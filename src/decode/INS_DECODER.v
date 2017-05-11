`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/08/2017 10:48:13 AM
// Design Name: 
// Module Name:     INS_DECODER
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


module INS_DECODER #(
        parameter RV321_LUI             = 7'b0110111    ,
        parameter RV321_AUIPC           = 7'b0010111    ,
        parameter RV321_JAL             = 7'b1101111    ,
        parameter RV321_JALR            = 7'b1100111    ,
        parameter RV321_BRANCH          = 7'b1100011    ,
        parameter RV321_LOAD            = 7'b0000011    ,
        parameter RV321_STORE           = 7'b0100011    ,
        parameter RV321_IMMEDIATE       = 7'b0010011    ,
        parameter RV321_ALU             = 7'b0110011    ,
        
        parameter RV321_FUN3_ADD_SUB    = 3'b000        ,
        parameter RV321_FUN3_SLL        = 3'b001        ,
        parameter RV321_FUN3_SLT        = 3'b010        ,
        parameter RV321_FUN3_SLTU       = 3'b011        ,
        parameter RV321_FUN3_XOR        = 3'b100        ,
        parameter RV321_FUN3_SRL_SRA    = 3'b101        ,
        parameter RV321_FUN3_OR         = 3'b110        ,
        parameter RV321_FUN3_AND        = 3'b111        ,
        
        parameter RV321_FUN7_ADD        = 7'b0000000    ,
        parameter RV321_FUN7_SUB        = 7'b0100000    ,
        
        parameter R_FORMAT              = 3'b000        ,
        parameter I_FORMAT              = 3'b001        ,
        parameter S_FORMAT              = 3'b010        ,
        parameter U_FORMAT              = 3'b011        ,
        parameter SB_FORMAT             = 3'b100        ,
        parameter UJ_FORMAT             = 3'b101        ,
        
        parameter ALU_NOP               = 5'b00000      ,
        parameter ALU_ADD               = 5'b00001      ,
        parameter ALU_SUB               = 5'b00010           
    ) (
        input   [31 : 0] INSTRUCTION            ,
        output  [2  : 0] IMM_FORMAT             ,
        output  [4  : 0] RS1_ADDRESS            ,
        output  [4  : 0] RS2_ADDRESS            ,
        output  [4  : 0] RD_ADDRESS             ,
		output  [4  : 0] SHIFT_AMOUNT           ,
		output  [4  : 0] ALU_INSTRUCTION        ,
        output           ALU_INPUT_1_SELECT     ,
        output           ALU_INPUT_2_SELECT     ,
        output  [2  : 0] DATA_CACHE_READ        ,
        output  [1  : 0] DATA_CACHE_WRITE       ,
        output           WRITE_BACK_MUX_SELECT  ,
        output           RD_WRITE_ENABLE        
    );
    
    reg  [2  : 0]   IMM_FORMAT_REG              ;
    reg  [4  : 0]   RS1_ADDRESS_REG             ;
    reg  [4  : 0]   RS2_ADDRESS_REG             ;
    reg  [4  : 0]   RD_ADDRESS_REG              ;
    reg  [4  : 0]   SHIFT_AMOUNT_REG            ;
    reg  [4  : 0]   ALU_INSTRUCTION_REG         ;
    reg             ALU_INPUT_1_SELECT_REG      ;
    reg             ALU_INPUT_2_SELECT_REG      ;
    reg  [2  : 0]   DATA_CACHE_READ_REG         ;
    reg  [1  : 0]   DATA_CACHE_WRITE_REG        ;
    reg             WRITE_BACK_MUX_SELECT_REG   ;
    reg             RD_WRITE_ENABLE_REG         ;
    
    wire [6  : 0]   OPCODE                      ;
    wire [4  : 0]   RD                          ;
    wire [2  : 0]   FUN3                        ;
    wire [4  : 0]   RS_1                        ;
    wire [4  : 0]   RS_2                        ;
    wire [6  : 0]   FUN7                        ;
    wire [4  : 0]   SHAMT                       ;
    
    assign OPCODE   = INSTRUCTION[6  :  0]      ; 
    assign RD       = INSTRUCTION[11 :  7]      ;
    assign FUN3     = INSTRUCTION[14 : 12]      ; 
    assign RS_1     = INSTRUCTION[19 : 15]      ;
    assign RS_2     = INSTRUCTION[24 : 20]      ;
    assign FUN7     = INSTRUCTION[31 : 25]      ;
    assign SHAMT    = INSTRUCTION[24 : 20]      ;
    
    always@(*)
    begin
        case(OPCODE)
                RV321_LUI:
                begin 
                end
                RV321_AUIPC:
                begin 
                end
                RV321_JAL:
                begin
                end
                RV321_JALR:
                begin
                end
                RV321_BRANCH:
                begin
                end
                RV321_LOAD:
                begin
                end
                RV321_STORE:
                begin
                end
                RV321_IMMEDIATE:
                begin
                end
                RV321_ALU:
                begin 
                    case(FUN3)
                        RV321_FUN3_ADD_SUB:
                        begin
                            case(FUN7)  
                                RV321_FUN7_ADD:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_ADD; 
                                end
                                RV321_FUN7_SUB:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_ADD;
                                end 
                                default:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_NOP;
                                end
                            endcase
                        end
                        RV321_FUN3_SLL:
                        begin
                        end
                        RV321_FUN3_SLT:
                        begin
                        end
                        RV321_FUN3_SLTU:
                        begin
                        end
                        RV321_FUN3_XOR:
                        begin
                        end
                        RV321_FUN3_SRL_SRA:
                        begin
                        end
                        RV321_FUN3_OR:
                        begin
                        end
                        RV321_FUN3_AND:
                        begin
                        end
                    endcase
                    IMM_FORMAT_REG              = R_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = RS_2;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_READ_REG         = 3'b0;
                    DATA_CACHE_WRITE_REG        = 2'b0;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                default:
                begin
                end
        endcase
    end
    
    assign  IMM_FORMAT              = IMM_FORMAT_REG            ;
    assign  RS1_ADDRESS             = RS1_ADDRESS_REG           ;
    assign  RS2_ADDRESS             = RS2_ADDRESS_REG           ;
    assign  RD_ADDRESS              = RD_ADDRESS_REG            ;
    assign  SHIFT_AMOUNT            = SHIFT_AMOUNT_REG          ;
    assign  ALU_INSTRUCTION         = ALU_INSTRUCTION_REG       ;
    assign  ALU_INPUT_1_SELECT      = ALU_INPUT_1_SELECT_REG    ;
    assign  ALU_INPUT_2_SELECT      = ALU_INPUT_2_SELECT_REG    ;
    assign  DATA_CACHE_READ         = DATA_CACHE_READ_REG       ;
    assign  DATA_CACHE_WRITE        = DATA_CACHE_WRITE_REG      ;
    assign  WRITE_BACK_MUX_SELECT   = WRITE_BACK_MUX_SELECT_REG ;
    assign  RD_WRITE_ENABLE         = RD_WRITE_ENABLE_REG       ;
    
endmodule
