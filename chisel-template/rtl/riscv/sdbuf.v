module SdBuf #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
) (
    input clock,

    input ren1,
    input wen1,
    input [ADDR_WIDTH-1:0] addr1,
    input [DATA_WIDTH-1:0] wdata1,
    output [DATA_WIDTH-1:0] rdata1,
    input ren2,
    input wen2,
    input [ADDR_WIDTH-1:0] addr2,
    input [DATA_WIDTH-1:0] wdata2,
    output [DATA_WIDTH-1:0] rdata2
);

    // Core Memory
    reg [DATA_WIDTH-1:0] ram_sdbuf [(2**ADDR_WIDTH)-1:0];

    reg [DATA_WIDTH-1:0] rdata1_reg;
    reg [DATA_WIDTH-1:0] rdata2_reg;
    assign rdata1 = rdata1_reg;
    assign rdata2 = rdata2_reg;

    always @ (posedge clock) begin
        if (wen1) begin
            ram_sdbuf[addr1] <= wdata1;
        end
        if (ren1) begin
            rdata1_reg <= ram_sdbuf[addr1];
        end
    end

    always @ (posedge clock) begin
        if (wen2) begin
            ram_sdbuf[addr2] <= wdata2;
        end
        if (ren2) begin
            rdata2_reg <= ram_sdbuf[addr2];
        end
    end

endmodule
