`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////cordic _function _implementetion///////////////////////////////////////////////////////////////////////////
///////////////////maximum number of iteretion i have selected n=20////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//i = 0,1,2,3,4,4,5,5,6,7,8,8,9,9 //if i follow this sequence then can achive sinhx,buit not coshx/////////////////////////////


module trigono_cordic #(parameter  n=20,s0 = 3'd0, s1 = 3'd1, s2 = 3'd2, s3 = 3'd3, s4 = 3'd4, s5 = 3'd5, s6 = 3'd6, s7 = 3'd7
,s8 = 4'd8, s9 = 4'd9, s10 = 4'd10, s11 = 4'd11, s12 = 4'd12, s13 = 4'd13 ,s14 = 4'd14 )(
       input clk,reset,
       input[31:0]zi, /// put the value in degree///when wish to calculate trigonometric function //sinx//cox//tanx//cosecx//cotx
       /////////////////// even sexx also///////////////////////////////////////////////////////////////////////////////////////
       input control_th,  ///if control_th=1 will give trigonometric function ///0 hyperbolic function/////////////////////////
       input start_control,
       output reg done,
       output reg[31:0]sin_th_x,
       output reg[31:0]cosec_th_x,
       output reg[31:0]cos_th_x,
       output reg[31:0]sec_th_x,
       output reg[31:0]tan_th_x,
       output reg[31:0]cot_th_x
    );    
reg [4:0]state;
reg[31:0] two_po_ni[0:19];
reg[31:0] alpha_i_tr[0:19];
reg[31:0] alpha_i_tr_hi[0:19];
reg[31:0]yi;
reg di;
reg[31:0]xi;
reg[5:0]i,j; /// required for number of ireterion/////////
reg[31:0] alphai;
reg[31:0] alpha_inv;
reg[31:0]zii;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//instantiation of multiplication modulemodule  module//////////////////////////////////////////////////
reg [31:0]mula,mulb;
wire[31:0]mult_ab;
float_mu1 fr(.a(mula), .b(mulb),.mult(mult_ab));
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//instantiation of addsubs module  module////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
reg[31:0]a_operand,b_operand;
wire [31:0] result_as;
addsubs addsubb(
       .a_operand(a_operand),
       .b_operand(b_operand),
       .AddBar_Sub(1'b0),////used only for addition purose///
       .Exception(),
       .result(result_as)
);
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//instantiation of multi3  module///////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [31:0] aa,bb;
reg dii;
wire [31:0]out3;
 multi3  mult (
       .clk(clk),
       .reset(reset),
       .a(aa),
       .b(bb),
       .di(dii),
       .out3(out3)
    );
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////instantiation of /divider module//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////
reg [31:0]div11,div22;
wire[31:0]div_out;
div1 d1(
     .A(div11),
     .B(div22),
     .OUT(div_out)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////


always@(posedge clk)begin
        if(reset)begin
           /////////////////here we have put 2**(-i) values i=0 to i=19///set crossponding hexa value in decimal formet/////////////////
           ////////////////2**(0),2**(-1),2**(-2),........2**(-19)//////////////////////////////////////////////////////////////////////
           two_po_ni[0]  <= 32'h3F800000;  two_po_ni[1]  <= 32'h3F000000;  two_po_ni[2]  <= 32'h3E800000;  two_po_ni[3]  <= 32'h3E000000;
           two_po_ni[4]  <= 32'h3D800000;  two_po_ni[5]  <= 32'h3D000000;  two_po_ni[6]  <= 32'h3C800000;  two_po_ni[7]  <= 32'h3C000000;
           two_po_ni[8]  <= 32'h3B800000;  two_po_ni[9]  <= 32'h3B000000;  two_po_ni[10] <= 32'h3A800000;  two_po_ni[11] <= 32'h3A000000;
           two_po_ni[12] <= 32'h39800000;  two_po_ni[13] <= 32'h39000000;  two_po_ni[14] <= 32'h38800000;  two_po_ni[15] <= 32'h38000000;
           two_po_ni[16] <= 32'h37800000;  two_po_ni[17] <= 32'h37000000;  two_po_ni[18] <= 32'h36800000;  two_po_ni[19] <= 32'h36000000;
           yi<=32'b0;/////this is always zero //because we wish to calculate trigonometric and hyperbolic functions/////////////////////
           sin_th_x   <= 32'h00000000;cosec_th_x <= 32'h00000000;
           cos_th_x   <= 32'h00000000;sec_th_x   <= 32'h00000000;
           tan_th_x   <= 32'h00000000;cot_th_x   <= 32'h00000000;    
        end
 ///////////////////////////////////////////////////////////////////       
        else begin
             case(state)
             s0: begin
             if(start_control==1) begin
                  yi<=32'b0;
                  done<=0;
                 ///////here all the predefined alpha values are defined degree formet like 45,27.42,14.77,...............................,0.00011
                 /////////////(alpha)i=tan_inverse(2**(-i))//////////////////////////////////////////////////////////////////////////////////////
                alpha_i_tr[0]  <= 32'h42340000;  alpha_i_tr[1]  <= 32'h41D5C28F;  alpha_i_tr[2]  <= 32'h4161A626;  alpha_i_tr[3]  <= 32'h40E4877C;
                alpha_i_tr[4]  <= 32'h4065A3D7;  alpha_i_tr[5]  <= 32'h3FDE5BD9;  alpha_i_tr[6]  <= 32'h3F6B851F;  alpha_i_tr[7]  <= 32'h3EEB851F;
                alpha_i_tr[8]  <= 32'h3E6B851F;  alpha_i_tr[9]  <= 32'h3DEB851F;  alpha_i_tr[10] <= 32'h3D6B851F;  alpha_i_tr[11] <= 32'h3CEB851F;
                alpha_i_tr[12] <= 32'h3C6B851F;  alpha_i_tr[13] <= 32'h3BEB851F;  alpha_i_tr[14] <= 32'h3B6B851F;  alpha_i_tr[15] <= 32'h3AEB851F;
                alpha_i_tr[16] <= 32'h3A6B851F;  alpha_i_tr[17] <= 32'h39EB851F;  alpha_i_tr[18] <= 32'h396B851F;  alpha_i_tr[19] <= 32'h38EB851F;
                if(control_th)begin
                    xi<=32'h3F1B7803;//// xi=0.60565 initialised value /////for trigonogetric function case/////////////////
                    zii<=zi;
                    i<=0;
                    j<=0;
                end
                else begin
                   xi<=32'h3F800000;//// xi=1.0 initialised value /////for hyperbolic_trigonogetric function case//////////
                   mula<=32'h3C8EEE97;
                   mulb<=zi;
                   i<=1;
                   j<=0;
                end
             end
          end   
             s1:begin
                ///////here all the predefined alpha values are defined radian formet like (alpha)=tanh_inverse(2**(-i)) given here in radian foremet like
                ////////////// 0.930,0.432,0.231,............................................................................0.0000068,0.0000034,0.0000017
                  ///////// Hyperbolic CORDIC alpha values in **radians** (atanh(2^-i)) /////////
                 alpha_i_tr_hi[0]  <= 32'h3F6E147B;  // 0.930
                 alpha_i_tr_hi[1]  <= 32'h3f0c9f51;  // 0.549306
                 alpha_i_tr_hi[2]  <= 32'h3e82c55d;  // 0.255412
                 alpha_i_tr_hi[3]  <= 32'h3e00ac3b;  // 0.125657
                 
                 alpha_i_tr_hi[4]  <= 32'h3d802a78;  // 0.062581
                 alpha_i_tr_hi[5]  <= 32'h3d802a78;  // 0.031260
                 alpha_i_tr_hi[6]  <= 32'h3c800219;  // 0.015626
                 alpha_i_tr_hi[7]  <= 32'h3c000219;  // 0.007813

                 alpha_i_tr_hi[8]  <= 32'h3b80064b;  // 0.003907
                 alpha_i_tr_hi[9]  <= 32'h3afffbce;  // 0.001953
                 alpha_i_tr_hi[10] <= 32'h3a800eae;  // 0.000977
                 alpha_i_tr_hi[11] <= 32'h39ffda40;  // 0.000488

                 alpha_i_tr_hi[12] <= 32'h396E147B;  // 0.000244
                 alpha_i_tr_hi[13] <= 32'h38DA0FF6;  // 0.000122
                 alpha_i_tr_hi[14] <= 32'h386FBC72;  // 0.000061
                 alpha_i_tr_hi[15] <= 32'h37DAF3B6;  // 0.000030

                 alpha_i_tr_hi[16] <= 32'h376E147B;  // 0.000015
                 alpha_i_tr_hi[17] <= 32'h36DA0FF6;  // 0.0000076
                 alpha_i_tr_hi[18] <= 32'h366FBC72;  // 0.0000038
                 alpha_i_tr_hi[19] <= 32'h35DAF3B6;  // 0.0000019

                if(control_th)
                    zii<=zi;
                else 
                    zii<=mult_ab;  ////we are doing this because for hyperbolic function determe:
                    //we convert degree value in to radian formet that set////////////////////// 
             end
////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////             
             s2:begin
                if(control_th)
                  alphai<=alpha_i_tr[i];
                else 
                  alpha_inv<=alpha_i_tr_hi[i]; 
             /////////// produceing yi*di*2**(-i) for xi+1///
               aa<=yi;
               bb<=two_po_ni[i];
               if(zii[31]==1)begin 
                   dii<=1;//-1
                   di<=1;
                end
                else begin
                   dii<=0;//1
                   di<=0;
            ////////////////////////////////////////////////       
                end
               end
            s3:begin
            ////////////////////////////////////////////////
            a_operand<=zii;
            if(dii==1 && control_th==1)
               b_operand<={1'b0,alphai[30:0]};
            else if(dii==0 && control_th==1)
               b_operand<={1'b1,alphai[30:0]};   
            else if(dii==1 && control_th==0)
               b_operand<={1'b0,alpha_inv[30:0]};
            else
               b_operand<={1'b1,alpha_inv[30:0]};  
           //produceing xi*di*2**(-i) for y+1//////////////
             aa<=xi;
             bb<=two_po_ni[i];
             dii<=di; 
            ////////////////////////////////////////////////   
             end
 ///////////////////////////////////////////////////////////  
           s8:begin
              zii<=result_as;
           end
            s4:begin
            //inthis state yi*di*2**(-i) value is ready//
            //wish to produce xi+1 expression////////////////////////////
              a_operand<=xi;
              if(di==1 && control_th==1)
                 b_operand<={1'b0,out3[30:0]};
              else if(out3[30:0]==0)
                 b_operand<=0;
              else if(di==0 && control_th==1)    
                 b_operand<={1'b1,out3[30:0]};  
              else   
                 b_operand<=out3;    
            end
            s5:begin
            //xi+1=xi-yi*di*2**(-i)///////this expression is ready/////
              xi<=result_as;
              if(control_th)
                  i<=i+1;
               else
                  if(i==4 || i==5 || i==8 || i==9)begin////this arrangement has been done to generate this iteretion 1,2,3,4,4,5,5,6,7,8,8,9,9//
                     if(j==1) begin
                        i<=i+1;
                        j<=0;
                     end   
                     else begin
                        j<=j+1;
                     end   
                  end
                  else begin
                     i<=i+1;
                  end
   //////////////////////////////////////////////////////////////////////                  
              //wish to produce yi+1 expression/////////////////////////   
              a_operand<=yi;
              if(out3==0)
                  b_operand<=0;
              else 
                  b_operand<=out3;  
              end
           s6:begin
           //yi+1=yi+xi*di*2**(-i)///////this expression is ready/////
            yi<=result_as;
            mula<=xi;
            mulb<=32'h3f9a8f5c;///1.2075//////////////////////////////
           end 
////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// 
          s13:begin
              if(!control_th) begin
                cos_th_x<=mult_ab;
                mula<=32'h3f9a8f5c;///1.2075//////////////////////////////
                mulb<=yi;
                state<=s14;
                end 
              else  begin
                sin_th_x<=yi;
                cos_th_x<=xi;
                state<=s14;
              end 
          end
          s14:begin
              if(!control_th)begin
                 sin_th_x<=mult_ab;
                 state<=s7;
              end
              else begin
                sin_th_x<=yi;
                cos_th_x<=xi;
                state<=s7;
              end
          end
           s7:begin
              div11<=sin_th_x;
              div22<=cos_th_x;
              state<=s9;
           end
           s9:begin
             tan_th_x<=div_out;
             div11<=xi;
             div22<=yi;
             state<=s10;
           end
           s10:begin
             cot_th_x<=div_out;
             div11<=32'b00111111100000000000000000000000;
             div22<=yi;
             state<=s11;
           end
            s11:begin
             cosec_th_x<=div_out;
             div11<=32'b00111111100000000000000000000000;
             div22<=xi;
             state<=s12;
           end
           s12:begin
             sec_th_x<=div_out;
             done<=1;
             if(start_control==0)
                state<=s0;
             else
                state<=s12;   
           end
        endcase
        end
end
////////////////// state decision ///////////////////////////////////////////
always @(posedge clk) begin
    if (reset) begin
        state <= s0;
    end
    else begin
        case (state)
            s0: begin
            if(start_control)
                state <= s1;
            else
                state <= s0;   
            end
            s1: begin
                state <= s2;
            end
            s2: begin
                state <= s3;
            end
            s3: begin
                state <= s8;
            end 
            s8: begin
                state <= s4;
            end  
            s4: begin
                state <= s5;
            end
            s5: begin
                state <= s6;
            end
            s6: begin
                if (i < n) begin
                    state <= s2;
                end
                else begin
                    state <= s13;
                end
            end
        endcase
    end  
end
endmodule




