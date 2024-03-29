module d_en_ff(
  input clk,
  input D,			// D input to be flopped
  input CLRN,		// asynch active low clear (reset)
  input EN,			// enable signal
  output logic Q
);

  ////////////////////////////////////////////////////
  // Declare any needed internal sigals below here //
  //////////////////////////////////////////////////
  logic d_int;
  logic AND1,AND2,NOTEN;
  
  //////////////////////////////////////////////////
  // Form logic that feeds D input to make it an //
  // enable FF.  Instantiate verilog primitives //
  ///////////////////////////////////////////////
  
  //The K-map shows that the next state should be a sum of two product terms.
  //AND1/2 are the intermediate logic for the product terms
  not not1(NOTEN,EN);
  and and1(AND1,Q,NOTEN);
  and and2(AND2,D,EN);
  or or1(d_int,AND1,AND2);
  
  //////////////////////////////////////////////
  // Instantiate simple d_ff without enable  //
  // and tie PRN inactive.  Connect D input //    
  // to logic you inferred above.          //
  //////////////////////////////////////////
  
  //pluggin the inputs and set PRN as high to deactivate
  d_ff idff(.clk(clk), .D(d_int), .CLRN(CLRN), .PRN(1'b1), .Q(Q));

endmodule
