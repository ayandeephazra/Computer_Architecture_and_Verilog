module ss_A2D_SM(clk,rst_n,strt_cnv,smp_eq_8,gt,clr_dac,inc_dac,
                 clr_smp,inc_smp,accum,cnv_cmplt);

  input logic clk,rst_n;			// clock and asynch reset
  input logic strt_cnv;			// asserted to kick off a conversion
  input logic smp_eq_8;			// from datapath, tells when we have 8 samples
  input logic gt;					// gt signal, has to be double flopped
  
  output logic clr_dac;			// clear the input counter to the DAC
  output logic inc_dac;			// increment the counter to the DAC
  output logic clr_smp;			// clear the sample counter
  output logic inc_smp;			// increment the sample counter
  output logic accum;				// asserted to make accumulator accumulate sample
  output logic cnv_cmplt;			// indicates when the conversion is complete

  /////////////////////////////////////////////////////////////////
  // You fill in the SM implementation. I want to see the use   //
  // of enumerated type for state, and proper SM coding style. //
  //////////////////////////////////////////////////////////////
  

logic gt1, gt2;
// STATES OF SM
typedef enum reg [1:0] {IDLE, CNV, ACCUM} state_t;
state_t state, nxt_state;

// RESETTING 
always_ff @(posedge clk or 
                 negedge rst_n)
    if (!rst_n) state <= IDLE;
    else state <= nxt_state;

// DOUBLE FLOPPING FOR SAFETY
always_ff @(posedge clk) begin
    gt1 <= gt;
    gt2 <= gt1;
end
always_comb begin

// DEFAULTING ALL THE OUTPUTS FROM THE SM MODULE
clr_dac = 0;
clr_smp = 0;
accum = 0;
inc_dac = 0;
cnv_cmplt = 0;
inc_smp = 0;

// SETTING DEAFULT NXT STATE TO IDLE 
nxt_state = IDLE;
case (state)
// CNV STATE DOES THE CONVERSION WHILE gt2 is not asserted, otherwise moves to the ACCUM STATE
CNV: if (gt2) begin
        accum = 1;
        nxt_state = ACCUM;
     end else begin
	inc_dac = 1;
       nxt_state = CNV;
	end

// IN THIS STATE OF THE SM, IF WE HAVE 8 SAMPLES, WE ASSERT cnv_cmplt and set next state to IDLE
// ELSE WE KEEP converting after asserting inc_smp 
ACCUM: if (smp_eq_8) begin
        cnv_cmplt = 1;
        nxt_state = IDLE;
     end else begin
	//clr_dac = 1;
	inc_smp = 1;
       nxt_state = CNV;
	end

// DEFAULT OR IDLE STATE STARTS WHEN start_cnv is asserted and then it clears DAC and SMP.
// SETS nxt_state to CNV
default: if(strt_cnv) begin
	clr_dac = 1;
	clr_smp = 1;
	nxt_state = CNV;
	end
endcase
end

endmodule
  
					   