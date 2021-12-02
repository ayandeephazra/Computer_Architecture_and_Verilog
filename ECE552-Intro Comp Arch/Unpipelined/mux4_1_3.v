module mux4_1_3(A, B, C, D, S, out);

  input [2:0] A, B, C, D;
  input [1:0] S;
  output [2:0] out;

  mux4_1 iMUX[2:0] (.A(A), .B(B), .C(C), .D(D), .S(S[1:0]), .out(out));
endmodule
