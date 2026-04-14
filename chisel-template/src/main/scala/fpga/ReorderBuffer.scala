package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import common.UIntExtension._
import common.OptionExtension._

class ReorderBufferEnqueue(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en      = Input(Bool())
  val rob_id  = Input(UInt(rob_id_ptr_len.W))
  val inst_id = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
}

// class BranchUpdate extends Bundle {
//   val en       = Bool()
//   val pc       = UInt(PC_LEN.W)
//   val bp_entry = new BranchPredictionEntry()
//   val history  = UInt(pht_history_len.W)
//   val br_taken = Bool()
//   val attr     = UInt(BTB_ATTR_LEN.W)
//   val is_ret   = Bool()
// }

class BranchCorrection(pht_history_len: Int) extends Bundle {
  val en       = Bool()
  // val pc       = UInt(PC_LEN.W)
  // val bp_entry = new BranchPredictionEntry()
  val fp_entry = new FetchPredictionEntry(pht_history_len)
  val fp_hit   = Bool()
  val mispred  = Bool()
  // val br_taken = Bool()
  // val attr     = UInt(BTB_ATTR_LEN.W)
  // val is_ret   = Bool()
  val target   = UInt(PC_LEN.W)
  // val next_pc  = UInt(PC_LEN.W)
}

class ReorderBufferBranchUpdateEntry(rob_id_len: Int, pht_history_len: Int) extends Bundle {
  val latter_pc = UInt(PC_LEN.W)
  val bp_entry  = new BranchPredictionEntry()
  val history   = UInt(pht_history_len.W)
  val br_taken  = Bool()
  val attr      = UInt(BTB_ATTR_LEN.W)
  val is_ret    = Bool()
  val next_pc   = UInt(PC_LEN.W)
}

class ReorderBufferBranchUpdate(rob_id_len: Int, pht_history_len: Int) extends Bundle {
  val en     = Input(Bool())
  val rob_id = Input(UInt(rob_id_len.W))
  val entry  = Input(new ReorderBufferBranchUpdateEntry(rob_id_len, pht_history_len))
}

class ReorderBufferFinish(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en      = Input(Bool())
  val rob_id  = Input(UInt(rob_id_ptr_len.W))
  // val wb_addr = Option.when(enable_pipeline_probe)(Input(UInt(ADDR_LEN.W)))
  val wb_data = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
}

class ReorderBufferFinish2(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en       = Input(Bool())
  val rob_id   = Input(UInt(rob_id_ptr_len.W))
  // val wb_addr  = Option.when(enable_pipeline_probe)(Input(UInt(ADDR_LEN.W)))
  val wb_data  = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
  val csr_read = Option.when(enable_pipeline_probe)(Input(Bool()))
  val csr_addr = Option.when(enable_pipeline_probe)(Input(UInt(CSR_ADDR_LEN.W)))
  val csr_data = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
  val csr_is_ecall = Option.when(enable_pipeline_probe)(Input(Bool()))
}

class ReorderBufferRedirect(rob_id_len: Int, pht_history_len: Int) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en         = Input(Bool())
  val redir_en   = Input(Bool())
  val rob_id     = Input(UInt(rob_id_ptr_len.W))
  val target_pc  = Input(UInt(PC_LEN.W))
  val correction = Input(new BranchCorrection(pht_history_len))
}

class ReorderBufferRetire(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val valid    = Output(Bool())
  val rob_id   = Output(UInt(rob_id_ptr_len.W))
  val inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(INST_ID_LEN.W)))
  val wb_addr  = Option.when(enable_pipeline_probe)(Output(UInt(ADDR_LEN.W)))
  val wb_data  = Option.when(enable_pipeline_probe)(Output(UInt(WORD_LEN.W)))
  val csr_read = Option.when(enable_pipeline_probe)(Output(Bool()))
  val csr_addr = Option.when(enable_pipeline_probe)(Output(UInt(CSR_ADDR_LEN.W)))
  val csr_data = Option.when(enable_pipeline_probe)(Output(UInt(WORD_LEN.W)))
  val csr_is_ecall = Option.when(enable_pipeline_probe)(Bool())
}

class ReorderBufferEntry(rob_id_len: Int, pht_history_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val finished     = Bool()
  val redirect     = Bool()
  val bp_updated   = Bool()
  val bp_upd_entry = new ReorderBufferBranchUpdateEntry(rob_id_len, pht_history_len)
  val redir_target_pc = UInt(PC_LEN.W)
  val redir_correction = new BranchCorrection(pht_history_len)
  val inst_id  = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  // val wb_addr  = Option.when(enable_pipeline_probe)(UInt(ADDR_LEN.W))
  val wb_data  = Option.when(enable_pipeline_probe)(UInt(WORD_LEN.W))
  val csr_read = Option.when(enable_pipeline_probe)(Bool())
  val csr_addr = Option.when(enable_pipeline_probe)(UInt(CSR_ADDR_LEN.W))
  val csr_data = Option.when(enable_pipeline_probe)(UInt(WORD_LEN.W))
  val csr_is_ecall = Option.when(enable_pipeline_probe)(Bool())
}

class ReorderBuffer(start_address: BigInt, rob_entries: Int, pht_history_len: Int, enable_pipeline_probe: Boolean) extends Module {
  val rob_id_len = log2Ceil(rob_entries)
  val rob_id_ptr_len = rob_id_len + 1

  val io = IO(new Bundle {
    val enq1       = new ReorderBufferEnqueue(rob_id_len, enable_pipeline_probe)
    val enq2       = new ReorderBufferEnqueue(rob_id_len, enable_pipeline_probe)
    val bp_upd     = new ReorderBufferBranchUpdate(rob_id_len, pht_history_len)
    val fin1       = new ReorderBufferFinish(rob_id_len, enable_pipeline_probe)
    val fin2       = new ReorderBufferFinish2(rob_id_len, enable_pipeline_probe)
    val fin3       = new ReorderBufferFinish(rob_id_len, enable_pipeline_probe)
    val redir      = new ReorderBufferRedirect(rob_id_len, pht_history_len)
    val retire1    = new ReorderBufferRetire(rob_id_len, enable_pipeline_probe)
    val retire2    = new ReorderBufferRetire(rob_id_len, enable_pipeline_probe)
    val iq_rob_range = Flipped(new InstructionQueueRobRange(rob_id_len))
    val iq_upd_rob = Flipped(new InstructionQueueUpdateRobPtr(rob_id_len))
    val iq_read1   = Flipped(new InstructionQueueRobRead(rob_id_len, enable_pipeline_probe))
    val iq_read2   = Flipped(new InstructionQueueRobRead(rob_id_len, enable_pipeline_probe))
    val iq_deq1    = Flipped(new InstructionQueueDequeue)
    val iq_deq2    = Flipped(new InstructionQueueDequeue)
    val rf_st1     = Flipped(new StabilizeRegisterAssignment)
    val rf_st2     = Flipped(new StabilizeRegisterAssignment)
    val rf_res     = Flipped(new ResetSpeculativeMapping)
    val flush      = Output(Bool())
    val target_pc  = Output(UInt(PC_LEN.W))
    val cr_out     = new BranchCorrection(pht_history_len)
    val upd_out    = Flipped(new BranchUpdatePort(pht_history_len))
  })

  val rob_buf    = Mem(rob_entries, new ReorderBufferEntry(rob_id_len, pht_history_len, enable_pipeline_probe))
  val flush      = Wire(Bool())
  // val redirected = RegInit(false.B)
  // val redir_ptr  = RegInit(0.U(rob_id_ptr_len.W))
  // val target_pc  = RegInit(0.U(PC_LEN.W))
  // val correction = RegInit(0.U.asTypeOf(new BranchCorrection(pht_history_len)))

  def enqueue: Unit = {
    io.iq_upd_rob.ptr := io.enq1.rob_id
    when (io.enq1.en) {
      rob_buf(io.enq1.rob_id.take(rob_id_len)).finished := false.B
      rob_buf(io.enq1.rob_id.take(rob_id_len)).redirect := false.B
      rob_buf(io.enq1.rob_id.take(rob_id_len)).bp_updated := false.B
      map2(rob_buf(io.enq1.rob_id.take(rob_id_len)).inst_id, io.enq1.inst_id)(_ := _)
      io.iq_upd_rob.ptr := io.enq1.rob_id + 1.U
      printf(cf"rob_buf(${io.enq1.rob_id.take(rob_id_len)}).bp_updated = 0\n")
    }
    when (io.enq2.en) {
      rob_buf(io.enq2.rob_id.take(rob_id_len)).finished := false.B
      rob_buf(io.enq2.rob_id.take(rob_id_len)).redirect := false.B
      rob_buf(io.enq2.rob_id.take(rob_id_len)).bp_updated := false.B
      map2(rob_buf(io.enq2.rob_id.take(rob_id_len)).inst_id, io.enq2.inst_id)(_ := _)
      io.iq_upd_rob.ptr := io.enq2.rob_id + 1.U
      printf(cf"rob_buf(${io.enq2.rob_id.take(rob_id_len)}).bp_updated = 0\n")
    }
    when (io.enq1.en || io.enq2.en) {
      when (io.enq2.en) {
        printf(cf"io.enq.rob_id=${io.enq2.rob_id}\n")
      }.otherwise {
        printf(cf"io.enq.rob_id=${io.enq1.rob_id}\n")
      }
    }
    io.iq_upd_rob.en := io.enq1.en || io.enq2.en
  }

  def finish: Unit = {
    when (io.fin1.en) {
      rob_buf(io.fin1.rob_id.take(rob_id_len)).finished := true.B
      // map2(rob_buf(io.fin1.rob_id.take(rob_id_len)).wb_addr, io.fin1.wb_addr)(_ := _)
      map2(rob_buf(io.fin1.rob_id.take(rob_id_len)).wb_data, io.fin1.wb_data)(_ := _)
      // printf(cf"io.fin1.wb_addr=${io.fin1.wb_addr.getOrElse(0)}\n")
      printf(cf"io.fin1.inst_id=${rob_buf(io.fin1.rob_id.take(rob_id_len)).inst_id.getOrElse(0)}\n")
    }
    when (io.fin2.en) {
      rob_buf(io.fin2.rob_id.take(rob_id_len)).finished := true.B
      // map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).wb_addr, io.fin2.wb_addr)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).wb_data, io.fin2.wb_data)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_read, io.fin2.csr_read)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_addr, io.fin2.csr_addr)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_data, io.fin2.csr_data)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_is_ecall, io.fin2.csr_is_ecall)(_ := _)
      // printf(cf"io.fin2.wb_addr=${io.fin2.wb_addr.getOrElse(0)}\n")
      printf(cf"io.fin2.inst_id=${rob_buf(io.fin2.rob_id.take(rob_id_len)).inst_id.getOrElse(0)}\n")
    }
    when (io.fin3.en) {
      rob_buf(io.fin3.rob_id.take(rob_id_len)).finished := true.B
      // map2(rob_buf(io.fin3.rob_id.take(rob_id_len)).wb_addr, io.fin3.wb_addr)(_ := _)
      map2(rob_buf(io.fin3.rob_id.take(rob_id_len)).wb_data, io.fin3.wb_data)(_ := _)
      // printf(cf"io.fin3.wb_addr=${io.fin3.wb_addr.getOrElse(0)}\n")
      printf(cf"io.fin3.inst_id=${rob_buf(io.fin3.rob_id.take(rob_id_len)).inst_id.getOrElse(0)}\n")
    }
    printf(cf"rob bp_upd.en = ${io.bp_upd.en}%d\n")
    when (io.redir.en) {
      rob_buf(io.bp_upd.rob_id).bp_upd_entry := io.bp_upd.entry
      rob_buf(io.bp_upd.rob_id).bp_updated   := io.bp_upd.en
      printf(cf"rob_buf(${io.bp_upd.rob_id}).bp_updated = 1\n")
      printf(cf"rob_buf(${io.bp_upd.rob_id}).bp_upd_entry.attr = ${io.bp_upd.entry.attr}%d\n")
      printf(cf"rob_buf(${io.bp_upd.rob_id}).bp_upd_entry.br_taken = ${io.bp_upd.entry.br_taken}%d\n")
      printf(cf"rob_buf(${io.bp_upd.rob_id}).bp_upd_entry.latter_pc := 0x${io.bp_upd.entry.latter_pc.pc_to_word}%x\n")
    }
    when (io.redir.en) {
      rob_buf(io.redir.rob_id.take(rob_id_len)).redirect         := io.redir.redir_en
      rob_buf(io.redir.rob_id.take(rob_id_len)).redir_target_pc  := io.redir.target_pc
      rob_buf(io.redir.rob_id.take(rob_id_len)).redir_correction := io.redir.correction
      // printf(cf"io.redir.rob_id=0x${io.redir.rob_id}%x\n")
    }
  }

  def retire: Unit = {
    val deq_ptr = io.iq_rob_range.last
    val ncount = deq_ptr - io.iq_rob_range.first
    val rob_id1 = deq_ptr.take(rob_id_len)
    val rob_id2 = deq_ptr.take(rob_id_len) + 1.U
    val valid1 = ncount(rob_id_len) && rob_buf(rob_id1).finished
    val valid2 = valid1 && !ncount.take(rob_id_len).andR && rob_buf(rob_id2).finished && !flush && !rob_buf(rob_id2).redirect && !rob_buf(rob_id2).bp_updated
    val bp_upd = rob_buf(rob_id1).bp_upd_entry

    io.iq_read1.iq_id   := rob_id1
    io.iq_read2.iq_id   := rob_id2
    io.rf_st1.en        := valid1 && (io.iq_read1.rf_wen === REN_S)
    io.rf_st1.addr      := io.iq_read1.wb_addr
    io.rf_st1.paddr     := io.iq_read1.paddrs.wb_paddr
    io.rf_st1.paddr_rel := io.iq_read1.paddrs.wb_paddr_rel
    io.rf_st2.en        := valid2 && (io.iq_read2.rf_wen === REN_S)
    io.rf_st2.addr      := io.iq_read2.wb_addr
    io.rf_st2.paddr     := io.iq_read2.paddrs.wb_paddr
    io.rf_st2.paddr_rel := io.iq_read2.paddrs.wb_paddr_rel
    io.rf_res.en        := RegNext(flush, true.B)

    flush                := /*valid1 && redirected && (redir_ptr.take(rob_id_len) === rob_id1)*/ valid1 && rob_buf(rob_id1).redirect
    io.flush             := RegNext(flush, true.B)
    io.target_pc         := RegNext(rob_buf(rob_id1).redir_target_pc, start_address.U(WORD_LEN.W).word_to_pc)
    io.cr_out            := rob_buf(rob_id1).redir_correction
    io.cr_out.en         := rob_buf(rob_id1).redir_correction.en && valid1
    io.upd_out.en        := rob_buf(rob_id1).bp_updated && valid1
    io.upd_out.latter_pc := bp_upd.latter_pc
    io.upd_out.bp_entry  := bp_upd.bp_entry
    io.upd_out.history   := bp_upd.history
    io.upd_out.br_taken  := bp_upd.br_taken
    io.upd_out.attr      := bp_upd.attr
    io.upd_out.is_ret    := bp_upd.is_ret
    io.upd_out.next_pc   := bp_upd.next_pc
    io.retire1.valid     := valid1
    io.retire1.rob_id    := rob_id1
    map2(io.retire1.inst_id, rob_buf(rob_id1).inst_id)(_ := _)
    // map2(io.retire1.wb_addr, rob_buf(rob_id1).wb_addr)(_ := _)
    io.retire1.wb_addr.map(_ := io.iq_read1.wb_addr)
    map2(io.retire1.wb_data, rob_buf(rob_id1).wb_data)(_ := _)
    map2(io.retire1.csr_read, rob_buf(rob_id1).csr_read)(_ := _)
    map2(io.retire1.csr_addr, rob_buf(rob_id1).csr_addr)(_ := _)
    map2(io.retire1.csr_data, rob_buf(rob_id1).csr_data)(_ := _)
    map2(io.retire1.csr_is_ecall, rob_buf(rob_id1).csr_is_ecall)(_ := _)
    io.retire2.valid    := valid2
    io.retire2.rob_id   := rob_id2
    map2(io.retire2.inst_id, rob_buf(rob_id2).inst_id)(_ := _)
    // map2(io.retire2.wb_addr, rob_buf(rob_id2).wb_addr)(_ := _)
    io.retire2.wb_addr.map(_ := io.iq_read2.wb_addr)
    map2(io.retire2.wb_data, rob_buf(rob_id2).wb_data)(_ := _)
    io.retire2.csr_read.map(_ := false.B)
    io.retire2.csr_addr.map(_ := 0.U)
    io.retire2.csr_data.map(_ := 0.U)
    io.retire2.csr_is_ecall.map(_ := false.B)
    io.iq_deq1.en       := valid1
    io.iq_deq2.en       := valid2
    // when (flush) {
    //   redirected := false.B
    // }
    printf(cf"io.iq_rob_range.first=0x${io.iq_rob_range.first}%x\n")
    printf(cf"io.iq_rob_range.last =0x${io.iq_rob_range.last}%x\n")
    printf(cf"rob_id1   : 0x${rob_id1}%x\n")
    printf(cf"rob_id2   : 0x${rob_id2}%x\n")
    printf(cf"finished1 : ${rob_buf(rob_id1).finished}\n")
    printf(cf"finished2 : ${rob_buf(rob_id2).finished}\n")
    printf(cf"valid1    : ${valid1}\n")
    printf(cf"valid2    : ${valid2}\n")
    printf(cf"inst_id1  : ${rob_buf(rob_id1).inst_id.getOrElse(0)}\n")
    printf(cf"inst_id2  : ${rob_buf(rob_id2).inst_id.getOrElse(0)}\n")
    printf(cf"latter_pc : 0x${bp_upd.latter_pc.pc_to_word}%x\n")
    printf(cf"upd_en    : ${rob_buf(rob_id1).bp_updated}\n")
    when (valid1 && (io.iq_read1.rf_wen === REN_S)) {
      printf(cf"x${io.iq_read1.wb_addr}%d{0x${io.iq_read1.paddrs.wb_paddr}%x} := 0x${rob_buf(rob_id1).wb_data.getOrElse(0)}%x ; rel {0x${io.iq_read1.paddrs.wb_paddr_rel}%x}\n")
    }
    when (valid2 && (io.iq_read2.rf_wen === REN_S)) {
      printf(cf"x${io.iq_read2.wb_addr}%d{0x${io.iq_read2.paddrs.wb_paddr}%x} := 0x${rob_buf(rob_id2).wb_data.getOrElse(0)}%x ; rel {0x${io.iq_read2.paddrs.wb_paddr_rel}%x}\n")
    }
    // printf(cf"redirected: ${redirected}\n")
    // printf(cf"redir_ptr : 0x${redir_ptr}%x\n")
    printf(cf"flush     : ${flush}\n")
    // printf(cf"target_pc : ${target_pc}\n")
  }

  enqueue
  finish
  retire
}
