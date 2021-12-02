module dff (clk, rst, q, d);

    input d;
    input clk, rst;
    output q;

    reg ff_out;

    assign #(1) q = ff_out;

    always @(posedge clk) begin
      ff_out = rst? 0 : d;
    end

endmodule
// DUMMY LINE FOR REV CONTROL :0: