module SPI_mnrch_tb();

    logic SS_n;				// active low serf select
    logic SCLK;				// Serial clock
    logic MOSI;				// serial data in from monarch
    logic MISO;				// serial data out to monarch
    logic INT;			// interrupt output
	
	
	logic clk;
	logic rst_n;
	logic [15:0] wt_data;
	logic wrt;
	logic [15:0] rd_data;
	logic done;
  
	SPI_iNEMO1 NEMO(.SS_n(SS_n),.SCLK(SCLK),.MISO(MISO),.MOSI(MOSI),.INT(INT));
	SPI_mnrch SPI(.wrt(wrt), .wt_data(wt_data), .done(done), .rd_data(rd_data), .clk(clk), .rst_n(rst_n), .SS_n(SS_n), .SCLK(SCLK), .MOSI(MOSI), .MISO(MISO));
	
	
	initial begin
	
	SS_n = 0;
	wrt = 0;
	clk = 0;
	rst_n = 0;
	
	@ (posedge clk);
	
	rst_n = 1;
	wt_data = 16'h8fxx;
	
	repeat(60000) @ (posedge clk);
	while(done==0) @ (posedge done);
	
	
	
	$stop;
	end

	always #5 clk = ~clk;


endmodule