module alu (A, B, Cin, Op, sub_op, inv_A, inv_B, Out, zero, neg, pos);

  input [15:0] A, B; 
  input Cin; 
  input [4:0] Op; 
  input [1:0] sub_op;
  input inv_A, inv_B; 
  output reg [15:0] Out;
  output zero, neg, pos; 

  wire [15:0] shft_out_imm, shft_out;
  wire [15:0] cla_sum, mux_out;
  wire [15:0] A_modif, B_modif;
  wire G_out;


  cla_16 iCLA (.A(A_modif), .B(B_modif), .cin(Cin), .sum(cla_sum), .cout(), .P_out(), .G_out(G_out));

  shifter iSHFT_IMM (.In(A_modif), .Cnt(B_modif[3:0]), .Op(Op[1:0]), .Out(shft_out_imm));
  shifter iSHFT (.In(A_modif), .Cnt(B_modif[3:0]), .Op(sub_op[1:0]), .Out(shft_out));


  always @(*) begin
    Out = 16'hXXXX;

    casex (Op)

      5'b00000: begin 
        end

      5'b00001: begin
       end


      5'b01000: begin // --- ADDI Rd, Rs, immediate ---
        Out = cla_sum;
      end

      5'b01001: begin 
        Out = cla_sum;
      end
 
      5'b01010: begin 
        Out = A_modif ^ B_modif;
      end


      5'b01011: begin 
        Out = A_modif & B_modif;
      end

      5'b101xx: begin 
        Out = shft_out_imm;
      end


      5'b10000: begin 
        Out = cla_sum;
      end

      5'b10001: begin 
        Out = cla_sum;
      end

      5'b10011: begin 
        Out = cla_sum;
      end

      5'b11001: begin 
        Out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};
      end


      5'b11011: begin 
        Out = mux_out;
      end

      5'b11010: begin
        Out = shft_out;
      end

      5'b11100: begin 
        Out = zero ? 16'h1 : 16'h0;
      end


      5'b11101: begin 
        Out =  ((neg & ~(A[15] ^ B[15])) | (A[15] & ~B[15])) ? 16'h1: 16'h0;
      end

      5'b11110: begin 
        Out = ((neg & ~(A[15] ^ B[15])) | (A[15] & ~B[15]) | zero) ? 16'h1 : 16'h0;
      end


      5'b11111: begin 
        Out = G_out ? 16'h0001 : 16'h0000;
      end

      5'b01100: begin 
        Out = cla_sum;
      end


      5'b01101: begin 
        Out = cla_sum;
      end

// 		  	BLTZ		      		 //
//   		     Rs, immediate			 //

      5'b01110: begin 
        Out = cla_sum;
      end

// 		  	BGEZ		      		 //
//   		     Rs, immediate			 //

      5'b01111: begin 
        Out = cla_sum;
      end

      5'b11000: begin
        Out = B;
      end

// 		  	SLBI		      		 //
//   		     Rs, immediate			 //

      5'b10010: begin 
        Out = (A << 8) | B;
      end


// 		  	J		      		 // 

      5'b00100: begin 
        Out = cla_sum;
      end


// 		  	JR		      		 // 

      5'b00101: begin 
        Out = cla_sum;
      end


// 		  	JAL		      		 // 

      5'b00110: begin 
        Out = cla_sum;
      end

// 		  	JALR		      		 // 

      5'b00111: begin 
        Out = cla_sum;
      end


// 		  	siic		      		 // 

      5'b00010: begin 
        end

// 		  	NOP/RTI		      		 // 

      5'b00011: begin 
       
      end
      default: begin  
       end
    endcase
  end


// 	     FLAGS   	  	       //

  assign zero = ~|cla_sum;
  assign neg = ~zero & cla_sum[15];
  assign pos = ~zero & ~cla_sum[15];


// 	     INPUT INVERSION   	       //
  assign A_modif = inv_A ? ~A : A;
  assign B_modif = inv_B ? ~B : B;


//      ADD/SUB/XOR/ANDN  SELECT       //

  mux4_1_16 iMUX(.A(cla_sum), .B(cla_sum), .C(A_modif ^ B_modif), .D(A_modif & B_modif), .S(sub_op), .out(mux_out));

endmodule
