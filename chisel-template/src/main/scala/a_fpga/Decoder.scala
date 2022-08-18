package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.stage.ChiselStage

class DMemDecoder(targetAddressRanges: Seq[(BigInt, BigInt)]) extends Module {
  val io = IO(new Bundle {
    val initiator = new DmemPortIo()
    val targets = Vec(targetAddressRanges.size, Flipped(new DmemPortIo))
  })

  val rvalid = WireDefault(true.B)
  val rdata = WireDefault("xdeadbeef".U(WORD_LEN.W))
  val rready = WireDefault(false.B)
  val wready = WireDefault(false.B)

  io.initiator.rvalid := rvalid
  io.initiator.rdata := rdata
  io.initiator.rready := rready
  io.initiator.wready := wready

  for(((start, length), index) <- targetAddressRanges.zipWithIndex) {
    val target = io.targets(index)

    val raddr = WireDefault(0.U(32.W))
    val ren = WireDefault(false.B)
    val waddr = WireDefault(0.U(32.W))
    val wen = WireDefault(false.B)
    val wdata = WireDefault("xdeadbeef".U(WORD_LEN.W))
    val wstrb = WireDefault("b1111".U)
    
    target.raddr := raddr
    target.ren := ren
    target.waddr := waddr
    target.wen := wen
    target.wdata := wdata
    target.wstrb := wstrb

    when(start.U <= io.initiator.raddr && io.initiator.raddr < (start + length).U ) {
      raddr := io.initiator.raddr - start.U
      ren := io.initiator.ren
      rvalid := target.rvalid
      rdata := target.rdata
      rready := target.rready
    }
    when(start.U <= io.initiator.waddr && io.initiator.waddr < (start + length).U ) {
      waddr := io.initiator.waddr - start.U
      wen := io.initiator.wen
      wdata := io.initiator.wdata
      wstrb := io.initiator.wstrb
      wready := target.wready
    }
  }
}

class IMemDecoder(targetAddressRanges: Seq[(BigInt, BigInt)]) extends Module {
  val io = IO(new Bundle {
    val initiator = new ImemPortIo()
    val targets = Vec(targetAddressRanges.size, Flipped(new ImemPortIo))
  })

  val valid = WireDefault(true.B)
  val inst = WireDefault("xdeadbeef".U(WORD_LEN.W))
  val next_addr = RegNext(io.initiator.addr)

  io.initiator.valid := valid
  io.initiator.inst := inst

  for(((start, length), index) <- targetAddressRanges.zipWithIndex) {
    val target = io.targets(index)

    val addr = WireDefault(0.U(WORD_LEN.W))
    val en = WireDefault(false.B)

    target.addr := addr
    target.en := en

    when(start.U <= io.initiator.addr && io.initiator.addr < (start + length).U ) {
      addr := io.initiator.addr - start.U
      en := io.initiator.en
    }
    when(start.U <= next_addr && next_addr < (start + length).U ) {
      valid := target.valid
      inst := target.inst
    }
  }
}
