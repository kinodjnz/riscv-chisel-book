package fpga.periferals

import chisel3._
import common.Consts._
import fpga._

class Gpio() extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val gpio = Output(UInt(32.W))
  })

  val output = RegInit(0.U(32.W))
  io.gpio := output

  io.mem.rdata := "xdeadbeef".U
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B
  when(io.mem.wen) {
    output := io.mem.wdata
  }
}
