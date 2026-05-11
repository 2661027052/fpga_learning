// =============================================================================
// gates_demo.v — 10种基本门电路的 Verilog 实现
// 知识点：数字电路基础 (L1)
// 目标：验证每种门电路的真值表，理解门级建模
// =============================================================================

module gates_demo (
    input  wire       a,      // 输入 A
    input  wire       b,      // 输入 B
    input  wire       en,     // 三态门使能
    input  wire       s,      // MUX 选择信号
    output wire       y_and,  // AND 门输出
    output wire       y_or,   // OR 门输出
    output wire       y_not,  // NOT 门输出（仅输入 a）
    output wire       y_nand, // NAND 门输出
    output wire       y_nor,  // NOR 门输出
    output wire       y_xor,  // XOR 门输出
    output wire       y_xnor, // XNOR 门输出
    output wire       y_buf,  // Buffer 输出
    output wire       y_tri,  // 三态门输出
    output wire       y_mux   // 2选1 MUX 输出
);

// === 门级建模：使用 Verilog 内置原语 ===

// 1. AND 门 — Y = A & B
and  u_and  (y_and,  a, b);

// 2. OR 门  — Y = A | B
or   u_or   (y_or,   a, b);

// 3. NOT 门 — Y = ~A
not  u_not  (y_not,  a);

// 4. NAND 门 — Y = ~(A & B)
nand u_nand (y_nand, a, b);

// 5. NOR 门 — Y = ~(A | B)
nor  u_nor  (y_nor,  a, b);

// 6. XOR 门 — Y = A ^ B
xor  u_xor  (y_xor,  a, b);

// 7. XNOR 门 — Y = ~(A ^ B)
xnor u_xnor (y_xnor, a, b);

// 8. Buffer — Y = A（用于增强驱动能力）
buf  u_buf  (y_buf,  a);

// 9. 三态门 — EN=1 时 Y=A，EN=0 时 Y=Z（高阻）
bufif1 u_tri (y_tri, a, en);

// 10. 2选1 MUX — 使用连续赋值展示数据流建模
assign y_mux = s ? b : a;   // S=0 选 A，S=1 选 B

endmodule
