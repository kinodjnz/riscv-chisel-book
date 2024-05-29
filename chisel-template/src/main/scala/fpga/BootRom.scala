package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFile
import chisel3.ChiselEnum
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations.MemorySynthInit

class BootRom(data_memory_path: String = null, imem_size_in_bytes: Int = 2048, enable_sim_wstrb: Boolean = false) extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val dmem = new DmemPortIo()
  })

  val imem_inst = RegInit(0.U(WORD_LEN.W))
  val imem_rdata = RegInit(0.U(WORD_LEN.W))

  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })

  val imem = Mem(imem_size_in_bytes/4, UInt(WORD_LEN.W))
  loadMemoryFromFileInline(imem, data_memory_path)

  when (io.imem.en) {
    imem_inst := imem.read(io.imem.addr(log2Ceil(imem_size_in_bytes) - 1, 2))
  }
  io.imem.inst := imem_inst
  io.imem.valid := RegNext(io.imem.en, false.B)

  val rwaddr = Mux(io.dmem.wen, io.dmem.waddr, io.dmem.raddr)(log2Ceil(imem_size_in_bytes) - 1, 2)
  when (io.dmem.wen) {
    if (enable_sim_wstrb) {
      // とりあえずchiseltestでbootromのバイトアクセスを有効化
      val rdata = imem.read(rwaddr)
      val wdata = Cat(VecInit((0 to 3).map(i => Mux(io.dmem.wstrb(i, i).asBool, io.dmem.wdata((WORD_LEN/4)*(i+1)-1, (WORD_LEN/4)*i), rdata((WORD_LEN/4)*(i+1)-1, (WORD_LEN/4)*i)))).reverse)
      imem.write(rwaddr, wdata)
    } else {
      imem.write(rwaddr, io.dmem.wdata)
    }
  }
  when (!io.dmem.wen && io.dmem.ren) {
    imem_rdata := imem.read(rwaddr)
  }
  io.dmem.rdata := imem_rdata
  io.dmem.rvalid := true.B // RegNext(io.dmem.ren, false.B)
  io.dmem.wready := true.B
  io.dmem.rready := true.B
}
