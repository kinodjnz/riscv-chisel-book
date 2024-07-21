package fpga

import chisel3._
import chisel3.util._
import common.Instructions._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.ChiselEnum

class LongCounter(unitWidth: Int, unitCount: Int) extends Module {
  val counterWidth = unitWidth * unitCount
  val io = IO(new Bundle {
    val value = Output(UInt(counterWidth.W))
  })

  // val counters = RegInit(VecInit((0 to unitCount - 1).map(_ => 0.U(unitWidth.W))))
  // val carries = RegInit(VecInit((0 to unitCount - 1).map(_ => false.B)))
  // for(i <- 0 to unitCount - 1) {
  //   carries(i) := counters(i)(unitWidth - 1, 1).andR() && !counters(i)(0) // overflows at the next cycle or not.
  //   if( i == 0 ) {
  //     counters(i) := counters(i) + 1.U
  //   } else {
  //     counters(i) := counters(i) + carries(i - 1).asUInt
  //   }
  // }
  // io.value := Cat(counters.reverse)
  val counter = RegInit(0.U(counterWidth.W))
  counter := counter + 1.U
  io.value := counter
}

class CoreDebugSignals extends Bundle {
  val ex2_reg_pc        = Output(UInt(WORD_LEN.W))
  val ex2_is_valid_inst = Output(Bool())
  // val csr_rdata = Output(UInt(WORD_LEN.W))
  // val ex1_reg_csr_addr = Output(UInt(CSR_ADDR_LEN.W))
  val me_intr       = Output(Bool())
  val mt_intr       = Output(Bool())
  val trap          = Output(Bool())
  val cycle_counter = Output(UInt(48.W))
  val id_pc         = Output(UInt(WORD_LEN.W))
  val id_inst       = Output(UInt(WORD_LEN.W))
  val mem3_rdata    = Output(UInt(WORD_LEN.W))
  val mem3_rvalid   = Output(Bool())
  val rwaddr        = Output(UInt(WORD_LEN.W))
  val ex2_reg_is_br = Output(Bool())
  val id_reg_is_bp_fail = Output(Bool())
  val id_reg_bp_taken = Output(Bool())
  val ic_state      = Output(UInt(3.W))
}

object IcState extends ChiselEnum {
  val Empty = Value     // reg: empty, reg2: empty, imem: this
  val EmptyHalf = Value // reg: empty, reg2: empty, imem: this, half address
  val Full = Value      // reg: full,  reg2: empty, imem: next
  val Full2Half = Value // reg: full,  reg2: full,  imem: next, half address
  val FullHalf = Value  // reg: full,  reg2: empty, imem: next, half address
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

class SimProbe(enable_sim_probe: Boolean) extends Bundle {
  val len_m = if (enable_sim_probe) 1 else 0
  val gp   = Output(UInt((WORD_LEN*len_m).W))
  val exit = Output(UInt(len_m.W))
}

class PipelineProbe(enable_pipeline_probe: Boolean) extends Bundle {
  val len_m = if (enable_pipeline_probe) 1 else 0
  val if2_valid   = Output(UInt(len_m.W))
  val if2_inst_id = Output(UInt((32*len_m).W))
  val if2_pc      = Output(UInt((WORD_LEN*len_m).W))
  val if2_inst    = Output(UInt((WORD_LEN*len_m).W))
  val id_valid    = Output(UInt(len_m.W))
  val id_inst_id  = Output(UInt((32*len_m).W))
  val rrd_valid   = Output(UInt(len_m.W))
  val rrd_inst_id = Output(UInt((32*len_m).W))
  val ex1_valid   = Output(UInt(len_m.W))
  val ex1_inst_id = Output(UInt((32*len_m).W))
  val ex2_valid   = Output(UInt(len_m.W))
  val ex2_inst_id = Output(UInt((32*len_m).W))
  val ex2_retired = Output(UInt(len_m.W))
  val mem1_valid   = Output(UInt(len_m.W))
  val mem1_inst_id = Output(UInt((32*len_m).W))
  val mem2_valid   = Output(UInt(len_m.W))
  val mem2_inst_id = Output(UInt((32*len_m).W))
  val mem3_valid   = Output(UInt(len_m.W))
  val mem3_inst_id = Output(UInt((32*len_m).W))
  val mem3_retired = Output(UInt(len_m.W))
}

class Core(
  start_address: BigInt = 0,
  dram_start: BigInt = 0x2000_0000L,
  dram_length: BigInt = 0x1000_0000L,
  enable_sim_probe: Boolean = false,
  enable_pipeline_probe: Boolean = false,
) extends Module {
  val io = IO(
    new Bundle {
      val imem = Flipped(new ImemPortIo())
      val dmem = Flipped(new DmemPortIo())
      val cache = Flipped(new CachePort())
      val pht_mem = Flipped(new PHTMemIo())
      val mtimer_mem = new DmemPortIo()
      val intr = Input(Bool())
      val debug_signal = new CoreDebugSignals()
      val sim_probe = new SimProbe(enable_sim_probe)
      val pipeline_probe = new PipelineProbe(enable_pipeline_probe)
    }
  )

  val inst_id_len: Int = if (enable_pipeline_probe) 32 else 1
  if (!enable_sim_probe) {
    io.sim_probe := DontCare
  }
  if (!enable_pipeline_probe) {
    io.pipeline_probe := DontCare
  }

  val regfile = Mem(32, UInt(WORD_LEN.W))
  //val csr_regfile = Mem(4096, UInt(WORD_LEN.W)) 
  val cycle_counter = Module(new LongCounter(8, 8)) // 64-bit cycle counter for CYCLE[H] CSR
  val mtimer = Module(new MachineTimer)

  val instret = RegInit(0.U(64.W))
  val csr_reg_trap_vector  = RegInit(0.U(PC_LEN.W))
  val csr_reg_mcause       = RegInit(0.U(WORD_LEN.W))
  // val csr_mtval         = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mepc         = RegInit(0.U(PC_LEN.W))
  val csr_reg_mstatus_mie  = RegInit(false.B)
  val csr_reg_mstatus_mpie = RegInit(false.B)
  val csr_reg_mscratch     = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mie_meie     = RegInit(false.B)
  val csr_reg_mie_mtie     = RegInit(false.B)
  // val csr_mip           = RegInit(0.U(WORD_LEN.W))
  val scoreboard   = Mem(32, Bool())

  io.mtimer_mem <> mtimer.io.mem

  //**********************************
  // Pipeline State Registers

  // IF/ID State
  val id_reg_valid_inst     = RegInit(false.B)
  val id_reg_inst           = RegInit(BUBBLE)
  val id_reg_bp_taken       = RegInit(false.B)
  val id_reg_pc             = RegInit(0.U(PC_LEN.W))
  val id_reg_bp_taken_pc    = RegInit(0.U(PC_LEN.W))
  val id_reg_bp_cnt         = RegInit(0.U(2.W))

  val id_reg_stall          = RegInit(false.B)
  val id_reg_is_trap        = RegInit(false.B)
  val id_reg_mcause         = RegInit(0.U(WORD_LEN.W))
  // val id_reg_mtval          = RegInit(0.U(WORD_LEN.W))
  val id_reg_is_br          = RegInit(false.B)

  // ID/RRD State
  val rrd_reg_pc            = RegInit(0.U(PC_LEN.W))
  val rrd_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_op1_sel       = RegInit(0.U(M_OP1_LEN.W))
  val rrd_reg_op2_sel       = RegInit(0.U(M_OP2_LEN.W))
  val rrd_reg_op3_sel       = RegInit(0.U(M_OP3_LEN.W))
  val rrd_reg_rs1_addr      = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_rs2_addr      = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_rs3_addr      = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_op2_data_im1  = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_op2_data_im0  = RegInit(0.U(12.W))
  val rrd_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val rrd_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val rrd_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val rrd_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val rrd_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val rrd_reg_imm_b_sext    = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_shamt         = RegInit(0.U(2.W))
  val rrd_reg_op2op         = RegInit(0.U(OP2OP_LEN.W))
  val rrd_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val rrd_reg_imm_mask_len  = RegInit(0.U(5.W))
  val rrd_reg_is_direct_j   = RegInit(false.B)
  val rrd_reg_is_br         = RegInit(false.B)
  val rrd_reg_is_j          = RegInit(false.B)
  val rrd_reg_bp_taken      = RegInit(false.B)
  val rrd_reg_bp_taken_pc   = RegInit(0.U(PC_LEN.W))
  val rrd_reg_bp_cnt        = RegInit(0.U(2.W))
  val rrd_reg_is_half       = RegInit(false.B)
  val rrd_reg_is_valid_inst = RegInit(false.B)
  val rrd_reg_is_trap       = RegInit(false.B)
  val rrd_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  // val rrd_reg_mtval          = RegInit(0.U(WORD_LEN.W))

  // RRD/EX1 State
  val ex1_reg_pc            = RegInit(0.U(PC_LEN.W))
  val ex1_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex1_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op3_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex1_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex1_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val ex1_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex1_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val ex1_reg_shamt         = RegInit(0.U(2.W))
  val ex1_reg_op2op         = RegInit(0.U(OP2OP_LEN.W))
  val ex1_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val ex1_reg_imm_mask      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_is_j          = RegInit(false.B)
  val ex1_reg_bp_taken      = RegInit(false.B)
  val ex1_reg_bp_taken_pc   = RegInit(0.U(PC_LEN.W))
  val ex1_reg_bp_cnt        = RegInit(0.U(2.W))
  val ex1_reg_is_half       = RegInit(false.B)
  val ex1_reg_is_valid_inst = RegInit(false.B)
  val ex1_reg_is_trap       = RegInit(false.B)
  val ex1_reg_is_mret       = RegInit(false.B)
  val ex1_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  // val ex1_reg_mtval         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_mem_use_reg   = RegInit(false.B)
  val ex1_reg_inst2_use_reg = RegInit(false.B)
  val ex1_reg_inst3_use_reg = RegInit(false.B)
  val ex1_reg_is_br         = RegInit(false.B)
  val ex1_reg_direct_jbr_pc = RegInit(0.U(PC_LEN.W))

  // EX1/EX2 State
  val ex2_reg_pc            = RegInit(0.U(PC_LEN.W))
  val ex2_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex2_reg_mullu         = RegInit(0.U((WORD_LEN*3/2).W))
  val ex2_reg_mulls         = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_mulhuu        = RegInit(0.U((WORD_LEN*3/2).W))
  val ex2_reg_mulhss        = RegInit(0.S((WORD_LEN*3/2).W))
  val ex2_reg_mulhsu        = RegInit(0.S((WORD_LEN*3/2).W))
  val ex2_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex2_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex2_reg_fun_sel       = RegInit(0.U(EX2_FUN_LEN.W))
  val ex2_reg_alu_out       = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_pc_bit_out    = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_op3_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_is_valid_inst = RegInit(false.B)
  // val ex2_reminder          = Wire(UInt(WORD_LEN.W))
  // val ex2_quotient          = Wire(UInt(WORD_LEN.W))
  val ex2_reg_divrem        = RegInit(false.B)
  val ex2_reg_sign_op1      = RegInit(0.U(1.W))
  val ex2_reg_sign_op12     = RegInit(0.U(1.W))
  val ex2_reg_zero_op2      = RegInit(false.B)
  val ex2_reg_init_dividend = RegInit(0.U((WORD_LEN+5).W))
  val ex2_reg_init_divisor  = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_orig_dividend = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_inst3_use_reg = RegInit(false.B)
  val ex2_reg_no_mem        = RegInit(false.B)

  // EX1/MEM1 State
  val mem1_reg_mem_wstrb     = RegInit(0.U(7.W))
  val mem1_reg_wdata         = RegInit(0.U(WORD_LEN.W))
  val mem1_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val mem1_reg_mem_use_reg   = RegInit(false.B)
  val mem1_reg_is_dram       = RegInit(false.B)
  val mem1_reg_is_mem_load   = RegInit(false.B)
  val mem1_reg_is_mem_store  = RegInit(false.B)
  val mem1_reg_is_dram_load  = RegInit(false.B)
  val mem1_reg_is_dram_store = RegInit(false.B)
  val mem1_reg_is_dram_fence = RegInit(false.B)
  val mem1_reg_is_valid_inst = RegInit(false.B)
  val mem1_reg_unaligned     = RegInit(false.B)

  // MEM1/MEM2 State
  val mem2_reg_wb_byte_offset = RegInit(0.U(2.W))
  val mem2_reg_mem_w          = RegInit(0.U(MW_LEN.W))
  // val mem2_reg_dmem_rdata     = RegInit(0.U(WORD_LEN.W))
  val mem2_reg_wb_addr        = RegInit(0.U(ADDR_LEN.W))
  val mem2_reg_is_valid_load  = RegInit(false.B)
  val mem2_reg_mem_use_reg    = RegInit(false.B)
  val mem2_reg_is_valid_inst  = RegInit(false.B)
  val mem2_reg_is_mem_load    = RegInit(false.B)
  val mem2_reg_is_dram_load   = RegInit(false.B)
  val mem2_reg_unaligned      = RegInit(false.B)

  // MEM2/MEM3 State
  val mem3_reg_wb_byte_offset = RegInit(0.U(2.W))
  val mem3_reg_mem_w          = RegInit(0.U(MW_LEN.W))
  val mem3_reg_dmem_rdata     = RegInit(0.U(WORD_LEN.W))
  val mem3_reg_rdata_high     = RegInit(0.U(24.W))
  val mem3_reg_wb_addr        = RegInit(0.U(ADDR_LEN.W))
  val mem3_reg_is_valid_load  = RegInit(false.B)
  val mem3_reg_is_valid_inst  = RegInit(false.B)
  val mem3_reg_mem_use_reg    = RegInit(false.B)
  val mem3_reg_unaligned      = RegInit(false.B)
  val mem3_reg_is_aligned_lw  = RegInit(false.B)

  val id_reg_is_bp_fail    = RegInit(true.B) // jump start_address when first time
  val id_reg_br_pc         = RegInit((start_address >> (WORD_LEN-PC_LEN)).U(PC_LEN.W))
  val id_stall             = Wire(Bool())
  val rrd_stall            = Wire(Bool())
  val ex2_stall            = Wire(Bool())
  val mem_stall            = Wire(Bool())
  val mem2_stall           = Wire(Bool())
  val mem1_mem_stall       = Wire(Bool())
  val mem1_dram_stall      = Wire(Bool())
  val ex1_reg_fw_en        = RegInit(false.B)
  val ex1_fw_data          = Wire(UInt(WORD_LEN.W))
  val ex2_reg_fw_en        = RegInit(false.B)
  val ex2_fw_data          = Wire(UInt(WORD_LEN.W))
  val mem3_reg_fw_en       = RegInit(false.B)
  val mem3_fw_data         = Wire(UInt(WORD_LEN.W))
  val ex2_div_stall_next   = Wire(Bool())
  val ex2_reg_div_stall    = RegInit(false.B)
  val ex2_div_stall        = Wire(Bool())
  val ex2_reg_divrem_state = RegInit(DivremState.Idle)
  val ex2_reg_is_br        = RegInit(false.B)
  val ex2_reg_br_pc        = RegInit(0.U(PC_LEN.W))
  val ex1_is_br            = Wire(Bool())
  val csr_is_br            = Wire(Bool())
  val csr_br_pc            = Wire(UInt(PC_LEN.W))
  val mem1_reg_dmem_state  = RegInit(DmemState.Idle)
  val ex2_reg_is_retired   = RegInit(false.B)
  val mem3_reg_is_retired  = RegInit(false.B)
  val ex1_en               = Wire(Bool())
  val ex2_reg_en           = RegInit(false.B)

  val if2_reg_inst_id      = RegInit(Fill(inst_id_len, 1.U(1.W)))
  val id_reg_inst_id_delay = RegInit(0.U(inst_id_len.W))
  val rrd_reg_inst_id      = RegInit(0.U(inst_id_len.W))
  val ex1_reg_inst_id      = RegInit(0.U(inst_id_len.W))
  val ex2_reg_inst_id      = RegInit(0.U(inst_id_len.W))
  val mem1_reg_inst_id     = RegInit(0.U(inst_id_len.W))
  val mem2_reg_inst_id     = RegInit(0.U(inst_id_len.W))
  val mem3_reg_inst_id     = RegInit(0.U(inst_id_len.W))

  //**********************************
  // Instruction Fetch And Branch Prediction

  val ic_addr_en       = Wire(Bool())
  val ic_addr          = Wire(UInt(PC_LEN.W))
  val ic_read_en2      = Wire(Bool())
  val ic_read_en4      = Wire(Bool())
  val ic_reg_read_rdy  = RegInit(false.B)
  val ic_reg_half_rdy  = RegInit(false.B)
  val ic_read_rdy      = Wire(Bool())
  val ic_half_rdy      = Wire(Bool())
  val ic_data_out      = Wire(UInt(WORD_LEN.W))
  val ic_reg_imem_addr = RegInit(0.U(PC_LEN.W))
  val ic_reg_addr_out  = RegInit(0.U(PC_LEN.W))
  val ic_addr_out      = Wire(UInt(PC_LEN.W))

  val ic_reg_inst       = RegInit(0.U(WORD_LEN.W))
  val ic_reg_inst_addr  = RegInit(0.U(PC_LEN.W))
  val ic_reg_inst2      = RegInit(0.U(WORD_LEN.W))
  val ic_reg_inst2_addr = RegInit(0.U(PC_LEN.W))

  val ic_state = RegInit(IcState.Empty)

  val ic_btb = Module(new BTB(BTB_INDEX_LEN))
  val ic_pht = Module(new PHT(PHT_INDEX_LEN))

  val ic_bp_taken              = Wire(Bool())
  val ic_bp_taken_pc           = Wire(UInt(PC_LEN.W))
  val ic_bp_cnt                = Wire(UInt(2.W))
  val ic_reg_bp_next_taken0    = RegInit(false.B)
  val ic_reg_bp_next_taken_pc0 = RegInit(0.U(PC_LEN.W))
  val ic_reg_bp_next_cnt0      = RegInit(0.U(2.W))
  val ic_reg_bp_next_taken1    = RegInit(false.B)
  val ic_reg_bp_next_taken_pc1 = RegInit(0.U(PC_LEN.W))
  val ic_reg_bp_next_cnt1      = RegInit(0.U(2.W))
  val ic_reg_bp_next_taken2    = RegInit(false.B)
  val ic_reg_bp_next_taken_pc2 = RegInit(0.U(PC_LEN.W))
  val ic_reg_bp_next_cnt2      = RegInit(0.U(2.W))

  val ic_imem_addr_2 = Cat(ic_reg_imem_addr(PC_LEN-1, 1), 1.U(1.W))
  val ic_imem_addr_4 = ic_reg_imem_addr + 2.U(PC_LEN.W)
  val ic_inst_addr_2 = Cat(ic_reg_inst_addr(PC_LEN-1, 1), 1.U(1.W))
  io.imem.addr := Cat(ic_reg_imem_addr, 0.U(1.W))
  io.imem.en := true.B
  ic_reg_read_rdy := true.B
  ic_reg_half_rdy := true.B
  ic_read_rdy := ic_reg_read_rdy
  ic_half_rdy := ic_reg_half_rdy
  ic_data_out := BUBBLE
  ic_addr_out := ic_reg_addr_out
  ic_reg_addr_out := ic_addr_out
  ic_btb.io.lu.pc := ic_reg_imem_addr
  ic_pht.io.lu.pc := ic_reg_imem_addr
  ic_bp_taken     := false.B
  ic_bp_taken_pc  := 0.U
  ic_bp_cnt       := 0.U
  ic_pht.io.mem <> io.pht_mem

  when (ic_addr_en) {
    val ic_next_imem_addr = Cat(ic_addr(PC_LEN-1, 1), 0.U(1.W))
    io.imem.addr     := Cat(ic_next_imem_addr, 0.U(1.W))
    ic_reg_imem_addr := ic_next_imem_addr
    ic_addr_out      := ic_addr
    ic_state         := Mux(ic_addr(0).asBool, IcState.EmptyHalf, IcState.Empty)
    ic_reg_read_rdy  := !ic_addr(0).asBool
    ic_btb.io.lu.pc  := ic_next_imem_addr
    ic_pht.io.lu.pc  := ic_next_imem_addr
  }.elsewhen (/*ic_state =/= IcState.Full && ic_state =/= IcState.Full2Half &&*/ !io.imem.valid) {
    ic_reg_read_rdy := ic_reg_read_rdy
    ic_reg_half_rdy := ic_reg_half_rdy
    ic_read_rdy     := false.B
    ic_half_rdy     := false.B
    switch (ic_state) {
      is (IcState.Empty) {
        ic_bp_taken    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_bp_taken_pc := ic_btb.io.lu.taken_pc0
        ic_bp_cnt      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken1    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_reg_bp_next_taken_pc1 := ic_btb.io.lu.taken_pc1
        ic_reg_bp_next_cnt1      := ic_pht.io.lu.cnt1
      }
      is (IcState.EmptyHalf) {
        ic_bp_taken    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_bp_taken_pc := ic_btb.io.lu.taken_pc1
        ic_bp_cnt      := ic_pht.io.lu.cnt1
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken1    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_reg_bp_next_taken_pc1 := ic_btb.io.lu.taken_pc1
        ic_reg_bp_next_cnt1      := ic_pht.io.lu.cnt1
      }
      is (IcState.Full) {
        ic_bp_taken    := ic_reg_bp_next_taken0
        ic_bp_taken_pc := ic_reg_bp_next_taken_pc0
        ic_bp_cnt      := ic_reg_bp_next_cnt0
      }
      is (IcState.FullHalf) {
        ic_bp_taken    := ic_reg_bp_next_taken1
        ic_bp_taken_pc := ic_reg_bp_next_taken_pc1
        ic_bp_cnt      := ic_reg_bp_next_cnt1
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken2    := ic_reg_bp_next_taken1
        ic_reg_bp_next_taken_pc2 := ic_reg_bp_next_taken_pc1
        ic_reg_bp_next_cnt2      := ic_reg_bp_next_cnt1
      }
      is (IcState.Full2Half) {
        ic_bp_taken    := ic_reg_bp_next_taken2
        ic_bp_taken_pc := ic_reg_bp_next_taken_pc2
        ic_bp_cnt      := ic_reg_bp_next_cnt2
      }
    }
  }.otherwise {
    switch (ic_state) {
      is (IcState.Empty) {
        io.imem.addr     := Cat(ic_imem_addr_4, 0.U(1.W))
        ic_reg_imem_addr := ic_imem_addr_4
        ic_reg_inst      := io.imem.inst
        ic_reg_inst_addr := ic_reg_imem_addr
        ic_data_out      := io.imem.inst
        ic_btb.io.lu.pc  := ic_imem_addr_4
        ic_pht.io.lu.pc  := ic_imem_addr_4
        ic_bp_taken      := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_bp_taken_pc   := ic_btb.io.lu.taken_pc0
        ic_bp_cnt        := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken1    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_reg_bp_next_taken_pc1 := ic_btb.io.lu.taken_pc1
        ic_reg_bp_next_cnt1      := ic_pht.io.lu.cnt1
        ic_state := IcState.Full
        when (ic_read_en2) {
          ic_addr_out := ic_imem_addr_2
          ic_state := IcState.FullHalf
        }.elsewhen (ic_read_en4) {
          ic_addr_out := ic_imem_addr_4
          ic_state := IcState.Empty
        }
      }
      is (IcState.EmptyHalf) {
        io.imem.addr     := Cat(ic_imem_addr_4, 0.U(1.W))
        ic_reg_imem_addr := ic_imem_addr_4
        ic_reg_inst      := io.imem.inst
        ic_reg_inst_addr := ic_reg_imem_addr
        ic_data_out      := Cat(Fill(WORD_LEN/2-1, 0.U), io.imem.inst(WORD_LEN-1, WORD_LEN/2))
        ic_addr_out      := ic_imem_addr_2
        ic_btb.io.lu.pc  := ic_imem_addr_4
        ic_pht.io.lu.pc  := ic_imem_addr_4
        ic_bp_taken      := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_bp_taken_pc   := ic_btb.io.lu.taken_pc1
        ic_bp_cnt        := ic_pht.io.lu.cnt1
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken1    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_reg_bp_next_taken_pc1 := ic_btb.io.lu.taken_pc1
        ic_reg_bp_next_cnt1      := ic_pht.io.lu.cnt1
        ic_state := IcState.FullHalf
        when (ic_read_en2) {
          ic_addr_out := ic_imem_addr_4
          ic_state := IcState.Empty
        }
      }
      is (IcState.Full) {
        io.imem.addr    := Cat(ic_reg_imem_addr, 0.U(1.W))
        ic_data_out     := ic_reg_inst
        ic_btb.io.lu.pc := ic_reg_imem_addr
        ic_pht.io.lu.pc := ic_reg_imem_addr
        ic_bp_taken     := ic_reg_bp_next_taken0
        ic_bp_taken_pc  := ic_reg_bp_next_taken_pc0
        ic_bp_cnt       := ic_reg_bp_next_cnt0
        when (ic_read_en2) {
          ic_addr_out := ic_inst_addr_2
          ic_state := IcState.FullHalf
        }.elsewhen(ic_read_en4) {
          ic_addr_out := ic_reg_imem_addr
          ic_state := IcState.Empty
        }
      }
      is (IcState.FullHalf) {
        io.imem.addr      := Cat(ic_imem_addr_4, 0.U(1.W))
        ic_reg_imem_addr  := ic_imem_addr_4
        ic_data_out       := Cat(io.imem.inst(WORD_LEN/2-1, 0), ic_reg_inst(WORD_LEN-1, WORD_LEN/2))
        ic_reg_inst       := io.imem.inst
        ic_reg_inst_addr  := ic_reg_imem_addr
        ic_reg_inst2      := ic_reg_inst
        ic_reg_inst2_addr := ic_reg_inst_addr
        ic_btb.io.lu.pc   := ic_imem_addr_4
        ic_pht.io.lu.pc   := ic_imem_addr_4
        ic_bp_taken       := ic_reg_bp_next_taken1
        ic_bp_taken_pc    := ic_reg_bp_next_taken_pc1
        ic_bp_cnt         := ic_reg_bp_next_cnt1
        ic_reg_bp_next_taken0    := ic_btb.io.lu.matches0 && ic_pht.io.lu.cnt0(0)
        ic_reg_bp_next_taken_pc0 := ic_btb.io.lu.taken_pc0
        ic_reg_bp_next_cnt0      := ic_pht.io.lu.cnt0
        ic_reg_bp_next_taken1    := ic_btb.io.lu.matches1 && ic_pht.io.lu.cnt1(0)
        ic_reg_bp_next_taken_pc1 := ic_btb.io.lu.taken_pc1
        ic_reg_bp_next_cnt1      := ic_pht.io.lu.cnt1
        ic_reg_bp_next_taken2    := ic_reg_bp_next_taken1
        ic_reg_bp_next_taken_pc2 := ic_reg_bp_next_taken_pc1
        ic_reg_bp_next_cnt2      := ic_reg_bp_next_cnt1
        ic_state := IcState.Full2Half
        when (ic_read_en2) {
          ic_addr_out := ic_reg_imem_addr
          ic_state := IcState.Full
        }.elsewhen(ic_read_en4) {
          ic_addr_out := Cat(ic_reg_imem_addr(PC_LEN-1, 1), 1.U(1.W))
          ic_state := IcState.FullHalf
        }
      }
      is (IcState.Full2Half) {
        io.imem.addr    := Cat(ic_reg_imem_addr, 0.U(1.W))
        ic_data_out     := Cat(ic_reg_inst(WORD_LEN/2-1, 0), ic_reg_inst2(WORD_LEN-1, WORD_LEN/2))
        ic_btb.io.lu.pc := ic_reg_imem_addr
        ic_pht.io.lu.pc := ic_reg_imem_addr
        ic_bp_taken     := ic_reg_bp_next_taken2
        ic_bp_taken_pc  := ic_reg_bp_next_taken_pc2
        ic_bp_cnt       := ic_reg_bp_next_cnt2
        when (ic_read_en2) {
          ic_addr_out := ic_reg_inst_addr
          ic_state := IcState.Full
        }.elsewhen(ic_read_en4) {
          ic_addr_out := Cat(ic_reg_inst_addr(PC_LEN-1, 1), 1.U(1.W))
          ic_state := IcState.FullHalf
        }
      }
    }
  }

  //**********************************
  // Instruction Fetch (IF) 1 Stage

  val if1_jump_addr = MuxCase(id_reg_bp_taken_pc, Seq(
    ex2_reg_is_br     -> ex2_reg_br_pc,
    id_reg_is_bp_fail -> id_reg_br_pc,
    // if2_reg_bp_taken  -> if2_reg_bp_taken_pc,
  ))
  val if1_is_jump = ex2_reg_is_br || id_reg_is_bp_fail || id_reg_bp_taken

  ic_addr_en  := if1_is_jump
  ic_addr     := if1_jump_addr

  //**********************************
  // Instruction Fetch (IF) 2 Stage

  val if2_is_half_inst = (ic_data_out(1, 0) =/= 3.U)
  ic_read_en2 := !id_reg_stall && if2_is_half_inst
  ic_read_en4 := !id_reg_stall && !if2_is_half_inst
  val if2_is_inst_read = ic_read_rdy || (ic_half_rdy && if2_is_half_inst)
  val if2_pc = ic_reg_addr_out
  val if2_is_valid_inst = !ex2_reg_is_br && !id_reg_is_bp_fail && !id_reg_bp_taken && if2_is_inst_read
  val if2_inst = Mux(if2_is_valid_inst, ic_data_out, BUBBLE)
  val if2_bp_taken = if2_is_valid_inst && ic_bp_taken
  if (enable_pipeline_probe) {
    val if2_probe_valid_inst = !id_reg_stall && if2_is_valid_inst
    val if2_inst_id = Mux(if2_probe_valid_inst,
      if2_reg_inst_id + 1.U,
      if2_reg_inst_id,
    )
    if2_reg_inst_id := if2_inst_id
    io.pipeline_probe.if2_valid   := if2_probe_valid_inst
    io.pipeline_probe.if2_inst_id := if2_inst_id
    io.pipeline_probe.if2_pc      := Cat(if2_pc, 0.U(1.W))
    io.pipeline_probe.if2_inst    := if2_inst
  }
  
  printf(p"ic_reg_addr_out: ${Hexadecimal(Cat(ic_reg_addr_out, 0.U(1.W)))}, ic_data_out: ${Hexadecimal(ic_data_out)}\n")
  printf(p"inst: ${Hexadecimal(if2_inst)}, ic_read_rdy: ${ic_read_rdy}, ic_state: ${ic_state.asUInt}, ic_addr_en: ${ic_addr_en.asUInt}\n")

  //**********************************
  // IF2/ID Register

  when (ex2_reg_is_br || !id_reg_stall) {
    // 優先順位重要！ジャンプ成立とストールが同時発生した場合、ジャンプ処理を優先
    // ストールとBP同時の場合、BP発生源の命令を生かすためストール優先
    id_reg_valid_inst := if2_is_valid_inst
    id_reg_inst       := if2_inst
    id_reg_bp_taken   := if2_bp_taken
  }
  when (!id_reg_stall) {
    id_reg_pc          := ic_reg_addr_out
    id_reg_bp_taken_pc := ic_bp_taken_pc
    id_reg_bp_cnt      := ic_bp_cnt
  }
  val id_reg_inst_id = if2_reg_inst_id

  //**********************************
  // Instruction Decode (ID) Stage

  id_stall := rrd_stall || ex2_stall
  id_reg_stall := id_stall

  // branch,jump時にIDをBUBBLE化
  // val id_inst = Mux(ex2_reg_is_br || id_reg_is_bp_fail, BUBBLE, id_reg_inst)
  val id_inst = id_reg_inst

  val id_is_half = (id_inst(1, 0) =/= 3.U)

  val id_rs1_addr = id_inst(19, 15)
  val id_rs2_addr = id_inst(24, 20)
  val id_rs3_addr = id_inst(31, 27)
  val id_w_wb_addr  = id_inst(11, 7)

  val ex2_wb_data = Wire(UInt(WORD_LEN.W))

  val id_c_rs1_addr  = id_inst(11, 7)
  val id_c_rs2_addr  = id_inst(6, 2)
  val id_c_wb_addr   = id_inst(11, 7)
  val id_c_rs1p_addr = Cat(1.U(2.W), id_inst(9, 7))
  val id_c_rs2p_addr = Cat(1.U(2.W), id_inst(4, 2))
  val id_c_rs3p_addr = Cat(1.U(2.W), id_inst(12, 10))
  val id_c_wb1p_addr = Cat(1.U(2.W), id_inst(9, 7))
  val id_c_wb2p_addr = Cat(1.U(2.W), id_inst(4, 2))

  val id_imm_i = id_inst(31, 20)
  val id_imm_i_sext = Cat(Fill(20, id_imm_i(11)), id_imm_i)
  val id_imm_s = Cat(id_inst(31, 25), id_inst(11, 7))
  val id_imm_s_sext = Cat(Fill(20, id_imm_s(11)), id_imm_s)
  val id_imm_b = Cat(id_inst(31), id_inst(7), id_inst(30, 25), id_inst(11, 8))
  val id_imm_b_sext = Cat(Fill(19, id_imm_b(11)), id_imm_b, 0.U(1.W))
  val id_imm_j = Cat(id_inst(31), id_inst(19, 12), id_inst(20), id_inst(30, 21))
  val id_imm_j_sext = Cat(Fill(11, id_imm_j(19)), id_imm_j, 0.U(1.W))
  val id_imm_u = id_inst(31,12)
  val id_imm_u_shifted = Cat(id_imm_u, Fill(12, 0.U))
  val id_imm_z = id_inst(19,15)
  val id_imm_z_uext = Cat(Fill(27, 0.U), id_imm_z)

  val id_c_imm_i = Cat(Fill(27, id_inst(12)), id_inst(6, 2))
  val id_c_imm_iu = Cat(Fill(15, id_inst(12)), id_inst(6, 2), Fill(12, 0.U))
  val id_c_imm_i16 = Cat(Fill(23, id_inst(12)), id_inst(4, 3), id_inst(5), id_inst(2), id_inst(6), Fill(4, 0.U))
  val id_c_imm_sl = Cat(Fill(4, 0.U), id_inst(3, 2), id_inst(12), id_inst(6, 4), Fill(2, 0.U))
  val id_c_imm_ss = Cat(Fill(4, 0.U), id_inst(8, 7), id_inst(12, 9), Fill(2, 0.U))
  val id_c_imm_iw = Cat(Fill(2, 0.U), id_inst(10, 7), id_inst(12, 11), id_inst(5), id_inst(6), Fill(2, 0.U))
  val id_c_imm_ls = Cat(Fill(5, 0.U), id_inst(5), id_inst(12, 10), id_inst(6), Fill(2, 0.U))
  val id_c_imm_b = Cat(Fill(24, id_inst(12)), id_inst(6, 5), id_inst(2), id_inst(11, 10), id_inst(4, 3), 0.U(1.W))
  val id_c_imm_j = Cat(Fill(21, id_inst(12)), id_inst(8), id_inst(10, 9), id_inst(6), id_inst(7), id_inst(2), id_inst(11), id_inst(5, 3), 0.U(1.W))

  val id_c_imm_b2 = Cat(Fill(27, id_inst(12)), id_inst(11, 10), id_inst(6, 5), 0.U(1.W))
  val id_c_imm_u = Cat(Fill(12, 0.U), id_inst(12, 5), Fill(12, 0.U))
  val id_c_imm_lsb = Cat(Fill(7, 0.U), id_inst(11, 10), id_inst(6, 5), id_inst(12))
  val id_c_imm_lsh = Cat(Fill(8, 0.U), id_inst(10), id_inst(6, 5), 0.U(1.W))
  val id_c_imm_sw0 = Cat(Fill(5, 0.U), id_inst(5, 3), id_inst(10), id_inst(6), Fill(2, 0.U))
  val id_c_imm_sb0 = Cat(Fill(8, 0.U), id_inst(10), id_inst(6, 4))
  val id_c_imm_sh0 = Cat(Fill(8, 0.U), id_inst(4), id_inst(10), id_inst(6, 5), 0.U(1.W))
  val id_c_imm_a2w = Cat(Fill(26, id_inst(12)), id_inst(5), id_inst(11, 10), id_inst(6), Fill(2, 0.U))
  val id_c_imm_a2b = Cat(Fill(30, id_inst(12)), id_inst(11, 10))

  val id_shamt = id_inst(14, 13)

  val id_imm_mask_len = id_inst(31, 27)

  val csignals = ListLookup(id_inst,
                    List(ALU_X     , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
    Array(
      LB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_B  , OP2OP_NOP),
      LBU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_BU , OP2OP_NOP),
      SB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , OP3_RS2   , REN_X, WB_ST   , WBA_RD , CSR_X, MW_B  , OP2OP_NOP),
      LH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_H  , OP2OP_NOP),
      LHU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_HU , OP2OP_NOP),
      SH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , OP3_RS2   , REN_X, WB_ST   , WBA_RD , CSR_X, MW_H  , OP2OP_NOP),
      LW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_W  , OP2OP_NOP),
      SW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , OP3_RS2   , REN_X, WB_ST   , WBA_RD , CSR_X, MW_W  , OP2OP_NOP),
      ADD        -> List(ALU_ADD   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ADDI       -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SUB        -> List(ALU_SUB   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      AND        -> List(ALU_AND   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      OR         -> List(ALU_OR    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      XOR        -> List(ALU_XOR   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ANDI       -> List(ALU_AND   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ORI        -> List(ALU_OR    , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      XORI       -> List(ALU_XOR   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRL        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRA        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2    , OP3_MSB   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLLI       -> List(ALU_FSL   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRLI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRAI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMI    , OP3_MSB   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLT        -> List(ALU_SLT   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLTU       -> List(ALU_SLTU  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLTI       -> List(ALU_SLT   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLTIU      -> List(ALU_SLTU  , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEQ        -> List(BR_BEQ    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BNE        -> List(BR_BNE    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BGE        -> List(BR_BGE    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BGEU       -> List(BR_BGEU   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BLT        -> List(BR_BLT    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BLTU       -> List(BR_BLTU   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      JAL        -> List(ALU_ADD   , OP1_PC    , OP2_IMJ    , OP3_X     , REN_S, WB_PC   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      JALR       -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_PC   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      LUI        -> List(ALU_ADD   , OP1_X     , OP2_IMU    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      AUIPC      -> List(ALU_ADD   , OP1_PC    , OP2_IMU    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CSRRW      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_W, MW_X  , OP2OP_NOP),
      CSRRWI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_W, MW_X  , OP2OP_NOP),
      CSRRS      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_S, MW_X  , OP2OP_NOP),
      CSRRSI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_S, MW_X  , OP2OP_NOP),
      CSRRC      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_C, MW_X  , OP2OP_NOP),
      CSRRCI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , OP3_X     , REN_S, WB_CSR  , WBA_RD , CSR_C, MW_X  , OP2OP_NOP),
      ECALL      -> List(CMD_ECALL , OP1_X     , OP2_X      , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_CSR, OP2OP_NOP),
      MRET       -> List(CMD_MRET  , OP1_X     , OP2_X      , OP3_X     , REN_X, WB_X    , WBA_RD , CSR_X, MW_CSR, OP2OP_NOP),
      FENCE_I    -> List(ALU_X     , OP1_X     , OP2_X      , OP3_X     , REN_X, WB_FENCE, WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MUL        -> List(ALU_MUL   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULH       -> List(ALU_MULH  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULHU      -> List(ALU_MULHU , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULHSU     -> List(ALU_MULHSU, OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      DIV        -> List(ALU_DIV   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      DIVU       -> List(ALU_DIVU  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REM        -> List(ALU_REM   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REMU       -> List(ALU_REMU  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MAX        -> List(ALU_MAX   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MAXU       -> List(ALU_MAXU  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MIN        -> List(ALU_MIN   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MINU       -> List(ALU_MINU  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CLZ        -> List(ALU_CLZ   , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CTZ        -> List(ALU_CTZ   , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CPOP       -> List(ALU_CPOP  , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REV8       -> List(ALU_REV8  , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SEXTB      -> List(ALU_SEXTB , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SEXTH      -> List(ALU_SEXTH , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ZEXTH      -> List(ALU_ZEXTH , OP1_RS1   , OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ANDN       -> List(ALU_AND   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      ORN        -> List(ALU_OR    , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      XNOR       -> List(ALU_XOR   , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      ROL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2    , OP3_OP1   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ROR        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2    , OP3_OP1   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      RORI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMI    , OP3_OP1   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSCTH      -> List(ALU_BSCTH , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SH_ADD     -> List(ALU_SHADD , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BCLR       -> List(ALU_BCLR  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSET       -> List(ALU_BSET  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BINV       -> List(ALU_BINV  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEXT       -> List(ALU_BEXT  , OP1_RS1   , OP2_RS2    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BCLRI      -> List(ALU_BCLR  , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSETI      -> List(ALU_BSET  , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BINVI      -> List(ALU_BINV  , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEXTI      -> List(ALU_BEXT  , OP1_RS1   , OP2_IMI    , OP3_X     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CMOV       -> List(ALU_CMOV  , OP1_RS1   , OP2_RS2    , OP3_RS3   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2    , OP3_RS3   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSR        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2    , OP3_RS3   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSRI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMI    , OP3_RS3   , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFM        -> List(ALU_BFM   , OP1_RS1   , OP2_RS2    , OP3_RD    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_ZERO),
      BFP        -> List(ALU_BFP   , OP1_RS1   , OP2_RS2    , OP3_RD    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFMI       -> List(ALU_BFM   , OP1_RS1   , OP2_IMI    , OP3_RD    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_ZERO),
      BFPI       -> List(ALU_BFP   , OP1_RS1   , OP2_IMI    , OP3_RD    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      C_ILL      -> List(ALU_X     , OP1_X     , OP2_X      , OP3_X     , REN_X, WB_X    , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI4SPN -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMIW , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI16SP -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_IMI16, OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI     -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_IMI  , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLS , OP3_X     , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_W  , OP2OP_NOP),
      C_SW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLS , OP3_C_RS2P, REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_LI       -> List(ALU_ADD   , OP1_X     , OP2_C_IMI  , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LUI      -> List(ALU_ADD   , OP1_X     , OP2_C_IMIU , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_SRAI     -> List(ALU_FSR   , OP1_C_RS1P, OP2_C_IMI  , OP3_MSB   , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SRLI     -> List(ALU_FSR   , OP1_C_RS1P, OP2_C_IMI  , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_ANDI     -> List(ALU_AND   , OP1_C_RS1P, OP2_C_IMI  , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SUB      -> List(ALU_SUB   , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_XOR      -> List(ALU_XOR   , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_OR       -> List(ALU_OR    , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_AND      -> List(ALU_AND   , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SLLI     -> List(ALU_FSL   , OP1_C_RS1 , OP2_C_IMI  , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_J        -> List(ALU_ADD   , OP1_PC    , OP2_C_IMJ  , OP3_X     , REN_X, WB_PC   , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_BEQZ     -> List(BR_BEQ    , OP1_C_RS1P, OP2_Z      , OP3_X     , REN_X, WB_X    , WBA_CBR, CSR_X, MW_BR , OP2OP_NOP),
      C_BNEZ     -> List(BR_BNE    , OP1_C_RS1P, OP2_Z      , OP3_X     , REN_X, WB_X    , WBA_CBR, CSR_X, MW_BR , OP2OP_NOP),
      C_JR       -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z      , OP3_X     , REN_X, WB_PC   , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_JALR     -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z      , OP3_X     , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_JAL      -> List(ALU_ADD   , OP1_PC    , OP2_C_IMJ  , OP3_X     , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_LWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMSL , OP3_X     , REN_S, WB_LD   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_SWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMSS , OP3_C_RS2 , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_MV       -> List(ALU_ADD   , OP1_Z     , OP2_C_RS2  , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADD      -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_RS2  , OP3_X     , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LB       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSB, OP3_X     , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_B  , OP2OP_NOP),
      C_LBU      -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSB, OP3_X     , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_BU , OP2OP_NOP),
      C_LH       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSH, OP3_X     , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_H  , OP2OP_NOP),
      C_LHU      -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSH, OP3_X     , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_HU , OP2OP_NOP),
      C_SH       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSH, OP3_C_RS2P, REN_X, WB_ST   , WBA_C  , CSR_X, MW_H  , OP2OP_NOP),
      C_SW0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMSW0, OP3_Z     , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_SB0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMSB0, OP3_Z     , REN_X, WB_ST   , WBA_C  , CSR_X, MW_B  , OP2OP_NOP),
      C_SH0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMSH0, OP3_Z     , REN_X, WB_ST   , WBA_C  , CSR_X, MW_H  , OP2OP_NOP),
      C_SB       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLSB, OP3_C_RS2P, REN_X, WB_ST   , WBA_C  , CSR_X, MW_B  , OP2OP_NOP),
      C_AUIPC    -> List(ALU_ADD   , OP1_PC    , OP2_C_IMU  , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_MUL      -> List(ALU_MUL   , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_S, WB_MD   , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_ZEXTB    -> List(ALU_AND   , OP1_C_RS1P, OP2_IM255  , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SEXTB    -> List(ALU_SEXTB , OP1_C_RS1P, OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SEXTH    -> List(ALU_SEXTH , OP1_C_RS1P, OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_ZEXTH    -> List(ALU_ZEXTH , OP1_C_RS1P, OP2_X      , OP3_X     , REN_S, WB_BIT  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_NOT      -> List(ALU_XOR   , OP1_C_RS1P, OP2_IMALL1 , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_NEG      -> List(ALU_SUB   , OP1_Z     , OP2_C_RS1P , OP3_X     , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_BEQ      -> List(BR_BEQ    , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_X, WB_X    , WBA_CB2, CSR_X, MW_BR , OP2OP_NOP),
      C_BNE      -> List(BR_BNE    , OP1_C_RS1P, OP2_C_RS2P , OP3_X     , REN_X, WB_X    , WBA_CB2, CSR_X, MW_BR , OP2OP_NOP),
      C_ADDI2W   -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMA2W, OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADD2     -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_RS3P , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SEQZ     -> List(ALU_SLTU  , OP1_C_RS1P, OP2_IM1    , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SNEZ     -> List(ALU_SLTU  , OP1_Z     , OP2_C_RS1P , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI2B   -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMA2B, OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SLT      -> List(ALU_SLT   , OP1_C_RS1P, OP2_C_RS3P , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SLTU     -> List(ALU_SLTU  , OP1_C_RS1P, OP2_C_RS3P , OP3_X     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
		)
	)
  val List(id_exe_fun, id_op1_sel, id_op2_sel, id_op3_sel, id_rf_wen, id_wb_sel, id_wba, id_csr_cmd, id_mem_w, id_op2op) = csignals

  val id_wb_addr = MuxCase(id_w_wb_addr, Seq(
    (id_wba === WBA_C)   -> id_c_wb_addr,
    (id_wba === WBA_CP1) -> id_c_wb1p_addr,
    (id_wba === WBA_CP2) -> id_c_wb2p_addr,
    (id_wba === WBA_RA)  -> 1.U(ADDR_LEN.W),
  ))

  val id_op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op1_sel === OP1_PC)     -> Cat(id_reg_pc, 0.U((WORD_LEN-PC_LEN).W)),
    (id_op1_sel === OP1_IMZ)    -> id_imm_z_uext,
  ))
  val id_op2_data_im1 = Wire(UInt(WORD_LEN.W))
  id_op2_data_im1 := MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op2_sel === OP2_IMI)     -> id_imm_i_sext,
    (id_op2_sel === OP2_IMS)     -> id_imm_s_sext,
    (id_op2_sel === OP2_IMJ)     -> id_imm_j_sext,
    (id_op2_sel === OP2_IMU)     -> id_imm_u_shifted,
    (id_op2_sel === OP2_C_IMI16) -> id_c_imm_i16,
    (id_op2_sel === OP2_C_IMI)   -> id_c_imm_i,
    (id_op2_sel === OP2_C_IMIU)  -> id_c_imm_iu,
    (id_op2_sel === OP2_C_IMJ)   -> id_c_imm_j,
    (id_op2_sel === OP2_IMALL1)  -> Fill(WORD_LEN, 1.U),
    (id_op2_sel === OP2_C_IMA2W) -> id_c_imm_a2w,
    (id_op2_sel === OP2_C_IMA2B) -> id_c_imm_a2b,
    (id_op2_sel === OP2_C_IMU)   -> id_c_imm_u,
    (id_op2_sel === OP2_RS2)     -> DontCare,
    (id_op2_sel === OP2_C_RS2)   -> DontCare,
    (id_op2_sel === OP2_C_RS3P)  -> DontCare,
    (id_op2_sel === OP2_C_RS2P)  -> DontCare,
    (id_op2_sel === OP2_C_RS1P)  -> DontCare,
  ))
  val id_op2_data_im0 = Wire(UInt(12.W))
  id_op2_data_im0 := MuxCase(0.U(12.W), Seq(
    (id_op2_sel === OP2_Z)       -> 0.U(12.W),
    (id_op2_sel === OP2_C_IMIW)  -> id_c_imm_iw,
    (id_op2_sel === OP2_C_IMLS)  -> id_c_imm_ls,
    (id_op2_sel === OP2_C_IMSL)  -> id_c_imm_sl,
    (id_op2_sel === OP2_C_IMSS)  -> id_c_imm_ss,
    (id_op2_sel === OP2_C_IMLSB) -> id_c_imm_lsb,
    (id_op2_sel === OP2_C_IMLSH) -> id_c_imm_lsh,
    (id_op2_sel === OP2_C_IMSW0) -> id_c_imm_sw0,
    (id_op2_sel === OP2_C_IMSB0) -> id_c_imm_sb0,
    (id_op2_sel === OP2_C_IMSH0) -> id_c_imm_sh0,
    (id_op2_sel === OP2_IM255)   -> 255.U(12.W),
    (id_op2_sel === OP2_IM1)     -> 1.U(12.W),
    (id_op2_sel === OP2_RS2)     -> DontCare,
    (id_op2_sel === OP2_C_RS2)   -> DontCare,
    (id_op2_sel === OP2_C_RS3P)  -> DontCare,
    (id_op2_sel === OP2_C_RS2P)  -> DontCare,
    (id_op2_sel === OP2_C_RS1P)  -> DontCare,
  ))

  val id_csr_addr = Mux(id_exe_fun === CMD_ECALL && id_mem_w === MW_CSR, CSR_ADDR_MCAUSE, id_inst(31,20))

  val id_m_op1_sel = MuxCase(M_OP1_IMM, Seq(
    (id_op1_sel === OP1_RS1)    -> M_OP1_RS,
    (id_op1_sel === OP1_C_RS1)  -> M_OP1_RS,
    (id_op1_sel === OP1_C_SP)   -> M_OP1_RS,
    (id_op1_sel === OP1_C_RS1P) -> M_OP1_RS,
  ))
  // val id_m_op2_sel = MuxCase(M_OP2_IMM, Seq(
  //   (id_op2_sel === OP2_RS2)    -> M_OP2_RS,
  //   (id_op2_sel === OP2_C_RS2)  -> M_OP2_RS,
  //   (id_op2_sel === OP2_C_RS1P) -> M_OP2_RS,
  //   (id_op2_sel === OP2_C_RS2P) -> M_OP2_RS,
  //   (id_op2_sel === OP2_C_RS3P) -> M_OP2_RS,
  //   // (id_op2_sel === OP2_RS_X)   -> M_OP2_RS,
  // ))
  val id_m_op2_sel = id_op2_sel(OP2_LEN - 1)
  val id_m_op3_sel = MuxCase(M_OP3_Z, Seq(
    (id_op3_sel === OP3_Z)       -> M_OP3_Z,
    (id_op3_sel === OP3_MSB)     -> M_OP3_MSB,
    (id_op3_sel === OP3_OP1)     -> M_OP3_OP1,
    (id_op3_sel === OP3_RS2)     -> M_OP3_RS,
    (id_op3_sel === OP3_C_RS2)   -> M_OP3_RS,
    (id_op3_sel === OP3_C_RS2P)  -> M_OP3_RS,
    (id_op3_sel === OP3_RS3)     -> M_OP3_RS,
    (id_op3_sel === OP3_RD)      -> M_OP3_RS,
  ))
  val id_m_rs1_addr = MuxCase(id_rs1_addr, Seq(
    (id_op1_sel === OP1_C_RS1)  -> id_c_rs1_addr,
    (id_op1_sel === OP1_C_SP)   -> 2.U(ADDR_LEN.W),
    (id_op1_sel === OP1_C_RS1P) -> id_c_rs1p_addr,
  ))
  val id_m_rs2_addr = MuxCase(id_rs2_addr, Seq(
    (id_op2_sel === OP2_C_RS2)  -> id_c_rs2_addr,
    (id_op2_sel === OP2_C_RS1P) -> id_c_rs1p_addr,
    (id_op2_sel === OP2_C_RS2P) -> id_c_rs2p_addr,
    (id_op2_sel === OP2_C_RS3P) -> id_c_rs3p_addr,
  ))
  val id_m_rs3_addr = MuxCase(id_rs2_addr, Seq(
    (id_op3_sel === OP3_C_RS2)  -> id_c_rs2_addr,
    (id_op3_sel === OP3_C_RS2P) -> id_c_rs2p_addr,
    (id_op3_sel === OP3_RS3)    -> id_rs3_addr,
    (id_op3_sel === OP3_RD)     -> id_w_wb_addr,
  ))
  val id_m_imm_b_sext = MuxCase(id_imm_b_sext, Seq(
    (id_wba === WBA_CBR) -> id_c_imm_b,
    (id_wba === WBA_CB2) -> id_c_imm_b2,
  ))

  val id_is_direct_j = (id_op2_sel === OP2_IMJ) || (id_op2_sel === OP2_C_IMJ)
  val id_is_br = (id_mem_w === MW_BR)
  val id_is_j = (id_wb_sel === WB_PC)
  val id_is_trap = (id_exe_fun === CMD_ECALL && id_mem_w === MW_CSR)
  val id_mcause = CSR_MCAUSE_ECALL_M
  // val id_mtval = 0.U(WORD_LEN.W)

  id_reg_br_pc := Mux(id_is_half, id_reg_pc + 1.U(PC_LEN.W), id_reg_pc + 2.U(PC_LEN.W))
  id_reg_is_bp_fail := !id_reg_stall && !ex2_reg_is_br && !id_reg_is_bp_fail && !id_is_j && !id_is_br && id_reg_bp_taken

  if (enable_pipeline_probe) {
    io.pipeline_probe.id_valid   := (id_inst =/= BUBBLE)
    io.pipeline_probe.id_inst_id := id_reg_inst_id
  }

  val id_reg_pc_delay         = RegInit(0.U(PC_LEN.W))
  val id_reg_wb_addr_delay    = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_sel_delay    = RegInit(0.U(M_OP1_LEN.W))
  val id_reg_op2_sel_delay    = RegInit(0.U(M_OP2_LEN.W))
  val id_reg_op3_sel_delay    = RegInit(0.U(M_OP3_LEN.W))
  val id_reg_rs1_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_rs2_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_rs3_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_op2_data_im1_delay = RegInit(0.U(WORD_LEN.W))
  val id_reg_op2_data_im0_delay = RegInit(0.U(12.W))
  val id_reg_exe_fun_delay    = RegInit(0.U(EXE_FUN_LEN.W))
  val id_reg_rf_wen_delay     = RegInit(0.U(REN_LEN.W))
  val id_reg_wb_sel_delay     = RegInit(0.U(WB_SEL_LEN.W))
  val id_reg_csr_addr_delay   = RegInit(0.U(CSR_ADDR_LEN.W))
  val id_reg_csr_cmd_delay    = RegInit(0.U(CSR_LEN.W))
  val id_reg_imm_b_sext_delay = RegInit(0.U(WORD_LEN.W))
  val id_reg_shamt_delay      = RegInit(0.U(2.W))
  val id_reg_op2op_delay      = RegInit(0.U(OP2OP_LEN.W))
  val id_reg_mem_w_delay      = RegInit(0.U(MW_LEN.W))
  val id_reg_imm_mask_len_delay = RegInit(0.U(5.W))
  val id_reg_is_direct_j_delay = RegInit(false.B)
  val id_reg_is_br_delay      = RegInit(false.B)
  val id_reg_is_j_delay       = RegInit(false.B)
  val id_reg_bp_taken_delay   = RegInit(false.B)
  val id_reg_bp_taken_pc_delay = RegInit(0.U(PC_LEN.W))
  val id_reg_bp_cnt_delay     = RegInit(0.U(2.W))
  val id_reg_is_half_delay    = RegInit(false.B)
  val id_reg_is_valid_inst_delay = RegInit(false.B)
  val id_reg_is_trap_delay    = RegInit(false.B)
  val id_reg_mcause_delay     = RegInit(0.U(WORD_LEN.W))
  // val id_reg_mtval_delay      = RegInit(0.U(WORD_LEN.W))

  when (ex2_reg_is_br || id_reg_is_bp_fail) {
    when (!id_reg_stall) {
      id_reg_pc_delay          := id_reg_pc
      id_reg_op1_sel_delay    := id_m_op1_sel
      id_reg_op2_sel_delay    := id_m_op2_sel
      id_reg_op3_sel_delay    := id_m_op3_sel
      id_reg_rs1_addr_delay   := id_m_rs1_addr
      id_reg_rs2_addr_delay   := id_m_rs2_addr
      id_reg_rs3_addr_delay   := id_m_rs3_addr
      id_reg_op1_data_delay   := id_op1_data
      id_reg_op2_data_im1_delay := id_op2_data_im1
      id_reg_op2_data_im0_delay := id_op2_data_im0
      id_reg_wb_addr_delay    := id_wb_addr
      id_reg_imm_b_sext_delay := id_m_imm_b_sext
      id_reg_shamt_delay      := id_shamt
      id_reg_op2op_delay      := id_op2op
      id_reg_imm_mask_len_delay := id_imm_mask_len
      id_reg_csr_addr_delay   := id_csr_addr
      id_reg_is_direct_j_delay := id_is_direct_j
      id_reg_bp_taken_pc_delay := id_reg_bp_taken_pc
      id_reg_bp_cnt_delay     := id_reg_bp_cnt
      id_reg_is_half_delay    := id_is_half
      id_reg_mcause_delay     := id_mcause
    }
    id_reg_rf_wen_delay        := REN_X
    id_reg_exe_fun_delay       := ALU_ADD
    id_reg_wb_sel_delay        := WB_X
    id_reg_csr_cmd_delay       := CSR_X
    id_reg_mem_w_delay         := MW_X
    id_reg_is_br_delay         := false.B
    id_reg_is_j_delay          := false.B
    id_reg_bp_taken_delay      := false.B
    id_reg_is_valid_inst_delay := false.B
    id_reg_is_trap_delay       := false.B
  }.elsewhen (!id_reg_stall) {
    id_reg_pc_delay         := id_reg_pc
    id_reg_op1_sel_delay    := id_m_op1_sel
    id_reg_op2_sel_delay    := id_m_op2_sel
    id_reg_op3_sel_delay    := id_m_op3_sel
    id_reg_rs1_addr_delay   := id_m_rs1_addr
    id_reg_rs2_addr_delay   := id_m_rs2_addr
    id_reg_rs3_addr_delay   := id_m_rs3_addr
    id_reg_op1_data_delay   := id_op1_data
    id_reg_op2_data_im1_delay := id_op2_data_im1
    id_reg_op2_data_im0_delay := id_op2_data_im0
    id_reg_wb_addr_delay    := id_wb_addr
    id_reg_rf_wen_delay     := id_rf_wen
    id_reg_exe_fun_delay    := id_exe_fun
    id_reg_wb_sel_delay     := id_wb_sel
    id_reg_imm_b_sext_delay := id_m_imm_b_sext
    id_reg_shamt_delay      := id_shamt
    id_reg_op2op_delay      := id_op2op
    id_reg_imm_mask_len_delay := id_imm_mask_len
    id_reg_csr_addr_delay   := id_csr_addr
    id_reg_csr_cmd_delay    := id_csr_cmd
    id_reg_mem_w_delay      := id_mem_w
    id_reg_is_direct_j_delay := id_is_direct_j
    id_reg_is_br_delay      := id_is_br
    id_reg_is_j_delay       := id_is_j
    id_reg_bp_taken_delay   := id_reg_bp_taken
    id_reg_bp_taken_pc_delay := id_reg_bp_taken_pc
    id_reg_bp_cnt_delay     := id_reg_bp_cnt
    id_reg_is_half_delay    := id_is_half
    id_reg_is_valid_inst_delay := id_inst =/= BUBBLE
    id_reg_is_trap_delay    := id_is_trap
    id_reg_mcause_delay     := id_mcause
    // id_reg_mtval_delay      := id_mtval
    if (enable_pipeline_probe) {
      id_reg_inst_id_delay  := id_reg_inst_id
    }
  }

  //**********************************
  // ID/RRD register
  when (ex2_reg_is_br || id_reg_is_bp_fail) {
    when(id_reg_stall) {
      rrd_reg_pc            := id_reg_pc_delay
      rrd_reg_op1_sel       := id_reg_op1_sel_delay
      rrd_reg_op2_sel       := id_reg_op2_sel_delay
      rrd_reg_op3_sel       := id_reg_op3_sel_delay
      rrd_reg_rs1_addr      := id_reg_rs1_addr_delay
      rrd_reg_rs2_addr      := id_reg_rs2_addr_delay
      rrd_reg_rs3_addr      := id_reg_rs3_addr_delay
      rrd_reg_op1_data      := id_reg_op1_data_delay
      rrd_reg_op2_data_im1  := id_reg_op2_data_im1_delay
      rrd_reg_op2_data_im0  := id_reg_op2_data_im0_delay
      rrd_reg_wb_addr       := id_reg_wb_addr_delay
      rrd_reg_rf_wen        := REN_X
      rrd_reg_exe_fun       := ALU_ADD
      rrd_reg_wb_sel        := WB_X
      rrd_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      rrd_reg_shamt         := id_reg_shamt_delay
      rrd_reg_op2op         := id_reg_op2op_delay
      rrd_reg_csr_addr      := id_reg_csr_addr_delay
      rrd_reg_csr_cmd       := CSR_X
      rrd_reg_mem_w         := MW_X
      rrd_reg_imm_mask_len  := id_reg_imm_mask_len_delay
      rrd_reg_is_direct_j   := false.B
      rrd_reg_is_br         := false.B
      rrd_reg_is_j          := false.B
      rrd_reg_bp_taken      := false.B
      rrd_reg_bp_taken_pc   := id_reg_bp_taken_pc_delay
      rrd_reg_bp_cnt        := id_reg_bp_cnt_delay
      rrd_reg_is_half       := id_reg_is_half_delay
      rrd_reg_is_valid_inst := false.B
      rrd_reg_is_trap       := false.B
      rrd_reg_mcause        := id_reg_mcause_delay
      // rrd_reg_mtval         := id_reg_mtval_delay
      if (enable_pipeline_probe) {
        rrd_reg_inst_id     := id_reg_inst_id_delay
      }
    }.otherwise {
      rrd_reg_pc            := id_reg_pc
      rrd_reg_op1_sel       := id_m_op1_sel
      rrd_reg_op2_sel       := id_m_op2_sel
      rrd_reg_op3_sel       := id_m_op3_sel
      rrd_reg_rs1_addr      := id_m_rs1_addr
      rrd_reg_rs2_addr      := id_m_rs2_addr
      rrd_reg_rs3_addr      := id_m_rs3_addr
      rrd_reg_op1_data      := id_op1_data
      rrd_reg_op2_data_im1  := id_op2_data_im1
      rrd_reg_op2_data_im0  := id_op2_data_im0
      rrd_reg_wb_addr       := id_wb_addr
      rrd_reg_rf_wen        := REN_X
      rrd_reg_exe_fun       := ALU_ADD
      rrd_reg_wb_sel        := WB_X
      rrd_reg_imm_b_sext    := id_m_imm_b_sext
      rrd_reg_shamt         := id_shamt
      rrd_reg_op2op         := id_op2op
      rrd_reg_csr_addr      := id_csr_addr
      rrd_reg_csr_cmd       := CSR_X
      rrd_reg_mem_w         := MW_X
      rrd_reg_imm_mask_len  := id_imm_mask_len
      rrd_reg_is_direct_j   := false.B
      rrd_reg_is_br         := false.B
      rrd_reg_is_j          := false.B
      rrd_reg_bp_taken      := false.B
      rrd_reg_bp_taken_pc   := id_reg_bp_taken_pc
      rrd_reg_bp_cnt        := id_reg_bp_cnt
      rrd_reg_is_half       := id_is_half
      rrd_reg_is_valid_inst := false.B
      rrd_reg_is_trap       := false.B
      rrd_reg_mcause        := id_mcause
      // rrd_reg_mtval         := id_mtval
      if (enable_pipeline_probe) {
        rrd_reg_inst_id     := id_reg_inst_id
      }
    }
  }.elsewhen(!rrd_stall && !ex2_stall) {
    when(id_reg_stall) {
      rrd_reg_pc            := id_reg_pc_delay
      rrd_reg_op1_sel       := id_reg_op1_sel_delay
      rrd_reg_op2_sel       := id_reg_op2_sel_delay
      rrd_reg_op3_sel       := id_reg_op3_sel_delay
      rrd_reg_rs1_addr      := id_reg_rs1_addr_delay
      rrd_reg_rs2_addr      := id_reg_rs2_addr_delay
      rrd_reg_rs3_addr      := id_reg_rs3_addr_delay
      rrd_reg_op1_data      := id_reg_op1_data_delay
      rrd_reg_op2_data_im1  := id_reg_op2_data_im1_delay
      rrd_reg_op2_data_im0  := id_reg_op2_data_im0_delay
      rrd_reg_wb_addr       := id_reg_wb_addr_delay
      rrd_reg_rf_wen        := id_reg_rf_wen_delay
      rrd_reg_exe_fun       := id_reg_exe_fun_delay
      rrd_reg_wb_sel        := id_reg_wb_sel_delay
      rrd_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      rrd_reg_shamt         := id_reg_shamt_delay
      rrd_reg_op2op         := id_reg_op2op_delay
      rrd_reg_csr_addr      := id_reg_csr_addr_delay
      rrd_reg_csr_cmd       := id_reg_csr_cmd_delay
      rrd_reg_mem_w         := id_reg_mem_w_delay
      rrd_reg_imm_mask_len  := id_reg_imm_mask_len_delay
      rrd_reg_is_direct_j   := id_reg_is_direct_j_delay
      rrd_reg_is_br         := id_reg_is_br_delay
      rrd_reg_is_j          := id_reg_is_j_delay
      rrd_reg_bp_taken      := id_reg_bp_taken_delay
      rrd_reg_bp_taken_pc   := id_reg_bp_taken_pc_delay
      rrd_reg_bp_cnt        := id_reg_bp_cnt_delay
      rrd_reg_is_half       := id_reg_is_half_delay
      rrd_reg_is_valid_inst := id_reg_is_valid_inst_delay
      rrd_reg_is_trap       := id_reg_is_trap_delay
      rrd_reg_mcause        := id_reg_mcause_delay
      // rrd_reg_mtval         := id_reg_mtval_delay
      if (enable_pipeline_probe) {
        rrd_reg_inst_id     := id_reg_inst_id_delay
      }
    }.otherwise {
      rrd_reg_pc            := id_reg_pc
      rrd_reg_op1_sel       := id_m_op1_sel
      rrd_reg_op2_sel       := id_m_op2_sel
      rrd_reg_op3_sel       := id_m_op3_sel
      rrd_reg_rs1_addr      := id_m_rs1_addr
      rrd_reg_rs2_addr      := id_m_rs2_addr
      rrd_reg_rs3_addr      := id_m_rs3_addr
      rrd_reg_op1_data      := id_op1_data
      rrd_reg_op2_data_im1  := id_op2_data_im1
      rrd_reg_op2_data_im0  := id_op2_data_im0
      rrd_reg_wb_addr       := id_wb_addr
      rrd_reg_rf_wen        := id_rf_wen
      rrd_reg_exe_fun       := id_exe_fun
      rrd_reg_wb_sel        := id_wb_sel
      rrd_reg_imm_b_sext    := id_m_imm_b_sext
      rrd_reg_shamt         := id_shamt
      rrd_reg_op2op         := id_op2op
      rrd_reg_csr_addr      := id_csr_addr
      rrd_reg_csr_cmd       := id_csr_cmd
      rrd_reg_mem_w         := id_mem_w
      rrd_reg_imm_mask_len  := id_imm_mask_len
      rrd_reg_is_direct_j   := id_is_direct_j
      rrd_reg_is_br         := id_is_br
      rrd_reg_is_j          := id_is_j
      rrd_reg_bp_taken      := id_reg_bp_taken
      rrd_reg_bp_taken_pc   := id_reg_bp_taken_pc
      rrd_reg_bp_cnt        := id_reg_bp_cnt
      rrd_reg_is_half       := id_is_half
      rrd_reg_is_valid_inst := id_inst =/= BUBBLE
      rrd_reg_is_trap       := id_is_trap
      rrd_reg_mcause        := id_mcause
      // rrd_reg_mtval         := id_mtval
      if (enable_pipeline_probe) {
        rrd_reg_inst_id     := id_reg_inst_id
      }
    }
  }
  //**********************************
  // Register read (RRD) Stage

  rrd_stall :=
    !ex2_reg_is_br && (
      ((rrd_reg_op1_sel === M_OP1_RS) && scoreboard(rrd_reg_rs1_addr)) ||
      ((rrd_reg_op2_sel === M_OP2_RS) && scoreboard(rrd_reg_rs2_addr)) ||
      ((rrd_reg_op3_sel === M_OP3_RS) && scoreboard(rrd_reg_rs3_addr)) ||
      ((rrd_reg_rf_wen === REN_S) && scoreboard(rrd_reg_wb_addr))
    )

  val rrd_op1_data = MuxCase(rrd_reg_op1_data, Seq(
    (rrd_reg_op1_sel === M_OP1_RS && rrd_reg_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_op1_sel === M_OP1_RS) &&
     (rrd_reg_rs1_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_op1_sel === M_OP1_RS) &&
     (rrd_reg_rs1_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
    (mem3_reg_fw_en &&
     (rrd_reg_op1_sel === M_OP1_RS) &&
     (rrd_reg_rs1_addr === mem3_reg_wb_addr)) -> mem3_fw_data,
    (rrd_reg_op1_sel === M_OP1_RS) -> regfile(rrd_reg_rs1_addr),
  ))
  val rrd_op2_data = MuxCase(rrd_reg_op2_data_im1 | Cat(0.U(20.W), rrd_reg_op2_data_im0), Seq(
    (rrd_reg_op2_sel === M_OP2_RS && rrd_reg_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_op2_sel === M_OP2_RS) &&
     (rrd_reg_rs2_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_op2_sel === M_OP2_RS) &&
     (rrd_reg_rs2_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
    (mem3_reg_fw_en &&
     (rrd_reg_op2_sel === M_OP2_RS) &&
     (rrd_reg_rs2_addr === mem3_reg_wb_addr)) -> mem3_fw_data,
    (rrd_reg_op2_sel === M_OP2_RS) -> regfile(rrd_reg_rs2_addr),
  ))
  val rrd_op3_data = MuxCase(regfile(rrd_reg_rs3_addr), Seq(
    (rrd_reg_op3_sel === M_OP3_Z)   -> 0.U(WORD_LEN.W),
    (rrd_reg_op3_sel === M_OP3_MSB) -> Fill(WORD_LEN, rrd_op1_data(WORD_LEN-1, WORD_LEN-1)),
    (rrd_reg_op3_sel === M_OP3_OP1) -> rrd_op1_data,
    (rrd_reg_rs3_addr === 0.U)    -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_rs3_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_rs3_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
    (mem3_reg_fw_en &&
     (rrd_reg_rs3_addr === mem3_reg_wb_addr)) -> mem3_fw_data,
  ))

  val rrd_imm_mask = Mux(rrd_reg_imm_mask_len === 0.U,
    Fill(WORD_LEN, 1.U(1.W)),
    Cat((0 until WORD_LEN).reverse.map(bit => (bit.U < rrd_reg_imm_mask_len).asUInt))
  )

  val rrd_direct_jbr_pc = rrd_reg_pc + rrd_reg_imm_b_sext(WORD_LEN-1, WORD_LEN-PC_LEN)

  val rrd_hazard = (rrd_reg_rf_wen === REN_S) && (rrd_reg_wb_addr =/= 0.U) && !rrd_stall && !ex2_reg_is_br
  val rrd_fw_en_next = rrd_hazard && (rrd_reg_wb_sel === WB_ALU)

  val rrd_mem_use_reg   = WireDefault(false.B)
  val rrd_inst2_use_reg = WireDefault(false.B)
  val rrd_inst3_use_reg = WireDefault(false.B)

  when (
    !ex2_stall && !rrd_stall && !ex2_reg_is_br &&
    rrd_reg_rf_wen === REN_S && rrd_reg_wb_addr =/= 0.U
  ) {
      scoreboard(rrd_reg_wb_addr) := rrd_reg_wb_sel =/= WB_ALU
      rrd_mem_use_reg   := rrd_reg_wb_sel === WB_LD
      rrd_inst2_use_reg := (rrd_reg_wb_sel === WB_BIT || rrd_reg_wb_sel === WB_PC)
      rrd_inst3_use_reg := (rrd_reg_wb_sel === WB_MD || rrd_reg_wb_sel === WB_CSR)
  }

  if (enable_pipeline_probe) {
    io.pipeline_probe.rrd_valid   := rrd_reg_is_valid_inst && !ex2_reg_is_br
    io.pipeline_probe.rrd_inst_id := rrd_reg_inst_id
  }

  //**********************************
  // RRD/EX1 register
  when(!ex2_stall) {
    val ex_is_bubble = rrd_stall || ex2_reg_is_br
    ex1_reg_pc            := rrd_reg_pc
    ex1_reg_op1_data      := rrd_op1_data
    ex1_reg_op2_data      := rrd_op2_data
    ex1_reg_op3_data      := rrd_op3_data
    ex1_reg_wb_addr       := rrd_reg_wb_addr
    ex1_reg_rf_wen        := Mux(ex_is_bubble, REN_X, rrd_reg_rf_wen)
    ex1_reg_exe_fun       := rrd_reg_exe_fun
    ex1_reg_wb_sel        := Mux(ex_is_bubble, WB_X, rrd_reg_wb_sel)
    ex1_reg_direct_jbr_pc := rrd_direct_jbr_pc
    ex1_reg_csr_addr      := rrd_reg_csr_addr
    ex1_reg_csr_cmd       := rrd_reg_csr_cmd
    ex1_reg_shamt         := rrd_reg_shamt
    ex1_reg_op2op         := rrd_reg_op2op
    ex1_reg_mem_w         := rrd_reg_mem_w
    ex1_reg_imm_mask      := rrd_imm_mask
    ex1_reg_is_mret       := !ex_is_bubble && (rrd_reg_exe_fun === CMD_MRET && rrd_reg_mem_w === MW_CSR)
    ex1_reg_is_br         := Mux(ex_is_bubble, false.B, rrd_reg_is_br)
    ex1_reg_is_j          := Mux(ex_is_bubble, false.B, rrd_reg_is_j)
    ex1_reg_bp_taken      := Mux(ex_is_bubble, false.B, rrd_reg_bp_taken)
    ex1_reg_bp_taken_pc   := rrd_reg_bp_taken_pc
    ex1_reg_bp_cnt        := rrd_reg_bp_cnt
    ex1_reg_is_half       := rrd_reg_is_half
    ex1_reg_is_valid_inst := rrd_reg_is_valid_inst && !ex_is_bubble
    ex1_reg_is_trap       := Mux(ex_is_bubble, false.B, rrd_reg_is_trap)
    ex1_reg_mcause        := rrd_reg_mcause
    // ex1_reg_mtval         := rrd_reg_mtval
    ex1_reg_mem_use_reg   := rrd_mem_use_reg
    ex1_reg_inst2_use_reg := rrd_inst2_use_reg
    ex1_reg_inst3_use_reg := rrd_inst3_use_reg
    ex1_reg_fw_en         := rrd_fw_en_next
    if (enable_pipeline_probe) {
      ex1_reg_inst_id     := rrd_reg_inst_id
    }
  }

  //**********************************
  // Execute (EX1) Stage

  val ex1_add_out = ex1_reg_op1_data + ex1_reg_op2_data
  val ex1_alu_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_exe_fun === ALU_ADD)   -> ex1_add_out,
    (ex1_reg_exe_fun === ALU_SUB)   -> (ex1_reg_op1_data - Mux(ex1_reg_op2op === OP2OP_NOP, ex1_reg_op2_data, 0.U(WORD_LEN.W))),
    (ex1_reg_exe_fun === ALU_AND)   -> (ex1_reg_op1_data & Mux(ex1_reg_op2op === OP2OP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_OR)    -> (ex1_reg_op1_data | Mux(ex1_reg_op2op === OP2OP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_XOR)   -> (ex1_reg_op1_data ^ Mux(ex1_reg_op2op === OP2OP_NOP, ex1_reg_op2_data, ~ex1_reg_op2_data)),
    (ex1_reg_exe_fun === ALU_FSL)   -> (Cat(ex1_reg_op1_data, ex1_reg_op3_data(WORD_LEN-1, 1)) >> (~ex1_reg_op2_data)(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_exe_fun === ALU_FSR)   -> (Cat(ex1_reg_op3_data(WORD_LEN-2, 0), ex1_reg_op1_data) >> ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0),
    (ex1_reg_exe_fun === ALU_SLT)   -> (ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt).asUInt,
    (ex1_reg_exe_fun === ALU_SLTU)  -> (ex1_reg_op1_data < ex1_reg_op2_data).asUInt,
    (ex1_reg_exe_fun === ALU_SHADD) -> ((ex1_reg_op1_data << ex1_reg_shamt)(WORD_LEN-1, 0) + ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_CMOV)  -> Mux(0.U(WORD_LEN.W) < ex1_reg_op2_data, ex1_reg_op1_data, ex1_reg_op3_data),
    (ex1_reg_exe_fun === ALU_BCLR)  -> (ex1_reg_op1_data & ~((1.U(WORD_LEN.W) << ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0))),
    (ex1_reg_exe_fun === ALU_BSET)  -> (ex1_reg_op1_data | (1.U(WORD_LEN.W) << ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0)),
    (ex1_reg_exe_fun === ALU_BINV)  -> (ex1_reg_op1_data ^ (1.U(WORD_LEN.W) << ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0)),
    (ex1_reg_exe_fun === ALU_BEXT)  -> Cat(Fill(WORD_LEN-1, 0.U(1.W)), (ex1_reg_op1_data >> ex1_reg_op2_data(4, 0))(0)),
  ))

  val ex1_mullu  = (ex1_reg_op1_data * ex1_reg_op2_data(WORD_LEN/2-1, 0))
  val ex1_mulls  = (ex1_reg_op1_data.asSInt * ex1_reg_op2_data(WORD_LEN/2-1, 0))(WORD_LEN*3/2-1, WORD_LEN/2)
  val ex1_mulhuu = (ex1_reg_op1_data * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2))
  val ex1_mulhss = (ex1_reg_op1_data.asSInt * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2).asSInt)
  val ex1_mulhsu = (ex1_reg_op1_data.asSInt * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2))

  def scatter_bit(value: UInt, mask: UInt, bit: Int): UInt = {
    if (bit == 0) {
      Mux(mask(bit).asBool, value(0), 0.U(1.W))
    } else {
      Mux(mask(bit).asBool, (value >> PopCount(mask(bit - 1, 0)))(0), 0.U(1.W))
    }
  }

  val ex1_next_pc = Mux(ex1_reg_is_half, ex1_reg_pc + 1.U(PC_LEN.W), ex1_reg_pc + 2.U(PC_LEN.W))
  val ex1_pc_bit_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_wb_sel === WB_PC)      -> Cat(ex1_next_pc, 0.U(1.W)),
    (ex1_reg_exe_fun === ALU_ZEXTH) -> Cat(0.U(16.W), ex1_reg_op1_data(15, 0)),
    (ex1_reg_exe_fun === ALU_CPOP)  -> PopCount(ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_CLZ)   -> PriorityEncoder(Cat(1.U(1.W), Reverse(ex1_reg_op1_data))),
    (ex1_reg_exe_fun === ALU_CTZ)   -> PriorityEncoder(Cat(1.U(1.W), ex1_reg_op1_data)),
    (ex1_reg_exe_fun === ALU_REV8)  -> Cat(ex1_reg_op1_data(7, 0), ex1_reg_op1_data(15, 8), ex1_reg_op1_data(23, 16), ex1_reg_op1_data(31, 24)),
    (ex1_reg_exe_fun === ALU_SEXTB) -> Cat(Fill(24, ex1_reg_op1_data(7)), ex1_reg_op1_data(7, 0)),
    (ex1_reg_exe_fun === ALU_SEXTH) -> Cat(Fill(16, ex1_reg_op1_data(15)), ex1_reg_op1_data(15, 0)),
    (ex1_reg_exe_fun === ALU_MAX)   -> Mux(ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt, ex1_reg_op2_data, ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_MAXU)  -> Mux(ex1_reg_op1_data < ex1_reg_op2_data, ex1_reg_op2_data, ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_MIN)   -> Mux(ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt, ex1_reg_op1_data, ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_MINU)  -> Mux(ex1_reg_op1_data < ex1_reg_op2_data, ex1_reg_op1_data, ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_BSCTH) -> Cat((0 until 16).reverse.map(bit => scatter_bit(ex1_reg_op1_data, ex1_reg_op2_data, bit))),
    (ex1_reg_exe_fun === ALU_BFM || ex1_reg_exe_fun === ALU_BFP)
                                    -> (ex1_reg_imm_mask << ex1_reg_op2_data(4, 0))(WORD_LEN-1, 0),
  ))

  val ex1_fun_sel = MuxCase(EX2_ALU, Seq(
    (
      (ex1_reg_wb_sel === WB_PC || ex1_reg_wb_sel === WB_BIT) &&
      (ex1_reg_exe_fun === ALU_BFM || ex1_reg_exe_fun === ALU_BFP)
    )                                                          -> EX2_MASK,
    (ex1_reg_wb_sel === WB_PC || ex1_reg_wb_sel === WB_BIT)    -> EX2_BIT,
    (ex1_reg_wb_sel === WB_CSR || ex1_reg_wb_sel === WB_FENCE) -> EX2_CSR,
    (ex1_reg_wb_sel === WB_MD)                                 -> EX2_MD,
  ))

  val ex1_divrem = WireDefault(false.B)
  val ex1_sign_op1 = WireDefault(0.U(1.W))
  val ex1_sign_op12 = WireDefault(0.U(1.W))
  val ex1_zero_op2 = Wire(Bool())
  val ex1_dividend = WireDefault(0.U((WORD_LEN+5).W))
  val ex1_divisor = WireDefault(0.U(WORD_LEN.W))
  val ex1_orig_dividend = Wire(UInt(WORD_LEN.W))

  when (ex1_reg_exe_fun === ALU_DIV || ex1_reg_exe_fun === ALU_REM) {
    ex1_divrem := ex1_reg_wb_sel === WB_MD
    when (ex1_reg_op1_data(WORD_LEN-1) === 1.U) {
      ex1_dividend := Cat(Fill(5, 0.U(1.W)), (~ex1_reg_op1_data + 1.U)(WORD_LEN-1, 0))
    }.otherwise {
      ex1_dividend := Cat(Fill(5, 0.U(1.W)), ex1_reg_op1_data(WORD_LEN-1, 0))
    }
    ex1_sign_op1 := ex1_reg_op1_data(WORD_LEN-1)
    when (ex1_reg_op2_data(WORD_LEN-1) === 1.U) {
      ex1_divisor := (~ex1_reg_op2_data + 1.U)(WORD_LEN-1, 0)
      ex1_sign_op12 := (ex1_sign_op1 === 0.U)
    }.otherwise {
      ex1_divisor := ex1_reg_op2_data
      ex1_sign_op12 := (ex1_sign_op1 === 1.U)
    }
  }.elsewhen (ex1_reg_exe_fun === ALU_DIVU || ex1_reg_exe_fun === ALU_REMU) {
    ex1_divrem := ex1_reg_wb_sel === WB_MD
    ex1_dividend := Cat(Fill(5, 0.U(1.W)), ex1_reg_op1_data(WORD_LEN-1, 0))
    ex1_sign_op1 := 0.U
    ex1_divisor := ex1_reg_op2_data
    ex1_sign_op12 := 0.U
  }
  ex1_zero_op2 := (ex1_reg_op2_data === 0.U)
  ex1_orig_dividend := ex1_reg_op1_data

  // branch
  val ex1_is_cond_br = Wire(Bool())
  ex1_is_cond_br := MuxCase(DontCare, Seq(
    (ex1_reg_exe_fun === BR_BEQ)  ->  (ex1_reg_op1_data === ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BNE)  -> !(ex1_reg_op1_data === ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BLT)  ->  (ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt),
    (ex1_reg_exe_fun === BR_BGE)  -> !(ex1_reg_op1_data.asSInt < ex1_reg_op2_data.asSInt),
    (ex1_reg_exe_fun === BR_BLTU) ->  (ex1_reg_op1_data < ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BGEU) -> !(ex1_reg_op1_data < ex1_reg_op2_data)
  ))
  val ex1_is_cond_br_inst = ex1_reg_is_br
  val ex1_is_uncond_br    = ex1_reg_is_j
  val ex1_taken_pc = Mux(ex1_is_uncond_br, ex1_add_out(WORD_LEN-1, WORD_LEN-PC_LEN), ex1_reg_direct_jbr_pc)
  val ex1_br_pc = MuxCase(ex1_next_pc, Seq(
    csr_is_br                                                     -> csr_br_pc,
    ((ex1_is_cond_br_inst && ex1_is_cond_br) || ex1_is_uncond_br) -> ex1_taken_pc,
  ))
  val ex1_predict_pc = Mux(ex1_reg_bp_taken, ex1_reg_bp_taken_pc, ex1_next_pc)
  val ex1_bp_failure = ex1_br_pc =/= ex1_predict_pc

  ex1_is_br := ex1_bp_failure && !ex2_reg_is_br

  ic_btb.io.up.en       := ex1_en && ((ex1_is_cond_br_inst && ex1_is_cond_br) || ex1_is_uncond_br)
  ic_btb.io.up.pc       := ex1_reg_pc
  ic_btb.io.up.taken_pc := ex1_taken_pc
  ic_pht.io.up.en       := ex1_en && (ex1_is_cond_br_inst || ex1_is_uncond_br)
  ic_pht.io.up.pc       := ex1_reg_pc
  ic_pht.io.up.cnt      := Mux((ex1_is_cond_br_inst && ex1_is_cond_br) || ex1_is_uncond_br,
    Cat(ex1_reg_bp_cnt(0, 0), (!ex1_reg_bp_cnt(1) | ex1_reg_bp_cnt(0)).asUInt),
    Cat(!ex1_reg_bp_cnt(0, 0), (ex1_reg_bp_cnt(1) & ex1_reg_bp_cnt(0)).asUInt),
  )

  ex1_fw_data := ex1_alu_out

  when (ex1_reg_inst2_use_reg || (!ex1_en && (ex1_reg_mem_use_reg || ex1_reg_inst3_use_reg))) {
    scoreboard(ex1_reg_wb_addr) := false.B
  }

  val ex1_hazard = (ex1_reg_rf_wen === REN_S) && (ex1_reg_wb_addr =/= 0.U) && ex1_en
  val ex1_fw_en_next = ex1_hazard && (ex1_reg_wb_sel =/= WB_MD) && (ex1_reg_wb_sel =/= WB_LD)

  if (enable_pipeline_probe) {
    io.pipeline_probe.ex1_valid   := ex1_en
    io.pipeline_probe.ex1_inst_id := ex1_reg_inst_id
  }

  //**********************************
  // EX1 CSR Stage

  val csr_mie_fw_en = WireDefault(false.B)
  val csr_mie_meie_fw = WireDefault(false.B)
  val csr_mie_mtie_fw = WireDefault(false.B)
  val csr_mstatus_mie_fw_en = WireDefault(false.B)
  val csr_mstatus_mie_fw = WireDefault(false.B)
  val csr_reg_is_meintr = RegNext(
    ((csr_mstatus_mie_fw_en && csr_mstatus_mie_fw) || (!csr_mstatus_mie_fw_en && csr_reg_mstatus_mie)) &&
      io.intr &&
      ((csr_mie_fw_en && csr_mie_meie_fw) || (!csr_mie_fw_en && csr_reg_mie_meie))
  )
  val csr_reg_is_mtintr = RegNext(
    ((csr_mstatus_mie_fw_en && csr_mstatus_mie_fw) || (!csr_mstatus_mie_fw_en && csr_reg_mstatus_mie)) &&
      mtimer.io.intr &&
      ((csr_mie_fw_en && csr_mie_mtie_fw) || (!csr_mie_fw_en && csr_reg_mie_mtie))
  )

  val csr_is_valid_inst = ex1_reg_is_valid_inst && !ex2_reg_is_br
  val csr_is_meintr = csr_reg_is_meintr && csr_is_valid_inst
  val csr_is_mtintr = csr_reg_is_mtintr && csr_is_valid_inst
  ex1_en := csr_is_valid_inst && !csr_is_meintr && !csr_is_mtintr
  val csr_is_trap = ex1_en && ex1_reg_is_trap
  val ex1_is_valid_inst = ex1_en && !ex1_reg_is_trap
  val csr_is_mret = ex1_en && ex1_reg_is_mret

  val csr_rdata = MuxLookup(ex1_reg_csr_addr, 0.U(WORD_LEN.W))(Seq(
    CSR_ADDR_MTVEC    -> Cat(csr_reg_trap_vector, 0.U((WORD_LEN-PC_LEN).W)),
    CSR_ADDR_TIME     -> mtimer.io.mtime(31, 0),
    CSR_ADDR_CYCLE    -> cycle_counter.io.value(31, 0),
    CSR_ADDR_INSTRET  -> instret(31, 0),
    CSR_ADDR_CYCLEH   -> cycle_counter.io.value(63, 32),
    CSR_ADDR_TIMEH    -> mtimer.io.mtime(63, 32),
    CSR_ADDR_INSTRETH -> instret(63, 32),
    CSR_ADDR_MEPC     -> Cat(csr_reg_mepc, 0.U((WORD_LEN-PC_LEN).W)),
    CSR_ADDR_MCAUSE   -> csr_reg_mcause,
    // CSR_ADDR_MTVAL   -> csr_mtval,
    CSR_ADDR_MSTATUS  -> Cat(0.U(24.W), csr_reg_mstatus_mpie.asUInt, 0.U(3.W), csr_reg_mstatus_mie.asUInt, 0.U(3.W)),
    CSR_ADDR_MSCRATCH -> csr_reg_mscratch,
    CSR_ADDR_MIE      -> Cat(0.U(20.W), csr_reg_mie_meie.asUInt, 0.U(3.W), csr_reg_mie_mtie.asUInt, 0.U(7.W)),
    CSR_ADDR_MIP      -> Cat(0.U(20.W), io.intr.asUInt, 0.U(3.W), mtimer.io.intr.asUInt, 0.U(7.W)),
  ))

  val csr_wdata = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_csr_cmd === CSR_W) -> ex1_reg_op1_data,
    (ex1_reg_csr_cmd === CSR_S) -> (csr_rdata | ex1_reg_op1_data),
    (ex1_reg_csr_cmd === CSR_C) -> (csr_rdata & ~ex1_reg_op1_data),
  ))

  when (ex1_en && ex1_reg_wb_sel === WB_CSR) {
    when (ex1_reg_csr_addr === CSR_ADDR_MTVEC) {
      csr_reg_trap_vector := csr_wdata(WORD_LEN-1, WORD_LEN-PC_LEN)
    }.elsewhen (ex1_reg_csr_addr === CSR_ADDR_MEPC) {
      csr_reg_mepc := csr_wdata(WORD_LEN-1, WORD_LEN-PC_LEN)
    }.elsewhen (ex1_reg_csr_addr === CSR_ADDR_MSTATUS) {
      csr_reg_mstatus_mie   := csr_wdata(3)
      csr_reg_mstatus_mpie  := csr_wdata(7)
      csr_mstatus_mie_fw_en := true.B
      csr_mstatus_mie_fw    := csr_wdata(3)
    }.elsewhen (ex1_reg_csr_addr === CSR_ADDR_MSCRATCH) {
      csr_reg_mscratch := csr_wdata
    }.elsewhen (ex1_reg_csr_addr === CSR_ADDR_MIE) {
      csr_reg_mie_meie := csr_wdata(11)
      csr_reg_mie_mtie := csr_wdata(7)
      csr_mie_fw_en    := true.B
      csr_mie_meie_fw  := csr_wdata(11)
      csr_mie_mtie_fw  := csr_wdata(7)
    }
  }

  // csr_mip := Cat(csr_mip(31, 12), io.intr.asUInt, csr_mip(10, 8), mtimer.io.intr.asUInt, csr_mip(6, 0))

  when (csr_is_meintr) {
    csr_reg_mcause       := CSR_MCAUSE_MEI
    // csr_mtval         := 0.U(WORD_LEN.W)
    csr_reg_mepc         := ex1_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_mstatus_mie_fw_en:= true.B
    csr_mstatus_mie_fw   := false.B
    csr_is_br            := true.B
    csr_br_pc            := csr_reg_trap_vector
  }.elsewhen (csr_is_mtintr) {
    csr_reg_mcause       := CSR_MCAUSE_MTI
    // csr_mtval         := 0.U(WORD_LEN.W)
    csr_reg_mepc         := ex1_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_mstatus_mie_fw_en:= true.B
    csr_mstatus_mie_fw   := false.B
    csr_is_br            := true.B
    csr_br_pc            := csr_reg_trap_vector
  }.elsewhen (csr_is_trap) {
    csr_reg_mcause       := ex1_reg_mcause
    // csr_mtval         := ex1_reg_mtval
    csr_reg_mepc         := ex1_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_mstatus_mie_fw_en:= true.B
    csr_mstatus_mie_fw   := false.B
    csr_is_br            := true.B
    csr_br_pc            := csr_reg_trap_vector
  }.elsewhen (csr_is_mret) {
    csr_reg_mstatus_mpie := true.B
    csr_reg_mstatus_mie  := csr_reg_mstatus_mpie
    csr_mstatus_mie_fw_en:= true.B
    csr_mstatus_mie_fw   := csr_reg_mstatus_mpie
    csr_is_br            := true.B
    csr_br_pc            := csr_reg_mepc
  }.otherwise {
    csr_is_br            := false.B
    csr_br_pc            := DontCare
  }

  ex2_reg_is_br := csr_is_br || ex1_is_br
  ex2_reg_br_pc := ex1_br_pc

  //**********************************
  // EX1/EX2 register
  when (!ex2_stall) {
    ex2_reg_pc         := ex1_reg_pc
    ex2_reg_wb_addr    := ex1_reg_wb_addr
    ex2_reg_alu_out    := ex1_alu_out
    ex2_reg_mullu      := ex1_mullu
    ex2_reg_mulls      := ex1_mulls
    ex2_reg_mulhuu     := ex1_mulhuu
    ex2_reg_mulhss     := ex1_mulhss
    ex2_reg_mulhsu     := ex1_mulhsu
    ex2_reg_pc_bit_out := ex1_pc_bit_out
    ex2_reg_exe_fun    := ex1_reg_exe_fun
    ex2_reg_rf_wen     := Mux(ex1_en, ex1_reg_rf_wen, REN_X)
    ex2_reg_fun_sel    := ex1_fun_sel
    ex2_reg_op3_data   := ex1_reg_op3_data
    ex2_reg_no_mem     := (ex1_reg_wb_sel =/= WB_LD && ex1_reg_wb_sel =/= WB_ST && ex1_reg_wb_sel =/= WB_FENCE) && ex1_en
    ex2_reg_is_valid_inst := ex1_is_valid_inst
    ex2_reg_divrem            := ex1_divrem && ex1_en
    ex2_reg_div_stall         := ex2_div_stall_next ||
      (ex1_divrem && ex1_en && (ex2_reg_divrem_state === DivremState.Idle || ex2_reg_divrem_state === DivremState.Finished))
    ex2_reg_sign_op1          := ex1_sign_op1
    ex2_reg_sign_op12         := ex1_sign_op12
    ex2_reg_zero_op2          := ex1_zero_op2
    ex2_reg_init_dividend     := ex1_dividend
    ex2_reg_init_divisor      := ex1_divisor
    ex2_reg_orig_dividend     := ex1_orig_dividend
    ex2_reg_inst3_use_reg     := ex1_reg_inst3_use_reg && ex1_en
    ex2_reg_fw_en             := ex1_fw_en_next
    if (enable_pipeline_probe) {
      ex2_reg_inst_id         := ex1_reg_inst_id
    }
  }.otherwise {
    ex2_reg_div_stall := ex2_div_stall_next ||
      (ex2_reg_divrem && (ex2_reg_divrem_state === DivremState.Idle || ex2_reg_divrem_state === DivremState.Finished))
  }
  ex2_div_stall := ex2_reg_div_stall
  when (mem2_stall && !ex2_reg_div_stall) {
    // ALU/BIT/MD/CSR/JBRのEX2ステージを実行中にメモリストールがあってもWBに進むので、2回実行しないようにEX2を空にする
    ex2_reg_rf_wen        := REN_X
    ex2_reg_divrem        := false.B
    ex2_reg_is_valid_inst := false.B
    ex2_reg_inst3_use_reg := false.B
  }

  ex2_stall := mem_stall || ex2_div_stall

  //**********************************
  // EX2 MUL/DIV Stage

  val ex2_reg_dividend     = RegInit(0.S((WORD_LEN+5).W))
  val ex2_reg_divisor      = RegInit(0.U((WORD_LEN+4).W))
  val ex2_reg_p_divisor    = RegInit(0.U((WORD_LEN*2).W))
  val ex2_reg_divrem_count = RegInit(0.U(5.W))
  val ex2_reg_rem_shift    = RegInit(0.U(5.W))
  val ex2_reg_extra_shift  = RegInit(false.B)
  val ex2_reg_d            = RegInit(0.U(3.W))
  val ex2_reg_reminder     = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_quotient     = RegInit(0.U(WORD_LEN.W))

  def signExtend48(value: UInt, w: Int): SInt = {
      (Fill(WORD_LEN*3/2 - w, value(w - 1)) ## value(w - 1, 0)).asSInt
  }
  def zeroExtend48(value: UInt, w: Int) = {
      Fill(WORD_LEN*3/2 - w, 0.U) ## value(w - 1, 0)
  }

  val ex2_alu_muldiv_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex2_reg_exe_fun === ALU_MUL)    -> (ex2_reg_mullu(WORD_LEN-1, 0) + (ex2_reg_mulhuu(WORD_LEN/2-1, 0) << (WORD_LEN/2))),
    (ex2_reg_exe_fun === ALU_MULH)   -> (signExtend48(ex2_reg_mulls, WORD_LEN) + ex2_reg_mulhss)(WORD_LEN*3/2-1, WORD_LEN/2),
    (ex2_reg_exe_fun === ALU_MULHU)  -> (zeroExtend48(ex2_reg_mullu(WORD_LEN*3/2-1, WORD_LEN/2), WORD_LEN) + ex2_reg_mulhuu)(WORD_LEN*3/2-1, WORD_LEN/2),
    (ex2_reg_exe_fun === ALU_MULHSU) -> (signExtend48(ex2_reg_mulls, WORD_LEN) + ex2_reg_mulhsu)(WORD_LEN*3/2-1, WORD_LEN/2),
    (ex2_reg_exe_fun === ALU_DIV)    -> ex2_reg_quotient,
    (ex2_reg_exe_fun === ALU_DIVU)   -> ex2_reg_quotient,
    (ex2_reg_exe_fun === ALU_REM)    -> ex2_reg_reminder,
    (ex2_reg_exe_fun === ALU_REMU)   -> ex2_reg_reminder,
  ))

  // ex2_quotient := ex2_reg_quotient
  // ex2_reminder := ex2_reg_reminder
  ex2_div_stall_next := false.B

  switch (ex2_reg_divrem_state) {
    is (DivremState.Idle) {
      when (ex2_reg_divrem) {
        when (ex2_reg_init_divisor(WORD_LEN-1, 2) === 0.U) {
          ex2_reg_divrem_state := DivremState.Dividing
        }.otherwise {
          ex2_reg_divrem_state := DivremState.Placing
        }
        //ex2_div_stall        := true.B
      }
      ex2_reg_dividend     := ex2_reg_init_dividend.asSInt
      ex2_reg_divisor      := Cat(ex2_reg_init_divisor(3, 0), 0.U(32.W))
      ex2_reg_p_divisor    := Cat(ex2_reg_init_divisor, 0.U(32.W))
      ex2_reg_divrem_count := 0.U
      ex2_reg_rem_shift    := 0.U
      ex2_reg_quotient     := 0.U
      when (ex2_reg_init_divisor(1) === 0.U) {
        ex2_reg_extra_shift := false.B
        ex2_reg_d           := 0.U(3.W)
      }.otherwise {
        ex2_reg_extra_shift := true.B
        ex2_reg_d           := Cat(ex2_reg_init_divisor(0), 0.U(2.W))
      }
    }
    is (DivremState.Placing) {
      when (ex2_reg_p_divisor(WORD_LEN*2-1, WORD_LEN+4) === 0.U) {
        ex2_reg_divrem_state := DivremState.Dividing
      }
      ex2_reg_p_divisor    := ex2_reg_p_divisor >> 2
      ex2_reg_divisor      := (ex2_reg_p_divisor >> 2)(WORD_LEN+3, 0)
      ex2_reg_divrem_count := ex2_reg_divrem_count + 1.U
      when (ex2_reg_p_divisor(WORD_LEN+3) === 0.U) {
        ex2_reg_extra_shift := false.B
        ex2_reg_d           := ex2_reg_p_divisor(WORD_LEN+1, WORD_LEN-1)
      }.otherwise {
        ex2_reg_extra_shift := true.B
        ex2_reg_d           := ex2_reg_p_divisor(WORD_LEN+2, WORD_LEN)
      }
      ex2_div_stall_next    := true.B
    }
    is (DivremState.Dividing) {
      val p = Mux(ex2_reg_extra_shift,
        Mux(ex2_reg_dividend(WORD_LEN+4) === 0.U,
          ex2_reg_dividend(WORD_LEN+3, WORD_LEN-1),
          ~ex2_reg_dividend(WORD_LEN+3, WORD_LEN-1),
        ),
        Mux(ex2_reg_dividend(WORD_LEN+4) === 0.U,
          ex2_reg_dividend(WORD_LEN+2, WORD_LEN-2),
          ~ex2_reg_dividend(WORD_LEN+2, WORD_LEN-2),
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
      val ex2_q = MuxLookup(ex2_reg_d, 0.U(2.W))(
        div_table.zipWithIndex.map{
          case (v, i) => i.U -> MuxLookup(p, 0.U(2.W))(v.zipWithIndex.map { case (x, i) => i.U -> x.U })
        }
      )

      when (ex2_reg_dividend(WORD_LEN+4) === 0.U) {
        ex2_reg_dividend := MuxCase(ex2_reg_dividend << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_dividend - Cat(0.U(1.W), ex2_reg_divisor).asSInt) << 2),
          (ex2_q(1) === 1.U) -> ((ex2_reg_dividend - Cat(ex2_reg_divisor, 0.U(1.W)).asSInt) << 2),
        ))
        ex2_reg_quotient := MuxCase(ex2_reg_quotient << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_quotient << 2) + 1.U),
          (ex2_q(1) === 1.U) -> ((ex2_reg_quotient << 2) + 2.U),
        ))
      }.otherwise {
        ex2_reg_dividend := MuxCase(ex2_reg_dividend << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_dividend + Cat(0.U(1.W), ex2_reg_divisor).asSInt) << 2),
          (ex2_q(1) === 1.U) -> ((ex2_reg_dividend + Cat(ex2_reg_divisor, 0.U(1.W)).asSInt) << 2),
        ))
        ex2_reg_quotient := MuxCase(ex2_reg_quotient << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_quotient << 2) - 1.U),
          (ex2_q(1) === 1.U) -> ((ex2_reg_quotient << 2) - 2.U),
        ))
      }
      ex2_reg_rem_shift := ex2_reg_rem_shift + 1.U
      ex2_reg_divrem_count := ex2_reg_divrem_count + 1.U
      when (ex2_reg_divrem_count === 16.U) {
        ex2_reg_divrem_state := DivremState.Shifting
      }
      ex2_div_stall_next := true.B
    }
    is (DivremState.Shifting) {
      ex2_reg_reminder := (ex2_reg_dividend >> Cat(ex2_reg_rem_shift, 0.U(1.W)))(WORD_LEN-1, 0)
      ex2_reg_divrem_state := DivremState.Correction
      ex2_div_stall_next := true.B
    }
    is (DivremState.Correction) {
      val reminder = Mux(ex2_reg_dividend(WORD_LEN+4) === 1.U,
        ex2_reg_reminder + ex2_reg_init_divisor(WORD_LEN-1, 0),
        ex2_reg_reminder,
      )
      ex2_reg_reminder := Mux(ex2_reg_zero_op2,
        ex2_reg_orig_dividend,
        Mux(ex2_reg_sign_op1 === 0.U,
          reminder,
          ~reminder + 1.U,
        ),
      )
      val quotient = Mux(ex2_reg_dividend(WORD_LEN+4) === 1.U,
        ex2_reg_quotient - 1.U,
        ex2_reg_quotient,
      )
      ex2_reg_quotient := Mux(ex2_reg_zero_op2,
        0xFFFF_FFFFL.U,
        Mux(ex2_reg_sign_op12 === 0.U,
          quotient,
          ~quotient + 1.U,
        ),
      )
      ex2_reg_divrem_state := DivremState.Finished
      //ex2_div_stall := true.B
    }
    is (DivremState.Finished) {
      ex2_reg_divrem_state := DivremState.Idle
    }
  }
  // printf(p"ex2_reg_divrem_state : 0x${Hexadecimal(ex2_reg_divrem_state.asUInt)}\n")
  // printf(p"ex2_reg_dividend     : 0x${Hexadecimal(ex2_reg_dividend)}\n")
  // printf(p"ex2_reg_divisor      : 0x${Hexadecimal(ex2_reg_divisor)}\n")
  // printf(p"ex2_reg_divrem_count : 0x${Hexadecimal(ex2_reg_divrem_count)}\n")
  // printf(p"ex2_reg_rem_shift    : 0x${Hexadecimal(ex2_reg_rem_shift)}\n")

  //**********************************
  // EX2 Stage
  val ex2_mask_out = Cat((0 until WORD_LEN).reverse.map(bit => Mux(ex2_reg_pc_bit_out(bit), ex2_reg_alu_out(bit), ex2_reg_op3_data(bit))))

  ex2_wb_data := MuxCase(ex2_reg_alu_out, Seq(
    (ex2_reg_fun_sel === EX2_MASK) -> ex2_mask_out,
    (ex2_reg_fun_sel === EX2_BIT)  -> ex2_reg_pc_bit_out,
    (ex2_reg_fun_sel === EX2_CSR || ex2_reg_fun_sel === EX2_CSR1) -> csr_rdata,
    (ex2_reg_fun_sel === EX2_MD || ex2_reg_fun_sel === EX2_MD1)   -> ex2_alu_muldiv_out,
  ))

  ex2_fw_data := MuxCase(ex2_reg_alu_out, Seq(
    (ex2_reg_fun_sel === EX2_MASK || ex2_reg_fun_sel === EX2_CSR) -> ex2_mask_out,
    (ex2_reg_fun_sel === EX2_BIT || ex2_reg_fun_sel === EX2_CSR1) -> ex2_reg_pc_bit_out,
  ))
  when (ex2_reg_inst3_use_reg && !ex2_div_stall) {
    scoreboard(ex2_reg_wb_addr) := false.B
  }

  ex2_reg_is_retired := ex2_reg_is_valid_inst && !ex2_div_stall && ex2_reg_no_mem

  when (!ex2_reg_div_stall && ex2_reg_rf_wen === REN_S && ex2_reg_no_mem) {
    regfile(ex2_reg_wb_addr) := ex2_wb_data
  }

  if (enable_pipeline_probe) {
    io.pipeline_probe.ex2_valid   := ex2_reg_no_mem
    io.pipeline_probe.ex2_inst_id := ex2_reg_inst_id
    io.pipeline_probe.ex2_retired := !ex2_reg_div_stall && ex2_reg_no_mem
  }

  //**********************************
  // EX1/MEM1 register
  val dram_addr_bits: Int = log2Ceil(dram_length)

  when (!ex2_stall) {
    mem1_reg_mem_wstrb     := (MuxCase("b1111".U, Seq(
      (ex1_reg_mem_w === MW_B || ex1_reg_mem_w === MW_BU) -> "b0001".U,
      (ex1_reg_mem_w === MW_H || ex1_reg_mem_w === MW_HU) -> "b0011".U,
      //(ex1_reg_mem_w === MW_W) -> "b1111".U,
    )) << (ex1_add_out(1, 0)))(6, 0)
    mem1_reg_unaligned     := MuxCase(ex1_add_out(1, 0) =/= "b00".U, Seq(
      (ex1_reg_mem_w === MW_B || ex1_reg_mem_w === MW_BU) -> false.B,
      (ex1_reg_mem_w === MW_H || ex1_reg_mem_w === MW_HU) -> (ex1_add_out(1, 0) === "b11".U),
    )) && (ex1_reg_wb_sel === WB_LD || ex1_reg_wb_sel === WB_ST) && ex1_en
    mem1_reg_wdata         := (Cat(ex1_reg_op3_data, ex1_reg_op3_data(31, 8)) << (8.U * ex1_add_out(1, 0)))(WORD_LEN+23, WORD_LEN-8)
    mem1_reg_mem_w         := ex1_reg_mem_w
    mem1_reg_mem_use_reg   := ex1_reg_mem_use_reg && ex1_en
    val mem1_is_dram       = ex1_add_out(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
    mem1_reg_is_dram       := mem1_is_dram
    mem1_reg_is_mem_load   := !mem1_is_dram && (ex1_reg_wb_sel === WB_LD) && ex1_en
    mem1_reg_is_mem_store  := !mem1_is_dram && (ex1_reg_wb_sel === WB_ST) && ex1_en
    mem1_reg_is_dram_load  := mem1_is_dram && (ex1_reg_wb_sel === WB_LD) && ex1_en
    mem1_reg_is_dram_store := mem1_is_dram && (ex1_reg_wb_sel === WB_ST) && ex1_en
    mem1_reg_is_dram_fence := (ex1_reg_wb_sel === WB_FENCE) && ex1_en
    mem1_reg_is_valid_inst := (ex1_reg_wb_sel === WB_LD || ex1_reg_wb_sel === WB_ST || ex1_reg_wb_sel === WB_FENCE) && ex1_en
    if (enable_pipeline_probe) {
      mem1_reg_inst_id     := ex1_reg_inst_id
    }
  }

  //**********************************
  // Memory Access Stage 1 (MEM1)

  when (!mem1_mem_stall && !mem1_dram_stall && mem1_reg_unaligned) {
    mem1_reg_unaligned       := false.B
  }

  val mem_addr  = Mux(mem1_reg_unaligned, ex2_reg_alu_out + 4.U, ex2_reg_alu_out)
  val mem_wstrb = Mux(mem1_reg_unaligned, Cat(0.U(1.W), mem1_reg_mem_wstrb(6, 4)), mem1_reg_mem_wstrb(3, 0))
  io.dmem.raddr := mem_addr
  io.dmem.waddr := mem_addr
  io.dmem.ren   := mem1_reg_is_mem_load
  io.dmem.wen   := mem1_reg_is_mem_store
  io.dmem.wstrb := mem_wstrb
  io.dmem.wdata := mem1_reg_wdata
  io.cache.raddr := mem_addr
  io.cache.waddr := mem_addr
  io.cache.ren   := mem1_reg_is_dram_load
  io.cache.wen   := mem1_reg_is_dram_store
  io.cache.wstrb := mem_wstrb
  io.cache.wdata := mem1_reg_wdata
  io.cache.iinvalidate := mem1_reg_is_dram_fence

  mem1_mem_stall := (mem1_reg_is_mem_load && !io.dmem.rready) || (mem1_reg_is_mem_store && !io.dmem.wready)
  mem1_dram_stall :=
    (mem1_reg_is_dram_load && !io.cache.rready) ||
    (mem1_reg_is_dram_store && !io.cache.wready) ||
    (mem1_reg_is_dram_fence && io.cache.ibusy)

  mem_stall := mem1_mem_stall || mem1_dram_stall || mem1_reg_unaligned || mem2_stall

  if (enable_pipeline_probe) {
    io.pipeline_probe.mem1_valid   := mem1_reg_is_valid_inst
    io.pipeline_probe.mem1_inst_id := mem1_reg_inst_id
  }

  //**********************************
  // MEM1/MEM2 regsiter
  when (!mem2_stall) {
    mem2_reg_wb_byte_offset := ex2_reg_alu_out(1, 0)
    mem2_reg_mem_w          := mem1_reg_mem_w
    // mem2_reg_dmem_rdata     := io.dmem.rdata
    mem2_reg_wb_addr        := ex2_reg_wb_addr
    mem2_reg_is_valid_load  := (!mem1_mem_stall && mem1_reg_is_mem_load) || (!mem1_dram_stall && mem1_reg_is_dram_load)
    mem2_reg_mem_use_reg    := !mem1_mem_stall && !mem1_dram_stall && mem1_reg_mem_use_reg
    mem2_reg_is_valid_inst  := !mem1_mem_stall && !mem1_dram_stall && mem1_reg_is_valid_inst
    mem2_reg_is_mem_load    := !mem1_mem_stall && mem1_reg_is_mem_load
    mem2_reg_is_dram_load   := !mem1_dram_stall && mem1_reg_is_dram_load
    mem2_reg_unaligned      := mem1_reg_unaligned
    if (enable_pipeline_probe) {
      mem2_reg_inst_id     := mem1_reg_inst_id
    }
  }

  //**********************************
  // Memory Access Stage 2 (MEM2)
  val mem2_mem_stall = (mem2_reg_is_mem_load && !io.dmem.rvalid)
  val mem2_dram_stall = (mem2_reg_is_dram_load && !io.cache.rvalid)
  mem2_stall := mem2_mem_stall || mem2_dram_stall

  if (enable_pipeline_probe) {
    io.pipeline_probe.mem2_valid   := !mem2_reg_unaligned && mem2_reg_is_valid_inst
    io.pipeline_probe.mem2_inst_id := mem2_reg_inst_id
  }

  val mem2_is_valid_load = !mem2_stall && !mem2_reg_unaligned && mem2_reg_is_valid_load
  val mem2_is_aligned_lw = !mem2_stall && mem2_reg_is_valid_load && mem2_reg_wb_byte_offset === "b00".U &&
    mem2_reg_mem_w =/= MW_B && mem2_reg_mem_w =/= MW_BU &&
    mem2_reg_mem_w =/= MW_H && mem2_reg_mem_w =/= MW_HU
  val mem2_fw_en_next = mem2_is_aligned_lw
  when (mem2_is_aligned_lw) {
    scoreboard(mem2_reg_wb_addr) := false.B
  }

  //**********************************
  // MEM2/MEM3 regsiter
  mem3_reg_wb_byte_offset := mem2_reg_wb_byte_offset
  mem3_reg_mem_w          := mem2_reg_mem_w
  mem3_reg_dmem_rdata     := Mux(mem2_reg_is_dram_load, io.cache.rdata, io.dmem.rdata)
  mem3_reg_wb_addr        := mem2_reg_wb_addr
  mem3_reg_is_valid_load  := !mem2_stall && !mem2_reg_unaligned && mem2_is_valid_load
  // mem3_reg_mem_use_reg    := !mem2_dram_stall && mem2_reg_mem_use_reg
  mem3_reg_is_valid_inst  := !mem2_stall && !mem2_reg_unaligned && mem2_reg_is_valid_inst
  mem3_reg_fw_en          := mem2_fw_en_next
  mem3_reg_unaligned      := mem2_reg_unaligned
  mem3_reg_is_aligned_lw  := mem2_is_aligned_lw
  if (enable_pipeline_probe) {
    when (!mem2_stall) {
      mem3_reg_inst_id    := mem2_reg_inst_id
    }
  }

  //**********************************
  // Memory Access Stage 3 (MEM3)
  def signExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, value(w - 1)) ## value(w - 1, 0)
  }
  def zeroExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, 0.U) ## value(w - 1, 0)
  }

  when (mem3_reg_unaligned) {
    mem3_reg_rdata_high := mem3_reg_dmem_rdata(23, 0)
  }
  val mem3_wb_rdata = (Cat(mem3_reg_rdata_high, mem3_reg_dmem_rdata) >> (8.U * mem3_reg_wb_byte_offset))(WORD_LEN-1, 0)
  val mem3_wb_data_load = MuxCase(mem3_wb_rdata, Seq(
    (mem3_reg_mem_w === MW_B)  -> signExtend(mem3_wb_rdata, 8),
    (mem3_reg_mem_w === MW_H)  -> signExtend(mem3_wb_rdata, 16),
    (mem3_reg_mem_w === MW_BU) -> zeroExtend(mem3_wb_rdata, 8),
    (mem3_reg_mem_w === MW_HU) -> zeroExtend(mem3_wb_rdata, 16),
  ))
  mem3_fw_data := mem3_reg_dmem_rdata
  when (mem3_reg_is_valid_load) {
    regfile(mem3_reg_wb_addr) := mem3_wb_data_load
  }
  when (mem3_reg_is_valid_load && !mem3_reg_is_aligned_lw) {
    scoreboard(mem3_reg_wb_addr) := false.B
  }
  mem3_reg_is_retired := mem3_reg_is_valid_inst

  when (ex2_reg_is_retired && mem3_reg_is_retired) {
    instret := instret + 2.U
  }.elsewhen (ex2_reg_is_retired || mem3_reg_is_retired) {
    instret := instret + 1.U
  }

  if (enable_pipeline_probe) {
    io.pipeline_probe.mem3_valid   := mem3_reg_is_valid_inst
    io.pipeline_probe.mem3_inst_id := mem3_reg_inst_id
    io.pipeline_probe.mem3_retired := mem3_reg_is_valid_inst
  }

  // Debug signals
  io.debug_signal.cycle_counter       := cycle_counter.io.value(47, 0)
  // io.debug_signal.csr_rdata        := csr_rdata
  // io.debug_signal.ex1_reg_csr_addr := ex1_reg_csr_addr
  io.debug_signal.ex2_reg_pc          := Cat(ex2_reg_pc, 0.U((WORD_LEN-PC_LEN).W))
  io.debug_signal.ex2_is_valid_inst   := ex2_reg_is_valid_inst
  io.debug_signal.me_intr             := csr_is_meintr
  io.debug_signal.mt_intr             := csr_is_mtintr
  io.debug_signal.trap                := csr_is_trap
  io.debug_signal.id_pc               := Cat(id_reg_pc, 0.U((WORD_LEN-PC_LEN).W))
  io.debug_signal.id_inst             := id_inst
  io.debug_signal.mem3_rdata          := mem3_reg_dmem_rdata
  io.debug_signal.mem3_rvalid         := mem3_reg_is_valid_load
  io.debug_signal.rwaddr              := ex2_wb_data
  io.debug_signal.ex2_reg_is_br       := ex2_reg_is_br
  io.debug_signal.id_reg_is_bp_fail   := id_reg_is_bp_fail
  io.debug_signal.id_reg_bp_taken     := id_reg_bp_taken
  io.debug_signal.ic_state            := ic_state.asUInt

  //**********************************
  // IO & Debug
  if (enable_sim_probe) {
    io.sim_probe.gp   := regfile(3)
    val exit = ex1_reg_is_trap && (ex1_reg_mcause === CSR_MCAUSE_ECALL_M) && (regfile(17) === 93.U(WORD_LEN.W))
    val do_exit = RegNext(exit)
    io.sim_probe.exit := RegNext(do_exit).asUInt
  }

  //printf(p"if1_reg_pc       : 0x${Hexadecimal(if1_reg_pc)}\n")
  printf(p"if2_pc           : 0x${Hexadecimal(Cat(if2_pc, 0.U(1.W)))}\n")
  printf(p"if2_is_valid_inst: 0x${Hexadecimal(if2_is_valid_inst)}\n")
  printf(p"if2_inst         : 0x${Hexadecimal(if2_inst)}\n")
  printf(p"ic_bp_taken      : 0x${Hexadecimal(ic_bp_taken)}\n")
  printf(p"ic_bp_taken_pc   : 0x${Hexadecimal(Cat(ic_bp_taken_pc, 0.U(1.W)))}\n")
  printf(p"ic_bp_cnt        : 0x${Hexadecimal(ic_bp_cnt)}\n")
  printf(p"id_reg_pc        : 0x${Hexadecimal(Cat(id_reg_pc, 0.U(1.W)))}\n")
  printf(p"id_reg_inst      : 0x${Hexadecimal(id_reg_inst)}\n")
  printf(p"id_stall         : 0x${Hexadecimal(id_stall)}\n")
  printf(p"id_inst          : 0x${Hexadecimal(id_inst)}\n")
  // printf(p"id_rs1_data      : 0x${Hexadecimal(id_rs1_data)}\n")
  // printf(p"id_rs2_data      : 0x${Hexadecimal(id_rs2_data)}\n")
  // printf(p"id_wb_addr       : 0x${Hexadecimal(id_wb_addr)}\n")
  printf(p"id_reg_bp_taken  : 0x${Hexadecimal(id_reg_bp_taken)}\n")
  printf(p"id_reg_is_bp_fail: 0x${Hexadecimal(id_reg_is_bp_fail)}\n")
  printf(p"rrd_reg_pc       : 0x${Hexadecimal(Cat(rrd_reg_pc, 0.U(1.W)))}\n")
  printf(p"rrd_reg_is_valid_: 0x${Hexadecimal(rrd_reg_is_valid_inst)}\n")
  printf(p"rrd_stall        : 0x${Hexadecimal(rrd_stall)}\n")
  // printf(p"rrd_reg_rs1_addr : 0x${Hexadecimal(rrd_reg_rs1_addr)}\n")
  // printf(p"rrd_reg_rs2_addr : 0x${Hexadecimal(rrd_reg_rs2_addr)}\n")
  printf(p"rrd_op1_data     : 0x${Hexadecimal(rrd_op1_data)}\n")
  printf(p"rrd_op2_data     : 0x${Hexadecimal(rrd_op2_data)}\n")
  printf(p"rrd_op3_data     : 0x${Hexadecimal(rrd_op3_data)}\n")
  printf(p"rrd_reg_op1_sel  : 0x${Hexadecimal(rrd_reg_op1_sel)}\n")
  // printf(p"ex1_reg_fw_en    : 0x${Hexadecimal(ex1_reg_fw_en)}\n")
  printf(p"rrd_reg_rs1_addr : 0x${Hexadecimal(rrd_reg_rs1_addr)}\n")
  printf(p"rrd_reg_wb_addr : 0x${Hexadecimal(rrd_reg_wb_addr)}\n")
  printf(p"rrd_reg_rf_wen : 0x${Hexadecimal(rrd_reg_rf_wen)}\n")
  printf(p"rrd_reg_wb_sel : 0x${Hexadecimal(rrd_reg_wb_sel)}\n")
  printf(p"scoreboard      : 0x${Hexadecimal(Cat((0 until 32).map(i => scoreboard(i).asUInt)))}\n")
  printf(p"ex1_fw_data      : 0x${Hexadecimal(ex1_fw_data)}\n")
  printf(p"ex1_reg_pc       : 0x${Hexadecimal(Cat(ex1_reg_pc, 0.U(1.W)))}\n")
  printf(p"ex1_reg_is_valid_: 0x${Hexadecimal(ex1_reg_is_valid_inst)}\n")
  printf(p"ex1_reg_op1_data : 0x${Hexadecimal(ex1_reg_op1_data)}\n")
  printf(p"ex1_reg_op2_data : 0x${Hexadecimal(ex1_reg_op2_data)}\n")
  printf(p"ex1_reg_op3_data : 0x${Hexadecimal(ex1_reg_op3_data)}\n")
  printf(p"ex1_alu_out      : 0x${Hexadecimal(ex1_alu_out)}\n")
  printf(p"ex1_pc_bit_out   : 0x${Hexadecimal(ex1_pc_bit_out)}\n")
  printf(p"ex1_reg_exe_fun  : 0x${Hexadecimal(ex1_reg_exe_fun)}\n")
  printf(p"ex1_reg_wb_sel   : 0x${Hexadecimal(ex1_reg_wb_sel)}\n")
  printf(p"ex1_reg_wb_addr  : 0x${Hexadecimal(ex1_reg_wb_addr)}\n")
  printf(p"ex1_reg_bp_taken : 0x${Hexadecimal(ex1_reg_bp_taken)}\n")
  printf(p"ex1_reg_bp_taken_: 0x${Hexadecimal(Cat(ex1_reg_bp_taken_pc, 0.U(1.W)))}\n")
  printf(p"ex1_is_br        : 0x${ex1_is_br}\n")
  printf(p"ex1_reg_bp_cnt   : 0x${ex1_reg_bp_cnt}\n")
  printf(p"ex2_reg_is_br    : 0x${ex2_reg_is_br}\n")
  printf(p"ex2_reg_br_pc  : 0x${Hexadecimal(Cat(ex2_reg_br_pc, 0.U(1.W)))}\n")
  printf(p"ex2_reg_pc       : 0x${Hexadecimal(Cat(ex2_reg_pc, 0.U(1.W)))}\n")
  printf(p"ex2_reg_is_valid_: 0x${Hexadecimal(ex2_reg_is_valid_inst)}\n")
  printf(p"ex2_stall        : 0x${Hexadecimal(ex2_stall)}\n")
  printf(p"ex2_wb_data      : 0x${Hexadecimal(ex2_wb_data)}\n")
  printf(p"ex2_alu_muldiv_ou: 0x${Hexadecimal(ex2_alu_muldiv_out)}\n")
  printf(p"ex2_reg_wb_addr  : 0x${Hexadecimal(ex2_reg_wb_addr)}\n")
  // printf(p"mem1_reg_mem_w    : 0x${Hexadecimal(mem1_reg_mem_w)}\n")
  printf(p"mem1_reg_wdata    : 0x${Hexadecimal(mem1_reg_wdata)}\n")
  printf(p"mem1_mem_stall   : 0x${Hexadecimal(mem1_mem_stall)}\n")
  printf(p"mem1_dram_stall  : 0x${Hexadecimal(mem1_dram_stall)}\n")
  printf(p"mem1_reg_unaligne: 0x${Hexadecimal(mem1_reg_unaligned)}\n")
  printf(p"mem1_is_valid_ins: 0x${Hexadecimal(mem1_reg_is_valid_inst)}\n")
  printf(p"mem2_mem_stall   : 0x${Hexadecimal(mem2_mem_stall)}\n")
  printf(p"mem2_dram_stall  : 0x${Hexadecimal(mem2_dram_stall)}\n")
  // printf(p"mem2_reg_dmem_rda: 0x${Hexadecimal(mem2_reg_dmem_rdata)}\n")
  // printf(p"mem2_reg_mem_use_: 0x${Hexadecimal(mem2_reg_mem_use_reg)}\n")
  printf(p"mem2_reg_is_valid: 0x${Hexadecimal(mem2_reg_is_valid_inst)}\n")
  printf(p"mem2_reg_is_mem_l: 0x${Hexadecimal(mem2_reg_is_mem_load)}\n")
  printf(p"mem2_reg_is_dram_: 0x${Hexadecimal(mem2_reg_is_dram_load)}\n")
  printf(p"mem2_reg_unaligne: 0x${Hexadecimal(mem2_reg_unaligned)}\n")
  printf(p"mem2_is_aligned_l: 0x${Hexadecimal(mem2_is_aligned_lw)}\n")
  printf(p"mem2_reg_wb_addr : 0x${Hexadecimal(mem2_reg_wb_addr)}\n")
  printf(p"mem3_reg_dmem_rda: 0x${Hexadecimal(mem3_reg_dmem_rdata)}\n")
  printf(p"mem3_wb_data_load: 0x${Hexadecimal(mem3_wb_data_load)}\n")
  printf(p"mem3_reg_unaligne: 0x${Hexadecimal(mem3_reg_unaligned)}\n")
  printf(p"mem3_reg_is_align: 0x${Hexadecimal(mem3_reg_is_aligned_lw)}\n")
  printf(p"mem3_reg_is_valid: 0x${Hexadecimal(mem3_reg_is_valid_inst)}\n")
  printf(p"mem3_reg_wb_addr : 0x${Hexadecimal(mem3_reg_wb_addr)}\n")
  // printf(p"mem3_reg_mem_use_: 0x${Hexadecimal(mem3_reg_mem_use_reg)}\n")
  printf(p"csr_is_meintr    : ${csr_is_meintr}\n")
  printf(p"csr_is_mtintr    : ${csr_is_mtintr}\n")
  printf(p"csr_is_trap      : ${csr_is_trap}\n")
  // printf(p"csr_reg_mepc         : 0x${Hexadecimal(csr_reg_mepc)}\n")
  printf(p"csr_is_br        : ${csr_is_br}\n")
  // printf(p"csr_wdata        : 0x${Hexadecimal(csr_wdata)}\n")
  // printf(p"ex1_reg_csr_cmd  : 0x${Hexadecimal(ex1_reg_csr_cmd)}\n")
  printf(p"instret          : ${instret}\n")
  // printf(p"mem1_reg_is_dram_fence: ${mem1_reg_is_dram_fence}\n")
  // printf(p"io.cache.ibusy   : ${io.cache.ibusy}\n")
  printf(p"cycle_counter    : ${io.debug_signal.cycle_counter}\n")
  printf("---------\n")
}
