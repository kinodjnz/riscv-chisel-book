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
  reg [63:0] mtime; // @[MachineTimer.scala 15:22]
  reg [63:0] mtimecmp; // @[MachineTimer.scala 16:25]
  reg  intr; // @[MachineTimer.scala 17:21]
  wire [63:0] _mtime_T_1 = mtime + 64'h1; // @[MachineTimer.scala 19:18]
  wire [31:0] _GEN_0 = 2'h3 == io_mem_raddr[3:2] ? mtimecmp[63:32] : 32'hdeadbeef; // @[MachineTimer.scala 25:16 30:33 41:22]
  wire [31:0] _GEN_1 = 2'h2 == io_mem_raddr[3:2] ? mtimecmp[31:0] : _GEN_0; // @[MachineTimer.scala 30:33 38:22]
  wire [31:0] _GEN_2 = 2'h1 == io_mem_raddr[3:2] ? mtime[63:32] : _GEN_1; // @[MachineTimer.scala 30:33 35:22]
  wire [31:0] _GEN_3 = 2'h0 == io_mem_raddr[3:2] ? mtime[31:0] : _GEN_2; // @[MachineTimer.scala 30:33 32:22]
  wire [63:0] _mtime_T_3 = {mtime[63:32],io_mem_wdata}; // @[Cat.scala 33:92]
  wire [63:0] _mtime_T_5 = {io_mem_wdata,mtime[31:0]}; // @[Cat.scala 33:92]
  wire [63:0] _mtimecmp_T_1 = {mtimecmp[63:32],io_mem_wdata}; // @[Cat.scala 33:92]
  wire [63:0] _mtimecmp_T_3 = {io_mem_wdata,mtimecmp[31:0]}; // @[Cat.scala 33:92]
  wire [63:0] _GEN_5 = 2'h3 == io_mem_waddr[3:2] ? _mtimecmp_T_3 : mtimecmp; // @[MachineTimer.scala 47:33 58:18 16:25]
  wire [63:0] _GEN_6 = 2'h2 == io_mem_waddr[3:2] ? _mtimecmp_T_1 : _GEN_5; // @[MachineTimer.scala 47:33 55:18]
  assign io_mem_rdata = io_mem_ren ? _GEN_3 : 32'hdeadbeef; // @[MachineTimer.scala 25:16 29:21]
  assign io_intr = intr; // @[MachineTimer.scala 21:11]
  assign io_mtime = mtime; // @[MachineTimer.scala 22:12]
  always @(posedge clock) begin
    if (reset) begin // @[MachineTimer.scala 15:22]
      mtime <= 64'h0; // @[MachineTimer.scala 15:22]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 46:21]
      if (2'h0 == io_mem_waddr[3:2]) begin // @[MachineTimer.scala 47:33]
        mtime <= _mtime_T_3; // @[MachineTimer.scala 49:15]
      end else if (2'h1 == io_mem_waddr[3:2]) begin // @[MachineTimer.scala 47:33]
        mtime <= _mtime_T_5; // @[MachineTimer.scala 52:15]
      end else begin
        mtime <= _mtime_T_1; // @[MachineTimer.scala 19:9]
      end
    end else begin
      mtime <= _mtime_T_1; // @[MachineTimer.scala 19:9]
    end
    if (reset) begin // @[MachineTimer.scala 16:25]
      mtimecmp <= 64'hffffffff; // @[MachineTimer.scala 16:25]
    end else if (io_mem_wen) begin // @[MachineTimer.scala 46:21]
      if (!(2'h0 == io_mem_waddr[3:2])) begin // @[MachineTimer.scala 47:33]
        if (!(2'h1 == io_mem_waddr[3:2])) begin // @[MachineTimer.scala 47:33]
          mtimecmp <= _GEN_6;
        end
      end
    end
    if (reset) begin // @[MachineTimer.scala 17:21]
      intr <= 1'h0; // @[MachineTimer.scala 17:21]
    end else begin
      intr <= mtime >= mtimecmp; // @[MachineTimer.scala 20:8]
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
module BTB(
  input         clock,
  input         reset,
  input  [30:0] io_lu_pc,
  output        io_lu_matches0,
  output [30:0] io_lu_taken_pc0,
  output        io_lu_matches1,
  output [30:0] io_lu_taken_pc1,
  input         io_up_en,
  input  [30:0] io_up_pc,
  input  [30:0] io_up_taken_pc
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
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [17:0] btb0_tag [0:255]; // @[BranchPredictor.scala 58:17]
  wire  btb0_tag_reg_entry0_MPORT_en; // @[BranchPredictor.scala 58:17]
  wire [7:0] btb0_tag_reg_entry0_MPORT_addr; // @[BranchPredictor.scala 58:17]
  wire [17:0] btb0_tag_reg_entry0_MPORT_data; // @[BranchPredictor.scala 58:17]
  wire [17:0] btb0_tag_MPORT_data; // @[BranchPredictor.scala 58:17]
  wire [7:0] btb0_tag_MPORT_addr; // @[BranchPredictor.scala 58:17]
  wire  btb0_tag_MPORT_mask; // @[BranchPredictor.scala 58:17]
  wire  btb0_tag_MPORT_en; // @[BranchPredictor.scala 58:17]
  reg [30:0] btb0_taken_pc [0:255]; // @[BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_reg_entry0_MPORT_en; // @[BranchPredictor.scala 58:17]
  wire [7:0] btb0_taken_pc_reg_entry0_MPORT_addr; // @[BranchPredictor.scala 58:17]
  wire [30:0] btb0_taken_pc_reg_entry0_MPORT_data; // @[BranchPredictor.scala 58:17]
  wire [30:0] btb0_taken_pc_MPORT_data; // @[BranchPredictor.scala 58:17]
  wire [7:0] btb0_taken_pc_MPORT_addr; // @[BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_MPORT_mask; // @[BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_MPORT_en; // @[BranchPredictor.scala 58:17]
  reg [17:0] btb1_tag [0:255]; // @[BranchPredictor.scala 59:17]
  wire  btb1_tag_reg_entry1_MPORT_en; // @[BranchPredictor.scala 59:17]
  wire [7:0] btb1_tag_reg_entry1_MPORT_addr; // @[BranchPredictor.scala 59:17]
  wire [17:0] btb1_tag_reg_entry1_MPORT_data; // @[BranchPredictor.scala 59:17]
  wire [17:0] btb1_tag_MPORT_1_data; // @[BranchPredictor.scala 59:17]
  wire [7:0] btb1_tag_MPORT_1_addr; // @[BranchPredictor.scala 59:17]
  wire  btb1_tag_MPORT_1_mask; // @[BranchPredictor.scala 59:17]
  wire  btb1_tag_MPORT_1_en; // @[BranchPredictor.scala 59:17]
  reg [30:0] btb1_taken_pc [0:255]; // @[BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_reg_entry1_MPORT_en; // @[BranchPredictor.scala 59:17]
  wire [7:0] btb1_taken_pc_reg_entry1_MPORT_addr; // @[BranchPredictor.scala 59:17]
  wire [30:0] btb1_taken_pc_reg_entry1_MPORT_data; // @[BranchPredictor.scala 59:17]
  wire [30:0] btb1_taken_pc_MPORT_1_data; // @[BranchPredictor.scala 59:17]
  wire [7:0] btb1_taken_pc_MPORT_1_addr; // @[BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_MPORT_1_mask; // @[BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_MPORT_1_en; // @[BranchPredictor.scala 59:17]
  reg [17:0] reg_entry0_tag; // @[BranchPredictor.scala 61:27]
  reg [30:0] reg_entry0_taken_pc; // @[BranchPredictor.scala 61:27]
  reg [17:0] reg_entry1_tag; // @[BranchPredictor.scala 62:27]
  reg [30:0] reg_entry1_taken_pc; // @[BranchPredictor.scala 62:27]
  wire [17:0] lu_pc_tag = io_lu_pc[26:9]; // @[BranchPredictor.scala 64:62]
  reg [17:0] reg_lu_pc_tag; // @[BranchPredictor.scala 65:30]
  wire [17:0] up_pc_tag = io_up_pc[26:9]; // @[BranchPredictor.scala 75:62]
  wire  _T_1 = ~io_up_pc[0]; // @[BranchPredictor.scala 76:21]
  wire [48:0] _T_3 = {up_pc_tag,io_up_taken_pc}; // @[Cat.scala 33:92]
  assign btb0_tag_reg_entry0_MPORT_en = 1'h1;
  assign btb0_tag_reg_entry0_MPORT_addr = io_lu_pc[8:1];
  assign btb0_tag_reg_entry0_MPORT_data = btb0_tag[btb0_tag_reg_entry0_MPORT_addr]; // @[BranchPredictor.scala 58:17]
  assign btb0_tag_MPORT_data = _T_3[48:31];
  assign btb0_tag_MPORT_addr = io_up_pc[8:1];
  assign btb0_tag_MPORT_mask = 1'h1;
  assign btb0_tag_MPORT_en = io_up_en & _T_1;
  assign btb0_taken_pc_reg_entry0_MPORT_en = 1'h1;
  assign btb0_taken_pc_reg_entry0_MPORT_addr = io_lu_pc[8:1];
  assign btb0_taken_pc_reg_entry0_MPORT_data = btb0_taken_pc[btb0_taken_pc_reg_entry0_MPORT_addr]; // @[BranchPredictor.scala 58:17]
  assign btb0_taken_pc_MPORT_data = _T_3[30:0];
  assign btb0_taken_pc_MPORT_addr = io_up_pc[8:1];
  assign btb0_taken_pc_MPORT_mask = 1'h1;
  assign btb0_taken_pc_MPORT_en = io_up_en & _T_1;
  assign btb1_tag_reg_entry1_MPORT_en = 1'h1;
  assign btb1_tag_reg_entry1_MPORT_addr = io_lu_pc[8:1];
  assign btb1_tag_reg_entry1_MPORT_data = btb1_tag[btb1_tag_reg_entry1_MPORT_addr]; // @[BranchPredictor.scala 59:17]
  assign btb1_tag_MPORT_1_data = _T_3[48:31];
  assign btb1_tag_MPORT_1_addr = io_up_pc[8:1];
  assign btb1_tag_MPORT_1_mask = 1'h1;
  assign btb1_tag_MPORT_1_en = io_up_en & io_up_pc[0];
  assign btb1_taken_pc_reg_entry1_MPORT_en = 1'h1;
  assign btb1_taken_pc_reg_entry1_MPORT_addr = io_lu_pc[8:1];
  assign btb1_taken_pc_reg_entry1_MPORT_data = btb1_taken_pc[btb1_taken_pc_reg_entry1_MPORT_addr]; // @[BranchPredictor.scala 59:17]
  assign btb1_taken_pc_MPORT_1_data = _T_3[30:0];
  assign btb1_taken_pc_MPORT_1_addr = io_up_pc[8:1];
  assign btb1_taken_pc_MPORT_1_mask = 1'h1;
  assign btb1_taken_pc_MPORT_1_en = io_up_en & io_up_pc[0];
  assign io_lu_matches0 = reg_entry0_tag == reg_lu_pc_tag; // @[BranchPredictor.scala 70:38]
  assign io_lu_taken_pc0 = reg_entry0_taken_pc; // @[BranchPredictor.scala 71:19]
  assign io_lu_matches1 = reg_entry1_tag == reg_lu_pc_tag; // @[BranchPredictor.scala 72:38]
  assign io_lu_taken_pc1 = reg_entry1_taken_pc; // @[BranchPredictor.scala 73:19]
  always @(posedge clock) begin
    if (btb0_tag_MPORT_en & btb0_tag_MPORT_mask) begin
      btb0_tag[btb0_tag_MPORT_addr] <= btb0_tag_MPORT_data; // @[BranchPredictor.scala 58:17]
    end
    if (btb0_taken_pc_MPORT_en & btb0_taken_pc_MPORT_mask) begin
      btb0_taken_pc[btb0_taken_pc_MPORT_addr] <= btb0_taken_pc_MPORT_data; // @[BranchPredictor.scala 58:17]
    end
    if (btb1_tag_MPORT_1_en & btb1_tag_MPORT_1_mask) begin
      btb1_tag[btb1_tag_MPORT_1_addr] <= btb1_tag_MPORT_1_data; // @[BranchPredictor.scala 59:17]
    end
    if (btb1_taken_pc_MPORT_1_en & btb1_taken_pc_MPORT_1_mask) begin
      btb1_taken_pc[btb1_taken_pc_MPORT_1_addr] <= btb1_taken_pc_MPORT_1_data; // @[BranchPredictor.scala 59:17]
    end
    if (reset) begin // @[BranchPredictor.scala 61:27]
      reg_entry0_tag <= 18'h0; // @[BranchPredictor.scala 61:27]
    end else begin
      reg_entry0_tag <= btb0_tag_reg_entry0_MPORT_data; // @[BranchPredictor.scala 67:14]
    end
    if (reset) begin // @[BranchPredictor.scala 61:27]
      reg_entry0_taken_pc <= 31'h0; // @[BranchPredictor.scala 61:27]
    end else begin
      reg_entry0_taken_pc <= btb0_taken_pc_reg_entry0_MPORT_data; // @[BranchPredictor.scala 67:14]
    end
    if (reset) begin // @[BranchPredictor.scala 62:27]
      reg_entry1_tag <= 18'h0; // @[BranchPredictor.scala 62:27]
    end else begin
      reg_entry1_tag <= btb1_tag_reg_entry1_MPORT_data; // @[BranchPredictor.scala 68:14]
    end
    if (reset) begin // @[BranchPredictor.scala 62:27]
      reg_entry1_taken_pc <= 31'h0; // @[BranchPredictor.scala 62:27]
    end else begin
      reg_entry1_taken_pc <= btb1_taken_pc_reg_entry1_MPORT_data; // @[BranchPredictor.scala 68:14]
    end
    if (reset) begin // @[BranchPredictor.scala 65:30]
      reg_lu_pc_tag <= 18'h0; // @[BranchPredictor.scala 65:30]
    end else begin
      reg_lu_pc_tag <= lu_pc_tag; // @[BranchPredictor.scala 65:30]
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
    btb0_tag[initvar] = _RAND_0[17:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    btb0_taken_pc[initvar] = _RAND_1[30:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    btb1_tag[initvar] = _RAND_2[17:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    btb1_taken_pc[initvar] = _RAND_3[30:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  reg_entry0_tag = _RAND_4[17:0];
  _RAND_5 = {1{`RANDOM}};
  reg_entry0_taken_pc = _RAND_5[30:0];
  _RAND_6 = {1{`RANDOM}};
  reg_entry1_tag = _RAND_6[17:0];
  _RAND_7 = {1{`RANDOM}};
  reg_entry1_taken_pc = _RAND_7[30:0];
  _RAND_8 = {1{`RANDOM}};
  reg_lu_pc_tag = _RAND_8[17:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PHT(
  input  [30:0] io_lu_pc,
  output [1:0]  io_lu_cnt0,
  output [1:0]  io_lu_cnt1,
  input         io_up_en,
  input  [30:0] io_up_pc,
  input  [1:0]  io_up_cnt,
  output        io_mem_wen,
  output [11:0] io_mem_raddr,
  input  [3:0]  io_mem_rdata,
  output [12:0] io_mem_waddr,
  output [1:0]  io_mem_wdata
);
  assign io_lu_cnt0 = io_mem_rdata[1:0]; // @[BranchPredictor.scala 94:20]
  assign io_lu_cnt1 = io_mem_rdata[3:2]; // @[BranchPredictor.scala 95:20]
  assign io_mem_wen = io_up_en; // @[BranchPredictor.scala 97:16]
  assign io_mem_raddr = io_lu_pc[12:1]; // @[BranchPredictor.scala 92:27]
  assign io_mem_waddr = io_up_pc[12:0]; // @[BranchPredictor.scala 98:27]
  assign io_mem_wdata = io_up_cnt; // @[BranchPredictor.scala 99:16]
endmodule
module Core(
  input         clock,
  input         reset,
  output [31:0] io_imem_addr,
  input  [31:0] io_imem_inst,
  input         io_imem_valid,
  output [31:0] io_dmem_raddr,
  input  [31:0] io_dmem_rdata,
  output        io_dmem_ren,
  input         io_dmem_rvalid,
  output [31:0] io_dmem_waddr,
  output        io_dmem_wen,
  input         io_dmem_wready,
  output [3:0]  io_dmem_wstrb,
  output [31:0] io_dmem_wdata,
  output        io_cache_iinvalidate,
  input         io_cache_ibusy,
  output [31:0] io_cache_raddr,
  input  [31:0] io_cache_rdata,
  output        io_cache_ren,
  input         io_cache_rvalid,
  input         io_cache_rready,
  output [31:0] io_cache_waddr,
  output        io_cache_wen,
  input         io_cache_wready,
  output [3:0]  io_cache_wstrb,
  output [31:0] io_cache_wdata,
  output        io_pht_mem_wen,
  output [11:0] io_pht_mem_raddr,
  input  [3:0]  io_pht_mem_rdata,
  output [12:0] io_pht_mem_waddr,
  output [1:0]  io_pht_mem_wdata,
  input  [31:0] io_mtimer_mem_raddr,
  output [31:0] io_mtimer_mem_rdata,
  input         io_mtimer_mem_ren,
  input  [31:0] io_mtimer_mem_waddr,
  input         io_mtimer_mem_wen,
  input  [31:0] io_mtimer_mem_wdata,
  input         io_intr,
  output [31:0] io_debug_signal_ex2_reg_pc,
  output        io_debug_signal_ex2_is_valid_inst,
  output        io_debug_signal_me_intr,
  output        io_debug_signal_mt_intr,
  output        io_debug_signal_trap,
  output [47:0] io_debug_signal_cycle_counter,
  output [31:0] io_debug_signal_id_pc,
  output [31:0] io_debug_signal_id_inst,
  output [31:0] io_debug_signal_mem3_rdata,
  output        io_debug_signal_mem3_rvalid,
  output [31:0] io_debug_signal_rwaddr,
  output        io_debug_signal_ex2_reg_is_br,
  output        io_debug_signal_id_reg_is_bp_fail,
  output        io_debug_signal_if2_reg_bp_taken,
  output [2:0]  io_debug_signal_ic_state
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
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
  reg [63:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [63:0] _RAND_76;
  reg [63:0] _RAND_77;
  reg [63:0] _RAND_78;
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
  reg [63:0] _RAND_94;
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
  reg [63:0] _RAND_184;
  reg [63:0] _RAND_185;
  reg [63:0] _RAND_186;
  reg [31:0] _RAND_187;
  reg [31:0] _RAND_188;
  reg [31:0] _RAND_189;
  reg [31:0] _RAND_190;
  reg [31:0] _RAND_191;
  reg [31:0] _RAND_192;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[Core.scala 133:20]
  wire  regfile_rrd_op1_data_MPORT_en; // @[Core.scala 133:20]
  wire [4:0] regfile_rrd_op1_data_MPORT_addr; // @[Core.scala 133:20]
  wire [31:0] regfile_rrd_op1_data_MPORT_data; // @[Core.scala 133:20]
  wire  regfile_rrd_op2_data_MPORT_en; // @[Core.scala 133:20]
  wire [4:0] regfile_rrd_op2_data_MPORT_addr; // @[Core.scala 133:20]
  wire [31:0] regfile_rrd_op2_data_MPORT_data; // @[Core.scala 133:20]
  wire  regfile_rrd_op3_data_MPORT_en; // @[Core.scala 133:20]
  wire [4:0] regfile_rrd_op3_data_MPORT_addr; // @[Core.scala 133:20]
  wire [31:0] regfile_rrd_op3_data_MPORT_data; // @[Core.scala 133:20]
  wire [31:0] regfile_MPORT_3_data; // @[Core.scala 133:20]
  wire [4:0] regfile_MPORT_3_addr; // @[Core.scala 133:20]
  wire  regfile_MPORT_3_mask; // @[Core.scala 133:20]
  wire  regfile_MPORT_3_en; // @[Core.scala 133:20]
  wire [31:0] regfile_MPORT_4_data; // @[Core.scala 133:20]
  wire [4:0] regfile_MPORT_4_addr; // @[Core.scala 133:20]
  wire  regfile_MPORT_4_mask; // @[Core.scala 133:20]
  wire  regfile_MPORT_4_en; // @[Core.scala 133:20]
  wire  cycle_counter_clock; // @[Core.scala 135:29]
  wire  cycle_counter_reset; // @[Core.scala 135:29]
  wire [63:0] cycle_counter_io_value; // @[Core.scala 135:29]
  wire  mtimer_clock; // @[Core.scala 136:22]
  wire  mtimer_reset; // @[Core.scala 136:22]
  wire [31:0] mtimer_io_mem_raddr; // @[Core.scala 136:22]
  wire [31:0] mtimer_io_mem_rdata; // @[Core.scala 136:22]
  wire  mtimer_io_mem_ren; // @[Core.scala 136:22]
  wire [31:0] mtimer_io_mem_waddr; // @[Core.scala 136:22]
  wire  mtimer_io_mem_wen; // @[Core.scala 136:22]
  wire [31:0] mtimer_io_mem_wdata; // @[Core.scala 136:22]
  wire  mtimer_io_intr; // @[Core.scala 136:22]
  wire [63:0] mtimer_io_mtime; // @[Core.scala 136:22]
  reg  scoreboard [0:31]; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_en; // @[Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_addr; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_data; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_1_en; // @[Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_1_addr; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_1_data; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_2_en; // @[Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_2_addr; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_2_data; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_3_en; // @[Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_3_addr; // @[Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_3_data; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_data; // @[Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_addr; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_mask; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_en; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_1_data; // @[Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_1_addr; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_1_mask; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_1_en; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_2_data; // @[Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_2_addr; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_2_mask; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_2_en; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_5_data; // @[Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_5_addr; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_5_mask; // @[Core.scala 149:25]
  wire  scoreboard_MPORT_5_en; // @[Core.scala 149:25]
  wire  ic_btb_clock; // @[Core.scala 358:22]
  wire  ic_btb_reset; // @[Core.scala 358:22]
  wire [30:0] ic_btb_io_lu_pc; // @[Core.scala 358:22]
  wire  ic_btb_io_lu_matches0; // @[Core.scala 358:22]
  wire [30:0] ic_btb_io_lu_taken_pc0; // @[Core.scala 358:22]
  wire  ic_btb_io_lu_matches1; // @[Core.scala 358:22]
  wire [30:0] ic_btb_io_lu_taken_pc1; // @[Core.scala 358:22]
  wire  ic_btb_io_up_en; // @[Core.scala 358:22]
  wire [30:0] ic_btb_io_up_pc; // @[Core.scala 358:22]
  wire [30:0] ic_btb_io_up_taken_pc; // @[Core.scala 358:22]
  wire [30:0] ic_pht_io_lu_pc; // @[Core.scala 359:22]
  wire [1:0] ic_pht_io_lu_cnt0; // @[Core.scala 359:22]
  wire [1:0] ic_pht_io_lu_cnt1; // @[Core.scala 359:22]
  wire  ic_pht_io_up_en; // @[Core.scala 359:22]
  wire [30:0] ic_pht_io_up_pc; // @[Core.scala 359:22]
  wire [1:0] ic_pht_io_up_cnt; // @[Core.scala 359:22]
  wire  ic_pht_io_mem_wen; // @[Core.scala 359:22]
  wire [11:0] ic_pht_io_mem_raddr; // @[Core.scala 359:22]
  wire [3:0] ic_pht_io_mem_rdata; // @[Core.scala 359:22]
  wire [12:0] ic_pht_io_mem_waddr; // @[Core.scala 359:22]
  wire [1:0] ic_pht_io_mem_wdata; // @[Core.scala 359:22]
  reg [63:0] instret; // @[Core.scala 138:24]
  reg [30:0] csr_reg_trap_vector; // @[Core.scala 139:37]
  reg [31:0] csr_reg_mcause; // @[Core.scala 140:37]
  reg [30:0] csr_reg_mepc; // @[Core.scala 142:37]
  reg  csr_reg_mstatus_mie; // @[Core.scala 143:37]
  reg  csr_reg_mstatus_mpie; // @[Core.scala 144:37]
  reg [31:0] csr_reg_mscratch; // @[Core.scala 145:37]
  reg  csr_reg_mie_meie; // @[Core.scala 146:37]
  reg  csr_reg_mie_mtie; // @[Core.scala 147:37]
  reg  id_reg_stall; // @[Core.scala 157:38]
  reg [30:0] rrd_reg_pc; // @[Core.scala 164:38]
  reg [4:0] rrd_reg_wb_addr; // @[Core.scala 165:38]
  reg  rrd_reg_op1_sel; // @[Core.scala 166:38]
  reg  rrd_reg_op2_sel; // @[Core.scala 167:38]
  reg [1:0] rrd_reg_op3_sel; // @[Core.scala 168:38]
  reg [4:0] rrd_reg_rs1_addr; // @[Core.scala 169:38]
  reg [4:0] rrd_reg_rs2_addr; // @[Core.scala 170:38]
  reg [4:0] rrd_reg_rs3_addr; // @[Core.scala 171:38]
  reg [31:0] rrd_reg_op1_data; // @[Core.scala 172:38]
  reg [31:0] rrd_reg_op2_data; // @[Core.scala 173:38]
  reg [4:0] rrd_reg_exe_fun; // @[Core.scala 174:38]
  reg  rrd_reg_rf_wen; // @[Core.scala 175:38]
  reg [2:0] rrd_reg_wb_sel; // @[Core.scala 176:38]
  reg [11:0] rrd_reg_csr_addr; // @[Core.scala 177:38]
  reg [1:0] rrd_reg_csr_cmd; // @[Core.scala 178:38]
  reg [31:0] rrd_reg_imm_b_sext; // @[Core.scala 179:38]
  reg [2:0] rrd_reg_mem_w; // @[Core.scala 180:38]
  reg  rrd_reg_is_br; // @[Core.scala 182:38]
  reg  rrd_reg_is_j; // @[Core.scala 183:38]
  reg  rrd_reg_bp_taken; // @[Core.scala 184:38]
  reg [30:0] rrd_reg_bp_taken_pc; // @[Core.scala 185:38]
  reg [1:0] rrd_reg_bp_cnt; // @[Core.scala 186:38]
  reg  rrd_reg_is_half; // @[Core.scala 187:38]
  reg  rrd_reg_is_valid_inst; // @[Core.scala 188:38]
  reg  rrd_reg_is_trap; // @[Core.scala 189:38]
  reg [31:0] rrd_reg_mcause; // @[Core.scala 190:38]
  reg [30:0] ex1_reg_pc; // @[Core.scala 194:38]
  reg [4:0] ex1_reg_wb_addr; // @[Core.scala 195:38]
  reg [31:0] ex1_reg_op1_data; // @[Core.scala 196:38]
  reg [31:0] ex1_reg_op2_data; // @[Core.scala 197:38]
  reg [31:0] ex1_reg_op3_data; // @[Core.scala 198:38]
  reg [4:0] ex1_reg_exe_fun; // @[Core.scala 199:38]
  reg  ex1_reg_rf_wen; // @[Core.scala 200:38]
  reg [2:0] ex1_reg_wb_sel; // @[Core.scala 201:38]
  reg [11:0] ex1_reg_csr_addr; // @[Core.scala 202:38]
  reg [1:0] ex1_reg_csr_cmd; // @[Core.scala 203:38]
  reg [2:0] ex1_reg_mem_w; // @[Core.scala 204:38]
  reg  ex1_is_uncond_br; // @[Core.scala 205:38]
  reg  ex1_reg_bp_taken; // @[Core.scala 206:38]
  reg [30:0] ex1_reg_bp_taken_pc; // @[Core.scala 207:38]
  reg [1:0] ex1_reg_bp_cnt; // @[Core.scala 208:38]
  reg  ex1_reg_is_half; // @[Core.scala 209:38]
  reg  ex1_reg_is_valid_inst; // @[Core.scala 210:38]
  reg  ex1_reg_is_trap; // @[Core.scala 211:38]
  reg [31:0] ex1_reg_mcause; // @[Core.scala 212:38]
  reg  ex1_reg_mem_use_reg; // @[Core.scala 214:38]
  reg  ex1_reg_inst2_use_reg; // @[Core.scala 215:38]
  reg  ex1_reg_inst3_use_reg; // @[Core.scala 216:38]
  reg  ex1_is_cond_br_inst; // @[Core.scala 217:38]
  reg [30:0] ex1_reg_direct_jbr_pc; // @[Core.scala 218:38]
  reg  jbr_reg_bp_en; // @[Core.scala 221:41]
  reg  jbr_reg_is_cond_br; // @[Core.scala 222:41]
  reg  jbr_reg_is_cond_br_inst; // @[Core.scala 223:41]
  reg  jbr_reg_is_uncond_br; // @[Core.scala 224:41]
  reg [30:0] jbr_reg_br_pc; // @[Core.scala 225:41]
  reg  jbr_reg_bp_taken; // @[Core.scala 226:41]
  reg [30:0] jbr_reg_bp_taken_pc; // @[Core.scala 227:41]
  reg [1:0] jbr_reg_bp_cnt; // @[Core.scala 228:41]
  reg  jbr_reg_is_half; // @[Core.scala 229:41]
  reg [30:0] ex2_reg_pc; // @[Core.scala 232:38]
  reg [4:0] ex2_reg_wb_addr; // @[Core.scala 233:38]
  reg [31:0] ex2_reg_op1_data; // @[Core.scala 234:38]
  reg [47:0] ex2_reg_mullu; // @[Core.scala 235:38]
  reg [31:0] ex2_reg_mulls; // @[Core.scala 236:38]
  reg [47:0] ex2_reg_mulhuu; // @[Core.scala 237:38]
  reg [47:0] ex2_reg_mulhss; // @[Core.scala 238:38]
  reg [47:0] ex2_reg_mulhsu; // @[Core.scala 239:38]
  reg [4:0] ex2_reg_exe_fun; // @[Core.scala 240:38]
  reg  ex2_reg_rf_wen; // @[Core.scala 241:38]
  reg [2:0] ex2_reg_wb_sel; // @[Core.scala 242:38]
  reg [11:0] ex2_reg_csr_addr; // @[Core.scala 243:38]
  reg [1:0] ex2_reg_csr_cmd; // @[Core.scala 244:38]
  reg [31:0] ex2_reg_alu_out; // @[Core.scala 245:38]
  reg [31:0] ex2_reg_pc_bit_out; // @[Core.scala 246:38]
  reg [31:0] ex2_reg_wdata; // @[Core.scala 247:38]
  reg  ex2_reg_is_valid_inst; // @[Core.scala 248:38]
  reg  ex2_reg_is_trap; // @[Core.scala 249:38]
  reg [31:0] ex2_reg_mcause; // @[Core.scala 250:38]
  reg  ex2_reg_divrem; // @[Core.scala 254:38]
  reg  ex2_reg_sign_op1; // @[Core.scala 255:38]
  reg  ex2_reg_sign_op12; // @[Core.scala 256:38]
  reg  ex2_reg_zero_op2; // @[Core.scala 257:38]
  reg [36:0] ex2_reg_init_dividend; // @[Core.scala 258:38]
  reg [31:0] ex2_reg_init_divisor; // @[Core.scala 259:38]
  reg [31:0] ex2_reg_orig_dividend; // @[Core.scala 260:38]
  reg  ex2_reg_inst3_use_reg; // @[Core.scala 261:38]
  reg  ex2_reg_no_mem; // @[Core.scala 262:38]
  reg [3:0] mem1_reg_mem_wstrb; // @[Core.scala 265:39]
  reg [2:0] mem1_reg_mem_w; // @[Core.scala 266:39]
  reg  mem1_reg_mem_use_reg; // @[Core.scala 267:39]
  reg  mem1_reg_is_mem_load; // @[Core.scala 269:39]
  reg  mem1_reg_is_mem_store; // @[Core.scala 270:39]
  reg  mem1_reg_is_dram_load; // @[Core.scala 271:39]
  reg  mem1_reg_is_dram_store; // @[Core.scala 272:39]
  reg  mem1_reg_is_dram_fence; // @[Core.scala 273:39]
  reg  mem1_reg_is_valid_inst; // @[Core.scala 274:39]
  reg [1:0] mem2_reg_wb_byte_offset; // @[Core.scala 277:40]
  reg [2:0] mem2_reg_mem_w; // @[Core.scala 278:40]
  reg [31:0] mem2_reg_dmem_rdata; // @[Core.scala 279:40]
  reg [31:0] mem2_reg_wb_addr; // @[Core.scala 280:40]
  reg  mem2_reg_is_valid_load; // @[Core.scala 281:40]
  reg  mem2_reg_mem_use_reg; // @[Core.scala 282:40]
  reg  mem2_reg_is_valid_inst; // @[Core.scala 283:40]
  reg  mem2_reg_is_dram_load; // @[Core.scala 284:40]
  reg [1:0] mem3_reg_wb_byte_offset; // @[Core.scala 287:40]
  reg [2:0] mem3_reg_mem_w; // @[Core.scala 288:40]
  reg [31:0] mem3_reg_dmem_rdata; // @[Core.scala 289:40]
  reg [31:0] mem3_reg_wb_addr; // @[Core.scala 290:40]
  reg  mem3_reg_is_valid_load; // @[Core.scala 291:40]
  reg  mem3_reg_is_valid_inst; // @[Core.scala 292:40]
  reg  mem3_reg_mem_use_reg; // @[Core.scala 293:40]
  reg  id_reg_bp_taken; // @[Core.scala 295:37]
  reg [30:0] id_reg_bp_taken_pc; // @[Core.scala 296:37]
  reg [1:0] id_reg_bp_cnt; // @[Core.scala 297:37]
  reg  id_reg_is_bp_fail; // @[Core.scala 298:37]
  reg [30:0] id_reg_br_pc; // @[Core.scala 299:37]
  reg  mem1_mem_stall_delay; // @[Core.scala 307:37]
  reg  ex1_reg_fw_en; // @[Core.scala 308:37]
  reg  ex2_reg_fw_en; // @[Core.scala 310:37]
  reg  ex2_reg_div_stall; // @[Core.scala 313:37]
  reg [2:0] ex2_reg_divrem_state; // @[Core.scala 314:37]
  reg  ex2_reg_is_br; // @[Core.scala 315:37]
  reg [30:0] ex2_reg_br_pc; // @[Core.scala 316:37]
  reg  ex2_reg_is_retired; // @[Core.scala 321:37]
  reg  mem3_reg_is_retired; // @[Core.scala 322:37]
  reg  ic_reg_read_rdy; // @[Core.scala 342:33]
  reg  ic_reg_half_rdy; // @[Core.scala 343:33]
  reg [30:0] ic_reg_imem_addr; // @[Core.scala 347:33]
  reg [30:0] ic_reg_addr_out; // @[Core.scala 348:33]
  reg [31:0] ic_reg_inst; // @[Core.scala 351:34]
  reg [30:0] ic_reg_inst_addr; // @[Core.scala 352:34]
  reg [31:0] ic_reg_inst2; // @[Core.scala 353:34]
  reg [2:0] ic_state; // @[Core.scala 356:25]
  reg  ic_reg_bp_next_taken0; // @[Core.scala 364:41]
  reg [30:0] ic_reg_bp_next_taken_pc0; // @[Core.scala 365:41]
  reg [1:0] ic_reg_bp_next_cnt0; // @[Core.scala 366:41]
  reg  ic_reg_bp_next_taken1; // @[Core.scala 367:41]
  reg [30:0] ic_reg_bp_next_taken_pc1; // @[Core.scala 368:41]
  reg [1:0] ic_reg_bp_next_cnt1; // @[Core.scala 369:41]
  reg  ic_reg_bp_next_taken2; // @[Core.scala 370:41]
  reg [30:0] ic_reg_bp_next_taken_pc2; // @[Core.scala 371:41]
  reg [1:0] ic_reg_bp_next_cnt2; // @[Core.scala 372:41]
  wire [30:0] ic_imem_addr_2 = {ic_reg_imem_addr[30:1],1'h1}; // @[Cat.scala 33:92]
  wire [30:0] ic_imem_addr_4 = ic_reg_imem_addr + 31'h2; // @[Core.scala 375:41]
  wire [30:0] ic_inst_addr_2 = {ic_reg_inst_addr[30:1],1'h1}; // @[Cat.scala 33:92]
  wire [31:0] _io_imem_addr_T = {ic_reg_imem_addr,1'h0}; // @[Cat.scala 33:92]
  wire [30:0] _if1_jump_addr_T = id_reg_is_bp_fail ? id_reg_br_pc : id_reg_bp_taken_pc; // @[Mux.scala 101:16]
  wire [30:0] if1_jump_addr = ex2_reg_is_br ? ex2_reg_br_pc : _if1_jump_addr_T; // @[Mux.scala 101:16]
  wire [30:0] ic_next_imem_addr = {if1_jump_addr[30:1],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _io_imem_addr_T_1 = {if1_jump_addr[30:1],1'h0,1'h0}; // @[Cat.scala 33:92]
  wire  _T_3 = 3'h0 == ic_state; // @[Core.scala 407:23]
  wire  _ic_bp_taken_T_1 = ic_btb_io_lu_matches0 & ic_pht_io_lu_cnt0[0]; // @[Core.scala 409:49]
  wire  _ic_reg_bp_next_taken1_T_1 = ic_btb_io_lu_matches1 & ic_pht_io_lu_cnt1[0]; // @[Core.scala 415:59]
  wire  _T_6 = 3'h1 == ic_state; // @[Core.scala 407:23]
  wire  _T_9 = 3'h2 == ic_state; // @[Core.scala 407:23]
  wire  _T_12 = 3'h4 == ic_state; // @[Core.scala 407:23]
  wire  _T_15 = 3'h3 == ic_state; // @[Core.scala 407:23]
  wire  _GEN_0 = 3'h3 == ic_state & ic_reg_bp_next_taken2; // @[Core.scala 388:19 407:23 447:24]
  wire [30:0] _GEN_1 = 3'h3 == ic_state ? ic_reg_bp_next_taken_pc2 : 31'h0; // @[Core.scala 389:19 407:23 448:24]
  wire [1:0] _GEN_2 = 3'h3 == ic_state ? ic_reg_bp_next_cnt2 : 2'h0; // @[Core.scala 390:19 407:23 449:24]
  wire  _GEN_3 = 3'h4 == ic_state ? ic_reg_bp_next_taken1 : _GEN_0; // @[Core.scala 407:23 436:24]
  wire [30:0] _GEN_4 = 3'h4 == ic_state ? ic_reg_bp_next_taken_pc1 : _GEN_1; // @[Core.scala 407:23 437:24]
  wire [1:0] _GEN_5 = 3'h4 == ic_state ? ic_reg_bp_next_cnt1 : _GEN_2; // @[Core.scala 407:23 438:24]
  wire  _GEN_6 = 3'h4 == ic_state ? _ic_bp_taken_T_1 : ic_reg_bp_next_taken0; // @[Core.scala 407:23 439:34 364:41]
  wire [30:0] _GEN_7 = 3'h4 == ic_state ? ic_btb_io_lu_taken_pc0 : ic_reg_bp_next_taken_pc0; // @[Core.scala 407:23 440:34 365:41]
  wire [1:0] _GEN_8 = 3'h4 == ic_state ? ic_pht_io_lu_cnt0 : ic_reg_bp_next_cnt0; // @[Core.scala 407:23 441:34 366:41]
  wire  _GEN_9 = 3'h4 == ic_state ? ic_reg_bp_next_taken1 : ic_reg_bp_next_taken2; // @[Core.scala 407:23 442:34 370:41]
  wire [30:0] _GEN_10 = 3'h4 == ic_state ? ic_reg_bp_next_taken_pc1 : ic_reg_bp_next_taken_pc2; // @[Core.scala 407:23 443:34 371:41]
  wire [1:0] _GEN_11 = 3'h4 == ic_state ? ic_reg_bp_next_cnt1 : ic_reg_bp_next_cnt2; // @[Core.scala 407:23 444:34 372:41]
  wire  _GEN_12 = 3'h2 == ic_state ? ic_reg_bp_next_taken0 : _GEN_3; // @[Core.scala 407:23 431:24]
  wire [30:0] _GEN_13 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc0 : _GEN_4; // @[Core.scala 407:23 432:24]
  wire [1:0] _GEN_14 = 3'h2 == ic_state ? ic_reg_bp_next_cnt0 : _GEN_5; // @[Core.scala 407:23 433:24]
  wire  _GEN_15 = 3'h2 == ic_state ? ic_reg_bp_next_taken0 : _GEN_6; // @[Core.scala 407:23 364:41]
  wire [30:0] _GEN_16 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc0 : _GEN_7; // @[Core.scala 407:23 365:41]
  wire [1:0] _GEN_17 = 3'h2 == ic_state ? ic_reg_bp_next_cnt0 : _GEN_8; // @[Core.scala 407:23 366:41]
  wire  _GEN_18 = 3'h2 == ic_state ? ic_reg_bp_next_taken2 : _GEN_9; // @[Core.scala 407:23 370:41]
  wire [30:0] _GEN_19 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_10; // @[Core.scala 407:23 371:41]
  wire [1:0] _GEN_20 = 3'h2 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_11; // @[Core.scala 407:23 372:41]
  wire  _GEN_21 = 3'h1 == ic_state ? _ic_reg_bp_next_taken1_T_1 : _GEN_12; // @[Core.scala 407:23 420:24]
  wire [30:0] _GEN_22 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc1 : _GEN_13; // @[Core.scala 407:23 421:24]
  wire [1:0] _GEN_23 = 3'h1 == ic_state ? ic_pht_io_lu_cnt1 : _GEN_14; // @[Core.scala 407:23 422:24]
  wire  _GEN_24 = 3'h1 == ic_state ? _ic_bp_taken_T_1 : _GEN_15; // @[Core.scala 407:23 423:34]
  wire [30:0] _GEN_25 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_16; // @[Core.scala 407:23 424:34]
  wire [1:0] _GEN_26 = 3'h1 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_17; // @[Core.scala 407:23 425:34]
  wire  _GEN_27 = 3'h1 == ic_state ? _ic_reg_bp_next_taken1_T_1 : ic_reg_bp_next_taken1; // @[Core.scala 407:23 426:34 367:41]
  wire [30:0] _GEN_28 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc1 : ic_reg_bp_next_taken_pc1; // @[Core.scala 407:23 427:34 368:41]
  wire [1:0] _GEN_29 = 3'h1 == ic_state ? ic_pht_io_lu_cnt1 : ic_reg_bp_next_cnt1; // @[Core.scala 407:23 428:34 369:41]
  wire  _GEN_30 = 3'h1 == ic_state ? ic_reg_bp_next_taken2 : _GEN_18; // @[Core.scala 407:23 370:41]
  wire [30:0] _GEN_31 = 3'h1 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_19; // @[Core.scala 407:23 371:41]
  wire [1:0] _GEN_32 = 3'h1 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_20; // @[Core.scala 407:23 372:41]
  wire  _GEN_33 = 3'h0 == ic_state ? ic_btb_io_lu_matches0 & ic_pht_io_lu_cnt0[0] : _GEN_21; // @[Core.scala 407:23 409:24]
  wire [30:0] _GEN_34 = 3'h0 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_22; // @[Core.scala 407:23 410:24]
  wire [1:0] _GEN_35 = 3'h0 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_23; // @[Core.scala 407:23 411:24]
  wire  _GEN_36 = 3'h0 == ic_state ? _ic_bp_taken_T_1 : _GEN_24; // @[Core.scala 407:23 412:34]
  wire [30:0] _GEN_37 = 3'h0 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_25; // @[Core.scala 407:23 413:34]
  wire [1:0] _GEN_38 = 3'h0 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_26; // @[Core.scala 407:23 414:34]
  wire  _GEN_42 = 3'h0 == ic_state ? ic_reg_bp_next_taken2 : _GEN_30; // @[Core.scala 407:23 370:41]
  wire [30:0] _GEN_43 = 3'h0 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_31; // @[Core.scala 407:23 371:41]
  wire [1:0] _GEN_44 = 3'h0 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_32; // @[Core.scala 407:23 372:41]
  wire [31:0] _io_imem_addr_T_2 = {ic_imem_addr_4,1'h0}; // @[Cat.scala 33:92]
  wire  _ic_read_en4_T = ~id_reg_stall; // @[Core.scala 591:18]
  wire  _if1_is_jump_T = ex2_reg_is_br | id_reg_is_bp_fail; // @[Core.scala 578:35]
  wire  if1_is_jump = ex2_reg_is_br | id_reg_is_bp_fail | id_reg_bp_taken; // @[Core.scala 578:56]
  wire [30:0] _ic_data_out_T_2 = {15'h0,io_imem_inst[31:16]}; // @[Cat.scala 33:92]
  wire [31:0] _ic_data_out_T_5 = {io_imem_inst[15:0],ic_reg_inst[31:16]}; // @[Cat.scala 33:92]
  wire [31:0] _ic_data_out_T_8 = {ic_reg_inst[15:0],ic_reg_inst2[31:16]}; // @[Cat.scala 33:92]
  wire [31:0] _GEN_64 = _T_15 ? _ic_data_out_T_8 : 32'h13; // @[Core.scala 383:15 453:23 553:25]
  wire [31:0] _GEN_73 = _T_12 ? _ic_data_out_T_5 : _GEN_64; // @[Core.scala 453:23 523:27]
  wire [31:0] _GEN_94 = _T_9 ? ic_reg_inst : _GEN_73; // @[Core.scala 453:23 506:25]
  wire [31:0] _GEN_119 = _T_6 ? {{1'd0}, _ic_data_out_T_2} : _GEN_94; // @[Core.scala 453:23 485:26]
  wire [31:0] _GEN_141 = _T_3 ? io_imem_inst : _GEN_119; // @[Core.scala 453:23 459:26]
  wire [31:0] _GEN_179 = ~io_imem_valid ? 32'h13 : _GEN_141; // @[Core.scala 383:15 402:98]
  wire [31:0] ic_data_out = if1_is_jump ? 32'h13 : _GEN_179; // @[Core.scala 383:15 393:21]
  wire  is_half_inst = ic_data_out[1:0] != 2'h3; // @[Core.scala 589:41]
  wire  ic_read_en4 = ~id_reg_stall & ~is_half_inst; // @[Core.scala 591:32]
  wire [30:0] _GEN_45 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_addr_out; // @[Core.scala 384:15 475:34 476:23]
  wire [1:0] _GEN_46 = ic_read_en4 ? 2'h0 : 2'h2; // @[Core.scala 471:18 475:34 477:20]
  wire  ic_read_en2 = _ic_read_en4_T & is_half_inst; // @[Core.scala 590:32]
  wire [30:0] _GEN_47 = ic_read_en2 ? ic_imem_addr_2 : _GEN_45; // @[Core.scala 472:28 473:23]
  wire [2:0] _GEN_48 = ic_read_en2 ? 3'h4 : {{1'd0}, _GEN_46}; // @[Core.scala 472:28 474:20]
  wire [30:0] _GEN_49 = ic_read_en2 ? ic_imem_addr_4 : ic_imem_addr_2; // @[Core.scala 499:28 500:23 486:26]
  wire [2:0] _GEN_50 = ic_read_en2 ? 3'h0 : 3'h4; // @[Core.scala 498:18 499:28 501:20]
  wire [30:0] _GEN_51 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_addr_out; // @[Core.scala 384:15 515:33 516:23]
  wire [2:0] _GEN_52 = ic_read_en4 ? 3'h0 : ic_state; // @[Core.scala 515:33 517:20 356:25]
  wire [30:0] _GEN_53 = ic_read_en2 ? ic_inst_addr_2 : _GEN_51; // @[Core.scala 512:28 513:23]
  wire [2:0] _GEN_54 = ic_read_en2 ? 3'h4 : _GEN_52; // @[Core.scala 512:28 514:20]
  wire [30:0] _GEN_55 = ic_read_en4 ? ic_imem_addr_2 : ic_reg_addr_out; // @[Core.scala 384:15 546:33 547:23]
  wire [2:0] _GEN_56 = ic_read_en4 ? 3'h4 : 3'h3; // @[Core.scala 542:18 546:33 548:20]
  wire [30:0] _GEN_57 = ic_read_en2 ? ic_reg_imem_addr : _GEN_55; // @[Core.scala 543:28 544:23]
  wire [2:0] _GEN_58 = ic_read_en2 ? 3'h2 : _GEN_56; // @[Core.scala 543:28 545:20]
  wire [30:0] _GEN_59 = ic_read_en4 ? ic_inst_addr_2 : ic_reg_addr_out; // @[Core.scala 384:15 562:33 563:23]
  wire [2:0] _GEN_60 = ic_read_en4 ? 3'h4 : ic_state; // @[Core.scala 562:33 564:20 356:25]
  wire [30:0] _GEN_61 = ic_read_en2 ? ic_reg_inst_addr : _GEN_59; // @[Core.scala 559:28 560:23]
  wire [2:0] _GEN_62 = ic_read_en2 ? 3'h2 : _GEN_60; // @[Core.scala 559:28 561:20]
  wire [31:0] _GEN_63 = _T_15 ? _io_imem_addr_T : _io_imem_addr_T; // @[Core.scala 377:16 453:23 552:25]
  wire [30:0] _GEN_69 = _T_15 ? _GEN_61 : ic_reg_addr_out; // @[Core.scala 384:15 453:23]
  wire [2:0] _GEN_70 = _T_15 ? _GEN_62 : ic_state; // @[Core.scala 453:23 356:25]
  wire [31:0] _GEN_71 = _T_12 ? _io_imem_addr_T_2 : _GEN_63; // @[Core.scala 453:23 521:27]
  wire [30:0] _GEN_72 = _T_12 ? ic_imem_addr_4 : ic_reg_imem_addr; // @[Core.scala 453:23 522:27 347:33]
  wire [31:0] _GEN_74 = _T_12 ? io_imem_inst : ic_reg_inst; // @[Core.scala 453:23 524:27 351:34]
  wire [30:0] _GEN_75 = _T_12 ? ic_reg_imem_addr : ic_reg_inst_addr; // @[Core.scala 453:23 525:27 352:34]
  wire [31:0] _GEN_76 = _T_12 ? ic_reg_inst : ic_reg_inst2; // @[Core.scala 453:23 526:27 353:34]
  wire  _GEN_85 = _T_12 ? _ic_reg_bp_next_taken1_T_1 : ic_reg_bp_next_taken1; // @[Core.scala 453:23 536:34 367:41]
  wire [30:0] _GEN_86 = _T_12 ? ic_btb_io_lu_taken_pc1 : ic_reg_bp_next_taken_pc1; // @[Core.scala 453:23 537:34 368:41]
  wire [1:0] _GEN_87 = _T_12 ? ic_pht_io_lu_cnt1 : ic_reg_bp_next_cnt1; // @[Core.scala 453:23 538:34 369:41]
  wire [2:0] _GEN_91 = _T_12 ? _GEN_58 : _GEN_70; // @[Core.scala 453:23]
  wire [30:0] _GEN_92 = _T_12 ? _GEN_57 : _GEN_69; // @[Core.scala 453:23]
  wire [31:0] _GEN_93 = _T_9 ? _io_imem_addr_T : _GEN_71; // @[Core.scala 453:23 505:25]
  wire [30:0] _GEN_95 = _T_9 ? ic_reg_imem_addr : _GEN_72; // @[Core.scala 453:23 507:25]
  wire [30:0] _GEN_99 = _T_9 ? _GEN_53 : _GEN_92; // @[Core.scala 453:23]
  wire [2:0] _GEN_100 = _T_9 ? _GEN_54 : _GEN_91; // @[Core.scala 453:23]
  wire [31:0] _GEN_102 = _T_9 ? ic_reg_inst : _GEN_74; // @[Core.scala 453:23 351:34]
  wire [30:0] _GEN_103 = _T_9 ? ic_reg_inst_addr : _GEN_75; // @[Core.scala 453:23 352:34]
  wire [31:0] _GEN_104 = _T_9 ? ic_reg_inst2 : _GEN_76; // @[Core.scala 453:23 353:34]
  wire  _GEN_109 = _T_9 ? ic_reg_bp_next_taken1 : _GEN_85; // @[Core.scala 453:23 367:41]
  wire [30:0] _GEN_110 = _T_9 ? ic_reg_bp_next_taken_pc1 : _GEN_86; // @[Core.scala 453:23 368:41]
  wire [1:0] _GEN_111 = _T_9 ? ic_reg_bp_next_cnt1 : _GEN_87; // @[Core.scala 453:23 369:41]
  wire [31:0] _GEN_115 = _T_6 ? _io_imem_addr_T_2 : _GEN_93; // @[Core.scala 453:23 481:26]
  wire [30:0] _GEN_116 = _T_6 ? ic_imem_addr_4 : _GEN_95; // @[Core.scala 453:23 482:26]
  wire [31:0] _GEN_117 = _T_6 ? io_imem_inst : _GEN_102; // @[Core.scala 453:23 483:26]
  wire [30:0] _GEN_118 = _T_6 ? ic_reg_imem_addr : _GEN_103; // @[Core.scala 453:23 484:26]
  wire [30:0] _GEN_120 = _T_6 ? _GEN_49 : _GEN_99; // @[Core.scala 453:23]
  wire  _GEN_128 = _T_6 ? _ic_reg_bp_next_taken1_T_1 : _GEN_109; // @[Core.scala 453:23 495:34]
  wire [30:0] _GEN_129 = _T_6 ? ic_btb_io_lu_taken_pc1 : _GEN_110; // @[Core.scala 453:23 496:34]
  wire [1:0] _GEN_130 = _T_6 ? ic_pht_io_lu_cnt1 : _GEN_111; // @[Core.scala 453:23 497:34]
  wire [2:0] _GEN_131 = _T_6 ? _GEN_50 : _GEN_100; // @[Core.scala 453:23]
  wire [31:0] _GEN_132 = _T_6 ? ic_reg_inst2 : _GEN_104; // @[Core.scala 453:23 353:34]
  wire [31:0] _GEN_137 = _T_3 ? _io_imem_addr_T_2 : _GEN_115; // @[Core.scala 453:23 455:26]
  wire [30:0] _GEN_138 = _T_3 ? ic_imem_addr_4 : _GEN_116; // @[Core.scala 453:23 456:26]
  wire  _GEN_160 = ~io_imem_valid ? ic_reg_half_rdy : 1'h1; // @[Core.scala 380:19 402:98 404:21]
  wire  _GEN_161 = ~io_imem_valid ? 1'h0 : ic_reg_read_rdy; // @[Core.scala 381:15 402:98 405:21]
  wire  _GEN_162 = ~io_imem_valid ? 1'h0 : ic_reg_half_rdy; // @[Core.scala 382:15 402:98 406:21]
  wire  _GEN_163 = ~io_imem_valid ? _GEN_33 : _GEN_33; // @[Core.scala 402:98]
  wire [30:0] _GEN_164 = ~io_imem_valid ? _GEN_34 : _GEN_34; // @[Core.scala 402:98]
  wire [1:0] _GEN_165 = ~io_imem_valid ? _GEN_35 : _GEN_35; // @[Core.scala 402:98]
  wire [31:0] _GEN_175 = ~io_imem_valid ? _io_imem_addr_T : _GEN_137; // @[Core.scala 377:16 402:98]
  wire [30:0] _GEN_176 = ~io_imem_valid ? ic_reg_imem_addr : _GEN_138; // @[Core.scala 347:33 402:98]
  wire  _GEN_191 = if1_is_jump | _GEN_160; // @[Core.scala 380:19 393:21]
  wire  ic_read_rdy = if1_is_jump ? ic_reg_read_rdy : _GEN_161; // @[Core.scala 381:15 393:21]
  wire  ic_half_rdy = if1_is_jump ? ic_reg_half_rdy : _GEN_162; // @[Core.scala 382:15 393:21]
  wire  ic_bp_taken = if1_is_jump ? 1'h0 : _GEN_163; // @[Core.scala 388:19 393:21]
  wire [30:0] ic_bp_taken_pc = if1_is_jump ? 31'h0 : _GEN_164; // @[Core.scala 389:19 393:21]
  wire [1:0] ic_bp_cnt = if1_is_jump ? 2'h0 : _GEN_165; // @[Core.scala 390:19 393:21]
  reg [30:0] id_reg_pc; // @[Core.scala 586:29]
  reg [31:0] id_reg_inst; // @[Core.scala 587:29]
  wire  _if2_pc_T = ic_half_rdy & is_half_inst; // @[Core.scala 592:66]
  wire  _if2_pc_T_1 = ic_read_rdy | ic_half_rdy & is_half_inst; // @[Core.scala 592:50]
  wire [30:0] if2_pc = id_reg_stall | ~(ic_read_rdy | ic_half_rdy & is_half_inst) ? id_reg_pc : ic_reg_addr_out; // @[Core.scala 592:19]
  wire [31:0] _if2_inst_T_1 = _if2_pc_T ? ic_data_out : 32'h13; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_2 = ic_read_rdy ? ic_data_out : _if2_inst_T_1; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_3 = id_reg_bp_taken ? 32'h13 : _if2_inst_T_2; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_4 = id_reg_is_bp_fail ? 32'h13 : _if2_inst_T_3; // @[Mux.scala 101:16]
  wire [31:0] _if2_inst_T_5 = id_reg_stall ? id_reg_inst : _if2_inst_T_4; // @[Mux.scala 101:16]
  wire [31:0] if2_inst = ex2_reg_is_br ? 32'h13 : _if2_inst_T_5; // @[Mux.scala 101:16]
  wire  _if2_bp_taken_T_2 = ic_bp_taken & _if2_pc_T_1; // @[Core.scala 607:42]
  wire  _if2_bp_taken_T_3 = id_reg_bp_taken ? 1'h0 : _if2_bp_taken_T_2; // @[Mux.scala 101:16]
  wire [31:0] _T_31 = {ic_reg_addr_out,1'h0}; // @[Cat.scala 33:92]
  wire  _T_33 = ~reset; // @[Core.scala 637:9]
  wire  _rrd_stall_T = ~rrd_reg_op1_sel; // @[Core.scala 1160:23]
  wire  _rrd_stall_T_2 = ~rrd_reg_op2_sel; // @[Core.scala 1161:23]
  wire  _rrd_stall_T_3 = ~rrd_reg_op2_sel & scoreboard_rrd_stall_MPORT_1_data; // @[Core.scala 1161:37]
  wire  _rrd_stall_T_4 = ~rrd_reg_op1_sel & scoreboard_rrd_stall_MPORT_data | _rrd_stall_T_3; // @[Core.scala 1160:70]
  wire  _rrd_stall_T_6 = rrd_reg_op3_sel == 2'h2 & scoreboard_rrd_stall_MPORT_2_data; // @[Core.scala 1162:37]
  wire  _rrd_stall_T_7 = _rrd_stall_T_4 | _rrd_stall_T_6; // @[Core.scala 1161:70]
  wire  _rrd_stall_T_9 = rrd_reg_rf_wen & scoreboard_rrd_stall_MPORT_3_data; // @[Core.scala 1163:33]
  wire  rrd_stall = _rrd_stall_T_7 | _rrd_stall_T_9; // @[Core.scala 1162:70]
  wire  _csr_is_valid_inst_T = ~ex2_reg_is_br; // @[Core.scala 1475:52]
  wire  csr_is_valid_inst = ex2_reg_is_valid_inst & ~ex2_reg_is_br; // @[Core.scala 1475:49]
  reg  csr_reg_is_meintr; // @[Core.scala 1464:34]
  wire  csr_is_meintr = csr_reg_is_meintr & csr_is_valid_inst; // @[Core.scala 1476:41]
  wire  _ex2_en_T = ~csr_is_meintr; // @[Core.scala 1479:34]
  reg  csr_reg_is_mtintr; // @[Core.scala 1469:34]
  wire  csr_is_mtintr = csr_reg_is_mtintr & csr_is_valid_inst; // @[Core.scala 1477:41]
  wire  _ex2_en_T_2 = ~csr_is_mtintr; // @[Core.scala 1479:52]
  wire  ex2_en = csr_is_valid_inst & ~csr_is_meintr & ~csr_is_mtintr; // @[Core.scala 1479:49]
  wire  mem1_is_mem_load = mem1_reg_is_mem_load & ex2_en; // @[Core.scala 1921:49]
  wire  mem1_is_mem_store = mem1_reg_is_mem_store & ex2_en; // @[Core.scala 1922:50]
  wire  mem1_mem_stall = mem1_is_mem_load & (~io_dmem_rvalid | mem1_mem_stall_delay) | mem1_is_mem_store & ~
    io_dmem_wready; // @[Core.scala 1942:85]
  wire  mem1_is_dram_load = mem1_reg_is_dram_load & ex2_en; // @[Core.scala 1923:50]
  wire  mem1_is_dram_store = mem1_reg_is_dram_store & ex2_en; // @[Core.scala 1924:51]
  wire  _mem1_dram_stall_T_3 = mem1_is_dram_store & ~io_cache_wready; // @[Core.scala 1949:25]
  wire  _mem1_dram_stall_T_4 = mem1_is_dram_load & ~io_cache_rready | _mem1_dram_stall_T_3; // @[Core.scala 1948:45]
  wire  mem1_is_dram_fence = mem1_reg_is_dram_fence & ex2_en; // @[Core.scala 1925:51]
  wire  _mem1_dram_stall_T_5 = mem1_is_dram_fence & io_cache_ibusy; // @[Core.scala 1950:25]
  wire  mem1_dram_stall = _mem1_dram_stall_T_4 | _mem1_dram_stall_T_5; // @[Core.scala 1949:46]
  wire  mem2_dram_stall = mem2_reg_is_dram_load & ~io_cache_rvalid; // @[Core.scala 1975:45]
  wire  mem_stall = mem1_mem_stall | mem1_dram_stall | mem2_dram_stall; // @[Core.scala 1945:50]
  wire  ex2_stall = mem_stall | ex2_reg_div_stall; // @[Core.scala 1454:26]
  wire  id_stall = rrd_stall | ex2_stall; // @[Core.scala 652:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 656:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[Core.scala 658:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 660:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 661:28]
  wire [4:0] id_rs3_addr = id_inst[31:27]; // @[Core.scala 662:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[Core.scala 663:30]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[Core.scala 668:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[Cat.scala 33:92]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[Cat.scala 33:92]
  wire [4:0] id_c_rs3p_addr = {2'h1,id_inst[12:10]}; // @[Cat.scala 33:92]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 676:25]
  wire [19:0] _id_imm_i_sext_T_2 = id_imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_imm_i_sext = {_id_imm_i_sext_T_2,id_imm_i}; // @[Cat.scala 33:92]
  wire [11:0] id_imm_s = {id_inst[31:25],id_w_wb_addr}; // @[Cat.scala 33:92]
  wire [19:0] _id_imm_s_sext_T_2 = id_imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_imm_s_sext = {_id_imm_s_sext_T_2,id_inst[31:25],id_w_wb_addr}; // @[Cat.scala 33:92]
  wire [11:0] id_imm_b = {id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8]}; // @[Cat.scala 33:92]
  wire [18:0] _id_imm_b_sext_T_2 = id_imm_b[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_imm_b_sext = {_id_imm_b_sext_T_2,id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8],1'h0}; // @[Cat.scala 33:92]
  wire [19:0] id_imm_j = {id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21]}; // @[Cat.scala 33:92]
  wire [10:0] _id_imm_j_sext_T_2 = id_imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_imm_j_sext = {_id_imm_j_sext_T_2,id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21],1'h0}; // @[Cat.scala 33:92]
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 684:25]
  wire [31:0] id_imm_u_shifted = {id_imm_u,12'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_imm_z_uext = {27'h0,id_rs1_addr}; // @[Cat.scala 33:92]
  wire [26:0] _id_c_imm_i_T_2 = id_inst[12] ? 27'h7ffffff : 27'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_i = {_id_c_imm_i_T_2,id_c_rs2_addr}; // @[Cat.scala 33:92]
  wire [14:0] _id_c_imm_iu_T_2 = id_inst[12] ? 15'h7fff : 15'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_iu = {_id_c_imm_iu_T_2,id_c_rs2_addr,12'h0}; // @[Cat.scala 33:92]
  wire [22:0] _id_c_imm_i16_T_2 = id_inst[12] ? 23'h7fffff : 23'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_i16 = {_id_c_imm_i16_T_2,id_inst[4:3],id_inst[5],id_inst[2],id_inst[6],4'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_sl = {24'h0,id_inst[3:2],id_inst[12],id_inst[6:4],2'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_ss = {24'h0,id_inst[8:7],id_inst[12:9],2'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_iw = {22'h0,id_inst[10:7],id_inst[12:11],id_inst[5],id_inst[6],2'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_ls = {25'h0,id_inst[5],id_inst[12:10],id_inst[6],2'h0}; // @[Cat.scala 33:92]
  wire [23:0] _id_c_imm_b_T_2 = id_inst[12] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_b = {_id_c_imm_b_T_2,id_inst[6:5],id_inst[2],id_inst[11:10],id_inst[4:3],1'h0}; // @[Cat.scala 33:92]
  wire [20:0] _id_c_imm_j_T_2 = id_inst[12] ? 21'h1fffff : 21'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_j = {_id_c_imm_j_T_2,id_inst[8],id_inst[10:9],id_inst[6],id_inst[7],id_inst[2],id_inst[11],
    id_inst[5:3],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_b2 = {_id_c_imm_i_T_2,id_inst[11:10],id_inst[6:5],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_u = {12'h0,id_inst[12:5],12'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_lsb = {27'h0,id_inst[11:10],id_inst[6:5],id_inst[12]}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_lsh = {28'h0,id_inst[10],id_inst[6:5],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_sw0 = {25'h0,id_inst[5:3],id_inst[10],id_inst[6],2'h0}; // @[Cat.scala 33:92]
  wire [31:0] id_c_imm_sb0 = {28'h0,id_inst[10],id_inst[6:4]}; // @[Cat.scala 33:92]
  wire [32:0] id_c_imm_sh0 = {28'h0,id_inst[4],id_inst[10],id_inst[6:5],1'h0}; // @[Cat.scala 33:92]
  wire [25:0] _id_c_imm_a2w_T_2 = id_inst[12] ? 26'h3ffffff : 26'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_a2w = {_id_c_imm_a2w_T_2,id_inst[5],id_inst[11:10],id_inst[6],2'h0}; // @[Cat.scala 33:92]
  wire [29:0] _id_c_imm_a2b_T_2 = id_inst[12] ? 30'h3fffffff : 30'h0; // @[Bitwise.scala 77:12]
  wire [31:0] id_c_imm_a2b = {_id_c_imm_a2b_T_2,id_inst[11:10]}; // @[Cat.scala 33:92]
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
  wire  _csignals_T_137 = 32'h60001033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'h60005033 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h60005013 == _csignals_T_16; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_142 = id_inst & 32'h600707f; // @[Lookup.scala 31:38]
  wire  _csignals_T_143 = 32'h6005033 == _csignals_T_142; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_144 = id_inst & 32'hffff; // @[Lookup.scala 31:38]
  wire  _csignals_T_145 = 32'h0 == _csignals_T_144; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_146 = id_inst & 32'he003; // @[Lookup.scala 31:38]
  wire  _csignals_T_147 = 32'h0 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_148 = id_inst & 32'hef83; // @[Lookup.scala 31:38]
  wire  _csignals_T_149 = 32'h6101 == _csignals_T_148; // @[Lookup.scala 31:38]
  wire  _csignals_T_151 = 32'h1 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_153 = 32'h4000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_155 = 32'hc000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_157 = 32'h4001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_159 = 32'h6001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_160 = id_inst & 32'hec03; // @[Lookup.scala 31:38]
  wire  _csignals_T_161 = 32'h8401 == _csignals_T_160; // @[Lookup.scala 31:38]
  wire  _csignals_T_163 = 32'h8001 == _csignals_T_160; // @[Lookup.scala 31:38]
  wire  _csignals_T_165 = 32'h8801 == _csignals_T_160; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_166 = id_inst & 32'hfc63; // @[Lookup.scala 31:38]
  wire  _csignals_T_167 = 32'h8c01 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_169 = 32'h8c21 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_171 = 32'h8c41 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_173 = 32'h8c61 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_175 = 32'h2 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_177 = 32'ha001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_179 = 32'hc001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_181 = 32'he001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_182 = id_inst & 32'hf07f; // @[Lookup.scala 31:38]
  wire  _csignals_T_183 = 32'h8002 == _csignals_T_182; // @[Lookup.scala 31:38]
  wire  _csignals_T_185 = 32'h9002 == _csignals_T_182; // @[Lookup.scala 31:38]
  wire  _csignals_T_187 = 32'h2001 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_189 = 32'h4002 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_191 = 32'hc002 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_192 = id_inst & 32'hf003; // @[Lookup.scala 31:38]
  wire  _csignals_T_193 = 32'h8002 == _csignals_T_192; // @[Lookup.scala 31:38]
  wire  _csignals_T_195 = 32'h9002 == _csignals_T_192; // @[Lookup.scala 31:38]
  wire  _csignals_T_197 = 32'h2000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_199 = 32'h6000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_200 = id_inst & 32'hf803; // @[Lookup.scala 31:38]
  wire  _csignals_T_201 = 32'h2002 == _csignals_T_200; // @[Lookup.scala 31:38]
  wire  _csignals_T_203 = 32'h2802 == _csignals_T_200; // @[Lookup.scala 31:38]
  wire  _csignals_T_205 = 32'h3002 == _csignals_T_200; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_206 = id_inst & 32'hf807; // @[Lookup.scala 31:38]
  wire  _csignals_T_207 = 32'h3802 == _csignals_T_206; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_208 = id_inst & 32'hf80f; // @[Lookup.scala 31:38]
  wire  _csignals_T_209 = 32'h3806 == _csignals_T_208; // @[Lookup.scala 31:38]
  wire  _csignals_T_211 = 32'h380e == _csignals_T_208; // @[Lookup.scala 31:38]
  wire  _csignals_T_213 = 32'h6002 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_215 = 32'he000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_217 = 32'h9c41 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_218 = id_inst & 32'hfc7f; // @[Lookup.scala 31:38]
  wire  _csignals_T_219 = 32'h9c61 == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_221 = 32'h9c65 == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_223 = 32'h9c6d == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_225 = 32'h9c69 == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_227 = 32'h9c75 == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_229 = 32'h9c79 == _csignals_T_218; // @[Lookup.scala 31:38]
  wire  _csignals_T_231 = 32'h8000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_233 = 32'ha000 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire  _csignals_T_235 = 32'ha002 == _csignals_T_146; // @[Lookup.scala 31:38]
  wire [31:0] _csignals_T_236 = id_inst & 32'he063; // @[Lookup.scala 31:38]
  wire  _csignals_T_237 = 32'he002 == _csignals_T_236; // @[Lookup.scala 31:38]
  wire  _csignals_T_239 = 32'he022 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_241 = 32'hf022 == _csignals_T_166; // @[Lookup.scala 31:38]
  wire  _csignals_T_243 = 32'he022 == _csignals_T_236; // @[Lookup.scala 31:38]
  wire  _csignals_T_245 = 32'he042 == _csignals_T_236; // @[Lookup.scala 31:38]
  wire  _csignals_T_247 = 32'he062 == _csignals_T_236; // @[Lookup.scala 31:38]
  wire [4:0] _csignals_T_248 = _csignals_T_247 ? 5'h7 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_249 = _csignals_T_245 ? 5'h6 : _csignals_T_248; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_250 = _csignals_T_243 ? 5'h0 : _csignals_T_249; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_251 = _csignals_T_241 ? 5'h7 : _csignals_T_250; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_252 = _csignals_T_239 ? 5'h7 : _csignals_T_251; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_253 = _csignals_T_237 ? 5'h0 : _csignals_T_252; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_254 = _csignals_T_235 ? 5'h0 : _csignals_T_253; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_255 = _csignals_T_233 ? 5'h13 : _csignals_T_254; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_256 = _csignals_T_231 ? 5'h12 : _csignals_T_255; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_257 = _csignals_T_229 ? 5'h8 : _csignals_T_256; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_258 = _csignals_T_227 ? 5'h1 : _csignals_T_257; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_259 = _csignals_T_225 ? 5'hb : _csignals_T_258; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_260 = _csignals_T_223 ? 5'ha : _csignals_T_259; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_261 = _csignals_T_221 ? 5'h9 : _csignals_T_260; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_262 = _csignals_T_219 ? 5'h2 : _csignals_T_261; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_263 = _csignals_T_217 ? 5'h8 : _csignals_T_262; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_264 = _csignals_T_215 ? 5'h0 : _csignals_T_263; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_265 = _csignals_T_213 ? 5'h0 : _csignals_T_264; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_266 = _csignals_T_211 ? 5'h0 : _csignals_T_265; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_267 = _csignals_T_209 ? 5'h0 : _csignals_T_266; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_268 = _csignals_T_207 ? 5'h0 : _csignals_T_267; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_269 = _csignals_T_205 ? 5'h0 : _csignals_T_268; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_270 = _csignals_T_203 ? 5'h0 : _csignals_T_269; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_271 = _csignals_T_201 ? 5'h0 : _csignals_T_270; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_272 = _csignals_T_199 ? 5'h0 : _csignals_T_271; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_273 = _csignals_T_197 ? 5'h0 : _csignals_T_272; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_274 = _csignals_T_195 ? 5'h0 : _csignals_T_273; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_275 = _csignals_T_193 ? 5'h0 : _csignals_T_274; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_276 = _csignals_T_191 ? 5'h0 : _csignals_T_275; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_277 = _csignals_T_189 ? 5'h0 : _csignals_T_276; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_278 = _csignals_T_187 ? 5'h0 : _csignals_T_277; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_279 = _csignals_T_185 ? 5'h0 : _csignals_T_278; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_280 = _csignals_T_183 ? 5'h0 : _csignals_T_279; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_281 = _csignals_T_181 ? 5'h13 : _csignals_T_280; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_282 = _csignals_T_179 ? 5'h12 : _csignals_T_281; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_283 = _csignals_T_177 ? 5'h0 : _csignals_T_282; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_284 = _csignals_T_175 ? 5'h4 : _csignals_T_283; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_285 = _csignals_T_173 ? 5'h2 : _csignals_T_284; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_286 = _csignals_T_171 ? 5'h3 : _csignals_T_285; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_287 = _csignals_T_169 ? 5'h1 : _csignals_T_286; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_288 = _csignals_T_167 ? 5'h8 : _csignals_T_287; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_289 = _csignals_T_165 ? 5'h2 : _csignals_T_288; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_290 = _csignals_T_163 ? 5'h5 : _csignals_T_289; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_291 = _csignals_T_161 ? 5'h5 : _csignals_T_290; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_292 = _csignals_T_159 ? 5'h0 : _csignals_T_291; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_293 = _csignals_T_157 ? 5'h0 : _csignals_T_292; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_294 = _csignals_T_155 ? 5'h0 : _csignals_T_293; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_295 = _csignals_T_153 ? 5'h0 : _csignals_T_294; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_296 = _csignals_T_151 ? 5'h0 : _csignals_T_295; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_297 = _csignals_T_149 ? 5'h0 : _csignals_T_296; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_298 = _csignals_T_147 ? 5'h0 : _csignals_T_297; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_299 = _csignals_T_145 ? 5'h0 : _csignals_T_298; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_300 = _csignals_T_143 ? 5'hf : _csignals_T_299; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_301 = _csignals_T_141 ? 5'h5 : _csignals_T_300; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_302 = _csignals_T_139 ? 5'h5 : _csignals_T_301; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_303 = _csignals_T_137 ? 5'h4 : _csignals_T_302; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_304 = _csignals_T_135 ? 5'h9 : _csignals_T_303; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_305 = _csignals_T_133 ? 5'hb : _csignals_T_304; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_306 = _csignals_T_131 ? 5'ha : _csignals_T_305; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_307 = _csignals_T_129 ? 5'hb : _csignals_T_306; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_308 = _csignals_T_127 ? 5'ha : _csignals_T_307; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_309 = _csignals_T_125 ? 5'h9 : _csignals_T_308; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_310 = _csignals_T_123 ? 5'h8 : _csignals_T_309; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_311 = _csignals_T_121 ? 5'h7 : _csignals_T_310; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_312 = _csignals_T_119 ? 5'h6 : _csignals_T_311; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_313 = _csignals_T_117 ? 5'h5 : _csignals_T_312; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_314 = _csignals_T_115 ? 5'hf : _csignals_T_313; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_315 = _csignals_T_113 ? 5'he : _csignals_T_314; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_316 = _csignals_T_111 ? 5'hd : _csignals_T_315; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_317 = _csignals_T_109 ? 5'hc : _csignals_T_316; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_318 = _csignals_T_107 ? 5'hf : _csignals_T_317; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_319 = _csignals_T_105 ? 5'hd : _csignals_T_318; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_320 = _csignals_T_103 ? 5'he : _csignals_T_319; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_321 = _csignals_T_101 ? 5'hc : _csignals_T_320; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_322 = _csignals_T_99 ? 5'hb : _csignals_T_321; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_323 = _csignals_T_97 ? 5'ha : _csignals_T_322; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_324 = _csignals_T_95 ? 5'h9 : _csignals_T_323; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_325 = _csignals_T_93 ? 5'h8 : _csignals_T_324; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_326 = _csignals_T_91 ? 5'h0 : _csignals_T_325; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_327 = _csignals_T_89 ? 5'h19 : _csignals_T_326; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_328 = _csignals_T_87 ? 5'h18 : _csignals_T_327; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_329 = _csignals_T_85 ? 5'h0 : _csignals_T_328; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_330 = _csignals_T_83 ? 5'h0 : _csignals_T_329; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_331 = _csignals_T_81 ? 5'h0 : _csignals_T_330; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_332 = _csignals_T_79 ? 5'h0 : _csignals_T_331; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_333 = _csignals_T_77 ? 5'h0 : _csignals_T_332; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_334 = _csignals_T_75 ? 5'h0 : _csignals_T_333; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_335 = _csignals_T_73 ? 5'h0 : _csignals_T_334; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_336 = _csignals_T_71 ? 5'h0 : _csignals_T_335; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_337 = _csignals_T_69 ? 5'h0 : _csignals_T_336; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_338 = _csignals_T_67 ? 5'h0 : _csignals_T_337; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_339 = _csignals_T_65 ? 5'h16 : _csignals_T_338; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_340 = _csignals_T_63 ? 5'h14 : _csignals_T_339; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_341 = _csignals_T_61 ? 5'h17 : _csignals_T_340; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_342 = _csignals_T_59 ? 5'h15 : _csignals_T_341; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_343 = _csignals_T_57 ? 5'h13 : _csignals_T_342; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_344 = _csignals_T_55 ? 5'h12 : _csignals_T_343; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_345 = _csignals_T_53 ? 5'h7 : _csignals_T_344; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_346 = _csignals_T_51 ? 5'h6 : _csignals_T_345; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_347 = _csignals_T_49 ? 5'h7 : _csignals_T_346; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_348 = _csignals_T_47 ? 5'h6 : _csignals_T_347; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_349 = _csignals_T_45 ? 5'h5 : _csignals_T_348; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_350 = _csignals_T_43 ? 5'h5 : _csignals_T_349; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_351 = _csignals_T_41 ? 5'h4 : _csignals_T_350; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_352 = _csignals_T_39 ? 5'h5 : _csignals_T_351; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_353 = _csignals_T_37 ? 5'h5 : _csignals_T_352; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_354 = _csignals_T_35 ? 5'h4 : _csignals_T_353; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_355 = _csignals_T_33 ? 5'h1 : _csignals_T_354; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_356 = _csignals_T_31 ? 5'h3 : _csignals_T_355; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_357 = _csignals_T_29 ? 5'h2 : _csignals_T_356; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_358 = _csignals_T_27 ? 5'h1 : _csignals_T_357; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_359 = _csignals_T_25 ? 5'h3 : _csignals_T_358; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_360 = _csignals_T_23 ? 5'h2 : _csignals_T_359; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_361 = _csignals_T_21 ? 5'h8 : _csignals_T_360; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_362 = _csignals_T_19 ? 5'h0 : _csignals_T_361; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_363 = _csignals_T_17 ? 5'h0 : _csignals_T_362; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_364 = _csignals_T_15 ? 5'h0 : _csignals_T_363; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_365 = _csignals_T_13 ? 5'h0 : _csignals_T_364; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_366 = _csignals_T_11 ? 5'h0 : _csignals_T_365; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_367 = _csignals_T_9 ? 5'h0 : _csignals_T_366; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_368 = _csignals_T_7 ? 5'h0 : _csignals_T_367; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_369 = _csignals_T_5 ? 5'h0 : _csignals_T_368; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_370 = _csignals_T_3 ? 5'h0 : _csignals_T_369; // @[Lookup.scala 34:39]
  wire [4:0] csignals_0 = _csignals_T_1 ? 5'h0 : _csignals_T_370; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_371 = _csignals_T_247 ? 3'h7 : 3'h4; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_372 = _csignals_T_245 ? 3'h7 : _csignals_T_371; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_373 = _csignals_T_243 ? 3'h7 : _csignals_T_372; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_374 = _csignals_T_241 ? 3'h0 : _csignals_T_373; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_375 = _csignals_T_239 ? 3'h7 : _csignals_T_374; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_376 = _csignals_T_237 ? 3'h7 : _csignals_T_375; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_377 = _csignals_T_235 ? 3'h7 : _csignals_T_376; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_378 = _csignals_T_233 ? 3'h7 : _csignals_T_377; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_379 = _csignals_T_231 ? 3'h7 : _csignals_T_378; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_380 = _csignals_T_229 ? 3'h0 : _csignals_T_379; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_381 = _csignals_T_227 ? 3'h7 : _csignals_T_380; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_382 = _csignals_T_225 ? 3'h7 : _csignals_T_381; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_383 = _csignals_T_223 ? 3'h7 : _csignals_T_382; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_384 = _csignals_T_221 ? 3'h7 : _csignals_T_383; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_385 = _csignals_T_219 ? 3'h7 : _csignals_T_384; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_386 = _csignals_T_217 ? 3'h7 : _csignals_T_385; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_387 = _csignals_T_215 ? 3'h1 : _csignals_T_386; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_388 = _csignals_T_213 ? 3'h7 : _csignals_T_387; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_389 = _csignals_T_211 ? 3'h7 : _csignals_T_388; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_390 = _csignals_T_209 ? 3'h7 : _csignals_T_389; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_391 = _csignals_T_207 ? 3'h7 : _csignals_T_390; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_392 = _csignals_T_205 ? 3'h7 : _csignals_T_391; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_393 = _csignals_T_203 ? 3'h7 : _csignals_T_392; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_394 = _csignals_T_201 ? 3'h7 : _csignals_T_393; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_395 = _csignals_T_199 ? 3'h7 : _csignals_T_394; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_396 = _csignals_T_197 ? 3'h7 : _csignals_T_395; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_397 = _csignals_T_195 ? 3'h5 : _csignals_T_396; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_398 = _csignals_T_193 ? 3'h0 : _csignals_T_397; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_399 = _csignals_T_191 ? 3'h6 : _csignals_T_398; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_400 = _csignals_T_189 ? 3'h6 : _csignals_T_399; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_401 = _csignals_T_187 ? 3'h1 : _csignals_T_400; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_402 = _csignals_T_185 ? 3'h5 : _csignals_T_401; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_403 = _csignals_T_183 ? 3'h5 : _csignals_T_402; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_404 = _csignals_T_181 ? 3'h7 : _csignals_T_403; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_405 = _csignals_T_179 ? 3'h7 : _csignals_T_404; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_406 = _csignals_T_177 ? 3'h1 : _csignals_T_405; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_407 = _csignals_T_175 ? 3'h5 : _csignals_T_406; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_408 = _csignals_T_173 ? 3'h7 : _csignals_T_407; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_409 = _csignals_T_171 ? 3'h7 : _csignals_T_408; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_410 = _csignals_T_169 ? 3'h7 : _csignals_T_409; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_411 = _csignals_T_167 ? 3'h7 : _csignals_T_410; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_412 = _csignals_T_165 ? 3'h7 : _csignals_T_411; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_413 = _csignals_T_163 ? 3'h7 : _csignals_T_412; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_414 = _csignals_T_161 ? 3'h7 : _csignals_T_413; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_415 = _csignals_T_159 ? 3'h0 : _csignals_T_414; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_416 = _csignals_T_157 ? 3'h0 : _csignals_T_415; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_417 = _csignals_T_155 ? 3'h7 : _csignals_T_416; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_418 = _csignals_T_153 ? 3'h7 : _csignals_T_417; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_419 = _csignals_T_151 ? 3'h5 : _csignals_T_418; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_420 = _csignals_T_149 ? 3'h5 : _csignals_T_419; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_421 = _csignals_T_147 ? 3'h6 : _csignals_T_420; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_422 = _csignals_T_145 ? 3'h0 : _csignals_T_421; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_423 = _csignals_T_143 ? 3'h4 : _csignals_T_422; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_424 = _csignals_T_141 ? 3'h4 : _csignals_T_423; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_425 = _csignals_T_139 ? 3'h4 : _csignals_T_424; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_426 = _csignals_T_137 ? 3'h4 : _csignals_T_425; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_427 = _csignals_T_135 ? 3'h4 : _csignals_T_426; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_428 = _csignals_T_133 ? 3'h4 : _csignals_T_427; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_429 = _csignals_T_131 ? 3'h4 : _csignals_T_428; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_430 = _csignals_T_129 ? 3'h4 : _csignals_T_429; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_431 = _csignals_T_127 ? 3'h4 : _csignals_T_430; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_432 = _csignals_T_125 ? 3'h4 : _csignals_T_431; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_433 = _csignals_T_123 ? 3'h4 : _csignals_T_432; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_434 = _csignals_T_121 ? 3'h4 : _csignals_T_433; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_435 = _csignals_T_119 ? 3'h4 : _csignals_T_434; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_436 = _csignals_T_117 ? 3'h4 : _csignals_T_435; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_437 = _csignals_T_115 ? 3'h4 : _csignals_T_436; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_438 = _csignals_T_113 ? 3'h4 : _csignals_T_437; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_439 = _csignals_T_111 ? 3'h4 : _csignals_T_438; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_440 = _csignals_T_109 ? 3'h4 : _csignals_T_439; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_441 = _csignals_T_107 ? 3'h4 : _csignals_T_440; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_442 = _csignals_T_105 ? 3'h4 : _csignals_T_441; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_443 = _csignals_T_103 ? 3'h4 : _csignals_T_442; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_444 = _csignals_T_101 ? 3'h4 : _csignals_T_443; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_445 = _csignals_T_99 ? 3'h4 : _csignals_T_444; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_446 = _csignals_T_97 ? 3'h4 : _csignals_T_445; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_447 = _csignals_T_95 ? 3'h4 : _csignals_T_446; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_448 = _csignals_T_93 ? 3'h4 : _csignals_T_447; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_449 = _csignals_T_91 ? 3'h0 : _csignals_T_448; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_450 = _csignals_T_89 ? 3'h0 : _csignals_T_449; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_451 = _csignals_T_87 ? 3'h0 : _csignals_T_450; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_452 = _csignals_T_85 ? 3'h2 : _csignals_T_451; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_453 = _csignals_T_83 ? 3'h4 : _csignals_T_452; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_454 = _csignals_T_81 ? 3'h2 : _csignals_T_453; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_455 = _csignals_T_79 ? 3'h4 : _csignals_T_454; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_456 = _csignals_T_77 ? 3'h2 : _csignals_T_455; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_457 = _csignals_T_75 ? 3'h4 : _csignals_T_456; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_458 = _csignals_T_73 ? 3'h1 : _csignals_T_457; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_459 = _csignals_T_71 ? 3'h0 : _csignals_T_458; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_460 = _csignals_T_69 ? 3'h4 : _csignals_T_459; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_461 = _csignals_T_67 ? 3'h1 : _csignals_T_460; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_462 = _csignals_T_65 ? 3'h4 : _csignals_T_461; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_463 = _csignals_T_63 ? 3'h4 : _csignals_T_462; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_464 = _csignals_T_61 ? 3'h4 : _csignals_T_463; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_465 = _csignals_T_59 ? 3'h4 : _csignals_T_464; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_466 = _csignals_T_57 ? 3'h4 : _csignals_T_465; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_467 = _csignals_T_55 ? 3'h4 : _csignals_T_466; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_468 = _csignals_T_53 ? 3'h4 : _csignals_T_467; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_469 = _csignals_T_51 ? 3'h4 : _csignals_T_468; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_470 = _csignals_T_49 ? 3'h4 : _csignals_T_469; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_471 = _csignals_T_47 ? 3'h4 : _csignals_T_470; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_472 = _csignals_T_45 ? 3'h4 : _csignals_T_471; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_473 = _csignals_T_43 ? 3'h4 : _csignals_T_472; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_474 = _csignals_T_41 ? 3'h4 : _csignals_T_473; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_475 = _csignals_T_39 ? 3'h4 : _csignals_T_474; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_476 = _csignals_T_37 ? 3'h4 : _csignals_T_475; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_477 = _csignals_T_35 ? 3'h4 : _csignals_T_476; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_478 = _csignals_T_33 ? 3'h4 : _csignals_T_477; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_479 = _csignals_T_31 ? 3'h4 : _csignals_T_478; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_480 = _csignals_T_29 ? 3'h4 : _csignals_T_479; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_481 = _csignals_T_27 ? 3'h4 : _csignals_T_480; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_482 = _csignals_T_25 ? 3'h4 : _csignals_T_481; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_483 = _csignals_T_23 ? 3'h4 : _csignals_T_482; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_484 = _csignals_T_21 ? 3'h4 : _csignals_T_483; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_485 = _csignals_T_19 ? 3'h4 : _csignals_T_484; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_486 = _csignals_T_17 ? 3'h4 : _csignals_T_485; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_487 = _csignals_T_15 ? 3'h4 : _csignals_T_486; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_488 = _csignals_T_13 ? 3'h4 : _csignals_T_487; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_489 = _csignals_T_11 ? 3'h4 : _csignals_T_488; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_490 = _csignals_T_9 ? 3'h4 : _csignals_T_489; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_491 = _csignals_T_7 ? 3'h4 : _csignals_T_490; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_492 = _csignals_T_5 ? 3'h4 : _csignals_T_491; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_493 = _csignals_T_3 ? 3'h4 : _csignals_T_492; // @[Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h4 : _csignals_T_493; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_494 = _csignals_T_247 ? 5'h3 : 5'h1; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_495 = _csignals_T_245 ? 5'h3 : _csignals_T_494; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_496 = _csignals_T_243 ? 5'h1c : _csignals_T_495; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_497 = _csignals_T_241 ? 5'h7 : _csignals_T_496; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_498 = _csignals_T_239 ? 5'h1a : _csignals_T_497; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_499 = _csignals_T_237 ? 5'h3 : _csignals_T_498; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_500 = _csignals_T_235 ? 5'h1b : _csignals_T_499; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_501 = _csignals_T_233 ? 5'h6 : _csignals_T_500; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_502 = _csignals_T_231 ? 5'h6 : _csignals_T_501; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_503 = _csignals_T_229 ? 5'h7 : _csignals_T_502; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_504 = _csignals_T_227 ? 5'h19 : _csignals_T_503; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_505 = _csignals_T_225 ? 5'h0 : _csignals_T_504; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_506 = _csignals_T_223 ? 5'h0 : _csignals_T_505; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_507 = _csignals_T_221 ? 5'h0 : _csignals_T_506; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_508 = _csignals_T_219 ? 5'h18 : _csignals_T_507; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_509 = _csignals_T_217 ? 5'h6 : _csignals_T_508; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_510 = _csignals_T_215 ? 5'h1d : _csignals_T_509; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_511 = _csignals_T_213 ? 5'h13 : _csignals_T_510; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_512 = _csignals_T_211 ? 5'h17 : _csignals_T_511; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_513 = _csignals_T_209 ? 5'h16 : _csignals_T_512; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_514 = _csignals_T_207 ? 5'h15 : _csignals_T_513; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_515 = _csignals_T_205 ? 5'h14 : _csignals_T_514; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_516 = _csignals_T_203 ? 5'h14 : _csignals_T_515; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_517 = _csignals_T_201 ? 5'h14 : _csignals_T_516; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_518 = _csignals_T_199 ? 5'h13 : _csignals_T_517; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_519 = _csignals_T_197 ? 5'h13 : _csignals_T_518; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_520 = _csignals_T_195 ? 5'h2 : _csignals_T_519; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_521 = _csignals_T_193 ? 5'h2 : _csignals_T_520; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_522 = _csignals_T_191 ? 5'h12 : _csignals_T_521; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_523 = _csignals_T_189 ? 5'h11 : _csignals_T_522; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_524 = _csignals_T_187 ? 5'h10 : _csignals_T_523; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_525 = _csignals_T_185 ? 5'h0 : _csignals_T_524; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_526 = _csignals_T_183 ? 5'h0 : _csignals_T_525; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_527 = _csignals_T_181 ? 5'h0 : _csignals_T_526; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_528 = _csignals_T_179 ? 5'h0 : _csignals_T_527; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_529 = _csignals_T_177 ? 5'h10 : _csignals_T_528; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_530 = _csignals_T_175 ? 5'hd : _csignals_T_529; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_531 = _csignals_T_173 ? 5'h6 : _csignals_T_530; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_532 = _csignals_T_171 ? 5'h6 : _csignals_T_531; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_533 = _csignals_T_169 ? 5'h6 : _csignals_T_532; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_534 = _csignals_T_167 ? 5'h6 : _csignals_T_533; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_535 = _csignals_T_165 ? 5'hd : _csignals_T_534; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_536 = _csignals_T_163 ? 5'hd : _csignals_T_535; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_537 = _csignals_T_161 ? 5'hd : _csignals_T_536; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_538 = _csignals_T_159 ? 5'hf : _csignals_T_537; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_539 = _csignals_T_157 ? 5'hd : _csignals_T_538; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_540 = _csignals_T_155 ? 5'he : _csignals_T_539; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_541 = _csignals_T_153 ? 5'he : _csignals_T_540; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_542 = _csignals_T_151 ? 5'hd : _csignals_T_541; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_543 = _csignals_T_149 ? 5'hc : _csignals_T_542; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_544 = _csignals_T_147 ? 5'hb : _csignals_T_543; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_545 = _csignals_T_145 ? 5'h0 : _csignals_T_544; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_546 = _csignals_T_143 ? 5'h1 : _csignals_T_545; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_547 = _csignals_T_141 ? 5'h4 : _csignals_T_546; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_548 = _csignals_T_139 ? 5'h1 : _csignals_T_547; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_549 = _csignals_T_137 ? 5'h1 : _csignals_T_548; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_550 = _csignals_T_135 ? 5'h1 : _csignals_T_549; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_551 = _csignals_T_133 ? 5'h1 : _csignals_T_550; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_552 = _csignals_T_131 ? 5'h1 : _csignals_T_551; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_553 = _csignals_T_129 ? 5'h0 : _csignals_T_552; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_554 = _csignals_T_127 ? 5'h0 : _csignals_T_553; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_555 = _csignals_T_125 ? 5'h0 : _csignals_T_554; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_556 = _csignals_T_123 ? 5'h0 : _csignals_T_555; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_557 = _csignals_T_121 ? 5'h0 : _csignals_T_556; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_558 = _csignals_T_119 ? 5'h0 : _csignals_T_557; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_559 = _csignals_T_117 ? 5'h0 : _csignals_T_558; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_560 = _csignals_T_115 ? 5'h1 : _csignals_T_559; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_561 = _csignals_T_113 ? 5'h1 : _csignals_T_560; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_562 = _csignals_T_111 ? 5'h1 : _csignals_T_561; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_563 = _csignals_T_109 ? 5'h1 : _csignals_T_562; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_564 = _csignals_T_107 ? 5'h1 : _csignals_T_563; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_565 = _csignals_T_105 ? 5'h1 : _csignals_T_564; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_566 = _csignals_T_103 ? 5'h1 : _csignals_T_565; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_567 = _csignals_T_101 ? 5'h1 : _csignals_T_566; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_568 = _csignals_T_99 ? 5'h1 : _csignals_T_567; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_569 = _csignals_T_97 ? 5'h1 : _csignals_T_568; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_570 = _csignals_T_95 ? 5'h1 : _csignals_T_569; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_571 = _csignals_T_93 ? 5'h1 : _csignals_T_570; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_572 = _csignals_T_91 ? 5'h0 : _csignals_T_571; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_573 = _csignals_T_89 ? 5'h0 : _csignals_T_572; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_574 = _csignals_T_87 ? 5'h0 : _csignals_T_573; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_575 = _csignals_T_85 ? 5'h0 : _csignals_T_574; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_576 = _csignals_T_83 ? 5'h0 : _csignals_T_575; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_577 = _csignals_T_81 ? 5'h0 : _csignals_T_576; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_578 = _csignals_T_79 ? 5'h0 : _csignals_T_577; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_579 = _csignals_T_77 ? 5'h0 : _csignals_T_578; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_580 = _csignals_T_75 ? 5'h0 : _csignals_T_579; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_581 = _csignals_T_73 ? 5'ha : _csignals_T_580; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_582 = _csignals_T_71 ? 5'ha : _csignals_T_581; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_583 = _csignals_T_69 ? 5'h4 : _csignals_T_582; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_584 = _csignals_T_67 ? 5'h9 : _csignals_T_583; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_585 = _csignals_T_65 ? 5'h1 : _csignals_T_584; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_586 = _csignals_T_63 ? 5'h1 : _csignals_T_585; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_587 = _csignals_T_61 ? 5'h1 : _csignals_T_586; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_588 = _csignals_T_59 ? 5'h1 : _csignals_T_587; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_589 = _csignals_T_57 ? 5'h1 : _csignals_T_588; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_590 = _csignals_T_55 ? 5'h1 : _csignals_T_589; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_591 = _csignals_T_53 ? 5'h4 : _csignals_T_590; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_592 = _csignals_T_51 ? 5'h4 : _csignals_T_591; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_593 = _csignals_T_49 ? 5'h1 : _csignals_T_592; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_594 = _csignals_T_47 ? 5'h1 : _csignals_T_593; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_595 = _csignals_T_45 ? 5'h4 : _csignals_T_594; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_596 = _csignals_T_43 ? 5'h4 : _csignals_T_595; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_597 = _csignals_T_41 ? 5'h4 : _csignals_T_596; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_598 = _csignals_T_39 ? 5'h1 : _csignals_T_597; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_599 = _csignals_T_37 ? 5'h1 : _csignals_T_598; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_600 = _csignals_T_35 ? 5'h1 : _csignals_T_599; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_601 = _csignals_T_33 ? 5'h4 : _csignals_T_600; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_602 = _csignals_T_31 ? 5'h4 : _csignals_T_601; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_603 = _csignals_T_29 ? 5'h4 : _csignals_T_602; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_604 = _csignals_T_27 ? 5'h1 : _csignals_T_603; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_605 = _csignals_T_25 ? 5'h1 : _csignals_T_604; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_606 = _csignals_T_23 ? 5'h1 : _csignals_T_605; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_607 = _csignals_T_21 ? 5'h1 : _csignals_T_606; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_608 = _csignals_T_19 ? 5'h4 : _csignals_T_607; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_609 = _csignals_T_17 ? 5'h1 : _csignals_T_608; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_610 = _csignals_T_15 ? 5'h8 : _csignals_T_609; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_611 = _csignals_T_13 ? 5'h4 : _csignals_T_610; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_612 = _csignals_T_11 ? 5'h8 : _csignals_T_611; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_613 = _csignals_T_9 ? 5'h4 : _csignals_T_612; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_614 = _csignals_T_7 ? 5'h4 : _csignals_T_613; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_615 = _csignals_T_5 ? 5'h8 : _csignals_T_614; // @[Lookup.scala 34:39]
  wire [4:0] _csignals_T_616 = _csignals_T_3 ? 5'h4 : _csignals_T_615; // @[Lookup.scala 34:39]
  wire [4:0] csignals_2 = _csignals_T_1 ? 5'h4 : _csignals_T_616; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_634 = _csignals_T_213 ? 3'h5 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_635 = _csignals_T_211 ? 3'h0 : _csignals_T_634; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_636 = _csignals_T_209 ? 3'h0 : _csignals_T_635; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_637 = _csignals_T_207 ? 3'h0 : _csignals_T_636; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_638 = _csignals_T_205 ? 3'h5 : _csignals_T_637; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_639 = _csignals_T_203 ? 3'h0 : _csignals_T_638; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_640 = _csignals_T_201 ? 3'h0 : _csignals_T_639; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_641 = _csignals_T_199 ? 3'h0 : _csignals_T_640; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_642 = _csignals_T_197 ? 3'h0 : _csignals_T_641; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_643 = _csignals_T_195 ? 3'h0 : _csignals_T_642; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_644 = _csignals_T_193 ? 3'h0 : _csignals_T_643; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_645 = _csignals_T_191 ? 3'h6 : _csignals_T_644; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_646 = _csignals_T_189 ? 3'h0 : _csignals_T_645; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_647 = _csignals_T_187 ? 3'h0 : _csignals_T_646; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_648 = _csignals_T_185 ? 3'h0 : _csignals_T_647; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_649 = _csignals_T_183 ? 3'h0 : _csignals_T_648; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_650 = _csignals_T_181 ? 3'h0 : _csignals_T_649; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_651 = _csignals_T_179 ? 3'h0 : _csignals_T_650; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_652 = _csignals_T_177 ? 3'h0 : _csignals_T_651; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_653 = _csignals_T_175 ? 3'h0 : _csignals_T_652; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_654 = _csignals_T_173 ? 3'h0 : _csignals_T_653; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_655 = _csignals_T_171 ? 3'h0 : _csignals_T_654; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_656 = _csignals_T_169 ? 3'h0 : _csignals_T_655; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_657 = _csignals_T_167 ? 3'h0 : _csignals_T_656; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_658 = _csignals_T_165 ? 3'h0 : _csignals_T_657; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_659 = _csignals_T_163 ? 3'h0 : _csignals_T_658; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_660 = _csignals_T_161 ? 3'h1 : _csignals_T_659; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_661 = _csignals_T_159 ? 3'h0 : _csignals_T_660; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_662 = _csignals_T_157 ? 3'h0 : _csignals_T_661; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_663 = _csignals_T_155 ? 3'h5 : _csignals_T_662; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_664 = _csignals_T_153 ? 3'h0 : _csignals_T_663; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_665 = _csignals_T_151 ? 3'h0 : _csignals_T_664; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_666 = _csignals_T_149 ? 3'h0 : _csignals_T_665; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_667 = _csignals_T_147 ? 3'h0 : _csignals_T_666; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_145 ? 3'h0 : _csignals_T_667; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_143 ? 3'h7 : _csignals_T_668; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_141 ? 3'h3 : _csignals_T_669; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_139 ? 3'h3 : _csignals_T_670; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_137 ? 3'h3 : _csignals_T_671; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_135 ? 3'h0 : _csignals_T_672; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_133 ? 3'h0 : _csignals_T_673; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_131 ? 3'h0 : _csignals_T_674; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_129 ? 3'h0 : _csignals_T_675; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_677 = _csignals_T_127 ? 3'h0 : _csignals_T_676; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_678 = _csignals_T_125 ? 3'h0 : _csignals_T_677; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_679 = _csignals_T_123 ? 3'h0 : _csignals_T_678; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_680 = _csignals_T_121 ? 3'h0 : _csignals_T_679; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_681 = _csignals_T_119 ? 3'h0 : _csignals_T_680; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_682 = _csignals_T_117 ? 3'h0 : _csignals_T_681; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_683 = _csignals_T_115 ? 3'h0 : _csignals_T_682; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_684 = _csignals_T_113 ? 3'h0 : _csignals_T_683; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_685 = _csignals_T_111 ? 3'h0 : _csignals_T_684; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_686 = _csignals_T_109 ? 3'h0 : _csignals_T_685; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_687 = _csignals_T_107 ? 3'h0 : _csignals_T_686; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_688 = _csignals_T_105 ? 3'h0 : _csignals_T_687; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_689 = _csignals_T_103 ? 3'h0 : _csignals_T_688; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_690 = _csignals_T_101 ? 3'h0 : _csignals_T_689; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_691 = _csignals_T_99 ? 3'h0 : _csignals_T_690; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_692 = _csignals_T_97 ? 3'h0 : _csignals_T_691; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_693 = _csignals_T_95 ? 3'h0 : _csignals_T_692; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_694 = _csignals_T_93 ? 3'h0 : _csignals_T_693; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_695 = _csignals_T_91 ? 3'h0 : _csignals_T_694; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_696 = _csignals_T_89 ? 3'h0 : _csignals_T_695; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_697 = _csignals_T_87 ? 3'h0 : _csignals_T_696; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_698 = _csignals_T_85 ? 3'h0 : _csignals_T_697; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_699 = _csignals_T_83 ? 3'h0 : _csignals_T_698; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_700 = _csignals_T_81 ? 3'h0 : _csignals_T_699; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_701 = _csignals_T_79 ? 3'h0 : _csignals_T_700; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_702 = _csignals_T_77 ? 3'h0 : _csignals_T_701; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_703 = _csignals_T_75 ? 3'h0 : _csignals_T_702; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_704 = _csignals_T_73 ? 3'h0 : _csignals_T_703; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_705 = _csignals_T_71 ? 3'h0 : _csignals_T_704; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_706 = _csignals_T_69 ? 3'h0 : _csignals_T_705; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_707 = _csignals_T_67 ? 3'h0 : _csignals_T_706; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_65 ? 3'h0 : _csignals_T_707; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_63 ? 3'h0 : _csignals_T_708; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_61 ? 3'h0 : _csignals_T_709; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_59 ? 3'h0 : _csignals_T_710; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_712 = _csignals_T_57 ? 3'h0 : _csignals_T_711; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_713 = _csignals_T_55 ? 3'h0 : _csignals_T_712; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_53 ? 3'h0 : _csignals_T_713; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_51 ? 3'h0 : _csignals_T_714; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_49 ? 3'h0 : _csignals_T_715; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_47 ? 3'h0 : _csignals_T_716; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_45 ? 3'h1 : _csignals_T_717; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_43 ? 3'h0 : _csignals_T_718; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_41 ? 3'h0 : _csignals_T_719; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_39 ? 3'h1 : _csignals_T_720; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_37 ? 3'h0 : _csignals_T_721; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_35 ? 3'h0 : _csignals_T_722; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_33 ? 3'h0 : _csignals_T_723; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_31 ? 3'h0 : _csignals_T_724; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_29 ? 3'h0 : _csignals_T_725; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_27 ? 3'h0 : _csignals_T_726; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_25 ? 3'h0 : _csignals_T_727; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_23 ? 3'h0 : _csignals_T_728; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_21 ? 3'h0 : _csignals_T_729; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_19 ? 3'h0 : _csignals_T_730; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_17 ? 3'h0 : _csignals_T_731; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_15 ? 3'h4 : _csignals_T_732; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_13 ? 3'h0 : _csignals_T_733; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_11 ? 3'h4 : _csignals_T_734; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_9 ? 3'h0 : _csignals_T_735; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_7 ? 3'h0 : _csignals_T_736; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_5 ? 3'h4 : _csignals_T_737; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_3 ? 3'h0 : _csignals_T_738; // @[Lookup.scala 34:39]
  wire [2:0] csignals_3 = _csignals_T_1 ? 3'h0 : _csignals_T_739; // @[Lookup.scala 34:39]
  wire  _csignals_T_747 = _csignals_T_233 ? 1'h0 : _csignals_T_235 | (_csignals_T_237 | (_csignals_T_239 | (
    _csignals_T_241 | (_csignals_T_243 | (_csignals_T_245 | _csignals_T_247))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_748 = _csignals_T_231 ? 1'h0 : _csignals_T_747; // @[Lookup.scala 34:39]
  wire  _csignals_T_757 = _csignals_T_213 ? 1'h0 : _csignals_T_215 | (_csignals_T_217 | (_csignals_T_219 | (
    _csignals_T_221 | (_csignals_T_223 | (_csignals_T_225 | (_csignals_T_227 | (_csignals_T_229 | _csignals_T_748)))))))
    ; // @[Lookup.scala 34:39]
  wire  _csignals_T_758 = _csignals_T_211 ? 1'h0 : _csignals_T_757; // @[Lookup.scala 34:39]
  wire  _csignals_T_759 = _csignals_T_209 ? 1'h0 : _csignals_T_758; // @[Lookup.scala 34:39]
  wire  _csignals_T_760 = _csignals_T_207 ? 1'h0 : _csignals_T_759; // @[Lookup.scala 34:39]
  wire  _csignals_T_761 = _csignals_T_205 ? 1'h0 : _csignals_T_760; // @[Lookup.scala 34:39]
  wire  _csignals_T_768 = _csignals_T_191 ? 1'h0 : _csignals_T_193 | (_csignals_T_195 | (_csignals_T_197 | (
    _csignals_T_199 | (_csignals_T_201 | (_csignals_T_203 | _csignals_T_761))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_772 = _csignals_T_183 ? 1'h0 : _csignals_T_185 | (_csignals_T_187 | (_csignals_T_189 |
    _csignals_T_768)); // @[Lookup.scala 34:39]
  wire  _csignals_T_773 = _csignals_T_181 ? 1'h0 : _csignals_T_772; // @[Lookup.scala 34:39]
  wire  _csignals_T_774 = _csignals_T_179 ? 1'h0 : _csignals_T_773; // @[Lookup.scala 34:39]
  wire  _csignals_T_775 = _csignals_T_177 ? 1'h0 : _csignals_T_774; // @[Lookup.scala 34:39]
  wire  _csignals_T_786 = _csignals_T_155 ? 1'h0 : _csignals_T_157 | (_csignals_T_159 | (_csignals_T_161 | (
    _csignals_T_163 | (_csignals_T_165 | (_csignals_T_167 | (_csignals_T_169 | (_csignals_T_171 | (_csignals_T_173 | (
    _csignals_T_175 | _csignals_T_775))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_791 = _csignals_T_145 ? 1'h0 : _csignals_T_147 | (_csignals_T_149 | (_csignals_T_151 | (
    _csignals_T_153 | _csignals_T_786))); // @[Lookup.scala 34:39]
  wire  _csignals_T_818 = _csignals_T_91 ? 1'h0 : _csignals_T_93 | (_csignals_T_95 | (_csignals_T_97 | (_csignals_T_99
     | (_csignals_T_101 | (_csignals_T_103 | (_csignals_T_105 | (_csignals_T_107 | (_csignals_T_109 | (_csignals_T_111
     | (_csignals_T_113 | (_csignals_T_115 | (_csignals_T_117 | (_csignals_T_119 | (_csignals_T_121 | (_csignals_T_123
     | (_csignals_T_125 | (_csignals_T_127 | (_csignals_T_129 | (_csignals_T_131 | (_csignals_T_133 | (_csignals_T_135
     | (_csignals_T_137 | (_csignals_T_139 | (_csignals_T_141 | (_csignals_T_143 | _csignals_T_791))))))))))))))))))))))
    ))); // @[Lookup.scala 34:39]
  wire  _csignals_T_819 = _csignals_T_89 ? 1'h0 : _csignals_T_818; // @[Lookup.scala 34:39]
  wire  _csignals_T_820 = _csignals_T_87 ? 1'h0 : _csignals_T_819; // @[Lookup.scala 34:39]
  wire  _csignals_T_831 = _csignals_T_65 ? 1'h0 : _csignals_T_67 | (_csignals_T_69 | (_csignals_T_71 | (_csignals_T_73
     | (_csignals_T_75 | (_csignals_T_77 | (_csignals_T_79 | (_csignals_T_81 | (_csignals_T_83 | (_csignals_T_85 |
    _csignals_T_820))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_832 = _csignals_T_63 ? 1'h0 : _csignals_T_831; // @[Lookup.scala 34:39]
  wire  _csignals_T_833 = _csignals_T_61 ? 1'h0 : _csignals_T_832; // @[Lookup.scala 34:39]
  wire  _csignals_T_834 = _csignals_T_59 ? 1'h0 : _csignals_T_833; // @[Lookup.scala 34:39]
  wire  _csignals_T_835 = _csignals_T_57 ? 1'h0 : _csignals_T_834; // @[Lookup.scala 34:39]
  wire  _csignals_T_836 = _csignals_T_55 ? 1'h0 : _csignals_T_835; // @[Lookup.scala 34:39]
  wire  _csignals_T_856 = _csignals_T_15 ? 1'h0 : _csignals_T_17 | (_csignals_T_19 | (_csignals_T_21 | (_csignals_T_23
     | (_csignals_T_25 | (_csignals_T_27 | (_csignals_T_29 | (_csignals_T_31 | (_csignals_T_33 | (_csignals_T_35 | (
    _csignals_T_37 | (_csignals_T_39 | (_csignals_T_41 | (_csignals_T_43 | (_csignals_T_45 | (_csignals_T_47 | (
    _csignals_T_49 | (_csignals_T_51 | (_csignals_T_53 | _csignals_T_836)))))))))))))))))); // @[Lookup.scala 34:39]
  wire  _csignals_T_858 = _csignals_T_11 ? 1'h0 : _csignals_T_13 | _csignals_T_856; // @[Lookup.scala 34:39]
  wire  _csignals_T_861 = _csignals_T_5 ? 1'h0 : _csignals_T_7 | (_csignals_T_9 | _csignals_T_858); // @[Lookup.scala 34:39]
  wire  csignals_4 = _csignals_T_1 | (_csignals_T_3 | _csignals_T_861); // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_874 = _csignals_T_225 ? 3'h7 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_875 = _csignals_T_223 ? 3'h7 : _csignals_T_874; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_876 = _csignals_T_221 ? 3'h7 : _csignals_T_875; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_877 = _csignals_T_219 ? 3'h0 : _csignals_T_876; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_878 = _csignals_T_217 ? 3'h4 : _csignals_T_877; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_879 = _csignals_T_215 ? 3'h0 : _csignals_T_878; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_880 = _csignals_T_213 ? 3'h2 : _csignals_T_879; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_881 = _csignals_T_211 ? 3'h2 : _csignals_T_880; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_882 = _csignals_T_209 ? 3'h2 : _csignals_T_881; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_883 = _csignals_T_207 ? 3'h2 : _csignals_T_882; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_884 = _csignals_T_205 ? 3'h2 : _csignals_T_883; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_885 = _csignals_T_203 ? 3'h6 : _csignals_T_884; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_886 = _csignals_T_201 ? 3'h6 : _csignals_T_885; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_887 = _csignals_T_199 ? 3'h6 : _csignals_T_886; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_888 = _csignals_T_197 ? 3'h6 : _csignals_T_887; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_889 = _csignals_T_195 ? 3'h0 : _csignals_T_888; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_890 = _csignals_T_193 ? 3'h0 : _csignals_T_889; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_891 = _csignals_T_191 ? 3'h2 : _csignals_T_890; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_892 = _csignals_T_189 ? 3'h6 : _csignals_T_891; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_893 = _csignals_T_187 ? 3'h1 : _csignals_T_892; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_894 = _csignals_T_185 ? 3'h1 : _csignals_T_893; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_895 = _csignals_T_183 ? 3'h1 : _csignals_T_894; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_896 = _csignals_T_181 ? 3'h0 : _csignals_T_895; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_897 = _csignals_T_179 ? 3'h0 : _csignals_T_896; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_898 = _csignals_T_177 ? 3'h1 : _csignals_T_897; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_899 = _csignals_T_175 ? 3'h0 : _csignals_T_898; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_900 = _csignals_T_173 ? 3'h0 : _csignals_T_899; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_901 = _csignals_T_171 ? 3'h0 : _csignals_T_900; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_902 = _csignals_T_169 ? 3'h0 : _csignals_T_901; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_903 = _csignals_T_167 ? 3'h0 : _csignals_T_902; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_904 = _csignals_T_165 ? 3'h0 : _csignals_T_903; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_905 = _csignals_T_163 ? 3'h0 : _csignals_T_904; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_906 = _csignals_T_161 ? 3'h0 : _csignals_T_905; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_907 = _csignals_T_159 ? 3'h0 : _csignals_T_906; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_908 = _csignals_T_157 ? 3'h0 : _csignals_T_907; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_909 = _csignals_T_155 ? 3'h2 : _csignals_T_908; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_910 = _csignals_T_153 ? 3'h6 : _csignals_T_909; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_911 = _csignals_T_151 ? 3'h0 : _csignals_T_910; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_912 = _csignals_T_149 ? 3'h0 : _csignals_T_911; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_913 = _csignals_T_147 ? 3'h0 : _csignals_T_912; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_914 = _csignals_T_145 ? 3'h0 : _csignals_T_913; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_915 = _csignals_T_143 ? 3'h0 : _csignals_T_914; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_916 = _csignals_T_141 ? 3'h0 : _csignals_T_915; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_917 = _csignals_T_139 ? 3'h0 : _csignals_T_916; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_918 = _csignals_T_137 ? 3'h0 : _csignals_T_917; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_919 = _csignals_T_135 ? 3'h0 : _csignals_T_918; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_920 = _csignals_T_133 ? 3'h0 : _csignals_T_919; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_921 = _csignals_T_131 ? 3'h0 : _csignals_T_920; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_922 = _csignals_T_129 ? 3'h7 : _csignals_T_921; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_923 = _csignals_T_127 ? 3'h7 : _csignals_T_922; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_924 = _csignals_T_125 ? 3'h7 : _csignals_T_923; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_925 = _csignals_T_123 ? 3'h7 : _csignals_T_924; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_926 = _csignals_T_121 ? 3'h7 : _csignals_T_925; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_927 = _csignals_T_119 ? 3'h7 : _csignals_T_926; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_928 = _csignals_T_117 ? 3'h7 : _csignals_T_927; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_929 = _csignals_T_115 ? 3'h7 : _csignals_T_928; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_930 = _csignals_T_113 ? 3'h7 : _csignals_T_929; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_931 = _csignals_T_111 ? 3'h7 : _csignals_T_930; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_932 = _csignals_T_109 ? 3'h7 : _csignals_T_931; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_933 = _csignals_T_107 ? 3'h4 : _csignals_T_932; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_934 = _csignals_T_105 ? 3'h4 : _csignals_T_933; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_935 = _csignals_T_103 ? 3'h4 : _csignals_T_934; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_936 = _csignals_T_101 ? 3'h4 : _csignals_T_935; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_937 = _csignals_T_99 ? 3'h4 : _csignals_T_936; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_938 = _csignals_T_97 ? 3'h4 : _csignals_T_937; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_939 = _csignals_T_95 ? 3'h4 : _csignals_T_938; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_940 = _csignals_T_93 ? 3'h4 : _csignals_T_939; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_941 = _csignals_T_91 ? 3'h3 : _csignals_T_940; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_942 = _csignals_T_89 ? 3'h0 : _csignals_T_941; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_943 = _csignals_T_87 ? 3'h0 : _csignals_T_942; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_944 = _csignals_T_85 ? 3'h5 : _csignals_T_943; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_945 = _csignals_T_83 ? 3'h5 : _csignals_T_944; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_946 = _csignals_T_81 ? 3'h5 : _csignals_T_945; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_947 = _csignals_T_79 ? 3'h5 : _csignals_T_946; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_948 = _csignals_T_77 ? 3'h5 : _csignals_T_947; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_949 = _csignals_T_75 ? 3'h5 : _csignals_T_948; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_950 = _csignals_T_73 ? 3'h0 : _csignals_T_949; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_951 = _csignals_T_71 ? 3'h0 : _csignals_T_950; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_952 = _csignals_T_69 ? 3'h1 : _csignals_T_951; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_953 = _csignals_T_67 ? 3'h1 : _csignals_T_952; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_954 = _csignals_T_65 ? 3'h0 : _csignals_T_953; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_955 = _csignals_T_63 ? 3'h0 : _csignals_T_954; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_956 = _csignals_T_61 ? 3'h0 : _csignals_T_955; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_957 = _csignals_T_59 ? 3'h0 : _csignals_T_956; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_958 = _csignals_T_57 ? 3'h0 : _csignals_T_957; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_959 = _csignals_T_55 ? 3'h0 : _csignals_T_958; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_960 = _csignals_T_53 ? 3'h0 : _csignals_T_959; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_961 = _csignals_T_51 ? 3'h0 : _csignals_T_960; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_962 = _csignals_T_49 ? 3'h0 : _csignals_T_961; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_963 = _csignals_T_47 ? 3'h0 : _csignals_T_962; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_964 = _csignals_T_45 ? 3'h0 : _csignals_T_963; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_965 = _csignals_T_43 ? 3'h0 : _csignals_T_964; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_966 = _csignals_T_41 ? 3'h0 : _csignals_T_965; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_967 = _csignals_T_39 ? 3'h0 : _csignals_T_966; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_968 = _csignals_T_37 ? 3'h0 : _csignals_T_967; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_969 = _csignals_T_35 ? 3'h0 : _csignals_T_968; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_970 = _csignals_T_33 ? 3'h0 : _csignals_T_969; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_971 = _csignals_T_31 ? 3'h0 : _csignals_T_970; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_972 = _csignals_T_29 ? 3'h0 : _csignals_T_971; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_973 = _csignals_T_27 ? 3'h0 : _csignals_T_972; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_974 = _csignals_T_25 ? 3'h0 : _csignals_T_973; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_975 = _csignals_T_23 ? 3'h0 : _csignals_T_974; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_976 = _csignals_T_21 ? 3'h0 : _csignals_T_975; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_977 = _csignals_T_19 ? 3'h0 : _csignals_T_976; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_978 = _csignals_T_17 ? 3'h0 : _csignals_T_977; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_979 = _csignals_T_15 ? 3'h2 : _csignals_T_978; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_980 = _csignals_T_13 ? 3'h6 : _csignals_T_979; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_981 = _csignals_T_11 ? 3'h2 : _csignals_T_980; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_982 = _csignals_T_9 ? 3'h6 : _csignals_T_981; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_983 = _csignals_T_7 ? 3'h6 : _csignals_T_982; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_984 = _csignals_T_5 ? 3'h2 : _csignals_T_983; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_985 = _csignals_T_3 ? 3'h6 : _csignals_T_984; // @[Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h6 : _csignals_T_985; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_986 = _csignals_T_247 ? 3'h3 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_987 = _csignals_T_245 ? 3'h3 : _csignals_T_986; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_988 = _csignals_T_243 ? 3'h3 : _csignals_T_987; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_989 = _csignals_T_241 ? 3'h3 : _csignals_T_988; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_990 = _csignals_T_239 ? 3'h3 : _csignals_T_989; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_991 = _csignals_T_237 ? 3'h3 : _csignals_T_990; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_992 = _csignals_T_235 ? 3'h3 : _csignals_T_991; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_993 = _csignals_T_233 ? 3'h7 : _csignals_T_992; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_994 = _csignals_T_231 ? 3'h7 : _csignals_T_993; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_995 = _csignals_T_229 ? 3'h2 : _csignals_T_994; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_996 = _csignals_T_227 ? 3'h2 : _csignals_T_995; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_997 = _csignals_T_225 ? 3'h2 : _csignals_T_996; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_998 = _csignals_T_223 ? 3'h2 : _csignals_T_997; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_999 = _csignals_T_221 ? 3'h2 : _csignals_T_998; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1000 = _csignals_T_219 ? 3'h2 : _csignals_T_999; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1001 = _csignals_T_217 ? 3'h2 : _csignals_T_1000; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1002 = _csignals_T_215 ? 3'h3 : _csignals_T_1001; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1003 = _csignals_T_213 ? 3'h1 : _csignals_T_1002; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1004 = _csignals_T_211 ? 3'h1 : _csignals_T_1003; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1005 = _csignals_T_209 ? 3'h1 : _csignals_T_1004; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1006 = _csignals_T_207 ? 3'h1 : _csignals_T_1005; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1007 = _csignals_T_205 ? 3'h1 : _csignals_T_1006; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1008 = _csignals_T_203 ? 3'h3 : _csignals_T_1007; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1009 = _csignals_T_201 ? 3'h3 : _csignals_T_1008; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1010 = _csignals_T_199 ? 3'h3 : _csignals_T_1009; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1011 = _csignals_T_197 ? 3'h3 : _csignals_T_1010; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1012 = _csignals_T_195 ? 3'h1 : _csignals_T_1011; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1013 = _csignals_T_193 ? 3'h1 : _csignals_T_1012; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1014 = _csignals_T_191 ? 3'h1 : _csignals_T_1013; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1015 = _csignals_T_189 ? 3'h1 : _csignals_T_1014; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1016 = _csignals_T_187 ? 3'h4 : _csignals_T_1015; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1017 = _csignals_T_185 ? 3'h4 : _csignals_T_1016; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1018 = _csignals_T_183 ? 3'h1 : _csignals_T_1017; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1019 = _csignals_T_181 ? 3'h6 : _csignals_T_1018; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1020 = _csignals_T_179 ? 3'h6 : _csignals_T_1019; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1021 = _csignals_T_177 ? 3'h1 : _csignals_T_1020; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1022 = _csignals_T_175 ? 3'h1 : _csignals_T_1021; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1023 = _csignals_T_173 ? 3'h2 : _csignals_T_1022; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1024 = _csignals_T_171 ? 3'h2 : _csignals_T_1023; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1025 = _csignals_T_169 ? 3'h2 : _csignals_T_1024; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1026 = _csignals_T_167 ? 3'h2 : _csignals_T_1025; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1027 = _csignals_T_165 ? 3'h2 : _csignals_T_1026; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1028 = _csignals_T_163 ? 3'h2 : _csignals_T_1027; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1029 = _csignals_T_161 ? 3'h2 : _csignals_T_1028; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1030 = _csignals_T_159 ? 3'h1 : _csignals_T_1029; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1031 = _csignals_T_157 ? 3'h1 : _csignals_T_1030; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1032 = _csignals_T_155 ? 3'h1 : _csignals_T_1031; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1033 = _csignals_T_153 ? 3'h3 : _csignals_T_1032; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1034 = _csignals_T_151 ? 3'h1 : _csignals_T_1033; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1035 = _csignals_T_149 ? 3'h1 : _csignals_T_1034; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1036 = _csignals_T_147 ? 3'h3 : _csignals_T_1035; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1037 = _csignals_T_145 ? 3'h1 : _csignals_T_1036; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1038 = _csignals_T_143 ? 3'h0 : _csignals_T_1037; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1039 = _csignals_T_141 ? 3'h0 : _csignals_T_1038; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1040 = _csignals_T_139 ? 3'h0 : _csignals_T_1039; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1041 = _csignals_T_137 ? 3'h0 : _csignals_T_1040; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1042 = _csignals_T_135 ? 3'h0 : _csignals_T_1041; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1043 = _csignals_T_133 ? 3'h0 : _csignals_T_1042; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1044 = _csignals_T_131 ? 3'h0 : _csignals_T_1043; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1045 = _csignals_T_129 ? 3'h0 : _csignals_T_1044; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1046 = _csignals_T_127 ? 3'h0 : _csignals_T_1045; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1047 = _csignals_T_125 ? 3'h0 : _csignals_T_1046; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1048 = _csignals_T_123 ? 3'h0 : _csignals_T_1047; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1049 = _csignals_T_121 ? 3'h0 : _csignals_T_1048; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1050 = _csignals_T_119 ? 3'h0 : _csignals_T_1049; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1051 = _csignals_T_117 ? 3'h0 : _csignals_T_1050; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1052 = _csignals_T_115 ? 3'h0 : _csignals_T_1051; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1053 = _csignals_T_113 ? 3'h0 : _csignals_T_1052; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1054 = _csignals_T_111 ? 3'h0 : _csignals_T_1053; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1055 = _csignals_T_109 ? 3'h0 : _csignals_T_1054; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1056 = _csignals_T_107 ? 3'h0 : _csignals_T_1055; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1057 = _csignals_T_105 ? 3'h0 : _csignals_T_1056; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1058 = _csignals_T_103 ? 3'h0 : _csignals_T_1057; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1059 = _csignals_T_101 ? 3'h0 : _csignals_T_1058; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1060 = _csignals_T_99 ? 3'h0 : _csignals_T_1059; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1061 = _csignals_T_97 ? 3'h0 : _csignals_T_1060; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1062 = _csignals_T_95 ? 3'h0 : _csignals_T_1061; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1063 = _csignals_T_93 ? 3'h0 : _csignals_T_1062; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1064 = _csignals_T_91 ? 3'h0 : _csignals_T_1063; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1065 = _csignals_T_89 ? 3'h0 : _csignals_T_1064; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1066 = _csignals_T_87 ? 3'h0 : _csignals_T_1065; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1067 = _csignals_T_85 ? 3'h0 : _csignals_T_1066; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1068 = _csignals_T_83 ? 3'h0 : _csignals_T_1067; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1069 = _csignals_T_81 ? 3'h0 : _csignals_T_1068; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1070 = _csignals_T_79 ? 3'h0 : _csignals_T_1069; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1071 = _csignals_T_77 ? 3'h0 : _csignals_T_1070; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1072 = _csignals_T_75 ? 3'h0 : _csignals_T_1071; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1073 = _csignals_T_73 ? 3'h0 : _csignals_T_1072; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1074 = _csignals_T_71 ? 3'h0 : _csignals_T_1073; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1075 = _csignals_T_69 ? 3'h0 : _csignals_T_1074; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1076 = _csignals_T_67 ? 3'h0 : _csignals_T_1075; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1077 = _csignals_T_65 ? 3'h0 : _csignals_T_1076; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1078 = _csignals_T_63 ? 3'h0 : _csignals_T_1077; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1079 = _csignals_T_61 ? 3'h0 : _csignals_T_1078; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1080 = _csignals_T_59 ? 3'h0 : _csignals_T_1079; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1081 = _csignals_T_57 ? 3'h0 : _csignals_T_1080; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1082 = _csignals_T_55 ? 3'h0 : _csignals_T_1081; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1083 = _csignals_T_53 ? 3'h0 : _csignals_T_1082; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1084 = _csignals_T_51 ? 3'h0 : _csignals_T_1083; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1085 = _csignals_T_49 ? 3'h0 : _csignals_T_1084; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1086 = _csignals_T_47 ? 3'h0 : _csignals_T_1085; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1087 = _csignals_T_45 ? 3'h0 : _csignals_T_1086; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1088 = _csignals_T_43 ? 3'h0 : _csignals_T_1087; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1089 = _csignals_T_41 ? 3'h0 : _csignals_T_1088; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1090 = _csignals_T_39 ? 3'h0 : _csignals_T_1089; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1091 = _csignals_T_37 ? 3'h0 : _csignals_T_1090; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1092 = _csignals_T_35 ? 3'h0 : _csignals_T_1091; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1093 = _csignals_T_33 ? 3'h0 : _csignals_T_1092; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1094 = _csignals_T_31 ? 3'h0 : _csignals_T_1093; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1095 = _csignals_T_29 ? 3'h0 : _csignals_T_1094; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1096 = _csignals_T_27 ? 3'h0 : _csignals_T_1095; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1097 = _csignals_T_25 ? 3'h0 : _csignals_T_1096; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1098 = _csignals_T_23 ? 3'h0 : _csignals_T_1097; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1099 = _csignals_T_21 ? 3'h0 : _csignals_T_1098; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1100 = _csignals_T_19 ? 3'h0 : _csignals_T_1099; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1101 = _csignals_T_17 ? 3'h0 : _csignals_T_1100; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1102 = _csignals_T_15 ? 3'h0 : _csignals_T_1101; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1103 = _csignals_T_13 ? 3'h0 : _csignals_T_1102; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1104 = _csignals_T_11 ? 3'h0 : _csignals_T_1103; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1105 = _csignals_T_9 ? 3'h0 : _csignals_T_1104; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1106 = _csignals_T_7 ? 3'h0 : _csignals_T_1105; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1107 = _csignals_T_5 ? 3'h0 : _csignals_T_1106; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1108 = _csignals_T_3 ? 3'h0 : _csignals_T_1107; // @[Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_1108; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1190 = _csignals_T_85 ? 2'h3 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1191 = _csignals_T_83 ? 2'h3 : _csignals_T_1190; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1192 = _csignals_T_81 ? 2'h2 : _csignals_T_1191; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1193 = _csignals_T_79 ? 2'h2 : _csignals_T_1192; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1194 = _csignals_T_77 ? 2'h1 : _csignals_T_1193; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1195 = _csignals_T_75 ? 2'h1 : _csignals_T_1194; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1196 = _csignals_T_73 ? 2'h0 : _csignals_T_1195; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1197 = _csignals_T_71 ? 2'h0 : _csignals_T_1196; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1198 = _csignals_T_69 ? 2'h0 : _csignals_T_1197; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1199 = _csignals_T_67 ? 2'h0 : _csignals_T_1198; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1200 = _csignals_T_65 ? 2'h0 : _csignals_T_1199; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1201 = _csignals_T_63 ? 2'h0 : _csignals_T_1200; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1202 = _csignals_T_61 ? 2'h0 : _csignals_T_1201; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1203 = _csignals_T_59 ? 2'h0 : _csignals_T_1202; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1204 = _csignals_T_57 ? 2'h0 : _csignals_T_1203; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1205 = _csignals_T_55 ? 2'h0 : _csignals_T_1204; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1206 = _csignals_T_53 ? 2'h0 : _csignals_T_1205; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1207 = _csignals_T_51 ? 2'h0 : _csignals_T_1206; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1208 = _csignals_T_49 ? 2'h0 : _csignals_T_1207; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1209 = _csignals_T_47 ? 2'h0 : _csignals_T_1208; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1210 = _csignals_T_45 ? 2'h0 : _csignals_T_1209; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1211 = _csignals_T_43 ? 2'h0 : _csignals_T_1210; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1212 = _csignals_T_41 ? 2'h0 : _csignals_T_1211; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1213 = _csignals_T_39 ? 2'h0 : _csignals_T_1212; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1214 = _csignals_T_37 ? 2'h0 : _csignals_T_1213; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1215 = _csignals_T_35 ? 2'h0 : _csignals_T_1214; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1216 = _csignals_T_33 ? 2'h0 : _csignals_T_1215; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1217 = _csignals_T_31 ? 2'h0 : _csignals_T_1216; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1218 = _csignals_T_29 ? 2'h0 : _csignals_T_1217; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1219 = _csignals_T_27 ? 2'h0 : _csignals_T_1218; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1220 = _csignals_T_25 ? 2'h0 : _csignals_T_1219; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1221 = _csignals_T_23 ? 2'h0 : _csignals_T_1220; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1222 = _csignals_T_21 ? 2'h0 : _csignals_T_1221; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1223 = _csignals_T_19 ? 2'h0 : _csignals_T_1222; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1224 = _csignals_T_17 ? 2'h0 : _csignals_T_1223; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1225 = _csignals_T_15 ? 2'h0 : _csignals_T_1224; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1226 = _csignals_T_13 ? 2'h0 : _csignals_T_1225; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1227 = _csignals_T_11 ? 2'h0 : _csignals_T_1226; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1228 = _csignals_T_9 ? 2'h0 : _csignals_T_1227; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1229 = _csignals_T_7 ? 2'h0 : _csignals_T_1228; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1230 = _csignals_T_5 ? 2'h0 : _csignals_T_1229; // @[Lookup.scala 34:39]
  wire [1:0] _csignals_T_1231 = _csignals_T_3 ? 2'h0 : _csignals_T_1230; // @[Lookup.scala 34:39]
  wire [1:0] csignals_7 = _csignals_T_1 ? 2'h0 : _csignals_T_1231; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1250 = _csignals_T_211 ? 3'h4 : _csignals_T_634; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1251 = _csignals_T_209 ? 3'h5 : _csignals_T_1250; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1252 = _csignals_T_207 ? 3'h0 : _csignals_T_1251; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1253 = _csignals_T_205 ? 3'h4 : _csignals_T_1252; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1254 = _csignals_T_203 ? 3'h6 : _csignals_T_1253; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1255 = _csignals_T_201 ? 3'h4 : _csignals_T_1254; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1256 = _csignals_T_199 ? 3'h7 : _csignals_T_1255; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1257 = _csignals_T_197 ? 3'h5 : _csignals_T_1256; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1258 = _csignals_T_195 ? 3'h0 : _csignals_T_1257; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1259 = _csignals_T_193 ? 3'h0 : _csignals_T_1258; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1260 = _csignals_T_191 ? 3'h0 : _csignals_T_1259; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1261 = _csignals_T_189 ? 3'h0 : _csignals_T_1260; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1262 = _csignals_T_187 ? 3'h0 : _csignals_T_1261; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1263 = _csignals_T_185 ? 3'h0 : _csignals_T_1262; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1264 = _csignals_T_183 ? 3'h0 : _csignals_T_1263; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1265 = _csignals_T_181 ? 3'h0 : _csignals_T_1264; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1266 = _csignals_T_179 ? 3'h0 : _csignals_T_1265; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1267 = _csignals_T_177 ? 3'h0 : _csignals_T_1266; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1268 = _csignals_T_175 ? 3'h0 : _csignals_T_1267; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1269 = _csignals_T_173 ? 3'h0 : _csignals_T_1268; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1270 = _csignals_T_171 ? 3'h0 : _csignals_T_1269; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1271 = _csignals_T_169 ? 3'h0 : _csignals_T_1270; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1272 = _csignals_T_167 ? 3'h0 : _csignals_T_1271; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1273 = _csignals_T_165 ? 3'h0 : _csignals_T_1272; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1274 = _csignals_T_163 ? 3'h0 : _csignals_T_1273; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1275 = _csignals_T_161 ? 3'h0 : _csignals_T_1274; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1276 = _csignals_T_159 ? 3'h0 : _csignals_T_1275; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1277 = _csignals_T_157 ? 3'h0 : _csignals_T_1276; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1278 = _csignals_T_155 ? 3'h0 : _csignals_T_1277; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1279 = _csignals_T_153 ? 3'h0 : _csignals_T_1278; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1280 = _csignals_T_151 ? 3'h0 : _csignals_T_1279; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1281 = _csignals_T_149 ? 3'h0 : _csignals_T_1280; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1282 = _csignals_T_147 ? 3'h0 : _csignals_T_1281; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1283 = _csignals_T_145 ? 3'h0 : _csignals_T_1282; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1284 = _csignals_T_143 ? 3'h0 : _csignals_T_1283; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1285 = _csignals_T_141 ? 3'h0 : _csignals_T_1284; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1286 = _csignals_T_139 ? 3'h0 : _csignals_T_1285; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1287 = _csignals_T_137 ? 3'h0 : _csignals_T_1286; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1288 = _csignals_T_135 ? 3'h0 : _csignals_T_1287; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1289 = _csignals_T_133 ? 3'h0 : _csignals_T_1288; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1290 = _csignals_T_131 ? 3'h0 : _csignals_T_1289; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1291 = _csignals_T_129 ? 3'h0 : _csignals_T_1290; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1292 = _csignals_T_127 ? 3'h0 : _csignals_T_1291; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1293 = _csignals_T_125 ? 3'h0 : _csignals_T_1292; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1294 = _csignals_T_123 ? 3'h0 : _csignals_T_1293; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1295 = _csignals_T_121 ? 3'h0 : _csignals_T_1294; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1296 = _csignals_T_119 ? 3'h0 : _csignals_T_1295; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1297 = _csignals_T_117 ? 3'h0 : _csignals_T_1296; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1298 = _csignals_T_115 ? 3'h0 : _csignals_T_1297; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1299 = _csignals_T_113 ? 3'h0 : _csignals_T_1298; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1300 = _csignals_T_111 ? 3'h0 : _csignals_T_1299; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1301 = _csignals_T_109 ? 3'h0 : _csignals_T_1300; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1302 = _csignals_T_107 ? 3'h0 : _csignals_T_1301; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1303 = _csignals_T_105 ? 3'h0 : _csignals_T_1302; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1304 = _csignals_T_103 ? 3'h0 : _csignals_T_1303; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1305 = _csignals_T_101 ? 3'h0 : _csignals_T_1304; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1306 = _csignals_T_99 ? 3'h0 : _csignals_T_1305; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1307 = _csignals_T_97 ? 3'h0 : _csignals_T_1306; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1308 = _csignals_T_95 ? 3'h0 : _csignals_T_1307; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1309 = _csignals_T_93 ? 3'h0 : _csignals_T_1308; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1310 = _csignals_T_91 ? 3'h0 : _csignals_T_1309; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1311 = _csignals_T_89 ? 3'h0 : _csignals_T_1310; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1312 = _csignals_T_87 ? 3'h0 : _csignals_T_1311; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1313 = _csignals_T_85 ? 3'h0 : _csignals_T_1312; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1314 = _csignals_T_83 ? 3'h0 : _csignals_T_1313; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1315 = _csignals_T_81 ? 3'h0 : _csignals_T_1314; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1316 = _csignals_T_79 ? 3'h0 : _csignals_T_1315; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1317 = _csignals_T_77 ? 3'h0 : _csignals_T_1316; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1318 = _csignals_T_75 ? 3'h0 : _csignals_T_1317; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1319 = _csignals_T_73 ? 3'h0 : _csignals_T_1318; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1320 = _csignals_T_71 ? 3'h0 : _csignals_T_1319; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1321 = _csignals_T_69 ? 3'h0 : _csignals_T_1320; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1322 = _csignals_T_67 ? 3'h0 : _csignals_T_1321; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1323 = _csignals_T_65 ? 3'h0 : _csignals_T_1322; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1324 = _csignals_T_63 ? 3'h0 : _csignals_T_1323; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1325 = _csignals_T_61 ? 3'h0 : _csignals_T_1324; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1326 = _csignals_T_59 ? 3'h0 : _csignals_T_1325; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1327 = _csignals_T_57 ? 3'h0 : _csignals_T_1326; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1328 = _csignals_T_55 ? 3'h0 : _csignals_T_1327; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1329 = _csignals_T_53 ? 3'h0 : _csignals_T_1328; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1330 = _csignals_T_51 ? 3'h0 : _csignals_T_1329; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1331 = _csignals_T_49 ? 3'h0 : _csignals_T_1330; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1332 = _csignals_T_47 ? 3'h0 : _csignals_T_1331; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1333 = _csignals_T_45 ? 3'h0 : _csignals_T_1332; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1334 = _csignals_T_43 ? 3'h0 : _csignals_T_1333; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1335 = _csignals_T_41 ? 3'h0 : _csignals_T_1334; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1336 = _csignals_T_39 ? 3'h0 : _csignals_T_1335; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1337 = _csignals_T_37 ? 3'h0 : _csignals_T_1336; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1338 = _csignals_T_35 ? 3'h0 : _csignals_T_1337; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1339 = _csignals_T_33 ? 3'h0 : _csignals_T_1338; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1340 = _csignals_T_31 ? 3'h0 : _csignals_T_1339; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1341 = _csignals_T_29 ? 3'h0 : _csignals_T_1340; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1342 = _csignals_T_27 ? 3'h0 : _csignals_T_1341; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1343 = _csignals_T_25 ? 3'h0 : _csignals_T_1342; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1344 = _csignals_T_23 ? 3'h0 : _csignals_T_1343; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1345 = _csignals_T_21 ? 3'h0 : _csignals_T_1344; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1346 = _csignals_T_19 ? 3'h0 : _csignals_T_1345; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1347 = _csignals_T_17 ? 3'h0 : _csignals_T_1346; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1348 = _csignals_T_15 ? 3'h0 : _csignals_T_1347; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1349 = _csignals_T_13 ? 3'h0 : _csignals_T_1348; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1350 = _csignals_T_11 ? 3'h4 : _csignals_T_1349; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1351 = _csignals_T_9 ? 3'h6 : _csignals_T_1350; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1352 = _csignals_T_7 ? 3'h4 : _csignals_T_1351; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1353 = _csignals_T_5 ? 3'h5 : _csignals_T_1352; // @[Lookup.scala 34:39]
  wire [2:0] _csignals_T_1354 = _csignals_T_3 ? 3'h7 : _csignals_T_1353; // @[Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h5 : _csignals_T_1354; // @[Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[Core.scala 841:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[Core.scala 842:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[Core.scala 843:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[Core.scala 844:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[Mux.scala 101:16]
  wire  _id_op1_data_T = csignals_1 == 3'h1; // @[Core.scala 848:17]
  wire [31:0] _id_op1_data_T_1 = {id_reg_pc,1'h0}; // @[Cat.scala 33:92]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h2; // @[Core.scala 849:17]
  wire [31:0] _id_op1_data_T_3 = _id_op1_data_T_2 ? id_imm_z_uext : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? _id_op1_data_T_1 : _id_op1_data_T_3; // @[Mux.scala 101:16]
  wire  _id_op2_data_T = csignals_2 == 5'h4; // @[Core.scala 852:17]
  wire  _id_op2_data_T_1 = csignals_2 == 5'h8; // @[Core.scala 853:17]
  wire  _id_op2_data_T_2 = csignals_2 == 5'h9; // @[Core.scala 854:17]
  wire  _id_op2_data_T_3 = csignals_2 == 5'ha; // @[Core.scala 855:17]
  wire  _id_op2_data_T_4 = csignals_2 == 5'hb; // @[Core.scala 856:17]
  wire  _id_op2_data_T_5 = csignals_2 == 5'hc; // @[Core.scala 857:17]
  wire  _id_op2_data_T_6 = csignals_2 == 5'hd; // @[Core.scala 858:17]
  wire  _id_op2_data_T_7 = csignals_2 == 5'he; // @[Core.scala 859:17]
  wire  _id_op2_data_T_8 = csignals_2 == 5'hf; // @[Core.scala 860:17]
  wire  _id_op2_data_T_9 = csignals_2 == 5'h10; // @[Core.scala 861:17]
  wire  _id_op2_data_T_10 = csignals_2 == 5'h11; // @[Core.scala 862:17]
  wire  _id_op2_data_T_11 = csignals_2 == 5'h12; // @[Core.scala 863:17]
  wire  _id_op2_data_T_12 = csignals_2 == 5'h13; // @[Core.scala 864:17]
  wire  _id_op2_data_T_13 = csignals_2 == 5'h14; // @[Core.scala 865:17]
  wire  _id_op2_data_T_14 = csignals_2 == 5'h15; // @[Core.scala 866:17]
  wire  _id_op2_data_T_15 = csignals_2 == 5'h16; // @[Core.scala 867:17]
  wire  _id_op2_data_T_16 = csignals_2 == 5'h17; // @[Core.scala 868:17]
  wire  _id_op2_data_T_17 = csignals_2 == 5'h18; // @[Core.scala 869:17]
  wire  _id_op2_data_T_18 = csignals_2 == 5'h19; // @[Core.scala 870:17]
  wire  _id_op2_data_T_20 = csignals_2 == 5'h1a; // @[Core.scala 871:17]
  wire  _id_op2_data_T_21 = csignals_2 == 5'h1b; // @[Core.scala 872:17]
  wire  _id_op2_data_T_22 = csignals_2 == 5'h1c; // @[Core.scala 873:17]
  wire  _id_op2_data_T_23 = csignals_2 == 5'h1d; // @[Core.scala 874:17]
  wire [31:0] _id_op2_data_T_24 = _id_op2_data_T_23 ? id_c_imm_u : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_25 = _id_op2_data_T_22 ? id_c_imm_a2b : _id_op2_data_T_24; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_26 = _id_op2_data_T_21 ? id_c_imm_a2w : _id_op2_data_T_25; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_27 = _id_op2_data_T_20 ? 32'h1 : _id_op2_data_T_26; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_28 = _id_op2_data_T_18 ? 32'hffffffff : _id_op2_data_T_27; // @[Mux.scala 101:16]
  wire [31:0] _id_op2_data_T_29 = _id_op2_data_T_17 ? 32'hff : _id_op2_data_T_28; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_30 = _id_op2_data_T_16 ? id_c_imm_sh0 : {{1'd0}, _id_op2_data_T_29}; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_31 = _id_op2_data_T_15 ? {{1'd0}, id_c_imm_sb0} : _id_op2_data_T_30; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_32 = _id_op2_data_T_14 ? {{1'd0}, id_c_imm_sw0} : _id_op2_data_T_31; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_33 = _id_op2_data_T_13 ? {{1'd0}, id_c_imm_lsh} : _id_op2_data_T_32; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_34 = _id_op2_data_T_12 ? {{1'd0}, id_c_imm_lsb} : _id_op2_data_T_33; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_35 = _id_op2_data_T_11 ? {{1'd0}, id_c_imm_ss} : _id_op2_data_T_34; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_36 = _id_op2_data_T_10 ? {{1'd0}, id_c_imm_sl} : _id_op2_data_T_35; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_37 = _id_op2_data_T_9 ? {{1'd0}, id_c_imm_j} : _id_op2_data_T_36; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_38 = _id_op2_data_T_8 ? {{1'd0}, id_c_imm_iu} : _id_op2_data_T_37; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_39 = _id_op2_data_T_7 ? {{1'd0}, id_c_imm_ls} : _id_op2_data_T_38; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_40 = _id_op2_data_T_6 ? {{1'd0}, id_c_imm_i} : _id_op2_data_T_39; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_41 = _id_op2_data_T_5 ? {{1'd0}, id_c_imm_i16} : _id_op2_data_T_40; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_42 = _id_op2_data_T_4 ? {{1'd0}, id_c_imm_iw} : _id_op2_data_T_41; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_43 = _id_op2_data_T_3 ? {{1'd0}, id_imm_u_shifted} : _id_op2_data_T_42; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_44 = _id_op2_data_T_2 ? {{1'd0}, id_imm_j_sext} : _id_op2_data_T_43; // @[Mux.scala 101:16]
  wire [32:0] _id_op2_data_T_45 = _id_op2_data_T_1 ? {{1'd0}, id_imm_s_sext} : _id_op2_data_T_44; // @[Mux.scala 101:16]
  wire [32:0] id_op2_data = _id_op2_data_T ? {{1'd0}, id_imm_i_sext} : _id_op2_data_T_45; // @[Mux.scala 101:16]
  wire  _id_csr_addr_T = csignals_0 == 5'h18; // @[Core.scala 877:36]
  wire [11:0] id_csr_addr = csignals_0 == 5'h18 ? 12'h342 : id_imm_i; // @[Core.scala 877:24]
  wire  _id_m_op1_sel_T = csignals_1 == 3'h4; // @[Core.scala 880:17]
  wire  _id_m_op1_sel_T_1 = csignals_1 == 3'h5; // @[Core.scala 881:17]
  wire  _id_m_op1_sel_T_2 = csignals_1 == 3'h6; // @[Core.scala 882:17]
  wire  _id_m_op1_sel_T_3 = csignals_1 == 3'h7; // @[Core.scala 883:17]
  wire  _id_m_op1_sel_T_4 = _id_m_op1_sel_T_3 ? 1'h0 : 1'h1; // @[Mux.scala 101:16]
  wire  _id_m_op1_sel_T_5 = _id_m_op1_sel_T_2 ? 1'h0 : _id_m_op1_sel_T_4; // @[Mux.scala 101:16]
  wire  _id_m_op1_sel_T_6 = _id_m_op1_sel_T_1 ? 1'h0 : _id_m_op1_sel_T_5; // @[Mux.scala 101:16]
  wire  id_m_op1_sel = _id_m_op1_sel_T ? 1'h0 : _id_m_op1_sel_T_6; // @[Mux.scala 101:16]
  wire  _id_m_op2_sel_T = csignals_2 == 5'h1; // @[Core.scala 886:17]
  wire  _id_m_op2_sel_T_1 = csignals_2 == 5'h2; // @[Core.scala 887:17]
  wire  _id_m_op2_sel_T_2 = csignals_2 == 5'h7; // @[Core.scala 888:17]
  wire  _id_m_op2_sel_T_3 = csignals_2 == 5'h6; // @[Core.scala 889:17]
  wire  _id_m_op2_sel_T_4 = csignals_2 == 5'h3; // @[Core.scala 890:17]
  wire  _id_m_op2_sel_T_5 = csignals_2 == 5'h5; // @[Core.scala 891:17]
  wire  _id_m_op2_sel_T_6 = _id_m_op2_sel_T_5 ? 1'h0 : 1'h1; // @[Mux.scala 101:16]
  wire  _id_m_op2_sel_T_7 = _id_m_op2_sel_T_4 ? 1'h0 : _id_m_op2_sel_T_6; // @[Mux.scala 101:16]
  wire  _id_m_op2_sel_T_8 = _id_m_op2_sel_T_3 ? 1'h0 : _id_m_op2_sel_T_7; // @[Mux.scala 101:16]
  wire  _id_m_op2_sel_T_9 = _id_m_op2_sel_T_2 ? 1'h0 : _id_m_op2_sel_T_8; // @[Mux.scala 101:16]
  wire  _id_m_op2_sel_T_10 = _id_m_op2_sel_T_1 ? 1'h0 : _id_m_op2_sel_T_9; // @[Mux.scala 101:16]
  wire  id_m_op2_sel = _id_m_op2_sel_T ? 1'h0 : _id_m_op2_sel_T_10; // @[Mux.scala 101:16]
  wire  _id_m_op3_sel_T = csignals_3 == 3'h0; // @[Core.scala 894:17]
  wire  _id_m_op3_sel_T_1 = csignals_3 == 3'h1; // @[Core.scala 895:17]
  wire  _id_m_op3_sel_T_2 = csignals_3 == 3'h3; // @[Core.scala 896:17]
  wire  _id_m_op3_sel_T_3 = csignals_3 == 3'h4; // @[Core.scala 897:17]
  wire  _id_m_op3_sel_T_4 = csignals_3 == 3'h6; // @[Core.scala 898:17]
  wire  _id_m_op3_sel_T_5 = csignals_3 == 3'h5; // @[Core.scala 899:17]
  wire  _id_m_op3_sel_T_6 = csignals_3 == 3'h7; // @[Core.scala 900:17]
  wire [1:0] _id_m_op3_sel_T_7 = _id_m_op3_sel_T_6 ? 2'h2 : 2'h0; // @[Mux.scala 101:16]
  wire [1:0] _id_m_op3_sel_T_8 = _id_m_op3_sel_T_5 ? 2'h2 : _id_m_op3_sel_T_7; // @[Mux.scala 101:16]
  wire [1:0] _id_m_op3_sel_T_9 = _id_m_op3_sel_T_4 ? 2'h2 : _id_m_op3_sel_T_8; // @[Mux.scala 101:16]
  wire [1:0] _id_m_op3_sel_T_10 = _id_m_op3_sel_T_3 ? 2'h2 : _id_m_op3_sel_T_9; // @[Mux.scala 101:16]
  wire [1:0] _id_m_op3_sel_T_11 = _id_m_op3_sel_T_2 ? 2'h3 : _id_m_op3_sel_T_10; // @[Mux.scala 101:16]
  wire [1:0] _id_m_op3_sel_T_12 = _id_m_op3_sel_T_1 ? 2'h1 : _id_m_op3_sel_T_11; // @[Mux.scala 101:16]
  wire [1:0] id_m_op3_sel = _id_m_op3_sel_T ? 2'h0 : _id_m_op3_sel_T_12; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs1_addr_T_3 = _id_m_op1_sel_T_3 ? id_c_rs1p_addr : id_rs1_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs1_addr_T_4 = _id_m_op1_sel_T_2 ? 5'h2 : _id_m_rs1_addr_T_3; // @[Mux.scala 101:16]
  wire [4:0] id_m_rs1_addr = _id_m_op1_sel_T_1 ? id_w_wb_addr : _id_m_rs1_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_4 = _id_m_op2_sel_T_4 ? id_c_rs3p_addr : id_rs2_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_5 = _id_m_op2_sel_T_3 ? id_c_rs2p_addr : _id_m_rs2_addr_T_4; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs2_addr_T_6 = _id_m_op2_sel_T_2 ? id_c_rs1p_addr : _id_m_rs2_addr_T_5; // @[Mux.scala 101:16]
  wire [4:0] id_m_rs2_addr = _id_m_op2_sel_T_1 ? id_c_rs2_addr : _id_m_rs2_addr_T_6; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs3_addr_T_3 = _id_m_op3_sel_T_6 ? id_rs3_addr : id_rs2_addr; // @[Mux.scala 101:16]
  wire [4:0] _id_m_rs3_addr_T_4 = _id_m_op3_sel_T_5 ? id_c_rs2p_addr : _id_m_rs3_addr_T_3; // @[Mux.scala 101:16]
  wire [4:0] id_m_rs3_addr = _id_m_op3_sel_T_4 ? id_c_rs2_addr : _id_m_rs3_addr_T_4; // @[Mux.scala 101:16]
  wire  _id_m_imm_b_sext_T = csignals_6 == 3'h6; // @[Core.scala 919:13]
  wire  _id_m_imm_b_sext_T_1 = csignals_6 == 3'h7; // @[Core.scala 920:13]
  wire [31:0] _id_m_imm_b_sext_T_2 = _id_m_imm_b_sext_T_1 ? id_c_imm_b2 : id_imm_b_sext; // @[Mux.scala 101:16]
  wire [31:0] id_m_imm_b_sext = _id_m_imm_b_sext_T ? id_c_imm_b : _id_m_imm_b_sext_T_2; // @[Mux.scala 101:16]
  wire  _id_is_br_T_1 = csignals_0 == 5'h13; // @[Core.scala 926:17]
  wire  _id_is_br_T_2 = csignals_0 == 5'h12 | _id_is_br_T_1; // @[Core.scala 925:29]
  wire  _id_is_br_T_3 = csignals_0 == 5'h14; // @[Core.scala 927:17]
  wire  _id_is_br_T_4 = _id_is_br_T_2 | _id_is_br_T_3; // @[Core.scala 926:29]
  wire  _id_is_br_T_5 = csignals_0 == 5'h15; // @[Core.scala 928:17]
  wire  _id_is_br_T_6 = _id_is_br_T_4 | _id_is_br_T_5; // @[Core.scala 927:29]
  wire  _id_is_br_T_7 = csignals_0 == 5'h16; // @[Core.scala 929:17]
  wire  _id_is_br_T_8 = _id_is_br_T_6 | _id_is_br_T_7; // @[Core.scala 928:29]
  wire  _id_is_br_T_9 = csignals_0 == 5'h17; // @[Core.scala 930:17]
  wire  id_is_br = _id_is_br_T_8 | _id_is_br_T_9; // @[Core.scala 929:30]
  wire  id_is_j = csignals_5 == 3'h1; // @[Core.scala 932:28]
  wire [30:0] _id_reg_br_pc_T_1 = id_reg_pc + 31'h1; // @[Core.scala 937:45]
  wire [30:0] _id_reg_br_pc_T_3 = id_reg_pc + 31'h2; // @[Core.scala 937:72]
  reg [30:0] id_reg_pc_delay; // @[Core.scala 945:40]
  reg [4:0] id_reg_wb_addr_delay; // @[Core.scala 946:40]
  reg  id_reg_op1_sel_delay; // @[Core.scala 947:40]
  reg  id_reg_op2_sel_delay; // @[Core.scala 948:40]
  reg [1:0] id_reg_op3_sel_delay; // @[Core.scala 949:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[Core.scala 950:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[Core.scala 951:40]
  reg [4:0] id_reg_rs3_addr_delay; // @[Core.scala 952:40]
  reg [31:0] id_reg_op1_data_delay; // @[Core.scala 953:40]
  reg [31:0] id_reg_op2_data_delay; // @[Core.scala 954:40]
  reg [4:0] id_reg_exe_fun_delay; // @[Core.scala 955:40]
  reg  id_reg_rf_wen_delay; // @[Core.scala 956:40]
  reg [2:0] id_reg_wb_sel_delay; // @[Core.scala 957:40]
  reg [11:0] id_reg_csr_addr_delay; // @[Core.scala 958:40]
  reg [1:0] id_reg_csr_cmd_delay; // @[Core.scala 959:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[Core.scala 960:40]
  reg [2:0] id_reg_mem_w_delay; // @[Core.scala 961:40]
  reg  id_reg_is_br_delay; // @[Core.scala 963:40]
  reg  id_reg_is_j_delay; // @[Core.scala 964:40]
  reg  id_reg_bp_taken_delay; // @[Core.scala 965:40]
  reg [30:0] id_reg_bp_taken_pc_delay; // @[Core.scala 966:41]
  reg [1:0] id_reg_bp_cnt_delay; // @[Core.scala 967:40]
  reg  id_reg_is_half_delay; // @[Core.scala 968:40]
  reg  id_reg_is_valid_inst_delay; // @[Core.scala 969:43]
  reg  id_reg_is_trap_delay; // @[Core.scala 970:40]
  reg [31:0] id_reg_mcause_delay; // @[Core.scala 971:40]
  wire [30:0] _GEN_211 = _ic_read_en4_T ? id_reg_pc : id_reg_pc_delay; // @[Core.scala 975:26 976:32 945:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[Core.scala 1012:43]
  wire [32:0] _GEN_220 = _ic_read_en4_T ? id_op2_data : {{1'd0}, id_reg_op2_data_delay}; // @[Core.scala 987:30 996:29 954:40]
  wire [32:0] _GEN_256 = ex2_reg_is_br ? {{1'd0}, id_reg_op2_data_delay} : _GEN_220; // @[Core.scala 974:24 954:40]
  wire [30:0] _GEN_266 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[Core.scala 1024:24 1025:29 1057:29]
  wire  _GEN_267 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[Core.scala 1024:24 1026:29 1058:29]
  wire  _GEN_268 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[Core.scala 1024:24 1027:29 1059:29]
  wire [1:0] _GEN_269 = id_reg_stall ? id_reg_op3_sel_delay : id_m_op3_sel; // @[Core.scala 1024:24 1028:29 1060:29]
  wire [4:0] _GEN_270 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[Core.scala 1024:24 1029:29 1061:29]
  wire [4:0] _GEN_271 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[Core.scala 1024:24 1030:29 1062:29]
  wire [4:0] _GEN_272 = id_reg_stall ? id_reg_rs3_addr_delay : id_m_rs3_addr; // @[Core.scala 1024:24 1031:29 1063:29]
  wire [31:0] _GEN_273 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[Core.scala 1024:24 1032:29 1064:29]
  wire [32:0] _GEN_274 = id_reg_stall ? {{1'd0}, id_reg_op2_data_delay} : id_op2_data; // @[Core.scala 1024:24 1033:29 1065:29]
  wire [4:0] _GEN_275 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[Core.scala 1024:24 1034:29 1066:29]
  wire [31:0] _GEN_279 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[Core.scala 1024:24 1038:29 1070:29]
  wire [11:0] _GEN_280 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[Core.scala 1024:24 1039:29 1071:29]
  wire [30:0] _GEN_282 = id_reg_stall ? id_reg_bp_taken_pc_delay : id_reg_bp_taken_pc; // @[Core.scala 1024:24 1046:29 1078:29]
  wire [1:0] _GEN_283 = id_reg_stall ? id_reg_bp_cnt_delay : id_reg_bp_cnt; // @[Core.scala 1024:24 1047:29 1079:29]
  wire  _GEN_284 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[Core.scala 1024:24 1048:29 1080:29]
  wire [31:0] _GEN_285 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[Core.scala 1024:24 1051:29 1083:29]
  wire  _T_39 = ~rrd_stall; // @[Core.scala 1089:14]
  wire  _T_40 = ~ex2_stall; // @[Core.scala 1089:28]
  wire [32:0] _GEN_305 = ~rrd_stall & ~ex2_stall ? _GEN_274 : {{1'd0}, rrd_reg_op2_data}; // @[Core.scala 1089:40 173:38]
  wire [32:0] _GEN_332 = ex2_reg_is_br ? _GEN_274 : _GEN_305; // @[Core.scala 1023:24]
  wire  _rrd_op1_data_T_2 = _rrd_stall_T & rrd_reg_rs1_addr == 5'h0; // @[Core.scala 1166:35]
  wire  _rrd_op1_data_T_4 = ex1_reg_fw_en & _rrd_stall_T; // @[Core.scala 1167:20]
  wire  _rrd_op1_data_T_5 = rrd_reg_rs1_addr == ex1_reg_wb_addr; // @[Core.scala 1169:24]
  wire  _rrd_op1_data_T_6 = _rrd_op1_data_T_4 & _rrd_op1_data_T_5; // @[Core.scala 1168:37]
  wire  _rrd_op1_data_T_8 = ex2_reg_fw_en & _rrd_stall_T; // @[Core.scala 1170:20]
  wire  _rrd_op1_data_T_9 = rrd_reg_rs1_addr == ex2_reg_wb_addr; // @[Core.scala 1172:24]
  wire  _rrd_op1_data_T_10 = _rrd_op1_data_T_8 & _rrd_op1_data_T_9; // @[Core.scala 1171:37]
  wire [31:0] _rrd_op1_data_T_12 = _rrd_stall_T ? regfile_rrd_op1_data_MPORT_data : rrd_reg_op1_data; // @[Mux.scala 101:16]
  wire  _ex2_fw_data_T_1 = ex2_reg_wb_sel == 3'h7; // @[Core.scala 1872:23]
  wire  _ex2_fw_data_T_2 = ex2_reg_wb_sel == 3'h1 | _ex2_fw_data_T_1; // @[Core.scala 1871:34]
  wire [31:0] ex2_fw_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : ex2_reg_alu_out; // @[Core.scala 1869:21]
  wire [31:0] _rrd_op1_data_T_13 = _rrd_op1_data_T_10 ? ex2_fw_data : _rrd_op1_data_T_12; // @[Mux.scala 101:16]
  wire  _ex1_fw_data_T = ex1_reg_wb_sel == 3'h1; // @[Core.scala 1344:21]
  wire [30:0] _ex1_next_pc_T_1 = ex1_reg_pc + 31'h1; // @[Core.scala 1281:53]
  wire [30:0] _ex1_next_pc_T_3 = ex1_reg_pc + 31'h2; // @[Core.scala 1281:81]
  wire [30:0] ex1_next_pc = ex1_reg_is_half ? _ex1_next_pc_T_1 : _ex1_next_pc_T_3; // @[Core.scala 1281:24]
  wire [31:0] _ex1_fw_data_T_1 = {ex1_next_pc,1'h0}; // @[Cat.scala 33:92]
  wire  _ex1_alu_out_T = ex1_reg_exe_fun == 5'h0; // @[Core.scala 1260:22]
  wire [31:0] ex1_add_out = ex1_reg_op1_data + ex1_reg_op2_data; // @[Core.scala 1258:38]
  wire  _ex1_alu_out_T_1 = ex1_reg_exe_fun == 5'h8; // @[Core.scala 1261:22]
  wire [31:0] _ex1_alu_out_T_3 = ex1_reg_op1_data - ex1_reg_op2_data; // @[Core.scala 1261:58]
  wire  _ex1_alu_out_T_4 = ex1_reg_exe_fun == 5'h2; // @[Core.scala 1262:22]
  wire [31:0] _ex1_alu_out_T_5 = ex1_reg_op1_data & ex1_reg_op2_data; // @[Core.scala 1262:58]
  wire  _ex1_alu_out_T_6 = ex1_reg_exe_fun == 5'h3; // @[Core.scala 1263:22]
  wire [31:0] _ex1_alu_out_T_7 = ex1_reg_op1_data | ex1_reg_op2_data; // @[Core.scala 1263:58]
  wire  _ex1_alu_out_T_8 = ex1_reg_exe_fun == 5'h1; // @[Core.scala 1264:22]
  wire [31:0] _ex1_alu_out_T_9 = ex1_reg_op1_data ^ ex1_reg_op2_data; // @[Core.scala 1264:58]
  wire  _ex1_alu_out_T_10 = ex1_reg_exe_fun == 5'h4; // @[Core.scala 1265:22]
  wire [62:0] _ex1_alu_out_T_12 = {ex1_reg_op1_data,ex1_reg_op3_data[31:1]}; // @[Cat.scala 33:92]
  wire [31:0] _ex1_alu_out_T_13 = ~ex1_reg_op2_data; // @[Core.scala 1265:100]
  wire [62:0] _ex1_alu_out_T_15 = _ex1_alu_out_T_12 >> _ex1_alu_out_T_13[4:0]; // @[Core.scala 1265:96]
  wire  _ex1_alu_out_T_17 = ex1_reg_exe_fun == 5'h5; // @[Core.scala 1266:22]
  wire [62:0] _ex1_alu_out_T_19 = {ex1_reg_op3_data[30:0],ex1_reg_op1_data}; // @[Cat.scala 33:92]
  wire [62:0] _ex1_alu_out_T_21 = _ex1_alu_out_T_19 >> ex1_reg_op2_data[4:0]; // @[Core.scala 1266:96]
  wire  _ex1_alu_out_T_23 = ex1_reg_exe_fun == 5'h6; // @[Core.scala 1267:22]
  wire  _ex1_alu_out_T_26 = $signed(ex1_reg_op1_data) < $signed(ex1_reg_op2_data); // @[Core.scala 1267:65]
  wire  _ex1_alu_out_T_27 = ex1_reg_exe_fun == 5'h7; // @[Core.scala 1268:22]
  wire  _ex1_alu_out_T_28 = ex1_reg_op1_data < ex1_reg_op2_data; // @[Core.scala 1268:58]
  wire  _ex1_alu_out_T_29 = ex1_reg_exe_fun == 5'ha; // @[Core.scala 1269:22]
  wire [31:0] _ex1_alu_out_T_31 = ex1_reg_op1_data & _ex1_alu_out_T_13; // @[Core.scala 1269:58]
  wire  _ex1_alu_out_T_32 = ex1_reg_exe_fun == 5'h9; // @[Core.scala 1270:22]
  wire [31:0] _ex1_alu_out_T_34 = ex1_reg_op1_data ^ _ex1_alu_out_T_13; // @[Core.scala 1270:58]
  wire  _ex1_alu_out_T_35 = ex1_reg_exe_fun == 5'hb; // @[Core.scala 1271:22]
  wire [31:0] _ex1_alu_out_T_37 = ex1_reg_op1_data | _ex1_alu_out_T_13; // @[Core.scala 1271:58]
  wire  _ex1_alu_out_T_38 = ex1_reg_exe_fun == 5'hf; // @[Core.scala 1272:22]
  wire [31:0] _ex1_alu_out_T_40 = 32'h0 < ex1_reg_op2_data ? ex1_reg_op1_data : ex1_reg_op3_data; // @[Core.scala 1272:43]
  wire [31:0] _ex1_alu_out_T_41 = _ex1_alu_out_T_38 ? _ex1_alu_out_T_40 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_42 = _ex1_alu_out_T_35 ? _ex1_alu_out_T_37 : _ex1_alu_out_T_41; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_43 = _ex1_alu_out_T_32 ? _ex1_alu_out_T_34 : _ex1_alu_out_T_42; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_44 = _ex1_alu_out_T_29 ? _ex1_alu_out_T_31 : _ex1_alu_out_T_43; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_45 = _ex1_alu_out_T_27 ? {{31'd0}, _ex1_alu_out_T_28} : _ex1_alu_out_T_44; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_46 = _ex1_alu_out_T_23 ? {{31'd0}, _ex1_alu_out_T_26} : _ex1_alu_out_T_45; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_47 = _ex1_alu_out_T_17 ? _ex1_alu_out_T_21[31:0] : _ex1_alu_out_T_46; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_48 = _ex1_alu_out_T_10 ? _ex1_alu_out_T_15[31:0] : _ex1_alu_out_T_47; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_49 = _ex1_alu_out_T_8 ? _ex1_alu_out_T_9 : _ex1_alu_out_T_48; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_50 = _ex1_alu_out_T_6 ? _ex1_alu_out_T_7 : _ex1_alu_out_T_49; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_51 = _ex1_alu_out_T_4 ? _ex1_alu_out_T_5 : _ex1_alu_out_T_50; // @[Mux.scala 101:16]
  wire [31:0] _ex1_alu_out_T_52 = _ex1_alu_out_T_1 ? _ex1_alu_out_T_3 : _ex1_alu_out_T_51; // @[Mux.scala 101:16]
  wire [31:0] ex1_alu_out = _ex1_alu_out_T ? ex1_add_out : _ex1_alu_out_T_52; // @[Mux.scala 101:16]
  wire [31:0] ex1_fw_data = _ex1_fw_data_T ? _ex1_fw_data_T_1 : ex1_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op1_data_T_14 = _rrd_op1_data_T_6 ? ex1_fw_data : _rrd_op1_data_T_13; // @[Mux.scala 101:16]
  wire [31:0] rrd_op1_data = _rrd_op1_data_T_2 ? 32'h0 : _rrd_op1_data_T_14; // @[Mux.scala 101:16]
  wire  _rrd_op2_data_T_2 = _rrd_stall_T_2 & rrd_reg_rs2_addr == 5'h0; // @[Core.scala 1176:35]
  wire  _rrd_op2_data_T_4 = ex1_reg_fw_en & _rrd_stall_T_2; // @[Core.scala 1177:20]
  wire  _rrd_op2_data_T_5 = rrd_reg_rs2_addr == ex1_reg_wb_addr; // @[Core.scala 1179:24]
  wire  _rrd_op2_data_T_6 = _rrd_op2_data_T_4 & _rrd_op2_data_T_5; // @[Core.scala 1178:37]
  wire  _rrd_op2_data_T_8 = ex2_reg_fw_en & _rrd_stall_T_2; // @[Core.scala 1180:20]
  wire  _rrd_op2_data_T_9 = rrd_reg_rs2_addr == ex2_reg_wb_addr; // @[Core.scala 1182:24]
  wire  _rrd_op2_data_T_10 = _rrd_op2_data_T_8 & _rrd_op2_data_T_9; // @[Core.scala 1181:37]
  wire [31:0] _rrd_op2_data_T_12 = _rrd_stall_T_2 ? regfile_rrd_op2_data_MPORT_data : rrd_reg_op2_data; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op2_data_T_13 = _rrd_op2_data_T_10 ? ex2_fw_data : _rrd_op2_data_T_12; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op2_data_T_14 = _rrd_op2_data_T_6 ? ex1_fw_data : _rrd_op2_data_T_13; // @[Mux.scala 101:16]
  wire [31:0] rrd_op2_data = _rrd_op2_data_T_2 ? 32'h0 : _rrd_op2_data_T_14; // @[Mux.scala 101:16]
  wire  _rrd_op3_data_T = rrd_reg_op3_sel == 2'h0; // @[Core.scala 1186:22]
  wire  _rrd_op3_data_T_1 = rrd_reg_op3_sel == 2'h1; // @[Core.scala 1187:22]
  wire [31:0] _rrd_op3_data_T_4 = rrd_op1_data[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 77:12]
  wire  _rrd_op3_data_T_5 = rrd_reg_op3_sel == 2'h3; // @[Core.scala 1188:22]
  wire  _rrd_op3_data_T_6 = rrd_reg_rs3_addr == 5'h0; // @[Core.scala 1189:23]
  wire  _rrd_op3_data_T_7 = rrd_reg_rs3_addr == ex1_reg_wb_addr; // @[Core.scala 1191:24]
  wire  _rrd_op3_data_T_8 = ex1_reg_fw_en & _rrd_op3_data_T_7; // @[Core.scala 1190:20]
  wire  _rrd_op3_data_T_9 = rrd_reg_rs3_addr == ex2_reg_wb_addr; // @[Core.scala 1193:24]
  wire  _rrd_op3_data_T_10 = ex2_reg_fw_en & _rrd_op3_data_T_9; // @[Core.scala 1192:20]
  wire [31:0] _rrd_op3_data_T_11 = _rrd_op3_data_T_10 ? ex2_fw_data : regfile_rrd_op3_data_MPORT_data; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op3_data_T_12 = _rrd_op3_data_T_8 ? ex1_fw_data : _rrd_op3_data_T_11; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op3_data_T_13 = _rrd_op3_data_T_6 ? 32'h0 : _rrd_op3_data_T_12; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op3_data_T_14 = _rrd_op3_data_T_5 ? rrd_op1_data : _rrd_op3_data_T_13; // @[Mux.scala 101:16]
  wire [31:0] _rrd_op3_data_T_15 = _rrd_op3_data_T_1 ? _rrd_op3_data_T_4 : _rrd_op3_data_T_14; // @[Mux.scala 101:16]
  wire [31:0] rrd_op3_data = _rrd_op3_data_T ? 32'h0 : _rrd_op3_data_T_15; // @[Mux.scala 101:16]
  wire [30:0] rrd_direct_jbr_pc = rrd_reg_pc + rrd_reg_imm_b_sext[31:1]; // @[Core.scala 1196:38]
  wire  _rrd_hazard_T_1 = rrd_reg_wb_addr != 5'h0; // @[Core.scala 1198:67]
  wire  rrd_hazard = rrd_reg_rf_wen & rrd_reg_wb_addr != 5'h0 & _T_39 & _csr_is_valid_inst_T; // @[Core.scala 1198:90]
  wire  rrd_fw_en_next = rrd_hazard & (rrd_reg_wb_sel == 3'h0 | rrd_reg_wb_sel == 3'h1); // @[Core.scala 1199:35]
  wire  _T_48 = _T_40 & _T_39 & _csr_is_valid_inst_T & rrd_reg_rf_wen; // @[Core.scala 1206:48]
  wire  _T_50 = _T_48 & _rrd_hazard_T_1; // @[Core.scala 1207:30]
  wire  _T_51 = rrd_reg_wb_sel != 3'h0; // @[Core.scala 1209:54]
  wire  _T_52 = rrd_reg_wb_sel != 3'h1; // @[Core.scala 1209:83]
  wire  rrd_mem_use_reg = _T_50 & (rrd_reg_wb_sel == 3'h6 | rrd_reg_wb_sel == 3'h2); // @[Core.scala 1208:5 1210:25 1201:38]
  wire  rrd_inst2_use_reg = _T_50 & (rrd_reg_wb_sel == 3'h7 | rrd_reg_wb_sel == 3'h3); // @[Core.scala 1208:5 1211:25 1202:38]
  wire  rrd_inst3_use_reg = _T_50 & (rrd_reg_wb_sel == 3'h4 | rrd_reg_wb_sel == 3'h5); // @[Core.scala 1208:5 1212:25 1203:38]
  wire  ex_is_bubble = rrd_stall | ex2_reg_is_br; // @[Core.scala 1223:34]
  wire [47:0] ex1_mullu = ex1_reg_op1_data * ex1_reg_op2_data[15:0]; // @[Core.scala 1275:38]
  wire [16:0] _ex1_mulls_T_2 = {1'b0,$signed(ex1_reg_op2_data[15:0])}; // @[Core.scala 1276:45]
  wire [48:0] _ex1_mulls_T_3 = $signed(ex1_reg_op1_data) * $signed(_ex1_mulls_T_2); // @[Core.scala 1276:45]
  wire [47:0] _ex1_mulls_T_5 = _ex1_mulls_T_3[47:0]; // @[Core.scala 1276:45]
  wire [31:0] ex1_mulls = _ex1_mulls_T_5[47:16]; // @[Core.scala 1276:81]
  wire [47:0] ex1_mulhuu = ex1_reg_op1_data * ex1_reg_op2_data[31:16]; // @[Core.scala 1277:38]
  wire [15:0] _ex1_mulhss_T_2 = ex1_reg_op2_data[31:16]; // @[Core.scala 1278:88]
  wire [47:0] ex1_mulhss = $signed(ex1_reg_op1_data) * $signed(_ex1_mulhss_T_2); // @[Core.scala 1278:45]
  wire [16:0] _ex1_mulhsu_T_2 = {1'b0,$signed(ex1_reg_op2_data[31:16])}; // @[Core.scala 1279:45]
  wire [48:0] _ex1_mulhsu_T_3 = $signed(ex1_reg_op1_data) * $signed(_ex1_mulhsu_T_2); // @[Core.scala 1279:45]
  wire [47:0] ex1_mulhsu = _ex1_mulhsu_T_3[47:0]; // @[Core.scala 1279:45]
  wire [31:0] _ex1_pc_bit_out_T_4 = {16'h0,ex1_reg_op1_data[15:0]}; // @[Cat.scala 33:92]
  wire [1:0] _ex1_pc_bit_out_T_38 = ex1_reg_op1_data[0] + ex1_reg_op1_data[1]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_40 = ex1_reg_op1_data[2] + ex1_reg_op1_data[3]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_42 = _ex1_pc_bit_out_T_38 + _ex1_pc_bit_out_T_40; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_44 = ex1_reg_op1_data[4] + ex1_reg_op1_data[5]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_46 = ex1_reg_op1_data[6] + ex1_reg_op1_data[7]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_48 = _ex1_pc_bit_out_T_44 + _ex1_pc_bit_out_T_46; // @[Bitwise.scala 51:90]
  wire [3:0] _ex1_pc_bit_out_T_50 = _ex1_pc_bit_out_T_42 + _ex1_pc_bit_out_T_48; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_52 = ex1_reg_op1_data[8] + ex1_reg_op1_data[9]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_54 = ex1_reg_op1_data[10] + ex1_reg_op1_data[11]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_56 = _ex1_pc_bit_out_T_52 + _ex1_pc_bit_out_T_54; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_58 = ex1_reg_op1_data[12] + ex1_reg_op1_data[13]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_60 = ex1_reg_op1_data[14] + ex1_reg_op1_data[15]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_62 = _ex1_pc_bit_out_T_58 + _ex1_pc_bit_out_T_60; // @[Bitwise.scala 51:90]
  wire [3:0] _ex1_pc_bit_out_T_64 = _ex1_pc_bit_out_T_56 + _ex1_pc_bit_out_T_62; // @[Bitwise.scala 51:90]
  wire [4:0] _ex1_pc_bit_out_T_66 = _ex1_pc_bit_out_T_50 + _ex1_pc_bit_out_T_64; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_68 = ex1_reg_op1_data[16] + ex1_reg_op1_data[17]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_70 = ex1_reg_op1_data[18] + ex1_reg_op1_data[19]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_72 = _ex1_pc_bit_out_T_68 + _ex1_pc_bit_out_T_70; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_74 = ex1_reg_op1_data[20] + ex1_reg_op1_data[21]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_76 = ex1_reg_op1_data[22] + ex1_reg_op1_data[23]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_78 = _ex1_pc_bit_out_T_74 + _ex1_pc_bit_out_T_76; // @[Bitwise.scala 51:90]
  wire [3:0] _ex1_pc_bit_out_T_80 = _ex1_pc_bit_out_T_72 + _ex1_pc_bit_out_T_78; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_82 = ex1_reg_op1_data[24] + ex1_reg_op1_data[25]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_84 = ex1_reg_op1_data[26] + ex1_reg_op1_data[27]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_86 = _ex1_pc_bit_out_T_82 + _ex1_pc_bit_out_T_84; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_88 = ex1_reg_op1_data[28] + ex1_reg_op1_data[29]; // @[Bitwise.scala 51:90]
  wire [1:0] _ex1_pc_bit_out_T_90 = ex1_reg_op1_data[30] + ex1_reg_op1_data[31]; // @[Bitwise.scala 51:90]
  wire [2:0] _ex1_pc_bit_out_T_92 = _ex1_pc_bit_out_T_88 + _ex1_pc_bit_out_T_90; // @[Bitwise.scala 51:90]
  wire [3:0] _ex1_pc_bit_out_T_94 = _ex1_pc_bit_out_T_86 + _ex1_pc_bit_out_T_92; // @[Bitwise.scala 51:90]
  wire [4:0] _ex1_pc_bit_out_T_96 = _ex1_pc_bit_out_T_80 + _ex1_pc_bit_out_T_94; // @[Bitwise.scala 51:90]
  wire [5:0] _ex1_pc_bit_out_T_98 = _ex1_pc_bit_out_T_66 + _ex1_pc_bit_out_T_96; // @[Bitwise.scala 51:90]
  wire [31:0] _GEN_617 = {{16'd0}, ex1_reg_op1_data[31:16]}; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_104 = _GEN_617 & 32'hffff; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_106 = {ex1_reg_op1_data[15:0], 16'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _ex1_pc_bit_out_T_108 = _ex1_pc_bit_out_T_106 & 32'hffff0000; // @[Bitwise.scala 108:80]
  wire [31:0] _ex1_pc_bit_out_T_109 = _ex1_pc_bit_out_T_104 | _ex1_pc_bit_out_T_108; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_618 = {{8'd0}, _ex1_pc_bit_out_T_109[31:8]}; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_114 = _GEN_618 & 32'hff00ff; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_116 = {_ex1_pc_bit_out_T_109[23:0], 8'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _ex1_pc_bit_out_T_118 = _ex1_pc_bit_out_T_116 & 32'hff00ff00; // @[Bitwise.scala 108:80]
  wire [31:0] _ex1_pc_bit_out_T_119 = _ex1_pc_bit_out_T_114 | _ex1_pc_bit_out_T_118; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_619 = {{4'd0}, _ex1_pc_bit_out_T_119[31:4]}; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_124 = _GEN_619 & 32'hf0f0f0f; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_126 = {_ex1_pc_bit_out_T_119[27:0], 4'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _ex1_pc_bit_out_T_128 = _ex1_pc_bit_out_T_126 & 32'hf0f0f0f0; // @[Bitwise.scala 108:80]
  wire [31:0] _ex1_pc_bit_out_T_129 = _ex1_pc_bit_out_T_124 | _ex1_pc_bit_out_T_128; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_620 = {{2'd0}, _ex1_pc_bit_out_T_129[31:2]}; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_134 = _GEN_620 & 32'h33333333; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_136 = {_ex1_pc_bit_out_T_129[29:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _ex1_pc_bit_out_T_138 = _ex1_pc_bit_out_T_136 & 32'hcccccccc; // @[Bitwise.scala 108:80]
  wire [31:0] _ex1_pc_bit_out_T_139 = _ex1_pc_bit_out_T_134 | _ex1_pc_bit_out_T_138; // @[Bitwise.scala 108:39]
  wire [31:0] _GEN_621 = {{1'd0}, _ex1_pc_bit_out_T_139[31:1]}; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_144 = _GEN_621 & 32'h55555555; // @[Bitwise.scala 108:31]
  wire [31:0] _ex1_pc_bit_out_T_146 = {_ex1_pc_bit_out_T_139[30:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [31:0] _ex1_pc_bit_out_T_148 = _ex1_pc_bit_out_T_146 & 32'haaaaaaaa; // @[Bitwise.scala 108:80]
  wire [31:0] _ex1_pc_bit_out_T_149 = _ex1_pc_bit_out_T_144 | _ex1_pc_bit_out_T_148; // @[Bitwise.scala 108:39]
  wire [32:0] _ex1_pc_bit_out_T_150 = {1'h1,_ex1_pc_bit_out_T_149}; // @[Cat.scala 33:92]
  wire [5:0] _ex1_pc_bit_out_T_184 = _ex1_pc_bit_out_T_150[31] ? 6'h1f : 6'h20; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_185 = _ex1_pc_bit_out_T_150[30] ? 6'h1e : _ex1_pc_bit_out_T_184; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_186 = _ex1_pc_bit_out_T_150[29] ? 6'h1d : _ex1_pc_bit_out_T_185; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_187 = _ex1_pc_bit_out_T_150[28] ? 6'h1c : _ex1_pc_bit_out_T_186; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_188 = _ex1_pc_bit_out_T_150[27] ? 6'h1b : _ex1_pc_bit_out_T_187; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_189 = _ex1_pc_bit_out_T_150[26] ? 6'h1a : _ex1_pc_bit_out_T_188; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_190 = _ex1_pc_bit_out_T_150[25] ? 6'h19 : _ex1_pc_bit_out_T_189; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_191 = _ex1_pc_bit_out_T_150[24] ? 6'h18 : _ex1_pc_bit_out_T_190; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_192 = _ex1_pc_bit_out_T_150[23] ? 6'h17 : _ex1_pc_bit_out_T_191; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_193 = _ex1_pc_bit_out_T_150[22] ? 6'h16 : _ex1_pc_bit_out_T_192; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_194 = _ex1_pc_bit_out_T_150[21] ? 6'h15 : _ex1_pc_bit_out_T_193; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_195 = _ex1_pc_bit_out_T_150[20] ? 6'h14 : _ex1_pc_bit_out_T_194; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_196 = _ex1_pc_bit_out_T_150[19] ? 6'h13 : _ex1_pc_bit_out_T_195; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_197 = _ex1_pc_bit_out_T_150[18] ? 6'h12 : _ex1_pc_bit_out_T_196; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_198 = _ex1_pc_bit_out_T_150[17] ? 6'h11 : _ex1_pc_bit_out_T_197; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_199 = _ex1_pc_bit_out_T_150[16] ? 6'h10 : _ex1_pc_bit_out_T_198; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_200 = _ex1_pc_bit_out_T_150[15] ? 6'hf : _ex1_pc_bit_out_T_199; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_201 = _ex1_pc_bit_out_T_150[14] ? 6'he : _ex1_pc_bit_out_T_200; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_202 = _ex1_pc_bit_out_T_150[13] ? 6'hd : _ex1_pc_bit_out_T_201; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_203 = _ex1_pc_bit_out_T_150[12] ? 6'hc : _ex1_pc_bit_out_T_202; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_204 = _ex1_pc_bit_out_T_150[11] ? 6'hb : _ex1_pc_bit_out_T_203; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_205 = _ex1_pc_bit_out_T_150[10] ? 6'ha : _ex1_pc_bit_out_T_204; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_206 = _ex1_pc_bit_out_T_150[9] ? 6'h9 : _ex1_pc_bit_out_T_205; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_207 = _ex1_pc_bit_out_T_150[8] ? 6'h8 : _ex1_pc_bit_out_T_206; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_208 = _ex1_pc_bit_out_T_150[7] ? 6'h7 : _ex1_pc_bit_out_T_207; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_209 = _ex1_pc_bit_out_T_150[6] ? 6'h6 : _ex1_pc_bit_out_T_208; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_210 = _ex1_pc_bit_out_T_150[5] ? 6'h5 : _ex1_pc_bit_out_T_209; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_211 = _ex1_pc_bit_out_T_150[4] ? 6'h4 : _ex1_pc_bit_out_T_210; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_212 = _ex1_pc_bit_out_T_150[3] ? 6'h3 : _ex1_pc_bit_out_T_211; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_213 = _ex1_pc_bit_out_T_150[2] ? 6'h2 : _ex1_pc_bit_out_T_212; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_214 = _ex1_pc_bit_out_T_150[1] ? 6'h1 : _ex1_pc_bit_out_T_213; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_215 = _ex1_pc_bit_out_T_150[0] ? 6'h0 : _ex1_pc_bit_out_T_214; // @[Mux.scala 47:70]
  wire [32:0] _ex1_pc_bit_out_T_217 = {1'h1,ex1_reg_op1_data}; // @[Cat.scala 33:92]
  wire [5:0] _ex1_pc_bit_out_T_251 = _ex1_pc_bit_out_T_217[31] ? 6'h1f : 6'h20; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_252 = _ex1_pc_bit_out_T_217[30] ? 6'h1e : _ex1_pc_bit_out_T_251; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_253 = _ex1_pc_bit_out_T_217[29] ? 6'h1d : _ex1_pc_bit_out_T_252; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_254 = _ex1_pc_bit_out_T_217[28] ? 6'h1c : _ex1_pc_bit_out_T_253; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_255 = _ex1_pc_bit_out_T_217[27] ? 6'h1b : _ex1_pc_bit_out_T_254; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_256 = _ex1_pc_bit_out_T_217[26] ? 6'h1a : _ex1_pc_bit_out_T_255; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_257 = _ex1_pc_bit_out_T_217[25] ? 6'h19 : _ex1_pc_bit_out_T_256; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_258 = _ex1_pc_bit_out_T_217[24] ? 6'h18 : _ex1_pc_bit_out_T_257; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_259 = _ex1_pc_bit_out_T_217[23] ? 6'h17 : _ex1_pc_bit_out_T_258; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_260 = _ex1_pc_bit_out_T_217[22] ? 6'h16 : _ex1_pc_bit_out_T_259; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_261 = _ex1_pc_bit_out_T_217[21] ? 6'h15 : _ex1_pc_bit_out_T_260; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_262 = _ex1_pc_bit_out_T_217[20] ? 6'h14 : _ex1_pc_bit_out_T_261; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_263 = _ex1_pc_bit_out_T_217[19] ? 6'h13 : _ex1_pc_bit_out_T_262; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_264 = _ex1_pc_bit_out_T_217[18] ? 6'h12 : _ex1_pc_bit_out_T_263; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_265 = _ex1_pc_bit_out_T_217[17] ? 6'h11 : _ex1_pc_bit_out_T_264; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_266 = _ex1_pc_bit_out_T_217[16] ? 6'h10 : _ex1_pc_bit_out_T_265; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_267 = _ex1_pc_bit_out_T_217[15] ? 6'hf : _ex1_pc_bit_out_T_266; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_268 = _ex1_pc_bit_out_T_217[14] ? 6'he : _ex1_pc_bit_out_T_267; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_269 = _ex1_pc_bit_out_T_217[13] ? 6'hd : _ex1_pc_bit_out_T_268; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_270 = _ex1_pc_bit_out_T_217[12] ? 6'hc : _ex1_pc_bit_out_T_269; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_271 = _ex1_pc_bit_out_T_217[11] ? 6'hb : _ex1_pc_bit_out_T_270; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_272 = _ex1_pc_bit_out_T_217[10] ? 6'ha : _ex1_pc_bit_out_T_271; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_273 = _ex1_pc_bit_out_T_217[9] ? 6'h9 : _ex1_pc_bit_out_T_272; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_274 = _ex1_pc_bit_out_T_217[8] ? 6'h8 : _ex1_pc_bit_out_T_273; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_275 = _ex1_pc_bit_out_T_217[7] ? 6'h7 : _ex1_pc_bit_out_T_274; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_276 = _ex1_pc_bit_out_T_217[6] ? 6'h6 : _ex1_pc_bit_out_T_275; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_277 = _ex1_pc_bit_out_T_217[5] ? 6'h5 : _ex1_pc_bit_out_T_276; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_278 = _ex1_pc_bit_out_T_217[4] ? 6'h4 : _ex1_pc_bit_out_T_277; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_279 = _ex1_pc_bit_out_T_217[3] ? 6'h3 : _ex1_pc_bit_out_T_278; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_280 = _ex1_pc_bit_out_T_217[2] ? 6'h2 : _ex1_pc_bit_out_T_279; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_281 = _ex1_pc_bit_out_T_217[1] ? 6'h1 : _ex1_pc_bit_out_T_280; // @[Mux.scala 47:70]
  wire [5:0] _ex1_pc_bit_out_T_282 = _ex1_pc_bit_out_T_217[0] ? 6'h0 : _ex1_pc_bit_out_T_281; // @[Mux.scala 47:70]
  wire [31:0] _ex1_pc_bit_out_T_288 = {ex1_reg_op1_data[7:0],ex1_reg_op1_data[15:8],ex1_reg_op1_data[23:16],
    ex1_reg_op1_data[31:24]}; // @[Cat.scala 33:92]
  wire [23:0] _ex1_pc_bit_out_T_292 = ex1_reg_op1_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _ex1_pc_bit_out_T_294 = {_ex1_pc_bit_out_T_292,ex1_reg_op1_data[7:0]}; // @[Cat.scala 33:92]
  wire [15:0] _ex1_pc_bit_out_T_298 = ex1_reg_op1_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _ex1_pc_bit_out_T_300 = {_ex1_pc_bit_out_T_298,ex1_reg_op1_data[15:0]}; // @[Cat.scala 33:92]
  wire  _ex1_pc_bit_out_T_301 = ex1_reg_exe_fun == 5'hc; // @[Core.scala 1291:22]
  wire [31:0] _ex1_pc_bit_out_T_305 = _ex1_alu_out_T_26 ? ex1_reg_op2_data : ex1_reg_op1_data; // @[Core.scala 1291:43]
  wire  _ex1_pc_bit_out_T_306 = ex1_reg_exe_fun == 5'hd; // @[Core.scala 1292:22]
  wire [31:0] _ex1_pc_bit_out_T_308 = _ex1_alu_out_T_28 ? ex1_reg_op2_data : ex1_reg_op1_data; // @[Core.scala 1292:43]
  wire  _ex1_pc_bit_out_T_309 = ex1_reg_exe_fun == 5'he; // @[Core.scala 1293:22]
  wire [31:0] _ex1_pc_bit_out_T_313 = _ex1_alu_out_T_26 ? ex1_reg_op1_data : ex1_reg_op2_data; // @[Core.scala 1293:43]
  wire [31:0] _ex1_pc_bit_out_T_316 = _ex1_alu_out_T_28 ? ex1_reg_op1_data : ex1_reg_op2_data; // @[Core.scala 1294:43]
  wire [31:0] _ex1_pc_bit_out_T_317 = _ex1_alu_out_T_38 ? _ex1_pc_bit_out_T_316 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_318 = _ex1_pc_bit_out_T_309 ? _ex1_pc_bit_out_T_313 : _ex1_pc_bit_out_T_317; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_319 = _ex1_pc_bit_out_T_306 ? _ex1_pc_bit_out_T_308 : _ex1_pc_bit_out_T_318; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_320 = _ex1_pc_bit_out_T_301 ? _ex1_pc_bit_out_T_305 : _ex1_pc_bit_out_T_319; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_321 = _ex1_alu_out_T_29 ? _ex1_pc_bit_out_T_300 : _ex1_pc_bit_out_T_320; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_322 = _ex1_alu_out_T_32 ? _ex1_pc_bit_out_T_294 : _ex1_pc_bit_out_T_321; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_323 = _ex1_alu_out_T_1 ? _ex1_pc_bit_out_T_288 : _ex1_pc_bit_out_T_322; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_324 = _ex1_alu_out_T_23 ? {{26'd0}, _ex1_pc_bit_out_T_282} : _ex1_pc_bit_out_T_323; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_325 = _ex1_alu_out_T_17 ? {{26'd0}, _ex1_pc_bit_out_T_215} : _ex1_pc_bit_out_T_324; // @[Mux.scala 101:16]
  wire [31:0] _ex1_pc_bit_out_T_326 = _ex1_alu_out_T_27 ? {{26'd0}, _ex1_pc_bit_out_T_98} : _ex1_pc_bit_out_T_325; // @[Mux.scala 101:16]
  wire [31:0] _ex1_dividend_T_1 = ~ex1_reg_op1_data; // @[Core.scala 1308:47]
  wire [31:0] _ex1_dividend_T_3 = _ex1_dividend_T_1 + 32'h1; // @[Core.scala 1308:65]
  wire [36:0] _ex1_dividend_T_5 = {5'h0,_ex1_dividend_T_3}; // @[Cat.scala 33:92]
  wire [36:0] _ex1_dividend_T_8 = {5'h0,ex1_reg_op1_data}; // @[Cat.scala 33:92]
  wire [31:0] _ex1_divisor_T_2 = _ex1_alu_out_T_13 + 32'h1; // @[Core.scala 1314:41]
  wire  _T_64 = _ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38; // @[Core.scala 1320:44]
  wire  ex1_sign_op1 = (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) & ex1_reg_op1_data[31]; // @[Core.scala 1305:69 1312:18]
  wire  _GEN_386 = ex1_reg_op2_data[31] ? ~ex1_sign_op1 : ex1_sign_op1; // @[Core.scala 1313:49 1315:21 1318:21]
  wire  ex1_divrem = _ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306 | _T_64; // @[Core.scala 1305:69 1306:16]
  wire  ex1_sign_op12 = (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) & _GEN_386; // @[Core.scala 1305:69]
  wire  ex1_zero_op2 = ex1_reg_op2_data == 32'h0; // @[Core.scala 1327:37]
  wire  _ex1_is_cond_br_T = ex1_reg_exe_fun == 5'h12; // @[Core.scala 1332:22]
  wire  _ex1_is_cond_br_T_1 = ex1_reg_op1_data == ex1_reg_op2_data; // @[Core.scala 1332:57]
  wire  _ex1_is_cond_br_T_2 = ex1_reg_exe_fun == 5'h13; // @[Core.scala 1333:22]
  wire  _ex1_is_cond_br_T_4 = ~_ex1_is_cond_br_T_1; // @[Core.scala 1333:38]
  wire  _ex1_is_cond_br_T_5 = ex1_reg_exe_fun == 5'h14; // @[Core.scala 1334:22]
  wire  _ex1_is_cond_br_T_9 = ex1_reg_exe_fun == 5'h15; // @[Core.scala 1335:22]
  wire  _ex1_is_cond_br_T_13 = ~_ex1_alu_out_T_26; // @[Core.scala 1335:38]
  wire  _ex1_is_cond_br_T_14 = ex1_reg_exe_fun == 5'h16; // @[Core.scala 1336:22]
  wire  _ex1_is_cond_br_T_16 = ex1_reg_exe_fun == 5'h17; // @[Core.scala 1337:22]
  wire  _ex1_is_cond_br_T_18 = ~_ex1_alu_out_T_28; // @[Core.scala 1337:38]
  wire  _ex1_is_cond_br_T_20 = _ex1_is_cond_br_T_14 ? _ex1_alu_out_T_28 : _ex1_is_cond_br_T_16 & _ex1_is_cond_br_T_18; // @[Mux.scala 101:16]
  wire  _ex1_is_cond_br_T_21 = _ex1_is_cond_br_T_9 ? _ex1_is_cond_br_T_13 : _ex1_is_cond_br_T_20; // @[Mux.scala 101:16]
  wire  _ex1_is_cond_br_T_22 = _ex1_is_cond_br_T_5 ? _ex1_alu_out_T_26 : _ex1_is_cond_br_T_21; // @[Mux.scala 101:16]
  wire  ex1_hazard = ex1_reg_rf_wen & ex1_reg_wb_addr != 5'h0 & _csr_is_valid_inst_T; // @[Core.scala 1351:76]
  wire  _ex1_fw_en_next_T_2 = ex1_reg_wb_sel != 3'h6; // @[Core.scala 1352:84]
  wire  ex1_fw_en_next = ex1_hazard & ex1_reg_wb_sel != 3'h4 & ex1_reg_wb_sel != 3'h6; // @[Core.scala 1352:65]
  wire  _jbr_reg_bp_en_T_1 = ex1_reg_is_valid_inst & _csr_is_valid_inst_T; // @[Core.scala 1363:55]
  wire  jbr_bp_en = jbr_reg_bp_en & _csr_is_valid_inst_T; // @[Core.scala 1377:33]
  wire  _jbr_cond_bp_fail_T = ~jbr_reg_bp_taken; // @[Core.scala 1379:6]
  wire  _jbr_cond_bp_fail_T_3 = jbr_reg_bp_taken_pc != jbr_reg_br_pc; // @[Core.scala 1380:69]
  wire  _jbr_cond_bp_fail_T_4 = jbr_reg_bp_taken & jbr_reg_is_cond_br & jbr_reg_bp_taken_pc != jbr_reg_br_pc; // @[Core.scala 1380:45]
  wire  _jbr_cond_bp_fail_T_5 = ~jbr_reg_bp_taken & jbr_reg_is_cond_br | _jbr_cond_bp_fail_T_4; // @[Core.scala 1379:47]
  wire  jbr_cond_bp_fail = jbr_bp_en & _jbr_cond_bp_fail_T_5; // @[Core.scala 1378:36]
  wire  jbr_cond_nbp_fail = jbr_bp_en & jbr_reg_bp_taken & jbr_reg_is_cond_br_inst & ~jbr_reg_is_cond_br; // @[Core.scala 1382:84]
  wire  _jbr_uncond_bp_fail_T_3 = jbr_reg_bp_taken & _jbr_cond_bp_fail_T_3; // @[Core.scala 1385:23]
  wire  _jbr_uncond_bp_fail_T_4 = _jbr_cond_bp_fail_T | _jbr_uncond_bp_fail_T_3; // @[Core.scala 1384:23]
  wire  jbr_uncond_bp_fail = jbr_bp_en & jbr_reg_is_uncond_br & _jbr_uncond_bp_fail_T_4; // @[Core.scala 1383:64]
  wire [30:0] _ex2_reg_br_pc_T_1 = ex2_reg_pc + 31'h1; // @[Core.scala 1389:59]
  wire [30:0] _ex2_reg_br_pc_T_3 = ex2_reg_pc + 31'h2; // @[Core.scala 1389:87]
  wire  csr_is_trap = ex2_reg_is_trap & csr_is_valid_inst & _ex2_en_T & _ex2_en_T_2; // @[Core.scala 1478:76]
  wire  csr_is_mret = ex2_en & ex2_reg_exe_fun == 5'h19; // @[Core.scala 1481:75]
  wire [30:0] _GEN_513 = csr_is_trap ? csr_reg_trap_vector : csr_reg_mepc; // @[Core.scala 1549:28 1558:26]
  wire [30:0] _GEN_521 = csr_is_mtintr ? csr_reg_trap_vector : _GEN_513; // @[Core.scala 1539:30 1548:26]
  wire [30:0] csr_br_pc = csr_is_meintr ? csr_reg_trap_vector : _GEN_521; // @[Core.scala 1529:24 1538:26]
  wire  jbr_is_br = jbr_cond_bp_fail | jbr_cond_nbp_fail | jbr_uncond_bp_fail; // @[Core.scala 1392:54]
  wire  _ic_pht_io_up_cnt_T_5 = ~jbr_reg_bp_cnt[1] | jbr_reg_bp_cnt[0]; // @[Core.scala 1400:51]
  wire [1:0] _ic_pht_io_up_cnt_T_6 = {jbr_reg_bp_cnt[0],_ic_pht_io_up_cnt_T_5}; // @[Cat.scala 33:92]
  wire  _ic_pht_io_up_cnt_T_8 = ~jbr_reg_bp_cnt[0]; // @[Core.scala 1401:9]
  wire  _ic_pht_io_up_cnt_T_11 = jbr_reg_bp_cnt[1] & jbr_reg_bp_cnt[0]; // @[Core.scala 1401:51]
  wire [1:0] _ic_pht_io_up_cnt_T_12 = {_ic_pht_io_up_cnt_T_8,_ic_pht_io_up_cnt_T_11}; // @[Cat.scala 33:92]
  wire [5:0] _ex2_reg_wdata_T_1 = 4'h8 * ex1_add_out[1:0]; // @[Core.scala 1421:53]
  wire [94:0] _GEN_65 = {{63'd0}, ex1_reg_op3_data}; // @[Core.scala 1421:45]
  wire [94:0] _ex2_reg_wdata_T_2 = _GEN_65 << _ex2_reg_wdata_T_1; // @[Core.scala 1421:45]
  wire  _ex2_reg_div_stall_T_2 = ex2_reg_divrem_state == 3'h0 | ex2_reg_divrem_state == 3'h5; // @[Core.scala 1428:65]
  wire  _ex2_reg_div_stall_T_3 = ex1_divrem & (ex2_reg_divrem_state == 3'h0 | ex2_reg_divrem_state == 3'h5); // @[Core.scala 1428:19]
  wire  _GEN_553 = 3'h2 == ex2_reg_divrem_state | 3'h3 == ex2_reg_divrem_state; // @[Core.scala 1681:33 1812:26]
  wire  _GEN_561 = 3'h1 == ex2_reg_divrem_state | _GEN_553; // @[Core.scala 1681:33 1719:29]
  wire  ex2_div_stall_next = 3'h0 == ex2_reg_divrem_state ? 1'h0 : _GEN_561; // @[Core.scala 1606:22 1681:33]
  wire  _ex2_reg_div_stall_T_8 = ex2_reg_divrem & _ex2_reg_div_stall_T_2; // @[Core.scala 1444:23]
  wire  _T_67 = ~ex2_reg_div_stall; // @[Core.scala 1446:28]
  wire  _T_71 = ex2_reg_wb_sel == 3'h5; // @[Core.scala 1506:42]
  wire  _T_75 = ex2_reg_csr_addr == 12'h300; // @[Core.scala 1511:34]
  wire  _GEN_468 = ex2_reg_csr_addr == 12'h341 ? 1'h0 : _T_75; // @[Core.scala 1462:42 1509:53]
  wire  _GEN_480 = ex2_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_468; // @[Core.scala 1462:42 1507:48]
  wire  _GEN_492 = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 & _GEN_480; // @[Core.scala 1462:42 1506:54]
  wire  _GEN_502 = csr_is_mret | _GEN_492; // @[Core.scala 1559:28 1562:26]
  wire  _GEN_510 = csr_is_trap | _GEN_502; // @[Core.scala 1549:28 1555:26]
  wire  _GEN_518 = csr_is_mtintr | _GEN_510; // @[Core.scala 1539:30 1545:26]
  wire  csr_mstatus_mie_fw_en = csr_is_meintr | _GEN_518; // @[Core.scala 1529:24 1535:26]
  wire  _csr_wdata_T = ex2_reg_csr_cmd == 2'h1; // @[Core.scala 1501:22]
  wire  _csr_wdata_T_1 = ex2_reg_csr_cmd == 2'h2; // @[Core.scala 1502:22]
  wire [31:0] _csr_rdata_T_10 = {20'h0,io_intr,3'h0,mtimer_io_intr,7'h0}; // @[Cat.scala 33:92]
  wire [31:0] _csr_rdata_T_9 = {20'h0,csr_reg_mie_meie,3'h0,csr_reg_mie_mtie,7'h0}; // @[Cat.scala 33:92]
  wire [31:0] _csr_rdata_T_8 = {24'h0,csr_reg_mstatus_mpie,3'h0,csr_reg_mstatus_mie,3'h0}; // @[Cat.scala 33:92]
  wire [31:0] _csr_rdata_T_7 = {csr_reg_mepc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _csr_rdata_T = {csr_reg_trap_vector,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _csr_rdata_T_12 = 12'h305 == ex2_reg_csr_addr ? _csr_rdata_T : 32'h0; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_14 = 12'hc01 == ex2_reg_csr_addr ? mtimer_io_mtime[31:0] : _csr_rdata_T_12; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_16 = 12'hc00 == ex2_reg_csr_addr ? cycle_counter_io_value[31:0] : _csr_rdata_T_14; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_18 = 12'hc02 == ex2_reg_csr_addr ? instret[31:0] : _csr_rdata_T_16; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_20 = 12'hc80 == ex2_reg_csr_addr ? cycle_counter_io_value[63:32] : _csr_rdata_T_18; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_22 = 12'hc81 == ex2_reg_csr_addr ? mtimer_io_mtime[63:32] : _csr_rdata_T_20; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_24 = 12'hc82 == ex2_reg_csr_addr ? instret[63:32] : _csr_rdata_T_22; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_26 = 12'h341 == ex2_reg_csr_addr ? _csr_rdata_T_7 : _csr_rdata_T_24; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_28 = 12'h342 == ex2_reg_csr_addr ? csr_reg_mcause : _csr_rdata_T_26; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_30 = 12'h300 == ex2_reg_csr_addr ? _csr_rdata_T_8 : _csr_rdata_T_28; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_32 = 12'h340 == ex2_reg_csr_addr ? csr_reg_mscratch : _csr_rdata_T_30; // @[Mux.scala 81:58]
  wire [31:0] _csr_rdata_T_34 = 12'h304 == ex2_reg_csr_addr ? _csr_rdata_T_9 : _csr_rdata_T_32; // @[Mux.scala 81:58]
  wire [31:0] csr_rdata = 12'h344 == ex2_reg_csr_addr ? _csr_rdata_T_10 : _csr_rdata_T_34; // @[Mux.scala 81:58]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | ex2_reg_op1_data; // @[Core.scala 1502:47]
  wire  _csr_wdata_T_3 = ex2_reg_csr_cmd == 2'h3; // @[Core.scala 1503:22]
  wire [31:0] _csr_wdata_T_4 = ~ex2_reg_op1_data; // @[Core.scala 1503:49]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _csr_wdata_T_4; // @[Core.scala 1503:47]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[Mux.scala 101:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? ex2_reg_op1_data : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire  _GEN_458 = ex2_reg_csr_addr == 12'h300 & csr_wdata[3]; // @[Core.scala 1511:56 1515:29 1463:39]
  wire  _GEN_469 = ex2_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_458; // @[Core.scala 1463:39 1509:53]
  wire  _GEN_481 = ex2_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_469; // @[Core.scala 1463:39 1507:48]
  wire  _GEN_493 = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 & _GEN_481; // @[Core.scala 1463:39 1506:54]
  wire  _GEN_503 = csr_is_mret ? csr_reg_mstatus_mpie : _GEN_493; // @[Core.scala 1559:28 1563:26]
  wire  _GEN_511 = csr_is_trap ? 1'h0 : _GEN_503; // @[Core.scala 1549:28 1556:26]
  wire  _GEN_519 = csr_is_mtintr ? 1'h0 : _GEN_511; // @[Core.scala 1539:30 1546:26]
  wire  csr_mstatus_mie_fw = csr_is_meintr ? 1'h0 : _GEN_519; // @[Core.scala 1529:24 1536:26]
  wire  _csr_reg_is_meintr_T_3 = csr_mstatus_mie_fw_en & csr_mstatus_mie_fw | ~csr_mstatus_mie_fw_en &
    csr_reg_mstatus_mie; // @[Core.scala 1465:52]
  wire  _csr_reg_is_meintr_T_4 = (csr_mstatus_mie_fw_en & csr_mstatus_mie_fw | ~csr_mstatus_mie_fw_en &
    csr_reg_mstatus_mie) & io_intr; // @[Core.scala 1465:104]
  wire  _T_77 = ex2_reg_csr_addr == 12'h304; // @[Core.scala 1518:34]
  wire  _GEN_452 = ex2_reg_csr_addr == 12'h340 ? 1'h0 : _T_77; // @[Core.scala 1459:34 1516:57]
  wire  _GEN_462 = ex2_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_452; // @[Core.scala 1459:34 1511:56]
  wire  _GEN_473 = ex2_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_462; // @[Core.scala 1459:34 1509:53]
  wire  _GEN_485 = ex2_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_473; // @[Core.scala 1459:34 1507:48]
  wire  csr_mie_fw_en = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 & _GEN_485; // @[Core.scala 1459:34 1506:54]
  wire  _GEN_447 = ex2_reg_csr_addr == 12'h304 & csr_wdata[11]; // @[Core.scala 1518:52 1522:24 1460:36]
  wire  _GEN_453 = ex2_reg_csr_addr == 12'h340 ? 1'h0 : _GEN_447; // @[Core.scala 1460:36 1516:57]
  wire  _GEN_463 = ex2_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_453; // @[Core.scala 1460:36 1511:56]
  wire  _GEN_474 = ex2_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_463; // @[Core.scala 1460:36 1509:53]
  wire  _GEN_486 = ex2_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_474; // @[Core.scala 1460:36 1507:48]
  wire  csr_mie_meie_fw = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 & _GEN_486; // @[Core.scala 1460:36 1506:54]
  wire  _csr_reg_is_meintr_T_6 = ~csr_mie_fw_en; // @[Core.scala 1467:47]
  wire  _csr_reg_is_meintr_T_8 = csr_mie_fw_en & csr_mie_meie_fw | ~csr_mie_fw_en & csr_reg_mie_meie; // @[Core.scala 1467:43]
  wire  _csr_reg_is_mtintr_T_4 = _csr_reg_is_meintr_T_3 & mtimer_io_intr; // @[Core.scala 1470:104]
  wire  _GEN_448 = ex2_reg_csr_addr == 12'h304 & csr_wdata[7]; // @[Core.scala 1518:52 1523:24 1461:36]
  wire  _GEN_454 = ex2_reg_csr_addr == 12'h340 ? 1'h0 : _GEN_448; // @[Core.scala 1461:36 1516:57]
  wire  _GEN_464 = ex2_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_454; // @[Core.scala 1461:36 1511:56]
  wire  _GEN_475 = ex2_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_464; // @[Core.scala 1461:36 1509:53]
  wire  _GEN_487 = ex2_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_475; // @[Core.scala 1461:36 1507:48]
  wire  csr_mie_mtie_fw = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 & _GEN_487; // @[Core.scala 1461:36 1506:54]
  wire  _csr_reg_is_mtintr_T_8 = csr_mie_fw_en & csr_mie_mtie_fw | _csr_reg_is_meintr_T_6 & csr_reg_mie_mtie; // @[Core.scala 1472:43]
  wire  ex2_is_valid_inst = ex2_en & ~csr_is_trap; // @[Core.scala 1480:31]
  wire  _GEN_444 = ex2_reg_csr_addr == 12'h304 ? csr_wdata[11] : csr_reg_mie_meie; // @[Core.scala 1518:52 1519:24 146:37]
  wire  _GEN_445 = ex2_reg_csr_addr == 12'h304 ? csr_wdata[7] : csr_reg_mie_mtie; // @[Core.scala 1518:52 1520:24 147:37]
  wire [31:0] _GEN_449 = ex2_reg_csr_addr == 12'h340 ? csr_wdata : csr_reg_mscratch; // @[Core.scala 1516:57 1517:24 145:37]
  wire  _GEN_450 = ex2_reg_csr_addr == 12'h340 ? csr_reg_mie_meie : _GEN_444; // @[Core.scala 146:37 1516:57]
  wire  _GEN_451 = ex2_reg_csr_addr == 12'h340 ? csr_reg_mie_mtie : _GEN_445; // @[Core.scala 147:37 1516:57]
  wire  _GEN_455 = ex2_reg_csr_addr == 12'h300 ? csr_wdata[3] : csr_reg_mstatus_mie; // @[Core.scala 1511:56 1512:29 143:37]
  wire  _GEN_456 = ex2_reg_csr_addr == 12'h300 ? csr_wdata[7] : csr_reg_mstatus_mpie; // @[Core.scala 1511:56 1513:29 144:37]
  wire [31:0] _GEN_459 = ex2_reg_csr_addr == 12'h300 ? csr_reg_mscratch : _GEN_449; // @[Core.scala 145:37 1511:56]
  wire  _GEN_460 = ex2_reg_csr_addr == 12'h300 ? csr_reg_mie_meie : _GEN_450; // @[Core.scala 146:37 1511:56]
  wire  _GEN_461 = ex2_reg_csr_addr == 12'h300 ? csr_reg_mie_mtie : _GEN_451; // @[Core.scala 147:37 1511:56]
  wire [30:0] _GEN_465 = ex2_reg_csr_addr == 12'h341 ? csr_wdata[31:1] : csr_reg_mepc; // @[Core.scala 1509:53 1510:20 142:37]
  wire  _GEN_466 = ex2_reg_csr_addr == 12'h341 ? csr_reg_mstatus_mie : _GEN_455; // @[Core.scala 143:37 1509:53]
  wire  _GEN_467 = ex2_reg_csr_addr == 12'h341 ? csr_reg_mstatus_mpie : _GEN_456; // @[Core.scala 144:37 1509:53]
  wire [30:0] _GEN_477 = ex2_reg_csr_addr == 12'h305 ? csr_reg_mepc : _GEN_465; // @[Core.scala 142:37 1507:48]
  wire  _GEN_478 = ex2_reg_csr_addr == 12'h305 ? csr_reg_mstatus_mie : _GEN_466; // @[Core.scala 143:37 1507:48]
  wire  _GEN_479 = ex2_reg_csr_addr == 12'h305 ? csr_reg_mstatus_mpie : _GEN_467; // @[Core.scala 144:37 1507:48]
  wire [30:0] _GEN_489 = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 ? _GEN_477 : csr_reg_mepc; // @[Core.scala 142:37 1506:54]
  wire  _GEN_490 = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 ? _GEN_478 : csr_reg_mstatus_mie; // @[Core.scala 143:37 1506:54]
  wire  _GEN_491 = _csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5 ? _GEN_479 : csr_reg_mstatus_mpie; // @[Core.scala 144:37 1506:54]
  wire  _GEN_500 = csr_is_mret | _GEN_491; // @[Core.scala 1559:28 1560:26]
  wire  _GEN_501 = csr_is_mret ? csr_reg_mstatus_mpie : _GEN_490; // @[Core.scala 1559:28 1561:26]
  wire  _GEN_512 = csr_is_trap | csr_is_mret; // @[Core.scala 1549:28 1557:26]
  wire  _GEN_520 = csr_is_mtintr | _GEN_512; // @[Core.scala 1539:30 1547:26]
  wire  csr_is_br = csr_is_meintr | _GEN_520; // @[Core.scala 1529:24 1537:26]
  reg [36:0] ex2_reg_dividend; // @[Core.scala 1576:37]
  reg [35:0] ex2_reg_divisor; // @[Core.scala 1577:37]
  reg [63:0] ex2_reg_p_divisor; // @[Core.scala 1578:37]
  reg [4:0] ex2_reg_divrem_count; // @[Core.scala 1579:37]
  reg [4:0] ex2_reg_rem_shift; // @[Core.scala 1580:37]
  reg  ex2_reg_extra_shift; // @[Core.scala 1581:37]
  reg [2:0] ex2_reg_d; // @[Core.scala 1582:37]
  reg [31:0] ex2_reg_reminder; // @[Core.scala 1583:37]
  reg [31:0] ex2_reg_quotient; // @[Core.scala 1584:37]
  wire  _ex2_alu_muldiv_out_T = ex2_reg_exe_fun == 5'h8; // @[Core.scala 1594:22]
  wire [31:0] _ex2_alu_muldiv_out_T_3 = {ex2_reg_mulhuu[15:0], 16'h0}; // @[Core.scala 1594:106]
  wire [31:0] _ex2_alu_muldiv_out_T_5 = ex2_reg_mullu[31:0] + _ex2_alu_muldiv_out_T_3; // @[Core.scala 1594:71]
  wire  _ex2_alu_muldiv_out_T_6 = ex2_reg_exe_fun == 5'h9; // @[Core.scala 1595:22]
  wire [15:0] _ex2_alu_muldiv_out_T_9 = ex2_reg_mulls[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 77:12]
  wire [47:0] _ex2_alu_muldiv_out_T_12 = {_ex2_alu_muldiv_out_T_9,ex2_reg_mulls}; // @[Core.scala 1587:65]
  wire [47:0] _ex2_alu_muldiv_out_T_15 = $signed(_ex2_alu_muldiv_out_T_12) + $signed(ex2_reg_mulhss); // @[Core.scala 1595:80]
  wire  _ex2_alu_muldiv_out_T_17 = ex2_reg_exe_fun == 5'ha; // @[Core.scala 1596:22]
  wire [47:0] _ex2_alu_muldiv_out_T_21 = {16'h0,ex2_reg_mullu[47:16]}; // @[Core.scala 1590:35]
  wire [47:0] _ex2_alu_muldiv_out_T_23 = _ex2_alu_muldiv_out_T_21 + ex2_reg_mulhuu; // @[Core.scala 1596:108]
  wire  _ex2_alu_muldiv_out_T_25 = ex2_reg_exe_fun == 5'hb; // @[Core.scala 1597:22]
  wire [47:0] _ex2_alu_muldiv_out_T_34 = $signed(_ex2_alu_muldiv_out_T_12) + $signed(ex2_reg_mulhsu); // @[Core.scala 1597:80]
  wire  _ex2_alu_muldiv_out_T_36 = ex2_reg_exe_fun == 5'hc; // @[Core.scala 1598:22]
  wire  _ex2_alu_muldiv_out_T_37 = ex2_reg_exe_fun == 5'he; // @[Core.scala 1599:22]
  wire  _ex2_alu_muldiv_out_T_38 = ex2_reg_exe_fun == 5'hd; // @[Core.scala 1600:22]
  wire  _ex2_alu_muldiv_out_T_39 = ex2_reg_exe_fun == 5'hf; // @[Core.scala 1601:22]
  wire [31:0] _ex2_alu_muldiv_out_T_40 = _ex2_alu_muldiv_out_T_39 ? ex2_reg_reminder : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_41 = _ex2_alu_muldiv_out_T_38 ? ex2_reg_reminder : _ex2_alu_muldiv_out_T_40; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_42 = _ex2_alu_muldiv_out_T_37 ? ex2_reg_quotient : _ex2_alu_muldiv_out_T_41; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_43 = _ex2_alu_muldiv_out_T_36 ? ex2_reg_quotient : _ex2_alu_muldiv_out_T_42; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_44 = _ex2_alu_muldiv_out_T_25 ? _ex2_alu_muldiv_out_T_34[47:16] :
    _ex2_alu_muldiv_out_T_43; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_45 = _ex2_alu_muldiv_out_T_17 ? _ex2_alu_muldiv_out_T_23[47:16] :
    _ex2_alu_muldiv_out_T_44; // @[Mux.scala 101:16]
  wire [31:0] _ex2_alu_muldiv_out_T_46 = _ex2_alu_muldiv_out_T_6 ? _ex2_alu_muldiv_out_T_15[47:16] :
    _ex2_alu_muldiv_out_T_45; // @[Mux.scala 101:16]
  wire [31:0] ex2_alu_muldiv_out = _ex2_alu_muldiv_out_T ? _ex2_alu_muldiv_out_T_5 : _ex2_alu_muldiv_out_T_46; // @[Mux.scala 101:16]
  wire [1:0] _GEN_530 = ex2_reg_init_divisor[31:2] == 30'h0 ? 2'h2 : 2'h1; // @[Core.scala 1684:60 1685:32 1687:32]
  wire [36:0] _ex2_reg_dividend_T = ex2_reg_init_dividend; // @[Core.scala 1691:53]
  wire [35:0] _ex2_reg_divisor_T_1 = {ex2_reg_init_divisor[3:0],32'h0}; // @[Cat.scala 33:92]
  wire [63:0] _ex2_reg_p_divisor_T = {ex2_reg_init_divisor,32'h0}; // @[Cat.scala 33:92]
  wire [2:0] _ex2_reg_d_T_1 = {ex2_reg_init_divisor[0],2'h0}; // @[Cat.scala 33:92]
  wire [4:0] _ex2_reg_divrem_count_T_1 = ex2_reg_divrem_count + 5'h1; // @[Core.scala 1711:52]
  wire  _p_T_1 = ~ex2_reg_dividend[36]; // @[Core.scala 1723:42]
  wire [4:0] _p_T_4 = ~ex2_reg_dividend[35:31]; // @[Core.scala 1725:11]
  wire [4:0] _p_T_5 = ~ex2_reg_dividend[36] ? ex2_reg_dividend[35:31] : _p_T_4; // @[Core.scala 1723:12]
  wire [4:0] _p_T_10 = ~ex2_reg_dividend[34:30]; // @[Core.scala 1729:11]
  wire [4:0] _p_T_11 = _p_T_1 ? ex2_reg_dividend[34:30] : _p_T_10; // @[Core.scala 1727:12]
  wire [4:0] p = ex2_reg_extra_shift ? _p_T_5 : _p_T_11; // @[Core.scala 1722:18]
  wire [1:0] _ex2_q_T_5 = 5'h2 == p ? 2'h1 : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_7 = 5'h3 == p ? 2'h1 : _ex2_q_T_5; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_9 = 5'h4 == p ? 2'h1 : _ex2_q_T_7; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_11 = 5'h5 == p ? 2'h1 : _ex2_q_T_9; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_13 = 5'h6 == p ? 2'h2 : _ex2_q_T_11; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_15 = 5'h7 == p ? 2'h2 : _ex2_q_T_13; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_17 = 5'h8 == p ? 2'h2 : _ex2_q_T_15; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_19 = 5'h9 == p ? 2'h2 : _ex2_q_T_17; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_21 = 5'ha == p ? 2'h2 : _ex2_q_T_19; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_23 = 5'hb == p ? 2'h2 : _ex2_q_T_21; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_37 = 5'h6 == p ? 2'h1 : _ex2_q_T_11; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_39 = 5'h7 == p ? 2'h2 : _ex2_q_T_37; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_41 = 5'h8 == p ? 2'h2 : _ex2_q_T_39; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_43 = 5'h9 == p ? 2'h2 : _ex2_q_T_41; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_45 = 5'ha == p ? 2'h2 : _ex2_q_T_43; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_47 = 5'hb == p ? 2'h2 : _ex2_q_T_45; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_49 = 5'hc == p ? 2'h2 : _ex2_q_T_47; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_51 = 5'hd == p ? 2'h2 : _ex2_q_T_49; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_67 = 5'h7 == p ? 2'h1 : _ex2_q_T_37; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_69 = 5'h8 == p ? 2'h2 : _ex2_q_T_67; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_71 = 5'h9 == p ? 2'h2 : _ex2_q_T_69; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_73 = 5'ha == p ? 2'h2 : _ex2_q_T_71; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_75 = 5'hb == p ? 2'h2 : _ex2_q_T_73; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_77 = 5'hc == p ? 2'h2 : _ex2_q_T_75; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_79 = 5'hd == p ? 2'h2 : _ex2_q_T_77; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_81 = 5'he == p ? 2'h2 : _ex2_q_T_79; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_83 = 5'hf == p ? 2'h2 : _ex2_q_T_81; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_125 = 5'h4 == p ? 2'h1 : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_127 = 5'h5 == p ? 2'h1 : _ex2_q_T_125; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_129 = 5'h6 == p ? 2'h1 : _ex2_q_T_127; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_131 = 5'h7 == p ? 2'h1 : _ex2_q_T_129; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_133 = 5'h8 == p ? 2'h1 : _ex2_q_T_131; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_135 = 5'h9 == p ? 2'h1 : _ex2_q_T_133; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_137 = 5'ha == p ? 2'h2 : _ex2_q_T_135; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_139 = 5'hb == p ? 2'h2 : _ex2_q_T_137; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_141 = 5'hc == p ? 2'h2 : _ex2_q_T_139; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_143 = 5'hd == p ? 2'h2 : _ex2_q_T_141; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_145 = 5'he == p ? 2'h2 : _ex2_q_T_143; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_147 = 5'hf == p ? 2'h2 : _ex2_q_T_145; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_149 = 5'h10 == p ? 2'h2 : _ex2_q_T_147; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_151 = 5'h11 == p ? 2'h2 : _ex2_q_T_149; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_189 = 5'h12 == p ? 2'h2 : _ex2_q_T_151; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_191 = 5'h13 == p ? 2'h2 : _ex2_q_T_189; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_253 = 5'ha == p ? 2'h1 : _ex2_q_T_135; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_255 = 5'hb == p ? 2'h1 : _ex2_q_T_253; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_257 = 5'hc == p ? 2'h2 : _ex2_q_T_255; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_259 = 5'hd == p ? 2'h2 : _ex2_q_T_257; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_261 = 5'he == p ? 2'h2 : _ex2_q_T_259; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_263 = 5'hf == p ? 2'h2 : _ex2_q_T_261; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_265 = 5'h10 == p ? 2'h2 : _ex2_q_T_263; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_267 = 5'h11 == p ? 2'h2 : _ex2_q_T_265; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_269 = 5'h12 == p ? 2'h2 : _ex2_q_T_267; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_271 = 5'h13 == p ? 2'h2 : _ex2_q_T_269; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_273 = 5'h14 == p ? 2'h2 : _ex2_q_T_271; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_275 = 5'h15 == p ? 2'h2 : _ex2_q_T_273; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_277 = 3'h1 == ex2_reg_d ? _ex2_q_T_51 : _ex2_q_T_23; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_279 = 3'h2 == ex2_reg_d ? _ex2_q_T_83 : _ex2_q_T_277; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_281 = 3'h3 == ex2_reg_d ? _ex2_q_T_83 : _ex2_q_T_279; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_283 = 3'h4 == ex2_reg_d ? _ex2_q_T_151 : _ex2_q_T_281; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_285 = 3'h5 == ex2_reg_d ? _ex2_q_T_191 : _ex2_q_T_283; // @[Mux.scala 81:58]
  wire [1:0] _ex2_q_T_287 = 3'h6 == ex2_reg_d ? _ex2_q_T_191 : _ex2_q_T_285; // @[Mux.scala 81:58]
  wire [1:0] ex2_q = 3'h7 == ex2_reg_d ? _ex2_q_T_275 : _ex2_q_T_287; // @[Mux.scala 81:58]
  wire [38:0] _ex2_reg_dividend_T_1 = {$signed(ex2_reg_dividend), 2'h0}; // @[Core.scala 1789:54]
  wire [36:0] _ex2_reg_dividend_T_5 = {1'h0,ex2_reg_divisor}; // @[Core.scala 1790:85]
  wire [36:0] _ex2_reg_dividend_T_8 = $signed(ex2_reg_dividend) - $signed(_ex2_reg_dividend_T_5); // @[Core.scala 1790:52]
  wire [38:0] _ex2_reg_dividend_T_9 = {$signed(_ex2_reg_dividend_T_8), 2'h0}; // @[Core.scala 1790:93]
  wire [36:0] _ex2_reg_dividend_T_13 = {ex2_reg_divisor,1'h0}; // @[Core.scala 1791:85]
  wire [36:0] _ex2_reg_dividend_T_16 = $signed(ex2_reg_dividend) - $signed(_ex2_reg_dividend_T_13); // @[Core.scala 1791:52]
  wire [38:0] _ex2_reg_dividend_T_17 = {$signed(_ex2_reg_dividend_T_16), 2'h0}; // @[Core.scala 1791:93]
  wire [38:0] _ex2_reg_dividend_T_18 = ex2_q[1] ? $signed(_ex2_reg_dividend_T_17) : $signed(_ex2_reg_dividend_T_1); // @[Mux.scala 101:16]
  wire [38:0] _ex2_reg_dividend_T_19 = ex2_q[0] ? $signed(_ex2_reg_dividend_T_9) : $signed(_ex2_reg_dividend_T_18); // @[Mux.scala 101:16]
  wire [33:0] _ex2_reg_quotient_T = {ex2_reg_quotient, 2'h0}; // @[Core.scala 1793:54]
  wire [33:0] _ex2_reg_quotient_T_5 = _ex2_reg_quotient_T + 34'h1; // @[Core.scala 1794:58]
  wire [33:0] _ex2_reg_quotient_T_10 = _ex2_reg_quotient_T + 34'h2; // @[Core.scala 1795:58]
  wire [33:0] _ex2_reg_quotient_T_11 = ex2_q[1] ? _ex2_reg_quotient_T_10 : _ex2_reg_quotient_T; // @[Mux.scala 101:16]
  wire [33:0] _ex2_reg_quotient_T_12 = ex2_q[0] ? _ex2_reg_quotient_T_5 : _ex2_reg_quotient_T_11; // @[Mux.scala 101:16]
  wire [36:0] _ex2_reg_dividend_T_27 = $signed(ex2_reg_dividend) + $signed(_ex2_reg_dividend_T_5); // @[Core.scala 1799:52]
  wire [38:0] _ex2_reg_dividend_T_28 = {$signed(_ex2_reg_dividend_T_27), 2'h0}; // @[Core.scala 1799:93]
  wire [36:0] _ex2_reg_dividend_T_35 = $signed(ex2_reg_dividend) + $signed(_ex2_reg_dividend_T_13); // @[Core.scala 1800:52]
  wire [38:0] _ex2_reg_dividend_T_36 = {$signed(_ex2_reg_dividend_T_35), 2'h0}; // @[Core.scala 1800:93]
  wire [38:0] _ex2_reg_dividend_T_37 = ex2_q[1] ? $signed(_ex2_reg_dividend_T_36) : $signed(_ex2_reg_dividend_T_1); // @[Mux.scala 101:16]
  wire [38:0] _ex2_reg_dividend_T_38 = ex2_q[0] ? $signed(_ex2_reg_dividend_T_28) : $signed(_ex2_reg_dividend_T_37); // @[Mux.scala 101:16]
  wire [33:0] _ex2_reg_quotient_T_18 = _ex2_reg_quotient_T - 34'h1; // @[Core.scala 1803:58]
  wire [33:0] _ex2_reg_quotient_T_23 = _ex2_reg_quotient_T - 34'h2; // @[Core.scala 1804:58]
  wire [33:0] _ex2_reg_quotient_T_24 = ex2_q[1] ? _ex2_reg_quotient_T_23 : _ex2_reg_quotient_T; // @[Mux.scala 101:16]
  wire [33:0] _ex2_reg_quotient_T_25 = ex2_q[0] ? _ex2_reg_quotient_T_18 : _ex2_reg_quotient_T_24; // @[Mux.scala 101:16]
  wire [38:0] _GEN_537 = _p_T_1 ? $signed(_ex2_reg_dividend_T_19) : $signed(_ex2_reg_dividend_T_38); // @[Core.scala 1788:51 1789:26 1798:26]
  wire [33:0] _GEN_538 = _p_T_1 ? _ex2_reg_quotient_T_12 : _ex2_reg_quotient_T_25; // @[Core.scala 1788:51 1793:26 1802:26]
  wire [4:0] _ex2_reg_rem_shift_T_1 = ex2_reg_rem_shift + 5'h1; // @[Core.scala 1807:46]
  wire [2:0] _GEN_539 = ex2_reg_divrem_count == 5'h10 ? 3'h3 : ex2_reg_divrem_state; // @[Core.scala 1809:44 1810:30 314:37]
  wire [5:0] _ex2_reg_reminder_T = {ex2_reg_rem_shift,1'h0}; // @[Cat.scala 33:92]
  wire [36:0] _ex2_reg_reminder_T_1 = $signed(ex2_reg_dividend) >>> _ex2_reg_reminder_T; // @[Core.scala 1815:45]
  wire [31:0] _reminder_T_4 = ex2_reg_reminder + ex2_reg_init_divisor; // @[Core.scala 1821:26]
  wire [31:0] reminder = ex2_reg_dividend[36] ? _reminder_T_4 : ex2_reg_reminder; // @[Core.scala 1820:25]
  wire [31:0] _ex2_reg_reminder_T_4 = ~reminder; // @[Core.scala 1828:11]
  wire [31:0] _ex2_reg_reminder_T_6 = _ex2_reg_reminder_T_4 + 32'h1; // @[Core.scala 1828:21]
  wire [31:0] _ex2_reg_reminder_T_7 = ~ex2_reg_sign_op1 ? reminder : _ex2_reg_reminder_T_6; // @[Core.scala 1826:12]
  wire [31:0] _ex2_reg_reminder_T_8 = ex2_reg_zero_op2 ? ex2_reg_orig_dividend : _ex2_reg_reminder_T_7; // @[Core.scala 1824:30]
  wire [31:0] _quotient_T_3 = ex2_reg_quotient - 32'h1; // @[Core.scala 1832:26]
  wire [31:0] quotient = ex2_reg_dividend[36] ? _quotient_T_3 : ex2_reg_quotient; // @[Core.scala 1831:25]
  wire [31:0] _ex2_reg_quotient_T_27 = ~quotient; // @[Core.scala 1839:11]
  wire [31:0] _ex2_reg_quotient_T_29 = _ex2_reg_quotient_T_27 + 32'h1; // @[Core.scala 1839:21]
  wire [31:0] _ex2_reg_quotient_T_30 = ~ex2_reg_sign_op12 ? quotient : _ex2_reg_quotient_T_29; // @[Core.scala 1837:12]
  wire [31:0] _ex2_reg_quotient_T_31 = ex2_reg_zero_op2 ? 32'hffffffff : _ex2_reg_quotient_T_30; // @[Core.scala 1835:30]
  wire [2:0] _GEN_540 = 3'h5 == ex2_reg_divrem_state ? 3'h0 : ex2_reg_divrem_state; // @[Core.scala 1681:33 1846:28 314:37]
  wire [31:0] _GEN_541 = 3'h4 == ex2_reg_divrem_state ? _ex2_reg_reminder_T_8 : ex2_reg_reminder; // @[Core.scala 1681:33 1824:24 1583:37]
  wire [31:0] _GEN_542 = 3'h4 == ex2_reg_divrem_state ? _ex2_reg_quotient_T_31 : ex2_reg_quotient; // @[Core.scala 1681:33 1835:24 1584:37]
  wire [2:0] _GEN_543 = 3'h4 == ex2_reg_divrem_state ? 3'h5 : _GEN_540; // @[Core.scala 1681:33 1842:28]
  wire [31:0] _GEN_544 = 3'h3 == ex2_reg_divrem_state ? _ex2_reg_reminder_T_1[31:0] : _GEN_541; // @[Core.scala 1681:33 1815:24]
  wire [2:0] _GEN_545 = 3'h3 == ex2_reg_divrem_state ? 3'h4 : _GEN_543; // @[Core.scala 1681:33 1816:28]
  wire [31:0] _GEN_547 = 3'h3 == ex2_reg_divrem_state ? ex2_reg_quotient : _GEN_542; // @[Core.scala 1681:33 1584:37]
  wire [38:0] _GEN_548 = 3'h2 == ex2_reg_divrem_state ? $signed(_GEN_537) : $signed({{2{ex2_reg_dividend[36]}},
    ex2_reg_dividend}); // @[Core.scala 1681:33 1576:37]
  wire [33:0] _GEN_549 = 3'h2 == ex2_reg_divrem_state ? _GEN_538 : {{2'd0}, _GEN_547}; // @[Core.scala 1681:33]
  wire [38:0] _GEN_562 = 3'h1 == ex2_reg_divrem_state ? $signed({{2{ex2_reg_dividend[36]}},ex2_reg_dividend}) : $signed(
    _GEN_548); // @[Core.scala 1681:33 1576:37]
  wire [33:0] _GEN_563 = 3'h1 == ex2_reg_divrem_state ? {{2'd0}, ex2_reg_quotient} : _GEN_549; // @[Core.scala 1681:33 1584:37]
  wire [38:0] _GEN_567 = 3'h0 == ex2_reg_divrem_state ? $signed({{2{_ex2_reg_dividend_T[36]}},_ex2_reg_dividend_T}) :
    $signed(_GEN_562); // @[Core.scala 1681:33 1691:28]
  wire [33:0] _GEN_572 = 3'h0 == ex2_reg_divrem_state ? 34'h0 : _GEN_563; // @[Core.scala 1681:33 1696:28]
  wire  _ex2_wb_data_T_4 = ex2_reg_wb_sel == 3'h3; // @[Core.scala 1864:23]
  wire  _ex2_wb_data_T_5 = _T_71 | _ex2_wb_data_T_4; // @[Core.scala 1863:35]
  wire  _ex2_wb_data_T_6 = ex2_reg_wb_sel == 3'h4; // @[Core.scala 1866:21]
  wire [31:0] _ex2_wb_data_T_7 = _ex2_wb_data_T_6 ? ex2_alu_muldiv_out : ex2_reg_alu_out; // @[Mux.scala 101:16]
  wire [31:0] _ex2_wb_data_T_8 = _ex2_wb_data_T_5 ? csr_rdata : _ex2_wb_data_T_7; // @[Mux.scala 101:16]
  wire [31:0] ex2_wb_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8; // @[Mux.scala 101:16]
  wire  _T_112 = ex2_en & _T_67 & ex2_reg_rf_wen; // @[Core.scala 1883:38]
  wire  _mem1_reg_mem_wstrb_T = ex1_reg_mem_w == 3'h5; // @[Core.scala 1899:22]
  wire  _mem1_reg_mem_wstrb_T_1 = ex1_reg_mem_w == 3'h4; // @[Core.scala 1900:22]
  wire [3:0] _mem1_reg_mem_wstrb_T_2 = _mem1_reg_mem_wstrb_T_1 ? 4'h3 : 4'hf; // @[Mux.scala 101:16]
  wire [3:0] _mem1_reg_mem_wstrb_T_3 = _mem1_reg_mem_wstrb_T ? 4'h1 : _mem1_reg_mem_wstrb_T_2; // @[Mux.scala 101:16]
  wire [6:0] _GEN_66 = {{3'd0}, _mem1_reg_mem_wstrb_T_3}; // @[Core.scala 1902:8]
  wire [6:0] _mem1_reg_mem_wstrb_T_5 = _GEN_66 << ex1_add_out[1:0]; // @[Core.scala 1902:8]
  wire  mem1_is_dram = ex1_add_out[31:28] == 4'h2; // @[Core.scala 1905:70]
  wire  _mem1_reg_is_mem_load_T = ~mem1_is_dram; // @[Core.scala 1907:31]
  wire  _mem1_reg_is_mem_load_T_1 = ex1_reg_wb_sel == 3'h6; // @[Core.scala 1907:64]
  wire  _mem1_reg_is_mem_store_T_1 = ex1_reg_wb_sel == 3'h2; // @[Core.scala 1908:64]
  wire  _mem1_reg_is_dram_fence_T = ex1_reg_wb_sel == 3'h3; // @[Core.scala 1911:47]
  wire  mem1_is_valid_inst = mem1_reg_is_valid_inst & ex2_en; // @[Core.scala 1926:51]
  wire  _mem1_mem_stall_delay_T_1 = ~mem1_mem_stall; // @[Core.scala 1941:65]
  wire  _T_115 = ~mem2_dram_stall; // @[Core.scala 1959:9]
  wire  _mem2_reg_is_valid_load_T_2 = ~mem1_dram_stall; // @[Core.scala 1964:74]
  wire  _mem2_reg_is_valid_load_T_3 = ~mem1_dram_stall & mem1_is_dram_load; // @[Core.scala 1964:91]
  wire  _mem2_reg_mem_use_reg_T_2 = _mem1_mem_stall_delay_T_1 & _mem2_reg_is_valid_load_T_2; // @[Core.scala 1965:48]
  wire [5:0] _mem3_wb_rdata_T = 4'h8 * mem3_reg_wb_byte_offset; // @[Core.scala 2006:51]
  wire [31:0] mem3_wb_rdata = mem3_reg_dmem_rdata >> _mem3_wb_rdata_T; // @[Core.scala 2006:43]
  wire  _mem3_wb_data_load_T = mem3_reg_mem_w == 3'h5; // @[Core.scala 2008:21]
  wire [23:0] _mem3_wb_data_load_T_3 = mem3_wb_rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _mem3_wb_data_load_T_5 = {_mem3_wb_data_load_T_3,mem3_wb_rdata[7:0]}; // @[Core.scala 2000:40]
  wire  _mem3_wb_data_load_T_6 = mem3_reg_mem_w == 3'h4; // @[Core.scala 2009:21]
  wire [15:0] _mem3_wb_data_load_T_9 = mem3_wb_rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 77:12]
  wire [31:0] _mem3_wb_data_load_T_11 = {_mem3_wb_data_load_T_9,mem3_wb_rdata[15:0]}; // @[Core.scala 2000:40]
  wire  _mem3_wb_data_load_T_12 = mem3_reg_mem_w == 3'h7; // @[Core.scala 2010:21]
  wire [31:0] _mem3_wb_data_load_T_15 = {24'h0,mem3_wb_rdata[7:0]}; // @[Core.scala 2003:31]
  wire  _mem3_wb_data_load_T_16 = mem3_reg_mem_w == 3'h6; // @[Core.scala 2011:21]
  wire [31:0] _mem3_wb_data_load_T_19 = {16'h0,mem3_wb_rdata[15:0]}; // @[Core.scala 2003:31]
  wire [31:0] _mem3_wb_data_load_T_20 = _mem3_wb_data_load_T_16 ? _mem3_wb_data_load_T_19 : mem3_wb_rdata; // @[Mux.scala 101:16]
  wire [31:0] _mem3_wb_data_load_T_21 = _mem3_wb_data_load_T_12 ? _mem3_wb_data_load_T_15 : _mem3_wb_data_load_T_20; // @[Mux.scala 101:16]
  wire [31:0] _mem3_wb_data_load_T_22 = _mem3_wb_data_load_T_6 ? _mem3_wb_data_load_T_11 : _mem3_wb_data_load_T_21; // @[Mux.scala 101:16]
  wire [31:0] mem3_wb_data_load = _mem3_wb_data_load_T ? _mem3_wb_data_load_T_5 : _mem3_wb_data_load_T_22; // @[Mux.scala 101:16]
  wire [63:0] _instret_T_1 = instret + 64'h2; // @[Core.scala 2022:24]
  wire [63:0] _instret_T_3 = instret + 64'h1; // @[Core.scala 2024:24]
  wire [31:0] _io_debug_signal_ex2_reg_pc_T = {ex2_reg_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_120 = {if2_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_129 = {ic_bp_taken_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_145 = {rrd_reg_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_164 = {ex1_reg_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_183 = {ex1_reg_bp_taken_pc,1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _T_192 = {ex2_reg_br_pc,1'h0}; // @[Cat.scala 33:92]
  wire [32:0] _GEN_622 = reset ? 33'h0 : _GEN_332; // @[Core.scala 173:{38,38}]
  wire [32:0] _GEN_623 = reset ? 33'h0 : _GEN_256; // @[Core.scala 954:{40,40}]
  wire [38:0] _GEN_624 = reset ? $signed(39'sh0) : $signed(_GEN_567); // @[Core.scala 1576:{37,37}]
  wire [33:0] _GEN_626 = reset ? 34'h0 : _GEN_572; // @[Core.scala 1584:{37,37}]
  LongCounter cycle_counter ( // @[Core.scala 135:29]
    .clock(cycle_counter_clock),
    .reset(cycle_counter_reset),
    .io_value(cycle_counter_io_value)
  );
  MachineTimer mtimer ( // @[Core.scala 136:22]
    .clock(mtimer_clock),
    .reset(mtimer_reset),
    .io_mem_raddr(mtimer_io_mem_raddr),
    .io_mem_rdata(mtimer_io_mem_rdata),
    .io_mem_ren(mtimer_io_mem_ren),
    .io_mem_waddr(mtimer_io_mem_waddr),
    .io_mem_wen(mtimer_io_mem_wen),
    .io_mem_wdata(mtimer_io_mem_wdata),
    .io_intr(mtimer_io_intr),
    .io_mtime(mtimer_io_mtime)
  );
  BTB ic_btb ( // @[Core.scala 358:22]
    .clock(ic_btb_clock),
    .reset(ic_btb_reset),
    .io_lu_pc(ic_btb_io_lu_pc),
    .io_lu_matches0(ic_btb_io_lu_matches0),
    .io_lu_taken_pc0(ic_btb_io_lu_taken_pc0),
    .io_lu_matches1(ic_btb_io_lu_matches1),
    .io_lu_taken_pc1(ic_btb_io_lu_taken_pc1),
    .io_up_en(ic_btb_io_up_en),
    .io_up_pc(ic_btb_io_up_pc),
    .io_up_taken_pc(ic_btb_io_up_taken_pc)
  );
  PHT ic_pht ( // @[Core.scala 359:22]
    .io_lu_pc(ic_pht_io_lu_pc),
    .io_lu_cnt0(ic_pht_io_lu_cnt0),
    .io_lu_cnt1(ic_pht_io_lu_cnt1),
    .io_up_en(ic_pht_io_up_en),
    .io_up_pc(ic_pht_io_up_pc),
    .io_up_cnt(ic_pht_io_up_cnt),
    .io_mem_wen(ic_pht_io_mem_wen),
    .io_mem_raddr(ic_pht_io_mem_raddr),
    .io_mem_rdata(ic_pht_io_mem_rdata),
    .io_mem_waddr(ic_pht_io_mem_waddr),
    .io_mem_wdata(ic_pht_io_mem_wdata)
  );
  assign regfile_rrd_op1_data_MPORT_en = 1'h1;
  assign regfile_rrd_op1_data_MPORT_addr = rrd_reg_rs1_addr;
  assign regfile_rrd_op1_data_MPORT_data = regfile[regfile_rrd_op1_data_MPORT_addr]; // @[Core.scala 133:20]
  assign regfile_rrd_op2_data_MPORT_en = 1'h1;
  assign regfile_rrd_op2_data_MPORT_addr = rrd_reg_rs2_addr;
  assign regfile_rrd_op2_data_MPORT_data = regfile[regfile_rrd_op2_data_MPORT_addr]; // @[Core.scala 133:20]
  assign regfile_rrd_op3_data_MPORT_en = 1'h1;
  assign regfile_rrd_op3_data_MPORT_addr = rrd_reg_rs3_addr;
  assign regfile_rrd_op3_data_MPORT_data = regfile[regfile_rrd_op3_data_MPORT_addr]; // @[Core.scala 133:20]
  assign regfile_MPORT_3_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8;
  assign regfile_MPORT_3_addr = ex2_reg_wb_addr;
  assign regfile_MPORT_3_mask = 1'h1;
  assign regfile_MPORT_3_en = _T_112 & ex2_reg_no_mem;
  assign regfile_MPORT_4_data = _mem3_wb_data_load_T ? _mem3_wb_data_load_T_5 : _mem3_wb_data_load_T_22;
  assign regfile_MPORT_4_addr = mem3_reg_wb_addr[4:0];
  assign regfile_MPORT_4_mask = 1'h1;
  assign regfile_MPORT_4_en = mem3_reg_is_valid_load;
  assign scoreboard_rrd_stall_MPORT_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_addr = rrd_reg_rs1_addr;
  assign scoreboard_rrd_stall_MPORT_data = scoreboard[scoreboard_rrd_stall_MPORT_addr]; // @[Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_1_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_1_addr = rrd_reg_rs2_addr;
  assign scoreboard_rrd_stall_MPORT_1_data = scoreboard[scoreboard_rrd_stall_MPORT_1_addr]; // @[Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_2_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_2_addr = rrd_reg_rs3_addr;
  assign scoreboard_rrd_stall_MPORT_2_data = scoreboard[scoreboard_rrd_stall_MPORT_2_addr]; // @[Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_3_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_3_addr = rrd_reg_wb_addr;
  assign scoreboard_rrd_stall_MPORT_3_data = scoreboard[scoreboard_rrd_stall_MPORT_3_addr]; // @[Core.scala 149:25]
  assign scoreboard_MPORT_data = _T_51 & _T_52;
  assign scoreboard_MPORT_addr = rrd_reg_wb_addr;
  assign scoreboard_MPORT_mask = 1'h1;
  assign scoreboard_MPORT_en = _T_48 & _rrd_hazard_T_1;
  assign scoreboard_MPORT_1_data = 1'h0;
  assign scoreboard_MPORT_1_addr = ex1_reg_wb_addr;
  assign scoreboard_MPORT_1_mask = 1'h1;
  assign scoreboard_MPORT_1_en = ex1_reg_inst2_use_reg;
  assign scoreboard_MPORT_2_data = 1'h0;
  assign scoreboard_MPORT_2_addr = ex2_reg_wb_addr;
  assign scoreboard_MPORT_2_mask = 1'h1;
  assign scoreboard_MPORT_2_en = ex2_reg_inst3_use_reg & _T_67;
  assign scoreboard_MPORT_5_data = 1'h0;
  assign scoreboard_MPORT_5_addr = mem3_reg_wb_addr[4:0];
  assign scoreboard_MPORT_5_mask = 1'h1;
  assign scoreboard_MPORT_5_en = mem3_reg_mem_use_reg;
  assign io_imem_addr = if1_is_jump ? _io_imem_addr_T_1 : _GEN_175; // @[Core.scala 393:21 395:22]
  assign io_dmem_raddr = ex2_reg_alu_out; // @[Core.scala 1927:17]
  assign io_dmem_ren = mem1_reg_is_mem_load & ex2_en; // @[Core.scala 1921:49]
  assign io_dmem_waddr = ex2_reg_alu_out; // @[Core.scala 1928:17]
  assign io_dmem_wen = mem1_reg_is_mem_store & ex2_en; // @[Core.scala 1922:50]
  assign io_dmem_wstrb = mem1_reg_mem_wstrb; // @[Core.scala 1931:17]
  assign io_dmem_wdata = ex2_reg_wdata; // @[Core.scala 1932:17]
  assign io_cache_iinvalidate = mem1_reg_is_dram_fence & ex2_en; // @[Core.scala 1925:51]
  assign io_cache_raddr = ex2_reg_alu_out; // @[Core.scala 1933:18]
  assign io_cache_ren = mem1_reg_is_dram_load & ex2_en; // @[Core.scala 1923:50]
  assign io_cache_waddr = ex2_reg_alu_out; // @[Core.scala 1934:18]
  assign io_cache_wen = mem1_reg_is_dram_store & ex2_en; // @[Core.scala 1924:51]
  assign io_cache_wstrb = mem1_reg_mem_wstrb; // @[Core.scala 1937:18]
  assign io_cache_wdata = ex2_reg_wdata; // @[Core.scala 1938:18]
  assign io_pht_mem_wen = ic_pht_io_mem_wen; // @[Core.scala 391:17]
  assign io_pht_mem_raddr = ic_pht_io_mem_raddr; // @[Core.scala 391:17]
  assign io_pht_mem_waddr = ic_pht_io_mem_waddr; // @[Core.scala 391:17]
  assign io_pht_mem_wdata = ic_pht_io_mem_wdata; // @[Core.scala 391:17]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[Core.scala 151:17]
  assign io_debug_signal_ex2_reg_pc = {ex2_reg_pc,1'h0}; // @[Cat.scala 33:92]
  assign io_debug_signal_ex2_is_valid_inst = csr_is_valid_inst & ~csr_is_meintr & ~csr_is_mtintr; // @[Core.scala 1479:49]
  assign io_debug_signal_me_intr = csr_reg_is_meintr & csr_is_valid_inst; // @[Core.scala 1476:41]
  assign io_debug_signal_mt_intr = csr_reg_is_mtintr & csr_is_valid_inst; // @[Core.scala 1477:41]
  assign io_debug_signal_trap = ex2_reg_is_trap & csr_is_valid_inst & _ex2_en_T & _ex2_en_T_2; // @[Core.scala 1478:76]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value[47:0]; // @[Core.scala 2034:64]
  assign io_debug_signal_id_pc = {id_reg_pc,1'h0}; // @[Cat.scala 33:92]
  assign io_debug_signal_id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[Core.scala 656:20]
  assign io_debug_signal_mem3_rdata = mem3_reg_dmem_rdata; // @[Core.scala 2044:39]
  assign io_debug_signal_mem3_rvalid = mem3_reg_is_valid_load; // @[Core.scala 2045:39]
  assign io_debug_signal_rwaddr = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8; // @[Mux.scala 101:16]
  assign io_debug_signal_ex2_reg_is_br = ex2_reg_is_br; // @[Core.scala 2047:39]
  assign io_debug_signal_id_reg_is_bp_fail = id_reg_is_bp_fail; // @[Core.scala 2048:39]
  assign io_debug_signal_if2_reg_bp_taken = id_reg_bp_taken; // @[Core.scala 2049:39]
  assign io_debug_signal_ic_state = ic_state; // @[Core.scala 2050:51]
  assign cycle_counter_clock = clock;
  assign cycle_counter_reset = reset;
  assign mtimer_clock = clock;
  assign mtimer_reset = reset;
  assign mtimer_io_mem_raddr = io_mtimer_mem_raddr; // @[Core.scala 151:17]
  assign mtimer_io_mem_ren = io_mtimer_mem_ren; // @[Core.scala 151:17]
  assign mtimer_io_mem_waddr = io_mtimer_mem_waddr; // @[Core.scala 151:17]
  assign mtimer_io_mem_wen = io_mtimer_mem_wen; // @[Core.scala 151:17]
  assign mtimer_io_mem_wdata = io_mtimer_mem_wdata; // @[Core.scala 151:17]
  assign ic_btb_clock = clock;
  assign ic_btb_reset = reset;
  assign ic_btb_io_lu_pc = if1_is_jump ? ic_next_imem_addr : _GEN_176; // @[Core.scala 393:21 400:22]
  assign ic_btb_io_up_en = jbr_bp_en & (jbr_reg_is_cond_br_inst & jbr_reg_is_cond_br | jbr_reg_is_uncond_br); // @[Core.scala 1394:38]
  assign ic_btb_io_up_pc = ex2_reg_pc; // @[Core.scala 1395:25]
  assign ic_btb_io_up_taken_pc = jbr_reg_br_pc; // @[Core.scala 1396:25]
  assign ic_pht_io_lu_pc = if1_is_jump ? ic_next_imem_addr : _GEN_176; // @[Core.scala 393:21 400:22]
  assign ic_pht_io_up_en = jbr_bp_en & (jbr_reg_is_cond_br_inst | jbr_reg_is_uncond_br); // @[Core.scala 1397:38]
  assign ic_pht_io_up_pc = ex2_reg_pc; // @[Core.scala 1398:25]
  assign ic_pht_io_up_cnt = jbr_reg_is_cond_br | jbr_reg_is_uncond_br ? _ic_pht_io_up_cnt_T_6 : _ic_pht_io_up_cnt_T_12; // @[Core.scala 1399:31]
  assign ic_pht_io_mem_rdata = io_pht_mem_rdata; // @[Core.scala 391:17]
  always @(posedge clock) begin
    if (regfile_MPORT_3_en & regfile_MPORT_3_mask) begin
      regfile[regfile_MPORT_3_addr] <= regfile_MPORT_3_data; // @[Core.scala 133:20]
    end
    if (regfile_MPORT_4_en & regfile_MPORT_4_mask) begin
      regfile[regfile_MPORT_4_addr] <= regfile_MPORT_4_data; // @[Core.scala 133:20]
    end
    if (scoreboard_MPORT_en & scoreboard_MPORT_mask) begin
      scoreboard[scoreboard_MPORT_addr] <= scoreboard_MPORT_data; // @[Core.scala 149:25]
    end
    if (scoreboard_MPORT_1_en & scoreboard_MPORT_1_mask) begin
      scoreboard[scoreboard_MPORT_1_addr] <= scoreboard_MPORT_1_data; // @[Core.scala 149:25]
    end
    if (scoreboard_MPORT_2_en & scoreboard_MPORT_2_mask) begin
      scoreboard[scoreboard_MPORT_2_addr] <= scoreboard_MPORT_2_data; // @[Core.scala 149:25]
    end
    if (scoreboard_MPORT_5_en & scoreboard_MPORT_5_mask) begin
      scoreboard[scoreboard_MPORT_5_addr] <= scoreboard_MPORT_5_data; // @[Core.scala 149:25]
    end
    if (reset) begin // @[Core.scala 138:24]
      instret <= 64'h0; // @[Core.scala 138:24]
    end else if (ex2_reg_is_retired & mem3_reg_is_retired) begin // @[Core.scala 2021:52]
      instret <= _instret_T_1; // @[Core.scala 2022:13]
    end else if (ex2_reg_is_retired | mem3_reg_is_retired) begin // @[Core.scala 2023:58]
      instret <= _instret_T_3; // @[Core.scala 2024:13]
    end
    if (reset) begin // @[Core.scala 139:37]
      csr_reg_trap_vector <= 31'h0; // @[Core.scala 139:37]
    end else if (_csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5) begin // @[Core.scala 1506:54]
      if (ex2_reg_csr_addr == 12'h305) begin // @[Core.scala 1507:48]
        csr_reg_trap_vector <= csr_wdata[31:1]; // @[Core.scala 1508:27]
      end
    end
    if (reset) begin // @[Core.scala 140:37]
      csr_reg_mcause <= 32'h0; // @[Core.scala 140:37]
    end else if (csr_is_meintr) begin // @[Core.scala 1529:24]
      csr_reg_mcause <= 32'h8000000b; // @[Core.scala 1530:26]
    end else if (csr_is_mtintr) begin // @[Core.scala 1539:30]
      csr_reg_mcause <= 32'h80000007; // @[Core.scala 1540:26]
    end else if (csr_is_trap) begin // @[Core.scala 1549:28]
      csr_reg_mcause <= ex2_reg_mcause; // @[Core.scala 1550:26]
    end
    if (reset) begin // @[Core.scala 142:37]
      csr_reg_mepc <= 31'h0; // @[Core.scala 142:37]
    end else if (csr_is_meintr) begin // @[Core.scala 1529:24]
      csr_reg_mepc <= ex2_reg_pc; // @[Core.scala 1532:26]
    end else if (csr_is_mtintr) begin // @[Core.scala 1539:30]
      csr_reg_mepc <= ex2_reg_pc; // @[Core.scala 1542:26]
    end else if (csr_is_trap) begin // @[Core.scala 1549:28]
      csr_reg_mepc <= ex2_reg_pc; // @[Core.scala 1552:26]
    end else begin
      csr_reg_mepc <= _GEN_489;
    end
    if (reset) begin // @[Core.scala 143:37]
      csr_reg_mstatus_mie <= 1'h0; // @[Core.scala 143:37]
    end else if (csr_is_meintr) begin // @[Core.scala 1529:24]
      csr_reg_mstatus_mie <= 1'h0; // @[Core.scala 1534:26]
    end else if (csr_is_mtintr) begin // @[Core.scala 1539:30]
      csr_reg_mstatus_mie <= 1'h0; // @[Core.scala 1544:26]
    end else if (csr_is_trap) begin // @[Core.scala 1549:28]
      csr_reg_mstatus_mie <= 1'h0; // @[Core.scala 1554:26]
    end else begin
      csr_reg_mstatus_mie <= _GEN_501;
    end
    if (reset) begin // @[Core.scala 144:37]
      csr_reg_mstatus_mpie <= 1'h0; // @[Core.scala 144:37]
    end else if (csr_is_meintr) begin // @[Core.scala 1529:24]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[Core.scala 1533:26]
    end else if (csr_is_mtintr) begin // @[Core.scala 1539:30]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[Core.scala 1543:26]
    end else if (csr_is_trap) begin // @[Core.scala 1549:28]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[Core.scala 1553:26]
    end else begin
      csr_reg_mstatus_mpie <= _GEN_500;
    end
    if (reset) begin // @[Core.scala 145:37]
      csr_reg_mscratch <= 32'h0; // @[Core.scala 145:37]
    end else if (_csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5) begin // @[Core.scala 1506:54]
      if (!(ex2_reg_csr_addr == 12'h305)) begin // @[Core.scala 1507:48]
        if (!(ex2_reg_csr_addr == 12'h341)) begin // @[Core.scala 1509:53]
          csr_reg_mscratch <= _GEN_459;
        end
      end
    end
    if (reset) begin // @[Core.scala 146:37]
      csr_reg_mie_meie <= 1'h0; // @[Core.scala 146:37]
    end else if (_csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5) begin // @[Core.scala 1506:54]
      if (!(ex2_reg_csr_addr == 12'h305)) begin // @[Core.scala 1507:48]
        if (!(ex2_reg_csr_addr == 12'h341)) begin // @[Core.scala 1509:53]
          csr_reg_mie_meie <= _GEN_460;
        end
      end
    end
    if (reset) begin // @[Core.scala 147:37]
      csr_reg_mie_mtie <= 1'h0; // @[Core.scala 147:37]
    end else if (_csr_is_valid_inst_T & ex2_reg_wb_sel == 3'h5) begin // @[Core.scala 1506:54]
      if (!(ex2_reg_csr_addr == 12'h305)) begin // @[Core.scala 1507:48]
        if (!(ex2_reg_csr_addr == 12'h341)) begin // @[Core.scala 1509:53]
          csr_reg_mie_mtie <= _GEN_461;
        end
      end
    end
    if (reset) begin // @[Core.scala 157:38]
      id_reg_stall <= 1'h0; // @[Core.scala 157:38]
    end else begin
      id_reg_stall <= id_stall; // @[Core.scala 653:16]
    end
    if (reset) begin // @[Core.scala 164:38]
      rrd_reg_pc <= 31'h0; // @[Core.scala 164:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_pc <= _GEN_266;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_pc <= _GEN_266;
    end
    if (reset) begin // @[Core.scala 165:38]
      rrd_reg_wb_addr <= 5'h0; // @[Core.scala 165:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_wb_addr <= _GEN_275;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_wb_addr <= _GEN_275;
    end
    if (reset) begin // @[Core.scala 166:38]
      rrd_reg_op1_sel <= 1'h0; // @[Core.scala 166:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_op1_sel <= _GEN_267;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_op1_sel <= _GEN_267;
    end
    if (reset) begin // @[Core.scala 167:38]
      rrd_reg_op2_sel <= 1'h0; // @[Core.scala 167:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_op2_sel <= _GEN_268;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_op2_sel <= _GEN_268;
    end
    if (reset) begin // @[Core.scala 168:38]
      rrd_reg_op3_sel <= 2'h0; // @[Core.scala 168:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_op3_sel <= _GEN_269;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_op3_sel <= _GEN_269;
    end
    if (reset) begin // @[Core.scala 169:38]
      rrd_reg_rs1_addr <= 5'h0; // @[Core.scala 169:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_rs1_addr <= _GEN_270;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_rs1_addr <= _GEN_270;
    end
    if (reset) begin // @[Core.scala 170:38]
      rrd_reg_rs2_addr <= 5'h0; // @[Core.scala 170:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_rs2_addr <= _GEN_271;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_rs2_addr <= _GEN_271;
    end
    if (reset) begin // @[Core.scala 171:38]
      rrd_reg_rs3_addr <= 5'h0; // @[Core.scala 171:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_rs3_addr <= _GEN_272;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_rs3_addr <= _GEN_272;
    end
    if (reset) begin // @[Core.scala 172:38]
      rrd_reg_op1_data <= 32'h0; // @[Core.scala 172:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_op1_data <= _GEN_273;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_op1_data <= _GEN_273;
    end
    rrd_reg_op2_data <= _GEN_622[31:0]; // @[Core.scala 173:{38,38}]
    if (reset) begin // @[Core.scala 174:38]
      rrd_reg_exe_fun <= 5'h0; // @[Core.scala 174:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_exe_fun <= 5'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_exe_fun <= id_reg_exe_fun_delay; // @[Core.scala 1102:29]
      end else begin
        rrd_reg_exe_fun <= csignals_0; // @[Core.scala 1134:29]
      end
    end
    if (reset) begin // @[Core.scala 175:38]
      rrd_reg_rf_wen <= 1'h0; // @[Core.scala 175:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_rf_wen <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_rf_wen <= id_reg_rf_wen_delay; // @[Core.scala 1101:29]
      end else begin
        rrd_reg_rf_wen <= csignals_4; // @[Core.scala 1133:29]
      end
    end
    if (reset) begin // @[Core.scala 176:38]
      rrd_reg_wb_sel <= 3'h0; // @[Core.scala 176:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_wb_sel <= 3'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_wb_sel <= id_reg_wb_sel_delay; // @[Core.scala 1103:29]
      end else begin
        rrd_reg_wb_sel <= csignals_5; // @[Core.scala 1135:29]
      end
    end
    if (reset) begin // @[Core.scala 177:38]
      rrd_reg_csr_addr <= 12'h0; // @[Core.scala 177:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_csr_addr <= _GEN_280;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_csr_addr <= _GEN_280;
    end
    if (reset) begin // @[Core.scala 178:38]
      rrd_reg_csr_cmd <= 2'h0; // @[Core.scala 178:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_csr_cmd <= 2'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[Core.scala 1106:29]
      end else begin
        rrd_reg_csr_cmd <= csignals_7; // @[Core.scala 1138:29]
      end
    end
    if (reset) begin // @[Core.scala 179:38]
      rrd_reg_imm_b_sext <= 32'h0; // @[Core.scala 179:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_imm_b_sext <= _GEN_279;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_imm_b_sext <= _GEN_279;
    end
    if (reset) begin // @[Core.scala 180:38]
      rrd_reg_mem_w <= 3'h0; // @[Core.scala 180:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_mem_w <= 3'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_mem_w <= id_reg_mem_w_delay; // @[Core.scala 1107:29]
      end else begin
        rrd_reg_mem_w <= csignals_8; // @[Core.scala 1139:29]
      end
    end
    if (reset) begin // @[Core.scala 182:38]
      rrd_reg_is_br <= 1'h0; // @[Core.scala 182:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_is_br <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_is_br <= id_reg_is_br_delay; // @[Core.scala 1109:29]
      end else begin
        rrd_reg_is_br <= id_is_br; // @[Core.scala 1141:29]
      end
    end
    if (reset) begin // @[Core.scala 183:38]
      rrd_reg_is_j <= 1'h0; // @[Core.scala 183:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_is_j <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_is_j <= id_reg_is_j_delay; // @[Core.scala 1110:29]
      end else begin
        rrd_reg_is_j <= id_is_j; // @[Core.scala 1142:29]
      end
    end
    if (reset) begin // @[Core.scala 184:38]
      rrd_reg_bp_taken <= 1'h0; // @[Core.scala 184:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_bp_taken <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_bp_taken <= id_reg_bp_taken_delay; // @[Core.scala 1111:29]
      end else begin
        rrd_reg_bp_taken <= id_reg_bp_taken; // @[Core.scala 1143:29]
      end
    end
    if (reset) begin // @[Core.scala 185:38]
      rrd_reg_bp_taken_pc <= 31'h0; // @[Core.scala 185:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_bp_taken_pc <= _GEN_282;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_bp_taken_pc <= _GEN_282;
    end
    if (reset) begin // @[Core.scala 186:38]
      rrd_reg_bp_cnt <= 2'h0; // @[Core.scala 186:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_bp_cnt <= _GEN_283;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_bp_cnt <= _GEN_283;
    end
    if (reset) begin // @[Core.scala 187:38]
      rrd_reg_is_half <= 1'h0; // @[Core.scala 187:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_is_half <= _GEN_284;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_is_half <= _GEN_284;
    end
    if (reset) begin // @[Core.scala 188:38]
      rrd_reg_is_valid_inst <= 1'h0; // @[Core.scala 188:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_is_valid_inst <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[Core.scala 1115:29]
      end else begin
        rrd_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[Core.scala 1147:29]
      end
    end
    if (reset) begin // @[Core.scala 189:38]
      rrd_reg_is_trap <= 1'h0; // @[Core.scala 189:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_is_trap <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      if (id_reg_stall) begin // @[Core.scala 1090:24]
        rrd_reg_is_trap <= id_reg_is_trap_delay; // @[Core.scala 1116:29]
      end else begin
        rrd_reg_is_trap <= _id_csr_addr_T; // @[Core.scala 1148:29]
      end
    end
    if (reset) begin // @[Core.scala 190:38]
      rrd_reg_mcause <= 32'h0; // @[Core.scala 190:38]
    end else if (ex2_reg_is_br) begin // @[Core.scala 1023:24]
      rrd_reg_mcause <= _GEN_285;
    end else if (~rrd_stall & ~ex2_stall) begin // @[Core.scala 1089:40]
      rrd_reg_mcause <= _GEN_285;
    end
    if (reset) begin // @[Core.scala 194:38]
      ex1_reg_pc <= 31'h0; // @[Core.scala 194:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_pc <= rrd_reg_pc; // @[Core.scala 1224:27]
    end
    if (reset) begin // @[Core.scala 195:38]
      ex1_reg_wb_addr <= 5'h0; // @[Core.scala 195:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_wb_addr <= rrd_reg_wb_addr; // @[Core.scala 1228:27]
    end
    if (reset) begin // @[Core.scala 196:38]
      ex1_reg_op1_data <= 32'h0; // @[Core.scala 196:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (_rrd_op1_data_T_2) begin // @[Mux.scala 101:16]
        ex1_reg_op1_data <= 32'h0;
      end else if (_rrd_op1_data_T_6) begin // @[Mux.scala 101:16]
        ex1_reg_op1_data <= ex1_fw_data;
      end else begin
        ex1_reg_op1_data <= _rrd_op1_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 197:38]
      ex1_reg_op2_data <= 32'h0; // @[Core.scala 197:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (_rrd_op2_data_T_2) begin // @[Mux.scala 101:16]
        ex1_reg_op2_data <= 32'h0;
      end else if (_rrd_op2_data_T_6) begin // @[Mux.scala 101:16]
        ex1_reg_op2_data <= ex1_fw_data;
      end else begin
        ex1_reg_op2_data <= _rrd_op2_data_T_13;
      end
    end
    if (reset) begin // @[Core.scala 198:38]
      ex1_reg_op3_data <= 32'h0; // @[Core.scala 198:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (_rrd_op3_data_T) begin // @[Mux.scala 101:16]
        ex1_reg_op3_data <= 32'h0;
      end else if (_rrd_op3_data_T_1) begin // @[Mux.scala 101:16]
        ex1_reg_op3_data <= _rrd_op3_data_T_4;
      end else begin
        ex1_reg_op3_data <= _rrd_op3_data_T_14;
      end
    end
    if (reset) begin // @[Core.scala 199:38]
      ex1_reg_exe_fun <= 5'h0; // @[Core.scala 199:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (ex_is_bubble) begin // @[Core.scala 1230:33]
        ex1_reg_exe_fun <= 5'h0;
      end else begin
        ex1_reg_exe_fun <= rrd_reg_exe_fun;
      end
    end
    if (reset) begin // @[Core.scala 200:38]
      ex1_reg_rf_wen <= 1'h0; // @[Core.scala 200:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (ex_is_bubble) begin // @[Core.scala 1229:33]
        ex1_reg_rf_wen <= 1'h0;
      end else begin
        ex1_reg_rf_wen <= rrd_reg_rf_wen;
      end
    end
    if (reset) begin // @[Core.scala 201:38]
      ex1_reg_wb_sel <= 3'h0; // @[Core.scala 201:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (ex_is_bubble) begin // @[Core.scala 1231:33]
        ex1_reg_wb_sel <= 3'h0;
      end else begin
        ex1_reg_wb_sel <= rrd_reg_wb_sel;
      end
    end
    if (reset) begin // @[Core.scala 202:38]
      ex1_reg_csr_addr <= 12'h0; // @[Core.scala 202:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_csr_addr <= rrd_reg_csr_addr; // @[Core.scala 1233:27]
    end
    if (reset) begin // @[Core.scala 203:38]
      ex1_reg_csr_cmd <= 2'h0; // @[Core.scala 203:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (ex_is_bubble) begin // @[Core.scala 1234:33]
        ex1_reg_csr_cmd <= 2'h0;
      end else begin
        ex1_reg_csr_cmd <= rrd_reg_csr_cmd;
      end
    end
    if (reset) begin // @[Core.scala 204:38]
      ex1_reg_mem_w <= 3'h0; // @[Core.scala 204:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_mem_w <= rrd_reg_mem_w; // @[Core.scala 1235:27]
    end
    if (reset) begin // @[Core.scala 205:38]
      ex1_is_uncond_br <= 1'h0; // @[Core.scala 205:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_is_uncond_br <= rrd_reg_is_j; // @[Core.scala 1237:27]
    end
    if (reset) begin // @[Core.scala 206:38]
      ex1_reg_bp_taken <= 1'h0; // @[Core.scala 206:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_bp_taken <= rrd_reg_bp_taken; // @[Core.scala 1238:27]
    end
    if (reset) begin // @[Core.scala 207:38]
      ex1_reg_bp_taken_pc <= 31'h0; // @[Core.scala 207:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_bp_taken_pc <= rrd_reg_bp_taken_pc; // @[Core.scala 1239:27]
    end
    if (reset) begin // @[Core.scala 208:38]
      ex1_reg_bp_cnt <= 2'h0; // @[Core.scala 208:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_bp_cnt <= rrd_reg_bp_cnt; // @[Core.scala 1240:27]
    end
    if (reset) begin // @[Core.scala 209:38]
      ex1_reg_is_half <= 1'h0; // @[Core.scala 209:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_is_half <= rrd_reg_is_half; // @[Core.scala 1241:27]
    end
    if (reset) begin // @[Core.scala 210:38]
      ex1_reg_is_valid_inst <= 1'h0; // @[Core.scala 210:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_is_valid_inst <= rrd_reg_is_valid_inst & ~ex_is_bubble; // @[Core.scala 1242:27]
    end
    if (reset) begin // @[Core.scala 211:38]
      ex1_reg_is_trap <= 1'h0; // @[Core.scala 211:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      if (ex_is_bubble) begin // @[Core.scala 1243:33]
        ex1_reg_is_trap <= 1'h0;
      end else begin
        ex1_reg_is_trap <= rrd_reg_is_trap;
      end
    end
    if (reset) begin // @[Core.scala 212:38]
      ex1_reg_mcause <= 32'h0; // @[Core.scala 212:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_mcause <= rrd_reg_mcause; // @[Core.scala 1244:27]
    end
    if (reset) begin // @[Core.scala 214:38]
      ex1_reg_mem_use_reg <= 1'h0; // @[Core.scala 214:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_mem_use_reg <= rrd_mem_use_reg; // @[Core.scala 1246:27]
    end
    if (reset) begin // @[Core.scala 215:38]
      ex1_reg_inst2_use_reg <= 1'h0; // @[Core.scala 215:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_inst2_use_reg <= rrd_inst2_use_reg; // @[Core.scala 1247:27]
    end
    if (reset) begin // @[Core.scala 216:38]
      ex1_reg_inst3_use_reg <= 1'h0; // @[Core.scala 216:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_inst3_use_reg <= rrd_inst3_use_reg; // @[Core.scala 1248:27]
    end
    if (reset) begin // @[Core.scala 217:38]
      ex1_is_cond_br_inst <= 1'h0; // @[Core.scala 217:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_is_cond_br_inst <= rrd_reg_is_br; // @[Core.scala 1236:27]
    end
    if (reset) begin // @[Core.scala 218:38]
      ex1_reg_direct_jbr_pc <= 31'h0; // @[Core.scala 218:38]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_direct_jbr_pc <= rrd_direct_jbr_pc; // @[Core.scala 1232:27]
    end
    if (reset) begin // @[Core.scala 221:41]
      jbr_reg_bp_en <= 1'h0; // @[Core.scala 221:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_bp_en <= ex1_reg_is_valid_inst & _csr_is_valid_inst_T; // @[Core.scala 1363:30]
    end
    if (reset) begin // @[Core.scala 222:41]
      jbr_reg_is_cond_br <= 1'h0; // @[Core.scala 222:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      if (_ex1_is_cond_br_T) begin // @[Mux.scala 101:16]
        jbr_reg_is_cond_br <= _ex1_is_cond_br_T_1;
      end else if (_ex1_is_cond_br_T_2) begin // @[Mux.scala 101:16]
        jbr_reg_is_cond_br <= _ex1_is_cond_br_T_4;
      end else begin
        jbr_reg_is_cond_br <= _ex1_is_cond_br_T_22;
      end
    end
    if (reset) begin // @[Core.scala 223:41]
      jbr_reg_is_cond_br_inst <= 1'h0; // @[Core.scala 223:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_is_cond_br_inst <= ex1_is_cond_br_inst; // @[Core.scala 1365:30]
    end
    if (reset) begin // @[Core.scala 224:41]
      jbr_reg_is_uncond_br <= 1'h0; // @[Core.scala 224:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_is_uncond_br <= ex1_is_uncond_br; // @[Core.scala 1366:30]
    end
    if (reset) begin // @[Core.scala 225:41]
      jbr_reg_br_pc <= 31'h0; // @[Core.scala 225:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      if (ex1_is_cond_br_inst) begin // @[Core.scala 1341:32]
        jbr_reg_br_pc <= ex1_reg_direct_jbr_pc;
      end else begin
        jbr_reg_br_pc <= ex1_add_out[31:1];
      end
    end
    if (reset) begin // @[Core.scala 226:41]
      jbr_reg_bp_taken <= 1'h0; // @[Core.scala 226:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_bp_taken <= ex1_reg_bp_taken; // @[Core.scala 1368:30]
    end
    if (reset) begin // @[Core.scala 227:41]
      jbr_reg_bp_taken_pc <= 31'h0; // @[Core.scala 227:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_bp_taken_pc <= ex1_reg_bp_taken_pc; // @[Core.scala 1369:30]
    end
    if (reset) begin // @[Core.scala 228:41]
      jbr_reg_bp_cnt <= 2'h0; // @[Core.scala 228:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_bp_cnt <= ex1_reg_bp_cnt; // @[Core.scala 1370:30]
    end
    if (reset) begin // @[Core.scala 229:41]
      jbr_reg_is_half <= 1'h0; // @[Core.scala 229:41]
    end else if (_T_40) begin // @[Core.scala 1362:21]
      jbr_reg_is_half <= ex1_reg_is_half; // @[Core.scala 1371:30]
    end
    if (reset) begin // @[Core.scala 232:38]
      ex2_reg_pc <= 31'h0; // @[Core.scala 232:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_pc <= ex1_reg_pc; // @[Core.scala 1407:24]
    end
    if (reset) begin // @[Core.scala 233:38]
      ex2_reg_wb_addr <= 5'h0; // @[Core.scala 233:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[Core.scala 1409:24]
    end
    if (reset) begin // @[Core.scala 234:38]
      ex2_reg_op1_data <= 32'h0; // @[Core.scala 234:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_op1_data <= ex1_reg_op1_data; // @[Core.scala 1408:24]
    end
    if (reset) begin // @[Core.scala 235:38]
      ex2_reg_mullu <= 48'h0; // @[Core.scala 235:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mullu <= ex1_mullu; // @[Core.scala 1411:24]
    end
    if (reset) begin // @[Core.scala 236:38]
      ex2_reg_mulls <= 32'h0; // @[Core.scala 236:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mulls <= ex1_mulls; // @[Core.scala 1412:24]
    end
    if (reset) begin // @[Core.scala 237:38]
      ex2_reg_mulhuu <= 48'h0; // @[Core.scala 237:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mulhuu <= ex1_mulhuu; // @[Core.scala 1413:24]
    end
    if (reset) begin // @[Core.scala 238:38]
      ex2_reg_mulhss <= 48'sh0; // @[Core.scala 238:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mulhss <= ex1_mulhss; // @[Core.scala 1414:24]
    end
    if (reset) begin // @[Core.scala 239:38]
      ex2_reg_mulhsu <= 48'sh0; // @[Core.scala 239:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mulhsu <= ex1_mulhsu; // @[Core.scala 1415:24]
    end
    if (reset) begin // @[Core.scala 240:38]
      ex2_reg_exe_fun <= 5'h0; // @[Core.scala 240:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_exe_fun <= ex1_reg_exe_fun; // @[Core.scala 1417:24]
    end
    if (reset) begin // @[Core.scala 241:38]
      ex2_reg_rf_wen <= 1'h0; // @[Core.scala 241:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_rf_wen <= ex1_reg_rf_wen; // @[Core.scala 1418:24]
    end
    if (reset) begin // @[Core.scala 242:38]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 242:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall & ex2_reg_no_mem) begin // @[Core.scala 1446:66]
      ex2_reg_wb_sel <= 3'h0; // @[Core.scala 1448:27]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_wb_sel <= ex1_reg_wb_sel; // @[Core.scala 1419:24]
    end
    if (reset) begin // @[Core.scala 243:38]
      ex2_reg_csr_addr <= 12'h0; // @[Core.scala 243:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_csr_addr <= ex1_reg_csr_addr; // @[Core.scala 1438:31]
    end
    if (reset) begin // @[Core.scala 244:38]
      ex2_reg_csr_cmd <= 2'h0; // @[Core.scala 244:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_csr_cmd <= ex1_reg_csr_cmd; // @[Core.scala 1437:31]
    end
    if (reset) begin // @[Core.scala 245:38]
      ex2_reg_alu_out <= 32'h0; // @[Core.scala 245:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      if (_ex1_alu_out_T) begin // @[Mux.scala 101:16]
        ex2_reg_alu_out <= ex1_add_out;
      end else if (_ex1_alu_out_T_1) begin // @[Mux.scala 101:16]
        ex2_reg_alu_out <= _ex1_alu_out_T_3;
      end else begin
        ex2_reg_alu_out <= _ex1_alu_out_T_51;
      end
    end
    if (reset) begin // @[Core.scala 246:38]
      ex2_reg_pc_bit_out <= 32'h0; // @[Core.scala 246:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      if (_ex1_fw_data_T) begin // @[Mux.scala 101:16]
        ex2_reg_pc_bit_out <= _ex1_fw_data_T_1;
      end else if (_ex1_alu_out_T_35) begin // @[Mux.scala 101:16]
        ex2_reg_pc_bit_out <= _ex1_pc_bit_out_T_4;
      end else begin
        ex2_reg_pc_bit_out <= _ex1_pc_bit_out_T_326;
      end
    end
    if (reset) begin // @[Core.scala 247:38]
      ex2_reg_wdata <= 32'h0; // @[Core.scala 247:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_wdata <= _ex2_reg_wdata_T_2[31:0]; // @[Core.scala 1421:24]
    end
    if (reset) begin // @[Core.scala 248:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 248:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall & ex2_reg_no_mem) begin // @[Core.scala 1446:66]
      ex2_reg_is_valid_inst <= 1'h0; // @[Core.scala 1449:27]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_is_valid_inst <= _jbr_reg_bp_en_T_1; // @[Core.scala 1422:27]
    end
    if (reset) begin // @[Core.scala 249:38]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 249:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall & ex2_reg_no_mem) begin // @[Core.scala 1446:66]
      ex2_reg_is_trap <= 1'h0; // @[Core.scala 1450:27]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_is_trap <= ex1_reg_is_trap; // @[Core.scala 1423:24]
    end
    if (reset) begin // @[Core.scala 250:38]
      ex2_reg_mcause <= 32'h0; // @[Core.scala 250:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_mcause <= ex1_reg_mcause; // @[Core.scala 1424:24]
    end
    if (reset) begin // @[Core.scala 254:38]
      ex2_reg_divrem <= 1'h0; // @[Core.scala 254:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_divrem <= ex1_divrem; // @[Core.scala 1426:31]
    end
    if (reset) begin // @[Core.scala 255:38]
      ex2_reg_sign_op1 <= 1'h0; // @[Core.scala 255:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_sign_op1 <= ex1_sign_op1; // @[Core.scala 1429:31]
    end
    if (reset) begin // @[Core.scala 256:38]
      ex2_reg_sign_op12 <= 1'h0; // @[Core.scala 256:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_sign_op12 <= ex1_sign_op12; // @[Core.scala 1430:31]
    end
    if (reset) begin // @[Core.scala 257:38]
      ex2_reg_zero_op2 <= 1'h0; // @[Core.scala 257:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_zero_op2 <= ex1_zero_op2; // @[Core.scala 1431:31]
    end
    if (reset) begin // @[Core.scala 258:38]
      ex2_reg_init_dividend <= 37'h0; // @[Core.scala 258:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      if (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) begin // @[Core.scala 1305:69]
        if (ex1_reg_op1_data[31]) begin // @[Core.scala 1307:49]
          ex2_reg_init_dividend <= _ex1_dividend_T_5; // @[Core.scala 1308:20]
        end else begin
          ex2_reg_init_dividend <= _ex1_dividend_T_8; // @[Core.scala 1310:20]
        end
      end else if (_ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38) begin // @[Core.scala 1320:77]
        ex2_reg_init_dividend <= _ex1_dividend_T_8; // @[Core.scala 1322:18]
      end else begin
        ex2_reg_init_dividend <= 37'h0; // @[Core.scala 1301:33]
      end
    end
    if (reset) begin // @[Core.scala 259:38]
      ex2_reg_init_divisor <= 32'h0; // @[Core.scala 259:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      if (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) begin // @[Core.scala 1305:69]
        if (ex1_reg_op2_data[31]) begin // @[Core.scala 1313:49]
          ex2_reg_init_divisor <= _ex1_divisor_T_2; // @[Core.scala 1314:19]
        end else begin
          ex2_reg_init_divisor <= ex1_reg_op2_data; // @[Core.scala 1317:19]
        end
      end else if (_ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38) begin // @[Core.scala 1320:77]
        ex2_reg_init_divisor <= ex1_reg_op2_data; // @[Core.scala 1324:17]
      end else begin
        ex2_reg_init_divisor <= 32'h0; // @[Core.scala 1302:32]
      end
    end
    if (reset) begin // @[Core.scala 260:38]
      ex2_reg_orig_dividend <= 32'h0; // @[Core.scala 260:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_orig_dividend <= ex1_reg_op1_data; // @[Core.scala 1434:31]
    end
    if (reset) begin // @[Core.scala 261:38]
      ex2_reg_inst3_use_reg <= 1'h0; // @[Core.scala 261:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall & ex2_reg_no_mem) begin // @[Core.scala 1446:66]
      ex2_reg_inst3_use_reg <= 1'h0; // @[Core.scala 1451:27]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_inst3_use_reg <= ex1_reg_inst3_use_reg; // @[Core.scala 1435:31]
    end
    if (reset) begin // @[Core.scala 262:38]
      ex2_reg_no_mem <= 1'h0; // @[Core.scala 262:38]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_no_mem <= _ex1_fw_en_next_T_2 & ex1_reg_wb_sel != 3'h2 & ex1_reg_wb_sel != 3'h3; // @[Core.scala 1420:24]
    end
    if (reset) begin // @[Core.scala 265:39]
      mem1_reg_mem_wstrb <= 4'h0; // @[Core.scala 265:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_mem_wstrb <= _mem1_reg_mem_wstrb_T_5[3:0]; // @[Core.scala 1898:28]
    end
    if (reset) begin // @[Core.scala 266:39]
      mem1_reg_mem_w <= 3'h0; // @[Core.scala 266:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_mem_w <= ex1_reg_mem_w; // @[Core.scala 1903:28]
    end
    if (reset) begin // @[Core.scala 267:39]
      mem1_reg_mem_use_reg <= 1'h0; // @[Core.scala 267:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_mem_use_reg <= ex1_reg_mem_use_reg; // @[Core.scala 1904:28]
    end
    if (reset) begin // @[Core.scala 269:39]
      mem1_reg_is_mem_load <= 1'h0; // @[Core.scala 269:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_mem_load <= ~mem1_is_dram & ex1_reg_wb_sel == 3'h6; // @[Core.scala 1907:28]
    end
    if (reset) begin // @[Core.scala 270:39]
      mem1_reg_is_mem_store <= 1'h0; // @[Core.scala 270:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_mem_store <= _mem1_reg_is_mem_load_T & ex1_reg_wb_sel == 3'h2; // @[Core.scala 1908:28]
    end
    if (reset) begin // @[Core.scala 271:39]
      mem1_reg_is_dram_load <= 1'h0; // @[Core.scala 271:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_dram_load <= mem1_is_dram & _mem1_reg_is_mem_load_T_1; // @[Core.scala 1909:28]
    end
    if (reset) begin // @[Core.scala 272:39]
      mem1_reg_is_dram_store <= 1'h0; // @[Core.scala 272:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_dram_store <= mem1_is_dram & _mem1_reg_is_mem_store_T_1; // @[Core.scala 1910:28]
    end
    if (reset) begin // @[Core.scala 273:39]
      mem1_reg_is_dram_fence <= 1'h0; // @[Core.scala 273:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_dram_fence <= ex1_reg_wb_sel == 3'h3; // @[Core.scala 1911:28]
    end
    if (reset) begin // @[Core.scala 274:39]
      mem1_reg_is_valid_inst <= 1'h0; // @[Core.scala 274:39]
    end else if (_T_40) begin // @[Core.scala 1897:21]
      mem1_reg_is_valid_inst <= _mem1_reg_is_mem_load_T_1 | _mem1_reg_is_mem_store_T_1 | _mem1_reg_is_dram_fence_T; // @[Core.scala 1912:28]
    end
    if (reset) begin // @[Core.scala 277:40]
      mem2_reg_wb_byte_offset <= 2'h0; // @[Core.scala 277:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_wb_byte_offset <= ex2_reg_alu_out[1:0]; // @[Core.scala 1960:29]
    end
    if (reset) begin // @[Core.scala 278:40]
      mem2_reg_mem_w <= 3'h0; // @[Core.scala 278:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_mem_w <= mem1_reg_mem_w; // @[Core.scala 1961:29]
    end
    if (reset) begin // @[Core.scala 279:40]
      mem2_reg_dmem_rdata <= 32'h0; // @[Core.scala 279:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_dmem_rdata <= io_dmem_rdata; // @[Core.scala 1962:29]
    end
    if (reset) begin // @[Core.scala 280:40]
      mem2_reg_wb_addr <= 32'h0; // @[Core.scala 280:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_wb_addr <= {{27'd0}, ex2_reg_wb_addr}; // @[Core.scala 1963:29]
    end
    if (reset) begin // @[Core.scala 281:40]
      mem2_reg_is_valid_load <= 1'h0; // @[Core.scala 281:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_is_valid_load <= _mem1_mem_stall_delay_T_1 & mem1_is_mem_load | ~mem1_dram_stall & mem1_is_dram_load; // @[Core.scala 1964:29]
    end
    if (reset) begin // @[Core.scala 282:40]
      mem2_reg_mem_use_reg <= 1'h0; // @[Core.scala 282:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_mem_use_reg <= _mem1_mem_stall_delay_T_1 & _mem2_reg_is_valid_load_T_2 & mem1_reg_mem_use_reg; // @[Core.scala 1965:29]
    end
    if (reset) begin // @[Core.scala 283:40]
      mem2_reg_is_valid_inst <= 1'h0; // @[Core.scala 283:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_is_valid_inst <= _mem2_reg_mem_use_reg_T_2 & mem1_is_valid_inst; // @[Core.scala 1966:29]
    end
    if (reset) begin // @[Core.scala 284:40]
      mem2_reg_is_dram_load <= 1'h0; // @[Core.scala 284:40]
    end else if (~mem2_dram_stall) begin // @[Core.scala 1959:27]
      mem2_reg_is_dram_load <= _mem2_reg_is_valid_load_T_3; // @[Core.scala 1967:29]
    end
    if (reset) begin // @[Core.scala 287:40]
      mem3_reg_wb_byte_offset <= 2'h0; // @[Core.scala 287:40]
    end else begin
      mem3_reg_wb_byte_offset <= mem2_reg_wb_byte_offset; // @[Core.scala 1984:27]
    end
    if (reset) begin // @[Core.scala 288:40]
      mem3_reg_mem_w <= 3'h0; // @[Core.scala 288:40]
    end else begin
      mem3_reg_mem_w <= mem2_reg_mem_w; // @[Core.scala 1985:27]
    end
    if (reset) begin // @[Core.scala 289:40]
      mem3_reg_dmem_rdata <= 32'h0; // @[Core.scala 289:40]
    end else if (mem2_reg_is_dram_load) begin // @[Core.scala 1986:33]
      mem3_reg_dmem_rdata <= io_cache_rdata;
    end else begin
      mem3_reg_dmem_rdata <= mem2_reg_dmem_rdata;
    end
    if (reset) begin // @[Core.scala 290:40]
      mem3_reg_wb_addr <= 32'h0; // @[Core.scala 290:40]
    end else begin
      mem3_reg_wb_addr <= mem2_reg_wb_addr; // @[Core.scala 1987:27]
    end
    if (reset) begin // @[Core.scala 291:40]
      mem3_reg_is_valid_load <= 1'h0; // @[Core.scala 291:40]
    end else begin
      mem3_reg_is_valid_load <= _T_115 & mem2_reg_is_valid_load; // @[Core.scala 1988:27]
    end
    if (reset) begin // @[Core.scala 292:40]
      mem3_reg_is_valid_inst <= 1'h0; // @[Core.scala 292:40]
    end else begin
      mem3_reg_is_valid_inst <= _T_115 & mem2_reg_is_valid_inst; // @[Core.scala 1990:27]
    end
    if (reset) begin // @[Core.scala 293:40]
      mem3_reg_mem_use_reg <= 1'h0; // @[Core.scala 293:40]
    end else begin
      mem3_reg_mem_use_reg <= _T_115 & mem2_reg_mem_use_reg; // @[Core.scala 1989:27]
    end
    if (reset) begin // @[Core.scala 295:37]
      id_reg_bp_taken <= 1'h0; // @[Core.scala 295:37]
    end else if (ex2_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_bp_taken <= 1'h0;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_is_bp_fail) begin // @[Mux.scala 101:16]
        id_reg_bp_taken <= 1'h0;
      end else begin
        id_reg_bp_taken <= _if2_bp_taken_T_3;
      end
    end
    if (reset) begin // @[Core.scala 296:37]
      id_reg_bp_taken_pc <= 31'h0; // @[Core.scala 296:37]
    end else if (!(id_reg_stall)) begin // @[Core.scala 614:28]
      if (if1_is_jump) begin // @[Core.scala 393:21]
        id_reg_bp_taken_pc <= 31'h0; // @[Core.scala 389:19]
      end else if (~io_imem_valid) begin // @[Core.scala 402:98]
        id_reg_bp_taken_pc <= _GEN_34;
      end else begin
        id_reg_bp_taken_pc <= _GEN_34;
      end
    end
    if (reset) begin // @[Core.scala 297:37]
      id_reg_bp_cnt <= 2'h0; // @[Core.scala 297:37]
    end else if (!(id_reg_stall)) begin // @[Core.scala 619:23]
      if (if1_is_jump) begin // @[Core.scala 393:21]
        id_reg_bp_cnt <= 2'h0; // @[Core.scala 390:19]
      end else if (~io_imem_valid) begin // @[Core.scala 402:98]
        id_reg_bp_cnt <= _GEN_35;
      end else begin
        id_reg_bp_cnt <= _GEN_35;
      end
    end
    id_reg_is_bp_fail <= reset | _ic_read_en4_T & _csr_is_valid_inst_T & ~id_reg_is_bp_fail & ~id_is_j & ~id_is_br &
      id_reg_bp_taken; // @[Core.scala 298:{37,37} 938:21]
    if (reset) begin // @[Core.scala 299:37]
      id_reg_br_pc <= 31'h4000000; // @[Core.scala 299:37]
    end else if (id_is_half) begin // @[Core.scala 937:22]
      id_reg_br_pc <= _id_reg_br_pc_T_1;
    end else begin
      id_reg_br_pc <= _id_reg_br_pc_T_3;
    end
    if (reset) begin // @[Core.scala 307:37]
      mem1_mem_stall_delay <= 1'h0; // @[Core.scala 307:37]
    end else begin
      mem1_mem_stall_delay <= mem1_is_mem_load & io_dmem_rvalid & ~mem1_mem_stall; // @[Core.scala 1941:24]
    end
    if (reset) begin // @[Core.scala 308:37]
      ex1_reg_fw_en <= 1'h0; // @[Core.scala 308:37]
    end else if (_T_40) begin // @[Core.scala 1222:20]
      ex1_reg_fw_en <= rrd_fw_en_next; // @[Core.scala 1249:27]
    end
    if (reset) begin // @[Core.scala 310:37]
      ex2_reg_fw_en <= 1'h0; // @[Core.scala 310:37]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_fw_en <= ex1_fw_en_next; // @[Core.scala 1436:31]
    end
    if (reset) begin // @[Core.scala 313:37]
      ex2_reg_div_stall <= 1'h0; // @[Core.scala 313:37]
    end else if (_T_40) begin // @[Core.scala 1406:21]
      ex2_reg_div_stall <= ex2_div_stall_next | _ex2_reg_div_stall_T_3; // @[Core.scala 1427:31]
    end else begin
      ex2_reg_div_stall <= ex2_div_stall_next | _ex2_reg_div_stall_T_8; // @[Core.scala 1443:23]
    end
    if (reset) begin // @[Core.scala 314:37]
      ex2_reg_divrem_state <= 3'h0; // @[Core.scala 314:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (ex2_reg_divrem) begin // @[Core.scala 1683:29]
        ex2_reg_divrem_state <= {{1'd0}, _GEN_530};
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (ex2_reg_p_divisor[63:36] == 28'h0) begin // @[Core.scala 1706:66]
        ex2_reg_divrem_state <= 3'h2; // @[Core.scala 1707:30]
      end
    end else if (3'h2 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divrem_state <= _GEN_539;
    end else begin
      ex2_reg_divrem_state <= _GEN_545;
    end
    if (reset) begin // @[Core.scala 315:37]
      ex2_reg_is_br <= 1'h0; // @[Core.scala 315:37]
    end else begin
      ex2_reg_is_br <= csr_is_br | jbr_is_br; // @[Core.scala 1571:17]
    end
    if (reset) begin // @[Core.scala 316:37]
      ex2_reg_br_pc <= 31'h0; // @[Core.scala 316:37]
    end else if (jbr_cond_bp_fail) begin // @[Mux.scala 101:16]
      ex2_reg_br_pc <= jbr_reg_br_pc;
    end else if (jbr_cond_nbp_fail) begin // @[Mux.scala 101:16]
      if (jbr_reg_is_half) begin // @[Core.scala 1389:30]
        ex2_reg_br_pc <= _ex2_reg_br_pc_T_1;
      end else begin
        ex2_reg_br_pc <= _ex2_reg_br_pc_T_3;
      end
    end else if (jbr_uncond_bp_fail) begin // @[Mux.scala 101:16]
      ex2_reg_br_pc <= jbr_reg_br_pc;
    end else begin
      ex2_reg_br_pc <= csr_br_pc;
    end
    if (reset) begin // @[Core.scala 321:37]
      ex2_reg_is_retired <= 1'h0; // @[Core.scala 321:37]
    end else begin
      ex2_reg_is_retired <= ex2_is_valid_inst & _T_67 & ex2_reg_no_mem; // @[Core.scala 1881:22]
    end
    if (reset) begin // @[Core.scala 322:37]
      mem3_reg_is_retired <= 1'h0; // @[Core.scala 322:37]
    end else begin
      mem3_reg_is_retired <= mem3_reg_is_valid_inst; // @[Core.scala 2019:23]
    end
    if (reset) begin // @[Core.scala 342:33]
      ic_reg_read_rdy <= 1'h0; // @[Core.scala 342:33]
    end else if (if1_is_jump) begin // @[Core.scala 393:21]
      ic_reg_read_rdy <= ~if1_jump_addr[0]; // @[Core.scala 399:22]
    end else if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
      ic_reg_read_rdy <= 1'h1; // @[Core.scala 379:19]
    end
    if (reset) begin // @[Core.scala 343:33]
      ic_reg_half_rdy <= 1'h0; // @[Core.scala 343:33]
    end else begin
      ic_reg_half_rdy <= _GEN_191;
    end
    if (reset) begin // @[Core.scala 347:33]
      ic_reg_imem_addr <= 31'h0; // @[Core.scala 347:33]
    end else if (if1_is_jump) begin // @[Core.scala 393:21]
      ic_reg_imem_addr <= ic_next_imem_addr; // @[Core.scala 396:22]
    end else if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
      if (_T_3) begin // @[Core.scala 453:23]
        ic_reg_imem_addr <= ic_imem_addr_4; // @[Core.scala 456:26]
      end else begin
        ic_reg_imem_addr <= _GEN_116;
      end
    end
    if (reset) begin // @[Core.scala 348:33]
      ic_reg_addr_out <= 31'h0; // @[Core.scala 348:33]
    end else if (if1_is_jump) begin // @[Core.scala 393:21]
      if (ex2_reg_is_br) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= ex2_reg_br_pc;
      end else if (id_reg_is_bp_fail) begin // @[Mux.scala 101:16]
        ic_reg_addr_out <= id_reg_br_pc;
      end else begin
        ic_reg_addr_out <= id_reg_bp_taken_pc;
      end
    end else if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
      if (_T_3) begin // @[Core.scala 453:23]
        ic_reg_addr_out <= _GEN_47;
      end else begin
        ic_reg_addr_out <= _GEN_120;
      end
    end
    if (reset) begin // @[Core.scala 351:34]
      ic_reg_inst <= 32'h0; // @[Core.scala 351:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
        if (_T_3) begin // @[Core.scala 453:23]
          ic_reg_inst <= io_imem_inst; // @[Core.scala 457:26]
        end else begin
          ic_reg_inst <= _GEN_117;
        end
      end
    end
    if (reset) begin // @[Core.scala 352:34]
      ic_reg_inst_addr <= 31'h0; // @[Core.scala 352:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
        if (_T_3) begin // @[Core.scala 453:23]
          ic_reg_inst_addr <= ic_reg_imem_addr; // @[Core.scala 458:26]
        end else begin
          ic_reg_inst_addr <= _GEN_118;
        end
      end
    end
    if (reset) begin // @[Core.scala 353:34]
      ic_reg_inst2 <= 32'h0; // @[Core.scala 353:34]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
        if (!(_T_3)) begin // @[Core.scala 453:23]
          ic_reg_inst2 <= _GEN_132;
        end
      end
    end
    if (reset) begin // @[Core.scala 356:25]
      ic_state <= 3'h0; // @[Core.scala 356:25]
    end else if (if1_is_jump) begin // @[Core.scala 393:21]
      ic_state <= {{2'd0}, if1_jump_addr[0]}; // @[Core.scala 398:22]
    end else if (!(~io_imem_valid)) begin // @[Core.scala 402:98]
      if (_T_3) begin // @[Core.scala 453:23]
        ic_state <= _GEN_48;
      end else begin
        ic_state <= _GEN_131;
      end
    end
    if (reset) begin // @[Core.scala 364:41]
      ic_reg_bp_next_taken0 <= 1'h0; // @[Core.scala 364:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_taken0 <= _GEN_36;
      end else begin
        ic_reg_bp_next_taken0 <= _GEN_36;
      end
    end
    if (reset) begin // @[Core.scala 365:41]
      ic_reg_bp_next_taken_pc0 <= 31'h0; // @[Core.scala 365:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_taken_pc0 <= _GEN_37;
      end else begin
        ic_reg_bp_next_taken_pc0 <= _GEN_37;
      end
    end
    if (reset) begin // @[Core.scala 366:41]
      ic_reg_bp_next_cnt0 <= 2'h0; // @[Core.scala 366:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_cnt0 <= _GEN_38;
      end else begin
        ic_reg_bp_next_cnt0 <= _GEN_38;
      end
    end
    if (reset) begin // @[Core.scala 367:41]
      ic_reg_bp_next_taken1 <= 1'h0; // @[Core.scala 367:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        if (3'h0 == ic_state) begin // @[Core.scala 407:23]
          ic_reg_bp_next_taken1 <= ic_btb_io_lu_matches1 & ic_pht_io_lu_cnt1[0]; // @[Core.scala 415:34]
        end else begin
          ic_reg_bp_next_taken1 <= _GEN_27;
        end
      end else if (_T_3) begin // @[Core.scala 453:23]
        ic_reg_bp_next_taken1 <= _ic_reg_bp_next_taken1_T_1; // @[Core.scala 468:34]
      end else begin
        ic_reg_bp_next_taken1 <= _GEN_128;
      end
    end
    if (reset) begin // @[Core.scala 368:41]
      ic_reg_bp_next_taken_pc1 <= 31'h0; // @[Core.scala 368:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        if (3'h0 == ic_state) begin // @[Core.scala 407:23]
          ic_reg_bp_next_taken_pc1 <= ic_btb_io_lu_taken_pc1; // @[Core.scala 416:34]
        end else begin
          ic_reg_bp_next_taken_pc1 <= _GEN_28;
        end
      end else if (_T_3) begin // @[Core.scala 453:23]
        ic_reg_bp_next_taken_pc1 <= ic_btb_io_lu_taken_pc1; // @[Core.scala 469:34]
      end else begin
        ic_reg_bp_next_taken_pc1 <= _GEN_129;
      end
    end
    if (reset) begin // @[Core.scala 369:41]
      ic_reg_bp_next_cnt1 <= 2'h0; // @[Core.scala 369:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        if (3'h0 == ic_state) begin // @[Core.scala 407:23]
          ic_reg_bp_next_cnt1 <= ic_pht_io_lu_cnt1; // @[Core.scala 417:34]
        end else begin
          ic_reg_bp_next_cnt1 <= _GEN_29;
        end
      end else if (_T_3) begin // @[Core.scala 453:23]
        ic_reg_bp_next_cnt1 <= ic_pht_io_lu_cnt1; // @[Core.scala 470:34]
      end else begin
        ic_reg_bp_next_cnt1 <= _GEN_130;
      end
    end
    if (reset) begin // @[Core.scala 370:41]
      ic_reg_bp_next_taken2 <= 1'h0; // @[Core.scala 370:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_taken2 <= _GEN_42;
      end else begin
        ic_reg_bp_next_taken2 <= _GEN_42;
      end
    end
    if (reset) begin // @[Core.scala 371:41]
      ic_reg_bp_next_taken_pc2 <= 31'h0; // @[Core.scala 371:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_taken_pc2 <= _GEN_43;
      end else begin
        ic_reg_bp_next_taken_pc2 <= _GEN_43;
      end
    end
    if (reset) begin // @[Core.scala 372:41]
      ic_reg_bp_next_cnt2 <= 2'h0; // @[Core.scala 372:41]
    end else if (!(if1_is_jump)) begin // @[Core.scala 393:21]
      if (~io_imem_valid) begin // @[Core.scala 402:98]
        ic_reg_bp_next_cnt2 <= _GEN_44;
      end else begin
        ic_reg_bp_next_cnt2 <= _GEN_44;
      end
    end
    if (reset) begin // @[Core.scala 586:29]
      id_reg_pc <= 31'h4000000; // @[Core.scala 586:29]
    end else if (!(id_reg_stall | ~(ic_read_rdy | ic_half_rdy & is_half_inst))) begin // @[Core.scala 592:19]
      id_reg_pc <= ic_reg_addr_out;
    end
    if (reset) begin // @[Core.scala 587:29]
      id_reg_inst <= 32'h0; // @[Core.scala 587:29]
    end else if (ex2_reg_is_br) begin // @[Mux.scala 101:16]
      id_reg_inst <= 32'h13;
    end else if (!(id_reg_stall)) begin // @[Mux.scala 101:16]
      if (id_reg_is_bp_fail) begin // @[Mux.scala 101:16]
        id_reg_inst <= 32'h13;
      end else begin
        id_reg_inst <= _if2_inst_T_3;
      end
    end
    csr_reg_is_meintr <= _csr_reg_is_meintr_T_4 & _csr_reg_is_meintr_T_8; // @[Core.scala 1466:15]
    csr_reg_is_mtintr <= _csr_reg_is_mtintr_T_4 & _csr_reg_is_mtintr_T_8; // @[Core.scala 1471:22]
    if (reset) begin // @[Core.scala 945:40]
      id_reg_pc_delay <= 31'h0; // @[Core.scala 945:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_pc_delay <= _GEN_211;
    end else begin
      id_reg_pc_delay <= _GEN_211;
    end
    if (reset) begin // @[Core.scala 946:40]
      id_reg_wb_addr_delay <= 5'h0; // @[Core.scala 946:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_wb_addr_T) begin // @[Mux.scala 101:16]
          id_reg_wb_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_wb_addr_delay <= _id_wb_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 947:40]
      id_reg_op1_sel_delay <= 1'h0; // @[Core.scala 947:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op1_sel_T) begin // @[Mux.scala 101:16]
          id_reg_op1_sel_delay <= 1'h0;
        end else begin
          id_reg_op1_sel_delay <= _id_m_op1_sel_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 948:40]
      id_reg_op2_sel_delay <= 1'h0; // @[Core.scala 948:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op2_sel_T) begin // @[Mux.scala 101:16]
          id_reg_op2_sel_delay <= 1'h0;
        end else begin
          id_reg_op2_sel_delay <= _id_m_op2_sel_T_10;
        end
      end
    end
    if (reset) begin // @[Core.scala 949:40]
      id_reg_op3_sel_delay <= 2'h0; // @[Core.scala 949:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op3_sel_T) begin // @[Mux.scala 101:16]
          id_reg_op3_sel_delay <= 2'h0;
        end else begin
          id_reg_op3_sel_delay <= _id_m_op3_sel_T_12;
        end
      end
    end
    if (reset) begin // @[Core.scala 950:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[Core.scala 950:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op1_sel_T_1) begin // @[Mux.scala 101:16]
          id_reg_rs1_addr_delay <= id_w_wb_addr;
        end else begin
          id_reg_rs1_addr_delay <= _id_m_rs1_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 951:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[Core.scala 951:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op2_sel_T_1) begin // @[Mux.scala 101:16]
          id_reg_rs2_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs2_addr_delay <= _id_m_rs2_addr_T_6;
        end
      end
    end
    if (reset) begin // @[Core.scala 952:40]
      id_reg_rs3_addr_delay <= 5'h0; // @[Core.scala 952:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_op3_sel_T_4) begin // @[Mux.scala 101:16]
          id_reg_rs3_addr_delay <= id_c_rs2_addr;
        end else begin
          id_reg_rs3_addr_delay <= _id_m_rs3_addr_T_4;
        end
      end
    end
    if (reset) begin // @[Core.scala 953:40]
      id_reg_op1_data_delay <= 32'h0; // @[Core.scala 953:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_op1_data_T) begin // @[Mux.scala 101:16]
          id_reg_op1_data_delay <= _id_op1_data_T_1;
        end else begin
          id_reg_op1_data_delay <= _id_op1_data_T_3;
        end
      end
    end
    id_reg_op2_data_delay <= _GEN_623[31:0]; // @[Core.scala 954:{40,40}]
    if (reset) begin // @[Core.scala 955:40]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 955:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_exe_fun_delay <= 5'h0; // @[Core.scala 979:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 5'h0;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_370;
      end
    end
    if (reset) begin // @[Core.scala 956:40]
      id_reg_rf_wen_delay <= 1'h0; // @[Core.scala 956:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_rf_wen_delay <= 1'h0; // @[Core.scala 978:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      id_reg_rf_wen_delay <= csignals_4; // @[Core.scala 998:29]
    end
    if (reset) begin // @[Core.scala 957:40]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 957:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_wb_sel_delay <= 3'h0; // @[Core.scala 980:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h6;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_985;
      end
    end
    if (reset) begin // @[Core.scala 958:40]
      id_reg_csr_addr_delay <= 12'h0; // @[Core.scala 958:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (csignals_0 == 5'h18) begin // @[Core.scala 877:24]
          id_reg_csr_addr_delay <= 12'h342;
        end else begin
          id_reg_csr_addr_delay <= id_imm_i;
        end
      end
    end
    if (reset) begin // @[Core.scala 959:40]
      id_reg_csr_cmd_delay <= 2'h0; // @[Core.scala 959:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_csr_cmd_delay <= 2'h0; // @[Core.scala 981:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 2'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_1231;
      end
    end
    if (reset) begin // @[Core.scala 960:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[Core.scala 960:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        if (_id_m_imm_b_sext_T) begin // @[Mux.scala 101:16]
          id_reg_imm_b_sext_delay <= id_c_imm_b;
        end else begin
          id_reg_imm_b_sext_delay <= _id_m_imm_b_sext_T_2;
        end
      end
    end
    if (reset) begin // @[Core.scala 961:40]
      id_reg_mem_w_delay <= 3'h0; // @[Core.scala 961:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_mem_w_delay <= 3'h0; // @[Core.scala 982:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      if (_csignals_T_1) begin // @[Lookup.scala 34:39]
        id_reg_mem_w_delay <= 3'h5;
      end else begin
        id_reg_mem_w_delay <= _csignals_T_1354;
      end
    end
    if (reset) begin // @[Core.scala 963:40]
      id_reg_is_br_delay <= 1'h0; // @[Core.scala 963:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        id_reg_is_br_delay <= id_is_br; // @[Core.scala 1006:29]
      end
    end
    if (reset) begin // @[Core.scala 964:40]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 964:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_is_j_delay <= 1'h0; // @[Core.scala 983:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      id_reg_is_j_delay <= id_is_j; // @[Core.scala 1007:29]
    end
    if (reset) begin // @[Core.scala 965:40]
      id_reg_bp_taken_delay <= 1'h0; // @[Core.scala 965:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_bp_taken_delay <= 1'h0; // @[Core.scala 984:31]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      id_reg_bp_taken_delay <= id_reg_bp_taken; // @[Core.scala 1008:29]
    end
    if (reset) begin // @[Core.scala 966:41]
      id_reg_bp_taken_pc_delay <= 31'h0; // @[Core.scala 966:41]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        id_reg_bp_taken_pc_delay <= id_reg_bp_taken_pc; // @[Core.scala 1009:30]
      end
    end
    if (reset) begin // @[Core.scala 967:40]
      id_reg_bp_cnt_delay <= 2'h0; // @[Core.scala 967:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        id_reg_bp_cnt_delay <= id_reg_bp_cnt; // @[Core.scala 1010:29]
      end
    end
    if (reset) begin // @[Core.scala 968:40]
      id_reg_is_half_delay <= 1'h0; // @[Core.scala 968:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        id_reg_is_half_delay <= id_is_half; // @[Core.scala 1011:29]
      end
    end
    if (reset) begin // @[Core.scala 969:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 969:43]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_is_valid_inst_delay <= 1'h0; // @[Core.scala 985:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[Core.scala 1012:32]
    end
    if (reset) begin // @[Core.scala 970:40]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 970:40]
    end else if (ex2_reg_is_br) begin // @[Core.scala 974:24]
      id_reg_is_trap_delay <= 1'h0; // @[Core.scala 986:32]
    end else if (_ic_read_en4_T) begin // @[Core.scala 987:30]
      id_reg_is_trap_delay <= _id_csr_addr_T; // @[Core.scala 1013:29]
    end
    if (reset) begin // @[Core.scala 971:40]
      id_reg_mcause_delay <= 32'h0; // @[Core.scala 971:40]
    end else if (!(ex2_reg_is_br)) begin // @[Core.scala 974:24]
      if (_ic_read_en4_T) begin // @[Core.scala 987:30]
        id_reg_mcause_delay <= 32'hb; // @[Core.scala 1014:29]
      end
    end
    ex2_reg_dividend <= _GEN_624[36:0]; // @[Core.scala 1576:{37,37}]
    if (reset) begin // @[Core.scala 1577:37]
      ex2_reg_divisor <= 36'h0; // @[Core.scala 1577:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divisor <= _ex2_reg_divisor_T_1; // @[Core.scala 1692:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divisor <= ex2_reg_p_divisor[37:2]; // @[Core.scala 1710:28]
    end
    if (reset) begin // @[Core.scala 1578:37]
      ex2_reg_p_divisor <= 64'h0; // @[Core.scala 1578:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_p_divisor <= _ex2_reg_p_divisor_T; // @[Core.scala 1693:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_p_divisor <= {{2'd0}, ex2_reg_p_divisor[63:2]}; // @[Core.scala 1709:28]
    end
    if (reset) begin // @[Core.scala 1579:37]
      ex2_reg_divrem_count <= 5'h0; // @[Core.scala 1579:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divrem_count <= 5'h0; // @[Core.scala 1694:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divrem_count <= _ex2_reg_divrem_count_T_1; // @[Core.scala 1711:28]
    end else if (3'h2 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_divrem_count <= _ex2_reg_divrem_count_T_1; // @[Core.scala 1808:28]
    end
    if (reset) begin // @[Core.scala 1580:37]
      ex2_reg_rem_shift <= 5'h0; // @[Core.scala 1580:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      ex2_reg_rem_shift <= 5'h0; // @[Core.scala 1695:28]
    end else if (!(3'h1 == ex2_reg_divrem_state)) begin // @[Core.scala 1681:33]
      if (3'h2 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
        ex2_reg_rem_shift <= _ex2_reg_rem_shift_T_1; // @[Core.scala 1807:25]
      end
    end
    if (reset) begin // @[Core.scala 1581:37]
      ex2_reg_extra_shift <= 1'h0; // @[Core.scala 1581:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (~ex2_reg_init_divisor[1]) begin // @[Core.scala 1697:46]
        ex2_reg_extra_shift <= 1'h0; // @[Core.scala 1698:29]
      end else begin
        ex2_reg_extra_shift <= 1'h1; // @[Core.scala 1701:29]
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (~ex2_reg_p_divisor[35]) begin // @[Core.scala 1712:52]
        ex2_reg_extra_shift <= 1'h0; // @[Core.scala 1713:29]
      end else begin
        ex2_reg_extra_shift <= 1'h1; // @[Core.scala 1716:29]
      end
    end
    if (reset) begin // @[Core.scala 1582:37]
      ex2_reg_d <= 3'h0; // @[Core.scala 1582:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (~ex2_reg_init_divisor[1]) begin // @[Core.scala 1697:46]
        ex2_reg_d <= 3'h0; // @[Core.scala 1699:29]
      end else begin
        ex2_reg_d <= _ex2_reg_d_T_1; // @[Core.scala 1702:29]
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[Core.scala 1681:33]
      if (~ex2_reg_p_divisor[35]) begin // @[Core.scala 1712:52]
        ex2_reg_d <= ex2_reg_p_divisor[33:31]; // @[Core.scala 1714:29]
      end else begin
        ex2_reg_d <= ex2_reg_p_divisor[34:32]; // @[Core.scala 1717:29]
      end
    end
    if (reset) begin // @[Core.scala 1583:37]
      ex2_reg_reminder <= 32'h0; // @[Core.scala 1583:37]
    end else if (!(3'h0 == ex2_reg_divrem_state)) begin // @[Core.scala 1681:33]
      if (!(3'h1 == ex2_reg_divrem_state)) begin // @[Core.scala 1681:33]
        if (!(3'h2 == ex2_reg_divrem_state)) begin // @[Core.scala 1681:33]
          ex2_reg_reminder <= _GEN_544;
        end
      end
    end
    ex2_reg_quotient <= _GEN_626[31:0]; // @[Core.scala 1584:{37,37}]
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",_T_31,ic_data_out); // @[Core.scala 637:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"inst: %x, ic_read_rdy: %d, ic_state: %d, ic_addr_en: %d\n",if2_inst,ic_read_rdy,ic_state
            ,if1_is_jump); // @[Core.scala 638:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"if2_pc           : 0x%x\n",_T_120); // @[Core.scala 2062:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[Core.scala 2063:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"if2_reg_bp_taken : 0x%x\n",id_reg_bp_taken); // @[Core.scala 2064:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ic_bp_taken      : 0x%x\n",ic_bp_taken); // @[Core.scala 2065:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ic_bp_taken_pc   : 0x%x\n",_T_129); // @[Core.scala 2066:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ic_bp_cnt        : 0x%x\n",ic_bp_cnt); // @[Core.scala 2067:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",_id_op1_data_T_1); // @[Core.scala 2068:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[Core.scala 2069:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[Core.scala 2070:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[Core.scala 2071:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"id_reg_is_bp_fail: 0x%x\n",id_reg_is_bp_fail); // @[Core.scala 2075:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_reg_pc       : 0x%x\n",_T_145); // @[Core.scala 2076:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_reg_is_valid_: 0x%x\n",rrd_reg_is_valid_inst); // @[Core.scala 2077:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_stall        : 0x%x\n",rrd_stall); // @[Core.scala 2078:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_op1_data     : 0x%x\n",rrd_op1_data); // @[Core.scala 2081:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_op2_data     : 0x%x\n",rrd_op2_data); // @[Core.scala 2082:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_op3_data     : 0x%x\n",rrd_op3_data); // @[Core.scala 2083:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_reg_op1_sel  : 0x%x\n",rrd_reg_op1_sel); // @[Core.scala 2084:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"rrd_reg_rs1_addr : 0x%x\n",rrd_reg_rs1_addr); // @[Core.scala 2086:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_fw_data      : 0x%x\n",ex1_fw_data); // @[Core.scala 2087:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",_T_164); // @[Core.scala 2088:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_is_valid_: 0x%x\n",ex1_reg_is_valid_inst); // @[Core.scala 2089:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_op1_data : 0x%x\n",ex1_reg_op1_data); // @[Core.scala 2090:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_op2_data : 0x%x\n",ex1_reg_op2_data); // @[Core.scala 2091:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_alu_out      : 0x%x\n",ex1_alu_out); // @[Core.scala 2092:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_exe_fun  : 0x%x\n",ex1_reg_exe_fun); // @[Core.scala 2093:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_wb_sel   : 0x%x\n",ex1_reg_wb_sel); // @[Core.scala 2094:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_wb_addr  : 0x%x\n",ex1_reg_wb_addr); // @[Core.scala 2095:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_bp_taken : 0x%x\n",ex1_reg_bp_taken); // @[Core.scala 2096:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex1_reg_bp_taken_: 0x%x\n",_T_183); // @[Core.scala 2097:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"jbr_is_br        : 0x%d\n",jbr_is_br); // @[Core.scala 2098:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"jbr_reg_bp_cnt   : 0x%d\n",jbr_reg_bp_cnt); // @[Core.scala 2099:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_reg_is_br    : 0x%d\n",ex2_reg_is_br); // @[Core.scala 2100:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_reg_br_pc  : 0x%x\n",_T_192); // @[Core.scala 2101:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",_io_debug_signal_ex2_reg_pc_T); // @[Core.scala 2102:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_is_valid_inst: 0x%x\n",ex2_is_valid_inst); // @[Core.scala 2103:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_stall        : 0x%x\n",ex2_stall); // @[Core.scala 2104:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_wb_data      : 0x%x\n",ex2_wb_data); // @[Core.scala 2105:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_alu_muldiv_ou: 0x%x\n",ex2_alu_muldiv_out); // @[Core.scala 2106:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_reg_wb_addr  : 0x%x\n",ex2_reg_wb_addr); // @[Core.scala 2107:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"ex2_reg_wdata    : 0x%x\n",ex2_reg_wdata); // @[Core.scala 2108:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem1_mem_stall   : 0x%x\n",mem1_mem_stall); // @[Core.scala 2110:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem1_dram_stall  : 0x%x\n",mem1_dram_stall); // @[Core.scala 2111:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem1_is_valid_ins: 0x%x\n",mem1_is_valid_inst); // @[Core.scala 2112:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem2_dram_stall  : 0x%x\n",mem2_dram_stall); // @[Core.scala 2113:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem2_reg_dmem_rda: 0x%x\n",mem2_reg_dmem_rdata); // @[Core.scala 2114:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem2_reg_is_valid: 0x%x\n",mem2_reg_is_valid_inst); // @[Core.scala 2116:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem2_reg_is_dram_: 0x%x\n",mem2_reg_is_dram_load); // @[Core.scala 2117:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem3_reg_dmem_rda: 0x%x\n",mem3_reg_dmem_rdata); // @[Core.scala 2118:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem3_wb_data_load: 0x%x\n",mem3_wb_data_load); // @[Core.scala 2119:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"mem3_reg_is_valid: 0x%x\n",mem3_reg_is_valid_inst); // @[Core.scala 2120:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"csr_is_meintr    : %d\n",csr_is_meintr); // @[Core.scala 2122:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"csr_is_mtintr    : %d\n",csr_is_mtintr); // @[Core.scala 2123:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"csr_is_trap      : %d\n",csr_is_trap); // @[Core.scala 2124:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"csr_is_br        : %d\n",csr_is_br); // @[Core.scala 2126:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[Core.scala 2129:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"cycle_counter    : %d\n",io_debug_signal_cycle_counter); // @[Core.scala 2132:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_33) begin
          $fwrite(32'h80000002,"---------\n"); // @[Core.scala 2133:9]
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
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    scoreboard[initvar] = _RAND_1[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {2{`RANDOM}};
  instret = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  csr_reg_trap_vector = _RAND_3[30:0];
  _RAND_4 = {1{`RANDOM}};
  csr_reg_mcause = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  csr_reg_mepc = _RAND_5[30:0];
  _RAND_6 = {1{`RANDOM}};
  csr_reg_mstatus_mie = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  csr_reg_mstatus_mpie = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  csr_reg_mscratch = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  csr_reg_mie_meie = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  csr_reg_mie_mtie = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  id_reg_stall = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  rrd_reg_pc = _RAND_12[30:0];
  _RAND_13 = {1{`RANDOM}};
  rrd_reg_wb_addr = _RAND_13[4:0];
  _RAND_14 = {1{`RANDOM}};
  rrd_reg_op1_sel = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  rrd_reg_op2_sel = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  rrd_reg_op3_sel = _RAND_16[1:0];
  _RAND_17 = {1{`RANDOM}};
  rrd_reg_rs1_addr = _RAND_17[4:0];
  _RAND_18 = {1{`RANDOM}};
  rrd_reg_rs2_addr = _RAND_18[4:0];
  _RAND_19 = {1{`RANDOM}};
  rrd_reg_rs3_addr = _RAND_19[4:0];
  _RAND_20 = {1{`RANDOM}};
  rrd_reg_op1_data = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  rrd_reg_op2_data = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  rrd_reg_exe_fun = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  rrd_reg_rf_wen = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rrd_reg_wb_sel = _RAND_24[2:0];
  _RAND_25 = {1{`RANDOM}};
  rrd_reg_csr_addr = _RAND_25[11:0];
  _RAND_26 = {1{`RANDOM}};
  rrd_reg_csr_cmd = _RAND_26[1:0];
  _RAND_27 = {1{`RANDOM}};
  rrd_reg_imm_b_sext = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  rrd_reg_mem_w = _RAND_28[2:0];
  _RAND_29 = {1{`RANDOM}};
  rrd_reg_is_br = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  rrd_reg_is_j = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  rrd_reg_bp_taken = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  rrd_reg_bp_taken_pc = _RAND_32[30:0];
  _RAND_33 = {1{`RANDOM}};
  rrd_reg_bp_cnt = _RAND_33[1:0];
  _RAND_34 = {1{`RANDOM}};
  rrd_reg_is_half = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  rrd_reg_is_valid_inst = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  rrd_reg_is_trap = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  rrd_reg_mcause = _RAND_37[31:0];
  _RAND_38 = {1{`RANDOM}};
  ex1_reg_pc = _RAND_38[30:0];
  _RAND_39 = {1{`RANDOM}};
  ex1_reg_wb_addr = _RAND_39[4:0];
  _RAND_40 = {1{`RANDOM}};
  ex1_reg_op1_data = _RAND_40[31:0];
  _RAND_41 = {1{`RANDOM}};
  ex1_reg_op2_data = _RAND_41[31:0];
  _RAND_42 = {1{`RANDOM}};
  ex1_reg_op3_data = _RAND_42[31:0];
  _RAND_43 = {1{`RANDOM}};
  ex1_reg_exe_fun = _RAND_43[4:0];
  _RAND_44 = {1{`RANDOM}};
  ex1_reg_rf_wen = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  ex1_reg_wb_sel = _RAND_45[2:0];
  _RAND_46 = {1{`RANDOM}};
  ex1_reg_csr_addr = _RAND_46[11:0];
  _RAND_47 = {1{`RANDOM}};
  ex1_reg_csr_cmd = _RAND_47[1:0];
  _RAND_48 = {1{`RANDOM}};
  ex1_reg_mem_w = _RAND_48[2:0];
  _RAND_49 = {1{`RANDOM}};
  ex1_is_uncond_br = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  ex1_reg_bp_taken = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  ex1_reg_bp_taken_pc = _RAND_51[30:0];
  _RAND_52 = {1{`RANDOM}};
  ex1_reg_bp_cnt = _RAND_52[1:0];
  _RAND_53 = {1{`RANDOM}};
  ex1_reg_is_half = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  ex1_reg_is_valid_inst = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  ex1_reg_is_trap = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  ex1_reg_mcause = _RAND_56[31:0];
  _RAND_57 = {1{`RANDOM}};
  ex1_reg_mem_use_reg = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  ex1_reg_inst2_use_reg = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  ex1_reg_inst3_use_reg = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  ex1_is_cond_br_inst = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  ex1_reg_direct_jbr_pc = _RAND_61[30:0];
  _RAND_62 = {1{`RANDOM}};
  jbr_reg_bp_en = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  jbr_reg_is_cond_br = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  jbr_reg_is_cond_br_inst = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  jbr_reg_is_uncond_br = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  jbr_reg_br_pc = _RAND_66[30:0];
  _RAND_67 = {1{`RANDOM}};
  jbr_reg_bp_taken = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  jbr_reg_bp_taken_pc = _RAND_68[30:0];
  _RAND_69 = {1{`RANDOM}};
  jbr_reg_bp_cnt = _RAND_69[1:0];
  _RAND_70 = {1{`RANDOM}};
  jbr_reg_is_half = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  ex2_reg_pc = _RAND_71[30:0];
  _RAND_72 = {1{`RANDOM}};
  ex2_reg_wb_addr = _RAND_72[4:0];
  _RAND_73 = {1{`RANDOM}};
  ex2_reg_op1_data = _RAND_73[31:0];
  _RAND_74 = {2{`RANDOM}};
  ex2_reg_mullu = _RAND_74[47:0];
  _RAND_75 = {1{`RANDOM}};
  ex2_reg_mulls = _RAND_75[31:0];
  _RAND_76 = {2{`RANDOM}};
  ex2_reg_mulhuu = _RAND_76[47:0];
  _RAND_77 = {2{`RANDOM}};
  ex2_reg_mulhss = _RAND_77[47:0];
  _RAND_78 = {2{`RANDOM}};
  ex2_reg_mulhsu = _RAND_78[47:0];
  _RAND_79 = {1{`RANDOM}};
  ex2_reg_exe_fun = _RAND_79[4:0];
  _RAND_80 = {1{`RANDOM}};
  ex2_reg_rf_wen = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  ex2_reg_wb_sel = _RAND_81[2:0];
  _RAND_82 = {1{`RANDOM}};
  ex2_reg_csr_addr = _RAND_82[11:0];
  _RAND_83 = {1{`RANDOM}};
  ex2_reg_csr_cmd = _RAND_83[1:0];
  _RAND_84 = {1{`RANDOM}};
  ex2_reg_alu_out = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  ex2_reg_pc_bit_out = _RAND_85[31:0];
  _RAND_86 = {1{`RANDOM}};
  ex2_reg_wdata = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  ex2_reg_is_valid_inst = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  ex2_reg_is_trap = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  ex2_reg_mcause = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  ex2_reg_divrem = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  ex2_reg_sign_op1 = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  ex2_reg_sign_op12 = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  ex2_reg_zero_op2 = _RAND_93[0:0];
  _RAND_94 = {2{`RANDOM}};
  ex2_reg_init_dividend = _RAND_94[36:0];
  _RAND_95 = {1{`RANDOM}};
  ex2_reg_init_divisor = _RAND_95[31:0];
  _RAND_96 = {1{`RANDOM}};
  ex2_reg_orig_dividend = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  ex2_reg_inst3_use_reg = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  ex2_reg_no_mem = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  mem1_reg_mem_wstrb = _RAND_99[3:0];
  _RAND_100 = {1{`RANDOM}};
  mem1_reg_mem_w = _RAND_100[2:0];
  _RAND_101 = {1{`RANDOM}};
  mem1_reg_mem_use_reg = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  mem1_reg_is_mem_load = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  mem1_reg_is_mem_store = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  mem1_reg_is_dram_load = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  mem1_reg_is_dram_store = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  mem1_reg_is_dram_fence = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  mem1_reg_is_valid_inst = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  mem2_reg_wb_byte_offset = _RAND_108[1:0];
  _RAND_109 = {1{`RANDOM}};
  mem2_reg_mem_w = _RAND_109[2:0];
  _RAND_110 = {1{`RANDOM}};
  mem2_reg_dmem_rdata = _RAND_110[31:0];
  _RAND_111 = {1{`RANDOM}};
  mem2_reg_wb_addr = _RAND_111[31:0];
  _RAND_112 = {1{`RANDOM}};
  mem2_reg_is_valid_load = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  mem2_reg_mem_use_reg = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  mem2_reg_is_valid_inst = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  mem2_reg_is_dram_load = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  mem3_reg_wb_byte_offset = _RAND_116[1:0];
  _RAND_117 = {1{`RANDOM}};
  mem3_reg_mem_w = _RAND_117[2:0];
  _RAND_118 = {1{`RANDOM}};
  mem3_reg_dmem_rdata = _RAND_118[31:0];
  _RAND_119 = {1{`RANDOM}};
  mem3_reg_wb_addr = _RAND_119[31:0];
  _RAND_120 = {1{`RANDOM}};
  mem3_reg_is_valid_load = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  mem3_reg_is_valid_inst = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  mem3_reg_mem_use_reg = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  id_reg_bp_taken = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  id_reg_bp_taken_pc = _RAND_124[30:0];
  _RAND_125 = {1{`RANDOM}};
  id_reg_bp_cnt = _RAND_125[1:0];
  _RAND_126 = {1{`RANDOM}};
  id_reg_is_bp_fail = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  id_reg_br_pc = _RAND_127[30:0];
  _RAND_128 = {1{`RANDOM}};
  mem1_mem_stall_delay = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  ex2_reg_div_stall = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  ex2_reg_divrem_state = _RAND_132[2:0];
  _RAND_133 = {1{`RANDOM}};
  ex2_reg_is_br = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  ex2_reg_br_pc = _RAND_134[30:0];
  _RAND_135 = {1{`RANDOM}};
  ex2_reg_is_retired = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  mem3_reg_is_retired = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_137[0:0];
  _RAND_138 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_138[0:0];
  _RAND_139 = {1{`RANDOM}};
  ic_reg_imem_addr = _RAND_139[30:0];
  _RAND_140 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_140[30:0];
  _RAND_141 = {1{`RANDOM}};
  ic_reg_inst = _RAND_141[31:0];
  _RAND_142 = {1{`RANDOM}};
  ic_reg_inst_addr = _RAND_142[30:0];
  _RAND_143 = {1{`RANDOM}};
  ic_reg_inst2 = _RAND_143[31:0];
  _RAND_144 = {1{`RANDOM}};
  ic_state = _RAND_144[2:0];
  _RAND_145 = {1{`RANDOM}};
  ic_reg_bp_next_taken0 = _RAND_145[0:0];
  _RAND_146 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc0 = _RAND_146[30:0];
  _RAND_147 = {1{`RANDOM}};
  ic_reg_bp_next_cnt0 = _RAND_147[1:0];
  _RAND_148 = {1{`RANDOM}};
  ic_reg_bp_next_taken1 = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc1 = _RAND_149[30:0];
  _RAND_150 = {1{`RANDOM}};
  ic_reg_bp_next_cnt1 = _RAND_150[1:0];
  _RAND_151 = {1{`RANDOM}};
  ic_reg_bp_next_taken2 = _RAND_151[0:0];
  _RAND_152 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc2 = _RAND_152[30:0];
  _RAND_153 = {1{`RANDOM}};
  ic_reg_bp_next_cnt2 = _RAND_153[1:0];
  _RAND_154 = {1{`RANDOM}};
  id_reg_pc = _RAND_154[30:0];
  _RAND_155 = {1{`RANDOM}};
  id_reg_inst = _RAND_155[31:0];
  _RAND_156 = {1{`RANDOM}};
  csr_reg_is_meintr = _RAND_156[0:0];
  _RAND_157 = {1{`RANDOM}};
  csr_reg_is_mtintr = _RAND_157[0:0];
  _RAND_158 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_158[30:0];
  _RAND_159 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_159[4:0];
  _RAND_160 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_160[0:0];
  _RAND_161 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_161[0:0];
  _RAND_162 = {1{`RANDOM}};
  id_reg_op3_sel_delay = _RAND_162[1:0];
  _RAND_163 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_163[4:0];
  _RAND_164 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_164[4:0];
  _RAND_165 = {1{`RANDOM}};
  id_reg_rs3_addr_delay = _RAND_165[4:0];
  _RAND_166 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_166[31:0];
  _RAND_167 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_167[31:0];
  _RAND_168 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_168[4:0];
  _RAND_169 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_169[0:0];
  _RAND_170 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_170[2:0];
  _RAND_171 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_171[11:0];
  _RAND_172 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_172[1:0];
  _RAND_173 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_173[31:0];
  _RAND_174 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_174[2:0];
  _RAND_175 = {1{`RANDOM}};
  id_reg_is_br_delay = _RAND_175[0:0];
  _RAND_176 = {1{`RANDOM}};
  id_reg_is_j_delay = _RAND_176[0:0];
  _RAND_177 = {1{`RANDOM}};
  id_reg_bp_taken_delay = _RAND_177[0:0];
  _RAND_178 = {1{`RANDOM}};
  id_reg_bp_taken_pc_delay = _RAND_178[30:0];
  _RAND_179 = {1{`RANDOM}};
  id_reg_bp_cnt_delay = _RAND_179[1:0];
  _RAND_180 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_180[0:0];
  _RAND_181 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_181[0:0];
  _RAND_182 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_182[0:0];
  _RAND_183 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_183[31:0];
  _RAND_184 = {2{`RANDOM}};
  ex2_reg_dividend = _RAND_184[36:0];
  _RAND_185 = {2{`RANDOM}};
  ex2_reg_divisor = _RAND_185[35:0];
  _RAND_186 = {2{`RANDOM}};
  ex2_reg_p_divisor = _RAND_186[63:0];
  _RAND_187 = {1{`RANDOM}};
  ex2_reg_divrem_count = _RAND_187[4:0];
  _RAND_188 = {1{`RANDOM}};
  ex2_reg_rem_shift = _RAND_188[4:0];
  _RAND_189 = {1{`RANDOM}};
  ex2_reg_extra_shift = _RAND_189[0:0];
  _RAND_190 = {1{`RANDOM}};
  ex2_reg_d = _RAND_190[2:0];
  _RAND_191 = {1{`RANDOM}};
  ex2_reg_reminder = _RAND_191[31:0];
  _RAND_192 = {1{`RANDOM}};
  ex2_reg_quotient = _RAND_192[31:0];
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
  input          io_cache_iinvalidate,
  output         io_cache_ibusy,
  input  [31:0]  io_cache_raddr,
  output [31:0]  io_cache_rdata,
  input          io_cache_ren,
  output         io_cache_rvalid,
  output         io_cache_rready,
  input  [31:0]  io_cache_waddr,
  input          io_cache_wen,
  output         io_cache_wready,
  input  [3:0]   io_cache_wstrb,
  input  [31:0]  io_cache_wdata,
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
  output [1:0]   io_icache_valid_wdata,
  output [2:0]   io_icache_state,
  output [2:0]   io_dram_state
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
  reg [255:0] _RAND_26;
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
  reg [15:0] i_tag_array_0 [0:127]; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_en; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_addr; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_data; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_1_en; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_1_addr; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_1_data; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_3_en; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_3_addr; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_3_data; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_5_en; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_5_addr; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_5_data; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_2_data; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_2_addr; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_2_mask; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_2_en; // @[Memory.scala 283:24]
  wire [15:0] i_tag_array_0_MPORT_4_data; // @[Memory.scala 283:24]
  wire [6:0] i_tag_array_0_MPORT_4_addr; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_4_mask; // @[Memory.scala 283:24]
  wire  i_tag_array_0_MPORT_4_en; // @[Memory.scala 283:24]
  reg [15:0] tag_array_0 [0:127]; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_6_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_6_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_6_data; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_7_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_7_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_7_data; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_8_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_8_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_8_data; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_9_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_9_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_9_data; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_12_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_12_addr; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_12_mask; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_12_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_14_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_14_addr; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_14_mask; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_14_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_16_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_16_addr; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_16_mask; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_16_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_0_MPORT_18_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_0_MPORT_18_addr; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_18_mask; // @[Memory.scala 495:22]
  wire  tag_array_0_MPORT_18_en; // @[Memory.scala 495:22]
  reg [15:0] tag_array_1 [0:127]; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_6_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_6_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_6_data; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_7_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_7_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_7_data; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_8_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_8_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_8_data; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_9_en; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_9_addr; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_9_data; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_12_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_12_addr; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_12_mask; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_12_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_14_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_14_addr; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_14_mask; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_14_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_16_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_16_addr; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_16_mask; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_16_en; // @[Memory.scala 495:22]
  wire [15:0] tag_array_1_MPORT_18_data; // @[Memory.scala 495:22]
  wire [6:0] tag_array_1_MPORT_18_addr; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_18_mask; // @[Memory.scala 495:22]
  wire  tag_array_1_MPORT_18_en; // @[Memory.scala 495:22]
  reg  lru_array_way_hot [0:127]; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_reg_lru_MPORT_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_reg_lru_MPORT_1_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_1_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_reg_lru_MPORT_1_data; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_10_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_10_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_10_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_10_en; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_11_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_11_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_11_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_11_en; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_13_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_13_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_13_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_13_en; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_15_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_15_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_15_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_15_en; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_17_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_17_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_17_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_17_en; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_19_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_way_hot_MPORT_19_addr; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_19_mask; // @[Memory.scala 496:22]
  wire  lru_array_way_hot_MPORT_19_en; // @[Memory.scala 496:22]
  reg  lru_array_dirty1 [0:127]; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_reg_lru_MPORT_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_reg_lru_MPORT_1_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_1_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_reg_lru_MPORT_1_data; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_10_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_10_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_10_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_10_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_11_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_11_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_11_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_11_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_13_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_13_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_13_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_13_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_15_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_15_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_15_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_15_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_17_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_17_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_17_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_17_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_19_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty1_MPORT_19_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_19_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty1_MPORT_19_en; // @[Memory.scala 496:22]
  reg  lru_array_dirty2 [0:127]; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_reg_lru_MPORT_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_reg_lru_MPORT_1_en; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_1_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_reg_lru_MPORT_1_data; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_10_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_10_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_10_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_10_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_11_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_11_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_11_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_11_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_13_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_13_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_13_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_13_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_15_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_15_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_15_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_15_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_17_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_17_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_17_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_17_en; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_19_data; // @[Memory.scala 496:22]
  wire [6:0] lru_array_dirty2_MPORT_19_addr; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_19_mask; // @[Memory.scala 496:22]
  wire  lru_array_dirty2_MPORT_19_en; // @[Memory.scala 496:22]
  reg [2:0] reg_dram_state; // @[Memory.scala 185:31]
  reg [26:0] reg_dram_addr; // @[Memory.scala 186:31]
  reg [127:0] reg_dram_wdata; // @[Memory.scala 187:31]
  reg [127:0] reg_dram_rdata; // @[Memory.scala 188:31]
  reg  reg_dram_di; // @[Memory.scala 189:28]
  wire  _T_3 = ~io_dramPort_busy; // @[Memory.scala 205:48]
  reg [2:0] icache_state; // @[Memory.scala 285:29]
  wire  _T_25 = 3'h0 == icache_state; // @[Memory.scala 320:25]
  reg [2:0] dcache_state; // @[Memory.scala 498:29]
  wire  _T_82 = 3'h0 == dcache_state; // @[Memory.scala 543:25]
  reg [15:0] reg_tag_0; // @[Memory.scala 499:24]
  reg [15:0] reg_req_addr_tag; // @[Memory.scala 503:29]
  wire  _T_87 = reg_tag_0 == reg_req_addr_tag; // @[Memory.scala 583:24]
  reg [15:0] reg_tag_1; // @[Memory.scala 499:24]
  wire  _T_88 = reg_tag_1 == reg_req_addr_tag; // @[Memory.scala 586:30]
  wire [1:0] _GEN_535 = reg_tag_1 == reg_req_addr_tag ? 2'h1 : 2'h2; // @[Memory.scala 586:52 588:29 590:29]
  wire [1:0] _GEN_537 = reg_tag_0 == reg_req_addr_tag ? 2'h1 : _GEN_535; // @[Memory.scala 583:46 585:29]
  wire [1:0] _GEN_1131 = 3'h1 == dcache_state ? _GEN_537 : 2'h0; // @[Memory.scala 528:23 543:25]
  wire [1:0] dcache_snoop_status = 3'h0 == dcache_state ? 2'h0 : _GEN_1131; // @[Memory.scala 528:23 543:25]
  wire  _T_47 = 2'h0 == dcache_snoop_status; // @[Memory.scala 389:36]
  wire  _GEN_24 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? 1'h0 : 1'h1; // @[Memory.scala 198:20 205:67 206:21]
  wire  dram_i_busy = 3'h0 == reg_dram_state ? _GEN_24 : 1'h1; // @[Memory.scala 198:20 203:27]
  wire  _T_54 = ~dram_i_busy; // @[Memory.scala 410:17]
  reg [15:0] i_reg_req_addr_tag; // @[Memory.scala 288:31]
  reg [6:0] i_reg_req_addr_index; // @[Memory.scala 288:31]
  wire [22:0] _dram_i_addr_T_1 = {i_reg_req_addr_tag,i_reg_req_addr_index}; // @[Cat.scala 33:92]
  wire [22:0] _GEN_329 = 3'h4 == icache_state ? _dram_i_addr_T_1 : _dram_i_addr_T_1; // @[Memory.scala 320:25]
  wire [26:0] dram_i_addr = {{4'd0}, _GEN_329}; // @[Memory.scala 176:26]
  wire [30:0] _io_dramPort_addr_T = {dram_i_addr,4'h0}; // @[Cat.scala 33:92]
  reg  reg_lru_way_hot; // @[Memory.scala 502:24]
  reg  reg_lru_dirty1; // @[Memory.scala 502:24]
  wire  _T_96 = ~reg_lru_way_hot; // @[Memory.scala 607:83]
  reg  reg_lru_dirty2; // @[Memory.scala 502:24]
  wire  _GEN_155 = 2'h1 == dcache_snoop_status ? 1'h0 : 2'h2 == dcache_snoop_status & _T_54; // @[Memory.scala 305:14 389:36]
  wire  _GEN_173 = 2'h0 == dcache_snoop_status ? 1'h0 : _GEN_155; // @[Memory.scala 305:14 389:36]
  wire  _GEN_291 = 3'h5 == icache_state ? 1'h0 : 3'h3 == icache_state & _T_54; // @[Memory.scala 305:14 320:25]
  wire  _GEN_328 = 3'h4 == icache_state ? _GEN_173 : _GEN_291; // @[Memory.scala 320:25]
  wire  _GEN_389 = 3'h2 == icache_state ? 1'h0 : _GEN_328; // @[Memory.scala 305:14 320:25]
  wire  _GEN_437 = 3'h1 == icache_state ? 1'h0 : _GEN_389; // @[Memory.scala 305:14 320:25]
  wire  dram_i_ren = 3'h0 == icache_state ? 1'h0 : _GEN_437; // @[Memory.scala 305:14 320:25]
  wire  _GEN_30 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? dram_i_ren : 1'h1; // @[Memory.scala 199:20 205:67]
  wire  dram_d_busy = 3'h0 == reg_dram_state ? _GEN_30 : 1'h1; // @[Memory.scala 199:20 203:27]
  wire  _T_99 = ~dram_d_busy; // @[Memory.scala 608:15]
  reg [6:0] reg_req_addr_index; // @[Memory.scala 503:29]
  wire [22:0] _dram_d_addr_T_1 = {reg_tag_0,reg_req_addr_index}; // @[Cat.scala 33:92]
  wire [22:0] _dram_d_addr_T_3 = {reg_tag_1,reg_req_addr_index}; // @[Cat.scala 33:92]
  wire [22:0] _GEN_540 = reg_lru_way_hot ? _dram_d_addr_T_1 : _dram_d_addr_T_3; // @[Memory.scala 610:42 611:25 614:25]
  wire [22:0] _dram_d_addr_T_5 = {reg_req_addr_tag,reg_req_addr_index}; // @[Cat.scala 33:92]
  wire [22:0] _GEN_550 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_540 :
    _dram_d_addr_T_5; // @[Memory.scala 607:111]
  wire [22:0] _GEN_917 = 3'h3 == dcache_state ? _GEN_550 : _dram_d_addr_T_5; // @[Memory.scala 543:25]
  wire [22:0] _GEN_1049 = 3'h2 == dcache_state ? _GEN_550 : _GEN_917; // @[Memory.scala 543:25]
  wire [26:0] dram_d_addr = {{4'd0}, _GEN_1049}; // @[Memory.scala 181:26]
  wire [30:0] _io_dramPort_addr_T_1 = {dram_d_addr,4'h0}; // @[Cat.scala 33:92]
  reg  reg_dcache_read; // @[Memory.scala 507:32]
  reg [255:0] reg_line1; // @[Memory.scala 500:26]
  wire [255:0] line1 = reg_dcache_read ? io_cache_array1_rdata : reg_line1; // @[Memory.scala 599:22]
  reg [255:0] reg_line2; // @[Memory.scala 501:26]
  wire [255:0] line2 = reg_dcache_read ? io_cache_array2_rdata : reg_line2; // @[Memory.scala 600:22]
  wire [255:0] _GEN_541 = reg_lru_way_hot ? line1 : line2; // @[Memory.scala 610:42 612:26 615:26]
  wire [255:0] dram_d_wdata = 3'h2 == dcache_state ? _GEN_541 : _GEN_541; // @[Memory.scala 543:25]
  wire  _GEN_553 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? 1'h0 : _T_99; // @[Memory.scala 607:111 514:14]
  wire  _GEN_559 = _T_88 ? 1'h0 : _GEN_553; // @[Memory.scala 514:14 604:52]
  wire  _GEN_565 = _T_87 ? 1'h0 : _GEN_559; // @[Memory.scala 514:14 601:46]
  wire  _GEN_841 = 3'h5 == dcache_state & _T_99; // @[Memory.scala 514:14 543:25]
  wire  _GEN_919 = 3'h3 == dcache_state ? _GEN_565 : _GEN_841; // @[Memory.scala 543:25]
  wire  _GEN_1007 = 3'h4 == dcache_state ? 1'h0 : _GEN_919; // @[Memory.scala 514:14 543:25]
  wire  _GEN_1051 = 3'h2 == dcache_state ? _GEN_565 : _GEN_1007; // @[Memory.scala 543:25]
  wire  _GEN_1139 = 3'h1 == dcache_state ? 1'h0 : _GEN_1051; // @[Memory.scala 514:14 543:25]
  wire  dram_d_ren = 3'h0 == dcache_state ? 1'h0 : _GEN_1139; // @[Memory.scala 514:14 543:25]
  wire [26:0] _GEN_2 = dram_d_ren ? dram_d_addr : reg_dram_addr; // @[Memory.scala 224:35 227:27 186:31]
  wire  _GEN_3 = dram_d_ren ? 1'h0 : reg_dram_di; // @[Memory.scala 224:35 228:25 189:28]
  wire [2:0] _GEN_4 = dram_d_ren ? 3'h2 : reg_dram_state; // @[Memory.scala 224:35 229:28 185:31]
  wire  _GEN_549 = (reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2) & _T_99; // @[Memory.scala 607:111 515:14]
  wire  _GEN_556 = _T_88 ? 1'h0 : _GEN_549; // @[Memory.scala 515:14 604:52]
  wire  _GEN_562 = _T_87 ? 1'h0 : _GEN_556; // @[Memory.scala 515:14 601:46]
  wire  _GEN_1004 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_562; // @[Memory.scala 515:14 543:25]
  wire  _GEN_1048 = 3'h2 == dcache_state ? _GEN_562 : _GEN_1004; // @[Memory.scala 543:25]
  wire  _GEN_1136 = 3'h1 == dcache_state ? 1'h0 : _GEN_1048; // @[Memory.scala 515:14 543:25]
  wire  dram_d_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1136; // @[Memory.scala 515:14 543:25]
  wire [30:0] _GEN_6 = dram_d_wen ? _io_dramPort_addr_T_1 : _io_dramPort_addr_T_1; // @[Memory.scala 215:29 217:30]
  wire [26:0] _GEN_9 = dram_d_wen ? dram_d_addr : _GEN_2; // @[Memory.scala 215:29 220:27]
  wire [127:0] _GEN_10 = dram_d_wen ? dram_d_wdata[255:128] : reg_dram_wdata; // @[Memory.scala 215:29 221:28 187:31]
  wire  _GEN_11 = dram_d_wen ? 1'h0 : _GEN_3; // @[Memory.scala 215:29 222:25]
  wire [2:0] _GEN_12 = dram_d_wen ? 3'h1 : _GEN_4; // @[Memory.scala 215:29 223:28]
  wire  _GEN_13 = dram_d_wen ? 1'h0 : dram_d_ren; // @[Memory.scala 191:19 215:29]
  wire  _GEN_14 = dram_i_ren | _GEN_13; // @[Memory.scala 207:27 208:27]
  wire [30:0] _GEN_15 = dram_i_ren ? _io_dramPort_addr_T : _GEN_6; // @[Memory.scala 207:27 209:28]
  wire  _GEN_17 = dram_i_ren | _GEN_11; // @[Memory.scala 207:27 211:23]
  wire  _GEN_20 = dram_i_ren ? 1'h0 : dram_d_wen; // @[Memory.scala 192:19 207:27]
  wire  _GEN_25 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_14; // @[Memory.scala 191:19 205:67]
  wire  _GEN_28 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? _GEN_17 : reg_dram_di; // @[Memory.scala 189:28 205:67]
  wire  _GEN_31 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_20; // @[Memory.scala 192:19 205:67]
  wire [30:0] _io_dramPort_addr_T_3 = {reg_dram_addr,4'h8}; // @[Cat.scala 33:92]
  wire [127:0] _GEN_40 = io_dramPort_rdata_valid ? io_dramPort_rdata : reg_dram_rdata; // @[Memory.scala 247:40 248:26 188:31]
  wire [2:0] _GEN_41 = io_dramPort_rdata_valid ? 3'h5 : 3'h4; // @[Memory.scala 247:40 249:26 251:26]
  wire [2:0] _GEN_42 = io_dramPort_rdata_valid ? 3'h3 : reg_dram_state; // @[Memory.scala 253:44 255:24 185:31]
  wire [2:0] _GEN_46 = _T_3 ? _GEN_41 : _GEN_42; // @[Memory.scala 244:32]
  wire [2:0] _GEN_49 = _T_3 ? 3'h5 : reg_dram_state; // @[Memory.scala 259:32 262:24 185:31]
  wire [2:0] _GEN_50 = io_dramPort_rdata_valid ? 3'h5 : reg_dram_state; // @[Memory.scala 266:38 268:24 185:31]
  wire [255:0] dram_rdata = {io_dramPort_rdata,reg_dram_rdata}; // @[Cat.scala 33:92]
  wire  _GEN_52 = io_dramPort_rdata_valid & reg_dram_di; // @[Memory.scala 201:22 272:38 276:28]
  wire  _GEN_53 = io_dramPort_rdata_valid & ~reg_dram_di; // @[Memory.scala 202:22 272:38 277:28]
  wire [2:0] _GEN_54 = io_dramPort_rdata_valid ? 3'h0 : reg_dram_state; // @[Memory.scala 272:38 278:24 185:31]
  wire [2:0] _GEN_58 = 3'h5 == reg_dram_state ? _GEN_54 : reg_dram_state; // @[Memory.scala 203:27 185:31]
  wire [127:0] _GEN_59 = 3'h4 == reg_dram_state ? _GEN_40 : reg_dram_rdata; // @[Memory.scala 203:27 188:31]
  wire [2:0] _GEN_60 = 3'h4 == reg_dram_state ? _GEN_50 : _GEN_58; // @[Memory.scala 203:27]
  wire  _GEN_62 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_52; // @[Memory.scala 201:22 203:27]
  wire  _GEN_63 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_53; // @[Memory.scala 202:22 203:27]
  wire  _GEN_64 = 3'h3 == reg_dram_state & _T_3; // @[Memory.scala 191:19 203:27]
  wire [2:0] _GEN_66 = 3'h3 == reg_dram_state ? _GEN_49 : _GEN_60; // @[Memory.scala 203:27]
  wire [127:0] _GEN_67 = 3'h3 == reg_dram_state ? reg_dram_rdata : _GEN_59; // @[Memory.scala 203:27 188:31]
  wire  _GEN_69 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_62; // @[Memory.scala 201:22 203:27]
  wire  _GEN_70 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_63; // @[Memory.scala 202:22 203:27]
  wire  _GEN_71 = 3'h2 == reg_dram_state ? _T_3 : _GEN_64; // @[Memory.scala 203:27]
  wire [30:0] _GEN_72 = 3'h2 == reg_dram_state ? _io_dramPort_addr_T_3 : _io_dramPort_addr_T_3; // @[Memory.scala 203:27]
  wire  _GEN_76 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_69; // @[Memory.scala 201:22 203:27]
  wire  _GEN_77 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_70; // @[Memory.scala 202:22 203:27]
  wire  _GEN_78 = 3'h1 == reg_dram_state & _T_3; // @[Memory.scala 192:19 203:27]
  wire [30:0] _GEN_79 = 3'h1 == reg_dram_state ? _io_dramPort_addr_T_3 : _GEN_72; // @[Memory.scala 203:27]
  wire  _GEN_83 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_71; // @[Memory.scala 191:19 203:27]
  wire  _GEN_86 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_76; // @[Memory.scala 201:22 203:27]
  wire  _GEN_87 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_77; // @[Memory.scala 202:22 203:27]
  wire [30:0] _GEN_90 = 3'h0 == reg_dram_state ? _GEN_15 : _GEN_79; // @[Memory.scala 203:27]
  wire  _GEN_92 = 3'h0 == reg_dram_state ? _GEN_28 : reg_dram_di; // @[Memory.scala 203:27 189:28]
  wire  dram_i_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_86; // @[Memory.scala 201:22 203:27]
  wire  dram_d_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_87; // @[Memory.scala 202:22 203:27]
  reg [15:0] i_reg_tag_0; // @[Memory.scala 286:26]
  reg [255:0] i_reg_line; // @[Memory.scala 287:27]
  reg [4:0] i_reg_req_addr_line_off; // @[Memory.scala 288:31]
  reg [15:0] i_reg_next_addr_tag; // @[Memory.scala 289:32]
  reg [6:0] i_reg_next_addr_index; // @[Memory.scala 289:32]
  reg [4:0] i_reg_next_addr_line_off; // @[Memory.scala 289:32]
  reg [1:0] i_reg_valid_rdata; // @[Memory.scala 290:34]
  reg [22:0] i_reg_cur_tag_index; // @[Memory.scala 291:36]
  reg  i_reg_addr_match; // @[Memory.scala 292:33]
  wire [9:0] _io_icache_raddr_T_1 = {io_imem_addr[11:5],io_imem_addr[4:2]}; // @[Cat.scala 33:92]
  wire [22:0] _T_26 = {io_imem_addr[27:12],io_imem_addr[11:5]}; // @[Cat.scala 33:92]
  wire [1:0] _GEN_103 = i_reg_cur_tag_index == _T_26 ? 2'h2 : 2'h1; // @[Memory.scala 336:74 337:24 339:24]
  wire  _GEN_117 = io_cache_iinvalidate ? 1'h0 : io_imem_en; // @[Memory.scala 283:24 325:35]
  wire  _i_reg_addr_match_T_3 = i_reg_req_addr_index == io_imem_addr[11:5]; // @[Memory.scala 348:32]
  wire  _i_reg_addr_match_T_4 = i_reg_req_addr_tag == io_imem_addr[27:12] & _i_reg_addr_match_T_3; // @[Memory.scala 347:111]
  wire  _i_reg_addr_match_T_7 = i_reg_req_addr_line_off[4:2] == io_imem_addr[4:2]; // @[Memory.scala 349:57]
  wire  _i_reg_addr_match_T_8 = _i_reg_addr_match_T_4 & _i_reg_addr_match_T_7; // @[Memory.scala 348:54]
  wire [1:0] _T_32 = io_icache_valid_rdata >> i_reg_req_addr_index[0]; // @[Memory.scala 350:36]
  wire  _T_36 = _T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag; // @[Memory.scala 350:105]
  wire [9:0] _io_icache_raddr_T_3 = {i_reg_req_addr_index,i_reg_req_addr_line_off[4:2]}; // @[Cat.scala 33:92]
  wire [15:0] _GEN_128 = io_imem_en ? i_tag_array_0_MPORT_1_data : i_reg_tag_0; // @[Memory.scala 373:31 374:19 286:26]
  wire [1:0] _GEN_131 = io_imem_en ? _GEN_103 : 2'h0; // @[Memory.scala 373:31 385:22]
  wire [2:0] _GEN_132 = io_cache_iinvalidate ? 3'h7 : {{1'd0}, _GEN_131}; // @[Memory.scala 368:35 372:22]
  wire [15:0] _GEN_134 = io_cache_iinvalidate ? i_reg_tag_0 : _GEN_128; // @[Memory.scala 286:26 368:35]
  wire [27:0] _dcache_snoop_addr_T = {i_reg_req_addr_tag,i_reg_req_addr_index,i_reg_req_addr_line_off}; // @[Memory.scala 392:47]
  wire [4:0] dcache_snoop_addr_line_off = _dcache_snoop_addr_T[4:0]; // @[Memory.scala 392:62]
  wire [6:0] dcache_snoop_addr_index = _dcache_snoop_addr_T[11:5]; // @[Memory.scala 392:62]
  wire [15:0] dcache_snoop_addr_tag = _dcache_snoop_addr_T[27:12]; // @[Memory.scala 392:62]
  wire [1:0] _icache_valid_wdata_T_1 = 2'h1 << i_reg_req_addr_index[0]; // @[Memory.scala 403:62]
  wire [1:0] icache_valid_wdata = i_reg_valid_rdata | _icache_valid_wdata_T_1; // @[Memory.scala 403:55]
  wire [2:0] _GEN_139 = ~dram_i_busy ? 3'h6 : 3'h3; // @[Memory.scala 410:31 413:26 415:26]
  wire [2:0] _GEN_142 = 2'h2 == dcache_snoop_status ? _GEN_139 : icache_state; // @[Memory.scala 285:29 389:36]
  wire [255:0] dcache_snoop_line = reg_tag_0 == reg_req_addr_tag ? io_cache_array1_rdata : io_cache_array2_rdata; // @[Memory.scala 583:46 584:27]
  wire [255:0] _GEN_143 = 2'h1 == dcache_snoop_status ? dcache_snoop_line : i_reg_line; // @[Memory.scala 389:36 395:22 287:27]
  wire [22:0] _GEN_152 = 2'h1 == dcache_snoop_status ? _dram_i_addr_T_1 : i_reg_cur_tag_index; // @[Memory.scala 389:36 405:31 291:36]
  wire [1:0] _GEN_153 = 2'h1 == dcache_snoop_status ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 389:36 406:29 290:34]
  wire [2:0] _GEN_154 = 2'h1 == dcache_snoop_status ? 3'h5 : _GEN_142; // @[Memory.scala 389:36 407:24]
  wire [255:0] _GEN_161 = 2'h0 == dcache_snoop_status ? i_reg_line : _GEN_143; // @[Memory.scala 287:27 389:36]
  wire  _GEN_164 = 2'h0 == dcache_snoop_status ? 1'h0 : 2'h1 == dcache_snoop_status; // @[Memory.scala 283:24 389:36]
  wire [22:0] _GEN_170 = 2'h0 == dcache_snoop_status ? i_reg_cur_tag_index : _GEN_152; // @[Memory.scala 291:36 389:36]
  wire [1:0] _GEN_171 = 2'h0 == dcache_snoop_status ? i_reg_valid_rdata : _GEN_153; // @[Memory.scala 290:34 389:36]
  wire [2:0] _GEN_172 = 2'h0 == dcache_snoop_status ? icache_state : _GEN_154; // @[Memory.scala 285:29 389:36]
  wire [7:0] _io_imem_inst_T_1 = {i_reg_next_addr_line_off[4:2],5'h0}; // @[Cat.scala 33:92]
  wire [255:0] _io_imem_inst_T_2 = i_reg_line >> _io_imem_inst_T_1; // @[Memory.scala 421:35]
  wire  _T_61 = i_reg_req_addr_index == i_reg_next_addr_index; // @[Memory.scala 423:32]
  wire  _T_62 = i_reg_req_addr_tag == i_reg_next_addr_tag & _T_61; // @[Memory.scala 422:100]
  wire [15:0] _GEN_178 = io_imem_en ? i_tag_array_0_MPORT_3_data : i_reg_tag_0; // @[Memory.scala 429:25 430:19 286:26]
  wire [2:0] _GEN_184 = _T_54 ? 3'h6 : icache_state; // @[Memory.scala 445:27 448:22 285:29]
  wire [255:0] _io_imem_inst_T_6 = dram_rdata >> _io_imem_inst_T_1; // @[Memory.scala 454:31]
  wire [31:0] _GEN_186 = dram_i_rdata_valid ? _io_imem_inst_T_6[31:0] : 32'hdeadbeef; // @[Memory.scala 299:16 452:33 454:22]
  wire  _GEN_187 = dram_i_rdata_valid & _T_62; // @[Memory.scala 300:17 452:33]
  wire [22:0] _GEN_196 = dram_i_rdata_valid ? _dram_i_addr_T_1 : i_reg_cur_tag_index; // @[Memory.scala 452:33 468:29 291:36]
  wire [1:0] _GEN_197 = dram_i_rdata_valid ? icache_valid_wdata : i_reg_valid_rdata; // @[Memory.scala 452:33 469:27 290:34]
  wire [2:0] _GEN_198 = dram_i_rdata_valid ? 3'h0 : icache_state; // @[Memory.scala 452:33 470:22 285:29]
  wire [15:0] _GEN_200 = io_imem_en ? i_tag_array_0_MPORT_5_data : i_reg_tag_0; // @[Memory.scala 482:25 483:19 286:26]
  wire [1:0] _GEN_203 = io_imem_en ? 2'h2 : 2'h0; // @[Memory.scala 482:25 488:22 490:22]
  wire [22:0] _GEN_208 = 3'h7 == icache_state ? 23'h7fffff : i_reg_cur_tag_index; // @[Memory.scala 320:25 478:27 291:36]
  wire [15:0] _GEN_209 = 3'h7 == icache_state ? io_imem_addr[27:12] : i_reg_req_addr_tag; // @[Memory.scala 320:25 480:22 288:31]
  wire [6:0] _GEN_210 = 3'h7 == icache_state ? io_imem_addr[11:5] : i_reg_req_addr_index; // @[Memory.scala 320:25 480:22 288:31]
  wire [4:0] _GEN_211 = 3'h7 == icache_state ? io_imem_addr[4:0] : i_reg_req_addr_line_off; // @[Memory.scala 320:25 480:22 288:31]
  wire  _GEN_212 = 3'h7 == icache_state | i_reg_addr_match; // @[Memory.scala 320:25 481:24 292:33]
  wire  _GEN_215 = 3'h7 == icache_state & io_imem_en; // @[Memory.scala 283:24 320:25]
  wire [15:0] _GEN_216 = 3'h7 == icache_state ? _GEN_200 : i_reg_tag_0; // @[Memory.scala 320:25 286:26]
  wire [2:0] _GEN_219 = 3'h7 == icache_state ? {{1'd0}, _GEN_203} : icache_state; // @[Memory.scala 320:25 285:29]
  wire [31:0] _GEN_220 = 3'h6 == icache_state ? _GEN_186 : 32'hdeadbeef; // @[Memory.scala 299:16 320:25]
  wire  _GEN_228 = 3'h6 == icache_state ? dram_i_rdata_valid : _GEN_215; // @[Memory.scala 320:25]
  wire [5:0] _GEN_229 = 3'h6 == icache_state ? i_reg_req_addr_index[6:1] : io_imem_addr[11:6]; // @[Memory.scala 320:25]
  wire [22:0] _GEN_231 = 3'h6 == icache_state ? _GEN_196 : _GEN_208; // @[Memory.scala 320:25]
  wire [1:0] _GEN_232 = 3'h6 == icache_state ? _GEN_197 : i_reg_valid_rdata; // @[Memory.scala 320:25 290:34]
  wire [2:0] _GEN_233 = 3'h6 == icache_state ? _GEN_198 : _GEN_219; // @[Memory.scala 320:25]
  wire  _GEN_235 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state; // @[Memory.scala 320:25 314:30]
  wire [15:0] _GEN_238 = 3'h6 == icache_state ? i_reg_req_addr_tag : _GEN_209; // @[Memory.scala 320:25 288:31]
  wire [6:0] _GEN_239 = 3'h6 == icache_state ? i_reg_req_addr_index : _GEN_210; // @[Memory.scala 320:25 288:31]
  wire [4:0] _GEN_240 = 3'h6 == icache_state ? i_reg_req_addr_line_off : _GEN_211; // @[Memory.scala 320:25 288:31]
  wire  _GEN_241 = 3'h6 == icache_state ? i_reg_addr_match : _GEN_212; // @[Memory.scala 320:25 292:33]
  wire  _GEN_244 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state & io_imem_en; // @[Memory.scala 283:24 320:25]
  wire [15:0] _GEN_245 = 3'h6 == icache_state ? i_reg_tag_0 : _GEN_216; // @[Memory.scala 320:25 286:26]
  wire [2:0] _GEN_249 = 3'h3 == icache_state ? _GEN_184 : _GEN_233; // @[Memory.scala 320:25]
  wire [31:0] _GEN_250 = 3'h3 == icache_state ? 32'hdeadbeef : _GEN_220; // @[Memory.scala 299:16 320:25]
  wire  _GEN_251 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & _GEN_187; // @[Memory.scala 300:17 320:25]
  wire  _GEN_254 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & dram_i_rdata_valid; // @[Memory.scala 283:24 320:25]
  wire  _GEN_258 = 3'h3 == icache_state ? 1'h0 : _GEN_228; // @[Memory.scala 312:23 320:25]
  wire [22:0] _GEN_261 = 3'h3 == icache_state ? i_reg_cur_tag_index : _GEN_231; // @[Memory.scala 320:25 291:36]
  wire [1:0] _GEN_262 = 3'h3 == icache_state ? i_reg_valid_rdata : _GEN_232; // @[Memory.scala 320:25 290:34]
  wire  _GEN_264 = 3'h3 == icache_state ? 1'h0 : _GEN_235; // @[Memory.scala 320:25 314:30]
  wire [15:0] _GEN_267 = 3'h3 == icache_state ? i_reg_req_addr_tag : _GEN_238; // @[Memory.scala 320:25 288:31]
  wire [6:0] _GEN_268 = 3'h3 == icache_state ? i_reg_req_addr_index : _GEN_239; // @[Memory.scala 320:25 288:31]
  wire [4:0] _GEN_269 = 3'h3 == icache_state ? i_reg_req_addr_line_off : _GEN_240; // @[Memory.scala 320:25 288:31]
  wire  _GEN_270 = 3'h3 == icache_state ? i_reg_addr_match : _GEN_241; // @[Memory.scala 320:25 292:33]
  wire  _GEN_273 = 3'h3 == icache_state ? 1'h0 : _GEN_244; // @[Memory.scala 283:24 320:25]
  wire [15:0] _GEN_274 = 3'h3 == icache_state ? i_reg_tag_0 : _GEN_245; // @[Memory.scala 320:25 286:26]
  wire [31:0] _GEN_276 = 3'h5 == icache_state ? _io_imem_inst_T_2[31:0] : _GEN_250; // @[Memory.scala 320:25 421:20]
  wire  _GEN_277 = 3'h5 == icache_state ? _T_62 : _GEN_251; // @[Memory.scala 320:25]
  wire [15:0] _GEN_278 = 3'h5 == icache_state ? io_imem_addr[27:12] : _GEN_267; // @[Memory.scala 320:25 427:22]
  wire [6:0] _GEN_279 = 3'h5 == icache_state ? io_imem_addr[11:5] : _GEN_268; // @[Memory.scala 320:25 427:22]
  wire [4:0] _GEN_280 = 3'h5 == icache_state ? io_imem_addr[4:0] : _GEN_269; // @[Memory.scala 320:25 427:22]
  wire  _GEN_281 = 3'h5 == icache_state | _GEN_270; // @[Memory.scala 320:25 428:24]
  wire [15:0] _GEN_285 = 3'h5 == icache_state ? _GEN_178 : _GEN_274; // @[Memory.scala 320:25]
  wire  _GEN_286 = 3'h5 == icache_state ? io_imem_en : _GEN_273; // @[Memory.scala 320:25]
  wire [9:0] _GEN_287 = 3'h5 == icache_state ? _io_icache_raddr_T_1 : _io_icache_raddr_T_1; // @[Memory.scala 320:25]
  wire  _GEN_288 = 3'h5 == icache_state ? io_imem_en : _GEN_258; // @[Memory.scala 320:25]
  wire [5:0] _GEN_289 = 3'h5 == icache_state ? io_imem_addr[11:6] : _GEN_229; // @[Memory.scala 320:25]
  wire [2:0] _GEN_290 = 3'h5 == icache_state ? {{1'd0}, _GEN_131} : _GEN_249; // @[Memory.scala 320:25]
  wire  _GEN_295 = 3'h5 == icache_state ? 1'h0 : _GEN_254; // @[Memory.scala 283:24 320:25]
  wire [22:0] _GEN_300 = 3'h5 == icache_state ? i_reg_cur_tag_index : _GEN_261; // @[Memory.scala 320:25 291:36]
  wire [1:0] _GEN_301 = 3'h5 == icache_state ? i_reg_valid_rdata : _GEN_262; // @[Memory.scala 320:25 290:34]
  wire  _GEN_303 = 3'h5 == icache_state ? 1'h0 : _GEN_264; // @[Memory.scala 320:25 314:30]
  wire  _GEN_308 = 3'h5 == icache_state ? 1'h0 : _GEN_273; // @[Memory.scala 283:24 320:25]
  wire [255:0] _GEN_313 = 3'h4 == icache_state ? _GEN_161 : i_reg_line; // @[Memory.scala 320:25 287:27]
  wire  _GEN_319 = 3'h4 == icache_state ? _GEN_164 : _GEN_295; // @[Memory.scala 320:25]
  wire  _GEN_322 = 3'h4 == icache_state ? _GEN_164 : _GEN_288; // @[Memory.scala 320:25]
  wire [5:0] _GEN_323 = 3'h4 == icache_state ? i_reg_req_addr_index[6:1] : _GEN_289; // @[Memory.scala 320:25]
  wire [22:0] _GEN_325 = 3'h4 == icache_state ? _GEN_170 : _GEN_300; // @[Memory.scala 320:25]
  wire [1:0] _GEN_326 = 3'h4 == icache_state ? _GEN_171 : _GEN_301; // @[Memory.scala 320:25]
  wire [2:0] _GEN_327 = 3'h4 == icache_state ? _GEN_172 : _GEN_290; // @[Memory.scala 320:25]
  wire [31:0] _GEN_330 = 3'h4 == icache_state ? 32'hdeadbeef : _GEN_276; // @[Memory.scala 299:16 320:25]
  wire  _GEN_331 = 3'h4 == icache_state ? 1'h0 : _GEN_277; // @[Memory.scala 300:17 320:25]
  wire [15:0] _GEN_332 = 3'h4 == icache_state ? i_reg_req_addr_tag : _GEN_278; // @[Memory.scala 320:25 288:31]
  wire [6:0] _GEN_333 = 3'h4 == icache_state ? i_reg_req_addr_index : _GEN_279; // @[Memory.scala 320:25 288:31]
  wire [4:0] _GEN_334 = 3'h4 == icache_state ? i_reg_req_addr_line_off : _GEN_280; // @[Memory.scala 320:25 288:31]
  wire  _GEN_335 = 3'h4 == icache_state ? i_reg_addr_match : _GEN_281; // @[Memory.scala 320:25 292:33]
  wire  _GEN_338 = 3'h4 == icache_state ? 1'h0 : 3'h5 == icache_state & io_imem_en; // @[Memory.scala 283:24 320:25]
  wire [15:0] _GEN_339 = 3'h4 == icache_state ? i_reg_tag_0 : _GEN_285; // @[Memory.scala 320:25 286:26]
  wire  _GEN_340 = 3'h4 == icache_state ? 1'h0 : _GEN_286; // @[Memory.scala 307:17 320:25]
  wire  _GEN_344 = 3'h4 == icache_state ? 1'h0 : _GEN_295; // @[Memory.scala 283:24 320:25]
  wire  _GEN_348 = 3'h4 == icache_state ? 1'h0 : _GEN_303; // @[Memory.scala 320:25 314:30]
  wire  _GEN_353 = 3'h4 == icache_state ? 1'h0 : _GEN_308; // @[Memory.scala 283:24 320:25]
  wire [31:0] _GEN_354 = 3'h2 == icache_state ? io_icache_rdata : _GEN_330; // @[Memory.scala 320:25 360:20]
  wire  _GEN_355 = 3'h2 == icache_state ? i_reg_addr_match : _GEN_331; // @[Memory.scala 320:25]
  wire  _GEN_356 = 3'h2 == icache_state ? 1'h0 : 1'h1; // @[Memory.scala 320:25 364:22]
  wire  _GEN_360 = 3'h2 == icache_state | _GEN_335; // @[Memory.scala 320:25 367:24]
  wire  _GEN_361 = 3'h2 == icache_state ? io_cache_iinvalidate : _GEN_348; // @[Memory.scala 320:25]
  wire  _GEN_369 = 3'h2 == icache_state ? _GEN_117 : _GEN_340; // @[Memory.scala 320:25]
  wire [9:0] _GEN_370 = 3'h2 == icache_state ? _io_icache_raddr_T_1 : _GEN_287; // @[Memory.scala 320:25]
  wire  _GEN_371 = 3'h2 == icache_state ? _GEN_117 : _GEN_322; // @[Memory.scala 320:25]
  wire [5:0] _GEN_372 = 3'h2 == icache_state ? io_imem_addr[11:6] : _GEN_323; // @[Memory.scala 320:25]
  wire  _GEN_373 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _T_47; // @[Memory.scala 303:19 320:25]
  wire  _GEN_380 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _GEN_164; // @[Memory.scala 283:24 320:25]
  wire  _GEN_383 = 3'h2 == icache_state ? 1'h0 : _GEN_319; // @[Memory.scala 308:17 320:25]
  wire  _GEN_393 = 3'h2 == icache_state ? 1'h0 : _GEN_338; // @[Memory.scala 283:24 320:25]
  wire  _GEN_396 = 3'h2 == icache_state ? 1'h0 : _GEN_344; // @[Memory.scala 283:24 320:25]
  wire  _GEN_401 = 3'h2 == icache_state ? 1'h0 : _GEN_353; // @[Memory.scala 283:24 320:25]
  wire  _GEN_403 = 3'h1 == icache_state ? _i_reg_addr_match_T_8 : _GEN_360; // @[Memory.scala 320:25 347:24]
  wire  _GEN_404 = 3'h1 == icache_state ? _T_36 : _GEN_369; // @[Memory.scala 320:25]
  wire [9:0] _GEN_405 = 3'h1 == icache_state ? _io_icache_raddr_T_3 : _GEN_370; // @[Memory.scala 320:25]
  wire [31:0] _GEN_408 = 3'h1 == icache_state ? 32'hdeadbeef : _GEN_354; // @[Memory.scala 299:16 320:25]
  wire  _GEN_409 = 3'h1 == icache_state ? 1'h0 : _GEN_355; // @[Memory.scala 300:17 320:25]
  wire  _GEN_410 = 3'h1 == icache_state | _GEN_356; // @[Memory.scala 301:18 320:25]
  wire  _GEN_414 = 3'h1 == icache_state ? 1'h0 : _GEN_361; // @[Memory.scala 320:25 314:30]
  wire  _GEN_419 = 3'h1 == icache_state ? 1'h0 : 3'h2 == icache_state & _GEN_117; // @[Memory.scala 283:24 320:25]
  wire  _GEN_421 = 3'h1 == icache_state ? 1'h0 : _GEN_371; // @[Memory.scala 312:23 320:25]
  wire  _GEN_423 = 3'h1 == icache_state ? 1'h0 : _GEN_373; // @[Memory.scala 303:19 320:25]
  wire  _GEN_430 = 3'h1 == icache_state ? 1'h0 : _GEN_380; // @[Memory.scala 283:24 320:25]
  wire  _GEN_433 = 3'h1 == icache_state ? 1'h0 : _GEN_383; // @[Memory.scala 308:17 320:25]
  wire  _GEN_441 = 3'h1 == icache_state ? 1'h0 : _GEN_393; // @[Memory.scala 283:24 320:25]
  wire  _GEN_444 = 3'h1 == icache_state ? 1'h0 : _GEN_396; // @[Memory.scala 283:24 320:25]
  wire  _GEN_449 = 3'h1 == icache_state ? 1'h0 : _GEN_401; // @[Memory.scala 283:24 320:25]
  wire  _GEN_466 = 3'h0 == icache_state | _GEN_403; // @[Memory.scala 320:25 342:24]
  wire  dcache_snoop_en = 3'h0 == icache_state ? 1'h0 : _GEN_423; // @[Memory.scala 303:19 320:25]
  reg [4:0] reg_req_addr_line_off; // @[Memory.scala 503:29]
  reg [31:0] reg_wdata; // @[Memory.scala 504:26]
  reg [3:0] reg_wstrb; // @[Memory.scala 505:26]
  reg  reg_ren; // @[Memory.scala 506:24]
  reg [31:0] reg_read_word; // @[Memory.scala 508:30]
  wire [31:0] _req_addr_T_12 = io_cache_ren ? io_cache_raddr : io_cache_waddr; // @[Memory.scala 559:27]
  wire [4:0] req_addr_4_line_off = _req_addr_T_12[4:0]; // @[Memory.scala 559:82]
  wire [6:0] req_addr_4_index = _req_addr_T_12[11:5]; // @[Memory.scala 559:82]
  wire [15:0] req_addr_4_tag = _req_addr_T_12[27:12]; // @[Memory.scala 559:82]
  wire  _T_83 = io_cache_ren | io_cache_wen; // @[Memory.scala 564:28]
  wire [1:0] _GEN_501 = io_cache_ren ? 2'h2 : 2'h3; // @[Memory.scala 574:31 575:26 577:26]
  wire [15:0] _GEN_512 = dcache_snoop_en ? dcache_snoop_addr_tag : req_addr_4_tag; // @[Memory.scala 545:30 547:22 560:22]
  wire [6:0] _GEN_513 = dcache_snoop_en ? dcache_snoop_addr_index : req_addr_4_index; // @[Memory.scala 545:30 547:22 560:22]
  wire [4:0] _GEN_514 = dcache_snoop_en ? dcache_snoop_addr_line_off : req_addr_4_line_off; // @[Memory.scala 545:30 547:22 560:22]
  wire  _GEN_520 = dcache_snoop_en | _T_83; // @[Memory.scala 545:30 549:28]
  wire  _GEN_524 = dcache_snoop_en ? 1'h0 : 1'h1; // @[Memory.scala 510:19 545:30 557:25]
  wire [31:0] _GEN_525 = dcache_snoop_en ? reg_wdata : io_cache_wdata; // @[Memory.scala 504:26 545:30 561:19]
  wire [3:0] _GEN_526 = dcache_snoop_en ? reg_wstrb : io_cache_wstrb; // @[Memory.scala 505:26 545:30 562:19]
  wire  _GEN_527 = dcache_snoop_en ? reg_ren : io_cache_ren; // @[Memory.scala 506:24 545:30 563:17]
  wire  _GEN_530 = dcache_snoop_en ? 1'h0 : _T_83; // @[Memory.scala 495:22 545:30]
  wire [7:0] _reg_read_word_T_1 = {reg_req_addr_line_off[4:2],5'h0}; // @[Cat.scala 33:92]
  wire [255:0] _reg_read_word_T_2 = line1 >> _reg_read_word_T_1; // @[Memory.scala 602:33]
  wire [255:0] _reg_read_word_T_6 = line2 >> _reg_read_word_T_1; // @[Memory.scala 605:33]
  wire [2:0] _GEN_545 = ~dram_d_busy ? 3'h5 : dcache_state; // @[Memory.scala 608:29 617:24 498:29]
  wire [2:0] _GEN_548 = _T_99 ? 3'h6 : dcache_state; // @[Memory.scala 620:29 623:24 498:29]
  wire [2:0] _GEN_552 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_545 : _GEN_548; // @[Memory.scala 607:111]
  wire [31:0] _GEN_554 = _T_88 ? _reg_read_word_T_6[31:0] : reg_read_word; // @[Memory.scala 604:52 605:23 508:30]
  wire [2:0] _GEN_555 = _T_88 ? 3'h4 : _GEN_552; // @[Memory.scala 604:52 606:22]
  wire [31:0] _GEN_560 = _T_87 ? _reg_read_word_T_2[31:0] : _GEN_554; // @[Memory.scala 601:46 602:23]
  wire [2:0] _GEN_561 = _T_87 ? 3'h4 : _GEN_555; // @[Memory.scala 601:46 603:22]
  wire [15:0] _GEN_569 = _T_83 ? tag_array_0_MPORT_9_data : reg_tag_0; // @[Memory.scala 649:45 650:19 499:24]
  wire [15:0] _GEN_570 = _T_83 ? tag_array_1_MPORT_9_data : reg_tag_1; // @[Memory.scala 649:45 650:19 499:24]
  wire  _GEN_572 = _T_83 ? lru_array_way_hot_reg_lru_MPORT_1_data : reg_lru_way_hot; // @[Memory.scala 649:45 658:19 502:24]
  wire  _GEN_573 = _T_83 ? lru_array_dirty1_reg_lru_MPORT_1_data : reg_lru_dirty1; // @[Memory.scala 649:45 658:19 502:24]
  wire  _GEN_574 = _T_83 ? lru_array_dirty2_reg_lru_MPORT_1_data : reg_lru_dirty2; // @[Memory.scala 649:45 658:19 502:24]
  wire [1:0] _GEN_575 = _T_83 ? _GEN_501 : 2'h0; // @[Memory.scala 649:45 665:24]
  wire [15:0] _GEN_579 = dcache_snoop_en ? tag_array_0_MPORT_8_data : _GEN_569; // @[Memory.scala 630:30 633:17]
  wire [15:0] _GEN_580 = dcache_snoop_en ? tag_array_1_MPORT_8_data : _GEN_570; // @[Memory.scala 630:30 633:17]
  wire [1:0] _GEN_584 = dcache_snoop_en ? 2'h1 : _GEN_575; // @[Memory.scala 630:30 640:22]
  wire  _GEN_588 = dcache_snoop_en ? reg_lru_way_hot : _GEN_572; // @[Memory.scala 502:24 630:30]
  wire  _GEN_589 = dcache_snoop_en ? reg_lru_dirty1 : _GEN_573; // @[Memory.scala 502:24 630:30]
  wire  _GEN_590 = dcache_snoop_en ? reg_lru_dirty2 : _GEN_574; // @[Memory.scala 502:24 630:30]
  wire [4:0] _wstrb_T_1 = {reg_req_addr_line_off[4:2],2'h0}; // @[Cat.scala 33:92]
  wire [31:0] _wstrb_T_3 = {28'h0,reg_wstrb}; // @[Memory.scala 537:37]
  wire [62:0] _GEN_0 = {{31'd0}, _wstrb_T_3}; // @[Memory.scala 540:30]
  wire [62:0] _wstrb_T_4 = _GEN_0 << _wstrb_T_1; // @[Memory.scala 540:30]
  wire [31:0] wstrb = _wstrb_T_4[31:0]; // @[Memory.scala 540:39]
  wire [255:0] _wdata_T_1 = {224'h0,reg_wdata}; // @[Memory.scala 534:42]
  wire [510:0] _GEN_1 = {{255'd0}, _wdata_T_1}; // @[Memory.scala 678:46]
  wire [510:0] _wdata_T_4 = _GEN_1 << _reg_read_word_T_1; // @[Memory.scala 678:46]
  wire [255:0] wdata = _wdata_T_4[255:0]; // @[Memory.scala 678:108]
  wire [2:0] _T_110 = {2'h1,reg_lru_dirty2}; // @[Cat.scala 33:92]
  wire [2:0] _T_115 = {1'h1,reg_lru_dirty1,1'h1}; // @[Cat.scala 33:92]
  wire [2:0] _GEN_614 = _T_88 ? 3'h0 : _GEN_552; // @[Memory.scala 685:52 693:22]
  wire [2:0] _GEN_628 = _T_87 ? 3'h0 : _GEN_614; // @[Memory.scala 676:46 684:22]
  wire  _GEN_629 = _T_87 ? 1'h0 : _T_88; // @[Memory.scala 522:25 676:46]
  wire [255:0] _io_cache_rdata_T_2 = dram_rdata >> _reg_read_word_T_1; // @[Memory.scala 726:33]
  wire  _T_135 = reg_lru_way_hot & reg_ren; // @[Memory.scala 730:39]
  wire [2:0] _T_136 = {2'h0,reg_lru_dirty2}; // @[Cat.scala 33:92]
  wire  _T_141 = _T_96 & reg_ren; // @[Memory.scala 737:45]
  wire [2:0] _T_142 = {1'h1,reg_lru_dirty1,1'h0}; // @[Cat.scala 33:92]
  wire [7:0] _io_cache_array1_wdata_T_3 = wstrb[0] ? _wdata_T_4[7:0] : dram_rdata[7:0]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_7 = wstrb[1] ? _wdata_T_4[15:8] : dram_rdata[15:8]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_11 = wstrb[2] ? _wdata_T_4[23:16] : dram_rdata[23:16]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_15 = wstrb[3] ? _wdata_T_4[31:24] : dram_rdata[31:24]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_19 = wstrb[4] ? _wdata_T_4[39:32] : dram_rdata[39:32]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_23 = wstrb[5] ? _wdata_T_4[47:40] : dram_rdata[47:40]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_27 = wstrb[6] ? _wdata_T_4[55:48] : dram_rdata[55:48]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_31 = wstrb[7] ? _wdata_T_4[63:56] : dram_rdata[63:56]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_35 = wstrb[8] ? _wdata_T_4[71:64] : dram_rdata[71:64]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_39 = wstrb[9] ? _wdata_T_4[79:72] : dram_rdata[79:72]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_43 = wstrb[10] ? _wdata_T_4[87:80] : dram_rdata[87:80]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_47 = wstrb[11] ? _wdata_T_4[95:88] : dram_rdata[95:88]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_51 = wstrb[12] ? _wdata_T_4[103:96] : dram_rdata[103:96]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_55 = wstrb[13] ? _wdata_T_4[111:104] : dram_rdata[111:104]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_59 = wstrb[14] ? _wdata_T_4[119:112] : dram_rdata[119:112]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_63 = wstrb[15] ? _wdata_T_4[127:120] : dram_rdata[127:120]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_67 = wstrb[16] ? _wdata_T_4[135:128] : dram_rdata[135:128]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_71 = wstrb[17] ? _wdata_T_4[143:136] : dram_rdata[143:136]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_75 = wstrb[18] ? _wdata_T_4[151:144] : dram_rdata[151:144]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_79 = wstrb[19] ? _wdata_T_4[159:152] : dram_rdata[159:152]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_83 = wstrb[20] ? _wdata_T_4[167:160] : dram_rdata[167:160]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_87 = wstrb[21] ? _wdata_T_4[175:168] : dram_rdata[175:168]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_91 = wstrb[22] ? _wdata_T_4[183:176] : dram_rdata[183:176]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_95 = wstrb[23] ? _wdata_T_4[191:184] : dram_rdata[191:184]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_99 = wstrb[24] ? _wdata_T_4[199:192] : dram_rdata[199:192]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_103 = wstrb[25] ? _wdata_T_4[207:200] : dram_rdata[207:200]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_107 = wstrb[26] ? _wdata_T_4[215:208] : dram_rdata[215:208]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_111 = wstrb[27] ? _wdata_T_4[223:216] : dram_rdata[223:216]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_115 = wstrb[28] ? _wdata_T_4[231:224] : dram_rdata[231:224]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_119 = wstrb[29] ? _wdata_T_4[239:232] : dram_rdata[239:232]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_123 = wstrb[30] ? _wdata_T_4[247:240] : dram_rdata[247:240]; // @[Memory.scala 753:18]
  wire [7:0] _io_cache_array1_wdata_T_127 = wstrb[31] ? _wdata_T_4[255:248] : dram_rdata[255:248]; // @[Memory.scala 753:18]
  wire [63:0] io_cache_array1_wdata_lo_lo = {_io_cache_array1_wdata_T_31,_io_cache_array1_wdata_T_27,
    _io_cache_array1_wdata_T_23,_io_cache_array1_wdata_T_19,_io_cache_array1_wdata_T_15,_io_cache_array1_wdata_T_11,
    _io_cache_array1_wdata_T_7,_io_cache_array1_wdata_T_3}; // @[Cat.scala 33:92]
  wire [127:0] io_cache_array1_wdata_lo = {_io_cache_array1_wdata_T_63,_io_cache_array1_wdata_T_59,
    _io_cache_array1_wdata_T_55,_io_cache_array1_wdata_T_51,_io_cache_array1_wdata_T_47,_io_cache_array1_wdata_T_43,
    _io_cache_array1_wdata_T_39,_io_cache_array1_wdata_T_35,io_cache_array1_wdata_lo_lo}; // @[Cat.scala 33:92]
  wire [63:0] io_cache_array1_wdata_hi_lo = {_io_cache_array1_wdata_T_95,_io_cache_array1_wdata_T_91,
    _io_cache_array1_wdata_T_87,_io_cache_array1_wdata_T_83,_io_cache_array1_wdata_T_79,_io_cache_array1_wdata_T_75,
    _io_cache_array1_wdata_T_71,_io_cache_array1_wdata_T_67}; // @[Cat.scala 33:92]
  wire [255:0] _io_cache_array1_wdata_T_128 = {_io_cache_array1_wdata_T_127,_io_cache_array1_wdata_T_123,
    _io_cache_array1_wdata_T_119,_io_cache_array1_wdata_T_115,_io_cache_array1_wdata_T_111,_io_cache_array1_wdata_T_107,
    _io_cache_array1_wdata_T_103,_io_cache_array1_wdata_T_99,io_cache_array1_wdata_hi_lo,io_cache_array1_wdata_lo}; // @[Cat.scala 33:92]
  wire  _GEN_659 = reg_lru_way_hot ? 1'h0 : 1'h1; // @[Memory.scala 495:22 747:42]
  wire  _GEN_674 = _T_96 & reg_ren | _GEN_659; // @[Memory.scala 737:57 739:30]
  wire [255:0] _GEN_677 = _T_96 & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 737:57 742:33]
  wire  _GEN_683 = _T_96 & reg_ren ? 1'h0 : reg_lru_way_hot; // @[Memory.scala 495:22 737:57]
  wire  _GEN_694 = _T_96 & reg_ren ? 1'h0 : _GEN_659; // @[Memory.scala 495:22 737:57]
  wire  _GEN_707 = reg_lru_way_hot & reg_ren | _GEN_683; // @[Memory.scala 730:51 732:30]
  wire [255:0] _GEN_710 = reg_lru_way_hot & reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[Memory.scala 730:51 735:33]
  wire  _GEN_716 = reg_lru_way_hot & reg_ren ? 1'h0 : _T_141; // @[Memory.scala 495:22 730:51]
  wire  _GEN_720 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_674; // @[Memory.scala 522:25 730:51]
  wire  _GEN_729 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_683; // @[Memory.scala 495:22 730:51]
  wire  _GEN_738 = reg_lru_way_hot & reg_ren ? 1'h0 : _GEN_694; // @[Memory.scala 495:22 730:51]
  wire  _GEN_747 = dram_d_rdata_valid & reg_ren; // @[Memory.scala 512:19 722:33]
  wire  _GEN_750 = dram_d_rdata_valid & _T_135; // @[Memory.scala 495:22 722:33]
  wire  _GEN_754 = dram_d_rdata_valid & _GEN_707; // @[Memory.scala 518:25 722:33]
  wire  _GEN_763 = dram_d_rdata_valid & _GEN_716; // @[Memory.scala 495:22 722:33]
  wire  _GEN_767 = dram_d_rdata_valid & _GEN_720; // @[Memory.scala 522:25 722:33]
  wire  _GEN_776 = dram_d_rdata_valid & _GEN_729; // @[Memory.scala 495:22 722:33]
  wire  _GEN_785 = dram_d_rdata_valid & _GEN_738; // @[Memory.scala 495:22 722:33]
  wire [2:0] _GEN_792 = dram_d_rdata_valid ? 3'h0 : dcache_state; // @[Memory.scala 722:33 767:22 498:29]
  wire [2:0] _GEN_840 = 3'h6 == dcache_state ? _GEN_792 : dcache_state; // @[Memory.scala 543:25 498:29]
  wire [2:0] _GEN_843 = 3'h5 == dcache_state ? _GEN_548 : _GEN_840; // @[Memory.scala 543:25]
  wire  _GEN_846 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_747; // @[Memory.scala 512:19 543:25]
  wire  _GEN_849 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_750; // @[Memory.scala 495:22 543:25]
  wire  _GEN_853 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_754; // @[Memory.scala 518:25 543:25]
  wire  _GEN_862 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_763; // @[Memory.scala 495:22 543:25]
  wire  _GEN_866 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_767; // @[Memory.scala 522:25 543:25]
  wire  _GEN_875 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_776; // @[Memory.scala 495:22 543:25]
  wire  _GEN_884 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_785; // @[Memory.scala 495:22 543:25]
  wire [255:0] _GEN_891 = 3'h3 == dcache_state ? line1 : reg_line1; // @[Memory.scala 543:25 500:26]
  wire [255:0] _GEN_892 = 3'h3 == dcache_state ? line2 : reg_line2; // @[Memory.scala 543:25 501:26]
  wire  _GEN_893 = 3'h3 == dcache_state ? _T_87 : _GEN_853; // @[Memory.scala 543:25]
  wire [31:0] _GEN_894 = 3'h3 == dcache_state ? wstrb : 32'hffffffff; // @[Memory.scala 543:25]
  wire [2:0] _GEN_904 = 3'h3 == dcache_state ? _GEN_628 : _GEN_843; // @[Memory.scala 543:25]
  wire  _GEN_905 = 3'h3 == dcache_state ? _GEN_629 : _GEN_866; // @[Memory.scala 543:25]
  wire [510:0] _GEN_908 = 3'h3 == dcache_state ? _wdata_T_4 : {{255'd0}, _GEN_677}; // @[Memory.scala 543:25]
  wire  _GEN_922 = 3'h3 == dcache_state ? 1'h0 : _GEN_846; // @[Memory.scala 512:19 543:25]
  wire  _GEN_925 = 3'h3 == dcache_state ? 1'h0 : _GEN_849; // @[Memory.scala 495:22 543:25]
  wire  _GEN_934 = 3'h3 == dcache_state ? 1'h0 : _GEN_862; // @[Memory.scala 495:22 543:25]
  wire  _GEN_943 = 3'h3 == dcache_state ? 1'h0 : _GEN_875; // @[Memory.scala 495:22 543:25]
  wire  _GEN_952 = 3'h3 == dcache_state ? 1'h0 : _GEN_884; // @[Memory.scala 495:22 543:25]
  wire  _GEN_959 = 3'h4 == dcache_state | _GEN_922; // @[Memory.scala 543:25 628:23]
  wire [15:0] _GEN_961 = 3'h4 == dcache_state ? _GEN_512 : reg_req_addr_tag; // @[Memory.scala 543:25 503:29]
  wire [6:0] _GEN_962 = 3'h4 == dcache_state ? _GEN_513 : reg_req_addr_index; // @[Memory.scala 543:25 503:29]
  wire [4:0] _GEN_963 = 3'h4 == dcache_state ? _GEN_514 : reg_req_addr_line_off; // @[Memory.scala 543:25 503:29]
  wire [15:0] _GEN_967 = 3'h4 == dcache_state ? _GEN_579 : reg_tag_0; // @[Memory.scala 499:24 543:25]
  wire [15:0] _GEN_968 = 3'h4 == dcache_state ? _GEN_580 : reg_tag_1; // @[Memory.scala 499:24 543:25]
  wire  _GEN_969 = 3'h4 == dcache_state ? _GEN_520 : _GEN_893; // @[Memory.scala 543:25]
  wire [31:0] _GEN_971 = 3'h4 == dcache_state ? 32'h0 : _GEN_894; // @[Memory.scala 543:25]
  wire  _GEN_972 = 3'h4 == dcache_state ? _GEN_520 : _GEN_905; // @[Memory.scala 543:25]
  wire [2:0] _GEN_975 = 3'h4 == dcache_state ? {{1'd0}, _GEN_584} : _GEN_904; // @[Memory.scala 543:25]
  wire [31:0] _GEN_977 = 3'h4 == dcache_state ? _GEN_525 : reg_wdata; // @[Memory.scala 543:25 504:26]
  wire [3:0] _GEN_978 = 3'h4 == dcache_state ? _GEN_526 : reg_wstrb; // @[Memory.scala 543:25 505:26]
  wire  _GEN_979 = 3'h4 == dcache_state ? _GEN_527 : reg_ren; // @[Memory.scala 506:24 543:25]
  wire  _GEN_983 = 3'h4 == dcache_state ? _GEN_588 : reg_lru_way_hot; // @[Memory.scala 502:24 543:25]
  wire  _GEN_984 = 3'h4 == dcache_state ? _GEN_589 : reg_lru_dirty1; // @[Memory.scala 502:24 543:25]
  wire  _GEN_985 = 3'h4 == dcache_state ? _GEN_590 : reg_lru_dirty2; // @[Memory.scala 502:24 543:25]
  wire [255:0] _GEN_986 = 3'h4 == dcache_state ? reg_line1 : _GEN_891; // @[Memory.scala 543:25 500:26]
  wire [255:0] _GEN_987 = 3'h4 == dcache_state ? reg_line2 : _GEN_892; // @[Memory.scala 543:25 501:26]
  wire  _GEN_991 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _T_87; // @[Memory.scala 496:22 543:25]
  wire  _GEN_999 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_629; // @[Memory.scala 496:22 543:25]
  wire  _GEN_1010 = 3'h4 == dcache_state ? 1'h0 : _GEN_925; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1019 = 3'h4 == dcache_state ? 1'h0 : _GEN_934; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1028 = 3'h4 == dcache_state ? 1'h0 : _GEN_943; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1037 = 3'h4 == dcache_state ? 1'h0 : _GEN_952; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1052 = 3'h2 == dcache_state ? 1'h0 : _GEN_959; // @[Memory.scala 512:19 543:25]
  wire  _GEN_1059 = 3'h2 == dcache_state ? 1'h0 : 3'h4 == dcache_state & dcache_snoop_en; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1062 = 3'h2 == dcache_state ? 1'h0 : _GEN_969; // @[Memory.scala 518:25 543:25]
  wire  _GEN_1065 = 3'h2 == dcache_state ? 1'h0 : _GEN_972; // @[Memory.scala 522:25 543:25]
  wire  _GEN_1068 = 3'h2 == dcache_state ? 1'h0 : 3'h4 == dcache_state & _GEN_524; // @[Memory.scala 510:19 543:25]
  wire  _GEN_1071 = 3'h2 == dcache_state ? reg_ren : _GEN_979; // @[Memory.scala 506:24 543:25]
  wire  _GEN_1074 = 3'h2 == dcache_state ? 1'h0 : 3'h4 == dcache_state & _GEN_530; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1081 = 3'h2 == dcache_state ? 1'h0 : _GEN_991; // @[Memory.scala 496:22 543:25]
  wire  _GEN_1089 = 3'h2 == dcache_state ? 1'h0 : _GEN_999; // @[Memory.scala 496:22 543:25]
  wire  _GEN_1096 = 3'h2 == dcache_state ? 1'h0 : _GEN_1010; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1105 = 3'h2 == dcache_state ? 1'h0 : _GEN_1019; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1114 = 3'h2 == dcache_state ? 1'h0 : _GEN_1028; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1123 = 3'h2 == dcache_state ? 1'h0 : _GEN_1037; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1140 = 3'h1 == dcache_state ? 1'h0 : _GEN_1052; // @[Memory.scala 512:19 543:25]
  wire  _GEN_1147 = 3'h1 == dcache_state ? 1'h0 : _GEN_1059; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1150 = 3'h1 == dcache_state ? 1'h0 : _GEN_1062; // @[Memory.scala 518:25 543:25]
  wire  _GEN_1153 = 3'h1 == dcache_state ? 1'h0 : _GEN_1065; // @[Memory.scala 522:25 543:25]
  wire  _GEN_1156 = 3'h1 == dcache_state ? 1'h0 : _GEN_1068; // @[Memory.scala 510:19 543:25]
  wire  _GEN_1159 = 3'h1 == dcache_state ? reg_ren : _GEN_1071; // @[Memory.scala 506:24 543:25]
  wire  _GEN_1162 = 3'h1 == dcache_state ? 1'h0 : _GEN_1074; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1169 = 3'h1 == dcache_state ? 1'h0 : _GEN_1081; // @[Memory.scala 496:22 543:25]
  wire  _GEN_1177 = 3'h1 == dcache_state ? 1'h0 : _GEN_1089; // @[Memory.scala 496:22 543:25]
  wire  _GEN_1184 = 3'h1 == dcache_state ? 1'h0 : _GEN_1096; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1193 = 3'h1 == dcache_state ? 1'h0 : _GEN_1105; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1202 = 3'h1 == dcache_state ? 1'h0 : _GEN_1114; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1211 = 3'h1 == dcache_state ? 1'h0 : _GEN_1123; // @[Memory.scala 495:22 543:25]
  wire  _GEN_1236 = 3'h0 == dcache_state ? _GEN_527 : _GEN_1159; // @[Memory.scala 543:25]
  wire  _T_157 = ~reset; // @[Memory.scala 798:9]
  assign i_tag_array_0_MPORT_en = _T_25 & _GEN_117;
  assign i_tag_array_0_MPORT_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_data = i_tag_array_0[i_tag_array_0_MPORT_addr]; // @[Memory.scala 283:24]
  assign i_tag_array_0_MPORT_1_en = _T_25 ? 1'h0 : _GEN_419;
  assign i_tag_array_0_MPORT_1_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_1_data = i_tag_array_0[i_tag_array_0_MPORT_1_addr]; // @[Memory.scala 283:24]
  assign i_tag_array_0_MPORT_3_en = _T_25 ? 1'h0 : _GEN_441;
  assign i_tag_array_0_MPORT_3_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_3_data = i_tag_array_0[i_tag_array_0_MPORT_3_addr]; // @[Memory.scala 283:24]
  assign i_tag_array_0_MPORT_5_en = _T_25 ? 1'h0 : _GEN_449;
  assign i_tag_array_0_MPORT_5_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_5_data = i_tag_array_0[i_tag_array_0_MPORT_5_addr]; // @[Memory.scala 283:24]
  assign i_tag_array_0_MPORT_2_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_2_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_2_mask = 1'h1;
  assign i_tag_array_0_MPORT_2_en = _T_25 ? 1'h0 : _GEN_430;
  assign i_tag_array_0_MPORT_4_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_4_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_4_mask = 1'h1;
  assign i_tag_array_0_MPORT_4_en = _T_25 ? 1'h0 : _GEN_444;
  assign tag_array_0_MPORT_6_en = _T_82 & dcache_snoop_en;
  assign tag_array_0_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_6_data = tag_array_0[tag_array_0_MPORT_6_addr]; // @[Memory.scala 495:22]
  assign tag_array_0_MPORT_7_en = _T_82 & _GEN_530;
  assign tag_array_0_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_0_MPORT_7_data = tag_array_0[tag_array_0_MPORT_7_addr]; // @[Memory.scala 495:22]
  assign tag_array_0_MPORT_8_en = _T_82 ? 1'h0 : _GEN_1147;
  assign tag_array_0_MPORT_8_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_8_data = tag_array_0[tag_array_0_MPORT_8_addr]; // @[Memory.scala 495:22]
  assign tag_array_0_MPORT_9_en = _T_82 ? 1'h0 : _GEN_1162;
  assign tag_array_0_MPORT_9_addr = _req_addr_T_12[11:5];
  assign tag_array_0_MPORT_9_data = tag_array_0[tag_array_0_MPORT_9_addr]; // @[Memory.scala 495:22]
  assign tag_array_0_MPORT_12_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_12_mask = 1'h1;
  assign tag_array_0_MPORT_12_en = _T_82 ? 1'h0 : _GEN_1184;
  assign tag_array_0_MPORT_14_data = reg_tag_0;
  assign tag_array_0_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_14_mask = 1'h1;
  assign tag_array_0_MPORT_14_en = _T_82 ? 1'h0 : _GEN_1193;
  assign tag_array_0_MPORT_16_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_16_mask = 1'h1;
  assign tag_array_0_MPORT_16_en = _T_82 ? 1'h0 : _GEN_1202;
  assign tag_array_0_MPORT_18_data = reg_tag_0;
  assign tag_array_0_MPORT_18_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_18_mask = 1'h1;
  assign tag_array_0_MPORT_18_en = _T_82 ? 1'h0 : _GEN_1211;
  assign tag_array_1_MPORT_6_en = _T_82 & dcache_snoop_en;
  assign tag_array_1_MPORT_6_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_6_data = tag_array_1[tag_array_1_MPORT_6_addr]; // @[Memory.scala 495:22]
  assign tag_array_1_MPORT_7_en = _T_82 & _GEN_530;
  assign tag_array_1_MPORT_7_addr = _req_addr_T_12[11:5];
  assign tag_array_1_MPORT_7_data = tag_array_1[tag_array_1_MPORT_7_addr]; // @[Memory.scala 495:22]
  assign tag_array_1_MPORT_8_en = _T_82 ? 1'h0 : _GEN_1147;
  assign tag_array_1_MPORT_8_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_8_data = tag_array_1[tag_array_1_MPORT_8_addr]; // @[Memory.scala 495:22]
  assign tag_array_1_MPORT_9_en = _T_82 ? 1'h0 : _GEN_1162;
  assign tag_array_1_MPORT_9_addr = _req_addr_T_12[11:5];
  assign tag_array_1_MPORT_9_data = tag_array_1[tag_array_1_MPORT_9_addr]; // @[Memory.scala 495:22]
  assign tag_array_1_MPORT_12_data = reg_tag_1;
  assign tag_array_1_MPORT_12_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_12_mask = 1'h1;
  assign tag_array_1_MPORT_12_en = _T_82 ? 1'h0 : _GEN_1184;
  assign tag_array_1_MPORT_14_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_14_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_14_mask = 1'h1;
  assign tag_array_1_MPORT_14_en = _T_82 ? 1'h0 : _GEN_1193;
  assign tag_array_1_MPORT_16_data = reg_tag_1;
  assign tag_array_1_MPORT_16_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_16_mask = 1'h1;
  assign tag_array_1_MPORT_16_en = _T_82 ? 1'h0 : _GEN_1202;
  assign tag_array_1_MPORT_18_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_18_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_18_mask = 1'h1;
  assign tag_array_1_MPORT_18_en = _T_82 ? 1'h0 : _GEN_1211;
  assign lru_array_way_hot_reg_lru_MPORT_en = _T_82 & _GEN_530;
  assign lru_array_way_hot_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_addr]; // @[Memory.scala 496:22]
  assign lru_array_way_hot_reg_lru_MPORT_1_en = _T_82 ? 1'h0 : _GEN_1162;
  assign lru_array_way_hot_reg_lru_MPORT_1_addr = _req_addr_T_12[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_1_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_1_addr]; // @[Memory.scala 496:22]
  assign lru_array_way_hot_MPORT_10_data = _T_110[2];
  assign lru_array_way_hot_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_10_mask = 1'h1;
  assign lru_array_way_hot_MPORT_10_en = _T_82 ? 1'h0 : _GEN_1169;
  assign lru_array_way_hot_MPORT_11_data = _T_115[2];
  assign lru_array_way_hot_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_11_mask = 1'h1;
  assign lru_array_way_hot_MPORT_11_en = _T_82 ? 1'h0 : _GEN_1177;
  assign lru_array_way_hot_MPORT_13_data = _T_136[2];
  assign lru_array_way_hot_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_13_mask = 1'h1;
  assign lru_array_way_hot_MPORT_13_en = _T_82 ? 1'h0 : _GEN_1184;
  assign lru_array_way_hot_MPORT_15_data = _T_142[2];
  assign lru_array_way_hot_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_15_mask = 1'h1;
  assign lru_array_way_hot_MPORT_15_en = _T_82 ? 1'h0 : _GEN_1193;
  assign lru_array_way_hot_MPORT_17_data = _T_110[2];
  assign lru_array_way_hot_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_17_mask = 1'h1;
  assign lru_array_way_hot_MPORT_17_en = _T_82 ? 1'h0 : _GEN_1202;
  assign lru_array_way_hot_MPORT_19_data = _T_115[2];
  assign lru_array_way_hot_MPORT_19_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_19_mask = 1'h1;
  assign lru_array_way_hot_MPORT_19_en = _T_82 ? 1'h0 : _GEN_1211;
  assign lru_array_dirty1_reg_lru_MPORT_en = _T_82 & _GEN_530;
  assign lru_array_dirty1_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_addr]; // @[Memory.scala 496:22]
  assign lru_array_dirty1_reg_lru_MPORT_1_en = _T_82 ? 1'h0 : _GEN_1162;
  assign lru_array_dirty1_reg_lru_MPORT_1_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_1_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_1_addr]; // @[Memory.scala 496:22]
  assign lru_array_dirty1_MPORT_10_data = _T_110[1];
  assign lru_array_dirty1_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_10_mask = 1'h1;
  assign lru_array_dirty1_MPORT_10_en = _T_82 ? 1'h0 : _GEN_1169;
  assign lru_array_dirty1_MPORT_11_data = _T_115[1];
  assign lru_array_dirty1_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_11_mask = 1'h1;
  assign lru_array_dirty1_MPORT_11_en = _T_82 ? 1'h0 : _GEN_1177;
  assign lru_array_dirty1_MPORT_13_data = _T_136[1];
  assign lru_array_dirty1_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_13_mask = 1'h1;
  assign lru_array_dirty1_MPORT_13_en = _T_82 ? 1'h0 : _GEN_1184;
  assign lru_array_dirty1_MPORT_15_data = _T_142[1];
  assign lru_array_dirty1_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_15_mask = 1'h1;
  assign lru_array_dirty1_MPORT_15_en = _T_82 ? 1'h0 : _GEN_1193;
  assign lru_array_dirty1_MPORT_17_data = _T_110[1];
  assign lru_array_dirty1_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_17_mask = 1'h1;
  assign lru_array_dirty1_MPORT_17_en = _T_82 ? 1'h0 : _GEN_1202;
  assign lru_array_dirty1_MPORT_19_data = _T_115[1];
  assign lru_array_dirty1_MPORT_19_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_19_mask = 1'h1;
  assign lru_array_dirty1_MPORT_19_en = _T_82 ? 1'h0 : _GEN_1211;
  assign lru_array_dirty2_reg_lru_MPORT_en = _T_82 & _GEN_530;
  assign lru_array_dirty2_reg_lru_MPORT_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_addr]; // @[Memory.scala 496:22]
  assign lru_array_dirty2_reg_lru_MPORT_1_en = _T_82 ? 1'h0 : _GEN_1162;
  assign lru_array_dirty2_reg_lru_MPORT_1_addr = _req_addr_T_12[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_1_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_1_addr]; // @[Memory.scala 496:22]
  assign lru_array_dirty2_MPORT_10_data = _T_110[0];
  assign lru_array_dirty2_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_10_mask = 1'h1;
  assign lru_array_dirty2_MPORT_10_en = _T_82 ? 1'h0 : _GEN_1169;
  assign lru_array_dirty2_MPORT_11_data = _T_115[0];
  assign lru_array_dirty2_MPORT_11_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_11_mask = 1'h1;
  assign lru_array_dirty2_MPORT_11_en = _T_82 ? 1'h0 : _GEN_1177;
  assign lru_array_dirty2_MPORT_13_data = _T_136[0];
  assign lru_array_dirty2_MPORT_13_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_13_mask = 1'h1;
  assign lru_array_dirty2_MPORT_13_en = _T_82 ? 1'h0 : _GEN_1184;
  assign lru_array_dirty2_MPORT_15_data = _T_142[0];
  assign lru_array_dirty2_MPORT_15_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_15_mask = 1'h1;
  assign lru_array_dirty2_MPORT_15_en = _T_82 ? 1'h0 : _GEN_1193;
  assign lru_array_dirty2_MPORT_17_data = _T_110[0];
  assign lru_array_dirty2_MPORT_17_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_17_mask = 1'h1;
  assign lru_array_dirty2_MPORT_17_en = _T_82 ? 1'h0 : _GEN_1202;
  assign lru_array_dirty2_MPORT_19_data = _T_115[0];
  assign lru_array_dirty2_MPORT_19_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_19_mask = 1'h1;
  assign lru_array_dirty2_MPORT_19_en = _T_82 ? 1'h0 : _GEN_1211;
  assign io_imem_inst = 3'h0 == icache_state ? 32'hdeadbeef : _GEN_408; // @[Memory.scala 299:16 320:25]
  assign io_imem_valid = 3'h0 == icache_state ? 1'h0 : _GEN_409; // @[Memory.scala 300:17 320:25]
  assign io_cache_ibusy = 3'h0 == icache_state ? 1'h0 : _GEN_410; // @[Memory.scala 320:25 322:22]
  assign io_cache_rdata = 3'h4 == dcache_state ? reg_read_word : _io_cache_rdata_T_2[31:0]; // @[Memory.scala 543:25 629:23]
  assign io_cache_rvalid = 3'h0 == dcache_state ? 1'h0 : _GEN_1140; // @[Memory.scala 512:19 543:25]
  assign io_cache_rready = 3'h0 == dcache_state ? _GEN_524 : _GEN_1156; // @[Memory.scala 543:25]
  assign io_cache_wready = 3'h0 == dcache_state ? _GEN_524 : _GEN_1156; // @[Memory.scala 543:25]
  assign io_dramPort_ren = 3'h0 == reg_dram_state ? _GEN_25 : _GEN_83; // @[Memory.scala 203:27]
  assign io_dramPort_wen = 3'h0 == reg_dram_state ? _GEN_31 : _GEN_78; // @[Memory.scala 203:27]
  assign io_dramPort_addr = _GEN_90[27:0];
  assign io_dramPort_wdata = 3'h0 == reg_dram_state ? dram_d_wdata[127:0] : reg_dram_wdata; // @[Memory.scala 203:27]
  assign io_cache_array1_en = 3'h0 == dcache_state ? _GEN_520 : _GEN_1150; // @[Memory.scala 543:25]
  assign io_cache_array1_we = 3'h0 == dcache_state ? 32'h0 : _GEN_971; // @[Memory.scala 543:25]
  assign io_cache_array1_addr = 3'h0 == dcache_state ? _GEN_513 : _GEN_962; // @[Memory.scala 543:25]
  assign io_cache_array1_wdata = 3'h3 == dcache_state ? wdata : _GEN_710; // @[Memory.scala 543:25]
  assign io_cache_array2_en = 3'h0 == dcache_state ? _GEN_520 : _GEN_1153; // @[Memory.scala 543:25]
  assign io_cache_array2_we = 3'h0 == dcache_state ? 32'h0 : _GEN_971; // @[Memory.scala 543:25]
  assign io_cache_array2_addr = 3'h0 == dcache_state ? _GEN_513 : _GEN_962; // @[Memory.scala 543:25]
  assign io_cache_array2_wdata = _GEN_908[255:0];
  assign io_icache_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_404; // @[Memory.scala 320:25]
  assign io_icache_wen = 3'h0 == icache_state ? 1'h0 : _GEN_433; // @[Memory.scala 308:17 320:25]
  assign io_icache_raddr = 3'h0 == icache_state ? _io_icache_raddr_T_1 : _GEN_405; // @[Memory.scala 320:25]
  assign io_icache_waddr = i_reg_req_addr_index; // @[Memory.scala 320:25]
  assign io_icache_wdata = 3'h4 == icache_state ? dcache_snoop_line : dram_rdata; // @[Memory.scala 320:25]
  assign io_icache_valid_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_421; // @[Memory.scala 320:25]
  assign io_icache_valid_wen = 3'h0 == icache_state ? 1'h0 : _GEN_433; // @[Memory.scala 308:17 320:25]
  assign io_icache_valid_invalidate = 3'h0 == icache_state ? io_cache_iinvalidate : _GEN_414; // @[Memory.scala 320:25]
  assign io_icache_valid_addr = 3'h0 == icache_state ? io_imem_addr[11:6] : _GEN_372; // @[Memory.scala 320:25]
  assign io_icache_valid_iaddr = 3'h0 == icache_state ? 1'h0 : _GEN_356; // @[Memory.scala 320:25]
  assign io_icache_valid_wdata = 3'h4 == icache_state ? icache_valid_wdata : icache_valid_wdata; // @[Memory.scala 320:25]
  assign io_icache_state = icache_state; // @[Memory.scala 772:35]
  assign io_dram_state = reg_dram_state; // @[Memory.scala 773:35]
  always @(posedge clock) begin
    if (i_tag_array_0_MPORT_2_en & i_tag_array_0_MPORT_2_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_2_addr] <= i_tag_array_0_MPORT_2_data; // @[Memory.scala 283:24]
    end
    if (i_tag_array_0_MPORT_4_en & i_tag_array_0_MPORT_4_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_4_addr] <= i_tag_array_0_MPORT_4_data; // @[Memory.scala 283:24]
    end
    if (tag_array_0_MPORT_12_en & tag_array_0_MPORT_12_mask) begin
      tag_array_0[tag_array_0_MPORT_12_addr] <= tag_array_0_MPORT_12_data; // @[Memory.scala 495:22]
    end
    if (tag_array_0_MPORT_14_en & tag_array_0_MPORT_14_mask) begin
      tag_array_0[tag_array_0_MPORT_14_addr] <= tag_array_0_MPORT_14_data; // @[Memory.scala 495:22]
    end
    if (tag_array_0_MPORT_16_en & tag_array_0_MPORT_16_mask) begin
      tag_array_0[tag_array_0_MPORT_16_addr] <= tag_array_0_MPORT_16_data; // @[Memory.scala 495:22]
    end
    if (tag_array_0_MPORT_18_en & tag_array_0_MPORT_18_mask) begin
      tag_array_0[tag_array_0_MPORT_18_addr] <= tag_array_0_MPORT_18_data; // @[Memory.scala 495:22]
    end
    if (tag_array_1_MPORT_12_en & tag_array_1_MPORT_12_mask) begin
      tag_array_1[tag_array_1_MPORT_12_addr] <= tag_array_1_MPORT_12_data; // @[Memory.scala 495:22]
    end
    if (tag_array_1_MPORT_14_en & tag_array_1_MPORT_14_mask) begin
      tag_array_1[tag_array_1_MPORT_14_addr] <= tag_array_1_MPORT_14_data; // @[Memory.scala 495:22]
    end
    if (tag_array_1_MPORT_16_en & tag_array_1_MPORT_16_mask) begin
      tag_array_1[tag_array_1_MPORT_16_addr] <= tag_array_1_MPORT_16_data; // @[Memory.scala 495:22]
    end
    if (tag_array_1_MPORT_18_en & tag_array_1_MPORT_18_mask) begin
      tag_array_1[tag_array_1_MPORT_18_addr] <= tag_array_1_MPORT_18_data; // @[Memory.scala 495:22]
    end
    if (lru_array_way_hot_MPORT_10_en & lru_array_way_hot_MPORT_10_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_10_addr] <= lru_array_way_hot_MPORT_10_data; // @[Memory.scala 496:22]
    end
    if (lru_array_way_hot_MPORT_11_en & lru_array_way_hot_MPORT_11_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_11_addr] <= lru_array_way_hot_MPORT_11_data; // @[Memory.scala 496:22]
    end
    if (lru_array_way_hot_MPORT_13_en & lru_array_way_hot_MPORT_13_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_13_addr] <= lru_array_way_hot_MPORT_13_data; // @[Memory.scala 496:22]
    end
    if (lru_array_way_hot_MPORT_15_en & lru_array_way_hot_MPORT_15_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_15_addr] <= lru_array_way_hot_MPORT_15_data; // @[Memory.scala 496:22]
    end
    if (lru_array_way_hot_MPORT_17_en & lru_array_way_hot_MPORT_17_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_17_addr] <= lru_array_way_hot_MPORT_17_data; // @[Memory.scala 496:22]
    end
    if (lru_array_way_hot_MPORT_19_en & lru_array_way_hot_MPORT_19_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_19_addr] <= lru_array_way_hot_MPORT_19_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_10_en & lru_array_dirty1_MPORT_10_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_10_addr] <= lru_array_dirty1_MPORT_10_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_11_en & lru_array_dirty1_MPORT_11_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_11_addr] <= lru_array_dirty1_MPORT_11_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_13_en & lru_array_dirty1_MPORT_13_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_13_addr] <= lru_array_dirty1_MPORT_13_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_15_en & lru_array_dirty1_MPORT_15_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_15_addr] <= lru_array_dirty1_MPORT_15_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_17_en & lru_array_dirty1_MPORT_17_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_17_addr] <= lru_array_dirty1_MPORT_17_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty1_MPORT_19_en & lru_array_dirty1_MPORT_19_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_19_addr] <= lru_array_dirty1_MPORT_19_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_10_en & lru_array_dirty2_MPORT_10_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_10_addr] <= lru_array_dirty2_MPORT_10_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_11_en & lru_array_dirty2_MPORT_11_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_11_addr] <= lru_array_dirty2_MPORT_11_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_13_en & lru_array_dirty2_MPORT_13_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_13_addr] <= lru_array_dirty2_MPORT_13_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_15_en & lru_array_dirty2_MPORT_15_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_15_addr] <= lru_array_dirty2_MPORT_15_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_17_en & lru_array_dirty2_MPORT_17_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_17_addr] <= lru_array_dirty2_MPORT_17_data; // @[Memory.scala 496:22]
    end
    if (lru_array_dirty2_MPORT_19_en & lru_array_dirty2_MPORT_19_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_19_addr] <= lru_array_dirty2_MPORT_19_data; // @[Memory.scala 496:22]
    end
    if (reset) begin // @[Memory.scala 185:31]
      reg_dram_state <= 3'h0; // @[Memory.scala 185:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 203:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 205:67]
        if (dram_i_ren) begin // @[Memory.scala 207:27]
          reg_dram_state <= 3'h2; // @[Memory.scala 212:26]
        end else begin
          reg_dram_state <= _GEN_12;
        end
      end
    end else if (3'h1 == reg_dram_state) begin // @[Memory.scala 203:27]
      if (_T_3) begin // @[Memory.scala 235:32]
        reg_dram_state <= 3'h0; // @[Memory.scala 240:24]
      end
    end else if (3'h2 == reg_dram_state) begin // @[Memory.scala 203:27]
      reg_dram_state <= _GEN_46;
    end else begin
      reg_dram_state <= _GEN_66;
    end
    if (reset) begin // @[Memory.scala 186:31]
      reg_dram_addr <= 27'h0; // @[Memory.scala 186:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 203:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 205:67]
        if (dram_i_ren) begin // @[Memory.scala 207:27]
          reg_dram_addr <= dram_i_addr; // @[Memory.scala 210:25]
        end else begin
          reg_dram_addr <= _GEN_9;
        end
      end
    end
    if (reset) begin // @[Memory.scala 187:31]
      reg_dram_wdata <= 128'h0; // @[Memory.scala 187:31]
    end else if (3'h0 == reg_dram_state) begin // @[Memory.scala 203:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[Memory.scala 205:67]
        if (!(dram_i_ren)) begin // @[Memory.scala 207:27]
          reg_dram_wdata <= _GEN_10;
        end
      end
    end
    if (reset) begin // @[Memory.scala 188:31]
      reg_dram_rdata <= 128'h0; // @[Memory.scala 188:31]
    end else if (!(3'h0 == reg_dram_state)) begin // @[Memory.scala 203:27]
      if (!(3'h1 == reg_dram_state)) begin // @[Memory.scala 203:27]
        if (3'h2 == reg_dram_state) begin // @[Memory.scala 203:27]
          reg_dram_rdata <= _GEN_40;
        end else begin
          reg_dram_rdata <= _GEN_67;
        end
      end
    end
    reg_dram_di <= reset | _GEN_92; // @[Memory.scala 189:{28,28}]
    if (reset) begin // @[Memory.scala 285:29]
      icache_state <= 3'h0; // @[Memory.scala 285:29]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 320:25]
      if (io_cache_iinvalidate) begin // @[Memory.scala 325:35]
        icache_state <= 3'h7; // @[Memory.scala 329:22]
      end else if (io_imem_en) begin // @[Memory.scala 330:31]
        icache_state <= {{1'd0}, _GEN_103};
      end
    end else if (3'h1 == icache_state) begin // @[Memory.scala 320:25]
      if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 350:145]
        icache_state <= 3'h2; // @[Memory.scala 354:22]
      end else begin
        icache_state <= 3'h4; // @[Memory.scala 356:22]
      end
    end else if (3'h2 == icache_state) begin // @[Memory.scala 320:25]
      icache_state <= _GEN_132;
    end else begin
      icache_state <= _GEN_327;
    end
    if (reset) begin // @[Memory.scala 498:29]
      dcache_state <= 3'h0; // @[Memory.scala 498:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        dcache_state <= 3'h1; // @[Memory.scala 555:22]
      end else if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
        dcache_state <= {{1'd0}, _GEN_501};
      end
    end else if (3'h1 == dcache_state) begin // @[Memory.scala 543:25]
      dcache_state <= 3'h0; // @[Memory.scala 592:20]
    end else if (3'h2 == dcache_state) begin // @[Memory.scala 543:25]
      dcache_state <= _GEN_561;
    end else begin
      dcache_state <= _GEN_975;
    end
    if (reset) begin // @[Memory.scala 499:24]
      reg_tag_0 <= 16'h0; // @[Memory.scala 499:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_tag_0 <= tag_array_0_MPORT_6_data; // @[Memory.scala 548:17]
      end else if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
        reg_tag_0 <= tag_array_0_MPORT_7_data; // @[Memory.scala 565:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_tag_0 <= _GEN_967;
      end
    end
    if (reset) begin // @[Memory.scala 503:29]
      reg_req_addr_tag <= 16'h0; // @[Memory.scala 503:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_req_addr_tag <= dcache_snoop_addr_tag; // @[Memory.scala 547:22]
      end else begin
        reg_req_addr_tag <= req_addr_4_tag; // @[Memory.scala 560:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_req_addr_tag <= _GEN_961;
      end
    end
    if (reset) begin // @[Memory.scala 499:24]
      reg_tag_1 <= 16'h0; // @[Memory.scala 499:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_tag_1 <= tag_array_1_MPORT_6_data; // @[Memory.scala 548:17]
      end else if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
        reg_tag_1 <= tag_array_1_MPORT_7_data; // @[Memory.scala 565:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_tag_1 <= _GEN_968;
      end
    end
    if (reset) begin // @[Memory.scala 288:31]
      i_reg_req_addr_tag <= 16'h0; // @[Memory.scala 288:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 320:25]
      i_reg_req_addr_tag <= io_imem_addr[27:12]; // @[Memory.scala 324:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 320:25]
        i_reg_req_addr_tag <= io_imem_addr[27:12]; // @[Memory.scala 366:22]
      end else begin
        i_reg_req_addr_tag <= _GEN_332;
      end
    end
    if (reset) begin // @[Memory.scala 288:31]
      i_reg_req_addr_index <= 7'h0; // @[Memory.scala 288:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 320:25]
      i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 324:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 320:25]
        i_reg_req_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 366:22]
      end else begin
        i_reg_req_addr_index <= _GEN_333;
      end
    end
    if (reset) begin // @[Memory.scala 502:24]
      reg_lru_way_hot <= 1'h0; // @[Memory.scala 502:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 545:30]
        if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
          reg_lru_way_hot <= lru_array_way_hot_reg_lru_MPORT_data; // @[Memory.scala 573:19]
        end
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_lru_way_hot <= _GEN_983;
      end
    end
    if (reset) begin // @[Memory.scala 502:24]
      reg_lru_dirty1 <= 1'h0; // @[Memory.scala 502:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 545:30]
        if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
          reg_lru_dirty1 <= lru_array_dirty1_reg_lru_MPORT_data; // @[Memory.scala 573:19]
        end
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_lru_dirty1 <= _GEN_984;
      end
    end
    if (reset) begin // @[Memory.scala 502:24]
      reg_lru_dirty2 <= 1'h0; // @[Memory.scala 502:24]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 545:30]
        if (io_cache_ren | io_cache_wen) begin // @[Memory.scala 564:45]
          reg_lru_dirty2 <= lru_array_dirty2_reg_lru_MPORT_data; // @[Memory.scala 573:19]
        end
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_lru_dirty2 <= _GEN_985;
      end
    end
    if (reset) begin // @[Memory.scala 503:29]
      reg_req_addr_index <= 7'h0; // @[Memory.scala 503:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_req_addr_index <= dcache_snoop_addr_index; // @[Memory.scala 547:22]
      end else begin
        reg_req_addr_index <= req_addr_4_index; // @[Memory.scala 560:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_req_addr_index <= _GEN_962;
      end
    end
    if (reset) begin // @[Memory.scala 507:32]
      reg_dcache_read <= 1'h0; // @[Memory.scala 507:32]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_dcache_read <= 1'h0; // @[Memory.scala 495:22]
      end else begin
        reg_dcache_read <= _T_83;
      end
    end else if (3'h1 == dcache_state) begin // @[Memory.scala 543:25]
      reg_dcache_read <= 1'h0; // @[Memory.scala 495:22]
    end else if (3'h2 == dcache_state) begin // @[Memory.scala 543:25]
      reg_dcache_read <= 1'h0; // @[Memory.scala 495:22]
    end else begin
      reg_dcache_read <= 3'h4 == dcache_state & _GEN_530;
    end
    if (reset) begin // @[Memory.scala 500:26]
      reg_line1 <= 256'h0; // @[Memory.scala 500:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 543:25]
          reg_line1 <= line1;
        end else begin
          reg_line1 <= _GEN_986;
        end
      end
    end
    if (reset) begin // @[Memory.scala 501:26]
      reg_line2 <= 256'h0; // @[Memory.scala 501:26]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 543:25]
          reg_line2 <= line2;
        end else begin
          reg_line2 <= _GEN_987;
        end
      end
    end
    if (reset) begin // @[Memory.scala 286:26]
      i_reg_tag_0 <= 16'h0; // @[Memory.scala 286:26]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 320:25]
      if (!(io_cache_iinvalidate)) begin // @[Memory.scala 325:35]
        if (io_imem_en) begin // @[Memory.scala 330:31]
          i_reg_tag_0 <= i_tag_array_0_MPORT_data; // @[Memory.scala 331:19]
        end
      end
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 320:25]
        i_reg_tag_0 <= _GEN_134;
      end else begin
        i_reg_tag_0 <= _GEN_339;
      end
    end
    if (reset) begin // @[Memory.scala 287:27]
      i_reg_line <= 256'h0; // @[Memory.scala 287:27]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 320:25]
      if (!(3'h1 == icache_state)) begin // @[Memory.scala 320:25]
        if (!(3'h2 == icache_state)) begin // @[Memory.scala 320:25]
          i_reg_line <= _GEN_313;
        end
      end
    end
    if (reset) begin // @[Memory.scala 288:31]
      i_reg_req_addr_line_off <= 5'h0; // @[Memory.scala 288:31]
    end else if (3'h0 == icache_state) begin // @[Memory.scala 320:25]
      i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 324:22]
    end else if (!(3'h1 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h2 == icache_state) begin // @[Memory.scala 320:25]
        i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 366:22]
      end else begin
        i_reg_req_addr_line_off <= _GEN_334;
      end
    end
    if (reset) begin // @[Memory.scala 289:32]
      i_reg_next_addr_tag <= 16'h0; // @[Memory.scala 289:32]
    end else begin
      i_reg_next_addr_tag <= io_imem_addr[27:12]; // @[Memory.scala 302:19]
    end
    if (reset) begin // @[Memory.scala 289:32]
      i_reg_next_addr_index <= 7'h0; // @[Memory.scala 289:32]
    end else begin
      i_reg_next_addr_index <= io_imem_addr[11:5]; // @[Memory.scala 302:19]
    end
    if (reset) begin // @[Memory.scala 289:32]
      i_reg_next_addr_line_off <= 5'h0; // @[Memory.scala 289:32]
    end else begin
      i_reg_next_addr_line_off <= io_imem_addr[4:0]; // @[Memory.scala 302:19]
    end
    if (reset) begin // @[Memory.scala 290:34]
      i_reg_valid_rdata <= 2'h0; // @[Memory.scala 290:34]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 320:25]
        i_reg_valid_rdata <= io_icache_valid_rdata; // @[Memory.scala 345:25]
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 320:25]
        i_reg_valid_rdata <= _GEN_326;
      end
    end
    if (reset) begin // @[Memory.scala 291:36]
      i_reg_cur_tag_index <= 23'h7fffff; // @[Memory.scala 291:36]
    end else if (!(3'h0 == icache_state)) begin // @[Memory.scala 320:25]
      if (3'h1 == icache_state) begin // @[Memory.scala 320:25]
        if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[Memory.scala 350:145]
          i_reg_cur_tag_index <= _dram_i_addr_T_1; // @[Memory.scala 353:29]
        end
      end else if (!(3'h2 == icache_state)) begin // @[Memory.scala 320:25]
        i_reg_cur_tag_index <= _GEN_325;
      end
    end
    if (reset) begin // @[Memory.scala 292:33]
      i_reg_addr_match <= 1'h0; // @[Memory.scala 292:33]
    end else begin
      i_reg_addr_match <= _GEN_466;
    end
    if (reset) begin // @[Memory.scala 503:29]
      reg_req_addr_line_off <= 5'h0; // @[Memory.scala 503:29]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (dcache_snoop_en) begin // @[Memory.scala 545:30]
        reg_req_addr_line_off <= dcache_snoop_addr_line_off; // @[Memory.scala 547:22]
      end else begin
        reg_req_addr_line_off <= req_addr_4_line_off; // @[Memory.scala 560:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_req_addr_line_off <= _GEN_963;
      end
    end
    if (reset) begin // @[Memory.scala 504:26]
      reg_wdata <= 32'h0; // @[Memory.scala 504:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 545:30]
        reg_wdata <= io_cache_wdata; // @[Memory.scala 561:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_wdata <= _GEN_977;
      end
    end
    if (reset) begin // @[Memory.scala 505:26]
      reg_wstrb <= 4'h0; // @[Memory.scala 505:26]
    end else if (3'h0 == dcache_state) begin // @[Memory.scala 543:25]
      if (!(dcache_snoop_en)) begin // @[Memory.scala 545:30]
        reg_wstrb <= io_cache_wstrb; // @[Memory.scala 562:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h2 == dcache_state)) begin // @[Memory.scala 543:25]
        reg_wstrb <= _GEN_978;
      end
    end
    reg_ren <= reset | _GEN_1236; // @[Memory.scala 506:{24,24}]
    if (reset) begin // @[Memory.scala 508:30]
      reg_read_word <= 32'h0; // @[Memory.scala 508:30]
    end else if (!(3'h0 == dcache_state)) begin // @[Memory.scala 543:25]
      if (!(3'h1 == dcache_state)) begin // @[Memory.scala 543:25]
        if (3'h2 == dcache_state) begin // @[Memory.scala 543:25]
          reg_read_word <= _GEN_560;
        end
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"icache_state    : %d\n",icache_state); // @[Memory.scala 798:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_157) begin
          $fwrite(32'h80000002,"dcache_state    : %d\n",dcache_state); // @[Memory.scala 799:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_157) begin
          $fwrite(32'h80000002,"reg_dram_state  : %d\n",reg_dram_state); // @[Memory.scala 800:9]
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
    i_tag_array_0[initvar] = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tag_array_0[initvar] = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    tag_array_1[initvar] = _RAND_2[15:0];
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
  reg_tag_0 = _RAND_13[15:0];
  _RAND_14 = {1{`RANDOM}};
  reg_req_addr_tag = _RAND_14[15:0];
  _RAND_15 = {1{`RANDOM}};
  reg_tag_1 = _RAND_15[15:0];
  _RAND_16 = {1{`RANDOM}};
  i_reg_req_addr_tag = _RAND_16[15:0];
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
  i_reg_tag_0 = _RAND_25[15:0];
  _RAND_26 = {8{`RANDOM}};
  i_reg_line = _RAND_26[255:0];
  _RAND_27 = {1{`RANDOM}};
  i_reg_req_addr_line_off = _RAND_27[4:0];
  _RAND_28 = {1{`RANDOM}};
  i_reg_next_addr_tag = _RAND_28[15:0];
  _RAND_29 = {1{`RANDOM}};
  i_reg_next_addr_index = _RAND_29[6:0];
  _RAND_30 = {1{`RANDOM}};
  i_reg_next_addr_line_off = _RAND_30[4:0];
  _RAND_31 = {1{`RANDOM}};
  i_reg_valid_rdata = _RAND_31[1:0];
  _RAND_32 = {1{`RANDOM}};
  i_reg_cur_tag_index = _RAND_32[22:0];
  _RAND_33 = {1{`RANDOM}};
  i_reg_addr_match = _RAND_33[0:0];
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
  wire  _T = ~io_dmem_wen; // @[BootRom.scala 46:9]
  reg  io_dmem_rvalid_REG; // @[BootRom.scala 50:28]
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
  assign io_dmem_rdata = imem_rdata; // @[BootRom.scala 49:17]
  assign io_dmem_rvalid = io_dmem_rvalid_REG; // @[BootRom.scala 50:18]
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
    end else if (~io_dmem_wen & io_dmem_ren) begin // @[BootRom.scala 46:38]
      imem_rdata <= imem_imem_rdata_MPORT_data; // @[BootRom.scala 47:16]
    end
    if (reset) begin // @[BootRom.scala 33:27]
      io_imem_valid_REG <= 1'h0; // @[BootRom.scala 33:27]
    end else begin
      io_imem_valid_REG <= io_imem_en; // @[BootRom.scala 33:27]
    end
    if (reset) begin // @[BootRom.scala 50:28]
      io_dmem_rvalid_REG <= 1'h0; // @[BootRom.scala 50:28]
    end else begin
      io_dmem_rvalid_REG <= io_dmem_ren; // @[BootRom.scala 50:28]
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
  reg [31:0] output_; // @[Gpio.scala 13:23]
  assign io_gpio = output_; // @[Gpio.scala 14:11]
  always @(posedge clock) begin
    if (reset) begin // @[Gpio.scala 13:23]
      output_ <= 32'h0; // @[Gpio.scala 13:23]
    end else if (io_mem_wen) begin // @[Gpio.scala 19:20]
      output_ <= io_mem_wdata; // @[Gpio.scala 20:12]
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
  reg [9:0] rateCounter; // @[Uart.scala 14:30]
  reg [3:0] bitCounter; // @[Uart.scala 15:29]
  reg  bits_0; // @[Uart.scala 16:19]
  reg  bits_1; // @[Uart.scala 16:19]
  reg  bits_2; // @[Uart.scala 16:19]
  reg  bits_3; // @[Uart.scala 16:19]
  reg  bits_4; // @[Uart.scala 16:19]
  reg  bits_5; // @[Uart.scala 16:19]
  reg  bits_6; // @[Uart.scala 16:19]
  reg  bits_7; // @[Uart.scala 16:19]
  reg  bits_8; // @[Uart.scala 16:19]
  reg  bits_9; // @[Uart.scala 16:19]
  wire [9:0] _T_1 = {1'h1,io_in_bits,1'h0}; // @[Cat.scala 33:92]
  wire  _GEN_0 = io_in_valid & io_in_ready ? _T_1[0] : bits_0; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_1 = io_in_valid & io_in_ready ? _T_1[1] : bits_1; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_2 = io_in_valid & io_in_ready ? _T_1[2] : bits_2; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_3 = io_in_valid & io_in_ready ? _T_1[3] : bits_3; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_4 = io_in_valid & io_in_ready ? _T_1[4] : bits_4; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_5 = io_in_valid & io_in_ready ? _T_1[5] : bits_5; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_6 = io_in_valid & io_in_ready ? _T_1[6] : bits_6; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_7 = io_in_valid & io_in_ready ? _T_1[7] : bits_7; // @[Uart.scala 21:38 22:14 16:19]
  wire  _GEN_8 = io_in_valid & io_in_ready ? _T_1[8] : bits_8; // @[Uart.scala 21:38 22:14 16:19]
  wire [3:0] _GEN_10 = io_in_valid & io_in_ready ? 4'ha : bitCounter; // @[Uart.scala 21:38 23:20 15:29]
  wire [3:0] _bitCounter_T_1 = bitCounter - 4'h1; // @[Uart.scala 31:38]
  wire [9:0] _rateCounter_T_1 = rateCounter - 10'h1; // @[Uart.scala 34:40]
  assign io_in_ready = bitCounter == 4'h0; // @[Uart.scala 19:31]
  assign io_tx = bitCounter == 4'h0 | bits_0; // @[Uart.scala 18:33]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 14:30]
      rateCounter <= 10'h0; // @[Uart.scala 14:30]
    end else if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        rateCounter <= 10'h363; // @[Uart.scala 32:25]
      end else begin
        rateCounter <= _rateCounter_T_1; // @[Uart.scala 34:25]
      end
    end else if (io_in_valid & io_in_ready) begin // @[Uart.scala 21:38]
      rateCounter <= 10'h363; // @[Uart.scala 24:21]
    end
    if (reset) begin // @[Uart.scala 15:29]
      bitCounter <= 4'h0; // @[Uart.scala 15:29]
    end else if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bitCounter <= _bitCounter_T_1; // @[Uart.scala 31:24]
      end else begin
        bitCounter <= _GEN_10;
      end
    end else begin
      bitCounter <= _GEN_10;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_0 <= bits_1; // @[Uart.scala 30:54]
      end else begin
        bits_0 <= _GEN_0;
      end
    end else begin
      bits_0 <= _GEN_0;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_1 <= bits_2; // @[Uart.scala 30:54]
      end else begin
        bits_1 <= _GEN_1;
      end
    end else begin
      bits_1 <= _GEN_1;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_2 <= bits_3; // @[Uart.scala 30:54]
      end else begin
        bits_2 <= _GEN_2;
      end
    end else begin
      bits_2 <= _GEN_2;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_3 <= bits_4; // @[Uart.scala 30:54]
      end else begin
        bits_3 <= _GEN_3;
      end
    end else begin
      bits_3 <= _GEN_3;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_4 <= bits_5; // @[Uart.scala 30:54]
      end else begin
        bits_4 <= _GEN_4;
      end
    end else begin
      bits_4 <= _GEN_4;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_5 <= bits_6; // @[Uart.scala 30:54]
      end else begin
        bits_5 <= _GEN_5;
      end
    end else begin
      bits_5 <= _GEN_5;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_6 <= bits_7; // @[Uart.scala 30:54]
      end else begin
        bits_6 <= _GEN_6;
      end
    end else begin
      bits_6 <= _GEN_6;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_7 <= bits_8; // @[Uart.scala 30:54]
      end else begin
        bits_7 <= _GEN_7;
      end
    end else begin
      bits_7 <= _GEN_7;
    end
    if (bitCounter > 4'h0) begin // @[Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[Uart.scala 28:35]
        bits_8 <= bits_9; // @[Uart.scala 30:54]
      end else begin
        bits_8 <= _GEN_8;
      end
    end else begin
      bits_8 <= _GEN_8;
    end
    if (io_in_valid & io_in_ready) begin // @[Uart.scala 21:38]
      bits_9 <= _T_1[9]; // @[Uart.scala 22:14]
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
  reg [10:0] rateCounter; // @[Uart.scala 46:30]
  reg [2:0] bitCounter; // @[Uart.scala 47:29]
  reg  bits_1; // @[Uart.scala 48:19]
  reg  bits_2; // @[Uart.scala 48:19]
  reg  bits_3; // @[Uart.scala 48:19]
  reg  bits_4; // @[Uart.scala 48:19]
  reg  bits_5; // @[Uart.scala 48:19]
  reg  bits_6; // @[Uart.scala 48:19]
  reg  bits_7; // @[Uart.scala 48:19]
  reg  rxRegs_0; // @[Uart.scala 49:25]
  reg  rxRegs_1; // @[Uart.scala 49:25]
  reg  rxRegs_2; // @[Uart.scala 49:25]
  reg  overrun; // @[Uart.scala 50:26]
  reg  running; // @[Uart.scala 51:26]
  reg  outValid; // @[Uart.scala 53:27]
  reg [7:0] outBits; // @[Uart.scala 54:22]
  wire  _GEN_0 = outValid & io_out_ready ? 1'h0 : outValid; // @[Uart.scala 59:32 60:18 53:27]
  wire  _GEN_3 = ~rxRegs_1 & rxRegs_0 | running; // @[Uart.scala 70:39 73:21 51:26]
  wire [7:0] _outBits_T_1 = {rxRegs_0,bits_7,bits_6,bits_5,bits_4,bits_3,bits_2,bits_1}; // @[Cat.scala 33:92]
  wire [2:0] _bitCounter_T_1 = bitCounter - 3'h1; // @[Uart.scala 86:42]
  wire  _GEN_4 = bitCounter == 3'h0 | _GEN_0; // @[Uart.scala 79:38 80:26]
  wire [10:0] _rateCounter_T_1 = rateCounter - 11'h1; // @[Uart.scala 89:40]
  assign io_out_valid = outValid; // @[Uart.scala 56:18]
  assign io_out_bits = outBits; // @[Uart.scala 57:17]
  assign io_overrun = overrun; // @[Uart.scala 67:16]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 46:30]
      rateCounter <= 11'h0; // @[Uart.scala 46:30]
    end else if (~running) begin // @[Uart.scala 69:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[Uart.scala 70:39]
        rateCounter <= 11'h515; // @[Uart.scala 71:25]
      end
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
      if (!(bitCounter == 3'h0)) begin // @[Uart.scala 79:38]
        rateCounter <= 11'h363; // @[Uart.scala 85:29]
      end
    end else begin
      rateCounter <= _rateCounter_T_1; // @[Uart.scala 89:25]
    end
    if (reset) begin // @[Uart.scala 47:29]
      bitCounter <= 3'h0; // @[Uart.scala 47:29]
    end else if (~running) begin // @[Uart.scala 69:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[Uart.scala 70:39]
        bitCounter <= 3'h7; // @[Uart.scala 72:24]
      end
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
      if (!(bitCounter == 3'h0)) begin // @[Uart.scala 79:38]
        bitCounter <= _bitCounter_T_1; // @[Uart.scala 86:28]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_1 <= bits_2; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_2 <= bits_3; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_3 <= bits_4; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_4 <= bits_5; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_5 <= bits_6; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_6 <= bits_7; // @[Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        bits_7 <= rxRegs_0; // @[Uart.scala 77:34]
      end
    end
    if (reset) begin // @[Uart.scala 49:25]
      rxRegs_0 <= 1'h0; // @[Uart.scala 49:25]
    end else begin
      rxRegs_0 <= rxRegs_1; // @[Uart.scala 65:52]
    end
    if (reset) begin // @[Uart.scala 49:25]
      rxRegs_1 <= 1'h0; // @[Uart.scala 49:25]
    end else begin
      rxRegs_1 <= rxRegs_2; // @[Uart.scala 65:52]
    end
    if (reset) begin // @[Uart.scala 49:25]
      rxRegs_2 <= 1'h0; // @[Uart.scala 49:25]
    end else begin
      rxRegs_2 <= io_rx; // @[Uart.scala 64:26]
    end
    if (reset) begin // @[Uart.scala 50:26]
      overrun <= 1'h0; // @[Uart.scala 50:26]
    end else if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        if (bitCounter == 3'h0) begin // @[Uart.scala 79:38]
          overrun <= outValid; // @[Uart.scala 82:25]
        end
      end
    end
    if (reset) begin // @[Uart.scala 51:26]
      running <= 1'h0; // @[Uart.scala 51:26]
    end else if (~running) begin // @[Uart.scala 69:20]
      running <= _GEN_3;
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
      if (bitCounter == 3'h0) begin // @[Uart.scala 79:38]
        running <= 1'h0; // @[Uart.scala 83:25]
      end
    end
    if (reset) begin // @[Uart.scala 53:27]
      outValid <= 1'h0; // @[Uart.scala 53:27]
    end else if (~running) begin // @[Uart.scala 69:20]
      outValid <= _GEN_0;
    end else if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
      outValid <= _GEN_4;
    end else begin
      outValid <= _GEN_0;
    end
    if (!(~running)) begin // @[Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[Uart.scala 76:35]
        if (bitCounter == 3'h0) begin // @[Uart.scala 79:38]
          outBits <= _outBits_T_1; // @[Uart.scala 81:25]
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
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[Uart.scala 102:18]
  wire  tx_reset; // @[Uart.scala 102:18]
  wire  tx_io_in_ready; // @[Uart.scala 102:18]
  wire  tx_io_in_valid; // @[Uart.scala 102:18]
  wire [7:0] tx_io_in_bits; // @[Uart.scala 102:18]
  wire  tx_io_tx; // @[Uart.scala 102:18]
  wire  rx_clock; // @[Uart.scala 110:18]
  wire  rx_reset; // @[Uart.scala 110:18]
  wire  rx_io_out_ready; // @[Uart.scala 110:18]
  wire  rx_io_out_valid; // @[Uart.scala 110:18]
  wire [7:0] rx_io_out_bits; // @[Uart.scala 110:18]
  wire  rx_io_rx; // @[Uart.scala 110:18]
  wire  rx_io_overrun; // @[Uart.scala 110:18]
  reg  tx_empty; // @[Uart.scala 103:25]
  reg [7:0] tx_data; // @[Uart.scala 105:24]
  reg  tx_intr_en; // @[Uart.scala 106:27]
  wire  _tx_io_in_valid_T = ~tx_empty; // @[Uart.scala 107:21]
  reg [7:0] rx_data; // @[Uart.scala 111:24]
  reg  rx_data_ready; // @[Uart.scala 112:30]
  reg  rx_intr_en; // @[Uart.scala 113:27]
  wire  _rx_io_out_ready_T = ~rx_data_ready; // @[Uart.scala 115:22]
  wire  _GEN_1 = rx_io_out_valid & _rx_io_out_ready_T | rx_data_ready; // @[Uart.scala 116:44 118:19 112:30]
  wire [31:0] _io_mem_rdata_T_1 = {27'h0,rx_io_overrun,rx_data_ready,_tx_io_in_valid_T,rx_intr_en,tx_intr_en}; // @[Cat.scala 33:92]
  wire [31:0] _GEN_2 = io_mem_raddr[2] ? {{24'd0}, rx_data} : 32'hdeadbeef; // @[Uart.scala 121:16 126:33 131:22]
  wire [31:0] _GEN_4 = ~io_mem_raddr[2] ? _io_mem_rdata_T_1 : _GEN_2; // @[Uart.scala 126:33 128:22]
  wire  _GEN_8 = tx_empty ? 1'h0 : tx_empty; // @[Uart.scala 144:25 145:20 103:25]
  wire [31:0] _GEN_9 = tx_empty ? io_mem_wdata : {{24'd0}, tx_data}; // @[Uart.scala 144:25 146:19 105:24]
  wire  _GEN_10 = io_mem_waddr[2] ? _GEN_8 : tx_empty; // @[Uart.scala 103:25 138:33]
  wire [31:0] _GEN_11 = io_mem_waddr[2] ? _GEN_9 : {{24'd0}, tx_data}; // @[Uart.scala 105:24 138:33]
  wire  _GEN_14 = ~io_mem_waddr[2] ? tx_empty : _GEN_10; // @[Uart.scala 103:25 138:33]
  wire [31:0] _GEN_15 = ~io_mem_waddr[2] ? {{24'd0}, tx_data} : _GEN_11; // @[Uart.scala 105:24 138:33]
  wire  _GEN_18 = io_mem_wen ? _GEN_14 : tx_empty; // @[Uart.scala 137:21 103:25]
  wire [31:0] _GEN_19 = io_mem_wen ? _GEN_15 : {{24'd0}, tx_data}; // @[Uart.scala 137:21 105:24]
  wire  tx_ready = tx_io_in_ready; // @[Uart.scala 104:{29,29}]
  wire  _GEN_20 = _tx_io_in_valid_T & tx_ready | _GEN_18; // @[Uart.scala 152:31 153:14]
  wire [31:0] _GEN_21 = reset ? 32'h0 : _GEN_19; // @[Uart.scala 105:{24,24}]
  UartTx tx ( // @[Uart.scala 102:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_in_ready(tx_io_in_ready),
    .io_in_valid(tx_io_in_valid),
    .io_in_bits(tx_io_in_bits),
    .io_tx(tx_io_tx)
  );
  UartRx rx ( // @[Uart.scala 110:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_out_ready(rx_io_out_ready),
    .io_out_valid(rx_io_out_valid),
    .io_out_bits(rx_io_out_bits),
    .io_rx(rx_io_rx),
    .io_overrun(rx_io_overrun)
  );
  assign io_mem_rdata = io_mem_ren ? _GEN_4 : 32'hdeadbeef; // @[Uart.scala 121:16 125:21]
  assign io_intr = tx_empty & tx_intr_en | rx_data_ready & rx_intr_en; // @[Uart.scala 156:39]
  assign io_tx = tx_io_tx; // @[Uart.scala 157:9]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = ~tx_empty; // @[Uart.scala 107:21]
  assign tx_io_in_bits = tx_data; // @[Uart.scala 108:17]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_out_ready = ~rx_data_ready; // @[Uart.scala 115:22]
  assign rx_io_rx = io_rx; // @[Uart.scala 158:9]
  always @(posedge clock) begin
    tx_empty <= reset | _GEN_20; // @[Uart.scala 103:{25,25}]
    tx_data <= _GEN_21[7:0]; // @[Uart.scala 105:{24,24}]
    if (reset) begin // @[Uart.scala 106:27]
      tx_intr_en <= 1'h0; // @[Uart.scala 106:27]
    end else if (io_mem_wen) begin // @[Uart.scala 137:21]
      if (~io_mem_waddr[2]) begin // @[Uart.scala 138:33]
        tx_intr_en <= io_mem_wdata[0]; // @[Uart.scala 140:20]
      end
    end
    if (reset) begin // @[Uart.scala 111:24]
      rx_data <= 8'h0; // @[Uart.scala 111:24]
    end else if (rx_io_out_valid & _rx_io_out_ready_T) begin // @[Uart.scala 116:44]
      rx_data <= rx_io_out_bits; // @[Uart.scala 117:13]
    end
    if (reset) begin // @[Uart.scala 112:30]
      rx_data_ready <= 1'h0; // @[Uart.scala 112:30]
    end else if (io_mem_ren) begin // @[Uart.scala 125:21]
      if (~io_mem_raddr[2]) begin // @[Uart.scala 126:33]
        rx_data_ready <= _GEN_1;
      end else if (io_mem_raddr[2]) begin // @[Uart.scala 126:33]
        rx_data_ready <= 1'h0; // @[Uart.scala 132:23]
      end else begin
        rx_data_ready <= _GEN_1;
      end
    end else begin
      rx_data_ready <= _GEN_1;
    end
    if (reset) begin // @[Uart.scala 113:27]
      rx_intr_en <= 1'h0; // @[Uart.scala 113:27]
    end else if (io_mem_wen) begin // @[Uart.scala 137:21]
      if (~io_mem_waddr[2]) begin // @[Uart.scala 138:33]
        rx_intr_en <= io_mem_wdata[1]; // @[Uart.scala 141:20]
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
  _RAND_3 = {1{`RANDOM}};
  rx_data = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  rx_data_ready = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  rx_intr_en = _RAND_5[0:0];
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
  reg [159:0] _RAND_144;
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
  reg  rx_res_in_progress; // @[Sdc.scala 104:35]
  reg [7:0] rx_res_counter; // @[Sdc.scala 105:31]
  reg  rx_res_bits_0; // @[Sdc.scala 106:24]
  reg  rx_res_bits_1; // @[Sdc.scala 106:24]
  reg  rx_res_bits_2; // @[Sdc.scala 106:24]
  reg  rx_res_bits_3; // @[Sdc.scala 106:24]
  reg  rx_res_bits_4; // @[Sdc.scala 106:24]
  reg  rx_res_bits_5; // @[Sdc.scala 106:24]
  reg  rx_res_bits_6; // @[Sdc.scala 106:24]
  reg  rx_res_bits_7; // @[Sdc.scala 106:24]
  reg  rx_res_bits_8; // @[Sdc.scala 106:24]
  reg  rx_res_bits_9; // @[Sdc.scala 106:24]
  reg  rx_res_bits_10; // @[Sdc.scala 106:24]
  reg  rx_res_bits_11; // @[Sdc.scala 106:24]
  reg  rx_res_bits_12; // @[Sdc.scala 106:24]
  reg  rx_res_bits_13; // @[Sdc.scala 106:24]
  reg  rx_res_bits_14; // @[Sdc.scala 106:24]
  reg  rx_res_bits_15; // @[Sdc.scala 106:24]
  reg  rx_res_bits_16; // @[Sdc.scala 106:24]
  reg  rx_res_bits_17; // @[Sdc.scala 106:24]
  reg  rx_res_bits_18; // @[Sdc.scala 106:24]
  reg  rx_res_bits_19; // @[Sdc.scala 106:24]
  reg  rx_res_bits_20; // @[Sdc.scala 106:24]
  reg  rx_res_bits_21; // @[Sdc.scala 106:24]
  reg  rx_res_bits_22; // @[Sdc.scala 106:24]
  reg  rx_res_bits_23; // @[Sdc.scala 106:24]
  reg  rx_res_bits_24; // @[Sdc.scala 106:24]
  reg  rx_res_bits_25; // @[Sdc.scala 106:24]
  reg  rx_res_bits_26; // @[Sdc.scala 106:24]
  reg  rx_res_bits_27; // @[Sdc.scala 106:24]
  reg  rx_res_bits_28; // @[Sdc.scala 106:24]
  reg  rx_res_bits_29; // @[Sdc.scala 106:24]
  reg  rx_res_bits_30; // @[Sdc.scala 106:24]
  reg  rx_res_bits_31; // @[Sdc.scala 106:24]
  reg  rx_res_bits_32; // @[Sdc.scala 106:24]
  reg  rx_res_bits_33; // @[Sdc.scala 106:24]
  reg  rx_res_bits_34; // @[Sdc.scala 106:24]
  reg  rx_res_bits_35; // @[Sdc.scala 106:24]
  reg  rx_res_bits_36; // @[Sdc.scala 106:24]
  reg  rx_res_bits_37; // @[Sdc.scala 106:24]
  reg  rx_res_bits_38; // @[Sdc.scala 106:24]
  reg  rx_res_bits_39; // @[Sdc.scala 106:24]
  reg  rx_res_bits_40; // @[Sdc.scala 106:24]
  reg  rx_res_bits_41; // @[Sdc.scala 106:24]
  reg  rx_res_bits_42; // @[Sdc.scala 106:24]
  reg  rx_res_bits_43; // @[Sdc.scala 106:24]
  reg  rx_res_bits_44; // @[Sdc.scala 106:24]
  reg  rx_res_bits_45; // @[Sdc.scala 106:24]
  reg  rx_res_bits_46; // @[Sdc.scala 106:24]
  reg  rx_res_bits_47; // @[Sdc.scala 106:24]
  reg  rx_res_bits_48; // @[Sdc.scala 106:24]
  reg  rx_res_bits_49; // @[Sdc.scala 106:24]
  reg  rx_res_bits_50; // @[Sdc.scala 106:24]
  reg  rx_res_bits_51; // @[Sdc.scala 106:24]
  reg  rx_res_bits_52; // @[Sdc.scala 106:24]
  reg  rx_res_bits_53; // @[Sdc.scala 106:24]
  reg  rx_res_bits_54; // @[Sdc.scala 106:24]
  reg  rx_res_bits_55; // @[Sdc.scala 106:24]
  reg  rx_res_bits_56; // @[Sdc.scala 106:24]
  reg  rx_res_bits_57; // @[Sdc.scala 106:24]
  reg  rx_res_bits_58; // @[Sdc.scala 106:24]
  reg  rx_res_bits_59; // @[Sdc.scala 106:24]
  reg  rx_res_bits_60; // @[Sdc.scala 106:24]
  reg  rx_res_bits_61; // @[Sdc.scala 106:24]
  reg  rx_res_bits_62; // @[Sdc.scala 106:24]
  reg  rx_res_bits_63; // @[Sdc.scala 106:24]
  reg  rx_res_bits_64; // @[Sdc.scala 106:24]
  reg  rx_res_bits_65; // @[Sdc.scala 106:24]
  reg  rx_res_bits_66; // @[Sdc.scala 106:24]
  reg  rx_res_bits_67; // @[Sdc.scala 106:24]
  reg  rx_res_bits_68; // @[Sdc.scala 106:24]
  reg  rx_res_bits_69; // @[Sdc.scala 106:24]
  reg  rx_res_bits_70; // @[Sdc.scala 106:24]
  reg  rx_res_bits_71; // @[Sdc.scala 106:24]
  reg  rx_res_bits_72; // @[Sdc.scala 106:24]
  reg  rx_res_bits_73; // @[Sdc.scala 106:24]
  reg  rx_res_bits_74; // @[Sdc.scala 106:24]
  reg  rx_res_bits_75; // @[Sdc.scala 106:24]
  reg  rx_res_bits_76; // @[Sdc.scala 106:24]
  reg  rx_res_bits_77; // @[Sdc.scala 106:24]
  reg  rx_res_bits_78; // @[Sdc.scala 106:24]
  reg  rx_res_bits_79; // @[Sdc.scala 106:24]
  reg  rx_res_bits_80; // @[Sdc.scala 106:24]
  reg  rx_res_bits_81; // @[Sdc.scala 106:24]
  reg  rx_res_bits_82; // @[Sdc.scala 106:24]
  reg  rx_res_bits_83; // @[Sdc.scala 106:24]
  reg  rx_res_bits_84; // @[Sdc.scala 106:24]
  reg  rx_res_bits_85; // @[Sdc.scala 106:24]
  reg  rx_res_bits_86; // @[Sdc.scala 106:24]
  reg  rx_res_bits_87; // @[Sdc.scala 106:24]
  reg  rx_res_bits_88; // @[Sdc.scala 106:24]
  reg  rx_res_bits_89; // @[Sdc.scala 106:24]
  reg  rx_res_bits_90; // @[Sdc.scala 106:24]
  reg  rx_res_bits_91; // @[Sdc.scala 106:24]
  reg  rx_res_bits_92; // @[Sdc.scala 106:24]
  reg  rx_res_bits_93; // @[Sdc.scala 106:24]
  reg  rx_res_bits_94; // @[Sdc.scala 106:24]
  reg  rx_res_bits_95; // @[Sdc.scala 106:24]
  reg  rx_res_bits_96; // @[Sdc.scala 106:24]
  reg  rx_res_bits_97; // @[Sdc.scala 106:24]
  reg  rx_res_bits_98; // @[Sdc.scala 106:24]
  reg  rx_res_bits_99; // @[Sdc.scala 106:24]
  reg  rx_res_bits_100; // @[Sdc.scala 106:24]
  reg  rx_res_bits_101; // @[Sdc.scala 106:24]
  reg  rx_res_bits_102; // @[Sdc.scala 106:24]
  reg  rx_res_bits_103; // @[Sdc.scala 106:24]
  reg  rx_res_bits_104; // @[Sdc.scala 106:24]
  reg  rx_res_bits_105; // @[Sdc.scala 106:24]
  reg  rx_res_bits_106; // @[Sdc.scala 106:24]
  reg  rx_res_bits_107; // @[Sdc.scala 106:24]
  reg  rx_res_bits_108; // @[Sdc.scala 106:24]
  reg  rx_res_bits_109; // @[Sdc.scala 106:24]
  reg  rx_res_bits_110; // @[Sdc.scala 106:24]
  reg  rx_res_bits_111; // @[Sdc.scala 106:24]
  reg  rx_res_bits_112; // @[Sdc.scala 106:24]
  reg  rx_res_bits_113; // @[Sdc.scala 106:24]
  reg  rx_res_bits_114; // @[Sdc.scala 106:24]
  reg  rx_res_bits_115; // @[Sdc.scala 106:24]
  reg  rx_res_bits_116; // @[Sdc.scala 106:24]
  reg  rx_res_bits_117; // @[Sdc.scala 106:24]
  reg  rx_res_bits_118; // @[Sdc.scala 106:24]
  reg  rx_res_bits_119; // @[Sdc.scala 106:24]
  reg  rx_res_bits_120; // @[Sdc.scala 106:24]
  reg  rx_res_bits_121; // @[Sdc.scala 106:24]
  reg  rx_res_bits_122; // @[Sdc.scala 106:24]
  reg  rx_res_bits_123; // @[Sdc.scala 106:24]
  reg  rx_res_bits_124; // @[Sdc.scala 106:24]
  reg  rx_res_bits_125; // @[Sdc.scala 106:24]
  reg  rx_res_bits_126; // @[Sdc.scala 106:24]
  reg  rx_res_bits_127; // @[Sdc.scala 106:24]
  reg  rx_res_bits_128; // @[Sdc.scala 106:24]
  reg  rx_res_bits_129; // @[Sdc.scala 106:24]
  reg  rx_res_bits_130; // @[Sdc.scala 106:24]
  reg  rx_res_bits_131; // @[Sdc.scala 106:24]
  reg  rx_res_bits_132; // @[Sdc.scala 106:24]
  reg  rx_res_bits_133; // @[Sdc.scala 106:24]
  reg  rx_res_bits_134; // @[Sdc.scala 106:24]
  reg  rx_res_bits_135; // @[Sdc.scala 106:24]
  reg  rx_res_next; // @[Sdc.scala 107:28]
  reg [3:0] rx_res_type; // @[Sdc.scala 108:28]
  reg [135:0] rx_res; // @[Sdc.scala 109:23]
  reg  rx_res_ready; // @[Sdc.scala 110:29]
  reg  rx_res_intr_en; // @[Sdc.scala 111:31]
  reg  rx_res_crc_0; // @[Sdc.scala 112:23]
  reg  rx_res_crc_1; // @[Sdc.scala 112:23]
  reg  rx_res_crc_2; // @[Sdc.scala 112:23]
  reg  rx_res_crc_3; // @[Sdc.scala 112:23]
  reg  rx_res_crc_4; // @[Sdc.scala 112:23]
  reg  rx_res_crc_5; // @[Sdc.scala 112:23]
  reg  rx_res_crc_6; // @[Sdc.scala 112:23]
  reg  rx_res_crc_error; // @[Sdc.scala 113:33]
  reg  rx_res_crc_en; // @[Sdc.scala 114:30]
  reg [7:0] rx_res_timer; // @[Sdc.scala 115:29]
  reg  rx_res_timeout; // @[Sdc.scala 116:31]
  reg [1:0] rx_res_read_counter; // @[Sdc.scala 117:36]
  reg [31:0] tx_cmd_arg; // @[Sdc.scala 118:27]
  reg  tx_cmd_0; // @[Sdc.scala 119:19]
  reg  tx_cmd_1; // @[Sdc.scala 119:19]
  reg  tx_cmd_2; // @[Sdc.scala 119:19]
  reg  tx_cmd_3; // @[Sdc.scala 119:19]
  reg  tx_cmd_4; // @[Sdc.scala 119:19]
  reg  tx_cmd_5; // @[Sdc.scala 119:19]
  reg  tx_cmd_6; // @[Sdc.scala 119:19]
  reg  tx_cmd_7; // @[Sdc.scala 119:19]
  reg  tx_cmd_8; // @[Sdc.scala 119:19]
  reg  tx_cmd_9; // @[Sdc.scala 119:19]
  reg  tx_cmd_10; // @[Sdc.scala 119:19]
  reg  tx_cmd_11; // @[Sdc.scala 119:19]
  reg  tx_cmd_12; // @[Sdc.scala 119:19]
  reg  tx_cmd_13; // @[Sdc.scala 119:19]
  reg  tx_cmd_14; // @[Sdc.scala 119:19]
  reg  tx_cmd_15; // @[Sdc.scala 119:19]
  reg  tx_cmd_16; // @[Sdc.scala 119:19]
  reg  tx_cmd_17; // @[Sdc.scala 119:19]
  reg  tx_cmd_18; // @[Sdc.scala 119:19]
  reg  tx_cmd_19; // @[Sdc.scala 119:19]
  reg  tx_cmd_20; // @[Sdc.scala 119:19]
  reg  tx_cmd_21; // @[Sdc.scala 119:19]
  reg  tx_cmd_22; // @[Sdc.scala 119:19]
  reg  tx_cmd_23; // @[Sdc.scala 119:19]
  reg  tx_cmd_24; // @[Sdc.scala 119:19]
  reg  tx_cmd_25; // @[Sdc.scala 119:19]
  reg  tx_cmd_26; // @[Sdc.scala 119:19]
  reg  tx_cmd_27; // @[Sdc.scala 119:19]
  reg  tx_cmd_28; // @[Sdc.scala 119:19]
  reg  tx_cmd_29; // @[Sdc.scala 119:19]
  reg  tx_cmd_30; // @[Sdc.scala 119:19]
  reg  tx_cmd_31; // @[Sdc.scala 119:19]
  reg  tx_cmd_32; // @[Sdc.scala 119:19]
  reg  tx_cmd_33; // @[Sdc.scala 119:19]
  reg  tx_cmd_34; // @[Sdc.scala 119:19]
  reg  tx_cmd_35; // @[Sdc.scala 119:19]
  reg  tx_cmd_36; // @[Sdc.scala 119:19]
  reg  tx_cmd_37; // @[Sdc.scala 119:19]
  reg  tx_cmd_38; // @[Sdc.scala 119:19]
  reg  tx_cmd_39; // @[Sdc.scala 119:19]
  reg  tx_cmd_40; // @[Sdc.scala 119:19]
  reg  tx_cmd_41; // @[Sdc.scala 119:19]
  reg  tx_cmd_42; // @[Sdc.scala 119:19]
  reg  tx_cmd_43; // @[Sdc.scala 119:19]
  reg  tx_cmd_44; // @[Sdc.scala 119:19]
  reg  tx_cmd_45; // @[Sdc.scala 119:19]
  reg  tx_cmd_46; // @[Sdc.scala 119:19]
  reg  tx_cmd_47; // @[Sdc.scala 119:19]
  reg [5:0] tx_cmd_counter; // @[Sdc.scala 120:31]
  reg  tx_cmd_crc_0; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_1; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_2; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_3; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_4; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_5; // @[Sdc.scala 121:23]
  reg  tx_cmd_crc_6; // @[Sdc.scala 121:23]
  reg [5:0] tx_cmd_timer; // @[Sdc.scala 122:29]
  reg  reg_tx_cmd_wrt; // @[Sdc.scala 123:31]
  reg  reg_tx_cmd_out; // @[Sdc.scala 124:31]
  reg  rx_dat_in_progress; // @[Sdc.scala 125:35]
  reg [10:0] rx_dat_counter; // @[Sdc.scala 126:31]
  reg  rx_dat_start_bit; // @[Sdc.scala 127:33]
  reg [3:0] rx_dat_bits_0; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_1; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_2; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_3; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_4; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_5; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_6; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_bits_7; // @[Sdc.scala 128:24]
  reg [3:0] rx_dat_next; // @[Sdc.scala 129:28]
  reg  rx_dat_continuous; // @[Sdc.scala 130:34]
  reg  rx_dat_ready; // @[Sdc.scala 131:29]
  reg  rx_dat_intr_en; // @[Sdc.scala 132:31]
  reg [3:0] rx_dat_crc_0; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_1; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_2; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_3; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_4; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_5; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_6; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_7; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_8; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_9; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_10; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_11; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_12; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_13; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_14; // @[Sdc.scala 133:23]
  reg [3:0] rx_dat_crc_15; // @[Sdc.scala 133:23]
  reg  rx_dat_crc_error; // @[Sdc.scala 134:33]
  reg [18:0] rx_dat_timer; // @[Sdc.scala 135:29]
  reg  rx_dat_timeout; // @[Sdc.scala 136:31]
  reg  rx_dat_overrun; // @[Sdc.scala 137:31]
  reg [7:0] rxtx_dat_counter; // @[Sdc.scala 139:33]
  reg [7:0] rxtx_dat_index; // @[Sdc.scala 140:31]
  reg [18:0] rx_busy_timer; // @[Sdc.scala 141:30]
  reg  rx_busy_in_progress; // @[Sdc.scala 142:36]
  reg  rx_dat0_next; // @[Sdc.scala 143:29]
  reg  rx_dat_buf_read; // @[Sdc.scala 144:32]
  reg [31:0] rx_dat_buf_cache; // @[Sdc.scala 145:33]
  reg  reg_tx_dat_wrt; // @[Sdc.scala 146:31]
  reg  reg_tx_dat_out; // @[Sdc.scala 147:31]
  reg  tx_empty_intr_en; // @[Sdc.scala 148:33]
  reg  tx_end_intr_en; // @[Sdc.scala 149:31]
  reg [10:0] tx_dat_counter; // @[Sdc.scala 150:31]
  reg [5:0] tx_dat_timer; // @[Sdc.scala 151:29]
  reg [3:0] tx_dat_0; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_1; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_2; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_3; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_4; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_5; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_6; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_7; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_8; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_9; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_10; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_11; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_12; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_13; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_14; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_15; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_16; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_17; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_18; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_19; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_20; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_21; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_22; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_23; // @[Sdc.scala 152:19]
  reg [3:0] tx_dat_crc_0; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_1; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_2; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_3; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_4; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_5; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_6; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_7; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_8; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_9; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_10; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_11; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_12; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_13; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_14; // @[Sdc.scala 153:23]
  reg [3:0] tx_dat_crc_15; // @[Sdc.scala 153:23]
  reg [31:0] tx_dat_prepared; // @[Sdc.scala 154:32]
  reg [1:0] tx_dat_prepare_state; // @[Sdc.scala 155:37]
  reg  tx_dat_started; // @[Sdc.scala 156:31]
  reg  tx_dat_in_progress; // @[Sdc.scala 158:35]
  reg  tx_dat_end; // @[Sdc.scala 159:27]
  reg [1:0] tx_dat_read_sel; // @[Sdc.scala 160:32]
  reg [1:0] tx_dat_write_sel; // @[Sdc.scala 161:33]
  reg  tx_dat_read_sel_changed; // @[Sdc.scala 162:40]
  reg  tx_dat_write_sel_new; // @[Sdc.scala 163:37]
  reg [3:0] tx_dat_crc_status_counter; // @[Sdc.scala 164:42]
  reg  tx_dat_crc_status_b_0; // @[Sdc.scala 165:32]
  reg  tx_dat_crc_status_b_1; // @[Sdc.scala 165:32]
  reg  tx_dat_crc_status_b_2; // @[Sdc.scala 165:32]
  reg [1:0] tx_dat_crc_status; // @[Sdc.scala 166:34]
  reg  tx_dat_prepared_read; // @[Sdc.scala 167:37]
  wire  _T_2 = tx_cmd_counter == 6'h0; // @[Sdc.scala 169:48]
  wire  _T_5 = _T & reg_clk; // @[Sdc.scala 171:35]
  wire [7:0] _rx_res_timer_T_1 = rx_res_timer - 8'h1; // @[Sdc.scala 173:38]
  wire [7:0] _GEN_4 = rx_res_timer == 8'h1 ? 8'h0 : rx_res_counter; // @[Sdc.scala 174:37 175:26 105:31]
  wire [135:0] _GEN_5 = rx_res_timer == 8'h1 ? 136'h0 : rx_res; // @[Sdc.scala 174:37 176:18 109:23]
  wire  _GEN_6 = rx_res_timer == 8'h1 | rx_res_ready; // @[Sdc.scala 174:37 177:24 110:29]
  wire  _GEN_7 = rx_res_timer == 8'h1 | rx_res_timeout; // @[Sdc.scala 174:37 178:26 116:31]
  wire [7:0] _GEN_8 = ~rx_res_in_progress & rx_res_next ? _rx_res_timer_T_1 : rx_res_timer; // @[Sdc.scala 172:49 173:22 115:29]
  wire [7:0] _GEN_9 = ~rx_res_in_progress & rx_res_next ? _GEN_4 : rx_res_counter; // @[Sdc.scala 105:31 172:49]
  wire [135:0] _GEN_10 = ~rx_res_in_progress & rx_res_next ? _GEN_5 : rx_res; // @[Sdc.scala 109:23 172:49]
  wire  _GEN_11 = ~rx_res_in_progress & rx_res_next ? _GEN_6 : rx_res_ready; // @[Sdc.scala 110:29 172:49]
  wire  _GEN_12 = ~rx_res_in_progress & rx_res_next ? _GEN_7 : rx_res_timeout; // @[Sdc.scala 116:31 172:49]
  wire [7:0] _rx_res_counter_T_1 = rx_res_counter - 8'h1; // @[Sdc.scala 184:42]
  wire [7:0] rx_res_lo_lo_lo_lo = {rx_res_bits_7,rx_res_bits_6,rx_res_bits_5,rx_res_bits_4,rx_res_bits_3,rx_res_bits_2,
    rx_res_bits_1,rx_res_bits_0}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_lo_lo_lo = {rx_res_bits_16,rx_res_bits_15,rx_res_bits_14,rx_res_bits_13,rx_res_bits_12,
    rx_res_bits_11,rx_res_bits_10,rx_res_bits_9,rx_res_bits_8,rx_res_lo_lo_lo_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_lo_lo_hi_lo = {rx_res_bits_24,rx_res_bits_23,rx_res_bits_22,rx_res_bits_21,rx_res_bits_20,
    rx_res_bits_19,rx_res_bits_18,rx_res_bits_17}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_lo_lo_hi = {rx_res_bits_33,rx_res_bits_32,rx_res_bits_31,rx_res_bits_30,rx_res_bits_29,
    rx_res_bits_28,rx_res_bits_27,rx_res_bits_26,rx_res_bits_25,rx_res_lo_lo_hi_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_lo_hi_lo_lo = {rx_res_bits_41,rx_res_bits_40,rx_res_bits_39,rx_res_bits_38,rx_res_bits_37,
    rx_res_bits_36,rx_res_bits_35,rx_res_bits_34}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_lo_hi_lo = {rx_res_bits_50,rx_res_bits_49,rx_res_bits_48,rx_res_bits_47,rx_res_bits_46,
    rx_res_bits_45,rx_res_bits_44,rx_res_bits_43,rx_res_bits_42,rx_res_lo_hi_lo_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_lo_hi_hi_lo = {rx_res_bits_58,rx_res_bits_57,rx_res_bits_56,rx_res_bits_55,rx_res_bits_54,
    rx_res_bits_53,rx_res_bits_52,rx_res_bits_51}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_lo_hi_hi = {rx_res_bits_67,rx_res_bits_66,rx_res_bits_65,rx_res_bits_64,rx_res_bits_63,
    rx_res_bits_62,rx_res_bits_61,rx_res_bits_60,rx_res_bits_59,rx_res_lo_hi_hi_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_hi_lo_lo_lo = {rx_res_bits_75,rx_res_bits_74,rx_res_bits_73,rx_res_bits_72,rx_res_bits_71,
    rx_res_bits_70,rx_res_bits_69,rx_res_bits_68}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_hi_lo_lo = {rx_res_bits_84,rx_res_bits_83,rx_res_bits_82,rx_res_bits_81,rx_res_bits_80,
    rx_res_bits_79,rx_res_bits_78,rx_res_bits_77,rx_res_bits_76,rx_res_hi_lo_lo_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_hi_lo_hi_lo = {rx_res_bits_92,rx_res_bits_91,rx_res_bits_90,rx_res_bits_89,rx_res_bits_88,
    rx_res_bits_87,rx_res_bits_86,rx_res_bits_85}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_hi_lo_hi = {rx_res_bits_101,rx_res_bits_100,rx_res_bits_99,rx_res_bits_98,rx_res_bits_97,
    rx_res_bits_96,rx_res_bits_95,rx_res_bits_94,rx_res_bits_93,rx_res_hi_lo_hi_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_hi_hi_lo_lo = {rx_res_bits_109,rx_res_bits_108,rx_res_bits_107,rx_res_bits_106,rx_res_bits_105,
    rx_res_bits_104,rx_res_bits_103,rx_res_bits_102}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_hi_hi_lo = {rx_res_bits_118,rx_res_bits_117,rx_res_bits_116,rx_res_bits_115,rx_res_bits_114,
    rx_res_bits_113,rx_res_bits_112,rx_res_bits_111,rx_res_bits_110,rx_res_hi_hi_lo_lo}; // @[Cat.scala 33:92]
  wire [7:0] rx_res_hi_hi_hi_lo = {rx_res_bits_126,rx_res_bits_125,rx_res_bits_124,rx_res_bits_123,rx_res_bits_122,
    rx_res_bits_121,rx_res_bits_120,rx_res_bits_119}; // @[Cat.scala 33:92]
  wire [16:0] rx_res_hi_hi_hi = {rx_res_bits_135,rx_res_bits_134,rx_res_bits_133,rx_res_bits_132,rx_res_bits_131,
    rx_res_bits_130,rx_res_bits_129,rx_res_bits_128,rx_res_bits_127,rx_res_hi_hi_hi_lo}; // @[Cat.scala 33:92]
  wire [136:0] _rx_res_T_1 = {rx_res_hi_hi_hi,rx_res_hi_hi_lo,rx_res_hi_lo_hi,rx_res_hi_lo_lo,rx_res_lo_hi_hi,
    rx_res_lo_hi_lo,rx_res_lo_lo_hi,rx_res_lo_lo_lo,rx_res_next}; // @[Cat.scala 33:92]
  wire [6:0] _rx_res_crc_error_T = {rx_res_crc_0,rx_res_crc_1,rx_res_crc_2,rx_res_crc_3,rx_res_crc_4,rx_res_crc_5,
    rx_res_crc_6}; // @[Cat.scala 33:92]
  wire [18:0] _GEN_13 = rx_res_type == 4'h5 ? 19'h7a120 : rx_busy_timer; // @[Sdc.scala 201:47 202:27 141:30]
  wire  _GEN_14 = rx_res_counter == 8'h1 ? 1'h0 : 1'h1; // @[Sdc.scala 185:28 195:39 197:30]
  wire [136:0] _GEN_15 = rx_res_counter == 8'h1 ? _rx_res_T_1 : {{1'd0}, _GEN_10}; // @[Sdc.scala 195:39 198:18]
  wire  _GEN_16 = rx_res_counter == 8'h1 | _GEN_11; // @[Sdc.scala 195:39 199:24]
  wire  _GEN_17 = rx_res_counter == 8'h1 ? rx_res_crc_en & _rx_res_crc_error_T != 7'h0 : rx_res_crc_error; // @[Sdc.scala 195:39 200:28 113:33]
  wire [18:0] _GEN_18 = rx_res_counter == 8'h1 ? _GEN_13 : rx_busy_timer; // @[Sdc.scala 141:30 195:39]
  wire [5:0] _GEN_19 = rx_res_counter == 8'h1 ? 6'h30 : tx_cmd_timer; // @[Sdc.scala 195:39 204:24 122:29]
  wire [7:0] _GEN_156 = rx_res_in_progress | ~rx_res_next ? _rx_res_counter_T_1 : _GEN_9; // @[Sdc.scala 181:49 184:24]
  wire  _GEN_157 = rx_res_in_progress | ~rx_res_next ? _GEN_14 : rx_res_in_progress; // @[Sdc.scala 104:35 181:49]
  wire  _GEN_158 = rx_res_in_progress | ~rx_res_next ? rx_res_next ^ rx_res_crc_6 : rx_res_crc_0; // @[Sdc.scala 112:23 181:49 187:23]
  wire  _GEN_159 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_0 : rx_res_crc_1; // @[Sdc.scala 112:23 181:49 188:23]
  wire  _GEN_160 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_1 : rx_res_crc_2; // @[Sdc.scala 112:23 181:49 189:23]
  wire  _GEN_161 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_2 ^ rx_res_crc_6 : rx_res_crc_3; // @[Sdc.scala 112:23 181:49 190:23]
  wire  _GEN_162 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_3 : rx_res_crc_4; // @[Sdc.scala 112:23 181:49 191:23]
  wire  _GEN_163 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_4 : rx_res_crc_5; // @[Sdc.scala 112:23 181:49 192:23]
  wire  _GEN_164 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_5 : rx_res_crc_6; // @[Sdc.scala 112:23 181:49 193:23]
  wire [136:0] _GEN_165 = rx_res_in_progress | ~rx_res_next ? _GEN_15 : {{1'd0}, _GEN_10}; // @[Sdc.scala 181:49]
  wire  _GEN_166 = rx_res_in_progress | ~rx_res_next ? _GEN_16 : _GEN_11; // @[Sdc.scala 181:49]
  wire  _GEN_167 = rx_res_in_progress | ~rx_res_next ? _GEN_17 : rx_res_crc_error; // @[Sdc.scala 113:33 181:49]
  wire [18:0] _GEN_168 = rx_res_in_progress | ~rx_res_next ? _GEN_18 : rx_busy_timer; // @[Sdc.scala 141:30 181:49]
  wire [5:0] _GEN_169 = rx_res_in_progress | ~rx_res_next ? _GEN_19 : tx_cmd_timer; // @[Sdc.scala 122:29 181:49]
  wire [7:0] _GEN_170 = _T & reg_clk ? _GEN_8 : rx_res_timer; // @[Sdc.scala 115:29 171:47]
  wire [7:0] _GEN_171 = _T & reg_clk ? _GEN_156 : rx_res_counter; // @[Sdc.scala 105:31 171:47]
  wire [136:0] _GEN_172 = _T & reg_clk ? _GEN_165 : {{1'd0}, rx_res}; // @[Sdc.scala 109:23 171:47]
  wire  _GEN_173 = _T & reg_clk ? _GEN_166 : rx_res_ready; // @[Sdc.scala 110:29 171:47]
  wire  _GEN_174 = _T & reg_clk ? _GEN_12 : rx_res_timeout; // @[Sdc.scala 116:31 171:47]
  wire  _GEN_311 = _T & reg_clk ? _GEN_157 : rx_res_in_progress; // @[Sdc.scala 104:35 171:47]
  wire  _GEN_312 = _T & reg_clk ? _GEN_158 : rx_res_crc_0; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_313 = _T & reg_clk ? _GEN_159 : rx_res_crc_1; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_314 = _T & reg_clk ? _GEN_160 : rx_res_crc_2; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_315 = _T & reg_clk ? _GEN_161 : rx_res_crc_3; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_316 = _T & reg_clk ? _GEN_162 : rx_res_crc_4; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_317 = _T & reg_clk ? _GEN_163 : rx_res_crc_5; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_318 = _T & reg_clk ? _GEN_164 : rx_res_crc_6; // @[Sdc.scala 112:23 171:47]
  wire  _GEN_319 = _T & reg_clk ? _GEN_167 : rx_res_crc_error; // @[Sdc.scala 113:33 171:47]
  wire [18:0] _GEN_320 = _T & reg_clk ? _GEN_168 : rx_busy_timer; // @[Sdc.scala 141:30 171:47]
  wire [7:0] _GEN_323 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_170 : rx_res_timer; // @[Sdc.scala 115:29 169:57]
  wire [7:0] _GEN_324 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_171 : rx_res_counter; // @[Sdc.scala 105:31 169:57]
  wire [136:0] _GEN_325 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_172 : {{1'd0}, rx_res}; // @[Sdc.scala 109:23 169:57]
  wire  _GEN_326 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_173 : rx_res_ready; // @[Sdc.scala 110:29 169:57]
  wire  _GEN_327 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_174 : rx_res_timeout; // @[Sdc.scala 116:31 169:57]
  wire  _GEN_464 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_311 : rx_res_in_progress; // @[Sdc.scala 104:35 169:57]
  wire  _GEN_465 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_312 : rx_res_crc_0; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_466 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_313 : rx_res_crc_1; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_467 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_314 : rx_res_crc_2; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_468 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_315 : rx_res_crc_3; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_469 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_316 : rx_res_crc_4; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_470 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_317 : rx_res_crc_5; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_471 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_318 : rx_res_crc_6; // @[Sdc.scala 112:23 169:57]
  wire  _GEN_472 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_319 : rx_res_crc_error; // @[Sdc.scala 113:33 169:57]
  wire [18:0] _GEN_473 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_320 : rx_busy_timer; // @[Sdc.scala 141:30 169:57]
  wire [5:0] _tx_cmd_timer_T_1 = tx_cmd_timer - 6'h1; // @[Sdc.scala 214:34]
  wire  _T_20 = rx_busy_timer != 19'h0 & _T & reg_clk; // @[Sdc.scala 217:64]
  wire [5:0] _tx_cmd_counter_T_1 = tx_cmd_counter - 6'h1; // @[Sdc.scala 224:38]
  wire  crc__0 = tx_cmd_7 ^ tx_cmd_crc_6; // @[Sdc.scala 227:17]
  wire  crc__3 = tx_cmd_crc_2 ^ tx_cmd_crc_6; // @[Sdc.scala 230:21]
  wire  _GEN_475 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_5 : tx_cmd_1; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_476 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_4 : tx_cmd_2; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_477 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_3 : tx_cmd_3; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_478 = tx_cmd_counter == 6'h9 ? crc__3 : tx_cmd_4; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_479 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_1 : tx_cmd_5; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_480 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_0 : tx_cmd_6; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_481 = tx_cmd_counter == 6'h9 ? crc__0 : tx_cmd_7; // @[Sdc.scala 238:35 239:39 223:48]
  wire  _GEN_482 = _T_2 & _T & reg_clk ? 1'h0 : reg_tx_cmd_wrt; // @[Sdc.scala 242:77 243:20 123:31]
  wire  _GEN_484 = tx_cmd_counter > 6'h0 & _T & reg_clk | _GEN_482; // @[Sdc.scala 220:75 221:20]
  wire  _GEN_486 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_475 : tx_cmd_0; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_487 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_476 : tx_cmd_1; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_488 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_477 : tx_cmd_2; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_489 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_478 : tx_cmd_3; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_490 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_479 : tx_cmd_4; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_491 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_480 : tx_cmd_5; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_492 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_481 : tx_cmd_6; // @[Sdc.scala 119:19 220:75]
  wire  _GEN_493 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_8 : tx_cmd_7; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_494 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_9 : tx_cmd_8; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_495 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_10 : tx_cmd_9; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_496 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_11 : tx_cmd_10; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_497 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_12 : tx_cmd_11; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_498 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_13 : tx_cmd_12; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_499 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_14 : tx_cmd_13; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_500 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_15 : tx_cmd_14; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_501 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_16 : tx_cmd_15; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_502 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_17 : tx_cmd_16; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_503 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_18 : tx_cmd_17; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_504 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_19 : tx_cmd_18; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_505 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_20 : tx_cmd_19; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_506 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_21 : tx_cmd_20; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_507 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_22 : tx_cmd_21; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_508 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_23 : tx_cmd_22; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_509 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_24 : tx_cmd_23; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_510 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_25 : tx_cmd_24; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_511 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_26 : tx_cmd_25; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_512 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_27 : tx_cmd_26; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_513 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_28 : tx_cmd_27; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_514 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_29 : tx_cmd_28; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_515 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_30 : tx_cmd_29; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_516 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_31 : tx_cmd_30; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_517 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_32 : tx_cmd_31; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_518 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_33 : tx_cmd_32; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_519 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_34 : tx_cmd_33; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_520 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_35 : tx_cmd_34; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_521 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_36 : tx_cmd_35; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_522 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_37 : tx_cmd_36; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_523 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_38 : tx_cmd_37; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_524 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_39 : tx_cmd_38; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_525 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_40 : tx_cmd_39; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_526 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_41 : tx_cmd_40; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_527 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_42 : tx_cmd_41; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_528 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_43 : tx_cmd_42; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_529 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_44 : tx_cmd_43; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_530 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_45 : tx_cmd_44; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_531 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_46 : tx_cmd_45; // @[Sdc.scala 119:19 220:75 223:48]
  wire  _GEN_532 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_47 : tx_cmd_46; // @[Sdc.scala 119:19 220:75 223:48]
  wire [5:0] _GEN_533 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _tx_cmd_counter_T_1 : tx_cmd_counter; // @[Sdc.scala 220:75 224:20 120:31]
  wire  _GEN_534 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__0 : tx_cmd_crc_0; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_535 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : tx_cmd_crc_1; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_536 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : tx_cmd_crc_2; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_537 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__3 : tx_cmd_crc_3; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_538 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : tx_cmd_crc_4; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_539 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : tx_cmd_crc_5; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_540 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : tx_cmd_crc_6; // @[Sdc.scala 220:75 235:16 121:23]
  wire  _GEN_543 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_486; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_544 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_487; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_545 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_488; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_546 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_489; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_547 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_490; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_548 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_491; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_549 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_492; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_550 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_493; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_551 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_494; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_552 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_495; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_553 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_496; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_554 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_497; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_555 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_498; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_556 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_499; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_557 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_500; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_558 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_501; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_559 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_502; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_560 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_503; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_561 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_504; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_562 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_505; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_563 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_506; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_564 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_507; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_565 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_508; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_566 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_509; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_567 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_510; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_568 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_511; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_569 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_512; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_570 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_513; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_571 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_514; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_572 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_515; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_573 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_516; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_574 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_517; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_575 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_518; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_576 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_519; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_577 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_520; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_578 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_521; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_579 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_522; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_580 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_523; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_581 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_524; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_582 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_525; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_583 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_526; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_584 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_527; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_585 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_528; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_586 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_529; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_587 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_530; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_588 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_531; // @[Sdc.scala 119:19 217:76]
  wire  _GEN_589 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_532; // @[Sdc.scala 119:19 217:76]
  wire [5:0] _GEN_590 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_533; // @[Sdc.scala 120:31 217:76]
  wire  _GEN_591 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_534; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_592 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_535; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_593 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_536; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_594 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_537; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_595 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_538; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_596 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_539; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_597 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_540; // @[Sdc.scala 121:23 217:76]
  wire  _GEN_601 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_543; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_602 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_544; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_603 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_545; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_604 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_546; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_605 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_547; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_606 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_548; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_607 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_549; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_608 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_550; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_609 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_551; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_610 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_552; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_611 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_553; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_612 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_554; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_613 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_555; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_614 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_556; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_615 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_557; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_616 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_558; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_617 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_559; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_618 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_560; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_619 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_561; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_620 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_562; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_621 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_563; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_622 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_564; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_623 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_565; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_624 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_566; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_625 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_567; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_626 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_568; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_627 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_569; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_628 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_570; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_629 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_571; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_630 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_572; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_631 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_573; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_632 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_574; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_633 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_575; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_634 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_576; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_635 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_577; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_636 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_578; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_637 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_579; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_638 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_580; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_639 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_581; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_640 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_582; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_641 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_583; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_642 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_584; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_643 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_585; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_644 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_586; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_645 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_587; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_646 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_588; // @[Sdc.scala 119:19 213:69]
  wire  _GEN_647 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_589; // @[Sdc.scala 119:19 213:69]
  wire [5:0] _GEN_648 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_590; // @[Sdc.scala 120:31 213:69]
  wire  _GEN_649 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_591; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_650 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_592; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_651 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_593; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_652 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_594; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_653 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_595; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_654 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_596; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_655 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_597; // @[Sdc.scala 121:23 213:69]
  wire  _GEN_657 = rx_dat_buf_read ? 1'h0 : rx_dat_buf_read; // @[Sdc.scala 259:26 261:21 144:32]
  wire [31:0] _GEN_658 = tx_dat_prepared_read ? io_sdbuf_rdata1 : tx_dat_prepared; // @[Sdc.scala 263:31 264:21 154:32]
  wire  _GEN_659 = tx_dat_prepared_read ? 1'h0 : tx_dat_prepared_read; // @[Sdc.scala 263:31 265:26 167:37]
  wire  _T_35 = ~rx_dat_in_progress; // @[Sdc.scala 271:13]
  wire [18:0] _rx_dat_timer_T_1 = rx_dat_timer - 19'h1; // @[Sdc.scala 272:38]
  wire  _T_39 = rx_dat_timer == 19'h1; // @[Sdc.scala 273:28]
  wire [7:0] _rxtx_dat_counter_T_1 = rxtx_dat_counter + 8'h1; // @[Sdc.scala 279:48]
  wire [10:0] _GEN_660 = rx_dat_timer == 19'h1 ? 11'h0 : rx_dat_counter; // @[Sdc.scala 273:37 274:26 126:31]
  wire  _GEN_661 = rx_dat_timer == 19'h1 | rx_dat_ready; // @[Sdc.scala 273:37 275:24 131:29]
  wire  _GEN_662 = rx_dat_timer == 19'h1 | rx_dat_timeout; // @[Sdc.scala 273:37 276:26 136:31]
  wire  _GEN_664 = rx_dat_timer == 19'h1 | _GEN_657; // @[Sdc.scala 273:37 278:27]
  wire [7:0] _GEN_665 = rx_dat_timer == 19'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[Sdc.scala 273:37 279:28 139:33]
  wire [10:0] _rx_dat_counter_T_1 = rx_dat_counter - 11'h1; // @[Sdc.scala 286:42]
  wire [3:0] _rx_dat_crc_0_T = rx_dat_next ^ rx_dat_crc_15; // @[Sdc.scala 288:38]
  wire [3:0] _rx_dat_crc_5_T = rx_dat_crc_4 ^ rx_dat_crc_15; // @[Sdc.scala 293:40]
  wire [3:0] _rx_dat_crc_12_T = rx_dat_crc_11 ^ rx_dat_crc_15; // @[Sdc.scala 300:42]
  wire  _T_50 = ~rx_dat_start_bit; // @[Sdc.scala 306:17]
  wire [7:0] _rxtx_dat_index_T_1 = rxtx_dat_index + 8'h1; // @[Sdc.scala 307:46]
  wire [15:0] io_sdbuf_wdata1_lo = {rx_dat_bits_5,rx_dat_bits_4,rx_dat_bits_7,rx_dat_bits_6}; // @[Cat.scala 33:92]
  wire [15:0] io_sdbuf_wdata1_hi = {rx_dat_bits_1,rx_dat_bits_0,rx_dat_bits_3,rx_dat_bits_2}; // @[Cat.scala 33:92]
  wire [7:0] _GEN_666 = ~rx_dat_start_bit ? _rxtx_dat_index_T_1 : rxtx_dat_index; // @[Sdc.scala 306:36 307:28 140:31]
  wire  _GEN_669 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? 1'h0 : rx_dat_start_bit; // @[Sdc.scala 304:78 305:28 127:33]
  wire [7:0] _GEN_670 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? _GEN_666 : rxtx_dat_index; // @[Sdc.scala 140:31 304:78]
  wire  _GEN_671 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 & _T_50; // @[Sdc.scala 251:17 304:78]
  wire  _T_51 = rx_dat_counter == 11'h1; // @[Sdc.scala 323:30]
  wire [31:0] crc_error_lo = {rx_dat_crc_8,rx_dat_crc_9,rx_dat_crc_10,rx_dat_crc_11,rx_dat_crc_12,rx_dat_crc_13,
    rx_dat_crc_14,rx_dat_crc_15}; // @[Cat.scala 33:92]
  wire [63:0] _crc_error_T = {rx_dat_crc_0,rx_dat_crc_1,rx_dat_crc_2,rx_dat_crc_3,rx_dat_crc_4,rx_dat_crc_5,rx_dat_crc_6
    ,rx_dat_crc_7,crc_error_lo}; // @[Cat.scala 33:92]
  wire  crc_error = _crc_error_T != 64'h0; // @[Sdc.scala 329:43]
  wire [10:0] _GEN_673 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 11'h411 : _rx_dat_counter_T_1; // @[Sdc.scala 286:24 333:62 334:28]
  wire [18:0] _GEN_674 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 19'h7a120 : rx_dat_timer; // @[Sdc.scala 333:62 335:26 135:29]
  wire  _GEN_675 = rx_dat_continuous & ~crc_error & ~rx_dat_ready | _GEN_669; // @[Sdc.scala 333:62 336:30]
  wire [3:0] _GEN_676 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_0_T; // @[Sdc.scala 288:23 333:62 337:24]
  wire [3:0] _GEN_677 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_0; // @[Sdc.scala 289:23 333:62 337:24]
  wire [3:0] _GEN_678 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_1; // @[Sdc.scala 290:23 333:62 337:24]
  wire [3:0] _GEN_679 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_2; // @[Sdc.scala 291:23 333:62 337:24]
  wire [3:0] _GEN_680 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_3; // @[Sdc.scala 292:23 333:62 337:24]
  wire [3:0] _GEN_681 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_5_T; // @[Sdc.scala 293:23 333:62 337:24]
  wire [3:0] _GEN_682 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_5; // @[Sdc.scala 294:23 333:62 337:24]
  wire [3:0] _GEN_683 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_6; // @[Sdc.scala 295:23 333:62 337:24]
  wire [3:0] _GEN_684 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_7; // @[Sdc.scala 296:23 333:62 337:24]
  wire [3:0] _GEN_685 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_8; // @[Sdc.scala 297:23 333:62 337:24]
  wire [3:0] _GEN_686 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_9; // @[Sdc.scala 298:24 333:62 337:24]
  wire [3:0] _GEN_687 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_10; // @[Sdc.scala 299:24 333:62 337:24]
  wire [3:0] _GEN_688 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_12_T; // @[Sdc.scala 300:24 333:62 337:24]
  wire [3:0] _GEN_689 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_12; // @[Sdc.scala 301:24 333:62 337:24]
  wire [3:0] _GEN_690 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_13; // @[Sdc.scala 302:24 333:62 337:24]
  wire [3:0] _GEN_691 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_14; // @[Sdc.scala 303:24 333:62 337:24]
  wire  _GEN_692 = rx_dat_counter == 11'h1 ? 1'h0 : rx_dat_in_progress; // @[Sdc.scala 323:39 324:30 125:35]
  wire  _GEN_693 = rx_dat_counter == 11'h1 | rx_dat_ready; // @[Sdc.scala 323:39 325:24 131:29]
  wire  _GEN_695 = rx_dat_counter == 11'h1 | _GEN_657; // @[Sdc.scala 323:39 327:27]
  wire [7:0] _GEN_696 = rx_dat_counter == 11'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[Sdc.scala 323:39 328:28 139:33]
  wire  _GEN_697 = rx_dat_counter == 11'h1 ? crc_error : rx_dat_crc_error; // @[Sdc.scala 323:39 330:28 134:33]
  wire  _GEN_698 = rx_dat_counter == 11'h1 ? rx_dat_ready : rx_dat_overrun; // @[Sdc.scala 323:39 332:26 137:31]
  wire [10:0] _GEN_699 = rx_dat_counter == 11'h1 ? _GEN_673 : _rx_dat_counter_T_1; // @[Sdc.scala 286:24 323:39]
  wire [18:0] _GEN_700 = rx_dat_counter == 11'h1 ? _GEN_674 : rx_dat_timer; // @[Sdc.scala 135:29 323:39]
  wire  _GEN_701 = rx_dat_counter == 11'h1 ? _GEN_675 : _GEN_669; // @[Sdc.scala 323:39]
  wire [3:0] _GEN_702 = rx_dat_counter == 11'h1 ? _GEN_676 : _rx_dat_crc_0_T; // @[Sdc.scala 288:23 323:39]
  wire [3:0] _GEN_703 = rx_dat_counter == 11'h1 ? _GEN_677 : rx_dat_crc_0; // @[Sdc.scala 289:23 323:39]
  wire [3:0] _GEN_704 = rx_dat_counter == 11'h1 ? _GEN_678 : rx_dat_crc_1; // @[Sdc.scala 290:23 323:39]
  wire [3:0] _GEN_705 = rx_dat_counter == 11'h1 ? _GEN_679 : rx_dat_crc_2; // @[Sdc.scala 291:23 323:39]
  wire [3:0] _GEN_706 = rx_dat_counter == 11'h1 ? _GEN_680 : rx_dat_crc_3; // @[Sdc.scala 292:23 323:39]
  wire [3:0] _GEN_707 = rx_dat_counter == 11'h1 ? _GEN_681 : _rx_dat_crc_5_T; // @[Sdc.scala 293:23 323:39]
  wire [3:0] _GEN_708 = rx_dat_counter == 11'h1 ? _GEN_682 : rx_dat_crc_5; // @[Sdc.scala 294:23 323:39]
  wire [3:0] _GEN_709 = rx_dat_counter == 11'h1 ? _GEN_683 : rx_dat_crc_6; // @[Sdc.scala 295:23 323:39]
  wire [3:0] _GEN_710 = rx_dat_counter == 11'h1 ? _GEN_684 : rx_dat_crc_7; // @[Sdc.scala 296:23 323:39]
  wire [3:0] _GEN_711 = rx_dat_counter == 11'h1 ? _GEN_685 : rx_dat_crc_8; // @[Sdc.scala 297:23 323:39]
  wire [3:0] _GEN_712 = rx_dat_counter == 11'h1 ? _GEN_686 : rx_dat_crc_9; // @[Sdc.scala 298:24 323:39]
  wire [3:0] _GEN_713 = rx_dat_counter == 11'h1 ? _GEN_687 : rx_dat_crc_10; // @[Sdc.scala 299:24 323:39]
  wire [3:0] _GEN_714 = rx_dat_counter == 11'h1 ? _GEN_688 : _rx_dat_crc_12_T; // @[Sdc.scala 300:24 323:39]
  wire [3:0] _GEN_715 = rx_dat_counter == 11'h1 ? _GEN_689 : rx_dat_crc_12; // @[Sdc.scala 301:24 323:39]
  wire [3:0] _GEN_716 = rx_dat_counter == 11'h1 ? _GEN_690 : rx_dat_crc_13; // @[Sdc.scala 302:24 323:39]
  wire [3:0] _GEN_717 = rx_dat_counter == 11'h1 ? _GEN_691 : rx_dat_crc_14; // @[Sdc.scala 303:24 323:39]
  wire  _GEN_718 = _T_35 & ~rx_dat_next[0] | _GEN_692; // @[Sdc.scala 281:66 282:28]
  wire [10:0] _GEN_727 = _T_35 & ~rx_dat_next[0] ? rx_dat_counter : _GEN_699; // @[Sdc.scala 126:31 281:66]
  wire [3:0] _GEN_728 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_0 : _GEN_702; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_729 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_1 : _GEN_703; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_730 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_2 : _GEN_704; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_731 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_3 : _GEN_705; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_732 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_4 : _GEN_706; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_733 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_5 : _GEN_707; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_734 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_6 : _GEN_708; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_735 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_7 : _GEN_709; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_736 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_8 : _GEN_710; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_737 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_9 : _GEN_711; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_738 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_10 : _GEN_712; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_739 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_11 : _GEN_713; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_740 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_12 : _GEN_714; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_741 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_13 : _GEN_715; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_742 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_14 : _GEN_716; // @[Sdc.scala 133:23 281:66]
  wire [3:0] _GEN_743 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_15 : _GEN_717; // @[Sdc.scala 133:23 281:66]
  wire  _GEN_744 = _T_35 & ~rx_dat_next[0] ? rx_dat_start_bit : _GEN_701; // @[Sdc.scala 127:33 281:66]
  wire [7:0] _GEN_745 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_index : _GEN_670; // @[Sdc.scala 140:31 281:66]
  wire  _GEN_746 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _GEN_671; // @[Sdc.scala 251:17 281:66]
  wire  _GEN_748 = _T_35 & ~rx_dat_next[0] ? rx_dat_ready : _GEN_693; // @[Sdc.scala 131:29 281:66]
  wire  _GEN_749 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _T_51; // @[Sdc.scala 254:17 281:66]
  wire  _GEN_750 = _T_35 & ~rx_dat_next[0] ? _GEN_657 : _GEN_695; // @[Sdc.scala 281:66]
  wire [7:0] _GEN_751 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_counter : _GEN_696; // @[Sdc.scala 139:33 281:66]
  wire  _GEN_752 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_error : _GEN_697; // @[Sdc.scala 134:33 281:66]
  wire  _GEN_753 = _T_35 & ~rx_dat_next[0] ? rx_dat_overrun : _GEN_698; // @[Sdc.scala 137:31 281:66]
  wire [18:0] _GEN_754 = _T_35 & ~rx_dat_next[0] ? rx_dat_timer : _GEN_700; // @[Sdc.scala 135:29 281:66]
  wire [18:0] _GEN_755 = ~rx_dat_in_progress & rx_dat_next[0] ? _rx_dat_timer_T_1 : _GEN_754; // @[Sdc.scala 271:59 272:22]
  wire [10:0] _GEN_756 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_660 : _GEN_727; // @[Sdc.scala 271:59]
  wire  _GEN_757 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_661 : _GEN_748; // @[Sdc.scala 271:59]
  wire  _GEN_758 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_662 : rx_dat_timeout; // @[Sdc.scala 136:31 271:59]
  wire  _GEN_759 = ~rx_dat_in_progress & rx_dat_next[0] ? _T_39 : _GEN_749; // @[Sdc.scala 271:59]
  wire  _GEN_760 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_664 : _GEN_750; // @[Sdc.scala 271:59]
  wire [7:0] _GEN_761 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_665 : _GEN_751; // @[Sdc.scala 271:59]
  wire  _GEN_762 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_in_progress : _GEN_718; // @[Sdc.scala 125:35 271:59]
  wire [3:0] _GEN_771 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_0 : _GEN_728; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_772 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_1 : _GEN_729; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_773 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_2 : _GEN_730; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_774 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_3 : _GEN_731; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_775 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_4 : _GEN_732; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_776 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_5 : _GEN_733; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_777 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_6 : _GEN_734; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_778 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_7 : _GEN_735; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_779 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_8 : _GEN_736; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_780 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_9 : _GEN_737; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_781 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_10 : _GEN_738; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_782 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_11 : _GEN_739; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_783 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_12 : _GEN_740; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_784 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_13 : _GEN_741; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_785 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_14 : _GEN_742; // @[Sdc.scala 133:23 271:59]
  wire [3:0] _GEN_786 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_15 : _GEN_743; // @[Sdc.scala 133:23 271:59]
  wire  _GEN_787 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_start_bit : _GEN_744; // @[Sdc.scala 127:33 271:59]
  wire [7:0] _GEN_788 = ~rx_dat_in_progress & rx_dat_next[0] ? rxtx_dat_index : _GEN_745; // @[Sdc.scala 140:31 271:59]
  wire  _GEN_789 = ~rx_dat_in_progress & rx_dat_next[0] ? 1'h0 : _GEN_746; // @[Sdc.scala 251:17 271:59]
  wire  _GEN_791 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_error : _GEN_752; // @[Sdc.scala 134:33 271:59]
  wire  _GEN_792 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_overrun : _GEN_753; // @[Sdc.scala 137:31 271:59]
  wire [18:0] _GEN_793 = _T_5 ? _GEN_755 : rx_dat_timer; // @[Sdc.scala 135:29 270:47]
  wire [10:0] _GEN_794 = _T_5 ? _GEN_756 : rx_dat_counter; // @[Sdc.scala 126:31 270:47]
  wire  _GEN_795 = _T_5 ? _GEN_757 : rx_dat_ready; // @[Sdc.scala 131:29 270:47]
  wire  _GEN_796 = _T_5 ? _GEN_758 : rx_dat_timeout; // @[Sdc.scala 136:31 270:47]
  wire  _GEN_797 = _T_5 & _GEN_759; // @[Sdc.scala 254:17 270:47]
  wire  _GEN_798 = _T_5 ? _GEN_760 : _GEN_657; // @[Sdc.scala 270:47]
  wire [7:0] _GEN_799 = _T_5 ? _GEN_761 : rxtx_dat_counter; // @[Sdc.scala 139:33 270:47]
  wire  _GEN_800 = _T_5 ? _GEN_762 : rx_dat_in_progress; // @[Sdc.scala 125:35 270:47]
  wire [3:0] _GEN_809 = _T_5 ? _GEN_771 : rx_dat_crc_0; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_810 = _T_5 ? _GEN_772 : rx_dat_crc_1; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_811 = _T_5 ? _GEN_773 : rx_dat_crc_2; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_812 = _T_5 ? _GEN_774 : rx_dat_crc_3; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_813 = _T_5 ? _GEN_775 : rx_dat_crc_4; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_814 = _T_5 ? _GEN_776 : rx_dat_crc_5; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_815 = _T_5 ? _GEN_777 : rx_dat_crc_6; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_816 = _T_5 ? _GEN_778 : rx_dat_crc_7; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_817 = _T_5 ? _GEN_779 : rx_dat_crc_8; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_818 = _T_5 ? _GEN_780 : rx_dat_crc_9; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_819 = _T_5 ? _GEN_781 : rx_dat_crc_10; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_820 = _T_5 ? _GEN_782 : rx_dat_crc_11; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_821 = _T_5 ? _GEN_783 : rx_dat_crc_12; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_822 = _T_5 ? _GEN_784 : rx_dat_crc_13; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_823 = _T_5 ? _GEN_785 : rx_dat_crc_14; // @[Sdc.scala 133:23 270:47]
  wire [3:0] _GEN_824 = _T_5 ? _GEN_786 : rx_dat_crc_15; // @[Sdc.scala 133:23 270:47]
  wire  _GEN_825 = _T_5 ? _GEN_787 : rx_dat_start_bit; // @[Sdc.scala 127:33 270:47]
  wire [7:0] _GEN_826 = _T_5 ? _GEN_788 : rxtx_dat_index; // @[Sdc.scala 140:31 270:47]
  wire  _GEN_827 = _T_5 & _GEN_789; // @[Sdc.scala 251:17 270:47]
  wire  _GEN_829 = _T_5 ? _GEN_791 : rx_dat_crc_error; // @[Sdc.scala 134:33 270:47]
  wire  _GEN_830 = _T_5 ? _GEN_792 : rx_dat_overrun; // @[Sdc.scala 137:31 270:47]
  wire [18:0] _GEN_832 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_793 : rx_dat_timer; // @[Sdc.scala 135:29 268:57]
  wire [10:0] _GEN_833 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_794 : rx_dat_counter; // @[Sdc.scala 126:31 268:57]
  wire  _GEN_834 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_795 : rx_dat_ready; // @[Sdc.scala 131:29 268:57]
  wire  _GEN_835 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_796 : rx_dat_timeout; // @[Sdc.scala 136:31 268:57]
  wire  _GEN_836 = rx_dat_counter > 11'h0 & _T_2 & _GEN_797; // @[Sdc.scala 254:17 268:57]
  wire  _GEN_837 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_798 : _GEN_657; // @[Sdc.scala 268:57]
  wire [7:0] _GEN_838 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_799 : rxtx_dat_counter; // @[Sdc.scala 139:33 268:57]
  wire  _GEN_839 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_800 : rx_dat_in_progress; // @[Sdc.scala 125:35 268:57]
  wire [3:0] _GEN_848 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_809 : rx_dat_crc_0; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_849 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_810 : rx_dat_crc_1; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_850 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_811 : rx_dat_crc_2; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_851 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_812 : rx_dat_crc_3; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_852 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_813 : rx_dat_crc_4; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_853 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_814 : rx_dat_crc_5; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_854 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_815 : rx_dat_crc_6; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_855 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_816 : rx_dat_crc_7; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_856 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_817 : rx_dat_crc_8; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_857 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_818 : rx_dat_crc_9; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_858 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_819 : rx_dat_crc_10; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_859 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_820 : rx_dat_crc_11; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_860 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_821 : rx_dat_crc_12; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_861 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_822 : rx_dat_crc_13; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_862 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_823 : rx_dat_crc_14; // @[Sdc.scala 133:23 268:57]
  wire [3:0] _GEN_863 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_824 : rx_dat_crc_15; // @[Sdc.scala 133:23 268:57]
  wire  _GEN_864 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_825 : rx_dat_start_bit; // @[Sdc.scala 127:33 268:57]
  wire [7:0] _GEN_865 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_826 : rxtx_dat_index; // @[Sdc.scala 140:31 268:57]
  wire  _GEN_868 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_829 : rx_dat_crc_error; // @[Sdc.scala 134:33 268:57]
  wire  _GEN_869 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_830 : rx_dat_overrun; // @[Sdc.scala 137:31 268:57]
  wire  _T_58 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new; // @[Sdc.scala 344:77]
  wire [10:0] _GEN_870 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 11'h412
     : tx_dat_counter; // @[Sdc.scala 344:102 345:20 150:31]
  wire  _GEN_872 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new | _GEN_659; // @[Sdc.scala 344:102 347:26]
  wire [7:0] _GEN_873 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ?
    _rxtx_dat_index_T_1 : _GEN_865; // @[Sdc.scala 344:102 349:20]
  wire [1:0] _GEN_874 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 2'h2 :
    tx_dat_prepare_state; // @[Sdc.scala 344:102 350:26 155:37]
  wire [7:0] _GEN_875 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 8'hff :
    {{2'd0}, tx_dat_timer}; // @[Sdc.scala 344:102 351:18 151:29]
  wire  _GEN_876 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_read_sel_changed; // @[Sdc.scala 344:102 352:29 162:40]
  wire  _GEN_877 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_write_sel_new; // @[Sdc.scala 344:102 353:26 163:37]
  wire  _GEN_878 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new |
    tx_dat_in_progress; // @[Sdc.scala 344:102 354:24 158:35]
  wire  _T_59 = tx_dat_read_sel == tx_dat_write_sel; // @[Sdc.scala 356:53]
  wire  _GEN_879 = tx_dat_read_sel_changed & tx_dat_read_sel == tx_dat_write_sel ? 1'h0 : _GEN_878; // @[Sdc.scala 356:76 357:24]
  wire [18:0] _rx_busy_timer_T_1 = rx_busy_timer - 19'h1; // @[Sdc.scala 364:40]
  wire [18:0] _GEN_880 = ~rx_busy_in_progress & rx_dat0_next ? _rx_busy_timer_T_1 : _GEN_473; // @[Sdc.scala 363:51 364:23]
  wire [3:0] _tx_dat_crc_status_counter_T_1 = tx_dat_crc_status_counter - 4'h1; // @[Sdc.scala 371:66]
  wire [2:0] crc_status = {tx_dat_crc_status_b_2,tx_dat_crc_status_b_1,tx_dat_crc_status_b_0}; // @[Cat.scala 33:92]
  wire  _tx_dat_crc_status_T = crc_status == 3'h2; // @[Sdc.scala 375:27]
  wire  _tx_dat_crc_status_T_1 = crc_status == 3'h5; // @[Sdc.scala 376:27]
  wire  _tx_dat_crc_status_T_2 = crc_status == 3'h6; // @[Sdc.scala 377:27]
  wire [1:0] _tx_dat_crc_status_T_3 = _tx_dat_crc_status_T_2 ? 2'h2 : 2'h3; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_crc_status_T_4 = _tx_dat_crc_status_T_1 ? 2'h1 : _tx_dat_crc_status_T_3; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_crc_status_T_5 = _tx_dat_crc_status_T ? 2'h0 : _tx_dat_crc_status_T_4; // @[Mux.scala 101:16]
  wire [1:0] _tx_dat_read_sel_T_1 = tx_dat_read_sel + 2'h1; // @[Sdc.scala 382:48]
  wire [1:0] _GEN_882 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_crc_status_T_5 : tx_dat_crc_status; // @[Sdc.scala 372:52 374:31 166:34]
  wire [1:0] _GEN_884 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_read_sel_T_1 : tx_dat_read_sel; // @[Sdc.scala 372:52 382:29 160:32]
  wire  _GEN_885 = tx_dat_crc_status_counter == 4'h2 | _GEN_876; // @[Sdc.scala 372:52 383:37]
  wire  _GEN_886 = tx_dat_started & ~tx_dat_in_progress | tx_dat_end; // @[Sdc.scala 389:58 390:26 159:27]
  wire  _GEN_887 = rx_dat0_next ? 1'h0 : 1'h1; // @[Sdc.scala 367:29 386:31 387:33]
  wire [18:0] _GEN_888 = rx_dat0_next ? 19'h0 : _GEN_880; // @[Sdc.scala 386:31 388:27]
  wire  _GEN_889 = rx_dat0_next ? _GEN_886 : tx_dat_end; // @[Sdc.scala 159:27 386:31]
  wire [3:0] _GEN_893 = tx_dat_crc_status_counter > 4'h0 ? _tx_dat_crc_status_counter_T_1 : tx_dat_crc_status_counter; // @[Sdc.scala 368:48 371:37 164:42]
  wire [1:0] _GEN_894 = tx_dat_crc_status_counter > 4'h0 ? _GEN_882 : tx_dat_crc_status; // @[Sdc.scala 166:34 368:48]
  wire [1:0] _GEN_896 = tx_dat_crc_status_counter > 4'h0 ? _GEN_884 : tx_dat_read_sel; // @[Sdc.scala 160:32 368:48]
  wire  _GEN_897 = tx_dat_crc_status_counter > 4'h0 ? _GEN_885 : _GEN_876; // @[Sdc.scala 368:48]
  wire  _GEN_898 = tx_dat_crc_status_counter > 4'h0 | _GEN_887; // @[Sdc.scala 367:29 368:48]
  wire [18:0] _GEN_899 = tx_dat_crc_status_counter > 4'h0 ? _GEN_880 : _GEN_888; // @[Sdc.scala 368:48]
  wire  _GEN_900 = tx_dat_crc_status_counter > 4'h0 ? tx_dat_end : _GEN_889; // @[Sdc.scala 159:27 368:48]
  wire [3:0] _GEN_905 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_893 : tx_dat_crc_status_counter; // @[Sdc.scala 164:42 366:51]
  wire [1:0] _GEN_908 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_896 : tx_dat_read_sel; // @[Sdc.scala 160:32 366:51]
  wire  _GEN_909 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_897 : _GEN_876; // @[Sdc.scala 366:51]
  wire [18:0] _GEN_910 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_899 : _GEN_880; // @[Sdc.scala 366:51]
  wire  _GEN_911 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_900 : tx_dat_end; // @[Sdc.scala 159:27 366:51]
  wire [18:0] _GEN_912 = _T_5 ? _GEN_910 : _GEN_473; // @[Sdc.scala 362:47]
  wire [3:0] _GEN_917 = _T_5 ? _GEN_905 : tx_dat_crc_status_counter; // @[Sdc.scala 164:42 362:47]
  wire [1:0] _GEN_920 = _T_5 ? _GEN_908 : tx_dat_read_sel; // @[Sdc.scala 160:32 362:47]
  wire  _GEN_921 = _T_5 ? _GEN_909 : _GEN_876; // @[Sdc.scala 362:47]
  wire  _GEN_922 = _T_5 ? _GEN_911 : tx_dat_end; // @[Sdc.scala 159:27 362:47]
  wire  _GEN_923 = rx_busy_timer > 19'h0 ? io_sdc_port_dat_in[0] : rx_dat0_next; // @[Sdc.scala 360:30 361:18 143:29]
  wire [18:0] _GEN_924 = rx_busy_timer > 19'h0 ? _GEN_912 : _GEN_473; // @[Sdc.scala 360:30]
  wire [3:0] _GEN_929 = rx_busy_timer > 19'h0 ? _GEN_917 : tx_dat_crc_status_counter; // @[Sdc.scala 360:30 164:42]
  wire [1:0] _GEN_932 = rx_busy_timer > 19'h0 ? _GEN_920 : tx_dat_read_sel; // @[Sdc.scala 360:30 160:32]
  wire  _GEN_933 = rx_busy_timer > 19'h0 ? _GEN_921 : _GEN_876; // @[Sdc.scala 360:30]
  wire  _GEN_934 = rx_busy_timer > 19'h0 ? _GEN_922 : tx_dat_end; // @[Sdc.scala 159:27 360:30]
  wire  _GEN_935 = _T_58 ? 1'h0 : _GEN_934; // @[Sdc.scala 398:102 400:16]
  wire [5:0] _tx_dat_timer_T_1 = tx_dat_timer - 6'h1; // @[Sdc.scala 407:34]
  wire [10:0] _tx_dat_counter_T_1 = tx_dat_counter - 11'h1; // @[Sdc.scala 414:38]
  wire [3:0] crc_1_0 = tx_dat_16 ^ tx_dat_crc_15; // @[Sdc.scala 417:18]
  wire [3:0] crc_1_5 = tx_dat_crc_4 ^ tx_dat_crc_15; // @[Sdc.scala 422:21]
  wire [3:0] crc_1_12 = tx_dat_crc_11 ^ tx_dat_crc_15; // @[Sdc.scala 429:22]
  wire  _T_91 = tx_dat_counter[2:0] == 3'h2; // @[Sdc.scala 437:65]
  wire [31:0] _GEN_936 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 32'h0 : _GEN_658; // @[Sdc.scala 443:80 444:23]
  wire [1:0] _GEN_937 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 2'h1 : _GEN_874; // @[Sdc.scala 443:80 445:28]
  wire  _GEN_938 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _T_58; // @[Sdc.scala 437:74 438:21]
  wire  _GEN_939 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _GEN_872; // @[Sdc.scala 437:74 439:28]
  wire [7:0] _GEN_940 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _rxtx_dat_index_T_1 : _GEN_873; // @[Sdc.scala 437:74 441:22]
  wire [1:0] _GEN_941 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? 2'h1 : _GEN_937; // @[Sdc.scala 437:74 442:28]
  wire [31:0] _GEN_942 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _GEN_658 : _GEN_936; // @[Sdc.scala 437:74]
  wire [3:0] _GEN_943 = tx_dat_counter == 11'h12 ? tx_dat_crc_14 : tx_dat_1; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_944 = tx_dat_counter == 11'h12 ? tx_dat_crc_13 : tx_dat_2; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_945 = tx_dat_counter == 11'h12 ? tx_dat_crc_12 : tx_dat_3; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_946 = tx_dat_counter == 11'h12 ? crc_1_12 : tx_dat_4; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_947 = tx_dat_counter == 11'h12 ? tx_dat_crc_10 : tx_dat_5; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_948 = tx_dat_counter == 11'h12 ? tx_dat_crc_9 : tx_dat_6; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_949 = tx_dat_counter == 11'h12 ? tx_dat_crc_8 : tx_dat_7; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_950 = tx_dat_counter == 11'h12 ? tx_dat_crc_7 : tx_dat_8; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_951 = tx_dat_counter == 11'h12 ? tx_dat_crc_6 : tx_dat_9; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_952 = tx_dat_counter == 11'h12 ? tx_dat_crc_5 : tx_dat_10; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_953 = tx_dat_counter == 11'h12 ? crc_1_5 : tx_dat_11; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_954 = tx_dat_counter == 11'h12 ? tx_dat_crc_3 : tx_dat_12; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_955 = tx_dat_counter == 11'h12 ? tx_dat_crc_2 : tx_dat_13; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_956 = tx_dat_counter == 11'h12 ? tx_dat_crc_1 : tx_dat_14; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_957 = tx_dat_counter == 11'h12 ? tx_dat_crc_0 : tx_dat_15; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_958 = tx_dat_counter == 11'h12 ? crc_1_0 : tx_dat_16; // @[Sdc.scala 447:36 448:40 413:50]
  wire [3:0] _GEN_959 = tx_dat_counter == 11'h12 ? 4'hf : tx_dat_17; // @[Sdc.scala 447:36 449:18 413:50]
  wire  _GEN_960 = tx_dat_counter == 11'h1 ? 1'h0 : 1'h1; // @[Sdc.scala 411:20 452:35 453:22]
  wire [18:0] _GEN_962 = tx_dat_counter == 11'h1 ? 19'h7a120 : _GEN_924; // @[Sdc.scala 452:35 455:21]
  wire [3:0] _GEN_963 = tx_dat_counter == 11'h1 ? 4'h6 : _GEN_929; // @[Sdc.scala 452:35 456:33]
  wire [3:0] _GEN_965 = tx_dat_counter != 11'h0 & _T & reg_clk ? tx_dat_0 : {{3'd0}, reg_tx_dat_out}; // @[Sdc.scala 147:31 410:77]
  wire [3:0] _GEN_966 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_943 : tx_dat_0; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_967 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_944 : tx_dat_1; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_968 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_945 : tx_dat_2; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_969 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_946 : tx_dat_3; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_970 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_947 : tx_dat_4; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_971 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_948 : tx_dat_5; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_972 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_949 : tx_dat_6; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_973 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_950 : tx_dat_7; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_974 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_951 : tx_dat_8; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_975 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_952 : tx_dat_9; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_976 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_953 : tx_dat_10; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_977 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_954 : tx_dat_11; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_978 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_955 : tx_dat_12; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_979 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_956 : tx_dat_13; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_980 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_957 : tx_dat_14; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_981 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_958 : tx_dat_15; // @[Sdc.scala 152:19 410:77]
  wire [3:0] _GEN_982 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_959 : tx_dat_16; // @[Sdc.scala 152:19 410:77]
  wire  _GEN_1006 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_938 : _T_58; // @[Sdc.scala 410:77]
  wire  _GEN_1007 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_939 : _GEN_872; // @[Sdc.scala 410:77]
  wire [7:0] _GEN_1008 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_940 : _GEN_873; // @[Sdc.scala 410:77]
  wire [1:0] _GEN_1009 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_941 : _GEN_874; // @[Sdc.scala 410:77]
  wire [7:0] _GEN_1013 = tx_dat_timer != 6'h0 & _T & reg_clk ? {{2'd0}, _tx_dat_timer_T_1} : _GEN_875; // @[Sdc.scala 406:75 407:18]
  wire [3:0] _GEN_1016 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_0 : _GEN_966; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1017 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_1 : _GEN_967; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1018 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_2 : _GEN_968; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1019 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_3 : _GEN_969; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1020 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_4 : _GEN_970; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1021 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_5 : _GEN_971; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1022 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_6 : _GEN_972; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1023 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_7 : _GEN_973; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1024 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_8 : _GEN_974; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1025 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_9 : _GEN_975; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1026 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_10 : _GEN_976; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1027 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_11 : _GEN_977; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1028 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_12 : _GEN_978; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1029 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_13 : _GEN_979; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1030 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_14 : _GEN_980; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1031 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_15 : _GEN_981; // @[Sdc.scala 152:19 406:75]
  wire [3:0] _GEN_1032 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_16 : _GEN_982; // @[Sdc.scala 152:19 406:75]
  wire  _GEN_1056 = tx_dat_timer != 6'h0 & _T & reg_clk ? _T_58 : _GEN_1006; // @[Sdc.scala 406:75]
  wire  _GEN_1057 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_872 : _GEN_1007; // @[Sdc.scala 406:75]
  wire [7:0] _GEN_1058 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_873 : _GEN_1008; // @[Sdc.scala 406:75]
  wire [1:0] _GEN_1059 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_874 : _GEN_1009; // @[Sdc.scala 406:75]
  wire [7:0] _GEN_1065 = _T_20 ? _GEN_875 : _GEN_1013; // @[Sdc.scala 403:70]
  wire [3:0] _GEN_1066 = _T_20 ? tx_dat_0 : _GEN_1016; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1067 = _T_20 ? tx_dat_1 : _GEN_1017; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1068 = _T_20 ? tx_dat_2 : _GEN_1018; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1069 = _T_20 ? tx_dat_3 : _GEN_1019; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1070 = _T_20 ? tx_dat_4 : _GEN_1020; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1071 = _T_20 ? tx_dat_5 : _GEN_1021; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1072 = _T_20 ? tx_dat_6 : _GEN_1022; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1073 = _T_20 ? tx_dat_7 : _GEN_1023; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1074 = _T_20 ? tx_dat_8 : _GEN_1024; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1075 = _T_20 ? tx_dat_9 : _GEN_1025; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1076 = _T_20 ? tx_dat_10 : _GEN_1026; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1077 = _T_20 ? tx_dat_11 : _GEN_1027; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1078 = _T_20 ? tx_dat_12 : _GEN_1028; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1079 = _T_20 ? tx_dat_13 : _GEN_1029; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1080 = _T_20 ? tx_dat_14 : _GEN_1030; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1081 = _T_20 ? tx_dat_15 : _GEN_1031; // @[Sdc.scala 152:19 403:70]
  wire [3:0] _GEN_1082 = _T_20 ? tx_dat_16 : _GEN_1032; // @[Sdc.scala 152:19 403:70]
  wire  _GEN_1106 = _T_20 ? _T_58 : _GEN_1056; // @[Sdc.scala 403:70]
  wire  _GEN_1107 = _T_20 ? _GEN_872 : _GEN_1057; // @[Sdc.scala 403:70]
  wire [7:0] _GEN_1108 = _T_20 ? _GEN_873 : _GEN_1058; // @[Sdc.scala 403:70]
  wire [1:0] _GEN_1109 = _T_20 ? _GEN_874 : _GEN_1059; // @[Sdc.scala 403:70]
  wire  _GEN_1131 = 2'h2 == tx_dat_prepare_state | _GEN_1106; // @[Sdc.scala 460:33 482:21]
  wire  _GEN_1132 = 2'h2 == tx_dat_prepare_state | _GEN_1107; // @[Sdc.scala 460:33 483:28]
  wire [7:0] _GEN_1133 = 2'h2 == tx_dat_prepare_state ? _rxtx_dat_index_T_1 : _GEN_1108; // @[Sdc.scala 460:33 485:22]
  wire [7:0] _GEN_1163 = 2'h1 == tx_dat_prepare_state ? _GEN_1108 : _GEN_1133; // @[Sdc.scala 460:33]
  wire [1:0] addr = io_mem_waddr[3:2]; // @[Sdc.scala 506:28]
  wire [8:0] baud_divider = io_mem_wdata[8:0]; // @[Sdc.scala 509:40]
  wire [47:0] tx_cmd_val = {2'h1,io_mem_wdata[9:4],tx_cmd_arg,7'h0,1'h1}; // @[Cat.scala 33:92]
  wire  _GEN_1175 = io_mem_wdata[3:0] == 4'h3 ? 1'h0 : 1'h1; // @[Sdc.scala 531:25 540:59 542:27]
  wire [7:0] _GEN_1176 = io_mem_wdata[3:0] == 4'h2 ? 8'h88 : 8'h30; // @[Sdc.scala 537:59 538:28]
  wire  _GEN_1177 = io_mem_wdata[3:0] == 4'h2 ? 1'h0 : _GEN_1175; // @[Sdc.scala 537:59 539:27]
  wire [7:0] _GEN_1178 = io_mem_wdata[3:0] == 4'h0 ? 8'h0 : _GEN_1176; // @[Sdc.scala 535:55 536:28]
  wire  _GEN_1179 = io_mem_wdata[3:0] == 4'h0 | _GEN_1177; // @[Sdc.scala 531:25 535:55]
  wire  _GEN_1180 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_839; // @[Sdc.scala 546:69 547:32]
  wire [10:0] _GEN_1181 = io_mem_wdata[12] | io_mem_wdata[13] ? 11'h411 : 11'h0; // @[Sdc.scala 546:69 548:28 560:28]
  wire  _GEN_1182 = io_mem_wdata[12] | io_mem_wdata[13] | _GEN_864; // @[Sdc.scala 546:69 549:30]
  wire [3:0] _GEN_1184 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_848; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1185 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_849; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1186 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_850; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1187 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_851; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1188 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_852; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1189 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_853; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1190 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_854; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1191 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_855; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1192 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_856; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1193 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_857; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1194 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_858; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1195 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_859; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1196 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_860; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1197 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_861; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1198 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_862; // @[Sdc.scala 546:69 551:24]
  wire [3:0] _GEN_1199 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_863; // @[Sdc.scala 546:69 551:24]
  wire  _GEN_1200 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_868; // @[Sdc.scala 546:69 552:30]
  wire [18:0] _GEN_1201 = io_mem_wdata[12] | io_mem_wdata[13] ? 19'h7a120 : _GEN_832; // @[Sdc.scala 546:69 553:26]
  wire  _GEN_1202 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_835; // @[Sdc.scala 546:69 554:28]
  wire  _GEN_1203 = io_mem_wdata[12] | io_mem_wdata[13] ? io_mem_wdata[13] : rx_dat_continuous; // @[Sdc.scala 546:69 555:31 130:34]
  wire  _GEN_1204 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_869; // @[Sdc.scala 546:69 556:28]
  wire [7:0] _GEN_1205 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_1163; // @[Sdc.scala 546:69 557:28]
  wire [7:0] _GEN_1206 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_838; // @[Sdc.scala 546:69 558:30]
  wire  _T_179 = io_mem_wdata[14] | io_mem_wdata[15]; // @[Sdc.scala 563:41]
  wire [1:0] _GEN_1209 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : _GEN_932; // @[Sdc.scala 563:69 566:29]
  wire [1:0] _GEN_1210 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : tx_dat_write_sel; // @[Sdc.scala 563:69 567:30 161:33]
  wire  _GEN_1211 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_933; // @[Sdc.scala 563:69 568:37]
  wire  _GEN_1212 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_877; // @[Sdc.scala 563:69 569:34]
  wire  _GEN_1213 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_879; // @[Sdc.scala 563:69 570:32]
  wire  _GEN_1214 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_935; // @[Sdc.scala 563:69 571:24]
  wire [7:0] _GEN_1215 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1205; // @[Sdc.scala 563:69 572:28]
  wire [7:0] _GEN_1216 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1206; // @[Sdc.scala 563:69 573:30]
  wire [5:0] _GEN_1265 = io_mem_wdata[11] ? 6'h30 : _GEN_648; // @[Sdc.scala 521:40 524:26]
  wire [3:0] _GEN_1273 = io_mem_wdata[11] ? io_mem_wdata[3:0] : rx_res_type; // @[Sdc.scala 521:40 526:23 108:28]
  wire  _GEN_1274 = io_mem_wdata[11] ? 1'h0 : _GEN_464; // @[Sdc.scala 521:40 527:30]
  wire  _GEN_1275 = io_mem_wdata[11] ? 1'h0 : _GEN_326; // @[Sdc.scala 521:40 528:24]
  wire  _GEN_1283 = io_mem_wdata[11] ? 1'h0 : _GEN_472; // @[Sdc.scala 521:40 530:28]
  wire  _GEN_1284 = io_mem_wdata[11] ? _GEN_1179 : rx_res_crc_en; // @[Sdc.scala 114:30 521:40]
  wire [7:0] _GEN_1285 = io_mem_wdata[11] ? 8'hff : _GEN_323; // @[Sdc.scala 521:40 532:24]
  wire  _GEN_1286 = io_mem_wdata[11] ? 1'h0 : _GEN_327; // @[Sdc.scala 521:40 533:26]
  wire [1:0] _GEN_1287 = io_mem_wdata[11] ? 2'h0 : rx_res_read_counter; // @[Sdc.scala 521:40 534:31 117:36]
  wire [7:0] _GEN_1288 = io_mem_wdata[11] ? _GEN_1178 : _GEN_324; // @[Sdc.scala 521:40]
  wire  _GEN_1289 = io_mem_wdata[11] ? _GEN_1180 : _GEN_839; // @[Sdc.scala 521:40]
  wire [10:0] _GEN_1290 = io_mem_wdata[11] ? _GEN_1181 : _GEN_833; // @[Sdc.scala 521:40]
  wire  _GEN_1291 = io_mem_wdata[11] ? _GEN_1182 : _GEN_864; // @[Sdc.scala 521:40]
  wire  _GEN_1292 = io_mem_wdata[11] ? 1'h0 : _GEN_834; // @[Sdc.scala 521:40]
  wire  _GEN_1309 = io_mem_wdata[11] ? _GEN_1200 : _GEN_868; // @[Sdc.scala 521:40]
  wire [18:0] _GEN_1310 = io_mem_wdata[11] ? _GEN_1201 : _GEN_832; // @[Sdc.scala 521:40]
  wire  _GEN_1311 = io_mem_wdata[11] ? _GEN_1202 : _GEN_835; // @[Sdc.scala 521:40]
  wire  _GEN_1312 = io_mem_wdata[11] ? _GEN_1203 : rx_dat_continuous; // @[Sdc.scala 130:34 521:40]
  wire  _GEN_1313 = io_mem_wdata[11] ? _GEN_1204 : _GEN_869; // @[Sdc.scala 521:40]
  wire [7:0] _GEN_1314 = io_mem_wdata[11] ? _GEN_1215 : _GEN_1163; // @[Sdc.scala 521:40]
  wire [7:0] _GEN_1315 = io_mem_wdata[11] ? _GEN_1216 : _GEN_838; // @[Sdc.scala 521:40]
  wire  _GEN_1316 = io_mem_wdata[11] ? _T_179 : tx_dat_started; // @[Sdc.scala 156:31 521:40]
  wire [1:0] _GEN_1318 = io_mem_wdata[11] ? _GEN_1209 : _GEN_932; // @[Sdc.scala 521:40]
  wire [1:0] _GEN_1319 = io_mem_wdata[11] ? _GEN_1210 : tx_dat_write_sel; // @[Sdc.scala 161:33 521:40]
  wire  _GEN_1320 = io_mem_wdata[11] ? _GEN_1211 : _GEN_933; // @[Sdc.scala 521:40]
  wire  _GEN_1321 = io_mem_wdata[11] ? _GEN_1212 : _GEN_877; // @[Sdc.scala 521:40]
  wire  _GEN_1322 = io_mem_wdata[11] ? _GEN_1213 : _GEN_879; // @[Sdc.scala 521:40]
  wire  _GEN_1323 = io_mem_wdata[11] ? _GEN_1214 : _GEN_935; // @[Sdc.scala 521:40]
  wire [1:0] _T_182 = tx_dat_read_sel ^ tx_dat_write_sel; // @[Sdc.scala 584:32]
  wire  _T_183 = _T_182 != 2'h2; // @[Sdc.scala 584:52]
  wire [7:0] _GEN_1324 = _T_182 != 2'h2 ? _rxtx_dat_counter_T_1 : _GEN_838; // @[Sdc.scala 584:65 585:28]
  wire  _T_185 = rxtx_dat_counter[6:0] == 7'h7f; // @[Sdc.scala 590:38]
  wire [1:0] _tx_dat_write_sel_T_1 = tx_dat_write_sel + 2'h1; // @[Sdc.scala 591:48]
  wire  _GEN_1327 = _T_59 | _GEN_877; // @[Sdc.scala 592:55 593:34]
  wire [1:0] _GEN_1328 = rxtx_dat_counter[6:0] == 7'h7f ? _tx_dat_write_sel_T_1 : tx_dat_write_sel; // @[Sdc.scala 590:49 591:28 161:33]
  wire  _GEN_1329 = rxtx_dat_counter[6:0] == 7'h7f ? _GEN_1327 : _GEN_877; // @[Sdc.scala 590:49]
  wire [7:0] _GEN_1330 = 2'h3 == addr ? _GEN_1324 : _GEN_838; // @[Sdc.scala 507:19]
  wire [1:0] _GEN_1333 = 2'h3 == addr ? _GEN_1328 : tx_dat_write_sel; // @[Sdc.scala 507:19 161:33]
  wire  _GEN_1334 = 2'h3 == addr ? _GEN_1329 : _GEN_877; // @[Sdc.scala 507:19]
  wire [31:0] _GEN_1335 = 2'h2 == addr ? io_mem_wdata : tx_cmd_arg; // @[Sdc.scala 507:19 581:20 118:27]
  wire [7:0] _GEN_1336 = 2'h2 == addr ? _GEN_838 : _GEN_1330; // @[Sdc.scala 507:19]
  wire  _GEN_1337 = 2'h2 == addr ? 1'h0 : 2'h3 == addr & _T_183; // @[Sdc.scala 255:17 507:19]
  wire [1:0] _GEN_1339 = 2'h2 == addr ? tx_dat_write_sel : _GEN_1333; // @[Sdc.scala 507:19 161:33]
  wire  _GEN_1340 = 2'h2 == addr ? _GEN_877 : _GEN_1334; // @[Sdc.scala 507:19]
  wire  _GEN_1399 = 2'h1 == addr ? _GEN_1275 : _GEN_326; // @[Sdc.scala 507:19]
  wire [1:0] _GEN_1411 = 2'h1 == addr ? _GEN_1287 : rx_res_read_counter; // @[Sdc.scala 507:19 117:36]
  wire  _GEN_1416 = 2'h1 == addr ? _GEN_1292 : _GEN_834; // @[Sdc.scala 507:19]
  wire [7:0] _GEN_1439 = 2'h1 == addr ? _GEN_1315 : _GEN_1336; // @[Sdc.scala 507:19]
  wire  _GEN_1449 = 2'h1 == addr ? 1'h0 : _GEN_1337; // @[Sdc.scala 255:17 507:19]
  wire  _GEN_1516 = 2'h0 == addr ? _GEN_326 : _GEN_1399; // @[Sdc.scala 507:19]
  wire [1:0] _GEN_1528 = 2'h0 == addr ? rx_res_read_counter : _GEN_1411; // @[Sdc.scala 507:19 117:36]
  wire  _GEN_1533 = 2'h0 == addr ? _GEN_834 : _GEN_1416; // @[Sdc.scala 507:19]
  wire [7:0] _GEN_1556 = 2'h0 == addr ? _GEN_838 : _GEN_1439; // @[Sdc.scala 507:19]
  wire  _GEN_1566 = 2'h0 == addr ? 1'h0 : _GEN_1449; // @[Sdc.scala 255:17 507:19]
  wire  _GEN_1633 = io_mem_wen ? _GEN_1516 : _GEN_326; // @[Sdc.scala 505:21]
  wire [1:0] _GEN_1645 = io_mem_wen ? _GEN_1528 : rx_res_read_counter; // @[Sdc.scala 505:21 117:36]
  wire  _GEN_1650 = io_mem_wen ? _GEN_1533 : _GEN_834; // @[Sdc.scala 505:21]
  wire [7:0] _GEN_1673 = io_mem_wen ? _GEN_1556 : _GEN_838; // @[Sdc.scala 505:21]
  wire [1:0] addr_1 = io_mem_raddr[3:2]; // @[Sdc.scala 600:28]
  wire [31:0] _io_mem_rdata_T = {reg_power,11'h0,tx_end_intr_en,tx_empty_intr_en,rx_dat_intr_en,rx_res_intr_en,7'h0,
    reg_baud_divider}; // @[Cat.scala 33:92]
  wire  _io_mem_rdata_T_1 = tx_dat_started & tx_dat_end; // @[Sdc.scala 618:26]
  wire  _io_mem_rdata_T_4 = tx_dat_started & _T_182 == 2'h2; // @[Sdc.scala 619:26]
  wire [17:0] io_mem_rdata_lo_1 = {rx_dat_crc_error,rx_dat_ready,13'h0,rx_res_timeout,rx_res_crc_error,rx_res_ready}; // @[Cat.scala 33:92]
  wire [31:0] _io_mem_rdata_T_5 = {8'h0,tx_dat_crc_status,_io_mem_rdata_T_1,_io_mem_rdata_T_4,rx_dat_overrun,
    rx_dat_timeout,io_mem_rdata_lo_1}; // @[Cat.scala 33:92]
  wire [1:0] _rx_res_read_counter_T_1 = rx_res_read_counter + 2'h1; // @[Sdc.scala 631:52]
  wire [6:0] _io_mem_rdata_T_6 = {rx_res_read_counter,5'h0}; // @[Cat.scala 33:92]
  wire [135:0] _io_mem_rdata_T_7 = rx_res >> _io_mem_rdata_T_6; // @[Sdc.scala 633:35]
  wire  _GEN_1685 = rx_res_read_counter == 2'h3 ? 1'h0 : _GEN_1633; // @[Sdc.scala 634:46 635:26]
  wire [31:0] _GEN_1686 = rx_res_type == 4'h2 ? _io_mem_rdata_T_7[31:0] : rx_res[39:8]; // @[Sdc.scala 632:44 633:24 638:24]
  wire  _GEN_1687 = rx_res_type == 4'h2 & _GEN_1685; // @[Sdc.scala 632:44 639:24]
  wire  _GEN_1688 = _T_185 ? 1'h0 : _GEN_1650; // @[Sdc.scala 649:51 650:26]
  wire [7:0] _GEN_1689 = rx_dat_ready ? _rxtx_dat_counter_T_1 : _GEN_1673; // @[Sdc.scala 644:29 645:28]
  wire  _GEN_1690 = rx_dat_ready | _GEN_836; // @[Sdc.scala 644:29 646:25]
  wire  _GEN_1691 = rx_dat_ready | _GEN_837; // @[Sdc.scala 644:29 647:27]
  wire  _GEN_1692 = rx_dat_ready ? _GEN_1688 : _GEN_1650; // @[Sdc.scala 644:29]
  wire [31:0] _GEN_1693 = 2'h3 == addr_1 ? rx_dat_buf_cache : 32'hdeadbeef; // @[Sdc.scala 501:16 601:19 643:22]
  wire [7:0] _GEN_1694 = 2'h3 == addr_1 ? _GEN_1689 : _GEN_1673; // @[Sdc.scala 601:19]
  wire  _GEN_1695 = 2'h3 == addr_1 ? _GEN_1690 : _GEN_836; // @[Sdc.scala 601:19]
  wire  _GEN_1696 = 2'h3 == addr_1 ? _GEN_1691 : _GEN_837; // @[Sdc.scala 601:19]
  wire  _GEN_1697 = 2'h3 == addr_1 ? _GEN_1692 : _GEN_1650; // @[Sdc.scala 601:19]
  wire [1:0] _GEN_1698 = 2'h2 == addr_1 ? _rx_res_read_counter_T_1 : _GEN_1645; // @[Sdc.scala 601:19 631:29]
  wire [31:0] _GEN_1699 = 2'h2 == addr_1 ? _GEN_1686 : _GEN_1693; // @[Sdc.scala 601:19]
  wire  _GEN_1700 = 2'h2 == addr_1 ? _GEN_1687 : _GEN_1633; // @[Sdc.scala 601:19]
  wire [7:0] _GEN_1701 = 2'h2 == addr_1 ? _GEN_1673 : _GEN_1694; // @[Sdc.scala 601:19]
  wire  _GEN_1702 = 2'h2 == addr_1 ? _GEN_836 : _GEN_1695; // @[Sdc.scala 601:19]
  wire  _GEN_1703 = 2'h2 == addr_1 ? _GEN_837 : _GEN_1696; // @[Sdc.scala 601:19]
  wire  _GEN_1704 = 2'h2 == addr_1 ? _GEN_1650 : _GEN_1697; // @[Sdc.scala 601:19]
  wire [31:0] _GEN_1705 = 2'h1 == addr_1 ? _io_mem_rdata_T_5 : _GEN_1699; // @[Sdc.scala 601:19 615:22]
  wire  _GEN_1709 = 2'h1 == addr_1 ? _GEN_836 : _GEN_1702; // @[Sdc.scala 601:19]
  wire [31:0] _GEN_1712 = 2'h0 == addr_1 ? _io_mem_rdata_T : _GEN_1705; // @[Sdc.scala 601:19 603:22]
  wire  _GEN_1716 = 2'h0 == addr_1 ? _GEN_836 : _GEN_1709; // @[Sdc.scala 601:19]
  wire  _io_intr_T_1 = rx_dat_intr_en & rx_dat_ready; // @[Sdc.scala 658:21]
  wire  _io_intr_T_2 = rx_res_intr_en & rx_res_ready | _io_intr_T_1; // @[Sdc.scala 657:47]
  wire  _io_intr_T_6 = tx_empty_intr_en & tx_dat_started & _T_183; // @[Sdc.scala 659:41]
  wire  _T_198 = ~reset; // @[Sdc.scala 662:9]
  wire [136:0] _GEN_1726 = reset ? 137'h0 : _GEN_325; // @[Sdc.scala 109:{23,23}]
  wire [3:0] _GEN_1727 = reset ? 4'h0 : _GEN_965; // @[Sdc.scala 147:{31,31}]
  wire [7:0] _GEN_1728 = reset ? 8'h0 : _GEN_1065; // @[Sdc.scala 151:{29,29}]
  assign io_mem_rdata = io_mem_ren ? _GEN_1712 : 32'hdeadbeef; // @[Sdc.scala 501:16 599:21]
  assign io_sdc_port_clk = reg_clk; // @[Sdc.scala 102:19]
  assign io_sdc_port_cmd_wrt = reg_tx_cmd_wrt; // @[Sdc.scala 210:23]
  assign io_sdc_port_cmd_out = reg_tx_cmd_out; // @[Sdc.scala 211:23]
  assign io_sdc_port_dat_wrt = reg_tx_dat_wrt; // @[Sdc.scala 247:23]
  assign io_sdc_port_dat_out = {{3'd0}, reg_tx_dat_out}; // @[Sdc.scala 248:23]
  assign io_sdbuf_ren1 = 2'h1 == tx_dat_prepare_state ? _GEN_1106 : _GEN_1131; // @[Sdc.scala 460:33]
  assign io_sdbuf_wen1 = rx_dat_counter > 11'h0 & _T_2 & _GEN_827; // @[Sdc.scala 251:17 268:57]
  assign io_sdbuf_addr1 = rxtx_dat_index; // @[Sdc.scala 252:18]
  assign io_sdbuf_wdata1 = {io_sdbuf_wdata1_hi,io_sdbuf_wdata1_lo}; // @[Cat.scala 33:92]
  assign io_sdbuf_ren2 = io_mem_ren ? _GEN_1716 : _GEN_836; // @[Sdc.scala 599:21]
  assign io_sdbuf_wen2 = io_mem_wen & _GEN_1566; // @[Sdc.scala 255:17 505:21]
  assign io_sdbuf_addr2 = rxtx_dat_counter; // @[Sdc.scala 256:18]
  assign io_sdbuf_wdata2 = io_mem_wdata; // @[Sdc.scala 584:65 587:27]
  assign io_intr = _io_intr_T_2 | _io_intr_T_6; // @[Sdc.scala 658:38]
  always @(posedge clock) begin
    if (reset) begin // @[Sdc.scala 88:26]
      reg_power <= 1'h0; // @[Sdc.scala 88:26]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 510:37]
          reg_power <= io_mem_wdata[31]; // @[Sdc.scala 511:21]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 89:33]
      reg_baud_divider <= 9'h2; // @[Sdc.scala 89:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 510:37]
          reg_baud_divider <= baud_divider; // @[Sdc.scala 512:28]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 90:32]
      reg_clk_counter <= 9'h2; // @[Sdc.scala 90:32]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        if (baud_divider != 9'h0) begin // @[Sdc.scala 510:37]
          reg_clk_counter <= baud_divider; // @[Sdc.scala 513:27]
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
    if (reset) begin // @[Sdc.scala 104:35]
      rx_res_in_progress <= 1'h0; // @[Sdc.scala 104:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_in_progress <= _GEN_464;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_res_in_progress <= _GEN_1274;
      end else begin
        rx_res_in_progress <= _GEN_464;
      end
    end else begin
      rx_res_in_progress <= _GEN_464;
    end
    if (reset) begin // @[Sdc.scala 105:31]
      rx_res_counter <= 8'h0; // @[Sdc.scala 105:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_counter <= _GEN_324;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_res_counter <= _GEN_1288;
      end else begin
        rx_res_counter <= _GEN_324;
      end
    end else begin
      rx_res_counter <= _GEN_324;
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_0 <= rx_res_next; // @[Sdc.scala 183:24]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_1 <= rx_res_bits_0; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_2 <= rx_res_bits_1; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_3 <= rx_res_bits_2; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_4 <= rx_res_bits_3; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_5 <= rx_res_bits_4; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_6 <= rx_res_bits_5; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_7 <= rx_res_bits_6; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_8 <= rx_res_bits_7; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_9 <= rx_res_bits_8; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_10 <= rx_res_bits_9; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_11 <= rx_res_bits_10; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_12 <= rx_res_bits_11; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_13 <= rx_res_bits_12; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_14 <= rx_res_bits_13; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_15 <= rx_res_bits_14; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_16 <= rx_res_bits_15; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_17 <= rx_res_bits_16; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_18 <= rx_res_bits_17; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_19 <= rx_res_bits_18; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_20 <= rx_res_bits_19; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_21 <= rx_res_bits_20; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_22 <= rx_res_bits_21; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_23 <= rx_res_bits_22; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_24 <= rx_res_bits_23; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_25 <= rx_res_bits_24; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_26 <= rx_res_bits_25; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_27 <= rx_res_bits_26; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_28 <= rx_res_bits_27; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_29 <= rx_res_bits_28; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_30 <= rx_res_bits_29; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_31 <= rx_res_bits_30; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_32 <= rx_res_bits_31; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_33 <= rx_res_bits_32; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_34 <= rx_res_bits_33; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_35 <= rx_res_bits_34; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_36 <= rx_res_bits_35; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_37 <= rx_res_bits_36; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_38 <= rx_res_bits_37; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_39 <= rx_res_bits_38; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_40 <= rx_res_bits_39; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_41 <= rx_res_bits_40; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_42 <= rx_res_bits_41; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_43 <= rx_res_bits_42; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_44 <= rx_res_bits_43; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_45 <= rx_res_bits_44; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_46 <= rx_res_bits_45; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_47 <= rx_res_bits_46; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_48 <= rx_res_bits_47; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_49 <= rx_res_bits_48; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_50 <= rx_res_bits_49; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_51 <= rx_res_bits_50; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_52 <= rx_res_bits_51; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_53 <= rx_res_bits_52; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_54 <= rx_res_bits_53; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_55 <= rx_res_bits_54; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_56 <= rx_res_bits_55; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_57 <= rx_res_bits_56; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_58 <= rx_res_bits_57; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_59 <= rx_res_bits_58; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_60 <= rx_res_bits_59; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_61 <= rx_res_bits_60; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_62 <= rx_res_bits_61; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_63 <= rx_res_bits_62; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_64 <= rx_res_bits_63; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_65 <= rx_res_bits_64; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_66 <= rx_res_bits_65; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_67 <= rx_res_bits_66; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_68 <= rx_res_bits_67; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_69 <= rx_res_bits_68; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_70 <= rx_res_bits_69; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_71 <= rx_res_bits_70; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_72 <= rx_res_bits_71; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_73 <= rx_res_bits_72; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_74 <= rx_res_bits_73; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_75 <= rx_res_bits_74; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_76 <= rx_res_bits_75; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_77 <= rx_res_bits_76; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_78 <= rx_res_bits_77; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_79 <= rx_res_bits_78; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_80 <= rx_res_bits_79; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_81 <= rx_res_bits_80; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_82 <= rx_res_bits_81; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_83 <= rx_res_bits_82; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_84 <= rx_res_bits_83; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_85 <= rx_res_bits_84; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_86 <= rx_res_bits_85; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_87 <= rx_res_bits_86; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_88 <= rx_res_bits_87; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_89 <= rx_res_bits_88; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_90 <= rx_res_bits_89; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_91 <= rx_res_bits_90; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_92 <= rx_res_bits_91; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_93 <= rx_res_bits_92; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_94 <= rx_res_bits_93; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_95 <= rx_res_bits_94; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_96 <= rx_res_bits_95; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_97 <= rx_res_bits_96; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_98 <= rx_res_bits_97; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_99 <= rx_res_bits_98; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_100 <= rx_res_bits_99; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_101 <= rx_res_bits_100; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_102 <= rx_res_bits_101; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_103 <= rx_res_bits_102; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_104 <= rx_res_bits_103; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_105 <= rx_res_bits_104; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_106 <= rx_res_bits_105; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_107 <= rx_res_bits_106; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_108 <= rx_res_bits_107; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_109 <= rx_res_bits_108; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_110 <= rx_res_bits_109; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_111 <= rx_res_bits_110; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_112 <= rx_res_bits_111; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_113 <= rx_res_bits_112; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_114 <= rx_res_bits_113; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_115 <= rx_res_bits_114; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_116 <= rx_res_bits_115; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_117 <= rx_res_bits_116; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_118 <= rx_res_bits_117; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_119 <= rx_res_bits_118; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_120 <= rx_res_bits_119; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_121 <= rx_res_bits_120; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_122 <= rx_res_bits_121; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_123 <= rx_res_bits_122; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_124 <= rx_res_bits_123; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_125 <= rx_res_bits_124; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_126 <= rx_res_bits_125; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_127 <= rx_res_bits_126; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_128 <= rx_res_bits_127; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_129 <= rx_res_bits_128; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_130 <= rx_res_bits_129; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_131 <= rx_res_bits_130; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_132 <= rx_res_bits_131; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_133 <= rx_res_bits_132; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_134 <= rx_res_bits_133; // @[Sdc.scala 182:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[Sdc.scala 181:49]
          rx_res_bits_135 <= rx_res_bits_134; // @[Sdc.scala 182:61]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 107:28]
      rx_res_next <= 1'h0; // @[Sdc.scala 107:28]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      rx_res_next <= io_sdc_port_res_in; // @[Sdc.scala 170:17]
    end
    if (reset) begin // @[Sdc.scala 108:28]
      rx_res_type <= 4'h0; // @[Sdc.scala 108:28]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          rx_res_type <= _GEN_1273;
        end
      end
    end
    rx_res <= _GEN_1726[135:0]; // @[Sdc.scala 109:{23,23}]
    if (reset) begin // @[Sdc.scala 110:29]
      rx_res_ready <= 1'h0; // @[Sdc.scala 110:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 599:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 601:19]
        rx_res_ready <= _GEN_1633;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 601:19]
        rx_res_ready <= _GEN_1633;
      end else begin
        rx_res_ready <= _GEN_1700;
      end
    end else begin
      rx_res_ready <= _GEN_1633;
    end
    if (reset) begin // @[Sdc.scala 111:31]
      rx_res_intr_en <= 1'h0; // @[Sdc.scala 111:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_intr_en <= io_mem_wdata[16]; // @[Sdc.scala 515:26]
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_0 <= _GEN_465;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_0 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_0 <= _GEN_465;
        end
      end else begin
        rx_res_crc_0 <= _GEN_465;
      end
    end else begin
      rx_res_crc_0 <= _GEN_465;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_1 <= _GEN_466;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_1 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_1 <= _GEN_466;
        end
      end else begin
        rx_res_crc_1 <= _GEN_466;
      end
    end else begin
      rx_res_crc_1 <= _GEN_466;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_2 <= _GEN_467;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_2 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_2 <= _GEN_467;
        end
      end else begin
        rx_res_crc_2 <= _GEN_467;
      end
    end else begin
      rx_res_crc_2 <= _GEN_467;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_3 <= _GEN_468;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_3 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_3 <= _GEN_468;
        end
      end else begin
        rx_res_crc_3 <= _GEN_468;
      end
    end else begin
      rx_res_crc_3 <= _GEN_468;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_4 <= _GEN_469;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_4 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_4 <= _GEN_469;
        end
      end else begin
        rx_res_crc_4 <= _GEN_469;
      end
    end else begin
      rx_res_crc_4 <= _GEN_469;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_5 <= _GEN_470;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_5 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_5 <= _GEN_470;
        end
      end else begin
        rx_res_crc_5 <= _GEN_470;
      end
    end else begin
      rx_res_crc_5 <= _GEN_470;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_6 <= _GEN_471;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          rx_res_crc_6 <= 1'h0; // @[Sdc.scala 529:22]
        end else begin
          rx_res_crc_6 <= _GEN_471;
        end
      end else begin
        rx_res_crc_6 <= _GEN_471;
      end
    end else begin
      rx_res_crc_6 <= _GEN_471;
    end
    if (reset) begin // @[Sdc.scala 113:33]
      rx_res_crc_error <= 1'h0; // @[Sdc.scala 113:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_error <= _GEN_472;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_res_crc_error <= _GEN_1283;
      end else begin
        rx_res_crc_error <= _GEN_472;
      end
    end else begin
      rx_res_crc_error <= _GEN_472;
    end
    if (reset) begin // @[Sdc.scala 114:30]
      rx_res_crc_en <= 1'h0; // @[Sdc.scala 114:30]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          rx_res_crc_en <= _GEN_1284;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 115:29]
      rx_res_timer <= 8'h0; // @[Sdc.scala 115:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_timer <= _GEN_323;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_res_timer <= _GEN_1285;
      end else begin
        rx_res_timer <= _GEN_323;
      end
    end else begin
      rx_res_timer <= _GEN_323;
    end
    if (reset) begin // @[Sdc.scala 116:31]
      rx_res_timeout <= 1'h0; // @[Sdc.scala 116:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_res_timeout <= _GEN_327;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_res_timeout <= _GEN_1286;
      end else begin
        rx_res_timeout <= _GEN_327;
      end
    end else begin
      rx_res_timeout <= _GEN_327;
    end
    if (reset) begin // @[Sdc.scala 117:36]
      rx_res_read_counter <= 2'h0; // @[Sdc.scala 117:36]
    end else if (io_mem_ren) begin // @[Sdc.scala 599:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 601:19]
        rx_res_read_counter <= _GEN_1645;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 601:19]
        rx_res_read_counter <= _GEN_1645;
      end else begin
        rx_res_read_counter <= _GEN_1698;
      end
    end else begin
      rx_res_read_counter <= _GEN_1645;
    end
    if (reset) begin // @[Sdc.scala 118:27]
      tx_cmd_arg <= 32'h0; // @[Sdc.scala 118:27]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (!(2'h1 == addr)) begin // @[Sdc.scala 507:19]
          tx_cmd_arg <= _GEN_1335;
        end
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_0 <= _GEN_601;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_0 <= tx_cmd_val[47]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_0 <= _GEN_601;
        end
      end else begin
        tx_cmd_0 <= _GEN_601;
      end
    end else begin
      tx_cmd_0 <= _GEN_601;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_1 <= _GEN_602;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_1 <= tx_cmd_val[46]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_1 <= _GEN_602;
        end
      end else begin
        tx_cmd_1 <= _GEN_602;
      end
    end else begin
      tx_cmd_1 <= _GEN_602;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_2 <= _GEN_603;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_2 <= tx_cmd_val[45]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_2 <= _GEN_603;
        end
      end else begin
        tx_cmd_2 <= _GEN_603;
      end
    end else begin
      tx_cmd_2 <= _GEN_603;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_3 <= _GEN_604;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_3 <= tx_cmd_val[44]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_3 <= _GEN_604;
        end
      end else begin
        tx_cmd_3 <= _GEN_604;
      end
    end else begin
      tx_cmd_3 <= _GEN_604;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_4 <= _GEN_605;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_4 <= tx_cmd_val[43]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_4 <= _GEN_605;
        end
      end else begin
        tx_cmd_4 <= _GEN_605;
      end
    end else begin
      tx_cmd_4 <= _GEN_605;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_5 <= _GEN_606;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_5 <= tx_cmd_val[42]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_5 <= _GEN_606;
        end
      end else begin
        tx_cmd_5 <= _GEN_606;
      end
    end else begin
      tx_cmd_5 <= _GEN_606;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_6 <= _GEN_607;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_6 <= tx_cmd_val[41]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_6 <= _GEN_607;
        end
      end else begin
        tx_cmd_6 <= _GEN_607;
      end
    end else begin
      tx_cmd_6 <= _GEN_607;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_7 <= _GEN_608;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_7 <= tx_cmd_val[40]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_7 <= _GEN_608;
        end
      end else begin
        tx_cmd_7 <= _GEN_608;
      end
    end else begin
      tx_cmd_7 <= _GEN_608;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_8 <= _GEN_609;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_8 <= tx_cmd_val[39]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_8 <= _GEN_609;
        end
      end else begin
        tx_cmd_8 <= _GEN_609;
      end
    end else begin
      tx_cmd_8 <= _GEN_609;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_9 <= _GEN_610;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_9 <= tx_cmd_val[38]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_9 <= _GEN_610;
        end
      end else begin
        tx_cmd_9 <= _GEN_610;
      end
    end else begin
      tx_cmd_9 <= _GEN_610;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_10 <= _GEN_611;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_10 <= tx_cmd_val[37]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_10 <= _GEN_611;
        end
      end else begin
        tx_cmd_10 <= _GEN_611;
      end
    end else begin
      tx_cmd_10 <= _GEN_611;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_11 <= _GEN_612;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_11 <= tx_cmd_val[36]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_11 <= _GEN_612;
        end
      end else begin
        tx_cmd_11 <= _GEN_612;
      end
    end else begin
      tx_cmd_11 <= _GEN_612;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_12 <= _GEN_613;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_12 <= tx_cmd_val[35]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_12 <= _GEN_613;
        end
      end else begin
        tx_cmd_12 <= _GEN_613;
      end
    end else begin
      tx_cmd_12 <= _GEN_613;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_13 <= _GEN_614;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_13 <= tx_cmd_val[34]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_13 <= _GEN_614;
        end
      end else begin
        tx_cmd_13 <= _GEN_614;
      end
    end else begin
      tx_cmd_13 <= _GEN_614;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_14 <= _GEN_615;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_14 <= tx_cmd_val[33]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_14 <= _GEN_615;
        end
      end else begin
        tx_cmd_14 <= _GEN_615;
      end
    end else begin
      tx_cmd_14 <= _GEN_615;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_15 <= _GEN_616;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_15 <= tx_cmd_val[32]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_15 <= _GEN_616;
        end
      end else begin
        tx_cmd_15 <= _GEN_616;
      end
    end else begin
      tx_cmd_15 <= _GEN_616;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_16 <= _GEN_617;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_16 <= tx_cmd_val[31]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_16 <= _GEN_617;
        end
      end else begin
        tx_cmd_16 <= _GEN_617;
      end
    end else begin
      tx_cmd_16 <= _GEN_617;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_17 <= _GEN_618;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_17 <= tx_cmd_val[30]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_17 <= _GEN_618;
        end
      end else begin
        tx_cmd_17 <= _GEN_618;
      end
    end else begin
      tx_cmd_17 <= _GEN_618;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_18 <= _GEN_619;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_18 <= tx_cmd_val[29]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_18 <= _GEN_619;
        end
      end else begin
        tx_cmd_18 <= _GEN_619;
      end
    end else begin
      tx_cmd_18 <= _GEN_619;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_19 <= _GEN_620;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_19 <= tx_cmd_val[28]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_19 <= _GEN_620;
        end
      end else begin
        tx_cmd_19 <= _GEN_620;
      end
    end else begin
      tx_cmd_19 <= _GEN_620;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_20 <= _GEN_621;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_20 <= tx_cmd_val[27]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_20 <= _GEN_621;
        end
      end else begin
        tx_cmd_20 <= _GEN_621;
      end
    end else begin
      tx_cmd_20 <= _GEN_621;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_21 <= _GEN_622;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_21 <= tx_cmd_val[26]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_21 <= _GEN_622;
        end
      end else begin
        tx_cmd_21 <= _GEN_622;
      end
    end else begin
      tx_cmd_21 <= _GEN_622;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_22 <= _GEN_623;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_22 <= tx_cmd_val[25]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_22 <= _GEN_623;
        end
      end else begin
        tx_cmd_22 <= _GEN_623;
      end
    end else begin
      tx_cmd_22 <= _GEN_623;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_23 <= _GEN_624;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_23 <= tx_cmd_val[24]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_23 <= _GEN_624;
        end
      end else begin
        tx_cmd_23 <= _GEN_624;
      end
    end else begin
      tx_cmd_23 <= _GEN_624;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_24 <= _GEN_625;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_24 <= tx_cmd_val[23]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_24 <= _GEN_625;
        end
      end else begin
        tx_cmd_24 <= _GEN_625;
      end
    end else begin
      tx_cmd_24 <= _GEN_625;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_25 <= _GEN_626;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_25 <= tx_cmd_val[22]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_25 <= _GEN_626;
        end
      end else begin
        tx_cmd_25 <= _GEN_626;
      end
    end else begin
      tx_cmd_25 <= _GEN_626;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_26 <= _GEN_627;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_26 <= tx_cmd_val[21]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_26 <= _GEN_627;
        end
      end else begin
        tx_cmd_26 <= _GEN_627;
      end
    end else begin
      tx_cmd_26 <= _GEN_627;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_27 <= _GEN_628;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_27 <= tx_cmd_val[20]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_27 <= _GEN_628;
        end
      end else begin
        tx_cmd_27 <= _GEN_628;
      end
    end else begin
      tx_cmd_27 <= _GEN_628;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_28 <= _GEN_629;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_28 <= tx_cmd_val[19]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_28 <= _GEN_629;
        end
      end else begin
        tx_cmd_28 <= _GEN_629;
      end
    end else begin
      tx_cmd_28 <= _GEN_629;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_29 <= _GEN_630;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_29 <= tx_cmd_val[18]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_29 <= _GEN_630;
        end
      end else begin
        tx_cmd_29 <= _GEN_630;
      end
    end else begin
      tx_cmd_29 <= _GEN_630;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_30 <= _GEN_631;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_30 <= tx_cmd_val[17]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_30 <= _GEN_631;
        end
      end else begin
        tx_cmd_30 <= _GEN_631;
      end
    end else begin
      tx_cmd_30 <= _GEN_631;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_31 <= _GEN_632;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_31 <= tx_cmd_val[16]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_31 <= _GEN_632;
        end
      end else begin
        tx_cmd_31 <= _GEN_632;
      end
    end else begin
      tx_cmd_31 <= _GEN_632;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_32 <= _GEN_633;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_32 <= tx_cmd_val[15]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_32 <= _GEN_633;
        end
      end else begin
        tx_cmd_32 <= _GEN_633;
      end
    end else begin
      tx_cmd_32 <= _GEN_633;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_33 <= _GEN_634;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_33 <= tx_cmd_val[14]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_33 <= _GEN_634;
        end
      end else begin
        tx_cmd_33 <= _GEN_634;
      end
    end else begin
      tx_cmd_33 <= _GEN_634;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_34 <= _GEN_635;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_34 <= tx_cmd_val[13]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_34 <= _GEN_635;
        end
      end else begin
        tx_cmd_34 <= _GEN_635;
      end
    end else begin
      tx_cmd_34 <= _GEN_635;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_35 <= _GEN_636;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_35 <= tx_cmd_val[12]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_35 <= _GEN_636;
        end
      end else begin
        tx_cmd_35 <= _GEN_636;
      end
    end else begin
      tx_cmd_35 <= _GEN_636;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_36 <= _GEN_637;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_36 <= tx_cmd_val[11]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_36 <= _GEN_637;
        end
      end else begin
        tx_cmd_36 <= _GEN_637;
      end
    end else begin
      tx_cmd_36 <= _GEN_637;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_37 <= _GEN_638;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_37 <= tx_cmd_val[10]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_37 <= _GEN_638;
        end
      end else begin
        tx_cmd_37 <= _GEN_638;
      end
    end else begin
      tx_cmd_37 <= _GEN_638;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_38 <= _GEN_639;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_38 <= tx_cmd_val[9]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_38 <= _GEN_639;
        end
      end else begin
        tx_cmd_38 <= _GEN_639;
      end
    end else begin
      tx_cmd_38 <= _GEN_639;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_39 <= _GEN_640;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_39 <= tx_cmd_val[8]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_39 <= _GEN_640;
        end
      end else begin
        tx_cmd_39 <= _GEN_640;
      end
    end else begin
      tx_cmd_39 <= _GEN_640;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_40 <= _GEN_641;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_40 <= tx_cmd_val[7]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_40 <= _GEN_641;
        end
      end else begin
        tx_cmd_40 <= _GEN_641;
      end
    end else begin
      tx_cmd_40 <= _GEN_641;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_41 <= _GEN_642;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_41 <= tx_cmd_val[6]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_41 <= _GEN_642;
        end
      end else begin
        tx_cmd_41 <= _GEN_642;
      end
    end else begin
      tx_cmd_41 <= _GEN_642;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_42 <= _GEN_643;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_42 <= tx_cmd_val[5]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_42 <= _GEN_643;
        end
      end else begin
        tx_cmd_42 <= _GEN_643;
      end
    end else begin
      tx_cmd_42 <= _GEN_643;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_43 <= _GEN_644;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_43 <= tx_cmd_val[4]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_43 <= _GEN_644;
        end
      end else begin
        tx_cmd_43 <= _GEN_644;
      end
    end else begin
      tx_cmd_43 <= _GEN_644;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_44 <= _GEN_645;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_44 <= tx_cmd_val[3]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_44 <= _GEN_645;
        end
      end else begin
        tx_cmd_44 <= _GEN_645;
      end
    end else begin
      tx_cmd_44 <= _GEN_645;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_45 <= _GEN_646;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_45 <= tx_cmd_val[2]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_45 <= _GEN_646;
        end
      end else begin
        tx_cmd_45 <= _GEN_646;
      end
    end else begin
      tx_cmd_45 <= _GEN_646;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_46 <= _GEN_647;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_46 <= tx_cmd_val[1]; // @[Sdc.scala 523:18]
        end else begin
          tx_cmd_46 <= _GEN_647;
        end
      end else begin
        tx_cmd_46 <= _GEN_647;
      end
    end else begin
      tx_cmd_46 <= _GEN_647;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
            tx_cmd_47 <= tx_cmd_val[0]; // @[Sdc.scala 523:18]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 120:31]
      tx_cmd_counter <= 6'h0; // @[Sdc.scala 120:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_counter <= _GEN_648;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_counter <= _GEN_1265;
      end else begin
        tx_cmd_counter <= _GEN_648;
      end
    end else begin
      tx_cmd_counter <= _GEN_648;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_0 <= _GEN_649;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_0 <= tx_cmd_val[41]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_0 <= _GEN_649;
        end
      end else begin
        tx_cmd_crc_0 <= _GEN_649;
      end
    end else begin
      tx_cmd_crc_0 <= _GEN_649;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_1 <= _GEN_650;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_1 <= tx_cmd_val[42]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_1 <= _GEN_650;
        end
      end else begin
        tx_cmd_crc_1 <= _GEN_650;
      end
    end else begin
      tx_cmd_crc_1 <= _GEN_650;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_2 <= _GEN_651;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_2 <= tx_cmd_val[43]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_2 <= _GEN_651;
        end
      end else begin
        tx_cmd_crc_2 <= _GEN_651;
      end
    end else begin
      tx_cmd_crc_2 <= _GEN_651;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_3 <= _GEN_652;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_3 <= tx_cmd_val[44]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_3 <= _GEN_652;
        end
      end else begin
        tx_cmd_crc_3 <= _GEN_652;
      end
    end else begin
      tx_cmd_crc_3 <= _GEN_652;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_4 <= _GEN_653;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_4 <= tx_cmd_val[45]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_4 <= _GEN_653;
        end
      end else begin
        tx_cmd_crc_4 <= _GEN_653;
      end
    end else begin
      tx_cmd_crc_4 <= _GEN_653;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_5 <= _GEN_654;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_5 <= tx_cmd_val[46]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_5 <= _GEN_654;
        end
      end else begin
        tx_cmd_crc_5 <= _GEN_654;
      end
    end else begin
      tx_cmd_crc_5 <= _GEN_654;
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_cmd_crc_6 <= _GEN_655;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
          tx_cmd_crc_6 <= tx_cmd_val[47]; // @[Sdc.scala 525:22]
        end else begin
          tx_cmd_crc_6 <= _GEN_655;
        end
      end else begin
        tx_cmd_crc_6 <= _GEN_655;
      end
    end else begin
      tx_cmd_crc_6 <= _GEN_655;
    end
    if (reset) begin // @[Sdc.scala 122:29]
      tx_cmd_timer <= 6'h0; // @[Sdc.scala 122:29]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 213:69]
      tx_cmd_timer <= _tx_cmd_timer_T_1; // @[Sdc.scala 214:18]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[Sdc.scala 169:57]
      if (_T & reg_clk) begin // @[Sdc.scala 171:47]
        tx_cmd_timer <= _GEN_169;
      end
    end
    if (reset) begin // @[Sdc.scala 123:31]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 123:31]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 213:69]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 215:20]
    end else if (rx_busy_timer != 19'h0 & _T & reg_clk) begin // @[Sdc.scala 217:76]
      reg_tx_cmd_wrt <= 1'h0; // @[Sdc.scala 218:20]
    end else begin
      reg_tx_cmd_wrt <= _GEN_484;
    end
    if (reset) begin // @[Sdc.scala 124:31]
      reg_tx_cmd_out <= 1'h0; // @[Sdc.scala 124:31]
    end else if (tx_cmd_counter > 6'h0 & _T & reg_clk) begin // @[Sdc.scala 220:75]
      reg_tx_cmd_out <= tx_cmd_0; // @[Sdc.scala 222:20]
    end
    if (reset) begin // @[Sdc.scala 125:35]
      rx_dat_in_progress <= 1'h0; // @[Sdc.scala 125:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_in_progress <= _GEN_839;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_in_progress <= _GEN_1289;
      end else begin
        rx_dat_in_progress <= _GEN_839;
      end
    end else begin
      rx_dat_in_progress <= _GEN_839;
    end
    if (reset) begin // @[Sdc.scala 126:31]
      rx_dat_counter <= 11'h0; // @[Sdc.scala 126:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_counter <= _GEN_833;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_counter <= _GEN_1290;
      end else begin
        rx_dat_counter <= _GEN_833;
      end
    end else begin
      rx_dat_counter <= _GEN_833;
    end
    if (reset) begin // @[Sdc.scala 127:33]
      rx_dat_start_bit <= 1'h0; // @[Sdc.scala 127:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_start_bit <= _GEN_864;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_start_bit <= _GEN_1291;
      end else begin
        rx_dat_start_bit <= _GEN_864;
      end
    end else begin
      rx_dat_start_bit <= _GEN_864;
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_0 <= rx_dat_next; // @[Sdc.scala 285:24]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_1 <= rx_dat_bits_0; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_2 <= rx_dat_bits_1; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_3 <= rx_dat_bits_2; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_4 <= rx_dat_bits_3; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_5 <= rx_dat_bits_4; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_6 <= rx_dat_bits_5; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      if (_T_5) begin // @[Sdc.scala 270:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[Sdc.scala 271:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[Sdc.scala 281:66]
            rx_dat_bits_7 <= rx_dat_bits_6; // @[Sdc.scala 284:50]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 129:28]
      rx_dat_next <= 4'h0; // @[Sdc.scala 129:28]
    end else if (rx_dat_counter > 11'h0 & _T_2) begin // @[Sdc.scala 268:57]
      rx_dat_next <= io_sdc_port_dat_in; // @[Sdc.scala 269:17]
    end
    if (reset) begin // @[Sdc.scala 130:34]
      rx_dat_continuous <= 1'h0; // @[Sdc.scala 130:34]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          rx_dat_continuous <= _GEN_1312;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 131:29]
      rx_dat_ready <= 1'h0; // @[Sdc.scala 131:29]
    end else if (io_mem_ren) begin // @[Sdc.scala 599:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 601:19]
        rx_dat_ready <= _GEN_1650;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 601:19]
        rx_dat_ready <= _GEN_1650;
      end else begin
        rx_dat_ready <= _GEN_1704;
      end
    end else begin
      rx_dat_ready <= _GEN_1650;
    end
    if (reset) begin // @[Sdc.scala 132:31]
      rx_dat_intr_en <= 1'h0; // @[Sdc.scala 132:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_intr_en <= io_mem_wdata[17]; // @[Sdc.scala 516:26]
      end
    end
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_0 <= _GEN_848;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_1 <= _GEN_849;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_2 <= _GEN_850;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_3 <= _GEN_851;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_4 <= _GEN_852;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_5 <= _GEN_853;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_6 <= _GEN_854;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_7 <= _GEN_855;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_8 <= _GEN_856;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_9 <= _GEN_857;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_10 <= _GEN_858;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_11 <= _GEN_859;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_12 <= _GEN_860;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_13 <= _GEN_861;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_14 <= _GEN_862;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_15 <= _GEN_863;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        if (io_mem_wdata[11]) begin // @[Sdc.scala 521:40]
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
    if (reset) begin // @[Sdc.scala 134:33]
      rx_dat_crc_error <= 1'h0; // @[Sdc.scala 134:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_error <= _GEN_868;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_crc_error <= _GEN_1309;
      end else begin
        rx_dat_crc_error <= _GEN_868;
      end
    end else begin
      rx_dat_crc_error <= _GEN_868;
    end
    if (reset) begin // @[Sdc.scala 135:29]
      rx_dat_timer <= 19'h0; // @[Sdc.scala 135:29]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_timer <= _GEN_832;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_timer <= _GEN_1310;
      end else begin
        rx_dat_timer <= _GEN_832;
      end
    end else begin
      rx_dat_timer <= _GEN_832;
    end
    if (reset) begin // @[Sdc.scala 136:31]
      rx_dat_timeout <= 1'h0; // @[Sdc.scala 136:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_timeout <= _GEN_835;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_timeout <= _GEN_1311;
      end else begin
        rx_dat_timeout <= _GEN_835;
      end
    end else begin
      rx_dat_timeout <= _GEN_835;
    end
    if (reset) begin // @[Sdc.scala 137:31]
      rx_dat_overrun <= 1'h0; // @[Sdc.scala 137:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_overrun <= _GEN_869;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rx_dat_overrun <= _GEN_1313;
      end else begin
        rx_dat_overrun <= _GEN_869;
      end
    end else begin
      rx_dat_overrun <= _GEN_869;
    end
    if (reset) begin // @[Sdc.scala 139:33]
      rxtx_dat_counter <= 8'h0; // @[Sdc.scala 139:33]
    end else if (io_mem_ren) begin // @[Sdc.scala 599:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 601:19]
        rxtx_dat_counter <= _GEN_1673;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 601:19]
        rxtx_dat_counter <= _GEN_1673;
      end else begin
        rxtx_dat_counter <= _GEN_1701;
      end
    end else begin
      rxtx_dat_counter <= _GEN_1673;
    end
    if (reset) begin // @[Sdc.scala 140:31]
      rxtx_dat_index <= 8'h0; // @[Sdc.scala 140:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        rxtx_dat_index <= _GEN_1163;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        rxtx_dat_index <= _GEN_1314;
      end else begin
        rxtx_dat_index <= _GEN_1163;
      end
    end else begin
      rxtx_dat_index <= _GEN_1163;
    end
    if (reset) begin // @[Sdc.scala 141:30]
      rx_busy_timer <= 19'h0; // @[Sdc.scala 141:30]
    end else if (_T_20) begin // @[Sdc.scala 403:70]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
      rx_busy_timer <= _GEN_962;
    end else begin
      rx_busy_timer <= _GEN_924;
    end
    if (reset) begin // @[Sdc.scala 142:36]
      rx_busy_in_progress <= 1'h0; // @[Sdc.scala 142:36]
    end else if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 360:30]
      if (_T_5) begin // @[Sdc.scala 362:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 366:51]
          rx_busy_in_progress <= _GEN_898;
        end
      end
    end
    rx_dat0_next <= reset | _GEN_923; // @[Sdc.scala 143:{29,29}]
    if (reset) begin // @[Sdc.scala 144:32]
      rx_dat_buf_read <= 1'h0; // @[Sdc.scala 144:32]
    end else if (io_mem_ren) begin // @[Sdc.scala 599:21]
      if (2'h0 == addr_1) begin // @[Sdc.scala 601:19]
        rx_dat_buf_read <= _GEN_837;
      end else if (2'h1 == addr_1) begin // @[Sdc.scala 601:19]
        rx_dat_buf_read <= _GEN_837;
      end else begin
        rx_dat_buf_read <= _GEN_1703;
      end
    end else begin
      rx_dat_buf_read <= _GEN_837;
    end
    if (reset) begin // @[Sdc.scala 145:33]
      rx_dat_buf_cache <= 32'h0; // @[Sdc.scala 145:33]
    end else if (rx_dat_buf_read) begin // @[Sdc.scala 259:26]
      rx_dat_buf_cache <= io_sdbuf_rdata2; // @[Sdc.scala 260:22]
    end
    if (reset) begin // @[Sdc.scala 146:31]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 146:31]
    end else if (_T_20) begin // @[Sdc.scala 403:70]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 404:20]
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
      reg_tx_dat_wrt <= 1'h0; // @[Sdc.scala 408:20]
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
      reg_tx_dat_wrt <= _GEN_960;
    end
    reg_tx_dat_out <= _GEN_1727[0]; // @[Sdc.scala 147:{31,31}]
    if (reset) begin // @[Sdc.scala 148:33]
      tx_empty_intr_en <= 1'h0; // @[Sdc.scala 148:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_empty_intr_en <= io_mem_wdata[18]; // @[Sdc.scala 517:26]
      end
    end
    if (reset) begin // @[Sdc.scala 149:31]
      tx_end_intr_en <= 1'h0; // @[Sdc.scala 149:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_end_intr_en <= io_mem_wdata[19]; // @[Sdc.scala 518:26]
      end
    end
    if (reset) begin // @[Sdc.scala 150:31]
      tx_dat_counter <= 11'h0; // @[Sdc.scala 150:31]
    end else if (_T_20) begin // @[Sdc.scala 403:70]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
      tx_dat_counter <= _tx_dat_counter_T_1; // @[Sdc.scala 414:20]
    end else begin
      tx_dat_counter <= _GEN_870;
    end
    tx_dat_timer <= _GEN_1728[5:0]; // @[Sdc.scala 151:{29,29}]
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_0 <= _GEN_1066;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_0 <= 4'h0; // @[Sdc.scala 473:17]
    end else begin
      tx_dat_0 <= _GEN_1066;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_1 <= _GEN_1067;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_1 <= tx_dat_prepared[7:4]; // @[Sdc.scala 474:17]
    end else begin
      tx_dat_1 <= _GEN_1067;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_2 <= _GEN_1068;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_2 <= tx_dat_prepared[3:0]; // @[Sdc.scala 475:17]
    end else begin
      tx_dat_2 <= _GEN_1068;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_3 <= _GEN_1069;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_3 <= tx_dat_prepared[15:12]; // @[Sdc.scala 476:17]
    end else begin
      tx_dat_3 <= _GEN_1069;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_4 <= _GEN_1070;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_4 <= tx_dat_prepared[11:8]; // @[Sdc.scala 477:17]
    end else begin
      tx_dat_4 <= _GEN_1070;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_5 <= _GEN_1071;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_5 <= tx_dat_prepared[23:20]; // @[Sdc.scala 478:17]
    end else begin
      tx_dat_5 <= _GEN_1071;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_6 <= _GEN_1072;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_6 <= tx_dat_prepared[19:16]; // @[Sdc.scala 479:17]
    end else begin
      tx_dat_6 <= _GEN_1072;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_7 <= _GEN_1073;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_7 <= tx_dat_prepared[31:28]; // @[Sdc.scala 480:17]
    end else begin
      tx_dat_7 <= _GEN_1073;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_8 <= _GEN_1074;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_8 <= tx_dat_prepared[27:24]; // @[Sdc.scala 481:17]
    end else begin
      tx_dat_8 <= _GEN_1074;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_9 <= tx_dat_prepared[7:4]; // @[Sdc.scala 489:18]
    end else begin
      tx_dat_9 <= _GEN_1075;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_10 <= tx_dat_prepared[3:0]; // @[Sdc.scala 490:18]
    end else begin
      tx_dat_10 <= _GEN_1076;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_11 <= tx_dat_prepared[15:12]; // @[Sdc.scala 491:18]
    end else begin
      tx_dat_11 <= _GEN_1077;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_12 <= tx_dat_prepared[11:8]; // @[Sdc.scala 492:18]
    end else begin
      tx_dat_12 <= _GEN_1078;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_13 <= tx_dat_prepared[23:20]; // @[Sdc.scala 493:18]
    end else begin
      tx_dat_13 <= _GEN_1079;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_14 <= tx_dat_prepared[19:16]; // @[Sdc.scala 494:18]
    end else begin
      tx_dat_14 <= _GEN_1080;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_15 <= tx_dat_prepared[31:28]; // @[Sdc.scala 495:18]
    end else begin
      tx_dat_15 <= _GEN_1081;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_16 <= tx_dat_prepared[7:4]; // @[Sdc.scala 462:18]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_16 <= _GEN_1082;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_16 <= tx_dat_prepared[27:24]; // @[Sdc.scala 496:18]
    end else begin
      tx_dat_16 <= _GEN_1082;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_17 <= tx_dat_prepared[3:0]; // @[Sdc.scala 463:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_17 <= tx_dat_18; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_18 <= tx_dat_prepared[15:12]; // @[Sdc.scala 464:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_18 <= tx_dat_19; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_19 <= tx_dat_prepared[11:8]; // @[Sdc.scala 465:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_19 <= tx_dat_20; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_20 <= tx_dat_prepared[23:20]; // @[Sdc.scala 466:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_20 <= tx_dat_21; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_21 <= tx_dat_prepared[19:16]; // @[Sdc.scala 467:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_21 <= tx_dat_22; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_22 <= tx_dat_prepared[31:28]; // @[Sdc.scala 468:18]
    end else if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_22 <= tx_dat_23; // @[Sdc.scala 413:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_23 <= tx_dat_prepared[27:24]; // @[Sdc.scala 469:18]
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_0 <= crc_1_0; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_1 <= tx_dat_crc_0; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_2 <= tx_dat_crc_1; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_3 <= tx_dat_crc_2; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_4 <= tx_dat_crc_3; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_5 <= crc_1_5; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_6 <= tx_dat_crc_5; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_7 <= tx_dat_crc_6; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_8 <= tx_dat_crc_7; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_9 <= tx_dat_crc_8; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_10 <= tx_dat_crc_9; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_11 <= tx_dat_crc_10; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_12 <= crc_1_12; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_13 <= tx_dat_crc_12; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_14 <= tx_dat_crc_13; // @[Sdc.scala 434:16]
        end
      end
    end
    if (!(_T_20)) begin // @[Sdc.scala 403:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[Sdc.scala 406:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
          tx_dat_crc_15 <= tx_dat_crc_14; // @[Sdc.scala 434:16]
        end
      end
    end
    if (reset) begin // @[Sdc.scala 154:32]
      tx_dat_prepared <= 32'h0; // @[Sdc.scala 154:32]
    end else if (_T_20) begin // @[Sdc.scala 403:70]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
      tx_dat_prepared <= _GEN_942;
    end else begin
      tx_dat_prepared <= _GEN_658;
    end
    if (reset) begin // @[Sdc.scala 155:37]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 155:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 470:28]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_prepare_state <= 2'h3; // @[Sdc.scala 486:28]
    end else if (2'h3 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      tx_dat_prepare_state <= 2'h0; // @[Sdc.scala 497:28]
    end else begin
      tx_dat_prepare_state <= _GEN_1109;
    end
    if (reset) begin // @[Sdc.scala 156:31]
      tx_dat_started <= 1'h0; // @[Sdc.scala 156:31]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          tx_dat_started <= _GEN_1316;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 158:35]
      tx_dat_in_progress <= 1'h0; // @[Sdc.scala 158:35]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_in_progress <= _GEN_879;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_in_progress <= _GEN_1322;
      end else begin
        tx_dat_in_progress <= _GEN_879;
      end
    end else begin
      tx_dat_in_progress <= _GEN_879;
    end
    if (reset) begin // @[Sdc.scala 159:27]
      tx_dat_end <= 1'h0; // @[Sdc.scala 159:27]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_end <= _GEN_935;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_end <= _GEN_1323;
      end else begin
        tx_dat_end <= _GEN_935;
      end
    end else begin
      tx_dat_end <= _GEN_935;
    end
    if (reset) begin // @[Sdc.scala 160:32]
      tx_dat_read_sel <= 2'h0; // @[Sdc.scala 160:32]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_read_sel <= _GEN_932;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_read_sel <= _GEN_1318;
      end else begin
        tx_dat_read_sel <= _GEN_932;
      end
    end else begin
      tx_dat_read_sel <= _GEN_932;
    end
    if (reset) begin // @[Sdc.scala 161:33]
      tx_dat_write_sel <= 2'h0; // @[Sdc.scala 161:33]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (!(2'h0 == addr)) begin // @[Sdc.scala 507:19]
        if (2'h1 == addr) begin // @[Sdc.scala 507:19]
          tx_dat_write_sel <= _GEN_1319;
        end else begin
          tx_dat_write_sel <= _GEN_1339;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 162:40]
      tx_dat_read_sel_changed <= 1'h0; // @[Sdc.scala 162:40]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_read_sel_changed <= _GEN_933;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_read_sel_changed <= _GEN_1320;
      end else begin
        tx_dat_read_sel_changed <= _GEN_933;
      end
    end else begin
      tx_dat_read_sel_changed <= _GEN_933;
    end
    if (reset) begin // @[Sdc.scala 163:37]
      tx_dat_write_sel_new <= 1'h0; // @[Sdc.scala 163:37]
    end else if (io_mem_wen) begin // @[Sdc.scala 505:21]
      if (2'h0 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_write_sel_new <= _GEN_877;
      end else if (2'h1 == addr) begin // @[Sdc.scala 507:19]
        tx_dat_write_sel_new <= _GEN_1321;
      end else begin
        tx_dat_write_sel_new <= _GEN_1340;
      end
    end else begin
      tx_dat_write_sel_new <= _GEN_877;
    end
    if (reset) begin // @[Sdc.scala 164:42]
      tx_dat_crc_status_counter <= 4'h0; // @[Sdc.scala 164:42]
    end else if (_T_20) begin // @[Sdc.scala 403:70]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[Sdc.scala 410:77]
      tx_dat_crc_status_counter <= _GEN_963;
    end else begin
      tx_dat_crc_status_counter <= _GEN_929;
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 360:30]
      if (_T_5) begin // @[Sdc.scala 362:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 366:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 368:48]
            tx_dat_crc_status_b_0 <= rx_dat0_next; // @[Sdc.scala 370:34]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 360:30]
      if (_T_5) begin // @[Sdc.scala 362:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 366:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 368:48]
            tx_dat_crc_status_b_1 <= tx_dat_crc_status_b_0; // @[Sdc.scala 369:84]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 360:30]
      if (_T_5) begin // @[Sdc.scala 362:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 366:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[Sdc.scala 368:48]
            tx_dat_crc_status_b_2 <= tx_dat_crc_status_b_1; // @[Sdc.scala 369:84]
          end
        end
      end
    end
    if (reset) begin // @[Sdc.scala 166:34]
      tx_dat_crc_status <= 2'h0; // @[Sdc.scala 166:34]
    end else if (rx_busy_timer > 19'h0) begin // @[Sdc.scala 360:30]
      if (_T_5) begin // @[Sdc.scala 362:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[Sdc.scala 366:51]
          tx_dat_crc_status <= _GEN_894;
        end
      end
    end
    if (reset) begin // @[Sdc.scala 167:37]
      tx_dat_prepared_read <= 1'h0; // @[Sdc.scala 167:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[Sdc.scala 460:33]
      if (_T_20) begin // @[Sdc.scala 403:70]
        tx_dat_prepared_read <= _GEN_872;
      end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[Sdc.scala 406:75]
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
          $fwrite(32'h80000002,"sdc.clk           : 0x%x\n",reg_clk); // @[Sdc.scala 662:9]
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
          $fwrite(32'h80000002,"sdc.cmd_wrt       : 0x%x\n",io_sdc_port_cmd_wrt); // @[Sdc.scala 663:9]
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
          $fwrite(32'h80000002,"sdc.cmd_out       : 0x%x\n",io_sdc_port_cmd_out); // @[Sdc.scala 664:9]
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
          $fwrite(32'h80000002,"rx_res_counter    : 0x%x\n",rx_res_counter); // @[Sdc.scala 665:9]
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
          $fwrite(32'h80000002,"rx_dat_counter    : 0x%x\n",rx_dat_counter); // @[Sdc.scala 666:9]
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
          $fwrite(32'h80000002,"rx_dat_next       : 0x%x\n",rx_dat_next); // @[Sdc.scala 667:9]
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
          $fwrite(32'h80000002,"tx_cmd_counter    : 0x%x\n",tx_cmd_counter); // @[Sdc.scala 668:9]
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
          $fwrite(32'h80000002,"tx_dat_counter    : 0x%x\n",tx_dat_counter); // @[Sdc.scala 669:9]
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
          $fwrite(32'h80000002,"tx_cmd_timer      : 0x%x\n",tx_cmd_timer); // @[Sdc.scala 670:9]
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
          $fwrite(32'h80000002,"rx_busy_timer     : 0x%x\n",rx_busy_timer); // @[Sdc.scala 671:9]
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
          $fwrite(32'h80000002,"tx_dat_read_sel   : 0x%x\n",tx_dat_read_sel); // @[Sdc.scala 672:9]
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
          $fwrite(32'h80000002,"tx_dat_write_sel  : 0x%x\n",tx_dat_write_sel); // @[Sdc.scala 673:9]
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
          $fwrite(32'h80000002,"tx_dat_started    : %d\n",tx_dat_started); // @[Sdc.scala 674:9]
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
          $fwrite(32'h80000002,"tx_dat_in_progress: %d\n",tx_dat_in_progress); // @[Sdc.scala 675:9]
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
  rx_res_in_progress = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  rx_res_counter = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  rx_res_bits_0 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  rx_res_bits_1 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  rx_res_bits_2 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  rx_res_bits_3 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  rx_res_bits_4 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  rx_res_bits_5 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  rx_res_bits_6 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  rx_res_bits_7 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  rx_res_bits_8 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  rx_res_bits_9 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  rx_res_bits_10 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  rx_res_bits_11 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  rx_res_bits_12 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  rx_res_bits_13 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  rx_res_bits_14 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  rx_res_bits_15 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  rx_res_bits_16 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  rx_res_bits_17 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rx_res_bits_18 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  rx_res_bits_19 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  rx_res_bits_20 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  rx_res_bits_21 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  rx_res_bits_22 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  rx_res_bits_23 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  rx_res_bits_24 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  rx_res_bits_25 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  rx_res_bits_26 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  rx_res_bits_27 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  rx_res_bits_28 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  rx_res_bits_29 = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  rx_res_bits_30 = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  rx_res_bits_31 = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  rx_res_bits_32 = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  rx_res_bits_33 = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  rx_res_bits_34 = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  rx_res_bits_35 = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  rx_res_bits_36 = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  rx_res_bits_37 = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  rx_res_bits_38 = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  rx_res_bits_39 = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  rx_res_bits_40 = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  rx_res_bits_41 = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  rx_res_bits_42 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  rx_res_bits_43 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  rx_res_bits_44 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  rx_res_bits_45 = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  rx_res_bits_46 = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  rx_res_bits_47 = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  rx_res_bits_48 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  rx_res_bits_49 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  rx_res_bits_50 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  rx_res_bits_51 = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  rx_res_bits_52 = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  rx_res_bits_53 = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  rx_res_bits_54 = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  rx_res_bits_55 = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  rx_res_bits_56 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  rx_res_bits_57 = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  rx_res_bits_58 = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  rx_res_bits_59 = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  rx_res_bits_60 = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  rx_res_bits_61 = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  rx_res_bits_62 = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  rx_res_bits_63 = _RAND_69[0:0];
  _RAND_70 = {1{`RANDOM}};
  rx_res_bits_64 = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  rx_res_bits_65 = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  rx_res_bits_66 = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  rx_res_bits_67 = _RAND_73[0:0];
  _RAND_74 = {1{`RANDOM}};
  rx_res_bits_68 = _RAND_74[0:0];
  _RAND_75 = {1{`RANDOM}};
  rx_res_bits_69 = _RAND_75[0:0];
  _RAND_76 = {1{`RANDOM}};
  rx_res_bits_70 = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  rx_res_bits_71 = _RAND_77[0:0];
  _RAND_78 = {1{`RANDOM}};
  rx_res_bits_72 = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  rx_res_bits_73 = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  rx_res_bits_74 = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  rx_res_bits_75 = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  rx_res_bits_76 = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  rx_res_bits_77 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  rx_res_bits_78 = _RAND_84[0:0];
  _RAND_85 = {1{`RANDOM}};
  rx_res_bits_79 = _RAND_85[0:0];
  _RAND_86 = {1{`RANDOM}};
  rx_res_bits_80 = _RAND_86[0:0];
  _RAND_87 = {1{`RANDOM}};
  rx_res_bits_81 = _RAND_87[0:0];
  _RAND_88 = {1{`RANDOM}};
  rx_res_bits_82 = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  rx_res_bits_83 = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  rx_res_bits_84 = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  rx_res_bits_85 = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  rx_res_bits_86 = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  rx_res_bits_87 = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  rx_res_bits_88 = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  rx_res_bits_89 = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  rx_res_bits_90 = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  rx_res_bits_91 = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  rx_res_bits_92 = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  rx_res_bits_93 = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  rx_res_bits_94 = _RAND_100[0:0];
  _RAND_101 = {1{`RANDOM}};
  rx_res_bits_95 = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  rx_res_bits_96 = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  rx_res_bits_97 = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  rx_res_bits_98 = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  rx_res_bits_99 = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  rx_res_bits_100 = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  rx_res_bits_101 = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  rx_res_bits_102 = _RAND_108[0:0];
  _RAND_109 = {1{`RANDOM}};
  rx_res_bits_103 = _RAND_109[0:0];
  _RAND_110 = {1{`RANDOM}};
  rx_res_bits_104 = _RAND_110[0:0];
  _RAND_111 = {1{`RANDOM}};
  rx_res_bits_105 = _RAND_111[0:0];
  _RAND_112 = {1{`RANDOM}};
  rx_res_bits_106 = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  rx_res_bits_107 = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  rx_res_bits_108 = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  rx_res_bits_109 = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  rx_res_bits_110 = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  rx_res_bits_111 = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  rx_res_bits_112 = _RAND_118[0:0];
  _RAND_119 = {1{`RANDOM}};
  rx_res_bits_113 = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  rx_res_bits_114 = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  rx_res_bits_115 = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  rx_res_bits_116 = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  rx_res_bits_117 = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  rx_res_bits_118 = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  rx_res_bits_119 = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  rx_res_bits_120 = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  rx_res_bits_121 = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  rx_res_bits_122 = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  rx_res_bits_123 = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  rx_res_bits_124 = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  rx_res_bits_125 = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  rx_res_bits_126 = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  rx_res_bits_127 = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  rx_res_bits_128 = _RAND_134[0:0];
  _RAND_135 = {1{`RANDOM}};
  rx_res_bits_129 = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  rx_res_bits_130 = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  rx_res_bits_131 = _RAND_137[0:0];
  _RAND_138 = {1{`RANDOM}};
  rx_res_bits_132 = _RAND_138[0:0];
  _RAND_139 = {1{`RANDOM}};
  rx_res_bits_133 = _RAND_139[0:0];
  _RAND_140 = {1{`RANDOM}};
  rx_res_bits_134 = _RAND_140[0:0];
  _RAND_141 = {1{`RANDOM}};
  rx_res_bits_135 = _RAND_141[0:0];
  _RAND_142 = {1{`RANDOM}};
  rx_res_next = _RAND_142[0:0];
  _RAND_143 = {1{`RANDOM}};
  rx_res_type = _RAND_143[3:0];
  _RAND_144 = {5{`RANDOM}};
  rx_res = _RAND_144[135:0];
  _RAND_145 = {1{`RANDOM}};
  rx_res_ready = _RAND_145[0:0];
  _RAND_146 = {1{`RANDOM}};
  rx_res_intr_en = _RAND_146[0:0];
  _RAND_147 = {1{`RANDOM}};
  rx_res_crc_0 = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  rx_res_crc_1 = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  rx_res_crc_2 = _RAND_149[0:0];
  _RAND_150 = {1{`RANDOM}};
  rx_res_crc_3 = _RAND_150[0:0];
  _RAND_151 = {1{`RANDOM}};
  rx_res_crc_4 = _RAND_151[0:0];
  _RAND_152 = {1{`RANDOM}};
  rx_res_crc_5 = _RAND_152[0:0];
  _RAND_153 = {1{`RANDOM}};
  rx_res_crc_6 = _RAND_153[0:0];
  _RAND_154 = {1{`RANDOM}};
  rx_res_crc_error = _RAND_154[0:0];
  _RAND_155 = {1{`RANDOM}};
  rx_res_crc_en = _RAND_155[0:0];
  _RAND_156 = {1{`RANDOM}};
  rx_res_timer = _RAND_156[7:0];
  _RAND_157 = {1{`RANDOM}};
  rx_res_timeout = _RAND_157[0:0];
  _RAND_158 = {1{`RANDOM}};
  rx_res_read_counter = _RAND_158[1:0];
  _RAND_159 = {1{`RANDOM}};
  tx_cmd_arg = _RAND_159[31:0];
  _RAND_160 = {1{`RANDOM}};
  tx_cmd_0 = _RAND_160[0:0];
  _RAND_161 = {1{`RANDOM}};
  tx_cmd_1 = _RAND_161[0:0];
  _RAND_162 = {1{`RANDOM}};
  tx_cmd_2 = _RAND_162[0:0];
  _RAND_163 = {1{`RANDOM}};
  tx_cmd_3 = _RAND_163[0:0];
  _RAND_164 = {1{`RANDOM}};
  tx_cmd_4 = _RAND_164[0:0];
  _RAND_165 = {1{`RANDOM}};
  tx_cmd_5 = _RAND_165[0:0];
  _RAND_166 = {1{`RANDOM}};
  tx_cmd_6 = _RAND_166[0:0];
  _RAND_167 = {1{`RANDOM}};
  tx_cmd_7 = _RAND_167[0:0];
  _RAND_168 = {1{`RANDOM}};
  tx_cmd_8 = _RAND_168[0:0];
  _RAND_169 = {1{`RANDOM}};
  tx_cmd_9 = _RAND_169[0:0];
  _RAND_170 = {1{`RANDOM}};
  tx_cmd_10 = _RAND_170[0:0];
  _RAND_171 = {1{`RANDOM}};
  tx_cmd_11 = _RAND_171[0:0];
  _RAND_172 = {1{`RANDOM}};
  tx_cmd_12 = _RAND_172[0:0];
  _RAND_173 = {1{`RANDOM}};
  tx_cmd_13 = _RAND_173[0:0];
  _RAND_174 = {1{`RANDOM}};
  tx_cmd_14 = _RAND_174[0:0];
  _RAND_175 = {1{`RANDOM}};
  tx_cmd_15 = _RAND_175[0:0];
  _RAND_176 = {1{`RANDOM}};
  tx_cmd_16 = _RAND_176[0:0];
  _RAND_177 = {1{`RANDOM}};
  tx_cmd_17 = _RAND_177[0:0];
  _RAND_178 = {1{`RANDOM}};
  tx_cmd_18 = _RAND_178[0:0];
  _RAND_179 = {1{`RANDOM}};
  tx_cmd_19 = _RAND_179[0:0];
  _RAND_180 = {1{`RANDOM}};
  tx_cmd_20 = _RAND_180[0:0];
  _RAND_181 = {1{`RANDOM}};
  tx_cmd_21 = _RAND_181[0:0];
  _RAND_182 = {1{`RANDOM}};
  tx_cmd_22 = _RAND_182[0:0];
  _RAND_183 = {1{`RANDOM}};
  tx_cmd_23 = _RAND_183[0:0];
  _RAND_184 = {1{`RANDOM}};
  tx_cmd_24 = _RAND_184[0:0];
  _RAND_185 = {1{`RANDOM}};
  tx_cmd_25 = _RAND_185[0:0];
  _RAND_186 = {1{`RANDOM}};
  tx_cmd_26 = _RAND_186[0:0];
  _RAND_187 = {1{`RANDOM}};
  tx_cmd_27 = _RAND_187[0:0];
  _RAND_188 = {1{`RANDOM}};
  tx_cmd_28 = _RAND_188[0:0];
  _RAND_189 = {1{`RANDOM}};
  tx_cmd_29 = _RAND_189[0:0];
  _RAND_190 = {1{`RANDOM}};
  tx_cmd_30 = _RAND_190[0:0];
  _RAND_191 = {1{`RANDOM}};
  tx_cmd_31 = _RAND_191[0:0];
  _RAND_192 = {1{`RANDOM}};
  tx_cmd_32 = _RAND_192[0:0];
  _RAND_193 = {1{`RANDOM}};
  tx_cmd_33 = _RAND_193[0:0];
  _RAND_194 = {1{`RANDOM}};
  tx_cmd_34 = _RAND_194[0:0];
  _RAND_195 = {1{`RANDOM}};
  tx_cmd_35 = _RAND_195[0:0];
  _RAND_196 = {1{`RANDOM}};
  tx_cmd_36 = _RAND_196[0:0];
  _RAND_197 = {1{`RANDOM}};
  tx_cmd_37 = _RAND_197[0:0];
  _RAND_198 = {1{`RANDOM}};
  tx_cmd_38 = _RAND_198[0:0];
  _RAND_199 = {1{`RANDOM}};
  tx_cmd_39 = _RAND_199[0:0];
  _RAND_200 = {1{`RANDOM}};
  tx_cmd_40 = _RAND_200[0:0];
  _RAND_201 = {1{`RANDOM}};
  tx_cmd_41 = _RAND_201[0:0];
  _RAND_202 = {1{`RANDOM}};
  tx_cmd_42 = _RAND_202[0:0];
  _RAND_203 = {1{`RANDOM}};
  tx_cmd_43 = _RAND_203[0:0];
  _RAND_204 = {1{`RANDOM}};
  tx_cmd_44 = _RAND_204[0:0];
  _RAND_205 = {1{`RANDOM}};
  tx_cmd_45 = _RAND_205[0:0];
  _RAND_206 = {1{`RANDOM}};
  tx_cmd_46 = _RAND_206[0:0];
  _RAND_207 = {1{`RANDOM}};
  tx_cmd_47 = _RAND_207[0:0];
  _RAND_208 = {1{`RANDOM}};
  tx_cmd_counter = _RAND_208[5:0];
  _RAND_209 = {1{`RANDOM}};
  tx_cmd_crc_0 = _RAND_209[0:0];
  _RAND_210 = {1{`RANDOM}};
  tx_cmd_crc_1 = _RAND_210[0:0];
  _RAND_211 = {1{`RANDOM}};
  tx_cmd_crc_2 = _RAND_211[0:0];
  _RAND_212 = {1{`RANDOM}};
  tx_cmd_crc_3 = _RAND_212[0:0];
  _RAND_213 = {1{`RANDOM}};
  tx_cmd_crc_4 = _RAND_213[0:0];
  _RAND_214 = {1{`RANDOM}};
  tx_cmd_crc_5 = _RAND_214[0:0];
  _RAND_215 = {1{`RANDOM}};
  tx_cmd_crc_6 = _RAND_215[0:0];
  _RAND_216 = {1{`RANDOM}};
  tx_cmd_timer = _RAND_216[5:0];
  _RAND_217 = {1{`RANDOM}};
  reg_tx_cmd_wrt = _RAND_217[0:0];
  _RAND_218 = {1{`RANDOM}};
  reg_tx_cmd_out = _RAND_218[0:0];
  _RAND_219 = {1{`RANDOM}};
  rx_dat_in_progress = _RAND_219[0:0];
  _RAND_220 = {1{`RANDOM}};
  rx_dat_counter = _RAND_220[10:0];
  _RAND_221 = {1{`RANDOM}};
  rx_dat_start_bit = _RAND_221[0:0];
  _RAND_222 = {1{`RANDOM}};
  rx_dat_bits_0 = _RAND_222[3:0];
  _RAND_223 = {1{`RANDOM}};
  rx_dat_bits_1 = _RAND_223[3:0];
  _RAND_224 = {1{`RANDOM}};
  rx_dat_bits_2 = _RAND_224[3:0];
  _RAND_225 = {1{`RANDOM}};
  rx_dat_bits_3 = _RAND_225[3:0];
  _RAND_226 = {1{`RANDOM}};
  rx_dat_bits_4 = _RAND_226[3:0];
  _RAND_227 = {1{`RANDOM}};
  rx_dat_bits_5 = _RAND_227[3:0];
  _RAND_228 = {1{`RANDOM}};
  rx_dat_bits_6 = _RAND_228[3:0];
  _RAND_229 = {1{`RANDOM}};
  rx_dat_bits_7 = _RAND_229[3:0];
  _RAND_230 = {1{`RANDOM}};
  rx_dat_next = _RAND_230[3:0];
  _RAND_231 = {1{`RANDOM}};
  rx_dat_continuous = _RAND_231[0:0];
  _RAND_232 = {1{`RANDOM}};
  rx_dat_ready = _RAND_232[0:0];
  _RAND_233 = {1{`RANDOM}};
  rx_dat_intr_en = _RAND_233[0:0];
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
  rx_dat_overrun = _RAND_253[0:0];
  _RAND_254 = {1{`RANDOM}};
  rxtx_dat_counter = _RAND_254[7:0];
  _RAND_255 = {1{`RANDOM}};
  rxtx_dat_index = _RAND_255[7:0];
  _RAND_256 = {1{`RANDOM}};
  rx_busy_timer = _RAND_256[18:0];
  _RAND_257 = {1{`RANDOM}};
  rx_busy_in_progress = _RAND_257[0:0];
  _RAND_258 = {1{`RANDOM}};
  rx_dat0_next = _RAND_258[0:0];
  _RAND_259 = {1{`RANDOM}};
  rx_dat_buf_read = _RAND_259[0:0];
  _RAND_260 = {1{`RANDOM}};
  rx_dat_buf_cache = _RAND_260[31:0];
  _RAND_261 = {1{`RANDOM}};
  reg_tx_dat_wrt = _RAND_261[0:0];
  _RAND_262 = {1{`RANDOM}};
  reg_tx_dat_out = _RAND_262[0:0];
  _RAND_263 = {1{`RANDOM}};
  tx_empty_intr_en = _RAND_263[0:0];
  _RAND_264 = {1{`RANDOM}};
  tx_end_intr_en = _RAND_264[0:0];
  _RAND_265 = {1{`RANDOM}};
  tx_dat_counter = _RAND_265[10:0];
  _RAND_266 = {1{`RANDOM}};
  tx_dat_timer = _RAND_266[5:0];
  _RAND_267 = {1{`RANDOM}};
  tx_dat_0 = _RAND_267[3:0];
  _RAND_268 = {1{`RANDOM}};
  tx_dat_1 = _RAND_268[3:0];
  _RAND_269 = {1{`RANDOM}};
  tx_dat_2 = _RAND_269[3:0];
  _RAND_270 = {1{`RANDOM}};
  tx_dat_3 = _RAND_270[3:0];
  _RAND_271 = {1{`RANDOM}};
  tx_dat_4 = _RAND_271[3:0];
  _RAND_272 = {1{`RANDOM}};
  tx_dat_5 = _RAND_272[3:0];
  _RAND_273 = {1{`RANDOM}};
  tx_dat_6 = _RAND_273[3:0];
  _RAND_274 = {1{`RANDOM}};
  tx_dat_7 = _RAND_274[3:0];
  _RAND_275 = {1{`RANDOM}};
  tx_dat_8 = _RAND_275[3:0];
  _RAND_276 = {1{`RANDOM}};
  tx_dat_9 = _RAND_276[3:0];
  _RAND_277 = {1{`RANDOM}};
  tx_dat_10 = _RAND_277[3:0];
  _RAND_278 = {1{`RANDOM}};
  tx_dat_11 = _RAND_278[3:0];
  _RAND_279 = {1{`RANDOM}};
  tx_dat_12 = _RAND_279[3:0];
  _RAND_280 = {1{`RANDOM}};
  tx_dat_13 = _RAND_280[3:0];
  _RAND_281 = {1{`RANDOM}};
  tx_dat_14 = _RAND_281[3:0];
  _RAND_282 = {1{`RANDOM}};
  tx_dat_15 = _RAND_282[3:0];
  _RAND_283 = {1{`RANDOM}};
  tx_dat_16 = _RAND_283[3:0];
  _RAND_284 = {1{`RANDOM}};
  tx_dat_17 = _RAND_284[3:0];
  _RAND_285 = {1{`RANDOM}};
  tx_dat_18 = _RAND_285[3:0];
  _RAND_286 = {1{`RANDOM}};
  tx_dat_19 = _RAND_286[3:0];
  _RAND_287 = {1{`RANDOM}};
  tx_dat_20 = _RAND_287[3:0];
  _RAND_288 = {1{`RANDOM}};
  tx_dat_21 = _RAND_288[3:0];
  _RAND_289 = {1{`RANDOM}};
  tx_dat_22 = _RAND_289[3:0];
  _RAND_290 = {1{`RANDOM}};
  tx_dat_23 = _RAND_290[3:0];
  _RAND_291 = {1{`RANDOM}};
  tx_dat_crc_0 = _RAND_291[3:0];
  _RAND_292 = {1{`RANDOM}};
  tx_dat_crc_1 = _RAND_292[3:0];
  _RAND_293 = {1{`RANDOM}};
  tx_dat_crc_2 = _RAND_293[3:0];
  _RAND_294 = {1{`RANDOM}};
  tx_dat_crc_3 = _RAND_294[3:0];
  _RAND_295 = {1{`RANDOM}};
  tx_dat_crc_4 = _RAND_295[3:0];
  _RAND_296 = {1{`RANDOM}};
  tx_dat_crc_5 = _RAND_296[3:0];
  _RAND_297 = {1{`RANDOM}};
  tx_dat_crc_6 = _RAND_297[3:0];
  _RAND_298 = {1{`RANDOM}};
  tx_dat_crc_7 = _RAND_298[3:0];
  _RAND_299 = {1{`RANDOM}};
  tx_dat_crc_8 = _RAND_299[3:0];
  _RAND_300 = {1{`RANDOM}};
  tx_dat_crc_9 = _RAND_300[3:0];
  _RAND_301 = {1{`RANDOM}};
  tx_dat_crc_10 = _RAND_301[3:0];
  _RAND_302 = {1{`RANDOM}};
  tx_dat_crc_11 = _RAND_302[3:0];
  _RAND_303 = {1{`RANDOM}};
  tx_dat_crc_12 = _RAND_303[3:0];
  _RAND_304 = {1{`RANDOM}};
  tx_dat_crc_13 = _RAND_304[3:0];
  _RAND_305 = {1{`RANDOM}};
  tx_dat_crc_14 = _RAND_305[3:0];
  _RAND_306 = {1{`RANDOM}};
  tx_dat_crc_15 = _RAND_306[3:0];
  _RAND_307 = {1{`RANDOM}};
  tx_dat_prepared = _RAND_307[31:0];
  _RAND_308 = {1{`RANDOM}};
  tx_dat_prepare_state = _RAND_308[1:0];
  _RAND_309 = {1{`RANDOM}};
  tx_dat_started = _RAND_309[0:0];
  _RAND_310 = {1{`RANDOM}};
  tx_dat_in_progress = _RAND_310[0:0];
  _RAND_311 = {1{`RANDOM}};
  tx_dat_end = _RAND_311[0:0];
  _RAND_312 = {1{`RANDOM}};
  tx_dat_read_sel = _RAND_312[1:0];
  _RAND_313 = {1{`RANDOM}};
  tx_dat_write_sel = _RAND_313[1:0];
  _RAND_314 = {1{`RANDOM}};
  tx_dat_read_sel_changed = _RAND_314[0:0];
  _RAND_315 = {1{`RANDOM}};
  tx_dat_write_sel_new = _RAND_315[0:0];
  _RAND_316 = {1{`RANDOM}};
  tx_dat_crc_status_counter = _RAND_316[3:0];
  _RAND_317 = {1{`RANDOM}};
  tx_dat_crc_status_b_0 = _RAND_317[0:0];
  _RAND_318 = {1{`RANDOM}};
  tx_dat_crc_status_b_1 = _RAND_318[0:0];
  _RAND_319 = {1{`RANDOM}};
  tx_dat_crc_status_b_2 = _RAND_319[0:0];
  _RAND_320 = {1{`RANDOM}};
  tx_dat_crc_status = _RAND_320[1:0];
  _RAND_321 = {1{`RANDOM}};
  tx_dat_prepared_read = _RAND_321[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InterruptController(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr,
  output [31:0] io_mem_rdata,
  input         io_mem_ren,
  input         io_mem_wen,
  input  [31:0] io_mem_wdata,
  input  [1:0]  io_intr_periferal,
  output        io_intr_cpu
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] reg_intr_enable; // @[InterruptController.scala 21:34]
  reg [1:0] reg_intr_asserted; // @[InterruptController.scala 22:34]
  reg  reg_intr_cpu; // @[InterruptController.scala 23:34]
  wire [1:0] inter_asserted = io_intr_periferal & reg_intr_enable; // @[InterruptController.scala 25:42]
  wire [31:0] _GEN_0 = io_mem_raddr[2] ? {{30'd0}, reg_intr_asserted} : 32'hdeadbeef; // @[InterruptController.scala 31:16 36:33 41:22]
  wire [31:0] _GEN_1 = ~io_mem_raddr[2] ? {{30'd0}, reg_intr_enable} : _GEN_0; // @[InterruptController.scala 36:33 38:22]
  wire [31:0] _GEN_3 = io_mem_wen ? io_mem_wdata : {{30'd0}, reg_intr_enable}; // @[InterruptController.scala 46:21 47:21 21:34]
  wire [31:0] _GEN_4 = reset ? 32'h0 : _GEN_3; // @[InterruptController.scala 21:{34,34}]
  assign io_mem_rdata = io_mem_ren ? _GEN_1 : 32'hdeadbeef; // @[InterruptController.scala 31:16 35:21]
  assign io_intr_cpu = reg_intr_cpu; // @[InterruptController.scala 29:15]
  always @(posedge clock) begin
    reg_intr_enable <= _GEN_4[1:0]; // @[InterruptController.scala 21:{34,34}]
    if (reset) begin // @[InterruptController.scala 22:34]
      reg_intr_asserted <= 2'h0; // @[InterruptController.scala 22:34]
    end else begin
      reg_intr_asserted <= inter_asserted; // @[InterruptController.scala 27:21]
    end
    if (reset) begin // @[InterruptController.scala 23:34]
      reg_intr_cpu <= 1'h0; // @[InterruptController.scala 23:34]
    end else begin
      reg_intr_cpu <= |inter_asserted; // @[InterruptController.scala 26:16]
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
  reg_intr_enable = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  reg_intr_asserted = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  reg_intr_cpu = _RAND_2[0:0];
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
  input  [31:0] io_initiator_waddr,
  input         io_initiator_wen,
  output        io_initiator_wready,
  input  [31:0] io_initiator_wdata,
  output [31:0] io_targets_0_raddr,
  input  [31:0] io_targets_0_rdata,
  output        io_targets_0_ren,
  input         io_targets_0_rvalid,
  output [31:0] io_targets_0_waddr,
  output        io_targets_0_wen,
  output [31:0] io_targets_0_wdata,
  output        io_targets_1_wen,
  output [31:0] io_targets_1_wdata,
  output [31:0] io_targets_2_raddr,
  input  [31:0] io_targets_2_rdata,
  output        io_targets_2_ren,
  output [31:0] io_targets_2_waddr,
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
  output [31:0] io_targets_4_waddr,
  output        io_targets_4_wen,
  output [31:0] io_targets_4_wdata,
  output [31:0] io_targets_5_raddr,
  input  [31:0] io_targets_5_rdata,
  output        io_targets_5_ren,
  output        io_targets_5_wen,
  output [31:0] io_targets_5_wdata,
  output [31:0] io_targets_6_raddr,
  input  [31:0] io_targets_6_rdata
);
  wire  _GEN_2 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rvalid : 1'h1; // @[Decoder.scala 39:79 42:14 13:27]
  wire [31:0] _GEN_3 = 21'h10000 == io_initiator_raddr[31:11] ? io_targets_0_rdata : 32'hdeadbeef; // @[Decoder.scala 39:79 43:13 14:26]
  wire [31:0] _GEN_12 = 26'hc00000 == io_initiator_raddr[31:6] ? 32'hdeadbeef : _GEN_3; // @[Decoder.scala 39:79 43:13]
  wire [31:0] _GEN_21 = 26'hc00040 == io_initiator_raddr[31:6] ? io_targets_2_rdata : _GEN_12; // @[Decoder.scala 39:79 43:13]
  wire [31:0] _GEN_30 = 26'hc00080 == io_initiator_raddr[31:6] ? io_targets_3_rdata : _GEN_21; // @[Decoder.scala 39:79 43:13]
  wire [31:0] _GEN_39 = 26'hc000c0 == io_initiator_raddr[31:6] ? io_targets_4_rdata : _GEN_30; // @[Decoder.scala 39:79 43:13]
  wire [31:0] _GEN_48 = 26'hc00100 == io_initiator_raddr[31:6] ? io_targets_5_rdata : _GEN_39; // @[Decoder.scala 39:79 43:13]
  assign io_initiator_rdata = 26'h1000000 == io_initiator_raddr[31:6] ? io_targets_6_rdata : _GEN_48; // @[Decoder.scala 39:79 43:13]
  assign io_initiator_rvalid = 26'h1000000 == io_initiator_raddr[31:6] | (26'hc00100 == io_initiator_raddr[31:6] | (26'hc000c0
     == io_initiator_raddr[31:6] | (26'hc00080 == io_initiator_raddr[31:6] | (26'hc00040 == io_initiator_raddr[31:6] | (26'hc00000
     == io_initiator_raddr[31:6] | _GEN_2))))); // @[Decoder.scala 39:79 42:14]
  assign io_initiator_wready = 26'h1000000 == io_initiator_waddr[31:6] | (26'hc00100 == io_initiator_waddr[31:6] | (26'hc000c0
     == io_initiator_waddr[31:6] | (26'hc00080 == io_initiator_waddr[31:6] | (26'hc00040 == io_initiator_waddr[31:6] | (26'hc00000
     == io_initiator_waddr[31:6] | 21'h10000 == io_initiator_waddr[31:11]))))); // @[Decoder.scala 45:79 50:14]
  assign io_targets_0_raddr = 21'h10000 == io_initiator_raddr[31:11] ? {{21'd0}, io_initiator_raddr[10:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
  assign io_targets_0_ren = 21'h10000 == io_initiator_raddr[31:11] & io_initiator_ren; // @[Decoder.scala 39:79 41:11 26:26]
  assign io_targets_0_waddr = 21'h10000 == io_initiator_waddr[31:11] ? {{21'd0}, io_initiator_waddr[10:0]} : 32'h0; // @[Decoder.scala 45:79 46:13 27:28]
  assign io_targets_0_wen = 21'h10000 == io_initiator_waddr[31:11] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_0_wdata = 21'h10000 == io_initiator_waddr[31:11] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_1_wen = 26'hc00000 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_1_wdata = 26'hc00000 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_2_raddr = 26'hc00040 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
  assign io_targets_2_ren = 26'hc00040 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 39:79 41:11 26:26]
  assign io_targets_2_waddr = 26'hc00040 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 45:79 46:13 27:28]
  assign io_targets_2_wen = 26'hc00040 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_2_wdata = 26'hc00040 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_3_raddr = 26'hc00080 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
  assign io_targets_3_ren = 26'hc00080 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 39:79 41:11 26:26]
  assign io_targets_3_waddr = 26'hc00080 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 45:79 46:13 27:28]
  assign io_targets_3_wen = 26'hc00080 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_3_wdata = 26'hc00080 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_4_raddr = 26'hc000c0 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
  assign io_targets_4_ren = 26'hc000c0 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 39:79 41:11 26:26]
  assign io_targets_4_waddr = 26'hc000c0 == io_initiator_waddr[31:6] ? {{26'd0}, io_initiator_waddr[5:0]} : 32'h0; // @[Decoder.scala 45:79 46:13 27:28]
  assign io_targets_4_wen = 26'hc000c0 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_4_wdata = 26'hc000c0 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_5_raddr = 26'hc00100 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
  assign io_targets_5_ren = 26'hc00100 == io_initiator_raddr[31:6] & io_initiator_ren; // @[Decoder.scala 39:79 41:11 26:26]
  assign io_targets_5_wen = 26'hc00100 == io_initiator_waddr[31:6] & io_initiator_wen; // @[Decoder.scala 45:79 47:11 28:26]
  assign io_targets_5_wdata = 26'hc00100 == io_initiator_waddr[31:6] ? io_initiator_wdata : 32'hdeadbeef; // @[Decoder.scala 45:79 48:13 29:28]
  assign io_targets_6_raddr = 26'h1000000 == io_initiator_raddr[31:6] ? {{26'd0}, io_initiator_raddr[5:0]} : 32'h0; // @[Decoder.scala 39:79 40:13 25:28]
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
  reg [31:0] next_addr; // @[Decoder.scala 63:26]
  wire  en = 21'h10000 == io_initiator_addr[31:11]; // @[Decoder.scala 78:37]
  wire  _GEN_2 = 21'h10000 == next_addr[31:11] ? io_targets_0_valid : 1'h1; // @[Decoder.scala 82:70 83:13 61:26]
  wire [31:0] _GEN_3 = 21'h10000 == next_addr[31:11] ? io_targets_0_inst : 32'hdeadbeef; // @[Decoder.scala 82:70 84:12 62:25]
  wire  en_1 = 4'h2 == io_initiator_addr[31:28]; // @[Decoder.scala 78:37]
  assign io_initiator_inst = 4'h2 == next_addr[31:28] ? io_targets_1_inst : _GEN_3; // @[Decoder.scala 82:70 84:12]
  assign io_initiator_valid = 4'h2 == next_addr[31:28] ? io_targets_1_valid : _GEN_2; // @[Decoder.scala 82:70 83:13]
  assign io_targets_0_en = 21'h10000 == io_initiator_addr[31:11]; // @[Decoder.scala 78:37]
  assign io_targets_0_addr = en ? {{21'd0}, io_initiator_addr[10:0]} : 32'h0; // @[Decoder.scala 78:78 79:12 72:27]
  assign io_targets_1_en = 4'h2 == io_initiator_addr[31:28]; // @[Decoder.scala 78:37]
  assign io_targets_1_addr = en_1 ? {{4'd0}, io_initiator_addr[27:0]} : 32'h0; // @[Decoder.scala 78:78 79:12 72:27]
  always @(posedge clock) begin
    next_addr <= io_initiator_addr; // @[Decoder.scala 63:26]
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
  output [31:0]  io_debugSignals_core_ex2_reg_pc,
  output         io_debugSignals_core_ex2_is_valid_inst,
  output         io_debugSignals_core_me_intr,
  output         io_debugSignals_core_mt_intr,
  output         io_debugSignals_core_trap,
  output [47:0]  io_debugSignals_core_cycle_counter,
  output [31:0]  io_debugSignals_core_id_pc,
  output [31:0]  io_debugSignals_core_id_inst,
  output [31:0]  io_debugSignals_core_mem3_rdata,
  output         io_debugSignals_core_mem3_rvalid,
  output [31:0]  io_debugSignals_core_rwaddr,
  output         io_debugSignals_core_ex2_reg_is_br,
  output         io_debugSignals_core_id_reg_is_bp_fail,
  output         io_debugSignals_core_if2_reg_bp_taken,
  output [2:0]   io_debugSignals_core_ic_state,
  output         io_debugSignals_ren,
  output         io_debugSignals_wen,
  output         io_debugSignals_wready,
  output [3:0]   io_debugSignals_wstrb,
  output [31:0]  io_debugSignals_wdata,
  output [2:0]   io_debugSignals_mem_icache_state,
  output [2:0]   io_debugSignals_mem_dram_state,
  output [15:0]  io_debugSignals_mem_imem_addr
);
  wire  core_clock; // @[Top.scala 77:20]
  wire  core_reset; // @[Top.scala 77:20]
  wire [31:0] core_io_imem_addr; // @[Top.scala 77:20]
  wire [31:0] core_io_imem_inst; // @[Top.scala 77:20]
  wire  core_io_imem_valid; // @[Top.scala 77:20]
  wire [31:0] core_io_dmem_raddr; // @[Top.scala 77:20]
  wire [31:0] core_io_dmem_rdata; // @[Top.scala 77:20]
  wire  core_io_dmem_ren; // @[Top.scala 77:20]
  wire  core_io_dmem_rvalid; // @[Top.scala 77:20]
  wire [31:0] core_io_dmem_waddr; // @[Top.scala 77:20]
  wire  core_io_dmem_wen; // @[Top.scala 77:20]
  wire  core_io_dmem_wready; // @[Top.scala 77:20]
  wire [3:0] core_io_dmem_wstrb; // @[Top.scala 77:20]
  wire [31:0] core_io_dmem_wdata; // @[Top.scala 77:20]
  wire  core_io_cache_iinvalidate; // @[Top.scala 77:20]
  wire  core_io_cache_ibusy; // @[Top.scala 77:20]
  wire [31:0] core_io_cache_raddr; // @[Top.scala 77:20]
  wire [31:0] core_io_cache_rdata; // @[Top.scala 77:20]
  wire  core_io_cache_ren; // @[Top.scala 77:20]
  wire  core_io_cache_rvalid; // @[Top.scala 77:20]
  wire  core_io_cache_rready; // @[Top.scala 77:20]
  wire [31:0] core_io_cache_waddr; // @[Top.scala 77:20]
  wire  core_io_cache_wen; // @[Top.scala 77:20]
  wire  core_io_cache_wready; // @[Top.scala 77:20]
  wire [3:0] core_io_cache_wstrb; // @[Top.scala 77:20]
  wire [31:0] core_io_cache_wdata; // @[Top.scala 77:20]
  wire  core_io_pht_mem_wen; // @[Top.scala 77:20]
  wire [11:0] core_io_pht_mem_raddr; // @[Top.scala 77:20]
  wire [3:0] core_io_pht_mem_rdata; // @[Top.scala 77:20]
  wire [12:0] core_io_pht_mem_waddr; // @[Top.scala 77:20]
  wire [1:0] core_io_pht_mem_wdata; // @[Top.scala 77:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[Top.scala 77:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[Top.scala 77:20]
  wire  core_io_mtimer_mem_ren; // @[Top.scala 77:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[Top.scala 77:20]
  wire  core_io_mtimer_mem_wen; // @[Top.scala 77:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[Top.scala 77:20]
  wire  core_io_intr; // @[Top.scala 77:20]
  wire [31:0] core_io_debug_signal_ex2_reg_pc; // @[Top.scala 77:20]
  wire  core_io_debug_signal_ex2_is_valid_inst; // @[Top.scala 77:20]
  wire  core_io_debug_signal_me_intr; // @[Top.scala 77:20]
  wire  core_io_debug_signal_mt_intr; // @[Top.scala 77:20]
  wire  core_io_debug_signal_trap; // @[Top.scala 77:20]
  wire [47:0] core_io_debug_signal_cycle_counter; // @[Top.scala 77:20]
  wire [31:0] core_io_debug_signal_id_pc; // @[Top.scala 77:20]
  wire [31:0] core_io_debug_signal_id_inst; // @[Top.scala 77:20]
  wire [31:0] core_io_debug_signal_mem3_rdata; // @[Top.scala 77:20]
  wire  core_io_debug_signal_mem3_rvalid; // @[Top.scala 77:20]
  wire [31:0] core_io_debug_signal_rwaddr; // @[Top.scala 77:20]
  wire  core_io_debug_signal_ex2_reg_is_br; // @[Top.scala 77:20]
  wire  core_io_debug_signal_id_reg_is_bp_fail; // @[Top.scala 77:20]
  wire  core_io_debug_signal_if2_reg_bp_taken; // @[Top.scala 77:20]
  wire [2:0] core_io_debug_signal_ic_state; // @[Top.scala 77:20]
  wire  memory_clock; // @[Top.scala 79:22]
  wire  memory_reset; // @[Top.scala 79:22]
  wire  memory_io_imem_en; // @[Top.scala 79:22]
  wire [31:0] memory_io_imem_addr; // @[Top.scala 79:22]
  wire [31:0] memory_io_imem_inst; // @[Top.scala 79:22]
  wire  memory_io_imem_valid; // @[Top.scala 79:22]
  wire  memory_io_cache_iinvalidate; // @[Top.scala 79:22]
  wire  memory_io_cache_ibusy; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_raddr; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_rdata; // @[Top.scala 79:22]
  wire  memory_io_cache_ren; // @[Top.scala 79:22]
  wire  memory_io_cache_rvalid; // @[Top.scala 79:22]
  wire  memory_io_cache_rready; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_waddr; // @[Top.scala 79:22]
  wire  memory_io_cache_wen; // @[Top.scala 79:22]
  wire  memory_io_cache_wready; // @[Top.scala 79:22]
  wire [3:0] memory_io_cache_wstrb; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_wdata; // @[Top.scala 79:22]
  wire  memory_io_dramPort_ren; // @[Top.scala 79:22]
  wire  memory_io_dramPort_wen; // @[Top.scala 79:22]
  wire [27:0] memory_io_dramPort_addr; // @[Top.scala 79:22]
  wire [127:0] memory_io_dramPort_wdata; // @[Top.scala 79:22]
  wire  memory_io_dramPort_init_calib_complete; // @[Top.scala 79:22]
  wire [127:0] memory_io_dramPort_rdata; // @[Top.scala 79:22]
  wire  memory_io_dramPort_rdata_valid; // @[Top.scala 79:22]
  wire  memory_io_dramPort_busy; // @[Top.scala 79:22]
  wire  memory_io_cache_array1_en; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_array1_we; // @[Top.scala 79:22]
  wire [6:0] memory_io_cache_array1_addr; // @[Top.scala 79:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[Top.scala 79:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[Top.scala 79:22]
  wire  memory_io_cache_array2_en; // @[Top.scala 79:22]
  wire [31:0] memory_io_cache_array2_we; // @[Top.scala 79:22]
  wire [6:0] memory_io_cache_array2_addr; // @[Top.scala 79:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[Top.scala 79:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[Top.scala 79:22]
  wire  memory_io_icache_ren; // @[Top.scala 79:22]
  wire  memory_io_icache_wen; // @[Top.scala 79:22]
  wire [9:0] memory_io_icache_raddr; // @[Top.scala 79:22]
  wire [31:0] memory_io_icache_rdata; // @[Top.scala 79:22]
  wire [6:0] memory_io_icache_waddr; // @[Top.scala 79:22]
  wire [255:0] memory_io_icache_wdata; // @[Top.scala 79:22]
  wire  memory_io_icache_valid_ren; // @[Top.scala 79:22]
  wire  memory_io_icache_valid_wen; // @[Top.scala 79:22]
  wire  memory_io_icache_valid_invalidate; // @[Top.scala 79:22]
  wire [5:0] memory_io_icache_valid_addr; // @[Top.scala 79:22]
  wire  memory_io_icache_valid_iaddr; // @[Top.scala 79:22]
  wire [1:0] memory_io_icache_valid_rdata; // @[Top.scala 79:22]
  wire [1:0] memory_io_icache_valid_wdata; // @[Top.scala 79:22]
  wire [2:0] memory_io_icache_state; // @[Top.scala 79:22]
  wire [2:0] memory_io_dram_state; // @[Top.scala 79:22]
  wire  boot_rom_clock; // @[Top.scala 80:24]
  wire  boot_rom_reset; // @[Top.scala 80:24]
  wire  boot_rom_io_imem_en; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_imem_addr; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_imem_inst; // @[Top.scala 80:24]
  wire  boot_rom_io_imem_valid; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_dmem_raddr; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_dmem_rdata; // @[Top.scala 80:24]
  wire  boot_rom_io_dmem_ren; // @[Top.scala 80:24]
  wire  boot_rom_io_dmem_rvalid; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_dmem_waddr; // @[Top.scala 80:24]
  wire  boot_rom_io_dmem_wen; // @[Top.scala 80:24]
  wire [31:0] boot_rom_io_dmem_wdata; // @[Top.scala 80:24]
  wire  sram1_clock; // @[Top.scala 81:21]
  wire  sram1_en; // @[Top.scala 81:21]
  wire [31:0] sram1_we; // @[Top.scala 81:21]
  wire [6:0] sram1_addr; // @[Top.scala 81:21]
  wire [255:0] sram1_wdata; // @[Top.scala 81:21]
  wire [255:0] sram1_rdata; // @[Top.scala 81:21]
  wire  sram2_clock; // @[Top.scala 82:21]
  wire  sram2_en; // @[Top.scala 82:21]
  wire [31:0] sram2_we; // @[Top.scala 82:21]
  wire [6:0] sram2_addr; // @[Top.scala 82:21]
  wire [255:0] sram2_wdata; // @[Top.scala 82:21]
  wire [255:0] sram2_rdata; // @[Top.scala 82:21]
  wire  icache_clock; // @[Top.scala 83:22]
  wire  icache_ren; // @[Top.scala 83:22]
  wire  icache_wen; // @[Top.scala 83:22]
  wire [9:0] icache_raddr; // @[Top.scala 83:22]
  wire [31:0] icache_rdata; // @[Top.scala 83:22]
  wire [6:0] icache_waddr; // @[Top.scala 83:22]
  wire [255:0] icache_wdata; // @[Top.scala 83:22]
  wire  icache_valid_clock; // @[Top.scala 84:28]
  wire  icache_valid_ren; // @[Top.scala 84:28]
  wire  icache_valid_wen; // @[Top.scala 84:28]
  wire  icache_valid_ien; // @[Top.scala 84:28]
  wire  icache_valid_invalidate; // @[Top.scala 84:28]
  wire [5:0] icache_valid_addr; // @[Top.scala 84:28]
  wire  icache_valid_iaddr; // @[Top.scala 84:28]
  wire [1:0] icache_valid_rdata; // @[Top.scala 84:28]
  wire [1:0] icache_valid_wdata; // @[Top.scala 84:28]
  wire [63:0] icache_valid_idata; // @[Top.scala 84:28]
  wire [1:0] icache_valid_dummy_data; // @[Top.scala 84:28]
  wire  pht_mem_clock; // @[Top.scala 85:23]
  wire  pht_mem_ren; // @[Top.scala 85:23]
  wire  pht_mem_wen; // @[Top.scala 85:23]
  wire [11:0] pht_mem_raddr; // @[Top.scala 85:23]
  wire [3:0] pht_mem_rdata; // @[Top.scala 85:23]
  wire [12:0] pht_mem_waddr; // @[Top.scala 85:23]
  wire [1:0] pht_mem_wdata; // @[Top.scala 85:23]
  wire  gpio_clock; // @[Top.scala 86:20]
  wire  gpio_reset; // @[Top.scala 86:20]
  wire  gpio_io_mem_wen; // @[Top.scala 86:20]
  wire [31:0] gpio_io_mem_wdata; // @[Top.scala 86:20]
  wire [31:0] gpio_io_gpio; // @[Top.scala 86:20]
  wire  uart_clock; // @[Top.scala 87:20]
  wire  uart_reset; // @[Top.scala 87:20]
  wire [31:0] uart_io_mem_raddr; // @[Top.scala 87:20]
  wire [31:0] uart_io_mem_rdata; // @[Top.scala 87:20]
  wire  uart_io_mem_ren; // @[Top.scala 87:20]
  wire [31:0] uart_io_mem_waddr; // @[Top.scala 87:20]
  wire  uart_io_mem_wen; // @[Top.scala 87:20]
  wire [31:0] uart_io_mem_wdata; // @[Top.scala 87:20]
  wire  uart_io_intr; // @[Top.scala 87:20]
  wire  uart_io_tx; // @[Top.scala 87:20]
  wire  uart_io_rx; // @[Top.scala 87:20]
  wire  sdc_clock; // @[Top.scala 88:19]
  wire  sdc_reset; // @[Top.scala 88:19]
  wire [31:0] sdc_io_mem_raddr; // @[Top.scala 88:19]
  wire [31:0] sdc_io_mem_rdata; // @[Top.scala 88:19]
  wire  sdc_io_mem_ren; // @[Top.scala 88:19]
  wire [31:0] sdc_io_mem_waddr; // @[Top.scala 88:19]
  wire  sdc_io_mem_wen; // @[Top.scala 88:19]
  wire [31:0] sdc_io_mem_wdata; // @[Top.scala 88:19]
  wire  sdc_io_sdc_port_clk; // @[Top.scala 88:19]
  wire  sdc_io_sdc_port_cmd_wrt; // @[Top.scala 88:19]
  wire  sdc_io_sdc_port_cmd_out; // @[Top.scala 88:19]
  wire  sdc_io_sdc_port_res_in; // @[Top.scala 88:19]
  wire  sdc_io_sdc_port_dat_wrt; // @[Top.scala 88:19]
  wire [3:0] sdc_io_sdc_port_dat_out; // @[Top.scala 88:19]
  wire [3:0] sdc_io_sdc_port_dat_in; // @[Top.scala 88:19]
  wire  sdc_io_sdbuf_ren1; // @[Top.scala 88:19]
  wire  sdc_io_sdbuf_wen1; // @[Top.scala 88:19]
  wire [7:0] sdc_io_sdbuf_addr1; // @[Top.scala 88:19]
  wire [31:0] sdc_io_sdbuf_rdata1; // @[Top.scala 88:19]
  wire [31:0] sdc_io_sdbuf_wdata1; // @[Top.scala 88:19]
  wire  sdc_io_sdbuf_ren2; // @[Top.scala 88:19]
  wire  sdc_io_sdbuf_wen2; // @[Top.scala 88:19]
  wire [7:0] sdc_io_sdbuf_addr2; // @[Top.scala 88:19]
  wire [31:0] sdc_io_sdbuf_rdata2; // @[Top.scala 88:19]
  wire [31:0] sdc_io_sdbuf_wdata2; // @[Top.scala 88:19]
  wire  sdc_io_intr; // @[Top.scala 88:19]
  wire  sdbuf_clock; // @[Top.scala 89:21]
  wire  sdbuf_ren1; // @[Top.scala 89:21]
  wire  sdbuf_wen1; // @[Top.scala 89:21]
  wire [7:0] sdbuf_addr1; // @[Top.scala 89:21]
  wire [31:0] sdbuf_wdata1; // @[Top.scala 89:21]
  wire [31:0] sdbuf_rdata1; // @[Top.scala 89:21]
  wire  sdbuf_ren2; // @[Top.scala 89:21]
  wire  sdbuf_wen2; // @[Top.scala 89:21]
  wire [7:0] sdbuf_addr2; // @[Top.scala 89:21]
  wire [31:0] sdbuf_wdata2; // @[Top.scala 89:21]
  wire [31:0] sdbuf_rdata2; // @[Top.scala 89:21]
  wire  intr_clock; // @[Top.scala 90:20]
  wire  intr_reset; // @[Top.scala 90:20]
  wire [31:0] intr_io_mem_raddr; // @[Top.scala 90:20]
  wire [31:0] intr_io_mem_rdata; // @[Top.scala 90:20]
  wire  intr_io_mem_ren; // @[Top.scala 90:20]
  wire  intr_io_mem_wen; // @[Top.scala 90:20]
  wire [31:0] intr_io_mem_wdata; // @[Top.scala 90:20]
  wire [1:0] intr_io_intr_periferal; // @[Top.scala 90:20]
  wire  intr_io_intr_cpu; // @[Top.scala 90:20]
  wire [31:0] config__io_mem_raddr; // @[Top.scala 91:22]
  wire [31:0] config__io_mem_rdata; // @[Top.scala 91:22]
  wire [31:0] dmem_decoder_io_initiator_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_initiator_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_initiator_ren; // @[Top.scala 93:28]
  wire  dmem_decoder_io_initiator_rvalid; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_initiator_waddr; // @[Top.scala 93:28]
  wire  dmem_decoder_io_initiator_wen; // @[Top.scala 93:28]
  wire  dmem_decoder_io_initiator_wready; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_initiator_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_0_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_0_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_0_ren; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_0_rvalid; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_0_waddr; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_0_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_0_wdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_1_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_1_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_2_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_2_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_2_ren; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_2_waddr; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_2_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_2_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_3_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_3_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_3_ren; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_3_waddr; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_3_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_3_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_4_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_4_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_4_ren; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_4_waddr; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_4_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_4_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_5_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_5_rdata; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_5_ren; // @[Top.scala 93:28]
  wire  dmem_decoder_io_targets_5_wen; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_5_wdata; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_6_raddr; // @[Top.scala 93:28]
  wire [31:0] dmem_decoder_io_targets_6_rdata; // @[Top.scala 93:28]
  wire  imem_decoder_clock; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_initiator_addr; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_initiator_inst; // @[Top.scala 112:28]
  wire  imem_decoder_io_initiator_valid; // @[Top.scala 112:28]
  wire  imem_decoder_io_targets_0_en; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_targets_0_addr; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_targets_0_inst; // @[Top.scala 112:28]
  wire  imem_decoder_io_targets_0_valid; // @[Top.scala 112:28]
  wire  imem_decoder_io_targets_1_en; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_targets_1_addr; // @[Top.scala 112:28]
  wire [31:0] imem_decoder_io_targets_1_inst; // @[Top.scala 112:28]
  wire  imem_decoder_io_targets_1_valid; // @[Top.scala 112:28]
  Core core ( // @[Top.scala 77:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
    .io_imem_valid(core_io_imem_valid),
    .io_dmem_raddr(core_io_dmem_raddr),
    .io_dmem_rdata(core_io_dmem_rdata),
    .io_dmem_ren(core_io_dmem_ren),
    .io_dmem_rvalid(core_io_dmem_rvalid),
    .io_dmem_waddr(core_io_dmem_waddr),
    .io_dmem_wen(core_io_dmem_wen),
    .io_dmem_wready(core_io_dmem_wready),
    .io_dmem_wstrb(core_io_dmem_wstrb),
    .io_dmem_wdata(core_io_dmem_wdata),
    .io_cache_iinvalidate(core_io_cache_iinvalidate),
    .io_cache_ibusy(core_io_cache_ibusy),
    .io_cache_raddr(core_io_cache_raddr),
    .io_cache_rdata(core_io_cache_rdata),
    .io_cache_ren(core_io_cache_ren),
    .io_cache_rvalid(core_io_cache_rvalid),
    .io_cache_rready(core_io_cache_rready),
    .io_cache_waddr(core_io_cache_waddr),
    .io_cache_wen(core_io_cache_wen),
    .io_cache_wready(core_io_cache_wready),
    .io_cache_wstrb(core_io_cache_wstrb),
    .io_cache_wdata(core_io_cache_wdata),
    .io_pht_mem_wen(core_io_pht_mem_wen),
    .io_pht_mem_raddr(core_io_pht_mem_raddr),
    .io_pht_mem_rdata(core_io_pht_mem_rdata),
    .io_pht_mem_waddr(core_io_pht_mem_waddr),
    .io_pht_mem_wdata(core_io_pht_mem_wdata),
    .io_mtimer_mem_raddr(core_io_mtimer_mem_raddr),
    .io_mtimer_mem_rdata(core_io_mtimer_mem_rdata),
    .io_mtimer_mem_ren(core_io_mtimer_mem_ren),
    .io_mtimer_mem_waddr(core_io_mtimer_mem_waddr),
    .io_mtimer_mem_wen(core_io_mtimer_mem_wen),
    .io_mtimer_mem_wdata(core_io_mtimer_mem_wdata),
    .io_intr(core_io_intr),
    .io_debug_signal_ex2_reg_pc(core_io_debug_signal_ex2_reg_pc),
    .io_debug_signal_ex2_is_valid_inst(core_io_debug_signal_ex2_is_valid_inst),
    .io_debug_signal_me_intr(core_io_debug_signal_me_intr),
    .io_debug_signal_mt_intr(core_io_debug_signal_mt_intr),
    .io_debug_signal_trap(core_io_debug_signal_trap),
    .io_debug_signal_cycle_counter(core_io_debug_signal_cycle_counter),
    .io_debug_signal_id_pc(core_io_debug_signal_id_pc),
    .io_debug_signal_id_inst(core_io_debug_signal_id_inst),
    .io_debug_signal_mem3_rdata(core_io_debug_signal_mem3_rdata),
    .io_debug_signal_mem3_rvalid(core_io_debug_signal_mem3_rvalid),
    .io_debug_signal_rwaddr(core_io_debug_signal_rwaddr),
    .io_debug_signal_ex2_reg_is_br(core_io_debug_signal_ex2_reg_is_br),
    .io_debug_signal_id_reg_is_bp_fail(core_io_debug_signal_id_reg_is_bp_fail),
    .io_debug_signal_if2_reg_bp_taken(core_io_debug_signal_if2_reg_bp_taken),
    .io_debug_signal_ic_state(core_io_debug_signal_ic_state)
  );
  Memory memory ( // @[Top.scala 79:22]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_imem_en(memory_io_imem_en),
    .io_imem_addr(memory_io_imem_addr),
    .io_imem_inst(memory_io_imem_inst),
    .io_imem_valid(memory_io_imem_valid),
    .io_cache_iinvalidate(memory_io_cache_iinvalidate),
    .io_cache_ibusy(memory_io_cache_ibusy),
    .io_cache_raddr(memory_io_cache_raddr),
    .io_cache_rdata(memory_io_cache_rdata),
    .io_cache_ren(memory_io_cache_ren),
    .io_cache_rvalid(memory_io_cache_rvalid),
    .io_cache_rready(memory_io_cache_rready),
    .io_cache_waddr(memory_io_cache_waddr),
    .io_cache_wen(memory_io_cache_wen),
    .io_cache_wready(memory_io_cache_wready),
    .io_cache_wstrb(memory_io_cache_wstrb),
    .io_cache_wdata(memory_io_cache_wdata),
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
    .io_icache_valid_wdata(memory_io_icache_valid_wdata),
    .io_icache_state(memory_io_icache_state),
    .io_dram_state(memory_io_dram_state)
  );
  BootRom boot_rom ( // @[Top.scala 80:24]
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
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram1 ( // @[Top.scala 81:21]
    .clock(sram1_clock),
    .en(sram1_en),
    .we(sram1_we),
    .addr(sram1_addr),
    .wdata(sram1_wdata),
    .rdata(sram1_rdata)
  );
  SRAM #(.NUM_COL(32), .COL_WIDTH(8), .ADDR_WIDTH(7), .DATA_WIDTH(256)) sram2 ( // @[Top.scala 82:21]
    .clock(sram2_clock),
    .en(sram2_en),
    .we(sram2_we),
    .addr(sram2_addr),
    .wdata(sram2_wdata),
    .rdata(sram2_rdata)
  );
  ICache #(.RDATA_WIDTH_BITS(5), .RADDR_WIDTH(10), .WDATA_WIDTH_BITS(8), .WADDR_WIDTH(7)) icache ( // @[Top.scala 83:22]
    .clock(icache_clock),
    .ren(icache_ren),
    .wen(icache_wen),
    .raddr(icache_raddr),
    .rdata(icache_rdata),
    .waddr(icache_waddr),
    .wdata(icache_wdata)
  );
  ICacheValid #(.DATA_WIDTH_BITS(1), .ADDR_WIDTH(6), .INVALIDATE_WIDTH_BITS(6), .INVALIDATE_ADDR_WIDTH(1)) icache_valid
     ( // @[Top.scala 84:28]
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
  PHTMem #(.RDATA_WIDTH_BITS(2), .RADDR_WIDTH(12), .WDATA_WIDTH_BITS(1), .WADDR_WIDTH(13)) pht_mem ( // @[Top.scala 85:23]
    .clock(pht_mem_clock),
    .ren(pht_mem_ren),
    .wen(pht_mem_wen),
    .raddr(pht_mem_raddr),
    .rdata(pht_mem_rdata),
    .waddr(pht_mem_waddr),
    .wdata(pht_mem_wdata)
  );
  Gpio gpio ( // @[Top.scala 86:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[Top.scala 87:20]
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
  Sdc sdc ( // @[Top.scala 88:19]
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
  SdBuf #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) sdbuf ( // @[Top.scala 89:21]
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
  InterruptController intr ( // @[Top.scala 90:20]
    .clock(intr_clock),
    .reset(intr_reset),
    .io_mem_raddr(intr_io_mem_raddr),
    .io_mem_rdata(intr_io_mem_rdata),
    .io_mem_ren(intr_io_mem_ren),
    .io_mem_wen(intr_io_mem_wen),
    .io_mem_wdata(intr_io_mem_wdata),
    .io_intr_periferal(intr_io_intr_periferal),
    .io_intr_cpu(intr_io_intr_cpu)
  );
  Config config_ ( // @[Top.scala 91:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder dmem_decoder ( // @[Top.scala 93:28]
    .io_initiator_raddr(dmem_decoder_io_initiator_raddr),
    .io_initiator_rdata(dmem_decoder_io_initiator_rdata),
    .io_initiator_ren(dmem_decoder_io_initiator_ren),
    .io_initiator_rvalid(dmem_decoder_io_initiator_rvalid),
    .io_initiator_waddr(dmem_decoder_io_initiator_waddr),
    .io_initiator_wen(dmem_decoder_io_initiator_wen),
    .io_initiator_wready(dmem_decoder_io_initiator_wready),
    .io_initiator_wdata(dmem_decoder_io_initiator_wdata),
    .io_targets_0_raddr(dmem_decoder_io_targets_0_raddr),
    .io_targets_0_rdata(dmem_decoder_io_targets_0_rdata),
    .io_targets_0_ren(dmem_decoder_io_targets_0_ren),
    .io_targets_0_rvalid(dmem_decoder_io_targets_0_rvalid),
    .io_targets_0_waddr(dmem_decoder_io_targets_0_waddr),
    .io_targets_0_wen(dmem_decoder_io_targets_0_wen),
    .io_targets_0_wdata(dmem_decoder_io_targets_0_wdata),
    .io_targets_1_wen(dmem_decoder_io_targets_1_wen),
    .io_targets_1_wdata(dmem_decoder_io_targets_1_wdata),
    .io_targets_2_raddr(dmem_decoder_io_targets_2_raddr),
    .io_targets_2_rdata(dmem_decoder_io_targets_2_rdata),
    .io_targets_2_ren(dmem_decoder_io_targets_2_ren),
    .io_targets_2_waddr(dmem_decoder_io_targets_2_waddr),
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
    .io_targets_4_waddr(dmem_decoder_io_targets_4_waddr),
    .io_targets_4_wen(dmem_decoder_io_targets_4_wen),
    .io_targets_4_wdata(dmem_decoder_io_targets_4_wdata),
    .io_targets_5_raddr(dmem_decoder_io_targets_5_raddr),
    .io_targets_5_rdata(dmem_decoder_io_targets_5_rdata),
    .io_targets_5_ren(dmem_decoder_io_targets_5_ren),
    .io_targets_5_wen(dmem_decoder_io_targets_5_wen),
    .io_targets_5_wdata(dmem_decoder_io_targets_5_wdata),
    .io_targets_6_raddr(dmem_decoder_io_targets_6_raddr),
    .io_targets_6_rdata(dmem_decoder_io_targets_6_rdata)
  );
  IMemDecoder imem_decoder ( // @[Top.scala 112:28]
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
  assign io_dram_ren = memory_io_dramPort_ren; // @[Top.scala 125:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[Top.scala 125:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[Top.scala 125:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[Top.scala 125:11]
  assign io_dram_wmask = 16'h0; // @[Top.scala 125:11]
  assign io_dram_user_busy = 1'h0; // @[Top.scala 125:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[Top.scala 202:11]
  assign io_uart_tx = uart_io_tx; // @[Top.scala 203:14]
  assign io_sdc_port_clk = sdc_io_sdc_port_clk; // @[Top.scala 205:15]
  assign io_sdc_port_cmd_wrt = sdc_io_sdc_port_cmd_wrt; // @[Top.scala 205:15]
  assign io_sdc_port_cmd_out = sdc_io_sdc_port_cmd_out; // @[Top.scala 205:15]
  assign io_sdc_port_dat_wrt = sdc_io_sdc_port_dat_wrt; // @[Top.scala 205:15]
  assign io_sdc_port_dat_out = sdc_io_sdc_port_dat_out; // @[Top.scala 205:15]
  assign io_debugSignals_core_ex2_reg_pc = core_io_debug_signal_ex2_reg_pc; // @[Top.scala 168:24]
  assign io_debugSignals_core_ex2_is_valid_inst = core_io_debug_signal_ex2_is_valid_inst; // @[Top.scala 168:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[Top.scala 168:24]
  assign io_debugSignals_core_mt_intr = core_io_debug_signal_mt_intr; // @[Top.scala 168:24]
  assign io_debugSignals_core_trap = core_io_debug_signal_trap; // @[Top.scala 168:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[Top.scala 168:24]
  assign io_debugSignals_core_id_pc = core_io_debug_signal_id_pc; // @[Top.scala 168:24]
  assign io_debugSignals_core_id_inst = core_io_debug_signal_id_inst; // @[Top.scala 168:24]
  assign io_debugSignals_core_mem3_rdata = core_io_debug_signal_mem3_rdata; // @[Top.scala 168:24]
  assign io_debugSignals_core_mem3_rvalid = core_io_debug_signal_mem3_rvalid; // @[Top.scala 168:24]
  assign io_debugSignals_core_rwaddr = core_io_debug_signal_rwaddr; // @[Top.scala 168:24]
  assign io_debugSignals_core_ex2_reg_is_br = core_io_debug_signal_ex2_reg_is_br; // @[Top.scala 168:24]
  assign io_debugSignals_core_id_reg_is_bp_fail = core_io_debug_signal_id_reg_is_bp_fail; // @[Top.scala 168:24]
  assign io_debugSignals_core_if2_reg_bp_taken = core_io_debug_signal_if2_reg_bp_taken; // @[Top.scala 168:24]
  assign io_debugSignals_core_ic_state = core_io_debug_signal_ic_state; // @[Top.scala 168:24]
  assign io_debugSignals_ren = core_io_dmem_ren | core_io_cache_ren; // @[Top.scala 171:46]
  assign io_debugSignals_wen = core_io_dmem_wen | core_io_cache_wen; // @[Top.scala 175:46]
  assign io_debugSignals_wready = memory_io_cache_wready; // @[Top.scala 176:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[Top.scala 177:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[Top.scala 174:26]
  assign io_debugSignals_mem_icache_state = memory_io_icache_state; // @[Top.scala 184:36]
  assign io_debugSignals_mem_dram_state = memory_io_dram_state; // @[Top.scala 185:34]
  assign io_debugSignals_mem_imem_addr = core_io_imem_addr[15:0]; // @[Top.scala 186:53]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = imem_decoder_io_initiator_inst; // @[Top.scala 119:16]
  assign core_io_imem_valid = imem_decoder_io_initiator_valid; // @[Top.scala 119:16]
  assign core_io_dmem_rdata = dmem_decoder_io_initiator_rdata; // @[Top.scala 120:16]
  assign core_io_dmem_rvalid = dmem_decoder_io_initiator_rvalid; // @[Top.scala 120:16]
  assign core_io_dmem_wready = dmem_decoder_io_initiator_wready; // @[Top.scala 120:16]
  assign core_io_cache_ibusy = memory_io_cache_ibusy; // @[Top.scala 122:17]
  assign core_io_cache_rdata = memory_io_cache_rdata; // @[Top.scala 122:17]
  assign core_io_cache_rvalid = memory_io_cache_rvalid; // @[Top.scala 122:17]
  assign core_io_cache_rready = memory_io_cache_rready; // @[Top.scala 122:17]
  assign core_io_cache_wready = memory_io_cache_wready; // @[Top.scala 122:17]
  assign core_io_pht_mem_rdata = pht_mem_rdata; // @[Top.scala 163:25]
  assign core_io_mtimer_mem_raddr = dmem_decoder_io_targets_3_raddr; // @[Top.scala 107:30]
  assign core_io_mtimer_mem_ren = dmem_decoder_io_targets_3_ren; // @[Top.scala 107:30]
  assign core_io_mtimer_mem_waddr = dmem_decoder_io_targets_3_waddr; // @[Top.scala 107:30]
  assign core_io_mtimer_mem_wen = dmem_decoder_io_targets_3_wen; // @[Top.scala 107:30]
  assign core_io_mtimer_mem_wdata = dmem_decoder_io_targets_3_wdata; // @[Top.scala 107:30]
  assign core_io_intr = intr_io_intr_cpu; // @[Top.scala 208:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_en = imem_decoder_io_targets_1_en; // @[Top.scala 117:30]
  assign memory_io_imem_addr = imem_decoder_io_targets_1_addr; // @[Top.scala 117:30]
  assign memory_io_cache_iinvalidate = core_io_cache_iinvalidate; // @[Top.scala 122:17]
  assign memory_io_cache_raddr = core_io_cache_raddr; // @[Top.scala 122:17]
  assign memory_io_cache_ren = core_io_cache_ren; // @[Top.scala 122:17]
  assign memory_io_cache_waddr = core_io_cache_waddr; // @[Top.scala 122:17]
  assign memory_io_cache_wen = core_io_cache_wen; // @[Top.scala 122:17]
  assign memory_io_cache_wstrb = core_io_cache_wstrb; // @[Top.scala 122:17]
  assign memory_io_cache_wdata = core_io_cache_wdata; // @[Top.scala 122:17]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[Top.scala 125:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[Top.scala 125:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[Top.scala 125:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[Top.scala 125:11]
  assign memory_io_cache_array1_rdata = sram1_rdata; // @[Top.scala 132:32]
  assign memory_io_cache_array2_rdata = sram2_rdata; // @[Top.scala 138:32]
  assign memory_io_icache_rdata = icache_rdata; // @[Top.scala 144:26]
  assign memory_io_icache_valid_rdata = icache_valid_rdata; // @[Top.scala 154:32]
  assign boot_rom_clock = clock;
  assign boot_rom_reset = reset;
  assign boot_rom_io_imem_en = imem_decoder_io_targets_0_en; // @[Top.scala 116:30]
  assign boot_rom_io_imem_addr = imem_decoder_io_targets_0_addr; // @[Top.scala 116:30]
  assign boot_rom_io_dmem_raddr = dmem_decoder_io_targets_0_raddr; // @[Top.scala 103:30]
  assign boot_rom_io_dmem_ren = dmem_decoder_io_targets_0_ren; // @[Top.scala 103:30]
  assign boot_rom_io_dmem_waddr = dmem_decoder_io_targets_0_waddr; // @[Top.scala 103:30]
  assign boot_rom_io_dmem_wen = dmem_decoder_io_targets_0_wen; // @[Top.scala 103:30]
  assign boot_rom_io_dmem_wdata = dmem_decoder_io_targets_0_wdata; // @[Top.scala 103:30]
  assign sram1_clock = clock; // @[Top.scala 127:18]
  assign sram1_en = memory_io_cache_array1_en; // @[Top.scala 128:15]
  assign sram1_we = memory_io_cache_array1_we; // @[Top.scala 129:15]
  assign sram1_addr = memory_io_cache_array1_addr; // @[Top.scala 130:17]
  assign sram1_wdata = memory_io_cache_array1_wdata; // @[Top.scala 131:18]
  assign sram2_clock = clock; // @[Top.scala 133:18]
  assign sram2_en = memory_io_cache_array2_en; // @[Top.scala 134:15]
  assign sram2_we = memory_io_cache_array2_we; // @[Top.scala 135:15]
  assign sram2_addr = memory_io_cache_array2_addr; // @[Top.scala 136:17]
  assign sram2_wdata = memory_io_cache_array2_wdata; // @[Top.scala 137:18]
  assign icache_clock = clock; // @[Top.scala 140:19]
  assign icache_ren = memory_io_icache_ren; // @[Top.scala 141:17]
  assign icache_wen = memory_io_icache_wen; // @[Top.scala 142:17]
  assign icache_raddr = memory_io_icache_raddr; // @[Top.scala 143:19]
  assign icache_waddr = memory_io_icache_waddr; // @[Top.scala 145:19]
  assign icache_wdata = memory_io_icache_wdata; // @[Top.scala 146:19]
  assign icache_valid_clock = clock; // @[Top.scala 148:25]
  assign icache_valid_ren = memory_io_icache_valid_ren; // @[Top.scala 149:23]
  assign icache_valid_wen = memory_io_icache_valid_wen; // @[Top.scala 150:23]
  assign icache_valid_ien = memory_io_icache_valid_invalidate; // @[Top.scala 157:23]
  assign icache_valid_invalidate = memory_io_icache_valid_invalidate; // @[Top.scala 151:30]
  assign icache_valid_addr = memory_io_icache_valid_addr; // @[Top.scala 152:24]
  assign icache_valid_iaddr = memory_io_icache_valid_iaddr; // @[Top.scala 153:25]
  assign icache_valid_wdata = memory_io_icache_valid_wdata; // @[Top.scala 155:25]
  assign icache_valid_idata = 64'h0; // @[Top.scala 156:25]
  assign pht_mem_clock = clock; // @[Top.scala 159:20]
  assign pht_mem_ren = 1'h1; // @[Top.scala 160:20]
  assign pht_mem_wen = core_io_pht_mem_wen; // @[Top.scala 161:20]
  assign pht_mem_raddr = core_io_pht_mem_raddr; // @[Top.scala 162:20]
  assign pht_mem_waddr = core_io_pht_mem_waddr; // @[Top.scala 164:20]
  assign pht_mem_wdata = core_io_pht_mem_wdata; // @[Top.scala 165:20]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = dmem_decoder_io_targets_1_wen; // @[Top.scala 105:30]
  assign gpio_io_mem_wdata = dmem_decoder_io_targets_1_wdata; // @[Top.scala 105:30]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = dmem_decoder_io_targets_2_raddr; // @[Top.scala 106:30]
  assign uart_io_mem_ren = dmem_decoder_io_targets_2_ren; // @[Top.scala 106:30]
  assign uart_io_mem_waddr = dmem_decoder_io_targets_2_waddr; // @[Top.scala 106:30]
  assign uart_io_mem_wen = dmem_decoder_io_targets_2_wen; // @[Top.scala 106:30]
  assign uart_io_mem_wdata = dmem_decoder_io_targets_2_wdata; // @[Top.scala 106:30]
  assign uart_io_rx = io_uart_rx; // @[Top.scala 204:14]
  assign sdc_clock = clock;
  assign sdc_reset = reset;
  assign sdc_io_mem_raddr = dmem_decoder_io_targets_4_raddr; // @[Top.scala 108:30]
  assign sdc_io_mem_ren = dmem_decoder_io_targets_4_ren; // @[Top.scala 108:30]
  assign sdc_io_mem_waddr = dmem_decoder_io_targets_4_waddr; // @[Top.scala 108:30]
  assign sdc_io_mem_wen = dmem_decoder_io_targets_4_wen; // @[Top.scala 108:30]
  assign sdc_io_mem_wdata = dmem_decoder_io_targets_4_wdata; // @[Top.scala 108:30]
  assign sdc_io_sdc_port_res_in = io_sdc_port_res_in; // @[Top.scala 205:15]
  assign sdc_io_sdc_port_dat_in = io_sdc_port_dat_in; // @[Top.scala 205:15]
  assign sdc_io_sdbuf_rdata1 = sdbuf_rdata1; // @[Top.scala 215:23]
  assign sdc_io_sdbuf_rdata2 = sdbuf_rdata2; // @[Top.scala 220:23]
  assign sdbuf_clock = clock; // @[Top.scala 210:19]
  assign sdbuf_ren1 = sdc_io_sdbuf_ren1; // @[Top.scala 211:19]
  assign sdbuf_wen1 = sdc_io_sdbuf_wen1; // @[Top.scala 212:19]
  assign sdbuf_addr1 = sdc_io_sdbuf_addr1; // @[Top.scala 213:19]
  assign sdbuf_wdata1 = sdc_io_sdbuf_wdata1; // @[Top.scala 214:19]
  assign sdbuf_ren2 = sdc_io_sdbuf_ren2; // @[Top.scala 216:19]
  assign sdbuf_wen2 = sdc_io_sdbuf_wen2; // @[Top.scala 217:19]
  assign sdbuf_addr2 = sdc_io_sdbuf_addr2; // @[Top.scala 218:19]
  assign sdbuf_wdata2 = sdc_io_sdbuf_wdata2; // @[Top.scala 219:19]
  assign intr_clock = clock;
  assign intr_reset = reset;
  assign intr_io_mem_raddr = dmem_decoder_io_targets_5_raddr; // @[Top.scala 109:30]
  assign intr_io_mem_ren = dmem_decoder_io_targets_5_ren; // @[Top.scala 109:30]
  assign intr_io_mem_wen = dmem_decoder_io_targets_5_wen; // @[Top.scala 109:30]
  assign intr_io_mem_wdata = dmem_decoder_io_targets_5_wdata; // @[Top.scala 109:30]
  assign intr_io_intr_periferal = {sdc_io_intr,uart_io_intr}; // @[Cat.scala 33:92]
  assign config__io_mem_raddr = dmem_decoder_io_targets_6_raddr; // @[Top.scala 110:30]
  assign dmem_decoder_io_initiator_raddr = core_io_dmem_raddr; // @[Top.scala 120:16]
  assign dmem_decoder_io_initiator_ren = core_io_dmem_ren; // @[Top.scala 120:16]
  assign dmem_decoder_io_initiator_waddr = core_io_dmem_waddr; // @[Top.scala 120:16]
  assign dmem_decoder_io_initiator_wen = core_io_dmem_wen; // @[Top.scala 120:16]
  assign dmem_decoder_io_initiator_wdata = core_io_dmem_wdata; // @[Top.scala 120:16]
  assign dmem_decoder_io_targets_0_rdata = boot_rom_io_dmem_rdata; // @[Top.scala 103:30]
  assign dmem_decoder_io_targets_0_rvalid = boot_rom_io_dmem_rvalid; // @[Top.scala 103:30]
  assign dmem_decoder_io_targets_2_rdata = uart_io_mem_rdata; // @[Top.scala 106:30]
  assign dmem_decoder_io_targets_3_rdata = core_io_mtimer_mem_rdata; // @[Top.scala 107:30]
  assign dmem_decoder_io_targets_4_rdata = sdc_io_mem_rdata; // @[Top.scala 108:30]
  assign dmem_decoder_io_targets_5_rdata = intr_io_mem_rdata; // @[Top.scala 109:30]
  assign dmem_decoder_io_targets_6_rdata = config__io_mem_rdata; // @[Top.scala 110:30]
  assign imem_decoder_clock = clock;
  assign imem_decoder_io_initiator_addr = core_io_imem_addr; // @[Top.scala 119:16]
  assign imem_decoder_io_targets_0_inst = boot_rom_io_imem_inst; // @[Top.scala 116:30]
  assign imem_decoder_io_targets_0_valid = boot_rom_io_imem_valid; // @[Top.scala 116:30]
  assign imem_decoder_io_targets_1_inst = memory_io_imem_inst; // @[Top.scala 117:30]
  assign imem_decoder_io_targets_1_valid = memory_io_imem_valid; // @[Top.scala 117:30]
endmodule
