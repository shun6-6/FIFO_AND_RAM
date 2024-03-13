`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 09:17:24
// Design Name: 
// Module Name: single_ram_module
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


module single_ram_module#(
    parameter           P_DATA_WIDTH    =   4   ,
    parameter           P_ADDR_DEPTH    =   128     
)(
    input                                   i_clk   ,
    input                                   i_rst   ,
    input                                   i_ena   ,
    input                                   i_wea   ,
    input  [P_DATA_WIDTH-1 : 0]             i_wdata ,
    input  [clogb2(P_ADDR_DEPTH-1)-1 : 0]   i_addr  ,
    output [P_DATA_WIDTH-1 : 0]             o_rdata    

);

function integer clogb2 (input integer bit_depth);              
	begin                                                           
	  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	    bit_depth = bit_depth >> 1;                                 
	end                                                           
endfunction 

reg  [P_DATA_WIDTH-1 : 0]   r_reg_ram[P_ADDR_DEPTH-1 : 0];

assign o_rdata = (i_ena && !i_wea) ? r_reg_ram[i_addr] : 'd0;

integer i;
always @(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        for(i = 0; i < P_ADDR_DEPTH; i = i + 1)
            r_reg_ram[i] <= 'd0;
    end
    else if(i_ena && i_wea)
        r_reg_ram[i_addr] <= i_wdata;
    else
        r_reg_ram[i_addr] <= r_reg_ram[i_addr];
end

endmodule
