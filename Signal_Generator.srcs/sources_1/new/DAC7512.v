`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SCNU
// Engineer: WJX
// 
// Create Date: 2020/09/04 00:20:42
// Design Name: Signal_Generator
// Module Name: DAC7512
// Project Name: Signal_Generator
// Target Devices: xc7z020clg484-1
// Tool Versions: Vivado 2019.2
// Description: DAC7512模块驱动
// 数据就绪 => 使能脉冲 => 读入数据 => 进入预传输状态 => 保持3个clk周期
// => 产生预传输结束信号 => 进入传输状态 => 在sclk的上升沿移入下一位数据
// => 在sclk的下降沿数据被读入芯片 => 传输完16bit数据 => 产生传输结束信号
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DAC7512(clk, rst, val, dat, sync, sclk, sdat);
    input        clk;  // 系统时钟 50Mhz
    input        rst;  // 复位信号 低电平有效
    input        val;  // 数据有效/使能
    input [11:0] dat;  // 12bit数据
    output reg   sync; // 同步控制信号
    output reg   sclk; // DAC 时钟 25MHz
    output       sdat; // DAC 串行数据

localparam [1:0] IDLE=2'b00, PRE=2'b10, DATA=2'b01;
//DAC状态机      空闲状态   预传输状态   传输状态      

always @(posedge clk or negedge rst) begin
    if(!rst)               sclk <= 1'b0;
    else                   sclk <= ~sclk;
end

reg [1:0] STATE, NEXT; // 状态更新(sclk)
always @(posedge sclk or negedge rst) begin
    if(!rst)               STATE <= IDLE;
    else                   STATE <= NEXT;
end

reg [1:0] CNT_PRE; // 预传输保持时间计数器
always @(posedge clk or negedge rst) begin
    if(!rst)               CNT_PRE <= 2'b0;
    else if(STATE==PRE)    CNT_PRE <= CNT_PRE+1;
    else                   CNT_PRE <= 2'b0;
end
wire END_PRE = (CNT_PRE == 2'b11); // 保持20ns*3后END

reg [4:0] CNT_DATA; // 数据传输状态计数器
always @(posedge clk or negedge!rst) begin
    if(!rst)               CNT_DATA <= 5'b0;
    else if(STATE==DATA)   CNT_DATA <= CNT_DATA+1;
    else                   CNT_DATA <= 5'b0;
end
wire END_DATA = (CNT_DATA == 5'd31); // sclk下降沿时计数奇数

always @(val or STATE or END_PRE or END_DATA) begin
    NEXT = STATE;
    casez(STATE)
        IDLE: if(val)      NEXT = PRE ;
        PRE : if(END_PRE)  NEXT = DATA;
        DATA: if(END_DATA) NEXT = IDLE;
        default:           NEXT = IDLE;
    endcase
end

always @(val or STATE or END_PRE or END_DATA) begin
    casez(STATE)
    IDLE:    sync = 0;
    PRE:     sync = 1;
    DATA:    sync = 0;
    default: sync = 0;
    endcase
end

reg [15:0] DATA_CP;
always @(posedge clk or negedge rst) begin
    if(!rst)                      DATA_CP <= 16'b0;
    else if(val)                  DATA_CP <= {4'b0, dat}; // 普通模式传输
    else if(STATE==DATA & ~sclk)  DATA_CP <= {DATA_CP[14:0], DATA_CP[15]};
    else                          DATA_CP <= DATA_CP;
end
assign sdat = DATA_CP[15] & (STATE==DATA);

endmodule
