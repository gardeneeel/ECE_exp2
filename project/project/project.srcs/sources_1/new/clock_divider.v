`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 00:16:53
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(clk_in, rst, clk_out);

parameter p = 1; // 4999 for 1Hz output
input clk_in; // input clk 10kHz
input rst;

output reg clk_out; // 1Hz

reg [25:0] q;
wire [25:0] r;

always @(posedge clk_in or negedge rst) begin
    if(!rst) begin
        q <= 0;
        clk_out <= 0;
    end
    else if(q == p) begin
        clk_out <= ~clk_out;
        q <= 0;
    end
    else q <= r;
end

assign r = q + 1;

endmodule
