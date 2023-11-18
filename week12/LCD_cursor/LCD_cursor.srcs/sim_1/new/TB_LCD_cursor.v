`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 16:25:57
// Design Name: 
// Module Name: TB_LCD_cursor
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


module TB_LCD_cursor();

reg clk, rst;
reg [9:0] number_btn;
reg [1:0] control_btn;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

LCD_cursor u0(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);

initial begin
    clk <= 0;
    rst <= 1;
    number_btn <= 10'b0000_0000_00;
    control_btn <= 2'b00;
    #10 rst <= 0;
    #10 rst <= 1;
    #300 number_btn <= 10'b1000_0000_00; // 1
    #30 number_btn <= 10'b0000_0000_00; 
    #30 control_btn <= 2'b10; // cursor shift left
    #30 control_btn <= 2'b00;
    #30 number_btn <= 10'b0000_0000_01; // 0
    #30 number_btn <= 10'b0000_0000_00;
    #30 control_btn <= 2'b01; // cursor shift right
    #30 control_btn <= 2'b00;
end

always #0.5 clk <= ~clk; // clock frequency 1MHz\

endmodule
