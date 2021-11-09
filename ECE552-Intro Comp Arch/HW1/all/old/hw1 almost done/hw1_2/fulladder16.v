
module fulladder16(A,B,S,Cout);
input [15:0] A,B;
//input Cin;
output [15:0] S;
output Cout;

//fulladder4 iADDER1[15:0] (.A(A),.B(B),.Cin(Cin),.S(S),.Cout(Cout));

wire Cout1, Cout2, Cout3;
fulladder4 iADDER1 (.A(A[3:0]),.B(B[3:0]),.Cin(1'b0),.S(S[3:0]),.Cout(Cout1));
fulladder4 iADDER2 (.A(A[7:4]),.B(B[7:4]),.Cin(Cout1),.S(S[7:4]),.Cout(Cout2));
fulladder4 iADDER3 (.A(A[11:8]),.B(B[11:8]),.Cin(Cout2),.S(S[11:8]),.Cout(Cout3));
fulladder4 iADDER4 (.A(A[15:12]),.B(B[15:12]),.Cin(Cout3),.S(S[15:12]),.Cout(Cout));

endmodule
