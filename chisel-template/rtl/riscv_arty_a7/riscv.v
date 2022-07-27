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
  wire [63:0] _GEN_6 = io_mem_waddr == 32'hc ? _mtimecmp_T_3 : mtimecmp; // @[MachineTimer.scala 48:40 49:16 15:25]
  wire [63:0] _GEN_7 = io_mem_waddr == 32'h8 ? _mtimecmp_T_1 : _GEN_6; // @[MachineTimer.scala 46:39 47:16]
  assign io_mem_rdata = io_mem_ren ? _GEN_3 : 32'h0; // @[MachineTimer.scala 23:21 37:18]
  assign io_mem_rvalid = io_mem_ren; // @[MachineTimer.scala 23:21 35:19 38:19]
  assign io_intr = intr; // @[MachineTimer.scala 20:11]
  assign io_mtime = mtime; // @[MachineTimer.scala 21:12]
  always @(posedge clock) begin
    if (reset) begin // @[MachineTimer.scala 14:22]
      mtime <= 64'h0; // @[MachineTimer.scala 14:22]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 41:21]
      if (io_mem_waddr == 32'h0) begin // @[MachineTimer.scala 42:33]
        mtime <= _mtime_T_3; // @[MachineTimer.scala 43:13]
      end else if (io_mem_waddr == 32'h4) begin // @[MachineTimer.scala 44:39]
        mtime <= _mtime_T_5; // @[MachineTimer.scala 45:13]
      end else begin
        mtime <= _mtime_T_1; // @[MachineTimer.scala 18:9]
      end
    end else begin
      mtime <= _mtime_T_1; // @[MachineTimer.scala 18:9]
    end
    if (reset) begin // @[MachineTimer.scala 15:25]
      mtimecmp <= 64'hffffffff; // @[MachineTimer.scala 15:25]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 41:21]
      if (!(io_mem_waddr == 32'h0)) begin // @[MachineTimer.scala 42:33]
        if (!(io_mem_waddr == 32'h4)) begin // @[MachineTimer.scala 44:39]
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
  output [31:0] io_dmem_waddr,
  output        io_dmem_wen,
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
  output [31:0] io_debug_signal_id_reg_inst,
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
  wire  bp_clock; // @[Core.scala 231:18]
  wire  bp_reset; // @[Core.scala 231:18]
  wire [31:0] bp_io_lu_inst_pc; // @[Core.scala 231:18]
  wire  bp_io_lu_br_hit; // @[Core.scala 231:18]
  wire  bp_io_lu_br_pos; // @[Core.scala 231:18]
  wire [31:0] bp_io_lu_br_addr; // @[Core.scala 231:18]
  wire  bp_io_up_update_en; // @[Core.scala 231:18]
  wire [31:0] bp_io_up_inst_pc; // @[Core.scala 231:18]
  wire  bp_io_up_br_pos; // @[Core.scala 231:18]
  wire [31:0] bp_io_up_br_addr; // @[Core.scala 231:18]
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
  reg  ex1_reg_is_bp_pos; // @[Core.scala 106:39]
  reg [31:0] ex1_reg_bp_addr; // @[Core.scala 107:39]
  reg  ex1_reg_is_half; // @[Core.scala 108:39]
  reg  ex1_reg_is_valid_inst; // @[Core.scala 109:39]
  reg  ex1_reg_is_trap; // @[Core.scala 110:39]
  reg [31:0] ex1_reg_mcause; // @[Core.scala 111:39]
  reg [31:0] ex2_reg_pc; // @[Core.scala 115:38]
  reg [4:0] ex2_reg_wb_addr; // @[Core.scala 116:38]
  reg [31:0] ex2_reg_op1_data; // @[Core.scala 117:38]
  reg [31:0] ex2_reg_op2_data; // @[Core.scala 118:38]
  reg [31:0] ex2_reg_rs2_data; // @[Core.scala 119:38]
  reg [4:0] ex2_reg_exe_fun; // @[Core.scala 120:38]
  reg [1:0] ex2_reg_mem_wen; // @[Core.scala 121:38]
  reg [1:0] ex2_reg_rf_wen; // @[Core.scala 122:38]
  reg [2:0] ex2_reg_wb_sel; // @[Core.scala 123:38]
  reg [11:0] ex2_reg_csr_addr; // @[Core.scala 124:38]
  reg [2:0] ex2_reg_csr_cmd; // @[Core.scala 125:38]
  reg [31:0] ex2_reg_imm_b_sext; // @[Core.scala 126:38]
  reg [31:0] ex2_reg_mem_w; // @[Core.scala 127:38]
  reg  ex2_reg_is_bp_pos; // @[Core.scala 128:38]
  reg [31:0] ex2_reg_bp_addr; // @[Core.scala 129:38]
  reg  ex2_reg_is_half; // @[Core.scala 130:38]
  reg  ex2_reg_is_valid_inst; // @[Core.scala 131:38]
  reg  ex2_reg_is_trap; // @[Core.scala 132:38]
  reg [31:0] ex2_reg_mcause; // @[Core.scala 133:38]
  reg  ex3_reg_bp_en; // @[Core.scala 137:41]
  reg [31:0] ex3_reg_pc; // @[Core.scala 138:41]
  reg  ex3_reg_is_cond_br; // @[Core.scala 139:41]
  reg  ex3_reg_is_cond_br_inst; // @[Core.scala 140:41]
  reg  ex3_reg_is_uncond_br; // @[Core.scala 141:41]
  reg [31:0] ex3_reg_cond_br_target; // @[Core.scala 142:41]
  reg [31:0] ex3_reg_uncond_br_target; // @[Core.scala 143:41]
  reg  ex3_reg_is_bp_pos; // @[Core.scala 144:41]
  reg [31:0] ex3_reg_bp_addr; // @[Core.scala 145:41]
  reg  ex3_reg_is_half; // @[Core.scala 146:41]
  reg  mem_reg_en; // @[Core.scala 149:38]
  reg [31:0] mem_reg_pc; // @[Core.scala 150:38]
  reg [4:0] mem_reg_wb_addr; // @[Core.scala 151:38]
  reg [31:0] mem_reg_op1_data; // @[Core.scala 152:38]
  reg [31:0] mem_reg_rs2_data; // @[Core.scala 153:38]
  reg [1:0] mem_reg_mem_wen; // @[Core.scala 154:38]
  reg [1:0] mem_reg_rf_wen; // @[Core.scala 155:38]
  reg [2:0] mem_reg_wb_sel; // @[Core.scala 156:38]
  reg [11:0] mem_reg_csr_addr; // @[Core.scala 157:38]
  reg [2:0] mem_reg_csr_cmd; // @[Core.scala 158:38]
  reg [31:0] mem_reg_alu_out; // @[Core.scala 160:38]
  reg [31:0] mem_reg_mem_w; // @[Core.scala 161:38]
  reg [3:0] mem_reg_mem_wstrb; // @[Core.scala 162:38]
  reg  mem_reg_is_half; // @[Core.scala 163:38]
  reg  mem_reg_is_valid_inst; // @[Core.scala 164:38]
  reg  mem_reg_is_trap; // @[Core.scala 165:38]
  reg [31:0] mem_reg_mcause; // @[Core.scala 166:38]
  reg [4:0] wb_reg_wb_addr; // @[Core.scala 170:38]
  reg [1:0] wb_reg_rf_wen; // @[Core.scala 171:38]
  reg [31:0] wb_reg_wb_data; // @[Core.scala 172:38]
  reg  wb_reg_is_valid_inst; // @[Core.scala 173:38]
  reg  if2_reg_is_bp_pos; // @[Core.scala 175:35]
  reg [31:0] if2_reg_bp_addr; // @[Core.scala 176:35]
  reg  if2_reg_is_uncond_br; // @[Core.scala 179:39]
  reg [31:0] if2_reg_uncond_br_addr; // @[Core.scala 180:39]
  reg  ex3_reg_is_br; // @[Core.scala 184:35]
  reg [31:0] ex3_reg_br_target; // @[Core.scala 185:35]
  reg  mem_reg_is_br; // @[Core.scala 186:35]
  reg [31:0] mem_reg_br_addr; // @[Core.scala 187:35]
  reg  ic_reg_read_rdy; // @[Core.scala 196:32]
  reg  ic_reg_half_rdy; // @[Core.scala 197:32]
  reg [31:0] ic_reg_addr_out; // @[Core.scala 199:32]
  reg [15:0] ic_reg_half; // @[Core.scala 203:33]
  wire  _ic_read_en2_T = ~id_reg_stall; // @[Core.scala 267:18]
  wire  _ic_data_out_T_2 = ic_reg_addr_out[1] & ic_reg_read_rdy; // @[Core.scala 224:32]
  wire [31:0] _ic_data_out_T_4 = {io_imem_inst[15:0],ic_reg_half}; // @[Cat.scala 31:58]
  wire  _ic_data_out_T_7 = ~ic_reg_read_rdy; // @[Core.scala 225:35]
  wire  _ic_data_out_T_8 = ic_reg_addr_out[1] & ~ic_reg_read_rdy; // @[Core.scala 225:32]
  wire [31:0] _ic_data_out_T_11 = {16'h0,io_imem_inst[31:16]}; // @[Cat.scala 31:58]
  wire [31:0] _ic_data_out_T_12 = _ic_data_out_T_8 ? _ic_data_out_T_11 : io_imem_inst; // @[Mux.scala 101:16]
  wire [31:0] ic_data_out = _ic_data_out_T_2 ? _ic_data_out_T_4 : _ic_data_out_T_12; // @[Mux.scala 101:16]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 266:41]
  wire  ic_read_en2 = ~id_reg_stall & is_half_inst; // @[Core.scala 267:32]
  wire  _ic_next_addr_T_1 = (ic_reg_half_rdy | ic_reg_read_rdy) & ic_read_en2; // @[Core.scala 207:43]
  wire [31:0] _ic_next_addr_T_3 = ic_reg_addr_out + 32'h2; // @[Core.scala 207:79]
  wire  ic_read_en4 = _ic_read_en2_T & ~is_half_inst; // @[Core.scala 268:32]
  wire  _ic_next_addr_T_4 = ic_reg_read_rdy & ic_read_en4; // @[Core.scala 208:22]
  wire [31:0] _ic_next_addr_T_6 = ic_reg_addr_out + 32'h4; // @[Core.scala 208:58]
  wire [31:0] _ic_next_addr_T_7 = _ic_next_addr_T_4 ? _ic_next_addr_T_6 : ic_reg_addr_out; // @[Mux.scala 101:16]
  wire [31:0] _ic_next_addr_T_8 = _ic_next_addr_T_1 ? _ic_next_addr_T_3 : _ic_next_addr_T_7; // @[Mux.scala 101:16]
  wire  _if1_is_jump_T = mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 246:35]
  reg  if1_reg_first; // @[Core.scala 236:30]
  wire  if1_is_jump = mem_reg_is_br | ex3_reg_is_br | if2_reg_is_bp_pos | if2_reg_is_uncond_br | if1_reg_first; // @[Core.scala 246:97]
  wire [31:0] _if1_jump_addr_T = if1_reg_first ? 32'h8000000 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_1 = if2_reg_is_uncond_br ? if2_reg_uncond_br_addr : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_2 = if2_reg_is_bp_pos ? if2_reg_bp_addr : _if1_jump_addr_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if1_jump_addr_T_3 = ex3_reg_is_br ? ex3_reg_br_target : _if1_jump_addr_T_2; // @[Mux.scala 101:16]
  wire [31:0] if1_jump_addr = mem_reg_is_br ? mem_reg_br_addr : _if1_jump_addr_T_3; // @[Mux.scala 101:16]
  wire [31:0] ic_next_addr = if1_is_jump ? if1_jump_addr : _ic_next_addr_T_8; // @[Mux.scala 101:16]
  wire  ic_fill_half = if1_is_jump & if1_jump_addr[1]; // @[Core.scala 210:33]
  wire [31:0] _ic_mem_addr_T_2 = {ic_next_addr[31:2],2'h0}; // @[Cat.scala 31:58]
  wire [31:0] _ic_mem_addr_T_4 = ic_next_addr + 32'h2; // @[Core.scala 213:23]
  wire [31:0] _ic_mem_addr_T_7 = {_ic_mem_addr_T_4[31:2],2'h0}; // @[Cat.scala 31:58]
  wire  _ic_reg_half_T_2 = _ic_data_out_T_7 | ic_read_en2 | ic_read_en4; // @[Core.scala 221:38]
  reg [31:0] if1_reg_next_pc; // @[Core.scala 251:32]
  wire [31:0] if1_next_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 252:24]
  wire [31:0] if1_next_pc_4 = if1_next_pc + 32'h4; // @[Core.scala 253:35]
  reg [31:0] if2_reg_pc; // @[Core.scala 263:29]
  reg [31:0] if2_reg_inst; // @[Core.scala 264:29]
  wire  _if2_pc_T = ic_reg_half_rdy & is_half_inst; // @[Core.scala 269:74]
  wire [31:0] if2_pc = id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst) ? if2_reg_pc : ic_reg_addr_out
    ; // @[Core.scala 269:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_reg_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = if2_reg_is_uncond_br ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = if2_reg_is_bp_pos ? 32'h13 : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = id_reg_stall ? if2_reg_inst : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_6 = mem_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex3_reg_is_br ? 32'h13 : _if2_inst_T_6; // @[Mux.scala 101:16]
  wire  if2_is_cond_br_w = if2_inst[6:0] == 7'h63; // @[Core.scala 285:42]
  wire  _if2_is_cond_br_c_T_3 = if2_inst[1:0] == 2'h1; // @[Core.scala 286:70]
  wire  if2_is_cond_br_c = if2_inst[15:14] == 2'h3 & if2_inst[1:0] == 2'h1; // @[Core.scala 286:52]
  wire  if2_is_cond_br = if2_is_cond_br_w | if2_is_cond_br_c; // @[Core.scala 287:41]
  wire  if2_is_jal_w = if2_inst[6:0] == 7'h6f; // @[Core.scala 288:38]
  wire  if2_is_jal_c = if2_inst[14:13] == 2'h1 & _if2_is_cond_br_c_T_3; // @[Core.scala 289:48]
  wire  if2_is_jal = if2_is_jal_w | if2_is_jal_c; // @[Core.scala 290:33]
  wire  if2_is_jalr = if2_inst[6:0] == 7'h67 | if2_inst[15:13] == 3'h4 & if2_inst[6:0] == 7'h2; // @[Core.scala 291:50]
  wire  if2_is_bp_br = if2_is_cond_br | if2_is_jalr; // @[Core.scala 292:37]
  wire [19:0] _if2_w_imm_b_T_2 = if2_inst[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_w_imm_b = {_if2_w_imm_b_T_2,if2_inst[7],if2_inst[30:25],if2_inst[11:8],1'h0}; // @[Cat.scala 31:58]
  wire [23:0] _if2_c_imm_b_T_2 = if2_inst[12] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_c_imm_b = {_if2_c_imm_b_T_2,if2_inst[6:5],if2_inst[2],if2_inst[11:10],if2_inst[4:3],1'h0}; // @[Cat.scala 31:58]
  wire [11:0] _if2_w_imm_j_T_2 = if2_inst[31] ? 12'hfff : 12'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_w_imm_j = {_if2_w_imm_j_T_2,if2_inst[19:12],if2_inst[20],if2_inst[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [20:0] _if2_c_imm_j_T_2 = if2_inst[12] ? 21'h1fffff : 21'h0; // @[Bitwise.scala 74:12]
  wire [31:0] if2_c_imm_j = {_if2_c_imm_j_T_2,if2_inst[8],if2_inst[10:9],if2_inst[6],if2_inst[7],if2_inst[2],if2_inst[11
    ],if2_inst[5:3],1'h0}; // @[Cat.scala 31:58]
  wire [31:0] if2_imm_b_sext = if2_is_cond_br_w ? if2_w_imm_b : if2_c_imm_b; // @[Core.scala 297:27]
  wire [31:0] if2_imm_j_sext = if2_is_jal_w ? if2_w_imm_j : if2_c_imm_j; // @[Core.scala 298:27]
  wire [31:0] if2_jal_addr = if2_pc + if2_imm_j_sext; // @[Core.scala 304:29]
  wire  _if2_is_bp_pos_T = if2_is_bp_br & bp_io_lu_br_pos; // @[Core.scala 312:19]
  wire  _if2_is_bp_pos_T_1 = ~bp_io_lu_br_hit; // @[Core.scala 313:26]
  wire  _if2_is_bp_pos_T_5 = if2_is_cond_br & ~bp_io_lu_br_hit & if2_imm_b_sext[31]; // @[Core.scala 313:43]
  wire  _if2_is_bp_pos_T_6 = if2_is_bp_br & bp_io_lu_br_pos | _if2_is_bp_pos_T_5; // @[Core.scala 312:39]
  wire [31:0] if2_cond_br_addr = if2_pc + if2_imm_b_sext; // @[Core.scala 316:33]
  wire  _if2_bp_addr_T_2 = _if2_is_bp_pos_T_1 & if2_is_cond_br; // @[Core.scala 320:23]
  wire [31:0] _if2_bp_addr_T_3 = _if2_bp_addr_T_2 ? if2_cond_br_addr : 32'h0; // @[Mux.scala 101:16]
  wire  _T_1 = ~reset; // @[Core.scala 324:9]
  reg  ex1_reg_hazard; // @[Core.scala 731:38]
  wire  _ex1_stall_T = ex1_reg_op1_sel == 3'h0; // @[Core.scala 745:23]
  wire  _ex1_stall_T_1 = ex1_reg_hazard & _ex1_stall_T; // @[Core.scala 744:21]
  wire  _ex1_stall_T_2 = ex1_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 746:24]
  wire  _ex1_stall_T_3 = _ex1_stall_T_1 & _ex1_stall_T_2; // @[Core.scala 745:36]
  reg  ex2_reg_hazard; // @[Core.scala 734:38]
  wire  _ex1_stall_T_5 = ex2_reg_hazard & _ex1_stall_T; // @[Core.scala 747:21]
  wire  _ex1_stall_T_6 = ex1_reg_rs1_addr == mem_reg_wb_addr; // @[Core.scala 749:24]
  wire  _ex1_stall_T_7 = _ex1_stall_T_5 & _ex1_stall_T_6; // @[Core.scala 748:36]
  wire  _ex1_stall_T_8 = _ex1_stall_T_3 | _ex1_stall_T_7; // @[Core.scala 746:46]
  wire  _ex1_stall_T_9 = ex1_reg_op2_sel == 4'h1; // @[Core.scala 751:23]
  wire  _ex1_stall_T_11 = ex1_reg_op2_sel == 4'h1 | ex1_reg_mem_wen == 2'h1; // @[Core.scala 751:35]
  wire  _ex1_stall_T_12 = ex1_reg_hazard & _ex1_stall_T_11; // @[Core.scala 750:21]
  wire  _ex1_stall_T_13 = ex1_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 752:24]
  wire  _ex1_stall_T_14 = _ex1_stall_T_12 & _ex1_stall_T_13; // @[Core.scala 751:65]
  wire  _ex1_stall_T_15 = _ex1_stall_T_8 | _ex1_stall_T_14; // @[Core.scala 749:46]
  wire  _ex1_stall_T_19 = ex2_reg_hazard & _ex1_stall_T_11; // @[Core.scala 753:21]
  wire  _ex1_stall_T_20 = ex1_reg_rs2_addr == mem_reg_wb_addr; // @[Core.scala 755:24]
  wire  _ex1_stall_T_21 = _ex1_stall_T_19 & _ex1_stall_T_20; // @[Core.scala 754:65]
  wire  ex1_stall = _ex1_stall_T_15 | _ex1_stall_T_21; // @[Core.scala 752:46]
  reg  mem_stall_delay; // @[Core.scala 970:32]
  wire  mem_stall = io_dmem_ren & (~io_dmem_rvalid | mem_stall_delay); // @[Core.scala 978:28]
  wire  id_stall = ex1_stall | mem_stall; // @[Core.scala 345:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 349:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 351:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 353:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 354:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 355:30]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 359:18]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 362:18]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 366:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 31:58]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 31:58]
  wire  _id_c_rs1_data_T = id_w_wb_addr == 5'h0; // @[Core.scala 374:20]
  wire [31:0] id_c_rs1_data = _id_c_rs1_data_T ? 32'h0 : regfile_id_c_rs1_data_MPORT_data; // @[Mux.scala 101:16]
  wire  _id_c_rs2_data_T = id_c_rs2_addr == 5'h0; // @[Core.scala 377:20]
  wire [31:0] id_c_rs2_data = _id_c_rs2_data_T ? 32'h0 : regfile_id_c_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 383:25]
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
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 391:25]
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
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 485:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 486:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 487:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 488:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h0; // @[Core.scala 492:17]
  wire  _id_op1_data_T_1 = csignals_1 == 3'h1; // @[Core.scala 493:17]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h3; // @[Core.scala 494:17]
  wire  _id_op1_data_T_3 = csignals_1 == 3'h4; // @[Core.scala 495:17]
  wire  _id_op1_data_T_4 = csignals_1 == 3'h5; // @[Core.scala 496:17]
  wire  _id_op1_data_T_5 = csignals_1 == 3'h6; // @[Core.scala 497:17]
  wire [31:0] _id_op1_data_T_6 = _id_op1_data_T_5 ? regfile_id_c_rs1p_data_data : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_7 = _id_op1_data_T_4 ? regfile_id_sp_data_data : _id_op1_data_T_6; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_8 = _id_op1_data_T_3 ? id_c_rs1_data : _id_op1_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_9 = _id_op1_data_T_2 ? id_imm_z_uext : _id_op1_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] _id_op1_data_T_10 = _id_op1_data_T_1 ? id_reg_pc : _id_op1_data_T_9; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? id_rs1_data : _id_op1_data_T_10; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 4'h1; // @[Core.scala 500:17]
  wire  _id_op2_data_T_1 = csignals_2 == 4'h2; // @[Core.scala 501:17]
  wire  _id_op2_data_T_2 = csignals_2 == 4'h3; // @[Core.scala 502:17]
  wire  _id_op2_data_T_3 = csignals_2 == 4'h4; // @[Core.scala 503:17]
  wire  _id_op2_data_T_4 = csignals_2 == 4'h5; // @[Core.scala 504:17]
  wire  _id_op2_data_T_5 = csignals_2 == 4'h6; // @[Core.scala 505:17]
  wire  _id_op2_data_T_6 = csignals_2 == 4'h7; // @[Core.scala 506:17]
  wire  _id_op2_data_T_7 = csignals_2 == 4'h8; // @[Core.scala 507:17]
  wire  _id_op2_data_T_8 = csignals_2 == 4'h9; // @[Core.scala 508:17]
  wire  _id_op2_data_T_9 = csignals_2 == 4'ha; // @[Core.scala 509:17]
  wire  _id_op2_data_T_10 = csignals_2 == 4'hb; // @[Core.scala 510:17]
  wire  _id_op2_data_T_11 = csignals_2 == 4'hc; // @[Core.scala 511:17]
  wire  _id_op2_data_T_12 = csignals_2 == 4'hd; // @[Core.scala 512:17]
  wire  _id_op2_data_T_13 = csignals_2 == 4'he; // @[Core.scala 513:17]
  wire  _id_op2_data_T_14 = csignals_2 == 4'hf; // @[Core.scala 514:17]
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
  wire  _id_csr_addr_T = csignals_7 == 3'h4; // @[Core.scala 517:36]
  wire [11:0] id_csr_addr = csignals_7 == 3'h4 ? 12'h342 : id_imm_i; // @[Core.scala 517:24]
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
  reg [31:0] id_reg_pc_delay; // @[Core.scala 551:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 552:40]
  reg [2:0] id_reg_op1_sel_delay; // @[Core.scala 553:40]
  reg [3:0] id_reg_op2_sel_delay; // @[Core.scala 554:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 555:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 556:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 557:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 558:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 560:40]
  reg [1:0] id_reg_mem_wen_delay; // @[Core.scala 561:40]
  reg [1:0] id_reg_rf_wen_delay; // @[Core.scala 562:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 563:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 564:40]
  reg [2:0] id_reg_csr_cmd_delay; // @[Core.scala 565:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 568:40]
  reg [31:0] id_reg_mem_w_delay; // @[Core.scala 571:40]
  reg  id_reg_is_bp_pos_delay; // @[Core.scala 572:40]
  reg [31:0] id_reg_bp_addr_delay; // @[Core.scala 573:40]
  reg  id_reg_is_half_delay; // @[Core.scala 574:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 575:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 576:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 577:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 605:43]
  wire [31:0] _GEN_24 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 614:24 615:29 640:29]
  wire [2:0] _GEN_25 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 614:24 616:29 641:29]
  wire [3:0] _GEN_26 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 614:24 617:29 642:29]
  wire [4:0] _GEN_27 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 614:24 618:29 643:29]
  wire [4:0] _GEN_28 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 614:24 619:29 644:29]
  wire [31:0] _GEN_29 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 614:24 620:29 645:29]
  wire [31:0] _GEN_30 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[Core.scala 614:24 621:29 646:29]
  wire [4:0] _GEN_32 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 614:24 623:29 648:29]
  wire [31:0] _GEN_36 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 614:24 627:29 652:29]
  wire [11:0] _GEN_37 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 614:24 628:29 653:29]
  wire [31:0] _GEN_39 = id_reg_stall ? id_reg_bp_addr_delay : id_reg_bp_addr; // @[Core.scala 614:24 633:29 658:29]
  wire  _GEN_40 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 614:24 634:29 659:29]
  wire [31:0] _GEN_41 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 614:24 637:29 662:29]
  wire  _T_6 = ~ex1_stall; // @[Core.scala 665:14]
  wire  _T_7 = ~mem_stall; // @[Core.scala 665:28]
  reg  ex1_reg_fw_en; // @[Core.scala 730:38]
  reg  ex2_reg_fw_en; // @[Core.scala 733:38]
  reg [31:0] ex2_reg_fw_data; // @[Core.scala 735:38]
  reg [1:0] mem_reg_rf_wen_delay; // @[Core.scala 736:38]
  reg [31:0] mem_reg_wb_data_delay; // @[Core.scala 738:38]
  reg [1:0] wb_reg_rf_wen_delay; // @[Core.scala 739:38]
  reg [4:0] wb_reg_wb_addr_delay; // @[Core.scala 740:38]
  reg [31:0] wb_reg_wb_data_delay; // @[Core.scala 741:38]
  wire  _ex1_op1_data_T_2 = _ex1_stall_T & ex1_reg_rs1_addr == 5'h0; // @[Core.scala 758:34]
  wire  _ex1_op1_data_T_4 = ex1_reg_fw_en & _ex1_stall_T; // @[Core.scala 759:20]
  wire  _ex1_op1_data_T_6 = _ex1_op1_data_T_4 & _ex1_stall_T_2; // @[Core.scala 760:36]
  wire  _ex1_op1_data_T_8 = ex2_reg_fw_en & _ex1_stall_T; // @[Core.scala 762:20]
  wire  _ex1_op1_data_T_10 = _ex1_op1_data_T_8 & _ex1_stall_T_6; // @[Core.scala 763:36]
  wire  _ex1_op1_data_T_11 = mem_reg_rf_wen_delay == 2'h1; // @[Core.scala 765:28]
  wire  _ex1_op1_data_T_13 = mem_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 765:39]
  wire  _ex1_op1_data_T_14 = ex1_reg_rs1_addr == wb_reg_wb_addr; // @[Core.scala 767:24]
  wire  _ex1_op1_data_T_15 = _ex1_op1_data_T_13 & _ex1_op1_data_T_14; // @[Core.scala 766:36]
  wire  _ex1_op1_data_T_16 = wb_reg_rf_wen_delay == 2'h1; // @[Core.scala 768:27]
  wire  _ex1_op1_data_T_18 = wb_reg_rf_wen_delay == 2'h1 & _ex1_stall_T; // @[Core.scala 768:38]
  wire  _ex1_op1_data_T_19 = ex1_reg_rs1_addr == wb_reg_wb_addr_delay; // @[Core.scala 770:24]
  wire  _ex1_op1_data_T_20 = _ex1_op1_data_T_18 & _ex1_op1_data_T_19; // @[Core.scala 769:36]
  wire [31:0] _ex1_op1_data_T_22 = _ex1_stall_T ? regfile_ex1_op1_data_MPORT_data : ex1_reg_op1_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_23 = _ex1_op1_data_T_20 ? wb_reg_wb_data_delay : _ex1_op1_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_24 = _ex1_op1_data_T_15 ? mem_reg_wb_data_delay : _ex1_op1_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op1_data_T_25 = _ex1_op1_data_T_10 ? ex2_reg_fw_data : _ex1_op1_data_T_24; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex2_reg_wb_sel == 3'h2; // @[Core.scala 879:21]
  wire [31:0] _ex1_fw_data_T_2 = ex2_reg_pc + 32'h2; // @[Core.scala 880:18]
  wire [31:0] _ex1_fw_data_T_4 = ex2_reg_pc + 32'h4; // @[Core.scala 881:18]
  wire [31:0] _ex1_fw_data_T_5 = ex2_reg_is_half ? _ex1_fw_data_T_2 : _ex1_fw_data_T_4; // @[Core.scala 879:38]
  wire  _ex2_alu_out_T = ex2_reg_exe_fun == 5'h1; // @[Core.scala 843:22]
  wire [31:0] _ex2_alu_out_T_2 = ex2_reg_op1_data + ex2_reg_op2_data; // @[Core.scala 843:58]
  wire  _ex2_alu_out_T_3 = ex2_reg_exe_fun == 5'h2; // @[Core.scala 844:22]
  wire [31:0] _ex2_alu_out_T_5 = ex2_reg_op1_data - ex2_reg_op2_data; // @[Core.scala 844:58]
  wire  _ex2_alu_out_T_6 = ex2_reg_exe_fun == 5'h3; // @[Core.scala 845:22]
  wire [31:0] _ex2_alu_out_T_7 = ex2_reg_op1_data & ex2_reg_op2_data; // @[Core.scala 845:58]
  wire  _ex2_alu_out_T_8 = ex2_reg_exe_fun == 5'h4; // @[Core.scala 846:22]
  wire [31:0] _ex2_alu_out_T_9 = ex2_reg_op1_data | ex2_reg_op2_data; // @[Core.scala 846:58]
  wire  _ex2_alu_out_T_10 = ex2_reg_exe_fun == 5'h5; // @[Core.scala 847:22]
  wire [31:0] _ex2_alu_out_T_11 = ex2_reg_op1_data ^ ex2_reg_op2_data; // @[Core.scala 847:58]
  wire  _ex2_alu_out_T_12 = ex2_reg_exe_fun == 5'h6; // @[Core.scala 848:22]
  wire [62:0] _GEN_7 = {{31'd0}, ex2_reg_op1_data}; // @[Core.scala 848:58]
  wire [62:0] _ex2_alu_out_T_14 = _GEN_7 << ex2_reg_op2_data[4:0]; // @[Core.scala 848:58]
  wire  _ex2_alu_out_T_16 = ex2_reg_exe_fun == 5'h7; // @[Core.scala 849:22]
  wire [31:0] _ex2_alu_out_T_18 = ex2_reg_op1_data >> ex2_reg_op2_data[4:0]; // @[Core.scala 849:58]
  wire  _ex2_alu_out_T_19 = ex2_reg_exe_fun == 5'h8; // @[Core.scala 850:22]
  wire [31:0] _ex2_alu_out_T_23 = $signed(ex2_reg_op1_data) >>> ex2_reg_op2_data[4:0]; // @[Core.scala 850:100]
  wire  _ex2_alu_out_T_24 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 851:22]
  wire  _ex2_alu_out_T_27 = $signed(ex2_reg_op1_data) < $signed(ex2_reg_op2_data); // @[Core.scala 851:67]
  wire  _ex2_alu_out_T_28 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 852:22]
  wire  _ex2_alu_out_T_29 = ex2_reg_op1_data < ex2_reg_op2_data; // @[Core.scala 852:58]
  wire  _ex2_alu_out_T_30 = ex2_reg_exe_fun == 5'h11; // @[Core.scala 853:22]
  wire [31:0] _ex2_alu_out_T_34 = _ex2_alu_out_T_2 & 32'hfffffffe; // @[Core.scala 853:79]
  wire  _ex2_alu_out_T_35 = ex2_reg_exe_fun == 5'h12; // @[Core.scala 854:22]
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
  wire  _ex1_op2_data_T_1 = ex1_reg_rs2_addr == 5'h0; // @[Core.scala 774:54]
  wire  _ex1_op2_data_T_2 = _ex1_stall_T_9 & ex1_reg_rs2_addr == 5'h0; // @[Core.scala 774:34]
  wire  _ex1_op2_data_T_4 = ex1_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 775:20]
  wire  _ex1_op2_data_T_6 = _ex1_op2_data_T_4 & _ex1_stall_T_13; // @[Core.scala 776:36]
  wire  _ex1_op2_data_T_8 = ex2_reg_fw_en & _ex1_stall_T_9; // @[Core.scala 778:20]
  wire  _ex1_op2_data_T_10 = _ex1_op2_data_T_8 & _ex1_stall_T_20; // @[Core.scala 779:36]
  wire  _ex1_op2_data_T_13 = _ex1_op1_data_T_11 & _ex1_stall_T_9; // @[Core.scala 781:39]
  wire  _ex1_op2_data_T_14 = ex1_reg_rs2_addr == wb_reg_wb_addr; // @[Core.scala 783:24]
  wire  _ex1_op2_data_T_15 = _ex1_op2_data_T_13 & _ex1_op2_data_T_14; // @[Core.scala 782:36]
  wire  _ex1_op2_data_T_18 = _ex1_op1_data_T_16 & _ex1_stall_T_9; // @[Core.scala 784:38]
  wire  _ex1_op2_data_T_19 = ex1_reg_rs2_addr == wb_reg_wb_addr_delay; // @[Core.scala 786:24]
  wire  _ex1_op2_data_T_20 = _ex1_op2_data_T_18 & _ex1_op2_data_T_19; // @[Core.scala 785:36]
  wire [31:0] _ex1_op2_data_T_22 = _ex1_stall_T_9 ? regfile_ex1_op2_data_MPORT_data : ex1_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_23 = _ex1_op2_data_T_20 ? wb_reg_wb_data_delay : _ex1_op2_data_T_22; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_24 = _ex1_op2_data_T_15 ? mem_reg_wb_data_delay : _ex1_op2_data_T_23; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_25 = _ex1_op2_data_T_10 ? ex2_reg_fw_data : _ex1_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _ex1_op2_data_T_26 = _ex1_op2_data_T_6 ? ex1_fw_data : _ex1_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] ex1_op2_data = _ex1_op2_data_T_2 ? 32'h0 : _ex1_op2_data_T_26; // @[Mux.scala 101:16]
  wire  _ex1_rs2_data_T_2 = ex1_reg_fw_en & _ex1_stall_T_13; // @[Core.scala 791:20]
  wire  _ex1_rs2_data_T_4 = ex2_reg_fw_en & _ex1_stall_T_20; // @[Core.scala 793:20]
  wire  _ex1_rs2_data_T_7 = _ex1_op1_data_T_11 & _ex1_op2_data_T_14; // @[Core.scala 795:39]
  wire  _ex1_rs2_data_T_10 = _ex1_op1_data_T_16 & _ex1_op2_data_T_19; // @[Core.scala 797:38]
  wire [31:0] _ex1_rs2_data_T_11 = _ex1_rs2_data_T_10 ? wb_reg_wb_data_delay : regfile_ex1_rs2_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_12 = _ex1_rs2_data_T_7 ? mem_reg_wb_data_delay : _ex1_rs2_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _ex1_rs2_data_T_13 = _ex1_rs2_data_T_4 ? ex2_reg_fw_data : _ex1_rs2_data_T_12; // @[Mux.scala 101:16]
  wire  _ex1_hazard_T_3 = ~mem_reg_is_br; // @[Core.scala 808:81]
  wire  _ex1_hazard_T_5 = ~ex3_reg_is_br; // @[Core.scala 808:99]
  wire  ex1_hazard = ex1_reg_rf_wen == 2'h1 & ex1_reg_wb_addr != 5'h0 & ~mem_reg_is_br & ~ex3_reg_is_br; // @[Core.scala 808:96]
  wire  ex_is_bubble = ex1_stall | mem_reg_is_br | ex3_reg_is_br; // @[Core.scala 816:51]
  wire  _ex2_is_cond_br_T = ex2_reg_exe_fun == 5'hb; // @[Core.scala 859:22]
  wire  _ex2_is_cond_br_T_1 = ex2_reg_op1_data == ex2_reg_op2_data; // @[Core.scala 859:57]
  wire  _ex2_is_cond_br_T_2 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 860:22]
  wire  _ex2_is_cond_br_T_4 = ~_ex2_is_cond_br_T_1; // @[Core.scala 860:38]
  wire  _ex2_is_cond_br_T_5 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 861:22]
  wire  _ex2_is_cond_br_T_9 = ex2_reg_exe_fun == 5'he; // @[Core.scala 862:22]
  wire  _ex2_is_cond_br_T_13 = ~_ex2_alu_out_T_27; // @[Core.scala 862:38]
  wire  _ex2_is_cond_br_T_14 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 863:22]
  wire  _ex2_is_cond_br_T_16 = ex2_reg_exe_fun == 5'h10; // @[Core.scala 864:22]
  wire  _ex2_is_cond_br_T_18 = ~_ex2_alu_out_T_29; // @[Core.scala 864:38]
  wire  _ex2_is_cond_br_T_20 = _ex2_is_cond_br_T_14 ? _ex2_alu_out_T_29 : _ex2_is_cond_br_T_16 & _ex2_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_T_21 = _ex2_is_cond_br_T_9 ? _ex2_is_cond_br_T_13 : _ex2_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex2_is_cond_br_inst_T_2 = _ex2_is_cond_br_T | _ex2_is_cond_br_T_2; // @[Core.scala 867:34]
  wire  _ex2_is_cond_br_inst_T_4 = _ex2_is_cond_br_inst_T_2 | _ex2_is_cond_br_T_5; // @[Core.scala 868:34]
  wire  _ex2_is_cond_br_inst_T_6 = _ex2_is_cond_br_inst_T_4 | _ex2_is_cond_br_T_9; // @[Core.scala 869:34]
  wire  _ex2_is_cond_br_inst_T_8 = _ex2_is_cond_br_inst_T_6 | _ex2_is_cond_br_T_14; // @[Core.scala 870:34]
  wire  ex2_is_cond_br_inst = _ex2_is_cond_br_inst_T_8 | _ex2_is_cond_br_T_16; // @[Core.scala 871:35]
  wire [31:0] ex2_cond_br_target = ex2_reg_pc + ex2_reg_imm_b_sext; // @[Core.scala 875:39]
  wire  ex2_hazard = ex2_reg_rf_wen == 2'h1 & ex2_reg_wb_addr != 5'h0 & _ex1_hazard_T_3 & _ex1_hazard_T_5; // @[Core.scala 886:96]
  wire  _ex3_reg_bp_en_T_2 = _ex1_hazard_T_3 & _ex1_hazard_T_5; // @[Core.scala 893:46]
  wire  ex3_bp_en = ex3_reg_bp_en & _ex1_hazard_T_3 & _ex1_hazard_T_5; // @[Core.scala 907:51]
  wire  _ex3_cond_bp_fail_T = ~ex3_reg_is_bp_pos; // @[Core.scala 909:6]
  wire  _ex3_cond_bp_fail_T_4 = ex3_reg_is_bp_pos & ex3_reg_is_cond_br & ex3_reg_bp_addr != ex3_reg_cond_br_target; // @[Core.scala 910:46]
  wire  _ex3_cond_bp_fail_T_5 = ~ex3_reg_is_bp_pos & ex3_reg_is_cond_br | _ex3_cond_bp_fail_T_4; // @[Core.scala 909:48]
  wire  ex3_cond_bp_fail = ex3_bp_en & _ex3_cond_bp_fail_T_5; // @[Core.scala 908:36]
  wire  ex3_cond_nbp_fail = ex3_bp_en & ex3_reg_is_bp_pos & ex3_reg_is_cond_br_inst & ~ex3_reg_is_cond_br; // @[Core.scala 912:85]
  wire  _ex3_uncond_bp_fail_T_3 = ex3_reg_is_bp_pos & ex3_reg_bp_addr != ex3_reg_uncond_br_target; // @[Core.scala 915:24]
  wire  _ex3_uncond_bp_fail_T_4 = _ex3_cond_bp_fail_T | _ex3_uncond_bp_fail_T_3; // @[Core.scala 914:24]
  wire  ex3_uncond_bp_fail = ex3_bp_en & ex3_reg_is_uncond_br & _ex3_uncond_bp_fail_T_4; // @[Core.scala 913:64]
  wire [31:0] _ex3_reg_br_target_T_1 = ex3_reg_pc + 32'h2; // @[Core.scala 919:59]
  wire [31:0] _ex3_reg_br_target_T_3 = ex3_reg_pc + 32'h4; // @[Core.scala 919:89]
  wire [31:0] _bp_io_up_br_addr_T = ex3_reg_is_uncond_br ? ex3_reg_uncond_br_target : 32'h0; // @[Mux.scala 101:16]
  wire  _mem_reg_mem_wstrb_T = ex2_reg_mem_w == 32'h3; // @[Core.scala 949:22]
  wire  _mem_reg_mem_wstrb_T_1 = ex2_reg_mem_w == 32'h2; // @[Core.scala 950:22]
  wire [3:0] _mem_reg_mem_wstrb_T_4 = _mem_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem_reg_mem_wstrb_T_5 = _mem_reg_mem_wstrb_T ? 4'h1 : _mem_reg_mem_wstrb_T_4; // @[Mux.scala 101:16]
  wire [6:0] _GEN_23 = {{3'd0}, _mem_reg_mem_wstrb_T_5}; // @[Core.scala 952:8]
  wire [6:0] _mem_reg_mem_wstrb_T_7 = _GEN_23 << ex2_alu_out[1:0]; // @[Core.scala 952:8]
  wire  mem_is_meintr = csr_mstatus[3] & (io_intr & csr_mie[11]); // @[Core.scala 963:45]
  wire  mem_is_mtintr = csr_mstatus[3] & (mtimer_io_intr & csr_mie[7]); // @[Core.scala 964:45]
  wire  _mem_en_T_4 = ~mem_reg_is_trap; // @[Core.scala 965:66]
  wire  _mem_en_T_6 = ~mem_is_meintr; // @[Core.scala 965:86]
  wire  _mem_en_T_8 = ~mem_is_mtintr; // @[Core.scala 965:104]
  wire  mem_en = mem_reg_en & _ex1_hazard_T_3 & _ex1_hazard_T_5 & ~mem_reg_is_trap & ~mem_is_meintr & ~mem_is_mtintr; // @[Core.scala 965:101]
  wire [2:0] mem_wb_sel = mem_en ? mem_reg_wb_sel : 3'h0; // @[Core.scala 967:23]
  wire [2:0] mem_csr_cmd = mem_en ? mem_reg_csr_cmd : 3'h0; // @[Core.scala 968:24]
  wire [1:0] mem_mem_wen = mem_en ? mem_reg_mem_wen : 2'h0; // @[Core.scala 969:24]
  wire  _io_dmem_ren_T = mem_wb_sel == 3'h1; // @[Core.scala 974:31]
  wire [5:0] _io_dmem_wdata_T_1 = 4'h8 * mem_reg_alu_out[1:0]; // @[Core.scala 977:46]
  wire [94:0] _GEN_31 = {{63'd0}, mem_reg_rs2_data}; // @[Core.scala 977:38]
  wire [94:0] _io_dmem_wdata_T_2 = _GEN_31 << _io_dmem_wdata_T_1; // @[Core.scala 977:38]
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
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 1000:18]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 1001:18]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | mem_reg_op1_data; // @[Core.scala 1001:43]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 1002:18]
  wire [31:0] _csr_wdata_T_4 = ~mem_reg_op1_data; // @[Core.scala 1002:45]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1002:43]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? mem_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [31:0] _GEN_142 = mem_reg_csr_addr == 12'h304 ? csr_wdata : csr_mie; // @[Core.scala 1014:52 1015:15 65:29]
  wire [31:0] _GEN_143 = mem_reg_csr_addr == 12'h340 ? csr_wdata : csr_mscratch; // @[Core.scala 1012:57 1013:20 64:29]
  wire [31:0] _GEN_144 = mem_reg_csr_addr == 12'h340 ? csr_mie : _GEN_142; // @[Core.scala 1012:57 65:29]
  wire [31:0] _GEN_145 = mem_reg_csr_addr == 12'h300 ? csr_wdata : csr_mstatus; // @[Core.scala 1010:56 1011:19 63:29]
  wire [31:0] _GEN_146 = mem_reg_csr_addr == 12'h300 ? csr_mscratch : _GEN_143; // @[Core.scala 1010:56 64:29]
  wire [31:0] _GEN_147 = mem_reg_csr_addr == 12'h300 ? csr_mie : _GEN_144; // @[Core.scala 1010:56 65:29]
  wire [31:0] _GEN_148 = mem_reg_csr_addr == 12'h341 ? csr_wdata : csr_mepc; // @[Core.scala 1008:53 1009:16 62:29]
  wire [31:0] _GEN_149 = mem_reg_csr_addr == 12'h341 ? csr_mstatus : _GEN_145; // @[Core.scala 1008:53 63:29]
  wire [31:0] _GEN_153 = mem_reg_csr_addr == 12'h305 ? csr_mepc : _GEN_148; // @[Core.scala 1006:48 62:29]
  wire [31:0] _GEN_154 = mem_reg_csr_addr == 12'h305 ? csr_mstatus : _GEN_149; // @[Core.scala 1006:48 63:29]
  wire [31:0] _GEN_158 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_153 : csr_mepc; // @[Core.scala 1005:82 62:29]
  wire [31:0] _GEN_159 = _csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3 ? _GEN_154 : csr_mstatus; // @[Core.scala 1005:82 63:29]
  wire [31:0] _csr_mip_T_3 = {csr_mip[31:12],io_intr,csr_mip[10:8],mtimer_io_intr,csr_mip[6:0]}; // @[Cat.scala 31:58]
  wire [31:0] _csr_mstatus_T_4 = {csr_mstatus[31:8],csr_mstatus[3],csr_mstatus[6:4],1'h0,csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire  _T_23 = mem_csr_cmd == 3'h6; // @[Core.scala 1042:27]
  wire [31:0] _csr_mstatus_T_19 = {csr_mstatus[31:8],1'h1,csr_mstatus[6:4],csr_mstatus[7],csr_mstatus[2:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_162 = mem_csr_cmd == 3'h6 ? _csr_mstatus_T_19 : _GEN_159; // @[Core.scala 1042:38 1043:21]
  wire [31:0] _GEN_164 = mem_csr_cmd == 3'h6 ? csr_mepc : mem_reg_br_addr; // @[Core.scala 1042:38 1045:21 187:35]
  wire  _GEN_169 = mem_reg_is_trap | _T_23; // @[Core.scala 1035:32 1040:21]
  wire  _GEN_175 = mem_is_mtintr | _GEN_169; // @[Core.scala 1028:30 1033:21]
  wire  _GEN_181 = mem_is_meintr | _GEN_175; // @[Core.scala 1021:24 1026:21]
  wire [31:0] mem_wb_rdata = io_dmem_rdata >> _io_dmem_wdata_T_1; // @[Core.scala 1058:36]
  wire  _mem_wb_data_load_T = mem_reg_mem_w == 32'h3; // @[Core.scala 1060:20]
  wire [23:0] _mem_wb_data_load_T_3 = mem_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_5 = {_mem_wb_data_load_T_3,mem_wb_rdata[7:0]}; // @[Core.scala 1051:40]
  wire  _mem_wb_data_load_T_6 = mem_reg_mem_w == 32'h2; // @[Core.scala 1061:20]
  wire [15:0] _mem_wb_data_load_T_9 = mem_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _mem_wb_data_load_T_11 = {_mem_wb_data_load_T_9,mem_wb_rdata[15:0]}; // @[Core.scala 1051:40]
  wire  _mem_wb_data_load_T_12 = mem_reg_mem_w == 32'h5; // @[Core.scala 1062:20]
  wire [31:0] _mem_wb_data_load_T_15 = {24'h0,mem_wb_rdata[7:0]}; // @[Core.scala 1054:31]
  wire  _mem_wb_data_load_T_16 = mem_reg_mem_w == 32'h4; // @[Core.scala 1063:20]
  wire [31:0] _mem_wb_data_load_T_19 = {16'h0,mem_wb_rdata[15:0]}; // @[Core.scala 1054:31]
  wire [31:0] _mem_wb_data_load_T_20 = _mem_wb_data_load_T_16 ? _mem_wb_data_load_T_19 : mem_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_21 = _mem_wb_data_load_T_12 ? _mem_wb_data_load_T_15 : _mem_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_load_T_22 = _mem_wb_data_load_T_6 ? _mem_wb_data_load_T_11 : _mem_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data_load = _mem_wb_data_load_T ? _mem_wb_data_load_T_5 : _mem_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire  _mem_wb_data_T_1 = mem_wb_sel == 3'h2; // @[Core.scala 1068:17]
  wire [31:0] _mem_wb_data_T_3 = mem_reg_pc + 32'h2; // @[Core.scala 1068:64]
  wire [31:0] _mem_wb_data_T_5 = mem_reg_pc + 32'h4; // @[Core.scala 1068:94]
  wire [31:0] _mem_wb_data_T_6 = mem_reg_is_half ? _mem_wb_data_T_3 : _mem_wb_data_T_5; // @[Core.scala 1068:35]
  wire  _mem_wb_data_T_7 = mem_wb_sel == 3'h3; // @[Core.scala 1069:17]
  wire [31:0] _mem_wb_data_T_8 = _mem_wb_data_T_7 ? csr_rdata : mem_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _mem_wb_data_T_9 = _mem_wb_data_T_1 ? _mem_wb_data_T_6 : _mem_wb_data_T_8; // @[Mux.scala 101:16]
  wire [31:0] mem_wb_data = _io_dmem_ren_T ? mem_wb_data_load : _mem_wb_data_T_9; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h1; // @[Core.scala 1096:24]
  reg  do_exit; // @[Core.scala 1111:24]
  reg  do_exit_delay; // @[Core.scala 1112:30]
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
  BranchPredictor bp ( // @[Core.scala 231:18]
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
  assign io_imem_addr = ic_fill_half ? _ic_mem_addr_T_2 : _ic_mem_addr_T_7; // @[Core.scala 211:24]
  assign io_dmem_raddr = mem_reg_alu_out; // @[Core.scala 972:17]
  assign io_dmem_ren = mem_wb_sel == 3'h1; // @[Core.scala 974:31]
  assign io_dmem_waddr = mem_reg_alu_out; // @[Core.scala 973:17]
  assign io_dmem_wen = mem_mem_wen[0]; // @[Core.scala 975:17]
  assign io_dmem_wstrb = mem_reg_mem_wstrb; // @[Core.scala 976:17]
  assign io_dmem_wdata = _io_dmem_wdata_T_2[31:0]; // @[Core.scala 977:71]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 68:17]
  assign io_mtimer_mem_rvalid = mtimer_io_mem_rvalid; // @[Core.scala 68:17]
  assign io_exit = do_exit_delay; // @[Core.scala 1115:11]
  assign io_debug_signal_mem_reg_pc = mem_reg_pc; // @[Core.scala 1104:30]
  assign io_debug_signal_csr_rdata = 12'h344 == mem_reg_csr_addr ? csr_mip : _csr_rdata_T_31; // @[Mux.scala 81:58]
  assign io_debug_signal_mem_reg_csr_addr = {{20'd0}, mem_reg_csr_addr}; // @[Core.scala 1103:36]
  assign io_debug_signal_me_intr = csr_mstatus[3] & (io_intr & csr_mie[11]); // @[Core.scala 963:45]
  assign io_debug_signal_id_reg_inst = id_reg_inst; // @[Core.scala 1106:31]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value; // @[Core.scala 1100:33]
  assign io_debug_signal_instret = instret; // @[Core.scala 1101:27]
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
  assign bp_io_lu_inst_pc = if1_is_jump ? if1_jump_addr : if1_reg_next_pc; // @[Core.scala 252:24]
  assign bp_io_up_update_en = ex3_bp_en & (ex3_reg_is_cond_br_inst | ex3_reg_is_uncond_br); // @[Core.scala 924:35]
  assign bp_io_up_inst_pc = ex3_reg_pc; // @[Core.scala 925:20]
  assign bp_io_up_br_pos = ex3_reg_is_cond_br | ex3_reg_is_uncond_br; // @[Core.scala 926:41]
  assign bp_io_up_br_addr = ex3_reg_is_cond_br ? ex3_reg_cond_br_target : _bp_io_up_br_addr_T; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (regfile_MPORT_en & regfile_MPORT_mask) begin
      regfile[regfile_MPORT_addr] <= regfile_MPORT_data; // @[Core.scala 54:20]
    end
    if (reset) begin // @[Core.scala 56:32]
      csr_trap_vector <= 32'h0; // @[Core.scala 56:32]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1005:82]
      if (mem_reg_csr_addr == 12'h305) begin // @[Core.scala 1006:48]
        if (_csr_wdata_T) begin // @[Mux.scala 101:16]
          csr_trap_vector <= mem_reg_op1_data;
        end else begin
          csr_trap_vector <= _csr_wdata_T_7;
        end
      end
    end
    if (reset) begin // @[Core.scala 59:24]
      instret <= 64'h0; // @[Core.scala 59:24]
    end else if (wb_reg_is_valid_inst) begin // @[Core.scala 1095:31]
      instret <= _instret_T_1; // @[Core.scala 1096:13]
    end
    if (reset) begin // @[Core.scala 60:29]
      csr_mcause <= 32'h0; // @[Core.scala 60:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1021:24]
      csr_mcause <= 32'h8000000b; // @[Core.scala 1022:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1028:30]
      csr_mcause <= 32'h80000007; // @[Core.scala 1029:21]
    end else if (mem_reg_is_trap) begin // @[Core.scala 1035:32]
      csr_mcause <= mem_reg_mcause; // @[Core.scala 1036:21]
    end
    if (reset) begin // @[Core.scala 62:29]
      csr_mepc <= 32'h0; // @[Core.scala 62:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1021:24]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1024:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1028:30]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1031:21]
    end else if (mem_reg_is_trap) begin // @[Core.scala 1035:32]
      csr_mepc <= mem_reg_pc; // @[Core.scala 1038:21]
    end else begin
      csr_mepc <= _GEN_158;
    end
    if (reset) begin // @[Core.scala 63:29]
      csr_mstatus <= 32'h0; // @[Core.scala 63:29]
    end else if (mem_is_meintr) begin // @[Core.scala 1021:24]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1025:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1028:30]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1032:21]
    end else if (mem_reg_is_trap) begin // @[Core.scala 1035:32]
      csr_mstatus <= _csr_mstatus_T_4; // @[Core.scala 1039:21]
    end else begin
      csr_mstatus <= _GEN_162;
    end
    if (reset) begin // @[Core.scala 64:29]
      csr_mscratch <= 32'h0; // @[Core.scala 64:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1005:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1006:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1008:53]
          csr_mscratch <= _GEN_146;
        end
      end
    end
    if (reset) begin // @[Core.scala 65:29]
      csr_mie <= 32'h0; // @[Core.scala 65:29]
    end else if (_csr_wdata_T | _csr_wdata_T_1 | _csr_wdata_T_3) begin // @[Core.scala 1005:82]
      if (!(mem_reg_csr_addr == 12'h305)) begin // @[Core.scala 1006:48]
        if (!(mem_reg_csr_addr == 12'h341)) begin // @[Core.scala 1008:53]
          csr_mie <= _GEN_147;
        end
      end
    end
    if (reset) begin // @[Core.scala 66:29]
      csr_mip <= 32'h0; // @[Core.scala 66:29]
    end else begin
      csr_mip <= _csr_mip_T_3; // @[Core.scala 1019:11]
    end
    if (reset) begin // @[Core.scala 74:38]
      id_reg_pc <= 32'h0; // @[Core.scala 74:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst)) begin // @[Core.scala 269:19]
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
      id_reg_stall <= id_stall; // @[Core.scala 346:16]
    end
    if (reset) begin // @[Core.scala 78:38]
      id_reg_is_bp_pos <= 1'h0; // @[Core.scala 78:38]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_stall) begin // @[Core.scala 310:26]
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
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_pc <= _GEN_24;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_pc <= _GEN_24;
    end
    if (reset) begin // @[Core.scala 86:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 86:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_wb_addr <= _GEN_32;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_wb_addr <= _GEN_32;
    end
    if (reset) begin // @[Core.scala 87:38]
      ex1_reg_op1_sel <= 3'h0; // @[Core.scala 87:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_op1_sel <= _GEN_25;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_op1_sel <= _GEN_25;
    end
    if (reset) begin // @[Core.scala 88:38]
      ex1_reg_op2_sel <= 4'h0; // @[Core.scala 88:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_op2_sel <= _GEN_26;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_op2_sel <= _GEN_26;
    end
    if (reset) begin // @[Core.scala 89:38]
      ex1_reg_rs1_addr <= 5'h0; // @[Core.scala 89:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_rs1_addr <= _GEN_27;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_rs1_addr <= _GEN_27;
    end
    if (reset) begin // @[Core.scala 90:38]
      ex1_reg_rs2_addr <= 5'h0; // @[Core.scala 90:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_rs2_addr <= _GEN_28;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_rs2_addr <= _GEN_28;
    end
    if (reset) begin // @[Core.scala 91:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 91:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_op1_data <= _GEN_29;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_op1_data <= _GEN_29;
    end
    if (reset) begin // @[Core.scala 92:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 92:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_op2_data <= _GEN_30;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_op2_data <= _GEN_30;
    end
    if (reset) begin // @[Core.scala 94:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 94:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_exe_fun <= 5'h1;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 678:29]
      end else begin
        ex1_reg_exe_fun <= csignals_0; // @[Core.scala 707:29]
      end
    end
    if (reset) begin // @[Core.scala 95:38]
      ex1_reg_mem_wen <= 2'h0; // @[Core.scala 95:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_mem_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_mem_wen <= id_reg_mem_wen_delay; // @[Core.scala 687:29]
      end else begin
        ex1_reg_mem_wen <= csignals_3; // @[Core.scala 716:29]
      end
    end
    if (reset) begin // @[Core.scala 96:38]
      ex1_reg_rf_wen <= 2'h0; // @[Core.scala 96:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_rf_wen <= 2'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 677:29]
      end else begin
        ex1_reg_rf_wen <= csignals_4; // @[Core.scala 706:29]
      end
    end
    if (reset) begin // @[Core.scala 97:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 97:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_wb_sel <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 679:29]
      end else begin
        ex1_reg_wb_sel <= csignals_5; // @[Core.scala 708:29]
      end
    end
    if (reset) begin // @[Core.scala 98:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 98:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_csr_addr <= _GEN_37;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_csr_addr <= _GEN_37;
    end
    if (reset) begin // @[Core.scala 99:38]
      ex1_reg_csr_cmd <= 3'h0; // @[Core.scala 99:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_csr_cmd <= 3'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 686:29]
      end else begin
        ex1_reg_csr_cmd <= csignals_7; // @[Core.scala 715:29]
      end
    end
    if (reset) begin // @[Core.scala 102:38]
      ex1_reg_imm_b_sext <= 32'h0; // @[Core.scala 102:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_imm_b_sext <= _GEN_36;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_imm_b_sext <= _GEN_36;
    end
    if (reset) begin // @[Core.scala 105:38]
      ex1_reg_mem_w <= 32'h0; // @[Core.scala 105:38]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_mem_w <= 32'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 688:29]
      end else begin
        ex1_reg_mem_w <= {{29'd0}, csignals_8}; // @[Core.scala 717:29]
      end
    end
    if (reset) begin // @[Core.scala 106:39]
      ex1_reg_is_bp_pos <= 1'h0; // @[Core.scala 106:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_is_bp_pos <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos_delay; // @[Core.scala 689:29]
      end else begin
        ex1_reg_is_bp_pos <= id_reg_is_bp_pos; // @[Core.scala 718:29]
      end
    end
    if (reset) begin // @[Core.scala 107:39]
      ex1_reg_bp_addr <= 32'h0; // @[Core.scala 107:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_bp_addr <= _GEN_39;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_bp_addr <= _GEN_39;
    end
    if (reset) begin // @[Core.scala 108:39]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 108:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_is_half <= _GEN_40;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_is_half <= _GEN_40;
    end
    if (reset) begin // @[Core.scala 109:39]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 109:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_is_valid_inst <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 692:29]
      end else begin
        ex1_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 721:29]
      end
    end
    if (reset) begin // @[Core.scala 110:39]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 110:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_is_trap <= 1'h0;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      if (id_reg_stall) begin // @[Core.scala 667:24]
        ex1_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 693:29]
      end else begin
        ex1_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 722:29]
      end
    end
    if (reset) begin // @[Core.scala 111:39]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 111:39]
    end else if (_if1_is_jump_T) begin // @[Core.scala 613:41]
      ex1_reg_mcause <= _GEN_41;
    end else if (~ex1_stall & ~mem_stall) begin // @[Core.scala 665:40]
      ex1_reg_mcause <= _GEN_41;
    end
    if (reset) begin // @[Core.scala 115:38]
      ex2_reg_pc <= 32'h0; // @[Core.scala 115:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 817:27]
    end
    if (reset) begin // @[Core.scala 116:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 116:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 821:27]
    end
    if (reset) begin // @[Core.scala 117:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 117:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (_ex1_op1_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= 32'h0;
      end else if (_ex1_op1_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op1_data <= ex1_fw_data;
      end else begin
        ex2_reg_op1_data <= _ex1_op1_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 118:38]
      ex2_reg_op2_data <= 32'h0; // @[Core.scala 118:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (_ex1_op2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= 32'h0;
      end else if (_ex1_op2_data_T_6) begin // @[Mux.scala 101:16]
        ex2_reg_op2_data <= ex1_fw_data;
      end else begin
        ex2_reg_op2_data <= _ex1_op2_data_T_25;
      end
    end
    if (reset) begin // @[Core.scala 119:38]
      ex2_reg_rs2_data <= 32'h0; // @[Core.scala 119:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (_ex1_op2_data_T_1) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= 32'h0;
      end else if (_ex1_rs2_data_T_2) begin // @[Mux.scala 101:16]
        ex2_reg_rs2_data <= ex1_fw_data;
      end else begin
        ex2_reg_rs2_data <= _ex1_rs2_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 120:38]
      ex2_reg_exe_fun <= 5'h0; // @[Core.scala 120:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 823:33]
        ex2_reg_exe_fun <= 5'h1;
      end else begin
        ex2_reg_exe_fun <= ex1_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 121:38]
      ex2_reg_mem_wen <= 2'h0; // @[Core.scala 121:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 828:33]
        ex2_reg_mem_wen <= 2'h0;
      end else begin
        ex2_reg_mem_wen <= ex1_reg_mem_wen;
      end
    end
    if (reset) begin // @[Core.scala 122:38]
      ex2_reg_rf_wen <= 2'h0; // @[Core.scala 122:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 822:33]
        ex2_reg_rf_wen <= 2'h0;
      end else begin
        ex2_reg_rf_wen <= ex1_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 123:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 123:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 824:33]
        ex2_reg_wb_sel <= 3'h0;
      end else begin
        ex2_reg_wb_sel <= ex1_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 124:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 124:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 826:27]
    end
    if (reset) begin // @[Core.scala 125:38]
      ex2_reg_csr_cmd <= 3'h0; // @[Core.scala 125:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 827:33]
        ex2_reg_csr_cmd <= 3'h0;
      end else begin
        ex2_reg_csr_cmd <= ex1_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 126:38]
      ex2_reg_imm_b_sext <= 32'h0; // @[Core.scala 126:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_imm_b_sext <= ex1_reg_imm_b_sext; // @[Core.scala 825:27]
    end
    if (reset) begin // @[Core.scala 127:38]
      ex2_reg_mem_w <= 32'h0; // @[Core.scala 127:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 829:27]
    end
    if (reset) begin // @[Core.scala 128:38]
      ex2_reg_is_bp_pos <= 1'h0; // @[Core.scala 128:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_is_bp_pos <= ex1_reg_is_bp_pos; // @[Core.scala 830:27]
    end
    if (reset) begin // @[Core.scala 129:38]
      ex2_reg_bp_addr <= 32'h0; // @[Core.scala 129:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_bp_addr <= ex1_reg_bp_addr; // @[Core.scala 831:27]
    end
    if (reset) begin // @[Core.scala 130:38]
      ex2_reg_is_half <= 1'h0; // @[Core.scala 130:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_is_half <= ex1_reg_is_half; // @[Core.scala 832:27]
    end
    if (reset) begin // @[Core.scala 131:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 131:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_is_valid_inst <= ex1_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 833:27]
    end
    if (reset) begin // @[Core.scala 132:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 132:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      if (ex_is_bubble) begin // @[Core.scala 834:33]
        ex2_reg_is_trap <= 1'h0;
      end else begin
        ex2_reg_is_trap <= ex1_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 133:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 133:38]
    end else if (_T_7) begin // @[Core.scala 815:20]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 835:27]
    end
    if (reset) begin // @[Core.scala 137:41]
      ex3_reg_bp_en <= 1'h0; // @[Core.scala 137:41]
    end else begin
      ex3_reg_bp_en <= _ex1_hazard_T_3 & _ex1_hazard_T_5; // @[Core.scala 893:28]
    end
    if (reset) begin // @[Core.scala 138:41]
      ex3_reg_pc <= 32'h0; // @[Core.scala 138:41]
    end else begin
      ex3_reg_pc <= ex2_reg_pc; // @[Core.scala 894:28]
    end
    if (reset) begin // @[Core.scala 139:41]
      ex3_reg_is_cond_br <= 1'h0; // @[Core.scala 139:41]
    end else if (_ex2_is_cond_br_T) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_1;
    end else if (_ex2_is_cond_br_T_2) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_4;
    end else if (_ex2_is_cond_br_T_5) begin // @[Mux.scala 101:16]
      ex3_reg_is_cond_br <= _ex2_alu_out_T_27;
    end else begin
      ex3_reg_is_cond_br <= _ex2_is_cond_br_T_21;
    end
    if (reset) begin // @[Core.scala 140:41]
      ex3_reg_is_cond_br_inst <= 1'h0; // @[Core.scala 140:41]
    end else begin
      ex3_reg_is_cond_br_inst <= ex2_is_cond_br_inst; // @[Core.scala 896:28]
    end
    if (reset) begin // @[Core.scala 141:41]
      ex3_reg_is_uncond_br <= 1'h0; // @[Core.scala 141:41]
    end else begin
      ex3_reg_is_uncond_br <= _ex2_alu_out_T_30; // @[Core.scala 897:28]
    end
    if (reset) begin // @[Core.scala 142:41]
      ex3_reg_cond_br_target <= 32'h0; // @[Core.scala 142:41]
    end else begin
      ex3_reg_cond_br_target <= ex2_cond_br_target; // @[Core.scala 898:28]
    end
    if (reset) begin // @[Core.scala 143:41]
      ex3_reg_uncond_br_target <= 32'h0; // @[Core.scala 143:41]
    end else if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_2;
    end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_5;
    end else if (_ex2_alu_out_T_6) begin // @[Mux.scala 101:16]
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_7;
    end else begin
      ex3_reg_uncond_br_target <= _ex2_alu_out_T_44;
    end
    if (reset) begin // @[Core.scala 144:41]
      ex3_reg_is_bp_pos <= 1'h0; // @[Core.scala 144:41]
    end else begin
      ex3_reg_is_bp_pos <= ex2_reg_is_bp_pos; // @[Core.scala 900:28]
    end
    if (reset) begin // @[Core.scala 145:41]
      ex3_reg_bp_addr <= 32'h0; // @[Core.scala 145:41]
    end else begin
      ex3_reg_bp_addr <= ex2_reg_bp_addr; // @[Core.scala 901:28]
    end
    if (reset) begin // @[Core.scala 146:41]
      ex3_reg_is_half <= 1'h0; // @[Core.scala 146:41]
    end else begin
      ex3_reg_is_half <= ex2_reg_is_half; // @[Core.scala 902:28]
    end
    if (reset) begin // @[Core.scala 149:38]
      mem_reg_en <= 1'h0; // @[Core.scala 149:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_en <= _ex3_reg_bp_en_T_2; // @[Core.scala 935:24]
    end
    if (reset) begin // @[Core.scala 150:38]
      mem_reg_pc <= 32'h0; // @[Core.scala 150:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_pc <= ex2_reg_pc; // @[Core.scala 936:24]
    end
    if (reset) begin // @[Core.scala 151:38]
      mem_reg_wb_addr <= 5'h0; // @[Core.scala 151:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_wb_addr <= ex2_reg_wb_addr; // @[Core.scala 939:24]
    end
    if (reset) begin // @[Core.scala 152:38]
      mem_reg_op1_data <= 32'h0; // @[Core.scala 152:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_op1_data <= ex2_reg_op1_data; // @[Core.scala 937:24]
    end
    if (reset) begin // @[Core.scala 153:38]
      mem_reg_rs2_data <= 32'h0; // @[Core.scala 153:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_rs2_data <= ex2_reg_rs2_data; // @[Core.scala 938:24]
    end
    if (reset) begin // @[Core.scala 154:38]
      mem_reg_mem_wen <= 2'h0; // @[Core.scala 154:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_mem_wen <= ex2_reg_mem_wen; // @[Core.scala 946:24]
    end
    if (reset) begin // @[Core.scala 155:38]
      mem_reg_rf_wen <= 2'h0; // @[Core.scala 155:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_rf_wen <= ex2_reg_rf_wen; // @[Core.scala 941:24]
    end
    if (reset) begin // @[Core.scala 156:38]
      mem_reg_wb_sel <= 3'h0; // @[Core.scala 156:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_wb_sel <= ex2_reg_wb_sel; // @[Core.scala 942:24]
    end
    if (reset) begin // @[Core.scala 157:38]
      mem_reg_csr_addr <= 12'h0; // @[Core.scala 157:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_csr_addr <= ex2_reg_csr_addr; // @[Core.scala 943:24]
    end
    if (reset) begin // @[Core.scala 158:38]
      mem_reg_csr_cmd <= 3'h0; // @[Core.scala 158:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_csr_cmd <= ex2_reg_csr_cmd; // @[Core.scala 944:24]
    end
    if (reset) begin // @[Core.scala 160:38]
      mem_reg_alu_out <= 32'h0; // @[Core.scala 160:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      if (_ex2_alu_out_T) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_2;
      end else if (_ex2_alu_out_T_3) begin // @[Mux.scala 101:16]
        mem_reg_alu_out <= _ex2_alu_out_T_5;
      end else begin
        mem_reg_alu_out <= _ex2_alu_out_T_45;
      end
    end
    if (reset) begin // @[Core.scala 161:38]
      mem_reg_mem_w <= 32'h0; // @[Core.scala 161:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_mem_w <= ex2_reg_mem_w; // @[Core.scala 947:24]
    end
    if (reset) begin // @[Core.scala 162:38]
      mem_reg_mem_wstrb <= 4'h0; // @[Core.scala 162:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_mem_wstrb <= _mem_reg_mem_wstrb_T_7[3:0]; // @[Core.scala 948:24]
    end
    if (reset) begin // @[Core.scala 163:38]
      mem_reg_is_half <= 1'h0; // @[Core.scala 163:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_is_half <= ex2_reg_is_half; // @[Core.scala 953:24]
    end
    if (reset) begin // @[Core.scala 164:38]
      mem_reg_is_valid_inst <= 1'h0; // @[Core.scala 164:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_is_valid_inst <= ex2_reg_is_valid_inst; // @[Core.scala 954:27]
    end
    if (reset) begin // @[Core.scala 165:38]
      mem_reg_is_trap <= 1'h0; // @[Core.scala 165:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_is_trap <= ex2_reg_is_trap; // @[Core.scala 955:24]
    end
    if (reset) begin // @[Core.scala 166:38]
      mem_reg_mcause <= 32'h0; // @[Core.scala 166:38]
    end else if (_T_7) begin // @[Core.scala 934:22]
      mem_reg_mcause <= ex2_reg_mcause; // @[Core.scala 956:24]
    end
    if (reset) begin // @[Core.scala 170:38]
      wb_reg_wb_addr <= 5'h0; // @[Core.scala 170:38]
    end else begin
      wb_reg_wb_addr <= mem_reg_wb_addr; // @[Core.scala 1078:18]
    end
    if (reset) begin // @[Core.scala 171:38]
      wb_reg_rf_wen <= 2'h0; // @[Core.scala 171:38]
    end else if (_T_7) begin // @[Core.scala 1079:24]
      if (mem_en) begin // @[Core.scala 966:23]
        wb_reg_rf_wen <= mem_reg_rf_wen;
      end else begin
        wb_reg_rf_wen <= 2'h0;
      end
    end else begin
      wb_reg_rf_wen <= 2'h0;
    end
    if (reset) begin // @[Core.scala 172:38]
      wb_reg_wb_data <= 32'h0; // @[Core.scala 172:38]
    end else if (_io_dmem_ren_T) begin // @[Mux.scala 101:16]
      if (_mem_wb_data_load_T) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_5;
      end else if (_mem_wb_data_load_T_6) begin // @[Mux.scala 101:16]
        wb_reg_wb_data <= _mem_wb_data_load_T_11;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_load_T_21;
      end
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      if (mem_reg_is_half) begin // @[Core.scala 1068:35]
        wb_reg_wb_data <= _mem_wb_data_T_3;
      end else begin
        wb_reg_wb_data <= _mem_wb_data_T_5;
      end
    end else if (_mem_wb_data_T_7) begin // @[Mux.scala 101:16]
      wb_reg_wb_data <= csr_rdata;
    end else begin
      wb_reg_wb_data <= mem_reg_alu_out;
    end
    if (reset) begin // @[Core.scala 173:38]
      wb_reg_is_valid_inst <= 1'h0; // @[Core.scala 173:38]
    end else begin
      wb_reg_is_valid_inst <= mem_reg_is_valid_inst & _T_7 & _mem_en_T_4 & _mem_en_T_6 & _mem_en_T_8; // @[Core.scala 1081:24]
    end
    if (reset) begin // @[Core.scala 175:35]
      if2_reg_is_bp_pos <= 1'h0; // @[Core.scala 175:35]
    end else if (!(id_reg_stall)) begin // @[Core.scala 310:26]
      if2_reg_is_bp_pos <= _if2_is_bp_pos_T_6;
    end
    if (reset) begin // @[Core.scala 176:35]
      if2_reg_bp_addr <= 32'h0; // @[Core.scala 176:35]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (_if2_is_bp_pos_T) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= bp_io_lu_br_addr;
      end else if (_if2_bp_addr_T_2) begin // @[Mux.scala 101:16]
        if2_reg_bp_addr <= if2_cond_br_addr;
      end else begin
        if2_reg_bp_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 179:39]
      if2_reg_is_uncond_br <= 1'h0; // @[Core.scala 179:39]
    end else if (!(id_reg_stall)) begin // @[Core.scala 299:26]
      if2_reg_is_uncond_br <= if2_is_jal;
    end
    if (reset) begin // @[Core.scala 180:39]
      if2_reg_uncond_br_addr <= 32'h0; // @[Core.scala 180:39]
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (if2_is_jal) begin // @[Mux.scala 101:16]
        if2_reg_uncond_br_addr <= if2_jal_addr;
      end else begin
        if2_reg_uncond_br_addr <= 32'h0;
      end
    end
    if (reset) begin // @[Core.scala 184:35]
      ex3_reg_is_br <= 1'h0; // @[Core.scala 184:35]
    end else begin
      ex3_reg_is_br <= ex3_cond_bp_fail | ex3_cond_nbp_fail | ex3_uncond_bp_fail; // @[Core.scala 922:17]
    end
    if (reset) begin // @[Core.scala 185:35]
      ex3_reg_br_target <= 32'h0; // @[Core.scala 185:35]
    end else if (ex3_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_cond_br_target;
    end else if (ex3_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (ex3_reg_is_half) begin // @[Core.scala 919:30]
        ex3_reg_br_target <= _ex3_reg_br_target_T_1;
      end else begin
        ex3_reg_br_target <= _ex3_reg_br_target_T_3;
      end
    end else if (ex3_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex3_reg_br_target <= ex3_reg_uncond_br_target;
    end else begin
      ex3_reg_br_target <= 32'h0;
    end
    if (reset) begin // @[Core.scala 186:35]
      mem_reg_is_br <= 1'h0; // @[Core.scala 186:35]
    end else begin
      mem_reg_is_br <= _GEN_181;
    end
    if (reset) begin // @[Core.scala 187:35]
      mem_reg_br_addr <= 32'h0; // @[Core.scala 187:35]
    end else if (mem_is_meintr) begin // @[Core.scala 1021:24]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1027:21]
    end else if (mem_is_mtintr) begin // @[Core.scala 1028:30]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1034:21]
    end else if (mem_reg_is_trap) begin // @[Core.scala 1035:32]
      mem_reg_br_addr <= csr_trap_vector; // @[Core.scala 1041:21]
    end else begin
      mem_reg_br_addr <= _GEN_164;
    end
    if (reset) begin // @[Core.scala 196:32]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 196:32]
    end else begin
      ic_reg_read_rdy <= ~ic_fill_half; // @[Core.scala 216:19]
    end
    if (reset) begin // @[Core.scala 197:32]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 197:32]
    end else begin
      ic_reg_half_rdy <= 1'h1; // @[Core.scala 215:19]
    end
    if (reset) begin // @[Core.scala 199:32]
      ic_reg_addr_out <= 32'h0; // @[Core.scala 199:32]
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
    if (reset) begin // @[Core.scala 203:33]
      ic_reg_half <= 16'h0; // @[Core.scala 203:33]
    end else if (_ic_reg_half_T_2) begin // @[Mux.scala 101:16]
      ic_reg_half <= io_imem_inst[31:16];
    end
    if1_reg_first <= reset; // @[Core.scala 236:{30,30} 237:17]
    if (reset) begin // @[Core.scala 251:32]
      if1_reg_next_pc <= 32'h0; // @[Core.scala 251:32]
    end else if (id_reg_stall) begin // @[Core.scala 254:25]
      if (if1_is_jump) begin // @[Core.scala 252:24]
        if (mem_reg_is_br) begin // @[Mux.scala 101:16]
          if1_reg_next_pc <= mem_reg_br_addr;
        end else begin
          if1_reg_next_pc <= _if1_jump_addr_T_3;
        end
      end
    end else begin
      if1_reg_next_pc <= if1_next_pc_4;
    end
    if (reset) begin // @[Core.scala 263:29]
      if2_reg_pc <= 32'h8000000; // @[Core.scala 263:29]
    end else if (!(id_reg_stall | ~(ic_reg_read_rdy | ic_reg_half_rdy & is_half_inst))) begin // @[Core.scala 269:19]
      if2_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 264:29]
      if2_reg_inst <= 32'h0; // @[Core.scala 264:29]
    end else if (ex3_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (mem_reg_is_br) begin // @[Mux.scala 101:16]
      if2_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if2_reg_inst <= _if2_inst_T_4;
    end
    if (reset) begin // @[Core.scala 731:38]
      ex1_reg_hazard <= 1'h0; // @[Core.scala 731:38]
    end else if (_T_7) begin // @[Core.scala 807:20]
      ex1_reg_hazard <= ex1_hazard & (ex1_reg_wb_sel == 3'h1 | ex1_reg_wb_sel == 3'h3); // @[Core.scala 810:20]
    end
    if (reset) begin // @[Core.scala 734:38]
      ex2_reg_hazard <= 1'h0; // @[Core.scala 734:38]
    end else if (_T_7) begin // @[Core.scala 885:20]
      ex2_reg_hazard <= ex2_hazard & (ex2_reg_wb_sel == 3'h1 | ex2_reg_wb_sel == 3'h3); // @[Core.scala 888:20]
    end
    if (reset) begin // @[Core.scala 970:32]
      mem_stall_delay <= 1'h0; // @[Core.scala 970:32]
    end else begin
      mem_stall_delay <= io_dmem_ren & io_dmem_rvalid & _T_7; // @[Core.scala 979:19]
    end
    if (reset) begin // @[Core.scala 551:40]
      id_reg_pc_delay <= 32'h0; // @[Core.scala 551:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_pc_delay <= id_reg_pc; // @[Core.scala 581:29]
    end
    if (reset) begin // @[Core.scala 552:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 552:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
        id_reg_wb_addr_delay <= id_w_wb_addr;
      end else if (_id_wb_addr_T_1) begin // @[Mux.scala 101:16]
        id_reg_wb_addr_delay <= id_c_rs1p_addr;
      end else begin
        id_reg_wb_addr_delay <= _id_wb_addr_T_5;
      end
    end
    if (reset) begin // @[Core.scala 553:40]
      id_reg_op1_sel_delay <= 3'h0; // @[Core.scala 553:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
        id_reg_op1_sel_delay <= 3'h0;
      end else if (_id_op1_data_T_4) begin // @[Mux.scala 101:16]
        id_reg_op1_sel_delay <= 3'h0;
      end else begin
        id_reg_op1_sel_delay <= _id_m_op1_sel_T_3;
      end
    end
    if (reset) begin // @[Core.scala 554:40]
      id_reg_op2_sel_delay <= 4'h0; // @[Core.scala 554:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
        id_reg_op2_sel_delay <= 4'h1;
      end else if (_id_op2_data_T_6) begin // @[Mux.scala 101:16]
        id_reg_op2_sel_delay <= 4'h1;
      end else begin
        id_reg_op2_sel_delay <= csignals_2;
      end
    end
    if (reset) begin // @[Core.scala 555:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 555:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op1_data_T_3) begin // @[Mux.scala 101:16]
        id_reg_rs1_addr_delay <= id_w_wb_addr;
      end else if (_id_op1_data_T_4) begin // @[Mux.scala 101:16]
        id_reg_rs1_addr_delay <= 5'h2;
      end else begin
        id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_3;
      end
    end
    if (reset) begin // @[Core.scala 556:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 556:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op2_data_T_5) begin // @[Mux.scala 101:16]
        id_reg_rs2_addr_delay <= id_c_rs2_addr;
      end else if (_id_op2_data_T_6) begin // @[Mux.scala 101:16]
        id_reg_rs2_addr_delay <= id_c_rs2p_addr;
      end else begin
        id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_5;
      end
    end
    if (reset) begin // @[Core.scala 557:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 557:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op1_data_T) begin // @[Mux.scala 101:16]
        if (_id_rs1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= 32'h0;
        end else begin
          id_reg_op1_data_delay <= regfile_id_rs1_data_MPORT_data;
        end
      end else if (_id_op1_data_T_1) begin // @[Mux.scala 101:16]
        id_reg_op1_data_delay <= id_reg_pc;
      end else begin
        id_reg_op1_data_delay <= _id_op1_data_T_9;
      end
    end
    if (reset) begin // @[Core.scala 558:40]
      id_reg_op2_data_delay <= 32'h0; // @[Core.scala 558:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_op2_data_T) begin // @[Mux.scala 101:16]
        if (_id_rs2_data_T) begin // @[Mux.scala 101:16]
          id_reg_op2_data_delay <= 32'h0;
        end else begin
          id_reg_op2_data_delay <= regfile_id_rs2_data_MPORT_data;
        end
      end else if (_id_op2_data_T_1) begin // @[Mux.scala 101:16]
        id_reg_op2_data_delay <= id_imm_i_sext;
      end else begin
        id_reg_op2_data_delay <= _id_op2_data_T_27;
      end
    end
    if (reset) begin // @[Core.scala 560:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 560:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h1;
      end else if (_csignals_T_3) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h1;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_210;
      end
    end
    if (reset) begin // @[Core.scala 561:40]
      id_reg_mem_wen_delay <= 2'h0; // @[Core.scala 561:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else if (_csignals_T_3) begin // @[Lookup.scala 34:39]
        id_reg_mem_wen_delay <= 2'h0;
      end else begin
        id_reg_mem_wen_delay <= _csignals_T_420;
      end
    end
    if (reset) begin // @[Core.scala 562:40]
      id_reg_rf_wen_delay <= 2'h0; // @[Core.scala 562:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_rf_wen_delay <= 2'h1;
      end else if (_csignals_T_3) begin // @[Lookup.scala 34:39]
        id_reg_rf_wen_delay <= 2'h1;
      end else begin
        id_reg_rf_wen_delay <= _csignals_T_490;
      end
    end
    if (reset) begin // @[Core.scala 563:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 563:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h1;
      end else if (_csignals_T_3) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h1;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_560;
      end
    end
    if (reset) begin // @[Core.scala 564:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 564:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (csignals_7 == 3'h4) begin // @[Core.scala 517:24]
        id_reg_csr_addr_delay <= 12'h342;
      end else begin
        id_reg_csr_addr_delay <= id_imm_i;
      end
    end
    if (reset) begin // @[Core.scala 565:40]
      id_reg_csr_cmd_delay <= 3'h0; // @[Core.scala 565:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else if (_csignals_T_3) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 3'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_700;
      end
    end
    if (reset) begin // @[Core.scala 568:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 568:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
        id_reg_imm_b_sext_delay <= id_c_imm_b;
      end else begin
        id_reg_imm_b_sext_delay <= id_imm_b_sext;
      end
    end
    if (reset) begin // @[Core.scala 571:40]
      id_reg_mem_w_delay <= 32'h0; // @[Core.scala 571:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_mem_w_delay <= {{29'd0}, csignals_8}; // @[Core.scala 601:29]
    end
    if (reset) begin // @[Core.scala 572:40]
      id_reg_is_bp_pos_delay <= 1'h0; // @[Core.scala 572:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_is_bp_pos_delay <= id_reg_is_bp_pos; // @[Core.scala 602:29]
    end
    if (reset) begin // @[Core.scala 573:40]
      id_reg_bp_addr_delay <= 32'h0; // @[Core.scala 573:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_bp_addr_delay <= id_reg_bp_addr; // @[Core.scala 603:29]
    end
    if (reset) begin // @[Core.scala 574:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 574:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_is_half_delay <= id_is_half; // @[Core.scala 604:29]
    end
    if (reset) begin // @[Core.scala 575:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 575:43]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 605:32]
    end
    if (reset) begin // @[Core.scala 576:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 576:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 606:29]
    end
    if (reset) begin // @[Core.scala 577:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 577:40]
    end else if (_ic_read_en2_T) begin // @[Core.scala 580:23]
      id_reg_mcause_delay <= 32'hb; // @[Core.scala 607:29]
    end
    if (reset) begin // @[Core.scala 730:38]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 730:38]
    end else if (_T_7) begin // @[Core.scala 807:20]
      ex1_reg_fw_en <= _T_6 & ex1_hazard & ex1_reg_wb_sel != 3'h1 & ex1_reg_wb_sel != 3'h3; // @[Core.scala 809:19]
    end
    if (reset) begin // @[Core.scala 733:38]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 733:38]
    end else if (_T_7) begin // @[Core.scala 885:20]
      ex2_reg_fw_en <= ex2_hazard & ex2_reg_wb_sel != 3'h1 & ex2_reg_wb_sel != 3'h3; // @[Core.scala 887:19]
    end
    if (reset) begin // @[Core.scala 735:38]
      ex2_reg_fw_data <= 32'h0; // @[Core.scala 735:38]
    end else if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
      if (ex2_reg_is_half) begin // @[Core.scala 879:38]
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
    if (reset) begin // @[Core.scala 736:38]
      mem_reg_rf_wen_delay <= 2'h0; // @[Core.scala 736:38]
    end else if (mem_en) begin // @[Core.scala 966:23]
      mem_reg_rf_wen_delay <= mem_reg_rf_wen;
    end else begin
      mem_reg_rf_wen_delay <= 2'h0;
    end
    if (reset) begin // @[Core.scala 738:38]
      mem_reg_wb_data_delay <= 32'h0; // @[Core.scala 738:38]
    end else if (_io_dmem_ren_T) begin // @[Core.scala 1074:31]
      mem_reg_wb_data_delay <= mem_wb_data_load;
    end else if (_io_dmem_ren_T) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= mem_wb_data_load;
    end else if (_mem_wb_data_T_1) begin // @[Mux.scala 101:16]
      mem_reg_wb_data_delay <= _mem_wb_data_T_6;
    end else begin
      mem_reg_wb_data_delay <= _mem_wb_data_T_8;
    end
    if (reset) begin // @[Core.scala 739:38]
      wb_reg_rf_wen_delay <= 2'h0; // @[Core.scala 739:38]
    end else begin
      wb_reg_rf_wen_delay <= wb_reg_rf_wen; // @[Core.scala 1091:24]
    end
    if (reset) begin // @[Core.scala 740:38]
      wb_reg_wb_addr_delay <= 5'h0; // @[Core.scala 740:38]
    end else begin
      wb_reg_wb_addr_delay <= wb_reg_wb_addr; // @[Core.scala 1092:24]
    end
    if (reset) begin // @[Core.scala 741:38]
      wb_reg_wb_data_delay <= 32'h0; // @[Core.scala 741:38]
    end else begin
      wb_reg_wb_data_delay <= wb_reg_wb_data; // @[Core.scala 1093:24]
    end
    if (reset) begin // @[Core.scala 1111:24]
      do_exit <= 1'h0; // @[Core.scala 1111:24]
    end else begin
      do_exit <= mem_reg_is_trap & mem_reg_mcause == 32'hb & regfile_do_exit_MPORT_data == 32'h5d; // @[Core.scala 1113:11]
    end
    if (reset) begin // @[Core.scala 1112:30]
      do_exit_delay <= 1'h0; // @[Core.scala 1112:30]
    end else begin
      do_exit_delay <= do_exit; // @[Core.scala 1114:17]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",ic_reg_addr_out,ic_data_out); // @[Core.scala 324:9]
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
            ic_reg_half_rdy); // @[Core.scala 325:9]
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
          $fwrite(32'h80000002,"if2_reg_pc       : 0x%x\n",if2_reg_pc); // @[Core.scala 1117:9]
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
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 1118:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_hit  : 0x%x\n",bp_io_lu_br_hit); // @[Core.scala 1119:9]
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
          $fwrite(32'h80000002,"bp.io.lu.br_pos  : 0x%x\n",bp_io_lu_br_pos); // @[Core.scala 1120:9]
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
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",id_reg_pc); // @[Core.scala 1121:9]
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
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 1122:9]
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
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 1123:9]
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
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 1124:9]
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
          $fwrite(32'h80000002,"id_rs1_data      : 0x%x\n",id_rs1_data); // @[Core.scala 1125:9]
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
          $fwrite(32'h80000002,"id_rs2_data      : 0x%x\n",id_rs2_data); // @[Core.scala 1126:9]
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
          $fwrite(32'h80000002,"id_wb_addr       : 0x%x\n",id_wb_addr); // @[Core.scala 1127:9]
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
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",ex1_reg_pc); // @[Core.scala 1128:9]
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
          $fwrite(32'h80000002,"ex1_stall        : 0x%x\n",ex1_stall); // @[Core.scala 1129:9]
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
          $fwrite(32'h80000002,"ex1_op1_data     : 0x%x\n",ex1_op1_data); // @[Core.scala 1130:9]
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
          $fwrite(32'h80000002,"ex1_op2_data     : 0x%x\n",ex1_op2_data); // @[Core.scala 1131:9]
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
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",ex2_reg_pc); // @[Core.scala 1134:9]
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
          $fwrite(32'h80000002,"ex2_reg_op1_data : 0x%x\n",ex2_reg_op1_data); // @[Core.scala 1135:9]
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
          $fwrite(32'h80000002,"ex2_reg_op2_data : 0x%x\n",ex2_reg_op2_data); // @[Core.scala 1136:9]
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
          $fwrite(32'h80000002,"ex2_alu_out      : 0x%x\n",ex2_alu_out); // @[Core.scala 1137:9]
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
          $fwrite(32'h80000002,"ex2_reg_exe_fun  : 0x%x\n",ex2_reg_exe_fun); // @[Core.scala 1138:9]
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
          $fwrite(32'h80000002,"ex2_reg_wb_sel   : 0x%x\n",ex2_reg_wb_sel); // @[Core.scala 1139:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_bp_pos : 0x%x\n",ex2_reg_is_bp_pos); // @[Core.scala 1140:9]
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
          $fwrite(32'h80000002,"ex2_reg_bp_addr  : 0x%x\n",ex2_reg_bp_addr); // @[Core.scala 1141:9]
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
          $fwrite(32'h80000002,"ex3_reg_pc       : 0x%x\n",ex3_reg_pc); // @[Core.scala 1142:9]
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
          $fwrite(32'h80000002,"ex3_reg_is_br    : 0x%x\n",ex3_reg_is_br); // @[Core.scala 1143:9]
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
          $fwrite(32'h80000002,"ex3_reg_br_target : 0x%x\n",ex3_reg_br_target); // @[Core.scala 1144:9]
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
          $fwrite(32'h80000002,"mem_reg_pc       : 0x%x\n",mem_reg_pc); // @[Core.scala 1145:9]
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
          $fwrite(32'h80000002,"mem_stall        : 0x%x\n",mem_stall); // @[Core.scala 1146:9]
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
          $fwrite(32'h80000002,"mem_wb_data      : 0x%x\n",mem_wb_data); // @[Core.scala 1147:9]
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
          $fwrite(32'h80000002,"mem_reg_mem_w    : 0x%x\n",mem_reg_mem_w); // @[Core.scala 1148:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_addr  : 0x%x\n",mem_reg_wb_addr); // @[Core.scala 1149:9]
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
          $fwrite(32'h80000002,"mem_is_meintr    : %d\n",mem_is_meintr); // @[Core.scala 1150:9]
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
          $fwrite(32'h80000002,"mem_is_mtintr    : %d\n",mem_is_mtintr); // @[Core.scala 1151:9]
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
          $fwrite(32'h80000002,"mem_reg_rf_wen_delay : 0x%x\n",mem_reg_rf_wen_delay); // @[Core.scala 1152:9]
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
          $fwrite(32'h80000002,"mem_wb_addr_delay : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1153:9]
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
          $fwrite(32'h80000002,"mem_reg_wb_data_delay : 0x%x\n",mem_reg_wb_data_delay); // @[Core.scala 1154:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_addr   : 0x%x\n",wb_reg_wb_addr); // @[Core.scala 1155:9]
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
          $fwrite(32'h80000002,"wb_reg_wb_data   : 0x%x\n",wb_reg_wb_data); // @[Core.scala 1156:9]
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
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 1157:9]
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
          $fwrite(32'h80000002,"cycle_counter(%d) : %d\n",do_exit,io_debug_signal_cycle_counter); // @[Core.scala 1158:9]
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
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 1159:9]
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
  ex1_reg_is_bp_pos = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  ex1_reg_bp_addr = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  ex1_reg_is_half = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  ex1_reg_is_valid_inst = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  ex1_reg_is_trap = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  ex1_reg_mcause = _RAND_35[31:0];
  _RAND_36 = {1{`RANDOM}};
  ex2_reg_pc = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  ex2_reg_wb_addr = _RAND_37[4:0];
  _RAND_38 = {1{`RANDOM}};
  ex2_reg_op1_data = _RAND_38[31:0];
  _RAND_39 = {1{`RANDOM}};
  ex2_reg_op2_data = _RAND_39[31:0];
  _RAND_40 = {1{`RANDOM}};
  ex2_reg_rs2_data = _RAND_40[31:0];
  _RAND_41 = {1{`RANDOM}};
  ex2_reg_exe_fun = _RAND_41[4:0];
  _RAND_42 = {1{`RANDOM}};
  ex2_reg_mem_wen = _RAND_42[1:0];
  _RAND_43 = {1{`RANDOM}};
  ex2_reg_rf_wen = _RAND_43[1:0];
  _RAND_44 = {1{`RANDOM}};
  ex2_reg_wb_sel = _RAND_44[2:0];
  _RAND_45 = {1{`RANDOM}};
  ex2_reg_csr_addr = _RAND_45[11:0];
  _RAND_46 = {1{`RANDOM}};
  ex2_reg_csr_cmd = _RAND_46[2:0];
  _RAND_47 = {1{`RANDOM}};
  ex2_reg_imm_b_sext = _RAND_47[31:0];
  _RAND_48 = {1{`RANDOM}};
  ex2_reg_mem_w = _RAND_48[31:0];
  _RAND_49 = {1{`RANDOM}};
  ex2_reg_is_bp_pos = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  ex2_reg_bp_addr = _RAND_50[31:0];
  _RAND_51 = {1{`RANDOM}};
  ex2_reg_is_half = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  ex2_reg_is_valid_inst = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  ex2_reg_is_trap = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  ex2_reg_mcause = _RAND_54[31:0];
  _RAND_55 = {1{`RANDOM}};
  ex3_reg_bp_en = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  ex3_reg_pc = _RAND_56[31:0];
  _RAND_57 = {1{`RANDOM}};
  ex3_reg_is_cond_br = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  ex3_reg_is_cond_br_inst = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  ex3_reg_is_uncond_br = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  ex3_reg_cond_br_target = _RAND_60[31:0];
  _RAND_61 = {1{`RANDOM}};
  ex3_reg_uncond_br_target = _RAND_61[31:0];
  _RAND_62 = {1{`RANDOM}};
  ex3_reg_is_bp_pos = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  ex3_reg_bp_addr = _RAND_63[31:0];
  _RAND_64 = {1{`RANDOM}};
  ex3_reg_is_half = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  mem_reg_en = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  mem_reg_pc = _RAND_66[31:0];
  _RAND_67 = {1{`RANDOM}};
  mem_reg_wb_addr = _RAND_67[4:0];
  _RAND_68 = {1{`RANDOM}};
  mem_reg_op1_data = _RAND_68[31:0];
  _RAND_69 = {1{`RANDOM}};
  mem_reg_rs2_data = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  mem_reg_mem_wen = _RAND_70[1:0];
  _RAND_71 = {1{`RANDOM}};
  mem_reg_rf_wen = _RAND_71[1:0];
  _RAND_72 = {1{`RANDOM}};
  mem_reg_wb_sel = _RAND_72[2:0];
  _RAND_73 = {1{`RANDOM}};
  mem_reg_csr_addr = _RAND_73[11:0];
  _RAND_74 = {1{`RANDOM}};
  mem_reg_csr_cmd = _RAND_74[2:0];
  _RAND_75 = {1{`RANDOM}};
  mem_reg_alu_out = _RAND_75[31:0];
  _RAND_76 = {1{`RANDOM}};
  mem_reg_mem_w = _RAND_76[31:0];
  _RAND_77 = {1{`RANDOM}};
  mem_reg_mem_wstrb = _RAND_77[3:0];
  _RAND_78 = {1{`RANDOM}};
  mem_reg_is_half = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  mem_reg_is_valid_inst = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  mem_reg_is_trap = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  mem_reg_mcause = _RAND_81[31:0];
  _RAND_82 = {1{`RANDOM}};
  wb_reg_wb_addr = _RAND_82[4:0];
  _RAND_83 = {1{`RANDOM}};
  wb_reg_rf_wen = _RAND_83[1:0];
  _RAND_84 = {1{`RANDOM}};
  wb_reg_wb_data = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  wb_reg_is_valid_inst = _RAND_85[0:0];
  _RAND_86 = {1{`RANDOM}};
  if2_reg_is_bp_pos = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  if2_reg_bp_addr = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  if2_reg_is_uncond_br = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  if2_reg_uncond_br_addr = _RAND_89[31:0];
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
  ic_reg_addr_out = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  ic_reg_half = _RAND_97[15:0];
  _RAND_98 = {1{`RANDOM}};
  if1_reg_first = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  if1_reg_next_pc = _RAND_99[31:0];
  _RAND_100 = {1{`RANDOM}};
  if2_reg_pc = _RAND_100[31:0];
  _RAND_101 = {1{`RANDOM}};
  if2_reg_inst = _RAND_101[31:0];
  _RAND_102 = {1{`RANDOM}};
  ex1_reg_hazard = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  ex2_reg_hazard = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  mem_stall_delay = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_105[31:0];
  _RAND_106 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_106[4:0];
  _RAND_107 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_107[2:0];
  _RAND_108 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_108[3:0];
  _RAND_109 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_109[4:0];
  _RAND_110 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_110[4:0];
  _RAND_111 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_111[31:0];
  _RAND_112 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_112[31:0];
  _RAND_113 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_113[4:0];
  _RAND_114 = {1{`RANDOM}};
  id_reg_mem_wen_delay = _RAND_114[1:0];
  _RAND_115 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_115[1:0];
  _RAND_116 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_116[2:0];
  _RAND_117 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_117[11:0];
  _RAND_118 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_118[2:0];
  _RAND_119 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_119[31:0];
  _RAND_120 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_120[31:0];
  _RAND_121 = {1{`RANDOM}};
  id_reg_is_bp_pos_delay = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  id_reg_bp_addr_delay = _RAND_122[31:0];
  _RAND_123 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_126[31:0];
  _RAND_127 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  ex2_reg_fw_data = _RAND_129[31:0];
  _RAND_130 = {1{`RANDOM}};
  mem_reg_rf_wen_delay = _RAND_130[1:0];
  _RAND_131 = {1{`RANDOM}};
  mem_reg_wb_data_delay = _RAND_131[31:0];
  _RAND_132 = {1{`RANDOM}};
  wb_reg_rf_wen_delay = _RAND_132[1:0];
  _RAND_133 = {1{`RANDOM}};
  wb_reg_wb_addr_delay = _RAND_133[4:0];
  _RAND_134 = {1{`RANDOM}};
  wb_reg_wb_data_delay = _RAND_134[31:0];
  _RAND_135 = {1{`RANDOM}};
  do_exit = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  do_exit_delay = _RAND_136[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input         clock,
  input         reset,
  input  [31:0] io_imem_addr,
  output [31:0] io_imem_inst,
  input  [31:0] io_dmem_raddr,
  output [31:0] io_dmem_rdata,
  input         io_dmem_ren,
  output        io_dmem_rvalid,
  input  [31:0] io_dmem_waddr,
  input         io_dmem_wen,
  input  [3:0]  io_dmem_wstrb,
  input  [31:0] io_dmem_wdata,
  output [8:0]  io_imemReadPort_address,
  input  [31:0] io_imemReadPort_data
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] dataMem_0 [0:127]; // @[Memory.scala 39:20]
  wire  dataMem_0_rdata_MPORT_en; // @[Memory.scala 39:20]
  wire [6:0] dataMem_0_rdata_MPORT_addr; // @[Memory.scala 39:20]
  wire [7:0] dataMem_0_rdata_MPORT_data; // @[Memory.scala 39:20]
  wire [7:0] dataMem_0_MPORT_data; // @[Memory.scala 39:20]
  wire [6:0] dataMem_0_MPORT_addr; // @[Memory.scala 39:20]
  wire  dataMem_0_MPORT_mask; // @[Memory.scala 39:20]
  wire  dataMem_0_MPORT_en; // @[Memory.scala 39:20]
  reg [7:0] dataMem_1 [0:127]; // @[Memory.scala 39:20]
  wire  dataMem_1_rdata_MPORT_en; // @[Memory.scala 39:20]
  wire [6:0] dataMem_1_rdata_MPORT_addr; // @[Memory.scala 39:20]
  wire [7:0] dataMem_1_rdata_MPORT_data; // @[Memory.scala 39:20]
  wire [7:0] dataMem_1_MPORT_data; // @[Memory.scala 39:20]
  wire [6:0] dataMem_1_MPORT_addr; // @[Memory.scala 39:20]
  wire  dataMem_1_MPORT_mask; // @[Memory.scala 39:20]
  wire  dataMem_1_MPORT_en; // @[Memory.scala 39:20]
  reg [7:0] dataMem_2 [0:127]; // @[Memory.scala 39:20]
  wire  dataMem_2_rdata_MPORT_en; // @[Memory.scala 39:20]
  wire [6:0] dataMem_2_rdata_MPORT_addr; // @[Memory.scala 39:20]
  wire [7:0] dataMem_2_rdata_MPORT_data; // @[Memory.scala 39:20]
  wire [7:0] dataMem_2_MPORT_data; // @[Memory.scala 39:20]
  wire [6:0] dataMem_2_MPORT_addr; // @[Memory.scala 39:20]
  wire  dataMem_2_MPORT_mask; // @[Memory.scala 39:20]
  wire  dataMem_2_MPORT_en; // @[Memory.scala 39:20]
  reg [7:0] dataMem_3 [0:127]; // @[Memory.scala 39:20]
  wire  dataMem_3_rdata_MPORT_en; // @[Memory.scala 39:20]
  wire [6:0] dataMem_3_rdata_MPORT_addr; // @[Memory.scala 39:20]
  wire [7:0] dataMem_3_rdata_MPORT_data; // @[Memory.scala 39:20]
  wire [7:0] dataMem_3_MPORT_data; // @[Memory.scala 39:20]
  wire [6:0] dataMem_3_MPORT_addr; // @[Memory.scala 39:20]
  wire  dataMem_3_MPORT_mask; // @[Memory.scala 39:20]
  wire  dataMem_3_MPORT_en; // @[Memory.scala 39:20]
  reg [31:0] rdata; // @[Memory.scala 44:22]
  reg  rvalid; // @[Memory.scala 45:23]
  wire  _T = ~io_dmem_wen; // @[Memory.scala 50:9]
  wire  _T_1 = ~io_dmem_wen & io_dmem_ren; // @[Memory.scala 50:22]
  wire [31:0] _rdata_T_2 = {dataMem_3_rdata_MPORT_data,dataMem_2_rdata_MPORT_data,dataMem_1_rdata_MPORT_data,
    dataMem_0_rdata_MPORT_data}; // @[Cat.scala 31:58]
  assign dataMem_0_rdata_MPORT_en = _T & io_dmem_ren;
  assign dataMem_0_rdata_MPORT_addr = io_dmem_raddr[8:2];
  assign dataMem_0_rdata_MPORT_data = dataMem_0[dataMem_0_rdata_MPORT_addr]; // @[Memory.scala 39:20]
  assign dataMem_0_MPORT_data = io_dmem_wdata[7:0];
  assign dataMem_0_MPORT_addr = io_dmem_waddr[8:2];
  assign dataMem_0_MPORT_mask = io_dmem_wstrb[0];
  assign dataMem_0_MPORT_en = io_dmem_wen;
  assign dataMem_1_rdata_MPORT_en = _T & io_dmem_ren;
  assign dataMem_1_rdata_MPORT_addr = io_dmem_raddr[8:2];
  assign dataMem_1_rdata_MPORT_data = dataMem_1[dataMem_1_rdata_MPORT_addr]; // @[Memory.scala 39:20]
  assign dataMem_1_MPORT_data = io_dmem_wdata[15:8];
  assign dataMem_1_MPORT_addr = io_dmem_waddr[8:2];
  assign dataMem_1_MPORT_mask = io_dmem_wstrb[1];
  assign dataMem_1_MPORT_en = io_dmem_wen;
  assign dataMem_2_rdata_MPORT_en = _T & io_dmem_ren;
  assign dataMem_2_rdata_MPORT_addr = io_dmem_raddr[8:2];
  assign dataMem_2_rdata_MPORT_data = dataMem_2[dataMem_2_rdata_MPORT_addr]; // @[Memory.scala 39:20]
  assign dataMem_2_MPORT_data = io_dmem_wdata[23:16];
  assign dataMem_2_MPORT_addr = io_dmem_waddr[8:2];
  assign dataMem_2_MPORT_mask = io_dmem_wstrb[2];
  assign dataMem_2_MPORT_en = io_dmem_wen;
  assign dataMem_3_rdata_MPORT_en = _T & io_dmem_ren;
  assign dataMem_3_rdata_MPORT_addr = io_dmem_raddr[8:2];
  assign dataMem_3_rdata_MPORT_data = dataMem_3[dataMem_3_rdata_MPORT_addr]; // @[Memory.scala 39:20]
  assign dataMem_3_MPORT_data = io_dmem_wdata[31:24];
  assign dataMem_3_MPORT_addr = io_dmem_waddr[8:2];
  assign dataMem_3_MPORT_mask = io_dmem_wstrb[3];
  assign dataMem_3_MPORT_en = io_dmem_wen;
  assign io_imem_inst = io_imemReadPort_data; // @[Memory.scala 35:16]
  assign io_dmem_rdata = rdata; // @[Memory.scala 46:17]
  assign io_dmem_rvalid = rvalid; // @[Memory.scala 47:18]
  assign io_imemReadPort_address = io_imem_addr[10:2]; // @[Memory.scala 36:27]
  always @(posedge clock) begin
    if (dataMem_0_MPORT_en & dataMem_0_MPORT_mask) begin
      dataMem_0[dataMem_0_MPORT_addr] <= dataMem_0_MPORT_data; // @[Memory.scala 39:20]
    end
    if (dataMem_1_MPORT_en & dataMem_1_MPORT_mask) begin
      dataMem_1[dataMem_1_MPORT_addr] <= dataMem_1_MPORT_data; // @[Memory.scala 39:20]
    end
    if (dataMem_2_MPORT_en & dataMem_2_MPORT_mask) begin
      dataMem_2[dataMem_2_MPORT_addr] <= dataMem_2_MPORT_data; // @[Memory.scala 39:20]
    end
    if (dataMem_3_MPORT_en & dataMem_3_MPORT_mask) begin
      dataMem_3[dataMem_3_MPORT_addr] <= dataMem_3_MPORT_data; // @[Memory.scala 39:20]
    end
    if (reset) begin // @[Memory.scala 44:22]
      rdata <= 32'h0; // @[Memory.scala 44:22]
    end else if (~io_dmem_wen & io_dmem_ren) begin // @[Memory.scala 50:39]
      rdata <= _rdata_T_2; // @[Memory.scala 51:11]
    end
    if (reset) begin // @[Memory.scala 45:23]
      rvalid <= 1'h0; // @[Memory.scala 45:23]
    end else begin
      rvalid <= _T_1;
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
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    dataMem_0[initvar] = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    dataMem_1[initvar] = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    dataMem_2[initvar] = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    dataMem_3[initvar] = _RAND_3[7:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  rdata = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  rvalid = _RAND_5[0:0];
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
  assign io_write_address = io_mem_waddr[10:2]; // @[SingleCycleMem.scala 20:20]
  assign io_write_data = io_mem_wdata; // @[SingleCycleMem.scala 22:17]
  assign io_write_enable = io_mem_wen; // @[SingleCycleMem.scala 21:19]
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
    end else if (io_mem_wen) begin // @[Gpio.scala 20:20]
      output_ <= io_mem_wdata; // @[Gpio.scala 21:12]
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
  wire  _GEN_3 = tx_empty ? 1'h0 : tx_empty; // @[Uart.scala 125:23 126:18 102:25]
  wire [31:0] _GEN_4 = tx_empty ? io_mem_wdata : {{24'd0}, tx_data}; // @[Uart.scala 125:23 127:17 104:24]
  wire  _GEN_5 = io_mem_waddr == 32'h4 ? _GEN_3 : tx_empty; // @[Uart.scala 102:25 124:39]
  wire [31:0] _GEN_6 = io_mem_waddr == 32'h4 ? _GEN_4 : {{24'd0}, tx_data}; // @[Uart.scala 104:24 124:39]
  wire  _GEN_8 = io_mem_waddr == 32'h0 ? tx_empty : _GEN_5; // @[Uart.scala 102:25 122:33]
  wire [31:0] _GEN_9 = io_mem_waddr == 32'h0 ? {{24'd0}, tx_data} : _GEN_6; // @[Uart.scala 104:24 122:33]
  wire  _GEN_11 = io_mem_wen ? _GEN_8 : tx_empty; // @[Uart.scala 121:21 102:25]
  wire [31:0] _GEN_12 = io_mem_wen ? _GEN_9 : {{24'd0}, tx_data}; // @[Uart.scala 121:21 104:24]
  wire  tx_ready = tx_io_in_ready;
  wire  _GEN_13 = _tx_io_in_valid_T & tx_ready | _GEN_11; // @[Uart.scala 133:31 134:14]
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
  assign io_intr = tx_empty & tx_intr_en; // @[Uart.scala 137:23]
  assign io_tx = tx_io_tx; // @[Uart.scala 138:9]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = ~tx_empty; // @[Uart.scala 106:21]
  assign tx_io_in_bits = tx_data; // @[Uart.scala 107:17]
  always @(posedge clock) begin
    tx_empty <= reset | _GEN_13; // @[Uart.scala 102:{25,25}]
    tx_data <= _GEN_14[7:0]; // @[Uart.scala 104:{24,24}]
    if (reset) begin // @[Uart.scala 105:27]
      tx_intr_en <= 1'h0; // @[Uart.scala 105:27]
    end else if (io_mem_wen) begin // @[Uart.scala 121:21]
      if (io_mem_waddr == 32'h0) begin // @[Uart.scala 122:33]
        tx_intr_en <= io_mem_wdata[0]; // @[Uart.scala 123:18]
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
  wire [26:0] _io_mem_rdata_T_2 = io_mem_raddr[2] ? 27'h5f5e100 : 27'h1234567; // @[Mux.scala 81:58]
  assign io_mem_rdata = {{5'd0}, _io_mem_rdata_T_2}; // @[Top.scala 17:16]
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
  wire [31:0] _raddr_T_1 = io_initiator_raddr - 32'h8000000; // @[Decoder.scala 40:35]
  wire  _GEN_2 = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? io_targets_0_rvalid : 1'h1; // @[Decoder.scala 39:85 42:14]
  wire [31:0] _GEN_3 = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? io_targets_0_rdata : 32'hdeadbeef
    ; // @[Decoder.scala 39:85 43:13]
  wire [31:0] _waddr_T_1 = io_initiator_waddr - 32'h8000000; // @[Decoder.scala 46:35]
  wire [31:0] _raddr_T_3 = io_initiator_raddr - 32'h20000000; // @[Decoder.scala 40:35]
  wire  _GEN_11 = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h20000200 ? io_targets_1_rvalid : _GEN_2; // @[Decoder.scala 39:85 42:14]
  wire [31:0] _GEN_12 = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h20000200 ? io_targets_1_rdata :
    _GEN_3; // @[Decoder.scala 39:85 43:13]
  wire [31:0] _waddr_T_3 = io_initiator_waddr - 32'h20000000; // @[Decoder.scala 46:35]
  wire [31:0] _GEN_21 = 32'h30000000 <= io_initiator_raddr & io_initiator_raddr < 32'h30000040 ? 32'hdeadbeef : _GEN_12; // @[Decoder.scala 39:85 43:13]
  wire [31:0] _raddr_T_7 = io_initiator_raddr - 32'h30001000; // @[Decoder.scala 40:35]
  wire  _GEN_29 = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? io_targets_3_rvalid : 32'h30000000
     <= io_initiator_raddr & io_initiator_raddr < 32'h30000040 | _GEN_11; // @[Decoder.scala 39:85 42:14]
  wire [31:0] _GEN_30 = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? io_targets_3_rdata :
    _GEN_21; // @[Decoder.scala 39:85 43:13]
  wire [31:0] _waddr_T_7 = io_initiator_waddr - 32'h30001000; // @[Decoder.scala 46:35]
  wire [31:0] _raddr_T_9 = io_initiator_raddr - 32'h30002000; // @[Decoder.scala 40:35]
  wire  _GEN_38 = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? io_targets_4_rvalid : _GEN_29
    ; // @[Decoder.scala 39:85 42:14]
  wire [31:0] _GEN_39 = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? io_targets_4_rdata :
    _GEN_30; // @[Decoder.scala 39:85 43:13]
  wire [31:0] _waddr_T_9 = io_initiator_waddr - 32'h30002000; // @[Decoder.scala 46:35]
  wire [31:0] _raddr_T_11 = io_initiator_raddr - 32'h40000000; // @[Decoder.scala 40:35]
  assign io_initiator_rdata = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 ?
    io_targets_5_rdata : _GEN_39; // @[Decoder.scala 39:85 43:13]
  assign io_initiator_rvalid = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 | _GEN_38; // @[Decoder.scala 39:85 42:14]
  assign io_initiator_wready = 32'h40000000 <= io_initiator_waddr & io_initiator_waddr < 32'h40000040 | (32'h30002000
     <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 | (32'h30001000 <= io_initiator_waddr &
    io_initiator_waddr < 32'h30001040 | (32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 | (32'h20000000
     <= io_initiator_waddr & io_initiator_waddr < 32'h20000200 | 32'h8000000 <= io_initiator_waddr & io_initiator_waddr
     < 32'h8000800)))); // @[Decoder.scala 45:85 50:14]
  assign io_targets_0_raddr = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 ? _raddr_T_1 : 32'h0; // @[Decoder.scala 39:85 40:13]
  assign io_targets_0_ren = 32'h8000000 <= io_initiator_raddr & io_initiator_raddr < 32'h8000800 & io_initiator_ren; // @[Decoder.scala 39:85 41:11]
  assign io_targets_0_waddr = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 ? _waddr_T_1 : 32'h0; // @[Decoder.scala 45:85 46:13]
  assign io_targets_0_wen = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 & io_initiator_wen; // @[Decoder.scala 45:85 47:11]
  assign io_targets_0_wdata = 32'h8000000 <= io_initiator_waddr & io_initiator_waddr < 32'h8000800 ? io_initiator_wdata
     : 32'hdeadbeef; // @[Decoder.scala 45:85 48:13]
  assign io_targets_1_raddr = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h20000200 ? _raddr_T_3 : 32'h0
    ; // @[Decoder.scala 39:85 40:13]
  assign io_targets_1_ren = 32'h20000000 <= io_initiator_raddr & io_initiator_raddr < 32'h20000200 & io_initiator_ren; // @[Decoder.scala 39:85 41:11]
  assign io_targets_1_waddr = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h20000200 ? _waddr_T_3 : 32'h0
    ; // @[Decoder.scala 45:85 46:13]
  assign io_targets_1_wen = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h20000200 & io_initiator_wen; // @[Decoder.scala 45:85 47:11]
  assign io_targets_1_wstrb = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h20000200 ?
    io_initiator_wstrb : 4'hf; // @[Decoder.scala 45:85 49:13]
  assign io_targets_1_wdata = 32'h20000000 <= io_initiator_waddr & io_initiator_waddr < 32'h20000200 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:85 48:13]
  assign io_targets_2_wen = 32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 & io_initiator_wen; // @[Decoder.scala 45:85 47:11]
  assign io_targets_2_wdata = 32'h30000000 <= io_initiator_waddr & io_initiator_waddr < 32'h30000040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:85 48:13]
  assign io_targets_3_raddr = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 ? _raddr_T_7 : 32'h0
    ; // @[Decoder.scala 39:85 40:13]
  assign io_targets_3_ren = 32'h30001000 <= io_initiator_raddr & io_initiator_raddr < 32'h30001040 & io_initiator_ren; // @[Decoder.scala 39:85 41:11]
  assign io_targets_3_waddr = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 ? _waddr_T_7 : 32'h0
    ; // @[Decoder.scala 45:85 46:13]
  assign io_targets_3_wen = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 & io_initiator_wen; // @[Decoder.scala 45:85 47:11]
  assign io_targets_3_wdata = 32'h30001000 <= io_initiator_waddr & io_initiator_waddr < 32'h30001040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:85 48:13]
  assign io_targets_4_raddr = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 ? _raddr_T_9 : 32'h0
    ; // @[Decoder.scala 39:85 40:13]
  assign io_targets_4_ren = 32'h30002000 <= io_initiator_raddr & io_initiator_raddr < 32'h30002040 & io_initiator_ren; // @[Decoder.scala 39:85 41:11]
  assign io_targets_4_waddr = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 ? _waddr_T_9 : 32'h0
    ; // @[Decoder.scala 45:85 46:13]
  assign io_targets_4_wen = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 & io_initiator_wen; // @[Decoder.scala 45:85 47:11]
  assign io_targets_4_wdata = 32'h30002000 <= io_initiator_waddr & io_initiator_waddr < 32'h30002040 ?
    io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:85 48:13]
  assign io_targets_5_raddr = 32'h40000000 <= io_initiator_raddr & io_initiator_raddr < 32'h40000040 ? _raddr_T_11 : 32'h0
    ; // @[Decoder.scala 39:85 40:13]
endmodule
module RiscV(
  input         clock,
  input         reset,
  output [7:0]  io_gpio,
  output        io_uart_tx,
  output        io_exit,
  output [31:0] io_debugSignals_core_mem_reg_pc,
  output [31:0] io_debugSignals_core_csr_rdata,
  output [31:0] io_debugSignals_core_mem_reg_csr_addr,
  output        io_debugSignals_core_me_intr,
  output [31:0] io_debugSignals_core_id_reg_inst,
  output [63:0] io_debugSignals_core_cycle_counter,
  output [63:0] io_debugSignals_core_instret,
  output [31:0] io_debugSignals_raddr,
  output [31:0] io_debugSignals_rdata,
  output        io_debugSignals_ren,
  output        io_debugSignals_rvalid,
  output [31:0] io_debugSignals_waddr,
  output        io_debugSignals_wen,
  output        io_debugSignals_wready,
  output [3:0]  io_debugSignals_wstrb,
  output [31:0] io_debugSignals_wdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  core_clock; // @[Top.scala 51:20]
  wire  core_reset; // @[Top.scala 51:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 51:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 51:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 51:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 51:20]
  wire  core_io_dmem_ren; // @[Top.scala 51:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 51:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 51:20]
  wire  core_io_dmem_wen; // @[Top.scala 51:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 51:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 51:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 51:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 51:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 51:20]
  wire  core_io_mtimer_mem_rvalid; // @[Top.scala 51:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 51:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 51:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 51:20]
  wire  core_io_intr; // @[Top.scala 51:20]
  wire  core_io_exit; // @[Top.scala 51:20]
  wire [31:0] core_io_debug_signal_mem_reg_pc; // @[Top.scala 51:20]
  wire [31:0] core_io_debug_signal_csr_rdata; // @[Top.scala 51:20]
  wire [31:0] core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 51:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 51:20]
  wire [31:0] core_io_debug_signal_id_reg_inst; // @[Top.scala 51:20]
  wire [63:0] core_io_debug_signal_cycle_counter; // @[Top.scala 51:20]
  wire [63:0] core_io_debug_signal_instret; // @[Top.scala 51:20]
  wire  memory_clock; // @[Top.scala 53:22]
  wire  memory_reset; // @[Top.scala 53:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 53:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 53:22]
  wire [31:0] memory_io_dmem_raddr; // @[Top.scala 53:22]
  wire [31:0] memory_io_dmem_rdata; // @[Top.scala 53:22]
  wire  memory_io_dmem_ren; // @[Top.scala 53:22]
  wire  memory_io_dmem_rvalid; // @[Top.scala 53:22]
  wire [31:0] memory_io_dmem_waddr; // @[Top.scala 53:22]
  wire  memory_io_dmem_wen; // @[Top.scala 53:22]
  wire [3:0] memory_io_dmem_wstrb; // @[Top.scala 53:22]
  wire [31:0] memory_io_dmem_wdata; // @[Top.scala 53:22]
  wire [8:0] memory_io_imemReadPort_address; // @[Top.scala 53:22]
  wire [31:0] memory_io_imemReadPort_data; // @[Top.scala 53:22]
  wire  imem_dbus_clock; // @[Top.scala 54:25]
  wire  imem_dbus_reset; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_mem_raddr; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_mem_rdata; // @[Top.scala 54:25]
  wire  imem_dbus_io_mem_ren; // @[Top.scala 54:25]
  wire  imem_dbus_io_mem_rvalid; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_mem_waddr; // @[Top.scala 54:25]
  wire  imem_dbus_io_mem_wen; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_mem_wdata; // @[Top.scala 54:25]
  wire [8:0] imem_dbus_io_read_address; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_read_data; // @[Top.scala 54:25]
  wire  imem_dbus_io_read_enable; // @[Top.scala 54:25]
  wire [8:0] imem_dbus_io_write_address; // @[Top.scala 54:25]
  wire [31:0] imem_dbus_io_write_data; // @[Top.scala 54:25]
  wire  imem_dbus_io_write_enable; // @[Top.scala 54:25]
  wire  gpio_clock; // @[Top.scala 55:20]
  wire  gpio_reset; // @[Top.scala 55:20]
  wire  gpio_io_mem_wen; // @[Top.scala 55:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 55:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 55:20]
  wire  uart_clock; // @[Top.scala 56:20]
  wire  uart_reset; // @[Top.scala 56:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 56:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 56:20]
  wire  uart_io_mem_ren; // @[Top.scala 56:20]
  wire  uart_io_mem_rvalid; // @[Top.scala 56:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 56:20]
  wire  uart_io_mem_wen; // @[Top.scala 56:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 56:20]
  wire  uart_io_intr; // @[Top.scala 56:20]
  wire  uart_io_tx; // @[Top.scala 56:20]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 57:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 57:22]
  wire [31:0] decoder_io_initiator_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_initiator_rdata; // @[Top.scala 59:23]
  wire  decoder_io_initiator_ren; // @[Top.scala 59:23]
  wire  decoder_io_initiator_rvalid; // @[Top.scala 59:23]
  wire [31:0] decoder_io_initiator_waddr; // @[Top.scala 59:23]
  wire  decoder_io_initiator_wen; // @[Top.scala 59:23]
  wire  decoder_io_initiator_wready; // @[Top.scala 59:23]
  wire [3:0] decoder_io_initiator_wstrb; // @[Top.scala 59:23]
  wire [31:0] decoder_io_initiator_wdata; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_0_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_0_rdata; // @[Top.scala 59:23]
  wire  decoder_io_targets_0_ren; // @[Top.scala 59:23]
  wire  decoder_io_targets_0_rvalid; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_0_waddr; // @[Top.scala 59:23]
  wire  decoder_io_targets_0_wen; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_0_wdata; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_1_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_1_rdata; // @[Top.scala 59:23]
  wire  decoder_io_targets_1_ren; // @[Top.scala 59:23]
  wire  decoder_io_targets_1_rvalid; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_1_waddr; // @[Top.scala 59:23]
  wire  decoder_io_targets_1_wen; // @[Top.scala 59:23]
  wire [3:0] decoder_io_targets_1_wstrb; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_1_wdata; // @[Top.scala 59:23]
  wire  decoder_io_targets_2_wen; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_2_wdata; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_3_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_3_rdata; // @[Top.scala 59:23]
  wire  decoder_io_targets_3_ren; // @[Top.scala 59:23]
  wire  decoder_io_targets_3_rvalid; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_3_waddr; // @[Top.scala 59:23]
  wire  decoder_io_targets_3_wen; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_3_wdata; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_4_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_4_rdata; // @[Top.scala 59:23]
  wire  decoder_io_targets_4_ren; // @[Top.scala 59:23]
  wire  decoder_io_targets_4_rvalid; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_4_waddr; // @[Top.scala 59:23]
  wire  decoder_io_targets_4_wen; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_4_wdata; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_5_raddr; // @[Top.scala 59:23]
  wire [31:0] decoder_io_targets_5_rdata; // @[Top.scala 59:23]
  reg [31:0] imem [0:511]; // @[Top.scala 84:17]
  wire  imem_imem_rdata_MPORT_en; // @[Top.scala 84:17]
  wire [8:0] imem_imem_rdata_MPORT_addr; // @[Top.scala 84:17]
  wire [31:0] imem_imem_rdata_MPORT_data; // @[Top.scala 84:17]
  wire  imem_imem_rdata2_MPORT_en; // @[Top.scala 84:17]
  wire [8:0] imem_imem_rdata2_MPORT_addr; // @[Top.scala 84:17]
  wire [31:0] imem_imem_rdata2_MPORT_data; // @[Top.scala 84:17]
  wire [31:0] imem_MPORT_data; // @[Top.scala 84:17]
  wire [8:0] imem_MPORT_addr; // @[Top.scala 84:17]
  wire  imem_MPORT_mask; // @[Top.scala 84:17]
  wire  imem_MPORT_en; // @[Top.scala 84:17]
  reg [31:0] imem_rdata; // @[Top.scala 74:27]
  reg [31:0] imem_rdata2; // @[Top.scala 75:28]
  wire [31:0] _GEN_3 = imem_imem_rdata_MPORT_data; // @[Top.scala 86:40 87:16 74:27]
  wire  _T = ~imem_dbus_io_write_enable; // @[Top.scala 93:9]
  Core core ( // @[Top.scala 51:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
    .io_dmem_raddr(core_io_dmem_raddr),
    .io_dmem_rdata(core_io_dmem_rdata),
    .io_dmem_ren(core_io_dmem_ren),
    .io_dmem_rvalid(core_io_dmem_rvalid),
    .io_dmem_waddr(core_io_dmem_waddr),
    .io_dmem_wen(core_io_dmem_wen),
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
    .io_debug_signal_id_reg_inst(core_io_debug_signal_id_reg_inst),
    .io_debug_signal_cycle_counter(core_io_debug_signal_cycle_counter),
    .io_debug_signal_instret(core_io_debug_signal_instret)
  );
  Memory memory ( // @[Top.scala 53:22]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_imem_addr(memory_io_imem_addr),
    .io_imem_inst(memory_io_imem_inst),
    .io_dmem_raddr(memory_io_dmem_raddr),
    .io_dmem_rdata(memory_io_dmem_rdata),
    .io_dmem_ren(memory_io_dmem_ren),
    .io_dmem_rvalid(memory_io_dmem_rvalid),
    .io_dmem_waddr(memory_io_dmem_waddr),
    .io_dmem_wen(memory_io_dmem_wen),
    .io_dmem_wstrb(memory_io_dmem_wstrb),
    .io_dmem_wdata(memory_io_dmem_wdata),
    .io_imemReadPort_address(memory_io_imemReadPort_address),
    .io_imemReadPort_data(memory_io_imemReadPort_data)
  );
  SingleCycleMem imem_dbus ( // @[Top.scala 54:25]
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
  Gpio gpio ( // @[Top.scala 55:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 56:20]
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
  Config config_ ( // @[Top.scala 57:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder decoder ( // @[Top.scala 59:23]
    .io_initiator_raddr(decoder_io_initiator_raddr),
    .io_initiator_rdata(decoder_io_initiator_rdata),
    .io_initiator_ren(decoder_io_initiator_ren),
    .io_initiator_rvalid(decoder_io_initiator_rvalid),
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
    .io_targets_1_waddr(decoder_io_targets_1_waddr),
    .io_targets_1_wen(decoder_io_targets_1_wen),
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
  assign imem_imem_rdata_MPORT_data = imem[imem_imem_rdata_MPORT_addr]; // @[Top.scala 84:17]
  assign imem_imem_rdata2_MPORT_en = _T & imem_dbus_io_read_enable;
  assign imem_imem_rdata2_MPORT_addr = imem_dbus_io_write_enable ? imem_dbus_io_write_address :
    imem_dbus_io_read_address;
  assign imem_imem_rdata2_MPORT_data = imem[imem_imem_rdata2_MPORT_addr]; // @[Top.scala 84:17]
  assign imem_MPORT_data = imem_dbus_io_write_data;
  assign imem_MPORT_addr = imem_dbus_io_write_enable ? imem_dbus_io_write_address : imem_dbus_io_read_address;
  assign imem_MPORT_mask = 1'h1;
  assign imem_MPORT_en = imem_dbus_io_write_enable;
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 114:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 115:14]
  assign io_exit = core_io_exit; // @[Top.scala 113:11]
  assign io_debugSignals_core_mem_reg_pc = core_io_debug_signal_mem_reg_pc; // @[Top.scala 102:24]
  assign io_debugSignals_core_csr_rdata = core_io_debug_signal_csr_rdata; // @[Top.scala 102:24]
  assign io_debugSignals_core_mem_reg_csr_addr = core_io_debug_signal_mem_reg_csr_addr; // @[Top.scala 102:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 102:24]
  assign io_debugSignals_core_id_reg_inst = core_io_debug_signal_id_reg_inst; // @[Top.scala 102:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 102:24]
  assign io_debugSignals_core_instret = core_io_debug_signal_instret; // @[Top.scala 102:24]
  assign io_debugSignals_raddr = core_io_dmem_raddr; // @[Top.scala 103:26]
  assign io_debugSignals_rdata = decoder_io_initiator_rdata; // @[Top.scala 104:26]
  assign io_debugSignals_ren = core_io_dmem_ren; // @[Top.scala 105:26]
  assign io_debugSignals_rvalid = decoder_io_initiator_rvalid; // @[Top.scala 106:26]
  assign io_debugSignals_waddr = core_io_dmem_waddr; // @[Top.scala 107:26]
  assign io_debugSignals_wen = core_io_dmem_wen; // @[Top.scala 109:26]
  assign io_debugSignals_wready = decoder_io_initiator_wready; // @[Top.scala 110:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 111:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 108:26]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = memory_io_imem_inst; // @[Top.scala 97:16]
  assign core_io_dmem_rdata = decoder_io_initiator_rdata; // @[Top.scala 99:16]
  assign core_io_dmem_rvalid = decoder_io_initiator_rvalid; // @[Top.scala 99:16]
  assign core_io_mtimer_mem_raddr = decoder_io_targets_4_raddr; // @[Top.scala 71:25]
  assign core_io_mtimer_mem_ren = decoder_io_targets_4_ren; // @[Top.scala 71:25]
  assign core_io_mtimer_mem_waddr = decoder_io_targets_4_waddr; // @[Top.scala 71:25]
  assign core_io_mtimer_mem_wen = decoder_io_targets_4_wen; // @[Top.scala 71:25]
  assign core_io_mtimer_mem_wdata = decoder_io_targets_4_wdata; // @[Top.scala 71:25]
  assign core_io_intr = uart_io_intr; // @[Top.scala 116:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_addr = core_io_imem_addr; // @[Top.scala 97:16]
  assign memory_io_dmem_raddr = decoder_io_targets_1_raddr; // @[Top.scala 68:25]
  assign memory_io_dmem_ren = decoder_io_targets_1_ren; // @[Top.scala 68:25]
  assign memory_io_dmem_waddr = decoder_io_targets_1_waddr; // @[Top.scala 68:25]
  assign memory_io_dmem_wen = decoder_io_targets_1_wen; // @[Top.scala 68:25]
  assign memory_io_dmem_wstrb = decoder_io_targets_1_wstrb; // @[Top.scala 68:25]
  assign memory_io_dmem_wdata = decoder_io_targets_1_wdata; // @[Top.scala 68:25]
  assign memory_io_imemReadPort_data = imem_rdata; // @[Top.scala 76:31]
  assign imem_dbus_clock = clock;
  assign imem_dbus_reset = reset;
  assign imem_dbus_io_mem_raddr = decoder_io_targets_0_raddr; // @[Top.scala 67:25]
  assign imem_dbus_io_mem_ren = decoder_io_targets_0_ren; // @[Top.scala 67:25]
  assign imem_dbus_io_mem_waddr = decoder_io_targets_0_waddr; // @[Top.scala 67:25]
  assign imem_dbus_io_mem_wen = decoder_io_targets_0_wen; // @[Top.scala 67:25]
  assign imem_dbus_io_mem_wdata = decoder_io_targets_0_wdata; // @[Top.scala 67:25]
  assign imem_dbus_io_read_data = imem_rdata2; // @[Top.scala 77:26]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = decoder_io_targets_2_wen; // @[Top.scala 69:25]
  assign gpio_io_mem_wdata = decoder_io_targets_2_wdata; // @[Top.scala 69:25]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = decoder_io_targets_3_raddr; // @[Top.scala 70:25]
  assign uart_io_mem_ren = decoder_io_targets_3_ren; // @[Top.scala 70:25]
  assign uart_io_mem_waddr = decoder_io_targets_3_waddr; // @[Top.scala 70:25]
  assign uart_io_mem_wen = decoder_io_targets_3_wen; // @[Top.scala 70:25]
  assign uart_io_mem_wdata = decoder_io_targets_3_wdata; // @[Top.scala 70:25]
  assign config__io_mem_raddr = decoder_io_targets_5_raddr; // @[Top.scala 72:25]
  assign decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 99:16]
  assign decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 99:16]
  assign decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 99:16]
  assign decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 99:16]
  assign decoder_io_initiator_wstrb = core_io_dmem_wstrb; // @[Top.scala 99:16]
  assign decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 99:16]
  assign decoder_io_targets_0_rdata = imem_dbus_io_mem_rdata; // @[Top.scala 67:25]
  assign decoder_io_targets_0_rvalid = imem_dbus_io_mem_rvalid; // @[Top.scala 67:25]
  assign decoder_io_targets_1_rdata = memory_io_dmem_rdata; // @[Top.scala 68:25]
  assign decoder_io_targets_1_rvalid = memory_io_dmem_rvalid; // @[Top.scala 68:25]
  assign decoder_io_targets_3_rdata = uart_io_mem_rdata; // @[Top.scala 70:25]
  assign decoder_io_targets_3_rvalid = uart_io_mem_rvalid; // @[Top.scala 70:25]
  assign decoder_io_targets_4_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 71:25]
  assign decoder_io_targets_4_rvalid = core_io_mtimer_mem_rvalid; // @[Top.scala 71:25]
  assign decoder_io_targets_5_rdata = config__io_mem_rdata; // @[Top.scala 72:25]
  always @(posedge clock) begin
    if (imem_MPORT_en & imem_MPORT_mask) begin
      imem[imem_MPORT_addr] <= imem_MPORT_data; // @[Top.scala 84:17]
    end
    if (reset) begin // @[Top.scala 74:27]
      imem_rdata <= 32'h0; // @[Top.scala 74:27]
    end else begin
      imem_rdata <= _GEN_3;
    end
    if (reset) begin // @[Top.scala 75:28]
      imem_rdata2 <= 32'h0; // @[Top.scala 75:28]
    end else if (~imem_dbus_io_write_enable & imem_dbus_io_read_enable) begin // @[Top.scala 93:65]
      imem_rdata2 <= imem_imem_rdata2_MPORT_data; // @[Top.scala 94:17]
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
