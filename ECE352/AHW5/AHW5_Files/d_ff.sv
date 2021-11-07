module d_ff(
  input clk,
  input D,			// the D input to be flopped 
  input CLRN,		// asynch active low clear (reset)
  input PRN,		// asynch active low preset
  output reg Q		// output of flop
);

always_ff @(posedge clk, negedge CLRN, negedge PRN)
  if (!CLRN)
    Q <= 1'b0;
  else if (!PRN)
    Q <= 1'b1;
  else
    Q <= D;
	
endmodule

