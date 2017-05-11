`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/11/2017 12:21:47 PM
// Design Name: 
// Module Name:     DECODING_STAGE_SIMULATION
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


module DECODING_STAGE_SIMULATION;

    // Inputs
    reg            clk                      ;
    reg            stall_decoding_stage     ;
    reg            clear_decoding_stage     ;
    reg   [4  : 0] rd_address_in            ;
    reg   [31 : 0] rd_data_in               ;
    reg            rd_write_enable_in       ;
    reg   [31 : 0] instruction              ;
    reg   [31 : 0] pc_in                    ;
    
    // Outputs
    wire  [31 : 0] pc_out                   ;
    wire  [4  : 0] rs1_address              ;
    wire  [4  : 0] rs2_address              ;
    wire  [4  : 0] rd_address_out           ;
    wire  [31 : 0] rs1_data                 ;
    wire  [31 : 0] rs2_data                 ;                     
    wire  [31 : 0] imm_output               ;
    wire  [4  : 0] shift_amount             ;
    wire  [4  : 0] alu_instruction          ;
    wire           alu_input_1_select       ;
    wire           alu_input_2_select       ;
    wire  [2  : 0] data_cache_read          ;
    wire  [1  : 0] data_cache_write         ;
    wire  [31 : 0] data_cache_write_data    ;
    wire           write_back_mux_select    ;
    wire           rd_write_enable_out      ;
    
    // Instantiate the Unit Under Test (UUT)
    DECODING_STAGE uut(
        .CLK(clk),
        .STALL_DECODING_STAGE(stall_decoding_stage),
        .CLEAR_DECODING_STAGE(clear_decoding_stage),
        .RD_ADDRESS_IN(rd_address_in),
        .RD_DATA_IN(rd_data_in),
        .RD_WRITE_ENABLE_IN(rd_write_enable_in),
        .INSTRUCTION(instruction),
        .PC_IN(pc_in),
        .PC_OUT(pc_out),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RD_ADDRESS_OUT(rd_address_out),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data),                       
        .IMM_OUTPUT(imm_output),
        .SHIFT_AMOUNT(shift_amount),
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_READ(data_cache_read),
        .DATA_CACHE_WRITE(data_cache_write),
        .DATA_CACHE_WRITE_DATA(data_cache_write_data),
        .WRITE_BACK_MUX_SELECT(write_back_mux_select),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_out)     
        );  
    
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
        stall_decoding_stage     = 1'b0 ;
        clear_decoding_stage     = 1'b0 ;
        rd_address_in            = 5'b0 ;
        rd_data_in               = 32'b0 ;
        rd_write_enable_in       = 1'b0 ;
        instruction              = 32'b00000000001000000000001000110011 ;
        pc_in                    = 32'b00000000000000000000000000000001 ;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        clk                      = 1'b1 ;
        
        
    end
    
endmodule