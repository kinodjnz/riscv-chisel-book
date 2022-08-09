module LongCounter(
  input         clock,
  input         reset,
  output [63:0] io_value
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] counter; // @[Core.scala 26:24]
  wire [63:0] _counter_T_1 = counter + 64'h1; // @[Core.scala 27:22]
  assign io_value = counter; // @[Core.scala 28:12]
  always @(posedge clock) begin
    if (reset) begin // @[Core.scala 26:24]
      counter <= 64'h0; // @[Core.scala 26:24]
    end else begin
      counter <= _counter_T_1; // @[Core.scala 27:11]
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
  output [31:0] io_debug_signal_csr_rdata,
  output [31:0] io_debug_signal_mem_reg_csr_addr,
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
  reg [31:0] regfile [0:31]; // @[Core.scala 54:20]
  wire  regfile_id_rs1_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_rs1_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_rs1_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_id_rs2_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_rs2_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_rs2_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_id_c_rs1_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_c_rs1_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_c_rs1_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_id_c_rs2_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_c_rs2_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_c_rs2_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_id_c_rs1p_data_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_c_rs1p_data_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_c_rs1p_data_data; // @[Core.scala 54:20]
  wire  regfile_id_c_rs2p_data_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_c_rs2p_data_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_c_rs2p_data_data; // @[Core.scala 54:20]
  wire  regfile_id_sp_data_en; // @[Core.scala 54:20]
  wire [4:0] regfile_id_sp_data_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_id_sp_data_data; // @[Core.scala 54:20]
  wire  regfile_ex1_op1_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_ex1_op1_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_ex1_op1_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_ex1_op2_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_ex1_op2_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_ex1_op2_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_ex1_rs2_data_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_ex1_rs2_data_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_ex1_rs2_data_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_io_gp_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_io_gp_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_io_gp_MPORT_data; // @[Core.scala 54:20]
  wire  regfile_do_exit_MPORT_en; // @[Core.scala 54:20]
  wire [4:0] regfile_do_exit_MPORT_addr; // @[Core.scala 54:20]
  wire [31:0] regfile_do_exit_MPORT_data; // @[Core.scala 54:20]
  wire [31:0] regfile_MPORT_data; // @[Core.scala 54:20]
  wire [4:0] regfile_MPORT_addr; // @[Core.scala 54:20]
  wire  regfile_MPORT_mask; // @[Core.scala 54:20]
  wire  regfile_MPORT_en; // @[Core.scala 54:20]
  wire  cycle_counter_clock; // @[Core.scala 57:29]
  wire  cycle_counter_reset; // @[Core.scala 57:29]
  wire [63:0] cycle_counter_io_value; // @[Core.scala 57:29]
  wire  mtimer_clock; // @[Core.scala 58:22]
  wire  mtimer_reset; // @[Core.scala 58:22]
  wire [31:0] mtimer_io_mem_raddr; // @[Core.scala 58:22]
  wire [31:0] mtimer_io_mem_rdata; // @[Core.scala 58:22]
  wire  mtimer_io_mem_ren; // @[Core.scala 58:22]
  wire  mtimer_io_mem_rvalid; // @[Core.scala 58:22]
  wire [31:0] mtimer_io_mem_waddr; // @[Core.scala 58:22]
  wire  mtimer_io_mem_wen; // @[Core.scala 58:22]
  wire [31:0] mtimer_io_mem_wdata; // @[Core.scala 58:22]
  wire  mtimer_io_intr; // @[Core.scala 58:22]
  wire [63:0] mtimer_io_mtime; // @[Core.scala 58:22]
  wire  bp_clock; // @[Core.scala 236:18]
  wire  bp_reset; // @[Core.scala 236:18]
  wire [31:0] bp_io_lu_inst_pc; // @[Core.scala 236:18]
  wire  bp_io_lu_br_hit; // @[Core.scala 236:18]
  wire  bp_io_lu_br_pos; // @[Core.scala 236:18]
  wire [31:0] bp_io_lu_br_addr; // @[Core.scala 236:18]
  wire  bp_io_up_update_en; // @[Core.scala 236:18]
  wire [31:0] bp_io_up_inst_pc; // @[Core.scala 236:18]
  wire  bp_io_up_br_pos; // @[Core.scala 236:18]
  wire [31:0] bp_io_up_br_addr; // @[Core.scala 236:18]
  reg [31:0] csr_trap_vector; // @[Core.scala 56:32]
  reg [63:0] instret; // @[Core.scala 59:24]
  reg [31:0] csr_mcause; // @[Core.scala 60:29]
  reg [31:0] csr_mepc; // @[Core.scala 62:29]
  reg [31:0] csr_mstatus; // @[Core.scala 63:29]
  reg [31:0] csr_mscratch; // @[Core.scala 64:29]
  reg [31:0] csr_mie; // @[Core.scala 65:29]
  reg [31:0] csr_mip; // @[Core.scala 66:29]
  reg [31:0] id_reg_pc; // @[Core.scala 74:38]
  reg [31:0] id_reg_inst; // @[Core.scala 76:38]
  reg  id_reg_stall; // @[Core.scala 77:38]
  reg  id_reg_is_bp_pos; // @[Core.scala 78:38]
  reg [31:0] id_reg_bp_addr; // @[Core.scala 79:38]
  reg [31:0] ex1_reg_pc; // @[Core.scala 85:38]
  reg [4:0] ex1_reg_wb_addr; // @[Core.scala 86:38]
  reg [2:0] ex1_reg_op1_sel; // @[Core.scala 87:38]
  reg [3:0] ex1_reg_op2_sel; // @[Core.scala 88:38]
  reg [4:0] ex1_reg_rs1_addr; // @[Core.scala 89:38]
  reg [4:0] ex1_reg_rs2_addr; // @[Core.scala 90:38]
  reg [31:0] ex1_reg_op1_data; // @[Core.scala 91:38]
  reg [31:0] ex1_reg_op2_data; // @[Core.scala 92:38]
  reg [4:0] ex1_reg_exe_fun; // @[Core.scala 94:38]
  reg [1:0] ex1_reg_mem_wen; // @[Core.scala 95:38]
  reg [1:0] ex1_reg_rf_wen; // @[Core.scala 96:38]
  reg [2:0] ex1_reg_wb_sel; // @[Core.scala 97:38]
  reg [11:0] ex1_reg_csr_addr; // @[Core.scala 98:38]
  reg [2:0] ex1_reg_csr_cmd; // @[Core.scala 99:38]
  reg [31:0] ex1_reg_imm_b_sext; // @[Core.scala 102:38]
  reg [31:0] ex1_reg_mem_w; // @[Core.scala 105:38]
  reg  ex1_reg_is_j; // @[Core.scala 106:39]
  reg  ex1_reg_is_bp_pos; // @[Core.scala 107:39]
  reg [31:0] ex1_reg_bp_addr; // @[Core.scala 108:39]
  reg  ex1_reg_is_half; // @[Core.scala 109:39]
  reg  ex1_reg_is_valid_inst; // @[Core.scala 110:39]
  reg  ex1_reg_is_trap; // @[Core.scala 111:39]
  reg [31:0] ex1_reg_mcause; // @[Core.scala 112:39]
  reg [31:0] ex2_reg_pc; // @[Core.scala 116:38]
  reg [4:0] ex2_reg_wb_addr; // @[Core.scala 117:38]
  reg [31:0] ex2_reg_op1_data; // @[Core.scala 118:38]
  reg [31:0] ex2_reg_op2_data; // @[Core.scala 119:38]
  reg [31:0] ex2_reg_rs2_data; // @[Core.scala 120:38]
  reg [4:0] ex2_reg_exe_fun; // @[Core.scala 121:38]
  reg [1:0] ex2_reg_mem_wen; // @[Core.scala 122:38]
  reg [1:0] ex2_reg_rf_wen; // @[Core.scala 123:38]
  reg [2:0] ex2_reg_wb_sel; // @[Core.scala 124:38]
  reg [11:0] ex2_reg_csr_addr; // @[Core.scala 125:38]
  reg [2:0] ex2_reg_csr_cmd; // @[Core.scala 126:38]
  reg [31:0] ex2_reg_imm_b_sext; // @[Core.scala 127:38]
  reg [31:0] ex2_reg_mem_w; // @[Core.scala 128:38]
  reg  ex2_reg_is_j; // @[Core.scala 129:38]
  reg  ex2_reg_is_bp_pos; // @[Core.scala 130:38]
  reg [31:0] ex2_reg_bp_addr; // @[Core.scala 131:38]
  reg  ex2_reg_is_half; // @[Core.scala 132:38]
  reg  ex2_reg_is_valid_inst; // @[Core.scala 133:38]
  reg  ex2_reg_is_trap; // @[Core.scala 134:38]
  reg [31:0] ex2_reg_mcause; // @[Core.scala 135:38]
  reg  ex3_reg_bp_en; // @[Core.scala 139:41]
  reg [31:0] ex3_reg_pc; // @[Core.scala 140:41]
  reg  ex3_reg_is_cond_br; // @[Core.scala 141:41]
  reg  ex3_reg_is_cond_br_inst; // @[Core.scala 142:41]
  reg  ex3_reg_is_uncond_br; // @[Core.scala 143:41]
  reg [31:0] ex3_reg_cond_br_target; // @[Core.scala 144:41]
  reg [31:0] ex3_reg_uncond_br_target; // @[Core.scala 145:41]
  reg  ex3_reg_is_j; // @[Core.scala 146:41]
  reg  ex3_reg_is_bp_pos; // @[Core.scala 147:41]
  reg [31:0] ex3_reg_bp_addr; // @[Core.scala 148:41]
  reg  ex3_reg_is_half; // @[Core.scala 149:41]
  reg  mem_reg_en; // @[Core.scala 152:38]
  reg [31:0] mem_reg_pc; // @[Core.scala 153:38]
  reg [4:0] mem_reg_wb_addr; // @[Core.scala 154:38]
  reg [31:0] mem_reg_op1_data; // @[Core.scala 155:38]
  reg [31:0] mem_reg_rs2_data; // @[Core.scala 156:38]
  reg [1:0] mem_reg_mem_wen; // @[Core.scala 157:38]
  reg [1:0] mem_reg_rf_wen; // @[Core.scala 158:38]
  reg [2:0] mem_reg_wb_sel; // @[Core.scala 159:38]
  reg [11:0] mem_reg_csr_addr; // @[Core.scala 160:38]
  reg [2:0] mem_reg_csr_cmd; // @[Core.scala 161:38]
  reg [31:0] mem_reg_alu_out; // @[Core.scala 163:38]
  reg [31:0] mem_reg_mem_w; // @[Core.scala 164:38]
  reg [3:0] mem_reg_mem_wstrb; // @[Core.scala 165:38]
  reg  mem_reg_is_half; // @[Core.scala 166:38]
  reg  mem_reg_is_valid_inst; // @[Core.scala 167:38]
  reg  mem_reg_is_trap; // @[Core.scala 168:38]
  reg [31:0] mem_reg_mcause; // @[Core.scala 169:38]
  reg [4:0] wb_reg_wb_addr; // @[Core.scala 173:38]
  reg [1:0] wb_reg_rf_wen; // @[Core.scala 174:38]
  reg [31:0] wb_reg_wb_data; // @[Core.scala 175:38]
  reg  wb_reg_is_valid_inst; // @[Core.scala 176:38]
  reg  if2_reg_is_bp_pos; // @[Core.scala 178:35]
  reg [31:0] if2_reg_bp_addr; // @[Core.scala 179:35]
  reg  if2_reg_is_uncond_br; // @[Core.scala 182:39]
  reg [31:0] if2_reg_uncond_br_addr; // @[Core.scala 183:39]
  reg  ex3_reg_is_br; // @[Core.scala 187:35]
  reg [31:0] ex3_reg_br_target; // @[Core.scala 188:35]
  reg  ex3_reg_is_br_before_trap; // @[Core.scala 189:42]
  reg [31:0] ex3_reg_trap_pc; // @[Core.scala 190:35]
  reg  mem_reg_is_br; // @[Core.scala 191:35]
  reg [31:0] mem_reg_br_addr; // @[Core.scala 192:35]
  reg  ic_reg_read_rdy; // @[Core.scala 201:32]
  reg  ic_reg_half_rdy; // @[Core.scala 202:32]
  reg [31:0] ic_reg_addr_out; // @[Core.scala 204:32]
  reg [15:0] ic_reg_half; // @[Core.scala 208:33]
  wire  _ic_read_en2_T = ~id_reg_stall; // @[Core.scala 278:18]
  wire  _ic_data_out_T_2 = ic_reg_addr_out[1] & ic_reg_read_rdy; // @[Core.scala 229:32]
  wire [31:0] _ic_data_out_T_4 = {io_imem_inst[15:0],ic_reg_half}; // @[Cat.scala 31:58]
  wire  _ic_data_out_T_7 = ~ic_reg_read_rdy; // @[Core.scala 230:35]
  wire  _ic_data_out_T_8 = ic_reg_addr_out[1] & ~ic_reg_read_rdy; // @[Core.scala 230:32]
  wire [31:0] _ic_data_out_T_11 = {16'h0,io_imem_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_12 = _ic_data_out_T_8 ? _ic_data_out_T_11 : io_imem_inst; // @[Mux.scala 101:16]
  wire [31:0] ic_data_out = _ic_data_out_T_2 ? _ic_data_out_T_4 : _ic_data_out_T_12; // @[Mux.scala 101:16]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 277:41]
  wire  ic_read_en2 = ~id_reg_stall & is_half_inst; // @[Core.scala 278:32]
  wire  _ic_next_addr_T_1 = (ic_reg_half_rdy | ic_reg_read_rdy) & ic_read_en2; // @[Core.scala 212:43]
  wire [31:0] _ic_next_addr_T_3 = ic_reg_addr_out + 32'h2; // @[Core.scala 212:79]
  wire  ic_read_en4 = _ic_read_en2_T & ~is_half_inst; // @[Core.scala 279:32]
  wire  _ic_next_addr_T_4 = ic_reg_read_rdy & ic_read_en4; // @[Core.scala 213:22]
  wire [31:0] _ic_next_addr_T_6 = ic_reg_addr_out + 32'h4; // @[Core.scala 213:58]
  wire [31:0] _ic_next_addr_T_7 = _ic_next_addr_T_4 ? _ic_next_addr_T_6 : ic_reg_addr_out; // @[Mux.scala 101:16]
  wire [31:0] _ic_next_addr_T_8 = _ic_next_addr_T_1 ? _ic_next_addr_T_3 : _ic_next_addr_T_7; // @[Mux.scala 101:16]
  wire  _if1_is_jump_T = mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 257:35]
  reg  if1_reg_first; // @[Core.scala 242:30]
  wire  if1_is_jump = mem_reg_is_br | ex3_reg_is_br | if2_reg_is_bp_pos | if2_reg_is_uncond_br | if1_reg_first; // @[Core.scala 257:97]
  wire [31:0] _if1_jump_addr_T = if1_reg_first ? 32'h8000000 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_1 = if2_reg_is_uncond_br ? if2_reg_uncond_br_addr : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_2 = if2_reg_is_bp_pos ? if2_reg_bp_addr : _if1_jump_addr_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_3 = ex3_reg_is_br ? ex3_reg_br_target : _if1_jump_addr_T_2; // @[Mux.scala 101:16]
  wire [31:0] if1_jump_addr = mem_reg_is_br ? mem_reg_br_addr : _if1_jump_addr_T_3; // @[Mux.scala 101:16]
  wire [31:0] ic_next_addr = if1_is_jump ? if1_jump_addr : _ic_next_addr_T_8; // @[Mux.scala 101:16]
  wire  ic_fill_half = if1_is_jump & if1_jump_addr[1]; // @[Core.scala 215:33]
  wire [31:0] _ic_mem_addr_T_2 = {ic_next_addr[31:2],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] _ic_mem_addr_T_4 = ic_next_addr + 32'h2; // @[Core.scala 218:23]
  wire [31:0] _ic_mem_addr_T_7 = {_ic_mem_addr_T_4[31:2],2'h0}; // @[Cat.scala 31:58]
  wire  _ic_reg_half_T_2 = _ic_data_out_T_7 | ic_read_en2 | ic_read_en4; // @[Core.scala 226:38]
  reg [31:0] if1_reg_next_pc; // @[Core.scala 262:32]
  wire [31:0] if1_next_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 263:24]
  wire [31:0] if1_next_pc_4 = if1_next_pc + 32'h4; // @[Core.scala 264:35]
  reg [31:0] if2_reg_pc; // @[Core.scala 274:29]
  reg [31:0] if2_reg_inst; // @[Core.scala 275:29]
  wire  _if2_pc_T = ic_reg_half_rdy & is_half_inst; // @[Core.scala 280:74]
  wire [31:0] if2_pc = id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst) ? if2_reg_pc : ic_reg_addr_out
    ; // @[Core.scala 280:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_reg_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = if2_reg_is_uncond_br ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = if2_reg_is_bp_pos ? 32'h13 : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = id_reg_stall ? if2_reg_inst : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_6 = mem_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex3_reg_is_br ? 32'h13 : _if2_inst_T_6; // @[Mux.scala 101:16]
  wire  if2_is_cond_br_w = if2_inst[6:0] == 7'h63; // @[Core.scala 296:42]
  wire  _if2_is_cond_br_c_T_3 = if2_inst[1:0] == 2'h1; // @[Core.scala 297:70]
  wire  if2_is_cond_br_c = if2_inst[15:14] == 2'h3 & if2_inst[1:0] == 2'h1; // @[Core.scala 297:52]
  wire  if2_is_cond_br = if2_is_cond_br_w | if2_is_cond_br_c; // @[Core.scala 298:41]
  wire  if2_is_jal_w = if2_inst[6:0] == 7'h6f; // @[Core.scala 299:38]
  wire  if2_is_jal_c = if2_inst[14:13] == 2'h1 & _if2_is_cond_br_c_T_3; // @[Core.scala 300:48]
  wire  if2_is_jal = if2_is_jal_w | if2_is_jal_c; // @[Core.scala 301:33]
  wire  if2_is_jalr = if2_inst[6:0] == 7'h67 | if2_inst[15:13] == 3'h4 & if2_inst[6:0] == 7'h2; // @[Core.scala 302:50]
  wire  if2_is_bp_br = if2_is_cond_br | if2_is_jalr; // @[Core.scala 303:37]
  wire [19:0] _if2_w_imm_b_T_2 = if2_inst[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_w_imm_b = {_if2_w_imm_b_T_2,if2_inst[7],if2_inst[30:25],if2_inst[11:8],1'h0}; // @[Cat.scala 31:58]
  wire [23:0] _if2_c_imm_b_T_2 = if2_inst[12] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_c_imm_b = {_if2_c_imm_b_T_2,if2_inst[6:5],if2_inst[2],if2_inst[11:10],if2_inst[4:3],1'h0}; // @[Cat.scala 31:58]
  wire [11:0] _if2_w_imm_j_T_2 = if2_inst[31] ? 12'hfff : 12'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_w_imm_j = {_if2_w_imm_j_T_2,if2_inst[19:12],if2_inst[20],if2_inst[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [20:0] _if2_c_imm_j_T_2 = if2_inst[12] ? 21'h1fffff : 21'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_c_imm_j = {_if2_c_imm_j_T_2,if2_inst[8],if2_inst[10:9],if2_inst[6],if2_inst[7],if2_inst[2],if2_inst[11
    ],if2_inst[5:3],1'h0}; // @[Cat.scala 31:58]
  wire [31:0] if2_imm_b_sext = if2_is_cond_br_w ? if2_w_imm_b : if2_c_imm_b; // @[Core.scala 308:27]
  wire [31:0] if2_imm_j_sext = if2_is_jal_w ? if2_w_imm_j : if2_c_imm_j; // @[Core.scala 309:27]
  wire [31:0] if2_jal_addr = if2_pc + if2_imm_j_sext; // @[Core.scala 315:29]
  wire  _if2_is_bp_pos_T = if2_is_bp_br & bp_io_lu_br_pos; // @[Core.scala 323:19]
  wire  _if2_is_bp_pos_T_1 = ~bp_io_lu_br_hit; // @[Core.scala 324:26]
  wire  _if2_is_bp_pos_T_5 = if2_is_cond_br & ~bp_io_lu_br_hit & if2_imm_b_sext[31]; // @[Core.scala 324:43]
  wire  _if2_is_bp_pos_T_6 = if2_is_bp_br & bp_io_lu_br_pos | _if2_is_bp_pos_T_5; // @[Core.scala 323:39]
  wire [31:0] if2_cond_br_addr = if2_pc + if2_imm_b_sext; // @[Core.scala 327:33]
  wire  _if2_bp_addr_T_2 = _if2_is_bp_pos_T_1 & if2_is_cond_br; // @[Core.scala 331:23]
  wire [31:0] _if2_bp_addr_T_3 = _if2_bp_addr_T_2 ? if2_cond_br_addr : 32'h0; // @[Mux.scala 101:16]
  wire  _T_1 = ~reset; // @[Core.scala 335:9]
  reg  ex1_reg_hazard; // @[Core.scala 763:38]
  wire  _ex1_stall_T = ex1_reg_op1_sel == 3'h0; // @[Core.scala 777:23]
  wire  _ex1_stall_T_1 = ex1_reg_hazard & _ex1_stall_T; // @[Core.scala 776:21]
  wire  _ex1_stall_T_2 = ex1_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 778:24]
  wire  _ex1_stall_T_3 = _ex1_stall_T_1 & _ex1_stall_T_2; // @[Core.scala 777:36]
  reg  ex2_reg_hazard; // @[Core.scala 766:38]
  wire  _ex1_stall_T_5 = ex2_reg_hazard & _ex1_stall_T; // @[Core.scala 779:21]
  wire  _ex1_stall_T_6 = ex1_reg_rs1_addr == mem_reg_wb_addr; // @[Core.scala 781:24]
  wire  _ex1_stall_T_7 = _ex1_stall_T_5 & _ex1_stall_T_6; // @[Core.scala 780:36]
  wire  _ex1_stall_T_8 = _ex1_stall_T_3 | _ex1_stall_T_7; // @[Core.scala 778:46]
  wire  _ex1_stall_T_9 = ex1_reg_op2_sel == 4'h1; // @[Core.scala 783:23]
  wire  _ex1_stall_T_11 = ex1_reg_op2_sel == 4'h1 | ex1_reg_mem_wen == 2'h1; // @[Core.scala 783:35]
  wire  _ex1_stall_T_12 = ex1_reg_hazard & _ex1_stall_T_11; // @[Core.scala 782:21]
  wire  _ex1_stall_T_13 = ex1_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 784:24]
  wire  _ex1_stall_T_14 = _ex1_stall_T_12 & _ex1_stall_T_13; // @[Core.scala 783:65]
  wire  _ex1_stall_T_15 = _ex1_stall_T_8 | _ex1_stall_T_14; // @[Core.scala 781:46]
  wire  _ex1_stall_T_19 = ex2_reg_hazard & _ex1_stall_T_11; // @[Core.scala 785:21]
  wire  _ex1_stall_T_20 = ex1_reg_rs2_addr == mem_reg_wb_addr; // @[Core.scala 787:24]
  wire  _ex1_stall_T_21 = _ex1_stall_T_19 & _ex1_stall_T_20; // @[Core.scala 786:65]
  wire  ex1_stall = _ex1_stall_T_15 | _ex1_stall_T_21; // @[Core.scala 784:46]
  wire  _mem_en_T = ~mem_reg_is_br; // @[Core.scala 1015:30]
  wire  _mem_en_T_2 = ~ex3_reg_is_br; // @[Core.scala 1015:48]
  wire  _mem_en_T_4 = ~mem_reg_is_trap; // @[Core.scala 1015:66]
  wire  mem_is_meintr = csr_mstatus[3] & (io_intr & csr_mie[11]); // @[Core.scala 1012:45]
  wire  _mem_en_T_6 = ~mem_is_meintr; // @[Core.scala 1015:86]
  wire  mem_is_mtintr = csr_mstatus[3] & (mtimer_io_intr & csr_mie[7]); // @[Core.scala 1013:45]
  wire  _mem_en_T_8 = ~mem_is_mtintr; // @[Core.scala 1015:104]
  wire  mem_en = mem_reg_en & ~mem_reg_is_br & ~ex3_reg_is_br & ~mem_reg_is_trap & ~mem_is_meintr & ~mem_is_mtintr; // @[Core.scala 1015:101]
  wire [2:0] mem_wb_sel = mem_en ? mem_reg_wb_sel : 3'h0; // @[Core.scala 1017:23]
  wire  _mem_stall_T = mem_wb_sel == 3'h1; // @[Core.scala 1028:29]
  reg  mem_stall_delay; // @[Core.scala 1020:32]
  wire [1:0] mem_mem_wen = mem_en ? mem_reg_mem_wen : 2'h0; // @[Core.scala 1019:24]
  wire  _mem_stall_T_6 = mem_mem_wen == 2'h1; // @[Core.scala 1028:118]
  wire  mem_stall = mem_wb_sel == 3'h1 & (~io_dmem_rvalid | ~io_dmem_rready | mem_stall_delay) | mem_mem_wen == 2'h1 & ~
    io_dmem_wready; // @[Core.scala 1028:101]
  wire  id_stall = ex1_stall | mem_stall; // @[Core.scala 356:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 360:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 362:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 364:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 365:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 366:30]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 370:18]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 373:18]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 377:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 31:58]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 31:58]
  wire  _id_c_rs1_data_T = id_w_wb_addr == 5'h0; // @[Core.scala 385:20]
  wire [31:0] id_c_rs1_data = _id_c_rs1_data_T ? 32'h0 : regfile_id_c_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_c_rs2_data_T = id_c_rs2_addr == 5'h0; // @[Core.scala 388:20]
  wire [31:0] id_c_rs2_data = _id_c_rs2_data_T ? 32'h0 : regfile_id_c_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 394:25]
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
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 402:25]
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
  wire [31:0] _csignals_T_90 = id_inst & 32'hffff; // @[Lookup.scala 31:38]
  wire  _csignals_T_91 = 32'h0 == _csignals_T_90; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_92 = id_inst & 32'he003; // @[Lookup.scala 31:38]
  wire  _csignals_T_93 = 32'h0 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_94 = id_inst & 32'hef83; // @[Lookup.scala 31:38]
  wire  _csignals_T_95 = 32'h6101 == _csignals_T_94; // @[Lookup.scala 31:38]
  wire  _csignals_T_97 = 32'h1 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_99 = 32'h4000 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_101 = 32'hc000 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_103 = 32'h4001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_105 = 32'h6001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_106 = id_inst & 32'hec03; // @[Lookup.scala 31:38]
  wire  _csignals_T_107 = 32'h8401 == _csignals_T_106; // @[Lookup.scala 31:38]
  wire  _csignals_T_109 = 32'h8001 == _csignals_T_106; // @[Lookup.scala 31:38]
  wire  _csignals_T_111 = 32'h8801 == _csignals_T_106; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_112 = id_inst & 32'hfc63; // @[Lookup.scala 31:38]
  wire  _csignals_T_113 = 32'h8c01 == _csignals_T_112; // @[Lookup.scala 31:38]
  wire  _csignals_T_115 = 32'h8c21 == _csignals_T_112; // @[Lookup.scala 31:38]
  wire  _csignals_T_117 = 32'h8c41 == _csignals_T_112; // @[Lookup.scala 31:38]
  wire  _csignals_T_119 = 32'h8c61 == _csignals_T_112; // @[Lookup.scala 31:38]
  wire  _csignals_T_121 = 32'h2 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_123 = 32'ha001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_125 = 32'hc001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_127 = 32'he001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_128 = id_inst & 32'hf07f; // @[Lookup.scala 31:38]
  wire  _csignals_T_129 = 32'h8002 == _csignals_T_128; // @[Lookup.scala 31:38]
  wire  _csignals_T_131 = 32'h9002 == _csignals_T_128; // @[Lookup.scala 31:38]
  wire  _csignals_T_133 = 32'h2001 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_135 = 32'h4002 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire  _csignals_T_137 = 32'hc002 == _csignals_T_92; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_138 = id_inst & 32'hf003; // @[Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'h8002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h9002 == _csignals_T_138; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_142 = _csignals_T_141 ? 5'h1 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_143 = _csignals_T_139 ? 5'h1 : _csignals_T_142; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_144 = _csignals_T_137 ? 5'h1 : _csignals_T_143; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_145 = _csignals_T_135 ? 5'h1 : _csignals_T_144; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_146 = _csignals_T_133 ? 5'h1 : _csignals_T_145; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_147 = _csignals_T_131 ? 5'h11 : _csignals_T_146; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_148 = _csignals_T_129 ? 5'h11 : _csignals_T_147; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_149 = _csignals_T_127 ? 5'hc : _csignals_T_148; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_150 = _csignals_T_125 ? 5'hb : _csignals_T_149; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_151 = _csignals_T_123 ? 5'h1 : _csignals_T_150; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_152 = _csignals_T_121 ? 5'h6 : _csignals_T_151; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_153 = _csignals_T_119 ? 5'h3 : _csignals_T_152; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_154 = _csignals_T_117 ? 5'h4 : _csignals_T_153; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_155 = _csignals_T_115 ? 5'h5 : _csignals_T_154; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_156 = _csignals_T_113 ? 5'h2 : _csignals_T_155; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_157 = _csignals_T_111 ? 5'h3 : _csignals_T_156; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_158 = _csignals_T_109 ? 5'h7 : _csignals_T_157; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_159 = _csignals_T_107 ? 5'h8 : _csignals_T_158; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_160 = _csignals_T_105 ? 5'h1 : _csignals_T_159; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_161 = _csignals_T_103 ? 5'h1 : _csignals_T_160; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_162 = _csignals_T_101 ? 5'h1 : _csignals_T_161; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_163 = _csignals_T_99 ? 5'h1 : _csignals_T_162; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_164 = _csignals_T_97 ? 5'h1 : _csignals_T_163; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_165 = _csignals_T_95 ? 5'h1 : _csignals_T_164; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_166 = _csignals_T_93 ? 5'h1 : _csignals_T_165; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_167 = _csignals_T_91 ? 5'h0 : _csignals_T_166; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_168 = _csignals_T_89 ? 5'h0 : _csignals_T_167; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_169 = _csignals_T_87 ? 5'h0 : _csignals_T_168; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_170 = _csignals_T_85 ? 5'h12 : _csignals_T_169; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_171 = _csignals_T_83 ? 5'h12 : _csignals_T_170; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_172 = _csignals_T_81 ? 5'h12 : _csignals_T_171; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_173 = _csignals_T_79 ? 5'h12 : _csignals_T_172; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_174 = _csignals_T_77 ? 5'h12 : _csignals_T_173; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_175 = _csignals_T_75 ? 5'h12 : _csignals_T_174; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_176 = _csignals_T_73 ? 5'h1 : _csignals_T_175; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_177 = _csignals_T_71 ? 5'h1 : _csignals_T_176; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_178 = _csignals_T_69 ? 5'h11 : _csignals_T_177; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_179 = _csignals_T_67 ? 5'h1 : _csignals_T_178; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_180 = _csignals_T_65 ? 5'hf : _csignals_T_179; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_181 = _csignals_T_63 ? 5'hd : _csignals_T_180; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_182 = _csignals_T_61 ? 5'h10 : _csignals_T_181; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_183 = _csignals_T_59 ? 5'he : _csignals_T_182; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_184 = _csignals_T_57 ? 5'hc : _csignals_T_183; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_185 = _csignals_T_55 ? 5'hb : _csignals_T_184; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_186 = _csignals_T_53 ? 5'ha : _csignals_T_185; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_187 = _csignals_T_51 ? 5'h9 : _csignals_T_186; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_188 = _csignals_T_49 ? 5'ha : _csignals_T_187; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_189 = _csignals_T_47 ? 5'h9 : _csignals_T_188; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_190 = _csignals_T_45 ? 5'h8 : _csignals_T_189; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_191 = _csignals_T_43 ? 5'h7 : _csignals_T_190; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_192 = _csignals_T_41 ? 5'h6 : _csignals_T_191; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_193 = _csignals_T_39 ? 5'h8 : _csignals_T_192; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_194 = _csignals_T_37 ? 5'h7 : _csignals_T_193; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_195 = _csignals_T_35 ? 5'h6 : _csignals_T_194; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_196 = _csignals_T_33 ? 5'h5 : _csignals_T_195; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_197 = _csignals_T_31 ? 5'h4 : _csignals_T_196; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_198 = _csignals_T_29 ? 5'h3 : _csignals_T_197; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_199 = _csignals_T_27 ? 5'h5 : _csignals_T_198; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_200 = _csignals_T_25 ? 5'h4 : _csignals_T_199; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_201 = _csignals_T_23 ? 5'h3 : _csignals_T_200; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_202 = _csignals_T_21 ? 5'h2 : _csignals_T_201; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_203 = _csignals_T_19 ? 5'h1 : _csignals_T_202; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_204 = _csignals_T_17 ? 5'h1 : _csignals_T_203; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_205 = _csignals_T_15 ? 5'h1 : _csignals_T_204; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_206 = _csignals_T_13 ? 5'h1 : _csignals_T_205; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_207 = _csignals_T_11 ? 5'h1 : _csignals_T_206; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_208 = _csignals_T_9 ? 5'h1 : _csignals_T_207; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_209 = _csignals_T_7 ? 5'h1 : _csignals_T_208; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_210 = _csignals_T_5 ? 5'h1 : _csignals_T_209; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_211 = _csignals_T_3 ? 5'h1 : _csignals_T_210; // @[Lookup.scala 34:39]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h1 : _csignals_T_211; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_212 = _csignals_T_141 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_213 = _csignals_T_139 ? 3'h2 : _csignals_T_212; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_214 = _csignals_T_137 ? 3'h5 : _csignals_T_213; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_215 = _csignals_T_135 ? 3'h5 : _csignals_T_214; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_216 = _csignals_T_133 ? 3'h1 : _csignals_T_215; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_217 = _csignals_T_131 ? 3'h4 : _csignals_T_216; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_218 = _csignals_T_129 ? 3'h4 : _csignals_T_217; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_219 = _csignals_T_127 ? 3'h6 : _csignals_T_218; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_220 = _csignals_T_125 ? 3'h6 : _csignals_T_219; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_221 = _csignals_T_123 ? 3'h1 : _csignals_T_220; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_222 = _csignals_T_121 ? 3'h4 : _csignals_T_221; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_223 = _csignals_T_119 ? 3'h6 : _csignals_T_222; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_224 = _csignals_T_117 ? 3'h6 : _csignals_T_223; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_225 = _csignals_T_115 ? 3'h6 : _csignals_T_224; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_226 = _csignals_T_113 ? 3'h6 : _csignals_T_225; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_227 = _csignals_T_111 ? 3'h6 : _csignals_T_226; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_228 = _csignals_T_109 ? 3'h6 : _csignals_T_227; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_229 = _csignals_T_107 ? 3'h6 : _csignals_T_228; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_230 = _csignals_T_105 ? 3'h2 : _csignals_T_229; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_231 = _csignals_T_103 ? 3'h2 : _csignals_T_230; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_232 = _csignals_T_101 ? 3'h6 : _csignals_T_231; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_233 = _csignals_T_99 ? 3'h6 : _csignals_T_232; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_234 = _csignals_T_97 ? 3'h4 : _csignals_T_233; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_235 = _csignals_T_95 ? 3'h4 : _csignals_T_234; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_236 = _csignals_T_93 ? 3'h5 : _csignals_T_235; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_237 = _csignals_T_91 ? 3'h4 : _csignals_T_236; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_238 = _csignals_T_89 ? 3'h2 : _csignals_T_237; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_239 = _csignals_T_87 ? 3'h2 : _csignals_T_238; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_240 = _csignals_T_85 ? 3'h3 : _csignals_T_239; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_241 = _csignals_T_83 ? 3'h0 : _csignals_T_240; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_242 = _csignals_T_81 ? 3'h3 : _csignals_T_241; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_243 = _csignals_T_79 ? 3'h0 : _csignals_T_242; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_244 = _csignals_T_77 ? 3'h3 : _csignals_T_243; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_245 = _csignals_T_75 ? 3'h0 : _csignals_T_244; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_246 = _csignals_T_73 ? 3'h1 : _csignals_T_245; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_247 = _csignals_T_71 ? 3'h2 : _csignals_T_246; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_248 = _csignals_T_69 ? 3'h0 : _csignals_T_247; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_249 = _csignals_T_67 ? 3'h1 : _csignals_T_248; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_250 = _csignals_T_65 ? 3'h0 : _csignals_T_249; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_251 = _csignals_T_63 ? 3'h0 : _csignals_T_250; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_252 = _csignals_T_61 ? 3'h0 : _csignals_T_251; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_253 = _csignals_T_59 ? 3'h0 : _csignals_T_252; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_254 = _csignals_T_57 ? 3'h0 : _csignals_T_253; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_255 = _csignals_T_55 ? 3'h0 : _csignals_T_254; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_256 = _csignals_T_53 ? 3'h0 : _csignals_T_255; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_257 = _csignals_T_51 ? 3'h0 : _csignals_T_256; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_258 = _csignals_T_49 ? 3'h0 : _csignals_T_257; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_259 = _csignals_T_47 ? 3'h0 : _csignals_T_258; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_260 = _csignals_T_45 ? 3'h0 : _csignals_T_259; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_261 = _csignals_T_43 ? 3'h0 : _csignals_T_260; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_262 = _csignals_T_41 ? 3'h0 : _csignals_T_261; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_263 = _csignals_T_39 ? 3'h0 : _csignals_T_262; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_264 = _csignals_T_37 ? 3'h0 : _csignals_T_263; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_265 = _csignals_T_35 ? 3'h0 : _csignals_T_264; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_266 = _csignals_T_33 ? 3'h0 : _csignals_T_265; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_267 = _csignals_T_31 ? 3'h0 : _csignals_T_266; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_268 = _csignals_T_29 ? 3'h0 : _csignals_T_267; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_269 = _csignals_T_27 ? 3'h0 : _csignals_T_268; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_270 = _csignals_T_25 ? 3'h0 : _csignals_T_269; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_271 = _csignals_T_23 ? 3'h0 : _csignals_T_270; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_272 = _csignals_T_21 ? 3'h0 : _csignals_T_271; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_273 = _csignals_T_19 ? 3'h0 : _csignals_T_272; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_274 = _csignals_T_17 ? 3'h0 : _csignals_T_273; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_275 = _csignals_T_15 ? 3'h0 : _csignals_T_274; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_276 = _csignals_T_13 ? 3'h0 : _csignals_T_275; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_277 = _csignals_T_11 ? 3'h0 : _csignals_T_276; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_278 = _csignals_T_9 ? 3'h0 : _csignals_T_277; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_279 = _csignals_T_7 ? 3'h0 : _csignals_T_278; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_280 = _csignals_T_5 ? 3'h0 : _csignals_T_279; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_281 = _csignals_T_3 ? 3'h0 : _csignals_T_280; // @[Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h0 : _csignals_T_281; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_282 = _csignals_T_141 ? 4'h6 : 4'h1; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_283 = _csignals_T_139 ? 4'h6 : _csignals_T_282; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_284 = _csignals_T_137 ? 4'hf : _csignals_T_283; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_285 = _csignals_T_135 ? 4'he : _csignals_T_284; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_286 = _csignals_T_133 ? 4'hd : _csignals_T_285; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_287 = _csignals_T_131 ? 4'h0 : _csignals_T_286; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_288 = _csignals_T_129 ? 4'h0 : _csignals_T_287; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_289 = _csignals_T_127 ? 4'h0 : _csignals_T_288; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_290 = _csignals_T_125 ? 4'h0 : _csignals_T_289; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_291 = _csignals_T_123 ? 4'hd : _csignals_T_290; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_292 = _csignals_T_121 ? 4'ha : _csignals_T_291; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_293 = _csignals_T_119 ? 4'h7 : _csignals_T_292; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_294 = _csignals_T_117 ? 4'h7 : _csignals_T_293; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_295 = _csignals_T_115 ? 4'h7 : _csignals_T_294; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_296 = _csignals_T_113 ? 4'h7 : _csignals_T_295; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_297 = _csignals_T_111 ? 4'ha : _csignals_T_296; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_298 = _csignals_T_109 ? 4'ha : _csignals_T_297; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_299 = _csignals_T_107 ? 4'ha : _csignals_T_298; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_300 = _csignals_T_105 ? 4'hc : _csignals_T_299; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_301 = _csignals_T_103 ? 4'ha : _csignals_T_300; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_302 = _csignals_T_101 ? 4'hb : _csignals_T_301; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_303 = _csignals_T_99 ? 4'hb : _csignals_T_302; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_304 = _csignals_T_97 ? 4'ha : _csignals_T_303; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_305 = _csignals_T_95 ? 4'h9 : _csignals_T_304; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_306 = _csignals_T_93 ? 4'h8 : _csignals_T_305; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_307 = _csignals_T_91 ? 4'h6 : _csignals_T_306; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_308 = _csignals_T_89 ? 4'h0 : _csignals_T_307; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_309 = _csignals_T_87 ? 4'h0 : _csignals_T_308; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_310 = _csignals_T_85 ? 4'h0 : _csignals_T_309; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_311 = _csignals_T_83 ? 4'h0 : _csignals_T_310; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_312 = _csignals_T_81 ? 4'h0 : _csignals_T_311; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_313 = _csignals_T_79 ? 4'h0 : _csignals_T_312; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_314 = _csignals_T_77 ? 4'h0 : _csignals_T_313; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_315 = _csignals_T_75 ? 4'h0 : _csignals_T_314; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_316 = _csignals_T_73 ? 4'h5 : _csignals_T_315; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_317 = _csignals_T_71 ? 4'h5 : _csignals_T_316; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_318 = _csignals_T_69 ? 4'h2 : _csignals_T_317; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_319 = _csignals_T_67 ? 4'h4 : _csignals_T_318; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_320 = _csignals_T_65 ? 4'h1 : _csignals_T_319; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_321 = _csignals_T_63 ? 4'h1 : _csignals_T_320; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_322 = _csignals_T_61 ? 4'h1 : _csignals_T_321; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_323 = _csignals_T_59 ? 4'h1 : _csignals_T_322; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_324 = _csignals_T_57 ? 4'h1 : _csignals_T_323; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_325 = _csignals_T_55 ? 4'h1 : _csignals_T_324; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_326 = _csignals_T_53 ? 4'h2 : _csignals_T_325; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_327 = _csignals_T_51 ? 4'h2 : _csignals_T_326; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_328 = _csignals_T_49 ? 4'h1 : _csignals_T_327; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_329 = _csignals_T_47 ? 4'h1 : _csignals_T_328; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_330 = _csignals_T_45 ? 4'h2 : _csignals_T_329; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_331 = _csignals_T_43 ? 4'h2 : _csignals_T_330; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_332 = _csignals_T_41 ? 4'h2 : _csignals_T_331; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_333 = _csignals_T_39 ? 4'h1 : _csignals_T_332; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_334 = _csignals_T_37 ? 4'h1 : _csignals_T_333; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_335 = _csignals_T_35 ? 4'h1 : _csignals_T_334; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_336 = _csignals_T_33 ? 4'h2 : _csignals_T_335; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_337 = _csignals_T_31 ? 4'h2 : _csignals_T_336; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_338 = _csignals_T_29 ? 4'h2 : _csignals_T_337; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_339 = _csignals_T_27 ? 4'h1 : _csignals_T_338; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_340 = _csignals_T_25 ? 4'h1 : _csignals_T_339; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_341 = _csignals_T_23 ? 4'h1 : _csignals_T_340; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_342 = _csignals_T_21 ? 4'h1 : _csignals_T_341; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_343 = _csignals_T_19 ? 4'h2 : _csignals_T_342; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_344 = _csignals_T_17 ? 4'h1 : _csignals_T_343; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_345 = _csignals_T_15 ? 4'h3 : _csignals_T_344; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_346 = _csignals_T_13 ? 4'h2 : _csignals_T_345; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_347 = _csignals_T_11 ? 4'h3 : _csignals_T_346; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_348 = _csignals_T_9 ? 4'h2 : _csignals_T_347; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_349 = _csignals_T_7 ? 4'h2 : _csignals_T_348; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_350 = _csignals_T_5 ? 4'h3 : _csignals_T_349; // @[Lookup.scala 34:39]
  wire [3:0] _csignals_T_351 = _csignals_T_3 ? 4'h2 : _csignals_T_350; // @[Lookup.scala 34:39]
  wire [3:0] csignals_2 = _csignals_T_1 ? 4'h2 : _csignals_T_351; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_354 = _csignals_T_137 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_355 = _csignals_T_135 ? 2'h0 : _csignals_T_354; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_356 = _csignals_T_133 ? 2'h0 : _csignals_T_355; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_357 = _csignals_T_131 ? 2'h0 : _csignals_T_356; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_358 = _csignals_T_129 ? 2'h0 : _csignals_T_357; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_359 = _csignals_T_127 ? 2'h0 : _csignals_T_358; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_360 = _csignals_T_125 ? 2'h0 : _csignals_T_359; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_361 = _csignals_T_123 ? 2'h0 : _csignals_T_360; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_362 = _csignals_T_121 ? 2'h0 : _csignals_T_361; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_363 = _csignals_T_119 ? 2'h0 : _csignals_T_362; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_364 = _csignals_T_117 ? 2'h0 : _csignals_T_363; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_365 = _csignals_T_115 ? 2'h0 : _csignals_T_364; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_366 = _csignals_T_113 ? 2'h0 : _csignals_T_365; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_367 = _csignals_T_111 ? 2'h0 : _csignals_T_366; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_368 = _csignals_T_109 ? 2'h0 : _csignals_T_367; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_369 = _csignals_T_107 ? 2'h0 : _csignals_T_368; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_370 = _csignals_T_105 ? 2'h0 : _csignals_T_369; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_371 = _csignals_T_103 ? 2'h0 : _csignals_T_370; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_372 = _csignals_T_101 ? 2'h1 : _csignals_T_371; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_373 = _csignals_T_99 ? 2'h0 : _csignals_T_372; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_374 = _csignals_T_97 ? 2'h0 : _csignals_T_373; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_375 = _csignals_T_95 ? 2'h0 : _csignals_T_374; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_376 = _csignals_T_93 ? 2'h0 : _csignals_T_375; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_377 = _csignals_T_91 ? 2'h0 : _csignals_T_376; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_378 = _csignals_T_89 ? 2'h0 : _csignals_T_377; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_379 = _csignals_T_87 ? 2'h0 : _csignals_T_378; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_380 = _csignals_T_85 ? 2'h0 : _csignals_T_379; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_381 = _csignals_T_83 ? 2'h0 : _csignals_T_380; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_382 = _csignals_T_81 ? 2'h0 : _csignals_T_381; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_383 = _csignals_T_79 ? 2'h0 : _csignals_T_382; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_384 = _csignals_T_77 ? 2'h0 : _csignals_T_383; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_385 = _csignals_T_75 ? 2'h0 : _csignals_T_384; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_386 = _csignals_T_73 ? 2'h0 : _csignals_T_385; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_387 = _csignals_T_71 ? 2'h0 : _csignals_T_386; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_388 = _csignals_T_69 ? 2'h0 : _csignals_T_387; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_389 = _csignals_T_67 ? 2'h0 : _csignals_T_388; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_390 = _csignals_T_65 ? 2'h0 : _csignals_T_389; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_391 = _csignals_T_63 ? 2'h0 : _csignals_T_390; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_392 = _csignals_T_61 ? 2'h0 : _csignals_T_391; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_393 = _csignals_T_59 ? 2'h0 : _csignals_T_392; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_394 = _csignals_T_57 ? 2'h0 : _csignals_T_393; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_395 = _csignals_T_55 ? 2'h0 : _csignals_T_394; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_396 = _csignals_T_53 ? 2'h0 : _csignals_T_395; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_397 = _csignals_T_51 ? 2'h0 : _csignals_T_396; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_398 = _csignals_T_49 ? 2'h0 : _csignals_T_397; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_399 = _csignals_T_47 ? 2'h0 : _csignals_T_398; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_400 = _csignals_T_45 ? 2'h0 : _csignals_T_399; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_401 = _csignals_T_43 ? 2'h0 : _csignals_T_400; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_402 = _csignals_T_41 ? 2'h0 : _csignals_T_401; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_403 = _csignals_T_39 ? 2'h0 : _csignals_T_402; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_404 = _csignals_T_37 ? 2'h0 : _csignals_T_403; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_405 = _csignals_T_35 ? 2'h0 : _csignals_T_404; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_406 = _csignals_T_33 ? 2'h0 : _csignals_T_405; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_407 = _csignals_T_31 ? 2'h0 : _csignals_T_406; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_408 = _csignals_T_29 ? 2'h0 : _csignals_T_407; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_409 = _csignals_T_27 ? 2'h0 : _csignals_T_408; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_410 = _csignals_T_25 ? 2'h0 : _csignals_T_409; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_411 = _csignals_T_23 ? 2'h0 : _csignals_T_410; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_412 = _csignals_T_21 ? 2'h0 : _csignals_T_411; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_413 = _csignals_T_19 ? 2'h0 : _csignals_T_412; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_414 = _csignals_T_17 ? 2'h0 : _csignals_T_413; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_415 = _csignals_T_15 ? 2'h1 : _csignals_T_414; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_416 = _csignals_T_13 ? 2'h0 : _csignals_T_415; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_417 = _csignals_T_11 ? 2'h1 : _csignals_T_416; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_418 = _csignals_T_9 ? 2'h0 : _csignals_T_417; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_419 = _csignals_T_7 ? 2'h0 : _csignals_T_418; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_420 = _csignals_T_5 ? 2'h1 : _csignals_T_419; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_421 = _csignals_T_3 ? 2'h0 : _csignals_T_420; // @[Lookup.scala 34:39]
  wire [1:0] csignals_3 = _csignals_T_1 ? 2'h0 : _csignals_T_421; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_422 = _csignals_T_141 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_423 = _csignals_T_139 ? 2'h1 : _csignals_T_422; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_424 = _csignals_T_137 ? 2'h0 : _csignals_T_423; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_425 = _csignals_T_135 ? 2'h1 : _csignals_T_424; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_426 = _csignals_T_133 ? 2'h1 : _csignals_T_425; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_427 = _csignals_T_131 ? 2'h1 : _csignals_T_426; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_428 = _csignals_T_129 ? 2'h1 : _csignals_T_427; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_429 = _csignals_T_127 ? 2'h0 : _csignals_T_428; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_430 = _csignals_T_125 ? 2'h0 : _csignals_T_429; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_431 = _csignals_T_123 ? 2'h1 : _csignals_T_430; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_432 = _csignals_T_121 ? 2'h1 : _csignals_T_431; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_433 = _csignals_T_119 ? 2'h1 : _csignals_T_432; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_434 = _csignals_T_117 ? 2'h1 : _csignals_T_433; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_435 = _csignals_T_115 ? 2'h1 : _csignals_T_434; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_436 = _csignals_T_113 ? 2'h1 : _csignals_T_435; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_437 = _csignals_T_111 ? 2'h1 : _csignals_T_436; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_438 = _csignals_T_109 ? 2'h1 : _csignals_T_437; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_439 = _csignals_T_107 ? 2'h1 : _csignals_T_438; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_440 = _csignals_T_105 ? 2'h1 : _csignals_T_439; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_441 = _csignals_T_103 ? 2'h1 : _csignals_T_440; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_442 = _csignals_T_101 ? 2'h0 : _csignals_T_441; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_443 = _csignals_T_99 ? 2'h1 : _csignals_T_442; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_444 = _csignals_T_97 ? 2'h1 : _csignals_T_443; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_445 = _csignals_T_95 ? 2'h1 : _csignals_T_444; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_446 = _csignals_T_93 ? 2'h1 : _csignals_T_445; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_447 = _csignals_T_91 ? 2'h0 : _csignals_T_446; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_448 = _csignals_T_89 ? 2'h0 : _csignals_T_447; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_449 = _csignals_T_87 ? 2'h0 : _csignals_T_448; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_450 = _csignals_T_85 ? 2'h1 : _csignals_T_449; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_451 = _csignals_T_83 ? 2'h1 : _csignals_T_450; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_452 = _csignals_T_81 ? 2'h1 : _csignals_T_451; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_453 = _csignals_T_79 ? 2'h1 : _csignals_T_452; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_454 = _csignals_T_77 ? 2'h1 : _csignals_T_453; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_455 = _csignals_T_75 ? 2'h1 : _csignals_T_454; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_456 = _csignals_T_73 ? 2'h1 : _csignals_T_455; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_457 = _csignals_T_71 ? 2'h1 : _csignals_T_456; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_458 = _csignals_T_69 ? 2'h1 : _csignals_T_457; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_459 = _csignals_T_67 ? 2'h1 : _csignals_T_458; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_460 = _csignals_T_65 ? 2'h0 : _csignals_T_459; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_461 = _csignals_T_63 ? 2'h0 : _csignals_T_460; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_462 = _csignals_T_61 ? 2'h0 : _csignals_T_461; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_463 = _csignals_T_59 ? 2'h0 : _csignals_T_462; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_464 = _csignals_T_57 ? 2'h0 : _csignals_T_463; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_465 = _csignals_T_55 ? 2'h0 : _csignals_T_464; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_466 = _csignals_T_53 ? 2'h1 : _csignals_T_465; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_467 = _csignals_T_51 ? 2'h1 : _csignals_T_466; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_468 = _csignals_T_49 ? 2'h1 : _csignals_T_467; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_469 = _csignals_T_47 ? 2'h1 : _csignals_T_468; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_470 = _csignals_T_45 ? 2'h1 : _csignals_T_469; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_471 = _csignals_T_43 ? 2'h1 : _csignals_T_470; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_472 = _csignals_T_41 ? 2'h1 : _csignals_T_471; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_473 = _csignals_T_39 ? 2'h1 : _csignals_T_472; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_474 = _csignals_T_37 ? 2'h1 : _csignals_T_473; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_475 = _csignals_T_35 ? 2'h1 : _csignals_T_474; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_476 = _csignals_T_33 ? 2'h1 : _csignals_T_475; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_477 = _csignals_T_31 ? 2'h1 : _csignals_T_476; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_478 = _csignals_T_29 ? 2'h1 : _csignals_T_477; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_479 = _csignals_T_27 ? 2'h1 : _csignals_T_478; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_480 = _csignals_T_25 ? 2'h1 : _csignals_T_479; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_481 = _csignals_T_23 ? 2'h1 : _csignals_T_480; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_482 = _csignals_T_21 ? 2'h1 : _csignals_T_481; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_483 = _csignals_T_19 ? 2'h1 : _csignals_T_482; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_484 = _csignals_T_17 ? 2'h1 : _csignals_T_483; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_485 = _csignals_T_15 ? 2'h0 : _csignals_T_484; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_486 = _csignals_T_13 ? 2'h1 : _csignals_T_485; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_487 = _csignals_T_11 ? 2'h0 : _csignals_T_486; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_488 = _csignals_T_9 ? 2'h1 : _csignals_T_487; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_489 = _csignals_T_7 ? 2'h1 : _csignals_T_488; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_490 = _csignals_T_5 ? 2'h0 : _csignals_T_489; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_491 = _csignals_T_3 ? 2'h1 : _csignals_T_490; // @[Lookup.scala 34:39]
  wire [1:0] csignals_4 = _csignals_T_1 ? 2'h1 : _csignals_T_491; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_495 = _csignals_T_135 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_496 = _csignals_T_133 ? 3'h2 : _csignals_T_495; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_497 = _csignals_T_131 ? 3'h2 : _csignals_T_496; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_498 = _csignals_T_129 ? 3'h0 : _csignals_T_497; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_499 = _csignals_T_127 ? 3'h0 : _csignals_T_498; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_500 = _csignals_T_125 ? 3'h0 : _csignals_T_499; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_501 = _csignals_T_123 ? 3'h0 : _csignals_T_500; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_502 = _csignals_T_121 ? 3'h0 : _csignals_T_501; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_503 = _csignals_T_119 ? 3'h0 : _csignals_T_502; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_504 = _csignals_T_117 ? 3'h0 : _csignals_T_503; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_505 = _csignals_T_115 ? 3'h0 : _csignals_T_504; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_506 = _csignals_T_113 ? 3'h0 : _csignals_T_505; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_507 = _csignals_T_111 ? 3'h0 : _csignals_T_506; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_508 = _csignals_T_109 ? 3'h0 : _csignals_T_507; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_509 = _csignals_T_107 ? 3'h0 : _csignals_T_508; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_510 = _csignals_T_105 ? 3'h0 : _csignals_T_509; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_511 = _csignals_T_103 ? 3'h0 : _csignals_T_510; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_512 = _csignals_T_101 ? 3'h0 : _csignals_T_511; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_513 = _csignals_T_99 ? 3'h1 : _csignals_T_512; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_514 = _csignals_T_97 ? 3'h0 : _csignals_T_513; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_515 = _csignals_T_95 ? 3'h0 : _csignals_T_514; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_516 = _csignals_T_93 ? 3'h0 : _csignals_T_515; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_517 = _csignals_T_91 ? 3'h0 : _csignals_T_516; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_518 = _csignals_T_89 ? 3'h0 : _csignals_T_517; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_519 = _csignals_T_87 ? 3'h0 : _csignals_T_518; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_520 = _csignals_T_85 ? 3'h3 : _csignals_T_519; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_521 = _csignals_T_83 ? 3'h3 : _csignals_T_520; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_522 = _csignals_T_81 ? 3'h3 : _csignals_T_521; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_523 = _csignals_T_79 ? 3'h3 : _csignals_T_522; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_524 = _csignals_T_77 ? 3'h3 : _csignals_T_523; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_525 = _csignals_T_75 ? 3'h3 : _csignals_T_524; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_526 = _csignals_T_73 ? 3'h0 : _csignals_T_525; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_527 = _csignals_T_71 ? 3'h0 : _csignals_T_526; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_528 = _csignals_T_69 ? 3'h2 : _csignals_T_527; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_529 = _csignals_T_67 ? 3'h2 : _csignals_T_528; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_530 = _csignals_T_65 ? 3'h0 : _csignals_T_529; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_531 = _csignals_T_63 ? 3'h0 : _csignals_T_530; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_532 = _csignals_T_61 ? 3'h0 : _csignals_T_531; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_533 = _csignals_T_59 ? 3'h0 : _csignals_T_532; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_534 = _csignals_T_57 ? 3'h0 : _csignals_T_533; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_535 = _csignals_T_55 ? 3'h0 : _csignals_T_534; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_536 = _csignals_T_53 ? 3'h0 : _csignals_T_535; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_537 = _csignals_T_51 ? 3'h0 : _csignals_T_536; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_538 = _csignals_T_49 ? 3'h0 : _csignals_T_537; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_539 = _csignals_T_47 ? 3'h0 : _csignals_T_538; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_540 = _csignals_T_45 ? 3'h0 : _csignals_T_539; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_541 = _csignals_T_43 ? 3'h0 : _csignals_T_540; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_542 = _csignals_T_41 ? 3'h0 : _csignals_T_541; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_543 = _csignals_T_39 ? 3'h0 : _csignals_T_542; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_544 = _csignals_T_37 ? 3'h0 : _csignals_T_543; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_545 = _csignals_T_35 ? 3'h0 : _csignals_T_544; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_546 = _csignals_T_33 ? 3'h0 : _csignals_T_545; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_547 = _csignals_T_31 ? 3'h0 : _csignals_T_546; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_548 = _csignals_T_29 ? 3'h0 : _csignals_T_547; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_549 = _csignals_T_27 ? 3'h0 : _csignals_T_548; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_550 = _csignals_T_25 ? 3'h0 : _csignals_T_549; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_551 = _csignals_T_23 ? 3'h0 : _csignals_T_550; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_552 = _csignals_T_21 ? 3'h0 : _csignals_T_551; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_553 = _csignals_T_19 ? 3'h0 : _csignals_T_552; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_554 = _csignals_T_17 ? 3'h0 : _csignals_T_553; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_555 = _csignals_T_15 ? 3'h0 : _csignals_T_554; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_556 = _csignals_T_13 ? 3'h1 : _csignals_T_555; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_557 = _csignals_T_11 ? 3'h0 : _csignals_T_556; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_558 = _csignals_T_9 ? 3'h1 : _csignals_T_557; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_559 = _csignals_T_7 ? 3'h1 : _csignals_T_558; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_560 = _csignals_T_5 ? 3'h0 : _csignals_T_559; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_561 = _csignals_T_3 ? 3'h1 : _csignals_T_560; // @[Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h1 : _csignals_T_561; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_562 = _csignals_T_141 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_563 = _csignals_T_139 ? 3'h1 : _csignals_T_562; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_564 = _csignals_T_137 ? 3'h1 : _csignals_T_563; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_565 = _csignals_T_135 ? 3'h1 : _csignals_T_564; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_566 = _csignals_T_133 ? 3'h4 : _csignals_T_565; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_567 = _csignals_T_131 ? 3'h4 : _csignals_T_566; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_568 = _csignals_T_129 ? 3'h1 : _csignals_T_567; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_569 = _csignals_T_127 ? 3'h1 : _csignals_T_568; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_570 = _csignals_T_125 ? 3'h1 : _csignals_T_569; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_571 = _csignals_T_123 ? 3'h1 : _csignals_T_570; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_572 = _csignals_T_121 ? 3'h1 : _csignals_T_571; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_573 = _csignals_T_119 ? 3'h2 : _csignals_T_572; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_574 = _csignals_T_117 ? 3'h2 : _csignals_T_573; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_575 = _csignals_T_115 ? 3'h2 : _csignals_T_574; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_576 = _csignals_T_113 ? 3'h2 : _csignals_T_575; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_577 = _csignals_T_111 ? 3'h2 : _csignals_T_576; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_578 = _csignals_T_109 ? 3'h2 : _csignals_T_577; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_579 = _csignals_T_107 ? 3'h2 : _csignals_T_578; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_580 = _csignals_T_105 ? 3'h1 : _csignals_T_579; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_581 = _csignals_T_103 ? 3'h1 : _csignals_T_580; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_582 = _csignals_T_101 ? 3'h1 : _csignals_T_581; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_583 = _csignals_T_99 ? 3'h3 : _csignals_T_582; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_584 = _csignals_T_97 ? 3'h1 : _csignals_T_583; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_585 = _csignals_T_95 ? 3'h1 : _csignals_T_584; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_586 = _csignals_T_93 ? 3'h3 : _csignals_T_585; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_587 = _csignals_T_91 ? 3'h1 : _csignals_T_586; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_588 = _csignals_T_89 ? 3'h0 : _csignals_T_587; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_589 = _csignals_T_87 ? 3'h0 : _csignals_T_588; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_590 = _csignals_T_85 ? 3'h0 : _csignals_T_589; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_591 = _csignals_T_83 ? 3'h0 : _csignals_T_590; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_592 = _csignals_T_81 ? 3'h0 : _csignals_T_591; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_593 = _csignals_T_79 ? 3'h0 : _csignals_T_592; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_594 = _csignals_T_77 ? 3'h0 : _csignals_T_593; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_595 = _csignals_T_75 ? 3'h0 : _csignals_T_594; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_596 = _csignals_T_73 ? 3'h0 : _csignals_T_595; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_597 = _csignals_T_71 ? 3'h0 : _csignals_T_596; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_598 = _csignals_T_69 ? 3'h0 : _csignals_T_597; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_599 = _csignals_T_67 ? 3'h0 : _csignals_T_598; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_600 = _csignals_T_65 ? 3'h0 : _csignals_T_599; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_601 = _csignals_T_63 ? 3'h0 : _csignals_T_600; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_602 = _csignals_T_61 ? 3'h0 : _csignals_T_601; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_603 = _csignals_T_59 ? 3'h0 : _csignals_T_602; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_604 = _csignals_T_57 ? 3'h0 : _csignals_T_603; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_605 = _csignals_T_55 ? 3'h0 : _csignals_T_604; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_606 = _csignals_T_53 ? 3'h0 : _csignals_T_605; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_607 = _csignals_T_51 ? 3'h0 : _csignals_T_606; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_608 = _csignals_T_49 ? 3'h0 : _csignals_T_607; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_609 = _csignals_T_47 ? 3'h0 : _csignals_T_608; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_610 = _csignals_T_45 ? 3'h0 : _csignals_T_609; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_611 = _csignals_T_43 ? 3'h0 : _csignals_T_610; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_612 = _csignals_T_41 ? 3'h0 : _csignals_T_611; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_613 = _csignals_T_39 ? 3'h0 : _csignals_T_612; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_614 = _csignals_T_37 ? 3'h0 : _csignals_T_613; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_615 = _csignals_T_35 ? 3'h0 : _csignals_T_614; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_616 = _csignals_T_33 ? 3'h0 : _csignals_T_615; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_617 = _csignals_T_31 ? 3'h0 : _csignals_T_616; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_618 = _csignals_T_29 ? 3'h0 : _csignals_T_617; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_619 = _csignals_T_27 ? 3'h0 : _csignals_T_618; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_620 = _csignals_T_25 ? 3'h0 : _csignals_T_619; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_621 = _csignals_T_23 ? 3'h0 : _csignals_T_620; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_622 = _csignals_T_21 ? 3'h0 : _csignals_T_621; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_623 = _csignals_T_19 ? 3'h0 : _csignals_T_622; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_624 = _csignals_T_17 ? 3'h0 : _csignals_T_623; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_625 = _csignals_T_15 ? 3'h0 : _csignals_T_624; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_626 = _csignals_T_13 ? 3'h0 : _csignals_T_625; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_627 = _csignals_T_11 ? 3'h0 : _csignals_T_626; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_628 = _csignals_T_9 ? 3'h0 : _csignals_T_627; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_629 = _csignals_T_7 ? 3'h0 : _csignals_T_628; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_630 = _csignals_T_5 ? 3'h0 : _csignals_T_629; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_631 = _csignals_T_3 ? 3'h0 : _csignals_T_630; // @[Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_631; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_658 = _csignals_T_89 ? 3'h6 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_659 = _csignals_T_87 ? 3'h4 : _csignals_T_658; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_660 = _csignals_T_85 ? 3'h3 : _csignals_T_659; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_661 = _csignals_T_83 ? 3'h3 : _csignals_T_660; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_662 = _csignals_T_81 ? 3'h2 : _csignals_T_661; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_663 = _csignals_T_79 ? 3'h2 : _csignals_T_662; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_664 = _csignals_T_77 ? 3'h1 : _csignals_T_663; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_665 = _csignals_T_75 ? 3'h1 : _csignals_T_664; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_666 = _csignals_T_73 ? 3'h0 : _csignals_T_665; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_667 = _csignals_T_71 ? 3'h0 : _csignals_T_666; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_69 ? 3'h0 : _csignals_T_667; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_67 ? 3'h0 : _csignals_T_668; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_65 ? 3'h0 : _csignals_T_669; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_63 ? 3'h0 : _csignals_T_670; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_61 ? 3'h0 : _csignals_T_671; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_59 ? 3'h0 : _csignals_T_672; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_57 ? 3'h0 : _csignals_T_673; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_55 ? 3'h0 : _csignals_T_674; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_53 ? 3'h0 : _csignals_T_675; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_677 = _csignals_T_51 ? 3'h0 : _csignals_T_676; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_678 = _csignals_T_49 ? 3'h0 : _csignals_T_677; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_679 = _csignals_T_47 ? 3'h0 : _csignals_T_678; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_680 = _csignals_T_45 ? 3'h0 : _csignals_T_679; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_681 = _csignals_T_43 ? 3'h0 : _csignals_T_680; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_682 = _csignals_T_41 ? 3'h0 : _csignals_T_681; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_683 = _csignals_T_39 ? 3'h0 : _csignals_T_682; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_684 = _csignals_T_37 ? 3'h0 : _csignals_T_683; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_685 = _csignals_T_35 ? 3'h0 : _csignals_T_684; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_686 = _csignals_T_33 ? 3'h0 : _csignals_T_685; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_687 = _csignals_T_31 ? 3'h0 : _csignals_T_686; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_688 = _csignals_T_29 ? 3'h0 : _csignals_T_687; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_689 = _csignals_T_27 ? 3'h0 : _csignals_T_688; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_690 = _csignals_T_25 ? 3'h0 : _csignals_T_689; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_691 = _csignals_T_23 ? 3'h0 : _csignals_T_690; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_692 = _csignals_T_21 ? 3'h0 : _csignals_T_691; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_693 = _csignals_T_19 ? 3'h0 : _csignals_T_692; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_694 = _csignals_T_17 ? 3'h0 : _csignals_T_693; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_695 = _csignals_T_15 ? 3'h0 : _csignals_T_694; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_696 = _csignals_T_13 ? 3'h0 : _csignals_T_695; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_697 = _csignals_T_11 ? 3'h0 : _csignals_T_696; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_698 = _csignals_T_9 ? 3'h0 : _csignals_T_697; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_699 = _csignals_T_7 ? 3'h0 : _csignals_T_698; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_700 = _csignals_T_5 ? 3'h0 : _csignals_T_699; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_701 = _csignals_T_3 ? 3'h0 : _csignals_T_700; // @[Lookup.scala 34:39]
  wire [2:0] csignals_7 = _csignals_T_1 ? 3'h0 : _csignals_T_701; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_704 = _csignals_T_137 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_705 = _csignals_T_135 ? 3'h1 : _csignals_T_704; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_706 = _csignals_T_133 ? 3'h0 : _csignals_T_705; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_707 = _csignals_T_131 ? 3'h0 : _csignals_T_706; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_129 ? 3'h0 : _csignals_T_707; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_127 ? 3'h0 : _csignals_T_708; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_125 ? 3'h0 : _csignals_T_709; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_123 ? 3'h0 : _csignals_T_710; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_712 = _csignals_T_121 ? 3'h0 : _csignals_T_711; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_713 = _csignals_T_119 ? 3'h0 : _csignals_T_712; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_117 ? 3'h0 : _csignals_T_713; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_115 ? 3'h0 : _csignals_T_714; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_113 ? 3'h0 : _csignals_T_715; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_111 ? 3'h0 : _csignals_T_716; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_109 ? 3'h0 : _csignals_T_717; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_107 ? 3'h0 : _csignals_T_718; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_105 ? 3'h0 : _csignals_T_719; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_103 ? 3'h0 : _csignals_T_720; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_101 ? 3'h1 : _csignals_T_721; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_99 ? 3'h1 : _csignals_T_722; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_97 ? 3'h0 : _csignals_T_723; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_95 ? 3'h0 : _csignals_T_724; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_93 ? 3'h0 : _csignals_T_725; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_91 ? 3'h0 : _csignals_T_726; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_89 ? 3'h0 : _csignals_T_727; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_87 ? 3'h0 : _csignals_T_728; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_85 ? 3'h0 : _csignals_T_729; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_83 ? 3'h0 : _csignals_T_730; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_81 ? 3'h0 : _csignals_T_731; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_79 ? 3'h0 : _csignals_T_732; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_77 ? 3'h0 : _csignals_T_733; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_75 ? 3'h0 : _csignals_T_734; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_73 ? 3'h0 : _csignals_T_735; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_71 ? 3'h0 : _csignals_T_736; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_69 ? 3'h0 : _csignals_T_737; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_67 ? 3'h0 : _csignals_T_738; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_740 = _csignals_T_65 ? 3'h0 : _csignals_T_739; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_741 = _csignals_T_63 ? 3'h0 : _csignals_T_740; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_742 = _csignals_T_61 ? 3'h0 : _csignals_T_741; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_743 = _csignals_T_59 ? 3'h0 : _csignals_T_742; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_744 = _csignals_T_57 ? 3'h0 : _csignals_T_743; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_745 = _csignals_T_55 ? 3'h0 : _csignals_T_744; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_746 = _csignals_T_53 ? 3'h0 : _csignals_T_745; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_747 = _csignals_T_51 ? 3'h0 : _csignals_T_746; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_748 = _csignals_T_49 ? 3'h0 : _csignals_T_747; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_749 = _csignals_T_47 ? 3'h0 : _csignals_T_748; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_750 = _csignals_T_45 ? 3'h0 : _csignals_T_749; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_751 = _csignals_T_43 ? 3'h0 : _csignals_T_750; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_752 = _csignals_T_41 ? 3'h0 : _csignals_T_751; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_753 = _csignals_T_39 ? 3'h0 : _csignals_T_752; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_754 = _csignals_T_37 ? 3'h0 : _csignals_T_753; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_755 = _csignals_T_35 ? 3'h0 : _csignals_T_754; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_756 = _csignals_T_33 ? 3'h0 : _csignals_T_755; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_757 = _csignals_T_31 ? 3'h0 : _csignals_T_756; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_758 = _csignals_T_29 ? 3'h0 : _csignals_T_757; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_759 = _csignals_T_27 ? 3'h0 : _csignals_T_758; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_760 = _csignals_T_25 ? 3'h0 : _csignals_T_759; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_761 = _csignals_T_23 ? 3'h0 : _csignals_T_760; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_762 = _csignals_T_21 ? 3'h0 : _csignals_T_761; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_763 = _csignals_T_19 ? 3'h0 : _csignals_T_762; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_764 = _csignals_T_17 ? 3'h0 : _csignals_T_763; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_765 = _csignals_T_15 ? 3'h1 : _csignals_T_764; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_766 = _csignals_T_13 ? 3'h1 : _csignals_T_765; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_767 = _csignals_T_11 ? 3'h2 : _csignals_T_766; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_768 = _csignals_T_9 ? 3'h4 : _csignals_T_767; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_769 = _csignals_T_7 ? 3'h2 : _csignals_T_768; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_770 = _csignals_T_5 ? 3'h3 : _csignals_T_769; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_771 = _csignals_T_3 ? 3'h5 : _csignals_T_770; // @[Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h3 : _csignals_T_771; // @[Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 496:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 497:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 498:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 499:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h0; // @[Core.scala 503:17]
  wire  _id_op1_data_T_1 = csignals_1 == 3'h1; // @[Core.scala 504:17]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h3; // @[Core.scala 505:17]
  wire  _id_op1_data_T_3 = csignals_1 == 3'h4; // @[Core.scala 506:17]
  wire  _id_op1_data_T_4 = csignals_1 == 3'h5; // @[Core.scala 507:17]
  wire  _id_op1_data_T_5 = csignals_1 == 3'h6; // @[Core.scala 508:17]
  wire [31:0] _id_op1_data_T_6 = _id_op1_data_T_5 ? regfile_id_c_rs1p_data_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_7 = _id_op1_data_T_4 ? regfile_id_sp_data_data : _id_op1_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_8 = _id_op1_data_T_3 ? id_c_rs1_data : _id_op1_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_9 = _id_op1_data_T_2 ? id_imm_z_uext : _id_op1_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_10 = _id_op1_data_T_1 ? id_reg_pc : _id_op1_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? id_rs1_data : _id_op1_data_T_10; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 4'h1; // @[Core.scala 511:17]
  wire  _id_op2_data_T_1 = csignals_2 == 4'h2; // @[Core.scala 512:17]
  wire  _id_op2_data_T_2 = csignals_2 == 4'h3; // @[Core.scala 513:17]
  wire  _id_op2_data_T_3 = csignals_2 == 4'h4; // @[Core.scala 514:17]
  wire  _id_op2_data_T_4 = csignals_2 == 4'h5; // @[Core.scala 515:17]
  wire  _id_op2_data_T_5 = csignals_2 == 4'h6; // @[Core.scala 516:17]
  wire  _id_op2_data_T_6 = csignals_2 == 4'h7; // @[Core.scala 517:17]
  wire  _id_op2_data_T_7 = csignals_2 == 4'h8; // @[Core.scala 518:17]
  wire  _id_op2_data_T_8 = csignals_2 == 4'h9; // @[Core.scala 519:17]
  wire  _id_op2_data_T_9 = csignals_2 == 4'ha; // @[Core.scala 520:17]
  wire  _id_op2_data_T_10 = csignals_2 == 4'hb; // @[Core.scala 521:17]
  wire  _id_op2_data_T_11 = csignals_2 == 4'hc; // @[Core.scala 522:17]
  wire  _id_op2_data_T_12 = csignals_2 == 4'hd; // @[Core.scala 523:17]
  wire  _id_op2_data_T_13 = csignals_2 == 4'he; // @[Core.scala 524:17]
  wire  _id_op2_data_T_14 = csignals_2 == 4'hf; // @[Core.scala 525:17]
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
  wire  _id_csr_addr_T = csignals_7 == 3'h4; // @[Core.scala 528:36]
  wire [11:0] id_csr_addr = csignals_7 == 3'h4 ? 12'h342 : id_imm_i; // @[Core.scala 528:24]
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
  wire  id_is_j = _id_op2_data_T_3 | _id_op2_data_T_12; // @[Core.scala 558:42]
  reg [31:0] id_reg_pc_delay; // @[Core.scala 563:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 564:40]
  reg [2:0] id_reg_op1_sel_delay; // @[Core.scala 565:40]
  reg [3:0] id_reg_op2_sel_delay; // @[Core.scala 566:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 567:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 568:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 569:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 570:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 572:40]
  reg [1:0] id_reg_mem_wen_delay; // @[Core.scala 573:40]
  reg [1:0] id_reg_rf_wen_delay; // @[Core.scala 574:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 575:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 576:40]
  reg [2:0] id_reg_csr_cmd_delay; // @[Core.scala 577:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 580:40]
  reg [31:0] id_reg_mem_w_delay; // @[Core.scala 583:40]
  reg  id_reg_is_j_delay; // @[Core.scala 584:40]
  reg  id_reg_is_bp_pos_delay; // @[Core.scala 585:40]
  reg [31:0] id_reg_bp_addr_delay; // @[Core.scala 586:40]
  reg  id_reg_is_half_delay; // @[Core.scala 587:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 588:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 589:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 590:40]
  wire [31:0] _GEN_0 = _ic_read_en2_T ? id_reg_pc : id_reg_pc_delay; // @[Core.scala 594:26 595:32 563:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 633:43]
  wire [31:0] _GEN_51 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 642:24 643:29 669:29]
  wire [2:0] _GEN_52 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 642:24 644:29 670:29]
  wire [3:0] _GEN_53 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 642:24 645:29 671:29]
  wire [4:0] _GEN_54 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 642:24 646:29 672:29]
  wire [4:0] _GEN_55 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 642:24 647:29 673:29]
  wire [31:0] _GEN_56 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 642:24 648:29 674:29]
  wire [31:0] _GEN_57 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[Core.scala 642:24 649:29 675:29]
  wire [4:0] _GEN_59 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 642:24 651:29 677:29]
  wire [31:0] _GEN_63 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 642:24 655:29 681:29]
  wire [11:0] _GEN_64 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 642:24 656:29 682:29]
  wire [31:0] _GEN_66 = id_reg_stall ? id_reg_bp_addr_delay : id_reg_bp_addr; // @[Core.scala 642:24 662:29 688:29]
  wire  _GEN_67 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 642:24 663:29 689:29]
  wire [31:0] _GEN_68 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 642:24 666:29 692:29]
  wire  _T_8 = ~ex1_stall; // @[Core.scala 695:14]
  wire  _T_9 = ~mem_stall; // @[Core.scala 695:28]
  reg  ex1_reg_fw_en; // @[Core.scala 762:38]
  reg  ex2_reg_fw_en; // @[Core.scala 765:38]
  reg [31:0] ex2_reg_fw_data; // @[Core.scala 767:38]
  reg [1:0] mem_reg_rf_wen_delay; // @[Core.scala 768:38]
  reg [31:0] mem_reg_wb_data_delay; // @[Core.scala 770:38]
  reg [1:0] wb_reg_rf_wen_delay; // @[Core.scala 771:38]
  reg [4:0] wb_reg_wb_addr_delay; // @[Core.scala 772:38]
  reg [31:0] wb_reg_wb_data_delay; // @[Core.scala 773:38]
  wire  _ex1_op1_data_T_2 = _ex1_stall_T & ex1_reg_rs1_addr == 5'h0; // @[Core.scala 790:34]
  wire  _ex1_op1_data_T_4 = ex1_reg_fw_en & _ex1_stall_T; // @[Core.scala 791:20]
  wire  _ex1_op1_data_T_6 = _ex1_op1_data_T_4 & _ex1_stall_T_2; // @[Core.scala 792:36]
  wire  _ex1_op1_data_T_8 = ex2_reg_fw_en & _ex1_stall_T; // @[Core.scala 794:20]
  wire  _ex1_op1_data_T_10 = _ex1_op1_data_T_8 & _ex1_stall_T_6; // @[Core.scala 795:36]
  wire  _ex1_op1_data_T_11 = mem_reg_rf_wen_delay == 2'h1; // @[Core.scala 797:28]
  wire  _ex1_op1_data_T_13 = mem_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 797:39]
  wire  _ex1_op1_data_T_14 = ex1_reg_rs1_addr == wb_reg_wb_addr; // @[Core.scala 799:24]
  wire  _ex1_op1_data_T_15 = _ex1_op1_data_T_13 & _ex1_op1_data_T_14; // @[Core.scala 798:36]
  wire  _ex1_op1_data_T_16 = wb_reg_rf_wen_delay == 2'h1; // @[Core.scala 800:27]
  wire  _ex1_op1_data_T_18 = wb_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 800:38]
  wire  _ex1_op1_data_T_19 = ex1_reg_rs1_addr == wb_reg_wb_addr_delay; // @[Core.scala 802:24]
  wire  _ex1_op1_data_T_20 = _ex1_op1_data_T_18 & _ex1_op1_data_T_19; // @[Core.scala 801:36]
  wire [31:0] _ex1_op1_data_T_22 = _ex1_stall_T ? regfile_ex1_op1_data_MPORT_data : ex1_reg_op1_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_23 = _ex1_op1_data_T_20 ? wb_reg_wb_data_delay : _ex1_op1_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_24 = _ex1_op1_data_T_15 ? mem_reg_wb_data_delay : _ex1_op1_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_25 = _ex1_op1_data_T_10 ? ex2_reg_fw_data : _ex1_op1_data_T_24; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex2_reg_wb_sel == 3'h2; // @[Core.scala 912:21]
  wire [31:0] _ex1_fw_data_T_2 = ex2_reg_pc + 32'h2; // @[Core.scala 913:18]
  wire [31:0] _ex1_fw_data_T_4 = ex2_reg_pc + 32'h4; // @[Core.scala 914:18]
  wire [31:0] _ex1_fw_data_T_5 = ex2_reg_is_half ? _ex1_fw_data_T_2 : _ex1_fw_data_T_4; // @[Core.scala 912:38]
  wire  _ex2_alu_out_T = ex2_reg_exe_fun == 5'h1; // @[Core.scala 876:22]
  wire [31:0] _ex2_alu_out_T_2 = ex2_reg_op1_data + ex2_reg_op2_data; // @[Core.scala 876:58]
  wire  _ex2_alu_out_T_3 = ex2_reg_exe_fun == 5'h2; // @[Core.scala 877:22]
  wire [31:0] _ex2_alu_out_T_5 = ex2_reg_op1_data - ex2_reg_op2_data; // @[Core.scala 877:58]
  wire  _ex2_alu_out_T_6 = ex2_reg_exe_fun == 5'h3; // @[Core.scala 878:22]
  wire [31:0] _ex2_alu_out_T_7 = ex2_reg_op1_data & ex2_reg_op2_data; // @[Core.scala 878:58]
  wire  _ex2_alu_out_T_8 = ex2_reg_exe_fun == 5'h4; // @[Core.scala 879:22]
  wire [31:0] _ex2_alu_out_T_9 = ex2_reg_op1_data | ex2_reg_op2_data; // @[Core.scala 879:58]
  wire  _ex2_alu_out_T_10 = ex2_reg_exe_fun == 5'h5; // @[Core.scala 880:22]
  wire [31:0] _ex2_alu_out_T_11 = ex2_reg_op1_data ^ ex2_reg_op2_data; // @[Core.scala 880:58]
  wire  _ex2_alu_out_T_12 = ex2_reg_exe_fun == 5'h6; // @[Core.scala 881:22]
  wire [62:0] _GEN_1 = {{31'd0}, ex2_reg_op1_data}; // @[Core.scala 881:58]
  wire [62:0] _ex2_alu_out_T_14 = _GEN_1 << ex2_reg_op2_data[4:0]; // @[Core.scala 881:58]
  wire  _ex2_alu_out_T_16 = ex2_reg_exe_fun == 5'h7; // @[Core.scala 882:22]
  wire [31:0] _ex2_alu_out_T_18 = ex2_reg_op1_data >> ex2_reg_op2_data[4:0]; // @[Core.scala 882:58]
  wire  _ex2_alu_out_T_19 = ex2_reg_exe_fun == 5'h8; // @[Core.scala 883:22]
  wire [31:0] _ex2_alu_out_T_23 = $signed(ex2_reg_op1_data) >>> ex2_reg_op2_data[4:0]; // @[Core.scala 883:100]
  wire  _ex2_alu_out_T_24 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 884:22]
  wire  _ex2_alu_out_T_27 = $signed(ex2_reg_op1_data) < $signed(ex2_reg_op2_data); // @[Core.scala 884:67]
  wire  _ex2_alu_out_T_28 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 885:22]
  wire  _ex2_alu_out_T_29 = ex2_reg_op1_data < ex2_reg_op2_data; // @[Core.scala 885:58]
  wire  _ex2_alu_out_T_30 = ex2_reg_exe_fun == 5'h11; // @[Core.scala 886:22]
  wire [31:0] _ex2_alu_out_T_34 = _ex2_alu_out_T_2 & 32'hfffffffe; // @[Core.scala 886:79]
  wire  _ex2_alu_out_T_35 = ex2_reg_exe_fun == 5'h12; // @[Core.scala 887:22]
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
  wire  _ex1_op2_data_T_1 = ex1_reg_rs2_addr == 5'h0; // @[Core.scala 806:54]
  wire  _ex1_op2_data_T_2 = _ex1_stall_T_9 & ex1_reg_rs2_addr == 5'h0; // @[Core.scala 806:34]
  wire  _ex1_op2_data_T_4 = ex1_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 807:20]
  wire  _ex1_op2_data_T_6 = _ex1_op2_data_T_4 & _ex1_stall_T_13; // @[Core.scala 808:36]
  wire  _ex1_op2_data_T_8 = ex2_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 810:20]
  wire  _ex1_op2_data_T_10 = _ex1_op2_data_T_8 & _ex1_stall_T_20; // @[Core.scala 811:36]
  wire  _ex1_op2_data_T_13 = _ex1_op1_data_T_11 & _ex1_stall_T_9; // @[Core.scala 813:39]
  wire  _ex1_op2_data_T_14 = ex1_reg_rs2_addr == wb_reg_wb_addr; // @[Core.scala 815:24]
  wire  _ex1_op2_data_T_15 = _ex1_op2_data_T_13 & _ex1_op2_data_T_14; // @[Core.scala 814:36]
  wire  _ex1_op2_data_T_18 = _ex1_op1_data_T_16 & _ex1_stall_T_9; // @[Core.scala 816:38]
  wire  _ex1_op2_data_T_19 = ex1_reg_rs2_addr == wb_reg_wb_addr_delay; // @[Core.scala 818:24]
  wire  _ex1_op2_data_T_20 = _ex1_op2_data_T_18 & _ex1_op2_data_T_19; // @[Core.scala 817:36]
  wire [31:0] _ex1_op2_data_T_22 = _ex1_stall_T_9 ? regfile_ex1_op2_data_MPORT_data : ex1_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_23 = _ex1_op2_data_T_20 ? wb_reg_wb_data_delay : _ex1_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_24 = _ex1_op2_data_T_15 ? mem_reg_wb_data_delay : _ex1_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_25 = _ex1_op2_data_T_10 ? ex2_reg_fw_data : _ex1_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_26 = _ex1_op2_data_T_6 ? ex1_fw_data : _ex1_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op2_data = _ex1_op2_data_T_2 ? 32'h0 : _ex1_op2_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_rs2_data_T_2 = ex1_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 823:20]
  wire  _ex1_rs2_data_T_4 = ex2_reg_fw_en & _ex1_stall_T_20; // @[Core.scala 825:20]
  wire  _ex1_rs2_data_T_7 = _ex1_op1_data_T_11 & _ex1_op2_data_T_14; // @[Core.scala 827:39]
  wire  _ex1_rs2_data_T_10 = _ex1_op1_data_T_16 & _ex1_op2_data_T_19; // @[Core.scala 829:38]
  wire [31:0] _ex1_rs2_data_T_11 = _ex1_rs2_data_T_10 ? wb_reg_wb_data_delay : regfile_ex1_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_12 = _ex1_rs2_data_T_7 ? mem_reg_wb_data_delay : _ex1_rs2_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_13 = _ex1_rs2_data_T_4 ? ex2_reg_fw_data : _ex1_rs2_data_T_12; // @[Mux.scala 101:16]
  wire  ex1_hazard = ex1_reg_rf_wen == 2'h1 & ex1_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 840:96]
  wire  ex_is_bubble = ex1_stall | mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 848:51]
  wire  _ex2_is_cond_br_T = ex2_reg_exe_fun == 5'hb; // @[Core.scala 892:22]
  wire  _ex2_is_cond_br_T_1 = ex2_reg_op1_data == ex2_reg_op2_data; // @[Core.scala 892:57]
  wire  _ex2_is_cond_br_T_2 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 893:22]
  wire  _ex2_is_cond_br_T_4 = ~_ex2_is_cond_br_T_1; // @[Core.scala 893:38]
  wire  _ex2_is_cond_br_T_5 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 894:22]
  wire  _ex2_is_cond_br_T_9 = ex2_reg_exe_fun == 5'he; // @[Core.scala 895:22]
  wire  _ex2_is_cond_br_T_13 = ~_ex2_alu_out_T_27; // @[Core.scala 895:38]
  wire  _ex2_is_cond_br_T_14 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 896:22]
  wire  _ex2_is_cond_br_T_16 = ex2_reg_exe_fun == 5'h10; // @[Core.scala 897:22]
  wire  _ex2_is_cond_br_T_18 = ~_ex2_alu_out_T_29; // @[Core.scala 897:38]
  wire  _ex2_is_cond_br_T_20 = _ex2_is_cond_br_T_14 ? _ex2_alu_out_T_29 : _ex2_is_cond_br_T_16 & _ex2_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_21 = _ex2_is_cond_br_T_9 ? _ex2_is_cond_br_T_13 : _ex2_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_inst_T_2 = _ex2_is_cond_br_T | _ex2_is_cond_br_T_2; // @[Core.scala 900:34]
  wire  _ex2_is_cond_br_inst_T_4 = _ex2_is_cond_br_inst_T_2 | _ex2_is_cond_br_T_5; // @[Core.scala 901:34]
  wire  _ex2_is_cond_br_inst_T_6 = _ex2_is_cond_br_inst_T_4 | _ex2_is_cond_br_T_9; // @[Core.scala 902:34]
  wire  _ex2_is_cond_br_inst_T_8 = _ex2_is_cond_br_inst_T_6 | _ex2_is_cond_br_T_14; // @[Core.scala 903:34]
  wire  ex2_is_cond_br_inst = _ex2_is_cond_br_inst_T_8 | _ex2_is_cond_br_T_16; // @[Core.scala 904:35]
  wire [31:0] ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext; // @[Core.scala 908:39]
  wire  ex2_hazard = ex2_reg_rf_wen == 2'h1 & ex2_reg_wb_addr != 5'h0 & _mem_en_T & _mem_en_T_2; // @[Core.scala 919:96]
  wire  _ex3_reg_bp_en_T_2 = _mem_en_T & _mem_en_T_2; // @[Core.scala 926:46]
  wire  ex3_bp_en = ex3_reg_bp_en & _mem_en_T & _mem_en_T_2; // @[Core.scala 942:51]
  wire  _ex3_cond_bp_fail_T = ~ex3_reg_is_bp_pos; // @[Core.scala 944:6]
  wire  _ex3_cond_bp_fail_T_4 = ex3_reg_is_bp_pos & ex3_reg_is_cond_br & ex3_reg_bp_addr != ex3_reg_cond_br_target; // @[Core.scala 945:46]
  wire  _ex3_cond_bp_fail_T_5 = ~ex3_reg_is_bp_pos & ex3_reg_is_cond_br | _ex3_cond_bp_fail_T_4; // @[Core.scala 944:48]
  wire  ex3_cond_bp_fail = ex3_bp_en & _ex3_cond_bp_fail_T_5; // @[Core.scala 943:36]
  wire  ex3_cond_nbp_fail = ex3_bp_en & ex3_reg_is_bp_pos & ex3_reg_is_cond_br_inst & ~ex3_reg_is_cond_br; // @[Core.scala 947:85]
  wire  _ex3_uncond_bp_fail_T = ex3_bp_en & ex3_reg_is_uncond_br; // @[Core.scala 948:39]
  wire  _ex3_uncond_bp_fail_T_3 = ex3_reg_is_bp_pos & ex3_reg_bp_addr != ex3_reg_uncond_br_target; // @[Core.scala 950:24]
  wire  _ex3_uncond_bp_fail_T_4 = _ex3_cond_bp_fail_T | _ex3_uncond_bp_fail_T_3; // @[Core.scala 949:24]
  wire  ex3_uncond_bp_fail = ex3_bp_en & ex3_reg_is_uncond_br & _ex3_uncond_bp_fail_T_4; // @[Core.scala 948:64]
  wire [31:0] _ex3_reg_br_target_T_1 = ex3_reg_pc + 32'h2; // @[Core.scala 954:59]
  wire [31:0] _ex3_reg_br_target_T_3 = ex3_reg_pc + 32'h4; // @[Core.scala 954:89]
  wire [31:0] _bp_io_up_br_addr_T = ex3_reg_is_uncond_br ? ex3_reg_uncond_br_target : 32'h0; // @[Mux.scala 101:16]
  wire  _ex3_cond_bp_success_T_2 = ex3_reg_is_bp_pos & ex3_reg_bp_addr == ex3_reg_cond_br_target; // @[Core.scala 968:23]
  wire  ex3_cond_bp_success = ex3_bp_en & ex3_reg_is_cond_br & _ex3_cond_bp_success_T_2; // @[Core.scala 967:61]
  wire  _ex3_uncond_bp_success_T_2 = ex3_reg_is_bp_pos & ex3_reg_bp_addr == ex3_reg_uncond_br_target; // @[Core.scala 971:23]
  wire  ex3_uncond_bp_success = _ex3_uncond_bp_fail_T & _ex3_uncond_bp_success_T_2; // @[Core.scala 970:65]
  wire  ex3_j_success = ex3_bp_en & ex3_reg_is_j; // @[Core.scala 973:33]
  wire  _mem_reg_mem_wstrb_T = ex2_reg_mem_w == 32'h3; // @[Core.scala 998:22]
  wire  _mem_reg_mem_wstrb_T_1 = ex2_reg_mem_w == 32'h2; // @[Core.scala 999:22]
  wire [3:0] _mem_reg_mem_wstrb_T_4 = _mem_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem_reg_mem_wstrb_T_5 = _mem_reg_mem_wstrb_T ? 4'h1 : _mem_reg_mem_wstrb_T_4; // @[Mux.scala 101:16]
  wire [6:0] _GEN_8 = {{3'd0}, _mem_reg_mem_wstrb_T_5}; // @[Core.scala 1001:8]
  wire [6:0] _mem_reg_mem_wstrb_T_7 = _GEN_8 << ex2_alu_out[1:0]; // @[Core.scala 1001:8]
  wire  mem_is_trap = mem_reg_is_trap & _mem_en_T & _mem_en_T_2 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1014:91]
  wire [2:0] mem_csr_cmd = mem_en ? mem_reg_csr_cmd : 3'h0; // @[Core.scala 1018:24]
  wire [5:0] _io_dmem_wdata_T_1 = 4'h8 * mem_reg_alu_out[1:0]; // @[Core.scala 1027:46]
  wire [94:0] _GEN_25 = {{63'd0}, mem_reg_rs2_data}; // @[Core.scala 1027:38]
  wire [94:0] _io_dmem_wdata_T_2 = _GEN_25 << _io_dmem_wdata_T_1; // @[Core.scala 1027:38]
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
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 1050:18]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 1051:18]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | mem_reg_op1_data; // @[Core.scala 1051:43]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 1052:18]
  wire [31:0] _csr_wdata_T_4 = ~mem_reg_op1_data; // @[Core.scala 1052:45]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1052:43]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? mem_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _GEN_173 = mem_reg_csr_addr == 12'h304 ? csr_wdata : csr_mie; // @[Core.scala 1064:52 1065:15 65:29]
  wire [31:0] _GEN_174 = mem_reg_csr_addr == 12'h340 ? csr_wdata : csr_mscratch; // @[Core.scala 1062:57 1063:20 64:29]
  wire [31:0] _GEN_175 = mem_reg_csr_addr == 12'h340 ? csr_mie : _GEN_173; // @[Core.scala 1062:57 65:29]
  wire [31:0] _GEN_176 = mem_reg_csr_addr == 12'h300 ? csr_wdata : csr_mstatus; // @[Core.scala 1060:56 1061:19 63:29]
  wire [31:0] _GEN_177 = mem_reg_csr_addr == 12'h300 ? csr_mscratch : _GEN_174; // @[Core.scala 1060:56 64:29]
  wire [31:0] _GEN_178 = mem_reg_csr_addr == 12'h300 ? csr_mie : _GEN_175; // @[Core.scala 1060:56 65:29]
  wire [31:0] _GEN_179 = mem_reg_csr_addr == 12'h341 ? csr_wdata : csr_mepc; // @[Core.scala 1058:53 1059:16 62:29]
  wire [31:0] _GEN_180 = mem_reg_csr_addr == 12'h341 ? csr_mstatus : _GEN_176; // @[Core.scala 1058:53 63:29]
  wire [31:0] _GEN_184 = mem_reg_csr_addr == 12'h305 ? csr_mepc : _GEN_179; // @[Core.scala 1056:48 62:29]
  wire [31:0] _GEN_185 = mem_reg_csr_addr == 12'h305 ? csr_mstatus : _GEN_180; // @[Core.scala 1056:48 63:29]
  wire [31:0] _GEN_189 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_184 : csr_mepc; // @[Core.scala 1055:82 62:29]
  wire [31:0] _GEN_190 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_185 : csr_mstatus; // @[Core.scala 1055:82 63:29]
  wire [31:0] _csr_mip_T_3 = {csr_mip[31:12],io_intr,csr_mip[10:8],mtimer_io_intr,csr_mip[6:0]}; // @[Cat.scala 31:58]
  wire [31:0] _csr_mepc_T = ex3_reg_is_br_before_trap ? ex3_reg_trap_pc : mem_reg_pc; // @[Mux.scala 101:16]
  wire [31:0] _csr_mepc_T_1 = ex3_reg_is_br ? ex3_reg_br_target : _csr_mepc_T; // @[Mux.scala 101:16]
  wire [31:0] _csr_mstatus_T_4 = {csr_mstatus[31:8],csr_mstatus[3],csr_mstatus[6:4],1'h0,csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire  _T_25 = mem_csr_cmd == 3'h6; // @[Core.scala 1101:27]
  wire [31:0] _csr_mstatus_T_19 = {csr_mstatus[31:8],1'h1,csr_mstatus[6:4],csr_mstatus[7],csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_193 = mem_csr_cmd == 3'h6 ? _csr_mstatus_T_19 : _GEN_190; // @[Core.scala 1101:38 1102:21]
  wire [31:0] _GEN_195 = mem_csr_cmd == 3'h6 ? csr_mepc : mem_reg_br_addr; // @[Core.scala 1101:38 1104:21 192:35]
  wire  _GEN_200 = mem_is_trap | _T_25; // @[Core.scala 1091:28 1099:21]
  wire  _GEN_206 = mem_is_mtintr | _GEN_200; // @[Core.scala 1081:30 1089:21]
  wire  _GEN_212 = mem_is_meintr | _GEN_206; // @[Core.scala 1071:24 1079:21]
  wire [31:0] mem_wb_rdata = io_dmem_rdata >> _io_dmem_wdata_T_1; // @[Core.scala 1117:36]
  wire  _mem_wb_data_load_T = mem_reg_mem_w == 32'h3; // @[Core.scala 1119:20]
  wire [23:0] _mem_wb_data_load_T_3 = mem_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_5 = {_mem_wb_data_load_T_3,mem_wb_rdata[7:0]}; // @[Core.scala 1110:40]
  wire  _mem_wb_data_load_T_6 = mem_reg_mem_w == 32'h2; // @[Core.scala 1120:20]
  wire [15:0] _mem_wb_data_load_T_9 = mem_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_11 = {_mem_wb_data_load_T_9,mem_wb_rdata[15:0]}; // @[Core.scala 1110:40]
  wire  _mem_wb_data_load_T_12 = mem_reg_mem_w == 32'h5; // @[Core.scala 1121:20]
  wire [31:0] _mem_wb_data_load_T_15 = {24'h0,mem_wb_rdata[7:0]}; // @[Core.scala 1113:31]
  wire  _mem_wb_data_load_T_16 = mem_reg_mem_w == 32'h4; // @[Core.scala 1122:20]
  wire [31:0] _mem_wb_data_load_T_19 = {16'h0,mem_wb_rdata[15:0]}; // @[Core.scala 1113:31]
  wire [31:0] _mem_wb_data_load_T_20 = _mem_wb_data_load_T_16 ? _mem_wb_data_load_T_19 : mem_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_21 = _mem_wb_data_load_T_12 ? _mem_wb_data_load_T_15 : _mem_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_22 = _mem_wb_data_load_T_6 ? _mem_wb_data_load_T_11 : _mem_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data_load = _mem_wb_data_load_T ? _mem_wb_data_load_T_5 : _mem_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T_1 = mem_wb_sel == 3'h2; // @[Core.scala 1127:17]
  wire [31:0] _mem_wb_data_T_3 = mem_reg_pc + 32'h2; // @[Core.scala 1127:64]
  wire [31:0] _mem_wb_data_T_5 = mem_reg_pc + 32'h4; // @[Core.scala 1127:94]
  wire [31:0] _mem_wb_data_T_6 = mem_reg_is_half ? _mem_wb_data_T_3 : _mem_wb_data_T_5; // @[Core.scala 1127:35]
  wire  _mem_wb_data_T_7 = mem_wb_sel == 3'h3; // @[Core.scala 1128:17]
  wire [31:0] _mem_wb_data_T_8 = _mem_wb_data_T_7 ? csr_rdata : mem_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_9 = _mem_wb_data_T_1 ? _mem_wb_data_T_6 : _mem_wb_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data = _mem_stall_T ? mem_wb_data_load : _mem_wb_data_T_9; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h1; // @[Core.scala 1155:24]
  reg  do_exit; // @[Core.scala 1170:24]
  reg  do_exit_delay; // @[Core.scala 1171:30]
  LongCounter cycle_counter ( // @[Core.scala 57:29]
    .clock(cycle_counter_clock),
    .reset(cycle_counter_reset),
    .io_value(cycle_counter_io_value)
  );
  MachineTimer mtimer ( // @[Core.scala 58:22]
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
  BranchPredictor bp ( // @[Core.scala 236:18]
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
  assign regfile_id_rs1_data_MPORT_data = regfile[regfile_id_rs1_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_id_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_rs2_data_MPORT_addr = id_inst[24:20];
  assign regfile_id_rs2_data_MPORT_data = regfile[regfile_id_rs2_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_id_c_rs1_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs1_data_MPORT_addr = id_inst[11:7];
  assign regfile_id_c_rs1_data_MPORT_data = regfile[regfile_id_c_rs1_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_id_c_rs2_data_MPORT_en = 1'h1;
  assign regfile_id_c_rs2_data_MPORT_addr = id_inst[6:2];
  assign regfile_id_c_rs2_data_MPORT_data = regfile[regfile_id_c_rs2_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_id_c_rs1p_data_en = 1'h1;
  assign regfile_id_c_rs1p_data_addr = {2'h1,id_inst[9:7]};
  assign regfile_id_c_rs1p_data_data = regfile[regfile_id_c_rs1p_data_addr]; // @[Core.scala 54:20]
  assign regfile_id_c_rs2p_data_en = 1'h1;
  assign regfile_id_c_rs2p_data_addr = {2'h1,id_inst[4:2]};
  assign regfile_id_c_rs2p_data_data = regfile[regfile_id_c_rs2p_data_addr]; // @[Core.scala 54:20]
  assign regfile_id_sp_data_en = 1'h1;
  assign regfile_id_sp_data_addr = 5'h2;
  assign regfile_id_sp_data_data = regfile[regfile_id_sp_data_addr]; // @[Core.scala 54:20]
  assign regfile_ex1_op1_data_MPORT_en = 1'h1;
  assign regfile_ex1_op1_data_MPORT_addr = ex1_reg_rs1_addr;
  assign regfile_ex1_op1_data_MPORT_data = regfile[regfile_ex1_op1_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_ex1_op2_data_MPORT_en = 1'h1;
  assign regfile_ex1_op2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_op2_data_MPORT_data = regfile[regfile_ex1_op2_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_ex1_rs2_data_MPORT_en = 1'h1;
  assign regfile_ex1_rs2_data_MPORT_addr = ex1_reg_rs2_addr;
  assign regfile_ex1_rs2_data_MPORT_data = regfile[regfile_ex1_rs2_data_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_io_gp_MPORT_en = 1'h1;
  assign regfile_io_gp_MPORT_addr = 5'h3;
  assign regfile_io_gp_MPORT_data = regfile[regfile_io_gp_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_do_exit_MPORT_en = 1'h1;
  assign regfile_do_exit_MPORT_addr = 5'h11;
  assign regfile_do_exit_MPORT_data = regfile[regfile_do_exit_MPORT_addr]; // @[Core.scala 54:20]
  assign regfile_MPORT_data = wb_reg_wb_data;
  assign regfile_MPORT_addr = wb_reg_wb_addr;
  assign regfile_MPORT_mask = 1'h1;
  assign regfile_MPORT_en = wb_reg_rf_wen == 2'h1;
  assign io_imem_addr = ic_fill_half ? _ic_mem_addr_T_2 : _ic_mem_addr_T_7; // @[Core.scala 216:24]
  assign io_dmem_raddr = mem_reg_alu_out; // @[Core.scala 1022:17]
  assign io_dmem_ren = io_dmem_rready & _mem_stall_T; // @[Core.scala 1024:35]
  assign io_dmem_waddr = mem_reg_alu_out; // @[Core.scala 1023:17]
  assign io_dmem_wen = io_dmem_wready & _mem_stall_T_6; // @[Core.scala 1025:35]
  assign io_dmem_wstrb = mem_reg_mem_wstrb; // @[Core.scala 1026:17]
  assign io_dmem_wdata = _io_dmem_wdata_T_2[31:0]; // @[Core.scala 1027:71]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 68:17]
  assign io_mtimer_mem_rvalid = mtimer_io_mem_rvalid; // @[Core.scala 68:17]
  assign io_exit = do_exit_delay; // @[Core.scala 1174:11]
  assign io_debug_signal_mem_reg_pc = mem_reg_pc; // @[Core.scala 1163:30]
  assign io_debug_signal_csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  assign io_debug_signal_mem_reg_csr_addr = {{20'd0}, mem_reg_csr_addr}; // @[Core.scala 1162:36]
  assign io_debug_signal_me_intr = csr_mstatus[3] & (io_intr & csr_mie[11]); // @[Core.scala 1012:45]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value; // @[Core.scala 1159:33]
  assign io_debug_signal_instret = instret; // @[Core.scala 1160:27]
  assign cycle_counter_clock = clock;
  assign cycle_counter_reset = reset;
  assign mtimer_clock = clock;
  assign mtimer_reset = reset;
  assign mtimer_io_mem_raddr = io_mtimer_mem_raddr; // @[Core.scala 68:17]
  assign mtimer_io_mem_ren = io_mtimer_mem_ren; // @[Core.scala 68:17]
  assign mtimer_io_mem_waddr = io_mtimer_mem_waddr; // @[Core.scala 68:17]
  assign mtimer_io_mem_wen = io_mtimer_mem_wen; // @[Core.scala 68:17]
  assign mtimer_io_mem_wdata = io_mtimer_mem_wdata; // @[Core.scala 68:17]
  assign bp_clock = clock;
  assign bp_reset = reset;
  assign bp_io_lu_inst_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 263:24]
  assign bp_io_up_update_en = ex3_bp_en & (ex3_reg_is_cond_br_inst | ex3_reg_is_uncond_br); // @[Core.scala 959:35]
  assign bp_io_up_inst_pc = ex3_reg_pc; // @[Core.scala 960:20]
  assign bp_io_up_br_pos = ex3_reg_is_cond_br | ex3_reg_is_uncond_br; // @[Core.scala 961:41]
  assign bp_io_up_br_addr = ex3_reg_is_cond_br ? ex3_reg_cond_br_target : _bp_io_up_br_addr_T; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (regfile_MPORT_en & regfile_MPORT_mask) begin
      regfile[regfile_MPORT_addr] <= regfile_MPORT_data; // @[Core.scala 54:20]
    end
    if (reset) begin // @[Core.scala 56:32]
      csr_trap_vector <= 32'h0; // @[Core.scala 56:32]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1055:82]
      if (mem_reg_csr_addr == 12'h305) begin // @[Core.scala 1056:48]
        if (_csr_wdata_T) begin // @[Mux.scala 101:16]
          csr_trap_vector <= mem_reg_op1_data;
        end else begin
          csr_trap_vector <= _csr_wdata_T_7;
        end
      end
    end
    if (reset) begin // @[Core.scala 59:24]
      instret <= 64'h0; // @[Core.scala 59:24]
    end else if (wb_reg_is_valid_inst) begin // @[Core.scala 1154:31]
      instret <= _instret_T_1; // @[Core.scala 1155:13]
    end
    if (reset) begin // @[Core.scala 60:29]
      csr_mcause <= 32'h0; // @[Core.scala 60:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1071:24]
      csr_mcause <= 32'h8000000b; // @[Core.scala 1072:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1081:30]
      csr_mcause <= 32'h80000007; // @[Core.scala 1082:21]
    end else if (mem_is_trap) begin // @[Core.scala 1091:28]
      csr_mcause <= mem_reg_mcause; // @[Core.scala 1092:21]
    end
    if (reset) begin // @[Core.scala 62:29]
      csr_mepc <= 32'h0; // @[Core.scala 62:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1071:24]
      csr_mepc <= _csr_mepc_T_1; // @[Core.scala 1074:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1081:30]
      csr_mepc <= _csr_mepc_T_1; // @[Core.scala 1084:21]
    end else if (mem_is_trap) begin // @[Core.scala 1091:28]
      csr_mepc <= _csr_mepc_T_1; // @[Core.scala 1094:21]
    end else begin
      csr_mepc <= _GEN_189;
    end
    if (reset) begin // @[Core.scala 63:29]
      csr_mstatus <= 32'h0; // @[Core.scala 63:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1071:24]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1078:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1081:30]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1088:21]
    end else if (mem_is_trap) begin // @[Core.scala 1091:28]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1098:21]
    end else begin
      csr_mstatus <= _GEN_193;
    end
    if (reset) begin // @[Core.scala 64:29]
      csr_mscratch <= 32'h0; // @[Core.scala 64:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1055:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1056:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1058:53]
          csr_mscratch <= _GEN_177;
        end
      end
    end
    if (reset) begin // @[Core.scala 65:29]
      csr_mie <= 32'h0; // @[Core.scala 65:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1055:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1056:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1058:53]
          csr_mie <= _GEN_178;
        end
      end
    end
    if (reset) begin // @[Core.scala 66:29]
      csr_mip <= 32'h0; // @[Core.scala 66:29]
    end else begin
      csr_mip <= _csr_mip_T_3; // @[Core.scala 1069:11]
    end
    if (reset) begin // @[Core.scala 74:38]
      id_reg_pc <= 32'h0; // @[Core.scala 74:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst)) begin // @[Core.scala 280:19]
        id_reg_pc <= if2_reg_pc;
      end else begin
        id_reg_pc <= ic_reg_addr_out;
      end
    end
    if (reset) begin // @[Core.scala 76:38]
      id_reg_inst <= 32'h0; // @[Core.scala 76:38]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (id_reg_stall) begin // @[Mux.scala 101:16]
      id_reg_inst <= if2_reg_inst;
    end else begin
      id_reg_inst <= _if2_inst_T_4;
    end
    if (reset) begin // @[Core.scala 77:38]
      id_reg_stall <= 1'h0; // @[Core.scala 77:38]
    end else begin
      id_reg_stall <= id_stall; // @[Core.scala 357:16]
    end
    if (reset) begin // @[Core.scala 78:38]
      id_reg_is_bp_pos <= 1'h0; // @[Core.scala 78:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Core.scala 321:26]
        id_reg_is_bp_pos <= if2_reg_is_bp_pos;
      end else begin
        id_reg_is_bp_pos <= _if2_is_bp_pos_T_6;
      end
    end
    if (reset) begin // @[Core.scala 79:38]
      id_reg_bp_addr <= 32'h0; // @[Core.scala 79:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= if2_reg_bp_addr;
      end else if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        id_reg_bp_addr <= bp_io_lu_br_addr;
      end else begin
        id_reg_bp_addr <= _if2_bp_addr_T_3;
      end
    end
    if (reset) begin // @[Core.scala 85:38]
      ex1_reg_pc <= 32'h0; // @[Core.scala 85:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_pc <= _GEN_51;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_pc <= _GEN_51;
    end
    if (reset) begin // @[Core.scala 86:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 86:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_wb_addr <= _GEN_59;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_wb_addr <= _GEN_59;
    end
    if (reset) begin // @[Core.scala 87:38]
      ex1_reg_op1_sel <= 3'h0; // @[Core.scala 87:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_op1_sel <= _GEN_52;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_op1_sel <= _GEN_52;
    end
    if (reset) begin // @[Core.scala 88:38]
      ex1_reg_op2_sel <= 4'h0; // @[Core.scala 88:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_op2_sel <= _GEN_53;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_op2_sel <= _GEN_53;
    end
    if (reset) begin // @[Core.scala 89:38]
      ex1_reg_rs1_addr <= 5'h0; // @[Core.scala 89:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_rs1_addr <= _GEN_54;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_rs1_addr <= _GEN_54;
    end
    if (reset) begin // @[Core.scala 90:38]
      ex1_reg_rs2_addr <= 5'h0; // @[Core.scala 90:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_rs2_addr <= _GEN_55;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_rs2_addr <= _GEN_55;
    end
    if (reset) begin // @[Core.scala 91:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 91:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_op1_data <= _GEN_56;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_op1_data <= _GEN_56;
    end
    if (reset) begin // @[Core.scala 92:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 92:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_op2_data <= _GEN_57;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_op2_data <= _GEN_57;
    end
    if (reset) begin // @[Core.scala 94:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 94:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_exe_fun <= 5'h1;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 708:29]
      end else begin
        ex1_reg_exe_fun <= csignals_0; // @[Core.scala 738:29]
      end
    end
    if (reset) begin // @[Core.scala 95:38]
      ex1_reg_mem_wen <= 2'h0; // @[Core.scala 95:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_mem_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_mem_wen <= id_reg_mem_wen_delay; // @[Core.scala 717:29]
      end else begin
        ex1_reg_mem_wen <= csignals_3; // @[Core.scala 747:29]
      end
    end
    if (reset) begin // @[Core.scala 96:38]
      ex1_reg_rf_wen <= 2'h0; // @[Core.scala 96:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_rf_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 707:29]
      end else begin
        ex1_reg_rf_wen <= csignals_4; // @[Core.scala 737:29]
      end
    end
    if (reset) begin // @[Core.scala 97:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 97:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_wb_sel <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 709:29]
      end else begin
        ex1_reg_wb_sel <= csignals_5; // @[Core.scala 739:29]
      end
    end
    if (reset) begin // @[Core.scala 98:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 98:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_csr_addr <= _GEN_64;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_csr_addr <= _GEN_64;
    end
    if (reset) begin // @[Core.scala 99:38]
      ex1_reg_csr_cmd <= 3'h0; // @[Core.scala 99:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_csr_cmd <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 716:29]
      end else begin
        ex1_reg_csr_cmd <= csignals_7; // @[Core.scala 746:29]
      end
    end
    if (reset) begin // @[Core.scala 102:38]
      ex1_reg_imm_b_sext <= 32'h0; // @[Core.scala 102:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_imm_b_sext <= _GEN_63;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_imm_b_sext <= _GEN_63;
    end
    if (reset) begin // @[Core.scala 105:38]
      ex1_reg_mem_w <= 32'h0; // @[Core.scala 105:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_mem_w <= 32'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 718:29]
      end else begin
        ex1_reg_mem_w <= {{29'd0}, csignals_8}; // @[Core.scala 748:29]
      end
    end
    if (reset) begin // @[Core.scala 106:39]
      ex1_reg_is_j <= 1'h0; // @[Core.scala 106:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_is_j <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_is_j <= id_reg_is_j_delay; // @[Core.scala 719:29]
      end else begin
        ex1_reg_is_j <= id_is_j; // @[Core.scala 749:29]
      end
    end
    if (reset) begin // @[Core.scala 107:39]
      ex1_reg_is_bp_pos <= 1'h0; // @[Core.scala 107:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_is_bp_pos <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos_delay; // @[Core.scala 720:29]
      end else begin
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos; // @[Core.scala 750:29]
      end
    end
    if (reset) begin // @[Core.scala 108:39]
      ex1_reg_bp_addr <= 32'h0; // @[Core.scala 108:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_bp_addr <= _GEN_66;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_bp_addr <= _GEN_66;
    end
    if (reset) begin // @[Core.scala 109:39]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 109:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_is_half <= _GEN_67;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_is_half <= _GEN_67;
    end
    if (reset) begin // @[Core.scala 110:39]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 110:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_is_valid_inst <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 723:29]
      end else begin
        ex1_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 753:29]
      end
    end
    if (reset) begin // @[Core.scala 111:39]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 111:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_is_trap <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      if (id_reg_stall) begin // @[Core.scala 697:24]
        ex1_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 724:29]
      end else begin
        ex1_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 754:29]
      end
    end
    if (reset) begin // @[Core.scala 112:39]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 112:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 641:41]
      ex1_reg_mcause <= _GEN_68;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 695:40]
      ex1_reg_mcause <= _GEN_68;
    end
    if (reset) begin // @[Core.scala 116:38]
      ex2_reg_pc <= 32'h0; // @[Core.scala 116:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 849:27]
    end
    if (reset) begin // @[Core.scala 117:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 117:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 853:27]
    end
    if (reset) begin // @[Core.scala 118:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 118:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (_ex1_op1_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= 32'h0;
      end else if (_ex1_op1_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= ex1_fw_data;
      end else begin
        ex2_reg_op1_data <= _ex1_op1_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 119:38]
      ex2_reg_op2_data <= 32'h0; // @[Core.scala 119:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (_ex1_op2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= 32'h0;
      end else if (_ex1_op2_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= ex1_fw_data;
      end else begin
        ex2_reg_op2_data <= _ex1_op2_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 120:38]
      ex2_reg_rs2_data <= 32'h0; // @[Core.scala 120:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (_ex1_op2_data_T_1) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= 32'h0;
      end else if (_ex1_rs2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= ex1_fw_data;
      end else begin
        ex2_reg_rs2_data <= _ex1_rs2_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 121:38]
      ex2_reg_exe_fun <= 5'h0; // @[Core.scala 121:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 855:33]
        ex2_reg_exe_fun <= 5'h1;
      end else begin
        ex2_reg_exe_fun <= ex1_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 122:38]
      ex2_reg_mem_wen <= 2'h0; // @[Core.scala 122:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 860:33]
        ex2_reg_mem_wen <= 2'h0;
      end else begin
        ex2_reg_mem_wen <= ex1_reg_mem_wen;
      end
    end
    if (reset) begin // @[Core.scala 123:38]
      ex2_reg_rf_wen <= 2'h0; // @[Core.scala 123:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 854:33]
        ex2_reg_rf_wen <= 2'h0;
      end else begin
        ex2_reg_rf_wen <= ex1_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 124:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 124:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 856:33]
        ex2_reg_wb_sel <= 3'h0;
      end else begin
        ex2_reg_wb_sel <= ex1_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 125:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 125:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 858:27]
    end
    if (reset) begin // @[Core.scala 126:38]
      ex2_reg_csr_cmd <= 3'h0; // @[Core.scala 126:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 859:33]
        ex2_reg_csr_cmd <= 3'h0;
      end else begin
        ex2_reg_csr_cmd <= ex1_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 127:38]
      ex2_reg_imm_b_sext <= 32'h0; // @[Core.scala 127:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_imm_b_sext <= ex1_reg_imm_b_sext; // @[Core.scala 857:27]
    end
    if (reset) begin // @[Core.scala 128:38]
      ex2_reg_mem_w <= 32'h0; // @[Core.scala 128:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 861:27]
    end
    if (reset) begin // @[Core.scala 129:38]
      ex2_reg_is_j <= 1'h0; // @[Core.scala 129:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_is_j <= ex1_reg_is_j; // @[Core.scala 862:27]
    end
    if (reset) begin // @[Core.scala 130:38]
      ex2_reg_is_bp_pos <= 1'h0; // @[Core.scala 130:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_is_bp_pos <= ex1_reg_is_bp_pos; // @[Core.scala 863:27]
    end
    if (reset) begin // @[Core.scala 131:38]
      ex2_reg_bp_addr <= 32'h0; // @[Core.scala 131:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_bp_addr <= ex1_reg_bp_addr; // @[Core.scala 864:27]
    end
    if (reset) begin // @[Core.scala 132:38]
      ex2_reg_is_half <= 1'h0; // @[Core.scala 132:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_is_half <= ex1_reg_is_half; // @[Core.scala 865:27]
    end
    if (reset) begin // @[Core.scala 133:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 133:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_is_valid_inst <= ex1_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 866:27]
    end
    if (reset) begin // @[Core.scala 134:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 134:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      if (ex_is_bubble) begin // @[Core.scala 867:33]
        ex2_reg_is_trap <= 1'h0;
      end else begin
        ex2_reg_is_trap <= ex1_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 135:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 135:38]
    end else if (_T_9) begin // @[Core.scala 847:20]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 868:27]
    end
    if (reset) begin // @[Core.scala 139:41]
      ex3_reg_bp_en <= 1'h0; // @[Core.scala 139:41]
    end else begin
      ex3_reg_bp_en <= _mem_en_T & _mem_en_T_2; // @[Core.scala 926:28]
    end
    if (reset) begin // @[Core.scala 140:41]
      ex3_reg_pc <= 32'h0; // @[Core.scala 140:41]
    end else begin
      ex3_reg_pc <= ex2_reg_pc; // @[Core.scala 927:28]
    end
    if (reset) begin // @[Core.scala 141:41]
      ex3_reg_is_cond_br <= 1'h0; // @[Core.scala 141:41]
    end else if (_ex2_is_cond_br_T) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_1;
    end else if (_ex2_is_cond_br_T_2) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_4;
    end else if (_ex2_is_cond_br_T_5) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_alu_out_T_27;
    end else begin
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_21;
    end
    if (reset) begin // @[Core.scala 142:41]
      ex3_reg_is_cond_br_inst <= 1'h0; // @[Core.scala 142:41]
    end else begin
      ex3_reg_is_cond_br_inst <= ex2_is_cond_br_inst; // @[Core.scala 930:28]
    end
    if (reset) begin // @[Core.scala 143:41]
      ex3_reg_is_uncond_br <= 1'h0; // @[Core.scala 143:41]
    end else begin
      ex3_reg_is_uncond_br <= _ex2_alu_out_T_30; // @[Core.scala 931:28]
    end
    if (reset) begin // @[Core.scala 144:41]
      ex3_reg_cond_br_target <= 32'h0; // @[Core.scala 144:41]
    end else begin
      ex3_reg_cond_br_target <= ex2_cond_br_target; // @[Core.scala 932:28]
    end
    if (reset) begin // @[Core.scala 145:41]
      ex3_reg_uncond_br_target <= 32'h0; // @[Core.scala 145:41]
    end else if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_2;
    end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_5;
    end else if (_ex2_alu_out_T_6) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_7;
    end else begin
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_44;
    end
    if (reset) begin // @[Core.scala 146:41]
      ex3_reg_is_j <= 1'h0; // @[Core.scala 146:41]
    end else begin
      ex3_reg_is_j <= ex2_reg_is_j; // @[Core.scala 934:28]
    end
    if (reset) begin // @[Core.scala 147:41]
      ex3_reg_is_bp_pos <= 1'h0; // @[Core.scala 147:41]
    end else begin
      ex3_reg_is_bp_pos <= ex2_reg_is_bp_pos; // @[Core.scala 935:28]
    end
    if (reset) begin // @[Core.scala 148:41]
      ex3_reg_bp_addr <= 32'h0; // @[Core.scala 148:41]
    end else begin
      ex3_reg_bp_addr <= ex2_reg_bp_addr; // @[Core.scala 936:28]
    end
    if (reset) begin // @[Core.scala 149:41]
      ex3_reg_is_half <= 1'h0; // @[Core.scala 149:41]
    end else begin
      ex3_reg_is_half <= ex2_reg_is_half; // @[Core.scala 937:28]
    end
    if (reset) begin // @[Core.scala 152:38]
      mem_reg_en <= 1'h0; // @[Core.scala 152:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_en <= _ex3_reg_bp_en_T_2; // @[Core.scala 984:24]
    end
    if (reset) begin // @[Core.scala 153:38]
      mem_reg_pc <= 32'h0; // @[Core.scala 153:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_pc <= ex2_reg_pc; // @[Core.scala 985:24]
    end
    if (reset) begin // @[Core.scala 154:38]
      mem_reg_wb_addr <= 5'h0; // @[Core.scala 154:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_wb_addr <= ex2_reg_wb_addr; // @[Core.scala 988:24]
    end
    if (reset) begin // @[Core.scala 155:38]
      mem_reg_op1_data <= 32'h0; // @[Core.scala 155:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_op1_data <= ex2_reg_op1_data; // @[Core.scala 986:24]
    end
    if (reset) begin // @[Core.scala 156:38]
      mem_reg_rs2_data <= 32'h0; // @[Core.scala 156:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_rs2_data <= ex2_reg_rs2_data; // @[Core.scala 987:24]
    end
    if (reset) begin // @[Core.scala 157:38]
      mem_reg_mem_wen <= 2'h0; // @[Core.scala 157:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_mem_wen <= ex2_reg_mem_wen; // @[Core.scala 995:24]
    end
    if (reset) begin // @[Core.scala 158:38]
      mem_reg_rf_wen <= 2'h0; // @[Core.scala 158:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_rf_wen <= ex2_reg_rf_wen; // @[Core.scala 990:24]
    end
    if (reset) begin // @[Core.scala 159:38]
      mem_reg_wb_sel <= 3'h0; // @[Core.scala 159:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_wb_sel <= ex2_reg_wb_sel; // @[Core.scala 991:24]
    end
    if (reset) begin // @[Core.scala 160:38]
      mem_reg_csr_addr <= 12'h0; // @[Core.scala 160:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_csr_addr <= ex2_reg_csr_addr; // @[Core.scala 992:24]
    end
    if (reset) begin // @[Core.scala 161:38]
      mem_reg_csr_cmd <= 3'h0; // @[Core.scala 161:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_csr_cmd <= ex2_reg_csr_cmd; // @[Core.scala 993:24]
    end
    if (reset) begin // @[Core.scala 163:38]
      mem_reg_alu_out <= 32'h0; // @[Core.scala 163:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_2;
      end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_5;
      end else begin
        mem_reg_alu_out <= _ex2_alu_out_T_45;
      end
    end
    if (reset) begin // @[Core.scala 164:38]
      mem_reg_mem_w <= 32'h0; // @[Core.scala 164:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_mem_w <= ex2_reg_mem_w; // @[Core.scala 996:24]
    end
    if (reset) begin // @[Core.scala 165:38]
      mem_reg_mem_wstrb <= 4'h0; // @[Core.scala 165:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_mem_wstrb <= _mem_reg_mem_wstrb_T_7[3:0]; // @[Core.scala 997:24]
    end
    if (reset) begin // @[Core.scala 166:38]
      mem_reg_is_half <= 1'h0; // @[Core.scala 166:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_is_half <= ex2_reg_is_half; // @[Core.scala 1002:24]
    end
    if (reset) begin // @[Core.scala 167:38]
      mem_reg_is_valid_inst <= 1'h0; // @[Core.scala 167:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_is_valid_inst <= ex2_reg_is_valid_inst; // @[Core.scala 1003:27]
    end
    if (reset) begin // @[Core.scala 168:38]
      mem_reg_is_trap <= 1'h0; // @[Core.scala 168:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_is_trap <= ex2_reg_is_trap; // @[Core.scala 1004:24]
    end
    if (reset) begin // @[Core.scala 169:38]
      mem_reg_mcause <= 32'h0; // @[Core.scala 169:38]
    end else if (_T_9) begin // @[Core.scala 983:22]
      mem_reg_mcause <= ex2_reg_mcause; // @[Core.scala 1005:24]
    end
    if (reset) begin // @[Core.scala 173:38]
      wb_reg_wb_addr <= 5'h0; // @[Core.scala 173:38]
    end else begin
      wb_reg_wb_addr <= mem_reg_wb_addr; // @[Core.scala 1137:18]
    end
    if (reset) begin // @[Core.scala 174:38]
      wb_reg_rf_wen <= 2'h0; // @[Core.scala 174:38]
    end else if (_T_9) begin // @[Core.scala 1138:24]
      if (mem_en) begin // @[Core.scala 1016:23]
        wb_reg_rf_wen <= mem_reg_rf_wen;
      end else begin
        wb_reg_rf_wen <= 2'h0;
      end
    end else begin
      wb_reg_rf_wen <= 2'h0;
    end
    if (reset) begin // @[Core.scala 175:38]
      wb_reg_wb_data <= 32'h0; // @[Core.scala 175:38]
    end else if (_mem_stall_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_11;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1127:35]
        wb_reg_wb_data <= _mem_wb_data_T_3;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= csr_rdata;
    end else begin
      wb_reg_wb_data <= mem_reg_alu_out;
    end
    if (reset) begin // @[Core.scala 176:38]
      wb_reg_is_valid_inst <= 1'h0; // @[Core.scala 176:38]
    end else begin
      wb_reg_is_valid_inst <= mem_reg_is_valid_inst & _T_9 & _mem_en_T_4 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1140:24]
    end
    if (reset) begin // @[Core.scala 178:35]
      if2_reg_is_bp_pos <= 1'h0; // @[Core.scala 178:35]
    end else if (!(id_reg_stall)) begin // @[Core.scala 321:26]
      if2_reg_is_bp_pos <= _if2_is_bp_pos_T_6;
    end
    if (reset) begin // @[Core.scala 179:35]
      if2_reg_bp_addr <= 32'h0; // @[Core.scala 179:35]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= bp_io_lu_br_addr;
      end else if (_if2_bp_addr_T_2) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= if2_cond_br_addr;
      end else begin
        if2_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 182:39]
      if2_reg_is_uncond_br <= 1'h0; // @[Core.scala 182:39]
    end else if (!(id_reg_stall)) begin // @[Core.scala 310:26]
      if2_reg_is_uncond_br <= if2_is_jal;
    end
    if (reset) begin // @[Core.scala 183:39]
      if2_reg_uncond_br_addr <= 32'h0; // @[Core.scala 183:39]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (if2_is_jal) begin // @[Mux.scala 101:16]
        if2_reg_uncond_br_addr <= if2_jal_addr;
      end else begin
        if2_reg_uncond_br_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 187:35]
      ex3_reg_is_br <= 1'h0; // @[Core.scala 187:35]
    end else begin
      ex3_reg_is_br <= ex3_cond_bp_fail | ex3_cond_nbp_fail | ex3_uncond_bp_fail; // @[Core.scala 957:17]
    end
    if (reset) begin // @[Core.scala 188:35]
      ex3_reg_br_target <= 32'h0; // @[Core.scala 188:35]
    end else if (ex3_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_cond_br_target;
    end else if (ex3_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (ex3_reg_is_half) begin // @[Core.scala 954:30]
        ex3_reg_br_target <= _ex3_reg_br_target_T_1;
      end else begin
        ex3_reg_br_target <= _ex3_reg_br_target_T_3;
      end
    end else if (ex3_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_br_target <= 32'h0;
    end
    if (reset) begin // @[Core.scala 189:42]
      ex3_reg_is_br_before_trap <= 1'h0; // @[Core.scala 189:42]
    end else begin
      ex3_reg_is_br_before_trap <= ex3_cond_bp_success | ex3_uncond_bp_success | ex3_j_success; // @[Core.scala 974:29]
    end
    if (reset) begin // @[Core.scala 190:35]
      ex3_reg_trap_pc <= 32'h0; // @[Core.scala 190:35]
    end else if (ex3_cond_bp_success) begin // @[Mux.scala 101:16]
      ex3_reg_trap_pc <= ex3_reg_cond_br_target;
    end else if (ex3_uncond_bp_success) begin // @[Mux.scala 101:16]
      ex3_reg_trap_pc <= ex3_reg_uncond_br_target;
    end else if (ex3_j_success) begin // @[Mux.scala 101:16]
      ex3_reg_trap_pc <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_trap_pc <= 32'h0;
    end
    if (reset) begin // @[Core.scala 191:35]
      mem_reg_is_br <= 1'h0; // @[Core.scala 191:35]
    end else begin
      mem_reg_is_br <= _GEN_212;
    end
    if (reset) begin // @[Core.scala 192:35]
      mem_reg_br_addr <= 32'h0; // @[Core.scala 192:35]
    end else if (mem_is_meintr) begin // @[Core.scala 1071:24]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1080:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1081:30]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1090:21]
    end else if (mem_is_trap) begin // @[Core.scala 1091:28]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1100:21]
    end else begin
      mem_reg_br_addr <= _GEN_195;
    end
    if (reset) begin // @[Core.scala 201:32]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 201:32]
    end else begin
      ic_reg_read_rdy <= ~ic_fill_half; // @[Core.scala 221:19]
    end
    if (reset) begin // @[Core.scala 202:32]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 202:32]
    end else begin
      ic_reg_half_rdy <= 1'h1; // @[Core.scala 220:19]
    end
    if (reset) begin // @[Core.scala 204:32]
      ic_reg_addr_out <= 32'h0; // @[Core.scala 204:32]
    end else if (if1_is_jump) begin // @[Mux.scala 101:16]
      if (mem_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= mem_reg_br_addr;
      end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= ex3_reg_br_target;
      end else begin
        ic_reg_addr_out <= _if1_jump_addr_T_2;
      end
    end else if (_ic_next_addr_T_1) begin // @[Mux.scala 101:16]
      ic_reg_addr_out <= _ic_next_addr_T_3;
    end else if (_ic_next_addr_T_4) begin // @[Mux.scala 101:16]
      ic_reg_addr_out <= _ic_next_addr_T_6;
    end
    if (reset) begin // @[Core.scala 208:33]
      ic_reg_half <= 16'h0; // @[Core.scala 208:33]
    end else if (_ic_reg_half_T_2) begin // @[Mux.scala 101:16]
      ic_reg_half <= io_imem_inst[31:16];
    end
    if1_reg_first <= reset; // @[Core.scala 242:{30,30} 243:17]
    if (reset) begin // @[Core.scala 262:32]
      if1_reg_next_pc <= 32'h0; // @[Core.scala 262:32]
    end else if (id_reg_stall) begin // @[Core.scala 265:25]
      if (if1_is_jump) begin // @[Core.scala 263:24]
        if (mem_reg_is_br) begin // @[Mux.scala 101:16]
          if1_reg_next_pc <= mem_reg_br_addr;
        end else begin
          if1_reg_next_pc <= _if1_jump_addr_T_3;
        end
      end
    end else begin
      if1_reg_next_pc <= if1_next_pc_4;
    end
    if (reset) begin // @[Core.scala 274:29]
      if2_reg_pc <= 32'h8000000; // @[Core.scala 274:29]
    end else if (!(id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst))) begin // @[Core.scala 280:19]
      if2_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 275:29]
      if2_reg_inst <= 32'h0; // @[Core.scala 275:29]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if2_reg_inst <= _if2_inst_T_4;
    end
    if (reset) begin // @[Core.scala 763:38]
      ex1_reg_hazard <= 1'h0; // @[Core.scala 763:38]
    end else if (_T_9) begin // @[Core.scala 839:20]
      ex1_reg_hazard <= ex1_hazard & (ex1_reg_wb_sel == 3'h1 | ex1_reg_wb_sel == 3'h3); // @[Core.scala 842:20]
    end
    if (reset) begin // @[Core.scala 766:38]
      ex2_reg_hazard <= 1'h0; // @[Core.scala 766:38]
    end else if (_T_9) begin // @[Core.scala 918:20]
      ex2_reg_hazard <= ex2_hazard & (ex2_reg_wb_sel == 3'h1 | ex2_reg_wb_sel == 3'h3); // @[Core.scala 921:20]
    end
    if (reset) begin // @[Core.scala 1020:32]
      mem_stall_delay <= 1'h0; // @[Core.scala 1020:32]
    end else begin
      mem_stall_delay <= _mem_stall_T & io_dmem_rvalid & _T_9; // @[Core.scala 1029:19]
    end
    if (reset) begin // @[Core.scala 563:40]
      id_reg_pc_delay <= 32'h0; // @[Core.scala 563:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_pc_delay <= _GEN_0;
    end else begin
      id_reg_pc_delay <= _GEN_0;
    end
    if (reset) begin // @[Core.scala 564:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 564:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_wb_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_wb_addr_delay <= _id_wb_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 565:40]
      id_reg_op1_sel_delay <= 3'h0; // @[Core.scala 565:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_op1_sel_delay <= 3'h0;
        end else begin
          id_reg_op1_sel_delay <= _id_m_op1_sel_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 566:40]
      id_reg_op2_sel_delay <= 4'h0; // @[Core.scala 566:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_op2_sel_delay <= 4'h1;
        end else begin
          id_reg_op2_sel_delay <= _id_m_op2_sel_T_2;
        end
      end
    end
    if (reset) begin // @[Core.scala 567:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 567:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
          id_reg_rs1_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 568:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 568:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
          id_reg_rs2_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 569:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 569:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= id_rs1_data;
        end else begin
          id_reg_op1_data_delay <= _id_op1_data_T_10;
        end
      end
    end
    if (reset) begin // @[Core.scala 570:40]
      id_reg_op2_data_delay <= 32'h0; // @[Core.scala 570:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_op2_data_T) begin // @[Mux.scala 101:16]
          id_reg_op2_data_delay <= id_rs2_data;
        end else begin
          id_reg_op2_data_delay <= _id_op2_data_T_28;
        end
      end
    end
    if (reset) begin // @[Core.scala 572:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 572:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_exe_fun_delay <= 5'h1; // @[Core.scala 598:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h1;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_211;
      end
    end
    if (reset) begin // @[Core.scala 573:40]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 573:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 601:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else begin
        id_reg_mem_wen_delay <= _csignals_T_421;
      end
    end
    if (reset) begin // @[Core.scala 574:40]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 574:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 597:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_rf_wen_delay <= 2'h1;
      end else begin
        id_reg_rf_wen_delay <= _csignals_T_491;
      end
    end
    if (reset) begin // @[Core.scala 575:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 575:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 599:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h1;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_561;
      end
    end
    if (reset) begin // @[Core.scala 576:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 576:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (csignals_7 == 3'h4) begin // @[Core.scala 528:24]
          id_reg_csr_addr_delay <= 12'h342;
        end else begin
          id_reg_csr_addr_delay <= id_imm_i;
        end
      end
    end
    if (reset) begin // @[Core.scala 577:40]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 577:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 600:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_701;
      end
    end
    if (reset) begin // @[Core.scala 580:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 580:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_imm_b_sext_delay <= id_c_imm_b;
        end else begin
          id_reg_imm_b_sext_delay <= id_imm_b_sext;
        end
      end
    end
    if (reset) begin // @[Core.scala 583:40]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 583:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 602:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      id_reg_mem_w_delay <= {{29'd0}, csignals_8}; // @[Core.scala 628:29]
    end
    if (reset) begin // @[Core.scala 584:40]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 584:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 603:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      id_reg_is_j_delay <= id_is_j; // @[Core.scala 629:29]
    end
    if (reset) begin // @[Core.scala 585:40]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 585:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 604:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      id_reg_is_bp_pos_delay <= id_reg_is_bp_pos; // @[Core.scala 630:29]
    end
    if (reset) begin // @[Core.scala 586:40]
      id_reg_bp_addr_delay <= 32'h0; // @[Core.scala 586:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        id_reg_bp_addr_delay <= id_reg_bp_addr; // @[Core.scala 631:29]
      end
    end
    if (reset) begin // @[Core.scala 587:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 587:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        id_reg_is_half_delay <= id_is_half; // @[Core.scala 632:29]
      end
    end
    if (reset) begin // @[Core.scala 588:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 588:43]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 605:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 633:32]
    end
    if (reset) begin // @[Core.scala 589:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 589:40]
    end else if (_if1_is_jump_T) begin // @[Core.scala 593:41]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 606:32]
    end else if (_ic_read_en2_T) begin // @[Core.scala 607:30]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 634:29]
    end
    if (reset) begin // @[Core.scala 590:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 590:40]
    end else if (!(_if1_is_jump_T)) begin // @[Core.scala 593:41]
      if (_ic_read_en2_T) begin // @[Core.scala 607:30]
        id_reg_mcause_delay <= 32'hb; // @[Core.scala 635:29]
      end
    end
    if (reset) begin // @[Core.scala 762:38]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 762:38]
    end else if (_T_9) begin // @[Core.scala 839:20]
      ex1_reg_fw_en <= _T_8 & ex1_hazard & ex1_reg_wb_sel != 3'h1 & ex1_reg_wb_sel != 3'h3; // @[Core.scala 841:19]
    end
    if (reset) begin // @[Core.scala 765:38]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 765:38]
    end else if (_T_9) begin // @[Core.scala 918:20]
      ex2_reg_fw_en <= ex2_hazard & ex2_reg_wb_sel != 3'h1 & ex2_reg_wb_sel != 3'h3; // @[Core.scala 920:19]
    end
    if (reset) begin // @[Core.scala 767:38]
      ex2_reg_fw_data <= 32'h0; // @[Core.scala 767:38]
    end else if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
      if (ex2_reg_is_half) begin // @[Core.scala 912:38]
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
    if (reset) begin // @[Core.scala 768:38]
      mem_reg_rf_wen_delay <= 2'h0; // @[Core.scala 768:38]
    end else if (mem_en) begin // @[Core.scala 1016:23]
      mem_reg_rf_wen_delay <= mem_reg_rf_wen;
    end else begin
      mem_reg_rf_wen_delay <= 2'h0;
    end
    if (reset) begin // @[Core.scala 770:38]
      mem_reg_wb_data_delay <= 32'h0; // @[Core.scala 770:38]
    end else if (_mem_stall_T) begin // @[Core.scala 1133:31]
      mem_reg_wb_data_delay <= mem_wb_data_load;
    end else if (_mem_stall_T) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= mem_wb_data_load;
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= _mem_wb_data_T_6;
    end else begin
      mem_reg_wb_data_delay <= _mem_wb_data_T_8;
    end
    if (reset) begin // @[Core.scala 771:38]
      wb_reg_rf_wen_delay <= 2'h0; // @[Core.scala 771:38]
    end else begin
      wb_reg_rf_wen_delay <= wb_reg_rf_wen; // @[Core.scala 1150:24]
    end
    if (reset) begin // @[Core.scala 772:38]
      wb_reg_wb_addr_delay <= 5'h0; // @[Core.scala 772:38]
    end else begin
      wb_reg_wb_addr_delay <= wb_reg_wb_addr; // @[Core.scala 1151:24]
    end
    if (reset) begin // @[Core.scala 773:38]
      wb_reg_wb_data_delay <= 32'h0; // @[Core.scala 773:38]
    end else begin
      wb_reg_wb_data_delay <= wb_reg_wb_data; // @[Core.scala 1152:24]
    end
    if (reset) begin // @[Core.scala 1170:24]
      do_exit <= 1'h0; // @[Core.scala 1170:24]
    end else begin
      do_exit <= mem_reg_is_trap & mem_reg_mcause == 32'hb & regfile_do_exit_MPORT_data == 32'h5d; // @[Core.scala 1172:11]
    end
    if (reset) begin // @[Core.scala 1171:30]
      do_exit_delay <= 1'h0; // @[Core.scala 1171:30]
    end else begin
      do_exit_delay <= do_exit; // @[Core.scala 1173:17]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",ic_reg_addr_out,ic_data_out); // @[Core.scala 335:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"inst: %x, ic_reg_read_rdy: %d, ic_reg_half_rdy: %d\n",if2_inst,ic_reg_read_rdy,
            ic_reg_half_rdy); // @[Core.scala 336:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"if2_reg_pc       : 0x%x\n",if2_reg_pc); // @[Core.scala 1176:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 1177:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"bp.io.lu.br_hit  : 0x%x\n",bp_io_lu_br_hit); // @[Core.scala 1178:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"bp.io.lu.br_pos  : 0x%x\n",bp_io_lu_br_pos); // @[Core.scala 1179:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",id_reg_pc); // @[Core.scala 1180:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 1181:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 1182:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 1183:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_rs1_data      : 0x%x\n",id_rs1_data); // @[Core.scala 1184:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_rs2_data      : 0x%x\n",id_rs2_data); // @[Core.scala 1185:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"id_wb_addr       : 0x%x\n",id_wb_addr); // @[Core.scala 1186:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",ex1_reg_pc); // @[Core.scala 1187:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex1_stall        : 0x%x\n",ex1_stall); // @[Core.scala 1188:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex1_op1_data     : 0x%x\n",ex1_op1_data); // @[Core.scala 1189:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex1_op2_data     : 0x%x\n",ex1_op2_data); // @[Core.scala 1190:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",ex2_reg_pc); // @[Core.scala 1193:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_op1_data : 0x%x\n",ex2_reg_op1_data); // @[Core.scala 1194:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_op2_data : 0x%x\n",ex2_reg_op2_data); // @[Core.scala 1195:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_alu_out      : 0x%x\n",ex2_alu_out); // @[Core.scala 1196:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_exe_fun  : 0x%x\n",ex2_reg_exe_fun); // @[Core.scala 1197:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_wb_sel   : 0x%x\n",ex2_reg_wb_sel); // @[Core.scala 1198:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_is_bp_pos : 0x%x\n",ex2_reg_is_bp_pos); // @[Core.scala 1199:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex2_reg_bp_addr  : 0x%x\n",ex2_reg_bp_addr); // @[Core.scala 1200:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex3_reg_pc       : 0x%x\n",ex3_reg_pc); // @[Core.scala 1201:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex3_reg_is_br    : 0x%x\n",ex3_reg_is_br); // @[Core.scala 1202:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"ex3_reg_br_target : 0x%x\n",ex3_reg_br_target); // @[Core.scala 1203:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_reg_pc       : 0x%x\n",mem_reg_pc); // @[Core.scala 1204:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_stall        : 0x%x\n",mem_stall); // @[Core.scala 1205:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_wb_data      : 0x%x\n",mem_wb_data); // @[Core.scala 1206:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_reg_mem_w    : 0x%x\n",mem_reg_mem_w); // @[Core.scala 1207:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_reg_wb_addr  : 0x%x\n",mem_reg_wb_addr); // @[Core.scala 1208:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_is_meintr    : %d\n",mem_is_meintr); // @[Core.scala 1209:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_is_mtintr    : %d\n",mem_is_mtintr); // @[Core.scala 1210:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_reg_rf_wen_delay : 0x%x\n",mem_reg_rf_wen_delay); // @[Core.scala 1211:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_wb_addr_delay : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1212:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"mem_reg_wb_data_delay : 0x%x\n",mem_reg_wb_data_delay); // @[Core.scala 1213:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"wb_reg_wb_addr   : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1214:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"wb_reg_wb_data   : 0x%x\n",wb_reg_wb_data); // @[Core.scala 1215:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 1216:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"cycle_counter(%d) : %d\n",do_exit,io_debug_signal_cycle_counter); // @[Core.scala 1217:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 1218:9]
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
  ex3_reg_is_j = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  ex3_reg_is_bp_pos = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  ex3_reg_bp_addr = _RAND_66[31:0];
  _RAND_67 = {1{`RANDOM}};
  ex3_reg_is_half = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  mem_reg_en = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  mem_reg_pc = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  mem_reg_wb_addr = _RAND_70[4:0];
  _RAND_71 = {1{`RANDOM}};
  mem_reg_op1_data = _RAND_71[31:0];
  _RAND_72 = {1{`RANDOM}};
  mem_reg_rs2_data = _RAND_72[31:0];
  _RAND_73 = {1{`RANDOM}};
  mem_reg_mem_wen = _RAND_73[1:0];
  _RAND_74 = {1{`RANDOM}};
  mem_reg_rf_wen = _RAND_74[1:0];
  _RAND_75 = {1{`RANDOM}};
  mem_reg_wb_sel = _RAND_75[2:0];
  _RAND_76 = {1{`RANDOM}};
  mem_reg_csr_addr = _RAND_76[11:0];
  _RAND_77 = {1{`RANDOM}};
  mem_reg_csr_cmd = _RAND_77[2:0];
  _RAND_78 = {1{`RANDOM}};
  mem_reg_alu_out = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  mem_reg_mem_w = _RAND_79[31:0];
  _RAND_80 = {1{`RANDOM}};
  mem_reg_mem_wstrb = _RAND_80[3:0];
  _RAND_81 = {1{`RANDOM}};
  mem_reg_is_half = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  mem_reg_is_valid_inst = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  mem_reg_is_trap = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  mem_reg_mcause = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  wb_reg_wb_addr = _RAND_85[4:0];
  _RAND_86 = {1{`RANDOM}};
  wb_reg_rf_wen = _RAND_86[1:0];
  _RAND_87 = {1{`RANDOM}};
  wb_reg_wb_data = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  wb_reg_is_valid_inst = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  if2_reg_is_bp_pos = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  if2_reg_bp_addr = _RAND_90[31:0];
  _RAND_91 = {1{`RANDOM}};
  if2_reg_is_uncond_br = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  if2_reg_uncond_br_addr = _RAND_92[31:0];
  _RAND_93 = {1{`RANDOM}};
  ex3_reg_is_br = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  ex3_reg_br_target = _RAND_94[31:0];
  _RAND_95 = {1{`RANDOM}};
  ex3_reg_is_br_before_trap = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  ex3_reg_trap_pc = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  mem_reg_is_br = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  mem_reg_br_addr = _RAND_98[31:0];
  _RAND_99 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_101[31:0];
  _RAND_102 = {1{`RANDOM}};
  ic_reg_half = _RAND_102[15:0];
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
  input  [31:0]  io_imem_addr,
  output [31:0]  io_imem_inst,
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
  output [8:0]   io_imemReadPort_address,
  input  [31:0]  io_imemReadPort_data,
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
  input  [255:0] io_cache_array2_rdata
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [255:0] _RAND_8;
  reg [255:0] _RAND_9;
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
  reg [19:0] tag_array_0 [0:127]; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_en; // @[Memory.scala 92:22]
  wire [6:0] tag_array_0_MPORT_addr; // @[Memory.scala 92:22]
  wire [19:0] tag_array_0_MPORT_data; // @[Memory.scala 92:22]
  wire [19:0] tag_array_0_MPORT_3_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_0_MPORT_3_addr; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_3_mask; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_3_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_0_MPORT_5_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_0_MPORT_5_addr; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_5_mask; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_5_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_0_MPORT_7_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_0_MPORT_7_addr; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_7_mask; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_7_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_0_MPORT_9_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_0_MPORT_9_addr; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_9_mask; // @[Memory.scala 92:22]
  wire  tag_array_0_MPORT_9_en; // @[Memory.scala 92:22]
  reg [19:0] tag_array_1 [0:127]; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_en; // @[Memory.scala 92:22]
  wire [6:0] tag_array_1_MPORT_addr; // @[Memory.scala 92:22]
  wire [19:0] tag_array_1_MPORT_data; // @[Memory.scala 92:22]
  wire [19:0] tag_array_1_MPORT_3_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_1_MPORT_3_addr; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_3_mask; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_3_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_1_MPORT_5_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_1_MPORT_5_addr; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_5_mask; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_5_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_1_MPORT_7_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_1_MPORT_7_addr; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_7_mask; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_7_en; // @[Memory.scala 92:22]
  wire [19:0] tag_array_1_MPORT_9_data; // @[Memory.scala 92:22]
  wire [6:0] tag_array_1_MPORT_9_addr; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_9_mask; // @[Memory.scala 92:22]
  wire  tag_array_1_MPORT_9_en; // @[Memory.scala 92:22]
  reg  lru_array_way_hot [0:127]; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_reg_lru_MPORT_en; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_1_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_1_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_1_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_1_en; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_2_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_2_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_2_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_2_en; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_4_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_4_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_4_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_4_en; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_6_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_6_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_6_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_6_en; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_8_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_8_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_8_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_8_en; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_10_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_way_hot_MPORT_10_addr; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_10_mask; // @[Memory.scala 95:22]
  wire  lru_array_way_hot_MPORT_10_en; // @[Memory.scala 95:22]
  reg  lru_array_dirty1 [0:127]; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_reg_lru_MPORT_en; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_1_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_1_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_1_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_1_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_2_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_2_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_2_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_2_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_4_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_4_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_4_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_4_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_6_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_6_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_6_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_6_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_8_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_8_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_8_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_8_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_10_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty1_MPORT_10_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_10_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty1_MPORT_10_en; // @[Memory.scala 95:22]
  reg  lru_array_dirty2 [0:127]; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_reg_lru_MPORT_en; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_1_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_1_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_1_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_1_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_2_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_2_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_2_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_2_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_4_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_4_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_4_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_4_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_6_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_6_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_6_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_6_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_8_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_8_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_8_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_8_en; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_10_data; // @[Memory.scala 95:22]
  wire [6:0] lru_array_dirty2_MPORT_10_addr; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_10_mask; // @[Memory.scala 95:22]
  wire  lru_array_dirty2_MPORT_10_en; // @[Memory.scala 95:22]
  reg [3:0] dcache_state; // @[Memory.scala 97:29]
  reg [19:0] reg_tag_0; // @[Memory.scala 98:24]
  reg [19:0] reg_tag_1; // @[Memory.scala 98:24]
  reg [255:0] reg_line1; // @[Memory.scala 99:26]
  reg [255:0] reg_line2; // @[Memory.scala 100:26]
  reg  reg_lru_way_hot; // @[Memory.scala 101:24]
  reg  reg_lru_dirty1; // @[Memory.scala 101:24]
  reg  reg_lru_dirty2; // @[Memory.scala 101:24]
  reg [19:0] reg_req_addr_tag; // @[Memory.scala 102:29]
  reg [6:0] reg_req_addr_index; // @[Memory.scala 102:29]
  reg [4:0] reg_req_addr_line_off; // @[Memory.scala 102:29]
  reg [31:0] reg_wdata; // @[Memory.scala 103:26]
  reg [3:0] reg_wstrb; // @[Memory.scala 104:26]
  reg  reg_ren; // @[Memory.scala 105:24]
  reg  reg_dcache_read; // @[Memory.scala 106:32]
  wire  _T_2 = 4'h0 == dcache_state; // @[Memory.scala 141:25]
  wire [31:0] _req_addr_T = io_dmem_ren ? io_dmem_raddr : io_dmem_waddr; // @[Memory.scala 145:25]
  wire [4:0] req_addr_line_off = _req_addr_T[4:0]; // @[Memory.scala 145:77]
  wire [6:0] req_addr_index = _req_addr_T[11:5]; // @[Memory.scala 145:77]
  wire [19:0] req_addr_tag = _req_addr_T[31:12]; // @[Memory.scala 145:77]
  wire  _T_3 = io_dmem_ren | io_dmem_wen; // @[Memory.scala 150:25]
  wire [1:0] _GEN_0 = io_dmem_ren ? 2'h1 : 2'h2; // @[Memory.scala 162:28 163:24 165:24]
  wire [255:0] _GEN_11 = reg_dcache_read ? io_cache_array1_rdata : reg_line1; // @[Memory.scala 170:30 171:19 99:26]
  wire [255:0] _GEN_12 = reg_dcache_read ? io_cache_array2_rdata : reg_line2; // @[Memory.scala 170:30 172:19 100:26]
  wire  _T_7 = reg_tag_0 == reg_req_addr_tag; // @[Memory.scala 176:24]
  wire [7:0] _io_dmem_rdata_T_1 = {reg_req_addr_line_off[4:2],5'h0}; // @[Cat.scala 31:58]
  wire [255:0] _io_dmem_rdata_T_2 = _GEN_11 >> _io_dmem_rdata_T_1; // @[Memory.scala 180:33]
  wire  _T_8 = reg_tag_1 == reg_req_addr_tag; // @[Memory.scala 182:30]
  wire [255:0] _io_dmem_rdata_T_6 = _GEN_12 >> _io_dmem_rdata_T_1; // @[Memory.scala 186:33]
  wire  _T_11 = ~reg_lru_way_hot; // @[Memory.scala 188:83]
  wire  _T_15 = io_dramPort_init_calib_complete & ~io_dramPort_busy; // @[Memory.scala 189:47]
  wire [26:0] _io_dramPort_addr_T_1 = {reg_tag_0[15:0],reg_req_addr_index,4'h0}; // @[Cat.scala 31:58]
  wire [26:0] _io_dramPort_addr_T_3 = {reg_tag_1[15:0],reg_req_addr_index,4'h0}; // @[Cat.scala 31:58]
  wire [26:0] _GEN_13 = reg_lru_way_hot ? _io_dramPort_addr_T_1 : _io_dramPort_addr_T_3; // @[Memory.scala 192:42 193:30 196:30]
  wire [127:0] _GEN_14 = reg_lru_way_hot ? _GEN_11[127:0] : _GEN_12[127:0]; // @[Memory.scala 192:42 194:31 197:31]
  wire [3:0] _GEN_19 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? 4'h3 : dcache_state; // @[Memory.scala 189:69 200:24 97:29]
  wire [26:0] _io_dramPort_addr_T_5 = {reg_req_addr_tag[15:0],reg_req_addr_index,4'h0}; // @[Cat.scala 31:58]
  wire [3:0] _GEN_23 = _T_15 ? 4'h5 : dcache_state; // @[Memory.scala 203:69 207:24 97:29]
  wire  _GEN_24 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? 1'h0 : _T_15; // @[Memory.scala 188:111]
  wire  _GEN_25 = (reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2) & _T_15; // @[Memory.scala 188:111]
  wire [26:0] _GEN_26 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_13 :
    _io_dramPort_addr_T_5; // @[Memory.scala 188:111]
  wire [3:0] _GEN_29 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_19 : _GEN_23; // @[Memory.scala 188:111]
  wire [3:0] _GEN_33 = reg_tag_1 == reg_req_addr_tag ? 4'h0 : _GEN_29; // @[Memory.scala 182:52 187:22]
  wire  _GEN_34 = reg_tag_1 == reg_req_addr_tag ? 1'h0 : _GEN_24; // @[Memory.scala 112:19 182:52]
  wire  _GEN_35 = reg_tag_1 == reg_req_addr_tag ? 1'h0 : _GEN_25; // @[Memory.scala 113:19 182:52]
  wire  _GEN_39 = reg_tag_0 == reg_req_addr_tag | _T_8; // @[Memory.scala 176:46 177:24]
  wire [31:0] _GEN_41 = reg_tag_0 == reg_req_addr_tag ? _io_dmem_rdata_T_2[31:0] : _io_dmem_rdata_T_6[31:0]; // @[Memory.scala 176:46 180:23]
  wire [3:0] _GEN_42 = reg_tag_0 == reg_req_addr_tag ? 4'h0 : _GEN_33; // @[Memory.scala 176:46 181:22]
  wire  _GEN_43 = reg_tag_0 == reg_req_addr_tag ? 1'h0 : _GEN_34; // @[Memory.scala 112:19 176:46]
  wire  _GEN_44 = reg_tag_0 == reg_req_addr_tag ? 1'h0 : _GEN_35; // @[Memory.scala 113:19 176:46]
  wire [4:0] _wstrb_T_1 = {reg_req_addr_line_off[4:2],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] _wstrb_T_3 = {28'h0,reg_wstrb}; // @[Memory.scala 135:38]
  wire [62:0] _GEN_1 = {{31'd0}, _wstrb_T_3}; // @[Memory.scala 138:30]
  wire [62:0] _wstrb_T_4 = _GEN_1 << _wstrb_T_1; // @[Memory.scala 138:30]
  wire [31:0] wstrb = _wstrb_T_4[31:0]; // @[Memory.scala 138:39]
  wire [255:0] _wdata_T_1 = {224'h0,reg_wdata}; // @[Memory.scala 132:43]
  wire [510:0] _GEN_2 = {{255'd0}, _wdata_T_1}; // @[Memory.scala 220:46]
  wire [510:0] _wdata_T_4 = _GEN_2 << _io_dmem_rdata_T_1; // @[Memory.scala 220:46]
  wire [255:0] wdata = _wdata_T_4[255:0]; // @[Memory.scala 220:109]
  wire [2:0] _T_23 = {2'h1,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire [2:0] _T_28 = {1'h1,reg_lru_dirty1,1'h1}; // @[Cat.scala 31:58]
  wire  _GEN_90 = _T_7 ? 1'h0 : _T_8; // @[Memory.scala 122:25 218:46]
  wire [26:0] _io_dramPort_addr_T_13 = {reg_tag_0[15:0],reg_req_addr_index,4'h8}; // @[Cat.scala 31:58]
  wire [26:0] _io_dramPort_addr_T_15 = {reg_tag_1[15:0],reg_req_addr_index,4'h8}; // @[Cat.scala 31:58]
  wire [26:0] _GEN_104 = reg_lru_way_hot ? _io_dramPort_addr_T_13 : _io_dramPort_addr_T_15; // @[Memory.scala 273:40 274:28 277:28]
  wire [127:0] _GEN_105 = reg_lru_way_hot ? reg_line1[255:128] : reg_line2[255:128]; // @[Memory.scala 273:40 275:29 278:29]
  wire [3:0] _GEN_110 = _T_15 ? 4'h4 : dcache_state; // @[Memory.scala 270:67 281:22 97:29]
  wire [26:0] _io_dramPort_addr_T_19 = {reg_req_addr_tag[15:0],reg_req_addr_index,4'h8}; // @[Cat.scala 31:58]
  wire [255:0] _reg_line1_T = {reg_line1[255:128],io_dramPort_rdata}; // @[Memory.scala 300:29]
  wire [255:0] _GEN_115 = io_dramPort_rdata_valid ? _reg_line1_T : reg_line1; // @[Memory.scala 297:40 300:21 99:26]
  wire [3:0] _GEN_116 = io_dramPort_rdata_valid ? 4'h8 : 4'h7; // @[Memory.scala 297:40 301:24 303:24]
  wire [3:0] _GEN_118 = io_dramPort_rdata_valid ? 4'h5 : dcache_state; // @[Memory.scala 305:44 309:22 97:29]
  wire [255:0] _GEN_122 = _T_15 ? _GEN_115 : _GEN_115; // @[Memory.scala 293:67]
  wire [3:0] _GEN_123 = _T_15 ? _GEN_116 : _GEN_118; // @[Memory.scala 293:67]
  wire [3:0] _GEN_127 = _T_15 ? 4'h8 : dcache_state; // @[Memory.scala 313:67 317:22 97:29]
  wire [3:0] _GEN_129 = io_dramPort_rdata_valid ? 4'h8 : dcache_state; // @[Memory.scala 321:38 325:22 97:29]
  wire [31:0] _T_70 = {reg_req_addr_tag,reg_req_addr_index,reg_req_addr_line_off}; // @[Memory.scala 334:72]
  wire  _T_72 = reg_ren & io_dmem_ren & io_dmem_raddr == _T_70; // @[Memory.scala 334:38]
  wire [255:0] _io_dmem_rdata_T_8 = {io_dramPort_rdata,reg_line1[127:0]}; // @[Memory.scala 336:33]
  wire [510:0] _GEN_3 = {{255'd0}, _io_dmem_rdata_T_8}; // @[Memory.scala 336:40]
  wire [510:0] _io_dmem_rdata_T_11 = _GEN_3 << _io_dmem_rdata_T_1; // @[Memory.scala 336:40]
  wire  _T_74 = reg_lru_way_hot & reg_ren; // @[Memory.scala 338:39]
  wire [2:0] _T_75 = {2'h0,reg_lru_dirty2}; // @[Cat.scala 31:58]
  wire  _T_80 = _T_11 & reg_ren; // @[Memory.scala 346:45]
  wire [2:0] _T_81 = {1'h1,reg_lru_dirty1,1'h0}; // @[Cat.scala 31:58]
  wire [7:0] _io_cache_array1_wdata_T_5 = wstrb[0] ? _wdata_T_4[7:0] : _io_dmem_rdata_T_8[7:0]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_10 = wstrb[1] ? _wdata_T_4[15:8] : _io_dmem_rdata_T_8[15:8]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_15 = wstrb[2] ? _wdata_T_4[23:16] : _io_dmem_rdata_T_8[23:16]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_20 = wstrb[3] ? _wdata_T_4[31:24] : _io_dmem_rdata_T_8[31:24]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_25 = wstrb[4] ? _wdata_T_4[39:32] : _io_dmem_rdata_T_8[39:32]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_30 = wstrb[5] ? _wdata_T_4[47:40] : _io_dmem_rdata_T_8[47:40]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_35 = wstrb[6] ? _wdata_T_4[55:48] : _io_dmem_rdata_T_8[55:48]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_40 = wstrb[7] ? _wdata_T_4[63:56] : _io_dmem_rdata_T_8[63:56]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_45 = wstrb[8] ? _wdata_T_4[71:64] : _io_dmem_rdata_T_8[71:64]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_50 = wstrb[9] ? _wdata_T_4[79:72] : _io_dmem_rdata_T_8[79:72]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_55 = wstrb[10] ? _wdata_T_4[87:80] : _io_dmem_rdata_T_8[87:80]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_60 = wstrb[11] ? _wdata_T_4[95:88] : _io_dmem_rdata_T_8[95:88]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_65 = wstrb[12] ? _wdata_T_4[103:96] : _io_dmem_rdata_T_8[103:96]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_70 = wstrb[13] ? _wdata_T_4[111:104] : _io_dmem_rdata_T_8[111:104]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_75 = wstrb[14] ? _wdata_T_4[119:112] : _io_dmem_rdata_T_8[119:112]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_80 = wstrb[15] ? _wdata_T_4[127:120] : _io_dmem_rdata_T_8[127:120]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_85 = wstrb[16] ? _wdata_T_4[135:128] : _io_dmem_rdata_T_8[135:128]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_90 = wstrb[17] ? _wdata_T_4[143:136] : _io_dmem_rdata_T_8[143:136]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_95 = wstrb[18] ? _wdata_T_4[151:144] : _io_dmem_rdata_T_8[151:144]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_100 = wstrb[19] ? _wdata_T_4[159:152] : _io_dmem_rdata_T_8[159:152]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_105 = wstrb[20] ? _wdata_T_4[167:160] : _io_dmem_rdata_T_8[167:160]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_110 = wstrb[21] ? _wdata_T_4[175:168] : _io_dmem_rdata_T_8[175:168]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_115 = wstrb[22] ? _wdata_T_4[183:176] : _io_dmem_rdata_T_8[183:176]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_120 = wstrb[23] ? _wdata_T_4[191:184] : _io_dmem_rdata_T_8[191:184]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_125 = wstrb[24] ? _wdata_T_4[199:192] : _io_dmem_rdata_T_8[199:192]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_130 = wstrb[25] ? _wdata_T_4[207:200] : _io_dmem_rdata_T_8[207:200]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_135 = wstrb[26] ? _wdata_T_4[215:208] : _io_dmem_rdata_T_8[215:208]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_140 = wstrb[27] ? _wdata_T_4[223:216] : _io_dmem_rdata_T_8[223:216]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_145 = wstrb[28] ? _wdata_T_4[231:224] : _io_dmem_rdata_T_8[231:224]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_150 = wstrb[29] ? _wdata_T_4[239:232] : _io_dmem_rdata_T_8[239:232]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_155 = wstrb[30] ? _wdata_T_4[247:240] : _io_dmem_rdata_T_8[247:240]; // @[Memory.scala 363:18]
  wire [7:0] _io_cache_array1_wdata_T_160 = wstrb[31] ? _wdata_T_4[255:248] : _io_dmem_rdata_T_8[255:248]; // @[Memory.scala 363:18]
  wire [63:0] io_cache_array1_wdata_lo_lo = {_io_cache_array1_wdata_T_40,_io_cache_array1_wdata_T_35,
    _io_cache_array1_wdata_T_30,_io_cache_array1_wdata_T_25,_io_cache_array1_wdata_T_20,_io_cache_array1_wdata_T_15,
    _io_cache_array1_wdata_T_10,_io_cache_array1_wdata_T_5}; // @[Cat.scala 31:58]
  wire [127:0] io_cache_array1_wdata_lo = {_io_cache_array1_wdata_T_80,_io_cache_array1_wdata_T_75,
    _io_cache_array1_wdata_T_70,_io_cache_array1_wdata_T_65,_io_cache_array1_wdata_T_60,_io_cache_array1_wdata_T_55,
    _io_cache_array1_wdata_T_50,_io_cache_array1_wdata_T_45,io_cache_array1_wdata_lo_lo}; // @[Cat.scala 31:58]
  wire [63:0] io_cache_array1_wdata_hi_lo = {_io_cache_array1_wdata_T_120,_io_cache_array1_wdata_T_115,
    _io_cache_array1_wdata_T_110,_io_cache_array1_wdata_T_105,_io_cache_array1_wdata_T_100,_io_cache_array1_wdata_T_95,
    _io_cache_array1_wdata_T_90,_io_cache_array1_wdata_T_85}; // @[Cat.scala 31:58]
  wire [255:0] _io_cache_array1_wdata_T_161 = {_io_cache_array1_wdata_T_160,_io_cache_array1_wdata_T_155,
    _io_cache_array1_wdata_T_150,_io_cache_array1_wdata_T_145,_io_cache_array1_wdata_T_140,_io_cache_array1_wdata_T_135,
    _io_cache_array1_wdata_T_130,_io_cache_array1_wdata_T_125,io_cache_array1_wdata_hi_lo,io_cache_array1_wdata_lo}; // @[Cat.scala 31:58]
  wire  _GEN_145 = reg_lru_way_hot ? 1'h0 : 1'h1; // @[Memory.scala 357:42 92:22]
  wire  _GEN_160 = _T_11 & reg_ren | _GEN_145; // @[Memory.scala 346:57 348:30]
  wire [255:0] _GEN_163 = _T_11 & reg_ren ? _io_dmem_rdata_T_8 : _io_cache_array1_wdata_T_161; // @[Memory.scala 346:57 351:33]
  wire  _GEN_169 = _T_11 & reg_ren ? 1'h0 : reg_lru_way_hot; // @[Memory.scala 346:57 92:22]
  wire  _GEN_180 = _T_11 & reg_ren ? 1'h0 : _GEN_145; // @[Memory.scala 346:57 92:22]
  wire  _GEN_193 = reg_lru_way_hot & reg_ren | _GEN_169; // @[Memory.scala 338:51 340:30]
  wire [255:0] _GEN_196 = reg_lru_way_hot & reg_ren ? _io_dmem_rdata_T_8 : _io_cache_array1_wdata_T_161; // @[Memory.scala 338:51 343:33]
  wire  _GEN_202 = reg_lru_way_hot & reg_ren ? 1'h0 : _T_80; // @[Memory.scala 338:51 92:22]
  wire  _GEN_206 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_160; // @[Memory.scala 122:25 338:51]
  wire  _GEN_215 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_169; // @[Memory.scala 338:51 92:22]
  wire  _GEN_224 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_180; // @[Memory.scala 338:51 92:22]
  wire  _GEN_231 = io_dramPort_rdata_valid & reg_ren; // @[Memory.scala 108:18 329:38 332:24]
  wire  _GEN_233 = io_dramPort_rdata_valid & _T_72; // @[Memory.scala 110:18 329:38]
  wire  _GEN_237 = io_dramPort_rdata_valid & _T_74; // @[Memory.scala 329:38 92:22]
  wire  _GEN_241 = io_dramPort_rdata_valid & _GEN_193; // @[Memory.scala 118:25 329:38]
  wire  _GEN_250 = io_dramPort_rdata_valid & _GEN_202; // @[Memory.scala 329:38 92:22]
  wire  _GEN_254 = io_dramPort_rdata_valid & _GEN_206; // @[Memory.scala 122:25 329:38]
  wire  _GEN_263 = io_dramPort_rdata_valid & _GEN_215; // @[Memory.scala 329:38 92:22]
  wire  _GEN_272 = io_dramPort_rdata_valid & _GEN_224; // @[Memory.scala 329:38 92:22]
  wire [3:0] _GEN_279 = io_dramPort_rdata_valid ? 4'h0 : dcache_state; // @[Memory.scala 329:38 379:22 97:29]
  wire [3:0] _GEN_328 = 4'h8 == dcache_state ? _GEN_279 : dcache_state; // @[Memory.scala 141:25 97:29]
  wire [255:0] _GEN_329 = 4'h7 == dcache_state ? _GEN_115 : reg_line1; // @[Memory.scala 141:25 99:26]
  wire [3:0] _GEN_330 = 4'h7 == dcache_state ? _GEN_129 : _GEN_328; // @[Memory.scala 141:25]
  wire  _GEN_331 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_231; // @[Memory.scala 108:18 141:25]
  wire  _GEN_333 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_233; // @[Memory.scala 110:18 141:25]
  wire  _GEN_337 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_237; // @[Memory.scala 141:25 92:22]
  wire  _GEN_341 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_241; // @[Memory.scala 118:25 141:25]
  wire  _GEN_350 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_250; // @[Memory.scala 141:25 92:22]
  wire  _GEN_354 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_254; // @[Memory.scala 122:25 141:25]
  wire  _GEN_363 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_263; // @[Memory.scala 141:25 92:22]
  wire  _GEN_372 = 4'h7 == dcache_state ? 1'h0 : 4'h8 == dcache_state & _GEN_272; // @[Memory.scala 141:25 92:22]
  wire  _GEN_379 = 4'h6 == dcache_state & _T_15; // @[Memory.scala 112:19 141:25]
  wire [3:0] _GEN_382 = 4'h6 == dcache_state ? _GEN_127 : _GEN_330; // @[Memory.scala 141:25]
  wire [255:0] _GEN_383 = 4'h6 == dcache_state ? reg_line1 : _GEN_329; // @[Memory.scala 141:25 99:26]
  wire  _GEN_384 = 4'h6 == dcache_state ? 1'h0 : _GEN_331; // @[Memory.scala 108:18 141:25]
  wire  _GEN_386 = 4'h6 == dcache_state ? 1'h0 : _GEN_333; // @[Memory.scala 110:18 141:25]
  wire  _GEN_390 = 4'h6 == dcache_state ? 1'h0 : _GEN_337; // @[Memory.scala 141:25 92:22]
  wire  _GEN_394 = 4'h6 == dcache_state ? 1'h0 : _GEN_341; // @[Memory.scala 118:25 141:25]
  wire  _GEN_403 = 4'h6 == dcache_state ? 1'h0 : _GEN_350; // @[Memory.scala 141:25 92:22]
  wire  _GEN_407 = 4'h6 == dcache_state ? 1'h0 : _GEN_354; // @[Memory.scala 122:25 141:25]
  wire  _GEN_416 = 4'h6 == dcache_state ? 1'h0 : _GEN_363; // @[Memory.scala 141:25 92:22]
  wire  _GEN_425 = 4'h6 == dcache_state ? 1'h0 : _GEN_372; // @[Memory.scala 141:25 92:22]
  wire  _GEN_432 = 4'h5 == dcache_state ? _T_15 : _GEN_379; // @[Memory.scala 141:25]
  wire [26:0] _GEN_434 = 4'h5 == dcache_state ? _io_dramPort_addr_T_19 : _io_dramPort_addr_T_19; // @[Memory.scala 141:25]
  wire [255:0] _GEN_435 = 4'h5 == dcache_state ? _GEN_122 : _GEN_383; // @[Memory.scala 141:25]
  wire [3:0] _GEN_436 = 4'h5 == dcache_state ? _GEN_123 : _GEN_382; // @[Memory.scala 141:25]
  wire  _GEN_437 = 4'h5 == dcache_state ? 1'h0 : _GEN_384; // @[Memory.scala 108:18 141:25]
  wire  _GEN_439 = 4'h5 == dcache_state ? 1'h0 : _GEN_386; // @[Memory.scala 110:18 141:25]
  wire  _GEN_443 = 4'h5 == dcache_state ? 1'h0 : _GEN_390; // @[Memory.scala 141:25 92:22]
  wire  _GEN_447 = 4'h5 == dcache_state ? 1'h0 : _GEN_394; // @[Memory.scala 118:25 141:25]
  wire  _GEN_456 = 4'h5 == dcache_state ? 1'h0 : _GEN_403; // @[Memory.scala 141:25 92:22]
  wire  _GEN_460 = 4'h5 == dcache_state ? 1'h0 : _GEN_407; // @[Memory.scala 122:25 141:25]
  wire  _GEN_469 = 4'h5 == dcache_state ? 1'h0 : _GEN_416; // @[Memory.scala 141:25 92:22]
  wire  _GEN_478 = 4'h5 == dcache_state ? 1'h0 : _GEN_425; // @[Memory.scala 141:25 92:22]
  wire  _GEN_485 = 4'h4 == dcache_state ? _T_15 : _GEN_432; // @[Memory.scala 141:25]
  wire [26:0] _GEN_487 = 4'h4 == dcache_state ? _io_dramPort_addr_T_5 : _GEN_434; // @[Memory.scala 141:25]
  wire [3:0] _GEN_488 = 4'h4 == dcache_state ? _GEN_23 : _GEN_436; // @[Memory.scala 141:25]
  wire [255:0] _GEN_489 = 4'h4 == dcache_state ? reg_line1 : _GEN_435; // @[Memory.scala 141:25 99:26]
  wire  _GEN_490 = 4'h4 == dcache_state ? 1'h0 : _GEN_437; // @[Memory.scala 108:18 141:25]
  wire  _GEN_492 = 4'h4 == dcache_state ? 1'h0 : _GEN_439; // @[Memory.scala 110:18 141:25]
  wire  _GEN_496 = 4'h4 == dcache_state ? 1'h0 : _GEN_443; // @[Memory.scala 141:25 92:22]
  wire  _GEN_500 = 4'h4 == dcache_state ? 1'h0 : _GEN_447; // @[Memory.scala 118:25 141:25]
  wire  _GEN_509 = 4'h4 == dcache_state ? 1'h0 : _GEN_456; // @[Memory.scala 141:25 92:22]
  wire  _GEN_513 = 4'h4 == dcache_state ? 1'h0 : _GEN_460; // @[Memory.scala 122:25 141:25]
  wire  _GEN_522 = 4'h4 == dcache_state ? 1'h0 : _GEN_469; // @[Memory.scala 141:25 92:22]
  wire  _GEN_531 = 4'h4 == dcache_state ? 1'h0 : _GEN_478; // @[Memory.scala 141:25 92:22]
  wire  _GEN_538 = 4'h3 == dcache_state ? 1'h0 : _GEN_485; // @[Memory.scala 141:25]
  wire [26:0] _GEN_540 = 4'h3 == dcache_state ? _GEN_104 : _GEN_487; // @[Memory.scala 141:25]
  wire [3:0] _GEN_543 = 4'h3 == dcache_state ? _GEN_110 : _GEN_488; // @[Memory.scala 141:25]
  wire [255:0] _GEN_544 = 4'h3 == dcache_state ? reg_line1 : _GEN_489; // @[Memory.scala 141:25 99:26]
  wire  _GEN_545 = 4'h3 == dcache_state ? 1'h0 : _GEN_490; // @[Memory.scala 108:18 141:25]
  wire  _GEN_547 = 4'h3 == dcache_state ? 1'h0 : _GEN_492; // @[Memory.scala 110:18 141:25]
  wire  _GEN_551 = 4'h3 == dcache_state ? 1'h0 : _GEN_496; // @[Memory.scala 141:25 92:22]
  wire  _GEN_555 = 4'h3 == dcache_state ? 1'h0 : _GEN_500; // @[Memory.scala 118:25 141:25]
  wire  _GEN_564 = 4'h3 == dcache_state ? 1'h0 : _GEN_509; // @[Memory.scala 141:25 92:22]
  wire  _GEN_568 = 4'h3 == dcache_state ? 1'h0 : _GEN_513; // @[Memory.scala 122:25 141:25]
  wire  _GEN_577 = 4'h3 == dcache_state ? 1'h0 : _GEN_522; // @[Memory.scala 141:25 92:22]
  wire  _GEN_586 = 4'h3 == dcache_state ? 1'h0 : _GEN_531; // @[Memory.scala 141:25 92:22]
  wire  _GEN_595 = 4'h2 == dcache_state ? _T_7 : _GEN_555; // @[Memory.scala 141:25]
  wire [31:0] _GEN_596 = 4'h2 == dcache_state ? wstrb : 32'hffffffff; // @[Memory.scala 141:25]
  wire  _GEN_607 = 4'h2 == dcache_state ? _GEN_90 : _GEN_568; // @[Memory.scala 141:25]
  wire [510:0] _GEN_610 = 4'h2 == dcache_state ? _wdata_T_4 : {{255'd0}, _GEN_163}; // @[Memory.scala 141:25]
  wire  _GEN_618 = 4'h2 == dcache_state ? _GEN_43 : _GEN_538; // @[Memory.scala 141:25]
  wire  _GEN_619 = 4'h2 == dcache_state ? _GEN_44 : 4'h3 == dcache_state & _T_15; // @[Memory.scala 141:25]
  wire [26:0] _GEN_620 = 4'h2 == dcache_state ? _GEN_26 : _GEN_540; // @[Memory.scala 141:25]
  wire [127:0] _GEN_621 = 4'h2 == dcache_state ? _GEN_14 : _GEN_105; // @[Memory.scala 141:25]
  wire  _GEN_623 = 4'h2 == dcache_state ? 1'h0 : _GEN_545; // @[Memory.scala 108:18 141:25]
  wire  _GEN_625 = 4'h2 == dcache_state ? 1'h0 : _GEN_547; // @[Memory.scala 110:18 141:25]
  wire  _GEN_629 = 4'h2 == dcache_state ? 1'h0 : _GEN_551; // @[Memory.scala 141:25 92:22]
  wire  _GEN_638 = 4'h2 == dcache_state ? 1'h0 : _GEN_564; // @[Memory.scala 141:25 92:22]
  wire  _GEN_647 = 4'h2 == dcache_state ? 1'h0 : _GEN_577; // @[Memory.scala 141:25 92:22]
  wire  _GEN_656 = 4'h2 == dcache_state ? 1'h0 : _GEN_586; // @[Memory.scala 141:25 92:22]
  wire  _GEN_665 = 4'h1 == dcache_state ? _GEN_39 : _GEN_623; // @[Memory.scala 141:25]
  wire  _GEN_667 = 4'h1 == dcache_state ? _GEN_39 : _GEN_625; // @[Memory.scala 141:25]
  wire [510:0] _GEN_668 = 4'h1 == dcache_state ? {{479'd0}, _GEN_41} : _io_dmem_rdata_T_11; // @[Memory.scala 141:25]
  wire  _GEN_670 = 4'h1 == dcache_state ? _GEN_43 : _GEN_618; // @[Memory.scala 141:25]
  wire  _GEN_671 = 4'h1 == dcache_state ? _GEN_44 : _GEN_619; // @[Memory.scala 141:25]
  wire [26:0] _GEN_672 = 4'h1 == dcache_state ? _GEN_26 : _GEN_620; // @[Memory.scala 141:25]
  wire  _GEN_675 = 4'h1 == dcache_state ? 1'h0 : _GEN_595; // @[Memory.scala 118:25 141:25]
  wire  _GEN_681 = 4'h1 == dcache_state ? 1'h0 : 4'h2 == dcache_state & _T_7; // @[Memory.scala 141:25 95:22]
  wire  _GEN_686 = 4'h1 == dcache_state ? 1'h0 : _GEN_607; // @[Memory.scala 122:25 141:25]
  wire  _GEN_692 = 4'h1 == dcache_state ? 1'h0 : 4'h2 == dcache_state & _GEN_90; // @[Memory.scala 141:25 95:22]
  wire  _GEN_699 = 4'h1 == dcache_state ? 1'h0 : _GEN_629; // @[Memory.scala 141:25 92:22]
  wire  _GEN_708 = 4'h1 == dcache_state ? 1'h0 : _GEN_638; // @[Memory.scala 141:25 92:22]
  wire  _GEN_717 = 4'h1 == dcache_state ? 1'h0 : _GEN_647; // @[Memory.scala 141:25 92:22]
  wire  _GEN_726 = 4'h1 == dcache_state ? 1'h0 : _GEN_656; // @[Memory.scala 141:25 92:22]
  wire  _GEN_740 = 4'h0 == dcache_state ? io_dmem_ren : reg_ren; // @[Memory.scala 141:25 149:15 105:24]
  wire  _GEN_743 = 4'h0 == dcache_state & _T_3; // @[Memory.scala 141:25 92:22]
  wire  _T_95 = ~reset; // @[Memory.scala 384:9]
  assign tag_array_0_MPORT_en = _T_2 & _T_3;
  assign tag_array_0_MPORT_addr = _req_addr_T[11:5];
  assign tag_array_0_MPORT_data = tag_array_0[tag_array_0_MPORT_addr]; // @[Memory.scala 92:22]
  assign tag_array_0_MPORT_3_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_3_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_3_mask = 1'h1;
  assign tag_array_0_MPORT_3_en = _T_2 ? 1'h0 : _GEN_699;
  assign tag_array_0_MPORT_5_data = reg_tag_0;
  assign tag_array_0_MPORT_5_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_5_mask = 1'h1;
  assign tag_array_0_MPORT_5_en = _T_2 ? 1'h0 : _GEN_708;
  assign tag_array_0_MPORT_7_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_7_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_7_mask = 1'h1;
  assign tag_array_0_MPORT_7_en = _T_2 ? 1'h0 : _GEN_717;
  assign tag_array_0_MPORT_9_data = reg_tag_0;
  assign tag_array_0_MPORT_9_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_9_mask = 1'h1;
  assign tag_array_0_MPORT_9_en = _T_2 ? 1'h0 : _GEN_726;
  assign tag_array_1_MPORT_en = _T_2 & _T_3;
  assign tag_array_1_MPORT_addr = _req_addr_T[11:5];
  assign tag_array_1_MPORT_data = tag_array_1[tag_array_1_MPORT_addr]; // @[Memory.scala 92:22]
  assign tag_array_1_MPORT_3_data = reg_tag_1;
  assign tag_array_1_MPORT_3_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_3_mask = 1'h1;
  assign tag_array_1_MPORT_3_en = _T_2 ? 1'h0 : _GEN_699;
  assign tag_array_1_MPORT_5_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_5_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_5_mask = 1'h1;
  assign tag_array_1_MPORT_5_en = _T_2 ? 1'h0 : _GEN_708;
  assign tag_array_1_MPORT_7_data = reg_tag_1;
  assign tag_array_1_MPORT_7_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_7_mask = 1'h1;
  assign tag_array_1_MPORT_7_en = _T_2 ? 1'h0 : _GEN_717;
  assign tag_array_1_MPORT_9_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_9_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_9_mask = 1'h1;
  assign tag_array_1_MPORT_9_en = _T_2 ? 1'h0 : _GEN_726;
  assign lru_array_way_hot_reg_lru_MPORT_en = _T_2 & _T_3;
  assign lru_array_way_hot_reg_lru_MPORT_addr = _req_addr_T[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_addr]; // @[Memory.scala 95:22]
  assign lru_array_way_hot_MPORT_1_data = _T_23[2];
  assign lru_array_way_hot_MPORT_1_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_1_mask = 1'h1;
  assign lru_array_way_hot_MPORT_1_en = _T_2 ? 1'h0 : _GEN_681;
  assign lru_array_way_hot_MPORT_2_data = _T_28[2];
  assign lru_array_way_hot_MPORT_2_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_2_mask = 1'h1;
  assign lru_array_way_hot_MPORT_2_en = _T_2 ? 1'h0 : _GEN_692;
  assign lru_array_way_hot_MPORT_4_data = _T_75[2];
  assign lru_array_way_hot_MPORT_4_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_4_mask = 1'h1;
  assign lru_array_way_hot_MPORT_4_en = _T_2 ? 1'h0 : _GEN_699;
  assign lru_array_way_hot_MPORT_6_data = _T_81[2];
  assign lru_array_way_hot_MPORT_6_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_6_mask = 1'h1;
  assign lru_array_way_hot_MPORT_6_en = _T_2 ? 1'h0 : _GEN_708;
  assign lru_array_way_hot_MPORT_8_data = _T_23[2];
  assign lru_array_way_hot_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_8_mask = 1'h1;
  assign lru_array_way_hot_MPORT_8_en = _T_2 ? 1'h0 : _GEN_717;
  assign lru_array_way_hot_MPORT_10_data = _T_28[2];
  assign lru_array_way_hot_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_10_mask = 1'h1;
  assign lru_array_way_hot_MPORT_10_en = _T_2 ? 1'h0 : _GEN_726;
  assign lru_array_dirty1_reg_lru_MPORT_en = _T_2 & _T_3;
  assign lru_array_dirty1_reg_lru_MPORT_addr = _req_addr_T[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_addr]; // @[Memory.scala 95:22]
  assign lru_array_dirty1_MPORT_1_data = _T_23[1];
  assign lru_array_dirty1_MPORT_1_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_1_mask = 1'h1;
  assign lru_array_dirty1_MPORT_1_en = _T_2 ? 1'h0 : _GEN_681;
  assign lru_array_dirty1_MPORT_2_data = _T_28[1];
  assign lru_array_dirty1_MPORT_2_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_2_mask = 1'h1;
  assign lru_array_dirty1_MPORT_2_en = _T_2 ? 1'h0 : _GEN_692;
  assign lru_array_dirty1_MPORT_4_data = _T_75[1];
  assign lru_array_dirty1_MPORT_4_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_4_mask = 1'h1;
  assign lru_array_dirty1_MPORT_4_en = _T_2 ? 1'h0 : _GEN_699;
  assign lru_array_dirty1_MPORT_6_data = _T_81[1];
  assign lru_array_dirty1_MPORT_6_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_6_mask = 1'h1;
  assign lru_array_dirty1_MPORT_6_en = _T_2 ? 1'h0 : _GEN_708;
  assign lru_array_dirty1_MPORT_8_data = _T_23[1];
  assign lru_array_dirty1_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_8_mask = 1'h1;
  assign lru_array_dirty1_MPORT_8_en = _T_2 ? 1'h0 : _GEN_717;
  assign lru_array_dirty1_MPORT_10_data = _T_28[1];
  assign lru_array_dirty1_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_10_mask = 1'h1;
  assign lru_array_dirty1_MPORT_10_en = _T_2 ? 1'h0 : _GEN_726;
  assign lru_array_dirty2_reg_lru_MPORT_en = _T_2 & _T_3;
  assign lru_array_dirty2_reg_lru_MPORT_addr = _req_addr_T[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_addr]; // @[Memory.scala 95:22]
  assign lru_array_dirty2_MPORT_1_data = _T_23[0];
  assign lru_array_dirty2_MPORT_1_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_1_mask = 1'h1;
  assign lru_array_dirty2_MPORT_1_en = _T_2 ? 1'h0 : _GEN_681;
  assign lru_array_dirty2_MPORT_2_data = _T_28[0];
  assign lru_array_dirty2_MPORT_2_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_2_mask = 1'h1;
  assign lru_array_dirty2_MPORT_2_en = _T_2 ? 1'h0 : _GEN_692;
  assign lru_array_dirty2_MPORT_4_data = _T_75[0];
  assign lru_array_dirty2_MPORT_4_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_4_mask = 1'h1;
  assign lru_array_dirty2_MPORT_4_en = _T_2 ? 1'h0 : _GEN_699;
  assign lru_array_dirty2_MPORT_6_data = _T_81[0];
  assign lru_array_dirty2_MPORT_6_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_6_mask = 1'h1;
  assign lru_array_dirty2_MPORT_6_en = _T_2 ? 1'h0 : _GEN_708;
  assign lru_array_dirty2_MPORT_8_data = _T_23[0];
  assign lru_array_dirty2_MPORT_8_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_8_mask = 1'h1;
  assign lru_array_dirty2_MPORT_8_en = _T_2 ? 1'h0 : _GEN_717;
  assign lru_array_dirty2_MPORT_10_data = _T_28[0];
  assign lru_array_dirty2_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_10_mask = 1'h1;
  assign lru_array_dirty2_MPORT_10_en = _T_2 ? 1'h0 : _GEN_726;
  assign io_imem_inst = io_imemReadPort_data; // @[Memory.scala 88:16]
  assign io_dmem_rdata = _GEN_668[31:0];
  assign io_dmem_rvalid = 4'h0 == dcache_state ? 1'h0 : _GEN_667; // @[Memory.scala 110:18 141:25]
  assign io_dmem_rready = 4'h0 == dcache_state | _GEN_665; // @[Memory.scala 141:25 143:22]
  assign io_dmem_wready = 4'h0 == dcache_state; // @[Memory.scala 141:25]
  assign io_imemReadPort_address = io_imem_addr[10:2]; // @[Memory.scala 89:27]
  assign io_dramPort_ren = 4'h0 == dcache_state ? 1'h0 : _GEN_670; // @[Memory.scala 112:19 141:25]
  assign io_dramPort_wen = 4'h0 == dcache_state ? 1'h0 : _GEN_671; // @[Memory.scala 113:19 141:25]
  assign io_dramPort_addr = {{1'd0}, _GEN_672};
  assign io_dramPort_wdata = 4'h1 == dcache_state ? _GEN_14 : _GEN_621; // @[Memory.scala 141:25]
  assign io_cache_array1_en = 4'h0 == dcache_state ? _T_3 : _GEN_675; // @[Memory.scala 141:25]
  assign io_cache_array1_we = 4'h0 == dcache_state ? 32'h0 : _GEN_596; // @[Memory.scala 141:25]
  assign io_cache_array1_addr = 4'h0 == dcache_state ? req_addr_index : reg_req_addr_index; // @[Memory.scala 141:25]
  assign io_cache_array1_wdata = 4'h2 == dcache_state ? wdata : _GEN_196; // @[Memory.scala 141:25]
  assign io_cache_array2_en = 4'h0 == dcache_state ? _T_3 : _GEN_686; // @[Memory.scala 141:25]
  assign io_cache_array2_we = 4'h0 == dcache_state ? 32'h0 : _GEN_596; // @[Memory.scala 141:25]
  assign io_cache_array2_addr = 4'h0 == dcache_state ? req_addr_index : reg_req_addr_index; // @[Memory.scala 141:25]
  assign io_cache_array2_wdata = _GEN_610[255:0];
  always @(posedge clock) begin
    if (tag_array_0_MPORT_3_en & tag_array_0_MPORT_3_mask) begin
      tag_array_0[tag_array_0_MPORT_3_addr] <= tag_array_0_MPORT_3_data; // @[Memory.scala 92:22]
    end
    if (tag_array_0_MPORT_5_en & tag_array_0_MPORT_5_mask) begin
      tag_array_0[tag_array_0_MPORT_5_addr] <= tag_array_0_MPORT_5_data; // @[Memory.scala 92:22]
    end
    if (tag_array_0_MPORT_7_en & tag_array_0_MPORT_7_mask) begin
      tag_array_0[tag_array_0_MPORT_7_addr] <= tag_array_0_MPORT_7_data; // @[Memory.scala 92:22]
    end
    if (tag_array_0_MPORT_9_en & tag_array_0_MPORT_9_mask) begin
      tag_array_0[tag_array_0_MPORT_9_addr] <= tag_array_0_MPORT_9_data; // @[Memory.scala 92:22]
    end
    if (tag_array_1_MPORT_3_en & tag_array_1_MPORT_3_mask) begin
      tag_array_1[tag_array_1_MPORT_3_addr] <= tag_array_1_MPORT_3_data; // @[Memory.scala 92:22]
    end
    if (tag_array_1_MPORT_5_en & tag_array_1_MPORT_5_mask) begin
      tag_array_1[tag_array_1_MPORT_5_addr] <= tag_array_1_MPORT_5_data; // @[Memory.scala 92:22]
    end
    if (tag_array_1_MPORT_7_en & tag_array_1_MPORT_7_mask) begin
      tag_array_1[tag_array_1_MPORT_7_addr] <= tag_array_1_MPORT_7_data; // @[Memory.scala 92:22]
    end
    if (tag_array_1_MPORT_9_en & tag_array_1_MPORT_9_mask) begin
      tag_array_1[tag_array_1_MPORT_9_addr] <= tag_array_1_MPORT_9_data; // @[Memory.scala 92:22]
    end
    if (lru_array_way_hot_MPORT_1_en & lru_array_way_hot_MPORT_1_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_1_addr] <= lru_array_way_hot_MPORT_1_data; // @[Memory.scala 95:22]
    end
    if (lru_array_way_hot_MPORT_2_en & lru_array_way_hot_MPORT_2_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_2_addr] <= lru_array_way_hot_MPORT_2_data; // @[Memory.scala 95:22]
    end
    if (lru_array_way_hot_MPORT_4_en & lru_array_way_hot_MPORT_4_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_4_addr] <= lru_array_way_hot_MPORT_4_data; // @[Memory.scala 95:22]
    end
    if (lru_array_way_hot_MPORT_6_en & lru_array_way_hot_MPORT_6_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_6_addr] <= lru_array_way_hot_MPORT_6_data; // @[Memory.scala 95:22]
    end
    if (lru_array_way_hot_MPORT_8_en & lru_array_way_hot_MPORT_8_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_8_addr] <= lru_array_way_hot_MPORT_8_data; // @[Memory.scala 95:22]
    end
    if (lru_array_way_hot_MPORT_10_en & lru_array_way_hot_MPORT_10_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_10_addr] <= lru_array_way_hot_MPORT_10_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_1_en & lru_array_dirty1_MPORT_1_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_1_addr] <= lru_array_dirty1_MPORT_1_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_2_en & lru_array_dirty1_MPORT_2_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_2_addr] <= lru_array_dirty1_MPORT_2_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_4_en & lru_array_dirty1_MPORT_4_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_4_addr] <= lru_array_dirty1_MPORT_4_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_6_en & lru_array_dirty1_MPORT_6_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_6_addr] <= lru_array_dirty1_MPORT_6_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_8_en & lru_array_dirty1_MPORT_8_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_8_addr] <= lru_array_dirty1_MPORT_8_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty1_MPORT_10_en & lru_array_dirty1_MPORT_10_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_10_addr] <= lru_array_dirty1_MPORT_10_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_1_en & lru_array_dirty2_MPORT_1_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_1_addr] <= lru_array_dirty2_MPORT_1_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_2_en & lru_array_dirty2_MPORT_2_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_2_addr] <= lru_array_dirty2_MPORT_2_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_4_en & lru_array_dirty2_MPORT_4_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_4_addr] <= lru_array_dirty2_MPORT_4_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_6_en & lru_array_dirty2_MPORT_6_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_6_addr] <= lru_array_dirty2_MPORT_6_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_8_en & lru_array_dirty2_MPORT_8_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_8_addr] <= lru_array_dirty2_MPORT_8_data; // @[Memory.scala 95:22]
    end
    if (lru_array_dirty2_MPORT_10_en & lru_array_dirty2_MPORT_10_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_10_addr] <= lru_array_dirty2_MPORT_10_data; // @[Memory.scala 95:22]
    end
    if (reset) begin // @[Memory.scala 97:29]
      dcache_state <= 4'h0; // @[Memory.scala 97:29]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        dcache_state <= {{2'd0}, _GEN_0};
      end
    end else if (4'h1 == dcache_state) begin // @[Memory.scala 141:25]
      dcache_state <= _GEN_42;
    end else if (4'h2 == dcache_state) begin // @[Memory.scala 141:25]
      dcache_state <= _GEN_42;
    end else begin
      dcache_state <= _GEN_543;
    end
    if (reset) begin // @[Memory.scala 98:24]
      reg_tag_0 <= 20'h0; // @[Memory.scala 98:24]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        reg_tag_0 <= tag_array_0_MPORT_data; // @[Memory.scala 151:17]
      end
    end
    if (reset) begin // @[Memory.scala 98:24]
      reg_tag_1 <= 20'h0; // @[Memory.scala 98:24]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        reg_tag_1 <= tag_array_1_MPORT_data; // @[Memory.scala 151:17]
      end
    end
    if (reset) begin // @[Memory.scala 99:26]
      reg_line1 <= 256'h0; // @[Memory.scala 99:26]
    end else if (!(4'h0 == dcache_state)) begin // @[Memory.scala 141:25]
      if (4'h1 == dcache_state) begin // @[Memory.scala 141:25]
        reg_line1 <= _GEN_11;
      end else if (4'h2 == dcache_state) begin // @[Memory.scala 141:25]
        reg_line1 <= _GEN_11;
      end else begin
        reg_line1 <= _GEN_544;
      end
    end
    if (reset) begin // @[Memory.scala 100:26]
      reg_line2 <= 256'h0; // @[Memory.scala 100:26]
    end else if (!(4'h0 == dcache_state)) begin // @[Memory.scala 141:25]
      if (4'h1 == dcache_state) begin // @[Memory.scala 141:25]
        reg_line2 <= _GEN_12;
      end else if (4'h2 == dcache_state) begin // @[Memory.scala 141:25]
        reg_line2 <= _GEN_12;
      end
    end
    if (reset) begin // @[Memory.scala 101:24]
      reg_lru_way_hot <= 1'h0; // @[Memory.scala 101:24]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        reg_lru_way_hot <= lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 161:17]
      end
    end
    if (reset) begin // @[Memory.scala 101:24]
      reg_lru_dirty1 <= 1'h0; // @[Memory.scala 101:24]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        reg_lru_dirty1 <= lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 161:17]
      end
    end
    if (reset) begin // @[Memory.scala 101:24]
      reg_lru_dirty2 <= 1'h0; // @[Memory.scala 101:24]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      if (io_dmem_ren | io_dmem_wen) begin // @[Memory.scala 150:41]
        reg_lru_dirty2 <= lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 161:17]
      end
    end
    if (reset) begin // @[Memory.scala 102:29]
      reg_req_addr_tag <= 20'h0; // @[Memory.scala 102:29]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      reg_req_addr_tag <= req_addr_tag; // @[Memory.scala 146:20]
    end
    if (reset) begin // @[Memory.scala 102:29]
      reg_req_addr_index <= 7'h0; // @[Memory.scala 102:29]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      reg_req_addr_index <= req_addr_index; // @[Memory.scala 146:20]
    end
    if (reset) begin // @[Memory.scala 102:29]
      reg_req_addr_line_off <= 5'h0; // @[Memory.scala 102:29]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      reg_req_addr_line_off <= req_addr_line_off; // @[Memory.scala 146:20]
    end
    if (reset) begin // @[Memory.scala 103:26]
      reg_wdata <= 32'h0; // @[Memory.scala 103:26]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      reg_wdata <= io_dmem_wdata; // @[Memory.scala 147:17]
    end
    if (reset) begin // @[Memory.scala 104:26]
      reg_wstrb <= 4'h0; // @[Memory.scala 104:26]
    end else if (4'h0 == dcache_state) begin // @[Memory.scala 141:25]
      reg_wstrb <= io_dmem_wstrb; // @[Memory.scala 148:17]
    end
    reg_ren <= reset | _GEN_740; // @[Memory.scala 105:{24,24}]
    if (reset) begin // @[Memory.scala 106:32]
      reg_dcache_read <= 1'h0; // @[Memory.scala 106:32]
    end else begin
      reg_dcache_read <= _GEN_743;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"io.dmem.rready  : %d\n",io_dmem_rready); // @[Memory.scala 384:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"io.dmem.wready  : %d\n",io_dmem_wready); // @[Memory.scala 385:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"io.dmem.ren     : %d\n",io_dmem_ren); // @[Memory.scala 386:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"io.dmem.wen     : %d\n",io_dmem_wen); // @[Memory.scala 387:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"io.dmem.raddr   : 0x%x\n",io_dmem_raddr); // @[Memory.scala 388:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"io.dmem.waddr   : 0x%x\n",io_dmem_waddr); // @[Memory.scala 389:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_req_addr    : 0x%x\n",_T_70); // @[Memory.scala 390:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_req_addr.tag: 0x%x\n",reg_req_addr_tag); // @[Memory.scala 391:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_req_addr.ind: 0x%x\n",reg_req_addr_index); // @[Memory.scala 392:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_req_addr.off: 0x%x\n",reg_req_addr_line_off); // @[Memory.scala 393:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_tag(0)      : 0x%x\n",reg_tag_0); // @[Memory.scala 394:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_tag(1)      : 0x%x\n",reg_tag_1); // @[Memory.scala 395:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_lru         : 0x%x\n",{reg_lru_way_hot,reg_lru_dirty1,reg_lru_dirty2}); // @[Memory.scala 396:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_line1       : 0x%x\n",reg_line1); // @[Memory.scala 397:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"reg_line2       : 0x%x\n",reg_line2); // @[Memory.scala 398:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_95) begin
          $fwrite(32'h80000002,"dcache_state    : %d\n",dcache_state); // @[Memory.scala 399:9]
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
    tag_array_0[initvar] = _RAND_0[19:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tag_array_1[initvar] = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_way_hot[initvar] = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_dirty1[initvar] = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    lru_array_dirty2[initvar] = _RAND_4[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  dcache_state = _RAND_5[3:0];
  _RAND_6 = {1{`RANDOM}};
  reg_tag_0 = _RAND_6[19:0];
  _RAND_7 = {1{`RANDOM}};
  reg_tag_1 = _RAND_7[19:0];
  _RAND_8 = {8{`RANDOM}};
  reg_line1 = _RAND_8[255:0];
  _RAND_9 = {8{`RANDOM}};
  reg_line2 = _RAND_9[255:0];
  _RAND_10 = {1{`RANDOM}};
  reg_lru_way_hot = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  reg_lru_dirty1 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  reg_lru_dirty2 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  reg_req_addr_tag = _RAND_13[19:0];
  _RAND_14 = {1{`RANDOM}};
  reg_req_addr_index = _RAND_14[6:0];
  _RAND_15 = {1{`RANDOM}};
  reg_req_addr_line_off = _RAND_15[4:0];
  _RAND_16 = {1{`RANDOM}};
  reg_wdata = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  reg_wstrb = _RAND_17[3:0];
  _RAND_18 = {1{`RANDOM}};
  reg_ren = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  reg_dcache_read = _RAND_19[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SingleCycleMem(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata,
  input         io_mem_ren,
  output        io_mem_rvalid,
  input  [31:0] io_mem_waddr,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  output [8:0]  io_read_address,
  input  [31:0] io_read_data,
  output        io_read_enable,
  output [8:0]  io_write_address,
  output [31:0] io_write_data,
  output        io_write_enable
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg  io_mem_rvalid_REG; // @[SingleCycleMem.scala 18:27]
  assign io_mem_rdata = io_read_data; // @[SingleCycleMem.scala 17:16]
  assign io_mem_rvalid = io_mem_rvalid_REG; // @[SingleCycleMem.scala 18:17]
  assign io_read_address = io_mem_raddr[10:2]; // @[SingleCycleMem.scala 15:19]
  assign io_read_enable = io_mem_ren; // @[SingleCycleMem.scala 16:18]
  assign io_write_address = io_mem_waddr[10:2]; // @[SingleCycleMem.scala 21:20]
  assign io_write_data = io_mem_wdata; // @[SingleCycleMem.scala 23:17]
  assign io_write_enable = io_mem_wen; // @[SingleCycleMem.scala 22:19]
  always @(posedge clock) begin
    if (reset) begin // @[SingleCycleMem.scala 18:27]
      io_mem_rvalid_REG <= 1'h0; // @[SingleCycleMem.scala 18:27]
    end else begin
      io_mem_rvalid_REG <= io_mem_ren; // @[SingleCycleMem.scala 18:27]
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
  io_mem_rvalid_REG = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
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
  assign io_mem_rdata = {{5'd0}, _io_mem_rdata_T_2}; // @[Top.scala 18:16]
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
  wire [31:0] _raddr_T_1 = io_initiator_raddr - 32'h8000000; // @[Decoder.scala 42:35]
  wire  _GEN_2 = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? io_targets_0_rvalid : 1'h1; // @[Decoder.scala 41:85 44:14]
  wire [31:0] _GEN_3 = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? io_targets_0_rdata : 32'hdeadbeef
    ; // @[Decoder.scala 41:85 45:13]
  wire [31:0] _waddr_T_1 = io_initiator_waddr - 32'h8000000; // @[Decoder.scala 49:35]
  wire [31:0] _raddr_T_3 = io_initiator_raddr - 32'h20000000; // @[Decoder.scala 42:35]
  wire  _GEN_12 = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000000 ? io_targets_1_rvalid : _GEN_2; // @[Decoder.scala 41:85 44:14]
  wire [31:0] _GEN_13 = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000000 ? io_targets_1_rdata :
    _GEN_3; // @[Decoder.scala 41:85 45:13]
  wire  _GEN_14 = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000000 ? io_targets_1_rready : 32'h8000000
     <= io_initiator_raddr & io_initiator_raddr < 32'h8000800; // @[Decoder.scala 41:85 46:14]
  wire [31:0] _waddr_T_3 = io_initiator_waddr - 32'h20000000; // @[Decoder.scala 49:35]
  wire  _GEN_19 = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000000 ? io_targets_1_wready : 32'h8000000
     <= io_initiator_waddr & io_initiator_waddr < 32'h8000800; // @[Decoder.scala 48:85 53:14]
  wire [31:0] _GEN_23 = 32'h30000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000040 ? 32'hdeadbeef : _GEN_13; // @[Decoder.scala 41:85 45:13]
  wire [31:0] _raddr_T_7 = io_initiator_raddr - 32'h30001000; // @[Decoder.scala 42:35]
  wire  _GEN_32 = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? io_targets_3_rvalid : 32'h30000000
     <= io_initiator_raddr & io_initiator_raddr < 32'h30000040 | _GEN_12; // @[Decoder.scala 41:85 44:14]
  wire [31:0] _GEN_33 = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? io_targets_3_rdata :
    _GEN_23; // @[Decoder.scala 41:85 45:13]
  wire [31:0] _waddr_T_7 = io_initiator_waddr - 32'h30001000; // @[Decoder.scala 49:35]
  wire [31:0] _raddr_T_9 = io_initiator_raddr - 32'h30002000; // @[Decoder.scala 42:35]
  wire  _GEN_42 = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? io_targets_4_rvalid : _GEN_32
    ; // @[Decoder.scala 41:85 44:14]
  wire [31:0] _GEN_43 = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? io_targets_4_rdata :
    _GEN_33; // @[Decoder.scala 41:85 45:13]
  wire [31:0] _waddr_T_9 = io_initiator_waddr - 32'h30002000; // @[Decoder.scala 49:35]
  wire [31:0] _raddr_T_11 = io_initiator_raddr - 32'h40000000; // @[Decoder.scala 42:35]
  assign io_initiator_rdata = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 ?
    io_targets_5_rdata : _GEN_43; // @[Decoder.scala 41:85 45:13]
  assign io_initiator_rvalid = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 | _GEN_42; // @[Decoder.scala 41:85 44:14]
  assign io_initiator_rready = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 | (32'h30002000
     <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 | (32'h30001000 <= io_initiator_raddr &
    io_initiator_raddr < 32'h30001040 | (32'h30000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000040 |
    _GEN_14))); // @[Decoder.scala 41:85 46:14]
  assign io_initiator_wready = 32'h40000000 <= io_initiator_waddr & io_initiator_waddr < 32'h40000040 | (32'h30002000
     <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 | (32'h30001000 <= io_initiator_waddr &
    io_initiator_waddr < 32'h30001040 | (32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 |
    _GEN_19))); // @[Decoder.scala 48:85 53:14]
  assign io_targets_0_raddr = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? _raddr_T_1 : 32'h0; // @[Decoder.scala 41:85 42:13]
  assign io_targets_0_ren = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 & io_initiator_ren; // @[Decoder.scala 41:85 43:11]
  assign io_targets_0_waddr = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 ? _waddr_T_1 : 32'h0; // @[Decoder.scala 48:85 49:13]
  assign io_targets_0_wen = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 & io_initiator_wen; // @[Decoder.scala 48:85 50:11]
  assign io_targets_0_wdata = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 ? io_initiator_wdata
     : 32'hdeadbeef; // @[Decoder.scala 48:85 51:13]
  assign io_targets_1_raddr = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000000 ? _raddr_T_3 : 32'h0
    ; // @[Decoder.scala 41:85 42:13]
  assign io_targets_1_ren = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000000 & io_initiator_ren; // @[Decoder.scala 41:85 43:11]
  assign io_targets_1_waddr = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000000 ? _waddr_T_3 : 32'h0
    ; // @[Decoder.scala 48:85 49:13]
  assign io_targets_1_wen = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000000 & io_initiator_wen; // @[Decoder.scala 48:85 50:11]
  assign io_targets_1_wstrb = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000000 ?
    io_initiator_wstrb : 4'hf; // @[Decoder.scala 48:85 52:13]
  assign io_targets_1_wdata = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000000 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 48:85 51:13]
  assign io_targets_2_wen = 32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 & io_initiator_wen; // @[Decoder.scala 48:85 50:11]
  assign io_targets_2_wdata = 32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 48:85 51:13]
  assign io_targets_3_raddr = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? _raddr_T_7 : 32'h0
    ; // @[Decoder.scala 41:85 42:13]
  assign io_targets_3_ren = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 & io_initiator_ren; // @[Decoder.scala 41:85 43:11]
  assign io_targets_3_waddr = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 ? _waddr_T_7 : 32'h0
    ; // @[Decoder.scala 48:85 49:13]
  assign io_targets_3_wen = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 & io_initiator_wen; // @[Decoder.scala 48:85 50:11]
  assign io_targets_3_wdata = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 48:85 51:13]
  assign io_targets_4_raddr = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? _raddr_T_9 : 32'h0
    ; // @[Decoder.scala 41:85 42:13]
  assign io_targets_4_ren = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 & io_initiator_ren; // @[Decoder.scala 41:85 43:11]
  assign io_targets_4_waddr = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 ? _waddr_T_9 : 32'h0
    ; // @[Decoder.scala 48:85 49:13]
  assign io_targets_4_wen = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 & io_initiator_wen; // @[Decoder.scala 48:85 50:11]
  assign io_targets_4_wdata = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 48:85 51:13]
  assign io_targets_5_raddr = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 ? _raddr_T_11 : 32'h0
    ; // @[Decoder.scala 41:85 42:13]
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
  output [31:0]  io_debugSignals_core_csr_rdata,
  output [31:0]  io_debugSignals_core_mem_reg_csr_addr,
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
  output [255:0] io_debugSignals_sram1_rdata,
  output [255:0] io_debugSignals_sram1_wdata,
  output         io_debugSignals_sram2_en,
  output [31:0]  io_debugSignals_sram2_we,
  output [6:0]   io_debugSignals_sram2_addr,
  output [255:0] io_debugSignals_sram2_rdata,
  output [255:0] io_debugSignals_sram2_wdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  core_clock; // @[Top.scala 70:20]
  wire  core_reset; // @[Top.scala 70:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 70:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 70:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 70:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 70:20]
  wire  core_io_dmem_ren; // @[Top.scala 70:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 70:20]
  wire  core_io_dmem_rready; // @[Top.scala 70:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 70:20]
  wire  core_io_dmem_wen; // @[Top.scala 70:20]
  wire  core_io_dmem_wready; // @[Top.scala 70:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 70:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 70:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 70:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 70:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 70:20]
  wire  core_io_mtimer_mem_rvalid; // @[Top.scala 70:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 70:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 70:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 70:20]
  wire  core_io_intr; // @[Top.scala 70:20]
  wire  core_io_exit; // @[Top.scala 70:20]
  wire [31:0] core_io_debug_signal_mem_reg_pc; // @[Top.scala 70:20]
  wire [31:0] core_io_debug_signal_csr_rdata; // @[Top.scala 70:20]
  wire [31:0] core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 70:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 70:20]
  wire [63:0] core_io_debug_signal_cycle_counter; // @[Top.scala 70:20]
  wire [63:0] core_io_debug_signal_instret; // @[Top.scala 70:20]
  wire  memory_clock; // @[Top.scala 72:22]
  wire  memory_reset; // @[Top.scala 72:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 72:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 72:22]
  wire [31:0] memory_io_dmem_raddr; // @[Top.scala 72:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 72:22]
  wire  memory_io_dmem_ren; // @[Top.scala 72:22]
  wire  memory_io_dmem_rvalid; // @[Top.scala 72:22]
  wire  memory_io_dmem_rready; // @[Top.scala 72:22]
  wire [31:0] memory_io_dmem_waddr; // @[Top.scala 72:22]
  wire  memory_io_dmem_wen; // @[Top.scala 72:22]
  wire  memory_io_dmem_wready; // @[Top.scala 72:22]
  wire [3:0] memory_io_dmem_wstrb; // @[Top.scala 72:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 72:22]
  wire [8:0] memory_io_imemReadPort_address; // @[Top.scala 72:22]
  wire [31:0] memory_io_imemReadPort_data; // @[Top.scala 72:22]
  wire  memory_io_dramPort_ren; // @[Top.scala 72:22]
  wire  memory_io_dramPort_wen; // @[Top.scala 72:22]
  wire [27:0] memory_io_dramPort_addr; // @[Top.scala 72:22]
  wire [127:0] memory_io_dramPort_wdata; // @[Top.scala 72:22]
  wire  memory_io_dramPort_init_calib_complete; // @[Top.scala 72:22]
  wire [127:0] memory_io_dramPort_rdata; // @[Top.scala 72:22]
  wire  memory_io_dramPort_rdata_valid; // @[Top.scala 72:22]
  wire  memory_io_dramPort_busy; // @[Top.scala 72:22]
  wire  memory_io_cache_array1_en; // @[Top.scala 72:22]
  wire [31:0] memory_io_cache_array1_we; // @[Top.scala 72:22]
  wire [6:0] memory_io_cache_array1_addr; // @[Top.scala 72:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[Top.scala 72:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[Top.scala 72:22]
  wire  memory_io_cache_array2_en; // @[Top.scala 72:22]
  wire [31:0] memory_io_cache_array2_we; // @[Top.scala 72:22]
  wire [6:0] memory_io_cache_array2_addr; // @[Top.scala 72:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[Top.scala 72:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[Top.scala 72:22]
  wire  imem_dbus_clock; // @[Top.scala 73:25]
  wire  imem_dbus_reset; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_mem_raddr; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_mem_rdata; // @[Top.scala 73:25]
  wire  imem_dbus_io_mem_ren; // @[Top.scala 73:25]
  wire  imem_dbus_io_mem_rvalid; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_mem_waddr; // @[Top.scala 73:25]
  wire  imem_dbus_io_mem_wen; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_mem_wdata; // @[Top.scala 73:25]
  wire [8:0] imem_dbus_io_read_address; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_read_data; // @[Top.scala 73:25]
  wire  imem_dbus_io_read_enable; // @[Top.scala 73:25]
  wire [8:0] imem_dbus_io_write_address; // @[Top.scala 73:25]
  wire [31:0] imem_dbus_io_write_data; // @[Top.scala 73:25]
  wire  imem_dbus_io_write_enable; // @[Top.scala 73:25]
  wire  sram1_clock; // @[Top.scala 74:21]
  wire  sram1_en; // @[Top.scala 74:21]
  wire [31:0] sram1_we; // @[Top.scala 74:21]
  wire [6:0] sram1_addr; // @[Top.scala 74:21]
  wire [255:0] sram1_wdata; // @[Top.scala 74:21]
  wire [255:0] sram1_rdata; // @[Top.scala 74:21]
  wire  sram2_clock; // @[Top.scala 75:21]
  wire  sram2_en; // @[Top.scala 75:21]
  wire [31:0] sram2_we; // @[Top.scala 75:21]
  wire [6:0] sram2_addr; // @[Top.scala 75:21]
  wire [255:0] sram2_wdata; // @[Top.scala 75:21]
  wire [255:0] sram2_rdata; // @[Top.scala 75:21]
  wire  gpio_clock; // @[Top.scala 76:20]
  wire  gpio_reset; // @[Top.scala 76:20]
  wire  gpio_io_mem_wen; // @[Top.scala 76:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 76:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 76:20]
  wire  uart_clock; // @[Top.scala 77:20]
  wire  uart_reset; // @[Top.scala 77:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 77:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 77:20]
  wire  uart_io_mem_ren; // @[Top.scala 77:20]
  wire  uart_io_mem_rvalid; // @[Top.scala 77:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 77:20]
  wire  uart_io_mem_wen; // @[Top.scala 77:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 77:20]
  wire  uart_io_intr; // @[Top.scala 77:20]
  wire  uart_io_tx; // @[Top.scala 77:20]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 78:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 78:22]
  wire [31:0] decoder_io_initiator_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_initiator_rdata; // @[Top.scala 80:23]
  wire  decoder_io_initiator_ren; // @[Top.scala 80:23]
  wire  decoder_io_initiator_rvalid; // @[Top.scala 80:23]
  wire  decoder_io_initiator_rready; // @[Top.scala 80:23]
  wire [31:0] decoder_io_initiator_waddr; // @[Top.scala 80:23]
  wire  decoder_io_initiator_wen; // @[Top.scala 80:23]
  wire  decoder_io_initiator_wready; // @[Top.scala 80:23]
  wire [3:0] decoder_io_initiator_wstrb; // @[Top.scala 80:23]
  wire [31:0] decoder_io_initiator_wdata; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_0_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_0_rdata; // @[Top.scala 80:23]
  wire  decoder_io_targets_0_ren; // @[Top.scala 80:23]
  wire  decoder_io_targets_0_rvalid; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_0_waddr; // @[Top.scala 80:23]
  wire  decoder_io_targets_0_wen; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_0_wdata; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_1_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_1_rdata; // @[Top.scala 80:23]
  wire  decoder_io_targets_1_ren; // @[Top.scala 80:23]
  wire  decoder_io_targets_1_rvalid; // @[Top.scala 80:23]
  wire  decoder_io_targets_1_rready; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_1_waddr; // @[Top.scala 80:23]
  wire  decoder_io_targets_1_wen; // @[Top.scala 80:23]
  wire  decoder_io_targets_1_wready; // @[Top.scala 80:23]
  wire [3:0] decoder_io_targets_1_wstrb; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_1_wdata; // @[Top.scala 80:23]
  wire  decoder_io_targets_2_wen; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_2_wdata; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_3_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_3_rdata; // @[Top.scala 80:23]
  wire  decoder_io_targets_3_ren; // @[Top.scala 80:23]
  wire  decoder_io_targets_3_rvalid; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_3_waddr; // @[Top.scala 80:23]
  wire  decoder_io_targets_3_wen; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_3_wdata; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_4_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_4_rdata; // @[Top.scala 80:23]
  wire  decoder_io_targets_4_ren; // @[Top.scala 80:23]
  wire  decoder_io_targets_4_rvalid; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_4_waddr; // @[Top.scala 80:23]
  wire  decoder_io_targets_4_wen; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_4_wdata; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_5_raddr; // @[Top.scala 80:23]
  wire [31:0] decoder_io_targets_5_rdata; // @[Top.scala 80:23]
  reg [31:0] imem [0:511]; // @[Top.scala 105:17]
  wire  imem_imem_rdata_MPORT_en; // @[Top.scala 105:17]
  wire [8:0] imem_imem_rdata_MPORT_addr; // @[Top.scala 105:17]
  wire [31:0] imem_imem_rdata_MPORT_data; // @[Top.scala 105:17]
  wire  imem_imem_rdata2_MPORT_en; // @[Top.scala 105:17]
  wire [8:0] imem_imem_rdata2_MPORT_addr; // @[Top.scala 105:17]
  wire [31:0] imem_imem_rdata2_MPORT_data; // @[Top.scala 105:17]
  wire [31:0] imem_MPORT_data; // @[Top.scala 105:17]
  wire [8:0] imem_MPORT_addr; // @[Top.scala 105:17]
  wire  imem_MPORT_mask; // @[Top.scala 105:17]
  wire  imem_MPORT_en; // @[Top.scala 105:17]
  reg [31:0] imem_rdata; // @[Top.scala 95:27]
  reg [31:0] imem_rdata2; // @[Top.scala 96:28]
  wire [31:0] _GEN_3 = imem_imem_rdata_MPORT_data; // @[Top.scala 107:40 108:16 95:27]
  wire  _T = ~imem_dbus_io_write_enable; // @[Top.scala 114:9]
  Core core ( // @[Top.scala 70:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
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
    .io_debug_signal_csr_rdata(core_io_debug_signal_csr_rdata),
    .io_debug_signal_mem_reg_csr_addr(core_io_debug_signal_mem_reg_csr_addr),
    .io_debug_signal_me_intr(core_io_debug_signal_me_intr),
    .io_debug_signal_cycle_counter(core_io_debug_signal_cycle_counter),
    .io_debug_signal_instret(core_io_debug_signal_instret)
  );
  Memory memory ( // @[Top.scala 72:22]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_imem_addr(memory_io_imem_addr),
    .io_imem_inst(memory_io_imem_inst),
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
    .io_imemReadPort_address(memory_io_imemReadPort_address),
    .io_imemReadPort_data(memory_io_imemReadPort_data),
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
    .io_cache_array2_rdata(memory_io_cache_array2_rdata)
  );
  SingleCycleMem imem_dbus ( // @[Top.scala 73:25]
    .clock(imem_dbus_clock),
    .reset(imem_dbus_reset),
    .io_mem_raddr(imem_dbus_io_mem_raddr),
    .io_mem_rdata(imem_dbus_io_mem_rdata),
    .io_mem_ren(imem_dbus_io_mem_ren),
    .io_mem_rvalid(imem_dbus_io_mem_rvalid),
    .io_mem_waddr(imem_dbus_io_mem_waddr),
    .io_mem_wen(imem_dbus_io_mem_wen),
    .io_mem_wdata(imem_dbus_io_mem_wdata),
    .io_read_address(imem_dbus_io_read_address),
    .io_read_data(imem_dbus_io_read_data),
    .io_read_enable(imem_dbus_io_read_enable),
    .io_write_address(imem_dbus_io_write_address),
    .io_write_data(imem_dbus_io_write_data),
    .io_write_enable(imem_dbus_io_write_enable)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram1 ( // @[Top.scala 74:21]
    .clock(sram1_clock),
    .en(sram1_en),
    .we(sram1_we),
    .addr(sram1_addr),
    .wdata(sram1_wdata),
    .rdata(sram1_rdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram2 ( // @[Top.scala 75:21]
    .clock(sram2_clock),
    .en(sram2_en),
    .we(sram2_we),
    .addr(sram2_addr),
    .wdata(sram2_wdata),
    .rdata(sram2_rdata)
  );
  Gpio gpio ( // @[Top.scala 76:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 77:20]
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
  Config config_ ( // @[Top.scala 78:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder decoder ( // @[Top.scala 80:23]
    .io_initiator_raddr(decoder_io_initiator_raddr),
    .io_initiator_rdata(decoder_io_initiator_rdata),
    .io_initiator_ren(decoder_io_initiator_ren),
    .io_initiator_rvalid(decoder_io_initiator_rvalid),
    .io_initiator_rready(decoder_io_initiator_rready),
    .io_initiator_waddr(decoder_io_initiator_waddr),
    .io_initiator_wen(decoder_io_initiator_wen),
    .io_initiator_wready(decoder_io_initiator_wready),
    .io_initiator_wstrb(decoder_io_initiator_wstrb),
    .io_initiator_wdata(decoder_io_initiator_wdata),
    .io_targets_0_raddr(decoder_io_targets_0_raddr),
    .io_targets_0_rdata(decoder_io_targets_0_rdata),
    .io_targets_0_ren(decoder_io_targets_0_ren),
    .io_targets_0_rvalid(decoder_io_targets_0_rvalid),
    .io_targets_0_waddr(decoder_io_targets_0_waddr),
    .io_targets_0_wen(decoder_io_targets_0_wen),
    .io_targets_0_wdata(decoder_io_targets_0_wdata),
    .io_targets_1_raddr(decoder_io_targets_1_raddr),
    .io_targets_1_rdata(decoder_io_targets_1_rdata),
    .io_targets_1_ren(decoder_io_targets_1_ren),
    .io_targets_1_rvalid(decoder_io_targets_1_rvalid),
    .io_targets_1_rready(decoder_io_targets_1_rready),
    .io_targets_1_waddr(decoder_io_targets_1_waddr),
    .io_targets_1_wen(decoder_io_targets_1_wen),
    .io_targets_1_wready(decoder_io_targets_1_wready),
    .io_targets_1_wstrb(decoder_io_targets_1_wstrb),
    .io_targets_1_wdata(decoder_io_targets_1_wdata),
    .io_targets_2_wen(decoder_io_targets_2_wen),
    .io_targets_2_wdata(decoder_io_targets_2_wdata),
    .io_targets_3_raddr(decoder_io_targets_3_raddr),
    .io_targets_3_rdata(decoder_io_targets_3_rdata),
    .io_targets_3_ren(decoder_io_targets_3_ren),
    .io_targets_3_rvalid(decoder_io_targets_3_rvalid),
    .io_targets_3_waddr(decoder_io_targets_3_waddr),
    .io_targets_3_wen(decoder_io_targets_3_wen),
    .io_targets_3_wdata(decoder_io_targets_3_wdata),
    .io_targets_4_raddr(decoder_io_targets_4_raddr),
    .io_targets_4_rdata(decoder_io_targets_4_rdata),
    .io_targets_4_ren(decoder_io_targets_4_ren),
    .io_targets_4_rvalid(decoder_io_targets_4_rvalid),
    .io_targets_4_waddr(decoder_io_targets_4_waddr),
    .io_targets_4_wen(decoder_io_targets_4_wen),
    .io_targets_4_wdata(decoder_io_targets_4_wdata),
    .io_targets_5_raddr(decoder_io_targets_5_raddr),
    .io_targets_5_rdata(decoder_io_targets_5_rdata)
  );
  assign imem_imem_rdata_MPORT_en = 1'h1;
  assign imem_imem_rdata_MPORT_addr = memory_io_imemReadPort_address;
  assign imem_imem_rdata_MPORT_data = imem[imem_imem_rdata_MPORT_addr]; // @[Top.scala 105:17]
  assign imem_imem_rdata2_MPORT_en = _T & imem_dbus_io_read_enable;
  assign imem_imem_rdata2_MPORT_addr = imem_dbus_io_write_enable ? imem_dbus_io_write_address :
    imem_dbus_io_read_address;
  assign imem_imem_rdata2_MPORT_data = imem[imem_imem_rdata2_MPORT_addr]; // @[Top.scala 105:17]
  assign imem_MPORT_data = imem_dbus_io_write_data;
  assign imem_MPORT_addr = imem_dbus_io_write_enable ? imem_dbus_io_write_address : imem_dbus_io_read_address;
  assign imem_MPORT_mask = 1'h1;
  assign imem_MPORT_en = imem_dbus_io_write_enable;
  assign io_dram_ren = memory_io_dramPort_ren; // @[Top.scala 123:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[Top.scala 123:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[Top.scala 123:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[Top.scala 123:11]
  assign io_dram_wmask = 16'h0; // @[Top.scala 123:11]
  assign io_dram_user_busy = 1'h0; // @[Top.scala 123:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 167:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 168:14]
  assign io_exit = core_io_exit; // @[Top.scala 166:11]
  assign io_debugSignals_core_mem_reg_pc = core_io_debug_signal_mem_reg_pc; // @[Top.scala 139:24]
  assign io_debugSignals_core_csr_rdata = core_io_debug_signal_csr_rdata; // @[Top.scala 139:24]
  assign io_debugSignals_core_mem_reg_csr_addr = core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 139:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 139:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 139:24]
  assign io_debugSignals_core_instret = core_io_debug_signal_instret; // @[Top.scala 139:24]
  assign io_debugSignals_raddr = core_io_dmem_raddr; // @[Top.scala 140:26]
  assign io_debugSignals_rdata = decoder_io_initiator_rdata; // @[Top.scala 141:26]
  assign io_debugSignals_ren = core_io_dmem_ren; // @[Top.scala 142:26]
  assign io_debugSignals_rvalid = decoder_io_initiator_rvalid; // @[Top.scala 143:26]
  assign io_debugSignals_waddr = core_io_dmem_waddr; // @[Top.scala 144:26]
  assign io_debugSignals_wen = core_io_dmem_wen; // @[Top.scala 146:26]
  assign io_debugSignals_wready = decoder_io_initiator_wready; // @[Top.scala 147:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 148:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 145:26]
  assign io_debugSignals_dram_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 150:44]
  assign io_debugSignals_dram_rdata_valid = io_dram_rdata_valid; // @[Top.scala 151:44]
  assign io_debugSignals_dram_busy = io_dram_busy; // @[Top.scala 152:44]
  assign io_debugSignals_dram_ren = io_dram_ren; // @[Top.scala 153:44]
  assign io_debugSignals_sram1_en = memory_io_cache_array1_en; // @[Top.scala 155:28]
  assign io_debugSignals_sram1_we = memory_io_cache_array1_we; // @[Top.scala 156:28]
  assign io_debugSignals_sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 157:30]
  assign io_debugSignals_sram1_rdata = sram1_rdata; // @[Top.scala 158:31]
  assign io_debugSignals_sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 159:31]
  assign io_debugSignals_sram2_en = memory_io_cache_array2_en; // @[Top.scala 160:28]
  assign io_debugSignals_sram2_we = memory_io_cache_array2_we; // @[Top.scala 161:28]
  assign io_debugSignals_sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 162:30]
  assign io_debugSignals_sram2_rdata = sram2_rdata; // @[Top.scala 163:31]
  assign io_debugSignals_sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 164:31]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = memory_io_imem_inst; // @[Top.scala 118:16]
  assign core_io_dmem_rdata = decoder_io_initiator_rdata; // @[Top.scala 120:16]
  assign core_io_dmem_rvalid = decoder_io_initiator_rvalid; // @[Top.scala 120:16]
  assign core_io_dmem_rready = decoder_io_initiator_rready; // @[Top.scala 120:16]
  assign core_io_dmem_wready = decoder_io_initiator_wready; // @[Top.scala 120:16]
  assign core_io_mtimer_mem_raddr = decoder_io_targets_4_raddr; // @[Top.scala 92:25]
  assign core_io_mtimer_mem_ren = decoder_io_targets_4_ren; // @[Top.scala 92:25]
  assign core_io_mtimer_mem_waddr = decoder_io_targets_4_waddr; // @[Top.scala 92:25]
  assign core_io_mtimer_mem_wen = decoder_io_targets_4_wen; // @[Top.scala 92:25]
  assign core_io_mtimer_mem_wdata = decoder_io_targets_4_wdata; // @[Top.scala 92:25]
  assign core_io_intr = uart_io_intr; // @[Top.scala 169:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_addr = core_io_imem_addr; // @[Top.scala 118:16]
  assign memory_io_dmem_raddr = decoder_io_targets_1_raddr; // @[Top.scala 89:25]
  assign memory_io_dmem_ren = decoder_io_targets_1_ren; // @[Top.scala 89:25]
  assign memory_io_dmem_waddr = decoder_io_targets_1_waddr; // @[Top.scala 89:25]
  assign memory_io_dmem_wen = decoder_io_targets_1_wen; // @[Top.scala 89:25]
  assign memory_io_dmem_wstrb = decoder_io_targets_1_wstrb; // @[Top.scala 89:25]
  assign memory_io_dmem_wdata = decoder_io_targets_1_wdata; // @[Top.scala 89:25]
  assign memory_io_imemReadPort_data = imem_rdata; // @[Top.scala 97:31]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 123:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[Top.scala 123:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[Top.scala 123:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[Top.scala 123:11]
  assign memory_io_cache_array1_rdata = sram1_rdata; // @[Top.scala 130:32]
  assign memory_io_cache_array2_rdata = sram2_rdata; // @[Top.scala 136:32]
  assign imem_dbus_clock = clock;
  assign imem_dbus_reset = reset;
  assign imem_dbus_io_mem_raddr = decoder_io_targets_0_raddr; // @[Top.scala 88:25]
  assign imem_dbus_io_mem_ren = decoder_io_targets_0_ren; // @[Top.scala 88:25]
  assign imem_dbus_io_mem_waddr = decoder_io_targets_0_waddr; // @[Top.scala 88:25]
  assign imem_dbus_io_mem_wen = decoder_io_targets_0_wen; // @[Top.scala 88:25]
  assign imem_dbus_io_mem_wdata = decoder_io_targets_0_wdata; // @[Top.scala 88:25]
  assign imem_dbus_io_read_data = imem_rdata2; // @[Top.scala 98:26]
  assign sram1_clock = clock; // @[Top.scala 125:18]
  assign sram1_en = memory_io_cache_array1_en; // @[Top.scala 126:15]
  assign sram1_we = memory_io_cache_array1_we; // @[Top.scala 127:15]
  assign sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 128:17]
  assign sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 129:18]
  assign sram2_clock = clock; // @[Top.scala 131:18]
  assign sram2_en = memory_io_cache_array2_en; // @[Top.scala 132:15]
  assign sram2_we = memory_io_cache_array2_we; // @[Top.scala 133:15]
  assign sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 134:17]
  assign sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 135:18]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = decoder_io_targets_2_wen; // @[Top.scala 90:25]
  assign gpio_io_mem_wdata = decoder_io_targets_2_wdata; // @[Top.scala 90:25]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = decoder_io_targets_3_raddr; // @[Top.scala 91:25]
  assign uart_io_mem_ren = decoder_io_targets_3_ren; // @[Top.scala 91:25]
  assign uart_io_mem_waddr = decoder_io_targets_3_waddr; // @[Top.scala 91:25]
  assign uart_io_mem_wen = decoder_io_targets_3_wen; // @[Top.scala 91:25]
  assign uart_io_mem_wdata = decoder_io_targets_3_wdata; // @[Top.scala 91:25]
  assign config__io_mem_raddr = decoder_io_targets_5_raddr; // @[Top.scala 93:25]
  assign decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 120:16]
  assign decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 120:16]
  assign decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 120:16]
  assign decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 120:16]
  assign decoder_io_initiator_wstrb = core_io_dmem_wstrb; // @[Top.scala 120:16]
  assign decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 120:16]
  assign decoder_io_targets_0_rdata = imem_dbus_io_mem_rdata; // @[Top.scala 88:25]
  assign decoder_io_targets_0_rvalid = imem_dbus_io_mem_rvalid; // @[Top.scala 88:25]
  assign decoder_io_targets_1_rdata = memory_io_dmem_rdata; // @[Top.scala 89:25]
  assign decoder_io_targets_1_rvalid = memory_io_dmem_rvalid; // @[Top.scala 89:25]
  assign decoder_io_targets_1_rready = memory_io_dmem_rready; // @[Top.scala 89:25]
  assign decoder_io_targets_1_wready = memory_io_dmem_wready; // @[Top.scala 89:25]
  assign decoder_io_targets_3_rdata = uart_io_mem_rdata; // @[Top.scala 91:25]
  assign decoder_io_targets_3_rvalid = uart_io_mem_rvalid; // @[Top.scala 91:25]
  assign decoder_io_targets_4_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 92:25]
  assign decoder_io_targets_4_rvalid = core_io_mtimer_mem_rvalid; // @[Top.scala 92:25]
  assign decoder_io_targets_5_rdata = config__io_mem_rdata; // @[Top.scala 93:25]
  always @(posedge clock) begin
    if (imem_MPORT_en & imem_MPORT_mask) begin
      imem[imem_MPORT_addr] <= imem_MPORT_data; // @[Top.scala 105:17]
    end
    if (reset) begin // @[Top.scala 95:27]
      imem_rdata <= 32'h0; // @[Top.scala 95:27]
    end else begin
      imem_rdata <= _GEN_3;
    end
    if (reset) begin // @[Top.scala 96:28]
      imem_rdata2 <= 32'h0; // @[Top.scala 96:28]
    end else if (~imem_dbus_io_write_enable & imem_dbus_io_read_enable) begin // @[Top.scala 114:65]
      imem_rdata2 <= imem_imem_rdata2_MPORT_data; // @[Top.scala 115:17]
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
  imem_rdata = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  imem_rdata2 = _RAND_1[31:0];
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
