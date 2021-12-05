module reg_1 (clk, rst, en_w_or_r, in, out);
  
  input clk, rst;
  input en_w_or_r; 
  input in;  
  output out;

  wire en_wr;

/////////////////////////////////////////////////////////////////////////////////////////
// 	   D-FF handling write/read operation using the en_wr( a.k.a enable write)     //
/////////////////////////////////////////////////////////////////////////////////////////
  dff iFF (.q(out), .d(en_wr), .clk(clk), .rst(rst));
  assign en_wr = (en_w_or_r) ? in : out;


endmodule
