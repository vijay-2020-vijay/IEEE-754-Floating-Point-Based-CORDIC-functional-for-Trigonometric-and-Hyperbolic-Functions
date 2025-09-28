`timescale 1ns / 1ps

module tb_multi3;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] a;
    reg [31:0] b;
    reg  di;

    // Outputs
    wire [31:0] out3;

    // Instantiate the DUT
    multi3 uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .di(di),
        .out3(out3)
    );

    // Clock generation: 10ns period
    initial clk = 1;
    always #5 clk = ~clk;

    // Test vectors
    initial begin

        // Release reset
        #10 reset = 0;
                // First multiplication
        #10 a = 32'h3F99999A; // 1.2
             b = 32'h400CCCCD; // 2.2
             di = 1; // -1.0
        
        // Second multiplication
        #10 a = 32'h40466666; // 3.55
             b = 32'h40880000; // 4.25
             di = 0; // 10.0
             
        // Third multiplication
        #10 a = 32'h3F666666; // 0.9
             b = 32'h3F4CCCCD; // 0.8
             di = 1; // +1.0
        
        // Fourth multiplication
        #10 a = 32'h40A00000; // 5.0
             b = 32'h40C80000; // 6.25
             di = 1; // -4.0
     
        // Wait for a few clock cycles
        #50;

        // Finish simulation
        $finish;
    end

endmodule

