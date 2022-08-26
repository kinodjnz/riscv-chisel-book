module ICache #(
    parameter RDATA_WIDTH_BITS = 5,
    parameter RADDR_WIDTH = 10,
    parameter WDATA_WIDTH_BITS = 8,
    parameter WADDR_WIDTH = 7
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
        if (ren) begin
            rdata_reg <= ram[raddr];
        end
    end
    assign rdata = rdata_reg;

    always @(posedge clock) begin : ramwrite
        integer i;
        reg [(WDATA_WIDTH_BITS-RDATA_WIDTH_BITS)-1:0] lsbaddr;
        for (i = 0; i < (2**(WDATA_WIDTH_BITS-RDATA_WIDTH_BITS)); i = i + 1) begin : write1
            lsbaddr = i;
            if (wen) begin
                ram[{waddr, lsbaddr}] <= wdata[(i+1)*RDATA_WIDTH-1 -: RDATA_WIDTH];
            end
        end
    end
 
endmodule
