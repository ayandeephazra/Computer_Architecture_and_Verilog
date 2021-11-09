module fetch (clk, rst, err, instr);

	input clk;
	input rst;
	output err;
	output [15:0] instr;

	// Your Code goes here
	reg [15:0] pc;
	reg [15:0] A,B;
	
	wire[15:0] S;
	wire Cout;
////////////////////////////////
	memory2c iMEM(.data_out(instr), .data_in(16'h0000), .addr(pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
	fulladder16 iFULLADDER(.A(A),.B(B),.S(S),.Cout(Cout));
	
	always @ (clk) begin
		 A = (clk)?pc:A;
		 B = (clk)?16'h0002:B;
             
	end

	always @ (clk, rst)  begin
		assign pc = (rst)? 16'h0000: S;
	end

endmodule
