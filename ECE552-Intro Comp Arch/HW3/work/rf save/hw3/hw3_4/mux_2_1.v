module mux_2_1(select, out, a, b);
input select;
input [15:0] a, b;
output [15:0] out;

//assign out = (select)? b: a;

wire [15:0] and1, and2;
//and [15:0] iAND1(and1, a, select);
assign and1 = a & {16{~select}};
assign and2 = b & {16{select}};
assign out = and1 | and2;
endmodule
