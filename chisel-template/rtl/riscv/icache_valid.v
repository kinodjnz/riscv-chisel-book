module ICacheValid #(
    parameter DATA_WIDTH_BITS = 1,
    parameter ADDR_WIDTH = 6,
    parameter INVALIDATE_WIDTH_BITS = 6,
    parameter INVALIDATE_ADDR_WIDTH = 1
) (
    input wire clock,
    input wire ren,
    input wire wen,
    input wire ien,
    input wire invalidate,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [INVALIDATE_ADDR_WIDTH-1:0] iaddr,
    output wire [(2**DATA_WIDTH_BITS)-1:0] rdata,
    input wire [(2**DATA_WIDTH_BITS)-1:0] wdata,
    input wire [(2**INVALIDATE_WIDTH_BITS)-1:0] idata,
    output wire [(2**INVALIDATE_WIDTH_BITS)-1:0] dummy_data
);

    localparam DATA_WIDTH = 2**DATA_WIDTH_BITS;
    localparam INVALIDATE_WIDTH = 2**INVALIDATE_WIDTH_BITS;

    reg [DATA_WIDTH-1:0] ram_valid [0:(2**ADDR_WIDTH)-1];
    reg [DATA_WIDTH-1:0] rdata_reg;
    reg [INVALIDATE_WIDTH-1:0] dummy_data_reg;

    always @(posedge clock) begin
        if (ren) begin
            rdata_reg <= ram_valid[addr];
            if (wen) begin
                ram_valid[addr] <= wdata;
            end
        end
    end
    assign rdata = rdata_reg;

    always @(posedge clock) begin : portA
        integer i;
        reg [(INVALIDATE_WIDTH_BITS-DATA_WIDTH_BITS)-1:0] lsbaddr;
        for (i = 0; i < (2**(INVALIDATE_WIDTH_BITS-DATA_WIDTH_BITS)); i = i + 1) begin
            lsbaddr = i;
            if (ien) begin
                dummy_data_reg[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] <= ram_valid[{iaddr, lsbaddr}];
                if (invalidate) begin
                    ram_valid[{iaddr, lsbaddr}] <= idata[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH];
                end
            end
        end
    end
    assign dummy_data = dummy_data_reg;
endmodule
