module UART_wrapper(clr_cmd_rdy, clk, rst_n, trmt, RX,resp,tx_done, TX, cmd_rdy,cmd);

	input logic clr_cmd_rdy, clk, rst_n, trmt, RX;
	input [7:0] resp;

	output logic tx_done, TX, cmd_rdy;
	output logic [15:0] cmd;

	// MUX SELECT SIGNAL FOR STORING OR NOT STORING A HIGH BYTE 
	logic storeByte, clr_rx_rdy;
	
	logic [7:0] rx_data;
	logic [7:0] mux_out, ff_out;
	logic rx_rdy;

	UART iUART(.clk(clk),.rst_n(rst_n),.RX(RX),.TX(TX),.rx_rdy(rx_rdy),.clr_rx_rdy(clr_rx_rdy),.rx_data(rx_data),.trmt(trmt),.tx_data(resp),.tx_done(tx_done));
	
	// UART Instantiation
	
	// SM related stuff here below

	typedef enum reg {IDLE, LOWBYTE} state_t;
	state_t state, nxt_state;

	// RESETTING 
	always_ff @(posedge clk or 
					 negedge rst_n)
		if (!rst_n) begin state <= IDLE;
						//cmd = 16'h0000;
					end
		else state <= nxt_state;

		/// STATE MACHINE CODE
	always_comb begin
	// defaulting SM outputs and control signsla
	storeByte = 0;
	clr_cmd_rdy = 1;
	tx_done = 0;
	TX = 0;

	nxt_state = IDLE;
	
	case(state)
	// LOW STATE
	LOWBYTE: begin if(rx_rdy) begin
				///transmission is completed here
				clr_cmd_rdy = 0;
				storeByte = 0;
				clr_rx_rdy = 1;
				nxt_state = IDLE;
				tx_done = 1;
			end
			end
			
	// HIGH STATE
	default: begin if(rx_rdy) begin
				//transmission is completed here
				tx_done = 1;
				storeByte = 1;
                // storebyte
				clr_rx_rdy = 1;
				nxt_state = LOWBYTE;
				storeByte = 0;
			end else begin
			// loopback
				tx_done = 0;
				//transmission is not completed here
				storeByte = 1;
				nxt_state = IDLE;
			end
			end
	endcase
	
	end
	
	// mux storing 
	assign mux_out = (~storeByte)? rx_data: ff_out;
	
	// ff
	always_ff @ (posedge clk)
		ff_out <= mux_out;
		
	// cmd reset assignment for multiple values during testing
	assign cmd = (!rst_n)? 16'h0000: {ff_out, rx_data};

	// SR flip flop functionality for cmd_rdy

    always_ff @(posedge clk or negedge rst_n) begin

		if(!rst_n) cmd_rdy <= 1'b0;
		else if(clr_cmd_rdy&clr_rx_rdy&TX) cmd_rdy <= 1'b1;
		else cmd_rdy <= 1'b0;
	
	end


endmodule