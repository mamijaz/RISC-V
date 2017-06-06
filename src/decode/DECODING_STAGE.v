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
            parameter   ADDRESS_WIDTH           = 32                        ,
            parameter   DATA_WIDTH              = 32                        ,
            parameter   REG_ADD_WIDTH           = 5                         ,
            parameter   ALU_INS_WIDTH           = 5                         ,
            parameter   D_CACHE_LW_WIDTH        = 3                         ,
            parameter   D_CACHE_SW_WIDTH        = 2                         ,
            parameter   IMM_FORMAT_SELECT       = 3                         ,
            
            parameter   HIGH                    = 1'b1                      ,
            parameter   LOW                     = 1'b0
        ) (
            input                                   CLK                     ,
            input                                   STALL_DECODING_STAGE    ,
            input                                   CLEAR_DECODING_STAGE    ,
            input   [REG_ADD_WIDTH - 1      : 0]    RD_ADDRESS_IN           ,
            input   [DATA_WIDTH - 1         : 0]    RD_DATA_IN              ,
            input                                   RD_WRITE_ENABLE_IN      ,
            input   [DATA_WIDTH - 1         : 0]    INSTRUCTION             ,
            input   [ADDRESS_WIDTH - 1      : 0]    PC_IN                   ,
            input                                   PC_VALID                ,
            output  [ADDRESS_WIDTH - 1      : 0]    PC_OUT                  ,
            output  [REG_ADD_WIDTH - 1      : 0]    RS1_ADDRESS             ,
            output  [REG_ADD_WIDTH - 1      : 0]    RS2_ADDRESS             ,
            output  [REG_ADD_WIDTH - 1      : 0]    RD_ADDRESS_OUT          ,
            output  [DATA_WIDTH - 1         : 0]    RS1_DATA                ,
            output  [DATA_WIDTH - 1         : 0]    RS2_DATA                ,                       
            output  [DATA_WIDTH - 1         : 0]    IMM_OUTPUT              , 
            output  [ALU_INS_WIDTH - 1      : 0]    ALU_INSTRUCTION         ,
            output                                  ALU_INPUT_1_SELECT      ,    
            output                                  ALU_INPUT_2_SELECT      ,
            output  [D_CACHE_LW_WIDTH - 1   : 0]    DATA_CACHE_LOAD         ,
            output  [D_CACHE_SW_WIDTH - 1   : 0]    DATA_CACHE_STORE        ,
            output                                  WRITE_BACK_MUX_SELECT   ,
            output                                  RD_WRITE_ENABLE_OUT        
    );
    
    reg     [ADDRESS_WIDTH - 1      : 0]    pc_reg                          ;
    reg     [REG_ADD_WIDTH - 1      : 0]    rs1_address_reg                 ;
    reg     [REG_ADD_WIDTH - 1      : 0]    rs2_address_reg                 ;
    reg     [REG_ADD_WIDTH - 1      : 0]    rd_address_reg                  ;
    reg     [DATA_WIDTH - 1         : 0]    rs1_data_reg                    ;
    reg     [DATA_WIDTH - 1         : 0]    rs2_data_reg                    ;                       
    reg     [DATA_WIDTH - 1         : 0]    imm_output_reg                  ;
    reg     [ALU_INS_WIDTH - 1      : 0]    alu_instruction_reg             ;
    reg                                     alu_input_1_select_reg          ;
    reg                                     alu_input_2_select_reg          ;
    reg     [D_CACHE_LW_WIDTH - 1   : 0]    data_cache_load_reg             ;
    reg     [D_CACHE_SW_WIDTH - 1   : 0]    data_cache_store_reg            ;
    reg                                     write_back_mux_select_reg       ;
    reg                                     rd_write_enable_reg             ;
    
    wire    [REG_ADD_WIDTH - 1      : 0]    rs1_address                     ;
    wire    [REG_ADD_WIDTH - 1      : 0]    rs2_address                     ;
    wire    [REG_ADD_WIDTH - 1      : 0]    rd_address_out                  ;
    wire    [DATA_WIDTH - 1         : 0]    rs1_data                        ;
    wire    [DATA_WIDTH - 1         : 0]    rs2_data                        ;  
    wire    [IMM_FORMAT_SELECT - 1  : 0]    imm_format                      ;                    
    wire    [DATA_WIDTH - 1         : 0]    imm_output                      ;
    wire    [ALU_INS_WIDTH - 1      : 0]    alu_instruction                 ;
    wire                                    alu_input_1_select              ;
    wire                                    alu_input_2_select              ;
    wire    [D_CACHE_LW_WIDTH - 1   : 0]    data_cache_load                 ;
    wire    [D_CACHE_SW_WIDTH - 1   : 0]    data_cache_store                ;
    wire                                    write_back_mux_select           ;
    wire                                    rd_write_enable_out             ;

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
                    write_back_mux_select_reg   <= LOW                      ;
                    rd_write_enable_reg         <= LOW                      ;
                end
            end
        end
        else
        begin
            pc_reg                      <= 32'b0                            ;
            rs1_address_reg             <= 5'b0                             ;
            rs2_address_reg             <= 5'b0                             ;
            rd_address_reg              <= 5'b0                             ;
            rs1_data_reg                <= 32'b0                            ;
            rs2_data_reg                <= 32'b0                            ;             
            imm_output_reg              <= 32'b0                            ;
            alu_instruction_reg         <= 5'b0                             ;
            alu_input_1_select_reg      <= LOW                              ;
            alu_input_2_select_reg      <= LOW                              ;
            data_cache_load_reg         <= 3'b0                             ;
            data_cache_store_reg        <= 2'b0                             ;
            write_back_mux_select_reg   <= LOW                              ;
            rd_write_enable_reg         <= LOW                              ;
        end
    end
    
    assign PC_OUT                   = pc_reg                                ;
    assign RS1_ADDRESS              = rs1_address_reg                       ;        
    assign RS2_ADDRESS              = rs2_address_reg                       ;
    assign RD_ADDRESS_OUT           = rd_address_reg                        ;
    assign RS1_DATA                 = rs1_data_reg                          ;
    assign RS2_DATA                 = rs2_data_reg                          ;        
    assign IMM_OUTPUT               = imm_output_reg                        ;
    assign ALU_INSTRUCTION          = alu_instruction_reg                   ;
    assign ALU_INPUT_1_SELECT       = alu_input_1_select_reg                ;
    assign ALU_INPUT_2_SELECT       = alu_input_2_select_reg                ;
    assign DATA_CACHE_LOAD          = data_cache_load_reg                   ;
    assign DATA_CACHE_STORE         = data_cache_store_reg                  ;
    assign WRITE_BACK_MUX_SELECT    = write_back_mux_select_reg             ;
    assign RD_WRITE_ENABLE_OUT      = rd_write_enable_reg                   ;
    
endmodule
