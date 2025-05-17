package fpga.sim

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import fpga._

class FetchSim() extends Module {
  val io = IO(new FetchUnitPort)
  val regs = Reg(Input(new FetchUnitPort))
  val reg_reset = RegInit(true.B)
  val fetch = Module(new FetchUnit(DramConfig()))

  fetch.reset := reset.asBool | reg_reset
  fetch.io.flush_en := regs.flush_en
  fetch.io.inst2_ready := regs.inst2_ready
  fetch.io.imem.inst := regs.imem.inst
  fetch.io.icache.addr_ready := regs.icache.addr_ready
  fetch.io.icache.idata := regs.icache.idata
  fetch.io.imem.valid := regs.imem.valid
  fetch.io.inst1_ready := regs.inst1_ready
  fetch.io.icache.idata_valid := regs.icache.idata_valid
  fetch.io.flush_iaddr := regs.flush_iaddr
  reg_reset := reset
  regs := io
  io :<= fetch.io
  // regs := fetch.io
  // io <> regs
}

object ElaborateFetchSim extends App {
  (new ChiselStage).emitVerilog(new FetchSim(), Array(
    "-o", "fetch.v",
    "--target-dir", "rtl/sim",
    "--throw-on-first-error"
  ))
}
