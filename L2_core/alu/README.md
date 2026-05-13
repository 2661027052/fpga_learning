# ALU 算术逻辑单元 | Arithmetic Logic Unit

> 8 位组合逻辑 ALU，支持 9 种运算。L2 核心技能：组合逻辑电路设计。
>
> 8-bit combinational ALU supporting 9 operations. L2 core skill: combinational logic design.

## 架构 | Architecture

```
    a[7:0] ──┬────────────────────┐
             │                    │
    b[7:0] ──┼──┐                │
             │  │                ▼
    op[3:0] ─┼──┤    ┌─────────────────┐
             │  │    │                 │
             ▼  ▼    │   组合逻辑      │──► result[7:0]
          ┌────────┐ │   case/mux      │
          │ 操作数  │ │   并行MUX       │──► zero（零标志 | Zero flag）
          │ 位宽扩展 │ │                 │
          │ Operand │ │                 │──► carry（进位标志 | Carry flag）
          │ Extend  │ │                 │
          └────────┘ └─────────────────┘
```

## 运算列表 | Operations

| 操作码 Opcode | 运算 Operation | 中文说明 | Description |
|:---:|:---:|:---|:---|
| 0000 | ADD | 加法，溢出时进位标志置1 | a + b, carry on overflow |
| 0001 | SUB | 减法，借位时进位标志置1 | a - b, carry on borrow |
| 0010 | MUL | 乘法（取低8位） | a * b (lower 8 bits) |
| 0011 | AND | 按位与 | Bitwise AND |
| 0100 | OR  | 按位或 | Bitwise OR  |
| 0101 | XOR | 按位异或 | Bitwise XOR |
| 0110 | SLT | 有符号小于比较，a<b时结果=1 | Set Less Than (signed), result=1 if a<b |
| 0111 | SRL | 逻辑右移，移位位数由 b[2:0] 控制 | Logical shift right, shift amount = b[2:0] |
| 1000 | SLL | 逻辑左移，移位位数由 b[2:0] 控制 | Logical shift left, shift amount = b[2:0] |

## 标志位 | Flags

- **zero（零标志）** M 结果为零时置1 / Asserted when result == 0
- **carry（进位/借位标志）** M ADD 进位输出 或 SUB 借位输出 / Carry output for ADD, borrow output for SUB

## 仿真 | Simulation

运行命令 / Run commands:

```bash
vlog alu/rtl/alu.v alu/sim/tb_alu.v
vsim -c tb_alu -do "run -all; quit"
```

## 测试覆盖 | Test Coverage

| 测试项 Test Item | 说明 Description |
|:---|:---|
| ADD | 正常加法、进位溢出、零结果、255+1回绕 / Normal add, carry overflow, zero result, 255+1 wrap |
| SUB | 正常减法、借位、零结果 / Normal subtract, borrow, zero result |
| MUL | 正常乘法、超8位溢出、零操作数 / Normal multiply, >8-bit overflow, zero operand |
| AND/OR/XOR | 位模式运算、零结果验证 / Bitwise operations, zero result check |
| SLT | 真/假/相等、有符号负数比较（-1<1）/ True/false/equal, signed negative comparison (-1<1) |
| SRL/SLL | 单次移位、最大移位、移位归零 / Single shift, max shift, shift to zero |
