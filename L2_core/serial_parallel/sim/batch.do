cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/serial_parallel.v serial_parallel_tb.v
vsim -c serial_parallel_tb -do "run -all; quit"
