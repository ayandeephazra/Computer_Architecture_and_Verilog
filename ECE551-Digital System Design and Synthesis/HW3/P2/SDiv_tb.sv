module SDiv_tb();

logic signed [15:0] dividend, divisor;
logic go, clk, rst_n;
logic rdy;
logic [15:0] quotient;

SDiv iSDiv(.dividend(dividend), .divisor(divisor), .go(go), .rdy(rdy), .quotient(quotient), .clk(clk), .rst_n(rst_n));


initial begin
clk = 0;
go = 1;
rst_n = 1;

dividend = 16'h0010;
divisor = 16'h0004;
//go = 1;
//$display("Ted %s", go);
//while(~rdy)@ (posedge clk);
//repeat(while(~rdy)) @ (posedge clk);
//$display("Ted %s", quotient);

repeat(7) @ (posedge clk);
$display(quotient);
if(quotient!==16'h0004)
$display("TEST1: ++ case failed");
else
$display("TEST1: ++ case passed");

 
//Ted %h", 

go = 1;
rst_n = 1;
dividend = 16'h0020;
divisor = 16'hfffc;

//$display("Ted %s", go);   hfffc

repeat(7) @ (posedge clk);
if(quotient!==16'h0000)
$display("TEST2: +- case failed");
else
$display("TEST2: +- case passed");

repeat(3) @ (posedge clk);
go = 1;
rst_n = 1;
dividend = 16'hfffe;
divisor = 16'h0004;

while(~rdy) @ (posedge clk);
repeat(10) @ (posedge clk);
if(quotient!==16'hfffc)
$display("TEST3: -+ case failed");
else
$display("TEST3: -+ case passed");
$stop;
end

always #5 clk = ~clk;
endmodule
