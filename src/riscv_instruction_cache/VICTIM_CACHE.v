`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/13/2017 11:49:08 AM
// Design Name: 
// Module Name:     VICTIM_CACHE
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


module VICTIM_CACHE #(
        parameter   BLOCK_WIDTH             = 512                           ,
        parameter   MEMORY_DEPTH            = 8                             ,
        parameter   TAG_WIDTH               = 26                            ,
        parameter   MEMORY_LATENCY    	    = "HIGH_LATENCY"                ,
        
        localparam  ADDRESS_WIDTH           = clog2(MEMORY_DEPTH-1)        	                           
    ) (
        input                              CLK                              ,
        input  [ADDRESS_WIDTH - 1  : 0]    WRITE_TAG_ADDRESS                ,   
        input  [BLOCK_WIDTH - 1    : 0]    DATA_IN                          ,
        input                              WRITE_ENABLE                     ,
        input  [ADDRESS_WIDTH - 1  : 0]    READ_TAG_ADDRESS                 ,                                         
        input                              READ_ENBLE                       , 
        output                             READ_HIT                         ,                                                    
        output [BLOCK_WIDTH - 1    : 0]    DATA_OUT           
    );
    
    reg [BLOCK_WIDTH - 1    : 0]    memory              [MEMORY_DEPTH - 1   : 0]    ;
    reg [TAG_WIDTH - 1      : 0]    tag                 [MEMORY_DEPTH - 1   : 0]    ;
    reg [ADDRESS_WIDTH - 1  : 0]    lru                 [MEMORY_DEPTH - 1   : 0]    ;
    
    reg                             read_hit_out_reg_1                              ;
    reg [BLOCK_WIDTH - 1    : 0]    data_out_reg_1                                  ;
    
    integer i;
    initial
    begin
        for (i = 0; i < MEMORY_DEPTH; i = i + 1)
            memory [ i ] = {BLOCK_WIDTH{1'b0}};
        for (i = 0; i < MEMORY_DEPTH; i = i + 1)
            tag [ i ] = {TAG_WIDTH{1'b0}};
        for (i = 0; i < MEMORY_DEPTH; i = i + 1)
            lru [ i ] = {ADDRESS_WIDTH{1'b0}};
    end
    
    always@(*)
    begin
    end
    
    always @(posedge CLK)
    begin
        if (WRITE_ENABLE)
        begin
           
        end
        if (READ_ENBLE)
        begin
            
        end
    end
    
    generate
        if (MEMORY_LATENCY == "LOW_LATENCY") 
        begin
            assign READ_HIT = read_hit_out_reg_1    ;
            assign DATA_OUT = data_out_reg_1        ;  
        end 
        else 
        begin
            reg                       read_hit_out_reg_2    = 1'b0                  ;
            reg [BLOCK_WIDTH - 1  :0] data_out_reg_2        = {BLOCK_WIDTH{1'b0}}   ;
            always @(posedge CLK) 
            begin
                if (READ_ENBLE)
                begin
                    read_hit_out_reg_2  <= read_hit_out_reg_1   ;
                    data_out_reg_2      <= data_out_reg_1       ;
                end
            end  
            assign READ_HIT = read_hit_out_reg_2    ;  
            assign DATA_OUT = data_out_reg_2        ;
        end
    endgenerate
    
    function integer clog2;
        input integer depth;
        for (clog2 = 0; depth > 0; clog2 = clog2 + 1)
            depth = depth >> 1;
    endfunction
    
endmodule
