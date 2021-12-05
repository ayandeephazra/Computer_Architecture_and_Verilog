module mux8_1_16b(InA, InB, InC, InD, InE, InF, InG, InH, S, Out);
  // --- Inputs and Outputs ---
  input [15:0] InA, InB, InC, InD, InE, InF, InG, InH;
  input [2:0] S;
  output [15:0] Out;

  // --- Code ---
  mux8_1 MUX8_1[15:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .InE(InE), .InF(InF), .InG(InG), .InH(InH), .S(S[2:0]), .Out(Out));
endmodule