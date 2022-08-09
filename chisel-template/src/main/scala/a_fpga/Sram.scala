package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental._

class SRAM extends BlackBox(Map("NUM_COL" -> 32, "COL_WIDTH" -> 8, "ADDR_WIDTH" -> 7, "DATA_WIDTH" -> 32*8)) {
  val io = IO(new Bundle() {
    val clock = Input(Clock())
    val en = Input(Bool())
    val we = Input(UInt(32.W))
    val addr = Input(UInt(7.W))
    val wdata = Input(UInt(256.W))
    val rdata = Output(UInt(256.W))
  })
}
