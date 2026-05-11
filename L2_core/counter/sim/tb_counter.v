// SPDX-License-Identifier: LicenseRef-Custom-Source-Available  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// Counter testbench v3
`timescale 1ns / 1ps

module tb_counter;
    parameter WIDTH = 4;
    reg clk, rst_n, en, up_down, load;
    reg [WIDTH-1:0] d;
    wire [WIDTH-1:0] q;
    wire ovf, at_max, at_zero;
    integer pass, fail, i;

    counter #(.WIDTH(WIDTH)) uut (
        .clk(clk), .rst_n(rst_n), .en(en), .up_down(up_down),
        .load(load), .d(d), .q(q), .ovf(ovf), .at_max(at_max), .at_zero(at_zero)
    );

    always #5 clk = ~clk;

    initial begin
        pass = 0; fail = 0;
        clk = 0; rst_n = 0; en = 0; up_down = 1; load = 0; d = 0;

        repeat (10) @(posedge clk);
        rst_n <= 1; @(posedge clk);
        en <= 1;

        // == UP: 1->15 then overflow to 0 ==
        $display("--- UP 1->15 ---");
        for (i = 1; i < 16; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== i[WIDTH-1:0]) begin
                $display("[FAIL] UP: expected %d, got %d", i, q); fail = fail + 1;
            end else pass = pass + 1;
        end
        @(posedge clk); #1;
        if (q === 0 && ovf === 1) begin
            $display("[PASS] UP overflow: 15->0"); pass = pass + 1;
        end else begin
            $display("[FAIL] UP overflow: q=%d ovf=%b", q, ovf); fail = fail + 1;
        end

        // == Load ==
        $display("--- Load 10 ---");
        load <= 1; d <= 4'd10;
        @(posedge clk); #1; load <= 0;
        if (q === 4'd10) begin $display("[PASS] Load 10"); pass = pass + 1; end
        else begin $display("[FAIL] Load: got %d", q); fail = fail + 1; end

        // == DOWN ==
        $display("--- DOWN ---");
        up_down <= 0;
        @(posedge clk); #1;
        if (q === 4'd9) pass = pass + 1; else begin $display("[FAIL] DOWN 10->9: %d", q); fail = fail + 1; end

        // DOWN underflow
        load <= 1; d <= 4'd2;
        @(posedge clk); #1; load <= 0;
        repeat (3) @(posedge clk); #1;  // 1,0,underflow
        if (q === 15 && ovf === 1) begin $display("[PASS] DOWN underflow"); pass = pass + 1; end
        else begin $display("[FAIL] DOWN underflow: q=%d ovf=%b", q, ovf); fail = fail + 1; end

        // == Enable off ==
        en <= 0;
        @(posedge clk); #1; @(posedge clk); #1;
        if (q === 15) begin $display("[PASS] EN_OFF hold"); pass = pass + 1; end
        else begin $display("[FAIL] EN_OFF: q=%d", q); fail = fail + 1; end

        // == at_max / at_zero ==
        en <= 1; up_down <= 1;
        load <= 1; d <= 4'd14;
        @(posedge clk); #1; load <= 0;
        @(posedge clk); #1;
        if (at_max && q === 15) begin $display("[PASS] AT_MAX"); pass = pass + 1; end
        else begin $display("[FAIL] AT_MAX: q=%d at_max=%b", q, at_max); fail = fail + 1; end

        up_down <= 0;
        load <= 1; d <= 4'd1;
        @(posedge clk); #1; load <= 0;
        @(posedge clk); #1;
        if (at_zero && q === 0) begin $display("[PASS] AT_ZERO"); pass = pass + 1; end
        else begin $display("[FAIL] AT_ZERO: q=%d at_zero=%b", q, at_zero); fail = fail + 1; end

        $display("======================================");
        $display("Counter: %d passed, %d failed", pass, fail);
        $display("======================================");
        $finish;
    end
endmodule

module tb_clk_div;
    reg clk_in, rst_n;
    wire clk_out;
    clk_div #(.DIV_FACTOR(4)) uut (.clk_in(clk_in), .rst_n(rst_n), .clk_out(clk_out));
    always #10 clk_in = ~clk_in;
    initial begin
        clk_in = 0; rst_n = 0;
        #100 rst_n = 1;
        #2000;
        $display("CLK_DIV: DIV_FACTOR=4, 50MHz -> 6.25MHz");
        $finish;
    end
endmodule
