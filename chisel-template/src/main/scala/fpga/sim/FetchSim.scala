package fpga.sim

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage
import common.Consts._
import fpga._

class FetchSim() extends Module {
  val dram_config = DramConfig()
  val zbtb_entries = ZBTB_ENTRIES
  val btb_entries = BTB_ENTRIES
  val pht_index_len = PHT_INDEX_LEN
  val pht_history_len = PHT_HISTORY_LEN
  val ras_entries = RAS_ENTRIES
  val redirect_buffer_size = REDIRECT_BUFFER_SIZE
  val ras_index_len  = log2Ceil(ras_entries)
  val enable_debug = false

  val io = IO(new Bundle {
    val ft         = new FetchPort(redirect_buffer_size)
    val cr         = new BranchCorrectionPort(pht_history_len, ras_entries)
    val redir_deq  = new RedirectDequeuePort(enable_debug, redirect_buffer_size)
    val redir_read = new RedirectReadPort(redirect_buffer_size, pht_history_len, ras_entries)
    val zbtb       = Flipped(new ZBTBIo(ZBTB_TARGET_LEN))
    val btb        = Flipped(new BTBIo)
    val pht        = Flipped(new PHTIo(pht_index_len, pht_history_len))
    val ras        = Flipped(new RASIo(ras_index_len))
    val pht_lmem   = Flipped(new PHTMemIo(pht_index_len))
    val pht_gmem   = Flipped(new PHTMemIo(pht_index_len))
  })
  val reg_ft         = Reg(Input(new FetchPort(redirect_buffer_size)))
  val reg_cr         = Reg(Input(new BranchCorrectionPort(pht_history_len, ras_entries)))
  val reg_redir_deq  = Reg(Input(new RedirectDequeuePort(enable_debug, redirect_buffer_size)))
  val reg_redir_read = Reg(Input(new RedirectReadPort(redirect_buffer_size, pht_history_len, ras_entries)))
  val reg_zbtb       = Reg(Flipped(Output(new ZBTBIo(ZBTB_TARGET_LEN))))
  val reg_btb        = Reg(Flipped(Output(new BTBIo)))
  val reg_pht        = Reg(Flipped(Output(new PHTIo(pht_index_len, pht_history_len))))
  val reg_ras        = Reg(Flipped(Output(new RASIo(ras_index_len))))
  val reg_pht_lmem   = Reg(Flipped(Output(new PHTMemIo(pht_index_len))))
  val reg_pht_gmem   = Reg(Flipped(Output(new PHTMemIo(pht_index_len))))
  val reg_reset      = RegInit(true.B)

  val fetcher = Module(new Fetcher(dram_config, pht_history_len, redirect_buffer_size))
  val fp = Module(new FetchPredictor(zbtb_entries, btb_entries, pht_index_len, pht_history_len, ras_entries, redirect_buffer_size))
  val rb = Module(new FetchRedirectBuffer(redirect_buffer_size, pht_history_len, ras_entries, enable_debug))

  fetcher.reset := reset.asBool | reg_reset
  fp.reset := reset.asBool | reg_reset
  rb.reset := reset.asBool | reg_reset
  fetcher.io.ft.flush_en           := reg_ft.flush_en
  fetcher.io.ft.inst2.ready        := reg_ft.inst2.ready
  fetcher.io.ft.imem.inst          := reg_ft.imem.inst
  fetcher.io.ft.icache.addr_ready  := reg_ft.icache.addr_ready
  fetcher.io.ft.icache.idata       := reg_ft.icache.idata
  fetcher.io.ft.imem.valid         := reg_ft.imem.valid
  fetcher.io.ft.inst1.ready        := reg_ft.inst1.ready
  fetcher.io.ft.icache.idata_valid := reg_ft.icache.idata_valid
  fetcher.io.ft.flush_iaddr        := reg_ft.flush_iaddr
  fp.io.cr.en                      := reg_cr.en
  fp.io.cr.pc                      := reg_cr.pc
  fp.io.cr.bp_entry                := reg_cr.bp_entry
  fp.io.cr.fp_entry                := reg_cr.fp_entry
  fp.io.cr.fp_hit                  := reg_cr.fp_hit
  fp.io.cr.mispred                 := reg_cr.mispred
  fp.io.cr.br_taken                := reg_cr.br_taken
  fp.io.cr.attr                    := reg_cr.attr
  fp.io.cr.is_ret                  := reg_cr.is_ret
  fp.io.cr.target                  := reg_cr.target
  fp.io.cr.next_pc                 := reg_cr.next_pc
  rb.io.deq.en                     := reg_redir_deq.en
  rb.io.read.ptr                   := reg_redir_read.ptr
  fp.io.zbtb.lu.matches            := reg_zbtb.lu.matches
  fp.io.zbtb.lu.target             := reg_zbtb.lu.target
  fp.io.btb.lu.result              := reg_btb.lu.result
  fp.io.pht.lu.taken               := reg_pht.lu.taken
  fp.io.pht.lu.lcnt                := reg_pht.lu.lcnt
  fp.io.pht.lu.gcnt                := reg_pht.lu.gcnt
  fp.io.pht.lmem.ren               := reg_pht.lmem.ren
  fp.io.pht.lmem.wen               := reg_pht.lmem.wen
  fp.io.pht.lmem.raddr             := reg_pht.lmem.raddr
  fp.io.pht.lmem.waddr             := reg_pht.lmem.waddr
  fp.io.pht.lmem.wdata             := reg_pht.lmem.wdata
  fp.io.pht.gmem.ren               := reg_pht.gmem.ren
  fp.io.pht.gmem.wen               := reg_pht.gmem.wen
  fp.io.pht.gmem.raddr             := reg_pht.gmem.raddr
  fp.io.pht.gmem.waddr             := reg_pht.gmem.waddr
  fp.io.pht.gmem.wdata             := reg_pht.gmem.wdata
  fp.io.pht.history                := reg_pht.history
  fp.io.ras.top                    := reg_ras.top
  fp.io.pht_lmem.rdata             := reg_pht_lmem.rdata
  fp.io.pht_gmem.rdata             := reg_pht_gmem.rdata

  fp.io.pr <> fetcher.io.pr
  fp.io.re <> rb.io.enq
  fp.io.ru <> rb.io.upd

  reg_reset      := reset
  reg_ft         := io.ft
  reg_cr         := io.cr
  reg_redir_deq  := io.redir_deq
  reg_redir_read := io.redir_read
  reg_zbtb       := io.zbtb
  reg_btb        := io.btb
  reg_pht        := io.pht
  reg_ras        := io.ras
  reg_pht_lmem   := io.pht_lmem
  reg_pht_gmem   := io.pht_gmem

  io.ft          :<= fetcher.io.ft
  io.cr          :<= fp.io.cr
  io.redir_deq   :<= rb.io.deq
  io.redir_read  :<= rb.io.read

  fp.io.zbtb     :>= io.zbtb
  fp.io.btb      :>= io.btb
  fp.io.pht      :>= io.pht
  fp.io.ras      :>= io.ras
  fp.io.pht_lmem :>= io.pht_lmem
  fp.io.pht_gmem :>= io.pht_gmem
}

object ElaborateFetchSim extends App {
  (new ChiselStage).emitVerilog(new FetchSim(), Array(
    "-o", "fetch.v",
    "--target-dir", "rtl/sim",
    "--throw-on-first-error"
  ))
}
