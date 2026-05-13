cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/traffic_light_fsm.v traffic_light_fsm_tb.v
vsim -c traffic_light_fsm_tb -do "run -all; quit"
