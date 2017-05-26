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
        input            CLK                                    ,
        output  [31 : 0] PC                                     ,
        output  [31 : 0] INSTRUCTION                            ,
        output  [31 : 0] ALU_OUT                                ,
        output  [31 : 0] RD_DATA_WRITE_BACK                                               
    );
    
    
    // Programe Counter --> Instruction Cache / Instruction Fetch 1  
    wire [31 : 0] pc_pc_to_if1                                  ;
    wire          pc_valid_pc_to_if1                            ; 
    
    // Programe Counter --> Instruction Fetch 1 , 2 , 3 
    wire          clear_instruction_fetch_stage                 ;
    
    // Programe Counter --> Decoding Stage
    wire          clear_decoding_stage                          ;
    
    // Hazard Control Unit --> All Stages
    wire          stall_programe_counter_stage                  ;
    wire          stall_instruction_cache                       ;
    wire          stall_instruction_fetch_stage                 ;
    wire          stall_decoding_stage                          ;
    wire          stall_execution_stage                         ;
    wire          stall_data_cache                              ;
    wire          stall_data_memory_stage                       ;
    
    // Instruction Fetch 1 --> Instruction Fetch 2
    wire [31 : 0] pc_if1_to_if2                                 ;
    wire          pc_valid_if1_to_if2                           ;   
    
    // Instruction Fetch 2 --> Instruction Fetch 3
    wire [31 : 0] pc_if2_to_if3                                 ;
    wire          pc_valid_if2_to_if3                           ; 
   
    // Instruction Fetch 3 --> Decoding Stage 
    wire [31 : 0] pc_if3_to_decoding_stage                      ;
    wire          pc_valid_if3_to_decoding_stage                ; 
    
    // Instruction Cache --> Decoding Stage 
    wire [31 : 0] instruction                                   ;
    
    // Instruction Cache --> Hazard Control Unit
    wire          instruction_cache_ready                       ; 
    
    // Decoding Stage --> Programe Counter / Execution Stage
    wire [31 : 0] imm_data                                      ;
    wire [4  : 0] alu_instruction                               ;
    
    // Decoding Stage --> Hazard Control Unit / Forwarding Unit
    wire [4  : 0] rs1_address                                   ;
    wire [4  : 0] rs2_address                                   ;
    
    // Decoding Stage --> Forwarding Unit
    wire [31 : 0] rs1_data_decoding_to_forwarding_unit          ;
    wire [31 : 0] rs2_data_decoding_to_forwarding_unit          ;
    
    // Decoding Stage --> Execution Stage  
    wire [31 : 0] pc_decoding_to_execution                      ;
    wire [4  : 0] rd_address_decoding_to_execution              ; 
    wire [2  : 0] data_cache_load_decoding_to_execution         ;
    wire [1  : 0] data_cache_store_decoding_to_execution        ;
    wire [31 : 0] data_cache_store_data_decoding_to_execution   ;
    wire          write_back_mux_select_decoding_to_execution   ;
    wire          rd_write_enable_out_decoding_to_execution     ;
    wire          alu_input_1_select                            ;
    wire          alu_input_2_select                            ; 
    
    // Forwarding Unit --> Programe Counter / Execution Stage 
    wire [2  : 0] rs1_data                                      ;
    
    // Forwarding Unit --> Execution Stage
    wire [2  : 0] rs2_data                                      ;
    
    // Execution Stage --> Programe Counter
    wire          branch_taken                                  ;
    
    // Execution Stage --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 1
    wire [4  : 0] rd_address_execution_to_dm1                   ;
	
	// Execution Stage --> Hazard Control Unit / Data Cache / Data Memory Stage 1
	wire [2  : 0] data_cache_load_execution_to_dm1              ;
    
    // Execution Stage --> Data Cache / Data Memory Stage 1
    wire [31 : 0] alu_out_execution_to_dm1                      ;
    
    // Execution Stage --> Data Memory Stage 1
    wire [1  : 0] data_cache_store_execution_to_dm1             ;
    wire [31 : 0] data_cache_store_data_execution_to_dm1        ;
    wire          write_back_mux_select_execution_to_dm1        ;
    wire          rd_write_enable_execution_to_dm1              ;
    
    // Data Cache --> Hazard Control Unit
    wire          data_cache_ready                              ;
    
    // Data Cache --> Write Back Stage
    wire [31 : 0] data_cache_read_data                          ;
    
    // Data Memory Stage 1 --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 2   
    wire [4  : 0] rd_address_dm1_to_dm2                         ;
    
	// Data Memory Stage 1 --> Hazard Control Unit / Data Memory Stage 2
	wire [2  : 0] data_cache_load_dm1_to_dm2                    ;
	
    // Data Memory Stage 1 --> Data Memory Stage 2
    wire [31 : 0] alu_out_dm1_to_dm2                            ;
    wire [1  : 0] data_cache_store_dm1_to_dm2                   ;
    wire [31 : 0] data_cache_store_data_dm1_to_dm2              ;
    wire          write_back_mux_select_dm1_to_dm2              ;
    wire          rd_write_enable_dm1_to_dm2                    ;
    
    // Data Memory Stage 2 --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 3   
    wire [4  : 0] rd_address_dm2_to_dm3                         ;
	
	// Data Memory Stage 2 --> Hazard Control Unit / Data Memory Stage 3
	wire [2  : 0] data_cache_load_dm2_to_dm3                    ;
    
    // Data Memory Stage 2 --> Data Memory Stage 3
    wire [31 : 0] alu_out_dm2_to_dm3                            ;
    wire [1  : 0] data_cache_store_dm2_to_dm3                   ;
    wire [31 : 0] data_cache_store_data_dm2_to_dm3              ;
    wire          write_back_mux_select_dm2_to_dm3              ;
    wire          rd_write_enable_dm2_to_dm3                    ; 
    
    // Data Memory Stage 3 --> Hazard Control Unit / Forwarding Unit / Write Back Stage   
    wire [4  : 0] rd_address_dm3_to_write_back                  ;
    
    // Data Memory Stage 3 --> Write Back Stage
    wire [31 : 0] alu_out_dm3_to_write_back                     ;
    wire          write_back_mux_select_dm3_to_write_back       ;
    wire          rd_write_enable_dm3_to_write_back             ;
    
    // Data Memory Stage 3 --> Data Cache
    wire [1  : 0] data_cache_store_dm3_to_write_back            ;
    wire [31 : 0] data_cache_store_data_dm3_to_write_back       ;
          
    // Write Back Stage 
    wire [31 : 0] rd_data_write_back                            ;
    
    
    PROGRAME_COUNTER_STAGE programe_counter_stage(
        .CLK(CLK),
        .STALL_PROGRAME_COUNTER_STAGE(stall_programe_counter_stage),
        .ALU_INSTRUCTION(alu_instruction),
        .BRANCH_TAKEN(branch_taken),
        .PC_EXECUTION(pc_decoding_to_execution),
        .RS1_DATA(rs1_data),
        .IMM_INPUT(imm_data),
        .PC_DECODING(pc_if3_to_decoding_stage),
        .PC(pc_pc_to_if1),
        .PC_VALID(pc_valid_pc_to_if1),
        .CLEAR_INSTRUCTION_FETCH_STAGE(clear_instruction_fetch_stage),
        .CLEAR_DECODING_STAGE(clear_decoding_stage)   
        );
        
    HAZARD_CONTROL_UNIT hazard_control_unit(
        .RS1_ADDRESS_EXECUTION(rs1_address),
        .RS2_ADDRESS_EXECUTION(rs2_address),
        .DATA_CACHE_LOAD_DM1(data_cache_load_execution_to_dm1),         
        .RD_ADDRESS_DM1(rd_address_execution_to_dm1),
        .DATA_CACHE_LOAD_DM2(data_cache_load_dm1_to_dm2),
        .RD_ADDRESS_DM2(rd_address_dm1_to_dm2),
        .DATA_CACHE_LOAD_DM3(data_cache_load_dm2_to_dm3),
        .RD_ADDRESS_DM3(rd_address_dm2_to_dm3),
        .STALL_PROGRAME_COUNTER_STAGE(stall_programe_counter_stage),
        .STALL_INSTRUCTION_CACHE(stall_instruction_cache),
        .STALL_INSTRUCTION_FETCH_STAGE(stall_instruction_fetch_stage),
        .STALL_DECODING_STAGE(stall_decoding_stage),
        .STALL_EXECUTION_STAGE(stall_execution_stage),
        .STALL_DATA_CACHE(stall_data_cache),
        .STALL_DATA_MEMORY_STAGE(stall_data_memory_stage)                    
        );
        
    INSTRUCTION_CACHE instruction_cache(
        .CLK(CLK),
        .STALL_INSTRUCTION_CACHE(stall_instruction_cache),
        .PC(pc_pc_to_if1),
        .PC_VALID(pc_valid_pc_to_if1),
        .INSTRUCTION(instruction),
        .INSTRUCTION_CACHE_READY(instruction_cache_ready)   
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_1(
        .CLK(CLK),
        .STALL_INSTRUCTION_FETCH_STAGE(stall_instruction_fetch_stage),
        .CLEAR_INSTRUCTION_FETCH_STAGE(clear_instruction_fetch_stage),
        .PC_IN(pc_pc_to_if1),
        .PC_VALID_IN(pc_valid_pc_to_if1),
        .PC_OUT(pc_if1_to_if2),
        .PC_VALID_OUT(pc_valid_if1_to_if2)
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_2(
        .CLK(CLK),
        .STALL_INSTRUCTION_FETCH_STAGE(stall_instruction_fetch_stage),
        .CLEAR_INSTRUCTION_FETCH_STAGE(clear_instruction_fetch_stage),
        .PC_IN(pc_if1_to_if2),      
        .PC_VALID_IN(pc_valid_if1_to_if2),
        .PC_OUT(pc_if2_to_if3),     
        .PC_VALID_OUT(pc_valid_if2_to_if3) 
        );
        
    INSTRUCTION_FETCH_STAGE instruction_fetch_stage_3(
        .CLK(CLK),
        .STALL_INSTRUCTION_FETCH_STAGE(stall_instruction_fetch_stage),
        .CLEAR_INSTRUCTION_FETCH_STAGE(clear_instruction_fetch_stage),
        .PC_IN(pc_if2_to_if3),      
        .PC_VALID_IN(pc_valid_if2_to_if3),
        .PC_OUT(pc_if3_to_decoding_stage),     
        .PC_VALID_OUT(pc_valid_if3_to_decoding_stage) 
        );
    
    DECODING_STAGE decoding_stage(
        .CLK(CLK),
        .STALL_DECODING_STAGE(stall_decoding_stage),
        .CLEAR_DECODING_STAGE(clear_decoding_stage),
        .RD_ADDRESS_IN(rd_address_dm3_to_write_back),
        .RD_DATA_IN(rd_data_write_back),
        .RD_WRITE_ENABLE_IN(rd_write_enable_dm3_to_write_back),
        .INSTRUCTION(instruction),
        .PC_IN(pc_if3_to_decoding_stage),
        .PC_VALID(pc_valid_if3_to_decoding_stage),
        .PC_OUT(pc_decoding_to_execution),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RD_ADDRESS_OUT(rd_address_decoding_to_execution),
        .RS1_DATA(rs1_data_decoding_to_forwarding_unit),
        .RS2_DATA(rs2_data_decoding_to_forwarding_unit),                       
        .IMM_OUTPUT(imm_data), 
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_LOAD(data_cache_load_decoding_to_execution),
        .DATA_CACHE_STORE(data_cache_store_data_decoding_to_execution),
        .DATA_CACHE_STORE_DATA(data_cache_store_data_decoding_to_execution),
        .WRITE_BACK_MUX_SELECT(write_back_mux_select_decoding_to_execution),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_out_decoding_to_execution)    
        );
        
    FORWARDING_UNIT forwarding_unit(
        .RS1_ADDRESS_EXECUTION(rs1_address),
        .RS1_DATA_EXECUTION(rs1_data_decoding_to_forwarding_unit),
        .RS2_ADDRESS_EXECUTION(rs2_address),
        .RS2_DATA_EXECUTION(rs2_data_decoding_to_forwarding_unit),
        .RD_ADDRESS_DM1(rd_address_execution_to_dm1),
        .RD_DATA_DM1(alu_out_execution_to_dm1),
        .RD_ADDRESS_DM2(rd_address_dm1_to_dm2),
        .RD_DATA_DM2(alu_out_dm1_to_dm2),
        .RD_ADDRESS_DM3(rd_address_dm2_to_dm3),
        .RD_DATA_DM3(alu_out_dm2_to_dm3),
        .RD_ADDRESS_WB(rd_address_dm3_to_write_back),
        .RD_DATA_WB(rd_data_write_back),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data)
        );
        
    EXECUTION_STAGE execution_stage(
        .CLK(CLK),
        .STALL_EXECUTION_STAGE(stall_execution_stage),
        .PC_IN(pc_decoding_to_execution),
        .RD_ADDRESS_IN(rd_address_decoding_to_execution),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data),                       
        .IMM_DATA(imm_data),
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_LOAD_IN(data_cache_load_decoding_to_execution),
        .DATA_CACHE_STORE_IN(data_cache_store_data_decoding_to_execution),
        .DATA_CACHE_STORE_DATA_IN(data_cache_store_data_decoding_to_execution),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_decoding_to_execution),
        .RD_WRITE_ENABLE_IN(rd_write_enable_out_decoding_to_execution),
        .RD_ADDRESS_OUT(rd_address_execution_to_dm1),
        .ALU_OUT(alu_out_execution_to_dm1),
        .BRANCH_TAKEN(branch_taken),
        .DATA_CACHE_LOAD_OUT(data_cache_load_execution_to_dm1),
        .DATA_CACHE_STORE_OUT(data_cache_store_execution_to_dm1),
        .DATA_CACHE_STORE_DATA_OUT(data_cache_store_data_execution_to_dm1),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_execution_to_dm1),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_execution_to_dm1)   
        );
    
    DATA_CACHE data_cache(
        .CLK(CLK),
        .STALL_DATA_CACHE(stall_data_cache),
        .DATA_CACHE_READ_ADDRESS(alu_out_execution_to_dm1),
        .DATA_CACHE_LOAD(data_cache_load_execution_to_dm1),
        .DATA_CACHE_WRITE_ADDRESS(alu_out_dm3_to_write_back),
        .DATA_CACHE_WRITE_DATA(data_cache_store_data_dm3_to_write_back),
        .DATA_CACHE_STORE(data_cache_store_dm3_to_write_back),
        .DATA_CACHE_READY(data_cache_ready),
        .DATA_CACHE_READ_DATA(data_cache_read_data) 
        );
        
    DATA_MEMORY_STAGE data_memory_stage_1(
        .CLK(CLK),
        .STALL_DATA_MEMORY_STAGE(stall_data_memory_stage),
        .RD_ADDRESS_IN(rd_address_execution_to_dm1),
        .ALU_OUT_IN(alu_out_execution_to_dm1),
        .DATA_CACHE_LOAD_IN(data_cache_load_execution_to_dm1),
        .DATA_CACHE_STORE_IN(data_cache_store_execution_to_dm1),
        .DATA_CACHE_STORE_DATA_IN(data_cache_store_data_execution_to_dm1),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_execution_to_dm1),
        .RD_WRITE_ENABLE_IN(rd_write_enable_execution_to_dm1),
        .RD_ADDRESS_OUT(rd_address_dm1_to_dm2),
        .ALU_OUT_OUT(alu_out_dm1_to_dm2),
        .DATA_CACHE_LOAD_OUT(data_cache_load_dm1_to_dm2),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm1_to_dm2),
        .DATA_CACHE_STORE_DATA_OUT(data_cache_store_data_dm1_to_dm2),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_dm1_to_dm2),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_dm1_to_dm2) 
        );
    
    DATA_MEMORY_STAGE data_memory_stage_2(
        .CLK(CLK),
        .STALL_DATA_MEMORY_STAGE(stall_data_memory_stage),
        .RD_ADDRESS_IN(rd_address_dm1_to_dm2),
        .ALU_OUT_IN(alu_out_dm1_to_dm2),
        .DATA_CACHE_LOAD_IN(data_cache_load_dm1_to_dm2),
        .DATA_CACHE_STORE_IN(data_cache_store_dm1_to_dm2),
        .DATA_CACHE_STORE_DATA_IN(data_cache_store_data_dm1_to_dm2),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_dm1_to_dm2),
        .RD_WRITE_ENABLE_IN(rd_write_enable_dm1_to_dm2),
        .RD_ADDRESS_OUT(rd_address_dm2_to_dm3),
        .ALU_OUT_OUT(alu_out_dm2_to_dm3),
        .DATA_CACHE_LOAD_OUT(data_cache_load_dm2_to_dm3),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm2_to_dm3),
        .DATA_CACHE_STORE_DATA_OUT(data_cache_store_data_dm2_to_dm3),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_dm2_to_dm3),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_dm2_to_dm3)
        );
    
    DATA_MEMORY_STAGE data_memory_stage_3(
        .CLK(CLK),
        .STALL_DATA_MEMORY_STAGE(stall_data_memory_stage),
        .RD_ADDRESS_IN(rd_address_dm2_to_dm3),
        .ALU_OUT_IN(alu_out_dm2_to_dm3),
        .DATA_CACHE_LOAD_IN(data_cache_load_dm2_to_dm3),
        .DATA_CACHE_STORE_IN(data_cache_store_dm2_to_dm3),
        .DATA_CACHE_STORE_DATA_IN(data_cache_store_data_dm2_to_dm3),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_dm2_to_dm3),
        .RD_WRITE_ENABLE_IN(rd_write_enable_dm2_to_dm3),
        .RD_ADDRESS_OUT(rd_address_dm3_to_write_back),
        .ALU_OUT_OUT(alu_out_dm3_to_write_back),
        .DATA_CACHE_LOAD_OUT(),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm3_to_write_back),
        .DATA_CACHE_STORE_DATA_OUT(data_cache_store_data_dm3_to_write_back),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_dm3_to_write_back),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_dm3_to_write_back)
        );
      
    WRITE_BACK_STAGE write_back_stage(
        .IN1(alu_out_dm3_to_write_back),
        .IN2(data_cache_read_data),
        .SELECT(write_back_mux_select_dm3_to_write_back),
        .OUT(rd_data_write_back)
        );
    
    assign PC                       = pc_pc_to_if1                  ;
    assign INSTRUCTION              = instruction                   ;
    assign ALU_OUT                  = alu_out_execution_to_dm1      ;
    assign RD_DATA_WRITE_BACK       = rd_data_write_back            ;
       
endmodule
