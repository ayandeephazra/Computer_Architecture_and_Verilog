module shifter_hier(In, Cnt, Op, Out);

   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

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

   shifter s0(
              // Outputs
              .Out                      (Out),
              // Inputs
              .In                       (In),
              .Cnt                      (Cnt),
              .Op                       (Op)
             );
   
endmodule // shifter_hier
