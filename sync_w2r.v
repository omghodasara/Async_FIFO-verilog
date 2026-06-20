//Author : omghodasara
//Module : sync_w2r
//Description : 2-stage flip-flop synchronizer to safely bring the write pointer into the read clock domain.

`timescale 1ns / 1ps

module sync_w2r #(
    parameter ADDR_WIDTH = 4
    )(
    input rclk,
    input rrst_n,  // active low reset to clear flip-flop
    input [ADDR_WIDTH:0] wptr,  // write pointer
                                // the extra bit represent lap counter
    output reg [ADDR_WIDTH:0] r2_wptr  
    );
    
    reg [ADDR_WIDTH:0] r1_wptr;
    
    always @(posedge rclk or negedge rrst_n) begin 
        if(!rrst_n) begin
            r1_wptr <= 0;
            r2_wptr <= 0;
        end else begin
            r1_wptr <= wptr;
            r2_wptr <= r1_wptr;
        end
    end
    
endmodule
