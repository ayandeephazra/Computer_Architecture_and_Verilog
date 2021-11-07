/////////////////////////////////////////////////////////
// Forms a 3-bit state register that will be one hot. //
// Meaning it needs to aynchronously reset to 6'h01  //
//////////////////////////////////////////////////////
module state3_reg(
  input clk,				// clock
  input CLRN,				// asynchronous active low reset
  input [1:0] nxt_state,	// forms next state (i.e. goes to D input of FFs)
  output [1:0] state		// output (current state)
);
  
  ////////////////////////////////////////////////////
  // Declare any needed internal signals.  Due to  //
  // all bits except LSB needed to reset, and the //
  // LSB needing to preset you will need to form //
  // two 2-bit vectors to hook to CLRN and PRN  //
  ///////////////////////////////////////////////
  //<-- you need to do this -->
  
  logic [1:0] CLRN_2;
  logic [1:0] PRN_2;
  
  ///////////////////////////////////////////////////////////
  // The two 2-bit vectors for CLRN & PRN are formed with //
  // vector concatenation of a mix of CLRN and 1'b1      //
  ////////////////////////////////////////////////////////
  //<-- you need to do this -->

  assign CLRN_2 = {CLRN, 1'b1};  
  assign PRN_2 = {1'b1, CLRN};
  
  ////////////////////////////////////////////////////////
  // instantiate 3 d_ff as a vector to implement state //
  //////////////////////////////////////////////////////
  //<-- you need to do this --> 

  d_ff d_ff_1[1:0](.clk(clk), .D(nxt_state[1:0]), .CLRN(CLRN_2[1:0]), .PRN(PRN_2[1:0]),
                      .Q(state[1:0]));
  
endmodule