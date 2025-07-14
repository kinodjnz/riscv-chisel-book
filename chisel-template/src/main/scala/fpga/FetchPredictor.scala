package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import common.UIntExtension._

class RedirectEnqueuePort(redirect_buffer_size: Int, pht_history_len: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val en       = Input(Bool())
  val flush_en = Input(Bool())
  val history  = Input(UInt(pht_history_len.W))
  val ptr      = Output(UInt(fp_ptr_len.W))
  val ready    = Output(Bool())
  val left1    = Output(Bool())
}

class RedirectUpdatePort(redirect_buffer_size: Int, pht_history_len: Int, ras_entries: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)
  val ras_index_len = log2Ceil(ras_entries)

  val en       = Input(Bool())
  val ptr      = Input(UInt(fp_ptr_len.W))
  // val fp_entry = Input(new FetchPredictionEntry(pht_history_len, ras_entries))
  val attr      = Input(UInt(BTB_ATTR_LEN.W))
  val is_ret    = Input(Bool())
  val ras_index = Input(UInt(ras_index_len.W))
  val target    = Input(UInt(PC_LEN.W))

}

class RedirectDequeuePort extends Bundle {
  val en = Input(Bool())
}

class RedirectReadPort(redirect_buffer_size: Int, pht_history_len: Int, ras_entries: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val ptr      = Input(UInt(fp_ptr_len.W))
  val fp_entry = Output(new FetchPredictionEntry(pht_history_len, ras_entries))
}

class FetchRedirectBuffer(redirect_buffer_size: Int, pht_history_len: Int, ras_entries: Int) extends Module {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val io = IO(new Bundle {
    val enq  = new RedirectEnqueuePort(redirect_buffer_size, pht_history_len)
    val upd  = new RedirectUpdatePort(redirect_buffer_size, pht_history_len, ras_entries)
    val deq  = new RedirectDequeuePort
    val read = new RedirectReadPort(redirect_buffer_size, pht_history_len, ras_entries)
  })

  val buf = Mem(redirect_buffer_size, new FetchPredictionEntry(pht_history_len, ras_entries))
  val enq_ptr = RegInit(0.U((fp_ptr_len + 1).W))
  val deq_ptr = RegInit(0.U((fp_ptr_len + 1).W))

  val ready = !(enq_ptr - deq_ptr)(fp_ptr_len)
  io.enq.ready := ready
  io.enq.left1 := ((enq_ptr - deq_ptr).take(fp_ptr_len) === 3.U(fp_ptr_len.W))
  io.enq.ptr   := enq_ptr
  when (ready || io.enq.flush_en) {
    buf(enq_ptr).history := io.enq.history
  }
  when (io.enq.en) {
    enq_ptr := enq_ptr + 1.U
  }
  when (io.deq.en) {
    deq_ptr := deq_ptr + 1.U
  }
  when (io.enq.flush_en) {
    deq_ptr := enq_ptr
  }
  printf(cf"redir enq_ptr = ${enq_ptr}\n")
  printf(cf"redir deq_ptr = ${deq_ptr}\n")

  when (io.upd.en) {
    buf(io.upd.ptr).attr      := io.upd.attr
    buf(io.upd.ptr).is_ret    := io.upd.is_ret
    buf(io.upd.ptr).ras_index := io.upd.ras_index
    buf(io.upd.ptr).target    := io.upd.target
  }

  io.read.fp_entry.attr      := buf(io.read.ptr).attr
  io.read.fp_entry.is_ret    := buf(io.read.ptr).is_ret
  io.read.fp_entry.history   := buf(io.read.ptr).history
  io.read.fp_entry.ras_index := buf(io.read.ptr).ras_index
  io.read.fp_entry.target    := buf(io.read.ptr).target
}

class BranchPredictionEntry extends Bundle {
  val lcnt  = UInt(2.W)
  val gcnt  = UInt(2.W) // gcnt === 0b01 means the instruction is not a branch
}

class FetchPredictionEntry(pht_history_len: Int, ras_entries: Int) extends Bundle {
  val ras_index_len = log2Ceil(ras_entries)

  val attr      = UInt(BTB_ATTR_LEN.W)
  val is_ret    = Bool()
  val history   = UInt(pht_history_len.W)
  val ras_index = UInt(ras_index_len.W)
  val target    = UInt(PC_LEN.W)
}

class FetchPredictionPort(redirect_buffer_size: Int) extends Bundle {
  val fp_ptr_len = log2Ceil(redirect_buffer_size)

  val iaddr_en       = Input(Bool())
  val iaddr          = Input(UInt(PC_LEN.W))
  val flush_en       = Input(Bool())
  val redirect_en    = Input(Bool())
  val redirect_ready = Output(Bool())
  val bp0_en         = Output(Bool())
  val bp0_pos        = Output(UInt(IALIGN_PTR_LEN.W)) // needed?
  val bp0_addr       = Output(UInt(PC_LEN.W))
  val bp1_en         = Output(Bool())
  val bp1_pos        = Output(UInt(IALIGN_PTR_LEN.W))
  val bp1_addr       = Output(UInt(PC_LEN.W))
  val bp_entries     = Output(Vec(4, new BranchPredictionEntry()))
  val fp_ptr         = Output(UInt(fp_ptr_len.W))
}

class BranchCorrectionPort(pht_history_len: Int, ras_entries: Int) extends Bundle {
  val en       = Input(Bool())
  val pc       = Input(UInt(PC_LEN.W))
  val bp_entry = Input(new BranchPredictionEntry())
  val fp_entry = Input(new FetchPredictionEntry(pht_history_len, ras_entries))
  val fp_hit   = Input(Bool())
  val mispred  = Input(Bool())
  val br_taken = Input(Bool())
  val attr     = Input(UInt(BTB_ATTR_LEN.W))
  val is_ret   = Input(Bool())
  val target   = Input(UInt(PC_LEN.W))
  val next_pc  = Input(UInt(PC_LEN.W))
}

class FetchPredictor(
  zbtb_entries: Int,
  btb_entries: Int,
  pht_index_len: Int,
  pht_history_len: Int,
  ras_entries: Int,
  redirect_buffer_size: Int,
) extends Module {
  val zbtb_index_len = log2Ceil(zbtb_entries)
  val ras_index_len  = log2Ceil(ras_entries)

  val io = IO(new Bundle {
    val pr = new FetchPredictionPort(pht_history_len)
    val cr = new BranchCorrectionPort(pht_history_len, ras_entries)
    val re = Flipped(new RedirectEnqueuePort(redirect_buffer_size, pht_history_len))
    val ru = Flipped(new RedirectUpdatePort(redirect_buffer_size, pht_history_len, ras_entries))
    val zbtb = Flipped(new ZBTBIo(ZBTB_TARGET_LEN))
    val btb = Flipped(new BTBIo)
    val pht = Flipped(new PHTIo(pht_index_len, pht_history_len))
    val ras = Flipped(new RASIo(ras_index_len))

    val pht_lmem = Flipped(new PHTMemIo(pht_index_len))
    val pht_gmem = Flipped(new PHTMemIo(pht_index_len))
  })

  io.pht.lmem <> io.pht_lmem
  io.pht.gmem <> io.pht_gmem

  def prediction_cycle: Unit = {
    val reg_iaddr_en    = RegNext(io.pr.iaddr_en)
    val reg_iaddr_index = RegInit(0.U(PC_LEN.W))
    val reg_redirect_en = RegNext(io.pr.redirect_en)
    val reg_flush_en    = RegNext(io.pr.flush_en)
    val reg_fp_ptr      = RegInit(io.re.ptr)

    reg_iaddr_index := io.pr.iaddr
    io.pr.redirect_ready := io.re.ready && (!io.re.left1 || !reg_redirect_en)

    io.zbtb.lu.pc := io.pr.iaddr

    val ibpos = reg_iaddr_index.take(2)

    val bp0_pos = MuxCase(3.U(IALIGN_PTR_LEN.W),
      Seq.tabulate(3)(i => ((i.U(2.W) >= ibpos) && io.zbtb.lu.matches(i)) -> i.U(IALIGN_PTR_LEN.W))
    )
    val bp0_en = reg_iaddr_en && VecInit.tabulate(4)(i => (i.U(2.W) >= ibpos) && io.zbtb.lu.matches(i)).asUInt.orR
    io.pr.bp0_en   := bp0_en
    io.pr.bp0_pos  := bp0_pos
    io.pr.bp0_addr := io.zbtb.lu.target(bp0_pos)

    io.btb.lu.pc := io.pr.iaddr
    io.pht.lu.pc := io.pr.iaddr

    val redirected = VecInit.tabulate(4)(i => (i.U(2.W) >= ibpos) && (
      (io.btb.lu.result(i).br && io.pht.lu.taken(i)) ||
      io.btb.lu.result(i).jump ||
      io.btb.lu.result(i).is_ret
    ))
    val br_taken = VecInit.tabulate(4)(i => io.btb.lu.result(i).br && io.pht.lu.taken(i))
    // val is_jump  = VecInit.tabulate(4)(i => io.btb.lu.result(i).jump)
    // val is_ret   = VecInit.tabulate(4)(i => io.btb.lu.result(i).is_ret)
    val attr = VecInit.tabulate(4)(i => io.btb.lu.result(i).attr)
    val bp1_pos = MuxCase(3.U(IALIGN_PTR_LEN.W),
      Seq.tabulate(3)(i => redirected(i) -> i.U(IALIGN_PTR_LEN.W))
    )
    val bp1_target = Mux(io.btb.lu.result(bp1_pos).is_ret, io.ras.top.ret_pc, io.btb.lu.result(bp1_pos).target)
    val bp1_en = reg_iaddr_en && redirected.asUInt.orR
    io.pr.bp1_en   := bp1_en
    io.pr.bp1_pos  := bp1_pos
    io.pr.bp1_addr := bp1_target

    io.ru.en        := bp1_en
    io.ru.ptr       := reg_fp_ptr
    io.ru.attr      := attr(bp1_pos)
    io.ru.is_ret    := io.btb.lu.result(bp1_pos).is_ret
    io.ru.ras_index := io.ras.top.index
    io.ru.target    := bp1_target

    for (i <- 0 until 4) {
      io.pr.bp_entries(i).lcnt := io.pht.lu.lcnt(i)
      io.pr.bp_entries(i).gcnt := Mux(attr(i) === BTB_ATTR_BR, io.pht.lu.gcnt(i), GCNT_NOT_BRANCH)
    }

    io.re.en       := !io.pr.flush_en && reg_redirect_en
    io.re.flush_en := reg_flush_en
    io.re.history  := io.pht.history
    io.pr.fp_ptr   := reg_fp_ptr
    when (!io.pr.flush_en && reg_redirect_en) {
      reg_fp_ptr   := io.re.ptr
      io.pr.fp_ptr := io.re.ptr
    }

    // Clear zbtb by btb prediction
    // val bp0_index = reg_iaddr_index.take(zbtb_index_len)
    io.zbtb.inv.en := !io.pr.flush_en && bp0_en && !br_taken(bp0_pos) && !io.btb.lu.result(bp0_pos).jump && bp0_pos <= bp1_pos
    io.zbtb.inv.pc := reg_iaddr_index.replace_lsbits(2, bp0_pos)

    // Update RAS by btb prediction
    io.ras.ret1.en      := !io.pr.flush_en && reg_iaddr_en && io.btb.lu.result(bp1_pos).is_ret
    io.ras.ret1.index   := io.ras.top.index - 1.U(ras_index_len.W)
    io.ras.call1.en     := !io.pr.flush_en && reg_iaddr_en && (attr(bp1_pos) === BTB_ATTR_DCALL)
    io.ras.call1.index  := io.ras.top.index + 1.U(ras_index_len.W)
    // val bcall_pos = MuxCase(3.U(IALIGN_PTR_LEN.W),
    //   Seq.tabulate(3)(i => (i.U(2.W) >= ibpos) && io.btb.lu.result(i).jump -> i.U(IALIGN_PTR_LEN.W))
    // )
    io.ras.call1.ret_pc := Mux(
      bp1_pos === 3.U,
      reg_iaddr_index.clear_lsbits(2) + 4.U,
      reg_iaddr_index.replace_lsbits(2, bp1_pos + 1.U),
    )

    // Update PHT history by btb prediction
    val pht_pc_index = reg_iaddr_index.take(pht_history_len)
    io.pht.br.en := !io.pr.flush_en && reg_iaddr_en && br_taken(bp1_pos)
    io.pht.br.pc := pht_pc_index.replace_lsbits(2, bp1_pos)
  }

  def correction_cycle: Unit = {
    def update_lcnt(br_taken: Bool, lcnt: UInt): UInt = {
      // if taken:
      //  (strongly not-taken) 10 => 00
      //  (weakly not-taken)   00 => 01
      //  (weakly taken)       01 => 11
      //  (strongly taken)     11 => 11
      val lcnt_if_taken = lcnt(0, 0) ## (!lcnt(1) | lcnt(0)).asUInt

      // if not-taken:
      //  (strongly not-taken) 10 => 10
      //  (weakly not-taken)   00 => 10
      //  (weakly taken)       01 => 00
      //  (strongly taken)     11 => 01
      val lcnt_unless_taken = (!lcnt(0, 0)) ## (lcnt(1) & lcnt(0)).asUInt

      Mux(br_taken, lcnt_if_taken, lcnt_unless_taken)
    }

    def update_gcnt(br_taken: Bool, gcnt: UInt): UInt = {
      // if taken:
      //  (not-taken) 10 => 00
      //  (neutral)   00 => 11
      //  (taken)     11 => 11
      val gcnt_if_taken = (gcnt(0) ^ !gcnt(1)) ## (gcnt(0) ^ !gcnt(1))

      // if not-taken:
      //  (not-taken) 10 => 10
      //  (neutral)   00 => 10
      //  (taken)     11 => 00
      val gcnt_unless_taken = (!gcnt(0)) ## 0.U(1.W)

      Mux(br_taken, gcnt_if_taken, gcnt_unless_taken)
    }

    def gcnt_is_branch(gcnt: UInt): Bool = {
      gcnt =/= 1.U(2.W)
    }

    // Update attr if the instruction redirects pc
    // or the instruction is incorrectly predicted to redirect pc.
    //
    // actual_attr === inval && attr =/= inval  => new attr <- inval
    // actual_attr === br    && taken           => new attr <- br
    // actual_attr === djump                    => new attr <- djump
    // actual_attr === dcall                    => new attr <- dcall
    // actual_attr === ret                      => new attr <- ret
    io.btb.up.en := io.cr.en && (
      ((io.cr.attr === BTB_ATTR_INVAL) && (io.cr.fp_hit || gcnt_is_branch(io.cr.bp_entry.gcnt))) ||
      (io.cr.br_taken) ||
      (io.cr.attr === BTB_ATTR_DJUMP) ||
      (io.cr.attr === BTB_ATTR_DCALL) ||
      (io.cr.is_ret)
    )
    io.btb.up.attr    := io.cr.attr
    io.btb.up.is_ret  := io.cr.is_ret
    io.btb.up.pc      := io.cr.pc
    io.btb.up.target  := io.cr.target

    // Rollback pattern history if pc redirect prediction fails.
    io.pht.res.en      := /*io.cr.en &&*/ io.cr.mispred
    io.pht.res.history := io.cr.fp_entry.history

    // Update bimodal counter if the instruction is branch.
    val updated_lcnt = update_lcnt(io.cr.br_taken, io.cr.bp_entry.lcnt)
    val updated_gcnt = update_gcnt(io.cr.br_taken, io.cr.bp_entry.gcnt)
    io.pht.up.en      := io.cr.en && (io.cr.attr === BTB_ATTR_BR)
    io.pht.up.history := io.cr.fp_entry.history // History before branch taken
    io.pht.up.pc      := io.cr.pc
    io.pht.up.lcnt    := updated_lcnt
    io.pht.up.gcnt    := updated_gcnt

    // Update pattern history if the branch is taken unlike the prediction.
    io.pht.br2.en      := io.cr.en && io.cr.br_taken && (!io.cr.fp_hit || io.cr.fp_entry.attr =/= BTB_ATTR_BR)
    io.pht.br2.history := io.cr.fp_entry.history
    io.pht.br2.pc      := io.cr.pc

    // Update zbtb
    io.zbtb.up.en     := io.cr.en && (io.cr.br_taken || (io.cr.attr === BTB_ATTR_DJUMP || io.cr.attr === BTB_ATTR_DCALL))
    io.zbtb.up.pc     := io.cr.pc
    io.zbtb.up.target := io.cr.target

    // Rollback RAS index if pc redirect prediction fails.
    io.ras.up.en    := /*io.cr.en &&*/ io.cr.mispred
    io.ras.up.index := io.cr.fp_entry.ras_index

    // Pop RAS if ret prediction fails.
    io.ras.ret2.en      := io.cr.en && io.cr.is_ret && (!io.cr.fp_hit || !io.cr.fp_entry.is_ret)
    io.ras.ret2.index   := io.cr.fp_entry.ras_index - 1.U(ras_index_len.W)

    // Push return address to RAS if call prediction fails.
    io.ras.call2.en     := io.cr.en && (io.cr.attr === BTB_ATTR_DCALL) &&
                             (!io.cr.fp_hit || io.cr.fp_entry.attr =/= BTB_ATTR_DCALL)
    io.ras.call2.index  := io.cr.fp_entry.ras_index + 1.U(ras_index_len.W)
    io.ras.call2.ret_pc := io.cr.next_pc
  }

  prediction_cycle
  correction_cycle
}

class ZBTBLookup(target_len: Int) extends Bundle {
  val pc      = Input(UInt(PC_LEN.W))
  val matches = Output(Vec(4, Bool()))
  val target  = Output(Vec(4, UInt(target_len.W)))
}

class ZBTBUpdate(target_len: Int) extends Bundle {
  val en     = Input(Bool())
  val pc     = Input(UInt(PC_LEN.W))
  val target = Input(UInt(target_len.W))
}

class ZBTBInvalidate extends Bundle {
  val en     = Input(Bool())
  val pc     = Input(UInt(PC_LEN.W))
}

class ZeroBranchTargetBuffer(tag_len: Int, target_len: Int) extends Bundle {
  val en     = Bool()
  val tag    = UInt(tag_len.W)
  val target = UInt(target_len.W)
}

class ZBTBIo(target_len: Int) extends Bundle {
  val lu  = new ZBTBLookup(target_len)
  val up  = new ZBTBUpdate(target_len)
  val inv = new ZBTBInvalidate
}

class ZBTB(
  zbtb_entries: Int = ZBTB_ENTRIES,
  tag_len: Int = ZBTB_TAG_LEN,
  target_len: Int = ZBTB_TARGET_LEN
) extends Module {
  val index_len = log2Ceil(zbtb_entries)

  val io = IO(new ZBTBIo(target_len))

  val zbtb_mem = List.fill(2)(Mem(zbtb_entries / 2, new ZeroBranchTargetBuffer(tag_len, target_len)))

  val zbtb_entry = Seq.tabulate(4)(i => zbtb_mem(i % 2)(io.lu.pc(index_len - 1, 2) ## (i / 2).U))

  val matches = zbtb_entry.map(e => e.en && (e.tag === io.lu.pc(tag_len - 1 + index_len, index_len)))
  val target  = zbtb_entry.map(e => e.target)

  io.lu.matches := RegNext(VecInit(matches), VecInit.fill(4)(false.B))
  io.lu.target  := RegNext(VecInit(target), VecInit.fill(4)(0.U(target_len.W)))

  val entry = Wire(new ZeroBranchTargetBuffer(tag_len, target_len))
  entry.en     := true.B
  entry.tag    := io.up.pc(tag_len - 1 + index_len, index_len)
  entry.target := io.up.target

  val addr = Mux(io.up.en, io.up.pc(index_len - 1, 0), io.inv.pc(index_len - 1, 0))

  for (i <- 0 until 4) {
    when (addr(1, 0) === i.U(2.W)) {
      when (io.inv.en || io.up.en) {
        zbtb_mem(i % 2)(addr(index_len - 1, 2) ## (i / 2).U).en := io.up.en
        when (io.inv.en && !io.up.en) {
          printf(cf"zbtb(${i})(0x${io.inv.pc.pc_to_word}%x) inv\n")
        }
      }
      when (io.up.en) {
        zbtb_mem(i % 2)(io.up.pc(index_len - 1, 2) ## (i / 2).U).tag    := entry.tag
        zbtb_mem(i % 2)(io.up.pc(index_len - 1, 2) ## (i / 2).U).target := entry.target
        printf(cf"zbtb(${i})(0x${io.up.pc.pc_to_word}%x) := 0x${io.up.target.pc_to_word}%x\n")
      }
    }
  }
}

class BTBResult extends Bundle {
  val jump   = Bool()
  val br     = Bool()
  val attr   = UInt(BTB_ATTR_LEN.W)
  val is_ret = Bool()
  val target = UInt(PC_LEN.W)
}

class BTBLookup extends Bundle {
  val pc     = Input(UInt(PC_LEN.W))
  val result = Output(Vec(4, new BTBResult))
}

class BTBUpdate extends Bundle {
  val en     = Input(Bool())
  val pc     = Input(UInt(PC_LEN.W))
  val attr   = Input(UInt(BTB_ATTR_LEN.W))
  val is_ret = Input(Bool())
  val target = Input(UInt(PC_LEN.W))
}

class BTBEntry(tag_len: Int) extends Bundle {
  val tag    = UInt(tag_len.W)
  val attr   = UInt(BTB_ATTR_LEN.W)
  val shared = UInt(1.W)
  val target = UInt((PC_LEN - 1).W)
}

class BTBPC(tag_len: Int, index_len: Int) extends Bundle {
  val tag   = UInt(tag_len.W)
  val index = UInt((index_len - 2).W)
}

class BTBIo extends Bundle {
  val lu = new BTBLookup
  val up = new BTBUpdate
}

class BTB(btb_entries: Int, tag_ignore: Int = BTB_TAG_IGNORE) extends Module {
  val index_len = log2Ceil(btb_entries)
  val tag_len   = PC_LEN - tag_ignore - index_len
  val entry_len = tag_len + BTB_ATTR_LEN + PC_LEN

  val io = IO(new BTBIo)

  val btb_mem = List.fill(4)(Mem(btb_entries / 4, UInt(entry_len.W)))

  val reg_entry = RegInit(VecInit.fill(4)(0.U(entry_len.W)))

  val lu_pc = (io.lu.pc(PC_LEN-1-tag_ignore, 2)).asTypeOf(new BTBPC(tag_len, index_len))
  val reg_lu_pc_tag = RegNext(lu_pc.tag, 0.U(tag_len.W))

  for (i <- 0 until 4) {
    reg_entry(i) := btb_mem(i).read(lu_pc.index)
  }

  val entry = reg_entry.map(e => e.asTypeOf(new BTBEntry(tag_len)))

  val tag_match = entry.map(e => (e.tag === reg_lu_pc_tag))
  val result = Wire(Vec(4, new BTBResult))
  for (i <- 0 until 4) {
    result(i).jump   := tag_match(i) && (entry(i).attr === BTB_ATTR_DJUMP || entry(i).attr === BTB_ATTR_DCALL)
    result(i).br     := tag_match(i) && (entry(i).attr === BTB_ATTR_BR)
    result(i).attr   := Mux(tag_match(i), entry(i).attr, BTB_ATTR_INVAL)
    result(i).is_ret := tag_match(i) && entry(i).shared.asBool && (entry(i).attr === BTB_ATTR_INVAL)
    result(i).target := entry(i).shared ## entry(i).target
    io.lu.result(i)  := result(i)
  }

  val up_pc = (io.up.pc(tag_len + index_len - 1, 2)).asTypeOf(new BTBPC(tag_len, index_len))
  val target = Cat(
    Mux(io.up.attr === BTB_ATTR_INVAL, io.up.is_ret, io.up.target(PC_LEN - 1)),
    io.up.target(PC_LEN - 2, 0)
  )
  for (i <- 0 until 4) {
    when (io.up.en && io.up.pc(1, 0) === i.U(2.W)) {
      btb_mem(i).write(up_pc.index, up_pc.tag ## io.up.attr ## target)
    }
  }
}

class PHTMemIo(index_len: Int) extends Bundle {
  val ren   = Input(Bool())
  val wen   = Input(Bool())
  val raddr = Input(UInt((index_len-2).W))
  val rdata = Output(UInt(8.W))
  val waddr = Input(UInt(index_len.W))
  val wdata = Input(UInt(2.W))
}

class PHTLookup extends Bundle {
  val pc    = Input(UInt(PC_LEN.W))
  val taken = Output(Vec(4, Bool()))
  val lcnt  = Output(Vec(4, UInt(2.W)))
  val gcnt  = Output(Vec(4, UInt(2.W)))
}

class PHTUpdate(history_len: Int) extends Bundle {
  val en      = Input(Bool())
  val history = Input(UInt(history_len.W))
  val pc      = Input(UInt(PC_LEN.W))
  val lcnt    = Input(UInt(2.W))
  val gcnt    = Input(UInt(2.W))
}

class PHTBranch extends Bundle {
  val en  = Input(Bool())
  val pc  = Input(UInt(PC_LEN.W))
}

class PHTBranch2(history_len: Int) extends Bundle {
  val en      = Input(Bool())
  val history = Input(UInt(history_len.W))
  val pc      = Input(UInt(PC_LEN.W))
}

class PHTReset(history_len: Int) extends Bundle {
  val en      = Input(Bool())
  val history = Input(UInt(history_len.W))
}

class PHTIo(index_len: Int, history_len: Int) extends Bundle {
  val lu      = new PHTLookup
  val up      = new PHTUpdate(history_len)
  val lmem    = Flipped(new PHTMemIo(index_len))
  val gmem    = Flipped(new PHTMemIo(index_len))
  val br      = new PHTBranch
  val br2     = new PHTBranch2(history_len)
  val history = Output(UInt(history_len.W))
  val res     = new PHTReset(history_len)
}

class PHT(index_len: Int, history_len: Int, history_shift: Int) extends Module {
  val io = IO(new PHTIo(index_len, history_len))

  val history = RegInit(0.U(history_len.W))

  def merge(history: UInt, pc: UInt): UInt = {
    ((Reverse(history) << (index_len - history_len)) ^ (pc >> 2))(index_len-1, 0)
  }

  def hash(history: UInt, pc: UInt): UInt = {
    ((history << history_shift) ^ pc)(history_len-1, 0)
  }

  io.lmem.ren   := true.B
  io.lmem.raddr := io.lu.pc(index_len-1, 2)
  val lcnt = io.lmem.rdata
  io.gmem.ren   := true.B
  io.gmem.raddr := merge(history, io.lu.pc)(index_len-1, 2)
  val gcnt = io.gmem.rdata
  for (i <- 0 until 4) {
    io.lu.lcnt(i)  := lcnt(i * 2 + 1, i * 2)
    io.lu.gcnt(i)  := gcnt(i * 2 + 1, i * 2)
    io.lu.taken(i) := Mux(gcnt(i * 2 + 1), gcnt(i * 2), lcnt(i * 2))
  }

  // io.history := RegNext(history, 0.U(history_len.W))
  io.history := history

  when (io.br.en) {
    history := hash(history, io.br.pc)(history_len-1, 0)
    printf(cf"PHT br 0x${hash(history, io.br.pc)(history_len-1, 0)}%x\n")
  }

  when (io.res.en) {
    history := io.res.history
    printf(cf"PHT reset 0x${io.res.history}%x\n")
  }

  when (io.br2.en) {
    history := hash(io.br2.history, io.br2.pc)(history_len-1, 0)
    printf(cf"PHT br2 0x${hash(io.br2.history, io.br2.pc)(history_len-1, 0)}%x\n")
  }

  io.lmem.wen   := io.up.en
  io.lmem.waddr := io.up.pc(index_len-1, 0)
  io.lmem.wdata := io.up.lcnt

  io.gmem.wen   := io.up.en
  io.gmem.waddr := merge(io.up.history, io.up.pc)(index_len-1, 0)
  io.gmem.wdata := io.up.gcnt

  // printf(cf"io.lu.pc         : 0x${Cat(io.lu.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.lu.cnt0       : 0x${io.lu.cnt0}%x\n")
  // printf(cf"io.lu.cnt1       : 0x${io.lu.cnt1}%x\n")
  // printf(cf"io.up.en         : ${io.up.en}\n")
  // printf(cf"io.up.pc         : 0x${Cat(io.up.pc, 0.U(1.W))}%x\n")
  // printf(cf"io.up.lcnt       : 0x${io.up.lcnt}%x\n")
}

class RASTop(index_len: Int) extends Bundle {
  val ret_pc = Output(UInt(PC_LEN.W))
  val index  = Output(UInt(index_len.W))
}

class RASRet(index_len: Int) extends Bundle {
  val en    = Input(Bool())
  val index = Input(UInt(index_len.W))
}

class RASCall(index_len: Int) extends Bundle {
  val en     = Input(Bool())
  val index  = Input(UInt(index_len.W))
  val ret_pc = Input(UInt(PC_LEN.W))
}

class RASUpdate(index_len: Int) extends Bundle {
  val en    = Input(Bool())
  val index = Input(UInt(index_len.W))
}

class RASIo(index_len: Int) extends Bundle {
  val top   = new RASTop(index_len)
  val ret1  = new RASRet(index_len)
  val call1 = new RASCall(index_len)
  val up    = new RASUpdate(index_len)
  val ret2  = new RASRet(index_len)
  val call2 = new RASCall(index_len)
}

class RAS(index_len: Int) extends Module {
  val ras_entries = (1 << index_len)

  val io = IO(new RASIo(index_len))

  val ras   = Mem(ras_entries, UInt(PC_LEN.W))
  val index = RegInit(0.U(index_len.W))

  val ret_pc    = RegInit(0.U(PC_LEN.W))
  val ret_index = RegNext(index, 0.U(index_len.W))

  ret_pc := ras(index)
  io.top.ret_pc := ret_pc
  io.top.index  := ret_index

  when (io.ret1.en) {
    index := io.ret1.index
    printf(cf"RAS ret1 index=${index}=>${io.ret1.index} pc=0x${Cat(ras(index), 0.U(1.W))}%x\n")
  }

  when (io.call1.en && !io.call2.en) {
    index := io.call1.index
    ras(io.call1.index) := io.call1.ret_pc
    printf(cf"RAS call1 index=${io.call1.index} pc=0x${Cat(io.call1.ret_pc, 0.U(1.W))}%x\n")
  }

  when (io.up.en) {
    index := io.up.index
    printf(cf"RAS reset index=${io.up.index}\n")
  }

  when (io.ret2.en) {
    index := io.ret2.index
    printf(cf"RAS ret2 index=${io.ret2.index}\n")
  }

  when (io.call2.en) {
    index := io.call2.index
    ras(io.call2.index) := io.call2.ret_pc
    printf(cf"RAS call2 index=${io.call2.index} pc=0x${Cat(io.call2.ret_pc, 0.U(1.W))}%x\n")
  }
}
