module serial8(clk,rst_n,rx_data,rx_rdy,RX,tx_data,trmt,tx_done,TX);

  input clk,rst_n;		// clock and active low reset
  output [7:0] rx_data;	// data byte received
  output rx_rdy;		// high pulse indicates data ready
  input RX;				// serial data input line
  input [7:0] tx_data;	// data byte to transmitter
  input trmt;			// high pulse tells transmitter to send
  output tx_done;		// high pulse indicates transmission complete
  output TX;			// serial data output line
  
  
  //////////////////////////////
  // Instantiate transmitter //
  ////////////////////////////
  manchester_TX iTX(.clk(clk),.rst_n(rst_n),.data(tx_data),
                    .trmt(trmt),.done(tx_done),.TX(TX));
  
  ///////////////////////////
  // Instantiate receiver //
  /////////////////////////
  manchester_RX iRX(.clk(clk),.rst_n(rst_n),.RX(RX),.data(rx_data),
                    .rdy(rx_rdy));
					
endmodule

module manchester_RX(clk,rst_n,RX,data,rdy);

	input clk;				// 50MHz clock
	input rst_n;			// active low asynch reset
	input RX;				// serial line in
	output reg [7:0] data;	// data we received
	output reg rdy;			// high for 1 clock when data ready

	typedef enum reg[4:0] {IDLE=5'b00001,START_L=5'b00010,
	               WAIT_FALL=5'b00100,WAIT_SHF=5'b01000,
				   WAIT_H=5'b10000} state_t;
				   
	state_t nxt_state;
	
	////////////////////////////////////////////////
	// Declare SM outputs (other than rdy) which //
	// is already declared as an output         //
	/////////////////////////////////////////////
	logic shft;
	logic clr_per;
	logic capture_per;
	logic clr_bit_cnt;
	logic inc_bit_cnt;

	///////////////////////////////////
	// Declare any internal signals //
	/////////////////////////////////
	logic per_eq_cap;
	logic [2:0] bit_cnt;
	logic sig_rise, sig_fall;
	logic sig_ff1,sig_ff2,sig_ff3;
	logic [8:0] period,captured_period;
	logic done8;
	logic [4:0] state;
	
	////////////////////////////////////////////////
	// Infer positive and negedge edge detectors //
	//////////////////////////////////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n) begin
	    sig_ff1 <= 1'b1;	// double flops
		sig_ff2 <= 1'b1;	// for meta-stability reasons
		sig_ff3 <= 1'b1;
	  end else begin
	    sig_ff1 <= RX;
		sig_ff2 <= sig_ff1;
		sig_ff3 <= sig_ff2;
	  end
	assign sig_rise = sig_ff2 & ~sig_ff3;
    assign sig_fall = ~sig_ff2 & sig_ff3;
	
	////////////////////////////
	// per_cnt & per_capture //
	//////////////////////////
	always_ff @(posedge clk)
	  if (clr_per)
	    period <= 8'h00;
	  else
	    period <= period + 8'h01;
		
	always_ff @(posedge clk)
	  if (capture_per)
	    captured_period <= period;
	
	//////////////////////////////////////////////////////
	// Infer comparison logic that produces per_eq_cap //
	////////////////////////////////////////////////////
	assign per_eq_cap = (period==captured_period) ? 1'b1 : 1'b0;
	
	
    //////////////////////////////
	// Infer RX shift register //
	////////////////////////////
	always_ff @(posedge clk)
	  if (shft)
	    data <= {data[6:0],sig_ff2};
	
	//////////////////////////////////////////////////////
	// Instantiate bit_cnt so we know when we are done //
	////////////////////////////////////////////////////
	always_ff @(posedge clk)
	  if (clr_bit_cnt)
	    bit_cnt <= 3'h0;
	  else if (inc_bit_cnt)
	    bit_cnt <= bit_cnt + 3'h1;
		
				  
	///////////////////////////////////
	// Infer logic to produce done8 //
	/////////////////////////////////
	assign done8 = &bit_cnt;
	
    ////////////////////////
	// Infer state flops //
	//////////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    state <= IDLE;
	  else
	    state <= nxt_state;
	
	always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		///////////////////////////////////////
		shft = 1'b0;
		clr_per = 1'b0;
		capture_per = 1'b0;
		clr_bit_cnt = 1'b0;
		inc_bit_cnt = 1'b0;
		rdy = 1'b0;
		nxt_state = state_t'(state);
		
		case (state)
		  IDLE: begin
		    clr_per = 1'b1;
		    if (sig_fall) begin
			  clr_bit_cnt = 1'b1;
			  nxt_state = START_L;
		    end
		  end
		  START_L : begin
		    if (sig_rise) begin
			  capture_per = 1'b1;
			  nxt_state = WAIT_FALL;
			end
		  end
		  WAIT_FALL : begin
		    if (sig_fall) begin
			  clr_per = 1'b1;
			  nxt_state = WAIT_SHF;
			end
		  end
		  WAIT_SHF : begin
		    if (per_eq_cap) begin
  			    shft = 1'b1;
				nxt_state = WAIT_H;
			end	
		  end
		  default : begin		// this is same as WAIT_H
		    if (sig_ff2) begin	// wait for RX rise if it hasn't already happened
				inc_bit_cnt = 1'b1;
				if (done8) begin
				  rdy = 1'b1;
				  nxt_state = IDLE;
				end else begin
				  nxt_state = WAIT_FALL;
				end
			end
		  end
		endcase
	end
		
endmodule

module manchester_TX(clk,rst_n,data,trmt,done,TX);

	input clk;			// 50MHz clock
	input rst_n;		// active low asynch reset
	input [7:0] data;	// data we are transmitting
	input trmt;			// tells it to tranmit
	output reg done;	// asserts when we are done
	output reg TX;		// the serial line output

	typedef enum reg[2:0] {IDLE,START_H,START_L,DATA_H,DATA_L} state_t;
	
	/////////////////////////////
	// declare state register //
	///////////////////////////
	state_t state, nxt_state;
	
	////////////////////////////////
	// declare internal regiters //
	//////////////////////////////
	logic [7:0] tx_reg;
	logic [7:0] period_cnt;
	logic [2:0] bit_cnt;
	
	/////////////////////////
	// declare SM outputs //
	///////////////////////
	logic shift;
	logic rst_per;
	logic clr_bit_cnt;
	logic inc_bit_cnt;
	logic set_TX,clr_TX;
	logic set_done;
	
	////////////////////////////////
	// declare timing parameters //
	//////////////////////////////
	localparam per_full = 8'h90;
	localparam per3_4 = 7'h6C;
	localparam per1_2 = 7'h48;
	localparam per1_4 = 6'h24;

	
	///////////////////////////
	// Infer state register //
	/////////////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    state <= IDLE;
	  else
	    state <= nxt_state;
		
	//////////////////////////////
	// Infer TX shift register //
	////////////////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    tx_reg = 8'hFF;
	  else if (trmt)
	    tx_reg <= data;
	  else if (shift)
	    tx_reg <= {tx_reg[6:0],1'b1};
		
	///////////////////////////
	// Infer period counter //
	/////////////////////////
	always_ff @(posedge clk)
	  if (rst_per)
	    period_cnt <= 8'h00;
	  else
	    period_cnt <= period_cnt + 8'h01;
		
	////////////////////////
	// Infer bit counter //
	//////////////////////
	always_ff @(posedge clk)
	  if (clr_bit_cnt)
	    bit_cnt <= 3'b000;
	  else if (inc_bit_cnt)
	    bit_cnt <= bit_cnt + 3'b001;

	////////////////////
	// Infer TX flop //
	//////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    TX <= 1'b1;
	  else if (set_TX)
	    TX <= 1'b1;
	  else if (clr_TX)
	    TX <= 1'b0;
		
	//////////////////////
	// Infer done flop //
	////////////////////
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    done <= 1'b0;
	  else if (set_done)
	    done <= 1'b1;
	  else if (trmt)
	    done <= 1'b0;

	//////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		///////////////////////////////////////
		shift = 1'b0;
		rst_per = 1'b0;
		clr_bit_cnt = 1'b0;
		inc_bit_cnt = 1'b0;
		set_TX = 1'b0;
		clr_TX = 1'b0;
		set_done = 1'b0;
		nxt_state = state;
		
		case (state)
		  IDLE: begin
		    if (trmt) begin
			  clr_TX = 1'b1;
			  rst_per = 1'b1;
			  nxt_state = START_H;
		    end
		  end
		  START_H : begin
		    if (period_cnt[6:0]==per1_2) begin
			  set_TX = 1'b1;
			  rst_per = 1'b1;
			  nxt_state = START_L;
			end
		  end
		  START_L : begin
		    if (period_cnt[6:0]==per1_2) begin
			  clr_TX = 1'b1;
			  rst_per = 1'b1;
			  clr_bit_cnt = 1'b1;
			  nxt_state = DATA_H;
			end
		  end
		  DATA_H : begin
		    if ((tx_reg[7] && (period_cnt[5:0]==per1_4)) ||
  			    (period_cnt[6:0]==per3_4)) begin
				set_TX = 1'b1;
				nxt_state = DATA_L;
			end	
		  end
		  default : begin		// this is same as DATA_L
		    if (period_cnt==per_full) begin
				inc_bit_cnt = 1'b1;
				rst_per = 1'b1;
				shift = 1'b1;
				if (bit_cnt==3'b111) begin
				  set_done = 1'b1;
				  nxt_state = IDLE;
				end else begin
				  clr_TX = 1'b1;
				  nxt_state = DATA_H;
				end
			end
		  end
		endcase
	end
		
endmodule	