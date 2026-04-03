`timescale 1ns / 1ps

module tb_MAC();
    reg i_clk;
    reg i_rstn;
    reg i_dsp_enable;

    reg signed [15:0] i_input_bram;
    reg signed [15:0] i_weight_bram;

    wire signed [47:0] o_dsp_output;

    // clock generation
    initial begin
        i_clk = 1'b0;
        forever #5 i_clk = ~i_clk;
    end

    MAC DUT(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_dsp_enable(i_dsp_enable),
        .i_input_bram(i_input_bram),
        .i_weight_bram(i_weight_bram),
        .o_dsp_output(o_dsp_output)
    );

    initial begin
        // init
        i_rstn = 1'b0;
        i_dsp_enable = 1'b0;
        i_input_bram = 16'sd0;
        i_weight_bram = 16'sd0;

        // release reset
        #20;
        i_rstn = 1'b1;
        i_dsp_enable = 1'b1;

        // 1 * 1
        @(posedge i_clk);
        i_input_bram = 16'sd1;
        i_weight_bram = 16'sd1;

        @(posedge i_clk);
        $display("[1st] expected = 1, output = %d", o_dsp_output);

        // 2 * 2
        i_input_bram = 16'sd2;
        i_weight_bram = 16'sd2;

        @(posedge i_clk);
        $display("[2nd] expected = 5, output = %d", o_dsp_output);

        // 3 * 3
        i_input_bram = 16'sd3;
        i_weight_bram = 16'sd3;

        @(posedge i_clk);
        $display("[3rd] expected = 14, output = %d", o_dsp_output);

        @(posedge i_clk);
        i_rstn = 0;
        i_dsp_enable = 0;
        
        #20;
        $finish;
    end

endmodule