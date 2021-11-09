module fetch_hier_bench();

    // wires and reg
    reg [15:0] pc;
    wire [15:0] instr;
    reg fail;

    // DUT & memory (initializing same memory twice)
    fetch_hier DUT();
    memory2c m0(.data_out(instr), .data_in(16'b0), .addr(pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(DUT.c0.clk), .rst(DUT.c0.rst));

    initial begin
        $display("Starting fetch.v testing");
        pc = 0;
        fail = 0;
    end

    always @ (posedge DUT.c0.clk) begin
        if(!DUT.c0.rst) begin
            // Checking instr outputs
            if (instr !== DUT.instr) begin
                $display("ERRORCHECK: instr not matching. Expected instr: %h, DUT instr: %h.",
                         instr, DUT.instr);
                fail = 1;
            end

            // Updating variable
            pc = pc + 2;
            
            // Stopping if halt is seen
            if (instr === 16'b0) begin
                if (fail) $display("TEST FAILED");
                else $display("TEST PASSED");
                $finish;
            end
        end
    end

endmodule
