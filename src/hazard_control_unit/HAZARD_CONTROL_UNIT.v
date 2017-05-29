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
        parameter   REG_ADD_WIDTH           = 5         ,
        parameter   D_CACHE_LW_WIDTH        = 3         ,
        parameter   D_CACHE_SW_WIDTH        = 2         ,
        
        parameter   HIGH                    = 1'b1      ,
        parameter   LOW                     = 1'b0
    ) (
        input                                   INSTRUCTION_CACHE_READY         ,
        input                                   DATA_CACHE_READY                ,
        input   [REG_ADD_WIDTH -1      : 0]     RS1_ADDRESS_EXECUTION           ,
        input   [REG_ADD_WIDTH -1      : 0]     RS2_ADDRESS_EXECUTION           ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM1             ,
        input   [D_CACHE_SW_WIDTH - 1  : 0]     DATA_CACHE_STORE_DM1            ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM1                  ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM2             ,
        input   [D_CACHE_SW_WIDTH - 1  : 0]     DATA_CACHE_STORE_DM2            ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM2                  ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM3             ,
        input   [D_CACHE_SW_WIDTH - 1  : 0]     DATA_CACHE_STORE_DM3            ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM3                  ,
        output                                  STALL_PROGRAME_COUNTER_STAGE    ,
        output                                  STALL_INSTRUCTION_CACHE         ,
        output                                  STALL_INSTRUCTION_FETCH_STAGE   ,
        output                                  STALL_DECODING_STAGE            ,
        output                                  STALL_EXECUTION_STAGE           ,
        output                                  STALL_DATA_CACHE                ,
        output                                  STALL_DATA_MEMORY_STAGE                       
    );
    
    reg            stall_programe_counter_stage_reg     ;
    reg            stall_instruction_cache_reg          ;
    reg            stall_instruction_fetch_stage_reg    ;
    reg            stall_decoding_stage_reg             ;
    reg            stall_execution_stage_reg            ;
    reg            stall_data_cache_reg                 ;
    reg            stall_data_memory_stage_reg          ;
    
    initial
    begin
        stall_programe_counter_stage_reg    = LOW       ;
        stall_instruction_cache_reg         = LOW       ;
        stall_instruction_fetch_stage_reg   = LOW       ;
        stall_decoding_stage_reg            = LOW       ;
        stall_execution_stage_reg           = LOW       ;
        stall_data_cache_reg                = LOW       ;
        stall_data_memory_stage_reg         = LOW       ;
    end
    
    always@(*) 
    begin
    
    end
    
    assign STALL_PROGRAME_COUNTER_STAGE     = stall_programe_counter_stage_reg      ;
    assign STALL_INSTRUCTION_CACHE          = stall_instruction_cache_reg           ;
    assign STALL_INSTRUCTION_FETCH_STAGE    = stall_instruction_fetch_stage_reg     ;
    assign STALL_DECODING_STAGE             = stall_decoding_stage_reg              ;
    assign STALL_EXECUTION_STAGE            = stall_execution_stage_reg             ;
    assign STALL_DATA_CACHE                 = stall_data_cache_reg                  ;
    assign STALL_DATA_MEMORY_STAGE          = stall_data_memory_stage_reg           ;
    
endmodule
