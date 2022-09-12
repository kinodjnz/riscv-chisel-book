package fpga

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import CacheConsts._

object SdState extends ChiselEnum {
  val WaitCmd = Value
  val Command = Value
  val WaitRes = Value
  val Respond = Value
}

class MockSd extends Module {
  val io = IO(new Bundle() {
    val sdc_port = Flipped(new SdcPort)
  })

  val prev_clk = RegInit(false.B)
  val cmd_bits = Reg(Vec(48, Bool()))
  val sd_state = RegInit(SdState.WaitCmd)
  val cmd_counter = RegInit(0.U(6.W))
  val cmd = RegInit(0.U(48.W))
  val wait_counter = RegInit(0.U(6.W))
  val res_bits = RegInit(VecInit((0 to 47).map(_ => 1.U(1.W))))
  val res_counter = RegInit(0.U(6.W))
  val dat_bits = RegInit(VecInit((0 to 15).map(_ => 15.U(4.W))))
  val dat_counter = RegInit(0.U(11.W))

  prev_clk := io.sdc_port.clk
  when (prev_clk && !io.sdc_port.clk) {
    (0 to 46).foreach(i => cmd_bits(i + 1) := cmd_bits(i))
    cmd_bits(0) := io.sdc_port.cmd_out
    (0 to 46).foreach(i => res_bits(i) := res_bits(i + 1))
    res_bits(47) := res_bits(0)
    (0 to 14).foreach(i => dat_bits(i) := dat_bits(i + 1))
    dat_bits(15) := dat_bits(0)
    switch (sd_state) {
      is (SdState.WaitCmd) {
        when (io.sdc_port.cmd_wrt && !io.sdc_port.cmd_out) {
          sd_state := SdState.Command
          cmd_counter := 47.U
        }
      }
      is (SdState.Command) {
        cmd_counter := cmd_counter - 1.U
        when (cmd_counter === 0.U) {
          cmd := Cat(cmd_bits.reverse)
          sd_state := SdState.WaitRes
          wait_counter := 8.U
        }
      }
      is (SdState.WaitRes) {
        wait_counter := wait_counter - 1.U
        when (wait_counter === 0.U) {
          sd_state := SdState.Respond
          res_counter := 47.U
          res_bits := cmd.asBools.reverse
          dat_counter := (1024 + 16 + 1).U
          dat_bits := VecInit((0 to 15).map(_ => 0.U(4.W)))
        }
      }
      is (SdState.Respond) {
        res_counter := res_counter - 1.U
        when (res_counter === 0.U) {
          res_bits := Fill(48, 1.U(1.W)).asBools
        }
        dat_counter := dat_counter - 1.U
        when (dat_counter === (1 + 16 + 1024).U) {
          dat_bits := VecInit((0 to 15).map(_ => 13.U(4.W)))
        }.elsewhen (dat_counter === (1 + 16).U) {
          dat_bits := VecInit((0 to 15).map(i => (((0xeda9 >> (15 - i)) & 1) * 13).U(4.W)))
        }.elsewhen (dat_counter === 1.U) {
          dat_bits := VecInit((0 to 15).map(_ => 15.U(4.W)))
        }
      }
    }
  }
  io.sdc_port.res_in := res_bits(0)
  io.sdc_port.dat_in := dat_bits(0)

  printf(p"sd_state           : 0x${Hexadecimal(sd_state.asUInt)}\n")
}
