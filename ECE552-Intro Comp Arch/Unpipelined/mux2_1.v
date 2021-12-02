module mux2_1(A, B, S, out);

  input A, B; 
  input S;
  output out;

  wire nand1, nand2;

  assign nand1 = ~(A & (~S));
  assign nand2 = ~(B & S);

  assign out = ~(nand1 & nand2);
endmodule
