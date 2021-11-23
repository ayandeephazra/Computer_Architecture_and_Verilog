module I_term(clk, rst_n, err_vld, moving, err_sat, I_term);

input clk, rst_n, err_vld, moving;
input signed [9:0]err_sat;
output signed [8:0]I_term;
logic overflow;
// Registers required
reg signed [14:0]nxt_integrator ,integrator, accum, mux1_out, err_sat_15;

// Sign-extend to 15 bits
assign err_sat_15 = {{5{err_sat[9]}},err_sat};

//Accumulator
assign accum = (integrator + err_sat_15);

// Overflow statement
assign overflow = ( (err_sat_15[14] === integrator[14]) && (integrator[14] === accum[14]) ) ? 1'b0 : 1'b1;

// Check error valid and overflow
assign mux1_out = (err_vld && (!overflow)) ? accum: integrator ;

//Check moving and assign to nxt_integrator
assign nxt_integrator = (moving) ?  mux1_out : 15'h0000 ;

always_ff @(posedge clk, negedge rst_n)
if(!rst_n)
  integrator<= 15'h0000;
else
  integrator<= nxt_integrator;

//I_term
assign I_term =  integrator[14:6];

endmodule
