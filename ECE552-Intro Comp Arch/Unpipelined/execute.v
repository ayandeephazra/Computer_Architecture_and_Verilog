module execute (instr, A, B, nxt_pc, se_5, ze_5, se_8, ze_8, se_11, se, srcALU, inv_A, inv_B, cin, ALUres, pc, enJAL);
  
  input [15:0] instr;
  input [15:0] A, B, nxt_pc;
  input [15:0] se_5, ze_5, se_8, ze_8, se_11;
  input se;
  input [1:0] srcALU;
  input inv_A, inv_B, cin;
  output [15:0] ALUres;
  output [15:0] pc;
  output enJAL;

  
  wire [15:0] se_5_tmp, se_8_tmp;
  wire [15:0] B_modif;
  wire [15:0] Branch_modif, PC_modif;
  wire [15:0] new_pc;
  wire [15:0] PC_jr;
  wire en_Branch, enJMP, enJR;
  wire zero, neg, pos;

  assign se_5_tmp = se ? se_5 : ze_5;
  assign se_8_tmp = se ? se_8 : ze_8;

/////////////////////////////////////////////
//	  BRANCH SELECT AND PC MODIF       //
/////////////////////////////////////////////
  branch_sel iBRANCH_SEL (.op(instr[15:11]), .zero(zero), .pos(pos), .neg(neg), .en(en_Branch));
  assign Branch_modif = en_Branch ? se_8 : 16'h0000;
  assign PC_modif = enJMP ? se_11 : Branch_modif;

/////////////////////////////////////////////
//	        JUMP SELECT                //
/////////////////////////////////////////////
  jump_sel iJMP_SEL (.op(instr[15:11]), .enJMP(enJMP), .enJR(enJR), .enJAL(enJAL));


/////////////////////////////////////////////
// 		 SIGN EXTENDED B / B       //
/////////////////////////////////////////////
  mux4_1_16 iB_MOD (.A(B), .B(se_5_tmp), .C(se_8_tmp), .D(16'h0000), .S(srcALU), .out(B_modif));


/////////////////////////////////////////////
// 		    ALU		           //
/////////////////////////////////////////////
  alu ALU (.A(A), .B(B_modif), .Cin(cin), .Op(instr[15:11]), .sub_op(instr[1:0]), .inv_A(inv_A), .inv_B(inv_B), .Out(ALUres), .zero(zero), .neg(neg), .pos(pos));


/////////////////////////////////////////////
//	         PC / PC w JUMP            //
/////////////////////////////////////////////
  cla_16 INC_PC (.A(nxt_pc), .B(PC_modif), .cin(1'b0), .sum(new_pc), .cout(), .P_out(), .G_out());
  cla_16 INC_JR (.A(A), .B(se_8), .cin(1'b0), .sum(PC_jr), .cout(), .P_out(), .G_out());
  assign pc = enJR ? PC_jr : new_pc;

endmodule
