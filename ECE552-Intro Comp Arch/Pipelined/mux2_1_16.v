module mux2_1_16(InA, InB, S, Out);
  // --- Inputs and Outputs ---
  input [15:0] InA, InB;
  input S;
  output [15:0] Out;

  // --- Code ---
  mux2_1 MUX2_1[15:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));
endmodule