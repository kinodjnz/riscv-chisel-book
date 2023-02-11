package fpga.sim

import chisel3._
import chisel3.util._
import fpga._
import fpga.CacheConsts._
import common.Consts._

class MockICacheValid extends Module {
  val io = IO(new Bundle() {
    val icache_valid = new ICacheValidPort()
  })

  val mem = Mem((1 << ICACHE_VALID_ADDR_BITS), UInt(ICACHE_VALID_BUNDLE_BITS.W))
  val rdata = RegInit(0.U(ICACHE_VALID_DATA_BITS.W))

  io.icache_valid.rdata := rdata
  when (io.icache_valid.ren) {
    rdata := mem.read(io.icache_valid.addr)
    when (io.icache_valid.wen) {
      mem.write(io.icache_valid.addr, io.icache_valid.wdata)
    }
  }
  when (io.icache_valid.invalidate) {
    (0 to ((1 << (ICACHE_INVALIDATE_DATA_BITS-ICACHE_VALID_DATA_BITS))-1)).foreach(i => mem.write(
      Cat(io.icache_valid.iaddr, i.asUInt((ICACHE_INVALIDATE_DATA_BITS-ICACHE_VALID_DATA_BITS).W)),
      io.icache_valid.idata((i+1)*ICACHE_VALID_BUNDLE_BITS-1, i*ICACHE_VALID_BUNDLE_BITS)
    ))
  }

  // printf(p"icv.ren           : 0x${Hexadecimal(io.icache_valid.ren)}\n")
  // printf(p"icv.addr          : 0x${Hexadecimal(io.icache_valid.addr)}\n")
  // printf(p"icv.rdata         : 0x${Hexadecimal(io.icache_valid.rdata)}\n")
  // printf(p"icv.invalidate    : 0x${Hexadecimal(io.icache_valid.invalidate)}\n")
  // printf(p"icv.iaddr         : 0x${Hexadecimal(io.icache_valid.iaddr)}\n")
  // printf(p"icv.idata         : 0x${Hexadecimal(io.icache_valid.idata)}\n")
}
