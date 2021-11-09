module fulladder_bench;

     reg [16:0] A;
     reg [16:0] B;
     reg [16:0] Sumcalc;

     wire [15:0] S;
     wire        Cout;
     wire	       Clk;
     //2 dummy wires
     wire rst;
     wire err;
     clkrst my_clkrst( .clk(Clk), .rst(rst), .err(err));
     fulladder16 DUT (.A(A[15:0]), .B(B[15:0]), .S(S), .Cout(Cout));


     initial
     begin
          A = 17'b0_0000_0000_0000_0000;
          B = 17'b0_0000_0000_0000_0000;
          #3200 $finish;
     end

     always@(posedge Clk) 
     begin
          A[15:0] = $random;
          B[15:0] = $random;
     end

     always@(negedge Clk)
     begin
          Sumcalc = A+B;
          $display("A : %x, B%x, Sum %x", A, B, S);

          if (Sumcalc[15:0] !== S) $display ("ERRORCHECK Sum error");
          if (Sumcalc[16] !== Cout) $display ("ERRORCHECK Cout error");
     end

endmodule // tb_fulladder
