`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/02 23:44:48
// Design Name: 
// Module Name: TB_seg_counter
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


module TB_seg_counter();

reg clk, rst, btn;
wire [7:0] seg_data;
wire [7:0] seg_sel;

seg_counter u0(clk, rst, btn, seg_data, seg_sel);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
end

always begin
    #5 clk <= ~clk;
end

always begin
    #40 btn <= ~btn;
end

endmodule
