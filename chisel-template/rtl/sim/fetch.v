module Fetcher(
  input         clock,
  input         reset,
  input         io_ft_flush_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [30:0] io_ft_flush_iaddr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_inst1_valid, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [30:0] io_ft_inst1_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [31:0] io_ft_inst1_data, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_inst1_bpfailed, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_inst1_redirected, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst1_bp_entry_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst1_bp_entry_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst1_fp_ptr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_ft_inst1_ready, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_inst2_valid, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [30:0] io_ft_inst2_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [31:0] io_ft_inst2_data, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_inst2_redirected, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst2_bp_entry_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst2_bp_entry_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [1:0]  io_ft_inst2_fp_ptr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_ft_inst2_ready, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_imem_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [31:0] io_ft_imem_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [63:0] io_ft_imem_inst, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_ft_imem_valid, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_ft_icache_addr_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [31:0] io_ft_icache_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_ft_icache_addr_ready, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [63:0] io_ft_icache_idata, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_ft_icache_idata_valid, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_iaddr_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output [30:0] io_pr_iaddr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_flush_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_invalidate, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_redirect_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_correct_enq, // @[src/main/scala/fpga/Fetch.scala 94:14]
  output        io_pr_target_changed, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_pr_redirect_ready, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_pr_bp0_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp0_pos, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [30:0] io_pr_bp0_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input         io_pr_bp1_en, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp1_pos, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [30:0] io_pr_bp1_addr, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_0_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_0_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_1_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_1_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_2_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_2_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_3_lcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [1:0]  io_pr_bp_entries_3_gcnt, // @[src/main/scala/fpga/Fetch.scala 94:14]
  input  [2:0]  io_pr_fp_ptr // @[src/main/scala/fpga/Fetch.scala 94:14]
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
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
`endif // RANDOMIZE_REG_INIT
  reg [30:0] fetch_buf_iaddr [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [30:0] fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iaddr_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iaddr_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [63:0] fetch_buf_idata [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [63:0] fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_idata_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_idata_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg  fetch_buf_iblock_cont [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_iblock_cont_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_iblock_cont_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_end_of_iblock [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_end_of_iblock_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_end_of_iblock_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_0_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_0_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_0_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_0_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_1_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_1_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_1_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_1_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_2_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_2_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_2_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_2_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_3_lcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_lcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_lcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_bp_entries_3_gcnt [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_bp_entries_3_gcnt_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_bp_entries_3_gcnt_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [1:0] fetch_buf_fp_ptr [0:3]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_3_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_3_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_3_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_4_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_4_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_4_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_5_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_5_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_5_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_6_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_6_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_6_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_12_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_12_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_12_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_end_of_iblocks_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_iblock_cont_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iblock_cont_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_iaddrs_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_iaddrs_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_iaddrs_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_idata0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_idata0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_idata0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_idata1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_idata1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_idata1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_bpe0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_bpe0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_bpe1_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_bpe1_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_reg_i0_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_reg_i0_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_reg_i0_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_1_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_1_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_1_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_2_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_2_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_2_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_7_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_7_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_7_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_8_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_8_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_8_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_9_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_9_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_9_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_10_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_10_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_10_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire [1:0] fetch_buf_fp_ptr_MPORT_11_addr; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_11_mask; // @[src/main/scala/fpga/Fetch.scala 108:22]
  wire  fetch_buf_fp_ptr_MPORT_11_en; // @[src/main/scala/fpga/Fetch.scala 108:22]
  reg [2:0] addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 109:31]
  reg [2:0] fetch_ptr; // @[src/main/scala/fpga/Fetch.scala 110:31]
  reg [2:0] read_ptr; // @[src/main/scala/fpga/Fetch.scala 111:31]
  reg  discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_1; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_2; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_3; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_4; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_5; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_6; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg  discard_buf_7; // @[src/main/scala/fpga/Fetch.scala 113:28]
  reg [2:0] discard_enq; // @[src/main/scala/fpga/Fetch.scala 114:28]
  reg [2:0] discard_deq; // @[src/main/scala/fpga/Fetch.scala 115:28]
  reg  reg_addressed; // @[src/main/scala/fpga/Fetch.scala 125:30]
  reg [30:0] reg_next_iaddr; // @[src/main/scala/fpga/Fetch.scala 128:41]
  reg  reg_fix_zbp_miss1; // @[src/main/scala/fpga/Fetch.scala 132:41]
  reg  reg_fix_zbp_miss2; // @[src/main/scala/fpga/Fetch.scala 133:41]
  reg  reg_bp1_redirect_en; // @[src/main/scala/fpga/Fetch.scala 134:41]
  reg  reg_bp1_target_changed; // @[src/main/scala/fpga/Fetch.scala 135:41]
  reg [30:0] reg_fix_addr; // @[src/main/scala/fpga/Fetch.scala 136:41]
  reg [2:0] reg_discard_enq; // @[src/main/scala/fpga/Fetch.scala 137:41]
  reg  reg_is_dram; // @[src/main/scala/fpga/Fetch.scala 138:41]
  wire  _invalidate_T = reg_fix_zbp_miss1 | reg_fix_zbp_miss2; // @[src/main/scala/fpga/Fetch.scala 142:48]
  wire  invalidate = (reg_fix_zbp_miss1 | reg_fix_zbp_miss2) & reg_addressed; // @[src/main/scala/fpga/Fetch.scala 142:70]
  wire  _bp1_redirect_en_T = ~invalidate; // @[src/main/scala/fpga/Fetch.scala 145:7]
  wire  _bp1_redirect_en_T_2 = ~io_pr_bp0_en & io_pr_bp1_en; // @[src/main/scala/fpga/Fetch.scala 146:24]
  wire  bp1_redirect_en = ~invalidate & _bp1_redirect_en_T_2; // @[src/main/scala/fpga/Fetch.scala 145:19]
  wire  _bp1_cancel_redir_T_2 = io_pr_bp0_en & ~io_pr_bp1_en; // @[src/main/scala/fpga/Fetch.scala 150:23]
  wire  bp1_cancel_redir = _bp1_redirect_en_T & _bp1_cancel_redir_T_2; // @[src/main/scala/fpga/Fetch.scala 149:19]
  wire  _bp1_target_changed_T_7 = io_pr_bp0_en & io_pr_bp1_en & (io_pr_bp0_addr[7:0] != io_pr_bp1_addr[7:0] |
    io_pr_bp0_pos != io_pr_bp1_pos); // @[src/main/scala/fpga/Fetch.scala 154:39]
  wire  bp1_target_changed = _bp1_redirect_en_T & _bp1_target_changed_T_7; // @[src/main/scala/fpga/Fetch.scala 153:19]
  wire  zbp_miss1 = bp1_redirect_en | bp1_cancel_redir; // @[src/main/scala/fpga/Fetch.scala 156:37]
  wire [30:0] _iaddr_T_1 = io_pr_bp0_en ? io_pr_bp0_addr : reg_next_iaddr; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] _iaddr_T_2 = _invalidate_T ? reg_fix_addr : _iaddr_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] iaddr = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_2; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] _reg_next_iaddr_T_1 = {iaddr[30:2],2'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  wire [30:0] _reg_next_iaddr_T_3 = _reg_next_iaddr_T_1 + 31'h4; // @[src/main/scala/fpga/Fetch.scala 163:58]
  wire  _fix_zbp_miss1_T = ~io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 164:22]
  wire  fix_zbp_miss1 = ~io_ft_flush_en & zbp_miss1; // @[src/main/scala/fpga/Fetch.scala 164:38]
  wire  fix_zbp_miss2 = _fix_zbp_miss1_T & bp1_target_changed; // @[src/main/scala/fpga/Fetch.scala 165:38]
  wire [2:0] count = addressing_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 173:32]
  wire  has_space = ~count[2]; // @[src/main/scala/fpga/Fetch.scala 174:22]
  wire [31:0] _is_dram_T = {iaddr,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  is_dram = _is_dram_T[31:28] == 4'h2; // @[src/main/scala/fpga/Fetch.scala 13:68]
  wire  redirect_ready = ~(_invalidate_T | io_pr_bp0_en) | io_pr_redirect_ready; // @[src/main/scala/fpga/Fetch.scala 178:84]
  wire  _T_1 = invalidate & _fix_zbp_miss1_T; // @[src/main/scala/fpga/Fetch.scala 180:22]
  wire [2:0] _addressing_ptr_T_1 = addressing_ptr - 3'h1; // @[src/main/scala/fpga/Fetch.scala 181:40]
  wire  _T_2 = ~is_dram; // @[src/main/scala/fpga/Fetch.scala 183:26]
  wire  wait_for_dram = reg_is_dram & ~is_dram & discard_enq != discard_deq; // @[src/main/scala/fpga/Fetch.scala 183:35]
  wire  _GEN_2 = wait_for_dram | is_dram; // @[src/main/scala/fpga/Fetch.scala 177:17 183:67 185:19]
  wire  _io_ft_imem_en_T = has_space & redirect_ready; // @[src/main/scala/fpga/Fetch.scala 189:41]
  wire  _io_ft_imem_en_T_1 = has_space & redirect_ready | io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 189:60]
  wire  _T_13 = ~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready; // @[src/main/scala/fpga/Fetch.scala 198:80]
  wire [2:0] _discard_enq_T_1 = discard_enq + 3'h1; // @[src/main/scala/fpga/Fetch.scala 205:38]
  wire [2:0] _addressing_ptr_T_3 = addressing_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 209:42]
  wire  _T_18 = ~reset; // @[src/main/scala/fpga/Fetch.scala 212:13]
  wire [1:0] _T_21 = addressing_ptr[1:0] - 2'h1; // @[src/main/scala/fpga/Fetch.scala 216:52]
  wire  _GEN_13 = io_ft_flush_en | discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_14 = io_ft_flush_en | discard_buf_1; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_15 = io_ft_flush_en | discard_buf_2; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_16 = io_ft_flush_en | discard_buf_3; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_17 = io_ft_flush_en | discard_buf_4; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_18 = io_ft_flush_en | discard_buf_5; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_19 = io_ft_flush_en | discard_buf_6; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire  _GEN_20 = io_ft_flush_en | discard_buf_7; // @[src/main/scala/fpga/Fetch.scala 215:27 218:24 113:28]
  wire [1:0] ptr = _T_1 ? _addressing_ptr_T_1[1:0] : addressing_ptr[1:0]; // @[src/main/scala/fpga/Fetch.scala 222:18]
  wire [1:0] forward_i0 = iaddr[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _discard_buf_T = invalidate | io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 236:50]
  wire  _GEN_27 = 3'h0 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_13; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_28 = 3'h1 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_14; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_29 = 3'h2 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_15; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_30 = 3'h3 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_16; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_31 = 3'h4 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_17; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_32 = 3'h5 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_18; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_33 = 3'h6 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_19; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_34 = 3'h7 == reg_discard_enq ? invalidate | io_ft_flush_en : _GEN_20; // @[src/main/scala/fpga/Fetch.scala 236:{36,36}]
  wire  _GEN_35 = reg_addressed ? _GEN_27 : _GEN_13; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_36 = reg_addressed ? _GEN_28 : _GEN_14; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_37 = reg_addressed ? _GEN_29 : _GEN_15; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_38 = reg_addressed ? _GEN_30 : _GEN_16; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_39 = reg_addressed ? _GEN_31 : _GEN_17; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_40 = reg_addressed ? _GEN_32 : _GEN_18; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_41 = reg_addressed ? _GEN_33 : _GEN_19; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire  _GEN_42 = reg_addressed ? _GEN_34 : _GEN_20; // @[src/main/scala/fpga/Fetch.scala 235:26]
  wire [63:0] idata = io_ft_imem_valid ? io_ft_imem_inst : io_ft_icache_idata; // @[src/main/scala/fpga/Fetch.scala 264:20]
  wire  _discard_T_1 = reg_addressed & reg_discard_enq == discard_deq; // @[src/main/scala/fpga/Fetch.scala 271:26]
  wire  _GEN_51 = 3'h1 == discard_deq ? discard_buf_1 : discard_buf_0; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_52 = 3'h2 == discard_deq ? discard_buf_2 : _GEN_51; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_53 = 3'h3 == discard_deq ? discard_buf_3 : _GEN_52; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_54 = 3'h4 == discard_deq ? discard_buf_4 : _GEN_53; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_55 = 3'h5 == discard_deq ? discard_buf_5 : _GEN_54; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_56 = 3'h6 == discard_deq ? discard_buf_6 : _GEN_55; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  _GEN_57 = 3'h7 == discard_deq ? discard_buf_7 : _GEN_56; // @[src/main/scala/fpga/Fetch.scala 270:{22,22}]
  wire  discard = _discard_T_1 ? _discard_buf_T : _GEN_57; // @[src/main/scala/fpga/Fetch.scala 270:22]
  wire  _T_70 = ~discard; // @[src/main/scala/fpga/Fetch.scala 277:29]
  wire  _T_71 = io_pr_bp1_en & ~discard; // @[src/main/scala/fpga/Fetch.scala 277:26]
  wire [1:0] _T_72 = io_pr_bp1_en ? io_pr_bp1_pos : 2'h3; // @[src/main/scala/fpga/Fetch.scala 280:45]
  wire  _T_78 = io_ft_imem_valid | io_ft_icache_idata_valid; // @[src/main/scala/fpga/Fetch.scala 287:28]
  wire [2:0] _discard_deq_T_1 = discard_deq + 3'h1; // @[src/main/scala/fpga/Fetch.scala 288:34]
  wire [2:0] _fetch_ptr_T_1 = fetch_ptr + 3'h1; // @[src/main/scala/fpga/Fetch.scala 290:32]
  wire [31:0] _T_83 = {fetch_buf_iaddr_MPORT_12_data,1'h0}; // @[src/main/scala/fpga/Fetch.scala 294:21]
  wire  _GEN_90 = (io_ft_imem_valid | io_ft_icache_idata_valid) & _T_70; // @[src/main/scala/fpga/Fetch.scala 108:22 287:57]
  reg [1:0] reg_i0; // @[src/main/scala/fpga/Fetch.scala 305:25]
  reg  reg_reset_i0; // @[src/main/scala/fpga/Fetch.scala 306:31]
  wire [2:0] count_1 = fetch_ptr - read_ptr; // @[src/main/scala/fpga/Fetch.scala 308:27]
  wire [1:0] sat_count = count_1 < 3'h2 ? count_1[1:0] : 2'h2; // @[src/main/scala/fpga/Fetch.scala 309:24]
  wire [2:0] _end_of_iblocks_T_1 = {{1'd0}, read_ptr[1:0]}; // @[src/main/scala/fpga/Fetch.scala 311:86]
  wire [2:0] _end_of_iblock_T = {1'h1,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data}; // @[src/main/scala/fpga/Fetch.scala 313:51]
  wire [2:0] _end_of_iblock_T_1 = {1'h0,fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 313:82]
  wire [2:0] end_of_iblock = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? _end_of_iblock_T : _end_of_iblock_T_1; // @[src/main/scala/fpga/Fetch.scala 313:28]
  wire [111:0] _idatas_T_1 = {fetch_buf_idata_idata1_MPORT_data[47:0],fetch_buf_idata_idata0_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 317:61]
  wire [15:0] idatas_0 = _idatas_T_1[15:0]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_1 = _idatas_T_1[31:16]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_2 = _idatas_T_1[47:32]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_3 = _idatas_T_1[63:48]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_4 = _idatas_T_1[79:64]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_5 = _idatas_T_1[95:80]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire [15:0] idatas_6 = _idatas_T_1[111:96]; // @[src/main/scala/common/UIntExtension.scala 16:100]
  wire  is_halfs_0 = idatas_0[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire  is_halfs_1 = idatas_1[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire  is_halfs_2 = idatas_2[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire  is_halfs_3 = idatas_3[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire  is_halfs_4 = idatas_4[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire  is_halfs_5 = idatas_5[1:0] != 2'h3; // @[src/main/scala/fpga/Fetch.scala 318:62]
  wire [3:0] _redir_oh_T = 4'h1 << fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data; // @[src/main/scala/chisel3/util/OneHot.scala 58:35]
  wire [3:0] _redir_oh_T_1 = 4'h1 << fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data; // @[src/main/scala/chisel3/util/OneHot.scala 58:35]
  wire [3:0] _redir_oh_T_2 = fetch_buf_iblock_cont_iblock_cont_MPORT_data ? 4'h0 : _redir_oh_T_1; // @[src/main/scala/fpga/Fetch.scala 323:54]
  wire [7:0] redir_oh = {_redir_oh_T,_redir_oh_T_2}; // @[src/main/scala/fpga/Fetch.scala 323:48]
  wire [2:0] i0 = {1'h0,reg_i0}; // @[src/main/scala/fpga/Fetch.scala 325:23]
  wire [2:0] i1 = i0 + 3'h1; // @[src/main/scala/fpga/Fetch.scala 326:17]
  wire [2:0] i2 = i0 + 3'h2; // @[src/main/scala/fpga/Fetch.scala 327:17]
  wire [2:0] i3 = i0 + 3'h3; // @[src/main/scala/fpga/Fetch.scala 328:17]
  wire  _GEN_93 = 3'h1 == i0 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 330:{25,25}]
  wire  _GEN_94 = 3'h2 == i0 ? is_halfs_2 : _GEN_93; // @[src/main/scala/fpga/Fetch.scala 330:{25,25}]
  wire  _GEN_95 = 3'h3 == i0 ? is_halfs_3 : _GEN_94; // @[src/main/scala/fpga/Fetch.scala 330:{25,25}]
  wire  _GEN_96 = 3'h4 == i0 ? is_halfs_4 : _GEN_95; // @[src/main/scala/fpga/Fetch.scala 330:{25,25}]
  wire  _GEN_97 = 3'h5 == i0 ? is_halfs_5 : _GEN_96; // @[src/main/scala/fpga/Fetch.scala 330:{25,25}]
  wire [2:0] inst1_past = _GEN_97 ? i1 : i2; // @[src/main/scala/fpga/Fetch.scala 330:25]
  wire [2:0] inst1_end = _GEN_97 ? i0 : i1; // @[src/main/scala/fpga/Fetch.scala 331:25]
  wire  _GEN_99 = 3'h1 == i1 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_100 = 3'h2 == i1 ? is_halfs_2 : _GEN_99; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_101 = 3'h3 == i1 ? is_halfs_3 : _GEN_100; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_102 = 3'h4 == i1 ? is_halfs_4 : _GEN_101; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_103 = 3'h5 == i1 ? is_halfs_5 : _GEN_102; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_105 = 3'h1 == i2 ? is_halfs_1 : is_halfs_0; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_106 = 3'h2 == i2 ? is_halfs_2 : _GEN_105; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_107 = 3'h3 == i2 ? is_halfs_3 : _GEN_106; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_108 = 3'h4 == i2 ? is_halfs_4 : _GEN_107; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  _GEN_109 = 3'h5 == i2 ? is_halfs_5 : _GEN_108; // @[src/main/scala/fpga/Fetch.scala 332:{25,25}]
  wire  inst2_half = _GEN_97 ? _GEN_103 : _GEN_109; // @[src/main/scala/fpga/Fetch.scala 332:25]
  wire [1:0] _inst2_past_T = inst2_half ? 2'h1 : 2'h2; // @[src/main/scala/fpga/Fetch.scala 333:38]
  wire [2:0] _GEN_180 = {{1'd0}, _inst2_past_T}; // @[src/main/scala/fpga/Fetch.scala 333:33]
  wire [2:0] inst2_past = inst1_past + _GEN_180; // @[src/main/scala/fpga/Fetch.scala 333:33]
  wire [2:0] _inst2_end_T = _GEN_103 ? i1 : i2; // @[src/main/scala/fpga/Fetch.scala 335:10]
  wire [2:0] _inst2_end_T_1 = _GEN_109 ? i2 : i3; // @[src/main/scala/fpga/Fetch.scala 336:10]
  wire [2:0] inst2_end = _GEN_97 ? _inst2_end_T : _inst2_end_T_1; // @[src/main/scala/fpga/Fetch.scala 334:24]
  wire  _inst1_valid_T = inst1_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 338:41]
  wire  _inst1_valid_T_2 = io_ft_flush_en | sat_count == 2'h0; // @[src/main/scala/fpga/Fetch.scala 339:23]
  wire  _inst1_valid_T_3 = sat_count == 2'h1; // @[src/main/scala/fpga/Fetch.scala 340:18]
  wire [2:0] _GEN_181 = {{1'd0}, fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data}; // @[src/main/scala/fpga/Fetch.scala 340:59]
  wire  _inst1_valid_T_4 = inst1_end <= _GEN_181; // @[src/main/scala/fpga/Fetch.scala 340:59]
  wire  _inst1_valid_T_5 = _inst1_valid_T_3 ? _inst1_valid_T_4 : _inst1_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst1_valid = _inst1_valid_T_2 ? 1'h0 : _inst1_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _inst2_valid_T = inst2_end <= end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 342:41]
  wire  _inst2_valid_T_4 = inst2_end <= _GEN_181; // @[src/main/scala/fpga/Fetch.scala 344:59]
  wire  _inst2_valid_T_5 = _inst1_valid_T_3 ? _inst2_valid_T_4 : _inst2_valid_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [30:0] iaddr0 = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],reg_i0}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire  inst1_bpfailed = _fix_zbp_miss1_T & sat_count != 2'h0 & ~_GEN_97 & end_of_iblock == i0; // @[src/main/scala/fpga/Fetch.scala 347:78]
  wire [15:0] _GEN_111 = 3'h1 == i1 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_112 = 3'h2 == i1 ? idatas_2 : _GEN_111; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_113 = 3'h3 == i1 ? idatas_3 : _GEN_112; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_114 = 3'h4 == i1 ? idatas_4 : _GEN_113; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_115 = 3'h5 == i1 ? idatas_5 : _GEN_114; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_116 = 3'h6 == i1 ? idatas_6 : _GEN_115; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_118 = 3'h1 == i0 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_119 = 3'h2 == i0 ? idatas_2 : _GEN_118; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_120 = 3'h3 == i0 ? idatas_3 : _GEN_119; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_121 = 3'h4 == i0 ? idatas_4 : _GEN_120; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_122 = 3'h5 == i0 ? idatas_5 : _GEN_121; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [15:0] _GEN_123 = 3'h6 == i0 ? idatas_6 : _GEN_122; // @[src/main/scala/fpga/Fetch.scala 349:{42,42}]
  wire [7:0] _io_ft_inst1_redirected_T = redir_oh >> inst1_end; // @[src/main/scala/fpga/Fetch.scala 352:39]
  wire [1:0] bp_entries_0_lcnt = fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] bp_entries_1_lcnt = fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_125 = 3'h1 == inst1_end ? bp_entries_1_lcnt : bp_entries_0_lcnt; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_2_lcnt = fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_126 = 3'h2 == inst1_end ? bp_entries_2_lcnt : _GEN_125; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_3_lcnt = fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_127 = 3'h3 == inst1_end ? bp_entries_3_lcnt : _GEN_126; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_4_lcnt = fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_128 = 3'h4 == inst1_end ? bp_entries_4_lcnt : _GEN_127; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_5_lcnt = fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_129 = 3'h5 == inst1_end ? bp_entries_5_lcnt : _GEN_128; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_6_lcnt = fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] bp_entries_0_gcnt = fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] bp_entries_1_gcnt = fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_132 = 3'h1 == inst1_end ? bp_entries_1_gcnt : bp_entries_0_gcnt; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_2_gcnt = fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_133 = 3'h2 == inst1_end ? bp_entries_2_gcnt : _GEN_132; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_3_gcnt = fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_134 = 3'h3 == inst1_end ? bp_entries_3_gcnt : _GEN_133; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_4_gcnt = fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_135 = 3'h4 == inst1_end ? bp_entries_4_gcnt : _GEN_134; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_5_gcnt = fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [1:0] _GEN_136 = 3'h5 == inst1_end ? bp_entries_5_gcnt : _GEN_135; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  wire [1:0] bp_entries_6_gcnt = fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 321:{29,29}]
  wire [30:0] _io_ft_inst2_addr_T_1 = inst1_past[2] ? fetch_buf_iaddr_iaddrs_MPORT_1_data : iaddr0; // @[src/main/scala/fpga/Fetch.scala 356:34]
  wire [15:0] _GEN_139 = 3'h1 == i2 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [15:0] _GEN_140 = 3'h2 == i2 ? idatas_2 : _GEN_139; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [15:0] _GEN_141 = 3'h3 == i2 ? idatas_3 : _GEN_140; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [15:0] _GEN_142 = 3'h4 == i2 ? idatas_4 : _GEN_141; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [15:0] _GEN_143 = 3'h5 == i2 ? idatas_5 : _GEN_142; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [15:0] _GEN_144 = 3'h6 == i2 ? idatas_6 : _GEN_143; // @[src/main/scala/fpga/Fetch.scala 358:{60,60}]
  wire [31:0] _io_ft_inst2_data_T = {_GEN_144,_GEN_116}; // @[src/main/scala/fpga/Fetch.scala 358:60]
  wire [15:0] _GEN_146 = 3'h1 == i3 ? idatas_1 : idatas_0; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [15:0] _GEN_147 = 3'h2 == i3 ? idatas_2 : _GEN_146; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [15:0] _GEN_148 = 3'h3 == i3 ? idatas_3 : _GEN_147; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [15:0] _GEN_149 = 3'h4 == i3 ? idatas_4 : _GEN_148; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [15:0] _GEN_150 = 3'h5 == i3 ? idatas_5 : _GEN_149; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [15:0] _GEN_151 = 3'h6 == i3 ? idatas_6 : _GEN_150; // @[src/main/scala/fpga/Fetch.scala 358:{86,86}]
  wire [31:0] _io_ft_inst2_data_T_1 = {_GEN_151,_GEN_144}; // @[src/main/scala/fpga/Fetch.scala 358:86]
  wire [7:0] _io_ft_inst2_redirected_T = redir_oh >> inst2_end; // @[src/main/scala/fpga/Fetch.scala 361:39]
  wire [1:0] _GEN_153 = 3'h1 == inst2_end ? bp_entries_1_lcnt : bp_entries_0_lcnt; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_154 = 3'h2 == inst2_end ? bp_entries_2_lcnt : _GEN_153; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_155 = 3'h3 == inst2_end ? bp_entries_3_lcnt : _GEN_154; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_156 = 3'h4 == inst2_end ? bp_entries_4_lcnt : _GEN_155; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_157 = 3'h5 == inst2_end ? bp_entries_5_lcnt : _GEN_156; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_160 = 3'h1 == inst2_end ? bp_entries_1_gcnt : bp_entries_0_gcnt; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_161 = 3'h2 == inst2_end ? bp_entries_2_gcnt : _GEN_160; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_162 = 3'h3 == inst2_end ? bp_entries_3_gcnt : _GEN_161; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_163 = 3'h4 == inst2_end ? bp_entries_4_gcnt : _GEN_162; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire [1:0] _GEN_164 = 3'h5 == inst2_end ? bp_entries_5_gcnt : _GEN_163; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  wire  _inst_past_T = io_ft_inst2_ready & inst2_valid; // @[src/main/scala/fpga/Fetch.scala 366:49]
  wire  _inst_past_T_2 = (io_ft_inst1_ready | io_ft_inst2_ready) & inst1_valid; // @[src/main/scala/fpga/Fetch.scala 367:49]
  wire [2:0] _inst_past_T_3 = _inst_past_T_2 ? inst1_past : i0; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] inst_past = _inst_past_T ? inst2_past : _inst_past_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _next_read_ptr_T_2 = inst_past > end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 370:66]
  wire  _next_read_ptr_T_3 = inst1_valid & end_of_iblock[2] & inst_past > end_of_iblock; // @[src/main/scala/fpga/Fetch.scala 370:53]
  wire  _next_read_ptr_T_7 = inst1_valid & (inst_past[2] | _next_read_ptr_T_2); // @[src/main/scala/fpga/Fetch.scala 371:20]
  wire [1:0] _next_read_ptr_T_9 = _next_read_ptr_T_3 ? 2'h2 : {{1'd0}, _next_read_ptr_T_7}; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [2:0] _GEN_183 = {{1'd0}, _next_read_ptr_T_9}; // @[src/main/scala/fpga/Fetch.scala 369:34]
  wire [2:0] next_read_ptr = read_ptr + _GEN_183; // @[src/main/scala/fpga/Fetch.scala 369:34]
  wire  _T_87 = inst1_valid & _next_read_ptr_T_2; // @[src/main/scala/fpga/Fetch.scala 374:23]
  wire [1:0] ptr_1 = next_read_ptr[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _reg_i0_T_1 = _io_ft_imem_en_T_1 & ptr_1 == ptr; // @[src/main/scala/fpga/Fetch.scala 377:23]
  wire  _T_89 = ~inst1_valid & reg_reset_i0; // @[src/main/scala/fpga/Fetch.scala 382:30]
  wire [2:0] _GEN_184 = {{1'd0}, ptr}; // @[src/main/scala/fpga/Fetch.scala 384:36]
  wire  _reg_i0_T_5 = _io_ft_imem_en_T_1 & read_ptr == _GEN_184; // @[src/main/scala/fpga/Fetch.scala 384:23]
  wire [1:0] _reg_i0_T_8 = _reg_i0_T_5 ? forward_i0 : fetch_buf_iaddr_reg_i0_MPORT_1_data[1:0]; // @[src/main/scala/fpga/Fetch.scala 383:20]
  wire  _GEN_174 = inst1_valid & _next_read_ptr_T_2 | _T_89; // @[src/main/scala/fpga/Fetch.scala 374:53 381:20]
  wire [31:0] _T_92 = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],reg_i0,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire [31:0] _T_98 = {io_ft_inst2_addr,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign fetch_buf_iaddr_MPORT_3_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_3_addr = 2'h0;
  assign fetch_buf_iaddr_MPORT_3_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_MPORT_4_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_4_addr = 2'h1;
  assign fetch_buf_iaddr_MPORT_4_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_MPORT_5_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_5_addr = 2'h2;
  assign fetch_buf_iaddr_MPORT_5_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_MPORT_6_en = 1'h1;
  assign fetch_buf_iaddr_MPORT_6_addr = 2'h3;
  assign fetch_buf_iaddr_MPORT_6_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_iaddr_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_iaddr_MPORT_12_data = fetch_buf_iaddr[fetch_buf_iaddr_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_end_of_iblocks_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_iblock_cont_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iaddr_iaddrs_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_iaddrs_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_idata0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_idata1_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_bpe0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iaddr_bpe1_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_iaddr_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_fp_ptr_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_iaddr_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_iaddr_reg_i0_MPORT_data = fetch_buf_iaddr[fetch_buf_iaddr_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_iaddr_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_iaddr_reg_i0_MPORT_1_data = fetch_buf_iaddr[fetch_buf_iaddr_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iaddr_MPORT_data = 31'h0;
  assign fetch_buf_iaddr_MPORT_addr = addressing_ptr[1:0] - 2'h1;
  assign fetch_buf_iaddr_MPORT_mask = 1'h0;
  assign fetch_buf_iaddr_MPORT_en = io_ft_flush_en;
  assign fetch_buf_iaddr_MPORT_1_data = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_2;
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
  assign fetch_buf_iaddr_MPORT_8_en = reg_addressed & _T_71;
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
  assign fetch_buf_idata_MPORT_3_data = fetch_buf_idata[fetch_buf_idata_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_MPORT_4_en = 1'h1;
  assign fetch_buf_idata_MPORT_4_addr = 2'h1;
  assign fetch_buf_idata_MPORT_4_data = fetch_buf_idata[fetch_buf_idata_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_MPORT_5_en = 1'h1;
  assign fetch_buf_idata_MPORT_5_addr = 2'h2;
  assign fetch_buf_idata_MPORT_5_data = fetch_buf_idata[fetch_buf_idata_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_MPORT_6_en = 1'h1;
  assign fetch_buf_idata_MPORT_6_addr = 2'h3;
  assign fetch_buf_idata_MPORT_6_data = fetch_buf_idata[fetch_buf_idata_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_idata_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_idata_MPORT_12_data = fetch_buf_idata[fetch_buf_idata_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_end_of_iblocks_MPORT_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_end_of_iblocks_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_idata_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_iblock_cont_MPORT_data = fetch_buf_idata[fetch_buf_idata_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_idata_iaddrs_MPORT_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_iaddrs_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_idata0_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_idata0_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_idata1_MPORT_en = 1'h1;
  assign fetch_buf_idata_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_idata1_MPORT_data = fetch_buf_idata[fetch_buf_idata_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_idata_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_bpe0_MPORT_data = fetch_buf_idata[fetch_buf_idata_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_idata_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_idata_bpe1_MPORT_data = fetch_buf_idata[fetch_buf_idata_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_idata_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_idata_fp_ptr_MPORT_data = fetch_buf_idata[fetch_buf_idata_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_idata_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_idata_reg_i0_MPORT_data = fetch_buf_idata[fetch_buf_idata_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_idata_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_idata_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_idata_reg_i0_MPORT_1_data = fetch_buf_idata[fetch_buf_idata_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_idata_MPORT_8_en = reg_addressed & _T_71;
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
  assign fetch_buf_iblock_cont_MPORT_3_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_MPORT_4_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_4_addr = 2'h1;
  assign fetch_buf_iblock_cont_MPORT_4_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_MPORT_5_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_5_addr = 2'h2;
  assign fetch_buf_iblock_cont_MPORT_5_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_MPORT_6_en = 1'h1;
  assign fetch_buf_iblock_cont_MPORT_6_addr = 2'h3;
  assign fetch_buf_iblock_cont_MPORT_6_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_iblock_cont_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_iblock_cont_MPORT_12_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_iblock_cont_MPORT_data =
    fetch_buf_iblock_cont[fetch_buf_iblock_cont_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_iblock_cont_iaddrs_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_iaddrs_MPORT_1_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_idata0_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_idata0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_idata1_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_idata1_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_bpe0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_iblock_cont_bpe1_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_fp_ptr_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_iblock_cont_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_iblock_cont_reg_i0_MPORT_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_iblock_cont_reg_i0_MPORT_1_data = fetch_buf_iblock_cont[fetch_buf_iblock_cont_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_iblock_cont_MPORT_8_en = reg_addressed & _T_71;
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
  assign fetch_buf_end_of_iblock_MPORT_3_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_MPORT_4_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_4_addr = 2'h1;
  assign fetch_buf_end_of_iblock_MPORT_4_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_MPORT_5_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_5_addr = 2'h2;
  assign fetch_buf_end_of_iblock_MPORT_5_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_MPORT_6_en = 1'h1;
  assign fetch_buf_end_of_iblock_MPORT_6_addr = 2'h3;
  assign fetch_buf_end_of_iblock_MPORT_6_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_end_of_iblock_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_end_of_iblock_MPORT_12_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_iblock_cont_MPORT_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_iaddrs_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_idata0_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_idata0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_idata1_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_idata1_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_bpe0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_end_of_iblock_bpe1_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_fp_ptr_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_data = fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_end_of_iblock_reg_i0_MPORT_1_data =
    fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_end_of_iblock_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_0_lcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_0_gcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_1_lcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_1_gcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_2_lcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_2_gcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_4_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_5_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_6_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_MPORT_12_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_3_lcnt_MPORT_8_en = reg_addressed & _T_71;
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
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_addr = 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_4_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_addr = 2'h2;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_5_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_addr = 2'h3;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_6_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_MPORT_12_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_idata0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_idata1_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_data =
    fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_bp_entries_3_gcnt_MPORT_8_en = reg_addressed & _T_71;
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
  assign fetch_buf_fp_ptr_MPORT_3_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_3_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_MPORT_4_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_4_addr = 2'h1;
  assign fetch_buf_fp_ptr_MPORT_4_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_4_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_MPORT_5_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_5_addr = 2'h2;
  assign fetch_buf_fp_ptr_MPORT_5_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_5_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_MPORT_6_en = 1'h1;
  assign fetch_buf_fp_ptr_MPORT_6_addr = 2'h3;
  assign fetch_buf_fp_ptr_MPORT_6_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_6_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_MPORT_12_en = _T_78 & _T_70;
  assign fetch_buf_fp_ptr_MPORT_12_addr = fetch_ptr[1:0];
  assign fetch_buf_fp_ptr_MPORT_12_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_12_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_end_of_iblocks_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_en = 1'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_end_of_iblocks_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_iblock_cont_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iblock_cont_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_iaddrs_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_addr = _end_of_iblocks_T_1[1:0];
  assign fetch_buf_fp_ptr_iaddrs_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iaddrs_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_en = 1'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_iaddrs_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_iaddrs_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_idata0_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_idata0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_idata0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_idata0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_idata1_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_idata1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_idata1_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_idata1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_bpe0_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_bpe0_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_bpe0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_bpe0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_bpe1_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_bpe1_MPORT_addr = read_ptr[1:0] + 2'h1;
  assign fetch_buf_fp_ptr_bpe1_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_bpe1_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_en = 1'h1;
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_fp_ptr_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_fp_ptr_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_reg_i0_MPORT_en = inst1_valid & _next_read_ptr_T_2;
  assign fetch_buf_fp_ptr_reg_i0_MPORT_addr = next_read_ptr[1:0];
  assign fetch_buf_fp_ptr_reg_i0_MPORT_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_reg_i0_MPORT_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_en = _T_87 ? 1'h0 : _T_89;
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_addr = read_ptr[1:0];
  assign fetch_buf_fp_ptr_reg_i0_MPORT_1_data = fetch_buf_fp_ptr[fetch_buf_fp_ptr_reg_i0_MPORT_1_addr]; // @[src/main/scala/fpga/Fetch.scala 108:22]
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
  assign fetch_buf_fp_ptr_MPORT_8_en = reg_addressed & _T_71;
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
  assign io_ft_inst1_valid = inst1_valid | inst1_bpfailed; // @[src/main/scala/fpga/Fetch.scala 355:43]
  assign io_ft_inst1_addr = {fetch_buf_iaddr_iaddrs_MPORT_data[30:2],reg_i0}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_ft_inst1_data = {_GEN_116,_GEN_123}; // @[src/main/scala/fpga/Fetch.scala 349:42]
  assign io_ft_inst1_bpfailed = _fix_zbp_miss1_T & sat_count != 2'h0 & ~_GEN_97 & end_of_iblock == i0; // @[src/main/scala/fpga/Fetch.scala 347:78]
  assign io_ft_inst1_redirected = _io_ft_inst1_redirected_T[0]; // @[src/main/scala/fpga/Fetch.scala 352:39]
  assign io_ft_inst1_bp_entry_lcnt = 3'h6 == inst1_end ? bp_entries_6_lcnt : _GEN_129; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  assign io_ft_inst1_bp_entry_gcnt = 3'h6 == inst1_end ? bp_entries_6_gcnt : _GEN_136; // @[src/main/scala/fpga/Fetch.scala 353:{28,28}]
  assign io_ft_inst1_fp_ptr = fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 354:28]
  assign io_ft_inst2_valid = _inst1_valid_T_2 ? 1'h0 : _inst2_valid_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_ft_inst2_addr = {_io_ft_inst2_addr_T_1[30:2],inst1_past[1:0]}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_ft_inst2_data = _GEN_97 ? _io_ft_inst2_data_T : _io_ft_inst2_data_T_1; // @[src/main/scala/fpga/Fetch.scala 358:34]
  assign io_ft_inst2_redirected = _io_ft_inst2_redirected_T[0]; // @[src/main/scala/fpga/Fetch.scala 361:39]
  assign io_ft_inst2_bp_entry_lcnt = 3'h6 == inst2_end ? bp_entries_6_lcnt : _GEN_157; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  assign io_ft_inst2_bp_entry_gcnt = 3'h6 == inst2_end ? bp_entries_6_gcnt : _GEN_164; // @[src/main/scala/fpga/Fetch.scala 362:{28,28}]
  assign io_ft_inst2_fp_ptr = fetch_buf_fp_ptr_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 363:28]
  assign io_ft_imem_en = (has_space & redirect_ready | io_ft_flush_en) & ~wait_for_dram & _T_2; // @[src/main/scala/fpga/Fetch.scala 189:97]
  assign io_ft_imem_addr = {_reg_next_iaddr_T_1,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign io_ft_icache_addr_en = _io_ft_imem_en_T_1 & is_dram; // @[src/main/scala/fpga/Fetch.scala 191:79]
  assign io_ft_icache_addr = {_reg_next_iaddr_T_1,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign io_pr_iaddr_en = ~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready ? 1'h0
     : 1'h1; // @[src/main/scala/fpga/Fetch.scala 198:122 200:24 203:23]
  assign io_pr_iaddr = io_ft_flush_en ? io_ft_flush_iaddr : _iaddr_T_2; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_flush_en = io_ft_flush_en; // @[src/main/scala/fpga/Fetch.scala 192:26]
  assign io_pr_invalidate = (reg_fix_zbp_miss1 | reg_fix_zbp_miss2) & reg_addressed; // @[src/main/scala/fpga/Fetch.scala 142:70]
  assign io_pr_redirect_en = io_ft_flush_en | reg_bp1_redirect_en | io_pr_bp0_en & _bp1_redirect_en_T; // @[src/main/scala/fpga/Fetch.scala 194:67]
  assign io_pr_correct_enq = _bp1_redirect_en_T & _bp1_cancel_redir_T_2; // @[src/main/scala/fpga/Fetch.scala 149:19]
  assign io_pr_target_changed = reg_bp1_target_changed; // @[src/main/scala/fpga/Fetch.scala 196:26]
  always @(posedge clock) begin
    if (fetch_buf_iaddr_MPORT_en & fetch_buf_iaddr_MPORT_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_addr] <= fetch_buf_iaddr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_1_en & fetch_buf_iaddr_MPORT_1_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_1_addr] <= fetch_buf_iaddr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_2_en & fetch_buf_iaddr_MPORT_2_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_2_addr] <= fetch_buf_iaddr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_7_en & fetch_buf_iaddr_MPORT_7_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_7_addr] <= fetch_buf_iaddr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_8_en & fetch_buf_iaddr_MPORT_8_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_8_addr] <= fetch_buf_iaddr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_9_en & fetch_buf_iaddr_MPORT_9_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_9_addr] <= fetch_buf_iaddr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_10_en & fetch_buf_iaddr_MPORT_10_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_10_addr] <= fetch_buf_iaddr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iaddr_MPORT_11_en & fetch_buf_iaddr_MPORT_11_mask) begin
      fetch_buf_iaddr[fetch_buf_iaddr_MPORT_11_addr] <= fetch_buf_iaddr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_en & fetch_buf_idata_MPORT_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_addr] <= fetch_buf_idata_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_1_en & fetch_buf_idata_MPORT_1_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_1_addr] <= fetch_buf_idata_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_2_en & fetch_buf_idata_MPORT_2_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_2_addr] <= fetch_buf_idata_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_7_en & fetch_buf_idata_MPORT_7_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_7_addr] <= fetch_buf_idata_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_8_en & fetch_buf_idata_MPORT_8_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_8_addr] <= fetch_buf_idata_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_9_en & fetch_buf_idata_MPORT_9_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_9_addr] <= fetch_buf_idata_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_10_en & fetch_buf_idata_MPORT_10_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_10_addr] <= fetch_buf_idata_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_idata_MPORT_11_en & fetch_buf_idata_MPORT_11_mask) begin
      fetch_buf_idata[fetch_buf_idata_MPORT_11_addr] <= fetch_buf_idata_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_en & fetch_buf_iblock_cont_MPORT_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_addr] <= fetch_buf_iblock_cont_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_1_en & fetch_buf_iblock_cont_MPORT_1_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_1_addr] <= fetch_buf_iblock_cont_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_2_en & fetch_buf_iblock_cont_MPORT_2_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_2_addr] <= fetch_buf_iblock_cont_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_7_en & fetch_buf_iblock_cont_MPORT_7_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_7_addr] <= fetch_buf_iblock_cont_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_8_en & fetch_buf_iblock_cont_MPORT_8_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_8_addr] <= fetch_buf_iblock_cont_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_9_en & fetch_buf_iblock_cont_MPORT_9_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_9_addr] <= fetch_buf_iblock_cont_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_10_en & fetch_buf_iblock_cont_MPORT_10_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_10_addr] <= fetch_buf_iblock_cont_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_iblock_cont_MPORT_11_en & fetch_buf_iblock_cont_MPORT_11_mask) begin
      fetch_buf_iblock_cont[fetch_buf_iblock_cont_MPORT_11_addr] <= fetch_buf_iblock_cont_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_en & fetch_buf_end_of_iblock_MPORT_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_addr] <= fetch_buf_end_of_iblock_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_1_en & fetch_buf_end_of_iblock_MPORT_1_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_1_addr] <= fetch_buf_end_of_iblock_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_2_en & fetch_buf_end_of_iblock_MPORT_2_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_2_addr] <= fetch_buf_end_of_iblock_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_7_en & fetch_buf_end_of_iblock_MPORT_7_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_7_addr] <= fetch_buf_end_of_iblock_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_8_en & fetch_buf_end_of_iblock_MPORT_8_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_8_addr] <= fetch_buf_end_of_iblock_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_9_en & fetch_buf_end_of_iblock_MPORT_9_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_9_addr] <= fetch_buf_end_of_iblock_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_10_en & fetch_buf_end_of_iblock_MPORT_10_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_10_addr] <= fetch_buf_end_of_iblock_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_end_of_iblock_MPORT_11_en & fetch_buf_end_of_iblock_MPORT_11_mask) begin
      fetch_buf_end_of_iblock[fetch_buf_end_of_iblock_MPORT_11_addr] <= fetch_buf_end_of_iblock_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_en & fetch_buf_bp_entries_0_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_1_en & fetch_buf_bp_entries_0_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_2_en & fetch_buf_bp_entries_0_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_7_en & fetch_buf_bp_entries_0_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_8_en & fetch_buf_bp_entries_0_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_9_en & fetch_buf_bp_entries_0_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_0_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_10_en & fetch_buf_bp_entries_0_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_0_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_lcnt_MPORT_11_en & fetch_buf_bp_entries_0_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_0_lcnt[fetch_buf_bp_entries_0_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_0_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_en & fetch_buf_bp_entries_0_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_1_en & fetch_buf_bp_entries_0_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_2_en & fetch_buf_bp_entries_0_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_7_en & fetch_buf_bp_entries_0_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_8_en & fetch_buf_bp_entries_0_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_9_en & fetch_buf_bp_entries_0_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_0_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_10_en & fetch_buf_bp_entries_0_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_0_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_0_gcnt_MPORT_11_en & fetch_buf_bp_entries_0_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_0_gcnt[fetch_buf_bp_entries_0_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_0_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_en & fetch_buf_bp_entries_1_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_1_en & fetch_buf_bp_entries_1_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_2_en & fetch_buf_bp_entries_1_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_7_en & fetch_buf_bp_entries_1_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_8_en & fetch_buf_bp_entries_1_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_9_en & fetch_buf_bp_entries_1_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_1_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_10_en & fetch_buf_bp_entries_1_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_1_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_lcnt_MPORT_11_en & fetch_buf_bp_entries_1_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_1_lcnt[fetch_buf_bp_entries_1_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_1_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_en & fetch_buf_bp_entries_1_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_1_en & fetch_buf_bp_entries_1_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_2_en & fetch_buf_bp_entries_1_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_7_en & fetch_buf_bp_entries_1_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_8_en & fetch_buf_bp_entries_1_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_9_en & fetch_buf_bp_entries_1_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_1_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_10_en & fetch_buf_bp_entries_1_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_1_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_1_gcnt_MPORT_11_en & fetch_buf_bp_entries_1_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_1_gcnt[fetch_buf_bp_entries_1_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_1_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_en & fetch_buf_bp_entries_2_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_1_en & fetch_buf_bp_entries_2_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_2_en & fetch_buf_bp_entries_2_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_7_en & fetch_buf_bp_entries_2_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_8_en & fetch_buf_bp_entries_2_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_9_en & fetch_buf_bp_entries_2_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_2_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_10_en & fetch_buf_bp_entries_2_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_2_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_lcnt_MPORT_11_en & fetch_buf_bp_entries_2_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_2_lcnt[fetch_buf_bp_entries_2_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_2_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_en & fetch_buf_bp_entries_2_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_1_en & fetch_buf_bp_entries_2_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_2_en & fetch_buf_bp_entries_2_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_7_en & fetch_buf_bp_entries_2_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_8_en & fetch_buf_bp_entries_2_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_9_en & fetch_buf_bp_entries_2_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_2_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_10_en & fetch_buf_bp_entries_2_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_2_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_2_gcnt_MPORT_11_en & fetch_buf_bp_entries_2_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_2_gcnt[fetch_buf_bp_entries_2_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_2_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_en & fetch_buf_bp_entries_3_lcnt_MPORT_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_1_en & fetch_buf_bp_entries_3_lcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_1_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_2_en & fetch_buf_bp_entries_3_lcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_2_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_7_en & fetch_buf_bp_entries_3_lcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_7_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_8_en & fetch_buf_bp_entries_3_lcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_8_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_9_en & fetch_buf_bp_entries_3_lcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_9_addr] <= fetch_buf_bp_entries_3_lcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_10_en & fetch_buf_bp_entries_3_lcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_3_lcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_lcnt_MPORT_11_en & fetch_buf_bp_entries_3_lcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_3_lcnt[fetch_buf_bp_entries_3_lcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_3_lcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_en & fetch_buf_bp_entries_3_gcnt_MPORT_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_1_en & fetch_buf_bp_entries_3_gcnt_MPORT_1_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_1_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_2_en & fetch_buf_bp_entries_3_gcnt_MPORT_2_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_2_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_7_en & fetch_buf_bp_entries_3_gcnt_MPORT_7_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_7_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_8_en & fetch_buf_bp_entries_3_gcnt_MPORT_8_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_8_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_9_en & fetch_buf_bp_entries_3_gcnt_MPORT_9_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_9_addr] <= fetch_buf_bp_entries_3_gcnt_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_10_en & fetch_buf_bp_entries_3_gcnt_MPORT_10_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_10_addr] <=
        fetch_buf_bp_entries_3_gcnt_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_bp_entries_3_gcnt_MPORT_11_en & fetch_buf_bp_entries_3_gcnt_MPORT_11_mask) begin
      fetch_buf_bp_entries_3_gcnt[fetch_buf_bp_entries_3_gcnt_MPORT_11_addr] <=
        fetch_buf_bp_entries_3_gcnt_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_en & fetch_buf_fp_ptr_MPORT_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_addr] <= fetch_buf_fp_ptr_MPORT_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_1_en & fetch_buf_fp_ptr_MPORT_1_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_1_addr] <= fetch_buf_fp_ptr_MPORT_1_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_2_en & fetch_buf_fp_ptr_MPORT_2_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_2_addr] <= fetch_buf_fp_ptr_MPORT_2_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_7_en & fetch_buf_fp_ptr_MPORT_7_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_7_addr] <= fetch_buf_fp_ptr_MPORT_7_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_8_en & fetch_buf_fp_ptr_MPORT_8_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_8_addr] <= fetch_buf_fp_ptr_MPORT_8_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_9_en & fetch_buf_fp_ptr_MPORT_9_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_9_addr] <= fetch_buf_fp_ptr_MPORT_9_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_10_en & fetch_buf_fp_ptr_MPORT_10_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_10_addr] <= fetch_buf_fp_ptr_MPORT_10_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (fetch_buf_fp_ptr_MPORT_11_en & fetch_buf_fp_ptr_MPORT_11_mask) begin
      fetch_buf_fp_ptr[fetch_buf_fp_ptr_MPORT_11_addr] <= fetch_buf_fp_ptr_MPORT_11_data; // @[src/main/scala/fpga/Fetch.scala 108:22]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 109:31]
      addressing_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 109:31]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 198:122]
      if (invalidate & _fix_zbp_miss1_T) begin // @[src/main/scala/fpga/Fetch.scala 180:42]
        addressing_ptr <= _addressing_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 181:22]
      end
    end else if (!(_T_1)) begin // @[src/main/scala/fpga/Fetch.scala 206:44]
      addressing_ptr <= _addressing_ptr_T_3; // @[src/main/scala/fpga/Fetch.scala 209:24]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 110:31]
      fetch_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 110:31]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 299:27]
      fetch_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 300:17]
    end else if (io_ft_imem_valid | io_ft_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 287:57]
      if (_T_70) begin // @[src/main/scala/fpga/Fetch.scala 289:23]
        fetch_ptr <= _fetch_ptr_T_1; // @[src/main/scala/fpga/Fetch.scala 290:19]
      end
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 111:31]
      read_ptr <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 111:31]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 394:27]
      read_ptr <= addressing_ptr; // @[src/main/scala/fpga/Fetch.scala 395:16]
    end else begin
      read_ptr <= next_read_ptr; // @[src/main/scala/fpga/Fetch.scala 373:14]
    end
    discard_buf_0 <= reset | _GEN_35; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_1 <= reset | _GEN_36; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_2 <= reset | _GEN_37; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_3 <= reset | _GEN_38; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_4 <= reset | _GEN_39; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_5 <= reset | _GEN_40; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_6 <= reset | _GEN_41; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    discard_buf_7 <= reset | _GEN_42; // @[src/main/scala/fpga/Fetch.scala 113:{28,28}]
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 114:28]
      discard_enq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 114:28]
    end else if (!(~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready)) begin // @[src/main/scala/fpga/Fetch.scala 198:122]
      discard_enq <= _discard_enq_T_1; // @[src/main/scala/fpga/Fetch.scala 205:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 115:28]
      discard_deq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 115:28]
    end else if (io_ft_imem_valid | io_ft_icache_idata_valid) begin // @[src/main/scala/fpga/Fetch.scala 287:57]
      discard_deq <= _discard_deq_T_1; // @[src/main/scala/fpga/Fetch.scala 288:19]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 125:30]
      reg_addressed <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 125:30]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 198:122]
      reg_addressed <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 200:24]
    end else begin
      reg_addressed <= 1'h1; // @[src/main/scala/fpga/Fetch.scala 203:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 128:41]
      reg_next_iaddr <= 31'hfff0; // @[src/main/scala/fpga/Fetch.scala 128:41]
    end else if (~_io_ft_imem_en_T & _fix_zbp_miss1_T | wait_for_dram | is_dram & ~io_ft_icache_addr_ready) begin // @[src/main/scala/fpga/Fetch.scala 198:122]
      if (io_ft_flush_en) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        reg_next_iaddr <= io_ft_flush_iaddr;
      end else if (_invalidate_T) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        reg_next_iaddr <= reg_fix_addr;
      end else begin
        reg_next_iaddr <= _iaddr_T_1;
      end
    end else begin
      reg_next_iaddr <= _reg_next_iaddr_T_3; // @[src/main/scala/fpga/Fetch.scala 163:20]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 132:41]
      reg_fix_zbp_miss1 <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 132:41]
    end else begin
      reg_fix_zbp_miss1 <= fix_zbp_miss1; // @[src/main/scala/fpga/Fetch.scala 168:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 133:41]
      reg_fix_zbp_miss2 <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 133:41]
    end else begin
      reg_fix_zbp_miss2 <= fix_zbp_miss2; // @[src/main/scala/fpga/Fetch.scala 169:23]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 134:41]
      reg_bp1_redirect_en <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 134:41]
    end else begin
      reg_bp1_redirect_en <= _fix_zbp_miss1_T & bp1_redirect_en; // @[src/main/scala/fpga/Fetch.scala 170:25]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 135:41]
      reg_bp1_target_changed <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 135:41]
    end else begin
      reg_bp1_target_changed <= fix_zbp_miss2; // @[src/main/scala/fpga/Fetch.scala 171:28]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 136:41]
      reg_fix_addr <= 31'h0; // @[src/main/scala/fpga/Fetch.scala 136:41]
    end else if (io_pr_bp1_en) begin // @[src/main/scala/fpga/Fetch.scala 166:23]
      reg_fix_addr <= io_pr_bp1_addr;
    end else begin
      reg_fix_addr <= reg_next_iaddr;
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 137:41]
      reg_discard_enq <= 3'h0; // @[src/main/scala/fpga/Fetch.scala 137:41]
    end else begin
      reg_discard_enq <= discard_enq; // @[src/main/scala/fpga/Fetch.scala 143:21]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 138:41]
      reg_is_dram <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 138:41]
    end else begin
      reg_is_dram <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 305:25]
      reg_i0 <= 2'h0; // @[src/main/scala/fpga/Fetch.scala 305:25]
    end else if (io_ft_flush_en) begin // @[src/main/scala/fpga/Fetch.scala 394:27]
      reg_i0 <= io_ft_flush_iaddr[1:0]; // @[src/main/scala/fpga/Fetch.scala 396:14]
    end else if (inst1_valid & _next_read_ptr_T_2) begin // @[src/main/scala/fpga/Fetch.scala 374:53]
      if (_reg_i0_T_1) begin // @[src/main/scala/fpga/Fetch.scala 376:20]
        reg_i0 <= forward_i0;
      end else begin
        reg_i0 <= fetch_buf_iaddr_reg_i0_MPORT_data[1:0];
      end
    end else if (~inst1_valid & reg_reset_i0) begin // @[src/main/scala/fpga/Fetch.scala 382:47]
      reg_i0 <= _reg_i0_T_8; // @[src/main/scala/fpga/Fetch.scala 383:14]
    end else begin
      reg_i0 <= inst_past[1:0]; // @[src/main/scala/fpga/Fetch.scala 390:14]
    end
    if (reset) begin // @[src/main/scala/fpga/Fetch.scala 306:31]
      reg_reset_i0 <= 1'h0; // @[src/main/scala/fpga/Fetch.scala 306:31]
    end else begin
      reg_reset_i0 <= _GEN_174;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~_T_13 & ~reset) begin
          $fwrite(32'h80000002,"fb(%x): 0x%x addressed\n",addressing_ptr,_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 212:13]
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
          $fwrite(32'h80000002,"iaddr             : %x\n",_is_dram_T); // @[src/main/scala/fpga/Fetch.scala 242:11]
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
          $fwrite(32'h80000002,"reg_next_iaddr    : %x\n",{reg_next_iaddr,1'h0}); // @[src/main/scala/fpga/Fetch.scala 243:11]
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
          $fwrite(32'h80000002,"io.ft.imem.addr   : %x\n",io_ft_imem_addr); // @[src/main/scala/fpga/Fetch.scala 244:11]
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
          $fwrite(32'h80000002,"io.ft.imem.en     : %d\n",io_ft_imem_en); // @[src/main/scala/fpga/Fetch.scala 245:11]
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
          $fwrite(32'h80000002,"io.ft.flush_en    : %d\n",io_ft_flush_en); // @[src/main/scala/fpga/Fetch.scala 246:11]
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
          $fwrite(32'h80000002,"io.pr.bp0_en      : %d\n",io_pr_bp0_en); // @[src/main/scala/fpga/Fetch.scala 247:11]
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
          $fwrite(32'h80000002,"io.pr.bp1_en      : %d\n",io_pr_bp1_en); // @[src/main/scala/fpga/Fetch.scala 248:11]
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
          $fwrite(32'h80000002,"fix_zbp_miss      : %d\n",fix_zbp_miss1 | fix_zbp_miss2); // @[src/main/scala/fpga/Fetch.scala 249:11]
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
          $fwrite(32'h80000002,"reg_fix_zbp_miss  : %d\n",_invalidate_T); // @[src/main/scala/fpga/Fetch.scala 250:11]
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
          $fwrite(32'h80000002,"io.pr.invalidate  : %d\n",io_pr_invalidate); // @[src/main/scala/fpga/Fetch.scala 251:11]
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
          $fwrite(32'h80000002,"io.pr.redirect_en : %d\n",io_pr_redirect_en); // @[src/main/scala/fpga/Fetch.scala 252:11]
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
          $fwrite(32'h80000002,"io.pr.correct_enq : %d\n",io_pr_correct_enq); // @[src/main/scala/fpga/Fetch.scala 253:11]
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
          $fwrite(32'h80000002,"io.pr.target_chang: %d\n",io_pr_target_changed); // @[src/main/scala/fpga/Fetch.scala 254:11]
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
          $fwrite(32'h80000002,"addressing        : %d\n",addressing_ptr[1:0]); // @[src/main/scala/fpga/Fetch.scala 255:11]
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
          $fwrite(32'h80000002,"fb(0).iaddr=%x\n",{fetch_buf_iaddr_MPORT_3_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 256:11]
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
          $fwrite(32'h80000002,"fb(1).iaddr=%x\n",{fetch_buf_iaddr_MPORT_4_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 257:11]
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
          $fwrite(32'h80000002,"fb(2).iaddr=%x\n",{fetch_buf_iaddr_MPORT_5_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 258:11]
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
          $fwrite(32'h80000002,"fb(3).iaddr=%x\n",{fetch_buf_iaddr_MPORT_6_data,1'h0}); // @[src/main/scala/fpga/Fetch.scala 259:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (reg_addressed & _T_18) begin
          $fwrite(32'h80000002,"fb(%d).end_of_iblock=%d\n",_T_21,_T_72); // @[src/main/scala/fpga/Fetch.scala 283:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (reg_addressed & _T_18) begin
          $fwrite(32'h80000002,"fb(%d).fp_ptr=%d\n",_T_21,io_pr_fp_ptr); // @[src/main/scala/fpga/Fetch.scala 284:13]
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
            io_ft_icache_idata_valid); // @[src/main/scala/fpga/Fetch.scala 292:15]
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
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x fetched\n",fetch_ptr,_T_83,idata); // @[src/main/scala/fpga/Fetch.scala 293:15]
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
          $fwrite(32'h80000002,"redir_oh: 0x%x  inst1_end: %d  redirected: %d\n",redir_oh,inst1_end,
            io_ft_inst1_redirected); // @[src/main/scala/fpga/Fetch.scala 400:13]
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
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,_T_92,{idatas_1,idatas_0},io_ft_inst1_ready); // @[src/main/scala/fpga/Fetch.scala 401:13]
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
          $fwrite(32'h80000002,"redir_oh: 0x%x  inst2_end: %d  redirected: %d\n",redir_oh,inst2_end,
            io_ft_inst2_redirected); // @[src/main/scala/fpga/Fetch.scala 404:13]
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
          $fwrite(32'h80000002,"fb(%x): 0x%x: 0x%x %d read\n",read_ptr,_T_98,io_ft_inst2_data,io_ft_inst2_ready); // @[src/main/scala/fpga/Fetch.scala 405:13]
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
  reg_fix_zbp_miss1 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  reg_fix_zbp_miss2 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  reg_bp1_redirect_en = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  reg_bp1_target_changed = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  reg_fix_addr = _RAND_32[30:0];
  _RAND_33 = {1{`RANDOM}};
  reg_discard_enq = _RAND_33[2:0];
  _RAND_34 = {1{`RANDOM}};
  reg_is_dram = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  reg_i0 = _RAND_35[1:0];
  _RAND_36 = {1{`RANDOM}};
  reg_reset_i0 = _RAND_36[0:0];
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
  input         io_pr_iaddr_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_pr_iaddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pr_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pr_invalidate, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pr_redirect_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pr_correct_enq, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pr_target_changed, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pr_redirect_ready, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pr_bp0_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp0_pos, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pr_bp0_addr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pr_bp1_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp1_pos, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pr_bp1_addr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_0_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_0_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_1_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_1_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_2_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_2_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_3_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pr_bp_entries_3_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [2:0]  io_pr_fp_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_upd_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_cr_upd_latter_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_cr_upd_bp_entry_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_cr_upd_bp_entry_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [7:0]  io_cr_upd_history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_upd_br_taken, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_cr_upd_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_upd_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_cr_upd_next_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_cr_fp_entry_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_fp_hit, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_cr_mispred, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_cr_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_re_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_re_correct, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_re_target_changed, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_re_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_re_history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_re_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_re_ready, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_re_left1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ru_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_ru_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_ru_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ru_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_ru_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_zbtb_lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_zbtb_lu_matches_0, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_zbtb_lu_matches_1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_zbtb_lu_matches_2, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_zbtb_lu_matches_3, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_zbtb_lu_target_0, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_zbtb_lu_target_1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_zbtb_lu_target_2, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_zbtb_lu_target_3, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_zbtb_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_zbtb_up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_zbtb_up_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_zbtb_inv_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_zbtb_inv_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_btb_lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_0_jump, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_0_br, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_btb_lu_result_0_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_0_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_btb_lu_result_0_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_1_jump, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_1_br, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_btb_lu_result_1_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_1_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_btb_lu_result_1_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_2_jump, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_2_br, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_btb_lu_result_2_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_2_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_btb_lu_result_2_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_3_jump, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_3_br, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_btb_lu_result_3_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_btb_lu_result_3_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_btb_lu_result_3_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_btb_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_btb_up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_btb_up_attr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_btb_up_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_btb_up_upd_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_btb_up_target, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pht__lu_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lu_taken_0, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lu_taken_1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lu_taken_2, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lu_taken_3, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_lcnt_0, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_lcnt_1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_lcnt_2, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_lcnt_3, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_gcnt_0, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_gcnt_1, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_gcnt_2, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lu_gcnt_3, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht__up_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_pht__up_history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pht__up_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pht__up_lcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pht__up_gcnt, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__lmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [10:0] io_pht__lmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_pht__lmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [12:0] io_pht__lmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__lmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__gmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input         io_pht__gmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [10:0] io_pht__gmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_pht__gmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [12:0] io_pht__gmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [1:0]  io_pht__gmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht__br_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pht__br_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht__br2_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_pht__br2_history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_pht__br2_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [7:0]  io_pht__history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht__res_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [7:0]  io_pht__res_history, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [30:0] io_ras_top_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ras_ret1_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ras_call1_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_ras_call1_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ras_up_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ras_ret2_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_ras_call2_en, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [30:0] io_ras_call2_ret_pc, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht_lmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht_lmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [10:0] io_pht_lmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [7:0]  io_pht_lmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [12:0] io_pht_lmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pht_lmem_wdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht_gmem_ren, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output        io_pht_gmem_wen, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [10:0] io_pht_gmem_raddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  input  [7:0]  io_pht_gmem_rdata, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [12:0] io_pht_gmem_waddr, // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
  output [1:0]  io_pht_gmem_wdata // @[src/main/scala/fpga/FetchPredictor.scala 168:14]
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
`endif // RANDOMIZE_REG_INIT
  reg  reg_iaddr_en; // @[src/main/scala/fpga/FetchPredictor.scala 186:34]
  reg  reg_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 187:34]
  reg [30:0] reg_iaddr_index; // @[src/main/scala/fpga/FetchPredictor.scala 188:34]
  reg  reg_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 189:34]
  reg  reg_correct_enq; // @[src/main/scala/fpga/FetchPredictor.scala 190:34]
  reg  reg_target_changed; // @[src/main/scala/fpga/FetchPredictor.scala 191:37]
  reg  reg_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 192:34]
  reg [1:0] reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 193:34]
  reg [3:0] reg_ibmask; // @[src/main/scala/fpga/FetchPredictor.scala 195:34]
  wire [1:0] ibpos = io_pr_iaddr[1:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _bp0_pos_T_1 = reg_ibmask[0] & io_zbtb_lu_matches_0; // @[src/main/scala/fpga/FetchPredictor.scala 211:43]
  wire  _bp0_pos_T_3 = reg_ibmask[1] & io_zbtb_lu_matches_1; // @[src/main/scala/fpga/FetchPredictor.scala 211:43]
  wire  _bp0_pos_T_5 = reg_ibmask[2] & io_zbtb_lu_matches_2; // @[src/main/scala/fpga/FetchPredictor.scala 211:43]
  wire [1:0] _bp0_pos_T_6 = _bp0_pos_T_5 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _bp0_pos_T_7 = _bp0_pos_T_3 ? 2'h1 : _bp0_pos_T_6; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] bp0_pos = _bp0_pos_T_1 ? 2'h0 : _bp0_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire  _bp0_en_T = ~reg_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 213:34]
  wire  _bp0_en_T_1 = reg_iaddr_en & ~reg_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 213:31]
  wire  _bp0_en_T_9 = reg_ibmask[3] & io_zbtb_lu_matches_3; // @[src/main/scala/fpga/FetchPredictor.scala 213:92]
  wire [3:0] _bp0_en_T_10 = {_bp0_en_T_9,_bp0_pos_T_5,_bp0_pos_T_3,_bp0_pos_T_1}; // @[src/main/scala/fpga/FetchPredictor.scala 213:118]
  wire  bp0_en = reg_iaddr_en & ~reg_invalidate & |_bp0_en_T_10; // @[src/main/scala/fpga/FetchPredictor.scala 213:50]
  wire [30:0] _GEN_1 = 2'h1 == bp0_pos ? io_zbtb_lu_target_1 : io_zbtb_lu_target_0; // @[src/main/scala/fpga/FetchPredictor.scala 216:{20,20}]
  wire [30:0] _GEN_2 = 2'h2 == bp0_pos ? io_zbtb_lu_target_2 : _GEN_1; // @[src/main/scala/fpga/FetchPredictor.scala 216:{20,20}]
  wire [30:0] _GEN_3 = 2'h3 == bp0_pos ? io_zbtb_lu_target_3 : _GEN_2; // @[src/main/scala/fpga/FetchPredictor.scala 216:{20,20}]
  wire [31:0] _T = {_GEN_3,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire [31:0] _T_1 = {reg_iaddr_index,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  _T_3 = ~reset; // @[src/main/scala/fpga/FetchPredictor.scala 219:13]
  wire  _redirected_T_1 = io_btb_lu_result_0_br & io_pht__lu_taken_0; // @[src/main/scala/fpga/FetchPredictor.scala 226:31]
  wire  _redirected_T_2 = io_btb_lu_result_0_br & io_pht__lu_taken_0 | io_btb_lu_result_0_jump; // @[src/main/scala/fpga/FetchPredictor.scala 226:54]
  wire  _redirected_T_3 = _redirected_T_2 | io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 227:32]
  wire  redirected_0 = reg_ibmask[0] & _redirected_T_3; // @[src/main/scala/fpga/FetchPredictor.scala 225:61]
  wire  _redirected_T_6 = io_btb_lu_result_1_br & io_pht__lu_taken_1; // @[src/main/scala/fpga/FetchPredictor.scala 226:31]
  wire  _redirected_T_7 = io_btb_lu_result_1_br & io_pht__lu_taken_1 | io_btb_lu_result_1_jump; // @[src/main/scala/fpga/FetchPredictor.scala 226:54]
  wire  _redirected_T_8 = _redirected_T_7 | io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 227:32]
  wire  redirected_1 = reg_ibmask[1] & _redirected_T_8; // @[src/main/scala/fpga/FetchPredictor.scala 225:61]
  wire  _redirected_T_11 = io_btb_lu_result_2_br & io_pht__lu_taken_2; // @[src/main/scala/fpga/FetchPredictor.scala 226:31]
  wire  _redirected_T_12 = io_btb_lu_result_2_br & io_pht__lu_taken_2 | io_btb_lu_result_2_jump; // @[src/main/scala/fpga/FetchPredictor.scala 226:54]
  wire  _redirected_T_13 = _redirected_T_12 | io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 227:32]
  wire  redirected_2 = reg_ibmask[2] & _redirected_T_13; // @[src/main/scala/fpga/FetchPredictor.scala 225:61]
  wire  _redirected_T_16 = io_btb_lu_result_3_br & io_pht__lu_taken_3; // @[src/main/scala/fpga/FetchPredictor.scala 226:31]
  wire  _redirected_T_17 = io_btb_lu_result_3_br & io_pht__lu_taken_3 | io_btb_lu_result_3_jump; // @[src/main/scala/fpga/FetchPredictor.scala 226:54]
  wire  _redirected_T_18 = _redirected_T_17 | io_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 227:32]
  wire  redirected_3 = reg_ibmask[3] & _redirected_T_18; // @[src/main/scala/fpga/FetchPredictor.scala 225:61]
  wire [1:0] _bp1_pos_T = redirected_2 ? 2'h2 : 2'h3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _bp1_pos_T_1 = redirected_1 ? 2'h1 : _bp1_pos_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] bp1_pos = redirected_0 ? 2'h0 : _bp1_pos_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [1:0] _GEN_5 = 2'h1 == bp1_pos ? io_btb_lu_result_1_attr : io_btb_lu_result_0_attr; // @[src/main/scala/fpga/FetchPredictor.scala 237:{57,57}]
  wire [1:0] _GEN_6 = 2'h2 == bp1_pos ? io_btb_lu_result_2_attr : _GEN_5; // @[src/main/scala/fpga/FetchPredictor.scala 237:{57,57}]
  wire [1:0] _GEN_7 = 2'h3 == bp1_pos ? io_btb_lu_result_3_attr : _GEN_6; // @[src/main/scala/fpga/FetchPredictor.scala 237:{57,57}]
  wire [30:0] _GEN_9 = 2'h1 == bp1_pos ? io_btb_lu_result_1_target : io_btb_lu_result_0_target; // @[src/main/scala/fpga/FetchPredictor.scala 237:{25,25}]
  wire [30:0] _GEN_10 = 2'h2 == bp1_pos ? io_btb_lu_result_2_target : _GEN_9; // @[src/main/scala/fpga/FetchPredictor.scala 237:{25,25}]
  wire [30:0] _GEN_11 = 2'h3 == bp1_pos ? io_btb_lu_result_3_target : _GEN_10; // @[src/main/scala/fpga/FetchPredictor.scala 237:{25,25}]
  wire [30:0] bp1_target = _GEN_7 == 2'h0 ? io_ras_top_ret_pc : _GEN_11; // @[src/main/scala/fpga/FetchPredictor.scala 237:25]
  wire [3:0] _bp1_en_T_2 = {redirected_3,redirected_2,redirected_1,redirected_0}; // @[src/main/scala/fpga/FetchPredictor.scala 238:64]
  wire  bp1_en = _bp0_en_T_1 & |_bp1_en_T_2; // @[src/main/scala/fpga/FetchPredictor.scala 238:50]
  wire  _io_ru_en_T_1 = bp1_en & ~io_pr_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 243:31]
  wire  _GEN_17 = 2'h1 == bp1_pos ? io_btb_lu_result_1_is_ret : io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 246:{21,21}]
  wire  _GEN_18 = 2'h2 == bp1_pos ? io_btb_lu_result_2_is_ret : _GEN_17; // @[src/main/scala/fpga/FetchPredictor.scala 246:{21,21}]
  wire  _GEN_19 = 2'h3 == bp1_pos ? io_btb_lu_result_3_is_ret : _GEN_18; // @[src/main/scala/fpga/FetchPredictor.scala 246:{21,21}]
  wire [31:0] _T_6 = {bp1_target,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  _io_re_en_T = ~io_pr_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 258:23]
  wire  _T_15 = reg_redirect_en & ~reg_correct_enq & ~io_pr_target_changed | reg_target_changed; // @[src/main/scala/fpga/FetchPredictor.scala 266:70]
  wire  _T_16 = _io_re_en_T & _T_15; // @[src/main/scala/fpga/FetchPredictor.scala 265:28]
  wire [1:0] cur_fp_ptr = _T_16 | reg_flush_en ? io_re_ptr : reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 268:25 269:18 193:34]
  wire  _GEN_22 = 2'h1 == bp0_pos ? _redirected_T_6 : _redirected_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 275:{52,52}]
  wire  _GEN_23 = 2'h2 == bp0_pos ? _redirected_T_11 : _GEN_22; // @[src/main/scala/fpga/FetchPredictor.scala 275:{52,52}]
  wire  _GEN_24 = 2'h3 == bp0_pos ? _redirected_T_16 : _GEN_23; // @[src/main/scala/fpga/FetchPredictor.scala 275:{52,52}]
  wire  _GEN_26 = 2'h1 == bp0_pos ? io_btb_lu_result_1_jump : io_btb_lu_result_0_jump; // @[src/main/scala/fpga/FetchPredictor.scala 275:{74,74}]
  wire  _GEN_27 = 2'h2 == bp0_pos ? io_btb_lu_result_2_jump : _GEN_26; // @[src/main/scala/fpga/FetchPredictor.scala 275:{74,74}]
  wire  _GEN_28 = 2'h3 == bp0_pos ? io_btb_lu_result_3_jump : _GEN_27; // @[src/main/scala/fpga/FetchPredictor.scala 275:{74,74}]
  wire  _io_ras_ret1_en_T_3 = _io_re_en_T & reg_iaddr_en & _bp0_en_T; // @[src/main/scala/fpga/FetchPredictor.scala 279:60]
  wire  _io_ras_call1_ret_pc_T = bp1_pos == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 282:15]
  wire [30:0] _io_ras_call1_ret_pc_T_2 = {reg_iaddr_index[30:2],2'h0}; // @[src/main/scala/common/UIntExtension.scala 12:73]
  wire [30:0] _io_ras_call1_ret_pc_T_4 = _io_ras_call1_ret_pc_T_2 + 31'h4; // @[src/main/scala/fpga/FetchPredictor.scala 283:39]
  wire [1:0] _io_ras_call1_ret_pc_T_6 = bp1_pos + 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 284:49]
  wire [30:0] _io_ras_call1_ret_pc_T_9 = {reg_iaddr_index[30:2],_io_ras_call1_ret_pc_T_6}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire [7:0] pht_pc_index = reg_iaddr_index[7:0]; // @[src/main/scala/common/UIntExtension.scala 14:34]
  wire  _GEN_30 = 2'h1 == bp1_pos ? _redirected_T_6 : _redirected_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 289:{72,72}]
  wire  _GEN_31 = 2'h2 == bp1_pos ? _redirected_T_11 : _GEN_30; // @[src/main/scala/fpga/FetchPredictor.scala 289:{72,72}]
  wire  _GEN_32 = 2'h3 == bp1_pos ? _redirected_T_16 : _GEN_31; // @[src/main/scala/fpga/FetchPredictor.scala 289:{72,72}]
  wire [7:0] _io_pht_br_pc_T_2 = {pht_pc_index[7:2],bp1_pos}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  wire  _io_btb_up_en_T_1 = io_cr_upd_bp_entry_gcnt != 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 329:12]
  wire  _io_btb_up_en_T_4 = io_cr_upd_attr == 2'h0 & (io_cr_fp_hit | _io_btb_up_en_T_1) | io_cr_upd_br_taken; // @[src/main/scala/fpga/FetchPredictor.scala 341:106]
  wire  _io_btb_up_en_T_5 = io_cr_upd_attr == 2'h2; // @[src/main/scala/fpga/FetchPredictor.scala 343:23]
  wire  _io_btb_up_en_T_6 = _io_btb_up_en_T_4 | _io_btb_up_en_T_5; // @[src/main/scala/fpga/FetchPredictor.scala 342:28]
  wire  _io_btb_up_en_T_7 = io_cr_upd_attr == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 344:23]
  wire  _io_btb_up_en_T_8 = _io_btb_up_en_T_6 | _io_btb_up_en_T_7; // @[src/main/scala/fpga/FetchPredictor.scala 343:43]
  wire  _io_btb_up_en_T_9 = _io_btb_up_en_T_8 | io_cr_upd_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 344:43]
  wire  _io_btb_up_upd_target_T_3 = io_cr_upd_br_taken | (_io_btb_up_en_T_5 | _io_btb_up_en_T_7); // @[src/main/scala/fpga/FetchPredictor.scala 350:65]
  wire [31:0] _T_24 = {io_cr_target,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire [31:0] _T_38 = {io_cr_upd_latter_pc,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  wire  _T_43 = io_cr_en & io_cr_upd_en & io_cr_fp_entry_attr == 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 362:36]
  wire  _T_45 = ~io_cr_upd_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 363:56]
  wire  _T_48 = io_cr_fp_hit & ~io_cr_upd_bp_entry_lcnt[0] & io_cr_upd_bp_entry_gcnt == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 363:64]
  wire  _T_53 = ~io_cr_fp_hit; // @[src/main/scala/fpga/FetchPredictor.scala 369:19]
  wire  _T_58 = ~io_cr_fp_hit & io_cr_upd_bp_entry_lcnt[0] & io_cr_upd_bp_entry_gcnt == 2'h2; // @[src/main/scala/fpga/FetchPredictor.scala 369:71]
  wire  _T_59 = ~io_cr_upd_br_taken; // @[src/main/scala/fpga/FetchPredictor.scala 370:15]
  wire  _updated_lcnt_lcnt_if_taken_T_4 = ~io_cr_upd_bp_entry_lcnt[1] | io_cr_upd_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 300:51]
  wire [1:0] updated_lcnt_lcnt_if_taken = {io_cr_upd_bp_entry_lcnt[0],_updated_lcnt_lcnt_if_taken_T_4}; // @[src/main/scala/fpga/FetchPredictor.scala 300:38]
  wire  _updated_lcnt_lcnt_unless_taken_T_4 = io_cr_upd_bp_entry_lcnt[1] & io_cr_upd_bp_entry_lcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 307:79]
  wire [1:0] updated_lcnt_lcnt_unless_taken = {_T_45,_updated_lcnt_lcnt_unless_taken_T_4}; // @[src/main/scala/fpga/FetchPredictor.scala 307:67]
  wire  _updated_gcnt_gcnt_if_taken_T_2 = ~io_cr_upd_bp_entry_gcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 317:38]
  wire  _updated_gcnt_gcnt_if_taken_T_3 = io_cr_upd_bp_entry_gcnt[1] ^ ~io_cr_upd_bp_entry_gcnt[0]; // @[src/main/scala/fpga/FetchPredictor.scala 317:36]
  wire [1:0] updated_gcnt_gcnt_if_taken = {_updated_gcnt_gcnt_if_taken_T_3,_updated_gcnt_gcnt_if_taken_T_3}; // @[src/main/scala/fpga/FetchPredictor.scala 317:48]
  wire [1:0] updated_gcnt_gcnt_unless_taken = {_updated_gcnt_gcnt_if_taken_T_2,1'h0}; // @[src/main/scala/fpga/FetchPredictor.scala 323:42]
  wire  _GEN_33 = _T_43 & _T_48; // @[src/main/scala/fpga/FetchPredictor.scala 365:17]
  wire  _GEN_40 = _T_43 & ~_T_48 & _T_58; // @[src/main/scala/fpga/FetchPredictor.scala 371:17]
  assign io_pr_redirect_ready = io_re_ready & (~io_re_left1 | ~io_pr_redirect_en); // @[src/main/scala/fpga/FetchPredictor.scala 198:41]
  assign io_pr_bp0_en = reg_iaddr_en & ~reg_invalidate & |_bp0_en_T_10; // @[src/main/scala/fpga/FetchPredictor.scala 213:50]
  assign io_pr_bp0_pos = _bp0_pos_T_1 ? 2'h0 : _bp0_pos_T_7; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_bp0_addr = 2'h3 == bp0_pos ? io_zbtb_lu_target_3 : _GEN_2; // @[src/main/scala/fpga/FetchPredictor.scala 216:{20,20}]
  assign io_pr_bp1_en = _bp0_en_T_1 & |_bp1_en_T_2; // @[src/main/scala/fpga/FetchPredictor.scala 238:50]
  assign io_pr_bp1_pos = redirected_0 ? 2'h0 : _bp1_pos_T_1; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  assign io_pr_bp1_addr = _GEN_7 == 2'h0 ? io_ras_top_ret_pc : _GEN_11; // @[src/main/scala/fpga/FetchPredictor.scala 237:25]
  assign io_pr_bp_entries_0_lcnt = io_pht__lu_lcnt_0; // @[src/main/scala/fpga/FetchPredictor.scala 254:32]
  assign io_pr_bp_entries_0_gcnt = io_btb_lu_result_0_attr == 2'h1 ? io_pht__lu_gcnt_0 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 255:38]
  assign io_pr_bp_entries_1_lcnt = io_pht__lu_lcnt_1; // @[src/main/scala/fpga/FetchPredictor.scala 254:32]
  assign io_pr_bp_entries_1_gcnt = io_btb_lu_result_1_attr == 2'h1 ? io_pht__lu_gcnt_1 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 255:38]
  assign io_pr_bp_entries_2_lcnt = io_pht__lu_lcnt_2; // @[src/main/scala/fpga/FetchPredictor.scala 254:32]
  assign io_pr_bp_entries_2_gcnt = io_btb_lu_result_2_attr == 2'h1 ? io_pht__lu_gcnt_2 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 255:38]
  assign io_pr_bp_entries_3_lcnt = io_pht__lu_lcnt_3; // @[src/main/scala/fpga/FetchPredictor.scala 254:32]
  assign io_pr_bp_entries_3_gcnt = io_btb_lu_result_3_attr == 2'h1 ? io_pht__lu_gcnt_3 : 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 255:38]
  assign io_pr_fp_ptr = {{1'd0}, cur_fp_ptr}; // @[src/main/scala/fpga/FetchPredictor.scala 263:20]
  assign io_re_en = ~io_pr_flush_en & (reg_redirect_en | reg_target_changed); // @[src/main/scala/fpga/FetchPredictor.scala 258:39]
  assign io_re_correct = reg_correct_enq; // @[src/main/scala/fpga/FetchPredictor.scala 259:20]
  assign io_re_target_changed = io_pr_target_changed; // @[src/main/scala/fpga/FetchPredictor.scala 260:26]
  assign io_re_flush_en = reg_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 261:20]
  assign io_re_history = io_pht__history; // @[src/main/scala/fpga/FetchPredictor.scala 262:20]
  assign io_ru_en = bp1_en & ~io_pr_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 243:31]
  assign io_ru_ptr = _T_16 | reg_flush_en ? io_re_ptr : reg_fp_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 268:25 269:18 193:34]
  assign io_ru_attr = 2'h3 == bp1_pos ? io_btb_lu_result_3_attr : _GEN_6; // @[src/main/scala/fpga/FetchPredictor.scala 245:{21,21}]
  assign io_ru_is_ret = 2'h3 == bp1_pos ? io_btb_lu_result_3_is_ret : _GEN_18; // @[src/main/scala/fpga/FetchPredictor.scala 246:{21,21}]
  assign io_ru_target = _GEN_7 == 2'h0 ? io_ras_top_ret_pc : _GEN_11; // @[src/main/scala/fpga/FetchPredictor.scala 237:25]
  assign io_zbtb_lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 200:19]
  assign io_zbtb_up_en = io_cr_upd_en & _io_btb_up_upd_target_T_3; // @[src/main/scala/fpga/FetchPredictor.scala 397:39]
  assign io_zbtb_up_pc = io_cr_upd_latter_pc; // @[src/main/scala/fpga/FetchPredictor.scala 398:23]
  assign io_zbtb_up_target = io_cr_target; // @[src/main/scala/fpga/FetchPredictor.scala 399:23]
  assign io_zbtb_inv_en = _io_re_en_T & bp0_en & ~_GEN_24 & ~_GEN_28 & bp0_pos <= bp1_pos; // @[src/main/scala/fpga/FetchPredictor.scala 275:106]
  assign io_zbtb_inv_pc = {reg_iaddr_index[30:2],bp0_pos}; // @[src/main/scala/common/UIntExtension.scala 13:89]
  assign io_btb_lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 222:18]
  assign io_btb_up_en = io_cr_en & _io_btb_up_en_T_9; // @[src/main/scala/fpga/FetchPredictor.scala 340:30]
  assign io_btb_up_pc = io_cr_upd_latter_pc; // @[src/main/scala/fpga/FetchPredictor.scala 349:26]
  assign io_btb_up_attr = io_cr_upd_attr; // @[src/main/scala/fpga/FetchPredictor.scala 347:26]
  assign io_btb_up_is_ret = io_cr_upd_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 348:26]
  assign io_btb_up_upd_target = io_cr_upd_en & (io_cr_upd_br_taken | (_io_btb_up_en_T_5 | _io_btb_up_en_T_7)); // @[src/main/scala/fpga/FetchPredictor.scala 350:42]
  assign io_btb_up_target = io_cr_target; // @[src/main/scala/fpga/FetchPredictor.scala 351:26]
  assign io_pht__lu_pc = io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 223:18]
  assign io_pht__up_en = io_cr_upd_en & io_cr_upd_attr == 2'h1; // @[src/main/scala/fpga/FetchPredictor.scala 385:39]
  assign io_pht__up_history = io_cr_upd_history; // @[src/main/scala/fpga/FetchPredictor.scala 386:23]
  assign io_pht__up_pc = io_cr_upd_latter_pc; // @[src/main/scala/fpga/FetchPredictor.scala 387:23]
  assign io_pht__up_lcnt = io_cr_upd_br_taken ? updated_lcnt_lcnt_if_taken : updated_lcnt_lcnt_unless_taken; // @[src/main/scala/fpga/FetchPredictor.scala 309:10]
  assign io_pht__up_gcnt = io_cr_upd_br_taken ? updated_gcnt_gcnt_if_taken : updated_gcnt_gcnt_unless_taken; // @[src/main/scala/fpga/FetchPredictor.scala 325:10]
  assign io_pht__lmem_rdata = io_pht_lmem_rdata; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht__gmem_rdata = io_pht_gmem_rdata; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  assign io_pht__br_en = _io_ras_ret1_en_T_3 & _GEN_32; // @[src/main/scala/fpga/FetchPredictor.scala 289:72]
  assign io_pht__br_pc = {{23'd0}, _io_pht_br_pc_T_2}; // @[src/main/scala/fpga/FetchPredictor.scala 290:18]
  assign io_pht__br2_en = io_cr_upd_en & io_cr_upd_br_taken & (_T_53 | io_cr_fp_entry_attr != 2'h1); // @[src/main/scala/fpga/FetchPredictor.scala 392:62]
  assign io_pht__br2_history = io_cr_upd_history; // @[src/main/scala/fpga/FetchPredictor.scala 393:24]
  assign io_pht__br2_pc = io_cr_upd_latter_pc; // @[src/main/scala/fpga/FetchPredictor.scala 394:24]
  assign io_pht__res_en = io_cr_en & io_cr_mispred; // @[src/main/scala/fpga/FetchPredictor.scala 379:36]
  assign io_pht__res_history = io_cr_upd_history; // @[src/main/scala/fpga/FetchPredictor.scala 380:24]
  assign io_ras_ret1_en = _io_re_en_T & reg_iaddr_en & _bp0_en_T & _GEN_19; // @[src/main/scala/fpga/FetchPredictor.scala 279:79]
  assign io_ras_call1_en = _io_ras_ret1_en_T_3 & _GEN_7 == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 280:79]
  assign io_ras_call1_ret_pc = _io_ras_call1_ret_pc_T ? _io_ras_call1_ret_pc_T_4 : _io_ras_call1_ret_pc_T_9; // @[src/main/scala/fpga/FetchPredictor.scala 281:31]
  assign io_ras_up_en = io_cr_en & io_cr_mispred; // @[src/main/scala/fpga/FetchPredictor.scala 402:33]
  assign io_ras_ret2_en = io_cr_upd_en & io_cr_upd_is_ret; // @[src/main/scala/fpga/FetchPredictor.scala 405:41]
  assign io_ras_call2_en = io_cr_upd_en & _io_btb_up_en_T_7; // @[src/main/scala/fpga/FetchPredictor.scala 408:41]
  assign io_ras_call2_ret_pc = io_cr_upd_next_pc; // @[src/main/scala/fpga/FetchPredictor.scala 409:25]
  assign io_pht_lmem_ren = io_pht__lmem_ren; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht_lmem_wen = io_pht__lmem_wen; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht_lmem_raddr = io_pht__lmem_raddr; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht_lmem_waddr = io_pht__lmem_waddr; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht_lmem_wdata = io_pht__lmem_wdata; // @[src/main/scala/fpga/FetchPredictor.scala 182:15]
  assign io_pht_gmem_ren = io_pht__gmem_ren; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  assign io_pht_gmem_wen = io_pht__gmem_wen; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  assign io_pht_gmem_raddr = io_pht__gmem_raddr; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  assign io_pht_gmem_waddr = io_pht__gmem_waddr; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  assign io_pht_gmem_wdata = io_pht__gmem_wdata; // @[src/main/scala/fpga/FetchPredictor.scala 183:15]
  always @(posedge clock) begin
    reg_iaddr_en <= io_pr_iaddr_en; // @[src/main/scala/fpga/FetchPredictor.scala 186:34]
    reg_invalidate <= io_pr_invalidate; // @[src/main/scala/fpga/FetchPredictor.scala 187:34]
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 188:34]
      reg_iaddr_index <= 31'h0; // @[src/main/scala/fpga/FetchPredictor.scala 188:34]
    end else begin
      reg_iaddr_index <= io_pr_iaddr; // @[src/main/scala/fpga/FetchPredictor.scala 197:21]
    end
    reg_redirect_en <= io_pr_redirect_en; // @[src/main/scala/fpga/FetchPredictor.scala 189:34]
    reg_correct_enq <= io_pr_correct_enq; // @[src/main/scala/fpga/FetchPredictor.scala 190:34]
    reg_target_changed <= io_pr_target_changed; // @[src/main/scala/fpga/FetchPredictor.scala 191:37]
    reg_flush_en <= io_pr_flush_en; // @[src/main/scala/fpga/FetchPredictor.scala 192:34]
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 193:34]
      reg_fp_ptr <= io_re_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 193:34]
    end else if (_T_16 | reg_flush_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 268:25]
      reg_fp_ptr <= io_re_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 269:18]
    end
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 195:34]
      reg_ibmask <= 4'h0; // @[src/main/scala/fpga/FetchPredictor.scala 195:34]
    end else if (2'h2 == ibpos) begin // @[src/main/scala/fpga/FetchPredictor.scala 204:51]
      reg_ibmask <= 4'hc;
    end else if (2'h1 == ibpos) begin // @[src/main/scala/fpga/FetchPredictor.scala 204:51]
      reg_ibmask <= 4'he;
    end else if (2'h0 == ibpos) begin // @[src/main/scala/fpga/FetchPredictor.scala 204:51]
      reg_ibmask <= 4'hf;
    end else begin
      reg_ibmask <= 4'h8;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (bp0_en & ~reset) begin
          $fwrite(32'h80000002,"fp(%d).target := 0x%x, pc=0x%x bp0_pos = %d\n",io_pr_fp_ptr,_T,_T_1,bp0_pos); // @[src/main/scala/fpga/FetchPredictor.scala 219:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_io_ru_en_T_1 & _T_3) begin
          $fwrite(32'h80000002,"fp(%d).target := 0x%x, pc=0x%x bp1_pos = %d\n",io_pr_fp_ptr,_T_6,_T_1,bp1_pos); // @[src/main/scala/fpga/FetchPredictor.scala 250:13]
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
          $fwrite(32'h80000002,"io.cr.en           : %d\n",io_cr_en); // @[src/main/scala/fpga/FetchPredictor.scala 352:11]
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
          $fwrite(32'h80000002,"io.cr.fp_hit       : %d\n",io_cr_fp_hit); // @[src/main/scala/fpga/FetchPredictor.scala 353:11]
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
          $fwrite(32'h80000002,"io.cr.fp_e.attr    : %d\n",io_cr_fp_entry_attr); // @[src/main/scala/fpga/FetchPredictor.scala 354:11]
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
          $fwrite(32'h80000002,"io.cr.target       : 0x%x\n",_T_24); // @[src/main/scala/fpga/FetchPredictor.scala 355:11]
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
          $fwrite(32'h80000002,"io.cr.upd.en       : %d\n",io_cr_upd_en); // @[src/main/scala/fpga/FetchPredictor.scala 356:11]
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
          $fwrite(32'h80000002,"io.cr.gcnt_is_br   : %d\n",_io_btb_up_en_T_1); // @[src/main/scala/fpga/FetchPredictor.scala 357:11]
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
          $fwrite(32'h80000002,"io.cr.upd.attr     : %d\n",io_cr_upd_attr); // @[src/main/scala/fpga/FetchPredictor.scala 358:11]
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
          $fwrite(32'h80000002,"io.cr.upd.br_taken : %d\n",io_cr_upd_br_taken); // @[src/main/scala/fpga/FetchPredictor.scala 359:11]
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
          $fwrite(32'h80000002,"io.cr.upd.is_ret   : %d\n",io_cr_upd_is_ret); // @[src/main/scala/fpga/FetchPredictor.scala 360:11]
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
          $fwrite(32'h80000002,"io.cr.upd.latter_pc: 0x%x\n",_T_38); // @[src/main/scala/fpga/FetchPredictor.scala 361:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_43 & _T_48 & io_cr_upd_br_taken & _T_3) begin
          $fwrite(32'h80000002,"============= gcnt positive prediction success; lcnt:%d gcnt:%d\n",
            io_cr_upd_bp_entry_lcnt,io_cr_upd_bp_entry_gcnt); // @[src/main/scala/fpga/FetchPredictor.scala 365:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_33 & _T_59 & _T_3) begin
          $fwrite(32'h80000002,"############# gcnt positive prediction failure; lcnt:%d gcnt:%d\n",
            io_cr_upd_bp_entry_lcnt,io_cr_upd_bp_entry_gcnt); // @[src/main/scala/fpga/FetchPredictor.scala 367:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_43 & ~_T_48 & _T_58 & _T_59 & _T_3) begin
          $fwrite(32'h80000002,"============= gcnt negative prediction success; lcnt:%d gcnt:%d\n",
            io_cr_upd_bp_entry_lcnt,io_cr_upd_bp_entry_gcnt); // @[src/main/scala/fpga/FetchPredictor.scala 371:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_40 & ~_T_59 & _T_3) begin
          $fwrite(32'h80000002,"############# gcnt negative prediction failure; lcnt:%d gcnt:%d\n",
            io_cr_upd_bp_entry_lcnt,io_cr_upd_bp_entry_gcnt); // @[src/main/scala/fpga/FetchPredictor.scala 373:17]
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
  reg_iaddr_en = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  reg_invalidate = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  reg_iaddr_index = _RAND_2[30:0];
  _RAND_3 = {1{`RANDOM}};
  reg_redirect_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_correct_enq = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  reg_target_changed = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  reg_flush_en = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  reg_fp_ptr = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  reg_ibmask = _RAND_8[3:0];
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
  input         io_enq_en, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_enq_correct, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_enq_target_changed, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_enq_flush_en, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input  [7:0]  io_enq_history, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output [1:0]  io_enq_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output        io_enq_ready, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output        io_enq_left1, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_upd_en, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input  [1:0]  io_upd_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input  [1:0]  io_upd_attr, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_upd_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input  [30:0] io_upd_target, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input         io_deq_en, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  input  [1:0]  io_read_ptr, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output [1:0]  io_read_fp_entry_attr, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output        io_read_fp_entry_is_ret, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output [7:0]  io_read_fp_entry_history, // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
  output [30:0] io_read_fp_entry_target // @[src/main/scala/fpga/FetchPredictor.scala 48:14]
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
  reg [1:0] buf_attr [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_attr_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_attr_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  reg  buf_is_ret [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_is_ret_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_is_ret_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  reg [7:0] buf_history [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [7:0] buf_history_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_history_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_history_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  reg [30:0] buf_target [0:3]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_io_read_fp_entry_attr_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_io_read_fp_entry_attr_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_io_read_fp_entry_is_ret_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_io_read_fp_entry_is_ret_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_io_read_fp_entry_history_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_io_read_fp_entry_history_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_io_read_fp_entry_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_io_read_fp_entry_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_MPORT_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_MPORT_1_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_1_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_1_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_MPORT_2_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_2_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_2_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [30:0] buf_target_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire [1:0] buf_target_MPORT_3_addr; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_3_mask; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  wire  buf_target_MPORT_3_en; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  reg [2:0] enq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
  reg [2:0] deq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 57:24]
  wire [2:0] _ready_T_1 = enq_ptr - deq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 59:25]
  wire  ready = ~_ready_T_1[2]; // @[src/main/scala/fpga/FetchPredictor.scala 59:15]
  wire [2:0] _enq_ptr_T_1 = enq_ptr + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 67:24]
  wire [2:0] _deq_ptr_T_1 = deq_ptr + 3'h1; // @[src/main/scala/fpga/FetchPredictor.scala 70:24]
  wire  _T_8 = ~reset; // @[src/main/scala/fpga/FetchPredictor.scala 71:11]
  wire [31:0] _T_15 = {io_upd_target,1'h0}; // @[src/main/scala/common/UIntExtension.scala 10:33]
  assign buf_attr_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_attr_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_is_ret_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_attr_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_history_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_attr_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_attr_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_attr_io_read_fp_entry_target_MPORT_data = buf_attr[buf_attr_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
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
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_attr_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_is_ret_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_is_ret_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_history_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_is_ret_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_is_ret_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_is_ret_io_read_fp_entry_target_MPORT_data = buf_is_ret[buf_is_ret_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
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
  assign buf_history_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_attr_MPORT_data = buf_history[buf_history_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_history_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_is_ret_MPORT_data = buf_history[buf_history_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_history_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_history_MPORT_data = buf_history[buf_history_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_history_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_history_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_history_io_read_fp_entry_target_MPORT_data = buf_history[buf_history_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_history_MPORT_data = io_enq_history;
  assign buf_history_MPORT_addr = enq_ptr[1:0];
  assign buf_history_MPORT_mask = 1'h1;
  assign buf_history_MPORT_en = ready | io_enq_flush_en;
  assign buf_history_MPORT_1_data = 8'h0;
  assign buf_history_MPORT_1_addr = io_upd_ptr;
  assign buf_history_MPORT_1_mask = 1'h0;
  assign buf_history_MPORT_1_en = io_upd_en;
  assign buf_history_MPORT_2_data = 8'h0;
  assign buf_history_MPORT_2_addr = io_upd_ptr;
  assign buf_history_MPORT_2_mask = 1'h0;
  assign buf_history_MPORT_2_en = io_upd_en;
  assign buf_history_MPORT_3_data = 8'h0;
  assign buf_history_MPORT_3_addr = io_upd_ptr;
  assign buf_history_MPORT_3_mask = 1'h0;
  assign buf_history_MPORT_3_en = io_upd_en;
  assign buf_target_io_read_fp_entry_attr_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_attr_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_attr_MPORT_data = buf_target[buf_target_io_read_fp_entry_attr_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_target_io_read_fp_entry_is_ret_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_is_ret_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_is_ret_MPORT_data = buf_target[buf_target_io_read_fp_entry_is_ret_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_target_io_read_fp_entry_history_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_history_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_history_MPORT_data = buf_target[buf_target_io_read_fp_entry_history_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
  assign buf_target_io_read_fp_entry_target_MPORT_en = 1'h1;
  assign buf_target_io_read_fp_entry_target_MPORT_addr = io_read_ptr;
  assign buf_target_io_read_fp_entry_target_MPORT_data = buf_target[buf_target_io_read_fp_entry_target_MPORT_addr]; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
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
  assign buf_target_MPORT_3_data = io_upd_target;
  assign buf_target_MPORT_3_addr = io_upd_ptr;
  assign buf_target_MPORT_3_mask = 1'h1;
  assign buf_target_MPORT_3_en = io_upd_en;
  assign io_enq_ptr = enq_ptr[1:0]; // @[src/main/scala/fpga/FetchPredictor.scala 62:16]
  assign io_enq_ready = ~_ready_T_1[2]; // @[src/main/scala/fpga/FetchPredictor.scala 59:15]
  assign io_enq_left1 = _ready_T_1[1:0] == 2'h3; // @[src/main/scala/fpga/FetchPredictor.scala 61:57]
  assign io_read_fp_entry_attr = buf_attr_io_read_fp_entry_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 92:30]
  assign io_read_fp_entry_is_ret = buf_is_ret_io_read_fp_entry_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 93:30]
  assign io_read_fp_entry_history = buf_history_io_read_fp_entry_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 94:30]
  assign io_read_fp_entry_target = buf_target_io_read_fp_entry_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 95:30]
  always @(posedge clock) begin
    if (buf_attr_MPORT_en & buf_attr_MPORT_mask) begin
      buf_attr[buf_attr_MPORT_addr] <= buf_attr_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_attr_MPORT_1_en & buf_attr_MPORT_1_mask) begin
      buf_attr[buf_attr_MPORT_1_addr] <= buf_attr_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_attr_MPORT_2_en & buf_attr_MPORT_2_mask) begin
      buf_attr[buf_attr_MPORT_2_addr] <= buf_attr_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_attr_MPORT_3_en & buf_attr_MPORT_3_mask) begin
      buf_attr[buf_attr_MPORT_3_addr] <= buf_attr_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_is_ret_MPORT_en & buf_is_ret_MPORT_mask) begin
      buf_is_ret[buf_is_ret_MPORT_addr] <= buf_is_ret_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_is_ret_MPORT_1_en & buf_is_ret_MPORT_1_mask) begin
      buf_is_ret[buf_is_ret_MPORT_1_addr] <= buf_is_ret_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_is_ret_MPORT_2_en & buf_is_ret_MPORT_2_mask) begin
      buf_is_ret[buf_is_ret_MPORT_2_addr] <= buf_is_ret_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_is_ret_MPORT_3_en & buf_is_ret_MPORT_3_mask) begin
      buf_is_ret[buf_is_ret_MPORT_3_addr] <= buf_is_ret_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_history_MPORT_en & buf_history_MPORT_mask) begin
      buf_history[buf_history_MPORT_addr] <= buf_history_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_history_MPORT_1_en & buf_history_MPORT_1_mask) begin
      buf_history[buf_history_MPORT_1_addr] <= buf_history_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_history_MPORT_2_en & buf_history_MPORT_2_mask) begin
      buf_history[buf_history_MPORT_2_addr] <= buf_history_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_history_MPORT_3_en & buf_history_MPORT_3_mask) begin
      buf_history[buf_history_MPORT_3_addr] <= buf_history_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_target_MPORT_en & buf_target_MPORT_mask) begin
      buf_target[buf_target_MPORT_addr] <= buf_target_MPORT_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_target_MPORT_1_en & buf_target_MPORT_1_mask) begin
      buf_target[buf_target_MPORT_1_addr] <= buf_target_MPORT_1_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_target_MPORT_2_en & buf_target_MPORT_2_mask) begin
      buf_target[buf_target_MPORT_2_addr] <= buf_target_MPORT_2_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (buf_target_MPORT_3_en & buf_target_MPORT_3_mask) begin
      buf_target[buf_target_MPORT_3_addr] <= buf_target_MPORT_3_data; // @[src/main/scala/fpga/FetchPredictor.scala 55:16]
    end
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
      enq_ptr <= 3'h0; // @[src/main/scala/fpga/FetchPredictor.scala 56:24]
    end else if (io_enq_en & ~io_enq_correct & ~io_enq_target_changed | io_enq_flush_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 66:86]
      enq_ptr <= _enq_ptr_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 67:13]
    end
    if (reset) begin // @[src/main/scala/fpga/FetchPredictor.scala 57:24]
      deq_ptr <= 3'h0; // @[src/main/scala/fpga/FetchPredictor.scala 57:24]
    end else if (io_enq_flush_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 78:26]
      deq_ptr <= enq_ptr; // @[src/main/scala/fpga/FetchPredictor.scala 79:13]
    end else if (io_deq_en) begin // @[src/main/scala/fpga/FetchPredictor.scala 69:20]
      deq_ptr <= _deq_ptr_T_1; // @[src/main/scala/fpga/FetchPredictor.scala 70:13]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_deq_en & ~reset) begin
          $fwrite(32'h80000002,"fp deq_ptr=%d\n",deq_ptr); // @[src/main/scala/fpga/FetchPredictor.scala 71:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_8) begin
          $fwrite(32'h80000002,"redir enq_ptr = %d\n",enq_ptr); // @[src/main/scala/fpga/FetchPredictor.scala 81:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_8) begin
          $fwrite(32'h80000002,"redir deq_ptr = %d\n",deq_ptr); // @[src/main/scala/fpga/FetchPredictor.scala 82:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_upd_en & _T_8) begin
          $fwrite(32'h80000002,"fp(%d).attr   := %d   is_ret := %d\n",io_upd_ptr,io_upd_attr,io_upd_is_ret); // @[src/main/scala/fpga/FetchPredictor.scala 88:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_upd_en & _T_8) begin
          $fwrite(32'h80000002,"fp(%d).target := 0x%x\n",io_upd_ptr,_T_15); // @[src/main/scala/fpga/FetchPredictor.scala 89:11]
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
    buf_history[initvar] = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    buf_target[initvar] = _RAND_3[30:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  enq_ptr = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  deq_ptr = _RAND_5[2:0];
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
  input         io_ft_flush_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_ft_flush_iaddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst1_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_ft_inst1_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [31:0] io_ft_inst1_data, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst1_bpfailed, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst1_redirected, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst1_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst1_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst1_fp_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_ft_inst1_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst2_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_ft_inst2_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [31:0] io_ft_inst2_data, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst2_bpfailed, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_inst2_redirected, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst2_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst2_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_ft_inst2_fp_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_ft_inst2_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_imem_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [31:0] io_ft_imem_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [63:0] io_ft_imem_inst, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_ft_imem_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_icache_addr_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [31:0] io_ft_icache_addr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_ft_icache_addr_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [63:0] io_ft_icache_idata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_ft_icache_idata_valid, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ft_icache_idata_ready, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_upd_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_cr_upd_latter_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_cr_upd_bp_entry_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_cr_upd_bp_entry_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [7:0]  io_cr_upd_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_upd_br_taken, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_cr_upd_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_upd_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_cr_upd_next_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_cr_fp_entry_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_fp_entry_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [7:0]  io_cr_fp_entry_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_cr_fp_entry_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_fp_hit, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_cr_mispred, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_cr_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_redir_deq_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_redir_read_ptr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_redir_read_fp_entry_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_redir_read_fp_entry_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_redir_read_fp_entry_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_redir_read_fp_entry_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_zbtb_lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_zbtb_lu_matches_0, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_zbtb_lu_matches_1, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_zbtb_lu_matches_2, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_zbtb_lu_matches_3, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_zbtb_lu_target_0, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_zbtb_lu_target_1, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_zbtb_lu_target_2, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_zbtb_lu_target_3, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_zbtb_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_zbtb_up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_zbtb_up_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_zbtb_inv_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_zbtb_inv_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_btb_lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_0_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_0_br, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_btb_lu_result_0_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_0_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_btb_lu_result_0_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_1_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_1_br, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_btb_lu_result_1_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_1_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_btb_lu_result_1_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_2_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_2_br, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_btb_lu_result_2_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_2_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_btb_lu_result_2_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_3_jump, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_3_br, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_btb_lu_result_3_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_btb_lu_result_3_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_btb_lu_result_3_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_btb_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_btb_up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_btb_up_attr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_btb_up_is_ret, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_btb_up_upd_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_btb_up_target, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_pht__lu_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lu_taken_0, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lu_taken_1, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lu_taken_2, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lu_taken_3, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_lcnt_0, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_lcnt_1, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_lcnt_2, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_lcnt_3, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_gcnt_0, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_gcnt_1, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_gcnt_2, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lu_gcnt_3, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht__up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_pht__up_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_pht__up_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_pht__up_lcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_pht__up_gcnt, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__lmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [10:0] io_pht__lmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_pht__lmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [12:0] io_pht__lmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__lmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__gmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input         io_pht__gmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [10:0] io_pht__gmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_pht__gmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [12:0] io_pht__gmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [1:0]  io_pht__gmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht__br_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_pht__br_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht__br2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_pht__br2_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_pht__br2_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [7:0]  io_pht__history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht__res_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [7:0]  io_pht__res_history, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [30:0] io_ras_top_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ras_ret1_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ras_call1_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_ras_call1_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ras_up_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ras_ret2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_ras_call2_en, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [30:0] io_ras_call2_ret_pc, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht_lmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht_lmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [10:0] io_pht_lmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [7:0]  io_pht_lmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [12:0] io_pht_lmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_pht_lmem_wdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht_gmem_ren, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output        io_pht_gmem_wen, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [10:0] io_pht_gmem_raddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  input  [7:0]  io_pht_gmem_rdata, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [12:0] io_pht_gmem_waddr, // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
  output [1:0]  io_pht_gmem_wdata // @[src/main/scala/fpga/sim/FetchSim.scala 20:14]
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
`endif // RANDOMIZE_REG_INIT
  wire  fetcher_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_ft_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [31:0] fetcher_io_ft_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst1_bpfailed; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst1_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst1_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst1_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst1_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_ft_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [31:0] fetcher_io_ft_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst2_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst2_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst2_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_ft_inst2_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [31:0] fetcher_io_ft_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [63:0] fetcher_io_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [31:0] fetcher_io_ft_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [63:0] fetcher_io_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_invalidate; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_correct_enq; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fetcher_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [30:0] fetcher_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [1:0] fetcher_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire [2:0] fetcher_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
  wire  fp_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_invalidate; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_correct_enq; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [2:0] fp_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_cr_upd_latter_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_cr_upd_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_cr_upd_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_cr_upd_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_upd_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_cr_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_cr_upd_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_correct; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_re_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_re_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_re_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ru_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_ru_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_ru_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ru_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_ru_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_zbtb_inv_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_zbtb_inv_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_btb_up_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_up_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_btb_up_upd_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_btb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pht__lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__up_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pht__up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__up_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__up_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [10:0] fp_io_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [12:0] fp_io_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [10:0] fp_io_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [12:0] fp_io_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__br_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pht__br_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__br2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__br2_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_pht__br2_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht__res_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht__res_history; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ras_ret1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ras_call1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_ras_call1_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ras_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ras_ret2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_ras_call2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [30:0] fp_io_ras_call2_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht_lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht_lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [10:0] fp_io_pht_lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [12:0] fp_io_pht_lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht_lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht_gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  fp_io_pht_gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [10:0] fp_io_pht_gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [7:0] fp_io_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [12:0] fp_io_pht_gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire [1:0] fp_io_pht_gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
  wire  rb_clock; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_correct; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [7:0] rb_io_enq_history; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [1:0] rb_io_enq_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_enq_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [1:0] rb_io_upd_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [1:0] rb_io_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [30:0] rb_io_upd_target; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [1:0] rb_io_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [1:0] rb_io_read_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire  rb_io_read_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [7:0] rb_io_read_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  wire [30:0] rb_io_read_fp_entry_target; // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
  reg  reg_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [30:0] reg_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [63:0] reg_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg [63:0] reg_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 32:27]
  reg  reg_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_cr_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [30:0] reg_cr_upd_latter_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [1:0] reg_cr_upd_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [1:0] reg_cr_upd_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_cr_upd_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [1:0] reg_cr_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_cr_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [30:0] reg_cr_upd_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [1:0] reg_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [7:0] reg_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg [30:0] reg_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 33:27]
  reg  reg_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 34:27]
  reg [1:0] reg_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 35:27]
  reg  reg_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg [30:0] reg_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 36:27]
  reg  reg_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [30:0] reg_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [30:0] reg_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [30:0] reg_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [1:0] reg_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg [30:0] reg_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 37:27]
  reg  reg_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [10:0] reg_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [12:0] reg_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg  reg_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [10:0] reg_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [12:0] reg_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [1:0] reg_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [7:0] reg_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 38:27]
  reg [30:0] reg_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 39:27]
  reg [7:0] reg_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 40:27]
  reg [7:0] reg_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 41:27]
  reg  reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 42:31]
  Fetcher fetcher ( // @[src/main/scala/fpga/sim/FetchSim.scala 44:23]
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
    .io_pr_invalidate(fetcher_io_pr_invalidate),
    .io_pr_redirect_en(fetcher_io_pr_redirect_en),
    .io_pr_correct_enq(fetcher_io_pr_correct_enq),
    .io_pr_target_changed(fetcher_io_pr_target_changed),
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
  FetchPredictor fp ( // @[src/main/scala/fpga/sim/FetchSim.scala 45:18]
    .clock(fp_clock),
    .reset(fp_reset),
    .io_pr_iaddr_en(fp_io_pr_iaddr_en),
    .io_pr_iaddr(fp_io_pr_iaddr),
    .io_pr_flush_en(fp_io_pr_flush_en),
    .io_pr_invalidate(fp_io_pr_invalidate),
    .io_pr_redirect_en(fp_io_pr_redirect_en),
    .io_pr_correct_enq(fp_io_pr_correct_enq),
    .io_pr_target_changed(fp_io_pr_target_changed),
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
    .io_cr_upd_en(fp_io_cr_upd_en),
    .io_cr_upd_latter_pc(fp_io_cr_upd_latter_pc),
    .io_cr_upd_bp_entry_lcnt(fp_io_cr_upd_bp_entry_lcnt),
    .io_cr_upd_bp_entry_gcnt(fp_io_cr_upd_bp_entry_gcnt),
    .io_cr_upd_history(fp_io_cr_upd_history),
    .io_cr_upd_br_taken(fp_io_cr_upd_br_taken),
    .io_cr_upd_attr(fp_io_cr_upd_attr),
    .io_cr_upd_is_ret(fp_io_cr_upd_is_ret),
    .io_cr_upd_next_pc(fp_io_cr_upd_next_pc),
    .io_cr_fp_entry_attr(fp_io_cr_fp_entry_attr),
    .io_cr_fp_hit(fp_io_cr_fp_hit),
    .io_cr_mispred(fp_io_cr_mispred),
    .io_cr_target(fp_io_cr_target),
    .io_re_en(fp_io_re_en),
    .io_re_correct(fp_io_re_correct),
    .io_re_target_changed(fp_io_re_target_changed),
    .io_re_flush_en(fp_io_re_flush_en),
    .io_re_history(fp_io_re_history),
    .io_re_ptr(fp_io_re_ptr),
    .io_re_ready(fp_io_re_ready),
    .io_re_left1(fp_io_re_left1),
    .io_ru_en(fp_io_ru_en),
    .io_ru_ptr(fp_io_ru_ptr),
    .io_ru_attr(fp_io_ru_attr),
    .io_ru_is_ret(fp_io_ru_is_ret),
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
    .io_btb_up_upd_target(fp_io_btb_up_upd_target),
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
    .io_ras_ret1_en(fp_io_ras_ret1_en),
    .io_ras_call1_en(fp_io_ras_call1_en),
    .io_ras_call1_ret_pc(fp_io_ras_call1_ret_pc),
    .io_ras_up_en(fp_io_ras_up_en),
    .io_ras_ret2_en(fp_io_ras_ret2_en),
    .io_ras_call2_en(fp_io_ras_call2_en),
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
  FetchRedirectBuffer rb ( // @[src/main/scala/fpga/sim/FetchSim.scala 46:18]
    .clock(rb_clock),
    .reset(rb_reset),
    .io_enq_en(rb_io_enq_en),
    .io_enq_correct(rb_io_enq_correct),
    .io_enq_target_changed(rb_io_enq_target_changed),
    .io_enq_flush_en(rb_io_enq_flush_en),
    .io_enq_history(rb_io_enq_history),
    .io_enq_ptr(rb_io_enq_ptr),
    .io_enq_ready(rb_io_enq_ready),
    .io_enq_left1(rb_io_enq_left1),
    .io_upd_en(rb_io_upd_en),
    .io_upd_ptr(rb_io_upd_ptr),
    .io_upd_attr(rb_io_upd_attr),
    .io_upd_is_ret(rb_io_upd_is_ret),
    .io_upd_target(rb_io_upd_target),
    .io_deq_en(rb_io_deq_en),
    .io_read_ptr(rb_io_read_ptr),
    .io_read_fp_entry_attr(rb_io_read_fp_entry_attr),
    .io_read_fp_entry_is_ret(rb_io_read_fp_entry_is_ret),
    .io_read_fp_entry_history(rb_io_read_fp_entry_history),
    .io_read_fp_entry_target(rb_io_read_fp_entry_target)
  );
  assign io_ft_inst1_valid = fetcher_io_ft_inst1_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_addr = fetcher_io_ft_inst1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_data = fetcher_io_ft_inst1_data; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_bpfailed = fetcher_io_ft_inst1_bpfailed; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_redirected = fetcher_io_ft_inst1_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_bp_entry_lcnt = fetcher_io_ft_inst1_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_bp_entry_gcnt = fetcher_io_ft_inst1_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst1_fp_ptr = fetcher_io_ft_inst1_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_valid = fetcher_io_ft_inst2_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_addr = fetcher_io_ft_inst2_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_data = fetcher_io_ft_inst2_data; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_bpfailed = 1'h0; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_redirected = fetcher_io_ft_inst2_redirected; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_bp_entry_lcnt = fetcher_io_ft_inst2_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_bp_entry_gcnt = fetcher_io_ft_inst2_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_inst2_fp_ptr = fetcher_io_ft_inst2_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_imem_en = fetcher_io_ft_imem_en; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_imem_addr = fetcher_io_ft_imem_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_icache_addr_en = fetcher_io_ft_icache_addr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_icache_addr = fetcher_io_ft_icache_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_ft_icache_idata_ready = 1'h1; // @[src/main/scala/fpga/sim/FetchSim.scala 112:18]
  assign io_redir_read_fp_entry_attr = rb_io_read_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_redir_read_fp_entry_is_ret = rb_io_read_fp_entry_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_redir_read_fp_entry_history = rb_io_read_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_redir_read_fp_entry_target = rb_io_read_fp_entry_target; // @[src/main/scala/fpga/sim/FetchSim.scala 115:18]
  assign io_zbtb_lu_pc = fp_io_zbtb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_zbtb_up_en = fp_io_zbtb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_zbtb_up_pc = fp_io_zbtb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_zbtb_up_target = fp_io_zbtb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_zbtb_inv_en = fp_io_zbtb_inv_en; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_zbtb_inv_pc = fp_io_zbtb_inv_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 117:18]
  assign io_btb_lu_pc = fp_io_btb_lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_en = fp_io_btb_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_pc = fp_io_btb_up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_attr = fp_io_btb_up_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_is_ret = fp_io_btb_up_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_upd_target = fp_io_btb_up_upd_target; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_btb_up_target = fp_io_btb_up_target; // @[src/main/scala/fpga/sim/FetchSim.scala 118:18]
  assign io_pht__lu_pc = fp_io_pht__lu_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__up_en = fp_io_pht__up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__up_history = fp_io_pht__up_history; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__up_pc = fp_io_pht__up_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__up_lcnt = fp_io_pht__up_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__up_gcnt = fp_io_pht__up_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__lmem_rdata = fp_io_pht__lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__gmem_rdata = fp_io_pht__gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__br_en = fp_io_pht__br_en; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__br_pc = fp_io_pht__br_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__br2_en = fp_io_pht__br2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__br2_history = fp_io_pht__br2_history; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__br2_pc = fp_io_pht__br2_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__res_en = fp_io_pht__res_en; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_pht__res_history = fp_io_pht__res_history; // @[src/main/scala/fpga/sim/FetchSim.scala 119:18]
  assign io_ras_ret1_en = fp_io_ras_ret1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_call1_en = fp_io_ras_call1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_call1_ret_pc = fp_io_ras_call1_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_up_en = fp_io_ras_up_en; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_ret2_en = fp_io_ras_ret2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_call2_en = fp_io_ras_call2_en; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_ras_call2_ret_pc = fp_io_ras_call2_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 120:18]
  assign io_pht_lmem_ren = fp_io_pht_lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 121:18]
  assign io_pht_lmem_wen = fp_io_pht_lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 121:18]
  assign io_pht_lmem_raddr = fp_io_pht_lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 121:18]
  assign io_pht_lmem_waddr = fp_io_pht_lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 121:18]
  assign io_pht_lmem_wdata = fp_io_pht_lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 121:18]
  assign io_pht_gmem_ren = fp_io_pht_gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 122:18]
  assign io_pht_gmem_wen = fp_io_pht_gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 122:18]
  assign io_pht_gmem_raddr = fp_io_pht_gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 122:18]
  assign io_pht_gmem_waddr = fp_io_pht_gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 122:18]
  assign io_pht_gmem_wdata = fp_io_pht_gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 122:18]
  assign fetcher_clock = clock;
  assign fetcher_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 48:33]
  assign fetcher_io_ft_flush_en = reg_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 51:36]
  assign fetcher_io_ft_flush_iaddr = reg_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 59:36]
  assign fetcher_io_ft_inst1_ready = reg_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 57:36]
  assign fetcher_io_ft_inst2_ready = reg_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 52:36]
  assign fetcher_io_ft_imem_inst = reg_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 53:36]
  assign fetcher_io_ft_imem_valid = reg_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 56:36]
  assign fetcher_io_ft_icache_addr_ready = reg_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 54:36]
  assign fetcher_io_ft_icache_idata = reg_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 55:36]
  assign fetcher_io_ft_icache_idata_valid = reg_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 58:36]
  assign fetcher_io_pr_redirect_ready = fp_io_pr_redirect_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp0_en = fp_io_pr_bp0_en; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp0_pos = fp_io_pr_bp0_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp0_addr = fp_io_pr_bp0_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp1_en = fp_io_pr_bp1_en; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp1_pos = fp_io_pr_bp1_pos; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp1_addr = fp_io_pr_bp1_addr; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_0_lcnt = fp_io_pr_bp_entries_0_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_0_gcnt = fp_io_pr_bp_entries_0_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_1_lcnt = fp_io_pr_bp_entries_1_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_1_gcnt = fp_io_pr_bp_entries_1_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_2_lcnt = fp_io_pr_bp_entries_2_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_2_gcnt = fp_io_pr_bp_entries_2_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_3_lcnt = fp_io_pr_bp_entries_3_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_bp_entries_3_gcnt = fp_io_pr_bp_entries_3_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fetcher_io_pr_fp_ptr = fp_io_pr_fp_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_clock = clock;
  assign fp_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 49:28]
  assign fp_io_pr_iaddr_en = fetcher_io_pr_iaddr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_iaddr = fetcher_io_pr_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_flush_en = fetcher_io_pr_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_invalidate = fetcher_io_pr_invalidate; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_redirect_en = fetcher_io_pr_redirect_en; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_correct_enq = fetcher_io_pr_correct_enq; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_pr_target_changed = fetcher_io_pr_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 96:12]
  assign fp_io_cr_en = reg_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 60:36]
  assign fp_io_cr_upd_en = reg_cr_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 65:36]
  assign fp_io_cr_upd_latter_pc = reg_cr_upd_latter_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 66:36]
  assign fp_io_cr_upd_bp_entry_lcnt = reg_cr_upd_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 67:36]
  assign fp_io_cr_upd_bp_entry_gcnt = reg_cr_upd_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 67:36]
  assign fp_io_cr_upd_history = reg_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 68:36]
  assign fp_io_cr_upd_br_taken = reg_cr_upd_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 69:36]
  assign fp_io_cr_upd_attr = reg_cr_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 70:36]
  assign fp_io_cr_upd_is_ret = reg_cr_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 71:36]
  assign fp_io_cr_upd_next_pc = reg_cr_upd_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 72:36]
  assign fp_io_cr_fp_entry_attr = reg_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 61:36]
  assign fp_io_cr_fp_hit = reg_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 62:36]
  assign fp_io_cr_mispred = reg_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 63:36]
  assign fp_io_cr_target = reg_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 64:36]
  assign fp_io_re_ptr = rb_io_enq_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign fp_io_re_ready = rb_io_enq_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign fp_io_re_left1 = rb_io_enq_left1; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign fp_io_zbtb_lu_matches_0 = reg_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_zbtb_lu_matches_1 = reg_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_zbtb_lu_matches_2 = reg_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_zbtb_lu_matches_3 = reg_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 75:36]
  assign fp_io_zbtb_lu_target_0 = reg_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_zbtb_lu_target_1 = reg_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_zbtb_lu_target_2 = reg_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_zbtb_lu_target_3 = reg_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 76:36]
  assign fp_io_btb_lu_result_0_jump = reg_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_0_br = reg_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_0_attr = reg_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_0_is_ret = reg_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_0_target = reg_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_1_jump = reg_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_1_br = reg_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_1_attr = reg_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_1_is_ret = reg_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_1_target = reg_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_2_jump = reg_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_2_br = reg_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_2_attr = reg_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_2_is_ret = reg_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_2_target = reg_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_3_jump = reg_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_3_br = reg_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_3_attr = reg_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_3_is_ret = reg_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_btb_lu_result_3_target = reg_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 77:36]
  assign fp_io_pht__lu_taken_0 = reg_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 78:36]
  assign fp_io_pht__lu_taken_1 = reg_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 78:36]
  assign fp_io_pht__lu_taken_2 = reg_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 78:36]
  assign fp_io_pht__lu_taken_3 = reg_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 78:36]
  assign fp_io_pht__lu_lcnt_0 = reg_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 79:36]
  assign fp_io_pht__lu_lcnt_1 = reg_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 79:36]
  assign fp_io_pht__lu_lcnt_2 = reg_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 79:36]
  assign fp_io_pht__lu_lcnt_3 = reg_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 79:36]
  assign fp_io_pht__lu_gcnt_0 = reg_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 80:36]
  assign fp_io_pht__lu_gcnt_1 = reg_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 80:36]
  assign fp_io_pht__lu_gcnt_2 = reg_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 80:36]
  assign fp_io_pht__lu_gcnt_3 = reg_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 80:36]
  assign fp_io_pht__lmem_ren = reg_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 81:36]
  assign fp_io_pht__lmem_wen = reg_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 82:36]
  assign fp_io_pht__lmem_raddr = reg_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 83:36]
  assign fp_io_pht__lmem_waddr = reg_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 84:36]
  assign fp_io_pht__lmem_wdata = reg_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 85:36]
  assign fp_io_pht__gmem_ren = reg_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 86:36]
  assign fp_io_pht__gmem_wen = reg_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 87:36]
  assign fp_io_pht__gmem_raddr = reg_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 88:36]
  assign fp_io_pht__gmem_waddr = reg_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 89:36]
  assign fp_io_pht__gmem_wdata = reg_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 90:36]
  assign fp_io_pht__history = reg_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 91:36]
  assign fp_io_ras_top_ret_pc = reg_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 92:36]
  assign fp_io_pht_lmem_rdata = reg_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 93:36]
  assign fp_io_pht_gmem_rdata = reg_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 94:36]
  assign rb_clock = clock;
  assign rb_reset = reset | reg_reset; // @[src/main/scala/fpga/sim/FetchSim.scala 50:28]
  assign rb_io_enq_en = fp_io_re_en; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign rb_io_enq_correct = fp_io_re_correct; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign rb_io_enq_target_changed = fp_io_re_target_changed; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign rb_io_enq_flush_en = fp_io_re_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign rb_io_enq_history = fp_io_re_history; // @[src/main/scala/fpga/sim/FetchSim.scala 97:12]
  assign rb_io_upd_en = fp_io_ru_en; // @[src/main/scala/fpga/sim/FetchSim.scala 98:12]
  assign rb_io_upd_ptr = fp_io_ru_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 98:12]
  assign rb_io_upd_attr = fp_io_ru_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 98:12]
  assign rb_io_upd_is_ret = fp_io_ru_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 98:12]
  assign rb_io_upd_target = fp_io_ru_target; // @[src/main/scala/fpga/sim/FetchSim.scala 98:12]
  assign rb_io_deq_en = reg_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 73:36]
  assign rb_io_read_ptr = reg_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 74:36]
  always @(posedge clock) begin
    reg_ft_flush_en <= io_ft_flush_en; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_flush_iaddr <= io_ft_flush_iaddr; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_inst1_ready <= io_ft_inst1_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_inst2_ready <= io_ft_inst2_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_imem_inst <= io_ft_imem_inst; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_imem_valid <= io_ft_imem_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_icache_addr_ready <= io_ft_icache_addr_ready; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_icache_idata <= io_ft_icache_idata; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_ft_icache_idata_valid <= io_ft_icache_idata_valid; // @[src/main/scala/fpga/sim/FetchSim.scala 101:18]
    reg_cr_en <= io_cr_en; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_en <= io_cr_upd_en; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_latter_pc <= io_cr_upd_latter_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_bp_entry_lcnt <= io_cr_upd_bp_entry_lcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_bp_entry_gcnt <= io_cr_upd_bp_entry_gcnt; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_br_taken <= io_cr_upd_br_taken; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_attr <= io_cr_upd_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_is_ret <= io_cr_upd_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_upd_next_pc <= io_cr_upd_next_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_fp_entry_attr <= io_cr_fp_entry_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_fp_entry_history <= io_cr_fp_entry_history; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_fp_hit <= io_cr_fp_hit; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_mispred <= io_cr_mispred; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_cr_target <= io_cr_target; // @[src/main/scala/fpga/sim/FetchSim.scala 102:18]
    reg_redir_deq_en <= io_redir_deq_en; // @[src/main/scala/fpga/sim/FetchSim.scala 103:18]
    reg_redir_read_ptr <= io_redir_read_ptr; // @[src/main/scala/fpga/sim/FetchSim.scala 104:18]
    reg_zbtb_lu_matches_0 <= io_zbtb_lu_matches_0; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_matches_1 <= io_zbtb_lu_matches_1; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_matches_2 <= io_zbtb_lu_matches_2; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_matches_3 <= io_zbtb_lu_matches_3; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_target_0 <= io_zbtb_lu_target_0; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_target_1 <= io_zbtb_lu_target_1; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_target_2 <= io_zbtb_lu_target_2; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_zbtb_lu_target_3 <= io_zbtb_lu_target_3; // @[src/main/scala/fpga/sim/FetchSim.scala 105:18]
    reg_btb_lu_result_0_jump <= io_btb_lu_result_0_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_0_br <= io_btb_lu_result_0_br; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_0_attr <= io_btb_lu_result_0_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_0_is_ret <= io_btb_lu_result_0_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_0_target <= io_btb_lu_result_0_target; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_1_jump <= io_btb_lu_result_1_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_1_br <= io_btb_lu_result_1_br; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_1_attr <= io_btb_lu_result_1_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_1_is_ret <= io_btb_lu_result_1_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_1_target <= io_btb_lu_result_1_target; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_2_jump <= io_btb_lu_result_2_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_2_br <= io_btb_lu_result_2_br; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_2_attr <= io_btb_lu_result_2_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_2_is_ret <= io_btb_lu_result_2_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_2_target <= io_btb_lu_result_2_target; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_3_jump <= io_btb_lu_result_3_jump; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_3_br <= io_btb_lu_result_3_br; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_3_attr <= io_btb_lu_result_3_attr; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_3_is_ret <= io_btb_lu_result_3_is_ret; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_btb_lu_result_3_target <= io_btb_lu_result_3_target; // @[src/main/scala/fpga/sim/FetchSim.scala 106:18]
    reg_pht__lu_taken_0 <= io_pht__lu_taken_0; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_taken_1 <= io_pht__lu_taken_1; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_taken_2 <= io_pht__lu_taken_2; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_taken_3 <= io_pht__lu_taken_3; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_lcnt_0 <= io_pht__lu_lcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_lcnt_1 <= io_pht__lu_lcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_lcnt_2 <= io_pht__lu_lcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_lcnt_3 <= io_pht__lu_lcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_gcnt_0 <= io_pht__lu_gcnt_0; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_gcnt_1 <= io_pht__lu_gcnt_1; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_gcnt_2 <= io_pht__lu_gcnt_2; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lu_gcnt_3 <= io_pht__lu_gcnt_3; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lmem_ren <= io_pht__lmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lmem_wen <= io_pht__lmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lmem_raddr <= io_pht__lmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lmem_waddr <= io_pht__lmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__lmem_wdata <= io_pht__lmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__gmem_ren <= io_pht__gmem_ren; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__gmem_wen <= io_pht__gmem_wen; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__gmem_raddr <= io_pht__gmem_raddr; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__gmem_waddr <= io_pht__gmem_waddr; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__gmem_wdata <= io_pht__gmem_wdata; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_pht__history <= io_pht__history; // @[src/main/scala/fpga/sim/FetchSim.scala 107:18]
    reg_ras_top_ret_pc <= io_ras_top_ret_pc; // @[src/main/scala/fpga/sim/FetchSim.scala 108:18]
    reg_pht_lmem_rdata <= io_pht_lmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 109:18]
    reg_pht_gmem_rdata <= io_pht_gmem_rdata; // @[src/main/scala/fpga/sim/FetchSim.scala 110:18]
    reg_reset <= reset; // @[src/main/scala/fpga/sim/FetchSim.scala 100:18 42:{31,31}]
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
  reg_cr_upd_en = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  reg_cr_upd_latter_pc = _RAND_11[30:0];
  _RAND_12 = {1{`RANDOM}};
  reg_cr_upd_bp_entry_lcnt = _RAND_12[1:0];
  _RAND_13 = {1{`RANDOM}};
  reg_cr_upd_bp_entry_gcnt = _RAND_13[1:0];
  _RAND_14 = {1{`RANDOM}};
  reg_cr_upd_br_taken = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  reg_cr_upd_attr = _RAND_15[1:0];
  _RAND_16 = {1{`RANDOM}};
  reg_cr_upd_is_ret = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  reg_cr_upd_next_pc = _RAND_17[30:0];
  _RAND_18 = {1{`RANDOM}};
  reg_cr_fp_entry_attr = _RAND_18[1:0];
  _RAND_19 = {1{`RANDOM}};
  reg_cr_fp_entry_history = _RAND_19[7:0];
  _RAND_20 = {1{`RANDOM}};
  reg_cr_fp_hit = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  reg_cr_mispred = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  reg_cr_target = _RAND_22[30:0];
  _RAND_23 = {1{`RANDOM}};
  reg_redir_deq_en = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  reg_redir_read_ptr = _RAND_24[1:0];
  _RAND_25 = {1{`RANDOM}};
  reg_zbtb_lu_matches_0 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  reg_zbtb_lu_matches_1 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  reg_zbtb_lu_matches_2 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  reg_zbtb_lu_matches_3 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  reg_zbtb_lu_target_0 = _RAND_29[30:0];
  _RAND_30 = {1{`RANDOM}};
  reg_zbtb_lu_target_1 = _RAND_30[30:0];
  _RAND_31 = {1{`RANDOM}};
  reg_zbtb_lu_target_2 = _RAND_31[30:0];
  _RAND_32 = {1{`RANDOM}};
  reg_zbtb_lu_target_3 = _RAND_32[30:0];
  _RAND_33 = {1{`RANDOM}};
  reg_btb_lu_result_0_jump = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  reg_btb_lu_result_0_br = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  reg_btb_lu_result_0_attr = _RAND_35[1:0];
  _RAND_36 = {1{`RANDOM}};
  reg_btb_lu_result_0_is_ret = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  reg_btb_lu_result_0_target = _RAND_37[30:0];
  _RAND_38 = {1{`RANDOM}};
  reg_btb_lu_result_1_jump = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  reg_btb_lu_result_1_br = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  reg_btb_lu_result_1_attr = _RAND_40[1:0];
  _RAND_41 = {1{`RANDOM}};
  reg_btb_lu_result_1_is_ret = _RAND_41[0:0];
  _RAND_42 = {1{`RANDOM}};
  reg_btb_lu_result_1_target = _RAND_42[30:0];
  _RAND_43 = {1{`RANDOM}};
  reg_btb_lu_result_2_jump = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  reg_btb_lu_result_2_br = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  reg_btb_lu_result_2_attr = _RAND_45[1:0];
  _RAND_46 = {1{`RANDOM}};
  reg_btb_lu_result_2_is_ret = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  reg_btb_lu_result_2_target = _RAND_47[30:0];
  _RAND_48 = {1{`RANDOM}};
  reg_btb_lu_result_3_jump = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  reg_btb_lu_result_3_br = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  reg_btb_lu_result_3_attr = _RAND_50[1:0];
  _RAND_51 = {1{`RANDOM}};
  reg_btb_lu_result_3_is_ret = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  reg_btb_lu_result_3_target = _RAND_52[30:0];
  _RAND_53 = {1{`RANDOM}};
  reg_pht__lu_taken_0 = _RAND_53[0:0];
  _RAND_54 = {1{`RANDOM}};
  reg_pht__lu_taken_1 = _RAND_54[0:0];
  _RAND_55 = {1{`RANDOM}};
  reg_pht__lu_taken_2 = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  reg_pht__lu_taken_3 = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  reg_pht__lu_lcnt_0 = _RAND_57[1:0];
  _RAND_58 = {1{`RANDOM}};
  reg_pht__lu_lcnt_1 = _RAND_58[1:0];
  _RAND_59 = {1{`RANDOM}};
  reg_pht__lu_lcnt_2 = _RAND_59[1:0];
  _RAND_60 = {1{`RANDOM}};
  reg_pht__lu_lcnt_3 = _RAND_60[1:0];
  _RAND_61 = {1{`RANDOM}};
  reg_pht__lu_gcnt_0 = _RAND_61[1:0];
  _RAND_62 = {1{`RANDOM}};
  reg_pht__lu_gcnt_1 = _RAND_62[1:0];
  _RAND_63 = {1{`RANDOM}};
  reg_pht__lu_gcnt_2 = _RAND_63[1:0];
  _RAND_64 = {1{`RANDOM}};
  reg_pht__lu_gcnt_3 = _RAND_64[1:0];
  _RAND_65 = {1{`RANDOM}};
  reg_pht__lmem_ren = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  reg_pht__lmem_wen = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  reg_pht__lmem_raddr = _RAND_67[10:0];
  _RAND_68 = {1{`RANDOM}};
  reg_pht__lmem_waddr = _RAND_68[12:0];
  _RAND_69 = {1{`RANDOM}};
  reg_pht__lmem_wdata = _RAND_69[1:0];
  _RAND_70 = {1{`RANDOM}};
  reg_pht__gmem_ren = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  reg_pht__gmem_wen = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  reg_pht__gmem_raddr = _RAND_72[10:0];
  _RAND_73 = {1{`RANDOM}};
  reg_pht__gmem_waddr = _RAND_73[12:0];
  _RAND_74 = {1{`RANDOM}};
  reg_pht__gmem_wdata = _RAND_74[1:0];
  _RAND_75 = {1{`RANDOM}};
  reg_pht__history = _RAND_75[7:0];
  _RAND_76 = {1{`RANDOM}};
  reg_ras_top_ret_pc = _RAND_76[30:0];
  _RAND_77 = {1{`RANDOM}};
  reg_pht_lmem_rdata = _RAND_77[7:0];
  _RAND_78 = {1{`RANDOM}};
  reg_pht_gmem_rdata = _RAND_78[7:0];
  _RAND_79 = {1{`RANDOM}};
  reg_reset = _RAND_79[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
