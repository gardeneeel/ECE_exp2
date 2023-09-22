`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 01:48:42
// Design Name: 
// Module Name: TB_MUX_8to1
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


module TB_MUX_8to1();

reg [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
reg [2:0] S = 3'b000;
wire [3:0] Y;

MUX_8to1 u0(I0, I1, I2, I3, I4, I5, I6, I7, S[0], S[1], S[2], Y);

initial begin
    I0 = 4'b0001;
    I1 = 4'b0010;
    I2 = 4'b0011;
    I3 = 4'b0100;
    I4 = 4'b0101;
    I5 = 4'b0110;
    I6 = 4'b0111;
    I7 = 4'b1000;
    while(S < 3'b111)
    begin
        #10
        S = S + 1;
    end
end
endmodule
