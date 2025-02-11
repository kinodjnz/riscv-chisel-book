package fpga

import chiseltest._
import scala.util.control.Breaks
import org.scalatest.flatspec.FixtureAnyFlatSpec
import org.scalatest.fixture._
import org.scalatest._
import chisel3._
import chisel3.util._
import chiseltest.experimental._
import fpga.sim._
import scala.util.Using

class RiscvTest extends FixtureAnyFlatSpec with ChiselScalatestTester with TestDataFixture {
  behavior of "RiscV"

  val tests = Array(
    ("fizzbuzz", 5000),
    ("dhry", 10000),
    ("mtimer", 1000),
    ("br", 1000),
    ("loop", 1000),
    ("sdc_rx", 7000),
    ("sdc_tx", 7000),
    ("zbb", 1000),
    ("xcc", 1000),
    ("xcr", 1000),
    ("fsl", 1000),
    ("fsr", 1000),
    ("fsri", 1000),
    ("bsct", 1000),
    ("rrd", 1000),
    ("lw", 1000),
    ("bfm", 1000),
    ("bfmi", 1000),
    ("bfmp", 1000),
    ("bfp", 1000),
    ("bfpi", 1000),
    ("bfpp", 1000),
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
    ("rv32ui-p-fence_i", 1000),
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
    ("rv32uzbb-p-andn", 1000),
    ("rv32uzbb-p-clz", 1000),
    ("rv32uzbb-p-cpop", 1000),
    ("rv32uzbb-p-ctz", 1000),
    ("rv32uzbb-p-max", 1000),
    ("rv32uzbb-p-maxu", 1000),
    ("rv32uzbb-p-min", 1000),
    ("rv32uzbb-p-minu", 1000),
    // ("rv32uzbb-p-orc_b", 1000),
    ("rv32uzbb-p-orn", 1000),
    ("rv32uzbb-p-rev8", 1000),
    ("rv32uzbb-p-rol", 1000),
    ("rv32uzbb-p-ror", 1000),
    ("rv32uzbb-p-rori", 1000),
    ("rv32uzbb-p-sext_b", 1000),
    ("rv32uzbb-p-sext_h", 1000),
    ("rv32uzbb-p-xnor", 1000),
    ("rv32uzbb-p-zext_h", 1000),
    ("rv32uzba-p-sh1add", 1000),
    ("rv32uzba-p-sh2add", 1000),
    ("rv32uzba-p-sh3add", 1000),
    ("rv32uzbs-p-bclr", 1000),
    ("rv32uzbs-p-bset", 1000),
    ("rv32uzbs-p-binv", 1000),
    ("rv32uzbs-p-bext", 1000),
    ("rv32uzbs-p-bclri", 1000),
    ("rv32uzbs-p-bseti", 1000),
    ("rv32uzbs-p-binvi", 1000),
    ("rv32uzbs-p-bexti", 1000),
    ("rv32mi-p-lh-misaligned", 1000),
    ("rv32mi-p-lw-misaligned", 1000),
    ("rv32mi-p-sh-misaligned", 1000),
    ("rv32mi-p-sw-misaligned", 1000),
  )
  for ((code, timeOut) <- tests) {
    it must f"runs ${code}" in { td: TestData =>
      test(new SimTop(f"../riscv-tests/isa/${code}.binhex", code.startsWith("sdc"), true))
          .withAnnotations(Seq(VerilatorBackendAnnotation)) { c =>
        Using(KanataWriter(s"test_run_dir/${sanitizeFileName(td.name)}/trace.kanata")) { writer =>
          c.clock.setTimeout(timeOut)
          while (c.io.sim_probe.exit.peek().litValue == 0){
            writer.write(c.io.pipeline_probe)
            c.clock.step(1)
          }
          c.io.sim_probe.gp.expect(1.U)
        }
      }
    }
  }
}
