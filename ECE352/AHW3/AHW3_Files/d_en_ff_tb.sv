module d_en_ff_tb();

  reg clk;				// clock
  reg D_stim;			// input stim to D input
  reg EN_stim;			// input stim to EN input
  reg CLR_stim;		    // input stim to CLRN input
  reg error;
  
  wire Q;				// Q output of en flop
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  d_en_ff iDUT(.clk(clk), .D(D_stim), .CLRN(CLR_stim), .EN(EN_stim), .Q(Q));
						

  initial begin
    error = 1'b0;		// innocent till proven guilty
    clk = 1'b0;
	D_stim = 1'b1;
	CLR_stim = 1'b1;
	EN_stim = 0;
	
    @(posedge clk);
	@(negedge clk);
	if (Q!==1'bx) begin
	  $display("ERR: at time = %t flop state should still be x",$time);
	  error = 1'b1;
	end
	
	CLR_stim = 1'b0;
	#1;
	if (Q!==1'b0) begin
	  $display("ERR: at time = %t flop state should be 0",$time);
	  error = 1'b1;
	end
	
	CLR_stim = 1'b1;
	@(negedge clk);
	if (Q!==1'b0) begin
	  $display("ERR: at time = %t flop state should maintain a 0",$time);
	  error = 1'b1;
	end	 
	
	EN_stim = 1'b1;
	@(negedge clk);
	if (Q!==1'b1) begin
	  $display("ERR: at time = %t flop state should become 1",$time);
	  error = 1'b1;
	end
	
	EN_stim = 1'b0;
	D_stim = 1'b0;
	@(negedge clk);
	if (Q!==1'b1) begin
	  $display("ERR: at time = %t flop state should maintain a 1",$time);
	  error = 1'b1;
	end	
	
	EN_stim = 1'b1;
	@(negedge clk);
	if (Q!==1'b0) begin
	  $display("ERR: at time = %t flop state should become 0",$time);
	  error = 1'b1;
	end
		

	if (!error)
	  $display("YAHOO! test passed for d_en_ff");
	$stop();
  end

  //////////////////////////////////////////////////////
  // clock starts low and toggles every 5 time units //
  ////////////////////////////////////////////////////
  always
    #5 clk = ~clk;

endmodule	
					