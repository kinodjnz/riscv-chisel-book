package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import ZeroBranchPredictionConsts._

object ZeroBranchPredictionConsts {
  val ZBTB_TAG_BITS    = 8
  val ZBTB_TARGET_BITS = PC_LEN
}

class ZBTBLookup extends Bundle {
  val pc        = Output(UInt(PC_LEN.W))
  val matches0  = Input(Bool())
  val target0   = Input(UInt(ZBTB_TARGET_BITS.W))
  val matches1  = Input(Bool())
  val target1   = Input(UInt(ZBTB_TARGET_BITS.W))
}

class ZBTBUpdate extends Bundle {
  val en     = Output(Bool())
  val pc     = Output(UInt(PC_LEN.W))
  val target = Output(UInt(ZBTB_TARGET_BITS.W))
}

class ZBTBInvalidate extends Bundle {
  val en     = Output(Bool())
  val pc     = Output(UInt(PC_LEN.W))
}

class ZeroBranchTargetBuffer extends Bundle {
  val en     = Bool()
  val tag    = UInt(ZBTB_TAG_BITS.W)
  val target = UInt(ZBTB_TARGET_BITS.W)
}

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

class ZBTB(zbtb_entries: Int) extends Module {
  val index_bits = log2Ceil(zbtb_entries)
  val pc_bits    = index_bits + ZBTB_TAG_BITS

  val io = IO(new Bundle {
    val lu = Flipped(new ZBTBLookup)
    val up = Flipped(new ZBTBUpdate)
    val inv = Flipped(new ZBTBInvalidate)
  })

  val zbtb0 = Mem(zbtb_entries / 2, new ZeroBranchTargetBuffer())
  val zbtb1 = Mem(zbtb_entries / 2, new ZeroBranchTargetBuffer())

  val zbtb_entry0 = zbtb0(io.lu.pc(index_bits - 1, 1))
  val zbtb_entry1 = zbtb1(io.lu.pc(index_bits - 1, 1))

  val matches0 = zbtb_entry0.en && (zbtb_entry0.tag === io.lu.pc(ZBTB_TAG_BITS - 1 + index_bits, index_bits))
  val target0  = zbtb_entry0.target
  val matches1 = zbtb_entry1.en && (zbtb_entry1.tag === io.lu.pc(ZBTB_TAG_BITS - 1 + index_bits, index_bits))
  val target1  = zbtb_entry1.target

  io.lu.matches0 := RegNext(matches0, false.B)
  io.lu.target0  := RegNext(target0, 0.U(PC_LEN.W))
  io.lu.matches1 := RegNext(matches1, false.B)
  io.lu.target1  := RegNext(target1, 0.U(PC_LEN.W))

  when (io.inv.en && !io.inv.pc(0)) {
    zbtb0(io.inv.pc(index_bits - 1, 1)).en := false.B
  }
  when (io.inv.en && io.inv.pc(0)) {
    zbtb1(io.inv.pc(index_bits - 1, 1)).en := false.B
  }

  val entry = Wire(new ZeroBranchTargetBuffer())
  entry.en     := true.B
  entry.tag    := io.up.pc(ZBTB_TAG_BITS - 1 + index_bits, index_bits)
  entry.target := io.up.target
  when (io.up.en && !io.up.pc(0)) {
    zbtb0(io.up.pc(index_bits - 1, 1)) := entry
    printf(cf"zbtb0(0x${Cat(io.up.pc, 0.U(1.W))}%x) := 0x${Cat(io.up.target, 0.U(1.W))}%x\n")
  }
  when (io.up.en && io.up.pc(0)) {
    zbtb1(io.up.pc(index_bits - 1, 1)) := entry
    printf(cf"zbtb1(0x${Cat(io.up.pc, 0.U(1.W))}%x) := 0x${Cat(io.up.target, 0.U(1.W))}%x\n")
  }
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

  // printf(cf"io.lu.pc         : 0x${Cat(io.lu.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.lu.cnt0       : 0x${io.lu.cnt0}%x\n")
  // printf(cf"io.lu.cnt1       : 0x${io.lu.cnt1}%x\n")
  // printf(cf"io.up.en         : ${io.up.en}\n")
  // printf(cf"io.up.pc         : 0x${Cat(io.up.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.up.cnt        : 0x${io.up.cnt}%x\n")
}
