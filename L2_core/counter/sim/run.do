# Counter 仿真脚本 — 在 ModelSim 中执行: do run.do
vlib work
vmap work work
vlog ../rtl/counter.v ../rtl/clk_div.v tb_counter.v
vsim -gui tb_counter
add wave -divider "控制信号"
add wave -radix binary    /tb_counter/clk
add wave -radix binary    /tb_counter/rst_n
add wave -radix binary    /tb_counter/en
add wave -radix binary    /tb_counter/up_down
add wave -radix binary    /tb_counter/load
add wave -divider "数据"
add wave -radix unsigned  /tb_counter/d
add wave -radix unsigned  /tb_counter/q
add wave -radix binary    /tb_counter/ovf
add wave -radix binary    /tb_counter/at_max
add wave -radix binary    /tb_counter/at_zero
run -all
