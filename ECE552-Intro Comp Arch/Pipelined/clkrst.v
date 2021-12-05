module clkrst (clk, rst, err);

    output clk;
    output rst;
    input  err;

    reg clk;
    reg rst;
    integer cycle_count;

    initial begin
      $dumpvars;
      cycle_count = 0;
      rst = 1;
      clk = 1;
      #201 rst = 0; // delay until slightly after two clock periods
    end

    always #50 begin   // delay 1/2 clock period each time thru loop
      clk = ~clk;
      if (clk & err) begin
        $display("Error signal asserted");
        $stop;
      end
    end
    always @(posedge clk) begin
    	cycle_count = cycle_count + 1;
	if (cycle_count > 100000) begin
		$display("hmm....more than 100000 cycles of simulation...error?\n");
		$finish;
	end
    end


endmodule
// DUMMY LINE FOR REV CONTROL :0: