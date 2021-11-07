module satMult_tb();

  reg error;				// error flag (set to keep track an error occurred)
  reg [15:0] coeff,Temp;	// stimulus representing coefficient and Temp register being multiplied
  wire [15:0] Prod;			// wire to connect to satProd for self-check

  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  satMult iDUT(.coeff(coeff),.Temp(Temp),.satProd(Prod));
  
  
  initial begin
    error = 1'b0;		// innnocent till proven guilty

	/// Test case 1 unity times positive ///
	coeff = 16'h4000;	// unity gain
	Temp = 16'h4567;	// positive
	#5;
	if (Prod!==16'h4567) begin
	  $display("ERROR: coeff was unity, times %h, should result in 0x4567 (no saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 1");
	  
	/// Test case 2 unity times negative ///
	coeff = 16'h4000;	// unity gain
	Temp = 16'hC321;	// substantial negative
	#5;
	if (Prod!==16'hC321) begin
	  $display("ERROR: coeff was unity, times %h, should result in 0xC321 (no saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 2");

	/// Test case 3 1.25 times positive ///
	coeff = 16'h5000;	// 1.25 gain
	Temp = 16'h4444;	// positive
	#5;
	if (Prod!==16'h5555) begin
	  $display("ERROR: coeff was 1.25, times %h, should result in 0x5555 (no saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 3");
	  
	/// Test case 4 1.25 times negative ///
	coeff = 16'h5000;	// 1.25 gain
	Temp = 16'hE000;	// -8192
	#5;
	if (Prod!==16'hD800) begin
	  $display("ERROR: coeff was 1.25, times %h, should result in 0xD800 (no saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 4");
	  
	/// Test case 5 positive overflow ///
	coeff = 16'h5000;	// 1.25 gain
	Temp = 16'h6668;	// positive
	#5;
	if (Prod!==16'h7FFF) begin
	  $display("ERROR: coeff was 1.25, times %h, should result in 0x7FFF (+ saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 5");
	
	/// Test case 6 negative overflow ///
	coeff = 16'h5000;	// 1.25 gain
	Temp = 16'h9998;	// negative
	#5;
	if (Prod!==16'h8000) begin
	  $display("ERROR: coeff was 1.25, times %h, should result in 0x8000 (- saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 6");	
	  
	/// Test case 7 negative gain no saturation ///
	coeff = 16'hC000;	// -1.0 gain
	Temp = 16'h6668;	// positive
	#5;
	if (Prod!==16'h9998) begin
	  $display("ERROR: coeff was -1.0, times %h, should result in 0x9998 (no saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 7");
	
	/// Test case 8 negative gain with saturation ///
	coeff = 16'hA000;	// -1.50 gain
	Temp = 16'h6668;	// positive
	#5;
	if (Prod!==16'h8000) begin
	  $display("ERROR: coeff was -1.50, times %h, should result in 0x8000 (- saturation)",Temp);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 8");	

	if (!error)
	  $display("YAHOO!! test passed");
	$stop();
  end
  
endmodule