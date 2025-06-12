package common

import chisel3._
import chisel3.util._
import common.Consts._

object SIntExtension {
  implicit class SIntMethods(data: SInt) {
    def sext: SInt = (data(data.getWidth - 1) ## data.asUInt).asSInt
  }
}
