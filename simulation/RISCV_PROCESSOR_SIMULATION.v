`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/26/2017 04:11:49 PM
// Design Name: 
// Module Name:     RISCV_PROCESSOR_SIMULATION
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


module RISCV_PROCESSOR_SIMULATION();

    parameter   ADDRESS_WIDTH           = 32    ;
    parameter   DATA_WIDTH              = 32    ;
    parameter   D_CACHE_LW_WIDTH        = 3     ;
    parameter   D_CACHE_SW_WIDTH        = 2     ;
    parameter   L2_BUS_WIDTH            = 32    ;
    parameter   INS_RAM_DEPTH           = 14    ; 
    parameter   DAT_RAM_DEPTH           = 4096  ; 
    
    parameter   HIGH                    = 1'b1  ;        
    parameter   LOW                     = 1'b0  ;
    
    //Standerd Inputs
    reg                                     clk                                     ;
    
    //Instruction Cache
    // Transfer Address From L1 to L2 Cache
    wire                                    address_to_l2_ready_ins                 ;
    wire                                    address_to_l2_valid_ins                 ;      
    wire    [ADDRESS_WIDTH - 2 - 1 : 0]     address_to_l2_ins                       ;
    // Transfer Data From L2 to L1 Cache       
    wire                                    data_from_l2_valid_ins                  ;
    wire                                    data_from_l2_ready_ins                  ;
    wire    [L2_BUS_WIDTH   - 1    : 0]     data_from_l2_ins                        ;
    
    //Data Cache
    // Write Data From L1 to L2 Cache
    wire                                    write_to_l2_ready_data                  ;
    wire                                    write_to_l2_valid_data                  ;
    wire    [ADDRESS_WIDTH - 2 - 1  : 0]    write_addr_to_l2_data                   ;
    wire    [L2_BUS_WIDTH   - 1     : 0]    data_to_l2_data                         ;
    wire                                    write_control_to_l2_data                ;
    wire                                    write_complete_data                     ;
    // Read Data From L2 to L1 Cache
    wire                                    read_addr_to_l2_ready_data              ;
    wire                                    read_addr_to_l2_valid_data              ;
    wire    [ADDRESS_WIDTH - 2 - 1  : 0]    read_addr_to_l2_data                    ;
    wire                                    data_from_l2_ready_data                 ;
    wire                                    data_from_l2_valid_data                 ;
    wire    [L2_BUS_WIDTH   - 1     : 0]    data_from_l2_data                       ;
   
    // Test Outputs
    wire    [ADDRESS_WIDTH - 1     : 0]     pc                                      ;
    wire    [DATA_WIDTH - 1        : 0]     instruction                             ;
    wire    [DATA_WIDTH - 1        : 0]     alu_instruction                         ;
    wire    [DATA_WIDTH - 1        : 0]     rs1_data                                ;
    wire    [DATA_WIDTH - 1        : 0]     pc_execution                            ;
    wire    [DATA_WIDTH - 1        : 0]     rs2_data                                ;
    wire    [DATA_WIDTH - 1        : 0]     imm_data                                ;                    
    wire    [DATA_WIDTH - 1        : 0]     alu_out                                 ;
    wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load                         ;
    wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store                        ;
    wire    [DATA_WIDTH - 1        : 0]     rd_data_write_back                      ;
   
    // Instantiate the Unit Under Test (UUT)
    RISCV_PROCESSOR uut(
        .CLK(clk),
        .PC(pc),
        .INSTRUCTION(instruction),
        .ALU_INSTRUCTION(alu_instruction),
        .RS1_DATA(rs1_data),
        .PC_EXECUTION(pc_execution),
        .RS2_DATA(rs2_data),
        .IMM_DATA(imm_data),
        .ALU_OUT(alu_out),
        .DATA_CACHE_LOAD(),
        .DATA_CACHE_STORE(),
        .RD_DATA_WRITE_BACK(rd_data_write_back),
        .ADDRESS_TO_L2_READY_INS(address_to_l2_ready_ins),
        .ADDRESS_TO_L2_VALID_INS(address_to_l2_valid_ins),      
        .ADDRESS_TO_L2_INS(address_to_l2_ins),    
        .DATA_FROM_L2_VALID_INS(data_from_l2_valid_ins),
        .DATA_FROM_L2_READY_INS(data_from_l2_ready_ins),
        .DATA_FROM_L2_INS(data_from_l2_ins),
        .WRITE_TO_L2_READY_DATA(write_to_l2_ready_data),
        .WRITE_TO_L2_VALID_DATA(write_to_l2_valid_data),
        .WRITE_ADDR_TO_L2_DATA(write_addr_to_l2_data),
        .DATA_TO_L2_DATA(data_to_l2_data),
        .WRITE_CONTROL_TO_L2_DATA(write_control_to_l2_data),
        .WRITE_COMPLETE_DATA(write_complete_data),
        .READ_ADDR_TO_L2_READY_DATA(read_addr_to_l2_ready_data),
        .READ_ADDR_TO_L2_VALID_DATA(read_addr_to_l2_valid_data),
        .READ_ADDR_TO_L2_DATA(read_addr_to_l2_data),
        .DATA_FROM_L2_READY_DATA(data_from_l2_ready_data),
        .DATA_FROM_L2_VALID_DATA(data_from_l2_valid_data),
        .DATA_FROM_L2_DATA(data_from_l2_data)                 
        );
    
    // L2 Cache emulators
    reg [DATA_WIDTH - 1 : 0] ins_memory     [0: INS_RAM_DEPTH - 1]  ;  
    reg [DATA_WIDTH - 1 : 0] data_memory    [0: DAT_RAM_DEPTH - 1]  ;  
    
    //////////////////------ TEST CODE ------//////////////////
    reg                                     data_from_l2_valid_ins_reg              ;
    reg    [L2_BUS_WIDTH   - 1      : 0]    data_from_l2_ins_reg                    ;
    
    reg    [ADDRESS_WIDTH - 2 - 1   : 0]    write_addr_to_l2_data_reg               ;  
    reg    [L2_BUS_WIDTH   - 1      : 0]    data_to_l2_data_reg                     ;
    
    reg                                     data_from_l2_valid_data_reg             ;
    reg    [L2_BUS_WIDTH   - 1      : 0]    data_from_l2_data_reg                   ;
    
    initial 
    begin
        // Initialize Inputs
        clk                             = 1'b0          ;
        data_from_l2_ins_reg            = 32'b0         ;
        data_from_l2_valid_ins_reg      = 1'b0          ;
        
        $readmemh("D:/Study/Verilog/RISC-V/verification programs/add/add.hex",ins_memory);
        
        #100    ;
        
        repeat(30)
        begin
            clk = ~ clk;
            #100;
        end
            
    end
    
    always@(posedge clk)
    begin
        if(address_to_l2_valid_ins == HIGH)
        begin
            data_from_l2_valid_ins_reg  <= HIGH                                 ;
            data_from_l2_ins_reg        <= ins_memory [address_to_l2_ins]       ;
        end
        
        if(write_to_l2_valid_data == HIGH)
        begin
            write_addr_to_l2_data_reg   <= write_addr_to_l2_data                ;
            data_to_l2_data_reg         <= data_to_l2_data                      ;             
        end
        
        if(read_addr_to_l2_valid_data == HIGH)
        begin
            data_from_l2_valid_data_reg <= HIGH                                 ;
            data_from_l2_data_reg       <= data_memory [read_addr_to_l2_data]   ;
        end
        
        data_memory [write_addr_to_l2_data_reg] <= data_to_l2_data_reg          ;
    end
    
    assign data_from_l2_valid_ins   = data_from_l2_valid_ins_reg                ;
    assign data_from_l2_ins         = data_from_l2_ins_reg                      ;
   
    assign data_from_l2_valid_data  = data_from_l2_valid_data_reg               ;
    assign data_from_l2_data        = data_from_l2_data_reg                     ;
    
    //////////////////------ TEST CODE ------//////////////////
    
endmodule
