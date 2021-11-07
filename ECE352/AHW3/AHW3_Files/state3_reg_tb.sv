module state3_reg_tb();

  //// declare stimulus as type reg ////
  reg error;
  reg clk;
  reg rst_n;
  
  wire [2:0] nxt_state;
  
  wire [2:0] state;		// hook to state output of DUT
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  state3_reg iDUT(.clk(clk),.CLRN(rst_n),.nxt_state(nxt_state),.state(state));
  
  assign nxt_state = {state[1:0],1'b0};
  
  initial begin
    error = 1'b0;		// innocent till proven guilty
    clk = 1'b0;
	rst_n = 1'b1;
	
	@(negedge clk);
	if (state!==3'bxx0) begin
	  $display("ERR: at time = %t state should be mainly uninitialized",$time);
	  error = 1'b1;
	end
	#1 rst_n = 1'b0;
	#1;
	if (state!==3'b001) begin
	  $display("ERR: at time = %t state should be 3'b001",$time);
	  error = 1'b1;
	end
	
	@(negedge clk);
	rst_n = 1'b1;
	if (state!==3'b001) begin
	  $display("ERR: at time = %t state should be 3'b001",$time);
	  error = 1'b1;
	end	
	
	@(negedge clk);
	if (state!==3'b010) begin
	  $display("ERR: at time = %t state should be 3'b010",$time);
	  error = 1'b1;
	end	
	
	@(negedge clk);
	if (state!==3'b100) begin
	  $display("ERR: at time = %t state should be 3'b100",$time);
	  error = 1'b1;
	end	

	#1 rst_n = 1'b0;
	#1;
	if (state!==3'b001) begin
	  $display("ERR: at time = %t state should be 3'b001",$time);
	  error = 1'b1;
	end
	
    if (!error)
	  $display("YAHOO! test passed for state3_reg");
	$stop();
  end
  
  always
    #5 clk = ~clk;		// clock start at zero and toggles every 5 time units
  
endmodule