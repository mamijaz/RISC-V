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
        
        localparam  BLOCK_SIZE              = WORD_PER_BLOCK * WORD_SIZE    ,
        localparam  BLOCK_WIDTH             = BLOCK_SIZE * 8                ,
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
        input    [BLOCK_WIDTH - 1       : 0]    DATA_FROM_L2_INS
    );
    
    // Status Registers
    reg                                     instruction_cache_ready_reg     ;
    
    // Pipeline Registers
    reg     [ADDRESS_WIDTH - 1      : 0]    pc_if2                          ;
    reg     [ADDRESS_WIDTH - 1      : 0]    pc_if3                          ;
    reg                                     hit_bank_0                      ;
    reg                                     hit_bank_1                      ;
    
    // Registers for L2
    reg                                     address_to_l2_valid_ins_reg     ;
    reg     [ADDRESS_WIDTH - 2 - 1   : 0]   address_to_l2_ins_reg           ;
    reg                                     data_from_l2_ready_ins_reg      ;
       
    wire    [LINE_SELECT - 1         : 0]   line_if1                        ;
    wire    [TAG_WIDTH - 1           : 0]   tag_if2                         ;
    wire    [TAG_WIDTH - 1           : 0]   tag_out_bank_0                  ;
    wire    [TAG_WIDTH - 1           : 0]   tag_out_bank_1                  ;
    wire    [BLOCK_WIDTH - 1         : 0]   block_out_bank_0                ;
    wire    [BLOCK_WIDTH - 1         : 0]   block_out_bank_1                ;
    wire                                    select_bank                     ;
    wire    [BLOCK_WIDTH - 1         : 0]   block_out                       ;
    wire    [WORD_SELECT - 1         : 0]   word_if3                        ;
    
    assign  line_if1    = PC[ADDRESS_WIDTH - TAG_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - 1 ]                                 ;
    assign  tag_if2     = pc_if2[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - 1 ]                                                       ;
    assign  word_if3    = pc_if3[ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - WORD_SELECT - 1 ] ;
    
    initial
    begin
        instruction_cache_ready_reg     = HIGH                              ;
        pc_if2                          = {ADDRESS_WIDTH {1'b0}}            ;
        pc_if3                          = {ADDRESS_WIDTH {1'b0}}            ;
        hit_bank_0                      = LOW                               ;
        hit_bank_1                      = LOW                               ;
        address_to_l2_valid_ins_reg     = LOW                               ;
        address_to_l2_ins_reg           = 30'b0                             ;
        data_from_l2_ready_ins_reg      = HIGH                              ;
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
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(PC_VALID),                                                     
        .DATA_OUT(tag_out_bank_0)
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
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(PC_VALID),                                                     
        .DATA_OUT(tag_out_bank_1)
        ); 
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(PC_VALID),                                                     
        .DATA_OUT(block_out_bank_0)
        ); 
       
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(),   
        .DATA_IN(),
        .WRITE_ENABLE(),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(PC_VALID),                                                     
        .DATA_OUT(block_out_bank_1)
        ); 
    
    ENCODER_FOR_2_WAY_ASSOCIATIVE_CACHE encoder_for_2_way_associative_cache(
        .IN1(hit_bank_0),
        .IN2(hit_bank_1),
        .OUT(select_bank)
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
        ) select_set(
        .IN1(block_out_bank_0),
        .IN2(block_out_bank_1),
        .SELECT(select_bank),
        .OUT(block_out)  
        );
    
    MULTIPLEXER_16_TO_1 #(
        .BUS_WIDTH(DATA_WIDTH)
        ) select_word(
        .IN1( block_out [ BLOCK_WIDTH - 15*DATA_WIDTH - 1 : BLOCK_WIDTH - 16*DATA_WIDTH ] ),
        .IN2( block_out [ BLOCK_WIDTH - 14*DATA_WIDTH - 1 : BLOCK_WIDTH - 15*DATA_WIDTH ] ),
        .IN3( block_out [ BLOCK_WIDTH - 13*DATA_WIDTH - 1 : BLOCK_WIDTH - 14*DATA_WIDTH ] ),
        .IN4( block_out [ BLOCK_WIDTH - 12*DATA_WIDTH - 1 : BLOCK_WIDTH - 13*DATA_WIDTH ] ),
        .IN5( block_out [ BLOCK_WIDTH - 11*DATA_WIDTH - 1 : BLOCK_WIDTH - 12*DATA_WIDTH ] ),
        .IN6( block_out [ BLOCK_WIDTH - 10*DATA_WIDTH - 1 : BLOCK_WIDTH - 11*DATA_WIDTH ] ),
        .IN7( block_out [ BLOCK_WIDTH - 9*DATA_WIDTH - 1 : BLOCK_WIDTH - 10*DATA_WIDTH ] ),
        .IN8( block_out [ BLOCK_WIDTH - 8*DATA_WIDTH - 1 : BLOCK_WIDTH - 9*DATA_WIDTH ] ),
        .IN9( block_out [ BLOCK_WIDTH - 7*DATA_WIDTH - 1 : BLOCK_WIDTH - 8*DATA_WIDTH ] ),
        .IN10( block_out [ BLOCK_WIDTH - 6*DATA_WIDTH - 1 : BLOCK_WIDTH - 7*DATA_WIDTH ] ),
        .IN11( block_out [ BLOCK_WIDTH - 5*DATA_WIDTH - 1 : BLOCK_WIDTH - 6*DATA_WIDTH ] ),
        .IN12( block_out [ BLOCK_WIDTH - 4*DATA_WIDTH - 1 : BLOCK_WIDTH - 5*DATA_WIDTH ] ),
        .IN13( block_out [ BLOCK_WIDTH - 3*DATA_WIDTH - 1 : BLOCK_WIDTH - 4*DATA_WIDTH ] ),
        .IN14( block_out [ BLOCK_WIDTH - 2*DATA_WIDTH - 1 : BLOCK_WIDTH - 3*DATA_WIDTH ] ),
        .IN15( block_out [ BLOCK_WIDTH - DATA_WIDTH - 1 : BLOCK_WIDTH - 2*DATA_WIDTH ] ),
        .IN16( block_out [ BLOCK_WIDTH - 1 : BLOCK_WIDTH - DATA_WIDTH ] ),
        .SELECT(word_if3),
        .OUT(INSTRUCTION)  
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
        //IF1
        
        //IF2
        if(tag_out_bank_0 == tag_if2)
        begin
            hit_bank_0 = HIGH ;
        end
        else
        begin
            hit_bank_0 = LOW ;
        end
        if(tag_out_bank_1 == tag_if2)
        begin
            hit_bank_0 = HIGH ;
        end
        else
        begin
            hit_bank_0 = LOW ;
        end
        
        //IF3
    
    end
    
    assign  INSTRUCTION_CACHE_READY     = instruction_cache_ready_reg       ;
    assign  ADDRESS_TO_L2_INS           = address_to_l2_ins_reg             ;
    assign  ADDRESS_TO_L2_VALID_INS     = address_to_l2_valid_ins_reg       ;
    assign  DATA_FROM_L2_READY_INS      = data_from_l2_ready_ins_reg        ;
   
endmodule
