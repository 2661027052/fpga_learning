# Counter & Clock Divider

Sequential logic building blocks. L2 core skill: sequential logic design.

## counter.v — Configurable Counter

**Features**: up/down counting, enable, parallel load, overflow flag, boundary detection.

| Condition | Next q | ovf |
|-----------|--------|-----|
| UP, q < MAX | q + 1 | 0 |
| UP, q == MAX | 0 | 1 |
| DOWN, q > 0 | q - 1 | 0 |
| DOWN, q == 0 | MAX | 1 |
| load=1 | d | 0 |
| en=0 | hold | 0 |

## clk_div.v — Even Clock Divider

50% duty cycle. f_out = f_in / (2 * DIV_FACTOR).

Example: 50MHz in, DIV_FACTOR=5 → 5MHz out.

## Simulation

```bash
vlog counter/rtl/counter.v counter/rtl/clk_div.v counter/sim/tb_counter.v
vsim -c tb_counter -do "run -all; quit"
vsim -c tb_clk_div -do "run -all; quit"
```

## Test Coverage

- UP: normal increment, overflow wrap, post-ovf resume
- DOWN: normal decrement, underflow wrap
- Load: parallel load mid-sequence
- Enable off: value hold
- at_max / at_zero: boundary flag assertion
- Clock divider: DIV_FACTOR=4 frequency check
