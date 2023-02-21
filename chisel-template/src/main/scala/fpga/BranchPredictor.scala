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
  val pc   = Output(UInt(WORD_LEN.W))
  val cnt0 = Input(UInt(2.W))
  val cnt1 = Input(UInt(2.W))
}

class PHTUpdate extends Bundle {
  val en  = Output(Bool())
  val pc  = Output(UInt(WORD_LEN.W))
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

  reg_entry0 := btb0.read(lu_pc.index)
  reg_entry1 := btb1.read(lu_pc.index)

  io.lu.matches0  := (reg_entry0.tag === lu_pc.tag)
  io.lu.taken_pc0 := reg_entry0.taken_pc
  io.lu.matches1  := (reg_entry1.tag === lu_pc.tag)
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

  printf(p"io.lu.pc         : 0x${Hexadecimal(Cat(io.lu.pc, 0.U(1.W)))}\n")
  printf(p"io.lu.cnt0       : 0x${Hexadecimal(io.lu.cnt0)}\n")
  printf(p"io.lu.cnt1       : 0x${Hexadecimal(io.lu.cnt1)}\n")
  printf(p"io.up.en         : 0x${io.up.en}\n")
  printf(p"io.up.pc         : 0x${Hexadecimal(Cat(io.up.pc, 0.U(1.W)))}\n")
  printf(p"io.up.cnt        : 0x${Hexadecimal(io.up.cnt)}\n")
}

/*
class BPLookup extends Bundle {
  val inst_pc = Output(UInt(WORD_LEN.W))
  val br_hit  = Input(Bool())
  val br_pos  = Input(Bool())
  val br_addr = Input(UInt(WORD_LEN.W))
}

class BPUpdate extends Bundle {
  val update_en = Output(Bool())
  val inst_pc   = Output(UInt(WORD_LEN.W))
  val br_pos    = Output(Bool())
  val br_addr   = Output(UInt(WORD_LEN.W))
}

class BranchPredictor(tableLen: Int) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new BPLookup)
    val up = Flipped(new BPUpdate)
  })

  // Lookup
  val bp_cache = Mem(tableLen, UInt((BP_HIST_LEN + BP_TAG_LEN + BP_BRANCH_LEN).W))

  val bp_reg_rd      = RegInit(0.U((BP_HIST_LEN + BP_TAG_LEN + BP_BRANCH_LEN).W))
  val bp_reg_tag     = RegInit(0.U(BP_TAG_LEN.W))

  bp_reg_tag := io.lu.inst_pc(WORD_LEN-1, BP_INDEX_LEN+1)
  val bp_index = io.lu.inst_pc(BP_INDEX_LEN, 1)
  bp_reg_rd := bp_cache.read(bp_index)
  val bp_rd_hist = bp_reg_rd(BP_HIST_LEN + BP_TAG_LEN + BP_BRANCH_LEN - 1, BP_TAG_LEN + BP_BRANCH_LEN)
  val bp_rd_tag  = bp_reg_rd(BP_TAG_LEN + BP_BRANCH_LEN - 1, BP_BRANCH_LEN)
  val bp_rd_br   = bp_reg_rd(BP_BRANCH_LEN - 1, 0)
  val bp_cache_do_br = bp_rd_hist(BP_HIST_LEN-1, BP_HIST_LEN-1).asBool()
  io.lu.br_hit := bp_reg_tag === bp_rd_tag
  io.lu.br_pos := bp_cache_do_br && io.lu.br_hit
  io.lu.br_addr := Mux(io.lu.br_pos, bp_rd_br, DontCare)

  // Update
  val bp_reg_update_pos     = RegInit(false.B)
  val bp_reg_update_br_addr = RegInit(0.U(WORD_LEN.W))
  val bp_reg_update_rd      = RegInit(0.U((BP_HIST_LEN + BP_TAG_LEN + BP_BRANCH_LEN).W))
  val bp_reg_update_write   = RegInit(false.B)
  val bp_reg_update_tag     = RegInit(0.U((BP_TAG_LEN).W))
  val bp_reg_update_index   = RegInit(0.U(BP_INDEX_LEN.W))
  val bp_reg_write_en       = RegInit(false.B)
  val bp_reg_write_index    = RegInit(0.U(BP_INDEX_LEN.W))
  val bp_reg_write_hist     = RegInit(0.U(BP_HIST_LEN.W))
  val bp_reg_write_tag      = RegInit(0.U((BP_TAG_LEN).W))
  val bp_reg_write_br_addr  = RegInit(0.U(WORD_LEN.W))
  bp_reg_update_write := io.up.update_en // TODO en/write競合
  bp_reg_update_pos := io.up.br_pos
  bp_reg_update_br_addr := io.up.br_addr

  val bp_update_rd_hist = bp_reg_update_rd(BP_HIST_LEN + BP_TAG_LEN + BP_BRANCH_LEN - 1, BP_TAG_LEN + BP_BRANCH_LEN)
  val bp_update_rd_tag  = bp_reg_update_rd(BP_TAG_LEN + BP_BRANCH_LEN - 1, BP_BRANCH_LEN)
  val bp_update_rd_br   = bp_reg_update_rd(BP_BRANCH_LEN - 1, 0)

  bp_reg_update_tag := io.up.inst_pc(WORD_LEN-1, BP_INDEX_LEN+1)
  val bp_update_index = io.up.inst_pc(BP_INDEX_LEN, 1)
  bp_reg_update_index := bp_update_index
  val bp_update_hist = Mux(bp_update_rd_tag === bp_reg_update_tag,
    MuxCase(0.U(BP_HIST_LEN.W), Seq(
      (bp_reg_update_pos && bp_update_rd_hist === 3.U)  -> 3.U(BP_HIST_LEN.W),
      bp_reg_update_pos                                     -> (bp_update_rd_hist + 1.U(BP_HIST_LEN.W)),
      (!bp_reg_update_pos && bp_update_rd_hist === 0.U) -> 0.U(BP_HIST_LEN.W),
      !bp_reg_update_pos                                    -> (bp_update_rd_hist - 1.U(BP_HIST_LEN.W)),
    )),
    Mux(bp_reg_update_pos, 2.U(BP_HIST_LEN.W), 1.U(BP_HIST_LEN.W)),
  )
  val bp_update_next_br_addr = Mux(bp_reg_update_pos, bp_reg_update_br_addr, bp_update_rd_br)
  bp_reg_write_en      := bp_reg_update_write
  bp_reg_write_index   := bp_reg_update_index
  bp_reg_write_hist    := bp_update_hist
  bp_reg_write_tag     := bp_reg_update_tag
  bp_reg_write_br_addr := bp_update_next_br_addr
  val bp_update_rw_index = Mux(io.up.update_en, bp_update_index, bp_reg_write_index)
  when(io.up.update_en) {
    bp_reg_update_rd := bp_cache.read(bp_update_rw_index)
  }
  when(!io.up.update_en && bp_reg_write_en) {
    bp_cache.write(bp_update_rw_index, Cat(bp_reg_write_hist, bp_reg_write_tag, bp_reg_write_br_addr))
  }

  // printf(p"io.up.update_en         : 0x${Hexadecimal(io.up.update_en)}\n")
  // printf(p"io.up.inst_pc           : 0x${Hexadecimal(io.up.inst_pc)}\n")
  // printf(p"io.up.br_pos            : 0x${Hexadecimal(io.up.br_pos)}\n")
  // printf(p"io.up.br_addr           : 0x${Hexadecimal(io.up.br_addr)}\n")
  // printf(p"bp_reg_write_en         : 0x${Hexadecimal(bp_reg_write_en)}\n")
  // printf(p"bp_reg_write_index      : 0x${Hexadecimal(bp_reg_write_index)}\n")
  // printf(p"bp_reg_write_hist       : 0x${Hexadecimal(bp_reg_write_hist)}\n")
  // printf(p"bp_reg_write_tag        : 0x${Hexadecimal(bp_reg_write_tag)}\n")
  // printf(p"bp_reg_write_br_addr    : 0x${Hexadecimal(bp_reg_write_br_addr)}\n")
  // printf(p"bp_index                : 0x${Hexadecimal(bp_index)}\n")
  // printf(p"bp_reg_tag              : 0x${Hexadecimal(bp_reg_tag)}\n")
  // printf(p"bp_reg_rd_hist          : 0x${Hexadecimal(bp_reg_rd_hist)}\n")
  // printf(p"bp_reg_rd_tag           : 0x${Hexadecimal(bp_reg_rd_tag)}\n")
  // printf(p"bp_reg_rd_br            : 0x${Hexadecimal(bp_reg_rd_br)}\n")
}
*/
