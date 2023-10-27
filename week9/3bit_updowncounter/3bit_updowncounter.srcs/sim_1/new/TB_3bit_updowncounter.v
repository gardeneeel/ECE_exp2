`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 01:41:34
// Design Name: 
// Module Name: TB_3bit_updowncounter
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


module TB_3bit_updowncounter();

reg clk, rst;
reg x;
wire [2:0] state;

updowncounter_3bit u0(clk, rst, x, state);

initial begin
    clk <= 0;
    x <= 0;
    rst <= 1;
    #20 rst <= 0;
    #20 rst <= 1; // reset, 000
    #20 x <= 1; // 001
    #20 x <= 0;
    #20 x <= 1; // 010
    #20 x <= 0;
    #20 x <= 1; // 011
    #20 x <= 0;
    #20 x <= 1; // 100
    #20 x <= 0;
    #20 x <= 1; // 101
    #20 x <= 0;
    #20 x <= 1; // 110
    #20 x <= 0;
    #20 x <= 1; // 111
    #20 x <= 0;
    #20 x <= 1; // 110
    #20 x <= 0;
    #20 x <= 1; // 101
    #20 x <= 0;
    #20 x <= 1; // 100
    #20 x <= 0;
    #20 x <= 1; // 011
    #20 x <= 0;
    #20 x <= 1; // 010
    #20 x <= 0;
    #20 x <= 1; // 001
    #20 x <= 0;
    #20 x <= 1; // 000
    #20 x <= 0;
end

always #5 clk <= ~clk;
endmodule
