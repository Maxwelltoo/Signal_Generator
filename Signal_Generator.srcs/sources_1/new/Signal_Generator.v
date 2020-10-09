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
// Revision 1.00 - 顶层封装完成
// Revision 1.10 - 使用PS核提供时钟
// Revision 1.15 - 优化连接，增加注释
// Revision 1.20 - 加入运行指示灯核、数据输出指示灯
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Signal_Generator(
    //input  CLK_50M,
    input  RST_N,
    input  ENC_1_A,
    input  ENC_1_B,
    input  ENC_2_A,
    input  ENC_2_B,
    input  KEY_1,
    input  KEY_2,
    output DAC_SYNC,
    output DAC_SCLK,
    output DAC_DIN,
    output LED_RUN,
    output LED_DAT);

wire  CLK_50M;
processing_system7_0 system_clk(
    .FCLK_CLK0(CLK_50M)
);

wire  wav_c, amp_c, f_inc, f_dec, p_inc, p_dec;
// 改变波形，改变幅值，频率+，频率-，相位+，相位-
Key key_wav(CLK_50M, RST_N, KEY_1, wav_c); // 按键1消抖后控制波形
Key key_amp(CLK_50M, RST_N, KEY_2, amp_c); // 按键2消抖后控制幅值
Encoder enc_freq(CLK_50M, RST_N, ENC_1_A, ENC_1_B, f_inc, f_dec); // 编码器1控制频率
Encoder enc_phas(CLK_50M, RST_N, ENC_2_A, ENC_2_B, p_inc, p_dec); // 编码器2控制相位

wire [ 1: 0] w_word, a_word; // 波形控制字，幅值控制字
wire [15: 0] p_word, f_word; // 相位控制字，频率控制字
Control ctrl_dds(CLK_50M, RST_N, wav_c, amp_c, f_inc, f_dec, p_inc, p_dec, w_word, a_word, p_word, f_word);

wire dac_pre;      // DAC预传输标志位
wire [11: 0] data; // DAC 12bit数据
wire valid;
Synthesis dac_in(CLK_50M, RST_N, w_word, a_word, p_word, f_word, dac_pre, data, valid);

DAC7512 dac_driver(CLK_50M, RST_N, data, valid, dac_pre, DAC_SCLK, DAC_DIN); 
// DAC的预传输标志位作为数据更新的标志位
assign DAC_SYNC = dac_pre;

reg [24:0] run_cnt; // 运行指示灯：0.5秒周期闪烁
assign LED_RUN = (run_cnt < 25'd25_000_000) ? 1'b1 : 1'b0 ;
always@(posedge CLK_50M or negedge RST_N) begin
    if (!RST_N)                        run_cnt <= 0;
    else if(run_cnt >= 25'd49_999_999) run_cnt <= 0;
    else                               run_cnt <= run_cnt + 1;
end

reg [19:0] dat_cnt; // 数据指示灯：DAC每输出500_000个数据闪烁一次 （数据用时：1000ns）
assign LED_DAT = (dat_cnt < 20'd500_000) ? 1'b1 : 1'b0 ; // 运行指示灯：0.5秒周期闪烁
always@(posedge dac_pre or negedge RST_N) begin
    if (!RST_N)                     dat_cnt <= 0;
    else if(dat_cnt >= 20'd999_999) dat_cnt <= 0;
    else                            dat_cnt <= dat_cnt + 1;
end

endmodule
