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
  reg [63:0] _RAND_72;
  reg [63:0] _RAND_73;
  reg [63:0] _RAND_74;
  reg [63:0] _RAND_75;
  reg [63:0] _RAND_76;
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
  reg [31:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
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
  wire  bp_clock; // @[Core.scala 327:18]
  wire  bp_reset; // @[Core.scala 327:18]
  wire [31:0] bp_io_lu_inst_pc; // @[Core.scala 327:18]
  wire  bp_io_lu_br_hit; // @[Core.scala 327:18]
  wire  bp_io_lu_br_pos; // @[Core.scala 327:18]
  wire [31:0] bp_io_lu_br_addr; // @[Core.scala 327:18]
  wire  bp_io_up_update_en; // @[Core.scala 327:18]
  wire [31:0] bp_io_up_inst_pc; // @[Core.scala 327:18]
  wire  bp_io_up_br_pos; // @[Core.scala 327:18]
  wire [31:0] bp_io_up_br_addr; // @[Core.scala 327:18]
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
  reg [47:0] mem_reg_mullu; // @[Core.scala 167:38]
  reg [47:0] mem_reg_mulls; // @[Core.scala 168:38]
  reg [47:0] mem_reg_mulhuu; // @[Core.scala 169:38]
  reg [47:0] mem_reg_mulhss; // @[Core.scala 170:38]
  reg [47:0] mem_reg_mulhsu; // @[Core.scala 171:38]
  reg [4:0] mem_reg_exe_fun; // @[Core.scala 172:38]
  reg [1:0] mem_reg_mem_wen; // @[Core.scala 173:38]
  reg [1:0] mem_reg_rf_wen; // @[Core.scala 174:38]
  reg [2:0] mem_reg_wb_sel; // @[Core.scala 175:38]
  reg [11:0] mem_reg_csr_addr; // @[Core.scala 176:38]
  reg [2:0] mem_reg_csr_cmd; // @[Core.scala 177:38]
  reg [31:0] mem_reg_alu_out; // @[Core.scala 179:38]
  reg [31:0] mem_reg_mem_w; // @[Core.scala 181:38]
  reg [3:0] mem_reg_mem_wstrb; // @[Core.scala 182:38]
  reg  mem_reg_is_half; // @[Core.scala 183:38]
  reg  mem_reg_is_valid_inst; // @[Core.scala 184:38]
  reg  mem_reg_is_trap; // @[Core.scala 185:38]
  reg [31:0] mem_reg_mcause; // @[Core.scala 186:38]
  reg [4:0] wb_reg_wb_addr; // @[Core.scala 190:38]
  reg [1:0] wb_reg_rf_wen; // @[Core.scala 191:38]
  reg [31:0] wb_reg_wb_data; // @[Core.scala 192:38]
  reg  wb_reg_is_valid_inst; // @[Core.scala 193:38]
  reg  if2_reg_is_bp_pos; // @[Core.scala 195:35]
  reg [31:0] if2_reg_bp_addr; // @[Core.scala 196:35]
  reg  ex3_reg_is_br; // @[Core.scala 200:35]
  reg [31:0] ex3_reg_br_target; // @[Core.scala 201:35]
  reg  mem_reg_is_br; // @[Core.scala 204:35]
  reg [31:0] mem_reg_br_addr; // @[Core.scala 205:35]
  reg  ic_reg_read_rdy; // @[Core.scala 214:32]
  reg  ic_reg_half_rdy; // @[Core.scala 215:32]
  reg [31:0] ic_reg_imem_addr; // @[Core.scala 217:33]
  reg [31:0] ic_reg_addr_out; // @[Core.scala 218:32]
  reg [31:0] ic_reg_inst; // @[Core.scala 220:34]
  reg [31:0] ic_reg_inst_addr; // @[Core.scala 221:34]
  reg [31:0] ic_reg_inst2; // @[Core.scala 222:34]
  reg [31:0] ic_reg_inst2_addr; // @[Core.scala 223:34]
  reg [2:0] ic_state; // @[Core.scala 225:25]
  wire [31:0] ic_imem_addr_2 = {ic_reg_imem_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] ic_imem_addr_4 = ic_reg_imem_addr + 32'h4; // @[Core.scala 228:41]
  wire [31:0] ic_inst_addr_2 = {ic_reg_inst_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  reg  if1_reg_first; // @[Core.scala 333:30]
  wire [31:0] _if1_jump_addr_T = if1_reg_first ? 32'h8000000 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_1 = if2_reg_is_bp_pos ? if2_reg_bp_addr : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_2 = ex3_reg_is_br ? ex3_reg_br_target : _if1_jump_addr_T_1; // @[Mux.scala 101:16]
  wire [31:0] if1_jump_addr = mem_reg_is_br ? mem_reg_br_addr : _if1_jump_addr_T_2; // @[Mux.scala 101:16]
  wire [31:0] ic_next_imem_addr = {if1_jump_addr[31:2],2'h0}; // @[Cat.scala 31:58]
  wire  _ic_read_en4_T = ~id_reg_stall; // @[Core.scala 369:18]
  wire  _if1_is_jump_T = mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 347:35]
  wire  if1_is_jump = mem_reg_is_br | ex3_reg_is_br | if2_reg_is_bp_pos | if1_reg_first; // @[Core.scala 347:73]
  wire [30:0] _ic_data_out_T_2 = {15'h0,io_imem_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_5 = {io_imem_inst[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_8 = {ic_reg_inst2[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_27 = 3'h3 == ic_state ? _ic_data_out_T_8 : 32'h13; // @[Core.scala 234:15 247:23 308:21]
  wire [31:0] _GEN_34 = 3'h4 == ic_state ? _ic_data_out_T_5 : _GEN_27; // @[Core.scala 247:23 290:21]
  wire [31:0] _GEN_42 = 3'h2 == ic_state ? ic_reg_inst : _GEN_34; // @[Core.scala 247:23 278:21]
  wire [31:0] _GEN_54 = 3'h1 == ic_state ? {{1'd0}, _ic_data_out_T_2} : _GEN_42; // @[Core.scala 247:23 268:21]
  wire [31:0] _GEN_63 = 3'h0 == ic_state ? io_imem_inst : _GEN_54; // @[Core.scala 247:23 253:21]
  wire [31:0] _GEN_74 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? 32'h13 : _GEN_63; // @[Core.scala 234:15 243:94]
  wire [31:0] ic_data_out = if1_is_jump ? 32'h13 : _GEN_74; // @[Core.scala 234:15 236:21]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 367:41]
  wire  ic_read_en4 = ~id_reg_stall & ~is_half_inst; // @[Core.scala 369:32]
  wire [31:0] _GEN_0 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_addr_out; // @[Core.scala 258:34 259:27 218:32]
  wire [1:0] _GEN_1 = ic_read_en4 ? 2'h0 : 2'h2; // @[Core.scala 254:18 258:34 260:20]
  wire  ic_read_en2 = _ic_read_en4_T & is_half_inst; // @[Core.scala 368:32]
  wire [31:0] _GEN_2 = ic_read_en2 ? ic_imem_addr_2 : _GEN_0; // @[Core.scala 255:28 256:27]
  wire [2:0] _GEN_3 = ic_read_en2 ? 3'h4 : {{1'd0}, _GEN_1}; // @[Core.scala 255:28 257:20]
  wire [31:0] _GEN_4 = ic_read_en2 ? ic_imem_addr_4 : ic_imem_addr_2; // @[Core.scala 269:25 271:28 272:27]
  wire [2:0] _GEN_5 = ic_read_en2 ? 3'h0 : 3'h4; // @[Core.scala 270:18 271:28 273:20]
  wire [31:0] _GEN_6 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_addr_out; // @[Core.scala 282:33 283:27 218:32]
  wire [2:0] _GEN_7 = ic_read_en4 ? 3'h0 : ic_state; // @[Core.scala 282:33 284:20 225:25]
  wire [31:0] _GEN_8 = ic_read_en2 ? ic_inst_addr_2 : _GEN_6; // @[Core.scala 279:28 280:27]
  wire [2:0] _GEN_9 = ic_read_en2 ? 3'h4 : _GEN_7; // @[Core.scala 279:28 281:20]
  wire [31:0] _GEN_10 = ic_read_en4 ? io_imem_inst : ic_reg_inst; // @[Core.scala 299:33 300:23 220:34]
  wire [31:0] _GEN_11 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_inst_addr; // @[Core.scala 299:33 301:28 221:34]
  wire [31:0] _GEN_12 = ic_read_en4 ? ic_imem_addr_2 : ic_reg_addr_out; // @[Core.scala 299:33 302:27 218:32]
  wire [2:0] _GEN_13 = ic_read_en4 ? 3'h4 : 3'h3; // @[Core.scala 293:18 299:33 303:20]
  wire [31:0] _GEN_14 = ic_read_en2 ? io_imem_inst : _GEN_10; // @[Core.scala 294:28 295:23]
  wire [31:0] _GEN_15 = ic_read_en2 ? ic_reg_imem_addr : _GEN_11; // @[Core.scala 294:28 296:28]
  wire [31:0] _GEN_16 = ic_read_en2 ? ic_reg_imem_addr : _GEN_12; // @[Core.scala 294:28 297:27]
  wire [2:0] _GEN_17 = ic_read_en2 ? 3'h2 : _GEN_13; // @[Core.scala 294:28 298:20]
  wire [31:0] _ic_reg_addr_out_T_3 = {ic_reg_inst2_addr[31:2],1'h1,1'h0}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_18 = ic_read_en4 ? ic_reg_inst2 : ic_reg_inst; // @[Core.scala 314:33 315:23 220:34]
  wire [31:0] _GEN_19 = ic_read_en4 ? ic_reg_inst2_addr : ic_reg_inst_addr; // @[Core.scala 314:33 316:28 221:34]
  wire [31:0] _GEN_20 = ic_read_en4 ? _ic_reg_addr_out_T_3 : ic_reg_addr_out; // @[Core.scala 314:33 317:27 218:32]
  wire [2:0] _GEN_21 = ic_read_en4 ? 3'h4 : ic_state; // @[Core.scala 314:33 318:20 225:25]
  wire [31:0] _GEN_22 = ic_read_en2 ? ic_reg_inst2 : _GEN_18; // @[Core.scala 309:28 310:23]
  wire [31:0] _GEN_23 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_19; // @[Core.scala 309:28 311:28]
  wire [31:0] _GEN_24 = ic_read_en2 ? ic_reg_inst2_addr : _GEN_20; // @[Core.scala 309:28 312:27]
  wire [2:0] _GEN_25 = ic_read_en2 ? 3'h2 : _GEN_21; // @[Core.scala 309:28 313:20]
  wire [31:0] _GEN_28 = 3'h3 == ic_state ? _GEN_22 : ic_reg_inst; // @[Core.scala 247:23 220:34]
  wire [31:0] _GEN_29 = 3'h3 == ic_state ? _GEN_23 : ic_reg_inst_addr; // @[Core.scala 247:23 221:34]
  wire [31:0] _GEN_30 = 3'h3 == ic_state ? _GEN_24 : ic_reg_addr_out; // @[Core.scala 247:23 218:32]
  wire [2:0] _GEN_31 = 3'h3 == ic_state ? _GEN_25 : ic_state; // @[Core.scala 247:23 225:25]
  wire [31:0] _GEN_32 = 3'h4 == ic_state ? ic_imem_addr_4 : ic_reg_imem_addr; // @[Core.scala 247:23 288:22]
  wire [31:0] _GEN_35 = 3'h4 == ic_state ? io_imem_inst : ic_reg_inst2; // @[Core.scala 247:23 291:22 222:34]
  wire [31:0] _GEN_36 = 3'h4 == ic_state ? ic_reg_imem_addr : ic_reg_inst2_addr; // @[Core.scala 247:23 292:27 223:34]
  wire [2:0] _GEN_37 = 3'h4 == ic_state ? _GEN_17 : _GEN_31; // @[Core.scala 247:23]
  wire [31:0] _GEN_38 = 3'h4 == ic_state ? _GEN_14 : _GEN_28; // @[Core.scala 247:23]
  wire [31:0] _GEN_39 = 3'h4 == ic_state ? _GEN_15 : _GEN_29; // @[Core.scala 247:23]
  wire [31:0] _GEN_40 = 3'h4 == ic_state ? _GEN_16 : _GEN_30; // @[Core.scala 247:23]
  wire [31:0] _GEN_41 = 3'h2 == ic_state ? ic_reg_imem_addr : _GEN_32; // @[Core.scala 247:23 277:22]
  wire [31:0] _GEN_43 = 3'h2 == ic_state ? _GEN_8 : _GEN_40; // @[Core.scala 247:23]
  wire [2:0] _GEN_44 = 3'h2 == ic_state ? _GEN_9 : _GEN_37; // @[Core.scala 247:23]
  wire [31:0] _GEN_46 = 3'h2 == ic_state ? ic_reg_inst2 : _GEN_35; // @[Core.scala 247:23 222:34]
  wire [31:0] _GEN_47 = 3'h2 == ic_state ? ic_reg_inst2_addr : _GEN_36; // @[Core.scala 247:23 223:34]
  wire [31:0] _GEN_48 = 3'h2 == ic_state ? ic_reg_inst : _GEN_38; // @[Core.scala 247:23 220:34]
  wire [31:0] _GEN_49 = 3'h2 == ic_state ? ic_reg_inst_addr : _GEN_39; // @[Core.scala 247:23 221:34]
  wire [31:0] _GEN_50 = 3'h1 == ic_state ? ic_imem_addr_4 : _GEN_41; // @[Core.scala 247:23 264:22]
  wire [31:0] _GEN_52 = 3'h1 == ic_state ? io_imem_inst : _GEN_48; // @[Core.scala 247:23 266:21]
  wire [31:0] _GEN_53 = 3'h1 == ic_state ? ic_reg_imem_addr : _GEN_49; // @[Core.scala 247:23 267:26]
  wire [31:0] _GEN_55 = 3'h1 == ic_state ? _GEN_4 : _GEN_43; // @[Core.scala 247:23]
  wire [2:0] _GEN_56 = 3'h1 == ic_state ? _GEN_5 : _GEN_44; // @[Core.scala 247:23]
  wire [31:0] _GEN_57 = 3'h1 == ic_state ? ic_reg_inst2 : _GEN_46; // @[Core.scala 247:23 222:34]
  wire [31:0] _GEN_58 = 3'h1 == ic_state ? ic_reg_inst2_addr : _GEN_47; // @[Core.scala 247:23 223:34]
  wire [31:0] _GEN_59 = 3'h0 == ic_state ? ic_imem_addr_4 : _GEN_50; // @[Core.scala 247:23 249:22]
  wire  _GEN_69 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_half_rdy : 1'h1; // @[Core.scala 233:19 243:94 245:21]
  wire [31:0] _GEN_70 = ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid ? ic_reg_imem_addr : _GEN_59; // @[Core.scala 230:16 243:94]
  wire  _GEN_84 = if1_is_jump | _GEN_69; // @[Core.scala 233:19 236:21]
  reg [31:0] if1_reg_next_pc; // @[Core.scala 352:32]
  wire [31:0] if1_next_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 353:24]
  wire [31:0] if1_next_pc_4 = if1_next_pc + 32'h4; // @[Core.scala 354:35]
  reg [31:0] if2_reg_pc; // @[Core.scala 364:29]
  reg [31:0] if2_reg_inst; // @[Core.scala 365:29]
  wire  _if2_pc_T = ic_reg_half_rdy & is_half_inst; // @[Core.scala 370:74]
  wire [31:0] if2_pc = id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst) ? if2_reg_pc : ic_reg_addr_out
    ; // @[Core.scala 370:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_reg_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = if2_reg_is_bp_pos ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = id_reg_stall ? if2_reg_inst : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = mem_reg_is_br ? 32'h13 : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex3_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire  if2_is_cond_br_w = if2_inst[6:0] == 7'h63; // @[Core.scala 385:42]
  wire  _if2_is_cond_br_c_T_3 = if2_inst[1:0] == 2'h1; // @[Core.scala 386:70]
  wire  if2_is_cond_br_c = if2_inst[15:14] == 2'h3 & if2_inst[1:0] == 2'h1; // @[Core.scala 386:52]
  wire  if2_is_cond_br = if2_is_cond_br_w | if2_is_cond_br_c; // @[Core.scala 387:41]
  wire  if2_is_jal_w = if2_inst[6:0] == 7'h6f; // @[Core.scala 388:38]
  wire  if2_is_jal_c = if2_inst[14:13] == 2'h1 & _if2_is_cond_br_c_T_3; // @[Core.scala 389:48]
  wire  if2_is_jal = if2_is_jal_w | if2_is_jal_c; // @[Core.scala 390:33]
  wire  if2_is_jalr = if2_inst[6:0] == 7'h67 | if2_inst[15:13] == 3'h4 & if2_inst[6:0] == 7'h2; // @[Core.scala 391:50]
  wire  if2_is_bp_br = if2_is_cond_br | if2_is_jalr | if2_is_jal; // @[Core.scala 392:52]
  wire  _if2_is_bp_pos_T = if2_is_bp_br & bp_io_lu_br_pos; // @[Core.scala 395:19]
  wire  _T_21 = ~reset; // @[Core.scala 404:9]
  reg  ex1_reg_hazard; // @[Core.scala 837:38]
  wire  _ex1_stall_T = ex1_reg_op1_sel == 3'h0; // @[Core.scala 851:23]
  wire  _ex1_stall_T_1 = ex1_reg_hazard & _ex1_stall_T; // @[Core.scala 850:21]
  wire  _ex1_stall_T_2 = ex1_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 852:24]
  wire  _ex1_stall_T_3 = _ex1_stall_T_1 & _ex1_stall_T_2; // @[Core.scala 851:36]
  reg  ex2_reg_hazard; // @[Core.scala 840:38]
  wire  _ex1_stall_T_5 = ex2_reg_hazard & _ex1_stall_T; // @[Core.scala 853:21]
  wire  _ex1_stall_T_6 = ex1_reg_rs1_addr == mem_reg_wb_addr; // @[Core.scala 855:24]
  wire  _ex1_stall_T_7 = _ex1_stall_T_5 & _ex1_stall_T_6; // @[Core.scala 854:36]
  wire  _ex1_stall_T_8 = _ex1_stall_T_3 | _ex1_stall_T_7; // @[Core.scala 852:46]
  wire  _ex1_stall_T_9 = ex1_reg_op2_sel == 4'h1; // @[Core.scala 857:23]
  wire  _ex1_stall_T_11 = ex1_reg_op2_sel == 4'h1 | ex1_reg_mem_wen == 2'h1; // @[Core.scala 857:35]
  wire  _ex1_stall_T_12 = ex1_reg_hazard & _ex1_stall_T_11; // @[Core.scala 856:21]
  wire  _ex1_stall_T_13 = ex1_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 858:24]
  wire  _ex1_stall_T_14 = _ex1_stall_T_12 & _ex1_stall_T_13; // @[Core.scala 857:65]
  wire  _ex1_stall_T_15 = _ex1_stall_T_8 | _ex1_stall_T_14; // @[Core.scala 855:46]
  wire  _ex1_stall_T_19 = ex2_reg_hazard & _ex1_stall_T_11; // @[Core.scala 859:21]
  wire  _ex1_stall_T_20 = ex1_reg_rs2_addr == mem_reg_wb_addr; // @[Core.scala 861:24]
  wire  _ex1_stall_T_21 = _ex1_stall_T_19 & _ex1_stall_T_20; // @[Core.scala 860:65]
  wire  ex1_stall = _ex1_stall_T_15 | _ex1_stall_T_21; // @[Core.scala 858:46]
  wire  _mem_en_T = ~mem_reg_is_br; // @[Core.scala 1102:30]
  wire  _mem_en_T_2 = ~ex3_reg_is_br; // @[Core.scala 1102:48]
  wire  _mem_en_T_4 = ~mem_reg_is_trap; // @[Core.scala 1102:66]
  wire  _mem_is_valid_inst_T_2 = _mem_en_T & _mem_en_T_2; // @[Core.scala 1098:68]
  wire  mem_is_valid_inst = mem_reg_is_valid_inst & (_mem_en_T & _mem_en_T_2); // @[Core.scala 1098:49]
  wire  mem_is_meintr = csr_mstatus[3] & (io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1099:73]
  wire  _mem_en_T_6 = ~mem_is_meintr; // @[Core.scala 1102:86]
  wire  mem_is_mtintr = csr_mstatus[3] & (mtimer_io_intr & csr_mie[7]) & mem_is_valid_inst; // @[Core.scala 1100:79]
  wire  _mem_en_T_8 = ~mem_is_mtintr; // @[Core.scala 1102:104]
  wire  mem_en = mem_reg_en & ~mem_reg_is_br & ~ex3_reg_is_br & ~mem_reg_is_trap & ~mem_is_meintr & ~mem_is_mtintr; // @[Core.scala 1102:101]
  wire [2:0] mem_wb_sel = mem_en ? mem_reg_wb_sel : 3'h0; // @[Core.scala 1104:23]
  wire  _mem_stall_T = mem_wb_sel == 3'h5; // @[Core.scala 1115:29]
  reg  mem_stall_delay; // @[Core.scala 1107:32]
  wire [1:0] mem_mem_wen = mem_en ? mem_reg_mem_wen : 2'h0; // @[Core.scala 1106:24]
  wire  _mem_stall_T_6 = mem_mem_wen == 2'h1; // @[Core.scala 1115:118]
  wire  mem_stall = mem_wb_sel == 3'h5 & (~io_dmem_rvalid | ~io_dmem_rready | mem_stall_delay) | mem_mem_wen == 2'h1 & ~
    io_dmem_wready | mem_mem_wen == 2'h3 & io_icache_control_busy; // @[Core.scala 1115:149]
  wire  id_stall = ex1_stall | mem_stall; // @[Core.scala 425:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 429:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 431:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 433:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 434:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 435:30]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 439:18]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 442:18]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 446:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 31:58]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 31:58]
  wire  _id_c_rs1_data_T = id_w_wb_addr == 5'h0; // @[Core.scala 454:20]
  wire [31:0] id_c_rs1_data = _id_c_rs1_data_T ? 32'h0 : regfile_id_c_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_c_rs2_data_T = id_c_rs2_addr == 5'h0; // @[Core.scala 457:20]
  wire [31:0] id_c_rs2_data = _id_c_rs2_data_T ? 32'h0 : regfile_id_c_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 463:25]
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
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 471:25]
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
  wire [31:0] _csignals_T_100 = id_inst & 32'hffff; // @[Lookup.scala 31:38]
  wire  _csignals_T_101 = 32'h0 == _csignals_T_100; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_102 = id_inst & 32'he003; // @[Lookup.scala 31:38]
  wire  _csignals_T_103 = 32'h0 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_104 = id_inst & 32'hef83; // @[Lookup.scala 31:38]
  wire  _csignals_T_105 = 32'h6101 == _csignals_T_104; // @[Lookup.scala 31:38]
  wire  _csignals_T_107 = 32'h1 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_109 = 32'h4000 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_111 = 32'hc000 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_113 = 32'h4001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_115 = 32'h6001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_116 = id_inst & 32'hec03; // @[Lookup.scala 31:38]
  wire  _csignals_T_117 = 32'h8401 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_119 = 32'h8001 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire  _csignals_T_121 = 32'h8801 == _csignals_T_116; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_122 = id_inst & 32'hfc63; // @[Lookup.scala 31:38]
  wire  _csignals_T_123 = 32'h8c01 == _csignals_T_122; // @[Lookup.scala 31:38]
  wire  _csignals_T_125 = 32'h8c21 == _csignals_T_122; // @[Lookup.scala 31:38]
  wire  _csignals_T_127 = 32'h8c41 == _csignals_T_122; // @[Lookup.scala 31:38]
  wire  _csignals_T_129 = 32'h8c61 == _csignals_T_122; // @[Lookup.scala 31:38]
  wire  _csignals_T_131 = 32'h2 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_133 = 32'ha001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_135 = 32'hc001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_137 = 32'he001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_138 = id_inst & 32'hf07f; // @[Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'h8002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h9002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_143 = 32'h2001 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_145 = 32'h4002 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire  _csignals_T_147 = 32'hc002 == _csignals_T_102; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_148 = id_inst & 32'hf003; // @[Lookup.scala 31:38]
  wire  _csignals_T_149 = 32'h8002 == _csignals_T_148; // @[Lookup.scala 31:38]
  wire  _csignals_T_151 = 32'h9002 == _csignals_T_148; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_152 = _csignals_T_151 ? 5'h1 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_153 = _csignals_T_149 ? 5'h1 : _csignals_T_152; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_154 = _csignals_T_147 ? 5'h1 : _csignals_T_153; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_155 = _csignals_T_145 ? 5'h1 : _csignals_T_154; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_156 = _csignals_T_143 ? 5'h1 : _csignals_T_155; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_157 = _csignals_T_141 ? 5'h11 : _csignals_T_156; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_158 = _csignals_T_139 ? 5'h11 : _csignals_T_157; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_159 = _csignals_T_137 ? 5'hc : _csignals_T_158; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_160 = _csignals_T_135 ? 5'hb : _csignals_T_159; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_161 = _csignals_T_133 ? 5'h1 : _csignals_T_160; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_162 = _csignals_T_131 ? 5'h6 : _csignals_T_161; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_163 = _csignals_T_129 ? 5'h3 : _csignals_T_162; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_164 = _csignals_T_127 ? 5'h4 : _csignals_T_163; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_165 = _csignals_T_125 ? 5'h5 : _csignals_T_164; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_166 = _csignals_T_123 ? 5'h2 : _csignals_T_165; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_167 = _csignals_T_121 ? 5'h3 : _csignals_T_166; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_168 = _csignals_T_119 ? 5'h7 : _csignals_T_167; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_169 = _csignals_T_117 ? 5'h8 : _csignals_T_168; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_170 = _csignals_T_115 ? 5'h1 : _csignals_T_169; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_171 = _csignals_T_113 ? 5'h1 : _csignals_T_170; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_172 = _csignals_T_111 ? 5'h1 : _csignals_T_171; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_173 = _csignals_T_109 ? 5'h1 : _csignals_T_172; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_174 = _csignals_T_107 ? 5'h1 : _csignals_T_173; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_175 = _csignals_T_105 ? 5'h1 : _csignals_T_174; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_176 = _csignals_T_103 ? 5'h1 : _csignals_T_175; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_177 = _csignals_T_101 ? 5'h0 : _csignals_T_176; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_178 = _csignals_T_99 ? 5'h19 : _csignals_T_177; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_179 = _csignals_T_97 ? 5'h18 : _csignals_T_178; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_180 = _csignals_T_95 ? 5'h17 : _csignals_T_179; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_181 = _csignals_T_93 ? 5'h16 : _csignals_T_180; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_182 = _csignals_T_91 ? 5'h0 : _csignals_T_181; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_183 = _csignals_T_89 ? 5'h0 : _csignals_T_182; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_184 = _csignals_T_87 ? 5'h0 : _csignals_T_183; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_185 = _csignals_T_85 ? 5'h12 : _csignals_T_184; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_186 = _csignals_T_83 ? 5'h12 : _csignals_T_185; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_187 = _csignals_T_81 ? 5'h12 : _csignals_T_186; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_188 = _csignals_T_79 ? 5'h12 : _csignals_T_187; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_189 = _csignals_T_77 ? 5'h12 : _csignals_T_188; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_190 = _csignals_T_75 ? 5'h12 : _csignals_T_189; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_191 = _csignals_T_73 ? 5'h1 : _csignals_T_190; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_192 = _csignals_T_71 ? 5'h1 : _csignals_T_191; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_193 = _csignals_T_69 ? 5'h11 : _csignals_T_192; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_194 = _csignals_T_67 ? 5'h1 : _csignals_T_193; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_195 = _csignals_T_65 ? 5'hf : _csignals_T_194; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_196 = _csignals_T_63 ? 5'hd : _csignals_T_195; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_197 = _csignals_T_61 ? 5'h10 : _csignals_T_196; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_198 = _csignals_T_59 ? 5'he : _csignals_T_197; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_199 = _csignals_T_57 ? 5'hc : _csignals_T_198; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_200 = _csignals_T_55 ? 5'hb : _csignals_T_199; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_201 = _csignals_T_53 ? 5'ha : _csignals_T_200; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_202 = _csignals_T_51 ? 5'h9 : _csignals_T_201; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_203 = _csignals_T_49 ? 5'ha : _csignals_T_202; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_204 = _csignals_T_47 ? 5'h9 : _csignals_T_203; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_205 = _csignals_T_45 ? 5'h8 : _csignals_T_204; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_206 = _csignals_T_43 ? 5'h7 : _csignals_T_205; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_207 = _csignals_T_41 ? 5'h6 : _csignals_T_206; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_208 = _csignals_T_39 ? 5'h8 : _csignals_T_207; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_209 = _csignals_T_37 ? 5'h7 : _csignals_T_208; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_210 = _csignals_T_35 ? 5'h6 : _csignals_T_209; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_211 = _csignals_T_33 ? 5'h5 : _csignals_T_210; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_212 = _csignals_T_31 ? 5'h4 : _csignals_T_211; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_213 = _csignals_T_29 ? 5'h3 : _csignals_T_212; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_214 = _csignals_T_27 ? 5'h5 : _csignals_T_213; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_215 = _csignals_T_25 ? 5'h4 : _csignals_T_214; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_216 = _csignals_T_23 ? 5'h3 : _csignals_T_215; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_217 = _csignals_T_21 ? 5'h2 : _csignals_T_216; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_218 = _csignals_T_19 ? 5'h1 : _csignals_T_217; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_219 = _csignals_T_17 ? 5'h1 : _csignals_T_218; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_220 = _csignals_T_15 ? 5'h1 : _csignals_T_219; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_221 = _csignals_T_13 ? 5'h1 : _csignals_T_220; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_222 = _csignals_T_11 ? 5'h1 : _csignals_T_221; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_223 = _csignals_T_9 ? 5'h1 : _csignals_T_222; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_224 = _csignals_T_7 ? 5'h1 : _csignals_T_223; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_225 = _csignals_T_5 ? 5'h1 : _csignals_T_224; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_226 = _csignals_T_3 ? 5'h1 : _csignals_T_225; // @[Lookup.scala 34:39]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h1 : _csignals_T_226; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_227 = _csignals_T_151 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_228 = _csignals_T_149 ? 3'h2 : _csignals_T_227; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_229 = _csignals_T_147 ? 3'h5 : _csignals_T_228; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_230 = _csignals_T_145 ? 3'h5 : _csignals_T_229; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_231 = _csignals_T_143 ? 3'h1 : _csignals_T_230; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_232 = _csignals_T_141 ? 3'h4 : _csignals_T_231; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_233 = _csignals_T_139 ? 3'h4 : _csignals_T_232; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_234 = _csignals_T_137 ? 3'h6 : _csignals_T_233; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_235 = _csignals_T_135 ? 3'h6 : _csignals_T_234; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_236 = _csignals_T_133 ? 3'h1 : _csignals_T_235; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_237 = _csignals_T_131 ? 3'h4 : _csignals_T_236; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_238 = _csignals_T_129 ? 3'h6 : _csignals_T_237; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_239 = _csignals_T_127 ? 3'h6 : _csignals_T_238; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_240 = _csignals_T_125 ? 3'h6 : _csignals_T_239; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_241 = _csignals_T_123 ? 3'h6 : _csignals_T_240; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_242 = _csignals_T_121 ? 3'h6 : _csignals_T_241; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_243 = _csignals_T_119 ? 3'h6 : _csignals_T_242; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_244 = _csignals_T_117 ? 3'h6 : _csignals_T_243; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_245 = _csignals_T_115 ? 3'h2 : _csignals_T_244; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_246 = _csignals_T_113 ? 3'h2 : _csignals_T_245; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_247 = _csignals_T_111 ? 3'h6 : _csignals_T_246; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_248 = _csignals_T_109 ? 3'h6 : _csignals_T_247; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_249 = _csignals_T_107 ? 3'h4 : _csignals_T_248; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_250 = _csignals_T_105 ? 3'h4 : _csignals_T_249; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_251 = _csignals_T_103 ? 3'h5 : _csignals_T_250; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_252 = _csignals_T_101 ? 3'h4 : _csignals_T_251; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_253 = _csignals_T_99 ? 3'h0 : _csignals_T_252; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_254 = _csignals_T_97 ? 3'h0 : _csignals_T_253; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_255 = _csignals_T_95 ? 3'h0 : _csignals_T_254; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_256 = _csignals_T_93 ? 3'h0 : _csignals_T_255; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_257 = _csignals_T_91 ? 3'h2 : _csignals_T_256; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_258 = _csignals_T_89 ? 3'h2 : _csignals_T_257; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_259 = _csignals_T_87 ? 3'h2 : _csignals_T_258; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_260 = _csignals_T_85 ? 3'h3 : _csignals_T_259; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_261 = _csignals_T_83 ? 3'h0 : _csignals_T_260; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_262 = _csignals_T_81 ? 3'h3 : _csignals_T_261; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_263 = _csignals_T_79 ? 3'h0 : _csignals_T_262; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_264 = _csignals_T_77 ? 3'h3 : _csignals_T_263; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_265 = _csignals_T_75 ? 3'h0 : _csignals_T_264; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_266 = _csignals_T_73 ? 3'h1 : _csignals_T_265; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_267 = _csignals_T_71 ? 3'h2 : _csignals_T_266; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_268 = _csignals_T_69 ? 3'h0 : _csignals_T_267; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_269 = _csignals_T_67 ? 3'h1 : _csignals_T_268; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_270 = _csignals_T_65 ? 3'h0 : _csignals_T_269; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_271 = _csignals_T_63 ? 3'h0 : _csignals_T_270; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_272 = _csignals_T_61 ? 3'h0 : _csignals_T_271; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_273 = _csignals_T_59 ? 3'h0 : _csignals_T_272; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_274 = _csignals_T_57 ? 3'h0 : _csignals_T_273; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_275 = _csignals_T_55 ? 3'h0 : _csignals_T_274; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_276 = _csignals_T_53 ? 3'h0 : _csignals_T_275; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_277 = _csignals_T_51 ? 3'h0 : _csignals_T_276; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_278 = _csignals_T_49 ? 3'h0 : _csignals_T_277; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_279 = _csignals_T_47 ? 3'h0 : _csignals_T_278; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_280 = _csignals_T_45 ? 3'h0 : _csignals_T_279; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_281 = _csignals_T_43 ? 3'h0 : _csignals_T_280; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_282 = _csignals_T_41 ? 3'h0 : _csignals_T_281; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_283 = _csignals_T_39 ? 3'h0 : _csignals_T_282; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_284 = _csignals_T_37 ? 3'h0 : _csignals_T_283; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_285 = _csignals_T_35 ? 3'h0 : _csignals_T_284; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_286 = _csignals_T_33 ? 3'h0 : _csignals_T_285; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_287 = _csignals_T_31 ? 3'h0 : _csignals_T_286; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_288 = _csignals_T_29 ? 3'h0 : _csignals_T_287; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_289 = _csignals_T_27 ? 3'h0 : _csignals_T_288; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_290 = _csignals_T_25 ? 3'h0 : _csignals_T_289; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_291 = _csignals_T_23 ? 3'h0 : _csignals_T_290; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_292 = _csignals_T_21 ? 3'h0 : _csignals_T_291; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_293 = _csignals_T_19 ? 3'h0 : _csignals_T_292; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_294 = _csignals_T_17 ? 3'h0 : _csignals_T_293; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_295 = _csignals_T_15 ? 3'h0 : _csignals_T_294; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_296 = _csignals_T_13 ? 3'h0 : _csignals_T_295; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_297 = _csignals_T_11 ? 3'h0 : _csignals_T_296; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_298 = _csignals_T_9 ? 3'h0 : _csignals_T_297; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_299 = _csignals_T_7 ? 3'h0 : _csignals_T_298; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_300 = _csignals_T_5 ? 3'h0 : _csignals_T_299; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_301 = _csignals_T_3 ? 3'h0 : _csignals_T_300; // @[Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h0 : _csignals_T_301; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_302 = _csignals_T_151 ? 4'h6 : 4'h1; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_303 = _csignals_T_149 ? 4'h6 : _csignals_T_302; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_304 = _csignals_T_147 ? 4'hf : _csignals_T_303; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_305 = _csignals_T_145 ? 4'he : _csignals_T_304; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_306 = _csignals_T_143 ? 4'hd : _csignals_T_305; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_307 = _csignals_T_141 ? 4'h0 : _csignals_T_306; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_308 = _csignals_T_139 ? 4'h0 : _csignals_T_307; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_309 = _csignals_T_137 ? 4'h0 : _csignals_T_308; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_310 = _csignals_T_135 ? 4'h0 : _csignals_T_309; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_311 = _csignals_T_133 ? 4'hd : _csignals_T_310; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_312 = _csignals_T_131 ? 4'ha : _csignals_T_311; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_313 = _csignals_T_129 ? 4'h7 : _csignals_T_312; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_314 = _csignals_T_127 ? 4'h7 : _csignals_T_313; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_315 = _csignals_T_125 ? 4'h7 : _csignals_T_314; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_316 = _csignals_T_123 ? 4'h7 : _csignals_T_315; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_317 = _csignals_T_121 ? 4'ha : _csignals_T_316; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_318 = _csignals_T_119 ? 4'ha : _csignals_T_317; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_319 = _csignals_T_117 ? 4'ha : _csignals_T_318; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_320 = _csignals_T_115 ? 4'hc : _csignals_T_319; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_321 = _csignals_T_113 ? 4'ha : _csignals_T_320; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_322 = _csignals_T_111 ? 4'hb : _csignals_T_321; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_323 = _csignals_T_109 ? 4'hb : _csignals_T_322; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_324 = _csignals_T_107 ? 4'ha : _csignals_T_323; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_325 = _csignals_T_105 ? 4'h9 : _csignals_T_324; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_326 = _csignals_T_103 ? 4'h8 : _csignals_T_325; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_327 = _csignals_T_101 ? 4'h6 : _csignals_T_326; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_328 = _csignals_T_99 ? 4'h1 : _csignals_T_327; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_329 = _csignals_T_97 ? 4'h1 : _csignals_T_328; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_330 = _csignals_T_95 ? 4'h1 : _csignals_T_329; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_331 = _csignals_T_93 ? 4'h1 : _csignals_T_330; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_332 = _csignals_T_91 ? 4'h0 : _csignals_T_331; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_333 = _csignals_T_89 ? 4'h0 : _csignals_T_332; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_334 = _csignals_T_87 ? 4'h0 : _csignals_T_333; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_335 = _csignals_T_85 ? 4'h0 : _csignals_T_334; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_336 = _csignals_T_83 ? 4'h0 : _csignals_T_335; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_337 = _csignals_T_81 ? 4'h0 : _csignals_T_336; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_338 = _csignals_T_79 ? 4'h0 : _csignals_T_337; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_339 = _csignals_T_77 ? 4'h0 : _csignals_T_338; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_340 = _csignals_T_75 ? 4'h0 : _csignals_T_339; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_341 = _csignals_T_73 ? 4'h5 : _csignals_T_340; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_342 = _csignals_T_71 ? 4'h5 : _csignals_T_341; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_343 = _csignals_T_69 ? 4'h2 : _csignals_T_342; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_344 = _csignals_T_67 ? 4'h4 : _csignals_T_343; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_345 = _csignals_T_65 ? 4'h1 : _csignals_T_344; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_346 = _csignals_T_63 ? 4'h1 : _csignals_T_345; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_347 = _csignals_T_61 ? 4'h1 : _csignals_T_346; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_348 = _csignals_T_59 ? 4'h1 : _csignals_T_347; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_349 = _csignals_T_57 ? 4'h1 : _csignals_T_348; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_350 = _csignals_T_55 ? 4'h1 : _csignals_T_349; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_351 = _csignals_T_53 ? 4'h2 : _csignals_T_350; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_352 = _csignals_T_51 ? 4'h2 : _csignals_T_351; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_353 = _csignals_T_49 ? 4'h1 : _csignals_T_352; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_354 = _csignals_T_47 ? 4'h1 : _csignals_T_353; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_355 = _csignals_T_45 ? 4'h2 : _csignals_T_354; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_356 = _csignals_T_43 ? 4'h2 : _csignals_T_355; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_357 = _csignals_T_41 ? 4'h2 : _csignals_T_356; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_358 = _csignals_T_39 ? 4'h1 : _csignals_T_357; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_359 = _csignals_T_37 ? 4'h1 : _csignals_T_358; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_360 = _csignals_T_35 ? 4'h1 : _csignals_T_359; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_361 = _csignals_T_33 ? 4'h2 : _csignals_T_360; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_362 = _csignals_T_31 ? 4'h2 : _csignals_T_361; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_363 = _csignals_T_29 ? 4'h2 : _csignals_T_362; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_364 = _csignals_T_27 ? 4'h1 : _csignals_T_363; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_365 = _csignals_T_25 ? 4'h1 : _csignals_T_364; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_366 = _csignals_T_23 ? 4'h1 : _csignals_T_365; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_367 = _csignals_T_21 ? 4'h1 : _csignals_T_366; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_368 = _csignals_T_19 ? 4'h2 : _csignals_T_367; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_369 = _csignals_T_17 ? 4'h1 : _csignals_T_368; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_370 = _csignals_T_15 ? 4'h3 : _csignals_T_369; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_371 = _csignals_T_13 ? 4'h2 : _csignals_T_370; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_372 = _csignals_T_11 ? 4'h3 : _csignals_T_371; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_373 = _csignals_T_9 ? 4'h2 : _csignals_T_372; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_374 = _csignals_T_7 ? 4'h2 : _csignals_T_373; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_375 = _csignals_T_5 ? 4'h3 : _csignals_T_374; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_376 = _csignals_T_3 ? 4'h2 : _csignals_T_375; // @[Lookup.scala 34:39]
  wire [3:0] csignals_2 = _csignals_T_1 ? 4'h2 : _csignals_T_376; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_379 = _csignals_T_147 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_380 = _csignals_T_145 ? 2'h0 : _csignals_T_379; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_381 = _csignals_T_143 ? 2'h0 : _csignals_T_380; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_382 = _csignals_T_141 ? 2'h0 : _csignals_T_381; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_383 = _csignals_T_139 ? 2'h0 : _csignals_T_382; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_384 = _csignals_T_137 ? 2'h0 : _csignals_T_383; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_385 = _csignals_T_135 ? 2'h0 : _csignals_T_384; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_386 = _csignals_T_133 ? 2'h0 : _csignals_T_385; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_387 = _csignals_T_131 ? 2'h0 : _csignals_T_386; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_388 = _csignals_T_129 ? 2'h0 : _csignals_T_387; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_389 = _csignals_T_127 ? 2'h0 : _csignals_T_388; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_390 = _csignals_T_125 ? 2'h0 : _csignals_T_389; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_391 = _csignals_T_123 ? 2'h0 : _csignals_T_390; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_392 = _csignals_T_121 ? 2'h0 : _csignals_T_391; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_393 = _csignals_T_119 ? 2'h0 : _csignals_T_392; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_394 = _csignals_T_117 ? 2'h0 : _csignals_T_393; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_395 = _csignals_T_115 ? 2'h0 : _csignals_T_394; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_396 = _csignals_T_113 ? 2'h0 : _csignals_T_395; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_397 = _csignals_T_111 ? 2'h1 : _csignals_T_396; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_398 = _csignals_T_109 ? 2'h0 : _csignals_T_397; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_399 = _csignals_T_107 ? 2'h0 : _csignals_T_398; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_400 = _csignals_T_105 ? 2'h0 : _csignals_T_399; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_401 = _csignals_T_103 ? 2'h0 : _csignals_T_400; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_402 = _csignals_T_101 ? 2'h0 : _csignals_T_401; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_403 = _csignals_T_99 ? 2'h0 : _csignals_T_402; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_404 = _csignals_T_97 ? 2'h0 : _csignals_T_403; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_405 = _csignals_T_95 ? 2'h0 : _csignals_T_404; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_406 = _csignals_T_93 ? 2'h0 : _csignals_T_405; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_407 = _csignals_T_91 ? 2'h3 : _csignals_T_406; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_408 = _csignals_T_89 ? 2'h0 : _csignals_T_407; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_409 = _csignals_T_87 ? 2'h0 : _csignals_T_408; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_410 = _csignals_T_85 ? 2'h0 : _csignals_T_409; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_411 = _csignals_T_83 ? 2'h0 : _csignals_T_410; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_412 = _csignals_T_81 ? 2'h0 : _csignals_T_411; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_413 = _csignals_T_79 ? 2'h0 : _csignals_T_412; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_414 = _csignals_T_77 ? 2'h0 : _csignals_T_413; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_415 = _csignals_T_75 ? 2'h0 : _csignals_T_414; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_416 = _csignals_T_73 ? 2'h0 : _csignals_T_415; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_417 = _csignals_T_71 ? 2'h0 : _csignals_T_416; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_418 = _csignals_T_69 ? 2'h0 : _csignals_T_417; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_419 = _csignals_T_67 ? 2'h0 : _csignals_T_418; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_420 = _csignals_T_65 ? 2'h0 : _csignals_T_419; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_421 = _csignals_T_63 ? 2'h0 : _csignals_T_420; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_422 = _csignals_T_61 ? 2'h0 : _csignals_T_421; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_423 = _csignals_T_59 ? 2'h0 : _csignals_T_422; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_424 = _csignals_T_57 ? 2'h0 : _csignals_T_423; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_425 = _csignals_T_55 ? 2'h0 : _csignals_T_424; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_426 = _csignals_T_53 ? 2'h0 : _csignals_T_425; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_427 = _csignals_T_51 ? 2'h0 : _csignals_T_426; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_428 = _csignals_T_49 ? 2'h0 : _csignals_T_427; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_429 = _csignals_T_47 ? 2'h0 : _csignals_T_428; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_430 = _csignals_T_45 ? 2'h0 : _csignals_T_429; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_431 = _csignals_T_43 ? 2'h0 : _csignals_T_430; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_432 = _csignals_T_41 ? 2'h0 : _csignals_T_431; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_433 = _csignals_T_39 ? 2'h0 : _csignals_T_432; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_434 = _csignals_T_37 ? 2'h0 : _csignals_T_433; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_435 = _csignals_T_35 ? 2'h0 : _csignals_T_434; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_436 = _csignals_T_33 ? 2'h0 : _csignals_T_435; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_437 = _csignals_T_31 ? 2'h0 : _csignals_T_436; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_438 = _csignals_T_29 ? 2'h0 : _csignals_T_437; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_439 = _csignals_T_27 ? 2'h0 : _csignals_T_438; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_440 = _csignals_T_25 ? 2'h0 : _csignals_T_439; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_441 = _csignals_T_23 ? 2'h0 : _csignals_T_440; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_442 = _csignals_T_21 ? 2'h0 : _csignals_T_441; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_443 = _csignals_T_19 ? 2'h0 : _csignals_T_442; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_444 = _csignals_T_17 ? 2'h0 : _csignals_T_443; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_445 = _csignals_T_15 ? 2'h1 : _csignals_T_444; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_446 = _csignals_T_13 ? 2'h0 : _csignals_T_445; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_447 = _csignals_T_11 ? 2'h1 : _csignals_T_446; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_448 = _csignals_T_9 ? 2'h0 : _csignals_T_447; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_449 = _csignals_T_7 ? 2'h0 : _csignals_T_448; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_450 = _csignals_T_5 ? 2'h1 : _csignals_T_449; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_451 = _csignals_T_3 ? 2'h0 : _csignals_T_450; // @[Lookup.scala 34:39]
  wire [1:0] csignals_3 = _csignals_T_1 ? 2'h0 : _csignals_T_451; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_452 = _csignals_T_151 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_453 = _csignals_T_149 ? 2'h1 : _csignals_T_452; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_454 = _csignals_T_147 ? 2'h0 : _csignals_T_453; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_455 = _csignals_T_145 ? 2'h1 : _csignals_T_454; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_456 = _csignals_T_143 ? 2'h1 : _csignals_T_455; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_457 = _csignals_T_141 ? 2'h1 : _csignals_T_456; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_458 = _csignals_T_139 ? 2'h1 : _csignals_T_457; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_459 = _csignals_T_137 ? 2'h0 : _csignals_T_458; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_460 = _csignals_T_135 ? 2'h0 : _csignals_T_459; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_461 = _csignals_T_133 ? 2'h1 : _csignals_T_460; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_462 = _csignals_T_131 ? 2'h1 : _csignals_T_461; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_463 = _csignals_T_129 ? 2'h1 : _csignals_T_462; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_464 = _csignals_T_127 ? 2'h1 : _csignals_T_463; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_465 = _csignals_T_125 ? 2'h1 : _csignals_T_464; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_466 = _csignals_T_123 ? 2'h1 : _csignals_T_465; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_467 = _csignals_T_121 ? 2'h1 : _csignals_T_466; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_468 = _csignals_T_119 ? 2'h1 : _csignals_T_467; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_469 = _csignals_T_117 ? 2'h1 : _csignals_T_468; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_470 = _csignals_T_115 ? 2'h1 : _csignals_T_469; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_471 = _csignals_T_113 ? 2'h1 : _csignals_T_470; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_472 = _csignals_T_111 ? 2'h0 : _csignals_T_471; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_473 = _csignals_T_109 ? 2'h1 : _csignals_T_472; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_474 = _csignals_T_107 ? 2'h1 : _csignals_T_473; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_475 = _csignals_T_105 ? 2'h1 : _csignals_T_474; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_476 = _csignals_T_103 ? 2'h1 : _csignals_T_475; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_477 = _csignals_T_101 ? 2'h0 : _csignals_T_476; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_478 = _csignals_T_99 ? 2'h1 : _csignals_T_477; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_479 = _csignals_T_97 ? 2'h1 : _csignals_T_478; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_480 = _csignals_T_95 ? 2'h1 : _csignals_T_479; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_481 = _csignals_T_93 ? 2'h1 : _csignals_T_480; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_482 = _csignals_T_91 ? 2'h0 : _csignals_T_481; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_483 = _csignals_T_89 ? 2'h0 : _csignals_T_482; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_484 = _csignals_T_87 ? 2'h0 : _csignals_T_483; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_485 = _csignals_T_85 ? 2'h1 : _csignals_T_484; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_486 = _csignals_T_83 ? 2'h1 : _csignals_T_485; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_487 = _csignals_T_81 ? 2'h1 : _csignals_T_486; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_488 = _csignals_T_79 ? 2'h1 : _csignals_T_487; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_489 = _csignals_T_77 ? 2'h1 : _csignals_T_488; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_490 = _csignals_T_75 ? 2'h1 : _csignals_T_489; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_491 = _csignals_T_73 ? 2'h1 : _csignals_T_490; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_492 = _csignals_T_71 ? 2'h1 : _csignals_T_491; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_493 = _csignals_T_69 ? 2'h1 : _csignals_T_492; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_494 = _csignals_T_67 ? 2'h1 : _csignals_T_493; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_495 = _csignals_T_65 ? 2'h0 : _csignals_T_494; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_496 = _csignals_T_63 ? 2'h0 : _csignals_T_495; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_497 = _csignals_T_61 ? 2'h0 : _csignals_T_496; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_498 = _csignals_T_59 ? 2'h0 : _csignals_T_497; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_499 = _csignals_T_57 ? 2'h0 : _csignals_T_498; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_500 = _csignals_T_55 ? 2'h0 : _csignals_T_499; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_501 = _csignals_T_53 ? 2'h1 : _csignals_T_500; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_502 = _csignals_T_51 ? 2'h1 : _csignals_T_501; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_503 = _csignals_T_49 ? 2'h1 : _csignals_T_502; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_504 = _csignals_T_47 ? 2'h1 : _csignals_T_503; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_505 = _csignals_T_45 ? 2'h1 : _csignals_T_504; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_506 = _csignals_T_43 ? 2'h1 : _csignals_T_505; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_507 = _csignals_T_41 ? 2'h1 : _csignals_T_506; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_508 = _csignals_T_39 ? 2'h1 : _csignals_T_507; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_509 = _csignals_T_37 ? 2'h1 : _csignals_T_508; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_510 = _csignals_T_35 ? 2'h1 : _csignals_T_509; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_511 = _csignals_T_33 ? 2'h1 : _csignals_T_510; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_512 = _csignals_T_31 ? 2'h1 : _csignals_T_511; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_513 = _csignals_T_29 ? 2'h1 : _csignals_T_512; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_514 = _csignals_T_27 ? 2'h1 : _csignals_T_513; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_515 = _csignals_T_25 ? 2'h1 : _csignals_T_514; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_516 = _csignals_T_23 ? 2'h1 : _csignals_T_515; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_517 = _csignals_T_21 ? 2'h1 : _csignals_T_516; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_518 = _csignals_T_19 ? 2'h1 : _csignals_T_517; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_519 = _csignals_T_17 ? 2'h1 : _csignals_T_518; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_520 = _csignals_T_15 ? 2'h0 : _csignals_T_519; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_521 = _csignals_T_13 ? 2'h1 : _csignals_T_520; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_522 = _csignals_T_11 ? 2'h0 : _csignals_T_521; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_523 = _csignals_T_9 ? 2'h1 : _csignals_T_522; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_524 = _csignals_T_7 ? 2'h1 : _csignals_T_523; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_525 = _csignals_T_5 ? 2'h0 : _csignals_T_524; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_526 = _csignals_T_3 ? 2'h1 : _csignals_T_525; // @[Lookup.scala 34:39]
  wire [1:0] csignals_4 = _csignals_T_1 ? 2'h1 : _csignals_T_526; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_530 = _csignals_T_145 ? 3'h5 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_531 = _csignals_T_143 ? 3'h4 : _csignals_T_530; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_532 = _csignals_T_141 ? 3'h4 : _csignals_T_531; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_533 = _csignals_T_139 ? 3'h0 : _csignals_T_532; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_534 = _csignals_T_137 ? 3'h0 : _csignals_T_533; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_535 = _csignals_T_135 ? 3'h0 : _csignals_T_534; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_536 = _csignals_T_133 ? 3'h0 : _csignals_T_535; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_537 = _csignals_T_131 ? 3'h0 : _csignals_T_536; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_538 = _csignals_T_129 ? 3'h0 : _csignals_T_537; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_539 = _csignals_T_127 ? 3'h0 : _csignals_T_538; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_540 = _csignals_T_125 ? 3'h0 : _csignals_T_539; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_541 = _csignals_T_123 ? 3'h0 : _csignals_T_540; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_542 = _csignals_T_121 ? 3'h0 : _csignals_T_541; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_543 = _csignals_T_119 ? 3'h0 : _csignals_T_542; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_544 = _csignals_T_117 ? 3'h0 : _csignals_T_543; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_545 = _csignals_T_115 ? 3'h0 : _csignals_T_544; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_546 = _csignals_T_113 ? 3'h0 : _csignals_T_545; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_547 = _csignals_T_111 ? 3'h0 : _csignals_T_546; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_548 = _csignals_T_109 ? 3'h5 : _csignals_T_547; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_549 = _csignals_T_107 ? 3'h0 : _csignals_T_548; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_550 = _csignals_T_105 ? 3'h0 : _csignals_T_549; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_551 = _csignals_T_103 ? 3'h0 : _csignals_T_550; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_552 = _csignals_T_101 ? 3'h0 : _csignals_T_551; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_553 = _csignals_T_99 ? 3'h6 : _csignals_T_552; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_554 = _csignals_T_97 ? 3'h6 : _csignals_T_553; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_555 = _csignals_T_95 ? 3'h6 : _csignals_T_554; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_556 = _csignals_T_93 ? 3'h6 : _csignals_T_555; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_557 = _csignals_T_91 ? 3'h0 : _csignals_T_556; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_558 = _csignals_T_89 ? 3'h0 : _csignals_T_557; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_559 = _csignals_T_87 ? 3'h0 : _csignals_T_558; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_560 = _csignals_T_85 ? 3'h7 : _csignals_T_559; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_561 = _csignals_T_83 ? 3'h7 : _csignals_T_560; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_562 = _csignals_T_81 ? 3'h7 : _csignals_T_561; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_563 = _csignals_T_79 ? 3'h7 : _csignals_T_562; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_564 = _csignals_T_77 ? 3'h7 : _csignals_T_563; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_565 = _csignals_T_75 ? 3'h7 : _csignals_T_564; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_566 = _csignals_T_73 ? 3'h0 : _csignals_T_565; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_567 = _csignals_T_71 ? 3'h0 : _csignals_T_566; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_568 = _csignals_T_69 ? 3'h4 : _csignals_T_567; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_569 = _csignals_T_67 ? 3'h4 : _csignals_T_568; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_570 = _csignals_T_65 ? 3'h0 : _csignals_T_569; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_571 = _csignals_T_63 ? 3'h0 : _csignals_T_570; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_572 = _csignals_T_61 ? 3'h0 : _csignals_T_571; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_573 = _csignals_T_59 ? 3'h0 : _csignals_T_572; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_574 = _csignals_T_57 ? 3'h0 : _csignals_T_573; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_575 = _csignals_T_55 ? 3'h0 : _csignals_T_574; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_576 = _csignals_T_53 ? 3'h0 : _csignals_T_575; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_577 = _csignals_T_51 ? 3'h0 : _csignals_T_576; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_578 = _csignals_T_49 ? 3'h0 : _csignals_T_577; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_579 = _csignals_T_47 ? 3'h0 : _csignals_T_578; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_580 = _csignals_T_45 ? 3'h0 : _csignals_T_579; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_581 = _csignals_T_43 ? 3'h0 : _csignals_T_580; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_582 = _csignals_T_41 ? 3'h0 : _csignals_T_581; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_583 = _csignals_T_39 ? 3'h0 : _csignals_T_582; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_584 = _csignals_T_37 ? 3'h0 : _csignals_T_583; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_585 = _csignals_T_35 ? 3'h0 : _csignals_T_584; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_586 = _csignals_T_33 ? 3'h0 : _csignals_T_585; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_587 = _csignals_T_31 ? 3'h0 : _csignals_T_586; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_588 = _csignals_T_29 ? 3'h0 : _csignals_T_587; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_589 = _csignals_T_27 ? 3'h0 : _csignals_T_588; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_590 = _csignals_T_25 ? 3'h0 : _csignals_T_589; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_591 = _csignals_T_23 ? 3'h0 : _csignals_T_590; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_592 = _csignals_T_21 ? 3'h0 : _csignals_T_591; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_593 = _csignals_T_19 ? 3'h0 : _csignals_T_592; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_594 = _csignals_T_17 ? 3'h0 : _csignals_T_593; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_595 = _csignals_T_15 ? 3'h0 : _csignals_T_594; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_596 = _csignals_T_13 ? 3'h5 : _csignals_T_595; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_597 = _csignals_T_11 ? 3'h0 : _csignals_T_596; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_598 = _csignals_T_9 ? 3'h5 : _csignals_T_597; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_599 = _csignals_T_7 ? 3'h5 : _csignals_T_598; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_600 = _csignals_T_5 ? 3'h0 : _csignals_T_599; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_601 = _csignals_T_3 ? 3'h5 : _csignals_T_600; // @[Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h5 : _csignals_T_601; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_602 = _csignals_T_151 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_603 = _csignals_T_149 ? 3'h1 : _csignals_T_602; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_604 = _csignals_T_147 ? 3'h1 : _csignals_T_603; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_605 = _csignals_T_145 ? 3'h1 : _csignals_T_604; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_606 = _csignals_T_143 ? 3'h4 : _csignals_T_605; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_607 = _csignals_T_141 ? 3'h4 : _csignals_T_606; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_608 = _csignals_T_139 ? 3'h1 : _csignals_T_607; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_609 = _csignals_T_137 ? 3'h1 : _csignals_T_608; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_610 = _csignals_T_135 ? 3'h1 : _csignals_T_609; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_611 = _csignals_T_133 ? 3'h1 : _csignals_T_610; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_612 = _csignals_T_131 ? 3'h1 : _csignals_T_611; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_613 = _csignals_T_129 ? 3'h2 : _csignals_T_612; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_614 = _csignals_T_127 ? 3'h2 : _csignals_T_613; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_615 = _csignals_T_125 ? 3'h2 : _csignals_T_614; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_616 = _csignals_T_123 ? 3'h2 : _csignals_T_615; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_617 = _csignals_T_121 ? 3'h2 : _csignals_T_616; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_618 = _csignals_T_119 ? 3'h2 : _csignals_T_617; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_619 = _csignals_T_117 ? 3'h2 : _csignals_T_618; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_620 = _csignals_T_115 ? 3'h1 : _csignals_T_619; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_621 = _csignals_T_113 ? 3'h1 : _csignals_T_620; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_622 = _csignals_T_111 ? 3'h1 : _csignals_T_621; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_623 = _csignals_T_109 ? 3'h3 : _csignals_T_622; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_624 = _csignals_T_107 ? 3'h1 : _csignals_T_623; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_625 = _csignals_T_105 ? 3'h1 : _csignals_T_624; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_626 = _csignals_T_103 ? 3'h3 : _csignals_T_625; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_627 = _csignals_T_101 ? 3'h1 : _csignals_T_626; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_628 = _csignals_T_99 ? 3'h0 : _csignals_T_627; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_629 = _csignals_T_97 ? 3'h0 : _csignals_T_628; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_630 = _csignals_T_95 ? 3'h0 : _csignals_T_629; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_631 = _csignals_T_93 ? 3'h0 : _csignals_T_630; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_632 = _csignals_T_91 ? 3'h0 : _csignals_T_631; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_633 = _csignals_T_89 ? 3'h0 : _csignals_T_632; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_634 = _csignals_T_87 ? 3'h0 : _csignals_T_633; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_635 = _csignals_T_85 ? 3'h0 : _csignals_T_634; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_636 = _csignals_T_83 ? 3'h0 : _csignals_T_635; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_637 = _csignals_T_81 ? 3'h0 : _csignals_T_636; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_638 = _csignals_T_79 ? 3'h0 : _csignals_T_637; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_639 = _csignals_T_77 ? 3'h0 : _csignals_T_638; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_640 = _csignals_T_75 ? 3'h0 : _csignals_T_639; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_641 = _csignals_T_73 ? 3'h0 : _csignals_T_640; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_642 = _csignals_T_71 ? 3'h0 : _csignals_T_641; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_643 = _csignals_T_69 ? 3'h0 : _csignals_T_642; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_644 = _csignals_T_67 ? 3'h0 : _csignals_T_643; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_645 = _csignals_T_65 ? 3'h0 : _csignals_T_644; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_646 = _csignals_T_63 ? 3'h0 : _csignals_T_645; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_647 = _csignals_T_61 ? 3'h0 : _csignals_T_646; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_648 = _csignals_T_59 ? 3'h0 : _csignals_T_647; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_649 = _csignals_T_57 ? 3'h0 : _csignals_T_648; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_650 = _csignals_T_55 ? 3'h0 : _csignals_T_649; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_651 = _csignals_T_53 ? 3'h0 : _csignals_T_650; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_652 = _csignals_T_51 ? 3'h0 : _csignals_T_651; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_653 = _csignals_T_49 ? 3'h0 : _csignals_T_652; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_654 = _csignals_T_47 ? 3'h0 : _csignals_T_653; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_655 = _csignals_T_45 ? 3'h0 : _csignals_T_654; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_656 = _csignals_T_43 ? 3'h0 : _csignals_T_655; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_657 = _csignals_T_41 ? 3'h0 : _csignals_T_656; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_658 = _csignals_T_39 ? 3'h0 : _csignals_T_657; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_659 = _csignals_T_37 ? 3'h0 : _csignals_T_658; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_660 = _csignals_T_35 ? 3'h0 : _csignals_T_659; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_661 = _csignals_T_33 ? 3'h0 : _csignals_T_660; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_662 = _csignals_T_31 ? 3'h0 : _csignals_T_661; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_663 = _csignals_T_29 ? 3'h0 : _csignals_T_662; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_664 = _csignals_T_27 ? 3'h0 : _csignals_T_663; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_665 = _csignals_T_25 ? 3'h0 : _csignals_T_664; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_666 = _csignals_T_23 ? 3'h0 : _csignals_T_665; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_667 = _csignals_T_21 ? 3'h0 : _csignals_T_666; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_19 ? 3'h0 : _csignals_T_667; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_17 ? 3'h0 : _csignals_T_668; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_15 ? 3'h0 : _csignals_T_669; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_13 ? 3'h0 : _csignals_T_670; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_11 ? 3'h0 : _csignals_T_671; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_9 ? 3'h0 : _csignals_T_672; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_7 ? 3'h0 : _csignals_T_673; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_5 ? 3'h0 : _csignals_T_674; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_3 ? 3'h0 : _csignals_T_675; // @[Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_676; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_89 ? 3'h6 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_87 ? 3'h4 : _csignals_T_708; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_85 ? 3'h3 : _csignals_T_709; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_83 ? 3'h3 : _csignals_T_710; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_712 = _csignals_T_81 ? 3'h2 : _csignals_T_711; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_713 = _csignals_T_79 ? 3'h2 : _csignals_T_712; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_77 ? 3'h1 : _csignals_T_713; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_75 ? 3'h1 : _csignals_T_714; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_73 ? 3'h0 : _csignals_T_715; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_71 ? 3'h0 : _csignals_T_716; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_69 ? 3'h0 : _csignals_T_717; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_67 ? 3'h0 : _csignals_T_718; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_65 ? 3'h0 : _csignals_T_719; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_63 ? 3'h0 : _csignals_T_720; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_61 ? 3'h0 : _csignals_T_721; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_59 ? 3'h0 : _csignals_T_722; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_57 ? 3'h0 : _csignals_T_723; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_55 ? 3'h0 : _csignals_T_724; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_53 ? 3'h0 : _csignals_T_725; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_51 ? 3'h0 : _csignals_T_726; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_49 ? 3'h0 : _csignals_T_727; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_47 ? 3'h0 : _csignals_T_728; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_45 ? 3'h0 : _csignals_T_729; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_43 ? 3'h0 : _csignals_T_730; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_41 ? 3'h0 : _csignals_T_731; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_39 ? 3'h0 : _csignals_T_732; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_37 ? 3'h0 : _csignals_T_733; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_35 ? 3'h0 : _csignals_T_734; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_33 ? 3'h0 : _csignals_T_735; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_31 ? 3'h0 : _csignals_T_736; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_29 ? 3'h0 : _csignals_T_737; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_27 ? 3'h0 : _csignals_T_738; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_740 = _csignals_T_25 ? 3'h0 : _csignals_T_739; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_741 = _csignals_T_23 ? 3'h0 : _csignals_T_740; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_742 = _csignals_T_21 ? 3'h0 : _csignals_T_741; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_743 = _csignals_T_19 ? 3'h0 : _csignals_T_742; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_744 = _csignals_T_17 ? 3'h0 : _csignals_T_743; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_745 = _csignals_T_15 ? 3'h0 : _csignals_T_744; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_746 = _csignals_T_13 ? 3'h0 : _csignals_T_745; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_747 = _csignals_T_11 ? 3'h0 : _csignals_T_746; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_748 = _csignals_T_9 ? 3'h0 : _csignals_T_747; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_749 = _csignals_T_7 ? 3'h0 : _csignals_T_748; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_750 = _csignals_T_5 ? 3'h0 : _csignals_T_749; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_751 = _csignals_T_3 ? 3'h0 : _csignals_T_750; // @[Lookup.scala 34:39]
  wire [2:0] csignals_7 = _csignals_T_1 ? 3'h0 : _csignals_T_751; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_754 = _csignals_T_147 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_755 = _csignals_T_145 ? 3'h1 : _csignals_T_754; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_756 = _csignals_T_143 ? 3'h0 : _csignals_T_755; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_757 = _csignals_T_141 ? 3'h0 : _csignals_T_756; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_758 = _csignals_T_139 ? 3'h0 : _csignals_T_757; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_759 = _csignals_T_137 ? 3'h0 : _csignals_T_758; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_760 = _csignals_T_135 ? 3'h0 : _csignals_T_759; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_761 = _csignals_T_133 ? 3'h0 : _csignals_T_760; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_762 = _csignals_T_131 ? 3'h0 : _csignals_T_761; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_763 = _csignals_T_129 ? 3'h0 : _csignals_T_762; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_764 = _csignals_T_127 ? 3'h0 : _csignals_T_763; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_765 = _csignals_T_125 ? 3'h0 : _csignals_T_764; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_766 = _csignals_T_123 ? 3'h0 : _csignals_T_765; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_767 = _csignals_T_121 ? 3'h0 : _csignals_T_766; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_768 = _csignals_T_119 ? 3'h0 : _csignals_T_767; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_769 = _csignals_T_117 ? 3'h0 : _csignals_T_768; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_770 = _csignals_T_115 ? 3'h0 : _csignals_T_769; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_771 = _csignals_T_113 ? 3'h0 : _csignals_T_770; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_772 = _csignals_T_111 ? 3'h1 : _csignals_T_771; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_773 = _csignals_T_109 ? 3'h1 : _csignals_T_772; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_774 = _csignals_T_107 ? 3'h0 : _csignals_T_773; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_775 = _csignals_T_105 ? 3'h0 : _csignals_T_774; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_776 = _csignals_T_103 ? 3'h0 : _csignals_T_775; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_777 = _csignals_T_101 ? 3'h0 : _csignals_T_776; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_778 = _csignals_T_99 ? 3'h0 : _csignals_T_777; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_779 = _csignals_T_97 ? 3'h0 : _csignals_T_778; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_780 = _csignals_T_95 ? 3'h0 : _csignals_T_779; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_781 = _csignals_T_93 ? 3'h0 : _csignals_T_780; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_782 = _csignals_T_91 ? 3'h0 : _csignals_T_781; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_783 = _csignals_T_89 ? 3'h0 : _csignals_T_782; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_784 = _csignals_T_87 ? 3'h0 : _csignals_T_783; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_785 = _csignals_T_85 ? 3'h0 : _csignals_T_784; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_786 = _csignals_T_83 ? 3'h0 : _csignals_T_785; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_787 = _csignals_T_81 ? 3'h0 : _csignals_T_786; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_788 = _csignals_T_79 ? 3'h0 : _csignals_T_787; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_789 = _csignals_T_77 ? 3'h0 : _csignals_T_788; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_790 = _csignals_T_75 ? 3'h0 : _csignals_T_789; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_791 = _csignals_T_73 ? 3'h0 : _csignals_T_790; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_792 = _csignals_T_71 ? 3'h0 : _csignals_T_791; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_793 = _csignals_T_69 ? 3'h0 : _csignals_T_792; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_794 = _csignals_T_67 ? 3'h0 : _csignals_T_793; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_795 = _csignals_T_65 ? 3'h0 : _csignals_T_794; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_796 = _csignals_T_63 ? 3'h0 : _csignals_T_795; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_797 = _csignals_T_61 ? 3'h0 : _csignals_T_796; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_798 = _csignals_T_59 ? 3'h0 : _csignals_T_797; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_799 = _csignals_T_57 ? 3'h0 : _csignals_T_798; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_800 = _csignals_T_55 ? 3'h0 : _csignals_T_799; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_801 = _csignals_T_53 ? 3'h0 : _csignals_T_800; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_802 = _csignals_T_51 ? 3'h0 : _csignals_T_801; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_803 = _csignals_T_49 ? 3'h0 : _csignals_T_802; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_804 = _csignals_T_47 ? 3'h0 : _csignals_T_803; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_805 = _csignals_T_45 ? 3'h0 : _csignals_T_804; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_806 = _csignals_T_43 ? 3'h0 : _csignals_T_805; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_807 = _csignals_T_41 ? 3'h0 : _csignals_T_806; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_808 = _csignals_T_39 ? 3'h0 : _csignals_T_807; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_809 = _csignals_T_37 ? 3'h0 : _csignals_T_808; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_810 = _csignals_T_35 ? 3'h0 : _csignals_T_809; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_811 = _csignals_T_33 ? 3'h0 : _csignals_T_810; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_812 = _csignals_T_31 ? 3'h0 : _csignals_T_811; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_813 = _csignals_T_29 ? 3'h0 : _csignals_T_812; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_814 = _csignals_T_27 ? 3'h0 : _csignals_T_813; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_815 = _csignals_T_25 ? 3'h0 : _csignals_T_814; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_816 = _csignals_T_23 ? 3'h0 : _csignals_T_815; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_817 = _csignals_T_21 ? 3'h0 : _csignals_T_816; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_818 = _csignals_T_19 ? 3'h0 : _csignals_T_817; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_819 = _csignals_T_17 ? 3'h0 : _csignals_T_818; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_820 = _csignals_T_15 ? 3'h1 : _csignals_T_819; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_821 = _csignals_T_13 ? 3'h1 : _csignals_T_820; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_822 = _csignals_T_11 ? 3'h2 : _csignals_T_821; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_823 = _csignals_T_9 ? 3'h4 : _csignals_T_822; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_824 = _csignals_T_7 ? 3'h2 : _csignals_T_823; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_825 = _csignals_T_5 ? 3'h3 : _csignals_T_824; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_826 = _csignals_T_3 ? 3'h5 : _csignals_T_825; // @[Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h3 : _csignals_T_826; // @[Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 570:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 571:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 572:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 573:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h0; // @[Core.scala 577:17]
  wire  _id_op1_data_T_1 = csignals_1 == 3'h1; // @[Core.scala 578:17]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h3; // @[Core.scala 579:17]
  wire  _id_op1_data_T_3 = csignals_1 == 3'h4; // @[Core.scala 580:17]
  wire  _id_op1_data_T_4 = csignals_1 == 3'h5; // @[Core.scala 581:17]
  wire  _id_op1_data_T_5 = csignals_1 == 3'h6; // @[Core.scala 582:17]
  wire [31:0] _id_op1_data_T_6 = _id_op1_data_T_5 ? regfile_id_c_rs1p_data_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_7 = _id_op1_data_T_4 ? regfile_id_sp_data_data : _id_op1_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_8 = _id_op1_data_T_3 ? id_c_rs1_data : _id_op1_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_9 = _id_op1_data_T_2 ? id_imm_z_uext : _id_op1_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_10 = _id_op1_data_T_1 ? id_reg_pc : _id_op1_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? id_rs1_data : _id_op1_data_T_10; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 4'h1; // @[Core.scala 585:17]
  wire  _id_op2_data_T_1 = csignals_2 == 4'h2; // @[Core.scala 586:17]
  wire  _id_op2_data_T_2 = csignals_2 == 4'h3; // @[Core.scala 587:17]
  wire  _id_op2_data_T_3 = csignals_2 == 4'h4; // @[Core.scala 588:17]
  wire  _id_op2_data_T_4 = csignals_2 == 4'h5; // @[Core.scala 589:17]
  wire  _id_op2_data_T_5 = csignals_2 == 4'h6; // @[Core.scala 590:17]
  wire  _id_op2_data_T_6 = csignals_2 == 4'h7; // @[Core.scala 591:17]
  wire  _id_op2_data_T_7 = csignals_2 == 4'h8; // @[Core.scala 592:17]
  wire  _id_op2_data_T_8 = csignals_2 == 4'h9; // @[Core.scala 593:17]
  wire  _id_op2_data_T_9 = csignals_2 == 4'ha; // @[Core.scala 594:17]
  wire  _id_op2_data_T_10 = csignals_2 == 4'hb; // @[Core.scala 595:17]
  wire  _id_op2_data_T_11 = csignals_2 == 4'hc; // @[Core.scala 596:17]
  wire  _id_op2_data_T_12 = csignals_2 == 4'hd; // @[Core.scala 597:17]
  wire  _id_op2_data_T_13 = csignals_2 == 4'he; // @[Core.scala 598:17]
  wire  _id_op2_data_T_14 = csignals_2 == 4'hf; // @[Core.scala 599:17]
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
  wire  _id_csr_addr_T = csignals_7 == 3'h4; // @[Core.scala 602:36]
  wire [11:0] id_csr_addr = csignals_7 == 3'h4 ? 12'h342 : id_imm_i; // @[Core.scala 602:24]
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
  wire  id_is_j = _id_op2_data_T_3 | _id_op2_data_T_12; // @[Core.scala 632:42]
  reg [31:0] id_reg_pc_delay; // @[Core.scala 637:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 638:40]
  reg [2:0] id_reg_op1_sel_delay; // @[Core.scala 639:40]
  reg [3:0] id_reg_op2_sel_delay; // @[Core.scala 640:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 641:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 642:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 643:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 644:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 646:40]
  reg [1:0] id_reg_mem_wen_delay; // @[Core.scala 647:40]
  reg [1:0] id_reg_rf_wen_delay; // @[Core.scala 648:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 649:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 650:40]
  reg [2:0] id_reg_csr_cmd_delay; // @[Core.scala 651:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 654:40]
  reg [31:0] id_reg_mem_w_delay; // @[Core.scala 657:40]
  reg  id_reg_is_j_delay; // @[Core.scala 658:40]
  reg  id_reg_is_bp_pos_delay; // @[Core.scala 659:40]
  reg [31:0] id_reg_bp_addr_delay; // @[Core.scala 660:40]
  reg  id_reg_is_half_delay; // @[Core.scala 661:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 662:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 663:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 664:40]
  wire [31:0] _GEN_90 = _ic_read_en4_T ? id_reg_pc : id_reg_pc_delay; // @[Core.scala 668:26 669:32 637:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 707:43]
  wire [31:0] _GEN_141 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 716:24 717:29 743:29]
  wire [2:0] _GEN_142 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 716:24 718:29 744:29]
  wire [3:0] _GEN_143 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 716:24 719:29 745:29]
  wire [4:0] _GEN_144 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 716:24 720:29 746:29]
  wire [4:0] _GEN_145 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 716:24 721:29 747:29]
  wire [31:0] _GEN_146 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 716:24 722:29 748:29]
  wire [31:0] _GEN_147 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[Core.scala 716:24 723:29 749:29]
  wire [4:0] _GEN_149 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 716:24 725:29 751:29]
  wire [31:0] _GEN_153 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 716:24 729:29 755:29]
  wire [11:0] _GEN_154 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 716:24 730:29 756:29]
  wire [31:0] _GEN_156 = id_reg_stall ? id_reg_bp_addr_delay : id_reg_bp_addr; // @[Core.scala 716:24 736:29 762:29]
  wire  _GEN_157 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 716:24 737:29 763:29]
  wire [31:0] _GEN_158 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 716:24 740:29 766:29]
  wire  _T_29 = ~ex1_stall; // @[Core.scala 769:14]
  wire  _T_30 = ~mem_stall; // @[Core.scala 769:28]
  reg  ex1_reg_fw_en; // @[Core.scala 836:38]
  reg  ex2_reg_fw_en; // @[Core.scala 839:38]
  reg [31:0] ex2_reg_fw_data; // @[Core.scala 841:38]
  reg [1:0] mem_reg_rf_wen_delay; // @[Core.scala 842:38]
  reg [31:0] mem_reg_wb_data_delay; // @[Core.scala 844:38]
  reg [1:0] wb_reg_rf_wen_delay; // @[Core.scala 845:38]
  reg [4:0] wb_reg_wb_addr_delay; // @[Core.scala 846:38]
  reg [31:0] wb_reg_wb_data_delay; // @[Core.scala 847:38]
  wire  _ex1_op1_data_T_2 = _ex1_stall_T & ex1_reg_rs1_addr == 5'h0; // @[Core.scala 864:34]
  wire  _ex1_op1_data_T_4 = ex1_reg_fw_en & _ex1_stall_T; // @[Core.scala 865:20]
  wire  _ex1_op1_data_T_6 = _ex1_op1_data_T_4 & _ex1_stall_T_2; // @[Core.scala 866:36]
  wire  _ex1_op1_data_T_8 = ex2_reg_fw_en & _ex1_stall_T; // @[Core.scala 868:20]
  wire  _ex1_op1_data_T_10 = _ex1_op1_data_T_8 & _ex1_stall_T_6; // @[Core.scala 869:36]
  wire  _ex1_op1_data_T_11 = mem_reg_rf_wen_delay == 2'h1; // @[Core.scala 871:28]
  wire  _ex1_op1_data_T_13 = mem_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 871:39]
  wire  _ex1_op1_data_T_14 = ex1_reg_rs1_addr == wb_reg_wb_addr; // @[Core.scala 873:24]
  wire  _ex1_op1_data_T_15 = _ex1_op1_data_T_13 & _ex1_op1_data_T_14; // @[Core.scala 872:36]
  wire  _ex1_op1_data_T_16 = wb_reg_rf_wen_delay == 2'h1; // @[Core.scala 874:27]
  wire  _ex1_op1_data_T_18 = wb_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 874:38]
  wire  _ex1_op1_data_T_19 = ex1_reg_rs1_addr == wb_reg_wb_addr_delay; // @[Core.scala 876:24]
  wire  _ex1_op1_data_T_20 = _ex1_op1_data_T_18 & _ex1_op1_data_T_19; // @[Core.scala 875:36]
  wire [31:0] _ex1_op1_data_T_22 = _ex1_stall_T ? regfile_ex1_op1_data_MPORT_data : ex1_reg_op1_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_23 = _ex1_op1_data_T_20 ? wb_reg_wb_data_delay : _ex1_op1_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_24 = _ex1_op1_data_T_15 ? mem_reg_wb_data_delay : _ex1_op1_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_25 = _ex1_op1_data_T_10 ? ex2_reg_fw_data : _ex1_op1_data_T_24; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex2_reg_wb_sel == 3'h4; // @[Core.scala 992:21]
  wire [31:0] _ex1_fw_data_T_2 = ex2_reg_pc + 32'h2; // @[Core.scala 993:18]
  wire [31:0] _ex1_fw_data_T_4 = ex2_reg_pc + 32'h4; // @[Core.scala 994:18]
  wire [31:0] _ex1_fw_data_T_5 = ex2_reg_is_half ? _ex1_fw_data_T_2 : _ex1_fw_data_T_4; // @[Core.scala 992:38]
  wire  _ex2_alu_out_T = ex2_reg_exe_fun == 5'h1; // @[Core.scala 950:22]
  wire [31:0] _ex2_alu_out_T_2 = ex2_reg_op1_data + ex2_reg_op2_data; // @[Core.scala 950:58]
  wire  _ex2_alu_out_T_3 = ex2_reg_exe_fun == 5'h2; // @[Core.scala 951:22]
  wire [31:0] _ex2_alu_out_T_5 = ex2_reg_op1_data - ex2_reg_op2_data; // @[Core.scala 951:58]
  wire  _ex2_alu_out_T_6 = ex2_reg_exe_fun == 5'h3; // @[Core.scala 952:22]
  wire [31:0] _ex2_alu_out_T_7 = ex2_reg_op1_data & ex2_reg_op2_data; // @[Core.scala 952:58]
  wire  _ex2_alu_out_T_8 = ex2_reg_exe_fun == 5'h4; // @[Core.scala 953:22]
  wire [31:0] _ex2_alu_out_T_9 = ex2_reg_op1_data | ex2_reg_op2_data; // @[Core.scala 953:58]
  wire  _ex2_alu_out_T_10 = ex2_reg_exe_fun == 5'h5; // @[Core.scala 954:22]
  wire [31:0] _ex2_alu_out_T_11 = ex2_reg_op1_data ^ ex2_reg_op2_data; // @[Core.scala 954:58]
  wire  _ex2_alu_out_T_12 = ex2_reg_exe_fun == 5'h6; // @[Core.scala 955:22]
  wire [62:0] _GEN_26 = {{31'd0}, ex2_reg_op1_data}; // @[Core.scala 955:58]
  wire [62:0] _ex2_alu_out_T_14 = _GEN_26 << ex2_reg_op2_data[4:0]; // @[Core.scala 955:58]
  wire  _ex2_alu_out_T_16 = ex2_reg_exe_fun == 5'h7; // @[Core.scala 956:22]
  wire [31:0] _ex2_alu_out_T_18 = ex2_reg_op1_data >> ex2_reg_op2_data[4:0]; // @[Core.scala 956:58]
  wire  _ex2_alu_out_T_19 = ex2_reg_exe_fun == 5'h8; // @[Core.scala 957:22]
  wire [31:0] _ex2_alu_out_T_23 = $signed(ex2_reg_op1_data) >>> ex2_reg_op2_data[4:0]; // @[Core.scala 957:100]
  wire  _ex2_alu_out_T_24 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 958:22]
  wire  _ex2_alu_out_T_27 = $signed(ex2_reg_op1_data) < $signed(ex2_reg_op2_data); // @[Core.scala 958:67]
  wire  _ex2_alu_out_T_28 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 959:22]
  wire  _ex2_alu_out_T_29 = ex2_reg_op1_data < ex2_reg_op2_data; // @[Core.scala 959:58]
  wire  _ex2_alu_out_T_30 = ex2_reg_exe_fun == 5'h11; // @[Core.scala 960:22]
  wire [31:0] _ex2_alu_out_T_34 = _ex2_alu_out_T_2 & 32'hfffffffe; // @[Core.scala 960:79]
  wire  _ex2_alu_out_T_35 = ex2_reg_exe_fun == 5'h12; // @[Core.scala 961:22]
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
  wire  _ex1_op2_data_T_1 = ex1_reg_rs2_addr == 5'h0; // @[Core.scala 880:54]
  wire  _ex1_op2_data_T_2 = _ex1_stall_T_9 & ex1_reg_rs2_addr == 5'h0; // @[Core.scala 880:34]
  wire  _ex1_op2_data_T_4 = ex1_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 881:20]
  wire  _ex1_op2_data_T_6 = _ex1_op2_data_T_4 & _ex1_stall_T_13; // @[Core.scala 882:36]
  wire  _ex1_op2_data_T_8 = ex2_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 884:20]
  wire  _ex1_op2_data_T_10 = _ex1_op2_data_T_8 & _ex1_stall_T_20; // @[Core.scala 885:36]
  wire  _ex1_op2_data_T_13 = _ex1_op1_data_T_11 & _ex1_stall_T_9; // @[Core.scala 887:39]
  wire  _ex1_op2_data_T_14 = ex1_reg_rs2_addr == wb_reg_wb_addr; // @[Core.scala 889:24]
  wire  _ex1_op2_data_T_15 = _ex1_op2_data_T_13 & _ex1_op2_data_T_14; // @[Core.scala 888:36]
  wire  _ex1_op2_data_T_18 = _ex1_op1_data_T_16 & _ex1_stall_T_9; // @[Core.scala 890:38]
  wire  _ex1_op2_data_T_19 = ex1_reg_rs2_addr == wb_reg_wb_addr_delay; // @[Core.scala 892:24]
  wire  _ex1_op2_data_T_20 = _ex1_op2_data_T_18 & _ex1_op2_data_T_19; // @[Core.scala 891:36]
  wire [31:0] _ex1_op2_data_T_22 = _ex1_stall_T_9 ? regfile_ex1_op2_data_MPORT_data : ex1_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_23 = _ex1_op2_data_T_20 ? wb_reg_wb_data_delay : _ex1_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_24 = _ex1_op2_data_T_15 ? mem_reg_wb_data_delay : _ex1_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_25 = _ex1_op2_data_T_10 ? ex2_reg_fw_data : _ex1_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_26 = _ex1_op2_data_T_6 ? ex1_fw_data : _ex1_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op2_data = _ex1_op2_data_T_2 ? 32'h0 : _ex1_op2_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_rs2_data_T_2 = ex1_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 897:20]
  wire  _ex1_rs2_data_T_4 = ex2_reg_fw_en & _ex1_stall_T_20; // @[Core.scala 899:20]
  wire  _ex1_rs2_data_T_7 = _ex1_op1_data_T_11 & _ex1_op2_data_T_14; // @[Core.scala 901:39]
  wire  _ex1_rs2_data_T_10 = _ex1_op1_data_T_16 & _ex1_op2_data_T_19; // @[Core.scala 903:38]
  wire [31:0] _ex1_rs2_data_T_11 = _ex1_rs2_data_T_10 ? wb_reg_wb_data_delay : regfile_ex1_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_12 = _ex1_rs2_data_T_7 ? mem_reg_wb_data_delay : _ex1_rs2_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_13 = _ex1_rs2_data_T_4 ? ex2_reg_fw_data : _ex1_rs2_data_T_12; // @[Mux.scala 101:16]
  wire  ex1_hazard = ex1_reg_rf_wen == 2'h1 & ex1_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 914:96]
  wire  ex_is_bubble = ex1_stall | mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 922:51]
  wire [47:0] ex2_mullu = ex2_reg_op1_data * ex2_reg_op2_data[15:0]; // @[Core.scala 964:38]
  wire [16:0] _ex2_mulls_T_2 = {1'b0,$signed(ex2_reg_op2_data[15:0])}; // @[Core.scala 965:47]
  wire [48:0] _ex2_mulls_T_3 = $signed(ex2_reg_op1_data) * $signed(_ex2_mulls_T_2); // @[Core.scala 965:47]
  wire [47:0] ex2_mulls = _ex2_mulls_T_3[47:0]; // @[Core.scala 965:47]
  wire [47:0] ex2_mulhuu = ex2_reg_op1_data * ex2_reg_op2_data[31:16]; // @[Core.scala 966:38]
  wire [15:0] _ex2_mulhss_T_2 = ex2_reg_op2_data[31:16]; // @[Core.scala 967:96]
  wire [47:0] ex2_mulhss = $signed(ex2_reg_op1_data) * $signed(_ex2_mulhss_T_2); // @[Core.scala 967:47]
  wire [16:0] _ex2_mulhsu_T_2 = {1'b0,$signed(ex2_reg_op2_data[31:16])}; // @[Core.scala 968:47]
  wire [48:0] _ex2_mulhsu_T_3 = $signed(ex2_reg_op1_data) * $signed(_ex2_mulhsu_T_2); // @[Core.scala 968:47]
  wire [47:0] ex2_mulhsu = _ex2_mulhsu_T_3[47:0]; // @[Core.scala 968:47]
  wire  _ex2_is_cond_br_T = ex2_reg_exe_fun == 5'hb; // @[Core.scala 972:22]
  wire  _ex2_is_cond_br_T_1 = ex2_reg_op1_data == ex2_reg_op2_data; // @[Core.scala 972:57]
  wire  _ex2_is_cond_br_T_2 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 973:22]
  wire  _ex2_is_cond_br_T_4 = ~_ex2_is_cond_br_T_1; // @[Core.scala 973:38]
  wire  _ex2_is_cond_br_T_5 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 974:22]
  wire  _ex2_is_cond_br_T_9 = ex2_reg_exe_fun == 5'he; // @[Core.scala 975:22]
  wire  _ex2_is_cond_br_T_13 = ~_ex2_alu_out_T_27; // @[Core.scala 975:38]
  wire  _ex2_is_cond_br_T_14 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 976:22]
  wire  _ex2_is_cond_br_T_16 = ex2_reg_exe_fun == 5'h10; // @[Core.scala 977:22]
  wire  _ex2_is_cond_br_T_18 = ~_ex2_alu_out_T_29; // @[Core.scala 977:38]
  wire  _ex2_is_cond_br_T_20 = _ex2_is_cond_br_T_14 ? _ex2_alu_out_T_29 : _ex2_is_cond_br_T_16 & _ex2_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_21 = _ex2_is_cond_br_T_9 ? _ex2_is_cond_br_T_13 : _ex2_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_inst_T_2 = _ex2_is_cond_br_T | _ex2_is_cond_br_T_2; // @[Core.scala 980:34]
  wire  _ex2_is_cond_br_inst_T_4 = _ex2_is_cond_br_inst_T_2 | _ex2_is_cond_br_T_5; // @[Core.scala 981:34]
  wire  _ex2_is_cond_br_inst_T_6 = _ex2_is_cond_br_inst_T_4 | _ex2_is_cond_br_T_9; // @[Core.scala 982:34]
  wire  _ex2_is_cond_br_inst_T_8 = _ex2_is_cond_br_inst_T_6 | _ex2_is_cond_br_T_14; // @[Core.scala 983:34]
  wire  ex2_is_cond_br_inst = _ex2_is_cond_br_inst_T_8 | _ex2_is_cond_br_T_16; // @[Core.scala 984:35]
  wire  ex2_is_uncond_br = _ex2_alu_out_T_30 | ex2_reg_is_j; // @[Core.scala 987:55]
  wire [31:0] ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext; // @[Core.scala 988:39]
  wire  ex2_hazard = ex2_reg_rf_wen == 2'h1 & ex2_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 999:96]
  wire  _ex3_reg_bp_en_T_3 = ex2_reg_is_valid_inst & _mem_en_T & _mem_en_T_2; // @[Core.scala 1006:71]
  wire  ex3_bp_en = ex3_reg_bp_en & _mem_en_T & _mem_en_T_2; // @[Core.scala 1022:51]
  wire  _ex3_cond_bp_fail_T = ~ex3_reg_is_bp_pos; // @[Core.scala 1024:6]
  wire  _ex3_cond_bp_fail_T_4 = ex3_reg_is_bp_pos & ex3_reg_is_cond_br & ex3_reg_bp_addr != ex3_reg_cond_br_target; // @[Core.scala 1025:46]
  wire  _ex3_cond_bp_fail_T_5 = ~ex3_reg_is_bp_pos & ex3_reg_is_cond_br | _ex3_cond_bp_fail_T_4; // @[Core.scala 1024:48]
  wire  ex3_cond_bp_fail = ex3_bp_en & _ex3_cond_bp_fail_T_5; // @[Core.scala 1023:36]
  wire  ex3_cond_nbp_fail = ex3_bp_en & ex3_reg_is_bp_pos & ex3_reg_is_cond_br_inst & ~ex3_reg_is_cond_br; // @[Core.scala 1027:85]
  wire  _ex3_uncond_bp_fail_T_3 = ex3_reg_is_bp_pos & ex3_reg_bp_addr != ex3_reg_uncond_br_target; // @[Core.scala 1030:24]
  wire  _ex3_uncond_bp_fail_T_4 = _ex3_cond_bp_fail_T | _ex3_uncond_bp_fail_T_3; // @[Core.scala 1029:24]
  wire  ex3_uncond_bp_fail = ex3_bp_en & ex3_reg_is_uncond_br & _ex3_uncond_bp_fail_T_4; // @[Core.scala 1028:64]
  wire [31:0] _ex3_reg_br_target_T_1 = ex3_reg_pc + 32'h2; // @[Core.scala 1034:59]
  wire [31:0] _ex3_reg_br_target_T_3 = ex3_reg_pc + 32'h4; // @[Core.scala 1034:89]
  wire [31:0] _bp_io_up_br_addr_T = ex3_reg_is_uncond_br ? ex3_reg_uncond_br_target : 32'h0; // @[Mux.scala 101:16]
  wire  _mem_reg_mem_wstrb_T = ex2_reg_mem_w == 32'h3; // @[Core.scala 1084:22]
  wire  _mem_reg_mem_wstrb_T_1 = ex2_reg_mem_w == 32'h2; // @[Core.scala 1085:22]
  wire [3:0] _mem_reg_mem_wstrb_T_4 = _mem_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem_reg_mem_wstrb_T_5 = _mem_reg_mem_wstrb_T ? 4'h1 : _mem_reg_mem_wstrb_T_4; // @[Mux.scala 101:16]
  wire [6:0] _GEN_33 = {{3'd0}, _mem_reg_mem_wstrb_T_5}; // @[Core.scala 1087:8]
  wire [6:0] _mem_reg_mem_wstrb_T_7 = _GEN_33 << ex2_alu_out[1:0]; // @[Core.scala 1087:8]
  wire  mem_is_trap = mem_reg_is_trap & mem_is_valid_inst & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1101:76]
  wire [2:0] mem_csr_cmd = mem_en ? mem_reg_csr_cmd : 3'h0; // @[Core.scala 1105:24]
  wire [5:0] _io_dmem_wdata_T_1 = 4'h8 * mem_reg_alu_out[1:0]; // @[Core.scala 1114:46]
  wire [94:0] _GEN_45 = {{63'd0}, mem_reg_rs2_data}; // @[Core.scala 1114:38]
  wire [94:0] _io_dmem_wdata_T_2 = _GEN_45 << _io_dmem_wdata_T_1; // @[Core.scala 1114:38]
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
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 1137:18]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 1138:18]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | mem_reg_op1_data; // @[Core.scala 1138:43]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 1139:18]
  wire [31:0] _csr_wdata_T_4 = ~mem_reg_op1_data; // @[Core.scala 1139:45]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1139:43]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? mem_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _GEN_269 = mem_reg_csr_addr == 12'h304 ? csr_wdata : csr_mie; // @[Core.scala 1151:52 1152:15 75:29]
  wire [31:0] _GEN_270 = mem_reg_csr_addr == 12'h340 ? csr_wdata : csr_mscratch; // @[Core.scala 1149:57 1150:20 74:29]
  wire [31:0] _GEN_271 = mem_reg_csr_addr == 12'h340 ? csr_mie : _GEN_269; // @[Core.scala 1149:57 75:29]
  wire [31:0] _GEN_272 = mem_reg_csr_addr == 12'h300 ? csr_wdata : csr_mstatus; // @[Core.scala 1147:56 1148:19 73:29]
  wire [31:0] _GEN_273 = mem_reg_csr_addr == 12'h300 ? csr_mscratch : _GEN_270; // @[Core.scala 1147:56 74:29]
  wire [31:0] _GEN_274 = mem_reg_csr_addr == 12'h300 ? csr_mie : _GEN_271; // @[Core.scala 1147:56 75:29]
  wire [31:0] _GEN_275 = mem_reg_csr_addr == 12'h341 ? csr_wdata : csr_mepc; // @[Core.scala 1145:53 1146:16 72:29]
  wire [31:0] _GEN_276 = mem_reg_csr_addr == 12'h341 ? csr_mstatus : _GEN_272; // @[Core.scala 1145:53 73:29]
  wire [31:0] _GEN_280 = mem_reg_csr_addr == 12'h305 ? csr_mepc : _GEN_275; // @[Core.scala 1143:48 72:29]
  wire [31:0] _GEN_281 = mem_reg_csr_addr == 12'h305 ? csr_mstatus : _GEN_276; // @[Core.scala 1143:48 73:29]
  wire [31:0] _GEN_285 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_280 : csr_mepc; // @[Core.scala 1142:82 72:29]
  wire [31:0] _GEN_286 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_281 : csr_mstatus; // @[Core.scala 1142:82 73:29]
  wire [31:0] _csr_mip_T_3 = {csr_mip[31:12],io_intr,csr_mip[10:8],mtimer_io_intr,csr_mip[6:0]}; // @[Cat.scala 31:58]
  wire [31:0] _csr_mstatus_T_4 = {csr_mstatus[31:8],csr_mstatus[3],csr_mstatus[6:4],1'h0,csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire  _T_46 = mem_csr_cmd == 3'h6; // @[Core.scala 1194:27]
  wire [31:0] _csr_mstatus_T_19 = {csr_mstatus[31:8],1'h1,csr_mstatus[6:4],csr_mstatus[7],csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_289 = mem_csr_cmd == 3'h6 ? _csr_mstatus_T_19 : _GEN_286; // @[Core.scala 1194:38 1195:21]
  wire [31:0] _GEN_291 = mem_csr_cmd == 3'h6 ? csr_mepc : mem_reg_br_addr; // @[Core.scala 1194:38 1197:21 205:35]
  wire  _GEN_296 = mem_is_trap | _T_46; // @[Core.scala 1182:28 1192:21]
  wire  _GEN_302 = mem_is_mtintr | _GEN_296; // @[Core.scala 1170:30 1180:21]
  wire  _GEN_308 = mem_is_meintr | _GEN_302; // @[Core.scala 1158:24 1168:21]
  wire  _mem_alu_mul_out_T = mem_reg_exe_fun == 5'h16; // @[Core.scala 1210:22]
  wire [31:0] _mem_alu_mul_out_T_3 = {mem_reg_mulhuu[15:0], 16'h0}; // @[Core.scala 1210:106]
  wire [31:0] _mem_alu_mul_out_T_5 = mem_reg_mullu[31:0] + _mem_alu_mul_out_T_3; // @[Core.scala 1210:71]
  wire  _mem_alu_mul_out_T_6 = mem_reg_exe_fun == 5'h17; // @[Core.scala 1211:22]
  wire [15:0] _mem_alu_mul_out_T_10 = mem_reg_mulls[47] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [47:0] _mem_alu_mul_out_T_13 = {_mem_alu_mul_out_T_10,mem_reg_mulls[47:16]}; // @[Core.scala 1203:71]
  wire [47:0] _mem_alu_mul_out_T_16 = $signed(_mem_alu_mul_out_T_13) + $signed(mem_reg_mulhss); // @[Core.scala 1211:108]
  wire  _mem_alu_mul_out_T_18 = mem_reg_exe_fun == 5'h18; // @[Core.scala 1212:22]
  wire [47:0] _mem_alu_mul_out_T_22 = {16'h0,mem_reg_mullu[47:16]}; // @[Core.scala 1206:35]
  wire [47:0] _mem_alu_mul_out_T_24 = _mem_alu_mul_out_T_22 + mem_reg_mulhuu; // @[Core.scala 1212:108]
  wire  _mem_alu_mul_out_T_26 = mem_reg_exe_fun == 5'h19; // @[Core.scala 1213:22]
  wire [47:0] _mem_alu_mul_out_T_36 = $signed(_mem_alu_mul_out_T_13) + $signed(mem_reg_mulhsu); // @[Core.scala 1213:108]
  wire [31:0] _mem_alu_mul_out_T_38 = _mem_alu_mul_out_T_26 ? _mem_alu_mul_out_T_36[47:16] : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_mul_out_T_39 = _mem_alu_mul_out_T_18 ? _mem_alu_mul_out_T_24[47:16] : _mem_alu_mul_out_T_38; // @[Mux.scala 101:16]
  wire [31:0] _mem_alu_mul_out_T_40 = _mem_alu_mul_out_T_6 ? _mem_alu_mul_out_T_16[47:16] : _mem_alu_mul_out_T_39; // @[Mux.scala 101:16]
  wire [31:0] mem_alu_mul_out = _mem_alu_mul_out_T ? _mem_alu_mul_out_T_5 : _mem_alu_mul_out_T_40; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_rdata = io_dmem_rdata >> _io_dmem_wdata_T_1; // @[Core.scala 1226:36]
  wire  _mem_wb_data_load_T = mem_reg_mem_w == 32'h3; // @[Core.scala 1228:20]
  wire [23:0] _mem_wb_data_load_T_3 = mem_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_5 = {_mem_wb_data_load_T_3,mem_wb_rdata[7:0]}; // @[Core.scala 1219:40]
  wire  _mem_wb_data_load_T_6 = mem_reg_mem_w == 32'h2; // @[Core.scala 1229:20]
  wire [15:0] _mem_wb_data_load_T_9 = mem_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_11 = {_mem_wb_data_load_T_9,mem_wb_rdata[15:0]}; // @[Core.scala 1219:40]
  wire  _mem_wb_data_load_T_12 = mem_reg_mem_w == 32'h5; // @[Core.scala 1230:20]
  wire [31:0] _mem_wb_data_load_T_15 = {24'h0,mem_wb_rdata[7:0]}; // @[Core.scala 1222:31]
  wire  _mem_wb_data_load_T_16 = mem_reg_mem_w == 32'h4; // @[Core.scala 1231:20]
  wire [31:0] _mem_wb_data_load_T_19 = {16'h0,mem_wb_rdata[15:0]}; // @[Core.scala 1222:31]
  wire [31:0] _mem_wb_data_load_T_20 = _mem_wb_data_load_T_16 ? _mem_wb_data_load_T_19 : mem_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_21 = _mem_wb_data_load_T_12 ? _mem_wb_data_load_T_15 : _mem_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_22 = _mem_wb_data_load_T_6 ? _mem_wb_data_load_T_11 : _mem_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data_load = _mem_wb_data_load_T ? _mem_wb_data_load_T_5 : _mem_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T = mem_reg_wb_sel == 3'h5; // @[Core.scala 1235:21]
  wire  _mem_wb_data_T_1 = mem_reg_wb_sel == 3'h4; // @[Core.scala 1236:21]
  wire [31:0] _mem_wb_data_T_3 = mem_reg_pc + 32'h2; // @[Core.scala 1236:68]
  wire [31:0] _mem_wb_data_T_5 = mem_reg_pc + 32'h4; // @[Core.scala 1236:98]
  wire [31:0] _mem_wb_data_T_6 = mem_reg_is_half ? _mem_wb_data_T_3 : _mem_wb_data_T_5; // @[Core.scala 1236:39]
  wire  _mem_wb_data_T_7 = mem_reg_wb_sel == 3'h7; // @[Core.scala 1237:21]
  wire  _mem_wb_data_T_8 = mem_reg_wb_sel == 3'h6; // @[Core.scala 1238:21]
  wire [31:0] _mem_wb_data_T_9 = _mem_wb_data_T_8 ? mem_alu_mul_out : mem_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_10 = _mem_wb_data_T_7 ? csr_rdata : _mem_wb_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_11 = _mem_wb_data_T_1 ? _mem_wb_data_T_6 : _mem_wb_data_T_10; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data = _mem_wb_data_T ? mem_wb_data_load : _mem_wb_data_T_11; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h1; // @[Core.scala 1266:24]
  reg  do_exit; // @[Core.scala 1281:24]
  reg  do_exit_delay; // @[Core.scala 1282:30]
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
  BranchPredictor bp ( // @[Core.scala 327:18]
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
  assign io_imem_addr = if1_is_jump ? ic_next_imem_addr : _GEN_70; // @[Core.scala 236:21 238:18]
  assign io_icache_control_invalidate = mem_mem_wen == 2'h3; // @[Core.scala 1216:48]
  assign io_dmem_raddr = mem_reg_alu_out; // @[Core.scala 1109:17]
  assign io_dmem_ren = io_dmem_rready & _mem_stall_T; // @[Core.scala 1111:35]
  assign io_dmem_waddr = mem_reg_alu_out; // @[Core.scala 1110:17]
  assign io_dmem_wen = io_dmem_wready & _mem_stall_T_6; // @[Core.scala 1112:35]
  assign io_dmem_wstrb = mem_reg_mem_wstrb; // @[Core.scala 1113:17]
  assign io_dmem_wdata = _io_dmem_wdata_T_2[31:0]; // @[Core.scala 1114:71]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 78:17]
  assign io_mtimer_mem_rvalid = mtimer_io_mem_rvalid; // @[Core.scala 78:17]
  assign io_exit = do_exit_delay; // @[Core.scala 1285:11]
  assign io_debug_signal_mem_reg_pc = mem_reg_pc; // @[Core.scala 1274:30]
  assign io_debug_signal_mem_is_valid_inst = mem_reg_is_valid_inst & (_mem_en_T & _mem_en_T_2); // @[Core.scala 1098:49]
  assign io_debug_signal_csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  assign io_debug_signal_mem_reg_csr_addr = mem_reg_csr_addr; // @[Core.scala 1273:36]
  assign io_debug_signal_me_intr = csr_mstatus[3] & (io_intr & csr_mie[11]) & mem_is_valid_inst; // @[Core.scala 1099:73]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value; // @[Core.scala 1270:33]
  assign io_debug_signal_instret = instret; // @[Core.scala 1271:27]
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
  assign bp_io_lu_inst_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 353:24]
  assign bp_io_up_update_en = ex3_bp_en & (ex3_reg_is_cond_br_inst | ex3_reg_is_uncond_br); // @[Core.scala 1039:35]
  assign bp_io_up_inst_pc = ex3_reg_pc; // @[Core.scala 1040:20]
  assign bp_io_up_br_pos = ex3_reg_is_cond_br | ex3_reg_is_uncond_br; // @[Core.scala 1041:41]
  assign bp_io_up_br_addr = ex3_reg_is_cond_br ? ex3_reg_cond_br_target : _bp_io_up_br_addr_T; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (regfile_MPORT_en & regfile_MPORT_mask) begin
      regfile[regfile_MPORT_addr] <= regfile_MPORT_data; // @[Core.scala 64:20]
    end
    if (reset) begin // @[Core.scala 66:32]
      csr_trap_vector <= 32'h0; // @[Core.scala 66:32]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1142:82]
      if (mem_reg_csr_addr == 12'h305) begin // @[Core.scala 1143:48]
        if (_csr_wdata_T) begin // @[Mux.scala 101:16]
          csr_trap_vector <= mem_reg_op1_data;
        end else begin
          csr_trap_vector <= _csr_wdata_T_7;
        end
      end
    end
    if (reset) begin // @[Core.scala 69:24]
      instret <= 64'h0; // @[Core.scala 69:24]
    end else if (wb_reg_is_valid_inst) begin // @[Core.scala 1265:31]
      instret <= _instret_T_1; // @[Core.scala 1266:13]
    end
    if (reset) begin // @[Core.scala 70:29]
      csr_mcause <= 32'h0; // @[Core.scala 70:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1158:24]
      csr_mcause <= 32'h8000000b; // @[Core.scala 1159:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1170:30]
      csr_mcause <= 32'h80000007; // @[Core.scala 1171:21]
    end else if (mem_is_trap) begin // @[Core.scala 1182:28]
      csr_mcause <= mem_reg_mcause; // @[Core.scala 1183:21]
    end
    if (reset) begin // @[Core.scala 72:29]
      csr_mepc <= 32'h0; // @[Core.scala 72:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1158:24]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1161:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1170:30]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1173:21]
    end else if (mem_is_trap) begin // @[Core.scala 1182:28]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1185:21]
    end else begin
      csr_mepc <= _GEN_285;
    end
    if (reset) begin // @[Core.scala 73:29]
      csr_mstatus <= 32'h0; // @[Core.scala 73:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1158:24]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1167:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1170:30]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1179:21]
    end else if (mem_is_trap) begin // @[Core.scala 1182:28]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1191:21]
    end else begin
      csr_mstatus <= _GEN_289;
    end
    if (reset) begin // @[Core.scala 74:29]
      csr_mscratch <= 32'h0; // @[Core.scala 74:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1142:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1143:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1145:53]
          csr_mscratch <= _GEN_273;
        end
      end
    end
    if (reset) begin // @[Core.scala 75:29]
      csr_mie <= 32'h0; // @[Core.scala 75:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1142:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1143:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1145:53]
          csr_mie <= _GEN_274;
        end
      end
    end
    if (reset) begin // @[Core.scala 76:29]
      csr_mip <= 32'h0; // @[Core.scala 76:29]
    end else begin
      csr_mip <= _csr_mip_T_3; // @[Core.scala 1156:11]
    end
    if (reset) begin // @[Core.scala 84:38]
      id_reg_pc <= 32'h0; // @[Core.scala 84:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst)) begin // @[Core.scala 370:19]
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
      id_reg_stall <= id_stall; // @[Core.scala 426:16]
    end
    if (reset) begin // @[Core.scala 88:38]
      id_reg_is_bp_pos <= 1'h0; // @[Core.scala 88:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Core.scala 393:26]
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
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_pc <= _GEN_141;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_pc <= _GEN_141;
    end
    if (reset) begin // @[Core.scala 96:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 96:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_wb_addr <= _GEN_149;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_wb_addr <= _GEN_149;
    end
    if (reset) begin // @[Core.scala 97:38]
      ex1_reg_op1_sel <= 3'h0; // @[Core.scala 97:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_op1_sel <= _GEN_142;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_op1_sel <= _GEN_142;
    end
    if (reset) begin // @[Core.scala 98:38]
      ex1_reg_op2_sel <= 4'h0; // @[Core.scala 98:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_op2_sel <= _GEN_143;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_op2_sel <= _GEN_143;
    end
    if (reset) begin // @[Core.scala 99:38]
      ex1_reg_rs1_addr <= 5'h0; // @[Core.scala 99:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_rs1_addr <= _GEN_144;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_rs1_addr <= _GEN_144;
    end
    if (reset) begin // @[Core.scala 100:38]
      ex1_reg_rs2_addr <= 5'h0; // @[Core.scala 100:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_rs2_addr <= _GEN_145;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_rs2_addr <= _GEN_145;
    end
    if (reset) begin // @[Core.scala 101:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 101:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_op1_data <= _GEN_146;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_op1_data <= _GEN_146;
    end
    if (reset) begin // @[Core.scala 102:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 102:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_op2_data <= _GEN_147;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_op2_data <= _GEN_147;
    end
    if (reset) begin // @[Core.scala 104:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 104:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_exe_fun <= 5'h1;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 782:29]
      end else begin
        ex1_reg_exe_fun <= csignals_0; // @[Core.scala 812:29]
      end
    end
    if (reset) begin // @[Core.scala 105:38]
      ex1_reg_mem_wen <= 2'h0; // @[Core.scala 105:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_mem_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_mem_wen <= id_reg_mem_wen_delay; // @[Core.scala 791:29]
      end else begin
        ex1_reg_mem_wen <= csignals_3; // @[Core.scala 821:29]
      end
    end
    if (reset) begin // @[Core.scala 106:38]
      ex1_reg_rf_wen <= 2'h0; // @[Core.scala 106:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_rf_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 781:29]
      end else begin
        ex1_reg_rf_wen <= csignals_4; // @[Core.scala 811:29]
      end
    end
    if (reset) begin // @[Core.scala 107:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 107:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_wb_sel <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 783:29]
      end else begin
        ex1_reg_wb_sel <= csignals_5; // @[Core.scala 813:29]
      end
    end
    if (reset) begin // @[Core.scala 108:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 108:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_csr_addr <= _GEN_154;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_csr_addr <= _GEN_154;
    end
    if (reset) begin // @[Core.scala 109:38]
      ex1_reg_csr_cmd <= 3'h0; // @[Core.scala 109:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_csr_cmd <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 790:29]
      end else begin
        ex1_reg_csr_cmd <= csignals_7; // @[Core.scala 820:29]
      end
    end
    if (reset) begin // @[Core.scala 112:38]
      ex1_reg_imm_b_sext <= 32'h0; // @[Core.scala 112:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_imm_b_sext <= _GEN_153;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_imm_b_sext <= _GEN_153;
    end
    if (reset) begin // @[Core.scala 115:38]
      ex1_reg_mem_w <= 32'h0; // @[Core.scala 115:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_mem_w <= 32'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 792:29]
      end else begin
        ex1_reg_mem_w <= {{29'd0}, csignals_8}; // @[Core.scala 822:29]
      end
    end
    if (reset) begin // @[Core.scala 116:39]
      ex1_reg_is_j <= 1'h0; // @[Core.scala 116:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_is_j <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_is_j <= id_reg_is_j_delay; // @[Core.scala 793:29]
      end else begin
        ex1_reg_is_j <= id_is_j; // @[Core.scala 823:29]
      end
    end
    if (reset) begin // @[Core.scala 117:39]
      ex1_reg_is_bp_pos <= 1'h0; // @[Core.scala 117:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_is_bp_pos <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos_delay; // @[Core.scala 794:29]
      end else begin
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos; // @[Core.scala 824:29]
      end
    end
    if (reset) begin // @[Core.scala 118:39]
      ex1_reg_bp_addr <= 32'h0; // @[Core.scala 118:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_bp_addr <= _GEN_156;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_bp_addr <= _GEN_156;
    end
    if (reset) begin // @[Core.scala 119:39]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 119:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_is_half <= _GEN_157;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_is_half <= _GEN_157;
    end
    if (reset) begin // @[Core.scala 120:39]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 120:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_is_valid_inst <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 797:29]
      end else begin
        ex1_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 827:29]
      end
    end
    if (reset) begin // @[Core.scala 121:39]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 121:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_is_trap <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      if (id_reg_stall) begin // @[Core.scala 771:24]
        ex1_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 798:29]
      end else begin
        ex1_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 828:29]
      end
    end
    if (reset) begin // @[Core.scala 122:39]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 122:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 715:41]
      ex1_reg_mcause <= _GEN_158;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 769:40]
      ex1_reg_mcause <= _GEN_158;
    end
    if (reset) begin // @[Core.scala 126:38]
      ex2_reg_pc <= 32'h0; // @[Core.scala 126:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 923:27]
    end
    if (reset) begin // @[Core.scala 127:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 127:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 927:27]
    end
    if (reset) begin // @[Core.scala 128:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 128:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
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
    end else if (_T_30) begin // @[Core.scala 921:20]
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
    end else if (_T_30) begin // @[Core.scala 921:20]
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
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 929:33]
        ex2_reg_exe_fun <= 5'h1;
      end else begin
        ex2_reg_exe_fun <= ex1_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 132:38]
      ex2_reg_mem_wen <= 2'h0; // @[Core.scala 132:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 934:33]
        ex2_reg_mem_wen <= 2'h0;
      end else begin
        ex2_reg_mem_wen <= ex1_reg_mem_wen;
      end
    end
    if (reset) begin // @[Core.scala 133:38]
      ex2_reg_rf_wen <= 2'h0; // @[Core.scala 133:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 928:33]
        ex2_reg_rf_wen <= 2'h0;
      end else begin
        ex2_reg_rf_wen <= ex1_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 134:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 134:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 930:33]
        ex2_reg_wb_sel <= 3'h0;
      end else begin
        ex2_reg_wb_sel <= ex1_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 135:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 135:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 932:27]
    end
    if (reset) begin // @[Core.scala 136:38]
      ex2_reg_csr_cmd <= 3'h0; // @[Core.scala 136:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 933:33]
        ex2_reg_csr_cmd <= 3'h0;
      end else begin
        ex2_reg_csr_cmd <= ex1_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 137:38]
      ex2_reg_imm_b_sext <= 32'h0; // @[Core.scala 137:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_imm_b_sext <= ex1_reg_imm_b_sext; // @[Core.scala 931:27]
    end
    if (reset) begin // @[Core.scala 138:38]
      ex2_reg_mem_w <= 32'h0; // @[Core.scala 138:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 935:27]
    end
    if (reset) begin // @[Core.scala 139:38]
      ex2_reg_is_j <= 1'h0; // @[Core.scala 139:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_is_j <= ex1_reg_is_j; // @[Core.scala 936:27]
    end
    if (reset) begin // @[Core.scala 140:38]
      ex2_reg_is_bp_pos <= 1'h0; // @[Core.scala 140:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_is_bp_pos <= ex1_reg_is_bp_pos; // @[Core.scala 937:27]
    end
    if (reset) begin // @[Core.scala 141:38]
      ex2_reg_bp_addr <= 32'h0; // @[Core.scala 141:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_bp_addr <= ex1_reg_bp_addr; // @[Core.scala 938:27]
    end
    if (reset) begin // @[Core.scala 142:38]
      ex2_reg_is_half <= 1'h0; // @[Core.scala 142:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_is_half <= ex1_reg_is_half; // @[Core.scala 939:27]
    end
    if (reset) begin // @[Core.scala 143:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 143:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_is_valid_inst <= ex1_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 940:27]
    end
    if (reset) begin // @[Core.scala 144:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 144:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      if (ex_is_bubble) begin // @[Core.scala 941:33]
        ex2_reg_is_trap <= 1'h0;
      end else begin
        ex2_reg_is_trap <= ex1_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 145:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 145:38]
    end else if (_T_30) begin // @[Core.scala 921:20]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 942:27]
    end
    if (reset) begin // @[Core.scala 149:41]
      ex3_reg_bp_en <= 1'h0; // @[Core.scala 149:41]
    end else begin
      ex3_reg_bp_en <= ex2_reg_is_valid_inst & _mem_en_T & _mem_en_T_2; // @[Core.scala 1006:28]
    end
    if (reset) begin // @[Core.scala 150:41]
      ex3_reg_pc <= 32'h0; // @[Core.scala 150:41]
    end else begin
      ex3_reg_pc <= ex2_reg_pc; // @[Core.scala 1007:28]
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
      ex3_reg_is_cond_br_inst <= ex2_is_cond_br_inst; // @[Core.scala 1010:28]
    end
    if (reset) begin // @[Core.scala 153:41]
      ex3_reg_is_uncond_br <= 1'h0; // @[Core.scala 153:41]
    end else begin
      ex3_reg_is_uncond_br <= ex2_is_uncond_br; // @[Core.scala 1011:28]
    end
    if (reset) begin // @[Core.scala 154:41]
      ex3_reg_cond_br_target <= 32'h0; // @[Core.scala 154:41]
    end else begin
      ex3_reg_cond_br_target <= ex2_cond_br_target; // @[Core.scala 1012:28]
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
      ex3_reg_is_bp_pos <= ex2_reg_is_bp_pos; // @[Core.scala 1015:28]
    end
    if (reset) begin // @[Core.scala 158:41]
      ex3_reg_bp_addr <= 32'h0; // @[Core.scala 158:41]
    end else begin
      ex3_reg_bp_addr <= ex2_reg_bp_addr; // @[Core.scala 1016:28]
    end
    if (reset) begin // @[Core.scala 159:41]
      ex3_reg_is_half <= 1'h0; // @[Core.scala 159:41]
    end else begin
      ex3_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1017:28]
    end
    if (reset) begin // @[Core.scala 162:38]
      mem_reg_en <= 1'h0; // @[Core.scala 162:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_en <= _mem_is_valid_inst_T_2; // @[Core.scala 1064:24]
    end
    if (reset) begin // @[Core.scala 163:38]
      mem_reg_pc <= 32'h0; // @[Core.scala 163:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_pc <= ex2_reg_pc; // @[Core.scala 1065:24]
    end
    if (reset) begin // @[Core.scala 164:38]
      mem_reg_wb_addr <= 5'h0; // @[Core.scala 164:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_wb_addr <= ex2_reg_wb_addr; // @[Core.scala 1068:24]
    end
    if (reset) begin // @[Core.scala 165:38]
      mem_reg_op1_data <= 32'h0; // @[Core.scala 165:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_op1_data <= ex2_reg_op1_data; // @[Core.scala 1066:24]
    end
    if (reset) begin // @[Core.scala 166:38]
      mem_reg_rs2_data <= 32'h0; // @[Core.scala 166:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_rs2_data <= ex2_reg_rs2_data; // @[Core.scala 1067:24]
    end
    if (reset) begin // @[Core.scala 167:38]
      mem_reg_mullu <= 48'h0; // @[Core.scala 167:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mullu <= ex2_mullu; // @[Core.scala 1070:24]
    end
    if (reset) begin // @[Core.scala 168:38]
      mem_reg_mulls <= 48'sh0; // @[Core.scala 168:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mulls <= ex2_mulls; // @[Core.scala 1071:24]
    end
    if (reset) begin // @[Core.scala 169:38]
      mem_reg_mulhuu <= 48'h0; // @[Core.scala 169:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mulhuu <= ex2_mulhuu; // @[Core.scala 1072:24]
    end
    if (reset) begin // @[Core.scala 170:38]
      mem_reg_mulhss <= 48'sh0; // @[Core.scala 170:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mulhss <= ex2_mulhss; // @[Core.scala 1073:24]
    end
    if (reset) begin // @[Core.scala 171:38]
      mem_reg_mulhsu <= 48'sh0; // @[Core.scala 171:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mulhsu <= ex2_mulhsu; // @[Core.scala 1074:24]
    end
    if (reset) begin // @[Core.scala 172:38]
      mem_reg_exe_fun <= 5'h0; // @[Core.scala 172:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_exe_fun <= ex2_reg_exe_fun; // @[Core.scala 1075:24]
    end
    if (reset) begin // @[Core.scala 173:38]
      mem_reg_mem_wen <= 2'h0; // @[Core.scala 173:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mem_wen <= ex2_reg_mem_wen; // @[Core.scala 1081:24]
    end
    if (reset) begin // @[Core.scala 174:38]
      mem_reg_rf_wen <= 2'h0; // @[Core.scala 174:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_rf_wen <= ex2_reg_rf_wen; // @[Core.scala 1076:24]
    end
    if (reset) begin // @[Core.scala 175:38]
      mem_reg_wb_sel <= 3'h0; // @[Core.scala 175:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_wb_sel <= ex2_reg_wb_sel; // @[Core.scala 1077:24]
    end
    if (reset) begin // @[Core.scala 176:38]
      mem_reg_csr_addr <= 12'h0; // @[Core.scala 176:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_csr_addr <= ex2_reg_csr_addr; // @[Core.scala 1078:24]
    end
    if (reset) begin // @[Core.scala 177:38]
      mem_reg_csr_cmd <= 3'h0; // @[Core.scala 177:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_csr_cmd <= ex2_reg_csr_cmd; // @[Core.scala 1079:24]
    end
    if (reset) begin // @[Core.scala 179:38]
      mem_reg_alu_out <= 32'h0; // @[Core.scala 179:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_2;
      end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_5;
      end else begin
        mem_reg_alu_out <= _ex2_alu_out_T_45;
      end
    end
    if (reset) begin // @[Core.scala 181:38]
      mem_reg_mem_w <= 32'h0; // @[Core.scala 181:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mem_w <= ex2_reg_mem_w; // @[Core.scala 1082:24]
    end
    if (reset) begin // @[Core.scala 182:38]
      mem_reg_mem_wstrb <= 4'h0; // @[Core.scala 182:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mem_wstrb <= _mem_reg_mem_wstrb_T_7[3:0]; // @[Core.scala 1083:24]
    end
    if (reset) begin // @[Core.scala 183:38]
      mem_reg_is_half <= 1'h0; // @[Core.scala 183:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1088:24]
    end
    if (reset) begin // @[Core.scala 184:38]
      mem_reg_is_valid_inst <= 1'h0; // @[Core.scala 184:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_is_valid_inst <= _ex3_reg_bp_en_T_3; // @[Core.scala 1089:27]
    end
    if (reset) begin // @[Core.scala 185:38]
      mem_reg_is_trap <= 1'h0; // @[Core.scala 185:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_is_trap <= ex2_reg_is_trap; // @[Core.scala 1090:24]
    end
    if (reset) begin // @[Core.scala 186:38]
      mem_reg_mcause <= 32'h0; // @[Core.scala 186:38]
    end else if (_T_30) begin // @[Core.scala 1063:22]
      mem_reg_mcause <= ex2_reg_mcause; // @[Core.scala 1091:24]
    end
    if (reset) begin // @[Core.scala 190:38]
      wb_reg_wb_addr <= 5'h0; // @[Core.scala 190:38]
    end else begin
      wb_reg_wb_addr <= mem_reg_wb_addr; // @[Core.scala 1248:18]
    end
    if (reset) begin // @[Core.scala 191:38]
      wb_reg_rf_wen <= 2'h0; // @[Core.scala 191:38]
    end else if (_T_30) begin // @[Core.scala 1249:24]
      if (mem_en) begin // @[Core.scala 1103:23]
        wb_reg_rf_wen <= mem_reg_rf_wen;
      end else begin
        wb_reg_rf_wen <= 2'h0;
      end
    end else begin
      wb_reg_rf_wen <= 2'h0;
    end
    if (reset) begin // @[Core.scala 192:38]
      wb_reg_wb_data <= 32'h0; // @[Core.scala 192:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_11;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1236:39]
        wb_reg_wb_data <= _mem_wb_data_T_3;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= csr_rdata;
    end else begin
      wb_reg_wb_data <= _mem_wb_data_T_9;
    end
    if (reset) begin // @[Core.scala 193:38]
      wb_reg_is_valid_inst <= 1'h0; // @[Core.scala 193:38]
    end else begin
      wb_reg_is_valid_inst <= mem_is_valid_inst & _T_30 & _mem_en_T_4 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1251:24]
    end
    if (reset) begin // @[Core.scala 195:35]
      if2_reg_is_bp_pos <= 1'h0; // @[Core.scala 195:35]
    end else if (!(id_reg_stall)) begin // @[Core.scala 393:26]
      if2_reg_is_bp_pos <= _if2_is_bp_pos_T;
    end
    if (reset) begin // @[Core.scala 196:35]
      if2_reg_bp_addr <= 32'h0; // @[Core.scala 196:35]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        if2_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 200:35]
      ex3_reg_is_br <= 1'h0; // @[Core.scala 200:35]
    end else begin
      ex3_reg_is_br <= ex3_cond_bp_fail | ex3_cond_nbp_fail | ex3_uncond_bp_fail; // @[Core.scala 1037:17]
    end
    if (reset) begin // @[Core.scala 201:35]
      ex3_reg_br_target <= 32'h0; // @[Core.scala 201:35]
    end else if (ex3_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_cond_br_target;
    end else if (ex3_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (ex3_reg_is_half) begin // @[Core.scala 1034:30]
        ex3_reg_br_target <= _ex3_reg_br_target_T_1;
      end else begin
        ex3_reg_br_target <= _ex3_reg_br_target_T_3;
      end
    end else if (ex3_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_br_target <= 32'h0;
    end
    if (reset) begin // @[Core.scala 204:35]
      mem_reg_is_br <= 1'h0; // @[Core.scala 204:35]
    end else begin
      mem_reg_is_br <= _GEN_308;
    end
    if (reset) begin // @[Core.scala 205:35]
      mem_reg_br_addr <= 32'h0; // @[Core.scala 205:35]
    end else if (mem_is_meintr) begin // @[Core.scala 1158:24]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1169:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1170:30]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1181:21]
    end else if (mem_is_trap) begin // @[Core.scala 1182:28]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1193:21]
    end else begin
      mem_reg_br_addr <= _GEN_291;
    end
    if (reset) begin // @[Core.scala 214:32]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 214:32]
    end else if (if1_is_jump) begin // @[Core.scala 236:21]
      ic_reg_read_rdy <= ~if1_jump_addr[1]; // @[Core.scala 242:21]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
      ic_reg_read_rdy <= 1'h1; // @[Core.scala 232:19]
    end
    if (reset) begin // @[Core.scala 215:32]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 215:32]
    end else begin
      ic_reg_half_rdy <= _GEN_84;
    end
    if (reset) begin // @[Core.scala 217:33]
      ic_reg_imem_addr <= 32'h0; // @[Core.scala 217:33]
    end else if (if1_is_jump) begin // @[Core.scala 236:21]
      ic_reg_imem_addr <= ic_next_imem_addr; // @[Core.scala 238:18]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
      if (3'h0 == ic_state) begin // @[Core.scala 247:23]
        ic_reg_imem_addr <= ic_imem_addr_4; // @[Core.scala 249:22]
      end else begin
        ic_reg_imem_addr <= _GEN_50;
      end
    end
    if (reset) begin // @[Core.scala 218:32]
      ic_reg_addr_out <= 32'h0; // @[Core.scala 218:32]
    end else if (if1_is_jump) begin // @[Core.scala 236:21]
      if (mem_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= mem_reg_br_addr;
      end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= ex3_reg_br_target;
      end else begin
        ic_reg_addr_out <= _if1_jump_addr_T_1;
      end
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
      if (3'h0 == ic_state) begin // @[Core.scala 247:23]
        ic_reg_addr_out <= _GEN_2;
      end else begin
        ic_reg_addr_out <= _GEN_55;
      end
    end
    if (reset) begin // @[Core.scala 220:34]
      ic_reg_inst <= 32'h0; // @[Core.scala 220:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 236:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
        if (3'h0 == ic_state) begin // @[Core.scala 247:23]
          ic_reg_inst <= io_imem_inst; // @[Core.scala 251:21]
        end else begin
          ic_reg_inst <= _GEN_52;
        end
      end
    end
    if (reset) begin // @[Core.scala 221:34]
      ic_reg_inst_addr <= 32'h0; // @[Core.scala 221:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 236:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
        if (3'h0 == ic_state) begin // @[Core.scala 247:23]
          ic_reg_inst_addr <= ic_reg_imem_addr; // @[Core.scala 252:26]
        end else begin
          ic_reg_inst_addr <= _GEN_53;
        end
      end
    end
    if (reset) begin // @[Core.scala 222:34]
      ic_reg_inst2 <= 32'h0; // @[Core.scala 222:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 236:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 247:23]
          ic_reg_inst2 <= _GEN_57;
        end
      end
    end
    if (reset) begin // @[Core.scala 223:34]
      ic_reg_inst2_addr <= 32'h0; // @[Core.scala 223:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 236:21]
      if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
        if (!(3'h0 == ic_state)) begin // @[Core.scala 247:23]
          ic_reg_inst2_addr <= _GEN_58;
        end
      end
    end
    if (reset) begin // @[Core.scala 225:25]
      ic_state <= 3'h0; // @[Core.scala 225:25]
    end else if (if1_is_jump) begin // @[Core.scala 236:21]
      ic_state <= {{2'd0}, if1_jump_addr[1]}; // @[Core.scala 241:14]
    end else if (!(ic_state != 3'h2 & ic_state != 3'h3 & ~io_imem_valid)) begin // @[Core.scala 243:94]
      if (3'h0 == ic_state) begin // @[Core.scala 247:23]
        ic_state <= _GEN_3;
      end else begin
        ic_state <= _GEN_56;
      end
    end
    if1_reg_first <= reset; // @[Core.scala 333:{30,30} 334:17]
    if (reset) begin // @[Core.scala 352:32]
      if1_reg_next_pc <= 32'h0; // @[Core.scala 352:32]
    end else if (id_reg_stall) begin // @[Core.scala 355:25]
      if (if1_is_jump) begin // @[Core.scala 353:24]
        if (mem_reg_is_br) begin // @[Mux.scala 101:16]
          if1_reg_next_pc <= mem_reg_br_addr;
        end else begin
          if1_reg_next_pc <= _if1_jump_addr_T_2;
        end
      end
    end else begin
      if1_reg_next_pc <= if1_next_pc_4;
    end
    if (reset) begin // @[Core.scala 364:29]
      if2_reg_pc <= 32'h8000000; // @[Core.scala 364:29]
    end else if (!(id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst))) begin // @[Core.scala 370:19]
      if2_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 365:29]
      if2_reg_inst <= 32'h0; // @[Core.scala 365:29]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if2_reg_inst <= _if2_inst_T_3;
    end
    if (reset) begin // @[Core.scala 837:38]
      ex1_reg_hazard <= 1'h0; // @[Core.scala 837:38]
    end else if (_T_30) begin // @[Core.scala 913:20]
      ex1_reg_hazard <= ex1_hazard & (ex1_reg_wb_sel == 3'h5 | ex1_reg_wb_sel == 3'h7 | ex1_reg_wb_sel == 3'h6); // @[Core.scala 916:20]
    end
    if (reset) begin // @[Core.scala 840:38]
      ex2_reg_hazard <= 1'h0; // @[Core.scala 840:38]
    end else if (_T_30) begin // @[Core.scala 998:20]
      ex2_reg_hazard <= ex2_hazard & (ex2_reg_wb_sel == 3'h5 | ex2_reg_wb_sel == 3'h7 | ex2_reg_wb_sel == 3'h6); // @[Core.scala 1001:20]
    end
    if (reset) begin // @[Core.scala 1107:32]
      mem_stall_delay <= 1'h0; // @[Core.scala 1107:32]
    end else begin
      mem_stall_delay <= _mem_stall_T & io_dmem_rvalid & _T_30; // @[Core.scala 1116:19]
    end
    if (reset) begin // @[Core.scala 637:40]
      id_reg_pc_delay <= 32'h0; // @[Core.scala 637:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_pc_delay <= _GEN_90;
    end else begin
      id_reg_pc_delay <= _GEN_90;
    end
    if (reset) begin // @[Core.scala 638:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 638:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_wb_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_wb_addr_delay <= _id_wb_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 639:40]
      id_reg_op1_sel_delay <= 3'h0; // @[Core.scala 639:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_op1_sel_delay <= 3'h0;
        end else begin
          id_reg_op1_sel_delay <= _id_m_op1_sel_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 640:40]
      id_reg_op2_sel_delay <= 4'h0; // @[Core.scala 640:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_op2_sel_delay <= 4'h1;
        end else begin
          id_reg_op2_sel_delay <= _id_m_op2_sel_T_2;
        end
      end
    end
    if (reset) begin // @[Core.scala 641:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 641:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_rs1_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 642:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 642:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_rs2_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 643:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 643:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= id_rs1_data;
        end else begin
          id_reg_op1_data_delay <= _id_op1_data_T_10;
        end
      end
    end
    if (reset) begin // @[Core.scala 644:40]
      id_reg_op2_data_delay <= 32'h0; // @[Core.scala 644:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_op2_data_T) begin // @[Mux.scala 101:16]
          id_reg_op2_data_delay <= id_rs2_data;
        end else begin
          id_reg_op2_data_delay <= _id_op2_data_T_28;
        end
      end
    end
    if (reset) begin // @[Core.scala 646:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 646:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_exe_fun_delay <= 5'h1; // @[Core.scala 672:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h1;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_226;
      end
    end
    if (reset) begin // @[Core.scala 647:40]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 647:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 675:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else begin
        id_reg_mem_wen_delay <= _csignals_T_451;
      end
    end
    if (reset) begin // @[Core.scala 648:40]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 648:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 671:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_rf_wen_delay <= 2'h1;
      end else begin
        id_reg_rf_wen_delay <= _csignals_T_526;
      end
    end
    if (reset) begin // @[Core.scala 649:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 649:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 673:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h5;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_601;
      end
    end
    if (reset) begin // @[Core.scala 650:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 650:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (csignals_7 == 3'h4) begin // @[Core.scala 602:24]
          id_reg_csr_addr_delay <= 12'h342;
        end else begin
          id_reg_csr_addr_delay <= id_imm_i;
        end
      end
    end
    if (reset) begin // @[Core.scala 651:40]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 651:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 674:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_751;
      end
    end
    if (reset) begin // @[Core.scala 654:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 654:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_imm_b_sext_delay <= id_c_imm_b;
        end else begin
          id_reg_imm_b_sext_delay <= id_imm_b_sext;
        end
      end
    end
    if (reset) begin // @[Core.scala 657:40]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 657:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 676:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      id_reg_mem_w_delay <= {{29'd0}, csignals_8}; // @[Core.scala 702:29]
    end
    if (reset) begin // @[Core.scala 658:40]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 658:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 677:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      id_reg_is_j_delay <= id_is_j; // @[Core.scala 703:29]
    end
    if (reset) begin // @[Core.scala 659:40]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 659:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 678:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      id_reg_is_bp_pos_delay <= id_reg_is_bp_pos; // @[Core.scala 704:29]
    end
    if (reset) begin // @[Core.scala 660:40]
      id_reg_bp_addr_delay <= 32'h0; // @[Core.scala 660:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        id_reg_bp_addr_delay <= id_reg_bp_addr; // @[Core.scala 705:29]
      end
    end
    if (reset) begin // @[Core.scala 661:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 661:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        id_reg_is_half_delay <= id_is_half; // @[Core.scala 706:29]
      end
    end
    if (reset) begin // @[Core.scala 662:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 662:43]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 679:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 707:32]
    end
    if (reset) begin // @[Core.scala 663:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 663:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 667:41]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 680:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 681:30]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 708:29]
    end
    if (reset) begin // @[Core.scala 664:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 664:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 667:41]
      if (_ic_read_en4_T) begin // @[Core.scala 681:30]
        id_reg_mcause_delay <= 32'hb; // @[Core.scala 709:29]
      end
    end
    if (reset) begin // @[Core.scala 836:38]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 836:38]
    end else if (_T_30) begin // @[Core.scala 913:20]
      ex1_reg_fw_en <= _T_29 & ex1_hazard & ex1_reg_wb_sel != 3'h5 & ex1_reg_wb_sel != 3'h7; // @[Core.scala 915:19]
    end
    if (reset) begin // @[Core.scala 839:38]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 839:38]
    end else if (_T_30) begin // @[Core.scala 998:20]
      ex2_reg_fw_en <= ex2_hazard & ex2_reg_wb_sel != 3'h5 & ex2_reg_wb_sel != 3'h7; // @[Core.scala 1000:19]
    end
    if (reset) begin // @[Core.scala 841:38]
      ex2_reg_fw_data <= 32'h0; // @[Core.scala 841:38]
    end else if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
      if (ex2_reg_is_half) begin // @[Core.scala 992:38]
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
    if (reset) begin // @[Core.scala 842:38]
      mem_reg_rf_wen_delay <= 2'h0; // @[Core.scala 842:38]
    end else if (mem_en) begin // @[Core.scala 1103:23]
      mem_reg_rf_wen_delay <= mem_reg_rf_wen;
    end else begin
      mem_reg_rf_wen_delay <= 2'h0;
    end
    if (reset) begin // @[Core.scala 844:38]
      mem_reg_wb_data_delay <= 32'h0; // @[Core.scala 844:38]
    end else if (_mem_wb_data_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_11;
      end else begin
        mem_reg_wb_data_delay <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1236:39]
        mem_reg_wb_data_delay <= _mem_wb_data_T_3;
      end else begin
        mem_reg_wb_data_delay <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= csr_rdata;
    end else begin
      mem_reg_wb_data_delay <= _mem_wb_data_T_9;
    end
    if (reset) begin // @[Core.scala 845:38]
      wb_reg_rf_wen_delay <= 2'h0; // @[Core.scala 845:38]
    end else begin
      wb_reg_rf_wen_delay <= wb_reg_rf_wen; // @[Core.scala 1261:24]
    end
    if (reset) begin // @[Core.scala 846:38]
      wb_reg_wb_addr_delay <= 5'h0; // @[Core.scala 846:38]
    end else begin
      wb_reg_wb_addr_delay <= wb_reg_wb_addr; // @[Core.scala 1262:24]
    end
    if (reset) begin // @[Core.scala 847:38]
      wb_reg_wb_data_delay <= 32'h0; // @[Core.scala 847:38]
    end else begin
      wb_reg_wb_data_delay <= wb_reg_wb_data; // @[Core.scala 1263:24]
    end
    if (reset) begin // @[Core.scala 1281:24]
      do_exit <= 1'h0; // @[Core.scala 1281:24]
    end else begin
      do_exit <= mem_reg_is_trap & mem_reg_mcause == 32'hb & regfile_do_exit_MPORT_data == 32'h5d; // @[Core.scala 1283:11]
    end
    if (reset) begin // @[Core.scala 1282:30]
      do_exit_delay <= 1'h0; // @[Core.scala 1282:30]
    end else begin
      do_exit_delay <= do_exit; // @[Core.scala 1284:17]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",ic_reg_addr_out,ic_data_out); // @[Core.scala 404:9]
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
          $fwrite(32'h80000002,"inst: %x, ic_reg_read_rdy: %d, ic_state: %d\n",if2_inst,ic_reg_read_rdy,ic_state); // @[Core.scala 405:9]
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
          $fwrite(32'h80000002,"if2_pc           : 0x%x\n",if2_pc); // @[Core.scala 1287:9]
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
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 1288:9]
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
          $fwrite(32'h80000002,"if2_reg_is_bp_pos: 0x%x\n",if2_reg_is_bp_pos); // @[Core.scala 1289:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_hit  : 0x%x\n",bp_io_lu_br_hit); // @[Core.scala 1290:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_pos  : 0x%x\n",bp_io_lu_br_pos); // @[Core.scala 1291:9]
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
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",id_reg_pc); // @[Core.scala 1292:9]
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
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 1293:9]
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
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 1294:9]
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
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 1295:9]
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
          $fwrite(32'h80000002,"id_rs1_data      : 0x%x\n",id_rs1_data); // @[Core.scala 1296:9]
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
          $fwrite(32'h80000002,"id_rs2_data      : 0x%x\n",id_rs2_data); // @[Core.scala 1297:9]
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
          $fwrite(32'h80000002,"id_wb_addr       : 0x%x\n",id_wb_addr); // @[Core.scala 1298:9]
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
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",ex1_reg_pc); // @[Core.scala 1299:9]
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
          $fwrite(32'h80000002,"ex1_reg_is_valid_: 0x%x\n",ex1_reg_is_valid_inst); // @[Core.scala 1300:9]
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
          $fwrite(32'h80000002,"ex1_stall        : 0x%x\n",ex1_stall); // @[Core.scala 1301:9]
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
          $fwrite(32'h80000002,"ex1_op1_data     : 0x%x\n",ex1_op1_data); // @[Core.scala 1302:9]
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
          $fwrite(32'h80000002,"ex1_op2_data     : 0x%x\n",ex1_op2_data); // @[Core.scala 1303:9]
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
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",ex2_reg_pc); // @[Core.scala 1306:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_valid_: 0x%x\n",ex2_reg_is_valid_inst); // @[Core.scala 1307:9]
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
          $fwrite(32'h80000002,"ex2_reg_op1_data : 0x%x\n",ex2_reg_op1_data); // @[Core.scala 1308:9]
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
          $fwrite(32'h80000002,"ex2_reg_op2_data : 0x%x\n",ex2_reg_op2_data); // @[Core.scala 1309:9]
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
          $fwrite(32'h80000002,"ex2_alu_out      : 0x%x\n",ex2_alu_out); // @[Core.scala 1310:9]
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
          $fwrite(32'h80000002,"ex2_reg_exe_fun  : 0x%x\n",ex2_reg_exe_fun); // @[Core.scala 1311:9]
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
          $fwrite(32'h80000002,"ex2_reg_wb_sel   : 0x%x\n",ex2_reg_wb_sel); // @[Core.scala 1312:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_bp_pos : 0x%x\n",ex2_reg_is_bp_pos); // @[Core.scala 1313:9]
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
          $fwrite(32'h80000002,"ex2_reg_bp_addr  : 0x%x\n",ex2_reg_bp_addr); // @[Core.scala 1314:9]
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
          $fwrite(32'h80000002,"ex3_reg_pc       : 0x%x\n",ex3_reg_pc); // @[Core.scala 1315:9]
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
          $fwrite(32'h80000002,"ex3_reg_is_br    : 0x%x\n",ex3_reg_is_br); // @[Core.scala 1316:9]
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
          $fwrite(32'h80000002,"ex3_reg_br_target : 0x%x\n",ex3_reg_br_target); // @[Core.scala 1317:9]
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
          $fwrite(32'h80000002,"mem_reg_pc       : 0x%x\n",mem_reg_pc); // @[Core.scala 1318:9]
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
          $fwrite(32'h80000002,"mem_is_valid_inst: 0x%x\n",mem_is_valid_inst); // @[Core.scala 1319:9]
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
          $fwrite(32'h80000002,"mem_stall        : 0x%x\n",mem_stall); // @[Core.scala 1320:9]
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
          $fwrite(32'h80000002,"mem_wb_data      : 0x%x\n",mem_wb_data); // @[Core.scala 1321:9]
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
          $fwrite(32'h80000002,"mem_alu_mul_out  : 0x%x\n",mem_alu_mul_out); // @[Core.scala 1322:9]
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
          $fwrite(32'h80000002,"mem_reg_mem_w    : 0x%x\n",mem_reg_mem_w); // @[Core.scala 1323:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_addr  : 0x%x\n",mem_reg_wb_addr); // @[Core.scala 1324:9]
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
          $fwrite(32'h80000002,"mem_is_meintr    : %d\n",mem_is_meintr); // @[Core.scala 1325:9]
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
          $fwrite(32'h80000002,"mem_is_mtintr    : %d\n",mem_is_mtintr); // @[Core.scala 1326:9]
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
          $fwrite(32'h80000002,"mem_reg_rf_wen_delay : 0x%x\n",mem_reg_rf_wen_delay); // @[Core.scala 1327:9]
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
          $fwrite(32'h80000002,"mem_wb_addr_delay : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1328:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_data_delay : 0x%x\n",mem_reg_wb_data_delay); // @[Core.scala 1329:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_addr   : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1330:9]
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
          $fwrite(32'h80000002,"wb_reg_is_valid_i: 0x%x\n",wb_reg_is_valid_inst); // @[Core.scala 1331:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_data   : 0x%x\n",wb_reg_wb_data); // @[Core.scala 1332:9]
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
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 1333:9]
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
          $fwrite(32'h80000002,"cycle_counter(%d) : %d\n",do_exit,io_debug_signal_cycle_counter); // @[Core.scala 1334:9]
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
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 1335:9]
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
  _RAND_72 = {2{`RANDOM}};
  mem_reg_mullu = _RAND_72[47:0];
  _RAND_73 = {2{`RANDOM}};
  mem_reg_mulls = _RAND_73[47:0];
  _RAND_74 = {2{`RANDOM}};
  mem_reg_mulhuu = _RAND_74[47:0];
  _RAND_75 = {2{`RANDOM}};
  mem_reg_mulhss = _RAND_75[47:0];
  _RAND_76 = {2{`RANDOM}};
  mem_reg_mulhsu = _RAND_76[47:0];
  _RAND_77 = {1{`RANDOM}};
  mem_reg_exe_fun = _RAND_77[4:0];
  _RAND_78 = {1{`RANDOM}};
  mem_reg_mem_wen = _RAND_78[1:0];
  _RAND_79 = {1{`RANDOM}};
  mem_reg_rf_wen = _RAND_79[1:0];
  _RAND_80 = {1{`RANDOM}};
  mem_reg_wb_sel = _RAND_80[2:0];
  _RAND_81 = {1{`RANDOM}};
  mem_reg_csr_addr = _RAND_81[11:0];
  _RAND_82 = {1{`RANDOM}};
  mem_reg_csr_cmd = _RAND_82[2:0];
  _RAND_83 = {1{`RANDOM}};
  mem_reg_alu_out = _RAND_83[31:0];
  _RAND_84 = {1{`RANDOM}};
  mem_reg_mem_w = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  mem_reg_mem_wstrb = _RAND_85[3:0];
  _RAND_86 = {1{`RANDOM}};
  mem_reg_is_half = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  mem_reg_is_valid_inst = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  mem_reg_is_trap = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  mem_reg_mcause = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  wb_reg_wb_addr = _RAND_90[4:0];
  _RAND_91 = {1{`RANDOM}};
  wb_reg_rf_wen = _RAND_91[1:0];
  _RAND_92 = {1{`RANDOM}};
  wb_reg_wb_data = _RAND_92[31:0];
  _RAND_93 = {1{`RANDOM}};
  wb_reg_is_valid_inst = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  if2_reg_is_bp_pos = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  if2_reg_bp_addr = _RAND_95[31:0];
  _RAND_96 = {1{`RANDOM}};
  ex3_reg_is_br = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  ex3_reg_br_target = _RAND_97[31:0];
  _RAND_98 = {1{`RANDOM}};
  mem_reg_is_br = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  mem_reg_br_addr = _RAND_99[31:0];
  _RAND_100 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  ic_reg_imem_addr = _RAND_102[31:0];
  _RAND_103 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_103[31:0];
  _RAND_104 = {1{`RANDOM}};
  ic_reg_inst = _RAND_104[31:0];
  _RAND_105 = {1{`RANDOM}};
  ic_reg_inst_addr = _RAND_105[31:0];
  _RAND_106 = {1{`RANDOM}};
  ic_reg_inst2 = _RAND_106[31:0];
  _RAND_107 = {1{`RANDOM}};
  ic_reg_inst2_addr = _RAND_107[31:0];
  _RAND_108 = {1{`RANDOM}};
  ic_state = _RAND_108[2:0];
  _RAND_109 = {1{`RANDOM}};
  if1_reg_first = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  if1_reg_next_pc = _RAND_110[31:0];
  _RAND_111 = {1{`RANDOM}};
  if2_reg_pc = _RAND_111[31:0];
  _RAND_112 = {1{`RANDOM}};
  if2_reg_inst = _RAND_112[31:0];
  _RAND_113 = {1{`RANDOM}};
  ex1_reg_hazard = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  ex2_reg_hazard = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  mem_stall_delay = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_116[31:0];
  _RAND_117 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_117[4:0];
  _RAND_118 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_118[2:0];
  _RAND_119 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_119[3:0];
  _RAND_120 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_120[4:0];
  _RAND_121 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_121[4:0];
  _RAND_122 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_122[31:0];
  _RAND_123 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_123[31:0];
  _RAND_124 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_124[4:0];
  _RAND_125 = {1{`RANDOM}};
  id_reg_mem_wen_delay = _RAND_125[1:0];
  _RAND_126 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_126[1:0];
  _RAND_127 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_127[2:0];
  _RAND_128 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_128[11:0];
  _RAND_129 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_129[2:0];
  _RAND_130 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_130[31:0];
  _RAND_131 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_131[31:0];
  _RAND_132 = {1{`RANDOM}};
  id_reg_is_j_delay = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  id_reg_is_bp_pos_delay = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  id_reg_bp_addr_delay = _RAND_134[31:0];
  _RAND_135 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_137[0:0];
  _RAND_138 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_138[31:0];
  _RAND_139 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_139[0:0];
  _RAND_140 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_140[0:0];
  _RAND_141 = {1{`RANDOM}};
  ex2_reg_fw_data = _RAND_141[31:0];
  _RAND_142 = {1{`RANDOM}};
  mem_reg_rf_wen_delay = _RAND_142[1:0];
  _RAND_143 = {1{`RANDOM}};
  mem_reg_wb_data_delay = _RAND_143[31:0];
  _RAND_144 = {1{`RANDOM}};
  wb_reg_rf_wen_delay = _RAND_144[1:0];
  _RAND_145 = {1{`RANDOM}};
  wb_reg_wb_addr_delay = _RAND_145[4:0];
  _RAND_146 = {1{`RANDOM}};
  wb_reg_wb_data_delay = _RAND_146[31:0];
  _RAND_147 = {1{`RANDOM}};
  do_exit = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  do_exit_delay = _RAND_148[0:0];
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
  input  [3:0]  io_sdc_port_dat_in
);
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
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
  reg [31:0] _RAND_145;
  reg [159:0] _RAND_146;
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
`endif // RANDOMIZE_REG_INIT
  reg [31:0] rx_dat [0:129]; // @[Sdc.scala 99:19]
  wire  rx_dat_io_mem_rdata_MPORT_en; // @[Sdc.scala 99:19]
  wire [7:0] rx_dat_io_mem_rdata_MPORT_addr; // @[Sdc.scala 99:19]
  wire [31:0] rx_dat_io_mem_rdata_MPORT_data; // @[Sdc.scala 99:19]
  wire [31:0] rx_dat_MPORT_data; // @[Sdc.scala 99:19]
  wire [7:0] rx_dat_MPORT_addr; // @[Sdc.scala 99:19]
  wire  rx_dat_MPORT_mask; // @[Sdc.scala 99:19]
  wire  rx_dat_MPORT_en; // @[Sdc.scala 99:19]
  reg  reg_power; // @[Sdc.scala 57:26]
  reg [8:0] reg_baud_divider; // @[Sdc.scala 58:33]
  reg [8:0] reg_clk_counter; // @[Sdc.scala 59:32]
  reg  reg_clk; // @[Sdc.scala 60:24]
  wire  _T = reg_clk_counter == 9'h0; // @[Sdc.scala 62:27]
  wire [8:0] _reg_clk_counter_T_1 = reg_clk_counter - 9'h1; // @[Sdc.scala 66:42]
  wire [8:0] _GEN_0 = reg_clk_counter == 9'h0 ? reg_baud_divider : _reg_clk_counter_T_1; // @[Sdc.scala 62:36 63:23 66:23]
  wire  _GEN_1 = reg_clk_counter == 9'h0 ? ~reg_clk : reg_clk; // @[Sdc.scala 62:36 64:15 60:24]
  wire [8:0] _GEN_2 = reg_power ? _GEN_0 : reg_clk_counter; // @[Sdc.scala 61:20 59:32]
  wire  _GEN_3 = reg_power & _GEN_1; // @[Sdc.scala 61:20 69:13]
  reg  rx_res_in_progress; // @[Sdc.scala 73:35]
  reg [7:0] rx_res_counter; // @[Sdc.scala 74:31]
  reg  rx_res_bits_0; // @[Sdc.scala 75:24]
  reg  rx_res_bits_1; // @[Sdc.scala 75:24]
  reg  rx_res_bits_2; // @[Sdc.scala 75:24]
  reg  rx_res_bits_3; // @[Sdc.scala 75:24]
  reg  rx_res_bits_4; // @[Sdc.scala 75:24]
  reg  rx_res_bits_5; // @[Sdc.scala 75:24]
  reg  rx_res_bits_6; // @[Sdc.scala 75:24]
  reg  rx_res_bits_7; // @[Sdc.scala 75:24]
  reg  rx_res_bits_8; // @[Sdc.scala 75:24]
  reg  rx_res_bits_9; // @[Sdc.scala 75:24]
  reg  rx_res_bits_10; // @[Sdc.scala 75:24]
  reg  rx_res_bits_11; // @[Sdc.scala 75:24]
  reg  rx_res_bits_12; // @[Sdc.scala 75:24]
  reg  rx_res_bits_13; // @[Sdc.scala 75:24]
  reg  rx_res_bits_14; // @[Sdc.scala 75:24]
  reg  rx_res_bits_15; // @[Sdc.scala 75:24]
  reg  rx_res_bits_16; // @[Sdc.scala 75:24]
  reg  rx_res_bits_17; // @[Sdc.scala 75:24]
  reg  rx_res_bits_18; // @[Sdc.scala 75:24]
  reg  rx_res_bits_19; // @[Sdc.scala 75:24]
  reg  rx_res_bits_20; // @[Sdc.scala 75:24]
  reg  rx_res_bits_21; // @[Sdc.scala 75:24]
  reg  rx_res_bits_22; // @[Sdc.scala 75:24]
  reg  rx_res_bits_23; // @[Sdc.scala 75:24]
  reg  rx_res_bits_24; // @[Sdc.scala 75:24]
  reg  rx_res_bits_25; // @[Sdc.scala 75:24]
  reg  rx_res_bits_26; // @[Sdc.scala 75:24]
  reg  rx_res_bits_27; // @[Sdc.scala 75:24]
  reg  rx_res_bits_28; // @[Sdc.scala 75:24]
  reg  rx_res_bits_29; // @[Sdc.scala 75:24]
  reg  rx_res_bits_30; // @[Sdc.scala 75:24]
  reg  rx_res_bits_31; // @[Sdc.scala 75:24]
  reg  rx_res_bits_32; // @[Sdc.scala 75:24]
  reg  rx_res_bits_33; // @[Sdc.scala 75:24]
  reg  rx_res_bits_34; // @[Sdc.scala 75:24]
  reg  rx_res_bits_35; // @[Sdc.scala 75:24]
  reg  rx_res_bits_36; // @[Sdc.scala 75:24]
  reg  rx_res_bits_37; // @[Sdc.scala 75:24]
  reg  rx_res_bits_38; // @[Sdc.scala 75:24]
  reg  rx_res_bits_39; // @[Sdc.scala 75:24]
  reg  rx_res_bits_40; // @[Sdc.scala 75:24]
  reg  rx_res_bits_41; // @[Sdc.scala 75:24]
  reg  rx_res_bits_42; // @[Sdc.scala 75:24]
  reg  rx_res_bits_43; // @[Sdc.scala 75:24]
  reg  rx_res_bits_44; // @[Sdc.scala 75:24]
  reg  rx_res_bits_45; // @[Sdc.scala 75:24]
  reg  rx_res_bits_46; // @[Sdc.scala 75:24]
  reg  rx_res_bits_47; // @[Sdc.scala 75:24]
  reg  rx_res_bits_48; // @[Sdc.scala 75:24]
  reg  rx_res_bits_49; // @[Sdc.scala 75:24]
  reg  rx_res_bits_50; // @[Sdc.scala 75:24]
  reg  rx_res_bits_51; // @[Sdc.scala 75:24]
  reg  rx_res_bits_52; // @[Sdc.scala 75:24]
  reg  rx_res_bits_53; // @[Sdc.scala 75:24]
  reg  rx_res_bits_54; // @[Sdc.scala 75:24]
  reg  rx_res_bits_55; // @[Sdc.scala 75:24]
  reg  rx_res_bits_56; // @[Sdc.scala 75:24]
  reg  rx_res_bits_57; // @[Sdc.scala 75:24]
  reg  rx_res_bits_58; // @[Sdc.scala 75:24]
  reg  rx_res_bits_59; // @[Sdc.scala 75:24]
  reg  rx_res_bits_60; // @[Sdc.scala 75:24]
  reg  rx_res_bits_61; // @[Sdc.scala 75:24]
  reg  rx_res_bits_62; // @[Sdc.scala 75:24]
  reg  rx_res_bits_63; // @[Sdc.scala 75:24]
  reg  rx_res_bits_64; // @[Sdc.scala 75:24]
  reg  rx_res_bits_65; // @[Sdc.scala 75:24]
  reg  rx_res_bits_66; // @[Sdc.scala 75:24]
  reg  rx_res_bits_67; // @[Sdc.scala 75:24]
  reg  rx_res_bits_68; // @[Sdc.scala 75:24]
  reg  rx_res_bits_69; // @[Sdc.scala 75:24]
  reg  rx_res_bits_70; // @[Sdc.scala 75:24]
  reg  rx_res_bits_71; // @[Sdc.scala 75:24]
  reg  rx_res_bits_72; // @[Sdc.scala 75:24]
  reg  rx_res_bits_73; // @[Sdc.scala 75:24]
  reg  rx_res_bits_74; // @[Sdc.scala 75:24]
  reg  rx_res_bits_75; // @[Sdc.scala 75:24]
  reg  rx_res_bits_76; // @[Sdc.scala 75:24]
  reg  rx_res_bits_77; // @[Sdc.scala 75:24]
  reg  rx_res_bits_78; // @[Sdc.scala 75:24]
  reg  rx_res_bits_79; // @[Sdc.scala 75:24]
  reg  rx_res_bits_80; // @[Sdc.scala 75:24]
  reg  rx_res_bits_81; // @[Sdc.scala 75:24]
  reg  rx_res_bits_82; // @[Sdc.scala 75:24]
  reg  rx_res_bits_83; // @[Sdc.scala 75:24]
  reg  rx_res_bits_84; // @[Sdc.scala 75:24]
  reg  rx_res_bits_85; // @[Sdc.scala 75:24]
  reg  rx_res_bits_86; // @[Sdc.scala 75:24]
  reg  rx_res_bits_87; // @[Sdc.scala 75:24]
  reg  rx_res_bits_88; // @[Sdc.scala 75:24]
  reg  rx_res_bits_89; // @[Sdc.scala 75:24]
  reg  rx_res_bits_90; // @[Sdc.scala 75:24]
  reg  rx_res_bits_91; // @[Sdc.scala 75:24]
  reg  rx_res_bits_92; // @[Sdc.scala 75:24]
  reg  rx_res_bits_93; // @[Sdc.scala 75:24]
  reg  rx_res_bits_94; // @[Sdc.scala 75:24]
  reg  rx_res_bits_95; // @[Sdc.scala 75:24]
  reg  rx_res_bits_96; // @[Sdc.scala 75:24]
  reg  rx_res_bits_97; // @[Sdc.scala 75:24]
  reg  rx_res_bits_98; // @[Sdc.scala 75:24]
  reg  rx_res_bits_99; // @[Sdc.scala 75:24]
  reg  rx_res_bits_100; // @[Sdc.scala 75:24]
  reg  rx_res_bits_101; // @[Sdc.scala 75:24]
  reg  rx_res_bits_102; // @[Sdc.scala 75:24]
  reg  rx_res_bits_103; // @[Sdc.scala 75:24]
  reg  rx_res_bits_104; // @[Sdc.scala 75:24]
  reg  rx_res_bits_105; // @[Sdc.scala 75:24]
  reg  rx_res_bits_106; // @[Sdc.scala 75:24]
  reg  rx_res_bits_107; // @[Sdc.scala 75:24]
  reg  rx_res_bits_108; // @[Sdc.scala 75:24]
  reg  rx_res_bits_109; // @[Sdc.scala 75:24]
  reg  rx_res_bits_110; // @[Sdc.scala 75:24]
  reg  rx_res_bits_111; // @[Sdc.scala 75:24]
  reg  rx_res_bits_112; // @[Sdc.scala 75:24]
  reg  rx_res_bits_113; // @[Sdc.scala 75:24]
  reg  rx_res_bits_114; // @[Sdc.scala 75:24]
  reg  rx_res_bits_115; // @[Sdc.scala 75:24]
  reg  rx_res_bits_116; // @[Sdc.scala 75:24]
  reg  rx_res_bits_117; // @[Sdc.scala 75:24]
  reg  rx_res_bits_118; // @[Sdc.scala 75:24]
  reg  rx_res_bits_119; // @[Sdc.scala 75:24]
  reg  rx_res_bits_120; // @[Sdc.scala 75:24]
  reg  rx_res_bits_121; // @[Sdc.scala 75:24]
  reg  rx_res_bits_122; // @[Sdc.scala 75:24]
  reg  rx_res_bits_123; // @[Sdc.scala 75:24]
  reg  rx_res_bits_124; // @[Sdc.scala 75:24]
  reg  rx_res_bits_125; // @[Sdc.scala 75:24]
  reg  rx_res_bits_126; // @[Sdc.scala 75:24]
  reg  rx_res_bits_127; // @[Sdc.scala 75:24]
  reg  rx_res_bits_128; // @[Sdc.scala 75:24]
  reg  rx_res_bits_129; // @[Sdc.scala 75:24]
  reg  rx_res_bits_130; // @[Sdc.scala 75:24]
  reg  rx_res_bits_131; // @[Sdc.scala 75:24]
  reg  rx_res_bits_132; // @[Sdc.scala 75:24]
  reg  rx_res_bits_133; // @[Sdc.scala 75:24]
  reg  rx_res_bits_134; // @[Sdc.scala 75:24]
  reg  rx_res_bits_135; // @[Sdc.scala 75:24]
  reg  rx_res_next; // @[Sdc.scala 76:28]
  reg [3:0] rx_res_type; // @[Sdc.scala 77:28]
  reg [135:0] rx_res; // @[Sdc.scala 78:23]
  reg  rx_res_ready; // @[Sdc.scala 79:29]
  reg  rx_res_crc_0; // @[Sdc.scala 80:23]
  reg  rx_res_crc_1; // @[Sdc.scala 80:23]
  reg  rx_res_crc_2; // @[Sdc.scala 80:23]
  reg  rx_res_crc_3; // @[Sdc.scala 80:23]
  reg  rx_res_crc_4; // @[Sdc.scala 80:23]
  reg  rx_res_crc_5; // @[Sdc.scala 80:23]
  reg  rx_res_crc_6; // @[Sdc.scala 80:23]
  reg  rx_res_crc_error; // @[Sdc.scala 81:33]
  reg  rx_res_crc_en; // @[Sdc.scala 82:30]
  reg [7:0] rx_res_timer; // @[Sdc.scala 83:29]
  reg  rx_res_timeout; // @[Sdc.scala 84:31]
  reg [1:0] rx_res_read_counter; // @[Sdc.scala 85:36]
  reg [31:0] tx_cmd_arg; // @[Sdc.scala 86:27]
  reg  tx_cmd_0; // @[Sdc.scala 87:19]
  reg  tx_cmd_1; // @[Sdc.scala 87:19]
  reg  tx_cmd_2; // @[Sdc.scala 87:19]
  reg  tx_cmd_3; // @[Sdc.scala 87:19]
  reg  tx_cmd_4; // @[Sdc.scala 87:19]
  reg  tx_cmd_5; // @[Sdc.scala 87:19]
  reg  tx_cmd_6; // @[Sdc.scala 87:19]
  reg  tx_cmd_7; // @[Sdc.scala 87:19]
  reg  tx_cmd_8; // @[Sdc.scala 87:19]
  reg  tx_cmd_9; // @[Sdc.scala 87:19]
  reg  tx_cmd_10; // @[Sdc.scala 87:19]
  reg  tx_cmd_11; // @[Sdc.scala 87:19]
  reg  tx_cmd_12; // @[Sdc.scala 87:19]
  reg  tx_cmd_13; // @[Sdc.scala 87:19]
  reg  tx_cmd_14; // @[Sdc.scala 87:19]
  reg  tx_cmd_15; // @[Sdc.scala 87:19]
  reg  tx_cmd_16; // @[Sdc.scala 87:19]
  reg  tx_cmd_17; // @[Sdc.scala 87:19]
  reg  tx_cmd_18; // @[Sdc.scala 87:19]
  reg  tx_cmd_19; // @[Sdc.scala 87:19]
  reg  tx_cmd_20; // @[Sdc.scala 87:19]
  reg  tx_cmd_21; // @[Sdc.scala 87:19]
  reg  tx_cmd_22; // @[Sdc.scala 87:19]
  reg  tx_cmd_23; // @[Sdc.scala 87:19]
  reg  tx_cmd_24; // @[Sdc.scala 87:19]
  reg  tx_cmd_25; // @[Sdc.scala 87:19]
  reg  tx_cmd_26; // @[Sdc.scala 87:19]
  reg  tx_cmd_27; // @[Sdc.scala 87:19]
  reg  tx_cmd_28; // @[Sdc.scala 87:19]
  reg  tx_cmd_29; // @[Sdc.scala 87:19]
  reg  tx_cmd_30; // @[Sdc.scala 87:19]
  reg  tx_cmd_31; // @[Sdc.scala 87:19]
  reg  tx_cmd_32; // @[Sdc.scala 87:19]
  reg  tx_cmd_33; // @[Sdc.scala 87:19]
  reg  tx_cmd_34; // @[Sdc.scala 87:19]
  reg  tx_cmd_35; // @[Sdc.scala 87:19]
  reg  tx_cmd_36; // @[Sdc.scala 87:19]
  reg  tx_cmd_37; // @[Sdc.scala 87:19]
  reg  tx_cmd_38; // @[Sdc.scala 87:19]
  reg  tx_cmd_39; // @[Sdc.scala 87:19]
  reg  tx_cmd_40; // @[Sdc.scala 87:19]
  reg  tx_cmd_41; // @[Sdc.scala 87:19]
  reg  tx_cmd_42; // @[Sdc.scala 87:19]
  reg  tx_cmd_43; // @[Sdc.scala 87:19]
  reg  tx_cmd_44; // @[Sdc.scala 87:19]
  reg  tx_cmd_45; // @[Sdc.scala 87:19]
  reg  tx_cmd_46; // @[Sdc.scala 87:19]
  reg  tx_cmd_47; // @[Sdc.scala 87:19]
  reg [5:0] tx_cmd_counter; // @[Sdc.scala 88:31]
  reg  tx_cmd_crc_0; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_1; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_2; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_3; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_4; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_5; // @[Sdc.scala 89:23]
  reg  tx_cmd_crc_6; // @[Sdc.scala 89:23]
  reg [5:0] tx_cmd_timer; // @[Sdc.scala 90:29]
  reg  reg_tx_cmd_wrt; // @[Sdc.scala 91:31]
  reg  reg_tx_cmd_out; // @[Sdc.scala 92:31]
  reg  rx_dat_in_progress; // @[Sdc.scala 93:35]
  reg [10:0] rx_dat_counter; // @[Sdc.scala 94:31]
  reg [7:0] rx_dat_index; // @[Sdc.scala 95:29]
  reg  rx_dat_start_bit; // @[Sdc.scala 96:33]
  reg [3:0] rx_dat_bits_0; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_1; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_2; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_3; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_4; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_5; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_6; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_bits_7; // @[Sdc.scala 97:24]
  reg [3:0] rx_dat_next; // @[Sdc.scala 98:28]
  reg  rx_dat_ready; // @[Sdc.scala 100:29]
  reg [3:0] rx_dat_crc_0; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_1; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_2; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_3; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_4; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_5; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_6; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_7; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_8; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_9; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_10; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_11; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_12; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_13; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_14; // @[Sdc.scala 101:23]
  reg [3:0] rx_dat_crc_15; // @[Sdc.scala 101:23]
  reg  rx_dat_crc_error; // @[Sdc.scala 102:33]
  reg [18:0] rx_dat_timer; // @[Sdc.scala 103:29]
  reg  rx_dat_timeout; // @[Sdc.scala 104:31]
  reg [6:0] rx_dat_read_counter; // @[Sdc.scala 105:36]
  wire  _T_2 = tx_cmd_counter == 6'h0; // @[Sdc.scala 107:48]
  wire  _T_5 = _T & reg_clk; // @[Sdc.scala 109:35]
  wire [7:0] _rx_res_timer_T_1 = rx_res_timer - 8'h1; // @[Sdc.scala 111:38]
  wire [7:0] _GEN_4 = rx_res_timer == 8'h1 ? 8'h0 : rx_res_counter; // @[Sdc.scala 112:37 113:26 74:31]
  wire [135:0] _GEN_5 = rx_res_timer == 8'h1 ? 136'h0 : rx_res; // @[Sdc.scala 112:37 114:18 78:23]
  wire  _GEN_6 = rx_res_timer == 8'h1 | rx_res_ready; // @[Sdc.scala 112:37 115:24 79:29]
  wire  _GEN_7 = rx_res_timer == 8'h1 | rx_res_timeout; // @[Sdc.scala 112:37 116:26 84:31]
  wire [7:0] _GEN_8 = ~rx_res_in_progress & rx_res_next ? _rx_res_timer_T_1 : rx_res_timer; // @[Sdc.scala 110:49 111:22 83:29]
  wire [7:0] _GEN_9 = ~rx_res_in_progress & rx_res_next ? _GEN_4 : rx_res_counter; // @[Sdc.scala 110:49 74:31]
  wire [135:0] _GEN_10 = ~rx_res_in_progress & rx_res_next ? _GEN_5 : rx_res; // @[Sdc.scala 110:49 78:23]
  wire  _GEN_11 = ~rx_res_in_progress & rx_res_next ? _GEN_6 : rx_res_ready; // @[Sdc.scala 110:49 79:29]
  wire  _GEN_12 = ~rx_res_in_progress & rx_res_next ? _GEN_7 : rx_res_timeout; // @[Sdc.scala 110:49 84:31]
  wire [7:0] _rx_res_counter_T_1 = rx_res_counter - 8'h1; // @[Sdc.scala 122:42]
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
  wire  _GEN_13 = rx_res_counter == 8'h1 ? 1'h0 : 1'h1; // @[Sdc.scala 123:28 133:39 135:30]
  wire [136:0] _GEN_14 = rx_res_counter == 8'h1 ? _rx_res_T_1 : {{1'd0}, _GEN_10}; // @[Sdc.scala 133:39 136:18]
  wire  _GEN_15 = rx_res_counter == 8'h1 | _GEN_11; // @[Sdc.scala 133:39 137:24]
  wire  _GEN_16 = rx_res_counter == 8'h1 ? rx_res_crc_en & _rx_res_crc_error_T != 7'h0 : rx_res_crc_error; // @[Sdc.scala 133:39 138:28 81:33]
  wire [5:0] _GEN_17 = rx_res_counter == 8'h1 ? 6'h30 : tx_cmd_timer; // @[Sdc.scala 133:39 139:24 90:29]
  wire [7:0] _GEN_154 = rx_res_in_progress | ~rx_res_next ? _rx_res_counter_T_1 : _GEN_9; // @[Sdc.scala 119:49 122:24]
  wire  _GEN_155 = rx_res_in_progress | ~rx_res_next ? _GEN_13 : rx_res_in_progress; // @[Sdc.scala 119:49 73:35]
  wire  _GEN_156 = rx_res_in_progress | ~rx_res_next ? rx_res_next ^ rx_res_crc_6 : rx_res_crc_0; // @[Sdc.scala 119:49 125:23 80:23]
  wire  _GEN_157 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_0 : rx_res_crc_1; // @[Sdc.scala 119:49 126:23 80:23]
  wire  _GEN_158 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_1 : rx_res_crc_2; // @[Sdc.scala 119:49 127:23 80:23]
  wire  _GEN_159 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_2 ^ rx_res_crc_6 : rx_res_crc_3; // @[Sdc.scala 119:49 128:23 80:23]
  wire  _GEN_160 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_3 : rx_res_crc_4; // @[Sdc.scala 119:49 129:23 80:23]
  wire  _GEN_161 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_4 : rx_res_crc_5; // @[Sdc.scala 119:49 130:23 80:23]
  wire  _GEN_162 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_5 : rx_res_crc_6; // @[Sdc.scala 119:49 131:23 80:23]
  wire [136:0] _GEN_163 = rx_res_in_progress | ~rx_res_next ? _GEN_14 : {{1'd0}, _GEN_10}; // @[Sdc.scala 119:49]
  wire  _GEN_164 = rx_res_in_progress | ~rx_res_next ? _GEN_15 : _GEN_11; // @[Sdc.scala 119:49]
  wire  _GEN_165 = rx_res_in_progress | ~rx_res_next ? _GEN_16 : rx_res_crc_error; // @[Sdc.scala 119:49 81:33]
  wire [5:0] _GEN_166 = rx_res_in_progress | ~rx_res_next ? _GEN_17 : tx_cmd_timer; // @[Sdc.scala 119:49 90:29]
  wire [7:0] _GEN_167 = _T & reg_clk ? _GEN_8 : rx_res_timer; // @[Sdc.scala 109:47 83:29]
  wire [7:0] _GEN_168 = _T & reg_clk ? _GEN_154 : rx_res_counter; // @[Sdc.scala 109:47 74:31]
  wire [136:0] _GEN_169 = _T & reg_clk ? _GEN_163 : {{1'd0}, rx_res}; // @[Sdc.scala 109:47 78:23]
  wire  _GEN_170 = _T & reg_clk ? _GEN_164 : rx_res_ready; // @[Sdc.scala 109:47 79:29]
  wire  _GEN_171 = _T & reg_clk ? _GEN_12 : rx_res_timeout; // @[Sdc.scala 109:47 84:31]
  wire  _GEN_308 = _T & reg_clk ? _GEN_155 : rx_res_in_progress; // @[Sdc.scala 109:47 73:35]
  wire  _GEN_309 = _T & reg_clk ? _GEN_156 : rx_res_crc_0; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_310 = _T & reg_clk ? _GEN_157 : rx_res_crc_1; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_311 = _T & reg_clk ? _GEN_158 : rx_res_crc_2; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_312 = _T & reg_clk ? _GEN_159 : rx_res_crc_3; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_313 = _T & reg_clk ? _GEN_160 : rx_res_crc_4; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_314 = _T & reg_clk ? _GEN_161 : rx_res_crc_5; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_315 = _T & reg_clk ? _GEN_162 : rx_res_crc_6; // @[Sdc.scala 109:47 80:23]
  wire  _GEN_316 = _T & reg_clk ? _GEN_165 : rx_res_crc_error; // @[Sdc.scala 109:47 81:33]
  wire [7:0] _GEN_319 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_167 : rx_res_timer; // @[Sdc.scala 107:57 83:29]
  wire [7:0] _GEN_320 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_168 : rx_res_counter; // @[Sdc.scala 107:57 74:31]
  wire [136:0] _GEN_321 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_169 : {{1'd0}, rx_res}; // @[Sdc.scala 107:57 78:23]
  wire  _GEN_322 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_170 : rx_res_ready; // @[Sdc.scala 107:57 79:29]
  wire  _GEN_323 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_171 : rx_res_timeout; // @[Sdc.scala 107:57 84:31]
  wire  _GEN_460 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_308 : rx_res_in_progress; // @[Sdc.scala 107:57 73:35]
  wire  _GEN_461 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_309 : rx_res_crc_0; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_462 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_310 : rx_res_crc_1; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_463 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_311 : rx_res_crc_2; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_464 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_312 : rx_res_crc_3; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_465 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_313 : rx_res_crc_4; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_466 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_314 : rx_res_crc_5; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_467 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_315 : rx_res_crc_6; // @[Sdc.scala 107:57 80:23]
  wire  _GEN_468 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_316 : rx_res_crc_error; // @[Sdc.scala 107:57 81:33]
  wire [5:0] _tx_cmd_timer_T_1 = tx_cmd_timer - 6'h1; // @[Sdc.scala 149:34]
  wire [5:0] _tx_cmd_counter_T_1 = tx_cmd_counter - 6'h1; // @[Sdc.scala 156:38]
  wire  crc_0 = tx_cmd_7 ^ tx_cmd_crc_6; // @[Sdc.scala 159:17]
  wire  crc_3 = tx_cmd_crc_2 ^ tx_cmd_crc_6; // @[Sdc.scala 162:21]
  wire  _GEN_470 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_5 : tx_cmd_1; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_471 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_4 : tx_cmd_2; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_472 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_3 : tx_cmd_3; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_473 = tx_cmd_counter == 6'h9 ? crc_3 : tx_cmd_4; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_474 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_1 : tx_cmd_5; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_475 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_0 : tx_cmd_6; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_476 = tx_cmd_counter == 6'h9 ? crc_0 : tx_cmd_7; // @[Sdc.scala 170:35 171:39 155:48]
  wire  _GEN_477 = _T_2 & _T & reg_clk ? 1'h0 : reg_tx_cmd_wrt; // @[Sdc.scala 174:77 175:20 91:31]
  wire  _GEN_479 = tx_cmd_counter > 6'h0 & _T & reg_clk | _GEN_477; // @[Sdc.scala 152:75 153:20]
  wire  _GEN_481 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_470 : tx_cmd_0; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_482 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_471 : tx_cmd_1; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_483 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_472 : tx_cmd_2; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_484 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_473 : tx_cmd_3; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_485 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_474 : tx_cmd_4; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_486 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_475 : tx_cmd_5; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_487 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_476 : tx_cmd_6; // @[Sdc.scala 152:75 87:19]
  wire  _GEN_488 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_8 : tx_cmd_7; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_489 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_9 : tx_cmd_8; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_490 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_10 : tx_cmd_9; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_491 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_11 : tx_cmd_10; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_492 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_12 : tx_cmd_11; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_493 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_13 : tx_cmd_12; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_494 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_14 : tx_cmd_13; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_495 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_15 : tx_cmd_14; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_496 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_16 : tx_cmd_15; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_497 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_17 : tx_cmd_16; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_498 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_18 : tx_cmd_17; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_499 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_19 : tx_cmd_18; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_500 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_20 : tx_cmd_19; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_501 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_21 : tx_cmd_20; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_502 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_22 : tx_cmd_21; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_503 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_23 : tx_cmd_22; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_504 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_24 : tx_cmd_23; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_505 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_25 : tx_cmd_24; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_506 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_26 : tx_cmd_25; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_507 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_27 : tx_cmd_26; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_508 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_28 : tx_cmd_27; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_509 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_29 : tx_cmd_28; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_510 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_30 : tx_cmd_29; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_511 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_31 : tx_cmd_30; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_512 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_32 : tx_cmd_31; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_513 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_33 : tx_cmd_32; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_514 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_34 : tx_cmd_33; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_515 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_35 : tx_cmd_34; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_516 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_36 : tx_cmd_35; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_517 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_37 : tx_cmd_36; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_518 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_38 : tx_cmd_37; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_519 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_39 : tx_cmd_38; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_520 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_40 : tx_cmd_39; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_521 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_41 : tx_cmd_40; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_522 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_42 : tx_cmd_41; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_523 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_43 : tx_cmd_42; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_524 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_44 : tx_cmd_43; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_525 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_45 : tx_cmd_44; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_526 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_46 : tx_cmd_45; // @[Sdc.scala 152:75 155:48 87:19]
  wire  _GEN_527 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_47 : tx_cmd_46; // @[Sdc.scala 152:75 155:48 87:19]
  wire [5:0] _GEN_528 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _tx_cmd_counter_T_1 : tx_cmd_counter; // @[Sdc.scala 152:75 156:20 88:31]
  wire  _GEN_529 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc_0 : tx_cmd_crc_0; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_530 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : tx_cmd_crc_1; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_531 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : tx_cmd_crc_2; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_532 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc_3 : tx_cmd_crc_3; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_533 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : tx_cmd_crc_4; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_534 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : tx_cmd_crc_5; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_535 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : tx_cmd_crc_6; // @[Sdc.scala 152:75 167:16 89:23]
  wire  _GEN_539 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_481; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_540 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_482; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_541 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_483; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_542 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_484; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_543 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_485; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_544 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_486; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_545 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_487; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_546 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_488; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_547 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_489; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_548 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_490; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_549 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_491; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_550 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_492; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_551 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_493; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_552 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_494; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_553 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_495; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_554 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_496; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_555 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_497; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_556 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_498; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_557 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_499; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_558 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_500; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_559 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_501; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_560 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_502; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_561 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_503; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_562 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_504; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_563 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_505; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_564 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_506; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_565 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_507; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_566 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_508; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_567 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_509; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_568 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_510; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_569 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_511; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_570 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_512; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_571 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_513; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_572 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_514; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_573 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_515; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_574 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_516; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_575 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_517; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_576 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_518; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_577 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_519; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_578 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_520; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_579 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_521; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_580 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_522; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_581 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_523; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_582 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_524; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_583 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_525; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_584 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_526; // @[Sdc.scala 148:69 87:19]
  wire  _GEN_585 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_527; // @[Sdc.scala 148:69 87:19]
  wire [5:0] _GEN_586 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_528; // @[Sdc.scala 148:69 88:31]
  wire  _GEN_587 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_529; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_588 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_530; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_589 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_531; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_590 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_532; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_591 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_533; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_592 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_534; // @[Sdc.scala 148:69 89:23]
  wire  _GEN_593 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_535; // @[Sdc.scala 148:69 89:23]
  wire  _T_27 = rx_dat_counter > 11'h0 & _T_2; // @[Sdc.scala 182:30]
  wire  _T_30 = ~rx_dat_in_progress; // @[Sdc.scala 185:13]
  wire [18:0] _rx_dat_timer_T_1 = rx_dat_timer - 19'h1; // @[Sdc.scala 186:38]
  wire [10:0] _GEN_594 = rx_dat_timer == 19'h1 ? 11'h0 : rx_dat_counter; // @[Sdc.scala 187:37 188:26 94:31]
  wire  _GEN_595 = rx_dat_timer == 19'h1 | rx_dat_ready; // @[Sdc.scala 187:37 189:24 100:29]
  wire  _GEN_596 = rx_dat_timer == 19'h1 | rx_dat_timeout; // @[Sdc.scala 187:37 190:26 104:31]
  wire [10:0] _rx_dat_counter_T_1 = rx_dat_counter - 11'h1; // @[Sdc.scala 197:42]
  wire [3:0] _rx_dat_crc_0_T = rx_dat_next ^ rx_dat_crc_15; // @[Sdc.scala 199:38]
  wire [3:0] _rx_dat_crc_5_T = rx_dat_crc_4 ^ rx_dat_crc_15; // @[Sdc.scala 204:40]
  wire [3:0] _rx_dat_crc_12_T = rx_dat_crc_11 ^ rx_dat_crc_15; // @[Sdc.scala 211:42]
  wire  _T_42 = ~rx_dat_start_bit; // @[Sdc.scala 217:17]
  wire [7:0] _rx_dat_index_T_1 = rx_dat_index + 8'h1; // @[Sdc.scala 218:42]
  wire [15:0] lo = {rx_dat_bits_5,rx_dat_bits_4,rx_dat_bits_7,rx_dat_bits_6}; // @[Cat.scala 31:58]
  wire [15:0] hi = {rx_dat_bits_1,rx_dat_bits_0,rx_dat_bits_3,rx_dat_bits_2}; // @[Cat.scala 31:58]
  wire [7:0] _GEN_597 = ~rx_dat_start_bit ? _rx_dat_index_T_1 : rx_dat_index; // @[Sdc.scala 217:36 218:26 95:29]
  wire  _GEN_603 = rx_dat_counter[2:0] == 3'h1 ? 1'h0 : rx_dat_start_bit; // @[Sdc.scala 215:45 216:28 96:33]
  wire [7:0] _GEN_604 = rx_dat_counter[2:0] == 3'h1 ? _GEN_597 : rx_dat_index; // @[Sdc.scala 215:45 95:29]
  wire  _GEN_607 = rx_dat_counter[2:0] == 3'h1 & _T_42; // @[Sdc.scala 215:45 99:19]
  wire [31:0] rx_dat_crc_error_lo = {rx_dat_crc_8,rx_dat_crc_9,rx_dat_crc_10,rx_dat_crc_11,rx_dat_crc_12,rx_dat_crc_13,
    rx_dat_crc_14,rx_dat_crc_15}; // @[Cat.scala 31:58]
  wire [63:0] _rx_dat_crc_error_T = {rx_dat_crc_0,rx_dat_crc_1,rx_dat_crc_2,rx_dat_crc_3,rx_dat_crc_4,rx_dat_crc_5,
    rx_dat_crc_6,rx_dat_crc_7,rx_dat_crc_error_lo}; // @[Cat.scala 31:58]
  wire  _GEN_610 = rx_dat_counter == 11'h1 ? 1'h0 : rx_dat_in_progress; // @[Sdc.scala 227:39 228:30 93:35]
  wire  _GEN_611 = rx_dat_counter == 11'h1 | rx_dat_ready; // @[Sdc.scala 227:39 229:24 100:29]
  wire  _GEN_612 = rx_dat_counter == 11'h1 ? _rx_dat_crc_error_T != 64'h0 : rx_dat_crc_error; // @[Sdc.scala 227:39 230:28 102:33]
  wire  _GEN_613 = _T_30 & ~rx_dat_next[0] | _GEN_610; // @[Sdc.scala 192:66 193:28]
  wire [10:0] _GEN_622 = _T_30 & ~rx_dat_next[0] ? rx_dat_counter : _rx_dat_counter_T_1; // @[Sdc.scala 192:66 197:24 94:31]
  wire [3:0] _GEN_623 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_0 : _rx_dat_crc_0_T; // @[Sdc.scala 101:23 192:66 199:23]
  wire [3:0] _GEN_624 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_1 : rx_dat_crc_0; // @[Sdc.scala 101:23 192:66 200:23]
  wire [3:0] _GEN_625 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_2 : rx_dat_crc_1; // @[Sdc.scala 101:23 192:66 201:23]
  wire [3:0] _GEN_626 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_3 : rx_dat_crc_2; // @[Sdc.scala 101:23 192:66 202:23]
  wire [3:0] _GEN_627 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_4 : rx_dat_crc_3; // @[Sdc.scala 101:23 192:66 203:23]
  wire [3:0] _GEN_628 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_5 : _rx_dat_crc_5_T; // @[Sdc.scala 101:23 192:66 204:23]
  wire [3:0] _GEN_629 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_6 : rx_dat_crc_5; // @[Sdc.scala 101:23 192:66 205:23]
  wire [3:0] _GEN_630 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_7 : rx_dat_crc_6; // @[Sdc.scala 101:23 192:66 206:23]
  wire [3:0] _GEN_631 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_8 : rx_dat_crc_7; // @[Sdc.scala 101:23 192:66 207:23]
  wire [3:0] _GEN_632 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_9 : rx_dat_crc_8; // @[Sdc.scala 101:23 192:66 208:23]
  wire [3:0] _GEN_633 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_10 : rx_dat_crc_9; // @[Sdc.scala 101:23 192:66 209:24]
  wire [3:0] _GEN_634 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_11 : rx_dat_crc_10; // @[Sdc.scala 101:23 192:66 210:24]
  wire [3:0] _GEN_635 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_12 : _rx_dat_crc_12_T; // @[Sdc.scala 101:23 192:66 211:24]
  wire [3:0] _GEN_636 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_13 : rx_dat_crc_12; // @[Sdc.scala 101:23 192:66 212:24]
  wire [3:0] _GEN_637 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_14 : rx_dat_crc_13; // @[Sdc.scala 101:23 192:66 213:24]
  wire [3:0] _GEN_638 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_15 : rx_dat_crc_14; // @[Sdc.scala 101:23 192:66 214:24]
  wire  _GEN_639 = _T_30 & ~rx_dat_next[0] ? rx_dat_start_bit : _GEN_603; // @[Sdc.scala 192:66 96:33]
  wire [7:0] _GEN_640 = _T_30 & ~rx_dat_next[0] ? rx_dat_index : _GEN_604; // @[Sdc.scala 192:66 95:29]
  wire  _GEN_643 = _T_30 & ~rx_dat_next[0] ? 1'h0 : _GEN_607; // @[Sdc.scala 192:66 99:19]
  wire  _GEN_646 = _T_30 & ~rx_dat_next[0] ? rx_dat_ready : _GEN_611; // @[Sdc.scala 100:29 192:66]
  wire  _GEN_647 = _T_30 & ~rx_dat_next[0] ? rx_dat_crc_error : _GEN_612; // @[Sdc.scala 102:33 192:66]
  wire [18:0] _GEN_648 = ~rx_dat_in_progress & rx_dat_next[0] ? _rx_dat_timer_T_1 : rx_dat_timer; // @[Sdc.scala 185:59 186:22 103:29]
  wire [10:0] _GEN_649 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_594 : _GEN_622; // @[Sdc.scala 185:59]
  wire  _GEN_650 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_595 : _GEN_646; // @[Sdc.scala 185:59]
  wire  _GEN_651 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_596 : rx_dat_timeout; // @[Sdc.scala 104:31 185:59]
  wire  _GEN_652 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_in_progress : _GEN_613; // @[Sdc.scala 185:59 93:35]
  wire [3:0] _GEN_661 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_0 : _GEN_623; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_662 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_1 : _GEN_624; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_663 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_2 : _GEN_625; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_664 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_3 : _GEN_626; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_665 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_4 : _GEN_627; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_666 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_5 : _GEN_628; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_667 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_6 : _GEN_629; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_668 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_7 : _GEN_630; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_669 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_8 : _GEN_631; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_670 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_9 : _GEN_632; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_671 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_10 : _GEN_633; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_672 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_11 : _GEN_634; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_673 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_12 : _GEN_635; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_674 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_13 : _GEN_636; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_675 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_14 : _GEN_637; // @[Sdc.scala 101:23 185:59]
  wire [3:0] _GEN_676 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_15 : _GEN_638; // @[Sdc.scala 101:23 185:59]
  wire  _GEN_677 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_start_bit : _GEN_639; // @[Sdc.scala 185:59 96:33]
  wire [7:0] _GEN_678 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_index : _GEN_640; // @[Sdc.scala 185:59 95:29]
  wire  _GEN_681 = ~rx_dat_in_progress & rx_dat_next[0] ? 1'h0 : _GEN_643; // @[Sdc.scala 185:59 99:19]
  wire  _GEN_684 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_error : _GEN_647; // @[Sdc.scala 102:33 185:59]
  wire [18:0] _GEN_685 = _T_5 ? _GEN_648 : rx_dat_timer; // @[Sdc.scala 103:29 184:47]
  wire [10:0] _GEN_686 = _T_5 ? _GEN_649 : rx_dat_counter; // @[Sdc.scala 184:47 94:31]
  wire  _GEN_687 = _T_5 ? _GEN_650 : rx_dat_ready; // @[Sdc.scala 100:29 184:47]
  wire  _GEN_688 = _T_5 ? _GEN_651 : rx_dat_timeout; // @[Sdc.scala 104:31 184:47]
  wire  _GEN_689 = _T_5 ? _GEN_652 : rx_dat_in_progress; // @[Sdc.scala 184:47 93:35]
  wire [3:0] _GEN_698 = _T_5 ? _GEN_661 : rx_dat_crc_0; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_699 = _T_5 ? _GEN_662 : rx_dat_crc_1; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_700 = _T_5 ? _GEN_663 : rx_dat_crc_2; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_701 = _T_5 ? _GEN_664 : rx_dat_crc_3; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_702 = _T_5 ? _GEN_665 : rx_dat_crc_4; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_703 = _T_5 ? _GEN_666 : rx_dat_crc_5; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_704 = _T_5 ? _GEN_667 : rx_dat_crc_6; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_705 = _T_5 ? _GEN_668 : rx_dat_crc_7; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_706 = _T_5 ? _GEN_669 : rx_dat_crc_8; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_707 = _T_5 ? _GEN_670 : rx_dat_crc_9; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_708 = _T_5 ? _GEN_671 : rx_dat_crc_10; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_709 = _T_5 ? _GEN_672 : rx_dat_crc_11; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_710 = _T_5 ? _GEN_673 : rx_dat_crc_12; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_711 = _T_5 ? _GEN_674 : rx_dat_crc_13; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_712 = _T_5 ? _GEN_675 : rx_dat_crc_14; // @[Sdc.scala 101:23 184:47]
  wire [3:0] _GEN_713 = _T_5 ? _GEN_676 : rx_dat_crc_15; // @[Sdc.scala 101:23 184:47]
  wire  _GEN_714 = _T_5 ? _GEN_677 : rx_dat_start_bit; // @[Sdc.scala 184:47 96:33]
  wire [7:0] _GEN_715 = _T_5 ? _GEN_678 : rx_dat_index; // @[Sdc.scala 184:47 95:29]
  wire  _GEN_718 = _T_5 & _GEN_681; // @[Sdc.scala 184:47 99:19]
  wire  _GEN_721 = _T_5 ? _GEN_684 : rx_dat_crc_error; // @[Sdc.scala 102:33 184:47]
  wire [18:0] _GEN_723 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_685 : rx_dat_timer; // @[Sdc.scala 103:29 182:57]
  wire [10:0] _GEN_724 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_686 : rx_dat_counter; // @[Sdc.scala 182:57 94:31]
  wire  _GEN_725 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_687 : rx_dat_ready; // @[Sdc.scala 100:29 182:57]
  wire  _GEN_726 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_688 : rx_dat_timeout; // @[Sdc.scala 104:31 182:57]
  wire  _GEN_727 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_689 : rx_dat_in_progress; // @[Sdc.scala 182:57 93:35]
  wire [3:0] _GEN_736 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_698 : rx_dat_crc_0; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_737 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_699 : rx_dat_crc_1; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_738 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_700 : rx_dat_crc_2; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_739 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_701 : rx_dat_crc_3; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_740 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_702 : rx_dat_crc_4; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_741 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_703 : rx_dat_crc_5; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_742 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_704 : rx_dat_crc_6; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_743 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_705 : rx_dat_crc_7; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_744 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_706 : rx_dat_crc_8; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_745 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_707 : rx_dat_crc_9; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_746 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_708 : rx_dat_crc_10; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_747 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_709 : rx_dat_crc_11; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_748 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_710 : rx_dat_crc_12; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_749 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_711 : rx_dat_crc_13; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_750 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_712 : rx_dat_crc_14; // @[Sdc.scala 101:23 182:57]
  wire [3:0] _GEN_751 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_713 : rx_dat_crc_15; // @[Sdc.scala 101:23 182:57]
  wire  _GEN_752 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_714 : rx_dat_start_bit; // @[Sdc.scala 182:57 96:33]
  wire [7:0] _GEN_753 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_715 : rx_dat_index; // @[Sdc.scala 182:57 95:29]
  wire  _GEN_759 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_721 : rx_dat_crc_error; // @[Sdc.scala 102:33 182:57]
  wire [1:0] addr = io_mem_waddr[3:2]; // @[Sdc.scala 242:28]
  wire [8:0] baud_divider = io_mem_wdata[8:0]; // @[Sdc.scala 245:40]
  wire [47:0] tx_cmd_val = {2'h1,io_mem_wdata[9:4],tx_cmd_arg,7'h0,1'h1}; // @[Cat.scala 31:58]
  wire  _GEN_764 = io_mem_wdata[3:0] == 4'h3 ? 1'h0 : 1'h1; // @[Sdc.scala 263:25 272:59 274:27]
  wire [7:0] _GEN_765 = io_mem_wdata[3:0] == 4'h2 ? 8'h88 : 8'h30; // @[Sdc.scala 269:59 270:28]
  wire  _GEN_766 = io_mem_wdata[3:0] == 4'h2 ? 1'h0 : _GEN_764; // @[Sdc.scala 269:59 271:27]
  wire [7:0] _GEN_767 = io_mem_wdata[3:0] == 4'h0 ? 8'h0 : _GEN_765; // @[Sdc.scala 267:55 268:28]
  wire  _GEN_768 = io_mem_wdata[3:0] == 4'h0 | _GEN_766; // @[Sdc.scala 263:25 267:55]
  wire  _GEN_769 = io_mem_wdata[12] ? 1'h0 : _GEN_727; // @[Sdc.scala 278:42 279:32]
  wire [10:0] _GEN_770 = io_mem_wdata[12] ? 11'h411 : 11'h0; // @[Sdc.scala 278:42 280:28 290:28]
  wire [7:0] _GEN_771 = io_mem_wdata[12] ? 8'h0 : _GEN_753; // @[Sdc.scala 278:42 281:26]
  wire  _GEN_772 = io_mem_wdata[12] | _GEN_752; // @[Sdc.scala 278:42 282:30]
  wire [3:0] _GEN_774 = io_mem_wdata[12] ? 4'h0 : _GEN_736; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_775 = io_mem_wdata[12] ? 4'h0 : _GEN_737; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_776 = io_mem_wdata[12] ? 4'h0 : _GEN_738; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_777 = io_mem_wdata[12] ? 4'h0 : _GEN_739; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_778 = io_mem_wdata[12] ? 4'h0 : _GEN_740; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_779 = io_mem_wdata[12] ? 4'h0 : _GEN_741; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_780 = io_mem_wdata[12] ? 4'h0 : _GEN_742; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_781 = io_mem_wdata[12] ? 4'h0 : _GEN_743; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_782 = io_mem_wdata[12] ? 4'h0 : _GEN_744; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_783 = io_mem_wdata[12] ? 4'h0 : _GEN_745; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_784 = io_mem_wdata[12] ? 4'h0 : _GEN_746; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_785 = io_mem_wdata[12] ? 4'h0 : _GEN_747; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_786 = io_mem_wdata[12] ? 4'h0 : _GEN_748; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_787 = io_mem_wdata[12] ? 4'h0 : _GEN_749; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_788 = io_mem_wdata[12] ? 4'h0 : _GEN_750; // @[Sdc.scala 278:42 284:24]
  wire [3:0] _GEN_789 = io_mem_wdata[12] ? 4'h0 : _GEN_751; // @[Sdc.scala 278:42 284:24]
  wire  _GEN_790 = io_mem_wdata[12] ? 1'h0 : _GEN_759; // @[Sdc.scala 278:42 285:30]
  wire [18:0] _GEN_791 = io_mem_wdata[12] ? 19'h7a120 : _GEN_723; // @[Sdc.scala 278:42 286:26]
  wire  _GEN_792 = io_mem_wdata[12] ? 1'h0 : _GEN_726; // @[Sdc.scala 278:42 287:28]
  wire [6:0] _GEN_793 = io_mem_wdata[12] ? 7'h0 : rx_dat_read_counter; // @[Sdc.scala 278:42 288:33 105:36]
  wire [5:0] _GEN_842 = io_mem_wdata[11] ? 6'h30 : _GEN_586; // @[Sdc.scala 253:40 256:26]
  wire [3:0] _GEN_850 = io_mem_wdata[11] ? io_mem_wdata[3:0] : rx_res_type; // @[Sdc.scala 253:40 258:23 77:28]
  wire  _GEN_851 = io_mem_wdata[11] ? 1'h0 : _GEN_460; // @[Sdc.scala 253:40 259:30]
  wire  _GEN_852 = io_mem_wdata[11] ? 1'h0 : _GEN_322; // @[Sdc.scala 253:40 260:24]
  wire  _GEN_860 = io_mem_wdata[11] ? 1'h0 : _GEN_468; // @[Sdc.scala 253:40 262:28]
  wire  _GEN_861 = io_mem_wdata[11] ? _GEN_768 : rx_res_crc_en; // @[Sdc.scala 253:40 82:30]
  wire [7:0] _GEN_862 = io_mem_wdata[11] ? 8'hff : _GEN_319; // @[Sdc.scala 253:40 264:24]
  wire  _GEN_863 = io_mem_wdata[11] ? 1'h0 : _GEN_323; // @[Sdc.scala 253:40 265:26]
  wire [1:0] _GEN_864 = io_mem_wdata[11] ? 2'h0 : rx_res_read_counter; // @[Sdc.scala 253:40 266:31 85:36]
  wire [7:0] _GEN_865 = io_mem_wdata[11] ? _GEN_767 : _GEN_320; // @[Sdc.scala 253:40]
  wire  _GEN_866 = io_mem_wdata[11] ? _GEN_769 : _GEN_727; // @[Sdc.scala 253:40]
  wire [10:0] _GEN_867 = io_mem_wdata[11] ? _GEN_770 : _GEN_724; // @[Sdc.scala 253:40]
  wire [7:0] _GEN_868 = io_mem_wdata[11] ? _GEN_771 : _GEN_753; // @[Sdc.scala 253:40]
  wire  _GEN_869 = io_mem_wdata[11] ? _GEN_772 : _GEN_752; // @[Sdc.scala 253:40]
  wire  _GEN_870 = io_mem_wdata[11] ? 1'h0 : _GEN_725; // @[Sdc.scala 253:40]
  wire  _GEN_887 = io_mem_wdata[11] ? _GEN_790 : _GEN_759; // @[Sdc.scala 253:40]
  wire [18:0] _GEN_888 = io_mem_wdata[11] ? _GEN_791 : _GEN_723; // @[Sdc.scala 253:40]
  wire  _GEN_889 = io_mem_wdata[11] ? _GEN_792 : _GEN_726; // @[Sdc.scala 253:40]
  wire [6:0] _GEN_890 = io_mem_wdata[11] ? _GEN_793 : rx_dat_read_counter; // @[Sdc.scala 105:36 253:40]
  wire [31:0] _GEN_891 = 2'h2 == addr ? io_mem_wdata : tx_cmd_arg; // @[Sdc.scala 243:19 296:20 86:27]
  wire  _GEN_950 = 2'h1 == addr ? _GEN_852 : _GEN_322; // @[Sdc.scala 243:19]
  wire [1:0] _GEN_962 = 2'h1 == addr ? _GEN_864 : rx_res_read_counter; // @[Sdc.scala 243:19 85:36]
  wire  _GEN_968 = 2'h1 == addr ? _GEN_870 : _GEN_725; // @[Sdc.scala 243:19]
  wire [6:0] _GEN_988 = 2'h1 == addr ? _GEN_890 : rx_dat_read_counter; // @[Sdc.scala 243:19 105:36]
  wire  _GEN_1051 = 2'h0 == addr ? _GEN_322 : _GEN_950; // @[Sdc.scala 243:19]
  wire [1:0] _GEN_1063 = 2'h0 == addr ? rx_res_read_counter : _GEN_962; // @[Sdc.scala 243:19 85:36]
  wire  _GEN_1069 = 2'h0 == addr ? _GEN_725 : _GEN_968; // @[Sdc.scala 243:19]
  wire [6:0] _GEN_1089 = 2'h0 == addr ? rx_dat_read_counter : _GEN_988; // @[Sdc.scala 243:19 105:36]
  wire  _GEN_1152 = io_mem_wen ? _GEN_1051 : _GEN_322; // @[Sdc.scala 241:21]
  wire [1:0] _GEN_1164 = io_mem_wen ? _GEN_1063 : rx_res_read_counter; // @[Sdc.scala 241:21 85:36]
  wire  _GEN_1170 = io_mem_wen ? _GEN_1069 : _GEN_725; // @[Sdc.scala 241:21]
  wire [6:0] _GEN_1190 = io_mem_wen ? _GEN_1089 : rx_dat_read_counter; // @[Sdc.scala 241:21 105:36]
  wire [1:0] addr_1 = io_mem_raddr[3:2]; // @[Sdc.scala 301:28]
  wire [31:0] _io_mem_rdata_T_2 = {13'h0,rx_dat_timeout,rx_dat_crc_error,rx_dat_ready,13'h0,rx_res_timeout,
    rx_res_crc_error,rx_res_ready}; // @[Cat.scala 31:58]
  wire [1:0] _rx_res_read_counter_T_1 = rx_res_read_counter + 2'h1; // @[Sdc.scala 316:52]
  wire [6:0] _io_mem_rdata_T_3 = {rx_res_read_counter,5'h0}; // @[Cat.scala 31:58]
  wire [135:0] _io_mem_rdata_T_4 = rx_res >> _io_mem_rdata_T_3; // @[Sdc.scala 318:35]
  wire  _GEN_1192 = rx_res_read_counter == 2'h3 ? 1'h0 : _GEN_1152; // @[Sdc.scala 319:46 320:26]
  wire [31:0] _GEN_1193 = rx_res_type == 4'h2 ? _io_mem_rdata_T_4[31:0] : rx_res[39:8]; // @[Sdc.scala 317:44 318:24 323:24]
  wire  _GEN_1194 = rx_res_type == 4'h2 & _GEN_1192; // @[Sdc.scala 317:44 324:24]
  wire [6:0] _rx_dat_read_counter_T_1 = rx_dat_read_counter + 7'h1; // @[Sdc.scala 328:52]
  wire  _GEN_1195 = rx_dat_read_counter == 7'h7f ? 1'h0 : _GEN_1170; // @[Sdc.scala 330:46 331:24]
  wire [6:0] _GEN_1196 = 2'h3 == addr_1 ? _rx_dat_read_counter_T_1 : _GEN_1190; // @[Sdc.scala 302:19 328:29]
  wire [31:0] _GEN_1200 = 2'h3 == addr_1 ? rx_dat_io_mem_rdata_MPORT_data : 32'hdeadbeef; // @[Sdc.scala 236:16 302:19 329:22]
  wire  _GEN_1201 = 2'h3 == addr_1 ? _GEN_1195 : _GEN_1170; // @[Sdc.scala 302:19]
  wire [31:0] _GEN_1203 = 2'h2 == addr_1 ? _GEN_1193 : _GEN_1200; // @[Sdc.scala 302:19]
  wire  _GEN_1208 = 2'h2 == addr_1 ? 1'h0 : 2'h3 == addr_1; // @[Sdc.scala 302:19 99:19]
  wire [31:0] _GEN_1210 = 2'h1 == addr_1 ? _io_mem_rdata_T_2 : _GEN_1203; // @[Sdc.scala 302:19 304:22]
  wire  _GEN_1216 = 2'h1 == addr_1 ? 1'h0 : _GEN_1208; // @[Sdc.scala 302:19 99:19]
  wire  _T_122 = ~reset; // @[Sdc.scala 337:9]
  wire [136:0] _GEN_1226 = reset ? 137'h0 : _GEN_321; // @[Sdc.scala 78:{23,23}]
  assign rx_dat_io_mem_rdata_MPORT_en = io_mem_ren & _GEN_1216;
  assign rx_dat_io_mem_rdata_MPORT_addr = {{1'd0}, rx_dat_read_counter};
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign rx_dat_io_mem_rdata_MPORT_data = rx_dat[rx_dat_io_mem_rdata_MPORT_addr]; // @[Sdc.scala 99:19]
  `else
  assign rx_dat_io_mem_rdata_MPORT_data = rx_dat_io_mem_rdata_MPORT_addr >= 8'h82 ? _RAND_1[31:0] :
    rx_dat[rx_dat_io_mem_rdata_MPORT_addr]; // @[Sdc.scala 99:19]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign rx_dat_MPORT_data = {hi,lo};
  assign rx_dat_MPORT_addr = rx_dat_index;
  assign rx_dat_MPORT_mask = 1'h1;
  assign rx_dat_MPORT_en = _T_27 & _GEN_718;
  assign io_mem_rdata = io_mem_ren ? _GEN_1210 : 32'hdeadbeef; // @[Sdc.scala 236:16 300:21]
  assign io_sdc_port_clk = reg_clk; // @[Sdc.scala 71:19]
  assign io_sdc_port_cmd_wrt = reg_tx_cmd_wrt; // @[Sdc.scala 145:23]
  assign io_sdc_port_cmd_out = reg_tx_cmd_out; // @[Sdc.scala 146:23]
  always @(posedge clock) begin
    if (rx_dat_MPORT_en & rx_dat_MPORT_mask) begin
      rx_dat[rx_dat_MPORT_addr] <= rx_dat_MPORT_data; // @[Sdc.scala 99:19]
    end
    if (reset) begin // @[Sdc.scala 57:26]
      reg_power <= 1'h0; // @[Sdc.scala 57:26]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 246:37]
          reg_power <= io_mem_wdata[31]; // @[Sdc.scala 247:21]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 58:33]
      reg_baud_divider <= 9'h2; // @[Sdc.scala 58:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 246:37]
          reg_baud_divider <= baud_divider; // @[Sdc.scala 248:28]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 59:32]
      reg_clk_counter <= 9'h2; // @[Sdc.scala 59:32]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 246:37]
          reg_clk_counter <= baud_divider; // @[Sdc.scala 249:27]
        end else begin
          reg_clk_counter <= _GEN_2;
        end
      end else begin
        reg_clk_counter <= _GEN_2;
      end
    end else begin
      reg_clk_counter <= _GEN_2;
    end
    if (reset) begin // @[Sdc.scala 60:24]
      reg_clk <= 1'h0; // @[Sdc.scala 60:24]
    end else begin
      reg_clk <= _GEN_3;
    end
    if (reset) begin // @[Sdc.scala 73:35]
      rx_res_in_progress <= 1'h0; // @[Sdc.scala 73:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_in_progress <= _GEN_460;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_res_in_progress <= _GEN_851;
      end else begin
        rx_res_in_progress <= _GEN_460;
      end
    end else begin
      rx_res_in_progress <= _GEN_460;
    end
    if (reset) begin // @[Sdc.scala 74:31]
      rx_res_counter <= 8'h0; // @[Sdc.scala 74:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_counter <= _GEN_320;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_res_counter <= _GEN_865;
      end else begin
        rx_res_counter <= _GEN_320;
      end
    end else begin
      rx_res_counter <= _GEN_320;
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_0 <= rx_res_next; // @[Sdc.scala 121:24]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_1 <= rx_res_bits_0; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_2 <= rx_res_bits_1; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_3 <= rx_res_bits_2; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_4 <= rx_res_bits_3; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_5 <= rx_res_bits_4; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_6 <= rx_res_bits_5; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_7 <= rx_res_bits_6; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_8 <= rx_res_bits_7; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_9 <= rx_res_bits_8; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_10 <= rx_res_bits_9; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_11 <= rx_res_bits_10; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_12 <= rx_res_bits_11; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_13 <= rx_res_bits_12; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_14 <= rx_res_bits_13; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_15 <= rx_res_bits_14; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_16 <= rx_res_bits_15; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_17 <= rx_res_bits_16; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_18 <= rx_res_bits_17; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_19 <= rx_res_bits_18; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_20 <= rx_res_bits_19; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_21 <= rx_res_bits_20; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_22 <= rx_res_bits_21; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_23 <= rx_res_bits_22; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_24 <= rx_res_bits_23; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_25 <= rx_res_bits_24; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_26 <= rx_res_bits_25; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_27 <= rx_res_bits_26; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_28 <= rx_res_bits_27; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_29 <= rx_res_bits_28; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_30 <= rx_res_bits_29; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_31 <= rx_res_bits_30; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_32 <= rx_res_bits_31; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_33 <= rx_res_bits_32; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_34 <= rx_res_bits_33; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_35 <= rx_res_bits_34; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_36 <= rx_res_bits_35; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_37 <= rx_res_bits_36; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_38 <= rx_res_bits_37; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_39 <= rx_res_bits_38; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_40 <= rx_res_bits_39; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_41 <= rx_res_bits_40; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_42 <= rx_res_bits_41; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_43 <= rx_res_bits_42; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_44 <= rx_res_bits_43; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_45 <= rx_res_bits_44; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_46 <= rx_res_bits_45; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_47 <= rx_res_bits_46; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_48 <= rx_res_bits_47; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_49 <= rx_res_bits_48; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_50 <= rx_res_bits_49; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_51 <= rx_res_bits_50; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_52 <= rx_res_bits_51; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_53 <= rx_res_bits_52; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_54 <= rx_res_bits_53; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_55 <= rx_res_bits_54; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_56 <= rx_res_bits_55; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_57 <= rx_res_bits_56; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_58 <= rx_res_bits_57; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_59 <= rx_res_bits_58; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_60 <= rx_res_bits_59; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_61 <= rx_res_bits_60; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_62 <= rx_res_bits_61; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_63 <= rx_res_bits_62; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_64 <= rx_res_bits_63; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_65 <= rx_res_bits_64; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_66 <= rx_res_bits_65; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_67 <= rx_res_bits_66; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_68 <= rx_res_bits_67; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_69 <= rx_res_bits_68; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_70 <= rx_res_bits_69; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_71 <= rx_res_bits_70; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_72 <= rx_res_bits_71; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_73 <= rx_res_bits_72; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_74 <= rx_res_bits_73; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_75 <= rx_res_bits_74; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_76 <= rx_res_bits_75; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_77 <= rx_res_bits_76; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_78 <= rx_res_bits_77; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_79 <= rx_res_bits_78; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_80 <= rx_res_bits_79; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_81 <= rx_res_bits_80; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_82 <= rx_res_bits_81; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_83 <= rx_res_bits_82; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_84 <= rx_res_bits_83; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_85 <= rx_res_bits_84; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_86 <= rx_res_bits_85; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_87 <= rx_res_bits_86; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_88 <= rx_res_bits_87; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_89 <= rx_res_bits_88; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_90 <= rx_res_bits_89; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_91 <= rx_res_bits_90; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_92 <= rx_res_bits_91; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_93 <= rx_res_bits_92; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_94 <= rx_res_bits_93; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_95 <= rx_res_bits_94; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_96 <= rx_res_bits_95; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_97 <= rx_res_bits_96; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_98 <= rx_res_bits_97; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_99 <= rx_res_bits_98; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_100 <= rx_res_bits_99; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_101 <= rx_res_bits_100; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_102 <= rx_res_bits_101; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_103 <= rx_res_bits_102; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_104 <= rx_res_bits_103; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_105 <= rx_res_bits_104; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_106 <= rx_res_bits_105; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_107 <= rx_res_bits_106; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_108 <= rx_res_bits_107; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_109 <= rx_res_bits_108; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_110 <= rx_res_bits_109; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_111 <= rx_res_bits_110; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_112 <= rx_res_bits_111; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_113 <= rx_res_bits_112; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_114 <= rx_res_bits_113; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_115 <= rx_res_bits_114; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_116 <= rx_res_bits_115; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_117 <= rx_res_bits_116; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_118 <= rx_res_bits_117; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_119 <= rx_res_bits_118; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_120 <= rx_res_bits_119; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_121 <= rx_res_bits_120; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_122 <= rx_res_bits_121; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_123 <= rx_res_bits_122; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_124 <= rx_res_bits_123; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_125 <= rx_res_bits_124; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_126 <= rx_res_bits_125; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_127 <= rx_res_bits_126; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_128 <= rx_res_bits_127; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_129 <= rx_res_bits_128; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_130 <= rx_res_bits_129; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_131 <= rx_res_bits_130; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_132 <= rx_res_bits_131; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_133 <= rx_res_bits_132; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_134 <= rx_res_bits_133; // @[Sdc.scala 120:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 119:49]
          rx_res_bits_135 <= rx_res_bits_134; // @[Sdc.scala 120:61]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 76:28]
      rx_res_next <= 1'h0; // @[Sdc.scala 76:28]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      rx_res_next <= io_sdc_port_res_in; // @[Sdc.scala 108:17]
    end
    if (reset) begin // @[Sdc.scala 77:28]
      rx_res_type <= 4'h0; // @[Sdc.scala 77:28]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 243:19]
        if (2'h1 == addr) begin // @[Sdc.scala 243:19]
          rx_res_type <= _GEN_850;
        end
      end
    end
    rx_res <= _GEN_1226[135:0]; // @[Sdc.scala 78:{23,23}]
    if (reset) begin // @[Sdc.scala 79:29]
      rx_res_ready <= 1'h0; // @[Sdc.scala 79:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 300:21]
      if (2'h1 == addr_1) begin // @[Sdc.scala 302:19]
        rx_res_ready <= _GEN_1152;
      end else if (2'h2 == addr_1) begin // @[Sdc.scala 302:19]
        rx_res_ready <= _GEN_1194;
      end else begin
        rx_res_ready <= _GEN_1152;
      end
    end else begin
      rx_res_ready <= _GEN_1152;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_0 <= _GEN_461;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_0 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_0 <= _GEN_461;
        end
      end else begin
        rx_res_crc_0 <= _GEN_461;
      end
    end else begin
      rx_res_crc_0 <= _GEN_461;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_1 <= _GEN_462;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_1 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_1 <= _GEN_462;
        end
      end else begin
        rx_res_crc_1 <= _GEN_462;
      end
    end else begin
      rx_res_crc_1 <= _GEN_462;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_2 <= _GEN_463;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_2 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_2 <= _GEN_463;
        end
      end else begin
        rx_res_crc_2 <= _GEN_463;
      end
    end else begin
      rx_res_crc_2 <= _GEN_463;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_3 <= _GEN_464;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_3 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_3 <= _GEN_464;
        end
      end else begin
        rx_res_crc_3 <= _GEN_464;
      end
    end else begin
      rx_res_crc_3 <= _GEN_464;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_4 <= _GEN_465;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_4 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_4 <= _GEN_465;
        end
      end else begin
        rx_res_crc_4 <= _GEN_465;
      end
    end else begin
      rx_res_crc_4 <= _GEN_465;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_5 <= _GEN_466;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_5 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_5 <= _GEN_466;
        end
      end else begin
        rx_res_crc_5 <= _GEN_466;
      end
    end else begin
      rx_res_crc_5 <= _GEN_466;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_6 <= _GEN_467;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_res_crc_6 <= 1'h0; // @[Sdc.scala 261:22]
        end else begin
          rx_res_crc_6 <= _GEN_467;
        end
      end else begin
        rx_res_crc_6 <= _GEN_467;
      end
    end else begin
      rx_res_crc_6 <= _GEN_467;
    end
    if (reset) begin // @[Sdc.scala 81:33]
      rx_res_crc_error <= 1'h0; // @[Sdc.scala 81:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_error <= _GEN_468;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_res_crc_error <= _GEN_860;
      end else begin
        rx_res_crc_error <= _GEN_468;
      end
    end else begin
      rx_res_crc_error <= _GEN_468;
    end
    if (reset) begin // @[Sdc.scala 82:30]
      rx_res_crc_en <= 1'h0; // @[Sdc.scala 82:30]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 243:19]
        if (2'h1 == addr) begin // @[Sdc.scala 243:19]
          rx_res_crc_en <= _GEN_861;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 83:29]
      rx_res_timer <= 8'h0; // @[Sdc.scala 83:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_timer <= _GEN_319;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_res_timer <= _GEN_862;
      end else begin
        rx_res_timer <= _GEN_319;
      end
    end else begin
      rx_res_timer <= _GEN_319;
    end
    if (reset) begin // @[Sdc.scala 84:31]
      rx_res_timeout <= 1'h0; // @[Sdc.scala 84:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_res_timeout <= _GEN_323;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_res_timeout <= _GEN_863;
      end else begin
        rx_res_timeout <= _GEN_323;
      end
    end else begin
      rx_res_timeout <= _GEN_323;
    end
    if (reset) begin // @[Sdc.scala 85:36]
      rx_res_read_counter <= 2'h0; // @[Sdc.scala 85:36]
    end else if (io_mem_ren) begin // @[Sdc.scala 300:21]
      if (2'h1 == addr_1) begin // @[Sdc.scala 302:19]
        rx_res_read_counter <= _GEN_1164;
      end else if (2'h2 == addr_1) begin // @[Sdc.scala 302:19]
        rx_res_read_counter <= _rx_res_read_counter_T_1; // @[Sdc.scala 316:29]
      end else begin
        rx_res_read_counter <= _GEN_1164;
      end
    end else begin
      rx_res_read_counter <= _GEN_1164;
    end
    if (reset) begin // @[Sdc.scala 86:27]
      tx_cmd_arg <= 32'h0; // @[Sdc.scala 86:27]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 243:19]
        if (!(2'h1 == addr)) begin // @[Sdc.scala 243:19]
          tx_cmd_arg <= _GEN_891;
        end
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_0 <= _GEN_539;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_0 <= tx_cmd_val[47]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_0 <= _GEN_539;
        end
      end else begin
        tx_cmd_0 <= _GEN_539;
      end
    end else begin
      tx_cmd_0 <= _GEN_539;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_1 <= _GEN_540;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_1 <= tx_cmd_val[46]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_1 <= _GEN_540;
        end
      end else begin
        tx_cmd_1 <= _GEN_540;
      end
    end else begin
      tx_cmd_1 <= _GEN_540;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_2 <= _GEN_541;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_2 <= tx_cmd_val[45]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_2 <= _GEN_541;
        end
      end else begin
        tx_cmd_2 <= _GEN_541;
      end
    end else begin
      tx_cmd_2 <= _GEN_541;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_3 <= _GEN_542;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_3 <= tx_cmd_val[44]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_3 <= _GEN_542;
        end
      end else begin
        tx_cmd_3 <= _GEN_542;
      end
    end else begin
      tx_cmd_3 <= _GEN_542;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_4 <= _GEN_543;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_4 <= tx_cmd_val[43]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_4 <= _GEN_543;
        end
      end else begin
        tx_cmd_4 <= _GEN_543;
      end
    end else begin
      tx_cmd_4 <= _GEN_543;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_5 <= _GEN_544;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_5 <= tx_cmd_val[42]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_5 <= _GEN_544;
        end
      end else begin
        tx_cmd_5 <= _GEN_544;
      end
    end else begin
      tx_cmd_5 <= _GEN_544;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_6 <= _GEN_545;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_6 <= tx_cmd_val[41]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_6 <= _GEN_545;
        end
      end else begin
        tx_cmd_6 <= _GEN_545;
      end
    end else begin
      tx_cmd_6 <= _GEN_545;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_7 <= _GEN_546;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_7 <= tx_cmd_val[40]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_7 <= _GEN_546;
        end
      end else begin
        tx_cmd_7 <= _GEN_546;
      end
    end else begin
      tx_cmd_7 <= _GEN_546;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_8 <= _GEN_547;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_8 <= tx_cmd_val[39]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_8 <= _GEN_547;
        end
      end else begin
        tx_cmd_8 <= _GEN_547;
      end
    end else begin
      tx_cmd_8 <= _GEN_547;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_9 <= _GEN_548;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_9 <= tx_cmd_val[38]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_9 <= _GEN_548;
        end
      end else begin
        tx_cmd_9 <= _GEN_548;
      end
    end else begin
      tx_cmd_9 <= _GEN_548;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_10 <= _GEN_549;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_10 <= tx_cmd_val[37]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_10 <= _GEN_549;
        end
      end else begin
        tx_cmd_10 <= _GEN_549;
      end
    end else begin
      tx_cmd_10 <= _GEN_549;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_11 <= _GEN_550;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_11 <= tx_cmd_val[36]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_11 <= _GEN_550;
        end
      end else begin
        tx_cmd_11 <= _GEN_550;
      end
    end else begin
      tx_cmd_11 <= _GEN_550;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_12 <= _GEN_551;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_12 <= tx_cmd_val[35]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_12 <= _GEN_551;
        end
      end else begin
        tx_cmd_12 <= _GEN_551;
      end
    end else begin
      tx_cmd_12 <= _GEN_551;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_13 <= _GEN_552;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_13 <= tx_cmd_val[34]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_13 <= _GEN_552;
        end
      end else begin
        tx_cmd_13 <= _GEN_552;
      end
    end else begin
      tx_cmd_13 <= _GEN_552;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_14 <= _GEN_553;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_14 <= tx_cmd_val[33]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_14 <= _GEN_553;
        end
      end else begin
        tx_cmd_14 <= _GEN_553;
      end
    end else begin
      tx_cmd_14 <= _GEN_553;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_15 <= _GEN_554;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_15 <= tx_cmd_val[32]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_15 <= _GEN_554;
        end
      end else begin
        tx_cmd_15 <= _GEN_554;
      end
    end else begin
      tx_cmd_15 <= _GEN_554;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_16 <= _GEN_555;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_16 <= tx_cmd_val[31]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_16 <= _GEN_555;
        end
      end else begin
        tx_cmd_16 <= _GEN_555;
      end
    end else begin
      tx_cmd_16 <= _GEN_555;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_17 <= _GEN_556;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_17 <= tx_cmd_val[30]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_17 <= _GEN_556;
        end
      end else begin
        tx_cmd_17 <= _GEN_556;
      end
    end else begin
      tx_cmd_17 <= _GEN_556;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_18 <= _GEN_557;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_18 <= tx_cmd_val[29]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_18 <= _GEN_557;
        end
      end else begin
        tx_cmd_18 <= _GEN_557;
      end
    end else begin
      tx_cmd_18 <= _GEN_557;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_19 <= _GEN_558;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_19 <= tx_cmd_val[28]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_19 <= _GEN_558;
        end
      end else begin
        tx_cmd_19 <= _GEN_558;
      end
    end else begin
      tx_cmd_19 <= _GEN_558;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_20 <= _GEN_559;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_20 <= tx_cmd_val[27]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_20 <= _GEN_559;
        end
      end else begin
        tx_cmd_20 <= _GEN_559;
      end
    end else begin
      tx_cmd_20 <= _GEN_559;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_21 <= _GEN_560;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_21 <= tx_cmd_val[26]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_21 <= _GEN_560;
        end
      end else begin
        tx_cmd_21 <= _GEN_560;
      end
    end else begin
      tx_cmd_21 <= _GEN_560;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_22 <= _GEN_561;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_22 <= tx_cmd_val[25]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_22 <= _GEN_561;
        end
      end else begin
        tx_cmd_22 <= _GEN_561;
      end
    end else begin
      tx_cmd_22 <= _GEN_561;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_23 <= _GEN_562;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_23 <= tx_cmd_val[24]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_23 <= _GEN_562;
        end
      end else begin
        tx_cmd_23 <= _GEN_562;
      end
    end else begin
      tx_cmd_23 <= _GEN_562;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_24 <= _GEN_563;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_24 <= tx_cmd_val[23]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_24 <= _GEN_563;
        end
      end else begin
        tx_cmd_24 <= _GEN_563;
      end
    end else begin
      tx_cmd_24 <= _GEN_563;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_25 <= _GEN_564;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_25 <= tx_cmd_val[22]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_25 <= _GEN_564;
        end
      end else begin
        tx_cmd_25 <= _GEN_564;
      end
    end else begin
      tx_cmd_25 <= _GEN_564;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_26 <= _GEN_565;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_26 <= tx_cmd_val[21]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_26 <= _GEN_565;
        end
      end else begin
        tx_cmd_26 <= _GEN_565;
      end
    end else begin
      tx_cmd_26 <= _GEN_565;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_27 <= _GEN_566;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_27 <= tx_cmd_val[20]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_27 <= _GEN_566;
        end
      end else begin
        tx_cmd_27 <= _GEN_566;
      end
    end else begin
      tx_cmd_27 <= _GEN_566;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_28 <= _GEN_567;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_28 <= tx_cmd_val[19]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_28 <= _GEN_567;
        end
      end else begin
        tx_cmd_28 <= _GEN_567;
      end
    end else begin
      tx_cmd_28 <= _GEN_567;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_29 <= _GEN_568;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_29 <= tx_cmd_val[18]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_29 <= _GEN_568;
        end
      end else begin
        tx_cmd_29 <= _GEN_568;
      end
    end else begin
      tx_cmd_29 <= _GEN_568;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_30 <= _GEN_569;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_30 <= tx_cmd_val[17]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_30 <= _GEN_569;
        end
      end else begin
        tx_cmd_30 <= _GEN_569;
      end
    end else begin
      tx_cmd_30 <= _GEN_569;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_31 <= _GEN_570;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_31 <= tx_cmd_val[16]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_31 <= _GEN_570;
        end
      end else begin
        tx_cmd_31 <= _GEN_570;
      end
    end else begin
      tx_cmd_31 <= _GEN_570;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_32 <= _GEN_571;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_32 <= tx_cmd_val[15]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_32 <= _GEN_571;
        end
      end else begin
        tx_cmd_32 <= _GEN_571;
      end
    end else begin
      tx_cmd_32 <= _GEN_571;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_33 <= _GEN_572;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_33 <= tx_cmd_val[14]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_33 <= _GEN_572;
        end
      end else begin
        tx_cmd_33 <= _GEN_572;
      end
    end else begin
      tx_cmd_33 <= _GEN_572;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_34 <= _GEN_573;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_34 <= tx_cmd_val[13]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_34 <= _GEN_573;
        end
      end else begin
        tx_cmd_34 <= _GEN_573;
      end
    end else begin
      tx_cmd_34 <= _GEN_573;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_35 <= _GEN_574;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_35 <= tx_cmd_val[12]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_35 <= _GEN_574;
        end
      end else begin
        tx_cmd_35 <= _GEN_574;
      end
    end else begin
      tx_cmd_35 <= _GEN_574;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_36 <= _GEN_575;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_36 <= tx_cmd_val[11]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_36 <= _GEN_575;
        end
      end else begin
        tx_cmd_36 <= _GEN_575;
      end
    end else begin
      tx_cmd_36 <= _GEN_575;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_37 <= _GEN_576;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_37 <= tx_cmd_val[10]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_37 <= _GEN_576;
        end
      end else begin
        tx_cmd_37 <= _GEN_576;
      end
    end else begin
      tx_cmd_37 <= _GEN_576;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_38 <= _GEN_577;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_38 <= tx_cmd_val[9]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_38 <= _GEN_577;
        end
      end else begin
        tx_cmd_38 <= _GEN_577;
      end
    end else begin
      tx_cmd_38 <= _GEN_577;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_39 <= _GEN_578;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_39 <= tx_cmd_val[8]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_39 <= _GEN_578;
        end
      end else begin
        tx_cmd_39 <= _GEN_578;
      end
    end else begin
      tx_cmd_39 <= _GEN_578;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_40 <= _GEN_579;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_40 <= tx_cmd_val[7]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_40 <= _GEN_579;
        end
      end else begin
        tx_cmd_40 <= _GEN_579;
      end
    end else begin
      tx_cmd_40 <= _GEN_579;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_41 <= _GEN_580;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_41 <= tx_cmd_val[6]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_41 <= _GEN_580;
        end
      end else begin
        tx_cmd_41 <= _GEN_580;
      end
    end else begin
      tx_cmd_41 <= _GEN_580;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_42 <= _GEN_581;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_42 <= tx_cmd_val[5]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_42 <= _GEN_581;
        end
      end else begin
        tx_cmd_42 <= _GEN_581;
      end
    end else begin
      tx_cmd_42 <= _GEN_581;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_43 <= _GEN_582;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_43 <= tx_cmd_val[4]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_43 <= _GEN_582;
        end
      end else begin
        tx_cmd_43 <= _GEN_582;
      end
    end else begin
      tx_cmd_43 <= _GEN_582;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_44 <= _GEN_583;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_44 <= tx_cmd_val[3]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_44 <= _GEN_583;
        end
      end else begin
        tx_cmd_44 <= _GEN_583;
      end
    end else begin
      tx_cmd_44 <= _GEN_583;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_45 <= _GEN_584;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_45 <= tx_cmd_val[2]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_45 <= _GEN_584;
        end
      end else begin
        tx_cmd_45 <= _GEN_584;
      end
    end else begin
      tx_cmd_45 <= _GEN_584;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_46 <= _GEN_585;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_46 <= tx_cmd_val[1]; // @[Sdc.scala 255:18]
        end else begin
          tx_cmd_46 <= _GEN_585;
        end
      end else begin
        tx_cmd_46 <= _GEN_585;
      end
    end else begin
      tx_cmd_46 <= _GEN_585;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 243:19]
        if (2'h1 == addr) begin // @[Sdc.scala 243:19]
          if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
            tx_cmd_47 <= tx_cmd_val[0]; // @[Sdc.scala 255:18]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 88:31]
      tx_cmd_counter <= 6'h0; // @[Sdc.scala 88:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_counter <= _GEN_586;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_counter <= _GEN_842;
      end else begin
        tx_cmd_counter <= _GEN_586;
      end
    end else begin
      tx_cmd_counter <= _GEN_586;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_0 <= _GEN_587;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_0 <= tx_cmd_val[41]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_0 <= _GEN_587;
        end
      end else begin
        tx_cmd_crc_0 <= _GEN_587;
      end
    end else begin
      tx_cmd_crc_0 <= _GEN_587;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_1 <= _GEN_588;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_1 <= tx_cmd_val[42]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_1 <= _GEN_588;
        end
      end else begin
        tx_cmd_crc_1 <= _GEN_588;
      end
    end else begin
      tx_cmd_crc_1 <= _GEN_588;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_2 <= _GEN_589;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_2 <= tx_cmd_val[43]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_2 <= _GEN_589;
        end
      end else begin
        tx_cmd_crc_2 <= _GEN_589;
      end
    end else begin
      tx_cmd_crc_2 <= _GEN_589;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_3 <= _GEN_590;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_3 <= tx_cmd_val[44]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_3 <= _GEN_590;
        end
      end else begin
        tx_cmd_crc_3 <= _GEN_590;
      end
    end else begin
      tx_cmd_crc_3 <= _GEN_590;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_4 <= _GEN_591;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_4 <= tx_cmd_val[45]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_4 <= _GEN_591;
        end
      end else begin
        tx_cmd_crc_4 <= _GEN_591;
      end
    end else begin
      tx_cmd_crc_4 <= _GEN_591;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_5 <= _GEN_592;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_5 <= tx_cmd_val[46]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_5 <= _GEN_592;
        end
      end else begin
        tx_cmd_crc_5 <= _GEN_592;
      end
    end else begin
      tx_cmd_crc_5 <= _GEN_592;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        tx_cmd_crc_6 <= _GEN_593;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          tx_cmd_crc_6 <= tx_cmd_val[47]; // @[Sdc.scala 257:22]
        end else begin
          tx_cmd_crc_6 <= _GEN_593;
        end
      end else begin
        tx_cmd_crc_6 <= _GEN_593;
      end
    end else begin
      tx_cmd_crc_6 <= _GEN_593;
    end
    if (reset) begin // @[Sdc.scala 90:29]
      tx_cmd_timer <= 6'h0; // @[Sdc.scala 90:29]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 148:69]
      tx_cmd_timer <= _tx_cmd_timer_T_1; // @[Sdc.scala 149:18]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 107:57]
      if (_T & reg_clk) begin // @[Sdc.scala 109:47]
        tx_cmd_timer <= _GEN_166;
      end
    end
    if (reset) begin // @[Sdc.scala 91:31]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 91:31]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 148:69]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 150:20]
    end else begin
      reg_tx_cmd_wrt <= _GEN_479;
    end
    if (reset) begin // @[Sdc.scala 92:31]
      reg_tx_cmd_out <= 1'h0; // @[Sdc.scala 92:31]
    end else if (tx_cmd_counter > 6'h0 & _T & reg_clk) begin // @[Sdc.scala 152:75]
      reg_tx_cmd_out <= tx_cmd_0; // @[Sdc.scala 154:20]
    end
    if (reset) begin // @[Sdc.scala 93:35]
      rx_dat_in_progress <= 1'h0; // @[Sdc.scala 93:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_in_progress <= _GEN_727;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_in_progress <= _GEN_866;
      end else begin
        rx_dat_in_progress <= _GEN_727;
      end
    end else begin
      rx_dat_in_progress <= _GEN_727;
    end
    if (reset) begin // @[Sdc.scala 94:31]
      rx_dat_counter <= 11'h0; // @[Sdc.scala 94:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_counter <= _GEN_724;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_counter <= _GEN_867;
      end else begin
        rx_dat_counter <= _GEN_724;
      end
    end else begin
      rx_dat_counter <= _GEN_724;
    end
    if (reset) begin // @[Sdc.scala 95:29]
      rx_dat_index <= 8'h0; // @[Sdc.scala 95:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_index <= _GEN_753;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_index <= _GEN_868;
      end else begin
        rx_dat_index <= _GEN_753;
      end
    end else begin
      rx_dat_index <= _GEN_753;
    end
    if (reset) begin // @[Sdc.scala 96:33]
      rx_dat_start_bit <= 1'h0; // @[Sdc.scala 96:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_start_bit <= _GEN_752;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_start_bit <= _GEN_869;
      end else begin
        rx_dat_start_bit <= _GEN_752;
      end
    end else begin
      rx_dat_start_bit <= _GEN_752;
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_0 <= rx_dat_next; // @[Sdc.scala 196:24]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_1 <= rx_dat_bits_0; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_2 <= rx_dat_bits_1; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_3 <= rx_dat_bits_2; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_4 <= rx_dat_bits_3; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_5 <= rx_dat_bits_4; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_6 <= rx_dat_bits_5; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      if (_T_5) begin // @[Sdc.scala 184:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 185:59]
          if (!(_T_30 & ~rx_dat_next[0])) begin // @[Sdc.scala 192:66]
            rx_dat_bits_7 <= rx_dat_bits_6; // @[Sdc.scala 195:50]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 98:28]
      rx_dat_next <= 4'h0; // @[Sdc.scala 98:28]
    end else if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 182:57]
      rx_dat_next <= io_sdc_port_dat_in; // @[Sdc.scala 183:17]
    end
    if (reset) begin // @[Sdc.scala 100:29]
      rx_dat_ready <= 1'h0; // @[Sdc.scala 100:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 300:21]
      if (2'h1 == addr_1) begin // @[Sdc.scala 302:19]
        rx_dat_ready <= _GEN_1170;
      end else if (2'h2 == addr_1) begin // @[Sdc.scala 302:19]
        rx_dat_ready <= _GEN_1170;
      end else begin
        rx_dat_ready <= _GEN_1201;
      end
    end else begin
      rx_dat_ready <= _GEN_1170;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_0 <= _GEN_736;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_0 <= _GEN_774;
        end else begin
          rx_dat_crc_0 <= _GEN_736;
        end
      end else begin
        rx_dat_crc_0 <= _GEN_736;
      end
    end else begin
      rx_dat_crc_0 <= _GEN_736;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_1 <= _GEN_737;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_1 <= _GEN_775;
        end else begin
          rx_dat_crc_1 <= _GEN_737;
        end
      end else begin
        rx_dat_crc_1 <= _GEN_737;
      end
    end else begin
      rx_dat_crc_1 <= _GEN_737;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_2 <= _GEN_738;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_2 <= _GEN_776;
        end else begin
          rx_dat_crc_2 <= _GEN_738;
        end
      end else begin
        rx_dat_crc_2 <= _GEN_738;
      end
    end else begin
      rx_dat_crc_2 <= _GEN_738;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_3 <= _GEN_739;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_3 <= _GEN_777;
        end else begin
          rx_dat_crc_3 <= _GEN_739;
        end
      end else begin
        rx_dat_crc_3 <= _GEN_739;
      end
    end else begin
      rx_dat_crc_3 <= _GEN_739;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_4 <= _GEN_740;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_4 <= _GEN_778;
        end else begin
          rx_dat_crc_4 <= _GEN_740;
        end
      end else begin
        rx_dat_crc_4 <= _GEN_740;
      end
    end else begin
      rx_dat_crc_4 <= _GEN_740;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_5 <= _GEN_741;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_5 <= _GEN_779;
        end else begin
          rx_dat_crc_5 <= _GEN_741;
        end
      end else begin
        rx_dat_crc_5 <= _GEN_741;
      end
    end else begin
      rx_dat_crc_5 <= _GEN_741;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_6 <= _GEN_742;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_6 <= _GEN_780;
        end else begin
          rx_dat_crc_6 <= _GEN_742;
        end
      end else begin
        rx_dat_crc_6 <= _GEN_742;
      end
    end else begin
      rx_dat_crc_6 <= _GEN_742;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_7 <= _GEN_743;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_7 <= _GEN_781;
        end else begin
          rx_dat_crc_7 <= _GEN_743;
        end
      end else begin
        rx_dat_crc_7 <= _GEN_743;
      end
    end else begin
      rx_dat_crc_7 <= _GEN_743;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_8 <= _GEN_744;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_8 <= _GEN_782;
        end else begin
          rx_dat_crc_8 <= _GEN_744;
        end
      end else begin
        rx_dat_crc_8 <= _GEN_744;
      end
    end else begin
      rx_dat_crc_8 <= _GEN_744;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_9 <= _GEN_745;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_9 <= _GEN_783;
        end else begin
          rx_dat_crc_9 <= _GEN_745;
        end
      end else begin
        rx_dat_crc_9 <= _GEN_745;
      end
    end else begin
      rx_dat_crc_9 <= _GEN_745;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_10 <= _GEN_746;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_10 <= _GEN_784;
        end else begin
          rx_dat_crc_10 <= _GEN_746;
        end
      end else begin
        rx_dat_crc_10 <= _GEN_746;
      end
    end else begin
      rx_dat_crc_10 <= _GEN_746;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_11 <= _GEN_747;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_11 <= _GEN_785;
        end else begin
          rx_dat_crc_11 <= _GEN_747;
        end
      end else begin
        rx_dat_crc_11 <= _GEN_747;
      end
    end else begin
      rx_dat_crc_11 <= _GEN_747;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_12 <= _GEN_748;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_12 <= _GEN_786;
        end else begin
          rx_dat_crc_12 <= _GEN_748;
        end
      end else begin
        rx_dat_crc_12 <= _GEN_748;
      end
    end else begin
      rx_dat_crc_12 <= _GEN_748;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_13 <= _GEN_749;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_13 <= _GEN_787;
        end else begin
          rx_dat_crc_13 <= _GEN_749;
        end
      end else begin
        rx_dat_crc_13 <= _GEN_749;
      end
    end else begin
      rx_dat_crc_13 <= _GEN_749;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_14 <= _GEN_750;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_14 <= _GEN_788;
        end else begin
          rx_dat_crc_14 <= _GEN_750;
        end
      end else begin
        rx_dat_crc_14 <= _GEN_750;
      end
    end else begin
      rx_dat_crc_14 <= _GEN_750;
    end
    if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_15 <= _GEN_751;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 253:40]
          rx_dat_crc_15 <= _GEN_789;
        end else begin
          rx_dat_crc_15 <= _GEN_751;
        end
      end else begin
        rx_dat_crc_15 <= _GEN_751;
      end
    end else begin
      rx_dat_crc_15 <= _GEN_751;
    end
    if (reset) begin // @[Sdc.scala 102:33]
      rx_dat_crc_error <= 1'h0; // @[Sdc.scala 102:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_error <= _GEN_759;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_crc_error <= _GEN_887;
      end else begin
        rx_dat_crc_error <= _GEN_759;
      end
    end else begin
      rx_dat_crc_error <= _GEN_759;
    end
    if (reset) begin // @[Sdc.scala 103:29]
      rx_dat_timer <= 19'h0; // @[Sdc.scala 103:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_timer <= _GEN_723;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_timer <= _GEN_888;
      end else begin
        rx_dat_timer <= _GEN_723;
      end
    end else begin
      rx_dat_timer <= _GEN_723;
    end
    if (reset) begin // @[Sdc.scala 104:31]
      rx_dat_timeout <= 1'h0; // @[Sdc.scala 104:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 241:21]
      if (2'h0 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_timeout <= _GEN_726;
      end else if (2'h1 == addr) begin // @[Sdc.scala 243:19]
        rx_dat_timeout <= _GEN_889;
      end else begin
        rx_dat_timeout <= _GEN_726;
      end
    end else begin
      rx_dat_timeout <= _GEN_726;
    end
    if (reset) begin // @[Sdc.scala 105:36]
      rx_dat_read_counter <= 7'h0; // @[Sdc.scala 105:36]
    end else if (io_mem_ren) begin // @[Sdc.scala 300:21]
      if (2'h1 == addr_1) begin // @[Sdc.scala 302:19]
        rx_dat_read_counter <= _GEN_1190;
      end else if (2'h2 == addr_1) begin // @[Sdc.scala 302:19]
        rx_dat_read_counter <= _GEN_1190;
      end else begin
        rx_dat_read_counter <= _GEN_1196;
      end
    end else begin
      rx_dat_read_counter <= _GEN_1190;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"sdc.clk           : 0x%x\n",reg_clk); // @[Sdc.scala 337:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_122) begin
          $fwrite(32'h80000002,"sdc.cmd_wrt       : 0x%x\n",io_sdc_port_cmd_wrt); // @[Sdc.scala 338:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_122) begin
          $fwrite(32'h80000002,"sdc.cmd_out       : 0x%x\n",io_sdc_port_cmd_out); // @[Sdc.scala 339:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_122) begin
          $fwrite(32'h80000002,"rx_res_counter    : 0x%x\n",rx_res_counter); // @[Sdc.scala 340:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_122) begin
          $fwrite(32'h80000002,"rx_dat_counter    : 0x%x\n",rx_dat_counter); // @[Sdc.scala 341:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_122) begin
          $fwrite(32'h80000002,"rx_dat_next       : 0x%x\n",rx_dat_next); // @[Sdc.scala 342:9]
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
`ifdef RANDOMIZE_GARBAGE_ASSIGN
  _RAND_1 = {1{`RANDOM}};
`endif // RANDOMIZE_GARBAGE_ASSIGN
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 130; initvar = initvar+1)
    rx_dat[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  reg_power = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  reg_baud_divider = _RAND_3[8:0];
  _RAND_4 = {1{`RANDOM}};
  reg_clk_counter = _RAND_4[8:0];
  _RAND_5 = {1{`RANDOM}};
  reg_clk = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  rx_res_in_progress = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  rx_res_counter = _RAND_7[7:0];
  _RAND_8 = {1{`RANDOM}};
  rx_res_bits_0 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  rx_res_bits_1 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  rx_res_bits_2 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  rx_res_bits_3 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  rx_res_bits_4 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  rx_res_bits_5 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  rx_res_bits_6 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  rx_res_bits_7 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  rx_res_bits_8 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  rx_res_bits_9 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  rx_res_bits_10 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  rx_res_bits_11 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  rx_res_bits_12 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  rx_res_bits_13 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  rx_res_bits_14 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  rx_res_bits_15 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rx_res_bits_16 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  rx_res_bits_17 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  rx_res_bits_18 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  rx_res_bits_19 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  rx_res_bits_20 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  rx_res_bits_21 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  rx_res_bits_22 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  rx_res_bits_23 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  rx_res_bits_24 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  rx_res_bits_25 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  rx_res_bits_26 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  rx_res_bits_27 = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  rx_res_bits_28 = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  rx_res_bits_29 = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  rx_res_bits_30 = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  rx_res_bits_31 = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  rx_res_bits_32 = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  rx_res_bits_33 = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  rx_res_bits_34 = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  rx_res_bits_35 = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  rx_res_bits_36 = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  rx_res_bits_37 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  rx_res_bits_38 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  rx_res_bits_39 = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  rx_res_bits_40 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  rx_res_bits_41 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  rx_res_bits_42 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  rx_res_bits_43 = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  rx_res_bits_44 = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  rx_res_bits_45 = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  rx_res_bits_46 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  rx_res_bits_47 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  rx_res_bits_48 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  rx_res_bits_49 = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  rx_res_bits_50 = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  rx_res_bits_51 = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  rx_res_bits_52 = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  rx_res_bits_53 = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  rx_res_bits_54 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  rx_res_bits_55 = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  rx_res_bits_56 = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  rx_res_bits_57 = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  rx_res_bits_58 = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  rx_res_bits_59 = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  rx_res_bits_60 = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  rx_res_bits_61 = _RAND_69[0:0];
  _RAND_70 = {1{`RANDOM}};
  rx_res_bits_62 = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  rx_res_bits_63 = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  rx_res_bits_64 = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  rx_res_bits_65 = _RAND_73[0:0];
  _RAND_74 = {1{`RANDOM}};
  rx_res_bits_66 = _RAND_74[0:0];
  _RAND_75 = {1{`RANDOM}};
  rx_res_bits_67 = _RAND_75[0:0];
  _RAND_76 = {1{`RANDOM}};
  rx_res_bits_68 = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  rx_res_bits_69 = _RAND_77[0:0];
  _RAND_78 = {1{`RANDOM}};
  rx_res_bits_70 = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  rx_res_bits_71 = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  rx_res_bits_72 = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  rx_res_bits_73 = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  rx_res_bits_74 = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  rx_res_bits_75 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  rx_res_bits_76 = _RAND_84[0:0];
  _RAND_85 = {1{`RANDOM}};
  rx_res_bits_77 = _RAND_85[0:0];
  _RAND_86 = {1{`RANDOM}};
  rx_res_bits_78 = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  rx_res_bits_79 = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  rx_res_bits_80 = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  rx_res_bits_81 = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  rx_res_bits_82 = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  rx_res_bits_83 = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  rx_res_bits_84 = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  rx_res_bits_85 = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  rx_res_bits_86 = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  rx_res_bits_87 = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  rx_res_bits_88 = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  rx_res_bits_89 = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  rx_res_bits_90 = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  rx_res_bits_91 = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  rx_res_bits_92 = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  rx_res_bits_93 = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  rx_res_bits_94 = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  rx_res_bits_95 = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  rx_res_bits_96 = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  rx_res_bits_97 = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  rx_res_bits_98 = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  rx_res_bits_99 = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  rx_res_bits_100 = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  rx_res_bits_101 = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  rx_res_bits_102 = _RAND_110[0:0];
  _RAND_111 = {1{`RANDOM}};
  rx_res_bits_103 = _RAND_111[0:0];
  _RAND_112 = {1{`RANDOM}};
  rx_res_bits_104 = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  rx_res_bits_105 = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  rx_res_bits_106 = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  rx_res_bits_107 = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  rx_res_bits_108 = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  rx_res_bits_109 = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  rx_res_bits_110 = _RAND_118[0:0];
  _RAND_119 = {1{`RANDOM}};
  rx_res_bits_111 = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  rx_res_bits_112 = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  rx_res_bits_113 = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  rx_res_bits_114 = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  rx_res_bits_115 = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  rx_res_bits_116 = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  rx_res_bits_117 = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  rx_res_bits_118 = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  rx_res_bits_119 = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  rx_res_bits_120 = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  rx_res_bits_121 = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  rx_res_bits_122 = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  rx_res_bits_123 = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  rx_res_bits_124 = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  rx_res_bits_125 = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  rx_res_bits_126 = _RAND_134[0:0];
  _RAND_135 = {1{`RANDOM}};
  rx_res_bits_127 = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  rx_res_bits_128 = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  rx_res_bits_129 = _RAND_137[0:0];
  _RAND_138 = {1{`RANDOM}};
  rx_res_bits_130 = _RAND_138[0:0];
  _RAND_139 = {1{`RANDOM}};
  rx_res_bits_131 = _RAND_139[0:0];
  _RAND_140 = {1{`RANDOM}};
  rx_res_bits_132 = _RAND_140[0:0];
  _RAND_141 = {1{`RANDOM}};
  rx_res_bits_133 = _RAND_141[0:0];
  _RAND_142 = {1{`RANDOM}};
  rx_res_bits_134 = _RAND_142[0:0];
  _RAND_143 = {1{`RANDOM}};
  rx_res_bits_135 = _RAND_143[0:0];
  _RAND_144 = {1{`RANDOM}};
  rx_res_next = _RAND_144[0:0];
  _RAND_145 = {1{`RANDOM}};
  rx_res_type = _RAND_145[3:0];
  _RAND_146 = {5{`RANDOM}};
  rx_res = _RAND_146[135:0];
  _RAND_147 = {1{`RANDOM}};
  rx_res_ready = _RAND_147[0:0];
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
  rx_dat_index = _RAND_222[7:0];
  _RAND_223 = {1{`RANDOM}};
  rx_dat_start_bit = _RAND_223[0:0];
  _RAND_224 = {1{`RANDOM}};
  rx_dat_bits_0 = _RAND_224[3:0];
  _RAND_225 = {1{`RANDOM}};
  rx_dat_bits_1 = _RAND_225[3:0];
  _RAND_226 = {1{`RANDOM}};
  rx_dat_bits_2 = _RAND_226[3:0];
  _RAND_227 = {1{`RANDOM}};
  rx_dat_bits_3 = _RAND_227[3:0];
  _RAND_228 = {1{`RANDOM}};
  rx_dat_bits_4 = _RAND_228[3:0];
  _RAND_229 = {1{`RANDOM}};
  rx_dat_bits_5 = _RAND_229[3:0];
  _RAND_230 = {1{`RANDOM}};
  rx_dat_bits_6 = _RAND_230[3:0];
  _RAND_231 = {1{`RANDOM}};
  rx_dat_bits_7 = _RAND_231[3:0];
  _RAND_232 = {1{`RANDOM}};
  rx_dat_next = _RAND_232[3:0];
  _RAND_233 = {1{`RANDOM}};
  rx_dat_ready = _RAND_233[0:0];
  _RAND_234 = {1{`RANDOM}};
  rx_dat_crc_0 = _RAND_234[3:0];
  _RAND_235 = {1{`RANDOM}};
  rx_dat_crc_1 = _RAND_235[3:0];
  _RAND_236 = {1{`RANDOM}};
  rx_dat_crc_2 = _RAND_236[3:0];
  _RAND_237 = {1{`RANDOM}};
  rx_dat_crc_3 = _RAND_237[3:0];
  _RAND_238 = {1{`RANDOM}};
  rx_dat_crc_4 = _RAND_238[3:0];
  _RAND_239 = {1{`RANDOM}};
  rx_dat_crc_5 = _RAND_239[3:0];
  _RAND_240 = {1{`RANDOM}};
  rx_dat_crc_6 = _RAND_240[3:0];
  _RAND_241 = {1{`RANDOM}};
  rx_dat_crc_7 = _RAND_241[3:0];
  _RAND_242 = {1{`RANDOM}};
  rx_dat_crc_8 = _RAND_242[3:0];
  _RAND_243 = {1{`RANDOM}};
  rx_dat_crc_9 = _RAND_243[3:0];
  _RAND_244 = {1{`RANDOM}};
  rx_dat_crc_10 = _RAND_244[3:0];
  _RAND_245 = {1{`RANDOM}};
  rx_dat_crc_11 = _RAND_245[3:0];
  _RAND_246 = {1{`RANDOM}};
  rx_dat_crc_12 = _RAND_246[3:0];
  _RAND_247 = {1{`RANDOM}};
  rx_dat_crc_13 = _RAND_247[3:0];
  _RAND_248 = {1{`RANDOM}};
  rx_dat_crc_14 = _RAND_248[3:0];
  _RAND_249 = {1{`RANDOM}};
  rx_dat_crc_15 = _RAND_249[3:0];
  _RAND_250 = {1{`RANDOM}};
  rx_dat_crc_error = _RAND_250[0:0];
  _RAND_251 = {1{`RANDOM}};
  rx_dat_timer = _RAND_251[18:0];
  _RAND_252 = {1{`RANDOM}};
  rx_dat_timeout = _RAND_252[0:0];
  _RAND_253 = {1{`RANDOM}};
  rx_dat_read_counter = _RAND_253[6:0];
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
  wire  _GEN_14 = 4'h2 == io_initiator_raddr[31:28] ? io_targets_1_rready : 21'h10000 == io_initiator_raddr[31:11]; // @[Decoder.scala 42:79 47:14]
  wire  _GEN_19 = 4'h2 == io_initiator_waddr[31:28] ? io_targets_1_wready : 21'h10000 == io_initiator_waddr[31:11]; // @[Decoder.scala 49:79 54:14]
  wire [31:0] _GEN_23 = 26'hc00000 == io_initiator_raddr[31:6] ? 32'hdeadbeef : _GEN_13; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_32 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_3_rvalid : 26'hc00000 == io_initiator_raddr[31:6]
     | _GEN_12; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_33 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_3_rdata : _GEN_23; // @[Decoder.scala 42:79 46:13]
  wire  _GEN_42 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rvalid : _GEN_32; // @[Decoder.scala 42:79 45:14]
  wire [31:0] _GEN_43 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_4_rdata : _GEN_33; // @[Decoder.scala 42:79 46:13]
  wire [31:0] _GEN_53 = 26'hc000c0 == io_initiator_raddr[31:6] ? io_targets_5_rdata : _GEN_43; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rdata = 26'h1000000 == io_initiator_raddr[31:6] ? io_targets_6_rdata : _GEN_53; // @[Decoder.scala 42:79 46:13]
  assign io_initiator_rvalid = 26'h1000000 == io_initiator_raddr[31:6] | (26'hc000c0 == io_initiator_raddr[31:6] |
    _GEN_42); // @[Decoder.scala 42:79 45:14]
  assign io_initiator_rready = 26'h1000000 == io_initiator_raddr[31:6] | (26'hc000c0 == io_initiator_raddr[31:6] | (26'hc00080
     == io_initiator_raddr[31:6] | (26'hc00040 == io_initiator_raddr[31:6] | (26'hc00000 == io_initiator_raddr[31:6] |
    _GEN_14)))); // @[Decoder.scala 42:79 47:14]
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
  output         io_sdc_port_clk,
  output         io_sdc_port_cmd_wrt,
  output         io_sdc_port_cmd_out,
  input          io_sdc_port_res_in,
  output         io_sdc_port_dat_wrt,
  output [3:0]   io_sdc_port_dat_out,
  input  [3:0]   io_sdc_port_dat_in,
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
  output [6:0]   io_debugSignals_sram2_addr,
  output         io_debugSignals_sdc_clk,
  output         io_debugSignals_sdc_cmd_wrt,
  output         io_debugSignals_sdc_cmd_out,
  output         io_debugSignals_sdc_res_in
);
  wire  core_clock; // @[Top.scala 73:20]
  wire  core_reset; // @[Top.scala 73:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 73:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 73:20]
  wire  core_io_imem_valid; // @[Top.scala 73:20]
  wire  core_io_icache_control_invalidate; // @[Top.scala 73:20]
  wire  core_io_icache_control_busy; // @[Top.scala 73:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 73:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 73:20]
  wire  core_io_dmem_ren; // @[Top.scala 73:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 73:20]
  wire  core_io_dmem_rready; // @[Top.scala 73:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 73:20]
  wire  core_io_dmem_wen; // @[Top.scala 73:20]
  wire  core_io_dmem_wready; // @[Top.scala 73:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 73:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 73:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 73:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 73:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 73:20]
  wire  core_io_mtimer_mem_rvalid; // @[Top.scala 73:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 73:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 73:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 73:20]
  wire  core_io_intr; // @[Top.scala 73:20]
  wire  core_io_exit; // @[Top.scala 73:20]
  wire [31:0] core_io_debug_signal_mem_reg_pc; // @[Top.scala 73:20]
  wire  core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 73:20]
  wire [31:0] core_io_debug_signal_csr_rdata; // @[Top.scala 73:20]
  wire [11:0] core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 73:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 73:20]
  wire [63:0] core_io_debug_signal_cycle_counter; // @[Top.scala 73:20]
  wire [63:0] core_io_debug_signal_instret; // @[Top.scala 73:20]
  wire  memory_clock; // @[Top.scala 75:22]
  wire  memory_reset; // @[Top.scala 75:22]
  wire  memory_io_imem_en; // @[Top.scala 75:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 75:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 75:22]
  wire  memory_io_imem_valid; // @[Top.scala 75:22]
  wire  memory_io_icache_control_invalidate; // @[Top.scala 75:22]
  wire  memory_io_icache_control_busy; // @[Top.scala 75:22]
  wire [31:0] memory_io_dmem_raddr; // @[Top.scala 75:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 75:22]
  wire  memory_io_dmem_ren; // @[Top.scala 75:22]
  wire  memory_io_dmem_rvalid; // @[Top.scala 75:22]
  wire  memory_io_dmem_rready; // @[Top.scala 75:22]
  wire [31:0] memory_io_dmem_waddr; // @[Top.scala 75:22]
  wire  memory_io_dmem_wen; // @[Top.scala 75:22]
  wire  memory_io_dmem_wready; // @[Top.scala 75:22]
  wire [3:0] memory_io_dmem_wstrb; // @[Top.scala 75:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 75:22]
  wire  memory_io_dramPort_ren; // @[Top.scala 75:22]
  wire  memory_io_dramPort_wen; // @[Top.scala 75:22]
  wire [27:0] memory_io_dramPort_addr; // @[Top.scala 75:22]
  wire [127:0] memory_io_dramPort_wdata; // @[Top.scala 75:22]
  wire  memory_io_dramPort_init_calib_complete; // @[Top.scala 75:22]
  wire [127:0] memory_io_dramPort_rdata; // @[Top.scala 75:22]
  wire  memory_io_dramPort_rdata_valid; // @[Top.scala 75:22]
  wire  memory_io_dramPort_busy; // @[Top.scala 75:22]
  wire  memory_io_cache_array1_en; // @[Top.scala 75:22]
  wire [31:0] memory_io_cache_array1_we; // @[Top.scala 75:22]
  wire [6:0] memory_io_cache_array1_addr; // @[Top.scala 75:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[Top.scala 75:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[Top.scala 75:22]
  wire  memory_io_cache_array2_en; // @[Top.scala 75:22]
  wire [31:0] memory_io_cache_array2_we; // @[Top.scala 75:22]
  wire [6:0] memory_io_cache_array2_addr; // @[Top.scala 75:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[Top.scala 75:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[Top.scala 75:22]
  wire  memory_io_icache_ren; // @[Top.scala 75:22]
  wire  memory_io_icache_wen; // @[Top.scala 75:22]
  wire [9:0] memory_io_icache_raddr; // @[Top.scala 75:22]
  wire [31:0] memory_io_icache_rdata; // @[Top.scala 75:22]
  wire [6:0] memory_io_icache_waddr; // @[Top.scala 75:22]
  wire [255:0] memory_io_icache_wdata; // @[Top.scala 75:22]
  wire  memory_io_icache_valid_ren; // @[Top.scala 75:22]
  wire  memory_io_icache_valid_wen; // @[Top.scala 75:22]
  wire  memory_io_icache_valid_invalidate; // @[Top.scala 75:22]
  wire [5:0] memory_io_icache_valid_addr; // @[Top.scala 75:22]
  wire  memory_io_icache_valid_iaddr; // @[Top.scala 75:22]
  wire [1:0] memory_io_icache_valid_rdata; // @[Top.scala 75:22]
  wire [1:0] memory_io_icache_valid_wdata; // @[Top.scala 75:22]
  wire  boot_rom_clock; // @[Top.scala 76:24]
  wire  boot_rom_reset; // @[Top.scala 76:24]
  wire  boot_rom_io_imem_en; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_imem_addr; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_imem_inst; // @[Top.scala 76:24]
  wire  boot_rom_io_imem_valid; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_dmem_raddr; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_dmem_rdata; // @[Top.scala 76:24]
  wire  boot_rom_io_dmem_ren; // @[Top.scala 76:24]
  wire  boot_rom_io_dmem_rvalid; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_dmem_waddr; // @[Top.scala 76:24]
  wire  boot_rom_io_dmem_wen; // @[Top.scala 76:24]
  wire [31:0] boot_rom_io_dmem_wdata; // @[Top.scala 76:24]
  wire  sram1_clock; // @[Top.scala 77:21]
  wire  sram1_en; // @[Top.scala 77:21]
  wire [31:0] sram1_we; // @[Top.scala 77:21]
  wire [6:0] sram1_addr; // @[Top.scala 77:21]
  wire [255:0] sram1_wdata; // @[Top.scala 77:21]
  wire [255:0] sram1_rdata; // @[Top.scala 77:21]
  wire  sram2_clock; // @[Top.scala 78:21]
  wire  sram2_en; // @[Top.scala 78:21]
  wire [31:0] sram2_we; // @[Top.scala 78:21]
  wire [6:0] sram2_addr; // @[Top.scala 78:21]
  wire [255:0] sram2_wdata; // @[Top.scala 78:21]
  wire [255:0] sram2_rdata; // @[Top.scala 78:21]
  wire  icache_clock; // @[Top.scala 79:22]
  wire  icache_ren; // @[Top.scala 79:22]
  wire  icache_wen; // @[Top.scala 79:22]
  wire [9:0] icache_raddr; // @[Top.scala 79:22]
  wire [31:0] icache_rdata; // @[Top.scala 79:22]
  wire [6:0] icache_waddr; // @[Top.scala 79:22]
  wire [255:0] icache_wdata; // @[Top.scala 79:22]
  wire  icache_valid_clock; // @[Top.scala 80:28]
  wire  icache_valid_ren; // @[Top.scala 80:28]
  wire  icache_valid_wen; // @[Top.scala 80:28]
  wire  icache_valid_ien; // @[Top.scala 80:28]
  wire  icache_valid_invalidate; // @[Top.scala 80:28]
  wire [5:0] icache_valid_addr; // @[Top.scala 80:28]
  wire  icache_valid_iaddr; // @[Top.scala 80:28]
  wire [1:0] icache_valid_rdata; // @[Top.scala 80:28]
  wire [1:0] icache_valid_wdata; // @[Top.scala 80:28]
  wire [63:0] icache_valid_idata; // @[Top.scala 80:28]
  wire [1:0] icache_valid_dummy_data; // @[Top.scala 80:28]
  wire  gpio_clock; // @[Top.scala 81:20]
  wire  gpio_reset; // @[Top.scala 81:20]
  wire  gpio_io_mem_wen; // @[Top.scala 81:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 81:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 81:20]
  wire  uart_clock; // @[Top.scala 82:20]
  wire  uart_reset; // @[Top.scala 82:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 82:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 82:20]
  wire  uart_io_mem_ren; // @[Top.scala 82:20]
  wire  uart_io_mem_rvalid; // @[Top.scala 82:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 82:20]
  wire  uart_io_mem_wen; // @[Top.scala 82:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 82:20]
  wire  uart_io_intr; // @[Top.scala 82:20]
  wire  uart_io_tx; // @[Top.scala 82:20]
  wire  sdc_clock; // @[Top.scala 83:19]
  wire  sdc_reset; // @[Top.scala 83:19]
  wire [31:0] sdc_io_mem_raddr; // @[Top.scala 83:19]
  wire [31:0] sdc_io_mem_rdata; // @[Top.scala 83:19]
  wire  sdc_io_mem_ren; // @[Top.scala 83:19]
  wire [31:0] sdc_io_mem_waddr; // @[Top.scala 83:19]
  wire  sdc_io_mem_wen; // @[Top.scala 83:19]
  wire [31:0] sdc_io_mem_wdata; // @[Top.scala 83:19]
  wire  sdc_io_sdc_port_clk; // @[Top.scala 83:19]
  wire  sdc_io_sdc_port_cmd_wrt; // @[Top.scala 83:19]
  wire  sdc_io_sdc_port_cmd_out; // @[Top.scala 83:19]
  wire  sdc_io_sdc_port_res_in; // @[Top.scala 83:19]
  wire [3:0] sdc_io_sdc_port_dat_in; // @[Top.scala 83:19]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 84:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 84:22]
  wire [31:0] dmem_decoder_io_initiator_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_initiator_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_initiator_ren; // @[Top.scala 86:28]
  wire  dmem_decoder_io_initiator_rvalid; // @[Top.scala 86:28]
  wire  dmem_decoder_io_initiator_rready; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_initiator_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_initiator_wen; // @[Top.scala 86:28]
  wire  dmem_decoder_io_initiator_wready; // @[Top.scala 86:28]
  wire [3:0] dmem_decoder_io_initiator_wstrb; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_initiator_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_0_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_0_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_0_ren; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_0_rvalid; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_0_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_0_wen; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_0_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_1_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_1_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_1_ren; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_1_rvalid; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_1_rready; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_1_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_1_wen; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_1_wready; // @[Top.scala 86:28]
  wire [3:0] dmem_decoder_io_targets_1_wstrb; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_1_wdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_2_wen; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_2_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_3_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_3_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_3_ren; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_3_rvalid; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_3_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_3_wen; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_3_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_4_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_4_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_4_ren; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_4_rvalid; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_4_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_4_wen; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_4_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_5_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_5_rdata; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_5_ren; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_5_waddr; // @[Top.scala 86:28]
  wire  dmem_decoder_io_targets_5_wen; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_5_wdata; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_6_raddr; // @[Top.scala 86:28]
  wire [31:0] dmem_decoder_io_targets_6_rdata; // @[Top.scala 86:28]
  wire  imem_decoder_clock; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_initiator_addr; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_initiator_inst; // @[Top.scala 103:28]
  wire  imem_decoder_io_initiator_valid; // @[Top.scala 103:28]
  wire  imem_decoder_io_targets_0_en; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_targets_0_addr; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_targets_0_inst; // @[Top.scala 103:28]
  wire  imem_decoder_io_targets_0_valid; // @[Top.scala 103:28]
  wire  imem_decoder_io_targets_1_en; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_targets_1_addr; // @[Top.scala 103:28]
  wire [31:0] imem_decoder_io_targets_1_inst; // @[Top.scala 103:28]
  wire  imem_decoder_io_targets_1_valid; // @[Top.scala 103:28]
  Core core ( // @[Top.scala 73:20]
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
  Memory memory ( // @[Top.scala 75:22]
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
  BootRom boot_rom ( // @[Top.scala 76:24]
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
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram1 ( // @[Top.scala 77:21]
    .clock(sram1_clock),
    .en(sram1_en),
    .we(sram1_we),
    .addr(sram1_addr),
    .wdata(sram1_wdata),
    .rdata(sram1_rdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram2 ( // @[Top.scala 78:21]
    .clock(sram2_clock),
    .en(sram2_en),
    .we(sram2_we),
    .addr(sram2_addr),
    .wdata(sram2_wdata),
    .rdata(sram2_rdata)
  );
  ICache #(.RDATA_WIDTH_BITS(5), .RADDR_WIDTH(10), .WDATA_WIDTH_BITS(8), .WADDR_WIDTH(7)) icache ( // @[Top.scala 79:22]
    .clock(icache_clock),
    .ren(icache_ren),
    .wen(icache_wen),
    .raddr(icache_raddr),
    .rdata(icache_rdata),
    .waddr(icache_waddr),
    .wdata(icache_wdata)
  );
  ICacheValid #(.DATA_WIDTH_BITS(1), .ADDR_WIDTH(6), .INVALIDATE_WIDTH_BITS(6), .INVALIDATE_ADDR_WIDTH(1)) icache_valid
     ( // @[Top.scala 80:28]
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
  Gpio gpio ( // @[Top.scala 81:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 82:20]
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
  Sdc sdc ( // @[Top.scala 83:19]
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
    .io_sdc_port_dat_in(sdc_io_sdc_port_dat_in)
  );
  Config config_ ( // @[Top.scala 84:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder dmem_decoder ( // @[Top.scala 86:28]
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
    .io_targets_5_rdata(dmem_decoder_io_targets_5_rdata),
    .io_targets_5_ren(dmem_decoder_io_targets_5_ren),
    .io_targets_5_waddr(dmem_decoder_io_targets_5_waddr),
    .io_targets_5_wen(dmem_decoder_io_targets_5_wen),
    .io_targets_5_wdata(dmem_decoder_io_targets_5_wdata),
    .io_targets_6_raddr(dmem_decoder_io_targets_6_raddr),
    .io_targets_6_rdata(dmem_decoder_io_targets_6_rdata)
  );
  IMemDecoder imem_decoder ( // @[Top.scala 103:28]
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
  assign io_dram_ren = memory_io_dramPort_ren; // @[Top.scala 116:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[Top.scala 116:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[Top.scala 116:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[Top.scala 116:11]
  assign io_dram_wmask = 16'h0; // @[Top.scala 116:11]
  assign io_dram_user_busy = 1'h0; // @[Top.scala 116:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 180:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 181:14]
  assign io_sdc_port_clk = sdc_io_sdc_port_clk; // @[Top.scala 183:15]
  assign io_sdc_port_cmd_wrt = sdc_io_sdc_port_cmd_wrt; // @[Top.scala 183:15]
  assign io_sdc_port_cmd_out = sdc_io_sdc_port_cmd_out; // @[Top.scala 183:15]
  assign io_sdc_port_dat_wrt = 1'h0; // @[Top.scala 183:15]
  assign io_sdc_port_dat_out = 4'h0; // @[Top.scala 183:15]
  assign io_exit = core_io_exit; // @[Top.scala 179:11]
  assign io_debugSignals_core_mem_reg_pc = core_io_debug_signal_mem_reg_pc; // @[Top.scala 151:24]
  assign io_debugSignals_core_mem_is_valid_inst = core_io_debug_signal_mem_is_valid_inst; // @[Top.scala 151:24]
  assign io_debugSignals_core_csr_rdata = core_io_debug_signal_csr_rdata; // @[Top.scala 151:24]
  assign io_debugSignals_core_mem_reg_csr_addr = core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 151:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 151:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 151:24]
  assign io_debugSignals_core_instret = core_io_debug_signal_instret; // @[Top.scala 151:24]
  assign io_debugSignals_raddr = core_io_dmem_raddr; // @[Top.scala 152:26]
  assign io_debugSignals_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 153:26]
  assign io_debugSignals_ren = core_io_dmem_ren; // @[Top.scala 154:26]
  assign io_debugSignals_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 155:26]
  assign io_debugSignals_waddr = core_io_dmem_waddr; // @[Top.scala 156:26]
  assign io_debugSignals_wen = core_io_dmem_wen; // @[Top.scala 158:26]
  assign io_debugSignals_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 159:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 160:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 157:26]
  assign io_debugSignals_dram_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 162:44]
  assign io_debugSignals_dram_rdata_valid = io_dram_rdata_valid; // @[Top.scala 163:44]
  assign io_debugSignals_dram_busy = io_dram_busy; // @[Top.scala 164:44]
  assign io_debugSignals_dram_ren = io_dram_ren; // @[Top.scala 165:44]
  assign io_debugSignals_sram1_en = memory_io_cache_array1_en; // @[Top.scala 167:28]
  assign io_debugSignals_sram1_we = memory_io_cache_array1_we; // @[Top.scala 168:28]
  assign io_debugSignals_sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 169:30]
  assign io_debugSignals_sram2_en = memory_io_cache_array2_en; // @[Top.scala 170:28]
  assign io_debugSignals_sram2_we = memory_io_cache_array2_we; // @[Top.scala 171:28]
  assign io_debugSignals_sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 172:30]
  assign io_debugSignals_sdc_clk = sdc_io_sdc_port_clk; // @[Top.scala 174:31]
  assign io_debugSignals_sdc_cmd_wrt = sdc_io_sdc_port_cmd_wrt; // @[Top.scala 175:31]
  assign io_debugSignals_sdc_cmd_out = sdc_io_sdc_port_cmd_out; // @[Top.scala 176:31]
  assign io_debugSignals_sdc_res_in = io_sdc_port_res_in; // @[Top.scala 177:31]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = imem_decoder_io_initiator_inst; // @[Top.scala 110:16]
  assign core_io_imem_valid = imem_decoder_io_initiator_valid; // @[Top.scala 110:16]
  assign core_io_icache_control_busy = memory_io_icache_control_busy; // @[Top.scala 113:26]
  assign core_io_dmem_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 111:16]
  assign core_io_dmem_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 111:16]
  assign core_io_dmem_rready = dmem_decoder_io_initiator_rready; // @[Top.scala 111:16]
  assign core_io_dmem_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 111:16]
  assign core_io_mtimer_mem_raddr = dmem_decoder_io_targets_4_raddr; // @[Top.scala 99:30]
  assign core_io_mtimer_mem_ren = dmem_decoder_io_targets_4_ren; // @[Top.scala 99:30]
  assign core_io_mtimer_mem_waddr = dmem_decoder_io_targets_4_waddr; // @[Top.scala 99:30]
  assign core_io_mtimer_mem_wen = dmem_decoder_io_targets_4_wen; // @[Top.scala 99:30]
  assign core_io_mtimer_mem_wdata = dmem_decoder_io_targets_4_wdata; // @[Top.scala 99:30]
  assign core_io_intr = uart_io_intr; // @[Top.scala 182:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_en = imem_decoder_io_targets_1_en; // @[Top.scala 108:30]
  assign memory_io_imem_addr = imem_decoder_io_targets_1_addr; // @[Top.scala 108:30]
  assign memory_io_icache_control_invalidate = core_io_icache_control_invalidate; // @[Top.scala 113:26]
  assign memory_io_dmem_raddr = dmem_decoder_io_targets_1_raddr; // @[Top.scala 96:30]
  assign memory_io_dmem_ren = dmem_decoder_io_targets_1_ren; // @[Top.scala 96:30]
  assign memory_io_dmem_waddr = dmem_decoder_io_targets_1_waddr; // @[Top.scala 96:30]
  assign memory_io_dmem_wen = dmem_decoder_io_targets_1_wen; // @[Top.scala 96:30]
  assign memory_io_dmem_wstrb = dmem_decoder_io_targets_1_wstrb; // @[Top.scala 96:30]
  assign memory_io_dmem_wdata = dmem_decoder_io_targets_1_wdata; // @[Top.scala 96:30]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 116:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[Top.scala 116:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[Top.scala 116:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[Top.scala 116:11]
  assign memory_io_cache_array1_rdata = sram1_rdata; // @[Top.scala 123:32]
  assign memory_io_cache_array2_rdata = sram2_rdata; // @[Top.scala 129:32]
  assign memory_io_icache_rdata = icache_rdata; // @[Top.scala 135:26]
  assign memory_io_icache_valid_rdata = icache_valid_rdata; // @[Top.scala 145:32]
  assign boot_rom_clock = clock;
  assign boot_rom_reset = reset;
  assign boot_rom_io_imem_en = imem_decoder_io_targets_0_en; // @[Top.scala 107:30]
  assign boot_rom_io_imem_addr = imem_decoder_io_targets_0_addr; // @[Top.scala 107:30]
  assign boot_rom_io_dmem_raddr = dmem_decoder_io_targets_0_raddr; // @[Top.scala 95:30]
  assign boot_rom_io_dmem_ren = dmem_decoder_io_targets_0_ren; // @[Top.scala 95:30]
  assign boot_rom_io_dmem_waddr = dmem_decoder_io_targets_0_waddr; // @[Top.scala 95:30]
  assign boot_rom_io_dmem_wen = dmem_decoder_io_targets_0_wen; // @[Top.scala 95:30]
  assign boot_rom_io_dmem_wdata = dmem_decoder_io_targets_0_wdata; // @[Top.scala 95:30]
  assign sram1_clock = clock; // @[Top.scala 118:18]
  assign sram1_en = memory_io_cache_array1_en; // @[Top.scala 119:15]
  assign sram1_we = memory_io_cache_array1_we; // @[Top.scala 120:15]
  assign sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 121:17]
  assign sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 122:18]
  assign sram2_clock = clock; // @[Top.scala 124:18]
  assign sram2_en = memory_io_cache_array2_en; // @[Top.scala 125:15]
  assign sram2_we = memory_io_cache_array2_we; // @[Top.scala 126:15]
  assign sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 127:17]
  assign sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 128:18]
  assign icache_clock = clock; // @[Top.scala 131:19]
  assign icache_ren = memory_io_icache_ren; // @[Top.scala 132:17]
  assign icache_wen = memory_io_icache_wen; // @[Top.scala 133:17]
  assign icache_raddr = memory_io_icache_raddr; // @[Top.scala 134:19]
  assign icache_waddr = memory_io_icache_waddr; // @[Top.scala 136:19]
  assign icache_wdata = memory_io_icache_wdata; // @[Top.scala 137:19]
  assign icache_valid_clock = clock; // @[Top.scala 139:25]
  assign icache_valid_ren = memory_io_icache_valid_ren; // @[Top.scala 140:23]
  assign icache_valid_wen = memory_io_icache_valid_wen; // @[Top.scala 141:23]
  assign icache_valid_ien = memory_io_icache_valid_invalidate; // @[Top.scala 148:23]
  assign icache_valid_invalidate = memory_io_icache_valid_invalidate; // @[Top.scala 142:30]
  assign icache_valid_addr = memory_io_icache_valid_addr; // @[Top.scala 143:24]
  assign icache_valid_iaddr = memory_io_icache_valid_iaddr; // @[Top.scala 144:25]
  assign icache_valid_wdata = memory_io_icache_valid_wdata; // @[Top.scala 146:25]
  assign icache_valid_idata = 64'h0; // @[Top.scala 147:25]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = dmem_decoder_io_targets_2_wen; // @[Top.scala 97:30]
  assign gpio_io_mem_wdata = dmem_decoder_io_targets_2_wdata; // @[Top.scala 97:30]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = dmem_decoder_io_targets_3_raddr; // @[Top.scala 98:30]
  assign uart_io_mem_ren = dmem_decoder_io_targets_3_ren; // @[Top.scala 98:30]
  assign uart_io_mem_waddr = dmem_decoder_io_targets_3_waddr; // @[Top.scala 98:30]
  assign uart_io_mem_wen = dmem_decoder_io_targets_3_wen; // @[Top.scala 98:30]
  assign uart_io_mem_wdata = dmem_decoder_io_targets_3_wdata; // @[Top.scala 98:30]
  assign sdc_clock = clock;
  assign sdc_reset = reset;
  assign sdc_io_mem_raddr = dmem_decoder_io_targets_5_raddr; // @[Top.scala 100:30]
  assign sdc_io_mem_ren = dmem_decoder_io_targets_5_ren; // @[Top.scala 100:30]
  assign sdc_io_mem_waddr = dmem_decoder_io_targets_5_waddr; // @[Top.scala 100:30]
  assign sdc_io_mem_wen = dmem_decoder_io_targets_5_wen; // @[Top.scala 100:30]
  assign sdc_io_mem_wdata = dmem_decoder_io_targets_5_wdata; // @[Top.scala 100:30]
  assign sdc_io_sdc_port_res_in = io_sdc_port_res_in; // @[Top.scala 183:15]
  assign sdc_io_sdc_port_dat_in = io_sdc_port_dat_in; // @[Top.scala 183:15]
  assign config__io_mem_raddr = dmem_decoder_io_targets_6_raddr; // @[Top.scala 101:30]
  assign dmem_decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 111:16]
  assign dmem_decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 111:16]
  assign dmem_decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 111:16]
  assign dmem_decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 111:16]
  assign dmem_decoder_io_initiator_wstrb = core_io_dmem_wstrb; // @[Top.scala 111:16]
  assign dmem_decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 111:16]
  assign dmem_decoder_io_targets_0_rdata = boot_rom_io_dmem_rdata; // @[Top.scala 95:30]
  assign dmem_decoder_io_targets_0_rvalid = boot_rom_io_dmem_rvalid; // @[Top.scala 95:30]
  assign dmem_decoder_io_targets_1_rdata = memory_io_dmem_rdata; // @[Top.scala 96:30]
  assign dmem_decoder_io_targets_1_rvalid = memory_io_dmem_rvalid; // @[Top.scala 96:30]
  assign dmem_decoder_io_targets_1_rready = memory_io_dmem_rready; // @[Top.scala 96:30]
  assign dmem_decoder_io_targets_1_wready = memory_io_dmem_wready; // @[Top.scala 96:30]
  assign dmem_decoder_io_targets_3_rdata = uart_io_mem_rdata; // @[Top.scala 98:30]
  assign dmem_decoder_io_targets_3_rvalid = uart_io_mem_rvalid; // @[Top.scala 98:30]
  assign dmem_decoder_io_targets_4_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 99:30]
  assign dmem_decoder_io_targets_4_rvalid = core_io_mtimer_mem_rvalid; // @[Top.scala 99:30]
  assign dmem_decoder_io_targets_5_rdata = sdc_io_mem_rdata; // @[Top.scala 100:30]
  assign dmem_decoder_io_targets_6_rdata = config__io_mem_rdata; // @[Top.scala 101:30]
  assign imem_decoder_clock = clock;
  assign imem_decoder_io_initiator_addr = core_io_imem_addr; // @[Top.scala 110:16]
  assign imem_decoder_io_targets_0_inst = boot_rom_io_imem_inst; // @[Top.scala 107:30]
  assign imem_decoder_io_targets_0_valid = boot_rom_io_imem_valid; // @[Top.scala 107:30]
  assign imem_decoder_io_targets_1_inst = memory_io_imem_inst; // @[Top.scala 108:30]
  assign imem_decoder_io_targets_1_valid = memory_io_imem_valid; // @[Top.scala 108:30]
endmodule
