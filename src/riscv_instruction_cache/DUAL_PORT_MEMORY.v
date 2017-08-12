`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/08/2017 10:53:59 AM
// Design Name: 
// Module Name:     DUAL_PORT_MEMORY
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


module DUAL_PORT_MEMORY #(
        parameter MEMORY_WIDTH          = 512                               ,                       
        parameter MEMORY_DEPTH          = 512                               ,                      
        parameter MEMORY_LATENCY    	= "LOW_LATENCY"                	    , 
        parameter INIT_FILE             = ""                        
    ) (
        input                                       CLK                     ,
        input  [$clog2(MEMORY_DEPTH-1) - 1  : 0]    WRITE_ADDRESS           ,   
        input  [MEMORY_WIDTH-1              : 0]    DATA_IN                 ,
        input                                       WRITE_ENABLE            ,
        input  [$clog2(MEMORY_DEPTH-1)-1    : 0]    READ_ADDRESS            ,                                         
        input                                       READ_ENBLE              ,                                                     
        output [MEMORY_WIDTH-1              : 0]    DATA_OUT           
    );
    
    reg [MEMORY_WIDTH - 1   : 0]    memory          [MEMORY_DEPTH - 1 : 0]  ;
    reg [MEMORY_WIDTH - 1   : 0]    data_out_reg                            ;
    
    integer i;
    initial
    begin
        if (INIT_FILE != "") 
            $readmemh(INIT_FILE, memory, 0, MEMORY_DEPTH-1);
        else
            for (i = 0; i < MEMORY_DEPTH; i = i + 1)
                memory [ i ] = {MEMORY_DEPTH{1'b0}};
    end
        
    always @(posedge CLK) begin
        if (WRITE_ENABLE)
        begin
            memory [WRITE_ADDRESS]  <= DATA_IN                              ;
        end
        if (READ_ENBLE)
        begin
            data_out_reg            <= memory [READ_ADDRESS]                ;
        end
    end
   
    generate
        if (MEMORY_LATENCY == "LOW_LATENCY") 
        begin
            assign DATA_OUT = data_out_reg;  
        end 
        else 
        begin
            reg [MEMORY_WIDTH - 1  :0] data_out_temp_reg = {MEMORY_WIDTH{1'b0}}  ;
            always @(posedge CLK) 
            begin
                if (READ_ENBLE)
                begin
                    data_out_temp_reg <= data_out_reg;
                end
            end    
            assign DATA_OUT = data_out_temp_reg;
        end
    endgenerate
    
endmodule
