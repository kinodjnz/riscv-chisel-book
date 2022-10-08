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
  val mem_reg_pc = Output(UInt(WORD_LEN.W))
  val mem_is_valid_inst = Output(Bool())
  val csr_rdata = Output(UInt(WORD_LEN.W))
  val mem_reg_csr_addr = Output(UInt(CSR_ADDR_LEN.W))
  val me_intr = Output(Bool())
  val cycle_counter = Output(UInt(64.W))
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
  val Dividing = Value
  val Finished = Value
}

class Core(startAddress: BigInt = 0, caribCount: BigInt = 10, bpTagInitPath: String = null) extends Module {
  val io = IO(
    new Bundle {
      val imem = Flipped(new ImemPortIo())
      val icache_control = Flipped(new ICacheControl())
      val dmem = Flipped(new DmemPortIo())
      val mtimer_mem = new DmemPortIo()
      val intr = Input(Bool())
      val gp   = Output(UInt(WORD_LEN.W))
      val exit = Output(Bool())
      val debug_signal = new CoreDebugSignals()
    }
  )

  val regfile = Mem(32, UInt(WORD_LEN.W))
  //val csr_regfile = Mem(4096, UInt(WORD_LEN.W)) 
  val csr_trap_vector = RegInit(0.U(WORD_LEN.W))
  val cycle_counter = Module(new LongCounter(8, 8)) // 64-bit cycle counter for CYCLE[H] CSR
  val mtimer = Module(new MachineTimer)
  val instret = RegInit(0.U(64.W))
  val csr_mcause   = RegInit(0.U(WORD_LEN.W))
  val csr_mtval    = RegInit(0.U(WORD_LEN.W))
  val csr_mepc     = RegInit(0.U(WORD_LEN.W))
  val csr_mstatus  = RegInit(0.U(WORD_LEN.W))
  val csr_mscratch = RegInit(0.U(WORD_LEN.W))
  val csr_mie      = RegInit(0.U(WORD_LEN.W))
  val csr_mip      = RegInit(0.U(WORD_LEN.W))

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
  val id_reg_is_trap        = RegInit(false.B)
  val id_reg_mcause         = RegInit(0.U(WORD_LEN.W))
  val id_reg_mtval          = RegInit(0.U(WORD_LEN.W))

  // ID/EX1 State
  val ex1_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex1_reg_op1_sel       = RegInit(0.U(OP1_LEN.W))
  val ex1_reg_op2_sel       = RegInit(0.U(OP2_LEN.W))
  val ex1_reg_rs1_addr      = RegInit(0.U(ADDR_LEN.W))
  val ex1_reg_rs2_addr      = RegInit(0.U(ADDR_LEN.W))
  val ex1_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_op2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_rs2_data      = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex1_reg_mem_wen       = RegInit(0.U(MEN_LEN.W))
  val ex1_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex1_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val ex1_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex1_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  //val ex1_reg_imm_i_sext    = RegInit(0.U(WORD_LEN.W))
  //val ex1_reg_imm_s_sext    = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_imm_b_sext    = RegInit(0.U(WORD_LEN.W))
  //val ex1_reg_imm_u_shifted = RegInit(0.U(WORD_LEN.W))
  //val ex1_reg_imm_z_uext    = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_mem_w         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_is_j           = RegInit(false.B)
  val ex1_reg_is_bp_pos      = RegInit(false.B)
  val ex1_reg_bp_addr        = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_is_half        = RegInit(false.B)
  val ex1_reg_is_valid_inst  = RegInit(false.B)
  val ex1_reg_is_trap        = RegInit(false.B)
  val ex1_reg_mcause         = RegInit(0.U(WORD_LEN.W))
  val ex1_reg_mtval          = RegInit(0.U(WORD_LEN.W))

  // EX1/EX2 State
  val ex2_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val ex2_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_op2_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_rs2_data      = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val ex2_reg_mem_wen       = RegInit(0.U(MEN_LEN.W))
  val ex2_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val ex2_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val ex2_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex2_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  val ex2_reg_imm_b_sext    = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_mem_w         = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_is_j          = RegInit(false.B)
  val ex2_reg_is_bp_pos     = RegInit(false.B)
  val ex2_reg_bp_addr       = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_is_half       = RegInit(false.B)
  val ex2_reg_is_valid_inst = RegInit(false.B)
  val ex2_reg_is_trap       = RegInit(false.B)
  val ex2_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  val ex2_reg_mtval         = RegInit(0.U(WORD_LEN.W))

  // EX2/EX3 State
  val ex3_reg_bp_en            = RegInit(false.B)
  val ex3_reg_pc               = RegInit(0.U(WORD_LEN.W))
  val ex3_reg_is_cond_br       = RegInit(false.B)
  val ex3_reg_is_cond_br_inst  = RegInit(false.B)
  val ex3_reg_is_uncond_br     = RegInit(false.B)
  val ex3_reg_cond_br_target   = RegInit(0.U(WORD_LEN.W))
  val ex3_reg_uncond_br_target = RegInit(0.U(WORD_LEN.W))
  val ex3_reg_is_j             = RegInit(false.B)
  val ex3_reg_is_bp_pos        = RegInit(false.B)
  val ex3_reg_bp_addr          = RegInit(0.U(WORD_LEN.W))
  val ex3_reg_is_half          = RegInit(false.B)

  // EX2/MEM State
  val mem_reg_en            = RegInit(false.B)
  val mem_reg_pc            = RegInit(0.U(WORD_LEN.W))
  val mem_reg_wb_addr       = RegInit(0.U(ADDR_LEN.W))
  val mem_reg_op1_data      = RegInit(0.U(WORD_LEN.W))
  val mem_reg_rs2_data      = RegInit(0.U(WORD_LEN.W))
  val mem_reg_mullu         = RegInit(0.U((WORD_LEN*3/2).W))
  val mem_reg_mulls         = RegInit(0.S((WORD_LEN*3/2).W))
  val mem_reg_mulhuu        = RegInit(0.U((WORD_LEN*3/2).W))
  val mem_reg_mulhss        = RegInit(0.S((WORD_LEN*3/2).W))
  val mem_reg_mulhsu        = RegInit(0.S((WORD_LEN*3/2).W))
  val mem_reg_exe_fun       = RegInit(0.U(EXE_FUN_LEN.W))
  val mem_reg_mem_wen       = RegInit(0.U(MEN_LEN.W))
  val mem_reg_rf_wen        = RegInit(0.U(REN_LEN.W))
  val mem_reg_wb_sel        = RegInit(0.U(WB_SEL_LEN.W))
  val mem_reg_csr_addr      = RegInit(0.U(CSR_ADDR_LEN.W))
  val mem_reg_csr_cmd       = RegInit(0.U(CSR_LEN.W))
  //val mem_reg_imm_z_uext    = RegInit(0.U(WORD_LEN.W))
  val mem_reg_alu_out       = RegInit(0.U(WORD_LEN.W))
  val mem_reg_alu_mulhsu_out  = RegInit(0.U(WORD_LEN.W))
  val mem_reg_mem_w         = RegInit(0.U(WORD_LEN.W))
  val mem_reg_mem_wstrb     = RegInit(0.U((WORD_LEN/8).W))
  val mem_reg_is_half       = RegInit(false.B)
  val mem_reg_is_valid_inst = RegInit(false.B)
  val mem_reg_is_trap       = RegInit(false.B)
  val mem_reg_mcause        = RegInit(0.U(WORD_LEN.W))
  val mem_reg_mtval         = RegInit(0.U(WORD_LEN.W))
  val mem_reminder              = Wire(UInt(WORD_LEN.W))
  val mem_quotient              = Wire(UInt(WORD_LEN.W))
  val mem_reg_divrem            = RegInit(false.B)
  val mem_reg_sign_op1          = RegInit(0.U(1.W))
  val mem_reg_sign_op12         = RegInit(0.U(1.W))
  val mem_reg_init_dividend     = RegInit(0.U((WORD_LEN*2).W))
  val mem_reg_init_divisor      = RegInit(0.U(WORD_LEN.W))

  // MEM/WB State
  val wb_reg_wb_addr        = RegInit(0.U(ADDR_LEN.W))
  val wb_reg_rf_wen         = RegInit(0.U(REN_LEN.W))
  val wb_reg_wb_data        = RegInit(0.U(WORD_LEN.W))
  val wb_reg_is_valid_inst  = RegInit(false.B)

  val if2_reg_is_bp_pos  = RegInit(false.B)
  val if2_reg_bp_addr    = RegInit(0.U(WORD_LEN.W))
  val id_stall           = Wire(Bool())
  val ex1_stall          = Wire(Bool())
  val mem_stall          = Wire(Bool())
  val mem_div_stall      = Wire(Bool())
  val ex3_reg_is_br      = RegInit(false.B)
  val ex3_reg_br_target  = RegInit(0.U(WORD_LEN.W))
  val ex3_reg_is_br_before_trap = RegInit(false.B)
  val ex3_reg_trap_pc    = RegInit(0.U(WORD_LEN.W))
  val mem_reg_is_br      = RegInit(false.B)
  val mem_reg_br_addr    = RegInit(0.U(WORD_LEN.W))

  //**********************************
  // Instruction Cache Controller

  val ic_addr_en      = Wire(Bool())
  val ic_addr         = Wire(UInt(WORD_LEN.W))
  val ic_read_en2     = Wire(Bool())
  val ic_read_en4     = Wire(Bool())
  val ic_reg_read_rdy = RegInit(false.B)
  val ic_reg_half_rdy = RegInit(false.B)
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
  }.elsewhen (ic_state =/= IcState.Full && ic_state =/= IcState.Full2Half && !io.imem.valid) {
    ic_reg_read_rdy := ic_reg_read_rdy
    ic_reg_half_rdy := ic_reg_half_rdy
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
    mem_reg_is_br           -> mem_reg_br_addr,
    ex3_reg_is_br           -> ex3_reg_br_target,
    if2_reg_is_bp_pos       -> if2_reg_bp_addr,
    if1_reg_first           -> startAddress.U,
  ))
  val if1_is_jump = mem_reg_is_br || ex3_reg_is_br || if2_reg_is_bp_pos || if1_reg_first

  ic_addr_en  := if1_is_jump
  ic_addr     := if1_jump_addr

  bp.io.lu.inst_pc := ic_addr_out

  //**********************************
  // IF1/IF2 Register

  //**********************************
  // Instruction Fetch (IF) 2 Stage

  val if2_reg_pc   = RegInit(startAddress.U(WORD_LEN.W))
  val if2_reg_inst = RegInit(0.U(WORD_LEN.W))

  val is_half_inst = (ic_data_out(1, 0) =/= 3.U)
  ic_read_en2 := !id_reg_stall && is_half_inst
  ic_read_en4 := !id_reg_stall && !is_half_inst
  val if2_pc = Mux(id_reg_stall || !(ic_reg_read_rdy || (ic_reg_half_rdy && is_half_inst)),
    if2_reg_pc,
    ic_reg_addr_out,
  )
  if2_reg_pc := if2_pc
  val if2_inst = MuxCase(BUBBLE, Seq(
	  // 優先順位重要！ジャンプ成立とストールが同時発生した場合、ジャンプ処理を優先
    ex3_reg_is_br     -> BUBBLE,
    mem_reg_is_br     -> BUBBLE,
    id_reg_stall      -> if2_reg_inst,
    if2_reg_is_bp_pos -> BUBBLE,
    ic_reg_read_rdy   -> ic_data_out,
    (ic_reg_half_rdy && is_half_inst) -> ic_data_out,
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
  val if2_is_bp_pos = Mux(id_reg_stall,
    if2_reg_is_bp_pos,
    (if2_is_bp_br && bp.io.lu.br_pos),
  )
  if2_reg_is_bp_pos := if2_is_bp_pos
  val if2_bp_addr = MuxCase(DontCare, Seq(
    id_reg_stall                         -> if2_reg_bp_addr,
    (if2_is_bp_br && bp.io.lu.br_pos)    -> bp.io.lu.br_addr,
  ))
  if2_reg_bp_addr := if2_bp_addr
  
  printf(p"ic_reg_addr_out: ${Hexadecimal(ic_reg_addr_out)}, ic_data_out: ${Hexadecimal(ic_data_out)}\n")
  printf(p"inst: ${Hexadecimal(if2_inst)}, ic_reg_read_rdy: ${ic_reg_read_rdy}, ic_state: ${ic_state.asUInt}\n")

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


  //**********************************
  // Instruction Decode (ID) Stage

  id_stall := ex1_stall || mem_stall
  id_reg_stall := id_stall

  // branch,jump時にIDをBUBBLE化
  val id_inst = Mux(mem_reg_is_br || ex3_reg_is_br, BUBBLE, id_reg_inst)

  val id_is_half = (id_inst(1, 0) =/= 3.U)

  val id_rs1_addr = id_inst(19, 15)
  val id_rs2_addr = id_inst(24, 20)
  val id_w_wb_addr  = id_inst(11, 7)

  val mem_wb_data = Wire(UInt(WORD_LEN.W))
  val id_rs1_data = MuxCase(regfile(id_rs1_addr), Seq(
    (id_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
  ))
  val id_rs2_data = MuxCase(regfile(id_rs2_addr), Seq(
    (id_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
  ))

  val id_c_rs1_addr  = id_inst(11, 7)
  val id_c_rs2_addr  = id_inst(6, 2)
  val id_c_wb_addr   = id_inst(11, 7)
  val id_c_rs1p_addr = Cat(1.U(2.W), id_inst(9, 7))
  val id_c_rs2p_addr = Cat(1.U(2.W), id_inst(4, 2))
  val id_c_wb1p_addr = Cat(1.U(2.W), id_inst(9, 7))
  val id_c_wb2p_addr = Cat(1.U(2.W), id_inst(4, 2))

  val id_c_rs1_data = MuxCase(regfile(id_c_rs1_addr), Seq(
    (id_c_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
  ))
  val id_c_rs2_data = MuxCase(regfile(id_c_rs2_addr), Seq(
    (id_c_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
  ))
  val id_c_rs1p_data = regfile(id_c_rs1p_addr)
  val id_c_rs2p_data = regfile(id_c_rs2p_addr)
  val id_sp_data = regfile(2.U(ADDR_LEN.W))

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
               List(ALU_X    , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
    Array(
      LB    -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, WBA_RD, CSR_X, MW_B),
      LBU   -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, WBA_RD, CSR_X, MW_BU),
      SB    -> List(ALU_ADD  , OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X  , WBA_RD, CSR_X, MW_B),
      LH    -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, WBA_RD, CSR_X, MW_H),
      LHU   -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, WBA_RD, CSR_X, MW_HU),
      SH    -> List(ALU_ADD  , OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X  , WBA_RD, CSR_X, MW_H),
      LW    -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, WBA_RD, CSR_X, MW_W),
      SW    -> List(ALU_ADD  , OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X  , WBA_RD, CSR_X, MW_W),
      ADD   -> List(ALU_ADD  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      ADDI  -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SUB   -> List(ALU_SUB  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      AND   -> List(ALU_AND  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      OR    -> List(ALU_OR   , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      XOR   -> List(ALU_XOR  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      ANDI  -> List(ALU_AND  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      ORI   -> List(ALU_OR   , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      XORI  -> List(ALU_XOR  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLL   -> List(ALU_SLL  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SRL   -> List(ALU_SRL  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SRA   -> List(ALU_SRA  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLLI  -> List(ALU_SLL  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SRLI  -> List(ALU_SRL  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SRAI  -> List(ALU_SRA  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLT   -> List(ALU_SLT  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLTU  -> List(ALU_SLTU , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLTI  -> List(ALU_SLT  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      SLTIU -> List(ALU_SLTU , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      BEQ   -> List(BR_BEQ   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      BNE   -> List(BR_BNE   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      BGE   -> List(BR_BGE   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      BGEU  -> List(BR_BGEU  , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      BLT   -> List(BR_BLT   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      BLTU  -> List(BR_BLTU  , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      JAL   -> List(ALU_ADD  , OP1_PC , OP2_IMJ, MEN_X, REN_S, WB_PC , WBA_RD, CSR_X, MW_X),
      JALR  -> List(ALU_JALR , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_PC , WBA_RD, CSR_X, MW_X),
      LUI   -> List(ALU_ADD  , OP1_X  , OP2_IMU, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      AUIPC -> List(ALU_ADD  , OP1_PC , OP2_IMU, MEN_X, REN_S, WB_ALU, WBA_RD, CSR_X, MW_X),
      CSRRW -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_W, MW_X),
      CSRRWI-> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_W, MW_X),
      CSRRS -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_S, MW_X),
      CSRRSI-> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_S, MW_X),
      CSRRC -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_C, MW_X),
      CSRRCI-> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, WBA_RD, CSR_C, MW_X),
      ECALL -> List(ALU_X    , OP1_X  , OP2_X  , MEN_X, REN_X, WB_X  , WBA_RD, CSR_E, MW_X),
      MRET  -> List(ALU_X    , OP1_X  , OP2_X  , MEN_X, REN_X, WB_X  , WBA_RD, CSR_R, MW_X),
      FENCE_I -> List(ALU_X  , OP1_X  , OP2_X  , MEN_FENCE, REN_X, WB_X  , WBA_RD, CSR_X, MW_X),
      MUL   -> List(ALU_MUL   , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      MULH  -> List(ALU_MULH  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      MULHU -> List(ALU_MULHU , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      MULHSU-> List(ALU_MULHSU, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      DIV   -> List(ALU_DIV   , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      DIVU  -> List(ALU_DIVU  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      REM   -> List(ALU_REM   , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      REMU  -> List(ALU_REMU  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_MD,  WBA_RD, CSR_X, MW_X),
      C_ILL      -> List(ALU_X    , OP1_C_RS1 , OP2_C_RS2  , MEN_X, REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_ADDI4SPN -> List(ALU_ADD  , OP1_C_SP  , OP2_C_IMIW , MEN_X, REN_S, WB_ALU, WBA_CP2, CSR_X, MW_X),
      C_ADDI16SP -> List(ALU_ADD  , OP1_C_RS1 , OP2_C_IMI16, MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_ADDI     -> List(ALU_ADD  , OP1_C_RS1 , OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_LW       -> List(ALU_ADD  , OP1_C_RS1P, OP2_C_IMLS , MEN_X, REN_S, WB_MEM, WBA_CP2, CSR_X, MW_W),
      C_SW       -> List(ALU_ADD  , OP1_C_RS1P, OP2_C_IMLS , MEN_S, REN_X, WB_X  , WBA_C  , CSR_X, MW_W),
      C_LI       -> List(ALU_ADD  , OP1_X     , OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_LUI      -> List(ALU_ADD  , OP1_X     , OP2_C_IMIU , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_SRAI     -> List(ALU_SRA  , OP1_C_RS1P, OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SRLI     -> List(ALU_SRL  , OP1_C_RS1P, OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_ANDI     -> List(ALU_AND  , OP1_C_RS1P, OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SUB      -> List(ALU_SUB  , OP1_C_RS1P, OP2_C_RS2P , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_XOR      -> List(ALU_XOR  , OP1_C_RS1P, OP2_C_RS2P , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_OR       -> List(ALU_OR   , OP1_C_RS1P, OP2_C_RS2P , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_AND      -> List(ALU_AND  , OP1_C_RS1P, OP2_C_RS2P , MEN_X, REN_S, WB_ALU, WBA_CP1, CSR_X, MW_X),
      C_SLLI     -> List(ALU_SLL  , OP1_C_RS1 , OP2_C_IMI  , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_J        -> List(ALU_ADD  , OP1_PC    , OP2_C_IMJ  , MEN_X, REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_BEQZ     -> List(BR_BEQ   , OP1_C_RS1P, OP2_Z      , MEN_X, REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_BNEZ     -> List(BR_BNE   , OP1_C_RS1P, OP2_Z      , MEN_X, REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_JR       -> List(ALU_JALR , OP1_C_RS1 , OP2_Z      , MEN_X, REN_X, WB_X  , WBA_C  , CSR_X, MW_X),
      C_JALR     -> List(ALU_JALR , OP1_C_RS1 , OP2_Z      , MEN_X, REN_S, WB_PC , WBA_RA , CSR_X, MW_X),
      C_JAL      -> List(ALU_ADD  , OP1_PC    , OP2_C_IMJ  , MEN_X, REN_S, WB_PC , WBA_RA , CSR_X, MW_X),
      C_LWSP     -> List(ALU_ADD  , OP1_C_SP  , OP2_C_IMSL , MEN_X, REN_S, WB_MEM, WBA_C  , CSR_X, MW_W),
      C_SWSP     -> List(ALU_ADD  , OP1_C_SP  , OP2_C_IMSS , MEN_S, REN_X, WB_X  , WBA_C  , CSR_X, MW_W),
      C_MV       -> List(ALU_ADD  , OP1_Z     , OP2_C_RS2  , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
      C_ADD      -> List(ALU_ADD  , OP1_C_RS1 , OP2_C_RS2  , MEN_X, REN_S, WB_ALU, WBA_C  , CSR_X, MW_X),
		)
	)
  val List(id_exe_fun, id_op1_sel, id_op2_sel, id_mem_wen, id_rf_wen, id_wb_sel, id_wba, id_csr_cmd, id_mem_w) = csignals

  val id_wb_addr = MuxCase(id_w_wb_addr, Seq(
    (id_wba === WBA_C)   -> id_c_wb_addr,
    (id_wba === WBA_CP1) -> id_c_wb1p_addr,
    (id_wba === WBA_CP2) -> id_c_wb2p_addr,
    (id_wba === WBA_RA)  -> 1.U(ADDR_LEN.W),
  ))

  val id_op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op1_sel === OP1_RS1)    -> id_rs1_data,
    (id_op1_sel === OP1_PC)     -> id_reg_pc,
    (id_op1_sel === OP1_IMZ)    -> id_imm_z_uext,
    (id_op1_sel === OP1_C_RS1)  -> id_c_rs1_data,
    (id_op1_sel === OP1_C_SP)   -> id_sp_data,
    (id_op1_sel === OP1_C_RS1P) -> id_c_rs1p_data,
  ))
  val id_op2_data = MuxCase(0.U(WORD_LEN.W), Seq(
    (id_op2_sel === OP2_RS2)     -> id_rs2_data,
    (id_op2_sel === OP2_IMI)     -> id_imm_i_sext,
    (id_op2_sel === OP2_IMS)     -> id_imm_s_sext,
    (id_op2_sel === OP2_IMJ)     -> id_imm_j_sext,
    (id_op2_sel === OP2_IMU)     -> id_imm_u_shifted,
    (id_op2_sel === OP2_C_RS2)   -> id_c_rs2_data,
    (id_op2_sel === OP2_C_RS2P)  -> id_c_rs2p_data,
    (id_op2_sel === OP2_C_IMIW)  -> id_c_imm_iw,
    (id_op2_sel === OP2_C_IMI16) -> id_c_imm_i16,
    (id_op2_sel === OP2_C_IMI)   -> id_c_imm_i,
    (id_op2_sel === OP2_C_IMLS)  -> id_c_imm_ls,
    (id_op2_sel === OP2_C_IMIU)  -> id_c_imm_iu,
    (id_op2_sel === OP2_C_IMJ)   -> id_c_imm_j,
    (id_op2_sel === OP2_C_IMSL)  -> id_c_imm_sl,
    (id_op2_sel === OP2_C_IMSS)  -> id_c_imm_ss,
  ))

  val id_csr_addr = Mux(id_csr_cmd === CSR_E, CSR_ADDR_MCAUSE, id_inst(31,20))

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
  val id_m_rs2_data = MuxCase(id_rs2_data, Seq(
    (id_op2_sel === OP2_C_IMLS) -> id_c_rs2p_data,
    (id_op2_sel === OP2_C_IMSS) -> id_c_rs2_data,
  ))
  val id_m_imm_b_sext = MuxCase(id_imm_b_sext, Seq(
    (id_wba === WBA_C) -> id_c_imm_b,
  ))

  val id_is_j = (id_op2_sel === OP2_IMJ) || (id_op2_sel === OP2_C_IMJ)
  val id_is_trap = (id_csr_cmd === CSR_E)
  val id_mcause = CSR_MCAUSE_ECALL_M
  val id_mtval = 0.U(WORD_LEN.W)

  val id_reg_pc_delay         = RegInit(0.U(WORD_LEN.W))
  val id_reg_wb_addr_delay    = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_sel_delay    = RegInit(0.U(OP1_LEN.W))
  val id_reg_op2_sel_delay    = RegInit(0.U(OP2_LEN.W))
  val id_reg_rs1_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_rs2_addr_delay   = RegInit(0.U(ADDR_LEN.W))
  val id_reg_op1_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_op2_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_rs2_data_delay   = RegInit(0.U(WORD_LEN.W))
  val id_reg_exe_fun_delay    = RegInit(0.U(EXE_FUN_LEN.W))
  val id_reg_mem_wen_delay    = RegInit(0.U(MEN_LEN.W))
  val id_reg_rf_wen_delay     = RegInit(0.U(REN_LEN.W))
  val id_reg_wb_sel_delay     = RegInit(0.U(WB_SEL_LEN.W))
  val id_reg_csr_addr_delay   = RegInit(0.U(CSR_ADDR_LEN.W))
  val id_reg_csr_cmd_delay    = RegInit(0.U(CSR_LEN.W))
  //val id_reg_imm_i_sext     = RegInit(0.U(WORD_LEN.W))
  //val id_reg_imm_s_sext     = RegInit(0.U(WORD_LEN.W))
  val id_reg_imm_b_sext_delay = RegInit(0.U(WORD_LEN.W))
  //val id_reg_imm_u_shifted  = RegInit(0.U(WORD_LEN.W))
  //val id_reg_imm_z_uext     = RegInit(0.U(WORD_LEN.W))
  val id_reg_mem_w_delay      = RegInit(0.U(WORD_LEN.W))
  val id_reg_is_j_delay       = RegInit(false.B)
  val id_reg_is_bp_pos_delay  = RegInit(false.B)
  val id_reg_bp_addr_delay    = RegInit(0.U(WORD_LEN.W))
  val id_reg_is_half_delay    = RegInit(false.B)
  val id_reg_is_valid_inst_delay = RegInit(false.B)
  val id_reg_is_trap_delay    = RegInit(false.B)
  val id_reg_mcause_delay     = RegInit(0.U(WORD_LEN.W))
  val id_reg_mtval_delay      = RegInit(0.U(WORD_LEN.W))

  when (mem_reg_is_br || ex3_reg_is_br) {
    when (!id_reg_stall) {
      id_reg_pc_delay          := id_reg_pc
    }
    id_reg_rf_wen_delay        := REN_X
    id_reg_exe_fun_delay       := ALU_ADD
    id_reg_wb_sel_delay        := WB_X
    id_reg_csr_cmd_delay       := CSR_X
    id_reg_mem_wen_delay       := MEN_X
    id_reg_mem_w_delay         := MW_X
    id_reg_is_j_delay          := false.B
    id_reg_is_bp_pos_delay     := false.B
    id_reg_is_valid_inst_delay := false.B
    id_reg_is_trap_delay       := false.B
  }.elsewhen (!id_reg_stall) {
    id_reg_pc_delay         := id_reg_pc
    id_reg_op1_sel_delay    := id_m_op1_sel
    id_reg_op2_sel_delay    := id_m_op2_sel
    id_reg_rs1_addr_delay   := id_m_rs1_addr
    id_reg_rs2_addr_delay   := id_m_rs2_addr
    id_reg_op1_data_delay   := id_op1_data
    id_reg_op2_data_delay   := id_op2_data
    id_reg_rs2_data_delay   := id_m_rs2_data
    id_reg_wb_addr_delay    := id_wb_addr
    id_reg_rf_wen_delay     := id_rf_wen
    id_reg_exe_fun_delay    := id_exe_fun
    id_reg_wb_sel_delay     := id_wb_sel
    //id_reg_imm_i_sext     := id_imm_i_sext
    //id_reg_imm_s_sext     := id_imm_s_sext
    id_reg_imm_b_sext_delay := id_m_imm_b_sext
    //id_reg_imm_u_shifted  := id_imm_u_shifted
    //id_reg_imm_z_uext     := id_imm_z_uext
    id_reg_csr_addr_delay   := id_csr_addr
    id_reg_csr_cmd_delay    := id_csr_cmd
    id_reg_mem_wen_delay    := id_mem_wen
    id_reg_mem_w_delay      := id_mem_w
    id_reg_is_j_delay       := id_is_j
    id_reg_is_bp_pos_delay  := id_reg_is_bp_pos
    id_reg_bp_addr_delay    := id_reg_bp_addr
    id_reg_is_half_delay    := id_is_half
    id_reg_is_valid_inst_delay := id_inst =/= BUBBLE
    id_reg_is_trap_delay    := id_is_trap
    id_reg_mcause_delay     := id_mcause
    id_reg_mtval_delay      := id_mtval
  }

  //**********************************
  // ID/EX1 register
  when (mem_reg_is_br || ex3_reg_is_br) {
    when(id_reg_stall) {
      ex1_reg_pc            := id_reg_pc_delay
      ex1_reg_op1_sel       := id_reg_op1_sel_delay
      ex1_reg_op2_sel       := id_reg_op2_sel_delay
      ex1_reg_rs1_addr      := id_reg_rs1_addr_delay
      ex1_reg_rs2_addr      := id_reg_rs2_addr_delay
      ex1_reg_op1_data      := id_reg_op1_data_delay
      ex1_reg_op2_data      := id_reg_op2_data_delay
      ex1_reg_rs2_data      := id_reg_rs2_data_delay
      ex1_reg_wb_addr       := id_reg_wb_addr_delay
      ex1_reg_rf_wen        := REN_X
      ex1_reg_exe_fun       := ALU_ADD
      ex1_reg_wb_sel        := WB_X
      ex1_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      ex1_reg_csr_addr      := id_reg_csr_addr_delay
      ex1_reg_csr_cmd       := CSR_X
      ex1_reg_mem_wen       := MEN_X
      ex1_reg_mem_w         := MW_X
      ex1_reg_is_j          := false.B
      ex1_reg_is_bp_pos     := false.B
      ex1_reg_bp_addr       := id_reg_bp_addr_delay
      ex1_reg_is_half       := id_reg_is_half_delay
      ex1_reg_is_valid_inst := false.B
      ex1_reg_is_trap       := false.B
      ex1_reg_mcause        := id_reg_mcause_delay
      ex1_reg_mtval         := id_reg_mtval_delay
    }.otherwise {
      ex1_reg_pc            := id_reg_pc
      ex1_reg_op1_sel       := id_m_op1_sel
      ex1_reg_op2_sel       := id_m_op2_sel
      ex1_reg_rs1_addr      := id_m_rs1_addr
      ex1_reg_rs2_addr      := id_m_rs2_addr
      ex1_reg_op1_data      := id_op1_data
      ex1_reg_op2_data      := id_op2_data
      ex1_reg_rs2_data      := id_m_rs2_data
      ex1_reg_wb_addr       := id_wb_addr
      ex1_reg_rf_wen        := REN_X
      ex1_reg_exe_fun       := ALU_ADD
      ex1_reg_wb_sel        := WB_X
      ex1_reg_imm_b_sext    := id_m_imm_b_sext
      ex1_reg_csr_addr      := id_csr_addr
      ex1_reg_csr_cmd       := CSR_X
      ex1_reg_mem_wen       := MEN_X
      ex1_reg_mem_w         := MW_X
      ex1_reg_is_j          := false.B
      ex1_reg_is_bp_pos     := false.B
      ex1_reg_bp_addr       := id_reg_bp_addr
      ex1_reg_is_half       := id_is_half
      ex1_reg_is_valid_inst := false.B
      ex1_reg_is_trap       := false.B
      ex1_reg_mcause        := id_mcause
      ex1_reg_mtval         := id_mtval
    }
  }.elsewhen(!ex1_stall && !mem_stall) {
  //when(!ex1_stall && !mem_stall) {
    when(id_reg_stall) {
      ex1_reg_pc            := id_reg_pc_delay
      ex1_reg_op1_sel       := id_reg_op1_sel_delay
      ex1_reg_op2_sel       := id_reg_op2_sel_delay
      ex1_reg_rs1_addr      := id_reg_rs1_addr_delay
      ex1_reg_rs2_addr      := id_reg_rs2_addr_delay
      ex1_reg_op1_data      := id_reg_op1_data_delay
      ex1_reg_op2_data      := id_reg_op2_data_delay
      ex1_reg_rs2_data      := id_reg_rs2_data_delay
      ex1_reg_wb_addr       := id_reg_wb_addr_delay
      ex1_reg_rf_wen        := id_reg_rf_wen_delay
      ex1_reg_exe_fun       := id_reg_exe_fun_delay
      ex1_reg_wb_sel        := id_reg_wb_sel_delay
      //ex1_reg_imm_i_sext    := id_imm_i_sext
      //ex1_reg_imm_s_sext    := id_imm_s_sext
      ex1_reg_imm_b_sext    := id_reg_imm_b_sext_delay
      //ex1_reg_imm_u_shifted := id_imm_u_shifted
      //ex1_reg_imm_z_uext    := id_imm_z_uext
      ex1_reg_csr_addr      := id_reg_csr_addr_delay
      ex1_reg_csr_cmd       := id_reg_csr_cmd_delay
      ex1_reg_mem_wen       := id_reg_mem_wen_delay
      ex1_reg_mem_w         := id_reg_mem_w_delay
      ex1_reg_is_j          := id_reg_is_j_delay
      ex1_reg_is_bp_pos     := id_reg_is_bp_pos_delay
      ex1_reg_bp_addr       := id_reg_bp_addr_delay
      ex1_reg_is_half       := id_reg_is_half_delay
      ex1_reg_is_valid_inst := id_reg_is_valid_inst_delay
      ex1_reg_is_trap       := id_reg_is_trap_delay
      ex1_reg_mcause        := id_reg_mcause_delay
      ex1_reg_mtval         := id_reg_mtval_delay
    }.otherwise {
      ex1_reg_pc            := id_reg_pc
      ex1_reg_op1_sel       := id_m_op1_sel
      ex1_reg_op2_sel       := id_m_op2_sel
      ex1_reg_rs1_addr      := id_m_rs1_addr
      ex1_reg_rs2_addr      := id_m_rs2_addr
      ex1_reg_op1_data      := id_op1_data
      ex1_reg_op2_data      := id_op2_data
      ex1_reg_rs2_data      := id_m_rs2_data
      ex1_reg_wb_addr       := id_wb_addr
      ex1_reg_rf_wen        := id_rf_wen
      ex1_reg_exe_fun       := id_exe_fun
      ex1_reg_wb_sel        := id_wb_sel
      //ex1_reg_imm_i_sext    := id_imm_i_sext
      //ex1_reg_imm_s_sext    := id_imm_s_sext
      ex1_reg_imm_b_sext    := id_m_imm_b_sext
      //ex1_reg_imm_u_shifted := id_imm_u_shifted
      //ex1_reg_imm_z_uext    := id_imm_z_uext
      ex1_reg_csr_addr      := id_csr_addr
      ex1_reg_csr_cmd       := id_csr_cmd
      ex1_reg_mem_wen       := id_mem_wen
      ex1_reg_mem_w         := id_mem_w
      ex1_reg_is_j          := id_is_j
      ex1_reg_is_bp_pos     := id_reg_is_bp_pos
      ex1_reg_bp_addr       := id_reg_bp_addr
      ex1_reg_is_half       := id_is_half
      ex1_reg_is_valid_inst := id_inst =/= BUBBLE
      ex1_reg_is_trap       := id_is_trap
      ex1_reg_mcause        := id_mcause
      ex1_reg_mtval         := id_mtval
    }
  }
  //**********************************
  // Execute (EX1) Stage

  val ex1_reg_fw_en         = RegInit(false.B)
  val ex1_reg_hazard        = RegInit(false.B)
  val ex1_fw_data           = Wire(UInt(WORD_LEN.W))
  val ex2_reg_fw_en         = RegInit(false.B)
  val ex2_reg_hazard        = RegInit(false.B)
  val ex2_reg_fw_data       = RegInit(0.U(WORD_LEN.W))
  val mem_reg_rf_wen_delay  = RegInit(0.U(REN_LEN.W))
  val mem_wb_addr_delay     = Wire(UInt(ADDR_LEN.W))
  val mem_reg_wb_data_delay = RegInit(0.U(WORD_LEN.W))
  val wb_reg_rf_wen_delay   = RegInit(0.U(REN_LEN.W))
  val wb_reg_wb_addr_delay  = RegInit(0.U(ADDR_LEN.W))
  val wb_reg_wb_data_delay  = RegInit(0.U(WORD_LEN.W))

  ex1_stall :=
    (ex1_reg_hazard &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === ex2_reg_wb_addr)) ||
    (ex2_reg_hazard &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === mem_reg_wb_addr)) ||
    (ex1_reg_hazard &&
     (ex1_reg_op2_sel === OP2_RS2 || ex1_reg_mem_wen === MEN_S) &&
     (ex1_reg_rs2_addr === ex2_reg_wb_addr)) ||
    (ex2_reg_hazard &&
     (ex1_reg_op2_sel === OP2_RS2 || ex1_reg_mem_wen === MEN_S) &&
     (ex1_reg_rs2_addr === mem_reg_wb_addr))

  val ex1_op1_data = MuxCase(ex1_reg_op1_data, Seq(
    (ex1_reg_op1_sel === OP1_RS1 && ex1_reg_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === ex2_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === mem_reg_wb_addr)) -> ex2_reg_fw_data,
    ((mem_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === mem_wb_addr_delay)) -> mem_reg_wb_data_delay,
    ((wb_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_op1_sel === OP1_RS1) &&
     (ex1_reg_rs1_addr === wb_reg_wb_addr_delay)) -> wb_reg_wb_data_delay,
    (ex1_reg_op1_sel === OP1_RS1) -> regfile(ex1_reg_rs1_addr),
  ))
  val ex1_op2_data = MuxCase(ex1_reg_op2_data, Seq(
    (ex1_reg_op2_sel === OP2_RS2 && ex1_reg_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (ex1_reg_op2_sel === OP2_RS2) &&
     (ex1_reg_rs2_addr === ex2_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (ex1_reg_op2_sel === OP2_RS2) &&
     (ex1_reg_rs2_addr === mem_reg_wb_addr)) -> ex2_reg_fw_data,
    ((mem_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_op2_sel === OP2_RS2) &&
     (ex1_reg_rs2_addr === mem_wb_addr_delay)) -> mem_reg_wb_data_delay,
    ((wb_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_op2_sel === OP2_RS2) &&
     (ex1_reg_rs2_addr === wb_reg_wb_addr_delay)) -> wb_reg_wb_data_delay,
    (ex1_reg_op2_sel === OP2_RS2) -> regfile(ex1_reg_rs2_addr),
  ))
  val ex1_rs2_data = MuxCase(regfile(ex1_reg_rs2_addr), Seq(
    (ex1_reg_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
    (ex1_reg_fw_en &&
     (ex1_reg_rs2_addr === ex2_reg_wb_addr)) -> ex1_fw_data,
    (ex2_reg_fw_en &&
     (ex1_reg_rs2_addr === mem_reg_wb_addr)) -> ex2_reg_fw_data,
    ((mem_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_rs2_addr === mem_wb_addr_delay)) -> mem_reg_wb_data_delay,
    ((wb_reg_rf_wen_delay === REN_S) &&
     (ex1_reg_rs2_addr === wb_reg_wb_addr_delay)) -> wb_reg_wb_data_delay,
  ))

  // when(ex1_stall || mem_stall) {
  //   ex1_reg_op1_data := ex1_op1_data
  //   ex1_reg_op2_data := ex1_op2_data
  //   ex1_reg_rs2_data := ex1_rs2_data
  // }

  when(!mem_stall) {
    val ex1_hazard = (ex1_reg_rf_wen === REN_S) && (ex1_reg_wb_addr =/= 0.U) && !mem_reg_is_br && !ex3_reg_is_br
    ex1_reg_fw_en := !ex1_stall && ex1_hazard && (ex1_reg_wb_sel =/= WB_MEM) && (ex1_reg_wb_sel =/= WB_CSR)
    ex1_reg_hazard := ex1_hazard && ((ex1_reg_wb_sel === WB_MEM) || (ex1_reg_wb_sel === WB_CSR) || (ex1_reg_wb_sel === WB_MD))
  }

  //**********************************
  // EX1/EX2 register
  when(!mem_stall) {
    val ex_is_bubble = ex1_stall || mem_reg_is_br || ex3_reg_is_br
    ex2_reg_pc            := ex1_reg_pc
    ex2_reg_op1_data      := ex1_op1_data
    ex2_reg_op2_data      := ex1_op2_data
    ex2_reg_rs2_data      := ex1_rs2_data
    ex2_reg_wb_addr       := ex1_reg_wb_addr
    ex2_reg_rf_wen        := Mux(ex_is_bubble, REN_X, ex1_reg_rf_wen)
    ex2_reg_exe_fun       := Mux(ex_is_bubble, ALU_ADD, ex1_reg_exe_fun)
    ex2_reg_wb_sel        := Mux(ex_is_bubble, WB_X, ex1_reg_wb_sel)
    ex2_reg_imm_b_sext    := ex1_reg_imm_b_sext
    ex2_reg_csr_addr      := ex1_reg_csr_addr
    ex2_reg_csr_cmd       := Mux(ex_is_bubble, CSR_X, ex1_reg_csr_cmd)
    ex2_reg_mem_wen       := Mux(ex_is_bubble, MEN_X, ex1_reg_mem_wen)
    ex2_reg_mem_w         := ex1_reg_mem_w
    ex2_reg_is_j          := ex1_reg_is_j
    ex2_reg_is_bp_pos     := ex1_reg_is_bp_pos
    ex2_reg_bp_addr       := ex1_reg_bp_addr
    ex2_reg_is_half       := ex1_reg_is_half
    ex2_reg_is_valid_inst := ex1_reg_is_valid_inst && !ex_is_bubble
    ex2_reg_is_trap       := Mux(ex_is_bubble, false.B, ex1_reg_is_trap)
    ex2_reg_mcause        := ex1_reg_mcause
    ex2_reg_mtval         := ex1_reg_mtval
  }

  //**********************************
  // Execute (EX2) Stage

  val ex2_alu_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (ex2_reg_exe_fun === ALU_ADD)   -> (ex2_reg_op1_data + ex2_reg_op2_data),
    (ex2_reg_exe_fun === ALU_SUB)   -> (ex2_reg_op1_data - ex2_reg_op2_data),
    (ex2_reg_exe_fun === ALU_AND)   -> (ex2_reg_op1_data & ex2_reg_op2_data),
    (ex2_reg_exe_fun === ALU_OR)    -> (ex2_reg_op1_data | ex2_reg_op2_data),
    (ex2_reg_exe_fun === ALU_XOR)   -> (ex2_reg_op1_data ^ ex2_reg_op2_data),
    (ex2_reg_exe_fun === ALU_SLL)   -> (ex2_reg_op1_data << ex2_reg_op2_data(4, 0))(31, 0),
    (ex2_reg_exe_fun === ALU_SRL)   -> (ex2_reg_op1_data >> ex2_reg_op2_data(4, 0)).asUInt(),
    (ex2_reg_exe_fun === ALU_SRA)   -> (ex2_reg_op1_data.asSInt() >> ex2_reg_op2_data(4, 0)).asUInt(),
    (ex2_reg_exe_fun === ALU_SLT)   -> (ex2_reg_op1_data.asSInt() < ex2_reg_op2_data.asSInt()).asUInt(),
    (ex2_reg_exe_fun === ALU_SLTU)  -> (ex2_reg_op1_data < ex2_reg_op2_data).asUInt(),
    (ex2_reg_exe_fun === ALU_JALR)  -> ((ex2_reg_op1_data + ex2_reg_op2_data) & ~1.U(WORD_LEN.W)),
    (ex2_reg_exe_fun === ALU_COPY1) -> ex2_reg_op1_data,
  ))

  val ex2_mullu  = (ex2_reg_op1_data * ex2_reg_op2_data(WORD_LEN/2-1, 0))
  val ex2_mulls  = (ex2_reg_op1_data.asSInt() * ex2_reg_op2_data(WORD_LEN/2-1, 0))
  val ex2_mulhuu = (ex2_reg_op1_data * ex2_reg_op2_data(WORD_LEN-1, WORD_LEN/2))
  val ex2_mulhss = (ex2_reg_op1_data.asSInt() * ex2_reg_op2_data(WORD_LEN-1, WORD_LEN/2).asSInt())
  val ex2_mulhsu = (ex2_reg_op1_data.asSInt() * ex2_reg_op2_data(WORD_LEN-1, WORD_LEN/2))

  val ex2_divrem = WireDefault(false.B)
  val ex2_sign_op1 = WireDefault(0.U(1.W))
  val ex2_sign_op12 = WireDefault(0.U(1.W))
  val ex2_dividend = WireDefault(0.U((WORD_LEN*2).W))
  val ex2_divisor = WireDefault(0.U(WORD_LEN.W))

  when (ex2_reg_exe_fun === ALU_DIV || ex2_reg_exe_fun === ALU_REM) {
    ex2_divrem := true.B
    when (ex2_reg_op1_data(WORD_LEN-1) === 1.U) {
      ex2_dividend := Cat(Fill(WORD_LEN, 0.U(1.W)), (~ex2_reg_op1_data + 1.U)(WORD_LEN-1, 0))
      ex2_sign_op1 := 1.U
    }.otherwise {
      ex2_dividend := Cat(Fill(WORD_LEN, 0.U(1.W)), ex2_reg_op1_data(WORD_LEN-1, 0))
      ex2_sign_op1 := 0.U
    }
    when (ex2_reg_op2_data(WORD_LEN-1) === 1.U) {
      ex2_divisor := (~ex2_reg_op2_data + 1.U)(WORD_LEN-1, 0)
      ex2_sign_op12 := (ex2_sign_op1 === 0.U) && (ex2_reg_op2_data =/= 0.U)
    }.otherwise {
      ex2_divisor := ex2_reg_op2_data
      ex2_sign_op12 := (ex2_sign_op1 === 1.U) && (ex2_reg_op2_data =/= 0.U)
    }
  }.elsewhen (ex2_reg_exe_fun === ALU_DIVU || ex2_reg_exe_fun === ALU_REMU) {
    ex2_divrem := true.B
    ex2_dividend := Cat(Fill(WORD_LEN, 0.U(1.W)), ex2_reg_op1_data(WORD_LEN-1, 0))
    ex2_sign_op1 := 0.U
    ex2_divisor := ex2_reg_op2_data
    ex2_sign_op12 := 0.U
  }

  // branch
  val ex2_is_cond_br = MuxCase(false.B, Seq(
    (ex2_reg_exe_fun === BR_BEQ)  ->  (ex2_reg_op1_data === ex2_reg_op2_data),
    (ex2_reg_exe_fun === BR_BNE)  -> !(ex2_reg_op1_data === ex2_reg_op2_data),
    (ex2_reg_exe_fun === BR_BLT)  ->  (ex2_reg_op1_data.asSInt() < ex2_reg_op2_data.asSInt()),
    (ex2_reg_exe_fun === BR_BGE)  -> !(ex2_reg_op1_data.asSInt() < ex2_reg_op2_data.asSInt()),
    (ex2_reg_exe_fun === BR_BLTU) ->  (ex2_reg_op1_data < ex2_reg_op2_data),
    (ex2_reg_exe_fun === BR_BGEU) -> !(ex2_reg_op1_data < ex2_reg_op2_data)
  ))
  val ex2_is_cond_br_inst = (
    (ex2_reg_exe_fun === BR_BEQ) ||
    (ex2_reg_exe_fun === BR_BNE) ||
    (ex2_reg_exe_fun === BR_BLT) ||
    (ex2_reg_exe_fun === BR_BGE) ||
    (ex2_reg_exe_fun === BR_BLTU) ||
    (ex2_reg_exe_fun === BR_BGEU)
  )
  val ex2_is_uncond_br = ex2_reg_exe_fun === ALU_JALR || ex2_reg_is_j
  val ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext
  val ex2_uncond_br_target = ex2_alu_out

  ex1_fw_data := MuxCase(ex2_alu_out, Seq(
    (ex2_reg_wb_sel === WB_PC) -> Mux(ex2_reg_is_half,
      ex2_reg_pc + 2.U(WORD_LEN.W),
      ex2_reg_pc + 4.U(WORD_LEN.W)
    ),
  ))
  ex2_reg_fw_data := ex1_fw_data
  when(!mem_stall) {
    val ex2_hazard = (ex2_reg_rf_wen === REN_S) && (ex2_reg_wb_addr =/= 0.U) && !mem_reg_is_br && !ex3_reg_is_br
    ex2_reg_fw_en := ex2_hazard && (ex2_reg_wb_sel =/= WB_MEM) && (ex2_reg_wb_sel =/= WB_CSR)
    ex2_reg_hazard := ex2_hazard && ((ex2_reg_wb_sel === WB_MEM) || (ex2_reg_wb_sel === WB_CSR) || (ex2_reg_wb_sel === WB_MD))
  }

  //**********************************
  // EX2/EX3 register
  // jump, br 命令ではストールは発生しないためストール時は単に更新しない
  when (!mem_stall) {
    ex3_reg_bp_en            := ex2_reg_is_valid_inst && !mem_reg_is_br && !ex3_reg_is_br
    ex3_reg_pc               := ex2_reg_pc
    ex3_reg_is_j             := ex2_reg_is_j
    ex3_reg_is_cond_br       := ex2_is_cond_br
    ex3_reg_is_cond_br_inst  := ex2_is_cond_br_inst
    ex3_reg_is_uncond_br     := ex2_is_uncond_br
    ex3_reg_cond_br_target   := ex2_cond_br_target
    ex3_reg_uncond_br_target := ex2_uncond_br_target
    ex3_reg_is_j             := ex2_reg_is_j
    ex3_reg_is_bp_pos        := ex2_reg_is_bp_pos
    ex3_reg_bp_addr          := ex2_reg_bp_addr
    ex3_reg_is_half          := ex2_reg_is_half
  }

  //**********************************
  // Execute (EX3) Stage

  val ex3_bp_en = ex3_reg_bp_en && !mem_reg_is_br && !ex3_reg_is_br
  val ex3_cond_bp_fail = ex3_bp_en && (
    (!ex3_reg_is_bp_pos && ex3_reg_is_cond_br) ||
    (ex3_reg_is_bp_pos && ex3_reg_is_cond_br && (ex3_reg_bp_addr =/= ex3_reg_cond_br_target))
  )
  val ex3_cond_nbp_fail = ex3_bp_en && ex3_reg_is_bp_pos && ex3_reg_is_cond_br_inst && !ex3_reg_is_cond_br
  val ex3_uncond_bp_fail = (ex3_bp_en && ex3_reg_is_uncond_br) && (
    !ex3_reg_is_bp_pos ||
    (ex3_reg_is_bp_pos && (ex3_reg_bp_addr =/= ex3_reg_uncond_br_target))
  )
  ex3_reg_br_target := MuxCase(DontCare, Seq(
    ex3_cond_bp_fail   -> ex3_reg_cond_br_target,
    ex3_cond_nbp_fail  -> Mux(ex3_reg_is_half, ex3_reg_pc + 2.U(WORD_LEN.W), ex3_reg_pc + 4.U(WORD_LEN.W)),
    ex3_uncond_bp_fail -> ex3_reg_uncond_br_target,
  ))
  ex3_reg_is_br := ex3_cond_bp_fail || ex3_cond_nbp_fail || ex3_uncond_bp_fail

  bp.io.up.update_en := ex3_bp_en && (ex3_reg_is_cond_br_inst || ex3_reg_is_uncond_br)
  bp.io.up.inst_pc := ex3_reg_pc
  bp.io.up.br_pos := ex3_reg_is_cond_br || ex3_reg_is_uncond_br
  bp.io.up.br_addr := MuxCase(DontCare, Seq(
    ex3_reg_is_cond_br   -> ex3_reg_cond_br_target,
    ex3_reg_is_uncond_br -> ex3_reg_uncond_br_target,
  ))

  val ex3_cond_bp_success = ex3_bp_en && ex3_reg_is_cond_br && (
    ex3_reg_is_bp_pos && (ex3_reg_bp_addr === ex3_reg_cond_br_target)
  )
  val ex3_uncond_bp_success = ex3_bp_en && ex3_reg_is_uncond_br && (
    ex3_reg_is_bp_pos && (ex3_reg_bp_addr === ex3_reg_uncond_br_target)
  )
  val ex3_j_success = ex3_bp_en && ex3_reg_is_j
  ex3_reg_is_br_before_trap := ex3_cond_bp_success || ex3_uncond_bp_success || ex3_j_success
  ex3_reg_trap_pc := MuxCase(DontCare, Seq(
    ex3_cond_bp_success   -> ex3_reg_cond_br_target,
    ex3_uncond_bp_success -> ex3_reg_uncond_br_target,
    ex3_j_success         -> ex3_reg_uncond_br_target,
  ))

  //**********************************
  // EX2/MEM register
  when( !mem_stall ) {  // MEMステージがストールしていない場合のみMEMのパイプラインレジスタを更新する。
    mem_reg_en         := !mem_reg_is_br && !ex3_reg_is_br
    mem_reg_pc         := ex2_reg_pc
    mem_reg_op1_data   := ex2_reg_op1_data
    mem_reg_rs2_data   := ex2_reg_rs2_data
    mem_reg_wb_addr    := ex2_reg_wb_addr
    mem_reg_alu_out    := ex2_alu_out
    mem_reg_mullu      := ex2_mullu
    mem_reg_mulls      := ex2_mulls
    mem_reg_mulhuu     := ex2_mulhuu
    mem_reg_mulhss     := ex2_mulhss
    mem_reg_mulhsu     := ex2_mulhsu
    mem_reg_exe_fun    := ex2_reg_exe_fun
    mem_reg_rf_wen     := ex2_reg_rf_wen
    mem_reg_wb_sel     := ex2_reg_wb_sel
    mem_reg_csr_addr   := ex2_reg_csr_addr
    mem_reg_csr_cmd    := ex2_reg_csr_cmd
    //mem_reg_imm_z_uext := ex2_reg_imm_z_uext
    mem_reg_mem_wen    := ex2_reg_mem_wen
    mem_reg_mem_w      := ex2_reg_mem_w
    mem_reg_mem_wstrb  := (MuxCase("b1111".U, Seq(
      (ex2_reg_mem_w === MW_B) -> "b0001".U,
      (ex2_reg_mem_w === MW_H) -> "b0011".U,
      (ex2_reg_mem_w === MW_W) -> "b1111".U,
    )) << (ex2_alu_out(1, 0)))(3, 0)
    mem_reg_is_half    := ex2_reg_is_half
    mem_reg_is_valid_inst := ex2_reg_is_valid_inst && !mem_reg_is_br && !ex3_reg_is_br
    mem_reg_is_trap    := ex2_reg_is_trap
    mem_reg_mcause     := ex2_reg_mcause
    mem_reg_mtval      := ex2_reg_mtval
    mem_reg_divrem            := ex2_divrem
    mem_reg_sign_op1          := ex2_sign_op1
    mem_reg_sign_op12         := ex2_sign_op12
    mem_reg_init_dividend     := ex2_dividend
    mem_reg_init_divisor      := ex2_divisor
  }

  //**********************************
  // Memory Access Stage

  val mem_is_valid_inst = mem_reg_is_valid_inst && (!mem_reg_is_br && !ex3_reg_is_br)
  val mem_is_meintr = csr_mstatus(3).asBool && (io.intr && csr_mie(11)) && mem_is_valid_inst
  val mem_is_mtintr = csr_mstatus(3).asBool && (mtimer.io.intr && csr_mie(7)) && mem_is_valid_inst
  val mem_is_trap = mem_reg_is_trap && mem_is_valid_inst && !mem_is_meintr && !mem_is_mtintr
  val mem_en = mem_reg_en && !mem_reg_is_br && !ex3_reg_is_br && !mem_reg_is_trap && !mem_is_meintr && !mem_is_mtintr
  val mem_rf_wen = Mux(mem_en, mem_reg_rf_wen, REN_X)
  val mem_wb_sel = Mux(mem_en, mem_reg_wb_sel, WB_X)
  val mem_csr_cmd = Mux(mem_en, mem_reg_csr_cmd, CSR_X)
  val mem_mem_wen = Mux(mem_en, mem_reg_mem_wen, MEN_X)
  val mem_stall_delay = RegInit(false.B)

  io.dmem.raddr := mem_reg_alu_out
  io.dmem.waddr := mem_reg_alu_out
  io.dmem.ren   := io.dmem.rready && (mem_wb_sel === WB_MEM)
  io.dmem.wen   := io.dmem.wready && (mem_mem_wen === MEN_S)
  io.dmem.wstrb := mem_reg_mem_wstrb
  io.dmem.wdata := (mem_reg_rs2_data << (8.U * mem_reg_alu_out(1, 0)))(WORD_LEN-1, 0)
  mem_stall := ((mem_wb_sel === WB_MEM) && (!io.dmem.rvalid || !io.dmem.rready || mem_stall_delay)) || ((mem_mem_wen === MEN_S) && !io.dmem.wready) || ((mem_mem_wen === MEN_FENCE) && io.icache_control.busy) || mem_div_stall
  mem_stall_delay := (mem_wb_sel === WB_MEM) && io.dmem.rvalid && !mem_stall // 読めた直後はストール

  // CSR
  val csr_rdata = MuxLookup(mem_reg_csr_addr, 0.U(WORD_LEN.W), Seq(
    CSR_ADDR_MTVEC    -> csr_trap_vector,
    CSR_ADDR_TIME     -> mtimer.io.mtime(31, 0),
    CSR_ADDR_CYCLE    -> cycle_counter.io.value(31, 0),
    CSR_ADDR_INSTRET  -> instret(31, 0),
    CSR_ADDR_CYCLEH   -> cycle_counter.io.value(63, 32),
    CSR_ADDR_TIMEH    -> mtimer.io.mtime(63, 32),
    CSR_ADDR_INSTRETH -> instret(63, 32),
    CSR_ADDR_MEPC     -> csr_mepc,
    CSR_ADDR_MCAUSE   -> csr_mcause,
    CSR_ADDR_MTVAL    -> csr_mtval,
    CSR_ADDR_MSTATUS  -> csr_mstatus,
    CSR_ADDR_MSCRATCH -> csr_mscratch,
    CSR_ADDR_MIE      -> csr_mie,
    CSR_ADDR_MIP      -> csr_mip,
  ))

  val csr_wdata = MuxCase(0.U(WORD_LEN.W), Seq(
    (mem_csr_cmd === CSR_W) -> mem_reg_op1_data,
    (mem_csr_cmd === CSR_S) -> (csr_rdata | mem_reg_op1_data),
    (mem_csr_cmd === CSR_C) -> (csr_rdata & ~mem_reg_op1_data),
  ))
  
  when (mem_csr_cmd === CSR_W || mem_csr_cmd === CSR_S || mem_csr_cmd === CSR_C) {
    when (mem_reg_csr_addr === CSR_ADDR_MTVEC) {
      csr_trap_vector := csr_wdata
    }.elsewhen (mem_reg_csr_addr === CSR_ADDR_MEPC) {
      csr_mepc := csr_wdata
    }.elsewhen (mem_reg_csr_addr === CSR_ADDR_MSTATUS) {
      csr_mstatus := csr_wdata
    }.elsewhen (mem_reg_csr_addr === CSR_ADDR_MSCRATCH) {
      csr_mscratch := csr_wdata
    }.elsewhen (mem_reg_csr_addr === CSR_ADDR_MIE) {
      csr_mie := csr_wdata
    }
  }

  csr_mip := Cat(csr_mip(31, 12), io.intr.asUInt, csr_mip(10, 8), mtimer.io.intr.asUInt, csr_mip(6, 0))

  when (mem_is_meintr) {
    csr_mcause      := CSR_MCAUSE_MEI
    csr_mtval       := 0.U(WORD_LEN.W)
    csr_mepc        := mem_reg_pc
    // csr_mepc        := MuxCase(mem_reg_pc, Seq(
    //   ex3_reg_is_br             -> ex3_reg_br_target,
    //   ex3_reg_is_br_before_trap -> ex3_reg_trap_pc,
    //   mem_reg_is_br             -> mem_reg_br_addr,
    // ))
    csr_mstatus     := Cat(csr_mstatus(31, 8), csr_mstatus(3), csr_mstatus(6, 4), 0.U(1.W), csr_mstatus(2, 0))
    mem_reg_is_br   := true.B
    mem_reg_br_addr := csr_trap_vector
  }.elsewhen (mem_is_mtintr) {
    csr_mcause      := CSR_MCAUSE_MTI
    csr_mtval       := 0.U(WORD_LEN.W)
    csr_mepc        := mem_reg_pc
    // csr_mepc        := MuxCase(mem_reg_pc, Seq(
    //   ex3_reg_is_br             -> ex3_reg_br_target,
    //   ex3_reg_is_br_before_trap -> ex3_reg_trap_pc,
    //   mem_reg_is_br             -> mem_reg_br_addr,
    // ))
    csr_mstatus     := Cat(csr_mstatus(31, 8), csr_mstatus(3), csr_mstatus(6, 4), 0.U(1.W), csr_mstatus(2, 0))
    mem_reg_is_br   := true.B
    mem_reg_br_addr := csr_trap_vector
  }.elsewhen (mem_is_trap) {
    csr_mcause      := mem_reg_mcause
    csr_mtval       := mem_reg_mtval
    csr_mepc        := mem_reg_pc
    // csr_mepc        := MuxCase(mem_reg_pc, Seq(
    //   ex3_reg_is_br             -> ex3_reg_br_target,
    //   ex3_reg_is_br_before_trap -> ex3_reg_trap_pc,
    //   mem_reg_is_br             -> mem_reg_br_addr,
    // ))
    csr_mstatus     := Cat(csr_mstatus(31, 8), csr_mstatus(3), csr_mstatus(6, 4), 0.U(1.W), csr_mstatus(2, 0))
    mem_reg_is_br   := true.B
    mem_reg_br_addr := csr_trap_vector
  }.elsewhen (mem_csr_cmd === CSR_R) {
    csr_mstatus     := Cat(csr_mstatus(31, 8), 1.U(1.W), csr_mstatus(6, 4), csr_mstatus(7), csr_mstatus(2, 0))
    mem_reg_is_br   := true.B
    mem_reg_br_addr := csr_mepc
  }.otherwise {
    mem_reg_is_br   := false.B
  }

  def signExtend48(value: UInt, w: Int): SInt = {
      (Fill(WORD_LEN*3/2 - w, value(w - 1)) ## value(w - 1, 0)).asSInt()
  }
  def zeroExtend48(value: UInt, w: Int) = {
      Fill(WORD_LEN*3/2 - w, 0.U) ## value(w - 1, 0)
  }

  val mem_alu_muldiv_out = MuxCase(0.U(WORD_LEN.W), Seq(
    (mem_reg_exe_fun === ALU_MUL)    -> (mem_reg_mullu(WORD_LEN-1, 0) + (mem_reg_mulhuu(WORD_LEN/2-1, 0) << (WORD_LEN/2))),
    (mem_reg_exe_fun === ALU_MULH)   -> (signExtend48(mem_reg_mulls(WORD_LEN*3/2-1, WORD_LEN/2), WORD_LEN) + mem_reg_mulhss)(WORD_LEN*3/2-1, WORD_LEN/2),
    (mem_reg_exe_fun === ALU_MULHU)  -> (zeroExtend48(mem_reg_mullu(WORD_LEN*3/2-1, WORD_LEN/2), WORD_LEN) + mem_reg_mulhuu)(WORD_LEN*3/2-1, WORD_LEN/2),
    (mem_reg_exe_fun === ALU_MULHSU) -> (signExtend48(mem_reg_mulls(WORD_LEN*3/2-1, WORD_LEN/2), WORD_LEN) + mem_reg_mulhsu)(WORD_LEN*3/2-1, WORD_LEN/2),
    (mem_reg_exe_fun === ALU_DIV)    -> mem_quotient,
    (mem_reg_exe_fun === ALU_DIVU)   -> mem_quotient,
    (mem_reg_exe_fun === ALU_REM)    -> mem_reminder,
    (mem_reg_exe_fun === ALU_REMU)   -> mem_reminder,
  ))

  val mem_reg_divrem_state = RegInit(DivremState.Idle)
  val mem_reg_dividend     = RegInit(0.U((WORD_LEN*2).W))
  val mem_reg_divisor      = RegInit(0.U(WORD_LEN.W))
  val mem_reg_divrem_count = RegInit(0.U(5.W))

  mem_quotient := DontCare
  mem_reminder := DontCare
  mem_div_stall := false.B

  switch (mem_reg_divrem_state) {
    is (DivremState.Idle) {
      when (mem_reg_divrem) {
        mem_reg_divrem_state := DivremState.Dividing
        mem_div_stall        := true.B
        mem_reg_dividend     := mem_reg_init_dividend
        mem_reg_divisor      := mem_reg_init_divisor
        mem_reg_divrem_count := 0.U // mem_reg_init_divrem_count
      }
    }
    is (DivremState.Dividing) {
      val reminder = Cat(mem_reg_dividend(WORD_LEN*2-1, WORD_LEN-1)) - Cat(0.U(1.W), mem_reg_divisor)
      when (reminder(WORD_LEN) === 0.U) {
        mem_reg_dividend := Cat(reminder(WORD_LEN-1, 0), mem_reg_dividend(WORD_LEN-2, 0), 1.U(1.W))
      }.otherwise {
        mem_reg_dividend := Cat(mem_reg_dividend(WORD_LEN*2-2, 0), 0.U(1.W))
      }
      mem_reg_divrem_count := mem_reg_divrem_count - 1.U
      when (mem_reg_divrem_count === 1.U) {
        mem_reg_divrem_state := DivremState.Finished
      }
      mem_div_stall := true.B
    }
    is (DivremState.Finished) {
      mem_reg_divrem_state := DivremState.Idle
      mem_reminder := Mux(mem_reg_sign_op1 === 0.U,
        mem_reg_dividend(2*WORD_LEN-1, WORD_LEN),
        ~mem_reg_dividend(2*WORD_LEN-1, WORD_LEN) + 1.U,
      )
      mem_quotient := Mux(mem_reg_sign_op12 === 0.U,
        mem_reg_dividend(WORD_LEN-1, 0),
        ~mem_reg_dividend(WORD_LEN-1, 0) + 1.U,
      )
    }
  }
  printf(p"mem_reg_divrem_state : 0x${Hexadecimal(mem_reg_divrem_state.asUInt())}\n")
  printf(p"mem_reg_dividend     : 0x${Hexadecimal(mem_reg_dividend)}\n")
  printf(p"mem_reg_divisor      : 0x${Hexadecimal(mem_reg_divisor)}\n")
  printf(p"mem_reg_divrem_count : 0x${Hexadecimal(mem_reg_divrem_count)}\n")

  io.icache_control.invalidate := (mem_mem_wen === MEN_FENCE)

  def signExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, value(w - 1)) ## value(w - 1, 0)
  }
  def zeroExtend(value: UInt, w: Int) = {
      Fill(WORD_LEN - w, 0.U) ## value(w - 1, 0)
  }
  
  val mem_wb_byte_offset = mem_reg_alu_out(1, 0)
  val mem_wb_rdata = io.dmem.rdata >> (8.U * mem_wb_byte_offset)
  val mem_wb_data_load = MuxCase(mem_wb_rdata, Seq(
    (mem_reg_mem_w === MW_B) -> signExtend(mem_wb_rdata, 8),
    (mem_reg_mem_w === MW_H) -> signExtend(mem_wb_rdata, 16),
    (mem_reg_mem_w === MW_BU) -> zeroExtend(mem_wb_rdata, 8),
    (mem_reg_mem_w === MW_HU) -> zeroExtend(mem_wb_rdata, 16),
  ))

  mem_wb_data := MuxCase(mem_reg_alu_out, Seq(
    (mem_reg_wb_sel === WB_MEM) -> mem_wb_data_load,
    (mem_reg_wb_sel === WB_PC)  -> Mux(mem_reg_is_half, mem_reg_pc + 2.U(WORD_LEN.W), mem_reg_pc + 4.U(WORD_LEN.W)),
    (mem_reg_wb_sel === WB_CSR) -> csr_rdata,
    (mem_reg_wb_sel === WB_MD) -> mem_alu_muldiv_out,
  ))

  mem_reg_rf_wen_delay  := mem_rf_wen
  mem_wb_addr_delay     := wb_reg_wb_addr
  //mem_reg_wb_data_delay := Mux(mem_reg_wb_sel === WB_MEM, mem_wb_data_load, mem_wb_data)
  mem_reg_wb_data_delay := mem_wb_data
  
  //**********************************
  // MEM/WB regsiter
  wb_reg_wb_addr := mem_reg_wb_addr
  wb_reg_rf_wen  := Mux(!mem_stall, mem_rf_wen, REN_X)
  wb_reg_wb_data := mem_wb_data 
  wb_reg_is_valid_inst := mem_is_valid_inst && !mem_stall && !mem_reg_is_trap && !mem_is_meintr && !mem_is_mtintr


  //**********************************
  // Writeback (WB) Stage

  when(wb_reg_rf_wen === REN_S) {
    regfile(wb_reg_wb_addr) := wb_reg_wb_data
  }

  wb_reg_rf_wen_delay  := wb_reg_rf_wen
  wb_reg_wb_addr_delay := wb_reg_wb_addr
  wb_reg_wb_data_delay := wb_reg_wb_data

  when (wb_reg_is_valid_inst) {
    instret := instret + 1.U
  }

  // Debug signals
  io.debug_signal.cycle_counter := cycle_counter.io.value
  io.debug_signal.csr_rdata := csr_rdata
  io.debug_signal.mem_reg_csr_addr := mem_reg_csr_addr
  io.debug_signal.mem_reg_pc := mem_reg_pc
  io.debug_signal.mem_is_valid_inst := mem_is_valid_inst
  io.debug_signal.me_intr := mem_is_meintr
  io.debug_signal.id_pc := id_reg_pc
  io.debug_signal.id_inst := id_inst

  //**********************************
  // IO & Debug
  io.gp := regfile(3)
  val do_exit = RegInit(false.B)
  val do_exit_delay = RegInit(false.B)
  do_exit := mem_reg_is_trap && (mem_reg_mcause === CSR_MCAUSE_ECALL_M) && (regfile(17) === 93.U(WORD_LEN.W))
  do_exit_delay := do_exit
  io.exit := do_exit_delay
  //printf(p"if1_reg_pc       : 0x${Hexadecimal(if1_reg_pc)}\n")
  printf(p"if2_pc           : 0x${Hexadecimal(if2_pc)}\n")
  printf(p"if2_inst         : 0x${Hexadecimal(if2_inst)}\n")
  printf(p"if2_reg_is_bp_pos: 0x${Hexadecimal(if2_reg_is_bp_pos)}\n")
  printf(p"bp.io.lu.br_hit  : 0x${Hexadecimal(bp.io.lu.br_hit)}\n")
  printf(p"bp.io.lu.br_pos  : 0x${Hexadecimal(bp.io.lu.br_pos)}\n")
  printf(p"id_reg_pc        : 0x${Hexadecimal(id_reg_pc)}\n")
  printf(p"id_reg_inst      : 0x${Hexadecimal(id_reg_inst)}\n")
  printf(p"id_stall         : 0x${Hexadecimal(id_stall)}\n")
  printf(p"id_inst          : 0x${Hexadecimal(id_inst)}\n")
  printf(p"id_rs1_data      : 0x${Hexadecimal(id_rs1_data)}\n")
  printf(p"id_rs2_data      : 0x${Hexadecimal(id_rs2_data)}\n")
  printf(p"id_wb_addr       : 0x${Hexadecimal(id_wb_addr)}\n")
  printf(p"ex1_reg_pc       : 0x${Hexadecimal(ex1_reg_pc)}\n")
  printf(p"ex1_reg_is_valid_: 0x${Hexadecimal(ex1_reg_is_valid_inst)}\n")
  printf(p"ex1_stall        : 0x${Hexadecimal(ex1_stall)}\n")
  printf(p"ex1_op1_data     : 0x${Hexadecimal(ex1_op1_data)}\n")
  printf(p"ex1_op2_data     : 0x${Hexadecimal(ex1_op2_data)}\n")
  // printf(p"ex1_reg_op1_sel   : 0x${Hexadecimal(ex1_reg_op1_sel)}\n")
  // printf(p"ex1_reg_rs1_addr  : 0x${Hexadecimal(ex1_reg_rs1_addr)}\n")
  printf(p"ex2_reg_pc       : 0x${Hexadecimal(ex2_reg_pc)}\n")
  printf(p"ex2_reg_is_valid_: 0x${Hexadecimal(ex2_reg_is_valid_inst)}\n")
  printf(p"ex2_reg_op1_data : 0x${Hexadecimal(ex2_reg_op1_data)}\n")
  printf(p"ex2_reg_op2_data : 0x${Hexadecimal(ex2_reg_op2_data)}\n")
  printf(p"ex2_alu_out      : 0x${Hexadecimal(ex2_alu_out)}\n")
  printf(p"ex2_reg_exe_fun  : 0x${Hexadecimal(ex2_reg_exe_fun)}\n")
  printf(p"ex2_reg_wb_sel   : 0x${Hexadecimal(ex2_reg_wb_sel)}\n")
  printf(p"ex2_reg_is_bp_pos : 0x${Hexadecimal(ex2_reg_is_bp_pos)}\n")
  printf(p"ex2_reg_bp_addr  : 0x${Hexadecimal(ex2_reg_bp_addr)}\n")
  printf(p"ex3_reg_pc       : 0x${Hexadecimal(ex3_reg_pc)}\n")
  printf(p"ex3_reg_is_br    : 0x${Hexadecimal(ex3_reg_is_br)}\n")
  printf(p"ex3_reg_br_target : 0x${Hexadecimal(ex3_reg_br_target)}\n")
  printf(p"mem_reg_pc       : 0x${Hexadecimal(mem_reg_pc)}\n")
  printf(p"mem_is_valid_inst: 0x${Hexadecimal(mem_is_valid_inst)}\n")
  printf(p"mem_stall        : 0x${Hexadecimal(mem_stall)}\n")
  printf(p"mem_wb_data      : 0x${Hexadecimal(mem_wb_data)}\n")
  printf(p"mem_alu_muldiv_ou: 0x${Hexadecimal(mem_alu_muldiv_out)}\n")
  printf(p"mem_reg_mem_w    : 0x${Hexadecimal(mem_reg_mem_w)}\n")
  printf(p"mem_reg_wb_addr  : 0x${Hexadecimal(mem_reg_wb_addr)}\n")
  printf(p"mem_is_meintr    : ${mem_is_meintr}\n")
  printf(p"mem_is_mtintr    : ${mem_is_mtintr}\n")
  printf(p"mem_reg_rf_wen_delay : 0x${Hexadecimal(mem_reg_rf_wen_delay)}\n")
  printf(p"mem_wb_addr_delay : 0x${Hexadecimal(mem_wb_addr_delay)}\n")
  printf(p"mem_reg_wb_data_delay : 0x${Hexadecimal(mem_reg_wb_data_delay)}\n")
  printf(p"wb_reg_wb_addr   : 0x${Hexadecimal(wb_reg_wb_addr)}\n")
  printf(p"wb_reg_is_valid_i: 0x${Hexadecimal(wb_reg_is_valid_inst)}\n")
  printf(p"wb_reg_wb_data   : 0x${Hexadecimal(wb_reg_wb_data)}\n")
  printf(p"instret          : ${instret}\n")
  printf(p"cycle_counter(${do_exit}) : ${io.debug_signal.cycle_counter}\n")
  printf("---------\n")
}