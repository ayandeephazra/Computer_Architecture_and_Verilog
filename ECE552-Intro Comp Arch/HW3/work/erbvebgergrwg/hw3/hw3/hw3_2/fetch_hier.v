module fetch_hier();

	wire clk;
	wire rst;
	wire err;
	wire [15:0] instr;

    // clk module
    clkrst c0(.clk(clk), .rst(rst), .err(err));

	// Fetch unit
	fetch f0(.clk(clk), .rst(rst), .err(err), .instr(instr));

endmodule
