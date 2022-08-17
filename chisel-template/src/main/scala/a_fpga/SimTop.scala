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
  val core = Module(new Core(startAddress, 10, bpTagInitPath))
  val memory = Module(new Memory(null, imemSizeInBytes))
  val boot_rom = Module(new BootRom(memoryPath, imemSizeInBytes))

  val decoder = Module(new DMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
    (BigInt(0x30002000L), BigInt(64)), // mtimer
  )))
  decoder.io.targets(0) <> boot_rom.io.dmem
  decoder.io.targets(1) <> memory.io.dmem
  decoder.io.targets(2) <> core.io.mtimer_mem

  core.io.imem <> boot_rom.io.imem
  core.io.dmem <> decoder.io.initiator

  memory.io.imem.addr := 0.U

  val dram = Module(new MockDram(null, dmemSizeInBytes))
  memory.io.dramPort <> dram.io.dram

  val sram = Module(new MockSram())
  memory.io.cache_array1 <> sram.io.cache_array1
  memory.io.cache_array2 <> sram.io.cache_array2

  core.io.intr := false.B
  io.gp   := core.io.gp
  io.exit := core.io.exit
}
