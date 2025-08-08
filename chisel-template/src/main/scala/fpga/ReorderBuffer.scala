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

class ReorderBufferFinish(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en      = Input(Bool())
  val rob_id  = Input(UInt(rob_id_ptr_len.W))
  val wb_addr = Option.when(enable_pipeline_probe)(Input(UInt(ADDR_LEN.W)))
  val wb_data = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
}

class ReorderBufferFinishJB(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val en        = Input(Bool())
  val rob_id    = Input(UInt(rob_id_ptr_len.W))
  val wb_addr   = Option.when(enable_pipeline_probe)(Input(UInt(ADDR_LEN.W)))
  val wb_data   = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
  val csr_read  = Option.when(enable_pipeline_probe)(Input(Bool()))
  val csr_addr  = Option.when(enable_pipeline_probe)(Input(UInt(CSR_ADDR_LEN.W)))
  val csr_data  = Option.when(enable_pipeline_probe)(Input(UInt(WORD_LEN.W)))
  val redirect  = Input(Bool())
  val target_pc = Input(UInt(PC_LEN.W))
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
}

class ReorderBufferEntry(enable_pipeline_probe: Boolean) extends Bundle {
  val finished = Bool()
  val redirect = Bool()
  val inst_id  = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  val wb_addr  = Option.when(enable_pipeline_probe)(UInt(ADDR_LEN.W))
  val wb_data  = Option.when(enable_pipeline_probe)(UInt(WORD_LEN.W))
  val csr_read = Option.when(enable_pipeline_probe)(Bool())
  val csr_addr = Option.when(enable_pipeline_probe)(UInt(CSR_ADDR_LEN.W))
  val csr_data = Option.when(enable_pipeline_probe)(UInt(WORD_LEN.W))
}

class ReorderBuffer(start_address: BigInt, rob_entries: Int, enable_pipeline_probe: Boolean) extends Module {
  val rob_id_len = log2Ceil(rob_entries)
  val rob_id_ptr_len = rob_id_len + 1

  val io = IO(new Bundle {
    val enq1       = new ReorderBufferEnqueue(rob_id_len, enable_pipeline_probe)
    val enq2       = new ReorderBufferEnqueue(rob_id_len, enable_pipeline_probe)
    val fin1       = new ReorderBufferFinish(rob_id_len, enable_pipeline_probe)
    val fin2       = new ReorderBufferFinishJB(rob_id_len, enable_pipeline_probe)
    val fin3       = new ReorderBufferFinish(rob_id_len, enable_pipeline_probe)
    val retire1    = new ReorderBufferRetire(rob_id_len, enable_pipeline_probe)
    val retire2    = new ReorderBufferRetire(rob_id_len, enable_pipeline_probe)
    val iq_rob_range = Flipped(new InstructionQueueRobRange(rob_id_len))
    val iq_upd_rob = Flipped(new InstructionQueueUpdateRobPtr(rob_id_len))
    val iq_deq1    = Flipped(new InstructionQueueDequeue)
    val iq_deq2    = Flipped(new InstructionQueueDequeue)
    val flush      = Output(Bool())
    val target_pc  = Output(UInt(PC_LEN.W))
  })

  val rob_buf    = Mem(rob_entries, new ReorderBufferEntry(enable_pipeline_probe))
  val flush      = Wire(Bool())
  val redirected = RegInit(true.B)
  val redir_ptr  = RegInit(0.U(rob_id_ptr_len.W))
  val target_pc  = RegInit(start_address.U(WORD_LEN.W).word_to_pc)

  def enqueue: Unit = {
    io.iq_upd_rob.ptr := io.enq1.rob_id
    when (io.enq1.en) {
      rob_buf(io.enq1.rob_id.take(rob_id_len)).finished := false.B
      rob_buf(io.enq1.rob_id.take(rob_id_len)).redirect := false.B
      map2(rob_buf(io.enq1.rob_id.take(rob_id_len)).inst_id, io.enq1.inst_id)(_ := _)
      io.iq_upd_rob.ptr := io.enq1.rob_id + 1.U
    }
    when (io.enq2.en) {
      rob_buf(io.enq2.rob_id.take(rob_id_len)).finished := false.B
      rob_buf(io.enq2.rob_id.take(rob_id_len)).redirect := false.B
      map2(rob_buf(io.enq2.rob_id.take(rob_id_len)).inst_id, io.enq2.inst_id)(_ := _)
      io.iq_upd_rob.ptr := io.enq2.rob_id + 1.U
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
      map2(rob_buf(io.fin1.rob_id.take(rob_id_len)).wb_addr, io.fin1.wb_addr)(_ := _)
      map2(rob_buf(io.fin1.rob_id.take(rob_id_len)).wb_data, io.fin1.wb_data)(_ := _)
      printf(cf"io.fin1.wb_addr=${io.fin1.wb_addr.getOrElse(0)}\n")
      printf(cf"io.fin1.inst_id=${rob_buf(io.fin1.rob_id.take(rob_id_len)).inst_id.getOrElse(0)}\n")
    }
    when (io.fin2.en) {
      rob_buf(io.fin2.rob_id.take(rob_id_len)).finished := true.B
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).wb_addr, io.fin2.wb_addr)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).wb_data, io.fin2.wb_data)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_read, io.fin2.csr_read)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_addr, io.fin2.csr_addr)(_ := _)
      map2(rob_buf(io.fin2.rob_id.take(rob_id_len)).csr_data, io.fin2.csr_data)(_ := _)
      when (io.fin2.redirect) {
        rob_buf(io.fin2.rob_id.take(rob_id_len)).redirect := true.B
        redirected := true.B
      }
      when (io.fin2.redirect && (!redirected || (io.fin2.rob_id - redir_ptr)(rob_id_len))) {
        target_pc := io.fin2.target_pc
        redir_ptr := io.fin2.rob_id
      }
      printf(cf"io.fin2.wb_addr=${io.fin2.wb_addr.get}\n")
      printf(cf"io.fin2.inst_id=${rob_buf(io.fin2.rob_id.take(rob_id_len)).inst_id.get}\n")
    }
    when (io.fin3.en) {
      rob_buf(io.fin3.rob_id.take(rob_id_len)).finished := true.B
      map2(rob_buf(io.fin3.rob_id.take(rob_id_len)).wb_addr, io.fin3.wb_addr)(_ := _)
      map2(rob_buf(io.fin3.rob_id.take(rob_id_len)).wb_data, io.fin3.wb_data)(_ := _)
      printf(cf"io.fin3.wb_addr=${io.fin3.wb_addr.get}\n")
      printf(cf"io.fin3.inst_id=${rob_buf(io.fin3.rob_id.take(rob_id_len)).inst_id.get}\n")
    }
    printf(cf"io.fin2.redirect=${io.fin2.redirect}\n")
    printf(cf"io.fin2.rob_id=0x${io.fin2.rob_id}%x\n")
  }

  def retire: Unit = {
    val deq_ptr = io.iq_rob_range.last
    val ncount = deq_ptr - io.iq_rob_range.first
    val rob_id1 = deq_ptr.take(rob_id_len)
    val rob_id2 = deq_ptr.take(rob_id_len) + 1.U
    val valid1 = ncount(rob_id_len) && rob_buf(rob_id1).finished
    val valid2 = valid1 && !ncount.take(rob_id_len).andR && rob_buf(rob_id2).finished && !flush && !rob_buf(rob_id2).redirect
    flush              := redirected && (redir_ptr.take(rob_id_len) === rob_id1) // valid1 && rob_buf(rob_id1).redirect
    io.flush           := flush
    io.target_pc       := target_pc
    io.retire1.valid   := valid1
    io.retire1.rob_id  := rob_id1
    map2(io.retire1.inst_id, rob_buf(rob_id1).inst_id)(_ := _)
    map2(io.retire1.wb_addr, rob_buf(rob_id1).wb_addr)(_ := _)
    map2(io.retire1.wb_data, rob_buf(rob_id1).wb_data)(_ := _)
    map2(io.retire1.csr_read, rob_buf(rob_id1).csr_read)(_ := _)
    map2(io.retire1.csr_addr, rob_buf(rob_id1).csr_addr)(_ := _)
    map2(io.retire1.csr_data, rob_buf(rob_id1).csr_data)(_ := _)
    io.retire2.valid   := valid2
    io.retire2.rob_id  := rob_id2
    map2(io.retire2.inst_id, rob_buf(rob_id2).inst_id)(_ := _)
    map2(io.retire2.wb_addr, rob_buf(rob_id2).wb_addr)(_ := _)
    map2(io.retire2.wb_data, rob_buf(rob_id2).wb_data)(_ := _)
    io.retire2.csr_read.map(_ := false.B)
    io.retire2.csr_addr.map(_ := 0.U)
    io.retire2.csr_data.map(_ := 0.U)
    io.iq_deq1.en      := valid1
    io.iq_deq2.en      := valid2
    when (flush) {
      redirected := false.B
    }
    printf(cf"io.iq_rob_range.first=0x${io.iq_rob_range.first}%x\n")
    printf(cf"io.iq_rob_range.last =0x${io.iq_rob_range.last}%x\n")
    printf(cf"rob_id1   : 0x${rob_id1}%x\n")
    printf(cf"rob_id2   : 0x${rob_id2}%x\n")
    printf(cf"finished1 : ${rob_buf(rob_id1).finished}\n")
    printf(cf"finished2 : ${rob_buf(rob_id2).finished}\n")
    printf(cf"valid1    : ${valid1}\n")
    printf(cf"valid2    : ${valid2}\n")
    printf(cf"inst_id1  : ${rob_buf(rob_id1).inst_id.get}\n")
    printf(cf"inst_id2  : ${rob_buf(rob_id2).inst_id.get}\n")
    printf(cf"redurected: ${redirected}\n")
    printf(cf"redir_ptr : 0x${redir_ptr}%x\n")
    printf(cf"flush     : ${flush}\n")
    printf(cf"target_pc : ${target_pc}\n")
  }

  enqueue
  finish
  retire
}
