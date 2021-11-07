module en_reg16(
  input clk,				// clock
  input EN,					// when high enable flop to capture
  input [15:0] D,			// register 8-bit data input
  output [15:0] Q			// register 8-bit Q output
);

  /////////////////////////////////////////////////////
  // instantiate 8 d_en_ff as a vector to implement //
  ///////////////////////////////////////////////////
  d_en_ff idff[15:0](.clk(clk), .D(D), .CLRN(1'b1), .EN(EN), .Q(Q));
  
endmodule