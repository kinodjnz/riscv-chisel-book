package fpga

import chisel3._
import chisel3.util.{MuxLookup, log2Ceil, Cat}
import chisel3.stage.ChiselStage
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.{annotate, ChiselAnnotation}
import common.Consts._
import DramConsts._
import CacheConsts._
import periferals._

class Config(clockHz: Int) extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
  })

  io.mem.rdata := MuxLookup(io.mem.raddr(2, 2), "xDEADBEEF".U, Seq(
    0.U -> "x01234567".U,
    1.U -> clockHz.U,
  ))
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B
}

class RiscVDebugSignals extends Bundle {
  val core = new CoreDebugSignals()

  //val raddr  = Output(UInt(WORD_LEN.W))
  // val rdata = Output(UInt(WORD_LEN.W))
  val ren   = Output(Bool())
  // val rvalid = Output(Bool())

  // val rwaddr  = Output(UInt(WORD_LEN.W))
  val wen   = Output(Bool())
  val wready = Output(Bool())
  val wstrb = Output(UInt(4.W))
  val wdata = Output(UInt(WORD_LEN.W))

  // val dram_init_calib_complete = Output(Bool())
  // val dram_rdata_valid         = Output(Bool())
  // val dram_busy                = Output(Bool())
  // val dram_ren                 = Output(Bool())

  val mem_icache_state = Output(UInt(3.W))
  val mem_dram_state = Output(UInt(3.W))
  val mem_imem_addr = Output(UInt(16.W))

  // val sdc_cmd_wrt = Output(Bool())
  // val sdc_cmd_out = Output(Bool())
  // val sdc_res_in  = Output(Bool())
  // val sdc_dat_in  = Output(UInt(4.W))
  // val sdc_rx_dat_index = Output(UInt(8.W))
  // val sdc_sdbuf_ren1 = Output(Bool())
  // val sdc_sdbuf_wen1 = Output(Bool())
  // val sdc_sdbuf_addr1 = Output(UInt(8.W))
  // val sdc_sdbuf_wdata1 = Output(UInt(8.W))
  // val sdc_sdbuf_ren2 = Output(Bool())
  // val sdc_sdbuf_wen2 = Output(Bool())
  // val sdc_sdbuf_addr2 = Output(UInt(8.W))
}

class RiscV(clockHz: Int) extends Module {
  val imemSizeInBytes = 2048
  val dmemSizeInBytes = 256L * 1024L * 1024L
  val startAddress = 0x08000000L

  val io = IO(new Bundle {
    val dram = Flipped(new DramIo())
    val gpio = Output(UInt(8.W))
    val uart_tx = Output(Bool())
    val uart_rx = Input(Bool())
    val sdc_port = new SdcPort
    //val exit = Output(Bool())
    val debugSignals = new RiscVDebugSignals()
  })
  val core = Module(new Core(startAddress))
  
  val memory = Module(new Memory())
  val boot_rom = Module(new BootRom("bootrom.hex", imemSizeInBytes))
  val dcache1 = Module(new DCache)
  val dcache2 = Module(new DCache)
  val icache = Module(new ICache(log2Ceil(WORD_LEN), ICACHE_INDEX_BITS+(log2Ceil(CACHE_LINE_LEN)-log2Ceil(WORD_LEN)), log2Ceil(CACHE_LINE_LEN), ICACHE_INDEX_BITS))
  val icache_valid = Module(new ICacheValid(ICACHE_VALID_DATA_BITS, ICACHE_VALID_ADDR_BITS, ICACHE_INVALIDATE_DATA_BITS, ICACHE_INVALIDATE_ADDR_BITS))
  val pht_mem = Module(new PHTMem(2, PHT_INDEX_BITS-1, 1, PHT_INDEX_BITS))
  val gpio = Module(new Gpio)
  val uart = Module(new Uart(clockHz))
  val sdc = Module(new Sdc)
  val sdbuf = Module(new SdBuf)
  val intr = Module(new InterruptController)
  val config = Module(new Config(clockHz))

  val dmem_decoder = Module(new DMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    // (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
    (BigInt(0x30000000L), BigInt(64)),  // GPIO
    (BigInt(0x30001000L), BigInt(64)),  // UART
    (BigInt(0x30002000L), BigInt(64)),  // mtimer
    (BigInt(0x30003000L), BigInt(64)),  // SD Controller
    (BigInt(0x30004000L), BigInt(64)),  // Interrupt Controller
    (BigInt(0x40000000L), BigInt(64)),  // CONFIG
  )))
  dmem_decoder.io.targets(0) <> boot_rom.io.dmem
  // dmem_decoder.io.targets(1) <> memory.io.dmem
  dmem_decoder.io.targets(1) <> gpio.io.mem
  dmem_decoder.io.targets(2) <> uart.io.mem
  dmem_decoder.io.targets(3) <> core.io.mtimer_mem
  dmem_decoder.io.targets(4) <> sdc.io.mem
  dmem_decoder.io.targets(5) <> intr.io.mem
  dmem_decoder.io.targets(6) <> config.io.mem

  val imem_decoder = Module(new IMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
  )))
  imem_decoder.io.targets(0) <> boot_rom.io.imem
  imem_decoder.io.targets(1) <> memory.io.imem

  core.io.imem <> imem_decoder.io.initiator
  core.io.dmem <> dmem_decoder.io.initiator

  core.io.cache <> memory.io.cache

  // dram
  io.dram <> memory.io.dramPort

  dcache1.io.clock := clock
  dcache1.io.ren := memory.io.cache_array1.ren
  dcache1.io.wen := memory.io.cache_array1.wen
  dcache1.io.we := memory.io.cache_array1.we
  dcache1.io.raddr := memory.io.cache_array1.raddr
  dcache1.io.waddr := memory.io.cache_array1.waddr
  dcache1.io.wdata := memory.io.cache_array1.wdata
  memory.io.cache_array1.rdata := dcache1.io.rdata
  dcache2.io.clock := clock
  dcache2.io.ren := memory.io.cache_array2.ren
  dcache2.io.wen := memory.io.cache_array2.wen
  dcache2.io.we := memory.io.cache_array2.we
  dcache2.io.raddr := memory.io.cache_array2.raddr
  dcache2.io.waddr := memory.io.cache_array2.waddr
  dcache2.io.wdata := memory.io.cache_array2.wdata
  memory.io.cache_array2.rdata := dcache2.io.rdata

  icache.io.clock := clock
  icache.io.ren := memory.io.icache.ren
  icache.io.wen := memory.io.icache.wen
  icache.io.raddr := memory.io.icache.raddr
  memory.io.icache.rdata := icache.io.rdata
  icache.io.waddr := memory.io.icache.waddr
  icache.io.wdata := memory.io.icache.wdata

  icache_valid.io.clock := clock
  icache_valid.io.ren := memory.io.icache_valid.ren
  icache_valid.io.wen := memory.io.icache_valid.wen
  icache_valid.io.invalidate := memory.io.icache_valid.invalidate
  icache_valid.io.addr := memory.io.icache_valid.addr
  icache_valid.io.iaddr := memory.io.icache_valid.iaddr
  memory.io.icache_valid.rdata := icache_valid.io.rdata
  icache_valid.io.wdata := memory.io.icache_valid.wdata
  icache_valid.io.idata := memory.io.icache_valid.idata
  icache_valid.io.ien := memory.io.icache_valid.invalidate

  pht_mem.io.clock := clock
  pht_mem.io.ren   := core.io.pht_mem.ren
  pht_mem.io.wen   := core.io.pht_mem.wen
  pht_mem.io.raddr := core.io.pht_mem.raddr
  core.io.pht_mem.rdata := pht_mem.io.rdata
  pht_mem.io.waddr := core.io.pht_mem.waddr
  pht_mem.io.wdata := core.io.pht_mem.wdata

  // Debug signals
  io.debugSignals.core <> core.io.debug_signal
  //io.debugSignals.raddr  := core.io.dmem.raddr
  // io.debugSignals.rdata  := memory.io.cache.rdata // dmem_decoder.io.initiator.rdata
  io.debugSignals.ren    := core.io.dmem.ren || core.io.cache.ren
  // io.debugSignals.rvalid := memory.io.cache.rvalid // dmem_decoder.io.initiator.rvalid
  // io.debugSignals.rwaddr  := core.io.dmem.waddr
  io.debugSignals.wdata  := core.io.dmem.wdata
  io.debugSignals.wen    := core.io.dmem.wen || core.io.cache.wen
  io.debugSignals.wready := memory.io.cache.wready // dmem_decoder.io.initiator.wready
  io.debugSignals.wstrb  := core.io.dmem.wstrb

  // io.debugSignals.dram_init_calib_complete := io.dram.init_calib_complete
  // io.debugSignals.dram_rdata_valid         := io.dram.rdata_valid
  // io.debugSignals.dram_busy                := io.dram.busy
  // io.debugSignals.dram_ren                 := io.dram.ren

  io.debugSignals.mem_icache_state := memory.io.icache_state
  io.debugSignals.mem_dram_state := memory.io.dram_state
  io.debugSignals.mem_imem_addr := core.io.imem.addr(15, 0)

  // io.debugSignals.sdc_cmd_wrt := sdc.io.sdc_port.cmd_wrt
  // io.debugSignals.sdc_cmd_out := sdc.io.sdc_port.cmd_out
  // io.debugSignals.sdc_res_in  := io.sdc_port.res_in
  // io.debugSignals.sdc_dat_in  := io.sdc_port.dat_in
  // io.debugSignals.sdc_rx_dat_index := sdc.io.rx_dat_index
  // io.debugSignals.sdc_sdbuf_ren1 := sdc.io.sdbuf.ren1
  // io.debugSignals.sdc_sdbuf_wen1 := sdc.io.sdbuf.wen1
  // io.debugSignals.sdc_sdbuf_addr1 := sdc.io.sdbuf.addr1
  // io.debugSignals.sdc_sdbuf_wdata1 := sdc.io.sdbuf.wdata1(7, 0)
  // io.debugSignals.sdc_sdbuf_ren2 := sdc.io.sdbuf.ren2
  // io.debugSignals.sdc_sdbuf_wen2 := sdc.io.sdbuf.wen2
  // io.debugSignals.sdc_sdbuf_addr2 := sdc.io.sdbuf.addr2

  // io.exit := core.io.exit
  io.gpio <> gpio.io.gpio
  io.uart_tx <> uart.io.tx
  io.uart_rx <> uart.io.rx
  io.sdc_port <> sdc.io.sdc_port

  intr.io.intr_periferal := Cat(sdc.io.intr.asUInt, uart.io.intr.asUInt)
  core.io.intr := intr.io.intr_cpu

  sdbuf.io.clock  := clock
  sdbuf.io.ren1   := sdc.io.sdbuf.ren1
  sdbuf.io.wen1   := sdc.io.sdbuf.wen1
  sdbuf.io.addr1  := sdc.io.sdbuf.addr1
  sdbuf.io.wdata1 := sdc.io.sdbuf.wdata1
  sdc.io.sdbuf.rdata1 := sdbuf.io.rdata1
  sdbuf.io.ren2   := sdc.io.sdbuf.ren2
  sdbuf.io.wen2   := sdc.io.sdbuf.wen2
  sdbuf.io.addr2  := sdc.io.sdbuf.addr2
  sdbuf.io.wdata2 := sdc.io.sdbuf.wdata2
  sdc.io.sdbuf.rdata2 := sdbuf.io.rdata2
}

object ElaborateArtyA7 extends App {
  (new ChiselStage).emitVerilog(new RiscV(100038910), Array(
    "-o", "riscv.v",
    "--target-dir", "rtl/riscv_arty_a7",
  ))
}

object ElaborateRunber extends App {
  (new ChiselStage).emitVerilog(new RiscV(12000000), Array(
    "-o", "riscv.v",
    "--target-dir", "rtl/riscv_runber",
  ))
}

object ElaborateTangNano9K extends App {
  (new ChiselStage).emitVerilog(new RiscV(27000000), Array(
    "-o", "riscv.v",
    "--target-dir", "rtl/riscv_tangnano9k",
  ))
}

