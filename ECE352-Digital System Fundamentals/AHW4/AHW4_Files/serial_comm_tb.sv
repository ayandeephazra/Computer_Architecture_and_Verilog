module serial_comm_tb();

  /////////////////////////////////////////////////
  // Declare stimulus signals to DUT and MASTER //
  ///////////////////////////////////////////////
  reg clk,rst_n;
  reg [23:0] cmd;			// command/data sent by master
  reg [15:0] sensor_data;	// sensor result sent by slave
  reg send_cmd;				// initiate send of command/data
  reg send_sensor;			// initiate send of sensor data
  
  //////////////////////////////////////////////////////
  // Declare signals connected to outputs to monitor //
  ////////////////////////////////////////////////////
  wire [23:0] cmd_rcvd;
  wire [15:0] sensor_rcvd;
  wire cmd_rdy;
  wire sensor_rdy;
  wire TX_RX;				// serial data from master -> slave
  wire RX_TX;				// serial data from slave -> master
  
  reg error;				// Error flag for test

  
  // Instantiate master
  serial_mstr iMSTR(.clk(clk),.rst_n(rst_n),.sensor_rdy(sensor_rdy),
                    .sensor_data(sensor_rcvd),.cmd2send(cmd),.send_cmd(send_cmd),
					.RX(RX_TX),.TX(TX_RX));
		
  /// Instantiate DUT ///  
  serial_comm iDUT(.clk(clk),.rst_n(rst_n),.RX(TX_RX), .cmd(cmd_rcvd), .cmd_rdy(cmd_rdy),
                   .TX(RX_TX), .tx_data(sensor_data), .trmt(send_sensor));
	
  initial begin
    error = 0;			// innocent till proven guilty
    clk = 0;
	rst_n = 0;
	send_cmd = 0;
	send_sensor = 0;
	cmd = 24'h89ABCD;
	sensor_data = 16'h9669;
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;			// deassert reset
	
	//// send first 24-bit command ///
	@(negedge clk);
	send_cmd = 1;
	@(negedge clk);
	send_cmd = 0;
	
	//// send first 16-bit data from DUT ////
	repeat (300) @(negedge clk);
	send_sensor = 1;
	@(negedge clk);
	send_sensor = 0;
		
	//////////////////////////////////////////////
    // Even though 16-bit sensor data sent 2nd //
    // it will arrive first.	              //
	///////////////////////////////////////////
	while (!sensor_rdy) @(negedge clk);		
	if (sensor_rcvd!==16'h9669) begin
	  $display("ERR: sensor_rcvd not as expected");
	  error = 1;
	end else
	  $display("GOOD: data from sensor matched 0x9669");
	  
	///////////////////////////////
	// Now wait for command rdy //
	/////////////////////////////
	while (!cmd_rdy) @(negedge clk);
	if (cmd_rcvd!==24'h89ABCD) begin
	  $display("ERR: cmd_rcvd not as expected");
	  error = 1;
	end else
	  $display("GOOD: command received matched 0x89ABCD");

    if (!error)
	  $display("YAHOO!! all tests pass toplevel test");
	else
      $display("ERRORs exist...continue debugging");
	$stop();

  end
  
  always
    #5 clk = ~clk;
  
endmodule