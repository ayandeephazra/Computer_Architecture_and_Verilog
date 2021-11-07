module datapath_tb();

  ///////////////////////////////
  // Declare stimulus signals //
  /////////////////////////////
  logic clk;					// system clock
  logic [15:0] a2d;				// represents data from A2D conversion
  logic [15:0] coeff;			// represents coefficient from NV_MEM
  logic selA2D;					// selects a2d data vs Temp for "A" side
  logic selCoeff;				// selects coeff data vs Temp for "B" side
  logic selMult;				// selects mult vs adder to drive dst
  logic enTmp;					// enables write to 16-bit Temp register

  ////////////////////////////////////////
  // Declare dst which monitors result //
  //////////////////////////////////////
  logic [15:0] dst;				// hooks to output for self-check purposes
  
  reg error;					// error flag in self-check

  /////////////////////////////////
  // Instantiate DUT (datapath) //
  ///////////////////////////////
  datapath iDUT(.clk(clk), .a2d(a2d), .coeff(coeff), .selA2D(selA2D),
                .selCoeff(selCoeff), .selMult(selMult), .enTmp(enTmp),
				.dst(dst));
				
  initial begin
    error = 0;		// innocent till proven guilty
    clk = 0;
	//// setup for: Temp <-- 0x1234 + 0x2345
	a2d = 16'h1234;
	coeff = 16'h2345;
	selA2D = 1;
	selCoeff = 1;
	selMult = 0;
	enTmp = 1;
    #2;							// wait 2 time units and check dst
	if (dst!==16'h3579) begin
	  $display("ERR: result on dst should be 0x3579");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test1");
	@(negedge clk);				// Temp will get assigned during intervening + edge clk
	
	//// setup for Temp <-- Temp + 0x3210
	coeff = 16'h3210;
	selA2D = 0;
	enTmp = 1;
    #2;							// wait 2 time units and check dst
	if (dst!==16'h6789) begin
	  $display("ERR: result on dst should be 0x6789");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test2");
    @(negedge clk);
    enTmp = 0;					// now don't write Temp for one clock
	@(negedge clk);				// If Temp wrote then next result will be wrong.

    //// setup for Temp <-- 0xF000 + Temp
    selA2D = 1;
    selCoeff = 0;
    enTmp = 1;
    a2d = 16'hF000;
    #2;							// wait 2 time units and check dst
 	if (dst!==16'h5789) begin
	  $display("ERR: result on dst should be 0x5789");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test3");
    @(negedge clk);
    	
    //// setup for dst <-- 0x5000*Temp
    selA2D = 0;
    selCoeff = 0;
    coeff = 16'h5000;
	selMult = 1;
    #2;							// wait 2 time units and check dst
 	if (dst!==16'h6D6B) begin
	  $display("ERR: result on dst should be 0x6D6B");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test4");
    @(negedge clk);	
	
    //// setup for dst <-- 0x5000*Temp (should saturate to 0x7FFF)
    coeff = 16'h5000;
	selMult = 1;
	enTmp = 0;					// don't write result to Temp
    #2;							// wait 2 time units and check dst
 	if (dst!==16'h7FFF) begin
	  $display("ERR: result on dst should be saturated to 0x7FFF");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test5");
    @(negedge clk);	

    //// setup for dst <-- 0xB000*Temp (should saturate to 0x8000)
    coeff = 16'hB000;
	selMult = 1;
	enTmp = 0;					// don't write result to Temp
    #2;							// wait 2 time units and check dst
 	if (dst!==16'h8000) begin
	  $display("ERR: result on dst should be saturated to 0x8000");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test6");
    @(negedge clk);

    //// setup for dst <-- 0x2345 + Temp (should saturate to 0x7FFF)
	selA2D = 1;
	selCoeff = 0;
	a2d = 16'h2345;
	selMult = 0;
	enTmp = 0;					// don't write result to Temp
    #2;							// wait 2 time units and check dst
 	if (dst!==16'h7fff) begin
	  $display("ERR: result on dst should be saturated to 0x7FFF");
	  $stop();
	  error = 1;
	end else $display("GOOD: Passed test7");
    @(negedge clk);
	
    if (!error)
	  $display("YAHOO! all tests passed!");
	else
	  $display("ERRORs occurred...continue debug");
	$stop();
  end
  
  always
    #5 clk = ~clk;
	

endmodule
