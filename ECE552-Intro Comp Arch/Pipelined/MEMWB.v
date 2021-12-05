module MEMWB (readData_in, readData_out, nxt_pc_in, nxt_pc_out, pc_in, pc_out, ALUres_in, ALUres_out, AB_in, AB_out, regSel_in, regSel_out, regWrite_in, regWrite_out, memtoreg_in, memtoreg_out, enJAL_in, enJAL_out, branch_in, branch_out, halt_in, halt_out, en, clk, rst);

  input [15:0] readData_in;
  input [15:0] nxt_pc_in;
  input [15:0] pc_in;
  input [15:0] ALUres_in;
  input [4:0] AB_in;
  input [2:0] regSel_in;
  input regWrite_in;
  input memtoreg_in;
  input enJAL_in;
  input branch_in;
  input halt_in;
  input en;
  input clk, rst;
  output [15:0] readData_out;
  output [15:0] nxt_pc_out;
  output [15:0] pc_out;
  output [15:0] ALUres_out;
  output [4:0] AB_out;
  output [2:0] regSel_out;
  output regWrite_out;
  output memtoreg_out;
  output enJAL_out;
  output branch_out;
  output halt_out;

  
  reg_16 readData (.clk(clk), .rst(rst), .en_w_or_r(en), .in(readData_in), .out(readData_out));
  reg_16 nextPC (.clk(clk), .rst(rst), .en_w_or_r(en), .in(nxt_pc_in), .out(nxt_pc_out));
  reg_16 newPC (.clk(clk), .rst(rst), .en_w_or_r(en), .in(pc_in), .out(pc_out));
  reg_16 aluResult (.clk(clk), .rst(rst), .en_w_or_r(en), .in(ALUres_in), .out(ALUres_out));
  reg_5 AB (.clk(clk), .rst(rst), .en_w_or_r(en), .in(AB_in), .out(AB_out));
  reg_3 regSel (.clk(clk), .rst(rst), .en_w_or_r(en), .in(regSel_in), .out(regSel_out));
  reg_1 regWrite (.clk(clk), .rst(rst), .en_w_or_r(en), .in(regWrite_in), .out(regWrite_out));
  reg_1 mem_to_reg (.clk(clk), .rst(rst), .en_w_or_r(en), .in(memtoreg_in), .out(memtoreg_out));
  reg_1 enJAL (.clk(clk), .rst(rst), .en_w_or_r(en), .in(enJAL_in), .out(enJAL_out));
  reg_1 branch (.clk(clk), .rst(rst), .en_w_or_r(en), .in(branch_in), .out(branch_out));
  reg_1 halt (.clk(clk), .rst(rst), .en_w_or_r(en), .in(halt_in), .out(halt_out));
endmodule