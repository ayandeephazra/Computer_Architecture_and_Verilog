module seqdec_78_bench;
   reg Inp;
   wire Clk;
   wire Reset;
   wire Out;
   reg [127:0] sequenc;
   integer    k;
   reg [7:0]  seq;
   reg [7:0]  seqp1;

   wire err;
   assign err = 1'b0;

   seqdec_78 DUT (.Inp(Inp),.Clk(Clk),.Reset(Reset),.Out(Out));
   clkrst my_ckrst ( .clk(Clk), .rst(Reset), .err(err));

   always@(posedge Clk)
     begin
	if (Reset == 1'b1) 
	  begin
	     Inp = 1'b0;
	     k = 0;
	     sequenc = 128'h0026_A352_F545_9793_4578_26A5_2937_82AB;    // Sequence detection is for 26, 52, 45, 93, 78
	     seq = 8'h00;
	     seqp1 = 8'h00;
   
	  end
	else
	  begin
	     Inp = sequenc[127-k];
	     k = k + 1;
	     seq[7:1] <= seq[6:0];
	     seq[0] <= Inp;
	     seqp1 <= seq;
	     
	     if (k == 128) $finish;
	     
	  end
     end


   always@(negedge Clk)
     begin
	if ((Out !== 1'b1) && (seqp1 === 8'h78))
	  $display("ERRORCHECK :: Out not going to 1 as expected");
	if ((Out === 1'b1) && (seqp1 !== 8'h78))
	  $display("ERRORCHECK :: Out going to 1 unnexpected");
     end
endmodule
