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

  // ベクトル
  val VSETVLI = BitPat("b?????????????????111?????1010111")
  val VLE     = BitPat("b000000100000?????????????0000111")
  val VSE     = BitPat("b000000100000?????????????0100111")
  val VADDVV  = BitPat("b0000001??????????000?????1010111")

  // カスタム
  val PCNT    = BitPat("b000000000000?????110?????0001011")

  // RVC
  val C_ILL      = BitPat("b????????????????0000000000000000")
  val C_ADDI4SPN = BitPat("b????????????????000???????????00")
  val C_ADDI16SP = BitPat("b????????????????011?00010?????01")
  val C_ADDI     = BitPat("b????????????????000???????????01")
  val C_LW       = BitPat("b????????????????010???????????00")
  val C_SW       = BitPat("b????????????????110???????????00")
}
