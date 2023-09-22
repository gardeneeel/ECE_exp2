`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 00:28:15
// Design Name: 
// Module Name: TB_JKFF
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


module TB_JKFF();

reg clk, J, K;
wire Q;

JKFF u0(clk, J, K, Q);

initial begin
    clk <= 0;
    #10 J <= 0;
    K <= 0;
    #30 J <= 0;
    K <= 1;
    #10 J <= 0;
    K <= 0;
    #30 J <= 1;
    K <= 0;
    #10 J <= 0;
    K <= 0;
    #30 J <= 1;
    K <= 1;
    #10 J <= 0;
    K <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule
