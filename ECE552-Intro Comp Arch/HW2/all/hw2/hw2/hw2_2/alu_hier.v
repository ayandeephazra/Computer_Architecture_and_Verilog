module alu_hier(A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);

   input [15:0] A;
   input [15:0] B;
   input Cin;
   input [2:0] Op;
   input invA;
   input invB;
   input sign;
   output [15:0] Out;
   output Ofl;
   output Z;

   wire clk;
   wire rst;
   wire err;

   assign err = 1'b0;
 
   clkrst c0(
             // Outputs
             .clk                       (clk),
             .rst                       (rst),
             // Inputs
             .err                       (err)
            );

    alu a0(
          // Outputs
          .Out                          (Out[15:0]),
          .Ofl                          (Ofl),
          .Z                            (Z),
          // Inputs
          .A                            (A[15:0]),
          .B                            (B[15:0]),
          .Cin                          (Cin),
          .Op                           (Op[2:0]),
          .invA                         (invA),
          .invB                         (invB),
          .sign                         (sign)
         ); 
endmodule // alu_hier
