`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module div1 #(parameter N = 32, M = 23,P = N-M-1)(
  input[N-1:0] A,
  input[N-1:0] B,
  
  output reg [N-1:0] OUT);
   reg OverFlow;
   reg UnderFlow;
  
  
  wire[M:0] C1;
 
  reg[P+1:0] temp_exp;
  reg[P+1:0] bias = 127;
  
  reg[P+1:0] temp_Shift;
    
    Fixed_Point_Divider D1({1'b1,A[M-1:0]},{1'b1,B[M-1:0]},C1);
    
    always@(*) begin
    
        OUT[N-1] = A[N-1]^B[N-1];
        
        
        temp_Shift = -( {9'b0,(~C1[M])} + B[N-2:M] + bias +2 );
        
        temp_exp = A[N-2:M] + temp_Shift;
        
        if (temp_exp[P+1] == 0 && temp_exp[P] == 1)
          begin
             OverFlow = 1;
             UnderFlow =0;
             OUT[N-2:0] = 31'b1111111111111111111111111111111;
          end
        else if (temp_exp[P+1] == 1)
          begin
             OverFlow = 0;
             UnderFlow = 1;
             OUT[N-2:0] = 0;
          end
        else
             OverFlow = 0;
             UnderFlow = 0;
             OUT[N-2:M]= temp_exp;
             if (C1[M] == 0)
                 OUT[M-1:0] = {C1[M-2:0],1'b0};
             else
                 OUT[M-1:0] = C1[M-1:0];
        
    end
    
endmodule

//// INPUT INCLUDING 1 to MANTISSA//////

module Fixed_Point_Divider #(parameter M = 23)(
  input[M:0] A,
  input[M:0] B,
  
  output reg [M:0] Q 
  );
    
reg [M+1:0] temp_A;

integer i;
always@(*) begin
temp_A = {1'b0,A};

 if(B ==  A)
         begin
            Q = {1'b1,{23{1'b0}}};
         end

 for(i=24;i>=1;i=i-1)
  begin
     if({1'b0,B}  > temp_A)
         begin
            Q[i-1] = 0;
            temp_A = (temp_A << 1);
         end
     else
         begin
            Q[i-1] = 1;
            temp_A = (temp_A - B);
            temp_A = (temp_A << 1);
         end
    
  end
end
endmodule

