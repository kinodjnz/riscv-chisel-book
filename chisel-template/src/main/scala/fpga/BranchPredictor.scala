package fpga

import chisel3._
import chisel3.util._
import common.Consts._

class BTBLookup extends Bundle {
  val pc        = Output(UInt(PC_LEN.W))
  val matches0  = Input(Bool())
  val taken_pc0 = Input(UInt(PC_LEN.W))
  val matches1  = Input(Bool())
  val taken_pc1 = Input(UInt(PC_LEN.W))
}

class BTBUpdate extends Bundle {
  val en       = Output(Bool())
  val pc       = Output(UInt(PC_LEN.W))
  val taken_pc = Output(UInt(PC_LEN.W))
}

class BTBBundle extends Bundle {
  val tag      = UInt(BTB_TAG_LEN.W)
  val taken_pc = UInt(PC_LEN.W)
}

class BTBPC extends Bundle {
  val tag   = UInt(BTB_TAG_LEN.W)
  val index = UInt((BTB_INDEX_BITS-1).W)
}

class PHTMemIo extends Bundle {
  val ren   = Input(Bool())
  val wen   = Input(Bool())
  val raddr = Input(UInt((PHT_INDEX_BITS-1).W))
  val rdata = Output(UInt(4.W))
  val waddr = Input(UInt(PHT_INDEX_BITS.W))
  val wdata = Input(UInt(2.W))
}

class PHTLookup extends Bundle {
  val pc   = Output(UInt(PC_LEN.W))
  val cnt0 = Input(UInt(2.W))
  val cnt1 = Input(UInt(2.W))
}

class PHTUpdate extends Bundle {
  val en  = Output(Bool())
  val pc  = Output(UInt(PC_LEN.W))
  val cnt = Output(UInt(2.W))
}

class BTB(btb_len: Int) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new BTBLookup)
    val up = Flipped(new BTBUpdate)
  })

  val btb0 = Mem(btb_len / 2, new BTBBundle())
  val btb1 = Mem(btb_len / 2, new BTBBundle())

  val reg_entry0 = RegInit(0.U.asTypeOf(new BTBBundle()))
  val reg_entry1 = RegInit(0.U.asTypeOf(new BTBBundle()))

  val lu_pc = (io.lu.pc(PC_LEN-1-BTB_TAG_IGNORE, 1)).asTypeOf(new BTBPC())
  val reg_lu_pc_tag = RegNext(lu_pc.tag, 0.U(BTB_TAG_LEN.W))

  reg_entry0 := btb0.read(lu_pc.index)
  reg_entry1 := btb1.read(lu_pc.index)

  io.lu.matches0  := (reg_entry0.tag === reg_lu_pc_tag)
  io.lu.taken_pc0 := reg_entry0.taken_pc
  io.lu.matches1  := (reg_entry1.tag === reg_lu_pc_tag)
  io.lu.taken_pc1 := reg_entry1.taken_pc

  val up_pc = (io.up.pc(PC_LEN-1-BTB_TAG_IGNORE, 1)).asTypeOf(new BTBPC())
  when (io.up.en && !io.up.pc(0)) {
    btb0.write(up_pc.index, Cat(up_pc.tag, io.up.taken_pc).asTypeOf(new BTBBundle()))
  }
  when (io.up.en && io.up.pc(0)) {
    btb1.write(up_pc.index, Cat(up_pc.tag, io.up.taken_pc).asTypeOf(new BTBBundle()))
  }
}

class PHT(pht_len: Int) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new PHTLookup)
    val up = Flipped(new PHTUpdate)
    val mem = Flipped(new PHTMemIo)
  })

  io.mem.ren   := true.B
  io.mem.raddr := io.lu.pc(PHT_INDEX_BITS-1, 1)
  val cnt = io.mem.rdata
  io.lu.cnt0 := cnt(1, 0)
  io.lu.cnt1 := cnt(3, 2)

  io.mem.wen   := io.up.en
  io.mem.waddr := io.up.pc(PHT_INDEX_BITS-1, 0)
  io.mem.wdata := io.up.cnt

  // printf(p"io.lu.pc         : 0x${Hexadecimal(Cat(io.lu.pc, 0.U(1.W)))}\n")
  // printf(p"io.lu.cnt0       : 0x${Hexadecimal(io.lu.cnt0)}\n")
  // printf(p"io.lu.cnt1       : 0x${Hexadecimal(io.lu.cnt1)}\n")
  // printf(p"io.up.en         : 0x${io.up.en}\n")
  // printf(p"io.up.pc         : 0x${Hexadecimal(Cat(io.up.pc, 0.U(1.W)))}\n")
  // printf(p"io.up.cnt        : 0x${Hexadecimal(io.up.cnt)}\n")
}
