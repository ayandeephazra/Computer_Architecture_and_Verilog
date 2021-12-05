module fetch (pc, AB, AB_IDEX, AB_EXMEM, AB_MEMWB, halt, siic, rti, enablePC, stall, branchEXMEM, clk, rst, nxt_pc, instr, epc_out);

  input clk, rst;
  input [15:0] pc;
  input halt;
  input siic;
  input rti;
 
  input AB, AB_IDEX, AB_EXMEM, AB_MEMWB;
  input enablePC;
  input stall, branchEXMEM;
  input [15:0] epc_out;

  output [15:0] nxt_pc;
  output [15:0] instr;

  wire [15:0] instr_tmp;
  wire branch_stall;
  wire [15:0] cur_pc; 
  wire [15:0] tmp_pc;
  wire [15:0] inc_by_2;
  wire [15:0] nxt_pc_tmp;
 

/////////////////////////////////////////////////////
// 	 A PC REG HOLDS PC UPON HALT ASSERTION     //
/////////////////////////////////////////////////////
  reg_16 iPC_REG (.clk(clk), .rst(rst), .en_w_or_r(enablePC), .in(tmp_pc), .out(cur_pc));

/////////////////////////////////////////
// 	   INSTRUCTION MEMORY          //
/////////////////////////////////////////
  wire [15:0] addr_in;
  //memory2c iINSTR_MEM (.data_out(instr_tmp), .data_in(16'h0000), .addr(cur_pc), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
  memory2c iINSTR_MEM (.data_out(instr_tmp), .data_in(16'h0000), .addr(addr_in), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
  
  assign addr_in = siic? 16'h0002: cur_pc;

/////////////////////////////////////////
// 	     PC = PC +2	   	       //
/////////////////////////////////////////
  wire [15:0] epc_out; 
  cla_16 iPC_INC (.A(cur_pc), .B(inc_by_2), .cin(1'b0), .sum(nxt_pc_tmp), .cout(), .P_out(), .G_out());
  //assign nxt_pc = siic? 16'h0002: {rti? epc_out :nxt_pc_tmp};
  assign nxt_pc = siic? 16'h0004: {rti? epc_out: nxt_pc_tmp}  ;
  //epc EPC (.clk(clk), .rst(rst), .en(siic), .in(cur_pc), .out(epc_out));
/////////////////////////////////////////
// 	   STALLING	               //
///////////////////////////////////////// 
  assign branch_stall = AB | AB_IDEX | AB_EXMEM | AB_MEMWB;
  assign instr = branch_stall ? 16'h0800 : instr_tmp;
  assign inc_by_2 = (stall | branch_stall) ? 16'h0000 : 16'h0002;
  assign tmp_pc = branchEXMEM ? pc : nxt_pc;
endmodule