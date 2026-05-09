package fpga.periferals

import chisel3._
import chisel3.util._
import common.Consts._
import SdcConsts._
import fpga._

class SdBufPort extends Bundle {
  val ren1   = Input(Bool())
  val wen1   = Input(Bool())
  val addr1  = Input(UInt(8.W))
  val rdata1 = Output(UInt(32.W))
  val wdata1 = Input(UInt(32.W))
  val ren2   = Input(Bool())
  val wen2   = Input(Bool())
  val addr2  = Input(UInt(8.W))
  val rdata2 = Output(UInt(32.W))
  val wdata2 = Input(UInt(32.W))
}

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

class CrcGenerator(len: Int, g: Int) extends Module {
  val io = IO(new Bundle {
    val init_en   = Input(Bool())
    val init_dat  = Input(Vec(len, Bool()))
    val in_en     = Input(Bool())
    val in_bit    = Input(Bool())
    val out_bit   = Output(Bool())
    val crc_valid = Output(Bool())
  })

  val reg_crc = Reg(Vec(len, Bool()))

  when (io.init_en) {
    reg_crc := io.init_dat
  }

  when (io.in_en) {
    val crc_out = reg_crc(len - 1)
    reg_crc(0) := (if ((g & 1) != 0) io.in_bit ^ crc_out else io.in_bit)
    for (i <- 1 until len) {
      reg_crc(i) := (if (((g >> i) & 1) != 0) reg_crc(i - 1) ^ crc_out else reg_crc(i - 1))
    }
  }

  io.out_bit := reg_crc(len-1)
  io.crc_valid := Cat(reg_crc) === 0.U
}

// memory map
// 00000000 | settings |
//    8-0 : baud divider
//     16 : res_intr_en
//     17 : rx_dat_intr_en
//     18 : tx_empty_intr_en
//     19 : tx_end_intr_en
//     31 : power
// 00000004 | control / status |
//    3-0 : res_type
//    9-4 : cmd
//     11 : cmd/res enable
//     12 : single block read enable
//     13 : multi block read enable
//     14 : single block write enable
//     15 : multi block write enable
//  31-14 : reserved
//      0 : rx response ready
//      1 : rx response crc error
//      2 : rx response timeout
//      3 : buffer overrun
//     16 : rx data ready
//     17 : rx data crc error
//     18 : rx data timeout
//     19 : rx data overrun
//     20 : tx data buffer full
//     21 : tx data end
//  22-23 : tx data status
// 00000008 | command / response |
// 0000000c | data    | 

class Sdc() extends Module {
  val io = IO(new Bundle {
    val mem = new DmemPortIo
    val sdc_port = new SdcPort()
    val sdbuf    = Flipped(new SdBufPort())
    val intr = Output(Bool())
  })

  val cmd_bits: Int = 48
  val res_bits_max: Int = 48 // 136
  val tx_dat_len: Int = 24
  val rx_busy_timeout: Int = 500000 // sclk = 20ms (25MHz)
  val tx_dat_crc_status_len: Int = 3

  val crc7 = Module(new CrcGenerator(7, 9))

  val reg_power = RegInit(false.B)
  val reg_baud_divider = RegInit(2.U(9.W)) // actual divider = (d + 1) * 2
  val reg_clk_counter = RegInit(2.U(9.W))
  val reg_clk = RegInit(false.B)
  val reg_rdata = RegInit(0.U(WORD_LEN.W))
  val reg_clk_edge = RegInit(false.B)
  when (reg_power) {
    when (reg_clk_counter === 0.U) {
      reg_clk_counter := reg_baud_divider
      reg_clk := !reg_clk
    }.otherwise {
      reg_clk_counter := reg_clk_counter - 1.U
    }
  }.otherwise {
    reg_clk := false.B
  }
  reg_clk_edge := (reg_clk_counter === 1.U && reg_clk)
  io.sdc_port.clk := reg_clk

  val rx_res_in_progress = RegInit(false.B)
  val rx_res_counter = RegInit(0.U(log2Ceil(res_bits_max).W))
  val rx_res_waiting = RegInit(false.B)
  val rx_res_bits = Reg(Vec(res_bits_max, Bool()))
  val rx_res_next = RegInit(false.B)
  val rx_res_type = RegInit(0.U(RES_TYPE_LEN.W))
  val rx_res = RegInit(0.U(res_bits_max.W))
  val rx_res_ready = RegInit(false.B)
  val rx_res_intr_en = RegInit(false.B)
  // val rx_res_crc = Reg(Vec(7, Bool()))
  val rx_res_crc_error = RegInit(false.B)
  val rx_res_crc_en = RegInit(false.B)
  val rx_res_timer = RegInit(0.U(8.W))
  val rx_res_timeout = RegInit(false.B)
  val rx_res_read_counter = RegInit(0.U(2.W))
  val tx_cmd_arg = RegInit(0.U(32.W))
  val tx_cmd = Reg(Vec(cmd_bits, Bool()))
  val tx_cmd_counter = RegInit(0.U(log2Ceil(cmd_bits).W))
  val tx_cmd_requesting = RegInit(false.B)
  // val tx_cmd_crc = Reg(Vec(7, Bool()))
  val tx_cmd_wait_timer = RegInit(0.U(log2Ceil(48).W))
  val tx_cmd_waiting = RegInit(false.B)
  val reg_tx_cmd_wrt = RegInit(false.B)
  val reg_tx_cmd_out = RegInit(false.B)
  val rx_dat_in_progress = RegInit(false.B)
  val rx_dat_counter = RegInit(0.U(11.W))
  val rx_dat_waiting = RegInit(false.B)
  val rx_dat_start_bit = RegInit(false.B)
  val rx_dat_bits = Reg(Vec(8, UInt(4.W)))
  val rx_dat_next = RegInit(0.U(4.W))
  val rx_dat_continuous = RegInit(false.B)
  val rx_dat_ready = RegInit(false.B)
  val rx_dat_intr_en = RegInit(false.B)
  // val rx_dat_crc = Reg(Vec(16, UInt(4.W)))
  val rx_dat_crc_error = false.B // RegInit(false.B)
  val rx_dat_timer = RegInit(0.U(19.W))
  val rx_dat_timeout = RegInit(false.B)
  val rx_dat_overrun = RegInit(false.B)
  // val rxtx_dat = Mem(256, UInt(32.W))
  val rxtx_dat_counter = RegInit(0.U(8.W))
  val rxtx_dat_index = RegInit(0.U(8.W))
  val rx_busy_timer = RegInit(0.U(log2Ceil(rx_busy_timeout).W))
  val rx_busy_waiting = RegInit(false.B)
  val rx_busy_in_progress = RegInit(false.B)
  val rx_dat0_next = RegInit(true.B)
  val rx_dat_buf_read = RegInit(false.B)
  val rx_dat_buf_cache = RegInit(0.U(32.W))
  val reg_tx_dat_wrt = RegInit(false.B)
  val reg_tx_dat_out = RegInit(false.B)
  val tx_empty_intr_en = RegInit(false.B)
  val tx_end_intr_en = RegInit(false.B)
  val tx_dat_counter = RegInit(0.U(11.W))
  val tx_dat_timer = RegInit(0.U(6.W))
  val tx_dat = Reg(Vec(tx_dat_len, UInt(4.W)))
  val tx_dat_crc = Reg(Vec(16, UInt(4.W)))
  val tx_dat_prepared = RegInit(0.U(32.W))
  val tx_dat_prepare_state = RegInit(0.U(2.W))
  val tx_dat_started = RegInit(false.B)
  val tx_dat_continuous = RegInit(false.B)
  val tx_dat_in_progress = RegInit(false.B)
  val tx_dat_end = RegInit(false.B)
  val tx_dat_read_sel = RegInit(0.U(2.W))
  val tx_dat_write_sel = RegInit(0.U(2.W))
  val tx_dat_read_sel_changed = RegInit(false.B)
  val tx_dat_write_sel_new = RegInit(false.B)
  val tx_dat_crc_status_counter = RegInit(0.U(4.W))
  val tx_dat_crc_status_b = Reg(Vec(tx_dat_crc_status_len, UInt(1.W)))
  val tx_dat_crc_status = RegInit(0.U(2.W))
  val tx_dat_prepared_read = RegInit(false.B)

  crc7.io.in_en    := false.B
  crc7.io.in_bit   := DontCare
  crc7.io.init_en  := false.B
  crc7.io.init_dat := DontCare

  rx_res_next := io.sdc_port.res_in
  when (reg_clk_edge) {
    when (rx_res_waiting && !tx_cmd_requesting) {
      when (!rx_res_in_progress) {
        crc7.io.init_en  := true.B
        crc7.io.init_dat := 0.U(7.W).asBools
        // rx_res_crc := 0
      }
      when (!rx_res_in_progress && rx_res_next) {
        rx_res_timer := rx_res_timer - 1.U;
        when (rx_res_timer === 1.U) {
          rx_res_counter := 0.U
          rx_res := 0.U
          rx_res_ready := true.B
          rx_res_timeout := true.B
          rx_res_waiting := false.B
        }
      }
      when (rx_res_in_progress || !rx_res_next) {
        (0 to res_bits_max - 2).foreach(i => rx_res_bits(i + 1) := rx_res_bits(i))
        rx_res_bits(0) := rx_res_next
        rx_res_counter := rx_res_counter - 1.U
        rx_res_in_progress := true.B
        crc7.io.in_en  := true.B
        crc7.io.in_bit := rx_res_next
        //printf(cf"rx_res_crc    : 0x${Cat(rx_res_crc.reverse)}%x\n")
      }
    }
    when (rx_res_counter === 1.U) {
      //printf(cf"final rx_crc  : 0x${Cat(rx_res_crc.reverse)}%x\n")
      rx_res_in_progress := false.B
      rx_res := Cat(Cat(rx_res_bits.reverse), rx_res_next)
      rx_res_ready := true.B
      rx_res_crc_error := rx_res_crc_en && crc7.io.crc_valid
      rx_res_counter := rx_res_counter - 1.U
      rx_res_waiting := false.B
      when (rx_res_type === RES_TYPE_R1B) {
        rx_busy_timer := rx_busy_timeout.U
        rx_busy_waiting := true.B
      }
      tx_cmd_wait_timer := 48.U // wait 1 byte before next cmd
      tx_cmd_waiting := true.B
    }
  }

  io.sdc_port.cmd_wrt := reg_tx_cmd_wrt
  io.sdc_port.cmd_out := reg_tx_cmd_out

  when (reg_clk_edge) {
    when (tx_cmd_waiting) {
      tx_cmd_wait_timer := tx_cmd_wait_timer - 1.U
      when (tx_cmd_wait_timer === 1.U) {
        tx_cmd_waiting := false.B
      }
      reg_tx_cmd_wrt := false.B
      reg_tx_cmd_out := DontCare
    }.elsewhen (rx_busy_waiting) {
      reg_tx_cmd_wrt := false.B
      reg_tx_cmd_out := DontCare
    }.elsewhen (tx_cmd_requesting) {
      val is_crc_cycle = (tx_cmd_counter(5, 3) === 0.U)
      reg_tx_cmd_wrt := true.B
      reg_tx_cmd_out := Mux(is_crc_cycle, tx_cmd(0) ^ crc7.io.out_bit, tx_cmd(0))
      (0 to cmd_bits - 2).foreach(i => tx_cmd(i) := tx_cmd(i + 1))
      tx_cmd_counter := tx_cmd_counter - 1.U
      crc7.io.in_en  := true.B
      crc7.io.in_bit := Mux(tx_cmd_counter(5, 3) =/= 0.U, tx_cmd(7), crc7.io.out_bit)
      // val crc_out = tx_cmd_crc(6)
      // val crc = VecInit(
      //   tx_cmd(7) ^ crc_out,
      //   tx_cmd_crc(0),
      //   tx_cmd_crc(1),
      //   tx_cmd_crc(2) ^ crc_out,
      //   tx_cmd_crc(3),
      //   tx_cmd_crc(4),
      //   tx_cmd_crc(5),
      // )
      // tx_cmd_crc := crc
      //printf(cf"tx_cmd_crc    : 0x${Cat(tx_cmd_crc.reverse)}%x\n")
      //printf(cf"tx_crc        : 0x${Cat(crc.reverse)}%x\n")
      // when (tx_cmd_counter === 8.U) {
      //   (0 to 6).foreach(i => tx_cmd(i) := crc(6 - i))
      //   //printf(cf"final tx_crc  : 0x${Cat(crc.reverse)}%x\n")
      // }
      when (tx_cmd_counter === 0.U) {
        tx_cmd_requesting := false.B
      }
    }.elsewhen (!tx_cmd_requesting) {
      reg_tx_cmd_wrt := false.B
      reg_tx_cmd_out := DontCare
    }
  }

  io.sdc_port.dat_wrt := reg_tx_dat_wrt
  io.sdc_port.dat_out := reg_tx_dat_out

  io.sdbuf.ren1 := false.B
  io.sdbuf.wen1 := false.B
  io.sdbuf.addr1 := rxtx_dat_index
  io.sdbuf.wdata1 := DontCare
  io.sdbuf.ren2 := false.B
  io.sdbuf.wen2 := false.B
  io.sdbuf.addr2 := rxtx_dat_counter
  io.sdbuf.wdata2 := DontCare

  when (rx_dat_buf_read) {
    rx_dat_buf_cache := io.sdbuf.rdata2
    rx_dat_buf_read := false.B
  }
  when (tx_dat_prepared_read) {
    tx_dat_prepared := io.sdbuf.rdata1
    tx_dat_prepared_read := false.B
  }

  when (rx_dat_waiting && !tx_cmd_requesting) {
    rx_dat_next := io.sdc_port.dat_in
    when (reg_clk_edge) {
      when (!rx_dat_in_progress && rx_dat_next(0).asBool) {
        rx_dat_timer := rx_dat_timer - 1.U;
        when (rx_dat_timer === 1.U) {
          rx_dat_counter := 0.U
          rx_dat_waiting := false.B
          rx_dat_ready := true.B
          rx_dat_timeout := true.B
          io.sdbuf.ren2 := true.B
          rx_dat_buf_read := true.B
          rxtx_dat_counter := rxtx_dat_counter + 1.U
        }
      }.elsewhen (!rx_dat_in_progress && !rx_dat_next(0).asBool) {
        rx_dat_in_progress := true.B
      }.otherwise {
        (0 to 6).foreach(i => rx_dat_bits(i + 1) := rx_dat_bits(i))
        rx_dat_bits(0) := rx_dat_next
        rx_dat_counter := rx_dat_counter - 1.U
        // val crc_out = rx_dat_crc(15)
        // rx_dat_crc(0) := rx_dat_next ^ crc_out
        // rx_dat_crc(1) := rx_dat_crc(0)
        // rx_dat_crc(2) := rx_dat_crc(1)
        // rx_dat_crc(3) := rx_dat_crc(2)
        // rx_dat_crc(4) := rx_dat_crc(3)
        // rx_dat_crc(5) := rx_dat_crc(4) ^ crc_out
        // rx_dat_crc(6) := rx_dat_crc(5)
        // rx_dat_crc(7) := rx_dat_crc(6)
        // rx_dat_crc(8) := rx_dat_crc(7)
        // rx_dat_crc(9) := rx_dat_crc(8)
        // rx_dat_crc(10) := rx_dat_crc(9)
        // rx_dat_crc(11) := rx_dat_crc(10)
        // rx_dat_crc(12) := rx_dat_crc(11) ^ crc_out
        // rx_dat_crc(13) := rx_dat_crc(12)
        // rx_dat_crc(14) := rx_dat_crc(13)
        // rx_dat_crc(15) := rx_dat_crc(14)
        when (rx_dat_counter(2, 0) === 1.U && rx_dat_counter(10, 4) =/= 0.U) {
          rx_dat_start_bit := false.B
          when (!rx_dat_start_bit) {
            rxtx_dat_index := rxtx_dat_index + 1.U
            io.sdbuf.wen1 := true.B
            io.sdbuf.wdata1 := Cat(
              rx_dat_bits(1), rx_dat_bits(0),
              rx_dat_bits(3), rx_dat_bits(2),
              rx_dat_bits(5), rx_dat_bits(4),
              rx_dat_bits(7), rx_dat_bits(6),
            )
            // rxtx_dat.write(rxtx_dat_index, Cat(
            //   rx_dat_bits(1), rx_dat_bits(0),
            //   rx_dat_bits(3), rx_dat_bits(2),
            //   rx_dat_bits(5), rx_dat_bits(4),
            //   rx_dat_bits(7), rx_dat_bits(6),
            // ))
          }
        }
        when (rx_dat_counter === 1.U) {
          rx_dat_in_progress := false.B
          rx_dat_ready := true.B
          io.sdbuf.ren2 := true.B
          rx_dat_buf_read := true.B
          rxtx_dat_counter := rxtx_dat_counter + 1.U
          val crc_error = false.B // Cat(rx_dat_crc) =/= 0.U
          // rx_dat_crc_error := crc_error
          val overrun = rx_dat_ready
          rx_dat_overrun := overrun
          when (rx_dat_continuous && !crc_error && !overrun) {
            rx_dat_counter := (1024+16+1).U
            rx_dat_waiting := true.B
            rx_dat_timer := 500000.U // 20ms (25MHz)
            rx_dat_start_bit := true.B
            // rx_dat_crc := 0.U(16.W).asBools
          }.otherwise {
            rx_dat_waiting := false.B
          }
        }
      }
    }
  }

  /*
  when ((tx_dat_read_sel_changed && (tx_dat_read_sel =/= tx_dat_write_sel)) || tx_dat_write_sel_new) {
    tx_dat_counter := (1+1024+16+1).U
    io.sdbuf.ren1 := true.B
    tx_dat_prepared_read := true.B
    // tx_dat_prepared := rxtx_dat.read(rxtx_dat_index)
    rxtx_dat_index := rxtx_dat_index + 1.U
    tx_dat_prepare_state := 2.U
    tx_dat_timer := 255.U
    tx_dat_read_sel_changed := false.B
    tx_dat_write_sel_new := false.B
    tx_dat_in_progress := true.B
  }
  when (tx_dat_read_sel_changed && (tx_dat_read_sel === tx_dat_write_sel)) {
    tx_dat_in_progress := false.B
  }
  */

  rx_dat0_next := io.sdc_port.dat_in(0)
  when (reg_clk_edge) {
    when (rx_busy_waiting) {
      when (!rx_busy_in_progress && rx_dat0_next) {
        rx_busy_timer := rx_busy_timer - 1.U
        when (rx_busy_timer === 1.U) {
          rx_busy_waiting := false.B
        }
      }
      when (rx_busy_in_progress || !rx_dat0_next) {
        rx_busy_in_progress := true.B
        /*
        when (tx_dat_crc_status_counter > 0.U) {
          (0 to tx_dat_crc_status_len - 2).foreach(i => tx_dat_crc_status_b(i + 1) := tx_dat_crc_status_b(i))
          tx_dat_crc_status_b(0) := rx_dat0_next
          tx_dat_crc_status_counter := tx_dat_crc_status_counter - 1.U
          when (tx_dat_crc_status_counter === 2.U) {
            val crc_status = Cat(tx_dat_crc_status_b(2), tx_dat_crc_status_b(1), tx_dat_crc_status_b(0))
            tx_dat_crc_status := MuxCase(3.U(2.W), Seq(
              (crc_status === "b010".U) -> 0.U(2.W), // data accepted
              (crc_status === "b101".U) -> 1.U(2.W), // CRC error
              (crc_status === "b110".U) -> 2.U(2.W), // write error
            ))
            when (crc_status =/= "b010".U) {
              tx_dat_continuous := false.B
            }
            tx_dat_read_sel := tx_dat_read_sel + 1.U
            tx_dat_read_sel_changed := true.B
          }
        }.otherwise {
        */
          when (rx_dat0_next) {
            rx_busy_in_progress := false.B
            // rx_busy_timer := 0.U
            rx_busy_waiting := false.B
            when (tx_dat_started && !tx_dat_in_progress) {
              tx_dat_end := true.B
            }
          }
        // }
      }
    }
  }

  when ((tx_dat_read_sel_changed && (tx_dat_read_sel =/= tx_dat_write_sel)) || tx_dat_write_sel_new) {
    // false 優先
    tx_dat_end := false.B
  }

  reg_tx_dat_wrt := false.B
  reg_tx_dat_out := DontCare
  /*
  when (rx_busy_waiting && reg_clk_edge) {
    reg_tx_dat_wrt := false.B
    reg_tx_dat_out := DontCare
  }.elsewhen (tx_dat_timer =/= 0.U && reg_clk_edge) {
    tx_dat_timer := tx_dat_timer - 1.U
    reg_tx_dat_wrt := false.B
    reg_tx_dat_out := DontCare
  }.elsewhen (tx_dat_counter =/= 0.U && reg_clk_edge) {
    reg_tx_dat_wrt := true.B
    reg_tx_dat_out := tx_dat(0)
    (0 to tx_dat_len - 2).foreach(i => tx_dat(i) := tx_dat(i + 1))
    tx_dat_counter := tx_dat_counter - 1.U
    val crc_out = tx_dat_crc(15)
    val crc = VecInit(
      tx_dat(16) ^ crc_out,
      tx_dat_crc(0),
      tx_dat_crc(1),
      tx_dat_crc(2),
      tx_dat_crc(3),
      tx_dat_crc(4) ^ crc_out,
      tx_dat_crc(5),
      tx_dat_crc(6),
      tx_dat_crc(7),
      tx_dat_crc(8),
      tx_dat_crc(9),
      tx_dat_crc(10),
      tx_dat_crc(11) ^ crc_out,
      tx_dat_crc(12),
      tx_dat_crc(13),
      tx_dat_crc(14),
    )
    tx_dat_crc := crc
    //printf(cf"tx_dat_crc    : 0x${Cat(tx_dat_crc.reverse)}%x\n")
    //printf(cf"tx_crc        : 0x${Cat(crc.reverse)}%x\n")
    when (tx_dat_counter(10, 5) =/= 0.U && tx_dat_counter(2, 0) === 2.U) {
      io.sdbuf.ren1 := true.B
      tx_dat_prepared_read := true.B
      // tx_dat_prepared := rxtx_dat.read(rxtx_dat_index)
      rxtx_dat_index := rxtx_dat_index + 1.U
      tx_dat_prepare_state := 1.U
    }.elsewhen (tx_dat_counter(10, 4) === 1.U && tx_dat_counter(2, 0) === 2.U) {
      tx_dat_prepared := 0.U(32.W)
      tx_dat_prepare_state := 1.U
    }
    when (tx_dat_counter === 18.U) {
      (0 to 15).foreach(i => tx_dat(i) := crc(15 - i))
      tx_dat(16) := 15.U(4.W)
      //printf(cf"final tx_crc  : 0x${Cat(crc.reverse)}%x\n")
    }
    when (tx_dat_counter === 1.U) {
      reg_tx_dat_wrt := false.B
      reg_tx_dat_out := DontCare
      rx_busy_timer := rx_busy_timeout.U
      tx_dat_crc_status_counter := 6.U
    }
  }
  */

  /*
  switch (tx_dat_prepare_state) {
    is (1.U) {
      tx_dat(16) := tx_dat_prepared(7, 4)
      tx_dat(17) := tx_dat_prepared(3, 0)
      tx_dat(18) := tx_dat_prepared(15, 12)
      tx_dat(19) := tx_dat_prepared(11, 8)
      tx_dat(20) := tx_dat_prepared(23, 20)
      tx_dat(21) := tx_dat_prepared(19, 16)
      tx_dat(22) := tx_dat_prepared(31, 28)
      tx_dat(23) := tx_dat_prepared(27, 24)
      tx_dat_prepare_state := 0.U
    }
    is (2.U) {
      tx_dat(0) := 0.U(4.W)
      tx_dat(1) := tx_dat_prepared(7, 4)
      tx_dat(2) := tx_dat_prepared(3, 0)
      tx_dat(3) := tx_dat_prepared(15, 12)
      tx_dat(4) := tx_dat_prepared(11, 8)
      tx_dat(5) := tx_dat_prepared(23, 20)
      tx_dat(6) := tx_dat_prepared(19, 16)
      tx_dat(7) := tx_dat_prepared(31, 28)
      tx_dat(8) := tx_dat_prepared(27, 24)
      io.sdbuf.ren1 := true.B
      tx_dat_prepared_read := true.B
      // tx_dat_prepared := rxtx_dat.read(rxtx_dat_index)
      rxtx_dat_index := rxtx_dat_index + 1.U
      tx_dat_prepare_state := 3.U
    }
    is (3.U) {
      tx_dat(9)  := tx_dat_prepared(7, 4)
      tx_dat(10) := tx_dat_prepared(3, 0)
      tx_dat(11) := tx_dat_prepared(15, 12)
      tx_dat(12) := tx_dat_prepared(11, 8)
      tx_dat(13) := tx_dat_prepared(23, 20)
      tx_dat(14) := tx_dat_prepared(19, 16)
      tx_dat(15) := tx_dat_prepared(31, 28)
      tx_dat(16) := tx_dat_prepared(27, 24)
      tx_dat_prepare_state := 0.U
    }
  }
  */

  io.mem.rdata := reg_rdata // "xdeadbeef".U
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
        rx_res_intr_en   := io.mem.wdata(16)
        rx_dat_intr_en   := io.mem.wdata(17)
        tx_empty_intr_en := io.mem.wdata(18)
        tx_end_intr_en   := io.mem.wdata(19)
      }
      is (1.U) {
        when (io.mem.wdata(11).asBool) {
          val tx_cmd_val = Cat(0.U, 1.U, io.mem.wdata(9, 4), tx_cmd_arg, 0.U(7.W), 1.U(1.W))
          tx_cmd := tx_cmd_val.asBools.reverse
          tx_cmd_counter := 47.U
          tx_cmd_requesting := true.B
          // tx_cmd_crc := tx_cmd_val(47, 41).asBools
          crc7.io.init_en := true.B
          crc7.io.init_dat := tx_cmd_val(47, 41).asBools
          rx_res_type := io.mem.wdata(3, 0)
          rx_res_in_progress := false.B
          rx_res_ready := false.B
          // rx_res_crc := 0.U(7.W).asBools
          // rx_res_crc_error := false.B
          rx_res_crc_en := true.B
          rx_res_timer := 255.U
          rx_res_timeout := false.B
          rx_res_read_counter := 0.U
          rx_res_waiting := false.B
          when (io.mem.wdata(3, 0) === RES_TYPE_NONE) {
            rx_res_counter := 0.U
          }.elsewhen (io.mem.wdata(3, 0) === RES_TYPE_R2) {
            rx_res_counter := 136.U
            rx_res_crc_en := false.B
            rx_res_waiting := true.B
          }.elsewhen (io.mem.wdata(3, 0) === RES_TYPE_R3) {
            rx_res_counter := 48.U
            rx_res_crc_en := false.B
            rx_res_waiting := true.B
          }.otherwise {
            rx_res_counter := 48.U
            rx_res_waiting := true.B
          }
          when (io.mem.wdata(12).asBool || io.mem.wdata(13).asBool) {
            rx_dat_in_progress := false.B
            rx_dat_counter := (1024+16+1).U
            rx_dat_waiting := true.B
            rx_dat_start_bit := true.B
            rx_dat_ready := false.B
            // rx_dat_crc := 0.U(16.W).asBools
            // rx_dat_crc_error := false.B
            rx_dat_timer := 500000.U // 20ms (25MHz)
            rx_dat_timeout := false.B
            rx_dat_continuous := io.mem.wdata(13).asBool
            rx_dat_overrun := false.B
            rxtx_dat_index := 0.U
            rxtx_dat_counter := 0.U
          }.otherwise {
            rx_dat_counter := 0.U
            rx_dat_waiting := false.B
            rx_dat_ready := false.B
          }
          // when (io.mem.wdata(14).asBool || io.mem.wdata(15).asBool) {
          //   tx_dat_started := true.B
          //   tx_dat_continuous := io.mem.wdata(15).asBool
          //   tx_dat_read_sel := 0.U
          //   tx_dat_write_sel := 0.U
          //   tx_dat_read_sel_changed := false.B
          //   tx_dat_write_sel_new := false.B
          //   tx_dat_in_progress := false.B
          //   tx_dat_end := false.B
          //   rxtx_dat_index := 0.U
          //   rxtx_dat_counter := 0.U
          // }.otherwise {
            tx_dat_started := false.B
            tx_dat_continuous := false.B
          // }
        }
      }
      is (2.U) {
        tx_cmd_arg := io.mem.wdata
      }
      is (3.U) {
        // when ((tx_dat_read_sel ^ tx_dat_write_sel) =/= "b10".U) {
        //   rxtx_dat_counter := rxtx_dat_counter + 1.U
        //   io.sdbuf.wen2 := true.B
        //   io.sdbuf.wdata2 := io.mem.wdata
        //   // rxtx_dat.write(rxtx_dat_counter, io.mem.wdata)
        // }
        // when (rxtx_dat_counter(6, 0) === 127.U) {
        //   tx_dat_write_sel := tx_dat_write_sel + 1.U
        //   when (tx_dat_read_sel === tx_dat_write_sel) {
        //     tx_dat_write_sel_new := true.B
        //   }
        // }
      }
    }
  }
  when (io.mem.ren) {
    val addr = io.mem.raddr(3, 2)
    switch (addr) {
      is (0.U) {
        reg_rdata := Cat(
          reg_power.asUInt,
          0.U(11.W),
          tx_end_intr_en.asUInt,
          tx_empty_intr_en.asUInt,
          rx_dat_intr_en.asUInt,
          rx_res_intr_en.asUInt,
          0.U(7.W),
          reg_baud_divider
        )
      }
      is (1.U) {
        reg_rdata := Cat(
          0.U(8.W),
          tx_dat_crc_status,
          tx_dat_started && tx_dat_end,
          tx_dat_started && ((tx_dat_read_sel ^ tx_dat_write_sel) === "b10".U),
          rx_dat_overrun.asUInt,
          rx_dat_timeout.asUInt,
          rx_dat_crc_error.asUInt,
          rx_dat_ready.asUInt,
          0.U(13.W),
          rx_res_timeout.asUInt,
          rx_res_crc_error.asUInt,
          rx_res_ready.asUInt
        )
      }
      is (2.U) {
        rx_res_read_counter := rx_res_read_counter + 1.U
        when (rx_res_type === RES_TYPE_R2) {
          reg_rdata := (rx_res >> Cat(rx_res_read_counter, 0.U(5.W)))(31, 0)
          when (rx_res_read_counter === 3.U) {
            rx_res_ready := false.B
          }
        }.otherwise {
          reg_rdata := rx_res(39, 8)
          rx_res_ready := false.B
        }
      }
      is (3.U) {
        reg_rdata := rx_dat_buf_cache
        when (rx_dat_ready) {
          rxtx_dat_counter := rxtx_dat_counter + 1.U
          io.sdbuf.ren2 := true.B
          rx_dat_buf_read := true.B
          // reg_rdata := rxtx_dat.read(rxtx_dat_counter)
          when (rxtx_dat_counter(6, 0) === 127.U) {
            rx_dat_ready := false.B
          }
        }
      }
    }
  }

  io.intr := (rx_res_intr_en && rx_res_ready) ||
    (rx_dat_intr_en && rx_dat_ready) ||
    (tx_empty_intr_en && tx_dat_started && (tx_dat_read_sel ^ tx_dat_write_sel) =/= "b10".U)
    (tx_end_intr_en && tx_dat_started && tx_dat_end)

  printf(cf"sdc.clk           : 0x${reg_clk}%x\n")
  printf(cf"sdc.cmd_wrt       : 0x${io.sdc_port.cmd_wrt}%x\n")
  printf(cf"sdc.cmd_out       : 0x${io.sdc_port.cmd_out}%x\n")
  printf(cf"rx_res_counter    : 0x${rx_res_counter}%x\n")
  printf(cf"rx_dat_counter    : 0x${rx_dat_counter}%x\n")
  printf(cf"rx_dat_next       : 0x${rx_dat_next}%x\n")
  printf(cf"tx_cmd_counter    : 0x${tx_cmd_counter}%x\n")
  printf(cf"tx_dat_counter    : 0x${tx_dat_counter}%x\n")
  printf(cf"tx_cmd_wait_timer : 0x${tx_cmd_wait_timer}%x\n")
  printf(cf"rx_busy_timer     : 0x${rx_busy_timer}%x\n")
  printf(cf"tx_dat_read_sel   : 0x${tx_dat_read_sel}%x\n")
  printf(cf"tx_dat_write_sel  : 0x${tx_dat_write_sel}%x\n")
  printf(cf"tx_dat_started    : ${tx_dat_started}\n")
  printf(cf"tx_dat_in_progress: ${tx_dat_in_progress}\n")
}
