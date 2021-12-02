module mux4_1_16(A, B, C, D, S, out);
 
  input [15:0] A, B, C, D;
  input [1:0] S;
  output [15:0] out;

  mux4_1 iMUX[15:0] (.A(A), .B(B), .C(C), .D(D), .S(S[1:0]), .out(out));
endmodule
