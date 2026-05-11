vlib work; vmap work work; vlog ../../key_debounce/rtl/key_debounce.v ../rtl/gpio_ctrl.v tb_gpio_ctrl.v
vsim -c tb_gpio_ctrl -do "run -all; quit"
