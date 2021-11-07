module UART_rx(clk , rst_n, RX, clr_rdy, rx_data, rdy);
input logic RX;	 		
output logic [7:0]rx_data;	
output logic rdy;	
input clk, rst_n; 		
input clr_rdy;			
	
logic [11:0]baud_cnt;		
logic [3:0]bit_cnt; 		
logic shift;			
logic start;			
logic shift_done = 1'b0;	
logic set_done;	
logic receive;			
logic [8:0]rx_shft_reg;		
		//
logic init;			
typedef enum reg [1:0] { IDLE, RSV} state_t;
state_t state, nxt_state;


//Shift receive
always_ff @(posedge clk)
 if(init)
	rx_shft_reg = 9'b000000000;   		
	// SHIFT WRITE
 else if(shift)begin
	shift = 0;
	rx_shft_reg  = {RX, rx_shft_reg[8:1]};
	shift_done = 1;				// END OF SIGNALLING
end

//REG ASSIGN
assign rx_data = rx_shft_reg[8:1];

// Baud Count HANDLING
always_ff@(posedge clk) 
 if(init)begin
   if(start)begin
	baud_cnt = 1032; // HALF OF MAX
   end
   else begin
	baud_cnt = 2064;
	receive = 1;
   end
 end
 else if(receive) begin
	receive = 0;
	baud_cnt = 2064; 
 end
 else if(baud_cnt == 0) begin
	baud_cnt = 2064;
	shift = 1;	
  end
 else
	baud_cnt = baud_cnt - 1; // DOWN COUNT


// Bit Count HANDLING
always_ff@(posedge clk) begin
if(init)
	bit_cnt = 0;  
else if(shift_done)begin
	shift_done = 0;
//Increment bit_cnt when a bit has been received
	bit_cnt = bit_cnt + 1; // 
end
end

// the Receiver State Machine 
always_ff @(posedge clk,negedge rst_n)
if (!rst_n)
	state <= IDLE;
else
	state <= nxt_state;

// RDY ASSINGMENT, ONLY DO WHEN SET DONE IS HIGH AND CLR_RDY IS HIGH
assign rdy = (set_done) ? ((clr_rdy) ? 0 :  1):  0;
always_comb begin
  	
case (state)

// IDLE DEAFULT
IDLE : if(RX == 0)begin 
	 set_done = 0;
	 init = 1; 
	 start = 1;
 	 nxt_state = RSV;
       end
	
// RECEIVE STATE
RSV :  begin
	start = 0;
	init = 0;
	if(bit_cnt == 10) begin
		set_done = 1;
		nxt_state = IDLE;
        end
end

default : nxt_state = IDLE;

endcase
end


endmodule
