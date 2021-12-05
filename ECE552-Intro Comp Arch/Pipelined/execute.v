module execute (epc_out, clk, rst, instr, A, B, nxt_pc, se_5, ze_5, se_8, ze_8, se_11, se, srcALU, regDestination, inv_A, inv_B, cin, ALUres, pc, regsel, enJAL, branch, siic, rti);

  input [15:0] instr;
  input [15:0] A, B, nxt_pc;
  input [15:0] se_5, ze_5, se_8, ze_8, se_11;
  input se;
  input [1:0] srcALU;
  input [1:0] regDestination;
  input inv_A, inv_B, cin;
  input siic, rti;
  output [15:0] ALUres;
  output [15:0] pc;
  output [2:0] regsel;
  output enJAL;
  output branch;
  input clk;
  input rst;
  output [15:0] epc_out;


  wire [15:0] se_5_tmp, se_8_tmp;
  wire [15:0] B_modif;
  wire zero, neg, pos;
  wire enBranch, enJMP, enJR;
  wire [15:0] Branch_modif, PC_modif;
  wire [15:0] new_pc, PC_jr;


  assign se_5_tmp = se ? se_5 : ze_5;
  assign se_8_tmp = se ? se_8 : ze_8;

/////////////////////////////////////////////
//	  BRANCH SELECT AND PC MODIF       //
/////////////////////////////////////////////
  branch_sel BRANCH (.op(instr[15:11]), .zero(zero), .pos(pos), .neg(neg), .en(enBranch));
  assign Branch_modif = enBranch ? se_8 : 16'h0000;
  assign PC_modif = enJMP ? se_11 : Branch_modif;

/////////////////////////////////////////////
//	        JUMP SELECT                //
/////////////////////////////////////////////  
jump_sel JUMP (.op(instr[15:11]), .enJMP(enJMP), .enJR(enJR), .enJAL(enJAL));


/////////////////////////////////////////////
// 		 SIGN EXTENDED B / B       //
/////////////////////////////////////////////
  mux4_1_16 SEL_B (.InA(B), .InB(se_5_tmp), .InC(se_8_tmp), .InD(16'h0000), .S(srcALU), .Out(B_modif));

  assign branch = enBranch | enJMP | enJR;

/////////////////////////////////////////////
// 		    ALU		           //
/////////////////////////////////////////////
  alu ALU (.A(A), .B(B_modif), .Cin(cin), .Op(instr[15:11]), .sub_op(instr[1:0]), .inv_A(inv_A), .inv_B(inv_B), .Out(ALUres), .zero(zero), .neg(neg), .pos(pos));


/////////////////////////////////////////////
// 		 DESTINATION REG           //
/////////////////////////////////////////////
  mux4_1_3 REG_SEL (.InA(instr[4:2]), .InB(instr[7:5]), .InC(instr[10:8]), .InD(3'b111), .S(regDestination), .Out(regsel));

/*

/////////////////////////////////////////////
//	         PC / PC w JUMP            //
/////////////////////////////////////////////
  cla_16 INC_PC (.A(nxt_pc), .B(PC_modif), .cin(1'b0), .sum(new_pc), .cout(), .P_out(), .G_out());
  cla_16 INC_JR (.A(A), .B(se_8), .cin(1'b0), .sum(PC_jr), .cout(), .P_out(), .G_out());
  assign pc = enJR ? PC_jr : new_pc;

*/

/////////////////////////////////////////////
//	         PC / PC w JUMP            //
/////////////////////////////////////////////
  wire [15:0] temp_pc, epc_out, epc_out_new;

  cla_16 INC_PC (.A(nxt_pc), .B(PC_modif), .cin(1'b0), .sum(new_pc), .cout(), .P_out(), .G_out());
  cla_16 INC_JR (.A(A), .B(se_8), .cin(1'b0), .sum(PC_jr), .cout(), .P_out(), .G_out());
cla_16 EPC_NEW (.A(epc_out), .B(~(16'h0002)), .cin(1'b1), .sum(epc_out_new), .cout(), .P_out(), .G_out());

  assign pc = enJR ? PC_jr : { siic? 16'h0002: {(rti)? epc_out_new: new_pc } };
  //assign pc = enJR? PC_jr : new_pc;
   // epc_out is the reuslt of the epc register. It is asigned to nxt_pc if rti is high
  // it's value changes depending on siic's value. If siic is high then epc changes the value of 
  // the register to tmp_pc
  epc EPC (.clk(clk), .rst(rst), .en(siic), .in(new_pc), .out(epc_out));

endmodule