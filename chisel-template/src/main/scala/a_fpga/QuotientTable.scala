package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental._

class QuotientTable(rdata_width_bits: Int, raddr_width: Int, wdata_width_bits: Int, waddr_width: Int)
    extends BlackBox(Map("RDATA_WIDTH_BITS" -> rdata_width_bits, "RADDR_WIDTH" -> raddr_width, "WDATA_WIDTH_BITS" -> wdata_width_bits, "WADDR_WIDTH" -> waddr_width)) {
  val io = IO(new Bundle() {
    val clock = Input(Clock())
    val wen = Input(Bool())
    val raddr = Input(UInt(raddr_width.W))
    val rdata = Output(UInt((1 << rdata_width_bits).W))
    val waddr = Input(UInt(waddr_width.W))
    val wdata = Input(UInt((1 << wdata_width_bits).W))
  })
}
