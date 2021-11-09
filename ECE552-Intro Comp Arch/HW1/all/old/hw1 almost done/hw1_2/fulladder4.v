
module fulladder4(A,B,Cin,S,Cout);
input [3:0] A,B;
input Cin;
output [3:0] S;
output Cout;

//fulladder1 iADDER1[3:0] (.A(A),.B(B),.Cin(Cin),.S(S),.Cout(Cout));
wire Cout1, Cout2, Cout3;
fulladder1 iADDER1 (.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.Cout(Cout1));
fulladder1 iADDER2 (.A(A[1]),.B(B[1]),.Cin(Cout1),.S(S[1]),.Cout(Cout2));
fulladder1 iADDER3 (.A(A[2]),.B(B[2]),.Cin(Cout2),.S(S[2]),.Cout(Cout3));
fulladder1 iADDER4 (.A(A[3]),.B(B[3]),.Cin(Cout3),.S(S[3]),.Cout(Cout));
endmodule