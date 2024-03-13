`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:40:40
// Design Name: 
// Module Name: dual_ram_tb
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


module dual_ram_tb();

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

reg         r_dual_ena      ;
reg         r_dual_enb      ;
reg  [3 :0] r_dual_wdata    ;
reg  [6 :0] r_dual_waddr    ;
reg  [6 :0] r_dual_raddr    ;
wire [3 :0] w_dual_rdata    ;

dual_ram_module#(
    .P_DATA_WIDTH   (4              ),
    .P_ADDR_DEPTH   (128            )     
)dual_ram_module_u0(
    .i_wclk         (clk            ),
    .i_wrst         (rst            ),
    .i_rclk         (clk            ),
    .i_rrst         (rst            ),
    .i_ena          (r_dual_ena     ),
    .i_enb          (r_dual_enb     ),
    .i_wdata        (r_dual_wdata   ),
    .i_waddr        (r_dual_waddr   ),
    .i_raddr        (r_dual_raddr   ),
    .o_rdata        (w_dual_rdata   )   

);

task dual_ram_write(input integer w_len);
begin:dual_ram_write
    integer i;
    r_dual_ena   <= 'd0;
    r_dual_enb   <= 'd0;
    r_dual_wdata <= 'd0;
    r_dual_waddr <= 'd0;
    r_dual_raddr <= 'd0;   
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < w_len; i = i + 1)begin
        r_dual_ena   <= 'd1;
        r_dual_enb   <= 'd0;
        r_dual_wdata <= r_dual_wdata + 'd1;
        r_dual_waddr <= i;
        r_dual_raddr <= 'd0; 
        @(posedge clk);
    end
    r_dual_ena   <= 'd0;
    r_dual_enb   <= 'd0;
    r_dual_wdata <= 'd0;
    r_dual_waddr <= 'd0;
    r_dual_raddr <= 'd0;   
end
endtask

task dual_ram_read(input integer r_len);
begin:dual_ram_read
    integer i;
    r_dual_ena   <= 'd0;
    r_dual_enb   <= 'd0;
    r_dual_wdata <= 'd0;
    r_dual_waddr <= 'd0;
    r_dual_raddr <= 'd0;     
    wait(!rst);
    @(posedge clk);
    for(i = 0; i < r_len; i = i + 1)begin
        r_dual_ena   <= 'd0;
        r_dual_enb   <= 'd1;
        r_dual_wdata <= 'd0;
        r_dual_waddr <= 'd0;
        r_dual_raddr <= i; 
        @(posedge clk);
    end
    r_dual_ena   <= 'd0;
    r_dual_enb   <= 'd0;
    r_dual_wdata <= 'd0;
    r_dual_waddr <= 'd0;
    r_dual_raddr <= 'd0;   
end
endtask

initial begin
    r_dual_ena   = 'd0;
    r_dual_enb   = 'd0;
    r_dual_wdata = 'd0;
    r_dual_waddr = 'd0;
    r_dual_raddr = 'd0; 
    wait(!rst);
    dual_ram_write(10);
    dual_ram_read(10);
end

endmodule