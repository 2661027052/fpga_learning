# CLAUDE.md — fpga_projects 项目规则

本文件仅在本仓库内生效，不影响其他项目。

## 新增 Verilog 文件模板

创建任何 `.v` 文件时，首行必须使用以下 SPDX 头：

```verilog
// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
```

## README 规范

- 每个模块的 README.md 使用中英双语
- 包含：模块概述、接口说明、仿真结果截图引用

## 仿真实操规范

### 仿真命令（bash 调用 ModelSim）

**必须使用 Tcl 大括号 `{}` 传递 `-do` 参数**，禁止在 bash 中使用双引号 `""` 嵌套（会被 bash 吃掉，导致 `Fatal: Exiting VSIM license process`）。

编译+仿真一条命令：

```bash
cd <模块>/sim && rm -rf work modelsim.ini && \
F:/modelsim/win64/vsim.exe -c -do \
  'vlib work; vmap work work; vlog ../rtl/<dut>.v <tb>.v; vsim -c <tb_name> -do {run -all; quit}; quit'
```

原理：外层 `'...'` 保护 bash 不转义，内层 `{...}` 是 Tcl 大括号，内容原样传给 `vsim -do`。

生成 transcript：

```bash
cd <模块>/sim && \
F:/modelsim/win64/vsim.exe -c <tb_name> -do "run -all; quit" 2>&1 | \
  sed -n '/# run -all/,$p' | sed '/# End time:/d' | \
  sed '$a\  \nSimulated with ModelSim' > ../screenshots/transcript.txt
```

可并行跑多个模块（各自独立 `sim/` 目录）。

### 仿真脚本（`.do` 文件）

- 必须以 `cd [file dirname [info script]]` 开头
- 用于 ModelSim GUI 交互（`do run.do`），不用作命令行仿真入口

### 仿真截图

- 存放于 `screenshots/`，格式 PNG
- 不得暴露本地绝对路径、用户名等个人信息

### Transcript 处理规则

- 删除开头的 ModelSim 版权横幅和启动日期
- 删除 `# End time:` 行（含仿真运行时间戳）
- 保留 `# run -all` 开始的仿真输出，以及 `$display`/`$error` 等用户打印内容
- **文件末尾必须空一行后追加** `Simulated with ModelSim`

### 隐私要求

仓库所有文件不得包含：
- 本地绝对路径
- 用户名、QQ 号、邮箱、手机号等个人身份信息
- 项目创建时间戳或仿真运行日期

## Git 规则

- 提交前检查：不得包含 `work/`、`work1/`、`*.cr.mti`、`*.mpf`、`*.wlf` 等 ModelSim 编译产物
- 不得包含任何 `.vcd`、`.qdb` 文件
- 如发现误提交，立即 `git rm --cached` + 更新 `.gitignore` + 新建 cleanup commit
- 不得使用 `git add -A`，始终用 `git add <specific-files>`

## 禁止事项

- 不得修改本仓库的 `LICENSE` 文件（除非用户明确要求）
- 不得修改 `git config user.email` 和 `user.name`
- 不得在代码/文档中使用 QQ 邮箱、手机号、本地路径等个人信息
- 不得分发或引用第三方 IP 核的源代码/网表
