package fpga.sim

import chisel3._
import chisel3.util._
import common.Consts._
import fpga._
import fpga.CacheConsts._

class MockPHTMem extends Module {
  val io = IO(new Bundle() {
    val pht_mem = new PHTMemIo(PHT_INDEX_LEN)
  })

  val mem = Mem(1<<PHT_INDEX_LEN, UInt(2.W))
  val rdata = RegInit(0.U(8.W))

  io.pht_mem.rdata := rdata
  when (io.pht_mem.ren) {
    rdata := Cat((0 until 4).map(i => mem.read(io.pht_mem.raddr ## i.U(2.W))).reverse)
    // mem.read(Cat(io.pht_mem.raddr, 1.U(1.W))), mem.read(Cat(io.pht_mem.raddr, 0.U(1.W))))
  }
  when (io.pht_mem.wen) {
    mem.write(io.pht_mem.waddr, io.pht_mem.wdata)
  }
  printf(cf"rdata          : 0x${rdata}%x\n")
}
