module I_term_tb();

logic clk,ov, rst_n, moving, err_vld;
logic signed [9:0]err_sat;
logic signed [8:0]I_term;
logic signed [14:0]temp1, temp2;

//Instantiate DUT
I_term iDUT(.clk(clk), .rst_n(rst_n), .err_vld(err_vld), .moving(moving), .err_sat(err_sat), .I_term(I_term));

initial begin
clk = 0;
rst_n = 0;
moving = 1;
err_vld = 1; 
err_sat = 10'h1FF;
@(posedge clk);
@(negedge clk);
rst_n = 1;  // deassert reset

repeat(10)@(posedge clk);

//Check moving case
moving = 0;
repeat(5)@(posedge clk);
if(I_term==1'b0)
$display("success: moving is working okay");
else
$display("fail: moving is not working okay");
moving = 1;
repeat(10)@(posedge clk);

//Check err_vld case
err_vld = 0;
repeat(5)@(posedge clk);
assign temp1 = I_term;
repeat(5)@(posedge clk);
if(temp1 == I_term)
$display("success: err_vld is working okay");
else
$display("fail: err_vld is not working okay");
repeat(5)@(posedge clk);
err_vld = 1;
repeat(10)@(posedge clk);

//Check overflow
@(posedge (I_term === 255))
$display("Overflow has occured");
repeat(5)@(posedge clk);
assign temp2 = I_term;
if(temp2 == I_term)
$display("success: overflow is working okay");
else
$display("fail: overflow is not working okay");
repeat(5)@(posedge clk);

$stop;
end

always
  #5 clk = ~clk;


endmodule
