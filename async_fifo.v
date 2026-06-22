//Author : omghodasara
//Module : async_fifo
//Description : top-level wrapper for the asynchronous FIFO. instantiates and connects all sub-modules.

`timescale 1ns / 1ps

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
    )(
    input wclk,
    input wrst_n,
    input winc,
    input rclk,
    input rrst_n,
    input rinc,
    input [DATA_WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [DATA_WIDTH-1:0] rdata
    );
    
    wire [ADDR_WIDTH:0] wptr, rptr, w2_rptr, r2_wptr;
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    
    fifomem #(
        .DATA_WIDTH(DATA_WIDTH), 
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifomem (
        .wclk(wclk),
        .wclken(winc),
        .wfull(wfull),
        .waddr(waddr),
        .wdata(wdata),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    sync_w2r #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_sync_w2r (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .wptr(wptr),
        .r2_wptr(r2_wptr)
    );
    
    sync_r2w #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_sync_r2w (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .rptr(rptr),
        .w2_rptr(w2_rptr)
    );
    
    rptr_empty #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_rptr_empty (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .r2_wptr(r2_wptr),
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr)
    );
    
    wptr_full #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_wptr_full (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .w2_rptr(w2_rptr),
        .wfull(wfull),
        .waddr(waddr),
        .wptr(wptr)
    );
        
endmodule
