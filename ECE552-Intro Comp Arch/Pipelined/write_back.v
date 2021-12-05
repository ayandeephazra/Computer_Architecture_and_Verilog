module write_back (ALUres, readData, nxt_pc, enJAL, memtoreg, writeData);

  input [15:0] ALUres;
  input [15:0] readData;
  input [15:0] nxt_pc;
  input enJAL;
  input memtoreg;

  output [15:0] writeData;

  mux4_1_16 WB_MUX (.InA(ALUres), .InB(readData), .InC(nxt_pc), .InD(16'hXXXX), .S({enJAL, memtoreg}), .Out(writeData));
endmodule