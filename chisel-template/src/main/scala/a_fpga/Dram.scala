package fpga

import chisel3._
import chisel3.util._
import DramConsts._

object DramConsts {
  val APP_ADDR_WIDTH = 28
  val APP_CMD_WIDTH  = 3
  val APP_DATA_WIDTH = 128
  val APP_MASK_WIDTH = 16
}

class DramIo extends Bundle {
  val ren                 = Input(Bool())
  val wen                 = Input(Bool())
  val addr                = Input(UInt(APP_ADDR_WIDTH.W))
  val wdata               = Input(UInt(APP_DATA_WIDTH.W))
  val wmask               = Input(UInt(APP_MASK_WIDTH.W))
  val user_busy           = Input(Bool())
  val init_calib_complete = Output(Bool())
  val rdata               = Output(UInt(APP_DATA_WIDTH.W))
  val rdata_valid         = Output(Bool())
  val busy                = Output(Bool())
}
