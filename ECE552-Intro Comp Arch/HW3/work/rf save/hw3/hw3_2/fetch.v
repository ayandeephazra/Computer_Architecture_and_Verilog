module fetch (clk, rst, err, instr);

        input clk;
        input rst;
        output err;
        output [15:0] instr;

        // Your Code goes here
        //reg [15:0] pc, pcPrev;
        wire [15:0] pcPrev_w;
        reg [15:0] A,B;

        wire[15:0] S, pc;
        wire Cout;
        wire [15:0] pc_fetch;
        wire [15:0] pc_u;
////////////////////////////////
        memory2c iMEM(.data_out(instr), .data_in(16'h0000), .addr(pc_fetch), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
        fulladder16 iFULLADDER(.A(pc_fetch),.B(16'h0002),.S(pc_u),.Cout(Cout));
        assign pc = (rst)? 16'h0000: pc_u;
        dff IDFF [15:0] (.q(pc_fetch), .d(pc), .clk(clk), .rst(rst));

    

endmodule
