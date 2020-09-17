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

wire  wav_c, amp_c, f_inc, f_dec, p_inc, p_dec;
// 改变波形，改变幅值，频率+，频率-，相位+，相位-

Key key_wav(CLK_50M, RST_N, KEY_1, wav_c); // 按键1消抖后控制波形
Key key_amp(CLK_50M, RST_N, KEY_2, amp_c); // 按键2消抖后控制幅值
Encoder enc_freq(CLK_50M, RST_N, ENC_1_A, ENC_1_B, f_inc, f_dec); // 编码器1控制频率
Encoder enc_phas(CLK_50M, RST_N, ENC_2_A, ENC_2_B, p_inc, p_dec); // 编码器2控制相位

// DDS_control 
reg [1 : 0] wave; // 方波 三角波 锯齿波 正弦波
always @(posedge wav_c or negedge RST_N) begin //改变波形
    if (!RST_N)     wave <= 16'h0083;
    else if (wav_c) wave <= wave + 1;
end
reg [1 : 0]  ampl; // 25% 50% 75% 100% 幅值
always @(posedge amp_c or negedge RST_N) begin //改变幅值
    if (!RST_N)     ampl <= 16'h0083;
    else if (amp_c) ampl <= ampl + 1;
end
reg [15: 0] phase; // 相位偏移值：控制初相位
always @(posedge p_inc or posedge p_dec or negedge RST_N) begin //改变相位
    if (!RST_N)     phase <= 16'h0083;
    else if (p_inc) phase <= phase + 1;
    else if (p_dec) phase <= phase - 1;
end
reg [15: 0] frqcy; // 相位累加量：控制频率
always @(posedge f_inc or posedge f_dec or negedge RST_N) begin //改变频率
    if (!RST_N)     frqcy <= 16'h0083; // 约100Khz
    else if (f_inc) frqcy <= frqcy + 1;
    else if (f_dec) frqcy <= frqcy - 1;
end

reg [15:0] cnt; //accumulator
always @(posedge CLK_50M) cnt <= cnt + frqcy;
dds_compiler_0 sin_wave (
  .aclk(aclk),                                // input wire aclk
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(s_axis_phase_tdata),    // input wire [31 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),    // output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata)      // output wire [31 : 0] m_axis_data_tdata
);

assign tria = cnt[15:4];
assign rect = cnt[15] ? 12'h000:12'hhh;
assign swat = cnt[15] ? cnt[14:3]:~cnt[14:3];
assign sin =;
always @(posedge CLK_50M ) begin
    casez (wave)
        2'b00: dds_data <= tria;
        2'b01: dds_data <= rect;
        2'b10: dds_data <= swat;
        2'b11: dds_data <= sin; 
        default: 
    endcase
end
reg [11:0] dds_data;  // DDS输出数据
reg        dds_valid; // DDS输出有效标志

DAC7512 dac_driver(CLK_50M, RST_N, dds_data, dds_valid, DAC_SYNC, DAC_SCLK, DAC_DIN);

endmodule
