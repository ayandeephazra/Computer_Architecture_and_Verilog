module alu_hier_bench;

   reg [15:0] A_pre_inv;
   reg [15:0] B_pre_inv;
   wire [15:0] A;
   wire [15:0] B;
   reg 	Cin;
   reg [2:0]	Op;
   reg 	invA;
   reg 	invB;
   reg 	sign;
   wire [15:0] Out;
   wire 	 Ofl;
   wire 	 Z;

   reg           fail;

   reg 		 cerror;
   reg [31:0] 	 ExOut;
   reg 	 ExOfl;
   reg 	 ExZ;
   integer idx;
   
   alu_hier DUT (.A(A_pre_inv), .B(B_pre_inv), .Cin(Cin), .Op(Op), .invA(invA), .invB(invB), .sign(sign), .Out(Out), .Ofl(Ofl), .Z(Z));
   
   initial
     begin
	A_pre_inv = 16'b0000;
	B_pre_inv = 16'b0000;
	Cin = 1'b0;
	Op = 3'b000;
	invA = 1'b0;
	invB = 1'b0;
	sign = 1'b0;
        fail = 0;
        
	#5000;
        if (fail)
          $display("TEST FAILED");
        else
          $display("TEST PASSED");
        $finish;
     end

  assign A = invA ? ~A_pre_inv : A_pre_inv;
  assign B = invB ? ~B_pre_inv : B_pre_inv;
   
   always@(posedge DUT.clk)
     begin
	A_pre_inv = $random;
	B_pre_inv = $random;
	Cin = $random;
	Op = $random;
	invA = $random;
	invB = $random;
	//invA = 1'b1;
	//invB = 1'b1;
	sign = $random;
     end

   always@(negedge DUT.clk)
     begin
	cerror = 1'b0;
	ExOut = 32'h0000_0000;
	ExZ = 1'b0;
	ExOfl = 1'b0;
	
	case (Op)
	  
	  3'b000 :
	    // A + B
	    begin
	       ExOut = A + B + Cin;
	       if (ExOut[15:0] == 16'h0000)
		 ExZ = 1'b1;
	       if (sign == 1'b1)
		 ExOfl = ExOut[15]^A[15]^B[15]^ExOut[16];
	       else
		 ExOfl = ExOut[16];
		 
	       if ((ExOut[15:0] !== Out) || (ExZ !== Z) || (ExOfl !== Ofl))
		 cerror = 1'b1;
	    end
	  3'b001 :
	    // A OR B
	    begin
	       ExOut = A | B;
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	  3'b010 :
	    // A XOR B
	    begin
	       ExOut = A ^ B;
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	  
	  3'b011 :
	    // A AND B
	    begin
	       ExOut = A & B;
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	  3'b100 :
	    // Shift Right Arithmetic
	    begin
	       for(idx = 31; idx > 15 ; idx = idx - 1)
		 ExOut[idx] = A[15];
	       ExOut[15:0] = A[15:0];
	       ExOut[15:0] = ExOut >> B[3:0];
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1; 
	    end
	  3'b101 :
	    // Right shift logical
	    begin
	       ExOut = A >> B[3:0];
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	  3'b110 :
	    // Rotate Left
	    begin
	       ExOut = A << B[3:0] | A >> 16-B[3:0];
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	  3'b111 :
	    // Shift Left
	    begin
	       ExOut = A << B[3:0];
	       if (ExOut[15:0] !== Out)
		 cerror = 1'b1;
	    end
	endcase // case (Op)
	
	if (cerror == 1'b1) begin
	  $display("ERRORCHECK :: ALU :: Inputs :: Op = %d , A = %x, B = %x, Cin = %x, invA = %x, invB = %x, sign = %x :: Outputs :: Out = %x, Ofl = %x, Z = %z :: Expected :: Out = %x, Ofl = %x, Z = %x", Op, A_pre_inv, B_pre_inv, Cin, invA, invB, sign, Out, Ofl, Z, ExOut[15:0], ExOfl, ExZ);
           fail = 1;
        end
	
     end

endmodule // tb_alu
