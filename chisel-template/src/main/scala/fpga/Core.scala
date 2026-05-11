package fpga

import chisel3._
import chisel3.util._
import common.Instructions._
import common.Consts._
import common.OptionExtension._
import common.UIntExtension._
import common.SIntExtension._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.ChiselEnum

class LongCounter(unitWidth: Int, unitCount: Int) extends Module {
  val counterWidth = unitWidth * unitCount
  val io = IO(new Bundle {
    val value = Output(UInt(counterWidth.W))
  })

  // val counters = RegInit(VecInit((0 to unitCount - 1).map(_ => 0.U(unitWidth.W))))
  // val carries = RegInit(VecInit((0 to unitCount - 1).map(_ => false.B)))
  // for (i <- 0 to unitCount - 1) {
  //   carries(i) := counters(i)(unitWidth - 1, 1).andR() && !counters(i)(0) // overflows at the next cycle or not.
  //   if (i == 0) {
  //     counters(i) := counters(i) + 1.U
  //   } else {
  //     counters(i) := counters(i) + carries(i - 1).asUInt
  //   }
  // }
  // io.value := Cat(counters.reverse)

  val counters = RegInit(VecInit((0 until 2).map(_ => 0.U(32.W))))
  val counter0 = RegNext(counters(0), 0.U(32.W))
  val carry = RegInit(0.U(1.W))
  val c = counters(0) +& 1.U
  counters(0) := c(31, 0)
  carry := c(32)
  counters(1) := counters(1) + carry
  io.value := Cat(counters(1), counter0)

  // val counter = RegInit(0.U(counterWidth.W))
  // counter := counter + 1.U
  // io.value := counter
}

class CoreDebugSignals extends Bundle {
  val ex2_reg_pc        = Output(UInt(WORD_LEN.W))
  val ex2_is_valid_inst = Output(Bool())
  // val csr_rdata         = Output(UInt(WORD_LEN.W))
  // val ex1_reg_csr_addr  = Output(UInt(CSR_ADDR_LEN.W))
  val me_intr           = Output(Bool())
  val mt_intr           = Output(Bool())
  val trap              = Output(Bool())
  val cycle_counter     = Output(UInt(48.W))
  val id_pc             = Output(UInt(WORD_LEN.W))
  val id_inst           = Output(UInt(WORD_LEN.W))
  val mem3_rdata        = Output(UInt(WORD_LEN.W))
  val mem3_rvalid       = Output(Bool())
  val rwaddr            = Output(UInt(WORD_LEN.W))
  val ex2_reg_is_br     = Output(Bool())
  val id_reg_bp_taken   = Output(Bool())
  val if2_zbp_taken     = Output(Bool())
  val ic_state          = Output(UInt(3.W))
}

object IcState extends ChiselEnum {
  val Empty = Value     // reg: empty, reg2: empty, imem: this
  val Full = Value      // reg: full,  reg2: empty, imem: next
  val Full2Half = Value // reg: full,  reg2: full,  imem: next, half address
  val FullHalf = Value  // reg: full,  reg2: empty, imem: next, half address
  val EmptyHalf = Value // reg: empty, reg2: empty, imem: this, half address
  val DummyFull = Value
  val DummyFull2Half = Value
  val DummyFullHalf = Value
}

object DivremState extends ChiselEnum {
  val Idle = Value
  val Placing = Value
  val Dividing = Value
  val Shifting = Value
  val Correction = Value
  val Finished = Value
}

object DmemState extends ChiselEnum {
  val Idle = Value
  val Reading = Value
}

class SimProbe extends Bundle {
  val gp   = Output(UInt((WORD_LEN).W))
  val exit = Output(Bool())
}

class PipelineProbe extends Bundle {
  val if2_valid1             = Output(Bool())
  val if2_inst_id1           = Output(UInt(INST_ID_LEN.W))
  val if2_pc1                = Output(UInt(INST_ID_LEN.W))
  val if2_inst1              = Output(UInt(INST_ID_LEN.W))
  val if2_valid2             = Output(Bool())
  val if2_inst_id2           = Output(UInt(INST_ID_LEN.W))
  val if2_pc2                = Output(UInt(INST_ID_LEN.W))
  val if2_inst2              = Output(UInt(INST_ID_LEN.W))
  val id1a_valid             = Output(Bool())
  val id1a_inst_id           = Output(UInt(INST_ID_LEN.W))
  val id1b_valid             = Output(Bool())
  val id1b_inst_id           = Output(UInt(INST_ID_LEN.W))
  val id2a_valid             = Output(Bool())
  val id2a_inst_id           = Output(UInt(INST_ID_LEN.W))
  val id2b_valid             = Output(Bool())
  val id2b_inst_id           = Output(UInt(INST_ID_LEN.W))
  val rrd_valid              = Output(Bool())
  val rrd_inst_id            = Output(UInt(INST_ID_LEN.W))
  val rrd_i2_valid           = Output(Bool())
  val rrd_i2_inst_id         = Output(UInt(INST_ID_LEN.W))
  val ex1_valid              = Output(Bool())
  val ex1_inst_id            = Output(UInt(INST_ID_LEN.W))
  val ex1_i2_valid           = Output(Bool())
  val ex1_i2_inst_id         = Output(UInt(INST_ID_LEN.W))
  // val ex1_i2_retired         = Output(Bool())
  // val ex1_i2_wb_addr         = Output(UInt(ADDR_LEN.W))
  // val ex1_i2_wb_data         = Output(UInt(WORD_LEN.W))
  val ex1_predict_redirected = Output(Bool())
  val ex1_predict_bpfailed   = Output(Bool())
  val ex1_predict_attr       = Output(UInt(BTB_ATTR_LEN.W))
  val ex1_predict_is_ret     = Output(Bool())
  val ex1_predict_target_pc  = Output(UInt(PC_LEN.W))
  val ex1_history            = Output(UInt(PHT_HISTORY_LEN.W))
  val ex1_lcnt               = Output(UInt(2.W))
  val ex1_gcnt               = Output(UInt(2.W))
  val ex1_actual_redirected  = Output(Bool())
  val ex1_actual_attr        = Output(UInt(BTB_ATTR_LEN.W))
  val ex1_actual_is_ret      = Output(Bool())
  val ex1_actual_target_pc   = Output(UInt(PC_LEN.W))
  val csr_read               = Output(Bool())
  val csr_addr               = Output(UInt(CSR_ADDR_LEN.W))
  val csr_data               = Output(UInt(WORD_LEN.W))
  val intr_mtimer            = Output(Bool())
  val intr_ext               = Output(Bool())
  val ex2_valid              = Output(Bool())
  val ex2_inst_id            = Output(UInt(INST_ID_LEN.W))
  // val ex2_retired            = Output(Bool())
  // val ex2_wb_addr            = Output(UInt(ADDR_LEN.W))
  // val ex2_wb_data            = Output(UInt(WORD_LEN.W))
  val mem1_valid             = Output(Bool())
  val mem1_inst_id           = Output(UInt(INST_ID_LEN.W))
  val mem2_valid             = Output(Bool())
  val mem2_inst_id           = Output(UInt(INST_ID_LEN.W))
  val mem3_valid             = Output(Bool())
  val mem3_inst_id           = Output(UInt(INST_ID_LEN.W))
  val mem3_is_load           = Output(Bool())
  val mem3_addr              = Output(UInt(WORD_LEN.W))
  val mem3_data              = Output(UInt(WORD_LEN.W))
  val retire1_valid          = Output(Bool())
  val retire1_inst_id        = Output(UInt(INST_ID_LEN.W))
  val retire1_wb_addr        = Output(UInt(ADDR_LEN.W))
  val retire1_wb_data        = Output(UInt(WORD_LEN.W))
  val retire2_valid          = Output(Bool())
  val retire2_inst_id        = Output(UInt(INST_ID_LEN.W))
  val retire2_wb_addr        = Output(UInt(ADDR_LEN.W))
  val retire2_wb_data        = Output(UInt(WORD_LEN.W))
  val flush_pipeline         = Output(Bool())
}

class Core(
  regsInitMemory: Option[RegisterFileInitMemoryPath] = None,
  start_address: BigInt = 0,
  dram_start: BigInt = 0x2000_0000L,
  dram_length: BigInt = 0x1000_0000L,
  enable_sim_probe: Boolean = false,
  enable_pipeline_probe: Boolean = false,
  enable_sim_unaligned: Boolean = false,
) extends Module {
  val rob_id_len = log2Ceil(IQ_ENTRIES)
  val rob_id_ptr_len = rob_id_len + 1
  val lsq_id_len = log2Ceil(LSQ_ENTRIES)
  val lsq_id_ptr_len = lsq_id_len + 1

  val io = IO(new Bundle {
    val imem = Flipped(new ImemPortIo())
    val dmem = Flipped(new DmemPortIo())
    val icache = Flipped(new CachedImemPort())
    val cache = Flipped(new CachePort())
    val pht_lmem = Flipped(new PHTMemIo(PHT_INDEX_LEN))
    val pht_gmem = Flipped(new PHTMemIo(PHT_INDEX_LEN))
    val mtimer_mem = new DmemPortIo()
    val intr = Input(Bool())
    val debug_signal = new CoreDebugSignals()
    val sim_probe = Option.when(enable_sim_probe)(new SimProbe())
    val pipeline_probe = Option.when(enable_pipeline_probe)(new PipelineProbe())
  })

  // val regsel = Mem(32, UInt(1.W))
  // val regfile1a = Mem(32, UInt(WORD_LEN.W))
  // val regfile1b = Mem(32, UInt(WORD_LEN.W))
  // val regfile2a = Mem(32, UInt(WORD_LEN.W))
  // val regfile2b = Mem(32, UInt(WORD_LEN.W))

  // def read_regfile_a(addr: UInt): UInt = {
  //   Mux(regsel(addr) === 0.U, regfile1a(addr), regfile2a(addr))
  // }
  // def read_regfile_b(addr: UInt): UInt = {
  //   Mux(regsel(addr) === 0.U, regfile1b(addr), regfile2b(addr))
  // }

  //val csr_regfile = Mem(4096, UInt(WORD_LEN.W)) 
  val cycle_counter = Module(new LongCounter(32, 2)) // 64-bit cycle counter for CYCLE[H] CSR
  val mtimer = Module(new MachineTimer)

  val instret = RegInit(0.U(64.W))
  val csr_reg_trap_vector  = RegInit(0.U(PC_LEN.W))
  val csr_reg_mcause_code  = RegInit(0.U(CSR_MCAUSE_CODE_LEN.W))
  // val csr_mtval         = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mepc         = RegInit(0.U(PC_LEN.W))
  val csr_reg_mstatus_mie  = RegInit(false.B)
  val csr_reg_mstatus_mpie = RegInit(false.B)
  val csr_reg_mscratch     = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mie_meie     = RegInit(false.B)
  val csr_reg_mie_mtie     = RegInit(false.B)
  // val csr_mip           = RegInit(0.U(WORD_LEN.W))
  val scoreboard   = Mem(48, Bool())

  io.mtimer_mem <> mtimer.io.mem

  //**********************************
  // Pipeline State Registers

  // ID/RRD State
  val rrd_reg_valid            = Wire(Bool()) // RegInit(false.B)
  val rrd_reg_pc               = Wire(UInt(PC_LEN.W)) // RegInit(0.U(PC_LEN.W))
  val rrd_rob_id               = Wire(UInt(rob_id_ptr_len.W))
  val rrd_lsq_id               = Wire(UInt(lsq_id_ptr_len.W))
  val rrd_reg_exe_sel          = Wire(UInt(EXE_SEL_LEN.W)) // RegInit(0.U(EXE_SEL_LEN.W))
  val rrd_reg_exe_fun          = Wire(UInt(EXE_FUN_LEN.W)) // RegInit(0.U(EXE_FUN_LEN.W))
  val rrd_reg_sop              = Wire(UInt(SOP_LEN.W)) // RegInit(0.U(SOP_LEN.W))
  val rrd_reg_op1_sel          = Wire(UInt(OP1_SEL_LEN.W)) // RegInit(0.U(OP1_SEL_LEN.W))
  val rrd_reg_op2_sel          = Wire(UInt(OP2_SEL_LEN.W)) // RegInit(0.U(OP2_SEL_LEN.W))
  val rrd_reg_op3_sel          = Wire(UInt(OP3_SEL_LEN.W)) // RegInit(0.U(OP3_SEL_LEN.W))
  val rrd_reg_rs1_addr         = Wire(UInt(ADDR_LEN.W))
  val rrd_reg_rs2_addr         = Wire(UInt(ADDR_LEN.W))
  val rrd_reg_rs3_addr         = Wire(UInt(ADDR_LEN.W))
  val rrd_reg_rs1_paddr        = Wire(UInt(PHYS_ADDR_LEN.W)) // RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_rs2_paddr        = Wire(UInt(PHYS_ADDR_LEN.W)) // RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_rs3_paddr        = Wire(UInt(PHYS_ADDR_LEN.W)) // RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_imm_data         = Wire(UInt(IMM_DATA_LEN.W)) // RegInit(0.U(IMM_DATA_LEN.W))
  val rrd_reg_rf_wen           = Wire(UInt(REN_LEN.W)) // RegInit(0.U(REN_LEN.W))
  val rrd_reg_wb_paddr         = Wire(UInt(PHYS_ADDR_LEN.W)) // RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_bp               = Wire(new BranchPrediction(REDIRECT_BUFFER_SIZE)) // RegInit(0.U.asTypeOf(new BranchPrediction(REDIRECT_BUFFER_SIZE)))
  val rrd_reg_is_half          = Wire(Bool()) // RegInit(false.B)
  val rrd_i2_valid             = Wire(Bool())
  val rrd_i2_pc                = Wire(UInt(PC_LEN.W))
  val rrd_i2_rob_id            = Wire(UInt(rob_id_ptr_len.W))
  val rrd_i2_lsq_id            = Wire(UInt(lsq_id_ptr_len.W))
  val rrd_i2_exe_sel           = Wire(UInt(EXE_SEL_LEN.W))
  val rrd_i2_exe_fun           = Wire(UInt(EXE_FUN_LEN.W))
  val rrd_i2_sop               = Wire(UInt(SOP_LEN.W))
  val rrd_i2_op1_sel           = Wire(UInt(OP1_SEL_LEN.W))
  val rrd_i2_op2_sel           = Wire(UInt(OP2_SEL_LEN.W))
  val rrd_i2_op3_sel           = Wire(UInt(OP3_SEL_LEN.W))
  val rrd_i2_rs1_addr          = Wire(UInt(ADDR_LEN.W))
  val rrd_i2_rs2_addr          = Wire(UInt(ADDR_LEN.W))
  val rrd_i2_rs3_addr          = Wire(UInt(ADDR_LEN.W))
  val rrd_i2_rs1_paddr         = Wire(UInt(PHYS_ADDR_LEN.W))
  val rrd_i2_rs2_paddr         = Wire(UInt(PHYS_ADDR_LEN.W))
  val rrd_i2_imm_data          = Wire(UInt(IMM_DATA_LEN.W))
  val rrd_i2_rf_wen            = Wire(UInt(REN_LEN.W))
  val rrd_i2_wb_paddr          = Wire(UInt(PHYS_ADDR_LEN.W))
  val rrd_i2_is_half           = Wire(Bool())
  val rrd_i2_redirected        = Wire(Bool())

  // RRD/EX1 State
  val ex1_reg_pc               = RegInit(0.U(PC_LEN.W))
  val ex1_reg_rob_id           = RegInit(0.U(rob_id_ptr_len.W))
  val ex1_reg_lsq_id           = RegInit(0.U(lsq_id_ptr_len.W))
  val ex1_reg_exe_sel          = RegInit(0.U(EXE_SEL_LEN.W))
  val ex1_reg_exe_fun          = RegInit(0.U(EXE_FUN_LEN.W))
  val ex1_reg_sop              = RegInit(0.U(SOP_LEN.W))
  val ex1_reg_op1_data         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op2_data         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op3_data         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_imm_data         = RegInit(0.U(IMM_DATA_LEN.W))
  val ex1_reg_rf_wen           = RegInit(0.U(REN_LEN.W))
  val ex1_reg_wb_paddr         = RegInit(0.U(PHYS_ADDR_LEN.W))
  val ex1_reg_bp               = RegInit(0.U.asTypeOf(new BranchPrediction(REDIRECT_BUFFER_SIZE)))
  val ex1_reg_is_half          = RegInit(false.B)
  val ex1_reg_valid            = RegInit(false.B)
  val ex1_reg_mem_use_reg      = RegInit(false.B)
  val ex1_reg_inst2_use_reg    = RegInit(false.B)
  val ex1_reg_inst3_use_reg    = RegInit(false.B)
  val ex1_reg_fp_entry         = RegInit(0.U.asTypeOf(new FetchPredictionEntry(PHT_HISTORY_LEN)))
  val ex1_reg_lsu_enq          = RegInit(false.B)
  val ex1_reg_i2_pc            = RegInit(0.U(PC_LEN.W))
  val ex1_reg_i2_rob_id        = RegInit(0.U(rob_id_ptr_len.W))
  val ex1_reg_i2_lsq_id        = RegInit(0.U(lsq_id_ptr_len.W))
  val ex1_reg_i2_is_alu        = RegInit(false.B)
  val ex1_reg_i2_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  // val ex1_reg_i2_sop           = RegInit(0.U(SOP_LEN.W))
  val ex1_reg_i2_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_i2_op2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_i2_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex1_reg_i2_wb_paddr      = RegInit(0.U(PHYS_ADDR_LEN.W))
  val ex1_reg_i2_valid         = RegInit(false.B)

  // EX1/EX2 State
  val ex2_reg_pc            = RegInit(0.U(PC_LEN.W))
  val ex2_reg_wb_paddr      = RegInit(0.U(PHYS_ADDR_LEN.W))
  val ex2_reg_mull          = RegInit(0.U((33+24).W))
  val ex2_reg_mulh          = RegInit(0.U((33+9).W))
  val ex2_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex2_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex2_reg_fun_sel       = RegInit(0.U(EX2_FUN_LEN.W))
  val ex2_reg_alu_out       = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_blu_out       = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_csr_rdata     = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_op3_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_valid         = RegInit(false.B)
  val ex2_reg_rob_id        = RegInit(0.U(rob_id_ptr_len.W))
  val ex2_reg_processed     = RegInit(false.B)
  // val ex2_reg_redirect      = RegInit(false.B)
  // val ex2_reg_target_pc     = RegInit(0.U(PC_LEN.W))
  val ex2_reg_inst3_use_reg = RegInit(false.B)
  // val ex2_reg_correction    = RegInit(0.U.asTypeOf(new BranchCorrection(PHT_HISTORY_LEN)))

  val div_divrem_in_use = Wire(Bool())
  val div_divrem_rrd_wb = Wire(Bool())
  val div_divrem_ex1_wb = Wire(Bool())
  val div_reg_pc        = RegInit(0.U(PC_LEN.W))
  val div_reg_is_div    = RegInit(false.B)
  val div_reg_en        = RegInit(false.B)
  val div_reg_wb_paddr  = RegInit(0.U(PHYS_ADDR_LEN.W))
  val div_reg_rob_id    = RegInit(0.U(rob_id_ptr_len.W))
  val div_reg_reminder  = RegInit(0.U(WORD_LEN.W))
  val div_reg_quotient  = RegInit(0.U(WORD_LEN.W))

  val rrd_stall            = Wire(Bool())
  val rrd_ready2           = Wire(Bool())
  val rrd_pause2           = Wire(Bool())
  val ex1_reg_fw_en        = RegInit(false.B)
  val ex1_fw_data          = Wire(UInt(WORD_LEN.W))
  val ex1_reg_fw2_en       = RegInit(false.B)
  val ex1_fw2_data         = Wire(UInt(WORD_LEN.W))
  val ex2_reg_fw_en        = RegInit(false.B)
  val ex2_fw_data          = Wire(UInt(WORD_LEN.W))
  // val mem3_reg_fw_en       = RegInit(false.B)
  // val mem3_fw_wb_addr      = Wire(UInt(ADDR_LEN.W))
  // val mem3_fw_data         = Wire(UInt(WORD_LEN.W))
  // val reg_flush            = RegInit(true.B) // jump start_address when first time
  // val reg_target_pc        = RegInit(start_address.U(WORD_LEN.W).word_to_pc)
  val reg_flush            = Wire(Bool())
  val reg_target_pc        = Wire(UInt(PC_LEN.W))
  val ex1_fetch_pc_en      = Wire(Bool())
  val ex2_reg_stall        = RegInit(false.B)
  val csr_is_br            = Wire(Bool())
  val csr_br_pc            = Wire(UInt(PC_LEN.W))
  val mem1_reg_dmem_state  = RegInit(DmemState.Idle)
  val ex1_reg_is_retired   = RegInit(false.B)
  val ex2_reg_is_retired   = RegInit(false.B)
  val mem3_reg_is_retired  = RegInit(false.B)
  val ex1_en               = Wire(Bool())
  val ex2_reg_en           = RegInit(false.B)
  val ex2_wb_data          = Wire(UInt(WORD_LEN.W))

  val if2_reg_inst_id      = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val rrd_reg_inst_id      = Option.when(enable_pipeline_probe)(Wire(UInt(INST_ID_LEN.W))) // (RegInit(0.U(INST_ID_LEN.W)))
  val rrd_i2_inst_id       = Option.when(enable_pipeline_probe)(Wire(UInt(INST_ID_LEN.W)))
  val ex1_reg_inst_id      = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val ex1_reg_i2_inst_id   = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val div_reg_inst_id      = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val ex2_reg_inst_id      = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val mem1_reg_inst_id     = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val mem2_reg_inst_id     = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val mem3_reg_inst_id     = Option.when(enable_pipeline_probe)(RegInit(0.U(INST_ID_LEN.W)))
  val ex2_reg_csr_addr     = Option.when(enable_pipeline_probe)(RegInit(0.U(CSR_ADDR_LEN.W)))
  val ex2_reg_csr_is_ecall = Option.when(enable_pipeline_probe)(RegInit(false.B))

  //**********************************
  // Instruction Fetch And Branch Prediction

  val fetch_unit = Module(new FetchUnit(
    DramConfig(),
    ZBTB_ENTRIES,
    BTB_ENTRIES,
    PHT_INDEX_LEN,
    PHT_HISTORY_LEN,
    RAS_ENTRIES,
    REDIRECT_BUFFER_SIZE,
    enable_pipeline_probe,
  ))
  val idu = Module(new InstructionDecoderUnit(REDIRECT_BUFFER_SIZE, enable_pipeline_probe))
  val lsu = Module(new LoadStoreUnit(enable_pipeline_probe, dram_start, dram_length, LSQ_ENTRIES, SPECUL_ENTRIES, rob_id_len, enable_sim_unaligned))
  val rob = Module(new ReorderBuffer(start_address, IQ_ENTRIES, PHT_HISTORY_LEN, log2Ceil(SPECUL_ENTRIES), enable_pipeline_probe))
  val rf  = Module(new RegisterFile(regsInitMemory, enable_sim_probe))

  idu.io.rob.range <> rob.io.iq_rob_range
  idu.io.rob.upd   <> rob.io.iq_upd_rob
  idu.io.rob.deq1  <> rob.io.iq_deq1
  idu.io.rob.deq2  <> rob.io.iq_deq2
  idu.io.rob.read1 <> rob.io.iq_read1
  idu.io.rob.read2 <> rob.io.iq_read2

  idu.io.rf_sp1 <> rf.io.specul1
  idu.io.rf_sp2 <> rf.io.specul2

  rf.io.stabilize1 <> rob.io.rf_st1
  rf.io.stabilize2 <> rob.io.rf_st2
  rf.io.res <> rob.io.rf_res

  def rf_read(port: Int, paddr: UInt): UInt = {
    rf.io.read(port).paddr := paddr
    rf.io.read(port).rdata
  }

  def rf_write(port: Int, en: Bool, paddr: UInt, wdata: UInt) = {
    rf.io.write(port).en    := en
    rf.io.write(port).paddr := paddr
    rf.io.write(port).wdata := wdata
  }

  fetch_unit.io.ft.flush_en := reg_flush
  fetch_unit.io.ft.flush_iaddr := rob.io.target_pc
  fetch_unit.io.ft.imem <> io.imem
  fetch_unit.io.ft.icache <> io.icache
  fetch_unit.io.ft.inst1.ready := idu.io.in1.ready
  fetch_unit.io.ft.inst2.ready := idu.io.in2.ready
  fetch_unit.io.pht_lmem <> io.pht_lmem
  fetch_unit.io.pht_gmem <> io.pht_gmem

  //**********************************
  // Instruction Fetch (IF) 2 Stage

  val if2_probe_valid1 = idu.io.in1.ready && fetch_unit.io.ft.inst1.valid
  val if2_probe_valid2 = idu.io.in2.ready && fetch_unit.io.ft.inst2.valid
  val if2_inst1 = MuxCase(BUBBLE, Seq(
    fetch_unit.io.ft.inst1.valid    -> fetch_unit.io.ft.inst1.data,
    fetch_unit.io.ft.inst1.bpfailed -> BPFAILURE,
  ))
  val if2_inst2 = MuxCase(BUBBLE, Seq(
    fetch_unit.io.ft.inst2.valid    -> fetch_unit.io.ft.inst2.data,
  ))
  if2_reg_inst_id.foreach(reg => reg := reg + MuxCase(0.U, Seq(
    if2_probe_valid2 -> 2.U,
    if2_probe_valid1 -> 1.U,
  )))
  io.pipeline_probe.foreach(_.if2_valid1 := if2_probe_valid1)
  map2(io.pipeline_probe, if2_reg_inst_id)(_.if2_inst_id1 := _)
  io.pipeline_probe.foreach(_.if2_pc1    := fetch_unit.io.ft.inst1.addr ## 0.U(1.W))
  io.pipeline_probe.foreach(_.if2_inst1  := if2_inst1)
  io.pipeline_probe.foreach(_.if2_valid2 := if2_probe_valid2)
  map2(io.pipeline_probe, if2_reg_inst_id)(_.if2_inst_id2 := _ + 1.U)
  io.pipeline_probe.foreach(_.if2_pc2    := fetch_unit.io.ft.inst2.addr ## 0.U(1.W))
  io.pipeline_probe.foreach(_.if2_inst2  := if2_inst2)
  
  // printf(cf"ic_addr_out: 0x${Cat(ic_addr_out, 0.U(1.W))}%x\n")
  // printf(cf"ic_reg_addr_out: 0x${Cat(fetch_unit.io.ft.inst1.addr, 0.U(1.W))}%x, ic_data_out: 0x${fetch_unit.io.ft.inst1.data}%x\n")
  // printf(cf"ic_imem_addr_4: 0x${ic_imem_addr_4 ## 0.U(1.W)}%x ic_read_en4: ${ic_read_en4} ic_read_en2: ${ic_read_en2}")
  // printf(cf"inst: 0x${if2_inst}%x, ic_read_rdy: ${ic_read_rdy}, ic_state: ${ic_state.asUInt}, ic_addr_en: ${ic_addr_en.asUInt}\n")
  printf(cf"if2_valid1: ${if2_probe_valid1} pc: 0x${fetch_unit.io.ft.inst1.addr ## 0.U(1.W)}%x inst: 0x${if2_inst1}%x\n")
  printf(cf"if2_valid2: ${if2_probe_valid2} pc: 0x${fetch_unit.io.ft.inst2.addr ## 0.U(1.W)}%x inst: 0x${if2_inst2}%x\n")
  printf(cf"flush_en: ${fetch_unit.io.ft.flush_en.asUInt}, flush_iaddr: 0x${fetch_unit.io.ft.flush_iaddr ## 0.U(1.W)}%x\n")

  //**********************************
  // IF2/ID Register

  //**********************************
  // Instruction Decode (ID) Stage

  idu.io.in1.valid         := fetch_unit.io.ft.inst1.valid
  idu.io.in1.inst          := if2_inst1
  idu.io.in1.pc            := fetch_unit.io.ft.inst1.addr
  idu.io.in1.bp.redirected := fetch_unit.io.ft.inst1.valid && fetch_unit.io.ft.inst1.redirected
  idu.io.in1.bp.bpfailed   := fetch_unit.io.ft.inst1.valid && fetch_unit.io.ft.inst1.bpfailed
  idu.io.in1.bp.bp_entry   := fetch_unit.io.ft.inst1.bp_entry
  idu.io.in1.bp.fp_ptr     := fetch_unit.io.ft.inst1.fp_ptr
  idu.io.in2.valid         := fetch_unit.io.ft.inst2.valid
  idu.io.in2.inst          := if2_inst2
  idu.io.in2.pc            := fetch_unit.io.ft.inst2.addr
  idu.io.in2.bp.redirected := fetch_unit.io.ft.inst2.valid && fetch_unit.io.ft.inst2.redirected
  idu.io.in2.bp.bpfailed   := fetch_unit.io.ft.inst2.valid && fetch_unit.io.ft.inst2.bpfailed
  idu.io.in2.bp.bp_entry   := fetch_unit.io.ft.inst2.bp_entry
  idu.io.in2.bp.fp_ptr     := fetch_unit.io.ft.inst2.fp_ptr

  map2(idu.io.in1.inst_id, if2_reg_inst_id)(_ := _)
  map2(idu.io.in2.inst_id, if2_reg_inst_id)(_ := _ + 1.U)

  map2(io.pipeline_probe, idu.io.pipeline_probe.id1a_valid)(_.id1a_valid := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id1a_inst_id)(_.id1a_inst_id := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id1b_valid)(_.id1b_valid := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id1b_inst_id)(_.id1b_inst_id := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id2a_valid)(_.id2a_valid := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id2a_inst_id)(_.id2a_inst_id := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id2b_valid)(_.id2b_valid := _)
  map2(io.pipeline_probe, idu.io.pipeline_probe.id2b_inst_id)(_.id2b_inst_id := _)

  idu.io.lsa1 <> lsu.io.alloc1
  idu.io.lsa2 <> lsu.io.alloc2

  when (idu.io.pasn1.en) {
    scoreboard(idu.io.pasn1.wb_paddr) := true.B
  }
  when (idu.io.pasn2.en) {
    scoreboard(idu.io.pasn2.wb_paddr) := true.B
  }

  //**********************************
  // ID/RRD register
  val id_rrd_ready = !rrd_stall
  val id_rrd_flush = reg_flush
  idu.io.out1.ready := id_rrd_ready
  idu.io.out2.ready := rrd_ready2
  idu.io.out1.pause := false.B
  idu.io.out2.pause := rrd_pause2
  idu.io.flush      := id_rrd_flush
  idu.io.stall      := ex2_reg_stall

  rrd_reg_valid            := idu.io.out1.valid
  rrd_reg_pc               := idu.io.out1.initial.pc
  rrd_rob_id               := idu.io.out1.rob_id
  rrd_lsq_id               := idu.io.out1.lsq_id
  map2(rrd_reg_inst_id, idu.io.out1.initial.inst_id)(_ := _)
  rrd_reg_exe_sel          := idu.io.out1.decoded.exe_sel
  rrd_reg_exe_fun          := idu.io.out1.decoded.exe_fun
  rrd_reg_sop              := idu.io.out1.decoded.sop
  rrd_reg_op1_sel          := idu.io.out1.decoded.op1_sel
  rrd_reg_op2_sel          := idu.io.out1.decoded.op2_sel
  rrd_reg_op3_sel          := idu.io.out1.decoded.op3_sel
  rrd_reg_rs1_addr         := idu.io.out1.decoded.rs1_addr
  rrd_reg_rs2_addr         := idu.io.out1.decoded.rs2_addr
  rrd_reg_rs3_addr         := idu.io.out1.decoded.rs3_addr
  rrd_reg_rs1_paddr        := idu.io.out1.paddrs.rs1_paddr
  rrd_reg_rs2_paddr        := idu.io.out1.paddrs.rs2_paddr
  rrd_reg_rs3_paddr        := idu.io.out1.paddrs.rs3_paddr
  rrd_reg_imm_data         := idu.io.out1.decoded.imm_data
  rrd_reg_rf_wen           := idu.io.out1.decoded.rf_wen
  rrd_reg_wb_paddr         := idu.io.out1.paddrs.wb_paddr
  rrd_reg_is_half          := idu.io.out1.initial.is_half
  rrd_reg_bp               := idu.io.out1.initial.bp

  rrd_i2_valid             := idu.io.out2.valid
  rrd_i2_pc                := idu.io.out2.initial.pc
  rrd_i2_rob_id            := idu.io.out2.rob_id
  rrd_i2_lsq_id            := idu.io.out2.lsq_id
  map2(rrd_i2_inst_id, idu.io.out2.initial.inst_id)(_ := _)
  rrd_i2_exe_sel           := idu.io.out2.decoded.exe_sel
  rrd_i2_exe_fun           := idu.io.out2.decoded.exe_fun
  rrd_i2_sop               := idu.io.out2.decoded.sop
  rrd_i2_op1_sel           := idu.io.out2.decoded.op1_sel
  rrd_i2_op2_sel           := idu.io.out2.decoded.op2_sel
  rrd_i2_op3_sel           := idu.io.out2.decoded.op3_sel
  rrd_i2_rs1_addr          := idu.io.out2.decoded.rs1_addr
  rrd_i2_rs2_addr          := idu.io.out2.decoded.rs2_addr
  rrd_i2_rs3_addr          := idu.io.out2.decoded.rs3_addr
  rrd_i2_rs1_paddr         := idu.io.out2.paddrs.rs1_paddr
  rrd_i2_rs2_paddr         := idu.io.out2.paddrs.rs2_paddr
  rrd_i2_imm_data          := idu.io.out2.decoded.imm_data
  rrd_i2_rf_wen            := idu.io.out2.decoded.rf_wen
  rrd_i2_wb_paddr          := idu.io.out2.paddrs.wb_paddr
  rrd_i2_is_half           := idu.io.out2.initial.is_half
  rrd_i2_redirected        := idu.io.out2.initial.bp.redirected

  //**********************************
  // Register read (RRD) Stage

  rrd_stall :=
    !reg_flush && (
      ex2_reg_stall
    ) || (
      ((rrd_reg_op1_sel    === OP1_SEL_RS)    && scoreboard(rrd_reg_rs1_paddr)) ||
      ((rrd_reg_op2_sel(1) === OP2_SEL_RS(1)) && scoreboard(rrd_reg_rs2_paddr)) ||
      ((rrd_reg_op3_sel(1) === OP3_SEL_RS(1)) && scoreboard(rrd_reg_rs3_paddr))
    ) || (
      rrd_reg_exe_sel === EXE_MD && PAT_DIVREM.matches(rrd_reg_exe_fun) && div_divrem_in_use
    ) || (
      div_divrem_rrd_wb
    )
  // val rrd_i1_wb_addr = Mux(rrd_reg_rf_wen === REN_S, rrd_reg_wb_paddr, 0.U(ADDR_LEN.W))
  rrd_ready2 := (reg_flush || !ex2_reg_stall) /*!rrd_stall*/ &&
    (
      (rrd_i2_exe_sel === EXE_ALU && PAT_CLU_FUN.matches(rrd_i2_exe_fun) && rrd_i2_sop === SOP_NOP) ||
      (rrd_i2_exe_sel === EXE_LD)
    ) &&
    // !rrd_reg_bp.redirected && rrd_reg_exe_sel =/= EXE_JB && rrd_reg_exe_sel =/= EXE_CSR &&
    !rrd_i2_redirected &&
    !lsu.io.out.wb_next &&
    rrd_i2_op3_sel(1) =/= OP3_SEL_RS(1) && !(
      ((rrd_i2_op1_sel    === OP1_SEL_RS)    && (scoreboard(rrd_i2_rs1_paddr))) ||
      ((rrd_i2_op2_sel(1) === OP2_SEL_RS(1)) && (scoreboard(rrd_i2_rs2_paddr)))
    )
  rrd_pause2 := lsu.io.out.wb_next

  def mix(op2_sel: UInt, imm_data: UInt, rs_data: UInt): UInt = {
    // Mux(op2_sel(0) === OP2_SEL_MIX(0), 0.U(1.W) ## imm_data(11, 7) ## rs_data(5, 0), rs_data)
    Mux(op2_sel(0) === OP2_SEL_MIX(0), imm_data(11, 6) ## rs_data(5, 0), rs_data)
  }
  def rmsb(op3_sel: UInt, rs_data: UInt): UInt = {
    Mux(op3_sel(0) === OP3_SEL_RMSB(0), Fill(WORD_LEN, rs_data(WORD_LEN-1)), rs_data)
  }

  val rrd_op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_fw_en &&
      (rrd_reg_op1_sel === OP1_SEL_RS) &&
      (rrd_reg_rs1_paddr === ex1_reg_wb_paddr)) -> ex1_fw_data,
    (ex1_reg_fw2_en &&
      (rrd_reg_op1_sel === OP1_SEL_RS) &&
      (rrd_reg_rs1_paddr === ex1_reg_i2_wb_paddr)) -> ex1_fw2_data,
    (ex2_reg_fw_en &&
      (rrd_reg_op1_sel === OP1_SEL_RS) &&
      (rrd_reg_rs1_paddr === ex2_reg_wb_paddr)) -> ex2_fw_data,
    (rrd_reg_op1_sel === OP1_SEL_RS)  -> rf_read(0, rrd_reg_rs1_paddr),
    (rrd_reg_op1_sel === OP1_SEL_PC)  -> rrd_reg_pc.pc_to_word,
    (rrd_reg_op1_sel === OP1_SEL_IMR) -> 0.U((WORD_LEN-ADDR_LEN).W) ## rrd_reg_rs1_addr,
  ))
  val rrd_op2_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_fw_en &&
      (rrd_reg_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_reg_rs2_paddr === ex1_reg_wb_paddr)) -> mix(rrd_reg_op2_sel, rrd_reg_imm_data, ex1_fw_data),
    (ex1_reg_fw2_en &&
      (rrd_reg_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_reg_rs2_paddr === ex1_reg_i2_wb_paddr)) -> mix(rrd_reg_op2_sel, rrd_reg_imm_data, ex1_fw2_data),
    (ex2_reg_fw_en &&
      (rrd_reg_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_reg_rs2_paddr === ex2_reg_wb_paddr)) -> mix(rrd_reg_op2_sel, rrd_reg_imm_data, ex2_fw_data),
    (rrd_reg_op2_sel(1) === OP2_SEL_RS(1)) -> mix(rrd_reg_op2_sel, rrd_reg_imm_data, rf_read(1, rrd_reg_rs2_paddr)),
    (rrd_reg_op2_sel === OP2_SEL_IMM &&
      rrd_reg_rs2_addr(1, 0) === OP2_IMM_I) -> rrd_reg_imm_data.signed_extend(WORD_LEN),
    (rrd_reg_op2_sel === OP2_SEL_IMM &&
      rrd_reg_rs2_addr(1, 0) === OP2_IMM_B) -> Mux(rrd_reg_rs3_addr(0), Fill(WORD_LEN, 1.U(1.W)), 0.U(25.W) ## rrd_reg_rs3_addr(2, 1) ## rrd_reg_rs2_addr(4, 2) ## rrd_reg_rs3_addr(4, 3)),
    (rrd_reg_op2_sel === OP2_SEL_IMM &&
      rrd_reg_rs2_addr(1, 0) === OP2_IMM_U &&
      !rrd_reg_is_half) -> rrd_reg_imm_data ## rrd_reg_rs1_addr ## rrd_reg_rs3_addr(2, 0) ## 0.U(12.W),
    (rrd_reg_op2_sel === OP2_SEL_IMM &&
      rrd_reg_rs2_addr(1, 0) === OP2_IMM_U &&
      rrd_reg_is_half)  -> rrd_reg_imm_data.signed_extend(20) ## 0.U(12.W),
    (rrd_reg_op2_sel === OP2_SEL_IMM &&
      rrd_reg_rs2_addr(1, 0) === OP2_IMM_J) -> (rrd_reg_imm_data(11) ## rrd_reg_rs1_addr ## rrd_reg_rs3_addr(2, 0) ## rrd_reg_imm_data(0) ## rrd_reg_imm_data(10, 1) ## 0.U(1.W)).signed_extend(WORD_LEN),
  ))
  val rrd_op3_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_fw_en &&
      (rrd_reg_op3_sel(1) === OP3_SEL_RS(1)) &&
      (rrd_reg_rs3_paddr === ex1_reg_wb_paddr))  -> rmsb(rrd_reg_op3_sel, ex1_fw_data),
    (ex1_reg_fw2_en &&
      (rrd_reg_op3_sel(1) === OP3_SEL_RS(1)) &&
      (rrd_reg_rs3_paddr === ex1_reg_i2_wb_paddr)) -> rmsb(rrd_reg_op3_sel, ex1_fw2_data),
    (ex2_reg_fw_en &&
      (rrd_reg_op3_sel(1) === OP3_SEL_RS(1)) &&
      (rrd_reg_rs3_paddr === ex2_reg_wb_paddr))  -> rmsb(rrd_reg_op3_sel, ex2_fw_data),
    (rrd_reg_op3_sel(1) === OP3_SEL_RS(1))     -> rmsb(rrd_reg_op3_sel, rf_read(2, rrd_reg_rs3_paddr)),
  ))

  val rrd_imm_data = MuxCase(rrd_reg_imm_data, Seq(
    // (rrd_reg_exe_fun === CSR_ECALL) -> CSR_ADDR_MCAUSE,
    (rrd_reg_exe_fun === ALU_ADD && rrd_reg_sop === SOP_NOP)
                                    -> rrd_reg_imm_data.replace_lsbits(2, 0.U(2.W)),
    (rrd_reg_exe_fun === ALU_ADD && rrd_reg_sop === SOP_SHAD)
                                    -> rrd_reg_imm_data.replace_lsbits(2, rrd_reg_rs3_addr(2, 1)),
    (BitPat("b10??").matches(rrd_reg_exe_fun) && rrd_reg_op3_sel(0) === OP3_SEL_Z(0))
                                    -> rrd_reg_imm_data(11) ## rrd_reg_imm_data(0) ## rrd_reg_imm_data(10, 1),
    (BitPat("b10??").matches(rrd_reg_exe_fun) && rrd_reg_op3_sel(0) === OP3_SEL_IMBC(0))
                                    -> rrd_reg_imm_data(11) ## rrd_reg_imm_data(11, 1),
  ))

  val rrd_i2_op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_fw_en &&
      (rrd_i2_op1_sel === OP1_SEL_RS) &&
      (rrd_i2_rs1_paddr === ex1_reg_wb_paddr)) -> ex1_fw_data,
    (ex1_reg_fw2_en &&
      (rrd_i2_op1_sel === OP1_SEL_RS) &&
      (rrd_i2_rs1_paddr === ex1_reg_i2_wb_paddr)) -> ex1_fw2_data,
    (ex2_reg_fw_en &&
      (rrd_i2_op1_sel === OP1_SEL_RS) &&
      (rrd_i2_rs1_paddr === ex2_reg_wb_paddr)) -> ex2_fw_data,
    (rrd_i2_op1_sel === OP1_SEL_RS)  -> rf_read(3, rrd_i2_rs1_paddr),
    (rrd_i2_op1_sel === OP1_SEL_PC)  -> rrd_i2_pc.pc_to_word,
  ))
  val rrd_i2_op2_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_fw_en &&
      (rrd_i2_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_i2_rs2_paddr === ex1_reg_wb_paddr)) -> ex1_fw_data,
    (ex1_reg_fw2_en &&
      (rrd_i2_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_i2_rs2_paddr === ex1_reg_i2_wb_paddr)) -> ex1_fw2_data,
    (ex2_reg_fw_en &&
      (rrd_i2_op2_sel(1) === OP2_SEL_RS(1)) &&
      (rrd_i2_rs2_paddr === ex2_reg_wb_paddr)) -> ex2_fw_data,
    (rrd_i2_op2_sel(1) === OP2_SEL_RS(1)) -> rf_read(4, rrd_i2_rs2_paddr),
    (rrd_i2_op2_sel === OP2_SEL_IMM &&
      rrd_i2_rs2_addr(1, 0) === OP2_IMM_I) -> rrd_i2_imm_data.signed_extend(WORD_LEN),
    (rrd_i2_op2_sel === OP2_SEL_IMM &&
      rrd_i2_rs2_addr(1, 0) === OP2_IMM_U &&
      !rrd_i2_is_half) -> rrd_i2_imm_data ## rrd_i2_rs1_addr ## rrd_i2_rs3_addr(2, 0) ## 0.U(12.W),
    (rrd_i2_op2_sel === OP2_SEL_IMM &&
      rrd_i2_rs2_addr(1, 0) === OP2_IMM_U &&
      rrd_i2_is_half)  -> rrd_i2_imm_data.signed_extend(20) ## 0.U(12.W),
  ))

  val rrd_wb = (rrd_reg_rf_wen === REN_S) && rrd_reg_valid && !rrd_stall && !reg_flush
  val rrd_fw_en_next = rrd_wb && (rrd_reg_exe_sel === EXE_ALU)

  val rrd_i2_wb = (rrd_i2_rf_wen === REN_S) && rrd_i2_valid && !reg_flush
  val rrd_fw2_en_next = (rrd_i2_wb && rrd_ready2) || lsu.io.out.fw_en_next

  val rrd_mem_use_reg   = WireDefault(false.B)
  val rrd_inst2_use_reg = WireDefault(false.B)
  val rrd_inst3_use_reg = WireDefault(false.B)

  val rrd_i2lsu_wb_paddr = Mux(rrd_i2_wb && !lsu.io.out.wb_next, rrd_i2_wb_paddr, lsu.io.out.wb_paddr_next)

  when (rrd_wb) {
    when (rrd_reg_exe_sel === EXE_ALU) {
      scoreboard(rrd_reg_wb_paddr) := false.B
    }
    // scoreboard(rrd_reg_wb_paddr) := rrd_reg_exe_sel =/= EXE_ALU
    rrd_mem_use_reg   := (rrd_reg_exe_sel === EXE_LD  || rrd_reg_exe_sel === EXE_ST)
    rrd_inst2_use_reg := (rrd_reg_exe_sel === EXE_BLU || rrd_reg_exe_sel === EXE_JB)
    rrd_inst3_use_reg := ((rrd_reg_exe_sel === EXE_MD && !PAT_DIVREM.matches(rrd_reg_exe_fun))
                                                      || rrd_reg_exe_sel === EXE_CSR)
  }

  // lsu.io.out.wb_next && !lsu.io.out.fw_en_next  : do not update scoreboard, updated by lsu.io.out.wb_nofw
  // !lsu.io.out.wb_next && !lsu.io.out.fw_en_next : update scoreboard(rrd_i2_wb_paddr) to !rrd_ready2
  // lsu.io.out.wb_next && lsu.io.out.fw_en_next   : reset scoreboard(lsu.io.out.wb_paddr_next)
  when ((rrd_i2_wb && rrd_ready2 && rrd_i2_exe_sel(2) === EXE_ALU(2) && !lsu.io.out.wb_next) || lsu.io.out.fw_en_next) {
    scoreboard(rrd_i2lsu_wb_paddr) := false.B
  }

  fetch_unit.io.redir_read.ptr := rrd_reg_bp.fp_ptr

  // rob.io.enq1.en     := rrd_reg_valid && !rrd_stall
  // rob.io.enq1.rob_id := rrd_rob_id
  // map2(rob.io.enq1.inst_id, rrd_reg_inst_id)(_ := _)
  // rob.io.enq2.en     := rrd_i2_valid && rrd_ready2
  // rob.io.enq2.rob_id := rrd_i2_rob_id
  // map2(rob.io.enq2.inst_id, rrd_i2_inst_id)(_ := _)

  io.pipeline_probe.foreach(_.rrd_valid := rrd_reg_valid && !reg_flush)
  io.pipeline_probe.foreach(_.rrd_i2_valid := rrd_i2_valid && !reg_flush)
  map2(io.pipeline_probe, rrd_reg_inst_id)(_.rrd_inst_id := _)
  map2(io.pipeline_probe, rrd_i2_inst_id)(_.rrd_i2_inst_id := _)

  //**********************************
  // RRD/EX1 register
  ex1_reg_pc               := rrd_reg_pc
  ex1_reg_rob_id           := rrd_rob_id
  ex1_reg_lsq_id           := rrd_lsq_id
  // ex1_reg_exe_sel          := rrd_reg_exe_sel
  ex1_reg_exe_fun          := rrd_reg_exe_fun
  ex1_reg_sop              := rrd_reg_sop
  ex1_reg_op1_data         := rrd_op1_data
  ex1_reg_op2_data         := rrd_op2_data
  ex1_reg_op3_data         := rrd_op3_data
  ex1_reg_wb_paddr         := rrd_reg_wb_paddr
  ex1_reg_imm_data         := rrd_imm_data
  ex1_reg_bp               := rrd_reg_bp
  ex1_reg_fp_entry         := fetch_unit.io.redir_read.fp_entry
  ex1_reg_is_half          := rrd_reg_is_half
  ex1_reg_mem_use_reg      := rrd_mem_use_reg
  ex1_reg_inst2_use_reg    := rrd_inst2_use_reg
  ex1_reg_inst3_use_reg    := rrd_inst3_use_reg
  ex1_reg_fw_en            := rrd_fw_en_next
  map2(ex1_reg_inst_id, rrd_reg_inst_id)(_ := _)
  ex1_reg_valid            := rrd_reg_valid && !rrd_stall
  ex1_reg_exe_sel          := Mux(!rrd_reg_valid || rrd_stall, EXE_ALU, rrd_reg_exe_sel)
  ex1_reg_lsu_enq          := // Mux(!rrd_reg_valid || rrd_stall,
    // false.B,
    rrd_reg_exe_sel === EXE_ST || rrd_reg_exe_sel === EXE_LD ||
    (rrd_reg_exe_sel === EXE_CSR && PAT_FENCE.matches(rrd_reg_exe_fun))
  // )
  ex1_reg_rf_wen           := Mux(!rrd_reg_valid || rrd_stall, REN_X, rrd_reg_rf_wen)
  ex1_reg_bp.redirected    := Mux(!rrd_reg_valid || rrd_stall, false.B, rrd_reg_bp.redirected)
  ex1_reg_bp.bpfailed      := Mux(!rrd_reg_valid || rrd_stall, false.B, rrd_reg_bp.bpfailed)
  div_reg_en               := rrd_reg_valid && !rrd_stall && PAT_DIVREM.matches(rrd_reg_exe_fun) && rrd_reg_exe_sel === EXE_MD
  ex1_reg_i2_pc            := rrd_i2_pc
  ex1_reg_i2_rob_id        := rrd_i2_rob_id
  ex1_reg_i2_lsq_id        := rrd_i2_lsq_id
  ex1_reg_i2_is_alu        := (rrd_i2_exe_sel === EXE_ALU)
  ex1_reg_i2_exe_fun       := rrd_i2_exe_fun
  // ex1_reg_i2_sop           := rrd_i2_sop
  ex1_reg_i2_op1_data      := rrd_i2_op1_data
  ex1_reg_i2_op2_data      := rrd_i2_op2_data
  ex1_reg_i2_wb_paddr      := rrd_i2lsu_wb_paddr
  ex1_reg_i2_rf_wen        := Mux(!rrd_i2_valid || !rrd_ready2 || (rrd_i2_exe_sel(2) =/= EXE_ALU(2)), REN_X, rrd_i2_rf_wen)
  ex1_reg_fw2_en           := rrd_fw2_en_next
  ex1_reg_i2_valid         := rrd_i2_valid && rrd_ready2
  map2(ex1_reg_i2_inst_id, rrd_i2_inst_id)(_ := _)
  when (reg_flush || ex2_reg_stall) {
    ex1_reg_valid         := false.B
    ex1_reg_rf_wen        := REN_X
    ex1_reg_bp.redirected := false.B
    ex1_reg_bp.bpfailed   := false.B
    div_reg_en            := false.B
    ex1_reg_i2_valid      := false.B
    ex1_reg_i2_rf_wen     := REN_X
  }

  //**********************************
  // Execute (EX1) Stage

  val ex1_add_out = Mux(
    PAT_BR.matches(ex1_reg_exe_fun),
    ex1_reg_pc.pc_to_word + ex1_reg_imm_data.signed_extend(PC_LEN).pc_to_word,
    ex1_reg_op1_data + ex1_reg_op2_data
  )
  val ex1_sign = Mux(ex1_reg_imm_data(10), ex1_reg_op1_data(15), ex1_reg_op1_data(7))
  val ex1_is_lt = Mux(
    ex1_reg_sop === SOP_SGN,
    ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt,
    ex1_reg_op1_data < ex1_reg_op2_data,
  )
  val ex1_is_eq = Mux(
    ex1_reg_sop === SOP_NOP,
     (ex1_reg_op1_data === ex1_reg_op2_data),
    !(ex1_reg_op1_data === ex1_reg_op2_data)
  )

  val ex1_alu_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_exe_fun === ALU_ADD)     -> ((ex1_reg_op1_data << ex1_reg_imm_data(1, 0))(WORD_LEN-1, 0) + ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_SUB)     -> (ex1_reg_op1_data - Mux(ex1_reg_sop === SOP_NOP, ex1_reg_op2_data, 0.U(WORD_LEN.W))),
    (ex1_reg_exe_fun === ALU_XOR)     -> (ex1_reg_op1_data ^ Mux(ex1_reg_sop === SOP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_AND)     -> (ex1_reg_op1_data & Mux(ex1_reg_sop === SOP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_OR)      -> (ex1_reg_op1_data | Mux(ex1_reg_sop === SOP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_FSL)     -> (Cat(ex1_reg_op1_data, ex1_reg_op3_data(WORD_LEN-1, 1)) >> (~ex1_reg_op2_data)(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_exe_fun === ALU_FSR)     -> (Cat(ex1_reg_op3_data(WORD_LEN-2, 0), ex1_reg_op1_data) >> ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_exe_fun === ALU_CMOV)    -> Mux(0.U(WORD_LEN.W) < ex1_reg_op2_data, ex1_reg_op1_data, ex1_reg_op3_data),
    (ex1_reg_exe_fun === ALU_SLT)     -> ex1_is_lt.asUInt,
    (ex1_reg_exe_fun === ALU_SEQ)     -> ex1_is_eq.asUInt,
    (ex1_reg_exe_fun === ALU_SZEXT)   -> Cat((0 until WORD_LEN).reverse.map(bit => Mux(
      bit.U(4, 3) < Cat(ex1_reg_imm_data(10), ~ex1_reg_imm_data(10)),
      ex1_reg_op1_data(bit),
      Mux(ex1_reg_sop === SOP_SEXT, ex1_sign, 0.U(1.W)),
    ))),
    (ex1_reg_exe_fun === ALU_MIN)     -> Mux(ex1_is_lt, ex1_reg_op1_data, ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_MAX)     -> Mux(ex1_is_lt, ex1_reg_op2_data, ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_BCLR)    -> (ex1_reg_op1_data & ~("x_80000000".U(WORD_LEN.W) >> ~ex1_reg_op2_data(4, 0))),
    (ex1_reg_exe_fun === ALU_BSET)    -> (ex1_reg_op1_data |  ("x_80000000".U(WORD_LEN.W) >> ~ex1_reg_op2_data(4, 0))),
    (ex1_reg_exe_fun === ALU_BEXT)    -> 0.U((WORD_LEN-1).W) ## (ex1_reg_op1_data >> ex1_reg_op2_data(4, 0))(0),
  ))

  val ex1_i2_add_out = ex1_reg_i2_op1_data + ex1_reg_i2_op2_data

  val ex1_clu_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_i2_exe_fun(2, 0) === ALU_ADD(2, 0)) -> ex1_i2_add_out,
    (ex1_reg_i2_exe_fun(2, 0) === ALU_SUB(2, 0)) -> (ex1_reg_i2_op1_data - ex1_reg_i2_op2_data),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_XOR(2, 0)) -> (ex1_reg_i2_op1_data ^ ex1_reg_i2_op2_data),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_AND(2, 0)) -> (ex1_reg_i2_op1_data & ex1_reg_i2_op2_data),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_OR(2, 0))  -> (ex1_reg_i2_op1_data | ex1_reg_i2_op2_data),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_FSL(2, 0)) -> (ex1_reg_i2_op1_data << ex1_reg_i2_op2_data(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_FSR(2, 0)) -> (ex1_reg_i2_op1_data >> ex1_reg_i2_op2_data(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_i2_exe_fun(2, 0) === ALU_SLT(2, 0)) -> (ex1_reg_i2_op1_data < ex1_reg_i2_op2_data).asUInt,
  ))

  ex1_fw2_data := Mux(ex1_reg_i2_rf_wen === REN_S, ex1_clu_out, lsu.io.out.fw_data)

  val ex1_i2_wb_data = Mux(ex1_reg_i2_rf_wen === REN_S, ex1_clu_out, lsu.io.out.wb_data)

  val rf_wen_1 = ((ex1_reg_i2_rf_wen === REN_S && (!reg_flush && !ex2_reg_stall)) || lsu.io.out.wb_en)
  rf_write(1, rf_wen_1, ex1_reg_i2_wb_paddr, ex1_i2_wb_data)
    // regsel(ex1_reg_i2_wb_paddr) := 1.U
    // regfile2a(ex1_reg_i2_wb_paddr) := ex1_i2_wb_data
    // regfile2b(ex1_reg_i2_wb_paddr) := ex1_i2_wb_data

  val ex1_i2_valid = ex1_reg_i2_valid && (!reg_flush && !ex2_reg_stall)
  ex1_reg_is_retired := ex1_i2_valid

  rob.io.enq1.en     := ex1_reg_valid
  rob.io.enq1.rob_id := ex1_reg_rob_id
  map2(rob.io.enq1.inst_id, ex1_reg_inst_id)(_ := _)
  rob.io.enq2.en     := ex1_reg_i2_valid
  rob.io.enq2.rob_id := ex1_reg_i2_rob_id
  map2(rob.io.enq2.inst_id, ex1_reg_i2_inst_id)(_ := _)

  // rob.io.fin1.en     := ex1_i2_valid || lsu.io.out.is_retired
  // rob.io.fin1.rob_id := Mux(lsu.io.out.is_retired, lsu.io.out.rob_id, ex1_reg_i2_rob_id)
  // rob.io.fin1.wb_addr.map(_ := Mux(lsu.io.out.is_retired,
  //   Mux(lsu.io.out.wb_en, lsu.io.out.wb_addr, 0.U(ADDR_LEN.W)),
  //   Mux(ex1_reg_i2_rf_wen === REN_S, ex1_reg_i2_wb_paddr, 0.U(ADDR_LEN.W)),
  // ))
  // rob.io.fin1.wb_data.map(_ := Mux(lsu.io.out.is_retired, lsu.io.out.wb_data, ex1_clu_out))
  rob.io.fin1.en     := ex1_i2_valid && ex1_reg_i2_is_alu
  rob.io.fin1.rob_id := ex1_reg_i2_rob_id
  // rob.io.fin1.wb_addr.map(_ := Mux(ex1_reg_i2_rf_wen === REN_S, ex1_reg_i2_wb_paddr, 0.U(ADDR_LEN.W)))
  rob.io.fin1.wb_data.map(_ := ex1_clu_out)

  val ex1_mul_op1_data = Mux(PAT_MULHS1.matches(ex1_reg_exe_fun),
    ex1_reg_op1_data.asSInt.sext,
    ex1_reg_op1_data.zext,
  )
  val ex1_mul_op2_data = Mux(PAT_MULHS2.matches(ex1_reg_exe_fun),
    ex1_reg_op2_data.asSInt.sext,
    ex1_reg_op2_data.zext,
  )
  val ex1_mull = (ex1_mul_op1_data * ex1_mul_op2_data.asUInt.take(24)).asUInt
  val ex1_mulh = (ex1_mul_op1_data * ex1_mul_op2_data(32, 24).asSInt).asUInt

  def scatter_bit(value: UInt, mask: UInt, bit: Int): UInt = {
    if (bit == 0) {
      Mux(mask(bit).asBool, value(0), 0.U(1.W))
    } else {
      Mux(mask(bit).asBool, (value >> PopCount(mask(bit - 1, 0)))(0), 0.U(1.W))
    }
  }

  def shift_or(value: UInt, enable: Bool, stage: Int): UInt = {
    Cat((0 until WORD_LEN).reverse.map(bit => value(bit) | Mux(enable, value(bit ^ (1 << stage)), 0.U(1.W))))
  }
  def nested_shift_or(value: UInt, enables: UInt, stage: Int): UInt = {
    if (stage > 0) {
      val nested = nested_shift_or(value, enables, stage - 1)
      shift_or(nested, enables(stage), stage)
    } else {
      shift_or(value, enables(stage), stage)
    }
  }

  // val ex1_mask_len = Mux(ex1_reg_is_bflen, ex1_reg_imm_len, ex1_reg_op2_data(10, 6))
  val ex1_mask_len = ex1_reg_op2_data(10, 6)
  val ex1_imm_mask = Mux(ex1_mask_len === 0.U,
    Fill(WORD_LEN, 1.U(1.W)),
    Cat((0 until WORD_LEN).reverse.map(bit => (bit.U < ex1_mask_len).asUInt)),
  )
  val ex1_bfx_sign_pos = ex1_mask_len +& ex1_reg_op2_data(4, 0)
  val ex1_bfx_sign_shift = Mux(ex1_bfx_sign_pos(5) || ex1_mask_len === 0.U, 0.U(5.W), ex1_bfx_sign_pos(4, 0))
  val ex1_bfx_sext = Fill(
    WORD_LEN,
    (Cat(ex1_reg_op1_data(WORD_LEN-2, 0), ex1_reg_op1_data(WORD_LEN-1)) >> ex1_bfx_sign_shift)(0)
  )
  val ex1_bfx_mask = Mux(ex1_bfx_sign_pos(5) || ex1_mask_len === 0.U,
    Cat((0 until WORD_LEN).map(bit => (!(bit.U < ex1_reg_op2_data(4, 0))).asUInt)),
    Cat((0 until WORD_LEN).reverse.map(bit => (bit.U < ex1_mask_len).asUInt)),
  )

  val ex1_next_pc   = Mux(ex1_reg_is_half, ex1_reg_pc + 1.U(PC_LEN.W), ex1_reg_pc + 2.U(PC_LEN.W))
  val ex1_latter_pc = Mux(ex1_reg_is_half, ex1_reg_pc, ex1_reg_pc + 1.U(PC_LEN.W))
  val ex1_blu_out   = MuxCase(ex1_next_pc.pc_to_word, Seq(
    (ex1_reg_exe_fun === BLU_CPOP)  -> PopCount(ex1_reg_op1_data),
    (ex1_reg_exe_fun === BLU_CLZ)   -> PriorityEncoder(Cat(1.U(1.W), Reverse(ex1_reg_op1_data))),
    (ex1_reg_exe_fun === BLU_CTZ)   -> PriorityEncoder(Cat(1.U(1.W), ex1_reg_op1_data)),
    (ex1_reg_exe_fun === BLU_REV8)  -> Cat(ex1_reg_op1_data(7, 0), ex1_reg_op1_data(15, 8), ex1_reg_op1_data(23, 16), ex1_reg_op1_data(31, 24)),
    // (ex1_reg_exe_fun === BLU_BSCTH) -> Cat((0 until 16).reverse.map(bit => scatter_bit(ex1_reg_op1_data, ex1_reg_op2_data, bit))),
    PAT_BFM_BFP.matches(ex1_reg_exe_fun)
                                    -> (ex1_imm_mask << ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0),
    PAT_BFX.matches(ex1_reg_exe_fun)
                                    -> ex1_bfx_mask,
    (ex1_reg_exe_fun === BLU_GORC)  -> nested_shift_or(ex1_reg_op1_data, ex1_reg_op2_data, 4),
    (ex1_reg_exe_fun === BLU_BINV)  -> (ex1_reg_op1_data ^ ("x_80000000".U(WORD_LEN.W) >> ~ex1_reg_op2_data(4, 0))),
  ))

  val ex1_fun_sel = MuxCase(EX2_ALU, Seq(
    (ex1_reg_exe_sel === EXE_BLU && PAT_BF.matches(ex1_reg_exe_fun)) -> EX2_MASK,
    (ex1_reg_exe_sel === EXE_BLU || ex1_reg_exe_sel === EXE_JB)      -> EX2_BLU,
    (ex1_reg_exe_sel === EXE_CSR)                                    -> EX2_CSR,
    (ex1_reg_exe_sel === EXE_MD)                                     -> EX2_MD,
  ))

  val div_pc       = WireDefault(ex1_reg_pc)
  val div_op1_data = WireDefault(ex1_reg_op1_data)
  val div_op2_data = WireDefault(ex1_reg_op2_data)
  val div_en       = Wire(Bool())
  val div_signed   = Wire(Bool())
  val div_unsigned = Wire(Bool())
  val div_is_div   = Wire(Bool())
  val div_wen      = Wire(Bool())
  val div_rob_id   = Wire(UInt(rob_id_ptr_len.W))
  val div_wb_paddr  = Wire(UInt(PHYS_ADDR_LEN.W))
  val div_inst_id  = Option.when(enable_pipeline_probe)(Wire(UInt(INST_ID_LEN.W)))

  div_en       := div_reg_en && ex1_en
  div_signed   := PAT_DIV_SIGNED.matches(ex1_reg_exe_fun)
  div_unsigned := PAT_DIV_UNSIGNED.matches(ex1_reg_exe_fun)
  div_is_div   := ex1_reg_exe_fun === MD_DIV || ex1_reg_exe_fun === MD_DIVU
  div_wen      := Mux(ex1_reg_rf_wen === REN_S && ex1_en, REN_S, REN_X)
  div_rob_id   := ex1_reg_rob_id
  div_wb_paddr := ex1_reg_wb_paddr
  map2(div_inst_id, ex1_reg_inst_id)(_ := _)

  // branch and jump
  val ex1_maybe_br_taken = Wire(Bool())
  val ex1_is_br = ex1_reg_exe_sel === EXE_JB &&  PAT_BR.matches(ex1_reg_exe_fun)
  val ex1_is_j  = ex1_reg_exe_sel === EXE_JB && !PAT_BR.matches(ex1_reg_exe_fun)
  ex1_maybe_br_taken := Lookup(ex1_reg_exe_fun, false.B, Seq(
    PAT_BEQ -> ex1_is_eq,
    PAT_BLT -> ex1_is_lt,
    PAT_BGE -> !ex1_is_lt,
  ))
  val ex1_is_br_taken  = ex1_maybe_br_taken && ex1_is_br
  val ex1_fetch_pc = Mux(ex1_is_br_taken || ex1_is_j, ex1_add_out.word_to_pc, ex1_next_pc)
  val ex1_csr_fetch_pc = Mux(csr_is_br, csr_br_pc, ex1_fetch_pc)
  val ex1_predict_pc = Mux(ex1_reg_bp.redirected, ex1_reg_fp_entry.target, ex1_next_pc)
  val ex1_bp_failure = ex1_fetch_pc =/= ex1_predict_pc
  val ex1_actual_attr = MuxCase(BTB_ATTR_INVAL, Seq(
    (ex1_reg_exe_sel === EXE_JB && PAT_BR.matches(ex1_reg_exe_fun)) -> BTB_ATTR_BR,
    (ex1_reg_exe_sel === EXE_JB && ex1_reg_exe_fun === JB_DJUMP)    -> ex1_reg_exe_fun.take(2),
    (ex1_reg_exe_sel === EXE_JB && ex1_reg_exe_fun === JB_DCALL)    -> ex1_reg_exe_fun.take(2),
    (ex1_reg_exe_sel === EXE_JB && ex1_reg_exe_fun === JB_OTHER)    -> BTB_ATTR_DJUMP,
  ))
  val ex1_actual_is_ret = (ex1_reg_exe_sel === EXE_JB && ex1_reg_exe_fun === JB_RET)

  ex1_fetch_pc_en := ex1_en && ex1_bp_failure && (!reg_flush && !ex2_reg_stall)

  when (ex1_en && ex1_is_br) {
    when (ex1_reg_bp.bp_entry.lcnt(0) && (ex1_reg_bp.bp_entry.gcnt === 2.U(2.W))) {
      when (ex1_is_br_taken) {
        printf(cf"PHT local correct\n")
      }.otherwise {
        printf(cf"PHT global correct\n")
      }
    }.elsewhen (!ex1_reg_bp.bp_entry.lcnt(0) && (ex1_reg_bp.bp_entry.gcnt === 3.U(2.W))) {
      when (ex1_is_br_taken) {
        printf(cf"PHT global correct\n")
      }.otherwise {
        printf(cf"PHT local correct\n")
      }
    }
  }

  rob.io.redir.en                  := ex1_en /*&& (!reg_flush && !ex2_reg_stall)*/ || csr_is_br
  rob.io.redir.redir_en            := ex1_fetch_pc_en || csr_is_br
  rob.io.redir.target_pc           := ex1_csr_fetch_pc
  rob.io.redir.rob_id              := ex1_reg_rob_id
  rob.io.redir.intr_mtimer.foreach(_ := mtimer.io.intr)
  rob.io.redir.intr_ext.foreach(_    := io.intr)
  rob.io.redir.correction.en       := ex1_en
  // rob.io.redir.correction.pc       := ex1_latter_pc
  // rob.io.redir.correction.bp_entry := ex1_reg_bp.bp_entry
  rob.io.redir.correction.fp_attr  := ex1_reg_fp_entry.attr
  rob.io.redir.correction.fp_hit   := ex1_reg_bp.redirected
  rob.io.redir.correction.mispred  := ex1_bp_failure && (!reg_flush && !ex2_reg_stall)
  // rob.io.redir.correction.br_taken := ex1_is_br_taken
  // rob.io.redir.correction.attr     := ex1_actual_attr
  // rob.io.redir.correction.is_ret   := ex1_actual_is_ret
  rob.io.redir.correction.target   := ex1_fetch_pc
  // rob.io.redir.correction.next_pc  := ex1_next_pc

  rob.io.bp_upd.en              := ex1_en && (ex1_reg_bp.redirected || ex1_reg_exe_sel === EXE_JB)
  rob.io.bp_upd.rob_id          := ex1_reg_rob_id
  rob.io.bp_upd.entry.latter_pc := ex1_latter_pc
  rob.io.bp_upd.entry.bp_entry  := ex1_reg_bp.bp_entry
  rob.io.bp_upd.entry.history   := ex1_reg_fp_entry.history
  rob.io.bp_upd.entry.br_taken  := ex1_is_br_taken
  rob.io.bp_upd.entry.attr      := ex1_actual_attr
  rob.io.bp_upd.entry.is_ret    := ex1_actual_is_ret
  rob.io.bp_upd.entry.next_pc   := ex1_next_pc

  lsu.io.put1.en       := ex1_en && ex1_reg_lsu_enq
  lsu.io.put1.memop    := ex1_reg_exe_sel.take(MEM_OP_LEN)
  lsu.io.put1.addr     := ex1_add_out
  lsu.io.put1.memw     := ex1_reg_exe_fun.take(MW_LEN)
  lsu.io.put1.wdata    := ex1_reg_op3_data
  lsu.io.put1.wb_paddr := ex1_reg_wb_paddr
  lsu.io.put1.rob_id   := ex1_reg_rob_id
  lsu.io.put1.lsq_id   := ex1_reg_lsq_id
  map2(lsu.io.put1.inst_id, ex1_reg_inst_id)(_ := _)

  lsu.io.put2.en       := ex1_i2_valid && !ex1_reg_i2_is_alu
  lsu.io.put2.addr     := ex1_i2_add_out
  lsu.io.put2.memw     := ex1_reg_i2_exe_fun.take(MW_LEN)
  lsu.io.put2.wb_paddr := ex1_reg_i2_wb_paddr
  lsu.io.put2.rob_id   := ex1_reg_i2_rob_id
  lsu.io.put2.lsq_id   := ex1_reg_i2_lsq_id
  map2(lsu.io.put2.inst_id, ex1_reg_i2_inst_id)(_ := _)

  lsu.io.flush.en       := ex1_fetch_pc_en || csr_is_br
  lsu.io.flush.preserve := ex1_reg_lsu_enq
    // ex1_reg_exe_sel === EXE_ST || ex1_reg_exe_sel === EXE_LD ||
    // (ex1_reg_exe_sel === EXE_CSR && PAT_FENCE.matches(ex1_reg_exe_fun))

  val ex1_redir_deq_en = ex1_en && ex1_reg_bp.redirected && (!reg_flush && !ex2_reg_stall)
  fetch_unit.io.redir_deq.en := ex1_redir_deq_en
  fetch_unit.io.redir_deq.ptr.map(_ := ex1_reg_bp.fp_ptr)

  ex1_fw_data := ex1_alu_out

  when (ex1_reg_inst2_use_reg || (!ex1_en && (ex1_reg_mem_use_reg || ex1_reg_inst3_use_reg || div_reg_en))) {
    scoreboard(ex1_reg_wb_paddr) := false.B
  }

  val ex1_hazard = (ex1_reg_rf_wen === REN_S) && (ex1_reg_wb_paddr =/= 0.U) && ex1_en
  val ex1_fw_en_next = ex1_hazard && (ex1_reg_exe_sel =/= EXE_MD) && (ex1_reg_exe_sel =/= EXE_LD)

  val csr_valid = ex1_reg_valid && (!reg_flush && !ex2_reg_stall)

  io.pipeline_probe.foreach(_.ex1_valid := csr_valid)
  io.pipeline_probe.foreach(_.ex1_i2_valid := ex1_i2_valid)
  map2(io.pipeline_probe, ex1_reg_inst_id)(_.ex1_inst_id := _)
  map2(io.pipeline_probe, ex1_reg_i2_inst_id)(_.ex1_i2_inst_id := _)

  io.pipeline_probe.foreach(_.ex1_predict_redirected := ex1_reg_bp.redirected)
  io.pipeline_probe.foreach(_.ex1_predict_bpfailed   := ex1_reg_bp.bpfailed)
  io.pipeline_probe.foreach(_.ex1_predict_attr       := ex1_reg_fp_entry.attr)
  io.pipeline_probe.foreach(_.ex1_predict_is_ret     := ex1_reg_fp_entry.is_ret)
  io.pipeline_probe.foreach(_.ex1_predict_target_pc  := ex1_predict_pc)
  io.pipeline_probe.foreach(_.ex1_history            := ex1_reg_fp_entry.history)
  io.pipeline_probe.foreach(_.ex1_lcnt               := ex1_reg_bp.bp_entry.lcnt)
  io.pipeline_probe.foreach(_.ex1_gcnt               := ex1_reg_bp.bp_entry.gcnt)
  io.pipeline_probe.foreach(_.ex1_actual_redirected  := ex1_is_br_taken || ex1_is_j)
  io.pipeline_probe.foreach(_.ex1_actual_attr        := ex1_actual_attr)
  io.pipeline_probe.foreach(_.ex1_actual_is_ret      := ex1_actual_is_ret)
  io.pipeline_probe.foreach(_.ex1_actual_target_pc   := ex1_fetch_pc)

  //**********************************
  // EX1 CSR Stage

  val csr_mie_fw_en = WireDefault(false.B)
  val csr_mie_meie_fw = WireDefault(false.B)
  val csr_mie_mtie_fw = WireDefault(false.B)
  val csr_mstatus_mie_fw_en = WireDefault(false.B)
  val csr_mstatus_mie_fw = WireDefault(false.B)
  val csr_reg_is_meintr = RegNext(
    Mux(csr_mstatus_mie_fw_en, csr_mstatus_mie_fw, csr_reg_mstatus_mie) &&
      io.intr &&
      Mux(csr_mie_fw_en, csr_mie_meie_fw, csr_reg_mie_meie)
  )
  val csr_reg_is_mtintr = RegNext(
    Mux(csr_mstatus_mie_fw_en, csr_mstatus_mie_fw, csr_reg_mstatus_mie) &&
      mtimer.io.intr &&
      Mux(csr_mie_fw_en, csr_mie_mtie_fw, csr_reg_mie_mtie)
  )

  // val csr_valid = ex1_reg_valid && (!reg_flush && !ex2_reg_stall)
  val csr_is_meintr = csr_reg_is_meintr && csr_valid
  val csr_is_mtintr = csr_reg_is_mtintr && csr_valid
  ex1_en := csr_valid && !csr_is_meintr && !csr_is_mtintr
  val ex1_is_ecall = ex1_reg_exe_sel === EXE_CSR && ex1_reg_exe_fun === CSR_ECALL
  val ex1_is_mret  = ex1_reg_exe_sel === EXE_CSR && ex1_reg_exe_fun === CSR_MRET
  val csr_is_ecall = ex1_en && ex1_is_ecall
  val ex1_valid    = csr_valid && !ex1_is_ecall
  val csr_is_mret  = ex1_en && ex1_is_mret
  val ex1_csr_addr = ex1_reg_imm_data

  def decode_mcause(mcause_code: UInt): UInt = {
    MuxCase(CSR_MCAUSE_X, Seq(
      (mcause_code === CSR_MCAUSE_CODE_MEI)     -> CSR_MCAUSE_MEI,
      (mcause_code === CSR_MCAUSE_CODE_MTI)     -> CSR_MCAUSE_MTI,
      (mcause_code === CSR_MCAUSE_CODE_ECALL_M) -> CSR_MCAUSE_ECALL_M,
    ))
  }

  val csr_rdata = MuxLookup(ex1_csr_addr, 0.U(WORD_LEN.W))(Seq(
    CSR_ADDR_MTVEC    -> Cat(csr_reg_trap_vector, 0.U((WORD_LEN-PC_LEN).W)),
    CSR_ADDR_TIME     -> mtimer.io.mtime(31, 0),
    CSR_ADDR_CYCLE    -> cycle_counter.io.value(31, 0),
    CSR_ADDR_INSTRET  -> instret(31, 0),
    CSR_ADDR_CYCLEH   -> cycle_counter.io.value(63, 32),
    CSR_ADDR_TIMEH    -> mtimer.io.mtime(63, 32),
    CSR_ADDR_INSTRETH -> instret(63, 32),
    CSR_ADDR_MEPC     -> Cat(csr_reg_mepc, 0.U((WORD_LEN-PC_LEN).W)),
    CSR_ADDR_MCAUSE   -> decode_mcause(csr_reg_mcause_code),
    // CSR_ADDR_MTVAL   -> csr_mtval,
    CSR_ADDR_MSTATUS  -> Cat(0.U(24.W), csr_reg_mstatus_mpie.asUInt, 0.U(3.W), csr_reg_mstatus_mie.asUInt, 0.U(3.W)),
    CSR_ADDR_MSCRATCH -> csr_reg_mscratch,
    CSR_ADDR_MIE      -> Cat(0.U(20.W), csr_reg_mie_meie.asUInt, 0.U(3.W), csr_reg_mie_mtie.asUInt, 0.U(7.W)),
    CSR_ADDR_MIP      -> Cat(0.U(20.W), io.intr.asUInt, 0.U(3.W), mtimer.io.intr.asUInt, 0.U(7.W)),
  ))

  val csr_wdata = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_exe_fun === CSR_W) -> ex1_reg_op1_data,
    (ex1_reg_exe_fun === CSR_S) -> (csr_rdata | ex1_reg_op1_data),
    (ex1_reg_exe_fun === CSR_C) -> (csr_rdata & ~ex1_reg_op1_data),
  ))

  when (ex1_en && ex1_reg_exe_sel === EXE_CSR) {
    when (ex1_csr_addr === CSR_ADDR_MTVEC) {
      csr_reg_trap_vector   := csr_wdata(WORD_LEN-1, WORD_LEN-PC_LEN)
    }.elsewhen (ex1_csr_addr === CSR_ADDR_MEPC) {
      csr_reg_mepc          := csr_wdata(WORD_LEN-1, WORD_LEN-PC_LEN)
    }.elsewhen (ex1_csr_addr === CSR_ADDR_MSTATUS) {
      csr_reg_mstatus_mie   := csr_wdata(3)
      csr_reg_mstatus_mpie  := csr_wdata(7)
      csr_mstatus_mie_fw_en := true.B
      csr_mstatus_mie_fw    := csr_wdata(3)
    }.elsewhen (ex1_csr_addr === CSR_ADDR_MSCRATCH) {
      csr_reg_mscratch      := csr_wdata
    }.elsewhen (ex1_csr_addr === CSR_ADDR_MIE) {
      csr_reg_mie_meie      := csr_wdata(11)
      csr_reg_mie_mtie      := csr_wdata(7)
      csr_mie_fw_en         := true.B
      csr_mie_meie_fw       := csr_wdata(11)
      csr_mie_mtie_fw       := csr_wdata(7)
    }
  }

  // csr_mip := Cat(csr_mip(31, 12), io.intr.asUInt, csr_mip(10, 8), mtimer.io.intr.asUInt, csr_mip(6, 0))

  when (csr_is_meintr) {
    csr_reg_mcause_code   := CSR_MCAUSE_CODE_MEI
    // csr_mtval          := 0.U(WORD_LEN.W)
    csr_reg_mepc          := ex1_next_pc
    csr_reg_mstatus_mpie  := csr_reg_mstatus_mie
    csr_reg_mstatus_mie   := false.B
    csr_mstatus_mie_fw_en := true.B
    csr_mstatus_mie_fw    := false.B
    csr_is_br             := true.B
    csr_br_pc             := csr_reg_trap_vector
  }.elsewhen (csr_is_mtintr) {
    csr_reg_mcause_code   := CSR_MCAUSE_CODE_MTI
    // csr_mtval          := 0.U(WORD_LEN.W)
    csr_reg_mepc          := ex1_next_pc
    csr_reg_mstatus_mpie  := csr_reg_mstatus_mie
    csr_reg_mstatus_mie   := false.B
    csr_mstatus_mie_fw_en := true.B
    csr_mstatus_mie_fw    := false.B
    csr_is_br             := true.B
    csr_br_pc             := csr_reg_trap_vector
  }.elsewhen (csr_is_ecall) {
    csr_reg_mcause_code   := CSR_MCAUSE_CODE_ECALL_M
    // csr_mtval          := ex1_reg_mtval
    csr_reg_mepc          := ex1_next_pc
    csr_reg_mstatus_mpie  := csr_reg_mstatus_mie
    csr_reg_mstatus_mie   := false.B
    csr_mstatus_mie_fw_en := true.B
    csr_mstatus_mie_fw    := false.B
    csr_is_br             := true.B
    csr_br_pc             := csr_reg_trap_vector
  }.elsewhen (csr_is_mret) {
    csr_reg_mstatus_mpie  := true.B
    csr_reg_mstatus_mie   := csr_reg_mstatus_mpie
    csr_mstatus_mie_fw_en := true.B
    csr_mstatus_mie_fw    := csr_reg_mstatus_mpie
    csr_is_br             := true.B
    csr_br_pc             := csr_reg_mepc
  }.otherwise {
    csr_is_br             := false.B
    csr_br_pc             := csr_reg_trap_vector
  }

  ex2_reg_stall := (ex1_fetch_pc_en || csr_is_br) || (ex2_reg_stall && !reg_flush)

  reg_flush     := rob.io.flush
  reg_target_pc := rob.io.target_pc

  val ex1_no_mem = (
    ex1_reg_exe_sel =/= EXE_LD &&
    ex1_reg_exe_sel =/= EXE_ST &&
    (ex1_reg_exe_sel =/= EXE_CSR || !PAT_FENCE.matches(ex1_reg_exe_fun))
  )

  //**********************************
  // EX1/EX2 register
  ex2_reg_pc                := Mux(div_divrem_ex1_wb, div_reg_pc, ex1_reg_pc)
  ex2_reg_rob_id            := Mux(div_divrem_ex1_wb, div_reg_rob_id, ex1_reg_rob_id)
  ex2_reg_wb_paddr          := Mux(div_divrem_ex1_wb, div_reg_wb_paddr, ex1_reg_wb_paddr) // Ignore the case of writing back to x0
  ex2_reg_alu_out           := ex1_alu_out
  ex2_reg_mull              := ex1_mull
  ex2_reg_mulh              := ex1_mulh
  ex2_reg_blu_out           := ex1_blu_out
  ex2_reg_csr_rdata         := csr_rdata
  ex2_reg_csr_addr.foreach(_ := ex1_csr_addr)
  ex2_reg_csr_is_ecall.foreach(_ := csr_is_ecall)
  ex2_reg_exe_fun           := Mux(div_divrem_ex1_wb, Mux(div_reg_is_div, MD_DIV, MD_REM), ex1_reg_exe_fun)
  ex2_reg_rf_wen            := Mux(div_divrem_ex1_wb, REN_S, Mux(csr_valid && ex1_no_mem, ex1_reg_rf_wen, REN_X))
  ex2_reg_fun_sel           := Mux(div_divrem_ex1_wb, EXE_MD, ex1_fun_sel)
  ex2_reg_op3_data          := Mux(ex1_reg_exe_fun === BLU_BFX && ex1_reg_sop === SOP_SEXT, ex1_bfx_sext, ex1_reg_op3_data)
  ex2_reg_valid             := ex1_valid && ex1_no_mem && !(ex1_reg_exe_sel === EXE_MD && PAT_DIVREM.matches(ex1_reg_exe_fun)) || div_divrem_ex1_wb
  ex2_reg_processed         := csr_valid && ex1_no_mem && !(ex1_reg_exe_sel === EXE_MD && PAT_DIVREM.matches(ex1_reg_exe_fun)) || div_divrem_ex1_wb
  ex2_reg_inst3_use_reg     := Mux(div_divrem_ex1_wb, true.B, ex1_reg_inst3_use_reg && ex1_en)
  ex2_reg_fw_en             := ex1_fw_en_next
  map3(ex2_reg_inst_id, ex1_reg_inst_id, div_reg_inst_id)(_ := Mux(!div_divrem_ex1_wb, _, _))

  //**********************************
  // EX2 MUL/DIV Stage

  def signExtend40(value: UInt, w: Int): UInt = {
      Fill(40 - w, value(w - 1)) ## value(w - 1, 0)
  }

  val ex2_md_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex2_reg_exe_fun === MD_MUL)    -> (ex2_reg_mull.take(WORD_LEN) + (ex2_reg_mulh.take(8) << 24)),
    (ex2_reg_exe_fun === MD_MULH || ex2_reg_exe_fun === MD_MULHU || ex2_reg_exe_fun === MD_MULHSU)
                                     -> (signExtend40(ex2_reg_mull(33+24-1, 24), 33) + ex2_reg_mulh.take(40))(39, 8),
    (ex2_reg_exe_fun === MD_DIV)    -> div_reg_quotient,
    (ex2_reg_exe_fun === MD_DIVU)   -> div_reg_quotient,
    (ex2_reg_exe_fun === MD_REM)    -> div_reg_reminder,
    (ex2_reg_exe_fun === MD_REMU)   -> div_reg_reminder,
  ))

  val div_reg_divrem_state  = RegInit(DivremState.Idle)
  val div_reg_init_divisor  = RegInit(0.U(WORD_LEN.W))
  val div_reg_orig_dividend = RegInit(0.U(WORD_LEN.W))
  val div_reg_sign_op1      = RegInit(0.U(1.W))
  val div_reg_sign_op12     = RegInit(0.U(1.W))
  val div_reg_zero_op2      = RegInit(false.B)
  val div_reg_dividend      = RegInit(0.S((WORD_LEN+5).W))
  val div_reg_divisor       = RegInit(0.U((WORD_LEN+4).W))
  val div_reg_p_divisor     = RegInit(0.U((WORD_LEN*2).W))
  val div_reg_divrem_count  = RegInit(0.U(5.W))
  val div_reg_rem_shift     = RegInit(0.U(5.W))
  val div_reg_extra_shift   = RegInit(false.B)
  val div_reg_d             = RegInit(0.U(3.W))

  div_divrem_in_use := div_reg_divrem_state =/= DivremState.Idle || div_reg_en
  div_divrem_rrd_wb := false.B
  div_divrem_ex1_wb := false.B

  switch (div_reg_divrem_state) {
    is (DivremState.Idle) {
      val div_dividend = Wire(UInt((WORD_LEN+5).W))
      val div_divisor = Wire(UInt(WORD_LEN.W))

      when (div_signed) {
        when (div_op1_data(WORD_LEN-1) === 1.U) {
          div_dividend := 0.U(5.W) ## (~div_op1_data + 1.U)(WORD_LEN-1, 0)
        }.otherwise {
          div_dividend := 0.U(5.W) ## div_op1_data(WORD_LEN-1, 0)
        }
        val sign_op1 = div_op1_data(WORD_LEN-1)
        div_reg_sign_op1 := sign_op1
        when (div_op2_data(WORD_LEN-1) === 1.U) {
          div_divisor   := (~div_op2_data + 1.U)(WORD_LEN-1, 0)
          div_reg_sign_op12 := (sign_op1 === 0.U)
        }.otherwise {
          div_divisor   := div_op2_data
          div_reg_sign_op12 := (sign_op1 === 1.U)
        }
      }.otherwise { // elsewhen (div_unsigned) {
        div_dividend  := 0.U(5.W) ## div_op1_data(WORD_LEN-1, 0)
        div_reg_sign_op1  := 0.U
        div_divisor   := div_op2_data
        div_reg_sign_op12 := 0.U
      }
      div_reg_zero_op2      := (div_op2_data === 0.U)
      div_reg_orig_dividend := div_op1_data
      div_reg_init_divisor  := div_divisor
      div_reg_is_div        := div_is_div

      when (div_en) {
        when (div_divisor(WORD_LEN-1, 2) === 0.U) {
          div_reg_divrem_state := DivremState.Dividing
        }.otherwise {
          div_reg_divrem_state := DivremState.Placing
        }
      }
      div_reg_dividend     := div_dividend.asSInt
      div_reg_divisor      := div_divisor(3, 0) ## 0.U(32.W)
      div_reg_p_divisor    := div_divisor ## 0.U(32.W)
      div_reg_divrem_count := 0.U
      div_reg_rem_shift    := 0.U
      div_reg_quotient     := 0.U
      when (div_divisor(1) === 0.U) {
        div_reg_extra_shift := false.B
        div_reg_d           := 0.U(3.W)
      }.otherwise {
        div_reg_extra_shift := true.B
        div_reg_d           := div_divisor(0) ## 0.U(2.W)
      }
      div_reg_pc            := div_pc
      div_reg_rob_id        := div_rob_id
      div_reg_wb_paddr      := div_wb_paddr
      map2(div_reg_inst_id, div_inst_id)(_ := _)
    }
    is (DivremState.Placing) {
      when (div_reg_p_divisor(WORD_LEN*2-1, WORD_LEN+4) === 0.U) {
        div_reg_divrem_state := DivremState.Dividing
      }
      div_reg_p_divisor    := div_reg_p_divisor >> 2
      div_reg_divisor      := (div_reg_p_divisor >> 2)(WORD_LEN+3, 0)
      div_reg_divrem_count := div_reg_divrem_count + 1.U
      when (div_reg_p_divisor(WORD_LEN+3) === 0.U) {
        div_reg_extra_shift := false.B
        div_reg_d           := div_reg_p_divisor(WORD_LEN+1, WORD_LEN-1)
      }.otherwise {
        div_reg_extra_shift := true.B
        div_reg_d           := div_reg_p_divisor(WORD_LEN+2, WORD_LEN)
      }
    }
    is (DivremState.Dividing) {
      val p = Mux(div_reg_extra_shift,
        Mux(div_reg_dividend(WORD_LEN+4) === 0.U,
          div_reg_dividend(WORD_LEN+3, WORD_LEN-1),
          ~div_reg_dividend(WORD_LEN+3, WORD_LEN-1),
        ),
        Mux(div_reg_dividend(WORD_LEN+4) === 0.U,
          div_reg_dividend(WORD_LEN+2, WORD_LEN-2),
          ~div_reg_dividend(WORD_LEN+2, WORD_LEN-2),
        ),
      )
      val div_table = Seq(
          Seq(0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
          Seq(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
      )
      val div_q = MuxLookup(div_reg_d, 0.U(2.W))(
        div_table.zipWithIndex.map{
          case (v, i) => i.U -> MuxLookup(p, 0.U(2.W))(v.zipWithIndex.map { case (x, i) => i.U -> x.U })
        }
      )

      when (div_reg_dividend(WORD_LEN+4) === 0.U) {
        div_reg_dividend := MuxCase(div_reg_dividend << 2, Seq(
          (div_q(0) === 1.U) -> ((div_reg_dividend - Cat(0.U(1.W), div_reg_divisor).asSInt) << 2),
          (div_q(1) === 1.U) -> ((div_reg_dividend - Cat(div_reg_divisor, 0.U(1.W)).asSInt) << 2),
        ))
        div_reg_quotient := MuxCase(div_reg_quotient << 2, Seq(
          (div_q(0) === 1.U) -> ((div_reg_quotient << 2) + 1.U),
          (div_q(1) === 1.U) -> ((div_reg_quotient << 2) + 2.U),
        ))
      }.otherwise {
        div_reg_dividend := MuxCase(div_reg_dividend << 2, Seq(
          (div_q(0) === 1.U) -> ((div_reg_dividend + Cat(0.U(1.W), div_reg_divisor).asSInt) << 2),
          (div_q(1) === 1.U) -> ((div_reg_dividend + Cat(div_reg_divisor, 0.U(1.W)).asSInt) << 2),
        ))
        div_reg_quotient := MuxCase(div_reg_quotient << 2, Seq(
          (div_q(0) === 1.U) -> ((div_reg_quotient << 2) - 1.U),
          (div_q(1) === 1.U) -> ((div_reg_quotient << 2) - 2.U),
        ))
      }
      div_reg_rem_shift := div_reg_rem_shift + 1.U
      div_reg_divrem_count := div_reg_divrem_count + 1.U
      when (div_reg_divrem_count === 16.U) {
        div_reg_divrem_state := DivremState.Shifting
      }
    }
    is (DivremState.Shifting) {
      div_reg_reminder := (div_reg_dividend >> Cat(div_reg_rem_shift, 0.U(1.W)))(WORD_LEN-1, 0)
      div_reg_divrem_state := DivremState.Correction
      div_divrem_rrd_wb := true.B
    }
    is (DivremState.Correction) {
      val reminder = Mux(div_reg_dividend(WORD_LEN+4) === 1.U,
        div_reg_reminder + div_reg_init_divisor(WORD_LEN-1, 0),
        div_reg_reminder,
      )
      div_reg_reminder := Mux(div_reg_zero_op2,
        div_reg_orig_dividend,
        Mux(div_reg_sign_op1 === 0.U,
          reminder,
          ~reminder + 1.U,
        ),
      )
      val quotient = Mux(div_reg_dividend(WORD_LEN+4) === 1.U,
        div_reg_quotient - 1.U,
        div_reg_quotient,
      )
      div_reg_quotient := Mux(div_reg_zero_op2,
        0xFFFF_FFFFL.U,
        Mux(div_reg_sign_op12 === 0.U,
          quotient,
          ~quotient + 1.U,
        ),
      )
      div_reg_divrem_state := DivremState.Finished
      div_divrem_ex1_wb := true.B
    }
    is (DivremState.Finished) {
      div_reg_divrem_state := DivremState.Idle
    }
  }
  // printf(cf"div_reg_divrem_state : 0x${div_reg_divrem_state.asUInt}%x\n")
  // printf(cf"div_reg_dividend     : 0x${div_reg_dividend}%x\n")
  // printf(cf"div_reg_divisor      : 0x${div_reg_divisor}%x\n")
  // printf(cf"div_reg_divrem_count : 0x${div_reg_divrem_count}%x\n")
  // printf(cf"div_reg_rem_shift    : 0x${div_reg_rem_shift}%x\n")

  //**********************************
  // EX2 Stage
  val ex2_mask_out = Cat((0 until WORD_LEN).reverse.map(bit => Mux(ex2_reg_blu_out(bit), ex2_reg_alu_out(bit), ex2_reg_op3_data(bit))))

  ex2_wb_data := MuxCase(ex2_reg_alu_out, Seq(
    (ex2_reg_fun_sel === EX2_MASK)       -> ex2_mask_out,
    (ex2_reg_fun_sel === EX2_BLU)        -> ex2_reg_blu_out,
    PAT_EX2_CSR.matches(ex2_reg_fun_sel) -> ex2_reg_csr_rdata,
    PAT_EX2_MD.matches(ex2_reg_fun_sel)  -> ex2_md_out,
  ))

  ex2_fw_data := MuxCase(ex2_reg_alu_out, Seq(
    PAT_EX2_MASK.matches(ex2_reg_fun_sel) -> ex2_mask_out,
    PAT_EX2_BLU.matches(ex2_reg_fun_sel)  -> ex2_reg_blu_out,
  ))
  when (ex2_reg_inst3_use_reg) {
    scoreboard(ex2_reg_wb_paddr) := false.B
  }

  ex2_reg_is_retired := ex2_reg_valid

  // In case where ex1_i2 and ex2 write to the same register at the same time, ex1_i2 has priority.
  // when (ex2_reg_rf_wen === REN_S && !(ex1_reg_i2_rf_wen === REN_S && (!reg_flush && !ex2_reg_stall) && (ex1_reg_i2_wb_paddr === ex2_reg_wb_paddr))) {
  val rf_wen_0 = (ex2_reg_rf_wen === REN_S)
  rf_write(0, rf_wen_0, ex2_reg_wb_paddr, ex2_wb_data)
    // regsel(ex2_reg_wb_paddr) := 0.U
    // regfile1a(ex2_reg_wb_paddr) := ex2_wb_data
    // regfile1b(ex2_reg_wb_paddr) := ex2_wb_data

  rob.io.fin2.en        := ex2_reg_processed
  rob.io.fin2.rob_id    := ex2_reg_rob_id
  // rob.io.fin2.wb_addr.foreach(_ := Mux(ex2_reg_rf_wen === REN_S, ex2_reg_wb_paddr, 0.U(ADDR_LEN.W)))
  rob.io.fin2.wb_data.foreach(_ := ex2_wb_data)
  rob.io.fin2.csr_read.foreach(_ := ex2_reg_valid && PAT_EX2_CSR.matches(ex2_reg_fun_sel) && ex2_reg_rf_wen === REN_S)
  map2(rob.io.fin2.csr_addr, ex2_reg_csr_addr)(_ := _)
  rob.io.fin2.csr_data.foreach(_ := ex2_reg_csr_rdata)
  map2(rob.io.fin2.csr_is_ecall, ex2_reg_csr_is_ecall)(_ := _)

  io.pipeline_probe.foreach(_.ex2_valid := ex2_reg_valid)
  map2(io.pipeline_probe, ex2_reg_inst_id)(_.ex2_inst_id := _)

  lsu.io.dmem <> io.dmem
  lsu.io.cache <> io.cache

  lsu.io.expire_specul1 <> rob.io.expire_specul1
  lsu.io.expire_specul2 <> rob.io.expire_specul2

  lsu.io.flush_specul := reg_flush

  // when (lsu.io.out.fw_en_next) {
  //   scoreboard(lsu.io.out.fw_wb_paddr) := false.B
  // }
  when (lsu.io.out.wb_nofw) {
    scoreboard(lsu.io.out.wb_paddr) := false.B
  }

  rob.io.fin3.en              := lsu.io.out.is_retired
  rob.io.fin3.rob_id          := lsu.io.out.rob_id
  rob.io.fin3.is_specul_load  := lsu.io.out.is_specul_load
  rob.io.fin3.specul_id       := lsu.io.out.specul_id
  rob.io.fin3.load_order_fail := lsu.io.out.load_order_fail
  // map2(rob.io.fin3.wb_addr, lsu.io.pipeline_probe)(_ := _.mem3_wb_addr)
  map2(rob.io.fin3.wb_data, lsu.io.pipeline_probe)(_ := _.mem3_data)

  fetch_unit.io.cr.en            := rob.io.cr_out.en
  fetch_unit.io.cr.fp_attr       := rob.io.cr_out.fp_attr
  fetch_unit.io.cr.fp_hit        := rob.io.cr_out.fp_hit
  fetch_unit.io.cr.mispred       := rob.io.cr_out.mispred
  fetch_unit.io.cr.target        := rob.io.cr_out.target
  fetch_unit.io.cr.upd.en        := rob.io.upd_out.en
  fetch_unit.io.cr.upd.latter_pc := rob.io.upd_out.latter_pc
  fetch_unit.io.cr.upd.bp_entry  := rob.io.upd_out.bp_entry
  fetch_unit.io.cr.upd.history   := rob.io.upd_out.history
  fetch_unit.io.cr.upd.br_taken  := rob.io.upd_out.br_taken
  fetch_unit.io.cr.upd.attr      := rob.io.upd_out.attr
  fetch_unit.io.cr.upd.is_ret    := rob.io.upd_out.is_ret
  fetch_unit.io.cr.upd.next_pc   := rob.io.upd_out.next_pc

  instret := instret + PopCount(Seq(ex1_reg_is_retired, ex2_reg_is_retired, lsu.io.out.is_retired))

  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem1_valid   := _.mem1_valid)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem1_inst_id := _.mem1_inst_id)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem2_valid   := _.mem2_valid)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem2_inst_id := _.mem2_inst_id)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem3_valid   := _.mem3_valid)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem3_inst_id := _.mem3_inst_id)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem3_is_load := _.mem3_is_load)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem3_addr    := _.mem3_addr)
  map2(io.pipeline_probe, lsu.io.pipeline_probe)(_.mem3_data    := _.mem3_data)

  io.pipeline_probe.map(_.retire1_valid := rob.io.retire1.valid)
  map2(io.pipeline_probe, rob.io.retire1.inst_id)(_.retire1_inst_id := _)
  map2(io.pipeline_probe, rob.io.retire1.wb_addr)(_.retire1_wb_addr := _)
  map2(io.pipeline_probe, rob.io.retire1.wb_data)(_.retire1_wb_data := _)
  map2(io.pipeline_probe, rob.io.retire1.csr_read)(_.csr_read := _)
  map2(io.pipeline_probe, rob.io.retire1.csr_addr)(_.csr_addr := _)
  map2(io.pipeline_probe, rob.io.retire1.csr_data)(_.csr_data := _)
  map2(io.pipeline_probe, rob.io.retire1.intr_mtimer)(_.intr_mtimer := _)
  map2(io.pipeline_probe, rob.io.retire1.intr_ext)(_.intr_ext := _)
  io.pipeline_probe.map(_.retire2_valid := rob.io.retire2.valid)
  map2(io.pipeline_probe, rob.io.retire2.inst_id)(_.retire2_inst_id := _)
  map2(io.pipeline_probe, rob.io.retire2.wb_addr)(_.retire2_wb_addr := _)
  map2(io.pipeline_probe, rob.io.retire2.wb_data)(_.retire2_wb_data := _)

  io.pipeline_probe.map(_.flush_pipeline := reg_flush)

  // Debug signals
  io.debug_signal.cycle_counter       := cycle_counter.io.value(47, 0)
  // io.debug_signal.csr_rdata        := csr_rdata
  // io.debug_signal.ex1_reg_csr_addr := ex1_csr_addr
  io.debug_signal.ex2_reg_pc          := Cat(ex2_reg_pc, 0.U((WORD_LEN-PC_LEN).W))
  io.debug_signal.ex2_is_valid_inst   := ex2_reg_valid
  io.debug_signal.me_intr             := csr_is_meintr
  io.debug_signal.mt_intr             := csr_is_mtintr
  io.debug_signal.trap                := csr_is_ecall
  io.debug_signal.id_pc               := idu.io.debug_signals.id_pc1
  io.debug_signal.id_inst             := idu.io.debug_signals.id_inst1
  io.debug_signal.mem3_rdata          := lsu.io.debug_signals.mem3_rdata
  io.debug_signal.mem3_rvalid         := lsu.io.debug_signals.mem3_rvalid
  io.debug_signal.rwaddr              := ex2_wb_data
  io.debug_signal.ex2_reg_is_br       := reg_flush
  io.debug_signal.id_reg_bp_taken     := false.B // id_reg_bp_taken
  io.debug_signal.if2_zbp_taken       := false.B // if2_zbp_taken
  io.debug_signal.ic_state            := 0.U // ic_state.asUInt

  //**********************************
  // IO & Debug
  if (enable_sim_probe) {
    val reg_gp = RegInit(0.U(WORD_LEN.W))
    val reg_a7 = RegInit(0.U(WORD_LEN.W))
    val gp = WireDefault(reg_gp)
    val a7 = WireDefault(reg_a7)
    when (rob.io.retire1.valid && rob.io.retire1.wb_addr.getOrElse(0.U) === 3.U) {
      gp := rob.io.retire1.wb_data.getOrElse(0.U)
    }
    when (rob.io.retire2.valid && rob.io.retire2.wb_addr.getOrElse(0.U) === 3.U) {
      gp := rob.io.retire2.wb_data.getOrElse(0.U)
    }
    when (rob.io.retire1.valid && rob.io.retire1.wb_addr.getOrElse(0.U) === 17.U) {
      a7 := rob.io.retire1.wb_data.getOrElse(0.U)
    }
    when (rob.io.retire2.valid && rob.io.retire2.wb_addr.getOrElse(0.U) === 17.U) {
      a7 := rob.io.retire2.wb_data.getOrElse(0.U)
    }
    reg_gp := gp
    reg_a7 := a7
    io.sim_probe.foreach(_.gp := gp)
    // val a7 = MuxCase(rf_read(6, 17.U), Seq(
    //   (ex1_reg_fw_en  && (ex1_reg_wb_paddr === 17.U))    -> ex1_fw_data,
    //   (ex1_reg_fw2_en && (ex1_reg_i2_wb_paddr === 17.U)) -> ex1_fw2_data,
    //   (ex2_reg_fw_en  && (ex2_reg_wb_paddr === 17.U))    -> ex2_fw_data,
    // ))
    val is_ecall = rob.io.retire1.valid && rob.io.retire1.csr_is_ecall.getOrElse(false.B)
    val exit = is_ecall && (a7 === 93.U(WORD_LEN.W))
    val do_exit = exit
    io.sim_probe.foreach(_.exit := do_exit.asUInt)
    printf(cf"csr_is_ecall        : ${is_ecall}\n")
    printf(cf"regfile(17)         : 0x${a7}%x\n")
    printf(cf"exit                : ${exit}\n")
    printf(cf"do_exit             : ${do_exit}\n")
  }

  // printf(cf"ic_addr_out      : 0x${Cat(ic_addr_out, 0.U(1.W))}%x\n")
  //printf(cf"if1_reg_pc       : 0x${if1_reg_pc}%x\n")
  printf(cf"if2_valid1       : ${if2_probe_valid1}%d\n")
  printf(cf"if2_pc1          : 0x${fetch_unit.io.ft.inst1.addr ## 0.U(1.W)}%x\n")
  printf(cf"if2_reg_inst_id1 : ${if2_reg_inst_id.getOrElse(0)}%d\n")
  printf(cf"if2_inst1        : 0x${if2_inst2}%x\n")
  printf(cf"if2_valid2       : ${if2_probe_valid2}%d\n")
  printf(cf"if2_pc2          : 0x${fetch_unit.io.ft.inst2.addr ## 0.U(1.W)}%x\n")
  printf(cf"if2_reg_inst_id2 : ${if2_reg_inst_id.map(_ + 1.U).getOrElse(0)}%d\n")
  printf(cf"if2_inst2        : 0x${if2_inst2}%x\n")
  // printf(cf"if2_zbp_taken    : ${if2_zbp_taken}%d\n")
  // printf(cf"ic_zbp_target    : 0x${Cat(ic_zbp_target, 0.U(1.W))}%x\n")
  // printf(cf"ic_bp_taken      : ${ic_bp.taken}%d\n")
  // printf(cf"ic_bp_attr       : 0x${ic_bp.attr}%x\n")
  // printf(cf"ic_bp_rasindex   : 0x${ic_ras.io.top.index}%x\n")
  // printf(cf"ic_bp_target     : 0x${Cat(ic_bp.target, 0.U(1.W))}%x\n")
  // printf(cf"ic_bp_cnt        : 0x${ic_bp.cnt}%x\n")
  // printf(cf"ic_bp_gcnt       : 0x${ic_bp.gcnt}%x\n")
  printf(cf"id_valid         : ${idu.io.pipeline_probe.id1a_valid.getOrElse(false.B)}%d\n")
  printf(cf"id_reg_pc        : 0x${idu.io.debug_signals.id_pc1 ## 0.U(1.W)}%x\n")
  printf(cf"id_reg_inst      : 0x${idu.io.debug_signals.id_inst1}%x\n")
  when (idu.io.pipeline_probe.id1b_valid.getOrElse(false.B)) {
    printf(cf"id_reg_pc2       : 0x${idu.io.debug_signals.id_pc2 ## 0.U(1.W)}%x\n")
    printf(cf"id_reg_inst2     : 0x${idu.io.debug_signals.id_inst2}%x\n")
  }
  // printf(cf"id_reg_bp_taken  : ${id_reg_bp_taken}%d\n")
  // printf(cf"id_reg_bp_target : 0x${Cat(id_reg_bp_target, 0.U(1.W))}%x\n")
  printf(cf"id_stall         : ${!idu.io.in1.ready}%d\n")
  // printf(cf"id_rs1_data      : 0x${id_rs1_data}%x\n")
  // printf(cf"id_rs2_data      : 0x${id_rs2_data}%x\n")
  // printf(cf"id_wb_addr       : 0x${id_wb_addr}%x\n")
  printf(cf"rrd_reg_pc       : 0x${Cat(rrd_reg_pc, 0.U(1.W))}%x\n")
  printf(cf"rrd_reg_valid    : ${rrd_reg_valid}%d\n")
  printf(cf"rrd_reg_inst_id  : ${rrd_reg_inst_id.getOrElse(0)}%d\n")
  printf(cf"rrd_stall        : ${rrd_stall}%d\n")
  printf(cf"rrd_reg_bp.fp_ptr: 0x${rrd_reg_bp.fp_ptr}%x\n")
  printf(cf"rrd_op1_data     : 0x${rrd_op1_data}%x\n")
  printf(cf"rrd_op2_data     : 0x${rrd_op2_data}%x\n")
  printf(cf"rrd_op3_data     : 0x${rrd_op3_data}%x\n")
  printf(cf"rrd_reg_imm_data : 0x${rrd_reg_imm_data}%x\n")
  printf(cf"rrd_reg_op1_sel  : 0x${rrd_reg_op1_sel}%x\n")
  // printf(cf"ex1_reg_fw_en    : ${ex1_reg_fw_en}%d\n")
  printf(cf"rrd_reg_rs1_addr : 0x${rrd_reg_rs1_addr}%x\n")
  printf(cf"rrd_reg_rs2_addr : 0x${rrd_reg_rs2_addr}%x\n")
  printf(cf"rrd_reg_rs3_addr : 0x${rrd_reg_rs3_addr}%x\n")
  printf(cf"rrd_reg_rs1_paddr: 0x${rrd_reg_rs1_paddr}%x\n")
  printf(cf"rrd_reg_rs2_paddr: 0x${rrd_reg_rs2_paddr}%x\n")
  printf(cf"rrd_reg_rs3_paddr: 0x${rrd_reg_rs3_paddr}%x\n")
  printf(cf"rrd_reg_wb_paddr : 0x${rrd_reg_wb_paddr}%x\n")
  printf(cf"rrd_reg_rf_wen   : 0x${rrd_reg_rf_wen}%x\n")
  // printf(cf"rrd_reg_wb_sel   : 0x${rrd_reg_wb_sel}%x\n")
  // printf(cf"rrd_reg_is_br    : 0x${rrd_reg_is_br}%x\n")
  printf(cf"rrd_ready2       : ${rrd_ready2}%d\n")
  printf(cf"rrd_i2_pc        : 0x${Cat(rrd_i2_pc, 0.U(1.W))}%x\n")
  printf(cf"rrd_i2_valid     : ${rrd_i2_valid}%d\n")
  printf(cf"rrd_i2_inst_id   : ${rrd_i2_inst_id.getOrElse(0)}%d\n")
  printf(cf"rrd_i2_op1_data  : 0x${rrd_i2_op1_data}%x\n")
  printf(cf"rrd_i2_op2_data  : 0x${rrd_i2_op2_data}%x\n")
  printf(cf"rrd_i2_imm_data  : 0x${rrd_i2_imm_data}%x\n")
  printf(cf"rrd_i2_rs1_addr  : 0x${rrd_i2_rs1_addr}%x\n")
  printf(cf"rrd_i2_rs2_addr  : 0x${rrd_i2_rs2_addr}%x\n")
  printf(cf"rrd_i2_rs1_paddr : 0x${rrd_i2_rs1_paddr}%x\n")
  printf(cf"rrd_i2_rs2_paddr : 0x${rrd_i2_rs2_paddr}%x\n")
  printf(cf"rrd_i2_wb_paddr  : 0x${rrd_i2_wb_paddr}%x\n")
  printf(cf"rrd_i2_rf_wen    : 0x${rrd_i2_rf_wen}%x\n")
  printf(cf"scoreboard       : 0x${Cat((0 until 32).map(i => scoreboard(i).asUInt).reverse)}%x\n")
  printf(cf"ex1_reg_fw_en    : ${ex1_reg_fw_en}\n")
  printf(cf"ex1_reg_wb_paddr  : 0x${ex1_reg_wb_paddr}%x\n")
  printf(cf"ex1_fw_data      : 0x${ex1_fw_data}%x\n")
  printf(cf"ex1_reg_pc       : 0x${Cat(ex1_reg_pc, 0.U(1.W))}%x\n")
  printf(cf"ex1_reg_valid    : ${ex1_reg_valid}%d\n")
  printf(cf"ex1_reg_inst_id  : ${ex1_reg_inst_id.getOrElse(0)}%d\n")
  printf(cf"ex1_reg_rob_id   : ${ex1_reg_rob_id}%d\n")
  printf(cf"ex1_reg_op1_data : 0x${ex1_reg_op1_data}%x\n")
  printf(cf"ex1_reg_op2_data : 0x${ex1_reg_op2_data}%x\n")
  printf(cf"ex1_reg_op3_data : 0x${ex1_reg_op3_data}%x\n")
  printf(cf"ex1_reg_imm_data : 0x${ex1_reg_imm_data}%x\n")
  printf(cf"ex1_alu_out      : 0x${ex1_alu_out}%x\n")
  printf(cf"ex1_blu_out      : 0x${ex1_blu_out}%x\n")
  printf(cf"ex1_reg_exe_sel  : 0x${ex1_reg_exe_sel}%x\n")
  printf(cf"ex1_reg_exe_fun  : 0x${ex1_reg_exe_fun}%x\n")
  // printf(cf"ex1_reg_sop    : 0x${ex1_reg_sop}%x\n")
  printf(cf"ex1_reg_wb_paddr  : 0x${ex1_reg_wb_paddr}%x\n")
  printf(cf"ex1_reg_fw2_en      : ${ex1_reg_fw2_en}\n")
  // printf(cf"ex1_reg_i2_wb_paddr : 0x${ex1_reg_i2_wb_paddr}%x\n")
  printf(cf"ex1_fw2_data        : 0x${ex1_fw2_data}%x\n")
  printf(cf"ex1_reg_i2_pc       : 0x${ex1_reg_i2_pc.pc_to_word}%x\n")
  printf(cf"ex1_reg_i2_valid    : ${ex1_reg_i2_valid}%d\n")
  printf(cf"ex1_reg_i2_exe_fun  : 0x${ex1_reg_i2_exe_fun}%x\n")
  printf(cf"ex1_reg_i2_inst_id  : ${ex1_reg_i2_inst_id.getOrElse(0)}%d\n")
  printf(cf"ex1_reg_id2_rob_id  : ${ex1_reg_i2_rob_id}%d\n")
  printf(cf"ex1_reg_i2_op1_data : 0x${ex1_reg_i2_op1_data}%x\n")
  printf(cf"ex1_reg_i2_op2_data : 0x${ex1_reg_i2_op2_data}%x\n")
  printf(cf"ex1_clu_out         : 0x${ex1_clu_out}%x\n")
  printf(cf"ex1_reg_i2_rf_wen   : ${ex1_reg_i2_rf_wen}\n")
  printf(cf"ex1_reg_i2_wb_paddr : 0x${ex1_reg_i2_wb_paddr}%x\n")
  printf(cf"ex1_maybe_br_take: ${ex1_maybe_br_taken}%d\n")
  printf(cf"ex1_is_br        : ${ex1_is_br}%d\n")
  printf(cf"ex1_reg_bp_redir : ${ex1_reg_bp.redirected}%d\n")
  printf(cf"ex1_reg_bp_target: 0x${ex1_reg_fp_entry.target.pc_to_word}%x\n")
  printf(cf"ex1_fetch_pc     : 0x${ex1_fetch_pc.pc_to_word}%x\n")
  printf(cf"ex1_predict_pc   : 0x${ex1_predict_pc.pc_to_word}%x\n")
  printf(cf"ex1_fetch_pc_en  : ${ex1_fetch_pc_en}%d\n")
  printf(cf"ex1_reg_bp_fp_ptr: 0x${ex1_reg_bp.fp_ptr}%x\n")
  printf(cf"ex1_reg_bp_lcnt  : 0x${ex1_reg_bp.bp_entry.lcnt}%x\n")
  printf(cf"ex1_reg_bp_gcnt  : 0x${ex1_reg_bp.bp_entry.gcnt}%x\n")
  printf(cf"ex1_reg_bp_attr  : 0x${fetch_unit.io.redir_read.fp_entry.attr}%x\n")
  printf(cf"ex1_reg_bp_histor: 0x${fetch_unit.io.redir_read.fp_entry.history}%x\n")
  printf(cf"ex1_reg_is_half  : ${ex1_reg_is_half}\n")
  printf(cf"ex1_reg_actual_at: 0x${ex1_actual_attr}%x\n")
  printf(cf"ex1_redir_deq_en : ${ex1_redir_deq_en}\n")
  // printf(cf"ex1_bfx_sext     : 0x${ex1_bfx_sext}%x\n")
  // printf(cf"ex1_bfx_sign_shif: 0x${ex1_bfx_sign_shift}%x\n")
  printf(cf"ex2_reg_fw_en    : ${ex2_reg_fw_en}%d\n")
  // printf(cf"ex2_reg_wb_paddr : 0x${ex2_reg_wb_paddr}%x\n")
  printf(cf"ex2_fw_data      : 0x${ex2_fw_data}%x\n")
  printf(cf"ex2_reg_pc       : 0x${Cat(ex2_reg_pc, 0.U(1.W))}%x\n")
  printf(cf"ex2_reg_valid    : ${ex2_reg_valid}%d\n")
  printf(cf"ex2_reg_stall    : ${ex2_reg_stall}%d\n")
  // printf(cf"ex2_reg_br_pc    : 0x${Cat(ex2_reg_br_pc, 0.U(1.W))}%x\n")
  printf(cf"ex2_reg_inst_id  : ${ex2_reg_inst_id.getOrElse(0)}%d\n")
  printf(cf"ex2_reg_op3_data : 0x${ex2_reg_op3_data}%x\n")
  printf(cf"ex2_wb_data      : 0x${ex2_wb_data}%x\n")
  printf(cf"ex2_md_out       : 0x${ex2_md_out}%x\n")
  printf(cf"ex2_reg_wb_paddr : 0x${ex2_reg_wb_paddr}%x\n")
  printf(cf"ex2_reg_rf_wen   : ${ex2_reg_rf_wen}%d\n")
  printf(cf"ex2_reg_processed: ${ex2_reg_processed}%d\n")
  // printf(cf"ex2_reg_cr_mispre: ${ex2_reg_correction.mispred}%d\n")
  // printf(cf"ex2_reg_redirect : ${ex2_reg_redirect}%d\n")
  printf(cf"retire1_valid    : ${rob.io.retire1.valid}%d\n")
  printf(cf"retire1_inst_id  : ${rob.io.retire1.inst_id.getOrElse(0)}%d\n")
  printf(cf"retire2_valid    : ${rob.io.retire2.valid}%d\n")
  printf(cf"retire2_inst_id  : ${rob.io.retire2.inst_id.getOrElse(0)}%d\n")
  printf(cf"rob.io.flush     : ${rob.io.flush}%d\n")
  printf(cf"rob.io.target_pc : 0x${rob.io.target_pc.pc_to_word}%x\n")
  printf(cf"reg_flush        : ${reg_flush}%d\n")
  printf(cf"reg_target_pc    : 0x${reg_target_pc.pc_to_word}%x\n")
  printf(cf"csr_is_meintr    : ${csr_is_meintr}\n")
  printf(cf"csr_is_mtintr    : ${csr_is_mtintr}\n")
  printf(cf"csr_is_ecall     : ${csr_is_ecall}\n")
  // printf(cf"csr_reg_mepc     : 0x${csr_reg_mepc}%x\n")
  printf(cf"csr_is_br        : ${csr_is_br}\n")
  // printf(cf"csr_wdata        : 0x${csr_wdata}%x\n")
  // printf(cf"ex1_reg_csr_cmd  : 0x${ex1_reg_csr_cmd_or_shamt}%x\n")
  printf(cf"instret          : ${instret}%d\n")
  // printf(cf"mem1_reg_is_dram_fence: ${mem1_reg_is_dram_fence}\n")
  // printf(cf"io.cache.ibusy   : ${io.cache.ibusy}\n")
  printf(cf"cycle_counter    : ${io.debug_signal.cycle_counter}%d\n")
  printf("---------\n")
}
