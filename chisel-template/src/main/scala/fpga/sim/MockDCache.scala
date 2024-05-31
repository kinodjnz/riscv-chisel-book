
package fpga.sim

import chisel3._
import chisel3.util._
import fpga._
import fpga.CacheConsts._

class MockDCache extends Module {
  val io = IO(new Bundle() {
    val cache_array1 = new DCachePort()
    val cache_array2 = new DCachePort()
  })

  val dmem1 = Mem(DCACHE_LINES, Vec(CACHE_LINE_LEN/8, UInt(8.W)))
  val dmem2 = Mem(DCACHE_LINES, Vec(CACHE_LINE_LEN/8, UInt(8.W)))

  val rdata1 = RegInit(0.U(CACHE_LINE_LEN.W))
  val rdata2 = RegInit(0.U(CACHE_LINE_LEN.W))

  io.cache_array1.rdata := rdata1
  io.cache_array2.rdata := rdata2
  when (io.cache_array1.ren) {
    rdata1 := Cat(dmem1.read(io.cache_array1.raddr).reverse)
  }
  when (io.cache_array1.wen) {
    dmem1.write(
      io.cache_array1.waddr,
      VecInit((0 to CACHE_LINE_LEN/8-1).map(i => io.cache_array1.wdata(i*8+7, i*8))),
      io.cache_array1.we.asBools
    )
  }
  when (io.cache_array2.ren) {
    rdata2 := Cat(dmem2.read(io.cache_array2.raddr).reverse)
  }
  when (io.cache_array2.wen) {
    dmem2.write(
      io.cache_array2.waddr,
      VecInit((0 to CACHE_LINE_LEN/8-1).map(i => io.cache_array2.wdata(i*8+7, i*8))),
      io.cache_array2.we.asBools
    )
  }
}
