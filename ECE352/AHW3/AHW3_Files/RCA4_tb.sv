module RCA4_tb();

  reg [9:0] stim;	// stimulus of type reg
  wire [3:0] S;
  wire Cout;		// outputs to monitor of type wire
  reg error,gold_Cout;
  reg [3:0] gold_sum;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  RCA4 iDUT(.A(stim[8:5]),.B(stim[4:1]),.Cin(stim[0]),.S(S),.Cout(Cout));
  
  initial begin
    error = 1'b0;	// innnocent till proven guilty
    for (stim=0; stim<10'h200; stim = stim + 10'h001) begin
	  #5;
	  {gold_Cout,gold_sum} = stim[8:5] + stim[4:1] + stim[0];
	  if (gold_Cout!==Cout) begin
	    error = 1'b1;
		$display("ERR: expected Cout=%b for A=%h, B=%h with Cin=%b",gold_Cout,stim[8:5],stim[4:1],stim[0]);
	  end 	
	  if (S!==gold_sum) begin
	    error = 1'b1;			// guilty
		$display("ERR: expected S=%h with A=%h, B=%h, Cin=%b",gold_sum,stim[8:5],stim[4:1],stim[0]);
      end
	end
	if (!error)
	  $display("YAHOO!! test passed");
	$stop();
  end
  
endmodule