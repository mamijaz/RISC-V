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
    
    PROGRAME_COUNTER_STAGE programe_counter_stage(
        );
        
    INSTRUCTION_CACHE instruction_cache(
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_1(
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_2(
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_3(
        );
    
    DECODING_STAGE decoding_stage(
        );
        
    FORWARDING_UNIT forwarding_unit(
        );
        
    EXECUTION_STAGE execution_stage(
        );
    
    DATA_CACHE data_cache(
        );
        
    DATA_MEMORY_STAGE data_memory_stage_1(
        );
    
    DATA_MEMORY_STAGE data_memory_stage_2(
        );
    
    DATA_MEMORY_STAGE data_memory_stage_3(
        );
      
    WRITE_BACK_STAGE write_back_stage(
        );
        
endmodule
