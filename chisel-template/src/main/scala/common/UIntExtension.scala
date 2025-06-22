package common

import chisel3._
import chisel3.util._
import common.Consts._

object UIntExtension {
  implicit class UIntMethods(data: UInt) {
    def word_to_pc: UInt = data.head(PC_LEN)
    def pc_to_word: UInt = data ## 0.U((WORD_LEN-PC_LEN).W)
    // def pc_to_word(pad: Int): UInt = data ## pad.U((WORD_LEN-PC_LEN).W)
    def clear_lsbits(bits: Int): UInt = data.head(data.getWidth - bits) ## 0.U(bits.W)
    def replace_lsbits(bits: Int, lsbits: UInt): UInt = data.head(data.getWidth - bits) ## lsbits(bits - 1, 0)
    def take(n: Int): UInt = data(n - 1, 0)
    def subdivideIn(n: Int): IndexedSeq[UInt] = (0 until ((data.getWidth + n - 1) / n)).map(i => data(i * n + n - 1, i * n))
    def subdivideInVec(n: Int): Vec[UInt] = VecInit.tabulate((data.getWidth + n - 1) / n)(i => data(i * n + n - 1, i * n))
    def signed_extend(n: Int): UInt = Fill(n - data.getWidth, data(data.getWidth - 1)) ## data
    def zero_extend(n: Int): UInt = 0.U((n - data.getWidth).W) ## data
  }
}
