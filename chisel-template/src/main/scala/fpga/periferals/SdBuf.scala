package fpga.periferals

import chisel3._
import chisel3.util._
import chisel3.experimental._

class SdBuf extends BlackBox(Map("ADDR_WIDTH" -> 8, "DATA_WIDTH" -> 32)) {
  val io = IO(new Bundle() {
    val clock = Input(Clock())
    val ren1 = Input(Bool())
    val wen1 = Input(Bool())
    val addr1 = Input(UInt(8.W))
    val wdata1 = Input(UInt(32.W))
    val rdata1 = Output(UInt(32.W))
    val ren2 = Input(Bool())
    val wen2 = Input(Bool())
    val addr2 = Input(UInt(8.W))
    val wdata2 = Input(UInt(32.W))
    val rdata2 = Output(UInt(32.W))
  })
}
