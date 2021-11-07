module ss_A2D_datapath(clk,clr_dac,inc_dac,clr_smp,inc_smp,accum,gt,
                       result,smp_eq_8);

  input clk;			// clock, reset not required
  input clr_dac;		// clears the couter that is input to the DAC
  input inc_dac;		// causes counter to DAC to increment
  input clr_smp;		// clear the sample counter (8 samples averaged)
  input inc_smp;		// causes sample counter to increment
  input accum;			// asserted by SM when sample should be accumulated
  
  output gt;			// greater than signal from comparator (asynch to clk)
  output [9:0] result;	// 10-bit result (average of 8 samples)
  output smp_eq_8;		// when asserted we have accumulated 8 samples
  
  reg [9:0] DAC_counter;	// provides input to 10-bit DAC
  reg [2:0] smp_counter;	// sample counter
  reg [12:0] accumulator;	// accumulator to accumulate 8 10-bit samples
  
  reg [9:0]analog_vals[0:15];	// this array will store analog vals
  reg [3:0]analog_ptr;			// this will point a current active analog value
  
  /////////////////////////////////////////////
  // Following counter feed into the 10-bit //
  // DAC. Does not need a asynch reset     //
  // because SM will clear using clr_dac  //
  /////////////////////////////////////////
  always @(posedge clk)
    if (clr_dac)
	  DAC_counter <= 10'h000;
	else if (inc_dac)
	  DAC_counter <= DAC_counter + 1;
	  
  ////////////////////////////////////////////////////
  // Following counter is used to count the number //
  // of samples that have been accumulated.       //
  /////////////////////////////////////////////////
  always @(posedge clk)
    if (clr_smp)
	  smp_counter <= 10'h000;
	else if (inc_smp)
	  smp_counter <= smp_counter + 1;

  /// SM needs to know when we have 8 samples ///	  
  assign smp_eq_8 = &smp_counter;

  //////////////////////////////////////////////
  // Following is the implementation of the  //
  // accumulator that will sum up 8 samples //
  ///////////////////////////////////////////  
  always @(posedge clk)
    if (clr_smp)
	  accumulator <= 13'h0000;
	else if (accum)
	  accumulator <= accumulator + {3'b000,DAC_counter};
	  
  /// Divide by 8 is simply left shifting or ///
  /// simply just taking the upper 10-bits. ///
  assign result = accumulator[12:3];
  
  /////////////////////////////////////////////////////
  // Model of Analog Comparator will simply be done //
  // by reading values from a file and comparing.  //
  //////////////////////////////////////////////////
  initial begin
    analog_ptr = 4'h0;	// will increment on each assertion of accum
	analog_vals[0] = 10'h100;	// next set of 8 should average to 0x100
	analog_vals[1] = 10'h101;
	analog_vals[2] = 10'h102;
	analog_vals[3] = 10'h100;
	analog_vals[4] = 10'h0FF;
	analog_vals[5] = 10'h0FE;
	analog_vals[6] = 10'h101;
	analog_vals[7] = 10'h0FE;	
	analog_vals[8] = 10'h200;	// next set of 8 should average to 0x200
	analog_vals[9] = 10'h201;
	analog_vals[10] = 10'h202;
	analog_vals[11] = 10'h200;
	analog_vals[12] = 10'h1FF;
	analog_vals[13] = 10'h1FE;
	analog_vals[14] = 10'h201;
	analog_vals[15] = 10'h1FE;	
  end
  
  ///////////////////////////////////////////////////////////////////
  // Following code looks bad because we are resetting analog_ptr //
  // in the initial block above, and assigning to it here.  Yes  //
  // this would be terrible for DUT code, but this is not code  //
  // that will be synthesized so we can do this.               //
  //////////////////////////////////////////////////////////////
  always @(posedge clk)
    if (accum)
	  analog_ptr <= analog_ptr + 1;
	  	  
  assign gt = (DAC_counter===10'hxxx) ? 1'b0 :
              (DAC_counter>analog_vals[analog_ptr]) ? 1'b1 : 1'b0;
  
endmodule