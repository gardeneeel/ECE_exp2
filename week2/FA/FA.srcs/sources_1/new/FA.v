`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/08 16:59:47
// Design Name: 
// Module Name: FA
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


module FA(x, y, z, C, S);

input x, y, z;
output C, S;

wire S1, C1, C2;

HA u1(x, y, C1, S1);
HA u2(z, S1, C2, S);

assign C = C1 | C2;

endmodule
