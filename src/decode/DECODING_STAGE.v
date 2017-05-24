`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/09/2017 07:54:56 PM
// Design Name: 
// Module Name:     DECODING_STAGE
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


module DECODING_STAGE #(
            parameter HIGH  = 1'b1  ,
            parameter LOW   = 1'b0
        ) (
            input            CLK                    ,
            input            STALL_DECODING_STAGE   ,
            input            CLEAR_DECODING_STAGE   ,
            input   [4  : 0] RD_ADDRESS_IN          ,
            input   [31 : 0] RD_DATA_IN             ,
            input            RD_WRITE_ENABLE_IN     ,
            input   [31 : 0] INSTRUCTION            ,
            input   [31 : 0] PC_IN                  ,
            input            PC_VALID               ,
            output  [31 : 0] PC_OUT                 ,
            output  [4  : 0] RS1_ADDRESS            ,
            output  [4  : 0] RS2_ADDRESS            ,
            output  [4  : 0] RD_ADDRESS_OUT         ,
            output  [31 : 0] RS1_DATA               ,
            output  [31 : 0] RS2_DATA               ,                       
            output  [31 : 0] IMM_OUTPUT             , 
            output  [4  : 0] ALU_INSTRUCTION        ,
            output           ALU_INPUT_1_SELECT     ,
            output           ALU_INPUT_2_SELECT     ,
            output  [2  : 0] DATA_CACHE_LOAD        ,
            output  [1  : 0] DATA_CACHE_STORE       ,
            output  [31 : 0] DATA_CACHE_STORE_DATA  ,
            output           WRITE_BACK_MUX_SELECT  ,
            output           RD_WRITE_ENABLE_OUT        
    );
    
    reg  [31 : 0]   pc_reg                      ;
    reg  [4  : 0]   rs1_address_reg             ;
    reg  [4  : 0]   rs2_address_reg             ;
    reg  [4  : 0]   rd_address_reg              ;
    reg  [31 : 0]   rs1_data_reg                ;
    reg  [31 : 0]   rs2_data_reg                ;                       
    reg  [31 : 0]   imm_output_reg              ;
    reg  [4  : 0]   alu_instruction_reg         ;
    reg             alu_input_1_select_reg      ;
    reg             alu_input_2_select_reg      ;
    reg  [2  : 0]   data_cache_load_reg         ;
    reg  [1  : 0]   data_cache_store_reg        ;
    reg  [31 : 0]   data_cache_store_data_reg   ;
    reg             write_back_mux_select_reg   ;
    reg             rd_write_enable_reg         ;
    
    wire [4  : 0]   rs1_address                 ;
    wire [4  : 0]   rs2_address                 ;
    wire [4  : 0]   rd_address_out              ;
    wire [31 : 0]   rs1_data                    ;
    wire [31 : 0]   rs2_data                    ;  
    wire [2  : 0]   imm_format                  ;                    
    wire [31 : 0]   imm_output                  ;
    wire [4  : 0]   alu_instruction             ;
    wire            alu_input_1_select          ;
    wire            alu_input_2_select          ;
    wire [2  : 0]   data_cache_load             ;
    wire [1  : 0]   data_cache_store            ;
    wire [31 : 0]   data_cache_store_data       ;
    wire            write_back_mux_select       ;
    wire            rd_write_enable_out         ;

    INS_DECODER ins_decoder(
        .INSTRUCTION(INSTRUCTION),
        .IMM_FORMAT(imm_format),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RD_ADDRESS(rd_address_out),
        .ALU_INSTRUCTION(alu_instruction),
        .ALU_INPUT_1_SELECT(alu_input_1_select),
        .ALU_INPUT_2_SELECT(alu_input_2_select),
        .DATA_CACHE_LOAD(data_cache_load),
        .DATA_CACHE_STORE(data_cache_store),
        .WRITE_BACK_MUX_SELECT(write_back_mux_select),
        .RD_WRITE_ENABLE(rd_write_enable_out)        
        );
        
    REGISTER_FILE register_file(
        .CLK(CLK),
        .RS1_ADDRESS(rs1_address),
        .RS2_ADDRESS(rs2_address),
        .RS1_DATA(rs1_data),
        .RS2_DATA(rs2_data),
        .RD_ADDRESS(RD_ADDRESS_IN),
        .RD_DATA(RD_DATA_IN),
        .RD_WRITE_EN(RD_WRITE_ENABLE_IN)
        );
        
    IMM_EXTENDER imm_extender(
        .IMM_INPUT(INSTRUCTION[31:7]),
        .IMM_FORMAT(imm_format),
        .IMM_OUTPUT(imm_output) 
        );
     
    always@(posedge CLK) 
    begin
        if(CLEAR_DECODING_STAGE == LOW)
        begin
            if(STALL_DECODING_STAGE == LOW)
            begin
                if(PC_VALID == HIGH)
                begin
                    pc_reg                      <= PC_IN                    ;
                    rs1_address_reg             <= rs1_address              ;
                    rs2_address_reg             <= rs2_address              ;
                    rd_address_reg              <= rd_address_out           ;
                    rs1_data_reg                <= rs1_data                 ;
                    rs2_data_reg                <= rs2_data                 ;             
                    imm_output_reg              <= imm_output               ;
                    alu_instruction_reg         <= alu_instruction          ;
                    alu_input_1_select_reg      <= alu_input_1_select       ;
                    alu_input_2_select_reg      <= alu_input_2_select       ;
                    data_cache_load_reg         <= data_cache_load          ;
                    data_cache_store_reg        <= data_cache_store         ;
                    data_cache_store_data_reg   <= rs2_data                 ;
                    write_back_mux_select_reg   <= write_back_mux_select    ;
                    rd_write_enable_reg         <= rd_write_enable_out      ;
                end
                else
                begin
                    pc_reg                      <= 32'b0                    ;
                    rs1_address_reg             <= 5'b0                     ;
                    rs2_address_reg             <= 5'b0                     ;
                    rd_address_reg              <= 5'b0                     ;
                    rs1_data_reg                <= 32'b0                    ;
                    rs2_data_reg                <= 32'b0                    ;             
                    imm_output_reg              <= 32'b0                    ;
                    alu_instruction_reg         <= 5'b0                     ;
                    alu_input_1_select_reg      <= LOW                      ;
                    alu_input_2_select_reg      <= LOW                      ;
                    data_cache_load_reg         <= 3'b0                     ;
                    data_cache_store_reg        <= 2'b0                     ;
                    data_cache_store_data_reg   <= 32'b0                    ;
                    write_back_mux_select_reg   <= LOW                      ;
                    rd_write_enable_reg         <= LOW                      ;
                end
            end
        end
        else
        begin
            pc_reg                      <= 32'b0                    ;
            rs1_address_reg             <= 5'b0                     ;
            rs2_address_reg             <= 5'b0                     ;
            rd_address_reg              <= 5'b0                     ;
            rs1_data_reg                <= 32'b0                    ;
            rs2_data_reg                <= 32'b0                    ;             
            imm_output_reg              <= 32'b0                    ;
            alu_instruction_reg         <= 5'b0                     ;
            alu_input_1_select_reg      <= LOW                      ;
            alu_input_2_select_reg      <= LOW                      ;
            data_cache_load_reg         <= 3'b0                     ;
            data_cache_store_reg        <= 2'b0                     ;
            data_cache_store_data_reg   <= 32'b0                    ;
            write_back_mux_select_reg   <= LOW                      ;
            rd_write_enable_reg         <= LOW                      ;
        end
    end
    
    assign PC_OUT                   = pc_reg                    ;
    assign RS1_ADDRESS              = rs1_address_reg           ;        
    assign RS2_ADDRESS              = rs2_address_reg           ;
    assign RD_ADDRESS_OUT           = rd_address_reg            ;
    assign RS1_DATA                 = rs1_data_reg              ;
    assign RS2_DATA                 = rs2_data_reg              ;        
    assign IMM_OUTPUT               = imm_output_reg            ;
    assign ALU_INSTRUCTION          = alu_instruction_reg       ;
    assign ALU_INPUT_1_SELECT       = alu_input_1_select_reg    ;
    assign ALU_INPUT_2_SELECT       = alu_input_2_select_reg    ;
    assign DATA_CACHE_LOAD          = data_cache_load_reg       ;
    assign DATA_CACHE_STORE         = data_cache_store_reg      ;
    assign DATA_CACHE_STORE_DATA    = data_cache_store_data_reg ;
    assign WRITE_BACK_MUX_SELECT    = write_back_mux_select_reg ;
    assign RD_WRITE_ENABLE_OUT      = rd_write_enable_reg       ;
    
endmodule
