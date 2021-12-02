module cla_16 (A, B, cin, sum, cout, P_out, G_out);

  input [15:0] A, B;
  input cin;
  output [15:0] sum;
  output cout, P_out, G_out;

  wire [15:0] carry_out;
  wire [3:0] P, G, C;

/////////////////////////////////////////
// 		PROPAGATE              //
/////////////////////////////////////////
  assign P_out = &P;

/////////////////////////////////////////
// 		GENERATE	       //
/////////////////////////////////////////
  assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & (G[1] | (P[1] & G[0])));

  cla_4 cla0 (.A(A[3:0]), .B(B[3:0]), .cin(cin), .sum(sum[3:0]), .cout(C[0]), .P_out(P[0]), .G_out(G[0]));
  cla_4 cla1 (.A(A[7:4]), .B(B[7:4]), .cin(C[0]), .sum(sum[7:4]), .cout(C[1]), .P_out(P[1]), .G_out(G[1]));
  cla_4 cla2 (.A(A[11:8]), .B(B[11:8]), .cin(C[1]), .sum(sum[11:8]), .cout(C[2]), .P_out(P[2]), .G_out(G[2]));
  cla_4 cla3 (.A(A[15:12]), .B(B[15:12]), .cin(C[2]), .sum(sum[15:12]), .cout(cout), .P_out(P[3]), .G_out(G[3]));


endmodule
