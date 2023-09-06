`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 23:25:55
// Design Name: 
// Module Name: TB_logic_gate
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


module TB_logic_gate();

reg i0, i1;
wire o1 ,o2, o3, o4, o5;

logic_gate u0(i0, i1, o1, o2, o3, o4, o5);

initial begin
    i0 = 0;
    i1 = 0; #10
    i0 = 1; #10
    i0 = 0;
    i1 = 1; #10
    i0 = 1;
end

endmodule
