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
        output           ALU_INPUT_1_SEL        ,
        output           ALU_INPUT_2_SEL        ,
        output  [1  : 0] DATA_CACHE_READ        ,
        output  [1  : 0] DATA_CACHE_WRITE       ,
        output  [2  : 0] DATA_CACHE_READ_EXTEND ,
        output           WRITE_BACK_MUX_SEL     ,
        output           RD_WRITE_EN        
    );
endmodule
