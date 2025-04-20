package fpga

import chisel3._
import chisel3.util._
import common.Instructions._
import common.Consts._
import common.OptionExtension._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.ChiselEnum

class BranchPrediction extends Bundle {
  val taken    = Bool()
  val attr     = UInt(BTB_ATTR_LEN.W)
  val is_ret   = Bool()
  val rasindex = UInt(RAS_INDEX_BITS.W)
  val target   = UInt(PC_LEN.W)
  val history  = UInt(PHT_HISTORY_BITS.W)
  val cnt      = UInt(2.W)
  val gcnt     = UInt(2.W)
}

class InstructionDecoderOutput(val enable_pipeline_probe: Boolean) extends Bundle {
  val pc            = UInt(PC_LEN.W)
  val wb_addr       = UInt(ADDR_LEN.W)
  val op1_sel       = UInt(M_OP1_LEN.W)
  val op2_sel       = UInt(M_OP2_LEN.W)
  val op3_sel       = UInt(M_OP3_LEN.W)
  val rs1_addr      = UInt(ADDR_LEN.W)
  val rs2_addr      = UInt(ADDR_LEN.W)
  val rs3_addr      = UInt(ADDR_LEN.W)
  // val op1_data      = UInt(WORD_LEN.W)
  val im1_data      = UInt(WORD_LEN.W)
  val im0_data      = UInt(12.W)
  val exe_fun       = UInt(EXE_FUN_LEN.W)
  val rf_wen        = UInt(REN_LEN.W)
  val wb_sel        = UInt(WB_SEL_LEN.W)
  // val csr_addr      = UInt(CSR_ADDR_LEN.W)
  val csr_cmd       = UInt(CSR_LEN.W)
  // val imm_b_sext    = UInt(WORD_LEN.W)
  val shamt         = UInt(2.W)
  val op2op         = UInt(OP2OP_LEN.W)
  val mem_w         = UInt(MW_LEN.W)
  val is_bflen      = Bool()
  val is_br         = Bool()
  val is_j          = Bool()
  val bp            = new BranchPrediction()
  val actual_attr   = UInt(BTB_ATTR_LEN.W)
  val actual_is_ret = Bool()
  val is_half       = Bool()
  val is_valid_inst = Bool()
  val is_trap       = Bool()
  val mcause_code   = UInt(CSR_MCAUSE_CODE_LEN.W)
  val inst_id       = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
}

class PipelineStageIO[+T <: Data](gen: T) extends Bundle {
  val ready = Input(Bool())
  val flush = Input(Bool())
  val bits  = Output(gen)
}

class InstructionFetcherOutput(val enable_pipeline_probe: Boolean) extends Bundle {
  val is_valid_inst = Bool()
  val inst          = UInt(WORD_LEN.W)
  val pc            = UInt(PC_LEN.W)
  val bp            = new BranchPrediction()
  val inst_id       = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
}

object InstructionDecoderInputIO {
  def apply(enable_pipeline_probe: Boolean): PipelineStageIO[InstructionFetcherOutput] =
    new PipelineStageIO(new InstructionFetcherOutput(enable_pipeline_probe))
}

object InstructionDecoderOutputIO {
  def apply(enable_pipeline_probe: Boolean): PipelineStageIO[InstructionDecoderOutput] =
    Flipped(new PipelineStageIO(new InstructionDecoderOutput(enable_pipeline_probe)))
}

class InstructionDecoderDebugSignals extends Bundle {
  val id_pc   = Output(UInt(WORD_LEN.W))
  val id_inst = Output(UInt(WORD_LEN.W))
}

class InstructionDecoderPipelineProbe(enable_pipeline_probe: Boolean) extends Bundle {
  val id_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
}

class InstructionDecoderIO(
  val enable_pipeline_probe: Boolean = false,
) extends Bundle {
  val in = Flipped(InstructionDecoderInputIO(enable_pipeline_probe))
  val out = Flipped(InstructionDecoderOutputIO(enable_pipeline_probe))
  val debug_signals = new InstructionDecoderDebugSignals()
  val pipeline_probe = new InstructionDecoderPipelineProbe(enable_pipeline_probe)
}

class InstructionDecoder(
  val enable_pipeline_probe: Boolean = false,
) extends Module {
  val io = IO(new InstructionDecoderIO(enable_pipeline_probe))

  val id_reg_is_valid_inst = RegInit(false.B)
  val id_reg_inst          = RegInit(BUBBLE)
  val id_reg_pc            = RegInit(0.U(PC_LEN.W))
  val id_reg_bp            = RegInit(0.U.asTypeOf(new BranchPrediction()))
  val id_reg_is_bp_fail    = RegInit(false.B)

  val id_output_queue = Module(new Queue(new InstructionDecoderOutput(enable_pipeline_probe), 1, pipe = false, flow = true))

  val id_in_ready = id_output_queue.io.enq.ready

  when (id_in_ready) {
    id_reg_pc := io.in.bits.pc
    id_reg_bp := io.in.bits.bp
  }
  when (io.in.flush || id_in_ready) {
    // 優先順位重要！ジャンプ成立とストールが同時発生した場合、ジャンプ処理を優先
    // ストールとBP同時の場合、BP発生源の命令を生かすためストール優先
    id_reg_is_valid_inst := io.in.bits.is_valid_inst
    id_reg_inst          := io.in.bits.inst
    id_reg_bp.taken      := io.in.bits.bp.taken
  }
  val id_inst_id = io.in.bits.inst_id

  io.in.ready := id_in_ready
  io.in.flush := io.out.flush

  io.debug_signals.id_pc   := Cat(id_reg_pc, 0.U((WORD_LEN-PC_LEN).W))
  io.debug_signals.id_inst := id_reg_inst

  val id_inst = id_reg_inst

  val id_is_half = (id_inst(1, 0) =/= 3.U)

  val id_rs1_addr = id_inst(19, 15)
  val id_rs2_addr = id_inst(24, 20)
  val id_rs3_addr = id_inst(31, 27)
  val id_w_wb_addr  = id_inst(11, 7)

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
  // val id_imm_z_uext = Cat(Fill(27, 0.U), id_imm_z)
  val id_imm_z_uext = Cat(Fill(7, 0.U), id_imm_z)

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

  val id_imm_bfi_c_len = MuxLookup(Cat(id_inst(26, 25), id_inst(14)), 0.U(5.W))(Seq(
    0.U(3.W) -> 0.U(5.W),
    1.U(3.W) -> 1.U(5.W),
    2.U(3.W) -> 2.U(5.W),
    3.U(3.W) -> 3.U(5.W),
    4.U(3.W) -> 4.U(5.W),
    5.U(3.W) -> 5.U(5.W),
    6.U(3.W) -> 6.U(5.W),
    7.U(3.W) -> 8.U(5.W),
  ))
  val id_imm_bfi_len = id_inst(31, 27)
  val id_imm_bfi_shamt = id_inst(24, 20)

  val id_imm_bfi   = Cat(Fill(1, 0.U), id_imm_bfi_len(4, 0),   0.U(1.W), id_imm_bfi_shamt(4, 0))
  val id_imm_bfi_c = Cat(Fill(1, 0.U), id_imm_bfi_c_len(4, 0), 0.U(1.W), id_imm_bfi_shamt(4, 0))

  val csignals = ListLookup(id_inst,
                    List(ALU_X     , OP1_X     , OP2_X       , OP3_X     , OPI_X, REN_X, WB_X    , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
    Array(
      LB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_B  , OP2OP_NOP),
      LBU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_BU , OP2OP_NOP),
      SB         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_RS2   , OPI_IMS     , REN_X, WB_ST   , WBA_RD , CSR_X, MW_B  , OP2OP_NOP),
      LH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_H  , OP2OP_NOP),
      LHU        -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_HU , OP2OP_NOP),
      SH         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_RS2   , OPI_IMS     , REN_X, WB_ST   , WBA_RD , CSR_X, MW_H  , OP2OP_NOP),
      LW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_LD   , WBA_RD , CSR_X, MW_W  , OP2OP_NOP),
      SW         -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_RS2   , OPI_IMS     , REN_X, WB_ST   , WBA_RD , CSR_X, MW_W  , OP2OP_NOP),
      ADD        -> List(ALU_ADD   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ADDI       -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SUB        -> List(ALU_SUB   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      AND        -> List(ALU_AND   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      OR         -> List(ALU_OR    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      XOR        -> List(ALU_XOR   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ANDI       -> List(ALU_AND   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ORI        -> List(ALU_OR    , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      XORI       -> List(ALU_XOR   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRL        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRA        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2     , OP3_MSB   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLLI       -> List(ALU_FSL   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRLI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SRAI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMM     , OP3_MSB   , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SLT        -> List(ALU_SLT   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SIGNED),
      SLTU       -> List(ALU_SLT   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_UNSIGNED),
      SLTI       -> List(ALU_SLT   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SIGNED),
      SLTIU      -> List(ALU_SLT   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_UNSIGNED),
      BEQ        -> List(BR_BEQ    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BNE        -> List(BR_BNE    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BGE        -> List(BR_BGE    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BGEU       -> List(BR_BGEU   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BLT        -> List(BR_BLT    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      BLTU       -> List(BR_BLTU   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOP),
      JAL        -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_IMJ     , REN_S, WB_PC   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      JALR       -> List(ALU_ADD   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_PC   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      LUI        -> List(ALU_ADD   , OP1_Z     , OP2_IMM     , OP3_X     , OPI_IMU     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      AUIPC      -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_IMU     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CSRRW      -> List(ALU_ADD   , OP1_RS1   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_W, MW_X  , OP2OP_NOP),
      CSRRWI     -> List(ALU_ADD   , OP1_IM0   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_W, MW_X  , OP2OP_NOP),
      CSRRS      -> List(ALU_ADD   , OP1_RS1   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_S, MW_X  , OP2OP_NOP),
      CSRRSI     -> List(ALU_ADD   , OP1_IM0   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_S, MW_X  , OP2OP_NOP),
      CSRRC      -> List(ALU_ADD   , OP1_RS1   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_C, MW_X  , OP2OP_NOP),
      CSRRCI     -> List(ALU_ADD   , OP1_IM0   , OP2_Z       , OP3_X     , OPI_IMZ     , REN_S, WB_CSR  , WBA_RD , CSR_C, MW_X  , OP2OP_NOP),
      ECALL      -> List(CMD_ECALL , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_X    , WBA_RD , CSR_X, MW_CSR, OP2OP_NOP),
      MRET       -> List(CMD_MRET  , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_X    , WBA_RD , CSR_X, MW_CSR, OP2OP_NOP),
      FENCE_I    -> List(ALU_X     , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_FENCE, WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MUL        -> List(ALU_MUL   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULH       -> List(ALU_MULH  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULHU      -> List(ALU_MULHU , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MULHSU     -> List(ALU_MULHSU, OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      DIV        -> List(ALU_DIV   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      DIVU       -> List(ALU_DIVU  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REM        -> List(ALU_REM   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REMU       -> List(ALU_REMU  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      MAX        -> List(ALU_MAX   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SIGNED),
      MAXU       -> List(ALU_MAX   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_UNSIGNED),
      MIN        -> List(ALU_MIN   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SIGNED),
      MINU       -> List(ALU_MIN   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_UNSIGNED),
      CLZ        -> List(ALU_CLZ   , OP1_RS1   , OP2_X       , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CTZ        -> List(ALU_CTZ   , OP1_RS1   , OP2_X       , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CPOP       -> List(ALU_CPOP  , OP1_RS1   , OP2_X       , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      REV8       -> List(ALU_REV8  , OP1_RS1   , OP2_X       , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SEXTB      -> List(ALU_SZEXT , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_EXTB    , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SEXT),
      SEXTH      -> List(ALU_SZEXT , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_EXTH    , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SEXT),
      ZEXTH      -> List(ALU_SZEXT , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_EXTH    , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ANDN       -> List(ALU_AND   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      ORN        -> List(ALU_OR    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      XNOR       -> List(ALU_XOR   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOT),
      ROL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2     , OP3_OP1   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      ROR        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2     , OP3_OP1   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      RORI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMM     , OP3_OP1   , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSCTH      -> List(ALU_BSCTH , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      SH_ADD     -> List(ALU_ADD   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_SHADD),
      BCLR       -> List(ALU_BCLR  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSET       -> List(ALU_BSET  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BINV       -> List(ALU_BINV  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEXT       -> List(ALU_BEXT  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BCLRI      -> List(ALU_BCLR  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSETI      -> List(ALU_BSET  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BINVI      -> List(ALU_BINV  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEXTI      -> List(ALU_BEXT  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      CMOV       -> List(ALU_CMOV  , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSL        -> List(ALU_FSL   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSR        -> List(ALU_FSR   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      FSRI       -> List(ALU_FSR   , OP1_RS1   , OP2_IMM     , OP3_RS3   , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFA        -> List(ALU_BFX   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFM        -> List(ALU_BFM   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_ZERO),
      BFP        -> List(ALU_BFP   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFF        -> List(ALU_BFP   , OP1_RS1   , OP2_RS2     , OP3_Z     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFX        -> List(ALU_BFX   , OP1_RS1   , OP2_RS2     , OP3_Z     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFS        -> List(ALU_BFX   , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_SEXT),
      BFAP       -> List(ALU_BFX   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFMP       -> List(ALU_BFM   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_ZERO),
      BFPP       -> List(ALU_BFP   , OP1_RS1   , OP2_RS2     , OP3_RS3   , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFAI       -> List(ALU_BFX   , OP1_RS1   , OP2_IMM     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFMI       -> List(ALU_BFM   , OP1_RS1   , OP2_IMM     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_ZERO),
      BFPI       -> List(ALU_BFP   , OP1_RS1   , OP2_IMM     , OP3_RS3   , OPI_BFIC    , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFFI       -> List(ALU_BFP   , OP1_RS1   , OP2_IMM     , OP3_Z     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFXI       -> List(ALU_BFX   , OP1_RS1   , OP2_IMM     , OP3_Z     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BFSI       -> List(ALU_BFX   , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_BFI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_SEXT),
      GORCI      -> List(ALU_GORC  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      C_ILL      -> List(ALU_X     , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_X    , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI4SPN -> List(ALU_ADD   , OP1_C_SP  , OP2_IMM     , OP3_X     , OPI_C_IMIW  , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI16SP -> List(ALU_ADD   , OP1_C_RS1 , OP2_IMM     , OP3_X     , OPI_C_IMI16 , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI     -> List(ALU_ADD   , OP1_C_RS1 , OP2_IMM     , OP3_X     , OPI_C_IMI   , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMLS  , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_W  , OP2OP_NOP),
      C_SW       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_C_RS2P, OPI_C_IMLS  , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_LI       -> List(ALU_ADD   , OP1_Z     , OP2_IMM     , OP3_X     , OPI_C_IMI   , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LUI      -> List(ALU_ADD   , OP1_Z     , OP2_IMM     , OP3_X     , OPI_C_IMIU  , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_SRAI     -> List(ALU_FSR   , OP1_C_RS1P, OP2_IMM     , OP3_MSB   , OPI_C_IMI   , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SRLI     -> List(ALU_FSR   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMI   , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_ANDI     -> List(ALU_AND   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMI   , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SUB      -> List(ALU_SUB   , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_XOR      -> List(ALU_XOR   , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_OR       -> List(ALU_OR    , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_AND      -> List(ALU_AND   , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SLLI     -> List(ALU_FSL   , OP1_C_RS1 , OP2_IMM     , OP3_X     , OPI_C_IMI   , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_J        -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_C_IMJ   , REN_X, WB_PC   , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_BEQZ     -> List(BR_BEQ    , OP1_C_RS1P, OP2_Z       , OP3_X     , OPI_C_IMB   , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOP),
      C_BNEZ     -> List(BR_BNE    , OP1_C_RS1P, OP2_Z       , OP3_X     , OPI_C_IMB   , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOP),
      C_JR       -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z       , OP3_X     , OPI_X       , REN_X, WB_PC   , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_JALR     -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z       , OP3_X     , OPI_X       , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_JAL      -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_C_IMJ   , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_LWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_IMM     , OP3_X     , OPI_C_IMSL  , REN_S, WB_LD   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_SWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_IMM     , OP3_C_RS2 , OPI_C_IMSS  , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_MV       -> List(ALU_ADD   , OP1_Z     , OP2_C_RS2   , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADD      -> List(ALU_ADD   , OP1_C_RS1 , OP2_C_RS2   , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_LB       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMLSB , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_B  , OP2OP_NOP),
      C_LBU      -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMLSB , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_BU , OP2OP_NOP),
      C_LH       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMLSH , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_H  , OP2OP_NOP),
      C_LHU      -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMLSH , REN_S, WB_LD   , WBA_CP2, CSR_X, MW_HU , OP2OP_NOP),
      C_SH       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_C_RS2P, OPI_C_IMLSH , REN_X, WB_ST   , WBA_C  , CSR_X, MW_H  , OP2OP_NOP),
      C_SW0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_Z     , OPI_C_IMSW0 , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_SB0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_Z     , OPI_C_IMSB0 , REN_X, WB_ST   , WBA_C  , CSR_X, MW_B  , OP2OP_NOP),
      C_SH0      -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_Z     , OPI_C_IMSH0 , REN_X, WB_ST   , WBA_C  , CSR_X, MW_H  , OP2OP_NOP),
      C_SB       -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_C_RS2P, OPI_C_IMLSB , REN_X, WB_ST   , WBA_C  , CSR_X, MW_B  , OP2OP_NOP),
      C_AUIPC    -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_C_IMU   , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_MUL      -> List(ALU_MUL   , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_X       , REN_S, WB_MD   , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_ZEXTB    -> List(ALU_SZEXT , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_EXTB    , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SEXTB    -> List(ALU_SZEXT , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_EXTB    , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_SEXT),
      C_ZEXTH    -> List(ALU_SZEXT , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_EXTH    , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_SEXTH    -> List(ALU_SZEXT , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_EXTH    , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_SEXT),
      C_NOT      -> List(ALU_XOR   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_IMALL1  , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_NEG      -> List(ALU_SUB   , OP1_Z     , OP2_C_RS1P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP1, CSR_X, MW_X  , OP2OP_NOP),
      C_BEQ      -> List(BR_BEQ    , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_C_IMB2  , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOP),
      C_BNE      -> List(BR_BNE    , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_C_IMB2  , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOP),
      C_ADDI2W   -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMA2W , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADD2     -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_RS3P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SEQZ     -> List(ALU_SLT   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_IM1     , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_UNSIGNED),
      C_SNEZ     -> List(ALU_SLT   , OP1_Z     , OP2_C_RS1P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_UNSIGNED),
      C_ADDI2B   -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMA2B , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SLT      -> List(ALU_SLT   , OP1_C_RS1P, OP2_C_RS3P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_SIGNED),
      C_SLTU     -> List(ALU_SLT   , OP1_C_RS1P, OP2_C_RS3P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_UNSIGNED),
		)
	)
  val List(id_exe_fun, id_op1_sel, id_op2_sel, id_op3_sel, id_opi_sel, id_rf_wen, id_wb_sel, id_wba, id_csr_cmd, id_mem_w, id_op2op) = csignals

  val id_wb_addr = MuxCase(id_w_wb_addr, Seq(
    (id_wba === WBA_C)   -> id_c_wb_addr,
    (id_wba === WBA_CP1) -> id_c_wb1p_addr,
    (id_wba === WBA_CP2) -> id_c_wb2p_addr,
    (id_wba === WBA_RA)  -> 1.U(ADDR_LEN.W),
  ))

  // val id_op1_data = Wire(UInt(WORD_LEN.W))
  // id_op1_data := MuxCase(DontCare, Seq(
  //   (id_op1_sel === OP1_PC)  -> Cat(id_reg_pc, 0.U((WORD_LEN-PC_LEN).W)),
  //   (id_op1_sel === OP1_IMZ) -> id_imm_z_uext,
  //   (id_op1_sel === OP1_Z)   -> 0.U(WORD_LEN.W),
  // ))
  val id_im1_data = Wire(UInt(WORD_LEN.W))
  id_im1_data := MuxCase(DontCare, Seq(
    // 32 bit imm
    (id_opi_sel === OPI_IMJ)     -> id_imm_j_sext,
    (id_opi_sel === OPI_IMU)     -> id_imm_u_shifted,
    (id_opi_sel === OPI_C_IMIU)  -> id_c_imm_iu,
    (id_opi_sel === OPI_C_IMU)   -> id_c_imm_u,
    (id_opi_sel === OPI_IMB)     -> id_imm_b_sext,
    (id_opi_sel === OPI_C_IMB)   -> id_c_imm_b,
    (id_opi_sel === OPI_C_IMB2)  -> id_c_imm_b2,
    // 12 bit signed imm
    (id_opi_sel === OPI_IMS)     -> id_imm_s_sext,
    (id_opi_sel === OPI_IMI)     -> id_imm_i_sext,
    (id_opi_sel === OPI_C_IMI16) -> id_c_imm_i16,
    (id_opi_sel === OPI_C_IMI)   -> id_c_imm_i,
    (id_opi_sel === OPI_C_IMJ)   -> id_c_imm_j,
    (id_opi_sel === OPI_IMALL1)  -> Fill(WORD_LEN, 1.U),
    (id_opi_sel === OPI_C_IMA2W) -> id_c_imm_a2w,
    (id_opi_sel === OPI_C_IMA2B) -> id_c_imm_a2b,
    // 12 bit imm
    (id_opi_sel === OPI_IMZ)     -> id_imm_i_sext,
    (id_opi_sel === OPI_C_IMIW)  -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMLS)  -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSL)  -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSS)  -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMLSB) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMLSH) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSW0) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSB0) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSH0) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_IM1)     -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_BFIC)    -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_BFI)     -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_EXTH)    -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_EXTB)    -> 0.U(WORD_LEN.W),
  ))
  val id_im0_data = Wire(UInt(12.W))
  id_im0_data := MuxCase(DontCare, Seq(
    // 32 bit imm
    (id_opi_sel === OPI_IMJ)     -> 0.U(12.W),
    (id_opi_sel === OPI_IMU)     -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMIU)  -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMU)   -> 0.U(12.W),
    (id_opi_sel === OPI_IMB)     -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMB)   -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMB2)  -> 0.U(12.W),
    // 12 bit signed imm
    (id_opi_sel === OPI_IMS)     -> 0.U(12.W),
    (id_opi_sel === OPI_IMI)     -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMI16) -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMI)   -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMJ)   -> 0.U(12.W),
    (id_opi_sel === OPI_IMALL1)  -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMA2W) -> 0.U(12.W),
    (id_opi_sel === OPI_C_IMA2B) -> 0.U(12.W),
    // 12 bit imm
    (id_opi_sel === OPI_IMZ)     -> id_imm_z_uext,
    (id_opi_sel === OPI_C_IMIW)  -> id_c_imm_iw,
    (id_opi_sel === OPI_C_IMLS)  -> id_c_imm_ls,
    (id_opi_sel === OPI_C_IMSL)  -> id_c_imm_sl,
    (id_opi_sel === OPI_C_IMSS)  -> id_c_imm_ss,
    (id_opi_sel === OPI_C_IMLSB) -> id_c_imm_lsb,
    (id_opi_sel === OPI_C_IMLSH) -> id_c_imm_lsh,
    (id_opi_sel === OPI_C_IMSW0) -> id_c_imm_sw0,
    (id_opi_sel === OPI_C_IMSB0) -> id_c_imm_sb0,
    (id_opi_sel === OPI_C_IMSH0) -> id_c_imm_sh0,
    (id_opi_sel === OPI_IM1)     -> 1.U(12.W),
    (id_opi_sel === OPI_BFIC)    -> id_imm_bfi_c,
    (id_opi_sel === OPI_BFI)     -> id_imm_bfi,
    (id_opi_sel === OPI_EXTH)    -> 0x400.U(12.W),
    (id_opi_sel === OPI_EXTB)    -> 0x200.U(12.W),
  ))

  val id_is_bflen = (id_op2_sel === OP2_RS2) && (id_opi_sel === OPI_BFIC || id_opi_sel === OPI_BFI)

  val id_m_op1_sel = MuxCase(M_OP1_Z, Seq(
    (id_op1_sel === OP1_RS1 && id_rs1_addr === 0.U(ADDR_LEN.W))
                                -> M_OP1_Z,
    (id_op1_sel === OP1_RS1)    -> M_OP1_RS,
    (id_op1_sel === OP1_C_RS1)  -> M_OP1_RS,
    (id_op1_sel === OP1_C_SP)   -> M_OP1_RS,
    (id_op1_sel === OP1_C_RS1P) -> M_OP1_RS,
    (id_op1_sel === OP1_PC)     -> M_OP1_PC,
    (id_op1_sel === OP1_IM0)    -> M_OP1_IM0,
  ))
  val id_m_op2_sel = MuxCase(M_OP2_Z, Seq(
    (id_op2_sel === OP2_RS2 && id_rs2_addr === 0.U(ADDR_LEN.W))
                                -> M_OP2_Z,
    (id_op2_sel === OP2_RS2)    -> M_OP2_RS,
    (id_op2_sel === OP2_C_RS2)  -> M_OP2_RS,
    (id_op2_sel === OP2_C_RS1P) -> M_OP2_RS,
    (id_op2_sel === OP2_C_RS2P) -> M_OP2_RS,
    (id_op2_sel === OP2_C_RS3P) -> M_OP2_RS,
    (id_op2_sel === OP2_IMM)    -> M_OP2_IMM,
  ))
  // val id_m_op2_sel = id_op2_sel(OP2_LEN - 1) && !(id_op2_sel === OP2_RS2 && id_rs2_addr === 0.U(ADDR_LEN.W))
  val id_m_op3_sel = MuxCase(M_OP3_Z, Seq(
    (id_op3_sel === OP3_Z)       -> M_OP3_Z,
    (id_op3_sel === OP3_MSB)     -> M_OP3_MSB,
    (id_op3_sel === OP3_OP1)     -> M_OP3_OP1,
    (id_op3_sel === OP3_RS2 && id_rs2_addr === 0.U(ADDR_LEN.W))
                                 -> M_OP3_Z,
    (id_op3_sel === OP3_RS2)     -> M_OP3_RS,
    (id_op3_sel === OP3_C_RS2)   -> M_OP3_RS,
    (id_op3_sel === OP3_C_RS2P)  -> M_OP3_RS,
    (id_op3_sel === OP3_RS3 && id_rs3_addr === 0.U(ADDR_LEN.W))
                                 -> M_OP3_Z,
    (id_op3_sel === OP3_RS3)     -> M_OP3_RS,
    // (id_op3_sel === OP3_RD)      -> M_OP3_RS,
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
    // (id_op3_sel === OP3_RD)     -> id_w_wb_addr,
  ))
  // val id_m_imm_b_sext = MuxCase(id_imm_b_sext, Seq(
  //   (id_wba === WBA_CBR) -> id_c_imm_b,
  //   (id_wba === WBA_CB2) -> id_c_imm_b2,
  // ))

  val id_is_br = (id_mem_w === MW_BR)
  val id_is_j = (id_wb_sel === WB_PC)
  val id_is_dj = (id_wb_sel === WB_PC) && (id_op1_sel === OP1_PC)
  val id_is_ret = (id_wb_sel === WB_PC) && (
    ((id_op1_sel === OP1_RS1)   && (id_rs1_addr === 1.U(ADDR_LEN.W))) ||
    ((id_op1_sel === OP1_C_RS1) && (id_c_rs1_addr === 1.U(ADDR_LEN.W)))
  )
  val id_is_dcall = id_is_dj && ((id_wba === WBA_RA) || ((id_wba === WBA_RD) && (id_w_wb_addr === 1.U(ADDR_LEN.W))))
  val id_actual_attr = MuxCase(BTB_ATTR_INVAL, Seq(
    (id_is_dcall) -> BTB_ATTR_DCALL,
    (id_is_dj)    -> BTB_ATTR_DJUMP,
    (id_is_br)    -> BTB_ATTR_BR,
  ))
  val id_actual_is_ret = id_is_ret

  val id_is_trap = (id_exe_fun === CMD_ECALL && id_mem_w === MW_CSR)
  val id_mcause_code = CSR_MCAUSE_CODE_ECALL_M
  // val id_mtval = 0.U(WORD_LEN.W)

  io.pipeline_probe.id_valid.foreach(_ := id_reg_is_valid_inst)
  map2(io.pipeline_probe.id_inst_id, id_inst_id)(_ := _)

  id_output_queue.io.enq.valid              := !io.out.flush
  id_output_queue.io.enq.bits.pc            := id_reg_pc
  id_output_queue.io.enq.bits.op1_sel       := id_m_op1_sel
  id_output_queue.io.enq.bits.op2_sel       := id_m_op2_sel
  id_output_queue.io.enq.bits.op3_sel       := id_m_op3_sel
  id_output_queue.io.enq.bits.rs1_addr      := id_m_rs1_addr
  id_output_queue.io.enq.bits.rs2_addr      := id_m_rs2_addr
  id_output_queue.io.enq.bits.rs3_addr      := id_m_rs3_addr
  // id_output_queue.io.enq.bits.op1_data      := id_op1_data
  id_output_queue.io.enq.bits.im1_data      := id_im1_data
  id_output_queue.io.enq.bits.im0_data      := id_im0_data
  id_output_queue.io.enq.bits.wb_addr       := id_wb_addr
  // id_output_queue.io.enq.bits.imm_b_sext    := id_m_imm_b_sext
  id_output_queue.io.enq.bits.shamt         := id_shamt
  id_output_queue.io.enq.bits.op2op         := id_op2op
  id_output_queue.io.enq.bits.is_bflen      := id_is_bflen
  // id_output_queue.io.enq.bits.csr_addr      := id_csr_addr
  id_output_queue.io.enq.bits.bp            := id_reg_bp
  id_output_queue.io.enq.bits.actual_attr   := id_actual_attr
  id_output_queue.io.enq.bits.actual_is_ret := id_actual_is_ret
  id_output_queue.io.enq.bits.is_half       := id_is_half
  id_output_queue.io.enq.bits.mcause_code   := id_mcause_code
  id_output_queue.io.enq.bits.rf_wen        := id_rf_wen
  id_output_queue.io.enq.bits.exe_fun       := id_exe_fun
  id_output_queue.io.enq.bits.wb_sel        := id_wb_sel
  id_output_queue.io.enq.bits.csr_cmd       := id_csr_cmd
  id_output_queue.io.enq.bits.mem_w         := id_mem_w
  id_output_queue.io.enq.bits.is_br         := id_is_br
  id_output_queue.io.enq.bits.is_j          := id_is_j
  id_output_queue.io.enq.bits.is_valid_inst := id_reg_is_valid_inst
  id_output_queue.io.enq.bits.is_trap       := id_is_trap
  map2(id_output_queue.io.enq.bits.inst_id, id_inst_id)(_ := _)

  id_output_queue.io.deq.ready := io.out.flush || io.out.ready

  io.out.bits.pc            := id_output_queue.io.deq.bits.pc
  io.out.bits.op1_sel       := id_output_queue.io.deq.bits.op1_sel
  io.out.bits.op2_sel       := id_output_queue.io.deq.bits.op2_sel
  io.out.bits.op3_sel       := id_output_queue.io.deq.bits.op3_sel
  io.out.bits.rs1_addr      := id_output_queue.io.deq.bits.rs1_addr
  io.out.bits.rs2_addr      := id_output_queue.io.deq.bits.rs2_addr
  io.out.bits.rs3_addr      := id_output_queue.io.deq.bits.rs3_addr
  // io.out.bits.op1_data      := id_output_queue.io.deq.bits.op1_data
  io.out.bits.im1_data      := id_output_queue.io.deq.bits.im1_data
  io.out.bits.im0_data      := id_output_queue.io.deq.bits.im0_data
  io.out.bits.wb_addr       := id_output_queue.io.deq.bits.wb_addr
  // io.out.bits.imm_b_sext    := id_output_queue.io.deq.bits.imm_b_sext
  io.out.bits.shamt         := id_output_queue.io.deq.bits.shamt
  io.out.bits.op2op         := id_output_queue.io.deq.bits.op2op
  io.out.bits.is_bflen      := id_output_queue.io.deq.bits.is_bflen
  // io.out.bits.csr_addr      := id_output_queue.io.deq.bits.csr_addr
  io.out.bits.bp            := id_output_queue.io.deq.bits.bp
  io.out.bits.actual_attr   := id_output_queue.io.deq.bits.actual_attr
  io.out.bits.actual_is_ret := id_output_queue.io.deq.bits.actual_is_ret
  io.out.bits.is_half       := id_output_queue.io.deq.bits.is_half
  io.out.bits.mcause_code   := id_output_queue.io.deq.bits.mcause_code
  io.out.bits.rf_wen        := id_output_queue.io.deq.bits.rf_wen
  io.out.bits.exe_fun       := id_output_queue.io.deq.bits.exe_fun
  io.out.bits.wb_sel        := id_output_queue.io.deq.bits.wb_sel
  io.out.bits.csr_cmd       := id_output_queue.io.deq.bits.csr_cmd
  io.out.bits.mem_w         := id_output_queue.io.deq.bits.mem_w
  io.out.bits.is_br         := id_output_queue.io.deq.bits.is_br
  io.out.bits.is_j          := id_output_queue.io.deq.bits.is_j
  io.out.bits.is_valid_inst := id_output_queue.io.deq.bits.is_valid_inst
  io.out.bits.is_trap       := id_output_queue.io.deq.bits.is_trap
  when (io.out.flush || !id_output_queue.io.deq.valid) {
    io.out.bits.rf_wen        := REN_X
    io.out.bits.exe_fun       := ALU_ADD
    io.out.bits.wb_sel        := WB_X
    io.out.bits.csr_cmd       := CSR_X
    io.out.bits.mem_w         := MW_X
    io.out.bits.is_br         := false.B
    io.out.bits.is_j          := false.B
    io.out.bits.bp.taken      := false.B
    io.out.bits.is_valid_inst := false.B
    io.out.bits.is_trap       := false.B
  }
  map2(io.out.bits.inst_id, id_output_queue.io.deq.bits.inst_id)(_ := _)
}
