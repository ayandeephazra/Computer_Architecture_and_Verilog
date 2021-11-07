module RCA16_tb();

  reg [15:0] A_op,B_op;		// stimulus for A[15:0] and B[15:0]
  reg Cin;					// stimulus for Cin
  wire [15:0] S;			// wire to connect to sum for self-check
  wire Cout;				// outputs to monitor of type wire
  reg error,gold_Cout;
  reg [15:0] gold_sum;
  integer vectors;			// index used to apply random vectors
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  RCA16 iDUT(.A(A_op),.B(B_op),.Cin(Cin),.S(S),.Cout(Cout));
  
  initial begin
    error = 1'b0;	// innnocent till proven guilty
	A_op = 16'h5566;
	B_op = 16'hAA99;
	Cin = 1'b0;
    for (vectors=0; vectors<15; vectors++) begin
	  A_op = $random%17'h10000;		// produce 16-bit random number
	  B_op = $random%17'h10000;		// produce 16-bit random number
	  Cin = $random%2'b10;			// produce 1-bit random number
	  #5;
	  {gold_Cout,gold_sum} = A_op + B_op + Cin;
	  if (gold_Cout!==Cout) begin
	    error = 1'b1;
		$display("ERR: expected Cout=%b for A=%h, B=%h with Cin=%b",gold_Cout,A_op,B_op,Cin);
	  end 	
	  if (S!==gold_sum) begin
	    error = 1'b1;			// guilty
		$display("ERR: expected S=%h with A=%h, B=%h, Cin=%b",gold_sum,A_op,B_op,Cin);
      end
	end
	if (!error)
	  $display("YAHOO!! test passed");
	$stop();
  end
  
endmodule