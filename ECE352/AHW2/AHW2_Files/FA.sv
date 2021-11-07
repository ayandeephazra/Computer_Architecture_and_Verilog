///////////////////////////////////////////////////
// FA.sv  This design will take in 3 bits       //
// and add them to produce a sum and carry out //
////////////////////////////////////////////////
module FA(
  input 	A,B,Cin,	// three input bits to be added
  output	S,Cout		// Sum and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic Sout1;
	logic Cout1;
	logic Cout2;

	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	xor iXOR1(Sout1,A,B);
	xor iXOR2(S,Sout1,Cin);

	and iAND1(Cout1,A,B);
	and iAND2(Cout2,Sout1,Cin);
	or iOR1(Cout,Cout1,Cout2);
	
endmodule // FA