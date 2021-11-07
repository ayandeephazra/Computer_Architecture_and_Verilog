module P_term_tb1();
//module P_term_tb(error,out_1,out_2,out_3, out_4);
logic signed[11:0]error;
logic signed[13:0]out;
logic signed[9:0]err_sat;
logic clk;
P_term DUT1(.error(error),.P_term(out));
initial begin
clk = 0;
out = 14'h0000;



// Positive error
error = 12'b011101100111;
repeat(3) @(posedge clk);

// Negative error
error = 12'b101101100111;
repeat(3) @(posedge clk);
if(out!=10'h200) begin
$display("ERR2: NEGATIVE CASE ERROR");
end



//else - err_sat 
error = 12'b111101100111;
repeat(3) @(posedge clk);



//zero value
error = 12'b000000000000;
repeat(3) @(posedge clk);
if(out!=16'h0000) begin
$display("ERR4: ZERO CASE ERROR");
end
end
always #5 clk = ~clk;
endmodule