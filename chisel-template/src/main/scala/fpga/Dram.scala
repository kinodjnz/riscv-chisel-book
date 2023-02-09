package fpga

import chisel3._
import chisel3.util._
import DramConsts._

object DramConsts {
  val DRAM_ADDR_WIDTH = 28
  val DRAM_DATA_WIDTH = 128
  val DRAM_MASK_WIDTH = 16
}

class DramIo extends Bundle {
  val ren                 = Input(Bool())
  val wen                 = Input(Bool())
  val addr                = Input(UInt(DRAM_ADDR_WIDTH.W))
  val wdata               = Input(UInt(DRAM_DATA_WIDTH.W))
  val wmask               = Input(UInt(DRAM_MASK_WIDTH.W))
  val user_busy           = Input(Bool())
  val init_calib_complete = Output(Bool())
  val rdata               = Output(UInt(DRAM_DATA_WIDTH.W))
  val rdata_valid         = Output(Bool())
  val busy                = Output(Bool())
}
