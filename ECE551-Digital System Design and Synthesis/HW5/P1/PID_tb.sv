module PID_tb();

	

	logic signed [11:0] error;
	logic clk, rst_n, err_vld, moving;
	//input signed [9:0]err_sat;
    logic signed [9:0] frwrd;
	logic signed [10:0] lft_spd, rght_spd;
	
	logic signed [24:0] stim [0:1999];
	logic signed [21:0] resp [0:1999];
	
	logic signed [24:0] stim_i;
	logic signed [21:0] resp_i;
	logic signed [10:0] lft_spd_resp;
	logic signed [10:0] rght_spd_resp;
	
	logic anyerror;
	
	PID iPID(.error, .clk, .rst_n, .err_vld, .moving, .frwrd, .lft_spd, .rght_spd);
	

	
	reg [11:0] i;
	initial begin
	
		$readmemh("PID_stim.hex",stim, 0, 1999);
	    $readmemh("PID_resp.hex",resp, 0, 1999);
	
		clk = 0;
		anyerror = 0;
		
		for(i = 0; i<2000; i = i + 1) begin
		
		
			stim_i = stim[i];
			
			rst_n = stim_i[24];
			moving = stim_i[23];
			err_vld = stim_i[22];
			error = stim_i[21:10];
			frwrd = stim_i[9:0];
			
			@(posedge clk);
			#1;
			resp_i = resp[i];
			lft_spd_resp = resp_i[21:11];
			rght_spd_resp = resp_i[10:0];
			if(lft_spd===lft_spd_resp && rght_spd===rght_spd_resp)
				$display("SUCCESS - //// desired lft_spd:%h // derived lft_spd:%h // desired rght_spd:%h // derived rght_spd:%h ", lft_spd_resp, lft_spd, rght_spd_resp, rght_spd);
				
			else begin
				anyerror = 1;
				$display("FAIL //// desired lft_spd:%h // derived lft_spd:%h // desired rght_spd:%h // derived rght_spd:%h ", lft_spd_resp, lft_spd, rght_spd_resp, rght_spd);
				//$stop;
			end	
				
			

		end
		if(anyerror) $display(":( atleast one error in the 2000 vector set");
		else $display(":) all stim vector elements match resp vector elements - AYAN DEEP HAZRA");
		$stop;
	
	end
	always #5 clk = ~clk;
endmodule
