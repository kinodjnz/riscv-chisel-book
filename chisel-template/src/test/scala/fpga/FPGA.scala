package fpga

import chiseltest._
import scala.util.control.Breaks
import org.scalatest.flatspec.AnyFlatSpec
import chisel3._
import chisel3.util._
import fpga.sim._

class RiscvTest extends AnyFlatSpec with ChiselScalatestTester {
    val dutName = "RiscV"
    behavior of dutName

    val args = Array(
        s"-tn=$dutName",
        s"-td=test_run_dir/$dutName",
        s"-tgvo=on",
    )

    val tests = Array(
      // ("bootrom", 100),
      // ("fizzbuzz", 5000),
      // ("mtimer", 1000),
      // ("br", 1000),
      // ("loop", 1000),
      // ("sdc_rx", 7000),
      // ("sdc_tx", 7000),
      ("zbb", 1000),
      ("icache", 200),
      ("dcache", 200),
      ("rv32ui-p-add", 1000),
      ("rv32ui-p-addi", 1000),
      ("rv32ui-p-and", 1000),
      ("rv32ui-p-andi", 1000),
      ("rv32ui-p-auipc", 1000),
      ("rv32ui-p-beq", 1000),
      ("rv32ui-p-bge", 1000),
      ("rv32ui-p-bgeu", 1000),
      ("rv32ui-p-blt", 1000),
      ("rv32ui-p-bltu", 1000),
      ("rv32ui-p-bne", 1000),
      // ("rv32ui-p-fence_i", 1000),
      ("rv32ui-p-jal", 1000),
      ("rv32ui-p-jalr", 1000),
      ("rv32ui-p-lb", 1000),
      ("rv32ui-p-lbu", 1000),
      ("rv32ui-p-lh", 1000),
      ("rv32ui-p-lhu", 1000),
      ("rv32ui-p-lui", 1000),
      ("rv32ui-p-lw", 1000),
      ("rv32ui-p-or", 1000),
      ("rv32ui-p-ori", 1000),
      ("rv32ui-p-sb", 1000),
      ("rv32ui-p-sh", 1000),
      ("rv32ui-p-simple", 1000),
      ("rv32ui-p-sll", 1000),
      ("rv32ui-p-slli", 1000),
      ("rv32ui-p-slt", 1000),
      ("rv32ui-p-slti", 1000),
      ("rv32ui-p-sltiu", 1000),
      ("rv32ui-p-sltu", 1000),
      ("rv32ui-p-sra", 1000),
      ("rv32ui-p-srai", 1000),
      ("rv32ui-p-srl", 1000),
      ("rv32ui-p-srli", 1000),
      ("rv32ui-p-sub", 1000),
      ("rv32ui-p-sw", 1000),
      ("rv32ui-p-xor", 1000),
      ("rv32ui-p-xori", 1000),
      ("rv32uc-p-rvc", 1000),
      ("rv32um-p-mul", 1000),
      ("rv32um-p-mulh", 1000),
      ("rv32um-p-mulhu", 1000),
      ("rv32um-p-mulhsu", 1000),
      ("rv32um-p-div", 1000),
      ("rv32um-p-divu", 1000),
      ("rv32um-p-rem", 1000),
      ("rv32um-p-remu", 1000),
    )
    for( (code, timeOut) <- tests ) {
        it must f"runs ${code}" in {
          test(new SimTop(f"../riscv-tests/isa/${code}.binhex", code.startsWith("sdc"))) { c =>
            c.clock.setTimeout(timeOut)
            while (!c.io.exit.peek().litToBoolean){
              c.clock.step(1)
            }
            c.io.gp.expect(1.U)
          }
        }
    }
}
