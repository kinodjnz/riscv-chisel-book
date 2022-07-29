package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.util.experimental.loadMemoryFromFile

class SimTop(memoryPath: String, bpTagInitPath: String) extends Module {
  val imemSizeInBytes = 16384
  val dmemSizeInBytes = 16384
  val startAddress = 0x00000000L

  val io = IO(new Bundle {
    val gp = Output(UInt(WORD_LEN.W))
    val exit = Output(Bool())
  })
  val core = Module(new Core(startAddress, bpTagInitPath))
  val memory = Module(new Memory(null, imemSizeInBytes, dmemSizeInBytes))
  val imem_dbus = Module(new SingleCycleMem(imemSizeInBytes))

  val decoder = Module(new DMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
    (BigInt(0x30002000L), BigInt(64)), // mtimer
  )))
  decoder.io.targets(0) <> imem_dbus.io.mem
  decoder.io.targets(1) <> memory.io.dmem
  decoder.io.targets(2) <> core.io.mtimer_mem

  val imem_rdata = RegInit(0.U(WORD_LEN.W))
  val imem_rdata2 = RegInit(0.U(WORD_LEN.W))
  memory.io.imemReadPort.data := imem_rdata
  imem_dbus.io.read.data := imem_rdata2

  val imem = Mem(imemSizeInBytes/4, UInt(32.W))
  loadMemoryFromFile(imem, memoryPath)
  when (memory.io.imemReadPort.enable) {
    imem_rdata := imem.read(memory.io.imemReadPort.address(log2Ceil(imemSizeInBytes) - 3, 0))
  }
  val rwaddr = Mux(imem_dbus.io.write.enable, imem_dbus.io.write.address, imem_dbus.io.read.address)
  when (imem_dbus.io.write.enable) {
    imem.write(rwaddr, imem_dbus.io.write.data)
  }
  when (!imem_dbus.io.write.enable && imem_dbus.io.read.enable) {
    imem_rdata2 := imem.read(rwaddr)
  }

  val dram = Module(new MockDram(null, dmemSizeInBytes))
  memory.io.dramPort <> dram.io.dram

  core.io.imem <> memory.io.imem
  //core.io.dmem <> memory.io.dmem
  core.io.dmem <> decoder.io.initiator

  core.io.intr := false.B
  io.gp   := core.io.gp
  io.exit := core.io.exit
}
