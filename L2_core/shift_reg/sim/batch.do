cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/shift_reg.v tb_shift_reg.v
vsim -c tb_shift_reg -do "run -all; quit"
