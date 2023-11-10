`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 15:21:03
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
reg [11:0] bcd;
output reg [11:0] bcd_out;

reg [2:0] i;

always @(posedge clk or posedge rst) begin
    if(rst) begin 
        bcd <= {4'd0, 4'd0, 4'd0};
        i <= 0;
    end
    else begin
        if(i == 0) begin
            bcd[11:1] <= 11'b0000_0000_000;
            bcd[0] <= bin[7];
        end
        else begin
            bcd[11:9] <= (bcd[11:8] >= 4'd5) ? bcd[11:8] + 2'd3 : bcd[11:8];
            bcd[8:5] <= (bcd[7:4] >= 4'd5) ? bcd[7:4] + 2'd3 : bcd[7:4];
            bcd[4:1] <= (bcd[4:1] >= 4'd5) ? bcd[4:1] + 2'd3 : bcd[4:1];
            bcd[0] <= bin[7-i];
        end
        i <= i + 1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) bcd_out <= {4'd0, 4'd0, 4'd0};
    else if(i == 0) bcd_out <= bcd;
end

endmodule
