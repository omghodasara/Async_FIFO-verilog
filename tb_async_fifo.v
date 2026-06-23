//Author : omghodasara
//Module : tb_async_fifo
//Description : testbench for the Asynchronous FIFO. verifies standard traffic, underflow protection, and overflow boundaries to expose CDC logic and memory safeguard failures (if present).

`timescale 1ns / 1ps

module tb_async_fifo();

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg wclk, wrst_n, winc;
    reg rclk, rrst_n, rinc;
    reg [DATA_WIDTH-1:0] wdata;
    
    wire wfull, rempty;
    wire [DATA_WIDTH-1:0] rdata;

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .rdata(rdata)
    );

    initial wclk = 0;
    always #5 wclk = ~wclk;   // 10ns period (100 MHz)

    initial rclk = 0;
    always #12 rclk = ~rclk;  // 24ns period (~41.6 MHz)

    // the stimulus block 
    integer i;

    initial begin
        $dumpfile("fifo_waveform.vcd");
        $dumpvars(0, tb_async_fifo);

        $display("--- Starting Async FIFO Verification ---");
        wrst_n = 0; winc = 0; wdata = 0;
        rrst_n = 0; rinc = 0;
        #20;
        wrst_n = 1; rrst_n = 1;
        #20;

        // TEST 1: normal sanity check
        $display("TEST 1: Writing and Reading 4 items (Sanity Check)");
        
        // write 4 items
        for (i = 1; i <= 4; i = i + 1) begin
            @(posedge wclk); #1;
            winc = 1; wdata = i; 
        end
        @(posedge wclk); #1; winc = 0;
        repeat(5) @(posedge rclk); // wait for sync
        
        // read 4 items
        for (i = 1; i <= 4; i = i + 1) begin
            @(posedge rclk); #1;
            rinc = 1;
        end
        @(posedge rclk); #1; rinc = 0;
        repeat(5) @(posedge rclk);

        // TEST 2: underflow check 
        $display("TEST 2: Attempting to read from an empty FIFO (Underflow Check)");
        
        // FIFO is currently empty. let's try to read anyway.
        @(posedge rclk); #1;
        rinc = 1; 
        repeat(3) @(posedge rclk); // trying to read 3 times
        #1; rinc = 0;
        repeat(5) @(posedge wclk);

        // TEST 3: overflow test 
        $display("TEST 3: Pushing FIFO past capacity (Overflow Check)");
        
        // We will aggressively write 18 items into a 16-slot FIFO.
        for (i = 101; i <= 118; i = i + 1) begin
            @(posedge wclk); #1;
            winc = 1; 
            wdata = i; // using 100s so it looks different from Test 1
        end
        @(posedge wclk); #1; winc = 0;
        repeat(5) @(posedge rclk); 

        // read the whole room back to check for corruption
        rinc = 1;
        repeat(18) @(posedge rclk);
        rinc = 0;

        #50;
        $display("--- Verification Complete. Check Waveforms! ---");
        $finish;
    end

endmodule