`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:17:24
// Design Name: 
// Module Name: syn_fifo_module
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


module syn_fifo_module#(
    parameter                       P_DATA_WIDTH    =   4   ,
    parameter                       P_ADDR_DEPTH    =   16     
)(          
    input                           i_clk       ,
    input                           i_rst       ,

    input                           i_wr_en     ,
    input  [P_DATA_WIDTH-1 : 0]     i_wdata     ,
    output                          o_wfull     ,

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

// reg  [clogb2(P_ADDR_DEPTH-1)-1 : 0] r_waddr;
// reg  [clogb2(P_ADDR_DEPTH-1)-1 : 0] r_raddr;
//拓展1bit读写地址位宽，以此判断读空和写满状态
reg  [clogb2(P_ADDR_DEPTH-1) : 0]   r_waddr     ;
reg  [clogb2(P_ADDR_DEPTH-1) : 0]   r_raddr     ;
reg                                 ro_wfull    ;
reg                                 ro_rempty   ;

// assign o_wfull  = ro_wfull ;
// assign o_rempty = ro_rempty;
assign o_wfull  = r_raddr == {!r_waddr[clogb2(P_ADDR_DEPTH-1)],r_waddr[clogb2(P_ADDR_DEPTH-1)-1:0]};
assign o_rempty = r_raddr == r_waddr;

dual_ram_module#(
    .P_DATA_WIDTH   (P_DATA_WIDTH   ),
    .P_ADDR_DEPTH   (P_ADDR_DEPTH   )     
)dual_ram_module_u0(
    .i_clk          (i_clk      ),
    .i_rst          (i_rst      ),
    .i_ena          (i_wr_en && !o_wfull    ),
    .i_enb          (i_rd_en && !o_rempty   ),
    .i_wdata        (i_wdata    ),
    .i_waddr        (r_waddr[clogb2(P_ADDR_DEPTH-1)-1:0]),
    .i_raddr        (r_raddr[clogb2(P_ADDR_DEPTH-1)-1:0]),
    .o_rdata        (o_rdata    )   

);

//写数据逻辑
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_waddr <= 'd0;
    else if(i_wr_en && !o_wfull)
        r_waddr <= r_waddr + 'd1;
    else
        r_waddr <= r_waddr;
end
//写满指示
// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)
//         ro_wfull <= 'd0;
//     else if(r_raddr == {!r_waddr[clogb2(P_ADDR_DEPTH-1)],r_waddr[clogb2(P_ADDR_DEPTH-1)-1:0]})
//         ro_wfull <= 'd1;
//     else
//         ro_wfull <= 'd0;
// end
//读数据逻辑
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)
        r_raddr <= 'd0;
    else if(i_rd_en && !o_rempty)
        r_raddr <= r_raddr + 'd1;
    else
        r_raddr <= r_raddr;
end
//读空指示
// always @(posedge i_clk or posedge i_rst)begin
//     if(i_rst)
//         ro_rempty <= 'd0;
//     else if(r_raddr == r_waddr)
//         ro_rempty <= 'd1;
//     else
//         ro_rempty <= 'd0;
// end


endmodule
