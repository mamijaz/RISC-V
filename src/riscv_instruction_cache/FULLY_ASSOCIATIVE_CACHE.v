`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/13/2017 11:49:08 AM
// Design Name: 
// Module Name:     FULLY_ASSOCIATIVE_CACHE
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


module FULLY_ASSOCIATIVE_CACHE #(
        parameter   BLOCK_WIDTH             = 512                           ,
        parameter   MEMORY_DEPTH            = 512                           ,
        parameter   TAG_WIDTH               = 26                           
    ) (
        input                                       CLK                     ,
        input  [$clog2(MEMORY_DEPTH-1) - 1  : 0]    WRITE_TAG_ADDRESS       ,   
        input  [BLOCK_WIDTH - 1             : 0]    DATA_IN                 ,
        input                                       WRITE_ENABLE            ,
        input  [$clog2(MEMORY_DEPTH-1)-1    : 0]    READ_TAG_ADDRESS        ,                                         
        input                                       READ_ENBLE              , 
        input                                       READ_HIT                ,                                                    
        output [BLOCK_WIDTH - 1             : 0]    DATA_OUT           
    );
endmodule
