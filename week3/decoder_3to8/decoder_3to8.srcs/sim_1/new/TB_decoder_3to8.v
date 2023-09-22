`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 00:43:11
// Design Name: 
// Module Name: TB_decoder_3to8
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


module TB_decoder_3to8();

reg x, y, z;
wire [7:0] D;

decoder_3to8 u0(x, y, z, D);

initial begin
    {x, y, z} = 3'b000;
    while({x, y, z} < 3'b111)
        begin
        #10
        {x, y, z} = {x, y, z} + 1;
        end
end
endmodule
