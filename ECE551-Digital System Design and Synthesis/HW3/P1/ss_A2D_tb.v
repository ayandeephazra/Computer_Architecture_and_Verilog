module ss_A2D_tb();

  reg clk,rst_n;
  reg strt_cnv;
  
  wire [9:0] result;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  ss_A2D iDUT(.clk(clk),.rst_n(rst_n),.strt_cnv(strt_cnv),
              .result(result),.cnv_cmplt(cnv_cmplt));
			  
  initial begin
    clk = 0;
	rst_n = 0;
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;
	@(negedge clk);
	strt_cnv = 1;
	@(negedge clk);
	strt_cnv = 0;
	@(posedge cnv_cmplt);		// wait for 1st conversion complete
    repeat(2)@(negedge clk);
	if  ((result<10'h0FF) || (result>10'h103))
	  begin
	    $display("ERROR: first conversion expected to be around 0x100 was %h",result);
		$stop;
	  end
	repeat(5)@(negedge clk);
	strt_cnv = 1;
	@(negedge clk)
	strt_cnv = 0;
	@(posedge cnv_cmplt);		// wait for 2nd conversion complete
    repeat(2)@(negedge clk);
	if ((result<10'h1FF) || (result>10'h203))
	  begin
	    $display("ERROR: first conversion expected to be around 0x200 was %h",result);
		$stop;
	  end
	repeat(5)@(negedge clk);
	$display("YAHOO! test passed");
	$stop();
  end
  
  always
    #5 clk = ~clk;

endmodule