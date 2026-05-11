# Shift Register 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/shift_reg.v tb_shift_reg.v
vsim -gui tb_shift_reg
add wave -divider "控制"
add wave -radix binary    /tb_shift_reg/clk
add wave -radix binary    /tb_shift_reg/rst_n
add wave -radix binary    /tb_shift_reg/en
add wave -radix binary    /tb_shift_reg/mode
add wave -divider "数据"
add wave -radix binary    /tb_shift_reg/d
add wave -radix binary    /tb_shift_reg/si_left
add wave -radix binary    /tb_shift_reg/si_right
add wave -divider "输出"
add wave -radix binary    /tb_shift_reg/q
add wave -radix binary    /tb_shift_reg/so_left
add wave -radix binary    /tb_shift_reg/so_right
run -all
