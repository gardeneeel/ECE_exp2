`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 01:38:30
// Design Name: 
// Module Name: MUX_8to1
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


module MUX_8to1(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, Y);

input [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
input S0, S1, S2;
output reg [3:0] Y;

always @(*) begin
    case({S2, S1, S0})
        3'b000: Y = I0;
        3'b001: Y = I1;
        3'b010: Y = I2;
        3'b011: Y = I3;
        3'b100: Y = I4;
        3'b101: Y = I5;
        3'b110: Y = I6;
        3'b111: Y = I7;
        default: Y = 4'b0000;
    endcase
end
endmodule
