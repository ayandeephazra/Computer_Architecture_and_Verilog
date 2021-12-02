module cla_4(A, B, cin, sum, cout, P_out, G_out);

  input [3:0] A, B;
  input cin;
  output [3:0] sum;
  output cout, P_out, G_out;


  wire [3:0] C, P, G;

  assign P = A | B;
  assign P_out = &P;


  assign G = A & B;
  assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);


  assign C[0] = cin;
  assign C[1] = G[0] | (P[0] & C[0]);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
  assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

  assign sum = A ^ B ^ C;

endmodule
