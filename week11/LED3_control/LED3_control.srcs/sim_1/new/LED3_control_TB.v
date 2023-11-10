`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 23:57:48
// Design Name: 
// Module Name: LED3_control_TB
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


module LED3_control_TB();

reg clk, rst;
reg [7:0] btn;

wire [3:0] led_signal_R;
wire [3:0] led_signal_G;
wire [3:0] led_signal_B;

LED3_control u0(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

initial begin
    clk <= 0;
    rst <= 0;
    btn <= 8'b00000000;
    #10 rst <= 1;
    #10 rst <= 0;
    #512 btn <= 8'b00000001; // red
    #512 btn <= 8'b00000010; // orange
    #512 btn <= 8'b00000100; // yellow
end

always #0.5 clk <= ~clk;

endmodule
