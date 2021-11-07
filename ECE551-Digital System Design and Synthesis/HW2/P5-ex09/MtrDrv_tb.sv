module MtrDrv_tb();

logic clk, rst_n;
logic signed [10:0] rght_spd, lft_spd;
logic lftPWM1, lftPWM2, rghtPWM1, rghtPWM2;

MtrDrv iMTRDRV(.lft_spd(lft_spd), .rght_spd(rght_spd), .lftPWM1(lftPWM1), .lftPWM2(lftPWM2), .rghtPWM1(rghtPWM1), .rghtPWM2(rghtPWM2), .clk(clk), .rst_n(rst_n));

initial begin

clk = 0;
rst_n = 0;

@(posedge clk);
@(negedge clk) rst_n = 1;

lft_spd = 11'h3ff;
rght_spd = 11'h400;

if(lftPWM1 == 0 & lftPWM2 == 1) $display("PASS1: lft PWM is correct for lft_spd = 11'h3ff");
else $display("FAIL1: lft PWM is wrong for lft_spd = 11'h3ff");
if(rghtPWM1 == 0 & rghtPWM2 == 1) $display("PASS2: rght PWM is correct for rght_spd = 11'h400");
else $display("FAIL2: lft PWM is wrong for rght_spd = 11'h400");
rst_n = 0;

@(posedge clk);
@(negedge clk) rst_n = 1;

lft_spd = 11'h000;
rght_spd = 11'h000;

if(lftPWM1 == 1 & lftPWM2 == 0) $display("PASS3: lft PWM is correct for lft_spd = 11'h000");
else $display("FAIL3: lft PWM is wrong for lft_spd = 11'h000");
if(rghtPWM1 == 0 & rghtPWM2 == 1) $display("PASS4: rght PWM is correct for rght_spd = 11'h000");
else $display("FAIL4: rght PWM is wrong for rght_spd = 11'h000");

rst_n = 0;

@(posedge clk);
@(negedge clk) rst_n = 1;

lft_spd = 11'h400;
rght_spd = 11'h3ff;

if(lftPWM1 == 1 & lftPWM2 == 0) $display("PASS5: lft PWM is correct for lft_spd = 11'h400");
else $display("FAIL5: lft PWM is wrong for lft_spd = 11'h400");
if(rghtPWM1 == 1 & rghtPWM2 == 0) $display("PASS6: rght PWM is correct for rght_spd = 11'h3ff");
else $display("FAIL6: lft PWM is wrong for rght_spd = 11'h3ff");
$stop;
end

always #5 clk = ~clk;
endmodule
