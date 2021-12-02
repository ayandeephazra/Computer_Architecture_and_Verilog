module mux2_1_16(A, B, S, out);

  input [15:0] A, B;
  input S;
  output [15:0] out;

mux2_1 iMUX[15:0] (.A(A), .B(B), .S(S), .out(out));
endmodule
