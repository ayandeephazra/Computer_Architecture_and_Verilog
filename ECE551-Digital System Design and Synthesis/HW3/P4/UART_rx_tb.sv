module UART_rx_tb();

logic clk, rst_n, clk2, rst_n2;
logic RX, TX;
logic clr_rdy;
logic [7:0]rx_data, tx_data;
logic rdy;
// random values
localparam set1 = 8'b01001010;  //test1
localparam set2 = 8'b01101000;	//test2
localparam set3 = 8'b11111110;	//test3
localparam set4 = 8'b11001111;	//test4

UART_tx DUT_TX(.clk(clk) , .rst_n(rst_n), .TX(TX), .trmt(1), .tx_data(tx_data), .tx_done(tx_done)); // Instantiating the transmitter

assign RX = TX; // send the TX bits to the RX

UART_rx DUT_RX(.clk(clk) , .rst_n(rst_n), .RX(RX), .clr_rdy(clr_rdy), .rx_data(rx_data), .rdy(rdy)); // Instantiating the receiver


initial begin
 clr_rdy = 1; // deassert rdy
 clk=0;
 rst_n = 0; // assert reset

 @(posedge clk);
 @(negedge clk);
 rst_n = 1; // deassert reset
 clr_rdy = 0;

 tx_data = set1; // assigning one of the three random sample tx_data set.

 @(posedge rdy)
 if(rx_data == set1) // Checks if tx_data == rx_data
	$display("TEST1: Test passed for test1");
 else
	$display("TEST1: Error for test1");

 clr_rdy = 1; // deassert rdy
 clk=0;
 rst_n = 0; // assert reset

 @(posedge clk);
 @(negedge clk);
 
 rst_n = 1; // deassert reset
 clr_rdy = 0;
 tx_data = set2;  // assigning one of the three random sample tx_data set.

 @(posedge rdy)
 if(rx_data == set2) // Checks if tx_data == rx_data
	$display("TEST2: Test passed for test2");
 else
	$display("TEST2: Error for test2");

 clr_rdy = 1; //
 clk=0;
 rst_n = 0; 

 @(posedge clk);
 @(negedge clk);
 rst_n = 1; 
 clr_rdy = 0;
 tx_data = set3;  

 clr_rdy = 0;
 @(posedge rdy)
 if(rx_data == set3) 
	$display("TEST3: Test passed for test3");
 else
	$display("TEST3: Error for test3");

 $stop;

end

always 
#5 clk = ~clk;

endmodule
