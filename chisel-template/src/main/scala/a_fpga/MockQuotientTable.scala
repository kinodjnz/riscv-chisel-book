package fpga

import chisel3._
import chisel3.util._
import CacheConsts._
import common.Consts._

class MockQuotientTable extends Module {
  val io = IO(new Bundle() {
    val quotient_table = new QuotientTablePort()
  })

  val mem = Mem(2, Vec(32, UInt(2.W)))

  /*
  val v = VecInit(
      0.U, 0.U, 1.U, 1.U,
      1.U, 1.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 1.U, 1.U,
      1.U, 1.U, 1.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 1.U, 1.U,
      1.U, 1.U, 1.U, 1.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 1.U, 1.U,
      1.U, 1.U, 1.U, 1.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      1.U, 1.U, 1.U, 1.U,
      1.U, 1.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      1.U, 1.U, 1.U, 1.U,
      1.U, 1.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      1.U, 1.U, 1.U, 1.U,
      1.U, 1.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      1.U, 1.U, 1.U, 1.U,
      1.U, 1.U, 1.U, 1.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 2.U, 2.U,
      2.U, 2.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
      0.U, 0.U, 0.U, 0.U,
  )
  */

  when (io.quotient_table.wen) {
    val d = io.quotient_table.wdata
    mem.write(io.quotient_table.waddr, VecInit((0 to 31).map(i => d(i*2+1, i*2))))
  }
  io.quotient_table.rdata := mem.read(io.quotient_table.raddr)(io.quotient_table.raddr)
}
