module SRAM #(
    parameter NUM_COL    =  4,
    parameter COL_WIDTH  =  8,
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = NUM_COL*COL_WIDTH
) (
    input clock,

    input en,
    input [NUM_COL-1:0] we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] rdata
);

    // Core Memory
    reg [DATA_WIDTH-1:0] ram_block [(2**ADDR_WIDTH)-1:0];

    reg [DATA_WIDTH-1:0] rdata_reg;
    assign rdata = rdata_reg;

    integer i;
    always @ (posedge clock) begin
        if(en) begin
            for(i=0;i<NUM_COL;i=i+1) begin
                if(we[i]) begin
                   ram_block[addr][i*COL_WIDTH +: COL_WIDTH] <= wdata[i*COL_WIDTH +: COL_WIDTH];
                end
            end
            rdata_reg <= ram_block[addr];
        end
    end
 
endmodule
