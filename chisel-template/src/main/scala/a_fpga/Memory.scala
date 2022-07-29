package fpga

import chisel3._
import chisel3.util._
import DramConsts._
import common.Consts._
import java.io.FileInputStream
import scala.collection.mutable.ArrayBuffer
import chisel3.util.experimental.loadMemoryFromFile

class ImemPortIo extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val inst = Output(UInt(WORD_LEN.W))
}

class DmemPortIo extends Bundle {
  val raddr  = Input(UInt(WORD_LEN.W))
  val rdata  = Output(UInt(WORD_LEN.W))
  val ren    = Input(Bool())
  val rvalid = Output(Bool())
  val rready = Output(Bool())

  val waddr  = Input(UInt(WORD_LEN.W))
  val wen    = Input(Bool())
  val wready = Output(Bool())
  val wstrb  = Input(UInt(4.W))
  val wdata  = Input(UInt(WORD_LEN.W))
}

class Memory(dataMemoryPath: String = null, imemSizeInBytes: Int = 16384, dmemSizeInBytes: Int = 16384) extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val dmem = new DmemPortIo()
    val imemReadPort = new MemoryReadPort(imemSizeInBytes/4, UInt(32.W))
    val dramPort = Flipped(new DramIo())
  })

  io.imem.inst := io.imemReadPort.data
  io.imemReadPort.address := io.imem.addr(WORD_LEN-1, 2)
  io.imemReadPort.enable := true.B

  io.dramPort.ren := io.dmem.ren
  io.dramPort.wen := io.dmem.wen
  val addr = Mux(io.dmem.ren, io.dmem.raddr, io.dmem.waddr)
  io.dramPort.addr := Cat(addr(DRAM_ADDR_WIDTH-1, 4), 0.U(3.W))
  io.dramPort.wdata := Cat(0.U((DRAM_DATA_WIDTH-WORD_LEN).W), io.dmem.wdata) << Cat(addr(3, 2), 0.U(5.W))
  io.dramPort.wmask := Cat(~0.U((DRAM_MASK_WIDTH-WORD_LEN/8).W), ~io.dmem.wstrb) << Cat(addr(3, 2), 0.U(2.W))
  io.dramPort.user_busy := false.B

  io.dmem.wready := io.dramPort.init_calib_complete && !io.dramPort.busy
  io.dmem.rready := io.dramPort.init_calib_complete && !io.dramPort.busy
  io.dmem.rdata := (io.dramPort.rdata >> Cat(addr(3, 2), 0.U(5.W)))(WORD_LEN-1, 0)
  io.dmem.rvalid := io.dramPort.rdata_valid

  /*
  val dataMem = Mem(dmemSizeInBytes/4, Vec(WORD_LEN/8, UInt(8.W)))
  if( dataMemoryPath != null ) {
    loadMemoryFromFile(dataMem, dataMemoryPath)
  }

  val rdata = RegInit(0.U(WORD_LEN.W))  
  val rvalid = RegInit(false.B)
  io.dmem.rdata := rdata
  io.dmem.rvalid := rvalid
  io.dmem.busy := false.B
  
  rvalid := false.B
  when( !io.dmem.wen && io.dmem.ren ) {
    rdata := Cat(dataMem.read(io.dmem.raddr(WORD_LEN-1, 2)).reverse)
    rvalid := true.B
  } 

  io.dmem.wready := true.B
  when(io.dmem.wen){
    val wdata = io.dmem.wdata
    dataMem.write(io.dmem.waddr(WORD_LEN-1, 2), VecInit((0 to (WORD_LEN/8)-1).map(i => wdata(8*(i+1)-1, 8*i))), io.dmem.wstrb.asBools)
  }
  */
}
