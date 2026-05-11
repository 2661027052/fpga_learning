# ALU 算术逻辑单元 (Arithmetic Logic Unit)

> 8 位组合逻辑 ALU，支持 9 种运算。L2 核心技能：组合逻辑电路设计。
>
> 8-bit combinational ALU supporting 9 operations. L2 core skill: combinational logic design.

## 架构 (Architecture)

```
    a[7:0] ──┬────────────────────┐
             │                    │
    b[7:0] ──┼──┐                │
             │  │                ▼
    op[3:0] ─┼──┤    ┌─────────────────┐
             │  │    │                 │
             ▼  ▼    │   组合逻辑      │──► result[7:0]
          ┌────────┐ │   case/mux      │
          │ 操作数  │ │   并行MUX       │──► zero（零标志）
          │ 位宽   │ │                 │
          │ 扩展   │ │                 │──► carry（进位标志）
          └────────┘ └─────────────────┘
```

## 运算列表 (Operations)

| 操作码 | 运算 | 中文说明 | Description |
|--------|------|---------|-------------|
| 0000   | ADD  | 加法，溢出时进位标志置1 | a + b, carry on overflow |
| 0001   | SUB  | 减法，借位时进位标志置1 | a - b, carry on borrow |
| 0010   | MUL  | 乘法（取低8位） | a * b (lower 8 bits) |
| 0011   | AND  | 按位与 | Bitwise AND |
| 0100   | OR   | 按位或 | Bitwise OR |
| 0101   | XOR  | 按位异或 | Bitwise XOR |
| 0110   | SLT  | 有符号小于比较，a<b时结果=1 | Set Less Than (signed) |
| 0111   | SRL  | 逻辑右移（移位位数由 b[2:0] 控制） | Logical shift right |
| 1000   | SLL  | 逻辑左移（移位位数由 b[2:0] 控制） | Logical shift left |

## 标志位 (Flags)

- **zero**：结果为零时置1（result == 0）
- **carry**：ADD 进位输出 或 SUB 借位输出

## 仿真 (Simulation)

```bash
vlog alu/rtl/alu.v alu/sim/tb_alu.v
vsim -c tb_alu -do "run -all; quit"
```

## 测试覆盖 (Test Coverage)

- ADD：正常加法、进位溢出、零结果、255+1回绕
- SUB：正常减法、借位、零结果
- MUL：正常乘法、超8位溢出、零操作数
- AND/OR/XOR：位模式运算、零结果验证
- SLT：真/假/相等、有符号负数比较（-1<1）
- SRL/SLL：单次移位、最大移位、移位归零
