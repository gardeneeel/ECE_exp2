`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 00:54:13
// Design Name: 
// Module Name: TB_oneshot_TFF
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


module TB_oneshot_TFF();

reg clk, rst, T;
wire Q;

oneshot_TFF u0(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    T <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule