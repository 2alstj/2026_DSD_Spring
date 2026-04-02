`timescale 1ps/1ps

module tb_init_file();
    parameter WIDTH = 16;
    parameter DEPTH = 4;
    parameter ADDR_WIDTH = $clog2(DEPTH);
    parameter INIT_FILE = "C:\\dsd\\week_4\\input.txt";

    reg                         clk;
    reg                         rstn;

    reg                         wr_en; 
    reg     [ADDR_WIDTH-1:0]    wr_addr;
    reg     [WIDTH-1:0]         wr_din;

    reg                         rd_en;
    reg     [ADDR_WIDTH-1:0]    rd_addr;

    wire    [WIDTH-1:0]         rd_dout;
    wire                        rd_valid;

    simple_dual_port_bram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .INIT_FILE(INIT_FILE)
    )bram(
        .clk(clk),
        .rstn(rstn),

        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_din(wr_din),

        .rd_en(rd_en),
        .rd_addr(rd_addr),

        .rd_dout(rd_dout),
        .rd_valid(rd_valid)    
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic bram_write(
        input [ADDR_WIDTH-1:0]  addr,
        input [WIDTH-1:0]       data
    );
    begin 
        @(negedge clk);
        wr_en = 1'b1;
        wr_addr = addr;
        wr_din = data;

        @(negedge clk);
        $display("[%0t] WRITE : addr = %0d, data = 0x%04h", $time, addr, data);
        
        wr_en = 0;
        wr_addr = {ADDR_WIDTH{1'b0}};
        wr_din = {WIDTH{1'b0}};
    end
    endtask

    task automatic bram_read(
        input [ADDR_WIDTH-1:0] addr
    );
    begin
        @(negedge clk);
        rd_en = 1'b1;
        rd_addr = addr;

        @(negedge clk);
        $display("[%0t] READ : addr = %0d, data = 0x%04h", $time, addr, rd_dout);

        rd_en = 1'b0;
        rd_addr = {ADDR_WIDTH{1'b0}};
    end
    endtask

    initial begin
        //initial 
        clk = 1'b0;
        rstn = 1'b0;
        wr_en = 1'b0;
        wr_addr = {ADDR_WIDTH{1'b0}};
        wr_din = {WIDTH{1'b0}};
        rd_en = 1'b0;
        rd_addr = {ADDR_WIDTH{1'b0}};

        repeat(2) @(posedge clk);
        rstn = 1'b1;
        
        $display("==============================================");
        $display("      SIMPLE DUAL PORT BRAM TEST START        ");
        $display("==============================================");
        $display("[%0t] reset deasserted", $time);

        bram_read(2'd0);
        bram_read(2'd1);
        bram_read(2'd2);
        bram_read(2'd3);

        bram_write(2'd0, 16'h1111);
        bram_write(2'd1, 16'h2222);
        bram_write(2'd2, 16'h3333);
        bram_write(2'd3, 16'h4444);

        bram_read(2'd0);
        bram_read(2'd1);
        bram_read(2'd2);
        bram_read(2'd3);

        $display("==============================================");
        $display("             TEST FINISHED                    ");
        $display("==============================================");

        #1 $finish;
    end

endmodule