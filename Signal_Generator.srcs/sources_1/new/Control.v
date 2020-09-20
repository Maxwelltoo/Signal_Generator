`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 17:40:03
// Design Name: 
// Module Name: Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 根据编码器与按键的输入控制波形、振幅、频率和相位
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Control(clk, rst, wav_c, amp_c, f_inc, f_dec, p_inc, p_dec, wave, ampl, phase, frqcy);
    input  clk;
    input  rst;
    input  wav_c;
    input  amp_c;
    input  f_inc; 
    input  f_dec;
    input  p_inc;
    input  p_dec;
    output reg [1 : 0] wave;  // 方波 三角波 锯齿波 正弦波
    output reg [1 : 0] ampl;  // 25% 50% 75% 100% 幅值
    output reg [15: 0] phase; // 相位偏移值：控制初相位
    output reg [15: 0] frqcy; // 相位累加量：控制频率

always @(posedge wav_c or negedge rst) begin //改变波形
    if (!rst)     wave <= 2'b11;
    else if (wav_c) wave <= wave + 1;
end

always @(posedge amp_c or negedge rst) begin //改变幅值
    if (!rst)     ampl <= 2'b00;
    else if (amp_c) ampl <= ampl + 1;
end

always @(posedge p_inc or posedge p_dec or negedge rst) begin //改变相位
    if (!rst)     phase <= 16'h0083;
    else if (p_inc) phase <= phase + 1;
    else if (p_dec) phase <= phase - 1;
end

always @(posedge f_inc or posedge f_dec or negedge rst) begin //改变频率
    if (!rst)     frqcy <= 16'h0083; // 约100Khz
    else if (f_inc) frqcy <= frqcy + 1;
    else if (f_dec) frqcy <= frqcy - 1;
end

endmodule
