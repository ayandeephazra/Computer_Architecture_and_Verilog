 module proc(clk, rst, err);
    input clk;
    input rst;
    output err;

    // Your Code Here

   // REG FILE HADNLING
   wire [2:0] read1regsel;
   wire [2:0] read2regsel;
   wire [2:0] writeregsel;
   wire [15:0] writedata, writedata_xor;
   wire [15:0] writedata_addi;
   wire      write;

   wire [15:0] read1data;
   wire [15:0] read2data;
   wire [15:0] read1data_reg;
   wire  err;
   wire fetch_clk;
   //////////////////////////
   rf iRF(.read1data(read1data), .read2data(read2data), .err(err),  .clk(fetch_clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel), .writeregsel(writeregsel), .writedata(writedata), .write(write));
    /////////////////////////
    wire [15:0] instr;
    wire halt;
    wire addi, xor_en;
   
    wire [1:0] opcode;
    wire [15:0]  temp_instr, xor_res;

    fetch iFETCH(.clk(fetch_clk), .rst(rst), .err(err), .instr(instr));
    fulladder16 iADDI_ADDER(.A(read1data_reg),.B({{11{instr[4]}}, instr[4:0]}),.S(writedata_addi),.Cout());
    alu iALU(.A(read1data), .B({{11{instr[4]}}, instr[4:0]}), .Cin(1'b0), .Op(opcode), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(writedata), .Ofl(), .Z(), .read1data(read1data), .read2data(read2data), .writedata(writedata));
   


    assign fetch_clk = halt? 0: clk;

    assign temp_instr = instr;
    assign halt = (temp_instr[15:11] === 5'b00000)? 1: 0;
    assign write = (halt)? 0: 1;
    assign addi = (temp_instr[15:11] === 5'b01000)? 1: 0;
    assign xor_en = (temp_instr[15:11] === 5'b11011)? 1: 0;
    assign opcode = (halt)? 2'b00: {(addi)? 2'b01: {(xor_en)? 2'b10: 2'b11} };

 
    assign read1regsel = instr[10:8];
    assign writeregsel = (addi)?instr[7:5]:{(xor_en)?instr[4:2]:3'bxxx};
    assign read2regsel = (xor_en)?instr[7:5]:3'bxxx;
	
    
endmodule
