`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/03 13:06:01
// Design Name: 
// Module Name: MAC
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


module MAC(
    input wire i_clk,
    input wire i_rstn,

    input wire i_dsp_enable,
    input wire signed [15:0] i_input_bram,
    input wire signed [15:0] i_weight_bram,
    output wire signed [47:0] o_dsp_output
    );
    reg signed [47:0] partial_sum;

    always@(posedge i_clk or negedge i_rstn) begin
        if(~i_rstn) begin 
            partial_sum <= 48'd0;
        end else if(i_dsp_enable) begin
            partial_sum <=o_dsp_output;
        end
    end

    dsp_macro_0 your_instance_name (
        .CLK(i_clk),  // input wire CLK
        .CE(i_dsp_enable),    // input wire CE
        .A(i_input_bram),      // input wire [15 : 0] A
        .B(i_weight_bram),      // input wire [15 : 0] B
        .C(partial_sum),      // input wire [47 : 0] C
        .P(o_dsp_output)      // output wire [47 : 0] P
    );
endmodule