module lshift_rot_tb();
logic [15:0] src;
logic [3:0] amt;
logic rot, clk;
logic [15:0] res;

lshift_rot iDUT(.src(src), .amt(amt), .rot(rot), .res(res));
initial begin
clk = 0;
src = 16'h8888;
amt = 4'h1;
rot = 0;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'h1110)
$display("ERR1: left shift for amt = 4'h1 does not work.");
else
$display("PASS1: left shift for amt = 4'h1 does work.");
///////////////////////////////////////////////////////////
repeat(2) @(posedge clk);
src = 16'h2000;
amt = 4'h2;
rot = 0;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'h8000)
$display("ERR2: left shift for amt = 4'h2 does not work.");
else
$display("PASS2: left shift for amt = 4'h2 does work.");
///////////////////////////////////////////////////////////
repeat(2) @(posedge clk);
src = 16'h0001;
amt = 4'hf;
rot = 0;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'h8000)
$display("ERR3: left shift for amt = 4'hf does not work.");
else
$display("PASS3: left shift for amt = 4'hf does work.");
/////////////////////////////////////////////////////////////
repeat(2) @(posedge clk);
src = 16'h8000;
amt = 4'h1;
rot = 1;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'h0001)
$display("ERR4: rot for src = 16'h8000 does not work. Rotate gives a value 1.");
else
$display("PASS4: rot for src = 16'h8000 does work.");
/////////////////////////////////////////////////////////////
repeat(2) @(posedge clk);
src = 16'hffff;
amt = 4'h1;
rot = 1;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'hffff)
$display("ERR5: rot for src = 16'hffff does not work. All f's should give all f's on rotate.");
else
$display("PASS5: rot for src = 16'hffff does work.");
/////////////////////////////////////////////////////////////
repeat(2) @(posedge clk);
src = 16'h0001;
amt = 4'h1;
rot = 1;
repeat(3) @(posedge clk);
@(posedge clk);
if(res!==16'h0002)
$display("ERR6: rot for src = 16'h0001 does not work.");
else
$display("PASS6: rot for src = 16'h0001 does work.");
$stop;
end
always #5 clk = ~clk;
endmodule
