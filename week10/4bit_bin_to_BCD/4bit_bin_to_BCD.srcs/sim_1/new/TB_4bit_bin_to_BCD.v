`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/02 21:09:17
// Design Name: 
// Module Name: TB_4bit_bin_to_BCD
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


module TB_4bit_bin_to_BCD();

reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

bin_to_BCD_4bit u0(clk, rst, bin, bcd);

initial begin
    clk <= 0;
    bin <= 4'b0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    while(bin < 4'b1111) begin
        #20 bin <= bin + 1;
    end
end

always begin
    #5 clk <= ~clk;
end
endmodule
