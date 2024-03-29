module rf (read1data, read2data,clk, rst, read1regsel, read2regsel, writeregsel, writedata, write);

  input clk, rst;
  input [15:0] writedata;
  input [2:0] read1regsel;
  input [2:0] read2regsel;
  input [2:0] writeregsel;
  input write;
  output [15:0] read1data;
  output [15:0] read2data;

  wire [7:0] wr_sel;
  wire [7:0] wr_tmp;
  wire [15:0] rd_0, rd_1, rd_2, rd_3, rd_4, rd_5, rd_6, rd_7;
  
  // decoding logic

  wire [2:0] S;
  wire [7:0] out;
  assign S = writeregsel;
  
  assign out[0] = (~S[2]) & (~S[1]) & (~S[0]);
  assign out[1] = (~S[2]) & (~S[1]) &  S[0];
  assign out[2] = (~S[2]) &  S[1] & (~S[0]);
  assign out[3] = (~S[2]) &  S[1] &  S[0];
  assign out[4] =  S[2] & (~S[1]) & (~S[0]);
  assign out[5] =  S[2] & (~S[1]) &  S[0];
  assign out[6] =  S[2] &  S[1] & (~S[0]);
  assign out[7] =  S[2] &  S[1] &  S[0];
  assign wr_tmp = out;


//////////////////////////////////////////////////
// 	  	readdata                        //
//////////////////////////////////////////////////
  mux8_1 iMUX_1[15:0] (.A(rd_0), .B(rd_1), .C(rd_2), .D(rd_3), .E(rd_4), .F(rd_5), .G(rd_6), .H(rd_7), .S(read1regsel), .out(read1data));
  mux8_1 iMUX_2[15:0] (.A(rd_0), .B(rd_1), .C(rd_2), .D(rd_3), .E(rd_4), .F(rd_5), .G(rd_6), .H(rd_7), .S(read2regsel), .out(read2data));
 

// write select handling

  enableWriting iEW(.wr_sel(wr_sel), .wr_tmp(wr_tmp), .write(write));

//////////////////////////////////////////////////
// 	  	register declaration            //
//////////////////////////////////////////////////
  reg_16 iREG16_1 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[0]), .in(writedata[15:0]), .out(rd_0[15:0]));
  reg_16 iREG16_2 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[1]), .in(writedata[15:0]), .out(rd_1[15:0]));
  reg_16 iREG16_3 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[2]), .in(writedata[15:0]), .out(rd_2[15:0]));
  reg_16 iREG16_4 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[3]), .in(writedata[15:0]), .out(rd_3[15:0]));
  reg_16 iREG16_5 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[4]), .in(writedata[15:0]), .out(rd_4[15:0]));
  reg_16 iREG16_6 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[5]), .in(writedata[15:0]), .out(rd_5[15:0]));
  reg_16 iREG16_7 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[6]), .in(writedata[15:0]), .out(rd_6[15:0]));
  reg_16 iREG16_8 (.clk(clk), .rst(rst), .en_w_or_r(wr_sel[7]), .in(writedata[15:0]), .out(rd_7[15:0]));

/*
 // your code
   reg [15:0] regs_array[7:0];
   reg err_r;
   wire [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
   wire [15:0] out0, out1, out2, out3, out4, out5, out6, out7;

   dff R0 [15:0] (.d(in0), .q(out0), .clk({16{clk}}), .rst({16{rst}}));
    dff R1 [15:0] (.d(in1), .q(out1), .clk({16{clk}}), .rst({16{rst}}));
    dff R2 [15:0] (.d(in2), .q(out2), .clk({16{clk}}), .rst({16{rst}}));
    dff R3 [15:0] (.d(in3), .q(out3), .clk({16{clk}}), .rst({16{rst}}));
    dff R4 [15:0] (.d(in4), .q(out4), .clk({16{clk}}), .rst({16{rst}}));
     dff R5 [15:0] (.d(in5), .q(out5), .clk({16{clk}}), .rst({16{rst}}));
     dff R6 [15:0] (.d(in6), .q(out6), .clk({16{clk}}), .rst({16{rst}}));
    dff R7 [15:0] (.d(in7), .q(out7), .clk({16{clk}}), .rst({16{rst}}));

   assign in0 = (writeregsel === 3'b000 & clk & write)? writedata: {(rst)?16'h0000:in0};
   assign in1 = (writeregsel === 3'b001 & clk & write)? writedata: {(rst)?16'h0000:in1};
   assign in2 = (writeregsel === 3'b010 & clk & write)? writedata: {(rst)?16'h0000:in2};
   assign in3 = (writeregsel === 3'b011 & clk & write)? writedata: {(rst)?16'h0000:in3};
   assign in4 = (writeregsel === 3'b100 & clk & write)? writedata: {(rst)?16'h0000:in4};
   assign in5 = (writeregsel === 3'b101 & clk & write)? writedata: {(rst)?16'h0000:in5};
   assign in6 = (writeregsel === 3'b110 & clk & write)? writedata: {(rst)?16'h0000:in6};
   assign in7 = (writeregsel === 3'b111 & clk & write)? writedata: {(rst)?16'h0000:in7};


   assign read1data = (read1regsel===3'b000)? out0: {(read1regsel===3'b001)? out1: {(read1regsel===3'b010)? out2: {(read1regsel===3'b011)? out3: {(read1regsel===3'b100)? out4: {(read1regsel===3'b101)? out5: {(read1regsel===3'b110)? out6: {(read1regsel===3'b111)? out7: 16'hzzzz}}}}}}};
   assign read2data = (read2regsel===3'b000)? out0: {(read2regsel===3'b001)? out1: {(read2regsel===3'b010)? out2: {(read2regsel===3'b011)? out3: {(read2regsel===3'b100)? out4: {(read2regsel===3'b101)? out5: {(read2regsel===3'b110)? out6: {(read2regsel===3'b111)? out7: 16'hzzzz}}}}}}};
*/


endmodule
