module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   /*
   Your code goes here
   */
   
   wire [15:0] firstMuxInput1, firstMuxOut, secondMuxInput1, secondMuxOut, thirdMuxInput1, thirdMuxOut, fourthMuxInput1, fourthMuxOut;
   ///////////////////////////////////////////////
   mux_4_1 i4to1MUX1(.select(Op), .out(firstMuxInput1), .a({In[15], In[15:1]}), .b({1'b0, In[15:1]}), .c({In[14:0], In[15]}), .d({In[14:0], 1'b0}));
   mux_2_1 i2to1MUX1(.select(Cnt[0]), .out(firstMuxOut), .a(In), .b(firstMuxInput1));
   ///////////////////////////////////////////////
   mux_4_1 i4to1MUX2(.select(Op), .out(secondMuxInput1), .a({firstMuxOut[15], firstMuxOut[15], firstMuxOut[15:2]}), .b({2'b00, firstMuxOut[15:2]}), .c({firstMuxOut[13:0], firstMuxOut[15:14]}), .d({firstMuxOut[13:0], 2'b00}));
   mux_2_1 i2to1MUX2(.select(Cnt[1]), .out(secondMuxOut), .a(firstMuxOut), .b(secondMuxInput1));
   ///////////////////////////////////////////////
   mux_4_1 i4to1MUX3(.select(Op), .out(thirdMuxInput1), .a({secondMuxOut[15], secondMuxOut[15], secondMuxOut[15], secondMuxOut[15], secondMuxOut[15:4]}), .b({4'b0000, secondMuxOut[15:4]}), .c({secondMuxOut[11:0], secondMuxOut[15:12]}), .d({secondMuxOut[11:0], 4'b0000}));
   mux_2_1 i2to1MUX3(.select(Cnt[2]), .out(thirdMuxOut), .a(secondMuxOut), .b(thirdMuxInput1));
   ////////////////////////////////////////////////
   mux_4_1 i4to1MUX4(.select(Op), .out(fourthMuxInput1), .a({thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15], thirdMuxOut[15:8]}), .b({8'b00000000, thirdMuxOut[15:8]}), .c({thirdMuxOut[7:0], thirdMuxOut[15:8]}), .d({thirdMuxOut[7:0], 8'b00000000}));
   mux_2_1 i2to1MUX4(.select(Cnt[3]), .out(fourthMuxOut), .a(thirdMuxOut), .b(fourthMuxInput1));

   assign Out = fourthMuxOut;
endmodule

