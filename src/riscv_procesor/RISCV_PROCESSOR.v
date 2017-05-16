`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/16/2017 07:37:27 PM
// Design Name: 
// Module Name:     RISCV_PROCESSOR
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


module RISCV_PROCESSOR #(

    ) (
        input            CLK        ,
        output  [31 : 0] ALU_OUT                                           
    );
    
    PROGRAME_COUNTER_STAGE PROGRAME_COUNTER_STAGE(
        );
    
    DECODING_STAGE DECODING_STAGE(
        );
        
    FORWARDING_UNIT FORWARDING_UNIT(
        );
        
    EXECUTION_STAGE EXECUTION_STAGE(
        );
        
endmodule
