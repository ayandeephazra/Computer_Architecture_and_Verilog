module CommTB();
logic clk, rst_n;		// clock and active low reset
logic RX;				// serial data input
logic send_cmd;			// indicates to tranmit 24-bit command (cmd)
//logic [15:0] cmd;		// 16-bit command

logic TX;				// serial data output
logic cmd_sent;		// indicates transmission of command complete
logic resp_rdy;		// indicates 8-bit response has been received
logic [7:0] resp;		// 8-bit response from DUT

wire [7:0] tx_data;		// 8-bit data to send to UART
wire tx_done;			// indicates 8-bit was sent over UART
wire rx_rdy;			// indicates 8-bit response is ready from UART

logic clr_cmd_rdy;
logic trmt;
logic [15:0] cmd_in, cmd_out;
logic cmd_rdy;
logic [7:0] resp_UART;
RemoteComm RC(.clk(clk), .rst_n(rst_n), .RX(RX), .TX(TX), .cmd(cmd_in), .send_cmd(send_cmd), .cmd_sent(cmd_sent), .resp_rdy(resp_rdy), .resp());
UART_wrapper UW(.clr_cmd_rdy(clr_cmd_rdy), .clk(clk), .rst_n(rst_n), .trmt(trmt), .RX(TX),.resp(resp_UART),.tx_done(tx_done), .TX(RX), .cmd_rdy(cmd_rdy),.cmd(cmd_out));

initial begin

clk = 0;
rst_n = 0;
send_cmd = 0;
clr_cmd_rdy = 1;
@(posedge clk);

// TEST1
trmt = 1;
rst_n = 1;
send_cmd = 1;
cmd_in = 16'hff00;
@(posedge clk);
send_cmd = 0;
// till cmd_rdy has a posedge
while(cmd_rdy==0) @ (posedge cmd_rdy);
if(cmd_in === cmd_out)
$display("PASS1: basic RemoteComm to UART_Wrapper transmission successful for cmd_in of 0x%h.", cmd_in);
else
$display("FAIL1: basic RemoteComm to UART_wrapper transmission failed. cmd_in:0x%h & cmd_out:0x%h", cmd_in, cmd_out);
// END TEST1

@(posedge clk);
trmt = 0;
rst_n = 0;
send_cmd = 0;
clr_cmd_rdy = 1;
@(posedge clk);

// TEST2
trmt = 1;
rst_n = 1;
send_cmd = 1;
cmd_in = 16'hfff0;
@(posedge clk);
send_cmd = 0;
// till cmd_rdy has a posedge
repeat(70000) @ (posedge clk);
while(cmd_rdy==0) @ (posedge cmd_rdy);
if(cmd_in === cmd_out)
$display("PASS2: basic RemoteComm to UART_Wrapper transmission successful for cmd_in of 0x%h.", cmd_in);
else
$display("FAIL2: basic RemoteComm to UART_wrapper transmission failed. cmd_in:0x%h & cmd_out:0x%h", cmd_in, cmd_out);
// END TEST2

@(posedge clk);
trmt = 0;
rst_n = 0;
send_cmd = 0;
clr_cmd_rdy = 1;
@(posedge clk);

// TEST3
trmt = 1;
rst_n = 1;
send_cmd = 1;
cmd_in = 16'hffff;
@(posedge clk);
send_cmd = 0;
// till cmd_rdy has a posedge
repeat(80000) @ (posedge clk);
while(cmd_rdy==0) @ (posedge cmd_rdy);
if(cmd_in === cmd_out)
$display("PASS3: basic RemoteComm to UART_Wrapper transmission successful for cmd_in of 0x%h.", cmd_in);
else
$display("FAIL3: basic RemoteComm to UART_wrapper transmission failed. cmd_in:0x%h & cmd_out:0x%h", cmd_in, cmd_out);
// END TEST3

$stop;
end
always #5 clk = ~clk;
endmodule
