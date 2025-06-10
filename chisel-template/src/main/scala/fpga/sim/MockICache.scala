package fpga.sim

import chisel3._
import chisel3.util._
import common.Consts._
import fpga._
import fpga.CacheConsts._

class MockICache extends Module {
  val io = IO(new Bundle() {
    val icache_sram = new ICacheSramPort()
  })

  val mem = Mem(ICACHE_LINES*4, UInt(FETCH_BLOCK_LEN.W))
  val rdata = RegInit(0.U(FETCH_BLOCK_LEN.W))

  io.icache_sram.rdata := rdata
  when (io.icache_sram.ren) {
    rdata := mem.read(io.icache_sram.raddr)
  }
  when (io.icache_sram.wen) {
    (0 to 3).foreach(i => mem.write(Cat(io.icache_sram.waddr, i.asUInt(2.W)), io.icache_sram.wdata(i*64+63, i*64)))
  }
}
