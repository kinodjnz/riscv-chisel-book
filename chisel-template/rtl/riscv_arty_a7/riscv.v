module LongCounter(
  input         clock,
  input         reset,
  output [63:0] io_value // @[src/main/scala/fpga/Core.scala 12:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] counter; // @[src/main/scala/fpga/Core.scala 27:24]
  wire [63:0] _counter_T_1 = counter + 64'h1; // @[src/main/scala/fpga/Core.scala 28:22]
  assign io_value = counter; // @[src/main/scala/fpga/Core.scala 29:12]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/Core.scala 27:24]
      counter <= 64'h0; // @[src/main/scala/fpga/Core.scala 27:24]
    end else begin
      counter <= _counter_T_1; // @[src/main/scala/fpga/Core.scala 28:11]
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
  input  [31:0] io_mem_raddr, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  output [31:0] io_mem_rdata, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  input  [31:0] io_mem_waddr, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  input         io_mem_wen, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  input  [31:0] io_mem_wdata, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  output        io_intr, // @[src/main/scala/fpga/MachineTimer.scala 8:14]
  output [63:0] io_mtime // @[src/main/scala/fpga/MachineTimer.scala 8:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] mtime; // @[src/main/scala/fpga/MachineTimer.scala 15:22]
  reg [63:0] mtimecmp; // @[src/main/scala/fpga/MachineTimer.scala 16:25]
  reg  intr; // @[src/main/scala/fpga/MachineTimer.scala 17:21]
  reg [31:0] rdata; // @[src/main/scala/fpga/MachineTimer.scala 18:22]
  wire [63:0] _mtime_T_1 = mtime + 64'h1; // @[src/main/scala/fpga/MachineTimer.scala 20:18]
  wire [31:0] _GEN_0 = 2'h3 == io_mem_raddr[3:2] ? mtimecmp[63:32] : rdata; // @[src/main/scala/fpga/MachineTimer.scala 32:33 43:15 18:22]
  wire [63:0] _mtime_T_3 = {mtime[63:32],io_mem_wdata}; // @[src/main/scala/fpga/MachineTimer.scala 51:21]
  wire [63:0] _mtime_T_5 = {io_mem_wdata,mtime[31:0]}; // @[src/main/scala/fpga/MachineTimer.scala 54:21]
  wire [63:0] _mtimecmp_T_1 = {mtimecmp[63:32],io_mem_wdata}; // @[src/main/scala/fpga/MachineTimer.scala 57:24]
  wire [63:0] _mtimecmp_T_3 = {io_mem_wdata,mtimecmp[31:0]}; // @[src/main/scala/fpga/MachineTimer.scala 60:24]
  wire [63:0] _GEN_4 = 2'h3 == io_mem_waddr[3:2] ? _mtimecmp_T_3 : mtimecmp; // @[src/main/scala/fpga/MachineTimer.scala 49:33 60:18 16:25]
  wire [63:0] _GEN_5 = 2'h2 == io_mem_waddr[3:2] ? _mtimecmp_T_1 : _GEN_4; // @[src/main/scala/fpga/MachineTimer.scala 49:33 57:18]
  assign io_mem_rdata = rdata; // @[src/main/scala/fpga/MachineTimer.scala 26:16]
  assign io_intr = intr; // @[src/main/scala/fpga/MachineTimer.scala 22:11]
  assign io_mtime = mtime; // @[src/main/scala/fpga/MachineTimer.scala 23:12]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/MachineTimer.scala 15:22]
      mtime <= 64'h0; // @[src/main/scala/fpga/MachineTimer.scala 15:22]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/MachineTimer.scala 48:21]
      if (2'h0 == io_mem_waddr[3:2]) begin // @[src/main/scala/fpga/MachineTimer.scala 49:33]
        mtime <= _mtime_T_3; // @[src/main/scala/fpga/MachineTimer.scala 51:15]
      end else if (2'h1 == io_mem_waddr[3:2]) begin // @[src/main/scala/fpga/MachineTimer.scala 49:33]
        mtime <= _mtime_T_5; // @[src/main/scala/fpga/MachineTimer.scala 54:15]
      end else begin
        mtime <= _mtime_T_1; // @[src/main/scala/fpga/MachineTimer.scala 20:9]
      end
    end else begin
      mtime <= _mtime_T_1; // @[src/main/scala/fpga/MachineTimer.scala 20:9]
    end
    if (reset) begin // @[src/main/scala/fpga/MachineTimer.scala 16:25]
      mtimecmp <= 64'hffffffff; // @[src/main/scala/fpga/MachineTimer.scala 16:25]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/MachineTimer.scala 48:21]
      if (!(2'h0 == io_mem_waddr[3:2])) begin // @[src/main/scala/fpga/MachineTimer.scala 49:33]
        if (!(2'h1 == io_mem_waddr[3:2])) begin // @[src/main/scala/fpga/MachineTimer.scala 49:33]
          mtimecmp <= _GEN_5;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/MachineTimer.scala 17:21]
      intr <= 1'h0; // @[src/main/scala/fpga/MachineTimer.scala 17:21]
    end else begin
      intr <= mtime >= mtimecmp; // @[src/main/scala/fpga/MachineTimer.scala 21:8]
    end
    if (reset) begin // @[src/main/scala/fpga/MachineTimer.scala 18:22]
      rdata <= 32'h0; // @[src/main/scala/fpga/MachineTimer.scala 18:22]
    end else if (2'h0 == io_mem_raddr[3:2]) begin // @[src/main/scala/fpga/MachineTimer.scala 32:33]
      rdata <= mtime[31:0]; // @[src/main/scala/fpga/MachineTimer.scala 34:15]
    end else if (2'h1 == io_mem_raddr[3:2]) begin // @[src/main/scala/fpga/MachineTimer.scala 32:33]
      rdata <= mtime[63:32]; // @[src/main/scala/fpga/MachineTimer.scala 37:15]
    end else if (2'h2 == io_mem_raddr[3:2]) begin // @[src/main/scala/fpga/MachineTimer.scala 32:33]
      rdata <= mtimecmp[31:0]; // @[src/main/scala/fpga/MachineTimer.scala 40:15]
    end else begin
      rdata <= _GEN_0;
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
  _RAND_3 = {1{`RANDOM}};
  rdata = _RAND_3[31:0];
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
  input  [30:0] io_lu_pc, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  output        io_lu_matches0, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  output [30:0] io_lu_taken_pc0, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  output        io_lu_matches1, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  output [30:0] io_lu_taken_pc1, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  input         io_up_en, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  input  [30:0] io_up_pc, // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
  input  [30:0] io_up_taken_pc // @[src/main/scala/fpga/BranchPredictor.scala 53:14]
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
  reg [17:0] btb0_tag [0:255]; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_tag_reg_entry0_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [7:0] btb0_tag_reg_entry0_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [17:0] btb0_tag_reg_entry0_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [17:0] btb0_tag_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [7:0] btb0_tag_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_tag_MPORT_mask; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_tag_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  reg [30:0] btb0_taken_pc [0:255]; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_reg_entry0_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [7:0] btb0_taken_pc_reg_entry0_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [30:0] btb0_taken_pc_reg_entry0_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [30:0] btb0_taken_pc_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire [7:0] btb0_taken_pc_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_MPORT_mask; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  wire  btb0_taken_pc_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  reg [17:0] btb1_tag [0:255]; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_tag_reg_entry1_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [7:0] btb1_tag_reg_entry1_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [17:0] btb1_tag_reg_entry1_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [17:0] btb1_tag_MPORT_1_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [7:0] btb1_tag_MPORT_1_addr; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_tag_MPORT_1_mask; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_tag_MPORT_1_en; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  reg [30:0] btb1_taken_pc [0:255]; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_reg_entry1_MPORT_en; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [7:0] btb1_taken_pc_reg_entry1_MPORT_addr; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [30:0] btb1_taken_pc_reg_entry1_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [30:0] btb1_taken_pc_MPORT_1_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire [7:0] btb1_taken_pc_MPORT_1_addr; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_MPORT_1_mask; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  wire  btb1_taken_pc_MPORT_1_en; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  reg [17:0] reg_entry0_tag; // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
  reg [30:0] reg_entry0_taken_pc; // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
  reg [17:0] reg_entry1_tag; // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
  reg [30:0] reg_entry1_taken_pc; // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
  wire [17:0] lu_pc_tag = io_lu_pc[26:9]; // @[src/main/scala/fpga/BranchPredictor.scala 64:62]
  reg [17:0] reg_lu_pc_tag; // @[src/main/scala/fpga/BranchPredictor.scala 65:30]
  wire [17:0] up_pc_tag = io_up_pc[26:9]; // @[src/main/scala/fpga/BranchPredictor.scala 75:62]
  wire  _T_1 = ~io_up_pc[0]; // @[src/main/scala/fpga/BranchPredictor.scala 76:21]
  wire [48:0] _T_3 = {up_pc_tag,io_up_taken_pc}; // @[src/main/scala/fpga/BranchPredictor.scala 77:32]
  assign btb0_tag_reg_entry0_MPORT_en = 1'h1;
  assign btb0_tag_reg_entry0_MPORT_addr = io_lu_pc[8:1];
  assign btb0_tag_reg_entry0_MPORT_data = btb0_tag[btb0_tag_reg_entry0_MPORT_addr]; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  assign btb0_tag_MPORT_data = _T_3[48:31];
  assign btb0_tag_MPORT_addr = io_up_pc[8:1];
  assign btb0_tag_MPORT_mask = 1'h1;
  assign btb0_tag_MPORT_en = io_up_en & _T_1;
  assign btb0_taken_pc_reg_entry0_MPORT_en = 1'h1;
  assign btb0_taken_pc_reg_entry0_MPORT_addr = io_lu_pc[8:1];
  assign btb0_taken_pc_reg_entry0_MPORT_data = btb0_taken_pc[btb0_taken_pc_reg_entry0_MPORT_addr]; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
  assign btb0_taken_pc_MPORT_data = _T_3[30:0];
  assign btb0_taken_pc_MPORT_addr = io_up_pc[8:1];
  assign btb0_taken_pc_MPORT_mask = 1'h1;
  assign btb0_taken_pc_MPORT_en = io_up_en & _T_1;
  assign btb1_tag_reg_entry1_MPORT_en = 1'h1;
  assign btb1_tag_reg_entry1_MPORT_addr = io_lu_pc[8:1];
  assign btb1_tag_reg_entry1_MPORT_data = btb1_tag[btb1_tag_reg_entry1_MPORT_addr]; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  assign btb1_tag_MPORT_1_data = _T_3[48:31];
  assign btb1_tag_MPORT_1_addr = io_up_pc[8:1];
  assign btb1_tag_MPORT_1_mask = 1'h1;
  assign btb1_tag_MPORT_1_en = io_up_en & io_up_pc[0];
  assign btb1_taken_pc_reg_entry1_MPORT_en = 1'h1;
  assign btb1_taken_pc_reg_entry1_MPORT_addr = io_lu_pc[8:1];
  assign btb1_taken_pc_reg_entry1_MPORT_data = btb1_taken_pc[btb1_taken_pc_reg_entry1_MPORT_addr]; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
  assign btb1_taken_pc_MPORT_1_data = _T_3[30:0];
  assign btb1_taken_pc_MPORT_1_addr = io_up_pc[8:1];
  assign btb1_taken_pc_MPORT_1_mask = 1'h1;
  assign btb1_taken_pc_MPORT_1_en = io_up_en & io_up_pc[0];
  assign io_lu_matches0 = reg_entry0_tag == reg_lu_pc_tag; // @[src/main/scala/fpga/BranchPredictor.scala 70:38]
  assign io_lu_taken_pc0 = reg_entry0_taken_pc; // @[src/main/scala/fpga/BranchPredictor.scala 71:19]
  assign io_lu_matches1 = reg_entry1_tag == reg_lu_pc_tag; // @[src/main/scala/fpga/BranchPredictor.scala 72:38]
  assign io_lu_taken_pc1 = reg_entry1_taken_pc; // @[src/main/scala/fpga/BranchPredictor.scala 73:19]
  always @(posedge clock) begin
    if (btb0_tag_MPORT_en & btb0_tag_MPORT_mask) begin
      btb0_tag[btb0_tag_MPORT_addr] <= btb0_tag_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
    end
    if (btb0_taken_pc_MPORT_en & btb0_taken_pc_MPORT_mask) begin
      btb0_taken_pc[btb0_taken_pc_MPORT_addr] <= btb0_taken_pc_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 58:17]
    end
    if (btb1_tag_MPORT_1_en & btb1_tag_MPORT_1_mask) begin
      btb1_tag[btb1_tag_MPORT_1_addr] <= btb1_tag_MPORT_1_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
    end
    if (btb1_taken_pc_MPORT_1_en & btb1_taken_pc_MPORT_1_mask) begin
      btb1_taken_pc[btb1_taken_pc_MPORT_1_addr] <= btb1_taken_pc_MPORT_1_data; // @[src/main/scala/fpga/BranchPredictor.scala 59:17]
    end
    if (reset) begin // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
      reg_entry0_tag <= 18'h0; // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
    end else begin
      reg_entry0_tag <= btb0_tag_reg_entry0_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 67:14]
    end
    if (reset) begin // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
      reg_entry0_taken_pc <= 31'h0; // @[src/main/scala/fpga/BranchPredictor.scala 61:27]
    end else begin
      reg_entry0_taken_pc <= btb0_taken_pc_reg_entry0_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 67:14]
    end
    if (reset) begin // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
      reg_entry1_tag <= 18'h0; // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
    end else begin
      reg_entry1_tag <= btb1_tag_reg_entry1_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 68:14]
    end
    if (reset) begin // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
      reg_entry1_taken_pc <= 31'h0; // @[src/main/scala/fpga/BranchPredictor.scala 62:27]
    end else begin
      reg_entry1_taken_pc <= btb1_taken_pc_reg_entry1_MPORT_data; // @[src/main/scala/fpga/BranchPredictor.scala 68:14]
    end
    if (reset) begin // @[src/main/scala/fpga/BranchPredictor.scala 65:30]
      reg_lu_pc_tag <= 18'h0; // @[src/main/scala/fpga/BranchPredictor.scala 65:30]
    end else begin
      reg_lu_pc_tag <= lu_pc_tag; // @[src/main/scala/fpga/BranchPredictor.scala 65:30]
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
  input  [30:0] io_lu_pc, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output [1:0]  io_lu_cnt0, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output [1:0]  io_lu_cnt1, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  input         io_up_en, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  input  [30:0] io_up_pc, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  input  [1:0]  io_up_cnt, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output        io_mem_wen, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output [11:0] io_mem_raddr, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  input  [3:0]  io_mem_rdata, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output [12:0] io_mem_waddr, // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
  output [1:0]  io_mem_wdata // @[src/main/scala/fpga/BranchPredictor.scala 85:14]
);
  assign io_lu_cnt0 = io_mem_rdata[1:0]; // @[src/main/scala/fpga/BranchPredictor.scala 94:20]
  assign io_lu_cnt1 = io_mem_rdata[3:2]; // @[src/main/scala/fpga/BranchPredictor.scala 95:20]
  assign io_mem_wen = io_up_en; // @[src/main/scala/fpga/BranchPredictor.scala 97:16]
  assign io_mem_raddr = io_lu_pc[12:1]; // @[src/main/scala/fpga/BranchPredictor.scala 92:27]
  assign io_mem_waddr = io_up_pc[12:0]; // @[src/main/scala/fpga/BranchPredictor.scala 98:27]
  assign io_mem_wdata = io_up_cnt; // @[src/main/scala/fpga/BranchPredictor.scala 99:16]
endmodule
module Core(
  input         clock,
  input         reset,
  output [31:0] io_imem_addr, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_imem_inst, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_imem_valid, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_dmem_raddr, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_dmem_rdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_dmem_ren, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_dmem_waddr, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_dmem_wen, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_dmem_wready, // @[src/main/scala/fpga/Core.scala 111:14]
  output [3:0]  io_dmem_wstrb, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_dmem_wdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_cache_iinvalidate, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_cache_ibusy, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_cache_raddr, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_cache_rdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_cache_ren, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_cache_rvalid, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_cache_rready, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_cache_waddr, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_cache_wen, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_cache_wready, // @[src/main/scala/fpga/Core.scala 111:14]
  output [3:0]  io_cache_wstrb, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_cache_wdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_pht_mem_wen, // @[src/main/scala/fpga/Core.scala 111:14]
  output [11:0] io_pht_mem_raddr, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [3:0]  io_pht_mem_rdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output [12:0] io_pht_mem_waddr, // @[src/main/scala/fpga/Core.scala 111:14]
  output [1:0]  io_pht_mem_wdata, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_mtimer_mem_raddr, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_mtimer_mem_rdata, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_mtimer_mem_waddr, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_mtimer_mem_wen, // @[src/main/scala/fpga/Core.scala 111:14]
  input  [31:0] io_mtimer_mem_wdata, // @[src/main/scala/fpga/Core.scala 111:14]
  input         io_intr, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_debug_signal_ex2_reg_pc, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_ex2_is_valid_inst, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_me_intr, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_mt_intr, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_trap, // @[src/main/scala/fpga/Core.scala 111:14]
  output [47:0] io_debug_signal_cycle_counter, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_debug_signal_id_pc, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_debug_signal_id_inst, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_debug_signal_mem3_rdata, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_mem3_rvalid, // @[src/main/scala/fpga/Core.scala 111:14]
  output [31:0] io_debug_signal_rwaddr, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_ex2_reg_is_br, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_id_reg_is_bp_fail, // @[src/main/scala/fpga/Core.scala 111:14]
  output        io_debug_signal_id_reg_bp_taken, // @[src/main/scala/fpga/Core.scala 111:14]
  output [2:0]  io_debug_signal_ic_state // @[src/main/scala/fpga/Core.scala 111:14]
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
  reg [63:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [63:0] _RAND_72;
  reg [63:0] _RAND_73;
  reg [63:0] _RAND_74;
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
  reg [63:0] _RAND_85;
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
  reg [63:0] _RAND_173;
  reg [63:0] _RAND_174;
  reg [63:0] _RAND_175;
  reg [31:0] _RAND_176;
  reg [31:0] _RAND_177;
  reg [31:0] _RAND_178;
  reg [31:0] _RAND_179;
  reg [31:0] _RAND_180;
  reg [31:0] _RAND_181;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_rrd_op1_data_MPORT_en; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [4:0] regfile_rrd_op1_data_MPORT_addr; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [31:0] regfile_rrd_op1_data_MPORT_data; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_rrd_op2_data_MPORT_en; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [4:0] regfile_rrd_op2_data_MPORT_addr; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [31:0] regfile_rrd_op2_data_MPORT_data; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_rrd_op3_data_MPORT_en; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [4:0] regfile_rrd_op3_data_MPORT_addr; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [31:0] regfile_rrd_op3_data_MPORT_data; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [31:0] regfile_MPORT_3_data; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [4:0] regfile_MPORT_3_addr; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_MPORT_3_mask; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_MPORT_3_en; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [31:0] regfile_MPORT_5_data; // @[src/main/scala/fpga/Core.scala 133:20]
  wire [4:0] regfile_MPORT_5_addr; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_MPORT_5_mask; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  regfile_MPORT_5_en; // @[src/main/scala/fpga/Core.scala 133:20]
  wire  cycle_counter_clock; // @[src/main/scala/fpga/Core.scala 135:29]
  wire  cycle_counter_reset; // @[src/main/scala/fpga/Core.scala 135:29]
  wire [63:0] cycle_counter_io_value; // @[src/main/scala/fpga/Core.scala 135:29]
  wire  mtimer_clock; // @[src/main/scala/fpga/Core.scala 136:22]
  wire  mtimer_reset; // @[src/main/scala/fpga/Core.scala 136:22]
  wire [31:0] mtimer_io_mem_raddr; // @[src/main/scala/fpga/Core.scala 136:22]
  wire [31:0] mtimer_io_mem_rdata; // @[src/main/scala/fpga/Core.scala 136:22]
  wire [31:0] mtimer_io_mem_waddr; // @[src/main/scala/fpga/Core.scala 136:22]
  wire  mtimer_io_mem_wen; // @[src/main/scala/fpga/Core.scala 136:22]
  wire [31:0] mtimer_io_mem_wdata; // @[src/main/scala/fpga/Core.scala 136:22]
  wire  mtimer_io_intr; // @[src/main/scala/fpga/Core.scala 136:22]
  wire [63:0] mtimer_io_mtime; // @[src/main/scala/fpga/Core.scala 136:22]
  reg  scoreboard [0:31]; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_1_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_1_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_1_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_2_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_2_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_2_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_3_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_rrd_stall_MPORT_3_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_rrd_stall_MPORT_3_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_mask; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_1_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_1_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_1_mask; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_1_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_2_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_2_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_2_mask; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_2_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_4_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_4_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_4_mask; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_4_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_6_data; // @[src/main/scala/fpga/Core.scala 149:25]
  wire [4:0] scoreboard_MPORT_6_addr; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_6_mask; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  scoreboard_MPORT_6_en; // @[src/main/scala/fpga/Core.scala 149:25]
  wire  ic_btb_clock; // @[src/main/scala/fpga/Core.scala 354:22]
  wire  ic_btb_reset; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_btb_io_lu_pc; // @[src/main/scala/fpga/Core.scala 354:22]
  wire  ic_btb_io_lu_matches0; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_btb_io_lu_taken_pc0; // @[src/main/scala/fpga/Core.scala 354:22]
  wire  ic_btb_io_lu_matches1; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_btb_io_lu_taken_pc1; // @[src/main/scala/fpga/Core.scala 354:22]
  wire  ic_btb_io_up_en; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_btb_io_up_pc; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_btb_io_up_taken_pc; // @[src/main/scala/fpga/Core.scala 354:22]
  wire [30:0] ic_pht_io_lu_pc; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [1:0] ic_pht_io_lu_cnt0; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [1:0] ic_pht_io_lu_cnt1; // @[src/main/scala/fpga/Core.scala 355:22]
  wire  ic_pht_io_up_en; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [30:0] ic_pht_io_up_pc; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [1:0] ic_pht_io_up_cnt; // @[src/main/scala/fpga/Core.scala 355:22]
  wire  ic_pht_io_mem_wen; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [11:0] ic_pht_io_mem_raddr; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [3:0] ic_pht_io_mem_rdata; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [12:0] ic_pht_io_mem_waddr; // @[src/main/scala/fpga/Core.scala 355:22]
  wire [1:0] ic_pht_io_mem_wdata; // @[src/main/scala/fpga/Core.scala 355:22]
  reg [63:0] instret; // @[src/main/scala/fpga/Core.scala 138:24]
  reg [30:0] csr_reg_trap_vector; // @[src/main/scala/fpga/Core.scala 139:37]
  reg [31:0] csr_reg_mcause; // @[src/main/scala/fpga/Core.scala 140:37]
  reg [30:0] csr_reg_mepc; // @[src/main/scala/fpga/Core.scala 142:37]
  reg  csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 143:37]
  reg  csr_reg_mstatus_mpie; // @[src/main/scala/fpga/Core.scala 144:37]
  reg [31:0] csr_reg_mscratch; // @[src/main/scala/fpga/Core.scala 145:37]
  reg  csr_reg_mie_meie; // @[src/main/scala/fpga/Core.scala 146:37]
  reg  csr_reg_mie_mtie; // @[src/main/scala/fpga/Core.scala 147:37]
  reg [31:0] id_reg_inst; // @[src/main/scala/fpga/Core.scala 158:38]
  reg  id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 159:38]
  reg [30:0] id_reg_pc; // @[src/main/scala/fpga/Core.scala 160:38]
  reg [30:0] id_reg_bp_taken_pc; // @[src/main/scala/fpga/Core.scala 161:38]
  reg [1:0] id_reg_bp_cnt; // @[src/main/scala/fpga/Core.scala 162:38]
  reg  id_reg_stall; // @[src/main/scala/fpga/Core.scala 164:38]
  reg [30:0] rrd_reg_pc; // @[src/main/scala/fpga/Core.scala 171:38]
  reg [4:0] rrd_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 172:38]
  reg  rrd_reg_op1_sel; // @[src/main/scala/fpga/Core.scala 173:38]
  reg  rrd_reg_op2_sel; // @[src/main/scala/fpga/Core.scala 174:38]
  reg [1:0] rrd_reg_op3_sel; // @[src/main/scala/fpga/Core.scala 175:38]
  reg [4:0] rrd_reg_rs1_addr; // @[src/main/scala/fpga/Core.scala 176:38]
  reg [4:0] rrd_reg_rs2_addr; // @[src/main/scala/fpga/Core.scala 177:38]
  reg [4:0] rrd_reg_rs3_addr; // @[src/main/scala/fpga/Core.scala 178:38]
  reg [31:0] rrd_reg_op1_data; // @[src/main/scala/fpga/Core.scala 179:38]
  reg [31:0] rrd_reg_op2_data; // @[src/main/scala/fpga/Core.scala 180:38]
  reg [3:0] rrd_reg_exe_fun; // @[src/main/scala/fpga/Core.scala 181:38]
  reg  rrd_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 182:38]
  reg [2:0] rrd_reg_wb_sel; // @[src/main/scala/fpga/Core.scala 183:38]
  reg [11:0] rrd_reg_csr_addr; // @[src/main/scala/fpga/Core.scala 184:38]
  reg [1:0] rrd_reg_csr_cmd; // @[src/main/scala/fpga/Core.scala 185:38]
  reg [31:0] rrd_reg_imm_b_sext; // @[src/main/scala/fpga/Core.scala 186:38]
  reg [2:0] rrd_reg_mem_w; // @[src/main/scala/fpga/Core.scala 187:38]
  reg  rrd_reg_is_br; // @[src/main/scala/fpga/Core.scala 189:38]
  reg  rrd_reg_is_j; // @[src/main/scala/fpga/Core.scala 190:38]
  reg  rrd_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 191:38]
  reg [30:0] rrd_reg_bp_taken_pc; // @[src/main/scala/fpga/Core.scala 192:38]
  reg [1:0] rrd_reg_bp_cnt; // @[src/main/scala/fpga/Core.scala 193:38]
  reg  rrd_reg_is_half; // @[src/main/scala/fpga/Core.scala 194:38]
  reg  rrd_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 195:38]
  reg  rrd_reg_is_trap; // @[src/main/scala/fpga/Core.scala 196:38]
  reg [31:0] rrd_reg_mcause; // @[src/main/scala/fpga/Core.scala 197:38]
  reg [30:0] ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 201:38]
  reg [4:0] ex1_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 202:38]
  reg [31:0] ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 203:38]
  reg [31:0] ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 204:38]
  reg [31:0] ex1_reg_op3_data; // @[src/main/scala/fpga/Core.scala 205:38]
  reg [3:0] ex1_reg_exe_fun; // @[src/main/scala/fpga/Core.scala 206:38]
  reg  ex1_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 207:38]
  reg [2:0] ex1_reg_wb_sel; // @[src/main/scala/fpga/Core.scala 208:38]
  reg [11:0] ex1_reg_csr_addr; // @[src/main/scala/fpga/Core.scala 209:38]
  reg [1:0] ex1_reg_csr_cmd; // @[src/main/scala/fpga/Core.scala 210:38]
  reg [2:0] ex1_reg_mem_w; // @[src/main/scala/fpga/Core.scala 211:38]
  reg  ex1_reg_is_j; // @[src/main/scala/fpga/Core.scala 212:38]
  reg  ex1_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 213:38]
  reg [30:0] ex1_reg_bp_taken_pc; // @[src/main/scala/fpga/Core.scala 214:38]
  reg [1:0] ex1_reg_bp_cnt; // @[src/main/scala/fpga/Core.scala 215:38]
  reg  ex1_reg_is_half; // @[src/main/scala/fpga/Core.scala 216:38]
  reg  ex1_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 217:38]
  reg  ex1_reg_is_trap; // @[src/main/scala/fpga/Core.scala 218:38]
  reg  ex1_reg_is_mret; // @[src/main/scala/fpga/Core.scala 219:38]
  reg [31:0] ex1_reg_mcause; // @[src/main/scala/fpga/Core.scala 220:38]
  reg  ex1_reg_mem_use_reg; // @[src/main/scala/fpga/Core.scala 222:38]
  reg  ex1_reg_inst2_use_reg; // @[src/main/scala/fpga/Core.scala 223:38]
  reg  ex1_reg_inst3_use_reg; // @[src/main/scala/fpga/Core.scala 224:38]
  reg  ex1_reg_is_br; // @[src/main/scala/fpga/Core.scala 225:38]
  reg [30:0] ex1_reg_direct_jbr_pc; // @[src/main/scala/fpga/Core.scala 226:38]
  reg [30:0] ex2_reg_pc; // @[src/main/scala/fpga/Core.scala 229:38]
  reg [4:0] ex2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 230:38]
  reg [47:0] ex2_reg_mullu; // @[src/main/scala/fpga/Core.scala 231:38]
  reg [31:0] ex2_reg_mulls; // @[src/main/scala/fpga/Core.scala 232:38]
  reg [47:0] ex2_reg_mulhuu; // @[src/main/scala/fpga/Core.scala 233:38]
  reg [47:0] ex2_reg_mulhss; // @[src/main/scala/fpga/Core.scala 234:38]
  reg [47:0] ex2_reg_mulhsu; // @[src/main/scala/fpga/Core.scala 235:38]
  reg [3:0] ex2_reg_exe_fun; // @[src/main/scala/fpga/Core.scala 236:38]
  reg  ex2_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 237:38]
  reg [2:0] ex2_reg_wb_sel; // @[src/main/scala/fpga/Core.scala 238:38]
  reg [31:0] ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 239:38]
  reg [31:0] ex2_reg_pc_bit_out; // @[src/main/scala/fpga/Core.scala 240:38]
  reg  ex2_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 241:38]
  reg  ex2_reg_divrem; // @[src/main/scala/fpga/Core.scala 244:38]
  reg  ex2_reg_sign_op1; // @[src/main/scala/fpga/Core.scala 245:38]
  reg  ex2_reg_sign_op12; // @[src/main/scala/fpga/Core.scala 246:38]
  reg  ex2_reg_zero_op2; // @[src/main/scala/fpga/Core.scala 247:38]
  reg [36:0] ex2_reg_init_dividend; // @[src/main/scala/fpga/Core.scala 248:38]
  reg [31:0] ex2_reg_init_divisor; // @[src/main/scala/fpga/Core.scala 249:38]
  reg [31:0] ex2_reg_orig_dividend; // @[src/main/scala/fpga/Core.scala 250:38]
  reg  ex2_reg_inst3_use_reg; // @[src/main/scala/fpga/Core.scala 251:38]
  reg  ex2_reg_no_mem; // @[src/main/scala/fpga/Core.scala 252:38]
  reg [6:0] mem1_reg_mem_wstrb; // @[src/main/scala/fpga/Core.scala 255:39]
  reg [31:0] mem1_reg_wdata; // @[src/main/scala/fpga/Core.scala 256:39]
  reg [2:0] mem1_reg_mem_w; // @[src/main/scala/fpga/Core.scala 257:39]
  reg  mem1_reg_is_mem_load; // @[src/main/scala/fpga/Core.scala 260:39]
  reg  mem1_reg_is_mem_store; // @[src/main/scala/fpga/Core.scala 261:39]
  reg  mem1_reg_is_dram_load; // @[src/main/scala/fpga/Core.scala 262:39]
  reg  mem1_reg_is_dram_store; // @[src/main/scala/fpga/Core.scala 263:39]
  reg  mem1_reg_is_dram_fence; // @[src/main/scala/fpga/Core.scala 264:39]
  reg  mem1_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 265:39]
  reg  mem1_reg_unaligned; // @[src/main/scala/fpga/Core.scala 266:39]
  reg [1:0] mem2_reg_wb_byte_offset; // @[src/main/scala/fpga/Core.scala 269:40]
  reg [2:0] mem2_reg_mem_w; // @[src/main/scala/fpga/Core.scala 270:40]
  reg [31:0] mem2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 272:40]
  reg  mem2_reg_is_valid_load; // @[src/main/scala/fpga/Core.scala 273:40]
  reg  mem2_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 275:40]
  reg  mem2_reg_is_mem_load; // @[src/main/scala/fpga/Core.scala 276:40]
  reg  mem2_reg_is_dram_load; // @[src/main/scala/fpga/Core.scala 277:40]
  reg  mem2_reg_unaligned; // @[src/main/scala/fpga/Core.scala 278:40]
  reg [1:0] mem3_reg_wb_byte_offset; // @[src/main/scala/fpga/Core.scala 281:40]
  reg [2:0] mem3_reg_mem_w; // @[src/main/scala/fpga/Core.scala 282:40]
  reg [31:0] mem3_reg_dmem_rdata; // @[src/main/scala/fpga/Core.scala 283:40]
  reg [23:0] mem3_reg_rdata_high; // @[src/main/scala/fpga/Core.scala 284:40]
  reg [31:0] mem3_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 285:40]
  reg  mem3_reg_is_valid_load; // @[src/main/scala/fpga/Core.scala 286:40]
  reg  mem3_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 287:40]
  reg  mem3_reg_unaligned; // @[src/main/scala/fpga/Core.scala 289:40]
  reg  mem3_reg_is_aligned_lw; // @[src/main/scala/fpga/Core.scala 290:40]
  reg  id_reg_is_bp_fail; // @[src/main/scala/fpga/Core.scala 292:37]
  reg [30:0] id_reg_br_pc; // @[src/main/scala/fpga/Core.scala 293:37]
  reg  ex1_reg_fw_en; // @[src/main/scala/fpga/Core.scala 301:37]
  reg  ex2_reg_fw_en; // @[src/main/scala/fpga/Core.scala 303:37]
  reg  mem3_reg_fw_en; // @[src/main/scala/fpga/Core.scala 305:37]
  reg  ex2_reg_div_stall; // @[src/main/scala/fpga/Core.scala 308:37]
  reg [2:0] ex2_reg_divrem_state; // @[src/main/scala/fpga/Core.scala 310:37]
  reg  ex2_reg_is_br; // @[src/main/scala/fpga/Core.scala 311:37]
  reg [30:0] ex2_reg_br_pc; // @[src/main/scala/fpga/Core.scala 312:37]
  reg  ex2_reg_is_retired; // @[src/main/scala/fpga/Core.scala 317:37]
  reg  mem3_reg_is_retired; // @[src/main/scala/fpga/Core.scala 318:37]
  reg  ic_reg_read_rdy; // @[src/main/scala/fpga/Core.scala 338:33]
  reg  ic_reg_half_rdy; // @[src/main/scala/fpga/Core.scala 339:33]
  reg [30:0] ic_reg_imem_addr; // @[src/main/scala/fpga/Core.scala 343:33]
  reg [30:0] ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 344:33]
  reg [31:0] ic_reg_inst; // @[src/main/scala/fpga/Core.scala 347:34]
  reg [30:0] ic_reg_inst_addr; // @[src/main/scala/fpga/Core.scala 348:34]
  reg [31:0] ic_reg_inst2; // @[src/main/scala/fpga/Core.scala 349:34]
  reg [2:0] ic_state; // @[src/main/scala/fpga/Core.scala 352:25]
  reg  ic_reg_bp_next_taken0; // @[src/main/scala/fpga/Core.scala 360:41]
  reg [30:0] ic_reg_bp_next_taken_pc0; // @[src/main/scala/fpga/Core.scala 361:41]
  reg [1:0] ic_reg_bp_next_cnt0; // @[src/main/scala/fpga/Core.scala 362:41]
  reg  ic_reg_bp_next_taken1; // @[src/main/scala/fpga/Core.scala 363:41]
  reg [30:0] ic_reg_bp_next_taken_pc1; // @[src/main/scala/fpga/Core.scala 364:41]
  reg [1:0] ic_reg_bp_next_cnt1; // @[src/main/scala/fpga/Core.scala 365:41]
  reg  ic_reg_bp_next_taken2; // @[src/main/scala/fpga/Core.scala 366:41]
  reg [30:0] ic_reg_bp_next_taken_pc2; // @[src/main/scala/fpga/Core.scala 367:41]
  reg [1:0] ic_reg_bp_next_cnt2; // @[src/main/scala/fpga/Core.scala 368:41]
  wire [30:0] ic_imem_addr_2 = {ic_reg_imem_addr[30:1],1'h1}; // @[src/main/scala/fpga/Core.scala 370:27]
  wire [30:0] ic_imem_addr_4 = ic_reg_imem_addr + 31'h2; // @[src/main/scala/fpga/Core.scala 371:41]
  wire [30:0] ic_inst_addr_2 = {ic_reg_inst_addr[30:1],1'h1}; // @[src/main/scala/fpga/Core.scala 372:27]
  wire [31:0] _io_imem_addr_T = {ic_reg_imem_addr,1'h0}; // @[src/main/scala/fpga/Core.scala 373:22]
  wire [30:0] _if1_jump_addr_T = id_reg_is_bp_fail ? id_reg_br_pc : id_reg_bp_taken_pc; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] if1_jump_addr = ex2_reg_is_br ? ex2_reg_br_pc : _if1_jump_addr_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] ic_next_imem_addr = {if1_jump_addr[30:1],1'h0}; // @[src/main/scala/fpga/Core.scala 390:32]
  wire [31:0] _io_imem_addr_T_1 = {if1_jump_addr[30:1],1'h0,1'h0}; // @[src/main/scala/fpga/Core.scala 391:28]
  wire  _T_3 = 3'h0 == ic_state; // @[src/main/scala/fpga/Core.scala 403:23]
  wire  _ic_bp_taken_T_1 = ic_btb_io_lu_matches0 & ic_pht_io_lu_cnt0[0]; // @[src/main/scala/fpga/Core.scala 405:49]
  wire  _ic_reg_bp_next_taken1_T_1 = ic_btb_io_lu_matches1 & ic_pht_io_lu_cnt1[0]; // @[src/main/scala/fpga/Core.scala 411:59]
  wire  _T_6 = 3'h1 == ic_state; // @[src/main/scala/fpga/Core.scala 403:23]
  wire  _T_9 = 3'h2 == ic_state; // @[src/main/scala/fpga/Core.scala 403:23]
  wire  _T_12 = 3'h4 == ic_state; // @[src/main/scala/fpga/Core.scala 403:23]
  wire  _T_15 = 3'h3 == ic_state; // @[src/main/scala/fpga/Core.scala 403:23]
  wire  _GEN_0 = 3'h3 == ic_state & ic_reg_bp_next_taken2; // @[src/main/scala/fpga/Core.scala 384:19 403:23 443:24]
  wire [30:0] _GEN_1 = 3'h3 == ic_state ? ic_reg_bp_next_taken_pc2 : 31'h0; // @[src/main/scala/fpga/Core.scala 385:19 403:23 444:24]
  wire [1:0] _GEN_2 = 3'h3 == ic_state ? ic_reg_bp_next_cnt2 : 2'h0; // @[src/main/scala/fpga/Core.scala 386:19 403:23 445:24]
  wire  _GEN_3 = 3'h4 == ic_state ? ic_reg_bp_next_taken1 : _GEN_0; // @[src/main/scala/fpga/Core.scala 403:23 432:24]
  wire [30:0] _GEN_4 = 3'h4 == ic_state ? ic_reg_bp_next_taken_pc1 : _GEN_1; // @[src/main/scala/fpga/Core.scala 403:23 433:24]
  wire [1:0] _GEN_5 = 3'h4 == ic_state ? ic_reg_bp_next_cnt1 : _GEN_2; // @[src/main/scala/fpga/Core.scala 403:23 434:24]
  wire  _GEN_6 = 3'h4 == ic_state ? _ic_bp_taken_T_1 : ic_reg_bp_next_taken0; // @[src/main/scala/fpga/Core.scala 403:23 435:34 360:41]
  wire [30:0] _GEN_7 = 3'h4 == ic_state ? ic_btb_io_lu_taken_pc0 : ic_reg_bp_next_taken_pc0; // @[src/main/scala/fpga/Core.scala 403:23 436:34 361:41]
  wire [1:0] _GEN_8 = 3'h4 == ic_state ? ic_pht_io_lu_cnt0 : ic_reg_bp_next_cnt0; // @[src/main/scala/fpga/Core.scala 403:23 437:34 362:41]
  wire  _GEN_9 = 3'h4 == ic_state ? ic_reg_bp_next_taken1 : ic_reg_bp_next_taken2; // @[src/main/scala/fpga/Core.scala 403:23 438:34 366:41]
  wire [30:0] _GEN_10 = 3'h4 == ic_state ? ic_reg_bp_next_taken_pc1 : ic_reg_bp_next_taken_pc2; // @[src/main/scala/fpga/Core.scala 403:23 439:34 367:41]
  wire [1:0] _GEN_11 = 3'h4 == ic_state ? ic_reg_bp_next_cnt1 : ic_reg_bp_next_cnt2; // @[src/main/scala/fpga/Core.scala 403:23 440:34 368:41]
  wire  _GEN_12 = 3'h2 == ic_state ? ic_reg_bp_next_taken0 : _GEN_3; // @[src/main/scala/fpga/Core.scala 403:23 427:24]
  wire [30:0] _GEN_13 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc0 : _GEN_4; // @[src/main/scala/fpga/Core.scala 403:23 428:24]
  wire [1:0] _GEN_14 = 3'h2 == ic_state ? ic_reg_bp_next_cnt0 : _GEN_5; // @[src/main/scala/fpga/Core.scala 403:23 429:24]
  wire  _GEN_15 = 3'h2 == ic_state ? ic_reg_bp_next_taken0 : _GEN_6; // @[src/main/scala/fpga/Core.scala 403:23 360:41]
  wire [30:0] _GEN_16 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc0 : _GEN_7; // @[src/main/scala/fpga/Core.scala 403:23 361:41]
  wire [1:0] _GEN_17 = 3'h2 == ic_state ? ic_reg_bp_next_cnt0 : _GEN_8; // @[src/main/scala/fpga/Core.scala 403:23 362:41]
  wire  _GEN_18 = 3'h2 == ic_state ? ic_reg_bp_next_taken2 : _GEN_9; // @[src/main/scala/fpga/Core.scala 403:23 366:41]
  wire [30:0] _GEN_19 = 3'h2 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_10; // @[src/main/scala/fpga/Core.scala 403:23 367:41]
  wire [1:0] _GEN_20 = 3'h2 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_11; // @[src/main/scala/fpga/Core.scala 403:23 368:41]
  wire  _GEN_21 = 3'h1 == ic_state ? _ic_reg_bp_next_taken1_T_1 : _GEN_12; // @[src/main/scala/fpga/Core.scala 403:23 416:24]
  wire [30:0] _GEN_22 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc1 : _GEN_13; // @[src/main/scala/fpga/Core.scala 403:23 417:24]
  wire [1:0] _GEN_23 = 3'h1 == ic_state ? ic_pht_io_lu_cnt1 : _GEN_14; // @[src/main/scala/fpga/Core.scala 403:23 418:24]
  wire  _GEN_24 = 3'h1 == ic_state ? _ic_bp_taken_T_1 : _GEN_15; // @[src/main/scala/fpga/Core.scala 403:23 419:34]
  wire [30:0] _GEN_25 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_16; // @[src/main/scala/fpga/Core.scala 403:23 420:34]
  wire [1:0] _GEN_26 = 3'h1 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_17; // @[src/main/scala/fpga/Core.scala 403:23 421:34]
  wire  _GEN_27 = 3'h1 == ic_state ? _ic_reg_bp_next_taken1_T_1 : ic_reg_bp_next_taken1; // @[src/main/scala/fpga/Core.scala 403:23 422:34 363:41]
  wire [30:0] _GEN_28 = 3'h1 == ic_state ? ic_btb_io_lu_taken_pc1 : ic_reg_bp_next_taken_pc1; // @[src/main/scala/fpga/Core.scala 403:23 423:34 364:41]
  wire [1:0] _GEN_29 = 3'h1 == ic_state ? ic_pht_io_lu_cnt1 : ic_reg_bp_next_cnt1; // @[src/main/scala/fpga/Core.scala 403:23 424:34 365:41]
  wire  _GEN_30 = 3'h1 == ic_state ? ic_reg_bp_next_taken2 : _GEN_18; // @[src/main/scala/fpga/Core.scala 403:23 366:41]
  wire [30:0] _GEN_31 = 3'h1 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_19; // @[src/main/scala/fpga/Core.scala 403:23 367:41]
  wire [1:0] _GEN_32 = 3'h1 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_20; // @[src/main/scala/fpga/Core.scala 403:23 368:41]
  wire  _GEN_33 = 3'h0 == ic_state ? ic_btb_io_lu_matches0 & ic_pht_io_lu_cnt0[0] : _GEN_21; // @[src/main/scala/fpga/Core.scala 403:23 405:24]
  wire [30:0] _GEN_34 = 3'h0 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_22; // @[src/main/scala/fpga/Core.scala 403:23 406:24]
  wire [1:0] _GEN_35 = 3'h0 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_23; // @[src/main/scala/fpga/Core.scala 403:23 407:24]
  wire  _GEN_36 = 3'h0 == ic_state ? _ic_bp_taken_T_1 : _GEN_24; // @[src/main/scala/fpga/Core.scala 403:23 408:34]
  wire [30:0] _GEN_37 = 3'h0 == ic_state ? ic_btb_io_lu_taken_pc0 : _GEN_25; // @[src/main/scala/fpga/Core.scala 403:23 409:34]
  wire [1:0] _GEN_38 = 3'h0 == ic_state ? ic_pht_io_lu_cnt0 : _GEN_26; // @[src/main/scala/fpga/Core.scala 403:23 410:34]
  wire  _GEN_42 = 3'h0 == ic_state ? ic_reg_bp_next_taken2 : _GEN_30; // @[src/main/scala/fpga/Core.scala 403:23 366:41]
  wire [30:0] _GEN_43 = 3'h0 == ic_state ? ic_reg_bp_next_taken_pc2 : _GEN_31; // @[src/main/scala/fpga/Core.scala 403:23 367:41]
  wire [1:0] _GEN_44 = 3'h0 == ic_state ? ic_reg_bp_next_cnt2 : _GEN_32; // @[src/main/scala/fpga/Core.scala 403:23 368:41]
  wire [31:0] _io_imem_addr_T_2 = {ic_imem_addr_4,1'h0}; // @[src/main/scala/fpga/Core.scala 451:32]
  wire  _ic_read_en4_T = ~id_reg_stall; // @[src/main/scala/fpga/Core.scala 584:18]
  wire  _if1_is_jump_T = ex2_reg_is_br | id_reg_is_bp_fail; // @[src/main/scala/fpga/Core.scala 574:35]
  wire  if1_is_jump = ex2_reg_is_br | id_reg_is_bp_fail | id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 574:56]
  wire [30:0] _ic_data_out_T_2 = {15'h0,io_imem_inst[31:16]}; // @[src/main/scala/fpga/Core.scala 481:32]
  wire [31:0] _ic_data_out_T_5 = {io_imem_inst[15:0],ic_reg_inst[31:16]}; // @[src/main/scala/fpga/Core.scala 519:33]
  wire [31:0] _ic_data_out_T_8 = {ic_reg_inst[15:0],ic_reg_inst2[31:16]}; // @[src/main/scala/fpga/Core.scala 549:31]
  wire [31:0] _GEN_64 = _T_15 ? _ic_data_out_T_8 : 32'h13; // @[src/main/scala/fpga/Core.scala 379:15 449:23 549:25]
  wire [31:0] _GEN_73 = _T_12 ? _ic_data_out_T_5 : _GEN_64; // @[src/main/scala/fpga/Core.scala 449:23 519:27]
  wire [31:0] _GEN_94 = _T_9 ? ic_reg_inst : _GEN_73; // @[src/main/scala/fpga/Core.scala 449:23 502:25]
  wire [31:0] _GEN_119 = _T_6 ? {{1'd0}, _ic_data_out_T_2} : _GEN_94; // @[src/main/scala/fpga/Core.scala 449:23 481:26]
  wire [31:0] _GEN_141 = _T_3 ? io_imem_inst : _GEN_119; // @[src/main/scala/fpga/Core.scala 449:23 455:26]
  wire [31:0] _GEN_179 = ~io_imem_valid ? 32'h13 : _GEN_141; // @[src/main/scala/fpga/Core.scala 379:15 398:98]
  wire [31:0] ic_data_out = if1_is_jump ? 32'h13 : _GEN_179; // @[src/main/scala/fpga/Core.scala 379:15 389:21]
  wire  if2_is_half_inst = ic_data_out[1:0] != 2'h3; // @[src/main/scala/fpga/Core.scala 582:45]
  wire  ic_read_en4 = ~id_reg_stall & ~if2_is_half_inst; // @[src/main/scala/fpga/Core.scala 584:32]
  wire [30:0] _GEN_45 = ic_read_en4 ? ic_imem_addr_4 : ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 380:15 471:34 472:23]
  wire [1:0] _GEN_46 = ic_read_en4 ? 2'h0 : 2'h2; // @[src/main/scala/fpga/Core.scala 467:18 471:34 473:20]
  wire  ic_read_en2 = _ic_read_en4_T & if2_is_half_inst; // @[src/main/scala/fpga/Core.scala 583:32]
  wire [30:0] _GEN_47 = ic_read_en2 ? ic_imem_addr_2 : _GEN_45; // @[src/main/scala/fpga/Core.scala 468:28 469:23]
  wire [2:0] _GEN_48 = ic_read_en2 ? 3'h4 : {{1'd0}, _GEN_46}; // @[src/main/scala/fpga/Core.scala 468:28 470:20]
  wire [30:0] _GEN_49 = ic_read_en2 ? ic_imem_addr_4 : ic_imem_addr_2; // @[src/main/scala/fpga/Core.scala 495:28 496:23 482:26]
  wire [2:0] _GEN_50 = ic_read_en2 ? 3'h0 : 3'h4; // @[src/main/scala/fpga/Core.scala 494:18 495:28 497:20]
  wire [30:0] _GEN_51 = ic_read_en4 ? ic_reg_imem_addr : ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 380:15 511:33 512:23]
  wire [2:0] _GEN_52 = ic_read_en4 ? 3'h0 : ic_state; // @[src/main/scala/fpga/Core.scala 511:33 513:20 352:25]
  wire [30:0] _GEN_53 = ic_read_en2 ? ic_inst_addr_2 : _GEN_51; // @[src/main/scala/fpga/Core.scala 508:28 509:23]
  wire [2:0] _GEN_54 = ic_read_en2 ? 3'h4 : _GEN_52; // @[src/main/scala/fpga/Core.scala 508:28 510:20]
  wire [30:0] _GEN_55 = ic_read_en4 ? ic_imem_addr_2 : ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 380:15 542:33 543:23]
  wire [2:0] _GEN_56 = ic_read_en4 ? 3'h4 : 3'h3; // @[src/main/scala/fpga/Core.scala 538:18 542:33 544:20]
  wire [30:0] _GEN_57 = ic_read_en2 ? ic_reg_imem_addr : _GEN_55; // @[src/main/scala/fpga/Core.scala 539:28 540:23]
  wire [2:0] _GEN_58 = ic_read_en2 ? 3'h2 : _GEN_56; // @[src/main/scala/fpga/Core.scala 539:28 541:20]
  wire [30:0] _GEN_59 = ic_read_en4 ? ic_inst_addr_2 : ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 380:15 558:33 559:23]
  wire [2:0] _GEN_60 = ic_read_en4 ? 3'h4 : ic_state; // @[src/main/scala/fpga/Core.scala 558:33 560:20 352:25]
  wire [30:0] _GEN_61 = ic_read_en2 ? ic_reg_inst_addr : _GEN_59; // @[src/main/scala/fpga/Core.scala 555:28 556:23]
  wire [2:0] _GEN_62 = ic_read_en2 ? 3'h2 : _GEN_60; // @[src/main/scala/fpga/Core.scala 555:28 557:20]
  wire [31:0] _GEN_63 = _T_15 ? _io_imem_addr_T : _io_imem_addr_T; // @[src/main/scala/fpga/Core.scala 373:16 449:23 548:25]
  wire [30:0] _GEN_69 = _T_15 ? _GEN_61 : ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 380:15 449:23]
  wire [2:0] _GEN_70 = _T_15 ? _GEN_62 : ic_state; // @[src/main/scala/fpga/Core.scala 449:23 352:25]
  wire [31:0] _GEN_71 = _T_12 ? _io_imem_addr_T_2 : _GEN_63; // @[src/main/scala/fpga/Core.scala 449:23 517:27]
  wire [30:0] _GEN_72 = _T_12 ? ic_imem_addr_4 : ic_reg_imem_addr; // @[src/main/scala/fpga/Core.scala 449:23 518:27 343:33]
  wire [31:0] _GEN_74 = _T_12 ? io_imem_inst : ic_reg_inst; // @[src/main/scala/fpga/Core.scala 449:23 520:27 347:34]
  wire [30:0] _GEN_75 = _T_12 ? ic_reg_imem_addr : ic_reg_inst_addr; // @[src/main/scala/fpga/Core.scala 449:23 521:27 348:34]
  wire [31:0] _GEN_76 = _T_12 ? ic_reg_inst : ic_reg_inst2; // @[src/main/scala/fpga/Core.scala 449:23 522:27 349:34]
  wire  _GEN_85 = _T_12 ? _ic_reg_bp_next_taken1_T_1 : ic_reg_bp_next_taken1; // @[src/main/scala/fpga/Core.scala 449:23 532:34 363:41]
  wire [30:0] _GEN_86 = _T_12 ? ic_btb_io_lu_taken_pc1 : ic_reg_bp_next_taken_pc1; // @[src/main/scala/fpga/Core.scala 449:23 533:34 364:41]
  wire [1:0] _GEN_87 = _T_12 ? ic_pht_io_lu_cnt1 : ic_reg_bp_next_cnt1; // @[src/main/scala/fpga/Core.scala 449:23 534:34 365:41]
  wire [2:0] _GEN_91 = _T_12 ? _GEN_58 : _GEN_70; // @[src/main/scala/fpga/Core.scala 449:23]
  wire [30:0] _GEN_92 = _T_12 ? _GEN_57 : _GEN_69; // @[src/main/scala/fpga/Core.scala 449:23]
  wire [31:0] _GEN_93 = _T_9 ? _io_imem_addr_T : _GEN_71; // @[src/main/scala/fpga/Core.scala 449:23 501:25]
  wire [30:0] _GEN_95 = _T_9 ? ic_reg_imem_addr : _GEN_72; // @[src/main/scala/fpga/Core.scala 449:23 503:25]
  wire [30:0] _GEN_99 = _T_9 ? _GEN_53 : _GEN_92; // @[src/main/scala/fpga/Core.scala 449:23]
  wire [2:0] _GEN_100 = _T_9 ? _GEN_54 : _GEN_91; // @[src/main/scala/fpga/Core.scala 449:23]
  wire [31:0] _GEN_102 = _T_9 ? ic_reg_inst : _GEN_74; // @[src/main/scala/fpga/Core.scala 449:23 347:34]
  wire [30:0] _GEN_103 = _T_9 ? ic_reg_inst_addr : _GEN_75; // @[src/main/scala/fpga/Core.scala 449:23 348:34]
  wire [31:0] _GEN_104 = _T_9 ? ic_reg_inst2 : _GEN_76; // @[src/main/scala/fpga/Core.scala 449:23 349:34]
  wire  _GEN_109 = _T_9 ? ic_reg_bp_next_taken1 : _GEN_85; // @[src/main/scala/fpga/Core.scala 449:23 363:41]
  wire [30:0] _GEN_110 = _T_9 ? ic_reg_bp_next_taken_pc1 : _GEN_86; // @[src/main/scala/fpga/Core.scala 449:23 364:41]
  wire [1:0] _GEN_111 = _T_9 ? ic_reg_bp_next_cnt1 : _GEN_87; // @[src/main/scala/fpga/Core.scala 449:23 365:41]
  wire [31:0] _GEN_115 = _T_6 ? _io_imem_addr_T_2 : _GEN_93; // @[src/main/scala/fpga/Core.scala 449:23 477:26]
  wire [30:0] _GEN_116 = _T_6 ? ic_imem_addr_4 : _GEN_95; // @[src/main/scala/fpga/Core.scala 449:23 478:26]
  wire [31:0] _GEN_117 = _T_6 ? io_imem_inst : _GEN_102; // @[src/main/scala/fpga/Core.scala 449:23 479:26]
  wire [30:0] _GEN_118 = _T_6 ? ic_reg_imem_addr : _GEN_103; // @[src/main/scala/fpga/Core.scala 449:23 480:26]
  wire [30:0] _GEN_120 = _T_6 ? _GEN_49 : _GEN_99; // @[src/main/scala/fpga/Core.scala 449:23]
  wire  _GEN_128 = _T_6 ? _ic_reg_bp_next_taken1_T_1 : _GEN_109; // @[src/main/scala/fpga/Core.scala 449:23 491:34]
  wire [30:0] _GEN_129 = _T_6 ? ic_btb_io_lu_taken_pc1 : _GEN_110; // @[src/main/scala/fpga/Core.scala 449:23 492:34]
  wire [1:0] _GEN_130 = _T_6 ? ic_pht_io_lu_cnt1 : _GEN_111; // @[src/main/scala/fpga/Core.scala 449:23 493:34]
  wire [2:0] _GEN_131 = _T_6 ? _GEN_50 : _GEN_100; // @[src/main/scala/fpga/Core.scala 449:23]
  wire [31:0] _GEN_132 = _T_6 ? ic_reg_inst2 : _GEN_104; // @[src/main/scala/fpga/Core.scala 449:23 349:34]
  wire [31:0] _GEN_137 = _T_3 ? _io_imem_addr_T_2 : _GEN_115; // @[src/main/scala/fpga/Core.scala 449:23 451:26]
  wire [30:0] _GEN_138 = _T_3 ? ic_imem_addr_4 : _GEN_116; // @[src/main/scala/fpga/Core.scala 449:23 452:26]
  wire  _GEN_160 = ~io_imem_valid ? ic_reg_half_rdy : 1'h1; // @[src/main/scala/fpga/Core.scala 376:19 398:98 400:21]
  wire  _GEN_161 = ~io_imem_valid ? 1'h0 : ic_reg_read_rdy; // @[src/main/scala/fpga/Core.scala 377:15 398:98 401:21]
  wire  _GEN_162 = ~io_imem_valid ? 1'h0 : ic_reg_half_rdy; // @[src/main/scala/fpga/Core.scala 378:15 398:98 402:21]
  wire  _GEN_163 = ~io_imem_valid ? _GEN_33 : _GEN_33; // @[src/main/scala/fpga/Core.scala 398:98]
  wire [30:0] _GEN_164 = ~io_imem_valid ? _GEN_34 : _GEN_34; // @[src/main/scala/fpga/Core.scala 398:98]
  wire [1:0] _GEN_165 = ~io_imem_valid ? _GEN_35 : _GEN_35; // @[src/main/scala/fpga/Core.scala 398:98]
  wire [31:0] _GEN_175 = ~io_imem_valid ? _io_imem_addr_T : _GEN_137; // @[src/main/scala/fpga/Core.scala 373:16 398:98]
  wire [30:0] _GEN_176 = ~io_imem_valid ? ic_reg_imem_addr : _GEN_138; // @[src/main/scala/fpga/Core.scala 343:33 398:98]
  wire  _GEN_191 = if1_is_jump | _GEN_160; // @[src/main/scala/fpga/Core.scala 376:19 389:21]
  wire  ic_read_rdy = if1_is_jump ? ic_reg_read_rdy : _GEN_161; // @[src/main/scala/fpga/Core.scala 377:15 389:21]
  wire  ic_half_rdy = if1_is_jump ? ic_reg_half_rdy : _GEN_162; // @[src/main/scala/fpga/Core.scala 378:15 389:21]
  wire  ic_bp_taken = if1_is_jump ? 1'h0 : _GEN_163; // @[src/main/scala/fpga/Core.scala 384:19 389:21]
  wire [30:0] ic_bp_taken_pc = if1_is_jump ? 31'h0 : _GEN_164; // @[src/main/scala/fpga/Core.scala 385:19 389:21]
  wire [1:0] ic_bp_cnt = if1_is_jump ? 2'h0 : _GEN_165; // @[src/main/scala/fpga/Core.scala 386:19 389:21]
  wire  if2_is_inst_read = ic_read_rdy | ic_half_rdy & if2_is_half_inst; // @[src/main/scala/fpga/Core.scala 585:38]
  wire  _if2_is_valid_inst_T = ~ex2_reg_is_br; // @[src/main/scala/fpga/Core.scala 587:27]
  wire  _if2_is_valid_inst_T_1 = ~id_reg_is_bp_fail; // @[src/main/scala/fpga/Core.scala 587:45]
  wire  if2_is_valid_inst = ~ex2_reg_is_br & ~id_reg_is_bp_fail & ~id_reg_bp_taken & if2_is_inst_read; // @[src/main/scala/fpga/Core.scala 587:84]
  wire [31:0] if2_inst = if2_is_valid_inst ? ic_data_out : 32'h13; // @[src/main/scala/fpga/Core.scala 588:21]
  wire  if2_bp_taken = if2_is_valid_inst & ic_bp_taken; // @[src/main/scala/fpga/Core.scala 589:40]
  wire [31:0] _T_31 = {ic_reg_addr_out,1'h0}; // @[src/main/scala/fpga/Core.scala 603:46]
  wire  _T_33 = ~reset; // @[src/main/scala/fpga/Core.scala 603:9]
  wire  _rrd_stall_T_1 = ~rrd_reg_op1_sel; // @[src/main/scala/fpga/Core.scala 1150:25]
  wire  _rrd_stall_T_3 = ~rrd_reg_op2_sel; // @[src/main/scala/fpga/Core.scala 1151:25]
  wire  _rrd_stall_T_4 = ~rrd_reg_op2_sel & scoreboard_rrd_stall_MPORT_1_data; // @[src/main/scala/fpga/Core.scala 1151:39]
  wire  _rrd_stall_T_5 = ~rrd_reg_op1_sel & scoreboard_rrd_stall_MPORT_data | _rrd_stall_T_4; // @[src/main/scala/fpga/Core.scala 1150:72]
  wire  _rrd_stall_T_7 = rrd_reg_op3_sel == 2'h2 & scoreboard_rrd_stall_MPORT_2_data; // @[src/main/scala/fpga/Core.scala 1152:39]
  wire  _rrd_stall_T_8 = _rrd_stall_T_5 | _rrd_stall_T_7; // @[src/main/scala/fpga/Core.scala 1151:72]
  wire  _rrd_stall_T_10 = rrd_reg_rf_wen & scoreboard_rrd_stall_MPORT_3_data; // @[src/main/scala/fpga/Core.scala 1153:35]
  wire  _rrd_stall_T_11 = _rrd_stall_T_8 | _rrd_stall_T_10; // @[src/main/scala/fpga/Core.scala 1152:72]
  wire  rrd_stall = _if2_is_valid_inst_T & _rrd_stall_T_11; // @[src/main/scala/fpga/Core.scala 1149:20]
  wire  mem1_mem_stall = mem1_reg_is_mem_store & ~io_dmem_wready; // @[src/main/scala/fpga/Core.scala 1800:89]
  wire  _mem1_dram_stall_T_3 = mem1_reg_is_dram_store & ~io_cache_wready; // @[src/main/scala/fpga/Core.scala 1803:29]
  wire  _mem1_dram_stall_T_4 = mem1_reg_is_dram_load & ~io_cache_rready | _mem1_dram_stall_T_3; // @[src/main/scala/fpga/Core.scala 1802:49]
  wire  _mem1_dram_stall_T_5 = mem1_reg_is_dram_fence & io_cache_ibusy; // @[src/main/scala/fpga/Core.scala 1804:29]
  wire  mem1_dram_stall = _mem1_dram_stall_T_4 | _mem1_dram_stall_T_5; // @[src/main/scala/fpga/Core.scala 1803:50]
  wire  mem2_dram_stall = mem2_reg_is_dram_load & ~io_cache_rvalid; // @[src/main/scala/fpga/Core.scala 1834:48]
  wire  mem_stall = mem1_mem_stall | mem1_dram_stall | mem1_reg_unaligned | mem2_dram_stall; // @[src/main/scala/fpga/Core.scala 1806:72]
  wire  ex2_stall = mem_stall | ex2_reg_div_stall; // @[src/main/scala/fpga/Core.scala 1538:26]
  wire  id_stall = rrd_stall | ex2_stall; // @[src/main/scala/fpga/Core.scala 626:25]
  wire [31:0] id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[src/main/scala/fpga/Core.scala 630:20]
  wire  id_is_half = id_inst[1:0] != 2'h3; // @[src/main/scala/fpga/Core.scala 632:35]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[src/main/scala/fpga/Core.scala 634:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[src/main/scala/fpga/Core.scala 635:28]
  wire [4:0] id_rs3_addr = id_inst[31:27]; // @[src/main/scala/fpga/Core.scala 636:28]
  wire [4:0] id_w_wb_addr = id_inst[11:7]; // @[src/main/scala/fpga/Core.scala 637:30]
  wire [4:0] id_c_rs2_addr = id_inst[6:2]; // @[src/main/scala/fpga/Core.scala 642:31]
  wire [4:0] id_c_rs1p_addr = {2'h1,id_inst[9:7]}; // @[src/main/scala/fpga/Core.scala 644:27]
  wire [4:0] id_c_rs2p_addr = {2'h1,id_inst[4:2]}; // @[src/main/scala/fpga/Core.scala 645:27]
  wire [4:0] id_c_rs3p_addr = {2'h1,id_inst[12:10]}; // @[src/main/scala/fpga/Core.scala 646:27]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[src/main/scala/fpga/Core.scala 650:25]
  wire [19:0] _id_imm_i_sext_T_2 = id_imm_i[11] ? 20'hfffff : 20'h0; // @[src/main/scala/fpga/Core.scala 651:31]
  wire [31:0] id_imm_i_sext = {_id_imm_i_sext_T_2,id_imm_i}; // @[src/main/scala/fpga/Core.scala 651:26]
  wire [11:0] id_imm_s = {id_inst[31:25],id_w_wb_addr}; // @[src/main/scala/fpga/Core.scala 652:21]
  wire [19:0] _id_imm_s_sext_T_2 = id_imm_s[11] ? 20'hfffff : 20'h0; // @[src/main/scala/fpga/Core.scala 653:31]
  wire [31:0] id_imm_s_sext = {_id_imm_s_sext_T_2,id_inst[31:25],id_w_wb_addr}; // @[src/main/scala/fpga/Core.scala 653:26]
  wire [11:0] id_imm_b = {id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8]}; // @[src/main/scala/fpga/Core.scala 654:21]
  wire [18:0] _id_imm_b_sext_T_2 = id_imm_b[11] ? 19'h7ffff : 19'h0; // @[src/main/scala/fpga/Core.scala 655:31]
  wire [31:0] id_imm_b_sext = {_id_imm_b_sext_T_2,id_inst[31],id_inst[7],id_inst[30:25],id_inst[11:8],1'h0}; // @[src/main/scala/fpga/Core.scala 655:26]
  wire [19:0] id_imm_j = {id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21]}; // @[src/main/scala/fpga/Core.scala 656:21]
  wire [10:0] _id_imm_j_sext_T_2 = id_imm_j[19] ? 11'h7ff : 11'h0; // @[src/main/scala/fpga/Core.scala 657:31]
  wire [31:0] id_imm_j_sext = {_id_imm_j_sext_T_2,id_inst[31],id_inst[19:12],id_inst[20],id_inst[30:21],1'h0}; // @[src/main/scala/fpga/Core.scala 657:26]
  wire [19:0] id_imm_u = id_inst[31:12]; // @[src/main/scala/fpga/Core.scala 658:25]
  wire [31:0] id_imm_u_shifted = {id_imm_u,12'h0}; // @[src/main/scala/fpga/Core.scala 659:29]
  wire [31:0] id_imm_z_uext = {27'h0,id_rs1_addr}; // @[src/main/scala/fpga/Core.scala 661:26]
  wire [26:0] _id_c_imm_i_T_2 = id_inst[12] ? 27'h7ffffff : 27'h0; // @[src/main/scala/fpga/Core.scala 663:28]
  wire [31:0] id_c_imm_i = {_id_c_imm_i_T_2,id_c_rs2_addr}; // @[src/main/scala/fpga/Core.scala 663:23]
  wire [14:0] _id_c_imm_iu_T_2 = id_inst[12] ? 15'h7fff : 15'h0; // @[src/main/scala/fpga/Core.scala 664:29]
  wire [31:0] id_c_imm_iu = {_id_c_imm_iu_T_2,id_c_rs2_addr,12'h0}; // @[src/main/scala/fpga/Core.scala 664:24]
  wire [22:0] _id_c_imm_i16_T_2 = id_inst[12] ? 23'h7fffff : 23'h0; // @[src/main/scala/fpga/Core.scala 665:30]
  wire [31:0] id_c_imm_i16 = {_id_c_imm_i16_T_2,id_inst[4:3],id_inst[5],id_inst[2],id_inst[6],4'h0}; // @[src/main/scala/fpga/Core.scala 665:25]
  wire [31:0] id_c_imm_sl = {24'h0,id_inst[3:2],id_inst[12],id_inst[6:4],2'h0}; // @[src/main/scala/fpga/Core.scala 666:24]
  wire [31:0] id_c_imm_ss = {24'h0,id_inst[8:7],id_inst[12:9],2'h0}; // @[src/main/scala/fpga/Core.scala 667:24]
  wire [31:0] id_c_imm_iw = {22'h0,id_inst[10:7],id_inst[12:11],id_inst[5],id_inst[6],2'h0}; // @[src/main/scala/fpga/Core.scala 668:24]
  wire [31:0] id_c_imm_ls = {25'h0,id_inst[5],id_inst[12:10],id_inst[6],2'h0}; // @[src/main/scala/fpga/Core.scala 669:24]
  wire [23:0] _id_c_imm_b_T_2 = id_inst[12] ? 24'hffffff : 24'h0; // @[src/main/scala/fpga/Core.scala 670:28]
  wire [31:0] id_c_imm_b = {_id_c_imm_b_T_2,id_inst[6:5],id_inst[2],id_inst[11:10],id_inst[4:3],1'h0}; // @[src/main/scala/fpga/Core.scala 670:23]
  wire [20:0] _id_c_imm_j_T_2 = id_inst[12] ? 21'h1fffff : 21'h0; // @[src/main/scala/fpga/Core.scala 671:28]
  wire [31:0] id_c_imm_j = {_id_c_imm_j_T_2,id_inst[8],id_inst[10:9],id_inst[6],id_inst[7],id_inst[2],id_inst[11],
    id_inst[5:3],1'h0}; // @[src/main/scala/fpga/Core.scala 671:23]
  wire [31:0] id_c_imm_b2 = {_id_c_imm_i_T_2,id_inst[11:10],id_inst[6:5],1'h0}; // @[src/main/scala/fpga/Core.scala 673:24]
  wire [31:0] id_c_imm_u = {12'h0,id_inst[12:5],12'h0}; // @[src/main/scala/fpga/Core.scala 674:23]
  wire [31:0] id_c_imm_lsb = {27'h0,id_inst[11:10],id_inst[6:5],id_inst[12]}; // @[src/main/scala/fpga/Core.scala 675:25]
  wire [31:0] id_c_imm_lsh = {28'h0,id_inst[10],id_inst[6:5],1'h0}; // @[src/main/scala/fpga/Core.scala 676:25]
  wire [31:0] id_c_imm_sw0 = {25'h0,id_inst[5:3],id_inst[10],id_inst[6],2'h0}; // @[src/main/scala/fpga/Core.scala 677:25]
  wire [31:0] id_c_imm_sb0 = {28'h0,id_inst[10],id_inst[6:4]}; // @[src/main/scala/fpga/Core.scala 678:25]
  wire [32:0] id_c_imm_sh0 = {28'h0,id_inst[4],id_inst[10],id_inst[6:5],1'h0}; // @[src/main/scala/fpga/Core.scala 679:25]
  wire [25:0] _id_c_imm_a2w_T_2 = id_inst[12] ? 26'h3ffffff : 26'h0; // @[src/main/scala/fpga/Core.scala 680:30]
  wire [31:0] id_c_imm_a2w = {_id_c_imm_a2w_T_2,id_inst[5],id_inst[11:10],id_inst[6],2'h0}; // @[src/main/scala/fpga/Core.scala 680:25]
  wire [29:0] _id_c_imm_a2b_T_2 = id_inst[12] ? 30'h3fffffff : 30'h0; // @[src/main/scala/fpga/Core.scala 681:30]
  wire [31:0] id_c_imm_a2b = {_id_c_imm_a2b_T_2,id_inst[11:10]}; // @[src/main/scala/fpga/Core.scala 681:25]
  wire [31:0] _csignals_T = id_inst & 32'h707f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_1 = 32'h3 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_3 = 32'h4003 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_5 = 32'h23 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_7 = 32'h1003 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_9 = 32'h5003 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_11 = 32'h1023 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_13 = 32'h2003 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_15 = 32'h2023 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_16 = id_inst & 32'hfe00707f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_17 = 32'h33 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_19 = 32'h13 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_21 = 32'h40000033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_23 = 32'h7033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_25 = 32'h6033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_27 = 32'h4033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_29 = 32'h7013 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_31 = 32'h6013 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_33 = 32'h4013 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_35 = 32'h1033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_37 = 32'h5033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_39 = 32'h40005033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_41 = 32'h1013 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_43 = 32'h5013 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_45 = 32'h40005013 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_47 = 32'h2033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_49 = 32'h3033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_51 = 32'h2013 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_53 = 32'h3013 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_55 = 32'h63 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_57 = 32'h1063 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_59 = 32'h5063 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_61 = 32'h7063 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_63 = 32'h4063 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_65 = 32'h6063 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_66 = id_inst & 32'h7f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_67 = 32'h6f == _csignals_T_66; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_69 = 32'h67 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_71 = 32'h37 == _csignals_T_66; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_73 = 32'h17 == _csignals_T_66; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_75 = 32'h1073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_77 = 32'h5073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_79 = 32'h2073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_81 = 32'h6073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_83 = 32'h3073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_85 = 32'h7073 == _csignals_T; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_87 = 32'h73 == id_inst; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_89 = 32'h30200073 == id_inst; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_91 = 32'h100f == id_inst; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_93 = 32'h2000033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_95 = 32'h2001033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_97 = 32'h2003033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_99 = 32'h2002033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_101 = 32'h2004033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_103 = 32'h2005033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_105 = 32'h2006033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_107 = 32'h2007033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_109 = 32'ha006033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_111 = 32'ha007033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_113 = 32'ha004033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_115 = 32'ha005033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_116 = id_inst & 32'hfff0707f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_117 = 32'h60001013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_119 = 32'h60101013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_121 = 32'h60201013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_123 = 32'h69805013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_125 = 32'h60401013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_127 = 32'h60501013 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_129 = 32'h8004033 == _csignals_T_116; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_131 = 32'h40007033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_133 = 32'h40006033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_135 = 32'h40004033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_137 = 32'h60001033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_139 = 32'h60005033 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_141 = 32'h60005013 == _csignals_T_16; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_142 = id_inst & 32'h600707f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_143 = 32'h6005033 == _csignals_T_142; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_145 = 32'h4001033 == _csignals_T_142; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_147 = 32'h4005033 == _csignals_T_142; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_149 = 32'h4005013 == _csignals_T_142; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_150 = id_inst & 32'hffff; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_151 = 32'h0 == _csignals_T_150; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_152 = id_inst & 32'he003; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_153 = 32'h0 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_154 = id_inst & 32'hef83; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_155 = 32'h6101 == _csignals_T_154; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_157 = 32'h1 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_159 = 32'h4000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_161 = 32'hc000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_163 = 32'h4001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_165 = 32'h6001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_166 = id_inst & 32'hec03; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_167 = 32'h8401 == _csignals_T_166; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_169 = 32'h8001 == _csignals_T_166; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_171 = 32'h8801 == _csignals_T_166; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_172 = id_inst & 32'hfc63; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_173 = 32'h8c01 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_175 = 32'h8c21 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_177 = 32'h8c41 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_179 = 32'h8c61 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_181 = 32'h2 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_183 = 32'ha001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_185 = 32'hc001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_187 = 32'he001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_188 = id_inst & 32'hf07f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_189 = 32'h8002 == _csignals_T_188; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_191 = 32'h9002 == _csignals_T_188; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_193 = 32'h2001 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_195 = 32'h4002 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_197 = 32'hc002 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_198 = id_inst & 32'hf003; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_199 = 32'h8002 == _csignals_T_198; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_201 = 32'h9002 == _csignals_T_198; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_203 = 32'h2000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_205 = 32'h6000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_206 = id_inst & 32'hf803; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_207 = 32'h2002 == _csignals_T_206; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_209 = 32'h2802 == _csignals_T_206; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_211 = 32'h3002 == _csignals_T_206; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_212 = id_inst & 32'hf807; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_213 = 32'h3802 == _csignals_T_212; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_214 = id_inst & 32'hf80f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_215 = 32'h3806 == _csignals_T_214; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_217 = 32'h380e == _csignals_T_214; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_219 = 32'h6002 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_221 = 32'he000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_223 = 32'h9c41 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_224 = id_inst & 32'hfc7f; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_225 = 32'h9c61 == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_227 = 32'h9c65 == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_229 = 32'h9c6d == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_231 = 32'h9c69 == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_233 = 32'h9c75 == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_235 = 32'h9c79 == _csignals_T_224; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_237 = 32'h8000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_239 = 32'ha000 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_241 = 32'ha002 == _csignals_T_152; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [31:0] _csignals_T_242 = id_inst & 32'he063; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_243 = 32'he002 == _csignals_T_242; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_245 = 32'he022 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_247 = 32'hf022 == _csignals_T_172; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_249 = 32'he022 == _csignals_T_242; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_251 = 32'he042 == _csignals_T_242; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire  _csignals_T_253 = 32'he062 == _csignals_T_242; // @[src/main/scala/chisel3/util/Lookup.scala 31:38]
  wire [3:0] _csignals_T_254 = _csignals_T_253 ? 4'h7 : 4'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_255 = _csignals_T_251 ? 4'h6 : _csignals_T_254; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_256 = _csignals_T_249 ? 4'h0 : _csignals_T_255; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_257 = _csignals_T_247 ? 4'h7 : _csignals_T_256; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_258 = _csignals_T_245 ? 4'h7 : _csignals_T_257; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_259 = _csignals_T_243 ? 4'h0 : _csignals_T_258; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_260 = _csignals_T_241 ? 4'h0 : _csignals_T_259; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_261 = _csignals_T_239 ? 4'h9 : _csignals_T_260; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_262 = _csignals_T_237 ? 4'h8 : _csignals_T_261; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_263 = _csignals_T_235 ? 4'h8 : _csignals_T_262; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_264 = _csignals_T_233 ? 4'h1 : _csignals_T_263; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_265 = _csignals_T_231 ? 4'ha : _csignals_T_264; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_266 = _csignals_T_229 ? 4'h9 : _csignals_T_265; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_267 = _csignals_T_227 ? 4'h8 : _csignals_T_266; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_268 = _csignals_T_225 ? 4'h2 : _csignals_T_267; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_269 = _csignals_T_223 ? 4'h8 : _csignals_T_268; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_270 = _csignals_T_221 ? 4'h0 : _csignals_T_269; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_271 = _csignals_T_219 ? 4'h0 : _csignals_T_270; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_272 = _csignals_T_217 ? 4'h0 : _csignals_T_271; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_273 = _csignals_T_215 ? 4'h0 : _csignals_T_272; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_274 = _csignals_T_213 ? 4'h0 : _csignals_T_273; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_275 = _csignals_T_211 ? 4'h0 : _csignals_T_274; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_276 = _csignals_T_209 ? 4'h0 : _csignals_T_275; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_277 = _csignals_T_207 ? 4'h0 : _csignals_T_276; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_278 = _csignals_T_205 ? 4'h0 : _csignals_T_277; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_279 = _csignals_T_203 ? 4'h0 : _csignals_T_278; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_280 = _csignals_T_201 ? 4'h0 : _csignals_T_279; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_281 = _csignals_T_199 ? 4'h0 : _csignals_T_280; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_282 = _csignals_T_197 ? 4'h0 : _csignals_T_281; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_283 = _csignals_T_195 ? 4'h0 : _csignals_T_282; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_284 = _csignals_T_193 ? 4'h0 : _csignals_T_283; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_285 = _csignals_T_191 ? 4'h0 : _csignals_T_284; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_286 = _csignals_T_189 ? 4'h0 : _csignals_T_285; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_287 = _csignals_T_187 ? 4'h9 : _csignals_T_286; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_288 = _csignals_T_185 ? 4'h8 : _csignals_T_287; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_289 = _csignals_T_183 ? 4'h0 : _csignals_T_288; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_290 = _csignals_T_181 ? 4'h4 : _csignals_T_289; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_291 = _csignals_T_179 ? 4'h2 : _csignals_T_290; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_292 = _csignals_T_177 ? 4'h3 : _csignals_T_291; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_293 = _csignals_T_175 ? 4'h1 : _csignals_T_292; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_294 = _csignals_T_173 ? 4'h8 : _csignals_T_293; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_295 = _csignals_T_171 ? 4'h2 : _csignals_T_294; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_296 = _csignals_T_169 ? 4'h5 : _csignals_T_295; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_297 = _csignals_T_167 ? 4'h5 : _csignals_T_296; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_298 = _csignals_T_165 ? 4'h0 : _csignals_T_297; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_299 = _csignals_T_163 ? 4'h0 : _csignals_T_298; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_300 = _csignals_T_161 ? 4'h0 : _csignals_T_299; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_301 = _csignals_T_159 ? 4'h0 : _csignals_T_300; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_302 = _csignals_T_157 ? 4'h0 : _csignals_T_301; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_303 = _csignals_T_155 ? 4'h0 : _csignals_T_302; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_304 = _csignals_T_153 ? 4'h0 : _csignals_T_303; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_305 = _csignals_T_151 ? 4'h0 : _csignals_T_304; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_306 = _csignals_T_149 ? 4'h5 : _csignals_T_305; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_307 = _csignals_T_147 ? 4'h5 : _csignals_T_306; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_308 = _csignals_T_145 ? 4'h4 : _csignals_T_307; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_309 = _csignals_T_143 ? 4'hf : _csignals_T_308; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_310 = _csignals_T_141 ? 4'h5 : _csignals_T_309; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_311 = _csignals_T_139 ? 4'h5 : _csignals_T_310; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_312 = _csignals_T_137 ? 4'h4 : _csignals_T_311; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_313 = _csignals_T_135 ? 4'h9 : _csignals_T_312; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_314 = _csignals_T_133 ? 4'hb : _csignals_T_313; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_315 = _csignals_T_131 ? 4'ha : _csignals_T_314; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_316 = _csignals_T_129 ? 4'ha : _csignals_T_315; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_317 = _csignals_T_127 ? 4'h9 : _csignals_T_316; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_318 = _csignals_T_125 ? 4'h8 : _csignals_T_317; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_319 = _csignals_T_123 ? 4'h7 : _csignals_T_318; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_320 = _csignals_T_121 ? 4'h6 : _csignals_T_319; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_321 = _csignals_T_119 ? 4'h5 : _csignals_T_320; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_322 = _csignals_T_117 ? 4'h4 : _csignals_T_321; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_323 = _csignals_T_115 ? 4'hf : _csignals_T_322; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_324 = _csignals_T_113 ? 4'he : _csignals_T_323; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_325 = _csignals_T_111 ? 4'hd : _csignals_T_324; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_326 = _csignals_T_109 ? 4'hc : _csignals_T_325; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_327 = _csignals_T_107 ? 4'hf : _csignals_T_326; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_328 = _csignals_T_105 ? 4'hd : _csignals_T_327; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_329 = _csignals_T_103 ? 4'he : _csignals_T_328; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_330 = _csignals_T_101 ? 4'hc : _csignals_T_329; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_331 = _csignals_T_99 ? 4'hb : _csignals_T_330; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_332 = _csignals_T_97 ? 4'ha : _csignals_T_331; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_333 = _csignals_T_95 ? 4'h9 : _csignals_T_332; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_334 = _csignals_T_93 ? 4'h8 : _csignals_T_333; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_335 = _csignals_T_91 ? 4'h0 : _csignals_T_334; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_336 = _csignals_T_89 ? 4'hf : _csignals_T_335; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_337 = _csignals_T_87 ? 4'he : _csignals_T_336; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_338 = _csignals_T_85 ? 4'h0 : _csignals_T_337; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_339 = _csignals_T_83 ? 4'h0 : _csignals_T_338; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_340 = _csignals_T_81 ? 4'h0 : _csignals_T_339; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_341 = _csignals_T_79 ? 4'h0 : _csignals_T_340; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_342 = _csignals_T_77 ? 4'h0 : _csignals_T_341; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_343 = _csignals_T_75 ? 4'h0 : _csignals_T_342; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_344 = _csignals_T_73 ? 4'h0 : _csignals_T_343; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_345 = _csignals_T_71 ? 4'h0 : _csignals_T_344; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_346 = _csignals_T_69 ? 4'h0 : _csignals_T_345; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_347 = _csignals_T_67 ? 4'h0 : _csignals_T_346; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_348 = _csignals_T_65 ? 4'hc : _csignals_T_347; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_349 = _csignals_T_63 ? 4'ha : _csignals_T_348; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_350 = _csignals_T_61 ? 4'hd : _csignals_T_349; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_351 = _csignals_T_59 ? 4'hb : _csignals_T_350; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_352 = _csignals_T_57 ? 4'h9 : _csignals_T_351; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_353 = _csignals_T_55 ? 4'h8 : _csignals_T_352; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_354 = _csignals_T_53 ? 4'h7 : _csignals_T_353; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_355 = _csignals_T_51 ? 4'h6 : _csignals_T_354; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_356 = _csignals_T_49 ? 4'h7 : _csignals_T_355; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_357 = _csignals_T_47 ? 4'h6 : _csignals_T_356; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_358 = _csignals_T_45 ? 4'h5 : _csignals_T_357; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_359 = _csignals_T_43 ? 4'h5 : _csignals_T_358; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_360 = _csignals_T_41 ? 4'h4 : _csignals_T_359; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_361 = _csignals_T_39 ? 4'h5 : _csignals_T_360; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_362 = _csignals_T_37 ? 4'h5 : _csignals_T_361; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_363 = _csignals_T_35 ? 4'h4 : _csignals_T_362; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_364 = _csignals_T_33 ? 4'h1 : _csignals_T_363; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_365 = _csignals_T_31 ? 4'h3 : _csignals_T_364; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_366 = _csignals_T_29 ? 4'h2 : _csignals_T_365; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_367 = _csignals_T_27 ? 4'h1 : _csignals_T_366; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_368 = _csignals_T_25 ? 4'h3 : _csignals_T_367; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_369 = _csignals_T_23 ? 4'h2 : _csignals_T_368; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_370 = _csignals_T_21 ? 4'h8 : _csignals_T_369; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_371 = _csignals_T_19 ? 4'h0 : _csignals_T_370; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_372 = _csignals_T_17 ? 4'h0 : _csignals_T_371; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_373 = _csignals_T_15 ? 4'h0 : _csignals_T_372; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_374 = _csignals_T_13 ? 4'h0 : _csignals_T_373; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_375 = _csignals_T_11 ? 4'h0 : _csignals_T_374; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_376 = _csignals_T_9 ? 4'h0 : _csignals_T_375; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_377 = _csignals_T_7 ? 4'h0 : _csignals_T_376; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_378 = _csignals_T_5 ? 4'h0 : _csignals_T_377; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] _csignals_T_379 = _csignals_T_3 ? 4'h0 : _csignals_T_378; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [3:0] csignals_0 = _csignals_T_1 ? 4'h0 : _csignals_T_379; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_380 = _csignals_T_253 ? 3'h7 : 3'h4; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_381 = _csignals_T_251 ? 3'h7 : _csignals_T_380; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_382 = _csignals_T_249 ? 3'h7 : _csignals_T_381; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_383 = _csignals_T_247 ? 3'h0 : _csignals_T_382; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_384 = _csignals_T_245 ? 3'h7 : _csignals_T_383; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_385 = _csignals_T_243 ? 3'h7 : _csignals_T_384; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_386 = _csignals_T_241 ? 3'h7 : _csignals_T_385; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_387 = _csignals_T_239 ? 3'h7 : _csignals_T_386; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_388 = _csignals_T_237 ? 3'h7 : _csignals_T_387; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_389 = _csignals_T_235 ? 3'h0 : _csignals_T_388; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_390 = _csignals_T_233 ? 3'h7 : _csignals_T_389; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_391 = _csignals_T_231 ? 3'h7 : _csignals_T_390; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_392 = _csignals_T_229 ? 3'h7 : _csignals_T_391; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_393 = _csignals_T_227 ? 3'h7 : _csignals_T_392; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_394 = _csignals_T_225 ? 3'h7 : _csignals_T_393; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_395 = _csignals_T_223 ? 3'h7 : _csignals_T_394; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_396 = _csignals_T_221 ? 3'h1 : _csignals_T_395; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_397 = _csignals_T_219 ? 3'h7 : _csignals_T_396; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_398 = _csignals_T_217 ? 3'h7 : _csignals_T_397; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_399 = _csignals_T_215 ? 3'h7 : _csignals_T_398; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_400 = _csignals_T_213 ? 3'h7 : _csignals_T_399; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_401 = _csignals_T_211 ? 3'h7 : _csignals_T_400; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_402 = _csignals_T_209 ? 3'h7 : _csignals_T_401; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_403 = _csignals_T_207 ? 3'h7 : _csignals_T_402; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_404 = _csignals_T_205 ? 3'h7 : _csignals_T_403; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_405 = _csignals_T_203 ? 3'h7 : _csignals_T_404; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_406 = _csignals_T_201 ? 3'h5 : _csignals_T_405; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_407 = _csignals_T_199 ? 3'h0 : _csignals_T_406; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_408 = _csignals_T_197 ? 3'h6 : _csignals_T_407; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_409 = _csignals_T_195 ? 3'h6 : _csignals_T_408; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_410 = _csignals_T_193 ? 3'h1 : _csignals_T_409; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_411 = _csignals_T_191 ? 3'h5 : _csignals_T_410; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_412 = _csignals_T_189 ? 3'h5 : _csignals_T_411; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_413 = _csignals_T_187 ? 3'h7 : _csignals_T_412; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_414 = _csignals_T_185 ? 3'h7 : _csignals_T_413; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_415 = _csignals_T_183 ? 3'h1 : _csignals_T_414; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_416 = _csignals_T_181 ? 3'h5 : _csignals_T_415; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_417 = _csignals_T_179 ? 3'h7 : _csignals_T_416; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_418 = _csignals_T_177 ? 3'h7 : _csignals_T_417; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_419 = _csignals_T_175 ? 3'h7 : _csignals_T_418; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_420 = _csignals_T_173 ? 3'h7 : _csignals_T_419; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_421 = _csignals_T_171 ? 3'h7 : _csignals_T_420; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_422 = _csignals_T_169 ? 3'h7 : _csignals_T_421; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_423 = _csignals_T_167 ? 3'h7 : _csignals_T_422; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_424 = _csignals_T_165 ? 3'h0 : _csignals_T_423; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_425 = _csignals_T_163 ? 3'h0 : _csignals_T_424; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_426 = _csignals_T_161 ? 3'h7 : _csignals_T_425; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_427 = _csignals_T_159 ? 3'h7 : _csignals_T_426; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_428 = _csignals_T_157 ? 3'h5 : _csignals_T_427; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_429 = _csignals_T_155 ? 3'h5 : _csignals_T_428; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_430 = _csignals_T_153 ? 3'h6 : _csignals_T_429; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_431 = _csignals_T_151 ? 3'h0 : _csignals_T_430; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_432 = _csignals_T_149 ? 3'h4 : _csignals_T_431; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_433 = _csignals_T_147 ? 3'h4 : _csignals_T_432; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_434 = _csignals_T_145 ? 3'h4 : _csignals_T_433; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_435 = _csignals_T_143 ? 3'h4 : _csignals_T_434; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_436 = _csignals_T_141 ? 3'h4 : _csignals_T_435; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_437 = _csignals_T_139 ? 3'h4 : _csignals_T_436; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_438 = _csignals_T_137 ? 3'h4 : _csignals_T_437; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_439 = _csignals_T_135 ? 3'h4 : _csignals_T_438; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_440 = _csignals_T_133 ? 3'h4 : _csignals_T_439; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_441 = _csignals_T_131 ? 3'h4 : _csignals_T_440; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_442 = _csignals_T_129 ? 3'h4 : _csignals_T_441; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_443 = _csignals_T_127 ? 3'h4 : _csignals_T_442; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_444 = _csignals_T_125 ? 3'h4 : _csignals_T_443; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_445 = _csignals_T_123 ? 3'h4 : _csignals_T_444; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_446 = _csignals_T_121 ? 3'h4 : _csignals_T_445; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_447 = _csignals_T_119 ? 3'h4 : _csignals_T_446; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_448 = _csignals_T_117 ? 3'h4 : _csignals_T_447; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_449 = _csignals_T_115 ? 3'h4 : _csignals_T_448; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_450 = _csignals_T_113 ? 3'h4 : _csignals_T_449; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_451 = _csignals_T_111 ? 3'h4 : _csignals_T_450; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_452 = _csignals_T_109 ? 3'h4 : _csignals_T_451; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_453 = _csignals_T_107 ? 3'h4 : _csignals_T_452; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_454 = _csignals_T_105 ? 3'h4 : _csignals_T_453; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_455 = _csignals_T_103 ? 3'h4 : _csignals_T_454; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_456 = _csignals_T_101 ? 3'h4 : _csignals_T_455; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_457 = _csignals_T_99 ? 3'h4 : _csignals_T_456; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_458 = _csignals_T_97 ? 3'h4 : _csignals_T_457; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_459 = _csignals_T_95 ? 3'h4 : _csignals_T_458; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_460 = _csignals_T_93 ? 3'h4 : _csignals_T_459; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_461 = _csignals_T_91 ? 3'h0 : _csignals_T_460; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_462 = _csignals_T_89 ? 3'h0 : _csignals_T_461; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_463 = _csignals_T_87 ? 3'h0 : _csignals_T_462; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_464 = _csignals_T_85 ? 3'h2 : _csignals_T_463; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_465 = _csignals_T_83 ? 3'h4 : _csignals_T_464; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_466 = _csignals_T_81 ? 3'h2 : _csignals_T_465; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_467 = _csignals_T_79 ? 3'h4 : _csignals_T_466; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_468 = _csignals_T_77 ? 3'h2 : _csignals_T_467; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_469 = _csignals_T_75 ? 3'h4 : _csignals_T_468; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_470 = _csignals_T_73 ? 3'h1 : _csignals_T_469; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_471 = _csignals_T_71 ? 3'h0 : _csignals_T_470; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_472 = _csignals_T_69 ? 3'h4 : _csignals_T_471; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_473 = _csignals_T_67 ? 3'h1 : _csignals_T_472; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_474 = _csignals_T_65 ? 3'h4 : _csignals_T_473; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_475 = _csignals_T_63 ? 3'h4 : _csignals_T_474; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_476 = _csignals_T_61 ? 3'h4 : _csignals_T_475; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_477 = _csignals_T_59 ? 3'h4 : _csignals_T_476; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_478 = _csignals_T_57 ? 3'h4 : _csignals_T_477; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_479 = _csignals_T_55 ? 3'h4 : _csignals_T_478; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_480 = _csignals_T_53 ? 3'h4 : _csignals_T_479; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_481 = _csignals_T_51 ? 3'h4 : _csignals_T_480; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_482 = _csignals_T_49 ? 3'h4 : _csignals_T_481; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_483 = _csignals_T_47 ? 3'h4 : _csignals_T_482; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_484 = _csignals_T_45 ? 3'h4 : _csignals_T_483; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_485 = _csignals_T_43 ? 3'h4 : _csignals_T_484; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_486 = _csignals_T_41 ? 3'h4 : _csignals_T_485; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_487 = _csignals_T_39 ? 3'h4 : _csignals_T_486; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_488 = _csignals_T_37 ? 3'h4 : _csignals_T_487; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_489 = _csignals_T_35 ? 3'h4 : _csignals_T_488; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_490 = _csignals_T_33 ? 3'h4 : _csignals_T_489; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_491 = _csignals_T_31 ? 3'h4 : _csignals_T_490; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_492 = _csignals_T_29 ? 3'h4 : _csignals_T_491; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_493 = _csignals_T_27 ? 3'h4 : _csignals_T_492; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_494 = _csignals_T_25 ? 3'h4 : _csignals_T_493; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_495 = _csignals_T_23 ? 3'h4 : _csignals_T_494; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_496 = _csignals_T_21 ? 3'h4 : _csignals_T_495; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_497 = _csignals_T_19 ? 3'h4 : _csignals_T_496; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_498 = _csignals_T_17 ? 3'h4 : _csignals_T_497; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_499 = _csignals_T_15 ? 3'h4 : _csignals_T_498; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_500 = _csignals_T_13 ? 3'h4 : _csignals_T_499; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_501 = _csignals_T_11 ? 3'h4 : _csignals_T_500; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_502 = _csignals_T_9 ? 3'h4 : _csignals_T_501; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_503 = _csignals_T_7 ? 3'h4 : _csignals_T_502; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_504 = _csignals_T_5 ? 3'h4 : _csignals_T_503; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_505 = _csignals_T_3 ? 3'h4 : _csignals_T_504; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] csignals_1 = _csignals_T_1 ? 3'h4 : _csignals_T_505; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_506 = _csignals_T_253 ? 5'h3 : 5'h1; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_507 = _csignals_T_251 ? 5'h3 : _csignals_T_506; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_508 = _csignals_T_249 ? 5'h1c : _csignals_T_507; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_509 = _csignals_T_247 ? 5'h7 : _csignals_T_508; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_510 = _csignals_T_245 ? 5'h1a : _csignals_T_509; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_511 = _csignals_T_243 ? 5'h3 : _csignals_T_510; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_512 = _csignals_T_241 ? 5'h1b : _csignals_T_511; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_513 = _csignals_T_239 ? 5'h6 : _csignals_T_512; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_514 = _csignals_T_237 ? 5'h6 : _csignals_T_513; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_515 = _csignals_T_235 ? 5'h7 : _csignals_T_514; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_516 = _csignals_T_233 ? 5'h19 : _csignals_T_515; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_517 = _csignals_T_231 ? 5'h1e : _csignals_T_516; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_518 = _csignals_T_229 ? 5'h1e : _csignals_T_517; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_519 = _csignals_T_227 ? 5'h1e : _csignals_T_518; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_520 = _csignals_T_225 ? 5'h18 : _csignals_T_519; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_521 = _csignals_T_223 ? 5'h6 : _csignals_T_520; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_522 = _csignals_T_221 ? 5'h1d : _csignals_T_521; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_523 = _csignals_T_219 ? 5'h13 : _csignals_T_522; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_524 = _csignals_T_217 ? 5'h17 : _csignals_T_523; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_525 = _csignals_T_215 ? 5'h16 : _csignals_T_524; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_526 = _csignals_T_213 ? 5'h15 : _csignals_T_525; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_527 = _csignals_T_211 ? 5'h14 : _csignals_T_526; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_528 = _csignals_T_209 ? 5'h14 : _csignals_T_527; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_529 = _csignals_T_207 ? 5'h14 : _csignals_T_528; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_530 = _csignals_T_205 ? 5'h13 : _csignals_T_529; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_531 = _csignals_T_203 ? 5'h13 : _csignals_T_530; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_532 = _csignals_T_201 ? 5'h2 : _csignals_T_531; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_533 = _csignals_T_199 ? 5'h2 : _csignals_T_532; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_534 = _csignals_T_197 ? 5'h12 : _csignals_T_533; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_535 = _csignals_T_195 ? 5'h11 : _csignals_T_534; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_536 = _csignals_T_193 ? 5'h10 : _csignals_T_535; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_537 = _csignals_T_191 ? 5'h0 : _csignals_T_536; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_538 = _csignals_T_189 ? 5'h0 : _csignals_T_537; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_539 = _csignals_T_187 ? 5'h0 : _csignals_T_538; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_540 = _csignals_T_185 ? 5'h0 : _csignals_T_539; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_541 = _csignals_T_183 ? 5'h10 : _csignals_T_540; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_542 = _csignals_T_181 ? 5'hd : _csignals_T_541; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_543 = _csignals_T_179 ? 5'h6 : _csignals_T_542; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_544 = _csignals_T_177 ? 5'h6 : _csignals_T_543; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_545 = _csignals_T_175 ? 5'h6 : _csignals_T_544; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_546 = _csignals_T_173 ? 5'h6 : _csignals_T_545; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_547 = _csignals_T_171 ? 5'hd : _csignals_T_546; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_548 = _csignals_T_169 ? 5'hd : _csignals_T_547; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_549 = _csignals_T_167 ? 5'hd : _csignals_T_548; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_550 = _csignals_T_165 ? 5'hf : _csignals_T_549; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_551 = _csignals_T_163 ? 5'hd : _csignals_T_550; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_552 = _csignals_T_161 ? 5'he : _csignals_T_551; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_553 = _csignals_T_159 ? 5'he : _csignals_T_552; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_554 = _csignals_T_157 ? 5'hd : _csignals_T_553; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_555 = _csignals_T_155 ? 5'hc : _csignals_T_554; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_556 = _csignals_T_153 ? 5'hb : _csignals_T_555; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_557 = _csignals_T_151 ? 5'h1e : _csignals_T_556; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_558 = _csignals_T_149 ? 5'h4 : _csignals_T_557; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_559 = _csignals_T_147 ? 5'h1 : _csignals_T_558; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_560 = _csignals_T_145 ? 5'h1 : _csignals_T_559; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_561 = _csignals_T_143 ? 5'h1 : _csignals_T_560; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_562 = _csignals_T_141 ? 5'h4 : _csignals_T_561; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_563 = _csignals_T_139 ? 5'h1 : _csignals_T_562; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_564 = _csignals_T_137 ? 5'h1 : _csignals_T_563; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_565 = _csignals_T_135 ? 5'h1 : _csignals_T_564; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_566 = _csignals_T_133 ? 5'h1 : _csignals_T_565; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_567 = _csignals_T_131 ? 5'h1 : _csignals_T_566; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_568 = _csignals_T_129 ? 5'h1e : _csignals_T_567; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_569 = _csignals_T_127 ? 5'h1e : _csignals_T_568; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_570 = _csignals_T_125 ? 5'h1e : _csignals_T_569; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_571 = _csignals_T_123 ? 5'h1e : _csignals_T_570; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_572 = _csignals_T_121 ? 5'h1e : _csignals_T_571; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_573 = _csignals_T_119 ? 5'h1e : _csignals_T_572; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_574 = _csignals_T_117 ? 5'h1e : _csignals_T_573; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_575 = _csignals_T_115 ? 5'h1 : _csignals_T_574; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_576 = _csignals_T_113 ? 5'h1 : _csignals_T_575; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_577 = _csignals_T_111 ? 5'h1 : _csignals_T_576; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_578 = _csignals_T_109 ? 5'h1 : _csignals_T_577; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_579 = _csignals_T_107 ? 5'h1 : _csignals_T_578; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_580 = _csignals_T_105 ? 5'h1 : _csignals_T_579; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_581 = _csignals_T_103 ? 5'h1 : _csignals_T_580; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_582 = _csignals_T_101 ? 5'h1 : _csignals_T_581; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_583 = _csignals_T_99 ? 5'h1 : _csignals_T_582; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_584 = _csignals_T_97 ? 5'h1 : _csignals_T_583; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_585 = _csignals_T_95 ? 5'h1 : _csignals_T_584; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_586 = _csignals_T_93 ? 5'h1 : _csignals_T_585; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_587 = _csignals_T_91 ? 5'h1e : _csignals_T_586; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_588 = _csignals_T_89 ? 5'h1e : _csignals_T_587; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_589 = _csignals_T_87 ? 5'h1e : _csignals_T_588; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_590 = _csignals_T_85 ? 5'h0 : _csignals_T_589; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_591 = _csignals_T_83 ? 5'h0 : _csignals_T_590; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_592 = _csignals_T_81 ? 5'h0 : _csignals_T_591; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_593 = _csignals_T_79 ? 5'h0 : _csignals_T_592; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_594 = _csignals_T_77 ? 5'h0 : _csignals_T_593; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_595 = _csignals_T_75 ? 5'h0 : _csignals_T_594; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_596 = _csignals_T_73 ? 5'ha : _csignals_T_595; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_597 = _csignals_T_71 ? 5'ha : _csignals_T_596; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_598 = _csignals_T_69 ? 5'h4 : _csignals_T_597; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_599 = _csignals_T_67 ? 5'h9 : _csignals_T_598; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_600 = _csignals_T_65 ? 5'h1 : _csignals_T_599; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_601 = _csignals_T_63 ? 5'h1 : _csignals_T_600; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_602 = _csignals_T_61 ? 5'h1 : _csignals_T_601; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_603 = _csignals_T_59 ? 5'h1 : _csignals_T_602; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_604 = _csignals_T_57 ? 5'h1 : _csignals_T_603; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_605 = _csignals_T_55 ? 5'h1 : _csignals_T_604; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_606 = _csignals_T_53 ? 5'h4 : _csignals_T_605; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_607 = _csignals_T_51 ? 5'h4 : _csignals_T_606; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_608 = _csignals_T_49 ? 5'h1 : _csignals_T_607; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_609 = _csignals_T_47 ? 5'h1 : _csignals_T_608; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_610 = _csignals_T_45 ? 5'h4 : _csignals_T_609; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_611 = _csignals_T_43 ? 5'h4 : _csignals_T_610; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_612 = _csignals_T_41 ? 5'h4 : _csignals_T_611; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_613 = _csignals_T_39 ? 5'h1 : _csignals_T_612; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_614 = _csignals_T_37 ? 5'h1 : _csignals_T_613; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_615 = _csignals_T_35 ? 5'h1 : _csignals_T_614; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_616 = _csignals_T_33 ? 5'h4 : _csignals_T_615; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_617 = _csignals_T_31 ? 5'h4 : _csignals_T_616; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_618 = _csignals_T_29 ? 5'h4 : _csignals_T_617; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_619 = _csignals_T_27 ? 5'h1 : _csignals_T_618; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_620 = _csignals_T_25 ? 5'h1 : _csignals_T_619; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_621 = _csignals_T_23 ? 5'h1 : _csignals_T_620; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_622 = _csignals_T_21 ? 5'h1 : _csignals_T_621; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_623 = _csignals_T_19 ? 5'h4 : _csignals_T_622; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_624 = _csignals_T_17 ? 5'h1 : _csignals_T_623; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_625 = _csignals_T_15 ? 5'h8 : _csignals_T_624; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_626 = _csignals_T_13 ? 5'h4 : _csignals_T_625; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_627 = _csignals_T_11 ? 5'h8 : _csignals_T_626; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_628 = _csignals_T_9 ? 5'h4 : _csignals_T_627; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_629 = _csignals_T_7 ? 5'h4 : _csignals_T_628; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_630 = _csignals_T_5 ? 5'h8 : _csignals_T_629; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] _csignals_T_631 = _csignals_T_3 ? 5'h4 : _csignals_T_630; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [4:0] csignals_2 = _csignals_T_1 ? 5'h4 : _csignals_T_631; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_649 = _csignals_T_219 ? 3'h5 : 3'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_650 = _csignals_T_217 ? 3'h0 : _csignals_T_649; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_651 = _csignals_T_215 ? 3'h0 : _csignals_T_650; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_652 = _csignals_T_213 ? 3'h0 : _csignals_T_651; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_653 = _csignals_T_211 ? 3'h5 : _csignals_T_652; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_654 = _csignals_T_209 ? 3'h0 : _csignals_T_653; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_655 = _csignals_T_207 ? 3'h0 : _csignals_T_654; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_656 = _csignals_T_205 ? 3'h0 : _csignals_T_655; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_657 = _csignals_T_203 ? 3'h0 : _csignals_T_656; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_658 = _csignals_T_201 ? 3'h0 : _csignals_T_657; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_659 = _csignals_T_199 ? 3'h0 : _csignals_T_658; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_660 = _csignals_T_197 ? 3'h6 : _csignals_T_659; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_661 = _csignals_T_195 ? 3'h0 : _csignals_T_660; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_662 = _csignals_T_193 ? 3'h0 : _csignals_T_661; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_663 = _csignals_T_191 ? 3'h0 : _csignals_T_662; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_664 = _csignals_T_189 ? 3'h0 : _csignals_T_663; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_665 = _csignals_T_187 ? 3'h0 : _csignals_T_664; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_666 = _csignals_T_185 ? 3'h0 : _csignals_T_665; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_667 = _csignals_T_183 ? 3'h0 : _csignals_T_666; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_668 = _csignals_T_181 ? 3'h0 : _csignals_T_667; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_669 = _csignals_T_179 ? 3'h0 : _csignals_T_668; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_670 = _csignals_T_177 ? 3'h0 : _csignals_T_669; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_671 = _csignals_T_175 ? 3'h0 : _csignals_T_670; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_672 = _csignals_T_173 ? 3'h0 : _csignals_T_671; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_673 = _csignals_T_171 ? 3'h0 : _csignals_T_672; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_674 = _csignals_T_169 ? 3'h0 : _csignals_T_673; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_675 = _csignals_T_167 ? 3'h1 : _csignals_T_674; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_676 = _csignals_T_165 ? 3'h0 : _csignals_T_675; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_677 = _csignals_T_163 ? 3'h0 : _csignals_T_676; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_678 = _csignals_T_161 ? 3'h5 : _csignals_T_677; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_679 = _csignals_T_159 ? 3'h0 : _csignals_T_678; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_680 = _csignals_T_157 ? 3'h0 : _csignals_T_679; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_681 = _csignals_T_155 ? 3'h0 : _csignals_T_680; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_682 = _csignals_T_153 ? 3'h0 : _csignals_T_681; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_683 = _csignals_T_151 ? 3'h0 : _csignals_T_682; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_684 = _csignals_T_149 ? 3'h7 : _csignals_T_683; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_685 = _csignals_T_147 ? 3'h7 : _csignals_T_684; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_686 = _csignals_T_145 ? 3'h7 : _csignals_T_685; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_687 = _csignals_T_143 ? 3'h7 : _csignals_T_686; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_688 = _csignals_T_141 ? 3'h3 : _csignals_T_687; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_689 = _csignals_T_139 ? 3'h3 : _csignals_T_688; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_690 = _csignals_T_137 ? 3'h3 : _csignals_T_689; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_691 = _csignals_T_135 ? 3'h0 : _csignals_T_690; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_692 = _csignals_T_133 ? 3'h0 : _csignals_T_691; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_693 = _csignals_T_131 ? 3'h0 : _csignals_T_692; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_694 = _csignals_T_129 ? 3'h0 : _csignals_T_693; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_695 = _csignals_T_127 ? 3'h0 : _csignals_T_694; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_696 = _csignals_T_125 ? 3'h0 : _csignals_T_695; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_697 = _csignals_T_123 ? 3'h0 : _csignals_T_696; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_698 = _csignals_T_121 ? 3'h0 : _csignals_T_697; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_699 = _csignals_T_119 ? 3'h0 : _csignals_T_698; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_700 = _csignals_T_117 ? 3'h0 : _csignals_T_699; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_701 = _csignals_T_115 ? 3'h0 : _csignals_T_700; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_702 = _csignals_T_113 ? 3'h0 : _csignals_T_701; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_703 = _csignals_T_111 ? 3'h0 : _csignals_T_702; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_704 = _csignals_T_109 ? 3'h0 : _csignals_T_703; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_705 = _csignals_T_107 ? 3'h0 : _csignals_T_704; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_706 = _csignals_T_105 ? 3'h0 : _csignals_T_705; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_707 = _csignals_T_103 ? 3'h0 : _csignals_T_706; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_708 = _csignals_T_101 ? 3'h0 : _csignals_T_707; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_709 = _csignals_T_99 ? 3'h0 : _csignals_T_708; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_710 = _csignals_T_97 ? 3'h0 : _csignals_T_709; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_711 = _csignals_T_95 ? 3'h0 : _csignals_T_710; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_712 = _csignals_T_93 ? 3'h0 : _csignals_T_711; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_713 = _csignals_T_91 ? 3'h0 : _csignals_T_712; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_714 = _csignals_T_89 ? 3'h0 : _csignals_T_713; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_715 = _csignals_T_87 ? 3'h0 : _csignals_T_714; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_716 = _csignals_T_85 ? 3'h0 : _csignals_T_715; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_717 = _csignals_T_83 ? 3'h0 : _csignals_T_716; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_718 = _csignals_T_81 ? 3'h0 : _csignals_T_717; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_719 = _csignals_T_79 ? 3'h0 : _csignals_T_718; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_720 = _csignals_T_77 ? 3'h0 : _csignals_T_719; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_721 = _csignals_T_75 ? 3'h0 : _csignals_T_720; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_722 = _csignals_T_73 ? 3'h0 : _csignals_T_721; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_723 = _csignals_T_71 ? 3'h0 : _csignals_T_722; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_724 = _csignals_T_69 ? 3'h0 : _csignals_T_723; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_725 = _csignals_T_67 ? 3'h0 : _csignals_T_724; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_726 = _csignals_T_65 ? 3'h0 : _csignals_T_725; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_727 = _csignals_T_63 ? 3'h0 : _csignals_T_726; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_728 = _csignals_T_61 ? 3'h0 : _csignals_T_727; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_729 = _csignals_T_59 ? 3'h0 : _csignals_T_728; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_730 = _csignals_T_57 ? 3'h0 : _csignals_T_729; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_731 = _csignals_T_55 ? 3'h0 : _csignals_T_730; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_732 = _csignals_T_53 ? 3'h0 : _csignals_T_731; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_733 = _csignals_T_51 ? 3'h0 : _csignals_T_732; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_734 = _csignals_T_49 ? 3'h0 : _csignals_T_733; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_735 = _csignals_T_47 ? 3'h0 : _csignals_T_734; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_736 = _csignals_T_45 ? 3'h1 : _csignals_T_735; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_737 = _csignals_T_43 ? 3'h0 : _csignals_T_736; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_738 = _csignals_T_41 ? 3'h0 : _csignals_T_737; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_739 = _csignals_T_39 ? 3'h1 : _csignals_T_738; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_740 = _csignals_T_37 ? 3'h0 : _csignals_T_739; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_741 = _csignals_T_35 ? 3'h0 : _csignals_T_740; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_742 = _csignals_T_33 ? 3'h0 : _csignals_T_741; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_743 = _csignals_T_31 ? 3'h0 : _csignals_T_742; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_744 = _csignals_T_29 ? 3'h0 : _csignals_T_743; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_745 = _csignals_T_27 ? 3'h0 : _csignals_T_744; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_746 = _csignals_T_25 ? 3'h0 : _csignals_T_745; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_747 = _csignals_T_23 ? 3'h0 : _csignals_T_746; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_748 = _csignals_T_21 ? 3'h0 : _csignals_T_747; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_749 = _csignals_T_19 ? 3'h0 : _csignals_T_748; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_750 = _csignals_T_17 ? 3'h0 : _csignals_T_749; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_751 = _csignals_T_15 ? 3'h4 : _csignals_T_750; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_752 = _csignals_T_13 ? 3'h0 : _csignals_T_751; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_753 = _csignals_T_11 ? 3'h4 : _csignals_T_752; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_754 = _csignals_T_9 ? 3'h0 : _csignals_T_753; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_755 = _csignals_T_7 ? 3'h0 : _csignals_T_754; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_756 = _csignals_T_5 ? 3'h4 : _csignals_T_755; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_757 = _csignals_T_3 ? 3'h0 : _csignals_T_756; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] csignals_3 = _csignals_T_1 ? 3'h0 : _csignals_T_757; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_765 = _csignals_T_239 ? 1'h0 : _csignals_T_241 | (_csignals_T_243 | (_csignals_T_245 | (
    _csignals_T_247 | (_csignals_T_249 | (_csignals_T_251 | _csignals_T_253))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_766 = _csignals_T_237 ? 1'h0 : _csignals_T_765; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_775 = _csignals_T_219 ? 1'h0 : _csignals_T_221 | (_csignals_T_223 | (_csignals_T_225 | (
    _csignals_T_227 | (_csignals_T_229 | (_csignals_T_231 | (_csignals_T_233 | (_csignals_T_235 | _csignals_T_766)))))))
    ; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_776 = _csignals_T_217 ? 1'h0 : _csignals_T_775; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_777 = _csignals_T_215 ? 1'h0 : _csignals_T_776; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_778 = _csignals_T_213 ? 1'h0 : _csignals_T_777; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_779 = _csignals_T_211 ? 1'h0 : _csignals_T_778; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_786 = _csignals_T_197 ? 1'h0 : _csignals_T_199 | (_csignals_T_201 | (_csignals_T_203 | (
    _csignals_T_205 | (_csignals_T_207 | (_csignals_T_209 | _csignals_T_779))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_790 = _csignals_T_189 ? 1'h0 : _csignals_T_191 | (_csignals_T_193 | (_csignals_T_195 |
    _csignals_T_786)); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_791 = _csignals_T_187 ? 1'h0 : _csignals_T_790; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_792 = _csignals_T_185 ? 1'h0 : _csignals_T_791; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_793 = _csignals_T_183 ? 1'h0 : _csignals_T_792; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_804 = _csignals_T_161 ? 1'h0 : _csignals_T_163 | (_csignals_T_165 | (_csignals_T_167 | (
    _csignals_T_169 | (_csignals_T_171 | (_csignals_T_173 | (_csignals_T_175 | (_csignals_T_177 | (_csignals_T_179 | (
    _csignals_T_181 | _csignals_T_793))))))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_809 = _csignals_T_151 ? 1'h0 : _csignals_T_153 | (_csignals_T_155 | (_csignals_T_157 | (
    _csignals_T_159 | _csignals_T_804))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_839 = _csignals_T_91 ? 1'h0 : _csignals_T_93 | (_csignals_T_95 | (_csignals_T_97 | (_csignals_T_99
     | (_csignals_T_101 | (_csignals_T_103 | (_csignals_T_105 | (_csignals_T_107 | (_csignals_T_109 | (_csignals_T_111
     | (_csignals_T_113 | (_csignals_T_115 | (_csignals_T_117 | (_csignals_T_119 | (_csignals_T_121 | (_csignals_T_123
     | (_csignals_T_125 | (_csignals_T_127 | (_csignals_T_129 | (_csignals_T_131 | (_csignals_T_133 | (_csignals_T_135
     | (_csignals_T_137 | (_csignals_T_139 | (_csignals_T_141 | (_csignals_T_143 | (_csignals_T_145 | (_csignals_T_147
     | (_csignals_T_149 | _csignals_T_809)))))))))))))))))))))))))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_840 = _csignals_T_89 ? 1'h0 : _csignals_T_839; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_841 = _csignals_T_87 ? 1'h0 : _csignals_T_840; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_852 = _csignals_T_65 ? 1'h0 : _csignals_T_67 | (_csignals_T_69 | (_csignals_T_71 | (_csignals_T_73
     | (_csignals_T_75 | (_csignals_T_77 | (_csignals_T_79 | (_csignals_T_81 | (_csignals_T_83 | (_csignals_T_85 |
    _csignals_T_841))))))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_853 = _csignals_T_63 ? 1'h0 : _csignals_T_852; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_854 = _csignals_T_61 ? 1'h0 : _csignals_T_853; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_855 = _csignals_T_59 ? 1'h0 : _csignals_T_854; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_856 = _csignals_T_57 ? 1'h0 : _csignals_T_855; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_857 = _csignals_T_55 ? 1'h0 : _csignals_T_856; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_877 = _csignals_T_15 ? 1'h0 : _csignals_T_17 | (_csignals_T_19 | (_csignals_T_21 | (_csignals_T_23
     | (_csignals_T_25 | (_csignals_T_27 | (_csignals_T_29 | (_csignals_T_31 | (_csignals_T_33 | (_csignals_T_35 | (
    _csignals_T_37 | (_csignals_T_39 | (_csignals_T_41 | (_csignals_T_43 | (_csignals_T_45 | (_csignals_T_47 | (
    _csignals_T_49 | (_csignals_T_51 | (_csignals_T_53 | _csignals_T_857)))))))))))))))))); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_879 = _csignals_T_11 ? 1'h0 : _csignals_T_13 | _csignals_T_877; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _csignals_T_882 = _csignals_T_5 ? 1'h0 : _csignals_T_7 | (_csignals_T_9 | _csignals_T_879); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  csignals_4 = _csignals_T_1 | (_csignals_T_3 | _csignals_T_882); // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_895 = _csignals_T_231 ? 3'h6 : 3'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_896 = _csignals_T_229 ? 3'h6 : _csignals_T_895; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_897 = _csignals_T_227 ? 3'h6 : _csignals_T_896; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_898 = _csignals_T_225 ? 3'h0 : _csignals_T_897; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_899 = _csignals_T_223 ? 3'h1 : _csignals_T_898; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_900 = _csignals_T_221 ? 3'h0 : _csignals_T_899; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_901 = _csignals_T_219 ? 3'h4 : _csignals_T_900; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_902 = _csignals_T_217 ? 3'h4 : _csignals_T_901; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_903 = _csignals_T_215 ? 3'h4 : _csignals_T_902; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_904 = _csignals_T_213 ? 3'h4 : _csignals_T_903; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_905 = _csignals_T_211 ? 3'h4 : _csignals_T_904; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_906 = _csignals_T_209 ? 3'h5 : _csignals_T_905; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_907 = _csignals_T_207 ? 3'h5 : _csignals_T_906; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_908 = _csignals_T_205 ? 3'h5 : _csignals_T_907; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_909 = _csignals_T_203 ? 3'h5 : _csignals_T_908; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_910 = _csignals_T_201 ? 3'h0 : _csignals_T_909; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_911 = _csignals_T_199 ? 3'h0 : _csignals_T_910; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_912 = _csignals_T_197 ? 3'h4 : _csignals_T_911; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_913 = _csignals_T_195 ? 3'h5 : _csignals_T_912; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_914 = _csignals_T_193 ? 3'h2 : _csignals_T_913; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_915 = _csignals_T_191 ? 3'h2 : _csignals_T_914; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_916 = _csignals_T_189 ? 3'h2 : _csignals_T_915; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_917 = _csignals_T_187 ? 3'h0 : _csignals_T_916; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_918 = _csignals_T_185 ? 3'h0 : _csignals_T_917; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_919 = _csignals_T_183 ? 3'h2 : _csignals_T_918; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_920 = _csignals_T_181 ? 3'h0 : _csignals_T_919; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_921 = _csignals_T_179 ? 3'h0 : _csignals_T_920; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_922 = _csignals_T_177 ? 3'h0 : _csignals_T_921; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_923 = _csignals_T_175 ? 3'h0 : _csignals_T_922; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_924 = _csignals_T_173 ? 3'h0 : _csignals_T_923; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_925 = _csignals_T_171 ? 3'h0 : _csignals_T_924; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_926 = _csignals_T_169 ? 3'h0 : _csignals_T_925; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_927 = _csignals_T_167 ? 3'h0 : _csignals_T_926; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_928 = _csignals_T_165 ? 3'h0 : _csignals_T_927; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_929 = _csignals_T_163 ? 3'h0 : _csignals_T_928; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_930 = _csignals_T_161 ? 3'h4 : _csignals_T_929; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_931 = _csignals_T_159 ? 3'h5 : _csignals_T_930; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_932 = _csignals_T_157 ? 3'h0 : _csignals_T_931; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_933 = _csignals_T_155 ? 3'h0 : _csignals_T_932; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_934 = _csignals_T_153 ? 3'h0 : _csignals_T_933; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_935 = _csignals_T_151 ? 3'h0 : _csignals_T_934; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_936 = _csignals_T_149 ? 3'h0 : _csignals_T_935; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_937 = _csignals_T_147 ? 3'h0 : _csignals_T_936; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_938 = _csignals_T_145 ? 3'h0 : _csignals_T_937; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_939 = _csignals_T_143 ? 3'h0 : _csignals_T_938; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_940 = _csignals_T_141 ? 3'h0 : _csignals_T_939; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_941 = _csignals_T_139 ? 3'h0 : _csignals_T_940; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_942 = _csignals_T_137 ? 3'h0 : _csignals_T_941; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_943 = _csignals_T_135 ? 3'h0 : _csignals_T_942; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_944 = _csignals_T_133 ? 3'h0 : _csignals_T_943; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_945 = _csignals_T_131 ? 3'h0 : _csignals_T_944; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_946 = _csignals_T_129 ? 3'h6 : _csignals_T_945; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_947 = _csignals_T_127 ? 3'h6 : _csignals_T_946; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_948 = _csignals_T_125 ? 3'h6 : _csignals_T_947; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_949 = _csignals_T_123 ? 3'h6 : _csignals_T_948; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_950 = _csignals_T_121 ? 3'h6 : _csignals_T_949; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_951 = _csignals_T_119 ? 3'h6 : _csignals_T_950; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_952 = _csignals_T_117 ? 3'h6 : _csignals_T_951; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_953 = _csignals_T_115 ? 3'h6 : _csignals_T_952; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_954 = _csignals_T_113 ? 3'h6 : _csignals_T_953; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_955 = _csignals_T_111 ? 3'h6 : _csignals_T_954; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_956 = _csignals_T_109 ? 3'h6 : _csignals_T_955; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_957 = _csignals_T_107 ? 3'h1 : _csignals_T_956; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_958 = _csignals_T_105 ? 3'h1 : _csignals_T_957; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_959 = _csignals_T_103 ? 3'h1 : _csignals_T_958; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_960 = _csignals_T_101 ? 3'h1 : _csignals_T_959; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_961 = _csignals_T_99 ? 3'h1 : _csignals_T_960; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_962 = _csignals_T_97 ? 3'h1 : _csignals_T_961; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_963 = _csignals_T_95 ? 3'h1 : _csignals_T_962; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_964 = _csignals_T_93 ? 3'h1 : _csignals_T_963; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_965 = _csignals_T_91 ? 3'h7 : _csignals_T_964; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_966 = _csignals_T_89 ? 3'h0 : _csignals_T_965; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_967 = _csignals_T_87 ? 3'h0 : _csignals_T_966; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_968 = _csignals_T_85 ? 3'h3 : _csignals_T_967; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_969 = _csignals_T_83 ? 3'h3 : _csignals_T_968; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_970 = _csignals_T_81 ? 3'h3 : _csignals_T_969; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_971 = _csignals_T_79 ? 3'h3 : _csignals_T_970; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_972 = _csignals_T_77 ? 3'h3 : _csignals_T_971; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_973 = _csignals_T_75 ? 3'h3 : _csignals_T_972; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_974 = _csignals_T_73 ? 3'h0 : _csignals_T_973; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_975 = _csignals_T_71 ? 3'h0 : _csignals_T_974; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_976 = _csignals_T_69 ? 3'h2 : _csignals_T_975; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_977 = _csignals_T_67 ? 3'h2 : _csignals_T_976; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_978 = _csignals_T_65 ? 3'h0 : _csignals_T_977; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_979 = _csignals_T_63 ? 3'h0 : _csignals_T_978; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_980 = _csignals_T_61 ? 3'h0 : _csignals_T_979; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_981 = _csignals_T_59 ? 3'h0 : _csignals_T_980; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_982 = _csignals_T_57 ? 3'h0 : _csignals_T_981; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_983 = _csignals_T_55 ? 3'h0 : _csignals_T_982; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_984 = _csignals_T_53 ? 3'h0 : _csignals_T_983; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_985 = _csignals_T_51 ? 3'h0 : _csignals_T_984; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_986 = _csignals_T_49 ? 3'h0 : _csignals_T_985; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_987 = _csignals_T_47 ? 3'h0 : _csignals_T_986; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_988 = _csignals_T_45 ? 3'h0 : _csignals_T_987; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_989 = _csignals_T_43 ? 3'h0 : _csignals_T_988; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_990 = _csignals_T_41 ? 3'h0 : _csignals_T_989; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_991 = _csignals_T_39 ? 3'h0 : _csignals_T_990; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_992 = _csignals_T_37 ? 3'h0 : _csignals_T_991; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_993 = _csignals_T_35 ? 3'h0 : _csignals_T_992; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_994 = _csignals_T_33 ? 3'h0 : _csignals_T_993; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_995 = _csignals_T_31 ? 3'h0 : _csignals_T_994; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_996 = _csignals_T_29 ? 3'h0 : _csignals_T_995; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_997 = _csignals_T_27 ? 3'h0 : _csignals_T_996; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_998 = _csignals_T_25 ? 3'h0 : _csignals_T_997; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_999 = _csignals_T_23 ? 3'h0 : _csignals_T_998; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1000 = _csignals_T_21 ? 3'h0 : _csignals_T_999; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1001 = _csignals_T_19 ? 3'h0 : _csignals_T_1000; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1002 = _csignals_T_17 ? 3'h0 : _csignals_T_1001; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1003 = _csignals_T_15 ? 3'h4 : _csignals_T_1002; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1004 = _csignals_T_13 ? 3'h5 : _csignals_T_1003; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1005 = _csignals_T_11 ? 3'h4 : _csignals_T_1004; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1006 = _csignals_T_9 ? 3'h5 : _csignals_T_1005; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1007 = _csignals_T_7 ? 3'h5 : _csignals_T_1006; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1008 = _csignals_T_5 ? 3'h4 : _csignals_T_1007; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1009 = _csignals_T_3 ? 3'h5 : _csignals_T_1008; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] csignals_5 = _csignals_T_1 ? 3'h5 : _csignals_T_1009; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1010 = _csignals_T_253 ? 3'h3 : 3'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1011 = _csignals_T_251 ? 3'h3 : _csignals_T_1010; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1012 = _csignals_T_249 ? 3'h3 : _csignals_T_1011; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1013 = _csignals_T_247 ? 3'h3 : _csignals_T_1012; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1014 = _csignals_T_245 ? 3'h3 : _csignals_T_1013; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1015 = _csignals_T_243 ? 3'h3 : _csignals_T_1014; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1016 = _csignals_T_241 ? 3'h3 : _csignals_T_1015; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1017 = _csignals_T_239 ? 3'h7 : _csignals_T_1016; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1018 = _csignals_T_237 ? 3'h7 : _csignals_T_1017; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1019 = _csignals_T_235 ? 3'h2 : _csignals_T_1018; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1020 = _csignals_T_233 ? 3'h2 : _csignals_T_1019; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1021 = _csignals_T_231 ? 3'h2 : _csignals_T_1020; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1022 = _csignals_T_229 ? 3'h2 : _csignals_T_1021; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1023 = _csignals_T_227 ? 3'h2 : _csignals_T_1022; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1024 = _csignals_T_225 ? 3'h2 : _csignals_T_1023; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1025 = _csignals_T_223 ? 3'h2 : _csignals_T_1024; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1026 = _csignals_T_221 ? 3'h3 : _csignals_T_1025; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1027 = _csignals_T_219 ? 3'h1 : _csignals_T_1026; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1028 = _csignals_T_217 ? 3'h1 : _csignals_T_1027; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1029 = _csignals_T_215 ? 3'h1 : _csignals_T_1028; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1030 = _csignals_T_213 ? 3'h1 : _csignals_T_1029; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1031 = _csignals_T_211 ? 3'h1 : _csignals_T_1030; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1032 = _csignals_T_209 ? 3'h3 : _csignals_T_1031; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1033 = _csignals_T_207 ? 3'h3 : _csignals_T_1032; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1034 = _csignals_T_205 ? 3'h3 : _csignals_T_1033; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1035 = _csignals_T_203 ? 3'h3 : _csignals_T_1034; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1036 = _csignals_T_201 ? 3'h1 : _csignals_T_1035; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1037 = _csignals_T_199 ? 3'h1 : _csignals_T_1036; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1038 = _csignals_T_197 ? 3'h1 : _csignals_T_1037; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1039 = _csignals_T_195 ? 3'h1 : _csignals_T_1038; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1040 = _csignals_T_193 ? 3'h4 : _csignals_T_1039; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1041 = _csignals_T_191 ? 3'h4 : _csignals_T_1040; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1042 = _csignals_T_189 ? 3'h1 : _csignals_T_1041; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1043 = _csignals_T_187 ? 3'h6 : _csignals_T_1042; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1044 = _csignals_T_185 ? 3'h6 : _csignals_T_1043; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1045 = _csignals_T_183 ? 3'h1 : _csignals_T_1044; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1046 = _csignals_T_181 ? 3'h1 : _csignals_T_1045; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1047 = _csignals_T_179 ? 3'h2 : _csignals_T_1046; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1048 = _csignals_T_177 ? 3'h2 : _csignals_T_1047; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1049 = _csignals_T_175 ? 3'h2 : _csignals_T_1048; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1050 = _csignals_T_173 ? 3'h2 : _csignals_T_1049; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1051 = _csignals_T_171 ? 3'h2 : _csignals_T_1050; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1052 = _csignals_T_169 ? 3'h2 : _csignals_T_1051; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1053 = _csignals_T_167 ? 3'h2 : _csignals_T_1052; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1054 = _csignals_T_165 ? 3'h1 : _csignals_T_1053; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1055 = _csignals_T_163 ? 3'h1 : _csignals_T_1054; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1056 = _csignals_T_161 ? 3'h1 : _csignals_T_1055; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1057 = _csignals_T_159 ? 3'h3 : _csignals_T_1056; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1058 = _csignals_T_157 ? 3'h1 : _csignals_T_1057; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1059 = _csignals_T_155 ? 3'h1 : _csignals_T_1058; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1060 = _csignals_T_153 ? 3'h3 : _csignals_T_1059; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1061 = _csignals_T_151 ? 3'h1 : _csignals_T_1060; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1062 = _csignals_T_149 ? 3'h0 : _csignals_T_1061; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1063 = _csignals_T_147 ? 3'h0 : _csignals_T_1062; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1064 = _csignals_T_145 ? 3'h0 : _csignals_T_1063; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1065 = _csignals_T_143 ? 3'h0 : _csignals_T_1064; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1066 = _csignals_T_141 ? 3'h0 : _csignals_T_1065; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1067 = _csignals_T_139 ? 3'h0 : _csignals_T_1066; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1068 = _csignals_T_137 ? 3'h0 : _csignals_T_1067; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1069 = _csignals_T_135 ? 3'h0 : _csignals_T_1068; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1070 = _csignals_T_133 ? 3'h0 : _csignals_T_1069; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1071 = _csignals_T_131 ? 3'h0 : _csignals_T_1070; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1072 = _csignals_T_129 ? 3'h0 : _csignals_T_1071; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1073 = _csignals_T_127 ? 3'h0 : _csignals_T_1072; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1074 = _csignals_T_125 ? 3'h0 : _csignals_T_1073; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1075 = _csignals_T_123 ? 3'h0 : _csignals_T_1074; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1076 = _csignals_T_121 ? 3'h0 : _csignals_T_1075; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1077 = _csignals_T_119 ? 3'h0 : _csignals_T_1076; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1078 = _csignals_T_117 ? 3'h0 : _csignals_T_1077; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1079 = _csignals_T_115 ? 3'h0 : _csignals_T_1078; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1080 = _csignals_T_113 ? 3'h0 : _csignals_T_1079; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1081 = _csignals_T_111 ? 3'h0 : _csignals_T_1080; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1082 = _csignals_T_109 ? 3'h0 : _csignals_T_1081; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1083 = _csignals_T_107 ? 3'h0 : _csignals_T_1082; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1084 = _csignals_T_105 ? 3'h0 : _csignals_T_1083; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1085 = _csignals_T_103 ? 3'h0 : _csignals_T_1084; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1086 = _csignals_T_101 ? 3'h0 : _csignals_T_1085; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1087 = _csignals_T_99 ? 3'h0 : _csignals_T_1086; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1088 = _csignals_T_97 ? 3'h0 : _csignals_T_1087; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1089 = _csignals_T_95 ? 3'h0 : _csignals_T_1088; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1090 = _csignals_T_93 ? 3'h0 : _csignals_T_1089; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1091 = _csignals_T_91 ? 3'h0 : _csignals_T_1090; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1092 = _csignals_T_89 ? 3'h0 : _csignals_T_1091; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1093 = _csignals_T_87 ? 3'h0 : _csignals_T_1092; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1094 = _csignals_T_85 ? 3'h0 : _csignals_T_1093; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1095 = _csignals_T_83 ? 3'h0 : _csignals_T_1094; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1096 = _csignals_T_81 ? 3'h0 : _csignals_T_1095; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1097 = _csignals_T_79 ? 3'h0 : _csignals_T_1096; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1098 = _csignals_T_77 ? 3'h0 : _csignals_T_1097; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1099 = _csignals_T_75 ? 3'h0 : _csignals_T_1098; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1100 = _csignals_T_73 ? 3'h0 : _csignals_T_1099; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1101 = _csignals_T_71 ? 3'h0 : _csignals_T_1100; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1102 = _csignals_T_69 ? 3'h0 : _csignals_T_1101; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1103 = _csignals_T_67 ? 3'h0 : _csignals_T_1102; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1104 = _csignals_T_65 ? 3'h0 : _csignals_T_1103; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1105 = _csignals_T_63 ? 3'h0 : _csignals_T_1104; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1106 = _csignals_T_61 ? 3'h0 : _csignals_T_1105; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1107 = _csignals_T_59 ? 3'h0 : _csignals_T_1106; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1108 = _csignals_T_57 ? 3'h0 : _csignals_T_1107; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1109 = _csignals_T_55 ? 3'h0 : _csignals_T_1108; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1110 = _csignals_T_53 ? 3'h0 : _csignals_T_1109; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1111 = _csignals_T_51 ? 3'h0 : _csignals_T_1110; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1112 = _csignals_T_49 ? 3'h0 : _csignals_T_1111; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1113 = _csignals_T_47 ? 3'h0 : _csignals_T_1112; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1114 = _csignals_T_45 ? 3'h0 : _csignals_T_1113; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1115 = _csignals_T_43 ? 3'h0 : _csignals_T_1114; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1116 = _csignals_T_41 ? 3'h0 : _csignals_T_1115; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1117 = _csignals_T_39 ? 3'h0 : _csignals_T_1116; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1118 = _csignals_T_37 ? 3'h0 : _csignals_T_1117; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1119 = _csignals_T_35 ? 3'h0 : _csignals_T_1118; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1120 = _csignals_T_33 ? 3'h0 : _csignals_T_1119; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1121 = _csignals_T_31 ? 3'h0 : _csignals_T_1120; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1122 = _csignals_T_29 ? 3'h0 : _csignals_T_1121; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1123 = _csignals_T_27 ? 3'h0 : _csignals_T_1122; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1124 = _csignals_T_25 ? 3'h0 : _csignals_T_1123; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1125 = _csignals_T_23 ? 3'h0 : _csignals_T_1124; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1126 = _csignals_T_21 ? 3'h0 : _csignals_T_1125; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1127 = _csignals_T_19 ? 3'h0 : _csignals_T_1126; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1128 = _csignals_T_17 ? 3'h0 : _csignals_T_1127; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1129 = _csignals_T_15 ? 3'h0 : _csignals_T_1128; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1130 = _csignals_T_13 ? 3'h0 : _csignals_T_1129; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1131 = _csignals_T_11 ? 3'h0 : _csignals_T_1130; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1132 = _csignals_T_9 ? 3'h0 : _csignals_T_1131; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1133 = _csignals_T_7 ? 3'h0 : _csignals_T_1132; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1134 = _csignals_T_5 ? 3'h0 : _csignals_T_1133; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1135 = _csignals_T_3 ? 3'h0 : _csignals_T_1134; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] csignals_6 = _csignals_T_1 ? 3'h0 : _csignals_T_1135; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1220 = _csignals_T_85 ? 2'h3 : 2'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1221 = _csignals_T_83 ? 2'h3 : _csignals_T_1220; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1222 = _csignals_T_81 ? 2'h2 : _csignals_T_1221; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1223 = _csignals_T_79 ? 2'h2 : _csignals_T_1222; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1224 = _csignals_T_77 ? 2'h1 : _csignals_T_1223; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1225 = _csignals_T_75 ? 2'h1 : _csignals_T_1224; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1226 = _csignals_T_73 ? 2'h0 : _csignals_T_1225; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1227 = _csignals_T_71 ? 2'h0 : _csignals_T_1226; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1228 = _csignals_T_69 ? 2'h0 : _csignals_T_1227; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1229 = _csignals_T_67 ? 2'h0 : _csignals_T_1228; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1230 = _csignals_T_65 ? 2'h0 : _csignals_T_1229; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1231 = _csignals_T_63 ? 2'h0 : _csignals_T_1230; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1232 = _csignals_T_61 ? 2'h0 : _csignals_T_1231; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1233 = _csignals_T_59 ? 2'h0 : _csignals_T_1232; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1234 = _csignals_T_57 ? 2'h0 : _csignals_T_1233; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1235 = _csignals_T_55 ? 2'h0 : _csignals_T_1234; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1236 = _csignals_T_53 ? 2'h0 : _csignals_T_1235; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1237 = _csignals_T_51 ? 2'h0 : _csignals_T_1236; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1238 = _csignals_T_49 ? 2'h0 : _csignals_T_1237; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1239 = _csignals_T_47 ? 2'h0 : _csignals_T_1238; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1240 = _csignals_T_45 ? 2'h0 : _csignals_T_1239; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1241 = _csignals_T_43 ? 2'h0 : _csignals_T_1240; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1242 = _csignals_T_41 ? 2'h0 : _csignals_T_1241; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1243 = _csignals_T_39 ? 2'h0 : _csignals_T_1242; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1244 = _csignals_T_37 ? 2'h0 : _csignals_T_1243; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1245 = _csignals_T_35 ? 2'h0 : _csignals_T_1244; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1246 = _csignals_T_33 ? 2'h0 : _csignals_T_1245; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1247 = _csignals_T_31 ? 2'h0 : _csignals_T_1246; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1248 = _csignals_T_29 ? 2'h0 : _csignals_T_1247; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1249 = _csignals_T_27 ? 2'h0 : _csignals_T_1248; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1250 = _csignals_T_25 ? 2'h0 : _csignals_T_1249; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1251 = _csignals_T_23 ? 2'h0 : _csignals_T_1250; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1252 = _csignals_T_21 ? 2'h0 : _csignals_T_1251; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1253 = _csignals_T_19 ? 2'h0 : _csignals_T_1252; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1254 = _csignals_T_17 ? 2'h0 : _csignals_T_1253; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1255 = _csignals_T_15 ? 2'h0 : _csignals_T_1254; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1256 = _csignals_T_13 ? 2'h0 : _csignals_T_1255; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1257 = _csignals_T_11 ? 2'h0 : _csignals_T_1256; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1258 = _csignals_T_9 ? 2'h0 : _csignals_T_1257; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1259 = _csignals_T_7 ? 2'h0 : _csignals_T_1258; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1260 = _csignals_T_5 ? 2'h0 : _csignals_T_1259; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] _csignals_T_1261 = _csignals_T_3 ? 2'h0 : _csignals_T_1260; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [1:0] csignals_7 = _csignals_T_1 ? 2'h0 : _csignals_T_1261; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1269 = _csignals_T_239 ? 3'h1 : 3'h0; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1270 = _csignals_T_237 ? 3'h1 : _csignals_T_1269; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1271 = _csignals_T_235 ? 3'h0 : _csignals_T_1270; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1272 = _csignals_T_233 ? 3'h0 : _csignals_T_1271; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1273 = _csignals_T_231 ? 3'h0 : _csignals_T_1272; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1274 = _csignals_T_229 ? 3'h0 : _csignals_T_1273; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1275 = _csignals_T_227 ? 3'h0 : _csignals_T_1274; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1276 = _csignals_T_225 ? 3'h0 : _csignals_T_1275; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1277 = _csignals_T_223 ? 3'h0 : _csignals_T_1276; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1278 = _csignals_T_221 ? 3'h0 : _csignals_T_1277; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1279 = _csignals_T_219 ? 3'h5 : _csignals_T_1278; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1280 = _csignals_T_217 ? 3'h4 : _csignals_T_1279; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1281 = _csignals_T_215 ? 3'h5 : _csignals_T_1280; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1282 = _csignals_T_213 ? 3'h0 : _csignals_T_1281; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1283 = _csignals_T_211 ? 3'h4 : _csignals_T_1282; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1284 = _csignals_T_209 ? 3'h6 : _csignals_T_1283; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1285 = _csignals_T_207 ? 3'h4 : _csignals_T_1284; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1286 = _csignals_T_205 ? 3'h7 : _csignals_T_1285; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1287 = _csignals_T_203 ? 3'h5 : _csignals_T_1286; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1288 = _csignals_T_201 ? 3'h0 : _csignals_T_1287; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1289 = _csignals_T_199 ? 3'h0 : _csignals_T_1288; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1290 = _csignals_T_197 ? 3'h0 : _csignals_T_1289; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1291 = _csignals_T_195 ? 3'h0 : _csignals_T_1290; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1292 = _csignals_T_193 ? 3'h0 : _csignals_T_1291; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1293 = _csignals_T_191 ? 3'h0 : _csignals_T_1292; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1294 = _csignals_T_189 ? 3'h0 : _csignals_T_1293; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1295 = _csignals_T_187 ? 3'h1 : _csignals_T_1294; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1296 = _csignals_T_185 ? 3'h1 : _csignals_T_1295; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1297 = _csignals_T_183 ? 3'h0 : _csignals_T_1296; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1298 = _csignals_T_181 ? 3'h0 : _csignals_T_1297; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1299 = _csignals_T_179 ? 3'h0 : _csignals_T_1298; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1300 = _csignals_T_177 ? 3'h0 : _csignals_T_1299; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1301 = _csignals_T_175 ? 3'h0 : _csignals_T_1300; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1302 = _csignals_T_173 ? 3'h0 : _csignals_T_1301; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1303 = _csignals_T_171 ? 3'h0 : _csignals_T_1302; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1304 = _csignals_T_169 ? 3'h0 : _csignals_T_1303; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1305 = _csignals_T_167 ? 3'h0 : _csignals_T_1304; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1306 = _csignals_T_165 ? 3'h0 : _csignals_T_1305; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1307 = _csignals_T_163 ? 3'h0 : _csignals_T_1306; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1308 = _csignals_T_161 ? 3'h0 : _csignals_T_1307; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1309 = _csignals_T_159 ? 3'h0 : _csignals_T_1308; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1310 = _csignals_T_157 ? 3'h0 : _csignals_T_1309; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1311 = _csignals_T_155 ? 3'h0 : _csignals_T_1310; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1312 = _csignals_T_153 ? 3'h0 : _csignals_T_1311; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1313 = _csignals_T_151 ? 3'h0 : _csignals_T_1312; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1314 = _csignals_T_149 ? 3'h0 : _csignals_T_1313; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1315 = _csignals_T_147 ? 3'h0 : _csignals_T_1314; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1316 = _csignals_T_145 ? 3'h0 : _csignals_T_1315; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1317 = _csignals_T_143 ? 3'h0 : _csignals_T_1316; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1318 = _csignals_T_141 ? 3'h0 : _csignals_T_1317; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1319 = _csignals_T_139 ? 3'h0 : _csignals_T_1318; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1320 = _csignals_T_137 ? 3'h0 : _csignals_T_1319; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1321 = _csignals_T_135 ? 3'h0 : _csignals_T_1320; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1322 = _csignals_T_133 ? 3'h0 : _csignals_T_1321; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1323 = _csignals_T_131 ? 3'h0 : _csignals_T_1322; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1324 = _csignals_T_129 ? 3'h0 : _csignals_T_1323; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1325 = _csignals_T_127 ? 3'h0 : _csignals_T_1324; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1326 = _csignals_T_125 ? 3'h0 : _csignals_T_1325; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1327 = _csignals_T_123 ? 3'h0 : _csignals_T_1326; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1328 = _csignals_T_121 ? 3'h0 : _csignals_T_1327; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1329 = _csignals_T_119 ? 3'h0 : _csignals_T_1328; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1330 = _csignals_T_117 ? 3'h0 : _csignals_T_1329; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1331 = _csignals_T_115 ? 3'h0 : _csignals_T_1330; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1332 = _csignals_T_113 ? 3'h0 : _csignals_T_1331; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1333 = _csignals_T_111 ? 3'h0 : _csignals_T_1332; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1334 = _csignals_T_109 ? 3'h0 : _csignals_T_1333; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1335 = _csignals_T_107 ? 3'h0 : _csignals_T_1334; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1336 = _csignals_T_105 ? 3'h0 : _csignals_T_1335; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1337 = _csignals_T_103 ? 3'h0 : _csignals_T_1336; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1338 = _csignals_T_101 ? 3'h0 : _csignals_T_1337; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1339 = _csignals_T_99 ? 3'h0 : _csignals_T_1338; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1340 = _csignals_T_97 ? 3'h0 : _csignals_T_1339; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1341 = _csignals_T_95 ? 3'h0 : _csignals_T_1340; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1342 = _csignals_T_93 ? 3'h0 : _csignals_T_1341; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1343 = _csignals_T_91 ? 3'h0 : _csignals_T_1342; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1344 = _csignals_T_89 ? 3'h3 : _csignals_T_1343; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1345 = _csignals_T_87 ? 3'h3 : _csignals_T_1344; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1346 = _csignals_T_85 ? 3'h0 : _csignals_T_1345; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1347 = _csignals_T_83 ? 3'h0 : _csignals_T_1346; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1348 = _csignals_T_81 ? 3'h0 : _csignals_T_1347; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1349 = _csignals_T_79 ? 3'h0 : _csignals_T_1348; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1350 = _csignals_T_77 ? 3'h0 : _csignals_T_1349; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1351 = _csignals_T_75 ? 3'h0 : _csignals_T_1350; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1352 = _csignals_T_73 ? 3'h0 : _csignals_T_1351; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1353 = _csignals_T_71 ? 3'h0 : _csignals_T_1352; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1354 = _csignals_T_69 ? 3'h0 : _csignals_T_1353; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1355 = _csignals_T_67 ? 3'h0 : _csignals_T_1354; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1356 = _csignals_T_65 ? 3'h1 : _csignals_T_1355; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1357 = _csignals_T_63 ? 3'h1 : _csignals_T_1356; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1358 = _csignals_T_61 ? 3'h1 : _csignals_T_1357; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1359 = _csignals_T_59 ? 3'h1 : _csignals_T_1358; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1360 = _csignals_T_57 ? 3'h1 : _csignals_T_1359; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1361 = _csignals_T_55 ? 3'h1 : _csignals_T_1360; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1362 = _csignals_T_53 ? 3'h0 : _csignals_T_1361; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1363 = _csignals_T_51 ? 3'h0 : _csignals_T_1362; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1364 = _csignals_T_49 ? 3'h0 : _csignals_T_1363; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1365 = _csignals_T_47 ? 3'h0 : _csignals_T_1364; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1366 = _csignals_T_45 ? 3'h0 : _csignals_T_1365; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1367 = _csignals_T_43 ? 3'h0 : _csignals_T_1366; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1368 = _csignals_T_41 ? 3'h0 : _csignals_T_1367; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1369 = _csignals_T_39 ? 3'h0 : _csignals_T_1368; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1370 = _csignals_T_37 ? 3'h0 : _csignals_T_1369; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1371 = _csignals_T_35 ? 3'h0 : _csignals_T_1370; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1372 = _csignals_T_33 ? 3'h0 : _csignals_T_1371; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1373 = _csignals_T_31 ? 3'h0 : _csignals_T_1372; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1374 = _csignals_T_29 ? 3'h0 : _csignals_T_1373; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1375 = _csignals_T_27 ? 3'h0 : _csignals_T_1374; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1376 = _csignals_T_25 ? 3'h0 : _csignals_T_1375; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1377 = _csignals_T_23 ? 3'h0 : _csignals_T_1376; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1378 = _csignals_T_21 ? 3'h0 : _csignals_T_1377; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1379 = _csignals_T_19 ? 3'h0 : _csignals_T_1378; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1380 = _csignals_T_17 ? 3'h0 : _csignals_T_1379; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1381 = _csignals_T_15 ? 3'h0 : _csignals_T_1380; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1382 = _csignals_T_13 ? 3'h0 : _csignals_T_1381; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1383 = _csignals_T_11 ? 3'h4 : _csignals_T_1382; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1384 = _csignals_T_9 ? 3'h6 : _csignals_T_1383; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1385 = _csignals_T_7 ? 3'h4 : _csignals_T_1384; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1386 = _csignals_T_5 ? 3'h5 : _csignals_T_1385; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] _csignals_T_1387 = _csignals_T_3 ? 3'h7 : _csignals_T_1386; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire [2:0] csignals_8 = _csignals_T_1 ? 3'h5 : _csignals_T_1387; // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
  wire  _id_wb_addr_T = csignals_6 == 3'h1; // @[src/main/scala/fpga/Core.scala 818:13]
  wire  _id_wb_addr_T_1 = csignals_6 == 3'h2; // @[src/main/scala/fpga/Core.scala 819:13]
  wire  _id_wb_addr_T_2 = csignals_6 == 3'h3; // @[src/main/scala/fpga/Core.scala 820:13]
  wire  _id_wb_addr_T_3 = csignals_6 == 3'h4; // @[src/main/scala/fpga/Core.scala 821:13]
  wire [4:0] _id_wb_addr_T_4 = _id_wb_addr_T_3 ? 5'h1 : id_w_wb_addr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_wb_addr_T_5 = _id_wb_addr_T_2 ? id_c_rs2p_addr : _id_wb_addr_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_wb_addr_T_6 = _id_wb_addr_T_1 ? id_c_rs1p_addr : _id_wb_addr_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] id_wb_addr = _id_wb_addr_T ? id_w_wb_addr : _id_wb_addr_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_op1_data_T = csignals_1 == 3'h1; // @[src/main/scala/fpga/Core.scala 825:17]
  wire [31:0] _id_op1_data_T_1 = {id_reg_pc,1'h0}; // @[src/main/scala/fpga/Core.scala 825:39]
  wire  _id_op1_data_T_2 = csignals_1 == 3'h2; // @[src/main/scala/fpga/Core.scala 826:17]
  wire [31:0] _id_op1_data_T_3 = _id_op1_data_T_2 ? id_imm_z_uext : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] id_op1_data = _id_op1_data_T ? _id_op1_data_T_1 : _id_op1_data_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_op2_data_T = csignals_2 == 5'h0; // @[src/main/scala/fpga/Core.scala 830:17]
  wire  _id_op2_data_T_1 = csignals_2 == 5'h4; // @[src/main/scala/fpga/Core.scala 831:17]
  wire  _id_op2_data_T_2 = csignals_2 == 5'h8; // @[src/main/scala/fpga/Core.scala 832:17]
  wire  _id_op2_data_T_3 = csignals_2 == 5'h9; // @[src/main/scala/fpga/Core.scala 833:17]
  wire  _id_op2_data_T_4 = csignals_2 == 5'ha; // @[src/main/scala/fpga/Core.scala 834:17]
  wire  _id_op2_data_T_5 = csignals_2 == 5'hb; // @[src/main/scala/fpga/Core.scala 835:17]
  wire  _id_op2_data_T_6 = csignals_2 == 5'hc; // @[src/main/scala/fpga/Core.scala 836:17]
  wire  _id_op2_data_T_7 = csignals_2 == 5'hd; // @[src/main/scala/fpga/Core.scala 837:17]
  wire  _id_op2_data_T_8 = csignals_2 == 5'he; // @[src/main/scala/fpga/Core.scala 838:17]
  wire  _id_op2_data_T_9 = csignals_2 == 5'hf; // @[src/main/scala/fpga/Core.scala 839:17]
  wire  _id_op2_data_T_10 = csignals_2 == 5'h10; // @[src/main/scala/fpga/Core.scala 840:17]
  wire  _id_op2_data_T_11 = csignals_2 == 5'h11; // @[src/main/scala/fpga/Core.scala 841:17]
  wire  _id_op2_data_T_12 = csignals_2 == 5'h12; // @[src/main/scala/fpga/Core.scala 842:17]
  wire  _id_op2_data_T_13 = csignals_2 == 5'h13; // @[src/main/scala/fpga/Core.scala 843:17]
  wire  _id_op2_data_T_14 = csignals_2 == 5'h14; // @[src/main/scala/fpga/Core.scala 844:17]
  wire  _id_op2_data_T_15 = csignals_2 == 5'h15; // @[src/main/scala/fpga/Core.scala 845:17]
  wire  _id_op2_data_T_16 = csignals_2 == 5'h16; // @[src/main/scala/fpga/Core.scala 846:17]
  wire  _id_op2_data_T_17 = csignals_2 == 5'h17; // @[src/main/scala/fpga/Core.scala 847:17]
  wire  _id_op2_data_T_18 = csignals_2 == 5'h18; // @[src/main/scala/fpga/Core.scala 848:17]
  wire  _id_op2_data_T_19 = csignals_2 == 5'h19; // @[src/main/scala/fpga/Core.scala 849:17]
  wire  _id_op2_data_T_21 = csignals_2 == 5'h1a; // @[src/main/scala/fpga/Core.scala 850:17]
  wire  _id_op2_data_T_22 = csignals_2 == 5'h1b; // @[src/main/scala/fpga/Core.scala 851:17]
  wire  _id_op2_data_T_23 = csignals_2 == 5'h1c; // @[src/main/scala/fpga/Core.scala 852:17]
  wire  _id_op2_data_T_24 = csignals_2 == 5'h1d; // @[src/main/scala/fpga/Core.scala 853:17]
  wire [31:0] _id_op2_data_T_25 = _id_op2_data_T_24 ? id_c_imm_u : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _id_op2_data_T_26 = _id_op2_data_T_23 ? id_c_imm_a2b : _id_op2_data_T_25; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _id_op2_data_T_27 = _id_op2_data_T_22 ? id_c_imm_a2w : _id_op2_data_T_26; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _id_op2_data_T_28 = _id_op2_data_T_21 ? 32'h1 : _id_op2_data_T_27; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _id_op2_data_T_29 = _id_op2_data_T_19 ? 32'hffffffff : _id_op2_data_T_28; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _id_op2_data_T_30 = _id_op2_data_T_18 ? 32'hff : _id_op2_data_T_29; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_31 = _id_op2_data_T_17 ? id_c_imm_sh0 : {{1'd0}, _id_op2_data_T_30}; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_32 = _id_op2_data_T_16 ? {{1'd0}, id_c_imm_sb0} : _id_op2_data_T_31; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_33 = _id_op2_data_T_15 ? {{1'd0}, id_c_imm_sw0} : _id_op2_data_T_32; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_34 = _id_op2_data_T_14 ? {{1'd0}, id_c_imm_lsh} : _id_op2_data_T_33; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_35 = _id_op2_data_T_13 ? {{1'd0}, id_c_imm_lsb} : _id_op2_data_T_34; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_36 = _id_op2_data_T_12 ? {{1'd0}, id_c_imm_ss} : _id_op2_data_T_35; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_37 = _id_op2_data_T_11 ? {{1'd0}, id_c_imm_sl} : _id_op2_data_T_36; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_38 = _id_op2_data_T_10 ? {{1'd0}, id_c_imm_j} : _id_op2_data_T_37; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_39 = _id_op2_data_T_9 ? {{1'd0}, id_c_imm_iu} : _id_op2_data_T_38; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_40 = _id_op2_data_T_8 ? {{1'd0}, id_c_imm_ls} : _id_op2_data_T_39; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_41 = _id_op2_data_T_7 ? {{1'd0}, id_c_imm_i} : _id_op2_data_T_40; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_42 = _id_op2_data_T_6 ? {{1'd0}, id_c_imm_i16} : _id_op2_data_T_41; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_43 = _id_op2_data_T_5 ? {{1'd0}, id_c_imm_iw} : _id_op2_data_T_42; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_44 = _id_op2_data_T_4 ? {{1'd0}, id_imm_u_shifted} : _id_op2_data_T_43; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_45 = _id_op2_data_T_3 ? {{1'd0}, id_imm_j_sext} : _id_op2_data_T_44; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_46 = _id_op2_data_T_2 ? {{1'd0}, id_imm_s_sext} : _id_op2_data_T_45; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_47 = _id_op2_data_T_1 ? {{1'd0}, id_imm_i_sext} : _id_op2_data_T_46; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [32:0] _id_op2_data_T_48 = _id_op2_data_T ? 33'h0 : _id_op2_data_T_47; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_csr_addr_T_2 = csignals_0 == 4'he & csignals_8 == 3'h3; // @[src/main/scala/fpga/Core.scala 856:50]
  wire [11:0] id_csr_addr = csignals_0 == 4'he & csignals_8 == 3'h3 ? 12'h342 : id_imm_i; // @[src/main/scala/fpga/Core.scala 856:24]
  wire  _id_m_op1_sel_T = csignals_1 == 3'h4; // @[src/main/scala/fpga/Core.scala 859:17]
  wire  _id_m_op1_sel_T_1 = csignals_1 == 3'h5; // @[src/main/scala/fpga/Core.scala 860:17]
  wire  _id_m_op1_sel_T_2 = csignals_1 == 3'h6; // @[src/main/scala/fpga/Core.scala 861:17]
  wire  _id_m_op1_sel_T_3 = csignals_1 == 3'h7; // @[src/main/scala/fpga/Core.scala 862:17]
  wire  _id_m_op1_sel_T_4 = _id_m_op1_sel_T_3 ? 1'h0 : 1'h1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op1_sel_T_5 = _id_m_op1_sel_T_2 ? 1'h0 : _id_m_op1_sel_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op1_sel_T_6 = _id_m_op1_sel_T_1 ? 1'h0 : _id_m_op1_sel_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  id_m_op1_sel = _id_m_op1_sel_T ? 1'h0 : _id_m_op1_sel_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op2_sel_T = csignals_2 == 5'h1; // @[src/main/scala/fpga/Core.scala 865:17]
  wire  _id_m_op2_sel_T_1 = csignals_2 == 5'h2; // @[src/main/scala/fpga/Core.scala 866:17]
  wire  _id_m_op2_sel_T_2 = csignals_2 == 5'h7; // @[src/main/scala/fpga/Core.scala 867:17]
  wire  _id_m_op2_sel_T_3 = csignals_2 == 5'h6; // @[src/main/scala/fpga/Core.scala 868:17]
  wire  _id_m_op2_sel_T_4 = csignals_2 == 5'h3; // @[src/main/scala/fpga/Core.scala 869:17]
  wire  _id_m_op2_sel_T_5 = csignals_2 == 5'h5; // @[src/main/scala/fpga/Core.scala 870:17]
  wire  _id_m_op2_sel_T_6 = _id_m_op2_sel_T_5 ? 1'h0 : 1'h1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op2_sel_T_7 = _id_m_op2_sel_T_4 ? 1'h0 : _id_m_op2_sel_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op2_sel_T_8 = _id_m_op2_sel_T_3 ? 1'h0 : _id_m_op2_sel_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op2_sel_T_9 = _id_m_op2_sel_T_2 ? 1'h0 : _id_m_op2_sel_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op2_sel_T_10 = _id_m_op2_sel_T_1 ? 1'h0 : _id_m_op2_sel_T_9; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  id_m_op2_sel = _id_m_op2_sel_T ? 1'h0 : _id_m_op2_sel_T_10; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_op3_sel_T = csignals_3 == 3'h0; // @[src/main/scala/fpga/Core.scala 873:17]
  wire  _id_m_op3_sel_T_1 = csignals_3 == 3'h1; // @[src/main/scala/fpga/Core.scala 874:17]
  wire  _id_m_op3_sel_T_2 = csignals_3 == 3'h3; // @[src/main/scala/fpga/Core.scala 875:17]
  wire  _id_m_op3_sel_T_3 = csignals_3 == 3'h4; // @[src/main/scala/fpga/Core.scala 876:17]
  wire  _id_m_op3_sel_T_4 = csignals_3 == 3'h6; // @[src/main/scala/fpga/Core.scala 877:17]
  wire  _id_m_op3_sel_T_5 = csignals_3 == 3'h5; // @[src/main/scala/fpga/Core.scala 878:17]
  wire  _id_m_op3_sel_T_6 = csignals_3 == 3'h7; // @[src/main/scala/fpga/Core.scala 879:17]
  wire [1:0] _id_m_op3_sel_T_7 = _id_m_op3_sel_T_6 ? 2'h2 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _id_m_op3_sel_T_8 = _id_m_op3_sel_T_5 ? 2'h2 : _id_m_op3_sel_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _id_m_op3_sel_T_9 = _id_m_op3_sel_T_4 ? 2'h2 : _id_m_op3_sel_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _id_m_op3_sel_T_10 = _id_m_op3_sel_T_3 ? 2'h2 : _id_m_op3_sel_T_9; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _id_m_op3_sel_T_11 = _id_m_op3_sel_T_2 ? 2'h3 : _id_m_op3_sel_T_10; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _id_m_op3_sel_T_12 = _id_m_op3_sel_T_1 ? 2'h1 : _id_m_op3_sel_T_11; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] id_m_op3_sel = _id_m_op3_sel_T ? 2'h0 : _id_m_op3_sel_T_12; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs1_addr_T_3 = _id_m_op1_sel_T_3 ? id_c_rs1p_addr : id_rs1_addr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs1_addr_T_4 = _id_m_op1_sel_T_2 ? 5'h2 : _id_m_rs1_addr_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] id_m_rs1_addr = _id_m_op1_sel_T_1 ? id_w_wb_addr : _id_m_rs1_addr_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs2_addr_T_4 = _id_m_op2_sel_T_4 ? id_c_rs3p_addr : id_rs2_addr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs2_addr_T_5 = _id_m_op2_sel_T_3 ? id_c_rs2p_addr : _id_m_rs2_addr_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs2_addr_T_6 = _id_m_op2_sel_T_2 ? id_c_rs1p_addr : _id_m_rs2_addr_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] id_m_rs2_addr = _id_m_op2_sel_T_1 ? id_c_rs2_addr : _id_m_rs2_addr_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs3_addr_T_3 = _id_m_op3_sel_T_6 ? id_rs3_addr : id_rs2_addr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] _id_m_rs3_addr_T_4 = _id_m_op3_sel_T_5 ? id_c_rs2p_addr : _id_m_rs3_addr_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [4:0] id_m_rs3_addr = _id_m_op3_sel_T_4 ? id_c_rs2_addr : _id_m_rs3_addr_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _id_m_imm_b_sext_T = csignals_6 == 3'h6; // @[src/main/scala/fpga/Core.scala 898:13]
  wire  _id_m_imm_b_sext_T_1 = csignals_6 == 3'h7; // @[src/main/scala/fpga/Core.scala 899:13]
  wire [31:0] _id_m_imm_b_sext_T_2 = _id_m_imm_b_sext_T_1 ? id_c_imm_b2 : id_imm_b_sext; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] id_m_imm_b_sext = _id_m_imm_b_sext_T ? id_c_imm_b : _id_m_imm_b_sext_T_2; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  id_is_br = csignals_8 == 3'h1; // @[src/main/scala/fpga/Core.scala 903:28]
  wire  id_is_j = csignals_5 == 3'h2; // @[src/main/scala/fpga/Core.scala 904:28]
  wire [30:0] _id_reg_br_pc_T_1 = id_reg_pc + 31'h1; // @[src/main/scala/fpga/Core.scala 909:45]
  wire [30:0] _id_reg_br_pc_T_3 = id_reg_pc + 31'h2; // @[src/main/scala/fpga/Core.scala 909:72]
  reg [30:0] id_reg_pc_delay; // @[src/main/scala/fpga/Core.scala 917:40]
  reg [4:0] id_reg_wb_addr_delay; // @[src/main/scala/fpga/Core.scala 918:40]
  reg  id_reg_op1_sel_delay; // @[src/main/scala/fpga/Core.scala 919:40]
  reg  id_reg_op2_sel_delay; // @[src/main/scala/fpga/Core.scala 920:40]
  reg [1:0] id_reg_op3_sel_delay; // @[src/main/scala/fpga/Core.scala 921:40]
  reg [4:0] id_reg_rs1_addr_delay; // @[src/main/scala/fpga/Core.scala 922:40]
  reg [4:0] id_reg_rs2_addr_delay; // @[src/main/scala/fpga/Core.scala 923:40]
  reg [4:0] id_reg_rs3_addr_delay; // @[src/main/scala/fpga/Core.scala 924:40]
  reg [31:0] id_reg_op1_data_delay; // @[src/main/scala/fpga/Core.scala 925:40]
  reg [31:0] id_reg_op2_data_delay; // @[src/main/scala/fpga/Core.scala 926:40]
  reg [3:0] id_reg_exe_fun_delay; // @[src/main/scala/fpga/Core.scala 927:40]
  reg  id_reg_rf_wen_delay; // @[src/main/scala/fpga/Core.scala 928:40]
  reg [2:0] id_reg_wb_sel_delay; // @[src/main/scala/fpga/Core.scala 929:40]
  reg [11:0] id_reg_csr_addr_delay; // @[src/main/scala/fpga/Core.scala 930:40]
  reg [1:0] id_reg_csr_cmd_delay; // @[src/main/scala/fpga/Core.scala 931:40]
  reg [31:0] id_reg_imm_b_sext_delay; // @[src/main/scala/fpga/Core.scala 932:40]
  reg [2:0] id_reg_mem_w_delay; // @[src/main/scala/fpga/Core.scala 933:40]
  reg  id_reg_is_br_delay; // @[src/main/scala/fpga/Core.scala 935:40]
  reg  id_reg_is_j_delay; // @[src/main/scala/fpga/Core.scala 936:40]
  reg  id_reg_bp_taken_delay; // @[src/main/scala/fpga/Core.scala 937:40]
  reg [30:0] id_reg_bp_taken_pc_delay; // @[src/main/scala/fpga/Core.scala 938:41]
  reg [1:0] id_reg_bp_cnt_delay; // @[src/main/scala/fpga/Core.scala 939:40]
  reg  id_reg_is_half_delay; // @[src/main/scala/fpga/Core.scala 940:40]
  reg  id_reg_is_valid_inst_delay; // @[src/main/scala/fpga/Core.scala 941:43]
  reg  id_reg_is_trap_delay; // @[src/main/scala/fpga/Core.scala 942:40]
  reg [31:0] id_reg_mcause_delay; // @[src/main/scala/fpga/Core.scala 943:40]
  wire [30:0] _GEN_217 = _ic_read_en4_T ? id_reg_pc : id_reg_pc_delay; // @[src/main/scala/fpga/Core.scala 947:26 948:32 917:40]
  wire  _GEN_218 = _ic_read_en4_T ? id_m_op1_sel : id_reg_op1_sel_delay; // @[src/main/scala/fpga/Core.scala 947:26 949:31 919:40]
  wire  _GEN_219 = _ic_read_en4_T ? id_m_op2_sel : id_reg_op2_sel_delay; // @[src/main/scala/fpga/Core.scala 947:26 950:31 920:40]
  wire [1:0] _GEN_220 = _ic_read_en4_T ? id_m_op3_sel : id_reg_op3_sel_delay; // @[src/main/scala/fpga/Core.scala 947:26 951:31 921:40]
  wire [4:0] _GEN_221 = _ic_read_en4_T ? id_m_rs1_addr : id_reg_rs1_addr_delay; // @[src/main/scala/fpga/Core.scala 947:26 952:31 922:40]
  wire [4:0] _GEN_222 = _ic_read_en4_T ? id_m_rs2_addr : id_reg_rs2_addr_delay; // @[src/main/scala/fpga/Core.scala 947:26 953:31 923:40]
  wire [4:0] _GEN_223 = _ic_read_en4_T ? id_m_rs3_addr : id_reg_rs3_addr_delay; // @[src/main/scala/fpga/Core.scala 947:26 954:31 924:40]
  wire [31:0] _GEN_224 = _ic_read_en4_T ? id_op1_data : id_reg_op1_data_delay; // @[src/main/scala/fpga/Core.scala 947:26 955:31 925:40]
  wire [31:0] id_op2_data = _id_op2_data_T_48[31:0]; // @[src/main/scala/fpga/Core.scala 828:25 829:15]
  wire [31:0] _GEN_225 = _ic_read_en4_T ? id_op2_data : id_reg_op2_data_delay; // @[src/main/scala/fpga/Core.scala 947:26 956:31 926:40]
  wire [4:0] _GEN_226 = _ic_read_en4_T ? id_wb_addr : id_reg_wb_addr_delay; // @[src/main/scala/fpga/Core.scala 947:26 957:31 918:40]
  wire [31:0] _GEN_227 = _ic_read_en4_T ? id_m_imm_b_sext : id_reg_imm_b_sext_delay; // @[src/main/scala/fpga/Core.scala 947:26 958:31 932:40]
  wire [11:0] _GEN_228 = _ic_read_en4_T ? id_csr_addr : id_reg_csr_addr_delay; // @[src/main/scala/fpga/Core.scala 947:26 959:31 930:40]
  wire [30:0] _GEN_230 = _ic_read_en4_T ? id_reg_bp_taken_pc : id_reg_bp_taken_pc_delay; // @[src/main/scala/fpga/Core.scala 947:26 961:32 938:41]
  wire [1:0] _GEN_231 = _ic_read_en4_T ? id_reg_bp_cnt : id_reg_bp_cnt_delay; // @[src/main/scala/fpga/Core.scala 947:26 962:31 939:40]
  wire  _GEN_232 = _ic_read_en4_T ? id_is_half : id_reg_is_half_delay; // @[src/main/scala/fpga/Core.scala 947:26 963:31 940:40]
  wire [31:0] _GEN_233 = _ic_read_en4_T ? 32'hb : id_reg_mcause_delay; // @[src/main/scala/fpga/Core.scala 947:26 964:31 943:40]
  wire  _id_reg_is_valid_inst_delay_T = id_inst != 32'h13; // @[src/main/scala/fpga/Core.scala 1001:43]
  wire [30:0] _GEN_288 = id_reg_stall ? id_reg_pc_delay : id_reg_pc; // @[src/main/scala/fpga/Core.scala 1013:24 1014:29 1046:29]
  wire  _GEN_289 = id_reg_stall ? id_reg_op1_sel_delay : id_m_op1_sel; // @[src/main/scala/fpga/Core.scala 1013:24 1015:29 1047:29]
  wire  _GEN_290 = id_reg_stall ? id_reg_op2_sel_delay : id_m_op2_sel; // @[src/main/scala/fpga/Core.scala 1013:24 1016:29 1048:29]
  wire [1:0] _GEN_291 = id_reg_stall ? id_reg_op3_sel_delay : id_m_op3_sel; // @[src/main/scala/fpga/Core.scala 1013:24 1017:29 1049:29]
  wire [4:0] _GEN_292 = id_reg_stall ? id_reg_rs1_addr_delay : id_m_rs1_addr; // @[src/main/scala/fpga/Core.scala 1013:24 1018:29 1050:29]
  wire [4:0] _GEN_293 = id_reg_stall ? id_reg_rs2_addr_delay : id_m_rs2_addr; // @[src/main/scala/fpga/Core.scala 1013:24 1019:29 1051:29]
  wire [4:0] _GEN_294 = id_reg_stall ? id_reg_rs3_addr_delay : id_m_rs3_addr; // @[src/main/scala/fpga/Core.scala 1013:24 1020:29 1052:29]
  wire [31:0] _GEN_295 = id_reg_stall ? id_reg_op1_data_delay : id_op1_data; // @[src/main/scala/fpga/Core.scala 1013:24 1021:29 1053:29]
  wire [31:0] _GEN_296 = id_reg_stall ? id_reg_op2_data_delay : id_op2_data; // @[src/main/scala/fpga/Core.scala 1013:24 1022:29 1054:29]
  wire [4:0] _GEN_297 = id_reg_stall ? id_reg_wb_addr_delay : id_wb_addr; // @[src/main/scala/fpga/Core.scala 1013:24 1023:29 1055:29]
  wire [31:0] _GEN_301 = id_reg_stall ? id_reg_imm_b_sext_delay : id_m_imm_b_sext; // @[src/main/scala/fpga/Core.scala 1013:24 1027:29 1059:29]
  wire [11:0] _GEN_302 = id_reg_stall ? id_reg_csr_addr_delay : id_csr_addr; // @[src/main/scala/fpga/Core.scala 1013:24 1028:29 1060:29]
  wire [30:0] _GEN_304 = id_reg_stall ? id_reg_bp_taken_pc_delay : id_reg_bp_taken_pc; // @[src/main/scala/fpga/Core.scala 1013:24 1035:29 1067:29]
  wire [1:0] _GEN_305 = id_reg_stall ? id_reg_bp_cnt_delay : id_reg_bp_cnt; // @[src/main/scala/fpga/Core.scala 1013:24 1036:29 1068:29]
  wire  _GEN_306 = id_reg_stall ? id_reg_is_half_delay : id_is_half; // @[src/main/scala/fpga/Core.scala 1013:24 1037:29 1069:29]
  wire [31:0] _GEN_307 = id_reg_stall ? id_reg_mcause_delay : 32'hb; // @[src/main/scala/fpga/Core.scala 1013:24 1040:29 1072:29]
  wire  _T_42 = ~rrd_stall; // @[src/main/scala/fpga/Core.scala 1078:14]
  wire  _T_43 = ~ex2_stall; // @[src/main/scala/fpga/Core.scala 1078:28]
  wire  _rrd_op1_data_T_2 = _rrd_stall_T_1 & rrd_reg_rs1_addr == 5'h0; // @[src/main/scala/fpga/Core.scala 1157:35]
  wire  _rrd_op1_data_T_4 = ex1_reg_fw_en & _rrd_stall_T_1; // @[src/main/scala/fpga/Core.scala 1158:20]
  wire  _rrd_op1_data_T_5 = rrd_reg_rs1_addr == ex1_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1160:24]
  wire  _rrd_op1_data_T_6 = _rrd_op1_data_T_4 & _rrd_op1_data_T_5; // @[src/main/scala/fpga/Core.scala 1159:37]
  wire  _rrd_op1_data_T_8 = ex2_reg_fw_en & _rrd_stall_T_1; // @[src/main/scala/fpga/Core.scala 1161:20]
  wire  _rrd_op1_data_T_9 = rrd_reg_rs1_addr == ex2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1163:24]
  wire  _rrd_op1_data_T_10 = _rrd_op1_data_T_8 & _rrd_op1_data_T_9; // @[src/main/scala/fpga/Core.scala 1162:37]
  wire  _rrd_op1_data_T_12 = mem3_reg_fw_en & _rrd_stall_T_1; // @[src/main/scala/fpga/Core.scala 1164:21]
  wire [31:0] _GEN_635 = {{27'd0}, rrd_reg_rs1_addr}; // @[src/main/scala/fpga/Core.scala 1166:24]
  wire  _rrd_op1_data_T_13 = _GEN_635 == mem3_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1166:24]
  wire  _rrd_op1_data_T_14 = _rrd_op1_data_T_12 & _rrd_op1_data_T_13; // @[src/main/scala/fpga/Core.scala 1165:37]
  wire [31:0] _rrd_op1_data_T_16 = _rrd_stall_T_1 ? regfile_rrd_op1_data_MPORT_data : rrd_reg_op1_data; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op1_data_T_17 = _rrd_op1_data_T_14 ? mem3_reg_dmem_rdata : _rrd_op1_data_T_16; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex2_fw_data_T_1 = ex2_reg_wb_sel == 3'h6; // @[src/main/scala/fpga/Core.scala 1726:23]
  wire  _ex2_fw_data_T_2 = ex2_reg_wb_sel == 3'h2 | _ex2_fw_data_T_1; // @[src/main/scala/fpga/Core.scala 1725:34]
  wire [31:0] ex2_fw_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 1723:21]
  wire [31:0] _rrd_op1_data_T_18 = _rrd_op1_data_T_10 ? ex2_fw_data : _rrd_op1_data_T_17; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex1_alu_out_T = ex1_reg_exe_fun == 4'h0; // @[src/main/scala/fpga/Core.scala 1260:22]
  wire [31:0] ex1_add_out = ex1_reg_op1_data + ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1258:38]
  wire  _ex1_alu_out_T_1 = ex1_reg_exe_fun == 4'h8; // @[src/main/scala/fpga/Core.scala 1261:22]
  wire [31:0] _ex1_alu_out_T_3 = ex1_reg_op1_data - ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1261:58]
  wire  _ex1_alu_out_T_4 = ex1_reg_exe_fun == 4'h2; // @[src/main/scala/fpga/Core.scala 1262:22]
  wire [31:0] _ex1_alu_out_T_5 = ex1_reg_op1_data & ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1262:58]
  wire  _ex1_alu_out_T_6 = ex1_reg_exe_fun == 4'h3; // @[src/main/scala/fpga/Core.scala 1263:22]
  wire [31:0] _ex1_alu_out_T_7 = ex1_reg_op1_data | ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1263:58]
  wire  _ex1_alu_out_T_8 = ex1_reg_exe_fun == 4'h1; // @[src/main/scala/fpga/Core.scala 1264:22]
  wire [31:0] _ex1_alu_out_T_9 = ex1_reg_op1_data ^ ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1264:58]
  wire  _ex1_alu_out_T_10 = ex1_reg_exe_fun == 4'h4; // @[src/main/scala/fpga/Core.scala 1265:22]
  wire [62:0] _ex1_alu_out_T_12 = {ex1_reg_op1_data,ex1_reg_op3_data[31:1]}; // @[src/main/scala/fpga/Core.scala 1265:44]
  wire [31:0] _ex1_alu_out_T_13 = ~ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1265:100]
  wire [62:0] _ex1_alu_out_T_15 = _ex1_alu_out_T_12 >> _ex1_alu_out_T_13[4:0]; // @[src/main/scala/fpga/Core.scala 1265:96]
  wire  _ex1_alu_out_T_17 = ex1_reg_exe_fun == 4'h5; // @[src/main/scala/fpga/Core.scala 1266:22]
  wire [62:0] _ex1_alu_out_T_19 = {ex1_reg_op3_data[30:0],ex1_reg_op1_data}; // @[src/main/scala/fpga/Core.scala 1266:44]
  wire [62:0] _ex1_alu_out_T_21 = _ex1_alu_out_T_19 >> ex1_reg_op2_data[4:0]; // @[src/main/scala/fpga/Core.scala 1266:96]
  wire  _ex1_alu_out_T_23 = ex1_reg_exe_fun == 4'h6; // @[src/main/scala/fpga/Core.scala 1267:22]
  wire  _ex1_alu_out_T_26 = $signed(ex1_reg_op1_data) < $signed(ex1_reg_op2_data); // @[src/main/scala/fpga/Core.scala 1267:65]
  wire  _ex1_alu_out_T_27 = ex1_reg_exe_fun == 4'h7; // @[src/main/scala/fpga/Core.scala 1268:22]
  wire  _ex1_alu_out_T_28 = ex1_reg_op1_data < ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1268:58]
  wire  _ex1_alu_out_T_29 = ex1_reg_exe_fun == 4'ha; // @[src/main/scala/fpga/Core.scala 1269:22]
  wire [31:0] _ex1_alu_out_T_31 = ex1_reg_op1_data & _ex1_alu_out_T_13; // @[src/main/scala/fpga/Core.scala 1269:58]
  wire  _ex1_alu_out_T_32 = ex1_reg_exe_fun == 4'h9; // @[src/main/scala/fpga/Core.scala 1270:22]
  wire [31:0] _ex1_alu_out_T_34 = ex1_reg_op1_data ^ _ex1_alu_out_T_13; // @[src/main/scala/fpga/Core.scala 1270:58]
  wire  _ex1_alu_out_T_35 = ex1_reg_exe_fun == 4'hb; // @[src/main/scala/fpga/Core.scala 1271:22]
  wire [31:0] _ex1_alu_out_T_37 = ex1_reg_op1_data | _ex1_alu_out_T_13; // @[src/main/scala/fpga/Core.scala 1271:58]
  wire  _ex1_alu_out_T_38 = ex1_reg_exe_fun == 4'hf; // @[src/main/scala/fpga/Core.scala 1272:22]
  wire [31:0] _ex1_alu_out_T_40 = 32'h0 < ex1_reg_op2_data ? ex1_reg_op1_data : ex1_reg_op3_data; // @[src/main/scala/fpga/Core.scala 1272:43]
  wire [31:0] _ex1_alu_out_T_41 = _ex1_alu_out_T_38 ? _ex1_alu_out_T_40 : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_42 = _ex1_alu_out_T_35 ? _ex1_alu_out_T_37 : _ex1_alu_out_T_41; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_43 = _ex1_alu_out_T_32 ? _ex1_alu_out_T_34 : _ex1_alu_out_T_42; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_44 = _ex1_alu_out_T_29 ? _ex1_alu_out_T_31 : _ex1_alu_out_T_43; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_45 = _ex1_alu_out_T_27 ? {{31'd0}, _ex1_alu_out_T_28} : _ex1_alu_out_T_44; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_46 = _ex1_alu_out_T_23 ? {{31'd0}, _ex1_alu_out_T_26} : _ex1_alu_out_T_45; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_47 = _ex1_alu_out_T_17 ? _ex1_alu_out_T_21[31:0] : _ex1_alu_out_T_46; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_48 = _ex1_alu_out_T_10 ? _ex1_alu_out_T_15[31:0] : _ex1_alu_out_T_47; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_49 = _ex1_alu_out_T_8 ? _ex1_alu_out_T_9 : _ex1_alu_out_T_48; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_50 = _ex1_alu_out_T_6 ? _ex1_alu_out_T_7 : _ex1_alu_out_T_49; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_51 = _ex1_alu_out_T_4 ? _ex1_alu_out_T_5 : _ex1_alu_out_T_50; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_alu_out_T_52 = _ex1_alu_out_T_1 ? _ex1_alu_out_T_3 : _ex1_alu_out_T_51; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] ex1_alu_out = _ex1_alu_out_T ? ex1_add_out : _ex1_alu_out_T_52; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op1_data_T_19 = _rrd_op1_data_T_6 ? ex1_alu_out : _rrd_op1_data_T_18; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] rrd_op1_data = _rrd_op1_data_T_2 ? 32'h0 : _rrd_op1_data_T_19; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _rrd_op2_data_T_2 = _rrd_stall_T_3 & rrd_reg_rs2_addr == 5'h0; // @[src/main/scala/fpga/Core.scala 1170:35]
  wire  _rrd_op2_data_T_4 = ex1_reg_fw_en & _rrd_stall_T_3; // @[src/main/scala/fpga/Core.scala 1171:20]
  wire  _rrd_op2_data_T_5 = rrd_reg_rs2_addr == ex1_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1173:24]
  wire  _rrd_op2_data_T_6 = _rrd_op2_data_T_4 & _rrd_op2_data_T_5; // @[src/main/scala/fpga/Core.scala 1172:37]
  wire  _rrd_op2_data_T_8 = ex2_reg_fw_en & _rrd_stall_T_3; // @[src/main/scala/fpga/Core.scala 1174:20]
  wire  _rrd_op2_data_T_9 = rrd_reg_rs2_addr == ex2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1176:24]
  wire  _rrd_op2_data_T_10 = _rrd_op2_data_T_8 & _rrd_op2_data_T_9; // @[src/main/scala/fpga/Core.scala 1175:37]
  wire  _rrd_op2_data_T_12 = mem3_reg_fw_en & _rrd_stall_T_3; // @[src/main/scala/fpga/Core.scala 1177:21]
  wire [31:0] _GEN_636 = {{27'd0}, rrd_reg_rs2_addr}; // @[src/main/scala/fpga/Core.scala 1179:24]
  wire  _rrd_op2_data_T_13 = _GEN_636 == mem3_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1179:24]
  wire  _rrd_op2_data_T_14 = _rrd_op2_data_T_12 & _rrd_op2_data_T_13; // @[src/main/scala/fpga/Core.scala 1178:37]
  wire [31:0] _rrd_op2_data_T_16 = _rrd_stall_T_3 ? regfile_rrd_op2_data_MPORT_data : rrd_reg_op2_data; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op2_data_T_17 = _rrd_op2_data_T_14 ? mem3_reg_dmem_rdata : _rrd_op2_data_T_16; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op2_data_T_18 = _rrd_op2_data_T_10 ? ex2_fw_data : _rrd_op2_data_T_17; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op2_data_T_19 = _rrd_op2_data_T_6 ? ex1_alu_out : _rrd_op2_data_T_18; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] rrd_op2_data = _rrd_op2_data_T_2 ? 32'h0 : _rrd_op2_data_T_19; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _rrd_op3_data_T = rrd_reg_op3_sel == 2'h0; // @[src/main/scala/fpga/Core.scala 1183:22]
  wire  _rrd_op3_data_T_1 = rrd_reg_op3_sel == 2'h1; // @[src/main/scala/fpga/Core.scala 1184:22]
  wire [31:0] _rrd_op3_data_T_4 = rrd_op1_data[31] ? 32'hffffffff : 32'h0; // @[src/main/scala/fpga/Core.scala 1184:44]
  wire  _rrd_op3_data_T_5 = rrd_reg_op3_sel == 2'h3; // @[src/main/scala/fpga/Core.scala 1185:22]
  wire  _rrd_op3_data_T_6 = rrd_reg_rs3_addr == 5'h0; // @[src/main/scala/fpga/Core.scala 1186:23]
  wire  _rrd_op3_data_T_7 = rrd_reg_rs3_addr == ex1_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1188:24]
  wire  _rrd_op3_data_T_8 = ex1_reg_fw_en & _rrd_op3_data_T_7; // @[src/main/scala/fpga/Core.scala 1187:20]
  wire  _rrd_op3_data_T_9 = rrd_reg_rs3_addr == ex2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1190:24]
  wire  _rrd_op3_data_T_10 = ex2_reg_fw_en & _rrd_op3_data_T_9; // @[src/main/scala/fpga/Core.scala 1189:20]
  wire [31:0] _GEN_637 = {{27'd0}, rrd_reg_rs3_addr}; // @[src/main/scala/fpga/Core.scala 1192:24]
  wire  _rrd_op3_data_T_11 = _GEN_637 == mem3_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1192:24]
  wire  _rrd_op3_data_T_12 = mem3_reg_fw_en & _rrd_op3_data_T_11; // @[src/main/scala/fpga/Core.scala 1191:21]
  wire [31:0] _rrd_op3_data_T_13 = _rrd_op3_data_T_12 ? mem3_reg_dmem_rdata : regfile_rrd_op3_data_MPORT_data; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op3_data_T_14 = _rrd_op3_data_T_10 ? ex2_fw_data : _rrd_op3_data_T_13; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op3_data_T_15 = _rrd_op3_data_T_8 ? ex1_alu_out : _rrd_op3_data_T_14; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op3_data_T_16 = _rrd_op3_data_T_6 ? 32'h0 : _rrd_op3_data_T_15; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op3_data_T_17 = _rrd_op3_data_T_5 ? rrd_op1_data : _rrd_op3_data_T_16; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _rrd_op3_data_T_18 = _rrd_op3_data_T_1 ? _rrd_op3_data_T_4 : _rrd_op3_data_T_17; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] rrd_op3_data = _rrd_op3_data_T ? 32'h0 : _rrd_op3_data_T_18; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] rrd_direct_jbr_pc = rrd_reg_pc + rrd_reg_imm_b_sext[31:1]; // @[src/main/scala/fpga/Core.scala 1195:38]
  wire  _rrd_hazard_T_1 = rrd_reg_wb_addr != 5'h0; // @[src/main/scala/fpga/Core.scala 1197:67]
  wire  rrd_hazard = rrd_reg_rf_wen & rrd_reg_wb_addr != 5'h0 & _T_42 & _if2_is_valid_inst_T; // @[src/main/scala/fpga/Core.scala 1197:90]
  wire  rrd_fw_en_next = rrd_hazard & rrd_reg_wb_sel == 3'h0; // @[src/main/scala/fpga/Core.scala 1198:35]
  wire  _T_51 = _T_43 & _T_42 & _if2_is_valid_inst_T & rrd_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 1205:48]
  wire  _T_53 = _T_51 & _rrd_hazard_T_1; // @[src/main/scala/fpga/Core.scala 1206:30]
  wire  rrd_mem_use_reg = _T_53 & rrd_reg_wb_sel == 3'h5; // @[src/main/scala/fpga/Core.scala 1207:5 1209:25 1200:38]
  wire  rrd_inst2_use_reg = _T_53 & (rrd_reg_wb_sel == 3'h6 | rrd_reg_wb_sel == 3'h2); // @[src/main/scala/fpga/Core.scala 1207:5 1210:25 1201:38]
  wire  rrd_inst3_use_reg = _T_53 & (rrd_reg_wb_sel == 3'h1 | rrd_reg_wb_sel == 3'h3); // @[src/main/scala/fpga/Core.scala 1207:5 1211:25 1202:38]
  wire  ex_is_bubble = rrd_stall | ex2_reg_is_br; // @[src/main/scala/fpga/Core.scala 1222:34]
  wire  _ex1_reg_is_mret_T = ~ex_is_bubble; // @[src/main/scala/fpga/Core.scala 1235:30]
  wire [47:0] ex1_mullu = ex1_reg_op1_data * ex1_reg_op2_data[15:0]; // @[src/main/scala/fpga/Core.scala 1275:38]
  wire [16:0] _ex1_mulls_T_2 = {1'b0,$signed(ex1_reg_op2_data[15:0])}; // @[src/main/scala/fpga/Core.scala 1276:45]
  wire [48:0] _ex1_mulls_T_3 = $signed(ex1_reg_op1_data) * $signed(_ex1_mulls_T_2); // @[src/main/scala/fpga/Core.scala 1276:45]
  wire [47:0] _ex1_mulls_T_5 = _ex1_mulls_T_3[47:0]; // @[src/main/scala/fpga/Core.scala 1276:45]
  wire [31:0] ex1_mulls = _ex1_mulls_T_5[47:16]; // @[src/main/scala/fpga/Core.scala 1276:81]
  wire [47:0] ex1_mulhuu = ex1_reg_op1_data * ex1_reg_op2_data[31:16]; // @[src/main/scala/fpga/Core.scala 1277:38]
  wire [15:0] _ex1_mulhss_T_2 = ex1_reg_op2_data[31:16]; // @[src/main/scala/fpga/Core.scala 1278:88]
  wire [47:0] ex1_mulhss = $signed(ex1_reg_op1_data) * $signed(_ex1_mulhss_T_2); // @[src/main/scala/fpga/Core.scala 1278:45]
  wire [16:0] _ex1_mulhsu_T_2 = {1'b0,$signed(ex1_reg_op2_data[31:16])}; // @[src/main/scala/fpga/Core.scala 1279:45]
  wire [48:0] _ex1_mulhsu_T_3 = $signed(ex1_reg_op1_data) * $signed(_ex1_mulhsu_T_2); // @[src/main/scala/fpga/Core.scala 1279:45]
  wire [47:0] ex1_mulhsu = _ex1_mulhsu_T_3[47:0]; // @[src/main/scala/fpga/Core.scala 1279:45]
  wire [30:0] _ex1_next_pc_T_1 = ex1_reg_pc + 31'h1; // @[src/main/scala/fpga/Core.scala 1281:53]
  wire [30:0] _ex1_next_pc_T_3 = ex1_reg_pc + 31'h2; // @[src/main/scala/fpga/Core.scala 1281:81]
  wire [30:0] ex1_next_pc = ex1_reg_is_half ? _ex1_next_pc_T_1 : _ex1_next_pc_T_3; // @[src/main/scala/fpga/Core.scala 1281:24]
  wire  _ex1_pc_bit_out_T = ex1_reg_wb_sel == 3'h2; // @[src/main/scala/fpga/Core.scala 1283:21]
  wire [31:0] _ex1_pc_bit_out_T_1 = {ex1_next_pc,1'h0}; // @[src/main/scala/fpga/Core.scala 1283:43]
  wire [31:0] _ex1_pc_bit_out_T_4 = {16'h0,ex1_reg_op1_data[15:0]}; // @[src/main/scala/fpga/Core.scala 1284:43]
  wire [1:0] _ex1_pc_bit_out_T_38 = ex1_reg_op1_data[0] + ex1_reg_op1_data[1]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_40 = ex1_reg_op1_data[2] + ex1_reg_op1_data[3]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_42 = _ex1_pc_bit_out_T_38 + _ex1_pc_bit_out_T_40; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_44 = ex1_reg_op1_data[4] + ex1_reg_op1_data[5]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_46 = ex1_reg_op1_data[6] + ex1_reg_op1_data[7]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_48 = _ex1_pc_bit_out_T_44 + _ex1_pc_bit_out_T_46; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [3:0] _ex1_pc_bit_out_T_50 = _ex1_pc_bit_out_T_42 + _ex1_pc_bit_out_T_48; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_52 = ex1_reg_op1_data[8] + ex1_reg_op1_data[9]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_54 = ex1_reg_op1_data[10] + ex1_reg_op1_data[11]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_56 = _ex1_pc_bit_out_T_52 + _ex1_pc_bit_out_T_54; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_58 = ex1_reg_op1_data[12] + ex1_reg_op1_data[13]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_60 = ex1_reg_op1_data[14] + ex1_reg_op1_data[15]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_62 = _ex1_pc_bit_out_T_58 + _ex1_pc_bit_out_T_60; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [3:0] _ex1_pc_bit_out_T_64 = _ex1_pc_bit_out_T_56 + _ex1_pc_bit_out_T_62; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [4:0] _ex1_pc_bit_out_T_66 = _ex1_pc_bit_out_T_50 + _ex1_pc_bit_out_T_64; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_68 = ex1_reg_op1_data[16] + ex1_reg_op1_data[17]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_70 = ex1_reg_op1_data[18] + ex1_reg_op1_data[19]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_72 = _ex1_pc_bit_out_T_68 + _ex1_pc_bit_out_T_70; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_74 = ex1_reg_op1_data[20] + ex1_reg_op1_data[21]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_76 = ex1_reg_op1_data[22] + ex1_reg_op1_data[23]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_78 = _ex1_pc_bit_out_T_74 + _ex1_pc_bit_out_T_76; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [3:0] _ex1_pc_bit_out_T_80 = _ex1_pc_bit_out_T_72 + _ex1_pc_bit_out_T_78; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_82 = ex1_reg_op1_data[24] + ex1_reg_op1_data[25]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_84 = ex1_reg_op1_data[26] + ex1_reg_op1_data[27]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_86 = _ex1_pc_bit_out_T_82 + _ex1_pc_bit_out_T_84; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_88 = ex1_reg_op1_data[28] + ex1_reg_op1_data[29]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [1:0] _ex1_pc_bit_out_T_90 = ex1_reg_op1_data[30] + ex1_reg_op1_data[31]; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [2:0] _ex1_pc_bit_out_T_92 = _ex1_pc_bit_out_T_88 + _ex1_pc_bit_out_T_90; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [3:0] _ex1_pc_bit_out_T_94 = _ex1_pc_bit_out_T_86 + _ex1_pc_bit_out_T_92; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [4:0] _ex1_pc_bit_out_T_96 = _ex1_pc_bit_out_T_80 + _ex1_pc_bit_out_T_94; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [5:0] _ex1_pc_bit_out_T_98 = _ex1_pc_bit_out_T_66 + _ex1_pc_bit_out_T_96; // @[src/main/scala/fpga/Core.scala 1285:48]
  wire [31:0] _GEN_638 = {{16'd0}, ex1_reg_op1_data[31:16]}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_104 = _GEN_638 & 32'hffff; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_106 = {ex1_reg_op1_data[15:0], 16'h0}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_108 = _ex1_pc_bit_out_T_106 & 32'hffff0000; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_109 = _ex1_pc_bit_out_T_104 | _ex1_pc_bit_out_T_108; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _GEN_639 = {{8'd0}, _ex1_pc_bit_out_T_109[31:8]}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_114 = _GEN_639 & 32'hff00ff; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_116 = {_ex1_pc_bit_out_T_109[23:0], 8'h0}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_118 = _ex1_pc_bit_out_T_116 & 32'hff00ff00; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_119 = _ex1_pc_bit_out_T_114 | _ex1_pc_bit_out_T_118; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _GEN_640 = {{4'd0}, _ex1_pc_bit_out_T_119[31:4]}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_124 = _GEN_640 & 32'hf0f0f0f; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_126 = {_ex1_pc_bit_out_T_119[27:0], 4'h0}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_128 = _ex1_pc_bit_out_T_126 & 32'hf0f0f0f0; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_129 = _ex1_pc_bit_out_T_124 | _ex1_pc_bit_out_T_128; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _GEN_641 = {{2'd0}, _ex1_pc_bit_out_T_129[31:2]}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_134 = _GEN_641 & 32'h33333333; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_136 = {_ex1_pc_bit_out_T_129[29:0], 2'h0}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_138 = _ex1_pc_bit_out_T_136 & 32'hcccccccc; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_139 = _ex1_pc_bit_out_T_134 | _ex1_pc_bit_out_T_138; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _GEN_642 = {{1'd0}, _ex1_pc_bit_out_T_139[31:1]}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_144 = _GEN_642 & 32'h55555555; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_146 = {_ex1_pc_bit_out_T_139[30:0], 1'h0}; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_148 = _ex1_pc_bit_out_T_146 & 32'haaaaaaaa; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [31:0] _ex1_pc_bit_out_T_149 = _ex1_pc_bit_out_T_144 | _ex1_pc_bit_out_T_148; // @[src/main/scala/fpga/Core.scala 1286:77]
  wire [32:0] _ex1_pc_bit_out_T_150 = {1'h1,_ex1_pc_bit_out_T_149}; // @[src/main/scala/fpga/Core.scala 1286:59]
  wire [5:0] _ex1_pc_bit_out_T_184 = _ex1_pc_bit_out_T_150[31] ? 6'h1f : 6'h20; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_185 = _ex1_pc_bit_out_T_150[30] ? 6'h1e : _ex1_pc_bit_out_T_184; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_186 = _ex1_pc_bit_out_T_150[29] ? 6'h1d : _ex1_pc_bit_out_T_185; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_187 = _ex1_pc_bit_out_T_150[28] ? 6'h1c : _ex1_pc_bit_out_T_186; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_188 = _ex1_pc_bit_out_T_150[27] ? 6'h1b : _ex1_pc_bit_out_T_187; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_189 = _ex1_pc_bit_out_T_150[26] ? 6'h1a : _ex1_pc_bit_out_T_188; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_190 = _ex1_pc_bit_out_T_150[25] ? 6'h19 : _ex1_pc_bit_out_T_189; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_191 = _ex1_pc_bit_out_T_150[24] ? 6'h18 : _ex1_pc_bit_out_T_190; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_192 = _ex1_pc_bit_out_T_150[23] ? 6'h17 : _ex1_pc_bit_out_T_191; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_193 = _ex1_pc_bit_out_T_150[22] ? 6'h16 : _ex1_pc_bit_out_T_192; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_194 = _ex1_pc_bit_out_T_150[21] ? 6'h15 : _ex1_pc_bit_out_T_193; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_195 = _ex1_pc_bit_out_T_150[20] ? 6'h14 : _ex1_pc_bit_out_T_194; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_196 = _ex1_pc_bit_out_T_150[19] ? 6'h13 : _ex1_pc_bit_out_T_195; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_197 = _ex1_pc_bit_out_T_150[18] ? 6'h12 : _ex1_pc_bit_out_T_196; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_198 = _ex1_pc_bit_out_T_150[17] ? 6'h11 : _ex1_pc_bit_out_T_197; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_199 = _ex1_pc_bit_out_T_150[16] ? 6'h10 : _ex1_pc_bit_out_T_198; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_200 = _ex1_pc_bit_out_T_150[15] ? 6'hf : _ex1_pc_bit_out_T_199; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_201 = _ex1_pc_bit_out_T_150[14] ? 6'he : _ex1_pc_bit_out_T_200; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_202 = _ex1_pc_bit_out_T_150[13] ? 6'hd : _ex1_pc_bit_out_T_201; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_203 = _ex1_pc_bit_out_T_150[12] ? 6'hc : _ex1_pc_bit_out_T_202; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_204 = _ex1_pc_bit_out_T_150[11] ? 6'hb : _ex1_pc_bit_out_T_203; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_205 = _ex1_pc_bit_out_T_150[10] ? 6'ha : _ex1_pc_bit_out_T_204; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_206 = _ex1_pc_bit_out_T_150[9] ? 6'h9 : _ex1_pc_bit_out_T_205; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_207 = _ex1_pc_bit_out_T_150[8] ? 6'h8 : _ex1_pc_bit_out_T_206; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_208 = _ex1_pc_bit_out_T_150[7] ? 6'h7 : _ex1_pc_bit_out_T_207; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_209 = _ex1_pc_bit_out_T_150[6] ? 6'h6 : _ex1_pc_bit_out_T_208; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_210 = _ex1_pc_bit_out_T_150[5] ? 6'h5 : _ex1_pc_bit_out_T_209; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_211 = _ex1_pc_bit_out_T_150[4] ? 6'h4 : _ex1_pc_bit_out_T_210; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_212 = _ex1_pc_bit_out_T_150[3] ? 6'h3 : _ex1_pc_bit_out_T_211; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_213 = _ex1_pc_bit_out_T_150[2] ? 6'h2 : _ex1_pc_bit_out_T_212; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_214 = _ex1_pc_bit_out_T_150[1] ? 6'h1 : _ex1_pc_bit_out_T_213; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_215 = _ex1_pc_bit_out_T_150[0] ? 6'h0 : _ex1_pc_bit_out_T_214; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [32:0] _ex1_pc_bit_out_T_217 = {1'h1,ex1_reg_op1_data}; // @[src/main/scala/fpga/Core.scala 1287:59]
  wire [5:0] _ex1_pc_bit_out_T_251 = _ex1_pc_bit_out_T_217[31] ? 6'h1f : 6'h20; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_252 = _ex1_pc_bit_out_T_217[30] ? 6'h1e : _ex1_pc_bit_out_T_251; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_253 = _ex1_pc_bit_out_T_217[29] ? 6'h1d : _ex1_pc_bit_out_T_252; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_254 = _ex1_pc_bit_out_T_217[28] ? 6'h1c : _ex1_pc_bit_out_T_253; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_255 = _ex1_pc_bit_out_T_217[27] ? 6'h1b : _ex1_pc_bit_out_T_254; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_256 = _ex1_pc_bit_out_T_217[26] ? 6'h1a : _ex1_pc_bit_out_T_255; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_257 = _ex1_pc_bit_out_T_217[25] ? 6'h19 : _ex1_pc_bit_out_T_256; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_258 = _ex1_pc_bit_out_T_217[24] ? 6'h18 : _ex1_pc_bit_out_T_257; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_259 = _ex1_pc_bit_out_T_217[23] ? 6'h17 : _ex1_pc_bit_out_T_258; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_260 = _ex1_pc_bit_out_T_217[22] ? 6'h16 : _ex1_pc_bit_out_T_259; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_261 = _ex1_pc_bit_out_T_217[21] ? 6'h15 : _ex1_pc_bit_out_T_260; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_262 = _ex1_pc_bit_out_T_217[20] ? 6'h14 : _ex1_pc_bit_out_T_261; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_263 = _ex1_pc_bit_out_T_217[19] ? 6'h13 : _ex1_pc_bit_out_T_262; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_264 = _ex1_pc_bit_out_T_217[18] ? 6'h12 : _ex1_pc_bit_out_T_263; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_265 = _ex1_pc_bit_out_T_217[17] ? 6'h11 : _ex1_pc_bit_out_T_264; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_266 = _ex1_pc_bit_out_T_217[16] ? 6'h10 : _ex1_pc_bit_out_T_265; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_267 = _ex1_pc_bit_out_T_217[15] ? 6'hf : _ex1_pc_bit_out_T_266; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_268 = _ex1_pc_bit_out_T_217[14] ? 6'he : _ex1_pc_bit_out_T_267; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_269 = _ex1_pc_bit_out_T_217[13] ? 6'hd : _ex1_pc_bit_out_T_268; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_270 = _ex1_pc_bit_out_T_217[12] ? 6'hc : _ex1_pc_bit_out_T_269; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_271 = _ex1_pc_bit_out_T_217[11] ? 6'hb : _ex1_pc_bit_out_T_270; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_272 = _ex1_pc_bit_out_T_217[10] ? 6'ha : _ex1_pc_bit_out_T_271; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_273 = _ex1_pc_bit_out_T_217[9] ? 6'h9 : _ex1_pc_bit_out_T_272; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_274 = _ex1_pc_bit_out_T_217[8] ? 6'h8 : _ex1_pc_bit_out_T_273; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_275 = _ex1_pc_bit_out_T_217[7] ? 6'h7 : _ex1_pc_bit_out_T_274; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_276 = _ex1_pc_bit_out_T_217[6] ? 6'h6 : _ex1_pc_bit_out_T_275; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_277 = _ex1_pc_bit_out_T_217[5] ? 6'h5 : _ex1_pc_bit_out_T_276; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_278 = _ex1_pc_bit_out_T_217[4] ? 6'h4 : _ex1_pc_bit_out_T_277; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_279 = _ex1_pc_bit_out_T_217[3] ? 6'h3 : _ex1_pc_bit_out_T_278; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_280 = _ex1_pc_bit_out_T_217[2] ? 6'h2 : _ex1_pc_bit_out_T_279; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_281 = _ex1_pc_bit_out_T_217[1] ? 6'h1 : _ex1_pc_bit_out_T_280; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [5:0] _ex1_pc_bit_out_T_282 = _ex1_pc_bit_out_T_217[0] ? 6'h0 : _ex1_pc_bit_out_T_281; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [31:0] _ex1_pc_bit_out_T_288 = {ex1_reg_op1_data[7:0],ex1_reg_op1_data[15:8],ex1_reg_op1_data[23:16],
    ex1_reg_op1_data[31:24]}; // @[src/main/scala/fpga/Core.scala 1288:43]
  wire [23:0] _ex1_pc_bit_out_T_292 = ex1_reg_op1_data[7] ? 24'hffffff : 24'h0; // @[src/main/scala/fpga/Core.scala 1289:48]
  wire [31:0] _ex1_pc_bit_out_T_294 = {_ex1_pc_bit_out_T_292,ex1_reg_op1_data[7:0]}; // @[src/main/scala/fpga/Core.scala 1289:43]
  wire [15:0] _ex1_pc_bit_out_T_298 = ex1_reg_op1_data[15] ? 16'hffff : 16'h0; // @[src/main/scala/fpga/Core.scala 1290:48]
  wire [31:0] _ex1_pc_bit_out_T_300 = {_ex1_pc_bit_out_T_298,ex1_reg_op1_data[15:0]}; // @[src/main/scala/fpga/Core.scala 1290:43]
  wire  _ex1_pc_bit_out_T_301 = ex1_reg_exe_fun == 4'hc; // @[src/main/scala/fpga/Core.scala 1291:22]
  wire [31:0] _ex1_pc_bit_out_T_305 = _ex1_alu_out_T_26 ? ex1_reg_op2_data : ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 1291:43]
  wire  _ex1_pc_bit_out_T_306 = ex1_reg_exe_fun == 4'hd; // @[src/main/scala/fpga/Core.scala 1292:22]
  wire [31:0] _ex1_pc_bit_out_T_308 = _ex1_alu_out_T_28 ? ex1_reg_op2_data : ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 1292:43]
  wire  _ex1_pc_bit_out_T_309 = ex1_reg_exe_fun == 4'he; // @[src/main/scala/fpga/Core.scala 1293:22]
  wire [31:0] _ex1_pc_bit_out_T_313 = _ex1_alu_out_T_26 ? ex1_reg_op1_data : ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1293:43]
  wire [31:0] _ex1_pc_bit_out_T_316 = _ex1_alu_out_T_28 ? ex1_reg_op1_data : ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1294:43]
  wire [31:0] _ex1_pc_bit_out_T_317 = _ex1_alu_out_T_38 ? _ex1_pc_bit_out_T_316 : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_318 = _ex1_pc_bit_out_T_309 ? _ex1_pc_bit_out_T_313 : _ex1_pc_bit_out_T_317; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_319 = _ex1_pc_bit_out_T_306 ? _ex1_pc_bit_out_T_308 : _ex1_pc_bit_out_T_318; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_320 = _ex1_pc_bit_out_T_301 ? _ex1_pc_bit_out_T_305 : _ex1_pc_bit_out_T_319; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_321 = _ex1_alu_out_T_32 ? _ex1_pc_bit_out_T_300 : _ex1_pc_bit_out_T_320; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_322 = _ex1_alu_out_T_1 ? _ex1_pc_bit_out_T_294 : _ex1_pc_bit_out_T_321; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_323 = _ex1_alu_out_T_27 ? _ex1_pc_bit_out_T_288 : _ex1_pc_bit_out_T_322; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_324 = _ex1_alu_out_T_17 ? {{26'd0}, _ex1_pc_bit_out_T_282} : _ex1_pc_bit_out_T_323; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_325 = _ex1_alu_out_T_10 ? {{26'd0}, _ex1_pc_bit_out_T_215} : _ex1_pc_bit_out_T_324; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex1_pc_bit_out_T_326 = _ex1_alu_out_T_23 ? {{26'd0}, _ex1_pc_bit_out_T_98} : _ex1_pc_bit_out_T_325; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex1_divrem_T = ex1_reg_wb_sel == 3'h1; // @[src/main/scala/fpga/Core.scala 1306:34]
  wire [31:0] _ex1_dividend_T_1 = ~ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 1308:47]
  wire [31:0] _ex1_dividend_T_3 = _ex1_dividend_T_1 + 32'h1; // @[src/main/scala/fpga/Core.scala 1308:65]
  wire [36:0] _ex1_dividend_T_5 = {5'h0,_ex1_dividend_T_3}; // @[src/main/scala/fpga/Core.scala 1308:26]
  wire [36:0] _ex1_dividend_T_8 = {5'h0,ex1_reg_op1_data}; // @[src/main/scala/fpga/Core.scala 1310:26]
  wire [31:0] _ex1_divisor_T_2 = _ex1_alu_out_T_13 + 32'h1; // @[src/main/scala/fpga/Core.scala 1314:41]
  wire  ex1_sign_op1 = (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) & ex1_reg_op1_data[31]; // @[src/main/scala/fpga/Core.scala 1305:69 1312:18]
  wire  _GEN_409 = ex1_reg_op2_data[31] ? ~ex1_sign_op1 : ex1_sign_op1; // @[src/main/scala/fpga/Core.scala 1313:49 1315:21 1318:21]
  wire  _GEN_410 = (_ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38) & _ex1_divrem_T; // @[src/main/scala/fpga/Core.scala 1320:77 1321:16 1297:31]
  wire  ex1_divrem = _ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306 ? ex1_reg_wb_sel == 3'h1 : _GEN_410; // @[src/main/scala/fpga/Core.scala 1305:69 1306:16]
  wire  ex1_sign_op12 = (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) & _GEN_409; // @[src/main/scala/fpga/Core.scala 1305:69]
  wire  ex1_zero_op2 = ex1_reg_op2_data == 32'h0; // @[src/main/scala/fpga/Core.scala 1327:37]
  wire  _ex1_is_cond_br_T_1 = ex1_reg_op1_data == ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1333:57]
  wire  _ex1_is_cond_br_T_4 = ~_ex1_is_cond_br_T_1; // @[src/main/scala/fpga/Core.scala 1334:38]
  wire  _ex1_is_cond_br_T_13 = ~_ex1_alu_out_T_26; // @[src/main/scala/fpga/Core.scala 1336:38]
  wire  _ex1_is_cond_br_T_18 = ~_ex1_alu_out_T_28; // @[src/main/scala/fpga/Core.scala 1338:38]
  wire  _ex1_is_cond_br_T_20 = _ex1_pc_bit_out_T_301 ? _ex1_alu_out_T_28 : _ex1_pc_bit_out_T_306 & _ex1_is_cond_br_T_18; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex1_is_cond_br_T_21 = _ex1_alu_out_T_35 ? _ex1_is_cond_br_T_13 : _ex1_is_cond_br_T_20; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex1_is_cond_br_T_22 = _ex1_alu_out_T_29 ? _ex1_alu_out_T_26 : _ex1_is_cond_br_T_21; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _ex1_is_cond_br_T_23 = _ex1_alu_out_T_32 ? _ex1_is_cond_br_T_4 : _ex1_is_cond_br_T_22; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  ex1_is_cond_br = _ex1_alu_out_T_1 ? _ex1_is_cond_br_T_1 : _ex1_is_cond_br_T_23; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] ex1_taken_pc = ex1_reg_is_j ? ex1_add_out[31:1] : ex1_reg_direct_jbr_pc; // @[src/main/scala/fpga/Core.scala 1342:25]
  wire  _ex1_br_pc_T_1 = ex1_reg_is_br & ex1_is_cond_br | ex1_reg_is_j; // @[src/main/scala/fpga/Core.scala 1345:46]
  wire [30:0] _ex1_br_pc_T_2 = _ex1_br_pc_T_1 ? ex1_taken_pc : ex1_next_pc; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  reg  csr_reg_is_meintr; // @[src/main/scala/fpga/Core.scala 1384:34]
  wire  csr_is_valid_inst = ex1_reg_is_valid_inst & _if2_is_valid_inst_T; // @[src/main/scala/fpga/Core.scala 1395:49]
  wire  csr_is_meintr = csr_reg_is_meintr & csr_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1396:41]
  reg  csr_reg_is_mtintr; // @[src/main/scala/fpga/Core.scala 1389:34]
  wire  csr_is_mtintr = csr_reg_is_mtintr & csr_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1397:41]
  wire  ex1_en = csr_is_valid_inst & ~csr_is_meintr & ~csr_is_mtintr; // @[src/main/scala/fpga/Core.scala 1398:49]
  wire  csr_is_trap = ex1_en & ex1_reg_is_trap; // @[src/main/scala/fpga/Core.scala 1399:28]
  wire  csr_is_mret = ex1_en & ex1_reg_is_mret; // @[src/main/scala/fpga/Core.scala 1401:28]
  wire  _GEN_492 = csr_is_trap | csr_is_mret; // @[src/main/scala/fpga/Core.scala 1469:28 1477:26]
  wire  _GEN_500 = csr_is_mtintr | _GEN_492; // @[src/main/scala/fpga/Core.scala 1459:30 1467:26]
  wire  csr_is_br = csr_is_meintr | _GEN_500; // @[src/main/scala/fpga/Core.scala 1449:24 1457:26]
  wire [30:0] _GEN_493 = csr_is_trap ? csr_reg_trap_vector : csr_reg_mepc; // @[src/main/scala/fpga/Core.scala 1469:28 1478:26]
  wire [30:0] _GEN_501 = csr_is_mtintr ? csr_reg_trap_vector : _GEN_493; // @[src/main/scala/fpga/Core.scala 1459:30 1468:26]
  wire [30:0] csr_br_pc = csr_is_meintr ? csr_reg_trap_vector : _GEN_501; // @[src/main/scala/fpga/Core.scala 1449:24 1458:26]
  wire [30:0] ex1_br_pc = csr_is_br ? csr_br_pc : _ex1_br_pc_T_2; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] ex1_predict_pc = ex1_reg_bp_taken ? ex1_reg_bp_taken_pc : ex1_next_pc; // @[src/main/scala/fpga/Core.scala 1347:27]
  wire  ex1_bp_failure = ex1_br_pc != ex1_predict_pc; // @[src/main/scala/fpga/Core.scala 1348:34]
  wire  ex1_is_br = ex1_bp_failure & _if2_is_valid_inst_T; // @[src/main/scala/fpga/Core.scala 1350:31]
  wire  _ic_pht_io_up_cnt_T_6 = ~ex1_reg_bp_cnt[1] | ex1_reg_bp_cnt[0]; // @[src/main/scala/fpga/Core.scala 1358:51]
  wire [1:0] _ic_pht_io_up_cnt_T_7 = {ex1_reg_bp_cnt[0],_ic_pht_io_up_cnt_T_6}; // @[src/main/scala/fpga/Core.scala 1358:8]
  wire  _ic_pht_io_up_cnt_T_9 = ~ex1_reg_bp_cnt[0]; // @[src/main/scala/fpga/Core.scala 1359:9]
  wire  _ic_pht_io_up_cnt_T_12 = ex1_reg_bp_cnt[1] & ex1_reg_bp_cnt[0]; // @[src/main/scala/fpga/Core.scala 1359:51]
  wire [1:0] _ic_pht_io_up_cnt_T_13 = {_ic_pht_io_up_cnt_T_9,_ic_pht_io_up_cnt_T_12}; // @[src/main/scala/fpga/Core.scala 1359:8]
  wire  _T_68 = ~ex1_en & (ex1_reg_mem_use_reg | ex1_reg_inst3_use_reg); // @[src/main/scala/fpga/Core.scala 1364:43]
  wire  ex1_hazard = ex1_reg_rf_wen & ex1_reg_wb_addr != 5'h0 & ex1_en; // @[src/main/scala/fpga/Core.scala 1368:76]
  wire  _ex1_fw_en_next_T_2 = ex1_reg_wb_sel != 3'h5; // @[src/main/scala/fpga/Core.scala 1369:84]
  wire  ex1_fw_en_next = ex1_hazard & ex1_reg_wb_sel != 3'h1 & ex1_reg_wb_sel != 3'h5; // @[src/main/scala/fpga/Core.scala 1369:65]
  wire  _T_74 = ex1_reg_csr_addr == 12'h300; // @[src/main/scala/fpga/Core.scala 1431:34]
  wire  _GEN_448 = ex1_reg_csr_addr == 12'h341 ? 1'h0 : _T_74; // @[src/main/scala/fpga/Core.scala 1382:42 1429:53]
  wire  _GEN_460 = ex1_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_448; // @[src/main/scala/fpga/Core.scala 1382:42 1427:48]
  wire  _GEN_472 = ex1_en & ex1_reg_wb_sel == 3'h3 & _GEN_460; // @[src/main/scala/fpga/Core.scala 1382:42 1426:46]
  wire  _GEN_482 = csr_is_mret | _GEN_472; // @[src/main/scala/fpga/Core.scala 1479:28 1482:26]
  wire  _GEN_490 = csr_is_trap | _GEN_482; // @[src/main/scala/fpga/Core.scala 1469:28 1475:26]
  wire  _GEN_498 = csr_is_mtintr | _GEN_490; // @[src/main/scala/fpga/Core.scala 1459:30 1465:26]
  wire  csr_mstatus_mie_fw_en = csr_is_meintr | _GEN_498; // @[src/main/scala/fpga/Core.scala 1449:24 1455:26]
  wire  _csr_wdata_T = ex1_reg_csr_cmd == 2'h1; // @[src/main/scala/fpga/Core.scala 1421:22]
  wire  _csr_wdata_T_1 = ex1_reg_csr_cmd == 2'h2; // @[src/main/scala/fpga/Core.scala 1422:22]
  wire [31:0] _csr_rdata_T_10 = {20'h0,io_intr,3'h0,mtimer_io_intr,7'h0}; // @[src/main/scala/fpga/Core.scala 1417:29]
  wire [31:0] _csr_rdata_T_9 = {20'h0,csr_reg_mie_meie,3'h0,csr_reg_mie_mtie,7'h0}; // @[src/main/scala/fpga/Core.scala 1416:29]
  wire [31:0] _csr_rdata_T_8 = {24'h0,csr_reg_mstatus_mpie,3'h0,csr_reg_mstatus_mie,3'h0}; // @[src/main/scala/fpga/Core.scala 1414:29]
  wire [31:0] _csr_rdata_T_7 = {csr_reg_mepc,1'h0}; // @[src/main/scala/fpga/Core.scala 1411:29]
  wire [31:0] _csr_rdata_T = {csr_reg_trap_vector,1'h0}; // @[src/main/scala/fpga/Core.scala 1404:29]
  wire [31:0] _csr_rdata_T_12 = 12'h305 == ex1_reg_csr_addr ? _csr_rdata_T : 32'h0; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_14 = 12'hc01 == ex1_reg_csr_addr ? mtimer_io_mtime[31:0] : _csr_rdata_T_12; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_16 = 12'hc00 == ex1_reg_csr_addr ? cycle_counter_io_value[31:0] : _csr_rdata_T_14; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_18 = 12'hc02 == ex1_reg_csr_addr ? instret[31:0] : _csr_rdata_T_16; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_20 = 12'hc80 == ex1_reg_csr_addr ? cycle_counter_io_value[63:32] : _csr_rdata_T_18; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_22 = 12'hc81 == ex1_reg_csr_addr ? mtimer_io_mtime[63:32] : _csr_rdata_T_20; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_24 = 12'hc82 == ex1_reg_csr_addr ? instret[63:32] : _csr_rdata_T_22; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_26 = 12'h341 == ex1_reg_csr_addr ? _csr_rdata_T_7 : _csr_rdata_T_24; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_28 = 12'h342 == ex1_reg_csr_addr ? csr_reg_mcause : _csr_rdata_T_26; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_30 = 12'h300 == ex1_reg_csr_addr ? _csr_rdata_T_8 : _csr_rdata_T_28; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_32 = 12'h340 == ex1_reg_csr_addr ? csr_reg_mscratch : _csr_rdata_T_30; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_rdata_T_34 = 12'h304 == ex1_reg_csr_addr ? _csr_rdata_T_9 : _csr_rdata_T_32; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] csr_rdata = 12'h344 == ex1_reg_csr_addr ? _csr_rdata_T_10 : _csr_rdata_T_34; // @[src/main/scala/fpga/Core.scala 1403:63]
  wire [31:0] _csr_wdata_T_2 = csr_rdata | ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 1422:47]
  wire  _csr_wdata_T_3 = ex1_reg_csr_cmd == 2'h3; // @[src/main/scala/fpga/Core.scala 1423:22]
  wire [31:0] _csr_wdata_T_5 = csr_rdata & _ex1_dividend_T_1; // @[src/main/scala/fpga/Core.scala 1423:47]
  wire [31:0] _csr_wdata_T_6 = _csr_wdata_T_3 ? _csr_wdata_T_5 : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] csr_wdata = _csr_wdata_T ? ex1_reg_op1_data : _csr_wdata_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _GEN_438 = ex1_reg_csr_addr == 12'h300 & csr_wdata[3]; // @[src/main/scala/fpga/Core.scala 1431:56 1435:29 1383:39]
  wire  _GEN_449 = ex1_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_438; // @[src/main/scala/fpga/Core.scala 1383:39 1429:53]
  wire  _GEN_461 = ex1_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_449; // @[src/main/scala/fpga/Core.scala 1383:39 1427:48]
  wire  _GEN_473 = ex1_en & ex1_reg_wb_sel == 3'h3 & _GEN_461; // @[src/main/scala/fpga/Core.scala 1383:39 1426:46]
  wire  _GEN_483 = csr_is_mret ? csr_reg_mstatus_mpie : _GEN_473; // @[src/main/scala/fpga/Core.scala 1479:28 1483:26]
  wire  _GEN_491 = csr_is_trap ? 1'h0 : _GEN_483; // @[src/main/scala/fpga/Core.scala 1469:28 1476:26]
  wire  _GEN_499 = csr_is_mtintr ? 1'h0 : _GEN_491; // @[src/main/scala/fpga/Core.scala 1459:30 1466:26]
  wire  csr_mstatus_mie_fw = csr_is_meintr ? 1'h0 : _GEN_499; // @[src/main/scala/fpga/Core.scala 1449:24 1456:26]
  wire  _csr_reg_is_meintr_T_3 = csr_mstatus_mie_fw_en & csr_mstatus_mie_fw | ~csr_mstatus_mie_fw_en &
    csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1385:52]
  wire  _csr_reg_is_meintr_T_4 = (csr_mstatus_mie_fw_en & csr_mstatus_mie_fw | ~csr_mstatus_mie_fw_en &
    csr_reg_mstatus_mie) & io_intr; // @[src/main/scala/fpga/Core.scala 1385:104]
  wire  _T_76 = ex1_reg_csr_addr == 12'h304; // @[src/main/scala/fpga/Core.scala 1438:34]
  wire  _GEN_432 = ex1_reg_csr_addr == 12'h340 ? 1'h0 : _T_76; // @[src/main/scala/fpga/Core.scala 1379:34 1436:57]
  wire  _GEN_442 = ex1_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_432; // @[src/main/scala/fpga/Core.scala 1379:34 1431:56]
  wire  _GEN_453 = ex1_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_442; // @[src/main/scala/fpga/Core.scala 1379:34 1429:53]
  wire  _GEN_465 = ex1_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_453; // @[src/main/scala/fpga/Core.scala 1379:34 1427:48]
  wire  csr_mie_fw_en = ex1_en & ex1_reg_wb_sel == 3'h3 & _GEN_465; // @[src/main/scala/fpga/Core.scala 1379:34 1426:46]
  wire  _GEN_427 = ex1_reg_csr_addr == 12'h304 & csr_wdata[11]; // @[src/main/scala/fpga/Core.scala 1438:52 1442:24 1380:36]
  wire  _GEN_433 = ex1_reg_csr_addr == 12'h340 ? 1'h0 : _GEN_427; // @[src/main/scala/fpga/Core.scala 1380:36 1436:57]
  wire  _GEN_443 = ex1_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_433; // @[src/main/scala/fpga/Core.scala 1380:36 1431:56]
  wire  _GEN_454 = ex1_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_443; // @[src/main/scala/fpga/Core.scala 1380:36 1429:53]
  wire  _GEN_466 = ex1_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_454; // @[src/main/scala/fpga/Core.scala 1380:36 1427:48]
  wire  csr_mie_meie_fw = ex1_en & ex1_reg_wb_sel == 3'h3 & _GEN_466; // @[src/main/scala/fpga/Core.scala 1380:36 1426:46]
  wire  _csr_reg_is_meintr_T_6 = ~csr_mie_fw_en; // @[src/main/scala/fpga/Core.scala 1387:47]
  wire  _csr_reg_is_meintr_T_8 = csr_mie_fw_en & csr_mie_meie_fw | ~csr_mie_fw_en & csr_reg_mie_meie; // @[src/main/scala/fpga/Core.scala 1387:43]
  wire  _csr_reg_is_mtintr_T_4 = _csr_reg_is_meintr_T_3 & mtimer_io_intr; // @[src/main/scala/fpga/Core.scala 1390:104]
  wire  _GEN_428 = ex1_reg_csr_addr == 12'h304 & csr_wdata[7]; // @[src/main/scala/fpga/Core.scala 1438:52 1443:24 1381:36]
  wire  _GEN_434 = ex1_reg_csr_addr == 12'h340 ? 1'h0 : _GEN_428; // @[src/main/scala/fpga/Core.scala 1381:36 1436:57]
  wire  _GEN_444 = ex1_reg_csr_addr == 12'h300 ? 1'h0 : _GEN_434; // @[src/main/scala/fpga/Core.scala 1381:36 1431:56]
  wire  _GEN_455 = ex1_reg_csr_addr == 12'h341 ? 1'h0 : _GEN_444; // @[src/main/scala/fpga/Core.scala 1381:36 1429:53]
  wire  _GEN_467 = ex1_reg_csr_addr == 12'h305 ? 1'h0 : _GEN_455; // @[src/main/scala/fpga/Core.scala 1381:36 1427:48]
  wire  csr_mie_mtie_fw = ex1_en & ex1_reg_wb_sel == 3'h3 & _GEN_467; // @[src/main/scala/fpga/Core.scala 1381:36 1426:46]
  wire  _csr_reg_is_mtintr_T_8 = csr_mie_fw_en & csr_mie_mtie_fw | _csr_reg_is_meintr_T_6 & csr_reg_mie_mtie; // @[src/main/scala/fpga/Core.scala 1392:43]
  wire  ex1_is_valid_inst = ex1_en & ~ex1_reg_is_trap; // @[src/main/scala/fpga/Core.scala 1400:34]
  wire  _GEN_424 = ex1_reg_csr_addr == 12'h304 ? csr_wdata[11] : csr_reg_mie_meie; // @[src/main/scala/fpga/Core.scala 1438:52 1439:24 146:37]
  wire  _GEN_425 = ex1_reg_csr_addr == 12'h304 ? csr_wdata[7] : csr_reg_mie_mtie; // @[src/main/scala/fpga/Core.scala 1438:52 1440:24 147:37]
  wire [31:0] _GEN_429 = ex1_reg_csr_addr == 12'h340 ? csr_wdata : csr_reg_mscratch; // @[src/main/scala/fpga/Core.scala 1436:57 1437:24 145:37]
  wire  _GEN_430 = ex1_reg_csr_addr == 12'h340 ? csr_reg_mie_meie : _GEN_424; // @[src/main/scala/fpga/Core.scala 1436:57 146:37]
  wire  _GEN_431 = ex1_reg_csr_addr == 12'h340 ? csr_reg_mie_mtie : _GEN_425; // @[src/main/scala/fpga/Core.scala 1436:57 147:37]
  wire  _GEN_435 = ex1_reg_csr_addr == 12'h300 ? csr_wdata[3] : csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1431:56 1432:29 143:37]
  wire  _GEN_436 = ex1_reg_csr_addr == 12'h300 ? csr_wdata[7] : csr_reg_mstatus_mpie; // @[src/main/scala/fpga/Core.scala 1431:56 1433:29 144:37]
  wire [31:0] _GEN_439 = ex1_reg_csr_addr == 12'h300 ? csr_reg_mscratch : _GEN_429; // @[src/main/scala/fpga/Core.scala 1431:56 145:37]
  wire  _GEN_440 = ex1_reg_csr_addr == 12'h300 ? csr_reg_mie_meie : _GEN_430; // @[src/main/scala/fpga/Core.scala 1431:56 146:37]
  wire  _GEN_441 = ex1_reg_csr_addr == 12'h300 ? csr_reg_mie_mtie : _GEN_431; // @[src/main/scala/fpga/Core.scala 1431:56 147:37]
  wire [30:0] _GEN_445 = ex1_reg_csr_addr == 12'h341 ? csr_wdata[31:1] : csr_reg_mepc; // @[src/main/scala/fpga/Core.scala 1429:53 1430:20 142:37]
  wire  _GEN_446 = ex1_reg_csr_addr == 12'h341 ? csr_reg_mstatus_mie : _GEN_435; // @[src/main/scala/fpga/Core.scala 1429:53 143:37]
  wire  _GEN_447 = ex1_reg_csr_addr == 12'h341 ? csr_reg_mstatus_mpie : _GEN_436; // @[src/main/scala/fpga/Core.scala 1429:53 144:37]
  wire [30:0] _GEN_457 = ex1_reg_csr_addr == 12'h305 ? csr_reg_mepc : _GEN_445; // @[src/main/scala/fpga/Core.scala 142:37 1427:48]
  wire  _GEN_458 = ex1_reg_csr_addr == 12'h305 ? csr_reg_mstatus_mie : _GEN_446; // @[src/main/scala/fpga/Core.scala 1427:48 143:37]
  wire  _GEN_459 = ex1_reg_csr_addr == 12'h305 ? csr_reg_mstatus_mpie : _GEN_447; // @[src/main/scala/fpga/Core.scala 1427:48 144:37]
  wire [30:0] _GEN_469 = ex1_en & ex1_reg_wb_sel == 3'h3 ? _GEN_457 : csr_reg_mepc; // @[src/main/scala/fpga/Core.scala 142:37 1426:46]
  wire  _GEN_470 = ex1_en & ex1_reg_wb_sel == 3'h3 ? _GEN_458 : csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1426:46 143:37]
  wire  _GEN_471 = ex1_en & ex1_reg_wb_sel == 3'h3 ? _GEN_459 : csr_reg_mstatus_mpie; // @[src/main/scala/fpga/Core.scala 1426:46 144:37]
  wire  _GEN_480 = csr_is_mret | _GEN_471; // @[src/main/scala/fpga/Core.scala 1479:28 1480:26]
  wire  _GEN_481 = csr_is_mret ? csr_reg_mstatus_mpie : _GEN_470; // @[src/main/scala/fpga/Core.scala 1479:28 1481:26]
  wire  _ex2_reg_divrem_T = ex1_divrem & ex1_en; // @[src/main/scala/fpga/Core.scala 1511:45]
  wire  _ex2_reg_div_stall_T_3 = ex2_reg_divrem_state == 3'h0 | ex2_reg_divrem_state == 3'h5; // @[src/main/scala/fpga/Core.scala 1513:75]
  wire  _ex2_reg_div_stall_T_4 = _ex2_reg_divrem_T & (ex2_reg_divrem_state == 3'h0 | ex2_reg_divrem_state == 3'h5); // @[src/main/scala/fpga/Core.scala 1513:29]
  wire  _GEN_561 = 3'h2 == ex2_reg_divrem_state | 3'h3 == ex2_reg_divrem_state; // @[src/main/scala/fpga/Core.scala 1575:33 1666:26]
  wire  _GEN_569 = 3'h1 == ex2_reg_divrem_state | _GEN_561; // @[src/main/scala/fpga/Core.scala 1575:33 1613:29]
  wire  ex2_div_stall_next = 3'h0 == ex2_reg_divrem_state ? 1'h0 : _GEN_569; // @[src/main/scala/fpga/Core.scala 1573:22 1575:33]
  wire  _ex2_reg_div_stall_T_9 = ex2_reg_divrem & _ex2_reg_div_stall_T_3; // @[src/main/scala/fpga/Core.scala 1527:23]
  wire  _T_78 = ~ex2_reg_div_stall; // @[src/main/scala/fpga/Core.scala 1530:23]
  reg [36:0] ex2_reg_dividend; // @[src/main/scala/fpga/Core.scala 1543:37]
  reg [35:0] ex2_reg_divisor; // @[src/main/scala/fpga/Core.scala 1544:37]
  reg [63:0] ex2_reg_p_divisor; // @[src/main/scala/fpga/Core.scala 1545:37]
  reg [4:0] ex2_reg_divrem_count; // @[src/main/scala/fpga/Core.scala 1546:37]
  reg [4:0] ex2_reg_rem_shift; // @[src/main/scala/fpga/Core.scala 1547:37]
  reg  ex2_reg_extra_shift; // @[src/main/scala/fpga/Core.scala 1548:37]
  reg [2:0] ex2_reg_d; // @[src/main/scala/fpga/Core.scala 1549:37]
  reg [31:0] ex2_reg_reminder; // @[src/main/scala/fpga/Core.scala 1550:37]
  reg [31:0] ex2_reg_quotient; // @[src/main/scala/fpga/Core.scala 1551:37]
  wire  _ex2_alu_muldiv_out_T = ex2_reg_exe_fun == 4'h8; // @[src/main/scala/fpga/Core.scala 1561:22]
  wire [31:0] _ex2_alu_muldiv_out_T_3 = {ex2_reg_mulhuu[15:0], 16'h0}; // @[src/main/scala/fpga/Core.scala 1561:106]
  wire [31:0] _ex2_alu_muldiv_out_T_5 = ex2_reg_mullu[31:0] + _ex2_alu_muldiv_out_T_3; // @[src/main/scala/fpga/Core.scala 1561:71]
  wire  _ex2_alu_muldiv_out_T_6 = ex2_reg_exe_fun == 4'h9; // @[src/main/scala/fpga/Core.scala 1562:22]
  wire [15:0] _ex2_alu_muldiv_out_T_9 = ex2_reg_mulls[31] ? 16'hffff : 16'h0; // @[src/main/scala/fpga/Core.scala 1554:12]
  wire [47:0] _ex2_alu_muldiv_out_T_12 = {_ex2_alu_muldiv_out_T_9,ex2_reg_mulls}; // @[src/main/scala/fpga/Core.scala 1554:65]
  wire [47:0] _ex2_alu_muldiv_out_T_15 = $signed(_ex2_alu_muldiv_out_T_12) + $signed(ex2_reg_mulhss); // @[src/main/scala/fpga/Core.scala 1562:80]
  wire  _ex2_alu_muldiv_out_T_17 = ex2_reg_exe_fun == 4'ha; // @[src/main/scala/fpga/Core.scala 1563:22]
  wire [47:0] _ex2_alu_muldiv_out_T_21 = {16'h0,ex2_reg_mullu[47:16]}; // @[src/main/scala/fpga/Core.scala 1557:35]
  wire [47:0] _ex2_alu_muldiv_out_T_23 = _ex2_alu_muldiv_out_T_21 + ex2_reg_mulhuu; // @[src/main/scala/fpga/Core.scala 1563:108]
  wire  _ex2_alu_muldiv_out_T_25 = ex2_reg_exe_fun == 4'hb; // @[src/main/scala/fpga/Core.scala 1564:22]
  wire [47:0] _ex2_alu_muldiv_out_T_34 = $signed(_ex2_alu_muldiv_out_T_12) + $signed(ex2_reg_mulhsu); // @[src/main/scala/fpga/Core.scala 1564:80]
  wire  _ex2_alu_muldiv_out_T_36 = ex2_reg_exe_fun == 4'hc; // @[src/main/scala/fpga/Core.scala 1565:22]
  wire  _ex2_alu_muldiv_out_T_37 = ex2_reg_exe_fun == 4'he; // @[src/main/scala/fpga/Core.scala 1566:22]
  wire  _ex2_alu_muldiv_out_T_38 = ex2_reg_exe_fun == 4'hd; // @[src/main/scala/fpga/Core.scala 1567:22]
  wire  _ex2_alu_muldiv_out_T_39 = ex2_reg_exe_fun == 4'hf; // @[src/main/scala/fpga/Core.scala 1568:22]
  wire [31:0] _ex2_alu_muldiv_out_T_40 = _ex2_alu_muldiv_out_T_39 ? ex2_reg_reminder : 32'h0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_41 = _ex2_alu_muldiv_out_T_38 ? ex2_reg_reminder : _ex2_alu_muldiv_out_T_40; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_42 = _ex2_alu_muldiv_out_T_37 ? ex2_reg_quotient : _ex2_alu_muldiv_out_T_41; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_43 = _ex2_alu_muldiv_out_T_36 ? ex2_reg_quotient : _ex2_alu_muldiv_out_T_42; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_44 = _ex2_alu_muldiv_out_T_25 ? _ex2_alu_muldiv_out_T_34[47:16] :
    _ex2_alu_muldiv_out_T_43; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_45 = _ex2_alu_muldiv_out_T_17 ? _ex2_alu_muldiv_out_T_23[47:16] :
    _ex2_alu_muldiv_out_T_44; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_alu_muldiv_out_T_46 = _ex2_alu_muldiv_out_T_6 ? _ex2_alu_muldiv_out_T_15[47:16] :
    _ex2_alu_muldiv_out_T_45; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] ex2_alu_muldiv_out = _ex2_alu_muldiv_out_T ? _ex2_alu_muldiv_out_T_5 : _ex2_alu_muldiv_out_T_46; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _GEN_538 = ex2_reg_init_divisor[31:2] == 30'h0 ? 2'h2 : 2'h1; // @[src/main/scala/fpga/Core.scala 1578:60 1579:32 1581:32]
  wire [36:0] _ex2_reg_dividend_T = ex2_reg_init_dividend; // @[src/main/scala/fpga/Core.scala 1585:53]
  wire [35:0] _ex2_reg_divisor_T_1 = {ex2_reg_init_divisor[3:0],32'h0}; // @[src/main/scala/fpga/Core.scala 1586:34]
  wire [63:0] _ex2_reg_p_divisor_T = {ex2_reg_init_divisor,32'h0}; // @[src/main/scala/fpga/Core.scala 1587:34]
  wire [2:0] _ex2_reg_d_T_1 = {ex2_reg_init_divisor[0],2'h0}; // @[src/main/scala/fpga/Core.scala 1596:35]
  wire [4:0] _ex2_reg_divrem_count_T_1 = ex2_reg_divrem_count + 5'h1; // @[src/main/scala/fpga/Core.scala 1605:52]
  wire  _p_T_1 = ~ex2_reg_dividend[36]; // @[src/main/scala/fpga/Core.scala 1617:42]
  wire [4:0] _p_T_4 = ~ex2_reg_dividend[35:31]; // @[src/main/scala/fpga/Core.scala 1619:11]
  wire [4:0] _p_T_5 = ~ex2_reg_dividend[36] ? ex2_reg_dividend[35:31] : _p_T_4; // @[src/main/scala/fpga/Core.scala 1617:12]
  wire [4:0] _p_T_10 = ~ex2_reg_dividend[34:30]; // @[src/main/scala/fpga/Core.scala 1623:11]
  wire [4:0] _p_T_11 = _p_T_1 ? ex2_reg_dividend[34:30] : _p_T_10; // @[src/main/scala/fpga/Core.scala 1621:12]
  wire [4:0] p = ex2_reg_extra_shift ? _p_T_5 : _p_T_11; // @[src/main/scala/fpga/Core.scala 1616:18]
  wire [1:0] _ex2_q_T_5 = 5'h2 == p ? 2'h1 : 2'h0; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_7 = 5'h3 == p ? 2'h1 : _ex2_q_T_5; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_9 = 5'h4 == p ? 2'h1 : _ex2_q_T_7; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_11 = 5'h5 == p ? 2'h1 : _ex2_q_T_9; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_13 = 5'h6 == p ? 2'h2 : _ex2_q_T_11; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_15 = 5'h7 == p ? 2'h2 : _ex2_q_T_13; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_17 = 5'h8 == p ? 2'h2 : _ex2_q_T_15; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_19 = 5'h9 == p ? 2'h2 : _ex2_q_T_17; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_21 = 5'ha == p ? 2'h2 : _ex2_q_T_19; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_23 = 5'hb == p ? 2'h2 : _ex2_q_T_21; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_37 = 5'h6 == p ? 2'h1 : _ex2_q_T_11; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_39 = 5'h7 == p ? 2'h2 : _ex2_q_T_37; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_41 = 5'h8 == p ? 2'h2 : _ex2_q_T_39; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_43 = 5'h9 == p ? 2'h2 : _ex2_q_T_41; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_45 = 5'ha == p ? 2'h2 : _ex2_q_T_43; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_47 = 5'hb == p ? 2'h2 : _ex2_q_T_45; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_49 = 5'hc == p ? 2'h2 : _ex2_q_T_47; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_51 = 5'hd == p ? 2'h2 : _ex2_q_T_49; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_67 = 5'h7 == p ? 2'h1 : _ex2_q_T_37; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_69 = 5'h8 == p ? 2'h2 : _ex2_q_T_67; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_71 = 5'h9 == p ? 2'h2 : _ex2_q_T_69; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_73 = 5'ha == p ? 2'h2 : _ex2_q_T_71; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_75 = 5'hb == p ? 2'h2 : _ex2_q_T_73; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_77 = 5'hc == p ? 2'h2 : _ex2_q_T_75; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_79 = 5'hd == p ? 2'h2 : _ex2_q_T_77; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_81 = 5'he == p ? 2'h2 : _ex2_q_T_79; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_83 = 5'hf == p ? 2'h2 : _ex2_q_T_81; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_125 = 5'h4 == p ? 2'h1 : 2'h0; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_127 = 5'h5 == p ? 2'h1 : _ex2_q_T_125; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_129 = 5'h6 == p ? 2'h1 : _ex2_q_T_127; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_131 = 5'h7 == p ? 2'h1 : _ex2_q_T_129; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_133 = 5'h8 == p ? 2'h1 : _ex2_q_T_131; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_135 = 5'h9 == p ? 2'h1 : _ex2_q_T_133; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_137 = 5'ha == p ? 2'h2 : _ex2_q_T_135; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_139 = 5'hb == p ? 2'h2 : _ex2_q_T_137; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_141 = 5'hc == p ? 2'h2 : _ex2_q_T_139; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_143 = 5'hd == p ? 2'h2 : _ex2_q_T_141; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_145 = 5'he == p ? 2'h2 : _ex2_q_T_143; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_147 = 5'hf == p ? 2'h2 : _ex2_q_T_145; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_149 = 5'h10 == p ? 2'h2 : _ex2_q_T_147; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_151 = 5'h11 == p ? 2'h2 : _ex2_q_T_149; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_189 = 5'h12 == p ? 2'h2 : _ex2_q_T_151; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_191 = 5'h13 == p ? 2'h2 : _ex2_q_T_189; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_253 = 5'ha == p ? 2'h1 : _ex2_q_T_135; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_255 = 5'hb == p ? 2'h1 : _ex2_q_T_253; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_257 = 5'hc == p ? 2'h2 : _ex2_q_T_255; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_259 = 5'hd == p ? 2'h2 : _ex2_q_T_257; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_261 = 5'he == p ? 2'h2 : _ex2_q_T_259; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_263 = 5'hf == p ? 2'h2 : _ex2_q_T_261; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_265 = 5'h10 == p ? 2'h2 : _ex2_q_T_263; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_267 = 5'h11 == p ? 2'h2 : _ex2_q_T_265; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_269 = 5'h12 == p ? 2'h2 : _ex2_q_T_267; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_271 = 5'h13 == p ? 2'h2 : _ex2_q_T_269; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_273 = 5'h14 == p ? 2'h2 : _ex2_q_T_271; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_275 = 5'h15 == p ? 2'h2 : _ex2_q_T_273; // @[src/main/scala/fpga/Core.scala 1638:55]
  wire [1:0] _ex2_q_T_277 = 3'h1 == ex2_reg_d ? _ex2_q_T_51 : _ex2_q_T_23; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] _ex2_q_T_279 = 3'h2 == ex2_reg_d ? _ex2_q_T_83 : _ex2_q_T_277; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] _ex2_q_T_281 = 3'h3 == ex2_reg_d ? _ex2_q_T_83 : _ex2_q_T_279; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] _ex2_q_T_283 = 3'h4 == ex2_reg_d ? _ex2_q_T_151 : _ex2_q_T_281; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] _ex2_q_T_285 = 3'h5 == ex2_reg_d ? _ex2_q_T_191 : _ex2_q_T_283; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] _ex2_q_T_287 = 3'h6 == ex2_reg_d ? _ex2_q_T_191 : _ex2_q_T_285; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [1:0] ex2_q = 3'h7 == ex2_reg_d ? _ex2_q_T_275 : _ex2_q_T_287; // @[src/main/scala/fpga/Core.scala 1636:49]
  wire [38:0] _ex2_reg_dividend_T_1 = {$signed(ex2_reg_dividend), 2'h0}; // @[src/main/scala/fpga/Core.scala 1643:54]
  wire [36:0] _ex2_reg_dividend_T_5 = {1'h0,ex2_reg_divisor}; // @[src/main/scala/fpga/Core.scala 1644:85]
  wire [36:0] _ex2_reg_dividend_T_8 = $signed(ex2_reg_dividend) - $signed(_ex2_reg_dividend_T_5); // @[src/main/scala/fpga/Core.scala 1644:52]
  wire [38:0] _ex2_reg_dividend_T_9 = {$signed(_ex2_reg_dividend_T_8), 2'h0}; // @[src/main/scala/fpga/Core.scala 1644:93]
  wire [36:0] _ex2_reg_dividend_T_13 = {ex2_reg_divisor,1'h0}; // @[src/main/scala/fpga/Core.scala 1645:85]
  wire [36:0] _ex2_reg_dividend_T_16 = $signed(ex2_reg_dividend) - $signed(_ex2_reg_dividend_T_13); // @[src/main/scala/fpga/Core.scala 1645:52]
  wire [38:0] _ex2_reg_dividend_T_17 = {$signed(_ex2_reg_dividend_T_16), 2'h0}; // @[src/main/scala/fpga/Core.scala 1645:93]
  wire [38:0] _ex2_reg_dividend_T_18 = ex2_q[1] ? $signed(_ex2_reg_dividend_T_17) : $signed(_ex2_reg_dividend_T_1); // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [38:0] _ex2_reg_dividend_T_19 = ex2_q[0] ? $signed(_ex2_reg_dividend_T_9) : $signed(_ex2_reg_dividend_T_18); // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [33:0] _ex2_reg_quotient_T = {ex2_reg_quotient, 2'h0}; // @[src/main/scala/fpga/Core.scala 1647:54]
  wire [33:0] _ex2_reg_quotient_T_5 = _ex2_reg_quotient_T + 34'h1; // @[src/main/scala/fpga/Core.scala 1648:58]
  wire [33:0] _ex2_reg_quotient_T_10 = _ex2_reg_quotient_T + 34'h2; // @[src/main/scala/fpga/Core.scala 1649:58]
  wire [33:0] _ex2_reg_quotient_T_11 = ex2_q[1] ? _ex2_reg_quotient_T_10 : _ex2_reg_quotient_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [33:0] _ex2_reg_quotient_T_12 = ex2_q[0] ? _ex2_reg_quotient_T_5 : _ex2_reg_quotient_T_11; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [36:0] _ex2_reg_dividend_T_27 = $signed(ex2_reg_dividend) + $signed(_ex2_reg_dividend_T_5); // @[src/main/scala/fpga/Core.scala 1653:52]
  wire [38:0] _ex2_reg_dividend_T_28 = {$signed(_ex2_reg_dividend_T_27), 2'h0}; // @[src/main/scala/fpga/Core.scala 1653:93]
  wire [36:0] _ex2_reg_dividend_T_35 = $signed(ex2_reg_dividend) + $signed(_ex2_reg_dividend_T_13); // @[src/main/scala/fpga/Core.scala 1654:52]
  wire [38:0] _ex2_reg_dividend_T_36 = {$signed(_ex2_reg_dividend_T_35), 2'h0}; // @[src/main/scala/fpga/Core.scala 1654:93]
  wire [38:0] _ex2_reg_dividend_T_37 = ex2_q[1] ? $signed(_ex2_reg_dividend_T_36) : $signed(_ex2_reg_dividend_T_1); // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [38:0] _ex2_reg_dividend_T_38 = ex2_q[0] ? $signed(_ex2_reg_dividend_T_28) : $signed(_ex2_reg_dividend_T_37); // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [33:0] _ex2_reg_quotient_T_18 = _ex2_reg_quotient_T - 34'h1; // @[src/main/scala/fpga/Core.scala 1657:58]
  wire [33:0] _ex2_reg_quotient_T_23 = _ex2_reg_quotient_T - 34'h2; // @[src/main/scala/fpga/Core.scala 1658:58]
  wire [33:0] _ex2_reg_quotient_T_24 = ex2_q[1] ? _ex2_reg_quotient_T_23 : _ex2_reg_quotient_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [33:0] _ex2_reg_quotient_T_25 = ex2_q[0] ? _ex2_reg_quotient_T_18 : _ex2_reg_quotient_T_24; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [38:0] _GEN_545 = _p_T_1 ? $signed(_ex2_reg_dividend_T_19) : $signed(_ex2_reg_dividend_T_38); // @[src/main/scala/fpga/Core.scala 1642:51 1643:26 1652:26]
  wire [33:0] _GEN_546 = _p_T_1 ? _ex2_reg_quotient_T_12 : _ex2_reg_quotient_T_25; // @[src/main/scala/fpga/Core.scala 1642:51 1647:26 1656:26]
  wire [4:0] _ex2_reg_rem_shift_T_1 = ex2_reg_rem_shift + 5'h1; // @[src/main/scala/fpga/Core.scala 1661:46]
  wire [2:0] _GEN_547 = ex2_reg_divrem_count == 5'h10 ? 3'h3 : ex2_reg_divrem_state; // @[src/main/scala/fpga/Core.scala 1663:44 1664:30 310:37]
  wire [5:0] _ex2_reg_reminder_T = {ex2_reg_rem_shift,1'h0}; // @[src/main/scala/fpga/Core.scala 1669:51]
  wire [36:0] _ex2_reg_reminder_T_1 = $signed(ex2_reg_dividend) >>> _ex2_reg_reminder_T; // @[src/main/scala/fpga/Core.scala 1669:45]
  wire [31:0] _reminder_T_4 = ex2_reg_reminder + ex2_reg_init_divisor; // @[src/main/scala/fpga/Core.scala 1675:26]
  wire [31:0] reminder = ex2_reg_dividend[36] ? _reminder_T_4 : ex2_reg_reminder; // @[src/main/scala/fpga/Core.scala 1674:25]
  wire [31:0] _ex2_reg_reminder_T_4 = ~reminder; // @[src/main/scala/fpga/Core.scala 1682:11]
  wire [31:0] _ex2_reg_reminder_T_6 = _ex2_reg_reminder_T_4 + 32'h1; // @[src/main/scala/fpga/Core.scala 1682:21]
  wire [31:0] _ex2_reg_reminder_T_7 = ~ex2_reg_sign_op1 ? reminder : _ex2_reg_reminder_T_6; // @[src/main/scala/fpga/Core.scala 1680:12]
  wire [31:0] _ex2_reg_reminder_T_8 = ex2_reg_zero_op2 ? ex2_reg_orig_dividend : _ex2_reg_reminder_T_7; // @[src/main/scala/fpga/Core.scala 1678:30]
  wire [31:0] _quotient_T_3 = ex2_reg_quotient - 32'h1; // @[src/main/scala/fpga/Core.scala 1686:26]
  wire [31:0] quotient = ex2_reg_dividend[36] ? _quotient_T_3 : ex2_reg_quotient; // @[src/main/scala/fpga/Core.scala 1685:25]
  wire [31:0] _ex2_reg_quotient_T_27 = ~quotient; // @[src/main/scala/fpga/Core.scala 1693:11]
  wire [31:0] _ex2_reg_quotient_T_29 = _ex2_reg_quotient_T_27 + 32'h1; // @[src/main/scala/fpga/Core.scala 1693:21]
  wire [31:0] _ex2_reg_quotient_T_30 = ~ex2_reg_sign_op12 ? quotient : _ex2_reg_quotient_T_29; // @[src/main/scala/fpga/Core.scala 1691:12]
  wire [31:0] _ex2_reg_quotient_T_31 = ex2_reg_zero_op2 ? 32'hffffffff : _ex2_reg_quotient_T_30; // @[src/main/scala/fpga/Core.scala 1689:30]
  wire [2:0] _GEN_548 = 3'h5 == ex2_reg_divrem_state ? 3'h0 : ex2_reg_divrem_state; // @[src/main/scala/fpga/Core.scala 1575:33 1700:28 310:37]
  wire [31:0] _GEN_549 = 3'h4 == ex2_reg_divrem_state ? _ex2_reg_reminder_T_8 : ex2_reg_reminder; // @[src/main/scala/fpga/Core.scala 1575:33 1678:24 1550:37]
  wire [31:0] _GEN_550 = 3'h4 == ex2_reg_divrem_state ? _ex2_reg_quotient_T_31 : ex2_reg_quotient; // @[src/main/scala/fpga/Core.scala 1575:33 1689:24 1551:37]
  wire [2:0] _GEN_551 = 3'h4 == ex2_reg_divrem_state ? 3'h5 : _GEN_548; // @[src/main/scala/fpga/Core.scala 1575:33 1696:28]
  wire [31:0] _GEN_552 = 3'h3 == ex2_reg_divrem_state ? _ex2_reg_reminder_T_1[31:0] : _GEN_549; // @[src/main/scala/fpga/Core.scala 1575:33 1669:24]
  wire [2:0] _GEN_553 = 3'h3 == ex2_reg_divrem_state ? 3'h4 : _GEN_551; // @[src/main/scala/fpga/Core.scala 1575:33 1670:28]
  wire [31:0] _GEN_555 = 3'h3 == ex2_reg_divrem_state ? ex2_reg_quotient : _GEN_550; // @[src/main/scala/fpga/Core.scala 1575:33 1551:37]
  wire [38:0] _GEN_556 = 3'h2 == ex2_reg_divrem_state ? $signed(_GEN_545) : $signed({{2{ex2_reg_dividend[36]}},
    ex2_reg_dividend}); // @[src/main/scala/fpga/Core.scala 1575:33 1543:37]
  wire [33:0] _GEN_557 = 3'h2 == ex2_reg_divrem_state ? _GEN_546 : {{2'd0}, _GEN_555}; // @[src/main/scala/fpga/Core.scala 1575:33]
  wire [38:0] _GEN_570 = 3'h1 == ex2_reg_divrem_state ? $signed({{2{ex2_reg_dividend[36]}},ex2_reg_dividend}) : $signed(
    _GEN_556); // @[src/main/scala/fpga/Core.scala 1575:33 1543:37]
  wire [33:0] _GEN_571 = 3'h1 == ex2_reg_divrem_state ? {{2'd0}, ex2_reg_quotient} : _GEN_557; // @[src/main/scala/fpga/Core.scala 1575:33 1551:37]
  wire [38:0] _GEN_575 = 3'h0 == ex2_reg_divrem_state ? $signed({{2{_ex2_reg_dividend_T[36]}},_ex2_reg_dividend_T}) :
    $signed(_GEN_570); // @[src/main/scala/fpga/Core.scala 1575:33 1585:28]
  wire [33:0] _GEN_580 = 3'h0 == ex2_reg_divrem_state ? 34'h0 : _GEN_571; // @[src/main/scala/fpga/Core.scala 1575:33 1590:28]
  wire  _ex2_wb_data_T_4 = ex2_reg_wb_sel == 3'h7; // @[src/main/scala/fpga/Core.scala 1718:23]
  wire  _ex2_wb_data_T_5 = ex2_reg_wb_sel == 3'h3 | _ex2_wb_data_T_4; // @[src/main/scala/fpga/Core.scala 1717:35]
  wire  _ex2_wb_data_T_6 = ex2_reg_wb_sel == 3'h1; // @[src/main/scala/fpga/Core.scala 1720:21]
  wire [31:0] _ex2_wb_data_T_7 = _ex2_wb_data_T_6 ? ex2_alu_muldiv_out : ex2_reg_alu_out; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _ex2_wb_data_T_8 = _ex2_wb_data_T_5 ? csr_rdata : _ex2_wb_data_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] ex2_wb_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _T_113 = _T_78 & ex2_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 1737:28]
  wire  _mem1_reg_mem_wstrb_T_2 = ex1_reg_mem_w == 3'h5 | ex1_reg_mem_w == 3'h7; // @[src/main/scala/fpga/Core.scala 1753:31]
  wire  _mem1_reg_mem_wstrb_T_5 = ex1_reg_mem_w == 3'h4 | ex1_reg_mem_w == 3'h6; // @[src/main/scala/fpga/Core.scala 1754:31]
  wire [3:0] _mem1_reg_mem_wstrb_T_6 = _mem1_reg_mem_wstrb_T_5 ? 4'h3 : 4'hf; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [3:0] _mem1_reg_mem_wstrb_T_7 = _mem1_reg_mem_wstrb_T_2 ? 4'h1 : _mem1_reg_mem_wstrb_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [6:0] _GEN_65 = {{3'd0}, _mem1_reg_mem_wstrb_T_7}; // @[src/main/scala/fpga/Core.scala 1756:8]
  wire [6:0] _mem1_reg_mem_wstrb_T_9 = _GEN_65 << ex1_add_out[1:0]; // @[src/main/scala/fpga/Core.scala 1756:8]
  wire  _mem1_reg_unaligned_T_1 = ex1_add_out[1:0] != 2'h0; // @[src/main/scala/fpga/Core.scala 1757:57]
  wire  _mem1_reg_unaligned_T_9 = ex1_add_out[1:0] == 2'h3; // @[src/main/scala/fpga/Core.scala 1759:81]
  wire  _mem1_reg_unaligned_T_10 = _mem1_reg_mem_wstrb_T_5 ? _mem1_reg_unaligned_T_9 : _mem1_reg_unaligned_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _mem1_reg_unaligned_T_11 = _mem1_reg_mem_wstrb_T_2 ? 1'h0 : _mem1_reg_unaligned_T_10; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _mem1_reg_unaligned_T_12 = ex1_reg_wb_sel == 3'h5; // @[src/main/scala/fpga/Core.scala 1760:27]
  wire  _mem1_reg_unaligned_T_13 = ex1_reg_wb_sel == 3'h4; // @[src/main/scala/fpga/Core.scala 1760:55]
  wire  _mem1_reg_unaligned_T_14 = ex1_reg_wb_sel == 3'h5 | ex1_reg_wb_sel == 3'h4; // @[src/main/scala/fpga/Core.scala 1760:37]
  wire  _mem1_reg_unaligned_T_16 = _mem1_reg_unaligned_T_11 & (ex1_reg_wb_sel == 3'h5 | ex1_reg_wb_sel == 3'h4) & ex1_en
    ; // @[src/main/scala/fpga/Core.scala 1760:66]
  wire [55:0] _mem1_reg_wdata_T_1 = {ex1_reg_op3_data,ex1_reg_op3_data[31:8]}; // @[src/main/scala/fpga/Core.scala 1761:35]
  wire [5:0] _mem1_reg_wdata_T_3 = 4'h8 * ex1_add_out[1:0]; // @[src/main/scala/fpga/Core.scala 1761:87]
  wire [118:0] _GEN_66 = {{63'd0}, _mem1_reg_wdata_T_1}; // @[src/main/scala/fpga/Core.scala 1761:79]
  wire [118:0] _mem1_reg_wdata_T_4 = _GEN_66 << _mem1_reg_wdata_T_3; // @[src/main/scala/fpga/Core.scala 1761:79]
  wire  mem1_is_dram = ex1_add_out[31:28] == 4'h2; // @[src/main/scala/fpga/Core.scala 1764:70]
  wire  _mem1_reg_is_mem_load_T = ~mem1_is_dram; // @[src/main/scala/fpga/Core.scala 1766:31]
  wire  _mem1_reg_is_dram_fence_T = ex1_reg_wb_sel == 3'h7; // @[src/main/scala/fpga/Core.scala 1770:47]
  wire  _T_116 = ~mem1_mem_stall; // @[src/main/scala/fpga/Core.scala 1780:9]
  wire  _T_117 = ~mem1_dram_stall; // @[src/main/scala/fpga/Core.scala 1780:28]
  wire  _T_118 = ~mem1_mem_stall & ~mem1_dram_stall; // @[src/main/scala/fpga/Core.scala 1780:25]
  wire [31:0] _mem_addr_T_1 = ex2_reg_alu_out + 32'h4; // @[src/main/scala/fpga/Core.scala 1784:59]
  wire [3:0] _mem_wstrb_T_1 = {1'h0,mem1_reg_mem_wstrb[6:4]}; // @[src/main/scala/fpga/Core.scala 1785:46]
  wire  _T_120 = ~mem2_dram_stall; // @[src/main/scala/fpga/Core.scala 1815:9]
  wire  _mem2_reg_is_valid_load_T_1 = _T_116 & mem1_reg_is_mem_load; // @[src/main/scala/fpga/Core.scala 1820:49]
  wire  _mem2_reg_is_valid_load_T_3 = _T_117 & mem1_reg_is_dram_load; // @[src/main/scala/fpga/Core.scala 1820:95]
  wire  _mem2_is_valid_load_T_2 = _T_120 & ~mem2_reg_unaligned; // @[src/main/scala/fpga/Core.scala 1842:40]
  wire  mem2_is_valid_load = _T_120 & ~mem2_reg_unaligned & mem2_reg_is_valid_load; // @[src/main/scala/fpga/Core.scala 1842:63]
  wire  _mem2_is_aligned_lw_T_4 = mem2_reg_mem_w != 3'h5; // @[src/main/scala/fpga/Core.scala 1844:20]
  wire  _mem2_is_aligned_lw_T_5 = _T_120 & mem2_reg_is_valid_load & mem2_reg_wb_byte_offset == 2'h0 &
    _mem2_is_aligned_lw_T_4; // @[src/main/scala/fpga/Core.scala 1843:105]
  wire  _mem2_is_aligned_lw_T_8 = mem2_reg_mem_w != 3'h4; // @[src/main/scala/fpga/Core.scala 1845:20]
  wire  _mem2_is_aligned_lw_T_9 = _mem2_is_aligned_lw_T_5 & mem2_reg_mem_w != 3'h7 & _mem2_is_aligned_lw_T_8; // @[src/main/scala/fpga/Core.scala 1844:57]
  wire  _mem2_is_aligned_lw_T_10 = mem2_reg_mem_w != 3'h6; // @[src/main/scala/fpga/Core.scala 1845:47]
  wire  mem2_is_aligned_lw = _mem2_is_aligned_lw_T_9 & mem2_reg_mem_w != 3'h6; // @[src/main/scala/fpga/Core.scala 1845:29]
  wire [55:0] _mem3_wb_rdata_T = {mem3_reg_rdata_high,mem3_reg_dmem_rdata}; // @[src/main/scala/fpga/Core.scala 1881:27]
  wire [5:0] _mem3_wb_rdata_T_1 = 4'h8 * mem3_reg_wb_byte_offset; // @[src/main/scala/fpga/Core.scala 1881:78]
  wire [55:0] _mem3_wb_rdata_T_2 = _mem3_wb_rdata_T >> _mem3_wb_rdata_T_1; // @[src/main/scala/fpga/Core.scala 1881:70]
  wire [31:0] mem3_wb_rdata = _mem3_wb_rdata_T_2[31:0]; // @[src/main/scala/fpga/Core.scala 1881:105]
  wire  _mem3_wb_data_load_T = mem3_reg_mem_w == 3'h5; // @[src/main/scala/fpga/Core.scala 1883:21]
  wire [23:0] _mem3_wb_data_load_T_3 = mem3_wb_rdata[7] ? 24'hffffff : 24'h0; // @[src/main/scala/fpga/Core.scala 1872:11]
  wire [31:0] _mem3_wb_data_load_T_5 = {_mem3_wb_data_load_T_3,mem3_wb_rdata[7:0]}; // @[src/main/scala/fpga/Core.scala 1872:40]
  wire  _mem3_wb_data_load_T_6 = mem3_reg_mem_w == 3'h4; // @[src/main/scala/fpga/Core.scala 1884:21]
  wire [15:0] _mem3_wb_data_load_T_9 = mem3_wb_rdata[15] ? 16'hffff : 16'h0; // @[src/main/scala/fpga/Core.scala 1872:11]
  wire [31:0] _mem3_wb_data_load_T_11 = {_mem3_wb_data_load_T_9,mem3_wb_rdata[15:0]}; // @[src/main/scala/fpga/Core.scala 1872:40]
  wire  _mem3_wb_data_load_T_12 = mem3_reg_mem_w == 3'h7; // @[src/main/scala/fpga/Core.scala 1885:21]
  wire [31:0] _mem3_wb_data_load_T_15 = {24'h0,mem3_wb_rdata[7:0]}; // @[src/main/scala/fpga/Core.scala 1875:31]
  wire  _mem3_wb_data_load_T_16 = mem3_reg_mem_w == 3'h6; // @[src/main/scala/fpga/Core.scala 1886:21]
  wire [31:0] _mem3_wb_data_load_T_19 = {16'h0,mem3_wb_rdata[15:0]}; // @[src/main/scala/fpga/Core.scala 1875:31]
  wire [31:0] _mem3_wb_data_load_T_20 = _mem3_wb_data_load_T_16 ? _mem3_wb_data_load_T_19 : mem3_wb_rdata; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _mem3_wb_data_load_T_21 = _mem3_wb_data_load_T_12 ? _mem3_wb_data_load_T_15 : _mem3_wb_data_load_T_20; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _mem3_wb_data_load_T_22 = _mem3_wb_data_load_T_6 ? _mem3_wb_data_load_T_11 : _mem3_wb_data_load_T_21; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] mem3_wb_data_load = _mem3_wb_data_load_T ? _mem3_wb_data_load_T_5 : _mem3_wb_data_load_T_22; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _T_124 = mem3_reg_is_valid_inst & ~mem3_reg_is_aligned_lw; // @[src/main/scala/fpga/Core.scala 1892:32]
  wire  _T_125 = ~mem3_reg_unaligned; // @[src/main/scala/fpga/Core.scala 1892:62]
  wire [63:0] _instret_T_1 = instret + 64'h2; // @[src/main/scala/fpga/Core.scala 1898:24]
  wire [63:0] _instret_T_3 = instret + 64'h1; // @[src/main/scala/fpga/Core.scala 1900:24]
  wire [31:0] _io_debug_signal_ex2_reg_pc_T = {ex2_reg_pc,1'h0}; // @[src/main/scala/fpga/Core.scala 1913:45]
  wire [38:0] _GEN_643 = reset ? $signed(39'sh0) : $signed(_GEN_575); // @[src/main/scala/fpga/Core.scala 1543:{37,37}]
  wire [33:0] _GEN_645 = reset ? 34'h0 : _GEN_580; // @[src/main/scala/fpga/Core.scala 1551:{37,37}]
  LongCounter cycle_counter ( // @[src/main/scala/fpga/Core.scala 135:29]
    .clock(cycle_counter_clock),
    .reset(cycle_counter_reset),
    .io_value(cycle_counter_io_value)
  );
  MachineTimer mtimer ( // @[src/main/scala/fpga/Core.scala 136:22]
    .clock(mtimer_clock),
    .reset(mtimer_reset),
    .io_mem_raddr(mtimer_io_mem_raddr),
    .io_mem_rdata(mtimer_io_mem_rdata),
    .io_mem_waddr(mtimer_io_mem_waddr),
    .io_mem_wen(mtimer_io_mem_wen),
    .io_mem_wdata(mtimer_io_mem_wdata),
    .io_intr(mtimer_io_intr),
    .io_mtime(mtimer_io_mtime)
  );
  BTB ic_btb ( // @[src/main/scala/fpga/Core.scala 354:22]
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
  PHT ic_pht ( // @[src/main/scala/fpga/Core.scala 355:22]
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
  assign regfile_rrd_op1_data_MPORT_data = regfile[regfile_rrd_op1_data_MPORT_addr]; // @[src/main/scala/fpga/Core.scala 133:20]
  assign regfile_rrd_op2_data_MPORT_en = 1'h1;
  assign regfile_rrd_op2_data_MPORT_addr = rrd_reg_rs2_addr;
  assign regfile_rrd_op2_data_MPORT_data = regfile[regfile_rrd_op2_data_MPORT_addr]; // @[src/main/scala/fpga/Core.scala 133:20]
  assign regfile_rrd_op3_data_MPORT_en = 1'h1;
  assign regfile_rrd_op3_data_MPORT_addr = rrd_reg_rs3_addr;
  assign regfile_rrd_op3_data_MPORT_data = regfile[regfile_rrd_op3_data_MPORT_addr]; // @[src/main/scala/fpga/Core.scala 133:20]
  assign regfile_MPORT_3_data = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8;
  assign regfile_MPORT_3_addr = ex2_reg_wb_addr;
  assign regfile_MPORT_3_mask = 1'h1;
  assign regfile_MPORT_3_en = _T_113 & ex2_reg_no_mem;
  assign regfile_MPORT_5_data = _mem3_wb_data_load_T ? _mem3_wb_data_load_T_5 : _mem3_wb_data_load_T_22;
  assign regfile_MPORT_5_addr = mem3_reg_wb_addr[4:0];
  assign regfile_MPORT_5_mask = 1'h1;
  assign regfile_MPORT_5_en = mem3_reg_is_valid_load;
  assign scoreboard_rrd_stall_MPORT_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_addr = rrd_reg_rs1_addr;
  assign scoreboard_rrd_stall_MPORT_data = scoreboard[scoreboard_rrd_stall_MPORT_addr]; // @[src/main/scala/fpga/Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_1_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_1_addr = rrd_reg_rs2_addr;
  assign scoreboard_rrd_stall_MPORT_1_data = scoreboard[scoreboard_rrd_stall_MPORT_1_addr]; // @[src/main/scala/fpga/Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_2_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_2_addr = rrd_reg_rs3_addr;
  assign scoreboard_rrd_stall_MPORT_2_data = scoreboard[scoreboard_rrd_stall_MPORT_2_addr]; // @[src/main/scala/fpga/Core.scala 149:25]
  assign scoreboard_rrd_stall_MPORT_3_en = 1'h1;
  assign scoreboard_rrd_stall_MPORT_3_addr = rrd_reg_wb_addr;
  assign scoreboard_rrd_stall_MPORT_3_data = scoreboard[scoreboard_rrd_stall_MPORT_3_addr]; // @[src/main/scala/fpga/Core.scala 149:25]
  assign scoreboard_MPORT_data = rrd_reg_wb_sel != 3'h0;
  assign scoreboard_MPORT_addr = rrd_reg_wb_addr;
  assign scoreboard_MPORT_mask = 1'h1;
  assign scoreboard_MPORT_en = _T_51 & _rrd_hazard_T_1;
  assign scoreboard_MPORT_1_data = 1'h0;
  assign scoreboard_MPORT_1_addr = ex1_reg_wb_addr;
  assign scoreboard_MPORT_1_mask = 1'h1;
  assign scoreboard_MPORT_1_en = ex1_reg_inst2_use_reg | _T_68;
  assign scoreboard_MPORT_2_data = 1'h0;
  assign scoreboard_MPORT_2_addr = ex2_reg_wb_addr;
  assign scoreboard_MPORT_2_mask = 1'h1;
  assign scoreboard_MPORT_2_en = ex2_reg_inst3_use_reg & _T_78;
  assign scoreboard_MPORT_4_data = 1'h0;
  assign scoreboard_MPORT_4_addr = mem2_reg_wb_addr[4:0];
  assign scoreboard_MPORT_4_mask = 1'h1;
  assign scoreboard_MPORT_4_en = _mem2_is_aligned_lw_T_9 & _mem2_is_aligned_lw_T_10;
  assign scoreboard_MPORT_6_data = 1'h0;
  assign scoreboard_MPORT_6_addr = mem3_reg_wb_addr[4:0];
  assign scoreboard_MPORT_6_mask = 1'h1;
  assign scoreboard_MPORT_6_en = _T_124 & _T_125;
  assign io_imem_addr = if1_is_jump ? _io_imem_addr_T_1 : _GEN_175; // @[src/main/scala/fpga/Core.scala 389:21 391:22]
  assign io_dmem_raddr = mem1_reg_unaligned ? _mem_addr_T_1 : ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 1784:22]
  assign io_dmem_ren = mem1_reg_is_mem_load; // @[src/main/scala/fpga/Core.scala 1788:17]
  assign io_dmem_waddr = mem1_reg_unaligned ? _mem_addr_T_1 : ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 1784:22]
  assign io_dmem_wen = mem1_reg_is_mem_store; // @[src/main/scala/fpga/Core.scala 1789:17]
  assign io_dmem_wstrb = mem1_reg_unaligned ? _mem_wstrb_T_1 : mem1_reg_mem_wstrb[3:0]; // @[src/main/scala/fpga/Core.scala 1785:22]
  assign io_dmem_wdata = mem1_reg_wdata; // @[src/main/scala/fpga/Core.scala 1791:17]
  assign io_cache_iinvalidate = mem1_reg_is_dram_fence; // @[src/main/scala/fpga/Core.scala 1798:24]
  assign io_cache_raddr = mem1_reg_unaligned ? _mem_addr_T_1 : ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 1784:22]
  assign io_cache_ren = mem1_reg_is_dram_load; // @[src/main/scala/fpga/Core.scala 1794:18]
  assign io_cache_waddr = mem1_reg_unaligned ? _mem_addr_T_1 : ex2_reg_alu_out; // @[src/main/scala/fpga/Core.scala 1784:22]
  assign io_cache_wen = mem1_reg_is_dram_store; // @[src/main/scala/fpga/Core.scala 1795:18]
  assign io_cache_wstrb = mem1_reg_unaligned ? _mem_wstrb_T_1 : mem1_reg_mem_wstrb[3:0]; // @[src/main/scala/fpga/Core.scala 1785:22]
  assign io_cache_wdata = mem1_reg_wdata; // @[src/main/scala/fpga/Core.scala 1797:18]
  assign io_pht_mem_wen = ic_pht_io_mem_wen; // @[src/main/scala/fpga/Core.scala 387:17]
  assign io_pht_mem_raddr = ic_pht_io_mem_raddr; // @[src/main/scala/fpga/Core.scala 387:17]
  assign io_pht_mem_waddr = ic_pht_io_mem_waddr; // @[src/main/scala/fpga/Core.scala 387:17]
  assign io_pht_mem_wdata = ic_pht_io_mem_wdata; // @[src/main/scala/fpga/Core.scala 387:17]
  assign io_mtimer_mem_rdata = mtimer_io_mem_rdata; // @[src/main/scala/fpga/Core.scala 151:17]
  assign io_debug_signal_ex2_reg_pc = {ex2_reg_pc,1'h0}; // @[src/main/scala/fpga/Core.scala 1913:45]
  assign io_debug_signal_ex2_is_valid_inst = ex2_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1914:39]
  assign io_debug_signal_me_intr = csr_reg_is_meintr & csr_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1396:41]
  assign io_debug_signal_mt_intr = csr_reg_is_mtintr & csr_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1397:41]
  assign io_debug_signal_trap = ex1_en & ex1_reg_is_trap; // @[src/main/scala/fpga/Core.scala 1399:28]
  assign io_debug_signal_cycle_counter = cycle_counter_io_value[47:0]; // @[src/main/scala/fpga/Core.scala 1910:64]
  assign io_debug_signal_id_pc = {id_reg_pc,1'h0}; // @[src/main/scala/fpga/Core.scala 1918:45]
  assign io_debug_signal_id_inst = _if1_is_jump_T ? 32'h13 : id_reg_inst; // @[src/main/scala/fpga/Core.scala 630:20]
  assign io_debug_signal_mem3_rdata = mem3_reg_dmem_rdata; // @[src/main/scala/fpga/Core.scala 1920:39]
  assign io_debug_signal_mem3_rvalid = mem3_reg_is_valid_load; // @[src/main/scala/fpga/Core.scala 1921:39]
  assign io_debug_signal_rwaddr = _ex2_fw_data_T_2 ? ex2_reg_pc_bit_out : _ex2_wb_data_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_debug_signal_ex2_reg_is_br = ex2_reg_is_br; // @[src/main/scala/fpga/Core.scala 1923:39]
  assign io_debug_signal_id_reg_is_bp_fail = id_reg_is_bp_fail; // @[src/main/scala/fpga/Core.scala 1924:39]
  assign io_debug_signal_id_reg_bp_taken = id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 1925:39]
  assign io_debug_signal_ic_state = ic_state; // @[src/main/scala/fpga/Core.scala 1926:51]
  assign cycle_counter_clock = clock;
  assign cycle_counter_reset = reset;
  assign mtimer_clock = clock;
  assign mtimer_reset = reset;
  assign mtimer_io_mem_raddr = io_mtimer_mem_raddr; // @[src/main/scala/fpga/Core.scala 151:17]
  assign mtimer_io_mem_waddr = io_mtimer_mem_waddr; // @[src/main/scala/fpga/Core.scala 151:17]
  assign mtimer_io_mem_wen = io_mtimer_mem_wen; // @[src/main/scala/fpga/Core.scala 151:17]
  assign mtimer_io_mem_wdata = io_mtimer_mem_wdata; // @[src/main/scala/fpga/Core.scala 151:17]
  assign ic_btb_clock = clock;
  assign ic_btb_reset = reset;
  assign ic_btb_io_lu_pc = if1_is_jump ? ic_next_imem_addr : _GEN_176; // @[src/main/scala/fpga/Core.scala 389:21 396:22]
  assign ic_btb_io_up_en = ex1_en & _ex1_br_pc_T_1; // @[src/main/scala/fpga/Core.scala 1352:35]
  assign ic_btb_io_up_pc = ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1353:25]
  assign ic_btb_io_up_taken_pc = ex1_reg_is_j ? ex1_add_out[31:1] : ex1_reg_direct_jbr_pc; // @[src/main/scala/fpga/Core.scala 1342:25]
  assign ic_pht_io_lu_pc = if1_is_jump ? ic_next_imem_addr : _GEN_176; // @[src/main/scala/fpga/Core.scala 389:21 396:22]
  assign ic_pht_io_up_en = ex1_en & (ex1_reg_is_br | ex1_reg_is_j); // @[src/main/scala/fpga/Core.scala 1355:35]
  assign ic_pht_io_up_pc = ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1356:25]
  assign ic_pht_io_up_cnt = _ex1_br_pc_T_1 ? _ic_pht_io_up_cnt_T_7 : _ic_pht_io_up_cnt_T_13; // @[src/main/scala/fpga/Core.scala 1357:31]
  assign ic_pht_io_mem_rdata = io_pht_mem_rdata; // @[src/main/scala/fpga/Core.scala 387:17]
  always @(posedge clock) begin
    if (regfile_MPORT_3_en & regfile_MPORT_3_mask) begin
      regfile[regfile_MPORT_3_addr] <= regfile_MPORT_3_data; // @[src/main/scala/fpga/Core.scala 133:20]
    end
    if (regfile_MPORT_5_en & regfile_MPORT_5_mask) begin
      regfile[regfile_MPORT_5_addr] <= regfile_MPORT_5_data; // @[src/main/scala/fpga/Core.scala 133:20]
    end
    if (scoreboard_MPORT_en & scoreboard_MPORT_mask) begin
      scoreboard[scoreboard_MPORT_addr] <= scoreboard_MPORT_data; // @[src/main/scala/fpga/Core.scala 149:25]
    end
    if (scoreboard_MPORT_1_en & scoreboard_MPORT_1_mask) begin
      scoreboard[scoreboard_MPORT_1_addr] <= scoreboard_MPORT_1_data; // @[src/main/scala/fpga/Core.scala 149:25]
    end
    if (scoreboard_MPORT_2_en & scoreboard_MPORT_2_mask) begin
      scoreboard[scoreboard_MPORT_2_addr] <= scoreboard_MPORT_2_data; // @[src/main/scala/fpga/Core.scala 149:25]
    end
    if (scoreboard_MPORT_4_en & scoreboard_MPORT_4_mask) begin
      scoreboard[scoreboard_MPORT_4_addr] <= scoreboard_MPORT_4_data; // @[src/main/scala/fpga/Core.scala 149:25]
    end
    if (scoreboard_MPORT_6_en & scoreboard_MPORT_6_mask) begin
      scoreboard[scoreboard_MPORT_6_addr] <= scoreboard_MPORT_6_data; // @[src/main/scala/fpga/Core.scala 149:25]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 138:24]
      instret <= 64'h0; // @[src/main/scala/fpga/Core.scala 138:24]
    end else if (ex2_reg_is_retired & mem3_reg_is_retired) begin // @[src/main/scala/fpga/Core.scala 1897:52]
      instret <= _instret_T_1; // @[src/main/scala/fpga/Core.scala 1898:13]
    end else if (ex2_reg_is_retired | mem3_reg_is_retired) begin // @[src/main/scala/fpga/Core.scala 1899:58]
      instret <= _instret_T_3; // @[src/main/scala/fpga/Core.scala 1900:13]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 139:37]
      csr_reg_trap_vector <= 31'h0; // @[src/main/scala/fpga/Core.scala 139:37]
    end else if (ex1_en & ex1_reg_wb_sel == 3'h3) begin // @[src/main/scala/fpga/Core.scala 1426:46]
      if (ex1_reg_csr_addr == 12'h305) begin // @[src/main/scala/fpga/Core.scala 1427:48]
        csr_reg_trap_vector <= csr_wdata[31:1]; // @[src/main/scala/fpga/Core.scala 1428:27]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 140:37]
      csr_reg_mcause <= 32'h0; // @[src/main/scala/fpga/Core.scala 140:37]
    end else if (csr_is_meintr) begin // @[src/main/scala/fpga/Core.scala 1449:24]
      csr_reg_mcause <= 32'h8000000b; // @[src/main/scala/fpga/Core.scala 1450:26]
    end else if (csr_is_mtintr) begin // @[src/main/scala/fpga/Core.scala 1459:30]
      csr_reg_mcause <= 32'h80000007; // @[src/main/scala/fpga/Core.scala 1460:26]
    end else if (csr_is_trap) begin // @[src/main/scala/fpga/Core.scala 1469:28]
      csr_reg_mcause <= ex1_reg_mcause; // @[src/main/scala/fpga/Core.scala 1470:26]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 142:37]
      csr_reg_mepc <= 31'h0; // @[src/main/scala/fpga/Core.scala 142:37]
    end else if (csr_is_meintr) begin // @[src/main/scala/fpga/Core.scala 1449:24]
      csr_reg_mepc <= ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1452:26]
    end else if (csr_is_mtintr) begin // @[src/main/scala/fpga/Core.scala 1459:30]
      csr_reg_mepc <= ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1462:26]
    end else if (csr_is_trap) begin // @[src/main/scala/fpga/Core.scala 1469:28]
      csr_reg_mepc <= ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1472:26]
    end else begin
      csr_reg_mepc <= _GEN_469;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 143:37]
      csr_reg_mstatus_mie <= 1'h0; // @[src/main/scala/fpga/Core.scala 143:37]
    end else if (csr_is_meintr) begin // @[src/main/scala/fpga/Core.scala 1449:24]
      csr_reg_mstatus_mie <= 1'h0; // @[src/main/scala/fpga/Core.scala 1454:26]
    end else if (csr_is_mtintr) begin // @[src/main/scala/fpga/Core.scala 1459:30]
      csr_reg_mstatus_mie <= 1'h0; // @[src/main/scala/fpga/Core.scala 1464:26]
    end else if (csr_is_trap) begin // @[src/main/scala/fpga/Core.scala 1469:28]
      csr_reg_mstatus_mie <= 1'h0; // @[src/main/scala/fpga/Core.scala 1474:26]
    end else begin
      csr_reg_mstatus_mie <= _GEN_481;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 144:37]
      csr_reg_mstatus_mpie <= 1'h0; // @[src/main/scala/fpga/Core.scala 144:37]
    end else if (csr_is_meintr) begin // @[src/main/scala/fpga/Core.scala 1449:24]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1453:26]
    end else if (csr_is_mtintr) begin // @[src/main/scala/fpga/Core.scala 1459:30]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1463:26]
    end else if (csr_is_trap) begin // @[src/main/scala/fpga/Core.scala 1469:28]
      csr_reg_mstatus_mpie <= csr_reg_mstatus_mie; // @[src/main/scala/fpga/Core.scala 1473:26]
    end else begin
      csr_reg_mstatus_mpie <= _GEN_480;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 145:37]
      csr_reg_mscratch <= 32'h0; // @[src/main/scala/fpga/Core.scala 145:37]
    end else if (ex1_en & ex1_reg_wb_sel == 3'h3) begin // @[src/main/scala/fpga/Core.scala 1426:46]
      if (!(ex1_reg_csr_addr == 12'h305)) begin // @[src/main/scala/fpga/Core.scala 1427:48]
        if (!(ex1_reg_csr_addr == 12'h341)) begin // @[src/main/scala/fpga/Core.scala 1429:53]
          csr_reg_mscratch <= _GEN_439;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 146:37]
      csr_reg_mie_meie <= 1'h0; // @[src/main/scala/fpga/Core.scala 146:37]
    end else if (ex1_en & ex1_reg_wb_sel == 3'h3) begin // @[src/main/scala/fpga/Core.scala 1426:46]
      if (!(ex1_reg_csr_addr == 12'h305)) begin // @[src/main/scala/fpga/Core.scala 1427:48]
        if (!(ex1_reg_csr_addr == 12'h341)) begin // @[src/main/scala/fpga/Core.scala 1429:53]
          csr_reg_mie_meie <= _GEN_440;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 147:37]
      csr_reg_mie_mtie <= 1'h0; // @[src/main/scala/fpga/Core.scala 147:37]
    end else if (ex1_en & ex1_reg_wb_sel == 3'h3) begin // @[src/main/scala/fpga/Core.scala 1426:46]
      if (!(ex1_reg_csr_addr == 12'h305)) begin // @[src/main/scala/fpga/Core.scala 1427:48]
        if (!(ex1_reg_csr_addr == 12'h341)) begin // @[src/main/scala/fpga/Core.scala 1429:53]
          csr_reg_mie_mtie <= _GEN_441;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 158:38]
      id_reg_inst <= 32'h0; // @[src/main/scala/fpga/Core.scala 158:38]
    end else if (ex2_reg_is_br | _ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 609:41]
      if (if2_is_valid_inst) begin // @[src/main/scala/fpga/Core.scala 588:21]
        if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
          id_reg_inst <= 32'h13; // @[src/main/scala/fpga/Core.scala 379:15]
        end else begin
          id_reg_inst <= _GEN_179;
        end
      end else begin
        id_reg_inst <= 32'h13;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 159:38]
      id_reg_bp_taken <= 1'h0; // @[src/main/scala/fpga/Core.scala 159:38]
    end else if (ex2_reg_is_br | _ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 609:41]
      id_reg_bp_taken <= if2_bp_taken; // @[src/main/scala/fpga/Core.scala 614:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 160:38]
      id_reg_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 160:38]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 616:24]
      id_reg_pc <= ic_reg_addr_out; // @[src/main/scala/fpga/Core.scala 617:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 161:38]
      id_reg_bp_taken_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 161:38]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 616:24]
      if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
        id_reg_bp_taken_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 385:19]
      end else if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        id_reg_bp_taken_pc <= _GEN_34;
      end else begin
        id_reg_bp_taken_pc <= _GEN_34;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 162:38]
      id_reg_bp_cnt <= 2'h0; // @[src/main/scala/fpga/Core.scala 162:38]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 616:24]
      if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
        id_reg_bp_cnt <= 2'h0; // @[src/main/scala/fpga/Core.scala 386:19]
      end else if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        id_reg_bp_cnt <= _GEN_35;
      end else begin
        id_reg_bp_cnt <= _GEN_35;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 164:38]
      id_reg_stall <= 1'h0; // @[src/main/scala/fpga/Core.scala 164:38]
    end else begin
      id_reg_stall <= id_stall; // @[src/main/scala/fpga/Core.scala 627:16]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 171:38]
      rrd_reg_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 171:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_pc <= _GEN_288;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_pc <= _GEN_288;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 172:38]
      rrd_reg_wb_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 172:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_wb_addr <= _GEN_297;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_wb_addr <= _GEN_297;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 173:38]
      rrd_reg_op1_sel <= 1'h0; // @[src/main/scala/fpga/Core.scala 173:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_op1_sel <= _GEN_289;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_op1_sel <= _GEN_289;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 174:38]
      rrd_reg_op2_sel <= 1'h0; // @[src/main/scala/fpga/Core.scala 174:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_op2_sel <= _GEN_290;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_op2_sel <= _GEN_290;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 175:38]
      rrd_reg_op3_sel <= 2'h0; // @[src/main/scala/fpga/Core.scala 175:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_op3_sel <= _GEN_291;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_op3_sel <= _GEN_291;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 176:38]
      rrd_reg_rs1_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 176:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_rs1_addr <= _GEN_292;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_rs1_addr <= _GEN_292;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 177:38]
      rrd_reg_rs2_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 177:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_rs2_addr <= _GEN_293;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_rs2_addr <= _GEN_293;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 178:38]
      rrd_reg_rs3_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 178:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_rs3_addr <= _GEN_294;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_rs3_addr <= _GEN_294;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 179:38]
      rrd_reg_op1_data <= 32'h0; // @[src/main/scala/fpga/Core.scala 179:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_op1_data <= _GEN_295;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_op1_data <= _GEN_295;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 180:38]
      rrd_reg_op2_data <= 32'h0; // @[src/main/scala/fpga/Core.scala 180:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_op2_data <= _GEN_296;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_op2_data <= _GEN_296;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 181:38]
      rrd_reg_exe_fun <= 4'h0; // @[src/main/scala/fpga/Core.scala 181:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_exe_fun <= 4'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_exe_fun <= id_reg_exe_fun_delay; // @[src/main/scala/fpga/Core.scala 1091:29]
      end else begin
        rrd_reg_exe_fun <= csignals_0; // @[src/main/scala/fpga/Core.scala 1123:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 182:38]
      rrd_reg_rf_wen <= 1'h0; // @[src/main/scala/fpga/Core.scala 182:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_rf_wen <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_rf_wen <= id_reg_rf_wen_delay; // @[src/main/scala/fpga/Core.scala 1090:29]
      end else begin
        rrd_reg_rf_wen <= csignals_4; // @[src/main/scala/fpga/Core.scala 1122:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 183:38]
      rrd_reg_wb_sel <= 3'h0; // @[src/main/scala/fpga/Core.scala 183:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_wb_sel <= 3'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_wb_sel <= id_reg_wb_sel_delay; // @[src/main/scala/fpga/Core.scala 1092:29]
      end else begin
        rrd_reg_wb_sel <= csignals_5; // @[src/main/scala/fpga/Core.scala 1124:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 184:38]
      rrd_reg_csr_addr <= 12'h0; // @[src/main/scala/fpga/Core.scala 184:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_csr_addr <= _GEN_302;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_csr_addr <= _GEN_302;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 185:38]
      rrd_reg_csr_cmd <= 2'h0; // @[src/main/scala/fpga/Core.scala 185:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_csr_cmd <= 2'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_csr_cmd <= id_reg_csr_cmd_delay; // @[src/main/scala/fpga/Core.scala 1095:29]
      end else begin
        rrd_reg_csr_cmd <= csignals_7; // @[src/main/scala/fpga/Core.scala 1127:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 186:38]
      rrd_reg_imm_b_sext <= 32'h0; // @[src/main/scala/fpga/Core.scala 186:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_imm_b_sext <= _GEN_301;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_imm_b_sext <= _GEN_301;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 187:38]
      rrd_reg_mem_w <= 3'h0; // @[src/main/scala/fpga/Core.scala 187:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_mem_w <= 3'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_mem_w <= id_reg_mem_w_delay; // @[src/main/scala/fpga/Core.scala 1096:29]
      end else begin
        rrd_reg_mem_w <= csignals_8; // @[src/main/scala/fpga/Core.scala 1128:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 189:38]
      rrd_reg_is_br <= 1'h0; // @[src/main/scala/fpga/Core.scala 189:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_is_br <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_is_br <= id_reg_is_br_delay; // @[src/main/scala/fpga/Core.scala 1098:29]
      end else begin
        rrd_reg_is_br <= id_is_br; // @[src/main/scala/fpga/Core.scala 1130:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 190:38]
      rrd_reg_is_j <= 1'h0; // @[src/main/scala/fpga/Core.scala 190:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_is_j <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_is_j <= id_reg_is_j_delay; // @[src/main/scala/fpga/Core.scala 1099:29]
      end else begin
        rrd_reg_is_j <= id_is_j; // @[src/main/scala/fpga/Core.scala 1131:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 191:38]
      rrd_reg_bp_taken <= 1'h0; // @[src/main/scala/fpga/Core.scala 191:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_bp_taken <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_bp_taken <= id_reg_bp_taken_delay; // @[src/main/scala/fpga/Core.scala 1100:29]
      end else begin
        rrd_reg_bp_taken <= id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 1132:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 192:38]
      rrd_reg_bp_taken_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 192:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_bp_taken_pc <= _GEN_304;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_bp_taken_pc <= _GEN_304;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 193:38]
      rrd_reg_bp_cnt <= 2'h0; // @[src/main/scala/fpga/Core.scala 193:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_bp_cnt <= _GEN_305;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_bp_cnt <= _GEN_305;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 194:38]
      rrd_reg_is_half <= 1'h0; // @[src/main/scala/fpga/Core.scala 194:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_is_half <= _GEN_306;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_is_half <= _GEN_306;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 195:38]
      rrd_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 195:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_is_valid_inst <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_is_valid_inst <= id_reg_is_valid_inst_delay; // @[src/main/scala/fpga/Core.scala 1104:29]
      end else begin
        rrd_reg_is_valid_inst <= _id_reg_is_valid_inst_delay_T; // @[src/main/scala/fpga/Core.scala 1136:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 196:38]
      rrd_reg_is_trap <= 1'h0; // @[src/main/scala/fpga/Core.scala 196:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_is_trap <= 1'h0;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      if (id_reg_stall) begin // @[src/main/scala/fpga/Core.scala 1079:24]
        rrd_reg_is_trap <= id_reg_is_trap_delay; // @[src/main/scala/fpga/Core.scala 1105:29]
      end else begin
        rrd_reg_is_trap <= _id_csr_addr_T_2; // @[src/main/scala/fpga/Core.scala 1137:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 197:38]
      rrd_reg_mcause <= 32'h0; // @[src/main/scala/fpga/Core.scala 197:38]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 1012:24]
      rrd_reg_mcause <= _GEN_307;
    end else if (~rrd_stall & ~ex2_stall) begin // @[src/main/scala/fpga/Core.scala 1078:40]
      rrd_reg_mcause <= _GEN_307;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 201:38]
      ex1_reg_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 201:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_pc <= rrd_reg_pc; // @[src/main/scala/fpga/Core.scala 1223:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 202:38]
      ex1_reg_wb_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 202:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_wb_addr <= rrd_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1227:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 203:38]
      ex1_reg_op1_data <= 32'h0; // @[src/main/scala/fpga/Core.scala 203:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (_rrd_op1_data_T_2) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op1_data <= 32'h0;
      end else if (_rrd_op1_data_T_6) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op1_data <= ex1_alu_out;
      end else begin
        ex1_reg_op1_data <= _rrd_op1_data_T_18;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 204:38]
      ex1_reg_op2_data <= 32'h0; // @[src/main/scala/fpga/Core.scala 204:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (_rrd_op2_data_T_2) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op2_data <= 32'h0;
      end else if (_rrd_op2_data_T_6) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op2_data <= ex1_alu_out;
      end else begin
        ex1_reg_op2_data <= _rrd_op2_data_T_18;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 205:38]
      ex1_reg_op3_data <= 32'h0; // @[src/main/scala/fpga/Core.scala 205:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (_rrd_op3_data_T) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op3_data <= 32'h0;
      end else if (_rrd_op3_data_T_1) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex1_reg_op3_data <= _rrd_op3_data_T_4;
      end else begin
        ex1_reg_op3_data <= _rrd_op3_data_T_17;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 206:38]
      ex1_reg_exe_fun <= 4'h0; // @[src/main/scala/fpga/Core.scala 206:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_exe_fun <= rrd_reg_exe_fun; // @[src/main/scala/fpga/Core.scala 1229:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 207:38]
      ex1_reg_rf_wen <= 1'h0; // @[src/main/scala/fpga/Core.scala 207:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1228:33]
        ex1_reg_rf_wen <= 1'h0;
      end else begin
        ex1_reg_rf_wen <= rrd_reg_rf_wen;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 208:38]
      ex1_reg_wb_sel <= 3'h0; // @[src/main/scala/fpga/Core.scala 208:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1230:33]
        ex1_reg_wb_sel <= 3'h0;
      end else begin
        ex1_reg_wb_sel <= rrd_reg_wb_sel;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 209:38]
      ex1_reg_csr_addr <= 12'h0; // @[src/main/scala/fpga/Core.scala 209:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_csr_addr <= rrd_reg_csr_addr; // @[src/main/scala/fpga/Core.scala 1232:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 210:38]
      ex1_reg_csr_cmd <= 2'h0; // @[src/main/scala/fpga/Core.scala 210:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_csr_cmd <= rrd_reg_csr_cmd; // @[src/main/scala/fpga/Core.scala 1233:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 211:38]
      ex1_reg_mem_w <= 3'h0; // @[src/main/scala/fpga/Core.scala 211:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_mem_w <= rrd_reg_mem_w; // @[src/main/scala/fpga/Core.scala 1234:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 212:38]
      ex1_reg_is_j <= 1'h0; // @[src/main/scala/fpga/Core.scala 212:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1237:33]
        ex1_reg_is_j <= 1'h0;
      end else begin
        ex1_reg_is_j <= rrd_reg_is_j;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 213:38]
      ex1_reg_bp_taken <= 1'h0; // @[src/main/scala/fpga/Core.scala 213:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1238:33]
        ex1_reg_bp_taken <= 1'h0;
      end else begin
        ex1_reg_bp_taken <= rrd_reg_bp_taken;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 214:38]
      ex1_reg_bp_taken_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 214:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_bp_taken_pc <= rrd_reg_bp_taken_pc; // @[src/main/scala/fpga/Core.scala 1239:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 215:38]
      ex1_reg_bp_cnt <= 2'h0; // @[src/main/scala/fpga/Core.scala 215:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_bp_cnt <= rrd_reg_bp_cnt; // @[src/main/scala/fpga/Core.scala 1240:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 216:38]
      ex1_reg_is_half <= 1'h0; // @[src/main/scala/fpga/Core.scala 216:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_is_half <= rrd_reg_is_half; // @[src/main/scala/fpga/Core.scala 1241:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 217:38]
      ex1_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 217:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_is_valid_inst <= rrd_reg_is_valid_inst & _ex1_reg_is_mret_T; // @[src/main/scala/fpga/Core.scala 1242:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 218:38]
      ex1_reg_is_trap <= 1'h0; // @[src/main/scala/fpga/Core.scala 218:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1243:33]
        ex1_reg_is_trap <= 1'h0;
      end else begin
        ex1_reg_is_trap <= rrd_reg_is_trap;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 219:38]
      ex1_reg_is_mret <= 1'h0; // @[src/main/scala/fpga/Core.scala 219:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_is_mret <= ~ex_is_bubble & (rrd_reg_exe_fun == 4'hf & rrd_reg_mem_w == 3'h3); // @[src/main/scala/fpga/Core.scala 1235:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 220:38]
      ex1_reg_mcause <= 32'h0; // @[src/main/scala/fpga/Core.scala 220:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_mcause <= rrd_reg_mcause; // @[src/main/scala/fpga/Core.scala 1244:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 222:38]
      ex1_reg_mem_use_reg <= 1'h0; // @[src/main/scala/fpga/Core.scala 222:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_mem_use_reg <= rrd_mem_use_reg; // @[src/main/scala/fpga/Core.scala 1246:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 223:38]
      ex1_reg_inst2_use_reg <= 1'h0; // @[src/main/scala/fpga/Core.scala 223:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_inst2_use_reg <= rrd_inst2_use_reg; // @[src/main/scala/fpga/Core.scala 1247:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 224:38]
      ex1_reg_inst3_use_reg <= 1'h0; // @[src/main/scala/fpga/Core.scala 224:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_inst3_use_reg <= rrd_inst3_use_reg; // @[src/main/scala/fpga/Core.scala 1248:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 225:38]
      ex1_reg_is_br <= 1'h0; // @[src/main/scala/fpga/Core.scala 225:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      if (ex_is_bubble) begin // @[src/main/scala/fpga/Core.scala 1236:33]
        ex1_reg_is_br <= 1'h0;
      end else begin
        ex1_reg_is_br <= rrd_reg_is_br;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 226:38]
      ex1_reg_direct_jbr_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 226:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_direct_jbr_pc <= rrd_direct_jbr_pc; // @[src/main/scala/fpga/Core.scala 1231:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 229:38]
      ex2_reg_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 229:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_pc <= ex1_reg_pc; // @[src/main/scala/fpga/Core.scala 1497:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 230:38]
      ex2_reg_wb_addr <= 5'h0; // @[src/main/scala/fpga/Core.scala 230:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_wb_addr <= ex1_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1498:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 231:38]
      ex2_reg_mullu <= 48'h0; // @[src/main/scala/fpga/Core.scala 231:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_mullu <= ex1_mullu; // @[src/main/scala/fpga/Core.scala 1500:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 232:38]
      ex2_reg_mulls <= 32'h0; // @[src/main/scala/fpga/Core.scala 232:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_mulls <= ex1_mulls; // @[src/main/scala/fpga/Core.scala 1501:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 233:38]
      ex2_reg_mulhuu <= 48'h0; // @[src/main/scala/fpga/Core.scala 233:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_mulhuu <= ex1_mulhuu; // @[src/main/scala/fpga/Core.scala 1502:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 234:38]
      ex2_reg_mulhss <= 48'sh0; // @[src/main/scala/fpga/Core.scala 234:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_mulhss <= ex1_mulhss; // @[src/main/scala/fpga/Core.scala 1503:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 235:38]
      ex2_reg_mulhsu <= 48'sh0; // @[src/main/scala/fpga/Core.scala 235:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_mulhsu <= ex1_mulhsu; // @[src/main/scala/fpga/Core.scala 1504:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 236:38]
      ex2_reg_exe_fun <= 4'h0; // @[src/main/scala/fpga/Core.scala 236:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_exe_fun <= ex1_reg_exe_fun; // @[src/main/scala/fpga/Core.scala 1506:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 237:38]
      ex2_reg_rf_wen <= 1'h0; // @[src/main/scala/fpga/Core.scala 237:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall) begin // @[src/main/scala/fpga/Core.scala 1530:43]
      ex2_reg_rf_wen <= 1'h0; // @[src/main/scala/fpga/Core.scala 1532:27]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_rf_wen <= ex1_en & ex1_reg_rf_wen; // @[src/main/scala/fpga/Core.scala 1507:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 238:38]
      ex2_reg_wb_sel <= 3'h0; // @[src/main/scala/fpga/Core.scala 238:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_wb_sel <= ex1_reg_wb_sel; // @[src/main/scala/fpga/Core.scala 1508:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 239:38]
      ex2_reg_alu_out <= 32'h0; // @[src/main/scala/fpga/Core.scala 239:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      if (_ex1_alu_out_T) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex2_reg_alu_out <= ex1_add_out;
      end else if (_ex1_alu_out_T_1) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex2_reg_alu_out <= _ex1_alu_out_T_3;
      end else begin
        ex2_reg_alu_out <= _ex1_alu_out_T_51;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 240:38]
      ex2_reg_pc_bit_out <= 32'h0; // @[src/main/scala/fpga/Core.scala 240:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      if (_ex1_pc_bit_out_T) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex2_reg_pc_bit_out <= _ex1_pc_bit_out_T_1;
      end else if (_ex1_alu_out_T_29) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ex2_reg_pc_bit_out <= _ex1_pc_bit_out_T_4;
      end else begin
        ex2_reg_pc_bit_out <= _ex1_pc_bit_out_T_326;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 241:38]
      ex2_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 241:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall) begin // @[src/main/scala/fpga/Core.scala 1530:43]
      ex2_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 1534:27]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_is_valid_inst <= ex1_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1510:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 244:38]
      ex2_reg_divrem <= 1'h0; // @[src/main/scala/fpga/Core.scala 244:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall) begin // @[src/main/scala/fpga/Core.scala 1530:43]
      ex2_reg_divrem <= 1'h0; // @[src/main/scala/fpga/Core.scala 1533:27]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_divrem <= ex1_divrem & ex1_en; // @[src/main/scala/fpga/Core.scala 1511:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 245:38]
      ex2_reg_sign_op1 <= 1'h0; // @[src/main/scala/fpga/Core.scala 245:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_sign_op1 <= ex1_sign_op1; // @[src/main/scala/fpga/Core.scala 1514:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 246:38]
      ex2_reg_sign_op12 <= 1'h0; // @[src/main/scala/fpga/Core.scala 246:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_sign_op12 <= ex1_sign_op12; // @[src/main/scala/fpga/Core.scala 1515:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 247:38]
      ex2_reg_zero_op2 <= 1'h0; // @[src/main/scala/fpga/Core.scala 247:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_zero_op2 <= ex1_zero_op2; // @[src/main/scala/fpga/Core.scala 1516:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 248:38]
      ex2_reg_init_dividend <= 37'h0; // @[src/main/scala/fpga/Core.scala 248:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      if (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) begin // @[src/main/scala/fpga/Core.scala 1305:69]
        if (ex1_reg_op1_data[31]) begin // @[src/main/scala/fpga/Core.scala 1307:49]
          ex2_reg_init_dividend <= _ex1_dividend_T_5; // @[src/main/scala/fpga/Core.scala 1308:20]
        end else begin
          ex2_reg_init_dividend <= _ex1_dividend_T_8; // @[src/main/scala/fpga/Core.scala 1310:20]
        end
      end else if (_ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38) begin // @[src/main/scala/fpga/Core.scala 1320:77]
        ex2_reg_init_dividend <= _ex1_dividend_T_8; // @[src/main/scala/fpga/Core.scala 1322:18]
      end else begin
        ex2_reg_init_dividend <= 37'h0; // @[src/main/scala/fpga/Core.scala 1301:33]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 249:38]
      ex2_reg_init_divisor <= 32'h0; // @[src/main/scala/fpga/Core.scala 249:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      if (_ex1_pc_bit_out_T_301 | _ex1_pc_bit_out_T_306) begin // @[src/main/scala/fpga/Core.scala 1305:69]
        if (ex1_reg_op2_data[31]) begin // @[src/main/scala/fpga/Core.scala 1313:49]
          ex2_reg_init_divisor <= _ex1_divisor_T_2; // @[src/main/scala/fpga/Core.scala 1314:19]
        end else begin
          ex2_reg_init_divisor <= ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1317:19]
        end
      end else if (_ex1_pc_bit_out_T_309 | _ex1_alu_out_T_38) begin // @[src/main/scala/fpga/Core.scala 1320:77]
        ex2_reg_init_divisor <= ex1_reg_op2_data; // @[src/main/scala/fpga/Core.scala 1324:17]
      end else begin
        ex2_reg_init_divisor <= 32'h0; // @[src/main/scala/fpga/Core.scala 1302:32]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 250:38]
      ex2_reg_orig_dividend <= 32'h0; // @[src/main/scala/fpga/Core.scala 250:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_orig_dividend <= ex1_reg_op1_data; // @[src/main/scala/fpga/Core.scala 1519:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 251:38]
      ex2_reg_inst3_use_reg <= 1'h0; // @[src/main/scala/fpga/Core.scala 251:38]
    end else if (mem2_dram_stall & ~ex2_reg_div_stall) begin // @[src/main/scala/fpga/Core.scala 1530:43]
      ex2_reg_inst3_use_reg <= 1'h0; // @[src/main/scala/fpga/Core.scala 1535:27]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_inst3_use_reg <= ex1_reg_inst3_use_reg & ex1_en; // @[src/main/scala/fpga/Core.scala 1520:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 252:38]
      ex2_reg_no_mem <= 1'h0; // @[src/main/scala/fpga/Core.scala 252:38]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_no_mem <= _ex1_fw_en_next_T_2 & ex1_reg_wb_sel != 3'h4 & ex1_reg_wb_sel != 3'h7 & ex1_en; // @[src/main/scala/fpga/Core.scala 1509:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 255:39]
      mem1_reg_mem_wstrb <= 7'h0; // @[src/main/scala/fpga/Core.scala 255:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_mem_wstrb <= _mem1_reg_mem_wstrb_T_9; // @[src/main/scala/fpga/Core.scala 1752:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 256:39]
      mem1_reg_wdata <= 32'h0; // @[src/main/scala/fpga/Core.scala 256:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_wdata <= _mem1_reg_wdata_T_4[55:24]; // @[src/main/scala/fpga/Core.scala 1761:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 257:39]
      mem1_reg_mem_w <= 3'h0; // @[src/main/scala/fpga/Core.scala 257:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_mem_w <= ex1_reg_mem_w; // @[src/main/scala/fpga/Core.scala 1762:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 260:39]
      mem1_reg_is_mem_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 260:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_mem_load <= ~mem1_is_dram & _mem1_reg_unaligned_T_12 & ex1_en; // @[src/main/scala/fpga/Core.scala 1766:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 261:39]
      mem1_reg_is_mem_store <= 1'h0; // @[src/main/scala/fpga/Core.scala 261:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_mem_store <= _mem1_reg_is_mem_load_T & _mem1_reg_unaligned_T_13 & ex1_en; // @[src/main/scala/fpga/Core.scala 1767:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 262:39]
      mem1_reg_is_dram_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 262:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_dram_load <= mem1_is_dram & _mem1_reg_unaligned_T_12 & ex1_en; // @[src/main/scala/fpga/Core.scala 1768:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 263:39]
      mem1_reg_is_dram_store <= 1'h0; // @[src/main/scala/fpga/Core.scala 263:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_dram_store <= mem1_is_dram & _mem1_reg_unaligned_T_13 & ex1_en; // @[src/main/scala/fpga/Core.scala 1769:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 264:39]
      mem1_reg_is_dram_fence <= 1'h0; // @[src/main/scala/fpga/Core.scala 264:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_dram_fence <= ex1_reg_wb_sel == 3'h7 & ex1_en; // @[src/main/scala/fpga/Core.scala 1770:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 265:39]
      mem1_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 265:39]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_is_valid_inst <= (_mem1_reg_unaligned_T_14 | _mem1_reg_is_dram_fence_T) & ex1_en; // @[src/main/scala/fpga/Core.scala 1771:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 266:39]
      mem1_reg_unaligned <= 1'h0; // @[src/main/scala/fpga/Core.scala 266:39]
    end else if (~mem1_mem_stall & ~mem1_dram_stall & mem1_reg_unaligned) begin // @[src/main/scala/fpga/Core.scala 1780:68]
      mem1_reg_unaligned <= 1'h0; // @[src/main/scala/fpga/Core.scala 1781:30]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1751:21]
      mem1_reg_unaligned <= _mem1_reg_unaligned_T_16; // @[src/main/scala/fpga/Core.scala 1757:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 269:40]
      mem2_reg_wb_byte_offset <= 2'h0; // @[src/main/scala/fpga/Core.scala 269:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_wb_byte_offset <= ex2_reg_alu_out[1:0]; // @[src/main/scala/fpga/Core.scala 1816:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 270:40]
      mem2_reg_mem_w <= 3'h0; // @[src/main/scala/fpga/Core.scala 270:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_mem_w <= mem1_reg_mem_w; // @[src/main/scala/fpga/Core.scala 1817:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 272:40]
      mem2_reg_wb_addr <= 32'h0; // @[src/main/scala/fpga/Core.scala 272:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_wb_addr <= {{27'd0}, ex2_reg_wb_addr}; // @[src/main/scala/fpga/Core.scala 1819:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 273:40]
      mem2_reg_is_valid_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 273:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_is_valid_load <= _T_116 & mem1_reg_is_mem_load | _T_117 & mem1_reg_is_dram_load; // @[src/main/scala/fpga/Core.scala 1820:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 275:40]
      mem2_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 275:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_is_valid_inst <= _T_118 & mem1_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1822:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 276:40]
      mem2_reg_is_mem_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 276:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_is_mem_load <= _mem2_reg_is_valid_load_T_1; // @[src/main/scala/fpga/Core.scala 1823:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 277:40]
      mem2_reg_is_dram_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 277:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_is_dram_load <= _mem2_reg_is_valid_load_T_3; // @[src/main/scala/fpga/Core.scala 1824:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 278:40]
      mem2_reg_unaligned <= 1'h0; // @[src/main/scala/fpga/Core.scala 278:40]
    end else if (~mem2_dram_stall) begin // @[src/main/scala/fpga/Core.scala 1815:22]
      mem2_reg_unaligned <= mem1_reg_unaligned; // @[src/main/scala/fpga/Core.scala 1825:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 281:40]
      mem3_reg_wb_byte_offset <= 2'h0; // @[src/main/scala/fpga/Core.scala 281:40]
    end else begin
      mem3_reg_wb_byte_offset <= mem2_reg_wb_byte_offset; // @[src/main/scala/fpga/Core.scala 1853:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 282:40]
      mem3_reg_mem_w <= 3'h0; // @[src/main/scala/fpga/Core.scala 282:40]
    end else begin
      mem3_reg_mem_w <= mem2_reg_mem_w; // @[src/main/scala/fpga/Core.scala 1854:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 283:40]
      mem3_reg_dmem_rdata <= 32'h0; // @[src/main/scala/fpga/Core.scala 283:40]
    end else if (mem2_reg_is_dram_load) begin // @[src/main/scala/fpga/Core.scala 1855:33]
      mem3_reg_dmem_rdata <= io_cache_rdata;
    end else begin
      mem3_reg_dmem_rdata <= io_dmem_rdata;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 284:40]
      mem3_reg_rdata_high <= 24'h0; // @[src/main/scala/fpga/Core.scala 284:40]
    end else if (mem3_reg_unaligned) begin // @[src/main/scala/fpga/Core.scala 1878:29]
      mem3_reg_rdata_high <= mem3_reg_dmem_rdata[23:0]; // @[src/main/scala/fpga/Core.scala 1879:25]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 285:40]
      mem3_reg_wb_addr <= 32'h0; // @[src/main/scala/fpga/Core.scala 285:40]
    end else begin
      mem3_reg_wb_addr <= mem2_reg_wb_addr; // @[src/main/scala/fpga/Core.scala 1856:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 286:40]
      mem3_reg_is_valid_load <= 1'h0; // @[src/main/scala/fpga/Core.scala 286:40]
    end else begin
      mem3_reg_is_valid_load <= _mem2_is_valid_load_T_2 & mem2_is_valid_load; // @[src/main/scala/fpga/Core.scala 1857:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 287:40]
      mem3_reg_is_valid_inst <= 1'h0; // @[src/main/scala/fpga/Core.scala 287:40]
    end else begin
      mem3_reg_is_valid_inst <= _mem2_is_valid_load_T_2 & mem2_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1859:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 289:40]
      mem3_reg_unaligned <= 1'h0; // @[src/main/scala/fpga/Core.scala 289:40]
    end else begin
      mem3_reg_unaligned <= mem2_reg_unaligned; // @[src/main/scala/fpga/Core.scala 1861:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 290:40]
      mem3_reg_is_aligned_lw <= 1'h0; // @[src/main/scala/fpga/Core.scala 290:40]
    end else begin
      mem3_reg_is_aligned_lw <= mem2_is_aligned_lw; // @[src/main/scala/fpga/Core.scala 1862:27]
    end
    id_reg_is_bp_fail <= reset | _ic_read_en4_T & _if2_is_valid_inst_T & _if2_is_valid_inst_T_1 & ~id_is_j & ~id_is_br
       & id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 292:{37,37} 910:21]
    if (reset) begin // @[src/main/scala/fpga/Core.scala 293:37]
      id_reg_br_pc <= 31'h4000000; // @[src/main/scala/fpga/Core.scala 293:37]
    end else if (id_is_half) begin // @[src/main/scala/fpga/Core.scala 909:22]
      id_reg_br_pc <= _id_reg_br_pc_T_1;
    end else begin
      id_reg_br_pc <= _id_reg_br_pc_T_3;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 301:37]
      ex1_reg_fw_en <= 1'h0; // @[src/main/scala/fpga/Core.scala 301:37]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1221:20]
      ex1_reg_fw_en <= rrd_fw_en_next; // @[src/main/scala/fpga/Core.scala 1249:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 303:37]
      ex2_reg_fw_en <= 1'h0; // @[src/main/scala/fpga/Core.scala 303:37]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_fw_en <= ex1_fw_en_next; // @[src/main/scala/fpga/Core.scala 1521:31]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 305:37]
      mem3_reg_fw_en <= 1'h0; // @[src/main/scala/fpga/Core.scala 305:37]
    end else begin
      mem3_reg_fw_en <= mem2_is_aligned_lw; // @[src/main/scala/fpga/Core.scala 1860:27]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 308:37]
      ex2_reg_div_stall <= 1'h0; // @[src/main/scala/fpga/Core.scala 308:37]
    end else if (_T_43) begin // @[src/main/scala/fpga/Core.scala 1496:21]
      ex2_reg_div_stall <= ex2_div_stall_next | _ex2_reg_div_stall_T_4; // @[src/main/scala/fpga/Core.scala 1512:31]
    end else begin
      ex2_reg_div_stall <= ex2_div_stall_next | _ex2_reg_div_stall_T_9; // @[src/main/scala/fpga/Core.scala 1526:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 310:37]
      ex2_reg_divrem_state <= 3'h0; // @[src/main/scala/fpga/Core.scala 310:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (ex2_reg_divrem) begin // @[src/main/scala/fpga/Core.scala 1577:29]
        ex2_reg_divrem_state <= {{1'd0}, _GEN_538};
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (ex2_reg_p_divisor[63:36] == 28'h0) begin // @[src/main/scala/fpga/Core.scala 1600:66]
        ex2_reg_divrem_state <= 3'h2; // @[src/main/scala/fpga/Core.scala 1601:30]
      end
    end else if (3'h2 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divrem_state <= _GEN_547;
    end else begin
      ex2_reg_divrem_state <= _GEN_553;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 311:37]
      ex2_reg_is_br <= 1'h0; // @[src/main/scala/fpga/Core.scala 311:37]
    end else begin
      ex2_reg_is_br <= csr_is_br | ex1_is_br; // @[src/main/scala/fpga/Core.scala 1491:17]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 312:37]
      ex2_reg_br_pc <= 31'h0; // @[src/main/scala/fpga/Core.scala 312:37]
    end else if (csr_is_br) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
      if (csr_is_meintr) begin // @[src/main/scala/fpga/Core.scala 1449:24]
        ex2_reg_br_pc <= csr_reg_trap_vector; // @[src/main/scala/fpga/Core.scala 1458:26]
      end else if (csr_is_mtintr) begin // @[src/main/scala/fpga/Core.scala 1459:30]
        ex2_reg_br_pc <= csr_reg_trap_vector; // @[src/main/scala/fpga/Core.scala 1468:26]
      end else begin
        ex2_reg_br_pc <= _GEN_493;
      end
    end else if (_ex1_br_pc_T_1) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
      if (ex1_reg_is_j) begin // @[src/main/scala/fpga/Core.scala 1342:25]
        ex2_reg_br_pc <= ex1_add_out[31:1];
      end else begin
        ex2_reg_br_pc <= ex1_reg_direct_jbr_pc;
      end
    end else if (ex1_reg_is_half) begin // @[src/main/scala/fpga/Core.scala 1281:24]
      ex2_reg_br_pc <= _ex1_next_pc_T_1;
    end else begin
      ex2_reg_br_pc <= _ex1_next_pc_T_3;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 317:37]
      ex2_reg_is_retired <= 1'h0; // @[src/main/scala/fpga/Core.scala 317:37]
    end else begin
      ex2_reg_is_retired <= ex2_reg_is_valid_inst & _T_78 & ex2_reg_no_mem; // @[src/main/scala/fpga/Core.scala 1735:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 318:37]
      mem3_reg_is_retired <= 1'h0; // @[src/main/scala/fpga/Core.scala 318:37]
    end else begin
      mem3_reg_is_retired <= mem3_reg_is_valid_inst; // @[src/main/scala/fpga/Core.scala 1895:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 338:33]
      ic_reg_read_rdy <= 1'h0; // @[src/main/scala/fpga/Core.scala 338:33]
    end else if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
      ic_reg_read_rdy <= ~if1_jump_addr[0]; // @[src/main/scala/fpga/Core.scala 395:22]
    end else if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
      ic_reg_read_rdy <= 1'h1; // @[src/main/scala/fpga/Core.scala 375:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 339:33]
      ic_reg_half_rdy <= 1'h0; // @[src/main/scala/fpga/Core.scala 339:33]
    end else begin
      ic_reg_half_rdy <= _GEN_191;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 343:33]
      ic_reg_imem_addr <= 31'h0; // @[src/main/scala/fpga/Core.scala 343:33]
    end else if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
      ic_reg_imem_addr <= ic_next_imem_addr; // @[src/main/scala/fpga/Core.scala 392:22]
    end else if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
      if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_reg_imem_addr <= ic_imem_addr_4; // @[src/main/scala/fpga/Core.scala 452:26]
      end else begin
        ic_reg_imem_addr <= _GEN_116;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 344:33]
      ic_reg_addr_out <= 31'h0; // @[src/main/scala/fpga/Core.scala 344:33]
    end else if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (ex2_reg_is_br) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ic_reg_addr_out <= ex2_reg_br_pc;
      end else if (id_reg_is_bp_fail) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        ic_reg_addr_out <= id_reg_br_pc;
      end else begin
        ic_reg_addr_out <= id_reg_bp_taken_pc;
      end
    end else if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
      if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_reg_addr_out <= _GEN_47;
      end else begin
        ic_reg_addr_out <= _GEN_120;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 347:34]
      ic_reg_inst <= 32'h0; // @[src/main/scala/fpga/Core.scala 347:34]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
          ic_reg_inst <= io_imem_inst; // @[src/main/scala/fpga/Core.scala 453:26]
        end else begin
          ic_reg_inst <= _GEN_117;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 348:34]
      ic_reg_inst_addr <= 31'h0; // @[src/main/scala/fpga/Core.scala 348:34]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
          ic_reg_inst_addr <= ic_reg_imem_addr; // @[src/main/scala/fpga/Core.scala 454:26]
        end else begin
          ic_reg_inst_addr <= _GEN_118;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 349:34]
      ic_reg_inst2 <= 32'h0; // @[src/main/scala/fpga/Core.scala 349:34]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (!(_T_3)) begin // @[src/main/scala/fpga/Core.scala 449:23]
          ic_reg_inst2 <= _GEN_132;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 352:25]
      ic_state <= 3'h0; // @[src/main/scala/fpga/Core.scala 352:25]
    end else if (if1_is_jump) begin // @[src/main/scala/fpga/Core.scala 389:21]
      ic_state <= {{2'd0}, if1_jump_addr[0]}; // @[src/main/scala/fpga/Core.scala 394:22]
    end else if (!(~io_imem_valid)) begin // @[src/main/scala/fpga/Core.scala 398:98]
      if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_state <= _GEN_48;
      end else begin
        ic_state <= _GEN_131;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 360:41]
      ic_reg_bp_next_taken0 <= 1'h0; // @[src/main/scala/fpga/Core.scala 360:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_taken0 <= _GEN_36;
      end else begin
        ic_reg_bp_next_taken0 <= _GEN_36;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 361:41]
      ic_reg_bp_next_taken_pc0 <= 31'h0; // @[src/main/scala/fpga/Core.scala 361:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_taken_pc0 <= _GEN_37;
      end else begin
        ic_reg_bp_next_taken_pc0 <= _GEN_37;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 362:41]
      ic_reg_bp_next_cnt0 <= 2'h0; // @[src/main/scala/fpga/Core.scala 362:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_cnt0 <= _GEN_38;
      end else begin
        ic_reg_bp_next_cnt0 <= _GEN_38;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 363:41]
      ic_reg_bp_next_taken1 <= 1'h0; // @[src/main/scala/fpga/Core.scala 363:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (3'h0 == ic_state) begin // @[src/main/scala/fpga/Core.scala 403:23]
          ic_reg_bp_next_taken1 <= ic_btb_io_lu_matches1 & ic_pht_io_lu_cnt1[0]; // @[src/main/scala/fpga/Core.scala 411:34]
        end else begin
          ic_reg_bp_next_taken1 <= _GEN_27;
        end
      end else if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_reg_bp_next_taken1 <= _ic_reg_bp_next_taken1_T_1; // @[src/main/scala/fpga/Core.scala 464:34]
      end else begin
        ic_reg_bp_next_taken1 <= _GEN_128;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 364:41]
      ic_reg_bp_next_taken_pc1 <= 31'h0; // @[src/main/scala/fpga/Core.scala 364:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (3'h0 == ic_state) begin // @[src/main/scala/fpga/Core.scala 403:23]
          ic_reg_bp_next_taken_pc1 <= ic_btb_io_lu_taken_pc1; // @[src/main/scala/fpga/Core.scala 412:34]
        end else begin
          ic_reg_bp_next_taken_pc1 <= _GEN_28;
        end
      end else if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_reg_bp_next_taken_pc1 <= ic_btb_io_lu_taken_pc1; // @[src/main/scala/fpga/Core.scala 465:34]
      end else begin
        ic_reg_bp_next_taken_pc1 <= _GEN_129;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 365:41]
      ic_reg_bp_next_cnt1 <= 2'h0; // @[src/main/scala/fpga/Core.scala 365:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        if (3'h0 == ic_state) begin // @[src/main/scala/fpga/Core.scala 403:23]
          ic_reg_bp_next_cnt1 <= ic_pht_io_lu_cnt1; // @[src/main/scala/fpga/Core.scala 413:34]
        end else begin
          ic_reg_bp_next_cnt1 <= _GEN_29;
        end
      end else if (_T_3) begin // @[src/main/scala/fpga/Core.scala 449:23]
        ic_reg_bp_next_cnt1 <= ic_pht_io_lu_cnt1; // @[src/main/scala/fpga/Core.scala 466:34]
      end else begin
        ic_reg_bp_next_cnt1 <= _GEN_130;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 366:41]
      ic_reg_bp_next_taken2 <= 1'h0; // @[src/main/scala/fpga/Core.scala 366:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_taken2 <= _GEN_42;
      end else begin
        ic_reg_bp_next_taken2 <= _GEN_42;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 367:41]
      ic_reg_bp_next_taken_pc2 <= 31'h0; // @[src/main/scala/fpga/Core.scala 367:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_taken_pc2 <= _GEN_43;
      end else begin
        ic_reg_bp_next_taken_pc2 <= _GEN_43;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 368:41]
      ic_reg_bp_next_cnt2 <= 2'h0; // @[src/main/scala/fpga/Core.scala 368:41]
    end else if (!(if1_is_jump)) begin // @[src/main/scala/fpga/Core.scala 389:21]
      if (~io_imem_valid) begin // @[src/main/scala/fpga/Core.scala 398:98]
        ic_reg_bp_next_cnt2 <= _GEN_44;
      end else begin
        ic_reg_bp_next_cnt2 <= _GEN_44;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 917:40]
      id_reg_pc_delay <= 31'h0; // @[src/main/scala/fpga/Core.scala 917:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_pc_delay <= _GEN_217;
    end else begin
      id_reg_pc_delay <= _GEN_217;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 918:40]
      id_reg_wb_addr_delay <= 5'h0; // @[src/main/scala/fpga/Core.scala 918:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_wb_addr_delay <= _GEN_226;
    end else begin
      id_reg_wb_addr_delay <= _GEN_226;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 919:40]
      id_reg_op1_sel_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 919:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_op1_sel_delay <= _GEN_218;
    end else begin
      id_reg_op1_sel_delay <= _GEN_218;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 920:40]
      id_reg_op2_sel_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 920:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_op2_sel_delay <= _GEN_219;
    end else begin
      id_reg_op2_sel_delay <= _GEN_219;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 921:40]
      id_reg_op3_sel_delay <= 2'h0; // @[src/main/scala/fpga/Core.scala 921:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_op3_sel_delay <= _GEN_220;
    end else begin
      id_reg_op3_sel_delay <= _GEN_220;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 922:40]
      id_reg_rs1_addr_delay <= 5'h0; // @[src/main/scala/fpga/Core.scala 922:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_rs1_addr_delay <= _GEN_221;
    end else begin
      id_reg_rs1_addr_delay <= _GEN_221;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 923:40]
      id_reg_rs2_addr_delay <= 5'h0; // @[src/main/scala/fpga/Core.scala 923:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_rs2_addr_delay <= _GEN_222;
    end else begin
      id_reg_rs2_addr_delay <= _GEN_222;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 924:40]
      id_reg_rs3_addr_delay <= 5'h0; // @[src/main/scala/fpga/Core.scala 924:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_rs3_addr_delay <= _GEN_223;
    end else begin
      id_reg_rs3_addr_delay <= _GEN_223;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 925:40]
      id_reg_op1_data_delay <= 32'h0; // @[src/main/scala/fpga/Core.scala 925:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_op1_data_delay <= _GEN_224;
    end else begin
      id_reg_op1_data_delay <= _GEN_224;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 926:40]
      id_reg_op2_data_delay <= 32'h0; // @[src/main/scala/fpga/Core.scala 926:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_op2_data_delay <= _GEN_225;
    end else begin
      id_reg_op2_data_delay <= _GEN_225;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 927:40]
      id_reg_exe_fun_delay <= 4'h0; // @[src/main/scala/fpga/Core.scala 927:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_exe_fun_delay <= 4'h0; // @[src/main/scala/fpga/Core.scala 967:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      if (_csignals_T_1) begin // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
        id_reg_exe_fun_delay <= 4'h0;
      end else begin
        id_reg_exe_fun_delay <= _csignals_T_379;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 928:40]
      id_reg_rf_wen_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 928:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_rf_wen_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 966:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_rf_wen_delay <= csignals_4; // @[src/main/scala/fpga/Core.scala 987:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 929:40]
      id_reg_wb_sel_delay <= 3'h0; // @[src/main/scala/fpga/Core.scala 929:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_wb_sel_delay <= 3'h0; // @[src/main/scala/fpga/Core.scala 968:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      if (_csignals_T_1) begin // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
        id_reg_wb_sel_delay <= 3'h5;
      end else begin
        id_reg_wb_sel_delay <= _csignals_T_1009;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 930:40]
      id_reg_csr_addr_delay <= 12'h0; // @[src/main/scala/fpga/Core.scala 930:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_csr_addr_delay <= _GEN_228;
    end else begin
      id_reg_csr_addr_delay <= _GEN_228;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 931:40]
      id_reg_csr_cmd_delay <= 2'h0; // @[src/main/scala/fpga/Core.scala 931:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_csr_cmd_delay <= 2'h0; // @[src/main/scala/fpga/Core.scala 969:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      if (_csignals_T_1) begin // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
        id_reg_csr_cmd_delay <= 2'h0;
      end else begin
        id_reg_csr_cmd_delay <= _csignals_T_1261;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 932:40]
      id_reg_imm_b_sext_delay <= 32'h0; // @[src/main/scala/fpga/Core.scala 932:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_imm_b_sext_delay <= _GEN_227;
    end else begin
      id_reg_imm_b_sext_delay <= _GEN_227;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 933:40]
      id_reg_mem_w_delay <= 3'h0; // @[src/main/scala/fpga/Core.scala 933:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_mem_w_delay <= 3'h0; // @[src/main/scala/fpga/Core.scala 970:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      if (_csignals_T_1) begin // @[src/main/scala/chisel3/util/Lookup.scala 34:39]
        id_reg_mem_w_delay <= 3'h5;
      end else begin
        id_reg_mem_w_delay <= _csignals_T_1387;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 935:40]
      id_reg_is_br_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 935:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_is_br_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 971:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_is_br_delay <= id_is_br; // @[src/main/scala/fpga/Core.scala 995:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 936:40]
      id_reg_is_j_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 936:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_is_j_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 972:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_is_j_delay <= id_is_j; // @[src/main/scala/fpga/Core.scala 996:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 937:40]
      id_reg_bp_taken_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 937:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_bp_taken_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 973:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_bp_taken_delay <= id_reg_bp_taken; // @[src/main/scala/fpga/Core.scala 997:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 938:41]
      id_reg_bp_taken_pc_delay <= 31'h0; // @[src/main/scala/fpga/Core.scala 938:41]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_bp_taken_pc_delay <= _GEN_230;
    end else begin
      id_reg_bp_taken_pc_delay <= _GEN_230;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 939:40]
      id_reg_bp_cnt_delay <= 2'h0; // @[src/main/scala/fpga/Core.scala 939:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_bp_cnt_delay <= _GEN_231;
    end else begin
      id_reg_bp_cnt_delay <= _GEN_231;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 940:40]
      id_reg_is_half_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 940:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_is_half_delay <= _GEN_232;
    end else begin
      id_reg_is_half_delay <= _GEN_232;
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 941:43]
      id_reg_is_valid_inst_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 941:43]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_is_valid_inst_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 974:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_is_valid_inst_delay <= id_inst != 32'h13; // @[src/main/scala/fpga/Core.scala 1001:32]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 942:40]
      id_reg_is_trap_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 942:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_is_trap_delay <= 1'h0; // @[src/main/scala/fpga/Core.scala 975:32]
    end else if (_ic_read_en4_T) begin // @[src/main/scala/fpga/Core.scala 976:30]
      id_reg_is_trap_delay <= _id_csr_addr_T_2; // @[src/main/scala/fpga/Core.scala 1002:29]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 943:40]
      id_reg_mcause_delay <= 32'h0; // @[src/main/scala/fpga/Core.scala 943:40]
    end else if (ex2_reg_is_br) begin // @[src/main/scala/fpga/Core.scala 946:24]
      id_reg_mcause_delay <= _GEN_233;
    end else begin
      id_reg_mcause_delay <= _GEN_233;
    end
    csr_reg_is_meintr <= _csr_reg_is_meintr_T_4 & _csr_reg_is_meintr_T_8; // @[src/main/scala/fpga/Core.scala 1386:15]
    csr_reg_is_mtintr <= _csr_reg_is_mtintr_T_4 & _csr_reg_is_mtintr_T_8; // @[src/main/scala/fpga/Core.scala 1391:22]
    ex2_reg_dividend <= _GEN_643[36:0]; // @[src/main/scala/fpga/Core.scala 1543:{37,37}]
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1544:37]
      ex2_reg_divisor <= 36'h0; // @[src/main/scala/fpga/Core.scala 1544:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divisor <= _ex2_reg_divisor_T_1; // @[src/main/scala/fpga/Core.scala 1586:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divisor <= ex2_reg_p_divisor[37:2]; // @[src/main/scala/fpga/Core.scala 1604:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1545:37]
      ex2_reg_p_divisor <= 64'h0; // @[src/main/scala/fpga/Core.scala 1545:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_p_divisor <= _ex2_reg_p_divisor_T; // @[src/main/scala/fpga/Core.scala 1587:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_p_divisor <= {{2'd0}, ex2_reg_p_divisor[63:2]}; // @[src/main/scala/fpga/Core.scala 1603:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1546:37]
      ex2_reg_divrem_count <= 5'h0; // @[src/main/scala/fpga/Core.scala 1546:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divrem_count <= 5'h0; // @[src/main/scala/fpga/Core.scala 1588:28]
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divrem_count <= _ex2_reg_divrem_count_T_1; // @[src/main/scala/fpga/Core.scala 1605:28]
    end else if (3'h2 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_divrem_count <= _ex2_reg_divrem_count_T_1; // @[src/main/scala/fpga/Core.scala 1662:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1547:37]
      ex2_reg_rem_shift <= 5'h0; // @[src/main/scala/fpga/Core.scala 1547:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      ex2_reg_rem_shift <= 5'h0; // @[src/main/scala/fpga/Core.scala 1589:28]
    end else if (!(3'h1 == ex2_reg_divrem_state)) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (3'h2 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
        ex2_reg_rem_shift <= _ex2_reg_rem_shift_T_1; // @[src/main/scala/fpga/Core.scala 1661:25]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1548:37]
      ex2_reg_extra_shift <= 1'h0; // @[src/main/scala/fpga/Core.scala 1548:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (~ex2_reg_init_divisor[1]) begin // @[src/main/scala/fpga/Core.scala 1591:46]
        ex2_reg_extra_shift <= 1'h0; // @[src/main/scala/fpga/Core.scala 1592:29]
      end else begin
        ex2_reg_extra_shift <= 1'h1; // @[src/main/scala/fpga/Core.scala 1595:29]
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (~ex2_reg_p_divisor[35]) begin // @[src/main/scala/fpga/Core.scala 1606:52]
        ex2_reg_extra_shift <= 1'h0; // @[src/main/scala/fpga/Core.scala 1607:29]
      end else begin
        ex2_reg_extra_shift <= 1'h1; // @[src/main/scala/fpga/Core.scala 1610:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1549:37]
      ex2_reg_d <= 3'h0; // @[src/main/scala/fpga/Core.scala 1549:37]
    end else if (3'h0 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (~ex2_reg_init_divisor[1]) begin // @[src/main/scala/fpga/Core.scala 1591:46]
        ex2_reg_d <= 3'h0; // @[src/main/scala/fpga/Core.scala 1593:29]
      end else begin
        ex2_reg_d <= _ex2_reg_d_T_1; // @[src/main/scala/fpga/Core.scala 1596:29]
      end
    end else if (3'h1 == ex2_reg_divrem_state) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (~ex2_reg_p_divisor[35]) begin // @[src/main/scala/fpga/Core.scala 1606:52]
        ex2_reg_d <= ex2_reg_p_divisor[33:31]; // @[src/main/scala/fpga/Core.scala 1608:29]
      end else begin
        ex2_reg_d <= ex2_reg_p_divisor[34:32]; // @[src/main/scala/fpga/Core.scala 1611:29]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Core.scala 1550:37]
      ex2_reg_reminder <= 32'h0; // @[src/main/scala/fpga/Core.scala 1550:37]
    end else if (!(3'h0 == ex2_reg_divrem_state)) begin // @[src/main/scala/fpga/Core.scala 1575:33]
      if (!(3'h1 == ex2_reg_divrem_state)) begin // @[src/main/scala/fpga/Core.scala 1575:33]
        if (!(3'h2 == ex2_reg_divrem_state)) begin // @[src/main/scala/fpga/Core.scala 1575:33]
          ex2_reg_reminder <= _GEN_552;
        end
      end
    end
    ex2_reg_quotient <= _GEN_645[31:0]; // @[src/main/scala/fpga/Core.scala 1551:{37,37}]
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"ic_reg_addr_out: %x, ic_data_out: %x\n",{ic_reg_addr_out,1'h0},ic_data_out); // @[src/main/scala/fpga/Core.scala 603:9]
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
            ,if1_is_jump); // @[src/main/scala/fpga/Core.scala 604:9]
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
          $fwrite(32'h80000002,"if2_pc           : 0x%x\n",_T_31); // @[src/main/scala/fpga/Core.scala 1938:9]
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
          $fwrite(32'h80000002,"if2_is_valid_inst: 0x%x\n",if2_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1939:9]
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
          $fwrite(32'h80000002,"if2_inst         : 0x%x\n",if2_inst); // @[src/main/scala/fpga/Core.scala 1940:9]
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
          $fwrite(32'h80000002,"ic_bp_taken      : 0x%x\n",ic_bp_taken); // @[src/main/scala/fpga/Core.scala 1941:9]
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
          $fwrite(32'h80000002,"ic_bp_taken_pc   : 0x%x\n",{ic_bp_taken_pc,1'h0}); // @[src/main/scala/fpga/Core.scala 1942:9]
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
          $fwrite(32'h80000002,"ic_bp_cnt        : 0x%x\n",ic_bp_cnt); // @[src/main/scala/fpga/Core.scala 1943:9]
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
          $fwrite(32'h80000002,"id_reg_pc        : 0x%x\n",_id_op1_data_T_1); // @[src/main/scala/fpga/Core.scala 1944:9]
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
          $fwrite(32'h80000002,"id_reg_inst      : 0x%x\n",id_reg_inst); // @[src/main/scala/fpga/Core.scala 1945:9]
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
          $fwrite(32'h80000002,"id_stall         : 0x%x\n",id_stall); // @[src/main/scala/fpga/Core.scala 1946:9]
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
          $fwrite(32'h80000002,"id_inst          : 0x%x\n",id_inst); // @[src/main/scala/fpga/Core.scala 1947:9]
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
          $fwrite(32'h80000002,"id_reg_bp_taken  : 0x%x\n",id_reg_bp_taken); // @[src/main/scala/fpga/Core.scala 1951:9]
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
          $fwrite(32'h80000002,"id_reg_is_bp_fail: 0x%x\n",id_reg_is_bp_fail); // @[src/main/scala/fpga/Core.scala 1952:9]
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
          $fwrite(32'h80000002,"rrd_reg_pc       : 0x%x\n",{rrd_reg_pc,1'h0}); // @[src/main/scala/fpga/Core.scala 1953:9]
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
          $fwrite(32'h80000002,"rrd_reg_is_valid_: 0x%x\n",rrd_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1954:9]
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
          $fwrite(32'h80000002,"rrd_stall        : 0x%x\n",rrd_stall); // @[src/main/scala/fpga/Core.scala 1955:9]
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
          $fwrite(32'h80000002,"rrd_op1_data     : 0x%x\n",rrd_op1_data); // @[src/main/scala/fpga/Core.scala 1958:9]
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
          $fwrite(32'h80000002,"rrd_op2_data     : 0x%x\n",rrd_op2_data); // @[src/main/scala/fpga/Core.scala 1959:9]
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
          $fwrite(32'h80000002,"rrd_op3_data     : 0x%x\n",rrd_op3_data); // @[src/main/scala/fpga/Core.scala 1960:9]
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
          $fwrite(32'h80000002,"rrd_reg_op1_sel  : 0x%x\n",rrd_reg_op1_sel); // @[src/main/scala/fpga/Core.scala 1961:9]
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
          $fwrite(32'h80000002,"rrd_reg_rs1_addr : 0x%x\n",rrd_reg_rs1_addr); // @[src/main/scala/fpga/Core.scala 1963:9]
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
          $fwrite(32'h80000002,"ex1_fw_data      : 0x%x\n",ex1_alu_out); // @[src/main/scala/fpga/Core.scala 1964:9]
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
          $fwrite(32'h80000002,"ex1_reg_pc       : 0x%x\n",{ex1_reg_pc,1'h0}); // @[src/main/scala/fpga/Core.scala 1965:9]
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
          $fwrite(32'h80000002,"ex1_reg_is_valid_: 0x%x\n",ex1_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1966:9]
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
          $fwrite(32'h80000002,"ex1_reg_op1_data : 0x%x\n",ex1_reg_op1_data); // @[src/main/scala/fpga/Core.scala 1967:9]
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
          $fwrite(32'h80000002,"ex1_reg_op2_data : 0x%x\n",ex1_reg_op2_data); // @[src/main/scala/fpga/Core.scala 1968:9]
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
          $fwrite(32'h80000002,"ex1_alu_out      : 0x%x\n",ex1_alu_out); // @[src/main/scala/fpga/Core.scala 1969:9]
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
          $fwrite(32'h80000002,"ex1_reg_exe_fun  : 0x%x\n",ex1_reg_exe_fun); // @[src/main/scala/fpga/Core.scala 1970:9]
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
          $fwrite(32'h80000002,"ex1_reg_wb_sel   : 0x%x\n",ex1_reg_wb_sel); // @[src/main/scala/fpga/Core.scala 1971:9]
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
          $fwrite(32'h80000002,"ex1_reg_wb_addr  : 0x%x\n",ex1_reg_wb_addr); // @[src/main/scala/fpga/Core.scala 1972:9]
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
          $fwrite(32'h80000002,"ex1_reg_bp_taken : 0x%x\n",ex1_reg_bp_taken); // @[src/main/scala/fpga/Core.scala 1973:9]
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
          $fwrite(32'h80000002,"ex1_reg_bp_taken_: 0x%x\n",{ex1_reg_bp_taken_pc,1'h0}); // @[src/main/scala/fpga/Core.scala 1974:9]
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
          $fwrite(32'h80000002,"ex1_is_br        : 0x%d\n",ex1_is_br); // @[src/main/scala/fpga/Core.scala 1975:9]
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
          $fwrite(32'h80000002,"ex1_reg_bp_cnt   : 0x%d\n",ex1_reg_bp_cnt); // @[src/main/scala/fpga/Core.scala 1976:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_br    : 0x%d\n",ex2_reg_is_br); // @[src/main/scala/fpga/Core.scala 1977:9]
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
          $fwrite(32'h80000002,"ex2_reg_br_pc  : 0x%x\n",{ex2_reg_br_pc,1'h0}); // @[src/main/scala/fpga/Core.scala 1978:9]
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
          $fwrite(32'h80000002,"ex2_reg_pc       : 0x%x\n",_io_debug_signal_ex2_reg_pc_T); // @[src/main/scala/fpga/Core.scala 1979:9]
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
          $fwrite(32'h80000002,"ex2_reg_is_valid_: 0x%x\n",ex2_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1980:9]
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
          $fwrite(32'h80000002,"ex2_stall        : 0x%x\n",ex2_stall); // @[src/main/scala/fpga/Core.scala 1981:9]
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
          $fwrite(32'h80000002,"ex2_wb_data      : 0x%x\n",ex2_wb_data); // @[src/main/scala/fpga/Core.scala 1982:9]
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
          $fwrite(32'h80000002,"ex2_alu_muldiv_ou: 0x%x\n",ex2_alu_muldiv_out); // @[src/main/scala/fpga/Core.scala 1983:9]
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
          $fwrite(32'h80000002,"ex2_reg_wb_addr  : 0x%x\n",ex2_reg_wb_addr); // @[src/main/scala/fpga/Core.scala 1984:9]
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
          $fwrite(32'h80000002,"mem1_reg_wdata    : 0x%x\n",mem1_reg_wdata); // @[src/main/scala/fpga/Core.scala 1986:9]
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
          $fwrite(32'h80000002,"mem1_mem_stall   : 0x%x\n",mem1_mem_stall); // @[src/main/scala/fpga/Core.scala 1987:9]
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
          $fwrite(32'h80000002,"mem1_dram_stall  : 0x%x\n",mem1_dram_stall); // @[src/main/scala/fpga/Core.scala 1988:9]
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
          $fwrite(32'h80000002,"mem1_reg_unaligne: 0x%x\n",mem1_reg_unaligned); // @[src/main/scala/fpga/Core.scala 1989:9]
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
          $fwrite(32'h80000002,"mem1_is_valid_ins: 0x%x\n",mem1_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1990:9]
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
          $fwrite(32'h80000002,"mem2_mem_stall   : 0x%x\n",1'h0); // @[src/main/scala/fpga/Core.scala 1991:9]
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
          $fwrite(32'h80000002,"mem2_dram_stall  : 0x%x\n",mem2_dram_stall); // @[src/main/scala/fpga/Core.scala 1992:9]
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
          $fwrite(32'h80000002,"mem2_reg_is_valid: 0x%x\n",mem2_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 1995:9]
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
          $fwrite(32'h80000002,"mem2_reg_is_mem_l: 0x%x\n",mem2_reg_is_mem_load); // @[src/main/scala/fpga/Core.scala 1996:9]
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
          $fwrite(32'h80000002,"mem2_reg_is_dram_: 0x%x\n",mem2_reg_is_dram_load); // @[src/main/scala/fpga/Core.scala 1997:9]
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
          $fwrite(32'h80000002,"mem2_reg_unaligne: 0x%x\n",mem2_reg_unaligned); // @[src/main/scala/fpga/Core.scala 1998:9]
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
          $fwrite(32'h80000002,"mem2_is_aligned_l: 0x%x\n",mem2_is_aligned_lw); // @[src/main/scala/fpga/Core.scala 1999:9]
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
          $fwrite(32'h80000002,"mem3_reg_dmem_rda: 0x%x\n",mem3_reg_dmem_rdata); // @[src/main/scala/fpga/Core.scala 2000:9]
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
          $fwrite(32'h80000002,"mem3_wb_data_load: 0x%x\n",mem3_wb_data_load); // @[src/main/scala/fpga/Core.scala 2001:9]
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
          $fwrite(32'h80000002,"mem3_reg_unaligne: 0x%x\n",mem3_reg_unaligned); // @[src/main/scala/fpga/Core.scala 2002:9]
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
          $fwrite(32'h80000002,"mem3_reg_is_align: 0x%x\n",mem3_reg_is_aligned_lw); // @[src/main/scala/fpga/Core.scala 2003:9]
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
          $fwrite(32'h80000002,"mem3_reg_is_valid: 0x%x\n",mem3_reg_is_valid_inst); // @[src/main/scala/fpga/Core.scala 2004:9]
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
          $fwrite(32'h80000002,"csr_is_meintr    : %d\n",csr_is_meintr); // @[src/main/scala/fpga/Core.scala 2006:9]
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
          $fwrite(32'h80000002,"csr_is_mtintr    : %d\n",csr_is_mtintr); // @[src/main/scala/fpga/Core.scala 2007:9]
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
          $fwrite(32'h80000002,"csr_is_trap      : %d\n",csr_is_trap); // @[src/main/scala/fpga/Core.scala 2008:9]
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
          $fwrite(32'h80000002,"csr_is_br        : %d\n",csr_is_br); // @[src/main/scala/fpga/Core.scala 2010:9]
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
          $fwrite(32'h80000002,"instret          : %d\n",instret); // @[src/main/scala/fpga/Core.scala 2013:9]
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
          $fwrite(32'h80000002,"cycle_counter    : %d\n",io_debug_signal_cycle_counter); // @[src/main/scala/fpga/Core.scala 2016:9]
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
          $fwrite(32'h80000002,"---------\n"); // @[src/main/scala/fpga/Core.scala 2017:9]
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
  id_reg_inst = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  id_reg_bp_taken = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  id_reg_pc = _RAND_13[30:0];
  _RAND_14 = {1{`RANDOM}};
  id_reg_bp_taken_pc = _RAND_14[30:0];
  _RAND_15 = {1{`RANDOM}};
  id_reg_bp_cnt = _RAND_15[1:0];
  _RAND_16 = {1{`RANDOM}};
  id_reg_stall = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  rrd_reg_pc = _RAND_17[30:0];
  _RAND_18 = {1{`RANDOM}};
  rrd_reg_wb_addr = _RAND_18[4:0];
  _RAND_19 = {1{`RANDOM}};
  rrd_reg_op1_sel = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  rrd_reg_op2_sel = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  rrd_reg_op3_sel = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  rrd_reg_rs1_addr = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  rrd_reg_rs2_addr = _RAND_23[4:0];
  _RAND_24 = {1{`RANDOM}};
  rrd_reg_rs3_addr = _RAND_24[4:0];
  _RAND_25 = {1{`RANDOM}};
  rrd_reg_op1_data = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  rrd_reg_op2_data = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  rrd_reg_exe_fun = _RAND_27[3:0];
  _RAND_28 = {1{`RANDOM}};
  rrd_reg_rf_wen = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  rrd_reg_wb_sel = _RAND_29[2:0];
  _RAND_30 = {1{`RANDOM}};
  rrd_reg_csr_addr = _RAND_30[11:0];
  _RAND_31 = {1{`RANDOM}};
  rrd_reg_csr_cmd = _RAND_31[1:0];
  _RAND_32 = {1{`RANDOM}};
  rrd_reg_imm_b_sext = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  rrd_reg_mem_w = _RAND_33[2:0];
  _RAND_34 = {1{`RANDOM}};
  rrd_reg_is_br = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  rrd_reg_is_j = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  rrd_reg_bp_taken = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  rrd_reg_bp_taken_pc = _RAND_37[30:0];
  _RAND_38 = {1{`RANDOM}};
  rrd_reg_bp_cnt = _RAND_38[1:0];
  _RAND_39 = {1{`RANDOM}};
  rrd_reg_is_half = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  rrd_reg_is_valid_inst = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  rrd_reg_is_trap = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  rrd_reg_mcause = _RAND_42[31:0];
  _RAND_43 = {1{`RANDOM}};
  ex1_reg_pc = _RAND_43[30:0];
  _RAND_44 = {1{`RANDOM}};
  ex1_reg_wb_addr = _RAND_44[4:0];
  _RAND_45 = {1{`RANDOM}};
  ex1_reg_op1_data = _RAND_45[31:0];
  _RAND_46 = {1{`RANDOM}};
  ex1_reg_op2_data = _RAND_46[31:0];
  _RAND_47 = {1{`RANDOM}};
  ex1_reg_op3_data = _RAND_47[31:0];
  _RAND_48 = {1{`RANDOM}};
  ex1_reg_exe_fun = _RAND_48[3:0];
  _RAND_49 = {1{`RANDOM}};
  ex1_reg_rf_wen = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  ex1_reg_wb_sel = _RAND_50[2:0];
  _RAND_51 = {1{`RANDOM}};
  ex1_reg_csr_addr = _RAND_51[11:0];
  _RAND_52 = {1{`RANDOM}};
  ex1_reg_csr_cmd = _RAND_52[1:0];
  _RAND_53 = {1{`RANDOM}};
  ex1_reg_mem_w = _RAND_53[2:0];
  _RAND_54 = {1{`RANDOM}};
  ex1_reg_is_j = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  ex1_reg_bp_taken = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  ex1_reg_bp_taken_pc = _RAND_56[30:0];
  _RAND_57 = {1{`RANDOM}};
  ex1_reg_bp_cnt = _RAND_57[1:0];
  _RAND_58 = {1{`RANDOM}};
  ex1_reg_is_half = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  ex1_reg_is_valid_inst = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  ex1_reg_is_trap = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  ex1_reg_is_mret = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  ex1_reg_mcause = _RAND_62[31:0];
  _RAND_63 = {1{`RANDOM}};
  ex1_reg_mem_use_reg = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  ex1_reg_inst2_use_reg = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  ex1_reg_inst3_use_reg = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  ex1_reg_is_br = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  ex1_reg_direct_jbr_pc = _RAND_67[30:0];
  _RAND_68 = {1{`RANDOM}};
  ex2_reg_pc = _RAND_68[30:0];
  _RAND_69 = {1{`RANDOM}};
  ex2_reg_wb_addr = _RAND_69[4:0];
  _RAND_70 = {2{`RANDOM}};
  ex2_reg_mullu = _RAND_70[47:0];
  _RAND_71 = {1{`RANDOM}};
  ex2_reg_mulls = _RAND_71[31:0];
  _RAND_72 = {2{`RANDOM}};
  ex2_reg_mulhuu = _RAND_72[47:0];
  _RAND_73 = {2{`RANDOM}};
  ex2_reg_mulhss = _RAND_73[47:0];
  _RAND_74 = {2{`RANDOM}};
  ex2_reg_mulhsu = _RAND_74[47:0];
  _RAND_75 = {1{`RANDOM}};
  ex2_reg_exe_fun = _RAND_75[3:0];
  _RAND_76 = {1{`RANDOM}};
  ex2_reg_rf_wen = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  ex2_reg_wb_sel = _RAND_77[2:0];
  _RAND_78 = {1{`RANDOM}};
  ex2_reg_alu_out = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  ex2_reg_pc_bit_out = _RAND_79[31:0];
  _RAND_80 = {1{`RANDOM}};
  ex2_reg_is_valid_inst = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  ex2_reg_divrem = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  ex2_reg_sign_op1 = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  ex2_reg_sign_op12 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  ex2_reg_zero_op2 = _RAND_84[0:0];
  _RAND_85 = {2{`RANDOM}};
  ex2_reg_init_dividend = _RAND_85[36:0];
  _RAND_86 = {1{`RANDOM}};
  ex2_reg_init_divisor = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  ex2_reg_orig_dividend = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  ex2_reg_inst3_use_reg = _RAND_88[0:0];
  _RAND_89 = {1{`RANDOM}};
  ex2_reg_no_mem = _RAND_89[0:0];
  _RAND_90 = {1{`RANDOM}};
  mem1_reg_mem_wstrb = _RAND_90[6:0];
  _RAND_91 = {1{`RANDOM}};
  mem1_reg_wdata = _RAND_91[31:0];
  _RAND_92 = {1{`RANDOM}};
  mem1_reg_mem_w = _RAND_92[2:0];
  _RAND_93 = {1{`RANDOM}};
  mem1_reg_is_mem_load = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  mem1_reg_is_mem_store = _RAND_94[0:0];
  _RAND_95 = {1{`RANDOM}};
  mem1_reg_is_dram_load = _RAND_95[0:0];
  _RAND_96 = {1{`RANDOM}};
  mem1_reg_is_dram_store = _RAND_96[0:0];
  _RAND_97 = {1{`RANDOM}};
  mem1_reg_is_dram_fence = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  mem1_reg_is_valid_inst = _RAND_98[0:0];
  _RAND_99 = {1{`RANDOM}};
  mem1_reg_unaligned = _RAND_99[0:0];
  _RAND_100 = {1{`RANDOM}};
  mem2_reg_wb_byte_offset = _RAND_100[1:0];
  _RAND_101 = {1{`RANDOM}};
  mem2_reg_mem_w = _RAND_101[2:0];
  _RAND_102 = {1{`RANDOM}};
  mem2_reg_wb_addr = _RAND_102[31:0];
  _RAND_103 = {1{`RANDOM}};
  mem2_reg_is_valid_load = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  mem2_reg_is_valid_inst = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  mem2_reg_is_mem_load = _RAND_105[0:0];
  _RAND_106 = {1{`RANDOM}};
  mem2_reg_is_dram_load = _RAND_106[0:0];
  _RAND_107 = {1{`RANDOM}};
  mem2_reg_unaligned = _RAND_107[0:0];
  _RAND_108 = {1{`RANDOM}};
  mem3_reg_wb_byte_offset = _RAND_108[1:0];
  _RAND_109 = {1{`RANDOM}};
  mem3_reg_mem_w = _RAND_109[2:0];
  _RAND_110 = {1{`RANDOM}};
  mem3_reg_dmem_rdata = _RAND_110[31:0];
  _RAND_111 = {1{`RANDOM}};
  mem3_reg_rdata_high = _RAND_111[23:0];
  _RAND_112 = {1{`RANDOM}};
  mem3_reg_wb_addr = _RAND_112[31:0];
  _RAND_113 = {1{`RANDOM}};
  mem3_reg_is_valid_load = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  mem3_reg_is_valid_inst = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  mem3_reg_unaligned = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  mem3_reg_is_aligned_lw = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  id_reg_is_bp_fail = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  id_reg_br_pc = _RAND_118[30:0];
  _RAND_119 = {1{`RANDOM}};
  ex1_reg_fw_en = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  ex2_reg_fw_en = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  mem3_reg_fw_en = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  ex2_reg_div_stall = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  ex2_reg_divrem_state = _RAND_123[2:0];
  _RAND_124 = {1{`RANDOM}};
  ex2_reg_is_br = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  ex2_reg_br_pc = _RAND_125[30:0];
  _RAND_126 = {1{`RANDOM}};
  ex2_reg_is_retired = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  mem3_reg_is_retired = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  ic_reg_read_rdy = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  ic_reg_half_rdy = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  ic_reg_imem_addr = _RAND_130[30:0];
  _RAND_131 = {1{`RANDOM}};
  ic_reg_addr_out = _RAND_131[30:0];
  _RAND_132 = {1{`RANDOM}};
  ic_reg_inst = _RAND_132[31:0];
  _RAND_133 = {1{`RANDOM}};
  ic_reg_inst_addr = _RAND_133[30:0];
  _RAND_134 = {1{`RANDOM}};
  ic_reg_inst2 = _RAND_134[31:0];
  _RAND_135 = {1{`RANDOM}};
  ic_state = _RAND_135[2:0];
  _RAND_136 = {1{`RANDOM}};
  ic_reg_bp_next_taken0 = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc0 = _RAND_137[30:0];
  _RAND_138 = {1{`RANDOM}};
  ic_reg_bp_next_cnt0 = _RAND_138[1:0];
  _RAND_139 = {1{`RANDOM}};
  ic_reg_bp_next_taken1 = _RAND_139[0:0];
  _RAND_140 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc1 = _RAND_140[30:0];
  _RAND_141 = {1{`RANDOM}};
  ic_reg_bp_next_cnt1 = _RAND_141[1:0];
  _RAND_142 = {1{`RANDOM}};
  ic_reg_bp_next_taken2 = _RAND_142[0:0];
  _RAND_143 = {1{`RANDOM}};
  ic_reg_bp_next_taken_pc2 = _RAND_143[30:0];
  _RAND_144 = {1{`RANDOM}};
  ic_reg_bp_next_cnt2 = _RAND_144[1:0];
  _RAND_145 = {1{`RANDOM}};
  id_reg_pc_delay = _RAND_145[30:0];
  _RAND_146 = {1{`RANDOM}};
  id_reg_wb_addr_delay = _RAND_146[4:0];
  _RAND_147 = {1{`RANDOM}};
  id_reg_op1_sel_delay = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  id_reg_op2_sel_delay = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  id_reg_op3_sel_delay = _RAND_149[1:0];
  _RAND_150 = {1{`RANDOM}};
  id_reg_rs1_addr_delay = _RAND_150[4:0];
  _RAND_151 = {1{`RANDOM}};
  id_reg_rs2_addr_delay = _RAND_151[4:0];
  _RAND_152 = {1{`RANDOM}};
  id_reg_rs3_addr_delay = _RAND_152[4:0];
  _RAND_153 = {1{`RANDOM}};
  id_reg_op1_data_delay = _RAND_153[31:0];
  _RAND_154 = {1{`RANDOM}};
  id_reg_op2_data_delay = _RAND_154[31:0];
  _RAND_155 = {1{`RANDOM}};
  id_reg_exe_fun_delay = _RAND_155[3:0];
  _RAND_156 = {1{`RANDOM}};
  id_reg_rf_wen_delay = _RAND_156[0:0];
  _RAND_157 = {1{`RANDOM}};
  id_reg_wb_sel_delay = _RAND_157[2:0];
  _RAND_158 = {1{`RANDOM}};
  id_reg_csr_addr_delay = _RAND_158[11:0];
  _RAND_159 = {1{`RANDOM}};
  id_reg_csr_cmd_delay = _RAND_159[1:0];
  _RAND_160 = {1{`RANDOM}};
  id_reg_imm_b_sext_delay = _RAND_160[31:0];
  _RAND_161 = {1{`RANDOM}};
  id_reg_mem_w_delay = _RAND_161[2:0];
  _RAND_162 = {1{`RANDOM}};
  id_reg_is_br_delay = _RAND_162[0:0];
  _RAND_163 = {1{`RANDOM}};
  id_reg_is_j_delay = _RAND_163[0:0];
  _RAND_164 = {1{`RANDOM}};
  id_reg_bp_taken_delay = _RAND_164[0:0];
  _RAND_165 = {1{`RANDOM}};
  id_reg_bp_taken_pc_delay = _RAND_165[30:0];
  _RAND_166 = {1{`RANDOM}};
  id_reg_bp_cnt_delay = _RAND_166[1:0];
  _RAND_167 = {1{`RANDOM}};
  id_reg_is_half_delay = _RAND_167[0:0];
  _RAND_168 = {1{`RANDOM}};
  id_reg_is_valid_inst_delay = _RAND_168[0:0];
  _RAND_169 = {1{`RANDOM}};
  id_reg_is_trap_delay = _RAND_169[0:0];
  _RAND_170 = {1{`RANDOM}};
  id_reg_mcause_delay = _RAND_170[31:0];
  _RAND_171 = {1{`RANDOM}};
  csr_reg_is_meintr = _RAND_171[0:0];
  _RAND_172 = {1{`RANDOM}};
  csr_reg_is_mtintr = _RAND_172[0:0];
  _RAND_173 = {2{`RANDOM}};
  ex2_reg_dividend = _RAND_173[36:0];
  _RAND_174 = {2{`RANDOM}};
  ex2_reg_divisor = _RAND_174[35:0];
  _RAND_175 = {2{`RANDOM}};
  ex2_reg_p_divisor = _RAND_175[63:0];
  _RAND_176 = {1{`RANDOM}};
  ex2_reg_divrem_count = _RAND_176[4:0];
  _RAND_177 = {1{`RANDOM}};
  ex2_reg_rem_shift = _RAND_177[4:0];
  _RAND_178 = {1{`RANDOM}};
  ex2_reg_extra_shift = _RAND_178[0:0];
  _RAND_179 = {1{`RANDOM}};
  ex2_reg_d = _RAND_179[2:0];
  _RAND_180 = {1{`RANDOM}};
  ex2_reg_reminder = _RAND_180[31:0];
  _RAND_181 = {1{`RANDOM}};
  ex2_reg_quotient = _RAND_181[31:0];
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
  input          io_imem_en, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [31:0]  io_imem_addr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [31:0]  io_imem_inst, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_imem_valid, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_cache_iinvalidate, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_ibusy, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [31:0]  io_cache_raddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [31:0]  io_cache_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_cache_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_rvalid, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_rready, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [31:0]  io_cache_waddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_cache_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_wready, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [3:0]   io_cache_wstrb, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [31:0]  io_cache_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_dramPort_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_dramPort_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [27:0]  io_dramPort_addr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [127:0] io_dramPort_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_dramPort_init_calib_complete, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [127:0] io_dramPort_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_dramPort_rdata_valid, // @[src/main/scala/fpga/Memory.scala 167:14]
  input          io_dramPort_busy, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_array1_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_array1_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [31:0]  io_cache_array1_we, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [6:0]   io_cache_array1_raddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [6:0]   io_cache_array1_waddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [255:0] io_cache_array1_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [255:0] io_cache_array1_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_array2_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_cache_array2_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [31:0]  io_cache_array2_we, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [6:0]   io_cache_array2_raddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [6:0]   io_cache_array2_waddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [255:0] io_cache_array2_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [255:0] io_cache_array2_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [9:0]   io_icache_raddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [31:0]  io_icache_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [6:0]   io_icache_waddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [255:0] io_icache_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_valid_ren, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_valid_wen, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_valid_invalidate, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [5:0]   io_icache_valid_addr, // @[src/main/scala/fpga/Memory.scala 167:14]
  output         io_icache_valid_iaddr, // @[src/main/scala/fpga/Memory.scala 167:14]
  input  [1:0]   io_icache_valid_rdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [1:0]   io_icache_valid_wdata, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [2:0]   io_icache_state, // @[src/main/scala/fpga/Memory.scala 167:14]
  output [2:0]   io_dram_state // @[src/main/scala/fpga/Memory.scala 167:14]
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
  reg [255:0] _RAND_22;
  reg [31:0] _RAND_23;
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
`endif // RANDOMIZE_REG_INIT
  reg [15:0] i_tag_array_0 [0:127]; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_en; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [6:0] i_tag_array_0_MPORT_addr; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [15:0] i_tag_array_0_MPORT_data; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_1_en; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [6:0] i_tag_array_0_MPORT_1_addr; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [15:0] i_tag_array_0_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_3_en; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [6:0] i_tag_array_0_MPORT_3_addr; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [15:0] i_tag_array_0_MPORT_3_data; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [15:0] i_tag_array_0_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [6:0] i_tag_array_0_MPORT_2_addr; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_2_mask; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_2_en; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [15:0] i_tag_array_0_MPORT_4_data; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire [6:0] i_tag_array_0_MPORT_4_addr; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_4_mask; // @[src/main/scala/fpga/Memory.scala 289:24]
  wire  i_tag_array_0_MPORT_4_en; // @[src/main/scala/fpga/Memory.scala 289:24]
  reg [15:0] tag_array_0 [0:127]; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_5_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_5_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_5_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_6_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_6_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_6_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_7_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_7_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_7_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_8_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_8_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_8_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_11_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_11_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_11_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_12_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_12_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_12_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_13_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_13_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_13_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_13_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_15_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_15_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_15_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_15_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_17_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_17_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_17_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_17_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_0_MPORT_19_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_0_MPORT_19_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_19_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_0_MPORT_19_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  reg [15:0] tag_array_1 [0:127]; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_5_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_5_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_5_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_6_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_6_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_6_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_7_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_7_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_7_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_8_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_8_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_8_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_11_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_11_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_11_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_12_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_12_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_12_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_13_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_13_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_13_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_13_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_15_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_15_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_15_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_15_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_17_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_17_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_17_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_17_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [15:0] tag_array_1_MPORT_19_data; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire [6:0] tag_array_1_MPORT_19_addr; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_19_mask; // @[src/main/scala/fpga/Memory.scala 501:22]
  wire  tag_array_1_MPORT_19_en; // @[src/main/scala/fpga/Memory.scala 501:22]
  reg  lru_array_way_hot [0:127]; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_1_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_1_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_2_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_reg_lru_MPORT_2_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_9_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_9_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_9_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_10_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_10_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_10_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_14_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_14_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_14_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_16_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_16_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_16_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_18_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_18_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_18_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_way_hot_MPORT_20_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_20_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_way_hot_MPORT_20_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  reg  lru_array_dirty1 [0:127]; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_1_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_1_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_2_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_reg_lru_MPORT_2_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_9_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_9_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_9_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_10_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_10_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_10_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_14_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_14_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_14_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_16_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_16_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_16_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_18_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_18_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_18_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty1_MPORT_20_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_20_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty1_MPORT_20_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  reg  lru_array_dirty2 [0:127]; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_1_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_1_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_2_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_reg_lru_MPORT_2_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_9_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_9_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_9_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_10_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_10_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_10_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_14_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_14_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_14_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_16_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_16_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_16_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_18_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_18_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_18_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire [6:0] lru_array_dirty2_MPORT_20_addr; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_20_mask; // @[src/main/scala/fpga/Memory.scala 502:22]
  wire  lru_array_dirty2_MPORT_20_en; // @[src/main/scala/fpga/Memory.scala 502:22]
  reg [2:0] reg_dram_state; // @[src/main/scala/fpga/Memory.scala 191:31]
  reg [26:0] reg_dram_addr; // @[src/main/scala/fpga/Memory.scala 192:31]
  reg [127:0] reg_dram_wdata; // @[src/main/scala/fpga/Memory.scala 193:31]
  reg [127:0] reg_dram_rdata; // @[src/main/scala/fpga/Memory.scala 194:31]
  reg  reg_dram_di; // @[src/main/scala/fpga/Memory.scala 195:28]
  wire  _T_3 = ~io_dramPort_busy; // @[src/main/scala/fpga/Memory.scala 211:48]
  reg [2:0] icache_state; // @[src/main/scala/fpga/Memory.scala 291:29]
  wire  _T_25 = 3'h0 == icache_state; // @[src/main/scala/fpga/Memory.scala 326:25]
  reg [2:0] dcache_state; // @[src/main/scala/fpga/Memory.scala 504:29]
  wire  _T_83 = 3'h0 == dcache_state; // @[src/main/scala/fpga/Memory.scala 571:25]
  reg [15:0] reg_tag_0; // @[src/main/scala/fpga/Memory.scala 505:24]
  reg [15:0] reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 511:29]
  wire  _T_88 = reg_tag_0 == reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 607:24]
  reg [15:0] reg_tag_1; // @[src/main/scala/fpga/Memory.scala 505:24]
  wire  _T_89 = reg_tag_1 == reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 610:30]
  wire [1:0] _GEN_472 = reg_tag_1 == reg_req_addr_tag ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Memory.scala 610:52 612:29 614:29]
  wire [1:0] _GEN_474 = reg_tag_0 == reg_req_addr_tag ? 2'h1 : _GEN_472; // @[src/main/scala/fpga/Memory.scala 607:46 609:29]
  wire [1:0] _GEN_1075 = 3'h1 == dcache_state ? _GEN_474 : 2'h0; // @[src/main/scala/fpga/Memory.scala 540:23 571:25]
  wire [1:0] dcache_snoop_status = 3'h0 == dcache_state ? 2'h0 : _GEN_1075; // @[src/main/scala/fpga/Memory.scala 540:23 571:25]
  wire  _T_47 = 2'h0 == dcache_snoop_status; // @[src/main/scala/fpga/Memory.scala 395:36]
  wire  _GEN_24 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 204:20 211:67 212:21]
  wire  dram_i_busy = 3'h0 == reg_dram_state ? _GEN_24 : 1'h1; // @[src/main/scala/fpga/Memory.scala 204:20 209:27]
  wire  _T_54 = ~dram_i_busy; // @[src/main/scala/fpga/Memory.scala 416:17]
  reg [15:0] i_reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 294:31]
  reg [6:0] i_reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 294:31]
  wire [22:0] _dram_i_addr_T_1 = {i_reg_req_addr_tag,i_reg_req_addr_index}; // @[src/main/scala/fpga/Memory.scala 418:31]
  wire [22:0] _GEN_290 = 3'h4 == icache_state ? _dram_i_addr_T_1 : _dram_i_addr_T_1; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [26:0] dram_i_addr = {{4'd0}, _GEN_290}; // @[src/main/scala/fpga/Memory.scala 182:26]
  wire [30:0] _io_dramPort_addr_T = {dram_i_addr,4'h0}; // @[src/main/scala/fpga/Memory.scala 215:34]
  wire  _T_95 = _T_88 | _T_89; // @[src/main/scala/fpga/Memory.scala 626:45]
  reg  reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 510:24]
  reg  reg_lru_dirty1; // @[src/main/scala/fpga/Memory.scala 510:24]
  reg  reg_lru_dirty2; // @[src/main/scala/fpga/Memory.scala 510:24]
  wire  _T_101 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2; // @[src/main/scala/fpga/Memory.scala 667:63]
  reg [6:0] reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 511:29]
  wire [22:0] _dram_d_addr_T_1 = {reg_tag_0,reg_req_addr_index}; // @[src/main/scala/fpga/Memory.scala 675:29]
  wire [22:0] _dram_d_addr_T_3 = {reg_tag_1,reg_req_addr_index}; // @[src/main/scala/fpga/Memory.scala 678:29]
  wire [22:0] _GEN_490 = reg_lru_way_hot ? _dram_d_addr_T_1 : _dram_d_addr_T_3; // @[src/main/scala/fpga/Memory.scala 674:40 675:23 678:23]
  wire [22:0] _dram_d_addr_T_5 = {reg_req_addr_tag,reg_req_addr_index}; // @[src/main/scala/fpga/Memory.scala 688:27]
  wire [22:0] _GEN_494 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_490 :
    _dram_d_addr_T_5; // @[src/main/scala/fpga/Memory.scala 667:111 688:21]
  wire  _GEN_155 = 2'h1 == dcache_snoop_status ? 1'h0 : 2'h2 == dcache_snoop_status & _T_54; // @[src/main/scala/fpga/Memory.scala 311:14 395:36]
  wire  _GEN_173 = 2'h0 == dcache_snoop_status ? 1'h0 : _GEN_155; // @[src/main/scala/fpga/Memory.scala 311:14 395:36]
  wire  _GEN_255 = 3'h5 == icache_state ? 1'h0 : 3'h3 == icache_state & _T_54; // @[src/main/scala/fpga/Memory.scala 311:14 326:25]
  wire  _GEN_289 = 3'h4 == icache_state ? _GEN_173 : _GEN_255; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_346 = 3'h2 == icache_state ? 1'h0 : _GEN_289; // @[src/main/scala/fpga/Memory.scala 311:14 326:25]
  wire  _GEN_391 = 3'h1 == icache_state ? 1'h0 : _GEN_346; // @[src/main/scala/fpga/Memory.scala 311:14 326:25]
  wire  dram_i_ren = 3'h0 == icache_state ? 1'h0 : _GEN_391; // @[src/main/scala/fpga/Memory.scala 311:14 326:25]
  wire  _GEN_30 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? dram_i_ren : 1'h1; // @[src/main/scala/fpga/Memory.scala 205:20 211:67]
  wire  dram_d_busy = 3'h0 == reg_dram_state ? _GEN_30 : 1'h1; // @[src/main/scala/fpga/Memory.scala 205:20 209:27]
  wire  _T_138 = ~dram_d_busy; // @[src/main/scala/fpga/Memory.scala 795:13]
  wire [22:0] _GEN_858 = 3'h3 == dcache_state ? _GEN_494 : _dram_d_addr_T_5; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [22:0] _GEN_902 = 3'h4 == dcache_state ? _GEN_494 : _GEN_858; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [22:0] _GEN_1008 = 3'h2 == dcache_state ? _GEN_494 : _GEN_902; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [26:0] dram_d_addr = {{4'd0}, _GEN_1008}; // @[src/main/scala/fpga/Memory.scala 187:26]
  wire [30:0] _io_dramPort_addr_T_1 = {dram_d_addr,4'h0}; // @[src/main/scala/fpga/Memory.scala 223:36]
  wire [255:0] cold_line = reg_lru_way_hot ? io_cache_array1_rdata : io_cache_array2_rdata; // @[src/main/scala/fpga/Memory.scala 568:19]
  reg [255:0] reg_line; // @[src/main/scala/fpga/Memory.scala 508:25]
  wire [255:0] _GEN_899 = 3'h4 == dcache_state ? reg_line : cold_line; // @[src/main/scala/fpga/Memory.scala 571:25 693:20]
  wire [255:0] dram_d_wdata = 3'h2 == dcache_state ? cold_line : _GEN_899; // @[src/main/scala/fpga/Memory.scala 571:25 625:20]
  wire  _GEN_489 = dram_d_busy ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 523:14 668:28 671:22]
  wire  _GEN_495 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? 1'h0 : _GEN_489; // @[src/main/scala/fpga/Memory.scala 667:111 522:14]
  wire  _GEN_520 = _T_88 | _T_89 ? 1'h0 : _GEN_495; // @[src/main/scala/fpga/Memory.scala 522:14 626:81]
  wire  _GEN_529 = _T_101 ? 1'h0 : _T_138; // @[src/main/scala/fpga/Memory.scala 694:105 522:14]
  wire  _GEN_765 = 3'h5 == dcache_state & _T_138; // @[src/main/scala/fpga/Memory.scala 522:14 571:25]
  wire  _GEN_859 = 3'h3 == dcache_state ? _GEN_520 : _GEN_765; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_903 = 3'h4 == dcache_state ? _GEN_529 : _GEN_859; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_1009 = 3'h2 == dcache_state ? _GEN_520 : _GEN_903; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_1102 = 3'h1 == dcache_state ? 1'h0 : _GEN_1009; // @[src/main/scala/fpga/Memory.scala 522:14 571:25]
  wire  dram_d_ren = 3'h0 == dcache_state ? 1'h0 : _GEN_1102; // @[src/main/scala/fpga/Memory.scala 522:14 571:25]
  wire [26:0] _GEN_2 = dram_d_ren ? dram_d_addr : reg_dram_addr; // @[src/main/scala/fpga/Memory.scala 230:35 233:27 192:31]
  wire  _GEN_3 = dram_d_ren ? 1'h0 : reg_dram_di; // @[src/main/scala/fpga/Memory.scala 230:35 234:25 195:28]
  wire [2:0] _GEN_4 = dram_d_ren ? 3'h2 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 230:35 235:28 191:31]
  wire  _GEN_493 = (reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2) & _GEN_489; // @[src/main/scala/fpga/Memory.scala 667:111 523:14]
  wire  _GEN_518 = _T_88 | _T_89 ? 1'h0 : _GEN_493; // @[src/main/scala/fpga/Memory.scala 523:14 626:81]
  wire  _GEN_526 = _T_101 & _T_138; // @[src/main/scala/fpga/Memory.scala 694:105 523:14]
  wire  _GEN_857 = 3'h3 == dcache_state & _GEN_518; // @[src/main/scala/fpga/Memory.scala 523:14 571:25]
  wire  _GEN_900 = 3'h4 == dcache_state ? _GEN_526 : _GEN_857; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_1007 = 3'h2 == dcache_state ? _GEN_518 : _GEN_900; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_1100 = 3'h1 == dcache_state ? 1'h0 : _GEN_1007; // @[src/main/scala/fpga/Memory.scala 523:14 571:25]
  wire  dram_d_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1100; // @[src/main/scala/fpga/Memory.scala 523:14 571:25]
  wire [30:0] _GEN_6 = dram_d_wen ? _io_dramPort_addr_T_1 : _io_dramPort_addr_T_1; // @[src/main/scala/fpga/Memory.scala 221:29 223:30]
  wire [26:0] _GEN_9 = dram_d_wen ? dram_d_addr : _GEN_2; // @[src/main/scala/fpga/Memory.scala 221:29 226:27]
  wire [127:0] _GEN_10 = dram_d_wen ? dram_d_wdata[255:128] : reg_dram_wdata; // @[src/main/scala/fpga/Memory.scala 221:29 227:28 193:31]
  wire  _GEN_11 = dram_d_wen ? 1'h0 : _GEN_3; // @[src/main/scala/fpga/Memory.scala 221:29 228:25]
  wire [2:0] _GEN_12 = dram_d_wen ? 3'h1 : _GEN_4; // @[src/main/scala/fpga/Memory.scala 221:29 229:28]
  wire  _GEN_13 = dram_d_wen ? 1'h0 : dram_d_ren; // @[src/main/scala/fpga/Memory.scala 197:19 221:29]
  wire  _GEN_14 = dram_i_ren | _GEN_13; // @[src/main/scala/fpga/Memory.scala 213:27 214:27]
  wire [30:0] _GEN_15 = dram_i_ren ? _io_dramPort_addr_T : _GEN_6; // @[src/main/scala/fpga/Memory.scala 213:27 215:28]
  wire  _GEN_17 = dram_i_ren | _GEN_11; // @[src/main/scala/fpga/Memory.scala 213:27 217:23]
  wire  _GEN_20 = dram_i_ren ? 1'h0 : dram_d_wen; // @[src/main/scala/fpga/Memory.scala 198:19 213:27]
  wire  _GEN_25 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_14; // @[src/main/scala/fpga/Memory.scala 197:19 211:67]
  wire  _GEN_28 = io_dramPort_init_calib_complete & ~io_dramPort_busy ? _GEN_17 : reg_dram_di; // @[src/main/scala/fpga/Memory.scala 195:28 211:67]
  wire  _GEN_31 = io_dramPort_init_calib_complete & ~io_dramPort_busy & _GEN_20; // @[src/main/scala/fpga/Memory.scala 198:19 211:67]
  wire [30:0] _io_dramPort_addr_T_3 = {reg_dram_addr,4'h8}; // @[src/main/scala/fpga/Memory.scala 243:32]
  wire [127:0] _GEN_40 = io_dramPort_rdata_valid ? io_dramPort_rdata : reg_dram_rdata; // @[src/main/scala/fpga/Memory.scala 253:40 254:26 194:31]
  wire [2:0] _GEN_41 = io_dramPort_rdata_valid ? 3'h5 : 3'h4; // @[src/main/scala/fpga/Memory.scala 253:40 255:26 257:26]
  wire [2:0] _GEN_42 = io_dramPort_rdata_valid ? 3'h3 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 259:44 261:24 191:31]
  wire [2:0] _GEN_46 = _T_3 ? _GEN_41 : _GEN_42; // @[src/main/scala/fpga/Memory.scala 250:32]
  wire [2:0] _GEN_49 = _T_3 ? 3'h5 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 265:32 268:24 191:31]
  wire [2:0] _GEN_50 = io_dramPort_rdata_valid ? 3'h5 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 272:38 274:24 191:31]
  wire [255:0] dram_rdata = {io_dramPort_rdata,reg_dram_rdata}; // @[src/main/scala/fpga/Memory.scala 281:26]
  wire  _GEN_52 = io_dramPort_rdata_valid & reg_dram_di; // @[src/main/scala/fpga/Memory.scala 207:22 278:38 282:28]
  wire  _GEN_53 = io_dramPort_rdata_valid & ~reg_dram_di; // @[src/main/scala/fpga/Memory.scala 208:22 278:38 283:28]
  wire [2:0] _GEN_54 = io_dramPort_rdata_valid ? 3'h0 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 278:38 284:24 191:31]
  wire [2:0] _GEN_58 = 3'h5 == reg_dram_state ? _GEN_54 : reg_dram_state; // @[src/main/scala/fpga/Memory.scala 209:27 191:31]
  wire [127:0] _GEN_59 = 3'h4 == reg_dram_state ? _GEN_40 : reg_dram_rdata; // @[src/main/scala/fpga/Memory.scala 209:27 194:31]
  wire [2:0] _GEN_60 = 3'h4 == reg_dram_state ? _GEN_50 : _GEN_58; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire  _GEN_62 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_52; // @[src/main/scala/fpga/Memory.scala 207:22 209:27]
  wire  _GEN_63 = 3'h4 == reg_dram_state ? 1'h0 : 3'h5 == reg_dram_state & _GEN_53; // @[src/main/scala/fpga/Memory.scala 208:22 209:27]
  wire  _GEN_64 = 3'h3 == reg_dram_state & _T_3; // @[src/main/scala/fpga/Memory.scala 197:19 209:27]
  wire [2:0] _GEN_66 = 3'h3 == reg_dram_state ? _GEN_49 : _GEN_60; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire [127:0] _GEN_67 = 3'h3 == reg_dram_state ? reg_dram_rdata : _GEN_59; // @[src/main/scala/fpga/Memory.scala 209:27 194:31]
  wire  _GEN_69 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_62; // @[src/main/scala/fpga/Memory.scala 207:22 209:27]
  wire  _GEN_70 = 3'h3 == reg_dram_state ? 1'h0 : _GEN_63; // @[src/main/scala/fpga/Memory.scala 208:22 209:27]
  wire  _GEN_71 = 3'h2 == reg_dram_state ? _T_3 : _GEN_64; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire [30:0] _GEN_72 = 3'h2 == reg_dram_state ? _io_dramPort_addr_T_3 : _io_dramPort_addr_T_3; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire  _GEN_76 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_69; // @[src/main/scala/fpga/Memory.scala 207:22 209:27]
  wire  _GEN_77 = 3'h2 == reg_dram_state ? 1'h0 : _GEN_70; // @[src/main/scala/fpga/Memory.scala 208:22 209:27]
  wire  _GEN_78 = 3'h1 == reg_dram_state & _T_3; // @[src/main/scala/fpga/Memory.scala 198:19 209:27]
  wire [30:0] _GEN_79 = 3'h1 == reg_dram_state ? _io_dramPort_addr_T_3 : _GEN_72; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire  _GEN_83 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_71; // @[src/main/scala/fpga/Memory.scala 197:19 209:27]
  wire  _GEN_86 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_76; // @[src/main/scala/fpga/Memory.scala 207:22 209:27]
  wire  _GEN_87 = 3'h1 == reg_dram_state ? 1'h0 : _GEN_77; // @[src/main/scala/fpga/Memory.scala 208:22 209:27]
  wire [30:0] _GEN_90 = 3'h0 == reg_dram_state ? _GEN_15 : _GEN_79; // @[src/main/scala/fpga/Memory.scala 209:27]
  wire  _GEN_92 = 3'h0 == reg_dram_state ? _GEN_28 : reg_dram_di; // @[src/main/scala/fpga/Memory.scala 209:27 195:28]
  wire  dram_i_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_86; // @[src/main/scala/fpga/Memory.scala 207:22 209:27]
  wire  dram_d_rdata_valid = 3'h0 == reg_dram_state ? 1'h0 : _GEN_87; // @[src/main/scala/fpga/Memory.scala 208:22 209:27]
  reg [15:0] i_reg_tag_0; // @[src/main/scala/fpga/Memory.scala 292:26]
  reg [255:0] i_reg_line; // @[src/main/scala/fpga/Memory.scala 293:27]
  reg [4:0] i_reg_req_addr_line_off; // @[src/main/scala/fpga/Memory.scala 294:31]
  reg [15:0] i_reg_next_addr_tag; // @[src/main/scala/fpga/Memory.scala 295:32]
  reg [6:0] i_reg_next_addr_index; // @[src/main/scala/fpga/Memory.scala 295:32]
  reg [4:0] i_reg_next_addr_line_off; // @[src/main/scala/fpga/Memory.scala 295:32]
  reg [1:0] i_reg_valid_rdata; // @[src/main/scala/fpga/Memory.scala 296:34]
  reg [22:0] i_reg_cur_tag_index; // @[src/main/scala/fpga/Memory.scala 297:36]
  reg  i_reg_addr_match; // @[src/main/scala/fpga/Memory.scala 298:33]
  wire [9:0] _io_icache_raddr_T_1 = {io_imem_addr[11:5],io_imem_addr[4:2]}; // @[src/main/scala/fpga/Memory.scala 339:31]
  wire [22:0] _T_26 = {io_imem_addr[27:12],io_imem_addr[11:5]}; // @[src/main/scala/fpga/Memory.scala 342:42]
  wire [1:0] _GEN_103 = i_reg_cur_tag_index == _T_26 ? 2'h2 : 2'h1; // @[src/main/scala/fpga/Memory.scala 342:74 343:24 345:24]
  wire  _GEN_117 = io_cache_iinvalidate ? 1'h0 : io_imem_en; // @[src/main/scala/fpga/Memory.scala 289:24 331:35]
  wire  _i_reg_addr_match_T_3 = i_reg_req_addr_index == io_imem_addr[11:5]; // @[src/main/scala/fpga/Memory.scala 354:32]
  wire  _i_reg_addr_match_T_4 = i_reg_req_addr_tag == io_imem_addr[27:12] & _i_reg_addr_match_T_3; // @[src/main/scala/fpga/Memory.scala 353:111]
  wire  _i_reg_addr_match_T_7 = i_reg_req_addr_line_off[4:2] == io_imem_addr[4:2]; // @[src/main/scala/fpga/Memory.scala 355:57]
  wire  _i_reg_addr_match_T_8 = _i_reg_addr_match_T_4 & _i_reg_addr_match_T_7; // @[src/main/scala/fpga/Memory.scala 354:54]
  wire [1:0] _T_32 = io_icache_valid_rdata >> i_reg_req_addr_index[0]; // @[src/main/scala/fpga/Memory.scala 356:36]
  wire  _T_36 = _T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 356:105]
  wire [9:0] _io_icache_raddr_T_3 = {i_reg_req_addr_index,i_reg_req_addr_line_off[4:2]}; // @[src/main/scala/fpga/Memory.scala 358:31]
  wire [15:0] _GEN_128 = io_imem_en ? i_tag_array_0_MPORT_1_data : i_reg_tag_0; // @[src/main/scala/fpga/Memory.scala 379:31 380:19 292:26]
  wire [1:0] _GEN_131 = io_imem_en ? _GEN_103 : 2'h0; // @[src/main/scala/fpga/Memory.scala 379:31 391:22]
  wire [2:0] _GEN_132 = io_cache_iinvalidate ? 3'h7 : {{1'd0}, _GEN_131}; // @[src/main/scala/fpga/Memory.scala 374:35 378:22]
  wire [15:0] _GEN_134 = io_cache_iinvalidate ? i_reg_tag_0 : _GEN_128; // @[src/main/scala/fpga/Memory.scala 292:26 374:35]
  wire [27:0] _dcache_snoop_addr_T = {i_reg_req_addr_tag,i_reg_req_addr_index,i_reg_req_addr_line_off}; // @[src/main/scala/fpga/Memory.scala 398:47]
  wire [4:0] dcache_snoop_addr_line_off = _dcache_snoop_addr_T[4:0]; // @[src/main/scala/fpga/Memory.scala 398:62]
  wire [6:0] dcache_snoop_addr_index = _dcache_snoop_addr_T[11:5]; // @[src/main/scala/fpga/Memory.scala 398:62]
  wire [15:0] dcache_snoop_addr_tag = _dcache_snoop_addr_T[27:12]; // @[src/main/scala/fpga/Memory.scala 398:62]
  wire [1:0] _icache_valid_wdata_T_1 = 2'h1 << i_reg_req_addr_index[0]; // @[src/main/scala/fpga/Memory.scala 409:62]
  wire [1:0] icache_valid_wdata = i_reg_valid_rdata | _icache_valid_wdata_T_1; // @[src/main/scala/fpga/Memory.scala 409:55]
  wire [2:0] _GEN_139 = ~dram_i_busy ? 3'h6 : 3'h3; // @[src/main/scala/fpga/Memory.scala 416:31 419:26 421:26]
  wire [2:0] _GEN_142 = 2'h2 == dcache_snoop_status ? _GEN_139 : icache_state; // @[src/main/scala/fpga/Memory.scala 291:29 395:36]
  wire [255:0] dcache_snoop_line = reg_tag_0 == reg_req_addr_tag ? io_cache_array1_rdata : io_cache_array2_rdata; // @[src/main/scala/fpga/Memory.scala 607:46 608:27]
  wire [255:0] _GEN_143 = 2'h1 == dcache_snoop_status ? dcache_snoop_line : i_reg_line; // @[src/main/scala/fpga/Memory.scala 395:36 401:22 293:27]
  wire [22:0] _GEN_152 = 2'h1 == dcache_snoop_status ? _dram_i_addr_T_1 : i_reg_cur_tag_index; // @[src/main/scala/fpga/Memory.scala 395:36 411:31 297:36]
  wire [1:0] _GEN_153 = 2'h1 == dcache_snoop_status ? icache_valid_wdata : i_reg_valid_rdata; // @[src/main/scala/fpga/Memory.scala 395:36 412:29 296:34]
  wire [2:0] _GEN_154 = 2'h1 == dcache_snoop_status ? 3'h5 : _GEN_142; // @[src/main/scala/fpga/Memory.scala 395:36 413:24]
  wire [255:0] _GEN_161 = 2'h0 == dcache_snoop_status ? i_reg_line : _GEN_143; // @[src/main/scala/fpga/Memory.scala 293:27 395:36]
  wire  _GEN_164 = 2'h0 == dcache_snoop_status ? 1'h0 : 2'h1 == dcache_snoop_status; // @[src/main/scala/fpga/Memory.scala 289:24 395:36]
  wire [22:0] _GEN_170 = 2'h0 == dcache_snoop_status ? i_reg_cur_tag_index : _GEN_152; // @[src/main/scala/fpga/Memory.scala 297:36 395:36]
  wire [1:0] _GEN_171 = 2'h0 == dcache_snoop_status ? i_reg_valid_rdata : _GEN_153; // @[src/main/scala/fpga/Memory.scala 296:34 395:36]
  wire [2:0] _GEN_172 = 2'h0 == dcache_snoop_status ? icache_state : _GEN_154; // @[src/main/scala/fpga/Memory.scala 291:29 395:36]
  wire [7:0] _io_imem_inst_T_1 = {i_reg_next_addr_line_off[4:2],5'h0}; // @[src/main/scala/fpga/Memory.scala 427:41]
  wire [255:0] _io_imem_inst_T_2 = i_reg_line >> _io_imem_inst_T_1; // @[src/main/scala/fpga/Memory.scala 427:35]
  wire  _T_61 = i_reg_req_addr_index == i_reg_next_addr_index; // @[src/main/scala/fpga/Memory.scala 429:32]
  wire  _T_62 = i_reg_req_addr_tag == i_reg_next_addr_tag & _T_61; // @[src/main/scala/fpga/Memory.scala 428:100]
  wire [15:0] _GEN_178 = io_imem_en ? i_tag_array_0_MPORT_3_data : i_reg_tag_0; // @[src/main/scala/fpga/Memory.scala 435:25 436:19 292:26]
  wire [2:0] _GEN_184 = _T_54 ? 3'h6 : icache_state; // @[src/main/scala/fpga/Memory.scala 451:27 454:22 291:29]
  wire [255:0] _io_imem_inst_T_6 = dram_rdata >> _io_imem_inst_T_1; // @[src/main/scala/fpga/Memory.scala 460:31]
  wire [31:0] _GEN_186 = dram_i_rdata_valid ? _io_imem_inst_T_6[31:0] : 32'hdeadbeef; // @[src/main/scala/fpga/Memory.scala 305:16 458:33 460:22]
  wire  _GEN_187 = dram_i_rdata_valid & _T_62; // @[src/main/scala/fpga/Memory.scala 306:17 458:33]
  wire [22:0] _GEN_196 = dram_i_rdata_valid ? _dram_i_addr_T_1 : i_reg_cur_tag_index; // @[src/main/scala/fpga/Memory.scala 458:33 474:29 297:36]
  wire [1:0] _GEN_197 = dram_i_rdata_valid ? icache_valid_wdata : i_reg_valid_rdata; // @[src/main/scala/fpga/Memory.scala 458:33 475:27 296:34]
  wire [2:0] _GEN_198 = dram_i_rdata_valid ? 3'h0 : icache_state; // @[src/main/scala/fpga/Memory.scala 458:33 476:22 291:29]
  wire [22:0] _GEN_203 = 3'h7 == icache_state ? 23'h7fffff : i_reg_cur_tag_index; // @[src/main/scala/fpga/Memory.scala 326:25 484:27 297:36]
  wire [2:0] _GEN_204 = 3'h7 == icache_state ? 3'h0 : icache_state; // @[src/main/scala/fpga/Memory.scala 326:25 496:22 291:29]
  wire [31:0] _GEN_205 = 3'h6 == icache_state ? _GEN_186 : 32'hdeadbeef; // @[src/main/scala/fpga/Memory.scala 305:16 326:25]
  wire [22:0] _GEN_215 = 3'h6 == icache_state ? _GEN_196 : _GEN_203; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [1:0] _GEN_216 = 3'h6 == icache_state ? _GEN_197 : i_reg_valid_rdata; // @[src/main/scala/fpga/Memory.scala 326:25 296:34]
  wire [2:0] _GEN_217 = 3'h6 == icache_state ? _GEN_198 : _GEN_204; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_219 = 3'h6 == icache_state ? 1'h0 : 3'h7 == icache_state; // @[src/main/scala/fpga/Memory.scala 326:25 320:30]
  wire [2:0] _GEN_224 = 3'h3 == icache_state ? _GEN_184 : _GEN_217; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [31:0] _GEN_225 = 3'h3 == icache_state ? 32'hdeadbeef : _GEN_205; // @[src/main/scala/fpga/Memory.scala 305:16 326:25]
  wire  _GEN_226 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & _GEN_187; // @[src/main/scala/fpga/Memory.scala 306:17 326:25]
  wire  _GEN_229 = 3'h3 == icache_state ? 1'h0 : 3'h6 == icache_state & dram_i_rdata_valid; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire [22:0] _GEN_235 = 3'h3 == icache_state ? i_reg_cur_tag_index : _GEN_215; // @[src/main/scala/fpga/Memory.scala 326:25 297:36]
  wire [1:0] _GEN_236 = 3'h3 == icache_state ? i_reg_valid_rdata : _GEN_216; // @[src/main/scala/fpga/Memory.scala 326:25 296:34]
  wire  _GEN_238 = 3'h3 == icache_state ? 1'h0 : _GEN_219; // @[src/main/scala/fpga/Memory.scala 326:25 320:30]
  wire [31:0] _GEN_241 = 3'h5 == icache_state ? _io_imem_inst_T_2[31:0] : _GEN_225; // @[src/main/scala/fpga/Memory.scala 326:25 427:20]
  wire  _GEN_242 = 3'h5 == icache_state ? _T_62 : _GEN_226; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [15:0] _GEN_243 = 3'h5 == icache_state ? io_imem_addr[27:12] : i_reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 326:25 433:22 294:31]
  wire [6:0] _GEN_244 = 3'h5 == icache_state ? io_imem_addr[11:5] : i_reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 326:25 433:22 294:31]
  wire [4:0] _GEN_245 = 3'h5 == icache_state ? io_imem_addr[4:0] : i_reg_req_addr_line_off; // @[src/main/scala/fpga/Memory.scala 326:25 433:22 294:31]
  wire  _GEN_246 = 3'h5 == icache_state | i_reg_addr_match; // @[src/main/scala/fpga/Memory.scala 326:25 434:24 298:33]
  wire [15:0] _GEN_250 = 3'h5 == icache_state ? _GEN_178 : i_reg_tag_0; // @[src/main/scala/fpga/Memory.scala 326:25 292:26]
  wire  _GEN_252 = 3'h5 == icache_state ? io_imem_en : _GEN_229; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [5:0] _GEN_253 = 3'h5 == icache_state ? io_imem_addr[11:6] : i_reg_req_addr_index[6:1]; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [2:0] _GEN_254 = 3'h5 == icache_state ? {{1'd0}, _GEN_131} : _GEN_224; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_259 = 3'h5 == icache_state ? 1'h0 : _GEN_229; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire [22:0] _GEN_264 = 3'h5 == icache_state ? i_reg_cur_tag_index : _GEN_235; // @[src/main/scala/fpga/Memory.scala 326:25 297:36]
  wire [1:0] _GEN_265 = 3'h5 == icache_state ? i_reg_valid_rdata : _GEN_236; // @[src/main/scala/fpga/Memory.scala 326:25 296:34]
  wire  _GEN_267 = 3'h5 == icache_state ? 1'h0 : _GEN_238; // @[src/main/scala/fpga/Memory.scala 326:25 320:30]
  wire [255:0] _GEN_274 = 3'h4 == icache_state ? _GEN_161 : i_reg_line; // @[src/main/scala/fpga/Memory.scala 326:25 293:27]
  wire  _GEN_280 = 3'h4 == icache_state ? _GEN_164 : _GEN_259; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_283 = 3'h4 == icache_state ? _GEN_164 : _GEN_252; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [5:0] _GEN_284 = 3'h4 == icache_state ? i_reg_req_addr_index[6:1] : _GEN_253; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [22:0] _GEN_286 = 3'h4 == icache_state ? _GEN_170 : _GEN_264; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [1:0] _GEN_287 = 3'h4 == icache_state ? _GEN_171 : _GEN_265; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [2:0] _GEN_288 = 3'h4 == icache_state ? _GEN_172 : _GEN_254; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [31:0] _GEN_291 = 3'h4 == icache_state ? 32'hdeadbeef : _GEN_241; // @[src/main/scala/fpga/Memory.scala 305:16 326:25]
  wire  _GEN_292 = 3'h4 == icache_state ? 1'h0 : _GEN_242; // @[src/main/scala/fpga/Memory.scala 306:17 326:25]
  wire [15:0] _GEN_293 = 3'h4 == icache_state ? i_reg_req_addr_tag : _GEN_243; // @[src/main/scala/fpga/Memory.scala 326:25 294:31]
  wire [6:0] _GEN_294 = 3'h4 == icache_state ? i_reg_req_addr_index : _GEN_244; // @[src/main/scala/fpga/Memory.scala 326:25 294:31]
  wire [4:0] _GEN_295 = 3'h4 == icache_state ? i_reg_req_addr_line_off : _GEN_245; // @[src/main/scala/fpga/Memory.scala 326:25 294:31]
  wire  _GEN_296 = 3'h4 == icache_state ? i_reg_addr_match : _GEN_246; // @[src/main/scala/fpga/Memory.scala 326:25 298:33]
  wire  _GEN_299 = 3'h4 == icache_state ? 1'h0 : 3'h5 == icache_state & io_imem_en; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire [15:0] _GEN_300 = 3'h4 == icache_state ? i_reg_tag_0 : _GEN_250; // @[src/main/scala/fpga/Memory.scala 326:25 292:26]
  wire  _GEN_304 = 3'h4 == icache_state ? 1'h0 : _GEN_259; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_308 = 3'h4 == icache_state ? 1'h0 : _GEN_267; // @[src/main/scala/fpga/Memory.scala 326:25 320:30]
  wire [31:0] _GEN_311 = 3'h2 == icache_state ? io_icache_rdata : _GEN_291; // @[src/main/scala/fpga/Memory.scala 326:25 366:20]
  wire  _GEN_312 = 3'h2 == icache_state ? i_reg_addr_match : _GEN_292; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_313 = 3'h2 == icache_state ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 326:25 370:22]
  wire  _GEN_317 = 3'h2 == icache_state | _GEN_296; // @[src/main/scala/fpga/Memory.scala 326:25 373:24]
  wire  _GEN_318 = 3'h2 == icache_state ? io_cache_iinvalidate : _GEN_308; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_326 = 3'h2 == icache_state ? _GEN_117 : _GEN_299; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [9:0] _GEN_327 = 3'h2 == icache_state ? _io_icache_raddr_T_1 : _io_icache_raddr_T_1; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_328 = 3'h2 == icache_state ? _GEN_117 : _GEN_283; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [5:0] _GEN_329 = 3'h2 == icache_state ? io_imem_addr[11:6] : _GEN_284; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire  _GEN_330 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _T_47; // @[src/main/scala/fpga/Memory.scala 309:19 326:25]
  wire  _GEN_337 = 3'h2 == icache_state ? 1'h0 : 3'h4 == icache_state & _GEN_164; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_340 = 3'h2 == icache_state ? 1'h0 : _GEN_280; // @[src/main/scala/fpga/Memory.scala 314:17 326:25]
  wire  _GEN_350 = 3'h2 == icache_state ? 1'h0 : _GEN_299; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_353 = 3'h2 == icache_state ? 1'h0 : _GEN_304; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_357 = 3'h1 == icache_state ? _i_reg_addr_match_T_8 : _GEN_317; // @[src/main/scala/fpga/Memory.scala 326:25 353:24]
  wire  _GEN_358 = 3'h1 == icache_state ? _T_36 : _GEN_326; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [9:0] _GEN_359 = 3'h1 == icache_state ? _io_icache_raddr_T_3 : _GEN_327; // @[src/main/scala/fpga/Memory.scala 326:25]
  wire [31:0] _GEN_362 = 3'h1 == icache_state ? 32'hdeadbeef : _GEN_311; // @[src/main/scala/fpga/Memory.scala 305:16 326:25]
  wire  _GEN_363 = 3'h1 == icache_state ? 1'h0 : _GEN_312; // @[src/main/scala/fpga/Memory.scala 306:17 326:25]
  wire  _GEN_364 = 3'h1 == icache_state | _GEN_313; // @[src/main/scala/fpga/Memory.scala 307:18 326:25]
  wire  _GEN_368 = 3'h1 == icache_state ? 1'h0 : _GEN_318; // @[src/main/scala/fpga/Memory.scala 326:25 320:30]
  wire  _GEN_373 = 3'h1 == icache_state ? 1'h0 : 3'h2 == icache_state & _GEN_117; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_375 = 3'h1 == icache_state ? 1'h0 : _GEN_328; // @[src/main/scala/fpga/Memory.scala 318:23 326:25]
  wire  _GEN_377 = 3'h1 == icache_state ? 1'h0 : _GEN_330; // @[src/main/scala/fpga/Memory.scala 309:19 326:25]
  wire  _GEN_384 = 3'h1 == icache_state ? 1'h0 : _GEN_337; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_387 = 3'h1 == icache_state ? 1'h0 : _GEN_340; // @[src/main/scala/fpga/Memory.scala 314:17 326:25]
  wire  _GEN_395 = 3'h1 == icache_state ? 1'h0 : _GEN_350; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_398 = 3'h1 == icache_state ? 1'h0 : _GEN_353; // @[src/main/scala/fpga/Memory.scala 289:24 326:25]
  wire  _GEN_417 = 3'h0 == icache_state | _GEN_357; // @[src/main/scala/fpga/Memory.scala 326:25 348:24]
  wire  dcache_snoop_en = 3'h0 == icache_state ? 1'h0 : _GEN_377; // @[src/main/scala/fpga/Memory.scala 309:19 326:25]
  reg [4:0] reg_req_addr_line_off; // @[src/main/scala/fpga/Memory.scala 511:29]
  reg [31:0] reg_wdata; // @[src/main/scala/fpga/Memory.scala 512:26]
  reg [3:0] reg_wstrb; // @[src/main/scala/fpga/Memory.scala 513:26]
  reg  reg_ren; // @[src/main/scala/fpga/Memory.scala 514:24]
  wire [7:0] _reg_read_word_T_1 = {reg_req_addr_line_off[4:2],5'h0}; // @[src/main/scala/fpga/Memory.scala 564:35]
  wire [255:0] _reg_read_word_T_2 = io_cache_array1_rdata >> _reg_read_word_T_1; // @[src/main/scala/fpga/Memory.scala 564:29]
  wire [255:0] _reg_read_word_T_6 = io_cache_array2_rdata >> _reg_read_word_T_1; // @[src/main/scala/fpga/Memory.scala 566:29]
  wire [31:0] _GEN_449 = _T_88 ? _reg_read_word_T_2[31:0] : _reg_read_word_T_6[31:0]; // @[src/main/scala/fpga/Memory.scala 563:42 564:19 566:19]
  wire [31:0] _req_addr_T_9 = io_cache_ren ? io_cache_raddr : io_cache_waddr; // @[src/main/scala/fpga/Memory.scala 585:27]
  wire [4:0] req_addr_3_line_off = _req_addr_T_9[4:0]; // @[src/main/scala/fpga/Memory.scala 585:82]
  wire [6:0] req_addr_3_index = _req_addr_T_9[11:5]; // @[src/main/scala/fpga/Memory.scala 585:82]
  wire [15:0] req_addr_3_tag = _req_addr_T_9[27:12]; // @[src/main/scala/fpga/Memory.scala 585:82]
  wire [1:0] _GEN_450 = io_cache_ren ? 2'h2 : 2'h3; // @[src/main/scala/fpga/Memory.scala 598:31 599:26 601:26]
  wire [15:0] _GEN_452 = dcache_snoop_en ? dcache_snoop_addr_tag : req_addr_3_tag; // @[src/main/scala/fpga/Memory.scala 573:30 575:22 586:22]
  wire [6:0] _GEN_453 = dcache_snoop_en ? dcache_snoop_addr_index : req_addr_3_index; // @[src/main/scala/fpga/Memory.scala 573:30 575:22 586:22]
  wire [4:0] _GEN_454 = dcache_snoop_en ? dcache_snoop_addr_line_off : req_addr_3_line_off; // @[src/main/scala/fpga/Memory.scala 573:30 575:22 586:22]
  wire  _GEN_462 = dcache_snoop_en ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 518:19 573:30 583:25]
  wire [31:0] _GEN_463 = dcache_snoop_en ? reg_wdata : io_cache_wdata; // @[src/main/scala/fpga/Memory.scala 512:26 573:30 587:19]
  wire [3:0] _GEN_464 = dcache_snoop_en ? reg_wstrb : io_cache_wstrb; // @[src/main/scala/fpga/Memory.scala 513:26 573:30 588:19]
  wire  _GEN_465 = dcache_snoop_en ? reg_ren : io_cache_ren; // @[src/main/scala/fpga/Memory.scala 514:24 573:30 589:17]
  wire [1:0] _GEN_476 = io_cache_wen ? 2'h3 : 2'h0; // @[src/main/scala/fpga/Memory.scala 661:37 662:28 664:26]
  wire [1:0] _GEN_477 = io_cache_ren ? 2'h2 : _GEN_476; // @[src/main/scala/fpga/Memory.scala 659:31 660:28]
  wire [15:0] _GEN_481 = dcache_snoop_en ? tag_array_0_MPORT_7_data : tag_array_0_MPORT_8_data; // @[src/main/scala/fpga/Memory.scala 635:32 638:19 652:19]
  wire [15:0] _GEN_482 = dcache_snoop_en ? tag_array_1_MPORT_7_data : tag_array_1_MPORT_8_data; // @[src/main/scala/fpga/Memory.scala 635:32 638:19 652:19]
  wire [1:0] _GEN_483 = dcache_snoop_en ? 2'h1 : _GEN_477; // @[src/main/scala/fpga/Memory.scala 635:32 643:24]
  wire  _GEN_485 = dcache_snoop_en ? reg_lru_way_hot : lru_array_way_hot_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 510:24 635:32 653:19]
  wire  _GEN_486 = dcache_snoop_en ? reg_lru_dirty1 : lru_array_dirty1_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 510:24 635:32 653:19]
  wire  _GEN_487 = dcache_snoop_en ? reg_lru_dirty2 : lru_array_dirty2_reg_lru_MPORT_1_data; // @[src/main/scala/fpga/Memory.scala 510:24 635:32 653:19]
  wire [2:0] _GEN_488 = dram_d_busy ? 3'h4 : 3'h5; // @[src/main/scala/fpga/Memory.scala 668:28 669:24 672:24]
  wire [2:0] _GEN_491 = dram_d_busy ? 3'h4 : 3'h6; // @[src/main/scala/fpga/Memory.scala 682:28 683:24 686:24]
  wire [2:0] _GEN_492 = reg_lru_way_hot & reg_lru_dirty1 | ~reg_lru_way_hot & reg_lru_dirty2 ? _GEN_488 : _GEN_491; // @[src/main/scala/fpga/Memory.scala 667:111]
  wire [15:0] _GEN_498 = _T_88 | _T_89 ? _GEN_452 : reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 511:29 626:81]
  wire [6:0] _GEN_499 = _T_88 | _T_89 ? _GEN_453 : reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 511:29 626:81]
  wire [4:0] _GEN_500 = _T_88 | _T_89 ? _GEN_454 : reg_req_addr_line_off; // @[src/main/scala/fpga/Memory.scala 511:29 626:81]
  wire  _GEN_503 = (_T_88 | _T_89) & dcache_snoop_en; // @[src/main/scala/fpga/Memory.scala 501:22 626:81]
  wire [15:0] _GEN_504 = _T_88 | _T_89 ? _GEN_481 : reg_tag_0; // @[src/main/scala/fpga/Memory.scala 505:24 626:81]
  wire [15:0] _GEN_505 = _T_88 | _T_89 ? _GEN_482 : reg_tag_1; // @[src/main/scala/fpga/Memory.scala 505:24 626:81]
  wire [2:0] _GEN_508 = _T_88 | _T_89 ? {{1'd0}, _GEN_483} : _GEN_492; // @[src/main/scala/fpga/Memory.scala 626:81]
  wire  _GEN_509 = (_T_88 | _T_89) & _GEN_462; // @[src/main/scala/fpga/Memory.scala 518:19 626:81]
  wire [31:0] _GEN_510 = _T_88 | _T_89 ? _GEN_463 : reg_wdata; // @[src/main/scala/fpga/Memory.scala 512:26 626:81]
  wire [3:0] _GEN_511 = _T_88 | _T_89 ? _GEN_464 : reg_wstrb; // @[src/main/scala/fpga/Memory.scala 513:26 626:81]
  wire  _GEN_512 = _T_88 | _T_89 ? _GEN_465 : reg_ren; // @[src/main/scala/fpga/Memory.scala 514:24 626:81]
  wire  _GEN_515 = _T_88 | _T_89 ? _GEN_485 : reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 510:24 626:81]
  wire  _GEN_516 = _T_88 | _T_89 ? _GEN_486 : reg_lru_dirty1; // @[src/main/scala/fpga/Memory.scala 510:24 626:81]
  wire  _GEN_517 = _T_88 | _T_89 ? _GEN_487 : reg_lru_dirty2; // @[src/main/scala/fpga/Memory.scala 510:24 626:81]
  wire [2:0] _GEN_522 = _T_138 ? 3'h5 : dcache_state; // @[src/main/scala/fpga/Memory.scala 695:29 697:24 504:29]
  wire [2:0] _GEN_525 = _T_138 ? 3'h6 : dcache_state; // @[src/main/scala/fpga/Memory.scala 707:29 709:24 504:29]
  wire [2:0] _GEN_527 = _T_101 ? _GEN_522 : _GEN_525; // @[src/main/scala/fpga/Memory.scala 694:105]
  wire [4:0] _wstrb_T_1 = {reg_req_addr_line_off[4:2],2'h0}; // @[src/main/scala/fpga/Memory.scala 721:47]
  wire [31:0] _wstrb_T_3 = {28'h0,reg_wstrb}; // @[src/main/scala/fpga/Memory.scala 549:37]
  wire [62:0] _GEN_0 = {{31'd0}, _wstrb_T_3}; // @[src/main/scala/fpga/Memory.scala 552:30]
  wire [62:0] _wstrb_T_4 = _GEN_0 << _wstrb_T_1; // @[src/main/scala/fpga/Memory.scala 552:30]
  wire [31:0] wstrb = _wstrb_T_4[31:0]; // @[src/main/scala/fpga/Memory.scala 552:39]
  wire [255:0] _wdata_T_1 = {224'h0,reg_wdata}; // @[src/main/scala/fpga/Memory.scala 546:42]
  wire [510:0] _GEN_1 = {{255'd0}, _wdata_T_1}; // @[src/main/scala/fpga/Memory.scala 722:44]
  wire [510:0] _wdata_T_4 = _GEN_1 << _reg_read_word_T_1; // @[src/main/scala/fpga/Memory.scala 722:44]
  wire [255:0] wdata = _wdata_T_4[255:0]; // @[src/main/scala/fpga/Memory.scala 722:106]
  wire [2:0] _T_121 = {2'h1,reg_lru_dirty2}; // @[src/main/scala/fpga/Memory.scala 733:50]
  wire [2:0] _T_125 = {1'h1,reg_lru_dirty1,1'h1}; // @[src/main/scala/fpga/Memory.scala 736:50]
  wire  _GEN_537 = _T_88 ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 533:25 731:48 735:31]
  wire [15:0] _GEN_547 = dcache_snoop_en ? tag_array_0_MPORT_11_data : tag_array_0_MPORT_12_data; // @[src/main/scala/fpga/Memory.scala 738:32 741:19 755:19]
  wire [15:0] _GEN_548 = dcache_snoop_en ? tag_array_1_MPORT_11_data : tag_array_1_MPORT_12_data; // @[src/main/scala/fpga/Memory.scala 738:32 741:19 755:19]
  wire  _GEN_550 = dcache_snoop_en ? reg_lru_way_hot : lru_array_way_hot_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 510:24 738:32 756:19]
  wire  _GEN_551 = dcache_snoop_en ? reg_lru_dirty1 : lru_array_dirty1_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 510:24 738:32 756:19]
  wire  _GEN_552 = dcache_snoop_en ? reg_lru_dirty2 : lru_array_dirty2_reg_lru_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 510:24 738:32 756:19]
  wire  _GEN_558 = _T_95 & _T_88; // @[src/main/scala/fpga/Memory.scala 527:25 730:81]
  wire  _GEN_565 = _T_95 & _GEN_537; // @[src/main/scala/fpga/Memory.scala 533:25 730:81]
  wire [15:0] _GEN_578 = _T_95 ? _GEN_547 : reg_tag_0; // @[src/main/scala/fpga/Memory.scala 505:24 730:81]
  wire [15:0] _GEN_579 = _T_95 ? _GEN_548 : reg_tag_1; // @[src/main/scala/fpga/Memory.scala 505:24 730:81]
  wire  _GEN_589 = _T_95 ? _GEN_550 : reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 510:24 730:81]
  wire  _GEN_590 = _T_95 ? _GEN_551 : reg_lru_dirty1; // @[src/main/scala/fpga/Memory.scala 510:24 730:81]
  wire  _GEN_591 = _T_95 ? _GEN_552 : reg_lru_dirty2; // @[src/main/scala/fpga/Memory.scala 510:24 730:81]
  wire [255:0] _io_cache_rdata_T_10 = dram_rdata >> _reg_read_word_T_1; // @[src/main/scala/fpga/Memory.scala 803:31]
  wire  _T_143 = reg_lru_way_hot & reg_ren; // @[src/main/scala/fpga/Memory.scala 817:41]
  wire [2:0] _T_144 = {2'h0,reg_lru_dirty2}; // @[src/main/scala/fpga/Memory.scala 820:52]
  wire [2:0] _T_148 = {1'h1,reg_lru_dirty1,1'h0}; // @[src/main/scala/fpga/Memory.scala 824:52]
  wire  _GEN_610 = reg_lru_way_hot & reg_ren ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 501:22 817:53]
  wire [7:0] _io_cache_array1_wdata_T_3 = wstrb[0] ? _wdata_T_4[7:0] : dram_rdata[7:0]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_7 = wstrb[1] ? _wdata_T_4[15:8] : dram_rdata[15:8]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_11 = wstrb[2] ? _wdata_T_4[23:16] : dram_rdata[23:16]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_15 = wstrb[3] ? _wdata_T_4[31:24] : dram_rdata[31:24]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_19 = wstrb[4] ? _wdata_T_4[39:32] : dram_rdata[39:32]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_23 = wstrb[5] ? _wdata_T_4[47:40] : dram_rdata[47:40]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_27 = wstrb[6] ? _wdata_T_4[55:48] : dram_rdata[55:48]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_31 = wstrb[7] ? _wdata_T_4[63:56] : dram_rdata[63:56]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_35 = wstrb[8] ? _wdata_T_4[71:64] : dram_rdata[71:64]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_39 = wstrb[9] ? _wdata_T_4[79:72] : dram_rdata[79:72]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_43 = wstrb[10] ? _wdata_T_4[87:80] : dram_rdata[87:80]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_47 = wstrb[11] ? _wdata_T_4[95:88] : dram_rdata[95:88]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_51 = wstrb[12] ? _wdata_T_4[103:96] : dram_rdata[103:96]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_55 = wstrb[13] ? _wdata_T_4[111:104] : dram_rdata[111:104]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_59 = wstrb[14] ? _wdata_T_4[119:112] : dram_rdata[119:112]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_63 = wstrb[15] ? _wdata_T_4[127:120] : dram_rdata[127:120]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_67 = wstrb[16] ? _wdata_T_4[135:128] : dram_rdata[135:128]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_71 = wstrb[17] ? _wdata_T_4[143:136] : dram_rdata[143:136]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_75 = wstrb[18] ? _wdata_T_4[151:144] : dram_rdata[151:144]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_79 = wstrb[19] ? _wdata_T_4[159:152] : dram_rdata[159:152]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_83 = wstrb[20] ? _wdata_T_4[167:160] : dram_rdata[167:160]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_87 = wstrb[21] ? _wdata_T_4[175:168] : dram_rdata[175:168]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_91 = wstrb[22] ? _wdata_T_4[183:176] : dram_rdata[183:176]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_95 = wstrb[23] ? _wdata_T_4[191:184] : dram_rdata[191:184]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_99 = wstrb[24] ? _wdata_T_4[199:192] : dram_rdata[199:192]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_103 = wstrb[25] ? _wdata_T_4[207:200] : dram_rdata[207:200]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_107 = wstrb[26] ? _wdata_T_4[215:208] : dram_rdata[215:208]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_111 = wstrb[27] ? _wdata_T_4[223:216] : dram_rdata[223:216]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_115 = wstrb[28] ? _wdata_T_4[231:224] : dram_rdata[231:224]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_119 = wstrb[29] ? _wdata_T_4[239:232] : dram_rdata[239:232]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_123 = wstrb[30] ? _wdata_T_4[247:240] : dram_rdata[247:240]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [7:0] _io_cache_array1_wdata_T_127 = wstrb[31] ? _wdata_T_4[255:248] : dram_rdata[255:248]; // @[src/main/scala/fpga/Memory.scala 830:16]
  wire [63:0] io_cache_array1_wdata_lo_lo = {_io_cache_array1_wdata_T_31,_io_cache_array1_wdata_T_27,
    _io_cache_array1_wdata_T_23,_io_cache_array1_wdata_T_19,_io_cache_array1_wdata_T_15,_io_cache_array1_wdata_T_11,
    _io_cache_array1_wdata_T_7,_io_cache_array1_wdata_T_3}; // @[src/main/scala/fpga/Memory.scala 829:39]
  wire [127:0] io_cache_array1_wdata_lo = {_io_cache_array1_wdata_T_63,_io_cache_array1_wdata_T_59,
    _io_cache_array1_wdata_T_55,_io_cache_array1_wdata_T_51,_io_cache_array1_wdata_T_47,_io_cache_array1_wdata_T_43,
    _io_cache_array1_wdata_T_39,_io_cache_array1_wdata_T_35,io_cache_array1_wdata_lo_lo}; // @[src/main/scala/fpga/Memory.scala 829:39]
  wire [63:0] io_cache_array1_wdata_hi_lo = {_io_cache_array1_wdata_T_95,_io_cache_array1_wdata_T_91,
    _io_cache_array1_wdata_T_87,_io_cache_array1_wdata_T_83,_io_cache_array1_wdata_T_79,_io_cache_array1_wdata_T_75,
    _io_cache_array1_wdata_T_71,_io_cache_array1_wdata_T_67}; // @[src/main/scala/fpga/Memory.scala 829:39]
  wire [255:0] _io_cache_array1_wdata_T_128 = {_io_cache_array1_wdata_T_127,_io_cache_array1_wdata_T_123,
    _io_cache_array1_wdata_T_119,_io_cache_array1_wdata_T_115,_io_cache_array1_wdata_T_111,_io_cache_array1_wdata_T_107,
    _io_cache_array1_wdata_T_103,_io_cache_array1_wdata_T_99,io_cache_array1_wdata_hi_lo,io_cache_array1_wdata_lo}; // @[src/main/scala/fpga/Memory.scala 829:39]
  wire  _GEN_628 = reg_lru_way_hot ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Memory.scala 501:22 835:42]
  wire [255:0] _GEN_635 = reg_ren ? dram_rdata : _io_cache_array1_wdata_T_128; // @[src/main/scala/fpga/Memory.scala 814:24 815:33 829:33]
  wire  _GEN_639 = reg_ren & _T_143; // @[src/main/scala/fpga/Memory.scala 501:22 814:24]
  wire  _GEN_643 = reg_ren ? _T_143 : reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 814:24]
  wire  _GEN_649 = reg_ren & _GEN_610; // @[src/main/scala/fpga/Memory.scala 501:22 814:24]
  wire  _GEN_653 = reg_ren ? _GEN_610 : _GEN_628; // @[src/main/scala/fpga/Memory.scala 814:24]
  wire  _GEN_659 = reg_ren ? 1'h0 : reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 501:22 814:24]
  wire  _GEN_668 = reg_ren ? 1'h0 : _GEN_628; // @[src/main/scala/fpga/Memory.scala 501:22 814:24]
  wire  _GEN_676 = dram_d_rdata_valid & reg_ren; // @[src/main/scala/fpga/Memory.scala 520:19 808:33]
  wire  _GEN_681 = dram_d_rdata_valid & _GEN_639; // @[src/main/scala/fpga/Memory.scala 501:22 808:33]
  wire  _GEN_685 = dram_d_rdata_valid & _GEN_643; // @[src/main/scala/fpga/Memory.scala 527:25 808:33]
  wire  _GEN_691 = dram_d_rdata_valid & _GEN_649; // @[src/main/scala/fpga/Memory.scala 501:22 808:33]
  wire  _GEN_695 = dram_d_rdata_valid & _GEN_653; // @[src/main/scala/fpga/Memory.scala 533:25 808:33]
  wire  _GEN_701 = dram_d_rdata_valid & _GEN_659; // @[src/main/scala/fpga/Memory.scala 501:22 808:33]
  wire  _GEN_710 = dram_d_rdata_valid & _GEN_668; // @[src/main/scala/fpga/Memory.scala 501:22 808:33]
  wire [2:0] _GEN_717 = dram_d_rdata_valid ? 3'h0 : dcache_state; // @[src/main/scala/fpga/Memory.scala 808:33 845:22 504:29]
  wire [31:0] _GEN_719 = 3'h6 == dcache_state ? 32'hffffffff : 32'h0; // @[src/main/scala/fpga/Memory.scala 528:25 571:25 804:26]
  wire [2:0] _GEN_764 = 3'h6 == dcache_state ? _GEN_717 : dcache_state; // @[src/main/scala/fpga/Memory.scala 571:25 504:29]
  wire [2:0] _GEN_767 = 3'h5 == dcache_state ? _GEN_525 : _GEN_764; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [31:0] _GEN_769 = 3'h5 == dcache_state ? 32'h0 : _GEN_719; // @[src/main/scala/fpga/Memory.scala 528:25 571:25]
  wire  _GEN_773 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_676; // @[src/main/scala/fpga/Memory.scala 520:19 571:25]
  wire  _GEN_778 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_681; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_782 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_685; // @[src/main/scala/fpga/Memory.scala 527:25 571:25]
  wire  _GEN_788 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_691; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_792 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_695; // @[src/main/scala/fpga/Memory.scala 533:25 571:25]
  wire  _GEN_798 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_701; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_807 = 3'h5 == dcache_state ? 1'h0 : 3'h6 == dcache_state & _GEN_710; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire [31:0] _GEN_816 = 3'h3 == dcache_state ? wstrb : _GEN_769; // @[src/main/scala/fpga/Memory.scala 571:25 725:26]
  wire  _GEN_820 = 3'h3 == dcache_state ? _GEN_558 : _GEN_782; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_828 = 3'h3 == dcache_state ? _GEN_565 : _GEN_792; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [15:0] _GEN_836 = 3'h3 == dcache_state ? _GEN_498 : reg_req_addr_tag; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire [6:0] _GEN_837 = 3'h3 == dcache_state ? _GEN_499 : reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire [4:0] _GEN_838 = 3'h3 == dcache_state ? _GEN_500 : reg_req_addr_line_off; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire [15:0] _GEN_842 = 3'h3 == dcache_state ? _GEN_578 : reg_tag_0; // @[src/main/scala/fpga/Memory.scala 505:24 571:25]
  wire [15:0] _GEN_843 = 3'h3 == dcache_state ? _GEN_579 : reg_tag_1; // @[src/main/scala/fpga/Memory.scala 505:24 571:25]
  wire [2:0] _GEN_846 = 3'h3 == dcache_state ? _GEN_508 : _GEN_767; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [31:0] _GEN_848 = 3'h3 == dcache_state ? _GEN_510 : reg_wdata; // @[src/main/scala/fpga/Memory.scala 571:25 512:26]
  wire [3:0] _GEN_849 = 3'h3 == dcache_state ? _GEN_511 : reg_wstrb; // @[src/main/scala/fpga/Memory.scala 571:25 513:26]
  wire  _GEN_850 = 3'h3 == dcache_state ? _GEN_512 : reg_ren; // @[src/main/scala/fpga/Memory.scala 514:24 571:25]
  wire  _GEN_854 = 3'h3 == dcache_state ? _GEN_589 : reg_lru_way_hot; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_855 = 3'h3 == dcache_state ? _GEN_590 : reg_lru_dirty1; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_856 = 3'h3 == dcache_state ? _GEN_591 : reg_lru_dirty2; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_861 = 3'h3 == dcache_state ? 1'h0 : _GEN_773; // @[src/main/scala/fpga/Memory.scala 520:19 571:25]
  wire  _GEN_864 = 3'h3 == dcache_state ? 1'h0 : _GEN_778; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_873 = 3'h3 == dcache_state ? 1'h0 : _GEN_788; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_882 = 3'h3 == dcache_state ? 1'h0 : _GEN_798; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_891 = 3'h3 == dcache_state ? 1'h0 : _GEN_807; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire [2:0] _GEN_901 = 3'h4 == dcache_state ? _GEN_527 : _GEN_846; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [31:0] _GEN_906 = 3'h4 == dcache_state ? 32'h0 : _GEN_816; // @[src/main/scala/fpga/Memory.scala 528:25 571:25]
  wire  _GEN_909 = 3'h4 == dcache_state ? 1'h0 : _GEN_820; // @[src/main/scala/fpga/Memory.scala 527:25 571:25]
  wire  _GEN_912 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_558; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire  _GEN_917 = 3'h4 == dcache_state ? 1'h0 : _GEN_828; // @[src/main/scala/fpga/Memory.scala 533:25 571:25]
  wire  _GEN_920 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_565; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire [15:0] _GEN_925 = 3'h4 == dcache_state ? reg_req_addr_tag : _GEN_836; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire [6:0] _GEN_926 = 3'h4 == dcache_state ? reg_req_addr_index : _GEN_837; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire [4:0] _GEN_927 = 3'h4 == dcache_state ? reg_req_addr_line_off : _GEN_838; // @[src/main/scala/fpga/Memory.scala 571:25 511:29]
  wire  _GEN_930 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_503; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire [15:0] _GEN_931 = 3'h4 == dcache_state ? reg_tag_0 : _GEN_842; // @[src/main/scala/fpga/Memory.scala 505:24 571:25]
  wire [15:0] _GEN_932 = 3'h4 == dcache_state ? reg_tag_1 : _GEN_843; // @[src/main/scala/fpga/Memory.scala 505:24 571:25]
  wire  _GEN_933 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _T_95; // @[src/main/scala/fpga/Memory.scala 526:25 571:25]
  wire  _GEN_935 = 3'h4 == dcache_state ? 1'h0 : 3'h3 == dcache_state & _GEN_509; // @[src/main/scala/fpga/Memory.scala 518:19 571:25]
  wire [31:0] _GEN_936 = 3'h4 == dcache_state ? reg_wdata : _GEN_848; // @[src/main/scala/fpga/Memory.scala 571:25 512:26]
  wire [3:0] _GEN_937 = 3'h4 == dcache_state ? reg_wstrb : _GEN_849; // @[src/main/scala/fpga/Memory.scala 571:25 513:26]
  wire  _GEN_938 = 3'h4 == dcache_state ? reg_ren : _GEN_850; // @[src/main/scala/fpga/Memory.scala 514:24 571:25]
  wire  _GEN_942 = 3'h4 == dcache_state ? reg_lru_way_hot : _GEN_854; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_943 = 3'h4 == dcache_state ? reg_lru_dirty1 : _GEN_855; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_944 = 3'h4 == dcache_state ? reg_lru_dirty2 : _GEN_856; // @[src/main/scala/fpga/Memory.scala 510:24 571:25]
  wire  _GEN_946 = 3'h4 == dcache_state ? 1'h0 : _GEN_861; // @[src/main/scala/fpga/Memory.scala 520:19 571:25]
  wire  _GEN_949 = 3'h4 == dcache_state ? 1'h0 : _GEN_864; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_958 = 3'h4 == dcache_state ? 1'h0 : _GEN_873; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_967 = 3'h4 == dcache_state ? 1'h0 : _GEN_882; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_976 = 3'h4 == dcache_state ? 1'h0 : _GEN_891; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_984 = 3'h2 == dcache_state ? _T_95 : _GEN_946; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_994 = 3'h2 == dcache_state ? _T_95 : _GEN_933; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [6:0] _GEN_995 = 3'h2 == dcache_state ? _GEN_453 : _GEN_453; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_997 = 3'h2 == dcache_state ? _GEN_509 : _GEN_935; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _GEN_1000 = 3'h2 == dcache_state ? _GEN_512 : _GEN_938; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire [31:0] _GEN_1013 = 3'h2 == dcache_state ? 32'h0 : _GEN_906; // @[src/main/scala/fpga/Memory.scala 528:25 571:25]
  wire  _GEN_1016 = 3'h2 == dcache_state ? 1'h0 : _GEN_909; // @[src/main/scala/fpga/Memory.scala 527:25 571:25]
  wire  _GEN_1019 = 3'h2 == dcache_state ? 1'h0 : _GEN_912; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire  _GEN_1024 = 3'h2 == dcache_state ? 1'h0 : _GEN_917; // @[src/main/scala/fpga/Memory.scala 533:25 571:25]
  wire  _GEN_1027 = 3'h2 == dcache_state ? 1'h0 : _GEN_920; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire  _GEN_1034 = 3'h2 == dcache_state ? 1'h0 : _GEN_930; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1037 = 3'h2 == dcache_state ? 1'h0 : _GEN_935; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1040 = 3'h2 == dcache_state ? 1'h0 : _GEN_949; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1049 = 3'h2 == dcache_state ? 1'h0 : _GEN_958; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1058 = 3'h2 == dcache_state ? 1'h0 : _GEN_967; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1067 = 3'h2 == dcache_state ? 1'h0 : _GEN_976; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1078 = 3'h1 == dcache_state ? 1'h0 : _GEN_984; // @[src/main/scala/fpga/Memory.scala 520:19 571:25]
  wire  _GEN_1085 = 3'h1 == dcache_state ? 1'h0 : 3'h2 == dcache_state & _GEN_503; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1088 = 3'h1 == dcache_state ? 1'h0 : _GEN_994; // @[src/main/scala/fpga/Memory.scala 526:25 571:25]
  wire  _GEN_1090 = 3'h1 == dcache_state ? 1'h0 : _GEN_997; // @[src/main/scala/fpga/Memory.scala 518:19 571:25]
  wire  _GEN_1093 = 3'h1 == dcache_state ? reg_ren : _GEN_1000; // @[src/main/scala/fpga/Memory.scala 514:24 571:25]
  wire  _GEN_1096 = 3'h1 == dcache_state ? 1'h0 : 3'h2 == dcache_state & _GEN_509; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire [31:0] _GEN_1106 = 3'h1 == dcache_state ? 32'h0 : _GEN_1013; // @[src/main/scala/fpga/Memory.scala 528:25 571:25]
  wire  _GEN_1109 = 3'h1 == dcache_state ? 1'h0 : _GEN_1016; // @[src/main/scala/fpga/Memory.scala 527:25 571:25]
  wire  _GEN_1112 = 3'h1 == dcache_state ? 1'h0 : _GEN_1019; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire  _GEN_1117 = 3'h1 == dcache_state ? 1'h0 : _GEN_1024; // @[src/main/scala/fpga/Memory.scala 533:25 571:25]
  wire  _GEN_1120 = 3'h1 == dcache_state ? 1'h0 : _GEN_1027; // @[src/main/scala/fpga/Memory.scala 502:22 571:25]
  wire  _GEN_1127 = 3'h1 == dcache_state ? 1'h0 : _GEN_1034; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1130 = 3'h1 == dcache_state ? 1'h0 : _GEN_1037; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1133 = 3'h1 == dcache_state ? 1'h0 : _GEN_1040; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1142 = 3'h1 == dcache_state ? 1'h0 : _GEN_1049; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1151 = 3'h1 == dcache_state ? 1'h0 : _GEN_1058; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1160 = 3'h1 == dcache_state ? 1'h0 : _GEN_1067; // @[src/main/scala/fpga/Memory.scala 501:22 571:25]
  wire  _GEN_1181 = 3'h0 == dcache_state ? _GEN_465 : _GEN_1093; // @[src/main/scala/fpga/Memory.scala 571:25]
  wire  _T_163 = ~reset; // @[src/main/scala/fpga/Memory.scala 887:9]
  assign i_tag_array_0_MPORT_en = _T_25 & _GEN_117;
  assign i_tag_array_0_MPORT_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_data = i_tag_array_0[i_tag_array_0_MPORT_addr]; // @[src/main/scala/fpga/Memory.scala 289:24]
  assign i_tag_array_0_MPORT_1_en = _T_25 ? 1'h0 : _GEN_373;
  assign i_tag_array_0_MPORT_1_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_1_data = i_tag_array_0[i_tag_array_0_MPORT_1_addr]; // @[src/main/scala/fpga/Memory.scala 289:24]
  assign i_tag_array_0_MPORT_3_en = _T_25 ? 1'h0 : _GEN_395;
  assign i_tag_array_0_MPORT_3_addr = io_imem_addr[11:5];
  assign i_tag_array_0_MPORT_3_data = i_tag_array_0[i_tag_array_0_MPORT_3_addr]; // @[src/main/scala/fpga/Memory.scala 289:24]
  assign i_tag_array_0_MPORT_2_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_2_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_2_mask = 1'h1;
  assign i_tag_array_0_MPORT_2_en = _T_25 ? 1'h0 : _GEN_384;
  assign i_tag_array_0_MPORT_4_data = i_reg_req_addr_tag;
  assign i_tag_array_0_MPORT_4_addr = i_reg_req_addr_index;
  assign i_tag_array_0_MPORT_4_mask = 1'h1;
  assign i_tag_array_0_MPORT_4_en = _T_25 ? 1'h0 : _GEN_398;
  assign tag_array_0_MPORT_5_en = _T_83 & dcache_snoop_en;
  assign tag_array_0_MPORT_5_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_5_data = tag_array_0[tag_array_0_MPORT_5_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_6_en = _T_83 & _GEN_462;
  assign tag_array_0_MPORT_6_addr = _req_addr_T_9[11:5];
  assign tag_array_0_MPORT_6_data = tag_array_0[tag_array_0_MPORT_6_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_7_en = _T_83 ? 1'h0 : _GEN_1085;
  assign tag_array_0_MPORT_7_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_7_data = tag_array_0[tag_array_0_MPORT_7_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_8_en = _T_83 ? 1'h0 : _GEN_1096;
  assign tag_array_0_MPORT_8_addr = _req_addr_T_9[11:5];
  assign tag_array_0_MPORT_8_data = tag_array_0[tag_array_0_MPORT_8_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_11_en = _T_83 ? 1'h0 : _GEN_1127;
  assign tag_array_0_MPORT_11_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_0_MPORT_11_data = tag_array_0[tag_array_0_MPORT_11_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_12_en = _T_83 ? 1'h0 : _GEN_1130;
  assign tag_array_0_MPORT_12_addr = _req_addr_T_9[11:5];
  assign tag_array_0_MPORT_12_data = tag_array_0[tag_array_0_MPORT_12_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_0_MPORT_13_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_13_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_13_mask = 1'h1;
  assign tag_array_0_MPORT_13_en = _T_83 ? 1'h0 : _GEN_1133;
  assign tag_array_0_MPORT_15_data = reg_tag_0;
  assign tag_array_0_MPORT_15_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_15_mask = 1'h1;
  assign tag_array_0_MPORT_15_en = _T_83 ? 1'h0 : _GEN_1142;
  assign tag_array_0_MPORT_17_data = reg_req_addr_tag;
  assign tag_array_0_MPORT_17_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_17_mask = 1'h1;
  assign tag_array_0_MPORT_17_en = _T_83 ? 1'h0 : _GEN_1151;
  assign tag_array_0_MPORT_19_data = reg_tag_0;
  assign tag_array_0_MPORT_19_addr = reg_req_addr_index;
  assign tag_array_0_MPORT_19_mask = 1'h1;
  assign tag_array_0_MPORT_19_en = _T_83 ? 1'h0 : _GEN_1160;
  assign tag_array_1_MPORT_5_en = _T_83 & dcache_snoop_en;
  assign tag_array_1_MPORT_5_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_5_data = tag_array_1[tag_array_1_MPORT_5_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_6_en = _T_83 & _GEN_462;
  assign tag_array_1_MPORT_6_addr = _req_addr_T_9[11:5];
  assign tag_array_1_MPORT_6_data = tag_array_1[tag_array_1_MPORT_6_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_7_en = _T_83 ? 1'h0 : _GEN_1085;
  assign tag_array_1_MPORT_7_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_7_data = tag_array_1[tag_array_1_MPORT_7_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_8_en = _T_83 ? 1'h0 : _GEN_1096;
  assign tag_array_1_MPORT_8_addr = _req_addr_T_9[11:5];
  assign tag_array_1_MPORT_8_data = tag_array_1[tag_array_1_MPORT_8_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_11_en = _T_83 ? 1'h0 : _GEN_1127;
  assign tag_array_1_MPORT_11_addr = _dcache_snoop_addr_T[11:5];
  assign tag_array_1_MPORT_11_data = tag_array_1[tag_array_1_MPORT_11_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_12_en = _T_83 ? 1'h0 : _GEN_1130;
  assign tag_array_1_MPORT_12_addr = _req_addr_T_9[11:5];
  assign tag_array_1_MPORT_12_data = tag_array_1[tag_array_1_MPORT_12_addr]; // @[src/main/scala/fpga/Memory.scala 501:22]
  assign tag_array_1_MPORT_13_data = reg_tag_1;
  assign tag_array_1_MPORT_13_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_13_mask = 1'h1;
  assign tag_array_1_MPORT_13_en = _T_83 ? 1'h0 : _GEN_1133;
  assign tag_array_1_MPORT_15_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_15_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_15_mask = 1'h1;
  assign tag_array_1_MPORT_15_en = _T_83 ? 1'h0 : _GEN_1142;
  assign tag_array_1_MPORT_17_data = reg_tag_1;
  assign tag_array_1_MPORT_17_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_17_mask = 1'h1;
  assign tag_array_1_MPORT_17_en = _T_83 ? 1'h0 : _GEN_1151;
  assign tag_array_1_MPORT_19_data = reg_req_addr_tag;
  assign tag_array_1_MPORT_19_addr = reg_req_addr_index;
  assign tag_array_1_MPORT_19_mask = 1'h1;
  assign tag_array_1_MPORT_19_en = _T_83 ? 1'h0 : _GEN_1160;
  assign lru_array_way_hot_reg_lru_MPORT_en = _T_83 & _GEN_462;
  assign lru_array_way_hot_reg_lru_MPORT_addr = _req_addr_T_9[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_way_hot_reg_lru_MPORT_1_en = _T_83 ? 1'h0 : _GEN_1096;
  assign lru_array_way_hot_reg_lru_MPORT_1_addr = _req_addr_T_9[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_1_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_1_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_way_hot_reg_lru_MPORT_2_en = _T_83 ? 1'h0 : _GEN_1130;
  assign lru_array_way_hot_reg_lru_MPORT_2_addr = _req_addr_T_9[11:5];
  assign lru_array_way_hot_reg_lru_MPORT_2_data = lru_array_way_hot[lru_array_way_hot_reg_lru_MPORT_2_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_way_hot_MPORT_9_data = _T_121[2];
  assign lru_array_way_hot_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_9_mask = 1'h1;
  assign lru_array_way_hot_MPORT_9_en = _T_83 ? 1'h0 : _GEN_1112;
  assign lru_array_way_hot_MPORT_10_data = _T_125[2];
  assign lru_array_way_hot_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_10_mask = 1'h1;
  assign lru_array_way_hot_MPORT_10_en = _T_83 ? 1'h0 : _GEN_1120;
  assign lru_array_way_hot_MPORT_14_data = _T_144[2];
  assign lru_array_way_hot_MPORT_14_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_14_mask = 1'h1;
  assign lru_array_way_hot_MPORT_14_en = _T_83 ? 1'h0 : _GEN_1133;
  assign lru_array_way_hot_MPORT_16_data = _T_148[2];
  assign lru_array_way_hot_MPORT_16_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_16_mask = 1'h1;
  assign lru_array_way_hot_MPORT_16_en = _T_83 ? 1'h0 : _GEN_1142;
  assign lru_array_way_hot_MPORT_18_data = _T_121[2];
  assign lru_array_way_hot_MPORT_18_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_18_mask = 1'h1;
  assign lru_array_way_hot_MPORT_18_en = _T_83 ? 1'h0 : _GEN_1151;
  assign lru_array_way_hot_MPORT_20_data = _T_125[2];
  assign lru_array_way_hot_MPORT_20_addr = reg_req_addr_index;
  assign lru_array_way_hot_MPORT_20_mask = 1'h1;
  assign lru_array_way_hot_MPORT_20_en = _T_83 ? 1'h0 : _GEN_1160;
  assign lru_array_dirty1_reg_lru_MPORT_en = _T_83 & _GEN_462;
  assign lru_array_dirty1_reg_lru_MPORT_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty1_reg_lru_MPORT_1_en = _T_83 ? 1'h0 : _GEN_1096;
  assign lru_array_dirty1_reg_lru_MPORT_1_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_1_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_1_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty1_reg_lru_MPORT_2_en = _T_83 ? 1'h0 : _GEN_1130;
  assign lru_array_dirty1_reg_lru_MPORT_2_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty1_reg_lru_MPORT_2_data = lru_array_dirty1[lru_array_dirty1_reg_lru_MPORT_2_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty1_MPORT_9_data = _T_121[1];
  assign lru_array_dirty1_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_9_mask = 1'h1;
  assign lru_array_dirty1_MPORT_9_en = _T_83 ? 1'h0 : _GEN_1112;
  assign lru_array_dirty1_MPORT_10_data = _T_125[1];
  assign lru_array_dirty1_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_10_mask = 1'h1;
  assign lru_array_dirty1_MPORT_10_en = _T_83 ? 1'h0 : _GEN_1120;
  assign lru_array_dirty1_MPORT_14_data = _T_144[1];
  assign lru_array_dirty1_MPORT_14_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_14_mask = 1'h1;
  assign lru_array_dirty1_MPORT_14_en = _T_83 ? 1'h0 : _GEN_1133;
  assign lru_array_dirty1_MPORT_16_data = _T_148[1];
  assign lru_array_dirty1_MPORT_16_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_16_mask = 1'h1;
  assign lru_array_dirty1_MPORT_16_en = _T_83 ? 1'h0 : _GEN_1142;
  assign lru_array_dirty1_MPORT_18_data = _T_121[1];
  assign lru_array_dirty1_MPORT_18_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_18_mask = 1'h1;
  assign lru_array_dirty1_MPORT_18_en = _T_83 ? 1'h0 : _GEN_1151;
  assign lru_array_dirty1_MPORT_20_data = _T_125[1];
  assign lru_array_dirty1_MPORT_20_addr = reg_req_addr_index;
  assign lru_array_dirty1_MPORT_20_mask = 1'h1;
  assign lru_array_dirty1_MPORT_20_en = _T_83 ? 1'h0 : _GEN_1160;
  assign lru_array_dirty2_reg_lru_MPORT_en = _T_83 & _GEN_462;
  assign lru_array_dirty2_reg_lru_MPORT_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty2_reg_lru_MPORT_1_en = _T_83 ? 1'h0 : _GEN_1096;
  assign lru_array_dirty2_reg_lru_MPORT_1_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_1_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_1_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty2_reg_lru_MPORT_2_en = _T_83 ? 1'h0 : _GEN_1130;
  assign lru_array_dirty2_reg_lru_MPORT_2_addr = _req_addr_T_9[11:5];
  assign lru_array_dirty2_reg_lru_MPORT_2_data = lru_array_dirty2[lru_array_dirty2_reg_lru_MPORT_2_addr]; // @[src/main/scala/fpga/Memory.scala 502:22]
  assign lru_array_dirty2_MPORT_9_data = _T_121[0];
  assign lru_array_dirty2_MPORT_9_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_9_mask = 1'h1;
  assign lru_array_dirty2_MPORT_9_en = _T_83 ? 1'h0 : _GEN_1112;
  assign lru_array_dirty2_MPORT_10_data = _T_125[0];
  assign lru_array_dirty2_MPORT_10_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_10_mask = 1'h1;
  assign lru_array_dirty2_MPORT_10_en = _T_83 ? 1'h0 : _GEN_1120;
  assign lru_array_dirty2_MPORT_14_data = _T_144[0];
  assign lru_array_dirty2_MPORT_14_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_14_mask = 1'h1;
  assign lru_array_dirty2_MPORT_14_en = _T_83 ? 1'h0 : _GEN_1133;
  assign lru_array_dirty2_MPORT_16_data = _T_148[0];
  assign lru_array_dirty2_MPORT_16_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_16_mask = 1'h1;
  assign lru_array_dirty2_MPORT_16_en = _T_83 ? 1'h0 : _GEN_1142;
  assign lru_array_dirty2_MPORT_18_data = _T_121[0];
  assign lru_array_dirty2_MPORT_18_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_18_mask = 1'h1;
  assign lru_array_dirty2_MPORT_18_en = _T_83 ? 1'h0 : _GEN_1151;
  assign lru_array_dirty2_MPORT_20_data = _T_125[0];
  assign lru_array_dirty2_MPORT_20_addr = reg_req_addr_index;
  assign lru_array_dirty2_MPORT_20_mask = 1'h1;
  assign lru_array_dirty2_MPORT_20_en = _T_83 ? 1'h0 : _GEN_1160;
  assign io_imem_inst = 3'h0 == icache_state ? 32'hdeadbeef : _GEN_362; // @[src/main/scala/fpga/Memory.scala 305:16 326:25]
  assign io_imem_valid = 3'h0 == icache_state ? 1'h0 : _GEN_363; // @[src/main/scala/fpga/Memory.scala 306:17 326:25]
  assign io_cache_ibusy = 3'h0 == icache_state ? 1'h0 : _GEN_364; // @[src/main/scala/fpga/Memory.scala 326:25 328:22]
  assign io_cache_rdata = 3'h2 == dcache_state ? _GEN_449 : _io_cache_rdata_T_10[31:0]; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_rvalid = 3'h0 == dcache_state ? 1'h0 : _GEN_1078; // @[src/main/scala/fpga/Memory.scala 520:19 571:25]
  assign io_cache_rready = 3'h0 == dcache_state ? _GEN_462 : _GEN_1090; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_wready = 3'h0 == dcache_state ? _GEN_462 : _GEN_1090; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_dramPort_ren = 3'h0 == reg_dram_state ? _GEN_25 : _GEN_83; // @[src/main/scala/fpga/Memory.scala 209:27]
  assign io_dramPort_wen = 3'h0 == reg_dram_state ? _GEN_31 : _GEN_78; // @[src/main/scala/fpga/Memory.scala 209:27]
  assign io_dramPort_addr = _GEN_90[27:0];
  assign io_dramPort_wdata = 3'h0 == reg_dram_state ? dram_d_wdata[127:0] : reg_dram_wdata; // @[src/main/scala/fpga/Memory.scala 209:27]
  assign io_cache_array1_ren = 3'h0 == dcache_state | _GEN_1088; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_array1_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1109; // @[src/main/scala/fpga/Memory.scala 527:25 571:25]
  assign io_cache_array1_we = 3'h0 == dcache_state ? 32'h0 : _GEN_1106; // @[src/main/scala/fpga/Memory.scala 528:25 571:25]
  assign io_cache_array1_raddr = 3'h0 == dcache_state ? _GEN_453 : _GEN_995; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_array1_waddr = reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 530:25 571:25]
  assign io_cache_array1_wdata = 3'h3 == dcache_state ? wdata : _GEN_635; // @[src/main/scala/fpga/Memory.scala 571:25 724:29]
  assign io_cache_array2_ren = 3'h0 == dcache_state | _GEN_1088; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_array2_wen = 3'h0 == dcache_state ? 1'h0 : _GEN_1117; // @[src/main/scala/fpga/Memory.scala 533:25 571:25]
  assign io_cache_array2_we = 3'h0 == dcache_state ? 32'h0 : _GEN_1106; // @[src/main/scala/fpga/Memory.scala 534:25 571:25]
  assign io_cache_array2_raddr = 3'h0 == dcache_state ? _GEN_453 : _GEN_995; // @[src/main/scala/fpga/Memory.scala 571:25]
  assign io_cache_array2_waddr = reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 530:25 571:25]
  assign io_cache_array2_wdata = 3'h3 == dcache_state ? wdata : _GEN_635; // @[src/main/scala/fpga/Memory.scala 571:25 727:29]
  assign io_icache_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_358; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_wen = 3'h0 == icache_state ? 1'h0 : _GEN_387; // @[src/main/scala/fpga/Memory.scala 314:17 326:25]
  assign io_icache_raddr = 3'h0 == icache_state ? _io_icache_raddr_T_1 : _GEN_359; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_waddr = i_reg_req_addr_index; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_wdata = 3'h4 == icache_state ? dcache_snoop_line : dram_rdata; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_valid_ren = 3'h0 == icache_state ? _GEN_117 : _GEN_375; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_valid_wen = 3'h0 == icache_state ? 1'h0 : _GEN_387; // @[src/main/scala/fpga/Memory.scala 314:17 326:25]
  assign io_icache_valid_invalidate = 3'h0 == icache_state ? io_cache_iinvalidate : _GEN_368; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_valid_addr = 3'h0 == icache_state ? io_imem_addr[11:6] : _GEN_329; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_valid_iaddr = 3'h0 == icache_state ? 1'h0 : _GEN_313; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_valid_wdata = 3'h4 == icache_state ? icache_valid_wdata : icache_valid_wdata; // @[src/main/scala/fpga/Memory.scala 326:25]
  assign io_icache_state = icache_state; // @[src/main/scala/fpga/Memory.scala 850:35]
  assign io_dram_state = reg_dram_state; // @[src/main/scala/fpga/Memory.scala 851:35]
  always @(posedge clock) begin
    if (i_tag_array_0_MPORT_2_en & i_tag_array_0_MPORT_2_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_2_addr] <= i_tag_array_0_MPORT_2_data; // @[src/main/scala/fpga/Memory.scala 289:24]
    end
    if (i_tag_array_0_MPORT_4_en & i_tag_array_0_MPORT_4_mask) begin
      i_tag_array_0[i_tag_array_0_MPORT_4_addr] <= i_tag_array_0_MPORT_4_data; // @[src/main/scala/fpga/Memory.scala 289:24]
    end
    if (tag_array_0_MPORT_13_en & tag_array_0_MPORT_13_mask) begin
      tag_array_0[tag_array_0_MPORT_13_addr] <= tag_array_0_MPORT_13_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_0_MPORT_15_en & tag_array_0_MPORT_15_mask) begin
      tag_array_0[tag_array_0_MPORT_15_addr] <= tag_array_0_MPORT_15_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_0_MPORT_17_en & tag_array_0_MPORT_17_mask) begin
      tag_array_0[tag_array_0_MPORT_17_addr] <= tag_array_0_MPORT_17_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_0_MPORT_19_en & tag_array_0_MPORT_19_mask) begin
      tag_array_0[tag_array_0_MPORT_19_addr] <= tag_array_0_MPORT_19_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_1_MPORT_13_en & tag_array_1_MPORT_13_mask) begin
      tag_array_1[tag_array_1_MPORT_13_addr] <= tag_array_1_MPORT_13_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_1_MPORT_15_en & tag_array_1_MPORT_15_mask) begin
      tag_array_1[tag_array_1_MPORT_15_addr] <= tag_array_1_MPORT_15_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_1_MPORT_17_en & tag_array_1_MPORT_17_mask) begin
      tag_array_1[tag_array_1_MPORT_17_addr] <= tag_array_1_MPORT_17_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (tag_array_1_MPORT_19_en & tag_array_1_MPORT_19_mask) begin
      tag_array_1[tag_array_1_MPORT_19_addr] <= tag_array_1_MPORT_19_data; // @[src/main/scala/fpga/Memory.scala 501:22]
    end
    if (lru_array_way_hot_MPORT_9_en & lru_array_way_hot_MPORT_9_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_9_addr] <= lru_array_way_hot_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_way_hot_MPORT_10_en & lru_array_way_hot_MPORT_10_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_10_addr] <= lru_array_way_hot_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_way_hot_MPORT_14_en & lru_array_way_hot_MPORT_14_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_14_addr] <= lru_array_way_hot_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_way_hot_MPORT_16_en & lru_array_way_hot_MPORT_16_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_16_addr] <= lru_array_way_hot_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_way_hot_MPORT_18_en & lru_array_way_hot_MPORT_18_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_18_addr] <= lru_array_way_hot_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_way_hot_MPORT_20_en & lru_array_way_hot_MPORT_20_mask) begin
      lru_array_way_hot[lru_array_way_hot_MPORT_20_addr] <= lru_array_way_hot_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_9_en & lru_array_dirty1_MPORT_9_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_9_addr] <= lru_array_dirty1_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_10_en & lru_array_dirty1_MPORT_10_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_10_addr] <= lru_array_dirty1_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_14_en & lru_array_dirty1_MPORT_14_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_14_addr] <= lru_array_dirty1_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_16_en & lru_array_dirty1_MPORT_16_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_16_addr] <= lru_array_dirty1_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_18_en & lru_array_dirty1_MPORT_18_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_18_addr] <= lru_array_dirty1_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty1_MPORT_20_en & lru_array_dirty1_MPORT_20_mask) begin
      lru_array_dirty1[lru_array_dirty1_MPORT_20_addr] <= lru_array_dirty1_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_9_en & lru_array_dirty2_MPORT_9_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_9_addr] <= lru_array_dirty2_MPORT_9_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_10_en & lru_array_dirty2_MPORT_10_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_10_addr] <= lru_array_dirty2_MPORT_10_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_14_en & lru_array_dirty2_MPORT_14_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_14_addr] <= lru_array_dirty2_MPORT_14_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_16_en & lru_array_dirty2_MPORT_16_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_16_addr] <= lru_array_dirty2_MPORT_16_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_18_en & lru_array_dirty2_MPORT_18_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_18_addr] <= lru_array_dirty2_MPORT_18_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (lru_array_dirty2_MPORT_20_en & lru_array_dirty2_MPORT_20_mask) begin
      lru_array_dirty2[lru_array_dirty2_MPORT_20_addr] <= lru_array_dirty2_MPORT_20_data; // @[src/main/scala/fpga/Memory.scala 502:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 191:31]
      reg_dram_state <= 3'h0; // @[src/main/scala/fpga/Memory.scala 191:31]
    end else if (3'h0 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[src/main/scala/fpga/Memory.scala 211:67]
        if (dram_i_ren) begin // @[src/main/scala/fpga/Memory.scala 213:27]
          reg_dram_state <= 3'h2; // @[src/main/scala/fpga/Memory.scala 218:26]
        end else begin
          reg_dram_state <= _GEN_12;
        end
      end
    end else if (3'h1 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      if (_T_3) begin // @[src/main/scala/fpga/Memory.scala 241:32]
        reg_dram_state <= 3'h0; // @[src/main/scala/fpga/Memory.scala 246:24]
      end
    end else if (3'h2 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      reg_dram_state <= _GEN_46;
    end else begin
      reg_dram_state <= _GEN_66;
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 192:31]
      reg_dram_addr <= 27'h0; // @[src/main/scala/fpga/Memory.scala 192:31]
    end else if (3'h0 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[src/main/scala/fpga/Memory.scala 211:67]
        if (dram_i_ren) begin // @[src/main/scala/fpga/Memory.scala 213:27]
          reg_dram_addr <= dram_i_addr; // @[src/main/scala/fpga/Memory.scala 216:25]
        end else begin
          reg_dram_addr <= _GEN_9;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 193:31]
      reg_dram_wdata <= 128'h0; // @[src/main/scala/fpga/Memory.scala 193:31]
    end else if (3'h0 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      if (io_dramPort_init_calib_complete & ~io_dramPort_busy) begin // @[src/main/scala/fpga/Memory.scala 211:67]
        if (!(dram_i_ren)) begin // @[src/main/scala/fpga/Memory.scala 213:27]
          reg_dram_wdata <= _GEN_10;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 194:31]
      reg_dram_rdata <= 128'h0; // @[src/main/scala/fpga/Memory.scala 194:31]
    end else if (!(3'h0 == reg_dram_state)) begin // @[src/main/scala/fpga/Memory.scala 209:27]
      if (!(3'h1 == reg_dram_state)) begin // @[src/main/scala/fpga/Memory.scala 209:27]
        if (3'h2 == reg_dram_state) begin // @[src/main/scala/fpga/Memory.scala 209:27]
          reg_dram_rdata <= _GEN_40;
        end else begin
          reg_dram_rdata <= _GEN_67;
        end
      end
    end
    reg_dram_di <= reset | _GEN_92; // @[src/main/scala/fpga/Memory.scala 195:{28,28}]
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 291:29]
      icache_state <= 3'h0; // @[src/main/scala/fpga/Memory.scala 291:29]
    end else if (3'h0 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (io_cache_iinvalidate) begin // @[src/main/scala/fpga/Memory.scala 331:35]
        icache_state <= 3'h7; // @[src/main/scala/fpga/Memory.scala 335:22]
      end else if (io_imem_en) begin // @[src/main/scala/fpga/Memory.scala 336:31]
        icache_state <= {{1'd0}, _GEN_103};
      end
    end else if (3'h1 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[src/main/scala/fpga/Memory.scala 356:145]
        icache_state <= 3'h2; // @[src/main/scala/fpga/Memory.scala 360:22]
      end else begin
        icache_state <= 3'h4; // @[src/main/scala/fpga/Memory.scala 362:22]
      end
    end else if (3'h2 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      icache_state <= _GEN_132;
    end else begin
      icache_state <= _GEN_288;
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 504:29]
      dcache_state <= 3'h0; // @[src/main/scala/fpga/Memory.scala 504:29]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        dcache_state <= 3'h1; // @[src/main/scala/fpga/Memory.scala 581:22]
      end else if (io_cache_ren | io_cache_wen) begin // @[src/main/scala/fpga/Memory.scala 597:45]
        dcache_state <= {{1'd0}, _GEN_450};
      end
    end else if (3'h1 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      dcache_state <= 3'h0; // @[src/main/scala/fpga/Memory.scala 616:20]
    end else if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      dcache_state <= _GEN_508;
    end else begin
      dcache_state <= _GEN_901;
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 505:24]
      reg_tag_0 <= 16'h0; // @[src/main/scala/fpga/Memory.scala 505:24]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_tag_0 <= tag_array_0_MPORT_5_data; // @[src/main/scala/fpga/Memory.scala 576:17]
      end else begin
        reg_tag_0 <= tag_array_0_MPORT_6_data; // @[src/main/scala/fpga/Memory.scala 590:17]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_tag_0 <= _GEN_504;
      end else begin
        reg_tag_0 <= _GEN_931;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 511:29]
      reg_req_addr_tag <= 16'h0; // @[src/main/scala/fpga/Memory.scala 511:29]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_req_addr_tag <= dcache_snoop_addr_tag; // @[src/main/scala/fpga/Memory.scala 575:22]
      end else begin
        reg_req_addr_tag <= req_addr_3_tag; // @[src/main/scala/fpga/Memory.scala 586:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_req_addr_tag <= _GEN_498;
      end else begin
        reg_req_addr_tag <= _GEN_925;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 505:24]
      reg_tag_1 <= 16'h0; // @[src/main/scala/fpga/Memory.scala 505:24]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_tag_1 <= tag_array_1_MPORT_5_data; // @[src/main/scala/fpga/Memory.scala 576:17]
      end else begin
        reg_tag_1 <= tag_array_1_MPORT_6_data; // @[src/main/scala/fpga/Memory.scala 590:17]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_tag_1 <= _GEN_505;
      end else begin
        reg_tag_1 <= _GEN_932;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 294:31]
      i_reg_req_addr_tag <= 16'h0; // @[src/main/scala/fpga/Memory.scala 294:31]
    end else if (3'h0 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      i_reg_req_addr_tag <= io_imem_addr[27:12]; // @[src/main/scala/fpga/Memory.scala 330:22]
    end else if (!(3'h1 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h2 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_req_addr_tag <= io_imem_addr[27:12]; // @[src/main/scala/fpga/Memory.scala 372:22]
      end else begin
        i_reg_req_addr_tag <= _GEN_293;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 294:31]
      i_reg_req_addr_index <= 7'h0; // @[src/main/scala/fpga/Memory.scala 294:31]
    end else if (3'h0 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      i_reg_req_addr_index <= io_imem_addr[11:5]; // @[src/main/scala/fpga/Memory.scala 330:22]
    end else if (!(3'h1 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h2 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_req_addr_index <= io_imem_addr[11:5]; // @[src/main/scala/fpga/Memory.scala 372:22]
      end else begin
        i_reg_req_addr_index <= _GEN_294;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 510:24]
      reg_lru_way_hot <= 1'h0; // @[src/main/scala/fpga/Memory.scala 510:24]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (!(dcache_snoop_en)) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_lru_way_hot <= lru_array_way_hot_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 591:17]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_lru_way_hot <= _GEN_515;
      end else begin
        reg_lru_way_hot <= _GEN_942;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 510:24]
      reg_lru_dirty1 <= 1'h0; // @[src/main/scala/fpga/Memory.scala 510:24]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (!(dcache_snoop_en)) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_lru_dirty1 <= lru_array_dirty1_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 591:17]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_lru_dirty1 <= _GEN_516;
      end else begin
        reg_lru_dirty1 <= _GEN_943;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 510:24]
      reg_lru_dirty2 <= 1'h0; // @[src/main/scala/fpga/Memory.scala 510:24]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (!(dcache_snoop_en)) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_lru_dirty2 <= lru_array_dirty2_reg_lru_MPORT_data; // @[src/main/scala/fpga/Memory.scala 591:17]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_lru_dirty2 <= _GEN_517;
      end else begin
        reg_lru_dirty2 <= _GEN_944;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 511:29]
      reg_req_addr_index <= 7'h0; // @[src/main/scala/fpga/Memory.scala 511:29]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_req_addr_index <= dcache_snoop_addr_index; // @[src/main/scala/fpga/Memory.scala 575:22]
      end else begin
        reg_req_addr_index <= req_addr_3_index; // @[src/main/scala/fpga/Memory.scala 586:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_req_addr_index <= _GEN_499;
      end else begin
        reg_req_addr_index <= _GEN_926;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 508:25]
      reg_line <= 256'h0; // @[src/main/scala/fpga/Memory.scala 508:25]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      reg_line <= cold_line; // @[src/main/scala/fpga/Memory.scala 569:12]
    end else if (3'h1 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      reg_line <= cold_line; // @[src/main/scala/fpga/Memory.scala 569:12]
    end else if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      reg_line <= cold_line; // @[src/main/scala/fpga/Memory.scala 625:20]
    end else begin
      reg_line <= _GEN_899;
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 292:26]
      i_reg_tag_0 <= 16'h0; // @[src/main/scala/fpga/Memory.scala 292:26]
    end else if (3'h0 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (!(io_cache_iinvalidate)) begin // @[src/main/scala/fpga/Memory.scala 331:35]
        if (io_imem_en) begin // @[src/main/scala/fpga/Memory.scala 336:31]
          i_reg_tag_0 <= i_tag_array_0_MPORT_data; // @[src/main/scala/fpga/Memory.scala 337:19]
        end
      end
    end else if (!(3'h1 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h2 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_tag_0 <= _GEN_134;
      end else begin
        i_reg_tag_0 <= _GEN_300;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 293:27]
      i_reg_line <= 256'h0; // @[src/main/scala/fpga/Memory.scala 293:27]
    end else if (!(3'h0 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (!(3'h1 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        if (!(3'h2 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
          i_reg_line <= _GEN_274;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 294:31]
      i_reg_req_addr_line_off <= 5'h0; // @[src/main/scala/fpga/Memory.scala 294:31]
    end else if (3'h0 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[src/main/scala/fpga/Memory.scala 330:22]
    end else if (!(3'h1 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h2 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_req_addr_line_off <= io_imem_addr[4:0]; // @[src/main/scala/fpga/Memory.scala 372:22]
      end else begin
        i_reg_req_addr_line_off <= _GEN_295;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 295:32]
      i_reg_next_addr_tag <= 16'h0; // @[src/main/scala/fpga/Memory.scala 295:32]
    end else begin
      i_reg_next_addr_tag <= io_imem_addr[27:12]; // @[src/main/scala/fpga/Memory.scala 308:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 295:32]
      i_reg_next_addr_index <= 7'h0; // @[src/main/scala/fpga/Memory.scala 295:32]
    end else begin
      i_reg_next_addr_index <= io_imem_addr[11:5]; // @[src/main/scala/fpga/Memory.scala 308:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 295:32]
      i_reg_next_addr_line_off <= 5'h0; // @[src/main/scala/fpga/Memory.scala 295:32]
    end else begin
      i_reg_next_addr_line_off <= io_imem_addr[4:0]; // @[src/main/scala/fpga/Memory.scala 308:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 296:34]
      i_reg_valid_rdata <= 2'h0; // @[src/main/scala/fpga/Memory.scala 296:34]
    end else if (!(3'h0 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h1 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_valid_rdata <= io_icache_valid_rdata; // @[src/main/scala/fpga/Memory.scala 351:25]
      end else if (!(3'h2 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_valid_rdata <= _GEN_287;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 297:36]
      i_reg_cur_tag_index <= 23'h7fffff; // @[src/main/scala/fpga/Memory.scala 297:36]
    end else if (!(3'h0 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
      if (3'h1 == icache_state) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        if (_T_32[0] & i_reg_tag_0 == i_reg_req_addr_tag) begin // @[src/main/scala/fpga/Memory.scala 356:145]
          i_reg_cur_tag_index <= _dram_i_addr_T_1; // @[src/main/scala/fpga/Memory.scala 359:29]
        end
      end else if (!(3'h2 == icache_state)) begin // @[src/main/scala/fpga/Memory.scala 326:25]
        i_reg_cur_tag_index <= _GEN_286;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 298:33]
      i_reg_addr_match <= 1'h0; // @[src/main/scala/fpga/Memory.scala 298:33]
    end else begin
      i_reg_addr_match <= _GEN_417;
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 511:29]
      reg_req_addr_line_off <= 5'h0; // @[src/main/scala/fpga/Memory.scala 511:29]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (dcache_snoop_en) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_req_addr_line_off <= dcache_snoop_addr_line_off; // @[src/main/scala/fpga/Memory.scala 575:22]
      end else begin
        reg_req_addr_line_off <= req_addr_3_line_off; // @[src/main/scala/fpga/Memory.scala 586:22]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_req_addr_line_off <= _GEN_500;
      end else begin
        reg_req_addr_line_off <= _GEN_927;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 512:26]
      reg_wdata <= 32'h0; // @[src/main/scala/fpga/Memory.scala 512:26]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (!(dcache_snoop_en)) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_wdata <= io_cache_wdata; // @[src/main/scala/fpga/Memory.scala 587:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_wdata <= _GEN_510;
      end else begin
        reg_wdata <= _GEN_936;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Memory.scala 513:26]
      reg_wstrb <= 4'h0; // @[src/main/scala/fpga/Memory.scala 513:26]
    end else if (3'h0 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (!(dcache_snoop_en)) begin // @[src/main/scala/fpga/Memory.scala 573:30]
        reg_wstrb <= io_cache_wstrb; // @[src/main/scala/fpga/Memory.scala 588:19]
      end
    end else if (!(3'h1 == dcache_state)) begin // @[src/main/scala/fpga/Memory.scala 571:25]
      if (3'h2 == dcache_state) begin // @[src/main/scala/fpga/Memory.scala 571:25]
        reg_wstrb <= _GEN_511;
      end else begin
        reg_wstrb <= _GEN_937;
      end
    end
    reg_ren <= reset | _GEN_1181; // @[src/main/scala/fpga/Memory.scala 514:{24,24}]
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"icache_state    : %d\n",icache_state); // @[src/main/scala/fpga/Memory.scala 887:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_163) begin
          $fwrite(32'h80000002,"dcache_state    : %d\n",dcache_state); // @[src/main/scala/fpga/Memory.scala 888:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_163) begin
          $fwrite(32'h80000002,"reg_dram_state  : %d\n",reg_dram_state); // @[src/main/scala/fpga/Memory.scala 889:9]
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
  _RAND_22 = {8{`RANDOM}};
  reg_line = _RAND_22[255:0];
  _RAND_23 = {1{`RANDOM}};
  i_reg_tag_0 = _RAND_23[15:0];
  _RAND_24 = {8{`RANDOM}};
  i_reg_line = _RAND_24[255:0];
  _RAND_25 = {1{`RANDOM}};
  i_reg_req_addr_line_off = _RAND_25[4:0];
  _RAND_26 = {1{`RANDOM}};
  i_reg_next_addr_tag = _RAND_26[15:0];
  _RAND_27 = {1{`RANDOM}};
  i_reg_next_addr_index = _RAND_27[6:0];
  _RAND_28 = {1{`RANDOM}};
  i_reg_next_addr_line_off = _RAND_28[4:0];
  _RAND_29 = {1{`RANDOM}};
  i_reg_valid_rdata = _RAND_29[1:0];
  _RAND_30 = {1{`RANDOM}};
  i_reg_cur_tag_index = _RAND_30[22:0];
  _RAND_31 = {1{`RANDOM}};
  i_reg_addr_match = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  reg_req_addr_line_off = _RAND_32[4:0];
  _RAND_33 = {1{`RANDOM}};
  reg_wdata = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  reg_wstrb = _RAND_34[3:0];
  _RAND_35 = {1{`RANDOM}};
  reg_ren = _RAND_35[0:0];
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
  input         io_imem_en, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input  [31:0] io_imem_addr, // @[src/main/scala/fpga/BootRom.scala 13:14]
  output [31:0] io_imem_inst, // @[src/main/scala/fpga/BootRom.scala 13:14]
  output        io_imem_valid, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input  [31:0] io_dmem_raddr, // @[src/main/scala/fpga/BootRom.scala 13:14]
  output [31:0] io_dmem_rdata, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input         io_dmem_ren, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input  [31:0] io_dmem_waddr, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input         io_dmem_wen, // @[src/main/scala/fpga/BootRom.scala 13:14]
  input  [31:0] io_dmem_wdata // @[src/main/scala/fpga/BootRom.scala 13:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] imem [0:511]; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire  imem_imem_inst_MPORT_en; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [8:0] imem_imem_inst_MPORT_addr; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [31:0] imem_imem_inst_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire  imem_imem_rdata_MPORT_en; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [8:0] imem_imem_rdata_MPORT_addr; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [31:0] imem_imem_rdata_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [31:0] imem_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire [8:0] imem_MPORT_addr; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire  imem_MPORT_mask; // @[src/main/scala/fpga/BootRom.scala 26:17]
  wire  imem_MPORT_en; // @[src/main/scala/fpga/BootRom.scala 26:17]
  reg [31:0] imem_inst; // @[src/main/scala/fpga/BootRom.scala 18:26]
  reg [31:0] imem_rdata; // @[src/main/scala/fpga/BootRom.scala 19:27]
  reg  io_imem_valid_REG; // @[src/main/scala/fpga/BootRom.scala 33:27]
  wire [31:0] _rwaddr_T = io_dmem_wen ? io_dmem_waddr : io_dmem_raddr; // @[src/main/scala/fpga/BootRom.scala 35:19]
  wire  _T = ~io_dmem_wen; // @[src/main/scala/fpga/BootRom.scala 46:9]
  assign imem_imem_inst_MPORT_en = io_imem_en;
  assign imem_imem_inst_MPORT_addr = io_imem_addr[10:2];
  assign imem_imem_inst_MPORT_data = imem[imem_imem_inst_MPORT_addr]; // @[src/main/scala/fpga/BootRom.scala 26:17]
  assign imem_imem_rdata_MPORT_en = _T & io_dmem_ren;
  assign imem_imem_rdata_MPORT_addr = _rwaddr_T[10:2];
  assign imem_imem_rdata_MPORT_data = imem[imem_imem_rdata_MPORT_addr]; // @[src/main/scala/fpga/BootRom.scala 26:17]
  assign imem_MPORT_data = io_dmem_wdata;
  assign imem_MPORT_addr = _rwaddr_T[10:2];
  assign imem_MPORT_mask = 1'h1;
  assign imem_MPORT_en = io_dmem_wen;
  assign io_imem_inst = imem_inst; // @[src/main/scala/fpga/BootRom.scala 32:16]
  assign io_imem_valid = io_imem_valid_REG; // @[src/main/scala/fpga/BootRom.scala 33:17]
  assign io_dmem_rdata = imem_rdata; // @[src/main/scala/fpga/BootRom.scala 49:17]
  always @(posedge clock) begin
    if (imem_MPORT_en & imem_MPORT_mask) begin
      imem[imem_MPORT_addr] <= imem_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 26:17]
    end
    if (reset) begin // @[src/main/scala/fpga/BootRom.scala 18:26]
      imem_inst <= 32'h0; // @[src/main/scala/fpga/BootRom.scala 18:26]
    end else if (io_imem_en) begin // @[src/main/scala/fpga/BootRom.scala 29:21]
      imem_inst <= imem_imem_inst_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 30:15]
    end
    if (reset) begin // @[src/main/scala/fpga/BootRom.scala 19:27]
      imem_rdata <= 32'h0; // @[src/main/scala/fpga/BootRom.scala 19:27]
    end else if (~io_dmem_wen & io_dmem_ren) begin // @[src/main/scala/fpga/BootRom.scala 46:38]
      imem_rdata <= imem_imem_rdata_MPORT_data; // @[src/main/scala/fpga/BootRom.scala 47:16]
    end
    if (reset) begin // @[src/main/scala/fpga/BootRom.scala 33:27]
      io_imem_valid_REG <= 1'h0; // @[src/main/scala/fpga/BootRom.scala 33:27]
    end else begin
      io_imem_valid_REG <= io_imem_en; // @[src/main/scala/fpga/BootRom.scala 33:27]
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
  input         io_mem_wen, // @[src/main/scala/fpga/periferals/Gpio.scala 8:14]
  input  [31:0] io_mem_wdata, // @[src/main/scala/fpga/periferals/Gpio.scala 8:14]
  output [31:0] io_gpio // @[src/main/scala/fpga/periferals/Gpio.scala 8:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] output_; // @[src/main/scala/fpga/periferals/Gpio.scala 13:23]
  assign io_gpio = output_; // @[src/main/scala/fpga/periferals/Gpio.scala 14:11]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/periferals/Gpio.scala 13:23]
      output_ <= 32'h0; // @[src/main/scala/fpga/periferals/Gpio.scala 13:23]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Gpio.scala 20:20]
      output_ <= io_mem_wdata; // @[src/main/scala/fpga/periferals/Gpio.scala 21:12]
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
  output       io_in_ready, // @[src/main/scala/fpga/periferals/Uart.scala 9:16]
  input        io_in_valid, // @[src/main/scala/fpga/periferals/Uart.scala 9:16]
  input  [7:0] io_in_bits, // @[src/main/scala/fpga/periferals/Uart.scala 9:16]
  output       io_tx // @[src/main/scala/fpga/periferals/Uart.scala 9:16]
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
  reg [9:0] rateCounter; // @[src/main/scala/fpga/periferals/Uart.scala 14:30]
  reg [3:0] bitCounter; // @[src/main/scala/fpga/periferals/Uart.scala 15:29]
  reg  bits_0; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_1; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_2; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_3; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_4; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_5; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_6; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_7; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_8; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  reg  bits_9; // @[src/main/scala/fpga/periferals/Uart.scala 16:19]
  wire [9:0] _T_1 = {1'h1,io_in_bits,1'h0}; // @[src/main/scala/fpga/periferals/Uart.scala 22:20]
  wire  _GEN_0 = io_in_valid & io_in_ready ? _T_1[0] : bits_0; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_1 = io_in_valid & io_in_ready ? _T_1[1] : bits_1; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_2 = io_in_valid & io_in_ready ? _T_1[2] : bits_2; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_3 = io_in_valid & io_in_ready ? _T_1[3] : bits_3; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_4 = io_in_valid & io_in_ready ? _T_1[4] : bits_4; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_5 = io_in_valid & io_in_ready ? _T_1[5] : bits_5; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_6 = io_in_valid & io_in_ready ? _T_1[6] : bits_6; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_7 = io_in_valid & io_in_ready ? _T_1[7] : bits_7; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire  _GEN_8 = io_in_valid & io_in_ready ? _T_1[8] : bits_8; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 22:14 16:19]
  wire [3:0] _GEN_10 = io_in_valid & io_in_ready ? 4'ha : bitCounter; // @[src/main/scala/fpga/periferals/Uart.scala 21:38 23:20 15:29]
  wire [3:0] _bitCounter_T_1 = bitCounter - 4'h1; // @[src/main/scala/fpga/periferals/Uart.scala 31:38]
  wire [9:0] _rateCounter_T_1 = rateCounter - 10'h1; // @[src/main/scala/fpga/periferals/Uart.scala 34:40]
  assign io_in_ready = bitCounter == 4'h0; // @[src/main/scala/fpga/periferals/Uart.scala 19:31]
  assign io_tx = bitCounter == 4'h0 | bits_0; // @[src/main/scala/fpga/periferals/Uart.scala 18:33]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 14:30]
      rateCounter <= 10'h0; // @[src/main/scala/fpga/periferals/Uart.scala 14:30]
    end else if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        rateCounter <= 10'h363; // @[src/main/scala/fpga/periferals/Uart.scala 32:25]
      end else begin
        rateCounter <= _rateCounter_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 34:25]
      end
    end else if (io_in_valid & io_in_ready) begin // @[src/main/scala/fpga/periferals/Uart.scala 21:38]
      rateCounter <= 10'h363; // @[src/main/scala/fpga/periferals/Uart.scala 24:21]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 15:29]
      bitCounter <= 4'h0; // @[src/main/scala/fpga/periferals/Uart.scala 15:29]
    end else if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bitCounter <= _bitCounter_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 31:24]
      end else begin
        bitCounter <= _GEN_10;
      end
    end else begin
      bitCounter <= _GEN_10;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_0 <= bits_1; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_0 <= _GEN_0;
      end
    end else begin
      bits_0 <= _GEN_0;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_1 <= bits_2; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_1 <= _GEN_1;
      end
    end else begin
      bits_1 <= _GEN_1;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_2 <= bits_3; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_2 <= _GEN_2;
      end
    end else begin
      bits_2 <= _GEN_2;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_3 <= bits_4; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_3 <= _GEN_3;
      end
    end else begin
      bits_3 <= _GEN_3;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_4 <= bits_5; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_4 <= _GEN_4;
      end
    end else begin
      bits_4 <= _GEN_4;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_5 <= bits_6; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_5 <= _GEN_5;
      end
    end else begin
      bits_5 <= _GEN_5;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_6 <= bits_7; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_6 <= _GEN_6;
      end
    end else begin
      bits_6 <= _GEN_6;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_7 <= bits_8; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_7 <= _GEN_7;
      end
    end else begin
      bits_7 <= _GEN_7;
    end
    if (bitCounter > 4'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 27:30]
      if (rateCounter == 10'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 28:35]
        bits_8 <= bits_9; // @[src/main/scala/fpga/periferals/Uart.scala 30:54]
      end else begin
        bits_8 <= _GEN_8;
      end
    end else begin
      bits_8 <= _GEN_8;
    end
    if (io_in_valid & io_in_ready) begin // @[src/main/scala/fpga/periferals/Uart.scala 21:38]
      bits_9 <= _T_1[9]; // @[src/main/scala/fpga/periferals/Uart.scala 22:14]
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
  input        io_out_ready, // @[src/main/scala/fpga/periferals/Uart.scala 40:16]
  output       io_out_valid, // @[src/main/scala/fpga/periferals/Uart.scala 40:16]
  output [7:0] io_out_bits, // @[src/main/scala/fpga/periferals/Uart.scala 40:16]
  input        io_rx, // @[src/main/scala/fpga/periferals/Uart.scala 40:16]
  output       io_overrun // @[src/main/scala/fpga/periferals/Uart.scala 40:16]
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
  reg [10:0] rateCounter; // @[src/main/scala/fpga/periferals/Uart.scala 46:30]
  reg [2:0] bitCounter; // @[src/main/scala/fpga/periferals/Uart.scala 47:29]
  reg  bits_1; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_2; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_3; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_4; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_5; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_6; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  bits_7; // @[src/main/scala/fpga/periferals/Uart.scala 48:19]
  reg  rxRegs_0; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
  reg  rxRegs_1; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
  reg  rxRegs_2; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
  reg  overrun; // @[src/main/scala/fpga/periferals/Uart.scala 50:26]
  reg  running; // @[src/main/scala/fpga/periferals/Uart.scala 51:26]
  reg  outValid; // @[src/main/scala/fpga/periferals/Uart.scala 53:27]
  reg [7:0] outBits; // @[src/main/scala/fpga/periferals/Uart.scala 54:22]
  wire  _GEN_0 = outValid & io_out_ready ? 1'h0 : outValid; // @[src/main/scala/fpga/periferals/Uart.scala 59:32 60:18 53:27]
  wire  _GEN_3 = ~rxRegs_1 & rxRegs_0 | running; // @[src/main/scala/fpga/periferals/Uart.scala 70:39 73:21 51:26]
  wire [7:0] _outBits_T_1 = {rxRegs_0,bits_7,bits_6,bits_5,bits_4,bits_3,bits_2,bits_1}; // @[src/main/scala/fpga/periferals/Uart.scala 81:31]
  wire [2:0] _bitCounter_T_1 = bitCounter - 3'h1; // @[src/main/scala/fpga/periferals/Uart.scala 86:42]
  wire  _GEN_4 = bitCounter == 3'h0 | _GEN_0; // @[src/main/scala/fpga/periferals/Uart.scala 79:38 80:26]
  wire [10:0] _rateCounter_T_1 = rateCounter - 11'h1; // @[src/main/scala/fpga/periferals/Uart.scala 89:40]
  assign io_out_valid = outValid; // @[src/main/scala/fpga/periferals/Uart.scala 56:18]
  assign io_out_bits = outBits; // @[src/main/scala/fpga/periferals/Uart.scala 57:17]
  assign io_overrun = overrun; // @[src/main/scala/fpga/periferals/Uart.scala 67:16]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 46:30]
      rateCounter <= 11'h0; // @[src/main/scala/fpga/periferals/Uart.scala 46:30]
    end else if (~running) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[src/main/scala/fpga/periferals/Uart.scala 70:39]
        rateCounter <= 11'h515; // @[src/main/scala/fpga/periferals/Uart.scala 71:25]
      end
    end else if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
      if (!(bitCounter == 3'h0)) begin // @[src/main/scala/fpga/periferals/Uart.scala 79:38]
        rateCounter <= 11'h363; // @[src/main/scala/fpga/periferals/Uart.scala 85:29]
      end
    end else begin
      rateCounter <= _rateCounter_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 89:25]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 47:29]
      bitCounter <= 3'h0; // @[src/main/scala/fpga/periferals/Uart.scala 47:29]
    end else if (~running) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (~rxRegs_1 & rxRegs_0) begin // @[src/main/scala/fpga/periferals/Uart.scala 70:39]
        bitCounter <= 3'h7; // @[src/main/scala/fpga/periferals/Uart.scala 72:24]
      end
    end else if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
      if (!(bitCounter == 3'h0)) begin // @[src/main/scala/fpga/periferals/Uart.scala 79:38]
        bitCounter <= _bitCounter_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 86:28]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_1 <= bits_2; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_2 <= bits_3; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_3 <= bits_4; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_4 <= bits_5; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_5 <= bits_6; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_6 <= bits_7; // @[src/main/scala/fpga/periferals/Uart.scala 78:58]
      end
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        bits_7 <= rxRegs_0; // @[src/main/scala/fpga/periferals/Uart.scala 77:34]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
      rxRegs_0 <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
    end else begin
      rxRegs_0 <= rxRegs_1; // @[src/main/scala/fpga/periferals/Uart.scala 65:52]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
      rxRegs_1 <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
    end else begin
      rxRegs_1 <= rxRegs_2; // @[src/main/scala/fpga/periferals/Uart.scala 65:52]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
      rxRegs_2 <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 49:25]
    end else begin
      rxRegs_2 <= io_rx; // @[src/main/scala/fpga/periferals/Uart.scala 64:26]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 50:26]
      overrun <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 50:26]
    end else if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        if (bitCounter == 3'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 79:38]
          overrun <= outValid; // @[src/main/scala/fpga/periferals/Uart.scala 82:25]
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 51:26]
      running <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 51:26]
    end else if (~running) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      running <= _GEN_3;
    end else if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
      if (bitCounter == 3'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 79:38]
        running <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 83:25]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 53:27]
      outValid <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 53:27]
    end else if (~running) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      outValid <= _GEN_0;
    end else if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
      outValid <= _GEN_4;
    end else begin
      outValid <= _GEN_0;
    end
    if (!(~running)) begin // @[src/main/scala/fpga/periferals/Uart.scala 69:20]
      if (rateCounter == 11'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 76:35]
        if (bitCounter == 3'h0) begin // @[src/main/scala/fpga/periferals/Uart.scala 79:38]
          outBits <= _outBits_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 81:25]
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
  input  [31:0] io_mem_raddr, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  output [31:0] io_mem_rdata, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  input  [31:0] io_mem_waddr, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  input         io_mem_wen, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  input  [31:0] io_mem_wdata, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  output        io_intr, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  output        io_tx, // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
  input         io_rx // @[src/main/scala/fpga/periferals/Uart.scala 95:14]
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
  wire  tx_clock; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire  tx_reset; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire  tx_io_in_ready; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire  tx_io_in_valid; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire [7:0] tx_io_in_bits; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire  tx_io_tx; // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
  wire  rx_clock; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire  rx_reset; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire  rx_io_out_ready; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire  rx_io_out_valid; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire [7:0] rx_io_out_bits; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire  rx_io_rx; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  wire  rx_io_overrun; // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
  reg  tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 103:25]
  reg [7:0] tx_data; // @[src/main/scala/fpga/periferals/Uart.scala 105:24]
  reg  tx_intr_en; // @[src/main/scala/fpga/periferals/Uart.scala 106:27]
  wire  _tx_io_in_valid_T = ~tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 107:21]
  reg [7:0] rx_data; // @[src/main/scala/fpga/periferals/Uart.scala 111:24]
  reg  rx_data_ready; // @[src/main/scala/fpga/periferals/Uart.scala 112:30]
  reg  rx_intr_en; // @[src/main/scala/fpga/periferals/Uart.scala 113:27]
  wire  _rx_io_out_ready_T = ~rx_data_ready; // @[src/main/scala/fpga/periferals/Uart.scala 115:22]
  wire  _GEN_1 = rx_io_out_valid & _rx_io_out_ready_T | rx_data_ready; // @[src/main/scala/fpga/periferals/Uart.scala 116:44 118:19 112:30]
  reg [31:0] rdata; // @[src/main/scala/fpga/periferals/Uart.scala 121:22]
  wire [31:0] _rdata_T_1 = {27'h0,rx_io_overrun,rx_data_ready,_tx_io_in_valid_T,rx_intr_en,tx_intr_en}; // @[src/main/scala/fpga/periferals/Uart.scala 131:21]
  wire  _GEN_6 = tx_empty ? 1'h0 : tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 147:25 148:20 103:25]
  wire [31:0] _GEN_7 = tx_empty ? io_mem_wdata : {{24'd0}, tx_data}; // @[src/main/scala/fpga/periferals/Uart.scala 147:25 149:19 105:24]
  wire  _GEN_8 = io_mem_waddr[2] ? _GEN_6 : tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 103:25 141:33]
  wire [31:0] _GEN_9 = io_mem_waddr[2] ? _GEN_7 : {{24'd0}, tx_data}; // @[src/main/scala/fpga/periferals/Uart.scala 105:24 141:33]
  wire  _GEN_12 = ~io_mem_waddr[2] ? tx_empty : _GEN_8; // @[src/main/scala/fpga/periferals/Uart.scala 103:25 141:33]
  wire [31:0] _GEN_13 = ~io_mem_waddr[2] ? {{24'd0}, tx_data} : _GEN_9; // @[src/main/scala/fpga/periferals/Uart.scala 105:24 141:33]
  wire  _GEN_16 = io_mem_wen ? _GEN_12 : tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 140:21 103:25]
  wire [31:0] _GEN_17 = io_mem_wen ? _GEN_13 : {{24'd0}, tx_data}; // @[src/main/scala/fpga/periferals/Uart.scala 140:21 105:24]
  wire  tx_ready = tx_io_in_ready; // @[src/main/scala/fpga/periferals/Uart.scala 104:{29,29}]
  wire  _GEN_18 = _tx_io_in_valid_T & tx_ready | _GEN_16; // @[src/main/scala/fpga/periferals/Uart.scala 155:31 156:14]
  wire [31:0] _GEN_19 = reset ? 32'h0 : _GEN_17; // @[src/main/scala/fpga/periferals/Uart.scala 105:{24,24}]
  UartTx tx ( // @[src/main/scala/fpga/periferals/Uart.scala 102:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_in_ready(tx_io_in_ready),
    .io_in_valid(tx_io_in_valid),
    .io_in_bits(tx_io_in_bits),
    .io_tx(tx_io_tx)
  );
  UartRx rx ( // @[src/main/scala/fpga/periferals/Uart.scala 110:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_out_ready(rx_io_out_ready),
    .io_out_valid(rx_io_out_valid),
    .io_out_bits(rx_io_out_bits),
    .io_rx(rx_io_rx),
    .io_overrun(rx_io_overrun)
  );
  assign io_mem_rdata = rdata; // @[src/main/scala/fpga/periferals/Uart.scala 123:16]
  assign io_intr = tx_empty & tx_intr_en | rx_data_ready & rx_intr_en; // @[src/main/scala/fpga/periferals/Uart.scala 159:39]
  assign io_tx = tx_io_tx; // @[src/main/scala/fpga/periferals/Uart.scala 160:9]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_in_valid = ~tx_empty; // @[src/main/scala/fpga/periferals/Uart.scala 107:21]
  assign tx_io_in_bits = tx_data; // @[src/main/scala/fpga/periferals/Uart.scala 108:17]
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_out_ready = ~rx_data_ready; // @[src/main/scala/fpga/periferals/Uart.scala 115:22]
  assign rx_io_rx = io_rx; // @[src/main/scala/fpga/periferals/Uart.scala 161:9]
  always @(posedge clock) begin
    tx_empty <= reset | _GEN_18; // @[src/main/scala/fpga/periferals/Uart.scala 103:{25,25}]
    tx_data <= _GEN_19[7:0]; // @[src/main/scala/fpga/periferals/Uart.scala 105:{24,24}]
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 106:27]
      tx_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 106:27]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Uart.scala 140:21]
      if (~io_mem_waddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 141:33]
        tx_intr_en <= io_mem_wdata[0]; // @[src/main/scala/fpga/periferals/Uart.scala 143:20]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 111:24]
      rx_data <= 8'h0; // @[src/main/scala/fpga/periferals/Uart.scala 111:24]
    end else if (rx_io_out_valid & _rx_io_out_ready_T) begin // @[src/main/scala/fpga/periferals/Uart.scala 116:44]
      rx_data <= rx_io_out_bits; // @[src/main/scala/fpga/periferals/Uart.scala 117:13]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 112:30]
      rx_data_ready <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 112:30]
    end else if (~io_mem_raddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 129:33]
      rx_data_ready <= _GEN_1;
    end else if (io_mem_raddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 129:33]
      rx_data_ready <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 135:23]
    end else begin
      rx_data_ready <= _GEN_1;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 113:27]
      rx_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Uart.scala 113:27]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Uart.scala 140:21]
      if (~io_mem_waddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 141:33]
        rx_intr_en <= io_mem_wdata[1]; // @[src/main/scala/fpga/periferals/Uart.scala 144:20]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Uart.scala 121:22]
      rdata <= 32'h0; // @[src/main/scala/fpga/periferals/Uart.scala 121:22]
    end else if (~io_mem_raddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 129:33]
      rdata <= _rdata_T_1; // @[src/main/scala/fpga/periferals/Uart.scala 131:15]
    end else if (io_mem_raddr[2]) begin // @[src/main/scala/fpga/periferals/Uart.scala 129:33]
      rdata <= {{24'd0}, rx_data}; // @[src/main/scala/fpga/periferals/Uart.scala 134:15]
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
  _RAND_6 = {1{`RANDOM}};
  rdata = _RAND_6[31:0];
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
  input  [31:0] io_mem_raddr, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [31:0] io_mem_rdata, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input         io_mem_ren, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input  [31:0] io_mem_waddr, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input         io_mem_wen, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input  [31:0] io_mem_wdata, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdc_port_clk, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdc_port_cmd_wrt, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdc_port_cmd_out, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input         io_sdc_port_res_in, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdc_port_dat_wrt, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [3:0]  io_sdc_port_dat_out, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input  [3:0]  io_sdc_port_dat_in, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdbuf_ren1, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdbuf_wen1, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [7:0]  io_sdbuf_addr1, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input  [31:0] io_sdbuf_rdata1, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [31:0] io_sdbuf_wdata1, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdbuf_ren2, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_sdbuf_wen2, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [7:0]  io_sdbuf_addr2, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  input  [31:0] io_sdbuf_rdata2, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output [31:0] io_sdbuf_wdata2, // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
  output        io_intr // @[src/main/scala/fpga/periferals/Sdc.scala 75:14]
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
  reg  reg_power; // @[src/main/scala/fpga/periferals/Sdc.scala 88:26]
  reg [8:0] reg_baud_divider; // @[src/main/scala/fpga/periferals/Sdc.scala 89:33]
  reg [8:0] reg_clk_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 90:32]
  reg  reg_clk; // @[src/main/scala/fpga/periferals/Sdc.scala 91:24]
  reg [31:0] reg_rdata; // @[src/main/scala/fpga/periferals/Sdc.scala 92:26]
  wire  _T = reg_clk_counter == 9'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 94:27]
  wire [8:0] _reg_clk_counter_T_1 = reg_clk_counter - 9'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 98:42]
  wire [8:0] _GEN_0 = reg_clk_counter == 9'h0 ? reg_baud_divider : _reg_clk_counter_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 94:36 95:23 98:23]
  wire  _GEN_1 = reg_clk_counter == 9'h0 ? ~reg_clk : reg_clk; // @[src/main/scala/fpga/periferals/Sdc.scala 94:36 96:15 91:24]
  wire [8:0] _GEN_2 = reg_power ? _GEN_0 : reg_clk_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 93:20 90:32]
  wire  _GEN_3 = reg_power & _GEN_1; // @[src/main/scala/fpga/periferals/Sdc.scala 101:13 93:20]
  reg  rx_res_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 105:35]
  reg [7:0] rx_res_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 106:31]
  reg  rx_res_bits_0; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_1; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_2; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_3; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_4; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_5; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_6; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_7; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_8; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_9; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_10; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_11; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_12; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_13; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_14; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_15; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_16; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_17; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_18; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_19; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_20; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_21; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_22; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_23; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_24; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_25; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_26; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_27; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_28; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_29; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_30; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_31; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_32; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_33; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_34; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_35; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_36; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_37; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_38; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_39; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_40; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_41; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_42; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_43; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_44; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_45; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_46; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_47; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_48; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_49; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_50; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_51; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_52; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_53; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_54; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_55; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_56; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_57; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_58; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_59; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_60; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_61; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_62; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_63; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_64; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_65; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_66; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_67; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_68; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_69; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_70; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_71; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_72; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_73; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_74; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_75; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_76; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_77; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_78; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_79; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_80; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_81; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_82; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_83; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_84; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_85; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_86; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_87; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_88; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_89; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_90; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_91; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_92; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_93; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_94; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_95; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_96; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_97; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_98; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_99; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_100; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_101; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_102; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_103; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_104; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_105; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_106; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_107; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_108; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_109; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_110; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_111; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_112; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_113; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_114; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_115; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_116; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_117; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_118; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_119; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_120; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_121; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_122; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_123; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_124; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_125; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_126; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_127; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_128; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_129; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_130; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_131; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_132; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_133; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_134; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_bits_135; // @[src/main/scala/fpga/periferals/Sdc.scala 107:24]
  reg  rx_res_next; // @[src/main/scala/fpga/periferals/Sdc.scala 108:28]
  reg [3:0] rx_res_type; // @[src/main/scala/fpga/periferals/Sdc.scala 109:28]
  reg [135:0] rx_res; // @[src/main/scala/fpga/periferals/Sdc.scala 110:23]
  reg  rx_res_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 111:29]
  reg  rx_res_intr_en; // @[src/main/scala/fpga/periferals/Sdc.scala 112:31]
  reg  rx_res_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23]
  reg  rx_res_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 114:33]
  reg  rx_res_crc_en; // @[src/main/scala/fpga/periferals/Sdc.scala 115:30]
  reg [7:0] rx_res_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 116:29]
  reg  rx_res_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 117:31]
  reg [1:0] rx_res_read_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 118:36]
  reg [31:0] tx_cmd_arg; // @[src/main/scala/fpga/periferals/Sdc.scala 119:27]
  reg  tx_cmd_0; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_1; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_2; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_3; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_4; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_5; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_6; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_7; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_8; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_9; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_10; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_11; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_12; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_13; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_14; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_15; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_16; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_17; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_18; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_19; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_20; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_21; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_22; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_23; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_24; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_25; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_26; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_27; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_28; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_29; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_30; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_31; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_32; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_33; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_34; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_35; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_36; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_37; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_38; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_39; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_40; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_41; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_42; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_43; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_44; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_45; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_46; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg  tx_cmd_47; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19]
  reg [5:0] tx_cmd_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 121:31]
  reg  tx_cmd_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg  tx_cmd_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23]
  reg [5:0] tx_cmd_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 123:29]
  reg  reg_tx_cmd_wrt; // @[src/main/scala/fpga/periferals/Sdc.scala 124:31]
  reg  reg_tx_cmd_out; // @[src/main/scala/fpga/periferals/Sdc.scala 125:31]
  reg  rx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 126:35]
  reg [10:0] rx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 127:31]
  reg  rx_dat_start_bit; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33]
  reg [3:0] rx_dat_bits_0; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_1; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_2; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_3; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_4; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_5; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_6; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_bits_7; // @[src/main/scala/fpga/periferals/Sdc.scala 129:24]
  reg [3:0] rx_dat_next; // @[src/main/scala/fpga/periferals/Sdc.scala 130:28]
  reg  rx_dat_continuous; // @[src/main/scala/fpga/periferals/Sdc.scala 131:34]
  reg  rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 132:29]
  reg  rx_dat_intr_en; // @[src/main/scala/fpga/periferals/Sdc.scala 133:31]
  reg [3:0] rx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_11; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg [3:0] rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23]
  reg  rx_dat_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33]
  reg [18:0] rx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29]
  reg  rx_dat_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 137:31]
  reg  rx_dat_overrun; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31]
  reg [7:0] rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 140:33]
  reg [7:0] rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31]
  reg [18:0] rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30]
  reg  rx_busy_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 143:36]
  reg  rx_dat0_next; // @[src/main/scala/fpga/periferals/Sdc.scala 144:29]
  reg  rx_dat_buf_read; // @[src/main/scala/fpga/periferals/Sdc.scala 145:32]
  reg [31:0] rx_dat_buf_cache; // @[src/main/scala/fpga/periferals/Sdc.scala 146:33]
  reg  reg_tx_dat_wrt; // @[src/main/scala/fpga/periferals/Sdc.scala 147:31]
  reg  reg_tx_dat_out; // @[src/main/scala/fpga/periferals/Sdc.scala 148:31]
  reg  tx_empty_intr_en; // @[src/main/scala/fpga/periferals/Sdc.scala 149:33]
  reg  tx_end_intr_en; // @[src/main/scala/fpga/periferals/Sdc.scala 150:31]
  reg [10:0] tx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 151:31]
  reg [5:0] tx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 152:29]
  reg [3:0] tx_dat_0; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_1; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_2; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_3; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_4; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_5; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_6; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_7; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_8; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_9; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_10; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_11; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_12; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_13; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_14; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_15; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_16; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_17; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_18; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_19; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_20; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_21; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_22; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_23; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19]
  reg [3:0] tx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_11; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [3:0] tx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 154:23]
  reg [31:0] tx_dat_prepared; // @[src/main/scala/fpga/periferals/Sdc.scala 155:32]
  reg [1:0] tx_dat_prepare_state; // @[src/main/scala/fpga/periferals/Sdc.scala 156:37]
  reg  tx_dat_started; // @[src/main/scala/fpga/periferals/Sdc.scala 157:31]
  reg  tx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 159:35]
  reg  tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27]
  reg [1:0] tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 161:32]
  reg [1:0] tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 162:33]
  reg  tx_dat_read_sel_changed; // @[src/main/scala/fpga/periferals/Sdc.scala 163:40]
  reg  tx_dat_write_sel_new; // @[src/main/scala/fpga/periferals/Sdc.scala 164:37]
  reg [3:0] tx_dat_crc_status_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 165:42]
  reg  tx_dat_crc_status_b_0; // @[src/main/scala/fpga/periferals/Sdc.scala 166:32]
  reg  tx_dat_crc_status_b_1; // @[src/main/scala/fpga/periferals/Sdc.scala 166:32]
  reg  tx_dat_crc_status_b_2; // @[src/main/scala/fpga/periferals/Sdc.scala 166:32]
  reg [1:0] tx_dat_crc_status; // @[src/main/scala/fpga/periferals/Sdc.scala 167:34]
  reg  tx_dat_prepared_read; // @[src/main/scala/fpga/periferals/Sdc.scala 168:37]
  wire  _T_2 = tx_cmd_counter == 6'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 170:48]
  wire  _T_5 = _T & reg_clk; // @[src/main/scala/fpga/periferals/Sdc.scala 172:35]
  wire [7:0] _rx_res_timer_T_1 = rx_res_timer - 8'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 174:38]
  wire [7:0] _GEN_4 = rx_res_timer == 8'h1 ? 8'h0 : rx_res_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 175:37 176:26 106:31]
  wire [135:0] _GEN_5 = rx_res_timer == 8'h1 ? 136'h0 : rx_res; // @[src/main/scala/fpga/periferals/Sdc.scala 175:37 177:18 110:23]
  wire  _GEN_6 = rx_res_timer == 8'h1 | rx_res_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 175:37 178:24 111:29]
  wire  _GEN_7 = rx_res_timer == 8'h1 | rx_res_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 175:37 179:26 117:31]
  wire [7:0] _GEN_8 = ~rx_res_in_progress & rx_res_next ? _rx_res_timer_T_1 : rx_res_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 173:49 174:22 116:29]
  wire [7:0] _GEN_9 = ~rx_res_in_progress & rx_res_next ? _GEN_4 : rx_res_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 106:31 173:49]
  wire [135:0] _GEN_10 = ~rx_res_in_progress & rx_res_next ? _GEN_5 : rx_res; // @[src/main/scala/fpga/periferals/Sdc.scala 110:23 173:49]
  wire  _GEN_11 = ~rx_res_in_progress & rx_res_next ? _GEN_6 : rx_res_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 111:29 173:49]
  wire  _GEN_12 = ~rx_res_in_progress & rx_res_next ? _GEN_7 : rx_res_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 117:31 173:49]
  wire [7:0] _rx_res_counter_T_1 = rx_res_counter - 8'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 185:42]
  wire [7:0] rx_res_lo_lo_lo_lo = {rx_res_bits_7,rx_res_bits_6,rx_res_bits_5,rx_res_bits_4,rx_res_bits_3,rx_res_bits_2,
    rx_res_bits_1,rx_res_bits_0}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_lo_lo_lo = {rx_res_bits_16,rx_res_bits_15,rx_res_bits_14,rx_res_bits_13,rx_res_bits_12,
    rx_res_bits_11,rx_res_bits_10,rx_res_bits_9,rx_res_bits_8,rx_res_lo_lo_lo_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_lo_lo_hi_lo = {rx_res_bits_24,rx_res_bits_23,rx_res_bits_22,rx_res_bits_21,rx_res_bits_20,
    rx_res_bits_19,rx_res_bits_18,rx_res_bits_17}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_lo_lo_hi = {rx_res_bits_33,rx_res_bits_32,rx_res_bits_31,rx_res_bits_30,rx_res_bits_29,
    rx_res_bits_28,rx_res_bits_27,rx_res_bits_26,rx_res_bits_25,rx_res_lo_lo_hi_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_lo_hi_lo_lo = {rx_res_bits_41,rx_res_bits_40,rx_res_bits_39,rx_res_bits_38,rx_res_bits_37,
    rx_res_bits_36,rx_res_bits_35,rx_res_bits_34}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_lo_hi_lo = {rx_res_bits_50,rx_res_bits_49,rx_res_bits_48,rx_res_bits_47,rx_res_bits_46,
    rx_res_bits_45,rx_res_bits_44,rx_res_bits_43,rx_res_bits_42,rx_res_lo_hi_lo_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_lo_hi_hi_lo = {rx_res_bits_58,rx_res_bits_57,rx_res_bits_56,rx_res_bits_55,rx_res_bits_54,
    rx_res_bits_53,rx_res_bits_52,rx_res_bits_51}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_lo_hi_hi = {rx_res_bits_67,rx_res_bits_66,rx_res_bits_65,rx_res_bits_64,rx_res_bits_63,
    rx_res_bits_62,rx_res_bits_61,rx_res_bits_60,rx_res_bits_59,rx_res_lo_hi_hi_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_hi_lo_lo_lo = {rx_res_bits_75,rx_res_bits_74,rx_res_bits_73,rx_res_bits_72,rx_res_bits_71,
    rx_res_bits_70,rx_res_bits_69,rx_res_bits_68}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_hi_lo_lo = {rx_res_bits_84,rx_res_bits_83,rx_res_bits_82,rx_res_bits_81,rx_res_bits_80,
    rx_res_bits_79,rx_res_bits_78,rx_res_bits_77,rx_res_bits_76,rx_res_hi_lo_lo_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_hi_lo_hi_lo = {rx_res_bits_92,rx_res_bits_91,rx_res_bits_90,rx_res_bits_89,rx_res_bits_88,
    rx_res_bits_87,rx_res_bits_86,rx_res_bits_85}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_hi_lo_hi = {rx_res_bits_101,rx_res_bits_100,rx_res_bits_99,rx_res_bits_98,rx_res_bits_97,
    rx_res_bits_96,rx_res_bits_95,rx_res_bits_94,rx_res_bits_93,rx_res_hi_lo_hi_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_hi_hi_lo_lo = {rx_res_bits_109,rx_res_bits_108,rx_res_bits_107,rx_res_bits_106,rx_res_bits_105,
    rx_res_bits_104,rx_res_bits_103,rx_res_bits_102}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_hi_hi_lo = {rx_res_bits_118,rx_res_bits_117,rx_res_bits_116,rx_res_bits_115,rx_res_bits_114,
    rx_res_bits_113,rx_res_bits_112,rx_res_bits_111,rx_res_bits_110,rx_res_hi_hi_lo_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [7:0] rx_res_hi_hi_hi_lo = {rx_res_bits_126,rx_res_bits_125,rx_res_bits_124,rx_res_bits_123,rx_res_bits_122,
    rx_res_bits_121,rx_res_bits_120,rx_res_bits_119}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [16:0] rx_res_hi_hi_hi = {rx_res_bits_135,rx_res_bits_134,rx_res_bits_133,rx_res_bits_132,rx_res_bits_131,
    rx_res_bits_130,rx_res_bits_129,rx_res_bits_128,rx_res_bits_127,rx_res_hi_hi_hi_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:28]
  wire [136:0] _rx_res_T_1 = {rx_res_hi_hi_hi,rx_res_hi_hi_lo,rx_res_hi_lo_hi,rx_res_hi_lo_lo,rx_res_lo_hi_hi,
    rx_res_lo_hi_lo,rx_res_lo_lo_hi,rx_res_lo_lo_lo,rx_res_next}; // @[src/main/scala/fpga/periferals/Sdc.scala 199:24]
  wire [6:0] _rx_res_crc_error_T = {rx_res_crc_0,rx_res_crc_1,rx_res_crc_2,rx_res_crc_3,rx_res_crc_4,rx_res_crc_5,
    rx_res_crc_6}; // @[src/main/scala/fpga/periferals/Sdc.scala 201:51]
  wire [18:0] _GEN_13 = rx_res_type == 4'h5 ? 19'h7a120 : rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 202:47 203:27 142:30]
  wire  _GEN_14 = rx_res_counter == 8'h1 ? 1'h0 : 1'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 186:28 196:39 198:30]
  wire [136:0] _GEN_15 = rx_res_counter == 8'h1 ? _rx_res_T_1 : {{1'd0}, _GEN_10}; // @[src/main/scala/fpga/periferals/Sdc.scala 196:39 199:18]
  wire  _GEN_16 = rx_res_counter == 8'h1 | _GEN_11; // @[src/main/scala/fpga/periferals/Sdc.scala 196:39 200:24]
  wire  _GEN_17 = rx_res_counter == 8'h1 ? rx_res_crc_en & _rx_res_crc_error_T != 7'h0 : rx_res_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 196:39 201:28 114:33]
  wire [18:0] _GEN_18 = rx_res_counter == 8'h1 ? _GEN_13 : rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30 196:39]
  wire [5:0] _GEN_19 = rx_res_counter == 8'h1 ? 6'h30 : tx_cmd_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 196:39 205:24 123:29]
  wire [7:0] _GEN_156 = rx_res_in_progress | ~rx_res_next ? _rx_res_counter_T_1 : _GEN_9; // @[src/main/scala/fpga/periferals/Sdc.scala 182:49 185:24]
  wire  _GEN_157 = rx_res_in_progress | ~rx_res_next ? _GEN_14 : rx_res_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 105:35 182:49]
  wire  _GEN_158 = rx_res_in_progress | ~rx_res_next ? rx_res_next ^ rx_res_crc_6 : rx_res_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 188:23]
  wire  _GEN_159 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_0 : rx_res_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 189:23]
  wire  _GEN_160 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_1 : rx_res_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 190:23]
  wire  _GEN_161 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_2 ^ rx_res_crc_6 : rx_res_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 191:23]
  wire  _GEN_162 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_3 : rx_res_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 192:23]
  wire  _GEN_163 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_4 : rx_res_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 193:23]
  wire  _GEN_164 = rx_res_in_progress | ~rx_res_next ? rx_res_crc_5 : rx_res_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 182:49 194:23]
  wire [136:0] _GEN_165 = rx_res_in_progress | ~rx_res_next ? _GEN_15 : {{1'd0}, _GEN_10}; // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
  wire  _GEN_166 = rx_res_in_progress | ~rx_res_next ? _GEN_16 : _GEN_11; // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
  wire  _GEN_167 = rx_res_in_progress | ~rx_res_next ? _GEN_17 : rx_res_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 114:33 182:49]
  wire [18:0] _GEN_168 = rx_res_in_progress | ~rx_res_next ? _GEN_18 : rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30 182:49]
  wire [5:0] _GEN_169 = rx_res_in_progress | ~rx_res_next ? _GEN_19 : tx_cmd_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 123:29 182:49]
  wire [7:0] _GEN_170 = _T & reg_clk ? _GEN_8 : rx_res_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 116:29 172:47]
  wire [7:0] _GEN_171 = _T & reg_clk ? _GEN_156 : rx_res_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 106:31 172:47]
  wire [136:0] _GEN_172 = _T & reg_clk ? _GEN_165 : {{1'd0}, rx_res}; // @[src/main/scala/fpga/periferals/Sdc.scala 110:23 172:47]
  wire  _GEN_173 = _T & reg_clk ? _GEN_166 : rx_res_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 111:29 172:47]
  wire  _GEN_174 = _T & reg_clk ? _GEN_12 : rx_res_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 117:31 172:47]
  wire  _GEN_311 = _T & reg_clk ? _GEN_157 : rx_res_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 105:35 172:47]
  wire  _GEN_312 = _T & reg_clk ? _GEN_158 : rx_res_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_313 = _T & reg_clk ? _GEN_159 : rx_res_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_314 = _T & reg_clk ? _GEN_160 : rx_res_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_315 = _T & reg_clk ? _GEN_161 : rx_res_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_316 = _T & reg_clk ? _GEN_162 : rx_res_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_317 = _T & reg_clk ? _GEN_163 : rx_res_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_318 = _T & reg_clk ? _GEN_164 : rx_res_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 172:47]
  wire  _GEN_319 = _T & reg_clk ? _GEN_167 : rx_res_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 114:33 172:47]
  wire [18:0] _GEN_320 = _T & reg_clk ? _GEN_168 : rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30 172:47]
  wire [7:0] _GEN_323 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_170 : rx_res_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 116:29 170:57]
  wire [7:0] _GEN_324 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_171 : rx_res_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 106:31 170:57]
  wire [136:0] _GEN_325 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_172 : {{1'd0}, rx_res}; // @[src/main/scala/fpga/periferals/Sdc.scala 110:23 170:57]
  wire  _GEN_326 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_173 : rx_res_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 111:29 170:57]
  wire  _GEN_327 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_174 : rx_res_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 117:31 170:57]
  wire  _GEN_464 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_311 : rx_res_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 105:35 170:57]
  wire  _GEN_465 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_312 : rx_res_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_466 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_313 : rx_res_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_467 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_314 : rx_res_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_468 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_315 : rx_res_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_469 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_316 : rx_res_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_470 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_317 : rx_res_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_471 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_318 : rx_res_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 113:23 170:57]
  wire  _GEN_472 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_319 : rx_res_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 114:33 170:57]
  wire [18:0] _GEN_473 = rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0 ? _GEN_320 : rx_busy_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30 170:57]
  wire [5:0] _tx_cmd_timer_T_1 = tx_cmd_timer - 6'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 215:34]
  wire  _T_20 = rx_busy_timer != 19'h0 & _T & reg_clk; // @[src/main/scala/fpga/periferals/Sdc.scala 218:64]
  wire [5:0] _tx_cmd_counter_T_1 = tx_cmd_counter - 6'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 225:38]
  wire  crc__0 = tx_cmd_7 ^ tx_cmd_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 228:17]
  wire  crc__3 = tx_cmd_crc_2 ^ tx_cmd_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 231:21]
  wire  _GEN_475 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_5 : tx_cmd_1; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_476 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_4 : tx_cmd_2; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_477 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_3 : tx_cmd_3; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_478 = tx_cmd_counter == 6'h9 ? crc__3 : tx_cmd_4; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_479 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_1 : tx_cmd_5; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_480 = tx_cmd_counter == 6'h9 ? tx_cmd_crc_0 : tx_cmd_6; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_481 = tx_cmd_counter == 6'h9 ? crc__0 : tx_cmd_7; // @[src/main/scala/fpga/periferals/Sdc.scala 239:35 240:39 224:48]
  wire  _GEN_482 = _T_2 & _T & reg_clk ? 1'h0 : reg_tx_cmd_wrt; // @[src/main/scala/fpga/periferals/Sdc.scala 243:77 244:20 124:31]
  wire  _GEN_484 = tx_cmd_counter > 6'h0 & _T & reg_clk | _GEN_482; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 222:20]
  wire  _GEN_486 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_475 : tx_cmd_0; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_487 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_476 : tx_cmd_1; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_488 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_477 : tx_cmd_2; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_489 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_478 : tx_cmd_3; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_490 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_479 : tx_cmd_4; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_491 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_480 : tx_cmd_5; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_492 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _GEN_481 : tx_cmd_6; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75]
  wire  _GEN_493 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_8 : tx_cmd_7; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_494 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_9 : tx_cmd_8; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_495 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_10 : tx_cmd_9; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_496 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_11 : tx_cmd_10; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_497 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_12 : tx_cmd_11; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_498 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_13 : tx_cmd_12; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_499 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_14 : tx_cmd_13; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_500 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_15 : tx_cmd_14; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_501 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_16 : tx_cmd_15; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_502 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_17 : tx_cmd_16; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_503 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_18 : tx_cmd_17; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_504 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_19 : tx_cmd_18; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_505 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_20 : tx_cmd_19; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_506 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_21 : tx_cmd_20; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_507 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_22 : tx_cmd_21; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_508 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_23 : tx_cmd_22; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_509 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_24 : tx_cmd_23; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_510 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_25 : tx_cmd_24; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_511 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_26 : tx_cmd_25; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_512 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_27 : tx_cmd_26; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_513 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_28 : tx_cmd_27; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_514 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_29 : tx_cmd_28; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_515 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_30 : tx_cmd_29; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_516 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_31 : tx_cmd_30; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_517 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_32 : tx_cmd_31; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_518 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_33 : tx_cmd_32; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_519 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_34 : tx_cmd_33; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_520 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_35 : tx_cmd_34; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_521 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_36 : tx_cmd_35; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_522 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_37 : tx_cmd_36; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_523 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_38 : tx_cmd_37; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_524 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_39 : tx_cmd_38; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_525 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_40 : tx_cmd_39; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_526 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_41 : tx_cmd_40; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_527 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_42 : tx_cmd_41; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_528 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_43 : tx_cmd_42; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_529 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_44 : tx_cmd_43; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_530 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_45 : tx_cmd_44; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_531 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_46 : tx_cmd_45; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire  _GEN_532 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_47 : tx_cmd_46; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 221:75 224:48]
  wire [5:0] _GEN_533 = tx_cmd_counter > 6'h0 & _T & reg_clk ? _tx_cmd_counter_T_1 : tx_cmd_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 225:20 121:31]
  wire  _GEN_534 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__0 : tx_cmd_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_535 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : tx_cmd_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_536 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : tx_cmd_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_537 = tx_cmd_counter > 6'h0 & _T & reg_clk ? crc__3 : tx_cmd_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_538 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : tx_cmd_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_539 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : tx_cmd_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_540 = tx_cmd_counter > 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : tx_cmd_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 221:75 236:16 122:23]
  wire  _GEN_543 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_486; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_544 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_487; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_545 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_488; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_546 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_489; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_547 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_490; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_548 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_491; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_549 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_492; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_550 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_493; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_551 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_494; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_552 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_495; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_553 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_496; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_554 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_497; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_555 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_498; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_556 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_499; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_557 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_500; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_558 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_501; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_559 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_502; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_560 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_503; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_561 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_504; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_562 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_505; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_563 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_506; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_564 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_507; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_565 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_508; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_566 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_509; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_567 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_510; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_568 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_511; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_569 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_512; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_570 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_513; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_571 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_514; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_572 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_515; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_573 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_516; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_574 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_517; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_575 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_518; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_576 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_519; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_577 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_520; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_578 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_521; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_579 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_522; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_580 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_523; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_581 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_524; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_582 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_525; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_583 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_526; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_584 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_527; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_585 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_528; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_586 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_529; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_587 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_530; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_588 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_531; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire  _GEN_589 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_532; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 218:76]
  wire [5:0] _GEN_590 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_533; // @[src/main/scala/fpga/periferals/Sdc.scala 121:31 218:76]
  wire  _GEN_591 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_534; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_592 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_535; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_593 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_536; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_594 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_537; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_595 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_538; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_596 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_539; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_597 = rx_busy_timer != 19'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_540; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 218:76]
  wire  _GEN_601 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_0 : _GEN_543; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_602 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_1 : _GEN_544; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_603 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_2 : _GEN_545; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_604 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_3 : _GEN_546; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_605 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_4 : _GEN_547; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_606 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_5 : _GEN_548; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_607 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_6 : _GEN_549; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_608 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_7 : _GEN_550; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_609 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_8 : _GEN_551; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_610 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_9 : _GEN_552; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_611 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_10 : _GEN_553; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_612 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_11 : _GEN_554; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_613 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_12 : _GEN_555; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_614 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_13 : _GEN_556; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_615 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_14 : _GEN_557; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_616 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_15 : _GEN_558; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_617 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_16 : _GEN_559; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_618 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_17 : _GEN_560; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_619 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_18 : _GEN_561; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_620 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_19 : _GEN_562; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_621 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_20 : _GEN_563; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_622 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_21 : _GEN_564; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_623 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_22 : _GEN_565; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_624 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_23 : _GEN_566; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_625 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_24 : _GEN_567; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_626 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_25 : _GEN_568; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_627 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_26 : _GEN_569; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_628 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_27 : _GEN_570; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_629 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_28 : _GEN_571; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_630 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_29 : _GEN_572; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_631 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_30 : _GEN_573; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_632 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_31 : _GEN_574; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_633 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_32 : _GEN_575; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_634 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_33 : _GEN_576; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_635 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_34 : _GEN_577; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_636 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_35 : _GEN_578; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_637 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_36 : _GEN_579; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_638 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_37 : _GEN_580; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_639 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_38 : _GEN_581; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_640 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_39 : _GEN_582; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_641 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_40 : _GEN_583; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_642 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_41 : _GEN_584; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_643 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_42 : _GEN_585; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_644 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_43 : _GEN_586; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_645 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_44 : _GEN_587; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_646 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_45 : _GEN_588; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire  _GEN_647 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_46 : _GEN_589; // @[src/main/scala/fpga/periferals/Sdc.scala 120:19 214:69]
  wire [5:0] _GEN_648 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_counter : _GEN_590; // @[src/main/scala/fpga/periferals/Sdc.scala 121:31 214:69]
  wire  _GEN_649 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_0 : _GEN_591; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_650 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_1 : _GEN_592; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_651 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_2 : _GEN_593; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_652 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_3 : _GEN_594; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_653 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_4 : _GEN_595; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_654 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_5 : _GEN_596; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_655 = tx_cmd_timer != 6'h0 & _T & reg_clk ? tx_cmd_crc_6 : _GEN_597; // @[src/main/scala/fpga/periferals/Sdc.scala 122:23 214:69]
  wire  _GEN_657 = rx_dat_buf_read ? 1'h0 : rx_dat_buf_read; // @[src/main/scala/fpga/periferals/Sdc.scala 260:26 262:21 145:32]
  wire [31:0] _GEN_658 = tx_dat_prepared_read ? io_sdbuf_rdata1 : tx_dat_prepared; // @[src/main/scala/fpga/periferals/Sdc.scala 264:31 265:21 155:32]
  wire  _GEN_659 = tx_dat_prepared_read ? 1'h0 : tx_dat_prepared_read; // @[src/main/scala/fpga/periferals/Sdc.scala 264:31 266:26 168:37]
  wire  _T_35 = ~rx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 272:13]
  wire [18:0] _rx_dat_timer_T_1 = rx_dat_timer - 19'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 273:38]
  wire  _T_39 = rx_dat_timer == 19'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 274:28]
  wire [7:0] _rxtx_dat_counter_T_1 = rxtx_dat_counter + 8'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 280:48]
  wire [10:0] _GEN_660 = rx_dat_timer == 19'h1 ? 11'h0 : rx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 274:37 275:26 127:31]
  wire  _GEN_661 = rx_dat_timer == 19'h1 | rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 274:37 276:24 132:29]
  wire  _GEN_662 = rx_dat_timer == 19'h1 | rx_dat_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 274:37 277:26 137:31]
  wire  _GEN_664 = rx_dat_timer == 19'h1 | _GEN_657; // @[src/main/scala/fpga/periferals/Sdc.scala 274:37 279:27]
  wire [7:0] _GEN_665 = rx_dat_timer == 19'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 274:37 280:28 140:33]
  wire [10:0] _rx_dat_counter_T_1 = rx_dat_counter - 11'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 287:42]
  wire [3:0] _rx_dat_crc_0_T = rx_dat_next ^ rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 289:38]
  wire [3:0] _rx_dat_crc_5_T = rx_dat_crc_4 ^ rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 294:40]
  wire [3:0] _rx_dat_crc_12_T = rx_dat_crc_11 ^ rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 301:42]
  wire  _T_50 = ~rx_dat_start_bit; // @[src/main/scala/fpga/periferals/Sdc.scala 307:17]
  wire [7:0] _rxtx_dat_index_T_1 = rxtx_dat_index + 8'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 308:46]
  wire [15:0] io_sdbuf_wdata1_lo = {rx_dat_bits_5,rx_dat_bits_4,rx_dat_bits_7,rx_dat_bits_6}; // @[src/main/scala/fpga/periferals/Sdc.scala 310:35]
  wire [15:0] io_sdbuf_wdata1_hi = {rx_dat_bits_1,rx_dat_bits_0,rx_dat_bits_3,rx_dat_bits_2}; // @[src/main/scala/fpga/periferals/Sdc.scala 310:35]
  wire [7:0] _GEN_666 = ~rx_dat_start_bit ? _rxtx_dat_index_T_1 : rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 307:36 308:28 141:31]
  wire  _GEN_669 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? 1'h0 : rx_dat_start_bit; // @[src/main/scala/fpga/periferals/Sdc.scala 305:78 306:28 128:33]
  wire [7:0] _GEN_670 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 ? _GEN_666 : rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31 305:78]
  wire  _GEN_671 = rx_dat_counter[2:0] == 3'h1 & rx_dat_counter[10:4] != 7'h0 & _T_50; // @[src/main/scala/fpga/periferals/Sdc.scala 252:17 305:78]
  wire  _T_51 = rx_dat_counter == 11'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 324:30]
  wire [31:0] crc_error_lo = {rx_dat_crc_8,rx_dat_crc_9,rx_dat_crc_10,rx_dat_crc_11,rx_dat_crc_12,rx_dat_crc_13,
    rx_dat_crc_14,rx_dat_crc_15}; // @[src/main/scala/fpga/periferals/Sdc.scala 330:30]
  wire [63:0] _crc_error_T = {rx_dat_crc_0,rx_dat_crc_1,rx_dat_crc_2,rx_dat_crc_3,rx_dat_crc_4,rx_dat_crc_5,rx_dat_crc_6
    ,rx_dat_crc_7,crc_error_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 330:30]
  wire  crc_error = _crc_error_T != 64'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 330:43]
  wire [10:0] _GEN_673 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 11'h411 : _rx_dat_counter_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 287:24 334:62 335:28]
  wire [18:0] _GEN_674 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 19'h7a120 : rx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 334:62 336:26 136:29]
  wire  _GEN_675 = rx_dat_continuous & ~crc_error & ~rx_dat_ready | _GEN_669; // @[src/main/scala/fpga/periferals/Sdc.scala 334:62 337:30]
  wire [3:0] _GEN_676 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_0_T; // @[src/main/scala/fpga/periferals/Sdc.scala 289:23 334:62 338:24]
  wire [3:0] _GEN_677 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 290:23 334:62 338:24]
  wire [3:0] _GEN_678 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 291:23 334:62 338:24]
  wire [3:0] _GEN_679 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 292:23 334:62 338:24]
  wire [3:0] _GEN_680 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 293:23 334:62 338:24]
  wire [3:0] _GEN_681 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_5_T; // @[src/main/scala/fpga/periferals/Sdc.scala 294:23 334:62 338:24]
  wire [3:0] _GEN_682 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 295:23 334:62 338:24]
  wire [3:0] _GEN_683 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 296:23 334:62 338:24]
  wire [3:0] _GEN_684 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 297:23 334:62 338:24]
  wire [3:0] _GEN_685 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 298:23 334:62 338:24]
  wire [3:0] _GEN_686 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 299:24 334:62 338:24]
  wire [3:0] _GEN_687 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 300:24 334:62 338:24]
  wire [3:0] _GEN_688 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : _rx_dat_crc_12_T; // @[src/main/scala/fpga/periferals/Sdc.scala 301:24 334:62 338:24]
  wire [3:0] _GEN_689 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 302:24 334:62 338:24]
  wire [3:0] _GEN_690 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 303:24 334:62 338:24]
  wire [3:0] _GEN_691 = rx_dat_continuous & ~crc_error & ~rx_dat_ready ? 4'h0 : rx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 304:24 334:62 338:24]
  wire  _GEN_692 = rx_dat_counter == 11'h1 ? 1'h0 : rx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 325:30 126:35]
  wire  _GEN_693 = rx_dat_counter == 11'h1 | rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 326:24 132:29]
  wire  _GEN_695 = rx_dat_counter == 11'h1 | _GEN_657; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 328:27]
  wire [7:0] _GEN_696 = rx_dat_counter == 11'h1 ? _rxtx_dat_counter_T_1 : rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 329:28 140:33]
  wire  _GEN_697 = rx_dat_counter == 11'h1 ? crc_error : rx_dat_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 331:28 135:33]
  wire  _GEN_698 = rx_dat_counter == 11'h1 ? rx_dat_ready : rx_dat_overrun; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39 333:26 138:31]
  wire [10:0] _GEN_699 = rx_dat_counter == 11'h1 ? _GEN_673 : _rx_dat_counter_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 287:24 324:39]
  wire [18:0] _GEN_700 = rx_dat_counter == 11'h1 ? _GEN_674 : rx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29 324:39]
  wire  _GEN_701 = rx_dat_counter == 11'h1 ? _GEN_675 : _GEN_669; // @[src/main/scala/fpga/periferals/Sdc.scala 324:39]
  wire [3:0] _GEN_702 = rx_dat_counter == 11'h1 ? _GEN_676 : _rx_dat_crc_0_T; // @[src/main/scala/fpga/periferals/Sdc.scala 289:23 324:39]
  wire [3:0] _GEN_703 = rx_dat_counter == 11'h1 ? _GEN_677 : rx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 290:23 324:39]
  wire [3:0] _GEN_704 = rx_dat_counter == 11'h1 ? _GEN_678 : rx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 291:23 324:39]
  wire [3:0] _GEN_705 = rx_dat_counter == 11'h1 ? _GEN_679 : rx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 292:23 324:39]
  wire [3:0] _GEN_706 = rx_dat_counter == 11'h1 ? _GEN_680 : rx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 293:23 324:39]
  wire [3:0] _GEN_707 = rx_dat_counter == 11'h1 ? _GEN_681 : _rx_dat_crc_5_T; // @[src/main/scala/fpga/periferals/Sdc.scala 294:23 324:39]
  wire [3:0] _GEN_708 = rx_dat_counter == 11'h1 ? _GEN_682 : rx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 295:23 324:39]
  wire [3:0] _GEN_709 = rx_dat_counter == 11'h1 ? _GEN_683 : rx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 296:23 324:39]
  wire [3:0] _GEN_710 = rx_dat_counter == 11'h1 ? _GEN_684 : rx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 297:23 324:39]
  wire [3:0] _GEN_711 = rx_dat_counter == 11'h1 ? _GEN_685 : rx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 298:23 324:39]
  wire [3:0] _GEN_712 = rx_dat_counter == 11'h1 ? _GEN_686 : rx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 299:24 324:39]
  wire [3:0] _GEN_713 = rx_dat_counter == 11'h1 ? _GEN_687 : rx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 300:24 324:39]
  wire [3:0] _GEN_714 = rx_dat_counter == 11'h1 ? _GEN_688 : _rx_dat_crc_12_T; // @[src/main/scala/fpga/periferals/Sdc.scala 301:24 324:39]
  wire [3:0] _GEN_715 = rx_dat_counter == 11'h1 ? _GEN_689 : rx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 302:24 324:39]
  wire [3:0] _GEN_716 = rx_dat_counter == 11'h1 ? _GEN_690 : rx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 303:24 324:39]
  wire [3:0] _GEN_717 = rx_dat_counter == 11'h1 ? _GEN_691 : rx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 304:24 324:39]
  wire  _GEN_718 = _T_35 & ~rx_dat_next[0] | _GEN_692; // @[src/main/scala/fpga/periferals/Sdc.scala 282:66 283:28]
  wire [10:0] _GEN_727 = _T_35 & ~rx_dat_next[0] ? rx_dat_counter : _GEN_699; // @[src/main/scala/fpga/periferals/Sdc.scala 127:31 282:66]
  wire [3:0] _GEN_728 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_0 : _GEN_702; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_729 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_1 : _GEN_703; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_730 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_2 : _GEN_704; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_731 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_3 : _GEN_705; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_732 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_4 : _GEN_706; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_733 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_5 : _GEN_707; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_734 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_6 : _GEN_708; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_735 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_7 : _GEN_709; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_736 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_8 : _GEN_710; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_737 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_9 : _GEN_711; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_738 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_10 : _GEN_712; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_739 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_11 : _GEN_713; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_740 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_12 : _GEN_714; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_741 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_13 : _GEN_715; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_742 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_14 : _GEN_716; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire [3:0] _GEN_743 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_15 : _GEN_717; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 282:66]
  wire  _GEN_744 = _T_35 & ~rx_dat_next[0] ? rx_dat_start_bit : _GEN_701; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33 282:66]
  wire [7:0] _GEN_745 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_index : _GEN_670; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31 282:66]
  wire  _GEN_746 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _GEN_671; // @[src/main/scala/fpga/periferals/Sdc.scala 252:17 282:66]
  wire  _GEN_748 = _T_35 & ~rx_dat_next[0] ? rx_dat_ready : _GEN_693; // @[src/main/scala/fpga/periferals/Sdc.scala 132:29 282:66]
  wire  _GEN_749 = _T_35 & ~rx_dat_next[0] ? 1'h0 : _T_51; // @[src/main/scala/fpga/periferals/Sdc.scala 255:17 282:66]
  wire  _GEN_750 = _T_35 & ~rx_dat_next[0] ? _GEN_657 : _GEN_695; // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
  wire [7:0] _GEN_751 = _T_35 & ~rx_dat_next[0] ? rxtx_dat_counter : _GEN_696; // @[src/main/scala/fpga/periferals/Sdc.scala 140:33 282:66]
  wire  _GEN_752 = _T_35 & ~rx_dat_next[0] ? rx_dat_crc_error : _GEN_697; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33 282:66]
  wire  _GEN_753 = _T_35 & ~rx_dat_next[0] ? rx_dat_overrun : _GEN_698; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31 282:66]
  wire [18:0] _GEN_754 = _T_35 & ~rx_dat_next[0] ? rx_dat_timer : _GEN_700; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29 282:66]
  wire [18:0] _GEN_755 = ~rx_dat_in_progress & rx_dat_next[0] ? _rx_dat_timer_T_1 : _GEN_754; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59 273:22]
  wire [10:0] _GEN_756 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_660 : _GEN_727; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
  wire  _GEN_757 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_661 : _GEN_748; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
  wire  _GEN_758 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_662 : rx_dat_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 137:31 272:59]
  wire  _GEN_759 = ~rx_dat_in_progress & rx_dat_next[0] ? _T_39 : _GEN_749; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
  wire  _GEN_760 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_664 : _GEN_750; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
  wire [7:0] _GEN_761 = ~rx_dat_in_progress & rx_dat_next[0] ? _GEN_665 : _GEN_751; // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
  wire  _GEN_762 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_in_progress : _GEN_718; // @[src/main/scala/fpga/periferals/Sdc.scala 126:35 272:59]
  wire [3:0] _GEN_771 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_0 : _GEN_728; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_772 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_1 : _GEN_729; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_773 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_2 : _GEN_730; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_774 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_3 : _GEN_731; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_775 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_4 : _GEN_732; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_776 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_5 : _GEN_733; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_777 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_6 : _GEN_734; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_778 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_7 : _GEN_735; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_779 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_8 : _GEN_736; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_780 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_9 : _GEN_737; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_781 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_10 : _GEN_738; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_782 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_11 : _GEN_739; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_783 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_12 : _GEN_740; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_784 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_13 : _GEN_741; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_785 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_14 : _GEN_742; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire [3:0] _GEN_786 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_15 : _GEN_743; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 272:59]
  wire  _GEN_787 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_start_bit : _GEN_744; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33 272:59]
  wire [7:0] _GEN_788 = ~rx_dat_in_progress & rx_dat_next[0] ? rxtx_dat_index : _GEN_745; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31 272:59]
  wire  _GEN_789 = ~rx_dat_in_progress & rx_dat_next[0] ? 1'h0 : _GEN_746; // @[src/main/scala/fpga/periferals/Sdc.scala 252:17 272:59]
  wire  _GEN_791 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_crc_error : _GEN_752; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33 272:59]
  wire  _GEN_792 = ~rx_dat_in_progress & rx_dat_next[0] ? rx_dat_overrun : _GEN_753; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31 272:59]
  wire [18:0] _GEN_793 = _T_5 ? _GEN_755 : rx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29 271:47]
  wire [10:0] _GEN_794 = _T_5 ? _GEN_756 : rx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 127:31 271:47]
  wire  _GEN_795 = _T_5 ? _GEN_757 : rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 132:29 271:47]
  wire  _GEN_796 = _T_5 ? _GEN_758 : rx_dat_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 137:31 271:47]
  wire  _GEN_797 = _T_5 & _GEN_759; // @[src/main/scala/fpga/periferals/Sdc.scala 255:17 271:47]
  wire  _GEN_798 = _T_5 ? _GEN_760 : _GEN_657; // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
  wire [7:0] _GEN_799 = _T_5 ? _GEN_761 : rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 140:33 271:47]
  wire  _GEN_800 = _T_5 ? _GEN_762 : rx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 126:35 271:47]
  wire [3:0] _GEN_809 = _T_5 ? _GEN_771 : rx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_810 = _T_5 ? _GEN_772 : rx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_811 = _T_5 ? _GEN_773 : rx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_812 = _T_5 ? _GEN_774 : rx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_813 = _T_5 ? _GEN_775 : rx_dat_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_814 = _T_5 ? _GEN_776 : rx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_815 = _T_5 ? _GEN_777 : rx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_816 = _T_5 ? _GEN_778 : rx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_817 = _T_5 ? _GEN_779 : rx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_818 = _T_5 ? _GEN_780 : rx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_819 = _T_5 ? _GEN_781 : rx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_820 = _T_5 ? _GEN_782 : rx_dat_crc_11; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_821 = _T_5 ? _GEN_783 : rx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_822 = _T_5 ? _GEN_784 : rx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_823 = _T_5 ? _GEN_785 : rx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire [3:0] _GEN_824 = _T_5 ? _GEN_786 : rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 271:47]
  wire  _GEN_825 = _T_5 ? _GEN_787 : rx_dat_start_bit; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33 271:47]
  wire [7:0] _GEN_826 = _T_5 ? _GEN_788 : rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31 271:47]
  wire  _GEN_827 = _T_5 & _GEN_789; // @[src/main/scala/fpga/periferals/Sdc.scala 252:17 271:47]
  wire  _GEN_829 = _T_5 ? _GEN_791 : rx_dat_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33 271:47]
  wire  _GEN_830 = _T_5 ? _GEN_792 : rx_dat_overrun; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31 271:47]
  wire [18:0] _GEN_832 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_793 : rx_dat_timer; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29 269:57]
  wire [10:0] _GEN_833 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_794 : rx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 127:31 269:57]
  wire  _GEN_834 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_795 : rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 132:29 269:57]
  wire  _GEN_835 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_796 : rx_dat_timeout; // @[src/main/scala/fpga/periferals/Sdc.scala 137:31 269:57]
  wire  _GEN_836 = rx_dat_counter > 11'h0 & _T_2 & _GEN_797; // @[src/main/scala/fpga/periferals/Sdc.scala 255:17 269:57]
  wire  _GEN_837 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_798 : _GEN_657; // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
  wire [7:0] _GEN_838 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_799 : rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 140:33 269:57]
  wire  _GEN_839 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_800 : rx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 126:35 269:57]
  wire [3:0] _GEN_848 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_809 : rx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_849 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_810 : rx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_850 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_811 : rx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_851 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_812 : rx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_852 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_813 : rx_dat_crc_4; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_853 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_814 : rx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_854 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_815 : rx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_855 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_816 : rx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_856 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_817 : rx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_857 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_818 : rx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_858 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_819 : rx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_859 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_820 : rx_dat_crc_11; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_860 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_821 : rx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_861 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_822 : rx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_862 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_823 : rx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire [3:0] _GEN_863 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_824 : rx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 134:23 269:57]
  wire  _GEN_864 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_825 : rx_dat_start_bit; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33 269:57]
  wire [7:0] _GEN_865 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_826 : rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31 269:57]
  wire  _GEN_868 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_829 : rx_dat_crc_error; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33 269:57]
  wire  _GEN_869 = rx_dat_counter > 11'h0 & _T_2 ? _GEN_830 : rx_dat_overrun; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31 269:57]
  wire  _T_58 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new; // @[src/main/scala/fpga/periferals/Sdc.scala 345:77]
  wire [10:0] _GEN_870 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 11'h412
     : tx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 346:20 151:31]
  wire  _GEN_872 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new | _GEN_659; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 348:26]
  wire [7:0] _GEN_873 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ?
    _rxtx_dat_index_T_1 : _GEN_865; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 350:20]
  wire [1:0] _GEN_874 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 2'h2 :
    tx_dat_prepare_state; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 351:26 156:37]
  wire [7:0] _GEN_875 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 8'hff :
    {{2'd0}, tx_dat_timer}; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 352:18 152:29]
  wire  _GEN_876 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_read_sel_changed; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 353:29 163:40]
  wire  _GEN_877 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new ? 1'h0 :
    tx_dat_write_sel_new; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 354:26 164:37]
  wire  _GEN_878 = tx_dat_read_sel_changed & tx_dat_read_sel != tx_dat_write_sel | tx_dat_write_sel_new |
    tx_dat_in_progress; // @[src/main/scala/fpga/periferals/Sdc.scala 345:102 355:24 159:35]
  wire  _T_59 = tx_dat_read_sel == tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 357:53]
  wire  _GEN_879 = tx_dat_read_sel_changed & tx_dat_read_sel == tx_dat_write_sel ? 1'h0 : _GEN_878; // @[src/main/scala/fpga/periferals/Sdc.scala 357:76 358:24]
  wire [18:0] _rx_busy_timer_T_1 = rx_busy_timer - 19'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 365:40]
  wire [18:0] _GEN_880 = ~rx_busy_in_progress & rx_dat0_next ? _rx_busy_timer_T_1 : _GEN_473; // @[src/main/scala/fpga/periferals/Sdc.scala 364:51 365:23]
  wire [3:0] _tx_dat_crc_status_counter_T_1 = tx_dat_crc_status_counter - 4'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 372:66]
  wire [2:0] crc_status = {tx_dat_crc_status_b_2,tx_dat_crc_status_b_1,tx_dat_crc_status_b_0}; // @[src/main/scala/fpga/periferals/Sdc.scala 374:33]
  wire  _tx_dat_crc_status_T = crc_status == 3'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 376:27]
  wire  _tx_dat_crc_status_T_1 = crc_status == 3'h5; // @[src/main/scala/fpga/periferals/Sdc.scala 377:27]
  wire  _tx_dat_crc_status_T_2 = crc_status == 3'h6; // @[src/main/scala/fpga/periferals/Sdc.scala 378:27]
  wire [1:0] _tx_dat_crc_status_T_3 = _tx_dat_crc_status_T_2 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _tx_dat_crc_status_T_4 = _tx_dat_crc_status_T_1 ? 2'h1 : _tx_dat_crc_status_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _tx_dat_crc_status_T_5 = _tx_dat_crc_status_T ? 2'h0 : _tx_dat_crc_status_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _tx_dat_read_sel_T_1 = tx_dat_read_sel + 2'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 383:48]
  wire [1:0] _GEN_882 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_crc_status_T_5 : tx_dat_crc_status; // @[src/main/scala/fpga/periferals/Sdc.scala 373:52 375:31 167:34]
  wire [1:0] _GEN_884 = tx_dat_crc_status_counter == 4'h2 ? _tx_dat_read_sel_T_1 : tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 373:52 383:29 161:32]
  wire  _GEN_885 = tx_dat_crc_status_counter == 4'h2 | _GEN_876; // @[src/main/scala/fpga/periferals/Sdc.scala 373:52 384:37]
  wire  _GEN_886 = tx_dat_started & ~tx_dat_in_progress | tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 390:58 391:26 160:27]
  wire  _GEN_887 = rx_dat0_next ? 1'h0 : 1'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 368:29 387:31 388:33]
  wire [18:0] _GEN_888 = rx_dat0_next ? 19'h0 : _GEN_880; // @[src/main/scala/fpga/periferals/Sdc.scala 387:31 389:27]
  wire  _GEN_889 = rx_dat0_next ? _GEN_886 : tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27 387:31]
  wire [3:0] _GEN_893 = tx_dat_crc_status_counter > 4'h0 ? _tx_dat_crc_status_counter_T_1 : tx_dat_crc_status_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 369:48 372:37 165:42]
  wire [1:0] _GEN_894 = tx_dat_crc_status_counter > 4'h0 ? _GEN_882 : tx_dat_crc_status; // @[src/main/scala/fpga/periferals/Sdc.scala 167:34 369:48]
  wire [1:0] _GEN_896 = tx_dat_crc_status_counter > 4'h0 ? _GEN_884 : tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 161:32 369:48]
  wire  _GEN_897 = tx_dat_crc_status_counter > 4'h0 ? _GEN_885 : _GEN_876; // @[src/main/scala/fpga/periferals/Sdc.scala 369:48]
  wire  _GEN_898 = tx_dat_crc_status_counter > 4'h0 | _GEN_887; // @[src/main/scala/fpga/periferals/Sdc.scala 368:29 369:48]
  wire [18:0] _GEN_899 = tx_dat_crc_status_counter > 4'h0 ? _GEN_880 : _GEN_888; // @[src/main/scala/fpga/periferals/Sdc.scala 369:48]
  wire  _GEN_900 = tx_dat_crc_status_counter > 4'h0 ? tx_dat_end : _GEN_889; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27 369:48]
  wire [3:0] _GEN_905 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_893 : tx_dat_crc_status_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 165:42 367:51]
  wire [1:0] _GEN_908 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_896 : tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 161:32 367:51]
  wire  _GEN_909 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_897 : _GEN_876; // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
  wire [18:0] _GEN_910 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_899 : _GEN_880; // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
  wire  _GEN_911 = rx_busy_in_progress | ~rx_dat0_next ? _GEN_900 : tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27 367:51]
  wire [18:0] _GEN_912 = _T_5 ? _GEN_910 : _GEN_473; // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
  wire [3:0] _GEN_917 = _T_5 ? _GEN_905 : tx_dat_crc_status_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 165:42 363:47]
  wire [1:0] _GEN_920 = _T_5 ? _GEN_908 : tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 161:32 363:47]
  wire  _GEN_921 = _T_5 ? _GEN_909 : _GEN_876; // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
  wire  _GEN_922 = _T_5 ? _GEN_911 : tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27 363:47]
  wire  _GEN_923 = rx_busy_timer > 19'h0 ? io_sdc_port_dat_in[0] : rx_dat0_next; // @[src/main/scala/fpga/periferals/Sdc.scala 361:30 362:18 144:29]
  wire [18:0] _GEN_924 = rx_busy_timer > 19'h0 ? _GEN_912 : _GEN_473; // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
  wire [3:0] _GEN_929 = rx_busy_timer > 19'h0 ? _GEN_917 : tx_dat_crc_status_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 361:30 165:42]
  wire [1:0] _GEN_932 = rx_busy_timer > 19'h0 ? _GEN_920 : tx_dat_read_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 361:30 161:32]
  wire  _GEN_933 = rx_busy_timer > 19'h0 ? _GEN_921 : _GEN_876; // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
  wire  _GEN_934 = rx_busy_timer > 19'h0 ? _GEN_922 : tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27 361:30]
  wire  _GEN_935 = _T_58 ? 1'h0 : _GEN_934; // @[src/main/scala/fpga/periferals/Sdc.scala 399:102 401:16]
  wire [5:0] _tx_dat_timer_T_1 = tx_dat_timer - 6'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 408:34]
  wire [10:0] _tx_dat_counter_T_1 = tx_dat_counter - 11'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 415:38]
  wire [3:0] crc_1_0 = tx_dat_16 ^ tx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 418:18]
  wire [3:0] crc_1_5 = tx_dat_crc_4 ^ tx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 423:21]
  wire [3:0] crc_1_12 = tx_dat_crc_11 ^ tx_dat_crc_15; // @[src/main/scala/fpga/periferals/Sdc.scala 430:22]
  wire  _T_91 = tx_dat_counter[2:0] == 3'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 438:65]
  wire [31:0] _GEN_936 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 32'h0 : _GEN_658; // @[src/main/scala/fpga/periferals/Sdc.scala 444:80 445:23]
  wire [1:0] _GEN_937 = tx_dat_counter[10:4] == 7'h1 & _T_91 ? 2'h1 : _GEN_874; // @[src/main/scala/fpga/periferals/Sdc.scala 444:80 446:28]
  wire  _GEN_938 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _T_58; // @[src/main/scala/fpga/periferals/Sdc.scala 438:74 439:21]
  wire  _GEN_939 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 | _GEN_872; // @[src/main/scala/fpga/periferals/Sdc.scala 438:74 440:28]
  wire [7:0] _GEN_940 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _rxtx_dat_index_T_1 : _GEN_873; // @[src/main/scala/fpga/periferals/Sdc.scala 438:74 442:22]
  wire [1:0] _GEN_941 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? 2'h1 : _GEN_937; // @[src/main/scala/fpga/periferals/Sdc.scala 438:74 443:28]
  wire [31:0] _GEN_942 = tx_dat_counter[10:5] != 6'h0 & tx_dat_counter[2:0] == 3'h2 ? _GEN_658 : _GEN_936; // @[src/main/scala/fpga/periferals/Sdc.scala 438:74]
  wire [3:0] _GEN_943 = tx_dat_counter == 11'h12 ? tx_dat_crc_14 : tx_dat_1; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_944 = tx_dat_counter == 11'h12 ? tx_dat_crc_13 : tx_dat_2; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_945 = tx_dat_counter == 11'h12 ? tx_dat_crc_12 : tx_dat_3; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_946 = tx_dat_counter == 11'h12 ? crc_1_12 : tx_dat_4; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_947 = tx_dat_counter == 11'h12 ? tx_dat_crc_10 : tx_dat_5; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_948 = tx_dat_counter == 11'h12 ? tx_dat_crc_9 : tx_dat_6; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_949 = tx_dat_counter == 11'h12 ? tx_dat_crc_8 : tx_dat_7; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_950 = tx_dat_counter == 11'h12 ? tx_dat_crc_7 : tx_dat_8; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_951 = tx_dat_counter == 11'h12 ? tx_dat_crc_6 : tx_dat_9; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_952 = tx_dat_counter == 11'h12 ? tx_dat_crc_5 : tx_dat_10; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_953 = tx_dat_counter == 11'h12 ? crc_1_5 : tx_dat_11; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_954 = tx_dat_counter == 11'h12 ? tx_dat_crc_3 : tx_dat_12; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_955 = tx_dat_counter == 11'h12 ? tx_dat_crc_2 : tx_dat_13; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_956 = tx_dat_counter == 11'h12 ? tx_dat_crc_1 : tx_dat_14; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_957 = tx_dat_counter == 11'h12 ? tx_dat_crc_0 : tx_dat_15; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_958 = tx_dat_counter == 11'h12 ? crc_1_0 : tx_dat_16; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 449:40 414:50]
  wire [3:0] _GEN_959 = tx_dat_counter == 11'h12 ? 4'hf : tx_dat_17; // @[src/main/scala/fpga/periferals/Sdc.scala 448:36 450:18 414:50]
  wire  _GEN_960 = tx_dat_counter == 11'h1 ? 1'h0 : 1'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 412:20 453:35 454:22]
  wire [18:0] _GEN_962 = tx_dat_counter == 11'h1 ? 19'h7a120 : _GEN_924; // @[src/main/scala/fpga/periferals/Sdc.scala 453:35 456:21]
  wire [3:0] _GEN_963 = tx_dat_counter == 11'h1 ? 4'h6 : _GEN_929; // @[src/main/scala/fpga/periferals/Sdc.scala 453:35 457:33]
  wire [3:0] _GEN_965 = tx_dat_counter != 11'h0 & _T & reg_clk ? tx_dat_0 : {{3'd0}, reg_tx_dat_out}; // @[src/main/scala/fpga/periferals/Sdc.scala 148:31 411:77]
  wire [3:0] _GEN_966 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_943 : tx_dat_0; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_967 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_944 : tx_dat_1; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_968 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_945 : tx_dat_2; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_969 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_946 : tx_dat_3; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_970 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_947 : tx_dat_4; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_971 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_948 : tx_dat_5; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_972 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_949 : tx_dat_6; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_973 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_950 : tx_dat_7; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_974 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_951 : tx_dat_8; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_975 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_952 : tx_dat_9; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_976 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_953 : tx_dat_10; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_977 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_954 : tx_dat_11; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_978 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_955 : tx_dat_12; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_979 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_956 : tx_dat_13; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_980 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_957 : tx_dat_14; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_981 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_958 : tx_dat_15; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire [3:0] _GEN_982 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_959 : tx_dat_16; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 411:77]
  wire  _GEN_1006 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_938 : _T_58; // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
  wire  _GEN_1007 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_939 : _GEN_872; // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
  wire [7:0] _GEN_1008 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_940 : _GEN_873; // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
  wire [1:0] _GEN_1009 = tx_dat_counter != 11'h0 & _T & reg_clk ? _GEN_941 : _GEN_874; // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
  wire [7:0] _GEN_1013 = tx_dat_timer != 6'h0 & _T & reg_clk ? {{2'd0}, _tx_dat_timer_T_1} : _GEN_875; // @[src/main/scala/fpga/periferals/Sdc.scala 407:75 408:18]
  wire [3:0] _GEN_1016 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_0 : _GEN_966; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1017 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_1 : _GEN_967; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1018 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_2 : _GEN_968; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1019 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_3 : _GEN_969; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1020 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_4 : _GEN_970; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1021 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_5 : _GEN_971; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1022 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_6 : _GEN_972; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1023 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_7 : _GEN_973; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1024 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_8 : _GEN_974; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1025 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_9 : _GEN_975; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1026 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_10 : _GEN_976; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1027 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_11 : _GEN_977; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1028 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_12 : _GEN_978; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1029 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_13 : _GEN_979; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1030 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_14 : _GEN_980; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1031 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_15 : _GEN_981; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire [3:0] _GEN_1032 = tx_dat_timer != 6'h0 & _T & reg_clk ? tx_dat_16 : _GEN_982; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 407:75]
  wire  _GEN_1056 = tx_dat_timer != 6'h0 & _T & reg_clk ? _T_58 : _GEN_1006; // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
  wire  _GEN_1057 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_872 : _GEN_1007; // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
  wire [7:0] _GEN_1058 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_873 : _GEN_1008; // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
  wire [1:0] _GEN_1059 = tx_dat_timer != 6'h0 & _T & reg_clk ? _GEN_874 : _GEN_1009; // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
  wire [7:0] _GEN_1065 = _T_20 ? _GEN_875 : _GEN_1013; // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
  wire [3:0] _GEN_1066 = _T_20 ? tx_dat_0 : _GEN_1016; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1067 = _T_20 ? tx_dat_1 : _GEN_1017; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1068 = _T_20 ? tx_dat_2 : _GEN_1018; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1069 = _T_20 ? tx_dat_3 : _GEN_1019; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1070 = _T_20 ? tx_dat_4 : _GEN_1020; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1071 = _T_20 ? tx_dat_5 : _GEN_1021; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1072 = _T_20 ? tx_dat_6 : _GEN_1022; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1073 = _T_20 ? tx_dat_7 : _GEN_1023; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1074 = _T_20 ? tx_dat_8 : _GEN_1024; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1075 = _T_20 ? tx_dat_9 : _GEN_1025; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1076 = _T_20 ? tx_dat_10 : _GEN_1026; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1077 = _T_20 ? tx_dat_11 : _GEN_1027; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1078 = _T_20 ? tx_dat_12 : _GEN_1028; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1079 = _T_20 ? tx_dat_13 : _GEN_1029; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1080 = _T_20 ? tx_dat_14 : _GEN_1030; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1081 = _T_20 ? tx_dat_15 : _GEN_1031; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire [3:0] _GEN_1082 = _T_20 ? tx_dat_16 : _GEN_1032; // @[src/main/scala/fpga/periferals/Sdc.scala 153:19 404:70]
  wire  _GEN_1106 = _T_20 ? _T_58 : _GEN_1056; // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
  wire  _GEN_1107 = _T_20 ? _GEN_872 : _GEN_1057; // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
  wire [7:0] _GEN_1108 = _T_20 ? _GEN_873 : _GEN_1058; // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
  wire [1:0] _GEN_1109 = _T_20 ? _GEN_874 : _GEN_1059; // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
  wire  _GEN_1131 = 2'h2 == tx_dat_prepare_state | _GEN_1106; // @[src/main/scala/fpga/periferals/Sdc.scala 461:33 483:21]
  wire  _GEN_1132 = 2'h2 == tx_dat_prepare_state | _GEN_1107; // @[src/main/scala/fpga/periferals/Sdc.scala 461:33 484:28]
  wire [7:0] _GEN_1133 = 2'h2 == tx_dat_prepare_state ? _rxtx_dat_index_T_1 : _GEN_1108; // @[src/main/scala/fpga/periferals/Sdc.scala 461:33 486:22]
  wire [7:0] _GEN_1163 = 2'h1 == tx_dat_prepare_state ? _GEN_1108 : _GEN_1133; // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
  wire [1:0] addr = io_mem_waddr[3:2]; // @[src/main/scala/fpga/periferals/Sdc.scala 508:28]
  wire [8:0] baud_divider = io_mem_wdata[8:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 511:40]
  wire [47:0] tx_cmd_val = {2'h1,io_mem_wdata[9:4],tx_cmd_arg,7'h0,1'h1}; // @[src/main/scala/fpga/periferals/Sdc.scala 524:31]
  wire  _GEN_1175 = io_mem_wdata[3:0] == 4'h3 ? 1'h0 : 1'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 533:25 542:59 544:27]
  wire [7:0] _GEN_1176 = io_mem_wdata[3:0] == 4'h2 ? 8'h88 : 8'h30; // @[src/main/scala/fpga/periferals/Sdc.scala 539:59 540:28]
  wire  _GEN_1177 = io_mem_wdata[3:0] == 4'h2 ? 1'h0 : _GEN_1175; // @[src/main/scala/fpga/periferals/Sdc.scala 539:59 541:27]
  wire [7:0] _GEN_1178 = io_mem_wdata[3:0] == 4'h0 ? 8'h0 : _GEN_1176; // @[src/main/scala/fpga/periferals/Sdc.scala 537:55 538:28]
  wire  _GEN_1179 = io_mem_wdata[3:0] == 4'h0 | _GEN_1177; // @[src/main/scala/fpga/periferals/Sdc.scala 533:25 537:55]
  wire  _GEN_1180 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_839; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 549:32]
  wire [10:0] _GEN_1181 = io_mem_wdata[12] | io_mem_wdata[13] ? 11'h411 : 11'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 550:28 562:28]
  wire  _GEN_1182 = io_mem_wdata[12] | io_mem_wdata[13] | _GEN_864; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 551:30]
  wire [3:0] _GEN_1184 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_848; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1185 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_849; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1186 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_850; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1187 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_851; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1188 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_852; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1189 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_853; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1190 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_854; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1191 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_855; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1192 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_856; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1193 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_857; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1194 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_858; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1195 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_859; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1196 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_860; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1197 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_861; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1198 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_862; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire [3:0] _GEN_1199 = io_mem_wdata[12] | io_mem_wdata[13] ? 4'h0 : _GEN_863; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 553:24]
  wire  _GEN_1200 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_868; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 554:30]
  wire [18:0] _GEN_1201 = io_mem_wdata[12] | io_mem_wdata[13] ? 19'h7a120 : _GEN_832; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 555:26]
  wire  _GEN_1202 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_835; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 556:28]
  wire  _GEN_1203 = io_mem_wdata[12] | io_mem_wdata[13] ? io_mem_wdata[13] : rx_dat_continuous; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 557:31 131:34]
  wire  _GEN_1204 = io_mem_wdata[12] | io_mem_wdata[13] ? 1'h0 : _GEN_869; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 558:28]
  wire [7:0] _GEN_1205 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_1163; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 559:28]
  wire [7:0] _GEN_1206 = io_mem_wdata[12] | io_mem_wdata[13] ? 8'h0 : _GEN_838; // @[src/main/scala/fpga/periferals/Sdc.scala 548:69 560:30]
  wire  _T_179 = io_mem_wdata[14] | io_mem_wdata[15]; // @[src/main/scala/fpga/periferals/Sdc.scala 565:41]
  wire [1:0] _GEN_1209 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : _GEN_932; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 568:29]
  wire [1:0] _GEN_1210 = io_mem_wdata[14] | io_mem_wdata[15] ? 2'h0 : tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 569:30 162:33]
  wire  _GEN_1211 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_933; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 570:37]
  wire  _GEN_1212 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_877; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 571:34]
  wire  _GEN_1213 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_879; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 572:32]
  wire  _GEN_1214 = io_mem_wdata[14] | io_mem_wdata[15] ? 1'h0 : _GEN_935; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 573:24]
  wire [7:0] _GEN_1215 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1205; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 574:28]
  wire [7:0] _GEN_1216 = io_mem_wdata[14] | io_mem_wdata[15] ? 8'h0 : _GEN_1206; // @[src/main/scala/fpga/periferals/Sdc.scala 565:69 575:30]
  wire [5:0] _GEN_1265 = io_mem_wdata[11] ? 6'h30 : _GEN_648; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 526:26]
  wire [3:0] _GEN_1273 = io_mem_wdata[11] ? io_mem_wdata[3:0] : rx_res_type; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 528:23 109:28]
  wire  _GEN_1274 = io_mem_wdata[11] ? 1'h0 : _GEN_464; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 529:30]
  wire  _GEN_1275 = io_mem_wdata[11] ? 1'h0 : _GEN_326; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 530:24]
  wire  _GEN_1283 = io_mem_wdata[11] ? 1'h0 : _GEN_472; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 532:28]
  wire  _GEN_1284 = io_mem_wdata[11] ? _GEN_1179 : rx_res_crc_en; // @[src/main/scala/fpga/periferals/Sdc.scala 115:30 523:40]
  wire [7:0] _GEN_1285 = io_mem_wdata[11] ? 8'hff : _GEN_323; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 534:24]
  wire  _GEN_1286 = io_mem_wdata[11] ? 1'h0 : _GEN_327; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 535:26]
  wire [1:0] _GEN_1287 = io_mem_wdata[11] ? 2'h0 : rx_res_read_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40 536:31 118:36]
  wire [7:0] _GEN_1288 = io_mem_wdata[11] ? _GEN_1178 : _GEN_324; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1289 = io_mem_wdata[11] ? _GEN_1180 : _GEN_839; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [10:0] _GEN_1290 = io_mem_wdata[11] ? _GEN_1181 : _GEN_833; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1291 = io_mem_wdata[11] ? _GEN_1182 : _GEN_864; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1292 = io_mem_wdata[11] ? 1'h0 : _GEN_834; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1309 = io_mem_wdata[11] ? _GEN_1200 : _GEN_868; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [18:0] _GEN_1310 = io_mem_wdata[11] ? _GEN_1201 : _GEN_832; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1311 = io_mem_wdata[11] ? _GEN_1202 : _GEN_835; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1312 = io_mem_wdata[11] ? _GEN_1203 : rx_dat_continuous; // @[src/main/scala/fpga/periferals/Sdc.scala 131:34 523:40]
  wire  _GEN_1313 = io_mem_wdata[11] ? _GEN_1204 : _GEN_869; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [7:0] _GEN_1314 = io_mem_wdata[11] ? _GEN_1215 : _GEN_1163; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [7:0] _GEN_1315 = io_mem_wdata[11] ? _GEN_1216 : _GEN_838; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1316 = io_mem_wdata[11] ? _T_179 : tx_dat_started; // @[src/main/scala/fpga/periferals/Sdc.scala 157:31 523:40]
  wire [1:0] _GEN_1318 = io_mem_wdata[11] ? _GEN_1209 : _GEN_932; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [1:0] _GEN_1319 = io_mem_wdata[11] ? _GEN_1210 : tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 162:33 523:40]
  wire  _GEN_1320 = io_mem_wdata[11] ? _GEN_1211 : _GEN_933; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1321 = io_mem_wdata[11] ? _GEN_1212 : _GEN_877; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1322 = io_mem_wdata[11] ? _GEN_1213 : _GEN_879; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire  _GEN_1323 = io_mem_wdata[11] ? _GEN_1214 : _GEN_935; // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
  wire [1:0] _T_182 = tx_dat_read_sel ^ tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 586:32]
  wire  _T_183 = _T_182 != 2'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 586:52]
  wire [7:0] _GEN_1324 = _T_182 != 2'h2 ? _rxtx_dat_counter_T_1 : _GEN_838; // @[src/main/scala/fpga/periferals/Sdc.scala 586:65 587:28]
  wire  _T_185 = rxtx_dat_counter[6:0] == 7'h7f; // @[src/main/scala/fpga/periferals/Sdc.scala 592:38]
  wire [1:0] _tx_dat_write_sel_T_1 = tx_dat_write_sel + 2'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 593:48]
  wire  _GEN_1327 = _T_59 | _GEN_877; // @[src/main/scala/fpga/periferals/Sdc.scala 594:55 595:34]
  wire [1:0] _GEN_1328 = rxtx_dat_counter[6:0] == 7'h7f ? _tx_dat_write_sel_T_1 : tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 592:49 593:28 162:33]
  wire  _GEN_1329 = rxtx_dat_counter[6:0] == 7'h7f ? _GEN_1327 : _GEN_877; // @[src/main/scala/fpga/periferals/Sdc.scala 592:49]
  wire [7:0] _GEN_1330 = 2'h3 == addr ? _GEN_1324 : _GEN_838; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [1:0] _GEN_1333 = 2'h3 == addr ? _GEN_1328 : tx_dat_write_sel; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19 162:33]
  wire  _GEN_1334 = 2'h3 == addr ? _GEN_1329 : _GEN_877; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [31:0] _GEN_1335 = 2'h2 == addr ? io_mem_wdata : tx_cmd_arg; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19 583:20 119:27]
  wire [7:0] _GEN_1336 = 2'h2 == addr ? _GEN_838 : _GEN_1330; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire  _GEN_1337 = 2'h2 == addr ? 1'h0 : 2'h3 == addr & _T_183; // @[src/main/scala/fpga/periferals/Sdc.scala 256:17 509:19]
  wire [1:0] _GEN_1339 = 2'h2 == addr ? tx_dat_write_sel : _GEN_1333; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19 162:33]
  wire  _GEN_1340 = 2'h2 == addr ? _GEN_877 : _GEN_1334; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire  _GEN_1399 = 2'h1 == addr ? _GEN_1275 : _GEN_326; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [1:0] _GEN_1411 = 2'h1 == addr ? _GEN_1287 : rx_res_read_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19 118:36]
  wire  _GEN_1416 = 2'h1 == addr ? _GEN_1292 : _GEN_834; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [7:0] _GEN_1439 = 2'h1 == addr ? _GEN_1315 : _GEN_1336; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire  _GEN_1449 = 2'h1 == addr ? 1'h0 : _GEN_1337; // @[src/main/scala/fpga/periferals/Sdc.scala 256:17 509:19]
  wire  _GEN_1516 = 2'h0 == addr ? _GEN_326 : _GEN_1399; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [1:0] _GEN_1528 = 2'h0 == addr ? rx_res_read_counter : _GEN_1411; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19 118:36]
  wire  _GEN_1533 = 2'h0 == addr ? _GEN_834 : _GEN_1416; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire [7:0] _GEN_1556 = 2'h0 == addr ? _GEN_838 : _GEN_1439; // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
  wire  _GEN_1566 = 2'h0 == addr ? 1'h0 : _GEN_1449; // @[src/main/scala/fpga/periferals/Sdc.scala 256:17 509:19]
  wire  _GEN_1633 = io_mem_wen ? _GEN_1516 : _GEN_326; // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
  wire [1:0] _GEN_1645 = io_mem_wen ? _GEN_1528 : rx_res_read_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 507:21 118:36]
  wire  _GEN_1650 = io_mem_wen ? _GEN_1533 : _GEN_834; // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
  wire [7:0] _GEN_1673 = io_mem_wen ? _GEN_1556 : _GEN_838; // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
  wire [1:0] addr_1 = io_mem_raddr[3:2]; // @[src/main/scala/fpga/periferals/Sdc.scala 602:28]
  wire [31:0] _reg_rdata_T = {reg_power,11'h0,tx_end_intr_en,tx_empty_intr_en,rx_dat_intr_en,rx_res_intr_en,7'h0,
    reg_baud_divider}; // @[src/main/scala/fpga/periferals/Sdc.scala 605:25]
  wire  _reg_rdata_T_1 = tx_dat_started & tx_dat_end; // @[src/main/scala/fpga/periferals/Sdc.scala 620:26]
  wire  _reg_rdata_T_4 = tx_dat_started & _T_182 == 2'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 621:26]
  wire [17:0] reg_rdata_lo_1 = {rx_dat_crc_error,rx_dat_ready,13'h0,rx_res_timeout,rx_res_crc_error,rx_res_ready}; // @[src/main/scala/fpga/periferals/Sdc.scala 617:25]
  wire [31:0] _reg_rdata_T_5 = {8'h0,tx_dat_crc_status,_reg_rdata_T_1,_reg_rdata_T_4,rx_dat_overrun,rx_dat_timeout,
    reg_rdata_lo_1}; // @[src/main/scala/fpga/periferals/Sdc.scala 617:25]
  wire [1:0] _rx_res_read_counter_T_1 = rx_res_read_counter + 2'h1; // @[src/main/scala/fpga/periferals/Sdc.scala 633:52]
  wire [6:0] _reg_rdata_T_6 = {rx_res_read_counter,5'h0}; // @[src/main/scala/fpga/periferals/Sdc.scala 635:38]
  wire [135:0] _reg_rdata_T_7 = rx_res >> _reg_rdata_T_6; // @[src/main/scala/fpga/periferals/Sdc.scala 635:32]
  wire  _GEN_1685 = rx_res_read_counter == 2'h3 ? 1'h0 : _GEN_1633; // @[src/main/scala/fpga/periferals/Sdc.scala 636:46 637:26]
  wire [31:0] _GEN_1686 = rx_res_type == 4'h2 ? _reg_rdata_T_7[31:0] : rx_res[39:8]; // @[src/main/scala/fpga/periferals/Sdc.scala 634:44 635:21 640:21]
  wire  _GEN_1687 = rx_res_type == 4'h2 & _GEN_1685; // @[src/main/scala/fpga/periferals/Sdc.scala 634:44 641:24]
  wire  _GEN_1688 = _T_185 ? 1'h0 : _GEN_1650; // @[src/main/scala/fpga/periferals/Sdc.scala 651:51 652:26]
  wire [7:0] _GEN_1689 = rx_dat_ready ? _rxtx_dat_counter_T_1 : _GEN_1673; // @[src/main/scala/fpga/periferals/Sdc.scala 646:29 647:28]
  wire  _GEN_1690 = rx_dat_ready | _GEN_836; // @[src/main/scala/fpga/periferals/Sdc.scala 646:29 648:25]
  wire  _GEN_1691 = rx_dat_ready | _GEN_837; // @[src/main/scala/fpga/periferals/Sdc.scala 646:29 649:27]
  wire  _GEN_1692 = rx_dat_ready ? _GEN_1688 : _GEN_1650; // @[src/main/scala/fpga/periferals/Sdc.scala 646:29]
  wire [31:0] _GEN_1693 = 2'h3 == addr_1 ? rx_dat_buf_cache : reg_rdata; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19 645:19 92:26]
  wire [7:0] _GEN_1694 = 2'h3 == addr_1 ? _GEN_1689 : _GEN_1673; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1695 = 2'h3 == addr_1 ? _GEN_1690 : _GEN_836; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1696 = 2'h3 == addr_1 ? _GEN_1691 : _GEN_837; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1697 = 2'h3 == addr_1 ? _GEN_1692 : _GEN_1650; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire [1:0] _GEN_1698 = 2'h2 == addr_1 ? _rx_res_read_counter_T_1 : _GEN_1645; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19 633:29]
  wire [31:0] _GEN_1699 = 2'h2 == addr_1 ? _GEN_1686 : _GEN_1693; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1700 = 2'h2 == addr_1 ? _GEN_1687 : _GEN_1633; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire [7:0] _GEN_1701 = 2'h2 == addr_1 ? _GEN_1673 : _GEN_1694; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1702 = 2'h2 == addr_1 ? _GEN_836 : _GEN_1695; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1703 = 2'h2 == addr_1 ? _GEN_837 : _GEN_1696; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1704 = 2'h2 == addr_1 ? _GEN_1650 : _GEN_1697; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1709 = 2'h1 == addr_1 ? _GEN_836 : _GEN_1702; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _GEN_1716 = 2'h0 == addr_1 ? _GEN_836 : _GEN_1709; // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
  wire  _io_intr_T_1 = rx_dat_intr_en & rx_dat_ready; // @[src/main/scala/fpga/periferals/Sdc.scala 660:21]
  wire  _io_intr_T_2 = rx_res_intr_en & rx_res_ready | _io_intr_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 659:47]
  wire  _io_intr_T_6 = tx_empty_intr_en & tx_dat_started & _T_183; // @[src/main/scala/fpga/periferals/Sdc.scala 661:41]
  wire  _T_198 = ~reset; // @[src/main/scala/fpga/periferals/Sdc.scala 664:9]
  wire [136:0] _GEN_1726 = reset ? 137'h0 : _GEN_325; // @[src/main/scala/fpga/periferals/Sdc.scala 110:{23,23}]
  wire [3:0] _GEN_1727 = reset ? 4'h0 : _GEN_965; // @[src/main/scala/fpga/periferals/Sdc.scala 148:{31,31}]
  wire [7:0] _GEN_1728 = reset ? 8'h0 : _GEN_1065; // @[src/main/scala/fpga/periferals/Sdc.scala 152:{29,29}]
  assign io_mem_rdata = reg_rdata; // @[src/main/scala/fpga/periferals/Sdc.scala 502:16]
  assign io_sdc_port_clk = reg_clk; // @[src/main/scala/fpga/periferals/Sdc.scala 103:19]
  assign io_sdc_port_cmd_wrt = reg_tx_cmd_wrt; // @[src/main/scala/fpga/periferals/Sdc.scala 211:23]
  assign io_sdc_port_cmd_out = reg_tx_cmd_out; // @[src/main/scala/fpga/periferals/Sdc.scala 212:23]
  assign io_sdc_port_dat_wrt = reg_tx_dat_wrt; // @[src/main/scala/fpga/periferals/Sdc.scala 248:23]
  assign io_sdc_port_dat_out = {{3'd0}, reg_tx_dat_out}; // @[src/main/scala/fpga/periferals/Sdc.scala 249:23]
  assign io_sdbuf_ren1 = 2'h1 == tx_dat_prepare_state ? _GEN_1106 : _GEN_1131; // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
  assign io_sdbuf_wen1 = rx_dat_counter > 11'h0 & _T_2 & _GEN_827; // @[src/main/scala/fpga/periferals/Sdc.scala 252:17 269:57]
  assign io_sdbuf_addr1 = rxtx_dat_index; // @[src/main/scala/fpga/periferals/Sdc.scala 253:18]
  assign io_sdbuf_wdata1 = {io_sdbuf_wdata1_hi,io_sdbuf_wdata1_lo}; // @[src/main/scala/fpga/periferals/Sdc.scala 310:35]
  assign io_sdbuf_ren2 = io_mem_ren ? _GEN_1716 : _GEN_836; // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
  assign io_sdbuf_wen2 = io_mem_wen & _GEN_1566; // @[src/main/scala/fpga/periferals/Sdc.scala 256:17 507:21]
  assign io_sdbuf_addr2 = rxtx_dat_counter; // @[src/main/scala/fpga/periferals/Sdc.scala 257:18]
  assign io_sdbuf_wdata2 = io_mem_wdata; // @[src/main/scala/fpga/periferals/Sdc.scala 586:65 589:27]
  assign io_intr = _io_intr_T_2 | _io_intr_T_6; // @[src/main/scala/fpga/periferals/Sdc.scala 660:38]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 88:26]
      reg_power <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 88:26]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (baud_divider != 9'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 512:37]
          reg_power <= io_mem_wdata[31]; // @[src/main/scala/fpga/periferals/Sdc.scala 513:21]
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 89:33]
      reg_baud_divider <= 9'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 89:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (baud_divider != 9'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 512:37]
          reg_baud_divider <= baud_divider; // @[src/main/scala/fpga/periferals/Sdc.scala 514:28]
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 90:32]
      reg_clk_counter <= 9'h2; // @[src/main/scala/fpga/periferals/Sdc.scala 90:32]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (baud_divider != 9'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 512:37]
          reg_clk_counter <= baud_divider; // @[src/main/scala/fpga/periferals/Sdc.scala 515:27]
        end else begin
          reg_clk_counter <= _GEN_2;
        end
      end else begin
        reg_clk_counter <= _GEN_2;
      end
    end else begin
      reg_clk_counter <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 91:24]
      reg_clk <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 91:24]
    end else begin
      reg_clk <= _GEN_3;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 92:26]
      reg_rdata <= 32'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 92:26]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        reg_rdata <= _reg_rdata_T; // @[src/main/scala/fpga/periferals/Sdc.scala 605:19]
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        reg_rdata <= _reg_rdata_T_5; // @[src/main/scala/fpga/periferals/Sdc.scala 617:19]
      end else begin
        reg_rdata <= _GEN_1699;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 105:35]
      rx_res_in_progress <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 105:35]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_in_progress <= _GEN_464;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_in_progress <= _GEN_1274;
      end else begin
        rx_res_in_progress <= _GEN_464;
      end
    end else begin
      rx_res_in_progress <= _GEN_464;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 106:31]
      rx_res_counter <= 8'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 106:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_counter <= _GEN_324;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_counter <= _GEN_1288;
      end else begin
        rx_res_counter <= _GEN_324;
      end
    end else begin
      rx_res_counter <= _GEN_324;
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_0 <= rx_res_next; // @[src/main/scala/fpga/periferals/Sdc.scala 184:24]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_1 <= rx_res_bits_0; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_2 <= rx_res_bits_1; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_3 <= rx_res_bits_2; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_4 <= rx_res_bits_3; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_5 <= rx_res_bits_4; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_6 <= rx_res_bits_5; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_7 <= rx_res_bits_6; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_8 <= rx_res_bits_7; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_9 <= rx_res_bits_8; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_10 <= rx_res_bits_9; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_11 <= rx_res_bits_10; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_12 <= rx_res_bits_11; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_13 <= rx_res_bits_12; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_14 <= rx_res_bits_13; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_15 <= rx_res_bits_14; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_16 <= rx_res_bits_15; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_17 <= rx_res_bits_16; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_18 <= rx_res_bits_17; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_19 <= rx_res_bits_18; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_20 <= rx_res_bits_19; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_21 <= rx_res_bits_20; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_22 <= rx_res_bits_21; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_23 <= rx_res_bits_22; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_24 <= rx_res_bits_23; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_25 <= rx_res_bits_24; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_26 <= rx_res_bits_25; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_27 <= rx_res_bits_26; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_28 <= rx_res_bits_27; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_29 <= rx_res_bits_28; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_30 <= rx_res_bits_29; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_31 <= rx_res_bits_30; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_32 <= rx_res_bits_31; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_33 <= rx_res_bits_32; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_34 <= rx_res_bits_33; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_35 <= rx_res_bits_34; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_36 <= rx_res_bits_35; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_37 <= rx_res_bits_36; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_38 <= rx_res_bits_37; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_39 <= rx_res_bits_38; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_40 <= rx_res_bits_39; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_41 <= rx_res_bits_40; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_42 <= rx_res_bits_41; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_43 <= rx_res_bits_42; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_44 <= rx_res_bits_43; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_45 <= rx_res_bits_44; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_46 <= rx_res_bits_45; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_47 <= rx_res_bits_46; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_48 <= rx_res_bits_47; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_49 <= rx_res_bits_48; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_50 <= rx_res_bits_49; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_51 <= rx_res_bits_50; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_52 <= rx_res_bits_51; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_53 <= rx_res_bits_52; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_54 <= rx_res_bits_53; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_55 <= rx_res_bits_54; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_56 <= rx_res_bits_55; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_57 <= rx_res_bits_56; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_58 <= rx_res_bits_57; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_59 <= rx_res_bits_58; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_60 <= rx_res_bits_59; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_61 <= rx_res_bits_60; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_62 <= rx_res_bits_61; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_63 <= rx_res_bits_62; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_64 <= rx_res_bits_63; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_65 <= rx_res_bits_64; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_66 <= rx_res_bits_65; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_67 <= rx_res_bits_66; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_68 <= rx_res_bits_67; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_69 <= rx_res_bits_68; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_70 <= rx_res_bits_69; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_71 <= rx_res_bits_70; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_72 <= rx_res_bits_71; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_73 <= rx_res_bits_72; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_74 <= rx_res_bits_73; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_75 <= rx_res_bits_74; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_76 <= rx_res_bits_75; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_77 <= rx_res_bits_76; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_78 <= rx_res_bits_77; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_79 <= rx_res_bits_78; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_80 <= rx_res_bits_79; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_81 <= rx_res_bits_80; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_82 <= rx_res_bits_81; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_83 <= rx_res_bits_82; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_84 <= rx_res_bits_83; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_85 <= rx_res_bits_84; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_86 <= rx_res_bits_85; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_87 <= rx_res_bits_86; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_88 <= rx_res_bits_87; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_89 <= rx_res_bits_88; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_90 <= rx_res_bits_89; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_91 <= rx_res_bits_90; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_92 <= rx_res_bits_91; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_93 <= rx_res_bits_92; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_94 <= rx_res_bits_93; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_95 <= rx_res_bits_94; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_96 <= rx_res_bits_95; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_97 <= rx_res_bits_96; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_98 <= rx_res_bits_97; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_99 <= rx_res_bits_98; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_100 <= rx_res_bits_99; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_101 <= rx_res_bits_100; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_102 <= rx_res_bits_101; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_103 <= rx_res_bits_102; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_104 <= rx_res_bits_103; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_105 <= rx_res_bits_104; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_106 <= rx_res_bits_105; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_107 <= rx_res_bits_106; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_108 <= rx_res_bits_107; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_109 <= rx_res_bits_108; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_110 <= rx_res_bits_109; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_111 <= rx_res_bits_110; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_112 <= rx_res_bits_111; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_113 <= rx_res_bits_112; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_114 <= rx_res_bits_113; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_115 <= rx_res_bits_114; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_116 <= rx_res_bits_115; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_117 <= rx_res_bits_116; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_118 <= rx_res_bits_117; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_119 <= rx_res_bits_118; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_120 <= rx_res_bits_119; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_121 <= rx_res_bits_120; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_122 <= rx_res_bits_121; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_123 <= rx_res_bits_122; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_124 <= rx_res_bits_123; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_125 <= rx_res_bits_124; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_126 <= rx_res_bits_125; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_127 <= rx_res_bits_126; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_128 <= rx_res_bits_127; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_129 <= rx_res_bits_128; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_130 <= rx_res_bits_129; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_131 <= rx_res_bits_130; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_132 <= rx_res_bits_131; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_133 <= rx_res_bits_132; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_134 <= rx_res_bits_133; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        if (rx_res_in_progress | ~rx_res_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 182:49]
          rx_res_bits_135 <= rx_res_bits_134; // @[src/main/scala/fpga/periferals/Sdc.scala 183:61]
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 108:28]
      rx_res_next <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 108:28]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      rx_res_next <= io_sdc_port_res_in; // @[src/main/scala/fpga/periferals/Sdc.scala 171:17]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 109:28]
      rx_res_type <= 4'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 109:28]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          rx_res_type <= _GEN_1273;
        end
      end
    end
    rx_res <= _GEN_1726[135:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 110:{23,23}]
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 111:29]
      rx_res_ready <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 111:29]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_res_ready <= _GEN_1633;
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_res_ready <= _GEN_1633;
      end else begin
        rx_res_ready <= _GEN_1700;
      end
    end else begin
      rx_res_ready <= _GEN_1633;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 112:31]
      rx_res_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 112:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_intr_en <= io_mem_wdata[16]; // @[src/main/scala/fpga/periferals/Sdc.scala 517:26]
      end
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_0 <= _GEN_465;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_0 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_0 <= _GEN_465;
        end
      end else begin
        rx_res_crc_0 <= _GEN_465;
      end
    end else begin
      rx_res_crc_0 <= _GEN_465;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_1 <= _GEN_466;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_1 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_1 <= _GEN_466;
        end
      end else begin
        rx_res_crc_1 <= _GEN_466;
      end
    end else begin
      rx_res_crc_1 <= _GEN_466;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_2 <= _GEN_467;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_2 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_2 <= _GEN_467;
        end
      end else begin
        rx_res_crc_2 <= _GEN_467;
      end
    end else begin
      rx_res_crc_2 <= _GEN_467;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_3 <= _GEN_468;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_3 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_3 <= _GEN_468;
        end
      end else begin
        rx_res_crc_3 <= _GEN_468;
      end
    end else begin
      rx_res_crc_3 <= _GEN_468;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_4 <= _GEN_469;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_4 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_4 <= _GEN_469;
        end
      end else begin
        rx_res_crc_4 <= _GEN_469;
      end
    end else begin
      rx_res_crc_4 <= _GEN_469;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_5 <= _GEN_470;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_5 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_5 <= _GEN_470;
        end
      end else begin
        rx_res_crc_5 <= _GEN_470;
      end
    end else begin
      rx_res_crc_5 <= _GEN_470;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_6 <= _GEN_471;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          rx_res_crc_6 <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 531:22]
        end else begin
          rx_res_crc_6 <= _GEN_471;
        end
      end else begin
        rx_res_crc_6 <= _GEN_471;
      end
    end else begin
      rx_res_crc_6 <= _GEN_471;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 114:33]
      rx_res_crc_error <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 114:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_error <= _GEN_472;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_crc_error <= _GEN_1283;
      end else begin
        rx_res_crc_error <= _GEN_472;
      end
    end else begin
      rx_res_crc_error <= _GEN_472;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 115:30]
      rx_res_crc_en <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 115:30]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          rx_res_crc_en <= _GEN_1284;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 116:29]
      rx_res_timer <= 8'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 116:29]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_timer <= _GEN_323;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_timer <= _GEN_1285;
      end else begin
        rx_res_timer <= _GEN_323;
      end
    end else begin
      rx_res_timer <= _GEN_323;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 117:31]
      rx_res_timeout <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 117:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_timeout <= _GEN_327;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_res_timeout <= _GEN_1286;
      end else begin
        rx_res_timeout <= _GEN_327;
      end
    end else begin
      rx_res_timeout <= _GEN_327;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 118:36]
      rx_res_read_counter <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 118:36]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_res_read_counter <= _GEN_1645;
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_res_read_counter <= _GEN_1645;
      end else begin
        rx_res_read_counter <= _GEN_1698;
      end
    end else begin
      rx_res_read_counter <= _GEN_1645;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 119:27]
      tx_cmd_arg <= 32'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 119:27]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (!(2'h1 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          tx_cmd_arg <= _GEN_1335;
        end
      end
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_0 <= _GEN_601;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_0 <= tx_cmd_val[47]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_0 <= _GEN_601;
        end
      end else begin
        tx_cmd_0 <= _GEN_601;
      end
    end else begin
      tx_cmd_0 <= _GEN_601;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_1 <= _GEN_602;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_1 <= tx_cmd_val[46]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_1 <= _GEN_602;
        end
      end else begin
        tx_cmd_1 <= _GEN_602;
      end
    end else begin
      tx_cmd_1 <= _GEN_602;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_2 <= _GEN_603;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_2 <= tx_cmd_val[45]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_2 <= _GEN_603;
        end
      end else begin
        tx_cmd_2 <= _GEN_603;
      end
    end else begin
      tx_cmd_2 <= _GEN_603;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_3 <= _GEN_604;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_3 <= tx_cmd_val[44]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_3 <= _GEN_604;
        end
      end else begin
        tx_cmd_3 <= _GEN_604;
      end
    end else begin
      tx_cmd_3 <= _GEN_604;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_4 <= _GEN_605;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_4 <= tx_cmd_val[43]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_4 <= _GEN_605;
        end
      end else begin
        tx_cmd_4 <= _GEN_605;
      end
    end else begin
      tx_cmd_4 <= _GEN_605;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_5 <= _GEN_606;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_5 <= tx_cmd_val[42]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_5 <= _GEN_606;
        end
      end else begin
        tx_cmd_5 <= _GEN_606;
      end
    end else begin
      tx_cmd_5 <= _GEN_606;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_6 <= _GEN_607;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_6 <= tx_cmd_val[41]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_6 <= _GEN_607;
        end
      end else begin
        tx_cmd_6 <= _GEN_607;
      end
    end else begin
      tx_cmd_6 <= _GEN_607;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_7 <= _GEN_608;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_7 <= tx_cmd_val[40]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_7 <= _GEN_608;
        end
      end else begin
        tx_cmd_7 <= _GEN_608;
      end
    end else begin
      tx_cmd_7 <= _GEN_608;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_8 <= _GEN_609;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_8 <= tx_cmd_val[39]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_8 <= _GEN_609;
        end
      end else begin
        tx_cmd_8 <= _GEN_609;
      end
    end else begin
      tx_cmd_8 <= _GEN_609;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_9 <= _GEN_610;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_9 <= tx_cmd_val[38]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_9 <= _GEN_610;
        end
      end else begin
        tx_cmd_9 <= _GEN_610;
      end
    end else begin
      tx_cmd_9 <= _GEN_610;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_10 <= _GEN_611;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_10 <= tx_cmd_val[37]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_10 <= _GEN_611;
        end
      end else begin
        tx_cmd_10 <= _GEN_611;
      end
    end else begin
      tx_cmd_10 <= _GEN_611;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_11 <= _GEN_612;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_11 <= tx_cmd_val[36]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_11 <= _GEN_612;
        end
      end else begin
        tx_cmd_11 <= _GEN_612;
      end
    end else begin
      tx_cmd_11 <= _GEN_612;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_12 <= _GEN_613;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_12 <= tx_cmd_val[35]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_12 <= _GEN_613;
        end
      end else begin
        tx_cmd_12 <= _GEN_613;
      end
    end else begin
      tx_cmd_12 <= _GEN_613;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_13 <= _GEN_614;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_13 <= tx_cmd_val[34]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_13 <= _GEN_614;
        end
      end else begin
        tx_cmd_13 <= _GEN_614;
      end
    end else begin
      tx_cmd_13 <= _GEN_614;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_14 <= _GEN_615;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_14 <= tx_cmd_val[33]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_14 <= _GEN_615;
        end
      end else begin
        tx_cmd_14 <= _GEN_615;
      end
    end else begin
      tx_cmd_14 <= _GEN_615;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_15 <= _GEN_616;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_15 <= tx_cmd_val[32]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_15 <= _GEN_616;
        end
      end else begin
        tx_cmd_15 <= _GEN_616;
      end
    end else begin
      tx_cmd_15 <= _GEN_616;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_16 <= _GEN_617;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_16 <= tx_cmd_val[31]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_16 <= _GEN_617;
        end
      end else begin
        tx_cmd_16 <= _GEN_617;
      end
    end else begin
      tx_cmd_16 <= _GEN_617;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_17 <= _GEN_618;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_17 <= tx_cmd_val[30]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_17 <= _GEN_618;
        end
      end else begin
        tx_cmd_17 <= _GEN_618;
      end
    end else begin
      tx_cmd_17 <= _GEN_618;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_18 <= _GEN_619;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_18 <= tx_cmd_val[29]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_18 <= _GEN_619;
        end
      end else begin
        tx_cmd_18 <= _GEN_619;
      end
    end else begin
      tx_cmd_18 <= _GEN_619;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_19 <= _GEN_620;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_19 <= tx_cmd_val[28]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_19 <= _GEN_620;
        end
      end else begin
        tx_cmd_19 <= _GEN_620;
      end
    end else begin
      tx_cmd_19 <= _GEN_620;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_20 <= _GEN_621;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_20 <= tx_cmd_val[27]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_20 <= _GEN_621;
        end
      end else begin
        tx_cmd_20 <= _GEN_621;
      end
    end else begin
      tx_cmd_20 <= _GEN_621;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_21 <= _GEN_622;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_21 <= tx_cmd_val[26]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_21 <= _GEN_622;
        end
      end else begin
        tx_cmd_21 <= _GEN_622;
      end
    end else begin
      tx_cmd_21 <= _GEN_622;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_22 <= _GEN_623;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_22 <= tx_cmd_val[25]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_22 <= _GEN_623;
        end
      end else begin
        tx_cmd_22 <= _GEN_623;
      end
    end else begin
      tx_cmd_22 <= _GEN_623;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_23 <= _GEN_624;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_23 <= tx_cmd_val[24]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_23 <= _GEN_624;
        end
      end else begin
        tx_cmd_23 <= _GEN_624;
      end
    end else begin
      tx_cmd_23 <= _GEN_624;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_24 <= _GEN_625;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_24 <= tx_cmd_val[23]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_24 <= _GEN_625;
        end
      end else begin
        tx_cmd_24 <= _GEN_625;
      end
    end else begin
      tx_cmd_24 <= _GEN_625;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_25 <= _GEN_626;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_25 <= tx_cmd_val[22]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_25 <= _GEN_626;
        end
      end else begin
        tx_cmd_25 <= _GEN_626;
      end
    end else begin
      tx_cmd_25 <= _GEN_626;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_26 <= _GEN_627;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_26 <= tx_cmd_val[21]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_26 <= _GEN_627;
        end
      end else begin
        tx_cmd_26 <= _GEN_627;
      end
    end else begin
      tx_cmd_26 <= _GEN_627;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_27 <= _GEN_628;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_27 <= tx_cmd_val[20]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_27 <= _GEN_628;
        end
      end else begin
        tx_cmd_27 <= _GEN_628;
      end
    end else begin
      tx_cmd_27 <= _GEN_628;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_28 <= _GEN_629;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_28 <= tx_cmd_val[19]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_28 <= _GEN_629;
        end
      end else begin
        tx_cmd_28 <= _GEN_629;
      end
    end else begin
      tx_cmd_28 <= _GEN_629;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_29 <= _GEN_630;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_29 <= tx_cmd_val[18]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_29 <= _GEN_630;
        end
      end else begin
        tx_cmd_29 <= _GEN_630;
      end
    end else begin
      tx_cmd_29 <= _GEN_630;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_30 <= _GEN_631;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_30 <= tx_cmd_val[17]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_30 <= _GEN_631;
        end
      end else begin
        tx_cmd_30 <= _GEN_631;
      end
    end else begin
      tx_cmd_30 <= _GEN_631;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_31 <= _GEN_632;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_31 <= tx_cmd_val[16]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_31 <= _GEN_632;
        end
      end else begin
        tx_cmd_31 <= _GEN_632;
      end
    end else begin
      tx_cmd_31 <= _GEN_632;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_32 <= _GEN_633;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_32 <= tx_cmd_val[15]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_32 <= _GEN_633;
        end
      end else begin
        tx_cmd_32 <= _GEN_633;
      end
    end else begin
      tx_cmd_32 <= _GEN_633;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_33 <= _GEN_634;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_33 <= tx_cmd_val[14]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_33 <= _GEN_634;
        end
      end else begin
        tx_cmd_33 <= _GEN_634;
      end
    end else begin
      tx_cmd_33 <= _GEN_634;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_34 <= _GEN_635;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_34 <= tx_cmd_val[13]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_34 <= _GEN_635;
        end
      end else begin
        tx_cmd_34 <= _GEN_635;
      end
    end else begin
      tx_cmd_34 <= _GEN_635;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_35 <= _GEN_636;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_35 <= tx_cmd_val[12]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_35 <= _GEN_636;
        end
      end else begin
        tx_cmd_35 <= _GEN_636;
      end
    end else begin
      tx_cmd_35 <= _GEN_636;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_36 <= _GEN_637;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_36 <= tx_cmd_val[11]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_36 <= _GEN_637;
        end
      end else begin
        tx_cmd_36 <= _GEN_637;
      end
    end else begin
      tx_cmd_36 <= _GEN_637;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_37 <= _GEN_638;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_37 <= tx_cmd_val[10]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_37 <= _GEN_638;
        end
      end else begin
        tx_cmd_37 <= _GEN_638;
      end
    end else begin
      tx_cmd_37 <= _GEN_638;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_38 <= _GEN_639;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_38 <= tx_cmd_val[9]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_38 <= _GEN_639;
        end
      end else begin
        tx_cmd_38 <= _GEN_639;
      end
    end else begin
      tx_cmd_38 <= _GEN_639;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_39 <= _GEN_640;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_39 <= tx_cmd_val[8]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_39 <= _GEN_640;
        end
      end else begin
        tx_cmd_39 <= _GEN_640;
      end
    end else begin
      tx_cmd_39 <= _GEN_640;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_40 <= _GEN_641;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_40 <= tx_cmd_val[7]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_40 <= _GEN_641;
        end
      end else begin
        tx_cmd_40 <= _GEN_641;
      end
    end else begin
      tx_cmd_40 <= _GEN_641;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_41 <= _GEN_642;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_41 <= tx_cmd_val[6]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_41 <= _GEN_642;
        end
      end else begin
        tx_cmd_41 <= _GEN_642;
      end
    end else begin
      tx_cmd_41 <= _GEN_642;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_42 <= _GEN_643;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_42 <= tx_cmd_val[5]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_42 <= _GEN_643;
        end
      end else begin
        tx_cmd_42 <= _GEN_643;
      end
    end else begin
      tx_cmd_42 <= _GEN_643;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_43 <= _GEN_644;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_43 <= tx_cmd_val[4]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_43 <= _GEN_644;
        end
      end else begin
        tx_cmd_43 <= _GEN_644;
      end
    end else begin
      tx_cmd_43 <= _GEN_644;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_44 <= _GEN_645;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_44 <= tx_cmd_val[3]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_44 <= _GEN_645;
        end
      end else begin
        tx_cmd_44 <= _GEN_645;
      end
    end else begin
      tx_cmd_44 <= _GEN_645;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_45 <= _GEN_646;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_45 <= tx_cmd_val[2]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_45 <= _GEN_646;
        end
      end else begin
        tx_cmd_45 <= _GEN_646;
      end
    end else begin
      tx_cmd_45 <= _GEN_646;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_46 <= _GEN_647;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_46 <= tx_cmd_val[1]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
        end else begin
          tx_cmd_46 <= _GEN_647;
        end
      end else begin
        tx_cmd_46 <= _GEN_647;
      end
    end else begin
      tx_cmd_46 <= _GEN_647;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
            tx_cmd_47 <= tx_cmd_val[0]; // @[src/main/scala/fpga/periferals/Sdc.scala 525:18]
          end
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 121:31]
      tx_cmd_counter <= 6'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 121:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_counter <= _GEN_648;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_counter <= _GEN_1265;
      end else begin
        tx_cmd_counter <= _GEN_648;
      end
    end else begin
      tx_cmd_counter <= _GEN_648;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_0 <= _GEN_649;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_0 <= tx_cmd_val[41]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_0 <= _GEN_649;
        end
      end else begin
        tx_cmd_crc_0 <= _GEN_649;
      end
    end else begin
      tx_cmd_crc_0 <= _GEN_649;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_1 <= _GEN_650;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_1 <= tx_cmd_val[42]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_1 <= _GEN_650;
        end
      end else begin
        tx_cmd_crc_1 <= _GEN_650;
      end
    end else begin
      tx_cmd_crc_1 <= _GEN_650;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_2 <= _GEN_651;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_2 <= tx_cmd_val[43]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_2 <= _GEN_651;
        end
      end else begin
        tx_cmd_crc_2 <= _GEN_651;
      end
    end else begin
      tx_cmd_crc_2 <= _GEN_651;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_3 <= _GEN_652;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_3 <= tx_cmd_val[44]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_3 <= _GEN_652;
        end
      end else begin
        tx_cmd_crc_3 <= _GEN_652;
      end
    end else begin
      tx_cmd_crc_3 <= _GEN_652;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_4 <= _GEN_653;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_4 <= tx_cmd_val[45]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_4 <= _GEN_653;
        end
      end else begin
        tx_cmd_crc_4 <= _GEN_653;
      end
    end else begin
      tx_cmd_crc_4 <= _GEN_653;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_5 <= _GEN_654;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_5 <= tx_cmd_val[46]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_5 <= _GEN_654;
        end
      end else begin
        tx_cmd_crc_5 <= _GEN_654;
      end
    end else begin
      tx_cmd_crc_5 <= _GEN_654;
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_cmd_crc_6 <= _GEN_655;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
          tx_cmd_crc_6 <= tx_cmd_val[47]; // @[src/main/scala/fpga/periferals/Sdc.scala 527:22]
        end else begin
          tx_cmd_crc_6 <= _GEN_655;
        end
      end else begin
        tx_cmd_crc_6 <= _GEN_655;
      end
    end else begin
      tx_cmd_crc_6 <= _GEN_655;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 123:29]
      tx_cmd_timer <= 6'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 123:29]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 214:69]
      tx_cmd_timer <= _tx_cmd_timer_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 215:18]
    end else if (rx_res_counter > 8'h0 & tx_cmd_counter == 6'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 170:57]
      if (_T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 172:47]
        tx_cmd_timer <= _GEN_169;
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 124:31]
      reg_tx_cmd_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 124:31]
    end else if (tx_cmd_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 214:69]
      reg_tx_cmd_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 216:20]
    end else if (rx_busy_timer != 19'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 218:76]
      reg_tx_cmd_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 219:20]
    end else begin
      reg_tx_cmd_wrt <= _GEN_484;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 125:31]
      reg_tx_cmd_out <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 125:31]
    end else if (tx_cmd_counter > 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 221:75]
      reg_tx_cmd_out <= tx_cmd_0; // @[src/main/scala/fpga/periferals/Sdc.scala 223:20]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 126:35]
      rx_dat_in_progress <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 126:35]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_in_progress <= _GEN_839;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_in_progress <= _GEN_1289;
      end else begin
        rx_dat_in_progress <= _GEN_839;
      end
    end else begin
      rx_dat_in_progress <= _GEN_839;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 127:31]
      rx_dat_counter <= 11'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 127:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_counter <= _GEN_833;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_counter <= _GEN_1290;
      end else begin
        rx_dat_counter <= _GEN_833;
      end
    end else begin
      rx_dat_counter <= _GEN_833;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 128:33]
      rx_dat_start_bit <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 128:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_start_bit <= _GEN_864;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_start_bit <= _GEN_1291;
      end else begin
        rx_dat_start_bit <= _GEN_864;
      end
    end else begin
      rx_dat_start_bit <= _GEN_864;
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_0 <= rx_dat_next; // @[src/main/scala/fpga/periferals/Sdc.scala 286:24]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_1 <= rx_dat_bits_0; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_2 <= rx_dat_bits_1; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_3 <= rx_dat_bits_2; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_4 <= rx_dat_bits_3; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_5 <= rx_dat_bits_4; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_6 <= rx_dat_bits_5; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 271:47]
        if (!(~rx_dat_in_progress & rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 272:59]
          if (!(_T_35 & ~rx_dat_next[0])) begin // @[src/main/scala/fpga/periferals/Sdc.scala 282:66]
            rx_dat_bits_7 <= rx_dat_bits_6; // @[src/main/scala/fpga/periferals/Sdc.scala 285:50]
          end
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 130:28]
      rx_dat_next <= 4'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 130:28]
    end else if (rx_dat_counter > 11'h0 & _T_2) begin // @[src/main/scala/fpga/periferals/Sdc.scala 269:57]
      rx_dat_next <= io_sdc_port_dat_in; // @[src/main/scala/fpga/periferals/Sdc.scala 270:17]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 131:34]
      rx_dat_continuous <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 131:34]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          rx_dat_continuous <= _GEN_1312;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 132:29]
      rx_dat_ready <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 132:29]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_dat_ready <= _GEN_1650;
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_dat_ready <= _GEN_1650;
      end else begin
        rx_dat_ready <= _GEN_1704;
      end
    end else begin
      rx_dat_ready <= _GEN_1650;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 133:31]
      rx_dat_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 133:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_intr_en <= io_mem_wdata[17]; // @[src/main/scala/fpga/periferals/Sdc.scala 518:26]
      end
    end
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_0 <= _GEN_848;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_1 <= _GEN_849;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_2 <= _GEN_850;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_3 <= _GEN_851;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_4 <= _GEN_852;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_5 <= _GEN_853;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_6 <= _GEN_854;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_7 <= _GEN_855;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_8 <= _GEN_856;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_9 <= _GEN_857;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_10 <= _GEN_858;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_11 <= _GEN_859;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_12 <= _GEN_860;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_13 <= _GEN_861;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_14 <= _GEN_862;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_15 <= _GEN_863;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (io_mem_wdata[11]) begin // @[src/main/scala/fpga/periferals/Sdc.scala 523:40]
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
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 135:33]
      rx_dat_crc_error <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 135:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_error <= _GEN_868;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_crc_error <= _GEN_1309;
      end else begin
        rx_dat_crc_error <= _GEN_868;
      end
    end else begin
      rx_dat_crc_error <= _GEN_868;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 136:29]
      rx_dat_timer <= 19'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 136:29]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_timer <= _GEN_832;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_timer <= _GEN_1310;
      end else begin
        rx_dat_timer <= _GEN_832;
      end
    end else begin
      rx_dat_timer <= _GEN_832;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 137:31]
      rx_dat_timeout <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 137:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_timeout <= _GEN_835;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_timeout <= _GEN_1311;
      end else begin
        rx_dat_timeout <= _GEN_835;
      end
    end else begin
      rx_dat_timeout <= _GEN_835;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 138:31]
      rx_dat_overrun <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 138:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_overrun <= _GEN_869;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rx_dat_overrun <= _GEN_1313;
      end else begin
        rx_dat_overrun <= _GEN_869;
      end
    end else begin
      rx_dat_overrun <= _GEN_869;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 140:33]
      rxtx_dat_counter <= 8'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 140:33]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rxtx_dat_counter <= _GEN_1673;
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rxtx_dat_counter <= _GEN_1673;
      end else begin
        rxtx_dat_counter <= _GEN_1701;
      end
    end else begin
      rxtx_dat_counter <= _GEN_1673;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 141:31]
      rxtx_dat_index <= 8'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 141:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rxtx_dat_index <= _GEN_1163;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        rxtx_dat_index <= _GEN_1314;
      end else begin
        rxtx_dat_index <= _GEN_1163;
      end
    end else begin
      rxtx_dat_index <= _GEN_1163;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 142:30]
      rx_busy_timer <= 19'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 142:30]
    end else if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
      rx_busy_timer <= _GEN_924;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
      rx_busy_timer <= _GEN_962;
    end else begin
      rx_busy_timer <= _GEN_924;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 143:36]
      rx_busy_in_progress <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 143:36]
    end else if (rx_busy_timer > 19'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
          rx_busy_in_progress <= _GEN_898;
        end
      end
    end
    rx_dat0_next <= reset | _GEN_923; // @[src/main/scala/fpga/periferals/Sdc.scala 144:{29,29}]
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 145:32]
      rx_dat_buf_read <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 145:32]
    end else if (io_mem_ren) begin // @[src/main/scala/fpga/periferals/Sdc.scala 601:21]
      if (2'h0 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_dat_buf_read <= _GEN_837;
      end else if (2'h1 == addr_1) begin // @[src/main/scala/fpga/periferals/Sdc.scala 603:19]
        rx_dat_buf_read <= _GEN_837;
      end else begin
        rx_dat_buf_read <= _GEN_1703;
      end
    end else begin
      rx_dat_buf_read <= _GEN_837;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 146:33]
      rx_dat_buf_cache <= 32'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 146:33]
    end else if (rx_dat_buf_read) begin // @[src/main/scala/fpga/periferals/Sdc.scala 260:26]
      rx_dat_buf_cache <= io_sdbuf_rdata2; // @[src/main/scala/fpga/periferals/Sdc.scala 261:22]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 147:31]
      reg_tx_dat_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 147:31]
    end else if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      reg_tx_dat_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 405:20]
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
      reg_tx_dat_wrt <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 409:20]
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
      reg_tx_dat_wrt <= _GEN_960;
    end
    reg_tx_dat_out <= _GEN_1727[0]; // @[src/main/scala/fpga/periferals/Sdc.scala 148:{31,31}]
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 149:33]
      tx_empty_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 149:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_empty_intr_en <= io_mem_wdata[18]; // @[src/main/scala/fpga/periferals/Sdc.scala 519:26]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 150:31]
      tx_end_intr_en <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 150:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_end_intr_en <= io_mem_wdata[19]; // @[src/main/scala/fpga/periferals/Sdc.scala 520:26]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 151:31]
      tx_dat_counter <= 11'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 151:31]
    end else if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
      tx_dat_counter <= _GEN_870;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
      tx_dat_counter <= _tx_dat_counter_T_1; // @[src/main/scala/fpga/periferals/Sdc.scala 415:20]
    end else begin
      tx_dat_counter <= _GEN_870;
    end
    tx_dat_timer <= _GEN_1728[5:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 152:{29,29}]
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_0 <= _GEN_1066;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_0 <= 4'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 474:17]
    end else begin
      tx_dat_0 <= _GEN_1066;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_1 <= _GEN_1067;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_1 <= tx_dat_prepared[7:4]; // @[src/main/scala/fpga/periferals/Sdc.scala 475:17]
    end else begin
      tx_dat_1 <= _GEN_1067;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_2 <= _GEN_1068;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_2 <= tx_dat_prepared[3:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 476:17]
    end else begin
      tx_dat_2 <= _GEN_1068;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_3 <= _GEN_1069;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_3 <= tx_dat_prepared[15:12]; // @[src/main/scala/fpga/periferals/Sdc.scala 477:17]
    end else begin
      tx_dat_3 <= _GEN_1069;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_4 <= _GEN_1070;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_4 <= tx_dat_prepared[11:8]; // @[src/main/scala/fpga/periferals/Sdc.scala 478:17]
    end else begin
      tx_dat_4 <= _GEN_1070;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_5 <= _GEN_1071;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_5 <= tx_dat_prepared[23:20]; // @[src/main/scala/fpga/periferals/Sdc.scala 479:17]
    end else begin
      tx_dat_5 <= _GEN_1071;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_6 <= _GEN_1072;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_6 <= tx_dat_prepared[19:16]; // @[src/main/scala/fpga/periferals/Sdc.scala 480:17]
    end else begin
      tx_dat_6 <= _GEN_1072;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_7 <= _GEN_1073;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_7 <= tx_dat_prepared[31:28]; // @[src/main/scala/fpga/periferals/Sdc.scala 481:17]
    end else begin
      tx_dat_7 <= _GEN_1073;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_8 <= _GEN_1074;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_8 <= tx_dat_prepared[27:24]; // @[src/main/scala/fpga/periferals/Sdc.scala 482:17]
    end else begin
      tx_dat_8 <= _GEN_1074;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_9 <= _GEN_1075;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_9 <= tx_dat_prepared[7:4]; // @[src/main/scala/fpga/periferals/Sdc.scala 490:18]
    end else begin
      tx_dat_9 <= _GEN_1075;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_10 <= _GEN_1076;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_10 <= tx_dat_prepared[3:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 491:18]
    end else begin
      tx_dat_10 <= _GEN_1076;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_11 <= _GEN_1077;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_11 <= tx_dat_prepared[15:12]; // @[src/main/scala/fpga/periferals/Sdc.scala 492:18]
    end else begin
      tx_dat_11 <= _GEN_1077;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_12 <= _GEN_1078;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_12 <= tx_dat_prepared[11:8]; // @[src/main/scala/fpga/periferals/Sdc.scala 493:18]
    end else begin
      tx_dat_12 <= _GEN_1078;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_13 <= _GEN_1079;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_13 <= tx_dat_prepared[23:20]; // @[src/main/scala/fpga/periferals/Sdc.scala 494:18]
    end else begin
      tx_dat_13 <= _GEN_1079;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_14 <= _GEN_1080;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_14 <= tx_dat_prepared[19:16]; // @[src/main/scala/fpga/periferals/Sdc.scala 495:18]
    end else begin
      tx_dat_14 <= _GEN_1080;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_15 <= _GEN_1081;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_15 <= tx_dat_prepared[31:28]; // @[src/main/scala/fpga/periferals/Sdc.scala 496:18]
    end else begin
      tx_dat_15 <= _GEN_1081;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_16 <= tx_dat_prepared[7:4]; // @[src/main/scala/fpga/periferals/Sdc.scala 463:18]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_16 <= _GEN_1082;
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_16 <= tx_dat_prepared[27:24]; // @[src/main/scala/fpga/periferals/Sdc.scala 497:18]
    end else begin
      tx_dat_16 <= _GEN_1082;
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_17 <= tx_dat_prepared[3:0]; // @[src/main/scala/fpga/periferals/Sdc.scala 464:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_17 <= tx_dat_18; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_18 <= tx_dat_prepared[15:12]; // @[src/main/scala/fpga/periferals/Sdc.scala 465:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_18 <= tx_dat_19; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_19 <= tx_dat_prepared[11:8]; // @[src/main/scala/fpga/periferals/Sdc.scala 466:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_19 <= tx_dat_20; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_20 <= tx_dat_prepared[23:20]; // @[src/main/scala/fpga/periferals/Sdc.scala 467:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_20 <= tx_dat_21; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_21 <= tx_dat_prepared[19:16]; // @[src/main/scala/fpga/periferals/Sdc.scala 468:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_21 <= tx_dat_22; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_22 <= tx_dat_prepared[31:28]; // @[src/main/scala/fpga/periferals/Sdc.scala 469:18]
    end else if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_22 <= tx_dat_23; // @[src/main/scala/fpga/periferals/Sdc.scala 414:50]
        end
      end
    end
    if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_23 <= tx_dat_prepared[27:24]; // @[src/main/scala/fpga/periferals/Sdc.scala 470:18]
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_0 <= crc_1_0; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_1 <= tx_dat_crc_0; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_2 <= tx_dat_crc_1; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_3 <= tx_dat_crc_2; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_4 <= tx_dat_crc_3; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_5 <= crc_1_5; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_6 <= tx_dat_crc_5; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_7 <= tx_dat_crc_6; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_8 <= tx_dat_crc_7; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_9 <= tx_dat_crc_8; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_10 <= tx_dat_crc_9; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_11 <= tx_dat_crc_10; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_12 <= crc_1_12; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_13 <= tx_dat_crc_12; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_14 <= tx_dat_crc_13; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (!(_T_20)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      if (!(tx_dat_timer != 6'h0 & _T & reg_clk)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
        if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
          tx_dat_crc_15 <= tx_dat_crc_14; // @[src/main/scala/fpga/periferals/Sdc.scala 435:16]
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 155:32]
      tx_dat_prepared <= 32'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 155:32]
    end else if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
      tx_dat_prepared <= _GEN_658;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
      tx_dat_prepared <= _GEN_942;
    end else begin
      tx_dat_prepared <= _GEN_658;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 156:37]
      tx_dat_prepare_state <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 156:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_prepare_state <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 471:28]
    end else if (2'h2 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_prepare_state <= 2'h3; // @[src/main/scala/fpga/periferals/Sdc.scala 487:28]
    end else if (2'h3 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      tx_dat_prepare_state <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 498:28]
    end else begin
      tx_dat_prepare_state <= _GEN_1109;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 157:31]
      tx_dat_started <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 157:31]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          tx_dat_started <= _GEN_1316;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 159:35]
      tx_dat_in_progress <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 159:35]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_in_progress <= _GEN_879;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_in_progress <= _GEN_1322;
      end else begin
        tx_dat_in_progress <= _GEN_879;
      end
    end else begin
      tx_dat_in_progress <= _GEN_879;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 160:27]
      tx_dat_end <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 160:27]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_end <= _GEN_935;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_end <= _GEN_1323;
      end else begin
        tx_dat_end <= _GEN_935;
      end
    end else begin
      tx_dat_end <= _GEN_935;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 161:32]
      tx_dat_read_sel <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 161:32]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_read_sel <= _GEN_932;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_read_sel <= _GEN_1318;
      end else begin
        tx_dat_read_sel <= _GEN_932;
      end
    end else begin
      tx_dat_read_sel <= _GEN_932;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 162:33]
      tx_dat_write_sel <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 162:33]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (!(2'h0 == addr)) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
          tx_dat_write_sel <= _GEN_1319;
        end else begin
          tx_dat_write_sel <= _GEN_1339;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 163:40]
      tx_dat_read_sel_changed <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 163:40]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_read_sel_changed <= _GEN_933;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_read_sel_changed <= _GEN_1320;
      end else begin
        tx_dat_read_sel_changed <= _GEN_933;
      end
    end else begin
      tx_dat_read_sel_changed <= _GEN_933;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 164:37]
      tx_dat_write_sel_new <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 164:37]
    end else if (io_mem_wen) begin // @[src/main/scala/fpga/periferals/Sdc.scala 507:21]
      if (2'h0 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_write_sel_new <= _GEN_877;
      end else if (2'h1 == addr) begin // @[src/main/scala/fpga/periferals/Sdc.scala 509:19]
        tx_dat_write_sel_new <= _GEN_1321;
      end else begin
        tx_dat_write_sel_new <= _GEN_1340;
      end
    end else begin
      tx_dat_write_sel_new <= _GEN_877;
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 165:42]
      tx_dat_crc_status_counter <= 4'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 165:42]
    end else if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
      tx_dat_crc_status_counter <= _GEN_929;
    end else if (tx_dat_counter != 11'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 411:77]
      tx_dat_crc_status_counter <= _GEN_963;
    end else begin
      tx_dat_crc_status_counter <= _GEN_929;
    end
    if (rx_busy_timer > 19'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 369:48]
            tx_dat_crc_status_b_0 <= rx_dat0_next; // @[src/main/scala/fpga/periferals/Sdc.scala 371:34]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 369:48]
            tx_dat_crc_status_b_1 <= tx_dat_crc_status_b_0; // @[src/main/scala/fpga/periferals/Sdc.scala 370:84]
          end
        end
      end
    end
    if (rx_busy_timer > 19'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
          if (tx_dat_crc_status_counter > 4'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 369:48]
            tx_dat_crc_status_b_2 <= tx_dat_crc_status_b_1; // @[src/main/scala/fpga/periferals/Sdc.scala 370:84]
          end
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 167:34]
      tx_dat_crc_status <= 2'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 167:34]
    end else if (rx_busy_timer > 19'h0) begin // @[src/main/scala/fpga/periferals/Sdc.scala 361:30]
      if (_T_5) begin // @[src/main/scala/fpga/periferals/Sdc.scala 363:47]
        if (rx_busy_in_progress | ~rx_dat0_next) begin // @[src/main/scala/fpga/periferals/Sdc.scala 367:51]
          tx_dat_crc_status <= _GEN_894;
        end
      end
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/Sdc.scala 168:37]
      tx_dat_prepared_read <= 1'h0; // @[src/main/scala/fpga/periferals/Sdc.scala 168:37]
    end else if (2'h1 == tx_dat_prepare_state) begin // @[src/main/scala/fpga/periferals/Sdc.scala 461:33]
      if (_T_20) begin // @[src/main/scala/fpga/periferals/Sdc.scala 404:70]
        tx_dat_prepared_read <= _GEN_872;
      end else if (tx_dat_timer != 6'h0 & _T & reg_clk) begin // @[src/main/scala/fpga/periferals/Sdc.scala 407:75]
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
          $fwrite(32'h80000002,"sdc.clk           : 0x%x\n",reg_clk); // @[src/main/scala/fpga/periferals/Sdc.scala 664:9]
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
          $fwrite(32'h80000002,"sdc.cmd_wrt       : 0x%x\n",io_sdc_port_cmd_wrt); // @[src/main/scala/fpga/periferals/Sdc.scala 665:9]
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
          $fwrite(32'h80000002,"sdc.cmd_out       : 0x%x\n",io_sdc_port_cmd_out); // @[src/main/scala/fpga/periferals/Sdc.scala 666:9]
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
          $fwrite(32'h80000002,"rx_res_counter    : 0x%x\n",rx_res_counter); // @[src/main/scala/fpga/periferals/Sdc.scala 667:9]
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
          $fwrite(32'h80000002,"rx_dat_counter    : 0x%x\n",rx_dat_counter); // @[src/main/scala/fpga/periferals/Sdc.scala 668:9]
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
          $fwrite(32'h80000002,"rx_dat_next       : 0x%x\n",rx_dat_next); // @[src/main/scala/fpga/periferals/Sdc.scala 669:9]
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
          $fwrite(32'h80000002,"tx_cmd_counter    : 0x%x\n",tx_cmd_counter); // @[src/main/scala/fpga/periferals/Sdc.scala 670:9]
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
          $fwrite(32'h80000002,"tx_dat_counter    : 0x%x\n",tx_dat_counter); // @[src/main/scala/fpga/periferals/Sdc.scala 671:9]
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
          $fwrite(32'h80000002,"tx_cmd_timer      : 0x%x\n",tx_cmd_timer); // @[src/main/scala/fpga/periferals/Sdc.scala 672:9]
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
          $fwrite(32'h80000002,"rx_busy_timer     : 0x%x\n",rx_busy_timer); // @[src/main/scala/fpga/periferals/Sdc.scala 673:9]
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
          $fwrite(32'h80000002,"tx_dat_read_sel   : 0x%x\n",tx_dat_read_sel); // @[src/main/scala/fpga/periferals/Sdc.scala 674:9]
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
          $fwrite(32'h80000002,"tx_dat_write_sel  : 0x%x\n",tx_dat_write_sel); // @[src/main/scala/fpga/periferals/Sdc.scala 675:9]
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
          $fwrite(32'h80000002,"tx_dat_started    : %d\n",tx_dat_started); // @[src/main/scala/fpga/periferals/Sdc.scala 676:9]
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
          $fwrite(32'h80000002,"tx_dat_in_progress: %d\n",tx_dat_in_progress); // @[src/main/scala/fpga/periferals/Sdc.scala 677:9]
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
  reg_rdata = _RAND_4[31:0];
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
module InterruptController(
  input         clock,
  input         reset,
  input  [31:0] io_mem_raddr, // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
  output [31:0] io_mem_rdata, // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
  input         io_mem_wen, // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
  input  [31:0] io_mem_wdata, // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
  input  [1:0]  io_intr_periferal, // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
  output        io_intr_cpu // @[src/main/scala/fpga/periferals/InterruptController.scala 15:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] reg_intr_enable; // @[src/main/scala/fpga/periferals/InterruptController.scala 21:34]
  reg [1:0] reg_intr_asserted; // @[src/main/scala/fpga/periferals/InterruptController.scala 22:34]
  reg  reg_intr_cpu; // @[src/main/scala/fpga/periferals/InterruptController.scala 23:34]
  wire [1:0] inter_asserted = io_intr_periferal & reg_intr_enable; // @[src/main/scala/fpga/periferals/InterruptController.scala 25:42]
  wire [31:0] _GEN_0 = io_mem_raddr[2] ? {{30'd0}, reg_intr_asserted} : 32'hdeadbeef; // @[src/main/scala/fpga/periferals/InterruptController.scala 31:16 37:33 42:22]
  wire [31:0] _GEN_2 = io_mem_wen ? io_mem_wdata : {{30'd0}, reg_intr_enable}; // @[src/main/scala/fpga/periferals/InterruptController.scala 47:21 48:21 21:34]
  wire [31:0] _GEN_3 = reset ? 32'h0 : _GEN_2; // @[src/main/scala/fpga/periferals/InterruptController.scala 21:{34,34}]
  assign io_mem_rdata = ~io_mem_raddr[2] ? {{30'd0}, reg_intr_enable} : _GEN_0; // @[src/main/scala/fpga/periferals/InterruptController.scala 37:33 39:22]
  assign io_intr_cpu = reg_intr_cpu; // @[src/main/scala/fpga/periferals/InterruptController.scala 29:15]
  always @(posedge clock) begin
    reg_intr_enable <= _GEN_3[1:0]; // @[src/main/scala/fpga/periferals/InterruptController.scala 21:{34,34}]
    if (reset) begin // @[src/main/scala/fpga/periferals/InterruptController.scala 22:34]
      reg_intr_asserted <= 2'h0; // @[src/main/scala/fpga/periferals/InterruptController.scala 22:34]
    end else begin
      reg_intr_asserted <= inter_asserted; // @[src/main/scala/fpga/periferals/InterruptController.scala 27:21]
    end
    if (reset) begin // @[src/main/scala/fpga/periferals/InterruptController.scala 23:34]
      reg_intr_cpu <= 1'h0; // @[src/main/scala/fpga/periferals/InterruptController.scala 23:34]
    end else begin
      reg_intr_cpu <= |inter_asserted; // @[src/main/scala/fpga/periferals/InterruptController.scala 26:16]
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
  input  [31:0] io_mem_raddr, // @[src/main/scala/fpga/Top.scala 14:14]
  output [31:0] io_mem_rdata // @[src/main/scala/fpga/Top.scala 14:14]
);
  wire [26:0] _io_mem_rdata_T_2 = io_mem_raddr[2] ? 27'h5f678fe : 27'h1234567; // @[src/main/scala/chisel3/util/Mux.scala 77:13]
  assign io_mem_rdata = {{5'd0}, _io_mem_rdata_T_2}; // @[src/main/scala/fpga/Top.scala 18:16]
endmodule
module DMemDecoder(
  input         clock,
  input         reset,
  input  [31:0] io_initiator_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_initiator_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input         io_initiator_ren, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_initiator_waddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input         io_initiator_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_initiator_wready, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_initiator_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_0_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_0_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_0_ren, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_0_waddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_0_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_0_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_1_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_1_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_2_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_2_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_2_waddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_2_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_2_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_3_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_3_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_3_waddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_3_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_3_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_4_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_4_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_4_ren, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_4_waddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_4_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_4_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_5_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_5_rdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output        io_targets_5_wen, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_5_wdata, // @[src/main/scala/fpga/Decoder.scala 8:14]
  output [31:0] io_targets_6_raddr, // @[src/main/scala/fpga/Decoder.scala 8:14]
  input  [31:0] io_targets_6_rdata // @[src/main/scala/fpga/Decoder.scala 8:14]
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
  reg [31:0] latched_raddr; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren = 21'h10000 == io_initiator_raddr[31:11] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_5 = 21'h10000 == latched_raddr[31:11] ? io_targets_0_rdata : 32'hdeadbeef; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13 15:26]
  reg [31:0] latched_raddr_1; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_1 = 26'hc00000 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_13 = 26'hc00000 == latched_raddr_1[31:6] ? 32'hdeadbeef : _GEN_5; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  reg [31:0] latched_raddr_2; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_2 = 26'hc00040 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_21 = 26'hc00040 == latched_raddr_2[31:6] ? io_targets_2_rdata : _GEN_13; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  reg [31:0] latched_raddr_3; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_3 = 26'hc00080 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_29 = 26'hc00080 == latched_raddr_3[31:6] ? io_targets_3_rdata : _GEN_21; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  reg [31:0] latched_raddr_4; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_4 = 26'hc000c0 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_37 = 26'hc000c0 == latched_raddr_4[31:6] ? io_targets_4_rdata : _GEN_29; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  reg [31:0] latched_raddr_5; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_5 = 26'hc00100 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  wire [31:0] _GEN_45 = 26'hc00100 == latched_raddr_5[31:6] ? io_targets_5_rdata : _GEN_37; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  reg [31:0] latched_raddr_6; // @[src/main/scala/fpga/Decoder.scala 33:32]
  wire  ren_6 = 26'h1000000 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  assign io_initiator_rdata = 26'h1000000 == latched_raddr_6[31:6] ? io_targets_6_rdata : _GEN_45; // @[src/main/scala/fpga/Decoder.scala 55:74 57:13]
  assign io_initiator_wready = 26'h1000000 == io_initiator_waddr[31:6] | (26'hc00100 == io_initiator_waddr[31:6] | (26'hc000c0
     == io_initiator_waddr[31:6] | (26'hc00080 == io_initiator_waddr[31:6] | (26'hc00040 == io_initiator_waddr[31:6] | (26'hc00000
     == io_initiator_waddr[31:6] | 21'h10000 == io_initiator_waddr[31:11]))))); // @[src/main/scala/fpga/Decoder.scala 59:79 62:14]
  assign io_targets_0_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  assign io_targets_0_ren = 21'h10000 == io_initiator_raddr[31:11] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  assign io_targets_0_waddr = io_initiator_waddr; // @[src/main/scala/fpga/Decoder.scala 29:28 43:11]
  assign io_targets_0_wen = 21'h10000 == io_initiator_waddr[31:11] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_0_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_1_wen = 26'hc00000 == io_initiator_waddr[31:6] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_1_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_2_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  assign io_targets_2_waddr = io_initiator_waddr; // @[src/main/scala/fpga/Decoder.scala 29:28 43:11]
  assign io_targets_2_wen = 26'hc00040 == io_initiator_waddr[31:6] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_2_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_3_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  assign io_targets_3_waddr = io_initiator_waddr; // @[src/main/scala/fpga/Decoder.scala 29:28 43:11]
  assign io_targets_3_wen = 26'hc00080 == io_initiator_waddr[31:6] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_3_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_4_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  assign io_targets_4_ren = 26'hc000c0 == io_initiator_raddr[31:6] & io_initiator_ren; // @[src/main/scala/fpga/Decoder.scala 47:79 49:11 28:26]
  assign io_targets_4_waddr = io_initiator_waddr; // @[src/main/scala/fpga/Decoder.scala 29:28 43:11]
  assign io_targets_4_wen = 26'hc000c0 == io_initiator_waddr[31:6] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_4_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_5_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  assign io_targets_5_wen = 26'hc00100 == io_initiator_waddr[31:6] & io_initiator_wen; // @[src/main/scala/fpga/Decoder.scala 59:79 61:11 30:26]
  assign io_targets_5_wdata = io_initiator_wdata; // @[src/main/scala/fpga/Decoder.scala 31:28 44:11]
  assign io_targets_6_raddr = io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 27:28 42:11]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (21'h10000 == io_initiator_raddr[31:11]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_1 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'hc00000 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_1) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_1 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_2 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'hc00040 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_2) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_2 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_3 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'hc00080 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_3) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_3 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_4 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'hc000c0 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_4) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_4 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_5 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'hc00100 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_5) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_5 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Decoder.scala 33:32]
      latched_raddr_6 <= 32'h0; // @[src/main/scala/fpga/Decoder.scala 33:32]
    end else if (26'h1000000 == io_initiator_raddr[31:6]) begin // @[src/main/scala/fpga/Decoder.scala 47:79]
      if (ren_6) begin // @[src/main/scala/fpga/Decoder.scala 51:28]
        latched_raddr_6 <= io_initiator_raddr; // @[src/main/scala/fpga/Decoder.scala 52:23]
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
  latched_raddr = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  latched_raddr_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  latched_raddr_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  latched_raddr_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  latched_raddr_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  latched_raddr_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  latched_raddr_6 = _RAND_6[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module IMemDecoder(
  input         clock,
  input  [31:0] io_initiator_addr, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output [31:0] io_initiator_inst, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output        io_initiator_valid, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output        io_targets_0_en, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output [31:0] io_targets_0_addr, // @[src/main/scala/fpga/Decoder.scala 68:14]
  input  [31:0] io_targets_0_inst, // @[src/main/scala/fpga/Decoder.scala 68:14]
  input         io_targets_0_valid, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output        io_targets_1_en, // @[src/main/scala/fpga/Decoder.scala 68:14]
  output [31:0] io_targets_1_addr, // @[src/main/scala/fpga/Decoder.scala 68:14]
  input  [31:0] io_targets_1_inst, // @[src/main/scala/fpga/Decoder.scala 68:14]
  input         io_targets_1_valid // @[src/main/scala/fpga/Decoder.scala 68:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] next_addr; // @[src/main/scala/fpga/Decoder.scala 75:26]
  wire  en = 21'h10000 == io_initiator_addr[31:11]; // @[src/main/scala/fpga/Decoder.scala 90:37]
  wire  _GEN_2 = 21'h10000 == next_addr[31:11] ? io_targets_0_valid : 1'h1; // @[src/main/scala/fpga/Decoder.scala 94:70 95:13 73:26]
  wire [31:0] _GEN_3 = 21'h10000 == next_addr[31:11] ? io_targets_0_inst : 32'hdeadbeef; // @[src/main/scala/fpga/Decoder.scala 94:70 96:12 74:25]
  wire  en_1 = 4'h2 == io_initiator_addr[31:28]; // @[src/main/scala/fpga/Decoder.scala 90:37]
  assign io_initiator_inst = 4'h2 == next_addr[31:28] ? io_targets_1_inst : _GEN_3; // @[src/main/scala/fpga/Decoder.scala 94:70 96:12]
  assign io_initiator_valid = 4'h2 == next_addr[31:28] ? io_targets_1_valid : _GEN_2; // @[src/main/scala/fpga/Decoder.scala 94:70 95:13]
  assign io_targets_0_en = 21'h10000 == io_initiator_addr[31:11]; // @[src/main/scala/fpga/Decoder.scala 90:37]
  assign io_targets_0_addr = en ? {{21'd0}, io_initiator_addr[10:0]} : 32'h0; // @[src/main/scala/fpga/Decoder.scala 90:78 91:12 84:27]
  assign io_targets_1_en = 4'h2 == io_initiator_addr[31:28]; // @[src/main/scala/fpga/Decoder.scala 90:37]
  assign io_targets_1_addr = en_1 ? {{4'd0}, io_initiator_addr[27:0]} : 32'h0; // @[src/main/scala/fpga/Decoder.scala 90:78 91:12 84:27]
  always @(posedge clock) begin
    next_addr <= io_initiator_addr; // @[src/main/scala/fpga/Decoder.scala 75:26]
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
  output         io_dram_ren, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_dram_wen, // @[src/main/scala/fpga/Top.scala 69:14]
  output [27:0]  io_dram_addr, // @[src/main/scala/fpga/Top.scala 69:14]
  output [127:0] io_dram_wdata, // @[src/main/scala/fpga/Top.scala 69:14]
  output [15:0]  io_dram_wmask, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_dram_user_busy, // @[src/main/scala/fpga/Top.scala 69:14]
  input          io_dram_init_calib_complete, // @[src/main/scala/fpga/Top.scala 69:14]
  input  [127:0] io_dram_rdata, // @[src/main/scala/fpga/Top.scala 69:14]
  input          io_dram_rdata_valid, // @[src/main/scala/fpga/Top.scala 69:14]
  input          io_dram_busy, // @[src/main/scala/fpga/Top.scala 69:14]
  output [7:0]   io_gpio, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_uart_tx, // @[src/main/scala/fpga/Top.scala 69:14]
  input          io_uart_rx, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_sdc_port_clk, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_sdc_port_cmd_wrt, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_sdc_port_cmd_out, // @[src/main/scala/fpga/Top.scala 69:14]
  input          io_sdc_port_res_in, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_sdc_port_dat_wrt, // @[src/main/scala/fpga/Top.scala 69:14]
  output [3:0]   io_sdc_port_dat_out, // @[src/main/scala/fpga/Top.scala 69:14]
  input  [3:0]   io_sdc_port_dat_in, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_core_ex2_reg_pc, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_ex2_is_valid_inst, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_me_intr, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_mt_intr, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_trap, // @[src/main/scala/fpga/Top.scala 69:14]
  output [47:0]  io_debugSignals_core_cycle_counter, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_core_id_pc, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_core_id_inst, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_core_mem3_rdata, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_mem3_rvalid, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_core_rwaddr, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_ex2_reg_is_br, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_id_reg_is_bp_fail, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_core_id_reg_bp_taken, // @[src/main/scala/fpga/Top.scala 69:14]
  output [2:0]   io_debugSignals_core_ic_state, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_ren, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_wen, // @[src/main/scala/fpga/Top.scala 69:14]
  output         io_debugSignals_wready, // @[src/main/scala/fpga/Top.scala 69:14]
  output [3:0]   io_debugSignals_wstrb, // @[src/main/scala/fpga/Top.scala 69:14]
  output [31:0]  io_debugSignals_wdata, // @[src/main/scala/fpga/Top.scala 69:14]
  output [2:0]   io_debugSignals_mem_icache_state, // @[src/main/scala/fpga/Top.scala 69:14]
  output [2:0]   io_debugSignals_mem_dram_state, // @[src/main/scala/fpga/Top.scala 69:14]
  output [15:0]  io_debugSignals_mem_imem_addr // @[src/main/scala/fpga/Top.scala 69:14]
);
  wire  core_clock; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_reset; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_imem_addr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_imem_inst; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_imem_valid; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_dmem_raddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_dmem_rdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_dmem_ren; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_dmem_waddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_dmem_wen; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_dmem_wready; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [3:0] core_io_dmem_wstrb; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_dmem_wdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_iinvalidate; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_ibusy; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_cache_raddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_cache_rdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_ren; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_rvalid; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_rready; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_cache_waddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_wen; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_cache_wready; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [3:0] core_io_cache_wstrb; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_cache_wdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_pht_mem_wen; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [11:0] core_io_pht_mem_raddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [3:0] core_io_pht_mem_rdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [12:0] core_io_pht_mem_waddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [1:0] core_io_pht_mem_wdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_mtimer_mem_raddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_mtimer_mem_rdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_mtimer_mem_waddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_mtimer_mem_wen; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_mtimer_mem_wdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_intr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_debug_signal_ex2_reg_pc; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_ex2_is_valid_inst; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_me_intr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_mt_intr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_trap; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [47:0] core_io_debug_signal_cycle_counter; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_debug_signal_id_pc; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_debug_signal_id_inst; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_debug_signal_mem3_rdata; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_mem3_rvalid; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [31:0] core_io_debug_signal_rwaddr; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_ex2_reg_is_br; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_id_reg_is_bp_fail; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  core_io_debug_signal_id_reg_bp_taken; // @[src/main/scala/fpga/Top.scala 78:20]
  wire [2:0] core_io_debug_signal_ic_state; // @[src/main/scala/fpga/Top.scala 78:20]
  wire  memory_clock; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_reset; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_imem_en; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_imem_addr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_imem_inst; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_imem_valid; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_iinvalidate; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_ibusy; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_raddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_rvalid; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_rready; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_waddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_wready; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [3:0] memory_io_cache_wstrb; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_dramPort_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_dramPort_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [27:0] memory_io_dramPort_addr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [127:0] memory_io_dramPort_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_dramPort_init_calib_complete; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [127:0] memory_io_dramPort_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_dramPort_rdata_valid; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_dramPort_busy; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_array1_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_array1_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_array1_we; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [6:0] memory_io_cache_array1_raddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [6:0] memory_io_cache_array1_waddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [255:0] memory_io_cache_array1_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [255:0] memory_io_cache_array1_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_array2_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_cache_array2_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_cache_array2_we; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [6:0] memory_io_cache_array2_raddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [6:0] memory_io_cache_array2_waddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [255:0] memory_io_cache_array2_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [255:0] memory_io_cache_array2_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [9:0] memory_io_icache_raddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [31:0] memory_io_icache_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [6:0] memory_io_icache_waddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [255:0] memory_io_icache_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_valid_ren; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_valid_wen; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_valid_invalidate; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [5:0] memory_io_icache_valid_addr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  memory_io_icache_valid_iaddr; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [1:0] memory_io_icache_valid_rdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [1:0] memory_io_icache_valid_wdata; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [2:0] memory_io_icache_state; // @[src/main/scala/fpga/Top.scala 80:22]
  wire [2:0] memory_io_dram_state; // @[src/main/scala/fpga/Top.scala 80:22]
  wire  boot_rom_clock; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  boot_rom_reset; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  boot_rom_io_imem_en; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_imem_addr; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_imem_inst; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  boot_rom_io_imem_valid; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_dmem_raddr; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_dmem_rdata; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  boot_rom_io_dmem_ren; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_dmem_waddr; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  boot_rom_io_dmem_wen; // @[src/main/scala/fpga/Top.scala 81:24]
  wire [31:0] boot_rom_io_dmem_wdata; // @[src/main/scala/fpga/Top.scala 81:24]
  wire  dcache1_clock; // @[src/main/scala/fpga/Top.scala 82:23]
  wire  dcache1_ren; // @[src/main/scala/fpga/Top.scala 82:23]
  wire  dcache1_wen; // @[src/main/scala/fpga/Top.scala 82:23]
  wire [31:0] dcache1_we; // @[src/main/scala/fpga/Top.scala 82:23]
  wire [6:0] dcache1_raddr; // @[src/main/scala/fpga/Top.scala 82:23]
  wire [6:0] dcache1_waddr; // @[src/main/scala/fpga/Top.scala 82:23]
  wire [255:0] dcache1_wdata; // @[src/main/scala/fpga/Top.scala 82:23]
  wire [255:0] dcache1_rdata; // @[src/main/scala/fpga/Top.scala 82:23]
  wire  dcache2_clock; // @[src/main/scala/fpga/Top.scala 83:23]
  wire  dcache2_ren; // @[src/main/scala/fpga/Top.scala 83:23]
  wire  dcache2_wen; // @[src/main/scala/fpga/Top.scala 83:23]
  wire [31:0] dcache2_we; // @[src/main/scala/fpga/Top.scala 83:23]
  wire [6:0] dcache2_raddr; // @[src/main/scala/fpga/Top.scala 83:23]
  wire [6:0] dcache2_waddr; // @[src/main/scala/fpga/Top.scala 83:23]
  wire [255:0] dcache2_wdata; // @[src/main/scala/fpga/Top.scala 83:23]
  wire [255:0] dcache2_rdata; // @[src/main/scala/fpga/Top.scala 83:23]
  wire  icache_clock; // @[src/main/scala/fpga/Top.scala 84:22]
  wire  icache_ren; // @[src/main/scala/fpga/Top.scala 84:22]
  wire  icache_wen; // @[src/main/scala/fpga/Top.scala 84:22]
  wire [9:0] icache_raddr; // @[src/main/scala/fpga/Top.scala 84:22]
  wire [31:0] icache_rdata; // @[src/main/scala/fpga/Top.scala 84:22]
  wire [6:0] icache_waddr; // @[src/main/scala/fpga/Top.scala 84:22]
  wire [255:0] icache_wdata; // @[src/main/scala/fpga/Top.scala 84:22]
  wire  icache_valid_clock; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  icache_valid_ren; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  icache_valid_wen; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  icache_valid_ien; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  icache_valid_invalidate; // @[src/main/scala/fpga/Top.scala 85:28]
  wire [5:0] icache_valid_addr; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  icache_valid_iaddr; // @[src/main/scala/fpga/Top.scala 85:28]
  wire [1:0] icache_valid_rdata; // @[src/main/scala/fpga/Top.scala 85:28]
  wire [1:0] icache_valid_wdata; // @[src/main/scala/fpga/Top.scala 85:28]
  wire [63:0] icache_valid_idata; // @[src/main/scala/fpga/Top.scala 85:28]
  wire [1:0] icache_valid_dummy_data; // @[src/main/scala/fpga/Top.scala 85:28]
  wire  pht_mem_clock; // @[src/main/scala/fpga/Top.scala 86:23]
  wire  pht_mem_ren; // @[src/main/scala/fpga/Top.scala 86:23]
  wire  pht_mem_wen; // @[src/main/scala/fpga/Top.scala 86:23]
  wire [11:0] pht_mem_raddr; // @[src/main/scala/fpga/Top.scala 86:23]
  wire [3:0] pht_mem_rdata; // @[src/main/scala/fpga/Top.scala 86:23]
  wire [12:0] pht_mem_waddr; // @[src/main/scala/fpga/Top.scala 86:23]
  wire [1:0] pht_mem_wdata; // @[src/main/scala/fpga/Top.scala 86:23]
  wire  gpio_clock; // @[src/main/scala/fpga/Top.scala 87:20]
  wire  gpio_reset; // @[src/main/scala/fpga/Top.scala 87:20]
  wire  gpio_io_mem_wen; // @[src/main/scala/fpga/Top.scala 87:20]
  wire [31:0] gpio_io_mem_wdata; // @[src/main/scala/fpga/Top.scala 87:20]
  wire [31:0] gpio_io_gpio; // @[src/main/scala/fpga/Top.scala 87:20]
  wire  uart_clock; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  uart_reset; // @[src/main/scala/fpga/Top.scala 88:20]
  wire [31:0] uart_io_mem_raddr; // @[src/main/scala/fpga/Top.scala 88:20]
  wire [31:0] uart_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 88:20]
  wire [31:0] uart_io_mem_waddr; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  uart_io_mem_wen; // @[src/main/scala/fpga/Top.scala 88:20]
  wire [31:0] uart_io_mem_wdata; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  uart_io_intr; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  uart_io_tx; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  uart_io_rx; // @[src/main/scala/fpga/Top.scala 88:20]
  wire  sdc_clock; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_reset; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_mem_raddr; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_mem_ren; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_mem_waddr; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_mem_wen; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_mem_wdata; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdc_port_clk; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdc_port_cmd_wrt; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdc_port_cmd_out; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdc_port_res_in; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdc_port_dat_wrt; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [3:0] sdc_io_sdc_port_dat_out; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [3:0] sdc_io_sdc_port_dat_in; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdbuf_ren1; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdbuf_wen1; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [7:0] sdc_io_sdbuf_addr1; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_sdbuf_rdata1; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_sdbuf_wdata1; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdbuf_ren2; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_sdbuf_wen2; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [7:0] sdc_io_sdbuf_addr2; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_sdbuf_rdata2; // @[src/main/scala/fpga/Top.scala 89:19]
  wire [31:0] sdc_io_sdbuf_wdata2; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdc_io_intr; // @[src/main/scala/fpga/Top.scala 89:19]
  wire  sdbuf_clock; // @[src/main/scala/fpga/Top.scala 90:21]
  wire  sdbuf_ren1; // @[src/main/scala/fpga/Top.scala 90:21]
  wire  sdbuf_wen1; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [7:0] sdbuf_addr1; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [31:0] sdbuf_wdata1; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [31:0] sdbuf_rdata1; // @[src/main/scala/fpga/Top.scala 90:21]
  wire  sdbuf_ren2; // @[src/main/scala/fpga/Top.scala 90:21]
  wire  sdbuf_wen2; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [7:0] sdbuf_addr2; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [31:0] sdbuf_wdata2; // @[src/main/scala/fpga/Top.scala 90:21]
  wire [31:0] sdbuf_rdata2; // @[src/main/scala/fpga/Top.scala 90:21]
  wire  intr_clock; // @[src/main/scala/fpga/Top.scala 91:20]
  wire  intr_reset; // @[src/main/scala/fpga/Top.scala 91:20]
  wire [31:0] intr_io_mem_raddr; // @[src/main/scala/fpga/Top.scala 91:20]
  wire [31:0] intr_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 91:20]
  wire  intr_io_mem_wen; // @[src/main/scala/fpga/Top.scala 91:20]
  wire [31:0] intr_io_mem_wdata; // @[src/main/scala/fpga/Top.scala 91:20]
  wire [1:0] intr_io_intr_periferal; // @[src/main/scala/fpga/Top.scala 91:20]
  wire  intr_io_intr_cpu; // @[src/main/scala/fpga/Top.scala 91:20]
  wire [31:0] config__io_mem_raddr; // @[src/main/scala/fpga/Top.scala 92:22]
  wire [31:0] config__io_mem_rdata; // @[src/main/scala/fpga/Top.scala 92:22]
  wire  dmem_decoder_clock; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_reset; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_initiator_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_initiator_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_initiator_ren; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_initiator_waddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_initiator_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_initiator_wready; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_initiator_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_0_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_0_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_0_ren; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_0_waddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_0_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_0_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_1_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_1_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_2_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_2_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_2_waddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_2_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_2_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_3_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_3_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_3_waddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_3_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_3_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_4_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_4_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_4_ren; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_4_waddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_4_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_4_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_5_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_5_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  dmem_decoder_io_targets_5_wen; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_5_wdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_6_raddr; // @[src/main/scala/fpga/Top.scala 94:28]
  wire [31:0] dmem_decoder_io_targets_6_rdata; // @[src/main/scala/fpga/Top.scala 94:28]
  wire  imem_decoder_clock; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_initiator_addr; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_initiator_inst; // @[src/main/scala/fpga/Top.scala 113:28]
  wire  imem_decoder_io_initiator_valid; // @[src/main/scala/fpga/Top.scala 113:28]
  wire  imem_decoder_io_targets_0_en; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_targets_0_addr; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_targets_0_inst; // @[src/main/scala/fpga/Top.scala 113:28]
  wire  imem_decoder_io_targets_0_valid; // @[src/main/scala/fpga/Top.scala 113:28]
  wire  imem_decoder_io_targets_1_en; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_targets_1_addr; // @[src/main/scala/fpga/Top.scala 113:28]
  wire [31:0] imem_decoder_io_targets_1_inst; // @[src/main/scala/fpga/Top.scala 113:28]
  wire  imem_decoder_io_targets_1_valid; // @[src/main/scala/fpga/Top.scala 113:28]
  Core core ( // @[src/main/scala/fpga/Top.scala 78:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_inst(core_io_imem_inst),
    .io_imem_valid(core_io_imem_valid),
    .io_dmem_raddr(core_io_dmem_raddr),
    .io_dmem_rdata(core_io_dmem_rdata),
    .io_dmem_ren(core_io_dmem_ren),
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
    .io_debug_signal_id_reg_bp_taken(core_io_debug_signal_id_reg_bp_taken),
    .io_debug_signal_ic_state(core_io_debug_signal_ic_state)
  );
  Memory memory ( // @[src/main/scala/fpga/Top.scala 80:22]
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
    .io_cache_array1_ren(memory_io_cache_array1_ren),
    .io_cache_array1_wen(memory_io_cache_array1_wen),
    .io_cache_array1_we(memory_io_cache_array1_we),
    .io_cache_array1_raddr(memory_io_cache_array1_raddr),
    .io_cache_array1_waddr(memory_io_cache_array1_waddr),
    .io_cache_array1_wdata(memory_io_cache_array1_wdata),
    .io_cache_array1_rdata(memory_io_cache_array1_rdata),
    .io_cache_array2_ren(memory_io_cache_array2_ren),
    .io_cache_array2_wen(memory_io_cache_array2_wen),
    .io_cache_array2_we(memory_io_cache_array2_we),
    .io_cache_array2_raddr(memory_io_cache_array2_raddr),
    .io_cache_array2_waddr(memory_io_cache_array2_waddr),
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
  BootRom boot_rom ( // @[src/main/scala/fpga/Top.scala 81:24]
    .clock(boot_rom_clock),
    .reset(boot_rom_reset),
    .io_imem_en(boot_rom_io_imem_en),
    .io_imem_addr(boot_rom_io_imem_addr),
    .io_imem_inst(boot_rom_io_imem_inst),
    .io_imem_valid(boot_rom_io_imem_valid),
    .io_dmem_raddr(boot_rom_io_dmem_raddr),
    .io_dmem_rdata(boot_rom_io_dmem_rdata),
    .io_dmem_ren(boot_rom_io_dmem_ren),
    .io_dmem_waddr(boot_rom_io_dmem_waddr),
    .io_dmem_wen(boot_rom_io_dmem_wen),
    .io_dmem_wdata(boot_rom_io_dmem_wdata)
  );
  DCache #(.ADDR_WIDTH(7), .COL_WIDTH(8), .DATA_WIDTH(256), .NUM_COL(32)) dcache1 ( // @[src/main/scala/fpga/Top.scala 82:23]
    .clock(dcache1_clock),
    .ren(dcache1_ren),
    .wen(dcache1_wen),
    .we(dcache1_we),
    .raddr(dcache1_raddr),
    .waddr(dcache1_waddr),
    .wdata(dcache1_wdata),
    .rdata(dcache1_rdata)
  );
  DCache #(.ADDR_WIDTH(7), .COL_WIDTH(8), .DATA_WIDTH(256), .NUM_COL(32)) dcache2 ( // @[src/main/scala/fpga/Top.scala 83:23]
    .clock(dcache2_clock),
    .ren(dcache2_ren),
    .wen(dcache2_wen),
    .we(dcache2_we),
    .raddr(dcache2_raddr),
    .waddr(dcache2_waddr),
    .wdata(dcache2_wdata),
    .rdata(dcache2_rdata)
  );
  ICache #(.RADDR_WIDTH(10), .RDATA_WIDTH_BITS(5), .WADDR_WIDTH(7), .WDATA_WIDTH_BITS(8)) icache ( // @[src/main/scala/fpga/Top.scala 84:22]
    .clock(icache_clock),
    .ren(icache_ren),
    .wen(icache_wen),
    .raddr(icache_raddr),
    .rdata(icache_rdata),
    .waddr(icache_waddr),
    .wdata(icache_wdata)
  );
  ICacheValid #(.ADDR_WIDTH(6), .DATA_WIDTH_BITS(1), .INVALIDATE_ADDR_WIDTH(1), .INVALIDATE_WIDTH_BITS(6)) icache_valid
     ( // @[src/main/scala/fpga/Top.scala 85:28]
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
  PHTMem #(.RADDR_WIDTH(12), .RDATA_WIDTH_BITS(2), .WADDR_WIDTH(13), .WDATA_WIDTH_BITS(1)) pht_mem ( // @[src/main/scala/fpga/Top.scala 86:23]
    .clock(pht_mem_clock),
    .ren(pht_mem_ren),
    .wen(pht_mem_wen),
    .raddr(pht_mem_raddr),
    .rdata(pht_mem_rdata),
    .waddr(pht_mem_waddr),
    .wdata(pht_mem_wdata)
  );
  Gpio gpio ( // @[src/main/scala/fpga/Top.scala 87:20]
    .clock(gpio_clock),
    .reset(gpio_reset),
    .io_mem_wen(gpio_io_mem_wen),
    .io_mem_wdata(gpio_io_mem_wdata),
    .io_gpio(gpio_io_gpio)
  );
  Uart uart ( // @[src/main/scala/fpga/Top.scala 88:20]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_mem_raddr(uart_io_mem_raddr),
    .io_mem_rdata(uart_io_mem_rdata),
    .io_mem_waddr(uart_io_mem_waddr),
    .io_mem_wen(uart_io_mem_wen),
    .io_mem_wdata(uart_io_mem_wdata),
    .io_intr(uart_io_intr),
    .io_tx(uart_io_tx),
    .io_rx(uart_io_rx)
  );
  Sdc sdc ( // @[src/main/scala/fpga/Top.scala 89:19]
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
  SdBuf #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) sdbuf ( // @[src/main/scala/fpga/Top.scala 90:21]
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
  InterruptController intr ( // @[src/main/scala/fpga/Top.scala 91:20]
    .clock(intr_clock),
    .reset(intr_reset),
    .io_mem_raddr(intr_io_mem_raddr),
    .io_mem_rdata(intr_io_mem_rdata),
    .io_mem_wen(intr_io_mem_wen),
    .io_mem_wdata(intr_io_mem_wdata),
    .io_intr_periferal(intr_io_intr_periferal),
    .io_intr_cpu(intr_io_intr_cpu)
  );
  Config config_ ( // @[src/main/scala/fpga/Top.scala 92:22]
    .io_mem_raddr(config__io_mem_raddr),
    .io_mem_rdata(config__io_mem_rdata)
  );
  DMemDecoder dmem_decoder ( // @[src/main/scala/fpga/Top.scala 94:28]
    .clock(dmem_decoder_clock),
    .reset(dmem_decoder_reset),
    .io_initiator_raddr(dmem_decoder_io_initiator_raddr),
    .io_initiator_rdata(dmem_decoder_io_initiator_rdata),
    .io_initiator_ren(dmem_decoder_io_initiator_ren),
    .io_initiator_waddr(dmem_decoder_io_initiator_waddr),
    .io_initiator_wen(dmem_decoder_io_initiator_wen),
    .io_initiator_wready(dmem_decoder_io_initiator_wready),
    .io_initiator_wdata(dmem_decoder_io_initiator_wdata),
    .io_targets_0_raddr(dmem_decoder_io_targets_0_raddr),
    .io_targets_0_rdata(dmem_decoder_io_targets_0_rdata),
    .io_targets_0_ren(dmem_decoder_io_targets_0_ren),
    .io_targets_0_waddr(dmem_decoder_io_targets_0_waddr),
    .io_targets_0_wen(dmem_decoder_io_targets_0_wen),
    .io_targets_0_wdata(dmem_decoder_io_targets_0_wdata),
    .io_targets_1_wen(dmem_decoder_io_targets_1_wen),
    .io_targets_1_wdata(dmem_decoder_io_targets_1_wdata),
    .io_targets_2_raddr(dmem_decoder_io_targets_2_raddr),
    .io_targets_2_rdata(dmem_decoder_io_targets_2_rdata),
    .io_targets_2_waddr(dmem_decoder_io_targets_2_waddr),
    .io_targets_2_wen(dmem_decoder_io_targets_2_wen),
    .io_targets_2_wdata(dmem_decoder_io_targets_2_wdata),
    .io_targets_3_raddr(dmem_decoder_io_targets_3_raddr),
    .io_targets_3_rdata(dmem_decoder_io_targets_3_rdata),
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
    .io_targets_5_wen(dmem_decoder_io_targets_5_wen),
    .io_targets_5_wdata(dmem_decoder_io_targets_5_wdata),
    .io_targets_6_raddr(dmem_decoder_io_targets_6_raddr),
    .io_targets_6_rdata(dmem_decoder_io_targets_6_rdata)
  );
  IMemDecoder imem_decoder ( // @[src/main/scala/fpga/Top.scala 113:28]
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
  assign io_dram_ren = memory_io_dramPort_ren; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_dram_wen = memory_io_dramPort_wen; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_dram_addr = memory_io_dramPort_addr; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_dram_wdata = memory_io_dramPort_wdata; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_dram_wmask = 16'h0; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_dram_user_busy = 1'h0; // @[src/main/scala/fpga/Top.scala 126:11]
  assign io_gpio = gpio_io_gpio[7:0]; // @[src/main/scala/fpga/Top.scala 207:11]
  assign io_uart_tx = uart_io_tx; // @[src/main/scala/fpga/Top.scala 208:14]
  assign io_sdc_port_clk = sdc_io_sdc_port_clk; // @[src/main/scala/fpga/Top.scala 210:15]
  assign io_sdc_port_cmd_wrt = sdc_io_sdc_port_cmd_wrt; // @[src/main/scala/fpga/Top.scala 210:15]
  assign io_sdc_port_cmd_out = sdc_io_sdc_port_cmd_out; // @[src/main/scala/fpga/Top.scala 210:15]
  assign io_sdc_port_dat_wrt = sdc_io_sdc_port_dat_wrt; // @[src/main/scala/fpga/Top.scala 210:15]
  assign io_sdc_port_dat_out = sdc_io_sdc_port_dat_out; // @[src/main/scala/fpga/Top.scala 210:15]
  assign io_debugSignals_core_ex2_reg_pc = core_io_debug_signal_ex2_reg_pc; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_ex2_is_valid_inst = core_io_debug_signal_ex2_is_valid_inst; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_me_intr = core_io_debug_signal_me_intr; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_mt_intr = core_io_debug_signal_mt_intr; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_trap = core_io_debug_signal_trap; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_cycle_counter = core_io_debug_signal_cycle_counter; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_id_pc = core_io_debug_signal_id_pc; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_id_inst = core_io_debug_signal_id_inst; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_mem3_rdata = core_io_debug_signal_mem3_rdata; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_mem3_rvalid = core_io_debug_signal_mem3_rvalid; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_rwaddr = core_io_debug_signal_rwaddr; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_ex2_reg_is_br = core_io_debug_signal_ex2_reg_is_br; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_id_reg_is_bp_fail = core_io_debug_signal_id_reg_is_bp_fail; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_id_reg_bp_taken = core_io_debug_signal_id_reg_bp_taken; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_core_ic_state = core_io_debug_signal_ic_state; // @[src/main/scala/fpga/Top.scala 173:24]
  assign io_debugSignals_ren = core_io_dmem_ren | core_io_cache_ren; // @[src/main/scala/fpga/Top.scala 176:46]
  assign io_debugSignals_wen = core_io_dmem_wen | core_io_cache_wen; // @[src/main/scala/fpga/Top.scala 180:46]
  assign io_debugSignals_wready = memory_io_cache_wready; // @[src/main/scala/fpga/Top.scala 181:26]
  assign io_debugSignals_wstrb = core_io_dmem_wstrb; // @[src/main/scala/fpga/Top.scala 182:26]
  assign io_debugSignals_wdata = core_io_dmem_wdata; // @[src/main/scala/fpga/Top.scala 179:26]
  assign io_debugSignals_mem_icache_state = memory_io_icache_state; // @[src/main/scala/fpga/Top.scala 189:36]
  assign io_debugSignals_mem_dram_state = memory_io_dram_state; // @[src/main/scala/fpga/Top.scala 190:34]
  assign io_debugSignals_mem_imem_addr = core_io_imem_addr[15:0]; // @[src/main/scala/fpga/Top.scala 191:53]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_inst = imem_decoder_io_initiator_inst; // @[src/main/scala/fpga/Top.scala 120:16]
  assign core_io_imem_valid = imem_decoder_io_initiator_valid; // @[src/main/scala/fpga/Top.scala 120:16]
  assign core_io_dmem_rdata = dmem_decoder_io_initiator_rdata; // @[src/main/scala/fpga/Top.scala 121:16]
  assign core_io_dmem_wready = dmem_decoder_io_initiator_wready; // @[src/main/scala/fpga/Top.scala 121:16]
  assign core_io_cache_ibusy = memory_io_cache_ibusy; // @[src/main/scala/fpga/Top.scala 123:17]
  assign core_io_cache_rdata = memory_io_cache_rdata; // @[src/main/scala/fpga/Top.scala 123:17]
  assign core_io_cache_rvalid = memory_io_cache_rvalid; // @[src/main/scala/fpga/Top.scala 123:17]
  assign core_io_cache_rready = memory_io_cache_rready; // @[src/main/scala/fpga/Top.scala 123:17]
  assign core_io_cache_wready = memory_io_cache_wready; // @[src/main/scala/fpga/Top.scala 123:17]
  assign core_io_pht_mem_rdata = pht_mem_rdata; // @[src/main/scala/fpga/Top.scala 168:25]
  assign core_io_mtimer_mem_raddr = dmem_decoder_io_targets_3_raddr; // @[src/main/scala/fpga/Top.scala 108:30]
  assign core_io_mtimer_mem_waddr = dmem_decoder_io_targets_3_waddr; // @[src/main/scala/fpga/Top.scala 108:30]
  assign core_io_mtimer_mem_wen = dmem_decoder_io_targets_3_wen; // @[src/main/scala/fpga/Top.scala 108:30]
  assign core_io_mtimer_mem_wdata = dmem_decoder_io_targets_3_wdata; // @[src/main/scala/fpga/Top.scala 108:30]
  assign core_io_intr = intr_io_intr_cpu; // @[src/main/scala/fpga/Top.scala 213:16]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_imem_en = imem_decoder_io_targets_1_en; // @[src/main/scala/fpga/Top.scala 118:30]
  assign memory_io_imem_addr = imem_decoder_io_targets_1_addr; // @[src/main/scala/fpga/Top.scala 118:30]
  assign memory_io_cache_iinvalidate = core_io_cache_iinvalidate; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_raddr = core_io_cache_raddr; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_ren = core_io_cache_ren; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_waddr = core_io_cache_waddr; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_wen = core_io_cache_wen; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_wstrb = core_io_cache_wstrb; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_cache_wdata = core_io_cache_wdata; // @[src/main/scala/fpga/Top.scala 123:17]
  assign memory_io_dramPort_init_calib_complete = io_dram_init_calib_complete; // @[src/main/scala/fpga/Top.scala 126:11]
  assign memory_io_dramPort_rdata = io_dram_rdata; // @[src/main/scala/fpga/Top.scala 126:11]
  assign memory_io_dramPort_rdata_valid = io_dram_rdata_valid; // @[src/main/scala/fpga/Top.scala 126:11]
  assign memory_io_dramPort_busy = io_dram_busy; // @[src/main/scala/fpga/Top.scala 126:11]
  assign memory_io_cache_array1_rdata = dcache1_rdata; // @[src/main/scala/fpga/Top.scala 135:32]
  assign memory_io_cache_array2_rdata = dcache2_rdata; // @[src/main/scala/fpga/Top.scala 143:32]
  assign memory_io_icache_rdata = icache_rdata; // @[src/main/scala/fpga/Top.scala 149:26]
  assign memory_io_icache_valid_rdata = icache_valid_rdata; // @[src/main/scala/fpga/Top.scala 159:32]
  assign boot_rom_clock = clock;
  assign boot_rom_reset = reset;
  assign boot_rom_io_imem_en = imem_decoder_io_targets_0_en; // @[src/main/scala/fpga/Top.scala 117:30]
  assign boot_rom_io_imem_addr = imem_decoder_io_targets_0_addr; // @[src/main/scala/fpga/Top.scala 117:30]
  assign boot_rom_io_dmem_raddr = dmem_decoder_io_targets_0_raddr; // @[src/main/scala/fpga/Top.scala 104:30]
  assign boot_rom_io_dmem_ren = dmem_decoder_io_targets_0_ren; // @[src/main/scala/fpga/Top.scala 104:30]
  assign boot_rom_io_dmem_waddr = dmem_decoder_io_targets_0_waddr; // @[src/main/scala/fpga/Top.scala 104:30]
  assign boot_rom_io_dmem_wen = dmem_decoder_io_targets_0_wen; // @[src/main/scala/fpga/Top.scala 104:30]
  assign boot_rom_io_dmem_wdata = dmem_decoder_io_targets_0_wdata; // @[src/main/scala/fpga/Top.scala 104:30]
  assign dcache1_clock = clock; // @[src/main/scala/fpga/Top.scala 128:20]
  assign dcache1_ren = memory_io_cache_array1_ren; // @[src/main/scala/fpga/Top.scala 129:18]
  assign dcache1_wen = memory_io_cache_array1_wen; // @[src/main/scala/fpga/Top.scala 130:18]
  assign dcache1_we = memory_io_cache_array1_we; // @[src/main/scala/fpga/Top.scala 131:17]
  assign dcache1_raddr = memory_io_cache_array1_raddr; // @[src/main/scala/fpga/Top.scala 132:20]
  assign dcache1_waddr = memory_io_cache_array1_waddr; // @[src/main/scala/fpga/Top.scala 133:20]
  assign dcache1_wdata = memory_io_cache_array1_wdata; // @[src/main/scala/fpga/Top.scala 134:20]
  assign dcache2_clock = clock; // @[src/main/scala/fpga/Top.scala 136:20]
  assign dcache2_ren = memory_io_cache_array2_ren; // @[src/main/scala/fpga/Top.scala 137:18]
  assign dcache2_wen = memory_io_cache_array2_wen; // @[src/main/scala/fpga/Top.scala 138:18]
  assign dcache2_we = memory_io_cache_array2_we; // @[src/main/scala/fpga/Top.scala 139:17]
  assign dcache2_raddr = memory_io_cache_array2_raddr; // @[src/main/scala/fpga/Top.scala 140:20]
  assign dcache2_waddr = memory_io_cache_array2_waddr; // @[src/main/scala/fpga/Top.scala 141:20]
  assign dcache2_wdata = memory_io_cache_array2_wdata; // @[src/main/scala/fpga/Top.scala 142:20]
  assign icache_clock = clock; // @[src/main/scala/fpga/Top.scala 145:19]
  assign icache_ren = memory_io_icache_ren; // @[src/main/scala/fpga/Top.scala 146:17]
  assign icache_wen = memory_io_icache_wen; // @[src/main/scala/fpga/Top.scala 147:17]
  assign icache_raddr = memory_io_icache_raddr; // @[src/main/scala/fpga/Top.scala 148:19]
  assign icache_waddr = memory_io_icache_waddr; // @[src/main/scala/fpga/Top.scala 150:19]
  assign icache_wdata = memory_io_icache_wdata; // @[src/main/scala/fpga/Top.scala 151:19]
  assign icache_valid_clock = clock; // @[src/main/scala/fpga/Top.scala 153:25]
  assign icache_valid_ren = memory_io_icache_valid_ren; // @[src/main/scala/fpga/Top.scala 154:23]
  assign icache_valid_wen = memory_io_icache_valid_wen; // @[src/main/scala/fpga/Top.scala 155:23]
  assign icache_valid_ien = memory_io_icache_valid_invalidate; // @[src/main/scala/fpga/Top.scala 162:23]
  assign icache_valid_invalidate = memory_io_icache_valid_invalidate; // @[src/main/scala/fpga/Top.scala 156:30]
  assign icache_valid_addr = memory_io_icache_valid_addr; // @[src/main/scala/fpga/Top.scala 157:24]
  assign icache_valid_iaddr = memory_io_icache_valid_iaddr; // @[src/main/scala/fpga/Top.scala 158:25]
  assign icache_valid_wdata = memory_io_icache_valid_wdata; // @[src/main/scala/fpga/Top.scala 160:25]
  assign icache_valid_idata = 64'h0; // @[src/main/scala/fpga/Top.scala 161:25]
  assign pht_mem_clock = clock; // @[src/main/scala/fpga/Top.scala 164:20]
  assign pht_mem_ren = 1'h1; // @[src/main/scala/fpga/Top.scala 165:20]
  assign pht_mem_wen = core_io_pht_mem_wen; // @[src/main/scala/fpga/Top.scala 166:20]
  assign pht_mem_raddr = core_io_pht_mem_raddr; // @[src/main/scala/fpga/Top.scala 167:20]
  assign pht_mem_waddr = core_io_pht_mem_waddr; // @[src/main/scala/fpga/Top.scala 169:20]
  assign pht_mem_wdata = core_io_pht_mem_wdata; // @[src/main/scala/fpga/Top.scala 170:20]
  assign gpio_clock = clock;
  assign gpio_reset = reset;
  assign gpio_io_mem_wen = dmem_decoder_io_targets_1_wen; // @[src/main/scala/fpga/Top.scala 106:30]
  assign gpio_io_mem_wdata = dmem_decoder_io_targets_1_wdata; // @[src/main/scala/fpga/Top.scala 106:30]
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_mem_raddr = dmem_decoder_io_targets_2_raddr; // @[src/main/scala/fpga/Top.scala 107:30]
  assign uart_io_mem_waddr = dmem_decoder_io_targets_2_waddr; // @[src/main/scala/fpga/Top.scala 107:30]
  assign uart_io_mem_wen = dmem_decoder_io_targets_2_wen; // @[src/main/scala/fpga/Top.scala 107:30]
  assign uart_io_mem_wdata = dmem_decoder_io_targets_2_wdata; // @[src/main/scala/fpga/Top.scala 107:30]
  assign uart_io_rx = io_uart_rx; // @[src/main/scala/fpga/Top.scala 209:14]
  assign sdc_clock = clock;
  assign sdc_reset = reset;
  assign sdc_io_mem_raddr = dmem_decoder_io_targets_4_raddr; // @[src/main/scala/fpga/Top.scala 109:30]
  assign sdc_io_mem_ren = dmem_decoder_io_targets_4_ren; // @[src/main/scala/fpga/Top.scala 109:30]
  assign sdc_io_mem_waddr = dmem_decoder_io_targets_4_waddr; // @[src/main/scala/fpga/Top.scala 109:30]
  assign sdc_io_mem_wen = dmem_decoder_io_targets_4_wen; // @[src/main/scala/fpga/Top.scala 109:30]
  assign sdc_io_mem_wdata = dmem_decoder_io_targets_4_wdata; // @[src/main/scala/fpga/Top.scala 109:30]
  assign sdc_io_sdc_port_res_in = io_sdc_port_res_in; // @[src/main/scala/fpga/Top.scala 210:15]
  assign sdc_io_sdc_port_dat_in = io_sdc_port_dat_in; // @[src/main/scala/fpga/Top.scala 210:15]
  assign sdc_io_sdbuf_rdata1 = sdbuf_rdata1; // @[src/main/scala/fpga/Top.scala 220:23]
  assign sdc_io_sdbuf_rdata2 = sdbuf_rdata2; // @[src/main/scala/fpga/Top.scala 225:23]
  assign sdbuf_clock = clock; // @[src/main/scala/fpga/Top.scala 215:19]
  assign sdbuf_ren1 = sdc_io_sdbuf_ren1; // @[src/main/scala/fpga/Top.scala 216:19]
  assign sdbuf_wen1 = sdc_io_sdbuf_wen1; // @[src/main/scala/fpga/Top.scala 217:19]
  assign sdbuf_addr1 = sdc_io_sdbuf_addr1; // @[src/main/scala/fpga/Top.scala 218:19]
  assign sdbuf_wdata1 = sdc_io_sdbuf_wdata1; // @[src/main/scala/fpga/Top.scala 219:19]
  assign sdbuf_ren2 = sdc_io_sdbuf_ren2; // @[src/main/scala/fpga/Top.scala 221:19]
  assign sdbuf_wen2 = sdc_io_sdbuf_wen2; // @[src/main/scala/fpga/Top.scala 222:19]
  assign sdbuf_addr2 = sdc_io_sdbuf_addr2; // @[src/main/scala/fpga/Top.scala 223:19]
  assign sdbuf_wdata2 = sdc_io_sdbuf_wdata2; // @[src/main/scala/fpga/Top.scala 224:19]
  assign intr_clock = clock;
  assign intr_reset = reset;
  assign intr_io_mem_raddr = dmem_decoder_io_targets_5_raddr; // @[src/main/scala/fpga/Top.scala 110:30]
  assign intr_io_mem_wen = dmem_decoder_io_targets_5_wen; // @[src/main/scala/fpga/Top.scala 110:30]
  assign intr_io_mem_wdata = dmem_decoder_io_targets_5_wdata; // @[src/main/scala/fpga/Top.scala 110:30]
  assign intr_io_intr_periferal = {sdc_io_intr,uart_io_intr}; // @[src/main/scala/fpga/Top.scala 212:32]
  assign config__io_mem_raddr = dmem_decoder_io_targets_6_raddr; // @[src/main/scala/fpga/Top.scala 111:30]
  assign dmem_decoder_clock = clock;
  assign dmem_decoder_reset = reset;
  assign dmem_decoder_io_initiator_raddr = core_io_dmem_raddr; // @[src/main/scala/fpga/Top.scala 121:16]
  assign dmem_decoder_io_initiator_ren = core_io_dmem_ren; // @[src/main/scala/fpga/Top.scala 121:16]
  assign dmem_decoder_io_initiator_waddr = core_io_dmem_waddr; // @[src/main/scala/fpga/Top.scala 121:16]
  assign dmem_decoder_io_initiator_wen = core_io_dmem_wen; // @[src/main/scala/fpga/Top.scala 121:16]
  assign dmem_decoder_io_initiator_wdata = core_io_dmem_wdata; // @[src/main/scala/fpga/Top.scala 121:16]
  assign dmem_decoder_io_targets_0_rdata = boot_rom_io_dmem_rdata; // @[src/main/scala/fpga/Top.scala 104:30]
  assign dmem_decoder_io_targets_2_rdata = uart_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 107:30]
  assign dmem_decoder_io_targets_3_rdata = core_io_mtimer_mem_rdata; // @[src/main/scala/fpga/Top.scala 108:30]
  assign dmem_decoder_io_targets_4_rdata = sdc_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 109:30]
  assign dmem_decoder_io_targets_5_rdata = intr_io_mem_rdata; // @[src/main/scala/fpga/Top.scala 110:30]
  assign dmem_decoder_io_targets_6_rdata = config__io_mem_rdata; // @[src/main/scala/fpga/Top.scala 111:30]
  assign imem_decoder_clock = clock;
  assign imem_decoder_io_initiator_addr = core_io_imem_addr; // @[src/main/scala/fpga/Top.scala 120:16]
  assign imem_decoder_io_targets_0_inst = boot_rom_io_imem_inst; // @[src/main/scala/fpga/Top.scala 117:30]
  assign imem_decoder_io_targets_0_valid = boot_rom_io_imem_valid; // @[src/main/scala/fpga/Top.scala 117:30]
  assign imem_decoder_io_targets_1_inst = memory_io_imem_inst; // @[src/main/scala/fpga/Top.scala 118:30]
  assign imem_decoder_io_targets_1_valid = memory_io_imem_valid; // @[src/main/scala/fpga/Top.scala 118:30]
endmodule
