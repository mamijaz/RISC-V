`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:12:26 AM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE
// Project Name:    RISC-V
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


module INSTRUCTION_CACHE #(
        parameter HIGH  = 1'b1  ,
        parameter LOW   = 1'b0
   ) (
        input   [31 : 0] PC                         ,
        input            PC_VALID                   ,
        input            INSTRUCTION_CACHE_STALL    ,
        output  [31 : 0] INSTRUCTION                ,
        output           INSTRUCTION_CACHE_READY    
   );
   
endmodule
