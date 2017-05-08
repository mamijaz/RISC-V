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

    ) (
        input   [31 : 0] INSTRUCTION        ,
        output  [2  : 0] IMM_FORMAT         ,
        output  [4  : 0] RS1_ADDRESS        ,
        output  [4  : 0] RS2_ADDRESS        ,
        output  [4  : 0] RD_ADDRESS         ,
        output           ALU_INPUT_1_SEL    ,
        output           ALU_INPUT_2_SEL    ,
        output           WRITE_BACK_MUX_SEL ,
        output           RD_WRITE_EN  
    );
endmodule
