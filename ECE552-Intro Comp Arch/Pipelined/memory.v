module memory (clk, rst, writeData, ALUres, memRead, memWrite, halt, readData);

  input clk, rst;
  input [15:0] writeData;
  input [15:0] ALUres;
  input memRead, memWrite;
  input halt;
  output [15:0] readData;

  wire memReadorWrite;

  assign memReadorWrite = memRead | memWrite;

/////////////////////////////////////////
// 	     DATA MEMORY               //
/////////////////////////////////////////
  memory2c DATA_MEM (.data_out(readData), .data_in(writeData), .addr(ALUres), .enable(memReadorWrite), .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));

endmodule
