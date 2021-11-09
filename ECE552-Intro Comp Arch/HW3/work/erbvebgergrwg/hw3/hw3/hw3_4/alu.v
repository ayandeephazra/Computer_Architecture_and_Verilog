module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z, read1data, read2data, writedata, beq_imm, beq_out);
   
        input [15:0] A;
        input [15:0] B;
	input [15:0] read1data;
	input [15:0] read2data;
	output [15:0] writedata;
        input Cin;
        input [1:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;
        output Ofl;
        output Z;
	input [15:0] beq_imm;
	output beq_out;

   /*
	Your code goes here
   */
        wire [15:0] inputZero, inputOne, A_modif, B_modif, sum;
	// temporary overflow value returned from the CLA module
	wire cla_cout, tempOfl, addOverflow, subOverflow;
        // BEQ HANDLING
	wire [15:0] beq_out;
    
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
	assign beq_out = (Op===2'b11 && read1data===16'h0000)? beq_imm: 16'h0000;

        mux_4_1 iMUX4TO1_1(.select(Op[1:0]), .out(Out), .a(16'hzzzz), .b(sum), .c(read1data^read2data), .d(beq_out));

endmodule
