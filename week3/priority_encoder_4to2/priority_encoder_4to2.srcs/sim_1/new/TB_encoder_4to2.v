`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 01:30:03
// Design Name: 
// Module Name: TB_encoder_4to2
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


module TB_encoder_4to2();

reg [3:0] D;
wire x, y, V;

priority_encoder_4to2 u0(D, x, y, V);

initial begin
    D = 4'b0000; #10
    D = 4'b1000; #10
    D = 4'b1011; #10
    D = 4'b0101; #10
    D = 4'b0001;
end
endmodule
