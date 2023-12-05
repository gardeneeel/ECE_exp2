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

parameter p = 1; // clk_in frequency / (2 * (p + 1)) = clk_out frequency
input clk_in; // input clk 10kHz
input rst;

output reg clk_out; 

reg [25:0] q;
wire [25:0] r;
reg init;

always @(posedge clk_in or negedge rst) begin
    if(!rst) begin
        q <= 0;
        clk_out <= 0;
        init <= 1;
    end
    else if(q == p) begin
        if(init) begin
            q <= 0;
            init <= 0;
        end
        else begin
            clk_out <= ~clk_out;
            q <= 0;
        end
    end
    else q <= r;
end

assign r = q + 1;

endmodule
