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
        localparam  BYTE_SELECT             = clog2(WORD_SIZE-1)            ,
        localparam  WORD_SELECT             = clog2(WORD_PER_BLOCK-1)       ,
        localparam  LINE_SELECT             = clog2(MEMORY_DEPTH-1)         ,
        localparam  TAG_WIDTH               = ADDRESS_WIDTH - ( LINE_SELECT + WORD_SELECT + BYTE_SELECT )
    ) (
        input                                           CLK                                     ,
        input                                           STALL_INSTRUCTION_CACHE                 ,
        input   [ADDRESS_WIDTH - 1              : 0]    PC                                      ,
        input                                           PC_VALID                                ,
        output  [ADDRESS_WIDTH - 1              : 0]    INSTRUCTION                             ,
        output                                          INSTRUCTION_CACHE_READY                 ,
        
        // Transfer Address From L1 to L2 Cache 
        input                                           ADDRESS_TO_L2_READY_INSTRUCTION_CACHE   ,
        output                                          ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE   ,      
        output  [TAG_WIDTH + LINE_SELECT - 1    : 0]    ADDRESS_TO_L2_INSTRUCTION_CACHE         ,
                
        // Transfer Data From L2 to L1 Cache   
        output                                          DATA_FROM_L2_READY_INSTRUCTION_CACHE    ,
        input                                           DATA_FROM_L2_VALID_INSTRUCTION_CACHE    ,
        input   [BLOCK_WIDTH - 1                : 0]    DATA_FROM_L2_INSTRUCTION_CACHE
    );
    
    // Pipeline Registers
    reg     [ADDRESS_WIDTH - 1              : 0]    pc_if2                          ;
    reg                                             pc_valid_if2                    ;
    reg     [ADDRESS_WIDTH - 1              : 0]    pc_if3                          ;
    reg                                             pc_valid_if3                    ;
    reg                                             valid_out_bank_0_if3            ;
    reg                                             valid_out_bank_1_if3            ;
    reg     [TAG_WIDTH - 1                  : 0]    tag_out_bank_0_if3              ;
    reg     [TAG_WIDTH - 1                  : 0]    tag_out_bank_1_if3              ;
    reg                                             hit_bank_0_if3                  ;
    reg                                             hit_bank_1_if3                  ;
    reg     [DATA_WIDTH - 1                 : 0]    instruction_reg                 ;
       
    wire    [LINE_SELECT - 1                : 0]    line_if1                        ;
    wire    [TAG_WIDTH + LINE_SELECT - 1    : 0]    block_address_if1               ;
    wire                                            read_enable_if1                 ;
    wire    [TAG_WIDTH - 1                  : 0]    tag_if2                         ;
    wire    [LINE_SELECT - 1                : 0]    line_if2                        ;
    wire    [TAG_WIDTH + LINE_SELECT - 1    : 0]    block_address_if3               ;
    wire    [TAG_WIDTH - 1                  : 0]    tag_if3                         ;
    wire    [LINE_SELECT - 1                : 0]    line_if3                        ;
    wire    [TAG_WIDTH - 1                  : 0]    tag_out_bank_0_if2              ;
    wire    [TAG_WIDTH - 1                  : 0]    tag_out_bank_1_if2              ;
    wire                                            valid_out_bank_0_if2            ;
    wire                                            valid_out_bank_1_if2            ;
    wire                                            hit_bank_0_if2                  ;
    wire                                            hit_bank_1_if2                  ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out_bank_0_if3            ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out_bank_1_if3            ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out_set_bank_if3          ;
    wire                                            lru_out_if3                     ;
    wire                                            cache_hit_if3                   ;
    wire                                            victim_cache_hit                ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out_victim_cache          ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out_l1                    ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_out                       ;
    wire    [WORD_SELECT - 1                : 0]    word_if3                        ;
    wire    [DATA_WIDTH - 1                 : 0]    word_out                        ;
    wire    [TAG_WIDTH + LINE_SELECT - 1    : 0]    block_address_to_victim_cache   ;
    wire    [BLOCK_WIDTH - 1                : 0]    block_to_victim_cache           ;
    wire                                            write_enable_victim_cache       ;
    wire    [BLOCK_WIDTH - 1                : 0]    data_block_from_l2_cache        ;
    wire    [BLOCK_WIDTH - 1                : 0]    write_block                     ;
    wire                                            write_enable_bank_0             ;
    wire                                            write_enable_bank_1             ;
    wire                                            lru_in                          ;
    wire                                            lru_write_enable                ;
    
    assign  block_address_if1   = PC[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT ]                                             ;
    assign  line_if1            = PC[ADDRESS_WIDTH - TAG_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT ]                                 ;
    assign  read_enable_if1     = PC_VALID & INSTRUCTION_CACHE_READY & !STALL_INSTRUCTION_CACHE                                                 ;
    assign  tag_if2             = pc_if2[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH ]                                                       ;
    assign  line_if2            = pc_if2[ADDRESS_WIDTH - TAG_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT ]                             ;
    assign  hit_bank_0_if2      = (tag_out_bank_0_if2 == tag_if2) & valid_out_bank_0_if2                                                        ;
    assign  hit_bank_1_if2      = (tag_out_bank_1_if2 == tag_if2) & valid_out_bank_1_if2                                                        ;
    assign  cache_hit_if3       = hit_bank_0_if3 | hit_bank_1_if3                                                                               ;
    assign  block_address_if3   = pc_if3[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT ]                                         ;
    assign  tag_if3             = pc_if3[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH ]                                                       ;
    assign  line_if3            = pc_if3[ADDRESS_WIDTH - TAG_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT ]                             ;
    assign  word_if3            = pc_if3[ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - WORD_SELECT ] ;
    
    initial
    begin
        pc_if2                          = {ADDRESS_WIDTH {1'b0}}            ;
        pc_valid_if2                    = LOW                               ;
        pc_if3                          = {ADDRESS_WIDTH {1'b0}}            ;
        pc_valid_if3                    = LOW                               ;
        valid_out_bank_0_if3            = LOW                               ;
        valid_out_bank_1_if3            = LOW                               ;
        hit_bank_0_if3                  = LOW                               ;
        hit_bank_1_if3                  = LOW                               ;
        instruction_reg                 = {DATA_WIDTH {1'b0}}               ;
    end  
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(TAG_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) tag_ram_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(tag_if3),
        .WRITE_ENABLE(write_enable_bank_0),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(tag_out_bank_0_if2)
        );
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(TAG_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) tag_ram_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(tag_if3),
        .WRITE_ENABLE(write_enable_bank_1),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(tag_out_bank_1_if2)
        );
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(1),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) valid_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(1'b1),
        .WRITE_ENABLE(write_enable_bank_0),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(valid_out_bank_0_if2)
        ); 
        
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(1),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("LOW_LATENCY")
    ) valid_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(1'b1),
        .WRITE_ENABLE(write_enable_bank_1),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(valid_out_bank_1_if2)
        );
    
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_0(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(write_block),
        .WRITE_ENABLE(write_enable_bank_0),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(block_out_bank_0_if3)
        ); 
       
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(BLOCK_WIDTH),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) data_ram_bank_1(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(write_block),
        .WRITE_ENABLE(write_enable_bank_1),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(block_out_bank_1_if3)
        ); 
        
    DUAL_PORT_MEMORY #(
        .MEMORY_WIDTH(1),                       
        .MEMORY_DEPTH(MEMORY_DEPTH),                      
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) lru(
        .CLK(CLK),
        .WRITE_ADDRESS(line_if3),   
        .DATA_IN(lru_in),
        .WRITE_ENABLE(lru_write_enable),
        .READ_ADDRESS(line_if1),                                         
        .READ_ENBLE(read_enable_if1),                                                     
        .DATA_OUT(lru_out_if3)
        ); 
        
    VICTIM_CACHE #(
        .BLOCK_WIDTH(BLOCK_WIDTH),
        .TAG_WIDTH(TAG_WIDTH + LINE_SELECT),
        .MEMORY_LATENCY("HIGH_LATENCY")
    ) victim_cache(
        .CLK(CLK),
        .WRITE_TAG_ADDRESS(block_address_to_victim_cache),   
        .WRITE_DATA(block_to_victim_cache),
        .WRITE_ENABLE(write_enable_victim_cache),
        .READ_TAG_ADDRESS(block_address_if1),                                         
        .READ_ENBLE(read_enable_if1), 
        .READ_HIT(victim_cache_hit),                                                    
        .READ_DATA(block_out_victim_cache)
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
    ) select_read_bank(
        .IN1(block_out_bank_0_if3),
        .IN2(block_out_bank_1_if3),
        .SELECT(!hit_bank_0_if3 & hit_bank_1_if3),
        .OUT(block_out_set_bank_if3)  
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
    ) select_victim_cache(
        .IN1(block_out_set_bank_if3),
        .IN2(block_out_victim_cache),
        .SELECT(!cache_hit_if3 & victim_cache_hit),
        .OUT(block_out_l1)  
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
    ) select_cache_miss(
        .IN1(block_out_l1),
        .IN2(data_block_from_l2_cache),
        .SELECT(!cache_hit_if3 & !victim_cache_hit),
        .OUT(block_out)  
        );
    
    MULTIPLEXER_16_TO_1 #(
        .BUS_WIDTH(DATA_WIDTH)
        ) select_word(
        .IN1( block_out [ BLOCK_WIDTH - 1 : BLOCK_WIDTH - DATA_WIDTH ] ),
        .IN2( block_out [ BLOCK_WIDTH - DATA_WIDTH - 1 : BLOCK_WIDTH - 2*DATA_WIDTH ] ),
        .IN3( block_out [ BLOCK_WIDTH - 2*DATA_WIDTH - 1 : BLOCK_WIDTH - 3*DATA_WIDTH ] ),
        .IN4( block_out [ BLOCK_WIDTH - 3*DATA_WIDTH - 1 : BLOCK_WIDTH - 4*DATA_WIDTH ] ),
        .IN5( block_out [ BLOCK_WIDTH - 4*DATA_WIDTH - 1 : BLOCK_WIDTH - 5*DATA_WIDTH ] ),
        .IN6( block_out [ BLOCK_WIDTH - 5*DATA_WIDTH - 1 : BLOCK_WIDTH - 6*DATA_WIDTH ] ),
        .IN7( block_out [ BLOCK_WIDTH - 6*DATA_WIDTH - 1 : BLOCK_WIDTH - 7*DATA_WIDTH ] ),
        .IN8( block_out [ BLOCK_WIDTH - 7*DATA_WIDTH - 1 : BLOCK_WIDTH - 8*DATA_WIDTH ] ),
        .IN9( block_out [ BLOCK_WIDTH - 8*DATA_WIDTH - 1 : BLOCK_WIDTH - 9*DATA_WIDTH ] ),
        .IN10( block_out [ BLOCK_WIDTH - 9*DATA_WIDTH - 1 : BLOCK_WIDTH - 10*DATA_WIDTH ] ),
        .IN11( block_out [ BLOCK_WIDTH - 10*DATA_WIDTH - 1 : BLOCK_WIDTH - 11*DATA_WIDTH ] ),
        .IN12( block_out [ BLOCK_WIDTH - 11*DATA_WIDTH - 1 : BLOCK_WIDTH - 12*DATA_WIDTH ] ),
        .IN13( block_out [ BLOCK_WIDTH - 12*DATA_WIDTH - 1 : BLOCK_WIDTH - 13*DATA_WIDTH ] ),
        .IN14( block_out [ BLOCK_WIDTH - 13*DATA_WIDTH - 1 : BLOCK_WIDTH - 14*DATA_WIDTH ] ),
        .IN15( block_out [ BLOCK_WIDTH - 14*DATA_WIDTH - 1 : BLOCK_WIDTH - 15*DATA_WIDTH ] ),
        .IN16( block_out [ BLOCK_WIDTH - 15*DATA_WIDTH - 1 : BLOCK_WIDTH - 16*DATA_WIDTH ] ),
        .SELECT(word_if3),
        .OUT(word_out)  
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
    ) select_write_block_to_bank(
        .IN1(block_out_victim_cache),
        .IN2(data_block_from_l2_cache),
        .SELECT(!victim_cache_hit),
        .OUT(write_block)  
        );
        
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH( TAG_WIDTH + LINE_SELECT )
    ) select_write_tag_to_victim_cache(
        .IN1({tag_out_bank_0_if3,line_if3}),
        .IN2({tag_out_bank_1_if3,line_if3}),
        .SELECT(!write_enable_bank_0 & write_enable_bank_1),
        .OUT(block_address_to_victim_cache)  
        );
    
    MULTIPLEXER_2_TO_1 #(
        .BUS_WIDTH(BLOCK_WIDTH)
    ) select_write_block_to_victim_cache(
        .IN1(block_out_bank_0_if3),
        .IN2(block_out_bank_1_if3),
        .SELECT(!write_enable_bank_0 & write_enable_bank_1),
        .OUT(block_to_victim_cache)  
        );
        
    INSTRUCTION_CACHE_REPLACEMENT_CONTROLLER #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .BLOCK_WIDTH(BLOCK_WIDTH),
        .MEMORY_DEPTH(MEMORY_DEPTH)                           
    ) instruction_cache_replacement_controller(
        .CLK(CLK),
        .LINE_IF2(line_if2),
        .HIT_BANK_0_IF2(hit_bank_0_if2),
        .HIT_BANK_1_IF2(hit_bank_1_if2),
        .LINE_IF3(line_if3),
        .PC_VALID_IF3(pc_valid_if3),
        .VALID_OUT_BANK_0_IF3(valid_out_bank_0_if3),
        .VALID_OUT_BANK_1_IF3(valid_out_bank_1_if3),
        .HIT_BANK_0_IF3(hit_bank_0_if3),
        .HIT_BANK_1_IF3(hit_bank_1_if3),
        .LRU_OUT_IF3(lru_out_if3),
        .VICTIM_CACHE_HIT(victim_cache_hit),
        .BLOCK_ADDRESS_IF3(block_address_if3),
        .DATA_BLOCK_FROM_L2_CACHE(data_block_from_l2_cache),
        .WRITE_ENABLE_BANK_0(write_enable_bank_0),
        .WRITE_ENABLE_BANK_1(write_enable_bank_1),
        .WRITE_ENABLE_VICTIM_CACHE(write_enable_victim_cache),
        .LRU_IN(lru_in),
        .LRU_WRITE_ENABLE(lru_write_enable),
        .INSTRUCTION_CACHE_READY(INSTRUCTION_CACHE_READY),
        .ADDRESS_TO_L2_READY_INSTRUCTION_CACHE(ADDRESS_TO_L2_READY_INSTRUCTION_CACHE),
        .ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE(ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE),
        .ADDRESS_TO_L2_INSTRUCTION_CACHE(ADDRESS_TO_L2_INSTRUCTION_CACHE),      
        .DATA_FROM_L2_READY_INSTRUCTION_CACHE(DATA_FROM_L2_READY_INSTRUCTION_CACHE),
        .DATA_FROM_L2_VALID_INSTRUCTION_CACHE(DATA_FROM_L2_VALID_INSTRUCTION_CACHE),
        .DATA_FROM_L2_INSTRUCTION_CACHE(DATA_FROM_L2_INSTRUCTION_CACHE)
        );                           
    
    always@(posedge CLK)
    begin
        if(INSTRUCTION_CACHE_READY & !STALL_INSTRUCTION_CACHE)
        begin
            //IF1
            pc_if2                  <= PC                   ;
            pc_valid_if2            <= PC_VALID             ;
            
            //IF2
            pc_if3                  <= pc_if2               ;
            pc_valid_if3            <= pc_valid_if2         ;
            valid_out_bank_0_if3    <= valid_out_bank_0_if2 ;
            valid_out_bank_1_if3    <= valid_out_bank_1_if2 ;
            tag_out_bank_0_if3      <= tag_out_bank_0_if2   ;
            tag_out_bank_1_if3      <= tag_out_bank_1_if2   ;
            hit_bank_0_if3          <= hit_bank_0_if2       ;
            hit_bank_1_if3          <= hit_bank_1_if2       ;
            
            //IF3
            instruction_reg         <= word_out             ;
        end
    end
    
    assign  INSTRUCTION                             = instruction_reg                   ;
   
    function integer clog2;
        input integer depth;
        for (clog2 = 0; depth > 0; clog2 = clog2 + 1)
            depth = depth >> 1;
    endfunction
        
endmodule
