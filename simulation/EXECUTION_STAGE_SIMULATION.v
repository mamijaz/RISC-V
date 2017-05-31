`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/22/2017 10:27:02 AM
// Design Name: 
// Module Name:     EXECUTION_STAGE_SIMULATION
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


module EXECUTION_STAGE_SIMULATION;

    // Inputs
    reg            clk                          ;
    reg            stall_execution_stage        ; 
    reg            clear_execution_stage        ;  
    reg   [31 : 0] pc_in                        ;
    reg   [4  : 0] rd_address_in                ;
    reg   [31 : 0] rs1_data                     ;
    reg   [31 : 0] rs2_data                     ;                       
    reg   [31 : 0] imm_data                     ;
    reg   [4  : 0] alu_instruction              ;
    reg            alu_input_1_select           ;
    reg            alu_input_2_select           ;
    reg   [2  : 0] data_cache_load_in           ;
    reg   [1  : 0] data_cache_store_in          ;
    reg            write_back_mux_select_in     ;
    reg            rd_write_enable_in           ;
    
    // Outputs
    wire  [4  : 0] rd_address_out               ;
    wire  [31 : 0] alu_out                      ;
    wire           branch_taken                 ;
    wire  [2  : 0] data_cache_load_out          ;
    wire  [1  : 0] data_cache_store_out         ;
    wire  [31 : 0] data_cache_store_data        ;
    wire           write_back_mux_select_out    ;
    wire           rd_write_enable_out          ;
    
    // Instantiate the Unit Under Test (UUT)
    EXECUTION_STAGE uut(
        .CLK(clk),
        .STALL_EXECUTION_STAGE(stall_execution_stage),
        .CLEAR_EXECUTION_STAGE(clear_execution_stage), 
        .PC_IN(pc_in),
        .RD_ADDRESS_IN(rd_address_in),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data),                     
        .IMM_DATA(imm_data),
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_LOAD_IN(data_cache_load_in),
        .DATA_CACHE_STORE_IN(data_cache_store_in),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_in),
        .RD_WRITE_ENABLE_IN(rd_write_enable_in),
        .RD_ADDRESS_OUT(rd_address_out),
        .ALU_OUT(alu_out),
        .BRANCH_TAKEN(branch_taken),
        .DATA_CACHE_LOAD_OUT(data_cache_load_out),
        .DATA_CACHE_STORE_OUT(data_cache_store_out),
        .DATA_CACHE_STORE_DATA(data_cache_store_data),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_out),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_out)     
        );
    
    initial 
    begin
        // Initialize Inputs
        clk                         = 1'b0 ;
        stall_execution_stage       = 1'b0 ; 
        clear_execution_stage       = 1'b0 ;
        pc_in                       = 32'b0 ;
        rd_address_in               = 5'b0 ;
        rs1_data                    = 32'b00000000000000000000000000000010 ;
        rs2_data                    = 32'b00000000000000000000000000000001 ;                         
        imm_data                    = 32'b0 ;
        alu_instruction             = 5'b00001 ;
        alu_input_1_select          = 1'b0 ;
        alu_input_2_select          = 1'b0 ;
        data_cache_load_in          = 3'b0 ;
        data_cache_store_in         = 2'b0 ;
        write_back_mux_select_in    = 1'b0 ;
        rd_write_enable_in          = 1'b0 ;
            
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        clk                      = 1'b1 ;
        
        
    end
   
endmodule
