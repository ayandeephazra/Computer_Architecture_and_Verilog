module mux8_1_16(A, B, C, D, E, F, G, H, S, out);

  input [15:0] A, B, C, D, E, F, G, H;
  input [2:0] S;
  output [15:0] out;

  mux8_1 iMUX[15:0] (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .S(S[2:0]), .out(out));
endmodule
