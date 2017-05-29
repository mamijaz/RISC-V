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
        parameter   ADDRESS_WIDTH           = 32        ,
        parameter   DATA_WIDTH              = 32        ,
        parameter   REG_ADD_WIDTH           = 5         ,
        parameter   ALU_INS_WIDTH           = 5         ,
        parameter   D_CACHE_LW_WIDTH        = 3         ,
        parameter   D_CACHE_SW_WIDTH        = 2         ,
        parameter   L2_BUS_WIDTH            = 32
    ) (
        input                                   CLK                                     ,
        
        //Instruction Cache
        // Transfer Address From L1 Cache to L2
        input                                   ADDRESS_TO_L2_READY_INS                 ,
        output                                  ADDRESS_TO_L2_VALID_INS                 ,      
        output  [ADDRESS_WIDTH - 2 - 1 : 0]     ADDRESS_TO_L2_INS                       ,
        // Transfer Data From L2 Cache to L1       
        input                                   DATA_FROM_L2_VALID_INS                  ,
        output                                  DATA_FROM_L2_READY_INS                  ,
        input   [L2_BUS_WIDTH   - 1    : 0]     DATA_FROM_L2_INS                        ,
        
        //Data Cache
        // Write Data From L1 to L2 Cache
        input                                   WRITE_TO_L2_READY_DATA                  ,
        output                                  WRITE_TO_L2_VALID_DATA                  ,
        output  [ADDRESS_WIDTH - 2 - 1  : 0]    WRITE_ADDR_TO_L2_DATA                   ,
        output  [L2_BUS_WIDTH   - 1     : 0]    DATA_TO_L2_DATA                         ,
        output                                  WRITE_CONTROL_TO_L2_DATA                ,
        input                                   WRITE_COMPLETE_DATA                     ,
        // Read Data From L2 to L1 Cache
        input                                   READ_ADDR_TO_L2_READY_DATA              ,
        output                                  READ_ADDR_TO_L2_VALID_DATA              ,
        output  [ADDRESS_WIDTH - 2 - 1  : 0]    READ_ADDR_TO_L2_DATA                    ,
        output                                  DATA_FROM_L2_READY_DATA                 ,
        input                                   DATA_FROM_L2_VALID_DATA                 ,
        input   [L2_BUS_WIDTH   - 1     : 0]    DATA_FROM_L2_DATA                       ,
        
        // Test Outputs
        output  [ADDRESS_WIDTH - 1     : 0]     PC                                      ,
        output  [DATA_WIDTH - 1        : 0]     INSTRUCTION                             ,
        output  [DATA_WIDTH - 1        : 0]     ALU_INSTRUCTION                         ,
        output  [DATA_WIDTH - 1        : 0]     RS1_DATA                                ,
        output  [DATA_WIDTH - 1        : 0]     PC_EXECUTION                            ,
        output  [DATA_WIDTH - 1        : 0]     RS2_DATA                                ,
        output  [DATA_WIDTH - 1        : 0]     IMM_DATA                                ,
        output  [DATA_WIDTH - 1        : 0]     ALU_OUT                                 ,
        output  [D_CACHE_LW_WIDTH - 1  : 0]     DATA_CACHE_LOAD                         ,
        output  [D_CACHE_SW_WIDTH - 1  : 0]     DATA_CACHE_STORE                        ,
        output  [DATA_WIDTH - 1        : 0]     RD_DATA_WRITE_BACK                                               
    );
    
    // Programe Counter --> Instruction Cache / Instruction Fetch 1  
    wire    [ADDRESS_WIDTH - 1     : 0]     pc_pc_to_if1                                ;
    wire                                    pc_valid_pc_to_if1                          ; 
    
    // Programe Counter --> Instruction Fetch 1 , 2 , 3 
    wire                                    clear_instruction_fetch_stage               ;
    
    // Programe Counter --> Decoding Stage
    wire                                    clear_decoding_stage                        ;
    
    // Hazard Control Unit --> All Stages
    wire                                    stall_programe_counter_stage                ;
    wire                                    stall_instruction_cache                     ;
    wire                                    stall_instruction_fetch_stage               ;
    wire                                    stall_decoding_stage                        ;
    wire                                    stall_execution_stage                       ;
    wire                                    stall_data_cache                            ;
    wire                                    stall_data_memory_stage                     ;
    
    // Instruction Cache --> Decoding Stage 
    wire    [DATA_WIDTH - 1        : 0]     instruction                                 ;
    
    // Instruction Cache --> Hazard Control Unit
    wire                                    instruction_cache_ready                     ;

    // Instruction Fetch 1 --> Instruction Fetch 2
    wire    [ADDRESS_WIDTH - 1     : 0]     pc_if1_to_if2                               ;
    wire                                    pc_valid_if1_to_if2                         ;   
    
    // Instruction Fetch 2 --> Instruction Fetch 3
    wire    [ADDRESS_WIDTH - 1     : 0]     pc_if2_to_if3                               ;
    wire                                    pc_valid_if2_to_if3                         ; 
   
    // Instruction Fetch 3 --> Decoding Stage 
    wire    [ADDRESS_WIDTH - 1     : 0]     pc_if3_to_decoding_stage                    ;
    wire                                    pc_valid_if3_to_decoding_stage              ; 
    
    // Decoding Stage --> Programe Counter / Execution Stage
    wire    [DATA_WIDTH - 1        : 0]     imm_data                                    ;
    wire    [ALU_INS_WIDTH - 1     : 0]     alu_instruction                             ;
    
    // Decoding Stage --> Hazard Control Unit / Forwarding Unit
    wire    [REG_ADD_WIDTH -1      : 0]     rs1_address                                 ;
    wire    [REG_ADD_WIDTH -1      : 0]     rs2_address                                 ;
    
    // Decoding Stage --> Forwarding Unit
    wire    [DATA_WIDTH - 1        : 0]     rs1_data_decoding_to_forwarding_unit        ;
    wire    [DATA_WIDTH - 1        : 0]     rs2_data_decoding_to_forwarding_unit        ;
    
    // Decoding Stage --> Execution Stage  
    wire    [ADDRESS_WIDTH - 1     : 0]     pc_decoding_to_execution                    ;
    wire    [REG_ADD_WIDTH -1      : 0]     rd_address_decoding_to_execution            ; 
    wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load_decoding_to_execution       ;
    wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store_decoding_to_execution      ;
    wire    [DATA_WIDTH - 1        : 0]     data_cache_store_data_decoding_to_execution ;
    wire                                    write_back_mux_select_decoding_to_execution ;
    wire                                    rd_write_enable_out_decoding_to_execution   ;
    wire                                    alu_input_1_select                          ;
    wire                                    alu_input_2_select                          ; 
    
    // Forwarding Unit --> Programe Counter / Execution Stage 
    wire    [DATA_WIDTH - 1        : 0]     rs1_data                                    ;
    
    // Forwarding Unit --> Execution Stage
    wire    [DATA_WIDTH - 1        : 0]     rs2_data                                    ;
    
    // Execution Stage --> Programe Counter
    wire                                    branch_taken                                ;
    
    // Execution Stage --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 1
    wire    [REG_ADD_WIDTH -1      : 0]     rd_address_execution_to_dm1                 ;
	
	// Execution Stage --> Hazard Control Unit / Data Cache / Data Memory Stage 1
	wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load_execution_to_dm1            ;
	wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store_execution_to_dm1           ;
	
	// Execution Stage --> Data Cache
	wire    [DATA_WIDTH - 1        : 0]     data_cache_store_data                       ;
    
    // Execution Stage --> Data Cache / Data Memory Stage 1
    wire    [DATA_WIDTH - 1        : 0]     alu_out_execution_to_dm1                    ;
    
    // Execution Stage --> Data Memory Stage 1
    wire                                    write_back_mux_select_execution_to_dm1      ;
    wire                                    rd_write_enable_execution_to_dm1            ;
    
    // Data Cache --> Hazard Control Unit
    wire                                    data_cache_ready                            ;
    
    // Data Cache --> Write Back Stage
    wire    [DATA_WIDTH - 1        : 0]     data_cache_read_data                        ;
    
    // Data Memory Stage 1 --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 2   
    wire    [REG_ADD_WIDTH -1      : 0]     rd_address_dm1_to_dm2                       ;
    
	// Data Memory Stage 1 --> Hazard Control Unit / Data Memory Stage 2
	wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load_dm1_to_dm2                  ;
	wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store_dm1_to_dm2                 ;
	
    // Data Memory Stage 1 --> Data Memory Stage 2
    wire    [DATA_WIDTH - 1        : 0]     alu_out_dm1_to_dm2                          ;
    wire                                    write_back_mux_select_dm1_to_dm2            ;
    wire                                    rd_write_enable_dm1_to_dm2                  ;
    
    // Data Memory Stage 2 --> Hazard Control Unit / Forwarding Unit / Data Memory Stage 3   
    wire    [REG_ADD_WIDTH -1      : 0]     rd_address_dm2_to_dm3                       ;
	
	// Data Memory Stage 2 --> Hazard Control Unit / Data Memory Stage 3
	wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load_dm2_to_dm3                  ;
	wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store_dm2_to_dm3                 ;
    
    // Data Memory Stage 2 --> Data Memory Stage 3
    wire    [DATA_WIDTH - 1        : 0]     alu_out_dm2_to_dm3                          ;
    wire                                    write_back_mux_select_dm2_to_dm3            ;
    wire                                    rd_write_enable_dm2_to_dm3                  ; 
    
    // Data Memory Stage 3 --> Hazard Control Unit / Forwarding Unit / Write Back Stage   
    wire    [REG_ADD_WIDTH -1      : 0]     rd_address_dm3_to_write_back                ;
    
    // Data Memory Stage 3 --> Hazard Control Unit / Write Back Stage
    wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load_dm3_to_write_back           ;
    wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store_dm3_to_write_back          ;
    
    // Data Memory Stage 3 --> Write Back Stage
    wire    [DATA_WIDTH - 1        : 0]     alu_out_dm3_to_write_back                   ;
    wire                                    write_back_mux_select_dm3_to_write_back     ;
    wire                                    rd_write_enable_dm3_to_write_back           ;
          
    // Write Back Stage 
    wire    [DATA_WIDTH - 1        : 0]     rd_data_write_back                          ;
    
    
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
        .INSTRUCTION_CACHE_READY(instruction_cache_ready),
        .DATA_CACHE_READY(data_cache_ready),
        .RS1_ADDRESS_EXECUTION(rs1_address),
        .RS2_ADDRESS_EXECUTION(rs2_address),
        .DATA_CACHE_LOAD_DM1(data_cache_load_execution_to_dm1),
        .DATA_CACHE_STORE_DM1(),         
        .RD_ADDRESS_DM1(rd_address_execution_to_dm1),
        .DATA_CACHE_LOAD_DM2(data_cache_load_dm1_to_dm2),
        .DATA_CACHE_STORE_DM2(),
        .RD_ADDRESS_DM2(rd_address_dm1_to_dm2),
        .DATA_CACHE_LOAD_DM3(data_cache_load_dm2_to_dm3),
        .DATA_CACHE_STORE_DM3(),
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
        .INSTRUCTION_CACHE_READY(instruction_cache_ready),
        .ADDRESS_TO_L2_READY_INS(ADDRESS_TO_L2_READY_INS),
        .ADDRESS_TO_L2_VALID_INS(ADDRESS_TO_L2_VALID_INS),      
        .ADDRESS_TO_L2_INS(ADDRESS_TO_L2_INS),    
        .DATA_FROM_L2_READY_INS(DATA_FROM_L2_READY_INS),
        .DATA_FROM_L2_VALID_INS(DATA_FROM_L2_VALID_INS),
        .DATA_FROM_L2_INS(DATA_FROM_L2_INS)   
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
        .DATA_CACHE_STORE(data_cache_store_decoding_to_execution),
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
        .DATA_CACHE_STORE_IN(data_cache_store_decoding_to_execution),
        .DATA_CACHE_STORE_DATA_IN(data_cache_store_data_decoding_to_execution),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_decoding_to_execution),
        .RD_WRITE_ENABLE_IN(rd_write_enable_out_decoding_to_execution),
        .RD_ADDRESS_OUT(rd_address_execution_to_dm1),
        .ALU_OUT(alu_out_execution_to_dm1),
        .BRANCH_TAKEN(branch_taken),
        .DATA_CACHE_LOAD_OUT(data_cache_load_execution_to_dm1),
        .DATA_CACHE_STORE_OUT(data_cache_store_execution_to_dm1),
        .DATA_CACHE_STORE_DATA_OUT(data_cache_store_data),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_execution_to_dm1),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_execution_to_dm1)   
        );
    
    DATA_CACHE data_cache(
        .CLK(CLK),
        .STALL_DATA_CACHE(stall_data_cache),
        .DATA_CACHE_READ_ADDRESS(alu_out_execution_to_dm1),
        .DATA_CACHE_LOAD(data_cache_load_execution_to_dm1),
        .DATA_CACHE_WRITE_ADDRESS(alu_out_execution_to_dm1),
        .DATA_CACHE_WRITE_DATA(data_cache_store_data),
        .DATA_CACHE_STORE(data_cache_store_execution_to_dm1),
        .DATA_CACHE_READY(data_cache_ready),
        .DATA_CACHE_READ_DATA(data_cache_read_data),
        .WRITE_TO_L2_READY_DATA(WRITE_TO_L2_READY_DATA),
        .WRITE_TO_L2_VALID_DATA(WRITE_TO_L2_VALID_DATA),
        .WRITE_ADDR_TO_L2_DATA(WRITE_ADDR_TO_L2_DATA),
        .DATA_TO_L2_DATA(DATA_TO_L2_DATA),
        .WRITE_CONTROL_TO_L2_DATA(WRITE_CONTROL_TO_L2_DATA),
        .WRITE_COMPLETE_DATA(WRITE_COMPLETE_DATA),
        .READ_ADDR_TO_L2_READY_DATA(READ_ADDR_TO_L2_READY_DATA),
        .READ_ADDR_TO_L2_VALID_DATA(READ_ADDR_TO_L2_VALID_DATA),
        .READ_ADDR_TO_L2_DATA(READ_ADDR_TO_L2_DATA),
        .DATA_FROM_L2_READY_DATA(DATA_FROM_L2_READY_DATA),
        .DATA_FROM_L2_VALID_DATA(DATA_FROM_L2_VALID_DATA),
        .DATA_FROM_L2_DATA(DATA_FROM_L2_DATA)  
        );
        
    DATA_MEMORY_STAGE data_memory_stage_1(
        .CLK(CLK),
        .STALL_DATA_MEMORY_STAGE(stall_data_memory_stage),
        .RD_ADDRESS_IN(rd_address_execution_to_dm1),
        .ALU_OUT_IN(alu_out_execution_to_dm1),
        .DATA_CACHE_LOAD_IN(data_cache_load_execution_to_dm1),
        .DATA_CACHE_STORE_IN(data_cache_store_execution_to_dm1),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_execution_to_dm1),
        .RD_WRITE_ENABLE_IN(rd_write_enable_execution_to_dm1),
        .RD_ADDRESS_OUT(rd_address_dm1_to_dm2),
        .ALU_OUT_OUT(alu_out_dm1_to_dm2),
        .DATA_CACHE_LOAD_OUT(data_cache_load_dm1_to_dm2),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm1_to_dm2),
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
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_dm1_to_dm2),
        .RD_WRITE_ENABLE_IN(rd_write_enable_dm1_to_dm2),
        .RD_ADDRESS_OUT(rd_address_dm2_to_dm3),
        .ALU_OUT_OUT(alu_out_dm2_to_dm3),
        .DATA_CACHE_LOAD_OUT(data_cache_load_dm2_to_dm3),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm2_to_dm3),
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
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_dm2_to_dm3),
        .RD_WRITE_ENABLE_IN(rd_write_enable_dm2_to_dm3),
        .RD_ADDRESS_OUT(rd_address_dm3_to_write_back),
        .ALU_OUT_OUT(alu_out_dm3_to_write_back),
        .DATA_CACHE_LOAD_OUT(data_cache_load_dm3_to_write_back),
        .DATA_CACHE_STORE_OUT(data_cache_store_dm3_to_write_back),
        .WRITE_BACK_MUX_SELECT_OUT(write_back_mux_select_dm3_to_write_back),
        .RD_WRITE_ENABLE_OUT(rd_write_enable_dm3_to_write_back)
        );
      
    WRITE_BACK_STAGE write_back_stage(
        .ALU_OUT_IN(alu_out_dm3_to_write_back),
        .DATA_CACHE_OUT_DATA(data_cache_read_data),
        .WRITE_BACK_MUX_SELECT_IN(write_back_mux_select_dm3_to_write_back),
        .WRITE_BACK_MUX_OUT(rd_data_write_back)
        );
    
    assign PC                       = pc_pc_to_if1                              ;
    assign INSTRUCTION              = instruction                               ;
    assign ALU_INSTRUCTION          = alu_instruction                           ;
    assign RS1_DATA                 = rs1_data                                  ;
    assign PC_EXECUTION             = pc_decoding_to_execution                  ;
    assign RS2_DATA                 = rs2_data                                  ;
    assign IMM_DATA                 = imm_data                                  ;
    assign ALU_OUT                  = alu_out_execution_to_dm1                  ;
    assign DATA_CACHE_LOAD          = data_cache_load_execution_to_dm1          ;
    assign DATA_CACHE_STORE         = data_cache_store_execution_to_dm1         ;
    assign RD_DATA_WRITE_BACK       = rd_data_write_back                        ;
       
endmodule
