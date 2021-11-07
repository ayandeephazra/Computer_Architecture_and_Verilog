module P_term_tb();

logic signed[11:0]error;
logic signed[13:0]out;
//logic signed[9:0]err_sat;
logic clk;

P_term DUT1(.error(error),.P_term(out));

initial begin
clk = 0;

// zero test
error = 12'h000;
repeat(2) @(posedge clk);
if(out=== 12'h000)
$display("TEST1: PASSED ZERO TEST");
else
$display("TEST1: FAILED ZERO TEST");
repeat(2) @(posedge clk);

// negative overflow test
error = 12'h988;
repeat(2) @(posedge clk);
if(out=== $signed(14'h3000))
$display("TEST2: PASSED NEG SATURATION TEST");
else
$display("TEST2: FAILED NEG SATURATION TEST");
repeat(2) @(posedge clk);

// positive overflow test
error = 12'h188;
repeat(2) @(posedge clk);
if(out=== $signed(14'hc40))
$display("TEST3: PASSED POS SATURATION TEST");
else
$display("TEST3: FAILED POS SATURATION TEST");
repeat(2) @(posedge clk);

// negative non saturation test
error = 12'hf0f;
repeat(2) @(posedge clk);
if(out=== $signed(14'h3878))
$display("TEST4: PASSED NEG NON SATURATION TEST");
else
$display("TEST4: FAILED NEG NON SATURATION TEST");
repeat(2) @(posedge clk);

// positive non saturation test
error = 12'h00f;
repeat(2) @(posedge clk);
if(out=== $signed(14'h0078))
$display("TEST5: PASSED POS NON SATURATION TEST");
else
$display("TEST5: FAILED POS NON SATURATION TEST");
repeat(2) @(posedge clk);

$stop;
end

always #5 clk = ~clk;
endmodule