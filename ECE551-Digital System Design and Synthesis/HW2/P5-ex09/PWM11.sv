module PWM11(clk, rst_n, duty, PWM_sig, PWM_sig_n);
input clk, rst_n;
input logic [10:0] duty;
output logic PWM_sig, PWM_sig_n;
logic[10:0] cnt;
logic comb_out, asynch_out;

//assign cnt = 0;
always @(negedge rst_n) 

// rst condition
if(!rst_n) begin
cnt = 0;
duty = 0;
asynch_out=0;
end
always @(posedge clk) begin

// comb logic
comb_out = (cnt<duty)?1:0;
cnt <= cnt + 1;
asynch_out<=comb_out;

end
// end statements for output
assign PWM_sig_n = ~asynch_out;
assign PWM_sig = asynch_out;
endmodule
