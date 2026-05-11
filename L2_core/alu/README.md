# ALU (Arithmetic Logic Unit)

8-bit combinational ALU supporting 9 operations. L2 core skill: combinational logic design.

## Architecture

```
    a[7:0] ──┬────────────────────┐
             │                    │
    b[7:0] ──┼──┐                │
             │  │                ▼
    op[3:0] ─┼──┤    ┌─────────────────┐
             │  │    │                 │
             ▼  ▼    │   Combinational │──► result[7:0]
          ┌────────┐ │   Logic         │
          │ Operand│ │   (case/mux)    │──► zero
          │ Width  │ │                 │
          │ Extend │ │                 │──► carry
          └────────┘ └─────────────────┘
```

## Operations

| Opcode | Operation | Description |
|--------|-----------|-------------|
| 0000   | ADD       | a + b, carry flag on overflow |
| 0001   | SUB       | a - b, carry flag on borrow |
| 0010   | MUL       | a * b (lower 8 bits) |
| 0011   | AND       | Bitwise AND |
| 0100   | OR        | Bitwise OR |
| 0101   | XOR       | Bitwise XOR |
| 0110   | SLT       | Set Less Than (signed), result=1 if a<b |
| 0111   | SRL       | Logical shift right by b[2:0] bits |
| 1000   | SLL       | Logical shift left by b[2:0] bits |

## Flags

- **zero**: asserted when `result == 0`
- **carry**: carry-out (ADD) or borrow (SUB) from bit 7

## Simulation

```bash
vlog alu/rtl/alu.v alu/sim/tb_alu.v
vsim -c tb_alu -do "run -all; quit"
```

## Test Coverage

- ADD: normal, carry-out, zero result, overflow wrap
- SUB: normal, borrow, zero result
- MUL: normal, overflow (>8 bits), zero operand
- AND/OR/XOR: bit patterns, zero result
- SLT: true, false, equal, signed negative comparison
- SRL: single shift, max shift, shift-to-zero
- SLL: single shift, max shift, overflow-to-zero
