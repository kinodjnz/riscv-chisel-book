package fpga

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.ChiselEnum
import chisel3.experimental.BundleLiterals._
import common.Instructions._
import common.Consts._
import common.UIntExtension._
import common.OptionExtension._

class BranchPrediction(redirect_buffer_size: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val redirected = Bool()
  val bpfailed   = Bool()
  val bp_entry   = new BranchPredictionEntry()
  val fp_ptr     = UInt(fp_ptr_len.W)
}

class InstructionQueueEntryInitial(redirect_buffer_size: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val pc      = UInt(PC_LEN.W)
  val bp      = new BranchPrediction(redirect_buffer_size)
  val inst_id = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
  val is_half = Bool()
}


class InstructionQueueEntryDecoded extends Bundle {
  val exe_sel  = UInt(EXE_SEL_LEN.W)
  val exe_fun  = UInt(EXE_FUN_LEN.W)
  val sop      = UInt(SOP_LEN.W)
  val op1_sel  = UInt(OP1_SEL_LEN.W)
  val op2_sel  = UInt(OP2_SEL_LEN.W)
  val op3_sel  = UInt(OP3_SEL_LEN.W)
  val rs1_addr = UInt(ADDR_LEN.W)
  val rs2_addr = UInt(ADDR_LEN.W)
  val rs3_addr = UInt(ADDR_LEN.W)
  val imm_data = UInt(IMM_DATA_LEN.W)
  val rf_wen   = UInt(REN_LEN.W)
  val wb_addr  = UInt(ADDR_LEN.W)
}

class InstructionDecoderOutput(redirect_buffer_size: Int, enable_pipeline_probe: Boolean) extends Bundle {
  val ready   = Input(Bool())
  val flush   = Input(Bool())
  val valid   = Output(Bool())
  val initial = Output(new InstructionQueueEntryInitial(redirect_buffer_size, enable_pipeline_probe))
  val decoded = Output(new InstructionQueueEntryDecoded)
  // val pc               = UInt(PC_LEN.W)
  // val wb_addr          = UInt(ADDR_LEN.W)
  // val op1_sel          = UInt(M_OP1_LEN.W)
  // val op2_sel          = UInt(M_OP2_LEN.W)
  // val op3_sel          = UInt(M_OP3_LEN.W)
  // val rs1_addr         = UInt(ADDR_LEN.W)
  // val rs2_addr         = UInt(ADDR_LEN.W)
  // val rs3_addr         = UInt(ADDR_LEN.W)
  // val im1_data         = UInt(WORD_LEN.W)
  // val im0_data         = UInt(12.W)
  // val exe_fun          = UInt(EXE_FUN_LEN.W)
  // val rf_wen           = UInt(REN_LEN.W)
  // val wb_sel           = UInt(WB_SEL_LEN.W)
  // val csr_cmd_or_shamt = UInt(CSR_LEN.W)
  // val op2op            = UInt(OP2OP_LEN.W)
  // val mem_w            = UInt(MW_LEN.W)
  // val is_bflen         = Bool()
  // val is_br            = Bool()
  // val bp               = new BranchPrediction(redirect_buffer_size)
  // val actual_attr      = UInt(BTB_ATTR_LEN.W)
  // val actual_is_ret    = Bool()
  // val is_half          = Bool()
  // val is_valid_inst    = Bool()
  // val is_trap          = Bool()
  // val mcause_code      = UInt(CSR_MCAUSE_CODE_LEN.W)
  // val inst_id          = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
}

class InstructionDecoderInput(
  redirect_buffer_size: Int,
  enable_pipeline_probe: Boolean
) extends Bundle {
  val ready   = Output(Bool())
  val flush   = Output(Bool())
  val valid   = Input(Bool())
  val inst    = Input(UInt(WORD_LEN.W))
  val pc      = Input(UInt(PC_LEN.W))
  val bp      = Input(new BranchPrediction(redirect_buffer_size))
  val inst_id = Option.when(enable_pipeline_probe)(Input(UInt(INST_ID_LEN.W)))
}

class InstructionDecoderDebugSignals extends Bundle {
  val id_pc   = Output(UInt(WORD_LEN.W))
  val id_inst = Output(UInt(WORD_LEN.W))
}

class InstructionDecoderPipelineProbe(enable_pipeline_probe: Boolean) extends Bundle {
  val id_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
}

class InstructionDecoder extends Module {
  val io = IO(new Bundle {
    val inst    = Input(UInt(WORD_LEN.W))
    val decoded = Output(new InstructionQueueEntryDecoded)
  })

  val inst = io.inst

  val csignals = ListLookup(
    inst,           List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_X     , OP2_X     , OP3_X     , OPI_X       , REN_X, WBA_RD),
    Array(
      LUI        -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_Z     , OP2_IMM   , OP3_IMF   , OPI_IMU     , REN_S, WBA_RD),
      AUIPC      -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_PC    , OP2_IMM   , OP3_IMF   , OPI_IMU     , REN_S, WBA_RD),
      JUMP       -> List(EXE_JB , JB_DJUMP  , SOP_NOP , OP1_PC    , OP2_IMM   , OP3_IMF   , OPI_IMJ     , REN_S, WBA_RD),
      CALL       -> List(EXE_JB , JB_DCALL  , SOP_NOP , OP1_PC    , OP2_IMM   , OP3_IMF   , OPI_IMJ     , REN_S, WBA_RD),
      RET        -> List(EXE_JB , JB_RET    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      JAL        -> List(EXE_JB , JB_OTHER  , SOP_NOP , OP1_PC    , OP2_IMM   , OP3_IMF   , OPI_IMJ     , REN_S, WBA_RD),
      JALR       -> List(EXE_JB , JB_OTHER  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      BEQ        -> List(EXE_JB , JB_BEQ    , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      BNE        -> List(EXE_JB , JB_BEQ    , SOP_NOT , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      BGE        -> List(EXE_JB , JB_BGE    , SOP_SGN , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      BGEU       -> List(EXE_JB , JB_BGE    , SOP_UNS , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      BLT        -> List(EXE_JB , JB_BLT    , SOP_SGN , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      BLTU       -> List(EXE_JB , JB_BLT    , SOP_UNS , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_IMB     , REN_X, WBA_RD),
      LB         -> List(EXE_LD,  F_MW_B    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      LH         -> List(EXE_LD,  F_MW_H    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      LW         -> List(EXE_LD,  F_MW_W    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      LBU        -> List(EXE_LD,  F_MW_BU   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      LHU        -> List(EXE_LD,  F_MW_HU   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      X_LOAD     -> List(EXE_LD,  F_MW_X    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X2    , OPI_IMI     , REN_S, WBA_RD),
      SB         -> List(EXE_ST,  F_MW_B    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS2   , OPI_IMS     , REN_X, WBA_RD),
      SH         -> List(EXE_ST,  F_MW_H    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS2   , OPI_IMS     , REN_X, WBA_RD),
      SW         -> List(EXE_ST,  F_MW_W    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS2   , OPI_IMS     , REN_X, WBA_RD),
      X_STORE    -> List(EXE_ST,  F_MW_X    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS2   , OPI_IMS     , REN_X, WBA_RD),
      ADDI       -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      SLTI       -> List(EXE_ALU, ALU_SLT   , SOP_SGN , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      SLTIU      -> List(EXE_ALU, ALU_SLT   , SOP_UNS , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      XORI       -> List(EXE_ALU, ALU_XOR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      ORI        -> List(EXE_ALU, ALU_OR    , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      ANDI       -> List(EXE_ALU, ALU_AND   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      SLLI       -> List(EXE_ALU, ALU_FSL   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_Z     , OPI_IMI     , REN_S, WBA_RD),
      SRLI       -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_Z     , OPI_IMI     , REN_S, WBA_RD),
      SRAI       -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_MSB   , OPI_IMI     , REN_S, WBA_RD),
      ADD        -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SUB        -> List(EXE_ALU, ALU_SUB   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SLL        -> List(EXE_ALU, ALU_FSL   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SLT        -> List(EXE_ALU, ALU_SLT   , SOP_SGN , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SLTU       -> List(EXE_ALU, ALU_SLT   , SOP_UNS , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      XOR        -> List(EXE_ALU, ALU_XOR   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SRL        -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_Z     , OPI_X       , REN_S, WBA_RD),
      SRA        -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_MSB   , OPI_X       , REN_S, WBA_RD),
      OR         -> List(EXE_ALU, ALU_OR    , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      AND        -> List(EXE_ALU, ALU_AND   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      CSRRW      -> List(EXE_CSR, CSR_W     , SOP_NOP , OP1_RS1   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CSRRWI     -> List(EXE_CSR, CSR_W     , SOP_NOP , OP1_IM0   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CSRRS      -> List(EXE_CSR, CSR_S     , SOP_NOP , OP1_RS1   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CSRRSI     -> List(EXE_CSR, CSR_S     , SOP_NOP , OP1_IM0   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CSRRC      -> List(EXE_CSR, CSR_C     , SOP_NOP , OP1_RS1   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CSRRCI     -> List(EXE_CSR, CSR_C     , SOP_NOP , OP1_IM0   , OP2_Z     , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      ECALL      -> List(EXE_CSR, CSR_ECALL , SOP_NOP , OP1_X     , OP2_X     , OP3_X     , OPI_X       , REN_X, WBA_RD),
      MRET       -> List(EXE_CSR, CSR_MRET  , SOP_NOP , OP1_X     , OP2_X     , OP3_X     , OPI_X       , REN_X, WBA_RD),
      FENCE_I    -> List(EXE_CSR, CSR_FENCEI, SOP_NOP , OP1_X     , OP2_X     , OP3_X     , OPI_X       , REN_X, WBA_RD),
      MUL        -> List(EXE_MD , MD_MUL    , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MULH       -> List(EXE_MD , MD_MULH   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MULHU      -> List(EXE_MD , MD_MULHU  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MULHSU     -> List(EXE_MD , MD_MULHSU , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      DIV        -> List(EXE_MD , MD_DIV    , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      DIVU       -> List(EXE_MD , MD_DIVU   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      REM        -> List(EXE_MD , MD_REM    , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      REMU       -> List(EXE_MD , MD_REMU   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MAX        -> List(EXE_ALU, ALU_MAX   , SOP_SGN , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MAXU       -> List(EXE_ALU, ALU_MAX   , SOP_UNS , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MIN        -> List(EXE_ALU, ALU_MIN   , SOP_SGN , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      MINU       -> List(EXE_ALU, ALU_MIN   , SOP_UNS , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      CLZ        -> List(EXE_BLU, BLU_CLZ   , SOP_NOP , OP1_RS1   , OP2_X     , OP3_X     , OPI_X       , REN_S, WBA_RD),
      CTZ        -> List(EXE_BLU, BLU_CTZ   , SOP_NOP , OP1_RS1   , OP2_X     , OP3_X     , OPI_X       , REN_S, WBA_RD),
      CPOP       -> List(EXE_BLU, BLU_CPOP  , SOP_NOP , OP1_RS1   , OP2_X     , OP3_X     , OPI_X       , REN_S, WBA_RD),
      REV8       -> List(EXE_BLU, BLU_REV8  , SOP_NOP , OP1_RS1   , OP2_X     , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SEXTB      -> List(EXE_ALU, ALU_SZEXT , SOP_SEXT, OP1_RS1   , OP2_IMM   , OP3_X     , OPI_EXTB    , REN_S, WBA_RD),
      SEXTH      -> List(EXE_ALU, ALU_SZEXT , SOP_SEXT, OP1_RS1   , OP2_IMM   , OP3_X     , OPI_EXTH    , REN_S, WBA_RD),
      ZEXTH      -> List(EXE_ALU, ALU_SZEXT , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_EXTH    , REN_S, WBA_RD),
      ANDN       -> List(EXE_ALU, ALU_AND   , SOP_NOT , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      ORN        -> List(EXE_ALU, ALU_OR    , SOP_NOT , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      XNOR       -> List(EXE_ALU, ALU_XOR   , SOP_NOT , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      ROL        -> List(EXE_ALU, ALU_FSL   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS1   , OPI_X       , REN_S, WBA_RD),
      ROR        -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS1   , OPI_X       , REN_S, WBA_RD),
      RORI       -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS1   , OPI_IMI     , REN_S, WBA_RD),
      BSCTH      -> List(EXE_BLU, BLU_BSCTH , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      SH_ADD     -> List(EXE_ALU, ALU_ADD   , SOP_SHAD, OP1_RS1   , OP2_RS2   , OP3_IMF   , OPI_X       , REN_S, WBA_RD),
      X_SHADD    -> List(EXE_ALU, ALU_ADD   , SOP_SHAD, OP1_RS1   , OP2_RS2   , OP3_IMF   , OPI_X       , REN_X, WBA_RD),
      BCLR       -> List(EXE_ALU, ALU_BCLR  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      BSET       -> List(EXE_ALU, ALU_BSET  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      BINV       -> List(EXE_BLU, BLU_BINV  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      BEXT       -> List(EXE_ALU, ALU_BEXT  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X     , OPI_X       , REN_S, WBA_RD),
      BCLRI      -> List(EXE_ALU, ALU_BCLR  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      BSETI      -> List(EXE_ALU, ALU_BSET  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      BINVI      -> List(EXE_BLU, BLU_BINV  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      BEXTI      -> List(EXE_ALU, ALU_BEXT  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      CMOV       -> List(EXE_ALU, ALU_CMOV  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      FSL        -> List(EXE_ALU, ALU_FSL   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      FSR        -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      FSRI       -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS3   , OPI_IMI     , REN_S, WBA_RD),
      X_ZBT      -> List(EXE_ALU, ALU_CMOV  , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_X3    , OPI_X       , REN_S, WBA_RD),
      X_ZBTI     -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X3    , OPI_IMI     , REN_S, WBA_RD),
      BFA        -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_RS2MIX, OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFM        -> List(EXE_BLU, BLU_BFM   , SOP_ZERO, OP1_RS1   , OP2_RS2MIX, OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFP        -> List(EXE_BLU, BLU_BFP   , SOP_NOP , OP1_RS1   , OP2_RS2MIX, OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFF        -> List(EXE_BLU, BLU_BFP   , SOP_NOP , OP1_RS1   , OP2_RS2MIX, OP3_Z3    , OPI_BFI     , REN_S, WBA_RD),
      BFX        -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_RS2MIX, OP3_Z3    , OPI_BFI     , REN_S, WBA_RD),
      BFS        -> List(EXE_BLU, BLU_BFX   , SOP_SEXT, OP1_RS1   , OP2_RS2MIX, OP3_X3    , OPI_BFI     , REN_S, WBA_RD),
      BFAP       -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      BFMP       -> List(EXE_BLU, BLU_BFM   , SOP_ZERO, OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      BFPP       -> List(EXE_BLU, BLU_BFP   , SOP_NOP , OP1_RS1   , OP2_RS2   , OP3_RS3   , OPI_X       , REN_S, WBA_RD),
      X_BF       -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_RS2MIX, OP3_Z3    , OPI_BFI     , REN_S, WBA_RD),
      BFAI       -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFMI       -> List(EXE_BLU, BLU_BFM   , SOP_ZERO, OP1_RS1   , OP2_IMM   , OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFPI       -> List(EXE_BLU, BLU_BFP   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_RS3   , OPI_BFIC    , REN_S, WBA_RD),
      BFFI       -> List(EXE_BLU, BLU_BFP   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_Z3    , OPI_BFI     , REN_S, WBA_RD),
      BFXI       -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_Z3    , OPI_BFI     , REN_S, WBA_RD),
      BFSI       -> List(EXE_BLU, BLU_BFX   , SOP_SEXT, OP1_RS1   , OP2_IMM   , OP3_X3    , OPI_BFI     , REN_S, WBA_RD),
      X_BFI      -> List(EXE_BLU, BLU_BFX   , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X3    , OPI_BFI     , REN_S, WBA_RD),
      GORCI      -> List(EXE_BLU, BLU_GORC  , SOP_NOP , OP1_RS1   , OP2_IMM   , OP3_X     , OPI_IMI     , REN_S, WBA_RD),
      // C_ILL      -> List(ALU_X     , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_X    , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_ADDI4SPN -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_SP  , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMIW , REN_S, WBA_CP2),
      C_AUIPC    -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_PC1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_IMU  , REN_S, WBA_CP2),
      C_LW       -> List(EXE_LD , F_MW_W    , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_IMLS , REN_S, WBA_CP2),
      C_SW       -> List(EXE_ST , F_MW_W    , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_RS2P, OPI_C_IMLS , REN_X, WBA_CP2),
      C_BEQ      -> List(EXE_JB , JB_BEQ    , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2PB, OPI_C_IMB2 , REN_X, WBA_CP2),
      C_BNE      -> List(EXE_JB , JB_BEQ    , SOP_NOT , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2PB, OPI_C_IMB2 , REN_X, WBA_CP2),
      C_JAL      -> List(EXE_JB , JB_DCALL  , SOP_NOP , OP1_C_PC1 , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMJ  , REN_S, WBA_RA ),
      C_ADDI     -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1 , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMI  , REN_S, WBA_C  ),
      C_LI       -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_Z1  , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMI  , REN_S, WBA_C  ),
      C_ADDI16SP -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1 , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMI16, REN_S, WBA_C  ),
      C_LUI      -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_Z1  , OP2_C_IM2P, OP3_C_X2P , OPI_C_IMIU , REN_S, WBA_C  ),
      C_SRLI     -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_IMI  , REN_S, WBA_CP1),
      C_SRAI     -> List(EXE_ALU, ALU_FSR   , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_M2P , OPI_C_IMI  , REN_S, WBA_CP1),
      C_ANDI     -> List(EXE_ALU, ALU_AND   , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_IMI  , REN_S, WBA_CP1),
      C_SUB      -> List(EXE_ALU, ALU_SUB   , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_XOR      -> List(EXE_ALU, ALU_XOR   , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_OR       -> List(EXE_ALU, ALU_OR    , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_AND      -> List(EXE_ALU, ALU_AND   , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_MULH     -> List(EXE_MD , MD_MULH   , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_MULHU    -> List(EXE_MD , MD_MULHU  , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_MUL      -> List(EXE_MD , MD_MUL    , SOP_NOP , OP1_C_RS1P, OP2_C_RS2P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_ZEXTB    -> List(EXE_ALU, ALU_SZEXT , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_EXTB , REN_S, WBA_CP1),
      C_SEXTB    -> List(EXE_ALU, ALU_SZEXT , SOP_SEXT, OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_EXTB , REN_S, WBA_CP1),
      C_ZEXTH    -> List(EXE_ALU, ALU_SZEXT , SOP_NOP , OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_EXTH , REN_S, WBA_CP1),
      C_SEXTH    -> List(EXE_ALU, ALU_SZEXT , SOP_SEXT, OP1_C_RS1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_EXTH , REN_S, WBA_CP1),
      C_1OP_ALU1 -> List(EXE_ALU, ALU_XOR   , SOP_NOT , OP1_C_Z1P,  OP2_C_RS1P, OP3_C_X2P , OPI_C_X    , REN_X, WBA_CP1),
      C_NOT      -> List(EXE_ALU, ALU_XOR   , SOP_NOT , OP1_C_Z1P,  OP2_C_RS1P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_NEG      -> List(EXE_ALU, ALU_SUB   , SOP_NOP , OP1_C_Z1P , OP2_C_RS1P, OP3_C_X2P , OPI_C_X    , REN_S, WBA_CP1),
      C_1OP_ALU2 -> List(EXE_ALU, ALU_SUB   , SOP_NOP , OP1_C_Z1P , OP2_C_RS1P, OP3_C_X2P , OPI_C_X    , REN_X, WBA_CP1),
      C_J        -> List(EXE_JB , JB_DJUMP  , SOP_NOP , OP1_C_PC1P, OP2_C_IM2P, OP3_C_X2P , OPI_C_IMJ  , REN_X, WBA_CP1),
      C_BEQZ     -> List(EXE_JB , JB_BEQ    , SOP_NOP , OP1_C_RS1P, OP2_C_Z2P , OP3_C_X2PB, OPI_C_IMB  , REN_X, WBA_CP1),
      C_BNEZ     -> List(EXE_JB , JB_BEQ    , SOP_NOT , OP1_C_RS1P, OP2_C_Z2P , OP3_C_X2PB, OPI_C_IMB  , REN_X, WBA_CP1),
      C_LWSP     -> List(EXE_LD , F_MW_W    , SOP_NOP , OP1_C_SP  , OP2_C_IM2 , OP3_C_X2  , OPI_C_IMSPL, REN_S, WBA_C  ),
      C_SWSP     -> List(EXE_ST , F_MW_W    , SOP_NOP , OP1_C_SP  , OP2_C_IM2 , OP3_C_RS2 , OPI_C_IMSPS, REN_X, WBA_C  ),
      C_SLLI     -> List(EXE_ALU, ALU_FSL   , SOP_NOP , OP1_C_RS1 , OP2_C_IM2 , OP3_C_X2  , OPI_C_IMI  , REN_S, WBA_C  ),
      C_RET      -> List(EXE_JB , JB_RET    , SOP_NOP , OP1_C_RS1 , OP2_C_Z2  , OP3_C_X2  , OPI_C_XSPS , REN_X, WBA_C  ),
      C_JR       -> List(EXE_JB , JB_OTHER  , SOP_NOP , OP1_C_RS1 , OP2_C_Z2  , OP3_C_X2  , OPI_C_XSPS , REN_X, WBA_C  ),
      C_JALR     -> List(EXE_JB , JB_OTHER  , SOP_NOP , OP1_C_RS1 , OP2_C_Z2  , OP3_C_X2  , OPI_C_XSPS , REN_S, WBA_RA ),
      C_MV       -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_Z1  , OP2_C_RS2 , OP3_C_X2  , OPI_C_XSPS , REN_S, WBA_C  ),
      C_ADD      -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1 , OP2_C_RS2 , OP3_C_X2  , OPI_C_XSPS , REN_S, WBA_C  ),
      C_LB       -> List(EXE_LD , F_MW_B    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMLSB, REN_S, WBA_CP2),
      C_LBU      -> List(EXE_LD , F_MW_BU   , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMLSB, REN_S, WBA_CP2),
      C_LH       -> List(EXE_LD , F_MW_H    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMLSH, REN_S, WBA_CP2),
      C_LHU      -> List(EXE_LD , F_MW_HU   , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMLSH, REN_S, WBA_CP2),
      C_SH       -> List(EXE_ST , F_MW_H    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_RS2P, OPI_C_IMLSH, REN_X, WBA_CP2),
      C_SW0      -> List(EXE_ST , F_MW_W    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_Z2P , OPI_C_IMSW0, REN_X, WBA_CP2),
      C_SB0      -> List(EXE_ST , F_MW_B    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_Z2P , OPI_C_IMSB0, REN_X, WBA_CP2),
      C_SH0      -> List(EXE_ST , F_MW_H    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_Z2P , OPI_C_IMSH0, REN_X, WBA_CP2),
      C_SB       -> List(EXE_ST , F_MW_B    , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_RS2P, OPI_C_IMLSB, REN_X, WBA_CP2),
      C_ADDI2W   -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMA2W, REN_S, WBA_CP2),
      C_ADD2     -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1P, OP2_C_RS3P, OP3_C_X2P , OPI_C_XA2B , REN_S, WBA_CP2),
      C_SEQZ     -> List(EXE_ALU, ALU_SEQ   , SOP_NOP , OP1_C_RS1P, OP2_C_Z3P , OP3_C_X2P , OPI_C_XA2B , REN_S, WBA_CP2),
      C_SNEZ     -> List(EXE_ALU, ALU_SEQ   , SOP_NOT , OP1_C_RS1P, OP2_C_Z3P , OP3_C_X2P , OPI_C_XA2B , REN_S, WBA_CP2),
      C_ADDI2B   -> List(EXE_ALU, ALU_ADD   , SOP_NOP , OP1_C_RS1P, OP2_C_IM3P, OP3_C_X2P , OPI_C_IMA2B, REN_S, WBA_CP2),
      C_SLT      -> List(EXE_ALU, ALU_SLT   , SOP_SGN , OP1_C_RS1P, OP2_C_RS3P, OP3_C_X2P , OPI_C_XA2B , REN_S, WBA_CP2),
      C_SLTU     -> List(EXE_ALU, ALU_SLT   , SOP_UNS , OP1_C_RS1P, OP2_C_RS3P, OP3_C_X2P , OPI_C_XA2B , REN_S, WBA_CP2),
		)
	)
  val List(              exe_sel, exe_fun   , sop     , op1_sel   , op2_sel   , op3_sel   , opi_sel    ,rf_wen, wba    ) = csignals

  val rs1_addr  = inst(19, 15)
  val rs2_addr  = inst(24, 20)
  val rs3_addr  = inst(31, 27)
  val rd_addr   = inst(11, 7)
  val rs3f_addr = inst(31, 30) ## inst(14, 12)

  val c_rs1_addr  = inst(11, 7)
  val c_rs2_addr  = inst(6, 2)
  val c_rd_addr   = inst(11, 7)
  val c_rs1p_addr = 1.U(2.W) ## inst(9, 7)
  val c_rs2p_addr = 1.U(2.W) ## inst(4, 2)
  val c_rs3p_addr = 1.U(2.W) ## inst(12, 10)
  val c_rd1p_addr = 1.U(2.W) ## inst(9, 7)
  val c_rd2p_addr = 1.U(2.W) ## inst(4, 2)

  // val m_op1_sel = Mux(
  //   (op1_sel === OP1_RS1 && rs1_addr === 0.U) || (op1_sel === OP1_C_RS1 && c_rs1_addr === 0.U),
  //   OP1_SEL_Z,
  //   op1_sel(3, 2),
  // )
  val m_op1_sel = op1_sel(3, 2)

  val m_rs1_addr = MuxCase(rs1_addr, Seq(
    (op1_sel === OP1_C_RS1)  -> c_rs1_addr,
    (op1_sel === OP1_C_Z1)   -> c_rs1_addr,
    (op1_sel === OP1_C_PC1)  -> c_rs1_addr,
    (op1_sel === OP1_C_SP)   -> 2.U(ADDR_LEN.W),
    (op1_sel === OP1_C_RS1P) -> c_rs1p_addr,
    (op1_sel === OP1_C_Z1P)  -> c_rs1p_addr,
    (op1_sel === OP1_C_PC1P) -> c_rs1p_addr,
  ))

  // val m_op2_sel = Mux(
  //   ((op2_sel === OP2_RS2 || op2_sel === OP2_RS2MIX) && rs2_addr === 0.U) ||
  //     (op2_sel === OP2_C_RS2 && c_rs2_addr === 0.U),
  //   OP2_SEL_Z,
  //   op2_sel(4, 3),
  // )
  val m_op2_sel = op2_sel(4, 3)

  val m_rs2_addr = MuxCase(rs2_addr, Seq(
    (op2_sel === OP2_C_RS1P) -> c_rs1p_addr,
    (op2_sel === OP2_C_RS2P) -> c_rs2p_addr,
    (op2_sel === OP2_C_IM2P) -> c_rs2p_addr,
    (op2_sel === OP2_C_Z2P)  -> c_rs2p_addr,
    (op2_sel === OP2_C_RS3P) -> c_rs3p_addr,
    (op2_sel === OP2_C_IM3P) -> c_rs3p_addr,
    (op2_sel === OP2_C_Z3P)  -> c_rs3p_addr,
    (op2_sel === OP2_C_RS2)  -> c_rs2_addr,
    (op2_sel === OP2_C_IM2)  -> c_rs2_addr,
    (op2_sel === OP2_C_Z2)   -> c_rs2_addr,
  ))

  // val m_op3_sel = Mux(
  //   ((rs3_sel === OP3_RS1 || rs3_sel === OP3_MSB) && rs1_addr === 0.U) ||
  //     (rs3_sel === OP3_RS2 && rs2_addr === 0.U) ||
  //     (rs3_sel === OP3_RS3 && rs3_addr === 0.U) ||
  //     (rs3_sel === OP3_C_RS2 && c_rs2_addr === 0.U),
  //   OP3_SEL_Z,
  //   op3_sel(4, 3),
  // )
  val m_op3_sel = op3_sel(4, 3)

  val m_rs3_addr = MuxCase(rs1_addr, Seq(
    (op3_sel === OP3_C_RS2P) -> c_rs2p_addr,
    (op3_sel === OP3_C_M2P)  -> c_rs2p_addr,
    (op3_sel === OP3_C_Z2P)  -> c_rs2p_addr,
    (op3_sel === OP3_C_X2PB) -> c_rs2p_addr,
    (op3_sel === OP3_C_RS2)  -> c_rs2_addr,
    (op3_sel === OP3_C_X2)   -> c_rs2_addr,
    (op3_sel === OP3_RS2)    -> rs2_addr,
    (op3_sel === OP3_X2)     -> rs2_addr,
    (op3_sel === OP3_RS3)    -> rs3_addr,
    (op3_sel === OP3_X3)     -> rs3_addr,
    (op3_sel === OP3_IMF)    -> rs3f_addr,
  ))

  val imm_sel = opi_sel(6, 5)

  def make_bfic_len(len: UInt): UInt = {
    Mux(len === 7.U(3.W), 8.U(5.W), 0.U(2.W) ## len)
  }

  val imm_data = MuxCase(inst(31, 20), Seq(
    (opi_sel === OPI_IMB)     -> inst(31, 25) ## inst(11, 7),
    (opi_sel === OPI_IMS)     -> inst(31, 25) ## inst(11, 7),
    (opi_sel === OPI_BFIC)    -> inst(31) ## make_bfic_len(inst(26, 25) ## inst(14)) ## inst(25, 20),
    (opi_sel === OPI_BFI)     -> inst(31) ## inst(31, 27) ## inst(25, 20),
    (opi_sel === OPI_EXTH)    -> inst(31) ## 1.U(1.W) ## inst(29, 20),
    (opi_sel === OPI_EXTB)    -> inst(31) ## 0.U(1.W) ## inst(29, 20),
    (opi_sel === OPI_C_IMIW)  -> 0.U(2.W) ## inst(10, 7) ## inst(12, 11) ## inst(5) ## inst(6) ## 0.U(2.W),
    (opi_sel === OPI_C_IMI16) -> Fill(3, inst(12)) ## inst(4, 3) ## inst(5) ## inst(2) ## inst(6) ## 0.U(4.W),
    (opi_sel === OPI_C_IMI)   -> Fill(7, inst(12)) ## inst(6, 2),
    (opi_sel === OPI_C_IMJ)   -> inst(12) ## inst(8) ## inst(10, 9) ## inst(6) ## inst(7) ## inst(2) ## inst(11) ## inst(5, 3) ## 0.U(1.W),
    (opi_sel === OPI_C_IMIU)  -> Fill(7, inst(12)) ## inst(6, 2),
    (opi_sel === OPI_C_IMU)   -> 0.U(4.W) ## inst(12, 5),
    // (opi_sel === OPI_C_IMU)   -> 0.U(4.W) ## inst(8, 7) ## inst(12, 8) ## inst(5) ## inst(6),
    (opi_sel === OPI_C_IMB)   -> Fill(4, inst(12)) ## inst(6, 5) ## inst(2) ## inst(11, 10) ## inst(4, 3) ## 0.U(1.W),
    (opi_sel === OPI_C_IMB2)  -> Fill(7, inst(12)) ## inst(11, 10) ## inst(6, 5) ## 0.U(1.W),
    (opi_sel === OPI_C_IMA2W) -> Fill(6, inst(12)) ## inst(5) ## inst(11, 10) ## inst(6) ## 0.U(2.W),
    (opi_sel === OPI_C_IMA2B) -> Fill(10, inst(12)) ## inst(11, 10),
    (opi_sel === OPI_C_IMLS)  -> 0.U(5.W) ## inst(5) ## inst(12, 10) ## inst(6) ## 0.U(2.W),
    (opi_sel === OPI_C_IMSPL) -> 0.U(4.W) ## inst(3, 2) ## inst(12) ## inst(6, 4) ## 0.U(2.W),
    (opi_sel === OPI_C_IMSPS) -> 0.U(4.W) ## inst(8, 7) ## inst(12, 9) ## 0.U(2.W),
    (opi_sel === OPI_C_IMLSB) -> 0.U(7.W) ## inst(11, 10) ## inst(6, 5) ## inst(12),
    (opi_sel === OPI_C_IMLSH) -> 0.U(8.W) ## inst(10) ## inst(6, 5) ## 0.U(1.W),
    (opi_sel === OPI_C_IMSW0) -> 0.U(5.W) ## inst(5, 3) ## inst(10) ## inst(6) ## 0.U(2.W),
    // (opi_sel === OPI_C_IMSW0) -> 0.U(5.W) ## inst(2) ## inst(5, 4) ## inst(10) ## inst(6) ## 0.U(2.W),
    (opi_sel === OPI_C_IMSB0) -> 0.U(8.W) ## inst(10) ## inst(6, 4),
    (opi_sel === OPI_C_IMSH0) -> 0.U(7.W) ## inst(4) ## inst(10) ## inst(6, 5) ## 0.U(1.W),
    (opi_sel === OPI_C_EXTH)  -> inst(12) ## 1.U(1.W) ## Fill(5, inst(12)) ## inst(6, 2),
    (opi_sel === OPI_C_EXTB)  -> inst(12) ## 0.U(1.W) ## Fill(5, inst(12)) ## inst(6, 2),
  ))

  val m_rf_wen = Mux(
    rf_wen === REN_S && !(wba === WBA_RD && rd_addr === 0.U) && !(wba === WBA_C && c_rd_addr === 0.U),
    REN_S,
    REN_X,
  )

  val m_wb_addr = MuxCase(rd_addr, Seq(
    (wba === WBA_C)   -> c_rd_addr,
    (wba === WBA_CP1) -> c_rd1p_addr,
    (wba === WBA_CP2) -> c_rd2p_addr,
    (wba === WBA_RA)  -> 1.U(ADDR_LEN.W),
  ))

  io.decoded.exe_sel  := exe_sel
  io.decoded.exe_fun  := exe_fun
  io.decoded.sop      := sop
  io.decoded.op1_sel  := m_op1_sel
  io.decoded.op2_sel  := m_op2_sel
  io.decoded.op3_sel  := m_op3_sel
  io.decoded.rs1_addr := m_rs1_addr
  io.decoded.rs2_addr := Mux(m_op2_sel === OP2_SEL_IMM, m_rs2_addr(4, 2) ## imm_sel, m_rs2_addr)
  io.decoded.rs3_addr := m_rs3_addr
  io.decoded.imm_data := imm_data
  io.decoded.rf_wen   := m_rf_wen
  io.decoded.wb_addr  := m_wb_addr
}

class InstructionDecoderUnit(
  redirect_buffer_size: Int,
  enable_pipeline_probe: Boolean = false,
) extends Module {
  val iq_id_len = log2Ceil(IQ_ENTRIES)
  val iq_id_ptr_len = iq_id_len + 1

  val io = IO(new Bundle {
    val in = new InstructionDecoderInput(redirect_buffer_size, enable_pipeline_probe)
    val out = new InstructionDecoderOutput(redirect_buffer_size, enable_pipeline_probe)
    val debug_signals = new InstructionDecoderDebugSignals()
    val pipeline_probe = new InstructionDecoderPipelineProbe(enable_pipeline_probe)
  })

  val iq = Module(new InstructionQueue(
    IQ_ENTRIES,
    new InstructionQueueEntryInitial(redirect_buffer_size, enable_pipeline_probe),
    new InstructionQueueEntryDecoded
  ))

  io.in.ready := iq.io.enq1.ready
  io.in.flush := io.out.flush

  iq.io.flush := io.out.flush

  iq.io.enq1.en              := io.in.valid && !io.out.flush
  iq.io.enq1.initial.pc      := io.in.pc
  iq.io.enq1.initial.bp      := io.in.bp
  iq.io.enq1.initial.is_half := (io.in.inst(1, 0) =/= 3.U)
  map2(iq.io.enq1.initial.inst_id, io.in.inst_id)(_ := _)

  iq.io.enq2.en         := false.B
  iq.io.enq2.initial.pc := io.in.pc
  iq.io.enq2.initial.bp := io.in.bp
  iq.io.enq2.initial.is_half := false.B
  map2(iq.io.enq2.initial.inst_id, io.in.inst_id)(_ := _)

  class Id1Input(iq_id_len: Int) extends Bundle {
    val iq_id_ptr_len = iq_id_len + 1

    val valid = Bool()
    val inst  = UInt(WORD_LEN.W)
    val iq_id = UInt(iq_id_ptr_len.W)
    val inst_id = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
  }

  def id1(in: Id1Input): Unit = {
    val reg_in = RegInit(new Id1Input(iq_id_len).Lit(
      _.valid   -> false.B,
      _.inst    -> BUBBLE,
      _.iq_id   -> 0.U,
      // x => map2(x.inst_id, Option.when(enable_pipeline_probe)(0.U))(_ -> _),
    ))
    reg_in := in
    // reg_in.valid := in.valid
    // reg_in.inst  := in.inst
    // reg_in.iq_id := in.iq_id

    val decoder = Module(new InstructionDecoder)

    decoder.io.inst := reg_in.inst

    iq.io.read1.iq_id := reg_in.iq_id

    io.pipeline_probe.id_valid.foreach(_ := reg_in.valid)
    map2(io.pipeline_probe.id_inst_id, reg_in.inst_id)(_ := _)

    io.debug_signals.id_pc   := iq.io.read1.initial.pc.pc_to_word
    io.debug_signals.id_inst := reg_in.inst

    iq.io.put.en      := reg_in.valid
    iq.io.put.iq_id   := reg_in.iq_id
    iq.io.put.decoded := decoder.io.decoded

    // printf(cf"decoder put en = ${reg_in.valid}\n")
    // printf(cf"decoder put iq_id = 0x${reg_in.iq_id}%x\n")
  }

  val id1_in = Wire(new Id1Input(iq_id_len))
  id1_in.valid := io.in.valid && iq.io.enq1.ready && !io.out.flush
  id1_in.inst  := io.in.inst
  id1_in.iq_id := iq.io.enq1.iq_id
  map2(id1_in.inst_id, io.in.inst_id)(_ := _)

  id1(id1_in)

  /*
  val reg_in = RegInit(new Id1Output(iq_id_len).Lit(
    _.valid -> false.B,
    _.inst  -> BUBBLE,
    _.iq_id -> 0.U
  ))
  reg_in.valid := id1_out.valid && !io.out.flush
  reg_in.inst  := id1_out.inst
  reg_in.iq_id := id1_out.iq_id

  val id_inst = reg_in.inst

  // val id_is_half = (id_inst(1, 0) =/= 3.U)

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
  val id_imm_z_uext = Cat(Fill(7, 0.U), id_imm_z)

  val id_c_imm_i = Cat(Fill(27, id_inst(12)), id_inst(6, 2))
  val id_c_imm_iu = Cat(Fill(15, id_inst(12)), id_inst(6, 2), Fill(12, 0.U))
  val id_c_imm_i16 = Cat(Fill(23, id_inst(12)), id_inst(4, 3), id_inst(5), id_inst(2), id_inst(6), Fill(4, 0.U))
  val id_c_imm_spl = Cat(Fill(4, 0.U), id_inst(3, 2), id_inst(12), id_inst(6, 4), Fill(2, 0.U))
  val id_c_imm_sps = Cat(Fill(4, 0.U), id_inst(8, 7), id_inst(12, 9), Fill(2, 0.U))
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
                    List(ALU_X     , OP1_X     , OP2_X       , OP3_X     , OPI_X       , REN_X, WB_X    , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
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
      BNE        -> List(BR_BEQ    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_NOT),
      BGE        -> List(BR_BGE    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_SIGNED),
      BGEU       -> List(BR_BGE    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_UNSIGNED),
      BLT        -> List(BR_BLT    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_SIGNED),
      BLTU       -> List(BR_BLT    , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_IMB     , REN_X, WB_X    , WBA_RD , CSR_X, MW_BR , OP2OP_UNSIGNED),
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
      BINV       -> List(ALU_BINV  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BEXT       -> List(ALU_BEXT  , OP1_RS1   , OP2_RS2     , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BCLRI      -> List(ALU_BCLR  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BSETI      -> List(ALU_BSET  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_ALU  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
      BINVI      -> List(ALU_BINV  , OP1_RS1   , OP2_IMM     , OP3_X     , OPI_IMI     , REN_S, WB_BIT  , WBA_RD , CSR_X, MW_X  , OP2OP_NOP),
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
      C_BNEZ     -> List(BR_BEQ    , OP1_C_RS1P, OP2_Z       , OP3_X     , OPI_C_IMB   , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOT),
      C_JR       -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z       , OP3_X     , OPI_X       , REN_X, WB_PC   , WBA_C  , CSR_X, MW_X  , OP2OP_NOP),
      C_JALR     -> List(ALU_ADD   , OP1_C_RS1 , OP2_Z       , OP3_X     , OPI_X       , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_JAL      -> List(ALU_ADD   , OP1_PC    , OP2_IMM     , OP3_X     , OPI_C_IMJ   , REN_S, WB_PC   , WBA_RA , CSR_X, MW_X  , OP2OP_NOP),
      C_LWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_IMM     , OP3_X     , OPI_C_IMSPL , REN_S, WB_LD   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
      C_SWSP     -> List(ALU_ADD   , OP1_C_SP  , OP2_IMM     , OP3_C_RS2 , OPI_C_IMSPS , REN_X, WB_ST   , WBA_C  , CSR_X, MW_W  , OP2OP_NOP),
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
      C_BNE      -> List(BR_BEQ    , OP1_C_RS1P, OP2_C_RS2P  , OP3_X     , OPI_C_IMB2  , REN_X, WB_X    , WBA_C  , CSR_X, MW_BR , OP2OP_NOT),
      C_ADDI2W   -> List(ALU_ADD   , OP1_C_RS1P, OP2_IMM     , OP3_X     , OPI_C_IMA2W , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_ADD2     -> List(ALU_ADD   , OP1_C_RS1P, OP2_C_RS3P  , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SEQZ     -> List(ALU_SEQ   , OP1_C_RS1P, OP2_Z       , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOP),
      C_SNEZ     -> List(ALU_SEQ   , OP1_C_RS1P, OP2_Z       , OP3_X     , OPI_X       , REN_S, WB_ALU  , WBA_CP2, CSR_X, MW_X  , OP2OP_NOT),
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
    (id_opi_sel === OPI_C_IMSPL) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSPS) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMLSB) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMLSH) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSW0) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSB0) -> 0.U(WORD_LEN.W),
    (id_opi_sel === OPI_C_IMSH0) -> 0.U(WORD_LEN.W),
    // (id_opi_sel === OPI_IM1)     -> 0.U(WORD_LEN.W),
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
    (id_opi_sel === OPI_C_IMSPL) -> id_c_imm_spl,
    (id_opi_sel === OPI_C_IMSPS) -> id_c_imm_sps,
    (id_opi_sel === OPI_C_IMLSB) -> id_c_imm_lsb,
    (id_opi_sel === OPI_C_IMLSH) -> id_c_imm_lsh,
    (id_opi_sel === OPI_C_IMSW0) -> id_c_imm_sw0,
    (id_opi_sel === OPI_C_IMSB0) -> id_c_imm_sb0,
    (id_opi_sel === OPI_C_IMSH0) -> id_c_imm_sh0,
    // (id_opi_sel === OPI_IM1)     -> 1.U(12.W),
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

  val id_csr_cmd_or_shamt = Mux(id_op2op === OP2OP_SHADD, id_shamt, id_csr_cmd)

  val id_is_br = (id_mem_w === MW_BR)
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

  iq.io.put.en                       := reg_in.valid
  iq.io.put.iq_id                    := reg_in.iq_id
  iq.io.put.decoded.wb_addr          := id_wb_addr
  iq.io.put.decoded.op1_sel          := id_m_op1_sel
  iq.io.put.decoded.op2_sel          := id_m_op2_sel
  iq.io.put.decoded.op3_sel          := id_m_op3_sel
  iq.io.put.decoded.rs1_addr         := id_m_rs1_addr
  iq.io.put.decoded.rs2_addr         := id_m_rs2_addr
  iq.io.put.decoded.rs3_addr         := id_m_rs3_addr
  iq.io.put.decoded.im1_data         := id_im1_data
  iq.io.put.decoded.im0_data         := id_im0_data
  iq.io.put.decoded.exe_fun          := id_exe_fun
  iq.io.put.decoded.rf_wen           := id_rf_wen
  iq.io.put.decoded.wb_sel           := id_wb_sel
  iq.io.put.decoded.csr_cmd_or_shamt := id_csr_cmd_or_shamt
  iq.io.put.decoded.op2op            := id_op2op
  iq.io.put.decoded.mem_w            := id_mem_w
  iq.io.put.decoded.is_bflen         := id_is_bflen
  iq.io.put.decoded.is_br            := id_is_br
  iq.io.put.decoded.actual_attr      := id_actual_attr
  iq.io.put.decoded.actual_is_ret    := id_actual_is_ret
  // iq.io.put.decoded.is_half          := id_is_half
  iq.io.put.decoded.is_trap          := id_is_trap
  iq.io.put.decoded.mcause_code      := id_mcause_code

  io.pipeline_probe.id_valid.foreach(_ := reg_in.valid)
  map2(io.pipeline_probe.id_inst_id, iq.io.read1.initial.inst_id)(_ := _)

  // printf(cf"deq_first : 0x${iq.io.range.deq_first}%x\n")
  // printf(cf"deq_last  : 0x${iq.io.range.deq_last}%x\n")

  class Id2Output(iq_id_len: Int) extends Bundle {
    val iq_id_ptr_len = iq_id_len + 1

    val valid = Bool()
    val iq_id = UInt(iq_id_ptr_len.W)
  }

  val id2_out = Wire(new Id2Output(iq_id_len))
  id2_out.valid := reg_in.valid && !io.out.flush
  id2_out.iq_id := reg_in.iq_id

  */

  def id2: Unit = {
    iq.io.peek.iq_id := iq.io.range.deq_first

    iq.io.upd_deq.en  := iq.io.peek.valid && io.out.ready
    iq.io.upd_deq.deq := iq.io.range.deq_first + 1.U

    io.out.valid   := iq.io.peek.valid && !io.out.flush
    io.out.initial := iq.io.peek.initial
    io.out.decoded := iq.io.peek.decoded

    when (io.out.flush || !iq.io.peek.valid) {
      io.out.decoded.exe_sel       := EXE_ALU
      io.out.decoded.op1_sel       := OP1_SEL_Z(1) ## iq.io.peek.decoded.op1_sel(0)
      io.out.decoded.op2_sel       := OP2_SEL_Z(1) ## iq.io.peek.decoded.op2_sel(0)
      io.out.decoded.op3_sel       := OP3_SEL_Z(1) ## iq.io.peek.decoded.op3_sel(0)
      io.out.decoded.rf_wen        := REN_X
      // io.out.decoded.wb_sel        := WB_X
      // io.out.decoded.mem_w         := MW_X
      // io.out.decoded.is_br         := false.B
      io.out.initial.bp.redirected := false.B
      io.out.initial.bp.bpfailed   := false.B
      // io.out.decoded.is_valid_inst := false.B
      // io.out.decoded.is_trap       := false.B
    }

    // printf(cf"decoder ready = ${io.out.ready}\n")
    // printf(cf"decoder peek valid = ${iq.io.peek.valid}\n")
    // printf(cf"decoder deq = 0x${iq.io.range.deq_first + 1.U}%x\n")
    // printf(cf"decoder deq first = 0x${iq.io.range.deq_first}%x\n")
    // printf(cf"decoder deq last = 0x${iq.io.range.deq_first}%x\n")
  }

  id2
}
