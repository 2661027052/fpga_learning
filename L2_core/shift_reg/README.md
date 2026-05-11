# Shift Register

8-bit universal shift register. L2 core skill: sequential logic design.

## Operations

| mode[1:0] | Operation | Behavior |
|-----------|-----------|----------|
| 00 | Hold | q unchanged |
| 01 | Shift Left | q <= {q[6:0], si_left}, so_left = q[7] |
| 10 | Shift Right | q <= {si_right, q[7:1]}, so_right = q[0] |
| 11 | Parallel Load | q <= d |

## Simulation

```bash
vlog shift_reg/rtl/shift_reg.v shift_reg/sim/tb_shift_reg.v
vsim -c tb_shift_reg -do "run -all; quit"
```

## Test Coverage

- Parallel load: 0xA6 pattern
- Shift left: 3 cycles, alternating serial input, so_left verification
- Shift right: 3 cycles, alternating serial input, so_right verification
- Hold: mode=00 preserves value across 3 cycles
- Reset: async clear to zero
