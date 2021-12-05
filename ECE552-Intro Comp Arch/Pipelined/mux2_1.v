module mux2_1(InA, InB, S, Out);
  // --- Input and Outputs ---
  input InA, InB; // input data
  input S; // select line
  output Out;

  // --- wire ---
  wire notS, nandAS, nandBS;

  // --- Code ---
  assign notS = ~S;  

  assign nandAS = ~(InA & notS);
  assign nandBS = ~(InB & S);

  assign Out = ~(nandAS & nandBS);
endmodule
