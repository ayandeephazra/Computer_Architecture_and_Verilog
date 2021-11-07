module D_term_tb();
logic [9:0] err_sat;
logic err_vld, clk, rst_n;
logic [12:0] 	D_term;
D_term iDUT(.err_sat(err_sat), .err_vld(err_vld), .rst_n(rst_n), .clk(clk), .D_term(D_term));
localparam ERRSAT1 = 10'h000;
initial begin
clk = 0;

/// CASE SUSTAINS A ZERO VALUE SO THAT DIFFERENCE IS 0 EVEN AFTER 2 CLOCK CYC
repeat (2) @ (posedge clk);
rst_n = 0;
err_vld = 1;
err_sat = ERRSAT1;
repeat (3) @ (posedge clk);
if(D_term!==12'h0000)
$display("TEST1: Sustained Zero case failed.");
else
$display("TEST1: Sustained Zero case passed.");
repeat (3) @ (posedge clk);
//////////////////////////////////////////////

/// CASE SUSTAINS A -VE VALUE SO THAT DIFFERENCE IS 0 EVEN AFTER 2 CLOCK CYC
repeat (2) @ (posedge clk);
rst_n = 1;
err_vld = 1;
err_sat = 10'h3ff;
repeat (3) @ (posedge clk);
if(D_term!==10'h000)
$display("TEST2: Sustained Negative case failed.");
else
$display("TEST2: Sustained Negative case passed.");
repeat (3) @ (posedge clk);
///////////////////////////////////////////////

/// CASE SUSTAINS A +VE VALUE SO THAT DIFFERENCE IS 0 EVEN AFTER 2 CLOCK CYC
repeat (2) @ (posedge clk);
rst_n = 1;
err_vld = 1;
err_sat = 10'h069;
repeat (3) @ (posedge clk);
if(D_term!==10'h000)
$display("TEST3: Sustained Positive case failed.");
else
$display("TEST3: Sustained Positive case passed.");
repeat (3) @ (posedge clk);
///////////////////////////////////////////////

/// CASE CHANGES ERR_SAT VALUE SO THAT SATURATE IS EQUAL TO 0X1 AND D_TERM SHOULD BE 0XB
repeat (2) @ (posedge clk);
rst_n = 1;
err_vld = 1;
err_sat = 10'h001;
repeat (2) @ (posedge clk);
err_vld = 0;
err_sat = 10'h002;
repeat (3) @ (posedge clk);
if(D_term!==10'h00b)
$display("TEST4: Changed err_sat case, where saturated D Diff = 1, failed.");
else
$display("TEST4: Changed err_sat case, where saturated D Diff = 1, passed.");
repeat (3) @ (posedge clk);
///////////////////////////////////////////////


/// CASE CHANGES ERR_SAT VALUE SO THAT SATURATE IS EQUAL TO 0X3F AND D_TERM SHOULD BE 0X575
repeat (2) @ (posedge clk);
rst_n = 1;
err_vld = 1;
err_sat = 10'h003;
repeat (2) @ (posedge clk);
err_vld = 0;
err_sat = 10'h002;
repeat (3) @ (posedge clk);
if(D_term!==11'h575)
$display("TEST5: Changed err_sat case, where saturated D Diff = 3ff, failed.");
else
$display("TEST5: Changed err_sat case, where saturated D Diff = 3ff, passed.");
repeat (3) @ (posedge clk);
///////////////////////////////////////////////


/// CASE CHANGES ERR_SAT VALUE SO THAT SATURATE IS EQUAL TO 0X3 AND D_TERM SHOULD BE 0X21
repeat (2) @ (posedge clk);
rst_n = 1;
err_vld = 1;
err_sat = 10'h0fd;
repeat (2) @ (posedge clk);
err_vld = 0;
err_sat = 10'h100;
repeat (3) @ (posedge clk);
if(D_term!==11'h021)
$display("TEST6: Changed err_sat case, where saturated D Diff = 3, failed.");
else
$display("TEST6: Changed err_sat case, where saturated D Diff = 3, passed.");
repeat (3) @ (posedge clk);
$stop;
end

always #5 clk = ~clk;

endmodule