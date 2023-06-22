package common

import chisel3._
import chisel3.util._

object Instructions {
  // ロード・ストア
  val LB      = BitPat("b?????????????????000?????0000011")
  val LH      = BitPat("b?????????????????001?????0000011")
  val LW      = BitPat("b?????????????????010?????0000011")
  val LBU     = BitPat("b?????????????????100?????0000011")
  val LHU     = BitPat("b?????????????????101?????0000011")
  val SB      = BitPat("b?????????????????000?????0100011")
  val SH      = BitPat("b?????????????????001?????0100011")
  val SW      = BitPat("b?????????????????010?????0100011")
  val SBU     = BitPat("b?????????????????100?????0100011")
  val SHU     = BitPat("b?????????????????101?????0100011")

  // 加算
  val ADD     = BitPat("b0000000??????????000?????0110011")
  val ADDI    = BitPat("b?????????????????000?????0010011")

  // 減算
  val SUB     = BitPat("b0100000??????????000?????0110011")

  // 論理演算
  val AND     = BitPat("b0000000??????????111?????0110011")
  val OR      = BitPat("b0000000??????????110?????0110011")
  val XOR     = BitPat("b0000000??????????100?????0110011")
  val ANDI    = BitPat("b?????????????????111?????0010011")
  val ORI     = BitPat("b?????????????????110?????0010011")
  val XORI    = BitPat("b?????????????????100?????0010011")

  // シフト
  val SLL     = BitPat("b0000000??????????001?????0110011")
  val SRL     = BitPat("b0000000??????????101?????0110011")
  val SRA     = BitPat("b0100000??????????101?????0110011")
  val SLLI    = BitPat("b0000000??????????001?????0010011")
  val SRLI    = BitPat("b0000000??????????101?????0010011")
  val SRAI    = BitPat("b0100000??????????101?????0010011")

  // 比較
  val SLT     = BitPat("b0000000??????????010?????0110011")
  val SLTU    = BitPat("b0000000??????????011?????0110011")
  val SLTI    = BitPat("b?????????????????010?????0010011")
  val SLTIU   = BitPat("b?????????????????011?????0010011")

  // 条件分岐
  val BEQ     = BitPat("b?????????????????000?????1100011")
  val BNE     = BitPat("b?????????????????001?????1100011")
  val BLT     = BitPat("b?????????????????100?????1100011")
  val BGE     = BitPat("b?????????????????101?????1100011")
  val BLTU    = BitPat("b?????????????????110?????1100011")
  val BGEU    = BitPat("b?????????????????111?????1100011")

  // ジャンプ
  val JAL     = BitPat("b?????????????????????????1101111")
  val JALR    = BitPat("b?????????????????000?????1100111")

  // 即値ロード
  val LUI     = BitPat("b?????????????????????????0110111")
  val AUIPC   = BitPat("b?????????????????????????0010111")

  // CSR
  val CSRRW   = BitPat("b?????????????????001?????1110011")
  val CSRRWI  = BitPat("b?????????????????101?????1110011")
  val CSRRS   = BitPat("b?????????????????010?????1110011")
  val CSRRSI  = BitPat("b?????????????????110?????1110011")
  val CSRRC   = BitPat("b?????????????????011?????1110011")
  val CSRRCI  = BitPat("b?????????????????111?????1110011")

  // 例外
  val ECALL   = BitPat("b00000000000000000000000001110011")
  val MRET    = BitPat("b00110000001000000000000001110011")

  // FENCE.I
  val FENCE_I = BitPat("b00000000000000000001000000001111")

  // MUL
  val MUL     = BitPat("b0000001??????????000?????0110011")
  val MULH    = BitPat("b0000001??????????001?????0110011")
  val MULHSU  = BitPat("b0000001??????????010?????0110011")
  val MULHU   = BitPat("b0000001??????????011?????0110011")

  // DIVREM
  val DIV     = BitPat("b0000001??????????100?????0110011")
  val DIVU    = BitPat("b0000001??????????101?????0110011")
  val REM     = BitPat("b0000001??????????110?????0110011")
  val REMU    = BitPat("b0000001??????????111?????0110011")

  // ビット
  val MAX     = BitPat("b0000101??????????110?????0110011")
  val MAXU    = BitPat("b0000101??????????111?????0110011")
  val MIN     = BitPat("b0000101??????????100?????0110011")
  val MINU    = BitPat("b0000101??????????101?????0110011")
  val ZEXTH   = BitPat("b000010000000?????100?????0110011")
  val ANDN    = BitPat("b0100000??????????111?????0110011")
  val ORN     = BitPat("b0100000??????????110?????0110011")
  val XNOR    = BitPat("b0100000??????????100?????0110011")
  val ROL     = BitPat("b0110000??????????001?????0110011")
  val ROR     = BitPat("b0110000??????????101?????0110011")
  val RORI    = BitPat("b0110000??????????101?????0010011")
  val CLZ     = BitPat("b011000000000?????001?????0010011")
  val CTZ     = BitPat("b011000000001?????001?????0010011")
  val CPOP    = BitPat("b011000000010?????001?????0010011")
  val SEXTB   = BitPat("b011000000100?????001?????0010011")
  val SEXTH   = BitPat("b011000000101?????001?????0010011")
  val ORCB    = BitPat("b001010000111?????101?????0010011")
  val REV8    = BitPat("b011010011000?????101?????0010011")

  // RVC
  val C_ILL      = BitPat("b????????????????0000000000000000")
  val C_ADDI4SPN = BitPat("b????????????????000???????????00")
  val C_ADDI16SP = BitPat("b????????????????011?00010?????01")
  val C_ADDI     = BitPat("b????????????????000???????????01")
  val C_LW       = BitPat("b????????????????010???????????00")
  val C_SW       = BitPat("b????????????????110???????????00")
  val C_LI       = BitPat("b????????????????010???????????01")
  val C_LUI      = BitPat("b????????????????011???????????01")
  val C_SRAI     = BitPat("b????????????????100?01????????01")
  val C_SRLI     = BitPat("b????????????????100?00????????01")
  val C_ANDI     = BitPat("b????????????????100?10????????01")
  val C_SUB      = BitPat("b????????????????100011???00???01")
  val C_XOR      = BitPat("b????????????????100011???01???01")
  val C_OR       = BitPat("b????????????????100011???10???01")
  val C_AND      = BitPat("b????????????????100011???11???01")
  val C_SLLI     = BitPat("b????????????????000???????????10")
  val C_J        = BitPat("b????????????????101???????????01")
  val C_BEQZ     = BitPat("b????????????????110???????????01")
  val C_BNEZ     = BitPat("b????????????????111???????????01")
  val C_JR       = BitPat("b????????????????1000?????0000010")
  val C_JALR     = BitPat("b????????????????1001?????0000010")
  val C_JAL      = BitPat("b????????????????001???????????01")
  val C_LWSP     = BitPat("b????????????????010???????????10")
  val C_SWSP     = BitPat("b????????????????110???????????10")
  val C_MV       = BitPat("b????????????????1000??????????10")
  val C_ADD      = BitPat("b????????????????1001??????????10")

  // Xcc
  val C_LB       = BitPat("b????????????????001???????????00")
  val C_LBU      = BitPat("b????????????????011???????????00")
  val C_LH       = BitPat("b????????????????00100?????????10")
  val C_LHU      = BitPat("b????????????????00101?????????10")
  val C_SH       = BitPat("b????????????????00110?????????10")
  val C_SW0      = BitPat("b????????????????00111????????010")
  val C_SB0      = BitPat("b????????????????00111???????0110")
  val C_SH0      = BitPat("b????????????????00111???????1110")
  val C_SB       = BitPat("b????????????????011???????????10")
  val C_AUIPC    = BitPat("b????????????????111???????????00")
  val C_MUL      = BitPat("b????????????????100111???10???01")
  val C_ZEXTB    = BitPat("b????????????????100111???1100001")
  val C_SEXTB    = BitPat("b????????????????100111???1100101")
  val C_ZEXTH    = BitPat("b????????????????100111???1101001")
  val C_SEXTH    = BitPat("b????????????????100111???1101101")
  val C_NOT      = BitPat("b????????????????100111???1110101")
  val C_NEG      = BitPat("b????????????????100111???1111001")
  val C_BEQ      = BitPat("b????????????????100???????????00")
  val C_BNE      = BitPat("b????????????????101???????????00")
  val C_ADDI2W   = BitPat("b????????????????101???????????10")
  val C_ADD2     = BitPat("b????????????????111??????00???10")
  val C_SEQZ     = BitPat("b????????????????111000???01???10")
  val C_SNEZ     = BitPat("b????????????????111100???01???10")
  val C_ADDI2B   = BitPat("b????????????????111??????01???10")
  val C_SLT      = BitPat("b????????????????111??????10???10")
  val C_SLTU     = BitPat("b????????????????111??????11???10")
}
