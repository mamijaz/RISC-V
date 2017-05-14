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
        parameter ALU_JALR              = 5'b01011      ,
        
        parameter HIGH                  = 1'b1          ,
        parameter LOW                   = 1'b0
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
    
    reg  [31 : 0] pc_reg                            ;
    reg           clear_decoding_stage_reg          ;
    reg           clear_execution_stage_reg         ;
    reg           pc_rs_1_select_reg                ;
    reg           pc_predict_select_reg             ;
    reg           pc_mispredict_select_reg          ;
    
    wire [31 : 0] pc_predictor_out                  ;
    wire [31 : 0] pc_execution_or_rs_1              ;
    wire [31 : 0] pc_current_plus_4_or_pc_predicted ;
    wire [31 : 0] pc_mispredicted                   ;
    wire [31 : 0] pc_next                           ;
    
    MULTIPLEXER_2_TO_1 PC_EXECUTION_OR_RS_1(
        .IN1(PC_EXECUTION),
        .IN2(RS1_DATA),
        .SELECT(pc_rs_1_select_reg),
        .OUT(pc_execution_or_rs_1) 
        );
    
    MULTIPLEXER_2_TO_1 PC_CURRENT_PLUS_4_OR_PC_PREDICTED(
        .IN1(pc_reg+4),
        .IN2(pc_predictor_out),
        .SELECT(pc_predict_select_reg),
        .OUT(pc_current_plus_4_or_pc_predicted) 
        );
        
    MULTIPLEXER_2_TO_1 PC_MISPREDICTED(
        .IN1(pc_current_plus_4_or_pc_predicted),
        .IN2(pc_execution_or_rs_1),
        .SELECT(pc_mispredict_select_reg),
        .OUT(pc_next) 
        );
    
    always@(*)
    begin
    
    end
    
    always@(posedge CLK)
    begin
        pc_reg <= pc_next;
    end
    
    assign PC                       = pc_reg                    ;
    assign CLEAR_DECODING_STAGE     = clear_decoding_stage_reg  ;
    assign CLEAR_EXECUTION_STAGE    = clear_execution_stage_reg ;
            
endmodule
