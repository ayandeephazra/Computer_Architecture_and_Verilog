module ss_A2D(clk,rst_n,strt_cnv,result,cnv_cmplt);

  input clk,rst_n;		// clock and active low reset
  input strt_cnv;		// start conversion
  
  output [9:0] result;	// result of average of 8-samples
  output cnv_cmplt;		// asserted for 1 clock when conversion completes
  
  wire [9:0] result;
  
  /////////////////////////////////////
  // Instantiate datapath of ss_A2D //
  ///////////////////////////////////
  ss_A2D_datapath iDP(.clk(clk),.clr_dac(clr_dac),.inc_dac(inc_dac),
                      .clr_smp(clr_smp),.inc_smp(inc_smp),.accum(accum),
					  .gt(gt),.result(result),.smp_eq_8(smp_eq_8));

  //////////////////////////////////////////
  // Instantiate state machine of ss_A2D //
  ////////////////////////////////////////
  ss_A2D_SM iSM(.clk(clk),.rst_n(rst_n),.strt_cnv(strt_cnv),.smp_eq_8(smp_eq_8),
            .gt(gt),.clr_dac(clr_dac),.inc_dac(inc_dac),.clr_smp(clr_smp),
			.inc_smp(inc_smp),.accum(accum),.cnv_cmplt(cnv_cmplt));
			
endmodule
