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
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
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
`endif // RANDOMIZE_REG_INIT
  reg [1:0] bp_cache_hist [0:255]; // @[BranchPredictor.scala 29:26]
  wire  bp_cache_hist_bp_reg_rd_hist_MPORT_en; // @[BranchPredictor.scala 29:26]
  wire [7:0] bp_cache_hist_bp_reg_rd_hist_MPORT_addr; // @[BranchPredictor.scala 29:26]
  wire [1:0] bp_cache_hist_bp_reg_rd_hist_MPORT_data; // @[BranchPredictor.scala 29:26]
  wire  bp_cache_hist_bp_reg_update_rd_hist_MPORT_en; // @[BranchPredictor.scala 29:26]
  wire [7:0] bp_cache_hist_bp_reg_update_rd_hist_MPORT_addr; // @[BranchPredictor.scala 29:26]
  wire [1:0] bp_cache_hist_bp_reg_update_rd_hist_MPORT_data; // @[BranchPredictor.scala 29:26]
  wire [1:0] bp_cache_hist_MPORT_data; // @[BranchPredictor.scala 29:26]
  wire [7:0] bp_cache_hist_MPORT_addr; // @[BranchPredictor.scala 29:26]
  wire  bp_cache_hist_MPORT_mask; // @[BranchPredictor.scala 29:26]
  wire  bp_cache_hist_MPORT_en; // @[BranchPredictor.scala 29:26]
  reg [22:0] bp_cache_tag [0:255]; // @[BranchPredictor.scala 30:26]
  wire  bp_cache_tag_bp_reg_rd_tag_MPORT_en; // @[BranchPredictor.scala 30:26]
  wire [7:0] bp_cache_tag_bp_reg_rd_tag_MPORT_addr; // @[BranchPredictor.scala 30:26]
  wire [22:0] bp_cache_tag_bp_reg_rd_tag_MPORT_data; // @[BranchPredictor.scala 30:26]
  wire  bp_cache_tag_bp_reg_update_rd_tag_MPORT_en; // @[BranchPredictor.scala 30:26]
  wire [7:0] bp_cache_tag_bp_reg_update_rd_tag_MPORT_addr; // @[BranchPredictor.scala 30:26]
  wire [22:0] bp_cache_tag_bp_reg_update_rd_tag_MPORT_data; // @[BranchPredictor.scala 30:26]
  wire [22:0] bp_cache_tag_MPORT_1_data; // @[BranchPredictor.scala 30:26]
  wire [7:0] bp_cache_tag_MPORT_1_addr; // @[BranchPredictor.scala 30:26]
  wire  bp_cache_tag_MPORT_1_mask; // @[BranchPredictor.scala 30:26]
  wire  bp_cache_tag_MPORT_1_en; // @[BranchPredictor.scala 30:26]
  reg [31:0] bp_cache_br [0:255]; // @[BranchPredictor.scala 31:26]
  wire  bp_cache_br_bp_reg_rd_br_MPORT_en; // @[BranchPredictor.scala 31:26]
  wire [7:0] bp_cache_br_bp_reg_rd_br_MPORT_addr; // @[BranchPredictor.scala 31:26]
  wire [31:0] bp_cache_br_bp_reg_rd_br_MPORT_data; // @[BranchPredictor.scala 31:26]
  wire  bp_cache_br_bp_reg_update_rd_br_MPORT_en; // @[BranchPredictor.scala 31:26]
  wire [7:0] bp_cache_br_bp_reg_update_rd_br_MPORT_addr; // @[BranchPredictor.scala 31:26]
  wire [31:0] bp_cache_br_bp_reg_update_rd_br_MPORT_data; // @[BranchPredictor.scala 31:26]
  wire [31:0] bp_cache_br_MPORT_2_data; // @[BranchPredictor.scala 31:26]
  wire [7:0] bp_cache_br_MPORT_2_addr; // @[BranchPredictor.scala 31:26]
  wire  bp_cache_br_MPORT_2_mask; // @[BranchPredictor.scala 31:26]
  wire  bp_cache_br_MPORT_2_en; // @[BranchPredictor.scala 31:26]
  reg [1:0] bp_reg_rd_hist; // @[BranchPredictor.scala 36:31]
  reg [22:0] bp_reg_rd_tag; // @[BranchPredictor.scala 37:31]
  reg [31:0] bp_reg_rd_br; // @[BranchPredictor.scala 38:31]
  reg [22:0] bp_reg_tag; // @[BranchPredictor.scala 39:31]
  wire  bp_cache_do_br = bp_reg_rd_hist[1]; // @[BranchPredictor.scala 46:38]
  reg  bp_reg_update_pos; // @[BranchPredictor.scala 52:38]
  reg [31:0] bp_reg_update_br_addr; // @[BranchPredictor.scala 53:38]
  reg [1:0] bp_reg_update_rd_hist; // @[BranchPredictor.scala 54:38]
  reg [22:0] bp_reg_update_rd_tag; // @[BranchPredictor.scala 55:38]
  reg [31:0] bp_reg_update_rd_br; // @[BranchPredictor.scala 56:38]
  reg  bp_reg_update_write; // @[BranchPredictor.scala 57:38]
  reg [22:0] bp_reg_update_tag; // @[BranchPredictor.scala 58:38]
  reg [7:0] bp_reg_update_index; // @[BranchPredictor.scala 59:38]
  reg  bp_reg_write_en; // @[BranchPredictor.scala 60:38]
  reg [7:0] bp_reg_write_index; // @[BranchPredictor.scala 61:38]
  reg [1:0] bp_reg_write_hist; // @[BranchPredictor.scala 62:38]
  reg [22:0] bp_reg_write_tag; // @[BranchPredictor.scala 63:38]
  reg [31:0] bp_reg_write_br_addr; // @[BranchPredictor.scala 64:38]
  wire [7:0] bp_update_index = io_up_inst_pc[8:1]; // @[BranchPredictor.scala 70:38]
  wire  _bp_update_hist_T_2 = bp_reg_update_pos & bp_reg_update_rd_hist == 2'h3; // @[BranchPredictor.scala 74:26]
  wire [1:0] _bp_update_hist_T_4 = bp_reg_update_rd_hist + 2'h1; // @[BranchPredictor.scala 75:87]
  wire  _bp_update_hist_T_5 = ~bp_reg_update_pos; // @[BranchPredictor.scala 76:8]
  wire  _bp_update_hist_T_7 = ~bp_reg_update_pos & bp_reg_update_rd_hist == 2'h0; // @[BranchPredictor.scala 76:27]
  wire [1:0] _bp_update_hist_T_10 = bp_reg_update_rd_hist - 2'h1; // @[BranchPredictor.scala 77:87]
  wire [1:0] _bp_update_hist_T_11 = _bp_update_hist_T_5 ? _bp_update_hist_T_10 : 2'h0; // @[Mux.scala 101:16]
  wire [1:0] _bp_update_hist_T_12 = _bp_update_hist_T_7 ? 2'h0 : _bp_update_hist_T_11; // @[Mux.scala 101:16]
  wire  _T = ~io_up_update_en; // @[BranchPredictor.scala 93:8]
  assign bp_cache_hist_bp_reg_rd_hist_MPORT_en = 1'h1;
  assign bp_cache_hist_bp_reg_rd_hist_MPORT_addr = io_lu_inst_pc[8:1];
  assign bp_cache_hist_bp_reg_rd_hist_MPORT_data = bp_cache_hist[bp_cache_hist_bp_reg_rd_hist_MPORT_addr]; // @[BranchPredictor.scala 29:26]
  assign bp_cache_hist_bp_reg_update_rd_hist_MPORT_en = io_up_update_en;
  assign bp_cache_hist_bp_reg_update_rd_hist_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_hist_bp_reg_update_rd_hist_MPORT_data = bp_cache_hist[bp_cache_hist_bp_reg_update_rd_hist_MPORT_addr]; // @[BranchPredictor.scala 29:26]
  assign bp_cache_hist_MPORT_data = bp_reg_write_hist;
  assign bp_cache_hist_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_hist_MPORT_mask = 1'h1;
  assign bp_cache_hist_MPORT_en = _T & bp_reg_write_en;
  assign bp_cache_tag_bp_reg_rd_tag_MPORT_en = 1'h1;
  assign bp_cache_tag_bp_reg_rd_tag_MPORT_addr = io_lu_inst_pc[8:1];
  assign bp_cache_tag_bp_reg_rd_tag_MPORT_data = bp_cache_tag[bp_cache_tag_bp_reg_rd_tag_MPORT_addr]; // @[BranchPredictor.scala 30:26]
  assign bp_cache_tag_bp_reg_update_rd_tag_MPORT_en = io_up_update_en;
  assign bp_cache_tag_bp_reg_update_rd_tag_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_tag_bp_reg_update_rd_tag_MPORT_data = bp_cache_tag[bp_cache_tag_bp_reg_update_rd_tag_MPORT_addr]; // @[BranchPredictor.scala 30:26]
  assign bp_cache_tag_MPORT_1_data = bp_reg_write_tag;
  assign bp_cache_tag_MPORT_1_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_tag_MPORT_1_mask = 1'h1;
  assign bp_cache_tag_MPORT_1_en = _T & bp_reg_write_en;
  assign bp_cache_br_bp_reg_rd_br_MPORT_en = 1'h1;
  assign bp_cache_br_bp_reg_rd_br_MPORT_addr = io_lu_inst_pc[8:1];
  assign bp_cache_br_bp_reg_rd_br_MPORT_data = bp_cache_br[bp_cache_br_bp_reg_rd_br_MPORT_addr]; // @[BranchPredictor.scala 31:26]
  assign bp_cache_br_bp_reg_update_rd_br_MPORT_en = io_up_update_en;
  assign bp_cache_br_bp_reg_update_rd_br_MPORT_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_br_bp_reg_update_rd_br_MPORT_data = bp_cache_br[bp_cache_br_bp_reg_update_rd_br_MPORT_addr]; // @[BranchPredictor.scala 31:26]
  assign bp_cache_br_MPORT_2_data = bp_reg_write_br_addr;
  assign bp_cache_br_MPORT_2_addr = io_up_update_en ? bp_update_index : bp_reg_write_index;
  assign bp_cache_br_MPORT_2_mask = 1'h1;
  assign bp_cache_br_MPORT_2_en = _T & bp_reg_write_en;
  assign io_lu_br_hit = bp_reg_tag == bp_reg_rd_tag; // @[BranchPredictor.scala 47:30]
  assign io_lu_br_pos = bp_cache_do_br & io_lu_br_hit; // @[BranchPredictor.scala 48:34]
  assign io_lu_br_addr = io_lu_br_pos ? bp_reg_rd_br : 32'h0; // @[BranchPredictor.scala 49:23]
  always @(posedge clock) begin
    if (bp_cache_hist_MPORT_en & bp_cache_hist_MPORT_mask) begin
      bp_cache_hist[bp_cache_hist_MPORT_addr] <= bp_cache_hist_MPORT_data; // @[BranchPredictor.scala 29:26]
    end
    if (bp_cache_tag_MPORT_1_en & bp_cache_tag_MPORT_1_mask) begin
      bp_cache_tag[bp_cache_tag_MPORT_1_addr] <= bp_cache_tag_MPORT_1_data; // @[BranchPredictor.scala 30:26]
    end
    if (bp_cache_br_MPORT_2_en & bp_cache_br_MPORT_2_mask) begin
      bp_cache_br[bp_cache_br_MPORT_2_addr] <= bp_cache_br_MPORT_2_data; // @[BranchPredictor.scala 31:26]
    end
    if (reset) begin // @[BranchPredictor.scala 36:31]
      bp_reg_rd_hist <= 2'h0; // @[BranchPredictor.scala 36:31]
    end else begin
      bp_reg_rd_hist <= bp_cache_hist_bp_reg_rd_hist_MPORT_data; // @[BranchPredictor.scala 43:18]
    end
    if (reset) begin // @[BranchPredictor.scala 37:31]
      bp_reg_rd_tag <= 23'h0; // @[BranchPredictor.scala 37:31]
    end else begin
      bp_reg_rd_tag <= bp_cache_tag_bp_reg_rd_tag_MPORT_data; // @[BranchPredictor.scala 44:17]
    end
    if (reset) begin // @[BranchPredictor.scala 38:31]
      bp_reg_rd_br <= 32'h0; // @[BranchPredictor.scala 38:31]
    end else begin
      bp_reg_rd_br <= bp_cache_br_bp_reg_rd_br_MPORT_data; // @[BranchPredictor.scala 45:16]
    end
    if (reset) begin // @[BranchPredictor.scala 39:31]
      bp_reg_tag <= 23'h0; // @[BranchPredictor.scala 39:31]
    end else begin
      bp_reg_tag <= io_lu_inst_pc[31:9]; // @[BranchPredictor.scala 41:14]
    end
    if (reset) begin // @[BranchPredictor.scala 52:38]
      bp_reg_update_pos <= 1'h0; // @[BranchPredictor.scala 52:38]
    end else begin
      bp_reg_update_pos <= io_up_br_pos; // @[BranchPredictor.scala 66:21]
    end
    if (reset) begin // @[BranchPredictor.scala 53:38]
      bp_reg_update_br_addr <= 32'h0; // @[BranchPredictor.scala 53:38]
    end else begin
      bp_reg_update_br_addr <= io_up_br_addr; // @[BranchPredictor.scala 67:25]
    end
    if (reset) begin // @[BranchPredictor.scala 54:38]
      bp_reg_update_rd_hist <= 2'h0; // @[BranchPredictor.scala 54:38]
    end else if (io_up_update_en) begin // @[BranchPredictor.scala 88:25]
      bp_reg_update_rd_hist <= bp_cache_hist_bp_reg_update_rd_hist_MPORT_data; // @[BranchPredictor.scala 89:27]
    end
    if (reset) begin // @[BranchPredictor.scala 55:38]
      bp_reg_update_rd_tag <= 23'h0; // @[BranchPredictor.scala 55:38]
    end else if (io_up_update_en) begin // @[BranchPredictor.scala 88:25]
      bp_reg_update_rd_tag <= bp_cache_tag_bp_reg_update_rd_tag_MPORT_data; // @[BranchPredictor.scala 90:27]
    end
    if (reset) begin // @[BranchPredictor.scala 56:38]
      bp_reg_update_rd_br <= 32'h0; // @[BranchPredictor.scala 56:38]
    end else if (io_up_update_en) begin // @[BranchPredictor.scala 88:25]
      bp_reg_update_rd_br <= bp_cache_br_bp_reg_update_rd_br_MPORT_data; // @[BranchPredictor.scala 91:27]
    end
    if (reset) begin // @[BranchPredictor.scala 57:38]
      bp_reg_update_write <= 1'h0; // @[BranchPredictor.scala 57:38]
    end else begin
      bp_reg_update_write <= io_up_update_en; // @[BranchPredictor.scala 65:23]
    end
    if (reset) begin // @[BranchPredictor.scala 58:38]
      bp_reg_update_tag <= 23'h0; // @[BranchPredictor.scala 58:38]
    end else begin
      bp_reg_update_tag <= io_up_inst_pc[31:9]; // @[BranchPredictor.scala 69:21]
    end
    if (reset) begin // @[BranchPredictor.scala 59:38]
      bp_reg_update_index <= 8'h0; // @[BranchPredictor.scala 59:38]
    end else begin
      bp_reg_update_index <= bp_update_index; // @[BranchPredictor.scala 71:23]
    end
    if (reset) begin // @[BranchPredictor.scala 60:38]
      bp_reg_write_en <= 1'h0; // @[BranchPredictor.scala 60:38]
    end else begin
      bp_reg_write_en <= bp_reg_update_write; // @[BranchPredictor.scala 82:24]
    end
    if (reset) begin // @[BranchPredictor.scala 61:38]
      bp_reg_write_index <= 8'h0; // @[BranchPredictor.scala 61:38]
    end else begin
      bp_reg_write_index <= bp_reg_update_index; // @[BranchPredictor.scala 83:24]
    end
    if (reset) begin // @[BranchPredictor.scala 62:38]
      bp_reg_write_hist <= 2'h0; // @[BranchPredictor.scala 62:38]
    end else if (bp_reg_update_rd_tag == bp_reg_update_tag) begin // @[BranchPredictor.scala 72:27]
      if (_bp_update_hist_T_2) begin // @[Mux.scala 101:16]
        bp_reg_write_hist <= 2'h3;
      end else if (bp_reg_update_pos) begin // @[Mux.scala 101:16]
        bp_reg_write_hist <= _bp_update_hist_T_4;
      end else begin
        bp_reg_write_hist <= _bp_update_hist_T_12;
      end
    end else if (bp_reg_update_pos) begin // @[BranchPredictor.scala 79:8]
      bp_reg_write_hist <= 2'h2;
    end else begin
      bp_reg_write_hist <= 2'h1;
    end
    if (reset) begin // @[BranchPredictor.scala 63:38]
      bp_reg_write_tag <= 23'h0; // @[BranchPredictor.scala 63:38]
    end else begin
      bp_reg_write_tag <= bp_reg_update_tag; // @[BranchPredictor.scala 85:24]
    end
    if (reset) begin // @[BranchPredictor.scala 64:38]
      bp_reg_write_br_addr <= 32'h0; // @[BranchPredictor.scala 64:38]
    end else if (bp_reg_update_pos) begin // @[BranchPredictor.scala 81:35]
      bp_reg_write_br_addr <= bp_reg_update_br_addr;
    end else begin
      bp_reg_write_br_addr <= bp_reg_update_rd_br;
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
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    bp_cache_hist[initvar] = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    bp_cache_tag[initvar] = _RAND_1[22:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    bp_cache_br[initvar] = _RAND_2[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  bp_reg_rd_hist = _RAND_3[1:0];
  _RAND_4 = {1{`RANDOM}};
  bp_reg_rd_tag = _RAND_4[22:0];
  _RAND_5 = {1{`RANDOM}};
  bp_reg_rd_br = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  bp_reg_tag = _RAND_6[22:0];
  _RAND_7 = {1{`RANDOM}};
  bp_reg_update_pos = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  bp_reg_update_br_addr = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  bp_reg_update_rd_hist = _RAND_9[1:0];
  _RAND_10 = {1{`RANDOM}};
  bp_reg_update_rd_tag = _RAND_10[22:0];
  _RAND_11 = {1{`RANDOM}};
  bp_reg_update_rd_br = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  bp_reg_update_write = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  bp_reg_update_tag = _RAND_13[22:0];
  _RAND_14 = {1{`RANDOM}};
  bp_reg_update_index = _RAND_14[7:0];
  _RAND_15 = {1{`RANDOM}};
  bp_reg_write_en = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  bp_reg_write_index = _RAND_16[7:0];
  _RAND_17 = {1{`RANDOM}};
  bp_reg_write_hist = _RAND_17[1:0];
  _RAND_18 = {1{`RANDOM}};
  bp_reg_write_tag = _RAND_18[22:0];
  _RAND_19 = {1{`RANDOM}};
  bp_reg_write_br_addr = _RAND_19[31:0];
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
  input         io_dmem_rready,
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
  input         io_intr,
  output        io_exit,
  output [31:0] io_debug_signal_mem_reg_pc,
  output        io_debug_signal_mem_is_valid_inst,
  output [31:0] io_debug_signal_csr_rdata,
  output [11:0] io_debug_signal_mem_reg_csr_addr,
  output        io_debug_signal_me_intr,
  output [63:0] io_debug_signal_cycle_counter,
  output [63:0] io_debug_signal_instret
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
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[Core.scala 64:20]
  wire  regfile_id_rs1_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_rs1_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_rs1_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_id_rs2_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_rs2_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_rs2_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_id_c_rs1_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_c_rs1_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_c_rs1_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_id_c_rs2_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_c_rs2_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_c_rs2_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_id_c_rs1p_data_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_c_rs1p_data_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_c_rs1p_data_data; // @[Core.scala 64:20]
  wire  regfile_id_c_rs2p_data_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_c_rs2p_data_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_c_rs2p_data_data; // @[Core.scala 64:20]
  wire  regfile_id_sp_data_en; // @[Core.scala 64:20]
  wire [4:0] regfile_id_sp_data_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_id_sp_data_data; // @[Core.scala 64:20]
  wire  regfile_ex1_op1_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_ex1_op1_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_ex1_op1_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_ex1_op2_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_ex1_op2_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_ex1_op2_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_ex1_rs2_data_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_ex1_rs2_data_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_ex1_rs2_data_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_io_gp_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_io_gp_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_io_gp_MPORT_data; // @[Core.scala 64:20]
  wire  regfile_do_exit_MPORT_en; // @[Core.scala 64:20]
  wire [4:0] regfile_do_exit_MPORT_addr; // @[Core.scala 64:20]
  wire [31:0] regfile_do_exit_MPORT_data; // @[Core.scala 64:20]
  wire [31:0] regfile_MPORT_data; // @[Core.scala 64:20]
  wire [4:0] regfile_MPORT_addr; // @[Core.scala 64:20]
  wire  regfile_MPORT_mask; // @[Core.scala 64:20]
  wire  regfile_MPORT_en; // @[Core.scala 64:20]
  wire  cycle_counter_clock; // @[Core.scala 67:29]
  wire  cycle_counter_reset; // @[Core.scala 67:29]
  wire [63:0] cycle_counter_io_value; // @[Core.scala 67:29]
  wire  mtimer_clock; // @[Core.scala 68:22]
  wire  mtimer_reset; // @[Core.scala 68:22]
  wire [31:0] mtimer_io_mem_raddr; // @[Core.scala 68:22]
  wire [31:0] mtimer_io_mem_rdata; // @[Core.scala 68:22]
  wire  mtimer_io_mem_ren; // @[Core.scala 68:22]
  wire  mtimer_io_mem_rvalid; // @[Core.scala 68:22]
  wire [31:0] mtimer_io_mem_waddr; // @[Core.scala 68:22]
  wire  mtimer_io_mem_wen; // @[Core.scala 68:22]
  wire [31:0] mtimer_io_mem_wdata; // @[Core.scala 68:22]
  wire  mtimer_io_intr; // @[Core.scala 68:22]
  wire [63:0] mtimer_io_mtime; // @[Core.scala 68:22]
  wire  bp_clock; // @[Core.scala 320:18]
  wire  bp_reset; // @[Core.scala 320:18]
  wire [31:0] bp_io_lu_inst_pc; // @[Core.scala 320:18]
  wire  bp_io_lu_br_hit; // @[Core.scala 320:18]
  wire  bp_io_lu_br_pos; // @[Core.scala 320:18]
  wire [31:0] bp_io_lu_br_addr; // @[Core.scala 320:18]
  wire  bp_io_up_update_en; // @[Core.scala 320:18]
  wire [31:0] bp_io_up_inst_pc; // @[Core.scala 320:18]
  wire  bp_io_up_br_pos; // @[Core.scala 320:18]
  wire [31:0] bp_io_up_br_addr; // @[Core.scala 320:18]
  reg [31:0] csr_trap_vector; // @[Core.scala 66:32]
  reg [63:0] instret; // @[Core.scala 69:24]
  reg [31:0] csr_mcause; // @[Core.scala 70:29]
  reg [31:0] csr_mepc; // @[Core.scala 72:29]
  reg [31:0] csr_mstatus; // @[Core.scala 73:29]
  reg [31:0] csr_mscratch; // @[Core.scala 74:29]
  reg [31:0] csr_mie; // @[Core.scala 75:29]
  reg [31:0] csr_mip; // @[Core.scala 76:29]
  reg [31:0] id_reg_pc; // @[Core.scala 84:38]
  reg [31:0] id_reg_inst; // @[Core.scala 86:38]
  reg  id_reg_stall; // @[Core.scala 87:38]
  reg  id_reg_is_bp_pos; // @[Core.scala 88:38]
  reg [31:0] id_reg_bp_addr; // @[Core.scala 89:38]
  reg [31:0] ex1_reg_pc; // @[Core.scala 95:38]
  reg [4:0] ex1_reg_wb_addr; // @[Core.scala 96:38]
  reg [2:0] ex1_reg_op1_sel; // @[Core.scala 97:38]
  reg [3:0] ex1_reg_op2_sel; // @[Core.scala 98:38]
  reg [4:0] ex1_reg_rs1_addr; // @[Core.scala 99:38]
  reg [4:0] ex1_reg_rs2_addr; // @[Core.scala 100:38]
  reg [31:0] ex1_reg_op1_data; // @[Core.scala 101:38]
  reg [31:0] ex1_reg_op2_data; // @[Core.scala 102:38]
  reg [4:0] ex1_reg_exe_fun; // @[Core.scala 104:38]
  reg [1:0] ex1_reg_mem_wen; // @[Core.scala 105:38]
  reg [1:0] ex1_reg_rf_wen; // @[Core.scala 106:38]
  reg [2:0] ex1_reg_wb_sel; // @[Core.scala 107:38]
  reg [11:0] ex1_reg_csr_addr; // @[Core.scala 108:38]
  reg [2:0] ex1_reg_csr_cmd; // @[Core.scala 109:38]
  reg [31:0] ex1_reg_imm_b_sext; // @[Core.scala 112:38]
  reg [31:0] ex1_reg_mem_w; // @[Core.scala 115:38]
  reg  ex1_reg_is_j; // @[Core.scala 116:39]
  reg  ex1_reg_is_bp_pos; // @[Core.scala 117:39]
  reg [31:0] ex1_reg_bp_addr; // @[Core.scala 118:39]
  reg  ex1_reg_is_half; // @[Core.scala 119:39]
  reg  ex1_reg_is_valid_inst; // @[Core.scala 120:39]
  reg  ex1_reg_is_trap; // @[Core.scala 121:39]
  reg [31:0] ex1_reg_mcause; // @[Core.scala 122:39]
  reg [31:0] ex2_reg_pc; // @[Core.scala 126:38]
  reg [4:0] ex2_reg_wb_addr; // @[Core.scala 127:38]
  reg [31:0] ex2_reg_op1_data; // @[Core.scala 128:38]
  reg [31:0] ex2_reg_op2_data; // @[Core.scala 129:38]
  reg [31:0] ex2_reg_rs2_data; // @[Core.scala 130:38]
  reg [4:0] ex2_reg_exe_fun; // @[Core.scala 131:38]
  reg [1:0] ex2_reg_mem_wen; // @[Core.scala 132:38]
  reg [1:0] ex2_reg_rf_wen; // @[Core.scala 133:38]
  reg [2:0] ex2_reg_wb_sel; // @[Core.scala 134:38]
  reg [11:0] ex2_reg_csr_addr; // @[Core.scala 135:38]
  reg [2:0] ex2_reg_csr_cmd; // @[Core.scala 136:38]
  reg [31:0] ex2_reg_imm_b_sext; // @[Core.scala 137:38]
  reg [31:0] ex2_reg_mem_w; // @[Core.scala 138:38]
  reg  ex2_reg_is_j; // @[Core.scala 139:38]
  reg  ex2_reg_is_bp_pos; // @[Core.scala 140:38]
  reg [31:0] ex2_reg_bp_addr; // @[Core.scala 141:38]
  reg  ex2_reg_is_half; // @[Core.scala 142:38]
  reg  ex2_reg_is_valid_inst; // @[Core.scala 143:38]
  reg  ex2_reg_is_trap; // @[Core.scala 144:38]
  reg [31:0] ex2_reg_mcause; // @[Core.scala 145:38]
  reg  ex3_reg_bp_en; // @[Core.scala 149:41]
  reg [31:0] ex3_reg_pc; // @[Core.scala 150:41]
  reg  ex3_reg_is_cond_br; // @[Core.scala 151:41]
  reg  ex3_reg_is_cond_br_inst; // @[Core.scala 152:41]
  reg  ex3_reg_is_uncond_br; // @[Core.scala 153:41]
  reg [31:0] ex3_reg_cond_br_target; // @[Core.scala 154:41]
  reg [31:0] ex3_reg_uncond_br_target; // @[Core.scala 155:41]
  reg  ex3_reg_is_bp_pos; // @[Core.scala 157:41]
  reg [31:0] ex3_reg_bp_addr; // @[Core.scala 158:41]
  reg  ex3_reg_is_half; // @[Core.scala 159:41]
  reg  mem_reg_en; // @[Core.scala 162:38]
  reg [31:0] mem_reg_pc; // @[Core.scala 163:38]
  reg [4:0] mem_reg_wb_addr; // @[Core.scala 164:38]
  reg [31:0] mem_reg_op1_data; // @[Core.scala 165:38]
  reg [31:0] mem_reg_rs2_data; // @[Core.scala 166:38]
  reg [1:0] mem_reg_mem_wen; // @[Core.scala 167:38]
  reg [1:0] mem_reg_rf_wen; // @[Core.scala 168:38]
  reg [2:0] mem_reg_wb_sel; // @[Core.scala 169:38]
  reg [11:0] mem_reg_csr_addr; // @[Core.scala 170:38]
  reg [2:0] mem_reg_csr_cmd; // @[Core.scala 171:38]
  reg [31:0] mem_reg_alu_out; // @[Core.scala 173:38]
  reg [31:0] mem_reg_mem_w; // @[Core.scala 174:38]
  reg [3:0] mem_reg_mem_wstrb; // @[Core.scala 175:38]
  reg  mem_reg_is_half; // @[Core.scala 176:38]
  reg  mem_reg_is_valid_inst; // @[Core.scala 177:38]
  reg  mem_reg_is_trap; // @[Core.scala 178:38]
  reg [31:0] mem_reg_mcause; // @[Core.scala 179:38]
  reg [4:0] wb_reg_wb_addr; // @[Core.scala 183:38]
  reg [1:0] wb_reg_rf_wen; // @[Core.scala 184:38]
  reg [31:0] wb_reg_wb_data; // @[Core.scala 185:38]
  reg  wb_reg_is_valid_inst; // @[Core.scala 186:38]
  reg  if2_reg_is_bp_pos; // @[Core.scala 188:35]
  reg [31:0] if2_reg_bp_addr; // @[Core.scala 189:35]
  reg  ex3_reg_is_br; // @[Core.scala 193:35]
  reg [31:0] ex3_reg_br_target; // @[Core.scala 194:35]
  reg  mem_reg_is_br; // @[Core.scala 197:35]
  reg [31:0] mem_reg_br_addr; // @[Core.scala 198:35]
  reg  ic_reg_read_rdy; // @[Core.scala 207:32]
  reg  ic_reg_half_rdy; // @[Core.scala 208:32]
  reg [31:0] ic_reg_imem_addr; // @[Core.scala 210:33]
  reg [31:0] ic_reg_addr_out; // @[Core.scala 211:32]
  reg [31:0] ic_reg_inst; // @[Core.scala 213:34]
  reg [31:0] ic_reg_inst_addr; // @[Core.scala 214:34]
  reg [31:0] ic_reg_inst2; // @[Core.scala 215:34]
  reg [31:0] ic_reg_inst2_addr; // @[Core.scala 216:34]
  reg [2:0] ic_state; // @[Core.scala 218:25]
  wire [31:0] ic_imem_addr_2 = {ic_reg_imem_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] ic_imem_addr_4 = ic_reg_imem_addr + 32'h4; // @[Core.scala 221:41]
  wire [31:0] ic_inst_addr_2 = {ic_reg_inst_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  reg  if1_reg_first; // @[Core.scala 326:30]
  wire [31:0] _if1_jump_addr_T = if1_reg_first ? 32'h8000000 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_1 = if2_reg_is_bp_pos ? if2_reg_bp_addr : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_2 = ex3_reg_is_br ? ex3_reg_br_target : _if1_jump_addr_T_1; // @[Mux.scala 101:16]
  wire [31:0] if1_jump_addr = mem_reg_is_br ? mem_reg_br_addr : _if1_jump_addr_T_2; // @[Mux.scala 101:16]
  wire [31:0] ic_next_imem_addr = {if1_jump_addr[31:2],2'h0}; // @[Cat.scala 31:58]
  wire  _ic_read_en4_T = ~id_reg_stall; // @[Core.scala 362:18]
  wire  _if1_is_jump_T = mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 340:35]
  wire  if1_is_jump = mem_reg_is_br | ex3_reg_is_br | if2_reg_is_bp_pos | if1_reg_first; // @[Core.scala 340:73]
  wire [30:0] _ic_data_out_T_2 = {15'h0,io_imem_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_5 = {io_imem_inst[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_8 = {ic_reg_inst2[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_27 = 3'h3 == ic_state ? _ic_data_out_T_8 : 32'h13; // @[Core.scala 227:15 240:23 301:21]
  wire [31:0] _GEN_34 = 3'h4 == ic_state ? _ic_data_out_T_5 : _GEN_27; // @[Core.scala 240:23 283:21]
  wire [31:0] _GEN_42 = 3'h2 == ic_state ? ic_reg_inst : _GEN_34; // @[Core.scala 240:23 271:21]
  wire [31:0] _GEN_54 = 3'h1 == ic_state ? {{1'd0}, _ic_data_out_T_2} : _GEN_42; // @[Core.scala 240:23 261:21]
  wire [31:0] _GEN_63 = 3'h0 == ic_state ? io_imem_inst : _GEN_54; // @[Core.scala 240:23 246:21]
  wire [31:0] _GEN_74 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? 32'h13 : _GEN_63; // @[Core.scala 227:15 236:94]
  wire [31:0] ic_data_out = if1_is_jump ? 32'h13 : _GEN_74; // @[Core.scala 227:15 229:21]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 360:41]
  wire  ic_read_en4 = ~id_reg_stall & ~is_half_inst; // @[Core.scala 362:32]
  wire [31:0] _GEN_0 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_addr_out; // @[Core.scala 251:34 252:27 211:32]
  wire [1:0] _GEN_1 = ic_read_en4 ? 2'h0 : 2'h2; // @[Core.scala 247:18 251:34 253:20]
  wire  ic_read_en2 = _ic_read_en4_T & is_half_inst; // @[Core.scala 361:32]
  wire [31:0] _GEN_2 = ic_read_en2 ? ic_imem_addr_2 : _GEN_0; // @[Core.scala 248:28 249:27]
  wire [2:0] _GEN_3 = ic_read_en2 ? 3'h4 : {{1'd0}, _GEN_1}; // @[Core.scala 248:28 250:20]
  wire [31:0] _GEN_4 = ic_read_en2 ? ic_imem_addr_4 : ic_imem_addr_2; // @[Core.scala 262:25 264:28 265:27]
  wire [2:0] _GEN_5 = ic_read_en2 ? 3'h0 : 3'h4; // @[Core.scala 263:18 264:28 266:20]
  wire [31:0] _GEN_6 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_addr_out; // @[Core.scala 275:33 276:27 211:32]
  wire [2:0] _GEN_7 = ic_read_en4 ? 3'h0 : ic_state; // @[Core.scala 275:33 277:20 218:25]
  wire [31:0] _GEN_8 = ic_read_en2 ? ic_inst_addr_2 : _GEN_6; // @[Core.scala 272:28 273:27]
  wire [2:0] _GEN_9 = ic_read_en2 ? 3'h4 : _GEN_7; // @[Core.scala 272:28 274:20]
  wire [31:0] _ic_reg_addr_out_T_1 = {ic_imem_addr_4[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_10 = ic_read_en4 ? io_imem_inst : ic_reg_inst; // @[Core.scala 292:33 293:23 213:34]
  wire [31:0] _GEN_11 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_inst_addr; // @[Core.scala 292:33 294:28 214:34]
  wire [31:0] _GEN_12 = ic_read_en4 ? _ic_reg_addr_out_T_1 : ic_reg_addr_out; // @[Core.scala 292:33 295:27 211:32]
  wire [2:0] _GEN_13 = ic_read_en4 ? 3'h4 : 3'h3; // @[Core.scala 286:18 292:33 296:20]
  wire [31:0] _GEN_14 = ic_read_en2 ? io_imem_inst : _GEN_10; // @[Core.scala 287:28 288:23]
  wire [31:0] _GEN_15 = ic_read_en2 ? ic_imem_addr_4 : _GEN_11; // @[Core.scala 287:28 289:28]
  wire [31:0] _GEN_16 = ic_read_en2 ? ic_imem_addr_4 : _GEN_12; // @[Core.scala 287:28 290:27]
  wire [2:0] _GEN_17 = ic_read_en2 ? 3'h2 : _GEN_13; // @[Core.scala 287:28 291:20]
  wire [31:0] _ic_reg_addr_out_T_3 = {ic_reg_inst2_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_18 = ic_read_en4 ? ic_reg_inst2 : ic_reg_inst; // @[Core.scala 307:33 308:23 213:34]
  wire [31:0] _GEN_19 = ic_read_en4 ? ic_reg_inst2_addr : ic_reg_inst_addr; // @[Core.scala 307:33 309:28 214:34]
  wire [31:0] _GEN_20 = ic_read_en4 ? _ic_reg_addr_out_T_3 : ic_reg_addr_out; // @[Core.scala 307:33 310:27 211:32]
  wire [2:0] _GEN_21 = ic_read_en4 ? 3'h4 : ic_state; // @[Core.scala 307:33 311:20 218:25]
  wire [31:0] _GEN_22 = ic_read_en2 ? ic_reg_inst2 : _GEN_18; // @[Core.scala 302:28 303:23]
  wire [31:0] _GEN_23 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_19; // @[Core.scala 302:28 304:28]
  wire [31:0] _GEN_24 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_20; // @[Core.scala 302:28 305:27]
  wire [2:0] _GEN_25 = ic_read_en2 ? 3'h2 : _GEN_21; // @[Core.scala 302:28 306:20]
  wire [31:0] _GEN_28 = 3'h3 == ic_state ? _GEN_22 : ic_reg_inst; // @[Core.scala 240:23 213:34]
  wire [31:0] _GEN_29 = 3'h3 == ic_state ? _GEN_23 : ic_reg_inst_addr; // @[Core.scala 240:23 214:34]
  wire [31:0] _GEN_30 = 3'h3 == ic_state ? _GEN_24 : ic_reg_addr_out; // @[Core.scala 240:23 211:32]
  wire [2:0] _GEN_31 = 3'h3 == ic_state ? _GEN_25 : ic_state; // @[Core.scala 240:23 218:25]
  wire [31:0] _GEN_32 = 3'h4 == ic_state ? ic_imem_addr_4 : ic_reg_imem_addr; // @[Core.scala 240:23 281:22]
  wire [31:0] _GEN_35 = 3'h4 == ic_state ? io_imem_inst : ic_reg_inst2; // @[Core.scala 240:23 284:22 215:34]
  wire [31:0] _GEN_36 = 3'h4 == ic_state ? ic_imem_addr_4 : ic_reg_inst2_addr; // @[Core.scala 240:23 285:27 216:34]
  wire [2:0] _GEN_37 = 3'h4 == ic_state ? _GEN_17 : _GEN_31; // @[Core.scala 240:23]
  wire [31:0] _GEN_38 = 3'h4 == ic_state ? _GEN_14 : _GEN_28; // @[Core.scala 240:23]
  wire [31:0] _GEN_39 = 3'h4 == ic_state ? _GEN_15 : _GEN_29; // @[Core.scala 240:23]
  wire [31:0] _GEN_40 = 3'h4 == ic_state ? _GEN_16 : _GEN_30; // @[Core.scala 240:23]
  wire [31:0] _GEN_41 = 3'h2 == ic_state ? ic_reg_imem_addr : _GEN_32; // @[Core.scala 240:23 270:22]
  wire [31:0] _GEN_43 = 3'h2 == ic_state ? _GEN_8 : _GEN_40; // @[Core.scala 240:23]
  wire [2:0] _GEN_44 = 3'h2 == ic_state ? _GEN_9 : _GEN_37; // @[Core.scala 240:23]
  wire [31:0] _GEN_46 = 3'h2 == ic_state ? ic_reg_inst2 : _GEN_35; // @[Core.scala 240:23 215:34]
  wire [31:0] _GEN_47 = 3'h2 == ic_state ? ic_reg_inst2_addr : _GEN_36; // @[Core.scala 240:23 216:34]
  wire [31:0] _GEN_48 = 3'h2 == ic_state ? ic_reg_inst : _GEN_38; // @[Core.scala 240:23 213:34]
  wire [31:0] _GEN_49 = 3'h2 == ic_state ? ic_reg_inst_addr : _GEN_39; // @[Core.scala 240:23 214:34]
  wire [31:0] _GEN_50 = 3'h1 == ic_state ? ic_imem_addr_4 : _GEN_41; // @[Core.scala 240:23 257:22]
  wire [31:0] _GEN_52 = 3'h1 == ic_state ? io_imem_inst : _GEN_48; // @[Core.scala 240:23 259:21]
  wire [31:0] _GEN_53 = 3'h1 == ic_state ? ic_reg_imem_addr : _GEN_49; // @[Core.scala 240:23 260:26]
  wire [31:0] _GEN_55 = 3'h1 == ic_state ? _GEN_4 : _GEN_43; // @[Core.scala 240:23]
  wire [2:0] _GEN_56 = 3'h1 == ic_state ? _GEN_5 : _GEN_44; // @[Core.scala 240:23]
  wire [31:0] _GEN_57 = 3'h1 == ic_state ? ic_reg_inst2 : _GEN_46; // @[Core.scala 240:23 215:34]
  wire [31:0] _GEN_58 = 3'h1 == ic_state ? ic_reg_inst2_addr : _GEN_47; // @[Core.scala 240:23 216:34]
  wire [31:0] _GEN_59 = 3'h0 == ic_state ? ic_imem_addr_4 : _GEN_50; // @[Core.scala 240:23 242:22]
  wire  _GEN_69 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_half_rdy : 1'h1; // @[Core.scala 226:19 236:94 238:21]
  wire [31:0] _GEN_70 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_imem_addr : _GEN_59; // @[Core.scala 223:16 236:94]
  wire  _GEN_84 = if1_is_jump | _GEN_69; // @[Core.scala 226:19 229:21]
  reg [31:0] if1_reg_next_pc; // @[Core.scala 345:32]
  wire [31:0] if1_next_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 346:24]
  wire [31:0] if1_next_pc_4 = if1_next_pc + 32'h4; // @[Core.scala 347:35]
  reg [31:0] if2_reg_pc; // @[Core.scala 357:29]
  reg [31:0] if2_reg_inst; // @[Core.scala 358:29]
  wire  _if2_pc_T = ic_reg_half_rdy & is_half_inst; // @[Core.scala 363:74]
  wire [31:0] if2_pc = id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst) ? if2_reg_pc : ic_reg_addr_out
    ; // @[Core.scala 363:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_reg_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = if2_reg_is_bp_pos ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = id_reg_stall ? if2_reg_inst : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = mem_reg_is_br ? 32'h13 : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex3_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire  if2_is_cond_br_w = if2_inst[6:0] == 7'h63; // @[Core.scala 378:42]
  wire  _if2_is_cond_br_c_T_3 = if2_inst[1:0] == 2'h1; // @[Core.scala 379:70]
  wire  if2_is_cond_br_c = if2_inst[15:14] == 2'h3 & if2_inst[1:0] == 2'h1; // @[Core.scala 379:52]
  wire  if2_is_cond_br = if2_is_cond_br_w | if2_is_cond_br_c; // @[Core.scala 380:41]
  wire  if2_is_jal_w = if2_inst[6:0] == 7'h6f; // @[Core.scala 381:38]
  wire  if2_is_jal_c = if2_inst[14:13] == 2'h1 & _if2_is_cond_br_c_T_3; // @[Core.scala 382:48]
  wire  if2_is_jal = if2_is_jal_w | if2_is_jal_c; // @[Core.scala 383:33]
  wire  if2_is_jalr = if2_inst[6:0] == 7'h67 | if2_inst[15:13] == 3'h4 & if2_inst[6:0] == 7'h2; // @[Core.scala 384:50]
  wire  if2_is_bp_br = if2_is_cond_br | if2_is_jalr | if2_is_jal; // @[Core.scala 385:52]
  wire  _if2_is_bp_pos_T = if2_is_bp_br & bp_io_lu_br_pos; // @[Core.scala 388:19]
  wire  _T_21 = ~reset; // @[Core.scala 397:9]
  reg  ex1_reg_hazard; // @[Core.scala 826:38]
  wire  _ex1_stall_T = ex1_reg_op1_sel == 3'h0; // @[Core.scala 840:23]
  wire  _ex1_stall_T_1 = ex1_reg_hazard & _ex1_stall_T; // @[Core.scala 839:21]
  wire  _ex1_stall_T_2 = ex1_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 841:24]
  wire  _ex1_stall_T_3 = _ex1_stall_T_1 & _ex1_stall_T_2; // @[Core.scala 840:36]
  reg  ex2_reg_hazard; // @[Core.scala 829:38]
  wire  _ex1_stall_T_5 = ex2_reg_hazard & _ex1_stall_T; // @[Core.scala 842:21]
  wire  _ex1_stall_T_6 = ex1_reg_rs1_addr == mem_reg_wb_addr; // @[Core.scala 844:24]
  wire  _ex1_stall_T_7 = _ex1_stall_T_5 & _ex1_stall_T_6; // @[Core.scala 843:36]
  wire  _ex1_stall_T_8 = _ex1_stall_T_3 | _ex1_stall_T_7; // @[Core.scala 841:46]
  wire  _ex1_stall_T_9 = ex1_reg_op2_sel == 4'h1; // @[Core.scala 846:23]
  wire  _ex1_stall_T_11 = ex1_reg_op2_sel == 4'h1 | ex1_reg_mem_wen == 2'h1; // @[Core.scala 846:35]
  wire  _ex1_stall_T_12 = ex1_reg_hazard & _ex1_stall_T_11; // @[Core.scala 845:21]
  wire  _ex1_stall_T_13 = ex1_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 847:24]
  wire  _ex1_stall_T_14 = _ex1_stall_T_12 & _ex1_stall_T_13; // @[Core.scala 846:65]
  wire  _ex1_stall_T_15 = _ex1_stall_T_8 | _ex1_stall_T_14; // @[Core.scala 844:46]
  wire  _ex1_stall_T_19 = ex2_reg_hazard & _ex1_stall_T_11; // @[Core.scala 848:21]
  wire  _ex1_stall_T_20 = ex1_reg_rs2_addr == mem_reg_wb_addr; // @[Core.scala 850:24]
  wire  _ex1_stall_T_21 = _ex1_stall_T_19 & _ex1_stall_T_20; // @[Core.scala 849:65]
  wire  ex1_stall = _ex1_stall_T_15 | _ex1_stall_T_21; // @[Core.scala 847:46]
  wire  _mem_en_T = ~mem_reg_is_br; // @[Core.scala 1079:30]
  wire  _mem_en_T_2 = ~ex3_reg_is_br; // @[Core.scala 1079:48]
  wire  _mem_en_T_4 = ~mem_reg_is_trap; // @[Core.scala 1079:66]
  wire  _mem_is_valid_inst_T_2 = _mem_en_T & _mem_en_T_2; // @[Core.scala 1075:68]
  wire  mem_is_valid_inst = mem_reg_is_valid_inst & (_mem_en_T & _mem_en_T_2); // @[Core.scala 1075:49]
  wire  mem_is_meintr = csr_mstatus[3] & (io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1076:73]
  wire  _mem_en_T_6 = ~mem_is_meintr; // @[Core.scala 1079:86]
  wire  mem_is_mtintr = csr_mstatus[3] & (mtimer_io_intr & csr_mie[7]) & mem_is_valid_inst; // @[Core.scala 1077:79]
  wire  _mem_en_T_8 = ~mem_is_mtintr; // @[Core.scala 1079:104]
  wire  mem_en = mem_reg_en & ~mem_reg_is_br & ~ex3_reg_is_br & ~mem_reg_is_trap & ~mem_is_meintr & ~mem_is_mtintr; // @[Core.scala 1079:101]
  wire [2:0] mem_wb_sel = mem_en ? mem_reg_wb_sel : 3'h0; // @[Core.scala 1081:23]
  wire  _mem_stall_T = mem_wb_sel == 3'h1; // @[Core.scala 1092:29]
  reg  mem_stall_delay; // @[Core.scala 1084:32]
  wire [1:0] mem_mem_wen = mem_en ? mem_reg_mem_wen : 2'h0; // @[Core.scala 1083:24]
  wire  _mem_stall_T_6 = mem_mem_wen == 2'h1; // @[Core.scala 1092:118]
  wire  mem_stall = mem_wb_sel == 3'h1 & (~io_dmem_rvalid | ~io_dmem_rready | mem_stall_delay) | mem_mem_wen == 2'h1 & ~
    io_dmem_wready | mem_mem_wen == 2'h3 & io_icache_control_busy; // @[Core.scala 1092:149]
  wire  id_stall = ex1_stall | mem_stall; // @[Core.scala 418:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 422:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 424:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 426:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 427:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 428:30]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 432:18]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 435:18]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 439:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 31:58]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 31:58]
  wire  _id_c_rs1_data_T = id_w_wb_addr == 5'h0; // @[Core.scala 447:20]
  wire [31:0] id_c_rs1_data = _id_c_rs1_data_T ? 32'h0 : regfile_id_c_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_c_rs2_data_T = id_c_rs2_addr == 5'h0; // @[Core.scala 450:20]
  wire [31:0] id_c_rs2_data = _id_c_rs2_data_T ? 32'h0 : regfile_id_c_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 456:25]
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
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 464:25]
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
  wire [31:0] _csignals_T_92 = id_inst & 32'hffff; // @[Lookup.scala 31:38]
  wire  _csignals_T_93 = 32'h0 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_94 = id_inst & 32'he003; // @[Lookup.scala 31:38]
  wire  _csignals_T_95 = 32'h0 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_96 = id_inst & 32'hef83; // @[Lookup.scala 31:38]
  wire  _csignals_T_97 = 32'h6101 == _csignals_T_96; // @[Lookup.scala 31:38]
  wire  _csignals_T_99 = 32'h1 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_101 = 32'h4000 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_103 = 32'hc000 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_105 = 32'h4001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_107 = 32'h6001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_108 = id_inst & 32'hec03; // @[Lookup.scala 31:38]
  wire  _csignals_T_109 = 32'h8401 == _csignals_T_108; // @[Lookup.scala 31:38]
  wire  _csignals_T_111 = 32'h8001 == _csignals_T_108; // @[Lookup.scala 31:38]
  wire  _csignals_T_113 = 32'h8801 == _csignals_T_108; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_114 = id_inst & 32'hfc63; // @[Lookup.scala 31:38]
  wire  _csignals_T_115 = 32'h8c01 == _csignals_T_114; // @[Lookup.scala 31:38]
  wire  _csignals_T_117 = 32'h8c21 == _csignals_T_114; // @[Lookup.scala 31:38]
  wire  _csignals_T_119 = 32'h8c41 == _csignals_T_114; // @[Lookup.scala 31:38]
  wire  _csignals_T_121 = 32'h8c61 == _csignals_T_114; // @[Lookup.scala 31:38]
  wire  _csignals_T_123 = 32'h2 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_125 = 32'ha001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_127 = 32'hc001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_129 = 32'he001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_130 = id_inst & 32'hf07f; // @[Lookup.scala 31:38]
  wire  _csignals_T_131 = 32'h8002 == _csignals_T_130; // @[Lookup.scala 31:38]
  wire  _csignals_T_133 = 32'h9002 == _csignals_T_130; // @[Lookup.scala 31:38]
  wire  _csignals_T_135 = 32'h2001 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_137 = 32'h4002 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'hc002 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_140 = id_inst & 32'hf003; // @[Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h8002 == _csignals_T_140; // @[Lookup.scala 31:38]
  wire  _csignals_T_143 = 32'h9002 == _csignals_T_140; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_144 = _csignals_T_143 ? 5'h1 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_145 = _csignals_T_141 ? 5'h1 : _csignals_T_144; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_146 = _csignals_T_139 ? 5'h1 : _csignals_T_145; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_147 = _csignals_T_137 ? 5'h1 : _csignals_T_146; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_148 = _csignals_T_135 ? 5'h1 : _csignals_T_147; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_149 = _csignals_T_133 ? 5'h11 : _csignals_T_148; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_150 = _csignals_T_131 ? 5'h11 : _csignals_T_149; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_151 = _csignals_T_129 ? 5'hc : _csignals_T_150; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_152 = _csignals_T_127 ? 5'hb : _csignals_T_151; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_153 = _csignals_T_125 ? 5'h1 : _csignals_T_152; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_154 = _csignals_T_123 ? 5'h6 : _csignals_T_153; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_155 = _csignals_T_121 ? 5'h3 : _csignals_T_154; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_156 = _csignals_T_119 ? 5'h4 : _csignals_T_155; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_157 = _csignals_T_117 ? 5'h5 : _csignals_T_156; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_158 = _csignals_T_115 ? 5'h2 : _csignals_T_157; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_159 = _csignals_T_113 ? 5'h3 : _csignals_T_158; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_160 = _csignals_T_111 ? 5'h7 : _csignals_T_159; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_161 = _csignals_T_109 ? 5'h8 : _csignals_T_160; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_162 = _csignals_T_107 ? 5'h1 : _csignals_T_161; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_163 = _csignals_T_105 ? 5'h1 : _csignals_T_162; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_164 = _csignals_T_103 ? 5'h1 : _csignals_T_163; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_165 = _csignals_T_101 ? 5'h1 : _csignals_T_164; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_166 = _csignals_T_99 ? 5'h1 : _csignals_T_165; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_167 = _csignals_T_97 ? 5'h1 : _csignals_T_166; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_168 = _csignals_T_95 ? 5'h1 : _csignals_T_167; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_169 = _csignals_T_93 ? 5'h0 : _csignals_T_168; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_170 = _csignals_T_91 ? 5'h0 : _csignals_T_169; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_171 = _csignals_T_89 ? 5'h0 : _csignals_T_170; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_172 = _csignals_T_87 ? 5'h0 : _csignals_T_171; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_173 = _csignals_T_85 ? 5'h12 : _csignals_T_172; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_174 = _csignals_T_83 ? 5'h12 : _csignals_T_173; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_175 = _csignals_T_81 ? 5'h12 : _csignals_T_174; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_176 = _csignals_T_79 ? 5'h12 : _csignals_T_175; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_177 = _csignals_T_77 ? 5'h12 : _csignals_T_176; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_178 = _csignals_T_75 ? 5'h12 : _csignals_T_177; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_179 = _csignals_T_73 ? 5'h1 : _csignals_T_178; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_180 = _csignals_T_71 ? 5'h1 : _csignals_T_179; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_181 = _csignals_T_69 ? 5'h11 : _csignals_T_180; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_182 = _csignals_T_67 ? 5'h1 : _csignals_T_181; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_183 = _csignals_T_65 ? 5'hf : _csignals_T_182; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_184 = _csignals_T_63 ? 5'hd : _csignals_T_183; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_185 = _csignals_T_61 ? 5'h10 : _csignals_T_184; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_186 = _csignals_T_59 ? 5'he : _csignals_T_185; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_187 = _csignals_T_57 ? 5'hc : _csignals_T_186; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_188 = _csignals_T_55 ? 5'hb : _csignals_T_187; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_189 = _csignals_T_53 ? 5'ha : _csignals_T_188; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_190 = _csignals_T_51 ? 5'h9 : _csignals_T_189; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_191 = _csignals_T_49 ? 5'ha : _csignals_T_190; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_192 = _csignals_T_47 ? 5'h9 : _csignals_T_191; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_193 = _csignals_T_45 ? 5'h8 : _csignals_T_192; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_194 = _csignals_T_43 ? 5'h7 : _csignals_T_193; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_195 = _csignals_T_41 ? 5'h6 : _csignals_T_194; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_196 = _csignals_T_39 ? 5'h8 : _csignals_T_195; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_197 = _csignals_T_37 ? 5'h7 : _csignals_T_196; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_198 = _csignals_T_35 ? 5'h6 : _csignals_T_197; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_199 = _csignals_T_33 ? 5'h5 : _csignals_T_198; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_200 = _csignals_T_31 ? 5'h4 : _csignals_T_199; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_201 = _csignals_T_29 ? 5'h3 : _csignals_T_200; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_202 = _csignals_T_27 ? 5'h5 : _csignals_T_201; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_203 = _csignals_T_25 ? 5'h4 : _csignals_T_202; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_204 = _csignals_T_23 ? 5'h3 : _csignals_T_203; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_205 = _csignals_T_21 ? 5'h2 : _csignals_T_204; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_206 = _csignals_T_19 ? 5'h1 : _csignals_T_205; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_207 = _csignals_T_17 ? 5'h1 : _csignals_T_206; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_208 = _csignals_T_15 ? 5'h1 : _csignals_T_207; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_209 = _csignals_T_13 ? 5'h1 : _csignals_T_208; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_210 = _csignals_T_11 ? 5'h1 : _csignals_T_209; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_211 = _csignals_T_9 ? 5'h1 : _csignals_T_210; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_212 = _csignals_T_7 ? 5'h1 : _csignals_T_211; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_213 = _csignals_T_5 ? 5'h1 : _csignals_T_212; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_214 = _csignals_T_3 ? 5'h1 : _csignals_T_213; // @[Lookup.scala 34:39]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h1 : _csignals_T_214; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_215 = _csignals_T_143 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_216 = _csignals_T_141 ? 3'h2 : _csignals_T_215; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_217 = _csignals_T_139 ? 3'h5 : _csignals_T_216; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_218 = _csignals_T_137 ? 3'h5 : _csignals_T_217; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_219 = _csignals_T_135 ? 3'h1 : _csignals_T_218; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_220 = _csignals_T_133 ? 3'h4 : _csignals_T_219; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_221 = _csignals_T_131 ? 3'h4 : _csignals_T_220; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_222 = _csignals_T_129 ? 3'h6 : _csignals_T_221; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_223 = _csignals_T_127 ? 3'h6 : _csignals_T_222; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_224 = _csignals_T_125 ? 3'h1 : _csignals_T_223; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_225 = _csignals_T_123 ? 3'h4 : _csignals_T_224; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_226 = _csignals_T_121 ? 3'h6 : _csignals_T_225; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_227 = _csignals_T_119 ? 3'h6 : _csignals_T_226; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_228 = _csignals_T_117 ? 3'h6 : _csignals_T_227; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_229 = _csignals_T_115 ? 3'h6 : _csignals_T_228; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_230 = _csignals_T_113 ? 3'h6 : _csignals_T_229; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_231 = _csignals_T_111 ? 3'h6 : _csignals_T_230; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_232 = _csignals_T_109 ? 3'h6 : _csignals_T_231; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_233 = _csignals_T_107 ? 3'h2 : _csignals_T_232; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_234 = _csignals_T_105 ? 3'h2 : _csignals_T_233; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_235 = _csignals_T_103 ? 3'h6 : _csignals_T_234; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_236 = _csignals_T_101 ? 3'h6 : _csignals_T_235; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_237 = _csignals_T_99 ? 3'h4 : _csignals_T_236; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_238 = _csignals_T_97 ? 3'h4 : _csignals_T_237; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_239 = _csignals_T_95 ? 3'h5 : _csignals_T_238; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_240 = _csignals_T_93 ? 3'h4 : _csignals_T_239; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_241 = _csignals_T_91 ? 3'h2 : _csignals_T_240; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_242 = _csignals_T_89 ? 3'h2 : _csignals_T_241; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_243 = _csignals_T_87 ? 3'h2 : _csignals_T_242; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_244 = _csignals_T_85 ? 3'h3 : _csignals_T_243; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_245 = _csignals_T_83 ? 3'h0 : _csignals_T_244; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_246 = _csignals_T_81 ? 3'h3 : _csignals_T_245; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_247 = _csignals_T_79 ? 3'h0 : _csignals_T_246; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_248 = _csignals_T_77 ? 3'h3 : _csignals_T_247; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_249 = _csignals_T_75 ? 3'h0 : _csignals_T_248; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_250 = _csignals_T_73 ? 3'h1 : _csignals_T_249; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_251 = _csignals_T_71 ? 3'h2 : _csignals_T_250; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_252 = _csignals_T_69 ? 3'h0 : _csignals_T_251; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_253 = _csignals_T_67 ? 3'h1 : _csignals_T_252; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_254 = _csignals_T_65 ? 3'h0 : _csignals_T_253; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_255 = _csignals_T_63 ? 3'h0 : _csignals_T_254; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_256 = _csignals_T_61 ? 3'h0 : _csignals_T_255; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_257 = _csignals_T_59 ? 3'h0 : _csignals_T_256; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_258 = _csignals_T_57 ? 3'h0 : _csignals_T_257; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_259 = _csignals_T_55 ? 3'h0 : _csignals_T_258; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_260 = _csignals_T_53 ? 3'h0 : _csignals_T_259; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_261 = _csignals_T_51 ? 3'h0 : _csignals_T_260; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_262 = _csignals_T_49 ? 3'h0 : _csignals_T_261; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_263 = _csignals_T_47 ? 3'h0 : _csignals_T_262; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_264 = _csignals_T_45 ? 3'h0 : _csignals_T_263; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_265 = _csignals_T_43 ? 3'h0 : _csignals_T_264; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_266 = _csignals_T_41 ? 3'h0 : _csignals_T_265; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_267 = _csignals_T_39 ? 3'h0 : _csignals_T_266; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_268 = _csignals_T_37 ? 3'h0 : _csignals_T_267; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_269 = _csignals_T_35 ? 3'h0 : _csignals_T_268; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_270 = _csignals_T_33 ? 3'h0 : _csignals_T_269; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_271 = _csignals_T_31 ? 3'h0 : _csignals_T_270; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_272 = _csignals_T_29 ? 3'h0 : _csignals_T_271; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_273 = _csignals_T_27 ? 3'h0 : _csignals_T_272; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_274 = _csignals_T_25 ? 3'h0 : _csignals_T_273; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_275 = _csignals_T_23 ? 3'h0 : _csignals_T_274; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_276 = _csignals_T_21 ? 3'h0 : _csignals_T_275; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_277 = _csignals_T_19 ? 3'h0 : _csignals_T_276; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_278 = _csignals_T_17 ? 3'h0 : _csignals_T_277; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_279 = _csignals_T_15 ? 3'h0 : _csignals_T_278; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_280 = _csignals_T_13 ? 3'h0 : _csignals_T_279; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_281 = _csignals_T_11 ? 3'h0 : _csignals_T_280; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_282 = _csignals_T_9 ? 3'h0 : _csignals_T_281; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_283 = _csignals_T_7 ? 3'h0 : _csignals_T_282; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_284 = _csignals_T_5 ? 3'h0 : _csignals_T_283; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_285 = _csignals_T_3 ? 3'h0 : _csignals_T_284; // @[Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h0 : _csignals_T_285; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_286 = _csignals_T_143 ? 4'h6 : 4'h1; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_287 = _csignals_T_141 ? 4'h6 : _csignals_T_286; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_288 = _csignals_T_139 ? 4'hf : _csignals_T_287; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_289 = _csignals_T_137 ? 4'he : _csignals_T_288; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_290 = _csignals_T_135 ? 4'hd : _csignals_T_289; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_291 = _csignals_T_133 ? 4'h0 : _csignals_T_290; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_292 = _csignals_T_131 ? 4'h0 : _csignals_T_291; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_293 = _csignals_T_129 ? 4'h0 : _csignals_T_292; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_294 = _csignals_T_127 ? 4'h0 : _csignals_T_293; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_295 = _csignals_T_125 ? 4'hd : _csignals_T_294; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_296 = _csignals_T_123 ? 4'ha : _csignals_T_295; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_297 = _csignals_T_121 ? 4'h7 : _csignals_T_296; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_298 = _csignals_T_119 ? 4'h7 : _csignals_T_297; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_299 = _csignals_T_117 ? 4'h7 : _csignals_T_298; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_300 = _csignals_T_115 ? 4'h7 : _csignals_T_299; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_301 = _csignals_T_113 ? 4'ha : _csignals_T_300; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_302 = _csignals_T_111 ? 4'ha : _csignals_T_301; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_303 = _csignals_T_109 ? 4'ha : _csignals_T_302; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_304 = _csignals_T_107 ? 4'hc : _csignals_T_303; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_305 = _csignals_T_105 ? 4'ha : _csignals_T_304; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_306 = _csignals_T_103 ? 4'hb : _csignals_T_305; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_307 = _csignals_T_101 ? 4'hb : _csignals_T_306; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_308 = _csignals_T_99 ? 4'ha : _csignals_T_307; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_309 = _csignals_T_97 ? 4'h9 : _csignals_T_308; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_310 = _csignals_T_95 ? 4'h8 : _csignals_T_309; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_311 = _csignals_T_93 ? 4'h6 : _csignals_T_310; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_312 = _csignals_T_91 ? 4'h0 : _csignals_T_311; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_313 = _csignals_T_89 ? 4'h0 : _csignals_T_312; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_314 = _csignals_T_87 ? 4'h0 : _csignals_T_313; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_315 = _csignals_T_85 ? 4'h0 : _csignals_T_314; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_316 = _csignals_T_83 ? 4'h0 : _csignals_T_315; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_317 = _csignals_T_81 ? 4'h0 : _csignals_T_316; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_318 = _csignals_T_79 ? 4'h0 : _csignals_T_317; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_319 = _csignals_T_77 ? 4'h0 : _csignals_T_318; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_320 = _csignals_T_75 ? 4'h0 : _csignals_T_319; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_321 = _csignals_T_73 ? 4'h5 : _csignals_T_320; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_322 = _csignals_T_71 ? 4'h5 : _csignals_T_321; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_323 = _csignals_T_69 ? 4'h2 : _csignals_T_322; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_324 = _csignals_T_67 ? 4'h4 : _csignals_T_323; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_325 = _csignals_T_65 ? 4'h1 : _csignals_T_324; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_326 = _csignals_T_63 ? 4'h1 : _csignals_T_325; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_327 = _csignals_T_61 ? 4'h1 : _csignals_T_326; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_328 = _csignals_T_59 ? 4'h1 : _csignals_T_327; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_329 = _csignals_T_57 ? 4'h1 : _csignals_T_328; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_330 = _csignals_T_55 ? 4'h1 : _csignals_T_329; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_331 = _csignals_T_53 ? 4'h2 : _csignals_T_330; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_332 = _csignals_T_51 ? 4'h2 : _csignals_T_331; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_333 = _csignals_T_49 ? 4'h1 : _csignals_T_332; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_334 = _csignals_T_47 ? 4'h1 : _csignals_T_333; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_335 = _csignals_T_45 ? 4'h2 : _csignals_T_334; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_336 = _csignals_T_43 ? 4'h2 : _csignals_T_335; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_337 = _csignals_T_41 ? 4'h2 : _csignals_T_336; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_338 = _csignals_T_39 ? 4'h1 : _csignals_T_337; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_339 = _csignals_T_37 ? 4'h1 : _csignals_T_338; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_340 = _csignals_T_35 ? 4'h1 : _csignals_T_339; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_341 = _csignals_T_33 ? 4'h2 : _csignals_T_340; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_342 = _csignals_T_31 ? 4'h2 : _csignals_T_341; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_343 = _csignals_T_29 ? 4'h2 : _csignals_T_342; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_344 = _csignals_T_27 ? 4'h1 : _csignals_T_343; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_345 = _csignals_T_25 ? 4'h1 : _csignals_T_344; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_346 = _csignals_T_23 ? 4'h1 : _csignals_T_345; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_347 = _csignals_T_21 ? 4'h1 : _csignals_T_346; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_348 = _csignals_T_19 ? 4'h2 : _csignals_T_347; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_349 = _csignals_T_17 ? 4'h1 : _csignals_T_348; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_350 = _csignals_T_15 ? 4'h3 : _csignals_T_349; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_351 = _csignals_T_13 ? 4'h2 : _csignals_T_350; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_352 = _csignals_T_11 ? 4'h3 : _csignals_T_351; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_353 = _csignals_T_9 ? 4'h2 : _csignals_T_352; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_354 = _csignals_T_7 ? 4'h2 : _csignals_T_353; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_355 = _csignals_T_5 ? 4'h3 : _csignals_T_354; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_356 = _csignals_T_3 ? 4'h2 : _csignals_T_355; // @[Lookup.scala 34:39]
  wire [3:0] csignals_2 = _csignals_T_1 ? 4'h2 : _csignals_T_356; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_359 = _csignals_T_139 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_360 = _csignals_T_137 ? 2'h0 : _csignals_T_359; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_361 = _csignals_T_135 ? 2'h0 : _csignals_T_360; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_362 = _csignals_T_133 ? 2'h0 : _csignals_T_361; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_363 = _csignals_T_131 ? 2'h0 : _csignals_T_362; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_364 = _csignals_T_129 ? 2'h0 : _csignals_T_363; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_365 = _csignals_T_127 ? 2'h0 : _csignals_T_364; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_366 = _csignals_T_125 ? 2'h0 : _csignals_T_365; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_367 = _csignals_T_123 ? 2'h0 : _csignals_T_366; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_368 = _csignals_T_121 ? 2'h0 : _csignals_T_367; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_369 = _csignals_T_119 ? 2'h0 : _csignals_T_368; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_370 = _csignals_T_117 ? 2'h0 : _csignals_T_369; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_371 = _csignals_T_115 ? 2'h0 : _csignals_T_370; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_372 = _csignals_T_113 ? 2'h0 : _csignals_T_371; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_373 = _csignals_T_111 ? 2'h0 : _csignals_T_372; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_374 = _csignals_T_109 ? 2'h0 : _csignals_T_373; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_375 = _csignals_T_107 ? 2'h0 : _csignals_T_374; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_376 = _csignals_T_105 ? 2'h0 : _csignals_T_375; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_377 = _csignals_T_103 ? 2'h1 : _csignals_T_376; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_378 = _csignals_T_101 ? 2'h0 : _csignals_T_377; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_379 = _csignals_T_99 ? 2'h0 : _csignals_T_378; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_380 = _csignals_T_97 ? 2'h0 : _csignals_T_379; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_381 = _csignals_T_95 ? 2'h0 : _csignals_T_380; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_382 = _csignals_T_93 ? 2'h0 : _csignals_T_381; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_383 = _csignals_T_91 ? 2'h3 : _csignals_T_382; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_384 = _csignals_T_89 ? 2'h0 : _csignals_T_383; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_385 = _csignals_T_87 ? 2'h0 : _csignals_T_384; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_386 = _csignals_T_85 ? 2'h0 : _csignals_T_385; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_387 = _csignals_T_83 ? 2'h0 : _csignals_T_386; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_388 = _csignals_T_81 ? 2'h0 : _csignals_T_387; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_389 = _csignals_T_79 ? 2'h0 : _csignals_T_388; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_390 = _csignals_T_77 ? 2'h0 : _csignals_T_389; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_391 = _csignals_T_75 ? 2'h0 : _csignals_T_390; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_392 = _csignals_T_73 ? 2'h0 : _csignals_T_391; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_393 = _csignals_T_71 ? 2'h0 : _csignals_T_392; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_394 = _csignals_T_69 ? 2'h0 : _csignals_T_393; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_395 = _csignals_T_67 ? 2'h0 : _csignals_T_394; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_396 = _csignals_T_65 ? 2'h0 : _csignals_T_395; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_397 = _csignals_T_63 ? 2'h0 : _csignals_T_396; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_398 = _csignals_T_61 ? 2'h0 : _csignals_T_397; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_399 = _csignals_T_59 ? 2'h0 : _csignals_T_398; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_400 = _csignals_T_57 ? 2'h0 : _csignals_T_399; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_401 = _csignals_T_55 ? 2'h0 : _csignals_T_400; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_402 = _csignals_T_53 ? 2'h0 : _csignals_T_401; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_403 = _csignals_T_51 ? 2'h0 : _csignals_T_402; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_404 = _csignals_T_49 ? 2'h0 : _csignals_T_403; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_405 = _csignals_T_47 ? 2'h0 : _csignals_T_404; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_406 = _csignals_T_45 ? 2'h0 : _csignals_T_405; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_407 = _csignals_T_43 ? 2'h0 : _csignals_T_406; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_408 = _csignals_T_41 ? 2'h0 : _csignals_T_407; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_409 = _csignals_T_39 ? 2'h0 : _csignals_T_408; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_410 = _csignals_T_37 ? 2'h0 : _csignals_T_409; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_411 = _csignals_T_35 ? 2'h0 : _csignals_T_410; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_412 = _csignals_T_33 ? 2'h0 : _csignals_T_411; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_413 = _csignals_T_31 ? 2'h0 : _csignals_T_412; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_414 = _csignals_T_29 ? 2'h0 : _csignals_T_413; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_415 = _csignals_T_27 ? 2'h0 : _csignals_T_414; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_416 = _csignals_T_25 ? 2'h0 : _csignals_T_415; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_417 = _csignals_T_23 ? 2'h0 : _csignals_T_416; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_418 = _csignals_T_21 ? 2'h0 : _csignals_T_417; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_419 = _csignals_T_19 ? 2'h0 : _csignals_T_418; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_420 = _csignals_T_17 ? 2'h0 : _csignals_T_419; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_421 = _csignals_T_15 ? 2'h1 : _csignals_T_420; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_422 = _csignals_T_13 ? 2'h0 : _csignals_T_421; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_423 = _csignals_T_11 ? 2'h1 : _csignals_T_422; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_424 = _csignals_T_9 ? 2'h0 : _csignals_T_423; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_425 = _csignals_T_7 ? 2'h0 : _csignals_T_424; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_426 = _csignals_T_5 ? 2'h1 : _csignals_T_425; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_427 = _csignals_T_3 ? 2'h0 : _csignals_T_426; // @[Lookup.scala 34:39]
  wire [1:0] csignals_3 = _csignals_T_1 ? 2'h0 : _csignals_T_427; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_428 = _csignals_T_143 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_429 = _csignals_T_141 ? 2'h1 : _csignals_T_428; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_430 = _csignals_T_139 ? 2'h0 : _csignals_T_429; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_431 = _csignals_T_137 ? 2'h1 : _csignals_T_430; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_432 = _csignals_T_135 ? 2'h1 : _csignals_T_431; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_433 = _csignals_T_133 ? 2'h1 : _csignals_T_432; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_434 = _csignals_T_131 ? 2'h1 : _csignals_T_433; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_435 = _csignals_T_129 ? 2'h0 : _csignals_T_434; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_436 = _csignals_T_127 ? 2'h0 : _csignals_T_435; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_437 = _csignals_T_125 ? 2'h1 : _csignals_T_436; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_438 = _csignals_T_123 ? 2'h1 : _csignals_T_437; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_439 = _csignals_T_121 ? 2'h1 : _csignals_T_438; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_440 = _csignals_T_119 ? 2'h1 : _csignals_T_439; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_441 = _csignals_T_117 ? 2'h1 : _csignals_T_440; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_442 = _csignals_T_115 ? 2'h1 : _csignals_T_441; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_443 = _csignals_T_113 ? 2'h1 : _csignals_T_442; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_444 = _csignals_T_111 ? 2'h1 : _csignals_T_443; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_445 = _csignals_T_109 ? 2'h1 : _csignals_T_444; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_446 = _csignals_T_107 ? 2'h1 : _csignals_T_445; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_447 = _csignals_T_105 ? 2'h1 : _csignals_T_446; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_448 = _csignals_T_103 ? 2'h0 : _csignals_T_447; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_449 = _csignals_T_101 ? 2'h1 : _csignals_T_448; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_450 = _csignals_T_99 ? 2'h1 : _csignals_T_449; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_451 = _csignals_T_97 ? 2'h1 : _csignals_T_450; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_452 = _csignals_T_95 ? 2'h1 : _csignals_T_451; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_453 = _csignals_T_93 ? 2'h0 : _csignals_T_452; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_454 = _csignals_T_91 ? 2'h0 : _csignals_T_453; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_455 = _csignals_T_89 ? 2'h0 : _csignals_T_454; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_456 = _csignals_T_87 ? 2'h0 : _csignals_T_455; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_457 = _csignals_T_85 ? 2'h1 : _csignals_T_456; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_458 = _csignals_T_83 ? 2'h1 : _csignals_T_457; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_459 = _csignals_T_81 ? 2'h1 : _csignals_T_458; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_460 = _csignals_T_79 ? 2'h1 : _csignals_T_459; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_461 = _csignals_T_77 ? 2'h1 : _csignals_T_460; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_462 = _csignals_T_75 ? 2'h1 : _csignals_T_461; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_463 = _csignals_T_73 ? 2'h1 : _csignals_T_462; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_464 = _csignals_T_71 ? 2'h1 : _csignals_T_463; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_465 = _csignals_T_69 ? 2'h1 : _csignals_T_464; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_466 = _csignals_T_67 ? 2'h1 : _csignals_T_465; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_467 = _csignals_T_65 ? 2'h0 : _csignals_T_466; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_468 = _csignals_T_63 ? 2'h0 : _csignals_T_467; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_469 = _csignals_T_61 ? 2'h0 : _csignals_T_468; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_470 = _csignals_T_59 ? 2'h0 : _csignals_T_469; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_471 = _csignals_T_57 ? 2'h0 : _csignals_T_470; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_472 = _csignals_T_55 ? 2'h0 : _csignals_T_471; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_473 = _csignals_T_53 ? 2'h1 : _csignals_T_472; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_474 = _csignals_T_51 ? 2'h1 : _csignals_T_473; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_475 = _csignals_T_49 ? 2'h1 : _csignals_T_474; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_476 = _csignals_T_47 ? 2'h1 : _csignals_T_475; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_477 = _csignals_T_45 ? 2'h1 : _csignals_T_476; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_478 = _csignals_T_43 ? 2'h1 : _csignals_T_477; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_479 = _csignals_T_41 ? 2'h1 : _csignals_T_478; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_480 = _csignals_T_39 ? 2'h1 : _csignals_T_479; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_481 = _csignals_T_37 ? 2'h1 : _csignals_T_480; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_482 = _csignals_T_35 ? 2'h1 : _csignals_T_481; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_483 = _csignals_T_33 ? 2'h1 : _csignals_T_482; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_484 = _csignals_T_31 ? 2'h1 : _csignals_T_483; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_485 = _csignals_T_29 ? 2'h1 : _csignals_T_484; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_486 = _csignals_T_27 ? 2'h1 : _csignals_T_485; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_487 = _csignals_T_25 ? 2'h1 : _csignals_T_486; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_488 = _csignals_T_23 ? 2'h1 : _csignals_T_487; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_489 = _csignals_T_21 ? 2'h1 : _csignals_T_488; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_490 = _csignals_T_19 ? 2'h1 : _csignals_T_489; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_491 = _csignals_T_17 ? 2'h1 : _csignals_T_490; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_492 = _csignals_T_15 ? 2'h0 : _csignals_T_491; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_493 = _csignals_T_13 ? 2'h1 : _csignals_T_492; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_494 = _csignals_T_11 ? 2'h0 : _csignals_T_493; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_495 = _csignals_T_9 ? 2'h1 : _csignals_T_494; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_496 = _csignals_T_7 ? 2'h1 : _csignals_T_495; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_497 = _csignals_T_5 ? 2'h0 : _csignals_T_496; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_498 = _csignals_T_3 ? 2'h1 : _csignals_T_497; // @[Lookup.scala 34:39]
  wire [1:0] csignals_4 = _csignals_T_1 ? 2'h1 : _csignals_T_498; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_502 = _csignals_T_137 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_503 = _csignals_T_135 ? 3'h2 : _csignals_T_502; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_504 = _csignals_T_133 ? 3'h2 : _csignals_T_503; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_505 = _csignals_T_131 ? 3'h0 : _csignals_T_504; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_506 = _csignals_T_129 ? 3'h0 : _csignals_T_505; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_507 = _csignals_T_127 ? 3'h0 : _csignals_T_506; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_508 = _csignals_T_125 ? 3'h0 : _csignals_T_507; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_509 = _csignals_T_123 ? 3'h0 : _csignals_T_508; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_510 = _csignals_T_121 ? 3'h0 : _csignals_T_509; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_511 = _csignals_T_119 ? 3'h0 : _csignals_T_510; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_512 = _csignals_T_117 ? 3'h0 : _csignals_T_511; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_513 = _csignals_T_115 ? 3'h0 : _csignals_T_512; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_514 = _csignals_T_113 ? 3'h0 : _csignals_T_513; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_515 = _csignals_T_111 ? 3'h0 : _csignals_T_514; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_516 = _csignals_T_109 ? 3'h0 : _csignals_T_515; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_517 = _csignals_T_107 ? 3'h0 : _csignals_T_516; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_518 = _csignals_T_105 ? 3'h0 : _csignals_T_517; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_519 = _csignals_T_103 ? 3'h0 : _csignals_T_518; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_520 = _csignals_T_101 ? 3'h1 : _csignals_T_519; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_521 = _csignals_T_99 ? 3'h0 : _csignals_T_520; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_522 = _csignals_T_97 ? 3'h0 : _csignals_T_521; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_523 = _csignals_T_95 ? 3'h0 : _csignals_T_522; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_524 = _csignals_T_93 ? 3'h0 : _csignals_T_523; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_525 = _csignals_T_91 ? 3'h0 : _csignals_T_524; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_526 = _csignals_T_89 ? 3'h0 : _csignals_T_525; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_527 = _csignals_T_87 ? 3'h0 : _csignals_T_526; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_528 = _csignals_T_85 ? 3'h3 : _csignals_T_527; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_529 = _csignals_T_83 ? 3'h3 : _csignals_T_528; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_530 = _csignals_T_81 ? 3'h3 : _csignals_T_529; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_531 = _csignals_T_79 ? 3'h3 : _csignals_T_530; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_532 = _csignals_T_77 ? 3'h3 : _csignals_T_531; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_533 = _csignals_T_75 ? 3'h3 : _csignals_T_532; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_534 = _csignals_T_73 ? 3'h0 : _csignals_T_533; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_535 = _csignals_T_71 ? 3'h0 : _csignals_T_534; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_536 = _csignals_T_69 ? 3'h2 : _csignals_T_535; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_537 = _csignals_T_67 ? 3'h2 : _csignals_T_536; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_538 = _csignals_T_65 ? 3'h0 : _csignals_T_537; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_539 = _csignals_T_63 ? 3'h0 : _csignals_T_538; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_540 = _csignals_T_61 ? 3'h0 : _csignals_T_539; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_541 = _csignals_T_59 ? 3'h0 : _csignals_T_540; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_542 = _csignals_T_57 ? 3'h0 : _csignals_T_541; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_543 = _csignals_T_55 ? 3'h0 : _csignals_T_542; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_544 = _csignals_T_53 ? 3'h0 : _csignals_T_543; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_545 = _csignals_T_51 ? 3'h0 : _csignals_T_544; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_546 = _csignals_T_49 ? 3'h0 : _csignals_T_545; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_547 = _csignals_T_47 ? 3'h0 : _csignals_T_546; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_548 = _csignals_T_45 ? 3'h0 : _csignals_T_547; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_549 = _csignals_T_43 ? 3'h0 : _csignals_T_548; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_550 = _csignals_T_41 ? 3'h0 : _csignals_T_549; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_551 = _csignals_T_39 ? 3'h0 : _csignals_T_550; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_552 = _csignals_T_37 ? 3'h0 : _csignals_T_551; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_553 = _csignals_T_35 ? 3'h0 : _csignals_T_552; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_554 = _csignals_T_33 ? 3'h0 : _csignals_T_553; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_555 = _csignals_T_31 ? 3'h0 : _csignals_T_554; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_556 = _csignals_T_29 ? 3'h0 : _csignals_T_555; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_557 = _csignals_T_27 ? 3'h0 : _csignals_T_556; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_558 = _csignals_T_25 ? 3'h0 : _csignals_T_557; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_559 = _csignals_T_23 ? 3'h0 : _csignals_T_558; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_560 = _csignals_T_21 ? 3'h0 : _csignals_T_559; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_561 = _csignals_T_19 ? 3'h0 : _csignals_T_560; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_562 = _csignals_T_17 ? 3'h0 : _csignals_T_561; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_563 = _csignals_T_15 ? 3'h0 : _csignals_T_562; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_564 = _csignals_T_13 ? 3'h1 : _csignals_T_563; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_565 = _csignals_T_11 ? 3'h0 : _csignals_T_564; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_566 = _csignals_T_9 ? 3'h1 : _csignals_T_565; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_567 = _csignals_T_7 ? 3'h1 : _csignals_T_566; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_568 = _csignals_T_5 ? 3'h0 : _csignals_T_567; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_569 = _csignals_T_3 ? 3'h1 : _csignals_T_568; // @[Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h1 : _csignals_T_569; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_570 = _csignals_T_143 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_571 = _csignals_T_141 ? 3'h1 : _csignals_T_570; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_572 = _csignals_T_139 ? 3'h1 : _csignals_T_571; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_573 = _csignals_T_137 ? 3'h1 : _csignals_T_572; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_574 = _csignals_T_135 ? 3'h4 : _csignals_T_573; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_575 = _csignals_T_133 ? 3'h4 : _csignals_T_574; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_576 = _csignals_T_131 ? 3'h1 : _csignals_T_575; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_577 = _csignals_T_129 ? 3'h1 : _csignals_T_576; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_578 = _csignals_T_127 ? 3'h1 : _csignals_T_577; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_579 = _csignals_T_125 ? 3'h1 : _csignals_T_578; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_580 = _csignals_T_123 ? 3'h1 : _csignals_T_579; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_581 = _csignals_T_121 ? 3'h2 : _csignals_T_580; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_582 = _csignals_T_119 ? 3'h2 : _csignals_T_581; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_583 = _csignals_T_117 ? 3'h2 : _csignals_T_582; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_584 = _csignals_T_115 ? 3'h2 : _csignals_T_583; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_585 = _csignals_T_113 ? 3'h2 : _csignals_T_584; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_586 = _csignals_T_111 ? 3'h2 : _csignals_T_585; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_587 = _csignals_T_109 ? 3'h2 : _csignals_T_586; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_588 = _csignals_T_107 ? 3'h1 : _csignals_T_587; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_589 = _csignals_T_105 ? 3'h1 : _csignals_T_588; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_590 = _csignals_T_103 ? 3'h1 : _csignals_T_589; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_591 = _csignals_T_101 ? 3'h3 : _csignals_T_590; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_592 = _csignals_T_99 ? 3'h1 : _csignals_T_591; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_593 = _csignals_T_97 ? 3'h1 : _csignals_T_592; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_594 = _csignals_T_95 ? 3'h3 : _csignals_T_593; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_595 = _csignals_T_93 ? 3'h1 : _csignals_T_594; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_596 = _csignals_T_91 ? 3'h0 : _csignals_T_595; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_597 = _csignals_T_89 ? 3'h0 : _csignals_T_596; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_598 = _csignals_T_87 ? 3'h0 : _csignals_T_597; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_599 = _csignals_T_85 ? 3'h0 : _csignals_T_598; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_600 = _csignals_T_83 ? 3'h0 : _csignals_T_599; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_601 = _csignals_T_81 ? 3'h0 : _csignals_T_600; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_602 = _csignals_T_79 ? 3'h0 : _csignals_T_601; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_603 = _csignals_T_77 ? 3'h0 : _csignals_T_602; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_604 = _csignals_T_75 ? 3'h0 : _csignals_T_603; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_605 = _csignals_T_73 ? 3'h0 : _csignals_T_604; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_606 = _csignals_T_71 ? 3'h0 : _csignals_T_605; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_607 = _csignals_T_69 ? 3'h0 : _csignals_T_606; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_608 = _csignals_T_67 ? 3'h0 : _csignals_T_607; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_609 = _csignals_T_65 ? 3'h0 : _csignals_T_608; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_610 = _csignals_T_63 ? 3'h0 : _csignals_T_609; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_611 = _csignals_T_61 ? 3'h0 : _csignals_T_610; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_612 = _csignals_T_59 ? 3'h0 : _csignals_T_611; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_613 = _csignals_T_57 ? 3'h0 : _csignals_T_612; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_614 = _csignals_T_55 ? 3'h0 : _csignals_T_613; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_615 = _csignals_T_53 ? 3'h0 : _csignals_T_614; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_616 = _csignals_T_51 ? 3'h0 : _csignals_T_615; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_617 = _csignals_T_49 ? 3'h0 : _csignals_T_616; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_618 = _csignals_T_47 ? 3'h0 : _csignals_T_617; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_619 = _csignals_T_45 ? 3'h0 : _csignals_T_618; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_620 = _csignals_T_43 ? 3'h0 : _csignals_T_619; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_621 = _csignals_T_41 ? 3'h0 : _csignals_T_620; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_622 = _csignals_T_39 ? 3'h0 : _csignals_T_621; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_623 = _csignals_T_37 ? 3'h0 : _csignals_T_622; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_624 = _csignals_T_35 ? 3'h0 : _csignals_T_623; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_625 = _csignals_T_33 ? 3'h0 : _csignals_T_624; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_626 = _csignals_T_31 ? 3'h0 : _csignals_T_625; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_627 = _csignals_T_29 ? 3'h0 : _csignals_T_626; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_628 = _csignals_T_27 ? 3'h0 : _csignals_T_627; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_629 = _csignals_T_25 ? 3'h0 : _csignals_T_628; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_630 = _csignals_T_23 ? 3'h0 : _csignals_T_629; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_631 = _csignals_T_21 ? 3'h0 : _csignals_T_630; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_632 = _csignals_T_19 ? 3'h0 : _csignals_T_631; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_633 = _csignals_T_17 ? 3'h0 : _csignals_T_632; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_634 = _csignals_T_15 ? 3'h0 : _csignals_T_633; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_635 = _csignals_T_13 ? 3'h0 : _csignals_T_634; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_636 = _csignals_T_11 ? 3'h0 : _csignals_T_635; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_637 = _csignals_T_9 ? 3'h0 : _csignals_T_636; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_638 = _csignals_T_7 ? 3'h0 : _csignals_T_637; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_639 = _csignals_T_5 ? 3'h0 : _csignals_T_638; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_640 = _csignals_T_3 ? 3'h0 : _csignals_T_639; // @[Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_640; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_89 ? 3'h6 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_87 ? 3'h4 : _csignals_T_668; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_85 ? 3'h3 : _csignals_T_669; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_83 ? 3'h3 : _csignals_T_670; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_81 ? 3'h2 : _csignals_T_671; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_79 ? 3'h2 : _csignals_T_672; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_77 ? 3'h1 : _csignals_T_673; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_75 ? 3'h1 : _csignals_T_674; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_73 ? 3'h0 : _csignals_T_675; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_677 = _csignals_T_71 ? 3'h0 : _csignals_T_676; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_678 = _csignals_T_69 ? 3'h0 : _csignals_T_677; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_679 = _csignals_T_67 ? 3'h0 : _csignals_T_678; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_680 = _csignals_T_65 ? 3'h0 : _csignals_T_679; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_681 = _csignals_T_63 ? 3'h0 : _csignals_T_680; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_682 = _csignals_T_61 ? 3'h0 : _csignals_T_681; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_683 = _csignals_T_59 ? 3'h0 : _csignals_T_682; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_684 = _csignals_T_57 ? 3'h0 : _csignals_T_683; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_685 = _csignals_T_55 ? 3'h0 : _csignals_T_684; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_686 = _csignals_T_53 ? 3'h0 : _csignals_T_685; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_687 = _csignals_T_51 ? 3'h0 : _csignals_T_686; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_688 = _csignals_T_49 ? 3'h0 : _csignals_T_687; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_689 = _csignals_T_47 ? 3'h0 : _csignals_T_688; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_690 = _csignals_T_45 ? 3'h0 : _csignals_T_689; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_691 = _csignals_T_43 ? 3'h0 : _csignals_T_690; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_692 = _csignals_T_41 ? 3'h0 : _csignals_T_691; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_693 = _csignals_T_39 ? 3'h0 : _csignals_T_692; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_694 = _csignals_T_37 ? 3'h0 : _csignals_T_693; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_695 = _csignals_T_35 ? 3'h0 : _csignals_T_694; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_696 = _csignals_T_33 ? 3'h0 : _csignals_T_695; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_697 = _csignals_T_31 ? 3'h0 : _csignals_T_696; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_698 = _csignals_T_29 ? 3'h0 : _csignals_T_697; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_699 = _csignals_T_27 ? 3'h0 : _csignals_T_698; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_700 = _csignals_T_25 ? 3'h0 : _csignals_T_699; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_701 = _csignals_T_23 ? 3'h0 : _csignals_T_700; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_702 = _csignals_T_21 ? 3'h0 : _csignals_T_701; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_703 = _csignals_T_19 ? 3'h0 : _csignals_T_702; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_704 = _csignals_T_17 ? 3'h0 : _csignals_T_703; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_705 = _csignals_T_15 ? 3'h0 : _csignals_T_704; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_706 = _csignals_T_13 ? 3'h0 : _csignals_T_705; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_707 = _csignals_T_11 ? 3'h0 : _csignals_T_706; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_9 ? 3'h0 : _csignals_T_707; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_7 ? 3'h0 : _csignals_T_708; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_5 ? 3'h0 : _csignals_T_709; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_3 ? 3'h0 : _csignals_T_710; // @[Lookup.scala 34:39]
  wire [2:0] csignals_7 = _csignals_T_1 ? 3'h0 : _csignals_T_711; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_139 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_137 ? 3'h1 : _csignals_T_714; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_135 ? 3'h0 : _csignals_T_715; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_133 ? 3'h0 : _csignals_T_716; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_131 ? 3'h0 : _csignals_T_717; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_129 ? 3'h0 : _csignals_T_718; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_127 ? 3'h0 : _csignals_T_719; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_125 ? 3'h0 : _csignals_T_720; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_123 ? 3'h0 : _csignals_T_721; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_121 ? 3'h0 : _csignals_T_722; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_119 ? 3'h0 : _csignals_T_723; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_117 ? 3'h0 : _csignals_T_724; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_115 ? 3'h0 : _csignals_T_725; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_113 ? 3'h0 : _csignals_T_726; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_111 ? 3'h0 : _csignals_T_727; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_109 ? 3'h0 : _csignals_T_728; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_107 ? 3'h0 : _csignals_T_729; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_105 ? 3'h0 : _csignals_T_730; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_103 ? 3'h1 : _csignals_T_731; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_101 ? 3'h1 : _csignals_T_732; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_99 ? 3'h0 : _csignals_T_733; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_97 ? 3'h0 : _csignals_T_734; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_95 ? 3'h0 : _csignals_T_735; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_93 ? 3'h0 : _csignals_T_736; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_91 ? 3'h0 : _csignals_T_737; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_89 ? 3'h0 : _csignals_T_738; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_740 = _csignals_T_87 ? 3'h0 : _csignals_T_739; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_741 = _csignals_T_85 ? 3'h0 : _csignals_T_740; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_742 = _csignals_T_83 ? 3'h0 : _csignals_T_741; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_743 = _csignals_T_81 ? 3'h0 : _csignals_T_742; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_744 = _csignals_T_79 ? 3'h0 : _csignals_T_743; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_745 = _csignals_T_77 ? 3'h0 : _csignals_T_744; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_746 = _csignals_T_75 ? 3'h0 : _csignals_T_745; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_747 = _csignals_T_73 ? 3'h0 : _csignals_T_746; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_748 = _csignals_T_71 ? 3'h0 : _csignals_T_747; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_749 = _csignals_T_69 ? 3'h0 : _csignals_T_748; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_750 = _csignals_T_67 ? 3'h0 : _csignals_T_749; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_751 = _csignals_T_65 ? 3'h0 : _csignals_T_750; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_752 = _csignals_T_63 ? 3'h0 : _csignals_T_751; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_753 = _csignals_T_61 ? 3'h0 : _csignals_T_752; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_754 = _csignals_T_59 ? 3'h0 : _csignals_T_753; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_755 = _csignals_T_57 ? 3'h0 : _csignals_T_754; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_756 = _csignals_T_55 ? 3'h0 : _csignals_T_755; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_757 = _csignals_T_53 ? 3'h0 : _csignals_T_756; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_758 = _csignals_T_51 ? 3'h0 : _csignals_T_757; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_759 = _csignals_T_49 ? 3'h0 : _csignals_T_758; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_760 = _csignals_T_47 ? 3'h0 : _csignals_T_759; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_761 = _csignals_T_45 ? 3'h0 : _csignals_T_760; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_762 = _csignals_T_43 ? 3'h0 : _csignals_T_761; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_763 = _csignals_T_41 ? 3'h0 : _csignals_T_762; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_764 = _csignals_T_39 ? 3'h0 : _csignals_T_763; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_765 = _csignals_T_37 ? 3'h0 : _csignals_T_764; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_766 = _csignals_T_35 ? 3'h0 : _csignals_T_765; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_767 = _csignals_T_33 ? 3'h0 : _csignals_T_766; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_768 = _csignals_T_31 ? 3'h0 : _csignals_T_767; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_769 = _csignals_T_29 ? 3'h0 : _csignals_T_768; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_770 = _csignals_T_27 ? 3'h0 : _csignals_T_769; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_771 = _csignals_T_25 ? 3'h0 : _csignals_T_770; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_772 = _csignals_T_23 ? 3'h0 : _csignals_T_771; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_773 = _csignals_T_21 ? 3'h0 : _csignals_T_772; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_774 = _csignals_T_19 ? 3'h0 : _csignals_T_773; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_775 = _csignals_T_17 ? 3'h0 : _csignals_T_774; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_776 = _csignals_T_15 ? 3'h1 : _csignals_T_775; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_777 = _csignals_T_13 ? 3'h1 : _csignals_T_776; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_778 = _csignals_T_11 ? 3'h2 : _csignals_T_777; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_779 = _csignals_T_9 ? 3'h4 : _csignals_T_778; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_780 = _csignals_T_7 ? 3'h2 : _csignals_T_779; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_781 = _csignals_T_5 ? 3'h3 : _csignals_T_780; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_782 = _csignals_T_3 ? 3'h5 : _csignals_T_781; // @[Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h3 : _csignals_T_782; // @[Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 559:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 560:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 561:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 562:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h0; // @[Core.scala 566:17]
  wire  _id_op1_data_T_1 = csignals_1 == 3'h1; // @[Core.scala 567:17]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h3; // @[Core.scala 568:17]
  wire  _id_op1_data_T_3 = csignals_1 == 3'h4; // @[Core.scala 569:17]
  wire  _id_op1_data_T_4 = csignals_1 == 3'h5; // @[Core.scala 570:17]
  wire  _id_op1_data_T_5 = csignals_1 == 3'h6; // @[Core.scala 571:17]
  wire [31:0] _id_op1_data_T_6 = _id_op1_data_T_5 ? regfile_id_c_rs1p_data_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_7 = _id_op1_data_T_4 ? regfile_id_sp_data_data : _id_op1_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_8 = _id_op1_data_T_3 ? id_c_rs1_data : _id_op1_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_9 = _id_op1_data_T_2 ? id_imm_z_uext : _id_op1_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_10 = _id_op1_data_T_1 ? id_reg_pc : _id_op1_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? id_rs1_data : _id_op1_data_T_10; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 4'h1; // @[Core.scala 574:17]
  wire  _id_op2_data_T_1 = csignals_2 == 4'h2; // @[Core.scala 575:17]
  wire  _id_op2_data_T_2 = csignals_2 == 4'h3; // @[Core.scala 576:17]
  wire  _id_op2_data_T_3 = csignals_2 == 4'h4; // @[Core.scala 577:17]
  wire  _id_op2_data_T_4 = csignals_2 == 4'h5; // @[Core.scala 578:17]
  wire  _id_op2_data_T_5 = csignals_2 == 4'h6; // @[Core.scala 579:17]
  wire  _id_op2_data_T_6 = csignals_2 == 4'h7; // @[Core.scala 580:17]
  wire  _id_op2_data_T_7 = csignals_2 == 4'h8; // @[Core.scala 581:17]
  wire  _id_op2_data_T_8 = csignals_2 == 4'h9; // @[Core.scala 582:17]
  wire  _id_op2_data_T_9 = csignals_2 == 4'ha; // @[Core.scala 583:17]
  wire  _id_op2_data_T_10 = csignals_2 == 4'hb; // @[Core.scala 584:17]
  wire  _id_op2_data_T_11 = csignals_2 == 4'hc; // @[Core.scala 585:17]
  wire  _id_op2_data_T_12 = csignals_2 == 4'hd; // @[Core.scala 586:17]
  wire  _id_op2_data_T_13 = csignals_2 == 4'he; // @[Core.scala 587:17]
  wire  _id_op2_data_T_14 = csignals_2 == 4'hf; // @[Core.scala 588:17]
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
  wire  _id_csr_addr_T = csignals_7 == 3'h4; // @[Core.scala 591:36]
  wire [11:0] id_csr_addr = csignals_7 == 3'h4 ? 12'h342 : id_imm_i; // @[Core.scala 591:24]
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
  wire  id_is_j = _id_op2_data_T_3 | _id_op2_data_T_12; // @[Core.scala 621:42]
  reg [31:0] id_reg_pc_delay; // @[Core.scala 626:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 627:40]
  reg [2:0] id_reg_op1_sel_delay; // @[Core.scala 628:40]
  reg [3:0] id_reg_op2_sel_delay; // @[Core.scala 629:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 630:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 631:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 632:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 633:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 635:40]
  reg [1:0] id_reg_mem_wen_delay; // @[Core.scala 636:40]
  reg [1:0] id_reg_rf_wen_delay; // @[Core.scala 637:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 638:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 639:40]
  reg [2:0] id_reg_csr_cmd_delay; // @[Core.scala 640:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 643:40]
  reg [31:0] id_reg_mem_w_delay; // @[Core.scala 646:40]
  reg  id_reg_is_j_delay; // @[Core.scala 647:40]
  reg  id_reg_is_bp_pos_delay; // @[Core.scala 648:40]
  reg [31:0] id_reg_bp_addr_delay; // @[Core.scala 649:40]
  reg  id_reg_is_half_delay; // @[Core.scala 650:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 651:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 652:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 653:40]
  wire [31:0] _GEN_90 = _ic_read_en4_T ? id_reg_pc : id_reg_pc_delay; // @[Core.scala 657:26 658:32 626:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 696:43]
  wire [31:0] _GEN_141 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 705:24 706:29 732:29]
  wire [2:0] _GEN_142 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 705:24 707:29 733:29]
  wire [3:0] _GEN_143 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 705:24 708:29 734:29]
  wire [4:0] _GEN_144 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 705:24 709:29 735:29]
  wire [4:0] _GEN_145 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 705:24 710:29 736:29]
  wire [31:0] _GEN_146 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 705:24 711:29 737:29]
  wire [31:0] _GEN_147 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[Core.scala 705:24 712:29 738:29]
  wire [4:0] _GEN_149 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 705:24 714:29 740:29]
  wire [31:0] _GEN_153 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 705:24 718:29 744:29]
  wire [11:0] _GEN_154 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 705:24 719:29 745:29]
  wire [31:0] _GEN_156 = id_reg_stall ? id_reg_bp_addr_delay : id_reg_bp_addr; // @[Core.scala 705:24 725:29 751:29]
  wire  _GEN_157 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 705:24 726:29 752:29]
  wire [31:0] _GEN_158 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 705:24 729:29 755:29]
  wire  _T_29 = ~ex1_stall; // @[Core.scala 758:14]
  wire  _T_30 = ~mem_stall; // @[Core.scala 758:28]
  reg  ex1_reg_fw_en; // @[Core.scala 825:38]
  reg  ex2_reg_fw_en; // @[Core.scala 828:38]
  reg [31:0] ex2_reg_fw_data; // @[Core.scala 830:38]
  reg [1:0] mem_reg_rf_wen_delay; // @[Core.scala 831:38]
  reg [31:0] mem_reg_wb_data_delay; // @[Core.scala 833:38]
  reg [1:0] wb_reg_rf_wen_delay; // @[Core.scala 834:38]
  reg [4:0] wb_reg_wb_addr_delay; // @[Core.scala 835:38]
  reg [31:0] wb_reg_wb_data_delay; // @[Core.scala 836:38]
  wire  _ex1_op1_data_T_2 = _ex1_stall_T & ex1_reg_rs1_addr == 5'h0; // @[Core.scala 853:34]
  wire  _ex1_op1_data_T_4 = ex1_reg_fw_en & _ex1_stall_T; // @[Core.scala 854:20]
  wire  _ex1_op1_data_T_6 = _ex1_op1_data_T_4 & _ex1_stall_T_2; // @[Core.scala 855:36]
  wire  _ex1_op1_data_T_8 = ex2_reg_fw_en & _ex1_stall_T; // @[Core.scala 857:20]
  wire  _ex1_op1_data_T_10 = _ex1_op1_data_T_8 & _ex1_stall_T_6; // @[Core.scala 858:36]
  wire  _ex1_op1_data_T_11 = mem_reg_rf_wen_delay == 2'h1; // @[Core.scala 860:28]
  wire  _ex1_op1_data_T_13 = mem_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 860:39]
  wire  _ex1_op1_data_T_14 = ex1_reg_rs1_addr == wb_reg_wb_addr; // @[Core.scala 862:24]
  wire  _ex1_op1_data_T_15 = _ex1_op1_data_T_13 & _ex1_op1_data_T_14; // @[Core.scala 861:36]
  wire  _ex1_op1_data_T_16 = wb_reg_rf_wen_delay == 2'h1; // @[Core.scala 863:27]
  wire  _ex1_op1_data_T_18 = wb_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 863:38]
  wire  _ex1_op1_data_T_19 = ex1_reg_rs1_addr == wb_reg_wb_addr_delay; // @[Core.scala 865:24]
  wire  _ex1_op1_data_T_20 = _ex1_op1_data_T_18 & _ex1_op1_data_T_19; // @[Core.scala 864:36]
  wire [31:0] _ex1_op1_data_T_22 = _ex1_stall_T ? regfile_ex1_op1_data_MPORT_data : ex1_reg_op1_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_23 = _ex1_op1_data_T_20 ? wb_reg_wb_data_delay : _ex1_op1_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_24 = _ex1_op1_data_T_15 ? mem_reg_wb_data_delay : _ex1_op1_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_25 = _ex1_op1_data_T_10 ? ex2_reg_fw_data : _ex1_op1_data_T_24; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex2_reg_wb_sel == 3'h2; // @[Core.scala 975:21]
  wire [31:0] _ex1_fw_data_T_2 = ex2_reg_pc + 32'h2; // @[Core.scala 976:18]
  wire [31:0] _ex1_fw_data_T_4 = ex2_reg_pc + 32'h4; // @[Core.scala 977:18]
  wire [31:0] _ex1_fw_data_T_5 = ex2_reg_is_half ? _ex1_fw_data_T_2 : _ex1_fw_data_T_4; // @[Core.scala 975:38]
  wire  _ex2_alu_out_T = ex2_reg_exe_fun == 5'h1; // @[Core.scala 939:22]
  wire [31:0] _ex2_alu_out_T_2 = ex2_reg_op1_data + ex2_reg_op2_data; // @[Core.scala 939:58]
  wire  _ex2_alu_out_T_3 = ex2_reg_exe_fun == 5'h2; // @[Core.scala 940:22]
  wire [31:0] _ex2_alu_out_T_5 = ex2_reg_op1_data - ex2_reg_op2_data; // @[Core.scala 940:58]
  wire  _ex2_alu_out_T_6 = ex2_reg_exe_fun == 5'h3; // @[Core.scala 941:22]
  wire [31:0] _ex2_alu_out_T_7 = ex2_reg_op1_data & ex2_reg_op2_data; // @[Core.scala 941:58]
  wire  _ex2_alu_out_T_8 = ex2_reg_exe_fun == 5'h4; // @[Core.scala 942:22]
  wire [31:0] _ex2_alu_out_T_9 = ex2_reg_op1_data | ex2_reg_op2_data; // @[Core.scala 942:58]
  wire  _ex2_alu_out_T_10 = ex2_reg_exe_fun == 5'h5; // @[Core.scala 943:22]
  wire [31:0] _ex2_alu_out_T_11 = ex2_reg_op1_data ^ ex2_reg_op2_data; // @[Core.scala 943:58]
  wire  _ex2_alu_out_T_12 = ex2_reg_exe_fun == 5'h6; // @[Core.scala 944:22]
  wire [62:0] _GEN_26 = {{31'd0}, ex2_reg_op1_data}; // @[Core.scala 944:58]
  wire [62:0] _ex2_alu_out_T_14 = _GEN_26 << ex2_reg_op2_data[4:0]; // @[Core.scala 944:58]
  wire  _ex2_alu_out_T_16 = ex2_reg_exe_fun == 5'h7; // @[Core.scala 945:22]
  wire [31:0] _ex2_alu_out_T_18 = ex2_reg_op1_data >> ex2_reg_op2_data[4:0]; // @[Core.scala 945:58]
  wire  _ex2_alu_out_T_19 = ex2_reg_exe_fun == 5'h8; // @[Core.scala 946:22]
  wire [31:0] _ex2_alu_out_T_23 = $signed(ex2_reg_op1_data) >>> ex2_reg_op2_data[4:0]; // @[Core.scala 946:100]
  wire  _ex2_alu_out_T_24 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 947:22]
  wire  _ex2_alu_out_T_27 = $signed(ex2_reg_op1_data) < $signed(ex2_reg_op2_data); // @[Core.scala 947:67]
  wire  _ex2_alu_out_T_28 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 948:22]
  wire  _ex2_alu_out_T_29 = ex2_reg_op1_data < ex2_reg_op2_data; // @[Core.scala 948:58]
  wire  _ex2_alu_out_T_30 = ex2_reg_exe_fun == 5'h11; // @[Core.scala 949:22]
  wire [31:0] _ex2_alu_out_T_34 = _ex2_alu_out_T_2 & 32'hfffffffe; // @[Core.scala 949:79]
  wire  _ex2_alu_out_T_35 = ex2_reg_exe_fun == 5'h12; // @[Core.scala 950:22]
  wire [31:0] _ex2_alu_out_T_36 = _ex2_alu_out_T_35 ? ex2_reg_op1_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_37 = _ex2_alu_out_T_30 ? _ex2_alu_out_T_34 : _ex2_alu_out_T_36; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_38 = _ex2_alu_out_T_28 ? {{31'd0}, _ex2_alu_out_T_29} : _ex2_alu_out_T_37; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_39 = _ex2_alu_out_T_24 ? {{31'd0}, _ex2_alu_out_T_27} : _ex2_alu_out_T_38; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_40 = _ex2_alu_out_T_19 ? _ex2_alu_out_T_23 : _ex2_alu_out_T_39; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_41 = _ex2_alu_out_T_16 ? _ex2_alu_out_T_18 : _ex2_alu_out_T_40; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_42 = _ex2_alu_out_T_12 ? _ex2_alu_out_T_14[31:0] : _ex2_alu_out_T_41; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_43 = _ex2_alu_out_T_10 ? _ex2_alu_out_T_11 : _ex2_alu_out_T_42; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_44 = _ex2_alu_out_T_8 ? _ex2_alu_out_T_9 : _ex2_alu_out_T_43; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_45 = _ex2_alu_out_T_6 ? _ex2_alu_out_T_7 : _ex2_alu_out_T_44; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_out_T_46 = _ex2_alu_out_T_3 ? _ex2_alu_out_T_5 : _ex2_alu_out_T_45; // @[Mux.scala 101:16]
  wire [31:0] ex2_alu_out = _ex2_alu_out_T ? _ex2_alu_out_T_2 : _ex2_alu_out_T_46; // @[Mux.scala 101:16]
  wire [31:0] ex1_fw_data = _ex1_fw_data_T ? _ex1_fw_data_T_5 : ex2_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_26 = _ex1_op1_data_T_6 ? ex1_fw_data : _ex1_op1_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op1_data = _ex1_op1_data_T_2 ? 32'h0 : _ex1_op1_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_op2_data_T_1 = ex1_reg_rs2_addr == 5'h0; // @[Core.scala 869:54]
  wire  _ex1_op2_data_T_2 = _ex1_stall_T_9 & ex1_reg_rs2_addr == 5'h0; // @[Core.scala 869:34]
  wire  _ex1_op2_data_T_4 = ex1_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 870:20]
  wire  _ex1_op2_data_T_6 = _ex1_op2_data_T_4 & _ex1_stall_T_13; // @[Core.scala 871:36]
  wire  _ex1_op2_data_T_8 = ex2_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 873:20]
  wire  _ex1_op2_data_T_10 = _ex1_op2_data_T_8 & _ex1_stall_T_20; // @[Core.scala 874:36]
  wire  _ex1_op2_data_T_13 = _ex1_op1_data_T_11 & _ex1_stall_T_9; // @[Core.scala 876:39]
  wire  _ex1_op2_data_T_14 = ex1_reg_rs2_addr == wb_reg_wb_addr; // @[Core.scala 878:24]
  wire  _ex1_op2_data_T_15 = _ex1_op2_data_T_13 & _ex1_op2_data_T_14; // @[Core.scala 877:36]
  wire  _ex1_op2_data_T_18 = _ex1_op1_data_T_16 & _ex1_stall_T_9; // @[Core.scala 879:38]
  wire  _ex1_op2_data_T_19 = ex1_reg_rs2_addr == wb_reg_wb_addr_delay; // @[Core.scala 881:24]
  wire  _ex1_op2_data_T_20 = _ex1_op2_data_T_18 & _ex1_op2_data_T_19; // @[Core.scala 880:36]
  wire [31:0] _ex1_op2_data_T_22 = _ex1_stall_T_9 ? regfile_ex1_op2_data_MPORT_data : ex1_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_23 = _ex1_op2_data_T_20 ? wb_reg_wb_data_delay : _ex1_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_24 = _ex1_op2_data_T_15 ? mem_reg_wb_data_delay : _ex1_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_25 = _ex1_op2_data_T_10 ? ex2_reg_fw_data : _ex1_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_26 = _ex1_op2_data_T_6 ? ex1_fw_data : _ex1_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op2_data = _ex1_op2_data_T_2 ? 32'h0 : _ex1_op2_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_rs2_data_T_2 = ex1_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 886:20]
  wire  _ex1_rs2_data_T_4 = ex2_reg_fw_en & _ex1_stall_T_20; // @[Core.scala 888:20]
  wire  _ex1_rs2_data_T_7 = _ex1_op1_data_T_11 & _ex1_op2_data_T_14; // @[Core.scala 890:39]
  wire  _ex1_rs2_data_T_10 = _ex1_op1_data_T_16 & _ex1_op2_data_T_19; // @[Core.scala 892:38]
  wire [31:0] _ex1_rs2_data_T_11 = _ex1_rs2_data_T_10 ? wb_reg_wb_data_delay : regfile_ex1_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_12 = _ex1_rs2_data_T_7 ? mem_reg_wb_data_delay : _ex1_rs2_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_13 = _ex1_rs2_data_T_4 ? ex2_reg_fw_data : _ex1_rs2_data_T_12; // @[Mux.scala 101:16]
  wire  ex1_hazard = ex1_reg_rf_wen == 2'h1 & ex1_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 903:96]
  wire  ex_is_bubble = ex1_stall | mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 911:51]
  wire  _ex2_is_cond_br_T = ex2_reg_exe_fun == 5'hb; // @[Core.scala 955:22]
  wire  _ex2_is_cond_br_T_1 = ex2_reg_op1_data == ex2_reg_op2_data; // @[Core.scala 955:57]
  wire  _ex2_is_cond_br_T_2 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 956:22]
  wire  _ex2_is_cond_br_T_4 = ~_ex2_is_cond_br_T_1; // @[Core.scala 956:38]
  wire  _ex2_is_cond_br_T_5 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 957:22]
  wire  _ex2_is_cond_br_T_9 = ex2_reg_exe_fun == 5'he; // @[Core.scala 958:22]
  wire  _ex2_is_cond_br_T_13 = ~_ex2_alu_out_T_27; // @[Core.scala 958:38]
  wire  _ex2_is_cond_br_T_14 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 959:22]
  wire  _ex2_is_cond_br_T_16 = ex2_reg_exe_fun == 5'h10; // @[Core.scala 960:22]
  wire  _ex2_is_cond_br_T_18 = ~_ex2_alu_out_T_29; // @[Core.scala 960:38]
  wire  _ex2_is_cond_br_T_20 = _ex2_is_cond_br_T_14 ? _ex2_alu_out_T_29 : _ex2_is_cond_br_T_16 & _ex2_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_21 = _ex2_is_cond_br_T_9 ? _ex2_is_cond_br_T_13 : _ex2_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_inst_T_2 = _ex2_is_cond_br_T | _ex2_is_cond_br_T_2; // @[Core.scala 963:34]
  wire  _ex2_is_cond_br_inst_T_4 = _ex2_is_cond_br_inst_T_2 | _ex2_is_cond_br_T_5; // @[Core.scala 964:34]
  wire  _ex2_is_cond_br_inst_T_6 = _ex2_is_cond_br_inst_T_4 | _ex2_is_cond_br_T_9; // @[Core.scala 965:34]
  wire  _ex2_is_cond_br_inst_T_8 = _ex2_is_cond_br_inst_T_6 | _ex2_is_cond_br_T_14; // @[Core.scala 966:34]
  wire  ex2_is_cond_br_inst = _ex2_is_cond_br_inst_T_8 | _ex2_is_cond_br_T_16; // @[Core.scala 967:35]
  wire  ex2_is_uncond_br = _ex2_alu_out_T_30 | ex2_reg_is_j; // @[Core.scala 970:55]
  wire [31:0] ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext; // @[Core.scala 971:39]
  wire  ex2_hazard = ex2_reg_rf_wen == 2'h1 & ex2_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 982:96]
  wire  _ex3_reg_bp_en_T_3 = ex2_reg_is_valid_inst & _mem_en_T & _mem_en_T_2; // @[Core.scala 989:71]
  wire  ex3_bp_en = ex3_reg_bp_en & _mem_en_T & _mem_en_T_2; // @[Core.scala 1005:51]
  wire  _ex3_cond_bp_fail_T = ~ex3_reg_is_bp_pos; // @[Core.scala 1007:6]
  wire  _ex3_cond_bp_fail_T_4 = ex3_reg_is_bp_pos & ex3_reg_is_cond_br & ex3_reg_bp_addr != ex3_reg_cond_br_target; // @[Core.scala 1008:46]
  wire  _ex3_cond_bp_fail_T_5 = ~ex3_reg_is_bp_pos & ex3_reg_is_cond_br | _ex3_cond_bp_fail_T_4; // @[Core.scala 1007:48]
  wire  ex3_cond_bp_fail = ex3_bp_en & _ex3_cond_bp_fail_T_5; // @[Core.scala 1006:36]
  wire  ex3_cond_nbp_fail = ex3_bp_en & ex3_reg_is_bp_pos & ex3_reg_is_cond_br_inst & ~ex3_reg_is_cond_br; // @[Core.scala 1010:85]
  wire  _ex3_uncond_bp_fail_T_3 = ex3_reg_is_bp_pos & ex3_reg_bp_addr != ex3_reg_uncond_br_target; // @[Core.scala 1013:24]
  wire  _ex3_uncond_bp_fail_T_4 = _ex3_cond_bp_fail_T | _ex3_uncond_bp_fail_T_3; // @[Core.scala 1012:24]
  wire  ex3_uncond_bp_fail = ex3_bp_en & ex3_reg_is_uncond_br & _ex3_uncond_bp_fail_T_4; // @[Core.scala 1011:64]
  wire [31:0] _ex3_reg_br_target_T_1 = ex3_reg_pc + 32'h2; // @[Core.scala 1017:59]
  wire [31:0] _ex3_reg_br_target_T_3 = ex3_reg_pc + 32'h4; // @[Core.scala 1017:89]
  wire [31:0] _bp_io_up_br_addr_T = ex3_reg_is_uncond_br ? ex3_reg_uncond_br_target : 32'h0; // @[Mux.scala 101:16]
  wire  _mem_reg_mem_wstrb_T = ex2_reg_mem_w == 32'h3; // @[Core.scala 1061:22]
  wire  _mem_reg_mem_wstrb_T_1 = ex2_reg_mem_w == 32'h2; // @[Core.scala 1062:22]
  wire [3:0] _mem_reg_mem_wstrb_T_4 = _mem_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem_reg_mem_wstrb_T_5 = _mem_reg_mem_wstrb_T ? 4'h1 : _mem_reg_mem_wstrb_T_4; // @[Mux.scala 101:16]
  wire [6:0] _GEN_33 = {{3'd0}, _mem_reg_mem_wstrb_T_5}; // @[Core.scala 1064:8]
  wire [6:0] _mem_reg_mem_wstrb_T_7 = _GEN_33 << ex2_alu_out[1:0]; // @[Core.scala 1064:8]
  wire  mem_is_trap = mem_reg_is_trap & mem_is_valid_inst & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1078:76]
  wire [2:0] mem_csr_cmd = mem_en ? mem_reg_csr_cmd : 3'h0; // @[Core.scala 1082:24]
  wire [5:0] _io_dmem_wdata_T_1 = 4'h8 * mem_reg_alu_out[1:0]; // @[Core.scala 1091:46]
  wire [94:0] _GEN_45 = {{63'd0}, mem_reg_rs2_data}; // @[Core.scala 1091:38]
  wire [94:0] _io_dmem_wdata_T_2 = _GEN_45 << _io_dmem_wdata_T_1; // @[Core.scala 1091:38]
  wire [31:0] _csr_rdata_T_7 = 12'h305 == mem_reg_csr_addr ? csr_trap_vector : 32'h0; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_9 = 12'hc01 == mem_reg_csr_addr ? mtimer_io_mtime[31:0] : _csr_rdata_T_7; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_11 = 12'hc00 == mem_reg_csr_addr ? cycle_counter_io_value[31:0] : _csr_rdata_T_9; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_13 = 12'hc02 == mem_reg_csr_addr ? instret[31:0] : _csr_rdata_T_11; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_15 = 12'hc80 == mem_reg_csr_addr ? cycle_counter_io_value[63:32] : _csr_rdata_T_13; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_17 = 12'hc81 == mem_reg_csr_addr ? mtimer_io_mtime[63:32] : _csr_rdata_T_15; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_19 = 12'hc82 == mem_reg_csr_addr ? instret[63:32] : _csr_rdata_T_17; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_21 = 12'h341 == mem_reg_csr_addr ? csr_mepc : _csr_rdata_T_19; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_23 = 12'h342 == mem_reg_csr_addr ? csr_mcause : _csr_rdata_T_21; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_25 = 12'h343 == mem_reg_csr_addr ? 32'h0 : _csr_rdata_T_23; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_27 = 12'h300 == mem_reg_csr_addr ? csr_mstatus : _csr_rdata_T_25; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_29 = 12'h340 == mem_reg_csr_addr ? csr_mscratch : _csr_rdata_T_27; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_31 = 12'h304 == mem_reg_csr_addr ? csr_mie : _csr_rdata_T_29; // @[Mux.scala 81:58]
  wire [31:0] csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 1114:18]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 1115:18]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | mem_reg_op1_data; // @[Core.scala 1115:43]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 1116:18]
  wire [31:0] _csr_wdata_T_4 = ~mem_reg_op1_data; // @[Core.scala 1116:45]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1116:43]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? mem_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _GEN_263 = mem_reg_csr_addr == 12'h304 ? csr_wdata : csr_mie; // @[Core.scala 1128:52 1129:15 75:29]
  wire [31:0] _GEN_264 = mem_reg_csr_addr == 12'h340 ? csr_wdata : csr_mscratch; // @[Core.scala 1126:57 1127:20 74:29]
  wire [31:0] _GEN_265 = mem_reg_csr_addr == 12'h340 ? csr_mie : _GEN_263; // @[Core.scala 1126:57 75:29]
  wire [31:0] _GEN_266 = mem_reg_csr_addr == 12'h300 ? csr_wdata : csr_mstatus; // @[Core.scala 1124:56 1125:19 73:29]
  wire [31:0] _GEN_267 = mem_reg_csr_addr == 12'h300 ? csr_mscratch : _GEN_264; // @[Core.scala 1124:56 74:29]
  wire [31:0] _GEN_268 = mem_reg_csr_addr == 12'h300 ? csr_mie : _GEN_265; // @[Core.scala 1124:56 75:29]
  wire [31:0] _GEN_269 = mem_reg_csr_addr == 12'h341 ? csr_wdata : csr_mepc; // @[Core.scala 1122:53 1123:16 72:29]
  wire [31:0] _GEN_270 = mem_reg_csr_addr == 12'h341 ? csr_mstatus : _GEN_266; // @[Core.scala 1122:53 73:29]
  wire [31:0] _GEN_274 = mem_reg_csr_addr == 12'h305 ? csr_mepc : _GEN_269; // @[Core.scala 1120:48 72:29]
  wire [31:0] _GEN_275 = mem_reg_csr_addr == 12'h305 ? csr_mstatus : _GEN_270; // @[Core.scala 1120:48 73:29]
  wire [31:0] _GEN_279 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_274 : csr_mepc; // @[Core.scala 1119:82 72:29]
  wire [31:0] _GEN_280 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_275 : csr_mstatus; // @[Core.scala 1119:82 73:29]
  wire [31:0] _csr_mip_T_3 = {csr_mip[31:12],io_intr,csr_mip[10:8],mtimer_io_intr,csr_mip[6:0]}; // @[Cat.scala 31:58]
  wire [31:0] _csr_mstatus_T_4 = {csr_mstatus[31:8],csr_mstatus[3],csr_mstatus[6:4],1'h0,csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire  _T_46 = mem_csr_cmd == 3'h6; // @[Core.scala 1171:27]
  wire [31:0] _csr_mstatus_T_19 = {csr_mstatus[31:8],1'h1,csr_mstatus[6:4],csr_mstatus[7],csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_283 = mem_csr_cmd == 3'h6 ? _csr_mstatus_T_19 : _GEN_280; // @[Core.scala 1171:38 1172:21]
  wire [31:0] _GEN_285 = mem_csr_cmd == 3'h6 ? csr_mepc : mem_reg_br_addr; // @[Core.scala 1171:38 1174:21 198:35]
  wire  _GEN_290 = mem_is_trap | _T_46; // @[Core.scala 1159:28 1169:21]
  wire  _GEN_296 = mem_is_mtintr | _GEN_290; // @[Core.scala 1147:30 1157:21]
  wire  _GEN_302 = mem_is_meintr | _GEN_296; // @[Core.scala 1135:24 1145:21]
  wire [31:0] mem_wb_rdata = io_dmem_rdata >> _io_dmem_wdata_T_1; // @[Core.scala 1189:36]
  wire  _mem_wb_data_load_T = mem_reg_mem_w == 32'h3; // @[Core.scala 1191:20]
  wire [23:0] _mem_wb_data_load_T_3 = mem_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_5 = {_mem_wb_data_load_T_3,mem_wb_rdata[7:0]}; // @[Core.scala 1182:40]
  wire  _mem_wb_data_load_T_6 = mem_reg_mem_w == 32'h2; // @[Core.scala 1192:20]
  wire [15:0] _mem_wb_data_load_T_9 = mem_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_11 = {_mem_wb_data_load_T_9,mem_wb_rdata[15:0]}; // @[Core.scala 1182:40]
  wire  _mem_wb_data_load_T_12 = mem_reg_mem_w == 32'h5; // @[Core.scala 1193:20]
  wire [31:0] _mem_wb_data_load_T_15 = {24'h0,mem_wb_rdata[7:0]}; // @[Core.scala 1185:31]
  wire  _mem_wb_data_load_T_16 = mem_reg_mem_w == 32'h4; // @[Core.scala 1194:20]
  wire [31:0] _mem_wb_data_load_T_19 = {16'h0,mem_wb_rdata[15:0]}; // @[Core.scala 1185:31]
  wire [31:0] _mem_wb_data_load_T_20 = _mem_wb_data_load_T_16 ? _mem_wb_data_load_T_19 : mem_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_21 = _mem_wb_data_load_T_12 ? _mem_wb_data_load_T_15 : _mem_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_22 = _mem_wb_data_load_T_6 ? _mem_wb_data_load_T_11 : _mem_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data_load = _mem_wb_data_load_T ? _mem_wb_data_load_T_5 : _mem_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T = mem_reg_wb_sel == 3'h1; // @[Core.scala 1198:21]
  wire  _mem_wb_data_T_1 = mem_reg_wb_sel == 3'h2; // @[Core.scala 1199:21]
  wire [31:0] _mem_wb_data_T_3 = mem_reg_pc + 32'h2; // @[Core.scala 1199:68]
  wire [31:0] _mem_wb_data_T_5 = mem_reg_pc + 32'h4; // @[Core.scala 1199:98]
  wire [31:0] _mem_wb_data_T_6 = mem_reg_is_half ? _mem_wb_data_T_3 : _mem_wb_data_T_5; // @[Core.scala 1199:39]
  wire  _mem_wb_data_T_7 = mem_reg_wb_sel == 3'h3; // @[Core.scala 1200:21]
  wire [31:0] _mem_wb_data_T_8 = _mem_wb_data_T_7 ? csr_rdata : mem_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_9 = _mem_wb_data_T_1 ? _mem_wb_data_T_6 : _mem_wb_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data = _mem_wb_data_T ? mem_wb_data_load : _mem_wb_data_T_9; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h1; // @[Core.scala 1228:24]
  reg  do_exit; // @[Core.scala 1243:24]
  reg  do_exit_delay; // @[Core.scala 1244:30]
  LongCounter cycle_counter ( // @[Core.scala 67:29]
    .clock(cycle_counter_clock),
    .reset(cycle_counter_reset),
    .io_value(cycle_counter_io_value)
  );
  MachineTimer mtimer ( // @[Core.scala 68:22]
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
  BranchPredictor bp ( // @[Core.scala 320:18]
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
  assign regfile_id_rs1_data_MPORT_data = regfile[regfile_id_rs1_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_id_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_rs2_data_MPORT_addr = id_inst[24:20];
  assign regfile_id_rs2_data_MPORT_data = regfile[regfile_id_rs2_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_id_c_rs1_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs1_data_MPORT_addr = id_inst[11:7];
  assign regfile_id_c_rs1_data_MPORT_data = regfile[regfile_id_c_rs1_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_id_c_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs2_data_MPORT_addr = id_inst[6:2];
  assign regfile_id_c_rs2_data_MPORT_data = regfile[regfile_id_c_rs2_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_id_c_rs1p_data_en = 1'h1;
  assign regfile_id_c_rs1p_data_addr = {2'h1,id_inst[9:7]};
  assign regfile_id_c_rs1p_data_data = regfile[regfile_id_c_rs1p_data_addr]; // @[Core.scala 64:20]
  assign regfile_id_c_rs2p_data_en = 1'h1;
  assign regfile_id_c_rs2p_data_addr = {2'h1,id_inst[4:2]};
  assign regfile_id_c_rs2p_data_data = regfile[regfile_id_c_rs2p_data_addr]; // @[Core.scala 64:20]
  assign regfile_id_sp_data_en = 1'h1;
  assign regfile_id_sp_data_addr = 5'h2;
  assign regfile_id_sp_data_data = regfile[regfile_id_sp_data_addr]; // @[Core.scala 64:20]
  assign regfile_ex1_op1_data_MPORT_en = 1'h1;
  assign regfile_ex1_op1_data_MPORT_addr = ex1_reg_rs1_addr;
  assign regfile_ex1_op1_data_MPORT_data = regfile[regfile_ex1_op1_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_ex1_op2_data_MPORT_en = 1'h1;
  assign regfile_ex1_op2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_op2_data_MPORT_data = regfile[regfile_ex1_op2_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_ex1_rs2_data_MPORT_en = 1'h1;
  assign regfile_ex1_rs2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_rs2_data_MPORT_data = regfile[regfile_ex1_rs2_data_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_io_gp_MPORT_en = 1'h1;
  assign regfile_io_gp_MPORT_addr = 5'h3;
  assign regfile_io_gp_MPORT_data = regfile[regfile_io_gp_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_do_exit_MPORT_en = 1'h1;
  assign regfile_do_exit_MPORT_addr = 5'h11;
  assign regfile_do_exit_MPORT_data = regfile[regfile_do_exit_MPORT_addr]; // @[Core.scala 64:20]
  assign regfile_MPORT_data = wb_reg_wb_data;
  assign regfile_MPORT_addr = wb_reg_wb_addr;
  assign regfile_MPORT_mask = 1'h1;
  assign regfile_MPORT_en = wb_reg_rf_wen == 2'h1;
  assign io_imem_addr = if1_is_jump ? ic_next_imem_addr : _GEN_70; // @[Core.scala 229:21 231:18]
  assign io_icache_control_invalidate = mem_mem_wen == 2'h3; // @[Core.scala 1179:48]
  assign io_dmem_raddr = mem_reg_alu_out; // @[Core.scala 1086:17]
  assign io_dmem_ren = io_dmem_rready & _mem_stall_T; // @[Core.scala 1088:35]
  assign io_dmem_waddr = mem_reg_alu_out; // @[Core.scala 1087:17]
  assign io_dmem_wen = io_dmem_wready & _mem_stall_T_6; // @[Core.scala 1089:35]
  assign io_dmem_wstrb = mem_reg_mem_wstrb; // @[Core.scala 1090:17]
  assign io_dmem_wdata = _io_dmem_wdata_T_2[31:0]; // @[Core.scala 1091:71]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 78:17]
  assign io_mtimer_mem_rvalid = mtimer_io_mem_rvalid; // @[Core.scala 78:17]
  assign io_exit = do_exit_delay; // @[Core.scala 1247:11]
  assign io_debug_signal_mem_reg_pc = mem_reg_pc; // @[Core.scala 1236:30]
  assign io_debug_signal_mem_is_valid_inst = mem_reg_is_valid_inst & (_mem_en_T & _mem_en_T_2); // @[Core.scala 1075:49]
  assign io_debug_signal_csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  assign io_debug_signal_mem_reg_csr_addr = mem_reg_csr_addr; // @[Core.scala 1235:36]
  assign io_debug_signal_me_intr = csr_mstatus[3] & (io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1076:73]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value; // @[Core.scala 1232:33]
  assign io_debug_signal_instret = instret; // @[Core.scala 1233:27]
  assign cycle_counter_clock = clock;
  assign cycle_counter_reset = reset;
  assign mtimer_clock = clock;
  assign mtimer_reset = reset;
  assign mtimer_io_mem_raddr = io_mtimer_mem_raddr; // @[Core.scala 78:17]
  assign mtimer_io_mem_ren = io_mtimer_mem_ren; // @[Core.scala 78:17]
  assign mtimer_io_mem_waddr = io_mtimer_mem_waddr; // @[Core.scala 78:17]
  assign mtimer_io_mem_wen = io_mtimer_mem_wen; // @[Core.scala 78:17]
  assign mtimer_io_mem_wdata = io_mtimer_mem_wdata; // @[Core.scala 78:17]
  assign bp_clock = clock;
  assign bp_reset = reset;
  assign bp_io_lu_inst_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 346:24]
  assign bp_io_up_update_en = ex3_bp_en & (ex3_reg_is_cond_br_inst | ex3_reg_is_uncond_br); // @[Core.scala 1022:35]
  assign bp_io_up_inst_pc = ex3_reg_pc; // @[Core.scala 1023:20]
  assign bp_io_up_br_pos = ex3_reg_is_cond_br | ex3_reg_is_uncond_br; // @[Core.scala 1024:41]
  assign bp_io_up_br_addr = ex3_reg_is_cond_br ? ex3_reg_cond_br_target : _bp_io_up_br_addr_T; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (regfile_MPORT_en & regfile_MPORT_mask) begin
      regfile[regfile_MPORT_addr] <= regfile_MPORT_data; // @[Core.scala 64:20]
    end
    if (reset) begin // @[Core.scala 66:32]
      csr_trap_vector <= 32'h0; // @[Core.scala 66:32]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1119:82]
      if (mem_reg_csr_addr == 12'h305) begin // @[Core.scala 1120:48]
        if (_csr_wdata_T) begin // @[Mux.scala 101:16]
          csr_trap_vector <= mem_reg_op1_data;
        end else begin
          csr_trap_vector <= _csr_wdata_T_7;
        end
      end
    end
    if (reset) begin // @[Core.scala 69:24]
      instret <= 64'h0; // @[Core.scala 69:24]
    end else if (wb_reg_is_valid_inst) begin // @[Core.scala 1227:31]
      instret <= _instret_T_1; // @[Core.scala 1228:13]
    end
    if (reset) begin // @[Core.scala 70:29]
      csr_mcause <= 32'h0; // @[Core.scala 70:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1135:24]
      csr_mcause <= 32'h8000000b; // @[Core.scala 1136:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1147:30]
      csr_mcause <= 32'h80000007; // @[Core.scala 1148:21]
    end else if (mem_is_trap) begin // @[Core.scala 1159:28]
      csr_mcause <= mem_reg_mcause; // @[Core.scala 1160:21]
    end
    if (reset) begin // @[Core.scala 72:29]
      csr_mepc <= 32'h0; // @[Core.scala 72:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1135:24]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1138:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1147:30]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1150:21]
    end else if (mem_is_trap) begin // @[Core.scala 1159:28]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1162:21]
    end else begin
      csr_mepc <= _GEN_279;
    end
    if (reset) begin // @[Core.scala 73:29]
      csr_mstatus <= 32'h0; // @[Core.scala 73:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1135:24]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1144:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1147:30]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1156:21]
    end else if (mem_is_trap) begin // @[Core.scala 1159:28]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1168:21]
    end else begin
      csr_mstatus <= _GEN_283;
    end
    if (reset) begin // @[Core.scala 74:29]
      csr_mscratch <= 32'h0; // @[Core.scala 74:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1119:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1120:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1122:53]
          csr_mscratch <= _GEN_267;
        end
      end
    end
    if (reset) begin // @[Core.scala 75:29]
      csr_mie <= 32'h0; // @[Core.scala 75:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1119:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1120:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1122:53]
          csr_mie <= _GEN_268;
        end
      end
    end
    if (reset) begin // @[Core.scala 76:29]
      csr_mip <= 32'h0; // @[Core.scala 76:29]
    end else begin
      csr_mip <= _csr_mip_T_3; // @[Core.scala 1133:11]
    end
    if (reset) begin // @[Core.scala 84:38]
      id_reg_pc <= 32'h0; // @[Core.scala 84:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst)) begin // @[Core.scala 363:19]
        id_reg_pc <= if2_reg_pc;
      end else begin
        id_reg_pc <= ic_reg_addr_out;
      end
    end
    if (reset) begin // @[Core.scala 86:38]
      id_reg_inst <= 32'h0; // @[Core.scala 86:38]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (id_reg_stall) begin // @[Mux.scala 101:16]
      id_reg_inst <= if2_reg_inst;
    end else begin
      id_reg_inst <= _if2_inst_T_3;
    end
    if (reset) begin // @[Core.scala 87:38]
      id_reg_stall <= 1'h0; // @[Core.scala 87:38]
    end else begin
      id_reg_stall <= id_stall; // @[Core.scala 419:16]
    end
    if (reset) begin // @[Core.scala 88:38]
      id_reg_is_bp_pos <= 1'h0; // @[Core.scala 88:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Core.scala 386:26]
        id_reg_is_bp_pos <= if2_reg_is_bp_pos;
      end else begin
        id_reg_is_bp_pos <= _if2_is_bp_pos_T;
      end
    end
    if (reset) begin // @[Core.scala 89:38]
      id_reg_bp_addr <= 32'h0; // @[Core.scala 89:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= if2_reg_bp_addr;
      end else if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        id_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 95:38]
      ex1_reg_pc <= 32'h0; // @[Core.scala 95:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_pc <= _GEN_141;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_pc <= _GEN_141;
    end
    if (reset) begin // @[Core.scala 96:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 96:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_wb_addr <= _GEN_149;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_wb_addr <= _GEN_149;
    end
    if (reset) begin // @[Core.scala 97:38]
      ex1_reg_op1_sel <= 3'h0; // @[Core.scala 97:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_op1_sel <= _GEN_142;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_op1_sel <= _GEN_142;
    end
    if (reset) begin // @[Core.scala 98:38]
      ex1_reg_op2_sel <= 4'h0; // @[Core.scala 98:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_op2_sel <= _GEN_143;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_op2_sel <= _GEN_143;
    end
    if (reset) begin // @[Core.scala 99:38]
      ex1_reg_rs1_addr <= 5'h0; // @[Core.scala 99:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_rs1_addr <= _GEN_144;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_rs1_addr <= _GEN_144;
    end
    if (reset) begin // @[Core.scala 100:38]
      ex1_reg_rs2_addr <= 5'h0; // @[Core.scala 100:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_rs2_addr <= _GEN_145;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_rs2_addr <= _GEN_145;
    end
    if (reset) begin // @[Core.scala 101:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 101:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_op1_data <= _GEN_146;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_op1_data <= _GEN_146;
    end
    if (reset) begin // @[Core.scala 102:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 102:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_op2_data <= _GEN_147;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_op2_data <= _GEN_147;
    end
    if (reset) begin // @[Core.scala 104:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 104:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_exe_fun <= 5'h1;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 771:29]
      end else begin
        ex1_reg_exe_fun <= csignals_0; // @[Core.scala 801:29]
      end
    end
    if (reset) begin // @[Core.scala 105:38]
      ex1_reg_mem_wen <= 2'h0; // @[Core.scala 105:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_mem_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_mem_wen <= id_reg_mem_wen_delay; // @[Core.scala 780:29]
      end else begin
        ex1_reg_mem_wen <= csignals_3; // @[Core.scala 810:29]
      end
    end
    if (reset) begin // @[Core.scala 106:38]
      ex1_reg_rf_wen <= 2'h0; // @[Core.scala 106:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_rf_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 770:29]
      end else begin
        ex1_reg_rf_wen <= csignals_4; // @[Core.scala 800:29]
      end
    end
    if (reset) begin // @[Core.scala 107:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 107:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_wb_sel <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 772:29]
      end else begin
        ex1_reg_wb_sel <= csignals_5; // @[Core.scala 802:29]
      end
    end
    if (reset) begin // @[Core.scala 108:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 108:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_csr_addr <= _GEN_154;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_csr_addr <= _GEN_154;
    end
    if (reset) begin // @[Core.scala 109:38]
      ex1_reg_csr_cmd <= 3'h0; // @[Core.scala 109:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_csr_cmd <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 779:29]
      end else begin
        ex1_reg_csr_cmd <= csignals_7; // @[Core.scala 809:29]
      end
    end
    if (reset) begin // @[Core.scala 112:38]
      ex1_reg_imm_b_sext <= 32'h0; // @[Core.scala 112:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_imm_b_sext <= _GEN_153;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_imm_b_sext <= _GEN_153;
    end
    if (reset) begin // @[Core.scala 115:38]
      ex1_reg_mem_w <= 32'h0; // @[Core.scala 115:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_mem_w <= 32'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 781:29]
      end else begin
        ex1_reg_mem_w <= {{29'd0}, csignals_8}; // @[Core.scala 811:29]
      end
    end
    if (reset) begin // @[Core.scala 116:39]
      ex1_reg_is_j <= 1'h0; // @[Core.scala 116:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_is_j <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_is_j <= id_reg_is_j_delay; // @[Core.scala 782:29]
      end else begin
        ex1_reg_is_j <= id_is_j; // @[Core.scala 812:29]
      end
    end
    if (reset) begin // @[Core.scala 117:39]
      ex1_reg_is_bp_pos <= 1'h0; // @[Core.scala 117:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_is_bp_pos <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos_delay; // @[Core.scala 783:29]
      end else begin
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos; // @[Core.scala 813:29]
      end
    end
    if (reset) begin // @[Core.scala 118:39]
      ex1_reg_bp_addr <= 32'h0; // @[Core.scala 118:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_bp_addr <= _GEN_156;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_bp_addr <= _GEN_156;
    end
    if (reset) begin // @[Core.scala 119:39]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 119:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_is_half <= _GEN_157;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_is_half <= _GEN_157;
    end
    if (reset) begin // @[Core.scala 120:39]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 120:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_is_valid_inst <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 786:29]
      end else begin
        ex1_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 816:29]
      end
    end
    if (reset) begin // @[Core.scala 121:39]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 121:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_is_trap <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      if (id_reg_stall) begin // @[Core.scala 760:24]
        ex1_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 787:29]
      end else begin
        ex1_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 817:29]
      end
    end
    if (reset) begin // @[Core.scala 122:39]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 122:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 704:41]
      ex1_reg_mcause <= _GEN_158;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 758:40]
      ex1_reg_mcause <= _GEN_158;
    end
    if (reset) begin // @[Core.scala 126:38]
      ex2_reg_pc <= 32'h0; // @[Core.scala 126:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 912:27]
    end
    if (reset) begin // @[Core.scala 127:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 127:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 916:27]
    end
    if (reset) begin // @[Core.scala 128:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 128:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (_ex1_op1_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= 32'h0;
      end else if (_ex1_op1_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= ex1_fw_data;
      end else begin
        ex2_reg_op1_data <= _ex1_op1_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 129:38]
      ex2_reg_op2_data <= 32'h0; // @[Core.scala 129:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (_ex1_op2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= 32'h0;
      end else if (_ex1_op2_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= ex1_fw_data;
      end else begin
        ex2_reg_op2_data <= _ex1_op2_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 130:38]
      ex2_reg_rs2_data <= 32'h0; // @[Core.scala 130:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (_ex1_op2_data_T_1) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= 32'h0;
      end else if (_ex1_rs2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= ex1_fw_data;
      end else begin
        ex2_reg_rs2_data <= _ex1_rs2_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 131:38]
      ex2_reg_exe_fun <= 5'h0; // @[Core.scala 131:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 918:33]
        ex2_reg_exe_fun <= 5'h1;
      end else begin
        ex2_reg_exe_fun <= ex1_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 132:38]
      ex2_reg_mem_wen <= 2'h0; // @[Core.scala 132:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 923:33]
        ex2_reg_mem_wen <= 2'h0;
      end else begin
        ex2_reg_mem_wen <= ex1_reg_mem_wen;
      end
    end
    if (reset) begin // @[Core.scala 133:38]
      ex2_reg_rf_wen <= 2'h0; // @[Core.scala 133:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 917:33]
        ex2_reg_rf_wen <= 2'h0;
      end else begin
        ex2_reg_rf_wen <= ex1_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 134:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 134:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 919:33]
        ex2_reg_wb_sel <= 3'h0;
      end else begin
        ex2_reg_wb_sel <= ex1_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 135:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 135:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 921:27]
    end
    if (reset) begin // @[Core.scala 136:38]
      ex2_reg_csr_cmd <= 3'h0; // @[Core.scala 136:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 922:33]
        ex2_reg_csr_cmd <= 3'h0;
      end else begin
        ex2_reg_csr_cmd <= ex1_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 137:38]
      ex2_reg_imm_b_sext <= 32'h0; // @[Core.scala 137:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_imm_b_sext <= ex1_reg_imm_b_sext; // @[Core.scala 920:27]
    end
    if (reset) begin // @[Core.scala 138:38]
      ex2_reg_mem_w <= 32'h0; // @[Core.scala 138:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 924:27]
    end
    if (reset) begin // @[Core.scala 139:38]
      ex2_reg_is_j <= 1'h0; // @[Core.scala 139:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_is_j <= ex1_reg_is_j; // @[Core.scala 925:27]
    end
    if (reset) begin // @[Core.scala 140:38]
      ex2_reg_is_bp_pos <= 1'h0; // @[Core.scala 140:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_is_bp_pos <= ex1_reg_is_bp_pos; // @[Core.scala 926:27]
    end
    if (reset) begin // @[Core.scala 141:38]
      ex2_reg_bp_addr <= 32'h0; // @[Core.scala 141:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_bp_addr <= ex1_reg_bp_addr; // @[Core.scala 927:27]
    end
    if (reset) begin // @[Core.scala 142:38]
      ex2_reg_is_half <= 1'h0; // @[Core.scala 142:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_is_half <= ex1_reg_is_half; // @[Core.scala 928:27]
    end
    if (reset) begin // @[Core.scala 143:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 143:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_is_valid_inst <= ex1_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 929:27]
    end
    if (reset) begin // @[Core.scala 144:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 144:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      if (ex_is_bubble) begin // @[Core.scala 930:33]
        ex2_reg_is_trap <= 1'h0;
      end else begin
        ex2_reg_is_trap <= ex1_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 145:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 145:38]
    end else if (_T_30) begin // @[Core.scala 910:20]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 931:27]
    end
    if (reset) begin // @[Core.scala 149:41]
      ex3_reg_bp_en <= 1'h0; // @[Core.scala 149:41]
    end else begin
      ex3_reg_bp_en <= ex2_reg_is_valid_inst & _mem_en_T & _mem_en_T_2; // @[Core.scala 989:28]
    end
    if (reset) begin // @[Core.scala 150:41]
      ex3_reg_pc <= 32'h0; // @[Core.scala 150:41]
    end else begin
      ex3_reg_pc <= ex2_reg_pc; // @[Core.scala 990:28]
    end
    if (reset) begin // @[Core.scala 151:41]
      ex3_reg_is_cond_br <= 1'h0; // @[Core.scala 151:41]
    end else if (_ex2_is_cond_br_T) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_1;
    end else if (_ex2_is_cond_br_T_2) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_4;
    end else if (_ex2_is_cond_br_T_5) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_alu_out_T_27;
    end else begin
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_21;
    end
    if (reset) begin // @[Core.scala 152:41]
      ex3_reg_is_cond_br_inst <= 1'h0; // @[Core.scala 152:41]
    end else begin
      ex3_reg_is_cond_br_inst <= ex2_is_cond_br_inst; // @[Core.scala 993:28]
    end
    if (reset) begin // @[Core.scala 153:41]
      ex3_reg_is_uncond_br <= 1'h0; // @[Core.scala 153:41]
    end else begin
      ex3_reg_is_uncond_br <= ex2_is_uncond_br; // @[Core.scala 994:28]
    end
    if (reset) begin // @[Core.scala 154:41]
      ex3_reg_cond_br_target <= 32'h0; // @[Core.scala 154:41]
    end else begin
      ex3_reg_cond_br_target <= ex2_cond_br_target; // @[Core.scala 995:28]
    end
    if (reset) begin // @[Core.scala 155:41]
      ex3_reg_uncond_br_target <= 32'h0; // @[Core.scala 155:41]
    end else if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_2;
    end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_5;
    end else if (_ex2_alu_out_T_6) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_7;
    end else begin
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_44;
    end
    if (reset) begin // @[Core.scala 157:41]
      ex3_reg_is_bp_pos <= 1'h0; // @[Core.scala 157:41]
    end else begin
      ex3_reg_is_bp_pos <= ex2_reg_is_bp_pos; // @[Core.scala 998:28]
    end
    if (reset) begin // @[Core.scala 158:41]
      ex3_reg_bp_addr <= 32'h0; // @[Core.scala 158:41]
    end else begin
      ex3_reg_bp_addr <= ex2_reg_bp_addr; // @[Core.scala 999:28]
    end
    if (reset) begin // @[Core.scala 159:41]
      ex3_reg_is_half <= 1'h0; // @[Core.scala 159:41]
    end else begin
      ex3_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1000:28]
    end
    if (reset) begin // @[Core.scala 162:38]
      mem_reg_en <= 1'h0; // @[Core.scala 162:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_en <= _mem_is_valid_inst_T_2; // @[Core.scala 1047:24]
    end
    if (reset) begin // @[Core.scala 163:38]
      mem_reg_pc <= 32'h0; // @[Core.scala 163:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_pc <= ex2_reg_pc; // @[Core.scala 1048:24]
    end
    if (reset) begin // @[Core.scala 164:38]
      mem_reg_wb_addr <= 5'h0; // @[Core.scala 164:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_wb_addr <= ex2_reg_wb_addr; // @[Core.scala 1051:24]
    end
    if (reset) begin // @[Core.scala 165:38]
      mem_reg_op1_data <= 32'h0; // @[Core.scala 165:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_op1_data <= ex2_reg_op1_data; // @[Core.scala 1049:24]
    end
    if (reset) begin // @[Core.scala 166:38]
      mem_reg_rs2_data <= 32'h0; // @[Core.scala 166:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_rs2_data <= ex2_reg_rs2_data; // @[Core.scala 1050:24]
    end
    if (reset) begin // @[Core.scala 167:38]
      mem_reg_mem_wen <= 2'h0; // @[Core.scala 167:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_mem_wen <= ex2_reg_mem_wen; // @[Core.scala 1058:24]
    end
    if (reset) begin // @[Core.scala 168:38]
      mem_reg_rf_wen <= 2'h0; // @[Core.scala 168:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_rf_wen <= ex2_reg_rf_wen; // @[Core.scala 1053:24]
    end
    if (reset) begin // @[Core.scala 169:38]
      mem_reg_wb_sel <= 3'h0; // @[Core.scala 169:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_wb_sel <= ex2_reg_wb_sel; // @[Core.scala 1054:24]
    end
    if (reset) begin // @[Core.scala 170:38]
      mem_reg_csr_addr <= 12'h0; // @[Core.scala 170:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_csr_addr <= ex2_reg_csr_addr; // @[Core.scala 1055:24]
    end
    if (reset) begin // @[Core.scala 171:38]
      mem_reg_csr_cmd <= 3'h0; // @[Core.scala 171:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_csr_cmd <= ex2_reg_csr_cmd; // @[Core.scala 1056:24]
    end
    if (reset) begin // @[Core.scala 173:38]
      mem_reg_alu_out <= 32'h0; // @[Core.scala 173:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_2;
      end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_5;
      end else begin
        mem_reg_alu_out <= _ex2_alu_out_T_45;
      end
    end
    if (reset) begin // @[Core.scala 174:38]
      mem_reg_mem_w <= 32'h0; // @[Core.scala 174:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_mem_w <= ex2_reg_mem_w; // @[Core.scala 1059:24]
    end
    if (reset) begin // @[Core.scala 175:38]
      mem_reg_mem_wstrb <= 4'h0; // @[Core.scala 175:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_mem_wstrb <= _mem_reg_mem_wstrb_T_7[3:0]; // @[Core.scala 1060:24]
    end
    if (reset) begin // @[Core.scala 176:38]
      mem_reg_is_half <= 1'h0; // @[Core.scala 176:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1065:24]
    end
    if (reset) begin // @[Core.scala 177:38]
      mem_reg_is_valid_inst <= 1'h0; // @[Core.scala 177:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_is_valid_inst <= _ex3_reg_bp_en_T_3; // @[Core.scala 1066:27]
    end
    if (reset) begin // @[Core.scala 178:38]
      mem_reg_is_trap <= 1'h0; // @[Core.scala 178:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_is_trap <= ex2_reg_is_trap; // @[Core.scala 1067:24]
    end
    if (reset) begin // @[Core.scala 179:38]
      mem_reg_mcause <= 32'h0; // @[Core.scala 179:38]
    end else if (_T_30) begin // @[Core.scala 1046:22]
      mem_reg_mcause <= ex2_reg_mcause; // @[Core.scala 1068:24]
    end
    if (reset) begin // @[Core.scala 183:38]
      wb_reg_wb_addr <= 5'h0; // @[Core.scala 183:38]
    end else begin
      wb_reg_wb_addr <= mem_reg_wb_addr; // @[Core.scala 1210:18]
    end
    if (reset) begin // @[Core.scala 184:38]
      wb_reg_rf_wen <= 2'h0; // @[Core.scala 184:38]
    end else if (_T_30) begin // @[Core.scala 1211:24]
      if (mem_en) begin // @[Core.scala 1080:23]
        wb_reg_rf_wen <= mem_reg_rf_wen;
      end else begin
        wb_reg_rf_wen <= 2'h0;
      end
    end else begin
      wb_reg_rf_wen <= 2'h0;
    end
    if (reset) begin // @[Core.scala 185:38]
      wb_reg_wb_data <= 32'h0; // @[Core.scala 185:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_11;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1199:39]
        wb_reg_wb_data <= _mem_wb_data_T_3;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= csr_rdata;
    end else begin
      wb_reg_wb_data <= mem_reg_alu_out;
    end
    if (reset) begin // @[Core.scala 186:38]
      wb_reg_is_valid_inst <= 1'h0; // @[Core.scala 186:38]
    end else begin
      wb_reg_is_valid_inst <= mem_is_valid_inst & _T_30 & _mem_en_T_4 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1213:24]
    end
    if (reset) begin // @[Core.scala 188:35]
      if2_reg_is_bp_pos <= 1'h0; // @[Core.scala 188:35]
    end else if (!(id_reg_stall)) begin // @[Core.scala 386:26]
      if2_reg_is_bp_pos <= _if2_is_bp_pos_T;
    end
    if (reset) begin // @[Core.scala 189:35]
      if2_reg_bp_addr <= 32'h0; // @[Core.scala 189:35]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        if2_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 193:35]
      ex3_reg_is_br <= 1'h0; // @[Core.scala 193:35]
    end else begin
      ex3_reg_is_br <= ex3_cond_bp_fail | ex3_cond_nbp_fail | ex3_uncond_bp_fail; // @[Core.scala 1020:17]
    end
    if (reset) begin // @[Core.scala 194:35]
      ex3_reg_br_target <= 32'h0; // @[Core.scala 194:35]
    end else if (ex3_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_cond_br_target;
    end else if (ex3_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (ex3_reg_is_half) begin // @[Core.scala 1017:30]
        ex3_reg_br_target <= _ex3_reg_br_target_T_1;
      end else begin
        ex3_reg_br_target <= _ex3_reg_br_target_T_3;
      end
    end else if (ex3_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_br_target <= 32'h0;
    end
    if (reset) begin // @[Core.scala 197:35]
      mem_reg_is_br <= 1'h0; // @[Core.scala 197:35]
    end else begin
      mem_reg_is_br <= _GEN_302;
    end
    if (reset) begin // @[Core.scala 198:35]
      mem_reg_br_addr <= 32'h0; // @[Core.scala 198:35]
    end else if (mem_is_meintr) begin // @[Core.scala 1135:24]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1146:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1147:30]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1158:21]
    end else if (mem_is_trap) begin // @[Core.scala 1159:28]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1170:21]
    end else begin
      mem_reg_br_addr <= _GEN_285;
    end
    if (reset) begin // @[Core.scala 207:32]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 207:32]
    end else if (if1_is_jump) begin // @[Core.scala 229:21]
      ic_reg_read_rdy <= ~if1_jump_addr[1]; // @[Core.scala 235:21]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
      ic_reg_read_rdy <= 1'h1; // @[Core.scala 225:19]
    end
    if (reset) begin // @[Core.scala 208:32]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 208:32]
    end else begin
      ic_reg_half_rdy <= _GEN_84;
    end
    if (reset) begin // @[Core.scala 210:33]
      ic_reg_imem_addr <= 32'h0; // @[Core.scala 210:33]
    end else if (if1_is_jump) begin // @[Core.scala 229:21]
      ic_reg_imem_addr <= ic_next_imem_addr; // @[Core.scala 231:18]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
      if (3'h0 == ic_state) begin // @[Core.scala 240:23]
        ic_reg_imem_addr <= ic_imem_addr_4; // @[Core.scala 242:22]
      end else begin
        ic_reg_imem_addr <= _GEN_50;
      end
    end
    if (reset) begin // @[Core.scala 211:32]
      ic_reg_addr_out <= 32'h0; // @[Core.scala 211:32]
    end else if (if1_is_jump) begin // @[Core.scala 229:21]
      if (mem_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= mem_reg_br_addr;
      end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= ex3_reg_br_target;
      end else begin
        ic_reg_addr_out <= _if1_jump_addr_T_1;
      end
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
      if (3'h0 == ic_state) begin // @[Core.scala 240:23]
        ic_reg_addr_out <= _GEN_2;
      end else begin
        ic_reg_addr_out <= _GEN_55;
      end
    end
    if (reset) begin // @[Core.scala 213:34]
      ic_reg_inst <= 32'h0; // @[Core.scala 213:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 229:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
        if (3'h0 == ic_state) begin // @[Core.scala 240:23]
          ic_reg_inst <= io_imem_inst; // @[Core.scala 244:21]
        end else begin
          ic_reg_inst <= _GEN_52;
        end
      end
    end
    if (reset) begin // @[Core.scala 214:34]
      ic_reg_inst_addr <= 32'h0; // @[Core.scala 214:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 229:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
        if (3'h0 == ic_state) begin // @[Core.scala 240:23]
          ic_reg_inst_addr <= ic_reg_imem_addr; // @[Core.scala 245:26]
        end else begin
          ic_reg_inst_addr <= _GEN_53;
        end
      end
    end
    if (reset) begin // @[Core.scala 215:34]
      ic_reg_inst2 <= 32'h0; // @[Core.scala 215:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 229:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 240:23]
          ic_reg_inst2 <= _GEN_57;
        end
      end
    end
    if (reset) begin // @[Core.scala 216:34]
      ic_reg_inst2_addr <= 32'h0; // @[Core.scala 216:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 229:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 240:23]
          ic_reg_inst2_addr <= _GEN_58;
        end
      end
    end
    if (reset) begin // @[Core.scala 218:25]
      ic_state <= 3'h0; // @[Core.scala 218:25]
    end else if (if1_is_jump) begin // @[Core.scala 229:21]
      ic_state <= {{2'd0}, if1_jump_addr[1]}; // @[Core.scala 234:14]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 236:94]
      if (3'h0 == ic_state) begin // @[Core.scala 240:23]
        ic_state <= _GEN_3;
      end else begin
        ic_state <= _GEN_56;
      end
    end
    if1_reg_first <= reset; // @[Core.scala 326:{30,30} 327:17]
    if (reset) begin // @[Core.scala 345:32]
      if1_reg_next_pc <= 32'h0; // @[Core.scala 345:32]
    end else if (id_reg_stall) begin // @[Core.scala 348:25]
      if (if1_is_jump) begin // @[Core.scala 346:24]
        if (mem_reg_is_br) begin // @[Mux.scala 101:16]
          if1_reg_next_pc <= mem_reg_br_addr;
        end else begin
          if1_reg_next_pc <= _if1_jump_addr_T_2;
        end
      end
    end else begin
      if1_reg_next_pc <= if1_next_pc_4;
    end
    if (reset) begin // @[Core.scala 357:29]
      if2_reg_pc <= 32'h8000000; // @[Core.scala 357:29]
    end else if (!(id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst))) begin // @[Core.scala 363:19]
      if2_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 358:29]
      if2_reg_inst <= 32'h0; // @[Core.scala 358:29]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if2_reg_inst <= _if2_inst_T_3;
    end
    if (reset) begin // @[Core.scala 826:38]
      ex1_reg_hazard <= 1'h0; // @[Core.scala 826:38]
    end else if (_T_30) begin // @[Core.scala 902:20]
      ex1_reg_hazard <= ex1_hazard & (ex1_reg_wb_sel == 3'h1 | ex1_reg_wb_sel == 3'h3); // @[Core.scala 905:20]
    end
    if (reset) begin // @[Core.scala 829:38]
      ex2_reg_hazard <= 1'h0; // @[Core.scala 829:38]
    end else if (_T_30) begin // @[Core.scala 981:20]
      ex2_reg_hazard <= ex2_hazard & (ex2_reg_wb_sel == 3'h1 | ex2_reg_wb_sel == 3'h3); // @[Core.scala 984:20]
    end
    if (reset) begin // @[Core.scala 1084:32]
      mem_stall_delay <= 1'h0; // @[Core.scala 1084:32]
    end else begin
      mem_stall_delay <= _mem_stall_T & io_dmem_rvalid & _T_30; // @[Core.scala 1093:19]
    end
    if (reset) begin // @[Core.scala 626:40]
      id_reg_pc_delay <= 32'h0; // @[Core.scala 626:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_pc_delay <= _GEN_90;
    end else begin
      id_reg_pc_delay <= _GEN_90;
    end
    if (reset) begin // @[Core.scala 627:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 627:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_wb_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_wb_addr_delay <= _id_wb_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 628:40]
      id_reg_op1_sel_delay <= 3'h0; // @[Core.scala 628:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_op1_sel_delay <= 3'h0;
        end else begin
          id_reg_op1_sel_delay <= _id_m_op1_sel_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 629:40]
      id_reg_op2_sel_delay <= 4'h0; // @[Core.scala 629:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_op2_sel_delay <= 4'h1;
        end else begin
          id_reg_op2_sel_delay <= _id_m_op2_sel_T_2;
        end
      end
    end
    if (reset) begin // @[Core.scala 630:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 630:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_rs1_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 631:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 631:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_rs2_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 632:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 632:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= id_rs1_data;
        end else begin
          id_reg_op1_data_delay <= _id_op1_data_T_10;
        end
      end
    end
    if (reset) begin // @[Core.scala 633:40]
      id_reg_op2_data_delay <= 32'h0; // @[Core.scala 633:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_op2_data_T) begin // @[Mux.scala 101:16]
          id_reg_op2_data_delay <= id_rs2_data;
        end else begin
          id_reg_op2_data_delay <= _id_op2_data_T_28;
        end
      end
    end
    if (reset) begin // @[Core.scala 635:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 635:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_exe_fun_delay <= 5'h1; // @[Core.scala 661:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h1;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_214;
      end
    end
    if (reset) begin // @[Core.scala 636:40]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 636:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 664:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else begin
        id_reg_mem_wen_delay <= _csignals_T_427;
      end
    end
    if (reset) begin // @[Core.scala 637:40]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 637:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 660:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_rf_wen_delay <= 2'h1;
      end else begin
        id_reg_rf_wen_delay <= _csignals_T_498;
      end
    end
    if (reset) begin // @[Core.scala 638:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 638:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 662:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h1;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_569;
      end
    end
    if (reset) begin // @[Core.scala 639:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 639:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (csignals_7 == 3'h4) begin // @[Core.scala 591:24]
          id_reg_csr_addr_delay <= 12'h342;
        end else begin
          id_reg_csr_addr_delay <= id_imm_i;
        end
      end
    end
    if (reset) begin // @[Core.scala 640:40]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 640:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 663:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_711;
      end
    end
    if (reset) begin // @[Core.scala 643:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 643:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_imm_b_sext_delay <= id_c_imm_b;
        end else begin
          id_reg_imm_b_sext_delay <= id_imm_b_sext;
        end
      end
    end
    if (reset) begin // @[Core.scala 646:40]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 646:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 665:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      id_reg_mem_w_delay <= {{29'd0}, csignals_8}; // @[Core.scala 691:29]
    end
    if (reset) begin // @[Core.scala 647:40]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 647:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 666:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      id_reg_is_j_delay <= id_is_j; // @[Core.scala 692:29]
    end
    if (reset) begin // @[Core.scala 648:40]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 648:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 667:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      id_reg_is_bp_pos_delay <= id_reg_is_bp_pos; // @[Core.scala 693:29]
    end
    if (reset) begin // @[Core.scala 649:40]
      id_reg_bp_addr_delay <= 32'h0; // @[Core.scala 649:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        id_reg_bp_addr_delay <= id_reg_bp_addr; // @[Core.scala 694:29]
      end
    end
    if (reset) begin // @[Core.scala 650:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 650:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        id_reg_is_half_delay <= id_is_half; // @[Core.scala 695:29]
      end
    end
    if (reset) begin // @[Core.scala 651:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 651:43]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 668:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 696:32]
    end
    if (reset) begin // @[Core.scala 652:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 652:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 656:41]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 669:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 670:30]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 697:29]
    end
    if (reset) begin // @[Core.scala 653:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 653:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 656:41]
      if (_ic_read_en4_T) begin // @[Core.scala 670:30]
        id_reg_mcause_delay <= 32'hb; // @[Core.scala 698:29]
      end
    end
    if (reset) begin // @[Core.scala 825:38]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 825:38]
    end else if (_T_30) begin // @[Core.scala 902:20]
      ex1_reg_fw_en <= _T_29 & ex1_hazard & ex1_reg_wb_sel != 3'h1 & ex1_reg_wb_sel != 3'h3; // @[Core.scala 904:19]
    end
    if (reset) begin // @[Core.scala 828:38]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 828:38]
    end else if (_T_30) begin // @[Core.scala 981:20]
      ex2_reg_fw_en <= ex2_hazard & ex2_reg_wb_sel != 3'h1 & ex2_reg_wb_sel != 3'h3; // @[Core.scala 983:19]
    end
    if (reset) begin // @[Core.scala 830:38]
      ex2_reg_fw_data <= 32'h0; // @[Core.scala 830:38]
    end else if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
      if (ex2_reg_is_half) begin // @[Core.scala 975:38]
        ex2_reg_fw_data <= _ex1_fw_data_T_2;
      end else begin
        ex2_reg_fw_data <= _ex1_fw_data_T_4;
      end
    end else if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
      ex2_reg_fw_data <= _ex2_alu_out_T_2;
    end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
      ex2_reg_fw_data <= _ex2_alu_out_T_5;
    end else begin
      ex2_reg_fw_data <= _ex2_alu_out_T_45;
    end
    if (reset) begin // @[Core.scala 831:38]
      mem_reg_rf_wen_delay <= 2'h0; // @[Core.scala 831:38]
    end else if (mem_en) begin // @[Core.scala 1080:23]
      mem_reg_rf_wen_delay <= mem_reg_rf_wen;
    end else begin
      mem_reg_rf_wen_delay <= 2'h0;
    end
    if (reset) begin // @[Core.scala 833:38]
      mem_reg_wb_data_delay <= 32'h0; // @[Core.scala 833:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_11;
      end else begin
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1199:39]
        mem_reg_wb_data_delay <= _mem_wb_data_T_3;
      end else begin
        mem_reg_wb_data_delay <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= csr_rdata;
    end else begin
      mem_reg_wb_data_delay <= mem_reg_alu_out;
    end
    if (reset) begin // @[Core.scala 834:38]
      wb_reg_rf_wen_delay <= 2'h0; // @[Core.scala 834:38]
    end else begin
      wb_reg_rf_wen_delay <= wb_reg_rf_wen; // @[Core.scala 1223:24]
    end
    if (reset) begin // @[Core.scala 835:38]
      wb_reg_wb_addr_delay <= 5'h0; // @[Core.scala 835:38]
    end else begin
      wb_reg_wb_addr_delay <= wb_reg_wb_addr; // @[Core.scala 1224:24]
    end
    if (reset) begin // @[Core.scala 836:38]
      wb_reg_wb_data_delay <= 32'h0; // @[Core.scala 836:38]
    end else begin
      wb_reg_wb_data_delay <= wb_reg_wb_data; // @[Core.scala 1225:24]
    end
    if (reset) begin // @[Core.scala 1243:24]
      do_exit <= 1'h0; // @[Core.scala 1243:24]
    end else begin
      do_exit <= mem_reg_is_trap & mem_reg_mcause == 32'hb & regfile_do_exit_MPORT_data == 32'h5d; // @[Core.scala 1245:11]
    end
    if (reset) begin // @[Core.scala 1244:30]
      do_exit_delay <= 1'h0; // @[Core.scala 1244:30]
    end else begin
      do_exit_delay <= do_exit; // @[Core.scala 1246:17]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",ic_reg_addr_out,ic_data_out); // @[Core.scala 397:9]
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
          $fwrite(32'h80000002,"inst: %x, ic_reg_read_rdy: %d, ic_state: %d\n",if2_inst,ic_reg_read_rdy,ic_state); // @[Core.scala 398:9]
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
          $fwrite(32'h80000002,"if2_pc           : 0x%x\n",if2_pc); // @[Core.scala 1249:9]
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
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 1250:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_hit  : 0x%x\n",bp_io_lu_br_hit); // @[Core.scala 1251:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_pos  : 0x%x\n",bp_io_lu_br_pos); // @[Core.scala 1252:9]
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
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",id_reg_pc); // @[Core.scala 1253:9]
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
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 1254:9]
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
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 1255:9]
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
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 1256:9]
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
          $fwrite(32'h80000002,"id_rs1_data      : 0x%x\n",id_rs1_data); // @[Core.scala 1257:9]
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
          $fwrite(32'h80000002,"id_rs2_data      : 0x%x\n",id_rs2_data); // @[Core.scala 1258:9]
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
          $fwrite(32'h80000002,"id_wb_addr       : 0x%x\n",id_wb_addr); // @[Core.scala 1259:9]
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
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",ex1_reg_pc); // @[Core.scala 1260:9]
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
          $fwrite(32'h80000002,"ex1_reg_is_valid_: 0x%x\n",ex1_reg_is_valid_inst); // @[Core.scala 1261:9]
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
          $fwrite(32'h80000002,"ex1_stall        : 0x%x\n",ex1_stall); // @[Core.scala 1262:9]
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
          $fwrite(32'h80000002,"ex1_op1_data     : 0x%x\n",ex1_op1_data); // @[Core.scala 1263:9]
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
          $fwrite(32'h80000002,"ex1_op2_data     : 0x%x\n",ex1_op2_data); // @[Core.scala 1264:9]
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
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",ex2_reg_pc); // @[Core.scala 1267:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_valid_: 0x%x\n",ex2_reg_is_valid_inst); // @[Core.scala 1268:9]
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
          $fwrite(32'h80000002,"ex2_reg_op1_data : 0x%x\n",ex2_reg_op1_data); // @[Core.scala 1269:9]
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
          $fwrite(32'h80000002,"ex2_reg_op2_data : 0x%x\n",ex2_reg_op2_data); // @[Core.scala 1270:9]
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
          $fwrite(32'h80000002,"ex2_alu_out      : 0x%x\n",ex2_alu_out); // @[Core.scala 1271:9]
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
          $fwrite(32'h80000002,"ex2_reg_exe_fun  : 0x%x\n",ex2_reg_exe_fun); // @[Core.scala 1272:9]
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
          $fwrite(32'h80000002,"ex2_reg_wb_sel   : 0x%x\n",ex2_reg_wb_sel); // @[Core.scala 1273:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_bp_pos : 0x%x\n",ex2_reg_is_bp_pos); // @[Core.scala 1274:9]
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
          $fwrite(32'h80000002,"ex2_reg_bp_addr  : 0x%x\n",ex2_reg_bp_addr); // @[Core.scala 1275:9]
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
          $fwrite(32'h80000002,"ex3_reg_pc       : 0x%x\n",ex3_reg_pc); // @[Core.scala 1276:9]
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
          $fwrite(32'h80000002,"ex3_reg_is_br    : 0x%x\n",ex3_reg_is_br); // @[Core.scala 1277:9]
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
          $fwrite(32'h80000002,"ex3_reg_br_target : 0x%x\n",ex3_reg_br_target); // @[Core.scala 1278:9]
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
          $fwrite(32'h80000002,"mem_reg_pc       : 0x%x\n",mem_reg_pc); // @[Core.scala 1279:9]
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
          $fwrite(32'h80000002,"mem_is_valid_inst: 0x%x\n",mem_is_valid_inst); // @[Core.scala 1280:9]
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
          $fwrite(32'h80000002,"mem_stall        : 0x%x\n",mem_stall); // @[Core.scala 1281:9]
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
          $fwrite(32'h80000002,"mem_wb_data      : 0x%x\n",mem_wb_data); // @[Core.scala 1282:9]
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
          $fwrite(32'h80000002,"mem_reg_mem_w    : 0x%x\n",mem_reg_mem_w); // @[Core.scala 1283:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_addr  : 0x%x\n",mem_reg_wb_addr); // @[Core.scala 1284:9]
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
          $fwrite(32'h80000002,"mem_is_meintr    : %d\n",mem_is_meintr); // @[Core.scala 1285:9]
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
          $fwrite(32'h80000002,"mem_is_mtintr    : %d\n",mem_is_mtintr); // @[Core.scala 1286:9]
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
          $fwrite(32'h80000002,"mem_reg_rf_wen_delay : 0x%x\n",mem_reg_rf_wen_delay); // @[Core.scala 1287:9]
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
          $fwrite(32'h80000002,"mem_wb_addr_delay : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1288:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_data_delay : 0x%x\n",mem_reg_wb_data_delay); // @[Core.scala 1289:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_addr   : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1290:9]
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
          $fwrite(32'h80000002,"wb_reg_is_valid_i: 0x%x\n",wb_reg_is_valid_inst); // @[Core.scala 1291:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_data   : 0x%x\n",wb_reg_wb_data); // @[Core.scala 1292:9]
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
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 1293:9]
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
          $fwrite(32'h80000002,"cycle_counter(%d) : %d\n",do_exit,io_debug_signal_cycle_counter); // @[Core.scala 1294:9]
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
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 1295:9]
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
  csr_mepc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  csr_mstatus = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  csr_mscratch = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  csr_mie = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  csr_mip = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  id_reg_pc = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  id_reg_inst = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  id_reg_stall = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  id_reg_is_bp_pos = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  id_reg_bp_addr = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  ex1_reg_pc = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  ex1_reg_wb_addr = _RAND_15[4:0];
  _RAND_16 = {1{`RANDOM}};
  ex1_reg_op1_sel = _RAND_16[2:0];
  _RAND_17 = {1{`RANDOM}};
  ex1_reg_op2_sel = _RAND_17[3:0];
  _RAND_18 = {1{`RANDOM}};
  ex1_reg_rs1_addr = _RAND_18[4:0];
  _RAND_19 = {1{`RANDOM}};
  ex1_reg_rs2_addr = _RAND_19[4:0];
  _RAND_20 = {1{`RANDOM}};
  ex1_reg_op1_data = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  ex1_reg_op2_data = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  ex1_reg_exe_fun = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  ex1_reg_mem_wen = _RAND_23[1:0];
  _RAND_24 = {1{`RANDOM}};
  ex1_reg_rf_wen = _RAND_24[1:0];
  _RAND_25 = {1{`RANDOM}};
  ex1_reg_wb_sel = _RAND_25[2:0];
  _RAND_26 = {1{`RANDOM}};
  ex1_reg_csr_addr = _RAND_26[11:0];
  _RAND_27 = {1{`RANDOM}};
  ex1_reg_csr_cmd = _RAND_27[2:0];
  _RAND_28 = {1{`RANDOM}};
  ex1_reg_imm_b_sext = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  ex1_reg_mem_w = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  ex1_reg_is_j = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  ex1_reg_is_bp_pos = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  ex1_reg_bp_addr = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  ex1_reg_is_half = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  ex1_reg_is_valid_inst = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  ex1_reg_is_trap = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  ex1_reg_mcause = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  ex2_reg_pc = _RAND_37[31:0];
  _RAND_38 = {1{`RANDOM}};
  ex2_reg_wb_addr = _RAND_38[4:0];
  _RAND_39 = {1{`RANDOM}};
  ex2_reg_op1_data = _RAND_39[31:0];
  _RAND_40 = {1{`RANDOM}};
  ex2_reg_op2_data = _RAND_40[31:0];
  _RAND_41 = {1{`RANDOM}};
  ex2_reg_rs2_data = _RAND_41[31:0];
  _RAND_42 = {1{`RANDOM}};
  ex2_reg_exe_fun = _RAND_42[4:0];
  _RAND_43 = {1{`RANDOM}};
  ex2_reg_mem_wen = _RAND_43[1:0];
  _RAND_44 = {1{`RANDOM}};
  ex2_reg_rf_wen = _RAND_44[1:0];
  _RAND_45 = {1{`RANDOM}};
  ex2_reg_wb_sel = _RAND_45[2:0];
  _RAND_46 = {1{`RANDOM}};
  ex2_reg_csr_addr = _RAND_46[11:0];
  _RAND_47 = {1{`RANDOM}};
  ex2_reg_csr_cmd = _RAND_47[2:0];
  _RAND_48 = {1{`RANDOM}};
  ex2_reg_imm_b_sext = _RAND_48[31:0];
  _RAND_49 = {1{`RANDOM}};
  ex2_reg_mem_w = _RAND_49[31:0];
  _RAND_50 = {1{`RANDOM}};
  ex2_reg_is_j = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  ex2_reg_is_bp_pos = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  ex2_reg_bp_addr = _RAND_52[31:0];
  _RAND_53 = {1{`RANDOM}};
  ex2_reg_is_half = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  ex2_reg_is_valid_inst = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  ex2_reg_is_trap = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  ex2_reg_mcause = _RAND_56[31:0];
  _RAND_57 = {1{`RANDOM}};
  ex3_reg_bp_en = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  ex3_reg_pc = _RAND_58[31:0];
  _RAND_59 = {1{`RANDOM}};
  ex3_reg_is_cond_br = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  ex3_reg_is_cond_br_inst = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  ex3_reg_is_uncond_br = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  ex3_reg_cond_br_target = _RAND_62[31:0];
  _RAND_63 = {1{`RANDOM}};
  ex3_reg_uncond_br_target = _RAND_63[31:0];
  _RAND_64 = {1{`RANDOM}};
  ex3_reg_is_bp_pos = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  ex3_reg_bp_addr = _RAND_65[31:0];
  _RAND_66 = {1{`RANDOM}};
  ex3_reg_is_half = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  mem_reg_en = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  mem_reg_pc = _RAND_68[31:0];
  _RAND_69 = {1{`RANDOM}};
  mem_reg_wb_addr = _RAND_69[4:0];
  _RAND_70 = {1{`RANDOM}};
  mem_reg_op1_data = _RAND_70[31:0];
  _RAND_71 = {1{`RANDOM}};
  mem_reg_rs2_data = _RAND_71[31:0];
  _RAND_72 = {1{`RANDOM}};
  mem_reg_mem_wen = _RAND_72[1:0];
  _RAND_73 = {1{`RANDOM}};
  mem_reg_rf_wen = _RAND_73[1:0];
  _RAND_74 = {1{`RANDOM}};
  mem_reg_wb_sel = _RAND_74[2:0];
  _RAND_75 = {1{`RANDOM}};
  mem_reg_csr_addr = _RAND_75[11:0];
  _RAND_76 = {1{`RANDOM}};
  mem_reg_csr_cmd = _RAND_76[2:0];
  _RAND_77 = {1{`RANDOM}};
  mem_reg_alu_out = _RAND_77[31:0];
  _RAND_78 = {1{`RANDOM}};
  mem_reg_mem_w = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  mem_reg_mem_wstrb = _RAND_79[3:0];
  _RAND_80 = {1{`RANDOM}};
  mem_reg_is_half = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  mem_reg_is_valid_inst = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  mem_reg_is_trap = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  mem_reg_mcause = _RAND_83[31:0];
  _RAND_84 = {1{`RANDOM}};
  wb_reg_wb_addr = _RAND_84[4:0];
  _RAND_85 = {1{`RANDOM}};
  wb_reg_rf_wen = _RAND_85[1:0];
  _RAND_86 = {1{`RANDOM}};
  wb_reg_wb_data = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  wb_reg_is_valid_inst = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  if2_reg_is_bp_pos = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  if2_reg_bp_addr = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  ex3_reg_is_br = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  ex3_reg_br_target = _RAND_91[31:0];
  _RAND_92 = {1{`RANDOM}};
  mem_reg_is_br = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  mem_reg_br_addr = _RAND_93[31:0];
  _RAND_94 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  ic_reg_imem_addr = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_97[31:0];
  _RAND_98 = {1{`RANDOM}};
  ic_reg_inst = _RAND_98[31:0];
  _RAND_99 = {1{`RANDOM}};
  ic_reg_inst_addr = _RAND_99[31:0];
  _RAND_100 = {1{`RANDOM}};
  ic_reg_inst2 = _RAND_100[31:0];
  _RAND_101 = {1{`RANDOM}};
  ic_reg_inst2_addr = _RAND_101[31:0];
  _RAND_102 = {1{`RANDOM}};
  ic_state = _RAND_102[2:0];
  _RAND_103 = {1{`RANDOM}};
  if1_reg_first = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  if1_reg_next_pc = _RAND_104[31:0];
  _RAND_105 = {1{`RANDOM}};
  if2_reg_pc = _RAND_105[31:0];
  _RAND_106 = {1{`RANDOM}};
  if2_reg_inst = _RAND_106[31:0];
  _RAND_107 = {1{`RANDOM}};
  ex1_reg_hazard = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  ex2_reg_hazard = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  mem_stall_delay = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_110[31:0];
  _RAND_111 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_111[4:0];
  _RAND_112 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_112[2:0];
  _RAND_113 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_113[3:0];
  _RAND_114 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_114[4:0];
  _RAND_115 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_115[4:0];
  _RAND_116 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_116[31:0];
  _RAND_117 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_117[31:0];
  _RAND_118 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_118[4:0];
  _RAND_119 = {1{`RANDOM}};
  id_reg_mem_wen_delay = _RAND_119[1:0];
  _RAND_120 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_120[1:0];
  _RAND_121 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_121[2:0];
  _RAND_122 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_122[11:0];
  _RAND_123 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_123[2:0];
  _RAND_124 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_124[31:0];
  _RAND_125 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_125[31:0];
  _RAND_126 = {1{`RANDOM}};
  id_reg_is_j_delay = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  id_reg_is_bp_pos_delay = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  id_reg_bp_addr_delay = _RAND_128[31:0];
  _RAND_129 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_132[31:0];
  _RAND_133 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_134[0:0];
  _RAND_135 = {1{`RANDOM}};
  ex2_reg_fw_data = _RAND_135[31:0];
  _RAND_136 = {1{`RANDOM}};
  mem_reg_rf_wen_delay = _RAND_136[1:0];
  _RAND_137 = {1{`RANDOM}};
  mem_reg_wb_data_delay = _RAND_137[31:0];
  _RAND_138 = {1{`RANDOM}};
  wb_reg_rf_wen_delay = _RAND_138[1:0];
  _RAND_139 = {1{`RANDOM}};
  wb_reg_wb_addr_delay = _RAND_139[4:0];
  _RAND_140 = {1{`RANDOM}};
  wb_reg_wb_data_delay = _RAND_140[31:0];
  _RAND_141 = {1{`RANDOM}};
  do_exit = _RAND_141[0:0];
  _RAND_142 = {1{`RANDOM}};
  do_exit_delay = _RAND_142[0:0];
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
  output         io_dmem_rready,
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
  reg [19:0] tag_array_0 [0:127]; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_6_en; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_6_addr; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_6_data; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_7_en; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_7_addr; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_7_data; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_10_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_10_addr; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_10_mask; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_10_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_12_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_12_addr; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_12_mask; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_12_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_14_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_14_addr; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_14_mask; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_14_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_0_MPORT_16_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_0_MPORT_16_addr; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_16_mask; // @[Memory.scala 476:22]
  wire  tag_array_0_MPORT_16_en; // @[Memory.scala 476:22]
  reg [19:0] tag_array_1 [0:127]; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_6_en; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_6_addr; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_6_data; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_7_en; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_7_addr; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_7_data; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_10_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_10_addr; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_10_mask; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_10_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_12_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_12_addr; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_12_mask; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_12_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_14_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_14_addr; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_14_mask; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_14_en; // @[Memory.scala 476:22]
  wire [19:0] tag_array_1_MPORT_16_data; // @[Memory.scala 476:22]
  wire [6:0] tag_array_1_MPORT_16_addr; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_16_mask; // @[Memory.scala 476:22]
  wire  tag_array_1_MPORT_16_en; // @[Memory.scala 476:22]
  reg  lru_array_way_hot [0:127]; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_reg_lru_MPORT_en; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_8_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_8_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_8_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_8_en; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_9_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_9_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_9_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_9_en; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_11_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_11_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_11_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_11_en; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_13_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_13_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_13_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_13_en; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_15_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_15_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_15_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_15_en; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_17_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_way_hot_MPORT_17_addr; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_17_mask; // @[Memory.scala 477:22]
  wire  lru_array_way_hot_MPORT_17_en; // @[Memory.scala 477:22]
  reg  lru_array_dirty1 [0:127]; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_reg_lru_MPORT_en; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_8_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_8_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_8_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_8_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_9_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_9_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_9_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_9_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_11_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_11_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_11_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_11_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_13_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_13_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_13_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_13_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_15_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_15_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_15_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_15_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_17_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty1_MPORT_17_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_17_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty1_MPORT_17_en; // @[Memory.scala 477:22]
  reg  lru_array_dirty2 [0:127]; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_reg_lru_MPORT_en; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_8_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_8_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_8_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_8_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_9_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_9_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_9_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_9_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_11_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_11_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_11_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_11_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_13_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_13_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_13_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_13_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_15_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_15_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_15_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_15_en; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_17_data; // @[Memory.scala 477:22]
  wire [6:0] lru_array_dirty2_MPORT_17_addr; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_17_mask; // @[Memory.scala 477:22]
  wire  lru_array_dirty2_MPORT_17_en; // @[Memory.scala 477:22]
  reg [2:0] reg_dram_state; // @[Memory.scala 171:31]
  reg [26:0] reg_dram_addr; // @[Memory.scala 172:31]
  reg [127:0] reg_dram_wdata; // @[Memory.scala 173:31]
  reg [127:0] reg_dram_rdata; // @[Memory.scala 174:31]
  reg  reg_dram_di; // @[Memory.scala 175:28]
  wire  _T_3 = ~io_dramPort_busy; // @[Memory.scala 191:48]
  reg [2:0] icache_state; // @[Memory.scala 271:29]
  wire  _T_25 = 3'h0 == icache_state; // @[Memory.scala 308:25]
  reg [2:0] dcache_state; // @[Memory.scala 479:29]
  wire  _T_77 = 3'h0 == dcache_state; // @[Memory.scala 524:25]
  reg [19:0] reg_tag_0; // @[Memory.scala 480:24]
  reg [19:0] reg_req_addr_tag; // @[Memory.scala 484:29]
  wire  _T_82 = reg_tag_0 == reg_req_addr_tag; // @[Memory.scala 564:24]
  reg [19:0] reg_tag_1; // @[Memory.scala 480:24]
  wire  _T_83 = reg_tag_1 == reg_req_addr_tag; // @[Memory.scala 567:30]
  wire [1:0] _GEN_532 = reg_tag_1 == reg_req_addr_tag ? 2'h1 : 2'h2; // @[Memory.scala 567:52 569:29 571:29]
  wire [1:0] _GEN_534 = reg_tag_0 == reg_req_addr_tag ? 2'h1 : _GEN_532; // @[Memory.scala 564:46 566:29]
  wire [1:0] _GEN_1076 = 3'h1 == dcache_state ? _GEN_534 : 2'h0; // @[Memory.scala 509:23 524:25]
  wire [1:0] dcache_snoop_status = 3'h0 == dcache_state ? 2'h0 : _GEN_1076; // @[Memory.scala 509:23 524:25]
  wire  _T_47 = 2'h0 == dcache_snoop_status; // @[Memory.scala 369:36]
  wire  _GEN_24 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? 1'h0 : 1'h1; // @[Memory.scala 184:20 191:67 192:21]
  wire  dram_i_busy = 3'h0 == reg_dram_state ? _GEN_24 : 1'h1; // @[Memory.scala 184:20 189:27]
  wire  _T_54 = ~dram_i_busy; // @[Memory.scala 395:17]
  reg [19:0] i_reg_req_addr_tag; // @[Memory.scala 274:31]
  reg [6:0] i_reg_req_addr_index; // @[Memory.scala 274:31]
  wire [22:0] _dram_i_addr_T_1 = {i_reg_req_addr_tag[15:0],i_reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_327 = 3'h4 == icache_state ? _dram_i_addr_T_1 : _dram_i_addr_T_1; // @[Memory.scala 308:25]
  wire [26:0] dram_i_addr = {{4'd0}, _GEN_327}; // @[Memory.scala 162:26]
  wire [30:0] _io_dramPort_addr_T = {dram_i_addr,4'h0}; // @[Cat.scala 31:58]
  reg  reg_lru_way_hot; // @[Memory.scala 483:24]
  reg  reg_lru_dirty1; // @[Memory.scala 483:24]
  wire  _T_91 = ~reg_lru_way_hot; // @[Memory.scala 588:83]
  reg  reg_lru_dirty2; // @[Memory.scala 483:24]
  wire  _GEN_155 = 2'h1 == dcache_snoop_status ? 1'h0 : 2'h2 == dcache_snoop_status & _T_54; // @[Memory.scala 293:14 369:36]
  wire  _GEN_174 = 2'h0 == dcache_snoop_status ? 1'h0 : _GEN_155; // @[Memory.scala 293:14 369:36]
  wire  _GEN_288 = 3'h5 == icache_state ? 1'h0 : 3'h3 == icache_state & _T_54; // @[Memory.scala 293:14 308:25]
  wire  _GEN_326 = 3'h4 == icache_state ? _GEN_174 : _GEN_288; // @[Memory.scala 308:25]
  wire  _GEN_386 = 3'h2 == icache_state ? 1'h0 : _GEN_326; // @[Memory.scala 293:14 308:25]
  wire  _GEN_434 = 3'h1 == icache_state ? 1'h0 : _GEN_386; // @[Memory.scala 293:14 308:25]
  wire  dram_i_ren = 3'h0 == icache_state ? 1'h0 : _GEN_434; // @[Memory.scala 293:14 308:25]
  wire  _GEN_30 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? dram_i_ren : 1'h1; // @[Memory.scala 185:20 191:67]
  wire  dram_d_busy = 3'h0 == reg_dram_state ? _GEN_30 : 1'h1; // @[Memory.scala 185:20 189:27]
  wire  _T_94 = ~dram_d_busy; // @[Memory.scala 589:15]
  reg [6:0] reg_req_addr_index; // @[Memory.scala 484:29]
  wire [22:0] _dram_d_addr_T_1 = {reg_tag_0[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _dram_d_addr_T_3 = {reg_tag_1[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_537 = reg_lru_way_hot ? _dram_d_addr_T_1 : _dram_d_addr_T_3; // @[Memory.scala 591:42 592:25 595:25]
  wire [22:0] _dram_d_addr_T_5 = {reg_req_addr_tag[15:0],reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [22:0] _GEN_547 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_537 :
    _dram_d_addr_T_5; // @[Memory.scala 588:111]
  wire [22:0] _GEN_893 = 3'h3 == dcache_state ? _GEN_547 : _dram_d_addr_T_5; // @[Memory.scala 524:25]
  wire [22:0] _GEN_1010 = 3'h2 == dcache_state ? _GEN_547 : _GEN_893; // @[Memory.scala 524:25]
  wire [26:0] dram_d_addr = {{4'd0}, _GEN_1010}; // @[Memory.scala 167:26]
  wire [30:0] _io_dramPort_addr_T_1 = {dram_d_addr,4'h0}; // @[Cat.scala 31:58]
  reg  reg_dcache_read; // @[Memory.scala 488:32]
  reg [255:0] reg_line1; // @[Memory.scala 481:26]
  wire [255:0] line1 = reg_dcache_read ? io_cache_array1_rdata : reg_line1; // @[Memory.scala 580:22]
  reg [255:0] reg_line2; // @[Memory.scala 482:26]
  wire [255:0] line2 = reg_dcache_read ? io_cache_array2_rdata : reg_line2; // @[Memory.scala 581:22]
  wire [255:0] _GEN_538 = reg_lru_way_hot ? line1 : line2; // @[Memory.scala 591:42 593:26 596:26]
  wire [255:0] dram_d_wdata = 3'h2 == dcache_state ? _GEN_538 : _GEN_538; // @[Memory.scala 524:25]
  wire  _GEN_550 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? 1'h0 : _T_94; // @[Memory.scala 588:111 495:14]
  wire  _GEN_556 = _T_83 ? 1'h0 : _GEN_550; // @[Memory.scala 495:14 585:52]
  wire  _GEN_562 = _T_82 ? 1'h0 : _GEN_556; // @[Memory.scala 495:14 582:46]
  wire  _GEN_816 = 3'h5 == dcache_state & _T_94; // @[Memory.scala 495:14 524:25]
  wire  _GEN_895 = 3'h3 == dcache_state ? _GEN_562 : _GEN_816; // @[Memory.scala 524:25]
  wire  _GEN_968 = 3'h4 == dcache_state ? 1'h0 : _GEN_895; // @[Memory.scala 495:14 524:25]
  wire  _GEN_1012 = 3'h2 == dcache_state ? _GEN_562 : _GEN_968; // @[Memory.scala 524:25]
  wire  _GEN_1084 = 3'h1 == dcache_state ? 1'h0 : _GEN_1012; // @[Memory.scala 495:14 524:25]
  wire  dram_d_ren = 3'h0 == dcache_state ? 1'h0 : _GEN_1084; // @[Memory.scala 495:14 524:25]
  wire [26:0] _GEN_2 = dram_d_ren ? dram_d_addr : reg_dram_addr; // @[Memory.scala 210:35 213:27 172:31]
  wire  _GEN_3 = dram_d_ren ? 1'h0 : reg_dram_di; // @[Memory.scala 210:35 214:25 175:28]
  wire [2:0] _GEN_4 = dram_d_ren ? 3'h2 : reg_dram_state; // @[Memory.scala 210:35 215:28 171:31]
  wire  _GEN_546 = (reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2) & _T_94; // @[Memory.scala 588:111 496:14]
  wire  _GEN_553 = _T_83 ? 1'h0 : _GEN_546; // @[Memory.scala 496:14 585:52]
  wire  _GEN_559 = _T_82 ? 1'h0 : _GEN_553; // @[Memory.scala 496:14 582:46]
  wire  _GEN_965 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_559; // @[Memory.scala 496:14 524:25]
  wire  _GEN_1009 = 3'h2 == dcache_state ? _GEN_559 : _GEN_965; // @[Memory.scala 524:25]
  wire  _GEN_1081 = 3'h1 == dcache_state ? 1'h0 : _GEN_1009; // @[Memory.scala 496:14 524:25]
  wire  dram_d_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1081; // @[Memory.scala 496:14 524:25]
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
  wire [9:0] _io_icache_raddr_T_1 = {io_imem_addr[11:5],io_imem_addr[4:2]}; // @[Cat.scala 31:58]
  wire [26:0] _T_26 = {io_imem_addr[31:12],io_imem_addr[11:5]}; // @[Cat.scala 31:58]
  wire [1:0] _GEN_103 = i_reg_cur_tag_index == _T_26 ? 2'h2 : 2'h1; // @[Memory.scala 324:74 325:24 327:24]
  wire  _GEN_117 = io_icache_control_invalidate ? 1'h0 : io_imem_en; // @[Memory.scala 269:24 313:43]
  wire [1:0] _T_32 = io_icache_valid_rdata >> i_reg_req_addr_index[0]; // @[Memory.scala 333:36]
  wire  _T_36 = _T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag; // @[Memory.scala 333:105]
  wire [9:0] _io_icache_raddr_T_3 = {i_reg_req_addr_index,i_reg_req_addr_line_off[4:2]}; // @[Cat.scala 31:58]
  wire [26:0] _i_reg_cur_tag_index_T_1 = {i_reg_req_addr_tag,i_reg_req_addr_index}; // @[Cat.scala 31:58]
  wire [19:0] _GEN_127 = io_imem_en ? i_tag_array_0_MPORT_1_data : i_reg_tag_0; // @[Memory.scala 353:31 354:19 272:26]
  wire [1:0] _GEN_130 = io_imem_en ? _GEN_103 : 2'h0; // @[Memory.scala 353:31 365:22]
  wire [2:0] _GEN_131 = io_icache_control_invalidate ? 3'h7 : {{1'd0}, _GEN_130}; // @[Memory.scala 348:43 352:22]
  wire [19:0] _GEN_133 = io_icache_control_invalidate ? i_reg_tag_0 : _GEN_127; // @[Memory.scala 272:26 348:43]
  wire [31:0] _dcache_snoop_addr_T = {i_reg_req_addr_tag,i_reg_req_addr_index,i_reg_req_addr_line_off}; // @[Memory.scala 372:47]
  wire [4:0] dcache_snoop_addr_line_off = _dcache_snoop_addr_T[4:0]; // @[Memory.scala 372:62]
  wire [6:0] dcache_snoop_addr_index = _dcache_snoop_addr_T[11:5]; // @[Memory.scala 372:62]
  wire [19:0] dcache_snoop_addr_tag = _dcache_snoop_addr_T[31:12]; // @[Memory.scala 372:62]
  wire [7:0] _i_reg_snoop_inst_T_1 = {i_reg_next_addr_line_off[4:2],5'h0}; // @[Cat.scala 31:58]
  wire [255:0] dcache_snoop_line = reg_tag_0 == reg_req_addr_tag ? io_cache_array1_rdata : io_cache_array2_rdata; // @[Memory.scala 564:46 565:27]
  wire [255:0] _i_reg_snoop_inst_T_2 = dcache_snoop_line >> _i_reg_snoop_inst_T_1; // @[Memory.scala 376:37]
  wire  _i_reg_snoop_inst_valid_T_3 = i_reg_req_addr_index == i_reg_next_addr_index; // @[Memory.scala 379:34]
  wire  _i_reg_snoop_inst_valid_T_4 = i_reg_req_addr_tag[15:0] == i_reg_next_addr_tag[15:0] &
    _i_reg_snoop_inst_valid_T_3; // @[Memory.scala 378:100]
  wire [1:0] _icache_valid_wdata_T_1 = 2'h1 << i_reg_req_addr_index[0]; // @[Memory.scala 388:62]
  wire [1:0] icache_valid_wdata = i_reg_valid_rdata | _icache_valid_wdata_T_1; // @[Memory.scala 388:55]
  wire [2:0] _GEN_138 = ~dram_i_busy ? 3'h6 : 3'h3; // @[Memory.scala 395:31 398:26 400:26]
  wire [2:0] _GEN_141 = 2'h2 == dcache_snoop_status ? _GEN_138 : icache_state; // @[Memory.scala 271:29 369:36]
  wire [31:0] _GEN_142 = 2'h1 == dcache_snoop_status ? _i_reg_snoop_inst_T_2[31:0] : i_reg_snoop_inst; // @[Memory.scala 369:36 376:28 276:33]
  wire  _GEN_143 = 2'h1 == dcache_snoop_status ? _i_reg_snoop_inst_valid_T_4 : i_reg_snoop_inst_valid; // @[Memory.scala 369:36 377:34 277:39]
  wire [26:0] _GEN_152 = 2'h1 == dcache_snoop_status ? _i_reg_cur_tag_index_T_1 : i_reg_cur_tag_index; // @[Memory.scala 369:36 390:31 280:36]
  wire [1:0] _GEN_153 = 2'h1 == dcache_snoop_status ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 369:36 391:29 279:34]
  wire [2:0] _GEN_154 = 2'h1 == dcache_snoop_status ? 3'h5 : _GEN_141; // @[Memory.scala 369:36 392:24]
  wire [31:0] _GEN_161 = 2'h0 == dcache_snoop_status ? i_reg_snoop_inst : _GEN_142; // @[Memory.scala 276:33 369:36]
  wire  _GEN_162 = 2'h0 == dcache_snoop_status ? i_reg_snoop_inst_valid : _GEN_143; // @[Memory.scala 369:36 277:39]
  wire  _GEN_165 = 2'h0 == dcache_snoop_status ? 1'h0 : 2'h1 == dcache_snoop_status; // @[Memory.scala 269:24 369:36]
  wire [26:0] _GEN_171 = 2'h0 == dcache_snoop_status ? i_reg_cur_tag_index : _GEN_152; // @[Memory.scala 280:36 369:36]
  wire [1:0] _GEN_172 = 2'h0 == dcache_snoop_status ? i_reg_valid_rdata : _GEN_153; // @[Memory.scala 279:34 369:36]
  wire [2:0] _GEN_173 = 2'h0 == dcache_snoop_status ? icache_state : _GEN_154; // @[Memory.scala 271:29 369:36]
  wire [19:0] _GEN_178 = io_imem_en ? i_tag_array_0_MPORT_3_data : i_reg_tag_0; // @[Memory.scala 411:25 412:19 272:26]
  wire [2:0] _GEN_184 = _T_54 ? 3'h6 : icache_state; // @[Memory.scala 427:27 430:22 271:29]
  wire [255:0] _io_imem_inst_T_2 = dram_rdata >> _i_reg_snoop_inst_T_1; // @[Memory.scala 436:31]
  wire [31:0] _GEN_186 = dram_i_rdata_valid ? _io_imem_inst_T_2[31:0] : 32'hdeadbeef; // @[Memory.scala 287:16 434:33 436:22]
  wire  _GEN_187 = dram_i_rdata_valid & _i_reg_snoop_inst_valid_T_4; // @[Memory.scala 288:17 434:33]
  wire [26:0] _GEN_196 = dram_i_rdata_valid ? _i_reg_cur_tag_index_T_1 : i_reg_cur_tag_index; // @[Memory.scala 434:33 450:29 280:36]
  wire [1:0] _GEN_197 = dram_i_rdata_valid ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 434:33 451:27 279:34]
  wire [2:0] _GEN_198 = dram_i_rdata_valid ? 3'h0 : icache_state; // @[Memory.scala 434:33 452:22 271:29]
  wire [19:0] _GEN_200 = io_imem_en ? i_tag_array_0_MPORT_5_data : i_reg_tag_0; // @[Memory.scala 463:25 464:19 272:26]
  wire [1:0] _GEN_203 = io_imem_en ? 2'h2 : 2'h0; // @[Memory.scala 463:25 469:22 471:22]
  wire [26:0] _GEN_208 = 3'h7 == icache_state ? 27'h7ffffff : i_reg_cur_tag_index; // @[Memory.scala 308:25 460:27 280:36]
  wire [4:0] _GEN_209 = 3'h7 == icache_state ? io_imem_addr[4:0] : i_reg_req_addr_line_off; // @[Memory.scala 308:25 462:22 274:31]
  wire [6:0] _GEN_210 = 3'h7 == icache_state ? io_imem_addr[11:5] : i_reg_req_addr_index; // @[Memory.scala 308:25 462:22 274:31]
  wire [19:0] _GEN_211 = 3'h7 == icache_state ? io_imem_addr[31:12] : i_reg_req_addr_tag; // @[Memory.scala 308:25 462:22 274:31]
  wire  _GEN_214 = 3'h7 == icache_state & io_imem_en; // @[Memory.scala 269:24 308:25]
  wire [19:0] _GEN_215 = 3'h7 == icache_state ? _GEN_200 : i_reg_tag_0; // @[Memory.scala 308:25 272:26]
  wire [2:0] _GEN_218 = 3'h7 == icache_state ? {{1'd0}, _GEN_203} : icache_state; // @[Memory.scala 308:25 271:29]
  wire [31:0] _GEN_219 = 3'h6 == icache_state ? _GEN_186 : 32'hdeadbeef; // @[Memory.scala 287:16 308:25]
  wire  _GEN_227 = 3'h6 == icache_state ? dram_i_rdata_valid : _GEN_214; // @[Memory.scala 308:25]
  wire [3:0] _GEN_228 = 3'h6 == icache_state ? i_reg_req_addr_index[4:1] : io_imem_addr[9:6]; // @[Memory.scala 308:25]
  wire [26:0] _GEN_230 = 3'h6 == icache_state ? _GEN_196 : _GEN_208; // @[Memory.scala 308:25]
  wire [1:0] _GEN_231 = 3'h6 == icache_state ? _GEN_197 : i_reg_valid_rdata; // @[Memory.scala 308:25 279:34]
  wire [2:0] _GEN_232 = 3'h6 == icache_state ? _GEN_198 : _GEN_218; // @[Memory.scala 308:25]
  wire  _GEN_234 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state; // @[Memory.scala 308:25 302:30]
  wire [4:0] _GEN_237 = 3'h6 == icache_state ? i_reg_req_addr_line_off : _GEN_209; // @[Memory.scala 308:25 274:31]
  wire [6:0] _GEN_238 = 3'h6 == icache_state ? i_reg_req_addr_index : _GEN_210; // @[Memory.scala 308:25 274:31]
  wire [19:0] _GEN_239 = 3'h6 == icache_state ? i_reg_req_addr_tag : _GEN_211; // @[Memory.scala 308:25 274:31]
  wire  _GEN_242 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state & io_imem_en; // @[Memory.scala 269:24 308:25]
  wire [19:0] _GEN_243 = 3'h6 == icache_state ? i_reg_tag_0 : _GEN_215; // @[Memory.scala 308:25 272:26]
  wire [2:0] _GEN_247 = 3'h3 == icache_state ? _GEN_184 : _GEN_232; // @[Memory.scala 308:25]
  wire [31:0] _GEN_248 = 3'h3 == icache_state ? 32'hdeadbeef : _GEN_219; // @[Memory.scala 287:16 308:25]
  wire  _GEN_249 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & _GEN_187; // @[Memory.scala 288:17 308:25]
  wire  _GEN_252 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & dram_i_rdata_valid; // @[Memory.scala 269:24 308:25]
  wire  _GEN_256 = 3'h3 == icache_state ? 1'h0 : _GEN_227; // @[Memory.scala 300:23 308:25]
  wire [26:0] _GEN_259 = 3'h3 == icache_state ? i_reg_cur_tag_index : _GEN_230; // @[Memory.scala 308:25 280:36]
  wire [1:0] _GEN_260 = 3'h3 == icache_state ? i_reg_valid_rdata : _GEN_231; // @[Memory.scala 308:25 279:34]
  wire  _GEN_262 = 3'h3 == icache_state ? 1'h0 : _GEN_234; // @[Memory.scala 308:25 302:30]
  wire [4:0] _GEN_265 = 3'h3 == icache_state ? i_reg_req_addr_line_off : _GEN_237; // @[Memory.scala 308:25 274:31]
  wire [6:0] _GEN_266 = 3'h3 == icache_state ? i_reg_req_addr_index : _GEN_238; // @[Memory.scala 308:25 274:31]
  wire [19:0] _GEN_267 = 3'h3 == icache_state ? i_reg_req_addr_tag : _GEN_239; // @[Memory.scala 308:25 274:31]
  wire  _GEN_270 = 3'h3 == icache_state ? 1'h0 : _GEN_242; // @[Memory.scala 269:24 308:25]
  wire [19:0] _GEN_271 = 3'h3 == icache_state ? i_reg_tag_0 : _GEN_243; // @[Memory.scala 308:25 272:26]
  wire [31:0] _GEN_273 = 3'h5 == icache_state ? i_reg_snoop_inst : _GEN_248; // @[Memory.scala 308:25 406:20]
  wire  _GEN_274 = 3'h5 == icache_state ? i_reg_snoop_inst_valid : _GEN_249; // @[Memory.scala 308:25 407:21]
  wire  _GEN_275 = 3'h5 == icache_state ? 1'h0 : i_reg_snoop_inst_valid; // @[Memory.scala 308:25 408:30 277:39]
  wire [4:0] _GEN_276 = 3'h5 == icache_state ? io_imem_addr[4:0] : _GEN_265; // @[Memory.scala 308:25 410:22]
  wire [6:0] _GEN_277 = 3'h5 == icache_state ? io_imem_addr[11:5] : _GEN_266; // @[Memory.scala 308:25 410:22]
  wire [19:0] _GEN_278 = 3'h5 == icache_state ? io_imem_addr[31:12] : _GEN_267; // @[Memory.scala 308:25 410:22]
  wire [19:0] _GEN_282 = 3'h5 == icache_state ? _GEN_178 : _GEN_271; // @[Memory.scala 308:25]
  wire  _GEN_283 = 3'h5 == icache_state ? io_imem_en : _GEN_270; // @[Memory.scala 308:25]
  wire [9:0] _GEN_284 = 3'h5 == icache_state ? _io_icache_raddr_T_1 : _io_icache_raddr_T_1; // @[Memory.scala 308:25]
  wire  _GEN_285 = 3'h5 == icache_state ? io_imem_en : _GEN_256; // @[Memory.scala 308:25]
  wire [3:0] _GEN_286 = 3'h5 == icache_state ? io_imem_addr[9:6] : _GEN_228; // @[Memory.scala 308:25]
  wire [2:0] _GEN_287 = 3'h5 == icache_state ? {{1'd0}, _GEN_130} : _GEN_247; // @[Memory.scala 308:25]
  wire  _GEN_292 = 3'h5 == icache_state ? 1'h0 : _GEN_252; // @[Memory.scala 269:24 308:25]
  wire [26:0] _GEN_297 = 3'h5 == icache_state ? i_reg_cur_tag_index : _GEN_259; // @[Memory.scala 308:25 280:36]
  wire [1:0] _GEN_298 = 3'h5 == icache_state ? i_reg_valid_rdata : _GEN_260; // @[Memory.scala 308:25 279:34]
  wire  _GEN_300 = 3'h5 == icache_state ? 1'h0 : _GEN_262; // @[Memory.scala 308:25 302:30]
  wire  _GEN_305 = 3'h5 == icache_state ? 1'h0 : _GEN_270; // @[Memory.scala 269:24 308:25]
  wire [31:0] _GEN_310 = 3'h4 == icache_state ? _GEN_161 : i_reg_snoop_inst; // @[Memory.scala 308:25 276:33]
  wire  _GEN_311 = 3'h4 == icache_state ? _GEN_162 : _GEN_275; // @[Memory.scala 308:25]
  wire  _GEN_317 = 3'h4 == icache_state ? _GEN_165 : _GEN_292; // @[Memory.scala 308:25]
  wire  _GEN_320 = 3'h4 == icache_state ? _GEN_165 : _GEN_285; // @[Memory.scala 308:25]
  wire [3:0] _GEN_321 = 3'h4 == icache_state ? i_reg_req_addr_index[4:1] : _GEN_286; // @[Memory.scala 308:25]
  wire [26:0] _GEN_323 = 3'h4 == icache_state ? _GEN_171 : _GEN_297; // @[Memory.scala 308:25]
  wire [1:0] _GEN_324 = 3'h4 == icache_state ? _GEN_172 : _GEN_298; // @[Memory.scala 308:25]
  wire [2:0] _GEN_325 = 3'h4 == icache_state ? _GEN_173 : _GEN_287; // @[Memory.scala 308:25]
  wire [31:0] _GEN_328 = 3'h4 == icache_state ? 32'hdeadbeef : _GEN_273; // @[Memory.scala 287:16 308:25]
  wire  _GEN_329 = 3'h4 == icache_state ? 1'h0 : _GEN_274; // @[Memory.scala 288:17 308:25]
  wire [4:0] _GEN_330 = 3'h4 == icache_state ? i_reg_req_addr_line_off : _GEN_276; // @[Memory.scala 308:25 274:31]
  wire [6:0] _GEN_331 = 3'h4 == icache_state ? i_reg_req_addr_index : _GEN_277; // @[Memory.scala 308:25 274:31]
  wire [19:0] _GEN_332 = 3'h4 == icache_state ? i_reg_req_addr_tag : _GEN_278; // @[Memory.scala 308:25 274:31]
  wire  _GEN_335 = 3'h4 == icache_state ? 1'h0 : 3'h5 == icache_state & io_imem_en; // @[Memory.scala 269:24 308:25]
  wire [19:0] _GEN_336 = 3'h4 == icache_state ? i_reg_tag_0 : _GEN_282; // @[Memory.scala 308:25 272:26]
  wire  _GEN_337 = 3'h4 == icache_state ? 1'h0 : _GEN_283; // @[Memory.scala 295:17 308:25]
  wire  _GEN_341 = 3'h4 == icache_state ? 1'h0 : _GEN_292; // @[Memory.scala 269:24 308:25]
  wire  _GEN_345 = 3'h4 == icache_state ? 1'h0 : _GEN_300; // @[Memory.scala 308:25 302:30]
  wire  _GEN_350 = 3'h4 == icache_state ? 1'h0 : _GEN_305; // @[Memory.scala 269:24 308:25]
  wire [31:0] _GEN_351 = 3'h2 == icache_state ? io_icache_rdata : _GEN_328; // @[Memory.scala 308:25 343:20]
  wire  _GEN_352 = 3'h2 == icache_state | _GEN_329; // @[Memory.scala 308:25 344:21]
  wire  _GEN_353 = 3'h2 == icache_state ? 1'h0 : 1'h1; // @[Memory.scala 308:25 345:30]
  wire  _GEN_357 = 3'h2 == icache_state ? io_icache_control_invalidate : _GEN_345; // @[Memory.scala 308:25]
  wire  _GEN_365 = 3'h2 == icache_state ? _GEN_117 : _GEN_337; // @[Memory.scala 308:25]
  wire [9:0] _GEN_366 = 3'h2 == icache_state ? _io_icache_raddr_T_1 : _GEN_284; // @[Memory.scala 308:25]
  wire  _GEN_367 = 3'h2 == icache_state ? _GEN_117 : _GEN_320; // @[Memory.scala 308:25]
  wire [3:0] _GEN_368 = 3'h2 == icache_state ? io_imem_addr[9:6] : _GEN_321; // @[Memory.scala 308:25]
  wire  _GEN_369 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _T_47; // @[Memory.scala 291:19 308:25]
  wire  _GEN_377 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _GEN_165; // @[Memory.scala 269:24 308:25]
  wire  _GEN_380 = 3'h2 == icache_state ? 1'h0 : _GEN_317; // @[Memory.scala 296:17 308:25]
  wire  _GEN_390 = 3'h2 == icache_state ? 1'h0 : _GEN_335; // @[Memory.scala 269:24 308:25]
  wire  _GEN_393 = 3'h2 == icache_state ? 1'h0 : _GEN_341; // @[Memory.scala 269:24 308:25]
  wire  _GEN_398 = 3'h2 == icache_state ? 1'h0 : _GEN_350; // @[Memory.scala 269:24 308:25]
  wire  _GEN_400 = 3'h1 == icache_state ? _T_36 : _GEN_365; // @[Memory.scala 308:25]
  wire [9:0] _GEN_401 = 3'h1 == icache_state ? _io_icache_raddr_T_3 : _GEN_366; // @[Memory.scala 308:25]
  wire [31:0] _GEN_404 = 3'h1 == icache_state ? 32'hdeadbeef : _GEN_351; // @[Memory.scala 287:16 308:25]
  wire  _GEN_405 = 3'h1 == icache_state ? 1'h0 : _GEN_352; // @[Memory.scala 288:17 308:25]
  wire  _GEN_406 = 3'h1 == icache_state | _GEN_353; // @[Memory.scala 308:25 289:26]
  wire  _GEN_410 = 3'h1 == icache_state ? 1'h0 : _GEN_357; // @[Memory.scala 308:25 302:30]
  wire  _GEN_415 = 3'h1 == icache_state ? 1'h0 : 3'h2 == icache_state & _GEN_117; // @[Memory.scala 269:24 308:25]
  wire  _GEN_417 = 3'h1 == icache_state ? 1'h0 : _GEN_367; // @[Memory.scala 300:23 308:25]
  wire  _GEN_419 = 3'h1 == icache_state ? 1'h0 : _GEN_369; // @[Memory.scala 291:19 308:25]
  wire  _GEN_427 = 3'h1 == icache_state ? 1'h0 : _GEN_377; // @[Memory.scala 269:24 308:25]
  wire  _GEN_430 = 3'h1 == icache_state ? 1'h0 : _GEN_380; // @[Memory.scala 296:17 308:25]
  wire  _GEN_438 = 3'h1 == icache_state ? 1'h0 : _GEN_390; // @[Memory.scala 269:24 308:25]
  wire  _GEN_441 = 3'h1 == icache_state ? 1'h0 : _GEN_393; // @[Memory.scala 269:24 308:25]
  wire  _GEN_446 = 3'h1 == icache_state ? 1'h0 : _GEN_398; // @[Memory.scala 269:24 308:25]
  wire [3:0] _GEN_462 = 3'h0 == icache_state ? io_imem_addr[9:6] : _GEN_368; // @[Memory.scala 308:25]
  wire  dcache_snoop_en = 3'h0 == icache_state ? 1'h0 : _GEN_419; // @[Memory.scala 291:19 308:25]
  reg [4:0] reg_req_addr_line_off; // @[Memory.scala 484:29]
  reg [31:0] reg_wdata; // @[Memory.scala 485:26]
  reg [3:0] reg_wstrb; // @[Memory.scala 486:26]
  reg  reg_ren; // @[Memory.scala 487:24]
  reg [31:0] reg_read_word; // @[Memory.scala 489:30]
  wire [31:0] _req_addr_T_12 = io_dmem_ren ? io_dmem_raddr : io_dmem_waddr; // @[Memory.scala 540:27]
  wire [4:0] req_addr_4_line_off = _req_addr_T_12[4:0]; // @[Memory.scala 540:79]
  wire [6:0] req_addr_4_index = _req_addr_T_12[11:5]; // @[Memory.scala 540:79]
  wire [19:0] req_addr_4_tag = _req_addr_T_12[31:12]; // @[Memory.scala 540:79]
  wire  _T_78 = io_dmem_ren | io_dmem_wen; // @[Memory.scala 545:27]
  wire [1:0] _GEN_498 = io_dmem_ren ? 2'h2 : 2'h3; // @[Memory.scala 555:30 556:26 558:26]
  wire [6:0] _GEN_510 = dcache_snoop_en ? dcache_snoop_addr_index : req_addr_4_index; // @[Memory.scala 526:30 528:22 541:22]
  wire  _GEN_517 = dcache_snoop_en | _T_78; // @[Memory.scala 526:30 530:28]
  wire  _GEN_521 = dcache_snoop_en ? 1'h0 : 1'h1; // @[Memory.scala 491:18 526:30 538:24]
  wire  _GEN_524 = dcache_snoop_en ? reg_ren : io_dmem_ren; // @[Memory.scala 487:24 526:30 544:17]
  wire  _GEN_527 = dcache_snoop_en ? 1'h0 : _T_78; // @[Memory.scala 476:22 526:30]
  wire [7:0] _reg_read_word_T_1 = {reg_req_addr_line_off[4:2],5'h0}; // @[Cat.scala 31:58]
  wire [255:0] _reg_read_word_T_2 = line1 >> _reg_read_word_T_1; // @[Memory.scala 583:33]
  wire [255:0] _reg_read_word_T_6 = line2 >> _reg_read_word_T_1; // @[Memory.scala 586:33]
  wire [2:0] _GEN_542 = ~dram_d_busy ? 3'h5 : dcache_state; // @[Memory.scala 589:29 598:24 479:29]
  wire [2:0] _GEN_545 = _T_94 ? 3'h6 : dcache_state; // @[Memory.scala 601:29 604:24 479:29]
  wire [2:0] _GEN_549 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_542 : _GEN_545; // @[Memory.scala 588:111]
  wire [31:0] _GEN_551 = _T_83 ? _reg_read_word_T_6[31:0] : reg_read_word; // @[Memory.scala 585:52 586:23 489:30]
  wire [2:0] _GEN_552 = _T_83 ? 3'h4 : _GEN_549; // @[Memory.scala 585:52 587:22]
  wire [31:0] _GEN_557 = _T_82 ? _reg_read_word_T_2[31:0] : _GEN_551; // @[Memory.scala 582:46 583:23]
  wire [2:0] _GEN_558 = _T_82 ? 3'h4 : _GEN_552; // @[Memory.scala 582:46 584:22]
  wire [4:0] _wstrb_T_1 = {reg_req_addr_line_off[4:2],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] _wstrb_T_3 = {28'h0,reg_wstrb}; // @[Memory.scala 518:37]
  wire [62:0] _GEN_0 = {{31'd0}, _wstrb_T_3}; // @[Memory.scala 521:30]
  wire [62:0] _wstrb_T_4 = _GEN_0 << _wstrb_T_1; // @[Memory.scala 521:30]
  wire [31:0] wstrb = _wstrb_T_4[31:0]; // @[Memory.scala 521:39]
  wire [255:0] _wdata_T_1 = {224'h0,reg_wdata}; // @[Memory.scala 515:42]
  wire [510:0] _GEN_1 = {{255'd0}, _wdata_T_1}; // @[Memory.scala 624:46]
  wire [510:0] _wdata_T_4 = _GEN_1 << _reg_read_word_T_1; // @[Memory.scala 624:46]
  wire [255:0] wdata = _wdata_T_4[255:0]; // @[Memory.scala 624:108]
  wire [2:0] _T_104 = {2'h1,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire [2:0] _T_109 = {1'h1,reg_lru_dirty1,1'h1}; // @[Cat.scala 31:58]
  wire [2:0] _GEN_586 = _T_83 ? 3'h0 : _GEN_549; // @[Memory.scala 631:52 639:22]
  wire [2:0] _GEN_600 = _T_82 ? 3'h0 : _GEN_586; // @[Memory.scala 622:46 630:22]
  wire  _GEN_601 = _T_82 ? 1'h0 : _T_83; // @[Memory.scala 503:25 622:46]
  wire [31:0] _T_129 = {reg_req_addr_tag,reg_req_addr_index,reg_req_addr_line_off}; // @[Memory.scala 672:72]
  wire  _T_131 = reg_ren & io_dmem_ren & io_dmem_raddr == _T_129; // @[Memory.scala 672:38]
  wire [255:0] _io_dmem_rdata_T_2 = dram_rdata >> _reg_read_word_T_1; // @[Memory.scala 674:34]
  wire  _T_133 = reg_lru_way_hot & reg_ren; // @[Memory.scala 676:39]
  wire [2:0] _T_134 = {2'h0,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire  _T_139 = _T_91 & reg_ren; // @[Memory.scala 683:45]
  wire [2:0] _T_140 = {1'h1,reg_lru_dirty1,1'h0}; // @[Cat.scala 31:58]
  wire [7:0] _io_cache_array1_wdata_T_3 = wstrb[0] ? _wdata_T_4[7:0] : dram_rdata[7:0]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_7 = wstrb[1] ? _wdata_T_4[15:8] : dram_rdata[15:8]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_11 = wstrb[2] ? _wdata_T_4[23:16] : dram_rdata[23:16]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_15 = wstrb[3] ? _wdata_T_4[31:24] : dram_rdata[31:24]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_19 = wstrb[4] ? _wdata_T_4[39:32] : dram_rdata[39:32]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_23 = wstrb[5] ? _wdata_T_4[47:40] : dram_rdata[47:40]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_27 = wstrb[6] ? _wdata_T_4[55:48] : dram_rdata[55:48]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_31 = wstrb[7] ? _wdata_T_4[63:56] : dram_rdata[63:56]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_35 = wstrb[8] ? _wdata_T_4[71:64] : dram_rdata[71:64]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_39 = wstrb[9] ? _wdata_T_4[79:72] : dram_rdata[79:72]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_43 = wstrb[10] ? _wdata_T_4[87:80] : dram_rdata[87:80]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_47 = wstrb[11] ? _wdata_T_4[95:88] : dram_rdata[95:88]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_51 = wstrb[12] ? _wdata_T_4[103:96] : dram_rdata[103:96]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_55 = wstrb[13] ? _wdata_T_4[111:104] : dram_rdata[111:104]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_59 = wstrb[14] ? _wdata_T_4[119:112] : dram_rdata[119:112]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_63 = wstrb[15] ? _wdata_T_4[127:120] : dram_rdata[127:120]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_67 = wstrb[16] ? _wdata_T_4[135:128] : dram_rdata[135:128]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_71 = wstrb[17] ? _wdata_T_4[143:136] : dram_rdata[143:136]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_75 = wstrb[18] ? _wdata_T_4[151:144] : dram_rdata[151:144]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_79 = wstrb[19] ? _wdata_T_4[159:152] : dram_rdata[159:152]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_83 = wstrb[20] ? _wdata_T_4[167:160] : dram_rdata[167:160]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_87 = wstrb[21] ? _wdata_T_4[175:168] : dram_rdata[175:168]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_91 = wstrb[22] ? _wdata_T_4[183:176] : dram_rdata[183:176]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_95 = wstrb[23] ? _wdata_T_4[191:184] : dram_rdata[191:184]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_99 = wstrb[24] ? _wdata_T_4[199:192] : dram_rdata[199:192]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_103 = wstrb[25] ? _wdata_T_4[207:200] : dram_rdata[207:200]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_107 = wstrb[26] ? _wdata_T_4[215:208] : dram_rdata[215:208]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_111 = wstrb[27] ? _wdata_T_4[223:216] : dram_rdata[223:216]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_115 = wstrb[28] ? _wdata_T_4[231:224] : dram_rdata[231:224]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_119 = wstrb[29] ? _wdata_T_4[239:232] : dram_rdata[239:232]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_123 = wstrb[30] ? _wdata_T_4[247:240] : dram_rdata[247:240]; // @[Memory.scala 699:18]
  wire [7:0] _io_cache_array1_wdata_T_127 = wstrb[31] ? _wdata_T_4[255:248] : dram_rdata[255:248]; // @[Memory.scala 699:18]
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
  wire  _GEN_632 = reg_lru_way_hot ? 1'h0 : 1'h1; // @[Memory.scala 476:22 693:42]
  wire  _GEN_647 = _T_91 & reg_ren | _GEN_632; // @[Memory.scala 683:57 685:30]
  wire [255:0] _GEN_650 = _T_91 & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 683:57 688:33]
  wire  _GEN_656 = _T_91 & reg_ren ? 1'h0 : reg_lru_way_hot; // @[Memory.scala 476:22 683:57]
  wire  _GEN_667 = _T_91 & reg_ren ? 1'h0 : _GEN_632; // @[Memory.scala 476:22 683:57]
  wire  _GEN_680 = reg_lru_way_hot & reg_ren | _GEN_656; // @[Memory.scala 676:51 678:30]
  wire [255:0] _GEN_683 = reg_lru_way_hot & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 676:51 681:33]
  wire  _GEN_689 = reg_lru_way_hot & reg_ren ? 1'h0 : _T_139; // @[Memory.scala 476:22 676:51]
  wire  _GEN_693 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_647; // @[Memory.scala 503:25 676:51]
  wire  _GEN_702 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_656; // @[Memory.scala 476:22 676:51]
  wire  _GEN_711 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_667; // @[Memory.scala 476:22 676:51]
  wire  _GEN_718 = dram_d_rdata_valid & reg_ren; // @[Memory.scala 491:18 668:33 670:24]
  wire  _GEN_720 = dram_d_rdata_valid & _T_131; // @[Memory.scala 493:18 668:33]
  wire  _GEN_724 = dram_d_rdata_valid & _T_133; // @[Memory.scala 476:22 668:33]
  wire  _GEN_728 = dram_d_rdata_valid & _GEN_680; // @[Memory.scala 499:25 668:33]
  wire  _GEN_737 = dram_d_rdata_valid & _GEN_689; // @[Memory.scala 476:22 668:33]
  wire  _GEN_741 = dram_d_rdata_valid & _GEN_693; // @[Memory.scala 503:25 668:33]
  wire  _GEN_750 = dram_d_rdata_valid & _GEN_702; // @[Memory.scala 476:22 668:33]
  wire  _GEN_759 = dram_d_rdata_valid & _GEN_711; // @[Memory.scala 476:22 668:33]
  wire [2:0] _GEN_766 = dram_d_rdata_valid ? 3'h0 : dcache_state; // @[Memory.scala 668:33 713:22 479:29]
  wire [2:0] _GEN_815 = 3'h6 == dcache_state ? _GEN_766 : dcache_state; // @[Memory.scala 524:25 479:29]
  wire [2:0] _GEN_818 = 3'h5 == dcache_state ? _GEN_545 : _GEN_815; // @[Memory.scala 524:25]
  wire  _GEN_819 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_718; // @[Memory.scala 491:18 524:25]
  wire  _GEN_821 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_720; // @[Memory.scala 493:18 524:25]
  wire  _GEN_825 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_724; // @[Memory.scala 476:22 524:25]
  wire  _GEN_829 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_728; // @[Memory.scala 499:25 524:25]
  wire  _GEN_838 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_737; // @[Memory.scala 476:22 524:25]
  wire  _GEN_842 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_741; // @[Memory.scala 503:25 524:25]
  wire  _GEN_851 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_750; // @[Memory.scala 476:22 524:25]
  wire  _GEN_860 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_759; // @[Memory.scala 476:22 524:25]
  wire [255:0] _GEN_867 = 3'h3 == dcache_state ? line1 : reg_line1; // @[Memory.scala 524:25 481:26]
  wire [255:0] _GEN_868 = 3'h3 == dcache_state ? line2 : reg_line2; // @[Memory.scala 524:25 482:26]
  wire  _GEN_869 = 3'h3 == dcache_state ? _T_82 : _GEN_829; // @[Memory.scala 524:25]
  wire [31:0] _GEN_870 = 3'h3 == dcache_state ? wstrb : 32'hffffffff; // @[Memory.scala 524:25]
  wire [2:0] _GEN_880 = 3'h3 == dcache_state ? _GEN_600 : _GEN_818; // @[Memory.scala 524:25]
  wire  _GEN_881 = 3'h3 == dcache_state ? _GEN_601 : _GEN_842; // @[Memory.scala 524:25]
  wire [510:0] _GEN_884 = 3'h3 == dcache_state ? _wdata_T_4 : {{255'd0}, _GEN_650}; // @[Memory.scala 524:25]
  wire  _GEN_896 = 3'h3 == dcache_state ? 1'h0 : _GEN_819; // @[Memory.scala 491:18 524:25]
  wire  _GEN_898 = 3'h3 == dcache_state ? 1'h0 : _GEN_821; // @[Memory.scala 493:18 524:25]
  wire  _GEN_902 = 3'h3 == dcache_state ? 1'h0 : _GEN_825; // @[Memory.scala 476:22 524:25]
  wire  _GEN_911 = 3'h3 == dcache_state ? 1'h0 : _GEN_838; // @[Memory.scala 476:22 524:25]
  wire  _GEN_920 = 3'h3 == dcache_state ? 1'h0 : _GEN_851; // @[Memory.scala 476:22 524:25]
  wire  _GEN_929 = 3'h3 == dcache_state ? 1'h0 : _GEN_860; // @[Memory.scala 476:22 524:25]
  wire  _GEN_936 = 3'h4 == dcache_state | _GEN_896; // @[Memory.scala 524:25 609:24]
  wire  _GEN_938 = 3'h4 == dcache_state | _GEN_898; // @[Memory.scala 524:25 611:24]
  wire [2:0] _GEN_940 = 3'h4 == dcache_state ? 3'h0 : _GEN_880; // @[Memory.scala 524:25 613:22]
  wire [255:0] _GEN_941 = 3'h4 == dcache_state ? reg_line1 : _GEN_867; // @[Memory.scala 524:25 481:26]
  wire [255:0] _GEN_942 = 3'h4 == dcache_state ? reg_line2 : _GEN_868; // @[Memory.scala 524:25 482:26]
  wire  _GEN_943 = 3'h4 == dcache_state ? 1'h0 : _GEN_869; // @[Memory.scala 499:25 524:25]
  wire  _GEN_949 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _T_82; // @[Memory.scala 477:22 524:25]
  wire  _GEN_954 = 3'h4 == dcache_state ? 1'h0 : _GEN_881; // @[Memory.scala 503:25 524:25]
  wire  _GEN_960 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_601; // @[Memory.scala 477:22 524:25]
  wire  _GEN_971 = 3'h4 == dcache_state ? 1'h0 : _GEN_902; // @[Memory.scala 476:22 524:25]
  wire  _GEN_980 = 3'h4 == dcache_state ? 1'h0 : _GEN_911; // @[Memory.scala 476:22 524:25]
  wire  _GEN_989 = 3'h4 == dcache_state ? 1'h0 : _GEN_920; // @[Memory.scala 476:22 524:25]
  wire  _GEN_998 = 3'h4 == dcache_state ? 1'h0 : _GEN_929; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1013 = 3'h2 == dcache_state ? 1'h0 : _GEN_936; // @[Memory.scala 491:18 524:25]
  wire  _GEN_1015 = 3'h2 == dcache_state ? 1'h0 : _GEN_938; // @[Memory.scala 493:18 524:25]
  wire  _GEN_1017 = 3'h2 == dcache_state ? 1'h0 : _GEN_943; // @[Memory.scala 499:25 524:25]
  wire  _GEN_1023 = 3'h2 == dcache_state ? 1'h0 : _GEN_949; // @[Memory.scala 477:22 524:25]
  wire  _GEN_1028 = 3'h2 == dcache_state ? 1'h0 : _GEN_954; // @[Memory.scala 503:25 524:25]
  wire  _GEN_1034 = 3'h2 == dcache_state ? 1'h0 : _GEN_960; // @[Memory.scala 477:22 524:25]
  wire  _GEN_1041 = 3'h2 == dcache_state ? 1'h0 : _GEN_971; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1050 = 3'h2 == dcache_state ? 1'h0 : _GEN_980; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1059 = 3'h2 == dcache_state ? 1'h0 : _GEN_989; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1068 = 3'h2 == dcache_state ? 1'h0 : _GEN_998; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1085 = 3'h1 == dcache_state ? 1'h0 : _GEN_1013; // @[Memory.scala 491:18 524:25]
  wire  _GEN_1087 = 3'h1 == dcache_state ? 1'h0 : _GEN_1015; // @[Memory.scala 493:18 524:25]
  wire  _GEN_1089 = 3'h1 == dcache_state ? 1'h0 : _GEN_1017; // @[Memory.scala 499:25 524:25]
  wire  _GEN_1095 = 3'h1 == dcache_state ? 1'h0 : _GEN_1023; // @[Memory.scala 477:22 524:25]
  wire  _GEN_1100 = 3'h1 == dcache_state ? 1'h0 : _GEN_1028; // @[Memory.scala 503:25 524:25]
  wire  _GEN_1106 = 3'h1 == dcache_state ? 1'h0 : _GEN_1034; // @[Memory.scala 477:22 524:25]
  wire  _GEN_1113 = 3'h1 == dcache_state ? 1'h0 : _GEN_1041; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1122 = 3'h1 == dcache_state ? 1'h0 : _GEN_1050; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1131 = 3'h1 == dcache_state ? 1'h0 : _GEN_1059; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1140 = 3'h1 == dcache_state ? 1'h0 : _GEN_1068; // @[Memory.scala 476:22 524:25]
  wire  _GEN_1166 = 3'h0 == dcache_state ? _GEN_524 : reg_ren; // @[Memory.scala 487:24 524:25]
  wire  _GEN_1169 = 3'h0 == dcache_state & _GEN_527; // @[Memory.scala 476:22 524:25]
  wire  _T_155 = ~reset; // @[Memory.scala 741:9]
  assign i_tag_array_0_MPORT_en = _T_25 & _GEN_117;
  assign i_tag_array_0_MPORT_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_data = i_tag_array_0[i_tag_array_0_MPORT_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_1_en = _T_25 ? 1'h0 : _GEN_415;
  assign i_tag_array_0_MPORT_1_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_1_data = i_tag_array_0[i_tag_array_0_MPORT_1_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_3_en = _T_25 ? 1'h0 : _GEN_438;
  assign i_tag_array_0_MPORT_3_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_3_data = i_tag_array_0[i_tag_array_0_MPORT_3_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_5_en = _T_25 ? 1'h0 : _GEN_446;
  assign i_tag_array_0_MPORT_5_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_5_data = i_tag_array_0[i_tag_array_0_MPORT_5_addr]; // @[Memory.scala 269:24]
  assign i_tag_array_0_MPORT_2_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_2_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_2_mask = 1'h1;
  assign i_tag_array_0_MPORT_2_en = _T_25 ? 1'h0 : _GEN_427;
  assign i_tag_array_0_MPORT_4_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_4_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_4_mask = 1'h1;
  assign i_tag_array_0_MPORT_4_en = _T_25 ? 1'h0 : _GEN_441;
  assign tag_array_0_MPORT_6_en = _T_77 & dcache_snoop_en;
  assign tag_array_0_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_6_data = tag_array_0[tag_array_0_MPORT_6_addr]; // @[Memory.scala 476:22]
  assign tag_array_0_MPORT_7_en = _T_77 & _GEN_527;
  assign tag_array_0_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_0_MPORT_7_data = tag_array_0[tag_array_0_MPORT_7_addr]; // @[Memory.scala 476:22]
  assign tag_array_0_MPORT_10_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_10_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_10_mask = 1'h1;
  assign tag_array_0_MPORT_10_en = _T_77 ? 1'h0 : _GEN_1113;
  assign tag_array_0_MPORT_12_data = reg_tag_0;
  assign tag_array_0_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_12_mask = 1'h1;
  assign tag_array_0_MPORT_12_en = _T_77 ? 1'h0 : _GEN_1122;
  assign tag_array_0_MPORT_14_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_14_mask = 1'h1;
  assign tag_array_0_MPORT_14_en = _T_77 ? 1'h0 : _GEN_1131;
  assign tag_array_0_MPORT_16_data = reg_tag_0;
  assign tag_array_0_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_16_mask = 1'h1;
  assign tag_array_0_MPORT_16_en = _T_77 ? 1'h0 : _GEN_1140;
  assign tag_array_1_MPORT_6_en = _T_77 & dcache_snoop_en;
  assign tag_array_1_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_6_data = tag_array_1[tag_array_1_MPORT_6_addr]; // @[Memory.scala 476:22]
  assign tag_array_1_MPORT_7_en = _T_77 & _GEN_527;
  assign tag_array_1_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_1_MPORT_7_data = tag_array_1[tag_array_1_MPORT_7_addr]; // @[Memory.scala 476:22]
  assign tag_array_1_MPORT_10_data = reg_tag_1;
  assign tag_array_1_MPORT_10_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_10_mask = 1'h1;
  assign tag_array_1_MPORT_10_en = _T_77 ? 1'h0 : _GEN_1113;
  assign tag_array_1_MPORT_12_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_12_mask = 1'h1;
  assign tag_array_1_MPORT_12_en = _T_77 ? 1'h0 : _GEN_1122;
  assign tag_array_1_MPORT_14_data = reg_tag_1;
  assign tag_array_1_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_14_mask = 1'h1;
  assign tag_array_1_MPORT_14_en = _T_77 ? 1'h0 : _GEN_1131;
  assign tag_array_1_MPORT_16_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_16_mask = 1'h1;
  assign tag_array_1_MPORT_16_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_way_hot_reg_lru_MPORT_en = _T_77 & _GEN_527;
  assign lru_array_way_hot_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_addr]; // @[Memory.scala 477:22]
  assign lru_array_way_hot_MPORT_8_data = _T_104[2];
  assign lru_array_way_hot_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_8_mask = 1'h1;
  assign lru_array_way_hot_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1095;
  assign lru_array_way_hot_MPORT_9_data = _T_109[2];
  assign lru_array_way_hot_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_9_mask = 1'h1;
  assign lru_array_way_hot_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1106;
  assign lru_array_way_hot_MPORT_11_data = _T_134[2];
  assign lru_array_way_hot_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_11_mask = 1'h1;
  assign lru_array_way_hot_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1113;
  assign lru_array_way_hot_MPORT_13_data = _T_140[2];
  assign lru_array_way_hot_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_13_mask = 1'h1;
  assign lru_array_way_hot_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_way_hot_MPORT_15_data = _T_104[2];
  assign lru_array_way_hot_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_15_mask = 1'h1;
  assign lru_array_way_hot_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_way_hot_MPORT_17_data = _T_109[2];
  assign lru_array_way_hot_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_17_mask = 1'h1;
  assign lru_array_way_hot_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_dirty1_reg_lru_MPORT_en = _T_77 & _GEN_527;
  assign lru_array_dirty1_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_addr]; // @[Memory.scala 477:22]
  assign lru_array_dirty1_MPORT_8_data = _T_104[1];
  assign lru_array_dirty1_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_8_mask = 1'h1;
  assign lru_array_dirty1_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1095;
  assign lru_array_dirty1_MPORT_9_data = _T_109[1];
  assign lru_array_dirty1_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_9_mask = 1'h1;
  assign lru_array_dirty1_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1106;
  assign lru_array_dirty1_MPORT_11_data = _T_134[1];
  assign lru_array_dirty1_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_11_mask = 1'h1;
  assign lru_array_dirty1_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1113;
  assign lru_array_dirty1_MPORT_13_data = _T_140[1];
  assign lru_array_dirty1_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_13_mask = 1'h1;
  assign lru_array_dirty1_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_dirty1_MPORT_15_data = _T_104[1];
  assign lru_array_dirty1_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_15_mask = 1'h1;
  assign lru_array_dirty1_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_dirty1_MPORT_17_data = _T_109[1];
  assign lru_array_dirty1_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_17_mask = 1'h1;
  assign lru_array_dirty1_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1140;
  assign lru_array_dirty2_reg_lru_MPORT_en = _T_77 & _GEN_527;
  assign lru_array_dirty2_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_addr]; // @[Memory.scala 477:22]
  assign lru_array_dirty2_MPORT_8_data = _T_104[0];
  assign lru_array_dirty2_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_8_mask = 1'h1;
  assign lru_array_dirty2_MPORT_8_en = _T_77 ? 1'h0 : _GEN_1095;
  assign lru_array_dirty2_MPORT_9_data = _T_109[0];
  assign lru_array_dirty2_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_9_mask = 1'h1;
  assign lru_array_dirty2_MPORT_9_en = _T_77 ? 1'h0 : _GEN_1106;
  assign lru_array_dirty2_MPORT_11_data = _T_134[0];
  assign lru_array_dirty2_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_11_mask = 1'h1;
  assign lru_array_dirty2_MPORT_11_en = _T_77 ? 1'h0 : _GEN_1113;
  assign lru_array_dirty2_MPORT_13_data = _T_140[0];
  assign lru_array_dirty2_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_13_mask = 1'h1;
  assign lru_array_dirty2_MPORT_13_en = _T_77 ? 1'h0 : _GEN_1122;
  assign lru_array_dirty2_MPORT_15_data = _T_104[0];
  assign lru_array_dirty2_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_15_mask = 1'h1;
  assign lru_array_dirty2_MPORT_15_en = _T_77 ? 1'h0 : _GEN_1131;
  assign lru_array_dirty2_MPORT_17_data = _T_109[0];
  assign lru_array_dirty2_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_17_mask = 1'h1;
  assign lru_array_dirty2_MPORT_17_en = _T_77 ? 1'h0 : _GEN_1140;
  assign io_imem_inst = 3'h0 == icache_state ? 32'hdeadbeef : _GEN_404; // @[Memory.scala 287:16 308:25]
  assign io_imem_valid = 3'h0 == icache_state ? 1'h0 : _GEN_405; // @[Memory.scala 288:17 308:25]
  assign io_icache_control_busy = 3'h0 == icache_state ? 1'h0 : _GEN_406; // @[Memory.scala 308:25 310:30]
  assign io_dmem_rdata = 3'h4 == dcache_state ? reg_read_word : _io_dmem_rdata_T_2[31:0]; // @[Memory.scala 524:25 612:23]
  assign io_dmem_rvalid = 3'h0 == dcache_state ? 1'h0 : _GEN_1087; // @[Memory.scala 493:18 524:25]
  assign io_dmem_rready = 3'h0 == dcache_state ? _GEN_521 : _GEN_1085; // @[Memory.scala 524:25]
  assign io_dmem_wready = 3'h0 == dcache_state & _GEN_521; // @[Memory.scala 524:25]
  assign io_dramPort_ren = 3'h0 == reg_dram_state ? _GEN_25 : _GEN_83; // @[Memory.scala 189:27]
  assign io_dramPort_wen = 3'h0 == reg_dram_state ? _GEN_31 : _GEN_78; // @[Memory.scala 189:27]
  assign io_dramPort_addr = _GEN_90[27:0];
  assign io_dramPort_wdata = 3'h0 == reg_dram_state ? dram_d_wdata[127:0] : reg_dram_wdata; // @[Memory.scala 189:27]
  assign io_cache_array1_en = 3'h0 == dcache_state ? _GEN_517 : _GEN_1089; // @[Memory.scala 524:25]
  assign io_cache_array1_we = 3'h0 == dcache_state ? 32'h0 : _GEN_870; // @[Memory.scala 524:25]
  assign io_cache_array1_addr = 3'h0 == dcache_state ? _GEN_510 : reg_req_addr_index; // @[Memory.scala 524:25]
  assign io_cache_array1_wdata = 3'h3 == dcache_state ? wdata : _GEN_683; // @[Memory.scala 524:25]
  assign io_cache_array2_en = 3'h0 == dcache_state ? _GEN_517 : _GEN_1100; // @[Memory.scala 524:25]
  assign io_cache_array2_we = 3'h0 == dcache_state ? 32'h0 : _GEN_870; // @[Memory.scala 524:25]
  assign io_cache_array2_addr = 3'h0 == dcache_state ? _GEN_510 : reg_req_addr_index; // @[Memory.scala 524:25]
  assign io_cache_array2_wdata = _GEN_884[255:0];
  assign io_icache_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_400; // @[Memory.scala 308:25]
  assign io_icache_wen = 3'h0 == icache_state ? 1'h0 : _GEN_430; // @[Memory.scala 296:17 308:25]
  assign io_icache_raddr = 3'h0 == icache_state ? _io_icache_raddr_T_1 : _GEN_401; // @[Memory.scala 308:25]
  assign io_icache_waddr = i_reg_req_addr_index; // @[Memory.scala 308:25]
  assign io_icache_wdata = 3'h4 == icache_state ? dcache_snoop_line : dram_rdata; // @[Memory.scala 308:25]
  assign io_icache_valid_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_417; // @[Memory.scala 308:25]
  assign io_icache_valid_wen = 3'h0 == icache_state ? 1'h0 : _GEN_430; // @[Memory.scala 296:17 308:25]
  assign io_icache_valid_invalidate = 3'h0 == icache_state ? io_icache_control_invalidate : _GEN_410; // @[Memory.scala 308:25]
  assign io_icache_valid_addr = {{2'd0}, _GEN_462};
  assign io_icache_valid_iaddr = 3'h0 == icache_state ? 1'h0 : _GEN_353; // @[Memory.scala 308:25]
  assign io_icache_valid_wdata = 3'h4 == icache_state ? icache_valid_wdata : icache_valid_wdata; // @[Memory.scala 308:25]
  always @(posedge clock) begin
    if (i_tag_array_0_MPORT_2_en & i_tag_array_0_MPORT_2_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_2_addr] <= i_tag_array_0_MPORT_2_data; // @[Memory.scala 269:24]
    end
    if (i_tag_array_0_MPORT_4_en & i_tag_array_0_MPORT_4_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_4_addr] <= i_tag_array_0_MPORT_4_data; // @[Memory.scala 269:24]
    end
    if (tag_array_0_MPORT_10_en & tag_array_0_MPORT_10_mask) begin
      tag_array_0[tag_array_0_MPORT_10_addr] <= tag_array_0_MPORT_10_data; // @[Memory.scala 476:22]
    end
    if (tag_array_0_MPORT_12_en & tag_array_0_MPORT_12_mask) begin
      tag_array_0[tag_array_0_MPORT_12_addr] <= tag_array_0_MPORT_12_data; // @[Memory.scala 476:22]
    end
    if (tag_array_0_MPORT_14_en & tag_array_0_MPORT_14_mask) begin
      tag_array_0[tag_array_0_MPORT_14_addr] <= tag_array_0_MPORT_14_data; // @[Memory.scala 476:22]
    end
    if (tag_array_0_MPORT_16_en & tag_array_0_MPORT_16_mask) begin
      tag_array_0[tag_array_0_MPORT_16_addr] <= tag_array_0_MPORT_16_data; // @[Memory.scala 476:22]
    end
    if (tag_array_1_MPORT_10_en & tag_array_1_MPORT_10_mask) begin
      tag_array_1[tag_array_1_MPORT_10_addr] <= tag_array_1_MPORT_10_data; // @[Memory.scala 476:22]
    end
    if (tag_array_1_MPORT_12_en & tag_array_1_MPORT_12_mask) begin
      tag_array_1[tag_array_1_MPORT_12_addr] <= tag_array_1_MPORT_12_data; // @[Memory.scala 476:22]
    end
    if (tag_array_1_MPORT_14_en & tag_array_1_MPORT_14_mask) begin
      tag_array_1[tag_array_1_MPORT_14_addr] <= tag_array_1_MPORT_14_data; // @[Memory.scala 476:22]
    end
    if (tag_array_1_MPORT_16_en & tag_array_1_MPORT_16_mask) begin
      tag_array_1[tag_array_1_MPORT_16_addr] <= tag_array_1_MPORT_16_data; // @[Memory.scala 476:22]
    end
    if (lru_array_way_hot_MPORT_8_en & lru_array_way_hot_MPORT_8_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_8_addr] <= lru_array_way_hot_MPORT_8_data; // @[Memory.scala 477:22]
    end
    if (lru_array_way_hot_MPORT_9_en & lru_array_way_hot_MPORT_9_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_9_addr] <= lru_array_way_hot_MPORT_9_data; // @[Memory.scala 477:22]
    end
    if (lru_array_way_hot_MPORT_11_en & lru_array_way_hot_MPORT_11_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_11_addr] <= lru_array_way_hot_MPORT_11_data; // @[Memory.scala 477:22]
    end
    if (lru_array_way_hot_MPORT_13_en & lru_array_way_hot_MPORT_13_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_13_addr] <= lru_array_way_hot_MPORT_13_data; // @[Memory.scala 477:22]
    end
    if (lru_array_way_hot_MPORT_15_en & lru_array_way_hot_MPORT_15_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_15_addr] <= lru_array_way_hot_MPORT_15_data; // @[Memory.scala 477:22]
    end
    if (lru_array_way_hot_MPORT_17_en & lru_array_way_hot_MPORT_17_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_17_addr] <= lru_array_way_hot_MPORT_17_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_8_en & lru_array_dirty1_MPORT_8_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_8_addr] <= lru_array_dirty1_MPORT_8_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_9_en & lru_array_dirty1_MPORT_9_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_9_addr] <= lru_array_dirty1_MPORT_9_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_11_en & lru_array_dirty1_MPORT_11_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_11_addr] <= lru_array_dirty1_MPORT_11_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_13_en & lru_array_dirty1_MPORT_13_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_13_addr] <= lru_array_dirty1_MPORT_13_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_15_en & lru_array_dirty1_MPORT_15_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_15_addr] <= lru_array_dirty1_MPORT_15_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty1_MPORT_17_en & lru_array_dirty1_MPORT_17_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_17_addr] <= lru_array_dirty1_MPORT_17_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_8_en & lru_array_dirty2_MPORT_8_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_8_addr] <= lru_array_dirty2_MPORT_8_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_9_en & lru_array_dirty2_MPORT_9_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_9_addr] <= lru_array_dirty2_MPORT_9_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_11_en & lru_array_dirty2_MPORT_11_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_11_addr] <= lru_array_dirty2_MPORT_11_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_13_en & lru_array_dirty2_MPORT_13_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_13_addr] <= lru_array_dirty2_MPORT_13_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_15_en & lru_array_dirty2_MPORT_15_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_15_addr] <= lru_array_dirty2_MPORT_15_data; // @[Memory.scala 477:22]
    end
    if (lru_array_dirty2_MPORT_17_en & lru_array_dirty2_MPORT_17_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_17_addr] <= lru_array_dirty2_MPORT_17_data; // @[Memory.scala 477:22]
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
    end else if (3'h0 == icache_state) begin // @[Memory.scala 308:25]
      if (io_icache_control_invalidate) begin // @[Memory.scala 313:43]
        icache_state <= 3'h7; // @[Memory.scala 317:22]
      end else if (io_imem_en) begin // @[Memory.scala 318:31]
        icache_state <= {{1'd0}, _GEN_103};
      end
    end else if (3'h1 == icache_state) begin // @[Memory.scala 308:25]
      if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 333:145]
        icache_state <= 3'h2; // @[Memory.scala 337:22]
      end else begin
        icache_state <= 3'h4; // @[Memory.scala 339:22]
      end
    end else if (3'h2 == icache_state) begin // @[Memory.scala 308:25]
      icache_state <= _GEN_131;
    end else begin
      icache_state <= _GEN_325;
    end
    if (reset) begin // @[Memory.scala 479:29]
      dcache_state <= 3'h0; // @[Memory.scala 479:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        dcache_state <= 3'h1; // @[Memory.scala 536:22]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
        dcache_state <= {{1'd0}, _GEN_498};
      end
    end else if (3'h1 == dcache_state) begin // @[Memory.scala 524:25]
      dcache_state <= 3'h0; // @[Memory.scala 573:20]
    end else if (3'h2 == dcache_state) begin // @[Memory.scala 524:25]
      dcache_state <= _GEN_558;
    end else begin
      dcache_state <= _GEN_940;
    end
    if (reset) begin // @[Memory.scala 480:24]
      reg_tag_0 <= 20'h0; // @[Memory.scala 480:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        reg_tag_0 <= tag_array_0_MPORT_6_data; // @[Memory.scala 529:17]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
        reg_tag_0 <= tag_array_0_MPORT_7_data; // @[Memory.scala 546:19]
      end
    end
    if (reset) begin // @[Memory.scala 484:29]
      reg_req_addr_tag <= 20'h0; // @[Memory.scala 484:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        reg_req_addr_tag <= dcache_snoop_addr_tag; // @[Memory.scala 528:22]
      end else begin
        reg_req_addr_tag <= req_addr_4_tag; // @[Memory.scala 541:22]
      end
    end
    if (reset) begin // @[Memory.scala 480:24]
      reg_tag_1 <= 20'h0; // @[Memory.scala 480:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        reg_tag_1 <= tag_array_1_MPORT_6_data; // @[Memory.scala 529:17]
      end else if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
        reg_tag_1 <= tag_array_1_MPORT_7_data; // @[Memory.scala 546:19]
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_tag <= 20'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 308:25]
      i_reg_req_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 312:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 308:25]
        i_reg_req_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 347:22]
      end else begin
        i_reg_req_addr_tag <= _GEN_332;
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_index <= 7'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 308:25]
      i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 312:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 308:25]
        i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 347:22]
      end else begin
        i_reg_req_addr_index <= _GEN_331;
      end
    end
    if (reset) begin // @[Memory.scala 483:24]
      reg_lru_way_hot <= 1'h0; // @[Memory.scala 483:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 526:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
          reg_lru_way_hot <= lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 554:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 483:24]
      reg_lru_dirty1 <= 1'h0; // @[Memory.scala 483:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 526:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
          reg_lru_dirty1 <= lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 554:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 483:24]
      reg_lru_dirty2 <= 1'h0; // @[Memory.scala 483:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 526:30]
        if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 545:43]
          reg_lru_dirty2 <= lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 554:19]
        end
      end
    end
    if (reset) begin // @[Memory.scala 484:29]
      reg_req_addr_index <= 7'h0; // @[Memory.scala 484:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        reg_req_addr_index <= dcache_snoop_addr_index; // @[Memory.scala 528:22]
      end else begin
        reg_req_addr_index <= req_addr_4_index; // @[Memory.scala 541:22]
      end
    end
    if (reset) begin // @[Memory.scala 488:32]
      reg_dcache_read <= 1'h0; // @[Memory.scala 488:32]
    end else begin
      reg_dcache_read <= _GEN_1169;
    end
    if (reset) begin // @[Memory.scala 481:26]
      reg_line1 <= 256'h0; // @[Memory.scala 481:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 524:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 524:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 524:25]
          reg_line1 <= line1;
        end else begin
          reg_line1 <= _GEN_941;
        end
      end
    end
    if (reset) begin // @[Memory.scala 482:26]
      reg_line2 <= 256'h0; // @[Memory.scala 482:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 524:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 524:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 524:25]
          reg_line2 <= line2;
        end else begin
          reg_line2 <= _GEN_942;
        end
      end
    end
    if (reset) begin // @[Memory.scala 272:26]
      i_reg_tag_0 <= 20'h0; // @[Memory.scala 272:26]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 308:25]
      if (!(io_icache_control_invalidate)) begin // @[Memory.scala 313:43]
        if (io_imem_en) begin // @[Memory.scala 318:31]
          i_reg_tag_0 <= i_tag_array_0_MPORT_data; // @[Memory.scala 319:19]
        end
      end
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 308:25]
        i_reg_tag_0 <= _GEN_133;
      end else begin
        i_reg_tag_0 <= _GEN_336;
      end
    end
    if (reset) begin // @[Memory.scala 274:31]
      i_reg_req_addr_line_off <= 5'h0; // @[Memory.scala 274:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 308:25]
      i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 312:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 308:25]
        i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 347:22]
      end else begin
        i_reg_req_addr_line_off <= _GEN_330;
      end
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_tag <= 20'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_tag <= io_imem_addr[31:12]; // @[Memory.scala 290:19]
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_index <= 7'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 290:19]
    end
    if (reset) begin // @[Memory.scala 275:32]
      i_reg_next_addr_line_off <= 5'h0; // @[Memory.scala 275:32]
    end else begin
      i_reg_next_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 290:19]
    end
    if (reset) begin // @[Memory.scala 276:33]
      i_reg_snoop_inst <= 32'h0; // @[Memory.scala 276:33]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 308:25]
      if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
        if (!(3'h2 == icache_state)) begin // @[Memory.scala 308:25]
          i_reg_snoop_inst <= _GEN_310;
        end
      end
    end
    if (reset) begin // @[Memory.scala 277:39]
      i_reg_snoop_inst_valid <= 1'h0; // @[Memory.scala 277:39]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 308:25]
      if (!(3'h1 == icache_state)) begin // @[Memory.scala 308:25]
        if (!(3'h2 == icache_state)) begin // @[Memory.scala 308:25]
          i_reg_snoop_inst_valid <= _GEN_311;
        end
      end
    end
    if (reset) begin // @[Memory.scala 279:34]
      i_reg_valid_rdata <= 2'h0; // @[Memory.scala 279:34]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 308:25]
        i_reg_valid_rdata <= io_icache_valid_rdata; // @[Memory.scala 332:25]
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 308:25]
        i_reg_valid_rdata <= _GEN_324;
      end
    end
    if (reset) begin // @[Memory.scala 280:36]
      i_reg_cur_tag_index <= 27'h7ffffff; // @[Memory.scala 280:36]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 308:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 308:25]
        if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 333:145]
          i_reg_cur_tag_index <= _i_reg_cur_tag_index_T_1; // @[Memory.scala 336:29]
        end
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 308:25]
        i_reg_cur_tag_index <= _GEN_323;
      end
    end
    if (reset) begin // @[Memory.scala 484:29]
      reg_req_addr_line_off <= 5'h0; // @[Memory.scala 484:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (dcache_snoop_en) begin // @[Memory.scala 526:30]
        reg_req_addr_line_off <= dcache_snoop_addr_line_off; // @[Memory.scala 528:22]
      end else begin
        reg_req_addr_line_off <= req_addr_4_line_off; // @[Memory.scala 541:22]
      end
    end
    if (reset) begin // @[Memory.scala 485:26]
      reg_wdata <= 32'h0; // @[Memory.scala 485:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 526:30]
        reg_wdata <= io_dmem_wdata; // @[Memory.scala 542:19]
      end
    end
    if (reset) begin // @[Memory.scala 486:26]
      reg_wstrb <= 4'h0; // @[Memory.scala 486:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 524:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 526:30]
        reg_wstrb <= io_dmem_wstrb; // @[Memory.scala 543:19]
      end
    end
    reg_ren <= reset | _GEN_1166; // @[Memory.scala 487:{24,24}]
    if (reset) begin // @[Memory.scala 489:30]
      reg_read_word <= 32'h0; // @[Memory.scala 489:30]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 524:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 524:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 524:25]
          reg_read_word <= _GEN_557;
        end
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"icache_state    : %d\n",icache_state); // @[Memory.scala 741:9]
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
          $fwrite(32'h80000002,"dcache_state    : %d\n",dcache_state); // @[Memory.scala 742:9]
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
          $fwrite(32'h80000002,"reg_dram_state  : %d\n",reg_dram_state); // @[Memory.scala 743:9]
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
  reg_req_addr_line_off = _RAND_34[4:0];
  _RAND_35 = {1{`RANDOM}};
  reg_wdata = _RAND_35[31:0];
  _RAND_36 = {1{`RANDOM}};
  reg_wstrb = _RAND_36[3:0];
  _RAND_37 = {1{`RANDOM}};
  reg_ren = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  reg_read_word = _RAND_38[31:0];
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
      output_ <= 32'hff; // @[Gpio.scala 14:23]
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
module Uart(
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
  output        io_tx
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[Uart.scala 101:18]
  wire  tx_reset; // @[Uart.scala 101:18]
  wire  tx_io_in_ready; // @[Uart.scala 101:18]
  wire  tx_io_in_valid; // @[Uart.scala 101:18]
  wire [7:0] tx_io_in_bits; // @[Uart.scala 101:18]
  wire  tx_io_tx; // @[Uart.scala 101:18]
  reg  tx_empty; // @[Uart.scala 102:25]
  reg [7:0] tx_data; // @[Uart.scala 104:24]
  reg  tx_intr_en; // @[Uart.scala 105:27]
  wire  _tx_io_in_valid_T = ~tx_empty; // @[Uart.scala 106:21]
  wire [31:0] _io_mem_rdata_T_1 = {29'h0,_tx_io_in_valid_T,1'h0,tx_intr_en}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_0 = io_mem_raddr == 32'h0 ? _io_mem_rdata_T_1 : 32'h0; // @[Uart.scala 110:33 111:20 113:20]
  wire  _GEN_3 = tx_empty ? 1'h0 : tx_empty; // @[Uart.scala 126:23 127:18 102:25]
  wire [31:0] _GEN_4 = tx_empty ? io_mem_wdata : {{24'd0}, tx_data}; // @[Uart.scala 126:23 128:17 104:24]
  wire  _GEN_5 = io_mem_waddr == 32'h4 ? _GEN_3 : tx_empty; // @[Uart.scala 102:25 125:39]
  wire [31:0] _GEN_6 = io_mem_waddr == 32'h4 ? _GEN_4 : {{24'd0}, tx_data}; // @[Uart.scala 104:24 125:39]
  wire  _GEN_8 = io_mem_waddr == 32'h0 ? tx_empty : _GEN_5; // @[Uart.scala 102:25 123:33]
  wire [31:0] _GEN_9 = io_mem_waddr == 32'h0 ? {{24'd0}, tx_data} : _GEN_6; // @[Uart.scala 104:24 123:33]
  wire  _GEN_11 = io_mem_wen ? _GEN_8 : tx_empty; // @[Uart.scala 122:21 102:25]
  wire [31:0] _GEN_12 = io_mem_wen ? _GEN_9 : {{24'd0}, tx_data}; // @[Uart.scala 122:21 104:24]
  wire  tx_ready = tx_io_in_ready;
  wire  _GEN_13 = _tx_io_in_valid_T & tx_ready | _GEN_11; // @[Uart.scala 134:31 135:14]
  wire [31:0] _GEN_14 = reset ? 32'h0 : _GEN_12; // @[Uart.scala 104:{24,24}]
  UartTx tx ( // @[Uart.scala 101:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_in_ready(tx_io_in_ready),
    .io_in_valid(tx_io_in_valid),
    .io_in_bits(tx_io_in_bits),
    .io_tx(tx_io_tx)
  );
  assign io_mem_rdata = io_mem_ren ? _GEN_0 : 32'h0; // @[Uart.scala 109:21 117:18]
  assign io_mem_rvalid = io_mem_ren; // @[Uart.scala 109:21 115:19 118:19]
  assign io_intr = tx_empty & tx_intr_en; // @[Uart.scala 138:23]
  assign io_tx = tx_io_tx; // @[Uart.scala 139:9]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = ~tx_empty; // @[Uart.scala 106:21]
  assign tx_io_in_bits = tx_data; // @[Uart.scala 107:17]
  always @(posedge clock) begin
    tx_empty <= reset | _GEN_13; // @[Uart.scala 102:{25,25}]
    tx_data <= _GEN_14[7:0]; // @[Uart.scala 104:{24,24}]
    if (reset) begin // @[Uart.scala 105:27]
      tx_intr_en <= 1'h0; // @[Uart.scala 105:27]
    end else if (io_mem_wen) begin // @[Uart.scala 122:21]
      if (io_mem_waddr == 32'h0) begin // @[Uart.scala 123:33]
        tx_intr_en <= io_mem_wdata[0]; // @[Uart.scala 124:18]
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
  tx_empty = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  tx_data = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  tx_intr_en = _RAND_2[0:0];
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
  output        io_initiator_rready,
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
  input         io_targets_1_rready,
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
  input         io_targets_3_rvalid,
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
  input  [31:0] io_targets_5_rdata
);
  wire  _GEN_2 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rvalid : 1'h1; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_3 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rdata : 32'hdeadbeef; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_12 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rvalid : _GEN_2; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_13 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rdata : _GEN_3; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_14 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rready : 21'h10000 == io_initiator_raddr[31:11]; // @[Decoder.scala 42:79 47:14]
  wire  _GEN_19 = 4'h2 == io_initiator_waddr[31:28] ? io_targets_1_wready : 21'h10000 == io_initiator_waddr[31:11]; // @[Decoder.scala 49:79 54:14]
  wire [31:0] _GEN_23 = 26'hc00000 == io_initiator_raddr[31:6] ? 32'hdeadbeef : _GEN_13; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_32 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_3_rvalid : 26'hc00000 == io_initiator_raddr[31:6]
     | _GEN_12; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_33 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_3_rdata : _GEN_23; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_42 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rvalid : _GEN_32; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_43 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rdata : _GEN_33; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rdata = 26'h1000000 == io_initiator_raddr[31:6] ? io_targets_5_rdata : _GEN_43; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rvalid = 26'h1000000 == io_initiator_raddr[31:6] | _GEN_42; // @[Decoder.scala 42:79 45:14]
  assign io_initiator_rready = 26'h1000000 == io_initiator_raddr[31:6] | (26'hc00080 == io_initiator_raddr[31:6] | (26'hc00040
     == io_initiator_raddr[31:6] | (26'hc00000 == io_initiator_raddr[31:6] | _GEN_14))); // @[Decoder.scala 42:79 47:14]
  assign io_initiator_wready = 26'h1000000 == io_initiator_waddr[31:6] | (26'hc00080 == io_initiator_waddr[31:6] | (26'hc00040
     == io_initiator_waddr[31:6] | (26'hc00000 == io_initiator_waddr[31:6] | _GEN_19))); // @[Decoder.scala 49:79 54:14]
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
  assign io_targets_5_raddr = 26'h1000000 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 42:79 43:13]
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
  output         io_exit,
  output [31:0]  io_debugSignals_core_mem_reg_pc,
  output         io_debugSignals_core_mem_is_valid_inst,
  output [31:0]  io_debugSignals_core_csr_rdata,
  output [11:0]  io_debugSignals_core_mem_reg_csr_addr,
  output         io_debugSignals_core_me_intr,
  output [63:0]  io_debugSignals_core_cycle_counter,
  output [63:0]  io_debugSignals_core_instret,
  output [31:0]  io_debugSignals_raddr,
  output [31:0]  io_debugSignals_rdata,
  output         io_debugSignals_ren,
  output         io_debugSignals_rvalid,
  output [31:0]  io_debugSignals_waddr,
  output         io_debugSignals_wen,
  output         io_debugSignals_wready,
  output [3:0]   io_debugSignals_wstrb,
  output [31:0]  io_debugSignals_wdata,
  output         io_debugSignals_dram_init_calib_complete,
  output         io_debugSignals_dram_rdata_valid,
  output         io_debugSignals_dram_busy,
  output         io_debugSignals_dram_ren,
  output         io_debugSignals_sram1_en,
  output [31:0]  io_debugSignals_sram1_we,
  output [6:0]   io_debugSignals_sram1_addr,
  output         io_debugSignals_sram2_en,
  output [31:0]  io_debugSignals_sram2_we,
  output [6:0]   io_debugSignals_sram2_addr
);
  wire  core_clock; // @[Top.scala 67:20]
  wire  core_reset; // @[Top.scala 67:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 67:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 67:20]
  wire  core_io_imem_valid; // @[Top.scala 67:20]
  wire  core_io_icache_control_invalidate; // @[Top.scala 67:20]
  wire  core_io_icache_control_busy; // @[Top.scala 67:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 67:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 67:20]
  wire  core_io_dmem_ren; // @[Top.scala 67:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 67:20]
  wire  core_io_dmem_rready; // @[Top.scala 67:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 67:20]
  wire  core_io_dmem_wen; // @[Top.scala 67:20]
  wire  core_io_dmem_wready; // @[Top.scala 67:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 67:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 67:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 67:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 67:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 67:20]
  wire  core_io_mtimer_mem_rvalid; // @[Top.scala 67:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 67:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 67:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 67:20]
  wire  core_io_intr; // @[Top.scala 67:20]
  wire  core_io_exit; // @[Top.scala 67:20]
  wire [31:0] core_io_debug_signal_mem_reg_pc; // @[Top.scala 67:20]
  wire  core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 67:20]
  wire [31:0] core_io_debug_signal_csr_rdata; // @[Top.scala 67:20]
  wire [11:0] core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 67:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 67:20]
  wire [63:0] core_io_debug_signal_cycle_counter; // @[Top.scala 67:20]
  wire [63:0] core_io_debug_signal_instret; // @[Top.scala 67:20]
  wire  memory_clock; // @[Top.scala 69:22]
  wire  memory_reset; // @[Top.scala 69:22]
  wire  memory_io_imem_en; // @[Top.scala 69:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 69:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 69:22]
  wire  memory_io_imem_valid; // @[Top.scala 69:22]
  wire  memory_io_icache_control_invalidate; // @[Top.scala 69:22]
  wire  memory_io_icache_control_busy; // @[Top.scala 69:22]
  wire [31:0] memory_io_dmem_raddr; // @[Top.scala 69:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 69:22]
  wire  memory_io_dmem_ren; // @[Top.scala 69:22]
  wire  memory_io_dmem_rvalid; // @[Top.scala 69:22]
  wire  memory_io_dmem_rready; // @[Top.scala 69:22]
  wire [31:0] memory_io_dmem_waddr; // @[Top.scala 69:22]
  wire  memory_io_dmem_wen; // @[Top.scala 69:22]
  wire  memory_io_dmem_wready; // @[Top.scala 69:22]
  wire [3:0] memory_io_dmem_wstrb; // @[Top.scala 69:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 69:22]
  wire  memory_io_dramPort_ren; // @[Top.scala 69:22]
  wire  memory_io_dramPort_wen; // @[Top.scala 69:22]
  wire [27:0] memory_io_dramPort_addr; // @[Top.scala 69:22]
  wire [127:0] memory_io_dramPort_wdata; // @[Top.scala 69:22]
  wire  memory_io_dramPort_init_calib_complete; // @[Top.scala 69:22]
  wire [127:0] memory_io_dramPort_rdata; // @[Top.scala 69:22]
  wire  memory_io_dramPort_rdata_valid; // @[Top.scala 69:22]
  wire  memory_io_dramPort_busy; // @[Top.scala 69:22]
  wire  memory_io_cache_array1_en; // @[Top.scala 69:22]
  wire [31:0] memory_io_cache_array1_we; // @[Top.scala 69:22]
  wire [6:0] memory_io_cache_array1_addr; // @[Top.scala 69:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[Top.scala 69:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[Top.scala 69:22]
  wire  memory_io_cache_array2_en; // @[Top.scala 69:22]
  wire [31:0] memory_io_cache_array2_we; // @[Top.scala 69:22]
  wire [6:0] memory_io_cache_array2_addr; // @[Top.scala 69:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[Top.scala 69:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[Top.scala 69:22]
  wire  memory_io_icache_ren; // @[Top.scala 69:22]
  wire  memory_io_icache_wen; // @[Top.scala 69:22]
  wire [9:0] memory_io_icache_raddr; // @[Top.scala 69:22]
  wire [31:0] memory_io_icache_rdata; // @[Top.scala 69:22]
  wire [6:0] memory_io_icache_waddr; // @[Top.scala 69:22]
  wire [255:0] memory_io_icache_wdata; // @[Top.scala 69:22]
  wire  memory_io_icache_valid_ren; // @[Top.scala 69:22]
  wire  memory_io_icache_valid_wen; // @[Top.scala 69:22]
  wire  memory_io_icache_valid_invalidate; // @[Top.scala 69:22]
  wire [5:0] memory_io_icache_valid_addr; // @[Top.scala 69:22]
  wire  memory_io_icache_valid_iaddr; // @[Top.scala 69:22]
  wire [1:0] memory_io_icache_valid_rdata; // @[Top.scala 69:22]
  wire [1:0] memory_io_icache_valid_wdata; // @[Top.scala 69:22]
  wire  boot_rom_clock; // @[Top.scala 70:24]
  wire  boot_rom_reset; // @[Top.scala 70:24]
  wire  boot_rom_io_imem_en; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_imem_addr; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_imem_inst; // @[Top.scala 70:24]
  wire  boot_rom_io_imem_valid; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_dmem_raddr; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_dmem_rdata; // @[Top.scala 70:24]
  wire  boot_rom_io_dmem_ren; // @[Top.scala 70:24]
  wire  boot_rom_io_dmem_rvalid; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_dmem_waddr; // @[Top.scala 70:24]
  wire  boot_rom_io_dmem_wen; // @[Top.scala 70:24]
  wire [31:0] boot_rom_io_dmem_wdata; // @[Top.scala 70:24]
  wire  sram1_clock; // @[Top.scala 71:21]
  wire  sram1_en; // @[Top.scala 71:21]
  wire [31:0] sram1_we; // @[Top.scala 71:21]
  wire [6:0] sram1_addr; // @[Top.scala 71:21]
  wire [255:0] sram1_wdata; // @[Top.scala 71:21]
  wire [255:0] sram1_rdata; // @[Top.scala 71:21]
  wire  sram2_clock; // @[Top.scala 72:21]
  wire  sram2_en; // @[Top.scala 72:21]
  wire [31:0] sram2_we; // @[Top.scala 72:21]
  wire [6:0] sram2_addr; // @[Top.scala 72:21]
  wire [255:0] sram2_wdata; // @[Top.scala 72:21]
  wire [255:0] sram2_rdata; // @[Top.scala 72:21]
  wire  icache_clock; // @[Top.scala 73:22]
  wire  icache_ren; // @[Top.scala 73:22]
  wire  icache_wen; // @[Top.scala 73:22]
  wire [9:0] icache_raddr; // @[Top.scala 73:22]
  wire [31:0] icache_rdata; // @[Top.scala 73:22]
  wire [6:0] icache_waddr; // @[Top.scala 73:22]
  wire [255:0] icache_wdata; // @[Top.scala 73:22]
  wire  icache_valid_clock; // @[Top.scala 74:28]
  wire  icache_valid_ren; // @[Top.scala 74:28]
  wire  icache_valid_wen; // @[Top.scala 74:28]
  wire  icache_valid_ien; // @[Top.scala 74:28]
  wire  icache_valid_invalidate; // @[Top.scala 74:28]
  wire [5:0] icache_valid_addr; // @[Top.scala 74:28]
  wire  icache_valid_iaddr; // @[Top.scala 74:28]
  wire [1:0] icache_valid_rdata; // @[Top.scala 74:28]
  wire [1:0] icache_valid_wdata; // @[Top.scala 74:28]
  wire [63:0] icache_valid_idata; // @[Top.scala 74:28]
  wire [1:0] icache_valid_dummy_data; // @[Top.scala 74:28]
  wire  gpio_clock; // @[Top.scala 75:20]
  wire  gpio_reset; // @[Top.scala 75:20]
  wire  gpio_io_mem_wen; // @[Top.scala 75:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 75:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 75:20]
  wire  uart_clock; // @[Top.scala 76:20]
  wire  uart_reset; // @[Top.scala 76:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 76:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 76:20]
  wire  uart_io_mem_ren; // @[Top.scala 76:20]
  wire  uart_io_mem_rvalid; // @[Top.scala 76:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 76:20]
  wire  uart_io_mem_wen; // @[Top.scala 76:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 76:20]
  wire  uart_io_intr; // @[Top.scala 76:20]
  wire  uart_io_tx; // @[Top.scala 76:20]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 77:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 77:22]
  wire [31:0] dmem_decoder_io_initiator_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_initiator_rdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_initiator_ren; // @[Top.scala 79:28]
  wire  dmem_decoder_io_initiator_rvalid; // @[Top.scala 79:28]
  wire  dmem_decoder_io_initiator_rready; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_initiator_waddr; // @[Top.scala 79:28]
  wire  dmem_decoder_io_initiator_wen; // @[Top.scala 79:28]
  wire  dmem_decoder_io_initiator_wready; // @[Top.scala 79:28]
  wire [3:0] dmem_decoder_io_initiator_wstrb; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_initiator_wdata; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_0_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_0_rdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_0_ren; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_0_rvalid; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_0_waddr; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_0_wen; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_0_wdata; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_1_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_1_rdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_1_ren; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_1_rvalid; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_1_rready; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_1_waddr; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_1_wen; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_1_wready; // @[Top.scala 79:28]
  wire [3:0] dmem_decoder_io_targets_1_wstrb; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_1_wdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_2_wen; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_2_wdata; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_3_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_3_rdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_3_ren; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_3_rvalid; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_3_waddr; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_3_wen; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_3_wdata; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_4_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_4_rdata; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_4_ren; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_4_rvalid; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_4_waddr; // @[Top.scala 79:28]
  wire  dmem_decoder_io_targets_4_wen; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_4_wdata; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_5_raddr; // @[Top.scala 79:28]
  wire [31:0] dmem_decoder_io_targets_5_rdata; // @[Top.scala 79:28]
  wire  imem_decoder_clock; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_initiator_addr; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_initiator_inst; // @[Top.scala 94:28]
  wire  imem_decoder_io_initiator_valid; // @[Top.scala 94:28]
  wire  imem_decoder_io_targets_0_en; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_targets_0_addr; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_targets_0_inst; // @[Top.scala 94:28]
  wire  imem_decoder_io_targets_0_valid; // @[Top.scala 94:28]
  wire  imem_decoder_io_targets_1_en; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_targets_1_addr; // @[Top.scala 94:28]
  wire [31:0] imem_decoder_io_targets_1_inst; // @[Top.scala 94:28]
  wire  imem_decoder_io_targets_1_valid; // @[Top.scala 94:28]
  Core core ( // @[Top.scala 67:20]
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
    .io_dmem_rready(core_io_dmem_rready),
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
    .io_debug_signal_csr_rdata(core_io_debug_signal_csr_rdata),
    .io_debug_signal_mem_reg_csr_addr(core_io_debug_signal_mem_reg_csr_addr),
    .io_debug_signal_me_intr(core_io_debug_signal_me_intr),
    .io_debug_signal_cycle_counter(core_io_debug_signal_cycle_counter),
    .io_debug_signal_instret(core_io_debug_signal_instret)
  );
  Memory memory ( // @[Top.scala 69:22]
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
    .io_dmem_rready(memory_io_dmem_rready),
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
  BootRom boot_rom ( // @[Top.scala 70:24]
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
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram1 ( // @[Top.scala 71:21]
    .clock(sram1_clock),
    .en(sram1_en),
    .we(sram1_we),
    .addr(sram1_addr),
    .wdata(sram1_wdata),
    .rdata(sram1_rdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram2 ( // @[Top.scala 72:21]
    .clock(sram2_clock),
    .en(sram2_en),
    .we(sram2_we),
    .addr(sram2_addr),
    .wdata(sram2_wdata),
    .rdata(sram2_rdata)
  );
  ICache #(.RDATA_WIDTH_BITS(5), .RADDR_WIDTH(10), .WDATA_WIDTH_BITS(8), .WADDR_WIDTH(7)) icache ( // @[Top.scala 73:22]
    .clock(icache_clock),
    .ren(icache_ren),
    .wen(icache_wen),
    .raddr(icache_raddr),
    .rdata(icache_rdata),
    .waddr(icache_waddr),
    .wdata(icache_wdata)
  );
  ICacheValid #(.DATA_WIDTH_BITS(1), .ADDR_WIDTH(6), .INVALIDATE_WIDTH_BITS(6), .INVALIDATE_ADDR_WIDTH(1)) icache_valid
     ( // @[Top.scala 74:28]
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
  Gpio gpio ( // @[Top.scala 75:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 76:20]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_mem_raddr(uart_io_mem_raddr),
    .io_mem_rdata(uart_io_mem_rdata),
    .io_mem_ren(uart_io_mem_ren),
    .io_mem_rvalid(uart_io_mem_rvalid),
    .io_mem_waddr(uart_io_mem_waddr),
    .io_mem_wen(uart_io_mem_wen),
    .io_mem_wdata(uart_io_mem_wdata),
    .io_intr(uart_io_intr),
    .io_tx(uart_io_tx)
  );
  Config config_ ( // @[Top.scala 77:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder dmem_decoder ( // @[Top.scala 79:28]
    .io_initiator_raddr(dmem_decoder_io_initiator_raddr),
    .io_initiator_rdata(dmem_decoder_io_initiator_rdata),
    .io_initiator_ren(dmem_decoder_io_initiator_ren),
    .io_initiator_rvalid(dmem_decoder_io_initiator_rvalid),
    .io_initiator_rready(dmem_decoder_io_initiator_rready),
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
    .io_targets_1_rready(dmem_decoder_io_targets_1_rready),
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
    .io_targets_3_rvalid(dmem_decoder_io_targets_3_rvalid),
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
    .io_targets_5_rdata(dmem_decoder_io_targets_5_rdata)
  );
  IMemDecoder imem_decoder ( // @[Top.scala 94:28]
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
  assign io_dram_ren = memory_io_dramPort_ren; // @[Top.scala 107:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[Top.scala 107:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[Top.scala 107:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[Top.scala 107:11]
  assign io_dram_wmask = 16'h0; // @[Top.scala 107:11]
  assign io_dram_user_busy = 1'h0; // @[Top.scala 107:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 166:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 167:14]
  assign io_exit = core_io_exit; // @[Top.scala 165:11]
  assign io_debugSignals_core_mem_reg_pc = core_io_debug_signal_mem_reg_pc; // @[Top.scala 142:24]
  assign io_debugSignals_core_mem_is_valid_inst = core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 142:24]
  assign io_debugSignals_core_csr_rdata = core_io_debug_signal_csr_rdata; // @[Top.scala 142:24]
  assign io_debugSignals_core_mem_reg_csr_addr = core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 142:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 142:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 142:24]
  assign io_debugSignals_core_instret = core_io_debug_signal_instret; // @[Top.scala 142:24]
  assign io_debugSignals_raddr = core_io_dmem_raddr; // @[Top.scala 143:26]
  assign io_debugSignals_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 144:26]
  assign io_debugSignals_ren = core_io_dmem_ren; // @[Top.scala 145:26]
  assign io_debugSignals_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 146:26]
  assign io_debugSignals_waddr = core_io_dmem_waddr; // @[Top.scala 147:26]
  assign io_debugSignals_wen = core_io_dmem_wen; // @[Top.scala 149:26]
  assign io_debugSignals_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 150:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 151:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 148:26]
  assign io_debugSignals_dram_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 153:44]
  assign io_debugSignals_dram_rdata_valid = io_dram_rdata_valid; // @[Top.scala 154:44]
  assign io_debugSignals_dram_busy = io_dram_busy; // @[Top.scala 155:44]
  assign io_debugSignals_dram_ren = io_dram_ren; // @[Top.scala 156:44]
  assign io_debugSignals_sram1_en = memory_io_cache_array1_en; // @[Top.scala 158:28]
  assign io_debugSignals_sram1_we = memory_io_cache_array1_we; // @[Top.scala 159:28]
  assign io_debugSignals_sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 160:30]
  assign io_debugSignals_sram2_en = memory_io_cache_array2_en; // @[Top.scala 161:28]
  assign io_debugSignals_sram2_we = memory_io_cache_array2_we; // @[Top.scala 162:28]
  assign io_debugSignals_sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 163:30]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = imem_decoder_io_initiator_inst; // @[Top.scala 101:16]
  assign core_io_imem_valid = imem_decoder_io_initiator_valid; // @[Top.scala 101:16]
  assign core_io_icache_control_busy = memory_io_icache_control_busy; // @[Top.scala 104:26]
  assign core_io_dmem_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 102:16]
  assign core_io_dmem_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 102:16]
  assign core_io_dmem_rready = dmem_decoder_io_initiator_rready; // @[Top.scala 102:16]
  assign core_io_dmem_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 102:16]
  assign core_io_mtimer_mem_raddr = dmem_decoder_io_targets_4_raddr; // @[Top.scala 91:30]
  assign core_io_mtimer_mem_ren = dmem_decoder_io_targets_4_ren; // @[Top.scala 91:30]
  assign core_io_mtimer_mem_waddr = dmem_decoder_io_targets_4_waddr; // @[Top.scala 91:30]
  assign core_io_mtimer_mem_wen = dmem_decoder_io_targets_4_wen; // @[Top.scala 91:30]
  assign core_io_mtimer_mem_wdata = dmem_decoder_io_targets_4_wdata; // @[Top.scala 91:30]
  assign core_io_intr = uart_io_intr; // @[Top.scala 168:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_en = imem_decoder_io_targets_1_en; // @[Top.scala 99:30]
  assign memory_io_imem_addr = imem_decoder_io_targets_1_addr; // @[Top.scala 99:30]
  assign memory_io_icache_control_invalidate = core_io_icache_control_invalidate; // @[Top.scala 104:26]
  assign memory_io_dmem_raddr = dmem_decoder_io_targets_1_raddr; // @[Top.scala 88:30]
  assign memory_io_dmem_ren = dmem_decoder_io_targets_1_ren; // @[Top.scala 88:30]
  assign memory_io_dmem_waddr = dmem_decoder_io_targets_1_waddr; // @[Top.scala 88:30]
  assign memory_io_dmem_wen = dmem_decoder_io_targets_1_wen; // @[Top.scala 88:30]
  assign memory_io_dmem_wstrb = dmem_decoder_io_targets_1_wstrb; // @[Top.scala 88:30]
  assign memory_io_dmem_wdata = dmem_decoder_io_targets_1_wdata; // @[Top.scala 88:30]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 107:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[Top.scala 107:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[Top.scala 107:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[Top.scala 107:11]
  assign memory_io_cache_array1_rdata = sram1_rdata; // @[Top.scala 114:32]
  assign memory_io_cache_array2_rdata = sram2_rdata; // @[Top.scala 120:32]
  assign memory_io_icache_rdata = icache_rdata; // @[Top.scala 126:26]
  assign memory_io_icache_valid_rdata = icache_valid_rdata; // @[Top.scala 136:32]
  assign boot_rom_clock = clock;
  assign boot_rom_reset = reset;
  assign boot_rom_io_imem_en = imem_decoder_io_targets_0_en; // @[Top.scala 98:30]
  assign boot_rom_io_imem_addr = imem_decoder_io_targets_0_addr; // @[Top.scala 98:30]
  assign boot_rom_io_dmem_raddr = dmem_decoder_io_targets_0_raddr; // @[Top.scala 87:30]
  assign boot_rom_io_dmem_ren = dmem_decoder_io_targets_0_ren; // @[Top.scala 87:30]
  assign boot_rom_io_dmem_waddr = dmem_decoder_io_targets_0_waddr; // @[Top.scala 87:30]
  assign boot_rom_io_dmem_wen = dmem_decoder_io_targets_0_wen; // @[Top.scala 87:30]
  assign boot_rom_io_dmem_wdata = dmem_decoder_io_targets_0_wdata; // @[Top.scala 87:30]
  assign sram1_clock = clock; // @[Top.scala 109:18]
  assign sram1_en = memory_io_cache_array1_en; // @[Top.scala 110:15]
  assign sram1_we = memory_io_cache_array1_we; // @[Top.scala 111:15]
  assign sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 112:17]
  assign sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 113:18]
  assign sram2_clock = clock; // @[Top.scala 115:18]
  assign sram2_en = memory_io_cache_array2_en; // @[Top.scala 116:15]
  assign sram2_we = memory_io_cache_array2_we; // @[Top.scala 117:15]
  assign sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 118:17]
  assign sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 119:18]
  assign icache_clock = clock; // @[Top.scala 122:19]
  assign icache_ren = memory_io_icache_ren; // @[Top.scala 123:17]
  assign icache_wen = memory_io_icache_wen; // @[Top.scala 124:17]
  assign icache_raddr = memory_io_icache_raddr; // @[Top.scala 125:19]
  assign icache_waddr = memory_io_icache_waddr; // @[Top.scala 127:19]
  assign icache_wdata = memory_io_icache_wdata; // @[Top.scala 128:19]
  assign icache_valid_clock = clock; // @[Top.scala 130:25]
  assign icache_valid_ren = memory_io_icache_valid_ren; // @[Top.scala 131:23]
  assign icache_valid_wen = memory_io_icache_valid_wen; // @[Top.scala 132:23]
  assign icache_valid_ien = memory_io_icache_valid_invalidate; // @[Top.scala 139:23]
  assign icache_valid_invalidate = memory_io_icache_valid_invalidate; // @[Top.scala 133:30]
  assign icache_valid_addr = memory_io_icache_valid_addr; // @[Top.scala 134:24]
  assign icache_valid_iaddr = memory_io_icache_valid_iaddr; // @[Top.scala 135:25]
  assign icache_valid_wdata = memory_io_icache_valid_wdata; // @[Top.scala 137:25]
  assign icache_valid_idata = 64'h0; // @[Top.scala 138:25]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = dmem_decoder_io_targets_2_wen; // @[Top.scala 89:30]
  assign gpio_io_mem_wdata = dmem_decoder_io_targets_2_wdata; // @[Top.scala 89:30]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = dmem_decoder_io_targets_3_raddr; // @[Top.scala 90:30]
  assign uart_io_mem_ren = dmem_decoder_io_targets_3_ren; // @[Top.scala 90:30]
  assign uart_io_mem_waddr = dmem_decoder_io_targets_3_waddr; // @[Top.scala 90:30]
  assign uart_io_mem_wen = dmem_decoder_io_targets_3_wen; // @[Top.scala 90:30]
  assign uart_io_mem_wdata = dmem_decoder_io_targets_3_wdata; // @[Top.scala 90:30]
  assign config__io_mem_raddr = dmem_decoder_io_targets_5_raddr; // @[Top.scala 92:30]
  assign dmem_decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 102:16]
  assign dmem_decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 102:16]
  assign dmem_decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 102:16]
  assign dmem_decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 102:16]
  assign dmem_decoder_io_initiator_wstrb = core_io_dmem_wstrb; // @[Top.scala 102:16]
  assign dmem_decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 102:16]
  assign dmem_decoder_io_targets_0_rdata = boot_rom_io_dmem_rdata; // @[Top.scala 87:30]
  assign dmem_decoder_io_targets_0_rvalid = boot_rom_io_dmem_rvalid; // @[Top.scala 87:30]
  assign dmem_decoder_io_targets_1_rdata = memory_io_dmem_rdata; // @[Top.scala 88:30]
  assign dmem_decoder_io_targets_1_rvalid = memory_io_dmem_rvalid; // @[Top.scala 88:30]
  assign dmem_decoder_io_targets_1_rready = memory_io_dmem_rready; // @[Top.scala 88:30]
  assign dmem_decoder_io_targets_1_wready = memory_io_dmem_wready; // @[Top.scala 88:30]
  assign dmem_decoder_io_targets_3_rdata = uart_io_mem_rdata; // @[Top.scala 90:30]
  assign dmem_decoder_io_targets_3_rvalid = uart_io_mem_rvalid; // @[Top.scala 90:30]
  assign dmem_decoder_io_targets_4_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 91:30]
  assign dmem_decoder_io_targets_4_rvalid = core_io_mtimer_mem_rvalid; // @[Top.scala 91:30]
  assign dmem_decoder_io_targets_5_rdata = config__io_mem_rdata; // @[Top.scala 92:30]
  assign imem_decoder_clock = clock;
  assign imem_decoder_io_initiator_addr = core_io_imem_addr; // @[Top.scala 101:16]
  assign imem_decoder_io_targets_0_inst = boot_rom_io_imem_inst; // @[Top.scala 98:30]
  assign imem_decoder_io_targets_0_valid = boot_rom_io_imem_valid; // @[Top.scala 98:30]
  assign imem_decoder_io_targets_1_inst = memory_io_imem_inst; // @[Top.scala 99:30]
  assign imem_decoder_io_targets_1_valid = memory_io_imem_valid; // @[Top.scala 99:30]
endmodule
