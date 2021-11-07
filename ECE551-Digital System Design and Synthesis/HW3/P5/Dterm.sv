module D_term(err_sat, err_vld, rst_n, clk, D_term);

input [9:0] err_sat;
input err_vld, rst_n, clk;
output [12:0] D_term;

logic [9:0] mux1_out, mux2_out, D_diff, prev_err;
reg [9:0] q1, q2;
logic [6:0] saturated_D_diff;

localparam P_COEFF = 6'h0B;

assign mux1_out = (err_vld)? err_sat: q1;

// FF 1
always_ff @(posedge clk)
if(!rst_n)
q1 <= 10'h000;
else
q1 <= mux1_out;

assign mux2_out = (err_vld)? q1: q2;

// FF 2
always_ff @(posedge clk)
if(!rst_n)
q2 <= 10'h000;
else
q2 <= mux2_out;

assign prev_err = q2;

//assign D_diff = err_sat - prev_err;
assign D_diff = err_sat - q2;

// Saturation
assign saturated_D_diff = (D_diff[9]===1)? ((D_diff[8:7]===2'b11)?D_diff[9:0]:6'h20) :
                          ((D_diff[8:7]===2'b00)?D_diff[9:0]:6'h1F) ;

assign D_term = saturated_D_diff * $signed(P_COEFF);

endmodule