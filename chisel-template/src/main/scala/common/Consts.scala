package common

import chisel3._
import chisel3.util._

object Consts {
  val WORD_LEN      = 32
  val START_ADDR    = 0.U(WORD_LEN.W)
  val BUBBLE        = 0x00000013.U(WORD_LEN.W)  // [ADDI x0,x0,0] = BUBBLE
  val UNIMP         = "x_c0001073".U(WORD_LEN.W) // [CSRRW x0, cycle, x0]
  val ADDR_LEN      = 5 // rs1,rs2,wb
  val CSR_ADDR_LEN  = 12
  val VLEN          = 128
  val LMUL_LEN      = 2
  val SEW_LEN       = 11
  val VL_ADDR       = 0xC20
  val VTYPE_ADDR    = 0xC21

  val EXE_FUN_LEN = 5
  val ALU_X       =  0.U(EXE_FUN_LEN.W)
  val ALU_ADD     =  0.U(EXE_FUN_LEN.W)
  val ALU_SUB     =  1.U(EXE_FUN_LEN.W)
  val ALU_XOR     =  2.U(EXE_FUN_LEN.W)
  val ALU_AND     =  3.U(EXE_FUN_LEN.W)
  val ALU_OR      =  4.U(EXE_FUN_LEN.W)
  val ALU_FSL     =  5.U(EXE_FUN_LEN.W)
  val ALU_FSR     =  6.U(EXE_FUN_LEN.W)
  val ALU_SLT     =  7.U(EXE_FUN_LEN.W)
  val ALU_SLTU    =  8.U(EXE_FUN_LEN.W)

  val ALU_MAX     =  9.U(EXE_FUN_LEN.W)
  val ALU_MAXU    = 10.U(EXE_FUN_LEN.W)
  val ALU_MIN     = 11.U(EXE_FUN_LEN.W)
  val ALU_MINU    = 12.U(EXE_FUN_LEN.W)
  val ALU_XNOR    = 13.U(EXE_FUN_LEN.W)
  val ALU_ANDN    = 14.U(EXE_FUN_LEN.W)
  val ALU_ORN     = 15.U(EXE_FUN_LEN.W)

  val ALU_CLZ     =  5.U(EXE_FUN_LEN.W)
  val ALU_CTZ     =  6.U(EXE_FUN_LEN.W)
  val ALU_CPOP    =  7.U(EXE_FUN_LEN.W)
  val ALU_REV8    =  8.U(EXE_FUN_LEN.W)
  val ALU_SEXTB   =  9.U(EXE_FUN_LEN.W)
  val ALU_SEXTH   = 10.U(EXE_FUN_LEN.W)
  val ALU_ZEXTH   = 11.U(EXE_FUN_LEN.W)
  val ALU_ORCB    = 12.U(EXE_FUN_LEN.W)

  // val ALU_JALR    = 17.U(EXE_FUN_LEN.W)
  // val ALU_COPY1   = 18.U(EXE_FUN_LEN.W)
  // val ALU_VADDVV  = 19.U(EXE_FUN_LEN.W)
  // val VSET        = 20.U(EXE_FUN_LEN.W)
  // val ALU_PCNT    = 21.U(EXE_FUN_LEN.W)

  val BR_BEQ      = 18.U(EXE_FUN_LEN.W)
  val BR_BNE      = 19.U(EXE_FUN_LEN.W)
  val BR_BLT      = 20.U(EXE_FUN_LEN.W)
  val BR_BGE      = 21.U(EXE_FUN_LEN.W)
  val BR_BLTU     = 22.U(EXE_FUN_LEN.W)
  val BR_BGEU     = 23.U(EXE_FUN_LEN.W)

  val ALU_MUL     =  8.U(EXE_FUN_LEN.W)
  val ALU_MULH    =  9.U(EXE_FUN_LEN.W)
  val ALU_MULHU   = 10.U(EXE_FUN_LEN.W)
  val ALU_MULHSU  = 11.U(EXE_FUN_LEN.W)
  val ALU_DIV     = 12.U(EXE_FUN_LEN.W)
  val ALU_REM     = 13.U(EXE_FUN_LEN.W)
  val ALU_DIVU    = 14.U(EXE_FUN_LEN.W)
  val ALU_REMU    = 15.U(EXE_FUN_LEN.W)

  val CMD_ECALL   = 24.U(EXE_FUN_LEN.W)
  val CMD_MRET    = 25.U(EXE_FUN_LEN.W)

  val OP1_LEN    = 3
  val OP1_X      = 0.U(OP1_LEN.W)
  val OP1_Z      = 0.U(OP1_LEN.W)
  val OP1_PC     = 1.U(OP1_LEN.W)
  val OP1_IMZ    = 2.U(OP1_LEN.W)
  val OP1_RS1    = 4.U(OP1_LEN.W)
  val OP1_C_RS1  = 5.U(OP1_LEN.W)
  val OP1_C_SP   = 6.U(OP1_LEN.W)
  val OP1_C_RS1P = 7.U(OP1_LEN.W)

  val M_OP1_LEN = 1
  val M_OP1_RS  = 0.U(M_OP1_LEN.W)
  val M_OP1_IMM = 1.U(M_OP1_LEN.W)

  val OP2_LEN     = 5
  val OP2_X       =  0.U(OP2_LEN.W)
  val OP2_Z       =  0.U(OP2_LEN.W)
  val OP2_RS2     =  1.U(OP2_LEN.W)
  val OP2_C_RS2   =  2.U(OP2_LEN.W)
  val OP2_C_RS3P  =  3.U(OP2_LEN.W)
  val OP2_IMI     =  4.U(OP2_LEN.W)
  val OP2_RS_X    =  5.U(OP2_LEN.W)
  val OP2_C_RS2P  =  6.U(OP2_LEN.W)
  val OP2_C_RS1P  =  7.U(OP2_LEN.W)
  val OP2_IMS     =  8.U(OP2_LEN.W)
  val OP2_IMJ     =  9.U(OP2_LEN.W)
  val OP2_IMU     = 10.U(OP2_LEN.W)
  val OP2_C_IMIW  = 11.U(OP2_LEN.W)
  val OP2_C_IMI16 = 12.U(OP2_LEN.W)
  val OP2_C_IMI   = 13.U(OP2_LEN.W)
  val OP2_C_IMLS  = 14.U(OP2_LEN.W)
  val OP2_C_IMIU  = 15.U(OP2_LEN.W)
  val OP2_C_IMJ   = 16.U(OP2_LEN.W)
  val OP2_C_IMSL  = 17.U(OP2_LEN.W)
  val OP2_C_IMSS  = 18.U(OP2_LEN.W)
  val OP2_C_IMLSB = 19.U(OP2_LEN.W)
  val OP2_C_IMLSH = 20.U(OP2_LEN.W)
  val OP2_C_IMSW0 = 21.U(OP2_LEN.W)
  val OP2_C_IMSB0 = 22.U(OP2_LEN.W)
  val OP2_C_IMSH0 = 23.U(OP2_LEN.W)
  val OP2_IM255   = 24.U(OP2_LEN.W)
  val OP2_IMALL1  = 25.U(OP2_LEN.W)
  val OP2_IM1     = 26.U(OP2_LEN.W)
  val OP2_C_IMA2W = 27.U(OP2_LEN.W)
  val OP2_C_IMA2B = 28.U(OP2_LEN.W)
  val OP2_C_IMU   = 29.U(OP2_LEN.W)

  val M_OP2_LEN = 1
  val M_OP2_RS  = 0.U(M_OP2_LEN.W)
  val M_OP2_IMM = 1.U(M_OP2_LEN.W)

  val OP3_LEN     = 3
  val OP3_X       = 0.U(OP3_LEN.W)
  val OP3_Z       = 0.U(OP3_LEN.W)
  val OP3_MSB     = 1.U(OP3_LEN.W)
  val OP3_OP1     = 3.U(OP3_LEN.W)
  val OP3_RS2     = 4.U(OP3_LEN.W)
  val OP3_C_RS2P  = 5.U(OP3_LEN.W)
  val OP3_C_RS2   = 6.U(OP3_LEN.W)
  val OP3_RS2_DMY = 7.U(OP3_LEN.W)

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
  val WB_PC      = 1.U(WB_SEL_LEN.W)
  val WB_ST      = 2.U(WB_SEL_LEN.W)
  val WB_FENCE   = 3.U(WB_SEL_LEN.W)
  val WB_MD      = 4.U(WB_SEL_LEN.W)
  val WB_CSR     = 5.U(WB_SEL_LEN.W)
  val WB_LD      = 6.U(WB_SEL_LEN.W)
  val WB_BIT     = 7.U(WB_SEL_LEN.W)

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

  val BP_HIST_LEN   = 2
  val BP_INDEX_LEN  = 8
  val BP_TAG_LEN    = 23
  val BP_BRANCH_LEN = WORD_LEN
  val BP_CACHE_LEN  = 256

  val PC_LEN           = WORD_LEN - 1
  val BTB_INDEX_BITS   = 9
  val BTB_INDEX_LEN    = 1 << BTB_INDEX_BITS
  val BTB_TAG_IGNORE   = 4 // ignore leading 4 bits of pc
  val BTB_TAG_LEN      = PC_LEN - BTB_TAG_IGNORE - BTB_INDEX_BITS
  val PHT_INDEX_BITS   = 13
  val PHT_INDEX_LEN    = 1 << PHT_INDEX_BITS
}
