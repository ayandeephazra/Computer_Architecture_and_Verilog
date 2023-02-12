
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module AudioTut(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		REF_CLK,

	//////////// I2C for configure CODEC //////////
	output		          		SCL,
	inout 		          		SDA,

	//////////// KEY //////////
	input 						RST_n,	// this is KEY[0]

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);

  wire [15:0] lft_out, rht_out;		// scaled audio data out to CODEC
  wire [15:0] lft_in, rht_in;		// captured audio data in from CODEC
  wire LRCLK;						// used for both DAC & ADC
  wire aud_vld;						// audio sample from CODEC valid
  wire rst_n;						// synchronized global reset signal
  wire cfg_done;					// CODEC configuration done
  wire clk;							// 50MHz clock from PLL
  wire pll_locked;					// PLL is locked on reference clock
  wire [11:0] volume;				// amount to scale volume by
  wire [9:0] xpix;					// current X coordinate of VGA
  wire [8:0] ypix;					// current Y coordinate of VGA
  
  reg [15:0] aud_sum,aud_abs;
  
  ////////////////////////////////////////////////////////
  // Instantiate PLL to generate clk and 25MHz VGA_CLK //
  //////////////////////////////////////////////////////
  PLL iPLL(.refclk(REF_CLK), .rst(~RST_n),.outclk_0(clk),.outclk_1(VGA_CLK),
           .locked(pll_locked));
 
  /////////////////////////////////////
  // instantiate rst_n synchronizer //
  ///////////////////////////////////
  rst_synch iRST(.clk(clk),.RST_n(RST_n), .pll_locked(pll_locked), .rst_n(rst_n));
  
  ////////////////////////////////
  // Instantiate ADC interface //
  //////////////////////////////
  A2D_intf iADC(.clk(clk),.rst_n(rst_n),.val0(volume),.CONVST(ADC_CONVST),
                .SCLK(ADC_SCLK),.MOSI(ADC_DIN),.MISO(ADC_DOUT));
  
  
  ////////////////////////////////////////////////////
  // Instantiate I2C based unit to configure CODEC //
  //////////////////////////////////////////////////
  CODEC_cfg iCFG(.clk(clk),.rst_n(rst_n),.SDA(SDA),.SCL(SCL),.cfg_done(cfg_done));
  
  //////////////////////////////////
  // Instantiate CODEC interface //
  ////////////////////////////////
  codec_intf iAUD(.clk(clk),.rst_n(rst_n),.ADCDAT(AUD_ADCDAT),.lft_out(lft_out),.rht_out(rht_out),
                  .LRCLK(LRCLK),.BCLK(AUD_BCLK),.MCLK(AUD_XCK),.DACDAT(AUD_DACDAT),
				  .lft_in(lft_in),.rht_in(rht_in),.valid(aud_vld));
  assign AUD_DACLRCK = LRCLK;
  assign AUD_ADCLRCK = LRCLK;
  
  //////////////////////////////////////
  // Instantiate Audio Scaling Block //
  ////////////////////////////////////
  AudioScale iSCL(.clk(clk),.rst_n(rst_n),.aud_vld(aud_vld),.volume(volume),
                  .lft_in(lft_in),.rht_in(rht_in),.lft_out(lft_out),
				  .rht_out(rht_out));
  
  always @(posedge clk)
    if (aud_vld)
	  aud_sum <= {lft_in[15],lft_in[15:1]} + {rht_in[15],rht_in[15:1]};
	  
  always @(posedge clk)
    aud_abs <= (aud_sum[15]) ? -aud_sum : aud_sum;

  assign LEDR = aud_abs[15:4];
  //assign LEDR = volume[11:2];
  
  ///////////////////////////////////////
  // Instantiate VGA Timing Generator //
  /////////////////////////////////////
  VGA_timing iVGATM(.clk25MHz(VGA_CLK), .rst_n(rst_n), .VGA_BLANK_N(VGA_BLANK_N), .VGA_HS(VGA_HS),
                    .VGA_SYNC_N(VGA_SYNC_N), .VGA_VS(VGA_VS), .xpix(xpix), .ypix(ypix));

  //////////////////////////////////////////////
  // Instantiate Logic that determines pixel //
  // colors based on music magnitude        //
  ///////////////////////////////////////////					
  DrawLogic(.clk(clk),.rst_n(rst_n),.aud_vld(aud_vld),.lft_in(lft_in),
            .rht_in(rht_in),.xpix(xpix),.ypix(ypix),.VGA_G(VGA_G),
			.VGA_B(VGA_B),.VGA_R(VGA_R));

endmodule
