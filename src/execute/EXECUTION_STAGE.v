`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz 
// 
// Create Date:     05/11/2017 12:23:41 PM
// Design Name: 
// Module Name:     EXECUTION_STAGE
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


module EXECUTION_STAGE #(
        parameter   ADDRESS_WIDTH           = 32        ,
        parameter   DATA_WIDTH              = 32        ,
        parameter   REG_ADD_WIDTH           = 5         ,
        parameter   ALU_INS_WIDTH           = 5         ,
        parameter   D_CACHE_LW_WIDTH        = 3         ,
        parameter   D_CACHE_SW_WIDTH        = 2         ,
        
        parameter   HIGH                    = 1'b1      ,
        parameter   LOW                     = 1'b0
    ) (
        input                                   CLK                         ,
        input                                   STALL_EXECUTION_STAGE       ,
        input                                   CLEAR_EXECUTION_STAGE       ,
        input   [ADDRESS_WIDTH - 1     : 0]     PC_IN                       ,
        input   [REG_ADD_WIDTH - 1      : 0]    RD_ADDRESS_IN               ,
        input   [DATA_WIDTH - 1         : 0]    RS1_DATA                    ,
        input   [DATA_WIDTH - 1         : 0]    RS2_DATA                    ,                       
        input   [DATA_WIDTH - 1         : 0]    IMM_DATA                    ,
        input   [ALU_INS_WIDTH - 1      : 0]    ALU_INSTRUCTION             ,
        input                                   ALU_INPUT_1_SELECT          ,
        input                                   ALU_INPUT_2_SELECT          ,
        input   [D_CACHE_LW_WIDTH - 1   : 0]    DATA_CACHE_LOAD_IN          ,
        input   [D_CACHE_SW_WIDTH - 1   : 0]    DATA_CACHE_STORE_IN         ,
        input                                   WRITE_BACK_MUX_SELECT_IN    ,
        input                                   RD_WRITE_ENABLE_IN          ,
        output  [REG_ADD_WIDTH - 1      : 0]    RD_ADDRESS_OUT              ,
        output  [DATA_WIDTH - 1         : 0]    ALU_OUT                     ,
        output                                  BRANCH_TAKEN                ,
        output  [D_CACHE_LW_WIDTH - 1   : 0]    DATA_CACHE_LOAD_OUT         ,
        output  [D_CACHE_SW_WIDTH - 1   : 0]    DATA_CACHE_STORE_OUT        ,
        output  [DATA_WIDTH - 1         : 0]    DATA_CACHE_STORE_DATA       ,
        output                                  WRITE_BACK_MUX_SELECT_OUT   ,
        output                                  RD_WRITE_ENABLE_OUT           
    );
    
    reg     [REG_ADD_WIDTH - 1      : 0]    rd_address_out_reg              ;
    reg     [DATA_WIDTH - 1         : 0]    alu_out_reg                     ;
    reg     [D_CACHE_LW_WIDTH - 1   : 0]    data_cache_load_out_reg         ;
    reg     [D_CACHE_SW_WIDTH - 1   : 0]    data_cache_store_out_reg        ;
    reg     [DATA_WIDTH - 1         : 0]    data_cache_store_data_reg       ;
    reg                                     write_back_mux_select_out_reg   ;
    reg                                     rd_write_enable_out_reg         ;
    
    wire    [DATA_WIDTH - 1         : 0]    alu_in1                         ;
    wire    [DATA_WIDTH - 1         : 0]    alu_in2                         ;
    wire    [DATA_WIDTH - 1         : 0]    alu_out                         ;   
        
    MULTIPLEXER_2_TO_1 alu_in1_mux(
        .IN1(RS1_DATA),
        .IN2(PC_IN),
        .SELECT(ALU_INPUT_1_SELECT),
        .OUT(alu_in1)
        );
    
    MULTIPLEXER_2_TO_1 alu_in2_mux(
        .IN1(RS2_DATA),
        .IN2(IMM_DATA),
        .SELECT(ALU_INPUT_2_SELECT),
        .OUT(alu_in2)
        );
    
    ALU alu(
        .ALU_IN1(alu_in1),
        .ALU_IN2(alu_in2),
        .ALU_INSTRUCTION(ALU_INSTRUCTION),
        .ALU_OUT(alu_out),
        .BRANCH_TAKEN(BRANCH_TAKEN)
        );
        
    always@(posedge CLK) 
    begin
        if(CLEAR_EXECUTION_STAGE == LOW)
        begin
            if(STALL_EXECUTION_STAGE == LOW)
            begin
                rd_address_out_reg              <= RD_ADDRESS_IN            ;
                alu_out_reg                     <= alu_out                  ;
                data_cache_load_out_reg         <= DATA_CACHE_LOAD_IN       ;
                data_cache_store_out_reg        <= DATA_CACHE_STORE_IN      ;
                data_cache_store_data_reg       <= RS2_DATA                 ;
                write_back_mux_select_out_reg   <= WRITE_BACK_MUX_SELECT_IN ;
                rd_write_enable_out_reg         <= RD_WRITE_ENABLE_IN       ;
            end
        end
        else
        begin
            rd_address_out_reg              <= 5'b0                         ;
            alu_out_reg                     <= 32'b0                        ;
            data_cache_load_out_reg         <= 3'b0                         ;
            data_cache_store_out_reg        <= 2'b0                         ;
            data_cache_store_data_reg       <= 32'b0                        ;
            write_back_mux_select_out_reg   <= 1'b0                         ;
            rd_write_enable_out_reg         <= 1'b0                         ;
        end
    end
    
    assign RD_ADDRESS_OUT                   = rd_address_out_reg            ;
    assign ALU_OUT                          = alu_out_reg                   ;
    assign DATA_CACHE_LOAD_OUT              = data_cache_load_out_reg       ;
    assign DATA_CACHE_STORE_OUT             = data_cache_store_out_reg      ;
    assign DATA_CACHE_STORE_DATA            = data_cache_store_data_reg     ;
    assign WRITE_BACK_MUX_SELECT_OUT        = write_back_mux_select_out_reg ;
    assign RD_WRITE_ENABLE_OUT              = rd_write_enable_out_reg       ;
   
endmodule
