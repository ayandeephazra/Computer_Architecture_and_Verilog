// Answer to (a)
// This code is not correct. The value of q is updated with d only when clk is changing from 0 to 1 (the positive edge).
// We can fix this by adding d to the sensitivity list. Now, q will take the value of d whenever clk is high. 

// Answer to (b)
//D-FF with an active low synchronous reset
module D_FF_Synch(clk, rst_n, q, d);
input rst_n, clk, d;
output reg q;

always_ff @(posedge clk)
  if(!rst_n)
  q<= '0;       // put 0 in q if rst is activated
else 
  q<= d;        // else put d

endmodule

// Answer to part (c)
// D-FF with asynchronous active low reset and an active high enable.
module D_FF_Asynch(clk, rst_n, q, d, en);
input d, en, rst_n, clk;
output reg q;

always_ff @(posedge clk, negedge rst_n)
  if (!rst_n) 
    q <= 1'b0;	   // asynch reset
  else if (en)
    q <= d;	  // enabling condition
  else
    q <= q;	  // keep older value

endmodule

// Answer to (d)
// SR FF with active low asynchronous reset.
module SR_FF_Asynch(clk, rst_n, q, d, s, r);
input rst_n, d, s, r, clk;
output reg q;
always_ff @(posedge clk, negedge rst_n)
  if (!rst_n)  // asynch reset
    q <= 1'b0;	  
   else if (r)  // If reset is 1, output is reset.
      q <= 1'b0;	 
   else if(s) // if set is 1, output is set.
      q <= 1'b1;
   else 
      q <= q;

endmodule

// Answer to (e)
// No. As a programmer, you will get a warning when trying to infer anything other than an FF, in an
// always_ff block. But the program still compiles and runs if you force it by ignoring the warnings. There
// are ways to force the synthesizer to infer a latch, from an always ff block.
 