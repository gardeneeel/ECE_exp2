`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 01:10:55
// Design Name: 
// Module Name: 3bit_updowncounter
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


module updowncounter_3bit(clk, rst, x, state);

input clk, rst;
input x;
reg x_reg, x_trig;
reg up_down; // 0 -> up / 1 -> down
output reg [2:0] state;

always @(negedge rst or posedge clk) begin
    if(!rst) {x_reg, x_trig} <= 2'b00;
    else begin
        x_reg <= x;
        x_trig <= x & ~x_reg;
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        state <= 3'b000;
    end
    else if(!up_down) begin // upcount
        case(state)
            3'b000 : state <= x_trig ? 3'b001 : 3'b000;
            3'b001 : state <= x_trig ? 3'b010 : 3'b001;
            3'b010 : state <= x_trig ? 3'b011 : 3'b010;
            3'b011 : state <= x_trig ? 3'b100 : 3'b011;
            3'b100 : state <= x_trig ? 3'b101 : 3'b100;
            3'b101 : state <= x_trig ? 3'b110 : 3'b101;
            3'b110 : state <= x_trig ? 3'b111 : 3'b110;
        endcase     
    end
    else if(up_down) begin // downcount
        case(state)
            3'b111 : state <= x_trig ? 3'b110 : 3'b111;
            3'b110 : state <= x_trig ? 3'b101 : 3'b110;
            3'b101 : state <= x_trig ? 3'b100 : 3'b101;
            3'b100 : state <= x_trig ? 3'b011 : 3'b100;
            3'b011 : state <= x_trig ? 3'b010 : 3'b011;
            3'b010 : state <= x_trig ? 3'b001 : 3'b010;
            3'b001 : state <= x_trig ? 3'b000 : 3'b001;
        endcase
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) up_down <= 0; // up
    else begin
        case(state)
            3'b000 : up_down <= 0;
            3'b111 : up_down <= 1;
        endcase
    end
end
endmodule
