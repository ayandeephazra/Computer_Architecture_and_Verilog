module demux1_2(Inp, S, OutA, OutB);

input Inp, S;
output OutA, OutB;

wire notS, nand1out, nand2out;

not1 iNOT1(.out(notS), .in1(S));
nand2 iNAND1(.in1(Inp), .in2(notS), .out(nand1out));
nand2 iNAND2(.in1(Inp), .in2(S), .out(nand2out));
not1 iNOT2(.out(OutA), .in1(nand1out));
not1 iNOT3(.out(OutB), .in1(nand2out));
endmodule
