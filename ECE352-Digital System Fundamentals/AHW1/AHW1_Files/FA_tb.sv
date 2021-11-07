module FA_tb();

  reg [3:0] stim;	// stimulus of type reg
  wire S,Cout;		// outputs to monitor of type wire
  reg error,real_sum;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  FA iDUT(.A(stim[2]),.B(stim[1]),.Cin(stim[0]),.S(S),.Cout(Cout));
  
  initial begin
    error = 1'b0;	// innnocent till proven guilty
    for (stim=0; stim<4'b1000; stim = stim + 4'b0001) begin
	  #5;
	  real_sum = ^stim[2:0];
	  if ((stim[2] && stim[1]) || (stim[2] && stim[0]) || (stim[1] && stim[0])) begin
	    if (Cout!==1'b1) begin
		  error = 1'b1;			// guilty
		  $display("ERR: Cout should be 1 with A=%b, B=%b, Cin=%b",stim[2],stim[1],stim[0]);
		end
	  end else begin
	    if (Cout!==1'b0) begin
		  error = 1'b1;			// guilty
		  $display("ERR: Cout should be 0 with A=%b, B=%b, Cin=%b",stim[2],stim[1],stim[0]);
		end	
      end		
	  if (S!==real_sum) begin
	    error = 1'b1;			// guilty
		$display("ERR: Sum should be %b with A=%b, B=%b, Cin=%b",real_sum,stim[2],stim[1],stim[0]);
      end
	end
	if (!error)
	  $display("YAHOO!! test passed");
	$stop();
  end
  
endmodule