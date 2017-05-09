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
        parameter INPUT_WIDTH     = 32
    ) (
        input   [INPUT_WIDTH - 1 : 0]   ALU_IN1           ,
        input   [INPUT_WIDTH - 1 : 0]   ALU_IN2           ,
        input   [5               : 0]   SHIFT_AMOUNT      ,
        output  [5               : 0]   ALU_INSTRUCTION   ,
        output  [INPUT_WIDTH - 1 : 0]   OUT
    );
endmodule
