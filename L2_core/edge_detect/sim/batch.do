cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/edge_detect.v edge_detect_tb.v
vsim -c edge_detect_tb -do "run -all; quit"
