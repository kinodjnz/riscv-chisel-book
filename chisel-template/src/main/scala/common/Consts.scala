package common

import chisel3._
import chisel3.util._

object Consts {
  val WORD_LEN      = 32
  val IALIGN_LEN    = 16
  val IBLOCK_LEN    = 64
  val IBLOCK_BITS   = log2Ceil(IBLOCK_LEN / 8)
  val START_ADDR    = 0.U(WORD_LEN.W)
  val BUBBLE        = 0x00000013.U(WORD_LEN.W)  // [ADDI x0,x0,0] = BUBBLE
  val UNIMP         = "x_c0001073".U(WORD_LEN.W) // [CSRRW x0, cycle, x0]
  val ADDR_LEN      = 5 // rs1,rs2,wb
  val CSR_ADDR_LEN  = 12
  val INST_ID_LEN   = 32
  val FETCH_BUFFER_SIZE = 4
  val FETCH_PTR_LEN = log2Ceil(FETCH_BUFFER_SIZE)
  val IALIGN_PTR_LEN = log2Ceil(IBLOCK_LEN / IALIGN_LEN)
  val BPFAILURE      = 0x00100013.U(WORD_LEN.W) // [ADDI x0,x0,1]

  val EXE_FUN_LEN = 4
  val ALU_X     =  0.U(EXE_FUN_LEN.W)
  val ALU_ADD   =  0.U(EXE_FUN_LEN.W)
  val ALU_XOR   =  1.U(EXE_FUN_LEN.W)
  val ALU_AND   =  2.U(EXE_FUN_LEN.W)
  val ALU_OR    =  3.U(EXE_FUN_LEN.W)
  val ALU_FSL   =  4.U(EXE_FUN_LEN.W)
  val ALU_FSR   =  5.U(EXE_FUN_LEN.W)
  val ALU_SUB   =  6.U(EXE_FUN_LEN.W)
  val ALU_SZEXT =  7.U(EXE_FUN_LEN.W)
  val ALU_SLT   =  8.U(EXE_FUN_LEN.W)
  val ALU_SEQ   =  9.U(EXE_FUN_LEN.W)
  val ALU_MIN   = 10.U(EXE_FUN_LEN.W)
  val ALU_MAX   = 11.U(EXE_FUN_LEN.W)
  val ALU_BEXT  = 12.U(EXE_FUN_LEN.W)
  val ALU_CMOV  = 13.U(EXE_FUN_LEN.W)
  val ALU_BCLR  = 14.U(EXE_FUN_LEN.W)
  val ALU_BSET  = 15.U(EXE_FUN_LEN.W)

  val ALU_BINV    =  1.U(EXE_FUN_LEN.W)
  val ALU_GORC    =  2.U(EXE_FUN_LEN.W)
  val ALU_BSCTH   =  3.U(EXE_FUN_LEN.W)
  val ALU_BFP     =  4.U(EXE_FUN_LEN.W)
  val ALU_BFX     =  5.U(EXE_FUN_LEN.W)
  val ALU_BFM     =  6.U(EXE_FUN_LEN.W)
  val ALU_BF_     =  7.U(EXE_FUN_LEN.W)
  val ALU_CPOP    =  8.U(EXE_FUN_LEN.W)
  val ALU_REV8    =  9.U(EXE_FUN_LEN.W)
  val ALU_CLZ     = 10.U(EXE_FUN_LEN.W)
  val ALU_CTZ     = 11.U(EXE_FUN_LEN.W)

  val BR_BLT      =  8.U(EXE_FUN_LEN.W)
  val BR_BEQ      =  9.U(EXE_FUN_LEN.W)
  val BR_BGE      = 10.U(EXE_FUN_LEN.W)

  val PAT_BLT     = BitPat("b??00")
  val PAT_BEQ     = BitPat("b??01")
  val PAT_BGE     = BitPat("b??10")

  val ALU_MUL     =  8.U(EXE_FUN_LEN.W)
  val ALU_MULH    =  9.U(EXE_FUN_LEN.W)
  val ALU_MULHU   = 10.U(EXE_FUN_LEN.W)
  val ALU_MULHSU  = 11.U(EXE_FUN_LEN.W)
  val ALU_DIV     = 12.U(EXE_FUN_LEN.W)
  val ALU_REM     = 13.U(EXE_FUN_LEN.W)
  val ALU_DIVU    = 14.U(EXE_FUN_LEN.W)
  val ALU_REMU    = 15.U(EXE_FUN_LEN.W)

  val CMD_ECALL   = 14.U(EXE_FUN_LEN.W)
  val CMD_MRET    = 15.U(EXE_FUN_LEN.W)

  val OP1_LEN    = 3
  val OP1_Z      = 0.U(OP1_LEN.W)
  val OP1_X      = 0.U(OP1_LEN.W)
  val OP1_PC     = 1.U(OP1_LEN.W)
  val OP1_IM0    = 2.U(OP1_LEN.W)
  val OP1_RS1    = 4.U(OP1_LEN.W)
  val OP1_C_RS1  = 5.U(OP1_LEN.W)
  val OP1_C_SP   = 6.U(OP1_LEN.W)
  val OP1_C_RS1P = 7.U(OP1_LEN.W)

  val M_OP1_LEN = 2
  val M_OP1_Z   = 0.U(M_OP1_LEN.W)
  val M_OP1_RS  = 1.U(M_OP1_LEN.W)
  val M_OP1_IM0 = 2.U(M_OP1_LEN.W)
  val M_OP1_PC  = 3.U(M_OP1_LEN.W)

  val OPI_LEN     = 5
  // 12 bit imm
  val OPI_X       =  0.U(OPI_LEN.W)
  val OPI_IMZ     =  1.U(OPI_LEN.W)
  val OPI_C_IMIW  =  2.U(OPI_LEN.W)
  val OPI_C_IMLS  =  3.U(OPI_LEN.W)
  val OPI_C_IMSL  =  4.U(OPI_LEN.W)
  val OPI_C_IMSS  =  5.U(OPI_LEN.W)
  val OPI_C_IMLSB =  6.U(OPI_LEN.W)
  val OPI_C_IMLSH =  7.U(OPI_LEN.W)
  val OPI_C_IMSW0 =  8.U(OPI_LEN.W)
  val OPI_C_IMSB0 =  9.U(OPI_LEN.W)
  val OPI_C_IMSH0 = 10.U(OPI_LEN.W)
  // val OPI_IM1     = 11.U(OPI_LEN.W)
  val OPI_BFIC    = 12.U(OPI_LEN.W)
  val OPI_BFI     = 13.U(OPI_LEN.W)
  val OPI_EXTH    = 14.U(OPI_LEN.W)
  val OPI_EXTB    = 15.U(OPI_LEN.W)
  // 12 bit signed imm
  val OPI_IMS     = 16.U(OPI_LEN.W)
  val OPI_IMI     = 17.U(OPI_LEN.W)
  val OPI_C_IMI16 = 18.U(OPI_LEN.W)
  val OPI_C_IMI   = 19.U(OPI_LEN.W)
  val OPI_C_IMJ   = 20.U(OPI_LEN.W)
  val OPI_IMALL1  = 21.U(OPI_LEN.W)
  val OPI_C_IMA2W = 22.U(OPI_LEN.W)
  val OPI_C_IMA2B = 23.U(OPI_LEN.W)
  // 32 bit imm
  val OPI_IMJ     = 25.U(OPI_LEN.W)
  val OPI_IMU     = 26.U(OPI_LEN.W)
  val OPI_C_IMIU  = 27.U(OPI_LEN.W)
  val OPI_C_IMU   = 28.U(OPI_LEN.W)
  val OPI_IMB     = 29.U(OPI_LEN.W)
  val OPI_C_IMB   = 30.U(OPI_LEN.W)
  val OPI_C_IMB2  = 31.U(OPI_LEN.W)

  val OP2_LEN     = 3
  val OP2_Z       = 0.U(OP2_LEN.W)
  val OP2_X       = 0.U(OP2_LEN.W)
  val OP2_IMM     = 2.U(OP2_LEN.W)
  val OP2_RS2     = 3.U(OP2_LEN.W)
  val OP2_C_RS1P  = 4.U(OP2_LEN.W)
  val OP2_C_RS2P  = 5.U(OP2_LEN.W)
  val OP2_C_RS3P  = 6.U(OP2_LEN.W)
  val OP2_C_RS2   = 7.U(OP2_LEN.W)
  // val OP2_RS2BFIC = 46.U(OP2_LEN.W)
  // val OP2_RS2BFI  = 47.U(OP2_LEN.W)

  val M_OP2_LEN = 2
  val M_OP2_Z   = 0.U(M_OP2_LEN.W)
  val M_OP2_IMM = 1.U(M_OP2_LEN.W)
  val M_OP2_RS  = 2.U(M_OP2_LEN.W)

  val OP2OP_LEN      = 1
  val OP2OP_NOP      = 0.U(OP2OP_LEN.W)
  val OP2OP_MIN      = 0.U(OP2OP_LEN.W)
  val OP2OP_SIGNED   = 0.U(OP2OP_LEN.W)
  val OP2OP_NOT      = 1.U(OP2OP_LEN.W)
  val OP2OP_ZERO     = 1.U(OP2OP_LEN.W)
  val OP2OP_SHADD    = 1.U(OP2OP_LEN.W)
  val OP2OP_MAX      = 1.U(OP2OP_LEN.W)
  val OP2OP_SEXT     = 1.U(OP2OP_LEN.W)
  val OP2OP_UNSIGNED = 1.U(OP2OP_LEN.W)

  val OP3_LEN     = 3
  val OP3_Z       = 0.U(OP3_LEN.W)
  val OP3_X       = 0.U(OP3_LEN.W)
  val OP3_MSB     = 1.U(OP3_LEN.W)
  // val OP3_RD      = 2.U(OP3_LEN.W)
  val OP3_OP1     = 3.U(OP3_LEN.W)
  val OP3_RS2     = 4.U(OP3_LEN.W)
  val OP3_C_RS2P  = 5.U(OP3_LEN.W)
  val OP3_C_RS2   = 6.U(OP3_LEN.W)
  val OP3_RS3     = 7.U(OP3_LEN.W)

  val M_OP3_LEN = 2
  val M_OP3_Z   = 0.U(M_OP3_LEN.W)
  val M_OP3_MSB = 1.U(M_OP3_LEN.W)
  val M_OP3_RS  = 2.U(M_OP3_LEN.W)
  val M_OP3_OP1 = 3.U(M_OP3_LEN.W)

  val REN_LEN = 1
  val REN_X   = 0.U(REN_LEN.W)
  val REN_S   = 1.U(REN_LEN.W)

  val WB_SEL_LEN = 3
  val WB_X       = 0.U(WB_SEL_LEN.W)
  val WB_ALU     = 0.U(WB_SEL_LEN.W)
  val WB_MD      = 1.U(WB_SEL_LEN.W)
  val WB_PC      = 2.U(WB_SEL_LEN.W)
  val WB_CSR     = 3.U(WB_SEL_LEN.W)
  val WB_ST      = 4.U(WB_SEL_LEN.W)
  val WB_LD      = 5.U(WB_SEL_LEN.W)
  val WB_BIT     = 6.U(WB_SEL_LEN.W)
  val WB_FENCE   = 7.U(WB_SEL_LEN.W)

  val EX2_FUN_LEN = 3
  val EX2_ALU  = 0.U(EX2_FUN_LEN.W)
  val EX2_MD   = 1.U(EX2_FUN_LEN.W)
  val EX2_MASK = 2.U(EX2_FUN_LEN.W)
  val EX2_CSR  = 3.U(EX2_FUN_LEN.W)
  val EX2_ALU1 = 4.U(EX2_FUN_LEN.W)
  val EX2_MD1  = 5.U(EX2_FUN_LEN.W)
  val EX2_BIT  = 6.U(EX2_FUN_LEN.W)
  val EX2_CSR1 = 7.U(EX2_FUN_LEN.W)

  val WBA_LEN = 3
  val WBA_RD  = 0.U(WBA_LEN.W)
  val WBA_C   = 1.U(WBA_LEN.W)
  val WBA_CP1 = 2.U(WBA_LEN.W)
  val WBA_CP2 = 3.U(WBA_LEN.W)
  val WBA_RA  = 4.U(WBA_LEN.W)
  val WBA_CBR = 6.U(WBA_LEN.W)
  val WBA_CB2 = 7.U(WBA_LEN.W)

  val MW_LEN = 3
  val MW_X   = 0.U(MW_LEN.W)
  val MW_W   = 0.U(MW_LEN.W)
  val MW_BR  = 1.U(MW_LEN.W)
  val MW_CSR = 3.U(MW_LEN.W)
  val MW_H   = 4.U(MW_LEN.W)
  val MW_B   = 5.U(MW_LEN.W)
  val MW_HU  = 6.U(MW_LEN.W)
  val MW_BU  = 7.U(MW_LEN.W)

  val CSR_LEN = 2
  val CSR_X   = 0.U(CSR_LEN.W)
  val CSR_W   = 1.U(CSR_LEN.W)
  val CSR_S   = 2.U(CSR_LEN.W)
  val CSR_C   = 3.U(CSR_LEN.W)

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

  val CSR_MCAUSE_MEI     = (0x80000000L + 11L).U(WORD_LEN.W)
  val CSR_MCAUSE_MTI     = (0x80000000L + 7L).U(WORD_LEN.W)
  val CSR_MCAUSE_ECALL_M = 11.U(WORD_LEN.W)

  val CSR_MCAUSE_CODE_LEN = 1
  val CSR_MCAUSE_CODE_ECALL_M = 0.U(CSR_MCAUSE_CODE_LEN.W)

  val BP_HIST_LEN   = 2
  val BP_INDEX_LEN  = 8
  val BP_TAG_LEN    = 23
  val BP_BRANCH_LEN = WORD_LEN
  val BP_CACHE_LEN  = 256

  val PC_LEN            = WORD_LEN - 1
  val ZBTB_ENTRIES      = 32
  val ZBTB_TAG_BITS     = 8
  val ZBTB_TARGET_BITS  = PC_LEN
  val BTB_INDEX_BITS    = 10
  val BTB_INDEX_LEN     = 1 << BTB_INDEX_BITS
  val BTB_TAG_IGNORE    = 4 // ignore leading 4 bits of pc
  val BTB_TAG_LEN       = PC_LEN - BTB_TAG_IGNORE - BTB_INDEX_BITS
  val BTB_ATTR_LEN      = 2
  val BTB_ATTR_INVAL    = 0.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_BR       = 1.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_DJUMP    = 2.U(BTB_ATTR_LEN.W)
  val BTB_ATTR_DCALL    = 3.U(BTB_ATTR_LEN.W)
  val BTB_BUNDLE_LEN    = BTB_TAG_LEN + BTB_ATTR_LEN + PC_LEN
  val PHT_HISTORY_BITS  = 6
  val PHT_HISTORY_SHIFT = 2
  val PHT_INDEX_BITS    = 13
  // val PHT_HISTORY_BITS  = 36
  // val PHT_HISTORY_SHIFT = 12
  // val PHT_INDEX_BITS    = 36+6
  val PHT_INDEX_LEN     = 1 << PHT_INDEX_BITS
  val RAS_INDEX_BITS    = 3
  val RAS_ENTRIES       = (1 << RAS_INDEX_BITS)
}
