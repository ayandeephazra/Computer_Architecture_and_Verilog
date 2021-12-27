/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
// Separate version for the valid bit because of flash clear:

module memv (data_out, addr, data_in, write, clk, rst, createdump, file_id);
   output data_out;
   input [7:0] addr;
   input       data_in;
   input       write;
   input       clk;
   input       rst;
   input       createdump;
   input [4:0] file_id;

   reg         mem [0:255];

   integer     mcd;
   integer     i;

   assign      data_out = (write | rst)? 0 : mem[addr];

   always @(posedge clk) begin
      if (rst) begin
         for (i=0; i<256; i=i+1) begin
            mem[i] = 0; // in hardware this would be a special flash-clear wire!
         end
      end
      if (!rst && write) mem[addr] = data_in;
      if (!rst && createdump) begin
         case (file_id)
           0: mcd = $fopen("Icache_0_valid");
           8: mcd = $fopen("Dcache_0_valid");
           16: mcd = $fopen("Icache_1_valid");
           24: mcd = $fopen("Dcache_1_valid");
           default: $display("Unknown (v) file_id %d", file_id);
         endcase
         for (i=0; i<256; i=i+1) begin
            $fdisplay(mcd,"%2h %4h", i, mem[i]);
         end
         $fclose(mcd);
      end
   end
endmodule
// DUMMY LINE FOR REV CONTROL :0:
