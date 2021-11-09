module mux_2_1(select, out, a, b);
input select;
input [15:0] a, b;
output [15:0] out;



wire [15:0] and1, and2;

// bitwise AND operations to build the 2 to 1 mux
assign and1 = a & {16{~select}};
assign and2 = b & {16{select}};

// bitwise OR to drive the output
assign out = and1 | and2;
endmodule
