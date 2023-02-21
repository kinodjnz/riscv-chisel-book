module PHTMem #(
    parameter RDATA_WIDTH_BITS = 2,
    parameter RADDR_WIDTH = 12,
    parameter WDATA_WIDTH_BITS = 1,
    parameter WADDR_WIDTH = 13
) (
    input clock,
    input ren,
    input wen,
    input [RADDR_WIDTH-1:0] raddr,
    output [(2**RDATA_WIDTH_BITS)-1:0] rdata,
    input [WADDR_WIDTH-1:0] waddr,
    input [(2**WDATA_WIDTH_BITS)-1:0] wdata
);

    localparam RDATA_WIDTH = 2**RDATA_WIDTH_BITS;
    localparam WDATA_WIDTH = 2**WDATA_WIDTH_BITS;

    reg [RDATA_WIDTH-1:0] ram [0:(2**RADDR_WIDTH)-1];
    reg [RDATA_WIDTH-1:0] rdata_reg;
 
    always @(posedge clock) begin
        if (wen) begin
            ram[waddr] <= wdata;
        end
    end
 
    always @(posedge clock) begin : ramread
        integer i;
        reg [(RDATA_WIDTH_BITS-WDATA_WIDTH_BITS)-1:0] lsbaddr;
        if (ren) begin
            for (i = 0; i < (2**(RDATA_WIDTH_BITS-WDATA_WIDTH_BITS)); i = i + 1) begin : read1
                lsbaddr = i;
                rdata_reg[(i+1)*WDATA_WIDTH-1 -: WDATA_WIDTH] <= ram[{raddr, lsbaddr}];
            end
        end
    end
    assign rdata = rdata_reg;

endmodule
