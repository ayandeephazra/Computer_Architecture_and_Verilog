module rcv_SM_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  logic clk, rst_n;		// clock and asynch active low reset
  logic rx_rdy;			// indicates a new byte ready from serial8

  
  ///////////////////////////////////////////////
  // Declare signals to monitor (DUT outputs) //
  /////////////////////////////////////////////
  logic cmd_rdy;		// ready signal rcv_SM sends when all 3-bytes ready
  logic EN_high;		// enables capture of high byte (first byte) of cmd[23:0]
  logic EN_mid;			// enables capture of mid byte (2nd byte) of cmd[23:0]
  
  logic error;			// Error flag for test
  
  ////////////////////////////////////////////////////
  // Instantiate rcv_SM to handle 3-byte reception //
  //////////////////////////////////////////////////
  rcv_SM iDUT(.clk(clk), .rst_n(rst_n), .rx_rdy(rx_rdy), .cmd_rdy(cmd_rdy),
         .EN_high(EN_high),.EN_mid(EN_mid));
		
  initial begin
    error = 0;			// innocent till proven guilty
    clk = 0;
	rst_n = 0;			// assert reset
	rx_rdy = 0;
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;			// deassert reset
	@(negedge clk);
	rx_rdy = 1;			// assert rx_rdy (1st byte ready)
	#1;					// wait 1 time unit
	if (EN_high!==1'b1) begin
	  $display("ERR: EN_high should be asserted at time %t",$time);
	  $display("     Recall...this is a mealy machine so outputs occur with inputs");
	  error = 1;
	end else $display("GOOD: EN_high asserted with rx_rdy");
	if (EN_mid!==1'b0) begin
	  $display("ERR: EN_mid should be low at time %t",$time);
	  $display("     High byte comes in first.");
	  error = 1;
	end else $display("GOOD: EN_mid was low with first byte received");
	
	@(negedge clk);
	rx_rdy = 0;
	@(negedge clk);
	if (EN_high | EN_mid) begin
	  $display("ERR: Neither EN_high or EN_mid should be asserted at time %t",$time);
	  error = 1;
	end else $display("GOOD: ENables not asserted");	
	
	@(negedge clk);
	rx_rdy = 1;		// indicate the byte has been received (2nd byte)
	#1;
	if (EN_high!==1'b0) begin
	  $display("ERR: EN_high should be low at time %t",$time);
	  error = 1;
	end else $display("GOOD: EN_high was low with 2nd byte received");	
	if (EN_mid!==1'b1) begin
	  $display("ERR: EN_mid should be asserted at time %t",$time);
	  $display("     This is 2nd byte received.");
	  error = 1;
	end else $display("GOOD: EN_mid asserted with 2nd rx_rdy");
	
	@(negedge clk);
	rx_rdy = 0;

	@(negedge clk);
	rx_rdy = 1;		// indicate the byte has been received (3rd byte)
	#1;
	if (EN_high!==1'b0) begin
	  $display("ERR: EN_high should be low at time %t",$time);
	  error = 1;
	end else $display("GOOD: EN_high was low with 2nd byte received");	
	if (EN_mid!==1'b0) begin
	  $display("ERR: EN_mid should be low at time %t",$time);
	  error = 1;
	end else $display("GOOD: EN_mid was low with first byte received");
	if (cmd_rdy!==1'b1) begin
	  $display("ERR: cmd_rdy should be high time %t",$time);
	  $display("     3rd byte is ready and this is a mealy machine");
	  error = 1;
	end else $display("GOOD: cmd_rdy was asserted with 3rd byte");
	
	@(negedge clk);
	rx_rdy = 0;	

	
	///////////////////////////////////////////////////////////////////
	// Now see if the start of a 2nd 16-bit transmission looks good //
	/////////////////////////////////////////////////////////////////
	@(negedge clk);
	rx_rdy = 1;			// assert transmit
	#1;					// wait 1 time unit
	if (EN_high!==1'b1) begin
	  $display("ERR: EN_high should be asserted at time %t",$time);
	  $display("     Recall...this is a mealy machine so outputs occur with inputs");
	  error = 1;
	end else $display("GOOD: EN_high asserted with rx_rdy");
	if (EN_mid!==1'b0) begin
	  $display("ERR: EN_mid should be low at time %t",$time);
	  $display("     High byte comes in first.");
	  error = 1;
	end else $display("GOOD: EN_mid was low with first byte received");
	
	
	if (!error)
      $display("YAHOO!! all tests for rcv_SM pass!");
    else
      $display("ERRORs exist...continue debugging");
	$stop();

  end

  
  always
    #5 clk = ~clk;
	
endmodule