module serial_mstr(clk,rst_n,sensor_rdy,sensor_data,cmd2send,send_cmd,RX,TX);

  input clk,rst_n;				// clock and active low reset
  input[23:0] cmd2send;			// data to transmitter
  input send_cmd;				// when asserted transmitter starts
  input RX;						// input serial data line
  output sensor_rdy;			// asserted when sensor_data is ready
  output [15:0] sensor_data;	// 16-bit received command
  output TX;					// output serial data line
  
  logic [7:0] tx_byte;		// byte to transmit, either cmd2send[23:16], cmd2send[15:8] or cmd2send[7:0]
  logic byte_sent;			// indicates byte has been sent by serial8
  logic sel_mid;			// selects cmd2snd[15:8] to be sent (as opposed to cmd2send[23:16])
  logic sel_low;			// selects cmd2snd[7:0] to be sent (as opposed to cmd2send[23:16])
  logic trmt_byte;			// initiates tranmission of byte by serial8
  logic [7:0] cmd_mid_byte;	// buffer of middle byte of cmd2send
  logic [7:0] cmd_low_byte;	// buffer of low byte of cmd2send
  logic [7:0] rx_byte;		// byte received, will form byte of sensor_data[15:8]
  logic rx_rdy;				// indicates byte received from serial8
  logic cap_high;			// asserted to capture high byte of sensor_data

  //////////////////////////////////////////////////////////////////////////
  // Infer mux that selects low vs high byte of tx_data for transmission //
  ////////////////////////////////////////////////////////////////////////
  assign tx_byte = (sel_mid) ? cmd_mid_byte : 
                   (sel_low) ? cmd_low_byte :
				   cmd2send[23:16];

  //////////////////////////
  // Instantiate serial8 //
  ////////////////////////
  serial8 iSRL(.clk(clk),.rst_n(rst_n),.rx_data(rx_byte),.rx_rdy(rx_rdy),.RX(RX),
               .tx_data(tx_byte),.trmt(trmt_byte),.tx_done(byte_sent),.TX(TX));
			   
  //////////////////////////////////////////////////////////////
  // Instantiate en_reg8 to capture high byte of sensor_data //
  ////////////////////////////////////////////////////////////
  en_reg8 iSNS_HIGH(.clk(clk), .EN(cap_high), .D(rx_byte), .Q(sensor_data[15:8]));
  assign sensor_data[7:0] = rx_byte;

  ///////////////////////////////////////////
  // Instantiate RCV_SM to handle receive //
  /////////////////////////////////////////
  mstr_rcv_SM iRCV_SM(.clk(clk), .rst_n(rst_n), .rx_rdy(rx_rdy), .sensor_rdy(sensor_rdy),
              .cap_high(cap_high));
		 
  ////////////////////////////////////////////////////////////////////////////
  // Instantiate en_reg8 as holding buffer for mid & low bytes of cmd2send //
  //////////////////////////////////////////////////////////////////////////
  en_reg8 iMID_CMD(.clk(clk), .EN(send_cmd), .D(cmd2send[15:8]), .Q(cmd_mid_byte));
  en_reg8 iLOW_CMD(.clk(clk), .EN(send_cmd), .D(cmd2send[7:0]), .Q(cmd_low_byte));  
		 
  ///////////////////////////////////////////////
  // Instantiate TX_SM to handle transmission //
  /////////////////////////////////////////////
  mstr_tx_SM iTX_SM(.clk(clk), .rst_n(rst_n), .send_cmd(send_cmd), .byte_sent(byte_sent),
             .sel_mid(sel_mid), .sel_low(sel_low), .trmt_byte(trmt_byte));
  
endmodule

///////////////////////////////////////////////////////
// mstr_rcv_SM & mstr_tx_SM inferred directly below //
/////////////////////////////////////////////////////

module mstr_tx_SM(clk,rst_n,send_cmd,byte_sent,sel_mid,sel_low,trmt_byte);

  input clk,rst_n;		// clock and active low asynch reset
  input send_cmd;		// asserted to initiate transmission of command
  input byte_sent;		// indicates tranmission of byte is complete
  output reg sel_mid;		// selects middle byte of cmd2send
  output reg sel_low;		// selects low byte of cmd2send
  output reg trmt_byte;		// kick off tranmission by serial8
  
  /// define custom state for state ///
  typedef enum reg[2:0] {IDLE=3'b001, MID_BYTE=3'b010, LOW_BYTE=3'b100} state_t;
  
  /// declare state flops and nxt_state ///
  state_t state, nxt_state;
  
  /// Infer state flops ///
  always @(posedge clk, negedge rst_n)
    if (!rst_n)
	  state <= IDLE;
	else
	  state <= nxt_state;
	  
  /// Infer state transition logic ///
  always_comb begin
    /// default outputs and nxt_state ////
	sel_mid = 0;
    sel_low = 0;
	trmt_byte = 0;
	nxt_state = state;
	
	case (state)
	  IDLE : begin
	    if (send_cmd) begin
		  trmt_byte = 1;
		  nxt_state = MID_BYTE;
		end
	  end
	  MID_BYTE : begin
	    if (byte_sent) begin
		  sel_mid = 1;
		  trmt_byte = 1;
		  nxt_state = LOW_BYTE;
		end
	  end
	  default : begin 	// same as LOW_BYTE
	    if (byte_sent) begin
		  sel_low = 1;
		  trmt_byte = 1;
		  nxt_state = IDLE;
		end
	  end
	endcase
  end
  
endmodule


module mstr_rcv_SM(
  input clk, rst_n,			// clock and active low asynch reset
  input rx_rdy,				// byte receieve from serial8
  output logic sensor_rdy,	// indicates sensor_data[15:0] has been received
  output logic cap_high		// capture high byte of sensor_data in register
);
    
	//// declare states ////
  	typedef enum reg[1:0] {HIGH=2'b01, LOW=2'b10} state_t;
	
	/////////////////////////////
	// declare nxt_state type //
	///////////////////////////
	state_t state, nxt_state;
	
    /// Infer state flops ///
    always @(posedge clk, negedge rst_n)
      if (!rst_n)
	    state <= HIGH;
	  else
	    state <= nxt_state;
	
	//////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		///////////////////////////////////////
		nxt_state = state;
        cap_high = 0;
		sensor_rdy = 0;
		
		case (state)
		  HIGH: begin
		    if (rx_rdy) begin
              cap_high = 1;
			  nxt_state = LOW;
		    end
		  end
		  default : begin		// same as LOW
		    if (rx_rdy) begin
			  nxt_state = HIGH;
			  sensor_rdy = 1;
			end
		  end
		endcase
	end
		
endmodule

