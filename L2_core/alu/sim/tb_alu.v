// SPDX-License-Identifier: MIT  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// ALU testbench — 覆盖全部9种运算 + 边界条件
`timescale 1ns / 1ps

module tb_alu;
    parameter WIDTH = 8;
    reg [WIDTH-1:0] a, b;
    reg [3:0] op;
    wire [WIDTH-1:0] result;
    wire zero, carry;
    integer pass, fail;

    alu #(.WIDTH(WIDTH)) uut (.a(a), .b(b), .op(op), .result(result), .zero(zero), .carry(carry));

    task check;
        input [255:0] test_name;
        input [WIDTH-1:0] expected_result;
        input expected_zero, expected_carry;
        begin
            #1;
            if (result === expected_result && zero === expected_zero && carry === expected_carry) begin
                $display("[PASS] %s: result=%d, zero=%b, carry=%b", test_name, result, zero, carry);
                pass = pass + 1;
            end else begin
                $display("[FAIL] %s: got (result=%d, zero=%b, carry=%b), expected (result=%d, zero=%b, carry=%b)",
                         test_name, result, zero, carry, expected_result, expected_zero, expected_carry);
                fail = fail + 1;
            end
        end
    endtask

    initial begin
        pass = 0; fail = 0;

        // ADD
        op = 4'b0000;
        a = 8'd20;  b = 8'd30;  check("ADD 20+30", 8'd50, 1'b0, 1'b0);
        a = 8'd200; b = 8'd100; check("ADD 200+100(carry)", 8'd44, 1'b0, 1'b1);
        a = 8'd0;   b = 8'd0;   check("ADD 0+0(zero)", 8'd0, 1'b1, 1'b0);
        a = 8'd255; b = 8'd1;   check("ADD 255+1", 8'd0, 1'b1, 1'b1);

        // SUB
        op = 4'b0001;
        a = 8'd50;  b = 8'd30;  check("SUB 50-30", 8'd20, 1'b0, 1'b0);
        a = 8'd30;  b = 8'd50;  check("SUB 30-50(borrow)", 8'd236, 1'b0, 1'b1);
        a = 8'd10;  b = 8'd10;  check("SUB 10-10(zero)", 8'd0, 1'b1, 1'b0);

        // MUL
        op = 4'b0010;
        a = 8'd10;  b = 8'd5;   check("MUL 10*5", 8'd50, 1'b0, 1'b0);
        a = 8'd16;  b = 8'd16;  check("MUL 16*16", 8'd0, 1'b1, 1'b1);
        a = 8'd0;   b = 8'd100; check("MUL 0*100", 8'd0, 1'b1, 1'b0);
        a = 8'd3;   b = 8'd7;   check("MUL 3*7", 8'd21, 1'b0, 1'b0);

        // AND
        op = 4'b0011;
        a = 8'b1111_0000; b = 8'b1010_1010; check("AND F0&AA", 8'b1010_0000, 1'b0, 1'b0);
        a = 8'b1111_1111; b = 8'b0000_0000; check("AND FF&00", 8'd0, 1'b1, 1'b0);

        // OR
        op = 4'b0100;
        a = 8'b1111_0000; b = 8'b0000_1111; check("OR F0|0F", 8'b1111_1111, 1'b0, 1'b0);
        a = 8'b0000_0000; b = 8'b0000_0000; check("OR 00|00", 8'd0, 1'b1, 1'b0);

        // XOR
        op = 4'b0101;
        a = 8'b1111_0000; b = 8'b1010_1010; check("XOR F0^AA", 8'b0101_1010, 1'b0, 1'b0);
        a = 8'b1010_1010; b = 8'b1010_1010; check("XOR same=0", 8'd0, 1'b1, 1'b0);

        // SLT
        op = 4'b0110;
        a = 8'd10;   b = 8'd20;   check("SLT 10<20", 8'd1, 1'b0, 1'b0);
        a = 8'd30;   b = 8'd10;   check("SLT 30<10", 8'd0, 1'b1, 1'b0);
        a = 8'd5;    b = 8'd5;    check("SLT 5<5", 8'd0, 1'b1, 1'b0);
        a = 8'hFF;   b = 8'd1;    check("SLT -1<1", 8'd1, 1'b0, 1'b0);

        // SRL
        op = 4'b0111;
        a = 8'b1000_0000; b = 8'd1; check("SRL 80>>1", 8'b0100_0000, 1'b0, 1'b0);
        a = 8'b1000_0000; b = 8'd7; check("SRL 80>>7", 8'b0000_0001, 1'b0, 1'b0);
        a = 8'b0000_0001; b = 8'd1; check("SRL 01>>1", 8'd0, 1'b1, 1'b0);

        // SLL
        op = 4'b1000;
        a = 8'b0000_0001; b = 8'd1; check("SLL 01<<1", 8'b0000_0010, 1'b0, 1'b0);
        a = 8'b0000_0001; b = 8'd7; check("SLL 01<<7", 8'b1000_0000, 1'b0, 1'b0);
        a = 8'b1000_0000; b = 8'd1; check("SLL 80<<1", 8'd0, 1'b1, 1'b0);

        $display("======================================");
        $display("ALU: %d passed, %d failed (total %d)", pass, fail, pass+fail);
        $display("======================================");
        $finish;
    end
endmodule
