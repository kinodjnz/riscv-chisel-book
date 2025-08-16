package fpga

import chisel3._
import chisel3.util._
import common.UIntExtension._

class InstructionQueueEntry[Initial <: Data, Decoded <: Data](genInitial: Initial, genDecoded: Decoded) extends Bundle {
  val initial = genInitial
  val decoded = genDecoded
}

class InstructionQueueEnqueue[Initial <: Data](iq_id_len: Int, genInitial: Initial) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val ready   = Output(Bool())
  val en      = Input(Bool())
  val initial = Input(genInitial)
  val iq_id   = Output(UInt(iq_id_ptr_len.W))
}

class InstructionQueuePutDecoded[Decoded <: Data](iq_id_len: Int, genDecoded: Decoded) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val en      = Input(Bool())
  val iq_id   = Input(UInt(iq_id_ptr_len.W))
  val decoded = Input(genDecoded)
}

class InstructionQueueReadDecoded[Decoded <: Data](genDecoded: Decoded) extends Bundle {
  val valid   = Output(Bool())
  val decoded = Output(genDecoded)
}

class InstructionQueuePeekRange(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val first = Output(UInt(iq_id_ptr_len.W))
  val last  = Output(UInt(iq_id_ptr_len.W))
}

class InstructionQueueUpdatePeekPtr(iq_id_len: Int) extends Bundle {
   val iq_id_ptr_len = iq_id_len + 1

  val en  = Input(Bool())
  val ptr = Input(UInt(iq_id_ptr_len.W))
}

class InstructionQueuePutLsq[Lsq <: Data](genLsq: Lsq) extends Bundle {
  val en      = Input(Bool())
  val lsq     = Input(genLsq)
}

class InstructionQueueRobRange(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val first = Output(UInt(iq_id_ptr_len.W))
  val last  = Output(UInt(iq_id_ptr_len.W))
}

class InstructionQueueUpdateRobPtr(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val en  = Input(Bool())
  val ptr = Input(UInt(iq_id_ptr_len.W))
}

class InstructionQueueReadInitial[Initial <: Data](iq_id_len: Int, genInitial: Initial) extends Bundle {
  val iq_id   = Input(UInt(iq_id_len.W))
  val initial = Output(genInitial)
}

class InstructionQueueDequeue extends Bundle {
  val en  = Input(Bool())
}

class InstructionQueuePeek[Initial <: Data, Decoded <: Data, Lsq <: Data](
  iq_id_len: Int,
  genInitial: Initial,
  genDecoded: Decoded,
  genLsq: Lsq,
) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val iq_id   = Input(UInt(iq_id_ptr_len.W))
  val valid   = Output(Bool())
  val initial = Output(genInitial)
  val decoded = Output(genDecoded)
  val lsq     = Output(genLsq)
}

class InstructionQueue[Initial <: Data, Decoded <: Data, Lsq <: Data](
  iq_buffer_size: Int,
  genInitial: Initial,
  genDecoded: Decoded,
  genLsq: Lsq,
) extends Module {
  val iq_id_len = log2Ceil(iq_buffer_size)
  val iq_id_ptr_len = iq_id_len + 1

  val io = IO(new Bundle {
    val enq1    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    val enq2    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    val put1    = new InstructionQueuePutDecoded(iq_id_len, genDecoded)
    val put2    = new InstructionQueuePutDecoded(iq_id_len, genDecoded)
    val read1   = new InstructionQueueReadDecoded(genDecoded)
    val read2   = new InstructionQueueReadDecoded(genDecoded)
    val lsq1    = new InstructionQueuePutLsq(genLsq)
    val lsq2    = new InstructionQueuePutLsq(genLsq)
    val peek_range = new InstructionQueuePeekRange(iq_id_len)
    val upd_peek   = new InstructionQueueUpdatePeekPtr(iq_id_len)
    val peek1   = new InstructionQueuePeek(iq_id_len, genInitial, genDecoded, genLsq)
    val peek2   = new InstructionQueuePeek(iq_id_len, genInitial, genDecoded, genLsq)
    val rob_range = new InstructionQueueRobRange(iq_id_len)
    val upd_rob   = new InstructionQueueUpdateRobPtr(iq_id_len)
    val read1_init = new InstructionQueueReadInitial(iq_id_len, genInitial)
    val read2_init = new InstructionQueueReadInitial(iq_id_len, genInitial)
    val deq1    = new InstructionQueueDequeue
    val deq2    = new InstructionQueueDequeue
    val flush   = Input(Bool())
  })

  val iq_buf_initial_0 = Mem(iq_buffer_size/2, genInitial)
  val iq_buf_initial_1 = Mem(iq_buffer_size/2, genInitial)
  val iq_buf_decoded_0 = Mem(iq_buffer_size/2, genDecoded)
  val iq_buf_decoded_1 = Mem(iq_buffer_size/2, genDecoded)
  val iq_buf_lsq_0     = Mem(iq_buffer_size/2, genLsq)
  val iq_buf_lsq_1     = Mem(iq_buffer_size/2, genLsq)
  val enq         = RegInit(0.U(iq_id_ptr_len.W))
  val decoded_ptr = RegInit(0.U(iq_id_ptr_len.W))
  val lsq_ptr     = RegInit(0.U(iq_id_ptr_len.W))
  val peek_ptr    = RegInit(0.U(iq_id_ptr_len.W))
  val rob_ptr    = RegInit(0.U(iq_id_ptr_len.W))
  val deq         = RegInit(0.U(iq_id_ptr_len.W))

  def enqueue: Unit = {
    val space  = enq - deq
    val ready1 = !space(iq_id_len)
    val ready2 = ready1 && !space.take(iq_id_len).andR
    // val ready2 = ready1 && space =/= Fill(iq_id_len, 1.U(1.W))

    val enq2 = enq + 1.U
    io.enq1.ready := ready1
    io.enq1.iq_id := enq
    io.enq2.ready := ready2
    io.enq2.iq_id := enq2
    val addr0 = Mux(enq(0), enq2.take(iq_id_len), enq.take(iq_id_len)) >> 1
    val addr1 = Mux(enq(0), enq.take(iq_id_len), enq2.take(iq_id_len)) >> 1
    val data0 = Mux(enq(0), io.enq2.initial, io.enq1.initial)
    val data1 = Mux(enq(0), io.enq1.initial, io.enq2.initial)
    when (!enq(0) && ready1 || enq(0) && ready2) {
      iq_buf_initial_0(addr0) := data0
    }
    when (enq(0) && ready1 || !enq(0) && ready2) {
      iq_buf_initial_1(addr1) := data1
    }
    when (ready2 && io.enq2.en) {
      enq := enq + 2.U
    }.elsewhen (ready1 && io.enq1.en) {
      enq := enq + 1.U
    }
    when (io.flush) {
      enq := enq
    }
  }

  def put_decoded: Unit = {
    val addr0 = Mux(io.put1.iq_id(0), io.put2.iq_id.take(iq_id_len), io.put1.iq_id.take(iq_id_len)) >> 1
    val addr1 = Mux(io.put1.iq_id(0), io.put1.iq_id.take(iq_id_len), io.put2.iq_id.take(iq_id_len)) >> 1
    val data0 = Mux(io.put1.iq_id(0), io.put2.decoded, io.put1.decoded)
    val data1 = Mux(io.put1.iq_id(0), io.put1.decoded, io.put2.decoded)
    when (!io.put1.iq_id(0) && io.put1.en || io.put1.iq_id(0) && io.put2.en) {
      iq_buf_decoded_0(addr0) := data0
    }
    when (io.put1.iq_id(0) && io.put1.en || !io.put1.iq_id(0) && io.put2.en) {
      iq_buf_decoded_1(addr1) := data1
    }
    when (io.put1.en) {
      decoded_ptr := io.put1.iq_id + 1.U
    }
    when (io.put2.en) {
      decoded_ptr := io.put1.iq_id + 2.U
    }
  }

  def read_decoded: Unit = {
    val ncount = lsq_ptr - decoded_ptr
    val valid0 = ncount(iq_id_len)
    val valid1 = valid0 && !ncount.take(iq_id_len).andR
    val iq_id1 = lsq_ptr.take(iq_id_len)
    val iq_id2 = lsq_ptr.take(iq_id_len) + 1.U
    val addr0 = Mux(iq_id1(0), iq_id2, iq_id1) >> 1
    val addr1 = Mux(iq_id1(0), iq_id1, iq_id2) >> 1
    val data0 = iq_buf_decoded_0(addr0)
    val data1 = iq_buf_decoded_1(addr1)
    io.read1.valid   := valid0
    io.read2.valid   := valid1
    io.read1.decoded := Mux(iq_id1(0), data1, data0)
    io.read2.decoded := Mux(iq_id1(0), data0, data1)
  }

  def put_lsq: Unit = {
    val lsq_ptr0 = lsq_ptr.take(iq_id_len)
    val lsq_ptr1 = lsq_ptr.take(iq_id_len) + 1.U
    val addr0 = Mux(lsq_ptr0(0), lsq_ptr1, lsq_ptr0) >> 1
    val addr1 = Mux(lsq_ptr0(0), lsq_ptr0, lsq_ptr1) >> 1
    val data0 = Mux(lsq_ptr0(0), io.lsq2.lsq, io.lsq1.lsq)
    val data1 = Mux(lsq_ptr0(0), io.lsq1.lsq, io.lsq2.lsq)
    when (!lsq_ptr0(0) && io.lsq1.en || lsq_ptr0(0) && io.lsq2.en) {
      iq_buf_lsq_0(addr0) := data0
    }
    when (lsq_ptr0(0) && io.lsq1.en || !lsq_ptr0(0) && io.lsq2.en) {
      iq_buf_lsq_1(addr1) := data1
    }
    when (io.lsq1.en) {
      lsq_ptr := lsq_ptr + 1.U
    }
    when (io.lsq2.en) {
      lsq_ptr := lsq_ptr + 2.U
    }
  }

  def peek: Unit = {
    io.peek_range.first := peek_ptr
    io.peek_range.last  := lsq_ptr

    when (io.upd_peek.en) {
      peek_ptr := io.upd_peek.ptr
    }
    when (io.flush) {
      peek_ptr    := enq
      decoded_ptr := enq
      lsq_ptr     := enq
    }

    io.peek1.valid   := (io.peek1.iq_id - lsq_ptr)(iq_id_len)
    io.peek2.valid   := (io.peek2.iq_id - lsq_ptr)(iq_id_len)
    val initial0 = iq_buf_initial_0(Mux(io.peek1.iq_id(0), io.peek2.iq_id, io.peek1.iq_id).take(iq_id_len) >> 1)
    val initial1 = iq_buf_initial_1(Mux(io.peek1.iq_id(0), io.peek1.iq_id, io.peek2.iq_id).take(iq_id_len) >> 1)
    io.peek1.initial := Mux(io.peek1.iq_id(0), initial1, initial0)
    io.peek2.initial := Mux(io.peek1.iq_id(0), initial0, initial1)
    val decoded0 = iq_buf_decoded_0(Mux(io.peek1.iq_id(0), io.peek2.iq_id, io.peek1.iq_id).take(iq_id_len) >> 1)
    val decoded1 = iq_buf_decoded_1(Mux(io.peek1.iq_id(0), io.peek1.iq_id, io.peek2.iq_id).take(iq_id_len) >> 1)
    io.peek1.decoded := Mux(io.peek1.iq_id(0), decoded1, decoded0)
    io.peek2.decoded := Mux(io.peek1.iq_id(0), decoded0, decoded1)
    val lsq0 = iq_buf_lsq_0(Mux(io.peek1.iq_id(0), io.peek2.iq_id, io.peek1.iq_id).take(iq_id_len) >> 1)
    val lsq1 = iq_buf_lsq_1(Mux(io.peek1.iq_id(0), io.peek1.iq_id, io.peek2.iq_id).take(iq_id_len) >> 1)
    io.peek1.lsq := Mux(io.peek1.iq_id(0), lsq1, lsq0)
    io.peek2.lsq := Mux(io.peek1.iq_id(0), lsq0, lsq1)
  }

  def rob: Unit = {
    io.rob_range.first := rob_ptr
    io.rob_range.last  := deq

    when (io.upd_rob.en) {
      rob_ptr := io.upd_rob.ptr
    }
    when (io.flush) {
      rob_ptr := enq
    }

    val initial0 = iq_buf_initial_0(Mux(io.read1_init.iq_id(0), io.read2_init.iq_id, io.read1_init.iq_id) >> 1)
    val initial1 = iq_buf_initial_1(Mux(io.read1_init.iq_id(0), io.read1_init.iq_id, io.read2_init.iq_id) >> 1)
    io.read1_init.initial := Mux(io.read1_init.iq_id(0), initial1, initial0)
    io.read2_init.initial := Mux(io.read1_init.iq_id(0), initial0, initial1)
  }

  def dequeue: Unit = {
    when (io.deq1.en) {
      deq := deq + 1.U
    }
    when (io.deq2.en) {
      deq := deq + 2.U
    }
    when (io.flush) {
      deq := enq
    }
  }

  printf(cf"iq enq         = ${enq}\n")
  printf(cf"iq decoded_ptr = ${decoded_ptr}\n")
  printf(cf"iq lsq_ptr     = ${lsq_ptr}\n")
  printf(cf"iq peek_ptr    = ${peek_ptr}\n")
  printf(cf"iq rob_ptr     = ${rob_ptr}\n")
  printf(cf"iq deq         = ${deq}\n")

  enqueue
  put_decoded
  read_decoded
  put_lsq
  peek
  rob
  dequeue
}
