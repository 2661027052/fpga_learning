# led_blink 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../rtl/led_blink.v tb_led_blink.v
vsim -gui tb_led_blink
add wave -divider "时钟与复位"
add wave -radix binary /tb_led_blink/clk
add wave -radix binary /tb_led_blink/rst_n
add wave -divider "LED输出"
add wave -radix binary /tb_led_blink/led
add wave -divider "内部计数器"
add wave -radix unsigned /tb_led_blink/u_led_blink/cnt
run -all
