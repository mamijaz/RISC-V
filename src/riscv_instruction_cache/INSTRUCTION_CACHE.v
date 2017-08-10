`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:12:26 AM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE
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


module INSTRUCTION_CACHE #(
        parameter   ADDRESS_WIDTH           = 32                            ,
        parameter   DATA_WIDTH              = 32                            ,
        
        parameter   CACHE_SIZE              = 64*1024                       ,
        parameter   WORD_SIZE               = 4                             ,
        parameter   WORD_PER_BLOCK          = 16                            ,
               
        parameter   HIGH                    = 1'b1                          ,
        parameter   LOW                     = 1'b0                          ,
        
        localparam  L2_BUS_WIDTH            = WORD_PER_BLOCK * 8            ,
        localparam  BLOCK_SIZE              = WORD_PER_BLOCK * WORD_SIZE    ,
        localparam  MEMORY_DEPTH            = CACHE_SIZE / (2 * BLOCK_SIZE) ,
        localparam  BYTE_SELECT             = $clog2(WORD_SIZE-1)           ,
        localparam  WORD_SELECT             = $clog2(WORD_PER_BLOCK-1)      ,
        localparam  LINE_SELECT             = $clog2(MEMORY_DEPTH-1)        ,
        localparam  TAG_WIDTH               = ADDRESS_WIDTH - ( LINE_SELECT + WORD_SELECT + BYTE_SELECT )
    ) (
        input                                   CLK                         ,
        input                                   STALL_INSTRUCTION_CACHE     ,
        input   [ADDRESS_WIDTH - 1      : 0]    PC                          ,
        input                                   PC_VALID                    ,
        output  [ADDRESS_WIDTH - 1      : 0]    INSTRUCTION                 ,
        output                                  INSTRUCTION_CACHE_READY     ,
        
        // Transfer Address From L1 to L2 Cache 
        input                                   ADDRESS_TO_L2_READY_INS     ,
        output                                  ADDRESS_TO_L2_VALID_INS     ,      
        output   [ADDRESS_WIDTH - 2 - 1 : 0]    ADDRESS_TO_L2_INS           ,
                
        // Transfer Data From L2 to L1 Cache   
        output                                  DATA_FROM_L2_READY_INS      ,
        input                                   DATA_FROM_L2_VALID_INS      ,
        input    [L2_BUS_WIDTH   - 1    : 0]    DATA_FROM_L2_INS
    );
    
    reg                                     instruction_cache_ready_reg     ;
    reg                                     address_to_l2_valid_ins_reg     ;
    reg     [ADDRESS_WIDTH - 2 - 1   : 0]   address_to_l2_ins_reg           ;
    reg                                     data_from_l2_ready_ins_reg      ;
    reg     [DATA_WIDTH - 1          : 0]   instruction_reg                 ; 
    
    initial
    begin
        instruction_cache_ready_reg     = HIGH                              ;
        address_to_l2_valid_ins_reg     = LOW                               ;
        address_to_l2_ins_reg           = 30'b0                             ;
        data_from_l2_ready_ins_reg      = HIGH                              ;
        instruction_reg                 = 32'b0                             ;
    end  
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(TAG_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) tag_ram_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(),                                         
        .READ_ENBLE(),                                                     
        .DATA_OUT()
        );
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(TAG_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) tag_ram_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(),                                         
        .READ_ENBLE(),                                                     
        .DATA_OUT()
        ); 
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_SIZE),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(),                                         
        .READ_ENBLE(),                                                     
        .DATA_OUT()
        ); 
       
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_SIZE),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(),                                         
        .READ_ENBLE(),                                                     
        .DATA_OUT()
        ); 
    
    ENCODER_FOR_2_WAY_ASSOCIATIVE_CACHE encoder_for_2_way_associative_cache(
        .IN1(),
        .IN2(),
        .OUT()
        );
        
    MULTIPLEXER_2_TO_1 select_set(
        );
    
    MULTIPLEXER_16_TO_1 select_word(
        );
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(1),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) lru(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(),                                         
        .READ_ENBLE(),                                                     
        .DATA_OUT()
        ); 
                                  
    
    always@(posedge CLK)
    begin
    
    end
    
    assign  INSTRUCTION_CACHE_READY     = instruction_cache_ready_reg       ;
    assign  ADDRESS_TO_L2_INS           = address_to_l2_ins_reg             ;
    assign  ADDRESS_TO_L2_VALID_INS     = address_to_l2_valid_ins_reg       ;
    assign  DATA_FROM_L2_READY_INS      = data_from_l2_ready_ins_reg        ;
    assign  INSTRUCTION                 = instruction_reg                   ;
   
endmodule
