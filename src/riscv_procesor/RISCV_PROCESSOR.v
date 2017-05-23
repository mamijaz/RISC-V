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
        .CLK(),
        .STALL_PROGRAME_COUNTER_STAGE(),
        .ALU_INSTRUCTION(),
        .BRANCH_TAKEN(),
        .PC_EXECUTION(),
        .RS1_DATA(),
        .IMM_INPUT(),
        .PC_DECODING(),
        .PC(),
        .CLEAR_INSTRUCTION_FETCH_STAGE(),
        .CLEAR_DECODING_STAGE(),
        .CLEAR_EXECUTION_STAGE()       
        );
        
    HAZARD_CONTROL_UNIT hazard_control_unit(
        );
        
    INSTRUCTION_CACHE instruction_cache(
        .PC(),
        .INSTRUCTION_CACHE_STALL(),
        .INSTRUCTION(),
        .INSTRUCTION_CACHE_READY()   
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_1(
        .CLK(),
        .STALL_INSTRUCTION_FETCH_STAGE(),
        .CLEAR_INSTRUCTION_FETCH_STAGE(),
        .PC_IN(),
        .PC_OUT() 
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_2(
        .CLK(),
        .STALL_INSTRUCTION_FETCH_STAGE(),
        .CLEAR_INSTRUCTION_FETCH_STAGE(),
        .PC_IN(),
        .PC_OUT() 
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_3(
        .CLK(),
        .STALL_INSTRUCTION_FETCH_STAGE(),
        .CLEAR_INSTRUCTION_FETCH_STAGE(),
        .PC_IN(),
        .PC_OUT() 
        );
    
    DECODING_STAGE decoding_stage(
        .CLK(),
        .STALL_DECODING_STAGE(),
        .CLEAR_DECODING_STAGE(),
        .RD_ADDRESS_IN(),
        .RD_DATA_IN(),
        .RD_WRITE_ENABLE_IN(),
        .INSTRUCTION(),
        .PC_IN(),
        .PC_OUT(),
        .RS1_ADDRESS(),
        .RS2_ADDRESS(),
        .RD_ADDRESS_OUT(),
        .RS1_DATA(),
        .RS2_DATA(),                       
        .IMM_OUTPUT(), 
        .ALU_INSTRUCTION(),
        .ALU_INPUT_1_SELECT(),
        .ALU_INPUT_2_SELECT(),
        .DATA_CACHE_LOAD(),
        .DATA_CACHE_STORE(),
        .DATA_CACHE_STORE_DATA(),
        .WRITE_BACK_MUX_SELECT(),
        .RD_WRITE_ENABLE_OUT()    
        );
        
    FORWARDING_UNIT forwarding_unit(
        .ALU_INPUT_1_SELECT(),
        .ALU_INPUT_2_SELECT(),
        .RS1_ADDRESS(),
        .RS2_ADDRESS(),
        .RD_ADDRESS_DM1(),
        .RD_ADDRESS_DM2(),
        .RD_ADDRESS_DM3(),
        .RD_ADDRESS_WB(),
        .ALU_INPUT_MUX_1_SELECT(),
        .ALU_INPUT_MUX_2_SELECT()
        );
        
    EXECUTION_STAGE execution_stage(
        .CLK(),
        .STALL_EXECUTION_STAGE(),
        .CLEAR_EXECUTION_STAGE(),
        .PC_IN(),
        .RS1_ADDRESS(),
        .RS2_ADDRESS(),
        .RD_ADDRESS_IN(),
        .RS1_DATA(),
        .RS2_DATA(),                       
        .IMM_DATA(),
        .ALU_INSTRUCTION(),
        .DATA_CACHE_LOAD_IN(),
        .DATA_CACHE_STORE_IN(),
        .DATA_CACHE_STORE_DATA_IN(),
        .WRITE_BACK_MUX_SELECT_IN(),
        .RD_WRITE_ENABLE_IN(),
        .ALU_IN1_MUX_SELECT(),
        .ALU_IN2_MUX_SELECT(),
        .RD_DATA_DM1(),
        .RD_DATA_DM2(),
        .RD_DATA_DM3(),
        .RD_DATA_WB(),
        .RD_ADDRESS_OUT(),
        .ALU_OUT(),
        .BRANCH_TAKEN(),
        .DATA_CACHE_LOAD_OUT(),
        .DATA_CACHE_STORE_OUT(),
        .DATA_CACHE_STORE_DATA_OUT(),
        .WRITE_BACK_MUX_SELECT_OUT(),
        .RD_WRITE_ENABLE_OUT()   
        );
    
    DATA_CACHE data_cache(
        .DATA_CACHE_STALL(),
        .DATA_CACHE_READ_ADDRESS(),
        .DATA_CACHE_LOAD(),
        .DATA_CACHE_WRITE_ADDRESS(),
        .DATA_CACHE_WRITE_DATA(),
        .DATA_CACHE_STORE(),
        .DATA_CACHE_READY(),
        .DATA_CACHE_READ_DATA() 
        );
        
    DATA_MEMORY_STAGE data_memory_stage_1(
        .CLK(),
        .RD_ADDRESS_IN(),
        .ALU_OUT_IN(),
        .DATA_CACHE_LOAD_IN(),
        .DATA_CACHE_STORE_IN(),
        .DATA_CACHE_STORE_DATA_IN(),
        .WRITE_BACK_MUX_SELECT_IN(),
        .RD_WRITE_ENABLE_IN(),
        .RD_ADDRESS_OUT(),
        .ALU_OUT_OUT(),
        .DATA_CACHE_LOAD_OUT(),
        .DATA_CACHE_STORE_OUT(),
        .DATA_CACHE_STORE_DATA_OUT(),
        .WRITE_BACK_MUX_SELECT_OUT(),
        .RD_WRITE_ENABLE_OUT() 
        );
    
    DATA_MEMORY_STAGE data_memory_stage_2(
        .CLK(),
        .RD_ADDRESS_IN(),
        .ALU_OUT_IN(),
        .DATA_CACHE_LOAD_IN(),
        .DATA_CACHE_STORE_IN(),
        .DATA_CACHE_STORE_DATA_IN(),
        .WRITE_BACK_MUX_SELECT_IN(),
        .RD_WRITE_ENABLE_IN(),
        .RD_ADDRESS_OUT(),
        .ALU_OUT_OUT(),
        .DATA_CACHE_LOAD_OUT(),
        .DATA_CACHE_STORE_OUT(),
        .DATA_CACHE_STORE_DATA_OUT(),
        .WRITE_BACK_MUX_SELECT_OUT(),
        .RD_WRITE_ENABLE_OUT()
        );
    
    DATA_MEMORY_STAGE data_memory_stage_3(
        .CLK(),
        .RD_ADDRESS_IN(),
        .ALU_OUT_IN(),
        .DATA_CACHE_LOAD_IN(),
        .DATA_CACHE_STORE_IN(),
        .DATA_CACHE_STORE_DATA_IN(),
        .WRITE_BACK_MUX_SELECT_IN(),
        .RD_WRITE_ENABLE_IN(),
        .RD_ADDRESS_OUT(),
        .ALU_OUT_OUT(),
        .DATA_CACHE_LOAD_OUT(),
        .DATA_CACHE_STORE_OUT(),
        .DATA_CACHE_STORE_DATA_OUT(),
        .WRITE_BACK_MUX_SELECT_OUT(),
        .RD_WRITE_ENABLE_OUT()
        );
      
    WRITE_BACK_STAGE write_back_stage(
        .IN1(),
        .IN2(),
        .SELECT(),
        .OUT()
        );
        
endmodule
