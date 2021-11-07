module UART_tx(clk , rst_n, TX, trmt, tx_data, tx_done);

input logic clk, rst_n, trmt;
input [7:0] tx_data;
output logic TX, tx_done;
//////////////////////////
logic init, set_done;
logic [8:0]tx_shft_reg;
logic [11:0]baud_cnt;
logic [3:0]bit_cnt;
logic shift;
logic shift_done = 1'b0;
logic TX_tmp = 1'b0;
//////////////////////
typedef enum reg [1:0] { IDLE, TRSMT} state_t;
state_t state, nxt_state;

always_ff @(posedge clk,negedge rst_n)
if (!rst_n)
state <= IDLE;
else
state <= nxt_state;
//////////////
assign TX = TX_tmp;
always_ff @(posedge clk,negedge rst_n)
	assign tx_done = (set_done && (!init)) ? 1 : 0;

// REGISTER HANDLING AND REST
always_ff @(posedge clk,negedge rst_n)
if(!rst_n)
tx_shft_reg = 9'h1FF;
else if(init)
tx_shft_reg  = {tx_data, 1'b0};
else if(shift) begin	
	shift = 0;
	TX_tmp = tx_shft_reg[0];
	tx_shft_reg = {1'b1, tx_shft_reg[8:1]};
	shift_done = 1;
	end


// BIT HANDINLING
always_ff@(posedge clk) begin
if(init)
bit_cnt = 0;
else if(shift_done)begin
shift_done = 0;
bit_cnt = bit_cnt + 1;
end
end


// BAUD HANDLING
always_ff@(posedge clk) begin
if(init)
baud_cnt = 0;
else if(baud_cnt == 2064)begin
shift = 1;
baud_cnt = 0;
end else
baud_cnt = baud_cnt + 1;
end

always_comb begin
  init = 0;
	
case (state)

IDLE : if(trmt) begin 
	
 	nxt_state = TRSMT;
	init = 1;
	end

// TRANSMIT STATE
TRSMT : if(bit_cnt == 10) begin
	set_done = 1;
	init = 0;	

	nxt_state = IDLE;
	end
default : nxt_state = IDLE;
// DEFAULT FOR SAFETY
endcase
end

endmodule
