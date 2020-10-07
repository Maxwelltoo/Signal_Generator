-makelib ies_lib/xilinx_vip -sv \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "D:/FPGA/Xilinx/vivado/2019.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../ipstatic/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_vip_v1_1_6 -sv \
  "../../../ipstatic/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib ies_lib/processing_system7_vip_v1_0_8 -sv \
  "../../../ipstatic/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Signal_Generator.srcs/sources_1/ip/processing_system7_0/sim/processing_system7_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

