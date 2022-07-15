package fpga

import chisel3._
import chisel3.util._
import common.Consts._

class MachineTimer extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val intr = Output(Bool())
    val mtime = Output(UInt(64.W))
  })

  val mtime = RegInit(0.U(64.W))
  val mtimecmp = RegInit(0xFFFFFFFFL.U(64.W))
  val intr = RegInit(false.B)

  mtime := mtime + 1.U
  intr := mtime >= mtimecmp
  io.intr := intr
  io.mtime := mtime

  when (io.mem.ren) {
    when (io.mem.raddr === 0.U) {
      io.mem.rdata := mtime(31, 0)
    }.elsewhen (io.mem.raddr === 4.U) {
      io.mem.rdata := mtime(63, 32)
    }.elsewhen (io.mem.raddr === 8.U) {
      io.mem.rdata := mtimecmp(31, 0)
    }.elsewhen (io.mem.raddr === 12.U) {
      io.mem.rdata := mtimecmp(63, 32)
    }.otherwise {
      io.mem.rdata := 0.U(WORD_LEN.W)
    }
    io.mem.rvalid := true.B
  }.otherwise {
    io.mem.rdata := 0.U(WORD_LEN.W)
    io.mem.rvalid := false.B
  }

  when (io.mem.wen) {
    when (io.mem.waddr === 0.U) {
      mtime := Cat(mtime(63, 32), io.mem.wdata)
    }.elsewhen (io.mem.waddr === 4.U) {
      mtime := Cat(io.mem.wdata, mtime(31, 0))
    }.elsewhen (io.mem.waddr === 8.U) {
      mtimecmp := Cat(mtimecmp(63, 32), io.mem.wdata)
    }.elsewhen (io.mem.waddr === 12.U) {
      mtimecmp := Cat(io.mem.wdata, mtimecmp(31, 0))
    }
  }
  io.mem.wready := true.B
}
