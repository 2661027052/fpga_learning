# Serial-Parallel 仿真脚本 - 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/serial_parallel.v serial_parallel_tb.v
vsim -gui serial_parallel_tb
add wave -divider "时钟与复位"
add wave /serial_parallel_tb/clk
add wave /serial_parallel_tb/rst_n
add wave -divider "SIPO 串转并"
add wave /serial_parallel_tb/si_data
add wave /serial_parallel_tb/si_valid
add wave -radix hex /serial_parallel_tb/po_data
add wave /serial_parallel_tb/po_valid
add wave -divider "PISO 并转串"
add wave -radix hex /serial_parallel_tb/pi_data
add wave /serial_parallel_tb/pi_load
add wave /serial_parallel_tb/so_data
add wave /serial_parallel_tb/so_valid
run -all
