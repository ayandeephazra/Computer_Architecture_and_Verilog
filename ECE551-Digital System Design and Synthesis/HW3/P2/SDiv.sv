module SDiv(dividend, divisor, go, rdy, quotient, clk, rst_n);

input signed [15:0] dividend, divisor;
input logic go, clk, rst_n;
output logic rdy;
output logic [15:0] quotient;

// subMux is muxes before the Subractor
logic [15:0] dividend_modif, divisor_modif, subMux1_out, subMux2_out, subtractRes;
logic [15:0] ff1_out, ff2_out;
logic init, negate_res;
logic [1:0] logicState;

// TEMPORARY TILL SM IS DEFINED

always_ff @ (posedge clk) begin
	assign dividend_modif = (dividend[15])? -dividend: dividend;
	assign divisor_modif = (divisor[15])? -divisor: divisor;
end

always_ff @(posedge clk) begin
	assign subMux1_out = (init)? dividend_modif: subtractRes;
	ff1_out <= subMux1_out;
end

always_ff @(posedge clk) begin 

	assign subMux2_out = (init)? divisor_modif: ff2_out;
	ff2_out <= subMux2_out;
	assign subtractRes = ff1_out - ff2_out;
end
// subtraction module


////////////////////////////////////////////////////////////////////////////////////////

logic SM_MuxIn, ff3_out, leftMux;


always_ff @(posedge clk) begin
assign SM_MuxIn = dividend[15] ^ divisor[15];
assign leftMux = (init)? SM_MuxIn: ff3_out;
ff3_out <= leftMux;
end
// TO THE STATE MACHINE
assign negate_res = ff3_out;
////////////////////////////////////////////////////////////////////////////////////////

typedef enum reg [1:0] {IDLE, DOING, DONE} state_t;
state_t state, nxt_state;
// RESETTING 
always_ff @(posedge clk or 
                 negedge rst_n)
    if (!rst_n) state <= IDLE;
    else state <= nxt_state;

always_ff @ (posedge clk) begin
	
end
always_comb begin
rdy = 0;
init = 0;
nxt_state = IDLE;
//assign quotient = 16'h0000;
case (state)
	DOING: begin
		
		if (~subtractRes[15]) begin
		go = 0;
		logicState = 2'b01;
		nxt_state = DOING;
		end else if (|subtractRes===0)begin
			
			if ( negate_res ) begin
				rdy = 1;
				init = 0;
				logicState = 2'b10;
				nxt_state = DONE;
			end else begin
				rdy = 1;
				init = 0;
				logicState = 2'b11;
				nxt_state = DONE;
			end 
			
		end else if (negate_res &subtractRes[15]) begin
			logicState = 2'b10;      
			rdy = 1;		
			init = 0;
			nxt_state = IDLE;
		end else if (negate_res & !	subtractRes[15]) begin
			logicState = 2'b11;
			rdy = 1;
			init = 0;
			nxt_state = IDLE;
		end	
		end

	DONE:  	begin
			init = 1;
			rdy = 1;
			go = 0;
			nxt_state = IDLE;
			logicState = 2'b00;
			end
	default: begin
			logicState = 2'b00;
			if (go) begin
			
			rst_n = 1;
			logicState = 2'b00;
			go = 1;
			init = 1;
			
			nxt_state = DOING;
			end 
		end
		//else begin
		//init = 0;
		//rdy = 0;
		//nxt_state = IDLE;
		//end
	
endcase
end
////////////////////////////////////////////////////////////////////////////////////////
logic [15:0] mux4_1_out;

// 4 to 1 MUX LOGIC
assign mux4_1_out = (logicState[1])? {(logicState[0]? quotient: -quotient)}: {logicState[0]? quotient + 1 : 16'h0000};

always_ff @(posedge clk) begin

quotient <= mux4_1_out;
end
endmodule