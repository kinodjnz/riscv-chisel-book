package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import common.UIntExtension._

case class DramConfig(
  dram_start: BigInt = 0x2000_0000L,
  dram_length: BigInt = 0x1000_0000L,
) {
  def dram_addr_bits: Int = log2Ceil(dram_length)
  def is_dram(addr: UInt): Bool = addr(WORD_LEN-1, dram_addr_bits) === dram_start.U(WORD_LEN-1, dram_addr_bits)
}

class FetchedInstruction(redirect_buffer_size: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val valid      = Output(Bool())
  val addr       = Output(UInt(PC_LEN.W))
  val data       = Output(UInt(WORD_LEN.W))
  val bpfailed   = Output(Bool())
  val redirected = Output(Bool())
  val bp_entry   = Output(new BranchPredictionEntry())
  val fp_ptr     = Output(UInt(fp_ptr_len.W))
  val ready      = Input(Bool())
}

class FetchPort(redirect_buffer_size: Int) extends Bundle {
  val flush_en    = Input(Bool())
  val flush_iaddr = Input(UInt(PC_LEN.W))
  val inst1       = new FetchedInstruction(redirect_buffer_size)
  val inst2       = new FetchedInstruction(redirect_buffer_size)

  val imem   = Flipped(new ImemPortIo())
  val icache = Flipped(new CachedImemPort())
}

class FetchUnit(
  dram_config: DramConfig,
  zbtb_entries: Int,
  btb_entries: Int,
  pht_index_len: Int,
  pht_history_len: Int,
  ras_entries: Int,
  redirect_buffer_size: Int,
) extends Module {
  val ras_index_len  = log2Ceil(ras_entries)

  val io = IO(new Bundle {
    val ft         = new FetchPort(redirect_buffer_size)
    val cr         = new BranchCorrectionPort(pht_history_len, ras_entries)
    val redir_deq  = new RedirectDequeuePort
    val redir_read = new RedirectReadPort(redirect_buffer_size, pht_history_len, ras_entries)
    val pht_lmem   = Flipped(new PHTMemIo(pht_index_len))
    val pht_gmem   = Flipped(new PHTMemIo(pht_index_len))
  })

  val fetcher = Module(new Fetcher(dram_config, pht_history_len, redirect_buffer_size))
  val fp = Module(new FetchPredictor(zbtb_entries, btb_entries, pht_index_len, pht_history_len, ras_entries, redirect_buffer_size))
  val rb = Module(new FetchRedirectBuffer(redirect_buffer_size, pht_history_len, ras_entries))
  val zbtb = Module(new ZBTB(zbtb_entries))
  val btb  = Module(new BTB(btb_entries))
  val pht  = Module(new PHT(pht_index_len, pht_history_len, PHT_HISTORY_SHIFT))
  val ras  = Module(new RAS(ras_index_len))

  io.ft <> fetcher.io.ft
  io.cr <> fp.io.cr
  io.redir_deq <> rb.io.deq
  io.redir_read <> rb.io.read
  io.pht_lmem <> fp.io.pht_lmem
  io.pht_gmem <> fp.io.pht_gmem
  fp.io.pr <> fetcher.io.pr
  fp.io.re <> rb.io.enq
  fp.io.ru <> rb.io.upd
  fp.io.zbtb <> zbtb.io
  fp.io.btb <> btb.io
  fp.io.pht <> pht.io
  fp.io.ras <> ras.io
}

class Fetcher(
  dram_config: DramConfig,
  pht_history_len: Int,
  redirect_buffer_size: Int,
) extends Module {
  val FETCH_BUFFER_SIZE   = 4
  val FETCH_PTR_LEN       = log2Ceil(FETCH_BUFFER_SIZE)
  val DISCARD_BUFFER_SIZE = FETCH_BUFFER_SIZE * 2
  val DISCARD_PTR_LEN     = log2Ceil(DISCARD_BUFFER_SIZE)
  val fp_ptr_len          = log2Ceil(redirect_buffer_size)

  val io = IO(new Bundle {
    val ft = new FetchPort(redirect_buffer_size)
    val pr = Flipped(new FetchPredictionPort(pht_history_len))
  })

  class FetchBuffer extends Bundle {
    val iaddr         = UInt(PC_LEN.W)
    val idata         = UInt(FETCH_BLOCK_LEN.W)
    val iblock_cont   = Bool()
    val end_of_iblock = UInt(IALIGN_PTR_LEN.W)
    val bp_entries    = Vec(4, new BranchPredictionEntry())
    val fp_ptr        = UInt(fp_ptr_len.W)
  }

  val fetch_buf = Mem(FETCH_BUFFER_SIZE, new FetchBuffer)
  val addressing_ptr = RegInit(0.U((FETCH_PTR_LEN + 1).W))
  val fetch_ptr      = RegInit(0.U((FETCH_PTR_LEN + 1).W))
  val read_ptr       = RegInit(0.U((FETCH_PTR_LEN + 1).W))

  val discard_buf = RegInit(VecInit.fill(DISCARD_BUFFER_SIZE)(true.B))
  val discard_enq = RegInit(0.U(DISCARD_PTR_LEN.W))
  val discard_deq = RegInit(0.U(DISCARD_PTR_LEN.W))

  val forward_discard_en  = WireDefault(false.B)
  val forward_discard_ptr = Wire(UInt(DISCARD_PTR_LEN.W))
  val forward_discard     = Wire(Bool())

  val forward_i0_en  = WireDefault(false.B)
  val forward_i0_ptr = Wire(UInt(FETCH_PTR_LEN.W))
  val forward_i0     = Wire(UInt(IALIGN_PTR_LEN.W))

  val reg_addressed = RegInit(false.B)

  def if0: Unit = {
    val reg_next_iaddr    = RegInit(0x0000fff0.U(PC_LEN.W))
    val iaddr             = Wire(UInt(PC_LEN.W))
    val fix_zbp_miss      = Wire(Bool())
    val reg_fix_zbp_miss  = RegInit(false.B)
    val reg_fix_addr      = RegInit(0.U(PC_LEN.W))
    val reg_discard_enq   = RegInit(0.U(DISCARD_PTR_LEN.W))
    val reg_is_dram       = RegInit(false.B)
    val reg_wait_for_dram = RegInit(false.B)
    val wait_for_dram     = WireDefault(false.B)

    val invalidate        = reg_fix_zbp_miss && reg_addressed
    reg_discard_enq := discard_enq
    val zbp_miss          =
      !invalidate && (
        (io.pr.bp0_en && !io.pr.bp1_en) ||
        (!io.pr.bp0_en && io.pr.bp1_en) ||
        (io.pr.bp0_en && io.pr.bp1_en && (io.pr.bp0_addr(7, 0) =/= io.pr.bp1_addr(7, 0) || io.pr.bp0_pos =/= io.pr.bp1_pos))
      )

    iaddr := MuxCase(reg_next_iaddr, Seq(
      io.ft.flush_en   -> io.ft.flush_iaddr,
      reg_fix_zbp_miss -> reg_fix_addr,
      io.pr.bp0_en     -> io.pr.bp0_addr,
    ))
    reg_next_iaddr := iaddr.clear_lsbits(IALIGN_PTR_LEN) + (1 << IALIGN_PTR_LEN).U(PC_LEN.W)
    fix_zbp_miss := !io.ft.flush_en && zbp_miss
    val fix_addr = Mux(io.pr.bp1_en, io.pr.bp1_addr, reg_next_iaddr)
    reg_fix_addr := fix_addr
    reg_fix_zbp_miss := fix_zbp_miss

    val count = addressing_ptr - read_ptr
    val has_space = (~count(FETCH_PTR_LEN)).asBool
    // val has_space = count < 3.U
    val is_dram = dram_config.is_dram(iaddr.pc_to_word)
    reg_is_dram := is_dram
    val redirect_ready = !(reg_fix_zbp_miss || io.pr.bp0_en) || io.pr.redirect_ready

    when (invalidate && !io.ft.flush_en) {
      addressing_ptr := addressing_ptr - 1.U
    }
    when (reg_is_dram && !is_dram && discard_enq =/= discard_deq) {
      wait_for_dram := true.B
      reg_is_dram := true.B
    }

    io.ft.imem.addr      := iaddr.clear_lsbits(IALIGN_PTR_LEN).pc_to_word
    io.ft.imem.en        := ((has_space && redirect_ready) || io.ft.flush_en) && !wait_for_dram && !is_dram
    io.ft.icache.addr    := iaddr.clear_lsbits(IALIGN_PTR_LEN).pc_to_word
    io.ft.icache.addr_en := ((has_space && redirect_ready) || io.ft.flush_en) && is_dram
    io.pr.flush_en       := io.ft.flush_en
    io.pr.redirect_en    := io.ft.flush_en || reg_fix_zbp_miss || io.pr.bp0_en
    io.pr.iaddr          := iaddr
    when ((!(has_space && redirect_ready) && !io.ft.flush_en) || wait_for_dram || (is_dram && !io.ft.icache.addr_ready)) {
      reg_next_iaddr   := iaddr
      io.pr.iaddr_en   := false.B
      reg_addressed    := false.B
    }.otherwise {
      io.pr.iaddr_en  := true.B
      reg_addressed   := true.B
      discard_enq     := discard_enq + 1.U
      when (invalidate && !io.ft.flush_en) {
        addressing_ptr := addressing_ptr
      }.otherwise {
        addressing_ptr := addressing_ptr + 1.U
      }

      printf(cf"fb(${addressing_ptr}%x): 0x${Cat(iaddr, 0.U(1.W))}%x addressed\n")
    }

    when (io.ft.flush_en) {
      fetch_buf(addressing_ptr.take(FETCH_PTR_LEN) - 1.U).iblock_cont := false.B
      for (i <- 0 until DISCARD_BUFFER_SIZE) {
        discard_buf(i) := true.B
      }
    }

    val ptr = Mux(
      invalidate && !io.ft.flush_en,
      (addressing_ptr - 1.U).take(FETCH_PTR_LEN),
      addressing_ptr.take(FETCH_PTR_LEN),
    )
    when ((has_space && redirect_ready) || io.ft.flush_en) {
      fetch_buf(ptr).iaddr       := iaddr
      fetch_buf(ptr).iblock_cont := true.B
      forward_i0_en              := true.B
    }
    forward_i0_ptr := ptr
    forward_i0     := iaddr.take(IALIGN_PTR_LEN)

    when (reg_addressed) {
      discard_buf(reg_discard_enq) := invalidate || io.ft.flush_en
      forward_discard_en           := true.B
    }
    forward_discard_ptr := reg_discard_enq
    forward_discard     := invalidate || io.ft.flush_en

    printf(cf"iaddr=${iaddr ## 0.U(1.W)}%x\n")
    printf(cf"reg_next_iaddr=${reg_next_iaddr ## 0.U(1.W)}%x\n")
    printf(cf"io.ft.imem.addr=${io.ft.imem.addr}%x\n")
    printf(cf"io.ft.imem.en=${io.ft.imem.en}\n")
    printf(cf"fix_zbp_miss=${fix_zbp_miss}\n")
    printf(cf"reg_fix_zbp_miss=${reg_fix_zbp_miss}\n")
    printf(cf"addressing=${addressing_ptr.take(FETCH_PTR_LEN)}\n")
    printf(cf"fb(0).iaddr=${fetch_buf(0.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(1).iaddr=${fetch_buf(1.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(2).iaddr=${fetch_buf(2.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(3).iaddr=${fetch_buf(3.U).iaddr ## 0.U(1.W)}%x\n")
  }

  def if1: Unit = {
    io.ft.icache.idata_ready := true.B
    val idata = Mux(io.ft.imem.valid, io.ft.imem.inst, io.ft.icache.idata)
    val fetch_in_progress = (addressing_ptr =/= fetch_ptr)
    when (fetch_in_progress) {
      fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).idata := idata
    }

    val discard = Mux(
      forward_discard_en && (forward_discard_ptr === discard_deq),
      forward_discard,
      discard_buf(discard_deq),
    )
    val bp_ptr = addressing_ptr.take(FETCH_PTR_LEN) - 1.U
    when (reg_addressed) {
      when (io.pr.bp1_en && !discard) {
        fetch_buf(bp_ptr).iblock_cont := false.B
      }
      fetch_buf(bp_ptr).end_of_iblock := Mux(io.pr.bp1_en, io.pr.bp1_pos, 3.U)
      fetch_buf(bp_ptr).bp_entries    := io.pr.bp_entries
      fetch_buf(bp_ptr).fp_ptr        := io.pr.fp_ptr
      printf(cf"fb(${bp_ptr}).fp_ptr=${io.pr.fp_ptr}\n")
    }

    when (io.ft.imem.valid || io.ft.icache.idata_valid) {
      discard_deq := discard_deq + 1.U
      when (!discard) {
        fetch_ptr := fetch_ptr + 1.U

        printf(cf"io.ft.imem.valid=${io.ft.imem.valid} io.ft.icache.idata_valid=${io.ft.icache.idata_valid}\n")
        printf(cf"fb(${fetch_ptr}%x): " +
          cf"0x${Cat(fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).iaddr, 0.U(1.W))}%x: " +
          cf"0x${idata}%x fetched\n")
      }
    }

    when (io.ft.flush_en) {
      fetch_ptr := addressing_ptr
    }
  }

  def if2: Unit = {
    val reg_i0 = RegInit(0.U(IALIGN_PTR_LEN.W))
    val reg_reset_i0 = RegInit(Bool(), false.B)

    val count = fetch_ptr - read_ptr
    val sat_count = Mux(count < 2.U, count.take(FETCH_PTR_LEN), 2.U)

    val end_of_iblocks = Seq.tabulate(2)(i => fetch_buf(read_ptr.take(FETCH_PTR_LEN) + i.U).end_of_iblock)
    val iblock_cont = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).iblock_cont
    val end_of_iblock = Mux(iblock_cont, 1.U(1.W) ## end_of_iblocks(1), 0.U(1.W) ## end_of_iblocks(0))
    val iaddrs = Seq.tabulate(2)(i => fetch_buf(read_ptr.take(FETCH_PTR_LEN) + i.U).iaddr)
    val idata0 = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).idata
    val idata1 = fetch_buf(read_ptr.take(FETCH_PTR_LEN) + 1.U).idata
    val idatas = (idata1.take(FETCH_BLOCK_LEN - IALIGN_LEN) ## idata0).subdivideInVec(IALIGN_LEN)
    val is_halfs = VecInit(idatas.take(6).map(x => x.take(2) =/= 3.U))
    val bpe0 = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).bp_entries
    val bpe1 = fetch_buf(read_ptr.take(FETCH_PTR_LEN) + 1.U).bp_entries
    val bp_entries = VecInit(bpe0 ++ bpe1.take(3))
    val fp_ptr = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).fp_ptr
    val redir_oh = UIntToOH(end_of_iblocks(1)) ## Mux(iblock_cont, 0.U(4.W), UIntToOH(end_of_iblocks(0)))

    val i0 = 0.U(1.W) ## reg_i0
    val i1 = i0 + 1.U
    val i2 = i0 + 2.U
    val i3 = i0 + 3.U
    val inst1_half = is_halfs(i0)
    val inst1_past = Mux(inst1_half, i1, i2)
    val inst1_end  = Mux(inst1_half, i0, i1)
    val inst2_half = Mux(inst1_half, is_halfs(i1), is_halfs(i2))
    val inst2_past = inst1_past + Mux(inst1_half, 1.U, 2.U)
    val inst2_end = Mux(inst1_half,
      Mux(is_halfs(i1), i1, i2),
      Mux(is_halfs(i2), i2, i3),
    )
    val inst1_valid = MuxCase(inst1_end <= end_of_iblock, Seq(
      (io.ft.flush_en || sat_count === 0.U) -> false.B,
      (sat_count === 1.U)                   -> (inst1_end <= end_of_iblocks(0)),
    ))
    val inst2_valid = MuxCase(inst2_end <= end_of_iblock, Seq(
      (io.ft.flush_en || sat_count === 0.U) -> false.B,
      (sat_count === 1.U)                   -> (inst2_end <= end_of_iblocks(0)),
    ))
    val iaddr0 = iaddrs(0).replace_lsbits(2, reg_i0)
    val inst1_bpfailed = !io.ft.flush_en && sat_count =/= 0.U && !inst1_half && end_of_iblock === i0
    io.ft.inst1.addr       := iaddr0
    io.ft.inst1.data       := idatas(i1) ## idatas(i0)
    io.ft.inst1.bpfailed   := inst1_bpfailed
    // io.ft.inst1.half       := inst1_half
    io.ft.inst1.redirected := redir_oh(inst1_end)
    io.ft.inst1.bp_entry   := bp_entries(inst1_end)
    io.ft.inst1.fp_ptr     := fp_ptr
    io.ft.inst1.valid      := inst1_valid || inst1_bpfailed
    io.ft.inst2.addr       := Mux(inst1_past(IALIGN_PTR_LEN), iaddrs(1), iaddr0)
      .replace_lsbits(IALIGN_PTR_LEN, inst1_past.take(IALIGN_PTR_LEN))
    io.ft.inst2.data       := Mux(is_halfs(i0), idatas(i2) ## idatas(i1), idatas(i3) ## idatas(i2))
    io.ft.inst2.bpfailed   := false.B // Mux(is_halfs(i0), !is_halfs(i1) && end_of_iblock === i1, !is_halfs(i2) && end_of_iblock === i2)
    // io.ft.inst2.half       := Mux(is_halfs(i0), is_halfs(i1), is_halfs(i2))
    io.ft.inst2.redirected := redir_oh(inst2_end)
    io.ft.inst2.bp_entry   := bp_entries(inst2_end)
    io.ft.inst2.fp_ptr     := fp_ptr
    io.ft.inst2.valid      := inst2_valid
    val inst_past = MuxCase(i0, Seq(
      ((                     io.ft.inst2.ready) && inst2_valid) -> inst2_past,
      ((io.ft.inst1.ready || io.ft.inst2.ready) && inst1_valid) -> inst1_past,
    ))
    val next_read_ptr = read_ptr + MuxCase(0.U, Seq(
      (inst1_valid && end_of_iblock(IALIGN_PTR_LEN) && inst_past > end_of_iblock) -> 2.U,
      (inst1_valid && (inst_past(IALIGN_PTR_LEN) || inst_past > end_of_iblock))   -> 1.U,
    ))
    read_ptr := next_read_ptr
    when (inst1_valid && inst_past > end_of_iblock) {
      val ptr = next_read_ptr.take(FETCH_PTR_LEN)
      reg_i0 := Mux(
        forward_i0_en && (ptr === forward_i0_ptr),
        forward_i0,
        fetch_buf(ptr).iaddr.take(IALIGN_PTR_LEN)
      )
      reg_reset_i0 := true.B
    }.elsewhen (!inst1_valid && reg_reset_i0) {
      reg_i0 := Mux(
        forward_i0_en && (read_ptr === forward_i0_ptr),
        forward_i0,
        fetch_buf(read_ptr).iaddr.take(IALIGN_PTR_LEN)
      )
      reg_reset_i0 := true.B
    }.otherwise {
      reg_i0 := inst_past.take(IALIGN_PTR_LEN)
    }

    when (io.ft.flush_en) {
      read_ptr := addressing_ptr
      reg_i0 := io.ft.flush_iaddr.take(IALIGN_PTR_LEN)
    }

    when (inst1_valid) {
      printf(cf"fb(${read_ptr}%x): 0x${Cat(iaddrs(0), 0.U(1.W))}%x: 0x${idatas(1) ## idatas(0)}%x ${io.ft.inst1.ready} read\n")
    }
    when (inst2_valid) {
      printf(cf"fb(${read_ptr}%x): 0x${Cat(io.ft.inst2.addr, 0.U(1.W))}%x: 0x${io.ft.inst2.data}%x ${io.ft.inst2.ready} read\n")
    }
  }

  if0
  if1
  if2
}
