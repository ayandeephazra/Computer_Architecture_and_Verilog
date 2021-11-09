module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [2:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;
        output Ofl;
        output Z;

   /*
	Your code goes here
   */
        wire [15:0] inputZero, inputOne, A_modif, B_modif, sum;
	// temporary overflow value returned from the CLA module
	wire cla_cout, tempOfl, addOverflow, subOverflow;
    
	// Inversion support and integration
	assign A_modif = (invA)? ~A: A;
	assign B_modif = (invB)? ~B: B;

	cla_16 iCLA(.a(A_modif),.b(B_modif), .cin(Cin), .sum(sum),.cout(tempOfl));
	//////////////////////

	// Overflow for Signed Addition
	assign addOverflow = (sign & Op==3'b000)?{   ((A[15]&B[15]&~sum[15])|(~A[15]&~B[15]&sum[15]))?1'b1:{(A[15]!==B[15] & sum[15])? 1'b1 : tempOfl  }}:tempOfl;
	// Overflow for Signed Subtraction
	assign subOverflow = (sign & Op==3'b000)?{(~invA&invB&Cin)? {((B[15]&~A[15]&~sum[15])||(~B[15]&A[15]&sum[15]))?1'b1:tempOfl}:   {(invA&~invB&Cin)? {((A[15]&~B[15]&~sum[15])||(~A[15]&B[15]&sum[15]))?1'b1:tempOfl}: tempOfl }  }: tempOfl;
	// any Overflow is registered
	assign Ofl = addOverflow|subOverflow;
	/////////////////////

        mux_4_1 iMUX4TO1_1(.select(Op[1:0]), .out(inputZero), .a(sum), .b(A_modif|B_modif), .c(A_modif^B_modif), .d(A_modif&B_modif));

        shifter iSHIFT(.In(A_modif), .Cnt(B_modif[3:0]), .Op(Op[1:0]), .Out(inputOne));
        //mux_4_1 iMUX4TO1_1(.select(Op[1:0]), .out(inputOne), .a(A+B), .b(A|B), .c(A^B), .d(A&B));

        mux_2_1 iMUX2TO1_1(.select(Op[2]), .out(Out), .a(inputZero), .b(inputOne));
	assign Z = (Out===16'h0000)? 1'b1: 1'b0;
endmodule
