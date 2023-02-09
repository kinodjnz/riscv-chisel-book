
package fpga.sim

import chisel3._
import chisel3.util._
import fpga._
import fpga.CacheConsts._

class MockSram extends Module {
  val io = IO(new Bundle() {
    val cache_array1 = new DCachePort()
    val cache_array2 = new DCachePort()
  })

  val dmem1 = Mem(DCACHE_LINES, Vec(CACHE_LINE_LEN/8, UInt(8.W)))
  val dmem2 = Mem(DCACHE_LINES, Vec(CACHE_LINE_LEN/8, UInt(8.W)))

  io.cache_array1.rdata := DontCare
  io.cache_array2.rdata := DontCare
  when (io.cache_array1.en) {
    dmem1.write(
      io.cache_array1.addr,
      VecInit((0 to CACHE_LINE_LEN/8-1).map(i => io.cache_array1.wdata(i*8+7, i*8))),
      io.cache_array1.we.asBools
    )
    io.cache_array1.rdata := Cat(dmem1.read(io.cache_array1.addr).reverse)
  }
  when (io.cache_array2.en) {
    dmem2.write(
      io.cache_array2.addr,
      VecInit((0 to CACHE_LINE_LEN/8-1).map(i => io.cache_array2.wdata(i*8+7, i*8))),
      io.cache_array2.we.asBools
    )
    io.cache_array2.rdata := Cat(dmem2.read(io.cache_array2.addr).reverse)
  }
}
