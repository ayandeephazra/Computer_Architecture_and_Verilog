module decode3_8 (in, out);
  // --- inputs and outputs ---
  input [2:0] in;
  output [7:0] out;

  // --- wires ---
  wire [2:0] nin;

  // --- code ---
  assign nin[0] = ~in[0];
  assign nin[1] = ~in[1];
  assign nin[2] = ~in[2];
  
  assign out[0] = nin[2] & nin[1] & nin[0];
  assign out[1] = nin[2] & nin[1] &  in[0];
  assign out[2] = nin[2] &  in[1] & nin[0];
  assign out[3] = nin[2] &  in[1] &  in[0];
  assign out[4] =  in[2] & nin[1] & nin[0];
  assign out[5] =  in[2] & nin[1] &  in[0];
  assign out[6] =  in[2] &  in[1] & nin[0];
  assign out[7] =  in[2] &  in[1] &  in[0];
endmodule
