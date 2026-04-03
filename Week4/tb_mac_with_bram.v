`timescale 1ns / 1ps

module tb_mac_with_bram();

    localparam INPUT_WIDTH       = 16;
    localparam WEIGHT_WIDTH      = 16;
    localparam OUTPUT_WIDTH      = 48;

    localparam INPUT_DEPTH       = 4;
    localparam WEIGHT_DEPTH      = 4;
    localparam OUTPUT_DEPTH      = 1024;

    localparam INPUT_ADDR_WIDTH  = $clog2(INPUT_DEPTH);
    localparam WEIGHT_ADDR_WIDTH = $clog2(WEIGHT_DEPTH);
    localparam OUTPUT_ADDR_WIDTH = $clog2(OUTPUT_DEPTH);

    reg i_clk;
    reg i_rstn;

    reg i_input_wr_en;
    reg [INPUT_ADDR_WIDTH-1:0] i_input_wr_addr;
    reg [INPUT_WIDTH-1:0] i_input_wr_din;
    reg i_input_rd_en;
    reg [INPUT_ADDR_WIDTH-1:0] i_input_rd_addr;

    reg i_weight_wr_en;
    reg [WEIGHT_ADDR_WIDTH-1:0] i_weight_wr_addr;
    reg [WEIGHT_WIDTH-1:0] i_weight_wr_din;
    reg i_weight_rd_en;
    reg [WEIGHT_ADDR_WIDTH-1:0] i_weight_rd_addr;

    reg i_mac_enable;

    reg i_output_wr_en;
    reg [OUTPUT_ADDR_WIDTH-1:0] i_output_wr_addr;

    reg i_output_rd_en;
    reg [OUTPUT_ADDR_WIDTH-1:0] i_output_rd_addr;
    wire o_output_rd_valid;
    wire [OUTPUT_WIDTH-1:0] o_output_rd_dout;

    // DUT
    mac_with_bram #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .INPUT_DEPTH(INPUT_DEPTH),
        .WEIGHT_DEPTH(WEIGHT_DEPTH),
        .OUTPUT_DEPTH(OUTPUT_DEPTH),
        .INPUT_INIT_FILE("C:\\dsd\\week_4\\input.txt"),
        .WEIGHT_INIT_FILE("C:\\dsd\\week_4\\weight.txt")
    ) top (
        .i_clk(i_clk),
        .i_rstn(i_rstn),

        .i_input_wr_en(i_input_wr_en),
        .i_input_wr_addr(i_input_wr_addr),
        .i_input_wr_din(i_input_wr_din),
        .i_input_rd_en(i_input_rd_en),
        .i_input_rd_addr(i_input_rd_addr),

        .i_weight_wr_en(i_weight_wr_en),
        .i_weight_wr_addr(i_weight_wr_addr),
        .i_weight_wr_din(i_weight_wr_din),
        .i_weight_rd_en(i_weight_rd_en),
        .i_weight_rd_addr(i_weight_rd_addr),

        .i_mac_enable(i_mac_enable),

        .i_output_wr_en(i_output_wr_en),
        .i_output_wr_addr(i_output_wr_addr),

        .i_output_rd_en(i_output_rd_en),
        .i_output_rd_addr(i_output_rd_addr),
        .o_output_rd_dout(o_output_rd_dout),
        .o_output_rd_valid(o_output_rd_valid)
    );

    // clock: 10ns period
    initial begin
        i_clk = 1'b0;
        forever #5 i_clk = ~i_clk;
    end

    initial begin
        // init
        i_rstn           = 1'b0;
        i_input_wr_en    = 1'b0;
        i_input_wr_addr  = 0;
        i_input_wr_din   = 0;
        i_input_rd_en    = 1'b0;
        i_input_rd_addr  = 0;
        i_weight_wr_en   = 1'b0;
        i_weight_wr_addr = 0;
        i_weight_wr_din  = 0;
        i_weight_rd_en   = 1'b0;
        i_weight_rd_addr = 0;
        i_mac_enable     = 1'b0;
        i_output_wr_en   = 1'b0;
        i_output_wr_addr = 0;
        i_output_rd_en   = 1'b0;
        i_output_rd_addr = 0;

        // reset
        #20;
        i_rstn = 1'b1;
        $display("[%0t] reset deasserted", $time);

        // C1: read addr 0
        #10;
        i_input_rd_en    = 1'b1;
        i_input_rd_addr  = 0;
        i_weight_rd_en   = 1'b1;
        i_weight_rd_addr = 0;
        i_mac_enable     = 1'b0;
        $display("[%0t] C1 read addr0", $time);

        // C2: read addr 1, MAC on data 0
        #10;
        i_input_rd_addr  = 1;
        i_weight_rd_addr = 1;
        i_mac_enable     = 1'b1;
        $display("[%0t] C2 read addr1 + MAC enable", $time);

        // C3: read addr 2, MAC on data 1
        #10;
        i_input_rd_addr  = 2;
        i_weight_rd_addr = 2;
        i_mac_enable     = 1'b1;
        $display("[%0t] C3 read addr2 + MAC enable", $time);

        // C4: read addr 3, MAC on data 2
        #10;
        i_input_rd_addr  = 3;
        i_weight_rd_addr = 3;
        i_mac_enable     = 1'b1;
        $display("[%0t] C4 read addr3 + MAC enable", $time);

        // C5: stop read, MAC on data 3
        #10;
        i_input_rd_en    = 1'b0;
        i_weight_rd_en   = 1'b0;
        i_mac_enable     = 1'b1;
        $display("[%0t] C5 stop read + MAC enable", $time);

        // C6: MAC off and write output BRAM (minimum safe timing)
        #10;
        i_mac_enable     = 1'b0;
        i_output_wr_en   = 1'b1;
        i_output_wr_addr = 0;
        $display("[%0t] C6 MAC disable + write addr0", $time);

        // C7: stop write
        #10;
        i_output_wr_en   = 1'b0;
        $display("[%0t] C7 stop write", $time);

        // C8: start read output BRAM addr 0
        #10;
        i_output_rd_en   = 1'b1;
        i_output_rd_addr = 0;
        $display("[%0t] C8 start read output BRAM addr0", $time);

        // C9: sample output while rd_valid should be asserted
        #10;
        if (o_output_rd_valid) begin
            $display("[%0t] OUTPUT BRAM DATA = %h", $time, o_output_rd_dout);
        end else begin
            $display("[%0t] OUTPUT read not valid", $time);
        end
        i_output_rd_en   = 1'b0;
        $display("[%0t] C9 stop read", $time);

        #20;
        $finish;
    end

endmodule
