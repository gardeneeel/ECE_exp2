`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 00:45:18
// Design Name: 
// Module Name: TB_2bit_upcounter
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


module TB_2bit_upcounter();

reg clk, rst;
reg x;
wire [1:0] state;

upcounter_2bit u0(clk, rst, x, state);

initial begin
    clk <= 0;
    x <= 0;
    rst <= 1;
    #20 rst <= 0;
    #20 rst <= 1; // reset, 00
    #20 x <= 1; // 01
    #20 x <= 0;
    #20 x <= 1; // 10
    #20 x <= 0;
    #20 x <= 1; // 11
    #20 x <= 0;    
    #20 x <= 1; // 00
    #20 x <= 0;
end

always #5 clk <= ~clk;
endmodule
