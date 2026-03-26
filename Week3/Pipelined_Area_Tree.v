`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 20:36:22
// Design Name: 
// Module Name: Pipelined_Area_Tree
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


module Pipelined_Area_Tree(
        input wire i_clk,
        input wire i_rstn,
        input wire i_en,
        input wire [15:0] i_din1,
        input wire [15:0] i_din2,
        input wire [15:0] i_din3,
        input wire [15:0] i_din4,  

        output wire [17:0] o_dout 
);

    reg [15:0] din_temp1;
    reg [15:0] din_temp2;
    reg [15:0] din_temp3;
    reg [15:0] din_temp4;

    reg [16:0] sum_temp1;
    reg [16:0] sum_temp2;

    reg[17:0] dout_o;

    always@(posedge i_clk) begin
        if(!i_rstn)begin
            din_temp1 <= 16'd0;
            din_temp2 <= 16'd0;
            din_temp3 <= 16'd0;
            din_temp4 <= 16'd0;

            sum_temp1 <= 17'd0;
            sum_temp2 <= 17'd0;

            dout_o <= 18'd0;
        end
        else if(i_en) begin
            //stage1
            din_temp1 <= i_din1;
            din_temp2 <= i_din2;
            din_temp3 <= i_din3;
            din_temp4 <= i_din4;

            //stage2
            sum_temp1 <= din_temp1 + din_temp2;
            sum_temp2 <= din_temp3 + din_temp4;

            //stage3
            dout_o <= sum_temp1 + sum_temp2;
        end
    end

    assign o_dout = dout_o;  
endmodule
