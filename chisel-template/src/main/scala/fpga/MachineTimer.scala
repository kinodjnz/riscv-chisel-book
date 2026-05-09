package fpga

import chisel3._
import chisel3.util._
import common.Consts._

class MachineTimer extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val intr = Output(Bool())
    val mtime = Output(UInt(64.W))
    val mtimecmp = Output(UInt(64.W))
  })

  val reg_mtime    = RegInit(0.U(64.W))
  val reg_mtimecmp = RegInit(0xFFFFFFFFL.U(64.W))
  val intr         = RegInit(false.B)
  val rdata        = RegInit(0.U(32.W))
  val mtime        = Wire(UInt(64.W))

  val mtime1 = reg_mtime + 1.U
  mtime     := mtime1
  reg_mtime := mtime

  intr        := reg_mtime >= reg_mtimecmp
  io.intr     := intr
  io.mtime    := reg_mtime
  io.mtimecmp := reg_mtimecmp

  io.mem.rdata  := rdata
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B

  // when (io.mem.ren) {
    switch (io.mem.raddr(3, 2)) {
      is (0.U) {
        rdata := reg_mtime(31, 0)
      }
      is (1.U) {
        rdata := reg_mtime(63, 32)
      }
      is (2.U) {
        rdata := reg_mtimecmp(31, 0)
      }
      is (3.U) {
        rdata := reg_mtimecmp(63, 32)
      }
    }
  // }

  when (io.mem.wen) {
    switch (io.mem.waddr(3, 2)) {
      is (0.U) {
        // mtime := Cat(mtime(63, 32), io.mem.wdata)
        mtime := mtime1(63, 32) ## io.mem.wdata
      }
      is (1.U) {
        // mtime := Cat(io.mem.wdata, mtime(31, 0))
        mtime := io.mem.wdata ## mtime1(31, 0)
      }
      is (2.U) {
        reg_mtimecmp := reg_mtimecmp(63, 32) ## io.mem.wdata
      }
      is (3.U) {
        reg_mtimecmp := io.mem.wdata ## reg_mtimecmp(31, 0)
      }
    }
  }
}
