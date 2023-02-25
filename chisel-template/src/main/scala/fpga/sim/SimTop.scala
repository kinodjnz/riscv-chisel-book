package fpga.sim

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile
import fpga._
import fpga.periferals._
import common.Consts._

class SimTop(memoryPath: String, with_sdc: Boolean, enable_pipeline_probe: Boolean = false) extends Module {
  val imemSizeInBytes = 16384
  val dmemSizeInBytes = 16384
  val startAddress = 0x00000000L

  val io = IO(new Bundle {
    val sim_probe = new SimProbe(true)
    val pipeline_probe = new PipelineProbe(enable_pipeline_probe)
  })
  val core = Module(new Core(startAddress, 0x2000_0000L, 0x1000_0000L, true, enable_pipeline_probe))
  val memory = Module(new Memory())
  val boot_rom = Module(new BootRom(memoryPath, imemSizeInBytes, true))

  val dmem_decoder = Module(new DMemDecoder(
    Seq(
      (BigInt(startAddress), BigInt(imemSizeInBytes)),
      // (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
      (BigInt(0x30002000L), BigInt(64)),  // mtimer
    ) ++ (
      if (with_sdc)
        Seq(
          (BigInt(0x30003000L), BigInt(64)),  // SD Controller
        )
     else
      List.empty
    )
  ))
  dmem_decoder.io.targets(0) <> boot_rom.io.dmem
  // dmem_decoder.io.targets(1) <> memory.io.dmem
  dmem_decoder.io.targets(1) <> core.io.mtimer_mem
  if (with_sdc) {
    val sdc = Module(new Sdc)
    val sd = Module(new MockSd)
    val sdbuf = Module(new MockSdBuf)
    dmem_decoder.io.targets(2) <> sdc.io.mem
    sdc.io.sdc_port <> sd.io.sdc_port
    sdc.io.sdbuf <> sdbuf.io.sdbuf
  }

  val imem_decoder = Module(new IMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
  )))
  imem_decoder.io.targets(0) <> boot_rom.io.imem
  imem_decoder.io.targets(1) <> memory.io.imem

  core.io.imem <> imem_decoder.io.initiator
  core.io.dmem <> dmem_decoder.io.initiator

  core.io.cache <> memory.io.cache

  val dram = Module(new MockDram(null, dmemSizeInBytes))
  memory.io.dramPort <> dram.io.dram

  val sram = Module(new MockSram())
  memory.io.cache_array1 <> sram.io.cache_array1
  memory.io.cache_array2 <> sram.io.cache_array2

  val icache = Module(new MockICache)
  memory.io.icache <> icache.io.icache

  val icache_valid = Module(new MockICacheValid)
  memory.io.icache_valid <> icache_valid.io.icache_valid

  val pht_mem = Module(new MockPHTMem)
  core.io.pht_mem <> pht_mem.io.pht_mem

  core.io.intr := 0.U
  io.sim_probe <> core.io.sim_probe
  io.pipeline_probe <> core.io.pipeline_probe
}
