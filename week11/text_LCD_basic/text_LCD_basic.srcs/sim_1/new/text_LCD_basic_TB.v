`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 23:49:09
// Design Name: 
// Module Name: text_LCD_basic_TB
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


module text_LCD_basic_TB();

reg clk, rst;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

text_LCD_basic u0(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

initial begin
    clk <= 0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
end

always #5 clk <= ~clk;

endmodule
