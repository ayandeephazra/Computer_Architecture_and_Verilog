module se_handler(instr, se_5, se_8, ze_8, ze_5, se_11);
// SIGN EXTENSION HANDLER MODULE
input [15:0] instr;
output [15:0] se_5;
output [15:0] se_8;
output [15:0] ze_8;
output [15:0] ze_5;
output [15:0] se_11;

// sign extend handling
  assign se_5 = {{11{instr[4]}}, instr[4:0]};
  assign se_8 = {{8{instr[7]}}, instr[7:0]};
  assign ze_8 = {{8{1'b0}}, instr[7:0]};
  assign se_11 = {{5{instr[10]}}, instr[10:0]};
  assign ze_5 = {{11{1'b0}}, instr[4:0]};


endmodule
