///////////////////////////////////////////////////////
// RCA16.sv  This design will add two 4-bit vectors  //
// plus a carry in to produce a sum and a carry out//
////////////////////////////////////////////////////
module RCA16(
  input 	[15:0]	A,B,	// two 16-bit vectors to be added
  input 			Cin,	// An optional carry in bit
  output 	[15:0]	S,		// 4-bit Sum
  output 			Cout  	// and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic	[15:0] CarryIn;
	logic 	[15:0] CarryOut;

	assign CarryIn = {CarryOut[14:0],Cin};
	assign Cout = CarryOut[15];

	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	FA iFA[15:0] (.A(A),.B(B),.Cin(CarryIn),.S(S),.Cout(CarryOut));
	
endmodule