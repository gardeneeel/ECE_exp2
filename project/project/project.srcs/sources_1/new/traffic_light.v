`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 22:45:12
// Design Name: 
// Module Name: traffic_light
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


module traffic_light(clk, rst, led_w_green, led_w_red, led_green, led_yellow, led_red, led_left,
                     LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst; // 10kHz clk

output reg [3:0] led_w_green; // {S, W, N, E}
output reg [3:0] led_w_red;
output reg [3:0] led_green;
output reg [3:0] led_yellow;
output reg [3:0] led_red;
output reg [3:0] led_left;
           
reg [2:0] state;
parameter STATE_A = 3'b000,  
          STATE_B = 3'b001,
          STATE_C = 3'b010,
          STATE_D = 3'b011,
          STATE_E = 3'b100,
          STATE_F = 3'b101,
          STATE_G = 3'b110,
          STATE_H = 3'b111;
reg passed_G, passed_C; // 분기 조건        
          
wire day_night;
parameter DAY   = 1'b0,
          NIGHT = 1'b1;        

reg [3:0] cnt_state;

reg [4:0] cnt_h; // 0 ~ 23h
reg [5:0] cnt_m; // 0 ~ 59m
reg [5:0] cnt_s; // 0 ~ 59s

wire clk_s; // 1Hz clk
reg clk_m, clk_h;

output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;

clock_divider #(.p(4999))C1(clk, rst, clk_s);
LCD_control L1(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, cnt_h, cnt_m, cnt_s, state, day_night);

always @(posedge clk_s or negedge rst) begin // s counter
    if(!rst) cnt_s <= 6'b000000;
    else if(cnt_s == 6'b111011) begin
        cnt_s <= 6'b000000;
        clk_m <= 1'b1;
    end
    else begin
        cnt_s <= cnt_s + 1;
        clk_m <= 1'b0;
    end   
end          

always @(posedge clk_m or negedge rst) begin // m counter
    if(!rst) cnt_m <= 6'b000000;
    else if(cnt_m == 6'b111011) begin
        cnt_m <= 6'b000000;
        clk_h <= 1'b1;
    end
    else begin
        cnt_m <= cnt_m + 1;
        clk_h <= 1'b0;
    end
end

always @(posedge clk_h or negedge rst) begin // h counter
    if(!rst) cnt_h <= 5'b00000;
    else if(cnt_h == 5'b10111) begin
        cnt_h <= 5'b00000;
    end
    else begin
        cnt_h <= cnt_h + 1;
    end
end

assign day_night = (cnt_h >= 8 && cnt_h < 23) ? DAY : NIGHT;

always @(posedge clk_s or negedge rst) begin // state control
    if(!rst) begin
        state <= STATE_A;
        cnt_state <= 0;
        passed_G <= 0;
        passed_C <= 0;
    end
    else if(day_night == DAY) begin // 5s duration
        case(state)
            STATE_A : begin
                if(cnt_state == 4) state <= STATE_D;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_B : begin
                if(cnt_state == 4) state <= STATE_A;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_C : begin
                if(cnt_state == 4) state <= STATE_A;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_D : begin
                if(cnt_state == 4) state <= STATE_F;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_E : begin
                if(cnt_state == 4 && passed_G == 0) begin
                    state <= STATE_G;
                    passed_G <= 1;
                end
                else if(cnt_state == 4 && passed_G == 1) begin
                    state <= STATE_A;
                    passed_G <= 0;
                end
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_F : begin
                if(cnt_state == 4) state <= STATE_E;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_G : begin
                if(cnt_state == 4) state <= STATE_E;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_H : begin
                if(cnt_state == 4) state <= STATE_A;
                if(cnt_state >= 4) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            default : state <= STATE_A;                                    
        endcase
    end
    else if(day_night == NIGHT) begin // 10s duration
        case(state)
            STATE_A : begin
                if(cnt_state == 9 && passed_C == 0) begin
                    state <= STATE_C;
                    passed_C <= 1;
                end
                else if(cnt_state == 9 && passed_C == 1) begin
                    state <= STATE_E;
                    passed_C <= 0;
                end
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_B : begin
                if(cnt_state == 9) state <= STATE_A;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_C : begin
                if(cnt_state == 9) state <= STATE_A;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_D : begin
                if(cnt_state == 9) state <= STATE_B;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_E : begin
                if(cnt_state == 9) state <= STATE_H;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            STATE_F : begin
                if(cnt_state == 9) state <= STATE_B;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_G : begin
                if(cnt_state == 9) state <= STATE_B;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end            
            STATE_H : begin
                if(cnt_state == 9) state <= STATE_B;
                if(cnt_state >= 9) cnt_state <= 0;
                else cnt_state <= cnt_state + 1;
            end
            default : state <= STATE_A;                                    
        endcase        
    end    
end

always @(posedge clk or negedge rst) begin // led control
    if(!rst) begin
         led_w_green <= 4'b0000;
         led_w_red <= 4'b0000;
         led_green <= 4'b0000;
         led_yellow <= 4'b0000;
         led_red <= 4'b0000;
         led_left <= 4'b0000;
    end
    else begin
        case(state)
            STATE_A : begin
                led_w_green <= 4'b0101;
                led_w_red <= 4'b1010;
                led_green <= 4'b1010;
                led_red <= 4'b0101;
                led_left <= 4'b0000;
            end
            STATE_B : begin
                led_w_green <= 4'b0001;
                led_w_red <= 4'b1110;
                led_green <= 4'b0010;
                led_red <= 4'b1101;
                led_left <= 4'b0010;
            end            
            STATE_C : begin
                led_w_green <= 4'b0100;
                led_w_red <= 4'b1011;
                led_green <= 4'b1000;
                led_red <= 4'b0111;
                led_left <= 4'b1000;
            end            
            STATE_D : begin
                led_w_green <= 4'b0000;
                led_w_red <= 4'b1111;
                led_green <= 4'b0000;
                led_red <= 4'b0101;
                led_left <= 4'b1010;        
            end            
            STATE_E : begin
                led_w_green <= 4'b1010;
                led_w_red <= 4'b0101;
                led_green <= 4'b0101;
                led_red <= 4'b1010;
                led_left <= 4'b0000;        
            end            
            STATE_F : begin
                led_w_green <= 4'b0010;
                led_w_red <= 4'b1101;
                led_green <= 4'b0100;
                led_red <= 4'b1011;
                led_left <= 4'b0100;        
            end            
            STATE_G : begin
                led_w_green <= 4'b1000;
                led_w_red <= 4'b0111;
                led_green <= 4'b0001;
                led_red <= 4'b1110;
                led_left <= 4'b0001;            
            end 
            STATE_H : begin
                led_w_green <= 4'b0000;
                led_w_red <= 4'b1111;
                led_green <= 4'b0000;
                led_red <= 4'b1010;
                led_left <= 4'b0101;            
            end                  
        endcase
    end
end
endmodule
