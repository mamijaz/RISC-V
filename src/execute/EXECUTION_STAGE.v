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
        input   [31 : 0] IMM_DATA                   ,
        input   [4  : 0] SHIFT_AMOUNT               ,
        input   [4  : 0] ALU_INSTRUCTION            ,
        input   [2  : 0] DATA_CACHE_LOAD_IN         ,
        input   [1  : 0] DATA_CACHE_STORE_IN        ,
        input   [31 : 0] DATA_CACHE_STORE_DATA_IN   ,
        input            WRITE_BACK_MUX_SELECT_IN   ,
        input            RD_WRITE_ENABLE_IN         ,
        input   [2  : 0] ALU_IN1_MUX_SELECT         ,
        input   [2  : 0] ALU_IN2_MUX_SELECT         ,
        input   [31 : 0] RS1_DATA_DM1               ,
        input   [31 : 0] RS1_DATA_DM2               ,
        input   [31 : 0] RS1_DATA_DM3               ,
        input   [31 : 0] RS1_DATA_WB                ,
        input   [31 : 0] RS2_DATA_DM1               ,
        input   [31 : 0] RS2_DATA_DM2               ,
        input   [31 : 0] RS2_DATA_DM3               ,
        input   [31 : 0] RS2_DATA_WB                ,
        output  [4  : 0] RD_ADDRESS_OUT             ,
        output  [31 : 0] ALU_OUT                    ,
        output  [1  : 0] BRANCH_TAKEN               ,
        output  [2  : 0] DATA_CACHE_LOAD_OUT        ,
        output  [1  : 0] DATA_CACHE_STORE_OUT       ,
        output  [31 : 0] DATA_CACHE_STORE_DATA_OUT  ,
        output           WRITE_BACK_MUX_SELECT_OUT  ,
        output           RD_WRITE_ENABLE_OUT           
    );
    
    reg  [4  : 0] RD_ADDRESS_OUT_REG                ;
    reg  [31 : 0] ALU_OUT_REG                       ;
    reg  [2  : 0] DATA_CACHE_LOAD_OUT_REG           ;
    reg  [1  : 0] DATA_CACHE_STORE_OUT_REG          ;
    reg  [31 : 0] DATA_CACHE_STORE_DATA_OUT_REG     ;
    reg           WRITE_BACK_MUX_SELECT_OUT_REG     ;
    reg           RD_WRITE_ENABLE_OUT_REG           ;
    
    wire [31 : 0] alu_in1                           ;
    wire [31 : 0] alu_in2                           ;
    wire [31 : 0] alu_out                           ;   
        
    MULTIPLEXER_6_TO_1 ALU_IN1_MUX(
        .IN1(RS1_DATA),
        .IN2(PC_IN),
        .IN3(RS1_DATA_DM1),
        .IN4(RS1_DATA_DM2),
        .IN5(RS1_DATA_DM3),
        .IN6(RS1_DATA_WB),
        .SELECT(ALU_IN1_MUX_SELECT),
        .OUT(alu_in1)
        );
    
    MULTIPLEXER_6_TO_1 ALU_IN2_MUX(
        .IN1(RS2_DATA),
        .IN2(IMM_DATA),
        .IN3(RS2_DATA_DM1),
        .IN4(RS2_DATA_DM2),
        .IN5(RS2_DATA_DM3),
        .IN6(RS2_DATA_WB),
        .SELECT(ALU_IN2_MUX_SELECT),
        .OUT(alu_in2)
        );
    
    ALU ALU(
        .ALU_IN1(alu_in1),
        .ALU_IN2(alu_in2),
        .SHIFT_AMOUNT(SHIFT_AMOUNT),
        .ALU_INSTRUCTION(ALU_INSTRUCTION),
        .ALU_OUT(alu_out),
        .BRANCH_TAKEN(BRANCH_TAKEN)
        );
        
    always@(posedge CLK) 
    begin
        if(STALL_EXECUTION_STAGE != HIGH)
        begin
            RD_ADDRESS_OUT_REG             <= RD_ADDRESS_IN;
            ALU_OUT_REG                    <= alu_out;
            DATA_CACHE_LOAD_OUT_REG        <= DATA_CACHE_LOAD_IN;
            DATA_CACHE_STORE_OUT_REG       <= DATA_CACHE_STORE_IN;
            DATA_CACHE_STORE_DATA_OUT_REG  <= DATA_CACHE_STORE_DATA_IN;
            WRITE_BACK_MUX_SELECT_OUT_REG  <= WRITE_BACK_MUX_SELECT_IN;
            RD_WRITE_ENABLE_OUT_REG        <= RD_WRITE_ENABLE_IN;
        end
    end
    
    assign RD_ADDRESS_OUT                   = RD_ADDRESS_OUT_REG            ;
    assign ALU_OUT                          = ALU_OUT_REG                   ;
    assign DATA_CACHE_LOAD_OUT              = DATA_CACHE_LOAD_OUT_REG       ;
    assign DATA_CACHE_STORE_OUT             = DATA_CACHE_STORE_OUT_REG      ;
    assign DATA_CACHE_STORE_DATA_OUT        = DATA_CACHE_STORE_DATA_OUT_REG ;
    assign WRITE_BACK_MUX_SELECT_OUT        = WRITE_BACK_MUX_SELECT_OUT_REG ;
    assign RD_WRITE_ENABLE_OUT              = RD_WRITE_ENABLE_OUT_REG       ;
   
endmodule
