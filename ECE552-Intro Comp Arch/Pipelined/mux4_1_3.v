module mux4_1_3(InA, InB, InC, InD, S, Out);
  // --- Inputs and Outputs ---
  input [2:0] InA, InB, InC, InD;
  input [1:0] S;
  output [2:0] Out;

  // --- Code ---
  mux4_1 MUX4_1[2:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S[1:0]), .Out(Out));
endmodule
