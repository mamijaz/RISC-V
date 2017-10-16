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

    parameter   HIGH                    = 1'b1                                      ;        
    parameter   LOW                     = 1'b0                                      ;

    parameter   ADDRESS_WIDTH           = 32                                        ;
    parameter   DATA_WIDTH              = 32                                        ;
    parameter   REG_ADD_WIDTH           = 5                                         ;
    parameter   ALU_INS_WIDTH           = 5                                         ;
    parameter   D_CACHE_LW_WIDTH        = 3                                         ;
    parameter   D_CACHE_SW_WIDTH        = 2                                         ;
    
    parameter   L2_BUS_WIDTH            = 32                                        ; 
    parameter   DAT_RAM_DEPTH           = 512                                       ; 
    
    parameter   WORD_SIZE               = 4                                         ;
    parameter   WORD_PER_BLOCK          = 16                                        ;
    parameter   INS_RAM_DEPTH           = 64                                        ;
    
    localparam  WORD_WIDTH              = WORD_SIZE*8                               ;
    localparam  BLOCK_WIDTH             = WORD_WIDTH*WORD_PER_BLOCK                 ;
    localparam  BLOCK_ADDRESS_WIDTH     = 26                                        ; 
    
    //Standerd Inputs
    reg                                     clk                                     ;
    
    //Instruction Cache
    // Transfer Address From L1 to L2 Cache
    reg                                     address_to_l2_ready_instruction_cache   ;
    wire                                    address_to_l2_valid_instruction_cache   ;      
    wire    [BLOCK_ADDRESS_WIDTH-1 : 0]     address_to_l2_instruction_cache         ;
    // Transfer Data From L2 to L1 Cache       
    reg                                     data_from_l2_valid_instruction_cache    ;
    wire                                    data_from_l2_ready_instruction_cache    ;
    reg     [BLOCK_WIDTH - 1       : 0]     data_from_l2_instruction_cache          ;
    
    //Data Cache
    // Write Data From L1 to L2 Cache
    wire                                    write_to_l2_ready_data                  ;
    wire                                    write_to_l2_valid_data                  ;
    wire    [ADDRESS_WIDTH - 2 - 1 : 0]     write_addr_to_l2_data                   ;
    wire    [L2_BUS_WIDTH   - 1    : 0]     data_to_l2_data                         ;
    wire                                    write_control_to_l2_data                ;
    wire                                    write_complete_data                     ;
    // Read Data From L2 to L1 Cache
    wire                                    read_addr_to_l2_ready_data              ;
    wire                                    read_addr_to_l2_valid_data              ;
    wire    [ADDRESS_WIDTH - 2 - 1 : 0]     read_addr_to_l2_data                    ;
    wire                                    data_from_l2_ready_data                 ;
    wire                                    data_from_l2_valid_data                 ;
    wire    [L2_BUS_WIDTH   - 1    : 0]     data_from_l2_data                       ;
   
    // Test Outputs
    wire    [ADDRESS_WIDTH - 1     : 0]     pc                                      ;
    wire    [DATA_WIDTH - 1        : 0]     instruction                             ;
    wire    [ALU_INS_WIDTH - 1     : 0]     alu_instruction                         ;
    wire    [DATA_WIDTH - 1        : 0]     rs1_data                                ;
    wire    [DATA_WIDTH - 1        : 0]     pc_execution                            ;
    wire    [DATA_WIDTH - 1        : 0]     rs2_data                                ;
    wire    [DATA_WIDTH - 1        : 0]     imm_data                                ;                    
    wire    [DATA_WIDTH - 1        : 0]     alu_out                                 ;
    wire    [REG_ADD_WIDTH - 1     : 0]     rd_address                              ;
    wire    [D_CACHE_LW_WIDTH - 1  : 0]     data_cache_load                         ;
    wire    [D_CACHE_SW_WIDTH - 1  : 0]     data_cache_store                        ;
    wire    [DATA_WIDTH - 1        : 0]     rd_data_write_back                      ;
    wire                                    pc_mispredicted                         ;
   
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
        .RD_ADDRESS(rd_address),
        .DATA_CACHE_LOAD(data_cache_load),
        .DATA_CACHE_STORE(data_cache_store),
        .RD_DATA_WRITE_BACK(rd_data_write_back),
        .PC_MISPREDICTED(pc_mispredicted),
        .ADDRESS_TO_L2_READY_INSTRUCTION_CACHE(address_to_l2_ready_instruction_cache),
        .ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE(address_to_l2_valid_instruction_cache),      
        .ADDRESS_TO_L2_INSTRUCTION_CACHE(address_to_l2_instruction_cache),    
        .DATA_FROM_L2_VALID_INSTRUCTION_CACHE(data_from_l2_valid_instruction_cache),
        .DATA_FROM_L2_READY_INSTRUCTION_CACHE(data_from_l2_ready_instruction_cache),
        .DATA_FROM_L2_INSTRUCTION_CACHE(data_from_l2_instruction_cache),
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
    reg [DATA_WIDTH - 1     : 0] instruction_memory     [0: INS_RAM_DEPTH - 1               ]  ;  
    reg [DATA_WIDTH - 1     : 0] data_memory            [0: DAT_RAM_DEPTH - 1               ]  ;  
    
    reg [BLOCK_WIDTH - 1    : 0] l2_memory              [0: INS_RAM_DEPTH/WORD_PER_BLOCK - 1]   ;
    
    //////////////////------ TEST CODE ------//////////////////
    
    reg    [ADDRESS_WIDTH - 2 - 1   : 0]    write_addr_to_l2_data_reg                   ;  
    reg    [L2_BUS_WIDTH   - 1      : 0]    data_to_l2_data_reg                         ;
    
    reg                                     data_from_l2_valid_data_reg                 ;
    reg    [L2_BUS_WIDTH   - 1      : 0]    data_from_l2_data_reg                       ;
    
    
    integer i,j;
    initial 
    begin
        // Initialize Inputs
        clk                                         = 1'b0          ;
        
        address_to_l2_ready_instruction_cache       = 1'b1          ;
        data_from_l2_instruction_cache              = 32'b0         ;
        data_from_l2_valid_instruction_cache        = 1'b0          ;
        
        write_addr_to_l2_data_reg                   = 30'b0         ;
        data_to_l2_data_reg                         = 32'b0         ;
        
        data_from_l2_valid_data_reg                 = 1'b0          ;
        data_from_l2_data_reg                       = 32'b0         ;
        
        //add
        $readmemh("D:/Study/Verilog/RISC-V/verification programs/add/add.hex",instruction_memory);				//Success-30
        
        //count
        //$readmemh("D:/Study/Verilog/RISC-V/verification programs/count/count.hex",instruction_memory);			//Success
        
        //sum
        //$readmemh("D:/Study/Verilog/RISC-V/verification programs/sum/sum.hex",instruction_memory);            	//Success-45
        
        //fibonacci
        //$readmemh("D:/Study/Verilog/RISC-V/verification programs/fibonacci/fibonacci.hex",instruction_memory); 	//Success-34
        
        for(i=0;i<INS_RAM_DEPTH/WORD_PER_BLOCK;i=i+1)
        begin
            l2_memory[i] = {BLOCK_WIDTH{1'b0}} ;
            for(j=0;j<WORD_PER_BLOCK;j=j+1)
            begin
                l2_memory[i] = l2_memory[i] << WORD_WIDTH                               ;
                l2_memory[i] = l2_memory[i] | instruction_memory[i*WORD_PER_BLOCK + j]  ;
            end
        end
        
        for(i = 0 ;i < DAT_RAM_DEPTH ; i = i + 1)
        begin
            data_memory [i] <= 32'b0    ;
        end
        
        #200    ;
        
        while(1)
        begin
            clk = ~ clk;
            #100;
        end
            
    end
    
    always@(posedge clk)
    begin
        //Instruction cache
        if(data_from_l2_ready_instruction_cache == HIGH)
        begin
            if(address_to_l2_valid_instruction_cache == HIGH)
            begin
                data_from_l2_valid_instruction_cache    <= HIGH                                                     ;
                data_from_l2_instruction_cache          <= l2_memory [address_to_l2_instruction_cache]              ;
            end
            else 
            begin
                data_from_l2_valid_instruction_cache    <= LOW                      ;
                data_from_l2_instruction_cache          <= {BLOCK_WIDTH{1'b0}}      ;
            end
        end
        else
        begin
            data_from_l2_valid_instruction_cache    <= LOW                      ;
            data_from_l2_instruction_cache          <= {BLOCK_WIDTH{1'b0}}      ;
        end
        
        //Data Cache
        if(read_addr_to_l2_valid_data == HIGH)
        begin
            data_from_l2_valid_data_reg <= HIGH                                 ;
            data_from_l2_data_reg       <= data_memory [read_addr_to_l2_data]   ;
        end
        else
        begin
            data_from_l2_valid_data_reg <= LOW                                  ;
            data_from_l2_data_reg       <= 32'b0                                ;
        end
        
        if(write_to_l2_valid_data == HIGH)
        begin
            data_memory [write_addr_to_l2_data] <= data_to_l2_data              ;
            //write_addr_to_l2_data_reg   <= write_addr_to_l2_data                ;
            //data_to_l2_data_reg         <= data_to_l2_data                      ;             
        end
        
        //data_memory [write_addr_to_l2_data_reg] <= data_to_l2_data_reg          ;
    end
   
    assign data_from_l2_valid_data              = data_from_l2_valid_data_reg               ;
    assign data_from_l2_data                    = data_from_l2_data_reg                     ;
    
    //////////////////------ TEST CODE ------//////////////////
    
endmodule
