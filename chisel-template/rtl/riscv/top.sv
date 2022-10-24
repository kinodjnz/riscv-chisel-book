module top #(
    parameter DDR3_DQ_WIDTH   = 16,
    parameter DDR3_DQS_WIDTH  = 2,
    parameter DDR3_ADDR_WIDTH = 14,
    parameter DDR3_BA_WIDTH   = 3,
    parameter DDR3_DM_WIDTH   = 2,
    parameter APP_ADDR_WIDTH  = 28,
    parameter APP_CMD_WIDTH   = 3,
    parameter APP_DATA_WIDTH  = 128,
    parameter APP_MASK_WIDTH  = 16
)(
    input  wire clock,
    input  wire resetn,
    inout  wire [DDR3_DQ_WIDTH-1 : 0]   ddr3_dq,
    inout  wire [DDR3_DQS_WIDTH-1 : 0]  ddr3_dqs_n,
    inout  wire [DDR3_DQS_WIDTH-1 : 0]  ddr3_dqs_p,
    output wire [DDR3_ADDR_WIDTH-1 : 0] ddr3_addr,
    output wire [DDR3_BA_WIDTH-1 : 0]   ddr3_ba,
    output wire                         ddr3_ras_n,
    output wire                         ddr3_cas_n,
    output wire                         ddr3_we_n,
    output wire                         ddr3_reset_n,
    output wire [0:0]                   ddr3_ck_p,
    output wire [0:0]                   ddr3_ck_n,
    output wire [0:0]                   ddr3_cke,
    output wire [0:0]                   ddr3_cs_n,
    output wire [DDR3_DM_WIDTH-1 : 0]   ddr3_dm,
    output wire [0:0]                   ddr3_odt,
    output logic [7:0] gpio_out,
    output logic uart_tx,
    input  logic uart_rx,
    output logic sdc_clk,
    inout  logic sdc_cmd,
    inout  logic [3:0] sdc_dat
);

// logic io_exit;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_mem_reg_pc;
(* mark_debug = "true" *) logic        io_debugSignals_core_mem_is_valid_inst;
// (* mark_debug = "true" *) logic [31:0] io_debugSignals_core_csr_rdata;
// (* mark_debug = "true" *) logic [11:0] io_debugSignals_core_mem_reg_csr_addr;
(* mark_debug = "true" *) logic        io_debugSignals_core_me_intr;
(* mark_debug = "true" *) logic [47:0] io_debugSignals_core_cycle_counter;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_id_pc;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_id_inst;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_rdata;
(* mark_debug = "true" *) logic        io_debugSignals_ren;
(* mark_debug = "true" *) logic        io_debugSignals_rvalid;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_rwaddr;
(* mark_debug = "true" *) logic        io_debugSignals_wen;
(* mark_debug = "true" *) logic        io_debugSignals_wready;
(* mark_debug = "true" *) logic [3:0]  io_debugSignals_wstrb;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_wdata;
// (* mark_debug = "true" *) logic        io_debugSignals_dram_init_calib_complete;
// (* mark_debug = "true" *) logic        io_debugSignals_dram_rdata_valid;
// (* mark_debug = "true" *) logic        io_debugSignals_dram_busy;
// (* mark_debug = "true" *) logic        io_debugSignals_dram_ren;
// (* mark_debug = "true" *) logic        io_debugSignals_sdc_cmd_wrt;
// (* mark_debug = "true" *) logic        io_debugSignals_sdc_cmd_out;
// (* mark_debug = "true" *) logic        io_debugSignals_sdc_res_in;
// (* mark_debug = "true" *) logic [3:0]  io_debugSignals_sdc_dat_in;
// (* mark_debug = "true" *) logic [7:0]  io_debugSignals_sdc_rx_dat_index;
(* mark_debug = "true" *) logic        io_debugSignals_sdc_sdbuf_ren1;
(* mark_debug = "true" *) logic        io_debugSignals_sdc_sdbuf_wen1;
(* mark_debug = "true" *) logic [7:0]  io_debugSignals_sdc_sdbuf_addr1;
(* mark_debug = "true" *) logic [7:0]  io_debugSignals_sdc_sdbuf_wdata1;
(* mark_debug = "true" *) logic        io_debugSignals_sdc_sdbuf_ren2;
(* mark_debug = "true" *) logic        io_debugSignals_sdc_sdbuf_wen2;
(* mark_debug = "true" *) logic [7:0]  io_debugSignals_sdc_sdbuf_addr2;

wire clk;
wire rst;

wire clk_166_67_mhz;
wire clk_200_mhz;
wire dram_rst;
wire dram_rstx_async;
reg  dram_rst_sync1;
reg  dram_rst_sync2;
wire locked;

wire                        io_dram_ren;
wire                        io_dram_wen;
wire [APP_ADDR_WIDTH-2 : 0] io_dram_addr;
wire [APP_DATA_WIDTH-1 : 0] io_dram_wdata;
wire [APP_MASK_WIDTH-1 : 0] io_dram_wmask;
wire                        io_dram_user_busy;
wire                        io_dram_init_calib_complete;
wire [APP_DATA_WIDTH-1 : 0] io_dram_rdata;
wire                        io_dram_rdata_valid;
wire                        io_dram_busy;

clk_wiz_1 dram_clkgen (
    .clk_in1(clock),
    .resetn(resetn),
    .clk_out1(clk_166_67_mhz),
    .clk_out2(clk_200_mhz),
    .locked(locked)
);

assign dram_rstx_async = resetn & locked;
assign dram_rst = dram_rst_sync2;

always @(posedge clk_166_67_mhz or negedge dram_rstx_async) begin
    if (!dram_rstx_async) begin
        dram_rst_sync1 <= 1'b1;
        dram_rst_sync2 <= 1'b1;
    end else begin
        dram_rst_sync1 <= 1'b0;
        dram_rst_sync2 <= dram_rst_sync1;
    end
end

DRAM #(
    .DDR3_DQ_WIDTH(DDR3_DQ_WIDTH),
    .DDR3_DQS_WIDTH(DDR3_DQS_WIDTH),
    .DDR3_ADDR_WIDTH(DDR3_ADDR_WIDTH),
    .DDR3_BA_WIDTH(DDR3_BA_WIDTH),
    .DDR3_DM_WIDTH(DDR3_DM_WIDTH),
    .APP_ADDR_WIDTH(APP_ADDR_WIDTH),
    .APP_CMD_WIDTH(APP_CMD_WIDTH),
    .APP_DATA_WIDTH(APP_DATA_WIDTH),
    .APP_MASK_WIDTH(APP_MASK_WIDTH)
) dram (
    .sys_clk(clk_166_67_mhz),
    .ref_clk(clk_200_mhz),
    .sys_rst(dram_rst),
    // dram interface signals
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    // output clock and reset (active-high) signals for user design
    .o_clk(clk),
    .o_rst(rst),
    // user design interface signals
    .i_ren(io_dram_ren),
    .i_wen(io_dram_wen),
    .i_addr(io_dram_addr),
    .i_data(io_dram_wdata),
    .i_mask(io_dram_wmask),
    .i_busy(io_dram_user_busy),
    .o_init_calib_complete(io_dram_init_calib_complete),
    .o_data(io_dram_rdata),
    .o_data_valid(io_dram_rdata_valid),
    .o_busy(io_dram_busy)
);

wire       sdc_cmd_wrt;
wire       sdc_cmd_out;
wire       sdc_res_in;
wire       sdc_dat_wrt;
wire [3:0] sdc_dat_out;
wire [3:0] sdc_dat_in;

assign sdc_cmd = sdc_cmd_wrt ? sdc_cmd_out : 1'bZ;
assign sdc_res_in = sdc_cmd;
assign sdc_dat = sdc_dat_wrt ? sdc_dat_out : 4'bZ;
assign sdc_dat_in = sdc_dat;

RiscV core(
    .clock(clk),
    .reset(rst),
    .io_gpio(gpio_out),
    .io_uart_tx(uart_tx),
    .io_uart_rx(uart_rx),
    .io_sdc_port_clk(sdc_clk),
    .io_sdc_port_cmd_wrt(sdc_cmd_wrt),
    .io_sdc_port_cmd_out(sdc_cmd_out),
    .io_sdc_port_res_in(sdc_res_in),
    .io_sdc_port_dat_wrt(sdc_dat_wrt),
    .io_sdc_port_dat_out(sdc_dat_out),
    .io_sdc_port_dat_in(sdc_dat_in),
    .*
);

endmodule
