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
    
    reg  [31 : 0] PC_REG                            ;
    reg           CLEAR_DECODING_STAGE_REG          ;
    reg           CLEAR_EXECUTION_STAGE_REG         ;
    reg  [31 : 0] IMM_ALIGNED_REG                   ;
    reg           PC_RS_1_SELECT_REG                ;
    reg           PC_PREDICT_SELECT_REG             ;
    reg           PC_MISPREDICT_SELECT_REG          ;
    
    wire [31 : 0] pc_predictor_out                  ;
    wire [31 : 0] pc_execution_or_rs_1              ;
    wire [31 : 0] pc_current_plus_4_or_pc_predicted ;
    wire [31 : 0] pc_mispredicted                   ;
    wire [31 : 0] pc_next                           ;
    
    MULTIPLEXER_2_TO_1 PC_EXECUTION_OR_RS_1(
        .IN1(PC_EXECUTION),
        .IN2(RS1_DATA),
        .SELECT(PC_RS_1_SELECT_REG),
        .OUT(pc_execution_or_rs_1) 
        );
    
    MULTIPLEXER_2_TO_1 PC_CURRENT_PLUS_4_OR_PC_PREDICTED(
        .IN1(PC_REG+4),
        .IN2(pc_predictor_out),
        .SELECT(PC_PREDICT_SELECT_REG),
        .OUT(pc_current_plus_4_or_pc_predicted) 
        );
        
    MULTIPLEXER_2_TO_1 PC_MISPREDICTED(
        .IN1(pc_current_plus_4_or_pc_predicted),
        .IN2(pc_execution_or_rs_1),
        .SELECT(PC_MISPREDICT_SELECT_REG),
        .OUT(pc_next) 
        );
    
    always@(*)
    begin
    
    end
    
    always@(posedge CLK)
    begin
        PC_REG <= pc_next;
    end
    
    assign PC                       = PC_REG                    ;
    assign CLEAR_DECODING_STAGE     = CLEAR_DECODING_STAGE_REG  ;
    assign CLEAR_EXECUTION_STAGE    = CLEAR_EXECUTION_STAGE_REG ;
            
endmodule
