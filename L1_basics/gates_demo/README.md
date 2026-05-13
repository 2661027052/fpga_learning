# 基本门电路演示 (Gates Demo)

## 模块概述 (Module Overview)

10种基本门电路 Verilog 门级原语实现，通过 testbench 自动遍历所有输入组合验证真值表。

Verilog gate-level primitive implementation of 10 basic logic gates. The testbench automatically exhausts all input combinations to verify truth tables.

## 接口说明 (Interface)

| 端口 Port | 方向 Dir | 位宽 Width | 说明 Description |
|-----------|----------|------------|------------------|
| a         | I        | 1          | 输入 A / Input A |
| b         | I        | 1          | 输入 B / Input B |
| en        | I        | 1          | 三态门使能（1=导通, 0=高阻）/ Tri-state enable |
| s         | I        | 1          | MUX 选择（0=选A, 1=选B）/ MUX select |
| y_and ~ y_mux | O   | 1 each     | 10 个门电路输出 / 10 gate outputs |

## 门电路清单 (Gate List)

| # | 门 Gate | 原语 Primitive | 逻辑 Logic |
|---|---------|----------------|------------|
| 1 | AND     | `and`          | Y = A & B |
| 2 | OR      | `or`           | Y = A | B |
| 3 | NOT     | `not`          | Y = ~A |
| 4 | NAND    | `nand`         | Y = ~(A & B) |
| 5 | NOR     | `nor`          | Y = ~(A | B) |
| 6 | XOR     | `xor`          | Y = A ^ B |
| 7 | XNOR    | `xnor`         | Y = ~(A ^ B) |
| 8 | Buffer  | `buf`          | Y = A |
| 9 | 三态门 Tri-state | `bufif1` | Y = EN ? A : Z |
| 10| MUX     | `assign`       | Y = S ? B : A |

## 仿真说明 (Simulation)

```bash
# ModelSim
cd sim
vlog ../rtl/gates_demo.v tb_gates_demo.v
vsim -c tb_gates_demo -do "run -all; quit"
```

Testbench 自动遍历 4 种 A/B 组合，每种组合自检所有门电路输出。

The testbench exhausts all 4 A/B combinations and self-checks all gate outputs for each combination.
