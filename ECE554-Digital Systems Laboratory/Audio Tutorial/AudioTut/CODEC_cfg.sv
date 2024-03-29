/* Make adder for counter */
module CODEC_cfg(clk,rst_n,SDA,SCL,cfg_done);
				   
  input clk, rst_n;

  output reg cfg_done;
  output SCL;			// I2C clock
  inout SDA;			// I2C data
 
  //<< You fill in the implementation >>
  logic [17:0] counter18, sum;
  reg [10:0] cntr_2048cc;
  reg [15:0] cmd;
  logic wrt, rst_2048cc_cntr;
  typedef enum reg [3:0] {IDLE, TIMER, ZERO, ZERO_T, ONE, ONE_T, FOUR, FOUR_T, FIVE, FIVE_T, SIX, SIX_T, SEVEN, SEVEN_T, NINE, NINE_T} state_t;
  state_t state, nxt_state;

  full_adder18 fa18(.a(counter18), .b(18'h00001), .s(sum), .cin(1'b0), .cout());
  
  // state flop
  always_ff @(posedge clk, negedge rst_n)
  if (!rst_n) begin
    state <= IDLE;
    counter18 = 18'h00000;
  end else begin
    counter18 <= sum;
    state <= nxt_state;
  end
  
  // 2048 reusable flop
  always_ff @(posedge clk)
    if (rst_2048cc_cntr)
      cntr_2048cc <= 11'h000;
    else 
      cntr_2048cc <= cntr_2048cc + 1;	

  // state machine
  always_comb begin
    //default outputs
    cfg_done = 0;
    cmd = 0;
    wrt = 0;
    nxt_state = state;
    rst_2048cc_cntr = 0;
    //counter18 = 18'b00000;
    //sum = 18'b00000;  
    
    case(state)
      TIMER: if (counter18 != 18'h3FFFF) begin
                
        //nxt_state same state
      end else
        nxt_state = ZERO;
      ZERO: begin
        cmd = 16'h0105;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = ZERO_T;
      end
      ZERO_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = ONE;  
      ONE: begin
        cmd = 16'h0305;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = ONE_T;
      end
      ONE_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = FOUR;  
      FOUR: begin
        cmd = 16'h0812;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = FOUR_T;
      end
      FOUR_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = FIVE; 
      FIVE: begin
        cmd = 16'h0a06;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = FIVE_T;
      end
      FIVE_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = SIX;  
      SIX: begin
        cmd = 16'h0c62;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = SIX_T;
      end
      SIX_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = SEVEN;
      SEVEN: begin
        cmd = 16'h0e01;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = SEVEN_T;
      end
      SEVEN_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else
        nxt_state = NINE;
      NINE: begin
        cmd = 16'h1201;
        wrt = 1;
        rst_2048cc_cntr = 1;
        nxt_state = NINE_T;
      end
      NINE_T: if (cntr_2048cc != 11'h7FF) begin
        //nxt_state same state
      end else begin
        cfg_done = 1;
        nxt_state = IDLE;
	end
      default: begin
        wrt = 0;
        rst_2048cc_cntr = 0;
        nxt_state = TIMER;
        //nxt_state same state
      end
    endcase
    
  end
  /////////////////////////////
  // Instantiate I2C Master //
  ///////////////////////////
  I2C24Wrt iDUT(.clk(clk),.rst_n(rst_n),.data16(cmd),.wrt(wrt),.done(done),
           .err(err),.SCL(SCL),.SDA(SDA));
 
endmodule
	  