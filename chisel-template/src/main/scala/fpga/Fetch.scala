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

class BranchPredictorPort extends Bundle {
  val iaddr_en      = Input(Bool())
  val iaddr         = Input(UInt(PC_LEN.W))
  val fetch_ptr     = Input(UInt(FETCH_PTR_LEN.W))
  val flush_en      = Input(Bool())
  val bp0_en        = Output(Bool())
  val bp0_pos       = Output(UInt(IALIGN_PTR_LEN.W))
  val bp0_addr      = Output(UInt(PC_LEN.W))
  val bp1_en        = Output(Bool())
  val bp1_pos       = Output(UInt(IALIGN_PTR_LEN.W))
  val bp1_addr      = Output(UInt(PC_LEN.W))
  val bp1_fetch_ptr = Output(UInt(FETCH_PTR_LEN.W))
}

class BranchPredictor extends Module {
  val io = IO(new BranchPredictorPort)
  // TODO: flushが来ているときは bp0/1_en を出さない

  // val btb = Module(new BTB(BTB_INDEX_LEN))
  // val pht = Module(new PHT(PHT_INDEX_LEN))
  // val zbtb = Module(new ZBTB(ZBTB_ENTRIES))
  // val ras = Module(new RAS())

  // TODO implement
  io.bp0_en        := false.B
  io.bp0_pos       := 0.U
  io.bp0_addr      := 0.U
  io.bp1_en        := false.B
  io.bp1_pos       := 0.U
  io.bp1_addr      := 0.U
  io.bp1_fetch_ptr := 0.U
}

class FetchUnitPort extends Bundle {
  val flush_en     = Input(Bool())
  val flush_iaddr  = Input(UInt(PC_LEN.W))
  val inst1_valid  = Output(Bool())
  val inst1_addr   = Output(UInt(PC_LEN.W))
  val inst1_data   = Output(UInt(WORD_LEN.W))
  val inst1_bpfail = Output(Bool())
  val inst1_half   = Output(Bool())
  val inst2_valid  = Output(Bool())
  val inst2_addr   = Output(UInt(PC_LEN.W))
  val inst2_data   = Output(UInt(WORD_LEN.W))
  val inst2_bpfail = Output(Bool())
  val inst2_half   = Output(Bool())
  val inst1_ready  = Input(Bool())
  val inst2_ready  = Input(Bool())

  val imem   = Flipped(new ImemPortIo())
  val icache = Flipped(new CachedImemPort())
}

class FetchUnit(
  dram_config: DramConfig,
) extends Module {
  val io = IO(new FetchUnitPort)

  class FetchBuffer extends Bundle {
    val iaddr = UInt(PC_LEN.W)
    val idata = UInt(IBLOCK_LEN.W)
    val receipt_advance = Bool()
    val iblock_cont = Bool()
    val end_of_iblock = UInt(IALIGN_PTR_LEN.W)
  }

  val fetch_buf = Mem(FETCH_BUFFER_SIZE, new FetchBuffer)
  val addressing_ptr = RegInit(0.U((FETCH_PTR_LEN + 1).W))
  val receipt_ptr    = RegInit(0.U((FETCH_PTR_LEN + 1).W))
  val fetch_ptr      = RegInit(0.U((FETCH_PTR_LEN + 1).W))
  val read_ptr       = RegInit(0.U((FETCH_PTR_LEN + 1).W))

  val bp = Module(new BranchPredictor)

  def if0: Unit = {
    val reg_next_iaddr = RegInit(0x0000fff0.U(PC_LEN.W))
    val iaddr = Wire(UInt(PC_LEN.W))
    iaddr := Mux(io.flush_en, io.flush_iaddr, reg_next_iaddr)
    reg_next_iaddr := iaddr + ((IBLOCK_LEN / 8) >> (WORD_LEN - PC_LEN)).U(PC_LEN.W)

    val count = addressing_ptr - read_ptr
    val has_space = (~count(FETCH_PTR_LEN)).asBool
    // val has_space = count < 3.U
    val is_dram = dram_config.is_dram(iaddr.pc_to_word)

    io.imem.addr      := iaddr.pc_to_word.clear_lsbits(IBLOCK_BITS)
    io.imem.en        := (has_space || io.flush_en) && !is_dram
    io.icache.addr    := iaddr.pc_to_word.clear_lsbits(IBLOCK_BITS)
    io.icache.addr_en := (has_space || io.flush_en) && is_dram
    bp.io.flush_en    := io.flush_en
    bp.io.iaddr       := iaddr
    bp.io.iaddr_en    := true.B
    bp.io.fetch_ptr   := addressing_ptr.take(FETCH_PTR_LEN)
    when (!(has_space || io.flush_en) || (is_dram && !io.icache.addr_ready)) {
      reg_next_iaddr := iaddr
      bp.io.iaddr_en := false.B
    }.otherwise {
      addressing_ptr := addressing_ptr + 1.U

      printf(cf"fb(${addressing_ptr}%x): 0x${Cat(iaddr, 0.U(1.W))}%x addressed\n")
    }

    when (has_space || io.flush_en) {
      fetch_buf(addressing_ptr.take(FETCH_PTR_LEN)).iaddr := iaddr
      fetch_buf(addressing_ptr.take(FETCH_PTR_LEN)).receipt_advance := true.B
    }

    printf(cf"iaddr=${iaddr ## 0.U(1.W)}%x\n")
    printf(cf"reg_next_iaddr=${reg_next_iaddr ## 0.U(1.W)}%x\n")
    printf(cf"io.imem.addr=${io.imem.addr}%x\n")
    printf(cf"io.imem.en=${io.imem.en}\n")
    printf(cf"addressing=${addressing_ptr.take(FETCH_PTR_LEN)}\n")
    printf(cf"fb(0).iaddr=${fetch_buf(0.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(1).iaddr=${fetch_buf(1.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(2).iaddr=${fetch_buf(2.U).iaddr ## 0.U(1.W)}%x\n")
    printf(cf"fb(3).iaddr=${fetch_buf(3.U).iaddr ## 0.U(1.W)}%x\n")
  }

  def if1: Unit = {
    io.icache.idata_ready := true.B
    val idata = Mux(io.imem.valid, io.imem.inst, io.icache.idata)
    val fetch_in_progress = (addressing_ptr =/= fetch_ptr)
    when (fetch_in_progress) {
      fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).idata := idata
      fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).iblock_cont := true.B
      fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).end_of_iblock := 3.U
    }

    val addressed_subsequent = (addressing_ptr.take(FETCH_PTR_LEN) - 2.U === bp.io.bp1_fetch_ptr)
    val receiving_inval = (addressing_ptr.take(FETCH_PTR_LEN) - 1.U === receipt_ptr.take(FETCH_PTR_LEN))

    val receipt_advance = fetch_buf(receipt_ptr.take(FETCH_PTR_LEN)).receipt_advance
    when (io.imem.valid || io.icache.idata_valid) {
      when (fetch_ptr =/= receipt_ptr) {
        fetch_ptr := fetch_ptr + 1.U
      }
      // 以下のいずれかの場合は receipt ptr を進めない
      // - 以前の bp1_en により無効化されている場合
      // - bp1 により無効化される qword をちょうど今 receive した場合
      when (receipt_advance && !(bp.io.bp1_en && addressed_subsequent && receiving_inval)) {
        receipt_ptr := receipt_ptr + 1.U
        fetch_ptr := fetch_ptr + 1.U
      }
      fetch_buf(receipt_ptr.take(FETCH_PTR_LEN)).receipt_advance := true.B

      printf(cf"io.imem.valid=${io.imem.valid} io.icache.idata_valid=${io.icache.idata_valid}\n")
      printf(cf"fb(${fetch_ptr}%x): " +
        cf"0x${Cat(fetch_buf(fetch_ptr.take(FETCH_PTR_LEN)).iaddr, 0.U(1.W))}%x: " +
        cf"0x${idata}%x fetched\n")
    }
    // bp1 により無効化される qword が addressing 済みでまだ receive していない場合、無効化を予約する
    when (bp.io.bp1_en && addressed_subsequent && (!receiving_inval || !(io.imem.valid || io.icache.idata_valid))) {
      fetch_buf(addressing_ptr.take(FETCH_PTR_LEN) - 1.U).receipt_advance := false.B
    }

    when (io.flush_en) {
      receipt_ptr := addressing_ptr
    }
  }

  def if2: Unit = {
    val count = receipt_ptr - read_ptr
    val sat_count = Mux(count(FETCH_PTR_LEN) === 0.U, count.take(FETCH_PTR_LEN), 2.U)

    val start_of_iblock = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).iaddr.take(IALIGN_PTR_LEN)
    val end_of_iblocks = (0 until 2).map(i => fetch_buf(read_ptr.take(FETCH_PTR_LEN) + i.U).end_of_iblock)
    val iblock_cont = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).iblock_cont
    val end_of_iblock_ov = (Mux(iblock_cont, 1.U(1.W) ## end_of_iblocks(1), 0.U(1.W) ## end_of_iblocks(0)) - start_of_iblock).take(IALIGN_PTR_LEN + 1)
    val end_of_iblock = Mux(end_of_iblock_ov > 3.U, 3.U(IALIGN_PTR_LEN.W), end_of_iblock_ov.take(IALIGN_PTR_LEN))
    val read_end_ov = (Mux(sat_count === 1.U, 3.U((IALIGN_PTR_LEN + 1).W), 7.U((IALIGN_PTR_LEN + 1).W)) - start_of_iblock).take(IALIGN_PTR_LEN + 1)
    val read_end = Mux(read_end_ov > 3.U, 3.U(IALIGN_PTR_LEN.W), read_end_ov.take(IALIGN_PTR_LEN))
    val iaddrs = (0 until 2).map(i => fetch_buf(read_ptr.take(FETCH_PTR_LEN) + i.U).iaddr)
    val idata0 = fetch_buf(read_ptr.take(FETCH_PTR_LEN)).idata
    val idata1 = fetch_buf(read_ptr.take(FETCH_PTR_LEN) + 1.U).idata
    val idatas = ((idata1 ## idata0) >> (start_of_iblock ## 0.U(log2Ceil(IALIGN_LEN).W))).take(IBLOCK_LEN).subdivideIn(IALIGN_LEN)
    val is_halfs_us = Cat((0 until 2).map(i => (idata1.subdivideIn(IALIGN_LEN)(i).take(2) =/= 3.U)).reverse) ##
                      Cat((0 until 4).map(i => (idata0.subdivideIn(IALIGN_LEN)(i).take(2) =/= 3.U)).reverse)
    val is_halfs = (is_halfs_us >> start_of_iblock)(2, 0)
    // val inst2_block1 = (start_of_iblock === 2.U && !is_halfs_us(2)) || start_of_iblock === 3.U
    // val inst2_ialign1 = (start_of_iblock === 3.U && !is_halfs_us(3))
    val inst1_past_us = start_of_iblock.pad(IALIGN_PTR_LEN + 1) + Mux(is_halfs(0), 1.U, 2.U)
    val inst1_end = Mux(is_halfs(0) || (!iblock_cont && start_of_iblock === end_of_iblocks(0)), 0.U(IALIGN_PTR_LEN.W), 1.U(IALIGN_PTR_LEN.W))
    val inst1_end_us = start_of_iblock.pad(IALIGN_PTR_LEN + 1) + inst1_end
    val inst2_half = Mux(is_halfs(0), is_halfs(1), is_halfs(2))
    val inst2_past_us = inst1_past_us + Mux(inst2_half, 1.U, 2.U)
    val inst2_end = Mux(is_halfs(0),
      Mux(is_halfs(1) || (!iblock_cont && inst1_past_us === end_of_iblocks(0)), 1.U(IALIGN_PTR_LEN.W), 2.U(IALIGN_PTR_LEN.W)),
      Mux(is_halfs(1) || (!iblock_cont && inst1_past_us === end_of_iblocks(0)), 2.U(IALIGN_PTR_LEN.W), 3.U(IALIGN_PTR_LEN.W)),
    )
    val inst2_end_us = start_of_iblock.pad(IALIGN_PTR_LEN + 1) + inst2_end
    val inst1_valid = MuxCase(inst1_end <= end_of_iblock, Seq(
      (io.flush_en || sat_count === 0.U) -> false.B,
      (sat_count === 1.U)                -> Mux(iblock_cont, !inst1_end_us(IALIGN_PTR_LEN), inst1_end_us <= end_of_iblocks(0)),
    ))
    val inst2_valid = MuxCase(inst2_end <= end_of_iblock, Seq(
      (io.flush_en || sat_count === 0.U) -> false.B,
      (sat_count === 1.U)                -> Mux(iblock_cont, !inst2_end_us(IALIGN_PTR_LEN), inst2_end_us <= end_of_iblocks(0)),
    ))
    io.inst1_addr   := iaddrs(0)
    io.inst1_data   := idatas(1) ## idatas(0)
    io.inst1_bpfail := !is_halfs(0) && end_of_iblock === 0.U
    io.inst1_half   := is_halfs(0)
    io.inst1_valid  := inst1_valid
    // io.inst1_valid  := !io.flush_en && (sat_count >= 2.U) || (sat_count === 1.U && !(inst2_ialign1 && iblock_cont))
    // io.inst1_valid  := !io.flush_en && (sat_count =/= 0.U)
    //   && (is_halfs(0) || (end_of_iblock >= 1.U && read_end >= 1.U) || end_of_iblock === 0.U)
    // io.inst2_addr   := MuxCase(iaddrs(0), Seq(
    //   (inst2_block1 && !inst2_ialign1) -> iaddrs(1).replace_lsbits(IALIGN_PTR_LEN, 0.U),
    //   (inst2_block1 && inst2_ialign1)  -> iaddrs(1).replace_lsbits(IALIGN_PTR_LEN, 1.U),
    // ))
    io.inst2_addr := Mux(inst1_past_us(IALIGN_PTR_LEN), iaddrs(1), iaddrs(0))
      .replace_lsbits(IALIGN_PTR_LEN, inst1_past_us.take(IALIGN_PTR_LEN))
    io.inst2_data   := Mux(is_halfs(0), idatas(2) ## idatas(1), idatas(3) ## idatas(2))
    io.inst2_bpfail := Mux(is_halfs(0), !is_halfs(1) && end_of_iblock === 1.U, !is_halfs(2) && end_of_iblock === 2.U)
    io.inst2_half   := Mux(is_halfs(0), is_halfs(1), is_halfs(2))
    io.inst2_valid  := inst2_valid
    val inst_past = MuxCase(start_of_iblock.pad(IALIGN_PTR_LEN + 1), Seq(
      (io.inst2_ready && inst2_valid)                     -> inst2_past_us,
      ((io.inst1_ready || io.inst2_ready) && inst1_valid) -> inst1_past_us,
    ))
    val iaddr_update = (io.inst2_ready && inst2_valid) || ((io.inst1_ready || io.inst2_ready) && inst1_valid)
    read_ptr := read_ptr + Mux(inst_past(IALIGN_PTR_LEN) || inst_past.take(IALIGN_PTR_LEN) > end_of_iblocks(0), 1.U, 0.U)
    when (iaddr_update) {
      when (inst_past(IALIGN_PTR_LEN) && iblock_cont) {
        fetch_buf((read_ptr + 1.U).take(FETCH_PTR_LEN)).iaddr := iaddrs(1).replace_lsbits(IALIGN_PTR_LEN, inst_past.take(IALIGN_PTR_LEN))
      }.otherwise {
        fetch_buf((read_ptr + 0.U).take(FETCH_PTR_LEN)).iaddr := iaddrs(0).replace_lsbits(IALIGN_PTR_LEN, inst_past.take(IALIGN_PTR_LEN))
      }
    }
    
    // io.inst2_valid  := !io.flush_en && sat_count =/= 0.U && Mux(is_halfs(0),
    //   Mux(is_halfs(1),
    //     end_of_iblock >= 1.U && read_end >= 1.U,
    //     (end_of_iblock >= 2.U && read_end >= 2.U) || (end_of_iblock === 1.U && read_end >= 1.U),
    //   ),
    //   Mux(is_halfs(2),
    //     end_of_iblock >= 2.U && read_end >= 2.U,
    //     (end_of_iblock >= 3.U && read_end >= 3.U) || (end_of_iblock === 2.U && read_end >= 2.U),
    //   ),
    // )


    // val inst1_len = MuxCase(0.U, Seq(
    //   (io.flush_en || sat_count === 0.U)        -> 0.U,
    //   (is_halfs(0) || end_of_iblock === 0.U)    -> 1.U,
    //   (end_of_iblock >= 1.U && read_end >= 1.U) -> 2.U,
    // ))
    // val inst12_len = MuxCase(inst1_len, Seq(
    //   (io.flush_en || sat_count === 0.U)                                            -> 0.U,
    //   ( is_halfs(0) && (is_halfs(1) || (end_of_iblock === 1.U && read_end >= 1.U))) -> 2.U,
    //   ( is_halfs(0) && !is_halfs(1) && (end_of_iblock >= 2.U  && read_end >= 2.U))  -> 3.U,
    //   (!is_halfs(0) && (is_halfs(2) || (end_of_iblock === 2.U && read_end >= 2.U))) -> 3.U,
    //   (!is_halfs(0) && !is_halfs(2) && (end_of_iblock >= 3.U  && read_end >= 3.U))  -> 4.U,
    // ))

    // val next_ptr = start_of_iblock.take(IALIGN_PTR_LEN + 1) + MuxCase(0.U, Seq(
    //   (io.inst2_ready && inst2_valid)                     -> inst12_len,
    //   ((io.inst1_ready || io.inst2_ready) && inst1_valid) -> inst1_len,
    // ))
    // when (next_ptr(IALIGN_PTR_LEN)) {
    //   read_ptr := read_ptr + 1.U
    //   when (iblock_cont) {
    //     fetch_buf(read_ptr.take(FETCH_PTR_LEN) + 1.U).iaddr := iaddrs(1).replace_lsbits(IALIGN_PTR_LEN, next_ptr.take(IALIGN_PTR_LEN))
    //   }
    // }.elsewhen (next_ptr > end_of_iblock) {
    //   read_ptr := read_ptr + 1.U
    // }.otherwise {
    //   fetch_buf(read_ptr.take(FETCH_PTR_LEN)).iaddr := iaddrs(0).replace_lsbits(IALIGN_PTR_LEN, next_ptr.take(IALIGN_PTR_LEN))
    // }

    when (io.flush_en) {
      read_ptr := addressing_ptr
    }

    when (inst1_valid) {
      printf(cf"fb(${read_ptr}%x): 0x${Cat(iaddrs(0), 0.U(1.W))}%x: 0x${idatas(1) ## idatas(0)}%x ${io.inst1_ready} read\n")
    }
    when (inst2_valid) {
      printf(cf"fb(${read_ptr}%x): 0x${Cat(io.inst2_addr, 0.U(1.W))}%x: 0x${io.inst2_data}%x ${io.inst2_ready} read\n")
    }
  }


  if0
  if1
  if2
}
