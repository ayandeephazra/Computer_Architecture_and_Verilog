module datapath(
  input clk,			// system clock
  input [15:0] a2d,		// Result from A2D conversionTemp
  input [15:0] coeff,	// calibration coefficient from NV_MEM
  input selA2D,			// selects A2D vs Temp on "A" side of datapath
  input selCoeff,		// selects coeff vs Temp on "B" side of datapath
  input selMult,		// selects Mult vs Add to drive dst
  input enTmp,			// enable write to Temp register
  output [15:0] dst		// the result of datapath computation
);

  ////////////////////////////////////////////////////////
  // Declare any needed internal signals as type logic //
  //////////////////////////////////////////////////////
  //<-- you need to do this -->
  
  logic [15:0] en_reg16_out;
  logic [15:0] MUX1;
  logic [15:0] MUX2;
  logic [15:0] satSum;
  logic [15:0] satProd;
  
  /////////////////////////////////////////////////
  // Instantiate en_reg16 to form Temp register //
  ///////////////////////////////////////////////
  //<-- you need to do this -->

  en_reg16 en_reg16_1(.clk(clk), .EN(enTmp), .D(dst), .Q(en_reg16_out));
  
  //////////////////////////////////////////////
  // Infer selection muxes for satAdd inputs //
  ////////////////////////////////////////////
  //<-- you need to do this -->

  assign MUX1 = (selA2D) ? a2d : en_reg16_out;
  assign MUX2 = (~selCoeff) ? en_reg16_out : coeff;
  
  /////////////////////////
  // Instantiate satAdd //
  ///////////////////////
  //<-- you need to do this -->

  satAdd satAdd_1 (.A(MUX1), .B(MUX2), .satSum(satSum));
  
  //////////////////////////
  // Instantiate satMult //
  ////////////////////////
  //<-- you need to do this -->

  satMult satMult_1 (.coeff(coeff), .Temp(en_reg16_out), .satProd(satProd));
  
  ///////////////////////////////////////////
  // Infer mux to select from Add vs Mult //
  /////////////////////////////////////////
  //<-- you need to do this -->

  assign dst = (selMult)? satProd : satSum;
  
endmodule
