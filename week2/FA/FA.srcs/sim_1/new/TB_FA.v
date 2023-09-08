`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/08 17:09:01
// Design Name: 
// Module Name: TB_FA
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


module TB_FA();

reg [2:0] a = 3'b000;
wire C, S;

FA u0(a[0], a[1], a[2], C, S);

initial begin
    while(a < 3'b111)
        begin
        #10
        a = a + 1; 
        end
end

endmodule
