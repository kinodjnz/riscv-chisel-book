module Fetcher(
  input         clock,
  input         reset,
  input         io_ft_flush_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [30:0] io_ft_flush_iaddr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_inst1_valid, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [30:0] io_ft_inst1_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [31:0] io_ft_inst1_data, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_inst1_bpfailed, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_inst1_redirected, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst1_bp_entry_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst1_bp_entry_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst1_fp_ptr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_ft_inst1_ready, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_inst2_valid, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [30:0] io_ft_inst2_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [31:0] io_ft_inst2_data, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_inst2_redirected, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst2_bp_entry_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst2_bp_entry_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [1:0]  io_ft_inst2_fp_ptr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_ft_inst2_ready, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_imem_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [31:0] io_ft_imem_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [63:0] io_ft_imem_inst, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_ft_imem_valid, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_ft_icache_addr_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [31:0] io_ft_icache_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_ft_icache_addr_ready, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [63:0] io_ft_icache_idata, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_ft_icache_idata_valid, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_pr_iaddr_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output [30:0] io_pr_iaddr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_pr_flush_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  output        io_pr_redirect_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_pr_redirect_ready, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_pr_bp0_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp0_pos, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [30:0] io_pr_bp0_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input         io_pr_bp1_en, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp1_pos, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [30:0] io_pr_bp1_addr, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_0_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_0_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_1_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_1_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_2_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_2_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_3_lcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [1:0]  io_pr_bp_entries_3_gcnt, // @[src/main/scala/fpga/Fetch.scala 93:14]
  input  [2:0]  io_pr_fp_ptr // @[src/main/scala/fpga/Fetch.scala 93:14]
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
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
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
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
`endif // RANDOMIZE_REG_INIT
  reg [30:0] fetch_buf_iaddr [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [30:0] fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iaddr_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iaddr_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [63:0] fetch_buf_idata [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [63:0] fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_idata_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_idata_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg  fetch_buf_iblock_cont [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_iblock_cont_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_end_of_iblock [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_0_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_0_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_1_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_1_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_2_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_2_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_3_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_bp_entries_3_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [1:0] fetch_buf_fp_ptr [0:3]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 107:22]
  wire  fetch_buf_fp_ptr_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 107:22]
  reg [2:0] addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 108:31]
  reg [2:0] fetch_ptr; // @[src/main/scala/fpga/Fetch.scala 109:31]
  reg [2:0] read_ptr; // @[src/main/scala/fpga/Fetch.scala 110:31]
  reg  discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_1; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_2; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_3; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_4; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_5; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_6; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg  discard_buf_7; // @[src/main/scala/fpga/Fetch.scala 112:28]
  reg [2:0] discard_enq; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg [2:0] discard_deq; // @[src/main/scala/fpga/Fetch.scala 114:28]
  reg  reg_addressed; // @[src/main/scala/fpga/Fetch.scala 124:30]
  reg [30:0] reg_next_iaddr; // @[src/main/scala/fpga/Fetch.scala 127:36]
  reg  reg_fix_zbp_miss; // @[src/main/scala/fpga/Fetch.scala 130:36]
  reg [30:0] reg_fix_addr; // @[src/main/scala/fpga/Fetch.scala 131:36]
  reg [2:0] reg_discard_enq; // @[src/main/scala/fpga/Fetch.scala 132:36]
  reg  reg_is_dram; // @[src/main/scala/fpga/Fetch.scala 133:36]
  wire  invalidate = reg_fix_zbp_miss & reg_addressed; // @[src/main/scala/fpga/Fetch.scala 137:46]
  wire  _zbp_miss_T_4 = ~io_pr_bp0_en & io_pr_bp1_en; // @[src/main/scala/fpga/Fetch.scala 142:24]
  wire  _zbp_miss_T_5 = io_pr_bp0_en & ~io_pr_bp1_en | _zbp_miss_T_4; // @[src/main/scala/fpga/Fetch.scala 141:41]
  wire  _zbp_miss_T_12 = io_pr_bp0_en & io_pr_bp1_en & (io_pr_bp0_addr[7:0] != io_pr_bp1_addr[7:0] | io_pr_bp0_pos !=
    io_pr_bp1_pos); // @[src/main/scala/fpga/Fetch.scala 143:39]
  wire  _zbp_miss_T_13 = _zbp_miss_T_5 | _zbp_miss_T_12; // @[src/main/scala/fpga/Fetch.scala 142:41]
  wire  zbp_miss = ~invalidate & _zbp_miss_T_13; // @[src/main/scala/fpga/Fetch.scala 140:19]
  wire [30:0] _iaddr_T = io_pr_bp0_en ? io_pr_bp0_addr : reg_next_iaddr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] _iaddr_T_1 = reg_fix_zbp_miss ? reg_fix_addr : _iaddr_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] iaddr = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] _reg_next_iaddr_T_1 = {iaddr[30:2],2'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  wire [30:0] _reg_next_iaddr_T_3 = _reg_next_iaddr_T_1 + 31'h4; // @[src/main/scala/fpga/Fetch.scala 151:58]
  wire  _fix_zbp_miss_T = ~io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 152:21]
  wire  fix_zbp_miss = ~io_ft_flush_en & zbp_miss; // @[src/main/scala/fpga/Fetch.scala 152:37]
  wire [2:0] count = addressing_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 157:32]
  wire  has_space = ~count[2]; // @[src/main/scala/fpga/Fetch.scala 158:22]
  wire [31:0] _is_dram_T = {iaddr,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  is_dram = _is_dram_T[31:28] == 4'h2; // @[src/main/scala/fpga/Fetch.scala 13:68]
  wire  redirect_ready = ~(reg_fix_zbp_miss | io_pr_bp0_en) | io_pr_redirect_ready; // @[src/main/scala/fpga/Fetch.scala 162:62]
  wire  _T_1 = invalidate & _fix_zbp_miss_T; // @[src/main/scala/fpga/Fetch.scala 164:22]
  wire [2:0] _addressing_ptr_T_1 = addressing_ptr - 3'h1; // @[src/main/scala/fpga/Fetch.scala 165:40]
  wire  _T_2 = ~is_dram; // @[src/main/scala/fpga/Fetch.scala 167:26]
  wire  wait_for_dram = reg_is_dram & ~is_dram & discard_enq != discard_deq; // @[src/main/scala/fpga/Fetch.scala 167:35]
  wire  _GEN_2 = wait_for_dram | is_dram; // @[src/main/scala/fpga/Fetch.scala 161:17 167:67 169:19]
  wire  _io_ft_imem_en_T = has_space & redirect_ready; // @[src/main/scala/fpga/Fetch.scala 173:41]
  wire  _io_ft_imem_en_T_1 = has_space & redirect_ready | io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 173:60]
  wire  _T_13 = ~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready; // @[src/main/scala/fpga/Fetch.scala 179:80]
  wire [2:0] _discard_enq_T_1 = discard_enq + 3'h1; // @[src/main/scala/fpga/Fetch.scala 186:38]
  wire [2:0] _addressing_ptr_T_3 = addressing_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 190:42]
  wire  _T_18 = ~reset; // @[src/main/scala/fpga/Fetch.scala 193:13]
  wire  _GEN_13 = io_ft_flush_en | discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_14 = io_ft_flush_en | discard_buf_1; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_15 = io_ft_flush_en | discard_buf_2; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_16 = io_ft_flush_en | discard_buf_3; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_17 = io_ft_flush_en | discard_buf_4; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_18 = io_ft_flush_en | discard_buf_5; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_19 = io_ft_flush_en | discard_buf_6; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire  _GEN_20 = io_ft_flush_en | discard_buf_7; // @[src/main/scala/fpga/Fetch.scala 196:27 199:24 112:28]
  wire [1:0] ptr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0]; // @[src/main/scala/fpga/Fetch.scala 203:18]
  wire [1:0] forward_i0 = iaddr[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _discard_buf_T = invalidate | io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 217:50]
  wire  _GEN_27 = 3'h0 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_13; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_28 = 3'h1 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_14; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_29 = 3'h2 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_15; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_30 = 3'h3 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_16; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_31 = 3'h4 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_17; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_32 = 3'h5 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_18; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_33 = 3'h6 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_19; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_34 = 3'h7 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_20; // @[src/main/scala/fpga/Fetch.scala 217:{36,36}]
  wire  _GEN_35 = reg_addressed ? _GEN_27 : _GEN_13; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_36 = reg_addressed ? _GEN_28 : _GEN_14; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_37 = reg_addressed ? _GEN_29 : _GEN_15; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_38 = reg_addressed ? _GEN_30 : _GEN_16; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_39 = reg_addressed ? _GEN_31 : _GEN_17; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_40 = reg_addressed ? _GEN_32 : _GEN_18; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_41 = reg_addressed ? _GEN_33 : _GEN_19; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire  _GEN_42 = reg_addressed ? _GEN_34 : _GEN_20; // @[src/main/scala/fpga/Fetch.scala 216:26]
  wire [63:0] idata = io_ft_imem_valid ? io_ft_imem_inst : io_ft_icache_idata; // @[src/main/scala/fpga/Fetch.scala 238:20]
  wire  _discard_T_1 = reg_addressed & reg_discard_enq == discard_deq; // @[src/main/scala/fpga/Fetch.scala 245:26]
  wire  _GEN_51 = 3'h1 == discard_deq ? discard_buf_1 : discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_52 = 3'h2 == discard_deq ? discard_buf_2 : _GEN_51; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_53 = 3'h3 == discard_deq ? discard_buf_3 : _GEN_52; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_54 = 3'h4 == discard_deq ? discard_buf_4 : _GEN_53; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_55 = 3'h5 == discard_deq ? discard_buf_5 : _GEN_54; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_56 = 3'h6 == discard_deq ? discard_buf_6 : _GEN_55; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  _GEN_57 = 3'h7 == discard_deq ? discard_buf_7 : _GEN_56; // @[src/main/scala/fpga/Fetch.scala 244:{22,22}]
  wire  discard = _discard_T_1 ? _discard_buf_T : _GEN_57; // @[src/main/scala/fpga/Fetch.scala 244:22]
  wire  _T_54 = ~discard; // @[src/main/scala/fpga/Fetch.scala 251:29]
  wire  _T_55 = io_pr_bp1_en & ~discard; // @[src/main/scala/fpga/Fetch.scala 251:26]
  wire  _T_57 = io_ft_imem_valid | io_ft_icache_idata_valid; // @[src/main/scala/fpga/Fetch.scala 259:28]
  wire [2:0] _discard_deq_T_1 = discard_deq + 3'h1; // @[src/main/scala/fpga/Fetch.scala 260:34]
  wire [2:0] _fetch_ptr_T_1 = fetch_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 262:32]
  wire [31:0] _T_62 = {fetch_buf_iaddr_MPORT_12_data,1'h0}; // @[src/main/scala/fpga/Fetch.scala 266:21]
  wire  _GEN_90 = (io_ft_imem_valid | io_ft_icache_idata_valid) & _T_54; // @[src/main/scala/fpga/Fetch.scala 107:22 259:57]
  reg [1:0] reg_i0; // @[src/main/scala/fpga/Fetch.scala 277:25]
  reg  reg_reset_i0; // @[src/main/scala/fpga/Fetch.scala 278:31]
  wire [2:0] count_1 = fetch_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 280:27]
  wire [1:0] sat_count = count_1 < 3'h2 ? count_1[1:0] : 2'h2; // @[src/main/scala/fpga/Fetch.scala 281:24]
  wire [2:0] _end_of_iblocks_T_1 = {{1'd0}, read_ptr[1:0]}; // @[src/main/scala/fpga/Fetch.scala 283:86]
  wire [2:0] _end_of_iblock_T = {1'h1,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data}; // @[src/main/scala/fpga/Fetch.scala 285:51]
  wire [2:0] _end_of_iblock_T_1 = {1'h0,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 285:82]
  wire [2:0] end_of_iblock = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? _end_of_iblock_T : _end_of_iblock_T_1; // @[src/main/scala/fpga/Fetch.scala 285:28]
  wire [111:0] _idatas_T_1 = {fetch_buf_idata_idata1_MPORT_data[47:0],fetch_buf_idata_idata0_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 289:61]
  wire [15:0] idatas_0 = _idatas_T_1[15:0]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_1 = _idatas_T_1[31:16]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_2 = _idatas_T_1[47:32]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_3 = _idatas_T_1[63:48]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_4 = _idatas_T_1[79:64]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_5 = _idatas_T_1[95:80]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_6 = _idatas_T_1[111:96]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire  is_halfs_0 = idatas_0[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire  is_halfs_1 = idatas_1[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire  is_halfs_2 = idatas_2[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire  is_halfs_3 = idatas_3[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire  is_halfs_4 = idatas_4[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire  is_halfs_5 = idatas_5[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 290:62]
  wire [3:0] _redir_oh_T = 4'h1 << fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data; // @[src/main/scala/chisel3/util/OneHot.scala 58:35]
  wire [3:0] _redir_oh_T_1 = 4'h1 << fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/chisel3/util/OneHot.scala 58:35]
  wire [3:0] _redir_oh_T_2 = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? 4'h0 : _redir_oh_T_1; // @[src/main/scala/fpga/Fetch.scala 295:54]
  wire [7:0] redir_oh = {_redir_oh_T,_redir_oh_T_2}; // @[src/main/scala/fpga/Fetch.scala 295:48]
  wire [2:0] i0 = {1'h0,reg_i0}; // @[src/main/scala/fpga/Fetch.scala 297:23]
  wire [2:0] i1 = i0 + 3'h1; // @[src/main/scala/fpga/Fetch.scala 298:17]
  wire [2:0] i2 = i0 + 3'h2; // @[src/main/scala/fpga/Fetch.scala 299:17]
  wire [2:0] i3 = i0 + 3'h3; // @[src/main/scala/fpga/Fetch.scala 300:17]
  wire  _GEN_93 = 3'h1 == i0 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 302:{25,25}]
  wire  _GEN_94 = 3'h2 == i0 ? is_halfs_2 : _GEN_93; // @[src/main/scala/fpga/Fetch.scala 302:{25,25}]
  wire  _GEN_95 = 3'h3 == i0 ? is_halfs_3 : _GEN_94; // @[src/main/scala/fpga/Fetch.scala 302:{25,25}]
  wire  _GEN_96 = 3'h4 == i0 ? is_halfs_4 : _GEN_95; // @[src/main/scala/fpga/Fetch.scala 302:{25,25}]
  wire  _GEN_97 = 3'h5 == i0 ? is_halfs_5 : _GEN_96; // @[src/main/scala/fpga/Fetch.scala 302:{25,25}]
  wire [2:0] inst1_past = _GEN_97 ? i1 : i2; // @[src/main/scala/fpga/Fetch.scala 302:25]
  wire [2:0] inst1_end = _GEN_97 ? i0 : i1; // @[src/main/scala/fpga/Fetch.scala 303:25]
  wire  _GEN_99 = 3'h1 == i1 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_100 = 3'h2 == i1 ? is_halfs_2 : _GEN_99; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_101 = 3'h3 == i1 ? is_halfs_3 : _GEN_100; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_102 = 3'h4 == i1 ? is_halfs_4 : _GEN_101; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_103 = 3'h5 == i1 ? is_halfs_5 : _GEN_102; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_105 = 3'h1 == i2 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_106 = 3'h2 == i2 ? is_halfs_2 : _GEN_105; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_107 = 3'h3 == i2 ? is_halfs_3 : _GEN_106; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_108 = 3'h4 == i2 ? is_halfs_4 : _GEN_107; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire  _GEN_109 = 3'h5 == i2 ? is_halfs_5 : _GEN_108; // @[src/main/scala/fpga/Fetch.scala 304:{25,25}]
  wire [1:0] _inst2_past_T = _GEN_97 ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Fetch.scala 305:38]
  wire [2:0] _GEN_181 = {{1'd0}, _inst2_past_T}; // @[src/main/scala/fpga/Fetch.scala 305:33]
  wire [2:0] inst2_past = inst1_past + _GEN_181; // @[src/main/scala/fpga/Fetch.scala 305:33]
  wire [2:0] _inst2_end_T = _GEN_103 ? i1 : i2; // @[src/main/scala/fpga/Fetch.scala 307:10]
  wire [2:0] _inst2_end_T_1 = _GEN_109 ? i2 : i3; // @[src/main/scala/fpga/Fetch.scala 308:10]
  wire [2:0] inst2_end = _GEN_97 ? _inst2_end_T : _inst2_end_T_1; // @[src/main/scala/fpga/Fetch.scala 306:24]
  wire  _inst1_valid_T = inst1_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 310:41]
  wire  _inst1_valid_T_2 = io_ft_flush_en | sat_count == 2'h0; // @[src/main/scala/fpga/Fetch.scala 311:23]
  wire  _inst1_valid_T_3 = sat_count == 2'h1; // @[src/main/scala/fpga/Fetch.scala 312:18]
  wire [2:0] _GEN_182 = {{1'd0}, fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 312:59]
  wire  _inst1_valid_T_4 = inst1_end <= _GEN_182; // @[src/main/scala/fpga/Fetch.scala 312:59]
  wire  _inst1_valid_T_5 = _inst1_valid_T_3 ? _inst1_valid_T_4 : _inst1_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst1_valid = _inst1_valid_T_2 ? 1'h0 : _inst1_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _inst2_valid_T = inst2_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 314:41]
  wire  _inst2_valid_T_4 = inst2_end <= _GEN_182; // @[src/main/scala/fpga/Fetch.scala 316:59]
  wire  _inst2_valid_T_5 = _inst1_valid_T_3 ? _inst2_valid_T_4 : _inst2_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] iaddr0 = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],reg_i0}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire  inst1_bpfailed = _fix_zbp_miss_T & sat_count != 2'h0 & ~_GEN_97 & end_of_iblock == i0; // @[src/main/scala/fpga/Fetch.scala 319:78]
  wire [15:0] _GEN_111 = 3'h1 == i1 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_112 = 3'h2 == i1 ? idatas_2 : _GEN_111; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_113 = 3'h3 == i1 ? idatas_3 : _GEN_112; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_114 = 3'h4 == i1 ? idatas_4 : _GEN_113; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_115 = 3'h5 == i1 ? idatas_5 : _GEN_114; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_116 = 3'h6 == i1 ? idatas_6 : _GEN_115; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_118 = 3'h1 == i0 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_119 = 3'h2 == i0 ? idatas_2 : _GEN_118; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_120 = 3'h3 == i0 ? idatas_3 : _GEN_119; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_121 = 3'h4 == i0 ? idatas_4 : _GEN_120; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_122 = 3'h5 == i0 ? idatas_5 : _GEN_121; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [15:0] _GEN_123 = 3'h6 == i0 ? idatas_6 : _GEN_122; // @[src/main/scala/fpga/Fetch.scala 321:{42,42}]
  wire [7:0] _io_ft_inst1_redirected_T = redir_oh >> inst1_end; // @[src/main/scala/fpga/Fetch.scala 324:39]
  wire [1:0] bp_entries_0_lcnt = fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] bp_entries_1_lcnt = fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_125 = 3'h1 == inst1_end ? bp_entries_1_lcnt : bp_entries_0_lcnt; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_2_lcnt = fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_126 = 3'h2 == inst1_end ? bp_entries_2_lcnt : _GEN_125; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_3_lcnt = fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_127 = 3'h3 == inst1_end ? bp_entries_3_lcnt : _GEN_126; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_4_lcnt = fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_128 = 3'h4 == inst1_end ? bp_entries_4_lcnt : _GEN_127; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_5_lcnt = fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_129 = 3'h5 == inst1_end ? bp_entries_5_lcnt : _GEN_128; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_6_lcnt = fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] bp_entries_0_gcnt = fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] bp_entries_1_gcnt = fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_132 = 3'h1 == inst1_end ? bp_entries_1_gcnt : bp_entries_0_gcnt; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_2_gcnt = fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_133 = 3'h2 == inst1_end ? bp_entries_2_gcnt : _GEN_132; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_3_gcnt = fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_134 = 3'h3 == inst1_end ? bp_entries_3_gcnt : _GEN_133; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_4_gcnt = fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_135 = 3'h4 == inst1_end ? bp_entries_4_gcnt : _GEN_134; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_5_gcnt = fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [1:0] _GEN_136 = 3'h5 == inst1_end ? bp_entries_5_gcnt : _GEN_135; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  wire [1:0] bp_entries_6_gcnt = fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 293:{29,29}]
  wire [30:0] _io_ft_inst2_addr_T_1 = inst1_past[2] ? fetch_buf_iaddr_iaddrs_MPORT_1_data : iaddr0; // @[src/main/scala/fpga/Fetch.scala 328:34]
  wire [15:0] _GEN_139 = 3'h1 == i2 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [15:0] _GEN_140 = 3'h2 == i2 ? idatas_2 : _GEN_139; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [15:0] _GEN_141 = 3'h3 == i2 ? idatas_3 : _GEN_140; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [15:0] _GEN_142 = 3'h4 == i2 ? idatas_4 : _GEN_141; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [15:0] _GEN_143 = 3'h5 == i2 ? idatas_5 : _GEN_142; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [15:0] _GEN_144 = 3'h6 == i2 ? idatas_6 : _GEN_143; // @[src/main/scala/fpga/Fetch.scala 330:{60,60}]
  wire [31:0] _io_ft_inst2_data_T = {_GEN_144,_GEN_116}; // @[src/main/scala/fpga/Fetch.scala 330:60]
  wire [15:0] _GEN_146 = 3'h1 == i3 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [15:0] _GEN_147 = 3'h2 == i3 ? idatas_2 : _GEN_146; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [15:0] _GEN_148 = 3'h3 == i3 ? idatas_3 : _GEN_147; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [15:0] _GEN_149 = 3'h4 == i3 ? idatas_4 : _GEN_148; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [15:0] _GEN_150 = 3'h5 == i3 ? idatas_5 : _GEN_149; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [15:0] _GEN_151 = 3'h6 == i3 ? idatas_6 : _GEN_150; // @[src/main/scala/fpga/Fetch.scala 330:{86,86}]
  wire [31:0] _io_ft_inst2_data_T_1 = {_GEN_151,_GEN_144}; // @[src/main/scala/fpga/Fetch.scala 330:86]
  wire [7:0] _io_ft_inst2_redirected_T = redir_oh >> inst2_end; // @[src/main/scala/fpga/Fetch.scala 333:39]
  wire [1:0] _GEN_153 = 3'h1 == inst2_end ? bp_entries_1_lcnt : bp_entries_0_lcnt; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_154 = 3'h2 == inst2_end ? bp_entries_2_lcnt : _GEN_153; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_155 = 3'h3 == inst2_end ? bp_entries_3_lcnt : _GEN_154; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_156 = 3'h4 == inst2_end ? bp_entries_4_lcnt : _GEN_155; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_157 = 3'h5 == inst2_end ? bp_entries_5_lcnt : _GEN_156; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_160 = 3'h1 == inst2_end ? bp_entries_1_gcnt : bp_entries_0_gcnt; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_161 = 3'h2 == inst2_end ? bp_entries_2_gcnt : _GEN_160; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_162 = 3'h3 == inst2_end ? bp_entries_3_gcnt : _GEN_161; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_163 = 3'h4 == inst2_end ? bp_entries_4_gcnt : _GEN_162; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire [1:0] _GEN_164 = 3'h5 == inst2_end ? bp_entries_5_gcnt : _GEN_163; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  wire  _inst_past_T = io_ft_inst2_ready & inst2_valid; // @[src/main/scala/fpga/Fetch.scala 338:49]
  wire  _inst_past_T_2 = (io_ft_inst1_ready | io_ft_inst2_ready) & inst1_valid; // @[src/main/scala/fpga/Fetch.scala 339:49]
  wire [2:0] _inst_past_T_3 = _inst_past_T_2 ? inst1_past : i0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] inst_past = _inst_past_T ? inst2_past : _inst_past_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _next_read_ptr_T_2 = inst_past > end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 342:66]
  wire  _next_read_ptr_T_3 = inst1_valid & end_of_iblock[2] & inst_past > end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 342:53]
  wire  _next_read_ptr_T_7 = inst1_valid & (inst_past[2] | _next_read_ptr_T_2); // @[src/main/scala/fpga/Fetch.scala 343:20]
  wire [1:0] _next_read_ptr_T_9 = _next_read_ptr_T_3 ? 2'h2 : {{1'd0}, _next_read_ptr_T_7}; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _GEN_184 = {{1'd0}, _next_read_ptr_T_9}; // @[src/main/scala/fpga/Fetch.scala 341:34]
  wire [2:0] next_read_ptr = read_ptr + _GEN_184; // @[src/main/scala/fpga/Fetch.scala 341:34]
  wire  _T_66 = inst1_valid & _next_read_ptr_T_2; // @[src/main/scala/fpga/Fetch.scala 346:23]
  wire [1:0] ptr_1 = next_read_ptr[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _reg_i0_T_1 = _io_ft_imem_en_T_1 & ptr_1 == ptr; // @[src/main/scala/fpga/Fetch.scala 349:23]
  wire  _T_68 = ~inst1_valid & reg_reset_i0; // @[src/main/scala/fpga/Fetch.scala 354:30]
  wire [2:0] _GEN_185 = {{1'd0}, ptr}; // @[src/main/scala/fpga/Fetch.scala 356:36]
  wire  _reg_i0_T_5 = _io_ft_imem_en_T_1 & read_ptr == _GEN_185; // @[src/main/scala/fpga/Fetch.scala 356:23]
  wire [1:0] _reg_i0_T_8 = _reg_i0_T_5 ? forward_i0 : fetch_buf_iaddr_reg_i0_MPORT_1_data[1:0]; // @[src/main/scala/fpga/Fetch.scala 355:20]
  wire  _GEN_170 = ~inst1_valid & reg_reset_i0 | reg_reset_i0; // @[src/main/scala/fpga/Fetch.scala 354:47 360:20 278:31]
  wire  _GEN_175 = inst1_valid & _next_read_ptr_T_2 | _GEN_170; // @[src/main/scala/fpga/Fetch.scala 346:53 353:20]
  assign fetch_buf_iaddr_MPORT_3_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_3_addr = 2'h0;
  assign fetch_buf_iaddr_MPORT_3_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_MPORT_4_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_4_addr = 2'h1;
  assign fetch_buf_iaddr_MPORT_4_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_MPORT_5_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_5_addr = 2'h2;
  assign fetch_buf_iaddr_MPORT_5_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_MPORT_6_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_6_addr = 2'h3;
  assign fetch_buf_iaddr_MPORT_6_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_iaddr_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_12_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_iblock_cont_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_iaddrs_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_idata0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_idata1_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_bpe0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_bpe1_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_fp_ptr_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_iaddr_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_iaddr_reg_i0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_iaddr_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_reg_i0_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iaddr_MPORT_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_en = io_ft_flush_en;
  assign fetch_buf_iaddr_MPORT_1_data = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_1;
  assign fetch_buf_iaddr_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_1_mask = 1'h1;
  assign fetch_buf_iaddr_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_iaddr_MPORT_2_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_2_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_iaddr_MPORT_7_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_7_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iaddr_MPORT_8_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_8_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_iaddr_MPORT_9_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_9_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_9_en = reg_addressed;
  assign fetch_buf_iaddr_MPORT_10_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_10_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_10_en = reg_addressed;
  assign fetch_buf_iaddr_MPORT_11_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_11_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_11_en = reg_addressed;
  assign fetch_buf_idata_MPORT_3_en = 1'h1;
  assign fetch_buf_idata_MPORT_3_addr = 2'h0;
  assign fetch_buf_idata_MPORT_3_data = fetch_buf_idata[fetch_buf_idata_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_MPORT_4_en = 1'h1;
  assign fetch_buf_idata_MPORT_4_addr = 2'h1;
  assign fetch_buf_idata_MPORT_4_data = fetch_buf_idata[fetch_buf_idata_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_MPORT_5_en = 1'h1;
  assign fetch_buf_idata_MPORT_5_addr = 2'h2;
  assign fetch_buf_idata_MPORT_5_data = fetch_buf_idata[fetch_buf_idata_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_MPORT_6_en = 1'h1;
  assign fetch_buf_idata_MPORT_6_addr = 2'h3;
  assign fetch_buf_idata_MPORT_6_data = fetch_buf_idata[fetch_buf_idata_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_idata_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_12_data = fetch_buf_idata[fetch_buf_idata_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_end_of_iblocks_MPORT_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_idata_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_iblock_cont_MPORT_data = fetch_buf_idata[fetch_buf_idata_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_iaddrs_MPORT_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_idata0_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_idata0_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_idata1_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_idata1_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_idata_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_bpe0_MPORT_data = fetch_buf_idata[fetch_buf_idata_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_idata_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_bpe1_MPORT_data = fetch_buf_idata[fetch_buf_idata_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_idata_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_fp_ptr_MPORT_data = fetch_buf_idata[fetch_buf_idata_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_idata_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_idata_reg_i0_MPORT_data = fetch_buf_idata[fetch_buf_idata_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_idata_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_idata_reg_i0_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_idata_MPORT_data = 64'h0;
  assign fetch_buf_idata_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_mask = 1'h0;
  assign fetch_buf_idata_MPORT_en = io_ft_flush_en;
  assign fetch_buf_idata_MPORT_1_data = 64'h0;
  assign fetch_buf_idata_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_idata_MPORT_1_mask = 1'h0;
  assign fetch_buf_idata_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_idata_MPORT_2_data = 64'h0;
  assign fetch_buf_idata_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_idata_MPORT_2_mask = 1'h0;
  assign fetch_buf_idata_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_idata_MPORT_7_data = io_ft_imem_valid ? io_ft_imem_inst : io_ft_icache_idata;
  assign fetch_buf_idata_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_7_mask = 1'h1;
  assign fetch_buf_idata_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_idata_MPORT_8_data = 64'h0;
  assign fetch_buf_idata_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_8_mask = 1'h0;
  assign fetch_buf_idata_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_idata_MPORT_9_data = 64'h0;
  assign fetch_buf_idata_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_9_mask = 1'h0;
  assign fetch_buf_idata_MPORT_9_en = reg_addressed;
  assign fetch_buf_idata_MPORT_10_data = 64'h0;
  assign fetch_buf_idata_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_10_mask = 1'h0;
  assign fetch_buf_idata_MPORT_10_en = reg_addressed;
  assign fetch_buf_idata_MPORT_11_data = 64'h0;
  assign fetch_buf_idata_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_idata_MPORT_11_mask = 1'h0;
  assign fetch_buf_idata_MPORT_11_en = reg_addressed;
  assign fetch_buf_iblock_cont_MPORT_3_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_3_addr = 2'h0;
  assign fetch_buf_iblock_cont_MPORT_3_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_MPORT_4_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_4_addr = 2'h1;
  assign fetch_buf_iblock_cont_MPORT_4_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_MPORT_5_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_5_addr = 2'h2;
  assign fetch_buf_iblock_cont_MPORT_5_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_MPORT_6_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_6_addr = 2'h3;
  assign fetch_buf_iblock_cont_MPORT_6_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_iblock_cont_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_12_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_iaddrs_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_idata0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_bpe0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_bpe1_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_iblock_cont_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_iblock_cont_reg_i0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_iblock_cont_MPORT_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_mask = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_en = io_ft_flush_en;
  assign fetch_buf_iblock_cont_MPORT_1_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_1_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_iblock_cont_MPORT_2_data = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_2_mask = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_iblock_cont_MPORT_7_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_7_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_iblock_cont_MPORT_8_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_8_mask = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_iblock_cont_MPORT_9_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_9_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_9_en = reg_addressed;
  assign fetch_buf_iblock_cont_MPORT_10_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_10_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_10_en = reg_addressed;
  assign fetch_buf_iblock_cont_MPORT_11_data = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iblock_cont_MPORT_11_mask = 1'h0;
  assign fetch_buf_iblock_cont_MPORT_11_en = reg_addressed;
  assign fetch_buf_end_of_iblock_MPORT_3_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_3_addr = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_3_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_MPORT_4_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_4_addr = 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_4_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_MPORT_5_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_5_addr = 2'h2;
  assign fetch_buf_end_of_iblock_MPORT_5_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_MPORT_6_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_6_addr = 2'h3;
  assign fetch_buf_end_of_iblock_MPORT_6_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_end_of_iblock_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_12_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_idata0_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_idata0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_idata1_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_bpe0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_bpe1_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_end_of_iblock_MPORT_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_en = io_ft_flush_en;
  assign fetch_buf_end_of_iblock_MPORT_1_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_1_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_end_of_iblock_MPORT_2_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_2_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_end_of_iblock_MPORT_7_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_7_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_end_of_iblock_MPORT_8_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_8_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_end_of_iblock_MPORT_9_data = io_pr_bp1_en ? io_pr_bp1_pos : 2'h3;
  assign fetch_buf_end_of_iblock_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_9_mask = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_9_en = reg_addressed;
  assign fetch_buf_end_of_iblock_MPORT_10_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_10_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_10_en = reg_addressed;
  assign fetch_buf_end_of_iblock_MPORT_11_data = 2'h0;
  assign fetch_buf_end_of_iblock_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_11_mask = 1'h0;
  assign fetch_buf_end_of_iblock_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_3_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_10_data = io_pr_bp_entries_0_lcnt;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_3_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_10_data = io_pr_bp_entries_0_gcnt;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_3_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_10_data = io_pr_bp_entries_1_lcnt;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_3_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_10_data = io_pr_bp_entries_1_gcnt;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_3_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_10_data = io_pr_bp_entries_2_lcnt;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_3_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_10_data = io_pr_bp_entries_2_gcnt;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_3_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_10_data = io_pr_bp_entries_3_lcnt;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_3_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_3_addr = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_3_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_en = io_ft_flush_en;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_1_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_MPORT_1_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_2_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_MPORT_2_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_7_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_MPORT_7_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_8_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_8_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_9_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_9_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_9_en = reg_addressed;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_10_data = io_pr_bp_entries_3_gcnt;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_10_mask = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_10_en = reg_addressed;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_11_data = 2'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_11_mask = 1'h0;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_11_en = reg_addressed;
  assign fetch_buf_fp_ptr_MPORT_3_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_3_addr = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_3_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_MPORT_4_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_4_addr = 2'h1;
  assign fetch_buf_fp_ptr_MPORT_4_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_MPORT_5_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_5_addr = 2'h2;
  assign fetch_buf_fp_ptr_MPORT_5_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_MPORT_6_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_6_addr = 2'h3;
  assign fetch_buf_fp_ptr_MPORT_6_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_MPORT_12_en = _T_57 & _T_54;
  assign fetch_buf_fp_ptr_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_12_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_fp_ptr_iaddrs_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_idata0_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_idata0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_idata1_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_idata1_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_bpe0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_bpe1_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_fp_ptr_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_fp_ptr_reg_i0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_en = _T_66 ? 1'h0 : _T_68;
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 107:22]
  assign fetch_buf_fp_ptr_MPORT_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_fp_ptr_MPORT_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_en = io_ft_flush_en;
  assign fetch_buf_fp_ptr_MPORT_1_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_1_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_1_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_1_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_fp_ptr_MPORT_2_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_2_addr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_2_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_2_en = _io_ft_imem_en_T | io_ft_flush_en;
  assign fetch_buf_fp_ptr_MPORT_7_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_7_addr = fetch_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_7_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_7_en = addressing_ptr != fetch_ptr;
  assign fetch_buf_fp_ptr_MPORT_8_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_8_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_fp_ptr_MPORT_8_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_8_en = reg_addressed & _T_55;
  assign fetch_buf_fp_ptr_MPORT_9_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_9_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_fp_ptr_MPORT_9_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_9_en = reg_addressed;
  assign fetch_buf_fp_ptr_MPORT_10_data = 2'h0;
  assign fetch_buf_fp_ptr_MPORT_10_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_fp_ptr_MPORT_10_mask = 1'h0;
  assign fetch_buf_fp_ptr_MPORT_10_en = reg_addressed;
  assign fetch_buf_fp_ptr_MPORT_11_data = io_pr_fp_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_11_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_fp_ptr_MPORT_11_mask = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_11_en = reg_addressed;
  assign io_ft_inst1_valid = inst1_valid | inst1_bpfailed; // @[src/main/scala/fpga/Fetch.scala 327:43]
  assign io_ft_inst1_addr = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],reg_i0}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_ft_inst1_data = {_GEN_116,_GEN_123}; // @[src/main/scala/fpga/Fetch.scala 321:42]
  assign io_ft_inst1_bpfailed = _fix_zbp_miss_T & sat_count != 2'h0 & ~_GEN_97 & end_of_iblock == i0; // @[src/main/scala/fpga/Fetch.scala 319:78]
  assign io_ft_inst1_redirected = _io_ft_inst1_redirected_T[0]; // @[src/main/scala/fpga/Fetch.scala 324:39]
  assign io_ft_inst1_bp_entry_lcnt = 3'h6 == inst1_end ? bp_entries_6_lcnt : _GEN_129; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  assign io_ft_inst1_bp_entry_gcnt = 3'h6 == inst1_end ? bp_entries_6_gcnt : _GEN_136; // @[src/main/scala/fpga/Fetch.scala 325:{28,28}]
  assign io_ft_inst1_fp_ptr = fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 326:28]
  assign io_ft_inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_ft_inst2_addr = {_io_ft_inst2_addr_T_1[30:2],inst1_past[1:0]}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_ft_inst2_data = _GEN_97 ? _io_ft_inst2_data_T : _io_ft_inst2_data_T_1; // @[src/main/scala/fpga/Fetch.scala 330:34]
  assign io_ft_inst2_redirected = _io_ft_inst2_redirected_T[0]; // @[src/main/scala/fpga/Fetch.scala 333:39]
  assign io_ft_inst2_bp_entry_lcnt = 3'h6 == inst2_end ? bp_entries_6_lcnt : _GEN_157; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  assign io_ft_inst2_bp_entry_gcnt = 3'h6 == inst2_end ? bp_entries_6_gcnt : _GEN_164; // @[src/main/scala/fpga/Fetch.scala 334:{28,28}]
  assign io_ft_inst2_fp_ptr = fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 335:28]
  assign io_ft_imem_en = (has_space & redirect_ready | io_ft_flush_en) & ~wait_for_dram & _T_2; // @[src/main/scala/fpga/Fetch.scala 173:97]
  assign io_ft_imem_addr = {_reg_next_iaddr_T_1,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign io_ft_icache_addr_en = _io_ft_imem_en_T_1 & is_dram; // @[src/main/scala/fpga/Fetch.scala 175:79]
  assign io_ft_icache_addr = {_reg_next_iaddr_T_1,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign io_pr_iaddr_en = ~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready ? 1'h0
     : 1'h1; // @[src/main/scala/fpga/Fetch.scala 179:122 181:24 184:23]
  assign io_pr_iaddr = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_flush_en = io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 176:26]
  assign io_pr_redirect_en = io_ft_flush_en | reg_fix_zbp_miss | io_pr_bp0_en; // @[src/main/scala/fpga/Fetch.scala 177:64]
  always @(posedge clock) begin
    if (fetch_buf_iaddr_MPORT_en & fetch_buf_iaddr_MPORT_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_addr] <= fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_1_en & fetch_buf_iaddr_MPORT_1_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_1_addr] <= fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_2_en & fetch_buf_iaddr_MPORT_2_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_2_addr] <= fetch_buf_iaddr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_7_en & fetch_buf_iaddr_MPORT_7_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_7_addr] <= fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_8_en & fetch_buf_iaddr_MPORT_8_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_8_addr] <= fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_9_en & fetch_buf_iaddr_MPORT_9_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_9_addr] <= fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_10_en & fetch_buf_iaddr_MPORT_10_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_10_addr] <= fetch_buf_iaddr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iaddr_MPORT_11_en & fetch_buf_iaddr_MPORT_11_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_11_addr] <= fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_en & fetch_buf_idata_MPORT_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_addr] <= fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_1_en & fetch_buf_idata_MPORT_1_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_1_addr] <= fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_2_en & fetch_buf_idata_MPORT_2_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_2_addr] <= fetch_buf_idata_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_7_en & fetch_buf_idata_MPORT_7_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_7_addr] <= fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_8_en & fetch_buf_idata_MPORT_8_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_8_addr] <= fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_9_en & fetch_buf_idata_MPORT_9_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_9_addr] <= fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_10_en & fetch_buf_idata_MPORT_10_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_10_addr] <= fetch_buf_idata_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_idata_MPORT_11_en & fetch_buf_idata_MPORT_11_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_11_addr] <= fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_en & fetch_buf_iblock_cont_MPORT_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_addr] <= fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_1_en & fetch_buf_iblock_cont_MPORT_1_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_1_addr] <= fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_2_en & fetch_buf_iblock_cont_MPORT_2_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_2_addr] <= fetch_buf_iblock_cont_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_7_en & fetch_buf_iblock_cont_MPORT_7_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_7_addr] <= fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_8_en & fetch_buf_iblock_cont_MPORT_8_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_8_addr] <= fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_9_en & fetch_buf_iblock_cont_MPORT_9_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_9_addr] <= fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_10_en & fetch_buf_iblock_cont_MPORT_10_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_10_addr] <= fetch_buf_iblock_cont_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_iblock_cont_MPORT_11_en & fetch_buf_iblock_cont_MPORT_11_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_11_addr] <= fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_en & fetch_buf_end_of_iblock_MPORT_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_addr] <= fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_1_en & fetch_buf_end_of_iblock_MPORT_1_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_1_addr] <= fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_2_en & fetch_buf_end_of_iblock_MPORT_2_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_2_addr] <= fetch_buf_end_of_iblock_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_7_en & fetch_buf_end_of_iblock_MPORT_7_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_7_addr] <= fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_8_en & fetch_buf_end_of_iblock_MPORT_8_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_8_addr] <= fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_9_en & fetch_buf_end_of_iblock_MPORT_9_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_9_addr] <= fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_10_en & fetch_buf_end_of_iblock_MPORT_10_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_10_addr] <= fetch_buf_end_of_iblock_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_11_en & fetch_buf_end_of_iblock_MPORT_11_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_11_addr] <= fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_en & fetch_buf_bp_entries_0_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_1_en & fetch_buf_bp_entries_0_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_2_en & fetch_buf_bp_entries_0_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_7_en & fetch_buf_bp_entries_0_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_8_en & fetch_buf_bp_entries_0_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_9_en & fetch_buf_bp_entries_0_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_10_en & fetch_buf_bp_entries_0_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_0_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_11_en & fetch_buf_bp_entries_0_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_0_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_en & fetch_buf_bp_entries_0_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_1_en & fetch_buf_bp_entries_0_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_2_en & fetch_buf_bp_entries_0_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_7_en & fetch_buf_bp_entries_0_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_8_en & fetch_buf_bp_entries_0_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_9_en & fetch_buf_bp_entries_0_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_10_en & fetch_buf_bp_entries_0_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_0_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_11_en & fetch_buf_bp_entries_0_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_0_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_en & fetch_buf_bp_entries_1_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_1_en & fetch_buf_bp_entries_1_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_2_en & fetch_buf_bp_entries_1_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_7_en & fetch_buf_bp_entries_1_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_8_en & fetch_buf_bp_entries_1_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_9_en & fetch_buf_bp_entries_1_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_10_en & fetch_buf_bp_entries_1_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_1_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_11_en & fetch_buf_bp_entries_1_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_1_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_en & fetch_buf_bp_entries_1_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_1_en & fetch_buf_bp_entries_1_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_2_en & fetch_buf_bp_entries_1_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_7_en & fetch_buf_bp_entries_1_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_8_en & fetch_buf_bp_entries_1_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_9_en & fetch_buf_bp_entries_1_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_10_en & fetch_buf_bp_entries_1_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_1_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_11_en & fetch_buf_bp_entries_1_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_1_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_en & fetch_buf_bp_entries_2_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_1_en & fetch_buf_bp_entries_2_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_2_en & fetch_buf_bp_entries_2_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_7_en & fetch_buf_bp_entries_2_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_8_en & fetch_buf_bp_entries_2_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_9_en & fetch_buf_bp_entries_2_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_10_en & fetch_buf_bp_entries_2_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_2_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_11_en & fetch_buf_bp_entries_2_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_2_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_en & fetch_buf_bp_entries_2_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_1_en & fetch_buf_bp_entries_2_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_2_en & fetch_buf_bp_entries_2_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_7_en & fetch_buf_bp_entries_2_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_8_en & fetch_buf_bp_entries_2_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_9_en & fetch_buf_bp_entries_2_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_10_en & fetch_buf_bp_entries_2_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_2_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_11_en & fetch_buf_bp_entries_2_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_2_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_en & fetch_buf_bp_entries_3_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_1_en & fetch_buf_bp_entries_3_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_2_en & fetch_buf_bp_entries_3_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_7_en & fetch_buf_bp_entries_3_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_8_en & fetch_buf_bp_entries_3_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_9_en & fetch_buf_bp_entries_3_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_10_en & fetch_buf_bp_entries_3_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_3_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_11_en & fetch_buf_bp_entries_3_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_3_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_en & fetch_buf_bp_entries_3_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_1_en & fetch_buf_bp_entries_3_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_2_en & fetch_buf_bp_entries_3_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_7_en & fetch_buf_bp_entries_3_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_8_en & fetch_buf_bp_entries_3_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_9_en & fetch_buf_bp_entries_3_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_10_en & fetch_buf_bp_entries_3_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_3_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_11_en & fetch_buf_bp_entries_3_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_3_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_en & fetch_buf_fp_ptr_MPORT_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_addr] <= fetch_buf_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_1_en & fetch_buf_fp_ptr_MPORT_1_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_1_addr] <= fetch_buf_fp_ptr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_2_en & fetch_buf_fp_ptr_MPORT_2_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_2_addr] <= fetch_buf_fp_ptr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_7_en & fetch_buf_fp_ptr_MPORT_7_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_7_addr] <= fetch_buf_fp_ptr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_8_en & fetch_buf_fp_ptr_MPORT_8_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_8_addr] <= fetch_buf_fp_ptr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_9_en & fetch_buf_fp_ptr_MPORT_9_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_9_addr] <= fetch_buf_fp_ptr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_10_en & fetch_buf_fp_ptr_MPORT_10_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_10_addr] <= fetch_buf_fp_ptr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (fetch_buf_fp_ptr_MPORT_11_en & fetch_buf_fp_ptr_MPORT_11_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_11_addr] <= fetch_buf_fp_ptr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 107:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 108:31]
      addressing_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 108:31]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 179:122]
      if (invalidate & _fix_zbp_miss_T) begin // @[src/main/scala/fpga/Fetch.scala 164:42]
        addressing_ptr <= _addressing_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 165:22]
      end
    end else if (!(_T_1)) begin // @[src/main/scala/fpga/Fetch.scala 187:44]
      addressing_ptr <= _addressing_ptr_T_3; // @[src/main/scala/fpga/Fetch.scala 190:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 109:31]
      fetch_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 109:31]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 271:27]
      fetch_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 272:17]
    end else if (io_ft_imem_valid | io_ft_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 259:57]
      if (_T_54) begin // @[src/main/scala/fpga/Fetch.scala 261:23]
        fetch_ptr <= _fetch_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 262:19]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 110:31]
      read_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 110:31]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 365:27]
      read_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 366:16]
    end else begin
      read_ptr <= next_read_ptr; // @[src/main/scala/fpga/Fetch.scala 345:14]
    end
    discard_buf_0 <= reset | _GEN_35; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_1 <= reset | _GEN_36; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_2 <= reset | _GEN_37; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_3 <= reset | _GEN_38; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_4 <= reset | _GEN_39; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_5 <= reset | _GEN_40; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_6 <= reset | _GEN_41; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    discard_buf_7 <= reset | _GEN_42; // @[src/main/scala/fpga/Fetch.scala 112:{28,28}]
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 113:28]
      discard_enq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 113:28]
    end else if (!(~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready)) begin // @[src/main/scala/fpga/Fetch.scala 179:122]
      discard_enq <= _discard_enq_T_1; // @[src/main/scala/fpga/Fetch.scala 186:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 114:28]
      discard_deq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 114:28]
    end else if (io_ft_imem_valid | io_ft_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 259:57]
      discard_deq <= _discard_deq_T_1; // @[src/main/scala/fpga/Fetch.scala 260:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 124:30]
      reg_addressed <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 124:30]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 179:122]
      reg_addressed <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 181:24]
    end else begin
      reg_addressed <= 1'h1; // @[src/main/scala/fpga/Fetch.scala 184:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 127:36]
      reg_next_iaddr <= 31'hfff0; // @[src/main/scala/fpga/Fetch.scala 127:36]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 179:122]
      if (io_ft_flush_en) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        reg_next_iaddr <= io_ft_flush_iaddr;
      end else if (reg_fix_zbp_miss) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        reg_next_iaddr <= reg_fix_addr;
      end else begin
        reg_next_iaddr <= _iaddr_T;
      end
    end else begin
      reg_next_iaddr <= _reg_next_iaddr_T_3; // @[src/main/scala/fpga/Fetch.scala 151:20]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 130:36]
      reg_fix_zbp_miss <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 130:36]
    end else begin
      reg_fix_zbp_miss <= fix_zbp_miss; // @[src/main/scala/fpga/Fetch.scala 155:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 131:36]
      reg_fix_addr <= 31'h0; // @[src/main/scala/fpga/Fetch.scala 131:36]
    end else if (io_pr_bp1_en) begin // @[src/main/scala/fpga/Fetch.scala 153:23]
      reg_fix_addr <= io_pr_bp1_addr;
    end else begin
      reg_fix_addr <= reg_next_iaddr;
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 132:36]
      reg_discard_enq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 132:36]
    end else begin
      reg_discard_enq <= discard_enq; // @[src/main/scala/fpga/Fetch.scala 138:21]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 133:36]
      reg_is_dram <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 133:36]
    end else begin
      reg_is_dram <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 277:25]
      reg_i0 <= 2'h0; // @[src/main/scala/fpga/Fetch.scala 277:25]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 365:27]
      reg_i0 <= io_ft_flush_iaddr[1:0]; // @[src/main/scala/fpga/Fetch.scala 367:14]
    end else if (inst1_valid & _next_read_ptr_T_2) begin // @[src/main/scala/fpga/Fetch.scala 346:53]
      if (_reg_i0_T_1) begin // @[src/main/scala/fpga/Fetch.scala 348:20]
        reg_i0 <= forward_i0;
      end else begin
        reg_i0 <= fetch_buf_iaddr_reg_i0_MPORT_data[1:0];
      end
    end else if (~inst1_valid & reg_reset_i0) begin // @[src/main/scala/fpga/Fetch.scala 354:47]
      reg_i0 <= _reg_i0_T_8; // @[src/main/scala/fpga/Fetch.scala 355:14]
    end else begin
      reg_i0 <= inst_past[1:0]; // @[src/main/scala/fpga/Fetch.scala 362:14]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 278:31]
      reg_reset_i0 <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 278:31]
    end else begin
      reg_reset_i0 <= _GEN_175;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~_T_13 & ~reset) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x addressed\n",addressing_ptr,_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 193:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"iaddr=%x\n",_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 223:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"reg_next_iaddr=%x\n",{reg_next_iaddr,1'h0}); // @[src/main/scala/fpga/Fetch.scala 224:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"io.ft.imem.addr=%x\n",io_ft_imem_addr); // @[src/main/scala/fpga/Fetch.scala 225:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"io.ft.imem.en=%d\n",io_ft_imem_en); // @[src/main/scala/fpga/Fetch.scala 226:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"fix_zbp_miss=%d\n",fix_zbp_miss); // @[src/main/scala/fpga/Fetch.scala 227:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"reg_fix_zbp_miss=%d\n",reg_fix_zbp_miss); // @[src/main/scala/fpga/Fetch.scala 228:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"addressing=%d\n",addressing_ptr[1:0]); // @[src/main/scala/fpga/Fetch.scala 229:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"fb(0).iaddr=%x\n",{fetch_buf_iaddr_MPORT_3_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 230:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"fb(1).iaddr=%x\n",{fetch_buf_iaddr_MPORT_4_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 231:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"fb(2).iaddr=%x\n",{fetch_buf_iaddr_MPORT_5_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 232:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_18) begin
          $fwrite(32'h80000002,"fb(3).iaddr=%x\n",{fetch_buf_iaddr_MPORT_6_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 233:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_90 & _T_18) begin
          $fwrite(32'h80000002,"io.ft.imem.valid=%d io.ft.icache.idata_valid=%d\n",io_ft_imem_valid,
            io_ft_icache_idata_valid); // @[src/main/scala/fpga/Fetch.scala 264:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_90 & _T_18) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x fetched\n",fetch_ptr,_T_62,idata); // @[src/main/scala/fpga/Fetch.scala 265:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (inst1_valid & _T_18) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,{fetch_buf_iaddr_iaddrs_MPORT_data,1'h0},{
            idatas_1,idatas_0},io_ft_inst1_ready); // @[src/main/scala/fpga/Fetch.scala 371:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (inst2_valid & _T_18) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,{io_ft_inst2_addr,1'h0},io_ft_inst2_data,
            io_ft_inst2_ready); // @[src/main/scala/fpga/Fetch.scala 374:13]
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
    fetch_buf_iblock_cont[initvar] = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_end_of_iblock[initvar] = _RAND_3[1:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_0_lcnt[initvar] = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_0_gcnt[initvar] = _RAND_5[1:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_1_lcnt[initvar] = _RAND_6[1:0];
  _RAND_7 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_1_gcnt[initvar] = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_2_lcnt[initvar] = _RAND_8[1:0];
  _RAND_9 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_2_gcnt[initvar] = _RAND_9[1:0];
  _RAND_10 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_3_lcnt[initvar] = _RAND_10[1:0];
  _RAND_11 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_bp_entries_3_gcnt[initvar] = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    fetch_buf_fp_ptr[initvar] = _RAND_12[1:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  addressing_ptr = _RAND_13[2:0];
  _RAND_14 = {1{`RANDOM}};
  fetch_ptr = _RAND_14[2:0];
  _RAND_15 = {1{`RANDOM}};
  read_ptr = _RAND_15[2:0];
  _RAND_16 = {1{`RANDOM}};
  discard_buf_0 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  discard_buf_1 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  discard_buf_2 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  discard_buf_3 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  discard_buf_4 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  discard_buf_5 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  discard_buf_6 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  discard_buf_7 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  discard_enq = _RAND_24[2:0];
  _RAND_25 = {1{`RANDOM}};
  discard_deq = _RAND_25[2:0];
  _RAND_26 = {1{`RANDOM}};
  reg_addressed = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  reg_next_iaddr = _RAND_27[30:0];
  _RAND_28 = {1{`RANDOM}};
  reg_fix_zbp_miss = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  reg_fix_addr = _RAND_29[30:0];
  _RAND_30 = {1{`RANDOM}};
  reg_discard_enq = _RAND_30[2:0];
  _RAND_31 = {1{`RANDOM}};
  reg_is_dram = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  reg_i0 = _RAND_32[1:0];
  _RAND_33 = {1{`RANDOM}};
  reg_reset_i0 = _RAND_33[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module FetchPredictor(
  input         clock,
  input         reset,
  input         io_pr_iaddr_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_pr_iaddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pr_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pr_redirect_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pr_redirect_ready, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pr_bp0_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp0_pos, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pr_bp0_addr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pr_bp1_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp1_pos, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pr_bp1_addr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_0_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_0_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_1_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_1_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_2_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_2_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_3_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pr_bp_entries_3_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_pr_fp_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_cr_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_cr_bp_entry_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_cr_bp_entry_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_cr_fp_entry_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_fp_entry_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [5:0]  io_cr_fp_entry_history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [2:0]  io_cr_fp_entry_ras_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_fp_hit, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_mispred, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_br_taken, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_cr_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_cr_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_cr_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_cr_next_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_re_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_re_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [5:0]  io_re_history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_re_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_re_ready, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_re_left1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ru_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_ru_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_ru_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ru_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ru_ras_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_ru_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_zbtb_lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_zbtb_lu_matches_0, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_zbtb_lu_matches_1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_zbtb_lu_matches_2, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_zbtb_lu_matches_3, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_zbtb_lu_target_0, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_zbtb_lu_target_1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_zbtb_lu_target_2, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_zbtb_lu_target_3, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_zbtb_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_zbtb_up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_zbtb_up_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_zbtb_inv_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_zbtb_inv_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_btb_lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_0_jump, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_0_br, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_btb_lu_result_0_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_0_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_btb_lu_result_0_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_1_jump, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_1_br, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_btb_lu_result_1_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_1_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_btb_lu_result_1_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_2_jump, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_2_br, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_btb_lu_result_2_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_2_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_btb_lu_result_2_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_3_jump, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_3_br, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_btb_lu_result_3_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_btb_lu_result_3_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_btb_lu_result_3_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_btb_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_btb_up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_btb_up_attr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_btb_up_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_btb_up_target, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pht__lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lu_taken_0, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lu_taken_1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lu_taken_2, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lu_taken_3, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_lcnt_0, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_lcnt_1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_lcnt_2, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_lcnt_3, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_gcnt_0, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_gcnt_1, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_gcnt_2, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lu_gcnt_3, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht__up_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [5:0]  io_pht__up_history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pht__up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pht__up_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pht__up_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__lmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [10:0] io_pht__lmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [7:0]  io_pht__lmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [12:0] io_pht__lmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__lmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__gmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input         io_pht__gmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [10:0] io_pht__gmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [7:0]  io_pht__gmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [12:0] io_pht__gmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [1:0]  io_pht__gmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht__br_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pht__br_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht__br2_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [5:0]  io_pht__br2_history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_pht__br2_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [5:0]  io_pht__history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht__res_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [5:0]  io_pht__res_history, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [30:0] io_ras_top_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [2:0]  io_ras_top_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ras_ret1_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ras_ret1_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ras_call1_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ras_call1_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_ras_call1_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ras_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ras_up_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ras_ret2_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ras_ret2_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_ras_call2_en, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [2:0]  io_ras_call2_index, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [30:0] io_ras_call2_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht_lmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht_lmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [10:0] io_pht_lmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [7:0]  io_pht_lmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [12:0] io_pht_lmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pht_lmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht_gmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output        io_pht_gmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [10:0] io_pht_gmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  input  [7:0]  io_pht_gmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [12:0] io_pht_gmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
  output [1:0]  io_pht_gmem_wdata // @[src/main/scala/fpga/FetchPredictor.scala 149:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg  reg_iaddr_en; // @[src/main/scala/fpga/FetchPredictor.scala 167:34]
  reg [30:0] reg_iaddr_index; // @[src/main/scala/fpga/FetchPredictor.scala 168:34]
  reg  reg_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 169:34]
  reg  reg_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 170:34]
  reg [1:0] reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 171:34]
  wire [1:0] ibpos = reg_iaddr_index[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _bp0_pos_T = 2'h0 >= ibpos; // @[src/main/scala/fpga/FetchPredictor.scala 181:39]
  wire  _bp0_pos_T_1 = 2'h0 >= ibpos & io_zbtb_lu_matches_0; // @[src/main/scala/fpga/FetchPredictor.scala 181:49]
  wire  _bp0_pos_T_2 = 2'h1 >= ibpos; // @[src/main/scala/fpga/FetchPredictor.scala 181:39]
  wire  _bp0_pos_T_3 = 2'h1 >= ibpos & io_zbtb_lu_matches_1; // @[src/main/scala/fpga/FetchPredictor.scala 181:49]
  wire  _bp0_pos_T_4 = 2'h2 >= ibpos; // @[src/main/scala/fpga/FetchPredictor.scala 181:39]
  wire  _bp0_pos_T_5 = 2'h2 >= ibpos & io_zbtb_lu_matches_2; // @[src/main/scala/fpga/FetchPredictor.scala 181:49]
  wire [1:0] _bp0_pos_T_6 = _bp0_pos_T_5 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _bp0_pos_T_7 = _bp0_pos_T_3 ? 2'h1 : _bp0_pos_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] bp0_pos = _bp0_pos_T_1 ? 2'h0 : _bp0_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [3:0] _bp0_en_T_8 = {io_zbtb_lu_matches_3,_bp0_pos_T_5,_bp0_pos_T_3,_bp0_pos_T_1}; // @[src/main/scala/fpga/FetchPredictor.scala 183:105]
  wire  bp0_en = reg_iaddr_en & |_bp0_en_T_8; // @[src/main/scala/fpga/FetchPredictor.scala 183:31]
  wire [30:0] _GEN_1 = 2'h1 == bp0_pos ? io_zbtb_lu_target_1 : io_zbtb_lu_target_0; // @[src/main/scala/fpga/FetchPredictor.scala 186:{20,20}]
  wire [30:0] _GEN_2 = 2'h2 == bp0_pos ? io_zbtb_lu_target_2 : _GEN_1; // @[src/main/scala/fpga/FetchPredictor.scala 186:{20,20}]
  wire  br_taken_0 = _bp0_pos_T & io_btb_lu_result_0_br & io_pht__lu_taken_0; // @[src/main/scala/fpga/FetchPredictor.scala 191:91]
  wire  br_taken_1 = _bp0_pos_T_2 & io_btb_lu_result_1_br & io_pht__lu_taken_1; // @[src/main/scala/fpga/FetchPredictor.scala 191:91]
  wire  br_taken_2 = _bp0_pos_T_4 & io_btb_lu_result_2_br & io_pht__lu_taken_2; // @[src/main/scala/fpga/FetchPredictor.scala 191:91]
  wire  br_taken_3 = io_btb_lu_result_3_br & io_pht__lu_taken_3; // @[src/main/scala/fpga/FetchPredictor.scala 191:91]
  wire  is_jump_0 = _bp0_pos_T & io_btb_lu_result_0_jump; // @[src/main/scala/fpga/FetchPredictor.scala 192:65]
  wire  is_jump_1 = _bp0_pos_T_2 & io_btb_lu_result_1_jump; // @[src/main/scala/fpga/FetchPredictor.scala 192:65]
  wire  is_jump_2 = _bp0_pos_T_4 & io_btb_lu_result_2_jump; // @[src/main/scala/fpga/FetchPredictor.scala 192:65]
  wire  is_ret_0 = _bp0_pos_T & io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 193:65]
  wire  is_ret_1 = _bp0_pos_T_2 & io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 193:65]
  wire  is_ret_2 = _bp0_pos_T_4 & io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 193:65]
  wire  _bp1_pos_T_1 = br_taken_0 | is_jump_0 | is_ret_0; // @[src/main/scala/fpga/FetchPredictor.scala 196:55]
  wire  _bp1_pos_T_3 = br_taken_1 | is_jump_1 | is_ret_1; // @[src/main/scala/fpga/FetchPredictor.scala 196:55]
  wire  _bp1_pos_T_5 = br_taken_2 | is_jump_2 | is_ret_2; // @[src/main/scala/fpga/FetchPredictor.scala 196:55]
  wire [1:0] _bp1_pos_T_6 = _bp1_pos_T_5 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _bp1_pos_T_7 = _bp1_pos_T_3 ? 2'h1 : _bp1_pos_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] bp1_pos = _bp1_pos_T_1 ? 2'h0 : _bp1_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _GEN_5 = 2'h1 == bp1_pos ? is_ret_1 : is_ret_0; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire  _GEN_6 = 2'h2 == bp1_pos ? is_ret_2 : _GEN_5; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire  _GEN_7 = 2'h3 == bp1_pos ? io_btb_lu_result_3_is_ret : _GEN_6; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire [30:0] _GEN_9 = 2'h1 == bp1_pos ? io_btb_lu_result_1_target : io_btb_lu_result_0_target; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire [30:0] _GEN_10 = 2'h2 == bp1_pos ? io_btb_lu_result_2_target : _GEN_9; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire [30:0] _GEN_11 = 2'h3 == bp1_pos ? io_btb_lu_result_3_target : _GEN_10; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  wire [3:0] _bp1_en_T = {br_taken_3,br_taken_2,br_taken_1,br_taken_0}; // @[src/main/scala/fpga/FetchPredictor.scala 199:44]
  wire [3:0] _bp1_en_T_2 = {io_btb_lu_result_3_jump,is_jump_2,is_jump_1,is_jump_0}; // @[src/main/scala/fpga/FetchPredictor.scala 199:66]
  wire [3:0] _bp1_en_T_5 = {io_btb_lu_result_3_is_ret,is_ret_2,is_ret_1,is_ret_0}; // @[src/main/scala/fpga/FetchPredictor.scala 199:87]
  wire [1:0] _GEN_13 = 2'h1 == bp1_pos ? io_btb_lu_result_1_attr : io_btb_lu_result_0_attr; // @[src/main/scala/fpga/FetchPredictor.scala 206:{21,21}]
  wire [1:0] _GEN_14 = 2'h2 == bp1_pos ? io_btb_lu_result_2_attr : _GEN_13; // @[src/main/scala/fpga/FetchPredictor.scala 206:{21,21}]
  wire [1:0] _GEN_15 = 2'h3 == bp1_pos ? io_btb_lu_result_3_attr : _GEN_14; // @[src/main/scala/fpga/FetchPredictor.scala 206:{21,21}]
  wire  _io_re_en_T = ~io_pr_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 216:23]
  wire  _io_re_en_T_1 = ~io_pr_flush_en & reg_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 216:39]
  wire [1:0] _GEN_16 = _io_re_en_T_1 ? io_re_ptr : reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 220:47 221:20 171:34]
  wire [4:0] bp0_index = reg_iaddr_index[4:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _GEN_18 = 2'h1 == bp0_pos ? br_taken_1 : br_taken_0; // @[src/main/scala/fpga/FetchPredictor.scala 227:{52,52}]
  wire  _GEN_19 = 2'h2 == bp0_pos ? br_taken_2 : _GEN_18; // @[src/main/scala/fpga/FetchPredictor.scala 227:{52,52}]
  wire  _GEN_20 = 2'h3 == bp0_pos ? br_taken_3 : _GEN_19; // @[src/main/scala/fpga/FetchPredictor.scala 227:{52,52}]
  wire  _GEN_22 = 2'h1 == bp0_pos ? is_jump_1 : is_jump_0; // @[src/main/scala/fpga/FetchPredictor.scala 227:{74,74}]
  wire  _GEN_23 = 2'h2 == bp0_pos ? is_jump_2 : _GEN_22; // @[src/main/scala/fpga/FetchPredictor.scala 227:{74,74}]
  wire  _GEN_24 = 2'h3 == bp0_pos ? io_btb_lu_result_3_jump : _GEN_23; // @[src/main/scala/fpga/FetchPredictor.scala 227:{74,74}]
  wire [4:0] _io_zbtb_inv_pc_T_2 = {bp0_index[4:2],bp0_pos}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire  _io_ras_ret1_en_T_1 = _io_re_en_T & reg_iaddr_en; // @[src/main/scala/fpga/FetchPredictor.scala 231:44]
  wire [1:0] _bcall_pos_T = is_jump_2 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _bcall_pos_T_1 = is_jump_1 ? 2'h1 : _bcall_pos_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] bcall_pos = is_jump_0 ? 2'h0 : _bcall_pos_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _io_ras_call1_ret_pc_T = bcall_pos == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 239:17]
  wire [30:0] _io_ras_call1_ret_pc_T_2 = {reg_iaddr_index[30:2],2'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  wire [30:0] _io_ras_call1_ret_pc_T_4 = _io_ras_call1_ret_pc_T_2 + 31'h4; // @[src/main/scala/fpga/FetchPredictor.scala 240:39]
  wire [1:0] _io_ras_call1_ret_pc_T_6 = bcall_pos + 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 241:51]
  wire [30:0] _io_ras_call1_ret_pc_T_9 = {reg_iaddr_index[30:2],_io_ras_call1_ret_pc_T_6}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire [5:0] pht_pc_index = reg_iaddr_index[5:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _GEN_26 = 2'h1 == bp1_pos ? br_taken_1 : br_taken_0; // @[src/main/scala/fpga/FetchPredictor.scala 246:{53,53}]
  wire  _GEN_27 = 2'h2 == bp1_pos ? br_taken_2 : _GEN_26; // @[src/main/scala/fpga/FetchPredictor.scala 246:{53,53}]
  wire  _GEN_28 = 2'h3 == bp1_pos ? br_taken_3 : _GEN_27; // @[src/main/scala/fpga/FetchPredictor.scala 246:{53,53}]
  wire [5:0] _io_pht_br_pc_T_2 = {pht_pc_index[5:2],bp1_pos}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire  _io_btb_up_en_T_1 = io_cr_bp_entry_gcnt != 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 286:12]
  wire  _io_btb_up_en_T_4 = io_cr_attr == 2'h0 & (io_cr_fp_hit | _io_btb_up_en_T_1) | io_cr_br_taken; // @[src/main/scala/fpga/FetchPredictor.scala 298:98]
  wire  _io_btb_up_en_T_5 = io_cr_attr == 2'h2; // @[src/main/scala/fpga/FetchPredictor.scala 300:19]
  wire  _io_btb_up_en_T_6 = _io_btb_up_en_T_4 | _io_btb_up_en_T_5; // @[src/main/scala/fpga/FetchPredictor.scala 299:24]
  wire  _io_btb_up_en_T_7 = io_cr_attr == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 301:19]
  wire  _io_btb_up_en_T_8 = _io_btb_up_en_T_6 | _io_btb_up_en_T_7; // @[src/main/scala/fpga/FetchPredictor.scala 300:39]
  wire  _io_btb_up_en_T_9 = _io_btb_up_en_T_8 | io_cr_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 301:39]
  wire  _updated_lcnt_lcnt_if_taken_T_4 = ~io_cr_bp_entry_lcnt[1] | io_cr_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 257:51]
  wire [1:0] updated_lcnt_lcnt_if_taken = {io_cr_bp_entry_lcnt[0],_updated_lcnt_lcnt_if_taken_T_4}; // @[src/main/scala/fpga/FetchPredictor.scala 257:38]
  wire  _updated_lcnt_lcnt_unless_taken_T_1 = ~io_cr_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 264:32]
  wire  _updated_lcnt_lcnt_unless_taken_T_4 = io_cr_bp_entry_lcnt[1] & io_cr_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 264:57]
  wire [1:0] updated_lcnt_lcnt_unless_taken = {_updated_lcnt_lcnt_unless_taken_T_1,_updated_lcnt_lcnt_unless_taken_T_4}; // @[src/main/scala/fpga/FetchPredictor.scala 264:45]
  wire  _updated_gcnt_gcnt_if_taken_T_3 = io_cr_bp_entry_gcnt[0] ^ ~io_cr_bp_entry_gcnt[1]; // @[src/main/scala/fpga/FetchPredictor.scala 274:36]
  wire [1:0] updated_gcnt_gcnt_if_taken = {_updated_gcnt_gcnt_if_taken_T_3,_updated_gcnt_gcnt_if_taken_T_3}; // @[src/main/scala/fpga/FetchPredictor.scala 274:48]
  wire  _updated_gcnt_gcnt_unless_taken_T_1 = ~io_cr_bp_entry_gcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 280:32]
  wire [1:0] updated_gcnt_gcnt_unless_taken = {_updated_gcnt_gcnt_unless_taken_T_1,1'h0}; // @[src/main/scala/fpga/FetchPredictor.scala 280:42]
  wire  _io_pht_br2_en_T_1 = ~io_cr_fp_hit; // @[src/main/scala/fpga/FetchPredictor.scala 323:58]
  wire  _io_ras_call2_en_T_4 = _io_pht_br2_en_T_1 | io_cr_fp_entry_attr != 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 342:45]
  assign io_pr_redirect_ready = io_re_ready & (~io_re_left1 | ~reg_redirect_en); // @[src/main/scala/fpga/FetchPredictor.scala 174:41]
  assign io_pr_bp0_en = reg_iaddr_en & |_bp0_en_T_8; // @[src/main/scala/fpga/FetchPredictor.scala 183:31]
  assign io_pr_bp0_pos = _bp0_pos_T_1 ? 2'h0 : _bp0_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_bp0_addr = 2'h3 == bp0_pos ? io_zbtb_lu_target_3 : _GEN_2; // @[src/main/scala/fpga/FetchPredictor.scala 186:{20,20}]
  assign io_pr_bp1_en = reg_iaddr_en & (|_bp1_en_T | |_bp1_en_T_2 | |_bp1_en_T_5); // @[src/main/scala/fpga/FetchPredictor.scala 199:31]
  assign io_pr_bp1_pos = _bp1_pos_T_1 ? 2'h0 : _bp1_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_bp1_addr = _GEN_7 ? io_ras_top_ret_pc : _GEN_11; // @[src/main/scala/fpga/FetchPredictor.scala 198:25]
  assign io_pr_bp_entries_0_lcnt = io_pht__lu_lcnt_0; // @[src/main/scala/fpga/FetchPredictor.scala 212:32]
  assign io_pr_bp_entries_0_gcnt = io_btb_lu_result_0_attr == 2'h1 ? io_pht__lu_gcnt_0 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 213:38]
  assign io_pr_bp_entries_1_lcnt = io_pht__lu_lcnt_1; // @[src/main/scala/fpga/FetchPredictor.scala 212:32]
  assign io_pr_bp_entries_1_gcnt = io_btb_lu_result_1_attr == 2'h1 ? io_pht__lu_gcnt_1 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 213:38]
  assign io_pr_bp_entries_2_lcnt = io_pht__lu_lcnt_2; // @[src/main/scala/fpga/FetchPredictor.scala 212:32]
  assign io_pr_bp_entries_2_gcnt = io_btb_lu_result_2_attr == 2'h1 ? io_pht__lu_gcnt_2 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 213:38]
  assign io_pr_bp_entries_3_lcnt = io_pht__lu_lcnt_3; // @[src/main/scala/fpga/FetchPredictor.scala 212:32]
  assign io_pr_bp_entries_3_gcnt = io_btb_lu_result_3_attr == 2'h1 ? io_pht__lu_gcnt_3 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 213:38]
  assign io_pr_fp_ptr = {{1'd0}, _GEN_16};
  assign io_re_en = ~io_pr_flush_en & reg_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 216:39]
  assign io_re_flush_en = reg_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 217:20]
  assign io_re_history = io_pht__history; // @[src/main/scala/fpga/FetchPredictor.scala 218:20]
  assign io_ru_en = reg_iaddr_en & (|_bp1_en_T | |_bp1_en_T_2 | |_bp1_en_T_5); // @[src/main/scala/fpga/FetchPredictor.scala 199:31]
  assign io_ru_ptr = reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 205:21]
  assign io_ru_attr = 2'h3 == bp1_pos ? io_btb_lu_result_3_attr : _GEN_14; // @[src/main/scala/fpga/FetchPredictor.scala 206:{21,21}]
  assign io_ru_is_ret = 2'h3 == bp1_pos ? io_btb_lu_result_3_is_ret : _GEN_6; // @[src/main/scala/fpga/FetchPredictor.scala 198:{25,25}]
  assign io_ru_ras_index = io_ras_top_index; // @[src/main/scala/fpga/FetchPredictor.scala 208:21]
  assign io_ru_target = _GEN_7 ? io_ras_top_ret_pc : _GEN_11; // @[src/main/scala/fpga/FetchPredictor.scala 198:25]
  assign io_zbtb_lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 176:19]
  assign io_zbtb_up_en = io_cr_en & (io_cr_br_taken | (_io_btb_up_en_T_5 | _io_btb_up_en_T_7)); // @[src/main/scala/fpga/FetchPredictor.scala 328:35]
  assign io_zbtb_up_pc = io_cr_pc; // @[src/main/scala/fpga/FetchPredictor.scala 329:23]
  assign io_zbtb_up_target = io_cr_target; // @[src/main/scala/fpga/FetchPredictor.scala 330:23]
  assign io_zbtb_inv_en = _io_re_en_T & bp0_en & ~_GEN_20 & ~_GEN_24 & bp0_pos <= bp1_pos; // @[src/main/scala/fpga/FetchPredictor.scala 227:92]
  assign io_zbtb_inv_pc = {{26'd0}, _io_zbtb_inv_pc_T_2}; // @[src/main/scala/fpga/FetchPredictor.scala 228:20]
  assign io_btb_lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 188:18]
  assign io_btb_up_en = io_cr_en & _io_btb_up_en_T_9; // @[src/main/scala/fpga/FetchPredictor.scala 297:30]
  assign io_btb_up_pc = io_cr_pc; // @[src/main/scala/fpga/FetchPredictor.scala 306:23]
  assign io_btb_up_attr = io_cr_attr; // @[src/main/scala/fpga/FetchPredictor.scala 304:23]
  assign io_btb_up_is_ret = io_cr_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 305:23]
  assign io_btb_up_target = io_cr_target; // @[src/main/scala/fpga/FetchPredictor.scala 307:23]
  assign io_pht__lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 189:18]
  assign io_pht__up_en = io_cr_en & io_cr_attr == 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 316:35]
  assign io_pht__up_history = io_cr_fp_entry_history; // @[src/main/scala/fpga/FetchPredictor.scala 317:23]
  assign io_pht__up_pc = io_cr_pc; // @[src/main/scala/fpga/FetchPredictor.scala 318:23]
  assign io_pht__up_lcnt = io_cr_br_taken ? updated_lcnt_lcnt_if_taken : updated_lcnt_lcnt_unless_taken; // @[src/main/scala/fpga/FetchPredictor.scala 266:10]
  assign io_pht__up_gcnt = io_cr_br_taken ? updated_gcnt_gcnt_if_taken : updated_gcnt_gcnt_unless_taken; // @[src/main/scala/fpga/FetchPredictor.scala 282:10]
  assign io_pht__lmem_rdata = io_pht_lmem_rdata; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht__gmem_rdata = io_pht_gmem_rdata; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  assign io_pht__br_en = _io_ras_ret1_en_T_1 & _GEN_28; // @[src/main/scala/fpga/FetchPredictor.scala 246:53]
  assign io_pht__br_pc = {{25'd0}, _io_pht_br_pc_T_2}; // @[src/main/scala/fpga/FetchPredictor.scala 247:18]
  assign io_pht__br2_en = io_cr_en & io_cr_br_taken & (~io_cr_fp_hit | io_cr_fp_entry_attr != 2'h1); // @[src/main/scala/fpga/FetchPredictor.scala 323:54]
  assign io_pht__br2_history = io_cr_fp_entry_history; // @[src/main/scala/fpga/FetchPredictor.scala 324:24]
  assign io_pht__br2_pc = io_cr_pc; // @[src/main/scala/fpga/FetchPredictor.scala 325:24]
  assign io_pht__res_en = io_cr_mispred; // @[src/main/scala/fpga/FetchPredictor.scala 310:24]
  assign io_pht__res_history = io_cr_fp_entry_history; // @[src/main/scala/fpga/FetchPredictor.scala 311:24]
  assign io_ras_ret1_en = _io_re_en_T & reg_iaddr_en & _GEN_7; // @[src/main/scala/fpga/FetchPredictor.scala 231:60]
  assign io_ras_ret1_index = io_ras_top_index - 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 232:45]
  assign io_ras_call1_en = _io_ras_ret1_en_T_1 & _GEN_15 == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 233:60]
  assign io_ras_call1_index = io_ras_top_index + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 234:45]
  assign io_ras_call1_ret_pc = _io_ras_call1_ret_pc_T ? _io_ras_call1_ret_pc_T_4 : _io_ras_call1_ret_pc_T_9; // @[src/main/scala/fpga/FetchPredictor.scala 238:31]
  assign io_ras_up_en = io_cr_mispred; // @[src/main/scala/fpga/FetchPredictor.scala 333:21]
  assign io_ras_up_index = io_cr_fp_entry_ras_index; // @[src/main/scala/fpga/FetchPredictor.scala 334:21]
  assign io_ras_ret2_en = io_cr_en & io_cr_is_ret & (_io_pht_br2_en_T_1 | ~io_cr_fp_entry_is_ret); // @[src/main/scala/fpga/FetchPredictor.scala 337:53]
  assign io_ras_ret2_index = io_cr_fp_entry_ras_index - 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 338:53]
  assign io_ras_call2_en = io_cr_en & _io_btb_up_en_T_7 & _io_ras_call2_en_T_4; // @[src/main/scala/fpga/FetchPredictor.scala 341:72]
  assign io_ras_call2_index = io_cr_fp_entry_ras_index + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 343:53]
  assign io_ras_call2_ret_pc = io_cr_next_pc; // @[src/main/scala/fpga/FetchPredictor.scala 344:25]
  assign io_pht_lmem_ren = io_pht__lmem_ren; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht_lmem_wen = io_pht__lmem_wen; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht_lmem_raddr = io_pht__lmem_raddr; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht_lmem_waddr = io_pht__lmem_waddr; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht_lmem_wdata = io_pht__lmem_wdata; // @[src/main/scala/fpga/FetchPredictor.scala 163:15]
  assign io_pht_gmem_ren = io_pht__gmem_ren; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  assign io_pht_gmem_wen = io_pht__gmem_wen; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  assign io_pht_gmem_raddr = io_pht__gmem_raddr; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  assign io_pht_gmem_waddr = io_pht__gmem_waddr; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  assign io_pht_gmem_wdata = io_pht__gmem_wdata; // @[src/main/scala/fpga/FetchPredictor.scala 164:15]
  always @(posedge clock) begin
    reg_iaddr_en <= io_pr_iaddr_en; // @[src/main/scala/fpga/FetchPredictor.scala 167:34]
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 168:34]
      reg_iaddr_index <= 31'h0; // @[src/main/scala/fpga/FetchPredictor.scala 168:34]
    end else begin
      reg_iaddr_index <= io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 173:21]
    end
    reg_redirect_en <= io_pr_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 169:34]
    reg_flush_en <= io_pr_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 170:34]
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 171:34]
      reg_fp_ptr <= io_re_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 171:34]
    end else if (_io_re_en_T_1) begin // @[src/main/scala/fpga/FetchPredictor.scala 220:47]
      reg_fp_ptr <= io_re_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 221:20]
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
  reg_iaddr_en = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  reg_iaddr_index = _RAND_1[30:0];
  _RAND_2 = {1{`RANDOM}};
  reg_redirect_en = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  reg_flush_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_fp_ptr = _RAND_4[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module FetchRedirectBuffer(
  input         clock,
  input         reset,
  input         io_enq_en, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input         io_enq_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [5:0]  io_enq_history, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output [1:0]  io_enq_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output        io_enq_ready, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output        io_enq_left1, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input         io_upd_en, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [1:0]  io_upd_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [1:0]  io_upd_attr, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input         io_upd_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [2:0]  io_upd_ras_index, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [30:0] io_upd_target, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input         io_deq_en, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  input  [1:0]  io_read_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output [1:0]  io_read_fp_entry_attr, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output        io_read_fp_entry_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output [5:0]  io_read_fp_entry_history, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output [2:0]  io_read_fp_entry_ras_index, // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
  output [30:0] io_read_fp_entry_target // @[src/main/scala/fpga/FetchPredictor.scala 47:14]
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
`endif // RANDOMIZE_REG_INIT
  reg [1:0] buf_attr [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_io_read_fp_entry_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_attr_MPORT_4_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_4_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_attr_MPORT_4_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  reg  buf_is_ret [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_is_ret_MPORT_4_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_4_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_is_ret_MPORT_4_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  reg [5:0] buf_history [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_io_read_fp_entry_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_io_read_fp_entry_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [5:0] buf_history_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_history_MPORT_4_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_4_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_history_MPORT_4_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  reg [2:0] buf_ras_index [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_io_read_fp_entry_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_io_read_fp_entry_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [2:0] buf_ras_index_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_ras_index_MPORT_4_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_4_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_ras_index_MPORT_4_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  reg [30:0] buf_target [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_io_read_fp_entry_ras_index_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_io_read_fp_entry_ras_index_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [30:0] buf_target_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire [1:0] buf_target_MPORT_4_addr; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_4_mask; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  wire  buf_target_MPORT_4_en; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  reg [2:0] enq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 55:24]
  reg [2:0] deq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
  wire [2:0] _ready_T_1 = enq_ptr - deq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 58:25]
  wire  ready = ~_ready_T_1[2]; // @[src/main/scala/fpga/FetchPredictor.scala 58:15]
  wire [2:0] _enq_ptr_T_1 = enq_ptr + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 66:24]
  wire [2:0] _deq_ptr_T_1 = deq_ptr + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 69:24]
  wire  _T_3 = ~reset; // @[src/main/scala/fpga/FetchPredictor.scala 74:9]
  assign buf_attr_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_attr_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_attr_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_history_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_attr_io_read_fp_entry_ras_index_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_ras_index_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_ras_index_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_ras_index_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_attr_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_target_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_attr_MPORT_data = 2'h0;
  assign buf_attr_MPORT_addr = enq_ptr[1:0];
  assign buf_attr_MPORT_mask = 1'h0;
  assign buf_attr_MPORT_en = ready | io_enq_flush_en;
  assign buf_attr_MPORT_1_data = io_upd_attr;
  assign buf_attr_MPORT_1_addr = io_upd_ptr;
  assign buf_attr_MPORT_1_mask = 1'h1;
  assign buf_attr_MPORT_1_en = io_upd_en;
  assign buf_attr_MPORT_2_data = 2'h0;
  assign buf_attr_MPORT_2_addr = io_upd_ptr;
  assign buf_attr_MPORT_2_mask = 1'h0;
  assign buf_attr_MPORT_2_en = io_upd_en;
  assign buf_attr_MPORT_3_data = 2'h0;
  assign buf_attr_MPORT_3_addr = io_upd_ptr;
  assign buf_attr_MPORT_3_mask = 1'h0;
  assign buf_attr_MPORT_3_en = io_upd_en;
  assign buf_attr_MPORT_4_data = 2'h0;
  assign buf_attr_MPORT_4_addr = io_upd_ptr;
  assign buf_attr_MPORT_4_mask = 1'h0;
  assign buf_attr_MPORT_4_en = io_upd_en;
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_is_ret_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_history_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_is_ret_io_read_fp_entry_ras_index_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_ras_index_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_ras_index_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_ras_index_MPORT_addr]
    ; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_is_ret_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_target_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_is_ret_MPORT_data = 1'h0;
  assign buf_is_ret_MPORT_addr = enq_ptr[1:0];
  assign buf_is_ret_MPORT_mask = 1'h0;
  assign buf_is_ret_MPORT_en = ready | io_enq_flush_en;
  assign buf_is_ret_MPORT_1_data = 1'h0;
  assign buf_is_ret_MPORT_1_addr = io_upd_ptr;
  assign buf_is_ret_MPORT_1_mask = 1'h0;
  assign buf_is_ret_MPORT_1_en = io_upd_en;
  assign buf_is_ret_MPORT_2_data = io_upd_is_ret;
  assign buf_is_ret_MPORT_2_addr = io_upd_ptr;
  assign buf_is_ret_MPORT_2_mask = 1'h1;
  assign buf_is_ret_MPORT_2_en = io_upd_en;
  assign buf_is_ret_MPORT_3_data = 1'h0;
  assign buf_is_ret_MPORT_3_addr = io_upd_ptr;
  assign buf_is_ret_MPORT_3_mask = 1'h0;
  assign buf_is_ret_MPORT_3_en = io_upd_en;
  assign buf_is_ret_MPORT_4_data = 1'h0;
  assign buf_is_ret_MPORT_4_addr = io_upd_ptr;
  assign buf_is_ret_MPORT_4_mask = 1'h0;
  assign buf_is_ret_MPORT_4_en = io_upd_en;
  assign buf_history_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_attr_MPORT_data = buf_history[buf_history_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_history_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_is_ret_MPORT_data = buf_history[buf_history_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_history_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_history_MPORT_data = buf_history[buf_history_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_history_io_read_fp_entry_ras_index_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_ras_index_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_ras_index_MPORT_data =
    buf_history[buf_history_io_read_fp_entry_ras_index_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_history_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_target_MPORT_data = buf_history[buf_history_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_history_MPORT_data = io_enq_history;
  assign buf_history_MPORT_addr = enq_ptr[1:0];
  assign buf_history_MPORT_mask = 1'h1;
  assign buf_history_MPORT_en = ready | io_enq_flush_en;
  assign buf_history_MPORT_1_data = 6'h0;
  assign buf_history_MPORT_1_addr = io_upd_ptr;
  assign buf_history_MPORT_1_mask = 1'h0;
  assign buf_history_MPORT_1_en = io_upd_en;
  assign buf_history_MPORT_2_data = 6'h0;
  assign buf_history_MPORT_2_addr = io_upd_ptr;
  assign buf_history_MPORT_2_mask = 1'h0;
  assign buf_history_MPORT_2_en = io_upd_en;
  assign buf_history_MPORT_3_data = 6'h0;
  assign buf_history_MPORT_3_addr = io_upd_ptr;
  assign buf_history_MPORT_3_mask = 1'h0;
  assign buf_history_MPORT_3_en = io_upd_en;
  assign buf_history_MPORT_4_data = 6'h0;
  assign buf_history_MPORT_4_addr = io_upd_ptr;
  assign buf_history_MPORT_4_mask = 1'h0;
  assign buf_history_MPORT_4_en = io_upd_en;
  assign buf_ras_index_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_ras_index_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_ras_index_io_read_fp_entry_attr_MPORT_data = buf_ras_index[buf_ras_index_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_ras_index_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_ras_index_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_ras_index_io_read_fp_entry_is_ret_MPORT_data =
    buf_ras_index[buf_ras_index_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_ras_index_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_ras_index_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_ras_index_io_read_fp_entry_history_MPORT_data =
    buf_ras_index[buf_ras_index_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_ras_index_io_read_fp_entry_ras_index_MPORT_en = 1'h1;
  assign buf_ras_index_io_read_fp_entry_ras_index_MPORT_addr = io_read_ptr;
  assign buf_ras_index_io_read_fp_entry_ras_index_MPORT_data =
    buf_ras_index[buf_ras_index_io_read_fp_entry_ras_index_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_ras_index_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_ras_index_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_ras_index_io_read_fp_entry_target_MPORT_data =
    buf_ras_index[buf_ras_index_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_ras_index_MPORT_data = 3'h0;
  assign buf_ras_index_MPORT_addr = enq_ptr[1:0];
  assign buf_ras_index_MPORT_mask = 1'h0;
  assign buf_ras_index_MPORT_en = ready | io_enq_flush_en;
  assign buf_ras_index_MPORT_1_data = 3'h0;
  assign buf_ras_index_MPORT_1_addr = io_upd_ptr;
  assign buf_ras_index_MPORT_1_mask = 1'h0;
  assign buf_ras_index_MPORT_1_en = io_upd_en;
  assign buf_ras_index_MPORT_2_data = 3'h0;
  assign buf_ras_index_MPORT_2_addr = io_upd_ptr;
  assign buf_ras_index_MPORT_2_mask = 1'h0;
  assign buf_ras_index_MPORT_2_en = io_upd_en;
  assign buf_ras_index_MPORT_3_data = io_upd_ras_index;
  assign buf_ras_index_MPORT_3_addr = io_upd_ptr;
  assign buf_ras_index_MPORT_3_mask = 1'h1;
  assign buf_ras_index_MPORT_3_en = io_upd_en;
  assign buf_ras_index_MPORT_4_data = 3'h0;
  assign buf_ras_index_MPORT_4_addr = io_upd_ptr;
  assign buf_ras_index_MPORT_4_mask = 1'h0;
  assign buf_ras_index_MPORT_4_en = io_upd_en;
  assign buf_target_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_attr_MPORT_data = buf_target[buf_target_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_target_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_is_ret_MPORT_data = buf_target[buf_target_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_target_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_history_MPORT_data = buf_target[buf_target_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_target_io_read_fp_entry_ras_index_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_ras_index_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_ras_index_MPORT_data = buf_target[buf_target_io_read_fp_entry_ras_index_MPORT_addr]
    ; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_target_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_target_MPORT_data = buf_target[buf_target_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
  assign buf_target_MPORT_data = 31'h0;
  assign buf_target_MPORT_addr = enq_ptr[1:0];
  assign buf_target_MPORT_mask = 1'h0;
  assign buf_target_MPORT_en = ready | io_enq_flush_en;
  assign buf_target_MPORT_1_data = 31'h0;
  assign buf_target_MPORT_1_addr = io_upd_ptr;
  assign buf_target_MPORT_1_mask = 1'h0;
  assign buf_target_MPORT_1_en = io_upd_en;
  assign buf_target_MPORT_2_data = 31'h0;
  assign buf_target_MPORT_2_addr = io_upd_ptr;
  assign buf_target_MPORT_2_mask = 1'h0;
  assign buf_target_MPORT_2_en = io_upd_en;
  assign buf_target_MPORT_3_data = 31'h0;
  assign buf_target_MPORT_3_addr = io_upd_ptr;
  assign buf_target_MPORT_3_mask = 1'h0;
  assign buf_target_MPORT_3_en = io_upd_en;
  assign buf_target_MPORT_4_data = io_upd_target;
  assign buf_target_MPORT_4_addr = io_upd_ptr;
  assign buf_target_MPORT_4_mask = 1'h1;
  assign buf_target_MPORT_4_en = io_upd_en;
  assign io_enq_ptr = enq_ptr[1:0]; // @[src/main/scala/fpga/FetchPredictor.scala 61:16]
  assign io_enq_ready = ~_ready_T_1[2]; // @[src/main/scala/fpga/FetchPredictor.scala 58:15]
  assign io_enq_left1 = _ready_T_1[1:0] == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 60:57]
  assign io_read_fp_entry_attr = buf_attr_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 84:30]
  assign io_read_fp_entry_is_ret = buf_is_ret_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 85:30]
  assign io_read_fp_entry_history = buf_history_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 86:30]
  assign io_read_fp_entry_ras_index = buf_ras_index_io_read_fp_entry_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 87:30]
  assign io_read_fp_entry_target = buf_target_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 88:30]
  always @(posedge clock) begin
    if (buf_attr_MPORT_en & buf_attr_MPORT_mask) begin
      buf_attr[buf_attr_MPORT_addr] <= buf_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_attr_MPORT_1_en & buf_attr_MPORT_1_mask) begin
      buf_attr[buf_attr_MPORT_1_addr] <= buf_attr_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_attr_MPORT_2_en & buf_attr_MPORT_2_mask) begin
      buf_attr[buf_attr_MPORT_2_addr] <= buf_attr_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_attr_MPORT_3_en & buf_attr_MPORT_3_mask) begin
      buf_attr[buf_attr_MPORT_3_addr] <= buf_attr_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_attr_MPORT_4_en & buf_attr_MPORT_4_mask) begin
      buf_attr[buf_attr_MPORT_4_addr] <= buf_attr_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_is_ret_MPORT_en & buf_is_ret_MPORT_mask) begin
      buf_is_ret[buf_is_ret_MPORT_addr] <= buf_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_is_ret_MPORT_1_en & buf_is_ret_MPORT_1_mask) begin
      buf_is_ret[buf_is_ret_MPORT_1_addr] <= buf_is_ret_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_is_ret_MPORT_2_en & buf_is_ret_MPORT_2_mask) begin
      buf_is_ret[buf_is_ret_MPORT_2_addr] <= buf_is_ret_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_is_ret_MPORT_3_en & buf_is_ret_MPORT_3_mask) begin
      buf_is_ret[buf_is_ret_MPORT_3_addr] <= buf_is_ret_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_is_ret_MPORT_4_en & buf_is_ret_MPORT_4_mask) begin
      buf_is_ret[buf_is_ret_MPORT_4_addr] <= buf_is_ret_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_history_MPORT_en & buf_history_MPORT_mask) begin
      buf_history[buf_history_MPORT_addr] <= buf_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_history_MPORT_1_en & buf_history_MPORT_1_mask) begin
      buf_history[buf_history_MPORT_1_addr] <= buf_history_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_history_MPORT_2_en & buf_history_MPORT_2_mask) begin
      buf_history[buf_history_MPORT_2_addr] <= buf_history_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_history_MPORT_3_en & buf_history_MPORT_3_mask) begin
      buf_history[buf_history_MPORT_3_addr] <= buf_history_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_history_MPORT_4_en & buf_history_MPORT_4_mask) begin
      buf_history[buf_history_MPORT_4_addr] <= buf_history_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_ras_index_MPORT_en & buf_ras_index_MPORT_mask) begin
      buf_ras_index[buf_ras_index_MPORT_addr] <= buf_ras_index_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_ras_index_MPORT_1_en & buf_ras_index_MPORT_1_mask) begin
      buf_ras_index[buf_ras_index_MPORT_1_addr] <= buf_ras_index_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_ras_index_MPORT_2_en & buf_ras_index_MPORT_2_mask) begin
      buf_ras_index[buf_ras_index_MPORT_2_addr] <= buf_ras_index_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_ras_index_MPORT_3_en & buf_ras_index_MPORT_3_mask) begin
      buf_ras_index[buf_ras_index_MPORT_3_addr] <= buf_ras_index_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_ras_index_MPORT_4_en & buf_ras_index_MPORT_4_mask) begin
      buf_ras_index[buf_ras_index_MPORT_4_addr] <= buf_ras_index_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_target_MPORT_en & buf_target_MPORT_mask) begin
      buf_target[buf_target_MPORT_addr] <= buf_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_target_MPORT_1_en & buf_target_MPORT_1_mask) begin
      buf_target[buf_target_MPORT_1_addr] <= buf_target_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_target_MPORT_2_en & buf_target_MPORT_2_mask) begin
      buf_target[buf_target_MPORT_2_addr] <= buf_target_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_target_MPORT_3_en & buf_target_MPORT_3_mask) begin
      buf_target[buf_target_MPORT_3_addr] <= buf_target_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (buf_target_MPORT_4_en & buf_target_MPORT_4_mask) begin
      buf_target[buf_target_MPORT_4_addr] <= buf_target_MPORT_4_data; // @[src/main/scala/fpga/FetchPredictor.scala 54:16]
    end
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 55:24]
      enq_ptr <= 3'h0; // @[src/main/scala/fpga/FetchPredictor.scala 55:24]
    end else if (io_enq_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 65:20]
      enq_ptr <= _enq_ptr_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 66:13]
    end
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
      deq_ptr <= 3'h0; // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
    end else if (io_enq_flush_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 71:26]
      deq_ptr <= enq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 72:13]
    end else if (io_deq_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 68:20]
      deq_ptr <= _deq_ptr_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 69:13]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"redir enq_ptr = %d\n",enq_ptr); // @[src/main/scala/fpga/FetchPredictor.scala 74:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"redir deq_ptr = %d\n",deq_ptr); // @[src/main/scala/fpga/FetchPredictor.scala 75:9]
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
    buf_attr[initvar] = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    buf_is_ret[initvar] = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    buf_history[initvar] = _RAND_2[5:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    buf_ras_index[initvar] = _RAND_3[2:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    buf_target[initvar] = _RAND_4[30:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  enq_ptr = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  deq_ptr = _RAND_6[2:0];
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
  input         io_ft_flush_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_ft_flush_iaddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst1_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_ft_inst1_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [31:0] io_ft_inst1_data, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst1_bpfailed, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst1_redirected, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst1_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst1_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst1_fp_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_ft_inst1_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst2_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_ft_inst2_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [31:0] io_ft_inst2_data, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst2_bpfailed, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_inst2_redirected, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst2_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst2_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_ft_inst2_fp_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_ft_inst2_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_imem_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [31:0] io_ft_imem_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [63:0] io_ft_imem_inst, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_ft_imem_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_icache_addr_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [31:0] io_ft_icache_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_ft_icache_addr_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [63:0] io_ft_icache_idata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_ft_icache_idata_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ft_icache_idata_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_cr_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_cr_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_cr_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_cr_fp_entry_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_fp_entry_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [5:0]  io_cr_fp_entry_history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [2:0]  io_cr_fp_entry_ras_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_cr_fp_entry_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_fp_hit, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_mispred, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_br_taken, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_cr_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_cr_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_cr_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_cr_next_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_redir_deq_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_redir_read_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_redir_read_fp_entry_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_redir_read_fp_entry_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [5:0]  io_redir_read_fp_entry_history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_redir_read_fp_entry_ras_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_redir_read_fp_entry_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_zbtb_lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_zbtb_lu_matches_0, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_zbtb_lu_matches_1, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_zbtb_lu_matches_2, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_zbtb_lu_matches_3, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_zbtb_lu_target_0, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_zbtb_lu_target_1, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_zbtb_lu_target_2, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_zbtb_lu_target_3, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_zbtb_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_zbtb_up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_zbtb_up_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_zbtb_inv_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_zbtb_inv_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_btb_lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_0_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_0_br, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_btb_lu_result_0_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_0_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_btb_lu_result_0_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_1_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_1_br, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_btb_lu_result_1_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_1_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_btb_lu_result_1_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_2_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_2_br, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_btb_lu_result_2_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_2_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_btb_lu_result_2_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_3_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_3_br, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_btb_lu_result_3_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_btb_lu_result_3_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_btb_lu_result_3_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_btb_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_btb_up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_btb_up_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_btb_up_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_btb_up_target, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_pht__lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lu_taken_0, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lu_taken_1, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lu_taken_2, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lu_taken_3, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_lcnt_0, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_lcnt_1, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_lcnt_2, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_lcnt_3, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_gcnt_0, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_gcnt_1, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_gcnt_2, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lu_gcnt_3, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht__up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [5:0]  io_pht__up_history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_pht__up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_pht__up_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_pht__up_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__lmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [10:0] io_pht__lmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [7:0]  io_pht__lmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [12:0] io_pht__lmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__lmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__gmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input         io_pht__gmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [10:0] io_pht__gmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [7:0]  io_pht__gmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [12:0] io_pht__gmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [1:0]  io_pht__gmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht__br_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_pht__br_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht__br2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [5:0]  io_pht__br2_history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_pht__br2_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [5:0]  io_pht__history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht__res_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [5:0]  io_pht__res_history, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [30:0] io_ras_top_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [2:0]  io_ras_top_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ras_ret1_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_ras_ret1_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ras_call1_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_ras_call1_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_ras_call1_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ras_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_ras_up_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ras_ret2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_ras_ret2_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_ras_call2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [2:0]  io_ras_call2_index, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [30:0] io_ras_call2_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht_lmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht_lmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [10:0] io_pht_lmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [7:0]  io_pht_lmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [12:0] io_pht_lmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_pht_lmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht_gmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output        io_pht_gmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [10:0] io_pht_gmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  input  [7:0]  io_pht_gmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [12:0] io_pht_gmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
  output [1:0]  io_pht_gmem_wdata // @[src/main/scala/fpga/sim/FetchSim.scala 19:14]
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
`endif // RANDOMIZE_REG_INIT
  wire  fetcher_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_ft_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [31:0] fetcher_io_ft_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst1_bpfailed; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst1_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst1_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst1_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst1_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_ft_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [31:0] fetcher_io_ft_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst2_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst2_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst2_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_ft_inst2_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [31:0] fetcher_io_ft_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [63:0] fetcher_io_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [31:0] fetcher_io_ft_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [63:0] fetcher_io_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fetcher_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [30:0] fetcher_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [1:0] fetcher_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire [2:0] fetcher_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
  wire  fp_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_cr_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_cr_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_cr_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_cr_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_cr_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_cr_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_cr_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_re_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_re_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_re_history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_re_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_re_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_re_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ru_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_ru_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_ru_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ru_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ru_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_ru_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_zbtb_inv_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_zbtb_inv_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_btb_up_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_btb_up_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_btb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pht__lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_pht__up_history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pht__up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__up_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__up_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [10:0] fp_io_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [7:0] fp_io_pht__lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [12:0] fp_io_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [10:0] fp_io_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [7:0] fp_io_pht__gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [12:0] fp_io_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__br_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pht__br_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__br2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_pht__br2_history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_pht__br2_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht__res_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [5:0] fp_io_pht__res_history; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_top_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ras_ret1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_ret1_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ras_call1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_call1_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_ras_call1_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ras_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_up_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ras_ret2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_ret2_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_ras_call2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [2:0] fp_io_ras_call2_index; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [30:0] fp_io_ras_call2_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht_lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht_lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [10:0] fp_io_pht_lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [7:0] fp_io_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [12:0] fp_io_pht_lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht_lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht_gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  fp_io_pht_gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [10:0] fp_io_pht_gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [7:0] fp_io_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [12:0] fp_io_pht_gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire [1:0] fp_io_pht_gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
  wire  rb_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_enq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_enq_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [5:0] rb_io_enq_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] rb_io_enq_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_enq_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_enq_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] rb_io_upd_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] rb_io_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [2:0] rb_io_upd_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] rb_io_upd_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] rb_io_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] rb_io_read_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_io_read_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [5:0] rb_io_read_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [2:0] rb_io_read_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] rb_io_read_fp_entry_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  reg  reg_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg [30:0] reg_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg [63:0] reg_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg [63:0] reg_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 31:27]
  reg  reg_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [30:0] reg_cr_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [1:0] reg_cr_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [1:0] reg_cr_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [1:0] reg_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [5:0] reg_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [2:0] reg_cr_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [1:0] reg_cr_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [30:0] reg_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [30:0] reg_cr_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [1:0] reg_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 34:27]
  reg  reg_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg  reg_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg  reg_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg  reg_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg [30:0] reg_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg [30:0] reg_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg [30:0] reg_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg [30:0] reg_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg  reg_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [1:0] reg_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [1:0] reg_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [1:0] reg_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [1:0] reg_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [10:0] reg_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [12:0] reg_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [10:0] reg_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [12:0] reg_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [5:0] reg_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [30:0] reg_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [2:0] reg_ras_top_index; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [7:0] reg_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 39:27]
  reg [7:0] reg_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 40:27]
  reg  reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 41:31]
  Fetcher fetcher ( // @[src/main/scala/fpga/sim/FetchSim.scala 43:23]
    .clock(fetcher_clock),
    .reset(fetcher_reset),
    .io_ft_flush_en(fetcher_io_ft_flush_en),
    .io_ft_flush_iaddr(fetcher_io_ft_flush_iaddr),
    .io_ft_inst1_valid(fetcher_io_ft_inst1_valid),
    .io_ft_inst1_addr(fetcher_io_ft_inst1_addr),
    .io_ft_inst1_data(fetcher_io_ft_inst1_data),
    .io_ft_inst1_bpfailed(fetcher_io_ft_inst1_bpfailed),
    .io_ft_inst1_redirected(fetcher_io_ft_inst1_redirected),
    .io_ft_inst1_bp_entry_lcnt(fetcher_io_ft_inst1_bp_entry_lcnt),
    .io_ft_inst1_bp_entry_gcnt(fetcher_io_ft_inst1_bp_entry_gcnt),
    .io_ft_inst1_fp_ptr(fetcher_io_ft_inst1_fp_ptr),
    .io_ft_inst1_ready(fetcher_io_ft_inst1_ready),
    .io_ft_inst2_valid(fetcher_io_ft_inst2_valid),
    .io_ft_inst2_addr(fetcher_io_ft_inst2_addr),
    .io_ft_inst2_data(fetcher_io_ft_inst2_data),
    .io_ft_inst2_redirected(fetcher_io_ft_inst2_redirected),
    .io_ft_inst2_bp_entry_lcnt(fetcher_io_ft_inst2_bp_entry_lcnt),
    .io_ft_inst2_bp_entry_gcnt(fetcher_io_ft_inst2_bp_entry_gcnt),
    .io_ft_inst2_fp_ptr(fetcher_io_ft_inst2_fp_ptr),
    .io_ft_inst2_ready(fetcher_io_ft_inst2_ready),
    .io_ft_imem_en(fetcher_io_ft_imem_en),
    .io_ft_imem_addr(fetcher_io_ft_imem_addr),
    .io_ft_imem_inst(fetcher_io_ft_imem_inst),
    .io_ft_imem_valid(fetcher_io_ft_imem_valid),
    .io_ft_icache_addr_en(fetcher_io_ft_icache_addr_en),
    .io_ft_icache_addr(fetcher_io_ft_icache_addr),
    .io_ft_icache_addr_ready(fetcher_io_ft_icache_addr_ready),
    .io_ft_icache_idata(fetcher_io_ft_icache_idata),
    .io_ft_icache_idata_valid(fetcher_io_ft_icache_idata_valid),
    .io_pr_iaddr_en(fetcher_io_pr_iaddr_en),
    .io_pr_iaddr(fetcher_io_pr_iaddr),
    .io_pr_flush_en(fetcher_io_pr_flush_en),
    .io_pr_redirect_en(fetcher_io_pr_redirect_en),
    .io_pr_redirect_ready(fetcher_io_pr_redirect_ready),
    .io_pr_bp0_en(fetcher_io_pr_bp0_en),
    .io_pr_bp0_pos(fetcher_io_pr_bp0_pos),
    .io_pr_bp0_addr(fetcher_io_pr_bp0_addr),
    .io_pr_bp1_en(fetcher_io_pr_bp1_en),
    .io_pr_bp1_pos(fetcher_io_pr_bp1_pos),
    .io_pr_bp1_addr(fetcher_io_pr_bp1_addr),
    .io_pr_bp_entries_0_lcnt(fetcher_io_pr_bp_entries_0_lcnt),
    .io_pr_bp_entries_0_gcnt(fetcher_io_pr_bp_entries_0_gcnt),
    .io_pr_bp_entries_1_lcnt(fetcher_io_pr_bp_entries_1_lcnt),
    .io_pr_bp_entries_1_gcnt(fetcher_io_pr_bp_entries_1_gcnt),
    .io_pr_bp_entries_2_lcnt(fetcher_io_pr_bp_entries_2_lcnt),
    .io_pr_bp_entries_2_gcnt(fetcher_io_pr_bp_entries_2_gcnt),
    .io_pr_bp_entries_3_lcnt(fetcher_io_pr_bp_entries_3_lcnt),
    .io_pr_bp_entries_3_gcnt(fetcher_io_pr_bp_entries_3_gcnt),
    .io_pr_fp_ptr(fetcher_io_pr_fp_ptr)
  );
  FetchPredictor fp ( // @[src/main/scala/fpga/sim/FetchSim.scala 44:18]
    .clock(fp_clock),
    .reset(fp_reset),
    .io_pr_iaddr_en(fp_io_pr_iaddr_en),
    .io_pr_iaddr(fp_io_pr_iaddr),
    .io_pr_flush_en(fp_io_pr_flush_en),
    .io_pr_redirect_en(fp_io_pr_redirect_en),
    .io_pr_redirect_ready(fp_io_pr_redirect_ready),
    .io_pr_bp0_en(fp_io_pr_bp0_en),
    .io_pr_bp0_pos(fp_io_pr_bp0_pos),
    .io_pr_bp0_addr(fp_io_pr_bp0_addr),
    .io_pr_bp1_en(fp_io_pr_bp1_en),
    .io_pr_bp1_pos(fp_io_pr_bp1_pos),
    .io_pr_bp1_addr(fp_io_pr_bp1_addr),
    .io_pr_bp_entries_0_lcnt(fp_io_pr_bp_entries_0_lcnt),
    .io_pr_bp_entries_0_gcnt(fp_io_pr_bp_entries_0_gcnt),
    .io_pr_bp_entries_1_lcnt(fp_io_pr_bp_entries_1_lcnt),
    .io_pr_bp_entries_1_gcnt(fp_io_pr_bp_entries_1_gcnt),
    .io_pr_bp_entries_2_lcnt(fp_io_pr_bp_entries_2_lcnt),
    .io_pr_bp_entries_2_gcnt(fp_io_pr_bp_entries_2_gcnt),
    .io_pr_bp_entries_3_lcnt(fp_io_pr_bp_entries_3_lcnt),
    .io_pr_bp_entries_3_gcnt(fp_io_pr_bp_entries_3_gcnt),
    .io_pr_fp_ptr(fp_io_pr_fp_ptr),
    .io_cr_en(fp_io_cr_en),
    .io_cr_pc(fp_io_cr_pc),
    .io_cr_bp_entry_lcnt(fp_io_cr_bp_entry_lcnt),
    .io_cr_bp_entry_gcnt(fp_io_cr_bp_entry_gcnt),
    .io_cr_fp_entry_attr(fp_io_cr_fp_entry_attr),
    .io_cr_fp_entry_is_ret(fp_io_cr_fp_entry_is_ret),
    .io_cr_fp_entry_history(fp_io_cr_fp_entry_history),
    .io_cr_fp_entry_ras_index(fp_io_cr_fp_entry_ras_index),
    .io_cr_fp_hit(fp_io_cr_fp_hit),
    .io_cr_mispred(fp_io_cr_mispred),
    .io_cr_br_taken(fp_io_cr_br_taken),
    .io_cr_attr(fp_io_cr_attr),
    .io_cr_is_ret(fp_io_cr_is_ret),
    .io_cr_target(fp_io_cr_target),
    .io_cr_next_pc(fp_io_cr_next_pc),
    .io_re_en(fp_io_re_en),
    .io_re_flush_en(fp_io_re_flush_en),
    .io_re_history(fp_io_re_history),
    .io_re_ptr(fp_io_re_ptr),
    .io_re_ready(fp_io_re_ready),
    .io_re_left1(fp_io_re_left1),
    .io_ru_en(fp_io_ru_en),
    .io_ru_ptr(fp_io_ru_ptr),
    .io_ru_attr(fp_io_ru_attr),
    .io_ru_is_ret(fp_io_ru_is_ret),
    .io_ru_ras_index(fp_io_ru_ras_index),
    .io_ru_target(fp_io_ru_target),
    .io_zbtb_lu_pc(fp_io_zbtb_lu_pc),
    .io_zbtb_lu_matches_0(fp_io_zbtb_lu_matches_0),
    .io_zbtb_lu_matches_1(fp_io_zbtb_lu_matches_1),
    .io_zbtb_lu_matches_2(fp_io_zbtb_lu_matches_2),
    .io_zbtb_lu_matches_3(fp_io_zbtb_lu_matches_3),
    .io_zbtb_lu_target_0(fp_io_zbtb_lu_target_0),
    .io_zbtb_lu_target_1(fp_io_zbtb_lu_target_1),
    .io_zbtb_lu_target_2(fp_io_zbtb_lu_target_2),
    .io_zbtb_lu_target_3(fp_io_zbtb_lu_target_3),
    .io_zbtb_up_en(fp_io_zbtb_up_en),
    .io_zbtb_up_pc(fp_io_zbtb_up_pc),
    .io_zbtb_up_target(fp_io_zbtb_up_target),
    .io_zbtb_inv_en(fp_io_zbtb_inv_en),
    .io_zbtb_inv_pc(fp_io_zbtb_inv_pc),
    .io_btb_lu_pc(fp_io_btb_lu_pc),
    .io_btb_lu_result_0_jump(fp_io_btb_lu_result_0_jump),
    .io_btb_lu_result_0_br(fp_io_btb_lu_result_0_br),
    .io_btb_lu_result_0_attr(fp_io_btb_lu_result_0_attr),
    .io_btb_lu_result_0_is_ret(fp_io_btb_lu_result_0_is_ret),
    .io_btb_lu_result_0_target(fp_io_btb_lu_result_0_target),
    .io_btb_lu_result_1_jump(fp_io_btb_lu_result_1_jump),
    .io_btb_lu_result_1_br(fp_io_btb_lu_result_1_br),
    .io_btb_lu_result_1_attr(fp_io_btb_lu_result_1_attr),
    .io_btb_lu_result_1_is_ret(fp_io_btb_lu_result_1_is_ret),
    .io_btb_lu_result_1_target(fp_io_btb_lu_result_1_target),
    .io_btb_lu_result_2_jump(fp_io_btb_lu_result_2_jump),
    .io_btb_lu_result_2_br(fp_io_btb_lu_result_2_br),
    .io_btb_lu_result_2_attr(fp_io_btb_lu_result_2_attr),
    .io_btb_lu_result_2_is_ret(fp_io_btb_lu_result_2_is_ret),
    .io_btb_lu_result_2_target(fp_io_btb_lu_result_2_target),
    .io_btb_lu_result_3_jump(fp_io_btb_lu_result_3_jump),
    .io_btb_lu_result_3_br(fp_io_btb_lu_result_3_br),
    .io_btb_lu_result_3_attr(fp_io_btb_lu_result_3_attr),
    .io_btb_lu_result_3_is_ret(fp_io_btb_lu_result_3_is_ret),
    .io_btb_lu_result_3_target(fp_io_btb_lu_result_3_target),
    .io_btb_up_en(fp_io_btb_up_en),
    .io_btb_up_pc(fp_io_btb_up_pc),
    .io_btb_up_attr(fp_io_btb_up_attr),
    .io_btb_up_is_ret(fp_io_btb_up_is_ret),
    .io_btb_up_target(fp_io_btb_up_target),
    .io_pht__lu_pc(fp_io_pht__lu_pc),
    .io_pht__lu_taken_0(fp_io_pht__lu_taken_0),
    .io_pht__lu_taken_1(fp_io_pht__lu_taken_1),
    .io_pht__lu_taken_2(fp_io_pht__lu_taken_2),
    .io_pht__lu_taken_3(fp_io_pht__lu_taken_3),
    .io_pht__lu_lcnt_0(fp_io_pht__lu_lcnt_0),
    .io_pht__lu_lcnt_1(fp_io_pht__lu_lcnt_1),
    .io_pht__lu_lcnt_2(fp_io_pht__lu_lcnt_2),
    .io_pht__lu_lcnt_3(fp_io_pht__lu_lcnt_3),
    .io_pht__lu_gcnt_0(fp_io_pht__lu_gcnt_0),
    .io_pht__lu_gcnt_1(fp_io_pht__lu_gcnt_1),
    .io_pht__lu_gcnt_2(fp_io_pht__lu_gcnt_2),
    .io_pht__lu_gcnt_3(fp_io_pht__lu_gcnt_3),
    .io_pht__up_en(fp_io_pht__up_en),
    .io_pht__up_history(fp_io_pht__up_history),
    .io_pht__up_pc(fp_io_pht__up_pc),
    .io_pht__up_lcnt(fp_io_pht__up_lcnt),
    .io_pht__up_gcnt(fp_io_pht__up_gcnt),
    .io_pht__lmem_ren(fp_io_pht__lmem_ren),
    .io_pht__lmem_wen(fp_io_pht__lmem_wen),
    .io_pht__lmem_raddr(fp_io_pht__lmem_raddr),
    .io_pht__lmem_rdata(fp_io_pht__lmem_rdata),
    .io_pht__lmem_waddr(fp_io_pht__lmem_waddr),
    .io_pht__lmem_wdata(fp_io_pht__lmem_wdata),
    .io_pht__gmem_ren(fp_io_pht__gmem_ren),
    .io_pht__gmem_wen(fp_io_pht__gmem_wen),
    .io_pht__gmem_raddr(fp_io_pht__gmem_raddr),
    .io_pht__gmem_rdata(fp_io_pht__gmem_rdata),
    .io_pht__gmem_waddr(fp_io_pht__gmem_waddr),
    .io_pht__gmem_wdata(fp_io_pht__gmem_wdata),
    .io_pht__br_en(fp_io_pht__br_en),
    .io_pht__br_pc(fp_io_pht__br_pc),
    .io_pht__br2_en(fp_io_pht__br2_en),
    .io_pht__br2_history(fp_io_pht__br2_history),
    .io_pht__br2_pc(fp_io_pht__br2_pc),
    .io_pht__history(fp_io_pht__history),
    .io_pht__res_en(fp_io_pht__res_en),
    .io_pht__res_history(fp_io_pht__res_history),
    .io_ras_top_ret_pc(fp_io_ras_top_ret_pc),
    .io_ras_top_index(fp_io_ras_top_index),
    .io_ras_ret1_en(fp_io_ras_ret1_en),
    .io_ras_ret1_index(fp_io_ras_ret1_index),
    .io_ras_call1_en(fp_io_ras_call1_en),
    .io_ras_call1_index(fp_io_ras_call1_index),
    .io_ras_call1_ret_pc(fp_io_ras_call1_ret_pc),
    .io_ras_up_en(fp_io_ras_up_en),
    .io_ras_up_index(fp_io_ras_up_index),
    .io_ras_ret2_en(fp_io_ras_ret2_en),
    .io_ras_ret2_index(fp_io_ras_ret2_index),
    .io_ras_call2_en(fp_io_ras_call2_en),
    .io_ras_call2_index(fp_io_ras_call2_index),
    .io_ras_call2_ret_pc(fp_io_ras_call2_ret_pc),
    .io_pht_lmem_ren(fp_io_pht_lmem_ren),
    .io_pht_lmem_wen(fp_io_pht_lmem_wen),
    .io_pht_lmem_raddr(fp_io_pht_lmem_raddr),
    .io_pht_lmem_rdata(fp_io_pht_lmem_rdata),
    .io_pht_lmem_waddr(fp_io_pht_lmem_waddr),
    .io_pht_lmem_wdata(fp_io_pht_lmem_wdata),
    .io_pht_gmem_ren(fp_io_pht_gmem_ren),
    .io_pht_gmem_wen(fp_io_pht_gmem_wen),
    .io_pht_gmem_raddr(fp_io_pht_gmem_raddr),
    .io_pht_gmem_rdata(fp_io_pht_gmem_rdata),
    .io_pht_gmem_waddr(fp_io_pht_gmem_waddr),
    .io_pht_gmem_wdata(fp_io_pht_gmem_wdata)
  );
  FetchRedirectBuffer rb ( // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
    .clock(rb_clock),
    .reset(rb_reset),
    .io_enq_en(rb_io_enq_en),
    .io_enq_flush_en(rb_io_enq_flush_en),
    .io_enq_history(rb_io_enq_history),
    .io_enq_ptr(rb_io_enq_ptr),
    .io_enq_ready(rb_io_enq_ready),
    .io_enq_left1(rb_io_enq_left1),
    .io_upd_en(rb_io_upd_en),
    .io_upd_ptr(rb_io_upd_ptr),
    .io_upd_attr(rb_io_upd_attr),
    .io_upd_is_ret(rb_io_upd_is_ret),
    .io_upd_ras_index(rb_io_upd_ras_index),
    .io_upd_target(rb_io_upd_target),
    .io_deq_en(rb_io_deq_en),
    .io_read_ptr(rb_io_read_ptr),
    .io_read_fp_entry_attr(rb_io_read_fp_entry_attr),
    .io_read_fp_entry_is_ret(rb_io_read_fp_entry_is_ret),
    .io_read_fp_entry_history(rb_io_read_fp_entry_history),
    .io_read_fp_entry_ras_index(rb_io_read_fp_entry_ras_index),
    .io_read_fp_entry_target(rb_io_read_fp_entry_target)
  );
  assign io_ft_inst1_valid = fetcher_io_ft_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_addr = fetcher_io_ft_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_data = fetcher_io_ft_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_bpfailed = fetcher_io_ft_inst1_bpfailed; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_redirected = fetcher_io_ft_inst1_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_bp_entry_lcnt = fetcher_io_ft_inst1_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_bp_entry_gcnt = fetcher_io_ft_inst1_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst1_fp_ptr = fetcher_io_ft_inst1_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_valid = fetcher_io_ft_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_addr = fetcher_io_ft_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_data = fetcher_io_ft_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_bpfailed = 1'h0; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_redirected = fetcher_io_ft_inst2_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_bp_entry_lcnt = fetcher_io_ft_inst2_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_bp_entry_gcnt = fetcher_io_ft_inst2_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_inst2_fp_ptr = fetcher_io_ft_inst2_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_imem_en = fetcher_io_ft_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_imem_addr = fetcher_io_ft_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_icache_addr_en = fetcher_io_ft_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_icache_addr = fetcher_io_ft_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_ft_icache_idata_ready = 1'h1; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
  assign io_redir_read_fp_entry_attr = rb_io_read_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_redir_read_fp_entry_is_ret = rb_io_read_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_redir_read_fp_entry_history = rb_io_read_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_redir_read_fp_entry_ras_index = rb_io_read_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_redir_read_fp_entry_target = rb_io_read_fp_entry_target; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_zbtb_lu_pc = fp_io_zbtb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_zbtb_up_en = fp_io_zbtb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_zbtb_up_pc = fp_io_zbtb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_zbtb_up_target = fp_io_zbtb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_zbtb_inv_en = fp_io_zbtb_inv_en; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_zbtb_inv_pc = fp_io_zbtb_inv_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 114:18]
  assign io_btb_lu_pc = fp_io_btb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_btb_up_en = fp_io_btb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_btb_up_pc = fp_io_btb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_btb_up_attr = fp_io_btb_up_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_btb_up_is_ret = fp_io_btb_up_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_btb_up_target = fp_io_btb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_pht__lu_pc = fp_io_pht__lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__up_en = fp_io_pht__up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__up_history = fp_io_pht__up_history; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__up_pc = fp_io_pht__up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__up_lcnt = fp_io_pht__up_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__up_gcnt = fp_io_pht__up_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__lmem_rdata = fp_io_pht__lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__gmem_rdata = fp_io_pht__gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__br_en = fp_io_pht__br_en; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__br_pc = fp_io_pht__br_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__br2_en = fp_io_pht__br2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__br2_history = fp_io_pht__br2_history; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__br2_pc = fp_io_pht__br2_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__res_en = fp_io_pht__res_en; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_pht__res_history = fp_io_pht__res_history; // @[src/main/scala/fpga/sim/FetchSim.scala 116:18]
  assign io_ras_ret1_en = fp_io_ras_ret1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_ret1_index = fp_io_ras_ret1_index; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call1_en = fp_io_ras_call1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call1_index = fp_io_ras_call1_index; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call1_ret_pc = fp_io_ras_call1_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_up_en = fp_io_ras_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_up_index = fp_io_ras_up_index; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_ret2_en = fp_io_ras_ret2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_ret2_index = fp_io_ras_ret2_index; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call2_en = fp_io_ras_call2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call2_index = fp_io_ras_call2_index; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_ras_call2_ret_pc = fp_io_ras_call2_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_pht_lmem_ren = fp_io_pht_lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht_lmem_wen = fp_io_pht_lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht_lmem_raddr = fp_io_pht_lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht_lmem_waddr = fp_io_pht_lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht_lmem_wdata = fp_io_pht_lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht_gmem_ren = fp_io_pht_gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht_gmem_wen = fp_io_pht_gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht_gmem_raddr = fp_io_pht_gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht_gmem_waddr = fp_io_pht_gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht_gmem_wdata = fp_io_pht_gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign fetcher_clock = clock;
  assign fetcher_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 47:33]
  assign fetcher_io_ft_flush_en = reg_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 50:36]
  assign fetcher_io_ft_flush_iaddr = reg_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 58:36]
  assign fetcher_io_ft_inst1_ready = reg_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 56:36]
  assign fetcher_io_ft_inst2_ready = reg_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 51:36]
  assign fetcher_io_ft_imem_inst = reg_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 52:36]
  assign fetcher_io_ft_imem_valid = reg_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 55:36]
  assign fetcher_io_ft_icache_addr_ready = reg_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 53:36]
  assign fetcher_io_ft_icache_idata = reg_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 54:36]
  assign fetcher_io_ft_icache_idata_valid = reg_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 57:36]
  assign fetcher_io_pr_redirect_ready = fp_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp0_en = fp_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp0_pos = fp_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp0_addr = fp_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp1_en = fp_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp1_pos = fp_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp1_addr = fp_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_0_lcnt = fp_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_0_gcnt = fp_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_1_lcnt = fp_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_1_gcnt = fp_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_2_lcnt = fp_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_2_gcnt = fp_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_3_lcnt = fp_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_bp_entries_3_gcnt = fp_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fetcher_io_pr_fp_ptr = fp_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fp_clock = clock;
  assign fp_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 48:28]
  assign fp_io_pr_iaddr_en = fetcher_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fp_io_pr_iaddr = fetcher_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fp_io_pr_flush_en = fetcher_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fp_io_pr_redirect_en = fetcher_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 93:12]
  assign fp_io_cr_en = reg_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 59:36]
  assign fp_io_cr_pc = reg_cr_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 60:36]
  assign fp_io_cr_bp_entry_lcnt = reg_cr_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 61:36]
  assign fp_io_cr_bp_entry_gcnt = reg_cr_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 61:36]
  assign fp_io_cr_fp_entry_attr = reg_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 62:36]
  assign fp_io_cr_fp_entry_is_ret = reg_cr_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 62:36]
  assign fp_io_cr_fp_entry_history = reg_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 62:36]
  assign fp_io_cr_fp_entry_ras_index = reg_cr_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 62:36]
  assign fp_io_cr_fp_hit = reg_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 63:36]
  assign fp_io_cr_mispred = reg_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 64:36]
  assign fp_io_cr_br_taken = reg_cr_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 65:36]
  assign fp_io_cr_attr = reg_cr_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 66:36]
  assign fp_io_cr_is_ret = reg_cr_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 67:36]
  assign fp_io_cr_target = reg_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 68:36]
  assign fp_io_cr_next_pc = reg_cr_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 69:36]
  assign fp_io_re_ptr = rb_io_enq_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign fp_io_re_ready = rb_io_enq_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign fp_io_re_left1 = rb_io_enq_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign fp_io_zbtb_lu_matches_0 = reg_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 72:36]
  assign fp_io_zbtb_lu_matches_1 = reg_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 72:36]
  assign fp_io_zbtb_lu_matches_2 = reg_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 72:36]
  assign fp_io_zbtb_lu_matches_3 = reg_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 72:36]
  assign fp_io_zbtb_lu_target_0 = reg_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 73:36]
  assign fp_io_zbtb_lu_target_1 = reg_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 73:36]
  assign fp_io_zbtb_lu_target_2 = reg_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 73:36]
  assign fp_io_zbtb_lu_target_3 = reg_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 73:36]
  assign fp_io_btb_lu_result_0_jump = reg_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_0_br = reg_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_0_attr = reg_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_0_is_ret = reg_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_0_target = reg_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_1_jump = reg_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_1_br = reg_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_1_attr = reg_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_1_is_ret = reg_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_1_target = reg_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_2_jump = reg_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_2_br = reg_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_2_attr = reg_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_2_is_ret = reg_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_2_target = reg_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_3_jump = reg_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_3_br = reg_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_3_attr = reg_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_3_is_ret = reg_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_btb_lu_result_3_target = reg_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  assign fp_io_pht__lu_taken_0 = reg_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_pht__lu_taken_1 = reg_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_pht__lu_taken_2 = reg_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_pht__lu_taken_3 = reg_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_pht__lu_lcnt_0 = reg_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_pht__lu_lcnt_1 = reg_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_pht__lu_lcnt_2 = reg_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_pht__lu_lcnt_3 = reg_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_pht__lu_gcnt_0 = reg_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_pht__lu_gcnt_1 = reg_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_pht__lu_gcnt_2 = reg_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_pht__lu_gcnt_3 = reg_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_pht__lmem_ren = reg_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 78:36]
  assign fp_io_pht__lmem_wen = reg_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 79:36]
  assign fp_io_pht__lmem_raddr = reg_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 80:36]
  assign fp_io_pht__lmem_waddr = reg_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 81:36]
  assign fp_io_pht__lmem_wdata = reg_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 82:36]
  assign fp_io_pht__gmem_ren = reg_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 83:36]
  assign fp_io_pht__gmem_wen = reg_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 84:36]
  assign fp_io_pht__gmem_raddr = reg_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 85:36]
  assign fp_io_pht__gmem_waddr = reg_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 86:36]
  assign fp_io_pht__gmem_wdata = reg_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 87:36]
  assign fp_io_pht__history = reg_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 88:36]
  assign fp_io_ras_top_ret_pc = reg_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 89:36]
  assign fp_io_ras_top_index = reg_ras_top_index; // @[src/main/scala/fpga/sim/FetchSim.scala 89:36]
  assign fp_io_pht_lmem_rdata = reg_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 90:36]
  assign fp_io_pht_gmem_rdata = reg_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 91:36]
  assign rb_clock = clock;
  assign rb_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 49:28]
  assign rb_io_enq_en = fp_io_re_en; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign rb_io_enq_flush_en = fp_io_re_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign rb_io_enq_history = fp_io_re_history; // @[src/main/scala/fpga/sim/FetchSim.scala 94:12]
  assign rb_io_upd_en = fp_io_ru_en; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_upd_ptr = fp_io_ru_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_upd_attr = fp_io_ru_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_upd_is_ret = fp_io_ru_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_upd_ras_index = fp_io_ru_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_upd_target = fp_io_ru_target; // @[src/main/scala/fpga/sim/FetchSim.scala 95:12]
  assign rb_io_deq_en = reg_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 70:36]
  assign rb_io_read_ptr = reg_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 71:36]
  always @(posedge clock) begin
    reg_ft_flush_en <= io_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_flush_iaddr <= io_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_inst1_ready <= io_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_inst2_ready <= io_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_imem_inst <= io_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_imem_valid <= io_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_icache_addr_ready <= io_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_icache_idata <= io_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_ft_icache_idata_valid <= io_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 98:18]
    reg_cr_en <= io_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_pc <= io_cr_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_bp_entry_lcnt <= io_cr_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_bp_entry_gcnt <= io_cr_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_fp_entry_attr <= io_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_fp_entry_is_ret <= io_cr_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_fp_entry_history <= io_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_fp_entry_ras_index <= io_cr_fp_entry_ras_index; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_fp_hit <= io_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_mispred <= io_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_br_taken <= io_cr_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_attr <= io_cr_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_is_ret <= io_cr_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_target <= io_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_cr_next_pc <= io_cr_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 99:18]
    reg_redir_deq_en <= io_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 100:18]
    reg_redir_read_ptr <= io_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_zbtb_lu_matches_0 <= io_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_matches_1 <= io_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_matches_2 <= io_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_matches_3 <= io_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_target_0 <= io_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_target_1 <= io_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_target_2 <= io_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_zbtb_lu_target_3 <= io_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_btb_lu_result_0_jump <= io_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_0_br <= io_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_0_attr <= io_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_0_is_ret <= io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_0_target <= io_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_1_jump <= io_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_1_br <= io_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_1_attr <= io_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_1_is_ret <= io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_1_target <= io_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_2_jump <= io_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_2_br <= io_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_2_attr <= io_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_2_is_ret <= io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_2_target <= io_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_3_jump <= io_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_3_br <= io_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_3_attr <= io_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_3_is_ret <= io_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_btb_lu_result_3_target <= io_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_pht__lu_taken_0 <= io_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_taken_1 <= io_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_taken_2 <= io_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_taken_3 <= io_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_lcnt_0 <= io_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_lcnt_1 <= io_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_lcnt_2 <= io_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_lcnt_3 <= io_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_gcnt_0 <= io_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_gcnt_1 <= io_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_gcnt_2 <= io_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lu_gcnt_3 <= io_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lmem_ren <= io_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lmem_wen <= io_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lmem_raddr <= io_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lmem_waddr <= io_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__lmem_wdata <= io_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__gmem_ren <= io_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__gmem_wen <= io_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__gmem_raddr <= io_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__gmem_waddr <= io_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__gmem_wdata <= io_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_pht__history <= io_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_ras_top_ret_pc <= io_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_ras_top_index <= io_ras_top_index; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_pht_lmem_rdata <= io_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_pht_gmem_rdata <= io_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_reset <= reset; // @[src/main/scala/fpga/sim/FetchSim.scala 41:{31,31} 97:18]
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
  reg_ft_flush_en = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  reg_ft_flush_iaddr = _RAND_1[30:0];
  _RAND_2 = {1{`RANDOM}};
  reg_ft_inst1_ready = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  reg_ft_inst2_ready = _RAND_3[0:0];
  _RAND_4 = {2{`RANDOM}};
  reg_ft_imem_inst = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  reg_ft_imem_valid = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  reg_ft_icache_addr_ready = _RAND_6[0:0];
  _RAND_7 = {2{`RANDOM}};
  reg_ft_icache_idata = _RAND_7[63:0];
  _RAND_8 = {1{`RANDOM}};
  reg_ft_icache_idata_valid = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  reg_cr_en = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  reg_cr_pc = _RAND_10[30:0];
  _RAND_11 = {1{`RANDOM}};
  reg_cr_bp_entry_lcnt = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  reg_cr_bp_entry_gcnt = _RAND_12[1:0];
  _RAND_13 = {1{`RANDOM}};
  reg_cr_fp_entry_attr = _RAND_13[1:0];
  _RAND_14 = {1{`RANDOM}};
  reg_cr_fp_entry_is_ret = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  reg_cr_fp_entry_history = _RAND_15[5:0];
  _RAND_16 = {1{`RANDOM}};
  reg_cr_fp_entry_ras_index = _RAND_16[2:0];
  _RAND_17 = {1{`RANDOM}};
  reg_cr_fp_hit = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  reg_cr_mispred = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  reg_cr_br_taken = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  reg_cr_attr = _RAND_20[1:0];
  _RAND_21 = {1{`RANDOM}};
  reg_cr_is_ret = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  reg_cr_target = _RAND_22[30:0];
  _RAND_23 = {1{`RANDOM}};
  reg_cr_next_pc = _RAND_23[30:0];
  _RAND_24 = {1{`RANDOM}};
  reg_redir_deq_en = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  reg_redir_read_ptr = _RAND_25[1:0];
  _RAND_26 = {1{`RANDOM}};
  reg_zbtb_lu_matches_0 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  reg_zbtb_lu_matches_1 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  reg_zbtb_lu_matches_2 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  reg_zbtb_lu_matches_3 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  reg_zbtb_lu_target_0 = _RAND_30[30:0];
  _RAND_31 = {1{`RANDOM}};
  reg_zbtb_lu_target_1 = _RAND_31[30:0];
  _RAND_32 = {1{`RANDOM}};
  reg_zbtb_lu_target_2 = _RAND_32[30:0];
  _RAND_33 = {1{`RANDOM}};
  reg_zbtb_lu_target_3 = _RAND_33[30:0];
  _RAND_34 = {1{`RANDOM}};
  reg_btb_lu_result_0_jump = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  reg_btb_lu_result_0_br = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  reg_btb_lu_result_0_attr = _RAND_36[1:0];
  _RAND_37 = {1{`RANDOM}};
  reg_btb_lu_result_0_is_ret = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  reg_btb_lu_result_0_target = _RAND_38[30:0];
  _RAND_39 = {1{`RANDOM}};
  reg_btb_lu_result_1_jump = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  reg_btb_lu_result_1_br = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  reg_btb_lu_result_1_attr = _RAND_41[1:0];
  _RAND_42 = {1{`RANDOM}};
  reg_btb_lu_result_1_is_ret = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  reg_btb_lu_result_1_target = _RAND_43[30:0];
  _RAND_44 = {1{`RANDOM}};
  reg_btb_lu_result_2_jump = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  reg_btb_lu_result_2_br = _RAND_45[0:0];
  _RAND_46 = {1{`RANDOM}};
  reg_btb_lu_result_2_attr = _RAND_46[1:0];
  _RAND_47 = {1{`RANDOM}};
  reg_btb_lu_result_2_is_ret = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  reg_btb_lu_result_2_target = _RAND_48[30:0];
  _RAND_49 = {1{`RANDOM}};
  reg_btb_lu_result_3_jump = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  reg_btb_lu_result_3_br = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  reg_btb_lu_result_3_attr = _RAND_51[1:0];
  _RAND_52 = {1{`RANDOM}};
  reg_btb_lu_result_3_is_ret = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  reg_btb_lu_result_3_target = _RAND_53[30:0];
  _RAND_54 = {1{`RANDOM}};
  reg_pht__lu_taken_0 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  reg_pht__lu_taken_1 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  reg_pht__lu_taken_2 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  reg_pht__lu_taken_3 = _RAND_57[0:0];
  _RAND_58 = {1{`RANDOM}};
  reg_pht__lu_lcnt_0 = _RAND_58[1:0];
  _RAND_59 = {1{`RANDOM}};
  reg_pht__lu_lcnt_1 = _RAND_59[1:0];
  _RAND_60 = {1{`RANDOM}};
  reg_pht__lu_lcnt_2 = _RAND_60[1:0];
  _RAND_61 = {1{`RANDOM}};
  reg_pht__lu_lcnt_3 = _RAND_61[1:0];
  _RAND_62 = {1{`RANDOM}};
  reg_pht__lu_gcnt_0 = _RAND_62[1:0];
  _RAND_63 = {1{`RANDOM}};
  reg_pht__lu_gcnt_1 = _RAND_63[1:0];
  _RAND_64 = {1{`RANDOM}};
  reg_pht__lu_gcnt_2 = _RAND_64[1:0];
  _RAND_65 = {1{`RANDOM}};
  reg_pht__lu_gcnt_3 = _RAND_65[1:0];
  _RAND_66 = {1{`RANDOM}};
  reg_pht__lmem_ren = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  reg_pht__lmem_wen = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  reg_pht__lmem_raddr = _RAND_68[10:0];
  _RAND_69 = {1{`RANDOM}};
  reg_pht__lmem_waddr = _RAND_69[12:0];
  _RAND_70 = {1{`RANDOM}};
  reg_pht__lmem_wdata = _RAND_70[1:0];
  _RAND_71 = {1{`RANDOM}};
  reg_pht__gmem_ren = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  reg_pht__gmem_wen = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  reg_pht__gmem_raddr = _RAND_73[10:0];
  _RAND_74 = {1{`RANDOM}};
  reg_pht__gmem_waddr = _RAND_74[12:0];
  _RAND_75 = {1{`RANDOM}};
  reg_pht__gmem_wdata = _RAND_75[1:0];
  _RAND_76 = {1{`RANDOM}};
  reg_pht__history = _RAND_76[5:0];
  _RAND_77 = {1{`RANDOM}};
  reg_ras_top_ret_pc = _RAND_77[30:0];
  _RAND_78 = {1{`RANDOM}};
  reg_ras_top_index = _RAND_78[2:0];
  _RAND_79 = {1{`RANDOM}};
  reg_pht_lmem_rdata = _RAND_79[7:0];
  _RAND_80 = {1{`RANDOM}};
  reg_pht_gmem_rdata = _RAND_80[7:0];
  _RAND_81 = {1{`RANDOM}};
  reg_reset = _RAND_81[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
