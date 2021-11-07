module PWM11_tb();

logic clk, rst_n;
logic [10:0] duty;
logic PWM_sig, PWM_sig_n;


PWM11 iDUT(.clk(clk), .rst_n(rst_n), .duty(duty), .PWM_sig(PWM_sig), .PWM_sig_n(PWM_sig_n));

initial begin


clk = 0;

// small duty cycle
//repeat (2) @(posedge clk);
rst_n = 0;
duty = 11'h000;
repeat (2048) @(posedge clk);
// somewhat larger duty cycle
repeat (2) @(posedge clk);
rst_n = 0;
duty = 11'h0ff;
repeat (2048) @(posedge clk);
// long duty cycle
repeat (2) @(posedge clk);
rst_n = 0;
duty = 11'h3ff;
repeat (2048) @(posedge clk);
$stop;
end


always #5 clk = ~clk;

endmodule