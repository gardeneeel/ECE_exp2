`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/10 22:27:27
// Design Name: 
// Module Name: SM1
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


module SM1(clk, rst, x, y, state);

input clk, rst, x;

output reg [1:0] state;
output reg y;
reg x_trig, x_reg;

always @(posedge clk or negedge rst) begin // state
    if(!rst) state <= 2'b00;
    else begin
        case(state)
            2'b00: state <= x ? 2'b01 : 2'b00;
            2'b01: state <= x ? 2'b11 : 2'b00;
            2'b10: state <= x ? 2'b10 : 2'b00;
            2'b11: state <= x ? 2'b10 : 2'b00;
        endcase
    end
end

always @(posedge clk or negedge rst) begin // output
    if(!rst) y <= 0;
    else begin
        case(state)
            2'b00: y <= 1'b0;
            2'b01: y <= x ? 1'b0 : 1'b1;
            2'b10: y <= x ? 1'b0 : 1'b1;
            2'b11: y <= x ? 1'b0 : 1'b1;
        endcase
    end
end
endmodule
