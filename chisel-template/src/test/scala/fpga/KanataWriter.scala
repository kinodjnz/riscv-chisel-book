
package fpga

import java.io.{PrintWriter, File}
import chiseltest._

object KanataWriter {
    def apply(filename: String): KanataWriter = new KanataWriter(new PrintWriter(new File(filename)))
}

class KanataWriter(private val writer: PrintWriter) extends AutoCloseable {
    writer.println("Kanata\t0004")

    def write(probe: PipelineProbe) = {
        if (probe.if2_valid.peek().litValue != 0) {
            val if2_inst_id = probe.if2_inst_id.peek().litValue
            writer.println(s"I\t${if2_inst_id}\t${if2_inst_id}\t0")
            writer.printf("L\t%d\t0\t%08x %08x\n", if2_inst_id.longValue, probe.if2_pc.peek().litValue.longValue, probe.if2_inst.peek().litValue.longValue)
            writer.println(s"S\t${if2_inst_id}\t0\tIF")
        }
        if (probe.id_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.id_inst_id.peek().litValue}\t0\tID")
        }
        if (probe.rrd_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.rrd_inst_id.peek().litValue}\t0\tRRD")
        }
        if (probe.ex1_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.ex1_inst_id.peek().litValue}\t0\tEX1")
        }
        if (probe.ex2_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.ex2_inst_id.peek().litValue}\t0\tEX2")
        }
        if (probe.mem1_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.mem1_inst_id.peek().litValue}\t0\tMEM1")
        }
        if (probe.mem2_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.mem2_inst_id.peek().litValue}\t0\tMEM2")
        }
        if (probe.mem3_valid.peek().litValue != 0) {
            writer.println(s"S\t${probe.mem3_inst_id.peek().litValue}\t0\tMEM3")
        }
        writer.println("C\t1")
        if (probe.if2_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.if2_inst_id.peek().litValue}\t0\tIF")
        }
        if (probe.id_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.id_inst_id.peek().litValue}\t0\tID")
        }
        if (probe.rrd_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.rrd_inst_id.peek().litValue}\t0\tRRD")
        }
        if (probe.ex1_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.ex1_inst_id.peek().litValue}\t0\tEX1")
        }
        if (probe.ex2_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.ex2_inst_id.peek().litValue}\t0\tEX2")
        }
        if (probe.ex2_retired.peek().litValue != 0) {
            val inst_id = probe.ex2_inst_id.peek().litValue
            writer.println(s"R\t${inst_id}\t${inst_id}\t0")
        }
        if (probe.mem1_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.mem1_inst_id.peek().litValue}\t0\tMEM1")
        }
        if (probe.mem2_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.mem2_inst_id.peek().litValue}\t0\tMEM2")
        }
        if (probe.mem3_valid.peek().litValue != 0) {
            writer.println(s"E\t${probe.mem3_inst_id.peek().litValue}\t0\tMEM3")
        }
        if (probe.mem3_retired.peek().litValue != 0) {
            val inst_id = probe.mem3_inst_id.peek().litValue
            writer.println(s"R\t${inst_id}\t${inst_id}\t0")
        }
    }

    override def close() = writer.close()
}
