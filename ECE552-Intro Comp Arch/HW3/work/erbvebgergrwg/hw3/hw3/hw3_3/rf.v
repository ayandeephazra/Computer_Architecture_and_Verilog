
/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

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


endmodule
// DUMMY LINE FOR REV CONTROL :1: