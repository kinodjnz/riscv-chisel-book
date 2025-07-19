package common

import chisel3._
import chisel3.util._
import common.UIntExtension._

object Consts {
  val WORD_LEN        = 32
  val IALIGN_LEN      = 16
  val PC_LEN          = WORD_LEN - log2Ceil(IALIGN_LEN / 8)
  val FETCH_BLOCK_LEN = 64
  val IALIGN_PTR_LEN  = log2Ceil(FETCH_BLOCK_LEN / IALIGN_LEN)
  val START_ADDR      = 0.U(WORD_LEN.W)
  val BUBBLE          = 0x00000013.U(WORD_LEN.W)  // [ADDI x0,x0,0] = BUBBLE
  val UNIMP           = "x_c0001073".U(WORD_LEN.W) // [CSRRW x0, cycle, x0]
  val BPFAILURE       = 0x00100013.U(WORD_LEN.W) // [ADDI x0,x0,1]
  val ADDR_LEN        = 5 // rs1,rs2,wb
  val CSR_ADDR_LEN    = 12
  val INST_ID_LEN     = 32
  val IQ_ENTRIES      = 16
  val IQ_ID_LEN       = log2Ceil(IQ_ENTRIES)
  val LSQ_ENTRIES     = 4
  val LSQ_ID_LEN      = log2Ceil(LSQ_ENTRIES)

  val EXE_SEL_LEN = 3
  val EXE_ALU = 0.U(EXE_SEL_LEN.W)
  val EXE_MD  = 1.U(EXE_SEL_LEN.W)
  val EXE_BLU = 2.U(EXE_SEL_LEN.W)
  val EXE_CSR = 3.U(EXE_SEL_LEN.W)
  val EXE_ST  = 4.U(EXE_SEL_LEN.W)
  val EXE_LD  = 5.U(EXE_SEL_LEN.W)
  val EXE_JB  = 7.U(EXE_SEL_LEN.W)

  val EXE_FUN_LEN = 4

  val ALU_X     =  0.U(EXE_FUN_LEN.W)
  val ALU_ADD   =  0.U(EXE_FUN_LEN.W)
  val ALU_SLT   =  1.U(EXE_FUN_LEN.W)
  val ALU_AND   =  2.U(EXE_FUN_LEN.W)
  val ALU_OR    =  3.U(EXE_FUN_LEN.W)
  val ALU_FSL   =  4.U(EXE_FUN_LEN.W)
  val ALU_FSR   =  5.U(EXE_FUN_LEN.W)
  val ALU_SUB   =  6.U(EXE_FUN_LEN.W)
  val ALU_XOR   =  7.U(EXE_FUN_LEN.W)
  val ALU_SEQ   =  8.U(EXE_FUN_LEN.W)
  val ALU_CMOV  =  9.U(EXE_FUN_LEN.W)
  val ALU_MIN   = 10.U(EXE_FUN_LEN.W)
  val ALU_MAX   = 11.U(EXE_FUN_LEN.W)
  val ALU_BEXT  = 12.U(EXE_FUN_LEN.W)
  val ALU_SZEXT = 13.U(EXE_FUN_LEN.W)
  val ALU_BCLR  = 14.U(EXE_FUN_LEN.W)
  val ALU_BSET  = 15.U(EXE_FUN_LEN.W)

  val BLU_BFP     =  4.U(EXE_FUN_LEN.W)
  val BLU_BFX     =  5.U(EXE_FUN_LEN.W)
  val BLU_BFM     =  6.U(EXE_FUN_LEN.W)
  val BLU_BF_     =  7.U(EXE_FUN_LEN.W)
  val BLU_CPOP    =  8.U(EXE_FUN_LEN.W)
  val BLU_REV8    =  9.U(EXE_FUN_LEN.W)
  val BLU_CLZ     = 10.U(EXE_FUN_LEN.W)
  val BLU_CTZ     = 11.U(EXE_FUN_LEN.W)
  val BLU_GORC    = 12.U(EXE_FUN_LEN.W)
  val BLU_BSCTH   = 13.U(EXE_FUN_LEN.W)
  val BLU_BINV    = 14.U(EXE_FUN_LEN.W)

  val PAT_BFM_BFP = BitPat("b01?0")
  val PAT_BFX     = BitPat("b01?1")
  val PAT_BF      = BitPat("b01??")

  val PAT_CLU_FUN = BitPat("b0???")

  val JB_OTHER    =  0.U(EXE_FUN_LEN.W)
  val JB_DJUMP    =  2.U(EXE_FUN_LEN.W)
  val JB_DCALL    =  3.U(EXE_FUN_LEN.W)
  val JB_RET      =  1.U(EXE_FUN_LEN.W)
  val JB_BPFAIL   =  7.U(EXE_FUN_LEN.W)
  val JB_BEQ      =  8.U(EXE_FUN_LEN.W)
  val JB_BLT      =  9.U(EXE_FUN_LEN.W)
  val JB_BGE      = 10.U(EXE_FUN_LEN.W)

  val PAT_BEQ     = BitPat("b1?00")
  val PAT_BLT     = BitPat("b1?01")
  val PAT_BGE     = BitPat("b1?10")
  val PAT_BR      = BitPat("b1???")

  val MD_MUL     =  8.U(EXE_FUN_LEN.W)
  val MD_MULH    =  9.U(EXE_FUN_LEN.W)
  val MD_MULHU   = 10.U(EXE_FUN_LEN.W)
  val MD_MULHSU  = 11.U(EXE_FUN_LEN.W)
  val MD_DIV     = 12.U(EXE_FUN_LEN.W)
  val MD_REM     = 13.U(EXE_FUN_LEN.W)
  val MD_DIVU    = 14.U(EXE_FUN_LEN.W)
  val MD_REMU    = 15.U(EXE_FUN_LEN.W)

  val PAT_MULHS1       = BitPat("b???1")
  val PAT_MULHS2       = BitPat("b??0?")
  val PAT_DIVREM       = BitPat("b?1??")
  val PAT_DIV_SIGNED   = BitPat("b??0?")
  val PAT_DIV_UNSIGNED = BitPat("b??1?")

  val CSR_W      =  1.U(EXE_FUN_LEN.W)
  val CSR_S      =  2.U(EXE_FUN_LEN.W)
  val CSR_C      =  3.U(EXE_FUN_LEN.W)
  val CSR_FENCEI =  7.U(EXE_FUN_LEN.W)
  val CSR_ECALL  = 14.U(EXE_FUN_LEN.W)
  val CSR_MRET   = 15.U(EXE_FUN_LEN.W)

  val PAT_FENCE = BitPat("b01??")

  val F_MW_X  = 0.U(EXE_FUN_LEN.W)
  val F_MW_W  = 0.U(EXE_FUN_LEN.W)
  val F_MW_B  = 1.U(EXE_FUN_LEN.W)
  val F_MW_H  = 2.U(EXE_FUN_LEN.W)
  val F_MW_BU = 5.U(EXE_FUN_LEN.W)
  val F_MW_HU = 6.U(EXE_FUN_LEN.W)

  val MW_LEN = 3
  val MW_X  = F_MW_X.take(MW_LEN)
  val MW_W  = F_MW_W.take(MW_LEN)
  val MW_B  = F_MW_B.take(MW_LEN)
  val MW_H  = F_MW_H.take(MW_LEN)
  val MW_BU = F_MW_BU.take(MW_LEN)
  val MW_HU = F_MW_HU.take(MW_LEN)

  val SOP_LEN  = 1
  val SOP_NOP  = 0.U(SOP_LEN.W)
  val SOP_MIN  = 0.U(SOP_LEN.W)
  val SOP_UNS  = 0.U(SOP_LEN.W)
  val SOP_NOT  = 1.U(SOP_LEN.W)
  val SOP_ZERO = 1.U(SOP_LEN.W)
  val SOP_SHAD = 1.U(SOP_LEN.W)
  val SOP_MAX  = 1.U(SOP_LEN.W)
  val SOP_SEXT = 1.U(SOP_LEN.W)
  val SOP_SGN  = 1.U(SOP_LEN.W)

  val EX2_FUN_LEN = 3
  val EX2_ALU   = 0.U(EX2_FUN_LEN.W)
  val EX2_MD    = 1.U(EX2_FUN_LEN.W)
  val EX2_BLU   = 2.U(EX2_FUN_LEN.W)
  val EX2_CSR   = 3.U(EX2_FUN_LEN.W)
  val EX2_X_ALU = 4.U(EX2_FUN_LEN.W)
  val EX2_X_MD  = 5.U(EX2_FUN_LEN.W)
  val EX2_MASK  = 6.U(EX2_FUN_LEN.W)
  val EX2_X_CSR = 7.U(EX2_FUN_LEN.W)

  val PAT_EX2_CSR  = BitPat("b?11")
  val PAT_EX2_MD   = BitPat("b?01")
  val PAT_EX2_BLU  = BitPat("b01?")
  val PAT_EX2_MASK = BitPat("b11?")

  val OP1_SEL_LEN = 2
  val OP1_SEL_RS   = 0.U(OP1_SEL_LEN.W)
  val OP1_SEL_PC   = 1.U(OP1_SEL_LEN.W)
  val OP1_SEL_Z    = 2.U(OP1_SEL_LEN.W)
  val OP1_SEL_IMR  = 3.U(OP1_SEL_LEN.W)

  val OP2_SEL_LEN = 2
  val OP2_SEL_RS  = 0.U(OP2_SEL_LEN.W)
  val OP2_SEL_MIX = 1.U(OP2_SEL_LEN.W)
  val OP2_SEL_Z   = 2.U(OP2_SEL_LEN.W)
  val OP2_SEL_IMM = 3.U(OP2_SEL_LEN.W)

  val OP2_IMM_I = 0.U(ADDR_LEN.W)
  val OP2_IMM_B = 1.U(ADDR_LEN.W)
  val OP2_IMM_U = 2.U(ADDR_LEN.W)
  val OP2_IMM_J = 3.U(ADDR_LEN.W)

  // val PAT_OP2_IMI = BitPat("b???00")
  // val PAT_OP2_IMU = BitPat("b???01")
  // val PAT_OP2_IMJ = BitPat("b???10")
  // val PAT_OP2_IMB = BitPat("b???11")

  val OP3_SEL_LEN = 2
  val OP3_SEL_RS   = 0.U
  val OP3_SEL_RMSB = 1.U
  val OP3_SEL_Z    = 2.U
  val OP3_SEL_IMBC = 3.U
  
  val OP1_LEN    = 4
  val OP1_RS1    =  0.U(OP1_LEN.W)
  val OP1_C_RS1  =  1.U(OP1_LEN.W)
  val OP1_C_SP   =  2.U(OP1_LEN.W)
  val OP1_C_RS1P =  3.U(OP1_LEN.W)
  val OP1_PC     =  4.U(OP1_LEN.W)
  val OP1_C_PC1  =  5.U(OP1_LEN.W)
  val OP1_C_PC1P =  7.U(OP1_LEN.W)
  val OP1_Z      =  8.U(OP1_LEN.W)
  val OP1_X      =  8.U(OP1_LEN.W)
  val OP1_C_Z1   =  9.U(OP1_LEN.W)
  val OP1_C_Z1P  = 11.U(OP1_LEN.W)
  val OP1_IM0    = 12.U(OP1_LEN.W)

  val OP2_LEN    = 5
  val OP2_RS2    =  0.U(OP2_LEN.W)
  val OP2_C_RS1P =  1.U(OP2_LEN.W)
  val OP2_C_RS2P =  2.U(OP2_LEN.W)
  val OP2_C_RS3P =  3.U(OP2_LEN.W)
  val OP2_C_RS2  =  4.U(OP2_LEN.W)
  val OP2_RS2MIX =  8.U(OP2_LEN.W)
  val OP2_Z      = 16.U(OP2_LEN.W)
  val OP2_X      = 16.U(OP2_LEN.W)
  val OP2_C_Z2P  = 18.U(OP2_LEN.W)
  val OP2_C_Z3P  = 19.U(OP2_LEN.W)
  val OP2_C_Z2   = 20.U(OP2_LEN.W)
  val OP2_IMM    = 24.U(OP2_LEN.W)
  val OP2_C_IM2P = 26.U(OP2_LEN.W)
  val OP2_C_IM3P = 27.U(OP2_LEN.W)
  val OP2_C_IM2  = 28.U(OP2_LEN.W)

  val OP3_LEN    = 5
  val OP3_RS1    =  0.U(OP3_LEN.W)
  val OP3_RS2    =  1.U(OP3_LEN.W)
  val OP3_RS3    =  2.U(OP3_LEN.W)
  val OP3_C_RS2P =  3.U(OP3_LEN.W)
  val OP3_C_RS2  =  4.U(OP3_LEN.W)
  val OP3_MSB    =  8.U(OP3_LEN.W)
  val OP3_C_M2P  = 11.U(OP3_LEN.W)
  val OP3_Z      = 16.U(OP3_LEN.W)
  val OP3_X      = 16.U(OP3_LEN.W)
  val OP3_X2     = 17.U(OP3_LEN.W)
  val OP3_Z3     = 18.U(OP3_LEN.W)
  val OP3_X3     = 18.U(OP3_LEN.W)
  val OP3_C_Z2P  = 19.U(OP3_LEN.W)
  val OP3_C_X2P  = 19.U(OP3_LEN.W)
  val OP3_C_X2   = 20.U(OP3_LEN.W)
  val OP3_IMF    = 21.U(OP3_LEN.W)
  val OP3_C_X2PB = 27.U(OP3_LEN.W)

  val IMM_DATA_LEN = 12

  val OPI_LEN     = 7
  val OPI_X       =  0.U(OPI_LEN.W)
  val OPI_IMI     =  0.U(OPI_LEN.W)
  val OPI_IMB     = 32.U(OPI_LEN.W)
  val OPI_IMU     = 64.U(OPI_LEN.W)
  val OPI_IMJ     = 96.U(OPI_LEN.W)
  val OPI_IMS     =  1.U(OPI_LEN.W)
  val OPI_BFIC    =  2.U(OPI_LEN.W)
  // val OPI_BFI     =  0.U(OPI_LEN.W)
  val OPI_BFI     =  9.U(OPI_LEN.W)
  val OPI_EXTH    =  3.U(OPI_LEN.W)
  val OPI_EXTB    =  4.U(OPI_LEN.W)
  val OPI_C_IMIW  =  5.U(OPI_LEN.W)
  val OPI_C_IMI16 =  6.U(OPI_LEN.W)
  val OPI_C_IMI   =  7.U(OPI_LEN.W)
  val OPI_C_X     =  7.U(OPI_LEN.W)
  val OPI_C_IMJ   =  8.U(OPI_LEN.W)
  val OPI_C_IMIU  = 66.U(OPI_LEN.W)
  val OPI_C_IMU   = 65.U(OPI_LEN.W)
  val OPI_C_IMB   = 10.U(OPI_LEN.W)
  val OPI_C_IMB2  = 11.U(OPI_LEN.W)
  val OPI_C_IMA2W = 12.U(OPI_LEN.W)
  val OPI_C_IMA2B = 13.U(OPI_LEN.W)
  val OPI_C_XA2B  = 13.U(OPI_LEN.W)
  val OPI_C_IMLS  = 14.U(OPI_LEN.W)
  val OPI_C_IMSPL = 15.U(OPI_LEN.W)
  val OPI_C_IMSPS = 16.U(OPI_LEN.W)
  val OPI_C_XSPS  = 16.U(OPI_LEN.W)
  val OPI_C_IMLSB = 17.U(OPI_LEN.W)
  val OPI_C_IMLSH = 18.U(OPI_LEN.W)
  val OPI_C_IMSW0 = 19.U(OPI_LEN.W)
  val OPI_C_IMSB0 = 20.U(OPI_LEN.W)
  val OPI_C_IMSH0 = 21.U(OPI_LEN.W)
  val OPI_C_EXTH  = 22.U(OPI_LEN.W)
  val OPI_C_EXTB  = 23.U(OPI_LEN.W)

  val REN_LEN = 1
  val REN_X   = 0.U(REN_LEN.W)
  val REN_S   = 1.U(REN_LEN.W)

  val WBA_LEN = 3
  val WBA_RD  = 0.U(WBA_LEN.W)
  val WBA_C   = 1.U(WBA_LEN.W)
  val WBA_CP1 = 2.U(WBA_LEN.W)
  val WBA_CP2 = 3.U(WBA_LEN.W)
  val WBA_RA  = 4.U(WBA_LEN.W)

  val MEM_OP_LEN = 2
  val MEM_OP_ST    = 0.U(MEM_OP_LEN.W)
  val MEM_OP_LD    = 1.U(MEM_OP_LEN.W)
  val MEM_OP_FENCE = 3.U(MEM_OP_LEN.W)

  val CSR_ADDR_MSTATUS  = 0x300.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MIE      = 0x304.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MTVEC    = 0x305.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MSCRATCH = 0x340.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MEPC     = 0x341.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MCAUSE   = 0x342.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MTVAL    = 0x343.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_MIP      = 0x344.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_CYCLE    = 0xc00.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_TIME     = 0xc01.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_INSTRET  = 0xc02.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_CYCLEH   = 0xc80.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_TIMEH    = 0xc81.U(CSR_ADDR_LEN.W)
  val CSR_ADDR_INSTRETH = 0xc82.U(CSR_ADDR_LEN.W)

  val CSR_MCAUSE_X       = 7.U(WORD_LEN.W)
  val CSR_MCAUSE_MEI     = (0x80000000L + 11L).U(WORD_LEN.W)
  val CSR_MCAUSE_MTI     = (0x80000000L + 7L).U(WORD_LEN.W)
  val CSR_MCAUSE_ECALL_M = 11.U(WORD_LEN.W)

  val CSR_MCAUSE_CODE_LEN = 2
  val CSR_MCAUSE_CODE_X       = 0.U(CSR_MCAUSE_CODE_LEN.W)
  val CSR_MCAUSE_CODE_MEI     = 1.U(CSR_MCAUSE_CODE_LEN.W)
  val CSR_MCAUSE_CODE_MTI     = 2.U(CSR_MCAUSE_CODE_LEN.W)
  val CSR_MCAUSE_CODE_ECALL_M = 3.U(CSR_MCAUSE_CODE_LEN.W)

  val BP_HIST_LEN   = 2
  val BP_INDEX_LEN  = 8
  val BP_TAG_LEN    = 23
  val BP_BRANCH_LEN = WORD_LEN
  val BP_CACHE_LEN  = 256

  val ZBTB_ENTRIES      = 32
  val ZBTB_TAG_LEN      = 8
  val ZBTB_TARGET_LEN   = PC_LEN
  val BTB_INDEX_LEN     = 10
  val BTB_ENTRIES       = 1 << BTB_INDEX_LEN
  val BTB_TAG_IGNORE    = 4 // ignore leading 4 bits of pc
  // val BTB_TAG_LEN       = PC_LEN - BTB_TAG_IGNORE - BTB_INDEX_LEN
  val BTB_ATTR_LEN      = 2
  val BTB_ATTR_INVAL    = 0.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_BR       = 1.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_DJUMP    = 2.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_DCALL    = 3.U(BTB_ATTR_LEN.W)
  // val BTB_ENTRY_LEN     = BTB_TAG_LEN + BTB_ATTR_LEN + PC_LEN
  val PHT_HISTORY_LEN   = 6
  val PHT_HISTORY_SHIFT = 2
  val PHT_INDEX_LEN     = 13
  // val PHT_HISTORY_BITS  = 36
  // val PHT_HISTORY_SHIFT = 12
  // val PHT_INDEX_LEN     = 36+6
  val RAS_INDEX_LEN     = 2
  val RAS_ENTRIES       = (1 << RAS_INDEX_LEN)
  val GCNT_NOT_BRANCH   = 1.U(2.W)
  val REDIRECT_BUFFER_SIZE = 4
}
