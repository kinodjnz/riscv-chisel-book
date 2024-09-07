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
  val pc       = Output(UInt(PC_LEN.W))
  val jump0    = Input(Bool())
  val br0      = Input(Bool())
  val attr0    = Input(UInt(BTB_ATTR_LEN.W))
  val is_ret0  = Input(Bool())
  val target0  = Input(UInt(PC_LEN.W))
  val jump1    = Input(Bool())
  val br1      = Input(Bool())
  val attr1    = Input(UInt(BTB_ATTR_LEN.W))
  val is_ret1  = Input(Bool())
  val target1  = Input(UInt(PC_LEN.W))
}

class BTBUpdate extends Bundle {
  val en     = Output(Bool())
  val pc     = Output(UInt(PC_LEN.W))
  val attr   = Output(UInt(BTB_ATTR_LEN.W))
  val is_ret = Output(Bool())
  val target = Output(UInt(PC_LEN.W))
}

class BTBBundle extends Bundle {
  val tag    = UInt(BTB_TAG_LEN.W)
  val attr   = UInt(BTB_ATTR_LEN.W)
  val shared = UInt(1.W)
  val target = UInt((PC_LEN - 1).W)
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
  val en      = Output(Bool())
  val history = Output(UInt(PHT_HISTORY_BITS.W))
  val pc      = Output(UInt(PC_LEN.W))
  val cnt     = Output(UInt(2.W))
}

class PHTBranch extends Bundle {
  val en  = Output(Bool())
  val pc  = Output(UInt(PC_LEN.W))
}

class PHTBranch2 extends Bundle {
  val en      = Output(Bool())
  val history = Output(UInt(PHT_HISTORY_BITS.W))
  val pc      = Output(UInt(PC_LEN.W))
}

class PHTReset extends Bundle {
  val en      = Output(Bool())
  val history = Output(UInt(PHT_HISTORY_BITS.W))
}

class RASTop extends Bundle {
  val ret_pc = Input(UInt(PC_LEN.W))
  val index  = Input(UInt(RAS_INDEX_BITS.W))
}

class RASRet extends Bundle {
  val en    = Output(Bool())
  val index = Output(UInt(RAS_INDEX_BITS.W))
}

class RASCall extends Bundle {
  val en     = Output(Bool())
  val index  = Output(UInt(RAS_INDEX_BITS.W))
  val ret_pc = Output(UInt(PC_LEN.W))
}

class RASUpdate extends Bundle {
  val en    = Output(Bool())
  val index = Output(UInt(RAS_INDEX_BITS.W))
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
    printf(cf"zbtb0(0x${Cat(io.inv.pc, 0.U(1.W))}%x) inv\n")
  }
  when (io.inv.en && io.inv.pc(0)) {
    zbtb1(io.inv.pc(index_bits - 1, 1)).en := false.B
    printf(cf"zbtb1(0x${Cat(io.inv.pc, 1.U(1.W))}%x) inv\n")
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
    printf(cf"zbtb1(0x${Cat(io.up.pc, 1.U(1.W))}%x) := 0x${Cat(io.up.target, 0.U(1.W))}%x\n")
  }
}

class BTB(btb_len: Int) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new BTBLookup)
    val up = Flipped(new BTBUpdate)
  })

  val btb0 = Mem(btb_len / 2, UInt(BTB_BUNDLE_LEN.W))
  val btb1 = Mem(btb_len / 2, UInt(BTB_BUNDLE_LEN.W))

  val reg_entry0 = RegInit(0.U(BTB_BUNDLE_LEN.W))
  val reg_entry1 = RegInit(0.U(BTB_BUNDLE_LEN.W))

  val lu_pc = (io.lu.pc(PC_LEN-1-BTB_TAG_IGNORE, 1)).asTypeOf(new BTBPC())
  val reg_lu_pc_tag = RegNext(lu_pc.tag, 0.U(BTB_TAG_LEN.W))

  reg_entry0 := btb0.read(lu_pc.index)
  reg_entry1 := btb1.read(lu_pc.index)

  val entry0 = reg_entry0.asTypeOf(new BTBBundle())
  val entry1 = reg_entry1.asTypeOf(new BTBBundle())

  val tag_match0 = (entry0.tag === reg_lu_pc_tag)
  io.lu.jump0   := tag_match0 && (entry0.attr === BTB_ATTR_DJUMP || entry0.attr === BTB_ATTR_DCALL)
  io.lu.br0     := tag_match0 && (entry0.attr === BTB_ATTR_BR)
  io.lu.attr0   := Mux(tag_match0, entry0.attr, BTB_ATTR_INVAL)
  io.lu.is_ret0 := entry0.shared.asBool && (entry0.attr === BTB_ATTR_INVAL)
  io.lu.target0 := Cat(entry0.shared, entry0.target)
  val tag_match1 = (entry1.tag === reg_lu_pc_tag)
  io.lu.jump1   := tag_match1 && (entry1.attr === BTB_ATTR_DJUMP || entry1.attr === BTB_ATTR_DCALL)
  io.lu.br1     := tag_match1 && (entry1.attr === BTB_ATTR_BR)
  io.lu.attr1   := Mux(tag_match1, entry1.attr, BTB_ATTR_INVAL)
  io.lu.is_ret1 := entry1.shared.asBool && (entry1.attr === BTB_ATTR_INVAL)
  io.lu.target1 := Cat(entry1.shared, entry1.target)

  val up_pc = (io.up.pc(PC_LEN-1-BTB_TAG_IGNORE, 1)).asTypeOf(new BTBPC())
  val target = Cat(
    Mux(io.up.attr === BTB_ATTR_INVAL, io.up.is_ret, io.up.target(PC_LEN - 1)),
    io.up.target(PC_LEN - 2, 0)
  )
  when (io.up.en && !io.up.pc(0)) {
    btb0.write(up_pc.index, Cat(up_pc.tag, io.up.attr, target))
  }
  when (io.up.en && io.up.pc(0)) {
    btb1.write(up_pc.index, Cat(up_pc.tag, io.up.attr, target))
  }
}

class PHT(pht_len: Int) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new PHTLookup)
    val up = Flipped(new PHTUpdate)
    val mem = Flipped(new PHTMemIo)
    val br = Flipped(new PHTBranch)
    val br2 = Flipped(new PHTBranch2)
    val history = Output(UInt(PHT_HISTORY_BITS.W))
    val res = Flipped(new PHTReset)
  })

  val history = RegInit(0.U(PHT_HISTORY_BITS.W))

  def merge(history: UInt, pc: UInt): UInt = {
    ((Reverse(history) << (PHT_INDEX_BITS - PHT_HISTORY_BITS)) ^ pc)(PHT_INDEX_BITS-1, 0)
  }

  def hash(history: UInt, pc: UInt): UInt = {
    ((history << PHT_HISTORY_SHIFT) ^ pc)(PHT_HISTORY_BITS-1, 0)
  }

  io.mem.ren   := true.B
  io.mem.raddr := merge(history, io.lu.pc)(PHT_INDEX_BITS-1, 1)
  val cnt = io.mem.rdata
  io.lu.cnt0 := cnt(1, 0)
  io.lu.cnt1 := cnt(3, 2)

  io.history := RegNext(history, 0.U(PHT_HISTORY_BITS.W))

  when (io.br.en) {
    history := hash(history, io.br.pc)(PHT_HISTORY_BITS-1, 0)
    printf(cf"PHT br 0x${hash(history, io.br.pc)(PHT_HISTORY_BITS-1, 0)}%x\n")
  }

  when (io.res.en) {
    history := io.res.history
    printf(cf"PHT reset 0x${io.res.history}%x\n")
  }

  when (io.br2.en) {
    history := hash(io.br2.history, io.br2.pc)(PHT_HISTORY_BITS-1, 0)
    printf(cf"PHT br2 0x${hash(io.br2.history, io.br2.pc)(PHT_HISTORY_BITS-1, 0)}%x\n")
  }

  // history := 0.U

  io.mem.wen   := io.up.en
  io.mem.waddr := merge(io.up.history, io.up.pc)(PHT_INDEX_BITS-1, 0)
  io.mem.wdata := io.up.cnt

  // printf(cf"io.lu.pc         : 0x${Cat(io.lu.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.lu.cnt0       : 0x${io.lu.cnt0}%x\n")
  // printf(cf"io.lu.cnt1       : 0x${io.lu.cnt1}%x\n")
  // printf(cf"io.up.en         : ${io.up.en}\n")
  // printf(cf"io.up.pc         : 0x${Cat(io.up.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.up.cnt        : 0x${io.up.cnt}%x\n")
}

class RAS extends Module {
  val io = IO(new Bundle {
    val top   = Flipped(new RASTop)
    val ret1  = Flipped(new RASRet)
    val call1 = Flipped(new RASCall)
    val up    = Flipped(new RASUpdate)
    val ret2  = Flipped(new RASRet)
    val call2 = Flipped(new RASCall)
  })

  val ras   = Mem(RAS_ENTRIES, UInt(PC_LEN.W))
  val index = RegInit(0.U(RAS_INDEX_BITS.W))

  val ret_pc    = RegInit(0.U(PC_LEN.W))
  val ret_index = RegNext(index, 0.U(RAS_INDEX_BITS.W))

  ret_pc := ras(index)
  io.top.ret_pc := ret_pc
  io.top.index  := ret_index

  when (io.ret1.en) {
    index := io.ret1.index
    printf(cf"RAS ret1 index=${io.ret1.index} pc=0x${Cat(ras(index), 0.U(1.W))}%x\n")
  }

  when (io.call1.en) {
    index := io.call1.index
    ras(io.call1.index) := io.call1.ret_pc
    printf(cf"RAS call index=${io.call1.index} pc=0x${Cat(io.call1.ret_pc, 0.U(1.W))}%x\n")
  }

  when (io.up.en) {
    index := io.up.index
    printf(cf"RAS reset index=${io.up.index}\n")
  }

  when (io.ret2.en) {
    index := io.ret2.index
    printf(cf"RAS ret index=${io.ret2.index} pc=0x${Cat(ras(index), 0.U(1.W))}%x\n")
  }

  when (io.call2.en) {
    index := io.call2.index
    ras(io.call2.index) := io.call2.ret_pc
    printf(cf"RAS call index=${io.call2.index} pc=0x${Cat(io.call2.ret_pc, 0.U(1.W))}%x\n")
  }
}
