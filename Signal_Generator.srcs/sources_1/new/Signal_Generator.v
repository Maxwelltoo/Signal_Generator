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
// 参数说明：   频率控制字frqcy：16bit    相位控制字phase：16bit
//              波形控制字wave ：2 bit    幅值控制字ampl ：2 bit
// DDS模块设置：16bit相位累加器，762.9hz频率分辨率
// DAC7512说明：12bit输出，SPI串行控制
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

wire  wav_c, amp_c, f_inc, f_dec, p_inc, p_dec;
// 改变波形，改变幅值，频率+，频率-，相位+，相位-
Key key_wav(CLK_50M, RST_N, KEY_1, wav_c); // 按键1消抖后控制波形
Key key_amp(CLK_50M, RST_N, KEY_2, amp_c); // 按键2消抖后控制幅值
Encoder enc_freq(CLK_50M, RST_N, ENC_1_A, ENC_1_B, f_inc, f_dec); // 编码器1控制频率
Encoder enc_phas(CLK_50M, RST_N, ENC_2_A, ENC_2_B, p_inc, p_dec); // 编码器2控制相位

wire [ 1: 0] w_word, a_word; // 波形控制字，幅值控制字
wire [15: 0] p_word, f_word; // 相位控制字，频率控制字
Control ctrl_dds(CLK_50M, RST_N, wav_c, amp_c, f_inc, f_dec, p_inc, p_dec, w_word, a_word, p_word, f_word);

wire dac_pre = DAC_SYNC;
wire [11: 0] data;
wire valid;
Synthesis dac_in(CLK_50M, RST_N, w_word, a_word, p_word, f_word, dac_pre, data, valid);

DAC7512 dac_driver(CLK_50M, RST_N, data, valid, DAC_SYNC, DAC_SCLK, DAC_DIN);

endmodule
