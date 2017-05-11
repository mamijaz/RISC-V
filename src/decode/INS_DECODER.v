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
        parameter RV321_FUN3_LB         = 3'b000        ,
        parameter RV321_FUN3_LH         = 3'b001        ,
        parameter RV321_FUN3_LW         = 3'b010        ,
        parameter RV321_FUN3_LBU        = 3'b100        ,
        parameter RV321_FUN3_LHU        = 3'b101        ,
        parameter RV321_FUN3_SB         = 3'b000        ,
        parameter RV321_FUN3_SH         = 3'b001        ,
        parameter RV321_FUN3_SW         = 3'b010        ,
        parameter RV321_FUN3_BEQ        = 3'b000        ,
        parameter RV321_FUN3_BNE        = 3'b001        ,
        parameter RV321_FUN3_BLT        = 3'b100        ,
        parameter RV321_FUN3_BGE        = 3'b101        ,
        parameter RV321_FUN3_BLTU       = 3'b110        ,
        parameter RV321_FUN3_BGEU       = 3'b111        ,
        
        parameter RV321_FUN7_ADD        = 7'b0000000    ,
        parameter RV321_FUN7_SUB        = 7'b0100000    ,
        parameter RV321_FUN7_SRL        = 7'b0000000    ,
        parameter RV321_FUN7_SRA        = 7'b0100000    ,
        
        parameter R_FORMAT              = 3'b000        ,
        parameter I_FORMAT              = 3'b001        ,
        parameter S_FORMAT              = 3'b010        ,
        parameter U_FORMAT              = 3'b011        ,
        parameter SB_FORMAT             = 3'b100        ,
        parameter UJ_FORMAT             = 3'b101        ,
        
        parameter ALU_NOP               = 5'b00000      ,
        parameter ALU_ADD               = 5'b00001      ,
        parameter ALU_SUB               = 5'b00010      ,
        parameter ALU_SLL               = 5'b00011      ,
        parameter ALU_SLT               = 5'b00100      ,
        parameter ALU_SLTU              = 5'b00101      ,
        parameter ALU_XOR               = 5'b00110      ,
        parameter ALU_SRL               = 5'b00111      ,
        parameter ALU_SRA               = 5'b01000      ,
        parameter ALU_OR                = 5'b01001      ,
        parameter ALU_AND               = 5'b01010      ,
        parameter ALU_SLLI              = 5'b01010      ,
        parameter ALU_SRLI              = 5'b01010      ,
        parameter ALU_SRAI              = 5'b01010      ,
        parameter ALU_JAL               = 5'b01010      ,
        parameter ALU_JALR              = 5'b01011      ,
        parameter ALU_BEQ               = 5'b01100      ,
        parameter ALU_BNE               = 5'b01101      ,
        parameter ALU_BLT               = 5'b01110      ,
        parameter ALU_BGE               = 5'b01111      ,
        parameter ALU_BLTU              = 5'b10000      ,
        parameter ALU_BGEU              = 5'b10001      ,
        
        parameter DATA_CACHE_LOAD_NONE  = 3'b000        , 
        parameter DATA_CACHE_LOAD_B_S   = 3'b010        ,
        parameter DATA_CACHE_LOAD_B_U   = 3'b011        ,
        parameter DATA_CACHE_LOAD_H_S   = 3'b100        ,
        parameter DATA_CACHE_LOAD_H_U   = 3'b101        ,
        parameter DATA_CACHE_LOAD_W     = 3'b110        ,
        parameter DATA_CACHE_STORE_NONE = 2'b00         ,
        parameter DATA_CACHE_STORE_B    = 2'b01         ,
        parameter DATA_CACHE_STORE_H    = 2'b10         ,
        parameter DATA_CACHE_STORE_W    = 2'b11                  
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
        output  [2  : 0] DATA_CACHE_LOAD        ,
        output  [1  : 0] DATA_CACHE_STORE       ,
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
    reg  [2  : 0]   DATA_CACHE_LOAD_REG         ;
    reg  [1  : 0]   DATA_CACHE_STORE_REG        ;
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
                    IMM_FORMAT_REG              = U_FORMAT;
                    RS1_ADDRESS_REG             = 5'b0;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_ADD;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b1;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                RV321_AUIPC:
                begin 
                    IMM_FORMAT_REG              = U_FORMAT;
                    RS1_ADDRESS_REG             = 5'b0;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_ADD;
                    ALU_INPUT_1_SELECT_REG      = 1'b1;   
                    ALU_INPUT_2_SELECT_REG      = 1'b1;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                RV321_JAL:
                begin
                    IMM_FORMAT_REG              = UJ_FORMAT;
                    RS1_ADDRESS_REG             = 5'b0;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_JAL;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                RV321_JALR:
                begin
                    IMM_FORMAT_REG              = I_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_JALR;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                RV321_BRANCH:
                begin
                    case(FUN3)
                        RV321_FUN3_BEQ:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BEQ;
                        end
                        RV321_FUN3_BNE:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BNE;
                        end
                        RV321_FUN3_BLT:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BLT;
                        end
                        RV321_FUN3_BGE:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BGE;
                        end
                        RV321_FUN3_BLTU:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BLTU;
                        end
                        RV321_FUN3_BGEU:
                        begin
                            ALU_INSTRUCTION_REG = ALU_BGEU;
                        end
                        default:
                        begin
                            ALU_INSTRUCTION_REG = ALU_NOP;
                        end
                    endcase
                    IMM_FORMAT_REG              = SB_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = RS_2;
                    RD_ADDRESS_REG              = 5'b0;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b0;
                end
                RV321_LOAD:
                begin
                    case(FUN3)
                        RV321_FUN3_LB:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_B_S;
                        end
                        RV321_FUN3_LH:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_H_S;
                        end
                        RV321_FUN3_LW:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_W;
                        end
                        RV321_FUN3_LBU:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_B_U;
                        end
                        RV321_FUN3_LHU:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_H_U;
                        end
                        default:
                        begin
                            DATA_CACHE_LOAD_REG = DATA_CACHE_LOAD_NONE;
                        end
                    endcase
                    IMM_FORMAT_REG              = I_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_ADD;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b1;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b1;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                RV321_STORE:
                begin
                    case(FUN3)
                        RV321_FUN3_SB:
                        begin
                            DATA_CACHE_STORE_REG = DATA_CACHE_STORE_B;
                        end
                        RV321_FUN3_SH:
                        begin
                            DATA_CACHE_STORE_REG = DATA_CACHE_STORE_H;
                        end
                        RV321_FUN3_SW:
                        begin
                            DATA_CACHE_STORE_REG = DATA_CACHE_STORE_W;
                        end
                        default:
                        begin
                            DATA_CACHE_STORE_REG = DATA_CACHE_STORE_NONE;
                        end
                    endcase
                    IMM_FORMAT_REG              = S_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = RS_2;
                    RD_ADDRESS_REG              = 5'b0;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_ADD;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b1;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b0;
                end
                RV321_IMMEDIATE:
                begin
                    case(FUN3)
                        RV321_FUN3_ADD_SUB:
                        begin
                            SHIFT_AMOUNT_REG    = 5'b0;
                            ALU_INSTRUCTION_REG = ALU_ADD; 
                        end
                        RV321_FUN3_SLL:
                        begin
                            SHIFT_AMOUNT_REG    = SHAMT;
                            ALU_INSTRUCTION_REG = ALU_SLLI; 
                        end
                        RV321_FUN3_SLT:
                        begin
                            SHIFT_AMOUNT_REG    = 5'b0;
                            ALU_INSTRUCTION_REG = ALU_SLT; 
                        end
                        RV321_FUN3_SLTU:
                        begin
                            SHIFT_AMOUNT_REG    = 5'b0;
                            ALU_INSTRUCTION_REG = ALU_SLTU; 
                        end
                        RV321_FUN3_XOR:
                        begin
                           SHIFT_AMOUNT_REG     = 5'b0; 
                           ALU_INSTRUCTION_REG  = ALU_XOR; 
                        end
                        RV321_FUN3_SRL_SRA:
                        begin
                            case(FUN7)  
                                RV321_FUN7_SRL:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_SRLI; 
                                end
                                RV321_FUN7_SRA:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_SRAI;
                                end 
                                default:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_NOP;
                                end
                            endcase
                            SHIFT_AMOUNT_REG = SHAMT;
                        end
                        RV321_FUN3_OR:
                        begin
                            SHIFT_AMOUNT_REG    = 5'b0;
                            ALU_INSTRUCTION_REG = ALU_OR; 
                        end
                        RV321_FUN3_AND:
                        begin
                            SHIFT_AMOUNT_REG    = 5'b0;
                            ALU_INSTRUCTION_REG = ALU_OR; 
                        end
                    endcase
                    IMM_FORMAT_REG              = I_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = RD;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b1;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
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
                            ALU_INSTRUCTION_REG = ALU_SLL; 
                        end
                        RV321_FUN3_SLT:
                        begin
                            ALU_INSTRUCTION_REG = ALU_SLT; 
                        end
                        RV321_FUN3_SLTU:
                        begin
                            ALU_INSTRUCTION_REG = ALU_SLTU; 
                        end
                        RV321_FUN3_XOR:
                        begin
                            ALU_INSTRUCTION_REG = ALU_XOR; 
                        end
                        RV321_FUN3_SRL_SRA:
                        begin
                            case(FUN7)  
                                RV321_FUN7_SRL:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_SRL; 
                                end
                                RV321_FUN7_SRA:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_SRA;
                                end 
                                default:
                                begin
                                    ALU_INSTRUCTION_REG = ALU_NOP;
                                end
                            endcase
                        end
                        RV321_FUN3_OR:
                        begin
                            ALU_INSTRUCTION_REG = ALU_OR;
                        end
                        RV321_FUN3_AND:
                        begin
                            ALU_INSTRUCTION_REG = ALU_AND;
                        end
                    endcase
                    IMM_FORMAT_REG              = R_FORMAT;
                    RS1_ADDRESS_REG             = RS_1;
                    RS2_ADDRESS_REG             = RS_2;
                    RD_ADDRESS_REG              = RD;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b1;
                end
                default:
                begin
                    IMM_FORMAT_REG              = R_FORMAT;
                    RS1_ADDRESS_REG             = 5'b0;
                    RS2_ADDRESS_REG             = 5'b0;
                    RD_ADDRESS_REG              = 5'b0;
                    SHIFT_AMOUNT_REG            = 5'b0;
                    ALU_INSTRUCTION_REG         = ALU_NOP;
                    ALU_INPUT_1_SELECT_REG      = 1'b0;   
                    ALU_INPUT_2_SELECT_REG      = 1'b0;
                    DATA_CACHE_LOAD_REG         = DATA_CACHE_LOAD_NONE;
                    DATA_CACHE_STORE_REG        = DATA_CACHE_STORE_NONE;
                    WRITE_BACK_MUX_SELECT_REG   = 1'b0;
                    RD_WRITE_ENABLE_REG         = 1'b0;
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
    assign  DATA_CACHE_LOAD         = DATA_CACHE_LOAD_REG       ;
    assign  DATA_CACHE_STORE        = DATA_CACHE_STORE_REG      ;
    assign  WRITE_BACK_MUX_SELECT   = WRITE_BACK_MUX_SELECT_REG ;
    assign  RD_WRITE_ENABLE         = RD_WRITE_ENABLE_REG       ;
    
endmodule
