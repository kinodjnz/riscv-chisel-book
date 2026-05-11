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

  val reg_mtime      = RegInit(VecInit(0.U(32.W), 0.U(32.W)))
  val reg_mtime0     = RegNext(reg_mtime(0), 0.U(32.W))
  val reg_carry      = RegInit(0.U(1.W))
  val reg_mtimecmp   = RegInit(VecInit(0xFFFF_FFFFL.U(32.W), 0xFFFF_FFFFL.U(32.W)))
  val reg_diff_carry = RegInit(false.B)
  val intr           = RegInit(false.B)
  val rdata          = RegInit(0.U(32.W))

  val time = reg_mtime(0) +& 1.U
  reg_mtime(0) := time(31, 0)
  reg_carry    := time(32)
  reg_mtime(1) := reg_mtime(1) + reg_carry

  reg_diff_carry := reg_mtime(0) >= reg_mtimecmp(0)

  intr        := ((reg_mtime(1) +& reg_diff_carry.asUInt) + ~reg_mtimecmp(1))(32)
  io.intr     := intr
  io.mtime    := Cat(reg_mtime(1), reg_mtime0)
  io.mtimecmp := Cat(reg_mtimecmp(1), reg_mtimecmp(0))

  io.mem.rdata  := rdata
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B

  switch (io.mem.raddr(3, 2)) {
    is (0.U) {
      rdata := reg_mtime0
    }
    is (1.U) {
      rdata := reg_mtime(1)
    }
    is (2.U) {
      rdata := reg_mtimecmp(0)
    }
    is (3.U) {
      rdata := reg_mtimecmp(1)
    }
  }

  when (io.mem.wen) {
    switch (io.mem.waddr(3, 2)) {
      is (0.U) {
        reg_mtime(0) := io.mem.wdata
      }
      is (1.U) {
        reg_mtime(1) := io.mem.wdata
      }
      is (2.U) {
        reg_mtimecmp(0) := io.mem.wdata
      }
      is (3.U) {
        reg_mtimecmp(1) := io.mem.wdata
      }
    }
  }
}
