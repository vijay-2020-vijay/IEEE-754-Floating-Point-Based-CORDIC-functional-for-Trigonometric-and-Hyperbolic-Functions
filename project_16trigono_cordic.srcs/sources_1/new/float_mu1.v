`timescale 1ns/1ps
module float_mu1(a, b, mult);
input [31:0] a, b;
output reg [31:0] mult;

wire [7:0] E1, E2, E;
wire [23:0] m1, m2;
wire [47:0] m;
wire sign;
assign m1 = {1'b1, a[22:0]}; // Add implicit 1
assign m2 = {1'b1, b[22:0]}; // Add implicit 1
assign sign = a[31] ^ b[31];
assign E1 = a[30:23];
assign E2 = b[30:23];
assign E = E1 + E2 - 127;
mult_men r1(.a(m1), .b(m2), .mul(m));
// Normalize the result
wire [22:0] norm_m;
wire [7:0] norm_E;
assign norm_m = (m[47] == 1) ? { m[46:24]} : { m[45:23]}; // Correct normalization
assign norm_E = (m[47] == 1) ? E+1 : E;
always@(*)begin
       
        if(a==0 || b==0)begin
           mult=0;
        end
        else begin
           mult = {sign, norm_E, norm_m};
        end  
        
end
endmodule

/////////////////////////////////////////////////////////////////
module mult_men(a, b, mul);
input [23:0] a, b; // Corrected input width
output [47:0] mul;
assign mul = a * b;
endmodule