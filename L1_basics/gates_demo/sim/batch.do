cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/gates_demo.v tb_gates_demo.v
vsim -c tb_gates_demo -do "run -all; quit"
