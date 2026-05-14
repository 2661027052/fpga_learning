# FPGA Learning Portfolio

> ⚠️ **License Notice**: Source Available — **non-commercial learning/research only**.
> Any commercial use (including embedding in products, production deployment)
> requires separate written permission. No warranty. Use at your own risk.
> See [LICENSE](LICENSE).
>
> 中文用户请参阅 [README_CN.md](README_CN.md)

---

An FPGA learning trajectory from zero to employable — each module includes synthesizable RTL, simulation testbench, and documentation.

## Project Structure

```
fpga_learning/
├── L1_basics/        # L1 Fundamentals — gates, LED, debounce, GPIO
├── L2_core/          # L2 Core Skills — ALU, counters, shift registers, FSM, protocols
├── L3_advanced/      # L3 Advanced — timing constraints, CDC, bus protocols, high-speed I/O
└── L4_expert/        # L4 Expert — SoC, DDR3, FIR/FFT, UVM
```

## Learning Roadmap

| Level | Difficulty | Stage | Topics |
|-------|------------|-------|--------|
| **L1 Fundamentals** | ⭐~⭐⭐ | Beginner | FPGA basics, digital logic, Verilog syntax, dev environment |
| **L2 Core Skills** | ⭐⭐~⭐⭐⭐ | Intermediate | Combinational/sequential logic, FSM, UART/SPI/I2C, simulation & debug |
| **L3 Advanced** | ⭐⭐⭐~⭐⭐⭐⭐ | Proficient | Timing constraints, CDC, AXI/AHB buses, high-speed interfaces |
| **L4 Expert** | ⭐⭐⭐⭐~⭐⭐⭐⭐⭐ | Expert | ZYNQ SoC, DDR3, FIR/FFT, SystemVerilog verification |

## Each Module Contains

- `rtl/` — synthesizable Verilog source
- `sim/` — testbench + simulation scripts
- `README.md` — bilingual module documentation

## Toolchain

- **FPGA**: Xilinx ZYNQ-7000 (Qimingxing board)
- **IDE**: Vivado 2020.1
- **Simulation**: ModelSim
- **VCS**: Git + GitHub

## Progress

Current stage: **L2 Core Skills** in progress

| Level | Modules | Status |
|-------|---------|--------|
| L1 Fundamentals | 4/4 | ✅ Done |
| L2 Core Skills | 3/15 | 🔧 In Progress |
| L3 Advanced | 0/21 | ⬜ Pending |
| L4 Expert | 0/6 | ⬜ Pending |

---

*Started 2026-05-10 · Updated daily*

## Trademark Notice

Xilinx, ZYNQ, and Vivado are trademarks of Xilinx (now AMD). ModelSim is a trademark of Siemens EDA.
All trademarks are property of their respective owners. This repository is not
affiliated with or endorsed by any of the companies mentioned.
