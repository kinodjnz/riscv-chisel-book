package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import DramConsts._
import chisel3.stage.ChiselStage
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations.MemorySynthInit


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

  val raddr  = Output(UInt(WORD_LEN.W))
  val rdata = Output(UInt(WORD_LEN.W))
  val ren   = Output(Bool())
  val rvalid = Output(Bool())

  val waddr  = Output(UInt(WORD_LEN.W))
  val wen   = Output(Bool())
  val wready = Output(Bool())
  val wstrb = Output(UInt(4.W))
  val wdata = Output(UInt(WORD_LEN.W))

  val dram_init_calib_complete = Output(Bool())
  val dram_rdata_valid         = Output(Bool())
  val dram_busy                = Output(Bool())
  val dram_ren                 = Output(Bool())
}

class RiscV(clockHz: Int) extends Module {
  val imemSizeInBytes = 2048
  val dmemSizeInBytes = 512
  val startAddress = 0x08000000L

  val io = IO(new Bundle {
    val dram = Flipped(new DramIo())
    val gpio = Output(UInt(8.W))
    val uart_tx = Output(Bool())
    val exit = Output(Bool())
    val debugSignals = new RiscVDebugSignals()
  })
  val core = Module(new Core(startAddress, 0x3FFFFL))
  
  val memory = Module(new Memory(null, imemSizeInBytes, dmemSizeInBytes))
  val imem_dbus = Module(new SingleCycleMem(imemSizeInBytes))
  val gpio = Module(new Gpio)
  val uart = Module(new Uart(clockHz))
  val config = Module(new Config(clockHz))

  val decoder = Module(new DMemDecoder(Seq(
    (BigInt(startAddress), BigInt(imemSizeInBytes)),
    (BigInt(0x20000000L), BigInt(dmemSizeInBytes)),
    (BigInt(0x30000000L), BigInt(64)),  // GPIO
    (BigInt(0x30001000L), BigInt(64)),  // UART
    (BigInt(0x30002000L), BigInt(64)),  // mtimer
    (BigInt(0x40000000L), BigInt(64)),  // CONFIG
  )))
  decoder.io.targets(0) <> imem_dbus.io.mem
  decoder.io.targets(1) <> memory.io.dmem
  decoder.io.targets(2) <> gpio.io.mem
  decoder.io.targets(3) <> uart.io.mem
  decoder.io.targets(4) <> core.io.mtimer_mem
  decoder.io.targets(5) <> config.io.mem

  val imem_rdata = RegInit(0.U(WORD_LEN.W))
  val imem_rdata2 = RegInit(0.U(WORD_LEN.W))
  memory.io.imemReadPort.data := imem_rdata
  imem_dbus.io.read.data := imem_rdata2

  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })

  val imem = Mem(imemSizeInBytes/4, UInt(WORD_LEN.W))
  loadMemoryFromFileInline(imem, "bootrom.hex")
  when (memory.io.imemReadPort.enable) {
    imem_rdata := imem.read(memory.io.imemReadPort.address(8, 0))
  }
  val rwaddr = Mux(imem_dbus.io.write.enable, imem_dbus.io.write.address, imem_dbus.io.read.address)
  when (imem_dbus.io.write.enable) {
    imem.write(rwaddr, imem_dbus.io.write.data)
  }
  when (!imem_dbus.io.write.enable && imem_dbus.io.read.enable) {
    imem_rdata2 := imem.read(rwaddr)
  }

  core.io.imem <> memory.io.imem
  // core.io.dmem <> memory.io.dmem
  core.io.dmem <> decoder.io.initiator

  // dram
  io.dram <> memory.io.dramPort

  // Debug signals
  io.debugSignals.core <> core.io.debug_signal
  io.debugSignals.raddr  := core.io.dmem.raddr  
  io.debugSignals.rdata  := decoder.io.initiator.rdata  
  io.debugSignals.ren    := core.io.dmem.ren    
  io.debugSignals.rvalid := decoder.io.initiator.rvalid 
  io.debugSignals.waddr  := core.io.dmem.waddr  
  io.debugSignals.wdata  := core.io.dmem.wdata
  io.debugSignals.wen    := core.io.dmem.wen    
  io.debugSignals.wready := decoder.io.initiator.wready 
  io.debugSignals.wstrb  := core.io.dmem.wstrb

  io.debugSignals.dram_init_calib_complete := io.dram.init_calib_complete
  io.debugSignals.dram_rdata_valid         := io.dram.rdata_valid
  io.debugSignals.dram_busy                := io.dram.busy
  io.debugSignals.dram_ren                 := io.dram.ren

  io.exit := core.io.exit
  io.gpio <> gpio.io.gpio
  io.uart_tx <> uart.io.tx
  core.io.intr <> uart.io.intr
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

