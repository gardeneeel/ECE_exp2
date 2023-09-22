`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 09:54:26
// Design Name: 
// Module Name: MUX_4to1
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


module MUX_4to1(I0, I1, I2, I3, S0, S1, Y);

input [1:0] I0, I1, I2, I3;
input S0, S1;
output [1:0] Y;

assign Y = S1 ? (S0 ? I3 : I2) : (S0 ? I1 : I0);

endmodule
