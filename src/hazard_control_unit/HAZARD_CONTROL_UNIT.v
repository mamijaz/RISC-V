`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/21/2017 05:15:30 PM
// Design Name: 
// Module Name:     HAZARD_CONTROL_UNIT
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


module HAZARD_CONTROL_UNIT #(
        parameter HIGH  = 1'b1  ,
        parameter LOW   = 1'b0
    ) (
        input           INSTRUCTION_CACHE_READY         ,
        input           DATA_CACHE_READY                ,
        input  [4  : 0] RS1_ADDRESS_EXECUTION           ,
        input  [4  : 0] RS2_ADDRESS_EXECUTION           ,
        input  [2  : 0] DATA_CACHE_LOAD_DM1             ,         
        input  [4  : 0] RD_ADDRESS_DM1                  ,
        input  [2  : 0] DATA_CACHE_LOAD_DM2             ,
        input  [4  : 0] RD_ADDRESS_DM2                  ,
        input  [2  : 0] DATA_CACHE_LOAD_DM3             ,
        input  [4  : 0] RD_ADDRESS_DM3                  ,
        output          STALL_PROGRAME_COUNTER_STAGE    ,
        output          STALL_INSTRUCTION_CACHE         ,
        output          STALL_INSTRUCTION_FETCH_STAGE   ,
        output          STALL_DECODING_STAGE            ,
        output          STALL_EXECUTION_STAGE           ,
        output          STALL_DATA_CACHE                ,
        output          STALL_DATA_MEMORY_STAGE                       
    );
    
    always@(*) 
    begin
    end
    
endmodule
