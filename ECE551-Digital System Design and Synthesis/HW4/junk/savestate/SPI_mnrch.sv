module SPI_mnrch(wrt, wt_data, done, rd_data, clk, rst_n,
SS_n, SCLK, MOSI, MISO);

input wrt, MISO;
input [15:0] wt_data;
input clk, rst_n;

output logic done, SS_n, SCLK, MOSI;
output [15:0] rd_data;

logic [4:0] bit_cntr;
logic SPI_transactions;
logic init; // bit cntr reg signal
logic shift; // bit cntr reg signal
logic ld_SCLK; //from the SM
logic [4:0] SCLK_div;
logic smpl; //sytatemaachine sample
logic MISO_smpl;
logic [15:0] shft_reg;
logic shft;
logic [15:0] wrt_data;
//sample MISO at negedge clk


/// SM specific signals
logic fall_imm, rise_imm;
logic done15;
logic set_done;

////////////////////////////
typedef enum reg [1:0] {IDLE, FP, SHIFTSAMPLE, BP} state_t;
state_t state, nxt_state;
////////////////////////////

always @ (posedge clk or negedge rst_n) begin
	
	if(!rst_n) begin
		state = IDLE;
	end

end

always @ (posedge clk) begin

	if(init) begin
		bit_cntr<=4'b0000;
	end
	else if (shift) begin
		bit_cntr<=bit_cntr+1;
	end

end

always @ (posedge clk) begin

	if(SCLK_div === 5'b01111) begin
		SCLK <= 1;
	end
	else begin
		SCLK <= 0;
	end
	if(ld_SCLK) begin
		SCLK_div <= 5'b10111;
	end

	else begin
		SCLK_div<=SCLK_div+1;
		// done and shift
	end
end

always @ (posedge clk) begin

	if(smpl) begin
		MISO_smpl <= MISO;
	end

end


always @ (posedge clk) begin

	if({init, shft} == 2'b1x) begin
		shft_reg <= wrt_data;
	end
	else if({init, shft} === 2'b01) begin
		shft_reg <= {shft_reg, MISO_smpl};
	end
	MOSI <= shft_reg;

end
// todo: LOWER PART OF PAGE 5 DATAPATH ELEMENT THE ONE THAT EMITS MOSI

always_comb begin
	ld_SCLK = 0;
	shift = 0;
	smpl = 0;
	init = 0;
	nxt_state = state;
	case(state)
			FP: begin
					if(fall_imm) begin
							nxt_state = SHIFTSAMPLE;
					end
					else if (~fall_imm) begin
							nxt_state = state;
					end
				end
				
			SHIFTSAMPLE: begin
							if(~done & fall_imm) begin
								shift = 1;
							end
							else if(~done & rise_imm) begin
								smpl = 1;
							end
							if(done) begin
								nxt_state = BP;
							end
					end
	
			BP: begin
						if(rise_imm) smpl = 1;
						else if (fall_imm) begin
						shift = 1;
						set_done = 1;
						ld_SCLK = 1;
						end
			end
			
			default: begin
						if(!rst_n) nxt_state = IDLE;
						else if (~wrt) ld_SCLK = 1;
						else if(wrt) begin init = 1; ld_SCLK = 1; nxt_state = FP; end
					end
					
					
	endcase
end
endmodule
