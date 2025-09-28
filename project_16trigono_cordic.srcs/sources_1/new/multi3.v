`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
///////////////in this module we will get result after 2 clk //verifited/////////
/////////////////////////////////////////////////////////////////////////////////
module multi3 (
       input clk,
       input reset,
       input[31:0]a,
       input[31:0]b,
       input di,
       output reg[31:0]out3
    );

reg[31:0]aa,bb;
wire[31:0]multi;
reg dii;
float_mu1  fm(.a(aa), .b(bb), .mult(multi));
always@(posedge clk)begin
       if(reset)begin
          out3<=0;
       end
       else begin
          aa<=a;
          bb<=b;
          dii<=di;
          out3 <= {dii, multi[30:0]};
       end
end  
endmodule
