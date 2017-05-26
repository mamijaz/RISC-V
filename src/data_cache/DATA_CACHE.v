`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:13:16 AM
// Design Name: 
// Module Name:     DATA_CACHE
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


module DATA_CACHE #(
        parameter DATA_CACHE_LOAD_NONE  = 3'b000        , 
        parameter DATA_CACHE_LOAD_B_S   = 3'b010        ,
        parameter DATA_CACHE_LOAD_B_U   = 3'b011        ,
        parameter DATA_CACHE_LOAD_H_S   = 3'b100        ,
        parameter DATA_CACHE_LOAD_H_U   = 3'b101        ,
        parameter DATA_CACHE_LOAD_W     = 3'b110        ,
        parameter DATA_CACHE_STORE_NONE = 2'b00         ,
        parameter DATA_CACHE_STORE_B    = 2'b01         ,
        parameter DATA_CACHE_STORE_H    = 2'b10         ,
        parameter DATA_CACHE_STORE_W    = 2'b11         ,
        
        parameter HIGH                  = 1'b1          ,
        parameter LOW                   = 1'b0
    ) (
        input            CLK                            ,
        input            STALL_DATA_CACHE               ,
        input   [31 : 0] DATA_CACHE_READ_ADDRESS        ,
        input   [2  : 0] DATA_CACHE_LOAD                ,
        input   [31 : 0] DATA_CACHE_WRITE_ADDRESS       ,
        input   [31 : 0] DATA_CACHE_WRITE_DATA          ,
        input   [1  : 0] DATA_CACHE_STORE               ,
        output           DATA_CACHE_READY               ,
        output  [31 : 0] DATA_CACHE_READ_DATA           
    );
    
endmodule
