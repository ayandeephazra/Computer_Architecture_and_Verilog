module decode (instr, writeData, regsel, regWrite_in, clk, rst, se_5, ze_5, se_8, ze_8, se_11, se, A, B, AB, srcALU, regDestination, memWrite, memtoreg, regWrite_out, inv_A, inv_B, cin, halt, siic, rti);

  input [15:0] instr;
  input [15:0] writeData;
  input [2:0] regsel;
  input regWrite_in;
  input clk, rst;
  output [15:0] A, B;
  output [4:0] AB;
  output [1:0] srcALU;
  output [1:0] regDestination;
  output [15:0] se_5, ze_5, se_8, ze_8, se_11;
  output se;
  output memWrite, memtoreg, regWrite_out;
  output inv_A, inv_B, cin;
  output halt;
  output siic, rti;

//////////////////////////////////////////////////
// 	 	 SIGN EXTEND LOGIC              //
//////////////////////////////////////////////////
  assign se_5 = {{11{instr[4]}}, instr[4:0]};
  assign ze_5 = {{11{1'b0}}, instr[4:0]};
  assign se_8 = {{8{instr[7]}}, instr[7:0]};
  assign ze_8 = {{8{1'b0}}, instr[7:0]};
  assign se_11 = {{5{instr[10]}}, instr[10:0]};

//////////////////////////////////////////////////
// 	  	 CONTROL LOGIC                  //
//////////////////////////////////////////////////
  control CONTROL (.instr(instr), .srcALU(srcALU), .regDestination(regDestination), .memWrite(memWrite), .regWrite(regWrite_out), .memtoreg(memtoreg), .inv_A(inv_A), .inv_B(inv_B), .cin(cin), .AB(AB), .se(se), .halt(halt), .siic(siic), .rti(rti));


///////////////////////////////////////////////////
// 	   READ1DATA, READ2DATA, WRITEDATA       //
///////////////////////////////////////////////////
  rf regFile0 (.read1data(A), .read2data(B), .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]), .writeregsel(regsel), .writedata(writeData), .write(regWrite_in));


endmodule