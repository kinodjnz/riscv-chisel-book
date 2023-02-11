package fpga.periferals

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import fpga._
import common.Consts._

// memory map
// 00000000 | intrrupt enable
// 00000004 | intrrupt asserted

class InterruptController() extends Module {
  val device_max: Int = 2

  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val intr_periferal = Input(UInt(device_max.W))
    val intr_cpu = Output(Bool())
  })

  val reg_intr_enable   = RegInit(0.U(device_max.W))
  val reg_intr_asserted = RegInit(0.U(device_max.W))
  val reg_intr_cpu      = RegInit(false.B)

  val inter_asserted = io.intr_periferal & reg_intr_enable
  reg_intr_cpu := inter_asserted.orR
  reg_intr_asserted := inter_asserted

  io.intr_cpu := reg_intr_cpu

  io.mem.rdata := "xdeadbeef".U
  io.mem.rvalid := true.B
  io.mem.wready := true.B

  when (io.mem.ren) {
    switch (io.mem.raddr(2, 2)) {
      is (0.U) {
        io.mem.rdata := reg_intr_enable
      }
      is (1.U) {
        io.mem.rdata := reg_intr_asserted
      }
    }
  }

  when (io.mem.wen) {
    reg_intr_enable := io.mem.wdata
  }
}
