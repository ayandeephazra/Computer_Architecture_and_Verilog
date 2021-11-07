module PSIC_tb();

  ///////////////////////////////
  // Declare stimulus signals //
  /////////////////////////////
  logic clk,rst_n;				// clock and asynch active low reset
  logic [23:0] cmd2send;		// command/data to send to PSIC
  logic send_cmd;				// strobed high to initiate send
  logic error;					// flag to keep track of error in test
  
  ///////////////////////////////////////////////
  // Declare internal signals being monitored //
  /////////////////////////////////////////////
  logic sensor_rdy;				// data returned by sensor is ready
  logic [15:0] sensor_rcvd;		// data received from sensor
  
  /////////////////////////////
  // Other internal signals //
  ///////////////////////////
  logic RX,TX;					// serial lines to/fro sensor

  
  /////////////////////////////
  // Instantiate DUT (PSIC) //
  ///////////////////////////
  PSIC iDUT(.clk(clk),.rst_n(rst_n),.RX(RX), .TX(TX));
  
  
  ///////////////////////////////////////////////////////
  // Instantiate serial_mstr to drive commands to DUT //
  /////////////////////////////////////////////////////
  serial_mstr iMSTR(.clk(clk),.rst_n(rst_n),.sensor_rdy(sensor_rdy),
                    .sensor_data(sensor_rcvd),.cmd2send(cmd2send),.send_cmd(send_cmd),
					.RX(TX),.TX(RX));
					
  initial begin
    error = 0;					// innocent till proven guilty
    clk = 0;
	rst_n = 0;
	send_cmd = 0;
	cmd2send = 24'h07_4000;		// Write Gain to unity
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;					// deassert reset

	/////////////////////////////////////////////////////////
	// First test is write to NV_MEM looking for response //
	///////////////////////////////////////////////////////
	@(negedge clk);				// send first command (write Gain unity)
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout1
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for response from write to NV_MEM");
		error = 1;
		$stop();
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout1;
		$display("GOOD: Test1 passed, write to NV_MEM gave response");
	  end
	join
	
	///////////////////////////////////////////////////////////////
	// second test is read of pressure.  With no Tco, no Offset //
	// and unity gain the result should match raw A2D reading  //
	////////////////////////////////////////////////////////////
	cmd2send = 24'h00_0000;		// read pressure
	@(negedge clk);				// send second command (get sensor reading)
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout2
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for first corrected pressure");
		error = 1;
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout2;
		if (sensor_rcvd!==16'h3456) begin
		  $display("ERR: result should be PRESSURE[0] = 16'h3456 %h", sensor_rcvd);
		  error = 1;
		end else
		  $display("GOOD: Test2 passed, raw mode reading worked");
	  end
	join
	
	//////////////////////////////////////////////////////////////
	// Third test write Gain to 1.25, Then get another reading //
	////////////////////////////////////////////////////////////
	cmd2send = 24'h07_5000;		// write Gain = 1.25
	@(negedge clk);				// send third command (write Gain 1.25)
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	/// wait for response ///
	while (!sensor_rdy) @(negedge clk);
	cmd2send = 24'h00_5000;		// Get reading
	@(negedge clk);
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout3
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for second corrected pressure");
		error = 1;
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout3;
		if (sensor_rcvd!==16'h496B) begin
		  $display("ERR: result should be 1.25*PRESSURE[1] = 16'h496B %h",sensor_rcvd);
		  error = 1;
		end else
		  $display("GOOD: Test3 passed, 1.25 Gain worked");
	  end
	join
	
	////////////////////////////////////////////////////////////////////////////
	// Study method of above tests.  Use copy/paste/modify to add more tests //
	//////////////////////////////////////////////////////////////////////////
	
	cmd2send = 24'h06_000C;		// write Offset = 000C
	@(negedge clk);				// send third command (write offset)
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	/// wait for response ///
	while (!sensor_rdy) @(negedge clk);
	cmd2send = 24'h00_5000;		// Get reading
	@(negedge clk);
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout4
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for second corrected pressure");
		error = 1;
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout4;
		if (sensor_rcvd!==16'h6C25) begin
		  $display("ERR: result should be 1.25*PRESSURE[1] = 16'h496B %h",sensor_rcvd);
		  error = 1;
		end else
		  $display("GOOD: Test4 passed, offset worked");
	  end
	join
	
	// THIS TESTS multiplier OVERFLOW
	cmd2send = 24'h05_5000;		// write Tco = 1.25
	@(negedge clk);				// send third command (write offset)
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	/// wait for response ///
	while (!sensor_rdy) @(negedge clk);
	cmd2send = 24'h00_5000;		// Get reading
	@(negedge clk);
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout5
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for second corrected pressure");
		error = 1;
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout5;
		if (sensor_rcvd!==16'h7fff) begin
		  $display("ERR: result should be 1.25*PRESSURE[1] = 16'h496B %h",sensor_rcvd);
		  error = 1;
		end else
		  $display("GOOD: Test5 passed, offset worked");
	  end
	join
	
	// THIS TESTS NON-OVERFLOWING NON-ZERO OPERATION WITH CHANGED VALUES IN A2D
	/// wait for response ///
	while (!sensor_rdy) @(negedge clk);
	cmd2send = 24'h00_5000;		// Get reading
	@(negedge clk);
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	fork
	  begin: timeout6
	    repeat(10000) @(negedge clk);
		$display("ERR: timed out waiting for second corrected pressure");
		error = 1;
	  end
	  begin
	    while (!sensor_rdy) @(negedge clk);
        disable timeout6;
		if (sensor_rcvd!==16'h5F41) begin
		  $display("ERR: result should be 1.25*PRESSURE[1] = 16'h496B %h",sensor_rcvd);
		  error = 1;
		end else
		  $display("GOOD: Test6 passed, offset worked");
	  end
	join
	if (!error) begin
	  $display("YAHOO!! all tests passed!");
	end else
	  $display("ERRORS exist...continue debugging");
	  
	$stop();
  end
  
  always
    #5 clk = ~clk;
  
endmodule