/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;
   reg CacheHit, Done, Stall;


   //***FOR STATE LOGIC******//

   wire [4:0] curr_state; 
   reg [4:0] next_state;


  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                            TO LOGIC                                                                //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   wire [2:0] offset;
   wire [7:0] index; 
   reg enable;
   reg comp; 
   reg write;
   wire [4:0] tag_in;
   wire write0, write1;
   wire [15:0] mem_addr; 
   wire valid_in; 
   reg[15:0] cAddr, mem_data_in, cache_data_in;
   reg[4:0] tag_mem;
   reg[2:0] offset_mem;

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                             WIRES AND LOGIC HANDLING                                                //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   wire cache_err, cache_err1, valid, dirty, hit, valid1, dirty1, hit1, hit0, dirty0, valid0, cache_err0; 
   wire [4:0] tag_out, tag_out1, tag_out0; 
   wire [15:0] cache_data_out, cache_data_out1, cache_data_out0; 

   //*****OUTPUTS from four_bank_mem****//
   wire mem_stall;
   wire [3:0] busy; 
   wire mem_err;
   wire[15:0] mem_data_out;

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                             INPUTS TO MEMORY MODULE                                                 //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   reg wr, rd; 

   reg victim;
   wire victimway_in, victimway, access_victim, victim_in;
   reg inv_victim;


   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                             SM STATES                                                               //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   localparam IDLE        = 5'h00;
   localparam COMPRD      = 5'h01;
   localparam COMPWR      = 5'h02;
   localparam WRITEBACK0  = 5'h03;
   localparam WRITEBACK1  = 5'h04;
   localparam WRITEBACK2  = 5'h05;
   localparam WRITEBACK3  = 5'h06;
   localparam MEMREAD0    = 5'h07;
   localparam MEMREAD1    = 5'h08;
   localparam MEMREAD2    = 5'h09;
   localparam MEMREAD3    = 5'h0A;
   localparam STORECACHE0 = 5'h0B;
   localparam STORECACHE1 = 5'h0C;
   localparam STORECACHE2 = 5'h0D;
   localparam STORECACHE3 = 5'h0E; 
   localparam STOREDONE   = 5'h0F;
   localparam ERR         = 5'h10;
   localparam DONE        = 5'h11;
   localparam WRITEMEM    = 5'h12;
   localparam WAITSTATE0  = 5'h13;
   localparam WAITSTATE1  = 5'h14;
   localparam WAITSTATE2  = 5'h15;
   localparam WAITSTATE3  = 5'h16;


  //*********************************//

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (cache_data_out0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (cache_err0),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write0),
                          .valid_in             (1'b1));                     

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (wr),
                     .rd                (rd));

   
   // your code here
   
  // unused buffer
  cache #(2 + mem_type) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (cache_data_out1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (cache_err1),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write1),
                          .valid_in             (1'b1));  
                          
   wire[15:0] access_data_sel, comp_data_sel;
   wire[4:0] access_tag_sel, comp_tag_sel;
   wire hit_sel0, access_dirty_sel, comp_dirty_sel;

   //assign tag_ou1 = 0;
   //assign cache_data_out1 = 0;
   //assign hit1 = 0;
  // assign dirty1 = 0;
   //assign valid1 = 0;
  // assign cache_err1 = 0;
   
   assign hit_sel0 = (hit0 & valid0);
   assign access_data_sel = access_victim ? cache_data_out1 : cache_data_out0;
   assign access_tag_sel = access_victim ? tag_out1 : tag_out0;
   assign comp_tag_sel = victim ? tag_out1 : tag_out0;
   assign access_dirty_sel = access_victim ? dirty1 : dirty0;
   assign comp_dirty_sel = victim ? dirty1 : dirty0;
   assign comp_data_sel = victim ? cache_data_out1 : cache_data_out0;
   //assign comp_data_sel = cache_data_out0;
   //assign comp_dirty_sel = dirty0;
   

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                             CACHE HANDLING CODE                                                     //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   assign cache_err = cache_err0 | cache_err1;
   assign valid = valid0 | valid1;
   
   assign write0 = (hit0 & valid0) ? write : comp ? 1'b0 : access_victim ? 1'b0 : write; 
   assign hit = ((hit0 & valid0) | (hit1 & valid1));
   assign DataOut = hit ? (hit_sel0 ? cache_data_out0 : cache_data_out1) :
       (comp ? comp_data_sel : access_data_sel);
   assign tag_out = hit ? (hit_sel0 ? tag_out0 : tag_out1) :
       (comp ? comp_tag_sel : access_tag_sel);
   assign write1 = (hit1 & valid1) ? write : comp ? 1'b0 : ~access_victim ? 1'b0 : write;

   assign dirty =  hit ? (hit_sel0 ? dirty0 : dirty1) :
       (comp ? comp_dirty_sel : access_dirty_sel);

   assign victimway_in = inv_victim ? ~victimway : victimway;
   assign victim_in = comp ? victim : access_victim; 

   assign mem_addr = {tag_mem, cAddr[10:3], offset_mem};
   assign tag_in = cAddr[15:11];
   assign index = cAddr[10:3];
   assign offset = cAddr[2:0];
   assign err = mem_err | cache_err;

  dff dffmod0 (.q(victimway), .d(victimway_in), .clk(clk), .rst(rst));
  dff dffmod1 [4:0] (.q(curr_state), .d(next_state), .clk(clk), .rst(rst));
  dff dffmod2 (.q(access_victim), .d(victim_in), .clk(clk), .rst(rst));


   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                        SM OUTPUTS HANDLING                                                         //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   always@(*)begin 
   comp = 1'b0;
   enable = 1'b0;
   CacheHit = 1'b0;
   write = 1'b0;
   offset_mem = 3'b000;
   cAddr = Addr;
   tag_mem = Addr[15:11];
   cache_data_in = DataIn;
   mem_data_in = DataOut;
   inv_victim = 1'b0;
   wr = 1'b0;
   rd = 1'b0;
   Done = 1'b0;
   Stall = 1'b1;
   //victim = (hit0 & ~hit1) ? 1'b0 : (~hit0 & hit1) ? 1'b1 : (~hit0 & ~hit1 & valid0 & ~valid1) ? 1'b1 : (~hit0 & ~hit1 & valid0 & valid1) ? victimway : 1'b0;

   victim = ((~hit0 & hit1) | (valid0 & ~valid1)) ? 1'b1 : (hit0 & ~hit1) ? 1'b0 : (valid0 & valid1) ? victimway : 1'b0;

    case(curr_state)


   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //                                             SM                                                                      //
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      IDLE: begin
        enable = 1'b1;
        Stall = 1'b0;
        next_state = (~Rd & ~Wr) ? IDLE : (Rd & ~ Wr) ? COMPRD : (~Rd & Wr) ? COMPWR : ERR;
      end

      COMPRD: begin
      enable = 1'b1;
      comp = 1'b1;
      next_state = (hit & valid) ? DONE : (~dirty & (~hit | ~valid)) ? MEMREAD0 : (dirty) ? WRITEBACK0 : ERR;
      end

      COMPWR: begin
      enable = 1'b1;
      comp = 1'b1;
      write = 1'b1;
      next_state = (hit & valid) ? DONE : (~dirty & (~hit | ~valid)) ? MEMREAD0 : WRITEBACK0;
      end

      WRITEBACK0: begin
      enable = 1'b1;
      comp = 1'b0;
      wr = 1'b1; 
      cAddr = {Addr[15:3], 3'b000};
      tag_mem = tag_out;
      next_state = (mem_stall) ? WRITEBACK0 : WRITEBACK1;
      end

      WRITEBACK1: begin
      enable = 1'b1;
      comp = 1'b0;
      write = 1'b0;
      wr = 1'b1;
      offset_mem = 3'b010;
      tag_mem = tag_out;
      cAddr = {Addr[15:3], 3'b010};
      next_state = (mem_stall) ? WRITEBACK1: WRITEBACK2;
      end

      WRITEBACK2: begin
      enable = 1'b1;
      comp = 1'b0;
      write = 1'b0;
      wr = 1'b1;
      offset_mem = 3'b100;
      tag_mem = tag_out;
      cAddr = {Addr[15:3], 3'b100};
      next_state = (mem_stall) ? WRITEBACK2: WRITEBACK3;
      end


      WRITEBACK3: begin
      enable = 1'b1;
      comp = 1'b0;
      write = 1'b0;
      wr = 1'b1; 
      offset_mem = 3'b110;
      tag_mem = tag_out;
      cAddr = {Addr[15:3], 3'b110};
      next_state = (mem_stall) ? WRITEBACK3: MEMREAD0;
      end

      MEMREAD0: begin
      rd = 1'b1; 
      next_state = (mem_stall) ? MEMREAD0: WAITSTATE0;
      end

      WAITSTATE0: begin
      rd = 1'b1;
      next_state = STORECACHE0;
      end


      MEMREAD1: begin
      rd = 1'b1;
      offset_mem = 3'b010;

      next_state = (mem_stall) ? MEMREAD1: WAITSTATE1;
      end

      WAITSTATE1: begin
      rd = 1'b1;
      next_state = STORECACHE1;
      end

      MEMREAD2: begin

      rd = 1'b1;
      offset_mem = 3'b100;
      next_state = (mem_stall) ? MEMREAD2: WAITSTATE2;
      end

      WAITSTATE2: begin
      rd = 1'b1;
      next_state = STORECACHE2;
      end

      MEMREAD3: begin

      rd = 1'b1;
      offset_mem = 3'b110;
      next_state = (mem_stall) ? MEMREAD3: WAITSTATE3;
      end

      WAITSTATE3: begin
      rd = 1'b1;
      next_state = STORECACHE3;
      end


      STORECACHE0: begin
      enable = 1'b1;
      write = 1'b1;
      cAddr = {Addr[15:3], 3'b000};
      cache_data_in = mem_data_out;
      next_state = MEMREAD1;
      end


      STORECACHE1: begin
      enable = 1'b1;
      write = 1'b1;
      cAddr = {Addr[15:3], 3'b010};
      offset_mem = 3'b010;
      cache_data_in = mem_data_out;
      next_state = MEMREAD2;
      end


      STORECACHE2: begin
      enable = 1'b1;
      write = 1'b1;
      cAddr = {Addr[15:3], 3'b100};
      offset_mem = 3'b100;
      cache_data_in = mem_data_out;
      next_state = MEMREAD3; 
      end

      STORECACHE3: begin
      enable = 1'b1;
      write = 1'b1;
      cAddr = {Addr[15:3], 3'b110};
      offset_mem = 3'b110;
      cache_data_in = mem_data_out;
      next_state = (Wr & ~Rd) ? WRITEMEM : STOREDONE;
      end

      WRITEMEM: begin
        enable = 1'b1;
        comp = 1'b1;
        write = 1'b1;
        next_state = STOREDONE;
      end

      STOREDONE: begin
        enable = 1'b1;
        Done = 1'b1;
        Stall = 1'b0;
        inv_victim = 1'b1;
        next_state = (Wr & ~Rd) ? COMPWR : (Rd & ~Wr) ? COMPRD : IDLE;
      end

      ERR: begin
        next_state = (Rd & Wr) ? ERR : IDLE;
      end

      DONE: begin
        enable = 1'b1;
        Done = 1'b1;
        CacheHit = 1'b1;
        Stall = 1'b0;
        inv_victim = 1'b1;
        next_state = (Wr & ~Rd) ? COMPWR : (Rd & ~Wr) ? COMPRD : IDLE;
      end

      default: begin
      end
    endcase
   end

endmodule // mem_system
// DUMMY LINE FOR REV CONTROL :9:
