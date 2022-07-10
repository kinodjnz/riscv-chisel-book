module top(
    input wire clock,
    input wire resetn,
    output logic [7:0] gpio_out,
    output logic uart_tx
);

logic io_exit;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_mem_reg_pc;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_csr_rdata;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_mem_reg_csr_addr;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_core_id_reg_inst;
(* mark_debug = "true" *) logic [63:0] io_debugSignals_core_cycle_counter;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_raddr;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_rdata;
(* mark_debug = "true" *) logic        io_debugSignals_ren;
(* mark_debug = "true" *) logic        io_debugSignals_rvalid;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_waddr;
(* mark_debug = "true" *) logic        io_debugSignals_wen;
(* mark_debug = "true" *) logic        io_debugSignals_wready;
(* mark_debug = "true" *) logic [3:0]  io_debugSignals_wstrb;
(* mark_debug = "true" *) logic [31:0] io_debugSignals_wdata;

RiscV core(
    .reset(!resetn),
    .io_gpio(gpio_out),
    .io_uart_tx(uart_tx),
    .*
);

endmodule
