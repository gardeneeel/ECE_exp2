`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 23:55:15
// Design Name: 
// Module Name: TB_DFF
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


module TB_DFF();

reg clk, D;
wire Q;

DFF u0(clk, D, Q);

initial begin
    clk <= 0;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
    #30 D <= 1;
    #30 D <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule
