`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/09/2017 09:46:11 PM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE_SIMULATION
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


module INSTRUCTION_CACHE_SIMULATION();

    parameter   HIGH                    = 1'b1                                          ;
    parameter   LOW                     = 1'b0                                          ;

    parameter   ADDRESS_WIDTH           = 32                                            ;
    parameter   WORD_SIZE               = 4                                             ;
    parameter   WORD_PER_BLOCK          = 16                                            ;
    parameter   L2_BUS_WIDTH            = 32                                            ;
    parameter   INS_RAM_DEPTH           = 64                                            ;
    
    localparam  WORD_WIDTH              = WORD_SIZE*8                                   ;
    localparam  BLOCK_WIDTH             = WORD_WIDTH*WORD_PER_BLOCK                     ;
    localparam  BLOCK_ADDRESS_WIDTH     = 26                                            ; 
    
    // Inputs
    reg                                     clk                                         ;
    reg                                     stall_instruction_cache                     ;
    reg     [ADDRESS_WIDTH - 1      : 0]    pc                                          ;
    reg                                     pc_valid                                    ;
    reg                                     address_to_l2_ready_instruction_cache       ;
    reg                                     data_from_l2_valid_instruction_cache        ;
    reg     [BLOCK_WIDTH   - 1      : 0]    data_from_l2_instruction_cache              ;
     
    // Outputs
    wire    [ADDRESS_WIDTH - 1      : 0]    instruction                                 ;
    wire                                    instruction_cache_ready                     ;
    wire                                    address_to_l2_valid_instruction_cache       ;      
    wire    [BLOCK_ADDRESS_WIDTH - 1: 0]    address_to_l2_instruction_cache             ;
    wire                                    data_from_l2_ready_instruction_cache        ;
     
    // Instantiate the Unit Under Test (UUT)
    INSTRUCTION_CACHE uut(
        .CLK(clk),
        .STALL_INSTRUCTION_CACHE(stall_instruction_cache),
        .PC(pc),
        .PC_VALID(pc_valid),
        .INSTRUCTION(instruction),
        .INSTRUCTION_CACHE_READY(instruction_cache_ready),
        .ADDRESS_TO_L2_READY_INSTRUCTION_CACHE(address_to_l2_ready_instruction_cache),
        .ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE(address_to_l2_valid_instruction_cache),      
        .ADDRESS_TO_L2_INSTRUCTION_CACHE(address_to_l2_instruction_cache), 
        .DATA_FROM_L2_READY_INSTRUCTION_CACHE(data_from_l2_ready_instruction_cache),
        .DATA_FROM_L2_VALID_INSTRUCTION_CACHE(data_from_l2_valid_instruction_cache),
        .DATA_FROM_L2_INSTRUCTION_CACHE(data_from_l2_instruction_cache)
        );
    
    // L2 Cache emulators
    reg [WORD_WIDTH - 1     : 0] instruction_memory     [0: INS_RAM_DEPTH - 1               ]   ;
    reg [BLOCK_WIDTH - 1    : 0] l2_memory              [0: INS_RAM_DEPTH/WORD_PER_BLOCK - 1]   ;
     
    integer i,j;
    initial 
    begin
        // Initialize Inputs
        clk                                     = LOW           ;
        address_to_l2_ready_instruction_cache   = HIGH          ;
        stall_instruction_cache                 = LOW           ;
        pc                                      = 32'd8         ;
        pc_valid                                = HIGH          ;
        
        //add
        $readmemh("D:/Study/Verilog/RISC-V/verification programs/add/add.hex",instruction_memory);                      
        
        for(i=0;i<INS_RAM_DEPTH/WORD_PER_BLOCK;i=i+1)
        begin
            l2_memory[i] = {BLOCK_WIDTH{1'b0}} ;
            for(j=0;j<WORD_PER_BLOCK;j=j+1)
            begin
                l2_memory[i] = l2_memory[i] << WORD_WIDTH                               ;
                l2_memory[i] = l2_memory[i] | instruction_memory[i*WORD_PER_BLOCK + j]  ;
            end
        end
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #100;
        pc                                      = 32'd0         ;
        #200;
       
        pc                                      = 32'd8         ;
        #200;
        
        pc                                      = 32'd12        ;
        #200;
        
    end
    
    always
    begin
        #100;
        clk=!clk;
    end
    
    always@(posedge clk)
    begin
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
    end

endmodule
