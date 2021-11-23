
module P_term(error, P_term);

input signed [11:0] error;
output signed [13:0] P_term;
wire signed [9:0] err_sat;
localparam P_COEFF = 5'h08;

// if, error[11] is a negative number, check 10:9 bits, if both are 1 then assign err_sat as lower 10 bits,
// else saturate to most negative value in  a 10 bit binary number 10'200.

// likewise for positive numbers.
assign err_sat = (error[11]===1)? ((error[10:9]===2'b11)?error[9:0]:10'h200) :
                          ((error[10:9]===2'b00)?error[9:0]:10'h1FF) ;

// signed multiply 
assign P_term = err_sat * $signed(P_COEFF);
endmodule