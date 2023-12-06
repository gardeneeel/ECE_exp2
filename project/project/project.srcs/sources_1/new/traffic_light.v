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


module traffic_light(clk, rst, clk_sel, btn_1h, btn_manual, 
                     led_w_green, led_w_red, led_green, led_yellow, led_red, led_left,
                     LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst; // 10kHz clk
input [2:0] clk_sel; // {10배, 100배, 200배}, 기본 1배
input btn_1h, btn_manual; // +1h btn, manual control btn

wire btn_1h_t, btn_manual_t;

output reg [3:0] led_w_green; // {S, W, N, E}
output reg [3:0] led_w_red;
output reg [3:0] led_green;
output reg [3:0] led_red;
output reg [3:0] led_left;
output reg [3:0] led_yellow;
reg flicker_enable, led_flicker;
integer cnt_flicker;
reg [3:0] next_led_red;
           
reg [2:0] state;
parameter STATE_A = 3'b000,  
          STATE_B = 3'b001,
          STATE_C = 3'b010,
          STATE_D = 3'b011,
          STATE_E = 3'b100,
          STATE_F = 3'b101,
          STATE_G = 3'b110,
          STATE_H = 3'b111;
integer cnt_state; 
reg passed_G, passed_C; // 분기 조건 
reg manual_enable; // manual control
reg manual_ready;
reg [2:0] next_state;
          
wire day_night;
parameter DAY   = 1'b0,
          NIGHT = 1'b1;        

reg [4:0] cnt_h; // 0 ~ 23h
reg [5:0] cnt_m; // 0 ~ 59m
reg [5:0] cnt_s; // 0 ~ 59s
integer cnt_1s;

wire clk_1, clk_10, clk_100, clk_200; // 1Hz, 10Hz, 100Hz, 200Hz clk
reg clk_s, clk_m, clk_h;
wire clk_h_t;

output LCD_E, LCD_RS, LCD_RW; // LCD control
output [7:0] LCD_DATA;

oneshot_universal #(.WIDTH(3))O1(clk, rst, {btn_1h, btn_manual, clk_h}, {btn_1h_t, btn_manual_t, clk_h_t});
clock_divider #(.p(4999))C1(clk, rst, clk_1); // 1배
clock_divider #(.p(499))C2(clk, rst, clk_10); // 10배
clock_divider #(.p(49))C3(clk, rst, clk_100); // 100배
clock_divider #(.p(24))C4(clk, rst, clk_200); // 200배
LCD_control L1(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, cnt_h, cnt_m, cnt_s, state, day_night);

always @(posedge clk or negedge rst) begin // clk select
    if(!rst) begin
        clk_s <= 0;
        cnt_1s <= 10000;
    end
    else begin
        case(clk_sel)
            3'b000 : begin
                clk_s <= clk_1;
                cnt_1s <= 10000;
            end
            3'b100 : begin
                clk_s <= clk_10;
                cnt_1s <= 1000;
            end
            3'b010 : begin
                clk_s <= clk_100;
                cnt_1s <= 100; 
            end
            3'b001 : begin
                clk_s <= clk_200;
                cnt_1s <= 50; 
            end
            default : begin
                clk_s <= clk_1;
                cnt_1s <= 10000;  
            end
        endcase 
    end
end

always @(posedge clk_s or negedge rst) begin // s counter
    if(!rst) begin
        cnt_s <= 6'b000000;
        clk_m <= 0;
    end
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
    if(!rst) begin
        cnt_m <= 6'b000000;
        clk_h <= 0;
    end
    else if(cnt_m == 6'b111011) begin
        cnt_m <= 6'b000000;
        clk_h <= 1'b1;
    end
    else begin
        cnt_m <= cnt_m + 1;
        clk_h <= 1'b0;
    end
end

always @(posedge clk or negedge rst) begin // h counter
    if(!rst) cnt_h <= 5'b00000;
    else if(btn_1h_t) cnt_h <= (cnt_h == 5'b10111) ? 5'b00000 : cnt_h + 1;
    else if(clk_h_t) cnt_h <= (cnt_h == 5'b10111) ? 5'b00000 : cnt_h + 1;
end

always @(posedge clk or negedge rst) begin // 보행신호등 점멸신호 전환 
    if(!rst) begin
        led_flicker <= 0;
        cnt_flicker <= 0; 
    end
    else if(!flicker_enable) begin
        led_flicker <= 0;
        cnt_flicker <= 0;
    end
    else if(flicker_enable) begin
        if(cnt_flicker >= cnt_1s / 2 - 1) begin // 0.5초마다 전환
            led_flicker <= ~led_flicker; 
            cnt_flicker <= 0;
        end
        else cnt_flicker <= cnt_flicker + 1;
    end
end

assign day_night = (cnt_h >= 8 && cnt_h < 23) ? DAY : NIGHT; // 08:00 ~ 23:00 => DAY, 23:00 ~ 08:00 => NIGHT

always @(posedge clk or negedge rst) begin // state control
    if(!rst) begin
        state          <= STATE_B;
        cnt_state      <= 0;
        passed_G       <= 0;
        passed_C       <= 0;
        next_state     <= 3'b000;
        manual_ready   <= 0;
        manual_enable  <= 0;
        flicker_enable <= 0;
    end
    else if(btn_manual_t) begin // manual control
        next_state   <= state;
        manual_ready <= 1;
        cnt_state    <= 0;
    end
    else if(manual_ready == 1) begin // 1s delay for manual control
        if(cnt_state >= cnt_1s - 1) begin
            state          <= STATE_A;
            cnt_state      <= 0;
            manual_ready   <= 0;
            manual_enable  <= 1; 
            flicker_enable <= 0;
        end     
        else cnt_state <= cnt_state + 1;  
    end
    else if(day_night == DAY) begin // 5s duration per state, A > D > F > E > G > E
        case(state)
            STATE_A : begin
                if(manual_enable) begin // 15s duration for manual control
                    if(cnt_state == 15 * cnt_1s / 2 - 1) flicker_enable <= 1;
                    if(cnt_state >= 15 * cnt_1s - 1) begin
                        state          <= next_state;
                        cnt_state      <= 0;
                        manual_enable  <= 0;
                        flicker_enable <= 0;
                    end    
                    else cnt_state <= cnt_state + 1;
                end
                else if(!manual_enable) begin
                    next_state <= STATE_D;
                    if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                    if(cnt_state >= 5 * cnt_1s - 1) begin
                        state          <= next_state;
                        cnt_state      <= 0;
                        flicker_enable <= 0;
                    end
                    else cnt_state <= cnt_state + 1;
                end    
            end
            STATE_B : begin
                next_state <= STATE_A;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            STATE_C : begin
                next_state <= STATE_A;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_D : begin
                next_state <= STATE_F;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_E : begin
                next_state <= (passed_G) ? STATE_A : STATE_G;            
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1 && passed_G == 0) begin
                    state    <= next_state;
                    passed_G <= 1;
                end
                else if(cnt_state >= 5 * cnt_1s - 1 && passed_G == 1) begin
                    state    <= next_state;
                    passed_G <= 0;
                end                
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            STATE_F : begin
                next_state <= STATE_E;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end             
                else cnt_state <= cnt_state + 1;
            end            
            STATE_G : begin
                next_state <= STATE_E;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_H : begin
                next_state <= STATE_A;
                if(cnt_state == 5 * cnt_1s / 2 - 1) flicker_enable <= 1;
                if(cnt_state >= 5 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            default : state <= STATE_A;                                    
        endcase
    end
    else if(day_night == NIGHT) begin // 10s duration per state, B > A > C > A > E > H
        case(state)
            STATE_A : begin
                if(manual_enable) begin // 15s duration for manual control
                    if(cnt_state == 15 / 2 * cnt_1s - 1) flicker_enable <= 1;
                    if(cnt_state >= 15 * cnt_1s - 1) begin
                        state          <= next_state;
                        cnt_state      <= 0;
                        manual_enable  <= 0;
                        flicker_enable <= 0;
                    end    
                    else cnt_state <= cnt_state + 1;
                end
                else if(!manual_enable) begin
                    next_state <= (passed_C) ? STATE_E : STATE_C;   
                    if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;    
                    if(cnt_state >= 10 * cnt_1s - 1 && passed_C == 0) begin
                        state    <= next_state;
                        passed_C <= 1;
                    end
                    else if(cnt_state >= 10 * cnt_1s - 1 && passed_C == 1) begin
                        state    <= next_state;
                        passed_C <= 0;
                    end
                    if(cnt_state >= 10 * cnt_1s - 1) begin
                        cnt_state      <= 0;
                        flicker_enable <= 0;
                    end
                    else cnt_state <= cnt_state + 1;
                end    
            end
            STATE_B : begin
                next_state <= STATE_A;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            STATE_C : begin
                next_state <= STATE_A;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_D : begin
                next_state <= STATE_B;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_E : begin
                next_state <= STATE_H;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            STATE_F : begin
                next_state <= STATE_B;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_G : begin
                next_state <= STATE_B;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end            
            STATE_H : begin
                next_state <= STATE_B;
                if(cnt_state == 5 * cnt_1s - 1) flicker_enable <= 1;
                if(cnt_state >= 10 * cnt_1s - 1) begin
                    state          <= next_state;
                    cnt_state      <= 0;
                    flicker_enable <= 0;
                end
                else cnt_state <= cnt_state + 1;
            end
            default : state <= STATE_A;                                    
        endcase        
    end    
end

always @(posedge clk or negedge rst) begin // 황색 신호 전환용
    if(!rst) next_led_red <= 4'b0000;
    else begin
        case(next_state)
            STATE_A : next_led_red <= 4'b0101;
            STATE_B : next_led_red <= 4'b1101;
            STATE_C : next_led_red <= 4'b0111;
            STATE_D : next_led_red <= 4'b0101;
            STATE_E : next_led_red <= 4'b1010;
            STATE_F : next_led_red <= 4'b1011;
            STATE_G : next_led_red <= 4'b1110;
            STATE_H : next_led_red <= 4'b1010;
        endcase
    end
end

always @(posedge clk or negedge rst) begin // led control
    if(!rst) begin
         led_w_green <= 4'b0000;
         led_w_red   <= 4'b0000;
         led_green   <= 4'b0000;
         led_yellow  <= 4'b0000;
         led_red     <= 4'b0000;
         led_left    <= 4'b0000;
    end
    else if(day_night == DAY) begin 
        case(state)
            STATE_A : begin
                if(manual_enable) begin
                    led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, led_flicker} : 4'b0101;
                    led_w_red   <= 4'b1010;
                    led_green   <= (cnt_state >= 14 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1010;
                    led_red     <= 4'b0101;
                    led_left    <= (cnt_state >= 14 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;       
                    if(cnt_state == 0) led_yellow <= 4'b0000;
                    else if(cnt_state == 14 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;            
                end
                else if(!manual_enable) begin
                    led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, led_flicker} : 4'b0101;
                    led_w_red   <= 4'b1010;
                    led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1010;
                    led_red     <= 4'b0101;
                    led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;                         
                    if(cnt_state == 0) led_yellow <= 4'b0000;
                    else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;            
                end
            end
            STATE_B : begin
                led_w_green <= (flicker_enable) ? {1'b0, 1'b0, 1'b0, led_flicker} : 4'b0001;
                led_w_red   <= 4'b1110;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0010;
                led_red     <= 4'b1101;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0010;
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red; 
            end            
            STATE_C : begin
                led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, 1'b0} : 4'b0100;
                led_w_red   <= 4'b1011;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1000;
                led_red     <= 4'b0111;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b1000;
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red; 
            end            
            STATE_D : begin
                led_w_green <= 4'b0000;
                led_w_red   <= 4'b1111;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0000;
                led_red     <= 4'b0101;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b1010;                  
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;  
            end            
            STATE_E : begin
                led_w_green <= (flicker_enable) ? {led_flicker, 1'b0, led_flicker, 1'b0} : 4'b1010;
                led_w_red   <= 4'b0101;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0101;
                led_red     <= 4'b1010;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;     
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;         
            end            
            STATE_F : begin
                led_w_green <= (flicker_enable) ? {1'b0, 1'b0, led_flicker, 1'b0} : 4'b0010;
                led_w_red   <= 4'b1101;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0100;
                led_red     <= 4'b1011;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0100;  
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red; 
            end            
            STATE_G : begin
                led_w_green <= (flicker_enable) ? {led_flicker , 1'b0, 1'b0, 1'b0} : 4'b1000;
                led_w_red   <= 4'b0111;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0001;
                led_red     <= 4'b1110;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0001; 
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;            
            end 
            STATE_H : begin
                led_w_green <= 4'b0000;
                led_w_red   <= 4'b1111;
                led_green   <= (cnt_state >= 4 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0000;
                led_red     <= 4'b1010;
                led_left    <= (cnt_state >= 4 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0101;           
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 4 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red; 
            end                  
        endcase
    end
    else if(day_night == NIGHT) begin
        case(state)
            STATE_A : begin
                if(manual_enable) begin
                    led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, led_flicker} : 4'b0101;
                    led_w_red   <= 4'b1010;
                    led_green   <= (cnt_state >= 14 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1010;
                    led_red     <= 4'b0101;
                    led_left    <= (cnt_state >= 14 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;       
                    if(cnt_state == 0) led_yellow <= 4'b0000;
                    else if(cnt_state == 14 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;         
                end
                else if(!manual_enable) begin
                    led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, led_flicker} : 4'b0101;
                    led_w_red   <= 4'b1010;
                    led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1010;
                    led_red     <= 4'b0101;
                    led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;           
                    if(cnt_state == 0) led_yellow <= 4'b0000;
                    else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;                                   
                end
            end
            STATE_B : begin
                led_w_green <= (flicker_enable) ? {1'b0, 1'b0, 1'b0, led_flicker} : 4'b0001;
                led_w_red   <= 4'b1110;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0010;
                led_red     <= 4'b1101;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0010;
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;
            end            
            STATE_C : begin
                led_w_green <= (flicker_enable) ? {1'b0, led_flicker, 1'b0, 1'b0} : 4'b0100;
                led_w_red   <= 4'b1011;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b1000;
                led_red     <= 4'b0111;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b1000;
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;
            end            
            STATE_D : begin
                led_w_green <= 4'b0000;
                led_w_red   <= 4'b1111;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0000;
                led_red     <= 4'b0101;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b1010;        
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;
            end            
            STATE_E : begin
                led_w_green <= (flicker_enable) ? {led_flicker, 1'b0, led_flicker, 1'b0} : 4'b1010;
                led_w_red   <= 4'b0101;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0101;
                led_red     <= 4'b1010;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0000;      
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;
            end            
            STATE_F : begin
                led_w_green <= (flicker_enable) ? {1'b0, 1'b0, led_flicker, 1'b0} : 4'b0010;
                led_w_red   <= 4'b1101;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0100;
                led_red     <= 4'b1011;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0100;    
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;  
            end            
            STATE_G : begin
                led_w_green <= (flicker_enable) ? {led_flicker, 1'b0, 1'b0, 1'b0} : 4'b1000;
                led_w_red   <= 4'b0111;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0001;
                led_red     <= 4'b1110;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0001;            
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;
            end 
            STATE_H : begin
                led_w_green <= 4'b0000;
                led_w_red   <= 4'b1111;
                led_green   <= (cnt_state >= 9 * cnt_1s - 1) ? led_green & ~next_led_red : 4'b0000;
                led_red     <= 4'b1010;
                led_left    <= (cnt_state >= 9 * cnt_1s - 1) ? led_left & ~next_led_red : 4'b0101;              
                if(cnt_state == 0) led_yellow <= 4'b0000;
                else if(cnt_state == 9 * cnt_1s - 1) led_yellow <= (led_green | led_left) & next_led_red;              
            end                  
        endcase        
    end
end

endmodule
