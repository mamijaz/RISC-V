`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/09/2017 06:36:09 PM
// Design Name: 
// Module Name:     ALU
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


module ALU #(
        parameter INPUT_WIDTH           = 32            ,
        
        parameter ALU_NOP               = 5'b00000      ,
        parameter ALU_ADD               = 5'b00001      ,
        parameter ALU_SUB               = 5'b00010      ,
        parameter ALU_SLL               = 5'b00011      ,
        parameter ALU_SLT               = 5'b00100      ,
        parameter ALU_SLTU              = 5'b00101      ,
        parameter ALU_XOR               = 5'b00110      ,
        parameter ALU_SRL               = 5'b00111      ,
        parameter ALU_SRA               = 5'b01000      ,
        parameter ALU_OR                = 5'b01001      ,
        parameter ALU_AND               = 5'b01010      ,
        parameter ALU_SLLI              = 5'b01010      ,
        parameter ALU_SRLI              = 5'b01010      ,
        parameter ALU_SRAI              = 5'b01010      ,
        parameter ALU_JAL               = 5'b01010      ,
        parameter ALU_JALR              = 5'b01011      ,
        parameter ALU_BEQ               = 5'b01100      ,
        parameter ALU_BNE               = 5'b01101      ,
        parameter ALU_BLT               = 5'b01110      ,
        parameter ALU_BGE               = 5'b01111      ,
        parameter ALU_BLTU              = 5'b10000      ,
        parameter ALU_BGEU              = 5'b10001      
    ) (
        input   [INPUT_WIDTH - 1 : 0]   ALU_IN1           ,
        input   [INPUT_WIDTH - 1 : 0]   ALU_IN2           ,
        input   [4               : 0]   SHIFT_AMOUNT      ,
        input   [4               : 0]   ALU_INSTRUCTION   ,
        output  [INPUT_WIDTH - 1 : 0]   ALU_OUT           ,
        output                          BRANCH_TAKEN
    );
   
    reg  [4  : 0]   ALU_OUT_REG         ;
    reg             BRANCH_TAKEN_REG    ;
    
    always@(*)
    begin
        case(ALU_INSTRUCTION)
        
        endcase
    end
    
    assign  ALU_OUT         = ALU_OUT_REG       ;
    assign  BRANCH_TAKEN    = BRANCH_TAKEN_REG  ;
    
endmodule
