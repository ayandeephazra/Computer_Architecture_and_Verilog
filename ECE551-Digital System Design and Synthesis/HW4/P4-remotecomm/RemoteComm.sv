module RemoteComm(clk, rst_n, RX, TX, cmd, send_cmd, cmd_sent, resp_rdy, resp);

input clk, rst_n;		// clock and active low reset
input RX;				// serial data input
input send_cmd;			// indicates to tranmit 24-bit command (cmd)
input [15:0] cmd;		// 16-bit command

output logic TX;				// serial data output
output logic cmd_sent;		// indicates transmission of command complete
output logic resp_rdy;		// indicates 8-bit response has been received
output logic [7:0] resp;		// 8-bit response from DUT

// internal sigs
logic [7:0] tx_data;		// 8-bit data to send to UART
wire tx_done;			// indicates 8-bit was sent over UART
wire rx_rdy;			// indicates 8-bit response is ready from UART

///////////////////////////////////////////////
// Registers needed...state machine control //
/////////////////////////////////////////////
					// used to buffer low byte of cmd
// below

///////////////////////////////
// state definitions for SM //
/////////////////////////////
logic sel_high, trmt, set_cmd_snt;
logic [7:0] ff_out;
typedef enum reg [1:0] {IDLE, ONE_BYTE, TWO_BYTE} state_t;
state_t state, nxt_state;

// RESETTING 
always_ff @(posedge clk or 
                 negedge rst_n)
    if (!rst_n) state <= IDLE;
    else state <= nxt_state;
	
///////////////////////////////////////////////
// Instantiate basic 8-bit UART transceiver //
/////////////////////////////////////////////
UART iUART(.clk(clk), .rst_n(rst_n), .RX(RX), .TX(TX), .tx_data(tx_data), .trmt(trmt),
           .tx_done(tx_done), .rx_data(resp), .rx_rdy(resp_rdy), .clr_rx_rdy(resp_rdy));

always_ff @ (posedge clk) begin
	if (send_cmd) begin
			ff_out <= cmd[7:0];
	end
	
end
// tx_data assignment mux
assign tx_data = (sel_high)? cmd[15:8]: ff_out;

always_comb begin
	// defaulting everything
	sel_high = 0;
	trmt = 0;
	set_cmd_snt = 0;
	nxt_state = state;
	case (state)
	ONE_BYTE: begin // first byte
		sel_high = 1; //0
		if(tx_done)
			nxt_state = TWO_BYTE;
	end
	TWO_BYTE: begin //2nd byte
		sel_high = 0; 
		trmt = 1;
		if(tx_done) begin
			set_cmd_snt = 1;
			nxt_state = IDLE;
		end
	end
	default: begin		// this is IDLE state
	trmt = 0;
		if (~send_cmd) begin
			nxt_state = IDLE;
		end
		else begin
			trmt = 1; 
			sel_high = 1;
			nxt_state = ONE_BYTE;
		end
	end

    endcase
end

// cmd_sent assignment with reset and SR flop functionality
always_ff @(posedge clk or negedge rst_n) begin

	if(!rst_n) cmd_sent <= 1'b0;
	// SR func
	else if(send_cmd & ~set_cmd_snt) cmd_sent <= send_cmd;
	else if(~send_cmd & set_cmd_snt) cmd_sent <= set_cmd_snt;
	
	end

endmodule	
