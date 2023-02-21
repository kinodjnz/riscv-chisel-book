package fpga.sim

import chisel3._
import chisel3.util._
import common.Consts._
import fpga._
import fpga.CacheConsts._

class MockPHTMem extends Module {
  val io = IO(new Bundle() {
    val pht_mem = new PHTMemIo()
  })

  val mem = Mem(1<<PHT_INDEX_BITS, UInt(2.W))
  val rdata = RegInit(0.U(4.W))

  io.pht_mem.rdata := rdata
  when (io.pht_mem.ren) {
    rdata := Cat(mem.read(Cat(io.pht_mem.raddr, 1.U(1.W))), mem.read(Cat(io.pht_mem.raddr, 0.U(1.W))))
  }
  when (io.pht_mem.wen) {
    mem.write(io.pht_mem.waddr, io.pht_mem.wdata)
  }
  printf(p"rdata          : 0x${Hexadecimal(rdata)}\n")
}
