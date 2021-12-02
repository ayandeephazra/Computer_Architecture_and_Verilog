module sll(In, Cnt, Out, Op);
// SHIFT LEFT LOGICAL
input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;
input [1:0] Op;
wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = (Op===2'b01)?In:16'hzzzz;
		4'b0001 : assign Out = (Op===2'b01)? {In[14:0], 1'h0}:16'hzzzz;
		4'b0010 : assign Out =  (Op===2'b01)?{In[13:0], 2'h0}:16'hzzzz;
		4'b0011 : assign Out =  (Op===2'b01)?{In[12:0], 3'h0}:16'hzzzz;
		4'b0100 : assign Out =  (Op===2'b01)?{In[11:0], 4'h0}:16'hzzzz;
		4'b0101 : assign Out =  (Op===2'b01)?{In[10:0], 5'h0}:16'hzzzz;
		4'b0110 : assign Out =  (Op===2'b01)?{In[9:0], 6'h0}:16'hzzzz;
		4'b0111 : assign Out =  (Op===2'b01)?{In[8:0], 7'h0}:16'hzzzz;
		4'b1000 : assign Out =  (Op===2'b01)?{In[7:0], 8'h0}:16'hzzzz;
		4'b1001 : assign Out =  (Op===2'b01)?{In[6:0], 9'h0}:16'hzzzz;
		4'b1010 : assign Out =  (Op===2'b01)?{In[5:0], 10'h0}:16'hzzzz;
		4'b1011 : assign Out =  (Op===2'b01)?{In[4:0], 11'h0}:16'hzzzz;
		4'b1100 : assign Out =  (Op===2'b01)?{In[3:0], 12'h0}:16'hzzzz;
		4'b1101 : assign Out =  (Op===2'b01)?{In[2:0], 13'h0}:16'hzzzz;
		4'b1110 : assign Out =  (Op===2'b01)?{In[1:0], 14'h0}:16'hzzzz;
		4'b1111 : assign Out =  (Op===2'b01)?{In[0], 15'h0}:16'hzzzz;
	endcase
end



endmodule