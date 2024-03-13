`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:17:24
// Design Name: 
// Module Name: asyn_fifo_module
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


module asyn_fifo_module#(
    parameter                       P_DATA_WIDTH    =   4   ,
    parameter                       P_ADDR_DEPTH    =   16     
)(          
    input                           i_wclk      ,
    input                           i_wrst      ,
    input                           i_wr_en     ,
    input  [P_DATA_WIDTH-1 : 0]     i_wdata     ,
    output                          o_wfull     ,

    input                           i_rclk      ,
    input                           i_rrst      ,
    input                           i_rd_en     ,
    output [P_DATA_WIDTH-1 : 0]     o_rdata     ,
    output                          o_rempty    
);

function integer clogb2(input integer bit_depth);
begin
    for(clogb2 = 0; bit_depth>0; clogb2 = clogb2 + 1)
        bit_depth = bit_depth >> 1;
end
endfunction

localparam P_ADDR_WIDTH = clogb2(P_ADDR_DEPTH-1);

//拓展1bit读写地址位宽，以此判断读空和写满状态
reg  [P_ADDR_WIDTH : 0]   r_waddr         ;
reg  [P_ADDR_WIDTH : 0]   r_raddr         ;
reg  [P_ADDR_WIDTH : 0]   r_gray_waddr    ;
reg  [P_ADDR_WIDTH : 0]   r_gray_raddr    ;

reg  [P_ADDR_WIDTH : 0]   r_gray_waddr_1d ;
reg  [P_ADDR_WIDTH : 0]   r_gray_waddr_2d ;
reg  [P_ADDR_WIDTH : 0]   r_gray_raddr_1d ;
reg  [P_ADDR_WIDTH : 0]   r_gray_raddr_2d ;

wire [P_ADDR_WIDTH : 0]   w_gray_waddr    ;
wire [P_ADDR_WIDTH : 0]   w_gray_raddr    ;

dual_ram_module#(
    .P_DATA_WIDTH   (P_DATA_WIDTH   ),
    .P_ADDR_DEPTH   (P_ADDR_DEPTH   )     
)dual_ram_module_u0(
    .i_wclk         (i_wclk     ),
    .i_wrst         (i_wrst     ),
    .i_rclk         (i_rclk     ),
    .i_rrst         (i_rrst     ),
    .i_ena          (i_wr_en && !o_wfull    ),
    .i_enb          (i_rd_en && !o_rempty   ),
    .i_wdata        (i_wdata    ),
    .i_waddr        (r_waddr[P_ADDR_WIDTH-1:0]),
    .i_raddr        (r_raddr[P_ADDR_WIDTH-1:0]),
    .o_rdata        (o_rdata    )   
);

binary2gray#(
    .BIN_WIDTH  (P_ADDR_WIDTH + 1   )
)binary2gray_waddr(
    .i_binary   (r_waddr            ),
    .o_gray     (w_gray_waddr       )    
);
binary2gray#(
    .BIN_WIDTH  (P_ADDR_WIDTH + 1   )
)binary2gray_raddr(
    .i_binary   (r_raddr            ),
    .o_gray     (w_gray_raddr       )           
);

assign o_wfull  = r_gray_waddr == {~r_gray_raddr_2d[P_ADDR_WIDTH:P_ADDR_WIDTH-1],r_gray_raddr_2d[P_ADDR_WIDTH-2:0]};
assign o_rempty = r_gray_raddr == r_gray_waddr_2d;

//写地址逻辑
always @(posedge i_wclk or posedge i_wrst)begin
    if(i_wrst)
        r_waddr <= 'd0;
    else if(i_wr_en && !o_wfull)
        r_waddr <= r_waddr + 'd1;
    else
        r_waddr <= r_waddr;
end

//读数据逻辑
always @(posedge i_rclk or posedge i_rrst)begin
    if(i_rrst)
        r_raddr <= 'd0;
    else if(i_rd_en && !o_rempty)
        r_raddr <= r_raddr + 'd1;
    else
        r_raddr <= r_raddr;
end

//读地址指针跨至写时钟域
always @(posedge i_rclk or posedge i_rrst)begin
    if(i_rrst)
        r_gray_raddr <= 'd0;
    else
        r_gray_raddr <= w_gray_raddr;
end

always @(posedge i_wclk or posedge i_wrst)begin
    if(i_wrst)begin
        r_gray_raddr_1d <= 'd0;
        r_gray_raddr_2d <= 'd0;
    end
    else begin
        r_gray_raddr_1d <= r_gray_raddr;
        r_gray_raddr_2d <= r_gray_raddr_1d;
    end
end
//写地址指针跨至读时钟域
always @(posedge i_wclk or posedge i_wrst)begin
    if(i_wrst)
        r_gray_waddr <= 'd0;
    else
        r_gray_waddr <= w_gray_waddr;
end

always @(posedge i_rclk or posedge i_rrst)begin
    if(i_rrst)begin
        r_gray_waddr_1d <= 'd0;
        r_gray_waddr_2d <= 'd0;
    end
    else begin
        r_gray_waddr_1d <= r_gray_waddr;
        r_gray_waddr_2d <= r_gray_waddr_1d;
    end
end

endmodule
