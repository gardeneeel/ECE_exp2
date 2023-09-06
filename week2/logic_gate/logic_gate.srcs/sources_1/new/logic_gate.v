`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 23:23:51
// Design Name: 
// Module Name: logic_gate
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


module logic_gate(i0, i1, o1, o2, o3, o4, o5);

input i0, i1;
output o1, o2, o3, o4, o5;

assign o1 = i0 & i1;
assign o2 = i0 | i1;
assign o3 = i0 ^ i1;
assign o4 = ~(i0 | i1);
assign o5 = ~(i0 & i1);

endmodule
