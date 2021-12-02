module control(instr, memWrite, RegWrite, memtoreg, inv_A, inv_B, Cin, se, srcALU, RegDst, halt);
  
  input [15:0] instr;
  output reg memWrite;
  output reg RegWrite;
  output reg memtoreg; 
  output reg inv_A, inv_B;
  output reg Cin;
  output reg se;
  output reg [1:0] srcALU;
  output reg [1:0] RegDst;
  output reg halt;


  always @(*) begin

    RegDst = 2'b11; memWrite = 1'b0; RegWrite = 1'b0; srcALU = 2'b11; halt = 1'b0;
    memtoreg = 1'b0; inv_A = 1'b0; inv_B = 1'b0; Cin = 1'b0; se = 1'b0;

    case ({instr[15:11]})

// 		        HALT 		      		 //
//   Cease instruction issue, dump memory state to file	 //
  
      5'b00000: begin 
        RegDst = 2'b00; halt = 1'b1;
      end

// 		        NOP 		      		 //
//   			None				 //

      5'b00001: begin 
        RegDst = 2'b00; 
      end

// 		        ADDI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b01000: begin 
	RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; se = 1'b1;
      end

// 		        SUBI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b01001: begin 
	RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; inv_A = 1'b1;Cin = 1'b1; se = 1'b1;
      end


// 		        XORI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b01010: begin 
	RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; 
        
      end

// 		        ANDI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b01011: begin 
  	 RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; inv_B = 1'b1;
      end


// 		        ROLI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10100: begin 
	RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; 
      end


// 		        SLLI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10101: begin 
	RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; 
      end


// 		        RORI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10110: begin 
        RegDst = 2'b01;  RegWrite = 1'b1; srcALU = 2'b01; 
      end


// 		        SRLI 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10111: begin 
        RegDst = 2'b01; RegWrite = 1'b1; srcALU = 2'b01; 
      end


// 		        ST 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10000: begin 
        RegDst = 2'b10; memWrite = 1'b1;srcALU = 2'b01; se = 1'b1;
      end


// 		        LD 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10001: begin 
        RegDst = 2'b01; RegWrite = 1'b1; memtoreg = 1'b1; srcALU = 2'b01; se = 1'b1;
      end

// 		        STU 		      		 //
//   		    Rd, Rs, immediate			 //

      5'b10011: begin 
        RegDst = 2'b10; memWrite = 1'b1; RegWrite = 1'b1; srcALU = 2'b01; se = 1'b1;
      end


// 		        BTR 		      		 //
//   		      Rd, Rs				 //

      5'b11001: begin 
        RegDst = 2'b00; RegWrite = 1'b1; srcALU = 2'b11; 
      end


// 		  ADD/SUB/XOR/ANDN 	      		 //
//   		      Rd, Rs, Rt			 //

      5'b11011: begin 
        RegDst = 2'b00; RegWrite = 1'b1; srcALU = 2'b00; Cin = (instr[1:0] == 2'b01) ? 1'b1 : 1'b0;
        inv_A = (instr[1:0] == 2'b01) ? 1'b1 : 1'b0;
        inv_B = (instr[1:0] == 2'b11) ? 1'b1 : 1'b0;
      end


// 		  ROL/SLL/ROR/SRL	      		 //
//   		      Rd, Rs, Rt			 //

      5'b11010: begin 
        RegDst = 2'b00; RegWrite = 1'b1; srcALU = 2'b00;
      end

// 		 	  SEQ      			 //
//   		      Rd, Rs, Rt			 //

      5'b11100: begin 
        RegDst = 2'b00; RegWrite = 1'b1;srcALU = 2'b00; inv_B = 1'b1; Cin = 1'b1;
      end


// 		  	SLT      	 		 //
//   		      Rd, Rs, Rt			 //

      5'b11101: begin 
        RegDst = 2'b00; RegWrite = 1'b1;srcALU = 2'b00; inv_B = 1'b1; Cin = 1'b1;
      end


// 		  	SLE      			 //
//   		      Rd, Rs, Rt			 //

      5'b11110: begin 
        RegDst = 2'b00; RegWrite = 1'b1; srcALU = 2'b00; inv_B = 1'b1; Cin = 1'b1;
      end


// 		  	SCO		      		 //
//   		      Rd, Rs, Rt			 //

      5'b11111: begin 
        RegDst = 2'b00;RegWrite = 1'b1;srcALU = 2'b00; 
      end

// 		  	BEQZ		      		 //
//   		     Rs, immediate			 //

      5'b01100: begin 
        RegDst = 2'b10; inv_B = 1'b1;Cin = 1'b1;
      end

// 		  	BNEZ		      		 //
//   		     Rs, immediate			 //

      5'b01101: begin 
        RegDst = 2'b10; inv_B = 1'b1; Cin = 1'b1;
      end

// 		  	BLTZ		      		 //
//   		     Rs, immediate			 //

      5'b01110: begin 
        RegDst = 2'b10;inv_B = 1'b1; Cin = 1'b1;
      end



// 		  	BGEZ		      		 //
//   		     Rs, immediate			 //

      5'b01111: begin 
        RegDst = 2'b10; inv_B = 1'b1; Cin = 1'b1;
      end


// 		  	LBI		      		 //
//   		     Rs, immediate			 //

      5'b11000: begin 
        RegDst = 2'b10; RegWrite = 1'b1; srcALU = 2'b10; se = 1'b1;
      end



// 		  	SLBI		      		 //
//   		     Rs, immediate			 //

      5'b10010: begin 
        RegDst = 2'b10; 
	RegWrite = 1'b1; 
	srcALU = 2'b10;
      end
// NO HANDLING FOR JUMP, SEPERATELY DONE

// 		  	J		      		 // 

      5'b00100: begin 
      end

// 		  	JR		      		 // 

      5'b00101: begin 
       end


// 		  	JAL		      		 // 

      5'b00110: begin 
        RegWrite = 1'b1;
      end

// 		  	JALR		      		 // 

      5'b00111: begin 
        RegWrite = 1'b1;
      end

// NO HANDLING FOR SIIC IN THIS PHASE OF PROJECT

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

endmodule
