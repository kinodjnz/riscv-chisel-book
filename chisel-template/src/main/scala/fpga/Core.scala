package fpga

import chisel3._
import chisel3.util._
import common.Instructions._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.ChiselEnum

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
  val ex2_reg_pc = Output(UInt(WORD_LEN.W))
  val ex2_is_valid_inst = Output(Bool())
  // val csr_rdata = Output(UInt(WORD_LEN.W))
  // val ex2_reg_csr_addr = Output(UInt(CSR_ADDR_LEN.W))
  val me_intr = Output(Bool())
  val mt_intr = Output(Bool())
  val cycle_counter = Output(UInt(48.W))
  val id_pc = Output(UInt(WORD_LEN.W))
  val id_inst = Output(UInt(WORD_LEN.W))
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

class Core(startAddress: BigInt = 0, caribCount: BigInt = 10, bpTagInitPath: String = null, dram_start: BigInt = 0x2000_0000L, dram_length: BigInt = 0x1000_0000L) extends Module {
  val io = IO(
    new Bundle {
      val imem = Flipped(new ImemPortIo())
      val dmem = Flipped(new DmemPortIo())
      val cache = Flipped(new CachePort())
      val mtimer_mem = new DmemPortIo()
      val intr = Input(Bool())
      val gp   = Output(UInt(WORD_LEN.W))
      val exit = Output(Bool())
      val debug_signal = new CoreDebugSignals()
    }
  )

  val regfile = Mem(32, UInt(WORD_LEN.W))
  //val csr_regfile = Mem(4096, UInt(WORD_LEN.W)) 
  val cycle_counter = Module(new LongCounter(8, 8)) // 64-bit cycle counter for CYCLE[H] CSR
  val mtimer = Module(new MachineTimer)

  val instret = RegInit(0.U(64.W))
  val csr_reg_trap_vector  = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mcause       = RegInit(0.U(WORD_LEN.W))
  // val csr_mtval         = RegInit(0.U(WORD_LEN.W))
  val csr_reg_mepc         = RegInit(0.U(WORD_LEN.W))
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
  val id_reg_pc             = RegInit(0.U(WORD_LEN.W))
  val id_reg_pc_cache       = RegInit(0.U(WORD_LEN.W))
  val id_reg_inst           = RegInit(0.U(WORD_LEN.W))
  val id_reg_stall          = RegInit(false.B)
  val id_reg_is_bp_pos      = RegInit(false.B)
  val id_reg_bp_addr        = RegInit(0.U(WORD_LEN.W))
  val id_reg_inst_cnt       = RegInit(0.U(INST_CNT_LEN.W))
  val id_reg_is_trap        = RegInit(false.B)
  val id_reg_mcause         = RegInit(0.U(WORD_LEN.W))
  // val id_reg_mtval          = RegInit(0.U(WORD_LEN.W))
  val id_reg_is_br          = RegInit(false.B)

  // ID/RRD State
  val rrd_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_inst_cnt      = RegInit(0.U(INST_CNT_LEN.W))
  val rrd_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_op1_sel       = RegInit(0.U(OP1_LEN.W))
  val rrd_reg_op2_sel       = RegInit(0.U(OP2_LEN.W))
  val rrd_reg_rs1_addr      = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_rs2_addr      = RegInit(0.U(ADDR_LEN.W))
  val rrd_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_op2_data      = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val rrd_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val rrd_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val rrd_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val rrd_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val rrd_reg_imm_b_sext    = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val rrd_reg_is_direct_j    = RegInit(false.B)
  val rrd_reg_is_br          = RegInit(false.B)
  val rrd_reg_is_j           = RegInit(false.B)
  val rrd_reg_is_bp_pos      = RegInit(false.B)
  val rrd_reg_bp_addr        = RegInit(0.U(WORD_LEN.W))
  val rrd_reg_is_half        = RegInit(false.B)
  val rrd_reg_is_valid_inst  = RegInit(false.B)
  val rrd_reg_is_trap        = RegInit(false.B)
  val rrd_reg_mcause         = RegInit(0.U(WORD_LEN.W))
  // val rrd_reg_mtval          = RegInit(0.U(WORD_LEN.W))

  // RRD/EX1 State
  val ex1_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_inst_cnt      = RegInit(0.U(INST_CNT_LEN.W))
  val ex1_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex1_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_rs2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex1_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex1_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val ex1_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex1_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val ex1_reg_br_target     = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val ex1_reg_is_j          = RegInit(false.B)
  val ex1_reg_is_bp_pos     = RegInit(false.B)
  val ex1_reg_bp_addr       = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_is_half       = RegInit(false.B)
  val ex1_reg_is_valid_inst = RegInit(false.B)
  val ex1_reg_is_trap       = RegInit(false.B)
  val ex1_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  // val ex1_reg_mtval         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_mem_use_reg   = RegInit(false.B)
  val ex1_reg_inst2_use_reg = RegInit(false.B)
  val ex1_reg_inst3_use_reg = RegInit(false.B)
  // val ex1_reg_is_direct_jbr_fail = RegInit(false.B)
  val ex1_reg_is_br              = RegInit(false.B)
  val ex1_reg_is_indirect_j      = RegInit(false.B)
  // val ex1_reg_is_direct_j        = RegInit(false.B)
  val ex1_reg_direct_jbr_target  = RegInit(0.U(WORD_LEN.W))
  // val ex1_reg_direct_bp_match  = RegInit(false.B)

  // EX1/JBR State
  val jbr_reg_bp_en            = RegInit(false.B)
  val jbr_reg_is_cond_br       = RegInit(false.B)
  val jbr_reg_is_cond_br_inst  = RegInit(false.B)
  val jbr_reg_is_uncond_br     = RegInit(false.B)
  val jbr_reg_cond_br_target   = RegInit(0.U(WORD_LEN.W))
  val jbr_reg_uncond_br_target = RegInit(0.U(WORD_LEN.W))
  val jbr_reg_is_bp_pos        = RegInit(false.B)
  val jbr_reg_bp_addr          = RegInit(0.U(WORD_LEN.W))
  val jbr_reg_is_half          = RegInit(false.B)

  // EX1/EX2 State
  // val ex2_reg_en            = RegInit(false.B)
  val ex2_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_inst_cnt      = RegInit(0.U(INST_CNT_LEN.W))
  val ex2_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex2_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_rs2_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_mullu         = RegInit(0.U((WORD_LEN*3/2).W))
  val ex2_reg_mulls         = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_mulhuu        = RegInit(0.U((WORD_LEN*3/2).W))
  val ex2_reg_mulhss        = RegInit(0.S((WORD_LEN*3/2).W))
  val ex2_reg_mulhsu        = RegInit(0.S((WORD_LEN*3/2).W))
  val ex2_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex2_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex2_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val ex2_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex2_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val ex2_reg_alu_out       = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_pc_bit_out    = RegInit(0.U(WORD_LEN.W))
  //val ex2_reg_alu_mulhsu_out  = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_wdata         = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_is_valid_inst = RegInit(false.B)
  val ex2_reg_is_trap       = RegInit(false.B)
  val ex2_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  // val ex2_reg_mtval         = RegInit(0.U(WORD_LEN.W))
  // val ex2_reminder              = Wire(UInt(WORD_LEN.W))
  // val ex2_quotient              = Wire(UInt(WORD_LEN.W))
  val ex2_reg_divrem            = RegInit(false.B)
  val ex2_reg_sign_op1          = RegInit(0.U(1.W))
  val ex2_reg_sign_op12         = RegInit(0.U(1.W))
  val ex2_reg_zero_op2          = RegInit(false.B)
  val ex2_reg_init_dividend     = RegInit(0.U((WORD_LEN+5).W))
  val ex2_reg_init_divisor      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_orig_dividend     = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_inst3_use_reg     = RegInit(false.B)

  // EX1/MEM1 State
  val mem1_reg_mem_wstrb     = RegInit(0.U((WORD_LEN/8).W))
  val mem1_reg_mem_w         = RegInit(0.U(MW_LEN.W))
  val mem1_reg_mem_use_reg   = RegInit(false.B)
  val mem1_reg_is_dram       = RegInit(false.B)
  val mem1_reg_is_mem_load   = RegInit(false.B)
  val mem1_reg_is_mem_store  = RegInit(false.B)
  val mem1_reg_is_dram_load  = RegInit(false.B)
  val mem1_reg_is_dram_store = RegInit(false.B)
  val mem1_reg_is_dram_fence = RegInit(false.B)
  val mem1_reg_is_valid_inst = RegInit(false.B)

  // MEM1/MEM2 State
  val mem2_reg_wb_byte_offset = RegInit(0.U(2.W))
  val mem2_reg_mem_w          = RegInit(0.U(MW_LEN.W))
  val mem2_reg_dmem_rdata     = RegInit(0.U(WORD_LEN.W))
  val mem2_reg_wb_addr        = RegInit(0.U(WORD_LEN.W))
  val mem2_reg_is_valid_load  = RegInit(false.B)
  val mem2_reg_mem_use_reg    = RegInit(false.B)
  val mem2_reg_is_valid_inst  = RegInit(false.B)
  val mem2_reg_is_dram_load   = RegInit(false.B)

  // MEM2/MEM3 State
  val mem3_reg_wb_byte_offset = RegInit(0.U(2.W))
  val mem3_reg_mem_w          = RegInit(0.U(MW_LEN.W))
  val mem3_reg_dmem_rdata     = RegInit(0.U(WORD_LEN.W))
  val mem3_reg_wb_addr        = RegInit(0.U(WORD_LEN.W))
  val mem3_reg_is_valid_load  = RegInit(false.B)
  val mem3_reg_is_valid_inst  = RegInit(false.B)
  val mem3_reg_mem_use_reg    = RegInit(false.B)

  val if2_reg_is_bp_pos  = RegInit(false.B)
  val if2_reg_bp_addr    = RegInit(0.U(WORD_LEN.W))
  val id_stall           = Wire(Bool())
  val rrd_stall          = Wire(Bool())
  val ex2_stall          = Wire(Bool())
  val mem_stall          = Wire(Bool())
  val mem1_mem_stall      = Wire(Bool())
  val mem1_dram_stall     = Wire(Bool())
  val mem2_dram_stall     = Wire(Bool())
  val mem1_mem_stall_delay = RegInit(false.B)
  val ex1_reg_fw_en      = RegInit(false.B)
  val ex1_fw_data        = Wire(UInt(WORD_LEN.W))
  val ex2_reg_fw_en      = RegInit(false.B)
  val ex2_fw_data        = Wire(UInt(WORD_LEN.W))
  val ex2_div_stall_next = Wire(Bool())
  val ex2_reg_div_stall  = RegInit(false.B)
  val ex2_reg_divrem_state = RegInit(DivremState.Idle)
  val ex2_reg_is_br      = RegInit(false.B)
  val ex2_reg_br_addr    = RegInit(0.U(WORD_LEN.W))
  val jbr_is_br          = Wire(Bool())
  val csr_is_br          = Wire(Bool())
  val csr_br_addr        = Wire(UInt(WORD_LEN.W))
  val mem1_reg_dmem_state = RegInit(DmemState.Idle)
  val ex2_reg_is_retired = RegInit(false.B)
  val mem3_reg_is_retired = RegInit(false.B)
  val ex2_is_valid_inst  = Wire(Bool())
  val ex2_en             = Wire(Bool())

  //**********************************
  // Instruction Cache Controller

  val ic_addr_en      = Wire(Bool())
  val ic_addr         = Wire(UInt(WORD_LEN.W))
  val ic_read_en2     = Wire(Bool())
  val ic_read_en4     = Wire(Bool())
  val ic_reg_read_rdy = RegInit(false.B)
  val ic_reg_half_rdy = RegInit(false.B)
  val ic_read_rdy     = Wire(Bool())
  val ic_half_rdy     = Wire(Bool())
  val ic_data_out     = Wire(UInt(WORD_LEN.W))
  val ic_reg_imem_addr = RegInit(0.U(WORD_LEN.W))
  val ic_reg_addr_out = RegInit(0.U(WORD_LEN.W))
  val ic_addr_out     = Wire(UInt(WORD_LEN.W))

  val ic_reg_inst       = RegInit(0.U(WORD_LEN.W))
  val ic_reg_inst_addr  = RegInit(0.U(WORD_LEN.W))
  val ic_reg_inst2      = RegInit(0.U(WORD_LEN.W))
  val ic_reg_inst2_addr = RegInit(0.U(WORD_LEN.W))

  val ic_state = RegInit(IcState.Empty)

  val ic_imem_addr_2 = Cat(ic_reg_imem_addr(WORD_LEN-1, 2), 1.U(1.W), 0.U(1.W))
  val ic_imem_addr_4 = ic_reg_imem_addr + 4.U(WORD_LEN.W)
  val ic_inst_addr_2 = Cat(ic_reg_inst_addr(WORD_LEN-1, 2), 1.U(1.W), 0.U(1.W))
  io.imem.addr := ic_reg_imem_addr
  io.imem.en := true.B
  ic_reg_read_rdy := true.B
  ic_reg_half_rdy := true.B
  ic_read_rdy := ic_reg_read_rdy
  ic_half_rdy := ic_reg_half_rdy
  ic_data_out := BUBBLE
  ic_addr_out := ic_reg_addr_out
  ic_reg_addr_out := ic_addr_out

  when (ic_addr_en) {
    val ic_next_imem_addr = Cat(ic_addr(WORD_LEN-1, 2), Fill(2, 0.U))
    io.imem.addr := ic_next_imem_addr
    ic_reg_imem_addr := ic_next_imem_addr
    ic_addr_out := ic_addr
    ic_state := Mux(ic_addr(1).asBool, IcState.EmptyHalf, IcState.Empty)
    ic_reg_read_rdy := !ic_addr(1).asBool
  }.elsewhen (/*ic_state =/= IcState.Full && ic_state =/= IcState.Full2Half &&*/ !io.imem.valid) {
    ic_reg_read_rdy := ic_reg_read_rdy
    ic_reg_half_rdy := ic_reg_half_rdy
    ic_read_rdy := false.B
    ic_half_rdy := false.B
  }.otherwise {
    switch (ic_state) {
      is (IcState.Empty) {
        io.imem.addr := ic_imem_addr_4
        ic_reg_imem_addr := ic_imem_addr_4
        ic_reg_inst := io.imem.inst
        ic_reg_inst_addr := ic_reg_imem_addr
        ic_data_out := io.imem.inst
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
        io.imem.addr := ic_imem_addr_4
        ic_reg_imem_addr := ic_imem_addr_4
        ic_reg_inst := io.imem.inst
        ic_reg_inst_addr := ic_reg_imem_addr
        ic_data_out := Cat(Fill(WORD_LEN/2-1, 0.U), io.imem.inst(WORD_LEN-1, WORD_LEN/2))
        ic_addr_out := ic_imem_addr_2
        ic_state := IcState.FullHalf
        when (ic_read_en2) {
          ic_addr_out := ic_imem_addr_4
          ic_state := IcState.Empty
        }
      }
      is (IcState.Full) {
        io.imem.addr := ic_reg_imem_addr
        ic_data_out := ic_reg_inst
        when (ic_read_en2) {
          ic_addr_out := ic_inst_addr_2
          ic_state := IcState.FullHalf
        }.elsewhen(ic_read_en4) {
          ic_addr_out := ic_reg_imem_addr
          ic_state := IcState.Empty
        }
      }
      is (IcState.FullHalf) {
        io.imem.addr := ic_imem_addr_4
        ic_reg_imem_addr := ic_imem_addr_4
        ic_data_out := Cat(io.imem.inst(WORD_LEN/2-1, 0), ic_reg_inst(WORD_LEN-1, WORD_LEN/2))
        ic_reg_inst2 := io.imem.inst
        ic_reg_inst2_addr := ic_reg_imem_addr
        ic_state := IcState.Full2Half
        when (ic_read_en2) {
          ic_reg_inst := io.imem.inst
          ic_reg_inst_addr := ic_reg_imem_addr
          ic_addr_out := ic_reg_imem_addr
          ic_state := IcState.Full
        }.elsewhen(ic_read_en4) {
          ic_reg_inst := io.imem.inst
          ic_reg_inst_addr := ic_reg_imem_addr
          ic_addr_out := Cat(ic_reg_imem_addr(WORD_LEN-1, 2), 1.U(1.W), 0.U(1.W))
          ic_state := IcState.FullHalf
        }
      }
      is (IcState.Full2Half) {
        io.imem.addr := ic_reg_imem_addr
        ic_data_out := Cat(ic_reg_inst2(WORD_LEN/2-1, 0), ic_reg_inst(WORD_LEN-1, WORD_LEN/2))
        when (ic_read_en2) {
          ic_reg_inst := ic_reg_inst2
          ic_reg_inst_addr := ic_reg_inst2_addr
          ic_addr_out := ic_reg_inst2_addr
          ic_state := IcState.Full
        }.elsewhen(ic_read_en4) {
          ic_reg_inst := ic_reg_inst2
          ic_reg_inst_addr := ic_reg_inst2_addr
          ic_addr_out := Cat(ic_reg_inst2_addr(WORD_LEN-1, 2), 1.U(1.W), 0.U(1.W))
          ic_state := IcState.FullHalf
        }
      }
    }
  }

  //**********************************
  // Branch Prediction Controller

  val bp = Module(new BranchPredictor(BP_CACHE_LEN, bpTagInitPath))

  //**********************************
  // Instruction Fetch (IF) 1 Stage

  val if1_reg_carib_counter = RegInit(caribCount.U(18.W))
  val if1_reg_first = RegInit(true.B)
  if1_reg_first := false.B
  // when (if1_reg_carib_counter =/= 0.U) {
  //   if1_reg_carib_counter := if1_reg_carib_counter - 1.U
  // }.otherwise {
  //   if1_reg_first := false.B
  // }

  val if1_jump_addr = MuxCase(0.U(WORD_LEN.W), Seq(
    ex2_reg_is_br     -> ex2_reg_br_addr,
    if2_reg_is_bp_pos -> if2_reg_bp_addr,
    if1_reg_first     -> startAddress.U,
  ))
  val if1_is_jump = ex2_reg_is_br || if2_reg_is_bp_pos || if1_reg_first

  ic_addr_en  := if1_is_jump
  ic_addr     := if1_jump_addr

  bp.io.lu.inst_pc := ic_addr_out

  //**********************************
  // IF1/IF2 Register

  //**********************************
  // Instruction Fetch (IF) 2 Stage

  val if2_reg_pc   = RegInit(startAddress.U(WORD_LEN.W))
  val if2_reg_inst = RegInit(0.U(WORD_LEN.W))
  val if2_reg_inst_cnt = RegInit(0.U(INST_CNT_LEN.W))

  val is_half_inst = (ic_data_out(1, 0) =/= 3.U)
  ic_read_en2 := !id_reg_stall && is_half_inst
  ic_read_en4 := !id_reg_stall && !is_half_inst
  val if2_pc = Mux(id_reg_stall || !(ic_read_rdy || (ic_half_rdy && is_half_inst)),
    if2_reg_pc,
    ic_reg_addr_out,
  )
  if2_reg_pc := if2_pc
  val if2_inst = MuxCase(BUBBLE, Seq(
	  // 優先順位重要！ジャンプ成立とストールが同時発生した場合、ジャンプ処理を優先
    ex2_reg_is_br     -> BUBBLE,
    id_reg_stall      -> if2_reg_inst,
    if2_reg_is_bp_pos -> BUBBLE,
    ic_read_rdy   -> ic_data_out,
    (ic_half_rdy && is_half_inst) -> ic_data_out,
  ))
  if2_reg_inst := if2_inst
  val if2_is_cond_br_w = (if2_inst(6, 0) === 0x63.U)
  val if2_is_cond_br_c = (if2_inst(15, 14) === 3.U && if2_inst(1, 0) === 1.U)
  val if2_is_cond_br = if2_is_cond_br_w || if2_is_cond_br_c
  val if2_is_jal_w = (if2_inst(6, 0) === 0x6f.U)
  val if2_is_jal_c = (if2_inst(14, 13) === 1.U && if2_inst(1, 0) === 1.U)
  val if2_is_jal = if2_is_jal_w || if2_is_jal_c
  val if2_is_jalr = ((if2_inst(6, 0) === 0x67.U) || (if2_inst(15, 13) === 4.U && if2_inst(6, 0) === 2.U))
  val if2_is_bp_br = if2_is_cond_br || if2_is_jalr || if2_is_jal
  val if2_is_bp_pos = MuxCase(false.B, Seq(
    ex2_reg_is_br -> false.B,
    id_reg_stall  -> if2_reg_is_bp_pos,
    if2_is_bp_br  -> bp.io.lu.br_pos,
  ))
  if2_reg_is_bp_pos := if2_is_bp_pos
  val if2_bp_addr = Mux(id_reg_stall,
    if2_reg_bp_addr,
    bp.io.lu.br_addr,
  )
  if2_reg_bp_addr := if2_bp_addr
  val if2_inst_cnt = Mux(!ex2_reg_is_br && id_reg_stall, if2_reg_inst_cnt, if2_reg_inst_cnt + 1.U)
  if2_reg_inst_cnt := if2_inst_cnt
  
  printf(p"ic_reg_addr_out: ${Hexadecimal(ic_reg_addr_out)}, ic_data_out: ${Hexadecimal(ic_data_out)}\n")
  printf(p"inst: ${Hexadecimal(if2_inst)}, ic_read_rdy: ${ic_read_rdy}, ic_state: ${ic_state.asUInt}\n")

  //**********************************
  // IF2/ID Register
  id_reg_pc   := MuxCase(if2_pc, Seq(
    id_reg_stall -> id_reg_pc,
  ))
  id_reg_pc_cache  := if2_pc
  id_reg_inst      := if2_inst
  id_reg_is_bp_pos := MuxCase(if2_is_bp_pos, Seq(
    id_reg_stall -> id_reg_is_bp_pos
  ))
  id_reg_bp_addr   := MuxCase(if2_bp_addr, Seq(
    id_reg_stall -> id_reg_bp_addr
  ))
  id_reg_inst_cnt  := if2_inst_cnt

  //**********************************
  // Instruction Decode (ID) Stage

  id_stall := rrd_stall || ex2_stall
  id_reg_stall := id_stall

  // branch,jump時にIDをBUBBLE化
  val id_inst = Mux(ex2_reg_is_br, BUBBLE, id_reg_inst)

  val id_is_half = (id_inst(1, 0) =/= 3.U)

  val id_rs1_addr = id_inst(19, 15)
  val id_rs2_addr = id_inst(24, 20)
  val id_w_wb_addr  = id_inst(11, 7)

  val ex2_wb_data = Wire(UInt(WORD_LEN.W))

  val id_c_rs1_addr  = id_inst(11, 7)
  val id_c_rs2_addr  = id_inst(6, 2)
  val id_c_wb_addr   = id_inst(11, 7)
  val id_c_rs1p_addr = Cat(1.U(2.W), id_inst(9, 7))
  val id_c_rs2p_addr = Cat(1.U(2.W), id_inst(4, 2))
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
  val id_c_imm_sl = Cat(Fill(24, 0.U), id_inst(3, 2), id_inst(12), id_inst(6, 4), Fill(2, 0.U))
  val id_c_imm_ss = Cat(Fill(24, 0.U), id_inst(8, 7), id_inst(12, 9), Fill(2, 0.U))
  val id_c_imm_iw = Cat(Fill(22, 0.U), id_inst(10, 7), id_inst(12, 11), id_inst(5), id_inst(6), Fill(2, 0.U))
  val id_c_imm_ls = Cat(Fill(25, 0.U), id_inst(5), id_inst(12, 10), id_inst(6), Fill(2, 0.U))
  val id_c_imm_b = Cat(Fill(24, id_inst(12)), id_inst(6, 5), id_inst(2), id_inst(11, 10), id_inst(4, 3), 0.U(1.W))
  val id_c_imm_j = Cat(Fill(21, id_inst(12)), id_inst(8), id_inst(10, 9), id_inst(6), id_inst(7), id_inst(2), id_inst(11), id_inst(5, 3), 0.U(1.W))

  val csignals = ListLookup(id_inst,
                    List(ALU_X     , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
    Array(
      LB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_LD , WBA_RD , CSR_X, MW_B),
      LBU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_LD , WBA_RD , CSR_X, MW_BU),
      SB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , REN_X, WB_ST , WBA_RD , CSR_X, MW_B),
      LH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_LD , WBA_RD , CSR_X, MW_H),
      LHU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_LD , WBA_RD , CSR_X, MW_HU),
      SH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , REN_X, WB_ST , WBA_RD , CSR_X, MW_H),
      LW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_LD , WBA_RD , CSR_X, MW_W),
      SW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMS    , REN_X, WB_ST , WBA_RD , CSR_X, MW_W),
      ADD        -> List(ALU_ADD   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      ADDI       -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SUB        -> List(ALU_SUB   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      AND        -> List(ALU_AND   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      OR         -> List(ALU_OR    , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      XOR        -> List(ALU_XOR   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      ANDI       -> List(ALU_AND   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      ORI        -> List(ALU_OR    , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      XORI       -> List(ALU_XOR   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLL        -> List(ALU_SLL   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SRL        -> List(ALU_SRL   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SRA        -> List(ALU_SRA   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLLI       -> List(ALU_SLL   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SRLI       -> List(ALU_SRL   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SRAI       -> List(ALU_SRA   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLT        -> List(ALU_SLT   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLTU       -> List(ALU_SLTU  , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLTI       -> List(ALU_SLT   , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      SLTIU      -> List(ALU_SLTU  , OP1_RS1   , OP2_IMI    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      BEQ        -> List(BR_BEQ    , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      BNE        -> List(BR_BNE    , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      BGE        -> List(BR_BGE    , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      BGEU       -> List(BR_BGEU   , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      BLT        -> List(BR_BLT    , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      BLTU       -> List(BR_BLTU   , OP1_RS1   , OP2_RS2    , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      JAL        -> List(ALU_ADD   , OP1_PC    , OP2_IMJ    , REN_S, WB_PC , WBA_RD , CSR_X, MW_X),
      JALR       -> List(ALU_ADD   , OP1_RS1   , OP2_IMI    , REN_S, WB_PC , WBA_RD , CSR_X, MW_X),
      LUI        -> List(ALU_ADD   , OP1_X     , OP2_IMU    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      AUIPC      -> List(ALU_ADD   , OP1_PC    , OP2_IMU    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      CSRRW      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_W, MW_X),
      CSRRWI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_W, MW_X),
      CSRRS      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_S, MW_X),
      CSRRSI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_S, MW_X),
      CSRRC      -> List(ALU_ADD   , OP1_RS1   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_C, MW_X),
      CSRRCI     -> List(ALU_ADD   , OP1_IMZ   , OP2_Z      , REN_S, WB_CSR, WBA_RD , CSR_C, MW_X),
      ECALL      -> List(CMD_ECALL , OP1_X     , OP2_X      , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      MRET       -> List(CMD_MRET  , OP1_X     , OP2_X      , REN_X, WB_X  , WBA_RD , CSR_X, MW_X),
      FENCE_I    -> List(ALU_X     , OP1_X     , OP2_X      , REN_X, WB_FENCE, WBA_RD, CSR_X, MW_X),
      MUL        -> List(ALU_MUL   , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      MULH       -> List(ALU_MULH  , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      MULHU      -> List(ALU_MULHU , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      MULHSU     -> List(ALU_MULHSU, OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      DIV        -> List(ALU_DIV   , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      DIVU       -> List(ALU_DIVU  , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      REM        -> List(ALU_REM   , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      REMU       -> List(ALU_REMU  , OP1_RS1   , OP2_RS2    , REN_S, WB_MD,  WBA_RD , CSR_X, MW_X),
      MAX        -> List(ALU_MAX   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      MAXU       -> List(ALU_MAXU  , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      MIN        -> List(ALU_MIN   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      MINU       -> List(ALU_MINU  , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      CLZ        -> List(ALU_CLZ   , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      CTZ        -> List(ALU_CTZ   , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      CPOP       -> List(ALU_CPOP  , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      REV8       -> List(ALU_REV8  , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      SEXTB      -> List(ALU_SEXTB , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      SEXTH      -> List(ALU_SEXTH , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      ZEXTH      -> List(ALU_ZEXTH , OP1_RS1   , OP2_X      , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      ANDN       -> List(ALU_ANDN  , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      ORN        -> List(ALU_ORN   , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      XNOR       -> List(ALU_XNOR  , OP1_RS1   , OP2_RS2    , REN_S, WB_ALU, WBA_RD , CSR_X, MW_X),
      // ROL     -> List(ALU_ROL   , OP1_RS1   , OP2_RS2    , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      // ROR     -> List(ALU_ROR   , OP1_RS1   , OP2_RS2    , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      // RORI    -> List(ALU_ROR   , OP1_RS1   , OP2_IMI    , REN_S, WB_BIT, WBA_RD , CSR_X, MW_X),
      C_ILL      -> List(ALU_X     , OP1_X     , OP2_X      , REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_ADDI4SPN -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMIW , REN_S, WB_ALU, WBA_CP2, CSR_X, MW_X),
      C_ADDI16SP -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_IMI16, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_ADDI     -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_IMI  , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_LW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLS , REN_S, WB_LD , WBA_CP2, CSR_X, MW_W),
      C_SW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_IMLS , REN_X, WB_ST , WBA_C  , CSR_X, MW_W),
      C_LI       -> List(ALU_ADD   , OP1_X     , OP2_C_IMI  , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_LUI      -> List(ALU_ADD   , OP1_X     , OP2_C_IMIU , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_SRAI     -> List(ALU_SRA   , OP1_C_RS1P, OP2_C_IMI  , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SRLI     -> List(ALU_SRL   , OP1_C_RS1P, OP2_C_IMI  , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_ANDI     -> List(ALU_AND   , OP1_C_RS1P, OP2_C_IMI  , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SUB      -> List(ALU_SUB   , OP1_C_RS1P, OP2_C_RS2P , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_XOR      -> List(ALU_XOR   , OP1_C_RS1P, OP2_C_RS2P , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_OR       -> List(ALU_OR    , OP1_C_RS1P, OP2_C_RS2P , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_AND      -> List(ALU_AND   , OP1_C_RS1P, OP2_C_RS2P , REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SLLI     -> List(ALU_SLL   , OP1_C_RS1 , OP2_C_IMI  , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_J        -> List(ALU_ADD   , OP1_PC    , OP2_C_IMJ  , REN_X, WB_PC , WBA_C  , CSR_X, MW_X),
      C_BEQZ     -> List(BR_BEQ    , OP1_C_RS1P, OP2_Z      , REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_BNEZ     -> List(BR_BNE    , OP1_C_RS1P, OP2_Z      , REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_JR       -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z      , REN_X, WB_PC , WBA_C  , CSR_X, MW_X),
      C_JALR     -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z      , REN_S, WB_PC , WBA_RA , CSR_X, MW_X),
      C_JAL      -> List(ALU_ADD   , OP1_PC    , OP2_C_IMJ  , REN_S, WB_PC , WBA_RA , CSR_X, MW_X),
      C_LWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMSL , REN_S, WB_LD , WBA_C  , CSR_X, MW_W),
      C_SWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_C_IMSS , REN_X, WB_ST , WBA_C  , CSR_X, MW_W),
      C_MV       -> List(ALU_ADD   , OP1_Z     , OP2_C_RS2  , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_ADD      -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_RS2  , REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
		)
	)
  val List(id_exe_fun, id_op1_sel, id_op2_sel, id_rf_wen, id_wb_sel, id_wba, id_csr_cmd, id_mem_w) = csignals

  val id_wb_addr = MuxCase(id_w_wb_addr, Seq(
    (id_wba === WBA_C)   -> id_c_wb_addr,
    (id_wba === WBA_CP1) -> id_c_wb1p_addr,
    (id_wba === WBA_CP2) -> id_c_wb2p_addr,
    (id_wba === WBA_RA)  -> 1.U(ADDR_LEN.W),
  ))

  val id_op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op1_sel === OP1_PC)     -> id_reg_pc,
    (id_op1_sel === OP1_IMZ)    -> id_imm_z_uext,
  ))
  val id_op2_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op2_sel === OP2_IMI)     -> id_imm_i_sext,
    (id_op2_sel === OP2_IMS)     -> id_imm_s_sext,
    (id_op2_sel === OP2_IMJ)     -> id_imm_j_sext,
    (id_op2_sel === OP2_IMU)     -> id_imm_u_shifted,
    (id_op2_sel === OP2_C_IMIW)  -> id_c_imm_iw,
    (id_op2_sel === OP2_C_IMI16) -> id_c_imm_i16,
    (id_op2_sel === OP2_C_IMI)   -> id_c_imm_i,
    (id_op2_sel === OP2_C_IMLS)  -> id_c_imm_ls,
    (id_op2_sel === OP2_C_IMIU)  -> id_c_imm_iu,
    (id_op2_sel === OP2_C_IMJ)   -> id_c_imm_j,
    (id_op2_sel === OP2_C_IMSL)  -> id_c_imm_sl,
    (id_op2_sel === OP2_C_IMSS)  -> id_c_imm_ss,
  ))

  val id_csr_addr = Mux(id_exe_fun === CMD_ECALL, CSR_ADDR_MCAUSE, id_inst(31,20))

  val id_m_op1_sel = MuxCase(id_op1_sel, Seq(
    (id_op1_sel === OP1_C_RS1)  -> OP1_RS1,
    (id_op1_sel === OP1_C_SP)   -> OP1_RS1,
    (id_op1_sel === OP1_C_RS1P) -> OP1_RS1,
  ))
  val id_m_op2_sel = MuxCase(id_op2_sel, Seq(
    (id_op2_sel === OP2_C_RS2)  -> OP2_RS2,
    (id_op2_sel === OP2_C_RS2P) -> OP2_RS2,
  ))
  val id_m_rs1_addr = MuxCase(id_rs1_addr, Seq(
    (id_op1_sel === OP1_C_RS1)  -> id_c_rs1_addr,
    (id_op1_sel === OP1_C_SP)   -> 2.U(ADDR_LEN.W),
    (id_op1_sel === OP1_C_RS1P) -> id_c_rs1p_addr,
  ))
  val id_m_rs2_addr = MuxCase(id_rs2_addr, Seq(
    (id_op2_sel === OP2_C_RS2)  -> id_c_rs2_addr,
    (id_op2_sel === OP2_C_RS2P) -> id_c_rs2p_addr,
    (id_op2_sel === OP2_C_IMLS) -> id_c_rs2p_addr,
    (id_op2_sel === OP2_C_IMSS) -> id_c_rs2_addr,
  ))
  val id_m_imm_b_sext = MuxCase(id_imm_b_sext, Seq(
    (id_wba === WBA_C) -> id_c_imm_b,
  ))

  val id_is_direct_j = (id_op2_sel === OP2_IMJ) || (id_op2_sel === OP2_C_IMJ)
  val id_is_br = (
    (id_exe_fun === BR_BEQ) ||
    (id_exe_fun === BR_BNE) ||
    (id_exe_fun === BR_BLT) ||
    (id_exe_fun === BR_BGE) ||
    (id_exe_fun === BR_BLTU) ||
    (id_exe_fun === BR_BGEU)
  )
  val id_is_j = (id_wb_sel === WB_PC)
  val id_is_trap = (id_exe_fun === CMD_ECALL)
  val id_mcause = CSR_MCAUSE_ECALL_M
  // val id_mtval = 0.U(WORD_LEN.W)

  val id_reg_pc_delay         = RegInit(0.U(WORD_LEN.W))
  val id_reg_inst_cnt_delay   = RegInit(0.U(INST_CNT_LEN.W))
  val id_reg_wb_addr_delay    = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_sel_delay    = RegInit(0.U(OP1_LEN.W))
  val id_reg_op2_sel_delay    = RegInit(0.U(OP2_LEN.W))
  val id_reg_rs1_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_rs2_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_op2_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_exe_fun_delay    = RegInit(0.U(EXE_FUN_LEN.W))
  val id_reg_rf_wen_delay     = RegInit(0.U(REN_LEN.W))
  val id_reg_wb_sel_delay     = RegInit(0.U(WB_SEL_LEN.W))
  val id_reg_csr_addr_delay   = RegInit(0.U(CSR_ADDR_LEN.W))
  val id_reg_csr_cmd_delay    = RegInit(0.U(CSR_LEN.W))
  val id_reg_imm_b_sext_delay = RegInit(0.U(WORD_LEN.W))
  val id_reg_mem_w_delay      = RegInit(0.U(MW_LEN.W))
  val id_reg_is_direct_j_delay = RegInit(false.B)
  val id_reg_is_br_delay      = RegInit(false.B)
  val id_reg_is_j_delay       = RegInit(false.B)
  val id_reg_is_bp_pos_delay  = RegInit(false.B)
  val id_reg_bp_addr_delay    = RegInit(0.U(WORD_LEN.W))
  val id_reg_is_half_delay    = RegInit(false.B)
  val id_reg_is_valid_inst_delay = RegInit(false.B)
  val id_reg_is_trap_delay    = RegInit(false.B)
  val id_reg_mcause_delay     = RegInit(0.U(WORD_LEN.W))
  // val id_reg_mtval_delay      = RegInit(0.U(WORD_LEN.W))

  when (ex2_reg_is_br) {
    when (!id_reg_stall) {
      id_reg_pc_delay          := id_reg_pc
      id_reg_inst_cnt_delay    := id_reg_inst_cnt
    }
    id_reg_rf_wen_delay        := REN_X
    id_reg_exe_fun_delay       := ALU_ADD
    id_reg_wb_sel_delay        := WB_X
    id_reg_csr_cmd_delay       := CSR_X
    id_reg_mem_w_delay         := MW_X
    id_reg_is_j_delay          := false.B
    id_reg_is_bp_pos_delay     := false.B
    id_reg_is_valid_inst_delay := false.B
    id_reg_is_trap_delay       := false.B
  }.elsewhen (!id_reg_stall) {
    id_reg_pc_delay         := id_reg_pc
    id_reg_inst_cnt_delay   := id_reg_inst_cnt
    id_reg_op1_sel_delay    := id_m_op1_sel
    id_reg_op2_sel_delay    := id_m_op2_sel
    id_reg_rs1_addr_delay   := id_m_rs1_addr
    id_reg_rs2_addr_delay   := id_m_rs2_addr
    id_reg_op1_data_delay   := id_op1_data
    id_reg_op2_data_delay   := id_op2_data
    id_reg_wb_addr_delay    := id_wb_addr
    id_reg_rf_wen_delay     := id_rf_wen
    id_reg_exe_fun_delay    := id_exe_fun
    id_reg_wb_sel_delay     := id_wb_sel
    id_reg_imm_b_sext_delay := id_m_imm_b_sext
    id_reg_csr_addr_delay   := id_csr_addr
    id_reg_csr_cmd_delay    := id_csr_cmd
    id_reg_mem_w_delay      := id_mem_w
    id_reg_is_direct_j_delay := id_is_direct_j
    id_reg_is_br_delay      := id_is_br
    id_reg_is_j_delay       := id_is_j
    id_reg_is_bp_pos_delay  := id_reg_is_bp_pos
    id_reg_bp_addr_delay    := id_reg_bp_addr
    id_reg_is_half_delay    := id_is_half
    id_reg_is_valid_inst_delay := id_inst =/= BUBBLE
    id_reg_is_trap_delay    := id_is_trap
    id_reg_mcause_delay     := id_mcause
    // id_reg_mtval_delay      := id_mtval
  }

  //**********************************
  // ID/RRD register
  when (ex2_reg_is_br) {
    when(id_reg_stall) {
      rrd_reg_pc            := id_reg_pc_delay
      rrd_reg_inst_cnt      := id_reg_inst_cnt_delay
      rrd_reg_op1_sel       := id_reg_op1_sel_delay
      rrd_reg_op2_sel       := id_reg_op2_sel_delay
      rrd_reg_rs1_addr      := id_reg_rs1_addr_delay
      rrd_reg_rs2_addr      := id_reg_rs2_addr_delay
      rrd_reg_op1_data      := id_reg_op1_data_delay
      rrd_reg_op2_data      := id_reg_op2_data_delay
      rrd_reg_wb_addr       := id_reg_wb_addr_delay
      rrd_reg_rf_wen        := REN_X
      rrd_reg_exe_fun       := ALU_ADD
      rrd_reg_wb_sel        := WB_X
      rrd_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      rrd_reg_csr_addr      := id_reg_csr_addr_delay
      rrd_reg_csr_cmd       := CSR_X
      rrd_reg_mem_w         := MW_X
      rrd_reg_is_direct_j   := false.B
      rrd_reg_is_br         := false.B
      rrd_reg_is_j          := false.B
      rrd_reg_is_bp_pos     := false.B
      rrd_reg_bp_addr       := id_reg_bp_addr_delay
      rrd_reg_is_half       := id_reg_is_half_delay
      rrd_reg_is_valid_inst := false.B
      rrd_reg_is_trap       := false.B
      rrd_reg_mcause        := id_reg_mcause_delay
      // rrd_reg_mtval         := id_reg_mtval_delay
    }.otherwise {
      rrd_reg_pc            := id_reg_pc
      rrd_reg_inst_cnt      := id_reg_inst_cnt
      rrd_reg_op1_sel       := id_m_op1_sel
      rrd_reg_op2_sel       := id_m_op2_sel
      rrd_reg_rs1_addr      := id_m_rs1_addr
      rrd_reg_rs2_addr      := id_m_rs2_addr
      rrd_reg_op1_data      := id_op1_data
      rrd_reg_op2_data      := id_op2_data
      rrd_reg_wb_addr       := id_wb_addr
      rrd_reg_rf_wen        := REN_X
      rrd_reg_exe_fun       := ALU_ADD
      rrd_reg_wb_sel        := WB_X
      rrd_reg_imm_b_sext    := id_m_imm_b_sext
      rrd_reg_csr_addr      := id_csr_addr
      rrd_reg_csr_cmd       := CSR_X
      rrd_reg_mem_w         := MW_X
      rrd_reg_is_direct_j   := false.B
      rrd_reg_is_br         := false.B
      rrd_reg_is_j          := false.B
      rrd_reg_is_bp_pos     := false.B
      rrd_reg_bp_addr       := id_reg_bp_addr
      rrd_reg_is_half       := id_is_half
      rrd_reg_is_valid_inst := false.B
      rrd_reg_is_trap       := false.B
      rrd_reg_mcause        := id_mcause
      // rrd_reg_mtval         := id_mtval
    }
  }.elsewhen(!rrd_stall && !ex2_stall) {
    when(id_reg_stall) {
      rrd_reg_pc            := id_reg_pc_delay
      rrd_reg_inst_cnt      := id_reg_inst_cnt_delay
      rrd_reg_op1_sel       := id_reg_op1_sel_delay
      rrd_reg_op2_sel       := id_reg_op2_sel_delay
      rrd_reg_rs1_addr      := id_reg_rs1_addr_delay
      rrd_reg_rs2_addr      := id_reg_rs2_addr_delay
      rrd_reg_op1_data      := id_reg_op1_data_delay
      rrd_reg_op2_data      := id_reg_op2_data_delay
      rrd_reg_wb_addr       := id_reg_wb_addr_delay
      rrd_reg_rf_wen        := id_reg_rf_wen_delay
      rrd_reg_exe_fun       := id_reg_exe_fun_delay
      rrd_reg_wb_sel        := id_reg_wb_sel_delay
      rrd_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      rrd_reg_csr_addr      := id_reg_csr_addr_delay
      rrd_reg_csr_cmd       := id_reg_csr_cmd_delay
      rrd_reg_mem_w         := id_reg_mem_w_delay
      rrd_reg_is_direct_j   := id_reg_is_direct_j_delay
      rrd_reg_is_br         := id_reg_is_br_delay
      rrd_reg_is_j          := id_reg_is_j_delay
      rrd_reg_is_bp_pos     := id_reg_is_bp_pos_delay
      rrd_reg_bp_addr       := id_reg_bp_addr_delay
      rrd_reg_is_half       := id_reg_is_half_delay
      rrd_reg_is_valid_inst := id_reg_is_valid_inst_delay
      rrd_reg_is_trap       := id_reg_is_trap_delay
      rrd_reg_mcause        := id_reg_mcause_delay
      // rrd_reg_mtval         := id_reg_mtval_delay
    }.otherwise {
      rrd_reg_pc            := id_reg_pc
      rrd_reg_inst_cnt      := id_reg_inst_cnt
      rrd_reg_op1_sel       := id_m_op1_sel
      rrd_reg_op2_sel       := id_m_op2_sel
      rrd_reg_rs1_addr      := id_m_rs1_addr
      rrd_reg_rs2_addr      := id_m_rs2_addr
      rrd_reg_op1_data      := id_op1_data
      rrd_reg_op2_data      := id_op2_data
      rrd_reg_wb_addr       := id_wb_addr
      rrd_reg_rf_wen        := id_rf_wen
      rrd_reg_exe_fun       := id_exe_fun
      rrd_reg_wb_sel        := id_wb_sel
      rrd_reg_imm_b_sext    := id_m_imm_b_sext
      rrd_reg_csr_addr      := id_csr_addr
      rrd_reg_csr_cmd       := id_csr_cmd
      rrd_reg_mem_w         := id_mem_w
      rrd_reg_is_direct_j   := id_is_direct_j
      rrd_reg_is_br         := id_is_br
      rrd_reg_is_j          := id_is_j
      rrd_reg_is_bp_pos     := id_reg_is_bp_pos
      rrd_reg_bp_addr       := id_reg_bp_addr
      rrd_reg_is_half       := id_is_half
      rrd_reg_is_valid_inst := id_inst =/= BUBBLE
      rrd_reg_is_trap       := id_is_trap
      rrd_reg_mcause        := id_mcause
      // rrd_reg_mtval         := id_mtval
    }
  }
  //**********************************
  // Register read (RRD) Stage

  rrd_stall :=
    ((rrd_reg_op1_sel === OP1_RS1) && scoreboard(rrd_reg_rs1_addr)) ||
    ((rrd_reg_op2_sel === OP2_RS2 || rrd_reg_wb_sel === WB_ST) && scoreboard(rrd_reg_rs2_addr)) ||
    ((rrd_reg_rf_wen === REN_S) && scoreboard(rrd_reg_wb_addr)) ||
    ((rrd_reg_rf_wen === REN_S) && (rrd_reg_wb_sel === WB_ALU) && ex1_reg_is_indirect_j)

  val rrd_op1_data = MuxCase(rrd_reg_op1_data, Seq(
    (rrd_reg_op1_sel === OP1_RS1 && rrd_reg_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_op1_sel === OP1_RS1) &&
     (rrd_reg_rs1_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_op1_sel === OP1_RS1) &&
     (rrd_reg_rs1_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
    (rrd_reg_op1_sel === OP1_RS1) -> regfile(rrd_reg_rs1_addr),
  ))
  val rrd_op2_data = MuxCase(rrd_reg_op2_data, Seq(
    (rrd_reg_op2_sel === OP2_RS2 && rrd_reg_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_op2_sel === OP2_RS2) &&
     (rrd_reg_rs2_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_op2_sel === OP2_RS2) &&
     (rrd_reg_rs2_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
    (rrd_reg_op2_sel === OP2_RS2) -> regfile(rrd_reg_rs2_addr),
  ))
  val rrd_rs2_data = MuxCase(regfile(rrd_reg_rs2_addr), Seq(
    (rrd_reg_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (rrd_reg_rs2_addr === ex1_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (rrd_reg_rs2_addr === ex2_reg_wb_addr)) -> ex2_fw_data,
  ))

  val rrd_direct_jbr_target = rrd_reg_pc + MuxCase(rrd_reg_imm_b_sext, Seq(
    rrd_reg_is_direct_j -> rrd_reg_op2_data,
  ))
  val rrd_is_indirect_j = (rrd_reg_is_j && !rrd_reg_is_direct_j) ||
    (rrd_reg_exe_fun === CMD_ECALL) ||
    (rrd_reg_exe_fun === CMD_MRET)

  val rrd_hazard = (rrd_reg_rf_wen === REN_S) && (rrd_reg_wb_addr =/= 0.U) && !rrd_stall && !ex2_reg_is_br
  val rrd_fw_en_next = rrd_hazard && ((rrd_reg_wb_sel === WB_ALU) || (rrd_reg_wb_sel === WB_PC))

  val rrd_mem_use_reg   = WireDefault(false.B)
  val rrd_inst2_use_reg = WireDefault(false.B)
  val rrd_inst3_use_reg = WireDefault(false.B)

  when (
    !ex2_stall && !rrd_stall && !ex2_reg_is_br &&
    rrd_reg_rf_wen === REN_S && rrd_reg_wb_addr =/= 0.U
  ) {
      scoreboard(rrd_reg_wb_addr) := (rrd_reg_wb_sel =/= WB_ALU && rrd_reg_wb_sel =/= WB_PC)
      rrd_mem_use_reg   := (rrd_reg_wb_sel === WB_LD || rrd_reg_wb_sel === WB_ST)
      rrd_inst2_use_reg := (rrd_reg_wb_sel === WB_BIT || rrd_reg_wb_sel === WB_FENCE)
      rrd_inst3_use_reg := (rrd_reg_wb_sel === WB_MD || rrd_reg_wb_sel === WB_CSR)
  }

  //**********************************
  // RRD/EX1 register
  when(!ex2_stall) {
    val ex_is_bubble = rrd_stall || ex2_reg_is_br
    ex1_reg_pc            := rrd_reg_pc
    ex1_reg_inst_cnt      := rrd_reg_inst_cnt
    ex1_reg_op1_data      := rrd_op1_data
    ex1_reg_op2_data      := rrd_op2_data
    ex1_reg_rs2_data      := rrd_rs2_data
    ex1_reg_wb_addr       := rrd_reg_wb_addr
    ex1_reg_rf_wen        := Mux(ex_is_bubble, REN_X, rrd_reg_rf_wen)
    ex1_reg_exe_fun       := Mux(ex_is_bubble, ALU_ADD, rrd_reg_exe_fun)
    ex1_reg_wb_sel        := Mux(ex_is_bubble, WB_X, rrd_reg_wb_sel)
    ex1_reg_direct_jbr_target := rrd_direct_jbr_target
    ex1_reg_csr_addr      := rrd_reg_csr_addr
    ex1_reg_csr_cmd       := Mux(ex_is_bubble, CSR_X, rrd_reg_csr_cmd)
    ex1_reg_mem_w         := rrd_reg_mem_w
    // ex1_reg_is_direct_j   := rrd_reg_is_direct_j
    ex1_reg_is_br         := rrd_reg_is_br
    ex1_reg_is_j          := rrd_reg_is_j
    ex1_reg_is_bp_pos     := rrd_reg_is_bp_pos
    ex1_reg_bp_addr       := rrd_reg_bp_addr
    ex1_reg_is_half       := rrd_reg_is_half
    ex1_reg_is_valid_inst := rrd_reg_is_valid_inst && !ex_is_bubble
    ex1_reg_is_trap       := Mux(ex_is_bubble, false.B, rrd_reg_is_trap)
    ex1_reg_mcause        := rrd_reg_mcause
    // ex1_reg_mtval         := rrd_reg_mtval
    ex1_reg_mem_use_reg   := rrd_mem_use_reg
    ex1_reg_inst2_use_reg := rrd_inst2_use_reg
    ex1_reg_inst3_use_reg := rrd_inst3_use_reg
    ex1_reg_is_indirect_j := rrd_reg_is_valid_inst && !ex_is_bubble && rrd_is_indirect_j
    ex1_reg_fw_en         := rrd_fw_en_next
  }

  //**********************************
  // Execute (EX1) Stage

  val ex1_alu_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_exe_fun === ALU_ADD)   -> (ex1_reg_op1_data + ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_SUB)   -> (ex1_reg_op1_data - ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_AND)   -> (ex1_reg_op1_data & ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_OR)    -> (ex1_reg_op1_data | ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_XOR)   -> (ex1_reg_op1_data ^ ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_SLL)   -> (ex1_reg_op1_data << ex1_reg_op2_data(4, 0))(31, 0),
    (ex1_reg_exe_fun === ALU_SRL)   -> (ex1_reg_op1_data >> ex1_reg_op2_data(4, 0)).asUInt(),
    (ex1_reg_exe_fun === ALU_SRA)   -> (ex1_reg_op1_data.asSInt() >> ex1_reg_op2_data(4, 0)).asUInt(),
    (ex1_reg_exe_fun === ALU_SLT)   -> (ex1_reg_op1_data.asSInt() < ex1_reg_op2_data.asSInt()).asUInt(),
    (ex1_reg_exe_fun === ALU_SLTU)  -> (ex1_reg_op1_data < ex1_reg_op2_data).asUInt(),
    (ex1_reg_exe_fun === ALU_MAX)   -> Mux(ex1_reg_op1_data.asSInt() < ex1_reg_op2_data.asSInt(), ex1_reg_op2_data, ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_MAXU)  -> Mux(ex1_reg_op1_data < ex1_reg_op2_data, ex1_reg_op2_data, ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_MIN)   -> Mux(ex1_reg_op1_data.asSInt() < ex1_reg_op2_data.asSInt(), ex1_reg_op1_data, ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_MINU)  -> Mux(ex1_reg_op1_data < ex1_reg_op2_data, ex1_reg_op1_data, ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_ANDN)  -> (ex1_reg_op1_data & ~ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_XNOR)  -> (ex1_reg_op1_data ^ ~ex1_reg_op2_data),
    (ex1_reg_exe_fun === ALU_ORN)   -> (ex1_reg_op1_data | ~ex1_reg_op2_data),
  ))

  val ex1_mullu  = (ex1_reg_op1_data * ex1_reg_op2_data(WORD_LEN/2-1, 0))
  val ex1_mulls  = (ex1_reg_op1_data.asSInt() * ex1_reg_op2_data(WORD_LEN/2-1, 0))(WORD_LEN*3/2-1, WORD_LEN/2)
  val ex1_mulhuu = (ex1_reg_op1_data * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2))
  val ex1_mulhss = (ex1_reg_op1_data.asSInt() * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2).asSInt())
  val ex1_mulhsu = (ex1_reg_op1_data.asSInt() * ex1_reg_op2_data(WORD_LEN-1, WORD_LEN/2))

  val ex1_next_pc = Mux(ex1_reg_is_half, ex1_reg_pc + 2.U(WORD_LEN.W), ex1_reg_pc + 4.U(WORD_LEN.W))
  val ex1_pc_bit_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex1_reg_wb_sel === WB_PC)      -> ex1_next_pc,
    (ex1_reg_exe_fun === ALU_ZEXTH) -> Cat(0.U(16.W), ex1_reg_op1_data(15, 0)),
    (ex1_reg_exe_fun === ALU_CPOP)  -> PopCount(ex1_reg_op1_data),
    (ex1_reg_exe_fun === ALU_CLZ)   -> PriorityEncoder(Cat(1.U(1.W), Reverse(ex1_reg_op1_data))),
    (ex1_reg_exe_fun === ALU_CTZ)   -> PriorityEncoder(Cat(1.U(1.W), ex1_reg_op1_data)),
    (ex1_reg_exe_fun === ALU_REV8)  -> Cat(ex1_reg_op1_data(7, 0), ex1_reg_op1_data(15, 8), ex1_reg_op1_data(23, 16), ex1_reg_op1_data(31, 24)),
    (ex1_reg_exe_fun === ALU_SEXTB) -> Cat(Fill(24, ex1_reg_op1_data(7)), ex1_reg_op1_data(7, 0)),
    (ex1_reg_exe_fun === ALU_SEXTH) -> Cat(Fill(16, ex1_reg_op1_data(15)), ex1_reg_op1_data(15, 0)),
    // (ex1_reg_exe_fun === ALU_ROL)   -> ((ex1_reg_op1_data << ex1_reg_op2_data(4, 0))(31, 0) | ((ex1_reg_op1_data >> 1.U) >> (~ex1_reg_op2_data(4, 0)))(31, 0)),
    // (ex1_reg_exe_fun === ALU_ROR)   -> ((ex1_reg_op1_data >> ex1_reg_op2_data(4, 0))(31, 0) | ((ex1_reg_op1_data << 1.U) << (~ex1_reg_op2_data(4, 0)))(31, 0)),
  ))

  val ex1_divrem = WireDefault(false.B)
  val ex1_sign_op1 = WireDefault(0.U(1.W))
  val ex1_sign_op12 = WireDefault(0.U(1.W))
  val ex1_zero_op2 = Wire(Bool())
  val ex1_dividend = WireDefault(0.U((WORD_LEN+5).W))
  val ex1_divisor = WireDefault(0.U(WORD_LEN.W))
  val ex1_orig_dividend = Wire(UInt(WORD_LEN.W))

  when (ex1_reg_exe_fun === ALU_DIV || ex1_reg_exe_fun === ALU_REM) {
    ex1_divrem := true.B
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
    ex1_divrem := true.B
    ex1_dividend := Cat(Fill(5, 0.U(1.W)), ex1_reg_op1_data(WORD_LEN-1, 0))
    ex1_sign_op1 := 0.U
    ex1_divisor := ex1_reg_op2_data
    ex1_sign_op12 := 0.U
  }
  ex1_zero_op2 := (ex1_reg_op2_data === 0.U)
  ex1_orig_dividend := ex1_reg_op1_data

  // branch
  val ex1_is_cond_br = MuxCase(false.B, Seq(
    (ex1_reg_exe_fun === BR_BEQ)  ->  (ex1_reg_op1_data === ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BNE)  -> !(ex1_reg_op1_data === ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BLT)  ->  (ex1_reg_op1_data.asSInt() < ex1_reg_op2_data.asSInt()),
    (ex1_reg_exe_fun === BR_BGE)  -> !(ex1_reg_op1_data.asSInt() < ex1_reg_op2_data.asSInt()),
    (ex1_reg_exe_fun === BR_BLTU) ->  (ex1_reg_op1_data < ex1_reg_op2_data),
    (ex1_reg_exe_fun === BR_BGEU) -> !(ex1_reg_op1_data < ex1_reg_op2_data)
  ))
  val ex1_is_cond_br_inst = ex1_reg_is_br
  val ex1_is_uncond_br = ex1_reg_is_j
  val ex1_cond_br_target = ex1_reg_direct_jbr_target
  val ex1_uncond_br_target = ex1_alu_out & ~1.U(WORD_LEN.W)
  // ex1_reg_is_direct_jbr_fail := ex1_is_valid_inst && (
  //   (ex1_reg_is_br && ex1_is_cond_br && (!ex1_reg_is_bp_pos || ex1_reg_direct_jbr_target =/= ex1_reg_bp_addr)) ||
  //   (ex1_reg_is_direct_j && (!ex1_reg_is_bp_pos || ex1_reg_direct_jbr_target =/= ex1_reg_bp_addr)) ||
  //   (ex1_reg_is_br && !ex1_is_cond_br && ex1_reg_is_bp_pos)
  // )

  ex1_fw_data := MuxCase(ex1_alu_out, Seq(
    (ex1_reg_wb_sel === WB_PC) -> ex1_next_pc,
  ))

  when (ex1_reg_inst2_use_reg) {
    scoreboard(ex1_reg_wb_addr) := false.B
  }

  val ex1_hazard = (ex1_reg_rf_wen === REN_S) && (ex1_reg_wb_addr =/= 0.U) && !ex2_reg_is_br
  val ex1_fw_en_next = ex1_hazard && (ex1_reg_wb_sel =/= WB_MD) && (ex1_reg_wb_sel =/= WB_LD)

  //**********************************
  // EX1/JBR register
  // jump, br 命令ではストールは発生しないためストール時は単に更新しない
  when (!ex2_stall) {
    jbr_reg_bp_en            := ex1_reg_is_valid_inst && !ex2_reg_is_br
    jbr_reg_is_cond_br       := ex1_is_cond_br
    jbr_reg_is_cond_br_inst  := ex1_is_cond_br_inst
    jbr_reg_is_uncond_br     := ex1_is_uncond_br
    jbr_reg_cond_br_target   := ex1_cond_br_target
    jbr_reg_uncond_br_target := ex1_uncond_br_target
    jbr_reg_is_bp_pos        := ex1_reg_is_bp_pos
    jbr_reg_bp_addr          := ex1_reg_bp_addr
    jbr_reg_is_half          := ex1_reg_is_half
  }

  //**********************************
  // Execute Jump/Branch (JBR) Stage

  val jbr_bp_en = jbr_reg_bp_en && !ex2_reg_is_br
  val jbr_cond_bp_fail = jbr_bp_en && (
    (!jbr_reg_is_bp_pos && jbr_reg_is_cond_br) ||
    (jbr_reg_is_bp_pos && jbr_reg_is_cond_br && (jbr_reg_bp_addr =/= jbr_reg_cond_br_target))
  )
  val jbr_cond_nbp_fail = jbr_bp_en && jbr_reg_is_bp_pos && jbr_reg_is_cond_br_inst && !jbr_reg_is_cond_br
  val jbr_uncond_bp_fail = (jbr_bp_en && jbr_reg_is_uncond_br) && (
    !jbr_reg_is_bp_pos ||
    (jbr_reg_is_bp_pos && (jbr_reg_bp_addr =/= jbr_reg_uncond_br_target))
  )
  ex2_reg_br_addr := MuxCase(csr_br_addr, Seq(
    jbr_cond_bp_fail   -> jbr_reg_cond_br_target,
    jbr_cond_nbp_fail  -> Mux(jbr_reg_is_half, ex2_reg_pc + 2.U(WORD_LEN.W), ex2_reg_pc + 4.U(WORD_LEN.W)),
    jbr_uncond_bp_fail -> jbr_reg_uncond_br_target,
  ))
  jbr_is_br := jbr_cond_bp_fail || jbr_cond_nbp_fail || jbr_uncond_bp_fail

  bp.io.up.update_en := jbr_bp_en && (jbr_reg_is_cond_br_inst || jbr_reg_is_uncond_br)
  bp.io.up.inst_pc := ex2_reg_pc
  bp.io.up.br_pos := jbr_reg_is_cond_br || jbr_reg_is_uncond_br
  bp.io.up.br_addr := MuxCase(DontCare, Seq(
    jbr_reg_is_cond_br   -> jbr_reg_cond_br_target,
    jbr_reg_is_uncond_br -> jbr_reg_uncond_br_target,
  ))

  // val jbr_cond_bp_success = jbr_bp_en && jbr_reg_is_cond_br && (
  //   jbr_reg_is_bp_pos && (jbr_reg_bp_addr === jbr_reg_cond_br_target)
  // )
  // val jbr_uncond_bp_success = jbr_bp_en && jbr_reg_is_uncond_br && (
  //   jbr_reg_is_bp_pos && (jbr_reg_bp_addr === jbr_reg_uncond_br_target)
  // )
  // val jbr_j_success = jbr_bp_en && jbr_reg_is_j
  // jbr_reg_is_br_before_trap := jbr_cond_bp_success || jbr_uncond_bp_success || jbr_j_success
  // jbr_reg_trap_pc := MuxCase(DontCare, Seq(
  //   jbr_cond_bp_success   -> jbr_reg_cond_br_target,
  //   jbr_uncond_bp_success -> jbr_reg_uncond_br_target,
  //   jbr_j_success         -> jbr_reg_uncond_br_target,
  // ))

  //**********************************
  // EX1/EX2 register
  when (!ex2_stall) {
    // ex2_reg_en         := !ex2_reg_is_br // && !(ex1_reg_rf_wen === REN_S && ex1_reg_wb_sel === WB_ALU)
    ex2_reg_pc         := ex1_reg_pc
    ex2_reg_inst_cnt   := ex1_reg_inst_cnt
    ex2_reg_op1_data   := ex1_reg_op1_data
    ex2_reg_rs2_data   := ex1_reg_rs2_data
    ex2_reg_wb_addr    := ex1_reg_wb_addr
    ex2_reg_alu_out    := ex1_alu_out
    ex2_reg_mullu      := ex1_mullu
    ex2_reg_mulls      := ex1_mulls
    ex2_reg_mulhuu     := ex1_mulhuu
    ex2_reg_mulhss     := ex1_mulhss
    ex2_reg_mulhsu     := ex1_mulhsu
    ex2_reg_pc_bit_out := ex1_pc_bit_out
    ex2_reg_exe_fun    := ex1_reg_exe_fun
    ex2_reg_rf_wen     := ex1_reg_rf_wen
    ex2_reg_wb_sel     := ex1_reg_wb_sel
    ex2_reg_wdata      := (ex1_reg_rs2_data << (8.U * ex1_alu_out(1, 0)))(WORD_LEN-1, 0)
    ex2_reg_is_valid_inst := ex1_reg_is_valid_inst && !ex2_reg_is_br
    ex2_reg_is_trap    := ex1_reg_is_trap
    ex2_reg_mcause     := ex1_reg_mcause
    // ex2_reg_mtval      := ex1_reg_mtval
    ex2_reg_divrem            := ex1_divrem
    ex2_reg_div_stall         := ex2_div_stall_next ||
      (ex1_divrem && (ex2_reg_divrem_state === DivremState.Idle || ex2_reg_divrem_state === DivremState.Finished))
    ex2_reg_sign_op1          := ex1_sign_op1
    ex2_reg_sign_op12         := ex1_sign_op12
    ex2_reg_zero_op2          := ex1_zero_op2
    ex2_reg_init_dividend     := ex1_dividend
    ex2_reg_init_divisor      := ex1_divisor
    ex2_reg_orig_dividend     := ex1_orig_dividend
    ex2_reg_inst3_use_reg     := ex1_reg_inst3_use_reg
    ex2_reg_fw_en             := ex1_fw_en_next
    ex2_reg_csr_cmd           := ex1_reg_csr_cmd
    ex2_reg_csr_addr          := ex1_reg_csr_addr
  }.otherwise {
    ex2_reg_div_stall := ex2_div_stall_next ||
      (ex2_reg_divrem && (ex2_reg_divrem_state === DivremState.Idle || ex2_reg_divrem_state === DivremState.Finished))
  }

  // val ex2_is_valid_inst = ex2_reg_is_valid_inst && !ex2_reg_is_br
  // val ex2_en = ex2_reg_en && !ex2_reg_is_br
  // val ex2_rf_wen = Mux(ex2_is_valid_inst, ex2_reg_rf_wen, REN_X)
  // val ex2_wb_sel = Mux(ex2_is_valid_inst, ex2_reg_wb_sel, WB_X)
  // val ex2_stall_delay = RegInit(false.B)

  ex2_stall := mem_stall || ex2_reg_div_stall

  //**********************************
  // EX2 CSR Stage

  val csr_mie_fw_en = WireDefault(false.B)
  val csr_mie_meie_fw = WireDefault(false.B)
  val csr_mie_mtie_fw = WireDefault(false.B)
  val csr_mstatus_mie_fw_en = WireDefault(false.B)
  val csr_mstatus_mie_fw = WireDefault(false.B)
  val csr_reg_is_meintr = RegNext(
    ((csr_mstatus_mie_fw_en && csr_mstatus_mie_fw) || csr_reg_mstatus_mie) && io.intr && ((csr_mie_fw_en && csr_mie_meie_fw) || csr_reg_mie_meie)
  )
  val csr_reg_is_mtintr = RegNext(
    ((csr_mstatus_mie_fw_en && csr_mstatus_mie_fw) || csr_reg_mstatus_mie) && mtimer.io.intr && ((csr_mie_fw_en && csr_mie_mtie_fw) || csr_reg_mie_mtie)
  )

  val csr_is_valid_inst = ex2_reg_is_valid_inst && !ex2_reg_is_br
  val csr_is_meintr = csr_reg_is_meintr && csr_is_valid_inst
  val csr_is_mtintr = csr_reg_is_mtintr && csr_is_valid_inst
  val csr_is_trap = ex2_reg_is_trap && csr_is_valid_inst && !csr_is_meintr && !csr_is_mtintr
  ex2_en := csr_is_valid_inst && !csr_is_meintr && !csr_is_mtintr
  ex2_is_valid_inst := ex2_en && !csr_is_trap
  val csr_is_mret = csr_is_valid_inst && !csr_is_meintr && !csr_is_mtintr && (ex2_reg_exe_fun === CMD_MRET)

  val csr_rdata = MuxLookup(ex2_reg_csr_addr, 0.U(WORD_LEN.W), Seq(
    CSR_ADDR_MTVEC    -> csr_reg_trap_vector,
    CSR_ADDR_TIME     -> mtimer.io.mtime(31, 0),
    CSR_ADDR_CYCLE    -> cycle_counter.io.value(31, 0),
    CSR_ADDR_INSTRET  -> instret(31, 0),
    CSR_ADDR_CYCLEH   -> cycle_counter.io.value(63, 32),
    CSR_ADDR_TIMEH    -> mtimer.io.mtime(63, 32),
    CSR_ADDR_INSTRETH -> instret(63, 32),
    CSR_ADDR_MEPC     -> csr_reg_mepc,
    CSR_ADDR_MCAUSE   -> csr_reg_mcause,
    // CSR_ADDR_MTVAL   -> csr_mtval,
    CSR_ADDR_MSTATUS  -> Cat(0.U(24.W), csr_reg_mstatus_mpie.asUInt, 0.U(3.W), csr_reg_mstatus_mie.asUInt, 0.U(3.W)),
    CSR_ADDR_MSCRATCH -> csr_reg_mscratch,
    CSR_ADDR_MIE      -> Cat(0.U(20.W), csr_reg_mie_meie.asUInt, 0.U(3.W), csr_reg_mie_mtie.asUInt, 0.U(7.W)),
    CSR_ADDR_MIP      -> Cat(0.U(20.W), io.intr.asUInt, 0.U(3.W), mtimer.io.intr.asUInt, 0.U(7.W)),
  ))

  val csr_wdata = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex2_reg_csr_cmd === CSR_W) -> ex2_reg_op1_data,
    (ex2_reg_csr_cmd === CSR_S) -> (csr_rdata | ex2_reg_op1_data),
    (ex2_reg_csr_cmd === CSR_C) -> (csr_rdata & ~ex2_reg_op1_data),
  ))

  when (!ex2_reg_is_br && ex2_reg_wb_sel === WB_CSR) {
    when (ex2_reg_csr_addr === CSR_ADDR_MTVEC) {
      csr_reg_trap_vector := csr_wdata
    }.elsewhen (ex2_reg_csr_addr === CSR_ADDR_MEPC) {
      csr_reg_mepc := csr_wdata
    }.elsewhen (ex2_reg_csr_addr === CSR_ADDR_MSTATUS) {
      csr_reg_mstatus_mie   := csr_wdata(3)
      csr_reg_mstatus_mpie  := csr_wdata(7)
      csr_mstatus_mie_fw_en := true.B
      csr_mstatus_mie_fw    := csr_wdata(3)
    }.elsewhen (ex2_reg_csr_addr === CSR_ADDR_MSCRATCH) {
      csr_reg_mscratch := csr_wdata
    }.elsewhen (ex2_reg_csr_addr === CSR_ADDR_MIE) {
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
    csr_reg_mepc         := ex2_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_is_br            := true.B
    csr_br_addr          := csr_reg_trap_vector
  }.elsewhen (csr_is_mtintr) {
    csr_reg_mcause       := CSR_MCAUSE_MTI
    // csr_mtval         := 0.U(WORD_LEN.W)
    csr_reg_mepc         := ex2_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_is_br            := true.B
    csr_br_addr          := csr_reg_trap_vector
  }.elsewhen (csr_is_trap) {
    csr_reg_mcause       := ex2_reg_mcause
    // csr_mtval         := ex2_reg_mtval
    csr_reg_mepc         := ex2_reg_pc
    csr_reg_mstatus_mpie := csr_reg_mstatus_mie
    csr_reg_mstatus_mie  := false.B
    csr_is_br            := true.B
    csr_br_addr          := csr_reg_trap_vector
  }.elsewhen (csr_is_mret) {
    csr_reg_mstatus_mpie := true.B
    csr_reg_mstatus_mie  := csr_reg_mstatus_mpie
    csr_is_br            := true.B
    csr_br_addr          := csr_reg_mepc
  }.otherwise {
    csr_is_br            := false.B
    csr_br_addr          := DontCare
  }

  ex2_reg_is_br := csr_is_br || jbr_is_br

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
      (Fill(WORD_LEN*3/2 - w, value(w - 1)) ## value(w - 1, 0)).asSInt()
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

  /*
  val (q_input, q_output) = pla(Seq(
    // d: 0
    (BitPat("b0000000?"), BitPat("b00")),
    (BitPat("b0000001?"), BitPat("b01")),
    (BitPat("b0000010?"), BitPat("b01")),
    (BitPat("b0000011?"), BitPat("b1?")),
    (BitPat("b000010??"), BitPat("b1?")),
    (BitPat("b000011??"), BitPat("b??")),
    (BitPat("b0001????"), BitPat("b??")),
    // d: 1
    (BitPat("b0010000?"), BitPat("b00")),
    (BitPat("b0010001?"), BitPat("b01")),
    (BitPat("b0010010?"), BitPat("b01")),
    (BitPat("b00100110"), BitPat("b01")),
    (BitPat("b00100111"), BitPat("b1?")),
    (BitPat("b001010??"), BitPat("b1?")),
    (BitPat("b0010110?"), BitPat("b1?")),
    (BitPat("b0010111?"), BitPat("b??")),
    (BitPat("b0011????"), BitPat("b??")),
    // d: 2
    (BitPat("b0100000?"), BitPat("b00")),
    (BitPat("b0100001?"), BitPat("b01")),
    (BitPat("b010001??"), BitPat("b01")),
    (BitPat("b01001???"), BitPat("b1?")),
    (BitPat("b0101????"), BitPat("b??")),
    // d: 3
    (BitPat("b0110000?"), BitPat("b00")),
    (BitPat("b0110001?"), BitPat("b01")),
    (BitPat("b011001??"), BitPat("b01")),
    (BitPat("b01101???"), BitPat("b1?")),
    (BitPat("b0111????"), BitPat("b??")),
    // d: 4
    (BitPat("b100000??"), BitPat("b00")),
    (BitPat("b100001??"), BitPat("b01")),
    (BitPat("b1000100?"), BitPat("b01")),
    (BitPat("b1000101?"), BitPat("b1?")),
    (BitPat("b100011??"), BitPat("b1?")),
    (BitPat("b1001000?"), BitPat("b1?")),
    (BitPat("b1001001?"), BitPat("b??")),
    (BitPat("b100101??"), BitPat("b??")),
    (BitPat("b10011???"), BitPat("b??")),
    // d: 5
    (BitPat("b101000??"), BitPat("b00")),
    (BitPat("b101001??"), BitPat("b01")),
    (BitPat("b1010100?"), BitPat("b01")),
    (BitPat("b1010101?"), BitPat("b1?")),
    (BitPat("b101011??"), BitPat("b1?")),
    (BitPat("b101100??"), BitPat("b1?")),
    (BitPat("b101101??"), BitPat("b??")),
    (BitPat("b10111???"), BitPat("b??")),
    // d: 6
    (BitPat("b110000??"), BitPat("b00")),
    (BitPat("b110001??"), BitPat("b01")),
    (BitPat("b1100100?"), BitPat("b01")),
    (BitPat("b1100101?"), BitPat("b1?")),
    (BitPat("b110011??"), BitPat("b1?")),
    (BitPat("b110100??"), BitPat("b1?")),
    (BitPat("b110101??"), BitPat("b??")),
    (BitPat("b11011???"), BitPat("b??")),
    // d: 7
    (BitPat("b111000??"), BitPat("b00")),
    (BitPat("b111001??"), BitPat("b01")),
    (BitPat("b111010??"), BitPat("b01")),
    (BitPat("b111011??"), BitPat("b1?")),
    (BitPat("b111100??"), BitPat("b1?")),
    (BitPat("b1111010?"), BitPat("b1?")),
    (BitPat("b1111011?"), BitPat("b??")),
    (BitPat("b11111???"), BitPat("b??")),
  ))
  q_input := 0.U(8.W)
  */

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
      ex2_reg_dividend     := ex2_reg_init_dividend.asSInt()
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
      // q_input := Cat(ex2_reg_d, p)
      // val ex2_q = q_output
      val ex2_q = MuxLookup(ex2_reg_d, 0.U(2.W), Seq(
        0.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 1.U, 3.U  -> 1.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 2.U, 7.U  -> 2.U,
          8.U  -> 2.U, 9.U  -> 2.U, 10.U -> 2.U, 11.U -> 2.U,
        )),
        1.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 1.U, 3.U  -> 1.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 2.U,
          8.U  -> 2.U, 9.U  -> 2.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U,
        )),
        2.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 1.U, 3.U  -> 1.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 2.U, 9.U  -> 2.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
        )),
        3.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 1.U, 3.U  -> 1.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 2.U, 9.U  -> 2.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
        )),
        4.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 0.U, 3.U  -> 0.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 1.U, 9.U  -> 1.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
          16.U -> 2.U, 17.U -> 2.U,
        )),
        5.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 0.U, 3.U  -> 0.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 1.U, 9.U  -> 1.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
          16.U -> 2.U, 17.U -> 2.U, 18.U -> 2.U, 19.U -> 2.U,
        )),
        6.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 0.U, 3.U  -> 0.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 1.U, 9.U  -> 1.U, 10.U -> 2.U, 11.U -> 2.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
          16.U -> 2.U, 17.U -> 2.U, 18.U -> 2.U, 19.U -> 2.U,
        )),
        7.U -> MuxLookup(p, 0.U(2.W), Seq(
          0.U  -> 0.U, 1.U  -> 0.U, 2.U  -> 0.U, 3.U  -> 0.U,
          4.U  -> 1.U, 5.U  -> 1.U, 6.U  -> 1.U, 7.U  -> 1.U,
          8.U  -> 1.U, 9.U  -> 1.U, 10.U -> 1.U, 11.U -> 1.U,
          12.U -> 2.U, 13.U -> 2.U, 14.U -> 2.U, 15.U -> 2.U,
          16.U -> 2.U, 17.U -> 2.U, 18.U -> 2.U, 19.U -> 2.U,
          20.U -> 2.U, 21.U -> 2.U,
        )),
      ))
      when (ex2_reg_dividend(WORD_LEN+4) === 0.U) {
        ex2_reg_dividend := MuxCase(ex2_reg_dividend << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_dividend - Cat(0.U(1.W), ex2_reg_divisor).asSInt()) << 2),
          (ex2_q(1) === 1.U) -> ((ex2_reg_dividend - Cat(ex2_reg_divisor, 0.U(1.W)).asSInt()) << 2),
        ))
        ex2_reg_quotient := MuxCase(ex2_reg_quotient << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_quotient << 2) + 1.U),
          (ex2_q(1) === 1.U) -> ((ex2_reg_quotient << 2) + 2.U),
        ))
      }.otherwise {
        ex2_reg_dividend := MuxCase(ex2_reg_dividend << 2, Seq(
          (ex2_q(0) === 1.U) -> ((ex2_reg_dividend + Cat(0.U(1.W), ex2_reg_divisor).asSInt()) << 2),
          (ex2_q(1) === 1.U) -> ((ex2_reg_dividend + Cat(ex2_reg_divisor, 0.U(1.W)).asSInt()) << 2),
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
  // printf(p"ex2_reg_divrem_state : 0x${Hexadecimal(ex2_reg_divrem_state.asUInt())}\n")
  // printf(p"ex2_reg_dividend     : 0x${Hexadecimal(ex2_reg_dividend)}\n")
  // printf(p"ex2_reg_divisor      : 0x${Hexadecimal(ex2_reg_divisor)}\n")
  // printf(p"ex2_reg_divrem_count : 0x${Hexadecimal(ex2_reg_divrem_count)}\n")
  // printf(p"ex2_reg_rem_shift    : 0x${Hexadecimal(ex2_reg_rem_shift)}\n")

  //**********************************
  // EX2 Stage
  ex2_wb_data := MuxCase(ex2_reg_alu_out, Seq(
    (
      (ex2_reg_wb_sel === WB_PC) ||
      (ex2_reg_wb_sel === WB_BIT)
    ) -> ex2_reg_pc_bit_out,
    (
      (ex2_reg_wb_sel === WB_CSR) ||
      (ex2_reg_wb_sel === WB_FENCE) // dummy for optimization
    ) -> csr_rdata,
    (ex2_reg_wb_sel === WB_MD) -> ex2_alu_muldiv_out,
  ))

  ex2_fw_data := Mux(
    (
      (ex2_reg_wb_sel === WB_PC) ||
      (ex2_reg_wb_sel === WB_BIT)
    ),
    ex2_reg_pc_bit_out,
    ex2_reg_alu_out,
  )
  when (ex2_reg_inst3_use_reg && !ex2_reg_div_stall) {
    scoreboard(ex2_reg_wb_addr) := false.B
  }

  ex2_reg_is_retired := ex2_is_valid_inst && !ex2_stall && (ex2_reg_wb_sel =/= WB_LD && ex2_reg_wb_sel =/= WB_ST)

  when (ex2_en && !ex2_stall && ex2_reg_rf_wen === REN_S && (ex2_reg_wb_sel =/= WB_LD && ex2_reg_wb_sel =/= WB_ST)) {
    regfile(ex2_reg_wb_addr) := ex2_wb_data
  }

  //**********************************
  // EX1/MEM1 register
  val dram_addr_bits: Int = log2Ceil(dram_length)

  when (!ex2_stall) {
    mem1_reg_mem_wstrb     := (MuxCase("b1111".U, Seq(
      (ex1_reg_mem_w === MW_B) -> "b0001".U,
      (ex1_reg_mem_w === MW_H) -> "b0011".U,
      //(ex1_reg_mem_w === MW_W) -> "b1111".U,
    )) << (ex1_alu_out(1, 0)))(3, 0)
    mem1_reg_mem_w         := ex1_reg_mem_w
    mem1_reg_mem_use_reg   := ex1_reg_mem_use_reg
    val mem1_is_dram       = ex1_alu_out(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
    mem1_reg_is_dram       := mem1_is_dram
    mem1_reg_is_mem_load   := !mem1_is_dram && (ex1_reg_wb_sel === WB_LD)
    mem1_reg_is_mem_store  := !mem1_is_dram && (ex1_reg_wb_sel === WB_ST)
    mem1_reg_is_dram_load  := mem1_is_dram && (ex1_reg_wb_sel === WB_LD)
    mem1_reg_is_dram_store := mem1_is_dram && (ex1_reg_wb_sel === WB_ST)
    mem1_reg_is_dram_fence := (ex1_reg_wb_sel === WB_FENCE)
    mem1_reg_is_valid_inst := (ex1_reg_wb_sel === WB_LD || ex1_reg_wb_sel === WB_ST || ex1_reg_wb_sel === WB_FENCE)
  }

  //**********************************
  // Memory Access Stage 1 (MEM1)

  val mem1_is_mem_load   = mem1_reg_is_mem_load && ex2_en
  val mem1_is_mem_store  = mem1_reg_is_mem_store && ex2_en
  val mem1_is_dram_load  = mem1_reg_is_dram_load && ex2_en
  val mem1_is_dram_store = mem1_reg_is_dram_store && ex2_en
  val mem1_is_dram_fence = mem1_reg_is_dram_fence && ex2_en
  val mem1_is_valid_inst = mem1_reg_is_valid_inst && ex2_en
  io.dmem.raddr := ex2_reg_alu_out
  io.dmem.waddr := ex2_reg_alu_out
  io.dmem.ren   := mem1_is_mem_load /*io.dmem.rready &&*/
  io.dmem.wen   := /*io.dmem.wready &&*/ mem1_is_mem_store
  io.dmem.wstrb := mem1_reg_mem_wstrb
  io.dmem.wdata := ex2_reg_wdata
  io.cache.raddr := ex2_reg_alu_out
  io.cache.waddr := ex2_reg_alu_out
  io.cache.ren   := mem1_is_dram_load
  io.cache.wen   := mem1_is_dram_store
  io.cache.wstrb := mem1_reg_mem_wstrb
  io.cache.wdata := ex2_reg_wdata
  io.cache.iinvalidate := mem1_is_dram_fence

  mem1_mem_stall_delay := mem1_is_mem_load && io.dmem.rvalid && !mem1_mem_stall // 読めた直後はストール
  mem1_mem_stall := (mem1_is_mem_load && (!io.dmem.rvalid || mem1_mem_stall_delay)) || (mem1_is_mem_store && !io.dmem.wready)
  mem1_dram_stall := false.B

  mem_stall := mem1_mem_stall || mem1_dram_stall || mem2_dram_stall

  mem1_dram_stall :=
    (mem1_is_dram_load && !io.cache.rready) ||
    (mem1_is_dram_store && !io.cache.wready) ||
    (mem1_is_dram_fence && io.cache.ibusy)

  //**********************************
  // MEM1/MEM2 regsiter
  when (!mem2_dram_stall) {
    mem2_reg_wb_byte_offset := ex2_reg_alu_out(1, 0)
    mem2_reg_mem_w          := mem1_reg_mem_w
    mem2_reg_dmem_rdata     := io.dmem.rdata
    mem2_reg_wb_addr        := ex2_reg_wb_addr
    mem2_reg_is_valid_load  := (!mem1_mem_stall && mem1_is_mem_load) || (!mem1_dram_stall && mem1_is_dram_load)
    mem2_reg_mem_use_reg    := !mem1_mem_stall && !mem1_dram_stall && mem1_reg_mem_use_reg
    mem2_reg_is_valid_inst  := !mem1_mem_stall && !mem1_dram_stall && mem1_is_valid_inst
    mem2_reg_is_dram_load   := !mem1_dram_stall && mem1_is_dram_load
  }

  //**********************************
  // Memory Access Stage 2 (MEM2)
  mem2_dram_stall := (mem2_reg_is_dram_load && !io.cache.rvalid)

  //**********************************
  // MEM2/MEM3 regsiter
  mem3_reg_wb_byte_offset := mem2_reg_wb_byte_offset
  mem3_reg_mem_w          := mem2_reg_mem_w
  mem3_reg_dmem_rdata     := Mux(mem2_reg_is_dram_load, io.cache.rdata, mem2_reg_dmem_rdata)
  mem3_reg_wb_addr        := mem2_reg_wb_addr
  mem3_reg_is_valid_load  := !mem2_dram_stall && mem2_reg_is_valid_load
  mem3_reg_mem_use_reg    := !mem2_dram_stall && mem2_reg_mem_use_reg
  mem3_reg_is_valid_inst  := !mem2_dram_stall && mem2_reg_is_valid_inst

  //**********************************
  // Memory Access Stage 3 (MEM3)
  def signExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, value(w - 1)) ## value(w - 1, 0)
  }
  def zeroExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, 0.U) ## value(w - 1, 0)
  }

  val mem3_wb_rdata = mem3_reg_dmem_rdata >> (8.U * mem3_reg_wb_byte_offset)
  val mem3_wb_data_load = MuxCase(mem3_wb_rdata, Seq(
    (mem3_reg_mem_w === MW_B)  -> signExtend(mem3_wb_rdata, 8),
    (mem3_reg_mem_w === MW_H)  -> signExtend(mem3_wb_rdata, 16),
    (mem3_reg_mem_w === MW_BU) -> zeroExtend(mem3_wb_rdata, 8),
    (mem3_reg_mem_w === MW_HU) -> zeroExtend(mem3_wb_rdata, 16),
  ))
  when (mem3_reg_is_valid_load) {
    regfile(mem3_reg_wb_addr) := mem3_wb_data_load
  }
  when (mem3_reg_mem_use_reg) {
    scoreboard(mem3_reg_wb_addr) := false.B
  }
  mem3_reg_is_retired := mem3_reg_is_valid_inst

  when (ex2_reg_is_retired && mem3_reg_is_retired) {
    instret := instret + 2.U
  }.elsewhen (ex2_reg_is_retired || mem3_reg_is_retired) {
    instret := instret + 1.U
  }

  // Debug signals
  io.debug_signal.cycle_counter       := cycle_counter.io.value(47, 0)
  // io.debug_signal.csr_rdata        := csr_rdata
  // io.debug_signal.ex2_reg_csr_addr := ex2_reg_csr_addr
  io.debug_signal.ex2_reg_pc          := ex2_reg_pc
  io.debug_signal.ex2_is_valid_inst   := ex2_is_valid_inst
  io.debug_signal.me_intr             := csr_is_meintr
  io.debug_signal.mt_intr             := csr_is_mtintr
  io.debug_signal.id_pc               := id_reg_pc
  io.debug_signal.id_inst             := id_inst

  //**********************************
  // IO & Debug
  io.gp := regfile(3)
  io.exit := ex1_reg_is_trap && (ex2_reg_mcause === CSR_MCAUSE_ECALL_M) && (regfile(17) === 93.U(WORD_LEN.W))

  //printf(p"if1_reg_pc       : 0x${Hexadecimal(if1_reg_pc)}\n")
  printf(p"if2_pc           : 0x${Hexadecimal(if2_pc)}\n")
  printf(p"if2_inst         : 0x${Hexadecimal(if2_inst)}\n")
  printf(p"if2_reg_is_bp_pos: 0x${Hexadecimal(if2_reg_is_bp_pos)}\n")
  printf(p"bp.io.lu.br_hit  : 0x${Hexadecimal(bp.io.lu.br_hit)}\n")
  printf(p"bp.io.lu.br_pos  : 0x${Hexadecimal(bp.io.lu.br_pos)}\n")
  printf(p"id_reg_pc        : 0x${Hexadecimal(id_reg_pc)}\n")
  printf(p"id_reg_inst      : 0x${Hexadecimal(id_reg_inst)}\n")
  // printf(p"id_reg_inst_cnt  : 0x${Hexadecimal(id_reg_inst_cnt)}\n")
  printf(p"id_stall         : 0x${Hexadecimal(id_stall)}\n")
  printf(p"id_inst          : 0x${Hexadecimal(id_inst)}\n")
  // printf(p"id_rs1_data      : 0x${Hexadecimal(id_rs1_data)}\n")
  // printf(p"id_rs2_data      : 0x${Hexadecimal(id_rs2_data)}\n")
  printf(p"id_wb_addr       : 0x${Hexadecimal(id_wb_addr)}\n")
  printf(p"rrd_reg_pc       : 0x${Hexadecimal(rrd_reg_pc)}\n")
  // printf(p"rrd_reg_inst_cnt : 0x${Hexadecimal(rrd_reg_inst_cnt)}\n")
  printf(p"rrd_reg_is_valid_: 0x${Hexadecimal(rrd_reg_is_valid_inst)}\n")
  printf(p"rrd_stall        : 0x${Hexadecimal(rrd_stall)}\n")
  // printf(p"rrd_reg_rs1_addr : 0x${Hexadecimal(rrd_reg_rs1_addr)}\n")
  // printf(p"rrd_reg_rs2_addr : 0x${Hexadecimal(rrd_reg_rs2_addr)}\n")
  printf(p"rrd_op1_data     : 0x${Hexadecimal(rrd_op1_data)}\n")
  printf(p"rrd_op2_data     : 0x${Hexadecimal(rrd_op2_data)}\n")
  printf(p"rrd_rs2_data     : 0x${Hexadecimal(rrd_rs2_data)}\n")
  // printf(p"rrd_reg_op1_sel  : 0x${Hexadecimal(rrd_reg_op1_sel)}\n")
  // printf(p"ex1_reg_fw_en    : 0x${Hexadecimal(ex1_reg_fw_en)}\n")
  // printf(p"rrd_reg_rs1_addr  : 0x${Hexadecimal(rrd_reg_rs1_addr)}\n")
  printf(p"ex1_fw_data      : 0x${Hexadecimal(ex1_fw_data)}\n")
  printf(p"ex1_reg_pc       : 0x${Hexadecimal(ex1_reg_pc)}\n")
  // printf(p"ex1_reg_inst_cnt : 0x${Hexadecimal(ex1_reg_inst_cnt)}\n")
  printf(p"ex1_reg_is_valid_: 0x${Hexadecimal(ex1_reg_is_valid_inst)}\n")
  printf(p"ex1_reg_op1_data : 0x${Hexadecimal(ex1_reg_op1_data)}\n")
  printf(p"ex1_reg_op2_data : 0x${Hexadecimal(ex1_reg_op2_data)}\n")
  printf(p"ex1_alu_out      : 0x${Hexadecimal(ex1_alu_out)}\n")
  printf(p"ex1_reg_exe_fun  : 0x${Hexadecimal(ex1_reg_exe_fun)}\n")
  printf(p"ex1_reg_wb_sel   : 0x${Hexadecimal(ex1_reg_wb_sel)}\n")
  printf(p"ex1_reg_wb_addr  : 0x${Hexadecimal(ex1_reg_wb_addr)}\n")
  printf(p"ex1_reg_is_bp_pos: 0x${Hexadecimal(ex1_reg_is_bp_pos)}\n")
  printf(p"ex1_reg_bp_addr  : 0x${Hexadecimal(ex1_reg_bp_addr)}\n")
  // printf(p"ex1_reg_is_d_jbr_: 0x${Hexadecimal(ex1_reg_is_direct_jbr_fail)}\n")
  printf(p"jbr_is_br        : 0x${jbr_is_br}\n")
  printf(p"ex2_reg_is_br    : 0x${ex2_reg_is_br}\n")
  printf(p"ex2_reg_br_addr  : 0x${Hexadecimal(ex2_reg_br_addr)}\n")
  printf(p"ex2_reg_pc       : 0x${Hexadecimal(ex2_reg_pc)}\n")
  // printf(p"ex2_reg_inst_cnt : 0x${Hexadecimal(ex2_reg_inst_cnt)}\n")
  printf(p"ex2_is_valid_inst: 0x${Hexadecimal(ex2_is_valid_inst)}\n")
  printf(p"ex2_stall        : 0x${Hexadecimal(ex2_stall)}\n")
  printf(p"ex2_wb_data      : 0x${Hexadecimal(ex2_wb_data)}\n")
  printf(p"ex2_alu_muldiv_ou: 0x${Hexadecimal(ex2_alu_muldiv_out)}\n")
  printf(p"ex2_reg_wb_addr  : 0x${Hexadecimal(ex2_reg_wb_addr)}\n")
  printf(p"ex2_reg_wdata    : 0x${Hexadecimal(ex2_reg_wdata)}\n")
  // printf(p"mem1_reg_mem_w    : 0x${Hexadecimal(mem1_reg_mem_w)}\n")
  printf(p"mem1_mem_stall   : 0x${Hexadecimal(mem1_mem_stall)}\n")
  printf(p"mem1_dram_stall  : 0x${Hexadecimal(mem1_dram_stall)}\n")
  printf(p"mem1_is_valid_ins: 0x${Hexadecimal(mem1_is_valid_inst)}\n")
  printf(p"mem2_dram_stall  : 0x${Hexadecimal(mem2_dram_stall)}\n")
  printf(p"mem2_reg_dmem_rda: 0x${Hexadecimal(mem2_reg_dmem_rdata)}\n")
  // printf(p"mem2_reg_mem_use_: 0x${Hexadecimal(mem2_reg_mem_use_reg)}\n")
  printf(p"mem2_reg_is_valid: 0x${Hexadecimal(mem2_reg_is_valid_inst)}\n")
  printf(p"mem3_wb_data_load: 0x${Hexadecimal(mem3_wb_data_load)}\n")
  printf(p"mem3_reg_is_valid: 0x${Hexadecimal(mem3_reg_is_valid_inst)}\n")
  // printf(p"mem3_reg_mem_use_: 0x${Hexadecimal(mem3_reg_mem_use_reg)}\n")
  printf(p"csr_is_meintr    : ${csr_is_meintr}\n")
  printf(p"csr_is_mtintr    : ${csr_is_mtintr}\n")
  // printf(p"csr_reg_mepc         : 0x${Hexadecimal(csr_reg_mepc)}\n")
  printf(p"csr_is_br        : ${csr_is_br}\n")
  // printf(p"csr_wdata        : 0x${Hexadecimal(csr_wdata)}\n")
  // printf(p"ex2_reg_csr_cmd  : 0x${Hexadecimal(ex2_reg_csr_cmd)}\n")
  printf(p"instret          : ${instret}\n")
  // printf(p"mem1_is_dram_fence: ${mem1_is_dram_fence}\n")
  // printf(p"io.cache.ibusy   : ${io.cache.ibusy}\n")
  printf(p"cycle_counter(${io.exit}) : ${io.debug_signal.cycle_counter}\n")
  printf("---------\n")
}
