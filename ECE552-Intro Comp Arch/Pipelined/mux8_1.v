module mux8_1 (InA, InB, InC, InD, InE, InF, InG, InH, S, Out);
  // --- Inputs and Outputs
  input InA, InB, InC, InD, InE, InF, InG, InH;
  input [2:0] S;
  output Out;

  // --- Wires ---
  wire out1, out2;

  // --- Code ---
  mux4_1 MUX1 (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S[1:0]), .Out(out1));
  mux4_1 MUX2 (.InA(InE), .InB(InF), .InC(InG), .InD(InH), .S(S[1:0]), .Out(out2));

  mux2_1 MUX3 (.InA(out1), .InB(out2), .S(S[2]), .Out(Out));
endmodule