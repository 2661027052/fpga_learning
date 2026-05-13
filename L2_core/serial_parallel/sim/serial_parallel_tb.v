// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

`timescale 1ns / 1ps

module serial_parallel_tb;

    localparam WIDTH   = 8;
    localparam CLK_PER = 20;

    reg                 clk;
    reg                 rst_n;
    // SIPO
    reg                 si_data;
    reg                 si_valid;
    wire [WIDTH-1:0]    po_data;
    wire                po_valid;
    // PISO
    reg  [WIDTH-1:0]    pi_data;
    reg                 pi_load;
    wire                so_data;
    wire                so_valid;

    serial_parallel #(.WIDTH(WIDTH)) u_dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .si_data (si_data),
        .si_valid(si_valid),
        .po_data (po_data),
        .po_valid(po_valid),
        .pi_data (pi_data),
        .pi_load (pi_load),
        .so_data (so_data),
        .so_valid(so_valid)
    );

    //============ 时钟 ============
    initial clk = 1'b0;
    always #(CLK_PER/2) clk = ~clk;

    //============ SIPO发送一个byte的任务 ============
    task sipo_send_byte(input [WIDTH-1:0] data);
        integer i;
        begin
            for (i = WIDTH-1; i >= 0; i = i - 1) begin
                @(negedge clk);          // 在negedge驱动，DUT在posedge稳定采样
                si_data  = data[i];      // 阻塞赋值，立即生效
                si_valid = 1'b1;
            end
            @(negedge clk);
            si_valid = 1'b0;
            si_data  = 1'b0;
        end
    endtask

    //============ 测试 ============
    integer error_count;

    initial begin
        error_count = 0;
        si_data  = 1'b0;
        si_valid = 1'b0;
        pi_data  = 8'd0;
        pi_load  = 1'b0;
        rst_n    = 1'b0;
        repeat(3) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);

        //--- Test 1: SIPO — 串行输入 0xA5 (10100101) ---
        $display("[TB] Test 1: SIPO receive 0xA5");
        fork
            begin
                @(posedge clk);
                @(posedge po_valid);
                if (po_data !== 8'hA5) begin
                    $error("[FAIL] T1: SIPO expected 0xA5, got 0x%h", po_data);
                    error_count = error_count + 1;
                end else
                    $display("[PASS] T1: SIPO received 0xA5 OK");
            end
            begin
                @(posedge clk);
                sipo_send_byte(8'hA5);
            end
        join

        //--- Test 2: SIPO — 连续接收 0x3C ---
        $display("[TB] Test 2: SIPO receive 0x3C");
        fork
            begin
                @(posedge clk);
                @(posedge po_valid);
                if (po_data !== 8'h3C) begin
                    $error("[FAIL] T2: SIPO expected 0x3C, got 0x%h", po_data);
                    error_count = error_count + 1;
                end else
                    $display("[PASS] T2: SIPO received 0x3C OK");
            end
            begin
                @(posedge clk);
                sipo_send_byte(8'h3C);
            end
        join

        //--- Test 3: PISO — 加载 0x55 串行输出 ---
        $display("[TB] Test 3: PISO send 0x55");
        @(posedge clk);
        pi_data <= 8'h55;
        pi_load <= 1'b1;
        @(posedge clk);
        pi_load <= 1'b0;

        begin : t3_check
            reg [WIDTH-1:0] piso_rx;
            integer i;
            piso_rx = 8'd0;
            for (i = 0; i < WIDTH; i = i + 1) begin
                @(posedge clk);
                piso_rx = {piso_rx[WIDTH-2:0], so_data};
            end
            if (piso_rx !== 8'h55) begin
                $error("[FAIL] T3: PISO expected 0x55, got 0x%h", piso_rx);
                error_count = error_count + 1;
            end else
                $display("[PASS] T3: PISO sent 0x55 OK");
        end

        //--- Test 4: SIPO+PISO 回环测试 ---
        $display("[TB] Test 4: Loopback SIPO → PISO");
        fork
            begin : t4_producer
                reg [WIDTH-1:0] loop_data;
                @(posedge clk);
                @(posedge po_valid);
                loop_data = po_data;
                @(posedge clk);
                pi_data <= loop_data;
                pi_load <= 1'b1;
                @(posedge clk);
                pi_load <= 1'b0;
            end
            begin
                @(posedge clk);
                sipo_send_byte(8'hA5);
            end
        join

        begin : t4_check
            reg [WIDTH-1:0] loop_rx;
            integer i;
            loop_rx = 8'd0;
            @(posedge so_valid);
            for (i = 0; i < WIDTH; i = i + 1) begin
                @(posedge clk);
                loop_rx = {loop_rx[WIDTH-2:0], so_data};
            end
            if (loop_rx !== 8'hA5) begin
                $error("[FAIL] T4: Loopback expected 0xA5, got 0x%h", loop_rx);
                error_count = error_count + 1;
            end else
                $display("[PASS] T4: Loopback 0xA5 OK");
        end

        //============ 结果 ============
        $display("========================================");
        if (error_count == 0)
            $display("[RESULT] ALL TESTS PASSED");
        else
            $display("[RESULT] FAILED: %0d errors", error_count);
        $display("========================================");

        $finish;
    end

    initial begin
        #100000;
        $error("[TB] TIMEOUT");
        $finish;
    end

endmodule
