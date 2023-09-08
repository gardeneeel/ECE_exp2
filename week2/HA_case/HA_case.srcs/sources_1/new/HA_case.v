`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 12:40:26
// Design Name: 
// Module Name: HA_case
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


module HA_case(a, C, S);

input [1:0] a;
output reg C, S;

always @(*) begin
    case(a)
        2'b00: begin
            C = 0;
            S = 0;
        end
        2'b01: begin
            C = 0;
            S = 1;
        end
        2'b10: begin
            C = 0;
            S = 1;
        end
        2'b11: begin
            C = 1;
            S = 0;
        end
        default: begin
            C = 0;
            S = 0;
        end
    endcase
end
endmodule
