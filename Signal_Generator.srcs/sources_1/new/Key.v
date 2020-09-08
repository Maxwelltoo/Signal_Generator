`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SCNU
// Engineer: WJX
// 
// Create Date: 2020/09/02 21:57:06
// Design Name: Signal_Generator
// Module Name: Key
// Project Name: Signal_Generator
// Target Devices: xc7z020clg484-1
// Tool Versions: Vivado 2019.2
// Description: 按键消抖 
//              当按键被按下时，延时消抖并输出一个时钟周期的脉冲
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Revision 1.00 - 逻辑设计完成
// Additional Comments:未仿真
// 
//////////////////////////////////////////////////////////////////////////////////

module Key(clk, rst, key_i, key_o);
    input  clk;      // 系统时钟 50Mhz
    input  rst;      // 复位信号 低电平有效
    input  key_i;    // 按键消抖前
    output key_o;    // 按键输出

    reg [1:0] key_state;      // 1:前一时刻按键状态  0：当前按键状态
    reg [1:0] key_delay;      // 1:延时前按键状态  0：延时后按键状态
    wire press;               // 按键按下信号
    localparam C=20'd999_999; // 50Mhz/999999+1=50hz
    reg [19:0] cnt;           // 1/50hz=20ms

    always @(posedge clk or negedge rst) begin
        if (!rst)  key_state <= 2'b11;
        else       key_state <= {key_state[0], key_i};
    end

    assign press = key_state[1] & ~key_state[0];

    always @(posedge clk or negedge rst) begin
        if(!rst| press)  cnt <= 20'b0;
        else if(cnt==C)  cnt <= 20'b0;
        else             cnt <= cnt+1;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)        key_delay[0] <= 1'b1;
        else if(cnt==C)  key_delay[0] <= key_i;
    end
    
    always @(posedge clk or negedge rst) begin
        if (!rst)        key_delay[1] <= 1'b1;
        else             key_delay[1] <= key_delay[0];
    end

    assign press = key_state[1] & ~key_state[0];

endmodule
