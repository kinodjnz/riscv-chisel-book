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

class InstructionQueueEntryDecoded(enable_pipeline_probe: Boolean) extends Bundle {
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
  val inst_id = Option.when(enable_pipeline_probe)(UInt(INST_ID_LEN.W))
}

class InstructionQueueEntryLsq(lsq_id_len: Int) extends Bundle {
  val lsq_id_ptr_len = lsq_id_len + 1

  val lsq_id = UInt(lsq_id_ptr_len.W)
}

class InstructionDecoderOutput(redirect_buffer_size: Int, enable_pipeline_probe: Boolean, lsq_id_len: Int, rob_id_len: Int) extends Bundle {
  val rob_id_ptr_len = rob_id_len + 1

  val ready   = Input(Bool())
  val valid   = Output(Bool())
  val initial = Output(new InstructionQueueEntryInitial(redirect_buffer_size, enable_pipeline_probe))
  val decoded = Output(new InstructionQueueEntryDecoded(enable_pipeline_probe))
  val lsq     = Output(new InstructionQueueEntryLsq(lsq_id_len))
  val rob_id  = Output(UInt(rob_id_ptr_len.W))
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
  val id_pc1   = Output(UInt(WORD_LEN.W))
  val id_inst1 = Output(UInt(WORD_LEN.W))
  val id_pc2   = Output(UInt(WORD_LEN.W))
  val id_inst2 = Output(UInt(WORD_LEN.W))
}

class InstructionDecoderPipelineProbe(enable_pipeline_probe: Boolean) extends Bundle {
  val id1a_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id1a_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
  val id1b_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id1b_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
  val id2a_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id2a_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
  val id2b_valid    = Option.when(enable_pipeline_probe)(Output(Bool()))
  val id2b_inst_id  = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
}

class InstructionDecoder(enable_pipeline_probe: Boolean) extends Module {
  val io = IO(new Bundle {
    val inst    = Input(UInt(WORD_LEN.W))
    val decoded = Output(new InstructionQueueEntryDecoded(enable_pipeline_probe))
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

  val m_op1_sel = op1_sel(3, 2)
  // val m_op1_sel = Mux(op1_sel === OP1_RS1 && rs1_addr === 0.U, OP1_SEL_Z, op1_sel(3, 2))

  val m_rs1_addr = MuxCase(rs1_addr, Seq(
    (op1_sel === OP1_C_RS1)  -> c_rs1_addr,
    (op1_sel === OP1_C_Z1)   -> c_rs1_addr,
    (op1_sel === OP1_C_PC1)  -> c_rs1_addr,
    (op1_sel === OP1_C_SP)   -> 2.U(ADDR_LEN.W),
    (op1_sel === OP1_C_RS1P) -> c_rs1p_addr,
    (op1_sel === OP1_C_Z1P)  -> c_rs1p_addr,
    (op1_sel === OP1_C_PC1P) -> c_rs1p_addr,
  ))

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
  io.decoded.inst_id.map(_ := 0.U)
}

class InstructionDecoderUnit(
  redirect_buffer_size: Int,
  enable_pipeline_probe: Boolean = false,
) extends Module {
  val iq_id_len = log2Ceil(IQ_ENTRIES)
  val iq_id_ptr_len = iq_id_len + 1
  val lsq_id_len = log2Ceil(LSQ_ENTRIES)

  val io = IO(new Bundle {
    val in1   = new InstructionDecoderInput(redirect_buffer_size, enable_pipeline_probe)
    val in2   = new InstructionDecoderInput(redirect_buffer_size, enable_pipeline_probe)
    val flush = Input(Bool())
    val stall = Input(Bool())
    val out1  = new InstructionDecoderOutput(redirect_buffer_size, enable_pipeline_probe, lsq_id_len, iq_id_len)
    val out2  = new InstructionDecoderOutput(redirect_buffer_size, enable_pipeline_probe, lsq_id_len, iq_id_len)
    val lsa1  = Flipped(new LoadStoreQueueAlloc(lsq_id_len))
    val lsa2  = Flipped(new LoadStoreQueueAlloc(lsq_id_len))
    val rob   = new Bundle {
      val range = new InstructionQueueRobRange(iq_id_len)
      val upd   = new InstructionQueueUpdateRobPtr(iq_id_len)
      val deq1  = new InstructionQueueDequeue
      val deq2  = new InstructionQueueDequeue
    }
    val debug_signals = new InstructionDecoderDebugSignals()
    val pipeline_probe = new InstructionDecoderPipelineProbe(enable_pipeline_probe)
  })

  val iq = Module(new InstructionQueue(
    IQ_ENTRIES,
    new InstructionQueueEntryInitial(redirect_buffer_size, enable_pipeline_probe),
    new InstructionQueueEntryDecoded(enable_pipeline_probe),
    new InstructionQueueEntryLsq(lsq_id_len),
  ))

  io.in1.ready := iq.io.enq1.ready
  io.in1.flush := io.flush
  io.in2.ready := iq.io.enq2.ready
  io.in2.flush := false.B

  iq.io.flush := io.flush

  iq.io.enq1.en              := io.in1.valid && (!io.flush && !io.stall)
  iq.io.enq1.initial.pc      := io.in1.pc
  iq.io.enq1.initial.bp      := io.in1.bp
  iq.io.enq1.initial.is_half := (io.in1.inst(1, 0) =/= 3.U)
  map2(iq.io.enq1.initial.inst_id, io.in1.inst_id)(_ := _)

  iq.io.enq2.en              := io.in2.valid && (!io.flush && !io.stall)
  iq.io.enq2.initial.pc      := io.in2.pc
  iq.io.enq2.initial.bp      := io.in2.bp
  iq.io.enq2.initial.is_half := (io.in2.inst(1, 0) =/= 3.U)
  map2(iq.io.enq2.initial.inst_id, io.in2.inst_id)(_ := _)

  iq.io.rob_range <> io.rob.range
  iq.io.upd_rob   <> io.rob.upd
  iq.io.deq1      <> io.rob.deq1
  iq.io.deq2      <> io.rob.deq2

  class Id1Input(iq_id_len: Int) extends Bundle {
    val iq_id_ptr_len = iq_id_len + 1

    val valid = Bool()
    val pc    = UInt(PC_LEN.W)
    val inst  = UInt(WORD_LEN.W)
    val iq_id = UInt(iq_id_ptr_len.W)
    val inst_id = Option.when(enable_pipeline_probe)(Output(UInt(32.W)))
  }

  def id1(in1: Id1Input, in2: Id1Input): Unit = {
    val reg_in1 = RegInit(new Id1Input(iq_id_len).Lit(
      _.valid   -> false.B,
      _.pc      -> 0.U,
      _.inst    -> BUBBLE,
      _.iq_id   -> 0.U,
      // x => map2(x.inst_id, Option.when(enable_pipeline_probe)(0.U))(_ -> _),
    ))
    val reg_in2 = RegInit(new Id1Input(iq_id_len).Lit(
      _.valid   -> false.B,
      _.pc      -> 0.U,
      _.inst    -> BUBBLE,
      _.iq_id   -> 0.U,
      // x => map2(x.inst_id, Option.when(enable_pipeline_probe)(0.U))(_ -> _),
    ))
    reg_in1 := in1
    reg_in2 := in2

    val decoder1 = Module(new InstructionDecoder(enable_pipeline_probe))
    val decoder2 = Module(new InstructionDecoder(enable_pipeline_probe))

    decoder1.io.inst := reg_in1.inst
    decoder2.io.inst := reg_in2.inst

    // iq.io.read1.iq_id := reg_in1.iq_id

    io.pipeline_probe.id1a_valid.foreach(_ := reg_in1.valid)
    map2(io.pipeline_probe.id1a_inst_id, reg_in1.inst_id)(_ := _)
    io.pipeline_probe.id1b_valid.foreach(_ := reg_in2.valid)
    map2(io.pipeline_probe.id1b_inst_id, reg_in2.inst_id)(_ := _)

    io.debug_signals.id_pc1   := reg_in1.pc
    io.debug_signals.id_inst1 := reg_in1.inst
    io.debug_signals.id_pc2   := reg_in2.pc
    io.debug_signals.id_inst2 := reg_in2.inst

    iq.io.put1.en      := reg_in1.valid
    iq.io.put1.iq_id   := reg_in1.iq_id
    iq.io.put1.decoded := decoder1.io.decoded
    map2(iq.io.put1.decoded.inst_id, reg_in1.inst_id)(_ := _)
    iq.io.put2.en      := reg_in2.valid
    iq.io.put2.iq_id   := reg_in2.iq_id
    iq.io.put2.decoded := decoder2.io.decoded
    map2(iq.io.put2.decoded.inst_id, reg_in2.inst_id)(_ := _)

    when (reg_in1.valid) {
      printf(cf"decoder pc      : 0x${reg_in1.pc.pc_to_word}%x\n")
      printf(cf"decoder inst    : 0x${reg_in1.inst}%x\n")
      printf(cf"decoder inst_id : 0x${reg_in1.inst_id.getOrElse(0)}%x\n")
      printf(cf"decoder exe_sel=${decoder1.io.decoded.exe_sel} exe_fun=${decoder1.io.decoded.exe_fun}\n")
    }
    when (reg_in2.valid) {
      printf(cf"decoder pc      : 0x${reg_in2.pc.pc_to_word}%x\n")
      printf(cf"decoder inst    : 0x${reg_in2.inst}%x\n")
      printf(cf"decoder inst_id : 0x${reg_in2.inst_id.getOrElse(0)}%x\n")
      printf(cf"decoder exe_sel=${decoder2.io.decoded.exe_sel} exe_fun=${decoder2.io.decoded.exe_fun}\n")
    }
    // printf(cf"decoder put en = ${reg_in.valid}\n")
    // printf(cf"decoder put iq_id = 0x${reg_in.iq_id}%x\n")
  }

  val id1_in1 = Wire(new Id1Input(iq_id_len))
  id1_in1.valid := io.in1.valid && iq.io.enq1.ready && (!io.flush && !io.stall)
  id1_in1.pc    := io.in1.pc
  id1_in1.inst  := io.in1.inst
  id1_in1.iq_id := iq.io.enq1.iq_id
  map2(id1_in1.inst_id, io.in1.inst_id)(_ := _)
  val id1_in2 = Wire(new Id1Input(iq_id_len))
  id1_in2.valid := io.in2.valid && iq.io.enq2.ready && (!io.flush && !io.stall)
  id1_in2.pc    := io.in2.pc
  id1_in2.inst  := io.in2.inst
  id1_in2.iq_id := iq.io.enq2.iq_id
  map2(id1_in2.inst_id, io.in2.inst_id)(_ := _)

  id1(id1_in1, id1_in2)

  def id2: Unit = {
    val lsq1_en = WireDefault(false.B)
    io.lsa1.en    := false.B
    when (iq.io.read1.valid) {
      when (
        (iq.io.read1.decoded.exe_sel === EXE_ST || iq.io.read1.decoded.exe_sel === EXE_LD) ||
        (iq.io.read1.decoded.exe_sel === EXE_CSR && PAT_FENCE.matches(iq.io.read1.decoded.exe_fun))
      ) {
        io.lsa1.en := (!io.flush && !io.stall)
        when (io.lsa1.valid) {
          printf(cf"iq lsq alloc1, exe_sel=${iq.io.read1.decoded.exe_sel} exe_fun=${iq.io.read1.decoded.exe_fun} lsq_id=${io.lsa1.lsq_id}\n")
          printf(cf"iq lsq inst_id=0x${iq.io.read1.decoded.inst_id.getOrElse(0)}%x\n")
          lsq1_en := true.B
        }
      }.otherwise {
        lsq1_en := true.B
      }
    }
    iq.io.lsq1.en         := lsq1_en
    iq.io.lsq1.lsq.lsq_id := io.lsa1.lsq_id

    io.lsa2.en    := false.B
    iq.io.lsq2.en := false.B
    when (iq.io.read2.valid && lsq1_en) {
      when (
        (iq.io.read2.decoded.exe_sel === EXE_ST || iq.io.read2.decoded.exe_sel === EXE_LD) ||
        (iq.io.read2.decoded.exe_sel === EXE_CSR && PAT_FENCE.matches(iq.io.read2.decoded.exe_fun))
      ) {
        io.lsa2.en := (!io.flush && !io.stall)
        when (io.lsa2.valid) {
          printf(cf"iq lsq alloc2, exe_sel=${iq.io.read2.decoded.exe_sel} exe_fun=${iq.io.read2.decoded.exe_fun} lsq_id=${io.lsa2.lsq_id}\n")
          printf(cf"iq lsq inst_id=0x${iq.io.read2.decoded.inst_id.getOrElse(0)}%x\n")
          iq.io.lsq2.en := true.B
        }
      }.otherwise {
        iq.io.lsq2.en := true.B
      }
    }
    iq.io.lsq2.lsq.lsq_id := io.lsa2.lsq_id

    io.pipeline_probe.id2a_valid.foreach(_ := iq.io.read1.valid)
    map2(io.pipeline_probe.id2a_inst_id, iq.io.read1.decoded.inst_id)(_ := _)
    io.pipeline_probe.id2b_valid.foreach(_ := iq.io.read2.valid)
    map2(io.pipeline_probe.id2b_inst_id, iq.io.read2.decoded.inst_id)(_ := _)
  }

  id2

  def id3: Unit = {
    iq.io.peek1.iq_id := iq.io.peek_range.first
    iq.io.peek2.iq_id := iq.io.peek_range.first + 1.U

    iq.io.upd_peek.en  := iq.io.peek1.valid && io.out1.ready
    iq.io.upd_peek.ptr := iq.io.peek_range.first + Mux(iq.io.peek2.valid && io.out2.ready, 2.U, 1.U)

    io.out1.valid   := iq.io.peek1.valid && (!io.flush && !io.stall)
    io.out1.initial := iq.io.peek1.initial
    io.out1.decoded := iq.io.peek1.decoded
    io.out1.lsq     := iq.io.peek1.lsq
    io.out1.rob_id  := iq.io.peek_range.first
    io.out2.valid   := iq.io.peek2.valid && (!io.flush && !io.stall)
    io.out2.initial := iq.io.peek2.initial
    io.out2.decoded := iq.io.peek2.decoded
    io.out2.lsq     := iq.io.peek2.lsq
    io.out2.rob_id  := iq.io.peek_range.first + 1.U

    // printf(cf"decoder ready      = ${io.out.ready}\n")
    // printf(cf"decoder peek valid = ${iq.io.peek.valid}\n")
    // printf(cf"decoder deq        = 0x${iq.io.peek_range.first + 1.U}%x\n")
    // printf(cf"decoder deq first  = 0x${iq.io.peek_range.first}%x\n")
    // printf(cf"decoder deq last   = 0x${iq.io.peek_range.last}%x\n")
  }

  id3
}
