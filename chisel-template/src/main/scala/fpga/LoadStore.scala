package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import common.Consts._
import common.UIntExtension._
import common.OptionExtension._

class LoadStoreOutput(rob_id_len: Int, specul_id_len: Int) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val fw_en_next      = Output(Bool())
  val fw_wb_paddr     = Output(UInt(PHYS_ADDR_LEN.W))
  val fw_data         = Output(UInt(WORD_LEN.W))
  val wb_next         = Output(Bool())
  // val retire_next  = Output(Bool())
  val wb_en           = Output(Bool())
  val wb_nofw         = Output(Bool())
  val wb_paddr_next   = Output(UInt(PHYS_ADDR_LEN.W))
  val wb_paddr        = Output(UInt(PHYS_ADDR_LEN.W))
  val wb_data         = Output(UInt(WORD_LEN.W))
  val is_retired      = Output(Bool())
  val rob_id          = Output(UInt(rob_id_ptr_len.W))
  val is_specul_load  = Output(Bool())
  val load_order_fail = Output(Bool())
  val specul_id       = Output(UInt(specul_id_len.W))
}

class LoadStoreQueueEntry(rob_id_len: Int, lsq_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1
  val lsq_id_ptr_len = lsq_id_len + 1

  val addr          = UInt((WORD_LEN - 2).W)
  val wstrb         = UInt(7.W)
  val unaligned     = Bool()
  val memwl         = UInt(2.W)
  val is_mem_load   = Bool()
  val is_mem_store  = Bool()
  val is_dram_load  = Bool()
  val is_dram_store = Bool()
  val is_dram_fence = Bool()
  val data          = UInt(WORD_LEN.W)
  val rob_id        = UInt(rob_id_ptr_len.W)
  val lsq_id        = UInt(lsq_id_ptr_len.W)
  val inst_id       = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
}

class LoadData extends Bundle {
  val unsigned       = UInt(1.W)
  val aligned_lw     = UInt(1.W)
  val wb_byte_offset = UInt(2.W)
  val is_specul_load = Bool()
  val lstrb          = UInt(7.W)
  val unused         = UInt((WORD_LEN-PHYS_ADDR_LEN-12).W)
  val wb_paddr       = UInt(PHYS_ADDR_LEN.W)
}

class LoadStoreQueueFlush extends Bundle {
  val en       = Input(Bool())
  val preserve = Input(Bool())
}

class LoadStoreQueueAlloc(lsq_id_len: Int) extends Bundle {
  val lsq_id_ptr_len = lsq_id_len + 1

  val en     = Input(Bool())
  val valid  = Output(Bool())
  val lsq_id = Output(UInt(lsq_id_ptr_len.W))
}

class LoadStoreQueuePut(enable_pipeline_probe: Boolean, rob_id_len: Int, lsq_id_len: Int) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1
  val lsq_id_ptr_len = lsq_id_len + 1

  val en       = Input(Bool())
  val memop    = Input(UInt(MEM_OP_LEN.W))
  val addr     = Input(UInt(WORD_LEN.W))
  val memw     = Input(UInt(MW_LEN.W))
  val wdata    = Input(UInt(WORD_LEN.W))
  val wb_paddr = Input(UInt(PHYS_ADDR_LEN.W))
  val rob_id   = Input(UInt(rob_id_ptr_len.W))
  val lsq_id   = Input(UInt(lsq_id_ptr_len.W))
  val inst_id  = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
}

class LoadStoreQueuePutLoad(enable_pipeline_probe: Boolean, rob_id_len: Int, lsq_id_len: Int) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1
  val lsq_id_ptr_len = lsq_id_len + 1

  val en       = Input(Bool())
  val addr     = Input(UInt(WORD_LEN.W))
  val memw     = Input(UInt(MW_LEN.W))
  val wb_paddr = Input(UInt(PHYS_ADDR_LEN.W))
  val rob_id   = Input(UInt(rob_id_ptr_len.W))
  val lsq_id   = Input(UInt(lsq_id_ptr_len.W))
  val inst_id  = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
}

class LoadStoreDebugSignals extends Bundle {
  val mem3_rvalid = Output(Bool())
  val mem3_rdata  = Output(UInt(WORD_LEN.W))
}

class LoadStorePipelineProbe extends Bundle {
  val mem1_valid    = Output(Bool())
  val mem1_inst_id  = Output(UInt(INST_ID_LEN.W))
  val mem2_valid    = Output(Bool())
  val mem2_inst_id  = Output(UInt(INST_ID_LEN.W))
  val mem3_valid    = Output(Bool())
  val mem3_inst_id  = Output(UInt(INST_ID_LEN.W))
  // val mem3_retired = Output(Bool())
  // val mem3_wb_paddr = Output(UInt(PHYS_ADDR_LEN.W))
  val mem3_wb_data  = Output(UInt(WORD_LEN.W))
}

class LoadStoreUnit(
  enable_pipeline_probe: Boolean,
  dram_start: BigInt,
  dram_length: BigInt,
  lsq_entries: Int,
  specul_entries: Int,
  rob_id_len: Int,
  enable_sim_unaligned: Boolean = false
) extends Module {
  val dram_addr_bits: Int = log2Ceil(dram_length)
  val lsq_id_len: Int = log2Ceil(lsq_entries)
  val lsq_id_ptr_len = lsq_id_len + 1
  val rob_id_ptr_len = rob_id_len + 1
  val specul_id_len = log2Ceil(specul_entries)

  val io = IO(new Bundle {
    val out            = new LoadStoreOutput(rob_id_len, specul_id_len)
    val flush          = new LoadStoreQueueFlush
    val alloc1         = new LoadStoreQueueAlloc(lsq_id_len)
    val alloc2         = new LoadStoreQueueAlloc(lsq_id_len)
    val put1           = new LoadStoreQueuePut(enable_pipeline_probe, rob_id_len, lsq_id_len)
    val put2           = new LoadStoreQueuePutLoad(enable_pipeline_probe, rob_id_len, lsq_id_len)
    val dmem           = Flipped(new DmemPortIo)
    val cache          = Flipped(new CachePort)
    val expire_specul1 = Flipped(new ExpireSpeculLoad(specul_id_len))
    val expire_specul2 = Flipped(new ExpireSpeculLoad(specul_id_len))
    val flush_specul   = Input(Bool())
    val debug_signals  = new LoadStoreDebugSignals
    val pipeline_probe = Option.when(enable_pipeline_probe)(new LoadStorePipelineProbe)
  })

  val queue0 = Mem(lsq_entries, UInt(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe).getWidth.W))
  val queue1 = Mem(lsq_entries, UInt(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe).getWidth.W))
  val q_sel  = Mem(lsq_entries, UInt(1.W))
  val rsv    = RegInit(0.U(lsq_id_ptr_len.W))
  val enq    = RegInit(0.U(lsq_id_ptr_len.W))
  val ldq    = RegInit(0.U(lsq_id_ptr_len.W))
  val deq    = RegInit(0.U(lsq_id_ptr_len.W))

  val reg_specul_id     = RegInit(0.U(specul_id_len.W))
  val specul_load_en    = List.fill(2)(Mem(specul_entries, Bool()))
  val specul_load_addrs = List.fill(2)(Mem(specul_entries, UInt((LOAD_ADDR_MATCH_LEN - 3).W)))
  val specul_load_strb  = List.fill(2)(Mem(specul_entries, UInt(4.W)))
  val specul_load_lsq   = List.fill(2)(Mem(specul_entries, UInt(lsq_id_ptr_len.W)))
  val mem1_reg_invalidate   = RegInit(false.B)

  val mem2_stall = Wire(Bool())

  def alloc = {
    val space = rsv - deq
    val valid1 = !space(lsq_id_len)
    val valid2 = valid1 && !space.take(lsq_id_len).andR
    io.alloc1.valid  := valid1
    io.alloc1.lsq_id := rsv
    io.alloc2.valid  := valid2 || !io.alloc1.en && valid1
    io.alloc2.lsq_id := Mux(io.alloc1.en, rsv + 1.U, rsv)
    when (io.alloc1.en && valid1 && io.alloc2.en && valid2) {
      rsv := rsv + 2.U
    }.elsewhen ((io.alloc1.en || io.alloc2.en) && valid1) {
      rsv := rsv + 1.U
    }
  }
  alloc

  def put = {
    val is_dram1 = io.put1.addr(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
    val aligned_lw1 = io.put1.addr(1, 0) === "b00".U &&
      io.put1.memw =/= MW_B && io.put1.memw =/= MW_BU &&
      io.put1.memw =/= MW_H && io.put1.memw =/= MW_HU
    val entry1 = Wire(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe))
    entry1.addr          := io.put1.addr(WORD_LEN-1, 2)
    entry1.wstrb         := (MuxCase("b1111".U, Seq(
      (io.put1.memw === MW_B || io.put1.memw === MW_BU) -> "b0001".U,
      (io.put1.memw === MW_H || io.put1.memw === MW_HU) -> "b0011".U,
    )) << (io.put1.addr(1, 0)))(6, 0)
    entry1.unaligned     := MuxCase(io.put1.addr(1, 0) =/= "b00".U, Seq(
      (io.put1.memw === MW_B || io.put1.memw === MW_BU) -> false.B,
      (io.put1.memw === MW_H || io.put1.memw === MW_HU) -> (io.put1.addr(1, 0) === "b11".U),
    )) && (io.put1.memop === MEM_OP_LD || io.put1.memop === MEM_OP_ST)
    val wdata = ((io.put1.wdata ## io.put1.wdata(31, 8)) << (8.U * io.put1.addr(1, 0)))(WORD_LEN+23, WORD_LEN-8)
    entry1.data          := Mux(io.put1.memop === MEM_OP_LD,
      io.put1.memw(2) ## aligned_lw1 ## io.put1.addr(1, 0) ## 0.U(1.W) ## wdata(26, 6) ## io.put1.wb_paddr,
      wdata,
    )
    entry1.memwl         := io.put1.memw.take(2)
    entry1.is_mem_load   := !is_dram1 && (io.put1.memop === MEM_OP_LD)
    entry1.is_mem_store  := !is_dram1 && (io.put1.memop === MEM_OP_ST)
    entry1.is_dram_load  :=  is_dram1 && (io.put1.memop === MEM_OP_LD)
    entry1.is_dram_store :=  is_dram1 && (io.put1.memop === MEM_OP_ST)
    entry1.is_dram_fence := (io.put1.memop === MEM_OP_FENCE)
    entry1.rob_id        := io.put1.rob_id
    entry1.lsq_id        := io.put1.lsq_id
    map2(entry1.inst_id, io.put1.inst_id)(_ := _)

    val is_dram2 = io.put2.addr(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
    val aligned_lw2 = io.put2.addr(1, 0) === "b00".U &&
      io.put2.memw =/= MW_B && io.put2.memw =/= MW_BU &&
      io.put2.memw =/= MW_H && io.put2.memw =/= MW_HU
    val entry2 = Wire(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe))
    entry2.addr          := io.put2.addr(WORD_LEN-1, 2)
    entry2.wstrb         := "b1111".U
    entry2.unaligned     := MuxCase(io.put2.addr(1, 0) =/= "b00".U, Seq(
      (io.put2.memw === MW_B || io.put2.memw === MW_BU) -> false.B,
      (io.put2.memw === MW_H || io.put2.memw === MW_HU) -> (io.put2.addr(1, 0) === "b11".U),
    ))
    val lstrb = MuxCase("b1111".U, Seq(
      (io.put2.memw === MW_B || io.put2.memw === MW_BU) -> "b0001".U,
      (io.put2.memw === MW_H || io.put2.memw === MW_HU) -> "b0011".U,
    )) << io.put2.addr(1, 0)
    entry2.data          := io.put2.memw(2) ## aligned_lw2 ## io.put2.addr(1, 0) ## 1.U(1.W) ## lstrb(6, 0) ## 0.U(14.W) ## io.put2.wb_paddr
    entry2.memwl         := io.put2.memw.take(2)
    entry2.is_mem_load   := !is_dram2
    entry2.is_mem_store  := false.B
    entry2.is_dram_load  :=  is_dram2
    entry2.is_dram_store := false.B
    entry2.is_dram_fence := false.B
    entry2.rob_id        := io.put2.rob_id
    entry2.lsq_id        := io.put2.lsq_id
    map2(entry2.inst_id, io.put2.inst_id)(_ := _)

    when (io.put1.en) {
      queue0(enq.take(lsq_id_len)) := entry1.asTypeOf(UInt(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe).getWidth.W))
      q_sel(enq.take(lsq_id_len)) := 0.U
    }
    when (io.put2.en) {
      val lsq_id = Mux(io.put1.en, (enq + 1.U).take(lsq_id_len), enq.take(lsq_id_len))
      queue1(lsq_id) := entry2.asTypeOf(UInt(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe).getWidth.W))
      q_sel(lsq_id) := 1.U
    }
    when (io.put1.en && io.put2.en) {
      enq := enq + 2.U
    }.elsewhen (io.put1.en || io.put2.en) {
      enq := enq + 1.U
    }
  }
  put

  def flush = {
    val reg_rsv_reset = RegInit(false.B)
    val reg_enq       = RegNext(enq)
    val reg_preserve  = RegNext(io.put1.en && io.flush.preserve)
    when (io.flush.en) {
      reg_rsv_reset := true.B
      // rsv := enq + Mux(io.put1.en && io.flush.preserve, 1.U, 0.U)
      enq := enq + Mux(io.put1.en && io.flush.preserve, 1.U, 0.U)
    }
    when (reg_rsv_reset) {
      rsv           := reg_enq + Mux(reg_preserve, 1.U, 0.U)
      reg_rsv_reset := false.B
    }
  }
  flush

  def mem1: Mem2Input = {
    val reg_first_cycle = RegInit(true.B)
    val mem1_mem_busy  = Wire(Bool())
    val mem1_dram_busy = Wire(Bool())
    val mem1_unaligned = Wire(Bool())
    val reg_load_order_fail_first = RegInit(false.B)

    val entry = Mux(q_sel(deq) === 0.U, queue0(deq), queue1(deq)).asTypeOf(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe))
    val valid = (deq - enq)(lsq_id_len)

    val mem_stall = mem1_mem_busy || mem1_dram_busy || mem1_unaligned || mem2_stall

    val lsq_id = ldq

    when (!mem_stall) {
      when (valid) {
        deq := deq + 1.U
      }
      reg_first_cycle := true.B
    }
    val valid_op      = valid && !mem1_reg_invalidate
    val in_addr       = entry.addr ## 0.U(2.W)
    val unaligned     = entry.unaligned && valid_op && reg_first_cycle
    val wdata         = entry.data
    val is_mem_load   = entry.is_mem_load   && valid_op
    val is_mem_store  = entry.is_mem_store  && valid_op
    val is_dram_load  = entry.is_dram_load  && valid_op
    val is_dram_store = entry.is_dram_store && valid_op
    val is_dram_fence = entry.is_dram_fence && valid_op

    when (!mem1_mem_busy && !mem1_dram_busy && unaligned) {
      reg_first_cycle := false.B
    }

    val addr  = Mux(unaligned, in_addr + 4.U, in_addr)
    val wstrb = Mux(unaligned, 0.U(1.W) ## entry.wstrb(6, 4), entry.wstrb(3, 0))
    io.dmem.raddr        := addr // (if (enable_sim_unaligned) addr else in_addr)
    io.dmem.waddr        := addr // (if (enable_sim_unaligned) addr else in_addr)
    io.dmem.ren          := is_mem_load
    io.dmem.wen          := is_mem_store
    io.dmem.wstrb        := wstrb
    io.dmem.wdata        := wdata
    io.cache.raddr       := addr
    io.cache.waddr       := addr
    io.cache.ren         := is_dram_load
    io.cache.wen         := is_dram_store
    io.cache.wstrb       := wstrb
    io.cache.wdata       := wdata
    io.cache.iinvalidate := is_dram_fence

    val fails = VecInit((0 until 2).map(idx => Cat((0 until specul_entries).map(i => (
      specul_load_addrs(idx)(i) === addr(LOAD_ADDR_MATCH_LEN - 1, 3) &&
        specul_load_en(idx)(i) &&
        (specul_load_strb(idx)(i) & wstrb) =/= 0.U &&
        (entry.lsq_id - specul_load_lsq(idx)(i))(lsq_id_len)
    ))).orR))
    val load_order_fail_cur = fails(in_addr(2) ^ unaligned) && (is_mem_store || is_dram_store)
    when (!mem_stall) {
      reg_load_order_fail_first := false.B
    }
    when (unaligned) {
      reg_load_order_fail_first := load_order_fail_cur
    }
    val load_order_fail = (reg_load_order_fail_first || load_order_fail_cur) && !unaligned
    mem1_reg_invalidate := mem1_reg_invalidate || load_order_fail

    mem1_mem_busy  := (is_mem_load && !io.dmem.rready) || (is_mem_store && !io.dmem.wready)
    mem1_dram_busy :=
      (is_dram_load  && !io.cache.rready) ||
      (is_dram_store && !io.cache.wready) ||
      (is_dram_fence && io.cache.ibusy)
    mem1_unaligned := unaligned

    io.pipeline_probe.foreach(_.mem1_valid := valid_op)
    map2(io.pipeline_probe, entry.inst_id)(_.mem1_inst_id := _)

    val loads = entry.data.asTypeOf(new LoadData)

    when ((is_mem_load || is_dram_load) && loads.is_specul_load) {
      when (addr(2) === 0.U(1.W)) {
        specul_load_en(0)(reg_specul_id)    := true.B
        specul_load_addrs(0)(reg_specul_id) := addr(LOAD_ADDR_MATCH_LEN - 1, 3)
        specul_load_strb(0)(reg_specul_id)  := Mux(unaligned, 0.U(1.W) ## loads.lstrb(6, 4), loads.lstrb(3, 0))
        specul_load_lsq(0)(reg_specul_id)   := entry.lsq_id
      }.otherwise {
        specul_load_en(1)(reg_specul_id)    := true.B
        specul_load_addrs(1)(reg_specul_id) := addr(LOAD_ADDR_MATCH_LEN - 1, 3)
        specul_load_strb(1)(reg_specul_id)  := Mux(unaligned, 0.U(1.W) ## loads.lstrb(6, 4), loads.lstrb(3, 0))
        specul_load_lsq(1)(reg_specul_id)   := entry.lsq_id
      }
      when (!unaligned) {
        reg_specul_id := Mux(reg_specul_id === 2.U, 0.U, reg_specul_id + 1.U)
      }
    }

    printf(cf"lsq_rsv          : ${rsv}\n")
    printf(cf"lsq_enq          : ${enq}\n")
    printf(cf"lsq_deq          : ${deq}\n")
    printf(cf"specul_id        : ${Mux(loads.is_specul_load, reg_specul_id, "b11".U)}\n")
    for (i <- 0 until LSQ_ENTRIES) {
      when (i.U < enq - deq) {
        val lsq_id = (deq + i.U).take(lsq_id_len)
        val e = Mux(q_sel(lsq_id) === 0.U, queue0(lsq_id), queue1(lsq_id)).asTypeOf(new LoadStoreQueueEntry(rob_id_len, lsq_id_len, enable_pipeline_probe))
        printf(cf"q(${deq+i.U}).addr      : 0x${e.addr ## 0.U(2.W)}%x\n")
        printf(cf"q(${deq+i.U}).memw      : 0x${e.data.asTypeOf(new LoadData).unsigned ## e.memwl}%x\n")
        printf(cf"q(${deq+i.U}).wdata     : 0x${e.data}%x\n")
        printf(cf"q(${deq+i.U}).unaligned : 0x${e.unaligned}%x\n")
      }
    }
    printf(cf"mem1_reg_addr    : 0x${addr}%x\n")
    printf(cf"mem1_reg_memw    : 0x${loads.unsigned ## entry.memwl}%x\n")
    printf(cf"mem1_reg_wdata   : 0x${wdata}%x\n")
    printf(cf"mem1_mem_busy    : ${mem1_mem_busy}%d\n")
    printf(cf"mem1_dram_busy   : ${mem1_dram_busy}%d\n")
    printf(cf"mem1_reg_first_cy: ${reg_first_cycle}%d\n")
    printf(cf"mem1_reg_unaligne: ${unaligned}%d\n")
    printf(cf"mem1_reg_valid   : ${valid_op}%d\n")
    printf(cf"mem1_reg_invalida: ${mem1_reg_invalidate}%d\n")
    printf(cf"mem1_inst_id     : ${entry.inst_id.getOrElse(0)}\n")
    for (i <- 0 until 2) {
      for (j <- 0 until SPECUL_ENTRIES) {
        when (specul_load_en(i)(j)) {
          printf(cf"specul_load 0x${specul_load_addrs(i)(j) ## i.U(1.W) ## 0.U(2.W)}%x ${specul_load_strb(i)(j)}%b\n")
        }
      }
    }

    val out = Wire(new Mem2Input(rob_id_len, enable_pipeline_probe))
    out.valid           := valid_op
    out.aligned_lw      := loads.aligned_lw
    out.memw            := loads.unsigned ## entry.memwl
    out.wb_byte_offset  := loads.wb_byte_offset
    out.wb_paddr        := loads.wb_paddr
    out.mem_busy        := mem1_mem_busy
    out.dram_busy       := mem1_dram_busy
    out.is_mem_load     := is_mem_load
    out.is_dram_load    := is_dram_load
    out.unaligned       := unaligned
    out.rob_id          := entry.rob_id
    out.is_specul_load  := loads.is_specul_load
    out.specul_id       := reg_specul_id
    out.load_order_fail := load_order_fail
    map2(out.inst_id, entry.inst_id)(_ := _)
    out
  }

  val mem2_in = mem1

  class Mem2Input(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
    val rob_id_ptr_len = rob_id_len + 1

    val valid           = Bool()
    val aligned_lw      = Bool()
    val wb_byte_offset  = UInt(2.W)
    val memw            = UInt(MW_LEN.W)
    val wb_paddr        = UInt(PHYS_ADDR_LEN.W)
    val mem_busy        = Bool()
    val dram_busy       = Bool()
    val is_mem_load     = Bool()
    val is_dram_load    = Bool()
    val unaligned       = Bool()
    val rob_id          = UInt(rob_id_ptr_len.W)
    val is_specul_load  = Bool()
    val specul_id       = UInt(specul_id_len.W)
    val load_order_fail = Bool()
    val inst_id         = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  }

  def mem2(in: Mem2Input): Mem3Input = {
    val reg_valid           = RegInit(false.B)
    val reg_aligned_lw      = RegInit(false.B)
    val reg_wb_byte_offset  = RegInit(0.U(2.W))
    val reg_memw            = RegInit(0.U(MW_LEN.W))
    val reg_wb_paddr        = RegInit(0.U(PHYS_ADDR_LEN.W))
    val reg_is_mem_load     = RegInit(false.B)
    val reg_is_dram_load    = RegInit(false.B)
    val reg_unaligned       = RegInit(false.B)
    val reg_rob_id          = RegInit(0.U(rob_id_ptr_len.W))
    val reg_is_specul_load  = RegInit(false.B)
    val reg_specul_id       = RegInit(0.U(specul_id_len.W))
    val reg_load_order_fail = RegInit(false.B)
    val reg_inst_id         = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))

    when (!mem2_stall) {
      reg_aligned_lw      := in.aligned_lw
      reg_wb_byte_offset  := in.wb_byte_offset
      reg_memw            := in.memw
      reg_wb_paddr        := in.wb_paddr
      reg_valid           := !in.mem_busy && !in.dram_busy && in.valid
      reg_is_mem_load     := !in.mem_busy && in.is_mem_load
      reg_is_dram_load    := !in.dram_busy && in.is_dram_load
      reg_unaligned       := in.unaligned
      reg_rob_id          := in.rob_id
      reg_is_specul_load  := in.is_specul_load
      reg_specul_id       := in.specul_id
      reg_load_order_fail := in.load_order_fail
      map2(reg_inst_id, in.inst_id)(_ := _)
    }

    val mem2_mem_busy = (reg_is_mem_load && !io.dmem.rvalid)
    val mem2_dram_busy = (reg_is_dram_load && !io.cache.rvalid)
    mem2_stall := mem2_mem_busy || mem2_dram_busy

    io.pipeline_probe.foreach(_.mem2_valid := !reg_unaligned && reg_valid)
    map2(io.pipeline_probe, reg_inst_id)(_.mem2_inst_id := _)

    val is_valid_load = !mem2_stall && !reg_unaligned && (reg_is_mem_load || reg_is_dram_load)
    val is_aligned_lw = !mem2_stall && (reg_is_mem_load || reg_is_dram_load) && reg_aligned_lw
    val valid         = !mem2_stall && !reg_unaligned && reg_valid
    io.out.fw_en_next    := is_aligned_lw
    io.out.fw_wb_paddr   := reg_wb_paddr
    io.out.wb_next       := is_valid_load
    // io.out.retire_next  := valid
    io.out.wb_paddr_next := reg_wb_paddr

    printf(cf"mem2_mem_busy    : ${mem2_mem_busy}%d\n")
    printf(cf"mem2_dram_busy   : ${mem2_dram_busy}%d\n")
    printf(cf"mem2_reg_valid   : ${reg_valid}%d\n")
    printf(cf"mem2_reg_is_mem_l: ${reg_is_mem_load}%d\n")
    printf(cf"mem2_reg_is_dram_: ${reg_is_dram_load}%d\n")
    printf(cf"mem2_reg_unaligne: ${reg_unaligned}%d\n")
    printf(cf"mem2_is_aligned_l: ${is_aligned_lw}%d\n")
    printf(cf"mem2_reg_wb_paddr: 0x${reg_wb_paddr}%x\n")

    val out = Wire(new Mem3Input(rob_id_len, enable_pipeline_probe))
    out.wb_byte_offset  := reg_wb_byte_offset
    out.memw            := reg_memw
    out.dmem_rdata      := Mux(reg_is_dram_load, io.cache.rdata, io.dmem.rdata)
    out.wb_paddr        := reg_wb_paddr
    out.is_valid_load   := is_valid_load
    out.valid           := valid
    out.unaligned       := reg_unaligned
    out.is_aligned_lw   := is_aligned_lw
    out.rob_id          := reg_rob_id
    out.is_specul_load  := reg_is_specul_load
    out.specul_id       := reg_specul_id
    out.load_order_fail := reg_load_order_fail
    map2(out.inst_id, reg_inst_id)(_ := _)
    out
  }

  val mem3_in = mem2(mem2_in)

  class Mem3Input(rob_id_len: Int, enable_pipeline_probe: Boolean) extends Bundle {
    val rob_id_ptr_len = rob_id_len + 1

    val wb_byte_offset  = UInt(2.W)
    val memw            = UInt(MW_LEN.W)
    val dmem_rdata      = UInt(WORD_LEN.W)
    val wb_paddr        = UInt(PHYS_ADDR_LEN.W)
    val is_valid_load   = Bool()
    val valid           = Bool()
    val unaligned       = Bool()
    val is_aligned_lw   = Bool()
    val rob_id          = UInt(rob_id_ptr_len.W)
    val is_specul_load  = Bool()
    val specul_id       = UInt(specul_id_len.W)
    val load_order_fail = Bool()
    val inst_id         = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  }

  def mem3(in: Mem3Input): Unit = {
    val reg_wb_byte_offset  = RegInit(0.U(2.W))
    val reg_memw            = RegInit(0.U(MW_LEN.W))
    val reg_dmem_rdata      = RegInit(0.U(WORD_LEN.W))
    val reg_wb_paddr        = RegInit(0.U(PHYS_ADDR_LEN.W))
    val reg_is_valid_load   = RegInit(false.B)
    val reg_valid           = RegInit(false.B)
    val reg_unaligned       = RegInit(false.B)
    val reg_is_aligned_lw   = RegInit(false.B)
    val reg_rdata_high      = RegInit(0.U(24.W))
    val reg_rob_id          = RegInit(0.U(rob_id_ptr_len.W))
    val reg_is_specul_load  = RegInit(false.B)
    val reg_specul_id       = RegInit(0.U(specul_id_len.W))
    val reg_load_order_fail = RegInit(false.B)
    val reg_inst_id         = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))

    reg_wb_byte_offset  := in.wb_byte_offset
    reg_memw            := in.memw
    reg_dmem_rdata      := in.dmem_rdata
    reg_wb_paddr        := in.wb_paddr
    reg_is_valid_load   := in.is_valid_load
    reg_valid           := in.valid
    reg_unaligned       := in.unaligned
    reg_is_aligned_lw   := in.is_aligned_lw
    reg_rob_id          := in.rob_id
    reg_is_specul_load  := in.is_specul_load
    reg_specul_id       := in.specul_id
    reg_load_order_fail := in.load_order_fail
    map2(reg_inst_id, in.inst_id)(_ := _)

    def signExtend(value: UInt, w: Int) = {
        Fill(WORD_LEN - w, value(w - 1)) ## value(w - 1, 0)
    }
    def zeroExtend(value: UInt, w: Int) = {
        Fill(WORD_LEN - w, 0.U) ## value(w - 1, 0)
    }

    when (reg_unaligned) {
      reg_rdata_high := reg_dmem_rdata(23, 0)
    }
    val wb_rdata = (Cat(reg_rdata_high, reg_dmem_rdata) >> (8.U * reg_wb_byte_offset))(WORD_LEN-1, 0)
    val wb_data_load = MuxCase(wb_rdata, Seq(
      (reg_memw === MW_B)  -> signExtend(wb_rdata, 8),
      (reg_memw === MW_H)  -> signExtend(wb_rdata, 16),
      (reg_memw === MW_BU) -> zeroExtend(wb_rdata, 8),
      (reg_memw === MW_HU) -> zeroExtend(wb_rdata, 16),
    ))
    io.out.fw_data         := reg_dmem_rdata
    io.out.wb_data         := wb_data_load
    io.out.wb_en           := reg_is_valid_load
    io.out.wb_nofw         := reg_is_valid_load && !reg_is_aligned_lw
    io.out.wb_paddr        := reg_wb_paddr
    io.out.is_retired      := reg_valid
    io.out.rob_id          := reg_rob_id
    io.out.is_specul_load  := reg_is_specul_load
    io.out.specul_id       := reg_specul_id
    io.out.load_order_fail := reg_load_order_fail

    io.debug_signals.mem3_rdata  := reg_dmem_rdata
    io.debug_signals.mem3_rvalid := reg_is_valid_load

    io.pipeline_probe.foreach(_.mem3_valid := reg_valid)
    map2(io.pipeline_probe, reg_inst_id)(_.mem3_inst_id := _)
    // io.pipeline_probe.foreach(_.mem3_retired := reg_valid)
    // io.pipeline_probe.foreach(_.mem3_wb_addr := Mux(reg_is_valid_load, reg_wb_addr, 0.U(ADDR_LEN.W)))
    io.pipeline_probe.foreach(_.mem3_wb_data := wb_data_load)

    printf(cf"mem3_reg_dmem_rda: 0x${reg_dmem_rdata}%x\n")
    printf(cf"mem3_wb_data_load: 0x${wb_data_load}%x\n")
    printf(cf"mem3_reg_unaligne: ${reg_unaligned}%d\n")
    printf(cf"mem3_reg_is_align: ${reg_is_aligned_lw}%d\n")
    printf(cf"mem3_reg_valid   : ${reg_valid}%d\n")
    printf(cf"mem3_reg_wb_paddr: 0x${reg_wb_paddr}%x\n")
  }

  mem3(mem3_in)

  def expire_specul: Unit = {
    when (io.expire_specul1.en) {
      specul_load_en(0)(io.expire_specul1.specul_id) := false.B
      specul_load_en(1)(io.expire_specul1.specul_id) := false.B
    }
    when (io.expire_specul2.en) {
      specul_load_en(0)(io.expire_specul2.specul_id) := false.B
      specul_load_en(1)(io.expire_specul2.specul_id) := false.B
    }
    when (io.flush_specul) {
      for (idx <- 0 until 2) {
        for (i <- 0 until specul_entries) {
          specul_load_en(idx)(i) := false.B
        }
      }
      mem1_reg_invalidate := false.B
    }
  }
  expire_specul
}
