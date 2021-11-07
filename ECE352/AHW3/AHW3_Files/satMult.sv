///////////////////////////////////////////////////////
// satMult.sv  Signed 16x16 multiply with divide by //
// 2^15 and saturation logic.                      //
////////////////////////////////////////////////////
module satMult(
  input signed [15:0] coeff,	// signed 16-bit input always is a coefficient from NV_mem
  input signed [15:0] Temp,		// Always from the Temp register
  output 	[15:0]	satProd		// 16-bit saturated product
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic signed [31:0] Prod;		// raw 16x16 signed product
	logic satPos,satNeg;			// result of sat_logic that tells us to saturated
	//<-- you might need to declare a few more internal signals -->//

        logic [15:0] MUX1;                           // 2-1 MUX used in implementation
        logic A, B, C, NOTA, NOTB, NOTC;             // representations of bits 31, 30, 29 of 
                                                     // Prod and their complements respectively
        logic m4m5, m4m6, m1m3, m2m3;                // minterm groupings needed in the final output
                                                     // eg) m4m5 would mean (m4 AND m5)
        logic [15:0] overflowVal1 = 16'h7FFF;        // OVERFLOW CONSTANT
        logic [15:0] overflowVal2 = 16'h8000;        // OVERFLOW CONSTANT
	
	//////////////////////////////////
	// infer 16x16 signed multiply //
	////////////////////////////////
	assign Prod = coeff*Temp;	// don't touch this
  
        assign A = Prod[31];
        assign B = Prod[30];
        assign C = Prod[29];
        not not1(NOTA, A);
        not not2(NOTB, B);
        not not3(NOTC, C);

    ///////////////////////////////////////////////
	// Infer sat_logic using structural verilog //
	// (instantiation of primitive gates)      //
	////////////////////////////////////////////
	//<-- instantiate verilog primitives to form satNeg, satPos logic -->//
        and and1(m4m5, A, NOTB);
        and and2(m4m6, A, NOTC);
        and and3(m1m3, NOTA, C);
        and and4(m2m3, NOTA, B);

        or or1(satNeg, m4m5, m4m6);
        or or2(satPos, m1m3, m2m3);
	
	////////////////////////////////////////////////////////////////
	// Infer saturation muxes using dataflow (assign statements) //
	// assign MuxOut = sel ? D1 : D0;   // a simple 2:1 mux     //
	/////////////////////////////////////////////////////////////
	//<-- use dataflow to infer muxes that pipe in saturation values -->//
        assign MUX1 = satPos? overflowVal1: Prod[29:14]; 
        assign satProd = satNeg? overflowVal2: MUX1;        
	
endmodule