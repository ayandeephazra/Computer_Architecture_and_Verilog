module reg_16 (clk, rst, en_w_or_r, in, out);
  
  input clk, rst;
  input en_w_or_r; 
  input [15:0] in;  
  output [15:0] out;

  wire [15:0] en_wr;

/////////////////////////////////////////////////////////////////////////////////////////
// 	   D-FF handling write/read operation using the en_wr( a.k.a enable write)     //
/////////////////////////////////////////////////////////////////////////////////////////
  dff iFF[15:0] (.q(out), .d(en_wr), .clk(clk), .rst(rst));
  assign en_wr = (en_w_or_r) ? in : out;


endmodule
