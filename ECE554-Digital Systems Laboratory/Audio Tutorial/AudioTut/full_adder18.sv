module full_adder18(a,b,s,cin,cout);

	input [17:0] a,b;
	input cin;
	output [17:0] s;
	output [17:0] cout;
	
	full_adder1 op1(.a(a[0]), .b(b[0]), .s(s[0]), .cin(cin), .cout(cout[0]));
	full_adder1 op2(.a(a[1]), .b(b[1]), .s(s[1]), .cin(cout[0]), .cout(cout[1]));
	full_adder1 op3(.a(a[2]), .b(b[2]), .s(s[2]), .cin(cout[1]), .cout(cout[2]));
	full_adder1 op4(.a(a[3]), .b(b[3]), .s(s[3]), .cin(cout[2]), .cout(cout[3]));
	full_adder1 op5(.a(a[4]), .b(b[4]), .s(s[4]), .cin(cout[3]), .cout(cout[4]));
	full_adder1 op6(.a(a[5]), .b(b[5]), .s(s[5]), .cin(cout[4]), .cout(cout[5]));
	full_adder1 op7(.a(a[6]), .b(b[6]), .s(s[6]), .cin(cout[5]), .cout(cout[6]));
	full_adder1 op8(.a(a[7]), .b(b[7]), .s(s[7]), .cin(cout[6]), .cout(cout[7]));
	full_adder1 op9(.a(a[8]), .b(b[8]), .s(s[8]), .cin(cout[7]), .cout(cout[8]));
	full_adder1 op10(.a(a[9]), .b(b[9]), .s(s[9]), .cin(cout[8]), .cout(cout[9]));
	full_adder1 op11(.a(a[10]), .b(b[10]), .s(s[10]), .cin(cout[9]), .cout(cout[10]));
	full_adder1 op12(.a(a[11]), .b(b[11]), .s(s[11]), .cin(cout[10]), .cout(cout[11]));
	full_adder1 op13(.a(a[12]), .b(b[12]), .s(s[12]), .cin(cout[11]), .cout(cout[12]));
	full_adder1 op14(.a(a[13]), .b(b[13]), .s(s[13]), .cin(cout[12]), .cout(cout[13]));
	full_adder1 op15(.a(a[14]), .b(b[14]), .s(s[14]), .cin(cout[13]), .cout(cout[14]));
	full_adder1 op16(.a(a[15]), .b(b[15]), .s(s[15]), .cin(cout[14]), .cout(cout[15]));
	full_adder1 op17(.a(a[16]), .b(b[16]), .s(s[16]), .cin(cout[15]), .cout(cout[16]));
	full_adder1 op18(.a(a[17]), .b(b[17]), .s(s[17]), .cin(cout[16]), .cout(cout[17]));

endmodule

module full_adder1(a,b,s,cin,cout);

	input a,b,cin;
	output s,cout;
	
	
	assign s = {a^b}^cin;
	assign cout = {{a^b}&cin} | {a&b};

endmodule
