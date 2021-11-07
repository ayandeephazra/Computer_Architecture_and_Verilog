module SPI_mnrch_tb();
	logic clk, rst_n, MISO, wrt;
	logic [15:0] wt_data;
	logic MOSI, SS_n,  SCLK,  done, INT;
	logic [15:0] rd_data;

	SPI_mnrch iSPY(.clk, .rst_n, .SS_n, .SCLK, .MOSI, .MISO, .wrt, .wt_data, .done, .rd_data);
	SPI_iNEMO1 iSPI_NEMO(.SS_n,.SCLK,.MISO,.MOSI,.INT(INT));
	initial begin 
		clk = 0;
		//TEST ONE: Check to see if rd_data has the value 16'hhxx6A
		rst_n = 0;
		@(posedge clk);
		@(negedge clk);
		rst_n = 1;
		
		
		wt_data = 16'h8Fxx;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);

		if(rd_data !== 16'hxx6A) begin
			$display("Does not contain WHO AM I");
			$display(rd_data);
			$stop();
		end
		
		
		//TEST TWO: Check to see if Nemo_setup properly gets asserted 
		wt_data = 16'h0D02;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);
		@(posedge iSPI_NEMO.NEMO_setup);
		if(!iSPI_NEMO.NEMO_setup)begin 
			$display("NEMO_setup is not asserted");
			$stop();
		end

		
		//TEST THREE: Check to see if the first register that was read was yawL = 8d
		
		@(posedge INT);
		wt_data = 16'hA6xx;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);
		if(rd_data !== 16'hxx8d) begin
			$display("yawL Error: The yaw rate low from the gyro is not correct");
			$stop();
		end
		
		//TEST FOUR: Check to see if the first register that was read was yawH = 99
		wt_data = 16'hA7xx;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);
		if(rd_data !== 16'hxx99) begin
			$display("yawL Error: The yaw rate high from the gyro is not correct");
			$stop();
		end
		
		//TEST FOUR: Check to see if the first register that was read was yawL = 3d
		
		@(posedge INT);
		wt_data = 16'hA6xx;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);
		if(rd_data !== 16'hxx3d) begin
			$display("yawL Error: The yaw rate low from the gyro is not correct");
			$stop();
		end
		
		//TEST FIVE: Check to see if the first register that was read was yawH = cd
		wt_data = 16'hA7xx;
		@(posedge clk) wrt = 1;
		@(posedge clk) wrt = 0;
		@(posedge done);
		if(rd_data !== 16'hxxcd) begin
			$display("yawL Error: The yaw rate high from the gyro is not correct");
			$stop();
		end
		
		
		
		
		$display("YAHOOOO ALL TESTS PASSED");
		$stop();
	end
	
	always
	#5 clk = ~clk;

endmodule