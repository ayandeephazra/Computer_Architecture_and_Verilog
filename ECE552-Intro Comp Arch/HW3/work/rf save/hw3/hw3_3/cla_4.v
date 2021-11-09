module cla_4(a, b, cin, sum, cout);
input [3:0] a, b;
input cin; 
output [3:0] sum;
output cout;

wire [3:0] prop, gen, carry;

assign prop = a^b;
assign gen = a&b;

assign carry[0] = cin;
assign carry[1] = gen[0] | (prop[0] & carry[0]);
assign carry[2] = gen[1] | (prop[1]&gen[0]) | (prop[1]&prop[0]&carry[0]);
assign carry[3] = gen[2] | (prop[2]&gen[1]) | (prop[2]&prop[1]&gen[0]) | (prop[2]&prop[1]&prop[0]&carry[0]);
assign cout = gen[3] | (prop[3]&gen[2]) | (prop[3]&prop[2]&gen[1]) | (prop[3]&prop[2]&prop[1]&gen[0]) | (prop[3]&prop[2]&prop[1]&prop[0]&carry[0]);
assign sum = prop^carry;
endmodule
