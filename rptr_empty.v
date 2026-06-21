//Author : omghodasara
//Module : rptr_empty
//Description : read pointer logic. increments binary pointer, translates to gray code, and generates the empty flag.

`timescale 1ns / 1ps

module rptr_empty #(
    parameter ADDR_WIDTH = 4
    )(
    input rclk,
    input rrst_n, // read reset ( active low )
    input rinc, // read increment
    input [ADDR_WIDTH:0] r2_wptr, // synchronized write pointer 
    output reg rempty,
    output [ADDR_WIDTH-1:0] raddr,
    output reg [ADDR_WIDTH:0] rptr //Gray code read pointer sent to the synchronizer
    );
    
    reg [ADDR_WIDTH:0] rbin; // an internal register to keep track of the standard binary count
    
    wire [ADDR_WIDTH:0] rbin_next, rgray_next;
    assign rbin_next = rbin + (rinc && !rempty);
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;
    
    assign raddr = rbin[ADDR_WIDTH-1:0];
    
    wire rempty_val = (rgray_next == r2_wptr);
    
    always @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            rempty <= 1;
            rptr <= 0;
            rbin <= 0;
        end else begin
            rempty <= rempty_val;
            rptr <= rgray_next;
            rbin <= rbin_next;
        end
    end

endmodule
