`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/12/2017 07:54:51 PM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE_REPLACEMENT_CONTROLLER
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


module INSTRUCTION_CACHE_REPLACEMENT_CONTROLLER #(  
        parameter   ADDRESS_WIDTH           = 32                            ,
        
        parameter   BLOCK_WIDTH             = 512                           ,
        parameter   MEMORY_DEPTH            = 512                           ,
        parameter   WORD_SIZE               = 4                             ,
        parameter   WORD_PER_BLOCK          = 16                            ,
        
        parameter   HIGH                    = 1'b1                          ,
        parameter   LOW                     = 1'b0                          ,
        
        localparam  BYTE_SELECT             = clog2(WORD_SIZE-1)            ,
        localparam  WORD_SELECT             = clog2(WORD_PER_BLOCK-1)       ,
        localparam  LINE_SELECT             = clog2(MEMORY_DEPTH-1)         ,
        localparam  TAG_WIDTH               = ADDRESS_WIDTH - ( LINE_SELECT + WORD_SELECT + BYTE_SELECT )                                     
    ) (
        input                                   CLK                                     ,
        input    [LINE_SELECT - 1       : 0]    LINE_IF2                                ,
        input                                   HIT_BANK_0_IF2                          ,
        input                                   HIT_BANK_1_IF2                          ,
        input    [LINE_SELECT - 1       : 0]    LINE_IF3                                , 
        input                                   HIT_BANK_0_IF3                          ,
        input                                   HIT_BANK_1_IF3                          ,
        input                                   LRU_OUT_IF3                             ,
        input                                   VICTIM_CACHE_HIT                        ,
        
        output                                  WRITE_ENABLE_BANK_0                     ,
        output                                  WRITE_ENABLE_BANK_1                     ,
        output                                  WRITE_ENABLE_VICTIM_CACHE               ,
        output                                  LRU_IN                                  ,
        output                                  LRU_WRITE_ENABLE                        ,
        output                                  INSTRUCTION_CACHE_READY                 ,
        
        // Transfer Address From L1 to L2 Cache 
        input                                   ADDRESS_TO_L2_READY_INSTRUCTION_CACHE   ,
        output                                  ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE   ,      
                
        // Transfer Data From L2 to L1 Cache   
        output                                  DATA_FROM_L2_READY_INSTRUCTION_CACHE    ,
        input                                   DATA_FROM_L2_VALID_INSTRUCTION_CACHE    
    );
    
    reg                                     write_enable_bank_0_reg                     ;
    reg                                     write_enable_bank_1_reg                     ;
    reg                                     write_enable_victim_cache_reg               ;
    reg                                     lru_in_reg                                  ;
    reg                                     lru_write_enable_reg                        ;
    reg                                     instruction_cache_ready_reg                 ;
    
    reg                                     address_to_l2_valid_instruction_cache_reg   ;
    reg                                     data_from_l2_ready_instruction_cache_reg    ;
    
    initial
    begin
        write_enable_bank_0_reg                     = LOW   ;
        write_enable_bank_1_reg                     = LOW   ;
        write_enable_victim_cache_reg               = LOW   ;
        lru_in_reg                                  = LOW   ;
        lru_write_enable_reg                        = LOW   ;
        instruction_cache_ready_reg                 = HIGH  ;
        address_to_l2_valid_instruction_cache_reg   = LOW   ;
        data_from_l2_ready_instruction_cache_reg    = LOW   ;
    end
    
    always@(*)
    begin
        if( HIT_BANK_0_IF3 & !HIT_BANK_1_IF3 & !VICTIM_CACHE_HIT)
        begin
            instruction_cache_ready_reg                 = HIGH  ;
            write_enable_bank_0_reg                     = LOW   ;
            write_enable_bank_1_reg                     = LOW   ;
            lru_in_reg                                  = HIGH  ;
            lru_write_enable_reg                        = HIGH  ;
            address_to_l2_valid_instruction_cache_reg   = LOW   ;
            data_from_l2_ready_instruction_cache_reg    = LOW   ;
            write_enable_victim_cache_reg               = LOW   ;
        end
        else if( !HIT_BANK_0_IF3 & HIT_BANK_1_IF3 & !VICTIM_CACHE_HIT )
        begin
            instruction_cache_ready_reg                 = HIGH  ;
            write_enable_bank_0_reg                     = LOW   ;
            write_enable_bank_1_reg                     = LOW   ;
            lru_in_reg                                  = LOW   ;
            lru_write_enable_reg                        = HIGH  ;
            address_to_l2_valid_instruction_cache_reg   = LOW   ;
            data_from_l2_ready_instruction_cache_reg    = LOW   ;
            write_enable_victim_cache_reg               = LOW   ;
        end
        else if( !HIT_BANK_0_IF3 & !HIT_BANK_1_IF3 & VICTIM_CACHE_HIT )
        begin
            if( ( !LRU_OUT_IF3 & !( (LINE_IF2 == LINE_IF3) & HIT_BANK_0_IF2) ) | ( LRU_OUT_IF3 & ( (LINE_IF2 == LINE_IF3) & HIT_BANK_1_IF2) ) )
            begin
                instruction_cache_ready_reg                 = HIGH  ;
                write_enable_bank_0_reg                     = HIGH  ;
                write_enable_bank_1_reg                     = LOW   ;
                lru_in_reg                                  = LOW   ;
                lru_write_enable_reg                        = HIGH  ;
                address_to_l2_valid_instruction_cache_reg   = LOW   ;
                data_from_l2_ready_instruction_cache_reg    = LOW   ;
                write_enable_victim_cache_reg               = LOW   ;
            end
            else
            begin
                instruction_cache_ready_reg                 = HIGH  ;
                write_enable_bank_0_reg                     = LOW   ;
                write_enable_bank_1_reg                     = HIGH  ;
                lru_in_reg                                  = HIGH  ;
                lru_write_enable_reg                        = HIGH  ;
                address_to_l2_valid_instruction_cache_reg   = LOW   ;
                data_from_l2_ready_instruction_cache_reg    = LOW   ;
                write_enable_victim_cache_reg               = LOW   ;
            end
        end
        else if( !HIT_BANK_0_IF3 & !HIT_BANK_1_IF3 & !VICTIM_CACHE_HIT )
        begin
            instruction_cache_ready_reg                 = LOW   ;
            write_enable_bank_0_reg                     = LOW   ;
            write_enable_bank_1_reg                     = HIGH  ;
            lru_in_reg                                  = HIGH  ;
            lru_write_enable_reg                        = HIGH  ;
            address_to_l2_valid_instruction_cache_reg   = HIGH  ;
            data_from_l2_ready_instruction_cache_reg    = HIGH  ;
            write_enable_victim_cache_reg               = HIGH  ;
            if(ADDRESS_TO_L2_READY_INSTRUCTION_CACHE)
            begin
                //address_to_l2_valid_instruction_cache_reg   = HIGH  ;
                //data_from_l2_ready_instruction_cache_reg    = HIGH  ;
            end
            if(DATA_FROM_L2_VALID_INSTRUCTION_CACHE)
            begin
                //write_enable_victim_cache_reg   = HIGH  ;    
            end
        end
        else
        begin
            instruction_cache_ready_reg                 = LOW   ;
            write_enable_bank_0_reg                     = LOW   ;
            write_enable_bank_1_reg                     = LOW   ;
            lru_in_reg                                  = LOW   ;
            lru_write_enable_reg                        = LOW   ;
            address_to_l2_valid_instruction_cache_reg   = LOW   ;
            data_from_l2_ready_instruction_cache_reg    = LOW   ;
            write_enable_victim_cache_reg               = LOW   ;
        end
    end
    
    assign  WRITE_ENABLE_BANK_0                     = write_enable_bank_0_reg                       ;
    assign  WRITE_ENABLE_BANK_1                     = write_enable_bank_1_reg                       ;
    assign  WRITE_ENABLE_VICTIM_CACHE               = write_enable_victim_cache_reg                 ;
    assign  LRU_IN                                  = lru_in_reg                                    ;
    assign  LRU_WRITE_ENABLE                        = lru_write_enable_reg                          ;                          
    assign  INSTRUCTION_CACHE_READY                 = instruction_cache_ready_reg                   ;
    assign  ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE   = address_to_l2_valid_instruction_cache_reg     ;
    assign  DATA_FROM_L2_READY_INSTRUCTION_CACHE    = data_from_l2_ready_instruction_cache_reg      ;
        
    function integer clog2;
        input integer depth;
        for (clog2 = 0; depth > 0; clog2 = clog2 + 1)
            depth = depth >> 1;
    endfunction
      
endmodule
