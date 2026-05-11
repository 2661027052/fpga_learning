# key_debounce 仿真脚本 — 在 ModelSim 中执行: do run.do
vlib work
vmap work work
vlog ../rtl/key_debounce.v tb_key_debounce.v
vsim -gui tb_key_debounce
add wave -divider "时钟与复位"
add wave -radix binary /tb_key_debounce/clk
add wave -radix binary /tb_key_debounce/rst_n
add wave -divider "按键与输出"
add wave -radix binary /tb_key_debounce/key_in
add wave -radix binary /tb_key_debounce/key_pressed
add wave -divider "内部消抖信号"
add wave -radix binary /tb_key_debounce/u_key_debounce/key_sync0
add wave -radix binary /tb_key_debounce/u_key_debounce/key_sync1
add wave -radix binary /tb_key_debounce/u_key_debounce/key_stable
add wave -radix unsigned /tb_key_debounce/u_key_debounce/debounce_cnt
run -all
