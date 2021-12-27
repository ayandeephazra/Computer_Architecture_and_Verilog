/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system_ref(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, 
   // Inputs
   Addr, DataIn, Rd, Wr, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        clk;
   input        rst;
   
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics

   reg [7:0]           mem[0:65535];
   reg                 loaded;
   integer             i;

   reg [15:0] DataOut;
   
   initial begin
      loaded = 0;
      for (i = 0; i < 65536; i=i+1) begin
         mem[i] = 0;
      end
   end

   always @(rst or loaded or Wr or Rd or DataIn) begin
      if (rst) begin
         if (!loaded) begin
            $readmemh("loadfile_all.img", mem);
            loaded = 1;
         end
      end else begin
         if (Wr) begin
            {mem[Addr], mem[Addr+8'd1]} = DataIn;
         end
         if (Rd) begin
            DataOut = {mem[Addr], mem[Addr+8'd1]};
         end
      end
   end // always @ (rst or loaded or Wr or Rd or DataIn)

   assign Done = (Rd|Wr);
   assign Stall = 1'b0;
   assign CacheHit = 1'b0;
      
endmodule // mem_system_ref
// DUMMY LINE FOR REV CONTROL :9:
