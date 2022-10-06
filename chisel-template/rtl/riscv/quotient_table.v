module QuotientTable #(
    parameter RDATA_WIDTH_BITS = 3,
    parameter RADDR_WIDTH = 4,
    parameter WDATA_WIDTH_BITS = 6,
    parameter WADDR_WIDTH = 1
) (
    input clock,
    input wen,
    input [RADDR_WIDTH-1:0] raddr,
    output [(2**RDATA_WIDTH_BITS)-1:0] rdata,
    input [WADDR_WIDTH-1:0] waddr,
    input [(2**WDATA_WIDTH_BITS)-1:0] wdata
);

    // localparam RDATA_WIDTH = 2**RDATA_WIDTH_BITS;
    // localparam WDATA_WIDTH = 2**WDATA_WIDTH_BITS;

    // reg [RDATA_WIDTH-1:0] ramq [0:(2**RADDR_WIDTH)-1];

    // assign rdata = ramq[raddr];

    // always @(posedge clock) begin : ramqwrite
    //     integer i;
    //     reg [(WDATA_WIDTH_BITS-RDATA_WIDTH_BITS)-1:0] lsbaddr;
    //     for (i = 0; i < (2**(WDATA_WIDTH_BITS-RDATA_WIDTH_BITS)); i = i + 1) begin : write2
    //         lsbaddr = i;
    //         if (wen) begin
    //             ramq[{waddr, lsbaddr}] <= wdata[(i+1)*RDATA_WIDTH-1 -: RDATA_WIDTH];
    //         end
    //     end
    // end

endmodule
