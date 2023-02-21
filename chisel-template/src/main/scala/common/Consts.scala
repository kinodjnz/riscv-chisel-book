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
  val ALU_SLL     =  5.U(EXE_FUN_LEN.W)
  val ALU_SRL     =  6.U(EXE_FUN_LEN.W)
  val ALU_SRA     =  7.U(EXE_FUN_LEN.W)
  val ALU_SLT     =  8.U(EXE_FUN_LEN.W)
  val ALU_SLTU    =  9.U(EXE_FUN_LEN.W)

  val ALU_MAX     = 10.U(EXE_FUN_LEN.W)
  val ALU_MAXU    = 11.U(EXE_FUN_LEN.W)
  val ALU_MIN     = 12.U(EXE_FUN_LEN.W)
  val ALU_MINU    = 13.U(EXE_FUN_LEN.W)
  val ALU_XNOR    = 14.U(EXE_FUN_LEN.W)
  val ALU_ANDN    = 15.U(EXE_FUN_LEN.W)
  val ALU_ORN     = 16.U(EXE_FUN_LEN.W)

  val ALU_ROL     = 1.U(EXE_FUN_LEN.W)
  val ALU_ROR     = 2.U(EXE_FUN_LEN.W)
  val ALU_CLZ     = 5.U(EXE_FUN_LEN.W)
  val ALU_CTZ     = 6.U(EXE_FUN_LEN.W)
  val ALU_CPOP    = 7.U(EXE_FUN_LEN.W)
  val ALU_REV8    = 8.U(EXE_FUN_LEN.W)
  val ALU_SEXTB   = 9.U(EXE_FUN_LEN.W)
  val ALU_SEXTH   = 10.U(EXE_FUN_LEN.W)
  val ALU_ZEXTH   = 11.U(EXE_FUN_LEN.W)
  val ALU_ORCB    = 12.U(EXE_FUN_LEN.W)

  val ALU_JALR    = 17.U(EXE_FUN_LEN.W)
  val ALU_COPY1   = 18.U(EXE_FUN_LEN.W)
  val ALU_VADDVV  = 19.U(EXE_FUN_LEN.W)
  val VSET        = 20.U(EXE_FUN_LEN.W)
  val ALU_PCNT    = 21.U(EXE_FUN_LEN.W)

  val BR_BEQ      = 18.U(EXE_FUN_LEN.W)
  val BR_BNE      = 19.U(EXE_FUN_LEN.W)
  val BR_BLT      = 20.U(EXE_FUN_LEN.W)
  val BR_BGE      = 21.U(EXE_FUN_LEN.W)
  val BR_BLTU     = 22.U(EXE_FUN_LEN.W)
  val BR_BGEU     = 23.U(EXE_FUN_LEN.W)

  val ALU_MUL     = 8.U(EXE_FUN_LEN.W)
  val ALU_MULH    = 9.U(EXE_FUN_LEN.W)
  val ALU_MULHU   = 10.U(EXE_FUN_LEN.W)
  val ALU_MULHSU  = 11.U(EXE_FUN_LEN.W)
  val ALU_DIV     = 12.U(EXE_FUN_LEN.W)
  val ALU_REM     = 13.U(EXE_FUN_LEN.W)
  val ALU_DIVU    = 14.U(EXE_FUN_LEN.W)
  val ALU_REMU    = 15.U(EXE_FUN_LEN.W)

  val CMD_ECALL   = 24.U(EXE_FUN_LEN.W)
  val CMD_MRET    = 25.U(EXE_FUN_LEN.W)

  val OP1_LEN    = 3
  val OP1_RS1    = 0.U(OP1_LEN.W)
  val OP1_PC     = 1.U(OP1_LEN.W)
  val OP1_X      = 2.U(OP1_LEN.W)
  val OP1_Z      = 2.U(OP1_LEN.W)
  val OP1_IMZ    = 3.U(OP1_LEN.W)
  val OP1_C_RS1  = 4.U(OP1_LEN.W)
  val OP1_C_SP   = 5.U(OP1_LEN.W)
  val OP1_C_RS1P = 6.U(OP1_LEN.W)

  val OP2_LEN     = 4
  val OP2_X       = 0.U(OP2_LEN.W)
  val OP2_Z       = 0.U(OP2_LEN.W)
  val OP2_RS2     = 1.U(OP2_LEN.W)
  val OP2_IMI     = 2.U(OP2_LEN.W)
  val OP2_IMS     = 3.U(OP2_LEN.W)
  val OP2_IMJ     = 4.U(OP2_LEN.W)
  val OP2_IMU     = 5.U(OP2_LEN.W)
  val OP2_C_RS2   = 6.U(OP2_LEN.W)
  val OP2_C_RS2P  = 7.U(OP2_LEN.W)
  val OP2_C_IMIW  = 8.U(OP2_LEN.W)
  val OP2_C_IMI16 = 9.U(OP2_LEN.W)
  val OP2_C_IMI   = 10.U(OP2_LEN.W)
  val OP2_C_IMLS  = 11.U(OP2_LEN.W)
  val OP2_C_IMIU  = 12.U(OP2_LEN.W)
  val OP2_C_IMJ   = 13.U(OP2_LEN.W)
  val OP2_C_IMSL  = 14.U(OP2_LEN.W)
  val OP2_C_IMSS  = 15.U(OP2_LEN.W)

  val MEN_LEN = 2
  val MEN_X   = 0.U(MEN_LEN.W)
  val MEN_S   = 1.U(MEN_LEN.W) // スカラ命令用
  val MEN_V   = 2.U(MEN_LEN.W) // ベクトル命令用
  val MEN_FENCE = 3.U(MEN_LEN.W)

  val REN_LEN = 1
  val REN_X   = 0.U(REN_LEN.W)
  val REN_S   = 1.U(REN_LEN.W) // スカラ命令用
  val REN_V   = 1.U(REN_LEN.W) // ベクトル命令用

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
  val CSR_E   = 0.U(CSR_LEN.W)
  val CSR_V   = 0.U(CSR_LEN.W)
  val CSR_R   = 0.U(CSR_LEN.W)

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
  val BTB_TAG_LEN      = WORD_LEN - BTB_TAG_IGNORE - BTB_INDEX_BITS
  val PHT_INDEX_BITS   = 13
  val PHT_INDEX_LEN    = 1 << PHT_INDEX_BITS
}
