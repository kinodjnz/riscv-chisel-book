package fpga

import chisel3._
import chisel3.util._
import DramConsts._
import common.Consts._
import java.io.FileInputStream
import scala.collection.mutable.ArrayBuffer
import chisel3.util.experimental.loadMemoryFromFile
import chisel3.experimental.ChiselEnum
import DCacheConsts._

class ImemPortIo extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val inst = Output(UInt(WORD_LEN.W))
}

class DmemPortIo extends Bundle {
  val raddr  = Input(UInt(WORD_LEN.W))
  val rdata  = Output(UInt(WORD_LEN.W))
  val ren    = Input(Bool())
  val rvalid = Output(Bool())
  val rready = Output(Bool())

  val waddr  = Input(UInt(WORD_LEN.W))
  val wen    = Input(Bool())
  val wready = Output(Bool())
  val wstrb  = Input(UInt(4.W))
  val wdata  = Input(UInt(WORD_LEN.W))
}

object DCacheState extends ChiselEnum {
  val Ready = Value
  val LookupForRead = Value
  val LookupForWrite = Value
  val Flushing = Value
  val Read1 = Value
  val Read2 = Value
  val Read2AndWaiting = Value
  val WaitingRead1 = Value
  val WaitingRead2 = Value
}

object DCacheConsts {
  val DCACHE_LINE_LEN = 256
  val DCACHE_LINES = 4 * 32
  val DCACHE_LINE_BITS = log2Ceil(DCACHE_LINE_LEN/8)
  val DCACHE_INDEX_BITS = log2Ceil(DCACHE_LINES)
  val DCACHE_TAG_BITS = WORD_LEN - DCACHE_INDEX_BITS - DCACHE_LINE_BITS
  val DCACHE_LRU_BITS = 3
}

class LruBundle extends Bundle {
  val way_hot = UInt(1.W)
  val dirty1  = Bool()
  val dirty2  = Bool()
}

class DCacheAddrBundle extends Bundle {
  val tag      = UInt(DCACHE_TAG_BITS.W)
  val index    = UInt(DCACHE_INDEX_BITS.W)
  val line_off = UInt(DCACHE_LINE_BITS.W)
}

class LineBundle extends Bundle {
  val line_u = UInt((DCACHE_LINE_LEN/2).W)
  val line_l = UInt((DCACHE_LINE_LEN/2).W)
}

class Memory(dataMemoryPath: String = null, imemSizeInBytes: Int = 16384, dmemSizeInBytes: Int = 16384) extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val dmem = new DmemPortIo()
    val imemReadPort = new MemoryReadPort(imemSizeInBytes/4, UInt(32.W))
    val dramPort = Flipped(new DramIo())
  })

  io.imem.inst := io.imemReadPort.data
  io.imemReadPort.address := io.imem.addr(WORD_LEN-1, 2)
  io.imemReadPort.enable := true.B

  val tag_array = Mem(DCACHE_LINES, Vec(2, UInt(DCACHE_TAG_BITS.W)))
  val cache_array1 = Mem(DCACHE_LINES, Vec(DCACHE_LINE_LEN/8, UInt(8.W)))
  val cache_array2 = Mem(DCACHE_LINES, Vec(DCACHE_LINE_LEN/8, UInt(8.W)))
  val lru_array = Mem(DCACHE_LINES, new LruBundle())

  val dcache_state = RegInit(DCacheState.Ready)
  val reg_tag = RegInit(VecInit(0.U(DCACHE_TAG_BITS.W), 0.U(DCACHE_TAG_BITS.W)))
  val reg_line1 = RegInit(VecInit((0 to (DCACHE_LINE_LEN/8)-1).map(i => 0.U(8.W))))
  val reg_line2 = RegInit(VecInit((0 to (DCACHE_LINE_LEN/8)-1).map(i => 0.U(8.W))))
  val reg_lru = RegInit(0.U.asTypeOf(new LruBundle()))
  val reg_req_addr = RegInit(0.U.asTypeOf(new DCacheAddrBundle()))
  val reg_wdata = RegInit(0.U(WORD_LEN.W))
  val reg_wstrb = RegInit(0.U(4.W))
  val reg_ren = RegInit(true.B)

  io.dmem.rready := false.B
  io.dmem.wready := false.B
  io.dmem.rvalid := false.B
  io.dmem.rdata  := DontCare
  io.dramPort.ren := false.B
  io.dramPort.wen := false.B
  io.dramPort.addr := DontCare
  io.dramPort.wdata := DontCare
  io.dramPort.wmask := 0.U
  io.dramPort.user_busy := false.B

  def toArray(wdata: UInt, bytes: Int) = {
    VecInit((0 to bytes-1).map(i => wdata(8*(i+1)-1, 8*i)))
  }
  def extendToLine(wdata: UInt) = {
    Fill(DCACHE_LINE_LEN - WORD_LEN, 0.U) ## wdata
  }
  def extendToLineMask(wstrb: UInt) = {
    Fill(DCACHE_LINE_LEN/8 - 4, 0.U) ## wstrb
  }
  def shiftLineMask(wstrb: UInt, shift: UInt) = {
    (extendToLineMask(wstrb) << shift)(DCACHE_LINE_LEN/8-1, 0)
  }

  switch (dcache_state) {
    is (DCacheState.Ready) {
      io.dmem.rready := true.B
      io.dmem.wready := true.B
      val req_addr = Mux(io.dmem.ren, io.dmem.raddr, io.dmem.waddr).asTypeOf(new DCacheAddrBundle())
      reg_req_addr := req_addr
      reg_wdata := io.dmem.wdata
      reg_wstrb := io.dmem.wstrb
      reg_ren := io.dmem.ren
      when (io.dmem.ren || io.dmem.wen) {
        reg_tag := tag_array.read(req_addr.index)
        reg_line1 := cache_array1.read(req_addr.index)
        reg_line2 := cache_array2.read(req_addr.index)
        reg_lru := lru_array.read(req_addr.index)
        when (io.dmem.ren) {
          dcache_state := DCacheState.LookupForRead
        }.otherwise {
          dcache_state := DCacheState.LookupForWrite
        }
      }
    }
    is (DCacheState.LookupForRead) {
      when (reg_tag(0) === reg_req_addr.tag) {
        io.dmem.rready := true.B
        io.dmem.wready := false.B
        io.dmem.rvalid := true.B
        io.dmem.rdata := (Cat(reg_line1.reverse) >> Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        dcache_state := DCacheState.Ready
      }.elsewhen (reg_tag(1) === reg_req_addr.tag) {
        io.dmem.rready := true.B
        io.dmem.wready := false.B
        io.dmem.rvalid := true.B
        io.dmem.rdata := (Cat(reg_line2.reverse) >> Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        dcache_state := DCacheState.Ready
      }.elsewhen ((reg_lru.way_hot === 1.U && reg_lru.dirty1) || (reg_lru.way_hot === 0.U && reg_lru.dirty2)) {
        when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
          io.dramPort.ren := false.B
          io.dramPort.wen := true.B
          when (reg_lru.way_hot === 1.U) {
            io.dramPort.addr := Cat(reg_tag(0)(15, 0), reg_req_addr.index, 0.U(4.W))
            io.dramPort.wdata := reg_line1.asTypeOf(new LineBundle()).line_l
          }.otherwise {
            io.dramPort.addr := Cat(reg_tag(1)(15, 0), reg_req_addr.index, 0.U(4.W))
            io.dramPort.wdata := reg_line2.asTypeOf(new LineBundle()).line_l
          }
          io.dramPort.wmask := 0.U
          dcache_state := DCacheState.Flushing
        }
      }.otherwise {
        when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
          io.dramPort.ren := true.B
          io.dramPort.wen := false.B
          io.dramPort.addr := Cat(reg_req_addr.tag(15, 0), reg_req_addr.index, 0.U(4.W))
          dcache_state := DCacheState.Read2
        }
      }
    }
    is (DCacheState.LookupForWrite) {
      when (reg_tag(0) === reg_req_addr.tag) {
        cache_array1.write(
          reg_req_addr.index,
          toArray(extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W)), DCACHE_LINE_LEN/8),
          shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(2.W))).asBools
        )
        lru_array.write(reg_req_addr.index, Cat(0.U, true.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
        dcache_state := DCacheState.Ready
      }.elsewhen (reg_tag(1) === reg_req_addr.tag) {
        cache_array2.write(
          reg_req_addr.index,
          toArray(extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W)), DCACHE_LINE_LEN/8),
          shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(2.W))).asBools
        )
        lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, true.B).asTypeOf(new LruBundle()))
        dcache_state := DCacheState.Ready
      }.elsewhen ((reg_lru.way_hot === 1.U && reg_lru.dirty1) || (reg_lru.way_hot === 0.U && reg_lru.dirty2)) {
        when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
          io.dramPort.ren := false.B
          io.dramPort.wen := true.B
          when (reg_lru.way_hot === 1.U) {
            io.dramPort.addr := Cat(reg_tag(0)(15, 0), reg_req_addr.index, 0.U(4.W))
            io.dramPort.wdata := reg_line1.asTypeOf(new LineBundle()).line_l
          }.otherwise {
            io.dramPort.addr := Cat(reg_tag(1)(15, 0), reg_req_addr.index, 0.U(4.W))
            io.dramPort.wdata := reg_line2.asTypeOf(new LineBundle()).line_l
          }
          io.dramPort.wmask := 0.U
          dcache_state := DCacheState.Flushing
        }
      }.otherwise {
        when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
          io.dramPort.ren := true.B
          io.dramPort.wen := false.B
          io.dramPort.addr := Cat(reg_req_addr.tag(15, 0), reg_req_addr.index, 0.U(4.W))
          dcache_state := DCacheState.Read2
        }
      }
    }
    is (DCacheState.Flushing) {
      when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
        io.dramPort.ren := false.B
        io.dramPort.wen := true.B
        when (reg_lru.way_hot === 1.U) {
          io.dramPort.addr := Cat(reg_tag(0)(15, 0), reg_req_addr.index, 8.U(4.W))
          io.dramPort.wdata := reg_line1.asTypeOf(new LineBundle()).line_u
        }.otherwise {
          io.dramPort.addr := Cat(reg_tag(1)(15, 0), reg_req_addr.index, 8.U(4.W))
          io.dramPort.wdata := reg_line2.asTypeOf(new LineBundle()).line_u
        }
        io.dramPort.wmask := 0.U
        dcache_state := DCacheState.Read1
      }
    }
    is (DCacheState.Read1) {
      when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
        io.dramPort.ren := true.B
        io.dramPort.wen := false.B
        io.dramPort.addr := Cat(reg_req_addr.tag(15, 0), reg_req_addr.index, 0.U(4.W))
        dcache_state := DCacheState.Read2
      }
    }
    is (DCacheState.Read2) {
      when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
        io.dramPort.ren := true.B
        io.dramPort.wen := false.B
        io.dramPort.addr := Cat(reg_req_addr.tag(15, 0), reg_req_addr.index, 8.U(4.W))
        when (io.dramPort.rdata_valid) {
          val line = reg_line1.asTypeOf(new LineBundle())
          line.line_l := io.dramPort.rdata
          reg_line1 := toArray(line.asUInt, DCACHE_LINE_LEN/8)
          dcache_state := DCacheState.WaitingRead2
        }.otherwise {
          dcache_state := DCacheState.WaitingRead1
        }
      }.elsewhen (io.dramPort.rdata_valid) {
        val line = reg_line1.asTypeOf(new LineBundle())
        line.line_l := io.dramPort.rdata
        reg_line1 := toArray(line.asUInt, DCACHE_LINE_LEN/8)
        dcache_state := DCacheState.Read2
      }
    }
    is (DCacheState.Read2AndWaiting) {
      when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
        io.dramPort.ren := true.B
        io.dramPort.wen := false.B
        io.dramPort.addr := Cat(reg_req_addr.tag(15, 0), reg_req_addr.index, 8.U(4.W))
        dcache_state := DCacheState.WaitingRead2
      }
    }
    is (DCacheState.WaitingRead1) {
      when (io.dramPort.rdata_valid) {
        val line = reg_line1.asTypeOf(new LineBundle())
        line.line_l := io.dramPort.rdata
        reg_line1 := toArray(line.asUInt, DCACHE_LINE_LEN/8)
        dcache_state := DCacheState.WaitingRead2
      }
    }
    is (DCacheState.WaitingRead2) {
      when (io.dramPort.rdata_valid) {
        val line = reg_line1.asTypeOf(new LineBundle())
        line.line_u := io.dramPort.rdata
        io.dmem.rready := reg_ren
        io.dmem.wready := false.B
        when (reg_ren && io.dmem.ren && io.dmem.raddr === reg_req_addr.asUInt) {
          io.dmem.rvalid := true.B
          io.dmem.rdata := line.asUInt << Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W))
        }
        when (reg_lru.way_hot === 1.U && reg_ren) {
          tag_array.write(reg_req_addr.index, VecInit(reg_req_addr.tag, reg_tag(1)))
          cache_array1.write(reg_req_addr.index, toArray(line.asUInt, DCACHE_LINE_LEN/8))
          lru_array.write(reg_req_addr.index, Cat(0.U, false.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
        }.elsewhen (reg_lru.way_hot === 0.U && reg_ren) {
          tag_array.write(reg_req_addr.index, VecInit(reg_tag(0), reg_req_addr.tag))
          cache_array2.write(reg_req_addr.index, toArray(line.asUInt, DCACHE_LINE_LEN/8))
          lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, false.B).asTypeOf(new LruBundle()))
        }.otherwise {
          val wdata_a = toArray(extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(5.W)), DCACHE_LINE_LEN/8)
          val wstrb_a = shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(DCACHE_LINE_BITS-1, 2), 0.U(2.W))).asBools
          val line_a = toArray(line.asUInt, DCACHE_LINE_LEN/8)
          val wline = VecInit((0 to (DCACHE_LINE_LEN/8)-1).map(i => Mux(wstrb_a(i), wdata_a(i), line_a(i))))
          when (reg_lru.way_hot === 1.U) {
            tag_array.write(reg_req_addr.index, VecInit(reg_req_addr.tag, reg_tag(1)))
            //tag_array.write(reg_req_addr.index, VecInit(0xFFFFFL.U, 0xFFFFFL.U), Seq(true.B, false.B))
            cache_array1.write(reg_req_addr.index, wline)
            lru_array.write(reg_req_addr.index, Cat(0.U, true.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
          }.otherwise {
            tag_array.write(reg_req_addr.index, VecInit(reg_tag(0), reg_req_addr.tag))
            //tag_array.write(reg_req_addr.index, VecInit(0xFFFFFL.U, 0xFFFFFL.U), Seq(true.B, false.B))
            cache_array2.write(reg_req_addr.index, wline)
            lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, true.B).asTypeOf(new LruBundle()))
          }
        }
        dcache_state := DCacheState.Ready
      }
    }
  }

  printf(p"io.dmem.rready  : ${io.dmem.rready}\n")
  printf(p"io.dmem.wready  : ${io.dmem.wready}\n")
  printf(p"io.dmem.ren     : ${io.dmem.ren}\n")
  printf(p"io.dmem.wen     : ${io.dmem.wen}\n")
  printf(p"io.dmem.raddr   : 0x${Hexadecimal(io.dmem.raddr)}\n")
  printf(p"io.dmem.waddr   : 0x${Hexadecimal(io.dmem.waddr)}\n")
  printf(p"reg_req_addr    : 0x${Hexadecimal(reg_req_addr.asUInt)}\n")
  printf(p"reg_req_addr.tag: 0x${Hexadecimal(reg_req_addr.tag)}\n")
  printf(p"reg_req_addr.ind: 0x${Hexadecimal(reg_req_addr.index)}\n")
  printf(p"reg_req_addr.off: 0x${Hexadecimal(reg_req_addr.line_off)}\n")
  printf(p"reg_tag(0)      : 0x${Hexadecimal(reg_tag(0))}\n")
  printf(p"reg_tag(1)      : 0x${Hexadecimal(reg_tag(1))}\n")
  printf(p"reg_lru         : 0x${Hexadecimal(reg_lru.asUInt)}\n")
  printf(p"dcache_state    : ${dcache_state.asUInt}\n")
}
