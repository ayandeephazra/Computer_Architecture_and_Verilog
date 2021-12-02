module decoder3_8 (S, out);

  input [2:0] S;
  output [7:0] out;
  
  assign out[0] = (~S[2]) & (~S[1]) & (~S[0]);
  assign out[1] = (~S[2]) & (~S[1]) &  S[0];
  assign out[2] = (~S[2]) &  S[1] & (~S[0]);
  assign out[3] = (~S[2]) &  S[1] &  S[0];
  assign out[4] =  S[2] & (~S[1]) & (~S[0]);
  assign out[5] =  S[2] & (~S[1]) &  S[0];
  assign out[6] =  S[2] &  S[1] & (~S[0]);
  assign out[7] =  S[2] &  S[1] &  S[0];

endmodule