`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 00:29:06
// Design Name: 
// Module Name: 2bit_upcounter
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


module upcounter_2bit(clk, rst, x, state);

input clk, rst;
input x;
reg x_trig, x_reg;
output reg [1:0] state;

always @(negedge rst or posedge clk) begin
    if(!rst) {x_trig, x_reg} <= 2'b00;
    else begin
        x_reg <= x;
        x_trig <= x & ~x_reg;
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        case(state)
            2'b00 : state <= x_trig ? 2'b01 : 2'b00;
            2'b01 : state <= x_trig ? 2'b10 : 2'b01;
            2'b10 : state <= x_trig ? 2'b11 : 2'b10;
            2'b11 : state <= x_trig ? 2'b00 : 2'b11;
        endcase
    end
end

endmodule
