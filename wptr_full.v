//Author : omghodasara
//Module : wptr_full
//Description : write pointer logic. increments binary pointer, translates to gray code, and generates the full flag.

`timescale 1ns / 1ps

module wptr_full #(
    parameter ADDR_WIDTH = 4
    )(
    input wclk,
    input wrst_n, // write reset ( active low )
    input winc, // write increment
    input [ADDR_WIDTH:0] w2_rptr, // synchronized read pointer 
    output reg wfull,
    output [ADDR_WIDTH-1:0] waddr,
    output reg [ADDR_WIDTH:0] wptr // gray code write pointer sent to the synchronizer
    );
    
    reg [ADDR_WIDTH:0] wbin; // an internal register to keep track of the standard binary count
    
    wire [ADDR_WIDTH:0] wbin_next, wgray_next;
    assign wbin_next = wbin + (winc && !wfull);
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;
    
    assign waddr = wbin[ADDR_WIDTH-1:0];
    
    wire wfull_val = (wgray_next == {~w2_rptr[ADDR_WIDTH], ~w2_rptr[ADDR_WIDTH-1], w2_rptr[ADDR_WIDTH-2:0]});
    
    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            wfull <= 0;
            wptr <= 0;
            wbin <= 0;
        end else begin
            wfull <= wfull_val;
            wptr <= wgray_next;
            wbin <= wbin_next;
        end
    end
    
endmodule
