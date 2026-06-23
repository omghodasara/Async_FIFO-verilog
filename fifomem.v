//Author : omghodasara
//Module : fifomem 
//Description : memory array for the FIFO. write uses clock, read just looks.

`timescale 1ns / 1ps

module fifomem  #(
    parameter DATA_WIDTH = 8,  
    parameter ADDR_WIDTH = 4   
    )(
    input wclk,
    input wclken,
    input wfull,
    input [ADDR_WIDTH-1:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input [ADDR_WIDTH-1:0] raddr,
    output [DATA_WIDTH-1:0] rdata
    );
    
    localparam DEPTH = 1 << ADDR_WIDTH;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    assign rdata = mem[raddr];
    
    always @(posedge wclk) begin
        if(wclken && !wfull)
            mem[waddr] <= wdata;
    end
    
endmodule

