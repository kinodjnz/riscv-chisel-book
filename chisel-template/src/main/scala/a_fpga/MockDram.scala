package fpga

import chisel3._
import chisel3.util._
import DramConsts._
import chisel3.util.experimental.loadMemoryFromFile

class MockDram(dataMemoryPath: String = null, dmemSizeInBytes: Int = 16384) extends Module {
  val io = IO(new Bundle {
    val dram = new DramIo()
  })

  val bytesPerWidth = DRAM_DATA_WIDTH / 8
  val carib_count = RegInit(50.U(8.W))
  val dataMem = Mem(dmemSizeInBytes/bytesPerWidth, Vec(bytesPerWidth, UInt(8.W)))
  if (dataMemoryPath != null) {
    loadMemoryFromFile(dataMem, dataMemoryPath)
  }

  when (carib_count === 0.U(8.W)) {
    io.dram.init_calib_complete := true.B
    val rdata = RegInit(0.U(DRAM_DATA_WIDTH.W))
    val rdata_valid = RegInit(false.B)
    io.dram.rdata := rdata
    io.dram.rdata_valid := rdata_valid
    io.dram.busy := false.B

    rdata_valid := false.B
    when (!io.dram.wen && io.dram.ren) {
      rdata := Cat(dataMem.read(io.dram.addr(DRAM_ADDR_WIDTH-1, 3)).reverse)
      rdata_valid := true.B
    }

    when (io.dram.wen) {
      val wdata = io.dram.wdata
      dataMem.write(
        io.dram.addr(DRAM_ADDR_WIDTH-1, 3),
        VecInit((0 to DRAM_MASK_WIDTH-1).map(i => wdata(8*(i+1)-1, 8*i))),
        (~io.dram.wmask).asBools
      )
    }
    // io.dram.user_busy
  }.otherwise {
    carib_count := carib_count - 1.U
    io.dram.rdata := 0.U(DRAM_DATA_WIDTH.W)
    io.dram.rdata_valid := false.B
    io.dram.init_calib_complete := false.B
    io.dram.busy := true.B
  }
}
