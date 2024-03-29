module shifter (In, Cnt, Op, Out);
   // TOP LEVEL SHIFTER MODULE
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;


// 10 IS ROR1!!!!!!!!!!!!
   wire [15:0] sll_out;
   wire [15:0] sra_out;
   wire [15:0] srl_out;
   wire [15:0] rl_out;
   wire [15:0] rr_out;
   sll iSLL(.In(In), .Cnt(Cnt), .Out(sll_out), .Op(Op));
   //sra iSRA(.In(In), .Cnt(Cnt), .Out(sra_out), .Op(Op));
   srl iSRL(.In(In), .Cnt(Cnt), .Out(srl_out), .Op(Op));
   rl iRL(.In(In), .Cnt(Cnt), .Out(rl_out), .Op(Op));
   rr iRR(.In(In), .Cnt(Cnt), .Out(rr_out), .Op(Op));

   assign Out = (Op===2'b00)?rl_out:{(Op===2'b11)? srl_out:{(Op===2'b10)? rr_out: {(Op===2'b01)? sll_out: 16'hzzzz}}};


endmodule


