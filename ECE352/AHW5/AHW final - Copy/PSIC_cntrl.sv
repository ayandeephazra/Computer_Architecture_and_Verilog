module PSIC_cntrl(
  input clk, rst_n,			// clock and active low asynch reset
  input cmd_rdy,			// new command ready from serial_comm
  input [2:0] cmd,			// only bits [18:16] of cmd[23:0] form the command
  output logic trmt,		// transmit corrected pressure reading via serial_comm
  output logic WE,			// Write Enable to NV_MEM (calibration coefficient memory)
  output logic [1:0] addr,	// address to NV_MEM, 00=zero, 01=Tco, 10=Offset, 11=Gain
  output logic selA2D,		// select A2D reading vs Temp register for datapath "A"
  output logic selCoeff,	// select A2D reading vs Temp register for datapath "B"
  output logic selMult,		// dst bus of datapath chooses Mult vs Add
  output logic enTmp,		// enable Temp register
  output logic strt_cnv,	// initiate A2D conversion
  output logic chnl,		// selects channel to convert 0=>PTAT, 1=>Pressure
  input cnv_cmplt			// A2D conversion complete
);
    
				 
	//// declare states ////
  	typedef enum reg[5:0] {IDLE=6'h01, HOLD=6'h02, S2=6'h03, S3=6'h04, S4=6'h05, S5=6'h06} state_t;
	
	/////////////////////////////
	// declare nxt_state type //
	///////////////////////////
	state_t nxt_state;
	
	///////////////////////////////
	// declare internal signals //
	/////////////////////////////
	logic [5:0] state;
	logic head;
	logic [1:0] body;
	
	///////////////////////////////////////////
	// Instantiate state flops (state7_reg) //
	/////////////////////////////////////////
	state6_reg iST(.clk(clk),.CLRN(rst_n),.nxt_state(nxt_state),.state(state));
	assign head=cmd[2];
	assign body=cmd[1:0];
	//////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		///////////////////////////////////////
		nxt_state = state_t'(state);
        trmt=1'b0;
		WE=1'b0;
		addr = 2'b00;
		selA2D=1'b0;
		selCoeff=0;
		selMult=0;
		enTmp=0;
		strt_cnv=0;
		chnl=0;
		case (state)
			IDLE: begin
				if(cmd_rdy && head==1) begin
					WE=1'b1;
					trmt=1'b1;
					if(body==2'b00)
						addr=2'b00;
                                        if(body==2'b10)
						addr=2'b10;	
					if(body==2'b11)
						addr=2'b11;
					if(body==2'b01)
						addr=2'b01;
					
				end
				else if(cmd_rdy && head==0) begin
					strt_cnv=1;
					chnl=0;
					nxt_state=HOLD;
				end
			end
			HOLD: begin
				if(cnv_cmplt) begin
					selA2D=1;
					selCoeff=1;
					enTmp=1;
					selMult=0;
					nxt_state = S2;
					addr=2'b00;
				end
			end
			S2: begin
				enTmp=1;
                                addr = 2'b01;
				strt_cnv = 1;
				chnl=1;
				selMult=1;
				nxt_state = S3;
				end
			S3: begin
				if(cnv_cmplt) begin
                                        selCoeff=0;
					enTmp=1;
					selMult=0;
					selA2D=1;
					nxt_tate = S4;
				end
			end
			S4: begin
                                selMult=0;
				addr=2'b10;
				enTmp=1;
				selCoeff=1;
				selA2D=0;
                                nxt_state=S5;
				
			end
			S5: begin
				selMult=1;
				trmt=1;
				nxt_state=IDLE;
				addr = 2'b11;
			end
		endcase
	end
		
endmodule	