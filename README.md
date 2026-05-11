# FPGA 学习项目 (FPGA Learning Portfolio)

> 从零到就业的 FPGA 学习轨迹 —— 每个模块含可综合 RTL、仿真 testbench、英文文档

## 项目结构 (Project Structure)

```
fpga_learning/
├── L1_basics/        # L1 基础认知 — 门电路、LED、按键消抖、GPIO
├── L2_core/          # L2 核心技能 — ALU、计数器、移位寄存器、状态机、协议
├── L3_advanced/      # L3 进阶应用 — 时序约束、CDC、总线协议、高速接口
└── L4_expert/        # L4 专家领域 — SoC、DDR3、FIR/FFT、UVM
```

## 学习路线 (Learning Roadmap)

| 层级 | 难度 | 阶段 | 内容 |
|------|------|------|------|
| **L1 基础认知** | ⭐~⭐⭐ | 入门 | FPGA 是什么、数字电路基础、Verilog 语法、开发环境 |
| **L2 核心技能** | ⭐⭐~⭐⭐⭐ | 进阶 | 组合/时序逻辑、状态机、UART/SPI/I2C、仿真与调试 |
| **L3 进阶应用** | ⭐⭐⭐~⭐⭐⭐⭐ | 精通 | 时序约束、跨时钟域、AXI/AHB 总线、高速接口 |
| **L4 专家领域** | ⭐⭐⭐⭐~⭐⭐⭐⭐⭐ | 冲刺 | ZYNQ SoC、DDR3、FIR/FFT、SystemVerilog 验证 |

## 每个模块包含 (Each Module)

- `rtl/` — 可综合 Verilog 源码（中文注释）
- `sim/` — Testbench + 仿真脚本
- `README.md` — 中英文模块文档

## 工具链 (Toolchain)

- **FPGA**: Xilinx ZYNQ-7000 (启明星开发板)
- **IDE**: Vivado 2020.1
- **仿真**: ModelSim
- **版本管理**: Git + GitHub

## 进度追踪 (Progress)

当前进度：**L2 核心技能** 进行中

| 层级 | 模块数 | 状态 |
|------|--------|------|
| L1 基础认知 | 4/4 | ✅ 完成 |
| L2 核心技能 | 3/15 | 🔧 进行中 |
| L3 进阶应用 | 0/21 | ⬜ 待开始 |
| L4 专家领域 | 0/6 | ⬜ 待开始 |

---

*开始于 2026-05-10 · 每天更新*
