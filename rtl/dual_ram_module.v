`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:17:24
// Design Name: 
// Module Name: dual_ram_module
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


module dual_ram_module#(
    parameter           P_DATA_WIDTH    =   4   ,
    parameter           P_ADDR_DEPTH    =   128     
)(
    input                                   i_wclk  ,
    input                                   i_wrst  ,
    input                                   i_rclk  ,
    input                                   i_rrst  ,
    input                                   i_ena   ,
    input                                   i_enb   ,
    input  [P_DATA_WIDTH-1 : 0]             i_wdata ,
    input  [clogb2(P_ADDR_DEPTH-1)-1 : 0]   i_waddr ,
    input  [clogb2(P_ADDR_DEPTH-1)-1 : 0]   i_raddr ,
    output [P_DATA_WIDTH-1 : 0]             o_rdata    

);
function integer clogb2 (input integer bit_depth);              
	begin                                                           
	  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	    bit_depth = bit_depth >> 1;                                 
	end                                                           
endfunction 

reg  [P_DATA_WIDTH-1 : 0]   r_reg_ram[P_ADDR_DEPTH-1 : 0];
reg  [P_DATA_WIDTH-1 : 0]   ro_rdata    ;

assign o_rdata = ro_rdata;

integer i;
always @(posedge i_wclk or posedge i_wrst)begin
    if(i_wrst)begin
        for(i = 0; i < P_ADDR_DEPTH; i = i + 1)
            r_reg_ram[i] <= 'd0;
    end
    else if(i_ena)
        r_reg_ram[i_waddr] <= i_wdata;
    else
        r_reg_ram[i_waddr] <= r_reg_ram[i_waddr];
end

always @(posedge i_rclk or posedge i_rrst)begin
    if(i_rrst)
        ro_rdata <= 'd0;
    else if(i_enb)
        ro_rdata <= r_reg_ram[i_raddr];
    else
        ro_rdata <= ro_rdata;
end


endmodule
