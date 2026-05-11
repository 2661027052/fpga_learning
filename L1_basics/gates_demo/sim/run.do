# gates_demo 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/gates_demo.v tb_gates_demo.v
vsim -gui tb_gates_demo

add wave -divider "输入"
add wave -radix binary /tb_gates_demo/a
add wave -radix binary /tb_gates_demo/b
add wave -radix binary /tb_gates_demo/en
add wave -radix binary /tb_gates_demo/s
add wave -divider "门电路输出"
add wave -radix binary /tb_gates_demo/y_and
add wave -radix binary /tb_gates_demo/y_or
add wave -radix binary /tb_gates_demo/y_not
add wave -radix binary /tb_gates_demo/y_nand
add wave -radix binary /tb_gates_demo/y_nor
add wave -radix binary /tb_gates_demo/y_xor
add wave -radix binary /tb_gates_demo/y_xnor
add wave -radix binary /tb_gates_demo/y_buf
add wave -radix binary /tb_gates_demo/y_tri
add wave -radix binary /tb_gates_demo/y_mux
run -all
