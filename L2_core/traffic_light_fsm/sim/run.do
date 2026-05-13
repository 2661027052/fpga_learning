# Traffic Light FSM 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/traffic_light_fsm.v traffic_light_fsm_tb.v
vsim -gui traffic_light_fsm_tb
add wave -divider "时钟与复位"
add wave /traffic_light_fsm_tb/clk
add wave /traffic_light_fsm_tb/rst_n
add wave -divider "状态机"
add wave -radix binary /traffic_light_fsm_tb/u_dut/current_state
add wave -radix binary /traffic_light_fsm_tb/u_dut/next_state
add wave -divider "南北方向"
add wave /traffic_light_fsm_tb/ns_green
add wave /traffic_light_fsm_tb/ns_yellow
add wave /traffic_light_fsm_tb/ns_red
add wave -divider "东西方向"
add wave /traffic_light_fsm_tb/ew_green
add wave /traffic_light_fsm_tb/ew_yellow
add wave /traffic_light_fsm_tb/ew_red
add wave -divider "倒计时"
add wave -radix unsigned /traffic_light_fsm_tb/cnt_out
run -all
