package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import common.Consts._
import common.UIntExtension._
import common.OptionExtension._

class LoadStoreInput(enable_pipeline_probe: Boolean) extends Bundle {
  val valid       = Input(Bool())
  val memop       = Input(UInt(MEM_OP_LEN.W))
  val addr        = Input(UInt(PC_LEN.W))
  val memw        = Input(UInt(MW_LEN.W))
  val wdata       = Input(UInt(WORD_LEN.W))
  val wb_addr     = Input(UInt(ADDR_LEN.W))
  val inst_id     = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
}

class LoadStoreOutput extends Bundle {
  val mem_stall   = Output(Bool())
  val mem2_stall  = Output(Bool())
  val fw_en_next  = Output(Bool())
  val fw_wb_addr  = Output(UInt(ADDR_LEN.W))
  val fw_data     = Output(UInt(WORD_LEN.W))
  val wb_en       = Output(Bool())
  val wb_nofw     = Output(Bool())
  val wb_addr     = Output(UInt(ADDR_LEN.W))
  val wb_data     = Output(UInt(WORD_LEN.W))
  val is_retired  = Output(Bool())
}

class LoadStoreDebugSignals extends Bundle {
  val mem3_rvalid = Output(Bool())
  val mem3_rdata  = Output(UInt(WORD_LEN.W))
}

class LoadStorePipelineProbe extends Bundle {
  val mem1_valid   = Output(Bool())
  val mem1_inst_id = Output(UInt(INST_ID_LEN.W))
  val mem2_valid   = Output(Bool())
  val mem2_inst_id = Output(UInt(INST_ID_LEN.W))
  val mem3_valid   = Output(Bool())
  val mem3_inst_id = Output(UInt(INST_ID_LEN.W))
  val mem3_retired = Output(Bool())
  val mem3_wb_addr = Output(UInt(ADDR_LEN.W))
  val mem3_wb_data = Output(UInt(WORD_LEN.W))
}

class LoadStoreUnit(enable_pipeline_probe: Boolean, dram_start: BigInt, dram_length: BigInt) extends Module {
  val dram_addr_bits: Int = log2Ceil(dram_length)

  val io = IO(new Bundle {
    val in = new LoadStoreInput(enable_pipeline_probe)
    val out = new LoadStoreOutput
    val dmem = Flipped(new DmemPortIo)
    val cache = Flipped(new CachePort)
    val debug_signals = new LoadStoreDebugSignals
    val pipeline_probe = Option.when(enable_pipeline_probe)(new LoadStorePipelineProbe)
  })

  val mem1_mem_busy  = Wire(Bool())
  val mem1_dram_busy = Wire(Bool())
  val mem1_unaligned = Wire(Bool())
  val mem2_stall     = Wire(Bool())
  val mem_stall      = Wire(Bool())

  mem_stall        := mem1_mem_busy || mem1_dram_busy || mem1_unaligned || mem2_stall
  io.out.mem_stall := mem_stall

  class Mem1Input(enable_pipeline_probe: Boolean) extends Bundle {
    val valid       = Bool()
    val memop       = UInt(MEM_OP_LEN.W)
    val addr        = UInt(WORD_LEN.W)
    val memw        = UInt(MW_LEN.W)
    val wdata       = UInt(WORD_LEN.W)
    val wb_addr     = UInt(ADDR_LEN.W)
    val inst_id     = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
  }

  val mem1_in = Wire(new Mem1Input(enable_pipeline_probe))
  mem1_in.valid   := io.in.valid
  mem1_in.memop   := io.in.memop
  mem1_in.addr    := io.in.addr
  mem1_in.memw    := io.in.memw
  mem1_in.wdata   := io.in.wdata
  mem1_in.wb_addr := io.in.wb_addr
  map2(mem1_in.inst_id, io.in.inst_id)(_ := _)

  def mem1(in: Mem1Input): Mem2Input = {
    val reg_valid         = RegInit(false.B)
    val reg_memop         = RegInit(0.U(MEM_OP_LEN.W))
    val reg_addr          = RegInit(0.U(WORD_LEN.W))
    val reg_unaligned     = RegInit(false.B)
    val reg_memw          = RegInit(MW_X)
    val reg_wstrb         = RegInit(0.U(7.W))
    val reg_wdata         = RegInit(0.U(WORD_LEN.W))
    val reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
    val reg_is_mem_load   = RegInit(false.B)
    val reg_is_mem_store  = RegInit(false.B)
    val reg_is_dram_load  = RegInit(false.B)
    val reg_is_dram_store = RegInit(false.B)
    val reg_is_dram_fence = RegInit(false.B)
    val reg_inst_id       = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))

    when (!mem_stall) {
      val is_dram = in.addr(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
      reg_addr          := in.addr
      reg_wstrb         := (MuxCase("b1111".U, Seq(
        (in.memw === MW_B || in.memw === MW_BU) -> "b0001".U,
        (in.memw === MW_H || in.memw === MW_HU) -> "b0011".U,
      )) << (in.addr(1, 0)))(6, 0)
      reg_unaligned     := MuxCase(in.addr(1, 0) =/= "b00".U, Seq(
        (in.memw === MW_B || in.memw === MW_BU) -> false.B,
        (in.memw === MW_H || in.memw === MW_HU) -> (in.addr(1, 0) === "b11".U),
      )) && (in.memop === MEM_OP_LD || in.memop === MEM_OP_ST) && in.valid
      reg_wb_addr       := in.wb_addr
      reg_wdata         := ((in.wdata ## in.wdata(31, 8)) << (8.U * in.addr(1, 0)))(WORD_LEN+23, WORD_LEN-8)
      reg_memw          := in.memw
      // mem1_reg_is_dram       := mem1_is_dram
      reg_is_mem_load   := !is_dram && (in.memop === MEM_OP_LD) && in.valid
      reg_is_mem_store  := !is_dram && (in.memop === MEM_OP_ST) && in.valid
      reg_is_dram_load  := is_dram && (in.memop === MEM_OP_LD) && in.valid
      reg_is_dram_store := is_dram && (in.memop === MEM_OP_ST) && in.valid
      reg_is_dram_fence := (in.memop === MEM_OP_FENCE) && in.valid
      reg_valid         := in.valid
      map2(reg_inst_id, in.inst_id)(_ := _)
    }

    when (!mem1_mem_busy && !mem1_dram_busy && reg_unaligned) {
      reg_unaligned := false.B
    }

    val addr  = Mux(reg_unaligned, reg_addr + 4.U, reg_addr)
    val wstrb = Mux(reg_unaligned, 0.U(1.W) ## reg_wstrb(6, 4), reg_wstrb(3, 0))
    io.dmem.raddr        := addr
    io.dmem.waddr        := addr
    io.dmem.ren          := reg_is_mem_load
    io.dmem.wen          := reg_is_mem_store
    io.dmem.wstrb        := wstrb
    io.dmem.wdata        := reg_wdata
    io.cache.raddr       := addr
    io.cache.waddr       := addr
    io.cache.ren         := reg_is_dram_load
    io.cache.wen         := reg_is_dram_store
    io.cache.wstrb       := wstrb
    io.cache.wdata       := reg_wdata
    io.cache.iinvalidate := reg_is_dram_fence

    mem1_mem_busy  := (reg_is_mem_load && !io.dmem.rready) || (reg_is_mem_store && !io.dmem.wready)
    mem1_dram_busy      :=
      (reg_is_dram_load  && !io.cache.rready) ||
      (reg_is_dram_store && !io.cache.wready) ||
      (reg_is_dram_fence && io.cache.ibusy)
    mem1_unaligned := reg_unaligned

    io.pipeline_probe.foreach(_.mem1_valid := reg_valid)
    map2(io.pipeline_probe, reg_inst_id)(_.mem1_inst_id := _)

    printf(cf"mem1_reg_addr    : 0x${reg_addr}%x\n")
    // printf(cf"mem1_reg_memw    : 0x${reg_memw}%x\n")
    printf(cf"mem1_reg_wdata   : 0x${reg_wdata}%x\n")
    printf(cf"mem1_mem_busy    : ${mem1_mem_busy}%d\n")
    printf(cf"mem1_dram_busy   : ${mem1_dram_busy}%d\n")
    printf(cf"mem1_reg_unaligne: ${reg_unaligned}%d\n")
    printf(cf"mem1_reg_valid   : ${reg_valid}%d\n")

    val out = Wire(new Mem2Input(enable_pipeline_probe))
    out.valid          := reg_valid
    out.wb_byte_offset := reg_addr(1, 0)
    out.memw           := reg_memw
    out.wb_addr        := reg_wb_addr
    out.mem_busy       := mem1_mem_busy
    out.dram_busy      := mem1_dram_busy
    out.is_mem_load    := reg_is_mem_load
    out.is_dram_load   := reg_is_dram_load
    out.unaligned      := reg_unaligned
    map2(out.inst_id, reg_inst_id)(_ := _)
    out
  }

  val mem2_in = mem1(mem1_in)

  class Mem2Input(enable_pipeline_probe: Boolean) extends Bundle {
    val valid          = Bool()
    val wb_byte_offset = UInt(2.W)
    val memw           = UInt(MW_LEN.W)
    val wb_addr        = UInt(ADDR_LEN.W)
    val mem_busy       = Bool()
    val dram_busy      = Bool()
    val is_mem_load    = Bool()
    val is_dram_load   = Bool()
    val unaligned      = Bool()
    val inst_id        = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  }

  def mem2(in: Mem2Input): Mem3Input = {
    val reg_valid          = RegInit(false.B)
    val reg_wb_byte_offset = RegInit(0.U(2.W))
    val reg_memw           = RegInit(0.U(MW_LEN.W))
    val reg_wb_addr        = RegInit(0.U(ADDR_LEN.W))
    // val reg_is_valid_load  = RegInit(false.B)
    val reg_is_mem_load    = RegInit(false.B)
    val reg_is_dram_load   = RegInit(false.B)
    val reg_unaligned      = RegInit(false.B)
    val reg_inst_id        = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))

    when (!mem2_stall) {
      reg_wb_byte_offset := in.wb_byte_offset
      reg_memw           := in.memw
      reg_wb_addr        := in.wb_addr
      // reg_is_valid_load  := (!in.mem_stall && in.is_mem_load) || (!in.dram_stall && in.is_dram_load)
      reg_valid          := !in.mem_busy && !in.dram_busy && in.valid
      reg_is_mem_load    := !in.mem_busy && in.is_mem_load
      reg_is_dram_load   := !in.dram_busy && in.is_dram_load
      reg_unaligned      := in.unaligned
      map2(reg_inst_id, in.inst_id)(_ := _)
    }

    val mem2_mem_busy = (reg_is_mem_load && !io.dmem.rvalid)
    val mem2_dram_busy = (reg_is_dram_load && !io.cache.rvalid)
    mem2_stall := mem2_mem_busy || mem2_dram_busy
    io.out.mem2_stall := mem2_stall

    io.pipeline_probe.foreach(_.mem2_valid := !reg_unaligned && reg_valid)
    map2(io.pipeline_probe, reg_inst_id)(_.mem2_inst_id := _)

    val is_valid_load = !mem2_stall && !reg_unaligned && (reg_is_mem_load || reg_is_dram_load)
    val is_aligned_lw = !mem2_stall && (reg_is_mem_load || reg_is_dram_load) && reg_wb_byte_offset === "b00".U &&
      reg_memw =/= MW_B && reg_memw =/= MW_BU &&
      reg_memw =/= MW_H && reg_memw =/= MW_HU
    io.out.fw_en_next := is_aligned_lw
    io.out.fw_wb_addr := reg_wb_addr

    printf(cf"mem2_mem_busy    : ${mem2_mem_busy}%d\n")
    printf(cf"mem2_dram_busy   : ${mem2_dram_busy}%d\n")
    printf(cf"mem2_reg_valid   : ${reg_valid}%d\n")
    printf(cf"mem2_reg_is_mem_l: ${reg_is_mem_load}%d\n")
    printf(cf"mem2_reg_is_dram_: ${reg_is_dram_load}%d\n")
    printf(cf"mem2_reg_unaligne: ${reg_unaligned}%d\n")
    printf(cf"mem2_is_aligned_l: ${is_aligned_lw}%d\n")
    printf(cf"mem2_reg_wb_addr : 0x${reg_wb_addr}%x\n")

    val out = Wire(new Mem3Input(enable_pipeline_probe))
    out.wb_byte_offset := reg_wb_byte_offset
    out.memw           := reg_memw
    out.dmem_rdata     := Mux(reg_is_dram_load, io.cache.rdata, io.dmem.rdata)
    out.wb_addr        := reg_wb_addr
    out.is_valid_load  := is_valid_load
    out.valid          := !mem2_stall && !reg_unaligned && reg_valid
    out.unaligned      := reg_unaligned
    out.is_aligned_lw  := is_aligned_lw
    map2(out.inst_id, reg_inst_id)(_ := _)
    out
  }

  val mem3_in = mem2(mem2_in)

  class Mem3Input(enable_pipeline_probe: Boolean) extends Bundle {
    val wb_byte_offset = UInt(2.W)
    val memw           = UInt(MW_LEN.W)
    val dmem_rdata     = UInt(WORD_LEN.W)
    val wb_addr        = UInt(ADDR_LEN.W)
    val is_valid_load  = Bool()
    val valid          = Bool()
    val unaligned      = Bool()
    val is_aligned_lw  = Bool()
    val inst_id        = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  }

  def mem3(in: Mem3Input): Unit = {
    val reg_wb_byte_offset = RegInit(0.U(2.W))
    val reg_memw           = RegInit(0.U(MW_LEN.W))
    val reg_dmem_rdata     = RegInit(0.U(WORD_LEN.W))
    val reg_wb_addr        = RegInit(0.U(ADDR_LEN.W))
    val reg_is_valid_load  = RegInit(false.B)
    val reg_valid          = RegInit(false.B)
    val reg_unaligned      = RegInit(false.B)
    val reg_is_aligned_lw  = RegInit(false.B)
    val reg_rdata_high     = RegInit(0.U(24.W))
    val reg_inst_id        = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))

    reg_wb_byte_offset := in.wb_byte_offset
    reg_memw           := in.memw
    reg_dmem_rdata     := in.dmem_rdata
    reg_wb_addr        := in.wb_addr
    reg_is_valid_load  := in.is_valid_load
    reg_valid          := in.valid
    reg_unaligned      := in.unaligned
    reg_is_aligned_lw  := in.is_aligned_lw
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
    io.out.fw_data    := reg_dmem_rdata
    io.out.wb_data    := wb_data_load
    io.out.wb_en      := reg_is_valid_load
    io.out.wb_nofw    := reg_is_valid_load && !reg_is_aligned_lw
    io.out.wb_addr    := reg_wb_addr
    io.out.is_retired := reg_valid

    io.debug_signals.mem3_rdata  := reg_dmem_rdata
    io.debug_signals.mem3_rvalid := reg_is_valid_load

    io.pipeline_probe.foreach(_.mem3_valid := reg_valid)
    map2(io.pipeline_probe, reg_inst_id)(_.mem3_inst_id := _)
    io.pipeline_probe.foreach(_.mem3_retired := reg_valid)
    io.pipeline_probe.foreach(_.mem3_wb_addr := Mux(reg_is_valid_load, reg_wb_addr, 0.U(ADDR_LEN.W)))
    io.pipeline_probe.foreach(_.mem3_wb_data := wb_data_load)

    printf(cf"mem3_reg_dmem_rda: 0x${reg_dmem_rdata}%x\n")
    printf(cf"mem3_wb_data_load: 0x${wb_data_load}%x\n")
    printf(cf"mem3_reg_unaligne: ${reg_unaligned}%d\n")
    printf(cf"mem3_reg_is_align: ${reg_is_aligned_lw}%d\n")
    printf(cf"mem3_reg_valid   : ${reg_valid}%d\n")
    printf(cf"mem3_reg_wb_addr : 0x${reg_wb_addr}%x\n")
  }

  mem3(mem3_in)
}
