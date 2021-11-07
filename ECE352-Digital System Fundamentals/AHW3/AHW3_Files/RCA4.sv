///////////////////////////////////////////////////////
// RCA4.sv  This design will add two 4-bit vectors  //
// plus a carry in to produce a sum and a carry out//
////////////////////////////////////////////////////
module RCA4(
  input 	[3:0]	A,B,	// two 4-bit vectors to be added
  input 			Cin,	// An optional carry in bit
  output 	[3:0]	S,		// 4-bit Sum
  output 			Cout  	// and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic C01;
	logic C02;
	logic C03;
	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	FA iFA0(.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.Cout(C01));
	FA iFA1(.A(A[1]),.B(B[1]),.Cin(C01),.S(S[1]),.Cout(C02));
	FA iFA2(.A(A[2]),.B(B[2]),.Cin(C02),.S(S[2]),.Cout(C03));
	FA iFA3(.A(A[3]),.B(B[3]),.Cin(C03),.S(S[3]),.Cout(Cout));

	
endmodule