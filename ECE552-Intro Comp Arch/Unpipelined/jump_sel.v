module jump_sel (op, enJMP, enJR, enJAL);

  input [4:0] op;
  output reg enJMP;
  output reg enJR;
  output reg enJAL;


  always @(*) begin
    case (op)

      5'b00100: begin
        enJMP = 1'b1;
        enJR = 1'b0;
        enJAL = 1'b0;
      end
      
      
      5'b00110: begin
        enJMP = 1'b1;
        enJR = 1'b0;
        enJAL = 1'b1;
      end

      5'b00101: begin
        enJMP = 1'b0;
        enJR = 1'b1;
        enJAL = 1'b0;
      end

      5'b00111: begin
        enJMP = 1'b0;
        enJR = 1'b1;
        enJAL = 1'b1;
      end
// null case
      default: begin
        enJMP = 1'b0;
        enJR = 1'b0;
        enJAL = 1'b0;
      end
    endcase
  end
endmodule