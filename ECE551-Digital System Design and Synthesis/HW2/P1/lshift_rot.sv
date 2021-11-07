module lshift_rot(src, amt, rot, res);
input [15:0] src;
input [3:0] amt;
input rot;
output [15:0] res;

logic [15:0] rotResult, mux1out, mux2out, mux3out, mux4out;

// all rot == 1 will use this result
assign rotResult = {src[14:0], src[15]};

// assign to rotResult if rot is = 1, else do 1 bit left shift based on bit 0 of amt
assign mux1out = (rot)?rotResult:{(amt[0])?{src[14:0],1'b0}:src};

// assign to rotResult if rot is = 1, else do 2 bit left shift based on bit 1 of amt
assign mux2out = (rot)?rotResult:{(amt[1])?{mux1out[13:0],2'b00}:mux1out};

// assign to rotResult if rot is = 1, else do 4 bit left shift based on bit 2 of amt
assign mux3out = (rot)?rotResult:{(amt[2])?{mux2out[11:0],4'b0000}:mux2out};

// assign to rotResult if rot is = 1, else do 8 bit left shift based on bit 3 of amt
assign mux4out = (rot)?rotResult:{(amt[3])?{mux3out[7:0],8'b00000000}:mux3out};


assign res = mux4out;
endmodule