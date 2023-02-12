module CODEC_cfg_tb();

  reg clk,rst_n;
 
  wire SDA,SCL;
  reg ack;
  reg cfg_done;
  

  assign (strong0,weak1) SDA = (ack) ? 1'b0 : 1'b1;
  
  ///////////////////////////////assign DUT///////////////////////////////////////////
  
  CODEC_cfg iDUT(.clk(clk), .rst_n(rst_n), .SDA(SDA), .SCL(SCL), .cfg_done(cfg_done));

  initial begin

    rst_n = 0;
	clk = 0;
	ack = 0;
	
	@(negedge clk);
	rst_n = 1;

	repeat (262144) @ (posedge clk) begin
		$display("18 bit counter counting up...");
	end
	$display("18 bit counter maxed out!");

	repeat(7) begin
		
			
			repeat (9) @ (posedge SCL);
			ack = 1;
			@ (negedge SCL);
			ack = 0;
			
			repeat (9) @ (posedge SCL);
			ack = 1;
			@ (negedge SCL);
			ack = 0;
			
			repeat (9) @ (posedge SCL);
			ack = 1;
			@ (negedge SCL);
			ack = 0;
						
			@(posedge SCL);
			
			$display("CMD done");
				
		
	end
	
	$stop();
		
  end
  
  always
    #5 clk = ~clk;

endmodule

