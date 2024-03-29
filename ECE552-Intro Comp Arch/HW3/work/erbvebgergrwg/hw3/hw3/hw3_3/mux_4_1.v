
module mux_4_1(select, out, a, b, c, d);
input [1:0] select;
input [15:0] a, b, c, d;
output [15:0] out;

wire [15:0] wire1, wire2;
// using 3 2_1 muxes for implementing a 4_1 mux
mux_2_1 iMUX_2_1_1(.select(select[0]), .out(wire1), .a(a), .b(b));
mux_2_1 iMUX_2_1_2(.select(select[0]), .out(wire2), .a(c), .b(d));
mux_2_1 iMUX_2_1_3(.select(select[1]), .out(out), .a(wire1), .b(wire2));
endmodule