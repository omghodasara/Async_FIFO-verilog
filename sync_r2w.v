//Author : omghodasara
//Module : sync_r2w
//Description : 2-stage flip-flop synchronizer to safely bring the read pointer into the write clock domain.

`timescale 1ns / 1ps

module sync_r2w #(
    parameter ADDR_WIDTH = 4
    )(
    input wclk,
    input wrst_n,  // active low reset to clear flip-flop
    input [ADDR_WIDTH:0] rptr,  // read pointer
                                // the extra bit represent lap counter
    output reg [ADDR_WIDTH:0] w2_rptr  
    );
    
    reg [ADDR_WIDTH:0] w1_rptr;
    
    always @(posedge wclk or negedge wrst_n) begin 
        if(!wrst_n) begin
            w1_rptr <= 0;
            w2_rptr <= 0;
        end else begin
            w1_rptr <= rptr;
            w2_rptr <= w1_rptr;
        end
    end
    
endmodule
