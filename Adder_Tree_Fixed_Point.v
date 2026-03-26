`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 21:06:32
// Design Name: 
// Module Name: Adder_Tree_Fixed_Point
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


module Adder_Tree_Fixed_Point(
    input wire i_clk, i_rstn, i_dsp_enable,
    input wire signed [15:0] i_din1, i_din2,
    input wire signed [15:0] i_weight1, i_weight2,

    output wire signed [15:0] o_dout
);

wire signed [47:0] mac_out1;
wire signed [47:0] mac_out2;
wire mac_done;

reg [2:0] sample_cnt;
reg add_done; 

//ff
reg signed [15:0] mac_out1_ff;
reg signed [15:0] mac_out2_ff;
reg signed [15:0] sum_ff; 

assign mac_done = i_dsp_enable && (sample_cnt == 3'd4);
assign o_dout = sum_ff;

MAC MAC_inst1(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_dsp_enable(i_dsp_enable),
    .i_dsp_weight(i_weight1),
    .i_dsp_input(i_din1),
    .o_dsp_output(mac_out1)
);

MAC MAC_inst2(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_dsp_enable(i_dsp_enable),
    .i_dsp_weight(i_weight2),
    .i_dsp_input(i_din2),
    .o_dsp_output(mac_out2)
);

always @(posedge i_clk) begin
    if(~i_rstn) begin
        sample_cnt <= 3'd0; 
        add_done <= 3'd0;
        mac_out1_ff <= 16'sd0;
        mac_out2_ff <= 16'sd0;
        sum_ff <= 16'sd0;
    end
    else begin 
        if(i_dsp_enable) begin
            if(sample_cnt == 3'd4) begin
                sample_cnt <= 3'd0;
            end
            else begin
                sample_cnt <= sample_cnt + 3'd1;
            end
        end

        //Tranction LSB
        if(mac_done) begin 
            mac_out1_ff <= mac_out1 >>> 8;
            mac_out2_ff <= mac_out2 >>> 8;
        end

        add_done <= mac_done;

        //Tranction MSB
        if(add_done) begin
            sum_ff <= $signed(mac_out1_ff) + $signed(mac_out2_ff);
        end
    end
end

endmodule
