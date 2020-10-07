vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_6
vlib questa_lib/msim/processing_system7_vip_v1_0_8
vlib questa_lib/msim/xil_defaultlib

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_6 questa_lib/msim/axi_vip_v1_1_6
vmap processing_system7_vip_v1_0_8 questa_lib/msim/processing_system7_vip_v1_0_8
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xilinx_vip -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/include" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../ipstatic/hdl" "+incdir+../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0" "+incdir+D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_6 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../ipstatic/hdl" "+incdir+../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0" "+incdir+D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_8 -64 -sv -L axi_vip_v1_1_6 -L processing_system7_vip_v1_0_8 -L xilinx_vip "+incdir+../../../ipstatic/hdl" "+incdir+../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0" "+incdir+D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/include" \
"../../../ipstatic/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic/hdl" "+incdir+../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0" "+incdir+D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/include" \
"../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0/sim/processing_system7_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

