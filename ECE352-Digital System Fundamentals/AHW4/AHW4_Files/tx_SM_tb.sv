module tx_SM_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  logic clk, rst_n;		// clock and asynch active low reset
  logic trmt;			// initiate transmisison of 16-bit quantity
  logic byte_sent;		// would be from serial8 tx_done.
  
  ///////////////////////////////////////////////
  // Declare signals to monitor (DUT outputs) //
  /////////////////////////////////////////////
  logic send_byte;		// would go to serial8 trmt
  logic sel_low;		// selects low byte of tx_data
  
  logic error;			// Error flag for test
  
  ///////////////////////////////////////////////
  // Instantiate TX_SM to handle transmission //
  /////////////////////////////////////////////
  tx_SM iDUT(.clk(clk), .rst_n(rst_n), .trmt(trmt), .byte_sent(byte_sent),
        .sel_low(sel_low), .send_byte(send_byte));
		
  initial begin
    error = 0;			// innocent till proven guilty
    clk = 0;
	rst_n = 0;			// assert reset
	trmt = 0;
	byte_sent = 0;
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;			// deassert reset
	@(negedge clk);
	trmt = 1;			// assert transmit
	#1;					// wait 1 time unit
	if (send_byte!==1'b1) begin
	  $display("ERR: send_byte should be asserted at time %t",$time);
	  $display("     Recall...this is a mealy machine so outputs occur with inputs");
	  error = 1;
	end else $display("GOOD: send_byte asserted with trmt");
	if (sel_low!==1'b0) begin
	  $display("ERR: sel_low should be low at time %t",$time);
	  $display("     we send high byte first.");
	  error = 1;
	end else $display("GOOD: sel_low was low with first byte sent");
	
	@(negedge clk);
	trmt = 0;
	if (send_byte!==1'b0) begin
	  $display("ERR: send_byte should be not still be asserted at time %t",$time);
	  error = 1;
	end else $display("GOOD: send_byte asserted with trmt");	
	
	@(negedge clk);
	byte_sent = 1;		// indicate the byte has been sent
	#1;
	if (sel_low!==1'b1) begin
	  $display("ERR: sel_low should be asserted at time %t",$time);
	  $display("     Recall...this is a mealy machine so outputs occur with inputs");
	  error = 1;
	end else $display("GOOD: sel_low asserted with first byte_sent");	
	if (send_byte!==1'b1) begin
	  $display("ERR: send_byte should be asserted at time %t",$time);
	  $display("     Recall...this is a mealy machine so outputs occur with inputs");
	  error = 1;
	end else $display("GOOD: send_byte asserted for low byte transmission");
	
	@(negedge clk);
	byte_sent = 0;
	
	//////////////////////////////////////////////////////////////////////
	// Now finish off what serial8 completion of 2nd byte transmission //
	////////////////////////////////////////////////////////////////////
	repeat(2) @(negedge clk);
	byte_sent = 1;
	@(negedge clk);
	byte_sent = 0;
	@(negedge clk);
	
	///////////////////////////////////////////////////////////////////
	// Now see if the start of a 2nd 16-bit transmission looks good //
	/////////////////////////////////////////////////////////////////
	@(negedge clk);
	trmt = 1;			// assert transmit
	#1;					// wait 1 time unit
	if (send_byte!==1'b1) begin
	  $display("ERR: send_byte should be asserted at time %t",$time);
	  error = 1;
	end else $display("GOOD: send_byte asserted with trmt for 2nd transmisison");
	if (sel_low!==1'b0) begin
	  $display("ERR: sel_low should be low at time %t",$time);
	  $display("     we send high byte first.");
	  error = 1;
	end else $display("GOOD: sel_low was low with first byte of 2nd trans");
	
    if (!error)
      $display("YAHOO!! all tests for tx_SM pass!");
    else
      $display("ERRORs exist...continue debugging");
	$stop();

  end

  
  always
    #5 clk = ~clk;
	
endmodule