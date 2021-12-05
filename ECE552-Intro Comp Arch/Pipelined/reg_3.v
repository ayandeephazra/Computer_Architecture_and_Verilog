module reg_3 (clk, rst, en_w_or_r, in, out);
  
  input clk, rst;
  input en_w_or_r; 
  input [2:0] in;  
  output [2:0] out;

  wire [2:0] en_wr;

/////////////////////////////////////////////////////////////////////////////////////////
// 	   D-FF handling write/read operation using the en_wr( a.k.a enable write)     //
/////////////////////////////////////////////////////////////////////////////////////////
  dff iFF[2:0] (.q(out), .d(en_wr), .clk(clk), .rst(rst));
  assign en_wr = (en_w_or_r) ? in : out;


endmodule
