package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFile
import chisel3.ChiselEnum
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations.MemorySynthInit
import scala.io.Source

class BootRom(data_memory_path: String = null, imem_size_in_bytes: Int = 2048, enable_sim_wstrb: Boolean = false, disable_imem_read_delay: Boolean = true) extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val dmem = new DmemPortIo()
  })

  val addr_len = log2Ceil(imem_size_in_bytes) - 3

  val imem_inst  = RegInit(0.U(FETCH_BLOCK_LEN.W))
  val imem_rdata = RegInit(0.U(FETCH_BLOCK_LEN.W))
  val imem_addr  = RegInit(0.U(addr_len.W))
  val odd_addr   = RegInit(false.B)

  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })

  val imem = Mem(imem_size_in_bytes/8, UInt(FETCH_BLOCK_LEN.W))
  if (data_memory_path != null) {
    loadMemoryFromFileInline(imem, data_memory_path)
  }

  imem_addr := io.imem.addr(addr_len + 2, 3)
  if (disable_imem_read_delay) {
    imem_inst := imem.read(io.imem.addr(addr_len + 2, 3))
    io.imem.valid := RegNext(io.imem.en, false.B)
  } else {
    imem_inst := imem.read(imem_addr)
    io.imem.valid := RegNext(imem_addr === io.imem.addr(addr_len + 2, 3), false.B)
  }
  io.imem.inst := imem_inst

  val rwaddr = Mux(io.dmem.wen, io.dmem.waddr, io.dmem.raddr)(addr_len + 2, 2)
  when (io.dmem.wen) {
    if (enable_sim_wstrb) {
      // とりあえずchiseltestでbootromのバイトアクセスを有効化
      val rdata = imem(rwaddr(addr_len, 1))
      val wstrb = Mux(rwaddr(0).asBool, Cat(io.dmem.wstrb, 0.U(4.W)), Cat(0.U(4.W), io.dmem.wstrb))
      val iwdata = Mux(rwaddr(0).asBool, Cat(io.dmem.wdata, 0.U(WORD_LEN.W)), Cat(0.U(WORD_LEN.W), io.dmem.wdata))
      val wdata = Cat(VecInit((0 to 7).map(i => Mux(wstrb(i, i).asBool, iwdata((WORD_LEN/4)*(i+1)-1, (WORD_LEN/4)*i), rdata((WORD_LEN/4)*(i+1)-1, (WORD_LEN/4)*i)))).reverse)
      imem.write(rwaddr(addr_len, 1), wdata)
    } else {
      // imem.write(rwaddr, io.dmem.wdata)
    }
  }
  odd_addr := rwaddr(0).asBool
  when (!io.dmem.wen && io.dmem.ren) {
    imem_rdata := imem.read(rwaddr(addr_len, 1))
  }
  io.dmem.rdata := Mux(odd_addr, (imem_rdata >> WORD_LEN)(WORD_LEN-1, 0), imem_rdata(WORD_LEN-1, 0))
  io.dmem.rvalid := true.B // RegNext(io.dmem.ren, false.B)
  io.dmem.wready := true.B
  io.dmem.rready := true.B
}
