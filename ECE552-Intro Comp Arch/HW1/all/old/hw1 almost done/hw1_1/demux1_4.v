module demux1_4(Inp, S, OutA, OutB, OutC, OutD);

input Inp;
input [1:0] S;
output OutA, OutB, OutC, OutD;

wire abInp, cdInp;

demux1_2 iDEMUX1_2_3(.Inp(Inp), .S(S[1]), .OutA(abInp), .OutB(cdInp));
demux1_2 iDEMUX1_2_1(.Inp(abInp), .S(S[0]), .OutA(OutA), .OutB(OutB));
demux1_2 iDEMUX1_2_2(.Inp(cdInp), .S(S[0]), .OutA(OutC), .OutB(OutD));

//demux1_2 iDEMUX1_2_4(.Inp(Inp), .S(S[0]), .OutA(OutB), .OutB(OutD));

endmodule
