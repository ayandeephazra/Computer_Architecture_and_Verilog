module quaddemux1_4(Inp, S, OutA, OutB, OutC, OutD);

input [3:0] Inp;
input [1:0] S;
output [3:0] OutA, OutB, OutC, OutD;

demux1_4 iDEMUX1_4[3:0] (.Inp(Inp), .S(S), .OutA(OutA), .OutB(OutB), .OutC(OutC), .OutD(OutD));

endmodule