`timescale 1ns / 1ps

module mac_with_bram # (
        parameter INPUT_WIDTH = 16,
        parameter WEIGHT_WIDTH = 16,
        parameter OUTPUT_WIDTH = 48,

        parameter INPUT_DEPTH = 1024,
        parameter WEIGHT_DEPTH = 1024,
        parameter OUTPUT_DEPTH = 1024,

        parameter INPUT_ADDR = $clog2(INPUT_DEPTH),
        parameter WEIGHT_ADDR = $clog2(WEIGHT_DEPTH),
        parameter OUTPUT_ADDR = $clog2(OUTPUT_DEPTH),

        parameter INPUT_INIT_FILE = "",
        parameter WEIGHT_INIT_FILE = ""
    )(
        //clk & rstn
        input wire                      i_clk,
        input wire                      i_rstn,

        //input bram
        input wire                      i_input_wr_en,
        input wire [INPUT_ADDR-1:0]     i_input_wr_addr,
        input wire [INPUT_WIDTH-1:0]    i_input_wr_din,

        input wire                      i_input_rd_en,
        input wire [INPUT_ADDR-1:0]     i_input_rd_addr,

        //wieght bram
        input wire                      i_weight_wr_en,
        input wire [WEIGHT_ADDR-1:0]     i_weight_wr_addr,
        input wire [WEIGHT_WIDTH-1:0]    i_weight_wr_din,

        input wire                      i_weight_rd_en,
        input wire [WEIGHT_ADDR-1:0]     i_weight_rd_addr,

        //output bram
        input wire                      i_output_wr_en,
        input wire [OUTPUT_ADDR-1:0]     i_output_wr_addr,

        input wire                      i_output_rd_en,
        input wire [OUTPUT_ADDR-1:0]     i_output_rd_addr,
        output wire [OUTPUT_WIDTH-1:0]      o_output_rd_dout,
        output wire                         o_output_rd_valid,

        //MAC
        input wire                      i_mac_enable

    );

    wire [INPUT_WIDTH-1:0]                          o_input_rd_dout;
    wire                                            o_input_rd_valid;
    wire [WEIGHT_WIDTH-1:0]                         o_weight_rd_dout;
    wire                                            o_weight_rd_valid;
    wire signed [OUTPUT_WIDTH-1:0]                  o_mac_out;
    
    simple_dual_port_bram #(
        .WIDTH(INPUT_WIDTH),
        .DEPTH(INPUT_DEPTH),
        .ADDR_WIDTH(INPUT_ADDR),
        .INIT_FILE(INPUT_INIT_FILE)
    )input_bram(
        .clk(i_clk),
        .rstn(i_rstn),
        .wr_en(i_input_wr_en),
        .wr_addr(i_input_wr_addr),
        .wr_din(i_input_wr_din),
        .rd_en(i_input_rd_en),
        .rd_addr(i_input_rd_addr),
        .rd_dout(o_input_rd_dout),
        .rd_valid(o_input_rd_valid)
    );

    simple_dual_port_bram #(
        .WIDTH(WEIGHT_WIDTH),
        .DEPTH(WEIGHT_DEPTH),
        .ADDR_WIDTH(WEIGHT_ADDR),
        .INIT_FILE(WEIGHT_INIT_FILE)
    )weight_bram(
        .clk(i_clk),
        .rstn(i_rstn),
        .wr_en(i_weight_wr_en),
        .wr_addr(i_weight_wr_addr),
        .wr_din(i_weight_wr_din),
        .rd_en(i_weight_rd_en),
        .rd_addr(i_weight_rd_addr),
        .rd_dout(o_weight_rd_dout),
        .rd_valid(o_weight_rd_valid)
    );

    MAC mac(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_dsp_enable(i_mac_enable),
        .i_input_bram($signed(o_input_rd_dout)),
        .i_weight_bram($signed(o_weight_rd_dout)),
        .o_dsp_output(o_mac_out)
    );

    simple_dual_port_bram #(
        .WIDTH(OUTPUT_WIDTH),
        .DEPTH(OUTPUT_DEPTH),
        .ADDR_WIDTH(OUTPUT_ADDR),
        .INIT_FILE("")
    )output_bram(
        .clk(i_clk),
        .rstn(i_rstn),
        .wr_en(i_output_wr_en),
        .wr_addr(i_output_wr_addr),
        .wr_din(o_mac_out),
        .rd_en(i_output_rd_en),
        .rd_addr(i_output_rd_addr),
        .rd_dout(o_output_rd_dout),
        .rd_valid(o_output_rd_valid)
    );

endmodule
