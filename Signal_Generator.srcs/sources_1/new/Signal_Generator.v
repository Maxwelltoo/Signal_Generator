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

wire wave_l,wave_r,f_increa,f_reduce,p_increa,p_reduce;
Key key_wave_l(CLK_50M, RST_N, KEY_1, wave_l);
Key key_wave_r(CLK_50M, RST_N, KEY_2, wave_r);
Encoder enc_freq(CLK_50M, RST_N, ENC_1_A, ENC_1_B, f_increa, f_reduce);
Encoder enc_phas(CLK_50M, RST_N, ENC_2_A, ENC_2_B, p_increa, p_reduce);

reg [15: 0] frequency;
reg [15: 0] phase;
always @(posedge CLK_50M or negedge RST_N) begin
    if (!RST_N) begin
        frequency = 16'h0083;
        phase     = 16'h0000; 
    end
    else

    ;
end



DAC7512 dac_driver();
    

endmodule
