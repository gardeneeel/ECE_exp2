`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 10:42:54
// Design Name: 
// Module Name: bin_to_BCD
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


module bin_to_BCD(clk, rst, bin, bcd_out);

input clk, rst;
input [7:0] bin;
reg [7:0] bcd;
output reg [7:0] bcd_out;

reg [2:0] i;

always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        bcd <= {4'd0, 4'd0};
        i <= 0;
    end
    else begin
        if(i == 0) begin
            bcd[7:1] <= 7'b0000_000;
            bcd[0] <= bin[7];
        end
        else begin
            bcd[7:5] <= (bcd[7:4] >= 3'd5) ? bcd[7:4] + 2'd3 : bcd[7:4];
            bcd[4:1] <= (bcd[3:0] >= 3'd5) ? bcd[3:0] + 2'd3 : bcd[3:0];
            bcd[0] <= bin[7-i];
        end
        i <= i + 1;
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) bcd_out <= {4'd0, 4'd0};
    else if(i == 0) bcd_out <= bcd;
end

endmodule
