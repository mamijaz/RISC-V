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
        parameter   TAG_WIDTH               = 26                            ,
        parameter   MEMORY_LATENCY    	    = "HIGH_LATENCY"                ,
        
        localparam  MEMORY_DEPTH            = 4                             ,
        localparam  ADDRESS_WIDTH           = clog2(MEMORY_DEPTH-1)        	                           
    ) (
        input                              CLK                              ,
        input  [TAG_WIDTH - 1      : 0]    WRITE_TAG_ADDRESS                ,   
        input  [BLOCK_WIDTH - 1    : 0]    WRITE_DATA                       ,
        input                              WRITE_ENABLE                     ,
        input  [TAG_WIDTH - 1      : 0]    READ_TAG_ADDRESS                 ,                                         
        input                              READ_ENBLE                       , 
        output                             READ_HIT                         ,                                                    
        output [BLOCK_WIDTH - 1    : 0]    READ_DATA           
    );
    
    reg [TAG_WIDTH - 1      : 0]    tag                 [MEMORY_DEPTH - 1   : 0]    ;
    reg [BLOCK_WIDTH - 1    : 0]    memory              [MEMORY_DEPTH - 1   : 0]    ;
    
    reg                             read_hit_out_reg_1                              ;
    reg [BLOCK_WIDTH - 1    : 0]    data_out_reg_1                                  ;
    
    reg [ADDRESS_WIDTH - 1  : 0]    record_counter                                  ;                        
    
    wire                            full                                            ;
    wire                            empty                                           ;
    
    assign full     = ( record_counter == (MEMORY_DEPTH - 1) )                      ;
    assign empty    = ( record_counter == 0 )                                       ;
    
    integer i;
    initial
    begin
        for (i = 0; i < MEMORY_DEPTH; i = i + 1)
            tag [ i ] = {TAG_WIDTH{1'b0}};
        for (i = 0; i < MEMORY_DEPTH; i = i + 1)
            memory [ i ] = {BLOCK_WIDTH{1'b0}};
        record_counter  = {ADDRESS_WIDTH{1'b0}};
    end
    
    always @(posedge CLK)
    begin
        if (WRITE_ENABLE & !full)
        begin
            tag [ record_counter ]      <= WRITE_TAG_ADDRESS    ;
            memory [ record_counter ]   <= WRITE_DATA           ;
            record_counter              <= record_counter + 1   ;   
        end
        if (WRITE_ENABLE & full)
        begin
            for (i = 0; i < MEMORY_DEPTH - 1 ; i = i + 1)
            begin
                tag [ i ]       <= tag [ i + 1 ]    ;
                memory [ i ]    <= memory [ i + 1 ] ;
            end
            tag [ record_counter ]      <= WRITE_TAG_ADDRESS    ;
            memory [ record_counter ]   <= WRITE_DATA           ;
        end
        
        if (READ_ENBLE & !empty)
        begin
            if( tag [ 0 ] == READ_TAG_ADDRESS) 
            begin
                read_hit_out_reg_1  <= 1'b1                     ;
                data_out_reg_1      <= memory [ 0 ]             ;
                record_counter      <= record_counter - 1       ;
                for (i = 0; i < MEMORY_DEPTH - 1 ; i = i + 1)
                begin
                    tag [ i ]       <= tag [ i + 1 ]    ;
                    memory [ i ]    <= memory [ i + 1 ] ;
                end
            end
            else if( tag [ 1 ] == READ_TAG_ADDRESS) 
            begin
                read_hit_out_reg_1  <= 1'b1                     ;
                data_out_reg_1      <= memory [ 1 ]             ;
                record_counter      <= record_counter - 1       ;
                for (i = 1; i < MEMORY_DEPTH - 1 ; i = i + 1)
                begin
                    tag [ i ]       <= tag [ i + 1 ]    ;
                    memory [ i ]    <= memory [ i + 1 ] ;
                end
            end
            else if( tag [ 2 ] == READ_TAG_ADDRESS) 
            begin
                read_hit_out_reg_1  <= 1'b1                     ;
                data_out_reg_1      <= memory [ 2 ]             ;
                record_counter      <= record_counter - 1       ;
                for (i = 2; i < MEMORY_DEPTH - 1 ; i = i + 1)
                begin
                    tag [ i ]       <= tag [ i + 1 ]    ;
                    memory [ i ]    <= memory [ i + 1 ] ;
                end
            end
            else if( tag [ 3 ] == READ_TAG_ADDRESS) 
            begin
                read_hit_out_reg_1  <= 1'b1                     ;
                data_out_reg_1      <= memory [ 3 ]             ;
                record_counter      <= record_counter - 1       ;
                for (i = 3; i < MEMORY_DEPTH - 1 ; i = i + 1)
                begin
                    tag [ i ]       <= tag [ i + 1 ]    ;
                    memory [ i ]    <= memory [ i + 1 ] ;
                end
            end
            else
            begin
                read_hit_out_reg_1  <= 1'b0                         ;
                data_out_reg_1      <= {BLOCK_WIDTH{1'b0}}          ;
            end
        end
        if (READ_ENBLE & empty)
        begin
            read_hit_out_reg_1  <= 1'b0                         ;
            data_out_reg_1      <= {BLOCK_WIDTH{1'b0}}          ;
        end
    end
    
    generate
        if (MEMORY_LATENCY == "LOW_LATENCY") 
        begin
            assign READ_HIT     = read_hit_out_reg_1    ;
            assign READ_DATA    = data_out_reg_1        ;  
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
            assign READ_HIT     = read_hit_out_reg_2    ;  
            assign READ_DATA    = data_out_reg_2        ;
        end
    endgenerate
    
    function integer clog2;
        input integer depth;
        for (clog2 = 0; depth > 0; clog2 = clog2 + 1)
            depth = depth >> 1;
    endfunction
    
endmodule
