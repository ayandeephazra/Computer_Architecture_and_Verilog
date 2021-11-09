module shifter_hier_bench;
   
    reg [15:0] In;
    reg [3:0]  Cnt;
    reg [1:0]  Op;
    wire [15:0] Out;

    reg         fail;

    reg [31:0]  Expected;
    integer     idx;
   
    shifter_hier DUT (.In(In), .Cnt(Cnt), .Op(Op), .Out(Out));

    initial
    begin
        In = 16'h0000;
        Cnt = 4'b0000;
        Op = 2'b00;
        fail = 0;

    #5000;
        if (fail)
            $display("TEST FAILED");
        else
            $display("TEST PASSED");
    $finish;
    end

    always@(posedge DUT.clk)
    begin
        In[15:0] = $random;
        //	In[15:0] = 16'hA0A0;
        Cnt[3:0] = $random;
        Op[1:0] = $random;
    end

   
	always@(negedge DUT.clk)
	begin
	    case (Op)
			2'b00 :
			// Shift Right Arithmetic
			begin
				for(idx = 31; idx > 15 ; idx = idx - 1) Expected[idx] = In[15];
				Expected[15:0] = In[15:0];
				Expected[15:0] = Expected >> Cnt;
				if (Expected[15:0] !== Out) begin
					$display("ERRORCHECK :: Shifter :: Shift Right Arith : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
					fail = 1;
				end
			end
			2'b01 :
			// Shift Right Logical
			begin
			    Expected = In >> Cnt;
			    if (Expected[15:0] !== Out) begin
			        $display("ERRORCHECK :: Shifter :: Shift Right Logic : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
					fail = 1;
				end
			end
			2'b10 :
			// Rotate Left
			begin
			    Expected = In << Cnt | In >> 16-Cnt;
			    if (Expected[15:0] !== Out) begin
			        $display("ERRORCHECK :: Shifter :: Rotate Left       : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
					fail = 1;
				end
			end
			2'b11 :
			// Shift Left
			begin
			    Expected = In << Cnt;
			    if (Expected[15:0] !== Out) begin
			        $display("ERRORCHECK :: Shifter :: Shift Left        : Count : %d, In = %x ; Expected : %x, Got %x", Cnt, In, Expected[15:0], Out);
					fail = 1;
				end
			end
   		endcase
     end  
endmodule // tb_shifter
