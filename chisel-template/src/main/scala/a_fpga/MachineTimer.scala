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

  io.mem.rdata := "xdeadbeef".U
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B

  when (io.mem.ren) {
    switch (io.mem.raddr(3, 2)) {
      is (0.U) {
        io.mem.rdata := mtime(31, 0)
      }
      is (1.U) {
        io.mem.rdata := mtime(63, 32)
      }
      is (2.U) {
        io.mem.rdata := mtimecmp(31, 0)
      }
      is (3.U) {
        io.mem.rdata := mtimecmp(63, 32)
      }
    }
  }

  when (io.mem.wen) {
    switch (io.mem.waddr(3, 2)) {
      is (0.U) {
        mtime := Cat(mtime(63, 32), io.mem.wdata)
      }
      is (1.U) {
        mtime := Cat(io.mem.wdata, mtime(31, 0))
      }
      is (2.U) {
        mtimecmp := Cat(mtimecmp(63, 32), io.mem.wdata)
      }
      is (3.U) {
        mtimecmp := Cat(io.mem.wdata, mtimecmp(31, 0))
      }
    }
  }
}
