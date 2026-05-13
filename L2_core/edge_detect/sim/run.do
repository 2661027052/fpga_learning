# Edge Detect 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/edge_detect.v edge_detect_tb.v
vsim -gui edge_detect_tb
add wave -divider "时钟与复位"
add wave /edge_detect_tb/clk
add wave /edge_detect_tb/rst_n
add wave -divider "输入信号"
add wave /edge_detect_tb/sig_in
add wave -divider "边沿检测"
add wave /edge_detect_tb/pos_edge
add wave /edge_detect_tb/neg_edge
add wave /edge_detect_tb/any_edge
run -all
