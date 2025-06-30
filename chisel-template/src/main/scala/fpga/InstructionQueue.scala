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

class InstructionQueueReadInitial[Initial <: Data](iq_id_len: Int, genInitial: Initial) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val iq_id   = Input(UInt(iq_id_ptr_len.W))
  val initial = Output(genInitial)
}

class InstructionQueueDequeueRange(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val deq_first = Output(UInt(iq_id_ptr_len.W))
  val deq_last  = Output(UInt(iq_id_ptr_len.W))
}

class InstructionQueueUpdateDequeuePtr(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val en  = Input(Bool())
  val deq = Input(UInt(iq_id_ptr_len.W))
}

class InstructionQueuePeek[Initial <: Data, Decoded <: Data](iq_id_len: Int, genInitial: Initial, genDecoded: Decoded) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val iq_id   = Input(UInt(iq_id_ptr_len.W))
  val valid   = Output(Bool())
  val initial = Output(genInitial)
  val decoded = Output(genDecoded)
}

class InstructionQueue[Initial <: Data, Decoded <: Data](iq_buffer_size: Int, genInitial: Initial, genDecoded: Decoded) extends Module {
  val iq_id_len = log2Ceil(iq_buffer_size)
  val iq_id_ptr_len = iq_id_len + 1

  val io = IO(new Bundle {
    val enq1    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    val enq2    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    // val read1   = new InstructionQueueReadInitial(iq_id_len, genInitial)
    val put1    = new InstructionQueuePutDecoded(iq_id_len, genDecoded)
    val put2    = new InstructionQueuePutDecoded(iq_id_len, genDecoded)
    val range   = new InstructionQueueDequeueRange(iq_id_len)
    val upd_deq = new InstructionQueueUpdateDequeuePtr(iq_id_len)
    val peek    = new InstructionQueuePeek(iq_id_len, genInitial, genDecoded)
    val flush   = Input(Bool())
  })

  val iq_buf_initial_0 = Mem(iq_buffer_size/2, genInitial)
  val iq_buf_initial_1 = Mem(iq_buffer_size/2, genInitial)
  val iq_buf_decoded_0 = Mem(iq_buffer_size/2, genDecoded)
  val iq_buf_decoded_1 = Mem(iq_buffer_size/2, genDecoded)
  val deq_first = RegInit(0.U(iq_id_ptr_len.W))
  val deq_last  = RegInit(0.U(iq_id_ptr_len.W))
  val enq       = RegInit(0.U(iq_id_ptr_len.W))

  def enqueue: Unit = {
    val space  = enq - deq_first
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

  // def read: Unit = {
  //   io.read1.initial := iq_buf(io.read1.iq_id.take(iq_id_len)).initial
  // }

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
      deq_last := io.put1.iq_id + 1.U
    }
    when (io.put2.en) {
      deq_last := io.put1.iq_id + 2.U
    }
  }

  def dequeue: Unit = {
    io.range.deq_first := deq_first
    io.range.deq_last  := deq_last

    when (io.upd_deq.en) {
      deq_first := io.upd_deq.deq
    }
    when (io.flush) {
      deq_first := enq
      deq_last := enq
    }

    io.peek.valid   := (io.peek.iq_id - deq_last)(iq_id_len)
    io.peek.initial := Mux(io.peek.iq_id(0),
      iq_buf_initial_1(io.peek.iq_id.take(iq_id_len) >> 1),
      iq_buf_initial_0(io.peek.iq_id.take(iq_id_len) >> 1),
    )
    io.peek.decoded := Mux(io.peek.iq_id(0),
      iq_buf_decoded_1(io.peek.iq_id.take(iq_id_len) >> 1),
      iq_buf_decoded_0(io.peek.iq_id.take(iq_id_len) >> 1),
    )
  }

  enqueue
  // read
  put_decoded
  dequeue
}
