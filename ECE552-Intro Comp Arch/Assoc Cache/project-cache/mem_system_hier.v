/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system_hier(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump
   );
   
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;


   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 err;                    // From m0 of mem_system.v
   // End of automatics

   clkrst clkgen(.clk(clk),
                 .rst(rst),
                 .err(err) );
   // For now force to be data memory all the time
   // Does not matter until you hook this up into your final processor
   
   mem_system #(1) m0(/*AUTOINST*/
                      // Outputs
                      .DataOut          (DataOut[15:0]),
                      .Done             (Done),
                      .Stall            (Stall),
                      .CacheHit         (CacheHit),
                      .err              (err),
                      // Inputs
                      .Addr             (Addr[15:0]),
                      .DataIn           (DataIn[15:0]),
                      .Rd               (Rd),
                      .Wr               (Wr),
                      .createdump       (createdump),
                      .clk              (clk),
                      .rst              (rst));
   
endmodule // mem_system_hier
// DUMMY LINE FOR REV CONTROL :9:
