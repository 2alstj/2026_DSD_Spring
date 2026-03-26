`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 20:46:36
// Design Name: 
// Module Name: tb_Pipelined_Area_Tree
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Pipelined_Area_Tree();
    reg clk, rstn, en;
    reg [16:0] din1;
    reg [16:0] din2;
    reg [16:0] din3;
    reg [16:0] din4;

    wire [17:0] result;

    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 1;
        #20 rstn = 0; din1 = 0; din2 = 0; din3 = 0; din4 = 0;
        #20 rstn = 1;
    end

    initial begin 
        en = 0; 
        #50 en = 1;
    end

    integer i;
    initial begin
        #60;
        for(i = 0; i <  15; i = i + 1) begin
            din1 = din1 + i;
            din2 = din2 + i * 2;
            din3 = din3 + i * 4;
            din4 = din4 + i * 8;
            #10;
        end
        #50;
        $stop;  
    end

    Pipelined_Area_Tree dut(
        .i_clk(clk),
        .i_rstn(rstn),
        .i_en(en),
        .i_din1(din1),
        .i_din2(din2),
        .i_din3(din3),
        .i_din4(din4),

        .o_dout(result)
    );

endmodule
