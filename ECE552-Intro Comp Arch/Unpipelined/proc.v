module proc (
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;
   output err;
  
// FETCH
  wire [15:0] instr;
  wire [15:0] pc, nxt_pc;
  wire halt;


// DECODE
  wire cin;
  wire [15:0] se_5, ze_5, se_8, ze_8, se_11;
  wire se;
  wire siic;
  wire [15:0] A, B;
  wire [1:0] srcALU;
  wire inv_A, inv_B;

// EXEC
  wire [15:0] ALUres;
  wire en_JAL;


// WRITEBACK
  wire [15:0] readData, writeData;
  wire memWrite, memtoreg;

// ERR
wire err_execute, err_decode, err_memory, err_fetch, err_wb;




 assign err = 1'b0; 			// deassert error.	

 // IF -> ID -> EX -> MEM -> WB
 fetch fetch0 (
    .clk(clk), 
    .rst(rst), 
    .pc(pc), 
    .halt(halt), 
    .nxt_pc(nxt_pc), 
    .instr(instr)
  );

  decode decode0 (
    .clk(clk), 
    .rst(rst), 
    .instr(instr), 
    .writeData(writeData), 
    .A(A), 
    .B(B), 
    .srcALU(srcALU), 
    .memWrite(memWrite), 
    .memtoreg(memtoreg), 
    .inv_A(inv_A), 
    .inv_B(inv_B), 
    .se_5(se_5), 
    .ze_5(ze_5), 
    .se_8(se_8), 
    .ze_8(ze_8), 
    .se_11(se_11), 
    .se(se),
    .cin(cin), 
    .halt(halt)
  );

  execute execute0 (
    .instr(instr), 
    .A(A), 
    .B(B), 
    .nxt_pc(nxt_pc), 
    .srcALU(srcALU), 
    .inv_A(inv_A), 
    .inv_B(inv_B), 
    .cin(cin), 
    .ALUres(ALUres), 
    .pc(pc), 
    .se_5(se_5), 
    .ze_5(ze_5), 
    .se_8(se_8), 
    .ze_8(ze_8), 
    .se_11(se_11), 
    .se(se),
    .enJAL(en_JAL)
  );

  memory memory0 (
    .clk(clk), 
    .rst(rst), 
    .writeData(B), 
    .ALUres(ALUres), 
    .memRead(memtoreg), 
    .memWrite(memWrite), 
    .halt(halt), 
    .readData(readData)
  );

  writeback wb0 (
    .ALUres(ALUres), 
    .nxt_pc(nxt_pc), 
    .enJAL(en_JAL), 
    .memtoreg(memtoreg), 
    .writeData(writeData),
    .readData(readData)  
  );
   
endmodule 
// DUMMY LINE FOR REV CONTROL :0:
