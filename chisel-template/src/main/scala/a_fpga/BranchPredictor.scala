package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFile

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

class BranchPredictor(tableLen: Int, bpTagInitPath: String = null) extends Module {
  val io = IO(new Bundle {
    val lu = Flipped(new BPLookup)
    val up = Flipped(new BPUpdate)
  })

  // Lookup
  val bp_cache_hist = Mem(tableLen, UInt(BP_HIST_LEN.W))
  val bp_cache_tag  = Mem(tableLen, UInt(BP_TAG_LEN.W))
  val bp_cache_br   = Mem(tableLen, UInt(BP_BRANCH_LEN.W))
  if (bpTagInitPath != null ) {
    loadMemoryFromFile(bp_cache_tag, bpTagInitPath)
  }

  val bp_reg_rd_hist = RegInit(0.U(BP_HIST_LEN.W))
  val bp_reg_rd_tag  = RegInit(0.U(BP_TAG_LEN.W))
  val bp_reg_rd_br   = RegInit(0.U((BP_BRANCH_LEN.W)))
  val bp_reg_tag     = RegInit(0.U(BP_TAG_LEN.W))

  bp_reg_tag := io.lu.inst_pc(WORD_LEN-1, BP_INDEX_LEN+1)
  val bp_index = io.lu.inst_pc(BP_INDEX_LEN, 1)
  bp_reg_rd_hist := bp_cache_hist.read(bp_index)
  bp_reg_rd_tag := bp_cache_tag.read(bp_index)
  bp_reg_rd_br := bp_cache_br.read(bp_index)
  val bp_cache_do_br = bp_reg_rd_hist(BP_HIST_LEN-1, BP_HIST_LEN-1).asBool()
  io.lu.br_hit := bp_reg_tag === bp_reg_rd_tag
  io.lu.br_pos := bp_cache_do_br && io.lu.br_hit
  io.lu.br_addr := Mux(io.lu.br_pos, bp_reg_rd_br, DontCare)

  // Update
  val bp_reg_update_pos     = RegInit(false.B)
  val bp_reg_update_br_addr = RegInit(0.U(WORD_LEN.W))
  val bp_reg_update_rd_hist = RegInit(0.U(BP_HIST_LEN.W))
  val bp_reg_update_rd_tag  = RegInit(0.U(BP_TAG_LEN.W))
  val bp_reg_update_rd_br   = RegInit(0.U(BP_BRANCH_LEN.W))
  val bp_reg_update_write   = RegInit(false.B)
  val bp_reg_update_tag     = RegInit(0.U((BP_TAG_LEN).W))
  val bp_reg_update_index   = RegInit(0.U(BP_INDEX_LEN.W))
  bp_reg_update_write := io.up.update_en // TODO en/write競合
  bp_reg_update_pos := io.up.br_pos
  bp_reg_update_br_addr := io.up.br_addr

  bp_reg_update_tag := io.up.inst_pc(WORD_LEN-1, BP_INDEX_LEN+1)
  val bp_update_index = io.up.inst_pc(BP_INDEX_LEN, 1)
  bp_reg_update_index := bp_update_index
  val bp_update_hist = Mux(bp_reg_update_rd_tag === bp_reg_update_tag,
    MuxCase(0.U(BP_HIST_LEN.W), Seq(
      (bp_reg_update_pos && bp_reg_update_rd_hist === 3.U)  -> 3.U(BP_HIST_LEN.W),
      bp_reg_update_pos                                     -> (bp_reg_update_rd_hist + 1.U(BP_HIST_LEN.W)),
      (!bp_reg_update_pos && bp_reg_update_rd_hist === 0.U) -> 0.U(BP_HIST_LEN.W),
      !bp_reg_update_pos                                    -> (bp_reg_update_rd_hist - 1.U(BP_HIST_LEN.W)),
    )),
    Mux(bp_reg_update_pos, 2.U(BP_HIST_LEN.W), 1.U(BP_HIST_LEN.W)),
  )
  val bp_update_next_br_addr = Mux(bp_reg_update_pos, bp_reg_update_br_addr, bp_reg_update_rd_br)
  when(io.up.update_en) {
    bp_reg_update_rd_hist := bp_cache_hist.read(bp_update_index)
    bp_reg_update_rd_tag  := bp_cache_tag.read(bp_update_index)
    bp_reg_update_rd_br   := bp_cache_br.read(bp_update_index)
  }
  when(!io.up.update_en && bp_reg_update_write) {
    bp_cache_hist.write(bp_reg_update_index, bp_update_hist)
    bp_cache_tag.write(bp_reg_update_index, bp_reg_update_tag)
    bp_cache_br.write(bp_reg_update_index, bp_update_next_br_addr)
  }
}
