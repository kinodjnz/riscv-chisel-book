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

class InstructionQueuePutDecoded[Decoded <: Data, Rob <: Data](iq_id_len: Int, genDecoded: Decoded, genRob: Rob) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val en      = Input(Bool())
  val iq_id   = Input(UInt(iq_id_ptr_len.W))
  val decoded = Input(genDecoded)
  val rob     = Input(genRob)
}

class InstructionQueueReadDecoded[Decoded <: Data](genDecoded: Decoded) extends Bundle {
  val valid   = Output(Bool())
  val decoded = Output(genDecoded)
}

class InstructionQueuePeekRange(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val peek1 = Output(UInt(iq_id_ptr_len.W))
  val peek2 = Output(UInt(iq_id_ptr_len.W))
  val last  = Output(UInt(iq_id_len.W))
  val diff  = Output(UInt(iq_id_len.W))
}

class InstructionQueueUpdatePeekPtr(iq_id_len: Int) extends Bundle {
   val iq_id_ptr_len = iq_id_len + 1

  // val en  = Input(Bool())
  val peek1 = Input(UInt(iq_id_ptr_len.W))
  val peek2 = Input(UInt(iq_id_ptr_len.W))
}

class InstructionQueuePutLsq[Lsq <: Data](genLsq: Lsq) extends Bundle {
  val en      = Input(Bool())
  val lsq     = Input(genLsq)
}

class InstructionQueuePutPhysAddrs[PhysAddrs <: Data, WbPhysAddrs <: Data](genPhysAddrs: PhysAddrs, genWbPhysAddrs: WbPhysAddrs) extends Bundle {
  val en        = Input(Bool())
  val paddrs    = Input(genPhysAddrs)
  val wb_paddrs = Input(genWbPhysAddrs)
}

class InstructionQueueRobRange(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val first = Output(UInt(iq_id_ptr_len.W))
  val last  = Output(UInt(iq_id_ptr_len.W))
  val flush_rob_id = Output(UInt(iq_id_ptr_len.W))
}

class InstructionQueueUpdateRobPtr(iq_id_len: Int) extends Bundle {
  val iq_id_ptr_len = iq_id_len + 1

  val en  = Input(Bool())
  val ptr = Input(UInt(iq_id_ptr_len.W))
}

class InstructionQueueReadAll[Rob <: Data, WbPhysAddrs <: Data](iq_id_len: Int, genRob: Rob, genWbPhysAddrs: WbPhysAddrs) extends Bundle {
  val iq_id     = Input(UInt(iq_id_len.W))
  val rob       = Output(genRob)
  val wb_paddrs = Output(genWbPhysAddrs)
}

class InstructionQueueDequeue extends Bundle {
  val en  = Input(Bool())
}

class InstructionQueuePeek[Initial <: Data, Decoded <: Data, Lsq <: Data, PhysAddrs <: Data](
  genInitial: Initial,
  genDecoded: Decoded,
  genLsq: Lsq,
  genPhysAddrs: PhysAddrs,
) extends Bundle {
  val valid   = Output(Bool())
  val initial = Output(genInitial)
  val decoded = Output(genDecoded)
  val lsq     = Output(genLsq)
  val paddrs  = Output(genPhysAddrs)
}

class InstructionQueue[Initial <: Data, Decoded <: Data, Lsq <: Data, Rob <: Data, PhysAddrs <: Data, WbPhysAddrs <: Data](
  iq_buffer_size: Int,
  genInitial: Initial,
  genDecoded: Decoded,
  genLsq: Lsq,
  genRob: Rob,
  genPhysAddrs: PhysAddrs,
  genWbPhysAddrs: WbPhysAddrs,
) extends Module {
  val iq_id_len = log2Ceil(iq_buffer_size)
  val iq_id_ptr_len = iq_id_len + 1

  val io = IO(new Bundle {
    val enq1    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    val enq2    = new InstructionQueueEnqueue(iq_id_len, genInitial)
    val put1    = new InstructionQueuePutDecoded(iq_id_len, genDecoded, genRob)
    val put2    = new InstructionQueuePutDecoded(iq_id_len, genDecoded, genRob)
    val read1   = new InstructionQueueReadDecoded(genDecoded)
    val read2   = new InstructionQueueReadDecoded(genDecoded)
    val lsq1    = new InstructionQueuePutLsq(genLsq)
    val lsq2    = new InstructionQueuePutLsq(genLsq)
    val put_pa1 = new InstructionQueuePutPhysAddrs(genPhysAddrs, genWbPhysAddrs)
    val put_pa2 = new InstructionQueuePutPhysAddrs(genPhysAddrs, genWbPhysAddrs)
    val peek_range = new InstructionQueuePeekRange(iq_id_len)
    val upd_peek   = new InstructionQueueUpdatePeekPtr(iq_id_len)
    val peek1   = new InstructionQueuePeek(genInitial, genDecoded, genLsq, genPhysAddrs)
    val peek2   = new InstructionQueuePeek(genInitial, genDecoded, genLsq, genPhysAddrs)
    val rob_range = new InstructionQueueRobRange(iq_id_len)
    val upd_rob   = new InstructionQueueUpdateRobPtr(iq_id_len)
    val read1_all = new InstructionQueueReadAll(iq_id_len, genRob, genWbPhysAddrs)
    val read2_all = new InstructionQueueReadAll(iq_id_len, genRob, genWbPhysAddrs)
    val deq1    = new InstructionQueueDequeue
    val deq2    = new InstructionQueueDequeue
    val flush   = Input(Bool())
  })

  val iq_buf_initial_0   = Mem(iq_buffer_size/2, UInt(genInitial.getWidth.W))
  val iq_buf_initial_1   = Mem(iq_buffer_size/2, UInt(genInitial.getWidth.W))
  val iq_buf_decoded_0   = Mem(iq_buffer_size/2, genDecoded)
  val iq_buf_decoded_1   = Mem(iq_buffer_size/2, genDecoded)
  val iq_buf_lsq_0       = Mem(iq_buffer_size/2, genLsq)
  val iq_buf_lsq_1       = Mem(iq_buffer_size/2, genLsq)
  val iq_buf_rob_0       = Mem(iq_buffer_size/2, genRob)
  val iq_buf_rob_1       = Mem(iq_buffer_size/2, genRob)
  val iq_buf_paddrs_0    = Mem(iq_buffer_size/2, genPhysAddrs)
  val iq_buf_paddrs_1    = Mem(iq_buffer_size/2, genPhysAddrs)
  val iq_buf_wb_paddrs_0 = Mem(iq_buffer_size/2, genWbPhysAddrs)
  val iq_buf_wb_paddrs_1 = Mem(iq_buffer_size/2, genWbPhysAddrs)
  val enq         = RegInit(0.U(iq_id_ptr_len.W))
  val decoded_ptr = RegInit(0.U(iq_id_ptr_len.W))
  val lsq_ptr     = RegInit(0.U(iq_id_ptr_len.W))
  val peek1_ptr   = RegInit(0.U(iq_id_ptr_len.W))
  val peek2_ptr   = RegInit(0.U(iq_id_ptr_len.W))
  val rob_ptr     = RegInit(0.U(iq_id_ptr_len.W))
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
      iq_buf_initial_0(addr0) := data0.asTypeOf(UInt(genInitial.getWidth.W))
    }
    when (enq(0) && ready1 || !enq(0) && ready2) {
      iq_buf_initial_1(addr1) := data1.asTypeOf(UInt(genInitial.getWidth.W))
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
    val rob0  = Mux(io.put1.iq_id(0), io.put2.rob, io.put1.rob)
    val rob1  = Mux(io.put1.iq_id(0), io.put1.rob, io.put2.rob)
    when (!io.put1.iq_id(0) && io.put1.en || io.put1.iq_id(0) && io.put2.en) {
      iq_buf_decoded_0(addr0) := data0
      iq_buf_rob_0(addr0)     := rob0
    }
    when (io.put1.iq_id(0) && io.put1.en || !io.put1.iq_id(0) && io.put2.en) {
      iq_buf_decoded_1(addr1) := data1
      iq_buf_rob_1(addr1)     := rob1
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

    val pa_paddr0 = Mux(lsq_ptr0(0), io.put_pa2.paddrs, io.put_pa1.paddrs)
    val pa_paddr1 = Mux(lsq_ptr0(0), io.put_pa1.paddrs, io.put_pa2.paddrs)
    val pa_wb_paddr0 = Mux(lsq_ptr0(0), io.put_pa2.wb_paddrs, io.put_pa1.wb_paddrs)
    val pa_wb_paddr1 = Mux(lsq_ptr0(0), io.put_pa1.wb_paddrs, io.put_pa2.wb_paddrs)
    when (!lsq_ptr0(0) && io.put_pa1.en || lsq_ptr0(0) && io.put_pa2.en) {
      iq_buf_paddrs_0(addr0)    := pa_paddr0
      iq_buf_wb_paddrs_0(addr0) := pa_wb_paddr0
    }
    when (lsq_ptr0(0) && io.put_pa1.en || !lsq_ptr0(0) && io.put_pa2.en) {
      iq_buf_paddrs_1(addr1)    := pa_paddr1
      iq_buf_wb_paddrs_1(addr1) := pa_wb_paddr1
    }
  }

  def peek: Unit = {
    io.peek_range.peek1 := peek1_ptr
    io.peek_range.peek2 := peek2_ptr
    io.peek_range.last  := lsq_ptr
    io.peek_range.diff  := peek2_ptr.take(iq_id_len) - peek1_ptr.take(iq_id_len)

    peek1_ptr := io.upd_peek.peek1
    peek2_ptr := io.upd_peek.peek2

    when (io.flush) {
      peek1_ptr          := enq
      peek2_ptr          := enq + 1.U
      io.peek_range.diff := 1.U
      decoded_ptr        := enq
      lsq_ptr            := enq
    }

    val iq_buf_addr_1 = peek1_ptr.take(iq_id_len) >> 1
    val iq_buf_addr_2 = peek2_ptr.take(iq_id_len) >> 1
    io.peek1.valid   := (peek1_ptr - lsq_ptr)(iq_id_len)
    io.peek2.valid   := (peek2_ptr - lsq_ptr)(iq_id_len)
    val initial10 = iq_buf_initial_0(iq_buf_addr_1).asTypeOf(genInitial)
    val initial11 = iq_buf_initial_1(iq_buf_addr_1).asTypeOf(genInitial)
    val initial20 = iq_buf_initial_0(iq_buf_addr_2).asTypeOf(genInitial)
    val initial21 = iq_buf_initial_1(iq_buf_addr_2).asTypeOf(genInitial)
    io.peek1.initial := Mux(peek1_ptr(0), initial11, initial10)
    io.peek2.initial := Mux(peek2_ptr(0), initial21, initial20)
    val decoded10 = iq_buf_decoded_0(iq_buf_addr_1)
    val decoded11 = iq_buf_decoded_1(iq_buf_addr_1)
    val decoded20 = iq_buf_decoded_0(iq_buf_addr_2)
    val decoded21 = iq_buf_decoded_1(iq_buf_addr_2)
    io.peek1.decoded := Mux(peek1_ptr(0), decoded11, decoded10)
    io.peek2.decoded := Mux(peek2_ptr(0), decoded21, decoded20)
    val lsq10 = iq_buf_lsq_0(iq_buf_addr_1)
    val lsq11 = iq_buf_lsq_1(iq_buf_addr_1)
    val lsq20 = iq_buf_lsq_0(iq_buf_addr_2)
    val lsq21 = iq_buf_lsq_1(iq_buf_addr_2)
    io.peek1.lsq := Mux(peek1_ptr(0), lsq11, lsq10)
    io.peek2.lsq := Mux(peek2_ptr(0), lsq21, lsq20)
    val paddrs10 = iq_buf_paddrs_0(iq_buf_addr_1)
    val paddrs11 = iq_buf_paddrs_1(iq_buf_addr_1)
    val paddrs20 = iq_buf_paddrs_0(iq_buf_addr_2)
    val paddrs21 = iq_buf_paddrs_1(iq_buf_addr_2)
    io.peek1.paddrs := Mux(peek1_ptr(0), paddrs11, paddrs10)
    io.peek2.paddrs := Mux(peek2_ptr(0), paddrs21, paddrs20)
  }

  def rob: Unit = {
    io.rob_range.first := rob_ptr
    io.rob_range.last  := deq
    io.rob_range.flush_rob_id := enq

    when (io.upd_rob.en) {
      rob_ptr := io.upd_rob.ptr
    }
    when (io.flush) {
      rob_ptr := enq
    }

    val iq_buf_addr_0 = Mux(io.read1_all.iq_id(0), io.read2_all.iq_id, io.read1_all.iq_id) >> 1
    val iq_buf_addr_1 = Mux(io.read1_all.iq_id(0), io.read1_all.iq_id, io.read2_all.iq_id) >> 1
    val rob0 = iq_buf_rob_0(iq_buf_addr_0)
    val rob1 = iq_buf_rob_1(iq_buf_addr_1)
    io.read1_all.rob := Mux(io.read1_all.iq_id(0), rob1, rob0)
    io.read2_all.rob := Mux(io.read1_all.iq_id(0), rob0, rob1)
    val wb_paddrs0 = iq_buf_wb_paddrs_0(iq_buf_addr_0)
    val wb_paddrs1 = iq_buf_wb_paddrs_1(iq_buf_addr_1)
    io.read1_all.wb_paddrs := Mux(io.read1_all.iq_id(0), wb_paddrs1, wb_paddrs0)
    io.read2_all.wb_paddrs := Mux(io.read1_all.iq_id(0), wb_paddrs0, wb_paddrs1)
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
  printf(cf"iq peek1_ptr   = ${peek1_ptr}\n")
  printf(cf"iq peek2_ptr   = ${peek2_ptr}\n")
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
