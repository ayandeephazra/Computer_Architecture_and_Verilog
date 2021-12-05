module srl(In, Cnt, Out, Op);
// SHIFT RIGHT LOGICAL
input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;
input [1:0] Op;
wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = (Op===2'b11)?In:16'hzzzz;
		4'b0001 : assign Out = (Op===2'b11)? {1'b0, In[15:1]}:16'hzzzz;
		4'b0010 : assign Out =  (Op===2'b11)?{2'b00, In[15:2]}:16'hzzzz;
		4'b0011 : assign Out =  (Op===2'b11)?{3'b000, In[15:3]}:16'hzzzz;
		4'b0100 : assign Out =  (Op===2'b11)?{4'b0000, In[15:4]}:16'hzzzz;
		4'b0101 : assign Out =  (Op===2'b11)?{5'b00000, In[15:5]}:16'hzzzz;
		4'b0110 : assign Out =  (Op===2'b11)?{6'b000000, In[15:6]}:16'hzzzz;
		4'b0111 : assign Out =  (Op===2'b11)?{7'b0000000, In[15:7]}:16'hzzzz;
		4'b1000 : assign Out =  (Op===2'b11)?{8'b00000000, In[15:8]}:16'hzzzz;
		4'b1001 : assign Out =  (Op===2'b11)?{9'b000000000, In[15:9]}:16'hzzzz;
		4'b1010 : assign Out =  (Op===2'b11)?{10'b0000000000, In[15:10]}:16'hzzzz;
		4'b1011 : assign Out =  (Op===2'b11)?{11'b00000000000, In[15:11]}:16'hzzzz;
		4'b1100 : assign Out =  (Op===2'b11)?{12'b000000000000, In[15:12]}:16'hzzzz;
		4'b1101 : assign Out =  (Op===2'b11)?{13'b0000000000000, In[15:13]}:16'hzzzz;
		4'b1110 : assign Out =  (Op===2'b11)?{14'b00000000000000, In[15:14]}:16'hzzzz;
		4'b1111 : assign Out =  (Op===2'b11)?{15'b000000000000000, In[15]}:16'hzzzz;
	endcase
end



endmodule
