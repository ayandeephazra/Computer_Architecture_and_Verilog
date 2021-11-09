module quaddemux1_4_bench;
    // No IO as testbench is just a wrapper for testing outputs

    // wires and registers used for testing
    reg [3:0] Inp;
    reg [1:0] S;

    wire [3:0] OutA;
    wire [3:0] OutB;
    wire [3:0] OutC;
    wire [3:0] OutD;

    wire Clk;
    // dummy wires used in clkrst module
    wire Rst;
    wire Err;

    // clkrst Module
    clkrst my_clkrst(.clk(Clk), .rst(Rst), .err(Err));

    //DUT (Device Under Testing) Instantiation
    quaddemux1_4 DUT(.Inp(Inp), .S(S), .OutA(OutA), .OutB(OutB), .OutC(OutC), .OutD(OutD));

    // Whatever you put in an initial block will be executed at the
    // start of the simulation. Use for proper testing initialization
    initial begin
        // Lets initialize the input signals (We do not want any Z's)
        Inp = 4'b0001;
        S = 2'b00;

        // #<some-number> denotes delay for simulator to wait before executing
        // further instructions.
        // $finish terminates the simulation. Here after starting simulation we 
        // are waiting for 4000 ticks before terminating it.
        #4000 $finish;
    end

    always @(posedge Clk) begin
        // Assigning random values to Inp and S for testing purpose at
        // every positive clk edge
        Inp = $random;
        S = $random;        
    end

    always @(negedge Clk) begin
        // Verifying the the output is correct at every negative clk edge
        case (S)
            2'b00 :
                if ((OutA !== Inp) || (OutB !== 4'b0000) ||
                    (OutC !== 4'b0000) || (OutD !== 4'b0000)) begin
                        $display ("ERRORCHECK Inp S = 2'b00");
                end
            2'b01 :
                if ((OutA !== 4'b0000) || (OutB !== Inp) ||
                    (OutC !== 4'b0000) || (OutD !== 4'b0000)) begin
                        $display ("ERRORCHECK Inp S = 2'b01");
                end
            2'b10 :
                if ((OutA !== 4'b0000) || (OutB !== 4'b0000) ||
                    (OutC !== Inp) || (OutD !== 4'b0000)) begin
                        $display ("ERRORCHECK Inp S = 2'b10");
                end
            2'b11 :
                if ((OutA !== 4'b0000) || (OutB !== 4'b0000) ||
                    (OutC !== 4'b0000) || (OutD !== Inp)) begin
                        $display ("ERRORCHECK Inp S = 2'b11");
                end 
        endcase
    end

endmodule