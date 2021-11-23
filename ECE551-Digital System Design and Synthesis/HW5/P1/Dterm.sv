module D_term(err_sat, err_vld, rst_n, clk, D_term);

        input [9:0] err_sat;
	input err_vld, rst_n, clk;
	logic signed [12:0] D_term;

	logic [9:0] mux1_out, mux2_out, D_diff, prev_err;
	reg [9:0] q1, q2;
	logic signed [6:0] saturated_D_diff;

	localparam P_COEFF_DTERM = 6'h0B;

	assign mux1_out = (err_vld)? err_sat[9:0]: q1;

	// FF 1
	always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
	q1 <= 10'h000;
	else
	q1 <= mux1_out;

	assign mux2_out = (err_vld)? q1: q2;

	// FF 2
	always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
	q2 <= 10'h000;
	else
	q2 <= mux2_out;

	assign prev_err = q2;

	//assign D_diff = err_sat - prev_err;
	assign D_diff = err_sat[9:0] - q2;

	// Saturation
	assign saturated_D_diff = (D_diff[9]==1)? ((D_diff[8:6]==3'b111)?D_diff[6:0]:7'h40) :
							  ((D_diff[8:6]==3'b000)?D_diff[6:0]:7'h3f) ;

							
							  
	// ERR VLD ASSERTION
	//assign D_term = (err_vld)?saturated_D_diff * $signed(P_COEFF_DTERM):D_term;
	assign D_term = saturated_D_diff * $signed(P_COEFF_DTERM);

endmodule