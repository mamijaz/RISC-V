`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz 
// 
// Create Date:     05/11/2017 12:23:41 PM
// Design Name: 
// Module Name:     EXECUTION_STAGE
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


module EXECUTION_STAGE #(
        parameter HIGH = 1'b1
    ) (
        input            CLK                        ,
        input            STALL_EXECUTION_STAGE      ,
        input            CLEAR_EXECUTION_STAGE      ,
        input   [31 : 0] PC_IN                      ,
        input   [4  : 0] RS1_ADDRESS                ,
        input   [4  : 0] RS2_ADDRESS                ,
        input   [4  : 0] RD_ADDRESS_IN              ,
        input   [31 : 0] RS1_DATA                   ,
        input   [31 : 0] RS2_DATA                   ,                       
        input   [31 : 0] IMM_OUTPUT                 ,
        input   [4  : 0] SHIFT_AMOUNT               ,
        input   [4  : 0] ALU_INSTRUCTION            ,
        input   [2  : 0] DATA_CACHE_READ_IN         ,
        input   [1  : 0] DATA_CACHE_WRITE_IN        ,
        input            WRITE_BACK_MUX_SELECT_IN   ,
        input            RD_WRITE_ENABLE_IN         ,
        output  [4  : 0] RD_ADDRESS_OUT             ,
        output  [31 : 0] ALU_OUT                    ,
        output  [2  : 0] DATA_CACHE_READ_OUT        ,
        output  [1  : 0] DATA_CACHE_WRITE_OUT       ,
        output  [31 : 0] DATA_CACHE_WRITE_DATA_OUT  ,
        output           WRITE_BACK_MUX_SELECT_OUT  ,
        output           RD_WRITE_ENABLE_OUT           
    );
    
    ALU ALU(
        );
        
    MULTIPLEXER_6_TO_1 MULTIPLEXER_6_TO_1(
        );
        
endmodule
