/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
// YOU SHALL NOT EDIT THIS FILE. ANY CHANGES TO THIS FILE WILL
// RESULT IN ZERO FOR THIS PROBLEM.

module rf_hier (
                // Outputs
                read1data, read2data, 
                // Inputs
                read1regsel, read2regsel, writeregsel, writedata, write
                );
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;

   wire          clk, rst;
   wire          err;
  

   // Ignore err for now
   clkrst clk_generator(.clk(clk), .rst(rst), .err(err) );
   rf rf0(
          // Outputs
          .read1data                    (read1data[15:0]),
          .read2data                    (read2data[15:0]),
          .err                          (err),
          // Inputs
          .clk                          (clk),
          .rst                          (rst),
          .read1regsel                  (read1regsel[2:0]),
          .read2regsel                  (read2regsel[2:0]),
          .writeregsel                  (writeregsel[2:0]),
          .writedata                    (writedata[15:0]),
          .write                        (write));

endmodule
// DUMMY LINE FOR REV CONTROL :4:
