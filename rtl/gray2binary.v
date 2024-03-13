`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 15:17:44
// Design Name: 
// Module Name: gray2binary
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


module gray2binary#(
    parameter   BIN_WIDTH = 4
)(
    input  [BIN_WIDTH - 1 : 0]  i_binary    ,
    output [BIN_WIDTH - 1 : 0]  o_gray          
);
assign o_gray[BIN_WIDTH - 1] = i_binary[BIN_WIDTH - 1];
genvar i;
generate
    for(i = 1; i < BIN_WIDTH; i = i+1)begin
        assign o_gray[BIN_WIDTH - 1 - i] = i_binary[BIN_WIDTH - 1 - i] ^ o_gray[BIN_WIDTH - i];
    end
endgenerate

endmodule
