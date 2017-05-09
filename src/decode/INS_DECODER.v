`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/08/2017 10:48:13 AM
// Design Name: 
// Module Name:     INS_DECODER
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


module INS_DECODER #(
        parameter RV321_LUI           = 7'b0110111 ,
        parameter RV321_AUIPC         = 7'b0010111 ,
        parameter RV321_JAL           = 7'b1101111 ,
        parameter RV321_JALR          = 7'b1100111 ,
        parameter RV321_BRANCH        = 7'b1100011 ,
        parameter RV321_LOAD          = 7'b0000011 ,
        parameter RV321_STORE         = 7'b0100011 ,
        parameter RV321_IMMEDIATE     = 7'b0010011 ,
        parameter RV321_ALU           = 7'b0110011
    ) (
        input   [31 : 0] INSTRUCTION            ,
        output  [2  : 0] IMM_FORMAT             ,
        output  [4  : 0] RS1_ADDRESS            ,
        output  [4  : 0] RS2_ADDRESS            ,
        output  [4  : 0] RD_ADDRESS             ,
		output  [5  : 0] SHIFT_AMOUNT           ,
		output  [5  : 0] ALU_INSTRUCTION        ,
        output           ALU_INPUT_1_SELECT     ,
        output           ALU_INPUT_2_SELECT     ,
        output  [2  : 0] DATA_CACHE_READ        ,
        output  [1  : 0] DATA_CACHE_WRITE       ,
        output           WRITE_BACK_MUX_SELECT  ,
        output           RD_WRITE_ENABLE        
    );
    
    reg  [2  : 0]   IMM_FORMAT_REG              ;
    reg  [4  : 0]   RS1_ADDRESS_REG             ;
    reg  [4  : 0]   RS2_ADDRESS_REG             ;
    reg  [4  : 0]   RD_ADDRESS_REG              ;
    reg  [5  : 0]   SHIFT_AMOUNT_REG            ;
    reg  [5  : 0]   ALU_INSTRUCTION_REG         ;
    reg             ALU_INPUT_1_SELECT_REG      ;
    reg             ALU_INPUT_2_SELECT_REG      ;
    reg  [2  : 0]   DATA_CACHE_READ_REG         ;
    reg  [1  : 0]   DATA_CACHE_WRITE_REG        ;
    reg             WRITE_BACK_MUX_SELECT_REG   ;
    reg             RD_WRITE_ENABLE_REG         ;
    
    wire [6  : 0]   OPCODE                      ;
    
    assign OPCODE = INSTRUCTION[6:0];
    
    always@(*)
    begin
        case(OPCODE)
                RV321_LUI:
                begin 
                end
                RV321_AUIPC:
                begin 
                end
                RV321_JAL:
                begin
                end
                RV321_JALR:
                begin
                end
                RV321_BRANCH:
                begin
                end
                RV321_LOAD:
                begin
                end
                RV321_STORE:
                begin
                end
                RV321_IMMEDIATE:
                begin
                end
                RV321_ALU:
                begin 
                end
        endcase
    end
    
    assign  IMM_FORMAT              = IMM_FORMAT_REG            ;
    assign  RS1_ADDRESS             = RS1_ADDRESS_REG           ;
    assign  RS2_ADDRESS             = RS2_ADDRESS_REG           ;
    assign  RD_ADDRESS              = RD_ADDRESS_REG            ;
    assign  SHIFT_AMOUNT            = SHIFT_AMOUNT_REG          ;
    assign  ALU_INSTRUCTION         = ALU_INSTRUCTION_REG       ;
    assign  ALU_INPUT_1_SELECT      = ALU_INPUT_1_SELECT_REG    ;
    assign  ALU_INPUT_2_SELECT      = ALU_INPUT_2_SELECT_REG    ;
    assign  DATA_CACHE_READ         = DATA_CACHE_READ_REG       ;
    assign  DATA_CACHE_WRITE        = DATA_CACHE_WRITE_REG      ;
    assign  WRITE_BACK_MUX_SELECT   = WRITE_BACK_MUX_SELECT_REG ;
    assign  RD_WRITE_ENABLE         = RD_WRITE_ENABLE_REG       ;
    
endmodule
