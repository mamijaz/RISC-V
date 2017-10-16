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
        
        parameter   DATA_CACHE_LOAD_NONE    = 3'b000    ,
        
        parameter   HIGH                    = 1'b1      ,
        parameter   LOW                     = 1'b0
    ) (
        input                                   INSTRUCTION_CACHE_READY         ,
        input                                   DATA_CACHE_READY                ,
        input                                   PC_MISPREDICTED                 ,
        input   [REG_ADD_WIDTH -1      : 0]     RS1_ADDRESS_EXECUTION           ,
        input   [REG_ADD_WIDTH -1      : 0]     RS2_ADDRESS_EXECUTION           ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM1             ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM1                  ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM2             ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM2                  ,
        input   [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD_DM3             ,
        input   [REG_ADD_WIDTH -1      : 0]     RD_ADDRESS_DM3                  ,
        output                                  CLEAR_INSTRUCTION_FETCH_STAGE   ,
        output                                  CLEAR_DECODING_STAGE            ,
        output                                  CLEAR_EXECUTION_STAGE           ,
        output                                  STALL_PROGRAME_COUNTER_STAGE    ,
        output                                  STALL_INSTRUCTION_CACHE         ,
        output                                  STALL_INSTRUCTION_FETCH_STAGE   ,
        output                                  STALL_DECODING_STAGE            ,
        output                                  STALL_EXECUTION_STAGE           ,
        output                                  STALL_DATA_MEMORY_STAGE                       
    );
    
    reg             clear_instruction_fetch_stage_reg       ;
    reg             clear_decoding_stage_reg                ;
    reg             clear_execution_stage_reg               ;
    reg             stall_programe_counter_stage_reg        ;
    reg             stall_instruction_cache_reg             ;
    reg             stall_instruction_fetch_stage_reg       ;
    reg             stall_decoding_stage_reg                ;
    reg             stall_execution_stage_reg               ;
    reg             stall_data_memory_stage_reg             ;
    
    initial
    begin
        clear_instruction_fetch_stage_reg   = LOW       ;
        clear_decoding_stage_reg            = LOW       ;
        clear_execution_stage_reg           = LOW       ;
        stall_programe_counter_stage_reg    = LOW       ;
        stall_instruction_cache_reg         = LOW       ;
        stall_instruction_fetch_stage_reg   = LOW       ;
        stall_decoding_stage_reg            = LOW       ;
        stall_execution_stage_reg           = LOW       ;
        stall_data_memory_stage_reg         = LOW       ;
    end
    
    always@(*) 
    begin
        if(PC_MISPREDICTED == HIGH)
        begin
            clear_instruction_fetch_stage_reg   = HIGH      ;
            clear_decoding_stage_reg            = HIGH      ;
        end
        else
        begin
            clear_instruction_fetch_stage_reg   = LOW       ;
            clear_decoding_stage_reg            = LOW       ;
        end
 
        if((((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM1) | (RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM1))& DATA_CACHE_LOAD_DM1 != DATA_CACHE_LOAD_NONE) | (((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM2) | (RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM2))& DATA_CACHE_LOAD_DM2 != DATA_CACHE_LOAD_NONE) | (((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM3) | (RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM3))& DATA_CACHE_LOAD_DM3 != DATA_CACHE_LOAD_NONE)) 
        begin
            clear_decoding_stage_reg            = LOW       ;
            clear_execution_stage_reg           = HIGH      ;
            stall_programe_counter_stage_reg    = HIGH      ;
            stall_instruction_cache_reg         = HIGH      ;
            stall_instruction_fetch_stage_reg   = HIGH      ;
            stall_decoding_stage_reg            = HIGH      ;
            stall_execution_stage_reg           = HIGH      ;
        end
        else if(INSTRUCTION_CACHE_READY == LOW)
        begin
            clear_decoding_stage_reg            = HIGH      ;
            clear_execution_stage_reg           = LOW       ;
            stall_programe_counter_stage_reg    = HIGH      ;
            stall_instruction_cache_reg         = LOW       ;
            stall_instruction_fetch_stage_reg   = HIGH      ;
            stall_decoding_stage_reg            = HIGH      ;
            stall_execution_stage_reg           = LOW       ;
        end
        else
        begin
            clear_decoding_stage_reg            = LOW       ;
            clear_execution_stage_reg           = LOW       ;
            stall_programe_counter_stage_reg    = LOW       ;
            stall_instruction_cache_reg         = LOW       ;
            stall_instruction_fetch_stage_reg   = LOW       ;
            stall_decoding_stage_reg            = LOW       ;
            stall_execution_stage_reg           = LOW       ;
        end
    end
    
    assign CLEAR_INSTRUCTION_FETCH_STAGE    = clear_instruction_fetch_stage_reg     ;
    assign CLEAR_DECODING_STAGE             = clear_decoding_stage_reg              ;
    assign CLEAR_EXECUTION_STAGE            = clear_execution_stage_reg             ;
    assign STALL_PROGRAME_COUNTER_STAGE     = stall_programe_counter_stage_reg      ;
    assign STALL_INSTRUCTION_CACHE          = stall_instruction_cache_reg           ;
    assign STALL_INSTRUCTION_FETCH_STAGE    = stall_instruction_fetch_stage_reg     ;
    assign STALL_DECODING_STAGE             = stall_decoding_stage_reg              ;
    assign STALL_EXECUTION_STAGE            = stall_execution_stage_reg             ;
    assign STALL_DATA_MEMORY_STAGE          = stall_data_memory_stage_reg           ;
    
endmodule
