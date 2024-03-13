`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:40:40
// Design Name: 
// Module Name: single_ram_tb
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


module single_ram_tb();

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

reg         r_ena   ;
reg         r_wea   ;
reg  [3 :0] r_wdata ;
reg  [6 :0] r_addr  ;
wire [3 :0] w_rdata ;

single_ram_module#(
    .P_DATA_WIDTH   (4          ) ,
    .P_ADDR_DEPTH   (128        )     
)single_ram_module_u0(
    .i_clk          (clk        ),
    .i_rst          (rst        ),
    .i_ena          (r_ena      ),
    .i_wea          (r_wea      ),
    .i_wdata        (r_wdata    ),
    .i_addr         (r_addr     ),
    .o_rdata        (w_rdata    )   
);


task single_ram_write(input integer w_len);
begin:single_ram_write
    integer i;
    r_ena   <= 'd0;
    r_wea   <= 'd0;
    r_wdata <= 'd0;
    r_addr  <= 'd0;      
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < w_len; i = i + 1)begin
        r_ena   <= 'd1;
        r_wea   <= 'd1;
        r_wdata <= r_wdata + 1;
        r_addr  <= i; 
        @(posedge clk);
    end
    r_ena   <= 'd0;
    r_wea   <= 'd0;
    r_wdata <= 'd0;
    r_addr  <= 'd0;   
end
endtask

task single_ram_read(input integer r_len);
begin:single_ram_read
    integer i;
    r_ena   <= 'd0;
    r_wea   <= 'd0;
    r_addr  <= 'd0;      
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < r_len; i = i + 1)begin
        r_ena   <= 'd1;
        r_wea   <= 'd0;
        r_addr  <= i; 
        @(posedge clk);
    end
    r_ena   <= 'd0;
    r_wea   <= 'd0;
    r_addr  <= 'd0;   
end
endtask

initial begin
    r_ena   = 'd0;
    r_wea   = 'd0;
    r_wdata = 'd0;
    r_addr  = 'd0;
    wait(!rst);
    single_ram_write(10);
    single_ram_read(10);
end

endmodule
