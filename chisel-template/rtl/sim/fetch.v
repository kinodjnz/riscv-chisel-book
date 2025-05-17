module FetchUnit(
  input         clock,
  input         reset,
  input         io_flush_en, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input  [30:0] io_flush_iaddr, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst1_valid, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [30:0] io_inst1_addr, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [31:0] io_inst1_data, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst1_bpfail, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst1_half, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst2_valid, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [30:0] io_inst2_addr, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [31:0] io_inst2_data, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst2_bpfail, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_inst2_half, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input         io_inst1_ready, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input         io_inst2_ready, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_imem_en, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [31:0] io_imem_addr, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input  [63:0] io_imem_inst, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input         io_imem_valid, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output        io_icache_addr_en, // @[src/main/scala/fpga/Fetch.scala 72:14]
  output [31:0] io_icache_addr, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input         io_icache_addr_ready, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input  [63:0] io_icache_idata, // @[src/main/scala/fpga/Fetch.scala 72:14]
  input         io_icache_idata_valid // @[src/main/scala/fpga/Fetch.scala 72:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  reg [30:0] fetch_buf_iaddr [0:3]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_start_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_start_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_start_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_6_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_12_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [30:0] fetch_buf_iaddr_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iaddr_MPORT_13_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_13_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iaddr_MPORT_13_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  reg [63:0] fetch_buf_idata [0:3]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_start_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_start_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_start_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_6_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_12_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [63:0] fetch_buf_idata_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_idata_MPORT_13_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_13_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_idata_MPORT_13_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  reg  fetch_buf_receipt_advance [0:3]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_start_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_start_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_start_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_6_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_12_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_receipt_advance_MPORT_13_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_13_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_receipt_advance_MPORT_13_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  reg  fetch_buf_iblock_cont [0:3]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_start_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_start_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_start_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_6_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_12_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_13_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_13_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_iblock_cont_MPORT_13_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  reg [1:0] fetch_buf_end_of_iblock [0:3]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_receipt_advance_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_receipt_advance_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_start_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_start_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_start_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_6_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_12_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_13_addr; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_13_mask; // @[src/main/scala/fpga/Fetch.scala 82:22]
  wire  fetch_buf_end_of_iblock_MPORT_13_en; // @[src/main/scala/fpga/Fetch.scala 82:22]
  reg [2:0] addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 83:31]
  reg [2:0] receipt_ptr; // @[src/main/scala/fpga/Fetch.scala 84:31]
  reg [2:0] fetch_ptr; // @[src/main/scala/fpga/Fetch.scala 85:31]
  reg [2:0] read_ptr; // @[src/main/scala/fpga/Fetch.scala 86:31]
  reg [30:0] reg_next_iaddr; // @[src/main/scala/fpga/Fetch.scala 91:33]
  wire [30:0] iaddr = io_flush_en ? io_flush_iaddr : reg_next_iaddr; // @[src/main/scala/fpga/Fetch.scala 93:17]
  wire [30:0] _reg_next_iaddr_T_1 = iaddr + 31'h4; // @[src/main/scala/fpga/Fetch.scala 94:29]
  wire [2:0] count = addressing_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 96:32]
  wire  has_space = ~count[2]; // @[src/main/scala/fpga/Fetch.scala 97:22]
  wire [31:0] _is_dram_T = {iaddr,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  is_dram = _is_dram_T[31:28] == 4'h2; // @[src/main/scala/fpga/Fetch.scala 13:68]
  wire  _io_imem_en_T = has_space | io_flush_en; // @[src/main/scala/fpga/Fetch.scala 102:37]
  wire  _T_4 = ~_io_imem_en_T | is_dram & ~io_icache_addr_ready; // @[src/main/scala/fpga/Fetch.scala 109:39]
  wire [2:0] _addressing_ptr_T_1 = addressing_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 113:40]
  wire  _T_7 = ~reset; // @[src/main/scala/fpga/Fetch.scala 115:13]
  wire [63:0] idata = io_imem_valid ? io_imem_inst : io_icache_idata; // @[src/main/scala/fpga/Fetch.scala 136:20]
  wire  _T_39 = io_imem_valid | io_icache_idata_valid; // @[src/main/scala/fpga/Fetch.scala 148:25]
  wire [2:0] _fetch_ptr_T_1 = fetch_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 150:32]
  wire [2:0] _receipt_ptr_T_1 = receipt_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 156:36]
  wire [31:0] _T_49 = {fetch_buf_iaddr_MPORT_10_data,1'h0}; // @[src/main/scala/fpga/Fetch.scala 163:19]
  wire [2:0] count_1 = receipt_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 177:29]
  wire [1:0] sat_count = ~count_1[2] ? count_1[1:0] : 2'h2; // @[src/main/scala/fpga/Fetch.scala 178:24]
  wire [1:0] start_of_iblock = fetch_buf_iaddr_start_of_iblock_MPORT_data[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire [2:0] _end_of_iblocks_T_1 = {{1'd0}, read_ptr[1:0]}; // @[src/main/scala/fpga/Fetch.scala 181:86]
  wire [2:0] _end_of_iblock_ov_T = {1'h1,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data}; // @[src/main/scala/fpga/Fetch.scala 183:55]
  wire [2:0] _end_of_iblock_ov_T_1 = {1'h0,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 183:86]
  wire [2:0] _end_of_iblock_ov_T_2 = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? _end_of_iblock_ov_T :
    _end_of_iblock_ov_T_1; // @[src/main/scala/fpga/Fetch.scala 183:32]
  wire [2:0] _GEN_61 = {{1'd0}, start_of_iblock}; // @[src/main/scala/fpga/Fetch.scala 183:108]
  wire [2:0] end_of_iblock_ov = _end_of_iblock_ov_T_2 - _GEN_61; // @[src/main/scala/fpga/Fetch.scala 183:108]
  wire [1:0] end_of_iblock = end_of_iblock_ov > 3'h3 ? 2'h3 : end_of_iblock_ov[1:0]; // @[src/main/scala/fpga/Fetch.scala 184:28]
  wire  _read_end_ov_T = sat_count == 2'h1; // @[src/main/scala/fpga/Fetch.scala 185:38]
  wire [127:0] _idatas_T = {fetch_buf_idata_idata1_MPORT_data,fetch_buf_idata_idata0_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 190:27]
  wire [5:0] _idatas_T_1 = {start_of_iblock,4'h0}; // @[src/main/scala/fpga/Fetch.scala 190:58]
  wire [127:0] _idatas_T_2 = _idatas_T >> _idatas_T_1; // @[src/main/scala/fpga/Fetch.scala 190:38]
  wire [15:0] idatas_0 = _idatas_T_2[15:0]; // @[src/main/scala/common/UIntExtension.scala 15:102]
  wire [15:0] idatas_1 = _idatas_T_2[31:16]; // @[src/main/scala/common/UIntExtension.scala 15:102]
  wire [15:0] idatas_2 = _idatas_T_2[47:32]; // @[src/main/scala/common/UIntExtension.scala 15:102]
  wire [15:0] idatas_3 = _idatas_T_2[63:48]; // @[src/main/scala/common/UIntExtension.scala 15:102]
  wire  _is_halfs_us_T_18 = fetch_buf_idata_idata0_MPORT_data[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 192:91]
  wire  _is_halfs_us_T_24 = fetch_buf_idata_idata0_MPORT_data[17:16] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 192:91]
  wire  _is_halfs_us_T_30 = fetch_buf_idata_idata0_MPORT_data[33:32] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 192:91]
  wire  _is_halfs_us_T_36 = fetch_buf_idata_idata0_MPORT_data[49:48] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 192:91]
  wire [5:0] is_halfs_us = {fetch_buf_idata_idata1_MPORT_data[17:16] != 2'h3,fetch_buf_idata_idata1_MPORT_data[1:0] != 2'h3
    ,_is_halfs_us_T_36,_is_halfs_us_T_30,_is_halfs_us_T_24,_is_halfs_us_T_18}; // @[src/main/scala/fpga/Fetch.scala 191:110]
  wire [5:0] _is_halfs_T = is_halfs_us >> start_of_iblock; // @[src/main/scala/fpga/Fetch.scala 193:33]
  wire [2:0] is_halfs = _is_halfs_T[2:0]; // @[src/main/scala/fpga/Fetch.scala 193:52]
  wire [1:0] _inst1_past_us_T_2 = is_halfs[0] ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Fetch.scala 196:70]
  wire [2:0] _GEN_63 = {{1'd0}, _inst1_past_us_T_2}; // @[src/main/scala/fpga/Fetch.scala 196:65]
  wire [2:0] inst1_past_us = _GEN_61 + _GEN_63; // @[src/main/scala/fpga/Fetch.scala 196:65]
  wire  _inst1_end_T_1 = ~fetch_buf_iblock_cont_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 197:41]
  wire [1:0] inst1_end = is_halfs[0] | ~fetch_buf_iblock_cont_iblock_cont_MPORT_data & start_of_iblock ==
    fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data ? 2'h0 : 2'h1; // @[src/main/scala/fpga/Fetch.scala 197:24]
  wire [2:0] _GEN_64 = {{1'd0}, inst1_end}; // @[src/main/scala/fpga/Fetch.scala 198:64]
  wire [2:0] inst1_end_us = _GEN_61 + _GEN_64; // @[src/main/scala/fpga/Fetch.scala 198:64]
  wire  inst2_half = is_halfs[0] ? is_halfs[1] : is_halfs[2]; // @[src/main/scala/fpga/Fetch.scala 199:25]
  wire [1:0] _inst2_past_us_T = inst2_half ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Fetch.scala 200:44]
  wire [2:0] _GEN_65 = {{1'd0}, _inst2_past_us_T}; // @[src/main/scala/fpga/Fetch.scala 200:39]
  wire [2:0] inst2_past_us = inst1_past_us + _GEN_65; // @[src/main/scala/fpga/Fetch.scala 200:39]
  wire [2:0] _GEN_66 = {{1'd0}, fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 202:57]
  wire  _inst2_end_T_5 = is_halfs[1] | _inst1_end_T_1 & inst1_past_us == _GEN_66; // @[src/main/scala/fpga/Fetch.scala 202:23]
  wire [1:0] _inst2_end_T_6 = is_halfs[1] | _inst1_end_T_1 & inst1_past_us == _GEN_66 ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Fetch.scala 202:10]
  wire [1:0] _inst2_end_T_12 = _inst2_end_T_5 ? 2'h2 : 2'h3; // @[src/main/scala/fpga/Fetch.scala 203:10]
  wire [1:0] inst2_end = is_halfs[0] ? _inst2_end_T_6 : _inst2_end_T_12; // @[src/main/scala/fpga/Fetch.scala 201:24]
  wire [2:0] _GEN_68 = {{1'd0}, inst2_end}; // @[src/main/scala/fpga/Fetch.scala 205:64]
  wire [2:0] inst2_end_us = _GEN_61 + _GEN_68; // @[src/main/scala/fpga/Fetch.scala 205:64]
  wire  _inst1_valid_T = inst1_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 206:41]
  wire  _inst1_valid_T_2 = io_flush_en | sat_count == 2'h0; // @[src/main/scala/fpga/Fetch.scala 207:20]
  wire  _inst1_valid_T_7 = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? ~inst1_end_us[2] : inst1_end_us <= _GEN_66; // @[src/main/scala/fpga/Fetch.scala 208:48]
  wire  _inst1_valid_T_8 = _read_end_ov_T ? _inst1_valid_T_7 : _inst1_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst1_valid = _inst1_valid_T_2 ? 1'h0 : _inst1_valid_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _inst2_valid_T = inst2_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 210:41]
  wire  _inst2_valid_T_7 = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? ~inst2_end_us[2] : inst2_end_us <= _GEN_66; // @[src/main/scala/fpga/Fetch.scala 212:48]
  wire  _inst2_valid_T_8 = _read_end_ov_T ? _inst2_valid_T_7 : _inst2_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _io_inst1_data_T = {idatas_1,idatas_0}; // @[src/main/scala/fpga/Fetch.scala 215:34]
  wire [30:0] _io_inst2_addr_T_1 = inst1_past_us[2] ? fetch_buf_iaddr_iaddrs_MPORT_1_data :
    fetch_buf_iaddr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 226:25]
  wire [31:0] _io_inst2_data_T_1 = {idatas_2,idatas_1}; // @[src/main/scala/fpga/Fetch.scala 228:51]
  wire [31:0] _io_inst2_data_T_2 = {idatas_3,idatas_2}; // @[src/main/scala/fpga/Fetch.scala 228:75]
  wire  _inst_past_T_1 = io_inst2_ready & inst2_valid; // @[src/main/scala/fpga/Fetch.scala 233:23]
  wire  _inst_past_T_3 = (io_inst1_ready | io_inst2_ready) & inst1_valid; // @[src/main/scala/fpga/Fetch.scala 234:43]
  wire [2:0] _inst_past_T_4 = _inst_past_T_3 ? inst1_past_us : _GEN_61; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] inst_past = _inst_past_T_1 ? inst2_past_us : _inst_past_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  iaddr_update = _inst_past_T_1 | _inst_past_T_3; // @[src/main/scala/fpga/Fetch.scala 236:56]
  wire  _read_ptr_T_3 = inst_past[2] | inst_past[1:0] > fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 237:58]
  wire [2:0] _GEN_71 = {{2'd0}, _read_ptr_T_3}; // @[src/main/scala/fpga/Fetch.scala 237:26]
  wire [2:0] _read_ptr_T_6 = read_ptr + _GEN_71; // @[src/main/scala/fpga/Fetch.scala 237:26]
  wire  _T_62 = inst_past[2] & fetch_buf_iblock_cont_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 239:39]
  wire [2:0] _T_64 = read_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 240:29]
  wire [3:0] _T_70 = {{1'd0}, read_ptr}; // @[src/main/scala/fpga/Fetch.scala 242:29]
  wire  _GEN_44 = inst_past[2] & fetch_buf_iblock_cont_iblock_cont_MPORT_data ? 1'h0 : 1'h1; // @[src/main/scala/fpga/Fetch.scala 239:55 242:18 82:22]
  assign fetch_buf_iaddr_MPORT_2_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_2_addr = 2'h0;
  assign fetch_buf_iaddr_MPORT_2_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_2_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_MPORT_3_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_3_addr = 2'h1;
  assign fetch_buf_iaddr_MPORT_3_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_MPORT_4_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_4_addr = 2'h2;
  assign fetch_buf_iaddr_MPORT_4_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_MPORT_5_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_5_addr = 2'h3;
  assign fetch_buf_iaddr_MPORT_5_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_receipt_advance_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_receipt_advance_MPORT_addr = receipt_ptr[1:0];
  assign fetch_buf_iaddr_receipt_advance_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_receipt_advance_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_MPORT_10_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_iaddr_MPORT_10_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_10_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_10_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_start_of_iblock_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_start_of_iblock_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_start_of_iblock_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_start_of_iblock_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_iblock_cont_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_iaddrs_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_idata0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_idata1_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iaddr_MPORT_data = io_flush_en ? io_flush_iaddr : reg_next_iaddr;
  assign fetch_buf_iaddr_MPORT_addr = addressing_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_mask = 1'h1;
  assign fetch_buf_iaddr_MPORT_en = has_space | io_flush_en;
  assign fetch_buf_iaddr_MPORT_1_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_1_addr = addressing_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_1_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_1_en = has_space | io_flush_en;
  assign fetch_buf_iaddr_MPORT_6_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_6_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_6_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_6_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iaddr_MPORT_7_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_7_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iaddr_MPORT_8_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_8_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_8_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_8_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iaddr_MPORT_9_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_9_addr = receipt_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_9_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_9_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_iaddr_MPORT_11_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_11_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_11_en = 1'h0;
  assign fetch_buf_iaddr_MPORT_12_data = {fetch_buf_iaddr_iaddrs_MPORT_1_data[30:2],inst_past[1:0]};
  assign fetch_buf_iaddr_MPORT_12_addr = _T_64[1:0];
  assign fetch_buf_iaddr_MPORT_12_mask = 1'h1;
  assign fetch_buf_iaddr_MPORT_12_en = iaddr_update & _T_62;
  assign fetch_buf_iaddr_MPORT_13_data = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],inst_past[1:0]};
  assign fetch_buf_iaddr_MPORT_13_addr = _T_70[1:0];
  assign fetch_buf_iaddr_MPORT_13_mask = 1'h1;
  assign fetch_buf_iaddr_MPORT_13_en = iaddr_update & _GEN_44;
  assign fetch_buf_idata_MPORT_2_en = 1'h1;
  assign fetch_buf_idata_MPORT_2_addr = 2'h0;
  assign fetch_buf_idata_MPORT_2_data = fetch_buf_idata[fetch_buf_idata_MPORT_2_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_MPORT_3_en = 1'h1;
  assign fetch_buf_idata_MPORT_3_addr = 2'h1;
  assign fetch_buf_idata_MPORT_3_data = fetch_buf_idata[fetch_buf_idata_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_MPORT_4_en = 1'h1;
  assign fetch_buf_idata_MPORT_4_addr = 2'h2;
  assign fetch_buf_idata_MPORT_4_data = fetch_buf_idata[fetch_buf_idata_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_MPORT_5_en = 1'h1;
  assign fetch_buf_idata_MPORT_5_addr = 2'h3;
  assign fetch_buf_idata_MPORT_5_data = fetch_buf_idata[fetch_buf_idata_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_receipt_advance_MPORT_en = 1'h1;
  assign fetch_buf_idata_receipt_advance_MPORT_addr = receipt_ptr[1:0];
  assign fetch_buf_idata_receipt_advance_MPORT_data = fetch_buf_idata[fetch_buf_idata_receipt_advance_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_MPORT_10_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_idata_MPORT_10_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_10_data = fetch_buf_idata[fetch_buf_idata_MPORT_10_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_start_of_iblock_MPORT_en = 1'h1;
  assign fetch_buf_idata_start_of_iblock_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_start_of_iblock_MPORT_data = fetch_buf_idata[fetch_buf_idata_start_of_iblock_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_end_of_iblocks_MPORT_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_idata_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_iblock_cont_MPORT_data = fetch_buf_idata[fetch_buf_idata_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_iaddrs_MPORT_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_idata0_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_idata0_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_idata1_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_idata1_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_idata_MPORT_data = 64'h0;
  assign fetch_buf_idata_MPORT_addr = addressing_ptr[1:0];
  assign fetch_buf_idata_MPORT_mask = 1'h0;
  assign fetch_buf_idata_MPORT_en = has_space | io_flush_en;
  assign fetch_buf_idata_MPORT_1_data = 64'h0;
  assign fetch_buf_idata_MPORT_1_addr = addressing_ptr[1:0];
  assign fetch_buf_idata_MPORT_1_mask = 1'h0;
  assign fetch_buf_idata_MPORT_1_en = has_space | io_flush_en;
  assign fetch_buf_idata_MPORT_6_data = io_imem_valid ? io_imem_inst : io_icache_idata;
  assign fetch_buf_idata_MPORT_6_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_6_mask = 1'h1;
  assign fetch_buf_idata_MPORT_6_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_idata_MPORT_7_data = 64'h0;
  assign fetch_buf_idata_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_7_mask = 1'h0;
  assign fetch_buf_idata_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_idata_MPORT_8_data = 64'h0;
  assign fetch_buf_idata_MPORT_8_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_8_mask = 1'h0;
  assign fetch_buf_idata_MPORT_8_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_idata_MPORT_9_data = 64'h0;
  assign fetch_buf_idata_MPORT_9_addr = receipt_ptr[1:0];
  assign fetch_buf_idata_MPORT_9_mask = 1'h0;
  assign fetch_buf_idata_MPORT_9_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_idata_MPORT_11_data = 64'h0;
  assign fetch_buf_idata_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_11_mask = 1'h0;
  assign fetch_buf_idata_MPORT_11_en = 1'h0;
  assign fetch_buf_idata_MPORT_12_data = 64'h0;
  assign fetch_buf_idata_MPORT_12_addr = _T_64[1:0];
  assign fetch_buf_idata_MPORT_12_mask = 1'h0;
  assign fetch_buf_idata_MPORT_12_en = iaddr_update & _T_62;
  assign fetch_buf_idata_MPORT_13_data = 64'h0;
  assign fetch_buf_idata_MPORT_13_addr = _T_70[1:0];
  assign fetch_buf_idata_MPORT_13_mask = 1'h0;
  assign fetch_buf_idata_MPORT_13_en = iaddr_update & _GEN_44;
  assign fetch_buf_receipt_advance_MPORT_2_en = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_2_addr = 2'h0;
  assign fetch_buf_receipt_advance_MPORT_2_data = fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_2_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_MPORT_3_en = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_3_addr = 2'h1;
  assign fetch_buf_receipt_advance_MPORT_3_data = fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_MPORT_4_en = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_4_addr = 2'h2;
  assign fetch_buf_receipt_advance_MPORT_4_data = fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_MPORT_5_en = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_5_addr = 2'h3;
  assign fetch_buf_receipt_advance_MPORT_5_data = fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_receipt_advance_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_receipt_advance_MPORT_addr = receipt_ptr[1:0];
  assign fetch_buf_receipt_advance_receipt_advance_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_receipt_advance_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_MPORT_10_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_receipt_advance_MPORT_10_addr = fetch_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_10_data = fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_10_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_start_of_iblock_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_start_of_iblock_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_receipt_advance_start_of_iblock_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_start_of_iblock_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_receipt_advance_iblock_cont_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_receipt_advance_iaddrs_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_receipt_advance_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_receipt_advance_iaddrs_MPORT_1_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_idata0_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_receipt_advance_idata0_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_idata1_MPORT_en = 1'h1;
  assign fetch_buf_receipt_advance_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_receipt_advance_idata1_MPORT_data =
    fetch_buf_receipt_advance[fetch_buf_receipt_advance_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_receipt_advance_MPORT_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_addr = addressing_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_en = has_space | io_flush_en;
  assign fetch_buf_receipt_advance_MPORT_1_data = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_1_addr = addressing_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_1_mask = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_1_en = has_space | io_flush_en;
  assign fetch_buf_receipt_advance_MPORT_6_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_6_addr = fetch_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_6_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_6_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_receipt_advance_MPORT_7_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_7_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_receipt_advance_MPORT_8_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_8_addr = fetch_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_8_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_8_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_receipt_advance_MPORT_9_data = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_9_addr = receipt_ptr[1:0];
  assign fetch_buf_receipt_advance_MPORT_9_mask = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_9_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_receipt_advance_MPORT_11_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_receipt_advance_MPORT_11_mask = 1'h1;
  assign fetch_buf_receipt_advance_MPORT_11_en = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_12_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_12_addr = _T_64[1:0];
  assign fetch_buf_receipt_advance_MPORT_12_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_12_en = iaddr_update & _T_62;
  assign fetch_buf_receipt_advance_MPORT_13_data = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_13_addr = _T_70[1:0];
  assign fetch_buf_receipt_advance_MPORT_13_mask = 1'h0;
  assign fetch_buf_receipt_advance_MPORT_13_en = iaddr_update & _GEN_44;
  assign fetch_buf_iblock_cont_MPORT_2_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_2_addr = 2'h0;
  assign fetch_buf_iblock_cont_MPORT_2_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_2_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_MPORT_3_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_3_addr = 2'h1;
  assign fetch_buf_iblock_cont_MPORT_3_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_MPORT_4_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_4_addr = 2'h2;
  assign fetch_buf_iblock_cont_MPORT_4_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_MPORT_5_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_5_addr = 2'h3;
  assign fetch_buf_iblock_cont_MPORT_5_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_receipt_advance_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_receipt_advance_MPORT_addr = receipt_ptr[1:0];
  assign fetch_buf_iblock_cont_receipt_advance_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_receipt_advance_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_MPORT_10_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_iblock_cont_MPORT_10_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_10_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_10_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_start_of_iblock_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_start_of_iblock_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_start_of_iblock_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_start_of_iblock_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_iaddrs_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_idata0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_iblock_cont_MPORT_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_addr = addressing_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_en = has_space | io_flush_en;
  assign fetch_buf_iblock_cont_MPORT_1_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_1_addr = addressing_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_1_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_1_en = has_space | io_flush_en;
  assign fetch_buf_iblock_cont_MPORT_6_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_6_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_6_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_6_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iblock_cont_MPORT_7_data = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_7_mask = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iblock_cont_MPORT_8_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_8_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_8_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_8_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iblock_cont_MPORT_9_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_9_addr = receipt_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_9_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_9_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_iblock_cont_MPORT_11_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_11_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_11_en = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_12_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_12_addr = _T_64[1:0];
  assign fetch_buf_iblock_cont_MPORT_12_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_12_en = iaddr_update & _T_62;
  assign fetch_buf_iblock_cont_MPORT_13_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_13_addr = _T_70[1:0];
  assign fetch_buf_iblock_cont_MPORT_13_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_13_en = iaddr_update & _GEN_44;
  assign fetch_buf_end_of_iblock_MPORT_2_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_2_addr = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_2_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_2_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_MPORT_3_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_3_addr = 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_3_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_MPORT_4_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_4_addr = 2'h2;
  assign fetch_buf_end_of_iblock_MPORT_4_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_MPORT_5_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_5_addr = 2'h3;
  assign fetch_buf_end_of_iblock_MPORT_5_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_receipt_advance_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_receipt_advance_MPORT_addr = receipt_ptr[1:0];
  assign fetch_buf_end_of_iblock_receipt_advance_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_receipt_advance_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_MPORT_10_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_end_of_iblock_MPORT_10_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_10_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_10_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_start_of_iblock_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_start_of_iblock_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_start_of_iblock_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_start_of_iblock_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_idata0_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_idata0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_idata1_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 82:22]
  assign fetch_buf_end_of_iblock_MPORT_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_addr = addressing_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_en = has_space | io_flush_en;
  assign fetch_buf_end_of_iblock_MPORT_1_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_1_addr = addressing_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_1_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_1_en = has_space | io_flush_en;
  assign fetch_buf_end_of_iblock_MPORT_6_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_6_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_6_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_6_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_end_of_iblock_MPORT_7_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_7_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_end_of_iblock_MPORT_8_data = 2'h3;
  assign fetch_buf_end_of_iblock_MPORT_8_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_8_mask = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_8_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_end_of_iblock_MPORT_9_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_9_addr = receipt_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_9_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_9_en = io_imem_valid | io_icache_idata_valid;
  assign fetch_buf_end_of_iblock_MPORT_11_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_11_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_11_en = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_12_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_12_addr = _T_64[1:0];
  assign fetch_buf_end_of_iblock_MPORT_12_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_12_en = iaddr_update & _T_62;
  assign fetch_buf_end_of_iblock_MPORT_13_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_13_addr = _T_70[1:0];
  assign fetch_buf_end_of_iblock_MPORT_13_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_13_en = iaddr_update & _GEN_44;
  assign io_inst1_valid = _inst1_valid_T_2 ? 1'h0 : _inst1_valid_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_inst1_addr = fetch_buf_iaddr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 214:21]
  assign io_inst1_data = {idatas_1,idatas_0}; // @[src/main/scala/fpga/Fetch.scala 215:34]
  assign io_inst1_bpfail = ~is_halfs[0] & end_of_iblock == 2'h0; // @[src/main/scala/fpga/Fetch.scala 216:37]
  assign io_inst1_half = is_halfs[0]; // @[src/main/scala/fpga/Fetch.scala 217:32]
  assign io_inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_8; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_inst2_addr = {_io_inst2_addr_T_1[30:2],inst1_past_us[1:0]}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_inst2_data = is_halfs[0] ? _io_inst2_data_T_1 : _io_inst2_data_T_2; // @[src/main/scala/fpga/Fetch.scala 228:27]
  assign io_inst2_bpfail = is_halfs[0] ? ~is_halfs[1] & end_of_iblock == 2'h1 : ~is_halfs[2] & end_of_iblock == 2'h2; // @[src/main/scala/fpga/Fetch.scala 229:27]
  assign io_inst2_half = is_halfs[0] ? is_halfs[1] : is_halfs[2]; // @[src/main/scala/fpga/Fetch.scala 230:27]
  assign io_imem_en = (has_space | io_flush_en) & ~is_dram; // @[src/main/scala/fpga/Fetch.scala 102:53]
  assign io_imem_addr = {_is_dram_T[31:3],3'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  assign io_icache_addr_en = _io_imem_en_T & is_dram; // @[src/main/scala/fpga/Fetch.scala 104:53]
  assign io_icache_addr = {_is_dram_T[31:3],3'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  always @(posedge clock) begin
    if (fetch_buf_iaddr_MPORT_en & fetch_buf_iaddr_MPORT_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_addr] <= fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_1_en & fetch_buf_iaddr_MPORT_1_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_1_addr] <= fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_6_en & fetch_buf_iaddr_MPORT_6_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_6_addr] <= fetch_buf_iaddr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_7_en & fetch_buf_iaddr_MPORT_7_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_7_addr] <= fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_8_en & fetch_buf_iaddr_MPORT_8_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_8_addr] <= fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_9_en & fetch_buf_iaddr_MPORT_9_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_9_addr] <= fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_11_en & fetch_buf_iaddr_MPORT_11_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_11_addr] <= fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_12_en & fetch_buf_iaddr_MPORT_12_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_12_addr] <= fetch_buf_iaddr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iaddr_MPORT_13_en & fetch_buf_iaddr_MPORT_13_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_13_addr] <= fetch_buf_iaddr_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_en & fetch_buf_idata_MPORT_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_addr] <= fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_1_en & fetch_buf_idata_MPORT_1_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_1_addr] <= fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_6_en & fetch_buf_idata_MPORT_6_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_6_addr] <= fetch_buf_idata_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_7_en & fetch_buf_idata_MPORT_7_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_7_addr] <= fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_8_en & fetch_buf_idata_MPORT_8_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_8_addr] <= fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_9_en & fetch_buf_idata_MPORT_9_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_9_addr] <= fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_11_en & fetch_buf_idata_MPORT_11_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_11_addr] <= fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_12_en & fetch_buf_idata_MPORT_12_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_12_addr] <= fetch_buf_idata_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_idata_MPORT_13_en & fetch_buf_idata_MPORT_13_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_13_addr] <= fetch_buf_idata_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_en & fetch_buf_receipt_advance_MPORT_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_addr] <= fetch_buf_receipt_advance_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_1_en & fetch_buf_receipt_advance_MPORT_1_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_1_addr] <= fetch_buf_receipt_advance_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_6_en & fetch_buf_receipt_advance_MPORT_6_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_6_addr] <= fetch_buf_receipt_advance_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_7_en & fetch_buf_receipt_advance_MPORT_7_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_7_addr] <= fetch_buf_receipt_advance_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_8_en & fetch_buf_receipt_advance_MPORT_8_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_8_addr] <= fetch_buf_receipt_advance_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_9_en & fetch_buf_receipt_advance_MPORT_9_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_9_addr] <= fetch_buf_receipt_advance_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_11_en & fetch_buf_receipt_advance_MPORT_11_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_11_addr] <= fetch_buf_receipt_advance_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_12_en & fetch_buf_receipt_advance_MPORT_12_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_12_addr] <= fetch_buf_receipt_advance_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_receipt_advance_MPORT_13_en & fetch_buf_receipt_advance_MPORT_13_mask) begin
      fetch_buf_receipt_advance[fetch_buf_receipt_advance_MPORT_13_addr] <= fetch_buf_receipt_advance_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_en & fetch_buf_iblock_cont_MPORT_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_addr] <= fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_1_en & fetch_buf_iblock_cont_MPORT_1_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_1_addr] <= fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_6_en & fetch_buf_iblock_cont_MPORT_6_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_6_addr] <= fetch_buf_iblock_cont_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_7_en & fetch_buf_iblock_cont_MPORT_7_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_7_addr] <= fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_8_en & fetch_buf_iblock_cont_MPORT_8_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_8_addr] <= fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_9_en & fetch_buf_iblock_cont_MPORT_9_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_9_addr] <= fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_11_en & fetch_buf_iblock_cont_MPORT_11_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_11_addr] <= fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_12_en & fetch_buf_iblock_cont_MPORT_12_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_12_addr] <= fetch_buf_iblock_cont_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_iblock_cont_MPORT_13_en & fetch_buf_iblock_cont_MPORT_13_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_13_addr] <= fetch_buf_iblock_cont_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_en & fetch_buf_end_of_iblock_MPORT_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_addr] <= fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_1_en & fetch_buf_end_of_iblock_MPORT_1_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_1_addr] <= fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_6_en & fetch_buf_end_of_iblock_MPORT_6_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_6_addr] <= fetch_buf_end_of_iblock_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_7_en & fetch_buf_end_of_iblock_MPORT_7_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_7_addr] <= fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_8_en & fetch_buf_end_of_iblock_MPORT_8_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_8_addr] <= fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_9_en & fetch_buf_end_of_iblock_MPORT_9_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_9_addr] <= fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_11_en & fetch_buf_end_of_iblock_MPORT_11_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_11_addr] <= fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_12_en & fetch_buf_end_of_iblock_MPORT_12_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_12_addr] <= fetch_buf_end_of_iblock_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_13_en & fetch_buf_end_of_iblock_MPORT_13_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_13_addr] <= fetch_buf_end_of_iblock_MPORT_13_data; // @[src/main/scala/fpga/Fetch.scala 82:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 83:31]
      addressing_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 83:31]
    end else if (!(~_io_imem_en_T | is_dram & ~io_icache_addr_ready)) begin // @[src/main/scala/fpga/Fetch.scala 109:78]
      addressing_ptr <= _addressing_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 113:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 84:31]
      receipt_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 84:31]
    end else if (io_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 171:24]
      receipt_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 172:19]
    end else if (io_imem_valid | io_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 148:51]
      if (fetch_buf_receipt_advance_receipt_advance_MPORT_data) begin // @[src/main/scala/fpga/Fetch.scala 155:92]
        receipt_ptr <= _receipt_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 156:21]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 85:31]
      fetch_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 85:31]
    end else if (io_imem_valid | io_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 148:51]
      if (fetch_buf_receipt_advance_receipt_advance_MPORT_data) begin // @[src/main/scala/fpga/Fetch.scala 155:92]
        fetch_ptr <= _fetch_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 157:19]
      end else if (fetch_ptr != receipt_ptr) begin // @[src/main/scala/fpga/Fetch.scala 149:40]
        fetch_ptr <= _fetch_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 150:19]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 86:31]
      read_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 86:31]
    end else if (io_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 286:24]
      read_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 287:16]
    end else begin
      read_ptr <= _read_ptr_T_6; // @[src/main/scala/fpga/Fetch.scala 237:14]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 91:33]
      reg_next_iaddr <= 31'hfff0; // @[src/main/scala/fpga/Fetch.scala 91:33]
    end else if (~_io_imem_en_T | is_dram & ~io_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 109:78]
      if (io_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 93:17]
        reg_next_iaddr <= io_flush_iaddr;
      end
    end else begin
      reg_next_iaddr <= _reg_next_iaddr_T_1; // @[src/main/scala/fpga/Fetch.scala 94:20]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~_T_4 & ~reset) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x addressed\n",addressing_ptr,_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 115:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"iaddr=%x\n",_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 123:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"reg_next_iaddr=%x\n",{reg_next_iaddr,1'h0}); // @[src/main/scala/fpga/Fetch.scala 124:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"io.imem.addr=%x\n",io_imem_addr); // @[src/main/scala/fpga/Fetch.scala 125:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"io.imem.en=%d\n",io_imem_en); // @[src/main/scala/fpga/Fetch.scala 126:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"addressing=%d\n",addressing_ptr[1:0]); // @[src/main/scala/fpga/Fetch.scala 127:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"fb(0).iaddr=%x\n",{fetch_buf_iaddr_MPORT_2_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 128:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"fb(1).iaddr=%x\n",{fetch_buf_iaddr_MPORT_3_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 129:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"fb(2).iaddr=%x\n",{fetch_buf_iaddr_MPORT_4_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 130:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_7) begin
          $fwrite(32'h80000002,"fb(3).iaddr=%x\n",{fetch_buf_iaddr_MPORT_5_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 131:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_39 & _T_7) begin
          $fwrite(32'h80000002,"io.imem.valid=%d io.icache.idata_valid=%d\n",io_imem_valid,io_icache_idata_valid); // @[src/main/scala/fpga/Fetch.scala 161:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_39 & _T_7) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x fetched\n",fetch_ptr,_T_49,idata); // @[src/main/scala/fpga/Fetch.scala 162:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (inst1_valid & _T_7) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,{fetch_buf_iaddr_iaddrs_MPORT_data,1'h0},
            _io_inst1_data_T,io_inst1_ready); // @[src/main/scala/fpga/Fetch.scala 291:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (inst2_valid & _T_7) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,{io_inst2_addr,1'h0},io_inst2_data,io_inst2_ready
            ); // @[src/main/scala/fpga/Fetch.scala 294:13]
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
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_iaddr[initvar] = _RAND_0[30:0];
  _RAND_1 = {2{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_idata[initvar] = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_receipt_advance[initvar] = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_iblock_cont[initvar] = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_end_of_iblock[initvar] = _RAND_4[1:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  addressing_ptr = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  receipt_ptr = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  fetch_ptr = _RAND_7[2:0];
  _RAND_8 = {1{`RANDOM}};
  read_ptr = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  reg_next_iaddr = _RAND_9[30:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module FetchSim(
  input         clock,
  input         reset,
  input         io_flush_en, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input  [30:0] io_flush_iaddr, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst1_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [30:0] io_inst1_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [31:0] io_inst1_data, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst1_bpfail, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst1_half, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst2_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [30:0] io_inst2_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [31:0] io_inst2_data, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst2_bpfail, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_inst2_half, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input         io_inst1_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input         io_inst2_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_imem_en, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [31:0] io_imem_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input  [63:0] io_imem_inst, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input         io_imem_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_icache_addr_en, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output [31:0] io_icache_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input         io_icache_addr_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input  [63:0] io_icache_idata, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  input         io_icache_idata_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
  output        io_icache_idata_ready // @[src/main/scala/fpga/sim/FetchSim.scala 9:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  wire  fetch_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [30:0] fetch_io_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [30:0] fetch_io_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [31:0] fetch_io_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst1_bpfail; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst1_half; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [30:0] fetch_io_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [31:0] fetch_io_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst2_bpfail; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst2_half; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [31:0] fetch_io_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [63:0] fetch_io_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [31:0] fetch_io_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire [63:0] fetch_io_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  wire  fetch_io_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
  reg  regs_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg [30:0] regs_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  regs_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  regs_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg [63:0] regs_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  regs_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  regs_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg [63:0] regs_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  regs_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 10:17]
  reg  reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 11:26]
  FetchUnit fetch ( // @[src/main/scala/fpga/sim/FetchSim.scala 12:21]
    .clock(fetch_clock),
    .reset(fetch_reset),
    .io_flush_en(fetch_io_flush_en),
    .io_flush_iaddr(fetch_io_flush_iaddr),
    .io_inst1_valid(fetch_io_inst1_valid),
    .io_inst1_addr(fetch_io_inst1_addr),
    .io_inst1_data(fetch_io_inst1_data),
    .io_inst1_bpfail(fetch_io_inst1_bpfail),
    .io_inst1_half(fetch_io_inst1_half),
    .io_inst2_valid(fetch_io_inst2_valid),
    .io_inst2_addr(fetch_io_inst2_addr),
    .io_inst2_data(fetch_io_inst2_data),
    .io_inst2_bpfail(fetch_io_inst2_bpfail),
    .io_inst2_half(fetch_io_inst2_half),
    .io_inst1_ready(fetch_io_inst1_ready),
    .io_inst2_ready(fetch_io_inst2_ready),
    .io_imem_en(fetch_io_imem_en),
    .io_imem_addr(fetch_io_imem_addr),
    .io_imem_inst(fetch_io_imem_inst),
    .io_imem_valid(fetch_io_imem_valid),
    .io_icache_addr_en(fetch_io_icache_addr_en),
    .io_icache_addr(fetch_io_icache_addr),
    .io_icache_addr_ready(fetch_io_icache_addr_ready),
    .io_icache_idata(fetch_io_icache_idata),
    .io_icache_idata_valid(fetch_io_icache_idata_valid)
  );
  assign io_inst1_valid = fetch_io_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst1_addr = fetch_io_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst1_data = fetch_io_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst1_bpfail = fetch_io_inst1_bpfail; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst1_half = fetch_io_inst1_half; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst2_valid = fetch_io_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst2_addr = fetch_io_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst2_data = fetch_io_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst2_bpfail = fetch_io_inst2_bpfail; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_inst2_half = fetch_io_inst2_half; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_imem_en = fetch_io_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_imem_addr = fetch_io_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_icache_addr_en = fetch_io_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_icache_addr = fetch_io_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign io_icache_idata_ready = 1'h1; // @[src/main/scala/fpga/sim/FetchSim.scala 26:6]
  assign fetch_clock = clock;
  assign fetch_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 14:31]
  assign fetch_io_flush_en = regs_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 15:21]
  assign fetch_io_flush_iaddr = regs_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 23:24]
  assign fetch_io_inst1_ready = regs_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 21:24]
  assign fetch_io_inst2_ready = regs_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 16:24]
  assign fetch_io_imem_inst = regs_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 17:22]
  assign fetch_io_imem_valid = regs_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 20:23]
  assign fetch_io_icache_addr_ready = regs_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 18:30]
  assign fetch_io_icache_idata = regs_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 19:25]
  assign fetch_io_icache_idata_valid = regs_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 22:31]
  always @(posedge clock) begin
    regs_flush_en <= io_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_flush_iaddr <= io_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_inst1_ready <= io_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_inst2_ready <= io_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_imem_inst <= io_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_imem_valid <= io_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_icache_addr_ready <= io_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_icache_idata <= io_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    regs_icache_idata_valid <= io_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 25:8]
    reg_reset <= reset; // @[src/main/scala/fpga/sim/FetchSim.scala 11:{26,26} 24:13]
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
  regs_flush_en = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  regs_flush_iaddr = _RAND_1[30:0];
  _RAND_2 = {1{`RANDOM}};
  regs_inst1_ready = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  regs_inst2_ready = _RAND_3[0:0];
  _RAND_4 = {2{`RANDOM}};
  regs_imem_inst = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  regs_imem_valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  regs_icache_addr_ready = _RAND_6[0:0];
  _RAND_7 = {2{`RANDOM}};
  regs_icache_idata = _RAND_7[63:0];
  _RAND_8 = {1{`RANDOM}};
  regs_icache_idata_valid = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  reg_reset = _RAND_9[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
