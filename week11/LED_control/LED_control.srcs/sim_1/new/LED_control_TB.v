`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 16:13:06
// Design Name: 
// Module Name: LED_control_TB
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


module LED_control_TB();

reg clk, rst;
reg [7:0] bin;
wire [7:0] seg_data;
wire [7:0] seg_sel;
wire led_signal;

LED_control u0(clk, rst, bin, seg_data, seg_sel, led_signal);

initial begin
    clk <= 0;
    rst <= 0;
    bin <= 8'b0000_0000;
    #10 rst <= 1;
    #10 rst <= 0;
    #512 bin <= 8'b0000_0000; // 0% duty cycle
    #512 bin <= 8'b0011_1111; // 25%
    #512 bin <= 8'b0111_1111; // 50%
    #512 bin <= 8'b1011_1111; // 75%
    #512 bin <= 8'b1111_1111; // 100%
end

always #0.5 clk <= ~clk;

endmodule
