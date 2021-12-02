module mux8_1 (A, B, C, D, E, F, G, H, S, out);
 
  input A, B, C, D, E, F, G, H;
  input [2:0] S;
  output out;

  wire mux_out1, mux_out2;


  mux4_1 iMUX1 (.A(A), .B(B), .C(C), .D(D), .S(S[1:0]), .out(mux_out1));
  mux4_1 iMUX2 (.A(E), .B(F), .C(G), .D(H), .S(S[1:0]), .out(mux_out2));
  mux2_1 iMUX3 (.A(mux_out1), .B(mux_out2), .S(S[2]), .out(out));
endmodule
