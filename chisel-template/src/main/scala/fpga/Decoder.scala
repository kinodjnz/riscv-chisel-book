package fpga

import chisel3._
import chisel3.util._
import common.Consts._

class DMemDecoder(targetAddressRanges: Seq[(BigInt, BigInt)]) extends Module {
  val io = IO(new Bundle {
    val initiator = new DmemPortIo()
    val targets = Vec(targetAddressRanges.size, Flipped(new DmemPortIo))
  })

  val rvalid = WireDefault(true.B)
  val rready = WireDefault(true.B)
  val rdata = WireDefault("xdeadbeef".U(WORD_LEN.W))
  val wready = WireDefault(false.B)

  io.initiator.rready := rready
  io.initiator.rvalid := rvalid
  io.initiator.rdata := rdata
  io.initiator.wready := wready

  for(((start, length), index) <- targetAddressRanges.zipWithIndex) {
    val bits: Int = log2Ceil(length)
    val target = io.targets(index)

    val raddr = WireDefault(0.U(WORD_LEN.W))
    val ren = WireDefault(false.B)
    val waddr = WireDefault(0.U(WORD_LEN.W))
    val wen = WireDefault(false.B)
    val wdata = WireDefault("xdeadbeef".U(WORD_LEN.W))
    val wstrb = WireDefault("b1111".U)
    val latched_raddr = RegInit(0.U(WORD_LEN.W))

    target.raddr := raddr
    target.ren := ren
    target.waddr := waddr
    target.wen := wen
    target.wdata := wdata
    target.wstrb := wstrb

    raddr := io.initiator.raddr
    waddr := io.initiator.waddr
    wdata := io.initiator.wdata
    wstrb := io.initiator.wstrb

    when (start.U(WORD_LEN-1, bits) === io.initiator.raddr(WORD_LEN-1, bits)) {
      // raddr := io.initiator.raddr(bits-1, 0)
      ren := io.initiator.ren
      rready := target.rready // TODO renからrreadyまではfalseを返すべき
      when (ren && rready) {
        latched_raddr := raddr
      }
    }
    when (start.U(WORD_LEN-1, bits) === latched_raddr(WORD_LEN-1, bits)) {
      rvalid := target.rvalid
      rdata := target.rdata
    }
    when (start.U(WORD_LEN-1, bits) === io.initiator.waddr(WORD_LEN-1, bits)) {
      // waddr := io.initiator.waddr(bits-1, 0)
      wen := io.initiator.wen
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

  for (((start, length), index) <- targetAddressRanges.zipWithIndex) {
    val bits: Int = log2Ceil(length)
    val target = io.targets(index)

    val addr = WireDefault(0.U(WORD_LEN.W))
    val en = WireDefault(false.B)

    target.addr := addr
    target.en := en

    when (start.U(WORD_LEN-1, bits) === io.initiator.addr(WORD_LEN-1, bits)) {
      addr := io.initiator.addr(bits-1, 0)
      en := io.initiator.en
    }
    when (start.U(WORD_LEN-1, bits) === next_addr(WORD_LEN-1, bits)) {
      valid := target.valid
      inst := target.inst
    }
  }
}
