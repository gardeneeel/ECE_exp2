`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 00:19:58
// Design Name: 
// Module Name: TB_comparator_4bit
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


module TB_comparator_4bit();

reg [3:0] a, b;
wire x, y, z;

comparator_4bit u0(a, b, x, y, z);

initial begin
    a = 4'b0011;
    b = 4'b1000; #10
    a = 4'b0111;
    b = 4'b0001; #10
    a = 4'b1001;
    b = 4'b1001; #10
    a = 4'b1011;
    b = 4'b1111;
end

endmodule
