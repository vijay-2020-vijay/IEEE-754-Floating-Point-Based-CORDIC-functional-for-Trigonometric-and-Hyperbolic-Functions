`timescale 1ns / 1ps
  
module testbench;

    reg clk, reset;
    reg [31:0] zi;   // input angle in IEEE 754 format (degrees)

    // DUT outputs should be wires, not regs
    wire [31:0] sin_th_x;
    wire [31:0] cos_th_x;
    wire [31:0] cosec_th_x;
    wire [31:0] sec_th_x;
    wire [31:0] tan_th_x;
    wire [31:0] cot_th_x;
    reg control_th;
    reg start_control;
    wire done;

    parameter n = 10;

    // Instantiate DUT
    trigono_cordic #(.n(n)) uut (
        .clk(clk),
        .reset(reset),
        .control_th(control_th),
        .start_control(start_control),
        .zi(zi),
        .sin_th_x(sin_th_x),
        .cos_th_x(cos_th_x),
        .cosec_th_x(cosec_th_x),
        .sec_th_x(sec_th_x),
        .tan_th_x(tan_th_x),
        .cot_th_x(cot_th_x),
        .done(done)
    );

    // Clock generation (10ns period = 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("====== Starting CORDIC Testbench ======");
        reset = 1;
        #20 reset = 0;

        // -------------------------
        // Test Case 1: 45 degrees
        // -------------------------
        zi = 32'h42340000; // 45.0 in IEEE-754
        control_th=0;///////means hyperbolic function determinate/////////
        start_control=1;
        #40
        start_control=0;
        #1000
        zi = 32'h42340000; // 45.0 in IEEE-754
        control_th=1;//////means Trigonometric function determinate/////////
        start_control=1;
        
    
    

    end
endmodule

