module mux4_1(A, B, C, D, S, out);

  input A, B, C, D;  
  input [1:0] S;
  output out;

  wire mux_out1, mux_out2;

  mux2_1 iMUX1(.A(A), .B(B), .S(S[0]), .out(mux_out1));
  mux2_1 iMUX2(.A(C), .B(D), .S(S[0]), .out(mux_out2));
  mux2_1 iMUX3(.A(mux_out1), .B(mux_out2), .S(S[1]), .out(out));
endmodule
