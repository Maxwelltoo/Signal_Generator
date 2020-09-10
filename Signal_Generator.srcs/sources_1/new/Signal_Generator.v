`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SCNU
// Engineer: WJX
// 
// Create Date: 2020/09/02 19:01:41
// Design Name: Signal_Generator
// Module Name: Signal_Generator
// Project Name: Signal_Generator
// Target Devices: xc7z020clg484-1
// Tool Versions: Vivado 2019.2
// Description: 基于DDS的信号发生器
// 
// DDS模块设置：16bit相位累加器，762.9hz频率分辨率
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Signal_Generator(
    input  CLK_50M,
    input  RST_N,
    input  ENC_1_A, 
    input  ENC_1_B, 
    input  ENC_2_A, 
    input  ENC_2_B,
    input  KEY_1,
    input  KEY_2,
    output DAC_SYNC,
    output DAC_SCLK,
    output DAC_DIN);

wire       wav, amp, f_inc, f_dec, p_inc, p_dec;
//波形控制 波形 幅值 频率+ 频率- 相位+ 相位-

Key key_wav(CLK_50M, RST_N, KEY_1, wav);
Key key_amp(CLK_50M, RST_N, KEY_2, amp);
Encoder enc_freq(CLK_50M, RST_N, ENC_1_A, ENC_1_B, f_inc, f_dec);
Encoder enc_phas(CLK_50M, RST_N, ENC_2_A, ENC_2_B, p_inc, p_dec);

reg [15: 0] phase;
always @(posedge p_inc or posedge p_dec or negedge RST_N) begin
    if (!RST_N)     phase <= 16'h0083;
    else if (p_inc) phase <= phase + 1;
    else if (p_dec) phase <= phase - 1;
end
reg [15: 0] frequency;
always @(posedge f_inc or posedge f_dec or negedge RST_N) begin
    if (!RST_N)     frequency <= 16'h0083;
    else if (f_inc) frequency <= frequency + 1;
    else if (f_dec) frequency <= frequency - 1;
end



DAC7512 dac_driver();
    

endmodule
