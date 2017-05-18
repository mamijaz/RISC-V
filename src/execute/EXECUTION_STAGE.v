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
        parameter HIGH  = 1'b1  ,
        parameter LOW   = 1'b0
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
        output           BRANCH_TAKEN               ,
        output  [2  : 0] DATA_CACHE_LOAD_OUT        ,
        output  [1  : 0] DATA_CACHE_STORE_OUT       ,
        output  [31 : 0] DATA_CACHE_STORE_DATA_OUT  ,
        output           WRITE_BACK_MUX_SELECT_OUT  ,
        output           RD_WRITE_ENABLE_OUT           
    );
    
    reg  [4  : 0] rd_address_out_reg                ;
    reg  [31 : 0] alu_out_reg                       ;
    reg  [2  : 0] data_cache_load_out_reg           ;
    reg  [1  : 0] data_cache_store_out_reg          ;
    reg  [31 : 0] data_cache_store_data_out_reg     ;
    reg           write_back_mux_select_out_reg     ;
    reg           rd_write_enable_out_reg           ;
    
    wire [31 : 0] alu_in1                           ;
    wire [31 : 0] alu_in2                           ;
    wire [31 : 0] alu_out                           ;   
        
    MULTIPLEXER_6_TO_1 alu_in1_mux(
        .IN1(RS1_DATA),
        .IN2(PC_IN),
        .IN3(RS1_DATA_DM1),
        .IN4(RS1_DATA_DM2),
        .IN5(RS1_DATA_DM3),
        .IN6(RS1_DATA_WB),
        .SELECT(ALU_IN1_MUX_SELECT),
        .OUT(alu_in1)
        );
    
    MULTIPLEXER_6_TO_1 alu_in2_mux(
        .IN1(RS2_DATA),
        .IN2(IMM_DATA),
        .IN3(RS2_DATA_DM1),
        .IN4(RS2_DATA_DM2),
        .IN5(RS2_DATA_DM3),
        .IN6(RS2_DATA_WB),
        .SELECT(ALU_IN2_MUX_SELECT),
        .OUT(alu_in2)
        );
    
    ALU alu(
        .ALU_IN1(alu_in1),
        .ALU_IN2(alu_in2),
        .ALU_INSTRUCTION(ALU_INSTRUCTION),
        .ALU_OUT(alu_out),
        .BRANCH_TAKEN(BRANCH_TAKEN)
        );
        
    always@(posedge CLK) 
    begin
        if(STALL_EXECUTION_STAGE == LOW)
        begin
            if(CLEAR_EXECUTION_STAGE == LOW)
            begin
                rd_address_out_reg             <= RD_ADDRESS_IN             ;
                alu_out_reg                    <= alu_out                   ;
                data_cache_load_out_reg        <= DATA_CACHE_LOAD_IN        ;
                data_cache_store_out_reg       <= DATA_CACHE_STORE_IN       ;
                data_cache_store_data_out_reg  <= DATA_CACHE_STORE_DATA_IN  ;
                write_back_mux_select_out_reg  <= WRITE_BACK_MUX_SELECT_IN  ;
                rd_write_enable_out_reg        <= RD_WRITE_ENABLE_IN        ;
            end
            else
            begin
                rd_address_out_reg             <= 5'b0                      ;
                alu_out_reg                    <= 32'b0                     ;
                data_cache_load_out_reg        <= 3'b0                      ;
                data_cache_store_out_reg       <= 2'b0                      ;
                data_cache_store_data_out_reg  <= 32'b0                     ;
                write_back_mux_select_out_reg  <= LOW                       ;
                rd_write_enable_out_reg        <= LOW                       ;
            end
        end
    end
    
    assign RD_ADDRESS_OUT                   = rd_address_out_reg            ;
    assign ALU_OUT                          = alu_out_reg                   ;
    assign DATA_CACHE_LOAD_OUT              = data_cache_load_out_reg       ;
    assign DATA_CACHE_STORE_OUT             = data_cache_store_out_reg      ;
    assign DATA_CACHE_STORE_DATA_OUT        = data_cache_store_data_out_reg ;
    assign WRITE_BACK_MUX_SELECT_OUT        = write_back_mux_select_out_reg ;
    assign RD_WRITE_ENABLE_OUT              = rd_write_enable_out_reg       ;
   
endmodule
