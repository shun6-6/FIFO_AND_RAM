`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/13 15:17:44
// Design Name: 
// Module Name: binary2gray
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


module binary2gray#(
    parameter   BIN_WIDTH = 4
)(
    input  [BIN_WIDTH - 1 : 0]  i_binary    ,
    output [BIN_WIDTH - 1 : 0]  o_gray          
);

assign o_gray = (i_binary >> 1) ^ i_binary;

endmodule
