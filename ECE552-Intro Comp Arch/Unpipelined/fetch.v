module fetch ( clk, rst, halt, pc, nxt_pc, instr);
 
  input clk, rst;
  input [15:0] pc;
  input halt;
  output [15:0] nxt_pc;
  output [15:0] instr;

  wire [15:0] cur_pc; 

/////////////////////////////////////////////////////
// 	 A PC REG HOLDS PC UPON HALT ASSERTION     //
/////////////////////////////////////////////////////
  reg_16 iPC_REG (.clk(clk), .rst(rst), .en_w_or_r(~halt), .in(pc), .out(cur_pc));

/////////////////////////////////////////
// 	   INSTRUCTION MEMORY          //
/////////////////////////////////////////
  memory2c iINSTR_MEM (.data_out(instr), .data_in(16'h0000), .addr(cur_pc), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

/////////////////////////////////////////
// 	     PC = PC +2	   	       //
/////////////////////////////////////////
  cla_16 iPC_INC (.A(cur_pc), .B(16'h0002), .cin(1'b0), .sum(nxt_pc), .cout(), .P_out(), .G_out());

/*
	input clk;
	input rst;
	input halt;
	  input [15:0] pc;
	output [15:0] next_pc;
	output err;
	output [15:0] instr;

	// Your Code goes here
	//reg [15:0] pc, pcPrev;
	wire [15:0] pcPrev_w;
	reg [15:0] A,B;
	
	wire[15:0] S;//, pc;
	wire Cout;
        wire [15:0] pc_fetch;
	wire [15:0] pc_u;
////////////////////////////////
	memory2c iMEM(.data_out(instr), .data_in(16'h0000), .addr(pc_fetch), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
	cla_16 iCLA(.a(pc_fetch),.b(16'h0002), .cin(1'b0), .sum(pc_u), .cout(Cout));
        assign pc = (rst)? 16'h0000: pc_u;
	//dff IDFF [15:0] (.q(pc_fetch), .d(pc), .clk(clk), .rst(rst));
        reg_16 iPC(.clk(clk), .rst(rst), .en_w_or_r(~halt), .in(pc), .out(cur_pc));
	assign next_pc = pc_u;

*/
endmodule
