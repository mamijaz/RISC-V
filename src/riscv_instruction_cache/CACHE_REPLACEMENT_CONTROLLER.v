`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/12/2017 07:54:51 PM
// Design Name: 
// Module Name:     CACHE_REPLACEMENT_CONTROLLER
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


module CACHE_REPLACEMENT_CONTROLLER #(  
        parameter   ADDRESS_WIDTH           = 32                            ,
        
        parameter   BLOCK_WIDTH             = 512                           ,
        parameter   MEMORY_DEPTH            = 512                           ,
        parameter   WORD_SIZE               = 4                             ,
        parameter   WORD_PER_BLOCK          = 16                            ,
        
        localparam  BYTE_SELECT             = clog2(WORD_SIZE-1)            ,
        localparam  WORD_SELECT             = clog2(WORD_PER_BLOCK-1)       ,
        localparam  LINE_SELECT             = clog2(MEMORY_DEPTH-1)         ,
        localparam  TAG_WIDTH               = ADDRESS_WIDTH - ( LINE_SELECT + WORD_SELECT + BYTE_SELECT )                                     
    ) (
        input                                   CLK                         ,
        input    [ADDRESS_WIDTH - 1     : 0]    PC_IF2                      ,
        input    [TAG_WIDTH - 1         : 0]    TAG_OUT_BANK_0_IF2          ,
        input    [TAG_WIDTH - 1         : 0]    TAG_OUT_BANK_1_IF2          ,
        input    [ADDRESS_WIDTH - 1     : 0]    PC_IF3                      ,
        input    [TAG_WIDTH - 1         : 0]    TAG_OUT_BANK_0_IF3          ,
        input    [TAG_WIDTH - 1         : 0]    TAG_OUT_BANK_1_IF3          ,
        input                                   HIT_BANK_0                  ,
        input                                   HIT_BANK_1                  ,
        
        // Transfer Address From L1 to L2 Cache 
        input                                   ADDRESS_TO_L2_READY_INS     ,
        output                                  ADDRESS_TO_L2_VALID_INS     ,      
        output   [ADDRESS_WIDTH - 2 - 1 : 0]    ADDRESS_TO_L2_INS           ,
                
        // Transfer Data From L2 to L1 Cache   
        output                                  DATA_FROM_L2_READY_INS      ,
        input                                   DATA_FROM_L2_VALID_INS      ,
        input    [BLOCK_WIDTH - 1       : 0]    DATA_FROM_L2_INS
    );
    
    wire    [LINE_SELECT - 1         : 0]   line_if2                        ;
    wire    [TAG_WIDTH - 1           : 0]   tag_if2                         ;
    
    assign  line_if2    = PC_IF2[ADDRESS_WIDTH - TAG_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - LINE_SELECT - 1 ] ;
    assign  tag_if2     = PC_IF2[ADDRESS_WIDTH - 1  : ADDRESS_WIDTH - TAG_WIDTH - 1 ]                           ;

  
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
        
    function integer clog2;
        input integer depth;
        for (clog2 = 0; depth > 0; clog2 = clog2 + 1)
            depth = depth >> 1;
    endfunction
      
endmodule
