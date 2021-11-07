module MtrDrv(lft_spd, rght_spd, lftPWM1, lftPWM2, rghtPWM1, rghtPWM2, clk, rst_n);

input clk, rst_n;
input signed [10:0] rght_spd, lft_spd;
output lftPWM1, lftPWM2, rghtPWM1, rghtPWM2;

logic signed [10:0] leftduty, rightduty;
//  left duty
assign leftduty = lft_spd + 11'h400;
// right duty
assign rightduty = rght_spd + 11'h400;

// left and right PWM instantiation
PWM11 iPWM1(.clk(clk), .rst_n(rst_n), .duty(leftduty), .PWM_sig(lftPWM1), .PWM_sig_n(lftPWM2));
PWM11 iPWM2(.clk(clk), .rst_n(rst_n), .duty(rightduty), .PWM_sig(rghtPWM1), .PWM_sig_n(rghtPWM2));

endmodule
