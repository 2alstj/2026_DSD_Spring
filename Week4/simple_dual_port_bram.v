`timescale 1ns / 1ps

module simple_dual_port_bram #(
    parameter WIDTH = 16,
    parameter DEPTH = 4,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter INIT_FILE = "C:\\dsd\\week_4\\input.txt"
)(
    input wire                       clk,
    input wire                       rstn,

    input wire                       wr_en,
    input wire  [ADDR_WIDTH-1:0]     wr_addr,
    input wire  [WIDTH-1:0]          wr_din,

    input wire                       rd_en,
    input wire  [ADDR_WIDTH-1:0]     rd_addr,

    output reg   [WIDTH-1:0]         rd_dout,
    output reg                       rd_valid    
);

    //BRAM
    (* ram_style = "block"*) reg [WIDTH-1:0] mem[0:DEPTH-1];

    generate
        if(INIT_FILE != "") begin : use_init_file
            initial begin 
                $readmemh(INIT_FILE, mem);
            end
        end
        else begin : init_to_zero
            integer i;
            initial begin
                for(i = 0;i < DEPTH; i = i + 1) begin
                    mem[i] = {WIDTH{1'b0}};
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rstn) begin 
        if(wr_en) mem[wr_addr] <= wr_din;
        if(rd_en) rd_dout <= mem[rd_addr];
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) rd_valid <= 0;
        else rd_valid <= rd_en;
    end

endmodule
