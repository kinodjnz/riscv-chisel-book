package fpga.sim

import chisel3._
import chisel3.util._
import common.Consts._
import fpga._
import fpga.CacheConsts._

class MockICache extends Module {
  val io = IO(new Bundle() {
    val icache = new ICachePort()
  })

  val mem = Mem(ICACHE_LINES*8, UInt(WORD_LEN.W))
  val rdata = RegInit(0.U(WORD_LEN.W))

  io.icache.rdata := rdata
  when (io.icache.ren) {
    rdata := mem.read(io.icache.raddr)
  }
  when (io.icache.wen) {
    (0 to 7).foreach(i => mem.write(Cat(io.icache.waddr, i.asUInt(3.W)), io.icache.wdata(i*32+31, i*32)))
  }
}
