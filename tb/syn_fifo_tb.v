`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 11:30:25
// Design Name: 
// Module Name: syn_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module syn_fifo_tb();

reg clk,rst;

always begin
    clk = 0;
    #10;
    clk = 1;
    #10;
end

initial begin
    rst = 1;
    #100;
    @(posedge clk) rst = 0;
end

reg         r_wr_en     ;
reg  [3 :0] r_wdata     ;
reg         r_rd_en     ;

wire [3 :0] w_rdata     ;
wire        w_rempty    ;
wire        w_wfull     ;

wire [3 :0] dout ;
wire        full ;
wire        empty;

syn_fifo_module#(
    .P_DATA_WIDTH   (4          ),
    .P_ADDR_DEPTH   (16         )    
)syn_fifo_module_u0(          
    .i_clk          (clk        ),
    .i_rst          (rst        ),

    .i_wr_en        (r_wr_en    ),
    .i_wdata        (r_wdata    ),
    .o_wfull        (w_wfull    ),

    .i_rd_en        (r_rd_en    ),
    .o_rdata        (w_rdata    ),
    .o_rempty       (w_rempty   ) 
);
fifo_generator_0 fifo_generator_0 (
  .clk  (clk    ),      // input wire clk
  .din  (r_wdata),      // input wire [3 : 0] din
  .wr_en(r_wr_en),  // input wire wr_en
  .rd_en(r_rd_en),  // input wire rd_en
  .dout (dout   ),    // output wire [3 : 0] dout
  .full (full   ),    // output wire full
  .empty(empty  )  // output wire empty
);


task syn_fifo_write(input integer w_len);
begin:syn_fifo_write
    integer i;
    r_wr_en <= 'd0;
    r_wdata <= 'd0;
    r_rd_en <= 'd0;    
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < w_len; i = i + 1)begin
        r_wr_en <= 'd1;
        r_wdata <= r_wdata + 'd1;
        r_rd_en <= 'd0;  
        @(posedge clk);
    end
    r_wr_en <= 'd0;
    r_wdata <= 'd0;
    r_rd_en <= 'd0;    
end
endtask

task syn_fifo_read(input integer w_len);
begin:syn_fifo_read
    integer i;
    r_wr_en <= 'd0;
    r_wdata <= 'd0;
    r_rd_en <= 'd0;    
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < w_len; i = i + 1)begin
        r_wr_en <= 'd0;
        r_wdata <= 'd0;
        r_rd_en <= 'd1;  
        @(posedge clk);
    end
    r_wr_en <= 'd0;
    r_wdata <= 'd0;
    r_rd_en <= 'd0;    
end
endtask

initial begin
    r_wr_en = 'd0;
    r_wdata = 'd0;
    r_rd_en = 'd0;   
    wait(!rst);
    syn_fifo_write(16);
    syn_fifo_read(16);
end

endmodule
