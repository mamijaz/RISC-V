`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:16:07 AM
// Design Name: 
// Module Name:     DATA_MEMORY_STAGE
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


module DATA_MEMORY_STAGE #(
        parameter HIGH  = 1'b1  
    ) (
        input            CLK                        ,
        input   [4  : 0] RD_ADDRESS_IN              ,
        input   [31 : 0] ALU_OUT_IN                 ,
        input   [2  : 0] DATA_CACHE_LOAD_IN         ,
        input   [1  : 0] DATA_CACHE_STORE_IN        ,
        input   [31 : 0] DATA_CACHE_STORE_DATA_IN   ,
        input            WRITE_BACK_MUX_SELECT_IN   ,
        input            RD_WRITE_ENABLE_IN         ,
        output  [4  : 0] RD_ADDRESS_OUT             ,
        output  [31 : 0] ALU_OUT_OUT                ,
        output  [2  : 0] DATA_CACHE_LOAD_OUT        ,
        output  [1  : 0] DATA_CACHE_STORE_OUT       ,
        output  [31 : 0] DATA_CACHE_STORE_DATA_OUT  ,
        output           WRITE_BACK_MUX_SELECT_OUT  ,
        output           RD_WRITE_ENABLE_OUT              
    );
    
    reg  [4  : 0] rd_address_reg             ;
    reg  [31 : 0] alu_out_reg                ;
    reg  [2  : 0] data_cache_load_reg        ;
    reg  [1  : 0] data_cache_store_reg       ;
    reg  [31 : 0] data_cache_store_data_reg  ;
    reg           write_back_mux_select_reg  ;
    reg           rd_write_enable_reg        ;         
    
    always@(posedge CLK) 
    begin
        rd_address_reg              <= RD_ADDRESS_OUT               ;
        alu_out_reg                 <= ALU_OUT_IN                   ;
        data_cache_load_reg         <= DATA_CACHE_LOAD_OUT          ;
        data_cache_store_reg        <= DATA_CACHE_STORE_OUT         ;
        data_cache_store_data_reg   <= DATA_CACHE_STORE_DATA_OUT    ;
        write_back_mux_select_reg   <= WRITE_BACK_MUX_SELECT_OUT    ;
        rd_write_enable_reg         <= RD_WRITE_ENABLE_OUT          ;
    end
    
    assign RD_ADDRESS_OUT               = rd_address_reg            ;
    assign ALU_OUT_OUT                  = alu_out_reg               ;
    assign DATA_CACHE_LOAD_OUT          = data_cache_load_reg       ;
    assign DATA_CACHE_STORE_OUT         = data_cache_store_reg      ;
    assign DATA_CACHE_STORE_DATA_OUT    = data_cache_store_data_reg ;
    assign WRITE_BACK_MUX_SELECT_OUT    = write_back_mux_select_reg ;
    assign RD_WRITE_ENABLE_OUT          = rd_write_enable_reg       ;
    
endmodule
