module sra(In, Cnt, Out, Op);
// SHIFT RIGHT ARITHMETIC
input [15:0] In;
input [3:0] Cnt;
output reg [15:0] Out;
input [1:0] Op;
wire [15:0] out;

always@(*) begin
	case(Cnt)
		4'b0000 : assign Out = (Op===2'b10)?In:16'hzzzz;
		4'b0001 : assign Out = (Op===2'b10)? {In[15], In[15:1]}:16'hzzzz;
		4'b0010 : assign Out =  (Op===2'b10)?{{2{In[15]}}, In[15:2]}:16'hzzzz;
		4'b0011 : assign Out =  (Op===2'b10)?{{3{In[15]}}, In[15:3]}:16'hzzzz;
		4'b0100 : assign Out =  (Op===2'b10)?{{4{In[15]}}, In[15:4]}:16'hzzzz;
		4'b0101 : assign Out =  (Op===2'b10)?{{5{In[15]}}, In[15:5]}:16'hzzzz;
		4'b0110 : assign Out =  (Op===2'b10)?{{6{In[15]}}, In[15:6]}:16'hzzzz;
		4'b0111 : assign Out =  (Op===2'b10)?{{7{In[15]}}, In[15:7]}:16'hzzzz;
		4'b1000 : assign Out =  (Op===2'b10)?{{8{In[15]}}, In[15:8]}:16'hzzzz;
		4'b1001 : assign Out =  (Op===2'b10)?{{9{In[15]}}, In[15:9]}:16'hzzzz;
		4'b1010 : assign Out =  (Op===2'b10)?{{10{In[15]}}, In[15:10]}:16'hzzzz;
		4'b1011 : assign Out =  (Op===2'b10)?{{11{In[15]}}, In[15:11]}:16'hzzzz;
		4'b1100 : assign Out =  (Op===2'b10)?{{12{In[15]}}, In[15:12]}:16'hzzzz;
		4'b1101 : assign Out =  (Op===2'b10)?{{13{In[15]}}, In[15:13]}:16'hzzzz;
		4'b1110 : assign Out =  (Op===2'b10)?{{14{In[15]}}, In[15:14]}:16'hzzzz;
		4'b1111 : assign Out =  (Op===2'b10)?{{15{In[15]}}, In[15]}:16'hzzzz;
	endcase
end



endmodule
