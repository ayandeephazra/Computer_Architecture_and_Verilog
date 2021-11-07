///////////////////////////////////////////////////////////
// satAdd.sv  This design will add two 16-bit vectors   //
// and produce a 16-bit sum.  The result is saturated  //
// to 0x7FFF if it were to overflow + or 0x8000 if it //
// were to overflow negative.                        //
//////////////////////////////////////////////////////
module satAdd(
  input 	[15:0]	A,B,		// two 16-bit vectors to be added
  output 	[15:0]	satSum		// 16-bit Sum
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic [15:0] Sum;		// raw sum from RCA16
	logic satPos,satNeg;	// result of sat_logic that tells us to saturated
	logic AMSB, BMSB, SMSB;
	logic AND1, AND2, NOTA, NOTB, NOTS;
	logic [15:0] firstMUX;
	logic [15:0] overflowVal1 = 16'h7FFF; 
	logic [15:0] overflowVal2 = 16'h8000;
	//logic carryout;
	//logic carryin;
	//<-- You might need to declare a few more -->
	
	////////////////////////////////////////
	// Instantiate RCA16 to form raw Sum //
	//////////////////////////////////////
	//<-- Instantiate RCA16 here...use connect by name: i.e.  .A(A) -->
	RCA16 iRCA0(.A(A), .B(B), .Cin(), .S(Sum), .Cout());
	//overflowVal1 = 16’h7FFF;
	//overflowVal2 = 16’h8000;
	assign AMSB = A[15];
	assign BMSB = B[15];
	assign SMSB = Sum[15];
    ///////////////////////////////////////////////
	// Infer sat_logic using structural verilog //
	// (instantiation of primitive gates)      //
	////////////////////////////////////////////
	//<-- add verilog primitives here to form satNeg, satPos -->
	not not1(NOTA, AMSB);
	not not2(NOTB, BMSB);
	not not3(NOTS, SMSB);
	and and1(AND1, NOTA, NOTB);
	and and2(satPos, AND1, SMSB);
	and and3(AND2, AMSB, BMSB);
	and and4(satNeg, AND2, NOTS);

	////////////////////////////////////////////////////////////////
	// Infer saturation muxes using dataflow (assign statements) //
	// assign MuxOut = sel ? D1 : D0;   // a simple 2:1 mux     //
	/////////////////////////////////////////////////////////////
    //<-- Use data flow here to infer muxes that pipe in saturation values -->
	
	assign firstMUX = ~satPos ? Sum : overflowVal1;
	assign satSum = ~satNeg ? firstMUX : overflowVal2;
	//$display("The value of result is: %b", satSum) ;
	
endmodule