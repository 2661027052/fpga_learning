# gates_demo — 10种基本门电路验证

## 功能
用 Verilog 门级原语实现 10 种基本门电路，并通过 testbench 自动遍历所有输入组合来验证真值表。

## 接口
| 端口 | 方向 | 位宽 | 说明 |
|------|------|------|------|
| a    | input | 1 | 输入 A |
| b    | input | 1 | 输入 B |
| en   | input | 1 | 三态门使能（1=导通, 0=高阻） |
| s    | input | 1 | MUX 选择（0=选A, 1=选B） |
| y_and ~ y_mux | output | 各1bit | 10 个门电路的输出 |

## 门电路清单
| # | 门 | 原语 | 逻辑 |
|---|-----|------|------|
| 1 | AND | `and` | Y = A & B |
| 2 | OR | `or` | Y = A | B |
| 3 | NOT | `not` | Y = ~A |
| 4 | NAND | `nand` | Y = ~(A & B) |
| 5 | NOR | `nor` | Y = ~(A | B) |
| 6 | XOR | `xor` | Y = A ^ B |
| 7 | XNOR | `xnor` | Y = ~(A ^ B) |
| 8 | Buffer | `buf` | Y = A |
| 9 | 三态门 | `bufif1` | Y = EN ? A : Z |
| 10 | MUX | `assign` | Y = S ? B : A |

## 仿真
```bash
# Modelsim 中运行
vlog ../rtl/gates_demo.v tb_gates_demo.v
vsim -c tb_gates_demo -do "run -all; quit"
```

testbench 自动遍历 4 种 A/B 组合，每种组合自检所有门电路输出。
