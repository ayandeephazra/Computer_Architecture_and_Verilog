/* $Author: karu $ */
/* $LastChangedDate: 2009-02-22 23:48:33 -0600 (Sun, 22 Feb 2009) $ */
/* $Rev: 20 $ */

module rf_bench(/*AUTOARG*/);
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [15:0]          read1data;              // From top of rf_hier.v
   wire [15:0]          read2data;              // From top of rf_hier.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [2:0]            read1regsel;            // To top of rf_hier.v
   reg [2:0]            read2regsel;            // To top of rf_hier.v
   reg                  write;                  // To top of rf_hier.v
   reg [15:0]           writedata;              // To top of rf_hier.v
   reg [2:0]            writeregsel;            // To top of rf_hier.v
   // End of automatics

   integer              cycle_count;

   wire                 clk;
   wire                 rst;

   reg                  fail;

   // Instantiate the module we want to verify

   rf_hier DUT(/*AUTOINST*/
               // Outputs
               .read1data               (read1data[15:0]),
               .read2data               (read2data[15:0]),
               // Inputs
               .read1regsel             (read1regsel[2:0]),
               .read2regsel             (read2regsel[2:0]),
               .writeregsel             (writeregsel[2:0]),
               .writedata               (writedata[15:0]),
               .write                   (write));

   // Pull out clk and rst from clkgenerator module
   assign               clk = DUT.clk_generator.clk;
   assign               rst = DUT.clk_generator.rst;

   // ref_rf is our reference register file
   reg [15:0]           ref_rf[7:0];
   reg [15:0]           ref_r1data;
   reg [15:0]           ref_r2data;

   initial begin
      cycle_count = 0;
      ref_rf[0] = 0;
      ref_rf[1] = 0;
      ref_rf[2] = 0;
      ref_rf[3] = 0;
      ref_rf[4] = 0;
      ref_rf[5] = 0;
      ref_rf[6] = 0;
      ref_rf[7] = 0;
      ref_r1data = 0;
      ref_r2data = 0;
      write = 0;
      fail = 0;
      $dumpvars;
   end

   always @ (posedge clk)begin

      // create 2 random read ports
      read1regsel = $random % 8;
      read2regsel = $random % 8;

      // create random data
      writedata = $random % 65536;

       // create a random write port
      writeregsel = $random % 8;

      // randomly choose whether to write or not
      write = $random % 2;

      // Read values from reference model
      ref_r1data = ref_rf[ read1regsel ];
      ref_r2data = ref_rf[ read2regsel ];

      // Reference model. We compare simulation against this
      // Write data into reference model

      if ((cycle_count >= 2) && write) begin
         ref_rf[ writeregsel ] = writedata;
      end

      // Delay for simulation to occur
      #10

      // Print log of what transpired
      $display("Cycle: %d R1: %d Sim: %d Exp: %d R2: %d Sim: %d Exp: %d W: %d data: %d enable: %d",
               cycle_count,
               read1regsel, read1data, ref_r1data,
               read2regsel, read2data, ref_r2data,
               writeregsel, writedata, write );
      if ( !rst && ( (ref_r1data !== read1data)
           ||  (ref_r2data !== read2data) ) ) begin
         $display("ERRORCHECK: Incorrect read data");
         fail = 1;
      end

      cycle_count = cycle_count + 1;
      if (cycle_count > 50) begin
		if (fail)
		  $display("TEST FAILED");
		else
		   $display("TEST PASSED");
		$finish;
      end

   end

endmodule // rf_bench
// DUMMY LINE FOR REV CONTROL :0:
