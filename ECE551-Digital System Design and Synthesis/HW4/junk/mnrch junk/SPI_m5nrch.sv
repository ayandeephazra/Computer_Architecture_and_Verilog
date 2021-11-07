module SPI_mnrch(clk, rst_n, SS_n, SCLK, MOSI, MISO, wrt, wt_data, done, rd_data);

	input clk, rst_n, MISO, wrt;
	input logic [15:0] wt_data;
	output logic MOSI, SS_n,  SCLK,  done;
	output logic [15:0] rd_data;
	
	logic ld_SCLK, d_input, MISO_smpl, done15, fall, rise, init, shft, set_done, smpl;
	logic[4:0] SCLK_div;
	logic [3:0] bit_cntr;
	logic [15:0] shft_reg;
	
	//Synchronously set the SCLK_div based on the value of ld_SCLK. If asserted, we preset it. Else, we will increment it.
	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n)
			SCLK_div <= 5'hFF;
		else if(ld_SCLK) begin
			SCLK_div <= 5'b10111;
		end
		else
			SCLK_div <= SCLK_div  + 1;

	end
	//Assign the rise and fall depending on the value of SCLK_div
	assign rise = (SCLK_div == 5'b01111) ? 1 : 0;
	assign fall = (SCLK_div == 5'b11111) ? 1 : 0;
	
	//Assign SCLK the msb of SCLK_div
	assign SCLK = SCLK_div[4];
	assign rd_data = shft_reg;
	always_ff@(posedge clk) begin
		if(smpl)
			MISO_smpl <= MISO;
		else
			MISO_smpl <= MISO_smpl;
				
	end
	
	//Synchronously assign the shft_reg. If the shift value is asserted, we want to shift one place to the left, replacing the lsb with MISO_smpl
	always_ff@(posedge clk) begin
		if(init)
			shft_reg <= wt_data;
		else if (shft) 
			shft_reg <= {shft_reg[14:0], MISO_smpl};
		else
			shft_reg <= shft_reg;
				
	end
	
	//Give MOSI the msb of shft_reg
	assign MOSI = shft_reg[15];

	//FF for implementing the BIT counter. Preset the value to b0000. If shift is asserted, we increment the bit counter. Else, we hold the value. 
	always_ff@(posedge clk) begin
		if(init )
			bit_cntr <= 4'b0000;
		else if  ( shft )
			bit_cntr <= bit_cntr + 1;
		else
			bit_cntr <= bit_cntr;
	end
	assign done15 = &bit_cntr;
	
	
	// SR Flip flop to set both done and SS_n. Both signals behave very similarly.
	always_ff@(posedge clk, negedge rst_n) begin
		if(!rst_n )begin
			done <= 1'b0;
			SS_n <= 1'b1;
		end
		else if  ( init ) begin
			done <= 1'b0; 
			SS_n <= 1'b0;
		end
		else if (set_done)begin
			done <= 1'b1;
			SS_n <= 1'b1;
		end
	end
	
	
	
	
	//Created a 4-state state machine. The First state is the FRONT PORCH and the Last state is the BACK PORCH.
			/////////////////START STATE MACHINE CODE///////////////////////////////
	typedef enum reg[1:0] {IDLE,FIRST,SHIFT,LAST} state_t;
	state_t state, nxt_state;
	

	////////infer state flip flops/////////
	always_ff @(posedge clk, negedge rst_n)
		if(!rst_n)
			state <= IDLE;
		else
			state <= nxt_state;
	
	always_comb begin
		////////default outputs////////
		smpl = 0;
		shft = 0;
		ld_SCLK = 0;
		init = 0;
		set_done = 0;
		nxt_state = state;
		case(state)
			FIRST: if(fall) begin
				ld_SCLK = 0;
				shft = 1;
				init = 1;
				nxt_state = SHIFT;
			
			end else if (rise) begin
				ld_SCLK = 0;
				smpl = 1;
				init = 1;
				nxt_state = FIRST;
			end
			else

				ld_SCLK = 0;
			SHIFT: if(done15) begin
				ld_SCLK = 0;
				//shft = 1;
				nxt_state = LAST;
			end  else if (fall) begin
				shft = 1;
				ld_SCLK = 0;
				nxt_state = SHIFT;
			end else if (rise) begin
				smpl = 1;
				ld_SCLK = 0;
				nxt_state = SHIFT;

			end else begin
				nxt_state = SHIFT;
				ld_SCLK = 0;
			end	
			LAST: if(fall) begin
				set_done = 1;
				shft = 1;
				ld_SCLK = 1;
				nxt_state = IDLE;
			end  else if (rise) begin
				ld_SCLK = 0;
				smpl = 1;
				nxt_state = LAST;
			end else begin
				ld_SCLK = 0;
				nxt_state = LAST;
			end 
			/////////default = IDLE/////////
			default: if(wrt) begin
				shft = 0;
				ld_SCLK = 0;
				nxt_state = FIRST;
			end else if(!wrt) begin
			       ld_SCLK = 1;
		       		nxt_state = IDLE;
		 	end		
		endcase
	end

	
	
	
endmodule
