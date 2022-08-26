package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental._

class ICacheValid(data_width_bits: Int, addr_width: Int, invalidate_width_bits: Int, invalidate_addr_width: Int)
    extends BlackBox(Map("DATA_WIDTH_BITS" -> data_width_bits, "ADDR_WIDTH" -> addr_width, "INVALIDATE_WIDTH_BITS" -> invalidate_width_bits, "INVALIDATE_ADDR_WIDTH" -> invalidate_addr_width)) {
  val io = IO(new Bundle() {
    val clock = Input(Clock())
    val ren = Input(Bool())
    val wen = Input(Bool())
    val ien = Input(Bool())
    val invalidate = Input(Bool())
    val addr = Input(UInt(addr_width.W))
    val iaddr = Input(UInt(invalidate_addr_width.W))
    val rdata = Output(UInt((1 << data_width_bits).W))
    val wdata = Input(UInt((1 << data_width_bits).W))
    val idata = Input(UInt((1 << invalidate_width_bits).W))
    val dummy_data = Output(UInt((1 << data_width_bits).W))
  })
}
