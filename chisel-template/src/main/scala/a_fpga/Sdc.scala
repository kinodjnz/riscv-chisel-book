package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import chisel3.stage.ChiselStage
import SdcConsts._

class SdcPort extends Bundle {
  val clk     = Output(Bool())
  val cmd_wrt = Output(Bool())
  val cmd_out = Output(Bool())
  val res_in  = Input(Bool())
  val dat_wrt = Output(Bool())
  val dat_out = Output(UInt(4.W))
  val dat_in  = Input(UInt(4.W))
}

object SdcConsts {
  val RES_TYPE_LEN = 4
  val RES_TYPE_NONE = 0.U(RES_TYPE_LEN.W)
  val RES_TYPE_R1   = 1.U(RES_TYPE_LEN.W)
  val RES_TYPE_R1B  = 5.U(RES_TYPE_LEN.W)
  val RES_TYPE_R2   = 2.U(RES_TYPE_LEN.W)
  val RES_TYPE_R3   = 3.U(RES_TYPE_LEN.W)
  val RES_TYPE_R6   = 6.U(RES_TYPE_LEN.W)
  val RES_TYPE_R7   = 7.U(RES_TYPE_LEN.W)
}

// memory map
// 00000000 | power | 0000000 | 000000 | width | 0000000 | baud divider |
// 00000004 | control / status |
//    3-0 : res_type
//    9-4 : cmd
//     11 : cmd/res enable
//  31-12 : reserved
//      0 : res_ready
//      8 : crc error
//      9 : buffer 
// 00000008 | command / response |
// 0000000c | data    | 

class Sdc() extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val sdc_port = new SdcPort()
  })

  val cmd_bits: Int = 48
  val res_bits: Int = 136

  val reg_power = RegInit(false.B)
  val reg_baud_divider = RegInit(2.U(9.W)) // actual divider = (d + 1) * 2
  val reg_clk_counter = RegInit(2.U(9.W))
  val reg_clk = RegInit(false.B)
  when (reg_power) {
    when (reg_clk_counter === 0.U) {
      reg_clk_counter := reg_baud_divider
      reg_clk := !reg_clk
    }.otherwise {
      reg_clk_counter := reg_clk_counter - 1.U
    }
  }
  io.sdc_port.clk := reg_clk

  val rx_res_in_progress = RegInit(false.B)
  val rx_res_counter = RegInit(0.U(8.W))
  val rx_res_bits = Reg(Vec(res_bits, Bool()))
  val rx_res_next = RegInit(false.B)
  val rx_res_type = RegInit(0.U(RES_TYPE_LEN.W))
  val rx_res = RegInit(0.U(136.W))
  val rx_res_ready = RegInit(false.B)
  val rx_res_crc = Reg(Vec(7, Bool()))
  val rx_res_crc_error = RegInit(false.B)
  val tx_cmd_arg = RegInit(0.U(32.W))
  val tx_cmd = Reg(Vec(cmd_bits, Bool()))
  val tx_cmd_counter = RegInit(0.U(6.W))
  val tx_cmd_crc = Reg(Vec(7, Bool()))
  val reg_tx_cmd_wrt = RegInit(false.B)
  val reg_tx_cmd_out = RegInit(false.B)

  when (rx_res_counter > 0.U && tx_cmd_counter === 0.U) {
    rx_res_next := io.sdc_port.res_in
    when (reg_clk_counter === 0.U && !reg_clk) {
      when (rx_res_in_progress || !rx_res_next) {
        (0 to res_bits - 2).foreach(i => rx_res_bits(i + 1) := rx_res_bits(i))
        rx_res_bits(0) := rx_res_next
        rx_res_counter := rx_res_counter - 1.U
        rx_res_in_progress := true.B
        val crc_out = rx_res_crc(6)
        rx_res_crc(0) := rx_res_next ^ crc_out
        rx_res_crc(1) := rx_res_crc(0)
        rx_res_crc(2) := rx_res_crc(1)
        rx_res_crc(3) := rx_res_crc(2) ^ crc_out
        rx_res_crc(4) := rx_res_crc(3)
        rx_res_crc(5) := rx_res_crc(4)
        rx_res_crc(6) := rx_res_crc(5)
        //printf(p"rx_res_crc    : 0x${Hexadecimal(Cat(rx_res_crc.reverse))}\n")
        when (rx_res_counter === 1.U) {
          //printf(p"final rx_crc  : 0x${Hexadecimal(Cat(rx_res_crc.reverse))}\n")
          rx_res_in_progress := false.B
          rx_res := Cat(Cat(rx_res_bits.reverse), rx_res_next)
          rx_res_ready := true.B
          rx_res_crc_error := Cat(rx_res_crc) =/= 0.U
        }
      }
    }
  }

  io.sdc_port.cmd_wrt := reg_tx_cmd_wrt
  io.sdc_port.cmd_out := reg_tx_cmd_out

  when (tx_cmd_counter > 0.U && reg_clk_counter === 0.U && !reg_clk) {
    reg_tx_cmd_wrt := true.B
    reg_tx_cmd_out := tx_cmd(0)
    (0 to cmd_bits - 2).foreach(i => tx_cmd(i) := tx_cmd(i + 1))
    tx_cmd_counter := tx_cmd_counter - 1.U
    val crc_out = tx_cmd_crc(6)
    val crc = VecInit(
      tx_cmd(7) ^ crc_out,
      tx_cmd_crc(0),
      tx_cmd_crc(1),
      tx_cmd_crc(2) ^ crc_out,
      tx_cmd_crc(3),
      tx_cmd_crc(4),
      tx_cmd_crc(5),
    )
    tx_cmd_crc := crc
    //printf(p"tx_cmd_crc    : 0x${Hexadecimal(Cat(tx_cmd_crc.reverse))}\n")
    //printf(p"tx_crc        : 0x${Hexadecimal(Cat(crc.reverse))}\n")
    when (tx_cmd_counter === 9.U) {
      (0 to 6).foreach(i => tx_cmd(i) := crc(6 - i))
      //printf(p"final tx_crc  : 0x${Hexadecimal(Cat(crc.reverse))}\n")
    }
  }.elsewhen (tx_cmd_counter === 0.U && reg_clk_counter === 0.U && !reg_clk) {
    reg_tx_cmd_wrt := false.B
    reg_tx_cmd_out := DontCare
  }

  io.sdc_port.dat_wrt := false.B
  io.sdc_port.dat_out := DontCare

  io.mem.rdata := "xdeadbeef".U
  io.mem.rvalid := true.B
  io.mem.rready := true.B
  io.mem.wready := true.B

  when (io.mem.wen) {
    val addr = io.mem.waddr(3, 2)
    switch (addr) {
      is (0.U) {
        val baud_divider = io.mem.wdata(8, 0)
        when (baud_divider =/= 0.U) {
          reg_power := io.mem.wdata(31)
          reg_baud_divider := baud_divider
          reg_clk_counter := baud_divider
        }
      }
      is (1.U) {
        when (io.mem.wdata(11).asBool) {
          val tx_cmd_val = Cat(0.U, 1.U, io.mem.wdata(9, 4), tx_cmd_arg, 0.U(7.W), 1.U(1.W))
          tx_cmd := tx_cmd_val.asBools.reverse
          tx_cmd_counter := 48.U
          tx_cmd_crc := tx_cmd_val(47, 41).asBools
          rx_res_type := io.mem.wdata(3, 0)
          rx_res_in_progress := false.B
          rx_res_ready := false.B
          rx_res_crc := 0.U(7.W).asBools
          rx_res_crc_error := false.B
          when (io.mem.wdata(3, 0) === RES_TYPE_R2) {
            rx_res_counter := 136.U
          }.otherwise {
            rx_res_counter := 48.U
          }
        }
      }
      is (2.U) {
        tx_cmd_arg := io.mem.wdata
      }
    }
  }
  when (io.mem.ren) {
    val addr = io.mem.raddr(3, 2)
    switch (addr) {
      is (1.U) {
        io.mem.rdata := Cat(Fill(23, 0.U(1.W)), rx_res_crc_error.asUInt, Fill(7, 0.U(1.W)), rx_res_ready.asUInt)
      }
      is (2.U) {
        when (rx_res_type === RES_TYPE_R2) {
          io.mem.rdata := rx_res(127, 96) // TODO
        }.otherwise {
          io.mem.rdata := rx_res(39, 8)
        }
      }
    }
  }

  printf(p"sdc.clk           : 0x${Hexadecimal(reg_clk)}\n")
  printf(p"sdc.cmd_wrt       : 0x${Hexadecimal(io.sdc_port.cmd_wrt)}\n")
  printf(p"sdc.cmd_out       : 0x${Hexadecimal(io.sdc_port.cmd_out)}\n")
}
