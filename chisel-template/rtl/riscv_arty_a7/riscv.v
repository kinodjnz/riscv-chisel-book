module LongCounter(
  input         clock,
  input         reset,
  output [63:0] io_value
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] counter; // @[Core.scala 27:24]
  wire [63:0] _counter_T_1 = counter + 64'h1; // @[Core.scala 28:22]
  assign io_value = counter; // @[Core.scala 29:12]
  always @(posedge clock) begin
    if (reset) begin // @[Core.scala 27:24]
      counter <= 64'h0; // @[Core.scala 27:24]
    end else begin
      counter <= _counter_T_1; // @[Core.scala 28:11]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  counter = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MachineTimer(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata,
  input         io_mem_ren,
  output        io_mem_rvalid,
  input  [31:0] io_mem_waddr,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  output        io_intr,
  output [63:0] io_mtime
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mtime; // @[MachineTimer.scala 14:22]
  reg [63:0] mtimecmp; // @[MachineTimer.scala 15:25]
  reg  intr; // @[MachineTimer.scala 16:21]
  wire [63:0] _mtime_T_1 = mtime + 64'h1; // @[MachineTimer.scala 18:18]
  wire [31:0] _GEN_0 = io_mem_raddr == 32'hc ? mtimecmp[63:32] : 32'h0; // @[MachineTimer.scala 30:40 31:20 33:20]
  wire [31:0] _GEN_1 = io_mem_raddr == 32'h8 ? mtimecmp[31:0] : _GEN_0; // @[MachineTimer.scala 28:39 29:20]
  wire [31:0] _GEN_2 = io_mem_raddr == 32'h4 ? mtime[63:32] : _GEN_1; // @[MachineTimer.scala 26:39 27:20]
  wire [31:0] _GEN_3 = io_mem_raddr == 32'h0 ? mtime[31:0] : _GEN_2; // @[MachineTimer.scala 24:33 25:20]
  wire [63:0] _mtime_T_3 = {mtime[63:32],io_mem_wdata}; // @[Cat.scala 31:58]
  wire [63:0] _mtime_T_5 = {io_mem_wdata,mtime[31:0]}; // @[Cat.scala 31:58]
  wire [63:0] _mtimecmp_T_1 = {mtimecmp[63:32],io_mem_wdata}; // @[Cat.scala 31:58]
  wire [63:0] _mtimecmp_T_3 = {io_mem_wdata,mtimecmp[31:0]}; // @[Cat.scala 31:58]
  wire [63:0] _GEN_6 = io_mem_waddr == 32'hc ? _mtimecmp_T_3 : mtimecmp; // @[MachineTimer.scala 49:40 50:16 15:25]
  wire [63:0] _GEN_7 = io_mem_waddr == 32'h8 ? _mtimecmp_T_1 : _GEN_6; // @[MachineTimer.scala 47:39 48:16]
  assign io_mem_rdata = io_mem_ren ? _GEN_3 : 32'h0; // @[MachineTimer.scala 23:21 37:18]
  assign io_mem_rvalid = io_mem_ren; // @[MachineTimer.scala 23:21 35:19 38:19]
  assign io_intr = intr; // @[MachineTimer.scala 20:11]
  assign io_mtime = mtime; // @[MachineTimer.scala 21:12]
  always @(posedge clock) begin
    if (reset) begin // @[MachineTimer.scala 14:22]
      mtime <= 64'h0; // @[MachineTimer.scala 14:22]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 42:21]
      if (io_mem_waddr == 32'h0) begin // @[MachineTimer.scala 43:33]
        mtime <= _mtime_T_3; // @[MachineTimer.scala 44:13]
      end else if (io_mem_waddr == 32'h4) begin // @[MachineTimer.scala 45:39]
        mtime <= _mtime_T_5; // @[MachineTimer.scala 46:13]
      end else begin
        mtime <= _mtime_T_1; // @[MachineTimer.scala 18:9]
      end
    end else begin
      mtime <= _mtime_T_1; // @[MachineTimer.scala 18:9]
    end
    if (reset) begin // @[MachineTimer.scala 15:25]
      mtimecmp <= 64'hffffffff; // @[MachineTimer.scala 15:25]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 42:21]
      if (!(io_mem_waddr == 32'h0)) begin // @[MachineTimer.scala 43:33]
        if (!(io_mem_waddr == 32'h4)) begin // @[MachineTimer.scala 45:39]
          mtimecmp <= _GEN_7;
        end
      end
    end
    if (reset) begin // @[MachineTimer.scala 16:21]
      intr <= 1'h0; // @[MachineTimer.scala 16:21]
    end else begin
      intr <= mtime >= mtimecmp; // @[MachineTimer.scala 19:8]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mtime = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  mtimecmp = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  intr = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BranchPredictor(
  input         clock,
  input         reset,
  input  [31:0] io_lu_inst_pc,
  output        io_lu_br_hit,
  output        io_lu_br_pos,
  output [31:0] io_lu_br_addr,
  input         io_up_update_en,
  input  [31:0] io_up_inst_pc,
  input         io_up_br_pos,
  input  [31:0] io_up_br_addr
);
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
`endif // RANDOMIZE_REG_INIT
  reg [56:0] bp_cache [0:255]; // @[BranchPredictor.scala 32:21]
  wire  bp_cache_bp_reg_rd_MPORT_en; // @[BranchPredictor.scala 32:21]
  wire [7:0] bp_cache_bp_reg_rd_MPORT_addr; // @[BranchPredictor.scala 32:21]
  wire [56:0] bp_cache_bp_reg_rd_MPORT_data; // @[BranchPredictor.scala 32:21]
  wire  bp_cache_bp_reg_update_rd_MPORT_en; // @[BranchPredictor.scala 32:21]
  wire [7:0] bp_cache_bp_reg_update_rd_MPORT_addr; // @[BranchPredictor.scala 32:21]
  wire [56:0] bp_cache_bp_reg_update_rd_MPORT_data; // @[BranchPredictor.scala 32:21]
  wire [56:0] bp_cache_MPORT_data; // @[BranchPredictor.scala 32:21]
  wire [7:0] bp_cache_MPORT_addr; // @[BranchPredictor.scala 32:21]
  wire  bp_cache_MPORT_mask; // @[BranchPredictor.scala 32:21]
  wire  bp_cache_MPORT_en; // @[BranchPredictor.scala 32:21]
  reg [56:0] bp_reg_rd; // @[BranchPredictor.scala 40:31]
  reg [22:0] bp_reg_tag; // @[BranchPredictor.scala 41:31]
  wire [1:0] bp_rd_hist = bp_reg_rd[56:55]; // @[BranchPredictor.scala 49:29]
  wire [22:0] bp_rd_tag = bp_reg_rd[54:32]; // @[BranchPredictor.scala 50:29]
  wire [31:0] bp_rd_br = bp_reg_rd[31:0]; // @[BranchPredictor.scala 51:29]
  wire  bp_cache_do_br = bp_rd_hist[1]; // @[BranchPredictor.scala 52:34]
  reg  bp_reg_update_pos; // @[BranchPredictor.scala 58:38]
  reg [31:0] bp_reg_update_br_addr; // @[BranchPredictor.scala 59:38]
  reg [56:0] bp_reg_update_rd; // @[BranchPredictor.scala 60:38]
  reg  bp_reg_update_write; // @[BranchPredictor.scala 64:38]
  reg [22:0] bp_reg_update_tag; // @[BranchPredictor.scala 65:38]
  reg [7:0] bp_reg_update_index; // @[BranchPredictor.scala 66:38]
  reg  bp_reg_write_en; // @[BranchPredictor.scala 67:38]
  reg [7:0] bp_reg_write_index; // @[BranchPredictor.scala 68:38]
  reg [1:0] bp_reg_write_hist; // @[BranchPredictor.scala 69:38]
  reg [22:0] bp_reg_write_tag; // @[BranchPredictor.scala 70:38]
  reg [31:0] bp_reg_write_br_addr; // @[BranchPredictor.scala 71:38]
  wire [1:0] bp_update_rd_hist = bp_reg_update_rd[56:55]; // @[BranchPredictor.scala 76:43]
  wire [22:0] bp_update_rd_tag = bp_reg_update_rd[54:32]; // @[BranchPredictor.scala 77:43]
  wire [31:0] bp_update_rd_br = bp_reg_update_rd[31:0]; // @[BranchPredictor.scala 78:43]
  wire [7:0] bp_update_index = io_up_inst_pc[8:1]; // @[BranchPredictor.scala 81:38]
  wire  _bp_update_hist_T_2 = bp_reg_update_pos & bp_update_rd_hist == 2'h3; // @[BranchPredictor.scala 85:26]
  wire [1:0] _bp_update_hist_T_4 = bp_update_rd_hist + 2'h1; // @[BranchPredictor.scala 86:83]
  wire  _bp_update_hist_T_5 = ~bp_reg_update_pos; // @[BranchPredictor.scala 87:8]
  wire  _bp_update_hist_T_7 = ~bp_reg_update_pos & bp_update_rd_hist == 2'h0; // @[BranchPredictor.scala 87:27]
  wire [1:0] _bp_update_hist_T_10 = bp_update_rd_hist - 2'h1; // @[BranchPredictor.scala 88:83]
  wire [1:0] _bp_update_hist_T_11 = _bp_update_hist_T_5 ? _bp_update_hist_T_10 : 2'h0; // @[Mux.scala 101:16]
  wire [1:0] _bp_update_hist_T_12 = _bp_update_hist_T_7 ? 2'h0 : _bp_update_hist_T_11; // @[Mux.scala 101:16]
  wire  _T = ~io_up_update_en; // @[BranchPredictor.scala 105:8]
  wire [24:0] hi = {bp_reg_write_hist,bp_reg_write_tag}; // @[Cat.scala 31:58]
  assign bp_cache_bp_reg_rd_MPORT_en = 1'h1;
  assign bp_cache_bp_reg_rd_MPORT_addr = io_lu_inst_pc[8:1];
  assign bp_cache_bp_reg_rd_MPORT_data = bp_cache[bp_cache_bp_reg_rd_MPORT_addr]; // @[BranchPredictor.scala 32:21]
  assign bp_cache_bp_reg_update_rd_MPORT_en = io_up_update_en;
  assign bp_cache_bp_reg_update_rd_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_bp_reg_update_rd_MPORT_data = bp_cache[bp_cache_bp_reg_update_rd_MPORT_addr]; // @[BranchPredictor.scala 32:21]
  assign bp_cache_MPORT_data = {hi,bp_reg_write_br_addr};
  assign bp_cache_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_MPORT_mask = 1'h1;
  assign bp_cache_MPORT_en = _T & bp_reg_write_en;
  assign io_lu_br_hit = bp_reg_tag == bp_rd_tag; // @[BranchPredictor.scala 53:30]
  assign io_lu_br_pos = bp_cache_do_br & io_lu_br_hit; // @[BranchPredictor.scala 54:34]
  assign io_lu_br_addr = io_lu_br_pos ? bp_rd_br : 32'h0; // @[BranchPredictor.scala 55:23]
  always @(posedge clock) begin
    if (bp_cache_MPORT_en & bp_cache_MPORT_mask) begin
      bp_cache[bp_cache_MPORT_addr] <= bp_cache_MPORT_data; // @[BranchPredictor.scala 32:21]
    end
    if (reset) begin // @[BranchPredictor.scala 40:31]
      bp_reg_rd <= 57'h0; // @[BranchPredictor.scala 40:31]
    end else begin
      bp_reg_rd <= bp_cache_bp_reg_rd_MPORT_data; // @[BranchPredictor.scala 48:13]
    end
    if (reset) begin // @[BranchPredictor.scala 41:31]
      bp_reg_tag <= 23'h0; // @[BranchPredictor.scala 41:31]
    end else begin
      bp_reg_tag <= io_lu_inst_pc[31:9]; // @[BranchPredictor.scala 43:14]
    end
    if (reset) begin // @[BranchPredictor.scala 58:38]
      bp_reg_update_pos <= 1'h0; // @[BranchPredictor.scala 58:38]
    end else begin
      bp_reg_update_pos <= io_up_br_pos; // @[BranchPredictor.scala 73:21]
    end
    if (reset) begin // @[BranchPredictor.scala 59:38]
      bp_reg_update_br_addr <= 32'h0; // @[BranchPredictor.scala 59:38]
    end else begin
      bp_reg_update_br_addr <= io_up_br_addr; // @[BranchPredictor.scala 74:25]
    end
    if (reset) begin // @[BranchPredictor.scala 60:38]
      bp_reg_update_rd <= 57'h0; // @[BranchPredictor.scala 60:38]
    end else if (io_up_update_en) begin // @[BranchPredictor.scala 99:25]
      bp_reg_update_rd <= bp_cache_bp_reg_update_rd_MPORT_data; // @[BranchPredictor.scala 103:22]
    end
    if (reset) begin // @[BranchPredictor.scala 64:38]
      bp_reg_update_write <= 1'h0; // @[BranchPredictor.scala 64:38]
    end else begin
      bp_reg_update_write <= io_up_update_en; // @[BranchPredictor.scala 72:23]
    end
    if (reset) begin // @[BranchPredictor.scala 65:38]
      bp_reg_update_tag <= 23'h0; // @[BranchPredictor.scala 65:38]
    end else begin
      bp_reg_update_tag <= io_up_inst_pc[31:9]; // @[BranchPredictor.scala 80:21]
    end
    if (reset) begin // @[BranchPredictor.scala 66:38]
      bp_reg_update_index <= 8'h0; // @[BranchPredictor.scala 66:38]
    end else begin
      bp_reg_update_index <= bp_update_index; // @[BranchPredictor.scala 82:23]
    end
    if (reset) begin // @[BranchPredictor.scala 67:38]
      bp_reg_write_en <= 1'h0; // @[BranchPredictor.scala 67:38]
    end else begin
      bp_reg_write_en <= bp_reg_update_write; // @[BranchPredictor.scala 93:24]
    end
    if (reset) begin // @[BranchPredictor.scala 68:38]
      bp_reg_write_index <= 8'h0; // @[BranchPredictor.scala 68:38]
    end else begin
      bp_reg_write_index <= bp_reg_update_index; // @[BranchPredictor.scala 94:24]
    end
    if (reset) begin // @[BranchPredictor.scala 69:38]
      bp_reg_write_hist <= 2'h0; // @[BranchPredictor.scala 69:38]
    end else if (bp_update_rd_tag == bp_reg_update_tag) begin // @[BranchPredictor.scala 83:27]
      if (_bp_update_hist_T_2) begin // @[Mux.scala 101:16]
        bp_reg_write_hist <= 2'h3;
      end else if (bp_reg_update_pos) begin // @[Mux.scala 101:16]
        bp_reg_write_hist <= _bp_update_hist_T_4;
      end else begin
        bp_reg_write_hist <= _bp_update_hist_T_12;
      end
    end else if (bp_reg_update_pos) begin // @[BranchPredictor.scala 90:8]
      bp_reg_write_hist <= 2'h2;
    end else begin
      bp_reg_write_hist <= 2'h1;
    end
    if (reset) begin // @[BranchPredictor.scala 70:38]
      bp_reg_write_tag <= 23'h0; // @[BranchPredictor.scala 70:38]
    end else begin
      bp_reg_write_tag <= bp_reg_update_tag; // @[BranchPredictor.scala 96:24]
    end
    if (reset) begin // @[BranchPredictor.scala 71:38]
      bp_reg_write_br_addr <= 32'h0; // @[BranchPredictor.scala 71:38]
    end else if (bp_reg_update_pos) begin // @[BranchPredictor.scala 92:35]
      bp_reg_write_br_addr <= bp_reg_update_br_addr;
    end else begin
      bp_reg_write_br_addr <= bp_update_rd_br;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    bp_cache[initvar] = _RAND_0[56:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {2{`RANDOM}};
  bp_reg_rd = _RAND_1[56:0];
  _RAND_2 = {1{`RANDOM}};
  bp_reg_tag = _RAND_2[22:0];
  _RAND_3 = {1{`RANDOM}};
  bp_reg_update_pos = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  bp_reg_update_br_addr = _RAND_4[31:0];
  _RAND_5 = {2{`RANDOM}};
  bp_reg_update_rd = _RAND_5[56:0];
  _RAND_6 = {1{`RANDOM}};
  bp_reg_update_write = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  bp_reg_update_tag = _RAND_7[22:0];
  _RAND_8 = {1{`RANDOM}};
  bp_reg_update_index = _RAND_8[7:0];
  _RAND_9 = {1{`RANDOM}};
  bp_reg_write_en = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  bp_reg_write_index = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  bp_reg_write_hist = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  bp_reg_write_tag = _RAND_12[22:0];
  _RAND_13 = {1{`RANDOM}};
  bp_reg_write_br_addr = _RAND_13[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Core(
  input         clock,
  input         reset,
  output [31:0] io_imem_addr,
  input  [31:0] io_imem_inst,
  input         io_imem_valid,
  output        io_icache_control_invalidate,
  input         io_icache_control_busy,
  output [31:0] io_dmem_raddr,
  input  [31:0] io_dmem_rdata,
  output        io_dmem_ren,
  input         io_dmem_rvalid,
  output [31:0] io_dmem_waddr,
  output        io_dmem_wen,
  input         io_dmem_wready,
  output [3:0]  io_dmem_wstrb,
  output [31:0] io_dmem_wdata,
  input  [31:0] io_mtimer_mem_raddr,
  output [31:0] io_mtimer_mem_rdata,
  input         io_mtimer_mem_ren,
  output        io_mtimer_mem_rvalid,
  input  [31:0] io_mtimer_mem_waddr,
  input         io_mtimer_mem_wen,
  input  [31:0] io_mtimer_mem_wdata,
  input  [1:0]  io_intr,
  output        io_exit,
  output [31:0] io_debug_signal_mem_reg_pc,
  output        io_debug_signal_mem_is_valid_inst,
  output        io_debug_signal_me_intr,
  output [47:0] io_debug_signal_cycle_counter,
  output [31:0] io_debug_signal_id_pc,
  output [31:0] io_debug_signal_id_inst
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [63:0] _RAND_77;
  reg [63:0] _RAND_78;
  reg [63:0] _RAND_79;
  reg [63:0] _RAND_80;
  reg [63:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
  reg [63:0] _RAND_99;
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
  reg [31:0] _RAND_105;
  reg [31:0] _RAND_106;
  reg [31:0] _RAND_107;
  reg [31:0] _RAND_108;
  reg [31:0] _RAND_109;
  reg [31:0] _RAND_110;
  reg [31:0] _RAND_111;
  reg [31:0] _RAND_112;
  reg [31:0] _RAND_113;
  reg [31:0] _RAND_114;
  reg [31:0] _RAND_115;
  reg [31:0] _RAND_116;
  reg [31:0] _RAND_117;
  reg [31:0] _RAND_118;
  reg [31:0] _RAND_119;
  reg [31:0] _RAND_120;
  reg [31:0] _RAND_121;
  reg [31:0] _RAND_122;
  reg [31:0] _RAND_123;
  reg [31:0] _RAND_124;
  reg [31:0] _RAND_125;
  reg [31:0] _RAND_126;
  reg [31:0] _RAND_127;
  reg [31:0] _RAND_128;
  reg [31:0] _RAND_129;
  reg [31:0] _RAND_130;
  reg [31:0] _RAND_131;
  reg [31:0] _RAND_132;
  reg [31:0] _RAND_133;
  reg [31:0] _RAND_134;
  reg [31:0] _RAND_135;
  reg [31:0] _RAND_136;
  reg [31:0] _RAND_137;
  reg [31:0] _RAND_138;
  reg [31:0] _RAND_139;
  reg [31:0] _RAND_140;
  reg [31:0] _RAND_141;
  reg [31:0] _RAND_142;
  reg [31:0] _RAND_143;
  reg [31:0] _RAND_144;
  reg [31:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
  reg [31:0] _RAND_149;
  reg [31:0] _RAND_150;
  reg [31:0] _RAND_151;
  reg [31:0] _RAND_152;
  reg [31:0] _RAND_153;
  reg [31:0] _RAND_154;
  reg [31:0] _RAND_155;
  reg [31:0] _RAND_156;
  reg [31:0] _RAND_157;
  reg [31:0] _RAND_158;
  reg [31:0] _RAND_159;
  reg [31:0] _RAND_160;
  reg [63:0] _RAND_161;
  reg [63:0] _RAND_162;
  reg [63:0] _RAND_163;
  reg [31:0] _RAND_164;
  reg [31:0] _RAND_165;
  reg [31:0] _RAND_166;
  reg [31:0] _RAND_167;
  reg [31:0] _RAND_168;
  reg [31:0] _RAND_169;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[Core.scala 74:20]
  wire  regfile_id_rs1_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_rs1_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_rs1_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_id_rs2_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_rs2_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_rs2_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_id_c_rs1_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_c_rs1_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_c_rs1_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_id_c_rs2_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_c_rs2_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_c_rs2_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_id_c_rs1p_data_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_c_rs1p_data_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_c_rs1p_data_data; // @[Core.scala 74:20]
  wire  regfile_id_c_rs2p_data_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_c_rs2p_data_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_c_rs2p_data_data; // @[Core.scala 74:20]
  wire  regfile_id_sp_data_en; // @[Core.scala 74:20]
  wire [4:0] regfile_id_sp_data_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_id_sp_data_data; // @[Core.scala 74:20]
  wire  regfile_ex1_op1_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_ex1_op1_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_ex1_op1_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_ex1_op2_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_ex1_op2_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_ex1_op2_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_ex1_rs2_data_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_ex1_rs2_data_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_ex1_rs2_data_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_io_gp_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_io_gp_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_io_gp_MPORT_data; // @[Core.scala 74:20]
  wire  regfile_io_exit_MPORT_en; // @[Core.scala 74:20]
  wire [4:0] regfile_io_exit_MPORT_addr; // @[Core.scala 74:20]
  wire [31:0] regfile_io_exit_MPORT_data; // @[Core.scala 74:20]
  wire [31:0] regfile_MPORT_data; // @[Core.scala 74:20]
  wire [4:0] regfile_MPORT_addr; // @[Core.scala 74:20]
  wire  regfile_MPORT_mask; // @[Core.scala 74:20]
  wire  regfile_MPORT_en; // @[Core.scala 74:20]
  wire  cycle_counter_clock; // @[Core.scala 77:29]
  wire  cycle_counter_reset; // @[Core.scala 77:29]
  wire [63:0] cycle_counter_io_value; // @[Core.scala 77:29]
  wire  mtimer_clock; // @[Core.scala 78:22]
  wire  mtimer_reset; // @[Core.scala 78:22]
  wire [31:0] mtimer_io_mem_raddr; // @[Core.scala 78:22]
  wire [31:0] mtimer_io_mem_rdata; // @[Core.scala 78:22]
  wire  mtimer_io_mem_ren; // @[Core.scala 78:22]
  wire  mtimer_io_mem_rvalid; // @[Core.scala 78:22]
  wire [31:0] mtimer_io_mem_waddr; // @[Core.scala 78:22]
  wire  mtimer_io_mem_wen; // @[Core.scala 78:22]
  wire [31:0] mtimer_io_mem_wdata; // @[Core.scala 78:22]
  wire  mtimer_io_intr; // @[Core.scala 78:22]
  wire [63:0] mtimer_io_mtime; // @[Core.scala 78:22]
  wire  bp_clock; // @[Core.scala 356:18]
  wire  bp_reset; // @[Core.scala 356:18]
  wire [31:0] bp_io_lu_inst_pc; // @[Core.scala 356:18]
  wire  bp_io_lu_br_hit; // @[Core.scala 356:18]
  wire  bp_io_lu_br_pos; // @[Core.scala 356:18]
  wire [31:0] bp_io_lu_br_addr; // @[Core.scala 356:18]
  wire  bp_io_up_update_en; // @[Core.scala 356:18]
  wire [31:0] bp_io_up_inst_pc; // @[Core.scala 356:18]
  wire  bp_io_up_br_pos; // @[Core.scala 356:18]
  wire [31:0] bp_io_up_br_addr; // @[Core.scala 356:18]
  reg [31:0] csr_trap_vector; // @[Core.scala 76:32]
  reg [63:0] instret; // @[Core.scala 79:24]
  reg [31:0] csr_mcause; // @[Core.scala 80:29]
  reg [31:0] csr_mtval; // @[Core.scala 81:29]
  reg [31:0] csr_mepc; // @[Core.scala 82:29]
  reg [31:0] csr_mstatus; // @[Core.scala 83:29]
  reg [31:0] csr_mscratch; // @[Core.scala 84:29]
  reg [31:0] csr_mie; // @[Core.scala 85:29]
  reg [31:0] csr_mip; // @[Core.scala 86:29]
  reg [31:0] id_reg_pc; // @[Core.scala 94:38]
  reg [31:0] id_reg_inst; // @[Core.scala 96:38]
  reg  id_reg_stall; // @[Core.scala 97:38]
  reg  id_reg_is_bp_pos; // @[Core.scala 98:38]
  reg [31:0] id_reg_bp_addr; // @[Core.scala 99:38]
  reg [1:0] id_reg_inst_cnt; // @[Core.scala 100:38]
  reg [31:0] ex1_reg_pc; // @[Core.scala 106:38]
  reg [1:0] ex1_reg_inst_cnt; // @[Core.scala 107:38]
  reg [4:0] ex1_reg_wb_addr; // @[Core.scala 108:38]
  reg [2:0] ex1_reg_op1_sel; // @[Core.scala 109:38]
  reg [3:0] ex1_reg_op2_sel; // @[Core.scala 110:38]
  reg [4:0] ex1_reg_rs1_addr; // @[Core.scala 111:38]
  reg [4:0] ex1_reg_rs2_addr; // @[Core.scala 112:38]
  reg [31:0] ex1_reg_op1_data; // @[Core.scala 113:38]
  reg [31:0] ex1_reg_op2_data; // @[Core.scala 114:38]
  reg [4:0] ex1_reg_exe_fun; // @[Core.scala 116:38]
  reg [1:0] ex1_reg_mem_wen; // @[Core.scala 117:38]
  reg  ex1_reg_rf_wen; // @[Core.scala 118:38]
  reg [2:0] ex1_reg_wb_sel; // @[Core.scala 119:38]
  reg [11:0] ex1_reg_csr_addr; // @[Core.scala 120:38]
  reg [2:0] ex1_reg_csr_cmd; // @[Core.scala 121:38]
  reg [31:0] ex1_reg_imm_b_sext; // @[Core.scala 124:38]
  reg [31:0] ex1_reg_mem_w; // @[Core.scala 127:38]
  reg  ex1_reg_is_j; // @[Core.scala 128:39]
  reg  ex1_reg_is_bp_pos; // @[Core.scala 129:39]
  reg [31:0] ex1_reg_bp_addr; // @[Core.scala 130:39]
  reg  ex1_reg_is_half; // @[Core.scala 131:39]
  reg  ex1_reg_is_valid_inst; // @[Core.scala 132:39]
  reg  ex1_reg_is_trap; // @[Core.scala 133:39]
  reg [31:0] ex1_reg_mcause; // @[Core.scala 134:39]
  reg [31:0] ex2_reg_pc; // @[Core.scala 138:38]
  reg [1:0] ex2_reg_inst_cnt; // @[Core.scala 139:38]
  reg [4:0] ex2_reg_wb_addr; // @[Core.scala 140:38]
  reg [31:0] ex2_reg_op1_data; // @[Core.scala 141:38]
  reg [31:0] ex2_reg_op2_data; // @[Core.scala 142:38]
  reg [31:0] ex2_reg_rs2_data; // @[Core.scala 143:38]
  reg [4:0] ex2_reg_exe_fun; // @[Core.scala 144:38]
  reg [1:0] ex2_reg_mem_wen; // @[Core.scala 145:38]
  reg  ex2_reg_rf_wen; // @[Core.scala 146:38]
  reg [2:0] ex2_reg_wb_sel; // @[Core.scala 147:38]
  reg [11:0] ex2_reg_csr_addr; // @[Core.scala 148:38]
  reg [2:0] ex2_reg_csr_cmd; // @[Core.scala 149:38]
  reg [31:0] ex2_reg_imm_b_sext; // @[Core.scala 150:38]
  reg [31:0] ex2_reg_mem_w; // @[Core.scala 151:38]
  reg  ex2_is_uncond_br; // @[Core.scala 152:38]
  reg  ex2_reg_is_bp_pos; // @[Core.scala 153:38]
  reg [31:0] ex2_reg_bp_addr; // @[Core.scala 154:38]
  reg  ex2_reg_is_half; // @[Core.scala 155:38]
  reg  ex2_reg_is_valid_inst; // @[Core.scala 156:38]
  reg  ex2_reg_is_trap; // @[Core.scala 157:38]
  reg [31:0] ex2_reg_mcause; // @[Core.scala 158:38]
  reg  ex3_reg_bp_en; // @[Core.scala 162:41]
  reg [31:0] ex3_reg_pc; // @[Core.scala 163:41]
  reg  ex3_reg_is_cond_br; // @[Core.scala 164:41]
  reg  ex3_reg_is_cond_br_inst; // @[Core.scala 165:41]
  reg  ex3_reg_is_uncond_br; // @[Core.scala 166:41]
  reg [31:0] ex3_reg_cond_br_target; // @[Core.scala 167:41]
  reg [31:0] ex3_reg_uncond_br_target; // @[Core.scala 168:41]
  reg  ex3_reg_is_bp_pos; // @[Core.scala 170:41]
  reg [31:0] ex3_reg_bp_addr; // @[Core.scala 171:41]
  reg  ex3_reg_is_half; // @[Core.scala 172:41]
  reg  mem_reg_en; // @[Core.scala 175:38]
  reg [31:0] mem_reg_pc; // @[Core.scala 176:38]
  reg [1:0] mem_reg_inst_cnt; // @[Core.scala 177:38]
  reg [4:0] mem_reg_wb_addr; // @[Core.scala 178:38]
  reg [31:0] mem_reg_op1_data; // @[Core.scala 179:38]
  reg [31:0] mem_reg_rs2_data; // @[Core.scala 180:38]
  reg [47:0] mem_reg_mullu; // @[Core.scala 181:38]
  reg [47:0] mem_reg_mulls; // @[Core.scala 182:38]
  reg [47:0] mem_reg_mulhuu; // @[Core.scala 183:38]
  reg [47:0] mem_reg_mulhss; // @[Core.scala 184:38]
  reg [47:0] mem_reg_mulhsu; // @[Core.scala 185:38]
  reg [4:0] mem_reg_exe_fun; // @[Core.scala 186:38]
  reg [1:0] mem_reg_mem_wen; // @[Core.scala 187:38]
  reg  mem_reg_rf_wen; // @[Core.scala 188:38]
  reg [2:0] mem_reg_wb_sel; // @[Core.scala 189:38]
  reg [11:0] mem_reg_csr_addr; // @[Core.scala 190:38]
  reg [2:0] mem_reg_csr_cmd; // @[Core.scala 191:38]
  reg [31:0] mem_reg_alu_out; // @[Core.scala 193:38]
  reg [31:0] mem_reg_pc_bit_out; // @[Core.scala 194:38]
  reg [31:0] mem_reg_mem_w; // @[Core.scala 196:38]
  reg [3:0] mem_reg_mem_wstrb; // @[Core.scala 197:38]
  reg  mem_reg_is_valid_inst; // @[Core.scala 198:38]
  reg  mem_reg_is_trap; // @[Core.scala 199:38]
  reg [31:0] mem_reg_mcause; // @[Core.scala 200:38]
  reg  mem_reg_divrem; // @[Core.scala 204:42]
  reg  mem_reg_sign_op1; // @[Core.scala 205:42]
  reg  mem_reg_sign_op12; // @[Core.scala 206:42]
  reg  mem_reg_zero_op2; // @[Core.scala 207:42]
  reg [36:0] mem_reg_init_dividend; // @[Core.scala 208:42]
  reg [31:0] mem_reg_init_divisor; // @[Core.scala 209:42]
  reg [31:0] mem_reg_orig_dividend; // @[Core.scala 210:42]
  reg [4:0] wb_reg_wb_addr; // @[Core.scala 213:38]
  reg  wb_reg_rf_wen; // @[Core.scala 214:38]
  reg [31:0] wb_reg_wb_data; // @[Core.scala 215:38]
  reg  wb_reg_is_valid_inst; // @[Core.scala 216:38]
  reg  if2_reg_is_bp_pos; // @[Core.scala 218:35]
  reg [31:0] if2_reg_bp_addr; // @[Core.scala 219:35]
  reg  mem_reg_div_stall; // @[Core.scala 224:35]
  reg [2:0] mem_reg_divrem_state; // @[Core.scala 225:37]
  reg  ex3_reg_is_br; // @[Core.scala 226:35]
  reg [31:0] ex3_reg_br_target; // @[Core.scala 227:35]
  reg  mem_reg_is_br; // @[Core.scala 230:35]
  reg [31:0] mem_reg_br_addr; // @[Core.scala 231:35]
  reg  ic_reg_read_rdy; // @[Core.scala 240:32]
  reg  ic_reg_half_rdy; // @[Core.scala 241:32]
  reg [31:0] ic_reg_imem_addr; // @[Core.scala 243:33]
  reg [31:0] ic_reg_addr_out; // @[Core.scala 244:32]
  reg [31:0] ic_reg_inst; // @[Core.scala 247:34]
  reg [31:0] ic_reg_inst_addr; // @[Core.scala 248:34]
  reg [31:0] ic_reg_inst2; // @[Core.scala 249:34]
  reg [31:0] ic_reg_inst2_addr; // @[Core.scala 250:34]
  reg [2:0] ic_state; // @[Core.scala 252:25]
  wire [31:0] ic_imem_addr_2 = {ic_reg_imem_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] ic_imem_addr_4 = ic_reg_imem_addr + 32'h4; // @[Core.scala 255:41]
  wire [31:0] ic_inst_addr_2 = {ic_reg_inst_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  reg  if1_reg_first; // @[Core.scala 362:30]
  wire [31:0] _if1_jump_addr_T = if1_reg_first ? 32'h8000000 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_1 = if2_reg_is_bp_pos ? if2_reg_bp_addr : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_2 = ex3_reg_is_br ? ex3_reg_br_target : _if1_jump_addr_T_1; // @[Mux.scala 101:16]
  wire [31:0] if1_jump_addr = mem_reg_is_br ? mem_reg_br_addr : _if1_jump_addr_T_2; // @[Mux.scala 101:16]
  wire [31:0] ic_next_imem_addr = {if1_jump_addr[31:2],2'h0}; // @[Cat.scala 31:58]
  wire  _ic_read_en4_T = ~id_reg_stall; // @[Core.scala 395:18]
  wire  _if1_is_jump_T = mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 376:35]
  wire  if1_is_jump = mem_reg_is_br | ex3_reg_is_br | if2_reg_is_bp_pos | if1_reg_first; // @[Core.scala 376:73]
  wire [30:0] _ic_data_out_T_2 = {15'h0,io_imem_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_5 = {io_imem_inst[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_8 = {ic_reg_inst2[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_27 = 3'h3 == ic_state ? _ic_data_out_T_8 : 32'h13; // @[Core.scala 261:15 276:23 337:21]
  wire [31:0] _GEN_34 = 3'h4 == ic_state ? _ic_data_out_T_5 : _GEN_27; // @[Core.scala 276:23 319:21]
  wire [31:0] _GEN_42 = 3'h2 == ic_state ? ic_reg_inst : _GEN_34; // @[Core.scala 276:23 307:21]
  wire [31:0] _GEN_54 = 3'h1 == ic_state ? {{1'd0}, _ic_data_out_T_2} : _GEN_42; // @[Core.scala 276:23 297:21]
  wire [31:0] _GEN_63 = 3'h0 == ic_state ? io_imem_inst : _GEN_54; // @[Core.scala 276:23 282:21]
  wire [31:0] _GEN_74 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? 32'h13 : _GEN_63; // @[Core.scala 261:15 272:94]
  wire [31:0] ic_data_out = if1_is_jump ? 32'h13 : _GEN_74; // @[Core.scala 261:15 265:21]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 393:41]
  wire  ic_read_en4 = ~id_reg_stall & ~is_half_inst; // @[Core.scala 395:32]
  wire [31:0] _GEN_0 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_addr_out; // @[Core.scala 262:15 287:34 288:23]
  wire [1:0] _GEN_1 = ic_read_en4 ? 2'h0 : 2'h2; // @[Core.scala 283:18 287:34 289:20]
  wire  ic_read_en2 = _ic_read_en4_T & is_half_inst; // @[Core.scala 394:32]
  wire [31:0] _GEN_2 = ic_read_en2 ? ic_imem_addr_2 : _GEN_0; // @[Core.scala 284:28 285:23]
  wire [2:0] _GEN_3 = ic_read_en2 ? 3'h4 : {{1'd0}, _GEN_1}; // @[Core.scala 284:28 286:20]
  wire [31:0] _GEN_4 = ic_read_en2 ? ic_imem_addr_4 : ic_imem_addr_2; // @[Core.scala 298:21 300:28 301:23]
  wire [2:0] _GEN_5 = ic_read_en2 ? 3'h0 : 3'h4; // @[Core.scala 299:18 300:28 302:20]
  wire [31:0] _GEN_6 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_addr_out; // @[Core.scala 262:15 311:33 312:23]
  wire [2:0] _GEN_7 = ic_read_en4 ? 3'h0 : ic_state; // @[Core.scala 311:33 313:20 252:25]
  wire [31:0] _GEN_8 = ic_read_en2 ? ic_inst_addr_2 : _GEN_6; // @[Core.scala 308:28 309:23]
  wire [2:0] _GEN_9 = ic_read_en2 ? 3'h4 : _GEN_7; // @[Core.scala 308:28 310:20]
  wire [31:0] _GEN_10 = ic_read_en4 ? io_imem_inst : ic_reg_inst; // @[Core.scala 328:33 329:23 247:34]
  wire [31:0] _GEN_11 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_inst_addr; // @[Core.scala 328:33 330:28 248:34]
  wire [31:0] _GEN_12 = ic_read_en4 ? ic_imem_addr_2 : ic_reg_addr_out; // @[Core.scala 262:15 328:33 331:23]
  wire [2:0] _GEN_13 = ic_read_en4 ? 3'h4 : 3'h3; // @[Core.scala 322:18 328:33 332:20]
  wire [31:0] _GEN_14 = ic_read_en2 ? io_imem_inst : _GEN_10; // @[Core.scala 323:28 324:23]
  wire [31:0] _GEN_15 = ic_read_en2 ? ic_reg_imem_addr : _GEN_11; // @[Core.scala 323:28 325:28]
  wire [31:0] _GEN_16 = ic_read_en2 ? ic_reg_imem_addr : _GEN_12; // @[Core.scala 323:28 326:23]
  wire [2:0] _GEN_17 = ic_read_en2 ? 3'h2 : _GEN_13; // @[Core.scala 323:28 327:20]
  wire [31:0] _ic_addr_out_T_3 = {ic_reg_inst2_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_18 = ic_read_en4 ? ic_reg_inst2 : ic_reg_inst; // @[Core.scala 343:33 344:23 247:34]
  wire [31:0] _GEN_19 = ic_read_en4 ? ic_reg_inst2_addr : ic_reg_inst_addr; // @[Core.scala 343:33 345:28 248:34]
  wire [31:0] _GEN_20 = ic_read_en4 ? _ic_addr_out_T_3 : ic_reg_addr_out; // @[Core.scala 262:15 343:33 346:23]
  wire [2:0] _GEN_21 = ic_read_en4 ? 3'h4 : ic_state; // @[Core.scala 343:33 347:20 252:25]
  wire [31:0] _GEN_22 = ic_read_en2 ? ic_reg_inst2 : _GEN_18; // @[Core.scala 338:28 339:23]
  wire [31:0] _GEN_23 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_19; // @[Core.scala 338:28 340:28]
  wire [31:0] _GEN_24 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_20; // @[Core.scala 338:28 341:23]
  wire [2:0] _GEN_25 = ic_read_en2 ? 3'h2 : _GEN_21; // @[Core.scala 338:28 342:20]
  wire [31:0] _GEN_28 = 3'h3 == ic_state ? _GEN_22 : ic_reg_inst; // @[Core.scala 276:23 247:34]
  wire [31:0] _GEN_29 = 3'h3 == ic_state ? _GEN_23 : ic_reg_inst_addr; // @[Core.scala 276:23 248:34]
  wire [31:0] _GEN_30 = 3'h3 == ic_state ? _GEN_24 : ic_reg_addr_out; // @[Core.scala 262:15 276:23]
  wire [2:0] _GEN_31 = 3'h3 == ic_state ? _GEN_25 : ic_state; // @[Core.scala 276:23 252:25]
  wire [31:0] _GEN_32 = 3'h4 == ic_state ? ic_imem_addr_4 : ic_reg_imem_addr; // @[Core.scala 276:23 317:22]
  wire [31:0] _GEN_35 = 3'h4 == ic_state ? io_imem_inst : ic_reg_inst2; // @[Core.scala 276:23 320:22 249:34]
  wire [31:0] _GEN_36 = 3'h4 == ic_state ? ic_reg_imem_addr : ic_reg_inst2_addr; // @[Core.scala 276:23 321:27 250:34]
  wire [2:0] _GEN_37 = 3'h4 == ic_state ? _GEN_17 : _GEN_31; // @[Core.scala 276:23]
  wire [31:0] _GEN_38 = 3'h4 == ic_state ? _GEN_14 : _GEN_28; // @[Core.scala 276:23]
  wire [31:0] _GEN_39 = 3'h4 == ic_state ? _GEN_15 : _GEN_29; // @[Core.scala 276:23]
  wire [31:0] _GEN_40 = 3'h4 == ic_state ? _GEN_16 : _GEN_30; // @[Core.scala 276:23]
  wire [31:0] _GEN_41 = 3'h2 == ic_state ? ic_reg_imem_addr : _GEN_32; // @[Core.scala 276:23 306:22]
  wire [31:0] _GEN_43 = 3'h2 == ic_state ? _GEN_8 : _GEN_40; // @[Core.scala 276:23]
  wire [2:0] _GEN_44 = 3'h2 == ic_state ? _GEN_9 : _GEN_37; // @[Core.scala 276:23]
  wire [31:0] _GEN_46 = 3'h2 == ic_state ? ic_reg_inst2 : _GEN_35; // @[Core.scala 276:23 249:34]
  wire [31:0] _GEN_47 = 3'h2 == ic_state ? ic_reg_inst2_addr : _GEN_36; // @[Core.scala 276:23 250:34]
  wire [31:0] _GEN_48 = 3'h2 == ic_state ? ic_reg_inst : _GEN_38; // @[Core.scala 276:23 247:34]
  wire [31:0] _GEN_49 = 3'h2 == ic_state ? ic_reg_inst_addr : _GEN_39; // @[Core.scala 276:23 248:34]
  wire [31:0] _GEN_50 = 3'h1 == ic_state ? ic_imem_addr_4 : _GEN_41; // @[Core.scala 276:23 293:22]
  wire [31:0] _GEN_52 = 3'h1 == ic_state ? io_imem_inst : _GEN_48; // @[Core.scala 276:23 295:21]
  wire [31:0] _GEN_53 = 3'h1 == ic_state ? ic_reg_imem_addr : _GEN_49; // @[Core.scala 276:23 296:26]
  wire [31:0] _GEN_55 = 3'h1 == ic_state ? _GEN_4 : _GEN_43; // @[Core.scala 276:23]
  wire [2:0] _GEN_56 = 3'h1 == ic_state ? _GEN_5 : _GEN_44; // @[Core.scala 276:23]
  wire [31:0] _GEN_57 = 3'h1 == ic_state ? ic_reg_inst2 : _GEN_46; // @[Core.scala 276:23 249:34]
  wire [31:0] _GEN_58 = 3'h1 == ic_state ? ic_reg_inst2_addr : _GEN_47; // @[Core.scala 276:23 250:34]
  wire [31:0] _GEN_59 = 3'h0 == ic_state ? ic_imem_addr_4 : _GEN_50; // @[Core.scala 276:23 278:22]
  wire [31:0] _GEN_65 = 3'h0 == ic_state ? _GEN_2 : _GEN_55; // @[Core.scala 276:23]
  wire  _GEN_69 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_half_rdy : 1'h1; // @[Core.scala 260:19 272:94 274:21]
  wire [31:0] _GEN_70 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_imem_addr : _GEN_59; // @[Core.scala 257:16 272:94]
  wire [31:0] _GEN_76 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_addr_out : _GEN_65; // @[Core.scala 262:15 272:94]
  wire  _GEN_84 = if1_is_jump | _GEN_69; // @[Core.scala 260:19 265:21]
  reg [31:0] if2_reg_pc; // @[Core.scala 389:29]
  reg [31:0] if2_reg_inst; // @[Core.scala 390:29]
  reg [1:0] if2_reg_inst_cnt; // @[Core.scala 391:33]
  wire  _if2_pc_T = ic_reg_half_rdy & is_half_inst; // @[Core.scala 396:74]
  wire [31:0] if2_pc = id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst) ? if2_reg_pc : ic_reg_addr_out
    ; // @[Core.scala 396:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_reg_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = if2_reg_is_bp_pos ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = id_reg_stall ? if2_reg_inst : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = mem_reg_is_br ? 32'h13 : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex3_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire  if2_is_cond_br_w = if2_inst[6:0] == 7'h63; // @[Core.scala 411:42]
  wire  _if2_is_cond_br_c_T_3 = if2_inst[1:0] == 2'h1; // @[Core.scala 412:70]
  wire  if2_is_cond_br_c = if2_inst[15:14] == 2'h3 & if2_inst[1:0] == 2'h1; // @[Core.scala 412:52]
  wire  if2_is_cond_br = if2_is_cond_br_w | if2_is_cond_br_c; // @[Core.scala 413:41]
  wire  if2_is_jal_w = if2_inst[6:0] == 7'h6f; // @[Core.scala 414:38]
  wire  if2_is_jal_c = if2_inst[14:13] == 2'h1 & _if2_is_cond_br_c_T_3; // @[Core.scala 415:48]
  wire  if2_is_jal = if2_is_jal_w | if2_is_jal_c; // @[Core.scala 416:33]
  wire  if2_is_jalr = if2_inst[6:0] == 7'h67 | if2_inst[15:13] == 3'h4 & if2_inst[6:0] == 7'h2; // @[Core.scala 417:50]
  wire  if2_is_bp_br = if2_is_cond_br | if2_is_jalr | if2_is_jal; // @[Core.scala 418:52]
  wire  _if2_is_bp_pos_T = if2_is_bp_br & bp_io_lu_br_pos; // @[Core.scala 421:19]
  wire  _if2_inst_cnt_T = ~ex3_reg_is_br; // @[Core.scala 429:26]
  wire  _if2_inst_cnt_T_1 = ~mem_reg_is_br; // @[Core.scala 429:44]
  wire [1:0] _if2_inst_cnt_T_5 = if2_reg_inst_cnt + 2'h1; // @[Core.scala 429:111]
  wire  _T_21 = ~reset; // @[Core.scala 432:9]
  reg  ex1_reg_hazard; // @[Core.scala 894:38]
  wire  _ex1_stall_T = ex1_reg_op1_sel == 3'h0; // @[Core.scala 909:23]
  wire  _ex1_stall_T_1 = ex1_reg_hazard & _ex1_stall_T; // @[Core.scala 908:21]
  wire  _ex1_stall_T_2 = ex1_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 910:24]
  wire  _ex1_stall_T_3 = _ex1_stall_T_1 & _ex1_stall_T_2; // @[Core.scala 909:36]
  wire  _ex1_stall_T_4 = ex1_reg_inst_cnt != ex2_reg_inst_cnt; // @[Core.scala 911:24]
  wire  _ex1_stall_T_5 = _ex1_stall_T_3 & _ex1_stall_T_4; // @[Core.scala 910:45]
  reg  ex2_reg_hazard; // @[Core.scala 897:38]
  wire  _ex1_stall_T_7 = ex2_reg_hazard & _ex1_stall_T; // @[Core.scala 912:21]
  wire  _ex1_stall_T_8 = ex1_reg_rs1_addr == mem_reg_wb_addr; // @[Core.scala 914:24]
  wire  _ex1_stall_T_9 = _ex1_stall_T_7 & _ex1_stall_T_8; // @[Core.scala 913:36]
  wire  _ex1_stall_T_10 = ex1_reg_inst_cnt != mem_reg_inst_cnt; // @[Core.scala 915:24]
  wire  _ex1_stall_T_11 = _ex1_stall_T_9 & _ex1_stall_T_10; // @[Core.scala 914:45]
  wire  _ex1_stall_T_12 = _ex1_stall_T_5 | _ex1_stall_T_11; // @[Core.scala 911:47]
  wire  _ex1_stall_T_13 = ex1_reg_op2_sel == 4'h1; // @[Core.scala 917:23]
  wire  _ex1_stall_T_15 = ex1_reg_op2_sel == 4'h1 | ex1_reg_mem_wen == 2'h1; // @[Core.scala 917:35]
  wire  _ex1_stall_T_16 = ex1_reg_hazard & _ex1_stall_T_15; // @[Core.scala 916:21]
  wire  _ex1_stall_T_17 = ex1_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 918:24]
  wire  _ex1_stall_T_18 = _ex1_stall_T_16 & _ex1_stall_T_17; // @[Core.scala 917:65]
  wire  _ex1_stall_T_20 = _ex1_stall_T_18 & _ex1_stall_T_4; // @[Core.scala 918:45]
  wire  _ex1_stall_T_21 = _ex1_stall_T_12 | _ex1_stall_T_20; // @[Core.scala 915:47]
  wire  _ex1_stall_T_25 = ex2_reg_hazard & _ex1_stall_T_15; // @[Core.scala 920:21]
  wire  _ex1_stall_T_26 = ex1_reg_rs2_addr == mem_reg_wb_addr; // @[Core.scala 922:24]
  wire  _ex1_stall_T_27 = _ex1_stall_T_25 & _ex1_stall_T_26; // @[Core.scala 921:65]
  wire  _ex1_stall_T_29 = _ex1_stall_T_27 & _ex1_stall_T_10; // @[Core.scala 922:45]
  wire  ex1_stall = _ex1_stall_T_21 | _ex1_stall_T_29; // @[Core.scala 919:47]
  wire  _mem_en_T_4 = ~mem_reg_is_trap; // @[Core.scala 1230:66]
  wire  _mem_is_meintr_T_2 = |io_intr; // @[Core.scala 1227:57]
  wire  _mem_is_valid_inst_T_2 = _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 1226:68]
  wire  mem_is_valid_inst = mem_reg_is_valid_inst & (_if2_inst_cnt_T_1 & _if2_inst_cnt_T); // @[Core.scala 1226:49]
  wire  mem_is_meintr = csr_mstatus[3] & (|io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1227:77]
  wire  _mem_en_T_6 = ~mem_is_meintr; // @[Core.scala 1230:86]
  wire  mem_is_mtintr = csr_mstatus[3] & (mtimer_io_intr & csr_mie[7]) & mem_is_valid_inst; // @[Core.scala 1228:79]
  wire  _mem_en_T_8 = ~mem_is_mtintr; // @[Core.scala 1230:104]
  wire  mem_en = mem_reg_en & _if2_inst_cnt_T_1 & _if2_inst_cnt_T & ~mem_reg_is_trap & ~mem_is_meintr & ~mem_is_mtintr; // @[Core.scala 1230:101]
  wire [2:0] mem_wb_sel = mem_en ? mem_reg_wb_sel : 3'h0; // @[Core.scala 1232:23]
  wire  _mem_stall_T = mem_wb_sel == 3'h6; // @[Core.scala 1243:29]
  reg  mem_stall_delay; // @[Core.scala 1235:32]
  wire [1:0] mem_mem_wen = mem_en ? mem_reg_mem_wen : 2'h0; // @[Core.scala 1234:24]
  wire  _mem_stall_T_4 = mem_mem_wen == 2'h1; // @[Core.scala 1244:19]
  wire  _mem_stall_T_6 = mem_mem_wen == 2'h1 & ~io_dmem_wready; // @[Core.scala 1244:30]
  wire  _mem_stall_T_7 = mem_wb_sel == 3'h6 & (~io_dmem_rvalid | mem_stall_delay) | _mem_stall_T_6; // @[Core.scala 1243:105]
  wire  _mem_stall_T_9 = mem_mem_wen == 2'h3 & io_icache_control_busy; // @[Core.scala 1245:34]
  wire  _mem_stall_T_10 = _mem_stall_T_7 | _mem_stall_T_9; // @[Core.scala 1244:50]
  wire  mem_stall = _mem_stall_T_10 | mem_reg_div_stall; // @[Core.scala 1245:61]
  wire  id_stall = ex1_stall | mem_stall; // @[Core.scala 453:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 457:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 459:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 461:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 462:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 463:30]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 467:18]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 470:18]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 474:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 31:58]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 31:58]
  wire  _id_c_rs1_data_T = id_w_wb_addr == 5'h0; // @[Core.scala 482:20]
  wire [31:0] id_c_rs1_data = _id_c_rs1_data_T ? 32'h0 : regfile_id_c_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_c_rs2_data_T = id_c_rs2_addr == 5'h0; // @[Core.scala 485:20]
  wire [31:0] id_c_rs2_data = _id_c_rs2_data_T ? 32'h0 : regfile_id_c_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 491:25]
  wire [19:0] _id_imm_i_sext_T_2 = id_imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_imm_i_sext = {_id_imm_i_sext_T_2,id_imm_i}; // @[Cat.scala 31:58]
  wire [11:0] id_imm_s = {id_inst[31:25],id_w_wb_addr}; // @[Cat.scala 31:58]
  wire [19:0] _id_imm_s_sext_T_2 = id_imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_imm_s_sext = {_id_imm_s_sext_T_2,id_inst[31:25],id_w_wb_addr}; // @[Cat.scala 31:58]
  wire [11:0] id_imm_b = {id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8]}; // @[Cat.scala 31:58]
  wire [18:0] _id_imm_b_sext_T_2 = id_imm_b[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_imm_b_sext = {_id_imm_b_sext_T_2,id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8],1'h0}; // @[Cat.scala 31:58]
  wire [19:0] id_imm_j = {id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21]}; // @[Cat.scala 31:58]
  wire [10:0] _id_imm_j_sext_T_2 = id_imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_imm_j_sext = {_id_imm_j_sext_T_2,id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 499:25]
  wire [31:0] id_imm_u_shifted = {id_imm_u,12'h0}; // @[Cat.scala 31:58]
  wire [31:0] id_imm_z_uext = {27'h0,id_rs1_addr}; // @[Cat.scala 31:58]
  wire [26:0] _id_c_imm_i_T_2 = id_inst[12] ? 27'h7ffffff : 27'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_c_imm_i = {_id_c_imm_i_T_2,id_c_rs2_addr}; // @[Cat.scala 31:58]
  wire [14:0] _id_c_imm_iu_T_2 = id_inst[12] ? 15'h7fff : 15'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_c_imm_iu = {_id_c_imm_iu_T_2,id_c_rs2_addr,12'h0}; // @[Cat.scala 31:58]
  wire [22:0] _id_c_imm_i16_T_2 = id_inst[12] ? 23'h7fffff : 23'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_c_imm_i16 = {_id_c_imm_i16_T_2,id_inst[4:3],id_inst[5],id_inst[2],id_inst[6],4'h0}; // @[Cat.scala 31:58]
  wire [31:0] id_c_imm_sl = {24'h0,id_inst[3:2],id_inst[12],id_inst[6:4],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] id_c_imm_ss = {24'h0,id_inst[8:7],id_inst[12:9],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] id_c_imm_iw = {22'h0,id_inst[10:7],id_inst[12:11],id_inst[5],id_inst[6],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] id_c_imm_ls = {25'h0,id_inst[5],id_inst[12:10],id_inst[6],2'h0}; // @[Cat.scala 31:58]
  wire [23:0] _id_c_imm_b_T_2 = id_inst[12] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_c_imm_b = {_id_c_imm_b_T_2,id_inst[6:5],id_inst[2],id_inst[11:10],id_inst[4:3],1'h0}; // @[Cat.scala 31:58]
  wire [20:0] _id_c_imm_j_T_2 = id_inst[12] ? 21'h1fffff : 21'h0; // @[Bitwise.scala 74:12]
  wire [31:0] id_c_imm_j = {_id_c_imm_j_T_2,id_inst[8],id_inst[10:9],id_inst[6],id_inst[7],id_inst[2],id_inst[11],
    id_inst[5:3],1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _csignals_T = id_inst & 32'h707f; // @[Lookup.scala 31:38]
  wire  _csignals_T_1 = 32'h3 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_3 = 32'h4003 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_5 = 32'h23 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_7 = 32'h1003 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_9 = 32'h5003 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_11 = 32'h1023 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_13 = 32'h2003 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_15 = 32'h2023 == _csignals_T; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_16 = id_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _csignals_T_17 = 32'h33 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_19 = 32'h13 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_21 = 32'h40000033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_23 = 32'h7033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_25 = 32'h6033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_27 = 32'h4033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_29 = 32'h7013 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_31 = 32'h6013 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_33 = 32'h4013 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_35 = 32'h1033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_37 = 32'h5033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_39 = 32'h40005033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_41 = 32'h1013 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_43 = 32'h5013 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_45 = 32'h40005013 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_47 = 32'h2033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_49 = 32'h3033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_51 = 32'h2013 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_53 = 32'h3013 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_55 = 32'h63 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_57 = 32'h1063 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_59 = 32'h5063 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_61 = 32'h7063 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_63 = 32'h4063 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_65 = 32'h6063 == _csignals_T; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_66 = id_inst & 32'h7f; // @[Lookup.scala 31:38]
  wire  _csignals_T_67 = 32'h6f == _csignals_T_66; // @[Lookup.scala 31:38]
  wire  _csignals_T_69 = 32'h67 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_71 = 32'h37 == _csignals_T_66; // @[Lookup.scala 31:38]
  wire  _csignals_T_73 = 32'h17 == _csignals_T_66; // @[Lookup.scala 31:38]
  wire  _csignals_T_75 = 32'h1073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_77 = 32'h5073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_79 = 32'h2073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_81 = 32'h6073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_83 = 32'h3073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_85 = 32'h7073 == _csignals_T; // @[Lookup.scala 31:38]
  wire  _csignals_T_87 = 32'h73 == id_inst; // @[Lookup.scala 31:38]
  wire  _csignals_T_89 = 32'h30200073 == id_inst; // @[Lookup.scala 31:38]
  wire  _csignals_T_91 = 32'h100f == id_inst; // @[Lookup.scala 31:38]
  wire  _csignals_T_93 = 32'h2000033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_95 = 32'h2001033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_97 = 32'h2003033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_99 = 32'h2002033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_101 = 32'h2004033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_103 = 32'h2005033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_105 = 32'h2006033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_107 = 32'h2007033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_109 = 32'ha006033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_111 = 32'ha007033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_113 = 32'ha004033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_115 = 32'ha005033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_116 = id_inst & 32'hfff0707f; // @[Lookup.scala 31:38]
  wire  _csignals_T_117 = 32'h60001013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_119 = 32'h60101013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_121 = 32'h60201013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_123 = 32'h69805013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_125 = 32'h60401013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_127 = 32'h60501013 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_129 = 32'h8004033 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_131 = 32'h40007033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_133 = 32'h40006033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_135 = 32'h40004033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_136 = id_inst & 32'hffff; // @[Lookup.scala 31:38]
  wire  _csignals_T_137 = 32'h0 == _csignals_T_136; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_138 = id_inst & 32'he003; // @[Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'h0 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_140 = id_inst & 32'hef83; // @[Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h6101 == _csignals_T_140; // @[Lookup.scala 31:38]
  wire  _csignals_T_143 = 32'h1 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_145 = 32'h4000 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_147 = 32'hc000 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_149 = 32'h4001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_151 = 32'h6001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_152 = id_inst & 32'hec03; // @[Lookup.scala 31:38]
  wire  _csignals_T_153 = 32'h8401 == _csignals_T_152; // @[Lookup.scala 31:38]
  wire  _csignals_T_155 = 32'h8001 == _csignals_T_152; // @[Lookup.scala 31:38]
  wire  _csignals_T_157 = 32'h8801 == _csignals_T_152; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_158 = id_inst & 32'hfc63; // @[Lookup.scala 31:38]
  wire  _csignals_T_159 = 32'h8c01 == _csignals_T_158; // @[Lookup.scala 31:38]
  wire  _csignals_T_161 = 32'h8c21 == _csignals_T_158; // @[Lookup.scala 31:38]
  wire  _csignals_T_163 = 32'h8c41 == _csignals_T_158; // @[Lookup.scala 31:38]
  wire  _csignals_T_165 = 32'h8c61 == _csignals_T_158; // @[Lookup.scala 31:38]
  wire  _csignals_T_167 = 32'h2 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_169 = 32'ha001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_171 = 32'hc001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_173 = 32'he001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_174 = id_inst & 32'hf07f; // @[Lookup.scala 31:38]
  wire  _csignals_T_175 = 32'h8002 == _csignals_T_174; // @[Lookup.scala 31:38]
  wire  _csignals_T_177 = 32'h9002 == _csignals_T_174; // @[Lookup.scala 31:38]
  wire  _csignals_T_179 = 32'h2001 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_181 = 32'h4002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_183 = 32'hc002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_184 = id_inst & 32'hf003; // @[Lookup.scala 31:38]
  wire  _csignals_T_185 = 32'h8002 == _csignals_T_184; // @[Lookup.scala 31:38]
  wire  _csignals_T_187 = 32'h9002 == _csignals_T_184; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_195 = _csignals_T_173 ? 5'h13 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_196 = _csignals_T_171 ? 5'h12 : _csignals_T_195; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_197 = _csignals_T_169 ? 5'h0 : _csignals_T_196; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_198 = _csignals_T_167 ? 5'h5 : _csignals_T_197; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_199 = _csignals_T_165 ? 5'h3 : _csignals_T_198; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_200 = _csignals_T_163 ? 5'h4 : _csignals_T_199; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_201 = _csignals_T_161 ? 5'h2 : _csignals_T_200; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_202 = _csignals_T_159 ? 5'h1 : _csignals_T_201; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_203 = _csignals_T_157 ? 5'h3 : _csignals_T_202; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_204 = _csignals_T_155 ? 5'h6 : _csignals_T_203; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_205 = _csignals_T_153 ? 5'h7 : _csignals_T_204; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_206 = _csignals_T_151 ? 5'h0 : _csignals_T_205; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_207 = _csignals_T_149 ? 5'h0 : _csignals_T_206; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_208 = _csignals_T_147 ? 5'h0 : _csignals_T_207; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_209 = _csignals_T_145 ? 5'h0 : _csignals_T_208; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_210 = _csignals_T_143 ? 5'h0 : _csignals_T_209; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_211 = _csignals_T_141 ? 5'h0 : _csignals_T_210; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_212 = _csignals_T_139 ? 5'h0 : _csignals_T_211; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_213 = _csignals_T_137 ? 5'h0 : _csignals_T_212; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_214 = _csignals_T_135 ? 5'he : _csignals_T_213; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_215 = _csignals_T_133 ? 5'h10 : _csignals_T_214; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_216 = _csignals_T_131 ? 5'hf : _csignals_T_215; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_217 = _csignals_T_129 ? 5'hb : _csignals_T_216; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_218 = _csignals_T_127 ? 5'ha : _csignals_T_217; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_219 = _csignals_T_125 ? 5'h9 : _csignals_T_218; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_220 = _csignals_T_123 ? 5'h8 : _csignals_T_219; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_221 = _csignals_T_121 ? 5'h7 : _csignals_T_220; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_222 = _csignals_T_119 ? 5'h6 : _csignals_T_221; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_223 = _csignals_T_117 ? 5'h5 : _csignals_T_222; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_224 = _csignals_T_115 ? 5'hd : _csignals_T_223; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_225 = _csignals_T_113 ? 5'hc : _csignals_T_224; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_226 = _csignals_T_111 ? 5'hb : _csignals_T_225; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_227 = _csignals_T_109 ? 5'ha : _csignals_T_226; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_228 = _csignals_T_107 ? 5'h1f : _csignals_T_227; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_229 = _csignals_T_105 ? 5'h1d : _csignals_T_228; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_230 = _csignals_T_103 ? 5'h1e : _csignals_T_229; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_231 = _csignals_T_101 ? 5'h1c : _csignals_T_230; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_232 = _csignals_T_99 ? 5'h1b : _csignals_T_231; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_233 = _csignals_T_97 ? 5'h1a : _csignals_T_232; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_234 = _csignals_T_95 ? 5'h19 : _csignals_T_233; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_235 = _csignals_T_93 ? 5'h18 : _csignals_T_234; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_236 = _csignals_T_91 ? 5'h0 : _csignals_T_235; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_237 = _csignals_T_89 ? 5'h0 : _csignals_T_236; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_238 = _csignals_T_87 ? 5'h0 : _csignals_T_237; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_239 = _csignals_T_85 ? 5'h0 : _csignals_T_238; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_240 = _csignals_T_83 ? 5'h0 : _csignals_T_239; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_241 = _csignals_T_81 ? 5'h0 : _csignals_T_240; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_242 = _csignals_T_79 ? 5'h0 : _csignals_T_241; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_243 = _csignals_T_77 ? 5'h0 : _csignals_T_242; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_244 = _csignals_T_75 ? 5'h0 : _csignals_T_243; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_245 = _csignals_T_73 ? 5'h0 : _csignals_T_244; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_246 = _csignals_T_71 ? 5'h0 : _csignals_T_245; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_247 = _csignals_T_69 ? 5'h0 : _csignals_T_246; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_248 = _csignals_T_67 ? 5'h0 : _csignals_T_247; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_249 = _csignals_T_65 ? 5'h16 : _csignals_T_248; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_250 = _csignals_T_63 ? 5'h14 : _csignals_T_249; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_251 = _csignals_T_61 ? 5'h17 : _csignals_T_250; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_252 = _csignals_T_59 ? 5'h15 : _csignals_T_251; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_253 = _csignals_T_57 ? 5'h13 : _csignals_T_252; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_254 = _csignals_T_55 ? 5'h12 : _csignals_T_253; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_255 = _csignals_T_53 ? 5'h9 : _csignals_T_254; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_256 = _csignals_T_51 ? 5'h8 : _csignals_T_255; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_257 = _csignals_T_49 ? 5'h9 : _csignals_T_256; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_258 = _csignals_T_47 ? 5'h8 : _csignals_T_257; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_259 = _csignals_T_45 ? 5'h7 : _csignals_T_258; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_260 = _csignals_T_43 ? 5'h6 : _csignals_T_259; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_261 = _csignals_T_41 ? 5'h5 : _csignals_T_260; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_262 = _csignals_T_39 ? 5'h7 : _csignals_T_261; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_263 = _csignals_T_37 ? 5'h6 : _csignals_T_262; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_264 = _csignals_T_35 ? 5'h5 : _csignals_T_263; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_265 = _csignals_T_33 ? 5'h2 : _csignals_T_264; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_266 = _csignals_T_31 ? 5'h4 : _csignals_T_265; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_267 = _csignals_T_29 ? 5'h3 : _csignals_T_266; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_268 = _csignals_T_27 ? 5'h2 : _csignals_T_267; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_269 = _csignals_T_25 ? 5'h4 : _csignals_T_268; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_270 = _csignals_T_23 ? 5'h3 : _csignals_T_269; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_271 = _csignals_T_21 ? 5'h1 : _csignals_T_270; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_272 = _csignals_T_19 ? 5'h0 : _csignals_T_271; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_273 = _csignals_T_17 ? 5'h0 : _csignals_T_272; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_274 = _csignals_T_15 ? 5'h0 : _csignals_T_273; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_275 = _csignals_T_13 ? 5'h0 : _csignals_T_274; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_276 = _csignals_T_11 ? 5'h0 : _csignals_T_275; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_277 = _csignals_T_9 ? 5'h0 : _csignals_T_276; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_278 = _csignals_T_7 ? 5'h0 : _csignals_T_277; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_279 = _csignals_T_5 ? 5'h0 : _csignals_T_278; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_280 = _csignals_T_3 ? 5'h0 : _csignals_T_279; // @[Lookup.scala 34:39]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h0 : _csignals_T_280; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_281 = _csignals_T_187 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_282 = _csignals_T_185 ? 3'h2 : _csignals_T_281; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_283 = _csignals_T_183 ? 3'h5 : _csignals_T_282; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_284 = _csignals_T_181 ? 3'h5 : _csignals_T_283; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_285 = _csignals_T_179 ? 3'h1 : _csignals_T_284; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_286 = _csignals_T_177 ? 3'h4 : _csignals_T_285; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_287 = _csignals_T_175 ? 3'h4 : _csignals_T_286; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_288 = _csignals_T_173 ? 3'h6 : _csignals_T_287; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_289 = _csignals_T_171 ? 3'h6 : _csignals_T_288; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_290 = _csignals_T_169 ? 3'h1 : _csignals_T_289; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_291 = _csignals_T_167 ? 3'h4 : _csignals_T_290; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_292 = _csignals_T_165 ? 3'h6 : _csignals_T_291; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_293 = _csignals_T_163 ? 3'h6 : _csignals_T_292; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_294 = _csignals_T_161 ? 3'h6 : _csignals_T_293; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_295 = _csignals_T_159 ? 3'h6 : _csignals_T_294; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_296 = _csignals_T_157 ? 3'h6 : _csignals_T_295; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_297 = _csignals_T_155 ? 3'h6 : _csignals_T_296; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_298 = _csignals_T_153 ? 3'h6 : _csignals_T_297; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_299 = _csignals_T_151 ? 3'h2 : _csignals_T_298; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_300 = _csignals_T_149 ? 3'h2 : _csignals_T_299; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_301 = _csignals_T_147 ? 3'h6 : _csignals_T_300; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_302 = _csignals_T_145 ? 3'h6 : _csignals_T_301; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_303 = _csignals_T_143 ? 3'h4 : _csignals_T_302; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_304 = _csignals_T_141 ? 3'h4 : _csignals_T_303; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_305 = _csignals_T_139 ? 3'h5 : _csignals_T_304; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_306 = _csignals_T_137 ? 3'h2 : _csignals_T_305; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_307 = _csignals_T_135 ? 3'h0 : _csignals_T_306; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_308 = _csignals_T_133 ? 3'h0 : _csignals_T_307; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_309 = _csignals_T_131 ? 3'h0 : _csignals_T_308; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_310 = _csignals_T_129 ? 3'h0 : _csignals_T_309; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_311 = _csignals_T_127 ? 3'h0 : _csignals_T_310; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_312 = _csignals_T_125 ? 3'h0 : _csignals_T_311; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_313 = _csignals_T_123 ? 3'h0 : _csignals_T_312; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_314 = _csignals_T_121 ? 3'h0 : _csignals_T_313; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_315 = _csignals_T_119 ? 3'h0 : _csignals_T_314; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_316 = _csignals_T_117 ? 3'h0 : _csignals_T_315; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_317 = _csignals_T_115 ? 3'h0 : _csignals_T_316; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_318 = _csignals_T_113 ? 3'h0 : _csignals_T_317; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_319 = _csignals_T_111 ? 3'h0 : _csignals_T_318; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_320 = _csignals_T_109 ? 3'h0 : _csignals_T_319; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_321 = _csignals_T_107 ? 3'h0 : _csignals_T_320; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_322 = _csignals_T_105 ? 3'h0 : _csignals_T_321; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_323 = _csignals_T_103 ? 3'h0 : _csignals_T_322; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_324 = _csignals_T_101 ? 3'h0 : _csignals_T_323; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_325 = _csignals_T_99 ? 3'h0 : _csignals_T_324; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_326 = _csignals_T_97 ? 3'h0 : _csignals_T_325; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_327 = _csignals_T_95 ? 3'h0 : _csignals_T_326; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_328 = _csignals_T_93 ? 3'h0 : _csignals_T_327; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_329 = _csignals_T_91 ? 3'h2 : _csignals_T_328; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_330 = _csignals_T_89 ? 3'h2 : _csignals_T_329; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_331 = _csignals_T_87 ? 3'h2 : _csignals_T_330; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_332 = _csignals_T_85 ? 3'h3 : _csignals_T_331; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_333 = _csignals_T_83 ? 3'h0 : _csignals_T_332; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_334 = _csignals_T_81 ? 3'h3 : _csignals_T_333; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_335 = _csignals_T_79 ? 3'h0 : _csignals_T_334; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_336 = _csignals_T_77 ? 3'h3 : _csignals_T_335; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_337 = _csignals_T_75 ? 3'h0 : _csignals_T_336; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_338 = _csignals_T_73 ? 3'h1 : _csignals_T_337; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_339 = _csignals_T_71 ? 3'h2 : _csignals_T_338; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_340 = _csignals_T_69 ? 3'h0 : _csignals_T_339; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_341 = _csignals_T_67 ? 3'h1 : _csignals_T_340; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_342 = _csignals_T_65 ? 3'h0 : _csignals_T_341; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_343 = _csignals_T_63 ? 3'h0 : _csignals_T_342; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_344 = _csignals_T_61 ? 3'h0 : _csignals_T_343; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_345 = _csignals_T_59 ? 3'h0 : _csignals_T_344; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_346 = _csignals_T_57 ? 3'h0 : _csignals_T_345; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_347 = _csignals_T_55 ? 3'h0 : _csignals_T_346; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_348 = _csignals_T_53 ? 3'h0 : _csignals_T_347; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_349 = _csignals_T_51 ? 3'h0 : _csignals_T_348; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_350 = _csignals_T_49 ? 3'h0 : _csignals_T_349; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_351 = _csignals_T_47 ? 3'h0 : _csignals_T_350; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_352 = _csignals_T_45 ? 3'h0 : _csignals_T_351; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_353 = _csignals_T_43 ? 3'h0 : _csignals_T_352; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_354 = _csignals_T_41 ? 3'h0 : _csignals_T_353; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_355 = _csignals_T_39 ? 3'h0 : _csignals_T_354; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_356 = _csignals_T_37 ? 3'h0 : _csignals_T_355; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_357 = _csignals_T_35 ? 3'h0 : _csignals_T_356; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_358 = _csignals_T_33 ? 3'h0 : _csignals_T_357; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_359 = _csignals_T_31 ? 3'h0 : _csignals_T_358; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_360 = _csignals_T_29 ? 3'h0 : _csignals_T_359; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_361 = _csignals_T_27 ? 3'h0 : _csignals_T_360; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_362 = _csignals_T_25 ? 3'h0 : _csignals_T_361; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_363 = _csignals_T_23 ? 3'h0 : _csignals_T_362; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_364 = _csignals_T_21 ? 3'h0 : _csignals_T_363; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_365 = _csignals_T_19 ? 3'h0 : _csignals_T_364; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_366 = _csignals_T_17 ? 3'h0 : _csignals_T_365; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_367 = _csignals_T_15 ? 3'h0 : _csignals_T_366; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_368 = _csignals_T_13 ? 3'h0 : _csignals_T_367; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_369 = _csignals_T_11 ? 3'h0 : _csignals_T_368; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_370 = _csignals_T_9 ? 3'h0 : _csignals_T_369; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_371 = _csignals_T_7 ? 3'h0 : _csignals_T_370; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_372 = _csignals_T_5 ? 3'h0 : _csignals_T_371; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_373 = _csignals_T_3 ? 3'h0 : _csignals_T_372; // @[Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h0 : _csignals_T_373; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_374 = _csignals_T_187 ? 4'h6 : 4'h1; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_375 = _csignals_T_185 ? 4'h6 : _csignals_T_374; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_376 = _csignals_T_183 ? 4'hf : _csignals_T_375; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_377 = _csignals_T_181 ? 4'he : _csignals_T_376; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_378 = _csignals_T_179 ? 4'hd : _csignals_T_377; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_379 = _csignals_T_177 ? 4'h0 : _csignals_T_378; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_380 = _csignals_T_175 ? 4'h0 : _csignals_T_379; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_381 = _csignals_T_173 ? 4'h0 : _csignals_T_380; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_382 = _csignals_T_171 ? 4'h0 : _csignals_T_381; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_383 = _csignals_T_169 ? 4'hd : _csignals_T_382; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_384 = _csignals_T_167 ? 4'ha : _csignals_T_383; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_385 = _csignals_T_165 ? 4'h7 : _csignals_T_384; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_386 = _csignals_T_163 ? 4'h7 : _csignals_T_385; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_387 = _csignals_T_161 ? 4'h7 : _csignals_T_386; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_388 = _csignals_T_159 ? 4'h7 : _csignals_T_387; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_389 = _csignals_T_157 ? 4'ha : _csignals_T_388; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_390 = _csignals_T_155 ? 4'ha : _csignals_T_389; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_391 = _csignals_T_153 ? 4'ha : _csignals_T_390; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_392 = _csignals_T_151 ? 4'hc : _csignals_T_391; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_393 = _csignals_T_149 ? 4'ha : _csignals_T_392; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_394 = _csignals_T_147 ? 4'hb : _csignals_T_393; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_395 = _csignals_T_145 ? 4'hb : _csignals_T_394; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_396 = _csignals_T_143 ? 4'ha : _csignals_T_395; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_397 = _csignals_T_141 ? 4'h9 : _csignals_T_396; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_398 = _csignals_T_139 ? 4'h8 : _csignals_T_397; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_399 = _csignals_T_137 ? 4'h0 : _csignals_T_398; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_400 = _csignals_T_135 ? 4'h1 : _csignals_T_399; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_401 = _csignals_T_133 ? 4'h1 : _csignals_T_400; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_402 = _csignals_T_131 ? 4'h1 : _csignals_T_401; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_403 = _csignals_T_129 ? 4'h0 : _csignals_T_402; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_404 = _csignals_T_127 ? 4'h0 : _csignals_T_403; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_405 = _csignals_T_125 ? 4'h0 : _csignals_T_404; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_406 = _csignals_T_123 ? 4'h0 : _csignals_T_405; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_407 = _csignals_T_121 ? 4'h0 : _csignals_T_406; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_408 = _csignals_T_119 ? 4'h0 : _csignals_T_407; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_409 = _csignals_T_117 ? 4'h0 : _csignals_T_408; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_410 = _csignals_T_115 ? 4'h1 : _csignals_T_409; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_411 = _csignals_T_113 ? 4'h1 : _csignals_T_410; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_412 = _csignals_T_111 ? 4'h1 : _csignals_T_411; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_413 = _csignals_T_109 ? 4'h1 : _csignals_T_412; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_414 = _csignals_T_107 ? 4'h1 : _csignals_T_413; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_415 = _csignals_T_105 ? 4'h1 : _csignals_T_414; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_416 = _csignals_T_103 ? 4'h1 : _csignals_T_415; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_417 = _csignals_T_101 ? 4'h1 : _csignals_T_416; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_418 = _csignals_T_99 ? 4'h1 : _csignals_T_417; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_419 = _csignals_T_97 ? 4'h1 : _csignals_T_418; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_420 = _csignals_T_95 ? 4'h1 : _csignals_T_419; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_421 = _csignals_T_93 ? 4'h1 : _csignals_T_420; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_422 = _csignals_T_91 ? 4'h0 : _csignals_T_421; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_423 = _csignals_T_89 ? 4'h0 : _csignals_T_422; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_424 = _csignals_T_87 ? 4'h0 : _csignals_T_423; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_425 = _csignals_T_85 ? 4'h0 : _csignals_T_424; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_426 = _csignals_T_83 ? 4'h0 : _csignals_T_425; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_427 = _csignals_T_81 ? 4'h0 : _csignals_T_426; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_428 = _csignals_T_79 ? 4'h0 : _csignals_T_427; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_429 = _csignals_T_77 ? 4'h0 : _csignals_T_428; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_430 = _csignals_T_75 ? 4'h0 : _csignals_T_429; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_431 = _csignals_T_73 ? 4'h5 : _csignals_T_430; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_432 = _csignals_T_71 ? 4'h5 : _csignals_T_431; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_433 = _csignals_T_69 ? 4'h2 : _csignals_T_432; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_434 = _csignals_T_67 ? 4'h4 : _csignals_T_433; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_435 = _csignals_T_65 ? 4'h1 : _csignals_T_434; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_436 = _csignals_T_63 ? 4'h1 : _csignals_T_435; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_437 = _csignals_T_61 ? 4'h1 : _csignals_T_436; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_438 = _csignals_T_59 ? 4'h1 : _csignals_T_437; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_439 = _csignals_T_57 ? 4'h1 : _csignals_T_438; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_440 = _csignals_T_55 ? 4'h1 : _csignals_T_439; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_441 = _csignals_T_53 ? 4'h2 : _csignals_T_440; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_442 = _csignals_T_51 ? 4'h2 : _csignals_T_441; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_443 = _csignals_T_49 ? 4'h1 : _csignals_T_442; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_444 = _csignals_T_47 ? 4'h1 : _csignals_T_443; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_445 = _csignals_T_45 ? 4'h2 : _csignals_T_444; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_446 = _csignals_T_43 ? 4'h2 : _csignals_T_445; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_447 = _csignals_T_41 ? 4'h2 : _csignals_T_446; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_448 = _csignals_T_39 ? 4'h1 : _csignals_T_447; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_449 = _csignals_T_37 ? 4'h1 : _csignals_T_448; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_450 = _csignals_T_35 ? 4'h1 : _csignals_T_449; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_451 = _csignals_T_33 ? 4'h2 : _csignals_T_450; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_452 = _csignals_T_31 ? 4'h2 : _csignals_T_451; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_453 = _csignals_T_29 ? 4'h2 : _csignals_T_452; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_454 = _csignals_T_27 ? 4'h1 : _csignals_T_453; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_455 = _csignals_T_25 ? 4'h1 : _csignals_T_454; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_456 = _csignals_T_23 ? 4'h1 : _csignals_T_455; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_457 = _csignals_T_21 ? 4'h1 : _csignals_T_456; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_458 = _csignals_T_19 ? 4'h2 : _csignals_T_457; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_459 = _csignals_T_17 ? 4'h1 : _csignals_T_458; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_460 = _csignals_T_15 ? 4'h3 : _csignals_T_459; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_461 = _csignals_T_13 ? 4'h2 : _csignals_T_460; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_462 = _csignals_T_11 ? 4'h3 : _csignals_T_461; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_463 = _csignals_T_9 ? 4'h2 : _csignals_T_462; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_464 = _csignals_T_7 ? 4'h2 : _csignals_T_463; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_465 = _csignals_T_5 ? 4'h3 : _csignals_T_464; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_466 = _csignals_T_3 ? 4'h2 : _csignals_T_465; // @[Lookup.scala 34:39]
  wire [3:0] csignals_2 = _csignals_T_1 ? 4'h2 : _csignals_T_466; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_469 = _csignals_T_183 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_470 = _csignals_T_181 ? 2'h0 : _csignals_T_469; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_471 = _csignals_T_179 ? 2'h0 : _csignals_T_470; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_472 = _csignals_T_177 ? 2'h0 : _csignals_T_471; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_473 = _csignals_T_175 ? 2'h0 : _csignals_T_472; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_474 = _csignals_T_173 ? 2'h0 : _csignals_T_473; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_475 = _csignals_T_171 ? 2'h0 : _csignals_T_474; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_476 = _csignals_T_169 ? 2'h0 : _csignals_T_475; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_477 = _csignals_T_167 ? 2'h0 : _csignals_T_476; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_478 = _csignals_T_165 ? 2'h0 : _csignals_T_477; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_479 = _csignals_T_163 ? 2'h0 : _csignals_T_478; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_480 = _csignals_T_161 ? 2'h0 : _csignals_T_479; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_481 = _csignals_T_159 ? 2'h0 : _csignals_T_480; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_482 = _csignals_T_157 ? 2'h0 : _csignals_T_481; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_483 = _csignals_T_155 ? 2'h0 : _csignals_T_482; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_484 = _csignals_T_153 ? 2'h0 : _csignals_T_483; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_485 = _csignals_T_151 ? 2'h0 : _csignals_T_484; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_486 = _csignals_T_149 ? 2'h0 : _csignals_T_485; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_487 = _csignals_T_147 ? 2'h1 : _csignals_T_486; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_488 = _csignals_T_145 ? 2'h0 : _csignals_T_487; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_489 = _csignals_T_143 ? 2'h0 : _csignals_T_488; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_490 = _csignals_T_141 ? 2'h0 : _csignals_T_489; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_491 = _csignals_T_139 ? 2'h0 : _csignals_T_490; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_492 = _csignals_T_137 ? 2'h0 : _csignals_T_491; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_493 = _csignals_T_135 ? 2'h0 : _csignals_T_492; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_494 = _csignals_T_133 ? 2'h0 : _csignals_T_493; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_495 = _csignals_T_131 ? 2'h0 : _csignals_T_494; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_496 = _csignals_T_129 ? 2'h0 : _csignals_T_495; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_497 = _csignals_T_127 ? 2'h0 : _csignals_T_496; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_498 = _csignals_T_125 ? 2'h0 : _csignals_T_497; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_499 = _csignals_T_123 ? 2'h0 : _csignals_T_498; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_500 = _csignals_T_121 ? 2'h0 : _csignals_T_499; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_501 = _csignals_T_119 ? 2'h0 : _csignals_T_500; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_502 = _csignals_T_117 ? 2'h0 : _csignals_T_501; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_503 = _csignals_T_115 ? 2'h0 : _csignals_T_502; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_504 = _csignals_T_113 ? 2'h0 : _csignals_T_503; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_505 = _csignals_T_111 ? 2'h0 : _csignals_T_504; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_506 = _csignals_T_109 ? 2'h0 : _csignals_T_505; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_507 = _csignals_T_107 ? 2'h0 : _csignals_T_506; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_508 = _csignals_T_105 ? 2'h0 : _csignals_T_507; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_509 = _csignals_T_103 ? 2'h0 : _csignals_T_508; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_510 = _csignals_T_101 ? 2'h0 : _csignals_T_509; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_511 = _csignals_T_99 ? 2'h0 : _csignals_T_510; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_512 = _csignals_T_97 ? 2'h0 : _csignals_T_511; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_513 = _csignals_T_95 ? 2'h0 : _csignals_T_512; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_514 = _csignals_T_93 ? 2'h0 : _csignals_T_513; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_515 = _csignals_T_91 ? 2'h3 : _csignals_T_514; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_516 = _csignals_T_89 ? 2'h0 : _csignals_T_515; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_517 = _csignals_T_87 ? 2'h0 : _csignals_T_516; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_518 = _csignals_T_85 ? 2'h0 : _csignals_T_517; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_519 = _csignals_T_83 ? 2'h0 : _csignals_T_518; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_520 = _csignals_T_81 ? 2'h0 : _csignals_T_519; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_521 = _csignals_T_79 ? 2'h0 : _csignals_T_520; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_522 = _csignals_T_77 ? 2'h0 : _csignals_T_521; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_523 = _csignals_T_75 ? 2'h0 : _csignals_T_522; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_524 = _csignals_T_73 ? 2'h0 : _csignals_T_523; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_525 = _csignals_T_71 ? 2'h0 : _csignals_T_524; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_526 = _csignals_T_69 ? 2'h0 : _csignals_T_525; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_527 = _csignals_T_67 ? 2'h0 : _csignals_T_526; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_528 = _csignals_T_65 ? 2'h0 : _csignals_T_527; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_529 = _csignals_T_63 ? 2'h0 : _csignals_T_528; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_530 = _csignals_T_61 ? 2'h0 : _csignals_T_529; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_531 = _csignals_T_59 ? 2'h0 : _csignals_T_530; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_532 = _csignals_T_57 ? 2'h0 : _csignals_T_531; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_533 = _csignals_T_55 ? 2'h0 : _csignals_T_532; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_534 = _csignals_T_53 ? 2'h0 : _csignals_T_533; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_535 = _csignals_T_51 ? 2'h0 : _csignals_T_534; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_536 = _csignals_T_49 ? 2'h0 : _csignals_T_535; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_537 = _csignals_T_47 ? 2'h0 : _csignals_T_536; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_538 = _csignals_T_45 ? 2'h0 : _csignals_T_537; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_539 = _csignals_T_43 ? 2'h0 : _csignals_T_538; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_540 = _csignals_T_41 ? 2'h0 : _csignals_T_539; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_541 = _csignals_T_39 ? 2'h0 : _csignals_T_540; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_542 = _csignals_T_37 ? 2'h0 : _csignals_T_541; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_543 = _csignals_T_35 ? 2'h0 : _csignals_T_542; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_544 = _csignals_T_33 ? 2'h0 : _csignals_T_543; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_545 = _csignals_T_31 ? 2'h0 : _csignals_T_544; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_546 = _csignals_T_29 ? 2'h0 : _csignals_T_545; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_547 = _csignals_T_27 ? 2'h0 : _csignals_T_546; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_548 = _csignals_T_25 ? 2'h0 : _csignals_T_547; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_549 = _csignals_T_23 ? 2'h0 : _csignals_T_548; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_550 = _csignals_T_21 ? 2'h0 : _csignals_T_549; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_551 = _csignals_T_19 ? 2'h0 : _csignals_T_550; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_552 = _csignals_T_17 ? 2'h0 : _csignals_T_551; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_553 = _csignals_T_15 ? 2'h1 : _csignals_T_552; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_554 = _csignals_T_13 ? 2'h0 : _csignals_T_553; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_555 = _csignals_T_11 ? 2'h1 : _csignals_T_554; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_556 = _csignals_T_9 ? 2'h0 : _csignals_T_555; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_557 = _csignals_T_7 ? 2'h0 : _csignals_T_556; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_558 = _csignals_T_5 ? 2'h1 : _csignals_T_557; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_559 = _csignals_T_3 ? 2'h0 : _csignals_T_558; // @[Lookup.scala 34:39]
  wire [1:0] csignals_3 = _csignals_T_1 ? 2'h0 : _csignals_T_559; // @[Lookup.scala 34:39]
  wire  _csignals_T_562 = _csignals_T_183 ? 1'h0 : _csignals_T_185 | _csignals_T_187; // @[Lookup.scala 34:39]
  wire  _csignals_T_566 = _csignals_T_175 ? 1'h0 : _csignals_T_177 | (_csignals_T_179 | (_csignals_T_181 |
    _csignals_T_562)); // @[Lookup.scala 34:39]
  wire  _csignals_T_567 = _csignals_T_173 ? 1'h0 : _csignals_T_566; // @[Lookup.scala 34:39]
  wire  _csignals_T_568 = _csignals_T_171 ? 1'h0 : _csignals_T_567; // @[Lookup.scala 34:39]
  wire  _csignals_T_569 = _csignals_T_169 ? 1'h0 : _csignals_T_568; // @[Lookup.scala 34:39]
  wire  _csignals_T_580 = _csignals_T_147 ? 1'h0 : _csignals_T_149 | (_csignals_T_151 | (_csignals_T_153 | (
    _csignals_T_155 | (_csignals_T_157 | (_csignals_T_159 | (_csignals_T_161 | (_csignals_T_163 | (_csignals_T_165 | (
    _csignals_T_167 | _csignals_T_569))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_585 = _csignals_T_137 ? 1'h0 : _csignals_T_139 | (_csignals_T_141 | (_csignals_T_143 | (
    _csignals_T_145 | _csignals_T_580))); // @[Lookup.scala 34:39]
  wire  _csignals_T_608 = _csignals_T_91 ? 1'h0 : _csignals_T_93 | (_csignals_T_95 | (_csignals_T_97 | (_csignals_T_99
     | (_csignals_T_101 | (_csignals_T_103 | (_csignals_T_105 | (_csignals_T_107 | (_csignals_T_109 | (_csignals_T_111
     | (_csignals_T_113 | (_csignals_T_115 | (_csignals_T_117 | (_csignals_T_119 | (_csignals_T_121 | (_csignals_T_123
     | (_csignals_T_125 | (_csignals_T_127 | (_csignals_T_129 | (_csignals_T_131 | (_csignals_T_133 | (_csignals_T_135
     | _csignals_T_585))))))))))))))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_609 = _csignals_T_89 ? 1'h0 : _csignals_T_608; // @[Lookup.scala 34:39]
  wire  _csignals_T_610 = _csignals_T_87 ? 1'h0 : _csignals_T_609; // @[Lookup.scala 34:39]
  wire  _csignals_T_621 = _csignals_T_65 ? 1'h0 : _csignals_T_67 | (_csignals_T_69 | (_csignals_T_71 | (_csignals_T_73
     | (_csignals_T_75 | (_csignals_T_77 | (_csignals_T_79 | (_csignals_T_81 | (_csignals_T_83 | (_csignals_T_85 |
    _csignals_T_610))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_622 = _csignals_T_63 ? 1'h0 : _csignals_T_621; // @[Lookup.scala 34:39]
  wire  _csignals_T_623 = _csignals_T_61 ? 1'h0 : _csignals_T_622; // @[Lookup.scala 34:39]
  wire  _csignals_T_624 = _csignals_T_59 ? 1'h0 : _csignals_T_623; // @[Lookup.scala 34:39]
  wire  _csignals_T_625 = _csignals_T_57 ? 1'h0 : _csignals_T_624; // @[Lookup.scala 34:39]
  wire  _csignals_T_626 = _csignals_T_55 ? 1'h0 : _csignals_T_625; // @[Lookup.scala 34:39]
  wire  _csignals_T_646 = _csignals_T_15 ? 1'h0 : _csignals_T_17 | (_csignals_T_19 | (_csignals_T_21 | (_csignals_T_23
     | (_csignals_T_25 | (_csignals_T_27 | (_csignals_T_29 | (_csignals_T_31 | (_csignals_T_33 | (_csignals_T_35 | (
    _csignals_T_37 | (_csignals_T_39 | (_csignals_T_41 | (_csignals_T_43 | (_csignals_T_45 | (_csignals_T_47 | (
    _csignals_T_49 | (_csignals_T_51 | (_csignals_T_53 | _csignals_T_626)))))))))))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_648 = _csignals_T_11 ? 1'h0 : _csignals_T_13 | _csignals_T_646; // @[Lookup.scala 34:39]
  wire  _csignals_T_651 = _csignals_T_5 ? 1'h0 : _csignals_T_7 | (_csignals_T_9 | _csignals_T_648); // @[Lookup.scala 34:39]
  wire  csignals_4 = _csignals_T_1 | (_csignals_T_3 | _csignals_T_651); // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_656 = _csignals_T_181 ? 3'h6 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_657 = _csignals_T_179 ? 3'h1 : _csignals_T_656; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_658 = _csignals_T_177 ? 3'h1 : _csignals_T_657; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_659 = _csignals_T_175 ? 3'h1 : _csignals_T_658; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_660 = _csignals_T_173 ? 3'h0 : _csignals_T_659; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_661 = _csignals_T_171 ? 3'h0 : _csignals_T_660; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_662 = _csignals_T_169 ? 3'h1 : _csignals_T_661; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_663 = _csignals_T_167 ? 3'h0 : _csignals_T_662; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_664 = _csignals_T_165 ? 3'h0 : _csignals_T_663; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_665 = _csignals_T_163 ? 3'h0 : _csignals_T_664; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_666 = _csignals_T_161 ? 3'h0 : _csignals_T_665; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_667 = _csignals_T_159 ? 3'h0 : _csignals_T_666; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_157 ? 3'h0 : _csignals_T_667; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_155 ? 3'h0 : _csignals_T_668; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_153 ? 3'h0 : _csignals_T_669; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_151 ? 3'h0 : _csignals_T_670; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_149 ? 3'h0 : _csignals_T_671; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_147 ? 3'h0 : _csignals_T_672; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_145 ? 3'h6 : _csignals_T_673; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_143 ? 3'h0 : _csignals_T_674; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_141 ? 3'h0 : _csignals_T_675; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_677 = _csignals_T_139 ? 3'h0 : _csignals_T_676; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_678 = _csignals_T_137 ? 3'h0 : _csignals_T_677; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_679 = _csignals_T_135 ? 3'h0 : _csignals_T_678; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_680 = _csignals_T_133 ? 3'h0 : _csignals_T_679; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_681 = _csignals_T_131 ? 3'h0 : _csignals_T_680; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_682 = _csignals_T_129 ? 3'h5 : _csignals_T_681; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_683 = _csignals_T_127 ? 3'h5 : _csignals_T_682; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_684 = _csignals_T_125 ? 3'h5 : _csignals_T_683; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_685 = _csignals_T_123 ? 3'h5 : _csignals_T_684; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_686 = _csignals_T_121 ? 3'h5 : _csignals_T_685; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_687 = _csignals_T_119 ? 3'h5 : _csignals_T_686; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_688 = _csignals_T_117 ? 3'h5 : _csignals_T_687; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_689 = _csignals_T_115 ? 3'h0 : _csignals_T_688; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_690 = _csignals_T_113 ? 3'h0 : _csignals_T_689; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_691 = _csignals_T_111 ? 3'h0 : _csignals_T_690; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_692 = _csignals_T_109 ? 3'h0 : _csignals_T_691; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_693 = _csignals_T_107 ? 3'h4 : _csignals_T_692; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_694 = _csignals_T_105 ? 3'h4 : _csignals_T_693; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_695 = _csignals_T_103 ? 3'h4 : _csignals_T_694; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_696 = _csignals_T_101 ? 3'h4 : _csignals_T_695; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_697 = _csignals_T_99 ? 3'h4 : _csignals_T_696; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_698 = _csignals_T_97 ? 3'h4 : _csignals_T_697; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_699 = _csignals_T_95 ? 3'h4 : _csignals_T_698; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_700 = _csignals_T_93 ? 3'h4 : _csignals_T_699; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_701 = _csignals_T_91 ? 3'h0 : _csignals_T_700; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_702 = _csignals_T_89 ? 3'h0 : _csignals_T_701; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_703 = _csignals_T_87 ? 3'h0 : _csignals_T_702; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_704 = _csignals_T_85 ? 3'h7 : _csignals_T_703; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_705 = _csignals_T_83 ? 3'h7 : _csignals_T_704; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_706 = _csignals_T_81 ? 3'h7 : _csignals_T_705; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_707 = _csignals_T_79 ? 3'h7 : _csignals_T_706; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_77 ? 3'h7 : _csignals_T_707; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_75 ? 3'h7 : _csignals_T_708; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_73 ? 3'h0 : _csignals_T_709; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_71 ? 3'h0 : _csignals_T_710; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_712 = _csignals_T_69 ? 3'h1 : _csignals_T_711; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_713 = _csignals_T_67 ? 3'h1 : _csignals_T_712; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_65 ? 3'h0 : _csignals_T_713; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_63 ? 3'h0 : _csignals_T_714; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_61 ? 3'h0 : _csignals_T_715; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_59 ? 3'h0 : _csignals_T_716; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_57 ? 3'h0 : _csignals_T_717; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_55 ? 3'h0 : _csignals_T_718; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_53 ? 3'h0 : _csignals_T_719; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_51 ? 3'h0 : _csignals_T_720; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_49 ? 3'h0 : _csignals_T_721; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_47 ? 3'h0 : _csignals_T_722; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_45 ? 3'h0 : _csignals_T_723; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_43 ? 3'h0 : _csignals_T_724; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_41 ? 3'h0 : _csignals_T_725; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_39 ? 3'h0 : _csignals_T_726; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_37 ? 3'h0 : _csignals_T_727; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_35 ? 3'h0 : _csignals_T_728; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_33 ? 3'h0 : _csignals_T_729; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_31 ? 3'h0 : _csignals_T_730; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_29 ? 3'h0 : _csignals_T_731; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_27 ? 3'h0 : _csignals_T_732; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_25 ? 3'h0 : _csignals_T_733; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_23 ? 3'h0 : _csignals_T_734; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_21 ? 3'h0 : _csignals_T_735; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_19 ? 3'h0 : _csignals_T_736; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_17 ? 3'h0 : _csignals_T_737; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_15 ? 3'h0 : _csignals_T_738; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_740 = _csignals_T_13 ? 3'h6 : _csignals_T_739; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_741 = _csignals_T_11 ? 3'h0 : _csignals_T_740; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_742 = _csignals_T_9 ? 3'h6 : _csignals_T_741; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_743 = _csignals_T_7 ? 3'h6 : _csignals_T_742; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_744 = _csignals_T_5 ? 3'h0 : _csignals_T_743; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_745 = _csignals_T_3 ? 3'h6 : _csignals_T_744; // @[Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h6 : _csignals_T_745; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_746 = _csignals_T_187 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_747 = _csignals_T_185 ? 3'h1 : _csignals_T_746; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_748 = _csignals_T_183 ? 3'h1 : _csignals_T_747; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_749 = _csignals_T_181 ? 3'h1 : _csignals_T_748; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_750 = _csignals_T_179 ? 3'h4 : _csignals_T_749; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_751 = _csignals_T_177 ? 3'h4 : _csignals_T_750; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_752 = _csignals_T_175 ? 3'h1 : _csignals_T_751; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_753 = _csignals_T_173 ? 3'h1 : _csignals_T_752; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_754 = _csignals_T_171 ? 3'h1 : _csignals_T_753; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_755 = _csignals_T_169 ? 3'h1 : _csignals_T_754; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_756 = _csignals_T_167 ? 3'h1 : _csignals_T_755; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_757 = _csignals_T_165 ? 3'h2 : _csignals_T_756; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_758 = _csignals_T_163 ? 3'h2 : _csignals_T_757; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_759 = _csignals_T_161 ? 3'h2 : _csignals_T_758; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_760 = _csignals_T_159 ? 3'h2 : _csignals_T_759; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_761 = _csignals_T_157 ? 3'h2 : _csignals_T_760; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_762 = _csignals_T_155 ? 3'h2 : _csignals_T_761; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_763 = _csignals_T_153 ? 3'h2 : _csignals_T_762; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_764 = _csignals_T_151 ? 3'h1 : _csignals_T_763; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_765 = _csignals_T_149 ? 3'h1 : _csignals_T_764; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_766 = _csignals_T_147 ? 3'h1 : _csignals_T_765; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_767 = _csignals_T_145 ? 3'h3 : _csignals_T_766; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_768 = _csignals_T_143 ? 3'h1 : _csignals_T_767; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_769 = _csignals_T_141 ? 3'h1 : _csignals_T_768; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_770 = _csignals_T_139 ? 3'h3 : _csignals_T_769; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_771 = _csignals_T_137 ? 3'h1 : _csignals_T_770; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_772 = _csignals_T_135 ? 3'h0 : _csignals_T_771; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_773 = _csignals_T_133 ? 3'h0 : _csignals_T_772; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_774 = _csignals_T_131 ? 3'h0 : _csignals_T_773; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_775 = _csignals_T_129 ? 3'h0 : _csignals_T_774; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_776 = _csignals_T_127 ? 3'h0 : _csignals_T_775; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_777 = _csignals_T_125 ? 3'h0 : _csignals_T_776; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_778 = _csignals_T_123 ? 3'h0 : _csignals_T_777; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_779 = _csignals_T_121 ? 3'h0 : _csignals_T_778; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_780 = _csignals_T_119 ? 3'h0 : _csignals_T_779; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_781 = _csignals_T_117 ? 3'h0 : _csignals_T_780; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_782 = _csignals_T_115 ? 3'h0 : _csignals_T_781; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_783 = _csignals_T_113 ? 3'h0 : _csignals_T_782; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_784 = _csignals_T_111 ? 3'h0 : _csignals_T_783; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_785 = _csignals_T_109 ? 3'h0 : _csignals_T_784; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_786 = _csignals_T_107 ? 3'h0 : _csignals_T_785; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_787 = _csignals_T_105 ? 3'h0 : _csignals_T_786; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_788 = _csignals_T_103 ? 3'h0 : _csignals_T_787; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_789 = _csignals_T_101 ? 3'h0 : _csignals_T_788; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_790 = _csignals_T_99 ? 3'h0 : _csignals_T_789; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_791 = _csignals_T_97 ? 3'h0 : _csignals_T_790; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_792 = _csignals_T_95 ? 3'h0 : _csignals_T_791; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_793 = _csignals_T_93 ? 3'h0 : _csignals_T_792; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_794 = _csignals_T_91 ? 3'h0 : _csignals_T_793; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_795 = _csignals_T_89 ? 3'h0 : _csignals_T_794; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_796 = _csignals_T_87 ? 3'h0 : _csignals_T_795; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_797 = _csignals_T_85 ? 3'h0 : _csignals_T_796; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_798 = _csignals_T_83 ? 3'h0 : _csignals_T_797; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_799 = _csignals_T_81 ? 3'h0 : _csignals_T_798; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_800 = _csignals_T_79 ? 3'h0 : _csignals_T_799; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_801 = _csignals_T_77 ? 3'h0 : _csignals_T_800; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_802 = _csignals_T_75 ? 3'h0 : _csignals_T_801; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_803 = _csignals_T_73 ? 3'h0 : _csignals_T_802; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_804 = _csignals_T_71 ? 3'h0 : _csignals_T_803; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_805 = _csignals_T_69 ? 3'h0 : _csignals_T_804; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_806 = _csignals_T_67 ? 3'h0 : _csignals_T_805; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_807 = _csignals_T_65 ? 3'h0 : _csignals_T_806; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_808 = _csignals_T_63 ? 3'h0 : _csignals_T_807; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_809 = _csignals_T_61 ? 3'h0 : _csignals_T_808; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_810 = _csignals_T_59 ? 3'h0 : _csignals_T_809; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_811 = _csignals_T_57 ? 3'h0 : _csignals_T_810; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_812 = _csignals_T_55 ? 3'h0 : _csignals_T_811; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_813 = _csignals_T_53 ? 3'h0 : _csignals_T_812; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_814 = _csignals_T_51 ? 3'h0 : _csignals_T_813; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_815 = _csignals_T_49 ? 3'h0 : _csignals_T_814; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_816 = _csignals_T_47 ? 3'h0 : _csignals_T_815; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_817 = _csignals_T_45 ? 3'h0 : _csignals_T_816; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_818 = _csignals_T_43 ? 3'h0 : _csignals_T_817; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_819 = _csignals_T_41 ? 3'h0 : _csignals_T_818; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_820 = _csignals_T_39 ? 3'h0 : _csignals_T_819; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_821 = _csignals_T_37 ? 3'h0 : _csignals_T_820; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_822 = _csignals_T_35 ? 3'h0 : _csignals_T_821; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_823 = _csignals_T_33 ? 3'h0 : _csignals_T_822; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_824 = _csignals_T_31 ? 3'h0 : _csignals_T_823; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_825 = _csignals_T_29 ? 3'h0 : _csignals_T_824; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_826 = _csignals_T_27 ? 3'h0 : _csignals_T_825; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_827 = _csignals_T_25 ? 3'h0 : _csignals_T_826; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_828 = _csignals_T_23 ? 3'h0 : _csignals_T_827; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_829 = _csignals_T_21 ? 3'h0 : _csignals_T_828; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_830 = _csignals_T_19 ? 3'h0 : _csignals_T_829; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_831 = _csignals_T_17 ? 3'h0 : _csignals_T_830; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_832 = _csignals_T_15 ? 3'h0 : _csignals_T_831; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_833 = _csignals_T_13 ? 3'h0 : _csignals_T_832; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_834 = _csignals_T_11 ? 3'h0 : _csignals_T_833; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_835 = _csignals_T_9 ? 3'h0 : _csignals_T_834; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_836 = _csignals_T_7 ? 3'h0 : _csignals_T_835; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_837 = _csignals_T_5 ? 3'h0 : _csignals_T_836; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_838 = _csignals_T_3 ? 3'h0 : _csignals_T_837; // @[Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_838; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_888 = _csignals_T_89 ? 3'h6 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_889 = _csignals_T_87 ? 3'h4 : _csignals_T_888; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_890 = _csignals_T_85 ? 3'h3 : _csignals_T_889; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_891 = _csignals_T_83 ? 3'h3 : _csignals_T_890; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_892 = _csignals_T_81 ? 3'h2 : _csignals_T_891; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_893 = _csignals_T_79 ? 3'h2 : _csignals_T_892; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_894 = _csignals_T_77 ? 3'h1 : _csignals_T_893; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_895 = _csignals_T_75 ? 3'h1 : _csignals_T_894; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_896 = _csignals_T_73 ? 3'h0 : _csignals_T_895; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_897 = _csignals_T_71 ? 3'h0 : _csignals_T_896; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_898 = _csignals_T_69 ? 3'h0 : _csignals_T_897; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_899 = _csignals_T_67 ? 3'h0 : _csignals_T_898; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_900 = _csignals_T_65 ? 3'h0 : _csignals_T_899; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_901 = _csignals_T_63 ? 3'h0 : _csignals_T_900; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_902 = _csignals_T_61 ? 3'h0 : _csignals_T_901; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_903 = _csignals_T_59 ? 3'h0 : _csignals_T_902; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_904 = _csignals_T_57 ? 3'h0 : _csignals_T_903; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_905 = _csignals_T_55 ? 3'h0 : _csignals_T_904; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_906 = _csignals_T_53 ? 3'h0 : _csignals_T_905; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_907 = _csignals_T_51 ? 3'h0 : _csignals_T_906; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_908 = _csignals_T_49 ? 3'h0 : _csignals_T_907; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_909 = _csignals_T_47 ? 3'h0 : _csignals_T_908; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_910 = _csignals_T_45 ? 3'h0 : _csignals_T_909; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_911 = _csignals_T_43 ? 3'h0 : _csignals_T_910; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_912 = _csignals_T_41 ? 3'h0 : _csignals_T_911; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_913 = _csignals_T_39 ? 3'h0 : _csignals_T_912; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_914 = _csignals_T_37 ? 3'h0 : _csignals_T_913; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_915 = _csignals_T_35 ? 3'h0 : _csignals_T_914; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_916 = _csignals_T_33 ? 3'h0 : _csignals_T_915; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_917 = _csignals_T_31 ? 3'h0 : _csignals_T_916; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_918 = _csignals_T_29 ? 3'h0 : _csignals_T_917; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_919 = _csignals_T_27 ? 3'h0 : _csignals_T_918; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_920 = _csignals_T_25 ? 3'h0 : _csignals_T_919; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_921 = _csignals_T_23 ? 3'h0 : _csignals_T_920; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_922 = _csignals_T_21 ? 3'h0 : _csignals_T_921; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_923 = _csignals_T_19 ? 3'h0 : _csignals_T_922; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_924 = _csignals_T_17 ? 3'h0 : _csignals_T_923; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_925 = _csignals_T_15 ? 3'h0 : _csignals_T_924; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_926 = _csignals_T_13 ? 3'h0 : _csignals_T_925; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_927 = _csignals_T_11 ? 3'h0 : _csignals_T_926; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_928 = _csignals_T_9 ? 3'h0 : _csignals_T_927; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_929 = _csignals_T_7 ? 3'h0 : _csignals_T_928; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_930 = _csignals_T_5 ? 3'h0 : _csignals_T_929; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_931 = _csignals_T_3 ? 3'h0 : _csignals_T_930; // @[Lookup.scala 34:39]
  wire [2:0] csignals_7 = _csignals_T_1 ? 3'h0 : _csignals_T_931; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_934 = _csignals_T_183 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_935 = _csignals_T_181 ? 3'h1 : _csignals_T_934; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_936 = _csignals_T_179 ? 3'h0 : _csignals_T_935; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_937 = _csignals_T_177 ? 3'h0 : _csignals_T_936; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_938 = _csignals_T_175 ? 3'h0 : _csignals_T_937; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_939 = _csignals_T_173 ? 3'h0 : _csignals_T_938; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_940 = _csignals_T_171 ? 3'h0 : _csignals_T_939; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_941 = _csignals_T_169 ? 3'h0 : _csignals_T_940; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_942 = _csignals_T_167 ? 3'h0 : _csignals_T_941; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_943 = _csignals_T_165 ? 3'h0 : _csignals_T_942; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_944 = _csignals_T_163 ? 3'h0 : _csignals_T_943; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_945 = _csignals_T_161 ? 3'h0 : _csignals_T_944; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_946 = _csignals_T_159 ? 3'h0 : _csignals_T_945; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_947 = _csignals_T_157 ? 3'h0 : _csignals_T_946; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_948 = _csignals_T_155 ? 3'h0 : _csignals_T_947; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_949 = _csignals_T_153 ? 3'h0 : _csignals_T_948; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_950 = _csignals_T_151 ? 3'h0 : _csignals_T_949; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_951 = _csignals_T_149 ? 3'h0 : _csignals_T_950; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_952 = _csignals_T_147 ? 3'h1 : _csignals_T_951; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_953 = _csignals_T_145 ? 3'h1 : _csignals_T_952; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_954 = _csignals_T_143 ? 3'h0 : _csignals_T_953; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_955 = _csignals_T_141 ? 3'h0 : _csignals_T_954; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_956 = _csignals_T_139 ? 3'h0 : _csignals_T_955; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_957 = _csignals_T_137 ? 3'h0 : _csignals_T_956; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_958 = _csignals_T_135 ? 3'h0 : _csignals_T_957; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_959 = _csignals_T_133 ? 3'h0 : _csignals_T_958; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_960 = _csignals_T_131 ? 3'h0 : _csignals_T_959; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_961 = _csignals_T_129 ? 3'h0 : _csignals_T_960; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_962 = _csignals_T_127 ? 3'h0 : _csignals_T_961; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_963 = _csignals_T_125 ? 3'h0 : _csignals_T_962; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_964 = _csignals_T_123 ? 3'h0 : _csignals_T_963; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_965 = _csignals_T_121 ? 3'h0 : _csignals_T_964; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_966 = _csignals_T_119 ? 3'h0 : _csignals_T_965; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_967 = _csignals_T_117 ? 3'h0 : _csignals_T_966; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_968 = _csignals_T_115 ? 3'h0 : _csignals_T_967; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_969 = _csignals_T_113 ? 3'h0 : _csignals_T_968; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_970 = _csignals_T_111 ? 3'h0 : _csignals_T_969; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_971 = _csignals_T_109 ? 3'h0 : _csignals_T_970; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_972 = _csignals_T_107 ? 3'h0 : _csignals_T_971; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_973 = _csignals_T_105 ? 3'h0 : _csignals_T_972; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_974 = _csignals_T_103 ? 3'h0 : _csignals_T_973; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_975 = _csignals_T_101 ? 3'h0 : _csignals_T_974; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_976 = _csignals_T_99 ? 3'h0 : _csignals_T_975; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_977 = _csignals_T_97 ? 3'h0 : _csignals_T_976; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_978 = _csignals_T_95 ? 3'h0 : _csignals_T_977; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_979 = _csignals_T_93 ? 3'h0 : _csignals_T_978; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_980 = _csignals_T_91 ? 3'h0 : _csignals_T_979; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_981 = _csignals_T_89 ? 3'h0 : _csignals_T_980; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_982 = _csignals_T_87 ? 3'h0 : _csignals_T_981; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_983 = _csignals_T_85 ? 3'h0 : _csignals_T_982; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_984 = _csignals_T_83 ? 3'h0 : _csignals_T_983; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_985 = _csignals_T_81 ? 3'h0 : _csignals_T_984; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_986 = _csignals_T_79 ? 3'h0 : _csignals_T_985; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_987 = _csignals_T_77 ? 3'h0 : _csignals_T_986; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_988 = _csignals_T_75 ? 3'h0 : _csignals_T_987; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_989 = _csignals_T_73 ? 3'h0 : _csignals_T_988; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_990 = _csignals_T_71 ? 3'h0 : _csignals_T_989; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_991 = _csignals_T_69 ? 3'h0 : _csignals_T_990; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_992 = _csignals_T_67 ? 3'h0 : _csignals_T_991; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_993 = _csignals_T_65 ? 3'h0 : _csignals_T_992; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_994 = _csignals_T_63 ? 3'h0 : _csignals_T_993; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_995 = _csignals_T_61 ? 3'h0 : _csignals_T_994; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_996 = _csignals_T_59 ? 3'h0 : _csignals_T_995; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_997 = _csignals_T_57 ? 3'h0 : _csignals_T_996; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_998 = _csignals_T_55 ? 3'h0 : _csignals_T_997; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_999 = _csignals_T_53 ? 3'h0 : _csignals_T_998; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1000 = _csignals_T_51 ? 3'h0 : _csignals_T_999; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1001 = _csignals_T_49 ? 3'h0 : _csignals_T_1000; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1002 = _csignals_T_47 ? 3'h0 : _csignals_T_1001; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1003 = _csignals_T_45 ? 3'h0 : _csignals_T_1002; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1004 = _csignals_T_43 ? 3'h0 : _csignals_T_1003; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1005 = _csignals_T_41 ? 3'h0 : _csignals_T_1004; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1006 = _csignals_T_39 ? 3'h0 : _csignals_T_1005; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1007 = _csignals_T_37 ? 3'h0 : _csignals_T_1006; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1008 = _csignals_T_35 ? 3'h0 : _csignals_T_1007; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1009 = _csignals_T_33 ? 3'h0 : _csignals_T_1008; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1010 = _csignals_T_31 ? 3'h0 : _csignals_T_1009; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1011 = _csignals_T_29 ? 3'h0 : _csignals_T_1010; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1012 = _csignals_T_27 ? 3'h0 : _csignals_T_1011; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1013 = _csignals_T_25 ? 3'h0 : _csignals_T_1012; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1014 = _csignals_T_23 ? 3'h0 : _csignals_T_1013; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1015 = _csignals_T_21 ? 3'h0 : _csignals_T_1014; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1016 = _csignals_T_19 ? 3'h0 : _csignals_T_1015; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1017 = _csignals_T_17 ? 3'h0 : _csignals_T_1016; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1018 = _csignals_T_15 ? 3'h1 : _csignals_T_1017; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1019 = _csignals_T_13 ? 3'h1 : _csignals_T_1018; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1020 = _csignals_T_11 ? 3'h2 : _csignals_T_1019; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1021 = _csignals_T_9 ? 3'h4 : _csignals_T_1020; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1022 = _csignals_T_7 ? 3'h2 : _csignals_T_1021; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1023 = _csignals_T_5 ? 3'h3 : _csignals_T_1022; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1024 = _csignals_T_3 ? 3'h5 : _csignals_T_1023; // @[Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h3 : _csignals_T_1024; // @[Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 619:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 620:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 621:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 622:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h0; // @[Core.scala 626:17]
  wire  _id_op1_data_T_1 = csignals_1 == 3'h1; // @[Core.scala 627:17]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h3; // @[Core.scala 628:17]
  wire  _id_op1_data_T_3 = csignals_1 == 3'h4; // @[Core.scala 629:17]
  wire  _id_op1_data_T_4 = csignals_1 == 3'h5; // @[Core.scala 630:17]
  wire  _id_op1_data_T_5 = csignals_1 == 3'h6; // @[Core.scala 631:17]
  wire [31:0] _id_op1_data_T_6 = _id_op1_data_T_5 ? regfile_id_c_rs1p_data_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_7 = _id_op1_data_T_4 ? regfile_id_sp_data_data : _id_op1_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_8 = _id_op1_data_T_3 ? id_c_rs1_data : _id_op1_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_9 = _id_op1_data_T_2 ? id_imm_z_uext : _id_op1_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_10 = _id_op1_data_T_1 ? id_reg_pc : _id_op1_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? id_rs1_data : _id_op1_data_T_10; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 4'h1; // @[Core.scala 634:17]
  wire  _id_op2_data_T_1 = csignals_2 == 4'h2; // @[Core.scala 635:17]
  wire  _id_op2_data_T_2 = csignals_2 == 4'h3; // @[Core.scala 636:17]
  wire  _id_op2_data_T_3 = csignals_2 == 4'h4; // @[Core.scala 637:17]
  wire  _id_op2_data_T_4 = csignals_2 == 4'h5; // @[Core.scala 638:17]
  wire  _id_op2_data_T_5 = csignals_2 == 4'h6; // @[Core.scala 639:17]
  wire  _id_op2_data_T_6 = csignals_2 == 4'h7; // @[Core.scala 640:17]
  wire  _id_op2_data_T_7 = csignals_2 == 4'h8; // @[Core.scala 641:17]
  wire  _id_op2_data_T_8 = csignals_2 == 4'h9; // @[Core.scala 642:17]
  wire  _id_op2_data_T_9 = csignals_2 == 4'ha; // @[Core.scala 643:17]
  wire  _id_op2_data_T_10 = csignals_2 == 4'hb; // @[Core.scala 644:17]
  wire  _id_op2_data_T_11 = csignals_2 == 4'hc; // @[Core.scala 645:17]
  wire  _id_op2_data_T_12 = csignals_2 == 4'hd; // @[Core.scala 646:17]
  wire  _id_op2_data_T_13 = csignals_2 == 4'he; // @[Core.scala 647:17]
  wire  _id_op2_data_T_14 = csignals_2 == 4'hf; // @[Core.scala 648:17]
  wire [31:0] _id_op2_data_T_15 = _id_op2_data_T_14 ? id_c_imm_ss : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_16 = _id_op2_data_T_13 ? id_c_imm_sl : _id_op2_data_T_15; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_17 = _id_op2_data_T_12 ? id_c_imm_j : _id_op2_data_T_16; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_18 = _id_op2_data_T_11 ? id_c_imm_iu : _id_op2_data_T_17; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_19 = _id_op2_data_T_10 ? id_c_imm_ls : _id_op2_data_T_18; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_20 = _id_op2_data_T_9 ? id_c_imm_i : _id_op2_data_T_19; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_21 = _id_op2_data_T_8 ? id_c_imm_i16 : _id_op2_data_T_20; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_22 = _id_op2_data_T_7 ? id_c_imm_iw : _id_op2_data_T_21; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_23 = _id_op2_data_T_6 ? regfile_id_c_rs2p_data_data : _id_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_24 = _id_op2_data_T_5 ? id_c_rs2_data : _id_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_25 = _id_op2_data_T_4 ? id_imm_u_shifted : _id_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_26 = _id_op2_data_T_3 ? id_imm_j_sext : _id_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_27 = _id_op2_data_T_2 ? id_imm_s_sext : _id_op2_data_T_26; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_28 = _id_op2_data_T_1 ? id_imm_i_sext : _id_op2_data_T_27; // @[Mux.scala 101:16]
  wire [31:0] id_op2_data = _id_op2_data_T ? id_rs2_data : _id_op2_data_T_28; // @[Mux.scala 101:16]
  wire  _id_csr_addr_T = csignals_7 == 3'h4; // @[Core.scala 651:36]
  wire [11:0] id_csr_addr = csignals_7 == 3'h4 ? 12'h342 : id_imm_i; // @[Core.scala 651:24]
  wire [2:0] _id_m_op1_sel_T_3 = _id_op1_data_T_5 ? 3'h0 : csignals_1; // @[Mux.scala 101:16]
  wire [2:0] _id_m_op1_sel_T_4 = _id_op1_data_T_4 ? 3'h0 : _id_m_op1_sel_T_3; // @[Mux.scala 101:16]
  wire [2:0] id_m_op1_sel = _id_op1_data_T_3 ? 3'h0 : _id_m_op1_sel_T_4; // @[Mux.scala 101:16]
  wire [3:0] _id_m_op2_sel_T_2 = _id_op2_data_T_6 ? 4'h1 : csignals_2; // @[Mux.scala 101:16]
  wire [3:0] id_m_op2_sel = _id_op2_data_T_5 ? 4'h1 : _id_m_op2_sel_T_2; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs1_addr_T_3 = _id_op1_data_T_5 ? id_c_rs1p_addr : id_rs1_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs1_addr_T_4 = _id_op1_data_T_4 ? 5'h2 : _id_m_rs1_addr_T_3; // @[Mux.scala 101:16]
  wire [4:0] id_m_rs1_addr = _id_op1_data_T_3 ? id_w_wb_addr : _id_m_rs1_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_4 = _id_op2_data_T_14 ? id_c_rs2_addr : id_rs2_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_5 = _id_op2_data_T_10 ? id_c_rs2p_addr : _id_m_rs2_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_6 = _id_op2_data_T_6 ? id_c_rs2p_addr : _id_m_rs2_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_m_rs2_addr = _id_op2_data_T_5 ? id_c_rs2_addr : _id_m_rs2_addr_T_6; // @[Mux.scala 101:16]
  wire [31:0] id_m_imm_b_sext = _id_wb_addr_T ? id_c_imm_b : id_imm_b_sext; // @[Mux.scala 101:16]
  wire  id_is_j = csignals_5 == 3'h1; // @[Core.scala 682:28]
  reg [31:0] id_reg_pc_delay; // @[Core.scala 687:40]
  reg [1:0] id_reg_inst_cnt_delay; // @[Core.scala 688:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 689:40]
  reg [2:0] id_reg_op1_sel_delay; // @[Core.scala 690:40]
  reg [3:0] id_reg_op2_sel_delay; // @[Core.scala 691:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 692:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 693:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 694:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 695:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 697:40]
  reg [1:0] id_reg_mem_wen_delay; // @[Core.scala 698:40]
  reg  id_reg_rf_wen_delay; // @[Core.scala 699:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 700:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 701:40]
  reg [2:0] id_reg_csr_cmd_delay; // @[Core.scala 702:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 705:40]
  reg [31:0] id_reg_mem_w_delay; // @[Core.scala 708:40]
  reg  id_reg_is_j_delay; // @[Core.scala 709:40]
  reg  id_reg_is_bp_pos_delay; // @[Core.scala 710:40]
  reg [31:0] id_reg_bp_addr_delay; // @[Core.scala 711:40]
  reg  id_reg_is_half_delay; // @[Core.scala 712:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 713:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 714:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 715:40]
  wire [31:0] _GEN_90 = _ic_read_en4_T ? id_reg_pc : id_reg_pc_delay; // @[Core.scala 719:26 720:32 687:40]
  wire [1:0] _GEN_91 = _ic_read_en4_T ? id_reg_inst_cnt : id_reg_inst_cnt_delay; // @[Core.scala 719:26 721:32 688:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 760:43]
  wire [31:0] _GEN_144 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 769:24 770:29 797:29]
  wire [1:0] _GEN_145 = id_reg_stall ? id_reg_inst_cnt_delay : id_reg_inst_cnt; // @[Core.scala 769:24 771:29 798:29]
  wire [2:0] _GEN_146 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 769:24 772:29 799:29]
  wire [3:0] _GEN_147 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 769:24 773:29 800:29]
  wire [4:0] _GEN_148 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 769:24 774:29 801:29]
  wire [4:0] _GEN_149 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 769:24 775:29 802:29]
  wire [31:0] _GEN_150 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 769:24 776:29 803:29]
  wire [31:0] _GEN_151 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[Core.scala 769:24 777:29 804:29]
  wire [4:0] _GEN_153 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 769:24 779:29 806:29]
  wire [31:0] _GEN_157 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 769:24 783:29 810:29]
  wire [11:0] _GEN_158 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 769:24 784:29 811:29]
  wire [31:0] _GEN_160 = id_reg_stall ? id_reg_bp_addr_delay : id_reg_bp_addr; // @[Core.scala 769:24 790:29 817:29]
  wire  _GEN_161 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 769:24 791:29 818:29]
  wire [31:0] _GEN_162 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 769:24 794:29 821:29]
  wire  _T_29 = ~ex1_stall; // @[Core.scala 824:14]
  wire  _T_30 = ~mem_stall; // @[Core.scala 824:28]
  reg  ex1_reg_fw_en; // @[Core.scala 893:38]
  reg  ex2_reg_fw_en; // @[Core.scala 896:38]
  reg  mem_reg_rf_wen_delay; // @[Core.scala 900:38]
  reg [31:0] mem_reg_wb_data_delay; // @[Core.scala 902:38]
  reg  wb_reg_rf_wen_delay; // @[Core.scala 903:38]
  reg [4:0] wb_reg_wb_addr_delay; // @[Core.scala 904:38]
  reg [31:0] wb_reg_wb_data_delay; // @[Core.scala 905:38]
  wire  _ex1_op1_data_T_2 = _ex1_stall_T & ex1_reg_rs1_addr == 5'h0; // @[Core.scala 926:34]
  wire  _ex1_op1_data_T_4 = ex1_reg_fw_en & _ex1_stall_T; // @[Core.scala 927:20]
  wire  _ex1_op1_data_T_6 = _ex1_op1_data_T_4 & _ex1_stall_T_2; // @[Core.scala 928:36]
  wire  _ex1_op1_data_T_8 = ex2_reg_fw_en & _ex1_stall_T; // @[Core.scala 930:20]
  wire  _ex1_op1_data_T_10 = _ex1_op1_data_T_8 & _ex1_stall_T_8; // @[Core.scala 931:36]
  wire  _ex1_op1_data_T_13 = mem_reg_rf_wen_delay & _ex1_stall_T; // @[Core.scala 933:39]
  wire  _ex1_op1_data_T_14 = ex1_reg_rs1_addr == wb_reg_wb_addr; // @[Core.scala 935:24]
  wire  _ex1_op1_data_T_15 = _ex1_op1_data_T_13 & _ex1_op1_data_T_14; // @[Core.scala 934:36]
  wire  _ex1_op1_data_T_18 = wb_reg_rf_wen_delay & _ex1_stall_T; // @[Core.scala 936:38]
  wire  _ex1_op1_data_T_19 = ex1_reg_rs1_addr == wb_reg_wb_addr_delay; // @[Core.scala 938:24]
  wire  _ex1_op1_data_T_20 = _ex1_op1_data_T_18 & _ex1_op1_data_T_19; // @[Core.scala 937:36]
  wire [31:0] _ex1_op1_data_T_22 = _ex1_stall_T ? regfile_ex1_op1_data_MPORT_data : ex1_reg_op1_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_23 = _ex1_op1_data_T_20 ? wb_reg_wb_data_delay : _ex1_op1_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_24 = _ex1_op1_data_T_15 ? mem_reg_wb_data_delay : _ex1_op1_data_T_23; // @[Mux.scala 101:16]
  wire  _mem_fw_data_T_2 = mem_reg_wb_sel == 3'h1 | mem_reg_wb_sel == 3'h5; // @[Core.scala 1636:49]
  wire [31:0] mem_fw_data = mem_reg_wb_sel == 3'h1 | mem_reg_wb_sel == 3'h5 ? mem_reg_pc_bit_out : mem_reg_alu_out; // @[Core.scala 1636:21]
  wire [31:0] _ex1_op1_data_T_25 = _ex1_op1_data_T_10 ? mem_fw_data : _ex1_op1_data_T_24; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex2_reg_wb_sel == 3'h1; // @[Core.scala 1108:21]
  wire [31:0] _ex2_next_pc_T_1 = ex2_reg_pc + 32'h2; // @[Core.scala 1039:53]
  wire [31:0] _ex2_next_pc_T_3 = ex2_reg_pc + 32'h4; // @[Core.scala 1039:83]
  wire [31:0] ex2_next_pc = ex2_reg_is_half ? _ex2_next_pc_T_1 : _ex2_next_pc_T_3; // @[Core.scala 1039:24]
  wire  _ex2_alu_out_T = ex2_reg_exe_fun == 5'h0; // @[Core.scala 1013:22]
  wire [31:0] _ex2_alu_out_T_2 = ex2_reg_op1_data + ex2_reg_op2_data; // @[Core.scala 1013:58]
  wire  _ex2_alu_out_T_3 = ex2_reg_exe_fun == 5'h1; // @[Core.scala 1014:22]
  wire [31:0] _ex2_alu_out_T_5 = ex2_reg_op1_data - ex2_reg_op2_data; // @[Core.scala 1014:58]
  wire  _ex2_alu_out_T_6 = ex2_reg_exe_fun == 5'h3; // @[Core.scala 1015:22]
  wire [31:0] _ex2_alu_out_T_7 = ex2_reg_op1_data & ex2_reg_op2_data; // @[Core.scala 1015:58]
  wire  _ex2_alu_out_T_8 = ex2_reg_exe_fun == 5'h4; // @[Core.scala 1016:22]
  wire [31:0] _ex2_alu_out_T_9 = ex2_reg_op1_data | ex2_reg_op2_data; // @[Core.scala 1016:58]
  wire  _ex2_alu_out_T_10 = ex2_reg_exe_fun == 5'h2; // @[Core.scala 1017:22]
  wire [31:0] _ex2_alu_out_T_11 = ex2_reg_op1_data ^ ex2_reg_op2_data; // @[Core.scala 1017:58]
  wire  _ex2_alu_out_T_12 = ex2_reg_exe_fun == 5'h5; // @[Core.scala 1018:22]
  wire [62:0] _GEN_26 = {{31'd0}, ex2_reg_op1_data}; // @[Core.scala 1018:58]
  wire [62:0] _ex2_alu_out_T_14 = _GEN_26 << ex2_reg_op2_data[4:0]; // @[Core.scala 1018:58]
  wire  _ex2_alu_out_T_16 = ex2_reg_exe_fun == 5'h6; // @[Core.scala 1019:22]
  wire [31:0] _ex2_alu_out_T_18 = ex2_reg_op1_data >> ex2_reg_op2_data[4:0]; // @[Core.scala 1019:58]
  wire  _ex2_alu_out_T_19 = ex2_reg_exe_fun == 5'h7; // @[Core.scala 1020:22]
  wire [31:0] _ex2_alu_out_T_23 = $signed(ex2_reg_op1_data) >>> ex2_reg_op2_data[4:0]; // @[Core.scala 1020:100]
  wire  _ex2_alu_out_T_24 = ex2_reg_exe_fun == 5'h8; // @[Core.scala 1021:22]
  wire  _ex2_alu_out_T_27 = $signed(ex2_reg_op1_data) < $signed(ex2_reg_op2_data); // @[Core.scala 1021:67]
  wire  _ex2_alu_out_T_28 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 1022:22]
  wire  _ex2_alu_out_T_29 = ex2_reg_op1_data < ex2_reg_op2_data; // @[Core.scala 1022:58]
  wire  _ex2_alu_out_T_30 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 1024:22]
  wire [31:0] _ex2_alu_out_T_34 = _ex2_alu_out_T_27 ? ex2_reg_op2_data : ex2_reg_op1_data; // @[Core.scala 1024:43]
  wire  _ex2_alu_out_T_35 = ex2_reg_exe_fun == 5'hb; // @[Core.scala 1025:22]
  wire [31:0] _ex2_alu_out_T_37 = _ex2_alu_out_T_29 ? ex2_reg_op2_data : ex2_reg_op1_data; // @[Core.scala 1025:43]
  wire  _ex2_alu_out_T_38 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 1026:22]
  wire [31:0] _ex2_alu_out_T_42 = _ex2_alu_out_T_27 ? ex2_reg_op1_data : ex2_reg_op2_data; // @[Core.scala 1026:43]
  wire  _ex2_alu_out_T_43 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 1027:22]
  wire [31:0] _ex2_alu_out_T_45 = _ex2_alu_out_T_29 ? ex2_reg_op1_data : ex2_reg_op2_data; // @[Core.scala 1027:43]
  wire  _ex2_alu_out_T_46 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 1028:22]
  wire [31:0] _ex2_alu_out_T_47 = ~ex2_reg_op2_data; // @[Core.scala 1028:60]
  wire [31:0] _ex2_alu_out_T_48 = ex2_reg_op1_data & _ex2_alu_out_T_47; // @[Core.scala 1028:58]
  wire  _ex2_alu_out_T_49 = ex2_reg_exe_fun == 5'he; // @[Core.scala 1029:22]
  wire [31:0] _ex2_alu_out_T_51 = ex2_reg_op1_data ^ _ex2_alu_out_T_47; // @[Core.scala 1029:58]
  wire  _ex2_alu_out_T_52 = ex2_reg_exe_fun == 5'h10; // @[Core.scala 1030:22]
  wire [31:0] _ex2_alu_out_T_54 = ex2_reg_op1_data | _ex2_alu_out_T_47; // @[Core.scala 1030:58]
  wire [31:0] _ex2_alu_out_T_55 = _ex2_alu_out_T_52 ? _ex2_alu_out_T_54 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_56 = _ex2_alu_out_T_49 ? _ex2_alu_out_T_51 : _ex2_alu_out_T_55; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_57 = _ex2_alu_out_T_46 ? _ex2_alu_out_T_48 : _ex2_alu_out_T_56; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_58 = _ex2_alu_out_T_43 ? _ex2_alu_out_T_45 : _ex2_alu_out_T_57; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_59 = _ex2_alu_out_T_38 ? _ex2_alu_out_T_42 : _ex2_alu_out_T_58; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_60 = _ex2_alu_out_T_35 ? _ex2_alu_out_T_37 : _ex2_alu_out_T_59; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_61 = _ex2_alu_out_T_30 ? _ex2_alu_out_T_34 : _ex2_alu_out_T_60; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_62 = _ex2_alu_out_T_28 ? {{31'd0}, _ex2_alu_out_T_29} : _ex2_alu_out_T_61; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_63 = _ex2_alu_out_T_24 ? {{31'd0}, _ex2_alu_out_T_27} : _ex2_alu_out_T_62; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_64 = _ex2_alu_out_T_19 ? _ex2_alu_out_T_23 : _ex2_alu_out_T_63; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_65 = _ex2_alu_out_T_16 ? _ex2_alu_out_T_18 : _ex2_alu_out_T_64; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_66 = _ex2_alu_out_T_12 ? _ex2_alu_out_T_14[31:0] : _ex2_alu_out_T_65; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_67 = _ex2_alu_out_T_10 ? _ex2_alu_out_T_11 : _ex2_alu_out_T_66; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_68 = _ex2_alu_out_T_8 ? _ex2_alu_out_T_9 : _ex2_alu_out_T_67; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_69 = _ex2_alu_out_T_6 ? _ex2_alu_out_T_7 : _ex2_alu_out_T_68; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_70 = _ex2_alu_out_T_3 ? _ex2_alu_out_T_5 : _ex2_alu_out_T_69; // @[Mux.scala 101:16]
  wire [31:0] ex2_alu_out = _ex2_alu_out_T ? _ex2_alu_out_T_2 : _ex2_alu_out_T_70; // @[Mux.scala 101:16]
  wire [31:0] ex1_fw_data = _ex1_fw_data_T ? ex2_next_pc : ex2_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_26 = _ex1_op1_data_T_6 ? ex1_fw_data : _ex1_op1_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op1_data = _ex1_op1_data_T_2 ? 32'h0 : _ex1_op1_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_op2_data_T_1 = ex1_reg_rs2_addr == 5'h0; // @[Core.scala 942:54]
  wire  _ex1_op2_data_T_2 = _ex1_stall_T_13 & ex1_reg_rs2_addr == 5'h0; // @[Core.scala 942:34]
  wire  _ex1_op2_data_T_4 = ex1_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 943:20]
  wire  _ex1_op2_data_T_6 = _ex1_op2_data_T_4 & _ex1_stall_T_17; // @[Core.scala 944:36]
  wire  _ex1_op2_data_T_8 = ex2_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 946:20]
  wire  _ex1_op2_data_T_10 = _ex1_op2_data_T_8 & _ex1_stall_T_26; // @[Core.scala 947:36]
  wire  _ex1_op2_data_T_13 = mem_reg_rf_wen_delay & _ex1_stall_T_13; // @[Core.scala 949:39]
  wire  _ex1_op2_data_T_14 = ex1_reg_rs2_addr == wb_reg_wb_addr; // @[Core.scala 951:24]
  wire  _ex1_op2_data_T_15 = _ex1_op2_data_T_13 & _ex1_op2_data_T_14; // @[Core.scala 950:36]
  wire  _ex1_op2_data_T_18 = wb_reg_rf_wen_delay & _ex1_stall_T_13; // @[Core.scala 952:38]
  wire  _ex1_op2_data_T_19 = ex1_reg_rs2_addr == wb_reg_wb_addr_delay; // @[Core.scala 954:24]
  wire  _ex1_op2_data_T_20 = _ex1_op2_data_T_18 & _ex1_op2_data_T_19; // @[Core.scala 953:36]
  wire [31:0] _ex1_op2_data_T_22 = _ex1_stall_T_13 ? regfile_ex1_op2_data_MPORT_data : ex1_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_23 = _ex1_op2_data_T_20 ? wb_reg_wb_data_delay : _ex1_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_24 = _ex1_op2_data_T_15 ? mem_reg_wb_data_delay : _ex1_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_25 = _ex1_op2_data_T_10 ? mem_fw_data : _ex1_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_26 = _ex1_op2_data_T_6 ? ex1_fw_data : _ex1_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op2_data = _ex1_op2_data_T_2 ? 32'h0 : _ex1_op2_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_rs2_data_T_2 = ex1_reg_fw_en & _ex1_stall_T_17; // @[Core.scala 959:20]
  wire  _ex1_rs2_data_T_4 = ex2_reg_fw_en & _ex1_stall_T_26; // @[Core.scala 961:20]
  wire  _ex1_rs2_data_T_7 = mem_reg_rf_wen_delay & _ex1_op2_data_T_14; // @[Core.scala 963:39]
  wire  _ex1_rs2_data_T_10 = wb_reg_rf_wen_delay & _ex1_op2_data_T_19; // @[Core.scala 965:38]
  wire [31:0] _ex1_rs2_data_T_11 = _ex1_rs2_data_T_10 ? wb_reg_wb_data_delay : regfile_ex1_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_12 = _ex1_rs2_data_T_7 ? mem_reg_wb_data_delay : _ex1_rs2_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_13 = _ex1_rs2_data_T_4 ? mem_fw_data : _ex1_rs2_data_T_12; // @[Mux.scala 101:16]
  wire  ex1_hazard = ex1_reg_rf_wen & ex1_reg_wb_addr != 5'h0 & _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 976:96]
  wire  ex_is_bubble = ex1_stall | mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 984:51]
  wire [47:0] ex2_mullu = ex2_reg_op1_data * ex2_reg_op2_data[15:0]; // @[Core.scala 1033:38]
  wire [16:0] _ex2_mulls_T_2 = {1'b0,$signed(ex2_reg_op2_data[15:0])}; // @[Core.scala 1034:47]
  wire [48:0] _ex2_mulls_T_3 = $signed(ex2_reg_op1_data) * $signed(_ex2_mulls_T_2); // @[Core.scala 1034:47]
  wire [47:0] ex2_mulls = _ex2_mulls_T_3[47:0]; // @[Core.scala 1034:47]
  wire [47:0] ex2_mulhuu = ex2_reg_op1_data * ex2_reg_op2_data[31:16]; // @[Core.scala 1035:38]
  wire [15:0] _ex2_mulhss_T_2 = ex2_reg_op2_data[31:16]; // @[Core.scala 1036:96]
  wire [47:0] ex2_mulhss = $signed(ex2_reg_op1_data) * $signed(_ex2_mulhss_T_2); // @[Core.scala 1036:47]
  wire [16:0] _ex2_mulhsu_T_2 = {1'b0,$signed(ex2_reg_op2_data[31:16])}; // @[Core.scala 1037:47]
  wire [48:0] _ex2_mulhsu_T_3 = $signed(ex2_reg_op1_data) * $signed(_ex2_mulhsu_T_2); // @[Core.scala 1037:47]
  wire [47:0] ex2_mulhsu = _ex2_mulhsu_T_3[47:0]; // @[Core.scala 1037:47]
  wire [31:0] _ex2_pc_bit_out_T_3 = {16'h0,ex2_reg_op1_data[15:0]}; // @[Cat.scala 31:58]
  wire [1:0] _ex2_pc_bit_out_T_37 = ex2_reg_op1_data[0] + ex2_reg_op1_data[1]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_39 = ex2_reg_op1_data[2] + ex2_reg_op1_data[3]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_41 = _ex2_pc_bit_out_T_37 + _ex2_pc_bit_out_T_39; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_43 = ex2_reg_op1_data[4] + ex2_reg_op1_data[5]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_45 = ex2_reg_op1_data[6] + ex2_reg_op1_data[7]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_47 = _ex2_pc_bit_out_T_43 + _ex2_pc_bit_out_T_45; // @[Bitwise.scala 48:55]
  wire [3:0] _ex2_pc_bit_out_T_49 = _ex2_pc_bit_out_T_41 + _ex2_pc_bit_out_T_47; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_51 = ex2_reg_op1_data[8] + ex2_reg_op1_data[9]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_53 = ex2_reg_op1_data[10] + ex2_reg_op1_data[11]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_55 = _ex2_pc_bit_out_T_51 + _ex2_pc_bit_out_T_53; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_57 = ex2_reg_op1_data[12] + ex2_reg_op1_data[13]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_59 = ex2_reg_op1_data[14] + ex2_reg_op1_data[15]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_61 = _ex2_pc_bit_out_T_57 + _ex2_pc_bit_out_T_59; // @[Bitwise.scala 48:55]
  wire [3:0] _ex2_pc_bit_out_T_63 = _ex2_pc_bit_out_T_55 + _ex2_pc_bit_out_T_61; // @[Bitwise.scala 48:55]
  wire [4:0] _ex2_pc_bit_out_T_65 = _ex2_pc_bit_out_T_49 + _ex2_pc_bit_out_T_63; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_67 = ex2_reg_op1_data[16] + ex2_reg_op1_data[17]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_69 = ex2_reg_op1_data[18] + ex2_reg_op1_data[19]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_71 = _ex2_pc_bit_out_T_67 + _ex2_pc_bit_out_T_69; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_73 = ex2_reg_op1_data[20] + ex2_reg_op1_data[21]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_75 = ex2_reg_op1_data[22] + ex2_reg_op1_data[23]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_77 = _ex2_pc_bit_out_T_73 + _ex2_pc_bit_out_T_75; // @[Bitwise.scala 48:55]
  wire [3:0] _ex2_pc_bit_out_T_79 = _ex2_pc_bit_out_T_71 + _ex2_pc_bit_out_T_77; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_81 = ex2_reg_op1_data[24] + ex2_reg_op1_data[25]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_83 = ex2_reg_op1_data[26] + ex2_reg_op1_data[27]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_85 = _ex2_pc_bit_out_T_81 + _ex2_pc_bit_out_T_83; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_87 = ex2_reg_op1_data[28] + ex2_reg_op1_data[29]; // @[Bitwise.scala 48:55]
  wire [1:0] _ex2_pc_bit_out_T_89 = ex2_reg_op1_data[30] + ex2_reg_op1_data[31]; // @[Bitwise.scala 48:55]
  wire [2:0] _ex2_pc_bit_out_T_91 = _ex2_pc_bit_out_T_87 + _ex2_pc_bit_out_T_89; // @[Bitwise.scala 48:55]
  wire [3:0] _ex2_pc_bit_out_T_93 = _ex2_pc_bit_out_T_85 + _ex2_pc_bit_out_T_91; // @[Bitwise.scala 48:55]
  wire [4:0] _ex2_pc_bit_out_T_95 = _ex2_pc_bit_out_T_79 + _ex2_pc_bit_out_T_93; // @[Bitwise.scala 48:55]
  wire [5:0] _ex2_pc_bit_out_T_97 = _ex2_pc_bit_out_T_65 + _ex2_pc_bit_out_T_95; // @[Bitwise.scala 48:55]
  wire [31:0] _GEN_401 = {{16'd0}, ex2_reg_op1_data[31:16]}; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_103 = _GEN_401 & 32'hffff; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_105 = {ex2_reg_op1_data[15:0], 16'h0}; // @[Bitwise.scala 105:70]
  wire [31:0] _ex2_pc_bit_out_T_107 = _ex2_pc_bit_out_T_105 & 32'hffff0000; // @[Bitwise.scala 105:80]
  wire [31:0] _ex2_pc_bit_out_T_108 = _ex2_pc_bit_out_T_103 | _ex2_pc_bit_out_T_107; // @[Bitwise.scala 105:39]
  wire [31:0] _GEN_402 = {{8'd0}, _ex2_pc_bit_out_T_108[31:8]}; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_113 = _GEN_402 & 32'hff00ff; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_115 = {_ex2_pc_bit_out_T_108[23:0], 8'h0}; // @[Bitwise.scala 105:70]
  wire [31:0] _ex2_pc_bit_out_T_117 = _ex2_pc_bit_out_T_115 & 32'hff00ff00; // @[Bitwise.scala 105:80]
  wire [31:0] _ex2_pc_bit_out_T_118 = _ex2_pc_bit_out_T_113 | _ex2_pc_bit_out_T_117; // @[Bitwise.scala 105:39]
  wire [31:0] _GEN_403 = {{4'd0}, _ex2_pc_bit_out_T_118[31:4]}; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_123 = _GEN_403 & 32'hf0f0f0f; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_125 = {_ex2_pc_bit_out_T_118[27:0], 4'h0}; // @[Bitwise.scala 105:70]
  wire [31:0] _ex2_pc_bit_out_T_127 = _ex2_pc_bit_out_T_125 & 32'hf0f0f0f0; // @[Bitwise.scala 105:80]
  wire [31:0] _ex2_pc_bit_out_T_128 = _ex2_pc_bit_out_T_123 | _ex2_pc_bit_out_T_127; // @[Bitwise.scala 105:39]
  wire [31:0] _GEN_404 = {{2'd0}, _ex2_pc_bit_out_T_128[31:2]}; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_133 = _GEN_404 & 32'h33333333; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_135 = {_ex2_pc_bit_out_T_128[29:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [31:0] _ex2_pc_bit_out_T_137 = _ex2_pc_bit_out_T_135 & 32'hcccccccc; // @[Bitwise.scala 105:80]
  wire [31:0] _ex2_pc_bit_out_T_138 = _ex2_pc_bit_out_T_133 | _ex2_pc_bit_out_T_137; // @[Bitwise.scala 105:39]
  wire [31:0] _GEN_405 = {{1'd0}, _ex2_pc_bit_out_T_138[31:1]}; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_143 = _GEN_405 & 32'h55555555; // @[Bitwise.scala 105:31]
  wire [31:0] _ex2_pc_bit_out_T_145 = {_ex2_pc_bit_out_T_138[30:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [31:0] _ex2_pc_bit_out_T_147 = _ex2_pc_bit_out_T_145 & 32'haaaaaaaa; // @[Bitwise.scala 105:80]
  wire [31:0] _ex2_pc_bit_out_T_148 = _ex2_pc_bit_out_T_143 | _ex2_pc_bit_out_T_147; // @[Bitwise.scala 105:39]
  wire [32:0] _ex2_pc_bit_out_T_149 = {1'h1,_ex2_pc_bit_out_T_148}; // @[Cat.scala 31:58]
  wire [5:0] _ex2_pc_bit_out_T_183 = _ex2_pc_bit_out_T_149[31] ? 6'h1f : 6'h20; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_184 = _ex2_pc_bit_out_T_149[30] ? 6'h1e : _ex2_pc_bit_out_T_183; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_185 = _ex2_pc_bit_out_T_149[29] ? 6'h1d : _ex2_pc_bit_out_T_184; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_186 = _ex2_pc_bit_out_T_149[28] ? 6'h1c : _ex2_pc_bit_out_T_185; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_187 = _ex2_pc_bit_out_T_149[27] ? 6'h1b : _ex2_pc_bit_out_T_186; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_188 = _ex2_pc_bit_out_T_149[26] ? 6'h1a : _ex2_pc_bit_out_T_187; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_189 = _ex2_pc_bit_out_T_149[25] ? 6'h19 : _ex2_pc_bit_out_T_188; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_190 = _ex2_pc_bit_out_T_149[24] ? 6'h18 : _ex2_pc_bit_out_T_189; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_191 = _ex2_pc_bit_out_T_149[23] ? 6'h17 : _ex2_pc_bit_out_T_190; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_192 = _ex2_pc_bit_out_T_149[22] ? 6'h16 : _ex2_pc_bit_out_T_191; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_193 = _ex2_pc_bit_out_T_149[21] ? 6'h15 : _ex2_pc_bit_out_T_192; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_194 = _ex2_pc_bit_out_T_149[20] ? 6'h14 : _ex2_pc_bit_out_T_193; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_195 = _ex2_pc_bit_out_T_149[19] ? 6'h13 : _ex2_pc_bit_out_T_194; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_196 = _ex2_pc_bit_out_T_149[18] ? 6'h12 : _ex2_pc_bit_out_T_195; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_197 = _ex2_pc_bit_out_T_149[17] ? 6'h11 : _ex2_pc_bit_out_T_196; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_198 = _ex2_pc_bit_out_T_149[16] ? 6'h10 : _ex2_pc_bit_out_T_197; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_199 = _ex2_pc_bit_out_T_149[15] ? 6'hf : _ex2_pc_bit_out_T_198; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_200 = _ex2_pc_bit_out_T_149[14] ? 6'he : _ex2_pc_bit_out_T_199; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_201 = _ex2_pc_bit_out_T_149[13] ? 6'hd : _ex2_pc_bit_out_T_200; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_202 = _ex2_pc_bit_out_T_149[12] ? 6'hc : _ex2_pc_bit_out_T_201; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_203 = _ex2_pc_bit_out_T_149[11] ? 6'hb : _ex2_pc_bit_out_T_202; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_204 = _ex2_pc_bit_out_T_149[10] ? 6'ha : _ex2_pc_bit_out_T_203; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_205 = _ex2_pc_bit_out_T_149[9] ? 6'h9 : _ex2_pc_bit_out_T_204; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_206 = _ex2_pc_bit_out_T_149[8] ? 6'h8 : _ex2_pc_bit_out_T_205; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_207 = _ex2_pc_bit_out_T_149[7] ? 6'h7 : _ex2_pc_bit_out_T_206; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_208 = _ex2_pc_bit_out_T_149[6] ? 6'h6 : _ex2_pc_bit_out_T_207; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_209 = _ex2_pc_bit_out_T_149[5] ? 6'h5 : _ex2_pc_bit_out_T_208; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_210 = _ex2_pc_bit_out_T_149[4] ? 6'h4 : _ex2_pc_bit_out_T_209; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_211 = _ex2_pc_bit_out_T_149[3] ? 6'h3 : _ex2_pc_bit_out_T_210; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_212 = _ex2_pc_bit_out_T_149[2] ? 6'h2 : _ex2_pc_bit_out_T_211; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_213 = _ex2_pc_bit_out_T_149[1] ? 6'h1 : _ex2_pc_bit_out_T_212; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_214 = _ex2_pc_bit_out_T_149[0] ? 6'h0 : _ex2_pc_bit_out_T_213; // @[Mux.scala 47:70]
  wire [32:0] _ex2_pc_bit_out_T_216 = {1'h1,ex2_reg_op1_data}; // @[Cat.scala 31:58]
  wire [5:0] _ex2_pc_bit_out_T_250 = _ex2_pc_bit_out_T_216[31] ? 6'h1f : 6'h20; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_251 = _ex2_pc_bit_out_T_216[30] ? 6'h1e : _ex2_pc_bit_out_T_250; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_252 = _ex2_pc_bit_out_T_216[29] ? 6'h1d : _ex2_pc_bit_out_T_251; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_253 = _ex2_pc_bit_out_T_216[28] ? 6'h1c : _ex2_pc_bit_out_T_252; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_254 = _ex2_pc_bit_out_T_216[27] ? 6'h1b : _ex2_pc_bit_out_T_253; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_255 = _ex2_pc_bit_out_T_216[26] ? 6'h1a : _ex2_pc_bit_out_T_254; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_256 = _ex2_pc_bit_out_T_216[25] ? 6'h19 : _ex2_pc_bit_out_T_255; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_257 = _ex2_pc_bit_out_T_216[24] ? 6'h18 : _ex2_pc_bit_out_T_256; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_258 = _ex2_pc_bit_out_T_216[23] ? 6'h17 : _ex2_pc_bit_out_T_257; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_259 = _ex2_pc_bit_out_T_216[22] ? 6'h16 : _ex2_pc_bit_out_T_258; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_260 = _ex2_pc_bit_out_T_216[21] ? 6'h15 : _ex2_pc_bit_out_T_259; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_261 = _ex2_pc_bit_out_T_216[20] ? 6'h14 : _ex2_pc_bit_out_T_260; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_262 = _ex2_pc_bit_out_T_216[19] ? 6'h13 : _ex2_pc_bit_out_T_261; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_263 = _ex2_pc_bit_out_T_216[18] ? 6'h12 : _ex2_pc_bit_out_T_262; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_264 = _ex2_pc_bit_out_T_216[17] ? 6'h11 : _ex2_pc_bit_out_T_263; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_265 = _ex2_pc_bit_out_T_216[16] ? 6'h10 : _ex2_pc_bit_out_T_264; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_266 = _ex2_pc_bit_out_T_216[15] ? 6'hf : _ex2_pc_bit_out_T_265; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_267 = _ex2_pc_bit_out_T_216[14] ? 6'he : _ex2_pc_bit_out_T_266; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_268 = _ex2_pc_bit_out_T_216[13] ? 6'hd : _ex2_pc_bit_out_T_267; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_269 = _ex2_pc_bit_out_T_216[12] ? 6'hc : _ex2_pc_bit_out_T_268; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_270 = _ex2_pc_bit_out_T_216[11] ? 6'hb : _ex2_pc_bit_out_T_269; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_271 = _ex2_pc_bit_out_T_216[10] ? 6'ha : _ex2_pc_bit_out_T_270; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_272 = _ex2_pc_bit_out_T_216[9] ? 6'h9 : _ex2_pc_bit_out_T_271; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_273 = _ex2_pc_bit_out_T_216[8] ? 6'h8 : _ex2_pc_bit_out_T_272; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_274 = _ex2_pc_bit_out_T_216[7] ? 6'h7 : _ex2_pc_bit_out_T_273; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_275 = _ex2_pc_bit_out_T_216[6] ? 6'h6 : _ex2_pc_bit_out_T_274; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_276 = _ex2_pc_bit_out_T_216[5] ? 6'h5 : _ex2_pc_bit_out_T_275; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_277 = _ex2_pc_bit_out_T_216[4] ? 6'h4 : _ex2_pc_bit_out_T_276; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_278 = _ex2_pc_bit_out_T_216[3] ? 6'h3 : _ex2_pc_bit_out_T_277; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_279 = _ex2_pc_bit_out_T_216[2] ? 6'h2 : _ex2_pc_bit_out_T_278; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_280 = _ex2_pc_bit_out_T_216[1] ? 6'h1 : _ex2_pc_bit_out_T_279; // @[Mux.scala 47:70]
  wire [5:0] _ex2_pc_bit_out_T_281 = _ex2_pc_bit_out_T_216[0] ? 6'h0 : _ex2_pc_bit_out_T_280; // @[Mux.scala 47:70]
  wire [31:0] _ex2_pc_bit_out_T_287 = {ex2_reg_op1_data[7:0],ex2_reg_op1_data[15:8],ex2_reg_op1_data[23:16],
    ex2_reg_op1_data[31:24]}; // @[Cat.scala 31:58]
  wire [23:0] _ex2_pc_bit_out_T_291 = ex2_reg_op1_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _ex2_pc_bit_out_T_293 = {_ex2_pc_bit_out_T_291,ex2_reg_op1_data[7:0]}; // @[Cat.scala 31:58]
  wire [15:0] _ex2_pc_bit_out_T_297 = ex2_reg_op1_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _ex2_pc_bit_out_T_299 = {_ex2_pc_bit_out_T_297,ex2_reg_op1_data[15:0]}; // @[Cat.scala 31:58]
  wire [31:0] _ex2_pc_bit_out_T_300 = _ex2_alu_out_T_30 ? _ex2_pc_bit_out_T_299 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex2_pc_bit_out_T_301 = _ex2_alu_out_T_28 ? _ex2_pc_bit_out_T_293 : _ex2_pc_bit_out_T_300; // @[Mux.scala 101:16]
  wire [31:0] _ex2_pc_bit_out_T_302 = _ex2_alu_out_T_24 ? _ex2_pc_bit_out_T_287 : _ex2_pc_bit_out_T_301; // @[Mux.scala 101:16]
  wire [31:0] _ex2_pc_bit_out_T_303 = _ex2_alu_out_T_16 ? {{26'd0}, _ex2_pc_bit_out_T_281} : _ex2_pc_bit_out_T_302; // @[Mux.scala 101:16]
  wire [31:0] _ex2_pc_bit_out_T_304 = _ex2_alu_out_T_12 ? {{26'd0}, _ex2_pc_bit_out_T_214} : _ex2_pc_bit_out_T_303; // @[Mux.scala 101:16]
  wire [31:0] _ex2_pc_bit_out_T_305 = _ex2_alu_out_T_19 ? {{26'd0}, _ex2_pc_bit_out_T_97} : _ex2_pc_bit_out_T_304; // @[Mux.scala 101:16]
  wire [31:0] _ex2_dividend_T_1 = ~ex2_reg_op1_data; // @[Core.scala 1064:47]
  wire [31:0] _ex2_dividend_T_3 = _ex2_dividend_T_1 + 32'h1; // @[Core.scala 1064:65]
  wire [36:0] _ex2_dividend_T_5 = {5'h0,_ex2_dividend_T_3}; // @[Cat.scala 31:58]
  wire [36:0] _ex2_dividend_T_8 = {5'h0,ex2_reg_op1_data}; // @[Cat.scala 31:58]
  wire [31:0] _ex2_divisor_T_2 = _ex2_alu_out_T_47 + 32'h1; // @[Core.scala 1070:41]
  wire  _T_43 = ex2_reg_exe_fun == 5'h1e | ex2_reg_exe_fun == 5'h1f; // @[Core.scala 1076:44]
  wire  ex2_sign_op1 = (ex2_reg_exe_fun == 5'h1c | ex2_reg_exe_fun == 5'h1d) & ex2_reg_op1_data[31]; // @[Core.scala 1061:69 1068:18]
  wire  _GEN_252 = ex2_reg_op2_data[31] ? ~ex2_sign_op1 : ex2_sign_op1; // @[Core.scala 1069:49 1071:21 1074:21]
  wire  ex2_divrem = ex2_reg_exe_fun == 5'h1c | ex2_reg_exe_fun == 5'h1d | _T_43; // @[Core.scala 1061:69 1062:16]
  wire  ex2_sign_op12 = (ex2_reg_exe_fun == 5'h1c | ex2_reg_exe_fun == 5'h1d) & _GEN_252; // @[Core.scala 1061:69]
  wire  ex2_zero_op2 = ex2_reg_op2_data == 32'h0; // @[Core.scala 1083:37]
  wire  _ex2_is_cond_br_T = ex2_reg_exe_fun == 5'h12; // @[Core.scala 1088:22]
  wire  _ex2_is_cond_br_T_1 = ex2_reg_op1_data == ex2_reg_op2_data; // @[Core.scala 1088:57]
  wire  _ex2_is_cond_br_T_2 = ex2_reg_exe_fun == 5'h13; // @[Core.scala 1089:22]
  wire  _ex2_is_cond_br_T_4 = ~_ex2_is_cond_br_T_1; // @[Core.scala 1089:38]
  wire  _ex2_is_cond_br_T_5 = ex2_reg_exe_fun == 5'h14; // @[Core.scala 1090:22]
  wire  _ex2_is_cond_br_T_9 = ex2_reg_exe_fun == 5'h15; // @[Core.scala 1091:22]
  wire  _ex2_is_cond_br_T_13 = ~_ex2_alu_out_T_27; // @[Core.scala 1091:38]
  wire  _ex2_is_cond_br_T_14 = ex2_reg_exe_fun == 5'h16; // @[Core.scala 1092:22]
  wire  _ex2_is_cond_br_T_16 = ex2_reg_exe_fun == 5'h17; // @[Core.scala 1093:22]
  wire  _ex2_is_cond_br_T_18 = ~_ex2_alu_out_T_29; // @[Core.scala 1093:38]
  wire  _ex2_is_cond_br_T_20 = _ex2_is_cond_br_T_14 ? _ex2_alu_out_T_29 : _ex2_is_cond_br_T_16 & _ex2_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_21 = _ex2_is_cond_br_T_9 ? _ex2_is_cond_br_T_13 : _ex2_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_22 = _ex2_is_cond_br_T_5 ? _ex2_alu_out_T_27 : _ex2_is_cond_br_T_21; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_inst_T_2 = _ex2_is_cond_br_T | _ex2_is_cond_br_T_2; // @[Core.scala 1096:34]
  wire  _ex2_is_cond_br_inst_T_4 = _ex2_is_cond_br_inst_T_2 | _ex2_is_cond_br_T_5; // @[Core.scala 1097:34]
  wire  _ex2_is_cond_br_inst_T_6 = _ex2_is_cond_br_inst_T_4 | _ex2_is_cond_br_T_9; // @[Core.scala 1098:34]
  wire  _ex2_is_cond_br_inst_T_8 = _ex2_is_cond_br_inst_T_6 | _ex2_is_cond_br_T_14; // @[Core.scala 1099:34]
  wire  ex2_is_cond_br_inst = _ex2_is_cond_br_inst_T_8 | _ex2_is_cond_br_T_16; // @[Core.scala 1100:35]
  wire [31:0] ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext; // @[Core.scala 1104:39]
  wire [31:0] ex2_uncond_br_target = ex2_alu_out & 32'hfffffffe; // @[Core.scala 1105:42]
  wire  ex2_hazard = ex2_reg_rf_wen & ex2_reg_wb_addr != 5'h0 & _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 1112:96]
  wire  _ex3_reg_bp_en_T_3 = ex2_reg_is_valid_inst & _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 1121:73]
  wire  ex3_bp_en = ex3_reg_bp_en & _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 1137:51]
  wire  _ex3_cond_bp_fail_T = ~ex3_reg_is_bp_pos; // @[Core.scala 1139:6]
  wire  _ex3_cond_bp_fail_T_4 = ex3_reg_is_bp_pos & ex3_reg_is_cond_br & ex3_reg_bp_addr != ex3_reg_cond_br_target; // @[Core.scala 1140:46]
  wire  _ex3_cond_bp_fail_T_5 = ~ex3_reg_is_bp_pos & ex3_reg_is_cond_br | _ex3_cond_bp_fail_T_4; // @[Core.scala 1139:48]
  wire  ex3_cond_bp_fail = ex3_bp_en & _ex3_cond_bp_fail_T_5; // @[Core.scala 1138:36]
  wire  ex3_cond_nbp_fail = ex3_bp_en & ex3_reg_is_bp_pos & ex3_reg_is_cond_br_inst & ~ex3_reg_is_cond_br; // @[Core.scala 1142:85]
  wire  _ex3_uncond_bp_fail_T_3 = ex3_reg_is_bp_pos & ex3_reg_bp_addr != ex3_reg_uncond_br_target; // @[Core.scala 1145:24]
  wire  _ex3_uncond_bp_fail_T_4 = _ex3_cond_bp_fail_T | _ex3_uncond_bp_fail_T_3; // @[Core.scala 1144:24]
  wire  ex3_uncond_bp_fail = ex3_bp_en & ex3_reg_is_uncond_br & _ex3_uncond_bp_fail_T_4; // @[Core.scala 1143:64]
  wire [31:0] _ex3_reg_br_target_T_1 = ex3_reg_pc + 32'h2; // @[Core.scala 1149:59]
  wire [31:0] _ex3_reg_br_target_T_3 = ex3_reg_pc + 32'h4; // @[Core.scala 1149:89]
  wire [31:0] _bp_io_up_br_addr_T = ex3_reg_is_uncond_br ? ex3_reg_uncond_br_target : 32'h0; // @[Mux.scala 101:16]
  wire  _mem_reg_mem_wstrb_T = ex2_reg_mem_w == 32'h3; // @[Core.scala 1201:22]
  wire  _mem_reg_mem_wstrb_T_1 = ex2_reg_mem_w == 32'h2; // @[Core.scala 1202:22]
  wire [3:0] _mem_reg_mem_wstrb_T_4 = _mem_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem_reg_mem_wstrb_T_5 = _mem_reg_mem_wstrb_T ? 4'h1 : _mem_reg_mem_wstrb_T_4; // @[Mux.scala 101:16]
  wire [6:0] _GEN_33 = {{3'd0}, _mem_reg_mem_wstrb_T_5}; // @[Core.scala 1204:8]
  wire [6:0] _mem_reg_mem_wstrb_T_7 = _GEN_33 << ex2_alu_out[1:0]; // @[Core.scala 1204:8]
  wire  _mem_reg_div_stall_T_2 = mem_reg_divrem_state == 3'h0 | mem_reg_divrem_state == 3'h5; // @[Core.scala 1211:65]
  wire  _mem_reg_div_stall_T_3 = ex2_divrem & (mem_reg_divrem_state == 3'h0 | mem_reg_divrem_state == 3'h5); // @[Core.scala 1211:19]
  wire  _GEN_371 = 3'h2 == mem_reg_divrem_state | 3'h3 == mem_reg_divrem_state; // @[Core.scala 1438:33 1569:26]
  wire  _GEN_379 = 3'h1 == mem_reg_divrem_state | _GEN_371; // @[Core.scala 1438:33 1476:29]
  wire  mem_div_stall_next = 3'h0 == mem_reg_divrem_state ? 1'h0 : _GEN_379; // @[Core.scala 1363:22 1438:33]
  wire  _mem_reg_div_stall_T_8 = mem_reg_divrem & _mem_reg_div_stall_T_2; // @[Core.scala 1220:23]
  wire  mem_is_trap = mem_reg_is_trap & mem_is_valid_inst & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1229:76]
  wire  mem_rf_wen = mem_en & mem_reg_rf_wen; // @[Core.scala 1231:23]
  wire [2:0] mem_csr_cmd = mem_en ? mem_reg_csr_cmd : 3'h0; // @[Core.scala 1233:24]
  wire [5:0] _io_dmem_wdata_T_1 = 4'h8 * mem_reg_alu_out[1:0]; // @[Core.scala 1242:46]
  wire [94:0] _GEN_45 = {{63'd0}, mem_reg_rs2_data}; // @[Core.scala 1242:38]
  wire [94:0] _io_dmem_wdata_T_2 = _GEN_45 << _io_dmem_wdata_T_1; // @[Core.scala 1242:38]
  wire [31:0] _csr_rdata_T_7 = 12'h305 == mem_reg_csr_addr ? csr_trap_vector : 32'h0; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_9 = 12'hc01 == mem_reg_csr_addr ? mtimer_io_mtime[31:0] : _csr_rdata_T_7; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_11 = 12'hc00 == mem_reg_csr_addr ? cycle_counter_io_value[31:0] : _csr_rdata_T_9; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_13 = 12'hc02 == mem_reg_csr_addr ? instret[31:0] : _csr_rdata_T_11; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_15 = 12'hc80 == mem_reg_csr_addr ? cycle_counter_io_value[63:32] : _csr_rdata_T_13; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_17 = 12'hc81 == mem_reg_csr_addr ? mtimer_io_mtime[63:32] : _csr_rdata_T_15; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_19 = 12'hc82 == mem_reg_csr_addr ? instret[63:32] : _csr_rdata_T_17; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_21 = 12'h341 == mem_reg_csr_addr ? csr_mepc : _csr_rdata_T_19; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_23 = 12'h342 == mem_reg_csr_addr ? csr_mcause : _csr_rdata_T_21; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_25 = 12'h343 == mem_reg_csr_addr ? csr_mtval : _csr_rdata_T_23; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_27 = 12'h300 == mem_reg_csr_addr ? csr_mstatus : _csr_rdata_T_25; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_29 = 12'h340 == mem_reg_csr_addr ? csr_mscratch : _csr_rdata_T_27; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_31 = 12'h304 == mem_reg_csr_addr ? csr_mie : _csr_rdata_T_29; // @[Mux.scala 81:58]
  wire [31:0] csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 1268:18]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 1269:18]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | mem_reg_op1_data; // @[Core.scala 1269:43]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 1270:18]
  wire [31:0] _csr_wdata_T_4 = ~mem_reg_op1_data; // @[Core.scala 1270:45]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1270:43]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? mem_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _GEN_307 = mem_reg_csr_addr == 12'h304 ? csr_wdata : csr_mie; // @[Core.scala 1282:52 1283:15 85:29]
  wire [31:0] _GEN_308 = mem_reg_csr_addr == 12'h340 ? csr_wdata : csr_mscratch; // @[Core.scala 1280:57 1281:20 84:29]
  wire [31:0] _GEN_309 = mem_reg_csr_addr == 12'h340 ? csr_mie : _GEN_307; // @[Core.scala 1280:57 85:29]
  wire [31:0] _GEN_310 = mem_reg_csr_addr == 12'h300 ? csr_wdata : csr_mstatus; // @[Core.scala 1278:56 1279:19 83:29]
  wire [31:0] _GEN_311 = mem_reg_csr_addr == 12'h300 ? csr_mscratch : _GEN_308; // @[Core.scala 1278:56 84:29]
  wire [31:0] _GEN_312 = mem_reg_csr_addr == 12'h300 ? csr_mie : _GEN_309; // @[Core.scala 1278:56 85:29]
  wire [31:0] _GEN_313 = mem_reg_csr_addr == 12'h341 ? csr_wdata : csr_mepc; // @[Core.scala 1276:53 1277:16 82:29]
  wire [31:0] _GEN_314 = mem_reg_csr_addr == 12'h341 ? csr_mstatus : _GEN_310; // @[Core.scala 1276:53 83:29]
  wire [31:0] _GEN_318 = mem_reg_csr_addr == 12'h305 ? csr_mepc : _GEN_313; // @[Core.scala 1274:48 82:29]
  wire [31:0] _GEN_319 = mem_reg_csr_addr == 12'h305 ? csr_mstatus : _GEN_314; // @[Core.scala 1274:48 83:29]
  wire [31:0] _GEN_323 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_318 : csr_mepc; // @[Core.scala 1273:82 82:29]
  wire [31:0] _GEN_324 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_319 : csr_mstatus; // @[Core.scala 1273:82 83:29]
  wire [31:0] _csr_mip_T_4 = {csr_mip[31:12],_mem_is_meintr_T_2,csr_mip[10:8],mtimer_io_intr,csr_mip[6:0]}; // @[Cat.scala 31:58]
  wire  _csr_mtval_T_2 = io_intr[0] ? 1'h0 : 1'h1; // @[Mux.scala 47:70]
  wire [31:0] _csr_mstatus_T_4 = {csr_mstatus[31:8],csr_mstatus[3],csr_mstatus[6:4],1'h0,csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire  _T_57 = mem_csr_cmd == 3'h6; // @[Core.scala 1325:27]
  wire [31:0] _csr_mstatus_T_19 = {csr_mstatus[31:8],1'h1,csr_mstatus[6:4],csr_mstatus[7],csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_327 = mem_csr_cmd == 3'h6 ? _csr_mstatus_T_19 : _GEN_324; // @[Core.scala 1325:38 1326:21]
  wire [31:0] _GEN_329 = mem_csr_cmd == 3'h6 ? csr_mepc : mem_reg_br_addr; // @[Core.scala 1325:38 1328:21 231:35]
  wire  _GEN_334 = mem_is_trap | _T_57; // @[Core.scala 1313:28 1323:21]
  wire  _GEN_340 = mem_is_mtintr | _GEN_334; // @[Core.scala 1301:30 1311:21]
  wire  _GEN_346 = mem_is_meintr | _GEN_340; // @[Core.scala 1289:24 1299:21]
  reg [36:0] mem_reg_dividend; // @[Core.scala 1340:37]
  reg [35:0] mem_reg_divisor; // @[Core.scala 1341:37]
  reg [63:0] mem_reg_p_divisor; // @[Core.scala 1342:37]
  reg [4:0] mem_reg_divrem_count; // @[Core.scala 1343:37]
  reg [4:0] mem_reg_rem_shift; // @[Core.scala 1344:37]
  reg  mem_reg_extra_shift; // @[Core.scala 1345:37]
  reg [2:0] mem_reg_d; // @[Core.scala 1346:37]
  reg [31:0] mem_reg_reminder; // @[Core.scala 1347:37]
  reg [31:0] mem_reg_quotient; // @[Core.scala 1348:37]
  wire  _mem_alu_muldiv_out_T = mem_reg_exe_fun == 5'h18; // @[Core.scala 1351:22]
  wire [31:0] _mem_alu_muldiv_out_T_3 = {mem_reg_mulhuu[15:0], 16'h0}; // @[Core.scala 1351:106]
  wire [31:0] _mem_alu_muldiv_out_T_5 = mem_reg_mullu[31:0] + _mem_alu_muldiv_out_T_3; // @[Core.scala 1351:71]
  wire  _mem_alu_muldiv_out_T_6 = mem_reg_exe_fun == 5'h19; // @[Core.scala 1352:22]
  wire [15:0] _mem_alu_muldiv_out_T_10 = mem_reg_mulls[47] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [47:0] _mem_alu_muldiv_out_T_13 = {_mem_alu_muldiv_out_T_10,mem_reg_mulls[47:16]}; // @[Core.scala 1334:71]
  wire [47:0] _mem_alu_muldiv_out_T_16 = $signed(_mem_alu_muldiv_out_T_13) + $signed(mem_reg_mulhss); // @[Core.scala 1352:108]
  wire  _mem_alu_muldiv_out_T_18 = mem_reg_exe_fun == 5'h1a; // @[Core.scala 1353:22]
  wire [47:0] _mem_alu_muldiv_out_T_22 = {16'h0,mem_reg_mullu[47:16]}; // @[Core.scala 1337:35]
  wire [47:0] _mem_alu_muldiv_out_T_24 = _mem_alu_muldiv_out_T_22 + mem_reg_mulhuu; // @[Core.scala 1353:108]
  wire  _mem_alu_muldiv_out_T_26 = mem_reg_exe_fun == 5'h1b; // @[Core.scala 1354:22]
  wire [47:0] _mem_alu_muldiv_out_T_36 = $signed(_mem_alu_muldiv_out_T_13) + $signed(mem_reg_mulhsu); // @[Core.scala 1354:108]
  wire  _mem_alu_muldiv_out_T_38 = mem_reg_exe_fun == 5'h1c; // @[Core.scala 1355:22]
  wire  _mem_alu_muldiv_out_T_39 = mem_reg_exe_fun == 5'h1e; // @[Core.scala 1356:22]
  wire  _mem_alu_muldiv_out_T_40 = mem_reg_exe_fun == 5'h1d; // @[Core.scala 1357:22]
  wire  _mem_alu_muldiv_out_T_41 = mem_reg_exe_fun == 5'h1f; // @[Core.scala 1358:22]
  wire [31:0] _mem_alu_muldiv_out_T_42 = _mem_alu_muldiv_out_T_41 ? mem_reg_reminder : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_43 = _mem_alu_muldiv_out_T_40 ? mem_reg_reminder : _mem_alu_muldiv_out_T_42; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_44 = _mem_alu_muldiv_out_T_39 ? mem_reg_quotient : _mem_alu_muldiv_out_T_43; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_45 = _mem_alu_muldiv_out_T_38 ? mem_reg_quotient : _mem_alu_muldiv_out_T_44; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_46 = _mem_alu_muldiv_out_T_26 ? _mem_alu_muldiv_out_T_36[47:16] :
    _mem_alu_muldiv_out_T_45; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_47 = _mem_alu_muldiv_out_T_18 ? _mem_alu_muldiv_out_T_24[47:16] :
    _mem_alu_muldiv_out_T_46; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_muldiv_out_T_48 = _mem_alu_muldiv_out_T_6 ? _mem_alu_muldiv_out_T_16[47:16] :
    _mem_alu_muldiv_out_T_47; // @[Mux.scala 101:16]
  wire [31:0] mem_alu_muldiv_out = _mem_alu_muldiv_out_T ? _mem_alu_muldiv_out_T_5 : _mem_alu_muldiv_out_T_48; // @[Mux.scala 101:16]
  wire [1:0] _GEN_348 = mem_reg_init_divisor[31:2] == 30'h0 ? 2'h2 : 2'h1; // @[Core.scala 1441:60 1442:32 1444:32]
  wire [36:0] _mem_reg_dividend_T = mem_reg_init_dividend; // @[Core.scala 1448:59]
  wire [35:0] _mem_reg_divisor_T_1 = {mem_reg_init_divisor[3:0],32'h0}; // @[Cat.scala 31:58]
  wire [63:0] _mem_reg_p_divisor_T = {mem_reg_init_divisor,32'h0}; // @[Cat.scala 31:58]
  wire [2:0] _mem_reg_d_T_1 = {mem_reg_init_divisor[0],2'h0}; // @[Cat.scala 31:58]
  wire [4:0] _mem_reg_divrem_count_T_1 = mem_reg_divrem_count + 5'h1; // @[Core.scala 1468:52]
  wire  _p_T_1 = ~mem_reg_dividend[36]; // @[Core.scala 1480:42]
  wire [4:0] _p_T_4 = ~mem_reg_dividend[35:31]; // @[Core.scala 1482:11]
  wire [4:0] _p_T_5 = ~mem_reg_dividend[36] ? mem_reg_dividend[35:31] : _p_T_4; // @[Core.scala 1480:12]
  wire [4:0] _p_T_10 = ~mem_reg_dividend[34:30]; // @[Core.scala 1486:11]
  wire [4:0] _p_T_11 = _p_T_1 ? mem_reg_dividend[34:30] : _p_T_10; // @[Core.scala 1484:12]
  wire [4:0] p = mem_reg_extra_shift ? _p_T_5 : _p_T_11; // @[Core.scala 1479:18]
  wire [1:0] _mem_q_T_5 = 5'h2 == p ? 2'h1 : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_7 = 5'h3 == p ? 2'h1 : _mem_q_T_5; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_9 = 5'h4 == p ? 2'h1 : _mem_q_T_7; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_11 = 5'h5 == p ? 2'h1 : _mem_q_T_9; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_13 = 5'h6 == p ? 2'h2 : _mem_q_T_11; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_15 = 5'h7 == p ? 2'h2 : _mem_q_T_13; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_17 = 5'h8 == p ? 2'h2 : _mem_q_T_15; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_19 = 5'h9 == p ? 2'h2 : _mem_q_T_17; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_21 = 5'ha == p ? 2'h2 : _mem_q_T_19; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_23 = 5'hb == p ? 2'h2 : _mem_q_T_21; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_37 = 5'h6 == p ? 2'h1 : _mem_q_T_11; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_39 = 5'h7 == p ? 2'h2 : _mem_q_T_37; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_41 = 5'h8 == p ? 2'h2 : _mem_q_T_39; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_43 = 5'h9 == p ? 2'h2 : _mem_q_T_41; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_45 = 5'ha == p ? 2'h2 : _mem_q_T_43; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_47 = 5'hb == p ? 2'h2 : _mem_q_T_45; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_49 = 5'hc == p ? 2'h2 : _mem_q_T_47; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_51 = 5'hd == p ? 2'h2 : _mem_q_T_49; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_67 = 5'h7 == p ? 2'h1 : _mem_q_T_37; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_69 = 5'h8 == p ? 2'h2 : _mem_q_T_67; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_71 = 5'h9 == p ? 2'h2 : _mem_q_T_69; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_73 = 5'ha == p ? 2'h2 : _mem_q_T_71; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_75 = 5'hb == p ? 2'h2 : _mem_q_T_73; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_77 = 5'hc == p ? 2'h2 : _mem_q_T_75; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_79 = 5'hd == p ? 2'h2 : _mem_q_T_77; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_81 = 5'he == p ? 2'h2 : _mem_q_T_79; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_83 = 5'hf == p ? 2'h2 : _mem_q_T_81; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_125 = 5'h4 == p ? 2'h1 : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_127 = 5'h5 == p ? 2'h1 : _mem_q_T_125; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_129 = 5'h6 == p ? 2'h1 : _mem_q_T_127; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_131 = 5'h7 == p ? 2'h1 : _mem_q_T_129; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_133 = 5'h8 == p ? 2'h1 : _mem_q_T_131; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_135 = 5'h9 == p ? 2'h1 : _mem_q_T_133; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_137 = 5'ha == p ? 2'h2 : _mem_q_T_135; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_139 = 5'hb == p ? 2'h2 : _mem_q_T_137; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_141 = 5'hc == p ? 2'h2 : _mem_q_T_139; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_143 = 5'hd == p ? 2'h2 : _mem_q_T_141; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_145 = 5'he == p ? 2'h2 : _mem_q_T_143; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_147 = 5'hf == p ? 2'h2 : _mem_q_T_145; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_149 = 5'h10 == p ? 2'h2 : _mem_q_T_147; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_151 = 5'h11 == p ? 2'h2 : _mem_q_T_149; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_189 = 5'h12 == p ? 2'h2 : _mem_q_T_151; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_191 = 5'h13 == p ? 2'h2 : _mem_q_T_189; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_253 = 5'ha == p ? 2'h1 : _mem_q_T_135; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_255 = 5'hb == p ? 2'h1 : _mem_q_T_253; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_257 = 5'hc == p ? 2'h2 : _mem_q_T_255; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_259 = 5'hd == p ? 2'h2 : _mem_q_T_257; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_261 = 5'he == p ? 2'h2 : _mem_q_T_259; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_263 = 5'hf == p ? 2'h2 : _mem_q_T_261; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_265 = 5'h10 == p ? 2'h2 : _mem_q_T_263; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_267 = 5'h11 == p ? 2'h2 : _mem_q_T_265; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_269 = 5'h12 == p ? 2'h2 : _mem_q_T_267; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_271 = 5'h13 == p ? 2'h2 : _mem_q_T_269; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_273 = 5'h14 == p ? 2'h2 : _mem_q_T_271; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_275 = 5'h15 == p ? 2'h2 : _mem_q_T_273; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_277 = 3'h1 == mem_reg_d ? _mem_q_T_51 : _mem_q_T_23; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_279 = 3'h2 == mem_reg_d ? _mem_q_T_83 : _mem_q_T_277; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_281 = 3'h3 == mem_reg_d ? _mem_q_T_83 : _mem_q_T_279; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_283 = 3'h4 == mem_reg_d ? _mem_q_T_151 : _mem_q_T_281; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_285 = 3'h5 == mem_reg_d ? _mem_q_T_191 : _mem_q_T_283; // @[Mux.scala 81:58]
  wire [1:0] _mem_q_T_287 = 3'h6 == mem_reg_d ? _mem_q_T_191 : _mem_q_T_285; // @[Mux.scala 81:58]
  wire [1:0] mem_q = 3'h7 == mem_reg_d ? _mem_q_T_275 : _mem_q_T_287; // @[Mux.scala 81:58]
  wire [38:0] _mem_reg_dividend_T_1 = {$signed(mem_reg_dividend), 2'h0}; // @[Core.scala 1546:54]
  wire [36:0] _mem_reg_dividend_T_5 = {1'h0,mem_reg_divisor}; // @[Core.scala 1547:91]
  wire [36:0] _mem_reg_dividend_T_8 = $signed(mem_reg_dividend) - $signed(_mem_reg_dividend_T_5); // @[Core.scala 1547:52]
  wire [38:0] _mem_reg_dividend_T_9 = {$signed(_mem_reg_dividend_T_8), 2'h0}; // @[Core.scala 1547:95]
  wire [36:0] _mem_reg_dividend_T_13 = {mem_reg_divisor,1'h0}; // @[Core.scala 1548:91]
  wire [36:0] _mem_reg_dividend_T_16 = $signed(mem_reg_dividend) - $signed(_mem_reg_dividend_T_13); // @[Core.scala 1548:52]
  wire [38:0] _mem_reg_dividend_T_17 = {$signed(_mem_reg_dividend_T_16), 2'h0}; // @[Core.scala 1548:95]
  wire [38:0] _mem_reg_dividend_T_18 = mem_q[1] ? $signed(_mem_reg_dividend_T_17) : $signed(_mem_reg_dividend_T_1); // @[Mux.scala 101:16]
  wire [38:0] _mem_reg_dividend_T_19 = mem_q[0] ? $signed(_mem_reg_dividend_T_9) : $signed(_mem_reg_dividend_T_18); // @[Mux.scala 101:16]
  wire [33:0] _mem_reg_quotient_T = {mem_reg_quotient, 2'h0}; // @[Core.scala 1550:54]
  wire [33:0] _mem_reg_quotient_T_5 = _mem_reg_quotient_T + 34'h1; // @[Core.scala 1551:58]
  wire [33:0] _mem_reg_quotient_T_10 = _mem_reg_quotient_T + 34'h2; // @[Core.scala 1552:58]
  wire [33:0] _mem_reg_quotient_T_11 = mem_q[1] ? _mem_reg_quotient_T_10 : _mem_reg_quotient_T; // @[Mux.scala 101:16]
  wire [33:0] _mem_reg_quotient_T_12 = mem_q[0] ? _mem_reg_quotient_T_5 : _mem_reg_quotient_T_11; // @[Mux.scala 101:16]
  wire [36:0] _mem_reg_dividend_T_27 = $signed(mem_reg_dividend) + $signed(_mem_reg_dividend_T_5); // @[Core.scala 1556:52]
  wire [38:0] _mem_reg_dividend_T_28 = {$signed(_mem_reg_dividend_T_27), 2'h0}; // @[Core.scala 1556:95]
  wire [36:0] _mem_reg_dividend_T_35 = $signed(mem_reg_dividend) + $signed(_mem_reg_dividend_T_13); // @[Core.scala 1557:52]
  wire [38:0] _mem_reg_dividend_T_36 = {$signed(_mem_reg_dividend_T_35), 2'h0}; // @[Core.scala 1557:95]
  wire [38:0] _mem_reg_dividend_T_37 = mem_q[1] ? $signed(_mem_reg_dividend_T_36) : $signed(_mem_reg_dividend_T_1); // @[Mux.scala 101:16]
  wire [38:0] _mem_reg_dividend_T_38 = mem_q[0] ? $signed(_mem_reg_dividend_T_28) : $signed(_mem_reg_dividend_T_37); // @[Mux.scala 101:16]
  wire [33:0] _mem_reg_quotient_T_18 = _mem_reg_quotient_T - 34'h1; // @[Core.scala 1560:58]
  wire [33:0] _mem_reg_quotient_T_23 = _mem_reg_quotient_T - 34'h2; // @[Core.scala 1561:58]
  wire [33:0] _mem_reg_quotient_T_24 = mem_q[1] ? _mem_reg_quotient_T_23 : _mem_reg_quotient_T; // @[Mux.scala 101:16]
  wire [33:0] _mem_reg_quotient_T_25 = mem_q[0] ? _mem_reg_quotient_T_18 : _mem_reg_quotient_T_24; // @[Mux.scala 101:16]
  wire [38:0] _GEN_355 = _p_T_1 ? $signed(_mem_reg_dividend_T_19) : $signed(_mem_reg_dividend_T_38); // @[Core.scala 1545:51 1546:26 1555:26]
  wire [33:0] _GEN_356 = _p_T_1 ? _mem_reg_quotient_T_12 : _mem_reg_quotient_T_25; // @[Core.scala 1545:51 1550:26 1559:26]
  wire [4:0] _mem_reg_rem_shift_T_1 = mem_reg_rem_shift + 5'h1; // @[Core.scala 1564:46]
  wire [2:0] _GEN_357 = mem_reg_divrem_count == 5'h10 ? 3'h3 : mem_reg_divrem_state; // @[Core.scala 1566:44 1567:30 225:37]
  wire [5:0] _mem_reg_reminder_T = {mem_reg_rem_shift,1'h0}; // @[Cat.scala 31:58]
  wire [36:0] _mem_reg_reminder_T_1 = $signed(mem_reg_dividend) >>> _mem_reg_reminder_T; // @[Core.scala 1572:45]
  wire [31:0] _reminder_T_4 = mem_reg_reminder + mem_reg_init_divisor; // @[Core.scala 1578:26]
  wire [31:0] reminder = mem_reg_dividend[36] ? _reminder_T_4 : mem_reg_reminder; // @[Core.scala 1577:25]
  wire [31:0] _mem_reg_reminder_T_4 = ~reminder; // @[Core.scala 1585:11]
  wire [31:0] _mem_reg_reminder_T_6 = _mem_reg_reminder_T_4 + 32'h1; // @[Core.scala 1585:21]
  wire [31:0] _mem_reg_reminder_T_7 = ~mem_reg_sign_op1 ? reminder : _mem_reg_reminder_T_6; // @[Core.scala 1583:12]
  wire [31:0] _mem_reg_reminder_T_8 = mem_reg_zero_op2 ? mem_reg_orig_dividend : _mem_reg_reminder_T_7; // @[Core.scala 1581:30]
  wire [31:0] _quotient_T_3 = mem_reg_quotient - 32'h1; // @[Core.scala 1589:26]
  wire [31:0] quotient = mem_reg_dividend[36] ? _quotient_T_3 : mem_reg_quotient; // @[Core.scala 1588:25]
  wire [31:0] _mem_reg_quotient_T_27 = ~quotient; // @[Core.scala 1596:11]
  wire [31:0] _mem_reg_quotient_T_29 = _mem_reg_quotient_T_27 + 32'h1; // @[Core.scala 1596:21]
  wire [31:0] _mem_reg_quotient_T_30 = ~mem_reg_sign_op12 ? quotient : _mem_reg_quotient_T_29; // @[Core.scala 1594:12]
  wire [31:0] _mem_reg_quotient_T_31 = mem_reg_zero_op2 ? 32'hffffffff : _mem_reg_quotient_T_30; // @[Core.scala 1592:30]
  wire [2:0] _GEN_358 = 3'h5 == mem_reg_divrem_state ? 3'h0 : mem_reg_divrem_state; // @[Core.scala 1438:33 1603:28 225:37]
  wire [31:0] _GEN_359 = 3'h4 == mem_reg_divrem_state ? _mem_reg_reminder_T_8 : mem_reg_reminder; // @[Core.scala 1438:33 1581:24 1347:37]
  wire [31:0] _GEN_360 = 3'h4 == mem_reg_divrem_state ? _mem_reg_quotient_T_31 : mem_reg_quotient; // @[Core.scala 1438:33 1592:24 1348:37]
  wire [2:0] _GEN_361 = 3'h4 == mem_reg_divrem_state ? 3'h5 : _GEN_358; // @[Core.scala 1438:33 1599:28]
  wire [31:0] _GEN_362 = 3'h3 == mem_reg_divrem_state ? _mem_reg_reminder_T_1[31:0] : _GEN_359; // @[Core.scala 1438:33 1572:24]
  wire [2:0] _GEN_363 = 3'h3 == mem_reg_divrem_state ? 3'h4 : _GEN_361; // @[Core.scala 1438:33 1573:28]
  wire [31:0] _GEN_365 = 3'h3 == mem_reg_divrem_state ? mem_reg_quotient : _GEN_360; // @[Core.scala 1438:33 1348:37]
  wire [38:0] _GEN_366 = 3'h2 == mem_reg_divrem_state ? $signed(_GEN_355) : $signed({{2{mem_reg_dividend[36]}},
    mem_reg_dividend}); // @[Core.scala 1438:33 1340:37]
  wire [33:0] _GEN_367 = 3'h2 == mem_reg_divrem_state ? _GEN_356 : {{2'd0}, _GEN_365}; // @[Core.scala 1438:33]
  wire [38:0] _GEN_380 = 3'h1 == mem_reg_divrem_state ? $signed({{2{mem_reg_dividend[36]}},mem_reg_dividend}) : $signed(
    _GEN_366); // @[Core.scala 1438:33 1340:37]
  wire [33:0] _GEN_381 = 3'h1 == mem_reg_divrem_state ? {{2'd0}, mem_reg_quotient} : _GEN_367; // @[Core.scala 1438:33 1348:37]
  wire [38:0] _GEN_385 = 3'h0 == mem_reg_divrem_state ? $signed({{2{_mem_reg_dividend_T[36]}},_mem_reg_dividend_T}) :
    $signed(_GEN_380); // @[Core.scala 1438:33 1448:28]
  wire [33:0] _GEN_390 = 3'h0 == mem_reg_divrem_state ? 34'h0 : _GEN_381; // @[Core.scala 1438:33 1453:28]
  wire [31:0] mem_wb_rdata = io_dmem_rdata >> _io_dmem_wdata_T_1; // @[Core.scala 1622:36]
  wire  _mem_wb_data_load_T = mem_reg_mem_w == 32'h3; // @[Core.scala 1624:20]
  wire [23:0] _mem_wb_data_load_T_3 = mem_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_5 = {_mem_wb_data_load_T_3,mem_wb_rdata[7:0]}; // @[Core.scala 1615:40]
  wire  _mem_wb_data_load_T_6 = mem_reg_mem_w == 32'h2; // @[Core.scala 1625:20]
  wire [15:0] _mem_wb_data_load_T_9 = mem_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_11 = {_mem_wb_data_load_T_9,mem_wb_rdata[15:0]}; // @[Core.scala 1615:40]
  wire  _mem_wb_data_load_T_12 = mem_reg_mem_w == 32'h5; // @[Core.scala 1626:20]
  wire [31:0] _mem_wb_data_load_T_15 = {24'h0,mem_wb_rdata[7:0]}; // @[Core.scala 1618:31]
  wire  _mem_wb_data_load_T_16 = mem_reg_mem_w == 32'h4; // @[Core.scala 1627:20]
  wire [31:0] _mem_wb_data_load_T_19 = {16'h0,mem_wb_rdata[15:0]}; // @[Core.scala 1618:31]
  wire [31:0] _mem_wb_data_load_T_20 = _mem_wb_data_load_T_16 ? _mem_wb_data_load_T_19 : mem_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_21 = _mem_wb_data_load_T_12 ? _mem_wb_data_load_T_15 : _mem_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_22 = _mem_wb_data_load_T_6 ? _mem_wb_data_load_T_11 : _mem_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data_load = _mem_wb_data_load_T ? _mem_wb_data_load_T_5 : _mem_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T = mem_reg_wb_sel == 3'h6; // @[Core.scala 1631:21]
  wire  _mem_wb_data_T_4 = mem_reg_wb_sel == 3'h7; // @[Core.scala 1633:21]
  wire  _mem_wb_data_T_5 = mem_reg_wb_sel == 3'h4; // @[Core.scala 1634:21]
  wire [31:0] _mem_wb_data_T_6 = _mem_wb_data_T_5 ? mem_alu_muldiv_out : mem_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_7 = _mem_wb_data_T_4 ? csr_rdata : _mem_wb_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_8 = _mem_fw_data_T_2 ? mem_reg_pc_bit_out : _mem_wb_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data = _mem_wb_data_T ? mem_wb_data_load : _mem_wb_data_T_8; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h1; // @[Core.scala 1663:24]
  wire [38:0] _GEN_406 = reset ? $signed(39'sh0) : $signed(_GEN_385); // @[Core.scala 1340:{37,37}]
  wire [33:0] _GEN_408 = reset ? 34'h0 : _GEN_390; // @[Core.scala 1348:{37,37}]
  LongCounter cycle_counter ( // @[Core.scala 77:29]
    .clock(cycle_counter_clock),
    .reset(cycle_counter_reset),
    .io_value(cycle_counter_io_value)
  );
  MachineTimer mtimer ( // @[Core.scala 78:22]
    .clock(mtimer_clock),
    .reset(mtimer_reset),
    .io_mem_raddr(mtimer_io_mem_raddr),
    .io_mem_rdata(mtimer_io_mem_rdata),
    .io_mem_ren(mtimer_io_mem_ren),
    .io_mem_rvalid(mtimer_io_mem_rvalid),
    .io_mem_waddr(mtimer_io_mem_waddr),
    .io_mem_wen(mtimer_io_mem_wen),
    .io_mem_wdata(mtimer_io_mem_wdata),
    .io_intr(mtimer_io_intr),
    .io_mtime(mtimer_io_mtime)
  );
  BranchPredictor bp ( // @[Core.scala 356:18]
    .clock(bp_clock),
    .reset(bp_reset),
    .io_lu_inst_pc(bp_io_lu_inst_pc),
    .io_lu_br_hit(bp_io_lu_br_hit),
    .io_lu_br_pos(bp_io_lu_br_pos),
    .io_lu_br_addr(bp_io_lu_br_addr),
    .io_up_update_en(bp_io_up_update_en),
    .io_up_inst_pc(bp_io_up_inst_pc),
    .io_up_br_pos(bp_io_up_br_pos),
    .io_up_br_addr(bp_io_up_br_addr)
  );
  assign regfile_id_rs1_data_MPORT_en = 1'h1;
  assign regfile_id_rs1_data_MPORT_addr = id_inst[19:15];
  assign regfile_id_rs1_data_MPORT_data = regfile[regfile_id_rs1_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_id_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_rs2_data_MPORT_addr = id_inst[24:20];
  assign regfile_id_rs2_data_MPORT_data = regfile[regfile_id_rs2_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_id_c_rs1_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs1_data_MPORT_addr = id_inst[11:7];
  assign regfile_id_c_rs1_data_MPORT_data = regfile[regfile_id_c_rs1_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_id_c_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs2_data_MPORT_addr = id_inst[6:2];
  assign regfile_id_c_rs2_data_MPORT_data = regfile[regfile_id_c_rs2_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_id_c_rs1p_data_en = 1'h1;
  assign regfile_id_c_rs1p_data_addr = {2'h1,id_inst[9:7]};
  assign regfile_id_c_rs1p_data_data = regfile[regfile_id_c_rs1p_data_addr]; // @[Core.scala 74:20]
  assign regfile_id_c_rs2p_data_en = 1'h1;
  assign regfile_id_c_rs2p_data_addr = {2'h1,id_inst[4:2]};
  assign regfile_id_c_rs2p_data_data = regfile[regfile_id_c_rs2p_data_addr]; // @[Core.scala 74:20]
  assign regfile_id_sp_data_en = 1'h1;
  assign regfile_id_sp_data_addr = 5'h2;
  assign regfile_id_sp_data_data = regfile[regfile_id_sp_data_addr]; // @[Core.scala 74:20]
  assign regfile_ex1_op1_data_MPORT_en = 1'h1;
  assign regfile_ex1_op1_data_MPORT_addr = ex1_reg_rs1_addr;
  assign regfile_ex1_op1_data_MPORT_data = regfile[regfile_ex1_op1_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_ex1_op2_data_MPORT_en = 1'h1;
  assign regfile_ex1_op2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_op2_data_MPORT_data = regfile[regfile_ex1_op2_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_ex1_rs2_data_MPORT_en = 1'h1;
  assign regfile_ex1_rs2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_rs2_data_MPORT_data = regfile[regfile_ex1_rs2_data_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_io_gp_MPORT_en = 1'h1;
  assign regfile_io_gp_MPORT_addr = 5'h3;
  assign regfile_io_gp_MPORT_data = regfile[regfile_io_gp_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_io_exit_MPORT_en = 1'h1;
  assign regfile_io_exit_MPORT_addr = 5'h11;
  assign regfile_io_exit_MPORT_data = regfile[regfile_io_exit_MPORT_addr]; // @[Core.scala 74:20]
  assign regfile_MPORT_data = wb_reg_wb_data;
  assign regfile_MPORT_addr = wb_reg_wb_addr;
  assign regfile_MPORT_mask = 1'h1;
  assign regfile_MPORT_en = wb_reg_rf_wen;
  assign io_imem_addr = if1_is_jump ? ic_next_imem_addr : _GEN_70; // @[Core.scala 265:21 267:18]
  assign io_icache_control_invalidate = mem_mem_wen == 2'h3; // @[Core.scala 1612:48]
  assign io_dmem_raddr = mem_reg_alu_out; // @[Core.scala 1237:17]
  assign io_dmem_ren = mem_wb_sel == 3'h6; // @[Core.scala 1239:54]
  assign io_dmem_waddr = mem_reg_alu_out; // @[Core.scala 1238:17]
  assign io_dmem_wen = io_dmem_wready & _mem_stall_T_4; // @[Core.scala 1240:35]
  assign io_dmem_wstrb = mem_reg_mem_wstrb; // @[Core.scala 1241:17]
  assign io_dmem_wdata = _io_dmem_wdata_T_2[31:0]; // @[Core.scala 1242:71]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 88:17]
  assign io_mtimer_mem_rvalid = mtimer_io_mem_rvalid; // @[Core.scala 88:17]
  assign io_exit = mem_reg_is_trap & mem_reg_mcause == 32'hb & regfile_io_exit_MPORT_data == 32'h5d; // @[Core.scala 1679:73]
  assign io_debug_signal_mem_reg_pc = mem_reg_pc; // @[Core.scala 1670:30]
  assign io_debug_signal_mem_is_valid_inst = mem_reg_is_valid_inst & (_if2_inst_cnt_T_1 & _if2_inst_cnt_T); // @[Core.scala 1226:49]
  assign io_debug_signal_me_intr = csr_mstatus[3] & (|io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1227:77]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value[47:0]; // @[Core.scala 1667:58]
  assign io_debug_signal_id_pc = id_reg_pc; // @[Core.scala 1673:25]
  assign io_debug_signal_id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 457:20]
  assign cycle_counter_clock = clock;
  assign cycle_counter_reset = reset;
  assign mtimer_clock = clock;
  assign mtimer_reset = reset;
  assign mtimer_io_mem_raddr = io_mtimer_mem_raddr; // @[Core.scala 88:17]
  assign mtimer_io_mem_ren = io_mtimer_mem_ren; // @[Core.scala 88:17]
  assign mtimer_io_mem_waddr = io_mtimer_mem_waddr; // @[Core.scala 88:17]
  assign mtimer_io_mem_wen = io_mtimer_mem_wen; // @[Core.scala 88:17]
  assign mtimer_io_mem_wdata = io_mtimer_mem_wdata; // @[Core.scala 88:17]
  assign bp_clock = clock;
  assign bp_reset = reset;
  assign bp_io_lu_inst_pc = if1_is_jump ? if1_jump_addr : _GEN_76; // @[Core.scala 265:21 269:17]
  assign bp_io_up_update_en = ex3_bp_en & (ex3_reg_is_cond_br_inst | ex3_reg_is_uncond_br); // @[Core.scala 1154:35]
  assign bp_io_up_inst_pc = ex3_reg_pc; // @[Core.scala 1155:20]
  assign bp_io_up_br_pos = ex3_reg_is_cond_br | ex3_reg_is_uncond_br; // @[Core.scala 1156:41]
  assign bp_io_up_br_addr = ex3_reg_is_cond_br ? ex3_reg_cond_br_target : _bp_io_up_br_addr_T; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (regfile_MPORT_en & regfile_MPORT_mask) begin
      regfile[regfile_MPORT_addr] <= regfile_MPORT_data; // @[Core.scala 74:20]
    end
    if (reset) begin // @[Core.scala 76:32]
      csr_trap_vector <= 32'h0; // @[Core.scala 76:32]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1273:82]
      if (mem_reg_csr_addr == 12'h305) begin // @[Core.scala 1274:48]
        if (_csr_wdata_T) begin // @[Mux.scala 101:16]
          csr_trap_vector <= mem_reg_op1_data;
        end else begin
          csr_trap_vector <= _csr_wdata_T_7;
        end
      end
    end
    if (reset) begin // @[Core.scala 79:24]
      instret <= 64'h0; // @[Core.scala 79:24]
    end else if (wb_reg_is_valid_inst) begin // @[Core.scala 1662:31]
      instret <= _instret_T_1; // @[Core.scala 1663:13]
    end
    if (reset) begin // @[Core.scala 80:29]
      csr_mcause <= 32'h0; // @[Core.scala 80:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1289:24]
      csr_mcause <= 32'h8000000b; // @[Core.scala 1290:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1301:30]
      csr_mcause <= 32'h80000007; // @[Core.scala 1302:21]
    end else if (mem_is_trap) begin // @[Core.scala 1313:28]
      csr_mcause <= mem_reg_mcause; // @[Core.scala 1314:21]
    end
    if (reset) begin // @[Core.scala 81:29]
      csr_mtval <= 32'h0; // @[Core.scala 81:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1289:24]
      csr_mtval <= {{31'd0}, _csr_mtval_T_2}; // @[Core.scala 1291:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1301:30]
      csr_mtval <= 32'h0; // @[Core.scala 1303:21]
    end else if (mem_is_trap) begin // @[Core.scala 1313:28]
      csr_mtval <= 32'h0; // @[Core.scala 1315:21]
    end
    if (reset) begin // @[Core.scala 82:29]
      csr_mepc <= 32'h0; // @[Core.scala 82:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1289:24]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1292:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1301:30]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1304:21]
    end else if (mem_is_trap) begin // @[Core.scala 1313:28]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1316:21]
    end else begin
      csr_mepc <= _GEN_323;
    end
    if (reset) begin // @[Core.scala 83:29]
      csr_mstatus <= 32'h0; // @[Core.scala 83:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1289:24]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1298:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1301:30]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1310:21]
    end else if (mem_is_trap) begin // @[Core.scala 1313:28]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1322:21]
    end else begin
      csr_mstatus <= _GEN_327;
    end
    if (reset) begin // @[Core.scala 84:29]
      csr_mscratch <= 32'h0; // @[Core.scala 84:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1273:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1274:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1276:53]
          csr_mscratch <= _GEN_311;
        end
      end
    end
    if (reset) begin // @[Core.scala 85:29]
      csr_mie <= 32'h0; // @[Core.scala 85:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1273:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1274:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1276:53]
          csr_mie <= _GEN_312;
        end
      end
    end
    if (reset) begin // @[Core.scala 86:29]
      csr_mip <= 32'h0; // @[Core.scala 86:29]
    end else begin
      csr_mip <= _csr_mip_T_4; // @[Core.scala 1287:11]
    end
    if (reset) begin // @[Core.scala 94:38]
      id_reg_pc <= 32'h0; // @[Core.scala 94:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst)) begin // @[Core.scala 396:19]
        id_reg_pc <= if2_reg_pc;
      end else begin
        id_reg_pc <= ic_reg_addr_out;
      end
    end
    if (reset) begin // @[Core.scala 96:38]
      id_reg_inst <= 32'h0; // @[Core.scala 96:38]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (id_reg_stall) begin // @[Mux.scala 101:16]
      id_reg_inst <= if2_reg_inst;
    end else begin
      id_reg_inst <= _if2_inst_T_3;
    end
    if (reset) begin // @[Core.scala 97:38]
      id_reg_stall <= 1'h0; // @[Core.scala 97:38]
    end else begin
      id_reg_stall <= id_stall; // @[Core.scala 454:16]
    end
    if (reset) begin // @[Core.scala 98:38]
      id_reg_is_bp_pos <= 1'h0; // @[Core.scala 98:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Core.scala 419:26]
        id_reg_is_bp_pos <= if2_reg_is_bp_pos;
      end else begin
        id_reg_is_bp_pos <= _if2_is_bp_pos_T;
      end
    end
    if (reset) begin // @[Core.scala 99:38]
      id_reg_bp_addr <= 32'h0; // @[Core.scala 99:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= if2_reg_bp_addr;
      end else if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        id_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 100:38]
      id_reg_inst_cnt <= 2'h0; // @[Core.scala 100:38]
    end else if (~ex3_reg_is_br & ~mem_reg_is_br & id_reg_stall) begin // @[Core.scala 429:25]
      id_reg_inst_cnt <= if2_reg_inst_cnt;
    end else begin
      id_reg_inst_cnt <= _if2_inst_cnt_T_5;
    end
    if (reset) begin // @[Core.scala 106:38]
      ex1_reg_pc <= 32'h0; // @[Core.scala 106:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_pc <= _GEN_144;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_pc <= _GEN_144;
    end
    if (reset) begin // @[Core.scala 107:38]
      ex1_reg_inst_cnt <= 2'h0; // @[Core.scala 107:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_inst_cnt <= _GEN_145;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_inst_cnt <= _GEN_145;
    end
    if (reset) begin // @[Core.scala 108:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 108:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_wb_addr <= _GEN_153;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_wb_addr <= _GEN_153;
    end
    if (reset) begin // @[Core.scala 109:38]
      ex1_reg_op1_sel <= 3'h0; // @[Core.scala 109:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_op1_sel <= _GEN_146;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_op1_sel <= _GEN_146;
    end
    if (reset) begin // @[Core.scala 110:38]
      ex1_reg_op2_sel <= 4'h0; // @[Core.scala 110:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_op2_sel <= _GEN_147;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_op2_sel <= _GEN_147;
    end
    if (reset) begin // @[Core.scala 111:38]
      ex1_reg_rs1_addr <= 5'h0; // @[Core.scala 111:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_rs1_addr <= _GEN_148;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_rs1_addr <= _GEN_148;
    end
    if (reset) begin // @[Core.scala 112:38]
      ex1_reg_rs2_addr <= 5'h0; // @[Core.scala 112:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_rs2_addr <= _GEN_149;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_rs2_addr <= _GEN_149;
    end
    if (reset) begin // @[Core.scala 113:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 113:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_op1_data <= _GEN_150;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_op1_data <= _GEN_150;
    end
    if (reset) begin // @[Core.scala 114:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 114:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_op2_data <= _GEN_151;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_op2_data <= _GEN_151;
    end
    if (reset) begin // @[Core.scala 116:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 116:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_exe_fun <= 5'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 838:29]
      end else begin
        ex1_reg_exe_fun <= csignals_0; // @[Core.scala 869:29]
      end
    end
    if (reset) begin // @[Core.scala 117:38]
      ex1_reg_mem_wen <= 2'h0; // @[Core.scala 117:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_mem_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_mem_wen <= id_reg_mem_wen_delay; // @[Core.scala 847:29]
      end else begin
        ex1_reg_mem_wen <= csignals_3; // @[Core.scala 878:29]
      end
    end
    if (reset) begin // @[Core.scala 118:38]
      ex1_reg_rf_wen <= 1'h0; // @[Core.scala 118:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_rf_wen <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 837:29]
      end else begin
        ex1_reg_rf_wen <= csignals_4; // @[Core.scala 868:29]
      end
    end
    if (reset) begin // @[Core.scala 119:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 119:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_wb_sel <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 839:29]
      end else begin
        ex1_reg_wb_sel <= csignals_5; // @[Core.scala 870:29]
      end
    end
    if (reset) begin // @[Core.scala 120:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 120:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_csr_addr <= _GEN_158;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_csr_addr <= _GEN_158;
    end
    if (reset) begin // @[Core.scala 121:38]
      ex1_reg_csr_cmd <= 3'h0; // @[Core.scala 121:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_csr_cmd <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 846:29]
      end else begin
        ex1_reg_csr_cmd <= csignals_7; // @[Core.scala 877:29]
      end
    end
    if (reset) begin // @[Core.scala 124:38]
      ex1_reg_imm_b_sext <= 32'h0; // @[Core.scala 124:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_imm_b_sext <= _GEN_157;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_imm_b_sext <= _GEN_157;
    end
    if (reset) begin // @[Core.scala 127:38]
      ex1_reg_mem_w <= 32'h0; // @[Core.scala 127:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_mem_w <= 32'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 848:29]
      end else begin
        ex1_reg_mem_w <= {{29'd0}, csignals_8}; // @[Core.scala 879:29]
      end
    end
    if (reset) begin // @[Core.scala 128:39]
      ex1_reg_is_j <= 1'h0; // @[Core.scala 128:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_is_j <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_is_j <= id_reg_is_j_delay; // @[Core.scala 849:29]
      end else begin
        ex1_reg_is_j <= id_is_j; // @[Core.scala 880:29]
      end
    end
    if (reset) begin // @[Core.scala 129:39]
      ex1_reg_is_bp_pos <= 1'h0; // @[Core.scala 129:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_is_bp_pos <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos_delay; // @[Core.scala 850:29]
      end else begin
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos; // @[Core.scala 881:29]
      end
    end
    if (reset) begin // @[Core.scala 130:39]
      ex1_reg_bp_addr <= 32'h0; // @[Core.scala 130:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_bp_addr <= _GEN_160;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_bp_addr <= _GEN_160;
    end
    if (reset) begin // @[Core.scala 131:39]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 131:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_is_half <= _GEN_161;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_is_half <= _GEN_161;
    end
    if (reset) begin // @[Core.scala 132:39]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 132:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_is_valid_inst <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 853:29]
      end else begin
        ex1_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 884:29]
      end
    end
    if (reset) begin // @[Core.scala 133:39]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 133:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_is_trap <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      if (id_reg_stall) begin // @[Core.scala 826:24]
        ex1_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 854:29]
      end else begin
        ex1_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 885:29]
      end
    end
    if (reset) begin // @[Core.scala 134:39]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 134:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 768:41]
      ex1_reg_mcause <= _GEN_162;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 824:40]
      ex1_reg_mcause <= _GEN_162;
    end
    if (reset) begin // @[Core.scala 138:38]
      ex2_reg_pc <= 32'h0; // @[Core.scala 138:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 985:27]
    end
    if (reset) begin // @[Core.scala 139:38]
      ex2_reg_inst_cnt <= 2'h0; // @[Core.scala 139:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_inst_cnt <= ex1_reg_inst_cnt; // @[Core.scala 986:27]
    end
    if (reset) begin // @[Core.scala 140:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 140:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 990:27]
    end
    if (reset) begin // @[Core.scala 141:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 141:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (_ex1_op1_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= 32'h0;
      end else if (_ex1_op1_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= ex1_fw_data;
      end else begin
        ex2_reg_op1_data <= _ex1_op1_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 142:38]
      ex2_reg_op2_data <= 32'h0; // @[Core.scala 142:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (_ex1_op2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= 32'h0;
      end else if (_ex1_op2_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= ex1_fw_data;
      end else begin
        ex2_reg_op2_data <= _ex1_op2_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 143:38]
      ex2_reg_rs2_data <= 32'h0; // @[Core.scala 143:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (_ex1_op2_data_T_1) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= 32'h0;
      end else if (_ex1_rs2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= ex1_fw_data;
      end else begin
        ex2_reg_rs2_data <= _ex1_rs2_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 144:38]
      ex2_reg_exe_fun <= 5'h0; // @[Core.scala 144:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 992:33]
        ex2_reg_exe_fun <= 5'h0;
      end else begin
        ex2_reg_exe_fun <= ex1_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 145:38]
      ex2_reg_mem_wen <= 2'h0; // @[Core.scala 145:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 997:33]
        ex2_reg_mem_wen <= 2'h0;
      end else begin
        ex2_reg_mem_wen <= ex1_reg_mem_wen;
      end
    end
    if (reset) begin // @[Core.scala 146:38]
      ex2_reg_rf_wen <= 1'h0; // @[Core.scala 146:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 991:33]
        ex2_reg_rf_wen <= 1'h0;
      end else begin
        ex2_reg_rf_wen <= ex1_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 147:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 147:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 993:33]
        ex2_reg_wb_sel <= 3'h0;
      end else begin
        ex2_reg_wb_sel <= ex1_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 148:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 148:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 995:27]
    end
    if (reset) begin // @[Core.scala 149:38]
      ex2_reg_csr_cmd <= 3'h0; // @[Core.scala 149:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 996:33]
        ex2_reg_csr_cmd <= 3'h0;
      end else begin
        ex2_reg_csr_cmd <= ex1_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 150:38]
      ex2_reg_imm_b_sext <= 32'h0; // @[Core.scala 150:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_imm_b_sext <= ex1_reg_imm_b_sext; // @[Core.scala 994:27]
    end
    if (reset) begin // @[Core.scala 151:38]
      ex2_reg_mem_w <= 32'h0; // @[Core.scala 151:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 998:27]
    end
    if (reset) begin // @[Core.scala 152:38]
      ex2_is_uncond_br <= 1'h0; // @[Core.scala 152:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_is_uncond_br <= ex1_reg_is_j; // @[Core.scala 999:27]
    end
    if (reset) begin // @[Core.scala 153:38]
      ex2_reg_is_bp_pos <= 1'h0; // @[Core.scala 153:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_is_bp_pos <= ex1_reg_is_bp_pos; // @[Core.scala 1000:27]
    end
    if (reset) begin // @[Core.scala 154:38]
      ex2_reg_bp_addr <= 32'h0; // @[Core.scala 154:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_bp_addr <= ex1_reg_bp_addr; // @[Core.scala 1001:27]
    end
    if (reset) begin // @[Core.scala 155:38]
      ex2_reg_is_half <= 1'h0; // @[Core.scala 155:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_is_half <= ex1_reg_is_half; // @[Core.scala 1002:27]
    end
    if (reset) begin // @[Core.scala 156:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 156:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_is_valid_inst <= ex1_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 1003:27]
    end
    if (reset) begin // @[Core.scala 157:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 157:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      if (ex_is_bubble) begin // @[Core.scala 1004:33]
        ex2_reg_is_trap <= 1'h0;
      end else begin
        ex2_reg_is_trap <= ex1_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 158:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 158:38]
    end else if (_T_30) begin // @[Core.scala 983:20]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 1005:27]
    end
    if (reset) begin // @[Core.scala 162:41]
      ex3_reg_bp_en <= 1'h0; // @[Core.scala 162:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_bp_en <= ex2_reg_is_valid_inst & _if2_inst_cnt_T_1 & _if2_inst_cnt_T; // @[Core.scala 1121:30]
    end
    if (reset) begin // @[Core.scala 163:41]
      ex3_reg_pc <= 32'h0; // @[Core.scala 163:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_pc <= ex2_reg_pc; // @[Core.scala 1122:30]
    end
    if (reset) begin // @[Core.scala 164:41]
      ex3_reg_is_cond_br <= 1'h0; // @[Core.scala 164:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      if (_ex2_is_cond_br_T) begin // @[Mux.scala 101:16]
        ex3_reg_is_cond_br <= _ex2_is_cond_br_T_1;
      end else if (_ex2_is_cond_br_T_2) begin // @[Mux.scala 101:16]
        ex3_reg_is_cond_br <= _ex2_is_cond_br_T_4;
      end else begin
        ex3_reg_is_cond_br <= _ex2_is_cond_br_T_22;
      end
    end
    if (reset) begin // @[Core.scala 165:41]
      ex3_reg_is_cond_br_inst <= 1'h0; // @[Core.scala 165:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_is_cond_br_inst <= ex2_is_cond_br_inst; // @[Core.scala 1124:30]
    end
    if (reset) begin // @[Core.scala 166:41]
      ex3_reg_is_uncond_br <= 1'h0; // @[Core.scala 166:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_is_uncond_br <= ex2_is_uncond_br; // @[Core.scala 1125:30]
    end
    if (reset) begin // @[Core.scala 167:41]
      ex3_reg_cond_br_target <= 32'h0; // @[Core.scala 167:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_cond_br_target <= ex2_cond_br_target; // @[Core.scala 1126:30]
    end
    if (reset) begin // @[Core.scala 168:41]
      ex3_reg_uncond_br_target <= 32'h0; // @[Core.scala 168:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_uncond_br_target <= ex2_uncond_br_target; // @[Core.scala 1127:30]
    end
    if (reset) begin // @[Core.scala 170:41]
      ex3_reg_is_bp_pos <= 1'h0; // @[Core.scala 170:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_is_bp_pos <= ex2_reg_is_bp_pos; // @[Core.scala 1129:30]
    end
    if (reset) begin // @[Core.scala 171:41]
      ex3_reg_bp_addr <= 32'h0; // @[Core.scala 171:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_bp_addr <= ex2_reg_bp_addr; // @[Core.scala 1130:30]
    end
    if (reset) begin // @[Core.scala 172:41]
      ex3_reg_is_half <= 1'h0; // @[Core.scala 172:41]
    end else if (_T_30) begin // @[Core.scala 1120:21]
      ex3_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1131:30]
    end
    if (reset) begin // @[Core.scala 175:38]
      mem_reg_en <= 1'h0; // @[Core.scala 175:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_en <= _mem_is_valid_inst_T_2; // @[Core.scala 1179:24]
    end
    if (reset) begin // @[Core.scala 176:38]
      mem_reg_pc <= 32'h0; // @[Core.scala 176:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_pc <= ex2_reg_pc; // @[Core.scala 1180:24]
    end
    if (reset) begin // @[Core.scala 177:38]
      mem_reg_inst_cnt <= 2'h0; // @[Core.scala 177:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_inst_cnt <= ex2_reg_inst_cnt; // @[Core.scala 1181:24]
    end
    if (reset) begin // @[Core.scala 178:38]
      mem_reg_wb_addr <= 5'h0; // @[Core.scala 178:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_wb_addr <= ex2_reg_wb_addr; // @[Core.scala 1184:24]
    end
    if (reset) begin // @[Core.scala 179:38]
      mem_reg_op1_data <= 32'h0; // @[Core.scala 179:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_op1_data <= ex2_reg_op1_data; // @[Core.scala 1182:24]
    end
    if (reset) begin // @[Core.scala 180:38]
      mem_reg_rs2_data <= 32'h0; // @[Core.scala 180:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_rs2_data <= ex2_reg_rs2_data; // @[Core.scala 1183:24]
    end
    if (reset) begin // @[Core.scala 181:38]
      mem_reg_mullu <= 48'h0; // @[Core.scala 181:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mullu <= ex2_mullu; // @[Core.scala 1186:24]
    end
    if (reset) begin // @[Core.scala 182:38]
      mem_reg_mulls <= 48'sh0; // @[Core.scala 182:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mulls <= ex2_mulls; // @[Core.scala 1187:24]
    end
    if (reset) begin // @[Core.scala 183:38]
      mem_reg_mulhuu <= 48'h0; // @[Core.scala 183:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mulhuu <= ex2_mulhuu; // @[Core.scala 1188:24]
    end
    if (reset) begin // @[Core.scala 184:38]
      mem_reg_mulhss <= 48'sh0; // @[Core.scala 184:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mulhss <= ex2_mulhss; // @[Core.scala 1189:24]
    end
    if (reset) begin // @[Core.scala 185:38]
      mem_reg_mulhsu <= 48'sh0; // @[Core.scala 185:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mulhsu <= ex2_mulhsu; // @[Core.scala 1190:24]
    end
    if (reset) begin // @[Core.scala 186:38]
      mem_reg_exe_fun <= 5'h0; // @[Core.scala 186:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_exe_fun <= ex2_reg_exe_fun; // @[Core.scala 1192:24]
    end
    if (reset) begin // @[Core.scala 187:38]
      mem_reg_mem_wen <= 2'h0; // @[Core.scala 187:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mem_wen <= ex2_reg_mem_wen; // @[Core.scala 1198:24]
    end
    if (reset) begin // @[Core.scala 188:38]
      mem_reg_rf_wen <= 1'h0; // @[Core.scala 188:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_rf_wen <= ex2_reg_rf_wen; // @[Core.scala 1193:24]
    end
    if (reset) begin // @[Core.scala 189:38]
      mem_reg_wb_sel <= 3'h0; // @[Core.scala 189:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_wb_sel <= ex2_reg_wb_sel; // @[Core.scala 1194:24]
    end
    if (reset) begin // @[Core.scala 190:38]
      mem_reg_csr_addr <= 12'h0; // @[Core.scala 190:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_csr_addr <= ex2_reg_csr_addr; // @[Core.scala 1195:24]
    end
    if (reset) begin // @[Core.scala 191:38]
      mem_reg_csr_cmd <= 3'h0; // @[Core.scala 191:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_csr_cmd <= ex2_reg_csr_cmd; // @[Core.scala 1196:24]
    end
    if (reset) begin // @[Core.scala 193:38]
      mem_reg_alu_out <= 32'h0; // @[Core.scala 193:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_2;
      end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_5;
      end else begin
        mem_reg_alu_out <= _ex2_alu_out_T_69;
      end
    end
    if (reset) begin // @[Core.scala 194:38]
      mem_reg_pc_bit_out <= 32'h0; // @[Core.scala 194:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
        if (ex2_reg_is_half) begin // @[Core.scala 1039:24]
          mem_reg_pc_bit_out <= _ex2_next_pc_T_1;
        end else begin
          mem_reg_pc_bit_out <= _ex2_next_pc_T_3;
        end
      end else if (_ex2_alu_out_T_35) begin // @[Mux.scala 101:16]
        mem_reg_pc_bit_out <= _ex2_pc_bit_out_T_3;
      end else begin
        mem_reg_pc_bit_out <= _ex2_pc_bit_out_T_305;
      end
    end
    if (reset) begin // @[Core.scala 196:38]
      mem_reg_mem_w <= 32'h0; // @[Core.scala 196:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mem_w <= ex2_reg_mem_w; // @[Core.scala 1199:24]
    end
    if (reset) begin // @[Core.scala 197:38]
      mem_reg_mem_wstrb <= 4'h0; // @[Core.scala 197:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mem_wstrb <= _mem_reg_mem_wstrb_T_7[3:0]; // @[Core.scala 1200:24]
    end
    if (reset) begin // @[Core.scala 198:38]
      mem_reg_is_valid_inst <= 1'h0; // @[Core.scala 198:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_is_valid_inst <= _ex3_reg_bp_en_T_3; // @[Core.scala 1205:27]
    end
    if (reset) begin // @[Core.scala 199:38]
      mem_reg_is_trap <= 1'h0; // @[Core.scala 199:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_is_trap <= ex2_reg_is_trap; // @[Core.scala 1206:24]
    end
    if (reset) begin // @[Core.scala 200:38]
      mem_reg_mcause <= 32'h0; // @[Core.scala 200:38]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_mcause <= ex2_reg_mcause; // @[Core.scala 1207:24]
    end
    if (reset) begin // @[Core.scala 204:42]
      mem_reg_divrem <= 1'h0; // @[Core.scala 204:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_divrem <= ex2_divrem; // @[Core.scala 1209:31]
    end
    if (reset) begin // @[Core.scala 205:42]
      mem_reg_sign_op1 <= 1'h0; // @[Core.scala 205:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_sign_op1 <= ex2_sign_op1; // @[Core.scala 1212:31]
    end
    if (reset) begin // @[Core.scala 206:42]
      mem_reg_sign_op12 <= 1'h0; // @[Core.scala 206:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_sign_op12 <= ex2_sign_op12; // @[Core.scala 1213:31]
    end
    if (reset) begin // @[Core.scala 207:42]
      mem_reg_zero_op2 <= 1'h0; // @[Core.scala 207:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_zero_op2 <= ex2_zero_op2; // @[Core.scala 1214:31]
    end
    if (reset) begin // @[Core.scala 208:42]
      mem_reg_init_dividend <= 37'h0; // @[Core.scala 208:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      if (ex2_reg_exe_fun == 5'h1c | ex2_reg_exe_fun == 5'h1d) begin // @[Core.scala 1061:69]
        if (ex2_reg_op1_data[31]) begin // @[Core.scala 1063:49]
          mem_reg_init_dividend <= _ex2_dividend_T_5; // @[Core.scala 1064:20]
        end else begin
          mem_reg_init_dividend <= _ex2_dividend_T_8; // @[Core.scala 1066:20]
        end
      end else if (ex2_reg_exe_fun == 5'h1e | ex2_reg_exe_fun == 5'h1f) begin // @[Core.scala 1076:77]
        mem_reg_init_dividend <= _ex2_dividend_T_8; // @[Core.scala 1078:18]
      end else begin
        mem_reg_init_dividend <= 37'h0;
      end
    end
    if (reset) begin // @[Core.scala 209:42]
      mem_reg_init_divisor <= 32'h0; // @[Core.scala 209:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      if (ex2_reg_exe_fun == 5'h1c | ex2_reg_exe_fun == 5'h1d) begin // @[Core.scala 1061:69]
        if (ex2_reg_op2_data[31]) begin // @[Core.scala 1069:49]
          mem_reg_init_divisor <= _ex2_divisor_T_2; // @[Core.scala 1070:19]
        end else begin
          mem_reg_init_divisor <= ex2_reg_op2_data; // @[Core.scala 1073:19]
        end
      end else if (ex2_reg_exe_fun == 5'h1e | ex2_reg_exe_fun == 5'h1f) begin // @[Core.scala 1076:77]
        mem_reg_init_divisor <= ex2_reg_op2_data; // @[Core.scala 1080:17]
      end else begin
        mem_reg_init_divisor <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 210:42]
      mem_reg_orig_dividend <= 32'h0; // @[Core.scala 210:42]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_orig_dividend <= ex2_reg_op1_data; // @[Core.scala 1217:31]
    end
    if (reset) begin // @[Core.scala 213:38]
      wb_reg_wb_addr <= 5'h0; // @[Core.scala 213:38]
    end else begin
      wb_reg_wb_addr <= mem_reg_wb_addr; // @[Core.scala 1645:18]
    end
    if (reset) begin // @[Core.scala 214:38]
      wb_reg_rf_wen <= 1'h0; // @[Core.scala 214:38]
    end else begin
      wb_reg_rf_wen <= _T_30 & mem_rf_wen; // @[Core.scala 1646:18]
    end
    if (reset) begin // @[Core.scala 215:38]
      wb_reg_wb_data <= 32'h0; // @[Core.scala 215:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_11;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_fw_data_T_2) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= mem_reg_pc_bit_out;
    end else if (_mem_wb_data_T_4) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= csr_rdata;
    end else begin
      wb_reg_wb_data <= _mem_wb_data_T_6;
    end
    if (reset) begin // @[Core.scala 216:38]
      wb_reg_is_valid_inst <= 1'h0; // @[Core.scala 216:38]
    end else begin
      wb_reg_is_valid_inst <= mem_is_valid_inst & _T_30 & _mem_en_T_4 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1648:24]
    end
    if (reset) begin // @[Core.scala 218:35]
      if2_reg_is_bp_pos <= 1'h0; // @[Core.scala 218:35]
    end else if (!(id_reg_stall)) begin // @[Core.scala 419:26]
      if2_reg_is_bp_pos <= _if2_is_bp_pos_T;
    end
    if (reset) begin // @[Core.scala 219:35]
      if2_reg_bp_addr <= 32'h0; // @[Core.scala 219:35]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        if2_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 224:35]
      mem_reg_div_stall <= 1'h0; // @[Core.scala 224:35]
    end else if (_T_30) begin // @[Core.scala 1178:22]
      mem_reg_div_stall <= mem_div_stall_next | _mem_reg_div_stall_T_3; // @[Core.scala 1210:31]
    end else begin
      mem_reg_div_stall <= mem_div_stall_next | _mem_reg_div_stall_T_8; // @[Core.scala 1219:23]
    end
    if (reset) begin // @[Core.scala 225:37]
      mem_reg_divrem_state <= 3'h0; // @[Core.scala 225:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (mem_reg_divrem) begin // @[Core.scala 1440:29]
        mem_reg_divrem_state <= {{1'd0}, _GEN_348};
      end
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (mem_reg_p_divisor[63:36] == 28'h0) begin // @[Core.scala 1463:66]
        mem_reg_divrem_state <= 3'h2; // @[Core.scala 1464:30]
      end
    end else if (3'h2 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divrem_state <= _GEN_357;
    end else begin
      mem_reg_divrem_state <= _GEN_363;
    end
    if (reset) begin // @[Core.scala 226:35]
      ex3_reg_is_br <= 1'h0; // @[Core.scala 226:35]
    end else begin
      ex3_reg_is_br <= ex3_cond_bp_fail | ex3_cond_nbp_fail | ex3_uncond_bp_fail; // @[Core.scala 1152:17]
    end
    if (reset) begin // @[Core.scala 227:35]
      ex3_reg_br_target <= 32'h0; // @[Core.scala 227:35]
    end else if (ex3_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_cond_br_target;
    end else if (ex3_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (ex3_reg_is_half) begin // @[Core.scala 1149:30]
        ex3_reg_br_target <= _ex3_reg_br_target_T_1;
      end else begin
        ex3_reg_br_target <= _ex3_reg_br_target_T_3;
      end
    end else if (ex3_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_br_target <= 32'h0;
    end
    if (reset) begin // @[Core.scala 230:35]
      mem_reg_is_br <= 1'h0; // @[Core.scala 230:35]
    end else begin
      mem_reg_is_br <= _GEN_346;
    end
    if (reset) begin // @[Core.scala 231:35]
      mem_reg_br_addr <= 32'h0; // @[Core.scala 231:35]
    end else if (mem_is_meintr) begin // @[Core.scala 1289:24]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1300:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1301:30]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1312:21]
    end else if (mem_is_trap) begin // @[Core.scala 1313:28]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1324:21]
    end else begin
      mem_reg_br_addr <= _GEN_329;
    end
    if (reset) begin // @[Core.scala 240:32]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 240:32]
    end else if (if1_is_jump) begin // @[Core.scala 265:21]
      ic_reg_read_rdy <= ~if1_jump_addr[1]; // @[Core.scala 271:21]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
      ic_reg_read_rdy <= 1'h1; // @[Core.scala 259:19]
    end
    if (reset) begin // @[Core.scala 241:32]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 241:32]
    end else begin
      ic_reg_half_rdy <= _GEN_84;
    end
    if (reset) begin // @[Core.scala 243:33]
      ic_reg_imem_addr <= 32'h0; // @[Core.scala 243:33]
    end else if (if1_is_jump) begin // @[Core.scala 265:21]
      ic_reg_imem_addr <= ic_next_imem_addr; // @[Core.scala 267:18]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
      if (3'h0 == ic_state) begin // @[Core.scala 276:23]
        ic_reg_imem_addr <= ic_imem_addr_4; // @[Core.scala 278:22]
      end else begin
        ic_reg_imem_addr <= _GEN_50;
      end
    end
    if (reset) begin // @[Core.scala 244:32]
      ic_reg_addr_out <= 32'h0; // @[Core.scala 244:32]
    end else if (if1_is_jump) begin // @[Core.scala 265:21]
      if (mem_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= mem_reg_br_addr;
      end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= ex3_reg_br_target;
      end else begin
        ic_reg_addr_out <= _if1_jump_addr_T_1;
      end
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
      if (3'h0 == ic_state) begin // @[Core.scala 276:23]
        ic_reg_addr_out <= _GEN_2;
      end else begin
        ic_reg_addr_out <= _GEN_55;
      end
    end
    if (reset) begin // @[Core.scala 247:34]
      ic_reg_inst <= 32'h0; // @[Core.scala 247:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 265:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
        if (3'h0 == ic_state) begin // @[Core.scala 276:23]
          ic_reg_inst <= io_imem_inst; // @[Core.scala 280:21]
        end else begin
          ic_reg_inst <= _GEN_52;
        end
      end
    end
    if (reset) begin // @[Core.scala 248:34]
      ic_reg_inst_addr <= 32'h0; // @[Core.scala 248:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 265:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
        if (3'h0 == ic_state) begin // @[Core.scala 276:23]
          ic_reg_inst_addr <= ic_reg_imem_addr; // @[Core.scala 281:26]
        end else begin
          ic_reg_inst_addr <= _GEN_53;
        end
      end
    end
    if (reset) begin // @[Core.scala 249:34]
      ic_reg_inst2 <= 32'h0; // @[Core.scala 249:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 265:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 276:23]
          ic_reg_inst2 <= _GEN_57;
        end
      end
    end
    if (reset) begin // @[Core.scala 250:34]
      ic_reg_inst2_addr <= 32'h0; // @[Core.scala 250:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 265:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 276:23]
          ic_reg_inst2_addr <= _GEN_58;
        end
      end
    end
    if (reset) begin // @[Core.scala 252:25]
      ic_state <= 3'h0; // @[Core.scala 252:25]
    end else if (if1_is_jump) begin // @[Core.scala 265:21]
      ic_state <= {{2'd0}, if1_jump_addr[1]}; // @[Core.scala 270:14]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 272:94]
      if (3'h0 == ic_state) begin // @[Core.scala 276:23]
        ic_state <= _GEN_3;
      end else begin
        ic_state <= _GEN_56;
      end
    end
    if1_reg_first <= reset; // @[Core.scala 362:{30,30} 363:17]
    if (reset) begin // @[Core.scala 389:29]
      if2_reg_pc <= 32'h8000000; // @[Core.scala 389:29]
    end else if (!(id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst))) begin // @[Core.scala 396:19]
      if2_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 390:29]
      if2_reg_inst <= 32'h0; // @[Core.scala 390:29]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if2_reg_inst <= _if2_inst_T_3;
    end
    if (reset) begin // @[Core.scala 391:33]
      if2_reg_inst_cnt <= 2'h0; // @[Core.scala 391:33]
    end else if (!(~ex3_reg_is_br & ~mem_reg_is_br & id_reg_stall)) begin // @[Core.scala 429:25]
      if2_reg_inst_cnt <= _if2_inst_cnt_T_5;
    end
    if (reset) begin // @[Core.scala 894:38]
      ex1_reg_hazard <= 1'h0; // @[Core.scala 894:38]
    end else if (_T_30) begin // @[Core.scala 975:20]
      ex1_reg_hazard <= ex1_hazard & (ex1_reg_wb_sel == 3'h6 | ex1_reg_wb_sel == 3'h7 | ex1_reg_wb_sel == 3'h4 |
        ex1_reg_wb_sel == 3'h5); // @[Core.scala 978:20]
    end
    if (reset) begin // @[Core.scala 897:38]
      ex2_reg_hazard <= 1'h0; // @[Core.scala 897:38]
    end else if (_T_30) begin // @[Core.scala 1111:20]
      ex2_reg_hazard <= ex2_hazard & (ex2_reg_wb_sel == 3'h6 | ex2_reg_wb_sel == 3'h7 | ex2_reg_wb_sel == 3'h4); // @[Core.scala 1114:20]
    end
    if (reset) begin // @[Core.scala 1235:32]
      mem_stall_delay <= 1'h0; // @[Core.scala 1235:32]
    end else begin
      mem_stall_delay <= _mem_stall_T & io_dmem_rvalid & _T_30; // @[Core.scala 1247:19]
    end
    if (reset) begin // @[Core.scala 687:40]
      id_reg_pc_delay <= 32'h0; // @[Core.scala 687:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_pc_delay <= _GEN_90;
    end else begin
      id_reg_pc_delay <= _GEN_90;
    end
    if (reset) begin // @[Core.scala 688:40]
      id_reg_inst_cnt_delay <= 2'h0; // @[Core.scala 688:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_inst_cnt_delay <= _GEN_91;
    end else begin
      id_reg_inst_cnt_delay <= _GEN_91;
    end
    if (reset) begin // @[Core.scala 689:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 689:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_wb_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_wb_addr_delay <= _id_wb_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 690:40]
      id_reg_op1_sel_delay <= 3'h0; // @[Core.scala 690:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_op1_sel_delay <= 3'h0;
        end else begin
          id_reg_op1_sel_delay <= _id_m_op1_sel_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 691:40]
      id_reg_op2_sel_delay <= 4'h0; // @[Core.scala 691:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_op2_sel_delay <= 4'h1;
        end else begin
          id_reg_op2_sel_delay <= _id_m_op2_sel_T_2;
        end
      end
    end
    if (reset) begin // @[Core.scala 692:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 692:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_rs1_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 693:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 693:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_rs2_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 694:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 694:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= id_rs1_data;
        end else begin
          id_reg_op1_data_delay <= _id_op1_data_T_10;
        end
      end
    end
    if (reset) begin // @[Core.scala 695:40]
      id_reg_op2_data_delay <= 32'h0; // @[Core.scala 695:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_op2_data_T) begin // @[Mux.scala 101:16]
          id_reg_op2_data_delay <= id_rs2_data;
        end else begin
          id_reg_op2_data_delay <= _id_op2_data_T_28;
        end
      end
    end
    if (reset) begin // @[Core.scala 697:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 697:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 724:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h0;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_280;
      end
    end
    if (reset) begin // @[Core.scala 698:40]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 698:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 727:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else begin
        id_reg_mem_wen_delay <= _csignals_T_559;
      end
    end
    if (reset) begin // @[Core.scala 699:40]
      id_reg_rf_wen_delay <= 1'h0; // @[Core.scala 699:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_rf_wen_delay <= 1'h0; // @[Core.scala 723:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_rf_wen_delay <= csignals_4; // @[Core.scala 744:29]
    end
    if (reset) begin // @[Core.scala 700:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 700:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 725:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h6;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_745;
      end
    end
    if (reset) begin // @[Core.scala 701:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 701:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (csignals_7 == 3'h4) begin // @[Core.scala 651:24]
          id_reg_csr_addr_delay <= 12'h342;
        end else begin
          id_reg_csr_addr_delay <= id_imm_i;
        end
      end
    end
    if (reset) begin // @[Core.scala 702:40]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 702:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 726:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_931;
      end
    end
    if (reset) begin // @[Core.scala 705:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 705:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_imm_b_sext_delay <= id_c_imm_b;
        end else begin
          id_reg_imm_b_sext_delay <= id_imm_b_sext;
        end
      end
    end
    if (reset) begin // @[Core.scala 708:40]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 708:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 728:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_mem_w_delay <= {{29'd0}, csignals_8}; // @[Core.scala 755:29]
    end
    if (reset) begin // @[Core.scala 709:40]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 709:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 729:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_is_j_delay <= id_is_j; // @[Core.scala 756:29]
    end
    if (reset) begin // @[Core.scala 710:40]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 710:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 730:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_is_bp_pos_delay <= id_reg_is_bp_pos; // @[Core.scala 757:29]
    end
    if (reset) begin // @[Core.scala 711:40]
      id_reg_bp_addr_delay <= 32'h0; // @[Core.scala 711:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        id_reg_bp_addr_delay <= id_reg_bp_addr; // @[Core.scala 758:29]
      end
    end
    if (reset) begin // @[Core.scala 712:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 712:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        id_reg_is_half_delay <= id_is_half; // @[Core.scala 759:29]
      end
    end
    if (reset) begin // @[Core.scala 713:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 713:43]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 731:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 760:32]
    end
    if (reset) begin // @[Core.scala 714:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 714:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 718:41]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 732:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 733:30]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 761:29]
    end
    if (reset) begin // @[Core.scala 715:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 715:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 718:41]
      if (_ic_read_en4_T) begin // @[Core.scala 733:30]
        id_reg_mcause_delay <= 32'hb; // @[Core.scala 762:29]
      end
    end
    if (reset) begin // @[Core.scala 893:38]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 893:38]
    end else if (_T_30) begin // @[Core.scala 975:20]
      ex1_reg_fw_en <= _T_29 & ex1_hazard & ex1_reg_wb_sel != 3'h6 & ex1_reg_wb_sel != 3'h7; // @[Core.scala 977:19]
    end
    if (reset) begin // @[Core.scala 896:38]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 896:38]
    end else if (_T_30) begin // @[Core.scala 1111:20]
      ex2_reg_fw_en <= ex2_hazard & ex2_reg_wb_sel != 3'h6 & ex2_reg_wb_sel != 3'h7; // @[Core.scala 1113:19]
    end
    if (reset) begin // @[Core.scala 900:38]
      mem_reg_rf_wen_delay <= 1'h0; // @[Core.scala 900:38]
    end else begin
      mem_reg_rf_wen_delay <= mem_rf_wen; // @[Core.scala 1638:25]
    end
    if (reset) begin // @[Core.scala 902:38]
      mem_reg_wb_data_delay <= 32'h0; // @[Core.scala 902:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_11;
      end else begin
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_fw_data_T_2) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= mem_reg_pc_bit_out;
    end else if (_mem_wb_data_T_4) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= csr_rdata;
    end else begin
      mem_reg_wb_data_delay <= _mem_wb_data_T_6;
    end
    if (reset) begin // @[Core.scala 903:38]
      wb_reg_rf_wen_delay <= 1'h0; // @[Core.scala 903:38]
    end else begin
      wb_reg_rf_wen_delay <= wb_reg_rf_wen; // @[Core.scala 1658:24]
    end
    if (reset) begin // @[Core.scala 904:38]
      wb_reg_wb_addr_delay <= 5'h0; // @[Core.scala 904:38]
    end else begin
      wb_reg_wb_addr_delay <= wb_reg_wb_addr; // @[Core.scala 1659:24]
    end
    if (reset) begin // @[Core.scala 905:38]
      wb_reg_wb_data_delay <= 32'h0; // @[Core.scala 905:38]
    end else begin
      wb_reg_wb_data_delay <= wb_reg_wb_data; // @[Core.scala 1660:24]
    end
    mem_reg_dividend <= _GEN_406[36:0]; // @[Core.scala 1340:{37,37}]
    if (reset) begin // @[Core.scala 1341:37]
      mem_reg_divisor <= 36'h0; // @[Core.scala 1341:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divisor <= _mem_reg_divisor_T_1; // @[Core.scala 1449:28]
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divisor <= mem_reg_p_divisor[37:2]; // @[Core.scala 1467:28]
    end
    if (reset) begin // @[Core.scala 1342:37]
      mem_reg_p_divisor <= 64'h0; // @[Core.scala 1342:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_p_divisor <= _mem_reg_p_divisor_T; // @[Core.scala 1450:28]
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_p_divisor <= {{2'd0}, mem_reg_p_divisor[63:2]}; // @[Core.scala 1466:28]
    end
    if (reset) begin // @[Core.scala 1343:37]
      mem_reg_divrem_count <= 5'h0; // @[Core.scala 1343:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divrem_count <= 5'h0; // @[Core.scala 1451:28]
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divrem_count <= _mem_reg_divrem_count_T_1; // @[Core.scala 1468:28]
    end else if (3'h2 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_divrem_count <= _mem_reg_divrem_count_T_1; // @[Core.scala 1565:28]
    end
    if (reset) begin // @[Core.scala 1344:37]
      mem_reg_rem_shift <= 5'h0; // @[Core.scala 1344:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      mem_reg_rem_shift <= 5'h0; // @[Core.scala 1452:28]
    end else if (!(3'h1 == mem_reg_divrem_state)) begin // @[Core.scala 1438:33]
      if (3'h2 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
        mem_reg_rem_shift <= _mem_reg_rem_shift_T_1; // @[Core.scala 1564:25]
      end
    end
    if (reset) begin // @[Core.scala 1345:37]
      mem_reg_extra_shift <= 1'h0; // @[Core.scala 1345:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (~mem_reg_init_divisor[1]) begin // @[Core.scala 1454:46]
        mem_reg_extra_shift <= 1'h0; // @[Core.scala 1455:29]
      end else begin
        mem_reg_extra_shift <= 1'h1; // @[Core.scala 1458:29]
      end
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (~mem_reg_p_divisor[35]) begin // @[Core.scala 1469:52]
        mem_reg_extra_shift <= 1'h0; // @[Core.scala 1470:29]
      end else begin
        mem_reg_extra_shift <= 1'h1; // @[Core.scala 1473:29]
      end
    end
    if (reset) begin // @[Core.scala 1346:37]
      mem_reg_d <= 3'h0; // @[Core.scala 1346:37]
    end else if (3'h0 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (~mem_reg_init_divisor[1]) begin // @[Core.scala 1454:46]
        mem_reg_d <= 3'h0; // @[Core.scala 1456:29]
      end else begin
        mem_reg_d <= _mem_reg_d_T_1; // @[Core.scala 1459:29]
      end
    end else if (3'h1 == mem_reg_divrem_state) begin // @[Core.scala 1438:33]
      if (~mem_reg_p_divisor[35]) begin // @[Core.scala 1469:52]
        mem_reg_d <= mem_reg_p_divisor[33:31]; // @[Core.scala 1471:29]
      end else begin
        mem_reg_d <= mem_reg_p_divisor[34:32]; // @[Core.scala 1474:29]
      end
    end
    if (reset) begin // @[Core.scala 1347:37]
      mem_reg_reminder <= 32'h0; // @[Core.scala 1347:37]
    end else if (!(3'h0 == mem_reg_divrem_state)) begin // @[Core.scala 1438:33]
      if (!(3'h1 == mem_reg_divrem_state)) begin // @[Core.scala 1438:33]
        if (!(3'h2 == mem_reg_divrem_state)) begin // @[Core.scala 1438:33]
          mem_reg_reminder <= _GEN_362;
        end
      end
    end
    mem_reg_quotient <= _GEN_408[31:0]; // @[Core.scala 1348:{37,37}]
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",ic_reg_addr_out,ic_data_out); // @[Core.scala 432:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"inst: %x, ic_reg_read_rdy: %d, ic_state: %d\n",if2_inst,ic_reg_read_rdy,ic_state); // @[Core.scala 433:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"if2_pc           : 0x%x\n",if2_pc); // @[Core.scala 1682:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 1683:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"if2_reg_is_bp_pos: 0x%x\n",if2_reg_is_bp_pos); // @[Core.scala 1684:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"bp.io.lu.br_hit  : 0x%x\n",bp_io_lu_br_hit); // @[Core.scala 1685:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"bp.io.lu.br_pos  : 0x%x\n",bp_io_lu_br_pos); // @[Core.scala 1686:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",id_reg_pc); // @[Core.scala 1687:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 1688:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_reg_inst_cnt  : 0x%x\n",id_reg_inst_cnt); // @[Core.scala 1689:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 1690:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 1691:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_rs1_data      : 0x%x\n",id_rs1_data); // @[Core.scala 1692:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_rs2_data      : 0x%x\n",id_rs2_data); // @[Core.scala 1693:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"id_wb_addr       : 0x%x\n",id_wb_addr); // @[Core.scala 1694:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",ex1_reg_pc); // @[Core.scala 1695:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_reg_inst_cnt : 0x%x\n",ex1_reg_inst_cnt); // @[Core.scala 1696:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_reg_is_valid_: 0x%x\n",ex1_reg_is_valid_inst); // @[Core.scala 1697:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_stall        : 0x%x\n",ex1_stall); // @[Core.scala 1698:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_op1_data     : 0x%x\n",ex1_op1_data); // @[Core.scala 1699:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex1_op2_data     : 0x%x\n",ex1_op2_data); // @[Core.scala 1700:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",ex2_reg_pc); // @[Core.scala 1703:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_inst_cnt : 0x%x\n",ex2_reg_inst_cnt); // @[Core.scala 1704:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_is_valid_: 0x%x\n",ex2_reg_is_valid_inst); // @[Core.scala 1705:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_op1_data : 0x%x\n",ex2_reg_op1_data); // @[Core.scala 1706:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_op2_data : 0x%x\n",ex2_reg_op2_data); // @[Core.scala 1707:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_alu_out      : 0x%x\n",ex2_alu_out); // @[Core.scala 1708:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_exe_fun  : 0x%x\n",ex2_reg_exe_fun); // @[Core.scala 1709:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_wb_sel   : 0x%x\n",ex2_reg_wb_sel); // @[Core.scala 1710:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_is_bp_pos : 0x%x\n",ex2_reg_is_bp_pos); // @[Core.scala 1711:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex2_reg_bp_addr  : 0x%x\n",ex2_reg_bp_addr); // @[Core.scala 1712:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex3_reg_pc       : 0x%x\n",ex3_reg_pc); // @[Core.scala 1713:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex3_reg_is_br    : 0x%x\n",ex3_reg_is_br); // @[Core.scala 1714:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"ex3_reg_br_target : 0x%x\n",ex3_reg_br_target); // @[Core.scala 1715:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_pc       : 0x%x\n",mem_reg_pc); // @[Core.scala 1716:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_inst_cnt : 0x%x\n",mem_reg_inst_cnt); // @[Core.scala 1717:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_is_valid_inst: 0x%x\n",mem_is_valid_inst); // @[Core.scala 1718:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_stall        : 0x%x\n",mem_stall); // @[Core.scala 1719:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_wb_data      : 0x%x\n",mem_wb_data); // @[Core.scala 1720:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_alu_muldiv_ou: 0x%x\n",mem_alu_muldiv_out); // @[Core.scala 1721:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_mem_w    : 0x%x\n",mem_reg_mem_w); // @[Core.scala 1722:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_wb_addr  : 0x%x\n",mem_reg_wb_addr); // @[Core.scala 1723:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_is_meintr    : %d\n",mem_is_meintr); // @[Core.scala 1724:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_is_mtintr    : %d\n",mem_is_mtintr); // @[Core.scala 1725:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_rf_wen_delay : 0x%x\n",mem_reg_rf_wen_delay); // @[Core.scala 1726:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_wb_addr_delay : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1727:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"mem_reg_wb_data_delay : 0x%x\n",mem_reg_wb_data_delay); // @[Core.scala 1728:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"wb_reg_wb_addr   : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1729:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"wb_reg_is_valid_i: 0x%x\n",wb_reg_is_valid_inst); // @[Core.scala 1730:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"wb_reg_wb_data   : 0x%x\n",wb_reg_wb_data); // @[Core.scala 1731:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 1732:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"cycle_counter(%d) : %d\n",io_exit,io_debug_signal_cycle_counter); // @[Core.scala 1733:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_21) begin
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 1734:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regfile[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  csr_trap_vector = _RAND_1[31:0];
  _RAND_2 = {2{`RANDOM}};
  instret = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  csr_mcause = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  csr_mtval = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  csr_mepc = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  csr_mstatus = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  csr_mscratch = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  csr_mie = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  csr_mip = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  id_reg_pc = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  id_reg_inst = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  id_reg_stall = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  id_reg_is_bp_pos = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  id_reg_bp_addr = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  id_reg_inst_cnt = _RAND_15[1:0];
  _RAND_16 = {1{`RANDOM}};
  ex1_reg_pc = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  ex1_reg_inst_cnt = _RAND_17[1:0];
  _RAND_18 = {1{`RANDOM}};
  ex1_reg_wb_addr = _RAND_18[4:0];
  _RAND_19 = {1{`RANDOM}};
  ex1_reg_op1_sel = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  ex1_reg_op2_sel = _RAND_20[3:0];
  _RAND_21 = {1{`RANDOM}};
  ex1_reg_rs1_addr = _RAND_21[4:0];
  _RAND_22 = {1{`RANDOM}};
  ex1_reg_rs2_addr = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  ex1_reg_op1_data = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  ex1_reg_op2_data = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  ex1_reg_exe_fun = _RAND_25[4:0];
  _RAND_26 = {1{`RANDOM}};
  ex1_reg_mem_wen = _RAND_26[1:0];
  _RAND_27 = {1{`RANDOM}};
  ex1_reg_rf_wen = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  ex1_reg_wb_sel = _RAND_28[2:0];
  _RAND_29 = {1{`RANDOM}};
  ex1_reg_csr_addr = _RAND_29[11:0];
  _RAND_30 = {1{`RANDOM}};
  ex1_reg_csr_cmd = _RAND_30[2:0];
  _RAND_31 = {1{`RANDOM}};
  ex1_reg_imm_b_sext = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  ex1_reg_mem_w = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  ex1_reg_is_j = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  ex1_reg_is_bp_pos = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  ex1_reg_bp_addr = _RAND_35[31:0];
  _RAND_36 = {1{`RANDOM}};
  ex1_reg_is_half = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  ex1_reg_is_valid_inst = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  ex1_reg_is_trap = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  ex1_reg_mcause = _RAND_39[31:0];
  _RAND_40 = {1{`RANDOM}};
  ex2_reg_pc = _RAND_40[31:0];
  _RAND_41 = {1{`RANDOM}};
  ex2_reg_inst_cnt = _RAND_41[1:0];
  _RAND_42 = {1{`RANDOM}};
  ex2_reg_wb_addr = _RAND_42[4:0];
  _RAND_43 = {1{`RANDOM}};
  ex2_reg_op1_data = _RAND_43[31:0];
  _RAND_44 = {1{`RANDOM}};
  ex2_reg_op2_data = _RAND_44[31:0];
  _RAND_45 = {1{`RANDOM}};
  ex2_reg_rs2_data = _RAND_45[31:0];
  _RAND_46 = {1{`RANDOM}};
  ex2_reg_exe_fun = _RAND_46[4:0];
  _RAND_47 = {1{`RANDOM}};
  ex2_reg_mem_wen = _RAND_47[1:0];
  _RAND_48 = {1{`RANDOM}};
  ex2_reg_rf_wen = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  ex2_reg_wb_sel = _RAND_49[2:0];
  _RAND_50 = {1{`RANDOM}};
  ex2_reg_csr_addr = _RAND_50[11:0];
  _RAND_51 = {1{`RANDOM}};
  ex2_reg_csr_cmd = _RAND_51[2:0];
  _RAND_52 = {1{`RANDOM}};
  ex2_reg_imm_b_sext = _RAND_52[31:0];
  _RAND_53 = {1{`RANDOM}};
  ex2_reg_mem_w = _RAND_53[31:0];
  _RAND_54 = {1{`RANDOM}};
  ex2_is_uncond_br = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  ex2_reg_is_bp_pos = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  ex2_reg_bp_addr = _RAND_56[31:0];
  _RAND_57 = {1{`RANDOM}};
  ex2_reg_is_half = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  ex2_reg_is_valid_inst = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  ex2_reg_is_trap = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  ex2_reg_mcause = _RAND_60[31:0];
  _RAND_61 = {1{`RANDOM}};
  ex3_reg_bp_en = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  ex3_reg_pc = _RAND_62[31:0];
  _RAND_63 = {1{`RANDOM}};
  ex3_reg_is_cond_br = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  ex3_reg_is_cond_br_inst = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  ex3_reg_is_uncond_br = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  ex3_reg_cond_br_target = _RAND_66[31:0];
  _RAND_67 = {1{`RANDOM}};
  ex3_reg_uncond_br_target = _RAND_67[31:0];
  _RAND_68 = {1{`RANDOM}};
  ex3_reg_is_bp_pos = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  ex3_reg_bp_addr = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  ex3_reg_is_half = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  mem_reg_en = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  mem_reg_pc = _RAND_72[31:0];
  _RAND_73 = {1{`RANDOM}};
  mem_reg_inst_cnt = _RAND_73[1:0];
  _RAND_74 = {1{`RANDOM}};
  mem_reg_wb_addr = _RAND_74[4:0];
  _RAND_75 = {1{`RANDOM}};
  mem_reg_op1_data = _RAND_75[31:0];
  _RAND_76 = {1{`RANDOM}};
  mem_reg_rs2_data = _RAND_76[31:0];
  _RAND_77 = {2{`RANDOM}};
  mem_reg_mullu = _RAND_77[47:0];
  _RAND_78 = {2{`RANDOM}};
  mem_reg_mulls = _RAND_78[47:0];
  _RAND_79 = {2{`RANDOM}};
  mem_reg_mulhuu = _RAND_79[47:0];
  _RAND_80 = {2{`RANDOM}};
  mem_reg_mulhss = _RAND_80[47:0];
  _RAND_81 = {2{`RANDOM}};
  mem_reg_mulhsu = _RAND_81[47:0];
  _RAND_82 = {1{`RANDOM}};
  mem_reg_exe_fun = _RAND_82[4:0];
  _RAND_83 = {1{`RANDOM}};
  mem_reg_mem_wen = _RAND_83[1:0];
  _RAND_84 = {1{`RANDOM}};
  mem_reg_rf_wen = _RAND_84[0:0];
  _RAND_85 = {1{`RANDOM}};
  mem_reg_wb_sel = _RAND_85[2:0];
  _RAND_86 = {1{`RANDOM}};
  mem_reg_csr_addr = _RAND_86[11:0];
  _RAND_87 = {1{`RANDOM}};
  mem_reg_csr_cmd = _RAND_87[2:0];
  _RAND_88 = {1{`RANDOM}};
  mem_reg_alu_out = _RAND_88[31:0];
  _RAND_89 = {1{`RANDOM}};
  mem_reg_pc_bit_out = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  mem_reg_mem_w = _RAND_90[31:0];
  _RAND_91 = {1{`RANDOM}};
  mem_reg_mem_wstrb = _RAND_91[3:0];
  _RAND_92 = {1{`RANDOM}};
  mem_reg_is_valid_inst = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  mem_reg_is_trap = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  mem_reg_mcause = _RAND_94[31:0];
  _RAND_95 = {1{`RANDOM}};
  mem_reg_divrem = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  mem_reg_sign_op1 = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  mem_reg_sign_op12 = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  mem_reg_zero_op2 = _RAND_98[0:0];
  _RAND_99 = {2{`RANDOM}};
  mem_reg_init_dividend = _RAND_99[36:0];
  _RAND_100 = {1{`RANDOM}};
  mem_reg_init_divisor = _RAND_100[31:0];
  _RAND_101 = {1{`RANDOM}};
  mem_reg_orig_dividend = _RAND_101[31:0];
  _RAND_102 = {1{`RANDOM}};
  wb_reg_wb_addr = _RAND_102[4:0];
  _RAND_103 = {1{`RANDOM}};
  wb_reg_rf_wen = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  wb_reg_wb_data = _RAND_104[31:0];
  _RAND_105 = {1{`RANDOM}};
  wb_reg_is_valid_inst = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  if2_reg_is_bp_pos = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  if2_reg_bp_addr = _RAND_107[31:0];
  _RAND_108 = {1{`RANDOM}};
  mem_reg_div_stall = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  mem_reg_divrem_state = _RAND_109[2:0];
  _RAND_110 = {1{`RANDOM}};
  ex3_reg_is_br = _RAND_110[0:0];
  _RAND_111 = {1{`RANDOM}};
  ex3_reg_br_target = _RAND_111[31:0];
  _RAND_112 = {1{`RANDOM}};
  mem_reg_is_br = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  mem_reg_br_addr = _RAND_113[31:0];
  _RAND_114 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  ic_reg_imem_addr = _RAND_116[31:0];
  _RAND_117 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_117[31:0];
  _RAND_118 = {1{`RANDOM}};
  ic_reg_inst = _RAND_118[31:0];
  _RAND_119 = {1{`RANDOM}};
  ic_reg_inst_addr = _RAND_119[31:0];
  _RAND_120 = {1{`RANDOM}};
  ic_reg_inst2 = _RAND_120[31:0];
  _RAND_121 = {1{`RANDOM}};
  ic_reg_inst2_addr = _RAND_121[31:0];
  _RAND_122 = {1{`RANDOM}};
  ic_state = _RAND_122[2:0];
  _RAND_123 = {1{`RANDOM}};
  if1_reg_first = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  if2_reg_pc = _RAND_124[31:0];
  _RAND_125 = {1{`RANDOM}};
  if2_reg_inst = _RAND_125[31:0];
  _RAND_126 = {1{`RANDOM}};
  if2_reg_inst_cnt = _RAND_126[1:0];
  _RAND_127 = {1{`RANDOM}};
  ex1_reg_hazard = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  ex2_reg_hazard = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  mem_stall_delay = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_130[31:0];
  _RAND_131 = {1{`RANDOM}};
  id_reg_inst_cnt_delay = _RAND_131[1:0];
  _RAND_132 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_132[4:0];
  _RAND_133 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_133[2:0];
  _RAND_134 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_134[3:0];
  _RAND_135 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_135[4:0];
  _RAND_136 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_136[4:0];
  _RAND_137 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_137[31:0];
  _RAND_138 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_138[31:0];
  _RAND_139 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_139[4:0];
  _RAND_140 = {1{`RANDOM}};
  id_reg_mem_wen_delay = _RAND_140[1:0];
  _RAND_141 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_141[0:0];
  _RAND_142 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_142[2:0];
  _RAND_143 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_143[11:0];
  _RAND_144 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_144[2:0];
  _RAND_145 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_145[31:0];
  _RAND_146 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_146[31:0];
  _RAND_147 = {1{`RANDOM}};
  id_reg_is_j_delay = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  id_reg_is_bp_pos_delay = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  id_reg_bp_addr_delay = _RAND_149[31:0];
  _RAND_150 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_150[0:0];
  _RAND_151 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_151[0:0];
  _RAND_152 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_152[0:0];
  _RAND_153 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_153[31:0];
  _RAND_154 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_154[0:0];
  _RAND_155 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_155[0:0];
  _RAND_156 = {1{`RANDOM}};
  mem_reg_rf_wen_delay = _RAND_156[0:0];
  _RAND_157 = {1{`RANDOM}};
  mem_reg_wb_data_delay = _RAND_157[31:0];
  _RAND_158 = {1{`RANDOM}};
  wb_reg_rf_wen_delay = _RAND_158[0:0];
  _RAND_159 = {1{`RANDOM}};
  wb_reg_wb_addr_delay = _RAND_159[4:0];
  _RAND_160 = {1{`RANDOM}};
  wb_reg_wb_data_delay = _RAND_160[31:0];
  _RAND_161 = {2{`RANDOM}};
  mem_reg_dividend = _RAND_161[36:0];
  _RAND_162 = {2{`RANDOM}};
  mem_reg_divisor = _RAND_162[35:0];
  _RAND_163 = {2{`RANDOM}};
  mem_reg_p_divisor = _RAND_163[63:0];
  _RAND_164 = {1{`RANDOM}};
  mem_reg_divrem_count = _RAND_164[4:0];
  _RAND_165 = {1{`RANDOM}};
  mem_reg_rem_shift = _RAND_165[4:0];
  _RAND_166 = {1{`RANDOM}};
  mem_reg_extra_shift = _RAND_166[0:0];
  _RAND_167 = {1{`RANDOM}};
  mem_reg_d = _RAND_167[2:0];
  _RAND_168 = {1{`RANDOM}};
  mem_reg_reminder = _RAND_168[31:0];
  _RAND_169 = {1{`RANDOM}};
  mem_reg_quotient = _RAND_169[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input          clock,
  input          reset,
  input          io_imem_en,
  input  [31:0]  io_imem_addr,
  output [31:0]  io_imem_inst,
  output         io_imem_valid,
  input          io_icache_control_invalidate,
  output         io_icache_control_busy,
  input  [31:0]  io_dmem_raddr,
  output [31:0]  io_dmem_rdata,
  input          io_dmem_ren,
  output         io_dmem_rvalid,
  input  [31:0]  io_dmem_waddr,
  input          io_dmem_wen,
  output         io_dmem_wready,
  input  [3:0]   io_dmem_wstrb,
  input  [31:0]  io_dmem_wdata,
  output         io_dramPort_ren,
  output         io_dramPort_wen,
  output [27:0]  io_dramPort_addr,
  output [127:0] io_dramPort_wdata,
  input          io_dramPort_init_calib_complete,
  input  [127:0] io_dramPort_rdata,
  input          io_dramPort_rdata_valid,
  input          io_dramPort_busy,
  output         io_cache_array1_en,
  output [31:0]  io_cache_array1_we,
  output [6:0]   io_cache_array1_addr,
  output [255:0] io_cache_array1_wdata,
  input  [255:0] io_cache_array1_rdata,
  output         io_cache_array2_en,
  output [31:0]  io_cache_array2_we,
  output [6:0]   io_cache_array2_addr,
  output [255:0] io_cache_array2_wdata,
  input  [255:0] io_cache_array2_rdata,
  output         io_icache_ren,
  output         io_icache_wen,
  output [9:0]   io_icache_raddr,
  input  [31:0]  io_icache_rdata,
  output [6:0]   io_icache_waddr,
  output [255:0] io_icache_wdata,
  output         io_icache_valid_ren,
  output         io_icache_valid_wen,
  output         io_icache_valid_invalidate,
  output [5:0]   io_icache_valid_addr,
  output         io_icache_valid_iaddr,
  input  [1:0]   io_icache_valid_rdata,
  output [1:0]   io_icache_valid_wdata
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [127:0] _RAND_8;
  reg [127:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [255:0] _RAND_23;
  reg [255:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
`endif // RANDOMIZE_REG_INIT
  reg [19:0] i_tag_array_0 [0:127]; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_en; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_addr; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_data; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_1_en; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_1_addr; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_1_data; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_3_en; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_3_addr; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_3_data; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_5_en; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_5_addr; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_5_data; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_2_data; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_2_addr; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_2_mask; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_2_en; // @[Memory.scala 269:24]
  wire [19:0] i_tag_array_0_MPORT_4_data; // @[Memory.scala 269:24]
  wire [6:0] i_tag_array_0_MPORT_4_addr; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_4_mask; // @[Memory.scala 269:24]
  wire  i_tag_array_0_MPORT_4_en; // @[Memory.scala 269:24]
  reg [19:0] tag_array_0 [0:127]; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_6_en; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_6_addr; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_6_data; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_7_en; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_7_addr; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_7_data; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_10_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_10_addr; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_10_mask; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_10_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_12_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_12_addr; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_12_mask; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_12_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_14_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_14_addr; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_14_mask; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_14_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_0_MPORT_16_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_0_MPORT_16_addr; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_16_mask; // @[Memory.scala 487:22]
  wire  tag_array_0_MPORT_16_en; // @[Memory.scala 487:22]
  reg [19:0] tag_array_1 [0:127]; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_6_en; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_6_addr; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_6_data; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_7_en; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_7_addr; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_7_data; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_10_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_10_addr; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_10_mask; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_10_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_12_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_12_addr; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_12_mask; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_12_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_14_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_14_addr; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_14_mask; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_14_en; // @[Memory.scala 487:22]
  wire [19:0] tag_array_1_MPORT_16_data; // @[Memory.scala 487:22]
  wire [6:0] tag_array_1_MPORT_16_addr; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_16_mask; // @[Memory.scala 487:22]
  wire  tag_array_1_MPORT_16_en; // @[Memory.scala 487:22]
  reg  lru_array_way_hot [0:127]; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_reg_lru_MPORT_en; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_8_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_8_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_8_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_8_en; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_9_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_9_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_9_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_9_en; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_11_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_11_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_11_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_11_en; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_13_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_13_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_13_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_13_en; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_15_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_15_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_15_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_15_en; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_17_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_way_hot_MPORT_17_addr; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_17_mask; // @[Memory.scala 488:22]
  wire  lru_array_way_hot_MPORT_17_en; // @[Memory.scala 488:22]
  reg  lru_array_dirty1 [0:127]; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_reg_lru_MPORT_en; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_8_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_8_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_8_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_8_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_9_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_9_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_9_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_9_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_11_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_11_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_11_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_11_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_13_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_13_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_13_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_13_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_15_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_15_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_15_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_15_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_17_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty1_MPORT_17_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_17_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty1_MPORT_17_en; // @[Memory.scala 488:22]
  reg  lru_array_dirty2 [0:127]; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_reg_lru_MPORT_en; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_8_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_8_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_8_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_8_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_9_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_9_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_9_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_9_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_11_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_11_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_11_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_11_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_13_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_13_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_13_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_13_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_15_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_15_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_15_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_15_en; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_17_data; // @[Memory.scala 488:22]
  wire [6:0] lru_array_dirty2_MPORT_17_addr; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_17_mask; // @[Memory.scala 488:22]
  wire  lru_array_dirty2_MPORT_17_en; // @[Memory.scala 488:22]
  reg [2:0] reg_dram_state; // @[Memory.scala 171:31]
  reg [26:0] reg_dram_addr; // @[Memory.scala 172:31]
  reg [127:0] reg_dram_wdata; // @[Memory.scala 173:31]
  reg [127:0] reg_dram_rdata; // @[Memory.scala 174:31]
  reg  reg_dram_di; // @[Memory.scala 175:28]
  wire  _T_3 = ~io_dramPort_busy; // @[Memory.scala 191:48]
  reg [2:0] icache_state; // @[Memory.scala 271:29]
  wire  _T_25 = 3'h0 == icache_state; // @[Memory.scala 309:25]
  reg [2:0] dcache_state; // @[Memory.scala 490:29]
  wire  _T_77 = 3'h0 == dcache_state; // @[Memory.scala 535:25]
  reg [19:0] reg_tag_0; // @[Memory.scala 491:24]
  reg [19:0] reg_req_addr_tag; // @[Memory.scala 495:29]
  wire  _T_82 = reg_tag_0 == reg_req_addr_tag; // @[Memory.scala 575:24]
  reg [19:0] reg_tag_1; // @[Memory.scala 491:24]
  wire  _T_83 = reg_tag_1 == reg_req_addr_tag; // @[Memory.scala 578:30]
  wire [1:0] _GEN_541 = reg_tag_1 == reg_req_addr_tag ? 2'h1 : 2'h2; // @[Memory.scala 578:52 580:29 582:29]
  wire [1:0] _GEN_543 = reg_tag_0 == reg_req_addr_tag ? 2'h1 : _GEN_541; // @[Memory.scala 575:46 577:29]
  wire [1:0] _GEN_1085 = 3'h1 == dcache_state ? _GEN_543 : 2'h0; // @[Memory.scala 520:23 535:25]
  wire [1:0] dcache_snoop_status = 3'h0 == dcache_state ? 2'h0 : _GEN_1085; // @[Memory.scala 520:23 535:25]
  wire  _T_47 = 2'h0 == dcache_snoop_status; // @[Memory.scala 378:36]
  wire  _GEN_24 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? 1'h0 : 1'h1; // @[Memory.scala 184:20 191:67 192:21]
  wire  dram_i_busy = 3'h0 == reg_dram_state ? _GEN_24 : 1'h1; // @[Memory.scala 184:20 189:27]
  wire  _T_54 = ~dram_i_busy; // @[Memory.scala 404:17]
  reg [19:0] i_reg_req_addr_tag; // @[Memory.scala 274:31]
  reg [6:0] i_reg_req_addr_index; // @[Memory.scala 274:31]
  wire [22:0] _dram_i_addr_T_1 = {i_reg_req_addr_tag[15:0],i_reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_332 = 3'h4 == icache_state ? _dram_i_addr_T_1 : _dram_i_addr_T_1; // @[Memory.scala 309:25]
  wire [26:0] dram_i_addr = {{4'd0}, _GEN_332}; // @[Memory.scala 162:26]
  wire [30:0] _io_dramPort_addr_T = {dram_i_addr,4'h0}; // @[Cat.scala 31:58]
  reg  reg_lru_way_hot; // @[Memory.scala 494:24]
  reg  reg_lru_dirty1; // @[Memory.scala 494:24]
  wire  _T_91 = ~reg_lru_way_hot; // @[Memory.scala 599:83]
  reg  reg_lru_dirty2; // @[Memory.scala 494:24]
  wire  _GEN_156 = 2'h1 == dcache_snoop_status ? 1'h0 : 2'h2 == dcache_snoop_status & _T_54; // @[Memory.scala 294:14 378:36]
  wire  _GEN_175 = 2'h0 == dcache_snoop_status ? 1'h0 : _GEN_156; // @[Memory.scala 294:14 378:36]
  wire  _GEN_293 = 3'h5 == icache_state ? 1'h0 : 3'h3 == icache_state & _T_54; // @[Memory.scala 294:14 309:25]
  wire  _GEN_331 = 3'h4 == icache_state ? _GEN_175 : _GEN_293; // @[Memory.scala 309:25]
  wire  _GEN_393 = 3'h2 == icache_state ? 1'h0 : _GEN_331; // @[Memory.scala 294:14 309:25]
  wire  _GEN_442 = 3'h1 == icache_state ? 1'h0 : _GEN_393; // @[Memory.scala 294:14 309:25]
  wire  dram_i_ren = 3'h0 == icache_state ? 1'h0 : _GEN_442; // @[Memory.scala 294:14 309:25]
  wire  _GEN_30 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? dram_i_ren : 1'h1; // @[Memory.scala 185:20 191:67]
  wire  dram_d_busy = 3'h0 == reg_dram_state ? _GEN_30 : 1'h1; // @[Memory.scala 185:20 189:27]
  wire  _T_94 = ~dram_d_busy; // @[Memory.scala 600:15]
  reg [6:0] reg_req_addr_index; // @[Memory.scala 495:29]
  wire [22:0] _dram_d_addr_T_1 = {reg_tag_0[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _dram_d_addr_T_3 = {reg_tag_1[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_546 = reg_lru_way_hot ? _dram_d_addr_T_1 : _dram_d_addr_T_3; // @[Memory.scala 602:42 603:25 606:25]
  wire [22:0] _dram_d_addr_T_5 = {reg_req_addr_tag[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_556 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_546 :
    _dram_d_addr_T_5; // @[Memory.scala 599:111]
  wire [22:0] _GEN_902 = 3'h3 == dcache_state ? _GEN_556 : _dram_d_addr_T_5; // @[Memory.scala 535:25]
  wire [22:0] _GEN_1019 = 3'h2 == dcache_state ? _GEN_556 : _GEN_902; // @[Memory.scala 535:25]
  wire [26:0] dram_d_addr = {{4'd0}, _GEN_1019}; // @[Memory.scala 167:26]
  wire [30:0] _io_dramPort_addr_T_1 = {dram_d_addr,4'h0}; // @[Cat.scala 31:58]
  reg  reg_dcache_read; // @[Memory.scala 499:32]
  reg [255:0] reg_line1; // @[Memory.scala 492:26]
  wire [255:0] line1 = reg_dcache_read ? io_cache_array1_rdata : reg_line1; // @[Memory.scala 591:22]
  reg [255:0] reg_line2; // @[Memory.scala 493:26]
  wire [255:0] line2 = reg_dcache_read ? io_cache_array2_rdata : reg_line2; // @[Memory.scala 592:22]
  wire [255:0] _GEN_547 = reg_lru_way_hot ? line1 : line2; // @[Memory.scala 602:42 604:26 607:26]
  wire [255:0] dram_d_wdata = 3'h2 == dcache_state ? _GEN_547 : _GEN_547; // @[Memory.scala 535:25]
  wire  _GEN_559 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? 1'h0 : _T_94; // @[Memory.scala 599:111 506:14]
  wire  _GEN_565 = _T_83 ? 1'h0 : _GEN_559; // @[Memory.scala 506:14 596:52]
  wire  _GEN_571 = _T_82 ? 1'h0 : _GEN_565; // @[Memory.scala 506:14 593:46]
  wire  _GEN_825 = 3'h5 == dcache_state & _T_94; // @[Memory.scala 506:14 535:25]
  wire  _GEN_904 = 3'h3 == dcache_state ? _GEN_571 : _GEN_825; // @[Memory.scala 535:25]
  wire  _GEN_977 = 3'h4 == dcache_state ? 1'h0 : _GEN_904; // @[Memory.scala 506:14 535:25]
  wire  _GEN_1021 = 3'h2 == dcache_state ? _GEN_571 : _GEN_977; // @[Memory.scala 535:25]
  wire  _GEN_1093 = 3'h1 == dcache_state ? 1'h0 : _GEN_1021; // @[Memory.scala 506:14 535:25]
  wire  dram_d_ren = 3'h0 == dcache_state ? 1'h0 : _GEN_1093; // @[Memory.scala 506:14 535:25]
  wire [26:0] _GEN_2 = dram_d_ren ? dram_d_addr : reg_dram_addr; // @[Memory.scala 210:35 213:27 172:31]
  wire  _GEN_3 = dram_d_ren ? 1'h0 : reg_dram_di; // @[Memory.scala 210:35 214:25 175:28]
  wire [2:0] _GEN_4 = dram_d_ren ? 3'h2 : reg_dram_state; // @[Memory.scala 210:35 215:28 171:31]
  wire  _GEN_555 = (reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2) & _T_94; // @[Memory.scala 599:111 507:14]
  wire  _GEN_562 = _T_83 ? 1'h0 : _GEN_555; // @[Memory.scala 507:14 596:52]
  wire  _GEN_568 = _T_82 ? 1'h0 : _GEN_562; // @[Memory.scala 507:14 593:46]
  wire  _GEN_974 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_568; // @[Memory.scala 507:14 535:25]
  wire  _GEN_1018 = 3'h2 == dcache_state ? _GEN_568 : _GEN_974; // @[Memory.scala 535:25]
  wire  _GEN_1090 = 3'h1 == dcache_state ? 1'h0 : _GEN_1018; // @[Memory.scala 507:14 535:25]
  wire  dram_d_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1090; // @[Memory.scala 507:14 535:25]
  wire [30:0] _GEN_6 = dram_d_wen ? _io_dramPort_addr_T_1 : _io_dramPort_addr_T_1; // @[Memory.scala 201:29 203:30]
  wire [26:0] _GEN_9 = dram_d_wen ? dram_d_addr : _GEN_2; // @[Memory.scala 201:29 206:27]
  wire [127:0] _GEN_10 = dram_d_wen ? dram_d_wdata[255:128] : reg_dram_wdata; // @[Memory.scala 201:29 207:28 173:31]
  wire  _GEN_11 = dram_d_wen ? 1'h0 : _GEN_3; // @[Memory.scala 201:29 208:25]
  wire [2:0] _GEN_12 = dram_d_wen ? 3'h1 : _GEN_4; // @[Memory.scala 201:29 209:28]
  wire  _GEN_13 = dram_d_wen ? 1'h0 : dram_d_ren; // @[Memory.scala 177:19 201:29]
  wire  _GEN_14 = dram_i_ren | _GEN_13; // @[Memory.scala 193:27 194:27]
  wire [30:0] _GEN_15 = dram_i_ren ? _io_dramPort_addr_T : _GEN_6; // @[Memory.scala 193:27 195:28]
  wire  _GEN_17 = dram_i_ren | _GEN_11; // @[Memory.scala 193:27 197:23]
  wire  _GEN_20 = dram_i_ren ? 1'h0 : dram_d_wen; // @[Memory.scala 178:19 193:27]
  wire  _GEN_25 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_14; // @[Memory.scala 177:19 191:67]
  wire  _GEN_28 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? _GEN_17 : reg_dram_di; // @[Memory.scala 175:28 191:67]
  wire  _GEN_31 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_20; // @[Memory.scala 178:19 191:67]
  wire [30:0] _io_dramPort_addr_T_3 = {reg_dram_addr,4'h8}; // @[Cat.scala 31:58]
  wire [127:0] _GEN_40 = io_dramPort_rdata_valid ? io_dramPort_rdata : reg_dram_rdata; // @[Memory.scala 233:40 234:26 174:31]
  wire [2:0] _GEN_41 = io_dramPort_rdata_valid ? 3'h5 : 3'h4; // @[Memory.scala 233:40 235:26 237:26]
  wire [2:0] _GEN_42 = io_dramPort_rdata_valid ? 3'h3 : reg_dram_state; // @[Memory.scala 239:44 241:24 171:31]
  wire [2:0] _GEN_46 = _T_3 ? _GEN_41 : _GEN_42; // @[Memory.scala 230:32]
  wire [2:0] _GEN_49 = _T_3 ? 3'h5 : reg_dram_state; // @[Memory.scala 245:32 248:24 171:31]
  wire [2:0] _GEN_50 = io_dramPort_rdata_valid ? 3'h5 : reg_dram_state; // @[Memory.scala 252:38 254:24 171:31]
  wire [255:0] dram_rdata = {io_dramPort_rdata,reg_dram_rdata}; // @[Cat.scala 31:58]
  wire  _GEN_52 = io_dramPort_rdata_valid & reg_dram_di; // @[Memory.scala 187:22 258:38 262:28]
  wire  _GEN_53 = io_dramPort_rdata_valid & ~reg_dram_di; // @[Memory.scala 188:22 258:38 263:28]
  wire [2:0] _GEN_54 = io_dramPort_rdata_valid ? 3'h0 : reg_dram_state; // @[Memory.scala 258:38 264:24 171:31]
  wire [2:0] _GEN_58 = 3'h5 == reg_dram_state ? _GEN_54 : reg_dram_state; // @[Memory.scala 189:27 171:31]
  wire [127:0] _GEN_59 = 3'h4 == reg_dram_state ? _GEN_40 : reg_dram_rdata; // @[Memory.scala 189:27 174:31]
  wire [2:0] _GEN_60 = 3'h4 == reg_dram_state ? _GEN_50 : _GEN_58; // @[Memory.scala 189:27]
  wire  _GEN_62 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_52; // @[Memory.scala 187:22 189:27]
  wire  _GEN_63 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_53; // @[Memory.scala 188:22 189:27]
  wire  _GEN_64 = 3'h3 == reg_dram_state & _T_3; // @[Memory.scala 177:19 189:27]
  wire [2:0] _GEN_66 = 3'h3 == reg_dram_state ? _GEN_49 : _GEN_60; // @[Memory.scala 189:27]
  wire [127:0] _GEN_67 = 3'h3 == reg_dram_state ? reg_dram_rdata : _GEN_59; // @[Memory.scala 189:27 174:31]
  wire  _GEN_69 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_62; // @[Memory.scala 187:22 189:27]
  wire  _GEN_70 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_63; // @[Memory.scala 188:22 189:27]
  wire  _GEN_71 = 3'h2 == reg_dram_state ? _T_3 : _GEN_64; // @[Memory.scala 189:27]
  wire [30:0] _GEN_72 = 3'h2 == reg_dram_state ? _io_dramPort_addr_T_3 : _io_dramPort_addr_T_3; // @[Memory.scala 189:27]
  wire  _GEN_76 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_69; // @[Memory.scala 187:22 189:27]
  wire  _GEN_77 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_70; // @[Memory.scala 188:22 189:27]
  wire  _GEN_78 = 3'h1 == reg_dram_state & _T_3; // @[Memory.scala 178:19 189:27]
  wire [30:0] _GEN_79 = 3'h1 == reg_dram_state ? _io_dramPort_addr_T_3 : _GEN_72; // @[Memory.scala 189:27]
  wire  _GEN_83 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_71; // @[Memory.scala 177:19 189:27]
  wire  _GEN_86 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_76; // @[Memory.scala 187:22 189:27]
  wire  _GEN_87 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_77; // @[Memory.scala 188:22 189:27]
  wire [30:0] _GEN_90 = 3'h0 == reg_dram_state ? _GEN_15 : _GEN_79; // @[Memory.scala 189:27]
  wire  _GEN_92 = 3'h0 == reg_dram_state ? _GEN_28 : reg_dram_di; // @[Memory.scala 189:27 175:28]
  wire  dram_i_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_86; // @[Memory.scala 187:22 189:27]
  wire  dram_d_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_87; // @[Memory.scala 188:22 189:27]
  reg [19:0] i_reg_tag_0; // @[Memory.scala 272:26]
  reg [4:0] i_reg_req_addr_line_off; // @[Memory.scala 274:31]
  reg [19:0] i_reg_next_addr_tag; // @[Memory.scala 275:32]
  reg [6:0] i_reg_next_addr_index; // @[Memory.scala 275:32]
  reg [4:0] i_reg_next_addr_line_off; // @[Memory.scala 275:32]
  reg [31:0] i_reg_snoop_inst; // @[Memory.scala 276:33]
  reg  i_reg_snoop_inst_valid; // @[Memory.scala 277:39]
  reg [1:0] i_reg_valid_rdata; // @[Memory.scala 279:34]
  reg [26:0] i_reg_cur_tag_index; // @[Memory.scala 280:36]
  reg  i_reg_addr_match; // @[Memory.scala 281:33]
  wire [9:0] _io_icache_raddr_T_1 = {io_imem_addr[11:5],io_imem_addr[4:2]}; // @[Cat.scala 31:58]
  wire [26:0] _T_26 = {io_imem_addr[31:12],io_imem_addr[11:5]}; // @[Cat.scala 31:58]
  wire [1:0] _GEN_103 = i_reg_cur_tag_index == _T_26 ? 2'h2 : 2'h1; // @[Memory.scala 325:74 326:24 328:24]
  wire  _GEN_117 = io_icache_control_invalidate ? 1'h0 : io_imem_en; // @[Memory.scala 269:24 314:43]
  wire  _i_reg_addr_match_T_3 = i_reg_req_addr_index == io_imem_addr[11:5]; // @[Memory.scala 337:32]
  wire  _i_reg_addr_match_T_4 = i_reg_req_addr_tag[15:0] == io_imem_addr[27:12] & _i_reg_addr_match_T_3; // @[Memory.scala 336:111]
  wire  _i_reg_addr_match_T_7 = i_reg_req_addr_line_off[4:2] == io_imem_addr[4:2]; // @[Memory.scala 338:57]
  wire  _i_reg_addr_match_T_8 = _i_reg_addr_match_T_4 & _i_reg_addr_match_T_7; // @[Memory.scala 337:54]
  wire [1:0] _T_32 = io_icache_valid_rdata >> i_reg_req_addr_index[0]; // @[Memory.scala 339:36]
  wire  _T_36 = _T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag; // @[Memory.scala 339:105]
  wire [9:0] _io_icache_raddr_T_3 = {i_reg_req_addr_index,i_reg_req_addr_line_off[4:2]}; // @[Cat.scala 31:58]
  wire [26:0] _i_reg_cur_tag_index_T_1 = {i_reg_req_addr_tag,i_reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [19:0] _GEN_128 = io_imem_en ? i_tag_array_0_MPORT_1_data : i_reg_tag_0; // @[Memory.scala 362:31 363:19 272:26]
  wire [1:0] _GEN_131 = io_imem_en ? _GEN_103 : 2'h0; // @[Memory.scala 362:31 374:22]
  wire [2:0] _GEN_132 = io_icache_control_invalidate ? 3'h7 : {{1'd0}, _GEN_131}; // @[Memory.scala 357:43 361:22]
  wire [19:0] _GEN_134 = io_icache_control_invalidate ? i_reg_tag_0 : _GEN_128; // @[Memory.scala 272:26 357:43]
  wire [31:0] _dcache_snoop_addr_T = {i_reg_req_addr_tag,i_reg_req_addr_index,i_reg_req_addr_line_off}; // @[Memory.scala 381:47]
  wire [4:0] dcache_snoop_addr_line_off = _dcache_snoop_addr_T[4:0]; // @[Memory.scala 381:62]
  wire [6:0] dcache_snoop_addr_index = _dcache_snoop_addr_T[11:5]; // @[Memory.scala 381:62]
  wire [19:0] dcache_snoop_addr_tag = _dcache_snoop_addr_T[31:12]; // @[Memory.scala 381:62]
  wire [7:0] _i_reg_snoop_inst_T_1 = {i_reg_next_addr_line_off[4:2],5'h0}; // @[Cat.scala 31:58]
  wire [255:0] dcache_snoop_line = reg_tag_0 == reg_req_addr_tag ? io_cache_array1_rdata : io_cache_array2_rdata; // @[Memory.scala 575:46 576:27]
  wire [255:0] _i_reg_snoop_inst_T_2 = dcache_snoop_line >> _i_reg_snoop_inst_T_1; // @[Memory.scala 385:37]
  wire  _i_reg_snoop_inst_valid_T_3 = i_reg_req_addr_index == i_reg_next_addr_index; // @[Memory.scala 388:34]
  wire  _i_reg_snoop_inst_valid_T_4 = i_reg_req_addr_tag[15:0] == i_reg_next_addr_tag[15:0] &
    _i_reg_snoop_inst_valid_T_3; // @[Memory.scala 387:100]
  wire [1:0] _icache_valid_wdata_T_1 = 2'h1 << i_reg_req_addr_index[0]; // @[Memory.scala 397:62]
  wire [1:0] icache_valid_wdata = i_reg_valid_rdata | _icache_valid_wdata_T_1; // @[Memory.scala 397:55]
  wire [2:0] _GEN_139 = ~dram_i_busy ? 3'h6 : 3'h3; // @[Memory.scala 404:31 407:26 409:26]
  wire [2:0] _GEN_142 = 2'h2 == dcache_snoop_status ? _GEN_139 : icache_state; // @[Memory.scala 271:29 378:36]
  wire [31:0] _GEN_143 = 2'h1 == dcache_snoop_status ? _i_reg_snoop_inst_T_2[31:0] : i_reg_snoop_inst; // @[Memory.scala 378:36 385:28 276:33]
  wire  _GEN_144 = 2'h1 == dcache_snoop_status ? _i_reg_snoop_inst_valid_T_4 : i_reg_snoop_inst_valid; // @[Memory.scala 378:36 386:34 277:39]
  wire [26:0] _GEN_153 = 2'h1 == dcache_snoop_status ? _i_reg_cur_tag_index_T_1 : i_reg_cur_tag_index; // @[Memory.scala 378:36 399:31 280:36]
  wire [1:0] _GEN_154 = 2'h1 == dcache_snoop_status ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 378:36 400:29 279:34]
  wire [2:0] _GEN_155 = 2'h1 == dcache_snoop_status ? 3'h5 : _GEN_142; // @[Memory.scala 378:36 401:24]
  wire [31:0] _GEN_162 = 2'h0 == dcache_snoop_status ? i_reg_snoop_inst : _GEN_143; // @[Memory.scala 276:33 378:36]
  wire  _GEN_163 = 2'h0 == dcache_snoop_status ? i_reg_snoop_inst_valid : _GEN_144; // @[Memory.scala 378:36 277:39]
  wire  _GEN_166 = 2'h0 == dcache_snoop_status ? 1'h0 : 2'h1 == dcache_snoop_status; // @[Memory.scala 269:24 378:36]
  wire [26:0] _GEN_172 = 2'h0 == dcache_snoop_status ? i_reg_cur_tag_index : _GEN_153; // @[Memory.scala 280:36 378:36]
  wire [1:0] _GEN_173 = 2'h0 == dcache_snoop_status ? i_reg_valid_rdata : _GEN_154; // @[Memory.scala 279:34 378:36]
  wire [2:0] _GEN_174 = 2'h0 == dcache_snoop_status ? icache_state : _GEN_155; // @[Memory.scala 271:29 378:36]
  wire [19:0] _GEN_179 = io_imem_en ? i_tag_array_0_MPORT_3_data : i_reg_tag_0; // @[Memory.scala 421:25 422:19 272:26]
  wire [2:0] _GEN_185 = _T_54 ? 3'h6 : icache_state; // @[Memory.scala 437:27 440:22 271:29]
  wire [255:0] _io_imem_inst_T_2 = dram_rdata >> _i_reg_snoop_inst_T_1; // @[Memory.scala 446:31]
  wire [31:0] _GEN_187 = dram_i_rdata_valid ? _io_imem_inst_T_2[31:0] : 32'hdeadbeef; // @[Memory.scala 288:16 444:33 446:22]
  wire  _GEN_188 = dram_i_rdata_valid & _i_reg_snoop_inst_valid_T_4; // @[Memory.scala 289:17 444:33]
  wire [26:0] _GEN_197 = dram_i_rdata_valid ? _i_reg_cur_tag_index_T_1 : i_reg_cur_tag_index; // @[Memory.scala 444:33 460:29 280:36]
  wire [1:0] _GEN_198 = dram_i_rdata_valid ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 444:33 461:27 279:34]
  wire [2:0] _GEN_199 = dram_i_rdata_valid ? 3'h0 : icache_state; // @[Memory.scala 444:33 462:22 271:29]
  wire [19:0] _GEN_201 = io_imem_en ? i_tag_array_0_MPORT_5_data : i_reg_tag_0; // @[Memory.scala 474:25 475:19 272:26]
  wire [1:0] _GEN_204 = io_imem_en ? 2'h2 : 2'h0; // @[Memory.scala 474:25 480:22 482:22]
  wire [26:0] _GEN_209 = 3'h7 == icache_state ? 27'h7ffffff : i_reg_cur_tag_index; // @[Memory.scala 309:25 470:27 280:36]
  wire [4:0] _GEN_210 = 3'h7 == icache_state ? io_imem_addr[4:0] : i_reg_req_addr_line_off; // @[Memory.scala 309:25 472:22 274:31]
  wire [6:0] _GEN_211 = 3'h7 == icache_state ? io_imem_addr[11:5] : i_reg_req_addr_index; // @[Memory.scala 309:25 472:22 274:31]
  wire [19:0] _GEN_212 = 3'h7 == icache_state ? io_imem_addr[31:12] : i_reg_req_addr_tag; // @[Memory.scala 309:25 472:22 274:31]
  wire  _GEN_213 = 3'h7 == icache_state | i_reg_addr_match; // @[Memory.scala 309:25 473:24 281:33]
  wire  _GEN_216 = 3'h7 == icache_state & io_imem_en; // @[Memory.scala 269:24 309:25]
  wire [19:0] _GEN_217 = 3'h7 == icache_state ? _GEN_201 : i_reg_tag_0; // @[Memory.scala 309:25 272:26]
  wire [2:0] _GEN_220 = 3'h7 == icache_state ? {{1'd0}, _GEN_204} : icache_state; // @[Memory.scala 309:25 271:29]
  wire [31:0] _GEN_221 = 3'h6 == icache_state ? _GEN_187 : 32'hdeadbeef; // @[Memory.scala 288:16 309:25]
  wire  _GEN_229 = 3'h6 == icache_state ? dram_i_rdata_valid : _GEN_216; // @[Memory.scala 309:25]
  wire [3:0] _GEN_230 = 3'h6 == icache_state ? i_reg_req_addr_index[4:1] : io_imem_addr[9:6]; // @[Memory.scala 309:25]
  wire [26:0] _GEN_232 = 3'h6 == icache_state ? _GEN_197 : _GEN_209; // @[Memory.scala 309:25]
  wire [1:0] _GEN_233 = 3'h6 == icache_state ? _GEN_198 : i_reg_valid_rdata; // @[Memory.scala 309:25 279:34]
  wire [2:0] _GEN_234 = 3'h6 == icache_state ? _GEN_199 : _GEN_220; // @[Memory.scala 309:25]
  wire  _GEN_236 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state; // @[Memory.scala 309:25 303:30]
  wire [4:0] _GEN_239 = 3'h6 == icache_state ? i_reg_req_addr_line_off : _GEN_210; // @[Memory.scala 309:25 274:31]
  wire [6:0] _GEN_240 = 3'h6 == icache_state ? i_reg_req_addr_index : _GEN_211; // @[Memory.scala 309:25 274:31]
  wire [19:0] _GEN_241 = 3'h6 == icache_state ? i_reg_req_addr_tag : _GEN_212; // @[Memory.scala 309:25 274:31]
  wire  _GEN_242 = 3'h6 == icache_state ? i_reg_addr_match : _GEN_213; // @[Memory.scala 309:25 281:33]
  wire  _GEN_245 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state & io_imem_en; // @[Memory.scala 269:24 309:25]
  wire [19:0] _GEN_246 = 3'h6 == icache_state ? i_reg_tag_0 : _GEN_217; // @[Memory.scala 309:25 272:26]
  wire [2:0] _GEN_250 = 3'h3 == icache_state ? _GEN_185 : _GEN_234; // @[Memory.scala 309:25]
  wire [31:0] _GEN_251 = 3'h3 == icache_state ? 32'hdeadbeef : _GEN_221; // @[Memory.scala 288:16 309:25]
  wire  _GEN_252 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & _GEN_188; // @[Memory.scala 289:17 309:25]
  wire  _GEN_255 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & dram_i_rdata_valid; // @[Memory.scala 269:24 309:25]
  wire  _GEN_259 = 3'h3 == icache_state ? 1'h0 : _GEN_229; // @[Memory.scala 301:23 309:25]
  wire [26:0] _GEN_262 = 3'h3 == icache_state ? i_reg_cur_tag_index : _GEN_232; // @[Memory.scala 309:25 280:36]
  wire [1:0] _GEN_263 = 3'h3 == icache_state ? i_reg_valid_rdata : _GEN_233; // @[Memory.scala 309:25 279:34]
  wire  _GEN_265 = 3'h3 == icache_state ? 1'h0 : _GEN_236; // @[Memory.scala 309:25 303:30]
  wire [4:0] _GEN_268 = 3'h3 == icache_state ? i_reg_req_addr_line_off : _GEN_239; // @[Memory.scala 309:25 274:31]
  wire [6:0] _GEN_269 = 3'h3 == icache_state ? i_reg_req_addr_index : _GEN_240; // @[Memory.scala 309:25 274:31]
  wire [19:0] _GEN_270 = 3'h3 == icache_state ? i_reg_req_addr_tag : _GEN_241; // @[Memory.scala 309:25 274:31]
  wire  _GEN_271 = 3'h3 == icache_state ? i_reg_addr_match : _GEN_242; // @[Memory.scala 309:25 281:33]
  wire  _GEN_274 = 3'h3 == icache_state ? 1'h0 : _GEN_245; // @[Memory.scala 269:24 309:25]
  wire [19:0] _GEN_275 = 3'h3 == icache_state ? i_reg_tag_0 : _GEN_246; // @[Memory.scala 309:25 272:26]
  wire [31:0] _GEN_277 = 3'h5 == icache_state ? i_reg_snoop_inst : _GEN_251; // @[Memory.scala 309:25 415:20]
  wire  _GEN_278 = 3'h5 == icache_state ? i_reg_snoop_inst_valid : _GEN_252; // @[Memory.scala 309:25 416:21]
  wire  _GEN_279 = 3'h5 == icache_state ? 1'h0 : i_reg_snoop_inst_valid; // @[Memory.scala 309:25 417:30 277:39]
  wire [4:0] _GEN_280 = 3'h5 == icache_state ? io_imem_addr[4:0] : _GEN_268; // @[Memory.scala 309:25 419:22]
  wire [6:0] _GEN_281 = 3'h5 == icache_state ? io_imem_addr[11:5] : _GEN_269; // @[Memory.scala 309:25 419:22]
  wire [19:0] _GEN_282 = 3'h5 == icache_state ? io_imem_addr[31:12] : _GEN_270; // @[Memory.scala 309:25 419:22]
  wire  _GEN_283 = 3'h5 == icache_state | _GEN_271; // @[Memory.scala 309:25 420:24]
  wire [19:0] _GEN_287 = 3'h5 == icache_state ? _GEN_179 : _GEN_275; // @[Memory.scala 309:25]
  wire  _GEN_288 = 3'h5 == icache_state ? io_imem_en : _GEN_274; // @[Memory.scala 309:25]
  wire [9:0] _GEN_289 = 3'h5 == icache_state ? _io_icache_raddr_T_1 : _io_icache_raddr_T_1; // @[Memory.scala 309:25]
  wire  _GEN_290 = 3'h5 == icache_state ? io_imem_en : _GEN_259; // @[Memory.scala 309:25]
  wire [3:0] _GEN_291 = 3'h5 == icache_state ? io_imem_addr[9:6] : _GEN_230; // @[Memory.scala 309:25]
  wire [2:0] _GEN_292 = 3'h5 == icache_state ? {{1'd0}, _GEN_131} : _GEN_250; // @[Memory.scala 309:25]
  wire  _GEN_297 = 3'h5 == icache_state ? 1'h0 : _GEN_255; // @[Memory.scala 269:24 309:25]
  wire [26:0] _GEN_302 = 3'h5 == icache_state ? i_reg_cur_tag_index : _GEN_262; // @[Memory.scala 309:25 280:36]
  wire [1:0] _GEN_303 = 3'h5 == icache_state ? i_reg_valid_rdata : _GEN_263; // @[Memory.scala 309:25 279:34]
  wire  _GEN_305 = 3'h5 == icache_state ? 1'h0 : _GEN_265; // @[Memory.scala 309:25 303:30]
  wire  _GEN_310 = 3'h5 == icache_state ? 1'h0 : _GEN_274; // @[Memory.scala 269:24 309:25]
  wire [31:0] _GEN_315 = 3'h4 == icache_state ? _GEN_162 : i_reg_snoop_inst; // @[Memory.scala 309:25 276:33]
  wire  _GEN_316 = 3'h4 == icache_state ? _GEN_163 : _GEN_279; // @[Memory.scala 309:25]
  wire  _GEN_322 = 3'h4 == icache_state ? _GEN_166 : _GEN_297; // @[Memory.scala 309:25]
  wire  _GEN_325 = 3'h4 == icache_state ? _GEN_166 : _GEN_290; // @[Memory.scala 309:25]
  wire [3:0] _GEN_326 = 3'h4 == icache_state ? i_reg_req_addr_index[4:1] : _GEN_291; // @[Memory.scala 309:25]
  wire [26:0] _GEN_328 = 3'h4 == icache_state ? _GEN_172 : _GEN_302; // @[Memory.scala 309:25]
  wire [1:0] _GEN_329 = 3'h4 == icache_state ? _GEN_173 : _GEN_303; // @[Memory.scala 309:25]
  wire [2:0] _GEN_330 = 3'h4 == icache_state ? _GEN_174 : _GEN_292; // @[Memory.scala 309:25]
  wire [31:0] _GEN_333 = 3'h4 == icache_state ? 32'hdeadbeef : _GEN_277; // @[Memory.scala 288:16 309:25]
  wire  _GEN_334 = 3'h4 == icache_state ? 1'h0 : _GEN_278; // @[Memory.scala 289:17 309:25]
  wire [4:0] _GEN_335 = 3'h4 == icache_state ? i_reg_req_addr_line_off : _GEN_280; // @[Memory.scala 309:25 274:31]
  wire [6:0] _GEN_336 = 3'h4 == icache_state ? i_reg_req_addr_index : _GEN_281; // @[Memory.scala 309:25 274:31]
  wire [19:0] _GEN_337 = 3'h4 == icache_state ? i_reg_req_addr_tag : _GEN_282; // @[Memory.scala 309:25 274:31]
  wire  _GEN_338 = 3'h4 == icache_state ? i_reg_addr_match : _GEN_283; // @[Memory.scala 309:25 281:33]
  wire  _GEN_341 = 3'h4 == icache_state ? 1'h0 : 3'h5 == icache_state & io_imem_en; // @[Memory.scala 269:24 309:25]
  wire [19:0] _GEN_342 = 3'h4 == icache_state ? i_reg_tag_0 : _GEN_287; // @[Memory.scala 309:25 272:26]
  wire  _GEN_343 = 3'h4 == icache_state ? 1'h0 : _GEN_288; // @[Memory.scala 296:17 309:25]
  wire  _GEN_347 = 3'h4 == icache_state ? 1'h0 : _GEN_297; // @[Memory.scala 269:24 309:25]
  wire  _GEN_351 = 3'h4 == icache_state ? 1'h0 : _GEN_305; // @[Memory.scala 309:25 303:30]
  wire  _GEN_356 = 3'h4 == icache_state ? 1'h0 : _GEN_310; // @[Memory.scala 269:24 309:25]
  wire [31:0] _GEN_357 = 3'h2 == icache_state ? io_icache_rdata : _GEN_333; // @[Memory.scala 309:25 349:20]
  wire  _GEN_358 = 3'h2 == icache_state ? i_reg_addr_match : _GEN_334; // @[Memory.scala 309:25]
  wire  _GEN_359 = 3'h2 == icache_state ? 1'h0 : 1'h1; // @[Memory.scala 309:25 353:30]
  wire  _GEN_363 = 3'h2 == icache_state | _GEN_338; // @[Memory.scala 309:25 356:24]
  wire  _GEN_364 = 3'h2 == icache_state ? io_icache_control_invalidate : _GEN_351; // @[Memory.scala 309:25]
  wire  _GEN_372 = 3'h2 == icache_state ? _GEN_117 : _GEN_343; // @[Memory.scala 309:25]
  wire [9:0] _GEN_373 = 3'h2 == icache_state ? _io_icache_raddr_T_1 : _GEN_289; // @[Memory.scala 309:25]
  wire  _GEN_374 = 3'h2 == icache_state ? _GEN_117 : _GEN_325; // @[Memory.scala 309:25]
  wire [3:0] _GEN_375 = 3'h2 == icache_state ? io_imem_addr[9:6] : _GEN_326; // @[Memory.scala 309:25]
  wire  _GEN_376 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _T_47; // @[Memory.scala 292:19 309:25]
  wire  _GEN_384 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _GEN_166; // @[Memory.scala 269:24 309:25]
  wire  _GEN_387 = 3'h2 == icache_state ? 1'h0 : _GEN_322; // @[Memory.scala 297:17 309:25]
  wire  _GEN_397 = 3'h2 == icache_state ? 1'h0 : _GEN_341; // @[Memory.scala 269:24 309:25]
  wire  _GEN_400 = 3'h2 == icache_state ? 1'h0 : _GEN_347; // @[Memory.scala 269:24 309:25]
  wire  _GEN_405 = 3'h2 == icache_state ? 1'h0 : _GEN_356; // @[Memory.scala 269:24 309:25]
  wire  _GEN_407 = 3'h1 == icache_state ? _i_reg_addr_match_T_8 : _GEN_363; // @[Memory.scala 309:25 336:24]
  wire  _GEN_408 = 3'h1 == icache_state ? _T_36 : _GEN_372; // @[Memory.scala 309:25]
  wire [9:0] _GEN_409 = 3'h1 == icache_state ? _io_icache_raddr_T_3 : _GEN_373; // @[Memory.scala 309:25]
  wire [31:0] _GEN_412 = 3'h1 == icache_state ? 32'hdeadbeef : _GEN_357; // @[Memory.scala 288:16 309:25]
  wire  _GEN_413 = 3'h1 == icache_state ? 1'h0 : _GEN_358; // @[Memory.scala 289:17 309:25]
  wire  _GEN_414 = 3'h1 == icache_state | _GEN_359; // @[Memory.scala 309:25 290:26]
  wire  _GEN_418 = 3'h1 == icache_state ? 1'h0 : _GEN_364; // @[Memory.scala 309:25 303:30]
  wire  _GEN_423 = 3'h1 == icache_state ? 1'h0 : 3'h2 == icache_state & _GEN_117; // @[Memory.scala 269:24 309:25]
  wire  _GEN_425 = 3'h1 == icache_state ? 1'h0 : _GEN_374; // @[Memory.scala 301:23 309:25]
  wire  _GEN_427 = 3'h1 == icache_state ? 1'h0 : _GEN_376; // @[Memory.scala 292:19 309:25]
  wire  _GEN_435 = 3'h1 == icache_state ? 1'h0 : _GEN_384; // @[Memory.scala 269:24 309:25]
  wire  _GEN_438 = 3'h1 == icache_state ? 1'h0 : _GEN_387; // @[Memory.scala 297:17 309:25]
  wire  _GEN_446 = 3'h1 == icache_state ? 1'h0 : _GEN_397; // @[Memory.scala 269:24 309:25]
  wire  _GEN_449 = 3'h1 == icache_state ? 1'h0 : _GEN_400; // @[Memory.scala 269:24 309:25]
  wire  _GEN_454 = 3'h1 == icache_state ? 1'h0 : _GEN_405; // @[Memory.scala 269:24 309:25]
  wire [3:0] _GEN_470 = 3'h0 == icache_state ? io_imem_addr[9:6] : _GEN_375; // @[Memory.scala 309:25]
  wire  _GEN_471 = 3'h0 == icache_state | _GEN_407; // @[Memory.scala 309:25 331:24]
  wire  dcache_snoop_en = 3'h0 == icache_state ? 1'h0 : _GEN_427; // @[Memory.scala 292:19 309:25]
  reg [4:0] reg_req_addr_line_off; // @[Memory.scala 495:29]
  reg [31:0] reg_wdata; // @[Memory.scala 496:26]
  reg [3:0] reg_wstrb; // @[Memory.scala 497:26]
  reg  reg_ren; // @[Memory.scala 498:24]
  reg [31:0] reg_read_word; // @[Memory.scala 500:30]
  wire [31:0] _req_addr_T_12 = io_dmem_ren ? io_dmem_raddr : io_dmem_waddr; // @[Memory.scala 551:27]
  wire [4:0] req_addr_4_line_off = _req_addr_T_12[4:0]; // @[Memory.scala 551:79]
  wire [6:0] req_addr_4_index = _req_addr_T_12[11:5]; // @[Memory.scala 551:79]
  wire [19:0] req_addr_4_tag = _req_addr_T_12[31:12]; // @[Memory.scala 551:79]
  wire  _T_78 = io_dmem_ren | io_dmem_wen; // @[Memory.scala 556:27]
  wire [1:0] _GEN_507 = io_dmem_ren ? 2'h2 : 2'h3; // @[Memory.scala 566:30 567:26 569:26]
  wire [6:0] _GEN_519 = dcache_snoop_en ? dcache_snoop_addr_index : req_addr_4_index; // @[Memory.scala 537:30 539:22 552:22]
  wire  _GEN_526 = dcache_snoop_en | _T_78; // @[Memory.scala 537:30 541:28]
  wire  _GEN_530 = dcache_snoop_en ? 1'h0 : 1'h1; // @[Memory.scala 502:18 537:30 549:24]
  wire  _GEN_533 = dcache_snoop_en ? reg_ren : io_dmem_ren; // @[Memory.scala 498:24 537:30 555:17]
  wire  _GEN_536 = dcache_snoop_en ? 1'h0 : _T_78; // @[Memory.scala 487:22 537:30]
  wire [7:0] _reg_read_word_T_1 = {reg_req_addr_line_off[4:2],5'h0}; // @[Cat.scala 31:58]
  wire [255:0] _reg_read_word_T_2 = line1 >> _reg_read_word_T_1; // @[Memory.scala 594:33]
  wire [255:0] _reg_read_word_T_6 = line2 >> _reg_read_word_T_1; // @[Memory.scala 597:33]
  wire [2:0] _GEN_551 = ~dram_d_busy ? 3'h5 : dcache_state; // @[Memory.scala 600:29 609:24 490:29]
  wire [2:0] _GEN_554 = _T_94 ? 3'h6 : dcache_state; // @[Memory.scala 612:29 615:24 490:29]
  wire [2:0] _GEN_558 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_551 : _GEN_554; // @[Memory.scala 599:111]
  wire [31:0] _GEN_560 = _T_83 ? _reg_read_word_T_6[31:0] : reg_read_word; // @[Memory.scala 596:52 597:23 500:30]
  wire [2:0] _GEN_561 = _T_83 ? 3'h4 : _GEN_558; // @[Memory.scala 596:52 598:22]
  wire [31:0] _GEN_566 = _T_82 ? _reg_read_word_T_2[31:0] : _GEN_560; // @[Memory.scala 593:46 594:23]
  wire [2:0] _GEN_567 = _T_82 ? 3'h4 : _GEN_561; // @[Memory.scala 593:46 595:22]
  wire [4:0] _wstrb_T_1 = {reg_req_addr_line_off[4:2],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] _wstrb_T_3 = {28'h0,reg_wstrb}; // @[Memory.scala 529:37]
  wire [62:0] _GEN_0 = {{31'd0}, _wstrb_T_3}; // @[Memory.scala 532:30]
  wire [62:0] _wstrb_T_4 = _GEN_0 << _wstrb_T_1; // @[Memory.scala 532:30]
  wire [31:0] wstrb = _wstrb_T_4[31:0]; // @[Memory.scala 532:39]
  wire [255:0] _wdata_T_1 = {224'h0,reg_wdata}; // @[Memory.scala 526:42]
  wire [510:0] _GEN_1 = {{255'd0}, _wdata_T_1}; // @[Memory.scala 635:46]
  wire [510:0] _wdata_T_4 = _GEN_1 << _reg_read_word_T_1; // @[Memory.scala 635:46]
  wire [255:0] wdata = _wdata_T_4[255:0]; // @[Memory.scala 635:108]
  wire [2:0] _T_104 = {2'h1,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire [2:0] _T_109 = {1'h1,reg_lru_dirty1,1'h1}; // @[Cat.scala 31:58]
  wire [2:0] _GEN_595 = _T_83 ? 3'h0 : _GEN_558; // @[Memory.scala 642:52 650:22]
  wire [2:0] _GEN_609 = _T_82 ? 3'h0 : _GEN_595; // @[Memory.scala 633:46 641:22]
  wire  _GEN_610 = _T_82 ? 1'h0 : _T_83; // @[Memory.scala 514:25 633:46]
  wire [31:0] _T_129 = {reg_req_addr_tag,reg_req_addr_index,reg_req_addr_line_off}; // @[Memory.scala 683:72]
  wire  _T_131 = reg_ren & io_dmem_ren & io_dmem_raddr == _T_129; // @[Memory.scala 683:38]
  wire [255:0] _io_dmem_rdata_T_2 = dram_rdata >> _reg_read_word_T_1; // @[Memory.scala 685:34]
  wire  _T_133 = reg_lru_way_hot & reg_ren; // @[Memory.scala 687:39]
  wire [2:0] _T_134 = {2'h0,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire  _T_139 = _T_91 & reg_ren; // @[Memory.scala 694:45]
  wire [2:0] _T_140 = {1'h1,reg_lru_dirty1,1'h0}; // @[Cat.scala 31:58]
  wire [7:0] _io_cache_array1_wdata_T_3 = wstrb[0] ? _wdata_T_4[7:0] : dram_rdata[7:0]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_7 = wstrb[1] ? _wdata_T_4[15:8] : dram_rdata[15:8]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_11 = wstrb[2] ? _wdata_T_4[23:16] : dram_rdata[23:16]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_15 = wstrb[3] ? _wdata_T_4[31:24] : dram_rdata[31:24]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_19 = wstrb[4] ? _wdata_T_4[39:32] : dram_rdata[39:32]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_23 = wstrb[5] ? _wdata_T_4[47:40] : dram_rdata[47:40]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_27 = wstrb[6] ? _wdata_T_4[55:48] : dram_rdata[55:48]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_31 = wstrb[7] ? _wdata_T_4[63:56] : dram_rdata[63:56]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_35 = wstrb[8] ? _wdata_T_4[71:64] : dram_rdata[71:64]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_39 = wstrb[9] ? _wdata_T_4[79:72] : dram_rdata[79:72]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_43 = wstrb[10] ? _wdata_T_4[87:80] : dram_rdata[87:80]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_47 = wstrb[11] ? _wdata_T_4[95:88] : dram_rdata[95:88]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_51 = wstrb[12] ? _wdata_T_4[103:96] : dram_rdata[103:96]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_55 = wstrb[13] ? _wdata_T_4[111:104] : dram_rdata[111:104]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_59 = wstrb[14] ? _wdata_T_4[119:112] : dram_rdata[119:112]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_63 = wstrb[15] ? _wdata_T_4[127:120] : dram_rdata[127:120]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_67 = wstrb[16] ? _wdata_T_4[135:128] : dram_rdata[135:128]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_71 = wstrb[17] ? _wdata_T_4[143:136] : dram_rdata[143:136]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_75 = wstrb[18] ? _wdata_T_4[151:144] : dram_rdata[151:144]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_79 = wstrb[19] ? _wdata_T_4[159:152] : dram_rdata[159:152]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_83 = wstrb[20] ? _wdata_T_4[167:160] : dram_rdata[167:160]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_87 = wstrb[21] ? _wdata_T_4[175:168] : dram_rdata[175:168]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_91 = wstrb[22] ? _wdata_T_4[183:176] : dram_rdata[183:176]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_95 = wstrb[23] ? _wdata_T_4[191:184] : dram_rdata[191:184]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_99 = wstrb[24] ? _wdata_T_4[199:192] : dram_rdata[199:192]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_103 = wstrb[25] ? _wdata_T_4[207:200] : dram_rdata[207:200]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_107 = wstrb[26] ? _wdata_T_4[215:208] : dram_rdata[215:208]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_111 = wstrb[27] ? _wdata_T_4[223:216] : dram_rdata[223:216]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_115 = wstrb[28] ? _wdata_T_4[231:224] : dram_rdata[231:224]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_119 = wstrb[29] ? _wdata_T_4[239:232] : dram_rdata[239:232]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_123 = wstrb[30] ? _wdata_T_4[247:240] : dram_rdata[247:240]; // @[Memory.scala 710:18]
  wire [7:0] _io_cache_array1_wdata_T_127 = wstrb[31] ? _wdata_T_4[255:248] : dram_rdata[255:248]; // @[Memory.scala 710:18]
  wire [63:0] io_cache_array1_wdata_lo_lo = {_io_cache_array1_wdata_T_31,_io_cache_array1_wdata_T_27,
    _io_cache_array1_wdata_T_23,_io_cache_array1_wdata_T_19,_io_cache_array1_wdata_T_15,_io_cache_array1_wdata_T_11,
    _io_cache_array1_wdata_T_7,_io_cache_array1_wdata_T_3}; // @[Cat.scala 31:58]
  wire [127:0] io_cache_array1_wdata_lo = {_io_cache_array1_wdata_T_63,_io_cache_array1_wdata_T_59,
    _io_cache_array1_wdata_T_55,_io_cache_array1_wdata_T_51,_io_cache_array1_wdata_T_47,_io_cache_array1_wdata_T_43,
    _io_cache_array1_wdata_T_39,_io_cache_array1_wdata_T_35,io_cache_array1_wdata_lo_lo}; // @[Cat.scala 31:58]
  wire [63:0] io_cache_array1_wdata_hi_lo = {_io_cache_array1_wdata_T_95,_io_cache_array1_wdata_T_91,
    _io_cache_array1_wdata_T_87,_io_cache_array1_wdata_T_83,_io_cache_array1_wdata_T_79,_io_cache_array1_wdata_T_75,
    _io_cache_array1_wdata_T_71,_io_cache_array1_wdata_T_67}; // @[Cat.scala 31:58]
  wire [255:0] _io_cache_array1_wdata_T_128 = {_io_cache_array1_wdata_T_127,_io_cache_array1_wdata_T_123,
    _io_cache_array1_wdata_T_119,_io_cache_array1_wdata_T_115,_io_cache_array1_wdata_T_111,_io_cache_array1_wdata_T_107,
    _io_cache_array1_wdata_T_103,_io_cache_array1_wdata_T_99,io_cache_array1_wdata_hi_lo,io_cache_array1_wdata_lo}; // @[Cat.scala 31:58]
  wire  _GEN_641 = reg_lru_way_hot ? 1'h0 : 1'h1; // @[Memory.scala 487:22 704:42]
  wire  _GEN_656 = _T_91 & reg_ren | _GEN_641; // @[Memory.scala 694:57 696:30]
  wire [255:0] _GEN_659 = _T_91 & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 694:57 699:33]
  wire  _GEN_665 = _T_91 & reg_ren ? 1'h0 : reg_lru_way_hot; // @[Memory.scala 487:22 694:57]
  wire  _GEN_676 = _T_91 & reg_ren ? 1'h0 : _GEN_641; // @[Memory.scala 487:22 694:57]
  wire  _GEN_689 = reg_lru_way_hot & reg_ren | _GEN_665; // @[Memory.scala 687:51 689:30]
  wire [255:0] _GEN_692 = reg_lru_way_hot & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 687:51 692:33]
  wire  _GEN_698 = reg_lru_way_hot & reg_ren ? 1'h0 : _T_139; // @[Memory.scala 487:22 687:51]
  wire  _GEN_702 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_656; // @[Memory.scala 514:25 687:51]
  wire  _GEN_711 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_665; // @[Memory.scala 487:22 687:51]
  wire  _GEN_720 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_676; // @[Memory.scala 487:22 687:51]
  wire  _GEN_729 = dram_d_rdata_valid & _T_131; // @[Memory.scala 504:18 679:33]
  wire  _GEN_733 = dram_d_rdata_valid & _T_133; // @[Memory.scala 487:22 679:33]
  wire  _GEN_737 = dram_d_rdata_valid & _GEN_689; // @[Memory.scala 510:25 679:33]
  wire  _GEN_746 = dram_d_rdata_valid & _GEN_698; // @[Memory.scala 487:22 679:33]
  wire  _GEN_750 = dram_d_rdata_valid & _GEN_702; // @[Memory.scala 514:25 679:33]
  wire  _GEN_759 = dram_d_rdata_valid & _GEN_711; // @[Memory.scala 487:22 679:33]
  wire  _GEN_768 = dram_d_rdata_valid & _GEN_720; // @[Memory.scala 487:22 679:33]
  wire [2:0] _GEN_775 = dram_d_rdata_valid ? 3'h0 : dcache_state; // @[Memory.scala 679:33 724:22 490:29]
  wire [2:0] _GEN_824 = 3'h6 == dcache_state ? _GEN_775 : dcache_state; // @[Memory.scala 535:25 490:29]
  wire [2:0] _GEN_827 = 3'h5 == dcache_state ? _GEN_554 : _GEN_824; // @[Memory.scala 535:25]
  wire  _GEN_830 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_729; // @[Memory.scala 504:18 535:25]
  wire  _GEN_834 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_733; // @[Memory.scala 487:22 535:25]
  wire  _GEN_838 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_737; // @[Memory.scala 510:25 535:25]
  wire  _GEN_847 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_746; // @[Memory.scala 487:22 535:25]
  wire  _GEN_851 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_750; // @[Memory.scala 514:25 535:25]
  wire  _GEN_860 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_759; // @[Memory.scala 487:22 535:25]
  wire  _GEN_869 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_768; // @[Memory.scala 487:22 535:25]
  wire [255:0] _GEN_876 = 3'h3 == dcache_state ? line1 : reg_line1; // @[Memory.scala 535:25 492:26]
  wire [255:0] _GEN_877 = 3'h3 == dcache_state ? line2 : reg_line2; // @[Memory.scala 535:25 493:26]
  wire  _GEN_878 = 3'h3 == dcache_state ? _T_82 : _GEN_838; // @[Memory.scala 535:25]
  wire [31:0] _GEN_879 = 3'h3 == dcache_state ? wstrb : 32'hffffffff; // @[Memory.scala 535:25]
  wire [2:0] _GEN_889 = 3'h3 == dcache_state ? _GEN_609 : _GEN_827; // @[Memory.scala 535:25]
  wire  _GEN_890 = 3'h3 == dcache_state ? _GEN_610 : _GEN_851; // @[Memory.scala 535:25]
  wire [510:0] _GEN_893 = 3'h3 == dcache_state ? _wdata_T_4 : {{255'd0}, _GEN_659}; // @[Memory.scala 535:25]
  wire  _GEN_907 = 3'h3 == dcache_state ? 1'h0 : _GEN_830; // @[Memory.scala 504:18 535:25]
  wire  _GEN_911 = 3'h3 == dcache_state ? 1'h0 : _GEN_834; // @[Memory.scala 487:22 535:25]
  wire  _GEN_920 = 3'h3 == dcache_state ? 1'h0 : _GEN_847; // @[Memory.scala 487:22 535:25]
  wire  _GEN_929 = 3'h3 == dcache_state ? 1'h0 : _GEN_860; // @[Memory.scala 487:22 535:25]
  wire  _GEN_938 = 3'h3 == dcache_state ? 1'h0 : _GEN_869; // @[Memory.scala 487:22 535:25]
  wire  _GEN_947 = 3'h4 == dcache_state | _GEN_907; // @[Memory.scala 535:25 622:24]
  wire [2:0] _GEN_949 = 3'h4 == dcache_state ? 3'h0 : _GEN_889; // @[Memory.scala 535:25 624:22]
  wire [255:0] _GEN_950 = 3'h4 == dcache_state ? reg_line1 : _GEN_876; // @[Memory.scala 535:25 492:26]
  wire [255:0] _GEN_951 = 3'h4 == dcache_state ? reg_line2 : _GEN_877; // @[Memory.scala 535:25 493:26]
  wire  _GEN_952 = 3'h4 == dcache_state ? 1'h0 : _GEN_878; // @[Memory.scala 510:25 535:25]
  wire  _GEN_958 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _T_82; // @[Memory.scala 488:22 535:25]
  wire  _GEN_963 = 3'h4 == dcache_state ? 1'h0 : _GEN_890; // @[Memory.scala 514:25 535:25]
  wire  _GEN_969 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_610; // @[Memory.scala 488:22 535:25]
  wire  _GEN_980 = 3'h4 == dcache_state ? 1'h0 : _GEN_911; // @[Memory.scala 487:22 535:25]
  wire  _GEN_989 = 3'h4 == dcache_state ? 1'h0 : _GEN_920; // @[Memory.scala 487:22 535:25]
  wire  _GEN_998 = 3'h4 == dcache_state ? 1'h0 : _GEN_929; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1007 = 3'h4 == dcache_state ? 1'h0 : _GEN_938; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1024 = 3'h2 == dcache_state ? 1'h0 : _GEN_947; // @[Memory.scala 504:18 535:25]
  wire  _GEN_1026 = 3'h2 == dcache_state ? 1'h0 : _GEN_952; // @[Memory.scala 510:25 535:25]
  wire  _GEN_1032 = 3'h2 == dcache_state ? 1'h0 : _GEN_958; // @[Memory.scala 488:22 535:25]
  wire  _GEN_1037 = 3'h2 == dcache_state ? 1'h0 : _GEN_963; // @[Memory.scala 514:25 535:25]
  wire  _GEN_1043 = 3'h2 == dcache_state ? 1'h0 : _GEN_969; // @[Memory.scala 488:22 535:25]
  wire  _GEN_1050 = 3'h2 == dcache_state ? 1'h0 : _GEN_980; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1059 = 3'h2 == dcache_state ? 1'h0 : _GEN_989; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1068 = 3'h2 == dcache_state ? 1'h0 : _GEN_998; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1077 = 3'h2 == dcache_state ? 1'h0 : _GEN_1007; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1096 = 3'h1 == dcache_state ? 1'h0 : _GEN_1024; // @[Memory.scala 504:18 535:25]
  wire  _GEN_1098 = 3'h1 == dcache_state ? 1'h0 : _GEN_1026; // @[Memory.scala 510:25 535:25]
  wire  _GEN_1104 = 3'h1 == dcache_state ? 1'h0 : _GEN_1032; // @[Memory.scala 488:22 535:25]
  wire  _GEN_1109 = 3'h1 == dcache_state ? 1'h0 : _GEN_1037; // @[Memory.scala 514:25 535:25]
  wire  _GEN_1115 = 3'h1 == dcache_state ? 1'h0 : _GEN_1043; // @[Memory.scala 488:22 535:25]
  wire  _GEN_1122 = 3'h1 == dcache_state ? 1'h0 : _GEN_1050; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1131 = 3'h1 == dcache_state ? 1'h0 : _GEN_1059; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1140 = 3'h1 == dcache_state ? 1'h0 : _GEN_1068; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1149 = 3'h1 == dcache_state ? 1'h0 : _GEN_1077; // @[Memory.scala 487:22 535:25]
  wire  _GEN_1175 = 3'h0 == dcache_state ? _GEN_533 : reg_ren; // @[Memory.scala 498:24 535:25]
  wire  _GEN_1178 = 3'h0 == dcache_state & _GEN_536; // @[Memory.scala 487:22 535:25]
  wire  _T_155 = ~reset; // @[Memory.scala 752:9]
  assign i_tag_array_0_MPORT_en = _T_25 & _GEN_117;
  assign i_tag_array_0_MPORT_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_data = i_tag_array_0[i_tag_array_0_MPORT_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_1_en = _T_25 ? 1'h0 : _GEN_423;
  assign i_tag_array_0_MPORT_1_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_1_data = i_tag_array_0[i_tag_array_0_MPORT_1_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_3_en = _T_25 ? 1'h0 : _GEN_446;
  assign i_tag_array_0_MPORT_3_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_3_data = i_tag_array_0[i_tag_array_0_MPORT_3_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_5_en = _T_25 ? 1'h0 : _GEN_454;
  assign i_tag_array_0_MPORT_5_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_5_data = i_tag_array_0[i_tag_array_0_MPORT_5_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_2_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_2_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_2_mask = 1'h1;
  assign i_tag_array_0_MPORT_2_en = _T_25 ? 1'h0 : _GEN_435;
  assign i_tag_array_0_MPORT_4_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_4_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_4_mask = 1'h1;
  assign i_tag_array_0_MPORT_4_en = _T_25 ? 1'h0 : _GEN_449;
  assign tag_array_0_MPORT_6_en = _T_77 & dcache_snoop_en;
  assign tag_array_0_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_6_data = tag_array_0[tag_array_0_MPORT_6_addr]; // @[Memory.scala 487:22]
  assign tag_array_0_MPORT_7_en = _T_77 & _GEN_536;
  assign tag_array_0_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_0_MPORT_7_data = tag_array_0[tag_array_0_MPORT_7_addr]; // @[Memory.scala 487:22]
  assign tag_array_0_MPORT_10_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_10_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_10_mask = 1'h1;
  assign tag_array_0_MPORT_10_en = _T_77 ? 1'h0 : _GEN_1122;
  assign tag_array_0_MPORT_12_data = reg_tag_0;
  assign tag_array_0_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_12_mask = 1'h1;
  assign tag_array_0_MPORT_12_en = _T_77 ? 1'h0 : _GEN_1131;
  assign tag_array_0_MPORT_14_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_14_mask = 1'h1;
  assign tag_array_0_MPORT_14_en = _T_77 ? 1'h0 : _GEN_1140;
  assign tag_array_0_MPORT_16_data = reg_tag_0;
  assign tag_array_0_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_16_mask = 1'h1;
  assign tag_array_0_MPORT_16_en = _T_77 ? 1'h0 : _GEN_1149;
  assign tag_array_1_MPORT_6_en = _T_77 & dcache_snoop_en;
  assign tag_array_1_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_6_data = tag_array_1[tag_array_1_MPORT_6_addr]; // @[Memory.scala 487:22]
  assign tag_array_1_MPORT_7_en = _T_77 & _GEN_536;
  assign tag_array_1_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_1_MPORT_7_data = tag_array_1[tag_array_1_MPORT_7_addr]; // @[Memory.scala 487:22]
  assign tag_array_1_MPORT_10_data = reg_tag_1;
  assign tag_array_1_MPORT_10_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_10_mask = 1'h1;
  assign tag_array_1_MPORT_10_en = _T_77 ? 1'h0 : _GEN_1122;
  assign tag_array_1_MPORT_12_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_12_mask = 1'h1;
  assign tag_array_1_MPORT_12_en = _T_77 ? 1'h0 : _GEN_1131;
  assign tag_array_1_MPORT_14_data = reg_tag_1;
  assign tag_array_1_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_14_mask = 1'h1;
  assign tag_array_1_MPORT_14_en = _T_77 ? 1'h0 : _GEN_1140;
  assign tag_array_1_MPORT_16_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_16_mask = 1'h1;
  assign tag_array_1_MPORT_16_en = _T_77 ? 1'h0 : _GEN_1149;
  assign lru_array_way_hot_reg_lru_MPORT_en = _T_77 & _GEN_536;
  assign lru_array_way_hot_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_addr]; // @[Memory.scala 488:22]
  assign lru_array_way_hot_MPORT_8_data = _T_104[2];
  assign lru_array_way_hot_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_8_mask = 1'h1;
  assign lru_array_way_hot_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1104;
  assign lru_array_way_hot_MPORT_9_data = _T_109[2];
  assign lru_array_way_hot_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_9_mask = 1'h1;
  assign lru_array_way_hot_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1115;
  assign lru_array_way_hot_MPORT_11_data = _T_134[2];
  assign lru_array_way_hot_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_11_mask = 1'h1;
  assign lru_array_way_hot_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_way_hot_MPORT_13_data = _T_140[2];
  assign lru_array_way_hot_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_13_mask = 1'h1;
  assign lru_array_way_hot_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_way_hot_MPORT_15_data = _T_104[2];
  assign lru_array_way_hot_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_15_mask = 1'h1;
  assign lru_array_way_hot_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_way_hot_MPORT_17_data = _T_109[2];
  assign lru_array_way_hot_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_17_mask = 1'h1;
  assign lru_array_way_hot_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1149;
  assign lru_array_dirty1_reg_lru_MPORT_en = _T_77 & _GEN_536;
  assign lru_array_dirty1_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_addr]; // @[Memory.scala 488:22]
  assign lru_array_dirty1_MPORT_8_data = _T_104[1];
  assign lru_array_dirty1_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_8_mask = 1'h1;
  assign lru_array_dirty1_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1104;
  assign lru_array_dirty1_MPORT_9_data = _T_109[1];
  assign lru_array_dirty1_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_9_mask = 1'h1;
  assign lru_array_dirty1_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1115;
  assign lru_array_dirty1_MPORT_11_data = _T_134[1];
  assign lru_array_dirty1_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_11_mask = 1'h1;
  assign lru_array_dirty1_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_dirty1_MPORT_13_data = _T_140[1];
  assign lru_array_dirty1_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_13_mask = 1'h1;
  assign lru_array_dirty1_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_dirty1_MPORT_15_data = _T_104[1];
  assign lru_array_dirty1_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_15_mask = 1'h1;
  assign lru_array_dirty1_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_dirty1_MPORT_17_data = _T_109[1];
  assign lru_array_dirty1_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_17_mask = 1'h1;
  assign lru_array_dirty1_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1149;
  assign lru_array_dirty2_reg_lru_MPORT_en = _T_77 & _GEN_536;
  assign lru_array_dirty2_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_addr]; // @[Memory.scala 488:22]
  assign lru_array_dirty2_MPORT_8_data = _T_104[0];
  assign lru_array_dirty2_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_8_mask = 1'h1;
  assign lru_array_dirty2_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1104;
  assign lru_array_dirty2_MPORT_9_data = _T_109[0];
  assign lru_array_dirty2_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_9_mask = 1'h1;
  assign lru_array_dirty2_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1115;
  assign lru_array_dirty2_MPORT_11_data = _T_134[0];
  assign lru_array_dirty2_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_11_mask = 1'h1;
  assign lru_array_dirty2_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_dirty2_MPORT_13_data = _T_140[0];
  assign lru_array_dirty2_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_13_mask = 1'h1;
  assign lru_array_dirty2_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_dirty2_MPORT_15_data = _T_104[0];
  assign lru_array_dirty2_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_15_mask = 1'h1;
  assign lru_array_dirty2_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_dirty2_MPORT_17_data = _T_109[0];
  assign lru_array_dirty2_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_17_mask = 1'h1;
  assign lru_array_dirty2_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1149;
  assign io_imem_inst = 3'h0 == icache_state ? 32'hdeadbeef : _GEN_412; // @[Memory.scala 288:16 309:25]
  assign io_imem_valid = 3'h0 == icache_state ? 1'h0 : _GEN_413; // @[Memory.scala 289:17 309:25]
  assign io_icache_control_busy = 3'h0 == icache_state ? 1'h0 : _GEN_414; // @[Memory.scala 309:25 311:30]
  assign io_dmem_rdata = 3'h4 == dcache_state ? reg_read_word : _io_dmem_rdata_T_2[31:0]; // @[Memory.scala 535:25 623:23]
  assign io_dmem_rvalid = 3'h0 == dcache_state ? 1'h0 : _GEN_1096; // @[Memory.scala 504:18 535:25]
  assign io_dmem_wready = 3'h0 == dcache_state & _GEN_530; // @[Memory.scala 535:25]
  assign io_dramPort_ren = 3'h0 == reg_dram_state ? _GEN_25 : _GEN_83; // @[Memory.scala 189:27]
  assign io_dramPort_wen = 3'h0 == reg_dram_state ? _GEN_31 : _GEN_78; // @[Memory.scala 189:27]
  assign io_dramPort_addr = _GEN_90[27:0];
  assign io_dramPort_wdata = 3'h0 == reg_dram_state ? dram_d_wdata[127:0] : reg_dram_wdata; // @[Memory.scala 189:27]
  assign io_cache_array1_en = 3'h0 == dcache_state ? _GEN_526 : _GEN_1098; // @[Memory.scala 535:25]
  assign io_cache_array1_we = 3'h0 == dcache_state ? 32'h0 : _GEN_879; // @[Memory.scala 535:25]
  assign io_cache_array1_addr = 3'h0 == dcache_state ? _GEN_519 : reg_req_addr_index; // @[Memory.scala 535:25]
  assign io_cache_array1_wdata = 3'h3 == dcache_state ? wdata : _GEN_692; // @[Memory.scala 535:25]
  assign io_cache_array2_en = 3'h0 == dcache_state ? _GEN_526 : _GEN_1109; // @[Memory.scala 535:25]
  assign io_cache_array2_we = 3'h0 == dcache_state ? 32'h0 : _GEN_879; // @[Memory.scala 535:25]
  assign io_cache_array2_addr = 3'h0 == dcache_state ? _GEN_519 : reg_req_addr_index; // @[Memory.scala 535:25]
  assign io_cache_array2_wdata = _GEN_893[255:0];
  assign io_icache_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_408; // @[Memory.scala 309:25]
  assign io_icache_wen = 3'h0 == icache_state ? 1'h0 : _GEN_438; // @[Memory.scala 297:17 309:25]
  assign io_icache_raddr = 3'h0 == icache_state ? _io_icache_raddr_T_1 : _GEN_409; // @[Memory.scala 309:25]
  assign io_icache_waddr = i_reg_req_addr_index; // @[Memory.scala 309:25]
  assign io_icache_wdata = 3'h4 == icache_state ? dcache_snoop_line : dram_rdata; // @[Memory.scala 309:25]
  assign io_icache_valid_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_425; // @[Memory.scala 309:25]
  assign io_icache_valid_wen = 3'h0 == icache_state ? 1'h0 : _GEN_438; // @[Memory.scala 297:17 309:25]
  assign io_icache_valid_invalidate = 3'h0 == icache_state ? io_icache_control_invalidate : _GEN_418; // @[Memory.scala 309:25]
  assign io_icache_valid_addr = {{2'd0}, _GEN_470};
  assign io_icache_valid_iaddr = 3'h0 == icache_state ? 1'h0 : _GEN_359; // @[Memory.scala 309:25]
  assign io_icache_valid_wdata = 3'h4 == icache_state ? icache_valid_wdata : icache_valid_wdata; // @[Memory.scala 309:25]
  always @(posedge clock) begin
    if (i_tag_array_0_MPORT_2_en & i_tag_array_0_MPORT_2_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_2_addr] <= i_tag_array_0_MPORT_2_data; // @[Memory.scala 269:24]
    end
    if (i_tag_array_0_MPORT_4_en & i_tag_array_0_MPORT_4_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_4_addr] <= i_tag_array_0_MPORT_4_data; // @[Memory.scala 269:24]
    end
    if (tag_array_0_MPORT_10_en & tag_array_0_MPORT_10_mask) begin
      tag_array_0[tag_array_0_MPORT_10_addr] <= tag_array_0_MPORT_10_data; // @[Memory.scala 487:22]
    end
    if (tag_array_0_MPORT_12_en & tag_array_0_MPORT_12_mask) begin
      tag_array_0[tag_array_0_MPORT_12_addr] <= tag_array_0_MPORT_12_data; // @[Memory.scala 487:22]
    end
    if (tag_array_0_MPORT_14_en & tag_array_0_MPORT_14_mask) begin
      tag_array_0[tag_array_0_MPORT_14_addr] <= tag_array_0_MPORT_14_data; // @[Memory.scala 487:22]
    end
    if (tag_array_0_MPORT_16_en & tag_array_0_MPORT_16_mask) begin
      tag_array_0[tag_array_0_MPORT_16_addr] <= tag_array_0_MPORT_16_data; // @[Memory.scala 487:22]
    end
    if (tag_array_1_MPORT_10_en & tag_array_1_MPORT_10_mask) begin
      tag_array_1[tag_array_1_MPORT_10_addr] <= tag_array_1_MPORT_10_data; // @[Memory.scala 487:22]
    end
    if (tag_array_1_MPORT_12_en & tag_array_1_MPORT_12_mask) begin
      tag_array_1[tag_array_1_MPORT_12_addr] <= tag_array_1_MPORT_12_data; // @[Memory.scala 487:22]
    end
    if (tag_array_1_MPORT_14_en & tag_array_1_MPORT_14_mask) begin
      tag_array_1[tag_array_1_MPORT_14_addr] <= tag_array_1_MPORT_14_data; // @[Memory.scala 487:22]
    end
    if (tag_array_1_MPORT_16_en & tag_array_1_MPORT_16_mask) begin
      tag_array_1[tag_array_1_MPORT_16_addr] <= tag_array_1_MPORT_16_data; // @[Memory.scala 487:22]
    end
    if (lru_array_way_hot_MPORT_8_en & lru_array_way_hot_MPORT_8_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_8_addr] <= lru_array_way_hot_MPORT_8_data; // @[Memory.scala 488:22]
    end
    if (lru_array_way_hot_MPORT_9_en & lru_array_way_hot_MPORT_9_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_9_addr] <= lru_array_way_hot_MPORT_9_data; // @[Memory.scala 488:22]
    end
    if (lru_array_way_hot_MPORT_11_en & lru_array_way_hot_MPORT_11_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_11_addr] <= lru_array_way_hot_MPORT_11_data; // @[Memory.scala 488:22]
    end
    if (lru_array_way_hot_MPORT_13_en & lru_array_way_hot_MPORT_13_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_13_addr] <= lru_array_way_hot_MPORT_13_data; // @[Memory.scala 488:22]
    end
    if (lru_array_way_hot_MPORT_15_en & lru_array_way_hot_MPORT_15_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_15_addr] <= lru_array_way_hot_MPORT_15_data; // @[Memory.scala 488:22]
    end
    if (lru_array_way_hot_MPORT_17_en & lru_array_way_hot_MPORT_17_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_17_addr] <= lru_array_way_hot_MPORT_17_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_8_en & lru_array_dirty1_MPORT_8_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_8_addr] <= lru_array_dirty1_MPORT_8_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_9_en & lru_array_dirty1_MPORT_9_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_9_addr] <= lru_array_dirty1_MPORT_9_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_11_en & lru_array_dirty1_MPORT_11_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_11_addr] <= lru_array_dirty1_MPORT_11_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_13_en & lru_array_dirty1_MPORT_13_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_13_addr] <= lru_array_dirty1_MPORT_13_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_15_en & lru_array_dirty1_MPORT_15_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_15_addr] <= lru_array_dirty1_MPORT_15_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty1_MPORT_17_en & lru_array_dirty1_MPORT_17_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_17_addr] <= lru_array_dirty1_MPORT_17_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_8_en & lru_array_dirty2_MPORT_8_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_8_addr] <= lru_array_dirty2_MPORT_8_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_9_en & lru_array_dirty2_MPORT_9_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_9_addr] <= lru_array_dirty2_MPORT_9_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_11_en & lru_array_dirty2_MPORT_11_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_11_addr] <= lru_array_dirty2_MPORT_11_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_13_en & lru_array_dirty2_MPORT_13_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_13_addr] <= lru_array_dirty2_MPORT_13_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_15_en & lru_array_dirty2_MPORT_15_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_15_addr] <= lru_array_dirty2_MPORT_15_data; // @[Memory.scala 488:22]
    end
    if (lru_array_dirty2_MPORT_17_en & lru_array_dirty2_MPORT_17_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_17_addr] <= lru_array_dirty2_MPORT_17_data; // @[Memory.scala 488:22]
    end
    if (reset) begin // @[Memory.scala 171:31]
      reg_dram_state <= 3'h0; // @[Memory.scala 171:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 189:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 191:67]
        if (dram_i_ren) begin // @[Memory.scala 193:27]
          reg_dram_state <= 3'h2; // @[Memory.scala 198:26]
        end else begin
          reg_dram_state <= _GEN_12;
        end
      end
    end else if (3'h1 == reg_dram_state) begin // @[Memory.scala 189:27]
      if (_T_3) begin // @[Memory.scala 221:32]
        reg_dram_state <= 3'h0; // @[Memory.scala 226:24]
      end
    end else if (3'h2 == reg_dram_state) begin // @[Memory.scala 189:27]
      reg_dram_state <= _GEN_46;
    end else begin
      reg_dram_state <= _GEN_66;
    end
    if (reset) begin // @[Memory.scala 172:31]
      reg_dram_addr <= 27'h0; // @[Memory.scala 172:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 189:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 191:67]
        if (dram_i_ren) begin // @[Memory.scala 193:27]
          reg_dram_addr <= dram_i_addr; // @[Memory.scala 196:25]
        end else begin
          reg_dram_addr <= _GEN_9;
        end
      end
    end
    if (reset) begin // @[Memory.scala 173:31]
      reg_dram_wdata <= 128'h0; // @[Memory.scala 173:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 189:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 191:67]
        if (!(dram_i_ren)) begin // @[Memory.scala 193:27]
          reg_dram_wdata <= _GEN_10;
        end
      end
    end
    if (reset) begin // @[Memory.scala 174:31]
      reg_dram_rdata <= 128'h0; // @[Memory.scala 174:31]
    end else if (!(3'h0 == reg_dram_state)) begin // @[Memory.scala 189:27]
      if (!(3'h1 == reg_dram_state)) begin // @[Memory.scala 189:27]
        if (3'h2 == reg_dram_state) begin // @[Memory.scala 189:27]
          reg_dram_rdata <= _GEN_40;
        end else begin
          reg_dram_rdata <= _GEN_67;
        end
      end
    end
    reg_dram_di <= reset | _GEN_92; // @[Memory.scala 175:{28,28}]
    if (reset) begin // @[Memory.scala 271:29]
      icache_state <= 3'h0; // @[Memory.scala 271:29]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 309:25]
      if (io_icache_control_invalidate) begin // @[Memory.scala 314:43]
        icache_state <= 3'h7; // @[Memory.scala 318:22]
      end else if (io_imem_en) begin // @[Memory.scala 319:31]
        icache_state <= {{1'd0}, _GEN_103};
      end
    end else if (3'h1 == icache_state) begin // @[Memory.scala 309:25]
      if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 339:145]
        icache_state <= 3'h2; // @[Memory.scala 343:22]
      end else begin
        icache_state <= 3'h4; // @[Memory.scala 345:22]
      end
    end else if (3'h2 == icache_state) begin // @[Memory.scala 309:25]
      icache_state <= _GEN_132;
    end else begin
      icache_state <= _GEN_330;
    end
    if (reset) begin // @[Memory.scala 490:29]
      dcache_state <= 3'h0; // @[Memory.scala 490:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        dcache_state <= 3'h1; // @[Memory.scala 547:22]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
        dcache_state <= {{1'd0}, _GEN_507};
      end
    end else if (3'h1 == dcache_state) begin // @[Memory.scala 535:25]
      dcache_state <= 3'h0; // @[Memory.scala 584:20]
    end else if (3'h2 == dcache_state) begin // @[Memory.scala 535:25]
      dcache_state <= _GEN_567;
    end else begin
      dcache_state <= _GEN_949;
    end
    if (reset) begin // @[Memory.scala 491:24]
      reg_tag_0 <= 20'h0; // @[Memory.scala 491:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        reg_tag_0 <= tag_array_0_MPORT_6_data; // @[Memory.scala 540:17]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
        reg_tag_0 <= tag_array_0_MPORT_7_data; // @[Memory.scala 557:19]
      end
    end
    if (reset) begin // @[Memory.scala 495:29]
      reg_req_addr_tag <= 20'h0; // @[Memory.scala 495:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        reg_req_addr_tag <= dcache_snoop_addr_tag; // @[Memory.scala 539:22]
      end else begin
        reg_req_addr_tag <= req_addr_4_tag; // @[Memory.scala 552:22]
      end
    end
    if (reset) begin // @[Memory.scala 491:24]
      reg_tag_1 <= 20'h0; // @[Memory.scala 491:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        reg_tag_1 <= tag_array_1_MPORT_6_data; // @[Memory.scala 540:17]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
        reg_tag_1 <= tag_array_1_MPORT_7_data; // @[Memory.scala 557:19]
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_tag <= 20'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 309:25]
      i_reg_req_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 313:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 309:25]
        i_reg_req_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 355:22]
      end else begin
        i_reg_req_addr_tag <= _GEN_337;
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_index <= 7'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 309:25]
      i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 313:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 309:25]
        i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 355:22]
      end else begin
        i_reg_req_addr_index <= _GEN_336;
      end
    end
    if (reset) begin // @[Memory.scala 494:24]
      reg_lru_way_hot <= 1'h0; // @[Memory.scala 494:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 537:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
          reg_lru_way_hot <= lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 565:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 494:24]
      reg_lru_dirty1 <= 1'h0; // @[Memory.scala 494:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 537:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
          reg_lru_dirty1 <= lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 565:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 494:24]
      reg_lru_dirty2 <= 1'h0; // @[Memory.scala 494:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 537:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 556:43]
          reg_lru_dirty2 <= lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 565:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 495:29]
      reg_req_addr_index <= 7'h0; // @[Memory.scala 495:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        reg_req_addr_index <= dcache_snoop_addr_index; // @[Memory.scala 539:22]
      end else begin
        reg_req_addr_index <= req_addr_4_index; // @[Memory.scala 552:22]
      end
    end
    if (reset) begin // @[Memory.scala 499:32]
      reg_dcache_read <= 1'h0; // @[Memory.scala 499:32]
    end else begin
      reg_dcache_read <= _GEN_1178;
    end
    if (reset) begin // @[Memory.scala 492:26]
      reg_line1 <= 256'h0; // @[Memory.scala 492:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 535:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 535:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 535:25]
          reg_line1 <= line1;
        end else begin
          reg_line1 <= _GEN_950;
        end
      end
    end
    if (reset) begin // @[Memory.scala 493:26]
      reg_line2 <= 256'h0; // @[Memory.scala 493:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 535:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 535:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 535:25]
          reg_line2 <= line2;
        end else begin
          reg_line2 <= _GEN_951;
        end
      end
    end
    if (reset) begin // @[Memory.scala 272:26]
      i_reg_tag_0 <= 20'h0; // @[Memory.scala 272:26]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 309:25]
      if (!(io_icache_control_invalidate)) begin // @[Memory.scala 314:43]
        if (io_imem_en) begin // @[Memory.scala 319:31]
          i_reg_tag_0 <= i_tag_array_0_MPORT_data; // @[Memory.scala 320:19]
        end
      end
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 309:25]
        i_reg_tag_0 <= _GEN_134;
      end else begin
        i_reg_tag_0 <= _GEN_342;
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_line_off <= 5'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 309:25]
      i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 313:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 309:25]
        i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 355:22]
      end else begin
        i_reg_req_addr_line_off <= _GEN_335;
      end
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_tag <= 20'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 291:19]
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_index <= 7'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 291:19]
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_line_off <= 5'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 291:19]
    end
    if (reset) begin // @[Memory.scala 276:33]
      i_reg_snoop_inst <= 32'h0; // @[Memory.scala 276:33]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 309:25]
      if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
        if (!(3'h2 == icache_state)) begin // @[Memory.scala 309:25]
          i_reg_snoop_inst <= _GEN_315;
        end
      end
    end
    if (reset) begin // @[Memory.scala 277:39]
      i_reg_snoop_inst_valid <= 1'h0; // @[Memory.scala 277:39]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 309:25]
      if (!(3'h1 == icache_state)) begin // @[Memory.scala 309:25]
        if (!(3'h2 == icache_state)) begin // @[Memory.scala 309:25]
          i_reg_snoop_inst_valid <= _GEN_316;
        end
      end
    end
    if (reset) begin // @[Memory.scala 279:34]
      i_reg_valid_rdata <= 2'h0; // @[Memory.scala 279:34]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 309:25]
        i_reg_valid_rdata <= io_icache_valid_rdata; // @[Memory.scala 334:25]
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 309:25]
        i_reg_valid_rdata <= _GEN_329;
      end
    end
    if (reset) begin // @[Memory.scala 280:36]
      i_reg_cur_tag_index <= 27'h7ffffff; // @[Memory.scala 280:36]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 309:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 309:25]
        if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 339:145]
          i_reg_cur_tag_index <= _i_reg_cur_tag_index_T_1; // @[Memory.scala 342:29]
        end
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 309:25]
        i_reg_cur_tag_index <= _GEN_328;
      end
    end
    if (reset) begin // @[Memory.scala 281:33]
      i_reg_addr_match <= 1'h0; // @[Memory.scala 281:33]
    end else begin
      i_reg_addr_match <= _GEN_471;
    end
    if (reset) begin // @[Memory.scala 495:29]
      reg_req_addr_line_off <= 5'h0; // @[Memory.scala 495:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (dcache_snoop_en) begin // @[Memory.scala 537:30]
        reg_req_addr_line_off <= dcache_snoop_addr_line_off; // @[Memory.scala 539:22]
      end else begin
        reg_req_addr_line_off <= req_addr_4_line_off; // @[Memory.scala 552:22]
      end
    end
    if (reset) begin // @[Memory.scala 496:26]
      reg_wdata <= 32'h0; // @[Memory.scala 496:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 537:30]
        reg_wdata <= io_dmem_wdata; // @[Memory.scala 553:19]
      end
    end
    if (reset) begin // @[Memory.scala 497:26]
      reg_wstrb <= 4'h0; // @[Memory.scala 497:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 535:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 537:30]
        reg_wstrb <= io_dmem_wstrb; // @[Memory.scala 554:19]
      end
    end
    reg_ren <= reset | _GEN_1175; // @[Memory.scala 498:{24,24}]
    if (reset) begin // @[Memory.scala 500:30]
      reg_read_word <= 32'h0; // @[Memory.scala 500:30]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 535:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 535:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 535:25]
          reg_read_word <= _GEN_566;
        end
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"icache_state    : %d\n",icache_state); // @[Memory.scala 752:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_155) begin
          $fwrite(32'h80000002,"dcache_state    : %d\n",dcache_state); // @[Memory.scala 753:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_155) begin
          $fwrite(32'h80000002,"reg_dram_state  : %d\n",reg_dram_state); // @[Memory.scala 754:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    i_tag_array_0[initvar] = _RAND_0[19:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tag_array_0[initvar] = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tag_array_1[initvar] = _RAND_2[19:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_way_hot[initvar] = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_dirty1[initvar] = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_dirty2[initvar] = _RAND_5[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  reg_dram_state = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  reg_dram_addr = _RAND_7[26:0];
  _RAND_8 = {4{`RANDOM}};
  reg_dram_wdata = _RAND_8[127:0];
  _RAND_9 = {4{`RANDOM}};
  reg_dram_rdata = _RAND_9[127:0];
  _RAND_10 = {1{`RANDOM}};
  reg_dram_di = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  icache_state = _RAND_11[2:0];
  _RAND_12 = {1{`RANDOM}};
  dcache_state = _RAND_12[2:0];
  _RAND_13 = {1{`RANDOM}};
  reg_tag_0 = _RAND_13[19:0];
  _RAND_14 = {1{`RANDOM}};
  reg_req_addr_tag = _RAND_14[19:0];
  _RAND_15 = {1{`RANDOM}};
  reg_tag_1 = _RAND_15[19:0];
  _RAND_16 = {1{`RANDOM}};
  i_reg_req_addr_tag = _RAND_16[19:0];
  _RAND_17 = {1{`RANDOM}};
  i_reg_req_addr_index = _RAND_17[6:0];
  _RAND_18 = {1{`RANDOM}};
  reg_lru_way_hot = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  reg_lru_dirty1 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  reg_lru_dirty2 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  reg_req_addr_index = _RAND_21[6:0];
  _RAND_22 = {1{`RANDOM}};
  reg_dcache_read = _RAND_22[0:0];
  _RAND_23 = {8{`RANDOM}};
  reg_line1 = _RAND_23[255:0];
  _RAND_24 = {8{`RANDOM}};
  reg_line2 = _RAND_24[255:0];
  _RAND_25 = {1{`RANDOM}};
  i_reg_tag_0 = _RAND_25[19:0];
  _RAND_26 = {1{`RANDOM}};
  i_reg_req_addr_line_off = _RAND_26[4:0];
  _RAND_27 = {1{`RANDOM}};
  i_reg_next_addr_tag = _RAND_27[19:0];
  _RAND_28 = {1{`RANDOM}};
  i_reg_next_addr_index = _RAND_28[6:0];
  _RAND_29 = {1{`RANDOM}};
  i_reg_next_addr_line_off = _RAND_29[4:0];
  _RAND_30 = {1{`RANDOM}};
  i_reg_snoop_inst = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  i_reg_snoop_inst_valid = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  i_reg_valid_rdata = _RAND_32[1:0];
  _RAND_33 = {1{`RANDOM}};
  i_reg_cur_tag_index = _RAND_33[26:0];
  _RAND_34 = {1{`RANDOM}};
  i_reg_addr_match = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  reg_req_addr_line_off = _RAND_35[4:0];
  _RAND_36 = {1{`RANDOM}};
  reg_wdata = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  reg_wstrb = _RAND_37[3:0];
  _RAND_38 = {1{`RANDOM}};
  reg_ren = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  reg_read_word = _RAND_39[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BootRom(
  input         clock,
  input         reset,
  input         io_imem_en,
  input  [31:0] io_imem_addr,
  output [31:0] io_imem_inst,
  output        io_imem_valid,
  input  [31:0] io_dmem_raddr,
  output [31:0] io_dmem_rdata,
  input         io_dmem_ren,
  output        io_dmem_rvalid,
  input  [31:0] io_dmem_waddr,
  input         io_dmem_wen,
  input  [31:0] io_dmem_wdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] imem [0:511]; // @[BootRom.scala 26:17]
  wire  imem_imem_inst_MPORT_en; // @[BootRom.scala 26:17]
  wire [8:0] imem_imem_inst_MPORT_addr; // @[BootRom.scala 26:17]
  wire [31:0] imem_imem_inst_MPORT_data; // @[BootRom.scala 26:17]
  wire  imem_imem_rdata_MPORT_en; // @[BootRom.scala 26:17]
  wire [8:0] imem_imem_rdata_MPORT_addr; // @[BootRom.scala 26:17]
  wire [31:0] imem_imem_rdata_MPORT_data; // @[BootRom.scala 26:17]
  wire [31:0] imem_MPORT_data; // @[BootRom.scala 26:17]
  wire [8:0] imem_MPORT_addr; // @[BootRom.scala 26:17]
  wire  imem_MPORT_mask; // @[BootRom.scala 26:17]
  wire  imem_MPORT_en; // @[BootRom.scala 26:17]
  reg [31:0] imem_inst; // @[BootRom.scala 18:26]
  reg [31:0] imem_rdata; // @[BootRom.scala 19:27]
  reg  io_imem_valid_REG; // @[BootRom.scala 33:27]
  wire [31:0] _rwaddr_T = io_dmem_wen ? io_dmem_waddr : io_dmem_raddr; // @[BootRom.scala 35:19]
  wire  _T = ~io_dmem_wen; // @[BootRom.scala 39:9]
  reg  io_dmem_rvalid_REG; // @[BootRom.scala 43:28]
  assign imem_imem_inst_MPORT_en = io_imem_en;
  assign imem_imem_inst_MPORT_addr = io_imem_addr[10:2];
  assign imem_imem_inst_MPORT_data = imem[imem_imem_inst_MPORT_addr]; // @[BootRom.scala 26:17]
  assign imem_imem_rdata_MPORT_en = _T & io_dmem_ren;
  assign imem_imem_rdata_MPORT_addr = _rwaddr_T[10:2];
  assign imem_imem_rdata_MPORT_data = imem[imem_imem_rdata_MPORT_addr]; // @[BootRom.scala 26:17]
  assign imem_MPORT_data = io_dmem_wdata;
  assign imem_MPORT_addr = _rwaddr_T[10:2];
  assign imem_MPORT_mask = 1'h1;
  assign imem_MPORT_en = io_dmem_wen;
  assign io_imem_inst = imem_inst; // @[BootRom.scala 32:16]
  assign io_imem_valid = io_imem_valid_REG; // @[BootRom.scala 33:17]
  assign io_dmem_rdata = imem_rdata; // @[BootRom.scala 42:17]
  assign io_dmem_rvalid = io_dmem_rvalid_REG; // @[BootRom.scala 43:18]
  always @(posedge clock) begin
    if (imem_MPORT_en & imem_MPORT_mask) begin
      imem[imem_MPORT_addr] <= imem_MPORT_data; // @[BootRom.scala 26:17]
    end
    if (reset) begin // @[BootRom.scala 18:26]
      imem_inst <= 32'h0; // @[BootRom.scala 18:26]
    end else if (io_imem_en) begin // @[BootRom.scala 29:21]
      imem_inst <= imem_imem_inst_MPORT_data; // @[BootRom.scala 30:15]
    end
    if (reset) begin // @[BootRom.scala 19:27]
      imem_rdata <= 32'h0; // @[BootRom.scala 19:27]
    end else if (~io_dmem_wen & io_dmem_ren) begin // @[BootRom.scala 39:38]
      imem_rdata <= imem_imem_rdata_MPORT_data; // @[BootRom.scala 40:16]
    end
    if (reset) begin // @[BootRom.scala 33:27]
      io_imem_valid_REG <= 1'h0; // @[BootRom.scala 33:27]
    end else begin
      io_imem_valid_REG <= io_imem_en; // @[BootRom.scala 33:27]
    end
    if (reset) begin // @[BootRom.scala 43:28]
      io_dmem_rvalid_REG <= 1'h0; // @[BootRom.scala 43:28]
    end else begin
      io_dmem_rvalid_REG <= io_dmem_ren; // @[BootRom.scala 43:28]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
  integer initvar;
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  imem_inst = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  imem_rdata = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  io_imem_valid_REG = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  io_dmem_rvalid_REG = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  initial begin
    $readmemh("bootrom.hex", imem);
  end
endmodule
module Gpio(
  input         clock,
  input         reset,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  output [31:0] io_gpio
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] output_; // @[Gpio.scala 14:23]
  assign io_gpio = output_; // @[Gpio.scala 15:11]
  always @(posedge clock) begin
    if (reset) begin // @[Gpio.scala 14:23]
      output_ <= 32'h0; // @[Gpio.scala 14:23]
    end else if (io_mem_wen) begin // @[Gpio.scala 21:20]
      output_ <= io_mem_wdata; // @[Gpio.scala 22:12]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  output_ = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module UartTx(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  output       io_tx
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  reg [9:0] rateCounter; // @[Uart.scala 13:30]
  reg [3:0] bitCounter; // @[Uart.scala 14:29]
  reg  bits_0; // @[Uart.scala 15:19]
  reg  bits_1; // @[Uart.scala 15:19]
  reg  bits_2; // @[Uart.scala 15:19]
  reg  bits_3; // @[Uart.scala 15:19]
  reg  bits_4; // @[Uart.scala 15:19]
  reg  bits_5; // @[Uart.scala 15:19]
  reg  bits_6; // @[Uart.scala 15:19]
  reg  bits_7; // @[Uart.scala 15:19]
  reg  bits_8; // @[Uart.scala 15:19]
  reg  bits_9; // @[Uart.scala 15:19]
  wire [9:0] _T_1 = {1'h1,io_in_bits,1'h0}; // @[Cat.scala 31:58]
  wire  _GEN_0 = io_in_valid & io_in_ready ? _T_1[0] : bits_0; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_1 = io_in_valid & io_in_ready ? _T_1[1] : bits_1; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_2 = io_in_valid & io_in_ready ? _T_1[2] : bits_2; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_3 = io_in_valid & io_in_ready ? _T_1[3] : bits_3; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_4 = io_in_valid & io_in_ready ? _T_1[4] : bits_4; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_5 = io_in_valid & io_in_ready ? _T_1[5] : bits_5; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_6 = io_in_valid & io_in_ready ? _T_1[6] : bits_6; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_7 = io_in_valid & io_in_ready ? _T_1[7] : bits_7; // @[Uart.scala 20:38 21:14 15:19]
  wire  _GEN_8 = io_in_valid & io_in_ready ? _T_1[8] : bits_8; // @[Uart.scala 20:38 21:14 15:19]
  wire [3:0] _GEN_10 = io_in_valid & io_in_ready ? 4'ha : bitCounter; // @[Uart.scala 20:38 22:20 14:29]
  wire [3:0] _bitCounter_T_1 = bitCounter - 4'h1; // @[Uart.scala 30:38]
  wire [9:0] _rateCounter_T_1 = rateCounter - 10'h1; // @[Uart.scala 33:40]
  assign io_in_ready = bitCounter == 4'h0; // @[Uart.scala 18:31]
  assign io_tx = bitCounter == 4'h0 | bits_0; // @[Uart.scala 17:33]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 13:30]
      rateCounter <= 10'h0; // @[Uart.scala 13:30]
    end else if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        rateCounter <= 10'h363; // @[Uart.scala 31:25]
      end else begin
        rateCounter <= _rateCounter_T_1; // @[Uart.scala 33:25]
      end
    end else if (io_in_valid & io_in_ready) begin // @[Uart.scala 20:38]
      rateCounter <= 10'h363; // @[Uart.scala 23:21]
    end
    if (reset) begin // @[Uart.scala 14:29]
      bitCounter <= 4'h0; // @[Uart.scala 14:29]
    end else if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bitCounter <= _bitCounter_T_1; // @[Uart.scala 30:24]
      end else begin
        bitCounter <= _GEN_10;
      end
    end else begin
      bitCounter <= _GEN_10;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_0 <= bits_1; // @[Uart.scala 29:54]
      end else begin
        bits_0 <= _GEN_0;
      end
    end else begin
      bits_0 <= _GEN_0;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_1 <= bits_2; // @[Uart.scala 29:54]
      end else begin
        bits_1 <= _GEN_1;
      end
    end else begin
      bits_1 <= _GEN_1;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_2 <= bits_3; // @[Uart.scala 29:54]
      end else begin
        bits_2 <= _GEN_2;
      end
    end else begin
      bits_2 <= _GEN_2;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_3 <= bits_4; // @[Uart.scala 29:54]
      end else begin
        bits_3 <= _GEN_3;
      end
    end else begin
      bits_3 <= _GEN_3;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_4 <= bits_5; // @[Uart.scala 29:54]
      end else begin
        bits_4 <= _GEN_4;
      end
    end else begin
      bits_4 <= _GEN_4;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_5 <= bits_6; // @[Uart.scala 29:54]
      end else begin
        bits_5 <= _GEN_5;
      end
    end else begin
      bits_5 <= _GEN_5;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_6 <= bits_7; // @[Uart.scala 29:54]
      end else begin
        bits_6 <= _GEN_6;
      end
    end else begin
      bits_6 <= _GEN_6;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_7 <= bits_8; // @[Uart.scala 29:54]
      end else begin
        bits_7 <= _GEN_7;
      end
    end else begin
      bits_7 <= _GEN_7;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 26:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 27:35]
        bits_8 <= bits_9; // @[Uart.scala 29:54]
      end else begin
        bits_8 <= _GEN_8;
      end
    end else begin
      bits_8 <= _GEN_8;
    end
    if (io_in_valid & io_in_ready) begin // @[Uart.scala 20:38]
      bits_9 <= _T_1[9]; // @[Uart.scala 21:14]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rateCounter = _RAND_0[9:0];
  _RAND_1 = {1{`RANDOM}};
  bitCounter = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  bits_0 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  bits_1 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  bits_2 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  bits_3 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  bits_4 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  bits_5 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  bits_6 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  bits_7 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  bits_8 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  bits_9 = _RAND_11[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module UartRx(
  input        clock,
  input        reset,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits,
  input        io_rx,
  output       io_overrun
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] rateCounter; // @[Uart.scala 45:30]
  reg [2:0] bitCounter; // @[Uart.scala 46:29]
  reg  bits_1; // @[Uart.scala 47:19]
  reg  bits_2; // @[Uart.scala 47:19]
  reg  bits_3; // @[Uart.scala 47:19]
  reg  bits_4; // @[Uart.scala 47:19]
  reg  bits_5; // @[Uart.scala 47:19]
  reg  bits_6; // @[Uart.scala 47:19]
  reg  bits_7; // @[Uart.scala 47:19]
  reg  rxRegs_0; // @[Uart.scala 48:25]
  reg  rxRegs_1; // @[Uart.scala 48:25]
  reg  rxRegs_2; // @[Uart.scala 48:25]
  reg  overrun; // @[Uart.scala 49:26]
  reg  running; // @[Uart.scala 50:26]
  reg  outValid; // @[Uart.scala 52:27]
  reg [7:0] outBits; // @[Uart.scala 53:22]
  wire  _GEN_0 = outValid & io_out_ready ? 1'h0 : outValid; // @[Uart.scala 58:32 59:18 52:27]
  wire  _GEN_3 = ~rxRegs_1 & rxRegs_0 | running; // @[Uart.scala 69:39 72:21 50:26]
  wire [7:0] _outBits_T_1 = {rxRegs_0,bits_7,bits_6,bits_5,bits_4,bits_3,bits_2,bits_1}; // @[Cat.scala 31:58]
  wire [2:0] _bitCounter_T_1 = bitCounter - 3'h1; // @[Uart.scala 85:42]
  wire  _GEN_4 = bitCounter == 3'h0 | _GEN_0; // @[Uart.scala 78:38 79:26]
  wire [10:0] _rateCounter_T_1 = rateCounter - 11'h1; // @[Uart.scala 88:40]
  assign io_out_valid = outValid; // @[Uart.scala 55:18]
  assign io_out_bits = outBits; // @[Uart.scala 56:17]
  assign io_overrun = overrun; // @[Uart.scala 66:16]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 45:30]
      rateCounter <= 11'h0; // @[Uart.scala 45:30]
    end else if (~running) begin // @[Uart.scala 68:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[Uart.scala 69:39]
        rateCounter <= 11'h515; // @[Uart.scala 70:25]
      end
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
      if (!(bitCounter == 3'h0)) begin // @[Uart.scala 78:38]
        rateCounter <= 11'h363; // @[Uart.scala 84:29]
      end
    end else begin
      rateCounter <= _rateCounter_T_1; // @[Uart.scala 88:25]
    end
    if (reset) begin // @[Uart.scala 46:29]
      bitCounter <= 3'h0; // @[Uart.scala 46:29]
    end else if (~running) begin // @[Uart.scala 68:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[Uart.scala 69:39]
        bitCounter <= 3'h7; // @[Uart.scala 71:24]
      end
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
      if (!(bitCounter == 3'h0)) begin // @[Uart.scala 78:38]
        bitCounter <= _bitCounter_T_1; // @[Uart.scala 85:28]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_1 <= bits_2; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_2 <= bits_3; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_3 <= bits_4; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_4 <= bits_5; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_5 <= bits_6; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_6 <= bits_7; // @[Uart.scala 77:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        bits_7 <= rxRegs_0; // @[Uart.scala 76:34]
      end
    end
    if (reset) begin // @[Uart.scala 48:25]
      rxRegs_0 <= 1'h0; // @[Uart.scala 48:25]
    end else begin
      rxRegs_0 <= rxRegs_1; // @[Uart.scala 64:52]
    end
    if (reset) begin // @[Uart.scala 48:25]
      rxRegs_1 <= 1'h0; // @[Uart.scala 48:25]
    end else begin
      rxRegs_1 <= rxRegs_2; // @[Uart.scala 64:52]
    end
    if (reset) begin // @[Uart.scala 48:25]
      rxRegs_2 <= 1'h0; // @[Uart.scala 48:25]
    end else begin
      rxRegs_2 <= io_rx; // @[Uart.scala 63:26]
    end
    if (reset) begin // @[Uart.scala 49:26]
      overrun <= 1'h0; // @[Uart.scala 49:26]
    end else if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        if (bitCounter == 3'h0) begin // @[Uart.scala 78:38]
          overrun <= outValid; // @[Uart.scala 81:25]
        end
      end
    end
    if (reset) begin // @[Uart.scala 50:26]
      running <= 1'h0; // @[Uart.scala 50:26]
    end else if (~running) begin // @[Uart.scala 68:20]
      running <= _GEN_3;
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
      if (bitCounter == 3'h0) begin // @[Uart.scala 78:38]
        running <= 1'h0; // @[Uart.scala 82:25]
      end
    end
    if (reset) begin // @[Uart.scala 52:27]
      outValid <= 1'h0; // @[Uart.scala 52:27]
    end else if (~running) begin // @[Uart.scala 68:20]
      outValid <= _GEN_0;
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
      outValid <= _GEN_4;
    end else begin
      outValid <= _GEN_0;
    end
    if (!(~running)) begin // @[Uart.scala 68:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 75:35]
        if (bitCounter == 3'h0) begin // @[Uart.scala 78:38]
          outBits <= _outBits_T_1; // @[Uart.scala 80:25]
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rateCounter = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  bitCounter = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  bits_1 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  bits_2 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  bits_3 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  bits_4 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  bits_5 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  bits_6 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  bits_7 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  rxRegs_0 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  rxRegs_1 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  rxRegs_2 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  overrun = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  running = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  outValid = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  outBits = _RAND_15[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Uart(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata,
  input         io_mem_ren,
  input  [31:0] io_mem_waddr,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  output        io_intr,
  output        io_tx,
  input         io_rx
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[Uart.scala 103:18]
  wire  tx_reset; // @[Uart.scala 103:18]
  wire  tx_io_in_ready; // @[Uart.scala 103:18]
  wire  tx_io_in_valid; // @[Uart.scala 103:18]
  wire [7:0] tx_io_in_bits; // @[Uart.scala 103:18]
  wire  tx_io_tx; // @[Uart.scala 103:18]
  wire  rx_clock; // @[Uart.scala 111:18]
  wire  rx_reset; // @[Uart.scala 111:18]
  wire  rx_io_out_ready; // @[Uart.scala 111:18]
  wire  rx_io_out_valid; // @[Uart.scala 111:18]
  wire [7:0] rx_io_out_bits; // @[Uart.scala 111:18]
  wire  rx_io_rx; // @[Uart.scala 111:18]
  wire  rx_io_overrun; // @[Uart.scala 111:18]
  reg  intr; // @[Uart.scala 101:21]
  reg  tx_empty; // @[Uart.scala 104:25]
  reg [7:0] tx_data; // @[Uart.scala 106:24]
  reg  tx_intr_en; // @[Uart.scala 107:27]
  wire  _tx_io_in_valid_T = ~tx_empty; // @[Uart.scala 108:21]
  reg [7:0] rx_data; // @[Uart.scala 112:24]
  reg  rx_data_ready; // @[Uart.scala 113:30]
  reg  rx_intr_en; // @[Uart.scala 114:27]
  wire  _rx_io_out_ready_T = ~rx_data_ready; // @[Uart.scala 116:22]
  wire  _GEN_1 = rx_io_out_valid & _rx_io_out_ready_T | rx_data_ready; // @[Uart.scala 117:44 119:19 113:30]
  wire [31:0] _io_mem_rdata_T_1 = {27'h0,rx_io_overrun,rx_data_ready,_tx_io_in_valid_T,rx_intr_en,tx_intr_en}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_2 = 2'h1 == io_mem_raddr[3:2] ? {{24'd0}, rx_data} : 32'hdeadbeef; // @[Uart.scala 122:16 128:33 133:22]
  wire [31:0] _GEN_4 = 2'h0 == io_mem_raddr[3:2] ? _io_mem_rdata_T_1 : _GEN_2; // @[Uart.scala 128:33 130:22]
  wire  _GEN_8 = tx_empty ? 1'h0 : tx_empty; // @[Uart.scala 146:25 147:20 104:25]
  wire [31:0] _GEN_9 = tx_empty ? io_mem_wdata : {{24'd0}, tx_data}; // @[Uart.scala 146:25 148:19 106:24]
  wire  _GEN_10 = 2'h1 == io_mem_waddr[3:2] ? _GEN_8 : tx_empty; // @[Uart.scala 104:25 140:33]
  wire [31:0] _GEN_11 = 2'h1 == io_mem_waddr[3:2] ? _GEN_9 : {{24'd0}, tx_data}; // @[Uart.scala 106:24 140:33]
  wire  _GEN_14 = 2'h0 == io_mem_waddr[3:2] ? tx_empty : _GEN_10; // @[Uart.scala 104:25 140:33]
  wire [31:0] _GEN_15 = 2'h0 == io_mem_waddr[3:2] ? {{24'd0}, tx_data} : _GEN_11; // @[Uart.scala 106:24 140:33]
  wire  _GEN_18 = io_mem_wen ? _GEN_14 : tx_empty; // @[Uart.scala 139:21 104:25]
  wire [31:0] _GEN_19 = io_mem_wen ? _GEN_15 : {{24'd0}, tx_data}; // @[Uart.scala 139:21 106:24]
  wire  tx_ready = tx_io_in_ready;
  wire  _GEN_20 = _tx_io_in_valid_T & tx_ready | _GEN_18; // @[Uart.scala 154:31 155:14]
  wire [31:0] _GEN_21 = reset ? 32'h0 : _GEN_19; // @[Uart.scala 106:{24,24}]
  UartTx tx ( // @[Uart.scala 103:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_in_ready(tx_io_in_ready),
    .io_in_valid(tx_io_in_valid),
    .io_in_bits(tx_io_in_bits),
    .io_tx(tx_io_tx)
  );
  UartRx rx ( // @[Uart.scala 111:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_out_ready(rx_io_out_ready),
    .io_out_valid(rx_io_out_valid),
    .io_out_bits(rx_io_out_bits),
    .io_rx(rx_io_rx),
    .io_overrun(rx_io_overrun)
  );
  assign io_mem_rdata = io_mem_ren ? _GEN_4 : 32'hdeadbeef; // @[Uart.scala 122:16 127:21]
  assign io_intr = intr; // @[Uart.scala 159:11]
  assign io_tx = tx_io_tx; // @[Uart.scala 160:9]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = ~tx_empty; // @[Uart.scala 108:21]
  assign tx_io_in_bits = tx_data; // @[Uart.scala 109:17]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_out_ready = ~rx_data_ready; // @[Uart.scala 116:22]
  assign rx_io_rx = io_rx; // @[Uart.scala 161:9]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 101:21]
      intr <= 1'h0; // @[Uart.scala 101:21]
    end else begin
      intr <= tx_empty & tx_intr_en | rx_data_ready & rx_intr_en; // @[Uart.scala 158:8]
    end
    tx_empty <= reset | _GEN_20; // @[Uart.scala 104:{25,25}]
    tx_data <= _GEN_21[7:0]; // @[Uart.scala 106:{24,24}]
    if (reset) begin // @[Uart.scala 107:27]
      tx_intr_en <= 1'h0; // @[Uart.scala 107:27]
    end else if (io_mem_wen) begin // @[Uart.scala 139:21]
      if (2'h0 == io_mem_waddr[3:2]) begin // @[Uart.scala 140:33]
        tx_intr_en <= io_mem_wdata[0]; // @[Uart.scala 142:20]
      end
    end
    if (reset) begin // @[Uart.scala 112:24]
      rx_data <= 8'h0; // @[Uart.scala 112:24]
    end else if (rx_io_out_valid & _rx_io_out_ready_T) begin // @[Uart.scala 117:44]
      rx_data <= rx_io_out_bits; // @[Uart.scala 118:13]
    end
    if (reset) begin // @[Uart.scala 113:30]
      rx_data_ready <= 1'h0; // @[Uart.scala 113:30]
    end else if (io_mem_ren) begin // @[Uart.scala 127:21]
      if (2'h0 == io_mem_raddr[3:2]) begin // @[Uart.scala 128:33]
        rx_data_ready <= _GEN_1;
      end else if (2'h1 == io_mem_raddr[3:2]) begin // @[Uart.scala 128:33]
        rx_data_ready <= 1'h0; // @[Uart.scala 134:23]
      end else begin
        rx_data_ready <= _GEN_1;
      end
    end else begin
      rx_data_ready <= _GEN_1;
    end
    if (reset) begin // @[Uart.scala 114:27]
      rx_intr_en <= 1'h0; // @[Uart.scala 114:27]
    end else if (io_mem_wen) begin // @[Uart.scala 139:21]
      if (2'h0 == io_mem_waddr[3:2]) begin // @[Uart.scala 140:33]
        rx_intr_en <= io_mem_wdata[1]; // @[Uart.scala 143:20]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  intr = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  tx_empty = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  tx_data = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  tx_intr_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  rx_data = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  rx_data_ready = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  rx_intr_en = _RAND_6[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Sdc(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata,
  input         io_mem_ren,
  input  [31:0] io_mem_waddr,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  output        io_sdc_port_clk,
  output        io_sdc_port_cmd_wrt,
  output        io_sdc_port_cmd_out,
  input         io_sdc_port_res_in,
  output        io_sdc_port_dat_wrt,
  output [3:0]  io_sdc_port_dat_out,
  input  [3:0]  io_sdc_port_dat_in,
  output        io_sdbuf_ren1,
  output        io_sdbuf_wen1,
  output [7:0]  io_sdbuf_addr1,
  input  [31:0] io_sdbuf_rdata1,
  output [31:0] io_sdbuf_wdata1,
  output        io_sdbuf_ren2,
  output        io_sdbuf_wen2,
  output [7:0]  io_sdbuf_addr2,
  input  [31:0] io_sdbuf_rdata2,
  output [31:0] io_sdbuf_wdata2,
  output        io_intr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [31:0] _RAND_77;
  reg [31:0] _RAND_78;
  reg [31:0] _RAND_79;
  reg [31:0] _RAND_80;
  reg [31:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
  reg [31:0] _RAND_99;
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
  reg [31:0] _RAND_105;
  reg [31:0] _RAND_106;
  reg [31:0] _RAND_107;
  reg [31:0] _RAND_108;
  reg [31:0] _RAND_109;
  reg [31:0] _RAND_110;
  reg [31:0] _RAND_111;
  reg [31:0] _RAND_112;
  reg [31:0] _RAND_113;
  reg [31:0] _RAND_114;
  reg [31:0] _RAND_115;
  reg [31:0] _RAND_116;
  reg [31:0] _RAND_117;
  reg [31:0] _RAND_118;
  reg [31:0] _RAND_119;
  reg [31:0] _RAND_120;
  reg [31:0] _RAND_121;
  reg [31:0] _RAND_122;
  reg [31:0] _RAND_123;
  reg [31:0] _RAND_124;
  reg [31:0] _RAND_125;
  reg [31:0] _RAND_126;
  reg [31:0] _RAND_127;
  reg [31:0] _RAND_128;
  reg [31:0] _RAND_129;
  reg [31:0] _RAND_130;
  reg [31:0] _RAND_131;
  reg [31:0] _RAND_132;
  reg [31:0] _RAND_133;
  reg [31:0] _RAND_134;
  reg [31:0] _RAND_135;
  reg [31:0] _RAND_136;
  reg [31:0] _RAND_137;
  reg [31:0] _RAND_138;
  reg [31:0] _RAND_139;
  reg [31:0] _RAND_140;
  reg [31:0] _RAND_141;
  reg [31:0] _RAND_142;
  reg [31:0] _RAND_143;
  reg [31:0] _RAND_144;
  reg [159:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
  reg [31:0] _RAND_149;
  reg [31:0] _RAND_150;
  reg [31:0] _RAND_151;
  reg [31:0] _RAND_152;
  reg [31:0] _RAND_153;
  reg [31:0] _RAND_154;
  reg [31:0] _RAND_155;
  reg [31:0] _RAND_156;
  reg [31:0] _RAND_157;
  reg [31:0] _RAND_158;
  reg [31:0] _RAND_159;
  reg [31:0] _RAND_160;
  reg [31:0] _RAND_161;
  reg [31:0] _RAND_162;
  reg [31:0] _RAND_163;
  reg [31:0] _RAND_164;
  reg [31:0] _RAND_165;
  reg [31:0] _RAND_166;
  reg [31:0] _RAND_167;
  reg [31:0] _RAND_168;
  reg [31:0] _RAND_169;
  reg [31:0] _RAND_170;
  reg [31:0] _RAND_171;
  reg [31:0] _RAND_172;
  reg [31:0] _RAND_173;
  reg [31:0] _RAND_174;
  reg [31:0] _RAND_175;
  reg [31:0] _RAND_176;
  reg [31:0] _RAND_177;
  reg [31:0] _RAND_178;
  reg [31:0] _RAND_179;
  reg [31:0] _RAND_180;
  reg [31:0] _RAND_181;
  reg [31:0] _RAND_182;
  reg [31:0] _RAND_183;
  reg [31:0] _RAND_184;
  reg [31:0] _RAND_185;
  reg [31:0] _RAND_186;
  reg [31:0] _RAND_187;
  reg [31:0] _RAND_188;
  reg [31:0] _RAND_189;
  reg [31:0] _RAND_190;
  reg [31:0] _RAND_191;
  reg [31:0] _RAND_192;
  reg [31:0] _RAND_193;
  reg [31:0] _RAND_194;
  reg [31:0] _RAND_195;
  reg [31:0] _RAND_196;
  reg [31:0] _RAND_197;
  reg [31:0] _RAND_198;
  reg [31:0] _RAND_199;
  reg [31:0] _RAND_200;
  reg [31:0] _RAND_201;
  reg [31:0] _RAND_202;
  reg [31:0] _RAND_203;
  reg [31:0] _RAND_204;
  reg [31:0] _RAND_205;
  reg [31:0] _RAND_206;
  reg [31:0] _RAND_207;
  reg [31:0] _RAND_208;
  reg [31:0] _RAND_209;
  reg [31:0] _RAND_210;
  reg [31:0] _RAND_211;
  reg [31:0] _RAND_212;
  reg [31:0] _RAND_213;
  reg [31:0] _RAND_214;
  reg [31:0] _RAND_215;
  reg [31:0] _RAND_216;
  reg [31:0] _RAND_217;
  reg [31:0] _RAND_218;
  reg [31:0] _RAND_219;
  reg [31:0] _RAND_220;
  reg [31:0] _RAND_221;
  reg [31:0] _RAND_222;
  reg [31:0] _RAND_223;
  reg [31:0] _RAND_224;
  reg [31:0] _RAND_225;
  reg [31:0] _RAND_226;
  reg [31:0] _RAND_227;
  reg [31:0] _RAND_228;
  reg [31:0] _RAND_229;
  reg [31:0] _RAND_230;
  reg [31:0] _RAND_231;
  reg [31:0] _RAND_232;
  reg [31:0] _RAND_233;
  reg [31:0] _RAND_234;
  reg [31:0] _RAND_235;
  reg [31:0] _RAND_236;
  reg [31:0] _RAND_237;
  reg [31:0] _RAND_238;
  reg [31:0] _RAND_239;
  reg [31:0] _RAND_240;
  reg [31:0] _RAND_241;
  reg [31:0] _RAND_242;
  reg [31:0] _RAND_243;
  reg [31:0] _RAND_244;
  reg [31:0] _RAND_245;
  reg [31:0] _RAND_246;
  reg [31:0] _RAND_247;
  reg [31:0] _RAND_248;
  reg [31:0] _RAND_249;
  reg [31:0] _RAND_250;
  reg [31:0] _RAND_251;
  reg [31:0] _RAND_252;
  reg [31:0] _RAND_253;
  reg [31:0] _RAND_254;
  reg [31:0] _RAND_255;
  reg [31:0] _RAND_256;
  reg [31:0] _RAND_257;
  reg [31:0] _RAND_258;
  reg [31:0] _RAND_259;
  reg [31:0] _RAND_260;
  reg [31:0] _RAND_261;
  reg [31:0] _RAND_262;
  reg [31:0] _RAND_263;
  reg [31:0] _RAND_264;
  reg [31:0] _RAND_265;
  reg [31:0] _RAND_266;
  reg [31:0] _RAND_267;
  reg [31:0] _RAND_268;
  reg [31:0] _RAND_269;
  reg [31:0] _RAND_270;
  reg [31:0] _RAND_271;
  reg [31:0] _RAND_272;
  reg [31:0] _RAND_273;
  reg [31:0] _RAND_274;
  reg [31:0] _RAND_275;
  reg [31:0] _RAND_276;
  reg [31:0] _RAND_277;
  reg [31:0] _RAND_278;
  reg [31:0] _RAND_279;
  reg [31:0] _RAND_280;
  reg [31:0] _RAND_281;
  reg [31:0] _RAND_282;
  reg [31:0] _RAND_283;
  reg [31:0] _RAND_284;
  reg [31:0] _RAND_285;
  reg [31:0] _RAND_286;
  reg [31:0] _RAND_287;
  reg [31:0] _RAND_288;
  reg [31:0] _RAND_289;
  reg [31:0] _RAND_290;
  reg [31:0] _RAND_291;
  reg [31:0] _RAND_292;
  reg [31:0] _RAND_293;
  reg [31:0] _RAND_294;
  reg [31:0] _RAND_295;
  reg [31:0] _RAND_296;
  reg [31:0] _RAND_297;
  reg [31:0] _RAND_298;
  reg [31:0] _RAND_299;
  reg [31:0] _RAND_300;
  reg [31:0] _RAND_301;
  reg [31:0] _RAND_302;
  reg [31:0] _RAND_303;
  reg [31:0] _RAND_304;
  reg [31:0] _RAND_305;
  reg [31:0] _RAND_306;
  reg [31:0] _RAND_307;
  reg [31:0] _RAND_308;
  reg [31:0] _RAND_309;
  reg [31:0] _RAND_310;
  reg [31:0] _RAND_311;
  reg [31:0] _RAND_312;
  reg [31:0] _RAND_313;
  reg [31:0] _RAND_314;
  reg [31:0] _RAND_315;
  reg [31:0] _RAND_316;
  reg [31:0] _RAND_317;
  reg [31:0] _RAND_318;
  reg [31:0] _RAND_319;
  reg [31:0] _RAND_320;
  reg [31:0] _RAND_321;
  reg [31:0] _RAND_322;
`endif // RANDOMIZE_REG_INIT
  reg  reg_power; // @[Sdc.scala 88:26]
  reg [8:0] reg_baud_divider; // @[Sdc.scala 89:33]
  reg [8:0] reg_clk_counter; // @[Sdc.scala 90:32]
  reg  reg_clk; // @[Sdc.scala 91:24]
  wire  _T = reg_clk_counter == 9'h0; // @[Sdc.scala 93:27]
  wire [8:0] _reg_clk_counter_T_1 = reg_clk_counter - 9'h1; // @[Sdc.scala 97:42]
  wire [8:0] _GEN_0 = reg_clk_counter == 9'h0 ? reg_baud_divider : _reg_clk_counter_T_1; // @[Sdc.scala 93:36 94:23 97:23]
  wire  _GEN_1 = reg_clk_counter == 9'h0 ? ~reg_clk : reg_clk; // @[Sdc.scala 93:36 95:15 91:24]
  wire [8:0] _GEN_2 = reg_power ? _GEN_0 : reg_clk_counter; // @[Sdc.scala 92:20 90:32]
  wire  _GEN_3 = reg_power & _GEN_1; // @[Sdc.scala 100:13 92:20]
  reg  intr; // @[Sdc.scala 104:21]
  reg  rx_res_in_progress; // @[Sdc.scala 106:35]
  reg [7:0] rx_res_counter; // @[Sdc.scala 107:31]
  reg  rx_res_bits_0; // @[Sdc.scala 108:24]
  reg  rx_res_bits_1; // @[Sdc.scala 108:24]
  reg  rx_res_bits_2; // @[Sdc.scala 108:24]
  reg  rx_res_bits_3; // @[Sdc.scala 108:24]
  reg  rx_res_bits_4; // @[Sdc.scala 108:24]
  reg  rx_res_bits_5; // @[Sdc.scala 108:24]
  reg  rx_res_bits_6; // @[Sdc.scala 108:24]
  reg  rx_res_bits_7; // @[Sdc.scala 108:24]
  reg  rx_res_bits_8; // @[Sdc.scala 108:24]
  reg  rx_res_bits_9; // @[Sdc.scala 108:24]
  reg  rx_res_bits_10; // @[Sdc.scala 108:24]
  reg  rx_res_bits_11; // @[Sdc.scala 108:24]
  reg  rx_res_bits_12; // @[Sdc.scala 108:24]
  reg  rx_res_bits_13; // @[Sdc.scala 108:24]
  reg  rx_res_bits_14; // @[Sdc.scala 108:24]
  reg  rx_res_bits_15; // @[Sdc.scala 108:24]
  reg  rx_res_bits_16; // @[Sdc.scala 108:24]
  reg  rx_res_bits_17; // @[Sdc.scala 108:24]
  reg  rx_res_bits_18; // @[Sdc.scala 108:24]
  reg  rx_res_bits_19; // @[Sdc.scala 108:24]
  reg  rx_res_bits_20; // @[Sdc.scala 108:24]
  reg  rx_res_bits_21; // @[Sdc.scala 108:24]
  reg  rx_res_bits_22; // @[Sdc.scala 108:24]
  reg  rx_res_bits_23; // @[Sdc.scala 108:24]
  reg  rx_res_bits_24; // @[Sdc.scala 108:24]
  reg  rx_res_bits_25; // @[Sdc.scala 108:24]
  reg  rx_res_bits_26; // @[Sdc.scala 108:24]
  reg  rx_res_bits_27; // @[Sdc.scala 108:24]
  reg  rx_res_bits_28; // @[Sdc.scala 108:24]
  reg  rx_res_bits_29; // @[Sdc.scala 108:24]
  reg  rx_res_bits_30; // @[Sdc.scala 108:24]
  reg  rx_res_bits_31; // @[Sdc.scala 108:24]
  reg  rx_res_bits_32; // @[Sdc.scala 108:24]
  reg  rx_res_bits_33; // @[Sdc.scala 108:24]
  reg  rx_res_bits_34; // @[Sdc.scala 108:24]
  reg  rx_res_bits_35; // @[Sdc.scala 108:24]
  reg  rx_res_bits_36; // @[Sdc.scala 108:24]
  reg  rx_res_bits_37; // @[Sdc.scala 108:24]
  reg  rx_res_bits_38; // @[Sdc.scala 108:24]
  reg  rx_res_bits_39; // @[Sdc.scala 108:24]
  reg  rx_res_bits_40; // @[Sdc.scala 108:24]
  reg  rx_res_bits_41; // @[Sdc.scala 108:24]
  reg  rx_res_bits_42; // @[Sdc.scala 108:24]
  reg  rx_res_bits_43; // @[Sdc.scala 108:24]
  reg  rx_res_bits_44; // @[Sdc.scala 108:24]
  reg  rx_res_bits_45; // @[Sdc.scala 108:24]
  reg  rx_res_bits_46; // @[Sdc.scala 108:24]
  reg  rx_res_bits_47; // @[Sdc.scala 108:24]
  reg  rx_res_bits_48; // @[Sdc.scala 108:24]
  reg  rx_res_bits_49; // @[Sdc.scala 108:24]
  reg  rx_res_bits_50; // @[Sdc.scala 108:24]
  reg  rx_res_bits_51; // @[Sdc.scala 108:24]
  reg  rx_res_bits_52; // @[Sdc.scala 108:24]
  reg  rx_res_bits_53; // @[Sdc.scala 108:24]
  reg  rx_res_bits_54; // @[Sdc.scala 108:24]
  reg  rx_res_bits_55; // @[Sdc.scala 108:24]
  reg  rx_res_bits_56; // @[Sdc.scala 108:24]
  reg  rx_res_bits_57; // @[Sdc.scala 108:24]
  reg  rx_res_bits_58; // @[Sdc.scala 108:24]
  reg  rx_res_bits_59; // @[Sdc.scala 108:24]
  reg  rx_res_bits_60; // @[Sdc.scala 108:24]
  reg  rx_res_bits_61; // @[Sdc.scala 108:24]
  reg  rx_res_bits_62; // @[Sdc.scala 108:24]
  reg  rx_res_bits_63; // @[Sdc.scala 108:24]
  reg  rx_res_bits_64; // @[Sdc.scala 108:24]
  reg  rx_res_bits_65; // @[Sdc.scala 108:24]
  reg  rx_res_bits_66; // @[Sdc.scala 108:24]
  reg  rx_res_bits_67; // @[Sdc.scala 108:24]
  reg  rx_res_bits_68; // @[Sdc.scala 108:24]
  reg  rx_res_bits_69; // @[Sdc.scala 108:24]
  reg  rx_res_bits_70; // @[Sdc.scala 108:24]
  reg  rx_res_bits_71; // @[Sdc.scala 108:24]
  reg  rx_res_bits_72; // @[Sdc.scala 108:24]
  reg  rx_res_bits_73; // @[Sdc.scala 108:24]
  reg  rx_res_bits_74; // @[Sdc.scala 108:24]
  reg  rx_res_bits_75; // @[Sdc.scala 108:24]
  reg  rx_res_bits_76; // @[Sdc.scala 108:24]
  reg  rx_res_bits_77; // @[Sdc.scala 108:24]
  reg  rx_res_bits_78; // @[Sdc.scala 108:24]
  reg  rx_res_bits_79; // @[Sdc.scala 108:24]
  reg  rx_res_bits_80; // @[Sdc.scala 108:24]
  reg  rx_res_bits_81; // @[Sdc.scala 108:24]
  reg  rx_res_bits_82; // @[Sdc.scala 108:24]
  reg  rx_res_bits_83; // @[Sdc.scala 108:24]
  reg  rx_res_bits_84; // @[Sdc.scala 108:24]
  reg  rx_res_bits_85; // @[Sdc.scala 108:24]
  reg  rx_res_bits_86; // @[Sdc.scala 108:24]
  reg  rx_res_bits_87; // @[Sdc.scala 108:24]
  reg  rx_res_bits_88; // @[Sdc.scala 108:24]
  reg  rx_res_bits_89; // @[Sdc.scala 108:24]
  reg  rx_res_bits_90; // @[Sdc.scala 108:24]
  reg  rx_res_bits_91; // @[Sdc.scala 108:24]
  reg  rx_res_bits_92; // @[Sdc.scala 108:24]
  reg  rx_res_bits_93; // @[Sdc.scala 108:24]
  reg  rx_res_bits_94; // @[Sdc.scala 108:24]
  reg  rx_res_bits_95; // @[Sdc.scala 108:24]
  reg  rx_res_bits_96; // @[Sdc.scala 108:24]
  reg  rx_res_bits_97; // @[Sdc.scala 108:24]
  reg  rx_res_bits_98; // @[Sdc.scala 108:24]
  reg  rx_res_bits_99; // @[Sdc.scala 108:24]
  reg  rx_res_bits_100; // @[Sdc.scala 108:24]
  reg  rx_res_bits_101; // @[Sdc.scala 108:24]
  reg  rx_res_bits_102; // @[Sdc.scala 108:24]
  reg  rx_res_bits_103; // @[Sdc.scala 108:24]
  reg  rx_res_bits_104; // @[Sdc.scala 108:24]
  reg  rx_res_bits_105; // @[Sdc.scala 108:24]
  reg  rx_res_bits_106; // @[Sdc.scala 108:24]
  reg  rx_res_bits_107; // @[Sdc.scala 108:24]
  reg  rx_res_bits_108; // @[Sdc.scala 108:24]
  reg  rx_res_bits_109; // @[Sdc.scala 108:24]
  reg  rx_res_bits_110; // @[Sdc.scala 108:24]
  reg  rx_res_bits_111; // @[Sdc.scala 108:24]
  reg  rx_res_bits_112; // @[Sdc.scala 108:24]
  reg  rx_res_bits_113; // @[Sdc.scala 108:24]
  reg  rx_res_bits_114; // @[Sdc.scala 108:24]
  reg  rx_res_bits_115; // @[Sdc.scala 108:24]
  reg  rx_res_bits_116; // @[Sdc.scala 108:24]
  reg  rx_res_bits_117; // @[Sdc.scala 108:24]
  reg  rx_res_bits_118; // @[Sdc.scala 108:24]
  reg  rx_res_bits_119; // @[Sdc.scala 108:24]
  reg  rx_res_bits_120; // @[Sdc.scala 108:24]
  reg  rx_res_bits_121; // @[Sdc.scala 108:24]
  reg  rx_res_bits_122; // @[Sdc.scala 108:24]
  reg  rx_res_bits_123; // @[Sdc.scala 108:24]
  reg  rx_res_bits_124; // @[Sdc.scala 108:24]
  reg  rx_res_bits_125; // @[Sdc.scala 108:24]
  reg  rx_res_bits_126; // @[Sdc.scala 108:24]
  reg  rx_res_bits_127; // @[Sdc.scala 108:24]
  reg  rx_res_bits_128; // @[Sdc.scala 108:24]
  reg  rx_res_bits_129; // @[Sdc.scala 108:24]
  reg  rx_res_bits_130; // @[Sdc.scala 108:24]
  reg  rx_res_bits_131; // @[Sdc.scala 108:24]
  reg  rx_res_bits_132; // @[Sdc.scala 108:24]
  reg  rx_res_bits_133; // @[Sdc.scala 108:24]
  reg  rx_res_bits_134; // @[Sdc.scala 108:24]
  reg  rx_res_bits_135; // @[Sdc.scala 108:24]
  reg  rx_res_next; // @[Sdc.scala 109:28]
  reg [3:0] rx_res_type; // @[Sdc.scala 110:28]
  reg [135:0] rx_res; // @[Sdc.scala 111:23]
  reg  rx_res_ready; // @[Sdc.scala 112:29]
  reg  rx_res_intr_en; // @[Sdc.scala 113:31]
  reg  rx_res_crc_0; // @[Sdc.scala 114:23]
  reg  rx_res_crc_1; // @[Sdc.scala 114:23]
  reg  rx_res_crc_2; // @[Sdc.scala 114:23]
  reg  rx_res_crc_3; // @[Sdc.scala 114:23]
  reg  rx_res_crc_4; // @[Sdc.scala 114:23]
  reg  rx_res_crc_5; // @[Sdc.scala 114:23]
  reg  rx_res_crc_6; // @[Sdc.scala 114:23]
  reg  rx_res_crc_error; // @[Sdc.scala 115:33]
  reg  rx_res_crc_en; // @[Sdc.scala 116:30]
  reg [7:0] rx_res_timer; // @[Sdc.scala 117:29]
  reg  rx_res_timeout; // @[Sdc.scala 118:31]
  reg [1:0] rx_res_read_counter; // @[Sdc.scala 119:36]
  reg [31:0] tx_cmd_arg; // @[Sdc.scala 120:27]
  reg  tx_cmd_0; // @[Sdc.scala 121:19]
  reg  tx_cmd_1; // @[Sdc.scala 121:19]
  reg  tx_cmd_2; // @[Sdc.scala 121:19]
  reg  tx_cmd_3; // @[Sdc.scala 121:19]
  reg  tx_cmd_4; // @[Sdc.scala 121:19]
  reg  tx_cmd_5; // @[Sdc.scala 121:19]
  reg  tx_cmd_6; // @[Sdc.scala 121:19]
  reg  tx_cmd_7; // @[Sdc.scala 121:19]
  reg  tx_cmd_8; // @[Sdc.scala 121:19]
  reg  tx_cmd_9; // @[Sdc.scala 121:19]
  reg  tx_cmd_10; // @[Sdc.scala 121:19]
  reg  tx_cmd_11; // @[Sdc.scala 121:19]
  reg  tx_cmd_12; // @[Sdc.scala 121:19]
  reg  tx_cmd_13; // @[Sdc.scala 121:19]
  reg  tx_cmd_14; // @[Sdc.scala 121:19]
  reg  tx_cmd_15; // @[Sdc.scala 121:19]
  reg  tx_cmd_16; // @[Sdc.scala 121:19]
  reg  tx_cmd_17; // @[Sdc.scala 121:19]
  reg  tx_cmd_18; // @[Sdc.scala 121:19]
  reg  tx_cmd_19; // @[Sdc.scala 121:19]
  reg  tx_cmd_20; // @[Sdc.scala 121:19]
  reg  tx_cmd_21; // @[Sdc.scala 121:19]
  reg  tx_cmd_22; // @[Sdc.scala 121:19]
  reg  tx_cmd_23; // @[Sdc.scala 121:19]
  reg  tx_cmd_24; // @[Sdc.scala 121:19]
  reg  tx_cmd_25; // @[Sdc.scala 121:19]
  reg  tx_cmd_26; // @[Sdc.scala 121:19]
  reg  tx_cmd_27; // @[Sdc.scala 121:19]
  reg  tx_cmd_28; // @[Sdc.scala 121:19]
  reg  tx_cmd_29; // @[Sdc.scala 121:19]
  reg  tx_cmd_30; // @[Sdc.scala 121:19]
  reg  tx_cmd_31; // @[Sdc.scala 121:19]
  reg  tx_cmd_32; // @[Sdc.scala 121:19]
  reg  tx_cmd_33; // @[Sdc.scala 121:19]
  reg  tx_cmd_34; // @[Sdc.scala 121:19]
  reg  tx_cmd_35; // @[Sdc.scala 121:19]
  reg  tx_cmd_36; // @[Sdc.scala 121:19]
  reg  tx_cmd_37; // @[Sdc.scala 121:19]
  reg  tx_cmd_38; // @[Sdc.scala 121:19]
  reg  tx_cmd_39; // @[Sdc.scala 121:19]
  reg  tx_cmd_40; // @[Sdc.scala 121:19]
  reg  tx_cmd_41; // @[Sdc.scala 121:19]
  reg  tx_cmd_42; // @[Sdc.scala 121:19]
  reg  tx_cmd_43; // @[Sdc.scala 121:19]
  reg  tx_cmd_44; // @[Sdc.scala 121:19]
  reg  tx_cmd_45; // @[Sdc.scala 121:19]
  reg  tx_cmd_46; // @[Sdc.scala 121:19]
  reg  tx_cmd_47; // @[Sdc.scala 121:19]
  reg [5:0] tx_cmd_counter; // @[Sdc.scala 122:31]
  reg  tx_cmd_crc_0; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_1; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_2; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_3; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_4; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_5; // @[Sdc.scala 123:23]
  reg  tx_cmd_crc_6; // @[Sdc.scala 123:23]
  reg [5:0] tx_cmd_timer; // @[Sdc.scala 124:29]
  reg  reg_tx_cmd_wrt; // @[Sdc.scala 125:31]
  reg  reg_tx_cmd_out; // @[Sdc.scala 126:31]
  reg  rx_dat_in_progress; // @[Sdc.scala 127:35]
  reg [10:0] rx_dat_counter; // @[Sdc.scala 128:31]
  reg  rx_dat_start_bit; // @[Sdc.scala 129:33]
  reg [3:0] rx_dat_bits_0; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_1; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_2; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_3; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_4; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_5; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_6; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_bits_7; // @[Sdc.scala 130:24]
  reg [3:0] rx_dat_next; // @[Sdc.scala 131:28]
  reg  rx_dat_continuous; // @[Sdc.scala 132:34]
  reg  rx_dat_ready; // @[Sdc.scala 133:29]
  reg  rx_dat_intr_en; // @[Sdc.scala 134:31]
  reg [3:0] rx_dat_crc_0; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_1; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_2; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_3; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_4; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_5; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_6; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_7; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_8; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_9; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_10; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_11; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_12; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_13; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_14; // @[Sdc.scala 135:23]
  reg [3:0] rx_dat_crc_15; // @[Sdc.scala 135:23]
  reg  rx_dat_crc_error; // @[Sdc.scala 136:33]
  reg [18:0] rx_dat_timer; // @[Sdc.scala 137:29]
  reg  rx_dat_timeout; // @[Sdc.scala 138:31]
  reg  rx_dat_overrun; // @[Sdc.scala 139:31]
  reg [7:0] rxtx_dat_counter; // @[Sdc.scala 141:33]
  reg [7:0] rxtx_dat_index; // @[Sdc.scala 142:31]
  reg [18:0] rx_busy_timer; // @[Sdc.scala 143:30]
  reg  rx_busy_in_progress; // @[Sdc.scala 144:36]
  reg  rx_dat0_next; // @[Sdc.scala 145:29]
  reg  rx_dat_buf_read; // @[Sdc.scala 146:32]
  reg [31:0] rx_dat_buf_cache; // @[Sdc.scala 147:33]
  reg  reg_tx_dat_wrt; // @[Sdc.scala 148:31]
  reg  reg_tx_dat_out; // @[Sdc.scala 149:31]
  reg  tx_empty_intr_en; // @[Sdc.scala 150:33]
  reg  tx_end_intr_en; // @[Sdc.scala 151:31]
  reg [10:0] tx_dat_counter; // @[Sdc.scala 152:31]
  reg [5:0] tx_dat_timer; // @[Sdc.scala 153:29]
  reg [3:0] tx_dat_0; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_1; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_2; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_3; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_4; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_5; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_6; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_7; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_8; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_9; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_10; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_11; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_12; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_13; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_14; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_15; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_16; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_17; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_18; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_19; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_20; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_21; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_22; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_23; // @[Sdc.scala 154:19]
  reg [3:0] tx_dat_crc_0; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_1; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_2; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_3; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_4; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_5; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_6; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_7; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_8; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_9; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_10; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_11; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_12; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_13; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_14; // @[Sdc.scala 155:23]
  reg [3:0] tx_dat_crc_15; // @[Sdc.scala 155:23]
  reg [31:0] tx_dat_prepared; // @[Sdc.scala 156:32]
  reg [1:0] tx_dat_prepare_state; // @[Sdc.scala 157:37]
  reg  tx_dat_started; // @[Sdc.scala 158:31]
  reg  tx_dat_in_progress; // @[Sdc.scala 160:35]
  reg  tx_dat_end; // @[Sdc.scala 161:27]
  reg [1:0] tx_dat_read_sel; // @[Sdc.scala 162:32]
  reg [1:0] tx_dat_write_sel; // @[Sdc.scala 163:33]
  reg  tx_dat_read_sel_changed; // @[Sdc.scala 164:40]
  reg  tx_dat_write_sel_new; // @[Sdc.scala 165:37]
  reg [3:0] tx_dat_crc_status_counter; // @[Sdc.scala 166:42]
  reg  tx_dat_crc_status_b_0; // @[Sdc.scala 167:32]
  reg  tx_dat_crc_status_b_1; // @[Sdc.scala 167:32]
  reg  tx_dat_crc_status_b_2; // @[Sdc.scala 167:32]
  reg [1:0] tx_dat_crc_status; // @[Sdc.scala 168:34]
  reg  tx_dat_prepared_read; // @[Sdc.scala 169:37]
  wire  _T_2 = tx_cmd_counter == 6'h0; // @[Sdc.scala 171:48]
  wire  _T_5 = _T & reg_clk; // @[Sdc.scala 173:35]
  wire [7:0] _rx_res_timer_T_1 = rx_res_timer - 8'h1; // @[Sdc.scala 175:38]
  wire [7:0] _GEN_4 = rx_res_timer == 8'h1 ? 8'h0 : rx_res_counter; // @[Sdc.scala 176:37 177:26 107:31]
  wire [135:0] _GEN_5 = rx_res_timer == 8'h1 ? 136'h0 : rx_res; // @[Sdc.scala 176:37 178:18 111:23]
  wire  _GEN_6 = rx_res_timer == 8'h1 | rx_res_ready; // @[Sdc.scala 176:37 179:24 112:29]
  wire  _GEN_7 = rx_res_timer == 8'h1 | rx_res_timeout; // @[Sdc.scala 176:37 180:26 118:31]
  wire [7:0] _GEN_8 = ~rx_res_in_progress & rx_res_next ? _rx_res_timer_T_1 : rx_res_timer; // @[Sdc.scala 174:49 175:22 117:29]
  wire [7:0] _GEN_9 = ~rx_res_in_progress & rx_res_next ? _GEN_4 : rx_res_counter; // @[Sdc.scala 107:31 174:49]
  wire [135:0] _GEN_10 = ~rx_res_in_progress & rx_res_next ? _GEN_5 : rx_res; // @[Sdc.scala 111:23 174:49]
  wire  _GEN_11 = ~rx_res_in_progress & rx_res_next ? _GEN_6 : rx_res_ready; // @[Sdc.scala 112:29 174:49]
  wire  _GEN_12 = ~rx_res_in_progress & rx_res_next ? _GEN_7 : rx_res_timeout; // @[Sdc.scala 118:31 174:49]
  wire [7:0] _rx_res_counter_T_1 = rx_res_counter - 8'h1; // @[Sdc.scala 186:42]
  wire [7:0] rx_res_lo_lo_lo_lo = {rx_res_bits_7,rx_res_bits_6,rx_res_bits_5,rx_res_bits_4,rx_res_bits_3,rx_res_bits_2,
    rx_res_bits_1,rx_res_bits_0}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_lo_lo_lo = {rx_res_bits_16,rx_res_bits_15,rx_res_bits_14,rx_res_bits_13,rx_res_bits_12,
    rx_res_bits_11,rx_res_bits_10,rx_res_bits_9,rx_res_bits_8,rx_res_lo_lo_lo_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_lo_lo_hi_lo = {rx_res_bits_24,rx_res_bits_23,rx_res_bits_22,rx_res_bits_21,rx_res_bits_20,
    rx_res_bits_19,rx_res_bits_18,rx_res_bits_17}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_lo_lo_hi = {rx_res_bits_33,rx_res_bits_32,rx_res_bits_31,rx_res_bits_30,rx_res_bits_29,
    rx_res_bits_28,rx_res_bits_27,rx_res_bits_26,rx_res_bits_25,rx_res_lo_lo_hi_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_lo_hi_lo_lo = {rx_res_bits_41,rx_res_bits_40,rx_res_bits_39,rx_res_bits_38,rx_res_bits_37,
    rx_res_bits_36,rx_res_bits_35,rx_res_bits_34}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_lo_hi_lo = {rx_res_bits_50,rx_res_bits_49,rx_res_bits_48,rx_res_bits_47,rx_res_bits_46,
    rx_res_bits_45,rx_res_bits_44,rx_res_bits_43,rx_res_bits_42,rx_res_lo_hi_lo_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_lo_hi_hi_lo = {rx_res_bits_58,rx_res_bits_57,rx_res_bits_56,rx_res_bits_55,rx_res_bits_54,
    rx_res_bits_53,rx_res_bits_52,rx_res_bits_51}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_lo_hi_hi = {rx_res_bits_67,rx_res_bits_66,rx_res_bits_65,rx_res_bits_64,rx_res_bits_63,
    rx_res_bits_62,rx_res_bits_61,rx_res_bits_60,rx_res_bits_59,rx_res_lo_hi_hi_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_hi_lo_lo_lo = {rx_res_bits_75,rx_res_bits_74,rx_res_bits_73,rx_res_bits_72,rx_res_bits_71,
    rx_res_bits_70,rx_res_bits_69,rx_res_bits_68}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_hi_lo_lo = {rx_res_bits_84,rx_res_bits_83,rx_res_bits_82,rx_res_bits_81,rx_res_bits_80,
    rx_res_bits_79,rx_res_bits_78,rx_res_bits_77,rx_res_bits_76,rx_res_hi_lo_lo_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_hi_lo_hi_lo = {rx_res_bits_92,rx_res_bits_91,rx_res_bits_90,rx_res_bits_89,rx_res_bits_88,
    rx_res_bits_87,rx_res_bits_86,rx_res_bits_85}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_hi_lo_hi = {rx_res_bits_101,rx_res_bits_100,rx_res_bits_99,rx_res_bits_98,rx_res_bits_97,
    rx_res_bits_96,rx_res_bits_95,rx_res_bits_94,rx_res_bits_93,rx_res_hi_lo_hi_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_hi_hi_lo_lo = {rx_res_bits_109,rx_res_bits_108,rx_res_bits_107,rx_res_bits_106,rx_res_bits_105,
    rx_res_bits_104,rx_res_bits_103,rx_res_bits_102}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_hi_hi_lo = {rx_res_bits_118,rx_res_bits_117,rx_res_bits_116,rx_res_bits_115,rx_res_bits_114,
    rx_res_bits_113,rx_res_bits_112,rx_res_bits_111,rx_res_bits_110,rx_res_hi_hi_lo_lo}; // @[Cat.scala 31:58]
  wire [7:0] rx_res_hi_hi_hi_lo = {rx_res_bits_126,rx_res_bits_125,rx_res_bits_124,rx_res_bits_123,rx_res_bits_122,
    rx_res_bits_121,rx_res_bits_120,rx_res_bits_119}; // @[Cat.scala 31:58]
  wire [16:0] rx_res_hi_hi_hi = {rx_res_bits_135,rx_res_bits_134,rx_res_bits_133,rx_res_bits_132,rx_res_bits_131,
    rx_res_bits_130,rx_res_bits_129,rx_res_bits_128,rx_res_bits_127,rx_res_hi_hi_hi_lo}; // @[Cat.scala 31:58]
  wire [136:0] _rx_res_T_1 = {rx_res_hi_hi_hi,rx_res_hi_hi_lo,rx_res_hi_lo_hi,rx_res_hi_lo_lo,rx_res_lo_hi_hi,
    rx_res_lo_hi_lo,rx_res_lo_lo_hi,rx_res_lo_lo_lo,rx_res_next}; // @[Cat.scala 31:58]
  wire [6:0] _rx_res_crc_error_T = {rx_res_crc_0,rx_res_crc_1,rx_res_crc_2,rx_res_crc_3,rx_res_crc_4,rx_res_crc_5,
    rx_res_crc_6}; // @[Cat.scala 31:58]
  wire [18:0] _GEN_13 = rx_res_type == 4'h5 ? 19'h7a120 : rx_busy_timer; // @[Sdc.scala 203:47 204:27 143:30]
  wire  _GEN_14 = rx_res_counter == 8'h1 ? 1'h0 : 1'h1; // @[Sdc.scala 187:28 197:39 199:30]
  wire [136:0] _GEN_15 = rx_res_counter == 8'h1 ? _rx_res_T_1 : {{1'd0}, _GEN_10}; // @[Sdc.scala 197:39 200:18]
  wire  _GEN_16 = rx_res_counter == 8'h1 | _GEN_11; // @[Sdc.scala 197:39 201:24]
  wire  _GEN_17 = rx_res_counter == 8'h1 ? rx_res_crc_en & _rx_res_crc_error_T != 7'h0 : rx_res_crc_error; // @[Sdc.scala 197:39 202:28 115:33]
  wire [18:0] _GEN_18 = rx_res_counter == 8'h1 ? _GEN_13 : rx_busy_timer; // @[Sdc.scala 143:30 197:39]
  wire [5:0] _GEN_19 = rx_res_counter == 8'h1 ? 6'h30 : tx_cmd_timer; // @[Sdc.scala 197:39 206:24 124:29]
  wire [7:0] _GEN_156 = rx_res_in_progress | ~rx_res_next ? _rx_res_counter_T_1 : _GEN_9; // @[Sdc.scala 183:49 186:24]
  wire  _GEN_157 = rx_res_in_progress | ~rx_res_next ? _GEN_14 : rx_res_in_progress; // @[Sdc.scala 106:35 183:49]
  wire  _GEN_158 = rx_res_in_progress | ~rx_res_next ? rx_res_next ^ rx_res_crc_6 : rx_res_crc_0; // @[Sdc.scala 114:23 183:49 189:23]
  wire  _GEN_159 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_0 : rx_res_crc_1; // @[Sdc.scala 114:23 183:49 190:23]
  wire  _GEN_160 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_1 : rx_res_crc_2; // @[Sdc.scala 114:23 183:49 191:23]
  wire  _GEN_161 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_2 ^ rx_res_crc_6 : rx_res_crc_3; // @[Sdc.scala 114:23 183:49 192:23]
  wire  _GEN_162 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_3 : rx_res_crc_4; // @[Sdc.scala 114:23 183:49 193:23]
  wire  _GEN_163 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_4 : rx_res_crc_5; // @[Sdc.scala 114:23 183:49 194:23]
  wire  _GEN_164 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_5 : rx_res_crc_6; // @[Sdc.scala 114:23 183:49 195:23]
  wire [136:0] _GEN_165 = rx_res_in_progress | ~rx_res_next ? _GEN_15 : {{1'd0}, _GEN_10}; // @[Sdc.scala 183:49]
  wire  _GEN_166 = rx_res_in_progress | ~rx_res_next ? _GEN_16 : _GEN_11; // @[Sdc.scala 183:49]
  wire  _GEN_167 = rx_res_in_progress | ~rx_res_next ? _GEN_17 : rx_res_crc_error; // @[Sdc.scala 115:33 183:49]
  wire [18:0] _GEN_168 = rx_res_in_progress | ~rx_res_next ? _GEN_18 : rx_busy_timer; // @[Sdc.scala 143:30 183:49]
  wire [5:0] _GEN_169 = rx_res_in_progress | ~rx_res_next ? _GEN_19 : tx_cmd_timer; // @[Sdc.scala 124:29 183:49]
  wire [7:0] _GEN_170 = _T & reg_clk ? _GEN_8 : rx_res_timer; // @[Sdc.scala 117:29 173:47]
  wire [7:0] _GEN_171 = _T & reg_clk ? _GEN_156 : rx_res_counter; // @[Sdc.scala 107:31 173:47]
  wire [136:0] _GEN_172 = _T & reg_clk ? _GEN_165 : {{1'd0}, rx_res}; // @[Sdc.scala 111:23 173:47]
  wire  _GEN_173 = _T & reg_clk ? _GEN_166 : rx_res_ready; // @[Sdc.scala 112:29 173:47]
  wire  _GEN_174 = _T & reg_clk ? _GEN_12 : rx_res_timeout; // @[Sdc.scala 118:31 173:47]
  wire  _GEN_311 = _T & reg_clk ? _GEN_157 : rx_res_in_progress; // @[Sdc.scala 106:35 173:47]
  wire  _GEN_312 = _T & reg_clk ? _GEN_158 : rx_res_crc_0; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_313 = _T & reg_clk ? _GEN_159 : rx_res_crc_1; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_314 = _T & reg_clk ? _GEN_160 : rx_res_crc_2; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_315 = _T & reg_clk ? _GEN_161 : rx_res_crc_3; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_316 = _T & reg_clk ? _GEN_162 : rx_res_crc_4; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_317 = _T & reg_clk ? _GEN_163 : rx_res_crc_5; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_318 = _T & reg_clk ? _GEN_164 : rx_res_crc_6; // @[Sdc.scala 114:23 173:47]
  wire  _GEN_319 = _T & reg_clk ? _GEN_167 : rx_res_crc_error; // @[Sdc.scala 115:33 173:47]
  wire [18:0] _GEN_320 = _T & reg_clk ? _GEN_168 : rx_busy_timer; // @[Sdc.scala 143:30 173:47]
  wire [7:0] _GEN_323 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_170 : rx_res_timer; // @[Sdc.scala 117:29 171:57]
  wire [7:0] _GEN_324 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_171 : rx_res_counter; // @[Sdc.scala 107:31 171:57]
  wire [136:0] _GEN_325 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_172 : {{1'd0}, rx_res}; // @[Sdc.scala 111:23 171:57]
  wire  _GEN_326 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_173 : rx_res_ready; // @[Sdc.scala 112:29 171:57]
  wire  _GEN_327 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_174 : rx_res_timeout; // @[Sdc.scala 118:31 171:57]
  wire  _GEN_464 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_311 : rx_res_in_progress; // @[Sdc.scala 106:35 171:57]
  wire  _GEN_465 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_312 : rx_res_crc_0; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_466 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_313 : rx_res_crc_1; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_467 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_314 : rx_res_crc_2; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_468 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_315 : rx_res_crc_3; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_469 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_316 : rx_res_crc_4; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_470 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_317 : rx_res_crc_5; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_471 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_318 : rx_res_crc_6; // @[Sdc.scala 114:23 171:57]
  wire  _GEN_472 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_319 : rx_res_crc_error; // @[Sdc.scala 115:33 171:57]
  wire [18:0] _GEN_473 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_320 : rx_busy_timer; // @[Sdc.scala 143:30 171:57]
  wire [5:0] _tx_cmd_timer_T_1 = tx_cmd_timer - 6'h1; // @[Sdc.scala 216:34]
  wire  _T_20 = rx_busy_timer != 19'h0 & _T & reg_clk; // @[Sdc.scala 219:64]
  wire [5:0] _tx_cmd_counter_T_1 = tx_cmd_counter - 6'h1; // @[Sdc.scala 226:38]
  wire  crc__0 = tx_cmd_7 ^ tx_cmd_crc_6; // @[Sdc.scala 229:17]
  wire  crc__3 = tx_cmd_crc_2 ^ tx_cmd_crc_6; // @[Sdc.scala 232:21]
  wire  _GEN_475 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_5 : tx_cmd_1; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_476 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_4 : tx_cmd_2; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_477 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_3 : tx_cmd_3; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_478 = tx_cmd_counter == 6'h9 ? crc__3 : tx_cmd_4; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_479 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_1 : tx_cmd_5; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_480 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_0 : tx_cmd_6; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_481 = tx_cmd_counter == 6'h9 ? crc__0 : tx_cmd_7; // @[Sdc.scala 240:35 241:39 225:48]
  wire  _GEN_482 = _T_2 & _T & reg_clk ? 1'h0 : reg_tx_cmd_wrt; // @[Sdc.scala 244:77 245:20 125:31]
  wire  _GEN_484 = tx_cmd_counter > 6'h0 & _T & reg_clk | _GEN_482; // @[Sdc.scala 222:75 223:20]
  wire  _GEN_486 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_475 : tx_cmd_0; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_487 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_476 : tx_cmd_1; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_488 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_477 : tx_cmd_2; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_489 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_478 : tx_cmd_3; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_490 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_479 : tx_cmd_4; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_491 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_480 : tx_cmd_5; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_492 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_481 : tx_cmd_6; // @[Sdc.scala 121:19 222:75]
  wire  _GEN_493 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_8 : tx_cmd_7; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_494 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_9 : tx_cmd_8; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_495 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_10 : tx_cmd_9; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_496 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_11 : tx_cmd_10; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_497 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_12 : tx_cmd_11; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_498 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_13 : tx_cmd_12; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_499 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_14 : tx_cmd_13; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_500 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_15 : tx_cmd_14; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_501 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_16 : tx_cmd_15; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_502 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_17 : tx_cmd_16; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_503 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_18 : tx_cmd_17; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_504 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_19 : tx_cmd_18; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_505 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_20 : tx_cmd_19; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_506 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_21 : tx_cmd_20; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_507 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_22 : tx_cmd_21; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_508 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_23 : tx_cmd_22; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_509 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_24 : tx_cmd_23; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_510 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_25 : tx_cmd_24; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_511 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_26 : tx_cmd_25; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_512 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_27 : tx_cmd_26; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_513 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_28 : tx_cmd_27; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_514 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_29 : tx_cmd_28; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_515 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_30 : tx_cmd_29; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_516 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_31 : tx_cmd_30; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_517 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_32 : tx_cmd_31; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_518 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_33 : tx_cmd_32; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_519 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_34 : tx_cmd_33; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_520 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_35 : tx_cmd_34; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_521 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_36 : tx_cmd_35; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_522 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_37 : tx_cmd_36; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_523 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_38 : tx_cmd_37; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_524 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_39 : tx_cmd_38; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_525 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_40 : tx_cmd_39; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_526 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_41 : tx_cmd_40; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_527 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_42 : tx_cmd_41; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_528 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_43 : tx_cmd_42; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_529 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_44 : tx_cmd_43; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_530 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_45 : tx_cmd_44; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_531 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_46 : tx_cmd_45; // @[Sdc.scala 121:19 222:75 225:48]
  wire  _GEN_532 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_47 : tx_cmd_46; // @[Sdc.scala 121:19 222:75 225:48]
  wire [5:0] _GEN_533 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _tx_cmd_counter_T_1 : tx_cmd_counter; // @[Sdc.scala 222:75 226:20 122:31]
  wire  _GEN_534 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__0 : tx_cmd_crc_0; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_535 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : tx_cmd_crc_1; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_536 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : tx_cmd_crc_2; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_537 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__3 : tx_cmd_crc_3; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_538 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : tx_cmd_crc_4; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_539 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : tx_cmd_crc_5; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_540 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : tx_cmd_crc_6; // @[Sdc.scala 222:75 237:16 123:23]
  wire  _GEN_543 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_486; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_544 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_487; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_545 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_488; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_546 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_489; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_547 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_490; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_548 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_491; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_549 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_492; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_550 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_493; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_551 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_494; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_552 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_495; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_553 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_496; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_554 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_497; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_555 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_498; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_556 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_499; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_557 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_500; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_558 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_501; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_559 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_502; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_560 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_503; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_561 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_504; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_562 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_505; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_563 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_506; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_564 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_507; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_565 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_508; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_566 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_509; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_567 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_510; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_568 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_511; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_569 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_512; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_570 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_513; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_571 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_514; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_572 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_515; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_573 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_516; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_574 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_517; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_575 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_518; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_576 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_519; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_577 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_520; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_578 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_521; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_579 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_522; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_580 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_523; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_581 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_524; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_582 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_525; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_583 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_526; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_584 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_527; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_585 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_528; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_586 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_529; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_587 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_530; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_588 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_531; // @[Sdc.scala 121:19 219:76]
  wire  _GEN_589 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_532; // @[Sdc.scala 121:19 219:76]
  wire [5:0] _GEN_590 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_533; // @[Sdc.scala 122:31 219:76]
  wire  _GEN_591 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_534; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_592 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_535; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_593 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_536; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_594 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_537; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_595 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_538; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_596 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_539; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_597 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_540; // @[Sdc.scala 123:23 219:76]
  wire  _GEN_601 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_543; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_602 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_544; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_603 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_545; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_604 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_546; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_605 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_547; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_606 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_548; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_607 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_549; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_608 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_550; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_609 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_551; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_610 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_552; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_611 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_553; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_612 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_554; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_613 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_555; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_614 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_556; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_615 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_557; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_616 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_558; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_617 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_559; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_618 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_560; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_619 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_561; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_620 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_562; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_621 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_563; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_622 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_564; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_623 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_565; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_624 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_566; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_625 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_567; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_626 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_568; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_627 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_569; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_628 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_570; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_629 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_571; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_630 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_572; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_631 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_573; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_632 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_574; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_633 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_575; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_634 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_576; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_635 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_577; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_636 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_578; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_637 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_579; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_638 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_580; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_639 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_581; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_640 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_582; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_641 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_583; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_642 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_584; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_643 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_585; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_644 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_586; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_645 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_587; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_646 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_588; // @[Sdc.scala 121:19 215:69]
  wire  _GEN_647 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_589; // @[Sdc.scala 121:19 215:69]
  wire [5:0] _GEN_648 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_590; // @[Sdc.scala 122:31 215:69]
  wire  _GEN_649 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_591; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_650 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_592; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_651 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_593; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_652 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_594; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_653 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_595; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_654 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_596; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_655 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_597; // @[Sdc.scala 123:23 215:69]
  wire  _GEN_657 = rx_dat_buf_read ? 1'h0 : rx_dat_buf_read; // @[Sdc.scala 261:26 263:21 146:32]
  wire [31:0] _GEN_658 = tx_dat_prepared_read ? io_sdbuf_rdata1 : tx_dat_prepared; // @[Sdc.scala 265:31 266:21 156:32]
  wire  _GEN_659 = tx_dat_prepared_read ? 1'h0 : tx_dat_prepared_read; // @[Sdc.scala 265:31 267:26 169:37]
  wire  _T_35 = ~rx_dat_in_progress; // @[Sdc.scala 273:13]
  wire [18:0] _rx_dat_timer_T_1 = rx_dat_timer - 19'h1; // @[Sdc.scala 274:38]
  wire  _T_39 = rx_dat_timer == 19'h1; // @[Sdc.scala 275:28]
  wire [7:0] _rxtx_dat_counter_T_1 = rxtx_dat_counter + 8'h1; // @[Sdc.scala 281:48]
  wire [10:0] _GEN_660 = rx_dat_timer == 19'h1 ? 11'h0 : rx_dat_counter; // @[Sdc.scala 275:37 276:26 128:31]
  wire  _GEN_661 = rx_dat_timer == 19'h1 | rx_dat_ready; // @[Sdc.scala 275:37 277:24 133:29]
  wire  _GEN_662 = rx_dat_timer == 19'h1 | rx_dat_timeout; // @[Sdc.scala 275:37 278:26 138:31]
  wire  _GEN_664 = rx_dat_timer == 19'h1 | _GEN_657; // @[Sdc.scala 275:37 280:27]
  wire [7:0] _GEN_665 = rx_dat_timer == 19'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[Sdc.scala 275:37 281:28 141:33]
  wire [10:0] _rx_dat_counter_T_1 = rx_dat_counter - 11'h1; // @[Sdc.scala 288:42]
  wire [3:0] _rx_dat_crc_0_T = rx_dat_next ^ rx_dat_crc_15; // @[Sdc.scala 290:38]
  wire [3:0] _rx_dat_crc_5_T = rx_dat_crc_4 ^ rx_dat_crc_15; // @[Sdc.scala 295:40]
  wire [3:0] _rx_dat_crc_12_T = rx_dat_crc_11 ^ rx_dat_crc_15; // @[Sdc.scala 302:42]
  wire  _T_50 = ~rx_dat_start_bit; // @[Sdc.scala 308:17]
  wire [7:0] _rxtx_dat_index_T_1 = rxtx_dat_index + 8'h1; // @[Sdc.scala 309:46]
  wire [15:0] io_sdbuf_wdata1_lo = {rx_dat_bits_5,rx_dat_bits_4,rx_dat_bits_7,rx_dat_bits_6}; // @[Cat.scala 31:58]
  wire [15:0] io_sdbuf_wdata1_hi = {rx_dat_bits_1,rx_dat_bits_0,rx_dat_bits_3,rx_dat_bits_2}; // @[Cat.scala 31:58]
  wire [7:0] _GEN_666 = ~rx_dat_start_bit ? _rxtx_dat_index_T_1 : rxtx_dat_index; // @[Sdc.scala 308:36 309:28 142:31]
  wire  _GEN_669 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? 1'h0 : rx_dat_start_bit; // @[Sdc.scala 306:78 307:28 129:33]
  wire [7:0] _GEN_670 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? _GEN_666 : rxtx_dat_index; // @[Sdc.scala 142:31 306:78]
  wire  _GEN_671 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 & _T_50; // @[Sdc.scala 253:17 306:78]
  wire  _T_51 = rx_dat_counter == 11'h1; // @[Sdc.scala 325:30]
  wire [31:0] crc_error_lo = {rx_dat_crc_8,rx_dat_crc_9,rx_dat_crc_10,rx_dat_crc_11,rx_dat_crc_12,rx_dat_crc_13,
    rx_dat_crc_14,rx_dat_crc_15}; // @[Cat.scala 31:58]
  wire [63:0] _crc_error_T = {rx_dat_crc_0,rx_dat_crc_1,rx_dat_crc_2,rx_dat_crc_3,rx_dat_crc_4,rx_dat_crc_5,rx_dat_crc_6
    ,rx_dat_crc_7,crc_error_lo}; // @[Cat.scala 31:58]
  wire  crc_error = _crc_error_T != 64'h0; // @[Sdc.scala 331:43]
  wire [10:0] _GEN_673 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 11'h411 : _rx_dat_counter_T_1; // @[Sdc.scala 288:24 335:62 336:28]
  wire [18:0] _GEN_674 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 19'h7a120 : rx_dat_timer; // @[Sdc.scala 335:62 337:26 137:29]
  wire  _GEN_675 = rx_dat_continuous & ~crc_error & ~rx_dat_ready | _GEN_669; // @[Sdc.scala 335:62 338:30]
  wire [3:0] _GEN_676 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_0_T; // @[Sdc.scala 290:23 335:62 339:24]
  wire [3:0] _GEN_677 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_0; // @[Sdc.scala 291:23 335:62 339:24]
  wire [3:0] _GEN_678 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_1; // @[Sdc.scala 292:23 335:62 339:24]
  wire [3:0] _GEN_679 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_2; // @[Sdc.scala 293:23 335:62 339:24]
  wire [3:0] _GEN_680 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_3; // @[Sdc.scala 294:23 335:62 339:24]
  wire [3:0] _GEN_681 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_5_T; // @[Sdc.scala 295:23 335:62 339:24]
  wire [3:0] _GEN_682 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_5; // @[Sdc.scala 296:23 335:62 339:24]
  wire [3:0] _GEN_683 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_6; // @[Sdc.scala 297:23 335:62 339:24]
  wire [3:0] _GEN_684 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_7; // @[Sdc.scala 298:23 335:62 339:24]
  wire [3:0] _GEN_685 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_8; // @[Sdc.scala 299:23 335:62 339:24]
  wire [3:0] _GEN_686 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_9; // @[Sdc.scala 300:24 335:62 339:24]
  wire [3:0] _GEN_687 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_10; // @[Sdc.scala 301:24 335:62 339:24]
  wire [3:0] _GEN_688 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_12_T; // @[Sdc.scala 302:24 335:62 339:24]
  wire [3:0] _GEN_689 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_12; // @[Sdc.scala 303:24 335:62 339:24]
  wire [3:0] _GEN_690 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_13; // @[Sdc.scala 304:24 335:62 339:24]
  wire [3:0] _GEN_691 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_14; // @[Sdc.scala 305:24 335:62 339:24]
  wire  _GEN_692 = rx_dat_counter == 11'h1 ? 1'h0 : rx_dat_in_progress; // @[Sdc.scala 325:39 326:30 127:35]
  wire  _GEN_693 = rx_dat_counter == 11'h1 | rx_dat_ready; // @[Sdc.scala 325:39 327:24 133:29]
  wire  _GEN_695 = rx_dat_counter == 11'h1 | _GEN_657; // @[Sdc.scala 325:39 329:27]
  wire [7:0] _GEN_696 = rx_dat_counter == 11'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[Sdc.scala 325:39 330:28 141:33]
  wire  _GEN_697 = rx_dat_counter == 11'h1 ? crc_error : rx_dat_crc_error; // @[Sdc.scala 325:39 332:28 136:33]
  wire  _GEN_698 = rx_dat_counter == 11'h1 ? rx_dat_ready : rx_dat_overrun; // @[Sdc.scala 325:39 334:26 139:31]
  wire [10:0] _GEN_699 = rx_dat_counter == 11'h1 ? _GEN_673 : _rx_dat_counter_T_1; // @[Sdc.scala 288:24 325:39]
  wire [18:0] _GEN_700 = rx_dat_counter == 11'h1 ? _GEN_674 : rx_dat_timer; // @[Sdc.scala 137:29 325:39]
  wire  _GEN_701 = rx_dat_counter == 11'h1 ? _GEN_675 : _GEN_669; // @[Sdc.scala 325:39]
  wire [3:0] _GEN_702 = rx_dat_counter == 11'h1 ? _GEN_676 : _rx_dat_crc_0_T; // @[Sdc.scala 290:23 325:39]
  wire [3:0] _GEN_703 = rx_dat_counter == 11'h1 ? _GEN_677 : rx_dat_crc_0; // @[Sdc.scala 291:23 325:39]
  wire [3:0] _GEN_704 = rx_dat_counter == 11'h1 ? _GEN_678 : rx_dat_crc_1; // @[Sdc.scala 292:23 325:39]
  wire [3:0] _GEN_705 = rx_dat_counter == 11'h1 ? _GEN_679 : rx_dat_crc_2; // @[Sdc.scala 293:23 325:39]
  wire [3:0] _GEN_706 = rx_dat_counter == 11'h1 ? _GEN_680 : rx_dat_crc_3; // @[Sdc.scala 294:23 325:39]
  wire [3:0] _GEN_707 = rx_dat_counter == 11'h1 ? _GEN_681 : _rx_dat_crc_5_T; // @[Sdc.scala 295:23 325:39]
  wire [3:0] _GEN_708 = rx_dat_counter == 11'h1 ? _GEN_682 : rx_dat_crc_5; // @[Sdc.scala 296:23 325:39]
  wire [3:0] _GEN_709 = rx_dat_counter == 11'h1 ? _GEN_683 : rx_dat_crc_6; // @[Sdc.scala 297:23 325:39]
  wire [3:0] _GEN_710 = rx_dat_counter == 11'h1 ? _GEN_684 : rx_dat_crc_7; // @[Sdc.scala 298:23 325:39]
  wire [3:0] _GEN_711 = rx_dat_counter == 11'h1 ? _GEN_685 : rx_dat_crc_8; // @[Sdc.scala 299:23 325:39]
  wire [3:0] _GEN_712 = rx_dat_counter == 11'h1 ? _GEN_686 : rx_dat_crc_9; // @[Sdc.scala 300:24 325:39]
  wire [3:0] _GEN_713 = rx_dat_counter == 11'h1 ? _GEN_687 : rx_dat_crc_10; // @[Sdc.scala 301:24 325:39]
  wire [3:0] _GEN_714 = rx_dat_counter == 11'h1 ? _GEN_688 : _rx_dat_crc_12_T; // @[Sdc.scala 302:24 325:39]
  wire [3:0] _GEN_715 = rx_dat_counter == 11'h1 ? _GEN_689 : rx_dat_crc_12; // @[Sdc.scala 303:24 325:39]
  wire [3:0] _GEN_716 = rx_dat_counter == 11'h1 ? _GEN_690 : rx_dat_crc_13; // @[Sdc.scala 304:24 325:39]
  wire [3:0] _GEN_717 = rx_dat_counter == 11'h1 ? _GEN_691 : rx_dat_crc_14; // @[Sdc.scala 305:24 325:39]
  wire  _GEN_718 = _T_35 & ~rx_dat_next[0] | _GEN_692; // @[Sdc.scala 283:66 284:28]
  wire [10:0] _GEN_727 = _T_35 & ~rx_dat_next[0] ? rx_dat_counter : _GEN_699; // @[Sdc.scala 128:31 283:66]
  wire [3:0] _GEN_728 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_0 : _GEN_702; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_729 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_1 : _GEN_703; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_730 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_2 : _GEN_704; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_731 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_3 : _GEN_705; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_732 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_4 : _GEN_706; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_733 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_5 : _GEN_707; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_734 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_6 : _GEN_708; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_735 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_7 : _GEN_709; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_736 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_8 : _GEN_710; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_737 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_9 : _GEN_711; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_738 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_10 : _GEN_712; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_739 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_11 : _GEN_713; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_740 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_12 : _GEN_714; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_741 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_13 : _GEN_715; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_742 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_14 : _GEN_716; // @[Sdc.scala 135:23 283:66]
  wire [3:0] _GEN_743 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_15 : _GEN_717; // @[Sdc.scala 135:23 283:66]
  wire  _GEN_744 = _T_35 & ~rx_dat_next[0] ? rx_dat_start_bit : _GEN_701; // @[Sdc.scala 129:33 283:66]
  wire [7:0] _GEN_745 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_index : _GEN_670; // @[Sdc.scala 142:31 283:66]
  wire  _GEN_746 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _GEN_671; // @[Sdc.scala 253:17 283:66]
  wire  _GEN_748 = _T_35 & ~rx_dat_next[0] ? rx_dat_ready : _GEN_693; // @[Sdc.scala 133:29 283:66]
  wire  _GEN_749 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _T_51; // @[Sdc.scala 256:17 283:66]
  wire  _GEN_750 = _T_35 & ~rx_dat_next[0] ? _GEN_657 : _GEN_695; // @[Sdc.scala 283:66]
  wire [7:0] _GEN_751 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_counter : _GEN_696; // @[Sdc.scala 141:33 283:66]
  wire  _GEN_752 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_error : _GEN_697; // @[Sdc.scala 136:33 283:66]
  wire  _GEN_753 = _T_35 & ~rx_dat_next[0] ? rx_dat_overrun : _GEN_698; // @[Sdc.scala 139:31 283:66]
  wire [18:0] _GEN_754 = _T_35 & ~rx_dat_next[0] ? rx_dat_timer : _GEN_700; // @[Sdc.scala 137:29 283:66]
  wire [18:0] _GEN_755 = ~rx_dat_in_progress & rx_dat_next[0] ? _rx_dat_timer_T_1 : _GEN_754; // @[Sdc.scala 273:59 274:22]
  wire [10:0] _GEN_756 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_660 : _GEN_727; // @[Sdc.scala 273:59]
  wire  _GEN_757 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_661 : _GEN_748; // @[Sdc.scala 273:59]
  wire  _GEN_758 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_662 : rx_dat_timeout; // @[Sdc.scala 138:31 273:59]
  wire  _GEN_759 = ~rx_dat_in_progress & rx_dat_next[0] ? _T_39 : _GEN_749; // @[Sdc.scala 273:59]
  wire  _GEN_760 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_664 : _GEN_750; // @[Sdc.scala 273:59]
  wire [7:0] _GEN_761 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_665 : _GEN_751; // @[Sdc.scala 273:59]
  wire  _GEN_762 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_in_progress : _GEN_718; // @[Sdc.scala 127:35 273:59]
  wire [3:0] _GEN_771 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_0 : _GEN_728; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_772 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_1 : _GEN_729; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_773 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_2 : _GEN_730; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_774 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_3 : _GEN_731; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_775 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_4 : _GEN_732; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_776 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_5 : _GEN_733; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_777 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_6 : _GEN_734; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_778 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_7 : _GEN_735; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_779 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_8 : _GEN_736; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_780 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_9 : _GEN_737; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_781 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_10 : _GEN_738; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_782 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_11 : _GEN_739; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_783 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_12 : _GEN_740; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_784 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_13 : _GEN_741; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_785 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_14 : _GEN_742; // @[Sdc.scala 135:23 273:59]
  wire [3:0] _GEN_786 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_15 : _GEN_743; // @[Sdc.scala 135:23 273:59]
  wire  _GEN_787 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_start_bit : _GEN_744; // @[Sdc.scala 129:33 273:59]
  wire [7:0] _GEN_788 = ~rx_dat_in_progress & rx_dat_next[0] ? rxtx_dat_index : _GEN_745; // @[Sdc.scala 142:31 273:59]
  wire  _GEN_789 = ~rx_dat_in_progress & rx_dat_next[0] ? 1'h0 : _GEN_746; // @[Sdc.scala 253:17 273:59]
  wire  _GEN_791 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_error : _GEN_752; // @[Sdc.scala 136:33 273:59]
  wire  _GEN_792 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_overrun : _GEN_753; // @[Sdc.scala 139:31 273:59]
  wire [18:0] _GEN_793 = _T_5 ? _GEN_755 : rx_dat_timer; // @[Sdc.scala 137:29 272:47]
  wire [10:0] _GEN_794 = _T_5 ? _GEN_756 : rx_dat_counter; // @[Sdc.scala 128:31 272:47]
  wire  _GEN_795 = _T_5 ? _GEN_757 : rx_dat_ready; // @[Sdc.scala 133:29 272:47]
  wire  _GEN_796 = _T_5 ? _GEN_758 : rx_dat_timeout; // @[Sdc.scala 138:31 272:47]
  wire  _GEN_797 = _T_5 & _GEN_759; // @[Sdc.scala 256:17 272:47]
  wire  _GEN_798 = _T_5 ? _GEN_760 : _GEN_657; // @[Sdc.scala 272:47]
  wire [7:0] _GEN_799 = _T_5 ? _GEN_761 : rxtx_dat_counter; // @[Sdc.scala 141:33 272:47]
  wire  _GEN_800 = _T_5 ? _GEN_762 : rx_dat_in_progress; // @[Sdc.scala 127:35 272:47]
  wire [3:0] _GEN_809 = _T_5 ? _GEN_771 : rx_dat_crc_0; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_810 = _T_5 ? _GEN_772 : rx_dat_crc_1; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_811 = _T_5 ? _GEN_773 : rx_dat_crc_2; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_812 = _T_5 ? _GEN_774 : rx_dat_crc_3; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_813 = _T_5 ? _GEN_775 : rx_dat_crc_4; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_814 = _T_5 ? _GEN_776 : rx_dat_crc_5; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_815 = _T_5 ? _GEN_777 : rx_dat_crc_6; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_816 = _T_5 ? _GEN_778 : rx_dat_crc_7; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_817 = _T_5 ? _GEN_779 : rx_dat_crc_8; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_818 = _T_5 ? _GEN_780 : rx_dat_crc_9; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_819 = _T_5 ? _GEN_781 : rx_dat_crc_10; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_820 = _T_5 ? _GEN_782 : rx_dat_crc_11; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_821 = _T_5 ? _GEN_783 : rx_dat_crc_12; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_822 = _T_5 ? _GEN_784 : rx_dat_crc_13; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_823 = _T_5 ? _GEN_785 : rx_dat_crc_14; // @[Sdc.scala 135:23 272:47]
  wire [3:0] _GEN_824 = _T_5 ? _GEN_786 : rx_dat_crc_15; // @[Sdc.scala 135:23 272:47]
  wire  _GEN_825 = _T_5 ? _GEN_787 : rx_dat_start_bit; // @[Sdc.scala 129:33 272:47]
  wire [7:0] _GEN_826 = _T_5 ? _GEN_788 : rxtx_dat_index; // @[Sdc.scala 142:31 272:47]
  wire  _GEN_827 = _T_5 & _GEN_789; // @[Sdc.scala 253:17 272:47]
  wire  _GEN_829 = _T_5 ? _GEN_791 : rx_dat_crc_error; // @[Sdc.scala 136:33 272:47]
  wire  _GEN_830 = _T_5 ? _GEN_792 : rx_dat_overrun; // @[Sdc.scala 139:31 272:47]
  wire [18:0] _GEN_832 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_793 : rx_dat_timer; // @[Sdc.scala 137:29 270:57]
  wire [10:0] _GEN_833 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_794 : rx_dat_counter; // @[Sdc.scala 128:31 270:57]
  wire  _GEN_834 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_795 : rx_dat_ready; // @[Sdc.scala 133:29 270:57]
  wire  _GEN_835 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_796 : rx_dat_timeout; // @[Sdc.scala 138:31 270:57]
  wire  _GEN_836 = rx_dat_counter > 11'h0 & _T_2 & _GEN_797; // @[Sdc.scala 256:17 270:57]
  wire  _GEN_837 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_798 : _GEN_657; // @[Sdc.scala 270:57]
  wire [7:0] _GEN_838 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_799 : rxtx_dat_counter; // @[Sdc.scala 141:33 270:57]
  wire  _GEN_839 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_800 : rx_dat_in_progress; // @[Sdc.scala 127:35 270:57]
  wire [3:0] _GEN_848 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_809 : rx_dat_crc_0; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_849 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_810 : rx_dat_crc_1; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_850 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_811 : rx_dat_crc_2; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_851 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_812 : rx_dat_crc_3; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_852 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_813 : rx_dat_crc_4; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_853 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_814 : rx_dat_crc_5; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_854 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_815 : rx_dat_crc_6; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_855 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_816 : rx_dat_crc_7; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_856 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_817 : rx_dat_crc_8; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_857 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_818 : rx_dat_crc_9; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_858 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_819 : rx_dat_crc_10; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_859 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_820 : rx_dat_crc_11; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_860 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_821 : rx_dat_crc_12; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_861 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_822 : rx_dat_crc_13; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_862 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_823 : rx_dat_crc_14; // @[Sdc.scala 135:23 270:57]
  wire [3:0] _GEN_863 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_824 : rx_dat_crc_15; // @[Sdc.scala 135:23 270:57]
  wire  _GEN_864 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_825 : rx_dat_start_bit; // @[Sdc.scala 129:33 270:57]
  wire [7:0] _GEN_865 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_826 : rxtx_dat_index; // @[Sdc.scala 142:31 270:57]
  wire  _GEN_868 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_829 : rx_dat_crc_error; // @[Sdc.scala 136:33 270:57]
  wire  _GEN_869 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_830 : rx_dat_overrun; // @[Sdc.scala 139:31 270:57]
  wire  _T_58 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new; // @[Sdc.scala 346:77]
  wire [10:0] _GEN_870 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 11'h412
     : tx_dat_counter; // @[Sdc.scala 346:102 347:20 152:31]
  wire  _GEN_872 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new | _GEN_659; // @[Sdc.scala 346:102 349:26]
  wire [7:0] _GEN_873 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ?
    _rxtx_dat_index_T_1 : _GEN_865; // @[Sdc.scala 346:102 351:20]
  wire [1:0] _GEN_874 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 2'h2 :
    tx_dat_prepare_state; // @[Sdc.scala 346:102 352:26 157:37]
  wire [7:0] _GEN_875 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 8'hff :
    {{2'd0}, tx_dat_timer}; // @[Sdc.scala 346:102 353:18 153:29]
  wire  _GEN_876 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_read_sel_changed; // @[Sdc.scala 346:102 354:29 164:40]
  wire  _GEN_877 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_write_sel_new; // @[Sdc.scala 346:102 355:26 165:37]
  wire  _GEN_878 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new |
    tx_dat_in_progress; // @[Sdc.scala 346:102 356:24 160:35]
  wire  _T_59 = tx_dat_read_sel == tx_dat_write_sel; // @[Sdc.scala 358:53]
  wire  _GEN_879 = tx_dat_read_sel_changed & tx_dat_read_sel == tx_dat_write_sel ? 1'h0 : _GEN_878; // @[Sdc.scala 358:76 359:24]
  wire [18:0] _rx_busy_timer_T_1 = rx_busy_timer - 19'h1; // @[Sdc.scala 366:40]
  wire [18:0] _GEN_880 = ~rx_busy_in_progress & rx_dat0_next ? _rx_busy_timer_T_1 : _GEN_473; // @[Sdc.scala 365:51 366:23]
  wire [3:0] _tx_dat_crc_status_counter_T_1 = tx_dat_crc_status_counter - 4'h1; // @[Sdc.scala 373:66]
  wire [2:0] crc_status = {tx_dat_crc_status_b_2,tx_dat_crc_status_b_1,tx_dat_crc_status_b_0}; // @[Cat.scala 31:58]
  wire  _tx_dat_crc_status_T = crc_status == 3'h2; // @[Sdc.scala 377:27]
  wire  _tx_dat_crc_status_T_1 = crc_status == 3'h5; // @[Sdc.scala 378:27]
  wire  _tx_dat_crc_status_T_2 = crc_status == 3'h6; // @[Sdc.scala 379:27]
  wire [1:0] _tx_dat_crc_status_T_3 = _tx_dat_crc_status_T_2 ? 2'h2 : 2'h3; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_crc_status_T_4 = _tx_dat_crc_status_T_1 ? 2'h1 : _tx_dat_crc_status_T_3; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_crc_status_T_5 = _tx_dat_crc_status_T ? 2'h0 : _tx_dat_crc_status_T_4; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_read_sel_T_1 = tx_dat_read_sel + 2'h1; // @[Sdc.scala 384:48]
  wire [1:0] _GEN_882 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_crc_status_T_5 : tx_dat_crc_status; // @[Sdc.scala 374:52 376:31 168:34]
  wire [1:0] _GEN_884 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_read_sel_T_1 : tx_dat_read_sel; // @[Sdc.scala 374:52 384:29 162:32]
  wire  _GEN_885 = tx_dat_crc_status_counter == 4'h2 | _GEN_876; // @[Sdc.scala 374:52 385:37]
  wire  _GEN_886 = tx_dat_started & ~tx_dat_in_progress | tx_dat_end; // @[Sdc.scala 391:58 392:26 161:27]
  wire  _GEN_887 = rx_dat0_next ? 1'h0 : 1'h1; // @[Sdc.scala 369:29 388:31 389:33]
  wire [18:0] _GEN_888 = rx_dat0_next ? 19'h0 : _GEN_880; // @[Sdc.scala 388:31 390:27]
  wire  _GEN_889 = rx_dat0_next ? _GEN_886 : tx_dat_end; // @[Sdc.scala 161:27 388:31]
  wire [3:0] _GEN_893 = tx_dat_crc_status_counter > 4'h0 ? _tx_dat_crc_status_counter_T_1 : tx_dat_crc_status_counter; // @[Sdc.scala 370:48 373:37 166:42]
  wire [1:0] _GEN_894 = tx_dat_crc_status_counter > 4'h0 ? _GEN_882 : tx_dat_crc_status; // @[Sdc.scala 168:34 370:48]
  wire [1:0] _GEN_896 = tx_dat_crc_status_counter > 4'h0 ? _GEN_884 : tx_dat_read_sel; // @[Sdc.scala 162:32 370:48]
  wire  _GEN_897 = tx_dat_crc_status_counter > 4'h0 ? _GEN_885 : _GEN_876; // @[Sdc.scala 370:48]
  wire  _GEN_898 = tx_dat_crc_status_counter > 4'h0 | _GEN_887; // @[Sdc.scala 369:29 370:48]
  wire [18:0] _GEN_899 = tx_dat_crc_status_counter > 4'h0 ? _GEN_880 : _GEN_888; // @[Sdc.scala 370:48]
  wire  _GEN_900 = tx_dat_crc_status_counter > 4'h0 ? tx_dat_end : _GEN_889; // @[Sdc.scala 161:27 370:48]
  wire [3:0] _GEN_905 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_893 : tx_dat_crc_status_counter; // @[Sdc.scala 166:42 368:51]
  wire [1:0] _GEN_908 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_896 : tx_dat_read_sel; // @[Sdc.scala 162:32 368:51]
  wire  _GEN_909 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_897 : _GEN_876; // @[Sdc.scala 368:51]
  wire [18:0] _GEN_910 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_899 : _GEN_880; // @[Sdc.scala 368:51]
  wire  _GEN_911 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_900 : tx_dat_end; // @[Sdc.scala 161:27 368:51]
  wire [18:0] _GEN_912 = _T_5 ? _GEN_910 : _GEN_473; // @[Sdc.scala 364:47]
  wire [3:0] _GEN_917 = _T_5 ? _GEN_905 : tx_dat_crc_status_counter; // @[Sdc.scala 166:42 364:47]
  wire [1:0] _GEN_920 = _T_5 ? _GEN_908 : tx_dat_read_sel; // @[Sdc.scala 162:32 364:47]
  wire  _GEN_921 = _T_5 ? _GEN_909 : _GEN_876; // @[Sdc.scala 364:47]
  wire  _GEN_922 = _T_5 ? _GEN_911 : tx_dat_end; // @[Sdc.scala 161:27 364:47]
  wire  _GEN_923 = rx_busy_timer > 19'h0 ? io_sdc_port_dat_in[0] : rx_dat0_next; // @[Sdc.scala 362:30 363:18 145:29]
  wire [18:0] _GEN_924 = rx_busy_timer > 19'h0 ? _GEN_912 : _GEN_473; // @[Sdc.scala 362:30]
  wire [3:0] _GEN_929 = rx_busy_timer > 19'h0 ? _GEN_917 : tx_dat_crc_status_counter; // @[Sdc.scala 362:30 166:42]
  wire [1:0] _GEN_932 = rx_busy_timer > 19'h0 ? _GEN_920 : tx_dat_read_sel; // @[Sdc.scala 362:30 162:32]
  wire  _GEN_933 = rx_busy_timer > 19'h0 ? _GEN_921 : _GEN_876; // @[Sdc.scala 362:30]
  wire  _GEN_934 = rx_busy_timer > 19'h0 ? _GEN_922 : tx_dat_end; // @[Sdc.scala 161:27 362:30]
  wire  _GEN_935 = _T_58 ? 1'h0 : _GEN_934; // @[Sdc.scala 400:102 402:16]
  wire [5:0] _tx_dat_timer_T_1 = tx_dat_timer - 6'h1; // @[Sdc.scala 409:34]
  wire [10:0] _tx_dat_counter_T_1 = tx_dat_counter - 11'h1; // @[Sdc.scala 416:38]
  wire [3:0] crc_1_0 = tx_dat_16 ^ tx_dat_crc_15; // @[Sdc.scala 419:18]
  wire [3:0] crc_1_5 = tx_dat_crc_4 ^ tx_dat_crc_15; // @[Sdc.scala 424:21]
  wire [3:0] crc_1_12 = tx_dat_crc_11 ^ tx_dat_crc_15; // @[Sdc.scala 431:22]
  wire  _T_91 = tx_dat_counter[2:0] == 3'h2; // @[Sdc.scala 439:65]
  wire [31:0] _GEN_936 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 32'h0 : _GEN_658; // @[Sdc.scala 445:80 446:23]
  wire [1:0] _GEN_937 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 2'h1 : _GEN_874; // @[Sdc.scala 445:80 447:28]
  wire  _GEN_938 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _T_58; // @[Sdc.scala 439:74 440:21]
  wire  _GEN_939 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _GEN_872; // @[Sdc.scala 439:74 441:28]
  wire [7:0] _GEN_940 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _rxtx_dat_index_T_1 : _GEN_873; // @[Sdc.scala 439:74 443:22]
  wire [1:0] _GEN_941 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? 2'h1 : _GEN_937; // @[Sdc.scala 439:74 444:28]
  wire [31:0] _GEN_942 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _GEN_658 : _GEN_936; // @[Sdc.scala 439:74]
  wire [3:0] _GEN_943 = tx_dat_counter == 11'h12 ? tx_dat_crc_14 : tx_dat_1; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_944 = tx_dat_counter == 11'h12 ? tx_dat_crc_13 : tx_dat_2; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_945 = tx_dat_counter == 11'h12 ? tx_dat_crc_12 : tx_dat_3; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_946 = tx_dat_counter == 11'h12 ? crc_1_12 : tx_dat_4; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_947 = tx_dat_counter == 11'h12 ? tx_dat_crc_10 : tx_dat_5; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_948 = tx_dat_counter == 11'h12 ? tx_dat_crc_9 : tx_dat_6; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_949 = tx_dat_counter == 11'h12 ? tx_dat_crc_8 : tx_dat_7; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_950 = tx_dat_counter == 11'h12 ? tx_dat_crc_7 : tx_dat_8; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_951 = tx_dat_counter == 11'h12 ? tx_dat_crc_6 : tx_dat_9; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_952 = tx_dat_counter == 11'h12 ? tx_dat_crc_5 : tx_dat_10; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_953 = tx_dat_counter == 11'h12 ? crc_1_5 : tx_dat_11; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_954 = tx_dat_counter == 11'h12 ? tx_dat_crc_3 : tx_dat_12; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_955 = tx_dat_counter == 11'h12 ? tx_dat_crc_2 : tx_dat_13; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_956 = tx_dat_counter == 11'h12 ? tx_dat_crc_1 : tx_dat_14; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_957 = tx_dat_counter == 11'h12 ? tx_dat_crc_0 : tx_dat_15; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_958 = tx_dat_counter == 11'h12 ? crc_1_0 : tx_dat_16; // @[Sdc.scala 449:36 450:40 415:50]
  wire [3:0] _GEN_959 = tx_dat_counter == 11'h12 ? 4'hf : tx_dat_17; // @[Sdc.scala 449:36 451:18 415:50]
  wire  _GEN_960 = tx_dat_counter == 11'h1 ? 1'h0 : 1'h1; // @[Sdc.scala 413:20 454:35 455:22]
  wire [18:0] _GEN_962 = tx_dat_counter == 11'h1 ? 19'h7a120 : _GEN_924; // @[Sdc.scala 454:35 457:21]
  wire [3:0] _GEN_963 = tx_dat_counter == 11'h1 ? 4'h6 : _GEN_929; // @[Sdc.scala 454:35 458:33]
  wire [3:0] _GEN_965 = tx_dat_counter != 11'h0 & _T & reg_clk ? tx_dat_0 : {{3'd0}, reg_tx_dat_out}; // @[Sdc.scala 149:31 412:77]
  wire [3:0] _GEN_966 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_943 : tx_dat_0; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_967 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_944 : tx_dat_1; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_968 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_945 : tx_dat_2; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_969 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_946 : tx_dat_3; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_970 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_947 : tx_dat_4; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_971 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_948 : tx_dat_5; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_972 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_949 : tx_dat_6; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_973 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_950 : tx_dat_7; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_974 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_951 : tx_dat_8; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_975 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_952 : tx_dat_9; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_976 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_953 : tx_dat_10; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_977 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_954 : tx_dat_11; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_978 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_955 : tx_dat_12; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_979 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_956 : tx_dat_13; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_980 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_957 : tx_dat_14; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_981 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_958 : tx_dat_15; // @[Sdc.scala 154:19 412:77]
  wire [3:0] _GEN_982 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_959 : tx_dat_16; // @[Sdc.scala 154:19 412:77]
  wire  _GEN_1006 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_938 : _T_58; // @[Sdc.scala 412:77]
  wire  _GEN_1007 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_939 : _GEN_872; // @[Sdc.scala 412:77]
  wire [7:0] _GEN_1008 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_940 : _GEN_873; // @[Sdc.scala 412:77]
  wire [1:0] _GEN_1009 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_941 : _GEN_874; // @[Sdc.scala 412:77]
  wire [7:0] _GEN_1013 = tx_dat_timer != 6'h0 & _T & reg_clk ? {{2'd0}, _tx_dat_timer_T_1} : _GEN_875; // @[Sdc.scala 408:75 409:18]
  wire [3:0] _GEN_1016 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_0 : _GEN_966; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1017 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_1 : _GEN_967; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1018 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_2 : _GEN_968; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1019 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_3 : _GEN_969; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1020 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_4 : _GEN_970; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1021 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_5 : _GEN_971; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1022 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_6 : _GEN_972; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1023 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_7 : _GEN_973; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1024 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_8 : _GEN_974; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1025 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_9 : _GEN_975; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1026 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_10 : _GEN_976; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1027 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_11 : _GEN_977; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1028 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_12 : _GEN_978; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1029 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_13 : _GEN_979; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1030 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_14 : _GEN_980; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1031 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_15 : _GEN_981; // @[Sdc.scala 154:19 408:75]
  wire [3:0] _GEN_1032 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_16 : _GEN_982; // @[Sdc.scala 154:19 408:75]
  wire  _GEN_1056 = tx_dat_timer != 6'h0 & _T & reg_clk ? _T_58 : _GEN_1006; // @[Sdc.scala 408:75]
  wire  _GEN_1057 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_872 : _GEN_1007; // @[Sdc.scala 408:75]
  wire [7:0] _GEN_1058 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_873 : _GEN_1008; // @[Sdc.scala 408:75]
  wire [1:0] _GEN_1059 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_874 : _GEN_1009; // @[Sdc.scala 408:75]
  wire [7:0] _GEN_1065 = _T_20 ? _GEN_875 : _GEN_1013; // @[Sdc.scala 405:70]
  wire [3:0] _GEN_1066 = _T_20 ? tx_dat_0 : _GEN_1016; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1067 = _T_20 ? tx_dat_1 : _GEN_1017; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1068 = _T_20 ? tx_dat_2 : _GEN_1018; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1069 = _T_20 ? tx_dat_3 : _GEN_1019; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1070 = _T_20 ? tx_dat_4 : _GEN_1020; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1071 = _T_20 ? tx_dat_5 : _GEN_1021; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1072 = _T_20 ? tx_dat_6 : _GEN_1022; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1073 = _T_20 ? tx_dat_7 : _GEN_1023; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1074 = _T_20 ? tx_dat_8 : _GEN_1024; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1075 = _T_20 ? tx_dat_9 : _GEN_1025; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1076 = _T_20 ? tx_dat_10 : _GEN_1026; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1077 = _T_20 ? tx_dat_11 : _GEN_1027; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1078 = _T_20 ? tx_dat_12 : _GEN_1028; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1079 = _T_20 ? tx_dat_13 : _GEN_1029; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1080 = _T_20 ? tx_dat_14 : _GEN_1030; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1081 = _T_20 ? tx_dat_15 : _GEN_1031; // @[Sdc.scala 154:19 405:70]
  wire [3:0] _GEN_1082 = _T_20 ? tx_dat_16 : _GEN_1032; // @[Sdc.scala 154:19 405:70]
  wire  _GEN_1106 = _T_20 ? _T_58 : _GEN_1056; // @[Sdc.scala 405:70]
  wire  _GEN_1107 = _T_20 ? _GEN_872 : _GEN_1057; // @[Sdc.scala 405:70]
  wire [7:0] _GEN_1108 = _T_20 ? _GEN_873 : _GEN_1058; // @[Sdc.scala 405:70]
  wire [1:0] _GEN_1109 = _T_20 ? _GEN_874 : _GEN_1059; // @[Sdc.scala 405:70]
  wire  _GEN_1131 = 2'h2 == tx_dat_prepare_state | _GEN_1106; // @[Sdc.scala 462:33 484:21]
  wire  _GEN_1132 = 2'h2 == tx_dat_prepare_state | _GEN_1107; // @[Sdc.scala 462:33 485:28]
  wire [7:0] _GEN_1133 = 2'h2 == tx_dat_prepare_state ? _rxtx_dat_index_T_1 : _GEN_1108; // @[Sdc.scala 462:33 487:22]
  wire [7:0] _GEN_1163 = 2'h1 == tx_dat_prepare_state ? _GEN_1108 : _GEN_1133; // @[Sdc.scala 462:33]
  wire [1:0] addr = io_mem_waddr[3:2]; // @[Sdc.scala 509:28]
  wire [8:0] baud_divider = io_mem_wdata[8:0]; // @[Sdc.scala 512:40]
  wire [47:0] tx_cmd_val = {2'h1,io_mem_wdata[9:4],tx_cmd_arg,7'h0,1'h1}; // @[Cat.scala 31:58]
  wire  _GEN_1175 = io_mem_wdata[3:0] == 4'h3 ? 1'h0 : 1'h1; // @[Sdc.scala 534:25 543:59 545:27]
  wire [7:0] _GEN_1176 = io_mem_wdata[3:0] == 4'h2 ? 8'h88 : 8'h30; // @[Sdc.scala 540:59 541:28]
  wire  _GEN_1177 = io_mem_wdata[3:0] == 4'h2 ? 1'h0 : _GEN_1175; // @[Sdc.scala 540:59 542:27]
  wire [7:0] _GEN_1178 = io_mem_wdata[3:0] == 4'h0 ? 8'h0 : _GEN_1176; // @[Sdc.scala 538:55 539:28]
  wire  _GEN_1179 = io_mem_wdata[3:0] == 4'h0 | _GEN_1177; // @[Sdc.scala 534:25 538:55]
  wire  _GEN_1180 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_839; // @[Sdc.scala 549:69 550:32]
  wire [10:0] _GEN_1181 = io_mem_wdata[12] | io_mem_wdata[13] ? 11'h411 : 11'h0; // @[Sdc.scala 549:69 551:28 563:28]
  wire  _GEN_1182 = io_mem_wdata[12] | io_mem_wdata[13] | _GEN_864; // @[Sdc.scala 549:69 552:30]
  wire [3:0] _GEN_1184 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_848; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1185 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_849; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1186 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_850; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1187 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_851; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1188 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_852; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1189 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_853; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1190 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_854; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1191 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_855; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1192 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_856; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1193 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_857; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1194 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_858; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1195 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_859; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1196 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_860; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1197 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_861; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1198 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_862; // @[Sdc.scala 549:69 554:24]
  wire [3:0] _GEN_1199 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_863; // @[Sdc.scala 549:69 554:24]
  wire  _GEN_1200 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_868; // @[Sdc.scala 549:69 555:30]
  wire [18:0] _GEN_1201 = io_mem_wdata[12] | io_mem_wdata[13] ? 19'h7a120 : _GEN_832; // @[Sdc.scala 549:69 556:26]
  wire  _GEN_1202 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_835; // @[Sdc.scala 549:69 557:28]
  wire  _GEN_1203 = io_mem_wdata[12] | io_mem_wdata[13] ? io_mem_wdata[13] : rx_dat_continuous; // @[Sdc.scala 549:69 558:31 132:34]
  wire  _GEN_1204 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_869; // @[Sdc.scala 549:69 559:28]
  wire [7:0] _GEN_1205 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_1163; // @[Sdc.scala 549:69 560:28]
  wire [7:0] _GEN_1206 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_838; // @[Sdc.scala 549:69 561:30]
  wire  _T_179 = io_mem_wdata[14] | io_mem_wdata[15]; // @[Sdc.scala 566:41]
  wire [1:0] _GEN_1209 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : _GEN_932; // @[Sdc.scala 566:69 569:29]
  wire [1:0] _GEN_1210 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : tx_dat_write_sel; // @[Sdc.scala 566:69 570:30 163:33]
  wire  _GEN_1211 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_933; // @[Sdc.scala 566:69 571:37]
  wire  _GEN_1212 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_877; // @[Sdc.scala 566:69 572:34]
  wire  _GEN_1213 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_879; // @[Sdc.scala 566:69 573:32]
  wire  _GEN_1214 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_935; // @[Sdc.scala 566:69 574:24]
  wire [7:0] _GEN_1215 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1205; // @[Sdc.scala 566:69 575:28]
  wire [7:0] _GEN_1216 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1206; // @[Sdc.scala 566:69 576:30]
  wire [5:0] _GEN_1265 = io_mem_wdata[11] ? 6'h30 : _GEN_648; // @[Sdc.scala 524:40 527:26]
  wire [3:0] _GEN_1273 = io_mem_wdata[11] ? io_mem_wdata[3:0] : rx_res_type; // @[Sdc.scala 524:40 529:23 110:28]
  wire  _GEN_1274 = io_mem_wdata[11] ? 1'h0 : _GEN_464; // @[Sdc.scala 524:40 530:30]
  wire  _GEN_1275 = io_mem_wdata[11] ? 1'h0 : _GEN_326; // @[Sdc.scala 524:40 531:24]
  wire  _GEN_1283 = io_mem_wdata[11] ? 1'h0 : _GEN_472; // @[Sdc.scala 524:40 533:28]
  wire  _GEN_1284 = io_mem_wdata[11] ? _GEN_1179 : rx_res_crc_en; // @[Sdc.scala 116:30 524:40]
  wire [7:0] _GEN_1285 = io_mem_wdata[11] ? 8'hff : _GEN_323; // @[Sdc.scala 524:40 535:24]
  wire  _GEN_1286 = io_mem_wdata[11] ? 1'h0 : _GEN_327; // @[Sdc.scala 524:40 536:26]
  wire [1:0] _GEN_1287 = io_mem_wdata[11] ? 2'h0 : rx_res_read_counter; // @[Sdc.scala 524:40 537:31 119:36]
  wire [7:0] _GEN_1288 = io_mem_wdata[11] ? _GEN_1178 : _GEN_324; // @[Sdc.scala 524:40]
  wire  _GEN_1289 = io_mem_wdata[11] ? _GEN_1180 : _GEN_839; // @[Sdc.scala 524:40]
  wire [10:0] _GEN_1290 = io_mem_wdata[11] ? _GEN_1181 : _GEN_833; // @[Sdc.scala 524:40]
  wire  _GEN_1291 = io_mem_wdata[11] ? _GEN_1182 : _GEN_864; // @[Sdc.scala 524:40]
  wire  _GEN_1292 = io_mem_wdata[11] ? 1'h0 : _GEN_834; // @[Sdc.scala 524:40]
  wire  _GEN_1309 = io_mem_wdata[11] ? _GEN_1200 : _GEN_868; // @[Sdc.scala 524:40]
  wire [18:0] _GEN_1310 = io_mem_wdata[11] ? _GEN_1201 : _GEN_832; // @[Sdc.scala 524:40]
  wire  _GEN_1311 = io_mem_wdata[11] ? _GEN_1202 : _GEN_835; // @[Sdc.scala 524:40]
  wire  _GEN_1312 = io_mem_wdata[11] ? _GEN_1203 : rx_dat_continuous; // @[Sdc.scala 132:34 524:40]
  wire  _GEN_1313 = io_mem_wdata[11] ? _GEN_1204 : _GEN_869; // @[Sdc.scala 524:40]
  wire [7:0] _GEN_1314 = io_mem_wdata[11] ? _GEN_1215 : _GEN_1163; // @[Sdc.scala 524:40]
  wire [7:0] _GEN_1315 = io_mem_wdata[11] ? _GEN_1216 : _GEN_838; // @[Sdc.scala 524:40]
  wire  _GEN_1316 = io_mem_wdata[11] ? _T_179 : tx_dat_started; // @[Sdc.scala 158:31 524:40]
  wire [1:0] _GEN_1318 = io_mem_wdata[11] ? _GEN_1209 : _GEN_932; // @[Sdc.scala 524:40]
  wire [1:0] _GEN_1319 = io_mem_wdata[11] ? _GEN_1210 : tx_dat_write_sel; // @[Sdc.scala 163:33 524:40]
  wire  _GEN_1320 = io_mem_wdata[11] ? _GEN_1211 : _GEN_933; // @[Sdc.scala 524:40]
  wire  _GEN_1321 = io_mem_wdata[11] ? _GEN_1212 : _GEN_877; // @[Sdc.scala 524:40]
  wire  _GEN_1322 = io_mem_wdata[11] ? _GEN_1213 : _GEN_879; // @[Sdc.scala 524:40]
  wire  _GEN_1323 = io_mem_wdata[11] ? _GEN_1214 : _GEN_935; // @[Sdc.scala 524:40]
  wire [1:0] _T_182 = tx_dat_read_sel ^ tx_dat_write_sel; // @[Sdc.scala 587:32]
  wire  _T_183 = _T_182 != 2'h2; // @[Sdc.scala 587:52]
  wire [7:0] _GEN_1324 = _T_182 != 2'h2 ? _rxtx_dat_counter_T_1 : _GEN_838; // @[Sdc.scala 587:65 588:28]
  wire  _T_185 = rxtx_dat_counter[6:0] == 7'h7f; // @[Sdc.scala 593:38]
  wire [1:0] _tx_dat_write_sel_T_1 = tx_dat_write_sel + 2'h1; // @[Sdc.scala 594:48]
  wire  _GEN_1327 = _T_59 | _GEN_877; // @[Sdc.scala 595:55 596:34]
  wire [1:0] _GEN_1328 = rxtx_dat_counter[6:0] == 7'h7f ? _tx_dat_write_sel_T_1 : tx_dat_write_sel; // @[Sdc.scala 593:49 594:28 163:33]
  wire  _GEN_1329 = rxtx_dat_counter[6:0] == 7'h7f ? _GEN_1327 : _GEN_877; // @[Sdc.scala 593:49]
  wire [7:0] _GEN_1330 = 2'h3 == addr ? _GEN_1324 : _GEN_838; // @[Sdc.scala 510:19]
  wire [1:0] _GEN_1333 = 2'h3 == addr ? _GEN_1328 : tx_dat_write_sel; // @[Sdc.scala 510:19 163:33]
  wire  _GEN_1334 = 2'h3 == addr ? _GEN_1329 : _GEN_877; // @[Sdc.scala 510:19]
  wire [31:0] _GEN_1335 = 2'h2 == addr ? io_mem_wdata : tx_cmd_arg; // @[Sdc.scala 510:19 584:20 120:27]
  wire [7:0] _GEN_1336 = 2'h2 == addr ? _GEN_838 : _GEN_1330; // @[Sdc.scala 510:19]
  wire  _GEN_1337 = 2'h2 == addr ? 1'h0 : 2'h3 == addr & _T_183; // @[Sdc.scala 257:17 510:19]
  wire [1:0] _GEN_1339 = 2'h2 == addr ? tx_dat_write_sel : _GEN_1333; // @[Sdc.scala 510:19 163:33]
  wire  _GEN_1340 = 2'h2 == addr ? _GEN_877 : _GEN_1334; // @[Sdc.scala 510:19]
  wire  _GEN_1399 = 2'h1 == addr ? _GEN_1275 : _GEN_326; // @[Sdc.scala 510:19]
  wire [1:0] _GEN_1411 = 2'h1 == addr ? _GEN_1287 : rx_res_read_counter; // @[Sdc.scala 510:19 119:36]
  wire  _GEN_1416 = 2'h1 == addr ? _GEN_1292 : _GEN_834; // @[Sdc.scala 510:19]
  wire [7:0] _GEN_1439 = 2'h1 == addr ? _GEN_1315 : _GEN_1336; // @[Sdc.scala 510:19]
  wire  _GEN_1449 = 2'h1 == addr ? 1'h0 : _GEN_1337; // @[Sdc.scala 257:17 510:19]
  wire  _GEN_1516 = 2'h0 == addr ? _GEN_326 : _GEN_1399; // @[Sdc.scala 510:19]
  wire [1:0] _GEN_1528 = 2'h0 == addr ? rx_res_read_counter : _GEN_1411; // @[Sdc.scala 510:19 119:36]
  wire  _GEN_1533 = 2'h0 == addr ? _GEN_834 : _GEN_1416; // @[Sdc.scala 510:19]
  wire [7:0] _GEN_1556 = 2'h0 == addr ? _GEN_838 : _GEN_1439; // @[Sdc.scala 510:19]
  wire  _GEN_1566 = 2'h0 == addr ? 1'h0 : _GEN_1449; // @[Sdc.scala 257:17 510:19]
  wire  _GEN_1633 = io_mem_wen ? _GEN_1516 : _GEN_326; // @[Sdc.scala 508:21]
  wire [1:0] _GEN_1645 = io_mem_wen ? _GEN_1528 : rx_res_read_counter; // @[Sdc.scala 508:21 119:36]
  wire  _GEN_1650 = io_mem_wen ? _GEN_1533 : _GEN_834; // @[Sdc.scala 508:21]
  wire [7:0] _GEN_1673 = io_mem_wen ? _GEN_1556 : _GEN_838; // @[Sdc.scala 508:21]
  wire [1:0] addr_1 = io_mem_raddr[3:2]; // @[Sdc.scala 603:28]
  wire [31:0] _io_mem_rdata_T = {reg_power,11'h0,tx_end_intr_en,tx_empty_intr_en,rx_dat_intr_en,rx_res_intr_en,7'h0,
    reg_baud_divider}; // @[Cat.scala 31:58]
  wire  _io_mem_rdata_T_1 = tx_dat_started & tx_dat_end; // @[Sdc.scala 621:26]
  wire  _io_mem_rdata_T_4 = tx_dat_started & _T_182 == 2'h2; // @[Sdc.scala 622:26]
  wire [17:0] io_mem_rdata_lo_1 = {rx_dat_crc_error,rx_dat_ready,13'h0,rx_res_timeout,rx_res_crc_error,rx_res_ready}; // @[Cat.scala 31:58]
  wire [31:0] _io_mem_rdata_T_5 = {8'h0,tx_dat_crc_status,_io_mem_rdata_T_1,_io_mem_rdata_T_4,rx_dat_overrun,
    rx_dat_timeout,io_mem_rdata_lo_1}; // @[Cat.scala 31:58]
  wire [1:0] _rx_res_read_counter_T_1 = rx_res_read_counter + 2'h1; // @[Sdc.scala 634:52]
  wire [6:0] _io_mem_rdata_T_6 = {rx_res_read_counter,5'h0}; // @[Cat.scala 31:58]
  wire [135:0] _io_mem_rdata_T_7 = rx_res >> _io_mem_rdata_T_6; // @[Sdc.scala 636:35]
  wire  _GEN_1685 = rx_res_read_counter == 2'h3 ? 1'h0 : _GEN_1633; // @[Sdc.scala 637:46 638:26]
  wire [31:0] _GEN_1686 = rx_res_type == 4'h2 ? _io_mem_rdata_T_7[31:0] : rx_res[39:8]; // @[Sdc.scala 635:44 636:24 641:24]
  wire  _GEN_1687 = rx_res_type == 4'h2 & _GEN_1685; // @[Sdc.scala 635:44 642:24]
  wire  _GEN_1688 = _T_185 ? 1'h0 : _GEN_1650; // @[Sdc.scala 652:51 653:26]
  wire [7:0] _GEN_1689 = rx_dat_ready ? _rxtx_dat_counter_T_1 : _GEN_1673; // @[Sdc.scala 647:29 648:28]
  wire  _GEN_1690 = rx_dat_ready | _GEN_836; // @[Sdc.scala 647:29 649:25]
  wire  _GEN_1691 = rx_dat_ready | _GEN_837; // @[Sdc.scala 647:29 650:27]
  wire  _GEN_1692 = rx_dat_ready ? _GEN_1688 : _GEN_1650; // @[Sdc.scala 647:29]
  wire [31:0] _GEN_1693 = 2'h3 == addr_1 ? rx_dat_buf_cache : 32'hdeadbeef; // @[Sdc.scala 503:16 604:19 646:22]
  wire [7:0] _GEN_1694 = 2'h3 == addr_1 ? _GEN_1689 : _GEN_1673; // @[Sdc.scala 604:19]
  wire  _GEN_1695 = 2'h3 == addr_1 ? _GEN_1690 : _GEN_836; // @[Sdc.scala 604:19]
  wire  _GEN_1696 = 2'h3 == addr_1 ? _GEN_1691 : _GEN_837; // @[Sdc.scala 604:19]
  wire  _GEN_1697 = 2'h3 == addr_1 ? _GEN_1692 : _GEN_1650; // @[Sdc.scala 604:19]
  wire [1:0] _GEN_1698 = 2'h2 == addr_1 ? _rx_res_read_counter_T_1 : _GEN_1645; // @[Sdc.scala 604:19 634:29]
  wire [31:0] _GEN_1699 = 2'h2 == addr_1 ? _GEN_1686 : _GEN_1693; // @[Sdc.scala 604:19]
  wire  _GEN_1700 = 2'h2 == addr_1 ? _GEN_1687 : _GEN_1633; // @[Sdc.scala 604:19]
  wire [7:0] _GEN_1701 = 2'h2 == addr_1 ? _GEN_1673 : _GEN_1694; // @[Sdc.scala 604:19]
  wire  _GEN_1702 = 2'h2 == addr_1 ? _GEN_836 : _GEN_1695; // @[Sdc.scala 604:19]
  wire  _GEN_1703 = 2'h2 == addr_1 ? _GEN_837 : _GEN_1696; // @[Sdc.scala 604:19]
  wire  _GEN_1704 = 2'h2 == addr_1 ? _GEN_1650 : _GEN_1697; // @[Sdc.scala 604:19]
  wire [31:0] _GEN_1705 = 2'h1 == addr_1 ? _io_mem_rdata_T_5 : _GEN_1699; // @[Sdc.scala 604:19 618:22]
  wire  _GEN_1709 = 2'h1 == addr_1 ? _GEN_836 : _GEN_1702; // @[Sdc.scala 604:19]
  wire [31:0] _GEN_1712 = 2'h0 == addr_1 ? _io_mem_rdata_T : _GEN_1705; // @[Sdc.scala 604:19 606:22]
  wire  _GEN_1716 = 2'h0 == addr_1 ? _GEN_836 : _GEN_1709; // @[Sdc.scala 604:19]
  wire  _intr_T_1 = rx_dat_intr_en & rx_dat_ready; // @[Sdc.scala 661:21]
  wire  _intr_T_2 = rx_res_intr_en & rx_res_ready | _intr_T_1; // @[Sdc.scala 660:44]
  wire  _intr_T_6 = tx_empty_intr_en & tx_dat_started & _T_183; // @[Sdc.scala 662:41]
  wire  _intr_T_7 = _intr_T_2 | _intr_T_6; // @[Sdc.scala 661:38]
  wire  _T_198 = ~reset; // @[Sdc.scala 666:9]
  wire [136:0] _GEN_1726 = reset ? 137'h0 : _GEN_325; // @[Sdc.scala 111:{23,23}]
  wire [3:0] _GEN_1727 = reset ? 4'h0 : _GEN_965; // @[Sdc.scala 149:{31,31}]
  wire [7:0] _GEN_1728 = reset ? 8'h0 : _GEN_1065; // @[Sdc.scala 153:{29,29}]
  assign io_mem_rdata = io_mem_ren ? _GEN_1712 : 32'hdeadbeef; // @[Sdc.scala 503:16 602:21]
  assign io_sdc_port_clk = reg_clk; // @[Sdc.scala 102:19]
  assign io_sdc_port_cmd_wrt = reg_tx_cmd_wrt; // @[Sdc.scala 212:23]
  assign io_sdc_port_cmd_out = reg_tx_cmd_out; // @[Sdc.scala 213:23]
  assign io_sdc_port_dat_wrt = reg_tx_dat_wrt; // @[Sdc.scala 249:23]
  assign io_sdc_port_dat_out = {{3'd0}, reg_tx_dat_out}; // @[Sdc.scala 250:23]
  assign io_sdbuf_ren1 = 2'h1 == tx_dat_prepare_state ? _GEN_1106 : _GEN_1131; // @[Sdc.scala 462:33]
  assign io_sdbuf_wen1 = rx_dat_counter > 11'h0 & _T_2 & _GEN_827; // @[Sdc.scala 253:17 270:57]
  assign io_sdbuf_addr1 = rxtx_dat_index; // @[Sdc.scala 254:18]
  assign io_sdbuf_wdata1 = {io_sdbuf_wdata1_hi,io_sdbuf_wdata1_lo}; // @[Cat.scala 31:58]
  assign io_sdbuf_ren2 = io_mem_ren ? _GEN_1716 : _GEN_836; // @[Sdc.scala 602:21]
  assign io_sdbuf_wen2 = io_mem_wen & _GEN_1566; // @[Sdc.scala 257:17 508:21]
  assign io_sdbuf_addr2 = rxtx_dat_counter; // @[Sdc.scala 258:18]
  assign io_sdbuf_wdata2 = io_mem_wdata; // @[Sdc.scala 587:65 590:27]
  assign io_intr = intr; // @[Sdc.scala 664:11]
  always @(posedge clock) begin
    if (reset) begin // @[Sdc.scala 88:26]
      reg_power <= 1'h0; // @[Sdc.scala 88:26]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 513:37]
          reg_power <= io_mem_wdata[31]; // @[Sdc.scala 514:21]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 89:33]
      reg_baud_divider <= 9'h2; // @[Sdc.scala 89:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 513:37]
          reg_baud_divider <= baud_divider; // @[Sdc.scala 515:28]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 90:32]
      reg_clk_counter <= 9'h2; // @[Sdc.scala 90:32]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 513:37]
          reg_clk_counter <= baud_divider; // @[Sdc.scala 516:27]
        end else begin
          reg_clk_counter <= _GEN_2;
        end
      end else begin
        reg_clk_counter <= _GEN_2;
      end
    end else begin
      reg_clk_counter <= _GEN_2;
    end
    if (reset) begin // @[Sdc.scala 91:24]
      reg_clk <= 1'h0; // @[Sdc.scala 91:24]
    end else begin
      reg_clk <= _GEN_3;
    end
    if (reset) begin // @[Sdc.scala 104:21]
      intr <= 1'h0; // @[Sdc.scala 104:21]
    end else begin
      intr <= _intr_T_7; // @[Sdc.scala 660:8]
    end
    if (reset) begin // @[Sdc.scala 106:35]
      rx_res_in_progress <= 1'h0; // @[Sdc.scala 106:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_in_progress <= _GEN_464;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_res_in_progress <= _GEN_1274;
      end else begin
        rx_res_in_progress <= _GEN_464;
      end
    end else begin
      rx_res_in_progress <= _GEN_464;
    end
    if (reset) begin // @[Sdc.scala 107:31]
      rx_res_counter <= 8'h0; // @[Sdc.scala 107:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_counter <= _GEN_324;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_res_counter <= _GEN_1288;
      end else begin
        rx_res_counter <= _GEN_324;
      end
    end else begin
      rx_res_counter <= _GEN_324;
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_0 <= rx_res_next; // @[Sdc.scala 185:24]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_1 <= rx_res_bits_0; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_2 <= rx_res_bits_1; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_3 <= rx_res_bits_2; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_4 <= rx_res_bits_3; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_5 <= rx_res_bits_4; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_6 <= rx_res_bits_5; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_7 <= rx_res_bits_6; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_8 <= rx_res_bits_7; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_9 <= rx_res_bits_8; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_10 <= rx_res_bits_9; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_11 <= rx_res_bits_10; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_12 <= rx_res_bits_11; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_13 <= rx_res_bits_12; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_14 <= rx_res_bits_13; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_15 <= rx_res_bits_14; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_16 <= rx_res_bits_15; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_17 <= rx_res_bits_16; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_18 <= rx_res_bits_17; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_19 <= rx_res_bits_18; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_20 <= rx_res_bits_19; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_21 <= rx_res_bits_20; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_22 <= rx_res_bits_21; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_23 <= rx_res_bits_22; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_24 <= rx_res_bits_23; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_25 <= rx_res_bits_24; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_26 <= rx_res_bits_25; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_27 <= rx_res_bits_26; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_28 <= rx_res_bits_27; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_29 <= rx_res_bits_28; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_30 <= rx_res_bits_29; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_31 <= rx_res_bits_30; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_32 <= rx_res_bits_31; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_33 <= rx_res_bits_32; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_34 <= rx_res_bits_33; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_35 <= rx_res_bits_34; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_36 <= rx_res_bits_35; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_37 <= rx_res_bits_36; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_38 <= rx_res_bits_37; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_39 <= rx_res_bits_38; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_40 <= rx_res_bits_39; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_41 <= rx_res_bits_40; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_42 <= rx_res_bits_41; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_43 <= rx_res_bits_42; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_44 <= rx_res_bits_43; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_45 <= rx_res_bits_44; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_46 <= rx_res_bits_45; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_47 <= rx_res_bits_46; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_48 <= rx_res_bits_47; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_49 <= rx_res_bits_48; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_50 <= rx_res_bits_49; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_51 <= rx_res_bits_50; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_52 <= rx_res_bits_51; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_53 <= rx_res_bits_52; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_54 <= rx_res_bits_53; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_55 <= rx_res_bits_54; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_56 <= rx_res_bits_55; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_57 <= rx_res_bits_56; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_58 <= rx_res_bits_57; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_59 <= rx_res_bits_58; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_60 <= rx_res_bits_59; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_61 <= rx_res_bits_60; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_62 <= rx_res_bits_61; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_63 <= rx_res_bits_62; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_64 <= rx_res_bits_63; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_65 <= rx_res_bits_64; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_66 <= rx_res_bits_65; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_67 <= rx_res_bits_66; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_68 <= rx_res_bits_67; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_69 <= rx_res_bits_68; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_70 <= rx_res_bits_69; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_71 <= rx_res_bits_70; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_72 <= rx_res_bits_71; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_73 <= rx_res_bits_72; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_74 <= rx_res_bits_73; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_75 <= rx_res_bits_74; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_76 <= rx_res_bits_75; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_77 <= rx_res_bits_76; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_78 <= rx_res_bits_77; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_79 <= rx_res_bits_78; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_80 <= rx_res_bits_79; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_81 <= rx_res_bits_80; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_82 <= rx_res_bits_81; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_83 <= rx_res_bits_82; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_84 <= rx_res_bits_83; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_85 <= rx_res_bits_84; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_86 <= rx_res_bits_85; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_87 <= rx_res_bits_86; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_88 <= rx_res_bits_87; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_89 <= rx_res_bits_88; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_90 <= rx_res_bits_89; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_91 <= rx_res_bits_90; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_92 <= rx_res_bits_91; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_93 <= rx_res_bits_92; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_94 <= rx_res_bits_93; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_95 <= rx_res_bits_94; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_96 <= rx_res_bits_95; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_97 <= rx_res_bits_96; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_98 <= rx_res_bits_97; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_99 <= rx_res_bits_98; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_100 <= rx_res_bits_99; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_101 <= rx_res_bits_100; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_102 <= rx_res_bits_101; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_103 <= rx_res_bits_102; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_104 <= rx_res_bits_103; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_105 <= rx_res_bits_104; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_106 <= rx_res_bits_105; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_107 <= rx_res_bits_106; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_108 <= rx_res_bits_107; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_109 <= rx_res_bits_108; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_110 <= rx_res_bits_109; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_111 <= rx_res_bits_110; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_112 <= rx_res_bits_111; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_113 <= rx_res_bits_112; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_114 <= rx_res_bits_113; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_115 <= rx_res_bits_114; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_116 <= rx_res_bits_115; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_117 <= rx_res_bits_116; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_118 <= rx_res_bits_117; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_119 <= rx_res_bits_118; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_120 <= rx_res_bits_119; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_121 <= rx_res_bits_120; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_122 <= rx_res_bits_121; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_123 <= rx_res_bits_122; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_124 <= rx_res_bits_123; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_125 <= rx_res_bits_124; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_126 <= rx_res_bits_125; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_127 <= rx_res_bits_126; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_128 <= rx_res_bits_127; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_129 <= rx_res_bits_128; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_130 <= rx_res_bits_129; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_131 <= rx_res_bits_130; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_132 <= rx_res_bits_131; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_133 <= rx_res_bits_132; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_134 <= rx_res_bits_133; // @[Sdc.scala 184:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 183:49]
          rx_res_bits_135 <= rx_res_bits_134; // @[Sdc.scala 184:61]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 109:28]
      rx_res_next <= 1'h0; // @[Sdc.scala 109:28]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      rx_res_next <= io_sdc_port_res_in; // @[Sdc.scala 172:17]
    end
    if (reset) begin // @[Sdc.scala 110:28]
      rx_res_type <= 4'h0; // @[Sdc.scala 110:28]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          rx_res_type <= _GEN_1273;
        end
      end
    end
    rx_res <= _GEN_1726[135:0]; // @[Sdc.scala 111:{23,23}]
    if (reset) begin // @[Sdc.scala 112:29]
      rx_res_ready <= 1'h0; // @[Sdc.scala 112:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 602:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 604:19]
        rx_res_ready <= _GEN_1633;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 604:19]
        rx_res_ready <= _GEN_1633;
      end else begin
        rx_res_ready <= _GEN_1700;
      end
    end else begin
      rx_res_ready <= _GEN_1633;
    end
    if (reset) begin // @[Sdc.scala 113:31]
      rx_res_intr_en <= 1'h0; // @[Sdc.scala 113:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_intr_en <= io_mem_wdata[16]; // @[Sdc.scala 518:26]
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_0 <= _GEN_465;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_0 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_0 <= _GEN_465;
        end
      end else begin
        rx_res_crc_0 <= _GEN_465;
      end
    end else begin
      rx_res_crc_0 <= _GEN_465;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_1 <= _GEN_466;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_1 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_1 <= _GEN_466;
        end
      end else begin
        rx_res_crc_1 <= _GEN_466;
      end
    end else begin
      rx_res_crc_1 <= _GEN_466;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_2 <= _GEN_467;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_2 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_2 <= _GEN_467;
        end
      end else begin
        rx_res_crc_2 <= _GEN_467;
      end
    end else begin
      rx_res_crc_2 <= _GEN_467;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_3 <= _GEN_468;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_3 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_3 <= _GEN_468;
        end
      end else begin
        rx_res_crc_3 <= _GEN_468;
      end
    end else begin
      rx_res_crc_3 <= _GEN_468;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_4 <= _GEN_469;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_4 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_4 <= _GEN_469;
        end
      end else begin
        rx_res_crc_4 <= _GEN_469;
      end
    end else begin
      rx_res_crc_4 <= _GEN_469;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_5 <= _GEN_470;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_5 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_5 <= _GEN_470;
        end
      end else begin
        rx_res_crc_5 <= _GEN_470;
      end
    end else begin
      rx_res_crc_5 <= _GEN_470;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_6 <= _GEN_471;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_res_crc_6 <= 1'h0; // @[Sdc.scala 532:22]
        end else begin
          rx_res_crc_6 <= _GEN_471;
        end
      end else begin
        rx_res_crc_6 <= _GEN_471;
      end
    end else begin
      rx_res_crc_6 <= _GEN_471;
    end
    if (reset) begin // @[Sdc.scala 115:33]
      rx_res_crc_error <= 1'h0; // @[Sdc.scala 115:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_error <= _GEN_472;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_res_crc_error <= _GEN_1283;
      end else begin
        rx_res_crc_error <= _GEN_472;
      end
    end else begin
      rx_res_crc_error <= _GEN_472;
    end
    if (reset) begin // @[Sdc.scala 116:30]
      rx_res_crc_en <= 1'h0; // @[Sdc.scala 116:30]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          rx_res_crc_en <= _GEN_1284;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 117:29]
      rx_res_timer <= 8'h0; // @[Sdc.scala 117:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_timer <= _GEN_323;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_res_timer <= _GEN_1285;
      end else begin
        rx_res_timer <= _GEN_323;
      end
    end else begin
      rx_res_timer <= _GEN_323;
    end
    if (reset) begin // @[Sdc.scala 118:31]
      rx_res_timeout <= 1'h0; // @[Sdc.scala 118:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_res_timeout <= _GEN_327;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_res_timeout <= _GEN_1286;
      end else begin
        rx_res_timeout <= _GEN_327;
      end
    end else begin
      rx_res_timeout <= _GEN_327;
    end
    if (reset) begin // @[Sdc.scala 119:36]
      rx_res_read_counter <= 2'h0; // @[Sdc.scala 119:36]
    end else if (io_mem_ren) begin // @[Sdc.scala 602:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 604:19]
        rx_res_read_counter <= _GEN_1645;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 604:19]
        rx_res_read_counter <= _GEN_1645;
      end else begin
        rx_res_read_counter <= _GEN_1698;
      end
    end else begin
      rx_res_read_counter <= _GEN_1645;
    end
    if (reset) begin // @[Sdc.scala 120:27]
      tx_cmd_arg <= 32'h0; // @[Sdc.scala 120:27]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (!(2'h1 == addr)) begin // @[Sdc.scala 510:19]
          tx_cmd_arg <= _GEN_1335;
        end
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_0 <= _GEN_601;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_0 <= tx_cmd_val[47]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_0 <= _GEN_601;
        end
      end else begin
        tx_cmd_0 <= _GEN_601;
      end
    end else begin
      tx_cmd_0 <= _GEN_601;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_1 <= _GEN_602;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_1 <= tx_cmd_val[46]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_1 <= _GEN_602;
        end
      end else begin
        tx_cmd_1 <= _GEN_602;
      end
    end else begin
      tx_cmd_1 <= _GEN_602;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_2 <= _GEN_603;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_2 <= tx_cmd_val[45]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_2 <= _GEN_603;
        end
      end else begin
        tx_cmd_2 <= _GEN_603;
      end
    end else begin
      tx_cmd_2 <= _GEN_603;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_3 <= _GEN_604;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_3 <= tx_cmd_val[44]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_3 <= _GEN_604;
        end
      end else begin
        tx_cmd_3 <= _GEN_604;
      end
    end else begin
      tx_cmd_3 <= _GEN_604;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_4 <= _GEN_605;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_4 <= tx_cmd_val[43]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_4 <= _GEN_605;
        end
      end else begin
        tx_cmd_4 <= _GEN_605;
      end
    end else begin
      tx_cmd_4 <= _GEN_605;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_5 <= _GEN_606;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_5 <= tx_cmd_val[42]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_5 <= _GEN_606;
        end
      end else begin
        tx_cmd_5 <= _GEN_606;
      end
    end else begin
      tx_cmd_5 <= _GEN_606;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_6 <= _GEN_607;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_6 <= tx_cmd_val[41]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_6 <= _GEN_607;
        end
      end else begin
        tx_cmd_6 <= _GEN_607;
      end
    end else begin
      tx_cmd_6 <= _GEN_607;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_7 <= _GEN_608;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_7 <= tx_cmd_val[40]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_7 <= _GEN_608;
        end
      end else begin
        tx_cmd_7 <= _GEN_608;
      end
    end else begin
      tx_cmd_7 <= _GEN_608;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_8 <= _GEN_609;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_8 <= tx_cmd_val[39]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_8 <= _GEN_609;
        end
      end else begin
        tx_cmd_8 <= _GEN_609;
      end
    end else begin
      tx_cmd_8 <= _GEN_609;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_9 <= _GEN_610;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_9 <= tx_cmd_val[38]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_9 <= _GEN_610;
        end
      end else begin
        tx_cmd_9 <= _GEN_610;
      end
    end else begin
      tx_cmd_9 <= _GEN_610;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_10 <= _GEN_611;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_10 <= tx_cmd_val[37]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_10 <= _GEN_611;
        end
      end else begin
        tx_cmd_10 <= _GEN_611;
      end
    end else begin
      tx_cmd_10 <= _GEN_611;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_11 <= _GEN_612;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_11 <= tx_cmd_val[36]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_11 <= _GEN_612;
        end
      end else begin
        tx_cmd_11 <= _GEN_612;
      end
    end else begin
      tx_cmd_11 <= _GEN_612;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_12 <= _GEN_613;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_12 <= tx_cmd_val[35]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_12 <= _GEN_613;
        end
      end else begin
        tx_cmd_12 <= _GEN_613;
      end
    end else begin
      tx_cmd_12 <= _GEN_613;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_13 <= _GEN_614;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_13 <= tx_cmd_val[34]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_13 <= _GEN_614;
        end
      end else begin
        tx_cmd_13 <= _GEN_614;
      end
    end else begin
      tx_cmd_13 <= _GEN_614;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_14 <= _GEN_615;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_14 <= tx_cmd_val[33]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_14 <= _GEN_615;
        end
      end else begin
        tx_cmd_14 <= _GEN_615;
      end
    end else begin
      tx_cmd_14 <= _GEN_615;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_15 <= _GEN_616;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_15 <= tx_cmd_val[32]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_15 <= _GEN_616;
        end
      end else begin
        tx_cmd_15 <= _GEN_616;
      end
    end else begin
      tx_cmd_15 <= _GEN_616;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_16 <= _GEN_617;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_16 <= tx_cmd_val[31]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_16 <= _GEN_617;
        end
      end else begin
        tx_cmd_16 <= _GEN_617;
      end
    end else begin
      tx_cmd_16 <= _GEN_617;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_17 <= _GEN_618;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_17 <= tx_cmd_val[30]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_17 <= _GEN_618;
        end
      end else begin
        tx_cmd_17 <= _GEN_618;
      end
    end else begin
      tx_cmd_17 <= _GEN_618;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_18 <= _GEN_619;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_18 <= tx_cmd_val[29]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_18 <= _GEN_619;
        end
      end else begin
        tx_cmd_18 <= _GEN_619;
      end
    end else begin
      tx_cmd_18 <= _GEN_619;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_19 <= _GEN_620;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_19 <= tx_cmd_val[28]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_19 <= _GEN_620;
        end
      end else begin
        tx_cmd_19 <= _GEN_620;
      end
    end else begin
      tx_cmd_19 <= _GEN_620;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_20 <= _GEN_621;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_20 <= tx_cmd_val[27]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_20 <= _GEN_621;
        end
      end else begin
        tx_cmd_20 <= _GEN_621;
      end
    end else begin
      tx_cmd_20 <= _GEN_621;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_21 <= _GEN_622;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_21 <= tx_cmd_val[26]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_21 <= _GEN_622;
        end
      end else begin
        tx_cmd_21 <= _GEN_622;
      end
    end else begin
      tx_cmd_21 <= _GEN_622;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_22 <= _GEN_623;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_22 <= tx_cmd_val[25]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_22 <= _GEN_623;
        end
      end else begin
        tx_cmd_22 <= _GEN_623;
      end
    end else begin
      tx_cmd_22 <= _GEN_623;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_23 <= _GEN_624;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_23 <= tx_cmd_val[24]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_23 <= _GEN_624;
        end
      end else begin
        tx_cmd_23 <= _GEN_624;
      end
    end else begin
      tx_cmd_23 <= _GEN_624;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_24 <= _GEN_625;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_24 <= tx_cmd_val[23]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_24 <= _GEN_625;
        end
      end else begin
        tx_cmd_24 <= _GEN_625;
      end
    end else begin
      tx_cmd_24 <= _GEN_625;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_25 <= _GEN_626;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_25 <= tx_cmd_val[22]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_25 <= _GEN_626;
        end
      end else begin
        tx_cmd_25 <= _GEN_626;
      end
    end else begin
      tx_cmd_25 <= _GEN_626;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_26 <= _GEN_627;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_26 <= tx_cmd_val[21]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_26 <= _GEN_627;
        end
      end else begin
        tx_cmd_26 <= _GEN_627;
      end
    end else begin
      tx_cmd_26 <= _GEN_627;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_27 <= _GEN_628;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_27 <= tx_cmd_val[20]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_27 <= _GEN_628;
        end
      end else begin
        tx_cmd_27 <= _GEN_628;
      end
    end else begin
      tx_cmd_27 <= _GEN_628;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_28 <= _GEN_629;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_28 <= tx_cmd_val[19]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_28 <= _GEN_629;
        end
      end else begin
        tx_cmd_28 <= _GEN_629;
      end
    end else begin
      tx_cmd_28 <= _GEN_629;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_29 <= _GEN_630;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_29 <= tx_cmd_val[18]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_29 <= _GEN_630;
        end
      end else begin
        tx_cmd_29 <= _GEN_630;
      end
    end else begin
      tx_cmd_29 <= _GEN_630;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_30 <= _GEN_631;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_30 <= tx_cmd_val[17]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_30 <= _GEN_631;
        end
      end else begin
        tx_cmd_30 <= _GEN_631;
      end
    end else begin
      tx_cmd_30 <= _GEN_631;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_31 <= _GEN_632;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_31 <= tx_cmd_val[16]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_31 <= _GEN_632;
        end
      end else begin
        tx_cmd_31 <= _GEN_632;
      end
    end else begin
      tx_cmd_31 <= _GEN_632;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_32 <= _GEN_633;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_32 <= tx_cmd_val[15]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_32 <= _GEN_633;
        end
      end else begin
        tx_cmd_32 <= _GEN_633;
      end
    end else begin
      tx_cmd_32 <= _GEN_633;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_33 <= _GEN_634;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_33 <= tx_cmd_val[14]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_33 <= _GEN_634;
        end
      end else begin
        tx_cmd_33 <= _GEN_634;
      end
    end else begin
      tx_cmd_33 <= _GEN_634;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_34 <= _GEN_635;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_34 <= tx_cmd_val[13]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_34 <= _GEN_635;
        end
      end else begin
        tx_cmd_34 <= _GEN_635;
      end
    end else begin
      tx_cmd_34 <= _GEN_635;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_35 <= _GEN_636;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_35 <= tx_cmd_val[12]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_35 <= _GEN_636;
        end
      end else begin
        tx_cmd_35 <= _GEN_636;
      end
    end else begin
      tx_cmd_35 <= _GEN_636;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_36 <= _GEN_637;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_36 <= tx_cmd_val[11]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_36 <= _GEN_637;
        end
      end else begin
        tx_cmd_36 <= _GEN_637;
      end
    end else begin
      tx_cmd_36 <= _GEN_637;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_37 <= _GEN_638;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_37 <= tx_cmd_val[10]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_37 <= _GEN_638;
        end
      end else begin
        tx_cmd_37 <= _GEN_638;
      end
    end else begin
      tx_cmd_37 <= _GEN_638;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_38 <= _GEN_639;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_38 <= tx_cmd_val[9]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_38 <= _GEN_639;
        end
      end else begin
        tx_cmd_38 <= _GEN_639;
      end
    end else begin
      tx_cmd_38 <= _GEN_639;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_39 <= _GEN_640;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_39 <= tx_cmd_val[8]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_39 <= _GEN_640;
        end
      end else begin
        tx_cmd_39 <= _GEN_640;
      end
    end else begin
      tx_cmd_39 <= _GEN_640;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_40 <= _GEN_641;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_40 <= tx_cmd_val[7]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_40 <= _GEN_641;
        end
      end else begin
        tx_cmd_40 <= _GEN_641;
      end
    end else begin
      tx_cmd_40 <= _GEN_641;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_41 <= _GEN_642;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_41 <= tx_cmd_val[6]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_41 <= _GEN_642;
        end
      end else begin
        tx_cmd_41 <= _GEN_642;
      end
    end else begin
      tx_cmd_41 <= _GEN_642;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_42 <= _GEN_643;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_42 <= tx_cmd_val[5]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_42 <= _GEN_643;
        end
      end else begin
        tx_cmd_42 <= _GEN_643;
      end
    end else begin
      tx_cmd_42 <= _GEN_643;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_43 <= _GEN_644;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_43 <= tx_cmd_val[4]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_43 <= _GEN_644;
        end
      end else begin
        tx_cmd_43 <= _GEN_644;
      end
    end else begin
      tx_cmd_43 <= _GEN_644;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_44 <= _GEN_645;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_44 <= tx_cmd_val[3]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_44 <= _GEN_645;
        end
      end else begin
        tx_cmd_44 <= _GEN_645;
      end
    end else begin
      tx_cmd_44 <= _GEN_645;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_45 <= _GEN_646;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_45 <= tx_cmd_val[2]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_45 <= _GEN_646;
        end
      end else begin
        tx_cmd_45 <= _GEN_646;
      end
    end else begin
      tx_cmd_45 <= _GEN_646;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_46 <= _GEN_647;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_46 <= tx_cmd_val[1]; // @[Sdc.scala 526:18]
        end else begin
          tx_cmd_46 <= _GEN_647;
        end
      end else begin
        tx_cmd_46 <= _GEN_647;
      end
    end else begin
      tx_cmd_46 <= _GEN_647;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
            tx_cmd_47 <= tx_cmd_val[0]; // @[Sdc.scala 526:18]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 122:31]
      tx_cmd_counter <= 6'h0; // @[Sdc.scala 122:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_counter <= _GEN_648;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_counter <= _GEN_1265;
      end else begin
        tx_cmd_counter <= _GEN_648;
      end
    end else begin
      tx_cmd_counter <= _GEN_648;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_0 <= _GEN_649;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_0 <= tx_cmd_val[41]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_0 <= _GEN_649;
        end
      end else begin
        tx_cmd_crc_0 <= _GEN_649;
      end
    end else begin
      tx_cmd_crc_0 <= _GEN_649;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_1 <= _GEN_650;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_1 <= tx_cmd_val[42]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_1 <= _GEN_650;
        end
      end else begin
        tx_cmd_crc_1 <= _GEN_650;
      end
    end else begin
      tx_cmd_crc_1 <= _GEN_650;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_2 <= _GEN_651;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_2 <= tx_cmd_val[43]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_2 <= _GEN_651;
        end
      end else begin
        tx_cmd_crc_2 <= _GEN_651;
      end
    end else begin
      tx_cmd_crc_2 <= _GEN_651;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_3 <= _GEN_652;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_3 <= tx_cmd_val[44]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_3 <= _GEN_652;
        end
      end else begin
        tx_cmd_crc_3 <= _GEN_652;
      end
    end else begin
      tx_cmd_crc_3 <= _GEN_652;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_4 <= _GEN_653;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_4 <= tx_cmd_val[45]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_4 <= _GEN_653;
        end
      end else begin
        tx_cmd_crc_4 <= _GEN_653;
      end
    end else begin
      tx_cmd_crc_4 <= _GEN_653;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_5 <= _GEN_654;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_5 <= tx_cmd_val[46]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_5 <= _GEN_654;
        end
      end else begin
        tx_cmd_crc_5 <= _GEN_654;
      end
    end else begin
      tx_cmd_crc_5 <= _GEN_654;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_cmd_crc_6 <= _GEN_655;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          tx_cmd_crc_6 <= tx_cmd_val[47]; // @[Sdc.scala 528:22]
        end else begin
          tx_cmd_crc_6 <= _GEN_655;
        end
      end else begin
        tx_cmd_crc_6 <= _GEN_655;
      end
    end else begin
      tx_cmd_crc_6 <= _GEN_655;
    end
    if (reset) begin // @[Sdc.scala 124:29]
      tx_cmd_timer <= 6'h0; // @[Sdc.scala 124:29]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 215:69]
      tx_cmd_timer <= _tx_cmd_timer_T_1; // @[Sdc.scala 216:18]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 171:57]
      if (_T & reg_clk) begin // @[Sdc.scala 173:47]
        tx_cmd_timer <= _GEN_169;
      end
    end
    if (reset) begin // @[Sdc.scala 125:31]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 125:31]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 215:69]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 217:20]
    end else if (rx_busy_timer != 19'h0 & _T & reg_clk) begin // @[Sdc.scala 219:76]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 220:20]
    end else begin
      reg_tx_cmd_wrt <= _GEN_484;
    end
    if (reset) begin // @[Sdc.scala 126:31]
      reg_tx_cmd_out <= 1'h0; // @[Sdc.scala 126:31]
    end else if (tx_cmd_counter > 6'h0 & _T & reg_clk) begin // @[Sdc.scala 222:75]
      reg_tx_cmd_out <= tx_cmd_0; // @[Sdc.scala 224:20]
    end
    if (reset) begin // @[Sdc.scala 127:35]
      rx_dat_in_progress <= 1'h0; // @[Sdc.scala 127:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_in_progress <= _GEN_839;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_in_progress <= _GEN_1289;
      end else begin
        rx_dat_in_progress <= _GEN_839;
      end
    end else begin
      rx_dat_in_progress <= _GEN_839;
    end
    if (reset) begin // @[Sdc.scala 128:31]
      rx_dat_counter <= 11'h0; // @[Sdc.scala 128:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_counter <= _GEN_833;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_counter <= _GEN_1290;
      end else begin
        rx_dat_counter <= _GEN_833;
      end
    end else begin
      rx_dat_counter <= _GEN_833;
    end
    if (reset) begin // @[Sdc.scala 129:33]
      rx_dat_start_bit <= 1'h0; // @[Sdc.scala 129:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_start_bit <= _GEN_864;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_start_bit <= _GEN_1291;
      end else begin
        rx_dat_start_bit <= _GEN_864;
      end
    end else begin
      rx_dat_start_bit <= _GEN_864;
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_0 <= rx_dat_next; // @[Sdc.scala 287:24]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_1 <= rx_dat_bits_0; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_2 <= rx_dat_bits_1; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_3 <= rx_dat_bits_2; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_4 <= rx_dat_bits_3; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_5 <= rx_dat_bits_4; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_6 <= rx_dat_bits_5; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      if (_T_5) begin // @[Sdc.scala 272:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 273:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 283:66]
            rx_dat_bits_7 <= rx_dat_bits_6; // @[Sdc.scala 286:50]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 131:28]
      rx_dat_next <= 4'h0; // @[Sdc.scala 131:28]
    end else if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 270:57]
      rx_dat_next <= io_sdc_port_dat_in; // @[Sdc.scala 271:17]
    end
    if (reset) begin // @[Sdc.scala 132:34]
      rx_dat_continuous <= 1'h0; // @[Sdc.scala 132:34]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          rx_dat_continuous <= _GEN_1312;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 133:29]
      rx_dat_ready <= 1'h0; // @[Sdc.scala 133:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 602:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 604:19]
        rx_dat_ready <= _GEN_1650;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 604:19]
        rx_dat_ready <= _GEN_1650;
      end else begin
        rx_dat_ready <= _GEN_1704;
      end
    end else begin
      rx_dat_ready <= _GEN_1650;
    end
    if (reset) begin // @[Sdc.scala 134:31]
      rx_dat_intr_en <= 1'h0; // @[Sdc.scala 134:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_intr_en <= io_mem_wdata[17]; // @[Sdc.scala 519:26]
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_0 <= _GEN_848;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_0 <= _GEN_1184;
        end else begin
          rx_dat_crc_0 <= _GEN_848;
        end
      end else begin
        rx_dat_crc_0 <= _GEN_848;
      end
    end else begin
      rx_dat_crc_0 <= _GEN_848;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_1 <= _GEN_849;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_1 <= _GEN_1185;
        end else begin
          rx_dat_crc_1 <= _GEN_849;
        end
      end else begin
        rx_dat_crc_1 <= _GEN_849;
      end
    end else begin
      rx_dat_crc_1 <= _GEN_849;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_2 <= _GEN_850;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_2 <= _GEN_1186;
        end else begin
          rx_dat_crc_2 <= _GEN_850;
        end
      end else begin
        rx_dat_crc_2 <= _GEN_850;
      end
    end else begin
      rx_dat_crc_2 <= _GEN_850;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_3 <= _GEN_851;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_3 <= _GEN_1187;
        end else begin
          rx_dat_crc_3 <= _GEN_851;
        end
      end else begin
        rx_dat_crc_3 <= _GEN_851;
      end
    end else begin
      rx_dat_crc_3 <= _GEN_851;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_4 <= _GEN_852;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_4 <= _GEN_1188;
        end else begin
          rx_dat_crc_4 <= _GEN_852;
        end
      end else begin
        rx_dat_crc_4 <= _GEN_852;
      end
    end else begin
      rx_dat_crc_4 <= _GEN_852;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_5 <= _GEN_853;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_5 <= _GEN_1189;
        end else begin
          rx_dat_crc_5 <= _GEN_853;
        end
      end else begin
        rx_dat_crc_5 <= _GEN_853;
      end
    end else begin
      rx_dat_crc_5 <= _GEN_853;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_6 <= _GEN_854;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_6 <= _GEN_1190;
        end else begin
          rx_dat_crc_6 <= _GEN_854;
        end
      end else begin
        rx_dat_crc_6 <= _GEN_854;
      end
    end else begin
      rx_dat_crc_6 <= _GEN_854;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_7 <= _GEN_855;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_7 <= _GEN_1191;
        end else begin
          rx_dat_crc_7 <= _GEN_855;
        end
      end else begin
        rx_dat_crc_7 <= _GEN_855;
      end
    end else begin
      rx_dat_crc_7 <= _GEN_855;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_8 <= _GEN_856;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_8 <= _GEN_1192;
        end else begin
          rx_dat_crc_8 <= _GEN_856;
        end
      end else begin
        rx_dat_crc_8 <= _GEN_856;
      end
    end else begin
      rx_dat_crc_8 <= _GEN_856;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_9 <= _GEN_857;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_9 <= _GEN_1193;
        end else begin
          rx_dat_crc_9 <= _GEN_857;
        end
      end else begin
        rx_dat_crc_9 <= _GEN_857;
      end
    end else begin
      rx_dat_crc_9 <= _GEN_857;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_10 <= _GEN_858;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_10 <= _GEN_1194;
        end else begin
          rx_dat_crc_10 <= _GEN_858;
        end
      end else begin
        rx_dat_crc_10 <= _GEN_858;
      end
    end else begin
      rx_dat_crc_10 <= _GEN_858;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_11 <= _GEN_859;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_11 <= _GEN_1195;
        end else begin
          rx_dat_crc_11 <= _GEN_859;
        end
      end else begin
        rx_dat_crc_11 <= _GEN_859;
      end
    end else begin
      rx_dat_crc_11 <= _GEN_859;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_12 <= _GEN_860;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_12 <= _GEN_1196;
        end else begin
          rx_dat_crc_12 <= _GEN_860;
        end
      end else begin
        rx_dat_crc_12 <= _GEN_860;
      end
    end else begin
      rx_dat_crc_12 <= _GEN_860;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_13 <= _GEN_861;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_13 <= _GEN_1197;
        end else begin
          rx_dat_crc_13 <= _GEN_861;
        end
      end else begin
        rx_dat_crc_13 <= _GEN_861;
      end
    end else begin
      rx_dat_crc_13 <= _GEN_861;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_14 <= _GEN_862;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_14 <= _GEN_1198;
        end else begin
          rx_dat_crc_14 <= _GEN_862;
        end
      end else begin
        rx_dat_crc_14 <= _GEN_862;
      end
    end else begin
      rx_dat_crc_14 <= _GEN_862;
    end
    if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_15 <= _GEN_863;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 524:40]
          rx_dat_crc_15 <= _GEN_1199;
        end else begin
          rx_dat_crc_15 <= _GEN_863;
        end
      end else begin
        rx_dat_crc_15 <= _GEN_863;
      end
    end else begin
      rx_dat_crc_15 <= _GEN_863;
    end
    if (reset) begin // @[Sdc.scala 136:33]
      rx_dat_crc_error <= 1'h0; // @[Sdc.scala 136:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_error <= _GEN_868;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_crc_error <= _GEN_1309;
      end else begin
        rx_dat_crc_error <= _GEN_868;
      end
    end else begin
      rx_dat_crc_error <= _GEN_868;
    end
    if (reset) begin // @[Sdc.scala 137:29]
      rx_dat_timer <= 19'h0; // @[Sdc.scala 137:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_timer <= _GEN_832;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_timer <= _GEN_1310;
      end else begin
        rx_dat_timer <= _GEN_832;
      end
    end else begin
      rx_dat_timer <= _GEN_832;
    end
    if (reset) begin // @[Sdc.scala 138:31]
      rx_dat_timeout <= 1'h0; // @[Sdc.scala 138:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_timeout <= _GEN_835;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_timeout <= _GEN_1311;
      end else begin
        rx_dat_timeout <= _GEN_835;
      end
    end else begin
      rx_dat_timeout <= _GEN_835;
    end
    if (reset) begin // @[Sdc.scala 139:31]
      rx_dat_overrun <= 1'h0; // @[Sdc.scala 139:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_overrun <= _GEN_869;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rx_dat_overrun <= _GEN_1313;
      end else begin
        rx_dat_overrun <= _GEN_869;
      end
    end else begin
      rx_dat_overrun <= _GEN_869;
    end
    if (reset) begin // @[Sdc.scala 141:33]
      rxtx_dat_counter <= 8'h0; // @[Sdc.scala 141:33]
    end else if (io_mem_ren) begin // @[Sdc.scala 602:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 604:19]
        rxtx_dat_counter <= _GEN_1673;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 604:19]
        rxtx_dat_counter <= _GEN_1673;
      end else begin
        rxtx_dat_counter <= _GEN_1701;
      end
    end else begin
      rxtx_dat_counter <= _GEN_1673;
    end
    if (reset) begin // @[Sdc.scala 142:31]
      rxtx_dat_index <= 8'h0; // @[Sdc.scala 142:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        rxtx_dat_index <= _GEN_1163;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        rxtx_dat_index <= _GEN_1314;
      end else begin
        rxtx_dat_index <= _GEN_1163;
      end
    end else begin
      rxtx_dat_index <= _GEN_1163;
    end
    if (reset) begin // @[Sdc.scala 143:30]
      rx_busy_timer <= 19'h0; // @[Sdc.scala 143:30]
    end else if (_T_20) begin // @[Sdc.scala 405:70]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
      rx_busy_timer <= _GEN_962;
    end else begin
      rx_busy_timer <= _GEN_924;
    end
    if (reset) begin // @[Sdc.scala 144:36]
      rx_busy_in_progress <= 1'h0; // @[Sdc.scala 144:36]
    end else if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 362:30]
      if (_T_5) begin // @[Sdc.scala 364:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 368:51]
          rx_busy_in_progress <= _GEN_898;
        end
      end
    end
    rx_dat0_next <= reset | _GEN_923; // @[Sdc.scala 145:{29,29}]
    if (reset) begin // @[Sdc.scala 146:32]
      rx_dat_buf_read <= 1'h0; // @[Sdc.scala 146:32]
    end else if (io_mem_ren) begin // @[Sdc.scala 602:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 604:19]
        rx_dat_buf_read <= _GEN_837;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 604:19]
        rx_dat_buf_read <= _GEN_837;
      end else begin
        rx_dat_buf_read <= _GEN_1703;
      end
    end else begin
      rx_dat_buf_read <= _GEN_837;
    end
    if (reset) begin // @[Sdc.scala 147:33]
      rx_dat_buf_cache <= 32'h0; // @[Sdc.scala 147:33]
    end else if (rx_dat_buf_read) begin // @[Sdc.scala 261:26]
      rx_dat_buf_cache <= io_sdbuf_rdata2; // @[Sdc.scala 262:22]
    end
    if (reset) begin // @[Sdc.scala 148:31]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 148:31]
    end else if (_T_20) begin // @[Sdc.scala 405:70]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 406:20]
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 410:20]
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
      reg_tx_dat_wrt <= _GEN_960;
    end
    reg_tx_dat_out <= _GEN_1727[0]; // @[Sdc.scala 149:{31,31}]
    if (reset) begin // @[Sdc.scala 150:33]
      tx_empty_intr_en <= 1'h0; // @[Sdc.scala 150:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_empty_intr_en <= io_mem_wdata[18]; // @[Sdc.scala 520:26]
      end
    end
    if (reset) begin // @[Sdc.scala 151:31]
      tx_end_intr_en <= 1'h0; // @[Sdc.scala 151:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_end_intr_en <= io_mem_wdata[19]; // @[Sdc.scala 521:26]
      end
    end
    if (reset) begin // @[Sdc.scala 152:31]
      tx_dat_counter <= 11'h0; // @[Sdc.scala 152:31]
    end else if (_T_20) begin // @[Sdc.scala 405:70]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
      tx_dat_counter <= _tx_dat_counter_T_1; // @[Sdc.scala 416:20]
    end else begin
      tx_dat_counter <= _GEN_870;
    end
    tx_dat_timer <= _GEN_1728[5:0]; // @[Sdc.scala 153:{29,29}]
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_0 <= _GEN_1066;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_0 <= 4'h0; // @[Sdc.scala 475:17]
    end else begin
      tx_dat_0 <= _GEN_1066;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_1 <= _GEN_1067;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_1 <= tx_dat_prepared[7:4]; // @[Sdc.scala 476:17]
    end else begin
      tx_dat_1 <= _GEN_1067;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_2 <= _GEN_1068;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_2 <= tx_dat_prepared[3:0]; // @[Sdc.scala 477:17]
    end else begin
      tx_dat_2 <= _GEN_1068;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_3 <= _GEN_1069;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_3 <= tx_dat_prepared[15:12]; // @[Sdc.scala 478:17]
    end else begin
      tx_dat_3 <= _GEN_1069;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_4 <= _GEN_1070;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_4 <= tx_dat_prepared[11:8]; // @[Sdc.scala 479:17]
    end else begin
      tx_dat_4 <= _GEN_1070;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_5 <= _GEN_1071;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_5 <= tx_dat_prepared[23:20]; // @[Sdc.scala 480:17]
    end else begin
      tx_dat_5 <= _GEN_1071;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_6 <= _GEN_1072;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_6 <= tx_dat_prepared[19:16]; // @[Sdc.scala 481:17]
    end else begin
      tx_dat_6 <= _GEN_1072;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_7 <= _GEN_1073;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_7 <= tx_dat_prepared[31:28]; // @[Sdc.scala 482:17]
    end else begin
      tx_dat_7 <= _GEN_1073;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_8 <= _GEN_1074;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_8 <= tx_dat_prepared[27:24]; // @[Sdc.scala 483:17]
    end else begin
      tx_dat_8 <= _GEN_1074;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_9 <= tx_dat_prepared[7:4]; // @[Sdc.scala 491:18]
    end else begin
      tx_dat_9 <= _GEN_1075;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_10 <= tx_dat_prepared[3:0]; // @[Sdc.scala 492:18]
    end else begin
      tx_dat_10 <= _GEN_1076;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_11 <= tx_dat_prepared[15:12]; // @[Sdc.scala 493:18]
    end else begin
      tx_dat_11 <= _GEN_1077;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_12 <= tx_dat_prepared[11:8]; // @[Sdc.scala 494:18]
    end else begin
      tx_dat_12 <= _GEN_1078;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_13 <= tx_dat_prepared[23:20]; // @[Sdc.scala 495:18]
    end else begin
      tx_dat_13 <= _GEN_1079;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_14 <= tx_dat_prepared[19:16]; // @[Sdc.scala 496:18]
    end else begin
      tx_dat_14 <= _GEN_1080;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_15 <= tx_dat_prepared[31:28]; // @[Sdc.scala 497:18]
    end else begin
      tx_dat_15 <= _GEN_1081;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_16 <= tx_dat_prepared[7:4]; // @[Sdc.scala 464:18]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_16 <= _GEN_1082;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_16 <= tx_dat_prepared[27:24]; // @[Sdc.scala 498:18]
    end else begin
      tx_dat_16 <= _GEN_1082;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_17 <= tx_dat_prepared[3:0]; // @[Sdc.scala 465:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_17 <= tx_dat_18; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_18 <= tx_dat_prepared[15:12]; // @[Sdc.scala 466:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_18 <= tx_dat_19; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_19 <= tx_dat_prepared[11:8]; // @[Sdc.scala 467:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_19 <= tx_dat_20; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_20 <= tx_dat_prepared[23:20]; // @[Sdc.scala 468:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_20 <= tx_dat_21; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_21 <= tx_dat_prepared[19:16]; // @[Sdc.scala 469:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_21 <= tx_dat_22; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_22 <= tx_dat_prepared[31:28]; // @[Sdc.scala 470:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_22 <= tx_dat_23; // @[Sdc.scala 415:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_23 <= tx_dat_prepared[27:24]; // @[Sdc.scala 471:18]
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_0 <= crc_1_0; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_1 <= tx_dat_crc_0; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_2 <= tx_dat_crc_1; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_3 <= tx_dat_crc_2; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_4 <= tx_dat_crc_3; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_5 <= crc_1_5; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_6 <= tx_dat_crc_5; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_7 <= tx_dat_crc_6; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_8 <= tx_dat_crc_7; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_9 <= tx_dat_crc_8; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_10 <= tx_dat_crc_9; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_11 <= tx_dat_crc_10; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_12 <= crc_1_12; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_13 <= tx_dat_crc_12; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_14 <= tx_dat_crc_13; // @[Sdc.scala 436:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 405:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 408:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
          tx_dat_crc_15 <= tx_dat_crc_14; // @[Sdc.scala 436:16]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 156:32]
      tx_dat_prepared <= 32'h0; // @[Sdc.scala 156:32]
    end else if (_T_20) begin // @[Sdc.scala 405:70]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
      tx_dat_prepared <= _GEN_942;
    end else begin
      tx_dat_prepared <= _GEN_658;
    end
    if (reset) begin // @[Sdc.scala 157:37]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 157:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 472:28]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_prepare_state <= 2'h3; // @[Sdc.scala 488:28]
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 499:28]
    end else begin
      tx_dat_prepare_state <= _GEN_1109;
    end
    if (reset) begin // @[Sdc.scala 158:31]
      tx_dat_started <= 1'h0; // @[Sdc.scala 158:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          tx_dat_started <= _GEN_1316;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 160:35]
      tx_dat_in_progress <= 1'h0; // @[Sdc.scala 160:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_in_progress <= _GEN_879;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_in_progress <= _GEN_1322;
      end else begin
        tx_dat_in_progress <= _GEN_879;
      end
    end else begin
      tx_dat_in_progress <= _GEN_879;
    end
    if (reset) begin // @[Sdc.scala 161:27]
      tx_dat_end <= 1'h0; // @[Sdc.scala 161:27]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_end <= _GEN_935;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_end <= _GEN_1323;
      end else begin
        tx_dat_end <= _GEN_935;
      end
    end else begin
      tx_dat_end <= _GEN_935;
    end
    if (reset) begin // @[Sdc.scala 162:32]
      tx_dat_read_sel <= 2'h0; // @[Sdc.scala 162:32]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_read_sel <= _GEN_932;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_read_sel <= _GEN_1318;
      end else begin
        tx_dat_read_sel <= _GEN_932;
      end
    end else begin
      tx_dat_read_sel <= _GEN_932;
    end
    if (reset) begin // @[Sdc.scala 163:33]
      tx_dat_write_sel <= 2'h0; // @[Sdc.scala 163:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 510:19]
        if (2'h1 == addr) begin // @[Sdc.scala 510:19]
          tx_dat_write_sel <= _GEN_1319;
        end else begin
          tx_dat_write_sel <= _GEN_1339;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 164:40]
      tx_dat_read_sel_changed <= 1'h0; // @[Sdc.scala 164:40]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_read_sel_changed <= _GEN_933;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_read_sel_changed <= _GEN_1320;
      end else begin
        tx_dat_read_sel_changed <= _GEN_933;
      end
    end else begin
      tx_dat_read_sel_changed <= _GEN_933;
    end
    if (reset) begin // @[Sdc.scala 165:37]
      tx_dat_write_sel_new <= 1'h0; // @[Sdc.scala 165:37]
    end else if (io_mem_wen) begin // @[Sdc.scala 508:21]
      if (2'h0 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_write_sel_new <= _GEN_877;
      end else if (2'h1 == addr) begin // @[Sdc.scala 510:19]
        tx_dat_write_sel_new <= _GEN_1321;
      end else begin
        tx_dat_write_sel_new <= _GEN_1340;
      end
    end else begin
      tx_dat_write_sel_new <= _GEN_877;
    end
    if (reset) begin // @[Sdc.scala 166:42]
      tx_dat_crc_status_counter <= 4'h0; // @[Sdc.scala 166:42]
    end else if (_T_20) begin // @[Sdc.scala 405:70]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 412:77]
      tx_dat_crc_status_counter <= _GEN_963;
    end else begin
      tx_dat_crc_status_counter <= _GEN_929;
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 362:30]
      if (_T_5) begin // @[Sdc.scala 364:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 368:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 370:48]
            tx_dat_crc_status_b_0 <= rx_dat0_next; // @[Sdc.scala 372:34]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 362:30]
      if (_T_5) begin // @[Sdc.scala 364:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 368:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 370:48]
            tx_dat_crc_status_b_1 <= tx_dat_crc_status_b_0; // @[Sdc.scala 371:84]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 362:30]
      if (_T_5) begin // @[Sdc.scala 364:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 368:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 370:48]
            tx_dat_crc_status_b_2 <= tx_dat_crc_status_b_1; // @[Sdc.scala 371:84]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 168:34]
      tx_dat_crc_status <= 2'h0; // @[Sdc.scala 168:34]
    end else if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 362:30]
      if (_T_5) begin // @[Sdc.scala 364:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 368:51]
          tx_dat_crc_status <= _GEN_894;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 169:37]
      tx_dat_prepared_read <= 1'h0; // @[Sdc.scala 169:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 462:33]
      if (_T_20) begin // @[Sdc.scala 405:70]
        tx_dat_prepared_read <= _GEN_872;
      end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 408:75]
        tx_dat_prepared_read <= _GEN_872;
      end else begin
        tx_dat_prepared_read <= _GEN_1007;
      end
    end else begin
      tx_dat_prepared_read <= _GEN_1132;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"sdc.clk           : 0x%x\n",reg_clk); // @[Sdc.scala 666:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"sdc.cmd_wrt       : 0x%x\n",io_sdc_port_cmd_wrt); // @[Sdc.scala 667:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"sdc.cmd_out       : 0x%x\n",io_sdc_port_cmd_out); // @[Sdc.scala 668:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"rx_res_counter    : 0x%x\n",rx_res_counter); // @[Sdc.scala 669:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"rx_dat_counter    : 0x%x\n",rx_dat_counter); // @[Sdc.scala 670:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"rx_dat_next       : 0x%x\n",rx_dat_next); // @[Sdc.scala 671:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_cmd_counter    : 0x%x\n",tx_cmd_counter); // @[Sdc.scala 672:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_dat_counter    : 0x%x\n",tx_dat_counter); // @[Sdc.scala 673:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_cmd_timer      : 0x%x\n",tx_cmd_timer); // @[Sdc.scala 674:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"rx_busy_timer     : 0x%x\n",rx_busy_timer); // @[Sdc.scala 675:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_dat_read_sel   : 0x%x\n",tx_dat_read_sel); // @[Sdc.scala 676:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_dat_write_sel  : 0x%x\n",tx_dat_write_sel); // @[Sdc.scala 677:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_dat_started    : %d\n",tx_dat_started); // @[Sdc.scala 678:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_198) begin
          $fwrite(32'h80000002,"tx_dat_in_progress: %d\n",tx_dat_in_progress); // @[Sdc.scala 679:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_power = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  reg_baud_divider = _RAND_1[8:0];
  _RAND_2 = {1{`RANDOM}};
  reg_clk_counter = _RAND_2[8:0];
  _RAND_3 = {1{`RANDOM}};
  reg_clk = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  intr = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  rx_res_in_progress = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  rx_res_counter = _RAND_6[7:0];
  _RAND_7 = {1{`RANDOM}};
  rx_res_bits_0 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  rx_res_bits_1 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  rx_res_bits_2 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  rx_res_bits_3 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  rx_res_bits_4 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  rx_res_bits_5 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  rx_res_bits_6 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  rx_res_bits_7 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  rx_res_bits_8 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  rx_res_bits_9 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  rx_res_bits_10 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  rx_res_bits_11 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  rx_res_bits_12 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  rx_res_bits_13 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  rx_res_bits_14 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  rx_res_bits_15 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  rx_res_bits_16 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rx_res_bits_17 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  rx_res_bits_18 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  rx_res_bits_19 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  rx_res_bits_20 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  rx_res_bits_21 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  rx_res_bits_22 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  rx_res_bits_23 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  rx_res_bits_24 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  rx_res_bits_25 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  rx_res_bits_26 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  rx_res_bits_27 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  rx_res_bits_28 = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  rx_res_bits_29 = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  rx_res_bits_30 = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  rx_res_bits_31 = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  rx_res_bits_32 = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  rx_res_bits_33 = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  rx_res_bits_34 = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  rx_res_bits_35 = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  rx_res_bits_36 = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  rx_res_bits_37 = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  rx_res_bits_38 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  rx_res_bits_39 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  rx_res_bits_40 = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  rx_res_bits_41 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  rx_res_bits_42 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  rx_res_bits_43 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  rx_res_bits_44 = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  rx_res_bits_45 = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  rx_res_bits_46 = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  rx_res_bits_47 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  rx_res_bits_48 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  rx_res_bits_49 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  rx_res_bits_50 = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  rx_res_bits_51 = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  rx_res_bits_52 = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  rx_res_bits_53 = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  rx_res_bits_54 = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  rx_res_bits_55 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  rx_res_bits_56 = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  rx_res_bits_57 = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  rx_res_bits_58 = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  rx_res_bits_59 = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  rx_res_bits_60 = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  rx_res_bits_61 = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  rx_res_bits_62 = _RAND_69[0:0];
  _RAND_70 = {1{`RANDOM}};
  rx_res_bits_63 = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  rx_res_bits_64 = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  rx_res_bits_65 = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  rx_res_bits_66 = _RAND_73[0:0];
  _RAND_74 = {1{`RANDOM}};
  rx_res_bits_67 = _RAND_74[0:0];
  _RAND_75 = {1{`RANDOM}};
  rx_res_bits_68 = _RAND_75[0:0];
  _RAND_76 = {1{`RANDOM}};
  rx_res_bits_69 = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  rx_res_bits_70 = _RAND_77[0:0];
  _RAND_78 = {1{`RANDOM}};
  rx_res_bits_71 = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  rx_res_bits_72 = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  rx_res_bits_73 = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  rx_res_bits_74 = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  rx_res_bits_75 = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  rx_res_bits_76 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  rx_res_bits_77 = _RAND_84[0:0];
  _RAND_85 = {1{`RANDOM}};
  rx_res_bits_78 = _RAND_85[0:0];
  _RAND_86 = {1{`RANDOM}};
  rx_res_bits_79 = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  rx_res_bits_80 = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  rx_res_bits_81 = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  rx_res_bits_82 = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  rx_res_bits_83 = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  rx_res_bits_84 = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  rx_res_bits_85 = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  rx_res_bits_86 = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  rx_res_bits_87 = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  rx_res_bits_88 = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  rx_res_bits_89 = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  rx_res_bits_90 = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  rx_res_bits_91 = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  rx_res_bits_92 = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  rx_res_bits_93 = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  rx_res_bits_94 = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  rx_res_bits_95 = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  rx_res_bits_96 = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  rx_res_bits_97 = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  rx_res_bits_98 = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  rx_res_bits_99 = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  rx_res_bits_100 = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  rx_res_bits_101 = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  rx_res_bits_102 = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  rx_res_bits_103 = _RAND_110[0:0];
  _RAND_111 = {1{`RANDOM}};
  rx_res_bits_104 = _RAND_111[0:0];
  _RAND_112 = {1{`RANDOM}};
  rx_res_bits_105 = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  rx_res_bits_106 = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  rx_res_bits_107 = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  rx_res_bits_108 = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  rx_res_bits_109 = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  rx_res_bits_110 = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  rx_res_bits_111 = _RAND_118[0:0];
  _RAND_119 = {1{`RANDOM}};
  rx_res_bits_112 = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  rx_res_bits_113 = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  rx_res_bits_114 = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  rx_res_bits_115 = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  rx_res_bits_116 = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  rx_res_bits_117 = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  rx_res_bits_118 = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  rx_res_bits_119 = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  rx_res_bits_120 = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  rx_res_bits_121 = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  rx_res_bits_122 = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  rx_res_bits_123 = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  rx_res_bits_124 = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  rx_res_bits_125 = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  rx_res_bits_126 = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  rx_res_bits_127 = _RAND_134[0:0];
  _RAND_135 = {1{`RANDOM}};
  rx_res_bits_128 = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  rx_res_bits_129 = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  rx_res_bits_130 = _RAND_137[0:0];
  _RAND_138 = {1{`RANDOM}};
  rx_res_bits_131 = _RAND_138[0:0];
  _RAND_139 = {1{`RANDOM}};
  rx_res_bits_132 = _RAND_139[0:0];
  _RAND_140 = {1{`RANDOM}};
  rx_res_bits_133 = _RAND_140[0:0];
  _RAND_141 = {1{`RANDOM}};
  rx_res_bits_134 = _RAND_141[0:0];
  _RAND_142 = {1{`RANDOM}};
  rx_res_bits_135 = _RAND_142[0:0];
  _RAND_143 = {1{`RANDOM}};
  rx_res_next = _RAND_143[0:0];
  _RAND_144 = {1{`RANDOM}};
  rx_res_type = _RAND_144[3:0];
  _RAND_145 = {5{`RANDOM}};
  rx_res = _RAND_145[135:0];
  _RAND_146 = {1{`RANDOM}};
  rx_res_ready = _RAND_146[0:0];
  _RAND_147 = {1{`RANDOM}};
  rx_res_intr_en = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  rx_res_crc_0 = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  rx_res_crc_1 = _RAND_149[0:0];
  _RAND_150 = {1{`RANDOM}};
  rx_res_crc_2 = _RAND_150[0:0];
  _RAND_151 = {1{`RANDOM}};
  rx_res_crc_3 = _RAND_151[0:0];
  _RAND_152 = {1{`RANDOM}};
  rx_res_crc_4 = _RAND_152[0:0];
  _RAND_153 = {1{`RANDOM}};
  rx_res_crc_5 = _RAND_153[0:0];
  _RAND_154 = {1{`RANDOM}};
  rx_res_crc_6 = _RAND_154[0:0];
  _RAND_155 = {1{`RANDOM}};
  rx_res_crc_error = _RAND_155[0:0];
  _RAND_156 = {1{`RANDOM}};
  rx_res_crc_en = _RAND_156[0:0];
  _RAND_157 = {1{`RANDOM}};
  rx_res_timer = _RAND_157[7:0];
  _RAND_158 = {1{`RANDOM}};
  rx_res_timeout = _RAND_158[0:0];
  _RAND_159 = {1{`RANDOM}};
  rx_res_read_counter = _RAND_159[1:0];
  _RAND_160 = {1{`RANDOM}};
  tx_cmd_arg = _RAND_160[31:0];
  _RAND_161 = {1{`RANDOM}};
  tx_cmd_0 = _RAND_161[0:0];
  _RAND_162 = {1{`RANDOM}};
  tx_cmd_1 = _RAND_162[0:0];
  _RAND_163 = {1{`RANDOM}};
  tx_cmd_2 = _RAND_163[0:0];
  _RAND_164 = {1{`RANDOM}};
  tx_cmd_3 = _RAND_164[0:0];
  _RAND_165 = {1{`RANDOM}};
  tx_cmd_4 = _RAND_165[0:0];
  _RAND_166 = {1{`RANDOM}};
  tx_cmd_5 = _RAND_166[0:0];
  _RAND_167 = {1{`RANDOM}};
  tx_cmd_6 = _RAND_167[0:0];
  _RAND_168 = {1{`RANDOM}};
  tx_cmd_7 = _RAND_168[0:0];
  _RAND_169 = {1{`RANDOM}};
  tx_cmd_8 = _RAND_169[0:0];
  _RAND_170 = {1{`RANDOM}};
  tx_cmd_9 = _RAND_170[0:0];
  _RAND_171 = {1{`RANDOM}};
  tx_cmd_10 = _RAND_171[0:0];
  _RAND_172 = {1{`RANDOM}};
  tx_cmd_11 = _RAND_172[0:0];
  _RAND_173 = {1{`RANDOM}};
  tx_cmd_12 = _RAND_173[0:0];
  _RAND_174 = {1{`RANDOM}};
  tx_cmd_13 = _RAND_174[0:0];
  _RAND_175 = {1{`RANDOM}};
  tx_cmd_14 = _RAND_175[0:0];
  _RAND_176 = {1{`RANDOM}};
  tx_cmd_15 = _RAND_176[0:0];
  _RAND_177 = {1{`RANDOM}};
  tx_cmd_16 = _RAND_177[0:0];
  _RAND_178 = {1{`RANDOM}};
  tx_cmd_17 = _RAND_178[0:0];
  _RAND_179 = {1{`RANDOM}};
  tx_cmd_18 = _RAND_179[0:0];
  _RAND_180 = {1{`RANDOM}};
  tx_cmd_19 = _RAND_180[0:0];
  _RAND_181 = {1{`RANDOM}};
  tx_cmd_20 = _RAND_181[0:0];
  _RAND_182 = {1{`RANDOM}};
  tx_cmd_21 = _RAND_182[0:0];
  _RAND_183 = {1{`RANDOM}};
  tx_cmd_22 = _RAND_183[0:0];
  _RAND_184 = {1{`RANDOM}};
  tx_cmd_23 = _RAND_184[0:0];
  _RAND_185 = {1{`RANDOM}};
  tx_cmd_24 = _RAND_185[0:0];
  _RAND_186 = {1{`RANDOM}};
  tx_cmd_25 = _RAND_186[0:0];
  _RAND_187 = {1{`RANDOM}};
  tx_cmd_26 = _RAND_187[0:0];
  _RAND_188 = {1{`RANDOM}};
  tx_cmd_27 = _RAND_188[0:0];
  _RAND_189 = {1{`RANDOM}};
  tx_cmd_28 = _RAND_189[0:0];
  _RAND_190 = {1{`RANDOM}};
  tx_cmd_29 = _RAND_190[0:0];
  _RAND_191 = {1{`RANDOM}};
  tx_cmd_30 = _RAND_191[0:0];
  _RAND_192 = {1{`RANDOM}};
  tx_cmd_31 = _RAND_192[0:0];
  _RAND_193 = {1{`RANDOM}};
  tx_cmd_32 = _RAND_193[0:0];
  _RAND_194 = {1{`RANDOM}};
  tx_cmd_33 = _RAND_194[0:0];
  _RAND_195 = {1{`RANDOM}};
  tx_cmd_34 = _RAND_195[0:0];
  _RAND_196 = {1{`RANDOM}};
  tx_cmd_35 = _RAND_196[0:0];
  _RAND_197 = {1{`RANDOM}};
  tx_cmd_36 = _RAND_197[0:0];
  _RAND_198 = {1{`RANDOM}};
  tx_cmd_37 = _RAND_198[0:0];
  _RAND_199 = {1{`RANDOM}};
  tx_cmd_38 = _RAND_199[0:0];
  _RAND_200 = {1{`RANDOM}};
  tx_cmd_39 = _RAND_200[0:0];
  _RAND_201 = {1{`RANDOM}};
  tx_cmd_40 = _RAND_201[0:0];
  _RAND_202 = {1{`RANDOM}};
  tx_cmd_41 = _RAND_202[0:0];
  _RAND_203 = {1{`RANDOM}};
  tx_cmd_42 = _RAND_203[0:0];
  _RAND_204 = {1{`RANDOM}};
  tx_cmd_43 = _RAND_204[0:0];
  _RAND_205 = {1{`RANDOM}};
  tx_cmd_44 = _RAND_205[0:0];
  _RAND_206 = {1{`RANDOM}};
  tx_cmd_45 = _RAND_206[0:0];
  _RAND_207 = {1{`RANDOM}};
  tx_cmd_46 = _RAND_207[0:0];
  _RAND_208 = {1{`RANDOM}};
  tx_cmd_47 = _RAND_208[0:0];
  _RAND_209 = {1{`RANDOM}};
  tx_cmd_counter = _RAND_209[5:0];
  _RAND_210 = {1{`RANDOM}};
  tx_cmd_crc_0 = _RAND_210[0:0];
  _RAND_211 = {1{`RANDOM}};
  tx_cmd_crc_1 = _RAND_211[0:0];
  _RAND_212 = {1{`RANDOM}};
  tx_cmd_crc_2 = _RAND_212[0:0];
  _RAND_213 = {1{`RANDOM}};
  tx_cmd_crc_3 = _RAND_213[0:0];
  _RAND_214 = {1{`RANDOM}};
  tx_cmd_crc_4 = _RAND_214[0:0];
  _RAND_215 = {1{`RANDOM}};
  tx_cmd_crc_5 = _RAND_215[0:0];
  _RAND_216 = {1{`RANDOM}};
  tx_cmd_crc_6 = _RAND_216[0:0];
  _RAND_217 = {1{`RANDOM}};
  tx_cmd_timer = _RAND_217[5:0];
  _RAND_218 = {1{`RANDOM}};
  reg_tx_cmd_wrt = _RAND_218[0:0];
  _RAND_219 = {1{`RANDOM}};
  reg_tx_cmd_out = _RAND_219[0:0];
  _RAND_220 = {1{`RANDOM}};
  rx_dat_in_progress = _RAND_220[0:0];
  _RAND_221 = {1{`RANDOM}};
  rx_dat_counter = _RAND_221[10:0];
  _RAND_222 = {1{`RANDOM}};
  rx_dat_start_bit = _RAND_222[0:0];
  _RAND_223 = {1{`RANDOM}};
  rx_dat_bits_0 = _RAND_223[3:0];
  _RAND_224 = {1{`RANDOM}};
  rx_dat_bits_1 = _RAND_224[3:0];
  _RAND_225 = {1{`RANDOM}};
  rx_dat_bits_2 = _RAND_225[3:0];
  _RAND_226 = {1{`RANDOM}};
  rx_dat_bits_3 = _RAND_226[3:0];
  _RAND_227 = {1{`RANDOM}};
  rx_dat_bits_4 = _RAND_227[3:0];
  _RAND_228 = {1{`RANDOM}};
  rx_dat_bits_5 = _RAND_228[3:0];
  _RAND_229 = {1{`RANDOM}};
  rx_dat_bits_6 = _RAND_229[3:0];
  _RAND_230 = {1{`RANDOM}};
  rx_dat_bits_7 = _RAND_230[3:0];
  _RAND_231 = {1{`RANDOM}};
  rx_dat_next = _RAND_231[3:0];
  _RAND_232 = {1{`RANDOM}};
  rx_dat_continuous = _RAND_232[0:0];
  _RAND_233 = {1{`RANDOM}};
  rx_dat_ready = _RAND_233[0:0];
  _RAND_234 = {1{`RANDOM}};
  rx_dat_intr_en = _RAND_234[0:0];
  _RAND_235 = {1{`RANDOM}};
  rx_dat_crc_0 = _RAND_235[3:0];
  _RAND_236 = {1{`RANDOM}};
  rx_dat_crc_1 = _RAND_236[3:0];
  _RAND_237 = {1{`RANDOM}};
  rx_dat_crc_2 = _RAND_237[3:0];
  _RAND_238 = {1{`RANDOM}};
  rx_dat_crc_3 = _RAND_238[3:0];
  _RAND_239 = {1{`RANDOM}};
  rx_dat_crc_4 = _RAND_239[3:0];
  _RAND_240 = {1{`RANDOM}};
  rx_dat_crc_5 = _RAND_240[3:0];
  _RAND_241 = {1{`RANDOM}};
  rx_dat_crc_6 = _RAND_241[3:0];
  _RAND_242 = {1{`RANDOM}};
  rx_dat_crc_7 = _RAND_242[3:0];
  _RAND_243 = {1{`RANDOM}};
  rx_dat_crc_8 = _RAND_243[3:0];
  _RAND_244 = {1{`RANDOM}};
  rx_dat_crc_9 = _RAND_244[3:0];
  _RAND_245 = {1{`RANDOM}};
  rx_dat_crc_10 = _RAND_245[3:0];
  _RAND_246 = {1{`RANDOM}};
  rx_dat_crc_11 = _RAND_246[3:0];
  _RAND_247 = {1{`RANDOM}};
  rx_dat_crc_12 = _RAND_247[3:0];
  _RAND_248 = {1{`RANDOM}};
  rx_dat_crc_13 = _RAND_248[3:0];
  _RAND_249 = {1{`RANDOM}};
  rx_dat_crc_14 = _RAND_249[3:0];
  _RAND_250 = {1{`RANDOM}};
  rx_dat_crc_15 = _RAND_250[3:0];
  _RAND_251 = {1{`RANDOM}};
  rx_dat_crc_error = _RAND_251[0:0];
  _RAND_252 = {1{`RANDOM}};
  rx_dat_timer = _RAND_252[18:0];
  _RAND_253 = {1{`RANDOM}};
  rx_dat_timeout = _RAND_253[0:0];
  _RAND_254 = {1{`RANDOM}};
  rx_dat_overrun = _RAND_254[0:0];
  _RAND_255 = {1{`RANDOM}};
  rxtx_dat_counter = _RAND_255[7:0];
  _RAND_256 = {1{`RANDOM}};
  rxtx_dat_index = _RAND_256[7:0];
  _RAND_257 = {1{`RANDOM}};
  rx_busy_timer = _RAND_257[18:0];
  _RAND_258 = {1{`RANDOM}};
  rx_busy_in_progress = _RAND_258[0:0];
  _RAND_259 = {1{`RANDOM}};
  rx_dat0_next = _RAND_259[0:0];
  _RAND_260 = {1{`RANDOM}};
  rx_dat_buf_read = _RAND_260[0:0];
  _RAND_261 = {1{`RANDOM}};
  rx_dat_buf_cache = _RAND_261[31:0];
  _RAND_262 = {1{`RANDOM}};
  reg_tx_dat_wrt = _RAND_262[0:0];
  _RAND_263 = {1{`RANDOM}};
  reg_tx_dat_out = _RAND_263[0:0];
  _RAND_264 = {1{`RANDOM}};
  tx_empty_intr_en = _RAND_264[0:0];
  _RAND_265 = {1{`RANDOM}};
  tx_end_intr_en = _RAND_265[0:0];
  _RAND_266 = {1{`RANDOM}};
  tx_dat_counter = _RAND_266[10:0];
  _RAND_267 = {1{`RANDOM}};
  tx_dat_timer = _RAND_267[5:0];
  _RAND_268 = {1{`RANDOM}};
  tx_dat_0 = _RAND_268[3:0];
  _RAND_269 = {1{`RANDOM}};
  tx_dat_1 = _RAND_269[3:0];
  _RAND_270 = {1{`RANDOM}};
  tx_dat_2 = _RAND_270[3:0];
  _RAND_271 = {1{`RANDOM}};
  tx_dat_3 = _RAND_271[3:0];
  _RAND_272 = {1{`RANDOM}};
  tx_dat_4 = _RAND_272[3:0];
  _RAND_273 = {1{`RANDOM}};
  tx_dat_5 = _RAND_273[3:0];
  _RAND_274 = {1{`RANDOM}};
  tx_dat_6 = _RAND_274[3:0];
  _RAND_275 = {1{`RANDOM}};
  tx_dat_7 = _RAND_275[3:0];
  _RAND_276 = {1{`RANDOM}};
  tx_dat_8 = _RAND_276[3:0];
  _RAND_277 = {1{`RANDOM}};
  tx_dat_9 = _RAND_277[3:0];
  _RAND_278 = {1{`RANDOM}};
  tx_dat_10 = _RAND_278[3:0];
  _RAND_279 = {1{`RANDOM}};
  tx_dat_11 = _RAND_279[3:0];
  _RAND_280 = {1{`RANDOM}};
  tx_dat_12 = _RAND_280[3:0];
  _RAND_281 = {1{`RANDOM}};
  tx_dat_13 = _RAND_281[3:0];
  _RAND_282 = {1{`RANDOM}};
  tx_dat_14 = _RAND_282[3:0];
  _RAND_283 = {1{`RANDOM}};
  tx_dat_15 = _RAND_283[3:0];
  _RAND_284 = {1{`RANDOM}};
  tx_dat_16 = _RAND_284[3:0];
  _RAND_285 = {1{`RANDOM}};
  tx_dat_17 = _RAND_285[3:0];
  _RAND_286 = {1{`RANDOM}};
  tx_dat_18 = _RAND_286[3:0];
  _RAND_287 = {1{`RANDOM}};
  tx_dat_19 = _RAND_287[3:0];
  _RAND_288 = {1{`RANDOM}};
  tx_dat_20 = _RAND_288[3:0];
  _RAND_289 = {1{`RANDOM}};
  tx_dat_21 = _RAND_289[3:0];
  _RAND_290 = {1{`RANDOM}};
  tx_dat_22 = _RAND_290[3:0];
  _RAND_291 = {1{`RANDOM}};
  tx_dat_23 = _RAND_291[3:0];
  _RAND_292 = {1{`RANDOM}};
  tx_dat_crc_0 = _RAND_292[3:0];
  _RAND_293 = {1{`RANDOM}};
  tx_dat_crc_1 = _RAND_293[3:0];
  _RAND_294 = {1{`RANDOM}};
  tx_dat_crc_2 = _RAND_294[3:0];
  _RAND_295 = {1{`RANDOM}};
  tx_dat_crc_3 = _RAND_295[3:0];
  _RAND_296 = {1{`RANDOM}};
  tx_dat_crc_4 = _RAND_296[3:0];
  _RAND_297 = {1{`RANDOM}};
  tx_dat_crc_5 = _RAND_297[3:0];
  _RAND_298 = {1{`RANDOM}};
  tx_dat_crc_6 = _RAND_298[3:0];
  _RAND_299 = {1{`RANDOM}};
  tx_dat_crc_7 = _RAND_299[3:0];
  _RAND_300 = {1{`RANDOM}};
  tx_dat_crc_8 = _RAND_300[3:0];
  _RAND_301 = {1{`RANDOM}};
  tx_dat_crc_9 = _RAND_301[3:0];
  _RAND_302 = {1{`RANDOM}};
  tx_dat_crc_10 = _RAND_302[3:0];
  _RAND_303 = {1{`RANDOM}};
  tx_dat_crc_11 = _RAND_303[3:0];
  _RAND_304 = {1{`RANDOM}};
  tx_dat_crc_12 = _RAND_304[3:0];
  _RAND_305 = {1{`RANDOM}};
  tx_dat_crc_13 = _RAND_305[3:0];
  _RAND_306 = {1{`RANDOM}};
  tx_dat_crc_14 = _RAND_306[3:0];
  _RAND_307 = {1{`RANDOM}};
  tx_dat_crc_15 = _RAND_307[3:0];
  _RAND_308 = {1{`RANDOM}};
  tx_dat_prepared = _RAND_308[31:0];
  _RAND_309 = {1{`RANDOM}};
  tx_dat_prepare_state = _RAND_309[1:0];
  _RAND_310 = {1{`RANDOM}};
  tx_dat_started = _RAND_310[0:0];
  _RAND_311 = {1{`RANDOM}};
  tx_dat_in_progress = _RAND_311[0:0];
  _RAND_312 = {1{`RANDOM}};
  tx_dat_end = _RAND_312[0:0];
  _RAND_313 = {1{`RANDOM}};
  tx_dat_read_sel = _RAND_313[1:0];
  _RAND_314 = {1{`RANDOM}};
  tx_dat_write_sel = _RAND_314[1:0];
  _RAND_315 = {1{`RANDOM}};
  tx_dat_read_sel_changed = _RAND_315[0:0];
  _RAND_316 = {1{`RANDOM}};
  tx_dat_write_sel_new = _RAND_316[0:0];
  _RAND_317 = {1{`RANDOM}};
  tx_dat_crc_status_counter = _RAND_317[3:0];
  _RAND_318 = {1{`RANDOM}};
  tx_dat_crc_status_b_0 = _RAND_318[0:0];
  _RAND_319 = {1{`RANDOM}};
  tx_dat_crc_status_b_1 = _RAND_319[0:0];
  _RAND_320 = {1{`RANDOM}};
  tx_dat_crc_status_b_2 = _RAND_320[0:0];
  _RAND_321 = {1{`RANDOM}};
  tx_dat_crc_status = _RAND_321[1:0];
  _RAND_322 = {1{`RANDOM}};
  tx_dat_prepared_read = _RAND_322[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Config(
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata
);
  wire [26:0] _io_mem_rdata_T_2 = io_mem_raddr[2] ? 27'h5f678fe : 27'h1234567; // @[Mux.scala 81:58]
  assign io_mem_rdata = {{5'd0}, _io_mem_rdata_T_2}; // @[Top.scala 19:16]
endmodule
module DMemDecoder(
  input  [31:0] io_initiator_raddr,
  output [31:0] io_initiator_rdata,
  input         io_initiator_ren,
  output        io_initiator_rvalid,
  input  [31:0] io_initiator_waddr,
  input         io_initiator_wen,
  output        io_initiator_wready,
  input  [3:0]  io_initiator_wstrb,
  input  [31:0] io_initiator_wdata,
  output [31:0] io_targets_0_raddr,
  input  [31:0] io_targets_0_rdata,
  output        io_targets_0_ren,
  input         io_targets_0_rvalid,
  output [31:0] io_targets_0_waddr,
  output        io_targets_0_wen,
  output [31:0] io_targets_0_wdata,
  output [31:0] io_targets_1_raddr,
  input  [31:0] io_targets_1_rdata,
  output        io_targets_1_ren,
  input         io_targets_1_rvalid,
  output [31:0] io_targets_1_waddr,
  output        io_targets_1_wen,
  input         io_targets_1_wready,
  output [3:0]  io_targets_1_wstrb,
  output [31:0] io_targets_1_wdata,
  output        io_targets_2_wen,
  output [31:0] io_targets_2_wdata,
  output [31:0] io_targets_3_raddr,
  input  [31:0] io_targets_3_rdata,
  output        io_targets_3_ren,
  output [31:0] io_targets_3_waddr,
  output        io_targets_3_wen,
  output [31:0] io_targets_3_wdata,
  output [31:0] io_targets_4_raddr,
  input  [31:0] io_targets_4_rdata,
  output        io_targets_4_ren,
  input         io_targets_4_rvalid,
  output [31:0] io_targets_4_waddr,
  output        io_targets_4_wen,
  output [31:0] io_targets_4_wdata,
  output [31:0] io_targets_5_raddr,
  input  [31:0] io_targets_5_rdata,
  output        io_targets_5_ren,
  output [31:0] io_targets_5_waddr,
  output        io_targets_5_wen,
  output [31:0] io_targets_5_wdata,
  output [31:0] io_targets_6_raddr,
  input  [31:0] io_targets_6_rdata
);
  wire  _GEN_2 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rvalid : 1'h1; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_3 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rdata : 32'hdeadbeef; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_12 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rvalid : _GEN_2; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_13 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rdata : _GEN_3; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_19 = 4'h2 == io_initiator_waddr[31:28] ? io_targets_1_wready : 21'h10000 == io_initiator_waddr[31:11]; // @[Decoder.scala 49:79 54:14]
  wire [31:0] _GEN_23 = 26'hc00000 == io_initiator_raddr[31:6] ? 32'hdeadbeef : _GEN_13; // @[Decoder.scala 42:79 46:13]
  wire [31:0] _GEN_33 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_3_rdata : _GEN_23; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_42 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rvalid : 26'hc00040 == io_initiator_raddr[31:6]
     | (26'hc00000 == io_initiator_raddr[31:6] | _GEN_12); // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_43 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rdata : _GEN_33; // @[Decoder.scala 42:79 46:13]
  wire [31:0] _GEN_53 = 26'hc000c0 == io_initiator_raddr[31:6] ? io_targets_5_rdata : _GEN_43; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rdata = 26'h1000000 == io_initiator_raddr[31:6] ? io_targets_6_rdata : _GEN_53; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rvalid = 26'h1000000 == io_initiator_raddr[31:6] | (26'hc000c0 == io_initiator_raddr[31:6] |
    _GEN_42); // @[Decoder.scala 42:79 45:14]
  assign io_initiator_wready = 26'h1000000 == io_initiator_waddr[31:6] | (26'hc000c0 == io_initiator_waddr[31:6] | (26'hc00080
     == io_initiator_waddr[31:6] | (26'hc00040 == io_initiator_waddr[31:6] | (26'hc00000 == io_initiator_waddr[31:6] |
    _GEN_19)))); // @[Decoder.scala 49:79 54:14]
  assign io_targets_0_raddr = 21'h10000 == io_initiator_raddr[31:11] ? {{21'd0}, io_initiator_raddr[10:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
  assign io_targets_0_ren = 21'h10000 == io_initiator_raddr[31:11] & io_initiator_ren; // @[Decoder.scala 42:79 44:11]
  assign io_targets_0_waddr = 21'h10000 == io_initiator_waddr[31:11] ? {{21'd0}, io_initiator_waddr[10:0]} : 32'h0; // @[Decoder.scala 49:79 50:13]
  assign io_targets_0_wen = 21'h10000 == io_initiator_waddr[31:11] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_0_wdata = 21'h10000 == io_initiator_waddr[31:11] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_1_raddr = 4'h2 == io_initiator_raddr[31:28] ? {{4'd0}, io_initiator_raddr[27:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
  assign io_targets_1_ren = 4'h2 == io_initiator_raddr[31:28] & io_initiator_ren; // @[Decoder.scala 42:79 44:11]
  assign io_targets_1_waddr = 4'h2 == io_initiator_waddr[31:28] ? {{4'd0}, io_initiator_waddr[27:0]} : 32'h0; // @[Decoder.scala 49:79 50:13]
  assign io_targets_1_wen = 4'h2 == io_initiator_waddr[31:28] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_1_wstrb = 4'h2 == io_initiator_waddr[31:28] ? io_initiator_wstrb : 4'hf; // @[Decoder.scala 49:79 53:13]
  assign io_targets_1_wdata = 4'h2 == io_initiator_waddr[31:28] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_2_wen = 26'hc00000 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_2_wdata = 26'hc00000 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_3_raddr = 26'hc00040 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
  assign io_targets_3_ren = 26'hc00040 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 42:79 44:11]
  assign io_targets_3_waddr = 26'hc00040 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 49:79 50:13]
  assign io_targets_3_wen = 26'hc00040 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_3_wdata = 26'hc00040 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_4_raddr = 26'hc00080 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
  assign io_targets_4_ren = 26'hc00080 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 42:79 44:11]
  assign io_targets_4_waddr = 26'hc00080 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 49:79 50:13]
  assign io_targets_4_wen = 26'hc00080 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_4_wdata = 26'hc00080 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_5_raddr = 26'hc000c0 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
  assign io_targets_5_ren = 26'hc000c0 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 42:79 44:11]
  assign io_targets_5_waddr = 26'hc000c0 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 49:79 50:13]
  assign io_targets_5_wen = 26'hc000c0 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 49:79 51:11]
  assign io_targets_5_wdata = 26'hc000c0 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 49:79 52:13]
  assign io_targets_6_raddr = 26'h1000000 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
endmodule
module IMemDecoder(
  input         clock,
  input  [31:0] io_initiator_addr,
  output [31:0] io_initiator_inst,
  output        io_initiator_valid,
  output        io_targets_0_en,
  output [31:0] io_targets_0_addr,
  input  [31:0] io_targets_0_inst,
  input         io_targets_0_valid,
  output        io_targets_1_en,
  output [31:0] io_targets_1_addr,
  input  [31:0] io_targets_1_inst,
  input         io_targets_1_valid
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] next_addr; // @[Decoder.scala 67:26]
  wire  en = 21'h10000 == io_initiator_addr[31:11]; // @[Decoder.scala 82:37]
  wire  _GEN_2 = 21'h10000 == next_addr[31:11] ? io_targets_0_valid : 1'h1; // @[Decoder.scala 86:70 87:13]
  wire [31:0] _GEN_3 = 21'h10000 == next_addr[31:11] ? io_targets_0_inst : 32'hdeadbeef; // @[Decoder.scala 86:70 88:12]
  wire  en_1 = 4'h2 == io_initiator_addr[31:28]; // @[Decoder.scala 82:37]
  assign io_initiator_inst = 4'h2 == next_addr[31:28] ? io_targets_1_inst : _GEN_3; // @[Decoder.scala 86:70 88:12]
  assign io_initiator_valid = 4'h2 == next_addr[31:28] ? io_targets_1_valid : _GEN_2; // @[Decoder.scala 86:70 87:13]
  assign io_targets_0_en = 21'h10000 == io_initiator_addr[31:11]; // @[Decoder.scala 82:37]
  assign io_targets_0_addr = en ? {{21'd0}, io_initiator_addr[10:0]} : 32'h0; // @[Decoder.scala 82:78 83:12]
  assign io_targets_1_en = 4'h2 == io_initiator_addr[31:28]; // @[Decoder.scala 82:37]
  assign io_targets_1_addr = en_1 ? {{4'd0}, io_initiator_addr[27:0]} : 32'h0; // @[Decoder.scala 82:78 83:12]
  always @(posedge clock) begin
    next_addr <= io_initiator_addr; // @[Decoder.scala 67:26]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  next_addr = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RiscV(
  input          clock,
  input          reset,
  output         io_dram_ren,
  output         io_dram_wen,
  output [27:0]  io_dram_addr,
  output [127:0] io_dram_wdata,
  output [15:0]  io_dram_wmask,
  output         io_dram_user_busy,
  input          io_dram_init_calib_complete,
  input  [127:0] io_dram_rdata,
  input          io_dram_rdata_valid,
  input          io_dram_busy,
  output [7:0]   io_gpio,
  output         io_uart_tx,
  input          io_uart_rx,
  output         io_sdc_port_clk,
  output         io_sdc_port_cmd_wrt,
  output         io_sdc_port_cmd_out,
  input          io_sdc_port_res_in,
  output         io_sdc_port_dat_wrt,
  output [3:0]   io_sdc_port_dat_out,
  input  [3:0]   io_sdc_port_dat_in,
  output [31:0]  io_debugSignals_core_mem_reg_pc,
  output         io_debugSignals_core_mem_is_valid_inst,
  output         io_debugSignals_core_me_intr,
  output [47:0]  io_debugSignals_core_cycle_counter,
  output [31:0]  io_debugSignals_core_id_pc,
  output [31:0]  io_debugSignals_core_id_inst,
  output [31:0]  io_debugSignals_rdata,
  output         io_debugSignals_ren,
  output         io_debugSignals_rvalid,
  output [31:0]  io_debugSignals_rwaddr,
  output         io_debugSignals_wen,
  output         io_debugSignals_wready,
  output [3:0]   io_debugSignals_wstrb,
  output [31:0]  io_debugSignals_wdata,
  output         io_debugSignals_sdc_sdbuf_ren1,
  output         io_debugSignals_sdc_sdbuf_wen1,
  output [7:0]   io_debugSignals_sdc_sdbuf_addr1,
  output [7:0]   io_debugSignals_sdc_sdbuf_wdata1,
  output         io_debugSignals_sdc_sdbuf_ren2,
  output         io_debugSignals_sdc_sdbuf_wen2,
  output [7:0]   io_debugSignals_sdc_sdbuf_addr2
);
  wire  core_clock; // @[Top.scala 75:20]
  wire  core_reset; // @[Top.scala 75:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 75:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 75:20]
  wire  core_io_imem_valid; // @[Top.scala 75:20]
  wire  core_io_icache_control_invalidate; // @[Top.scala 75:20]
  wire  core_io_icache_control_busy; // @[Top.scala 75:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 75:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 75:20]
  wire  core_io_dmem_ren; // @[Top.scala 75:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 75:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 75:20]
  wire  core_io_dmem_wen; // @[Top.scala 75:20]
  wire  core_io_dmem_wready; // @[Top.scala 75:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 75:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 75:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 75:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 75:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 75:20]
  wire  core_io_mtimer_mem_rvalid; // @[Top.scala 75:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 75:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 75:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 75:20]
  wire [1:0] core_io_intr; // @[Top.scala 75:20]
  wire  core_io_exit; // @[Top.scala 75:20]
  wire [31:0] core_io_debug_signal_mem_reg_pc; // @[Top.scala 75:20]
  wire  core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 75:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 75:20]
  wire [47:0] core_io_debug_signal_cycle_counter; // @[Top.scala 75:20]
  wire [31:0] core_io_debug_signal_id_pc; // @[Top.scala 75:20]
  wire [31:0] core_io_debug_signal_id_inst; // @[Top.scala 75:20]
  wire  memory_clock; // @[Top.scala 77:22]
  wire  memory_reset; // @[Top.scala 77:22]
  wire  memory_io_imem_en; // @[Top.scala 77:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 77:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 77:22]
  wire  memory_io_imem_valid; // @[Top.scala 77:22]
  wire  memory_io_icache_control_invalidate; // @[Top.scala 77:22]
  wire  memory_io_icache_control_busy; // @[Top.scala 77:22]
  wire [31:0] memory_io_dmem_raddr; // @[Top.scala 77:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 77:22]
  wire  memory_io_dmem_ren; // @[Top.scala 77:22]
  wire  memory_io_dmem_rvalid; // @[Top.scala 77:22]
  wire [31:0] memory_io_dmem_waddr; // @[Top.scala 77:22]
  wire  memory_io_dmem_wen; // @[Top.scala 77:22]
  wire  memory_io_dmem_wready; // @[Top.scala 77:22]
  wire [3:0] memory_io_dmem_wstrb; // @[Top.scala 77:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 77:22]
  wire  memory_io_dramPort_ren; // @[Top.scala 77:22]
  wire  memory_io_dramPort_wen; // @[Top.scala 77:22]
  wire [27:0] memory_io_dramPort_addr; // @[Top.scala 77:22]
  wire [127:0] memory_io_dramPort_wdata; // @[Top.scala 77:22]
  wire  memory_io_dramPort_init_calib_complete; // @[Top.scala 77:22]
  wire [127:0] memory_io_dramPort_rdata; // @[Top.scala 77:22]
  wire  memory_io_dramPort_rdata_valid; // @[Top.scala 77:22]
  wire  memory_io_dramPort_busy; // @[Top.scala 77:22]
  wire  memory_io_cache_array1_en; // @[Top.scala 77:22]
  wire [31:0] memory_io_cache_array1_we; // @[Top.scala 77:22]
  wire [6:0] memory_io_cache_array1_addr; // @[Top.scala 77:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[Top.scala 77:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[Top.scala 77:22]
  wire  memory_io_cache_array2_en; // @[Top.scala 77:22]
  wire [31:0] memory_io_cache_array2_we; // @[Top.scala 77:22]
  wire [6:0] memory_io_cache_array2_addr; // @[Top.scala 77:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[Top.scala 77:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[Top.scala 77:22]
  wire  memory_io_icache_ren; // @[Top.scala 77:22]
  wire  memory_io_icache_wen; // @[Top.scala 77:22]
  wire [9:0] memory_io_icache_raddr; // @[Top.scala 77:22]
  wire [31:0] memory_io_icache_rdata; // @[Top.scala 77:22]
  wire [6:0] memory_io_icache_waddr; // @[Top.scala 77:22]
  wire [255:0] memory_io_icache_wdata; // @[Top.scala 77:22]
  wire  memory_io_icache_valid_ren; // @[Top.scala 77:22]
  wire  memory_io_icache_valid_wen; // @[Top.scala 77:22]
  wire  memory_io_icache_valid_invalidate; // @[Top.scala 77:22]
  wire [5:0] memory_io_icache_valid_addr; // @[Top.scala 77:22]
  wire  memory_io_icache_valid_iaddr; // @[Top.scala 77:22]
  wire [1:0] memory_io_icache_valid_rdata; // @[Top.scala 77:22]
  wire [1:0] memory_io_icache_valid_wdata; // @[Top.scala 77:22]
  wire  boot_rom_clock; // @[Top.scala 78:24]
  wire  boot_rom_reset; // @[Top.scala 78:24]
  wire  boot_rom_io_imem_en; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_imem_addr; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_imem_inst; // @[Top.scala 78:24]
  wire  boot_rom_io_imem_valid; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_dmem_raddr; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_dmem_rdata; // @[Top.scala 78:24]
  wire  boot_rom_io_dmem_ren; // @[Top.scala 78:24]
  wire  boot_rom_io_dmem_rvalid; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_dmem_waddr; // @[Top.scala 78:24]
  wire  boot_rom_io_dmem_wen; // @[Top.scala 78:24]
  wire [31:0] boot_rom_io_dmem_wdata; // @[Top.scala 78:24]
  wire  sram1_clock; // @[Top.scala 79:21]
  wire  sram1_en; // @[Top.scala 79:21]
  wire [31:0] sram1_we; // @[Top.scala 79:21]
  wire [6:0] sram1_addr; // @[Top.scala 79:21]
  wire [255:0] sram1_wdata; // @[Top.scala 79:21]
  wire [255:0] sram1_rdata; // @[Top.scala 79:21]
  wire  sram2_clock; // @[Top.scala 80:21]
  wire  sram2_en; // @[Top.scala 80:21]
  wire [31:0] sram2_we; // @[Top.scala 80:21]
  wire [6:0] sram2_addr; // @[Top.scala 80:21]
  wire [255:0] sram2_wdata; // @[Top.scala 80:21]
  wire [255:0] sram2_rdata; // @[Top.scala 80:21]
  wire  icache_clock; // @[Top.scala 81:22]
  wire  icache_ren; // @[Top.scala 81:22]
  wire  icache_wen; // @[Top.scala 81:22]
  wire [9:0] icache_raddr; // @[Top.scala 81:22]
  wire [31:0] icache_rdata; // @[Top.scala 81:22]
  wire [6:0] icache_waddr; // @[Top.scala 81:22]
  wire [255:0] icache_wdata; // @[Top.scala 81:22]
  wire  icache_valid_clock; // @[Top.scala 82:28]
  wire  icache_valid_ren; // @[Top.scala 82:28]
  wire  icache_valid_wen; // @[Top.scala 82:28]
  wire  icache_valid_ien; // @[Top.scala 82:28]
  wire  icache_valid_invalidate; // @[Top.scala 82:28]
  wire [5:0] icache_valid_addr; // @[Top.scala 82:28]
  wire  icache_valid_iaddr; // @[Top.scala 82:28]
  wire [1:0] icache_valid_rdata; // @[Top.scala 82:28]
  wire [1:0] icache_valid_wdata; // @[Top.scala 82:28]
  wire [63:0] icache_valid_idata; // @[Top.scala 82:28]
  wire [1:0] icache_valid_dummy_data; // @[Top.scala 82:28]
  wire  gpio_clock; // @[Top.scala 83:20]
  wire  gpio_reset; // @[Top.scala 83:20]
  wire  gpio_io_mem_wen; // @[Top.scala 83:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 83:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 83:20]
  wire  uart_clock; // @[Top.scala 84:20]
  wire  uart_reset; // @[Top.scala 84:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 84:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 84:20]
  wire  uart_io_mem_ren; // @[Top.scala 84:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 84:20]
  wire  uart_io_mem_wen; // @[Top.scala 84:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 84:20]
  wire  uart_io_intr; // @[Top.scala 84:20]
  wire  uart_io_tx; // @[Top.scala 84:20]
  wire  uart_io_rx; // @[Top.scala 84:20]
  wire  sdc_clock; // @[Top.scala 85:19]
  wire  sdc_reset; // @[Top.scala 85:19]
  wire [31:0] sdc_io_mem_raddr; // @[Top.scala 85:19]
  wire [31:0] sdc_io_mem_rdata; // @[Top.scala 85:19]
  wire  sdc_io_mem_ren; // @[Top.scala 85:19]
  wire [31:0] sdc_io_mem_waddr; // @[Top.scala 85:19]
  wire  sdc_io_mem_wen; // @[Top.scala 85:19]
  wire [31:0] sdc_io_mem_wdata; // @[Top.scala 85:19]
  wire  sdc_io_sdc_port_clk; // @[Top.scala 85:19]
  wire  sdc_io_sdc_port_cmd_wrt; // @[Top.scala 85:19]
  wire  sdc_io_sdc_port_cmd_out; // @[Top.scala 85:19]
  wire  sdc_io_sdc_port_res_in; // @[Top.scala 85:19]
  wire  sdc_io_sdc_port_dat_wrt; // @[Top.scala 85:19]
  wire [3:0] sdc_io_sdc_port_dat_out; // @[Top.scala 85:19]
  wire [3:0] sdc_io_sdc_port_dat_in; // @[Top.scala 85:19]
  wire  sdc_io_sdbuf_ren1; // @[Top.scala 85:19]
  wire  sdc_io_sdbuf_wen1; // @[Top.scala 85:19]
  wire [7:0] sdc_io_sdbuf_addr1; // @[Top.scala 85:19]
  wire [31:0] sdc_io_sdbuf_rdata1; // @[Top.scala 85:19]
  wire [31:0] sdc_io_sdbuf_wdata1; // @[Top.scala 85:19]
  wire  sdc_io_sdbuf_ren2; // @[Top.scala 85:19]
  wire  sdc_io_sdbuf_wen2; // @[Top.scala 85:19]
  wire [7:0] sdc_io_sdbuf_addr2; // @[Top.scala 85:19]
  wire [31:0] sdc_io_sdbuf_rdata2; // @[Top.scala 85:19]
  wire [31:0] sdc_io_sdbuf_wdata2; // @[Top.scala 85:19]
  wire  sdc_io_intr; // @[Top.scala 85:19]
  wire  sdbuf_clock; // @[Top.scala 86:21]
  wire  sdbuf_ren1; // @[Top.scala 86:21]
  wire  sdbuf_wen1; // @[Top.scala 86:21]
  wire [7:0] sdbuf_addr1; // @[Top.scala 86:21]
  wire [31:0] sdbuf_wdata1; // @[Top.scala 86:21]
  wire [31:0] sdbuf_rdata1; // @[Top.scala 86:21]
  wire  sdbuf_ren2; // @[Top.scala 86:21]
  wire  sdbuf_wen2; // @[Top.scala 86:21]
  wire [7:0] sdbuf_addr2; // @[Top.scala 86:21]
  wire [31:0] sdbuf_wdata2; // @[Top.scala 86:21]
  wire [31:0] sdbuf_rdata2; // @[Top.scala 86:21]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 87:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 87:22]
  wire [31:0] dmem_decoder_io_initiator_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_initiator_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_initiator_ren; // @[Top.scala 89:28]
  wire  dmem_decoder_io_initiator_rvalid; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_initiator_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_initiator_wen; // @[Top.scala 89:28]
  wire  dmem_decoder_io_initiator_wready; // @[Top.scala 89:28]
  wire [3:0] dmem_decoder_io_initiator_wstrb; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_initiator_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_0_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_0_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_0_ren; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_0_rvalid; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_0_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_0_wen; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_0_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_1_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_1_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_1_ren; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_1_rvalid; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_1_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_1_wen; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_1_wready; // @[Top.scala 89:28]
  wire [3:0] dmem_decoder_io_targets_1_wstrb; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_1_wdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_2_wen; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_2_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_3_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_3_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_3_ren; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_3_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_3_wen; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_3_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_4_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_4_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_4_ren; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_4_rvalid; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_4_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_4_wen; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_4_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_5_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_5_rdata; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_5_ren; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_5_waddr; // @[Top.scala 89:28]
  wire  dmem_decoder_io_targets_5_wen; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_5_wdata; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_6_raddr; // @[Top.scala 89:28]
  wire [31:0] dmem_decoder_io_targets_6_rdata; // @[Top.scala 89:28]
  wire  imem_decoder_clock; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_initiator_addr; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_initiator_inst; // @[Top.scala 106:28]
  wire  imem_decoder_io_initiator_valid; // @[Top.scala 106:28]
  wire  imem_decoder_io_targets_0_en; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_targets_0_addr; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_targets_0_inst; // @[Top.scala 106:28]
  wire  imem_decoder_io_targets_0_valid; // @[Top.scala 106:28]
  wire  imem_decoder_io_targets_1_en; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_targets_1_addr; // @[Top.scala 106:28]
  wire [31:0] imem_decoder_io_targets_1_inst; // @[Top.scala 106:28]
  wire  imem_decoder_io_targets_1_valid; // @[Top.scala 106:28]
  wire  _core_io_intr_T = sdc_io_intr; // @[Top.scala 187:35]
  Core core ( // @[Top.scala 75:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
    .io_imem_valid(core_io_imem_valid),
    .io_icache_control_invalidate(core_io_icache_control_invalidate),
    .io_icache_control_busy(core_io_icache_control_busy),
    .io_dmem_raddr(core_io_dmem_raddr),
    .io_dmem_rdata(core_io_dmem_rdata),
    .io_dmem_ren(core_io_dmem_ren),
    .io_dmem_rvalid(core_io_dmem_rvalid),
    .io_dmem_waddr(core_io_dmem_waddr),
    .io_dmem_wen(core_io_dmem_wen),
    .io_dmem_wready(core_io_dmem_wready),
    .io_dmem_wstrb(core_io_dmem_wstrb),
    .io_dmem_wdata(core_io_dmem_wdata),
    .io_mtimer_mem_raddr(core_io_mtimer_mem_raddr),
    .io_mtimer_mem_rdata(core_io_mtimer_mem_rdata),
    .io_mtimer_mem_ren(core_io_mtimer_mem_ren),
    .io_mtimer_mem_rvalid(core_io_mtimer_mem_rvalid),
    .io_mtimer_mem_waddr(core_io_mtimer_mem_waddr),
    .io_mtimer_mem_wen(core_io_mtimer_mem_wen),
    .io_mtimer_mem_wdata(core_io_mtimer_mem_wdata),
    .io_intr(core_io_intr),
    .io_exit(core_io_exit),
    .io_debug_signal_mem_reg_pc(core_io_debug_signal_mem_reg_pc),
    .io_debug_signal_mem_is_valid_inst(core_io_debug_signal_mem_is_valid_inst),
    .io_debug_signal_me_intr(core_io_debug_signal_me_intr),
    .io_debug_signal_cycle_counter(core_io_debug_signal_cycle_counter),
    .io_debug_signal_id_pc(core_io_debug_signal_id_pc),
    .io_debug_signal_id_inst(core_io_debug_signal_id_inst)
  );
  Memory memory ( // @[Top.scala 77:22]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_imem_en(memory_io_imem_en),
    .io_imem_addr(memory_io_imem_addr),
    .io_imem_inst(memory_io_imem_inst),
    .io_imem_valid(memory_io_imem_valid),
    .io_icache_control_invalidate(memory_io_icache_control_invalidate),
    .io_icache_control_busy(memory_io_icache_control_busy),
    .io_dmem_raddr(memory_io_dmem_raddr),
    .io_dmem_rdata(memory_io_dmem_rdata),
    .io_dmem_ren(memory_io_dmem_ren),
    .io_dmem_rvalid(memory_io_dmem_rvalid),
    .io_dmem_waddr(memory_io_dmem_waddr),
    .io_dmem_wen(memory_io_dmem_wen),
    .io_dmem_wready(memory_io_dmem_wready),
    .io_dmem_wstrb(memory_io_dmem_wstrb),
    .io_dmem_wdata(memory_io_dmem_wdata),
    .io_dramPort_ren(memory_io_dramPort_ren),
    .io_dramPort_wen(memory_io_dramPort_wen),
    .io_dramPort_addr(memory_io_dramPort_addr),
    .io_dramPort_wdata(memory_io_dramPort_wdata),
    .io_dramPort_init_calib_complete(memory_io_dramPort_init_calib_complete),
    .io_dramPort_rdata(memory_io_dramPort_rdata),
    .io_dramPort_rdata_valid(memory_io_dramPort_rdata_valid),
    .io_dramPort_busy(memory_io_dramPort_busy),
    .io_cache_array1_en(memory_io_cache_array1_en),
    .io_cache_array1_we(memory_io_cache_array1_we),
    .io_cache_array1_addr(memory_io_cache_array1_addr),
    .io_cache_array1_wdata(memory_io_cache_array1_wdata),
    .io_cache_array1_rdata(memory_io_cache_array1_rdata),
    .io_cache_array2_en(memory_io_cache_array2_en),
    .io_cache_array2_we(memory_io_cache_array2_we),
    .io_cache_array2_addr(memory_io_cache_array2_addr),
    .io_cache_array2_wdata(memory_io_cache_array2_wdata),
    .io_cache_array2_rdata(memory_io_cache_array2_rdata),
    .io_icache_ren(memory_io_icache_ren),
    .io_icache_wen(memory_io_icache_wen),
    .io_icache_raddr(memory_io_icache_raddr),
    .io_icache_rdata(memory_io_icache_rdata),
    .io_icache_waddr(memory_io_icache_waddr),
    .io_icache_wdata(memory_io_icache_wdata),
    .io_icache_valid_ren(memory_io_icache_valid_ren),
    .io_icache_valid_wen(memory_io_icache_valid_wen),
    .io_icache_valid_invalidate(memory_io_icache_valid_invalidate),
    .io_icache_valid_addr(memory_io_icache_valid_addr),
    .io_icache_valid_iaddr(memory_io_icache_valid_iaddr),
    .io_icache_valid_rdata(memory_io_icache_valid_rdata),
    .io_icache_valid_wdata(memory_io_icache_valid_wdata)
  );
  BootRom boot_rom ( // @[Top.scala 78:24]
    .clock(boot_rom_clock),
    .reset(boot_rom_reset),
    .io_imem_en(boot_rom_io_imem_en),
    .io_imem_addr(boot_rom_io_imem_addr),
    .io_imem_inst(boot_rom_io_imem_inst),
    .io_imem_valid(boot_rom_io_imem_valid),
    .io_dmem_raddr(boot_rom_io_dmem_raddr),
    .io_dmem_rdata(boot_rom_io_dmem_rdata),
    .io_dmem_ren(boot_rom_io_dmem_ren),
    .io_dmem_rvalid(boot_rom_io_dmem_rvalid),
    .io_dmem_waddr(boot_rom_io_dmem_waddr),
    .io_dmem_wen(boot_rom_io_dmem_wen),
    .io_dmem_wdata(boot_rom_io_dmem_wdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram1 ( // @[Top.scala 79:21]
    .clock(sram1_clock),
    .en(sram1_en),
    .we(sram1_we),
    .addr(sram1_addr),
    .wdata(sram1_wdata),
    .rdata(sram1_rdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram2 ( // @[Top.scala 80:21]
    .clock(sram2_clock),
    .en(sram2_en),
    .we(sram2_we),
    .addr(sram2_addr),
    .wdata(sram2_wdata),
    .rdata(sram2_rdata)
  );
  ICache #(.RDATA_WIDTH_BITS(5), .RADDR_WIDTH(10), .WDATA_WIDTH_BITS(8), .WADDR_WIDTH(7)) icache ( // @[Top.scala 81:22]
    .clock(icache_clock),
    .ren(icache_ren),
    .wen(icache_wen),
    .raddr(icache_raddr),
    .rdata(icache_rdata),
    .waddr(icache_waddr),
    .wdata(icache_wdata)
  );
  ICacheValid #(.DATA_WIDTH_BITS(1), .ADDR_WIDTH(6), .INVALIDATE_WIDTH_BITS(6), .INVALIDATE_ADDR_WIDTH(1)) icache_valid
     ( // @[Top.scala 82:28]
    .clock(icache_valid_clock),
    .ren(icache_valid_ren),
    .wen(icache_valid_wen),
    .ien(icache_valid_ien),
    .invalidate(icache_valid_invalidate),
    .addr(icache_valid_addr),
    .iaddr(icache_valid_iaddr),
    .rdata(icache_valid_rdata),
    .wdata(icache_valid_wdata),
    .idata(icache_valid_idata),
    .dummy_data(icache_valid_dummy_data)
  );
  Gpio gpio ( // @[Top.scala 83:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 84:20]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_mem_raddr(uart_io_mem_raddr),
    .io_mem_rdata(uart_io_mem_rdata),
    .io_mem_ren(uart_io_mem_ren),
    .io_mem_waddr(uart_io_mem_waddr),
    .io_mem_wen(uart_io_mem_wen),
    .io_mem_wdata(uart_io_mem_wdata),
    .io_intr(uart_io_intr),
    .io_tx(uart_io_tx),
    .io_rx(uart_io_rx)
  );
  Sdc sdc ( // @[Top.scala 85:19]
    .clock(sdc_clock),
    .reset(sdc_reset),
    .io_mem_raddr(sdc_io_mem_raddr),
    .io_mem_rdata(sdc_io_mem_rdata),
    .io_mem_ren(sdc_io_mem_ren),
    .io_mem_waddr(sdc_io_mem_waddr),
    .io_mem_wen(sdc_io_mem_wen),
    .io_mem_wdata(sdc_io_mem_wdata),
    .io_sdc_port_clk(sdc_io_sdc_port_clk),
    .io_sdc_port_cmd_wrt(sdc_io_sdc_port_cmd_wrt),
    .io_sdc_port_cmd_out(sdc_io_sdc_port_cmd_out),
    .io_sdc_port_res_in(sdc_io_sdc_port_res_in),
    .io_sdc_port_dat_wrt(sdc_io_sdc_port_dat_wrt),
    .io_sdc_port_dat_out(sdc_io_sdc_port_dat_out),
    .io_sdc_port_dat_in(sdc_io_sdc_port_dat_in),
    .io_sdbuf_ren1(sdc_io_sdbuf_ren1),
    .io_sdbuf_wen1(sdc_io_sdbuf_wen1),
    .io_sdbuf_addr1(sdc_io_sdbuf_addr1),
    .io_sdbuf_rdata1(sdc_io_sdbuf_rdata1),
    .io_sdbuf_wdata1(sdc_io_sdbuf_wdata1),
    .io_sdbuf_ren2(sdc_io_sdbuf_ren2),
    .io_sdbuf_wen2(sdc_io_sdbuf_wen2),
    .io_sdbuf_addr2(sdc_io_sdbuf_addr2),
    .io_sdbuf_rdata2(sdc_io_sdbuf_rdata2),
    .io_sdbuf_wdata2(sdc_io_sdbuf_wdata2),
    .io_intr(sdc_io_intr)
  );
  SdBuf #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) sdbuf ( // @[Top.scala 86:21]
    .clock(sdbuf_clock),
    .ren1(sdbuf_ren1),
    .wen1(sdbuf_wen1),
    .addr1(sdbuf_addr1),
    .wdata1(sdbuf_wdata1),
    .rdata1(sdbuf_rdata1),
    .ren2(sdbuf_ren2),
    .wen2(sdbuf_wen2),
    .addr2(sdbuf_addr2),
    .wdata2(sdbuf_wdata2),
    .rdata2(sdbuf_rdata2)
  );
  Config config_ ( // @[Top.scala 87:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder dmem_decoder ( // @[Top.scala 89:28]
    .io_initiator_raddr(dmem_decoder_io_initiator_raddr),
    .io_initiator_rdata(dmem_decoder_io_initiator_rdata),
    .io_initiator_ren(dmem_decoder_io_initiator_ren),
    .io_initiator_rvalid(dmem_decoder_io_initiator_rvalid),
    .io_initiator_waddr(dmem_decoder_io_initiator_waddr),
    .io_initiator_wen(dmem_decoder_io_initiator_wen),
    .io_initiator_wready(dmem_decoder_io_initiator_wready),
    .io_initiator_wstrb(dmem_decoder_io_initiator_wstrb),
    .io_initiator_wdata(dmem_decoder_io_initiator_wdata),
    .io_targets_0_raddr(dmem_decoder_io_targets_0_raddr),
    .io_targets_0_rdata(dmem_decoder_io_targets_0_rdata),
    .io_targets_0_ren(dmem_decoder_io_targets_0_ren),
    .io_targets_0_rvalid(dmem_decoder_io_targets_0_rvalid),
    .io_targets_0_waddr(dmem_decoder_io_targets_0_waddr),
    .io_targets_0_wen(dmem_decoder_io_targets_0_wen),
    .io_targets_0_wdata(dmem_decoder_io_targets_0_wdata),
    .io_targets_1_raddr(dmem_decoder_io_targets_1_raddr),
    .io_targets_1_rdata(dmem_decoder_io_targets_1_rdata),
    .io_targets_1_ren(dmem_decoder_io_targets_1_ren),
    .io_targets_1_rvalid(dmem_decoder_io_targets_1_rvalid),
    .io_targets_1_waddr(dmem_decoder_io_targets_1_waddr),
    .io_targets_1_wen(dmem_decoder_io_targets_1_wen),
    .io_targets_1_wready(dmem_decoder_io_targets_1_wready),
    .io_targets_1_wstrb(dmem_decoder_io_targets_1_wstrb),
    .io_targets_1_wdata(dmem_decoder_io_targets_1_wdata),
    .io_targets_2_wen(dmem_decoder_io_targets_2_wen),
    .io_targets_2_wdata(dmem_decoder_io_targets_2_wdata),
    .io_targets_3_raddr(dmem_decoder_io_targets_3_raddr),
    .io_targets_3_rdata(dmem_decoder_io_targets_3_rdata),
    .io_targets_3_ren(dmem_decoder_io_targets_3_ren),
    .io_targets_3_waddr(dmem_decoder_io_targets_3_waddr),
    .io_targets_3_wen(dmem_decoder_io_targets_3_wen),
    .io_targets_3_wdata(dmem_decoder_io_targets_3_wdata),
    .io_targets_4_raddr(dmem_decoder_io_targets_4_raddr),
    .io_targets_4_rdata(dmem_decoder_io_targets_4_rdata),
    .io_targets_4_ren(dmem_decoder_io_targets_4_ren),
    .io_targets_4_rvalid(dmem_decoder_io_targets_4_rvalid),
    .io_targets_4_waddr(dmem_decoder_io_targets_4_waddr),
    .io_targets_4_wen(dmem_decoder_io_targets_4_wen),
    .io_targets_4_wdata(dmem_decoder_io_targets_4_wdata),
    .io_targets_5_raddr(dmem_decoder_io_targets_5_raddr),
    .io_targets_5_rdata(dmem_decoder_io_targets_5_rdata),
    .io_targets_5_ren(dmem_decoder_io_targets_5_ren),
    .io_targets_5_waddr(dmem_decoder_io_targets_5_waddr),
    .io_targets_5_wen(dmem_decoder_io_targets_5_wen),
    .io_targets_5_wdata(dmem_decoder_io_targets_5_wdata),
    .io_targets_6_raddr(dmem_decoder_io_targets_6_raddr),
    .io_targets_6_rdata(dmem_decoder_io_targets_6_rdata)
  );
  IMemDecoder imem_decoder ( // @[Top.scala 106:28]
    .clock(imem_decoder_clock),
    .io_initiator_addr(imem_decoder_io_initiator_addr),
    .io_initiator_inst(imem_decoder_io_initiator_inst),
    .io_initiator_valid(imem_decoder_io_initiator_valid),
    .io_targets_0_en(imem_decoder_io_targets_0_en),
    .io_targets_0_addr(imem_decoder_io_targets_0_addr),
    .io_targets_0_inst(imem_decoder_io_targets_0_inst),
    .io_targets_0_valid(imem_decoder_io_targets_0_valid),
    .io_targets_1_en(imem_decoder_io_targets_1_en),
    .io_targets_1_addr(imem_decoder_io_targets_1_addr),
    .io_targets_1_inst(imem_decoder_io_targets_1_inst),
    .io_targets_1_valid(imem_decoder_io_targets_1_valid)
  );
  assign io_dram_ren = memory_io_dramPort_ren; // @[Top.scala 119:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[Top.scala 119:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[Top.scala 119:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[Top.scala 119:11]
  assign io_dram_wmask = 16'h0; // @[Top.scala 119:11]
  assign io_dram_user_busy = 1'h0; // @[Top.scala 119:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 184:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 185:14]
  assign io_sdc_port_clk = sdc_io_sdc_port_clk; // @[Top.scala 188:15]
  assign io_sdc_port_cmd_wrt = sdc_io_sdc_port_cmd_wrt; // @[Top.scala 188:15]
  assign io_sdc_port_cmd_out = sdc_io_sdc_port_cmd_out; // @[Top.scala 188:15]
  assign io_sdc_port_dat_wrt = sdc_io_sdc_port_dat_wrt; // @[Top.scala 188:15]
  assign io_sdc_port_dat_out = sdc_io_sdc_port_dat_out; // @[Top.scala 188:15]
  assign io_debugSignals_core_mem_reg_pc = core_io_debug_signal_mem_reg_pc; // @[Top.scala 154:24]
  assign io_debugSignals_core_mem_is_valid_inst = core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 154:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 154:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 154:24]
  assign io_debugSignals_core_id_pc = core_io_debug_signal_id_pc; // @[Top.scala 154:24]
  assign io_debugSignals_core_id_inst = core_io_debug_signal_id_inst; // @[Top.scala 154:24]
  assign io_debugSignals_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 156:26]
  assign io_debugSignals_ren = core_io_dmem_ren; // @[Top.scala 157:26]
  assign io_debugSignals_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 158:26]
  assign io_debugSignals_rwaddr = core_io_dmem_waddr; // @[Top.scala 159:27]
  assign io_debugSignals_wen = core_io_dmem_wen; // @[Top.scala 161:26]
  assign io_debugSignals_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 162:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 163:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 160:26]
  assign io_debugSignals_sdc_sdbuf_ren1 = sdc_io_sdbuf_ren1; // @[Top.scala 175:34]
  assign io_debugSignals_sdc_sdbuf_wen1 = sdc_io_sdbuf_wen1; // @[Top.scala 176:34]
  assign io_debugSignals_sdc_sdbuf_addr1 = sdc_io_sdbuf_addr1; // @[Top.scala 177:35]
  assign io_debugSignals_sdc_sdbuf_wdata1 = sdc_io_sdbuf_wdata1[7:0]; // @[Top.scala 178:58]
  assign io_debugSignals_sdc_sdbuf_ren2 = sdc_io_sdbuf_ren2; // @[Top.scala 179:34]
  assign io_debugSignals_sdc_sdbuf_wen2 = sdc_io_sdbuf_wen2; // @[Top.scala 180:34]
  assign io_debugSignals_sdc_sdbuf_addr2 = sdc_io_sdbuf_addr2; // @[Top.scala 181:35]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = imem_decoder_io_initiator_inst; // @[Top.scala 113:16]
  assign core_io_imem_valid = imem_decoder_io_initiator_valid; // @[Top.scala 113:16]
  assign core_io_icache_control_busy = memory_io_icache_control_busy; // @[Top.scala 116:26]
  assign core_io_dmem_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 114:16]
  assign core_io_dmem_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 114:16]
  assign core_io_dmem_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 114:16]
  assign core_io_mtimer_mem_raddr = dmem_decoder_io_targets_4_raddr; // @[Top.scala 102:30]
  assign core_io_mtimer_mem_ren = dmem_decoder_io_targets_4_ren; // @[Top.scala 102:30]
  assign core_io_mtimer_mem_waddr = dmem_decoder_io_targets_4_waddr; // @[Top.scala 102:30]
  assign core_io_mtimer_mem_wen = dmem_decoder_io_targets_4_wen; // @[Top.scala 102:30]
  assign core_io_mtimer_mem_wdata = dmem_decoder_io_targets_4_wdata; // @[Top.scala 102:30]
  assign core_io_intr = {_core_io_intr_T,uart_io_intr}; // @[Cat.scala 31:58]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_en = imem_decoder_io_targets_1_en; // @[Top.scala 111:30]
  assign memory_io_imem_addr = imem_decoder_io_targets_1_addr; // @[Top.scala 111:30]
  assign memory_io_icache_control_invalidate = core_io_icache_control_invalidate; // @[Top.scala 116:26]
  assign memory_io_dmem_raddr = dmem_decoder_io_targets_1_raddr; // @[Top.scala 99:30]
  assign memory_io_dmem_ren = dmem_decoder_io_targets_1_ren; // @[Top.scala 99:30]
  assign memory_io_dmem_waddr = dmem_decoder_io_targets_1_waddr; // @[Top.scala 99:30]
  assign memory_io_dmem_wen = dmem_decoder_io_targets_1_wen; // @[Top.scala 99:30]
  assign memory_io_dmem_wstrb = dmem_decoder_io_targets_1_wstrb; // @[Top.scala 99:30]
  assign memory_io_dmem_wdata = dmem_decoder_io_targets_1_wdata; // @[Top.scala 99:30]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 119:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[Top.scala 119:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[Top.scala 119:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[Top.scala 119:11]
  assign memory_io_cache_array1_rdata = sram1_rdata; // @[Top.scala 126:32]
  assign memory_io_cache_array2_rdata = sram2_rdata; // @[Top.scala 132:32]
  assign memory_io_icache_rdata = icache_rdata; // @[Top.scala 138:26]
  assign memory_io_icache_valid_rdata = icache_valid_rdata; // @[Top.scala 148:32]
  assign boot_rom_clock = clock;
  assign boot_rom_reset = reset;
  assign boot_rom_io_imem_en = imem_decoder_io_targets_0_en; // @[Top.scala 110:30]
  assign boot_rom_io_imem_addr = imem_decoder_io_targets_0_addr; // @[Top.scala 110:30]
  assign boot_rom_io_dmem_raddr = dmem_decoder_io_targets_0_raddr; // @[Top.scala 98:30]
  assign boot_rom_io_dmem_ren = dmem_decoder_io_targets_0_ren; // @[Top.scala 98:30]
  assign boot_rom_io_dmem_waddr = dmem_decoder_io_targets_0_waddr; // @[Top.scala 98:30]
  assign boot_rom_io_dmem_wen = dmem_decoder_io_targets_0_wen; // @[Top.scala 98:30]
  assign boot_rom_io_dmem_wdata = dmem_decoder_io_targets_0_wdata; // @[Top.scala 98:30]
  assign sram1_clock = clock; // @[Top.scala 121:18]
  assign sram1_en = memory_io_cache_array1_en; // @[Top.scala 122:15]
  assign sram1_we = memory_io_cache_array1_we; // @[Top.scala 123:15]
  assign sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 124:17]
  assign sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 125:18]
  assign sram2_clock = clock; // @[Top.scala 127:18]
  assign sram2_en = memory_io_cache_array2_en; // @[Top.scala 128:15]
  assign sram2_we = memory_io_cache_array2_we; // @[Top.scala 129:15]
  assign sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 130:17]
  assign sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 131:18]
  assign icache_clock = clock; // @[Top.scala 134:19]
  assign icache_ren = memory_io_icache_ren; // @[Top.scala 135:17]
  assign icache_wen = memory_io_icache_wen; // @[Top.scala 136:17]
  assign icache_raddr = memory_io_icache_raddr; // @[Top.scala 137:19]
  assign icache_waddr = memory_io_icache_waddr; // @[Top.scala 139:19]
  assign icache_wdata = memory_io_icache_wdata; // @[Top.scala 140:19]
  assign icache_valid_clock = clock; // @[Top.scala 142:25]
  assign icache_valid_ren = memory_io_icache_valid_ren; // @[Top.scala 143:23]
  assign icache_valid_wen = memory_io_icache_valid_wen; // @[Top.scala 144:23]
  assign icache_valid_ien = memory_io_icache_valid_invalidate; // @[Top.scala 151:23]
  assign icache_valid_invalidate = memory_io_icache_valid_invalidate; // @[Top.scala 145:30]
  assign icache_valid_addr = memory_io_icache_valid_addr; // @[Top.scala 146:24]
  assign icache_valid_iaddr = memory_io_icache_valid_iaddr; // @[Top.scala 147:25]
  assign icache_valid_wdata = memory_io_icache_valid_wdata; // @[Top.scala 149:25]
  assign icache_valid_idata = 64'h0; // @[Top.scala 150:25]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = dmem_decoder_io_targets_2_wen; // @[Top.scala 100:30]
  assign gpio_io_mem_wdata = dmem_decoder_io_targets_2_wdata; // @[Top.scala 100:30]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = dmem_decoder_io_targets_3_raddr; // @[Top.scala 101:30]
  assign uart_io_mem_ren = dmem_decoder_io_targets_3_ren; // @[Top.scala 101:30]
  assign uart_io_mem_waddr = dmem_decoder_io_targets_3_waddr; // @[Top.scala 101:30]
  assign uart_io_mem_wen = dmem_decoder_io_targets_3_wen; // @[Top.scala 101:30]
  assign uart_io_mem_wdata = dmem_decoder_io_targets_3_wdata; // @[Top.scala 101:30]
  assign uart_io_rx = io_uart_rx; // @[Top.scala 186:14]
  assign sdc_clock = clock;
  assign sdc_reset = reset;
  assign sdc_io_mem_raddr = dmem_decoder_io_targets_5_raddr; // @[Top.scala 103:30]
  assign sdc_io_mem_ren = dmem_decoder_io_targets_5_ren; // @[Top.scala 103:30]
  assign sdc_io_mem_waddr = dmem_decoder_io_targets_5_waddr; // @[Top.scala 103:30]
  assign sdc_io_mem_wen = dmem_decoder_io_targets_5_wen; // @[Top.scala 103:30]
  assign sdc_io_mem_wdata = dmem_decoder_io_targets_5_wdata; // @[Top.scala 103:30]
  assign sdc_io_sdc_port_res_in = io_sdc_port_res_in; // @[Top.scala 188:15]
  assign sdc_io_sdc_port_dat_in = io_sdc_port_dat_in; // @[Top.scala 188:15]
  assign sdc_io_sdbuf_rdata1 = sdbuf_rdata1; // @[Top.scala 195:23]
  assign sdc_io_sdbuf_rdata2 = sdbuf_rdata2; // @[Top.scala 200:23]
  assign sdbuf_clock = clock; // @[Top.scala 190:19]
  assign sdbuf_ren1 = sdc_io_sdbuf_ren1; // @[Top.scala 191:19]
  assign sdbuf_wen1 = sdc_io_sdbuf_wen1; // @[Top.scala 192:19]
  assign sdbuf_addr1 = sdc_io_sdbuf_addr1; // @[Top.scala 193:19]
  assign sdbuf_wdata1 = sdc_io_sdbuf_wdata1; // @[Top.scala 194:19]
  assign sdbuf_ren2 = sdc_io_sdbuf_ren2; // @[Top.scala 196:19]
  assign sdbuf_wen2 = sdc_io_sdbuf_wen2; // @[Top.scala 197:19]
  assign sdbuf_addr2 = sdc_io_sdbuf_addr2; // @[Top.scala 198:19]
  assign sdbuf_wdata2 = sdc_io_sdbuf_wdata2; // @[Top.scala 199:19]
  assign config__io_mem_raddr = dmem_decoder_io_targets_6_raddr; // @[Top.scala 104:30]
  assign dmem_decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 114:16]
  assign dmem_decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 114:16]
  assign dmem_decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 114:16]
  assign dmem_decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 114:16]
  assign dmem_decoder_io_initiator_wstrb = core_io_dmem_wstrb; // @[Top.scala 114:16]
  assign dmem_decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 114:16]
  assign dmem_decoder_io_targets_0_rdata = boot_rom_io_dmem_rdata; // @[Top.scala 98:30]
  assign dmem_decoder_io_targets_0_rvalid = boot_rom_io_dmem_rvalid; // @[Top.scala 98:30]
  assign dmem_decoder_io_targets_1_rdata = memory_io_dmem_rdata; // @[Top.scala 99:30]
  assign dmem_decoder_io_targets_1_rvalid = memory_io_dmem_rvalid; // @[Top.scala 99:30]
  assign dmem_decoder_io_targets_1_wready = memory_io_dmem_wready; // @[Top.scala 99:30]
  assign dmem_decoder_io_targets_3_rdata = uart_io_mem_rdata; // @[Top.scala 101:30]
  assign dmem_decoder_io_targets_4_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 102:30]
  assign dmem_decoder_io_targets_4_rvalid = core_io_mtimer_mem_rvalid; // @[Top.scala 102:30]
  assign dmem_decoder_io_targets_5_rdata = sdc_io_mem_rdata; // @[Top.scala 103:30]
  assign dmem_decoder_io_targets_6_rdata = config__io_mem_rdata; // @[Top.scala 104:30]
  assign imem_decoder_clock = clock;
  assign imem_decoder_io_initiator_addr = core_io_imem_addr; // @[Top.scala 113:16]
  assign imem_decoder_io_targets_0_inst = boot_rom_io_imem_inst; // @[Top.scala 110:30]
  assign imem_decoder_io_targets_0_valid = boot_rom_io_imem_valid; // @[Top.scala 110:30]
  assign imem_decoder_io_targets_1_inst = memory_io_imem_inst; // @[Top.scala 111:30]
  assign imem_decoder_io_targets_1_valid = memory_io_imem_valid; // @[Top.scala 111:30]
endmodule
