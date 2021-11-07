module serial_comm(clk,rst_n,RX,cmd,cmd_rdy,TX,tx_data,trmt);

  input clk,rst_n;		// clock and active low asynch reset
  input RX;				// serial data in
  output [23:0] cmd;	// bits[23:16] represent command, bits [15:0] represent data
  output cmd_rdy;		// pulses high when new cmd is ready
  output TX;			// serial data output
  input [15:0] tx_data;	// 16-bit data to transmit (corrected pressure reading)
  input trmt;			// high pulse initiates tranmission
  
  logic [7:0] tx_byte;		// byte to transmit, either tx_data[15:8] or tx_data[7:0]
  logic byte_sent;			// indicates byte has been sent by serial8
  logic sel_low;			// selects tx_data[7:0] to be sent (as opposed to tx_data[15:8])
  logic send_byte;			// initiates tranmission of byte by serial8
  logic [7:0] tx_low_byte; 	// buffer of low byte of tx_data
  logic [7:0] rx_byte;		// byte received, will form byte of cmd[23:8]
  logic rx_rdy;				// indicates byte received from serial8
  logic EN_high;			// asserted to capture rx_byte into cmd[23:16] register
  logic EN_mid;				// asserted to capture rx_byte into cmd[15:8] register
  
  

  //////////////////////////////////////////////////////////////////////////
  // Infer mux that selects low vs high byte of tx_data for transmission //
  // Should form tx_byte[7:0] which is declared above.                  //
  ///////////////////////////////////////////////////////////////////////
  //<-- you complete this code -->

  assign tx_byte = sel_low ? tx_low_byte : tx_data[15:8];

  //////////////////////////////////////////////////////////
  // Instantiate serial8 (byte based serial transceiver) //
  ////////////////////////////////////////////////////////
  serial8 iSRL(.clk(clk),.rst_n(rst_n),.rx_data(rx_byte),.rx_rdy(rx_rdy),.RX(RX),
               .tx_data(tx_byte),.trmt(send_byte),.tx_done(byte_sent),.TX(TX));
			   
  ////////////////////////////////////////////////////////////////////
  // Instantiate en_reg8 as high and mid bytes of received command //
  // Also form cmd[7:0] from last byte received by serial8.       //
  /////////////////////////////////////////////////////////////////
  //<-- you complete this code -->

  en_reg8 iEN_REG8_1[7:0](.clk(clk), .D(rx_byte), .EN(EN_high), .Q(cmd[23:16]));
  en_reg8 iEN_REG8_2[7:0](.clk(clk), .D(rx_byte), .EN(EN_mid), .Q(cmd[15:8]));
  assign cmd[7:0] = rx_byte[7:0];

  ///////////////////////////////////////////
  // Instantiate RCV_SM to handle receive //
  /////////////////////////////////////////
  rcv_SM iRCV_SM(.clk(clk), .rst_n(rst_n), .rx_rdy(rx_rdy), .cmd_rdy(cmd_rdy),
         .EN_high(EN_high),.EN_mid(EN_mid));
		 
  ////////////////////////////////////////////////////////////////////
  // Instantiate en_reg8 as holding buffer for low byte of tx_data //
  //////////////////////////////////////////////////////////////////
  //<-- you complete this code -->

  en_reg8 iEN_REG8_3[7:0](.clk(clk), .D(tx_data[7:0]), .EN(trmt), .Q(tx_low_byte));


		 
  ///////////////////////////////////////////////
  // Instantiate TX_SM to handle transmission //
  /////////////////////////////////////////////
  tx_SM iTX_SM(.clk(clk), .rst_n(rst_n), .trmt(trmt), .byte_sent(byte_sent),
        .sel_low(sel_low), .send_byte(send_byte));
  
endmodule

  
  
  
  
  
  

  
  
 