module fulladder1(A,B,Cin,S,Cout);
input A,B,Cin;
output S,Cout;
wire xor1_out, xor2_out, nand1_out,nand2_out, not1_out, not2_out, nor1_out, not3_out;
xor2 iXOR1(.in1(A), .in2(B), .out(xor1_out));
xor2 iXOR2(.in1(xor1_out), .in2(Cin), .out(S));
nand2 iNAND1(.in1(xor1_out), .in2(Cin), .out(nand1_out));
not1 iNOT1(.in1(nand1_out), .out(not1_out));
nand2 iNAND2(.in1(A), .in2(B), .out(nand2_out));
not1 iNOT2(.in1(nand2_out), .out(not2_out));
nor2 iNOR1(.in1(not1_out), .in2(not2_out), .out(nor1_out));
not1 iNOT3(.in1(nor1_out), .out(Cout));
endmodule