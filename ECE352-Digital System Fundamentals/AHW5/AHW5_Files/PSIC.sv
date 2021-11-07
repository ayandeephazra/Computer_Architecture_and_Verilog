module PSIC(
  input clk,rst_n,	// clock and asynch active low reset
  input RX,			// serial data input
  output TX		// serial data output
);

  //////////////////////////////////////
  // declare internal signals //
  /////////////////////////////
  logic [1:0] addr;			// address to NV_MEM
  logic WE;					// Write Enable to NV_MEM
  logic [15:0] coeff;		// coefficient read from NV_MEM goes to datapath
  logic strt_cnv;			// from control_SM to A2D, starts conversion
  logic chnl;				// from control_SM to A2D, specifies temp vs pressure
  logic cnv_cmplt;			// from A2D to control_SM, indicates conversion ready
  logic [15:0] a2d_data;	// result of conversion
  logic [23:0] cmd;			// command/data from serial_comm
  logic cmd_rdy;			// to control_SM indicates command is ready
  logic [15:0] dst;			// dest bus of datapath (result of computation step)
  logic trmt;				// from control_SM to serial_comm.  Transmit corrected pressure
  logic selA2D;				// from control_SM to datapath.  Select A2D for "A" input
  logic selCoeff;			// from control_SM to datapath.  Select coeff for "B" input
  logic selMult;			// from control_SM to datapath.  Select Mult vs Add for dst
  logic enTmp;				// from control_SM.  Enable write to Temp register
  
  
  
  /////////////////////////////////////////////////////////////
  // Instantiate NV_MEM that holds calibration coefficients //
  ///////////////////////////////////////////////////////////
  NV_MEM iMEM(.clk(clk),.addr(addr),.WE(WE),.wdata(cmd[15:0]),.rdata(coeff));
  
  /////////////////////////////////////////
  // Instantiate model of A2D converter //
  ///////////////////////////////////////
  A2D iA2D(.clk(clk),.rst_n(rst_n),.strt(strt_cnv),.chnl(chnl),.cmplt(cnv_cmplt),
           .a2d(a2d_data));
		   
  //////////////////////////////////////////////////////////
  // Instantiate datapath (arithmetic computation) block //
  ////////////////////////////////////////////////////////
  datapath iDP(.clk(clk),.a2d(a2d_data),.coeff(coeff),.selA2D(selA2D),
               .selCoeff(selCoeff),.selMult(selMult),.enTmp(enTmp),.dst(dst));
			   
  //////////////////////////////////
  // Instantiate main control SM //
  ////////////////////////////////
  PSIC_cntrl iSM(.clk(clk),.rst_n(rst_n),.cmd_rdy(cmd_rdy),.cmd(cmd[18:16]),.trmt(trmt),
                 .WE(WE),.addr(addr),.selA2D(selA2D),.selCoeff(selCoeff),.selMult(selMult),
				 .enTmp(enTmp),.strt_cnv(strt_cnv),.chnl(chnl),.cnv_cmplt(cnv_cmplt));

  ////////////////////////////////////
  // Instantiate serial_comm block //
  //////////////////////////////////
  serial_comm iCOMM(.clk(clk),.rst_n(rst_n),.RX(RX),.cmd(cmd),.cmd_rdy(cmd_rdy),
                    .TX(TX),.tx_data(dst),.trmt(trmt));
					
endmodule
  
  
///// EEPROM (NV memory) model defined below here //////
// Don't modify anything below this line //
module NV_MEM(clk,addr,WE,wdata,rdata);
  
  input clk;
  input [1:0] addr;		// 00=zero, 01=Tco, 10=Offset, 11=Gain
  input WE;				// when asserted addressed location is written
  input [15:0] wdata;	// data to write
  output [15:0] rdata;	// data from addressed location
  
  reg [15:0]mem[0:3];	// declare memory of EEPROM
  
  assign rdata = mem[addr];
  
  always @(posedge clk)
    if (WE)
	  mem[addr] <= wdata;
	  
  ////////////////////////////////////////////////
  // EEPROM powers up with following constants //
  //////////////////////////////////////////////
  initial begin
    mem[0] = 16'h0000;	// zero in zero reg
	mem[1] = 16'h0000;	// zero in Tco
	mem[2] = 16'h0000;  // zero in Offset
	mem[3] = 16'h4000;	// unity in Gain
  end
endmodule