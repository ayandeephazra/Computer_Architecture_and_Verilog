
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
   reg [15:0] reg_array[7:0];
   reg [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
   reg err_tmp;

   always @ (rst) begin
	reg_array[0] = 16'h0000;
	reg_array[1] = 16'h0000;
	reg_array[2] = 16'h0000;
	reg_array[3] = 16'h0000;
	reg_array[4] = 16'h0000;
	reg_array[5] = 16'h0000;
	reg_array[6] = 16'h0000;
	reg_array[7] = 16'h0000;
   end

   always @ (clk) begin
	case (writeregsel) 
		3'b000: reg_array[0] = (clk & write)? writedata: reg_array[0];
		3'b001: reg_array[1] = (clk & write)? writedata: reg_array[1];
		3'b010: reg_array[2] = (clk & write)? writedata: reg_array[2];
		3'b011: reg_array[3] = (clk & write)? writedata: reg_array[3];
		3'b100: reg_array[4] = (clk & write)? writedata: reg_array[4];
		3'b101: reg_array[5] = (clk & write)? writedata: reg_array[5];
		3'b110: reg_array[6] = (clk & write)? writedata: reg_array[6];
		3'b111: reg_array[7] = (clk & write)? writedata: reg_array[7];
		default: ; //err_tmp = 1'b1; 
			
	endcase
   end
//assign err = err_tmp;

assign read1data = reg_array[read1regsel];

assign read2data = reg_array[read2regsel];


endmodule
// DUMMY LINE FOR REV CONTROL :1: