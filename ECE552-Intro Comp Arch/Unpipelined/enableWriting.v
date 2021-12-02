module enableWriting(wr_sel, wr_tmp, write);

  input [7:0] wr_tmp;
  input write;
  output [7:0] wr_sel;

//////////////////////////////////////////////////
  assign wr_sel[0] = wr_tmp[0] & write;
  assign wr_sel[1] = wr_tmp[1] & write;
  assign wr_sel[2] = wr_tmp[2] & write;
  assign wr_sel[3] = wr_tmp[3] & write;
  assign wr_sel[4] = wr_tmp[4] & write;
  assign wr_sel[5] = wr_tmp[5] & write;
  assign wr_sel[6] = wr_tmp[6] & write;
  assign wr_sel[7] = wr_tmp[7] & write;
endmodule