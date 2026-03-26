`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 19:54:34
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
    input wire signed [16:0] i_dsp_input,
    input wire signed [16:0] i_dsp_weight,
    
    output wire [47:0] o_dsp_output
    );

    reg signed [47:0] psum;

    always@(posedge i_clk) begin 
        if(!i_rstn) begin
            psum <= 0;
        end
        else if(i_dsp_enable) begin
            psum <= o_dsp_output;
        end
    end

    dsp dsp_inst (
        .CLK(i_clk),  // input wire CLK
        .CE(i_dsp_enable),    // input wire CE
        .A(i_dsp_input),      // input wire [15 : 0] A
        .B(i_dsp_weight),      // input wire [15 : 0] B
        .C(psum),      // input wire [47 : 0] C
        .P(o_dsp_output)      // output wire [47 : 0] P
    );
endmodule
