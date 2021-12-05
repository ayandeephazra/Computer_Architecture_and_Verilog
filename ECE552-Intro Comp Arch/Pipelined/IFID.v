module IFID (nxt_pc_in, nxt_pc_out, instr_in, instr_out, en, clk, rst);

  input clk, rst;
  input [15:0] nxt_pc_in;
  input [15:0] instr_in;
  input en;
  output [15:0] nxt_pc_out;
  output [15:0] instr_out;

  wire [15:0] instr_sel;

  reg_16 iNXT_PC (.clk(clk), .rst(rst), .en_w_or_r(en), .in(nxt_pc_in), .out(nxt_pc_out));

  assign instr_sel = rst ? 16'h0800 : instr_in;

  reg_16 iINSTR (.clk(clk), .rst(1'b0), .en_w_or_r(en), .in(instr_sel), .out(instr_out));
endmodule