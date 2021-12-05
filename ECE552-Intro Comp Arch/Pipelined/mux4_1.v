
module mux4_1(InA, InB, InC, InD, S, Out);
  // --- Inputs and Outputs ---
  input InA, InB, InC, InD; // 
  input [1:0] S;
  output Out;

  // --- Wires ---
  wire out1, out2;

  // --- Code ---
  mux2_1 MUX1(.InA(InA), .InB(InB), .S(S[0]), .Out(out1));
  mux2_1 MUX2(.InA(InC), .InB(InD), .S(S[0]), .Out(out2));

  mux2_1 MUX3(.InA(out1), .InB(out2), .S(S[1]), .Out(Out));
endmodule