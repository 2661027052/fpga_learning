# gpio_ctrl 仿真脚本 — 在 ModelSim 中执行: do run.do
cd [file dirname [info script]]
vlib work
vmap work work
vlog ../../key_debounce/rtl/key_debounce.v ../rtl/gpio_ctrl.v tb_gpio_ctrl.v
vsim -gui tb_gpio_ctrl
add wave -divider "时钟与复位"
add wave -radix binary /tb_gpio_ctrl/clk
add wave -radix binary /tb_gpio_ctrl/rst_n
add wave -divider "按键输入"
add wave -radix binary /tb_gpio_ctrl/key_in
add wave -divider "LED输出"
add wave -radix binary /tb_gpio_ctrl/led_out
run -all
