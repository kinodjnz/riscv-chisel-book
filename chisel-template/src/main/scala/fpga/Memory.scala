package fpga

import chisel3._
import chisel3.util._
import DramConsts._
import common.Consts._
import java.io.FileInputStream
import scala.collection.mutable.ArrayBuffer
import chisel3.util.experimental.loadMemoryFromFile
import chisel3.experimental.ChiselEnum
import CacheConsts._

class ImemPortIo extends Bundle {
  val en = Input(Bool())
  val addr = Input(UInt(WORD_LEN.W))
  val inst = Output(UInt(WORD_LEN.W))
  val valid = Output(Bool())
}

class DmemPortIo extends Bundle {
  val raddr  = Input(UInt(WORD_LEN.W))
  val rdata  = Output(UInt(WORD_LEN.W))
  val ren    = Input(Bool())
  val rvalid = Output(Bool())
  // val rready = Output(Bool())

  val waddr  = Input(UInt(WORD_LEN.W))
  val wen    = Input(Bool())
  val wready = Output(Bool())
  val wstrb  = Input(UInt(4.W))
  val wdata  = Input(UInt(WORD_LEN.W))
}

class CachePort extends Bundle {
  val iinvalidate = Input(Bool())
  val ibusy       = Output(Bool())

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

object ICacheState extends ChiselEnum {
  val Ready = Value
  val Prelookup = Value
  val Lookup = Value
  val Read = Value
  val WaitingSnoop = Value
  val RespondSnoop = Value
  val WaitingRead = Value
  val Invalidate2 = Value
}

object DCacheState extends ChiselEnum {
  val Ready = Value
  val SnoopRead = Value
  val LookupForRead = Value
  val LookupForWrite = Value
  val RespondRead = Value
  val Read = Value
  val WaitingRead = Value
}

object CacheConsts {
  val CACHE_LINE_LEN = 256
  val CACHE_LINE_BITS = log2Ceil(CACHE_LINE_LEN/8)
  val ICACHE_LINES = 128
  val ICACHE_INDEX_BITS = log2Ceil(ICACHE_LINES)
  val ICACHE_TAG_BITS = WORD_LEN - 4 - ICACHE_INDEX_BITS - CACHE_LINE_BITS
  val DCACHE_LINES = 128
  val DCACHE_INDEX_BITS = log2Ceil(DCACHE_LINES)
  val DCACHE_TAG_BITS = WORD_LEN - 4 - DCACHE_INDEX_BITS - CACHE_LINE_BITS
  val DCACHE_LRU_BITS = 3
  val ICACHE_VALID_BUNDLE_BITS = 2
  val ICACHE_VALID_DATA_BITS = log2Ceil(ICACHE_VALID_BUNDLE_BITS)
  val ICACHE_VALID_ADDR_BITS = ICACHE_INDEX_BITS-ICACHE_VALID_DATA_BITS
  val ICACHE_INVALIDATE_ADDR_BITS = log2Ceil(ICACHE_VALID_BUNDLE_BITS)
  val ICACHE_INVALIDATE_DATA_BITS = ICACHE_INDEX_BITS-ICACHE_INVALIDATE_ADDR_BITS
}

class ICachePort extends Bundle {
  val ren   = Input(Bool())
  val wen   = Input(Bool())
  val raddr = Input(UInt((ICACHE_INDEX_BITS+CACHE_LINE_BITS-2).W))
  val rdata = Output(UInt(WORD_LEN.W))
  val waddr = Input(UInt(ICACHE_INDEX_BITS.W))
  val wdata = Input(UInt(CACHE_LINE_LEN.W))
}

class DCachePort extends Bundle {
  val en    = Input(Bool())
  val we    = Input(UInt((CACHE_LINE_LEN/8).W))
  val addr  = Input(UInt(DCACHE_INDEX_BITS.W))
  val wdata = Input(UInt(CACHE_LINE_LEN.W))
  val rdata = Output(UInt(CACHE_LINE_LEN.W))
}

class ICacheValidPort extends Bundle {
  val ren        = Input(Bool())
  val wen        = Input(Bool())
  val invalidate = Input(Bool())
  val addr       = Input(UInt(ICACHE_VALID_ADDR_BITS.W))
  val iaddr      = Input(UInt(ICACHE_INVALIDATE_ADDR_BITS.W))
  val rdata      = Output(UInt((1 << ICACHE_VALID_DATA_BITS).W))
  val wdata      = Input(UInt((1 << ICACHE_VALID_DATA_BITS).W))
  val idata      = Input(UInt((1 << ICACHE_INVALIDATE_DATA_BITS).W))
}

class LruBundle extends Bundle {
  val way_hot = UInt(1.W)
  val dirty1  = Bool()
  val dirty2  = Bool()
}

class ICacheAddrBundle extends Bundle {
  val tag      = UInt(ICACHE_TAG_BITS.W)
  val index    = UInt(ICACHE_INDEX_BITS.W)
  val line_off = UInt(CACHE_LINE_BITS.W)
}

class DCacheAddrBundle extends Bundle {
  val tag      = UInt(DCACHE_TAG_BITS.W)
  val index    = UInt(DCACHE_INDEX_BITS.W)
  val line_off = UInt(CACHE_LINE_BITS.W)
}

class LineBundle extends Bundle {
  val line_u = UInt((CACHE_LINE_LEN/2).W)
  val line_l = UInt((CACHE_LINE_LEN/2).W)
}

object CacheDataOrInst extends ChiselEnum {
  val Data = Value
  val Inst = Value
}

object DramState extends ChiselEnum {
  val Ready = Value
  val Write2 = Value
  val Read2 = Value
  val Read2AfterReceiving1 = Value
  val WaitingRead1 = Value
  val WaitingRead2 = Value
}

object DCacheSnoopStatus extends ChiselEnum {
  val Busy = Value
  val Found = Value
  val NotFound = Value
}

class Memory() extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val cache = new CachePort()
    // val dmem = new DmemPortIo()
    val dramPort = Flipped(new DramIo())
    val cache_array1 = Flipped(new DCachePort())
    val cache_array2 = Flipped(new DCachePort())
    val icache = Flipped(new ICachePort())
    val icache_valid = Flipped(new ICacheValidPort())
    val icache_state = Output(UInt(3.W))
    val dram_state = Output(UInt(3.W))
  })

  val dram_i_busy  = Wire(Bool())
  val dram_i_ren   = Wire(Bool())
  val dram_i_addr  = Wire(UInt((WORD_LEN-CACHE_LINE_BITS).W))
  val dram_i_rdata_valid = Wire(Bool())
  val dram_d_busy  = Wire(Bool())
  val dram_d_ren   = Wire(Bool())
  val dram_d_wen   = Wire(Bool())
  val dram_d_addr  = Wire(UInt((WORD_LEN-CACHE_LINE_BITS).W))
  val dram_d_wdata = Wire(UInt(CACHE_LINE_LEN.W))
  val dram_d_rdata_valid = Wire(Bool())
  val dram_rdata   = Wire(UInt(CACHE_LINE_LEN.W))
  val reg_dram_state = RegInit(DramState.Ready)
  val reg_dram_addr  = RegInit(0.U((WORD_LEN-CACHE_LINE_BITS).W))
  val reg_dram_wdata = RegInit(0.U((CACHE_LINE_LEN/2).W))
  val reg_dram_rdata = RegInit(0.U((CACHE_LINE_LEN/2).W))
  val reg_dram_di = RegInit(CacheDataOrInst.Inst)

  io.dramPort.ren := false.B
  io.dramPort.wen := false.B
  io.dramPort.addr := DontCare
  io.dramPort.wdata := DontCare
  io.dramPort.wmask := 0.U
  io.dramPort.user_busy := false.B

  dram_i_busy      := true.B
  dram_d_busy      := true.B
  dram_rdata       := DontCare
  dram_i_rdata_valid := false.B
  dram_d_rdata_valid := false.B
  switch (reg_dram_state) {
    is (DramState.Ready) {
      when (io.dramPort.init_calib_complete && !io.dramPort.busy) {
        dram_i_busy := false.B
        when (dram_i_ren) {
          io.dramPort.ren := true.B
          io.dramPort.addr := Cat(dram_i_addr, 0.U(4.W))
          reg_dram_addr := dram_i_addr
          reg_dram_di := CacheDataOrInst.Inst
          reg_dram_state := DramState.Read2
        }.otherwise {
          dram_d_busy := false.B
          when (dram_d_wen) {
            io.dramPort.wen := true.B
            io.dramPort.addr := Cat(dram_d_addr, 0.U(4.W))
            io.dramPort.wdata := dram_d_wdata.asTypeOf(new LineBundle()).line_l
            io.dramPort.wmask := 0.U
            reg_dram_addr := dram_d_addr
            reg_dram_wdata := dram_d_wdata.asTypeOf(new LineBundle()).line_u
            reg_dram_di := CacheDataOrInst.Data
            reg_dram_state := DramState.Write2
          }.elsewhen (dram_d_ren) {
            io.dramPort.ren := true.B
            io.dramPort.addr := Cat(dram_d_addr, 0.U(4.W))
            reg_dram_addr := dram_d_addr
            reg_dram_di := CacheDataOrInst.Data
            reg_dram_state := DramState.Read2
          }
        }
      }
    }
    is (DramState.Write2) {
      when (!io.dramPort.busy) {
        io.dramPort.wen := true.B
        io.dramPort.addr := Cat(reg_dram_addr, 8.U(4.W))
        io.dramPort.wdata := reg_dram_wdata
        io.dramPort.wmask := 0.U
        reg_dram_state := DramState.Ready
      }
    }
    is (DramState.Read2) {
      when (!io.dramPort.busy) {
        io.dramPort.ren := true.B
        io.dramPort.addr := Cat(reg_dram_addr, 8.U(4.W))
        when (io.dramPort.rdata_valid) {
          reg_dram_rdata := io.dramPort.rdata
          reg_dram_state := DramState.WaitingRead2
        }.otherwise {
          reg_dram_state := DramState.WaitingRead1
        }
      }.elsewhen (io.dramPort.rdata_valid) {
        reg_dram_rdata := io.dramPort.rdata
        reg_dram_state := DramState.Read2AfterReceiving1
      }
    }
    is (DramState.Read2AfterReceiving1) {
      when (!io.dramPort.busy) {
        io.dramPort.ren := true.B
        io.dramPort.addr := Cat(reg_dram_addr, 8.U(4.W))
        reg_dram_state := DramState.WaitingRead2
      }
    }
    is (DramState.WaitingRead1) {
      when (io.dramPort.rdata_valid) {
        reg_dram_rdata := io.dramPort.rdata
        reg_dram_state := DramState.WaitingRead2
      }
    }
    is (DramState.WaitingRead2) {
      when (io.dramPort.rdata_valid) {
        //dram_i_busy := (reg_dram_di =/= CacheDataOrInst.Inst)
        //dram_d_busy := (reg_dram_di =/= CacheDataOrInst.Data)
        dram_rdata := Cat(io.dramPort.rdata, reg_dram_rdata)
        dram_i_rdata_valid := (reg_dram_di === CacheDataOrInst.Inst)
        dram_d_rdata_valid := (reg_dram_di === CacheDataOrInst.Data)
        reg_dram_state := DramState.Ready
      }
    }
  }

  val i_tag_array = Mem(ICACHE_LINES, Vec(1, UInt(ICACHE_TAG_BITS.W)))

  val icache_state = RegInit(ICacheState.Ready)
  val i_reg_tag = RegInit(VecInit(0.U(ICACHE_TAG_BITS.W)))
  val i_reg_line = RegInit(0.U(CACHE_LINE_LEN.W))
  val i_reg_req_addr = RegInit(0.U.asTypeOf(new ICacheAddrBundle()))
  val i_reg_next_addr = RegInit(0.U.asTypeOf(new ICacheAddrBundle()))
  val i_reg_valid_rdata = RegInit(0.U((1 << ICACHE_VALID_DATA_BITS).W))
  val i_reg_cur_tag_index = RegInit(Fill(ICACHE_TAG_BITS+ICACHE_INDEX_BITS, 1.U(1.W)))
  val i_reg_addr_match = RegInit(false.B)

  val dcache_snoop_en = Wire(Bool())
  val dcache_snoop_addr = Wire(new DCacheAddrBundle())
  val dcache_snoop_status = Wire(DCacheSnoopStatus())
  val dcache_snoop_line = Wire(UInt(CACHE_LINE_LEN.W))

  io.imem.inst := "xdeadbeef".U
  io.imem.valid := false.B
  io.cache.ibusy := true.B
  i_reg_next_addr := io.imem.addr.asTypeOf(new ICacheAddrBundle())
  dcache_snoop_en := false.B
  dcache_snoop_addr := DontCare
  dram_i_ren := false.B
  dram_i_addr := DontCare
  io.icache.ren := false.B
  io.icache.wen := false.B
  io.icache.raddr := DontCare
  io.icache.waddr := DontCare
  io.icache.wdata := DontCare
  io.icache_valid.ren := false.B
  io.icache_valid.wen := false.B
  io.icache_valid.invalidate := false.B
  io.icache_valid.addr := DontCare
  io.icache_valid.iaddr := DontCare
  io.icache_valid.wdata := DontCare
  io.icache_valid.idata := DontCare

  switch (icache_state) {
    is (ICacheState.Ready) {
      io.cache.ibusy := false.B
      val req_addr = io.imem.addr.asTypeOf(new ICacheAddrBundle())
      i_reg_req_addr := req_addr
      when (io.cache.iinvalidate) {
        io.icache_valid.invalidate := true.B
        io.icache_valid.iaddr := 0.U(1.W)
        io.icache_valid.idata := 0.U((1 << ICACHE_INVALIDATE_DATA_BITS).W)
        icache_state := ICacheState.Invalidate2
      }.elsewhen (io.imem.en) {
        i_reg_tag := i_tag_array.read(req_addr.index)
        io.icache.ren := true.B
        io.icache.raddr := Cat(req_addr.index, req_addr.line_off(CACHE_LINE_BITS-1, 2))
        io.icache_valid.ren := true.B
        io.icache_valid.addr := req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
        when (i_reg_cur_tag_index === Cat(req_addr.tag, req_addr.index)) {
          icache_state := ICacheState.Lookup
        }.otherwise {
          icache_state := ICacheState.Prelookup
        }
      }
      i_reg_addr_match := true.B
    }
    is (ICacheState.Prelookup) {
      i_reg_valid_rdata := io.icache_valid.rdata
      val i_next_addr = io.imem.addr.asTypeOf(new ICacheAddrBundle())
      i_reg_addr_match := (i_reg_req_addr.tag(ICACHE_TAG_BITS-1, 0) === i_next_addr.tag(ICACHE_TAG_BITS-1, 0) &&
          i_reg_req_addr.index === i_next_addr.index &&
          i_reg_req_addr.line_off(CACHE_LINE_BITS-1, 2) === i_next_addr.line_off(CACHE_LINE_BITS-1, 2))
      when ((io.icache_valid.rdata >> i_reg_req_addr.index(ICACHE_INVALIDATE_ADDR_BITS-1, 0))(0).asBool && i_reg_tag(0) === i_reg_req_addr.tag) {
        io.icache.ren := true.B
        io.icache.raddr := Cat(i_reg_req_addr.index, i_reg_req_addr.line_off(CACHE_LINE_BITS-1, 2))
        i_reg_cur_tag_index := Cat(i_reg_req_addr.tag, i_reg_req_addr.index)
        icache_state := ICacheState.Lookup
      }.otherwise {
        icache_state := ICacheState.WaitingSnoop
      }
    }
    is (ICacheState.Lookup) {
      io.imem.inst := io.icache.rdata
      when (i_reg_addr_match) {
        io.imem.valid := true.B
      }
      io.cache.ibusy := false.B
      val req_addr = io.imem.addr.asTypeOf(new ICacheAddrBundle())
      i_reg_req_addr := req_addr
      i_reg_addr_match := true.B
      when (io.cache.iinvalidate) {
        io.icache_valid.invalidate := true.B
        io.icache_valid.iaddr := 0.U(1.W)
        io.icache_valid.idata := 0.U((1 << ICACHE_INVALIDATE_DATA_BITS).W)
        icache_state := ICacheState.Invalidate2
      }.elsewhen (io.imem.en) {
        i_reg_tag := i_tag_array.read(req_addr.index)
        io.icache.ren := true.B
        io.icache.raddr := Cat(req_addr.index, req_addr.line_off(CACHE_LINE_BITS-1, 2))
        io.icache_valid.ren := true.B
        io.icache_valid.addr := req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
        when (i_reg_cur_tag_index === Cat(req_addr.tag, req_addr.index)) {
          icache_state := ICacheState.Lookup
        }.otherwise {
          icache_state := ICacheState.Prelookup
        }
      }.otherwise {
        icache_state := ICacheState.Ready
      }
    }
    is (ICacheState.WaitingSnoop) {
      switch (dcache_snoop_status) {
        is (DCacheSnoopStatus.Busy) {
          dcache_snoop_en := true.B
          dcache_snoop_addr := i_reg_req_addr.asUInt.asTypeOf(new DCacheAddrBundle())
        }
        is (DCacheSnoopStatus.Found) {
          i_reg_line := dcache_snoop_line
          i_tag_array.write(i_reg_req_addr.index, VecInit(i_reg_req_addr.tag))
          io.icache.wen := true.B
          io.icache.waddr := i_reg_req_addr.index
          io.icache.wdata := dcache_snoop_line
          io.icache_valid.ren := true.B
          io.icache_valid.wen := true.B
          io.icache_valid.addr := i_reg_req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
          val icache_valid_wdata = (i_reg_valid_rdata | (1.U << i_reg_req_addr.index(ICACHE_VALID_DATA_BITS-1, 0)))((1 << ICACHE_VALID_DATA_BITS)-1, 0)
          io.icache_valid.wdata := icache_valid_wdata
          i_reg_cur_tag_index := Cat(i_reg_req_addr.tag, i_reg_req_addr.index)
          i_reg_valid_rdata := icache_valid_wdata
          icache_state := ICacheState.RespondSnoop
        }
        is (DCacheSnoopStatus.NotFound) {
          when (!dram_i_busy) {
            dram_i_ren := true.B
            dram_i_addr := Cat(i_reg_req_addr.tag(ICACHE_TAG_BITS-1, 0), i_reg_req_addr.index)
            icache_state := ICacheState.WaitingRead
          }.otherwise {
            icache_state := ICacheState.Read
          }
        }
      }
    }
    is (ICacheState.RespondSnoop) {
      io.imem.inst := (i_reg_line >> Cat(i_reg_next_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
      when (i_reg_req_addr.tag(ICACHE_TAG_BITS-1, 0) === i_reg_next_addr.tag(ICACHE_TAG_BITS-1, 0) &&
          i_reg_req_addr.index === i_reg_next_addr.index) {
        io.imem.valid := true.B
      }
      val req_addr = io.imem.addr.asTypeOf(new ICacheAddrBundle())
      i_reg_req_addr := req_addr
      i_reg_addr_match := true.B
      when (io.imem.en) {
        i_reg_tag := i_tag_array.read(req_addr.index)
        io.icache.ren := true.B
        io.icache.raddr := Cat(req_addr.index, req_addr.line_off(CACHE_LINE_BITS-1, 2))
        io.icache_valid.ren := true.B
        io.icache_valid.addr := req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
        when (i_reg_cur_tag_index === Cat(req_addr.tag, req_addr.index)) {
          icache_state := ICacheState.Lookup
        }.otherwise {
          icache_state := ICacheState.Prelookup
        }
      }.otherwise {
        icache_state := ICacheState.Ready
      }
    }
    is (ICacheState.Read) {
      when (!dram_i_busy) {
        dram_i_ren := true.B
        dram_i_addr := Cat(i_reg_req_addr.tag(ICACHE_TAG_BITS-1, 0), i_reg_req_addr.index)
        icache_state := ICacheState.WaitingRead
      }
    }
    is (ICacheState.WaitingRead) {
      when (dram_i_rdata_valid) {
        val line = dram_rdata
        io.imem.inst := (line >> Cat(i_reg_next_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        when (i_reg_req_addr.tag(ICACHE_TAG_BITS-1, 0) === i_reg_next_addr.tag(ICACHE_TAG_BITS-1, 0) &&
            i_reg_req_addr.index === i_reg_next_addr.index) {
          io.imem.valid := true.B
        }
        i_tag_array.write(i_reg_req_addr.index, VecInit(i_reg_req_addr.tag))
        io.icache.wen := true.B
        io.icache.waddr := i_reg_req_addr.index
        io.icache.wdata := line
        io.icache_valid.ren := true.B
        io.icache_valid.wen := true.B
        io.icache_valid.addr := i_reg_req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
        val icache_valid_wdata = (i_reg_valid_rdata | (1.U << i_reg_req_addr.index(ICACHE_VALID_DATA_BITS-1, 0)))((1 << ICACHE_VALID_DATA_BITS)-1, 0)
        io.icache_valid.wdata := icache_valid_wdata
        i_reg_cur_tag_index := Cat(i_reg_req_addr.tag, i_reg_req_addr.index)
        i_reg_valid_rdata := icache_valid_wdata
        icache_state := ICacheState.Ready
      }
    }
    is (ICacheState.Invalidate2) {
      io.cache.ibusy := true.B
      io.icache_valid.invalidate := true.B
      io.icache_valid.iaddr := 1.U(1.W)
      io.icache_valid.idata := 0.U((1 << ICACHE_INVALIDATE_DATA_BITS).W)
      i_reg_cur_tag_index := Fill(ICACHE_TAG_BITS+ICACHE_INDEX_BITS, 1.U(1.W))
      val req_addr = io.imem.addr.asTypeOf(new ICacheAddrBundle())
      i_reg_req_addr := req_addr
      i_reg_addr_match := true.B
      when (io.imem.en) {
        i_reg_tag := i_tag_array.read(req_addr.index)
        io.icache.ren := true.B
        io.icache.raddr := Cat(req_addr.index, req_addr.line_off(CACHE_LINE_BITS-1, 2))
        io.icache_valid.ren := true.B
        io.icache_valid.addr := req_addr.index(ICACHE_INDEX_BITS-1, ICACHE_INVALIDATE_ADDR_BITS)
        icache_state := ICacheState.Lookup
      }.otherwise {
        icache_state := ICacheState.Ready
      }
    }
  }

  val tag_array = Mem(DCACHE_LINES, Vec(2, UInt(DCACHE_TAG_BITS.W)))
  val lru_array = Mem(DCACHE_LINES, new LruBundle())

  val dcache_state = RegInit(DCacheState.Ready)
  val reg_tag = RegInit(VecInit(0.U(DCACHE_TAG_BITS.W), 0.U(DCACHE_TAG_BITS.W)))
  val reg_line1 = RegInit(0.U(CACHE_LINE_LEN.W))
  val reg_line2 = RegInit(0.U(CACHE_LINE_LEN.W))
  val reg_lru = RegInit(0.U.asTypeOf(new LruBundle()))
  val reg_req_addr = RegInit(0.U.asTypeOf(new DCacheAddrBundle()))
  val reg_wdata = RegInit(0.U(WORD_LEN.W))
  val reg_wstrb = RegInit(0.U(4.W))
  val reg_ren = RegInit(true.B)
  val reg_dcache_read = RegInit(false.B)
  val reg_read_word = RegInit(0.U(WORD_LEN.W))

  io.cache.rready := false.B
  io.cache.wready := false.B
  io.cache.rvalid := false.B
  io.cache.rdata  := DontCare
  dram_d_ren := false.B
  dram_d_wen := false.B
  dram_d_addr := DontCare
  dram_d_wdata := DontCare
  io.cache_array1.en    := false.B
  io.cache_array1.we    := DontCare
  io.cache_array1.addr  := DontCare
  io.cache_array1.wdata := DontCare
  io.cache_array2.en    := false.B
  io.cache_array2.we    := DontCare
  io.cache_array2.addr  := DontCare
  io.cache_array2.wdata := DontCare
  reg_dcache_read := false.B
  dcache_snoop_line := DontCare
  dcache_snoop_status := DCacheSnoopStatus.Busy

  def toArray(wdata: UInt, bytes: Int) = {
    VecInit((0 to bytes-1).map(i => wdata(8*(i+1)-1, 8*i)))
  }
  def extendToLine(wdata: UInt) = {
    Fill(CACHE_LINE_LEN - WORD_LEN, 0.U) ## wdata
  }
  def extendToLineMask(wstrb: UInt) = {
    Fill(CACHE_LINE_LEN/8 - 4, 0.U) ## wstrb
  }
  def shiftLineMask(wstrb: UInt, shift: UInt) = {
    (extendToLineMask(wstrb) << shift)(CACHE_LINE_LEN/8-1, 0)
  }

  switch (dcache_state) {
    is (DCacheState.Ready) {
      when (dcache_snoop_en) {
        val req_addr = dcache_snoop_addr
        reg_req_addr := req_addr
        reg_tag := tag_array.read(req_addr.index)
        io.cache_array1.en := true.B
        io.cache_array1.addr := req_addr.index
        io.cache_array1.we := 0.U
        io.cache_array2.en := true.B
        io.cache_array2.addr := req_addr.index
        io.cache_array2.we := 0.U
        dcache_state := DCacheState.SnoopRead
      }.otherwise {
        io.cache.rready := true.B
        io.cache.wready := true.B
        val req_addr = Mux(io.cache.ren, io.cache.raddr, io.cache.waddr).asTypeOf(new DCacheAddrBundle())
        reg_req_addr := req_addr
        reg_wdata := io.cache.wdata
        reg_wstrb := io.cache.wstrb
        reg_ren := io.cache.ren
        when (io.cache.ren || io.cache.wen) {
          reg_tag := tag_array.read(req_addr.index)
          io.cache_array1.en := true.B
          io.cache_array1.addr := req_addr.index
          io.cache_array1.we := 0.U
          io.cache_array2.en := true.B
          io.cache_array2.addr := req_addr.index
          io.cache_array2.we := 0.U
          reg_dcache_read := true.B
          reg_lru := lru_array.read(req_addr.index)
          when (io.cache.ren) {
            dcache_state := DCacheState.LookupForRead
          }.otherwise {
            dcache_state := DCacheState.LookupForWrite
          }
        }
      }
    }
    is (DCacheState.SnoopRead) {
      when (reg_tag(0) === reg_req_addr.tag) {
        dcache_snoop_line := io.cache_array1.rdata
        dcache_snoop_status := DCacheSnoopStatus.Found
      }.elsewhen (reg_tag(1) === reg_req_addr.tag) {
        dcache_snoop_line := io.cache_array2.rdata
        dcache_snoop_status := DCacheSnoopStatus.Found
      }.otherwise {
        dcache_snoop_status := DCacheSnoopStatus.NotFound
      }
      dcache_state := DCacheState.Ready
    }
    is (DCacheState.LookupForRead) {
      when (reg_dcache_read) {
        reg_line1 := io.cache_array1.rdata
        reg_line2 := io.cache_array2.rdata
      }
      val line1 = Mux(reg_dcache_read, io.cache_array1.rdata, reg_line1)
      val line2 = Mux(reg_dcache_read, io.cache_array2.rdata, reg_line2)
      when (reg_tag(0) === reg_req_addr.tag) {
        reg_read_word := (line1 >> Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        dcache_state := DCacheState.RespondRead
      }.elsewhen (reg_tag(1) === reg_req_addr.tag) {
        reg_read_word := (line2 >> Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        dcache_state := DCacheState.RespondRead
      }.elsewhen ((reg_lru.way_hot === 1.U && reg_lru.dirty1) || (reg_lru.way_hot === 0.U && reg_lru.dirty2)) {
        when (!dram_d_busy) {
          dram_d_wen := true.B
          when (reg_lru.way_hot === 1.U) {
            dram_d_addr := Cat(reg_tag(0)(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
            dram_d_wdata := line1
          }.otherwise {
            dram_d_addr := Cat(reg_tag(1)(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
            dram_d_wdata := line2
          }
          dcache_state := DCacheState.Read
        }
      }.otherwise {
        when (!dram_d_busy) {
          dram_d_ren := true.B
          dram_d_addr := Cat(reg_req_addr.tag(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
          dcache_state := DCacheState.WaitingRead
        }
      }
    }
    is (DCacheState.RespondRead) {
        io.cache.rready := false.B
        io.cache.wready := false.B
        io.cache.rvalid := true.B
        io.cache.rdata := reg_read_word
        dcache_state := DCacheState.Ready
    }
    is (DCacheState.LookupForWrite) {
      when (reg_dcache_read) {
        reg_line1 := io.cache_array1.rdata
        reg_line2 := io.cache_array2.rdata
      }
      val line1 = Mux(reg_dcache_read, io.cache_array1.rdata, reg_line1)
      val line2 = Mux(reg_dcache_read, io.cache_array2.rdata, reg_line2)
      when (reg_tag(0) === reg_req_addr.tag) {
        val wstrb = shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(2.W)))
        val wdata = (extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(CACHE_LINE_LEN-1, 0)
        io.cache_array1.en := true.B
        io.cache_array1.we := wstrb
        io.cache_array1.addr := reg_req_addr.index
        io.cache_array1.wdata := wdata
        lru_array.write(reg_req_addr.index, Cat(0.U, true.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
        dcache_state := DCacheState.Ready
      }.elsewhen (reg_tag(1) === reg_req_addr.tag) {
        val wstrb = shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(2.W)))
        val wdata = extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W))
        io.cache_array2.en := true.B
        io.cache_array2.we := wstrb
        io.cache_array2.addr := reg_req_addr.index
        io.cache_array2.wdata := wdata
        lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, true.B).asTypeOf(new LruBundle()))
        dcache_state := DCacheState.Ready
      }.elsewhen ((reg_lru.way_hot === 1.U && reg_lru.dirty1) || (reg_lru.way_hot === 0.U && reg_lru.dirty2)) {
        when (!dram_d_busy) {
          dram_d_wen := true.B
          when (reg_lru.way_hot === 1.U) {
            dram_d_addr := Cat(reg_tag(0)(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
            dram_d_wdata := line1
          }.otherwise {
            dram_d_addr := Cat(reg_tag(1)(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
            dram_d_wdata := line2
          }
          dcache_state := DCacheState.Read
        }
      }.otherwise {
        when (!dram_d_busy) {
          dram_d_ren := true.B
          dram_d_addr := Cat(reg_req_addr.tag(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
          dcache_state := DCacheState.WaitingRead
        }
      }
    }
    is (DCacheState.Read) {
      when (!dram_d_busy) {
        dram_d_ren := true.B
        dram_d_addr := Cat(reg_req_addr.tag(DCACHE_TAG_BITS-1, 0), reg_req_addr.index)
        dcache_state := DCacheState.WaitingRead
      }
    }
    is (DCacheState.WaitingRead) {
      when (dram_d_rdata_valid) {
        val line = dram_rdata
        io.cache.rready := false.B
        io.cache.wready := false.B
        io.cache.rdata := (line >> Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W)))(WORD_LEN-1, 0)
        when (reg_ren /*&& !io.cache.ren && io.cache.raddr === reg_req_addr.asUInt*/) {
          io.cache.rvalid := true.B
        }
        when (reg_lru.way_hot === 1.U && reg_ren) {
          tag_array.write(reg_req_addr.index, VecInit(reg_req_addr.tag, reg_tag(1)))
          io.cache_array1.en := true.B
          io.cache_array1.we := Fill(CACHE_LINE_LEN/8, 1.U(1.W))
          io.cache_array1.addr := reg_req_addr.index
          io.cache_array1.wdata := line
          lru_array.write(reg_req_addr.index, Cat(0.U, false.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
        }.elsewhen (reg_lru.way_hot === 0.U && reg_ren) {
          tag_array.write(reg_req_addr.index, VecInit(reg_tag(0), reg_req_addr.tag))
          io.cache_array2.en := true.B
          io.cache_array2.we := Fill(CACHE_LINE_LEN/8, 1.U(1.W))
          io.cache_array2.addr := reg_req_addr.index
          io.cache_array2.wdata := line
          lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, false.B).asTypeOf(new LruBundle()))
        }.otherwise {
          val wstrb = shiftLineMask(reg_wstrb, Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(2.W)))
          val wdata = extendToLine(reg_wdata) << Cat(reg_req_addr.line_off(CACHE_LINE_BITS-1, 2), 0.U(5.W))
          when (reg_lru.way_hot === 1.U) {
            tag_array.write(reg_req_addr.index, VecInit(reg_req_addr.tag, reg_tag(1)))
            io.cache_array1.en := true.B
            io.cache_array1.we := Fill(CACHE_LINE_LEN/8, 1.U(1.W))
            io.cache_array1.addr := reg_req_addr.index
            io.cache_array1.wdata := Cat((0 to CACHE_LINE_LEN/8-1).map(i => {
              Mux(wstrb(i), wdata(i*8+7, i*8), line(i*8+7, i*8))
            }).reverse)
            lru_array.write(reg_req_addr.index, Cat(0.U, true.B, reg_lru.dirty2).asTypeOf(new LruBundle()))
          }.otherwise {
            tag_array.write(reg_req_addr.index, VecInit(reg_tag(0), reg_req_addr.tag))
            io.cache_array2.en := true.B
            io.cache_array2.we := Fill(CACHE_LINE_LEN/8, 1.U(1.W))
            io.cache_array2.addr := reg_req_addr.index
            io.cache_array2.wdata := Cat((0 to CACHE_LINE_LEN/8-1).map(i => {
              Mux(wstrb(i), wdata(i*8+7, i*8), line(i*8+7, i*8))
            }).reverse)
            lru_array.write(reg_req_addr.index, Cat(1.U, reg_lru.dirty1, true.B).asTypeOf(new LruBundle()))
          }
        }
        dcache_state := DCacheState.Ready
      }
    }
  }

  io.icache_state := icache_state.asUInt
  io.dram_state := reg_dram_state.asUInt

  // printf(p"io.imem.en      : ${io.imem.en}\n")
  // printf(p"io.imem.addr    : 0x${Hexadecimal(io.imem.addr)}\n")
  // printf(p"io.imem.inst    : 0x${Hexadecimal(io.imem.inst)}\n")
  // printf(p"io.imem.valid   : ${io.imem.valid}\n")
  // printf(p"dcache_snoop_en     : ${dcache_snoop_en}\n")
  // printf(p"dcache_snoop_addr   : 0x${Hexadecimal(dcache_snoop_addr.asUInt)}\n")
  // printf(p"dcache_snoop_line   : 0x${Hexadecimal(dcache_snoop_line)}\n")
  // printf(p"dcache_snoop_status : ${dcache_snoop_status.asUInt}\n")
  // printf(p"io.cache.rready  : ${io.cache.rready}\n")
  // printf(p"io.cache.wready  : ${io.cache.wready}\n")
  // printf(p"io.cache.ren     : ${io.cache.ren}\n")
  // printf(p"io.cache.wen     : ${io.cache.wen}\n")
  // printf(p"io.cache.raddr   : 0x${Hexadecimal(io.cache.raddr)}\n")
  // printf(p"io.cache.waddr   : 0x${Hexadecimal(io.cache.waddr)}\n")
  // printf(p"reg_req_addr    : 0x${Hexadecimal(reg_req_addr.asUInt)}\n")
  // printf(p"reg_req_addr.tag: 0x${Hexadecimal(reg_req_addr.tag)}\n")
  // printf(p"reg_req_addr.ind: 0x${Hexadecimal(reg_req_addr.index)}\n")
  // printf(p"reg_req_addr.off: 0x${Hexadecimal(reg_req_addr.line_off)}\n")
  // printf(p"reg_tag(0)      : 0x${Hexadecimal(reg_tag(0))}\n")
  // printf(p"reg_tag(1)      : 0x${Hexadecimal(reg_tag(1))}\n")
  // printf(p"reg_lru         : 0x${Hexadecimal(reg_lru.asUInt)}\n")
  // //printf(p"reg_line1       : 0x${Hexadecimal(reg_line1)}\n")
  // //printf(p"reg_line2       : 0x${Hexadecimal(reg_line2)}\n")
  printf(p"icache_state    : ${icache_state.asUInt}\n")
  printf(p"dcache_state    : ${dcache_state.asUInt}\n")
  printf(p"reg_dram_state  : ${reg_dram_state.asUInt}\n")
}
