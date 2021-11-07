/////////////////////////////////////////////////////////
// Forms a 6-bit state register that will be one hot. //
// Meaning it needs to aynchronously reset to 6'h01  //
//////////////////////////////////////////////////////
module state6_reg(
  input clk,				// clock
  input CLRN,				// asynchronous active low reset
  input [5:0] nxt_state,	// forms next state (i.e. goes to D input of FFs)
  output [5:0] state		// output (current state)
);
  
  ////////////////////////////////////////////////////
  // Declare any needed internal signals.  Due to  //
  // all bits except LSB needed to reset, and the //
  // LSB needing to preset you will need to form //
  // two 6-bit vectors to hook to CLRN and PRN  //
  ///////////////////////////////////////////////
  //<-- you need to do this -->
  
  logic [5:0] CLRN_6;
  logic [5:0] PRN_6;
  
  ///////////////////////////////////////////////////////////
  // The two 6-bit vectors for CLRN & PRN are formed with //
  // vector concatenation of a mix of CLRN and 1'b1      //
  ////////////////////////////////////////////////////////
  //<-- you need to do this -->

  assign CLRN_6 = {CLRN, CLRN, CLRN, CLRN, CLRN, 1'b1};  
  assign PRN_6 = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, CLRN};
  
  ////////////////////////////////////////////////////////
  // instantiate 6 d_ff as a vector to implement state //
  //////////////////////////////////////////////////////
  //<-- you need to do this -->

  d_ff d_ff_1[5:0](.clk(clk), .D(nxt_state[5:0]), .CLRN(CLRN_6[5:0]), .PRN(PRN_6[5:0]),
                      .Q(state[5:0]));
  
endmodule