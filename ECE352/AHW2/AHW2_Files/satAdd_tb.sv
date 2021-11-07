module satAdd_tb();

  reg error;				// error flag (set to keep track an error occurred)
  reg [15:0] A_op,B_op;		// stimulus for A[15:0] and B[15:0]
  wire [15:0] S;			// wire to connect to satSum for self-check

  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  satAdd iDUT(.A(A_op),.B(B_op),.satSum(S));
  
  initial begin
    error = 1'b0;		// innnocent till proven guilty
	
	/// Test case 1 ///
	A_op = 16'h7F65;	// large positive
	B_op = 16'hC321;	// substantial negative
	#5;
	if (S!==16'h4286) begin
	  $display("ERROR: addition of %h and %h should result in 0x4286 (no saturation)",A_op,B_op);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 1");

	/// Test case 2 ///
	A_op = 16'h7FE8;	// large positive
	B_op = 16'h0015;	// small positive, but not overflow
	#5;
	if (S!==16'h7FFD) begin
	  $display("ERROR: addition of %h and %h should result in 0x7FFD (no saturation)",A_op,B_op);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 2");

	/// Test case 3 ///
	A_op = 16'h7FE8;	// large positive
	B_op = 16'h0025;	// small positive, will overflow +
	#5;
	if (S!==16'h7FFF) begin
	  $display("ERROR: addition of %h and %h should result in 0x7FFF (+ saturation)",A_op,B_op);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 3");	  
	  
	/// Test case 4 ///
	A_op = 16'h800F;	// large negative
	B_op = 16'hFFFD;	// small negative, will not overflow
	#5;
	if (S!==16'h800C) begin
	  $display("ERROR: addition of %h and %h should result in 0x800C (no saturation)",A_op,B_op);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 4");	  

	/// Test case 5 ///
	A_op = 16'h800F;	// large negative
	B_op = 16'hFFED;	// small negative, will underflow -
	#5;
	if (S!==16'h8000) begin
	  $display("ERROR: addition of %h and %h should result in 0x8000 (- saturation)",A_op,B_op);
	  error = 1'b1;
	end else
	  $display("GOOD: passed test case 5");		  
	
	if (!error)
	  $display("YAHOO!! test passed");
	$stop();
  end
  
endmodule