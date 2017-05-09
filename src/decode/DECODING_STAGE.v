`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/09/2017 07:54:56 PM
// Design Name: 
// Module Name:     DECODING_STAGE
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


module DECODING_STAGE #(
            parameter HIGH = 1'b1
        ) (
            input            CLK                    ,
            input            STALL_DECODING_STAGE   ,
            input            CLEAR_DECODING_STAGE   ,
            input   [4  : 0] RD_ADDRESS_IN          ,
            input   [31 : 0] RD_DATA_IN             ,
            input            RD_WRITE_ENABLE_IN     ,
            input   [31 : 0] INSTRUCTION            ,
            input   [31 : 0] PC_IN                  ,
            input   [31 : 0] PC_OUT                 ,
            output  [4  : 0] RS1_ADDRESS            ,
            output  [4  : 0] RS2_ADDRESS            ,
            output  [4  : 0] RD_ADDRESS_OUT         ,
            output  [31 : 0] RS1_DATA               ,
            output  [31 : 0] RS2_DATA               ,                       
            output  [31 : 0] IMM_OUTPUT             ,
            output  [5  : 0] SHIFT_AMOUNT           ,
            output  [5  : 0] ALU_INSTRUCTION        ,
            output           ALU_INPUT_1_SELECT     ,
            output           ALU_INPUT_2_SELECT     ,
            output  [2  : 0] DATA_CACHE_READ        ,
            output  [1  : 0] DATA_CACHE_WRITE       ,
            output           WRITE_BACK_MUX_SELECT  ,
            output           RD_WRITE_ENABLE_OUT        
    );
    
    reg  [31 : 0]   PC_REG                      ;
    reg  [4  : 0]   RS1_ADDRESS_REG             ;
    reg  [4  : 0]   RS2_ADDRESS_REG             ;
    reg  [4  : 0]   RD_ADDRESS_REG              ;
    reg  [31 : 0]   RS1_DATA_REG                ;
    reg  [31 : 0]   RS2_DATA_REG                ;                       
    reg  [31 : 0]   IMM_OUTPUT_REG              ;
    reg  [5  : 0]   SHIFT_AMOUNT_REG            ;
    reg  [5  : 0]   ALU_INSTRUCTION_REG         ;
    reg             ALU_INPUT_1_SELECT_REG      ;
    reg             ALU_INPUT_2_SELECT_REG      ;
    reg  [2  : 0]   DATA_CACHE_READ_REG         ;
    reg  [1  : 0]   DATA_CACHE_WRITE_REG        ;
    reg             WRITE_BACK_MUX_SELECT_REG   ;
    reg             RD_WRITE_ENABLE_REG         ;
    
    wire [4  : 0]   rs1_address                 ;
    wire [4  : 0]   rs2_address                 ;
    wire [4  : 0]   rd_address_out              ;
    wire [31 : 0]   rs1_data                    ;
    wire [31 : 0]   rs2_data                    ;  
    wire [2  : 0]   imm_format                  ;                    
    wire [31 : 0]   imm_output                  ;
    wire [5  : 0]   shift_amount                ;
    wire [5  : 0]   alu_instruction             ;
    wire            alu_input_1_select          ;
    wire            alu_input_2_select          ;
    wire [2  : 0]   data_cache_read             ;
    wire [1  : 0]   data_cache_write            ;
    wire            write_back_mux_select       ;
    wire            rd_write_enable_out         ;

    INS_DECODER INS_DECODER(
        .INSTRUCTION(INSTRUCTION),
        .IMM_FORMAT(imm_format),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RD_ADDRESS(rd_address_out),
        .SHIFT_AMOUNT(shift_amount),
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_READ(data_cache_read),
        .DATA_CACHE_WRITE(data_cache_write),
        .WRITE_BACK_MUX_SELECT(write_back_mux_select),
        .RD_WRITE_ENABLE(rd_write_enable_out)        
        );
        
    REGISTER_FILE REGISTER_FILE(
        .CLK(CLK),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data),
        .RD_ADDRESS(RD_ADDRESS_IN),
        .RD_DATA(RD_DATA_IN),
        .RD_WRITE_EN(RD_WRITE_ENABLE_IN)
        );
        
    IMM_EXTENDER IMM_EXTENDER(
        .IMM_INPUT(INSTRUCTION[31:7]),
        .IMM_FORMAT(imm_format),
        .IMM_OUTPUT(imm_output) 
        );
     
    always@(posedge CLK) 
    begin
        if(STALL_DECODING_STAGE != HIGH)
        begin
            PC_REG                      <= PC_IN                    ;
            RS1_ADDRESS_REG             <= rs1_address              ;
            RS2_ADDRESS_REG             <= rs2_address              ;
            RD_ADDRESS_REG              <= rd_address_out           ;
            RS1_DATA_REG                <= rs1_data                 ;
            RS2_DATA_REG                <= rs2_data                 ;             
            IMM_OUTPUT_REG              <= imm_output               ;
            SHIFT_AMOUNT_REG            <= shift_amount             ;
            ALU_INSTRUCTION_REG         <= alu_instruction          ;
            ALU_INPUT_1_SELECT_REG      <= alu_input_1_select       ;
            ALU_INPUT_2_SELECT_REG      <= alu_input_2_select       ;
            DATA_CACHE_READ_REG         <= data_cache_read          ;
            DATA_CACHE_WRITE_REG        <= data_cache_write         ;
            WRITE_BACK_MUX_SELECT_REG   <= write_back_mux_select    ;
            RD_WRITE_ENABLE_REG         <= rd_write_enable_out      ;
        end
    end
    
    assign PC_OUT                   = PC_REG                    ;
    assign RS1_ADDRESS              = RS1_ADDRESS_REG           ;        
    assign RS2_ADDRESS              = RS2_ADDRESS_REG           ;
    assign RD_ADDRESS_OUT           = RD_ADDRESS_REG            ;
    assign RS1_DATA                 = RS1_DATA_REG              ;
    assign RS2_DATA                 = RS2_DATA_REG              ;        
    assign IMM_OUTPUT               = IMM_OUTPUT_REG            ;
    assign SHIFT_AMOUNT             = SHIFT_AMOUNT_REG          ;
    assign ALU_INSTRUCTION          = ALU_INSTRUCTION_REG       ;
    assign ALU_INPUT_1_SELECT       = ALU_INPUT_1_SELECT_REG    ;
    assign ALU_INPUT_2_SELECT       = ALU_INPUT_2_SELECT_REG    ;
    assign DATA_CACHE_READ          = DATA_CACHE_READ_REG       ;
    assign DATA_CACHE_WRITE         = DATA_CACHE_WRITE_REG      ;
    assign WRITE_BACK_MUX_SELECT    = WRITE_BACK_MUX_SELECT_REG ;
    assign RD_WRITE_ENABLE_OUT      = RD_WRITE_ENABLE_REG       ;
    
endmodule
