module rr(In, Cnt, Out, Op);
// ROTATE RIGHT MODULE
input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;
input [1:0] Op;
wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = (Op===2'b10)?In:16'hzzzz;
		4'b0001 : assign Out = (Op===2'b10)? {In[0], In[15:1]}:16'hzzzz;
		4'b0010 : assign Out =  (Op===2'b10)?{In[1:0], In[15:2]}:16'hzzzz;
		4'b0011 : assign Out =  (Op===2'b10)?{In[2:0], In[15:3]}:16'hzzzz;
		4'b0100 : assign Out =  (Op===2'b10)?{In[3:0], In[15:4]}:16'hzzzz;
		4'b0101 : assign Out =  (Op===2'b10)?{In[4:0], In[15:5]}:16'hzzzz;
		4'b0110 : assign Out =  (Op===2'b10)?{In[5:0], In[15:6]}:16'hzzzz;
		4'b0111 : assign Out =  (Op===2'b10)?{In[6:0], In[15:7]}:16'hzzzz;
		4'b1000 : assign Out =  (Op===2'b10)?{In[7:0], In[15:8]}:16'hzzzz;
		4'b1001 : assign Out =  (Op===2'b10)?{In[8:0], In[15:9]}:16'hzzzz;
		4'b1010 : assign Out =  (Op===2'b10)?{In[9:0], In[15:10]}:16'hzzzz;
		4'b1011 : assign Out =  (Op===2'b10)?{In[10:0], In[15:11]}:16'hzzzz;
		4'b1100 : assign Out =  (Op===2'b10)?{In[11:0], In[15:12]}:16'hzzzz;
		4'b1101 : assign Out =  (Op===2'b10)?{In[12:0], In[15:13]}:16'hzzzz;
		4'b1110 : assign Out =  (Op===2'b10)?{In[13:0], In[15:14]}:16'hzzzz;
		4'b1111 : assign Out =  (Op===2'b10)?{In[14:0], In[15]}:16'hzzzz;
	endcase
end
endmodule
