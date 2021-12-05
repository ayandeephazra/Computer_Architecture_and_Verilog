
module epc (clk, rst, en, in, out);
  
  input clk, rst;
  input en; 
  input [15:0] in;  
  output [15:0] out;

  wire [15:0] en_wr;

  // write only when enabled, else stall same value indefinitely

  dff iFF[15:0] (.q(out), .d(en_wr), .clk(clk), .rst(rst));
  assign en_wr = (en) ? in : out;


endmodule
