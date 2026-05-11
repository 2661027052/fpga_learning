// ALU testbench — 覆盖全部9种运算 + 边界条件
`timescale 1ns / 1ps

module tb_alu;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] a;
    reg  [WIDTH-1:0] b;
    reg  [3:0]       op;
    wire [WIDTH-1:0] result;
    wire             zero;
    wire             carry;

    integer pass_count;
    integer fail_count;

    alu #(.WIDTH(WIDTH)) uut (
        .a      (a),
        .b      (b),
        .op     (op),
        .result (result),
        .zero   (zero),
        .carry  (carry)
    );

    // 自动判断测试是否通过
    task check;
        input [255:0] test_name;
        input [WIDTH-1:0] expected_result;
        input             expected_zero;
        input             expected_carry;
        begin
            #1;  // 等待组合逻辑稳定
            if (result === expected_result && zero === expected_zero && carry === expected_carry) begin
                $display("[PASS] %s: result=%d, zero=%b, carry=%b", test_name, result, zero, carry);
                pass_count = pass_count + 1;
            end
            else begin
                $display("[FAIL] %s: got (result=%d, zero=%b, carry=%b), expected (result=%d, zero=%b, carry=%b)",
                         test_name, result, zero, carry, expected_result, expected_zero, expected_carry);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        // ============================================
        // 1. ADD 加法测试
        // ============================================
        op = 4'b0000;

        a = 8'd20;  b = 8'd30;  check("ADD 20+30",      8'd50,  1'b0, 1'b0);
        a = 8'd200; b = 8'd100; check("ADD 200+100(carry)", 8'd44, 1'b0, 1'b1);
        a = 8'd0;   b = 8'd0;   check("ADD 0+0(zero)",  8'd0,   1'b1, 1'b0);
        a = 8'd255; b = 8'd1;   check("ADD 255+1",      8'd0,   1'b1, 1'b1);

        // ============================================
        // 2. SUB 减法测试
        // ============================================
        op = 4'b0001;

        a = 8'd50;  b = 8'd30;  check("SUB 50-30",      8'd20,  1'b0, 1'b0);
        a = 8'd30;  b = 8'd50;  check("SUB 30-50(borrow)", 8'd236, 1'b0, 1'b1);
        a = 8'd10;  b = 8'd10;  check("SUB 10-10(zero)", 8'd0,   1'b1, 1'b0);

        // ============================================
        // 3. MUL 乘法测试
        // ============================================
        op = 4'b0010;

        a = 8'd10;  b = 8'd5;   check("MUL 10*5",       8'd50,  1'b0, 1'b0);
        a = 8'd16;  b = 8'd16;  check("MUL 16*16(overflow)", 8'd0, 1'b1, 1'b0);
        a = 8'd0;   b = 8'd100; check("MUL 0*100(zero)", 8'd0,   1'b1, 1'b0);
        a = 8'd3;   b = 8'd7;   check("MUL 3*7",        8'd21,  1'b0, 1'b0);

        // ============================================
        // 4. AND 按位与测试
        // ============================================
        op = 4'b0011;

        a = 8'b1111_0000; b = 8'b1010_1010; check("AND 0xF0 & 0xAA",  8'b1010_0000, 1'b0, 1'b0);
        a = 8'b1111_1111; b = 8'b0000_0000; check("AND 0xFF & 0x00(0)", 8'd0, 1'b1, 1'b0);

        // ============================================
        // 5. OR 按位或测试
        // ============================================
        op = 4'b0100;

        a = 8'b1111_0000; b = 8'b0000_1111; check("OR 0xF0 | 0x0F",  8'b1111_1111, 1'b0, 1'b0);
        a = 8'b0000_0000; b = 8'b0000_0000; check("OR 0x00 | 0x00(zero)", 8'd0, 1'b1, 1'b0);

        // ============================================
        // 6. XOR 按位异或测试
        // ============================================
        op = 4'b0101;

        a = 8'b1111_0000; b = 8'b1010_1010; check("XOR 0xF0 ^ 0xAA", 8'b0101_1010, 1'b0, 1'b0);
        a = 8'b1010_1010; b = 8'b1010_1010; check("XOR same->0",      8'd0, 1'b1, 1'b0);

        // ============================================
        // 7. SLT 有符号小于比较
        // ============================================
        op = 4'b0110;

        a = 8'd10;   b = 8'd20;   check("SLT 10<20",     8'd1,  1'b0, 1'b0);
        a = 8'd30;   b = 8'd10;   check("SLT 30<10",     8'd0,  1'b1, 1'b0);
        a = 8'd5;    b = 8'd5;    check("SLT 5<5(false)", 8'd0,  1'b1, 1'b0);
        a = 8'hFF;   b = 8'd1;    check("SLT -1<1(true)", 8'd1,  1'b0, 1'b0);

        // ============================================
        // 8. SRL 逻辑右移
        // ============================================
        op = 4'b0111;

        a = 8'b1000_0000; b = 8'd1; check("SRL 0x80>>1", 8'b0100_0000, 1'b0, 1'b0);
        a = 8'b1000_0000; b = 8'd7; check("SRL 0x80>>7", 8'b0000_0001, 1'b0, 1'b0);
        a = 8'b0000_0001; b = 8'd1; check("SRL 0x01>>1(0)", 8'd0, 1'b1, 1'b0);

        // ============================================
        // 9. SLL 逻辑左移
        // ============================================
        op = 4'b1000;

        a = 8'b0000_0001; b = 8'd1; check("SLL 0x01<<1", 8'b0000_0010, 1'b0, 1'b0);
        a = 8'b0000_0001; b = 8'd7; check("SLL 0x01<<7", 8'b1000_0000, 1'b0, 1'b0);
        a = 8'b1000_0000; b = 8'd1; check("SLL 0x80<<1(0)", 8'd0, 1'b1, 1'b0);

        // ============================================
        // 测试总结
        // ============================================
        $display("======================================");
        $display("Test Summary: %d passed, %d failed (total %d)",
                  pass_count, fail_count, pass_count + fail_count);
        $display("======================================");
        $finish;
    end

endmodule
