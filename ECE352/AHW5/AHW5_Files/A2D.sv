module A2D(
  input clk,rst_n,		// clock and active low resetstrt
  input strt,			// tells A2D to start a conversion
  input chnl,			// selects CH1 (pressure) for conversion
  output cmplt,			// asserted for 1 clock when A2D done
  output reg [15:0] a2d	// result of A2D conversion
);

  ////////////////////////////////////////////////////////////
  // NOTE: this is only a crude model of an A2D converter  //
  // You can edit the values stored in the "values" array //
  // below to test with values other than those provided //
  ////////////////////////////////////////////////////////
  
  reg last_CH;				// flop that holds last channel conv started on.
  // declare a memory to hold values for A2D results
  reg [15:0]PTAT[0:7];		// holds values for temperature readings
  reg [15:0]PRESSURE[0:7];	// holds values for pressure readings
  
  initial begin
    /// edit below to test with different values for A2D results of temperature
    PTAT[0] = 16'h1ABC;	// first A2D result for temp (CH0)
    PTAT[1] = 16'h1ABC;	// second A2D result for temp (CH0)
    PTAT[2] = 16'h1ABC;	// third A2D result for temp (CH0)
    PTAT[3] = 16'h1ABC;	// fourth A2D result for temp (CH0)
    PTAT[4] = 16'h1ABC;	// fifth A2D result for temp (CH0) ------ 5
    PTAT[5] = 16'h1ABC;	// sixth A2D result for temp (CH0)
    PTAT[6] = 16'h5ABC;	// seventh A2D result for temp (CH0)
    PTAT[7] = 16'h5ABC;	// eigth A2D result for temp (CH0)
	/// edit below to test with different values for A2D results of temperature
    PRESSURE[0] = 16'h3456;	// first A2D result for pressure (CH1)
    PRESSURE[1] = 16'h3ABC;	// second A2D result for pressure (CH1) 
    PRESSURE[2] = 16'h5678;	// third A2D result for pressure (CH1)) -- 3ABC
    PRESSURE[3] = 16'h5ABC;	// fourth A2D result for pressure (CH1)
    PRESSURE[4] = 16'h2ABD;	// fifth A2D result for pressure (CH1) ---- 5ABC
    PRESSURE[5] = 16'h6ABC;	// sixth A2D result for pressure (CH1)
    PRESSURE[6] = 16'h5ABC;	// seventh A2D result for pressure (CH1)
    PRESSURE[7] = 16'h5ABC;	// eigth A2D result for pressure (CH1)
			
  end
  
  reg [2:0] indxCH0;	// index into PTAT[]
  reg [2:0] indxCH1;	// index into PRESSURE[]
  reg [3:0] cnt;	// count clocks till cmplt
   
  ///////////////////////////////////////////////////
  // increment indx into values[] upon completion //
  /////////////////////////////////////////////////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n) begin
	  indxCH0 <= 3'b000;
	  indxCH1 <= 3'b000;
	end else if (cnt==4'hC) begin
	  indxCH0 <= (last_CH) ? indxCH0 : indxCH0 + 1;
	  indxCH1 <= (last_CH) ? indxCH1 + 1 : indxCH1;
	end
	  
  /////////////////////////////////////////////////////////
  // Keep track of last channel when conversion started //
  ///////////////////////////////////////////////////////
  always_ff @(posedge clk)
    if (strt)
	  last_CH <= chnl;
	  
  //////////////////////////////////////////////////
  // cnt times out the conversion.  Freezes at F //
  ////////////////////////////////////////////////  
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  cnt <= 4'hF;
	else if (strt)
	  cnt <= 4'h0;
	else if (~&cnt)
	  cnt <= cnt + 4'h1;

  ////////////////////////////////////////
  // flop values[indx] upon completion //
  //////////////////////////////////////
  always_ff @(posedge clk)
    if (cnt==4'hC)
      a2d <= (last_CH) ? PRESSURE[indxCH1] : PTAT[indxCH0];

  assign cmplt = (cnt==4'hD) ? 1'b1 : 1'b0;

endmodule  
  
  