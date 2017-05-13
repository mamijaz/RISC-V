`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/13/2017 06:08:14 PM
// Design Name: 
// Module Name:     PROGRAME_COUNTER_STAGE
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


module PROGRAME_COUNTER_STAGE #(
        parameter ALU_JAL               = 5'b01010      ,
        parameter ALU_JALR              = 5'b01011      
    ) (
        input            CLK                        ,
        input            STALL_EXECUTION_STAGE      ,
        input  [4  : 0]  ALU_INSTRUCTION            ,
        input            BRANCH_TAKEN               ,
        input  [31 : 0]  PC_EXECUTION               ,
        input  [31 : 0]  RS1_DATA                   ,
        input  [31 : 0]  IMM_INPUT                  ,
        input  [31 : 0]  PC_DECODING                ,
        output [31 : 0]  PC                         ,
        output           CLEAR_DECODING_STAGE       ,
        output           CLEAR_EXECUTION_STAGE
    );
endmodule
