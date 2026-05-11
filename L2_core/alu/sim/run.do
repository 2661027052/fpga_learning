# ALU 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/alu.v tb_alu.v
vsim -gui tb_alu
add wave -divider "输入"
add wave -radix unsigned /tb_alu/a
add wave -radix unsigned /tb_alu/b
add wave -radix binary    /tb_alu/op
add wave -divider "输出"
add wave -radix unsigned /tb_alu/result
add wave -radix binary    /tb_alu/zero
add wave -radix binary    /tb_alu/carry
run -all
