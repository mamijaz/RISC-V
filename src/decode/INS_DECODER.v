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
        parameter DATA_CACHE_STORE_W    = 2'b11         ,
        
        parameter SELECT_RS1            = 1'b0          ,
        parameter SELECT_PC             = 1'b1          ,
        parameter SELECT_RS2            = 1'b0          ,
        parameter SELECT_IMM            = 1'b1          ,
        
        parameter HIGH                  = 1'b1          ,
        parameter LOW                   = 1'b0                     
    ) (
        input   [31 : 0] INSTRUCTION            ,
        output  [2  : 0] IMM_FORMAT             ,
        output  [4  : 0] RS1_ADDRESS            ,
        output  [4  : 0] RS2_ADDRESS            ,
        output  [4  : 0] RD_ADDRESS             ,
		output  [4  : 0] ALU_INSTRUCTION        ,
        output           ALU_INPUT_1_SELECT     ,
        output           ALU_INPUT_2_SELECT     ,
        output  [2  : 0] DATA_CACHE_LOAD        ,
        output  [1  : 0] DATA_CACHE_STORE       ,
        output           WRITE_BACK_MUX_SELECT  ,
        output           RD_WRITE_ENABLE        
    );
    
    reg  [2  : 0]   imm_format_reg              ;
    reg  [4  : 0]   rs1_address_reg             ;
    reg  [4  : 0]   rs2_address_reg             ;
    reg  [4  : 0]   rd_address_reg              ;
    reg  [4  : 0]   alu_instruction_reg         ;
    reg             alu_input_1_select_reg      ;
    reg             alu_input_2_select_reg      ;
    reg  [2  : 0]   data_cache_load_reg         ;
    reg  [1  : 0]   data_cache_store_reg        ;
    reg             write_back_mux_select_reg   ;
    reg             rd_write_enable_reg         ;
    
    wire [6  : 0]   opcode                      ;
    wire [4  : 0]   rd                          ;
    wire [2  : 0]   fun3                        ;
    wire [4  : 0]   rs_1                        ;
    wire [4  : 0]   rs_2                        ;
    wire [6  : 0]   fun7                        ;
    
    assign opcode   = INSTRUCTION[6  :  0]      ; 
    assign rd       = INSTRUCTION[11 :  7]      ;
    assign fun3     = INSTRUCTION[14 : 12]      ; 
    assign rs_1     = INSTRUCTION[19 : 15]      ;
    assign rs_2     = INSTRUCTION[24 : 20]      ;
    assign fun7     = INSTRUCTION[31 : 25]      ;
    
    always@(*)
    begin
        case(opcode)
                RV321_LUI:
                begin 
                    imm_format_reg              = U_FORMAT;
                    rs1_address_reg             = 5'b0;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_instruction_reg         = ALU_ADD;
                    alu_input_1_select_reg      = SELECT_PC;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_AUIPC:
                begin 
                    imm_format_reg              = U_FORMAT;
                    rs1_address_reg             = 5'b0;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_instruction_reg         = ALU_ADD;
                    alu_input_1_select_reg      = SELECT_PC;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_JAL:
                begin
                    imm_format_reg              = UJ_FORMAT;
                    rs1_address_reg             = 5'b0;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_instruction_reg         = ALU_JAL;
                    alu_input_1_select_reg      = SELECT_PC;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_JALR:
                begin
                    imm_format_reg              = I_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_instruction_reg         = ALU_JALR;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_BRANCH:
                begin
                    case(fun3)
                        RV321_FUN3_BEQ:
                        begin
                            alu_instruction_reg = ALU_BEQ;
                        end
                        RV321_FUN3_BNE:
                        begin
                            alu_instruction_reg = ALU_BNE;
                        end
                        RV321_FUN3_BLT:
                        begin
                            alu_instruction_reg = ALU_BLT;
                        end
                        RV321_FUN3_BGE:
                        begin
                            alu_instruction_reg = ALU_BGE;
                        end
                        RV321_FUN3_BLTU:
                        begin
                            alu_instruction_reg = ALU_BLTU;
                        end
                        RV321_FUN3_BGEU:
                        begin
                            alu_instruction_reg = ALU_BGEU;
                        end
                        default:
                        begin
                            alu_instruction_reg = ALU_NOP;
                        end
                    endcase
                    imm_format_reg              = SB_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = rs_2;
                    rd_address_reg              = 5'b0;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_RS2;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = LOW;
                end
                RV321_LOAD:
                begin
                    case(fun3)
                        RV321_FUN3_LB:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_B_S;
                        end
                        RV321_FUN3_LH:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_H_S;
                        end
                        RV321_FUN3_LW:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_W;
                        end
                        RV321_FUN3_LBU:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_B_U;
                        end
                        RV321_FUN3_LHU:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_H_U;
                        end
                        default:
                        begin
                            data_cache_load_reg = DATA_CACHE_LOAD_NONE;
                        end
                    endcase
                    imm_format_reg              = I_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_instruction_reg         = ALU_ADD;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = HIGH;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_STORE:
                begin
                    case(fun3)
                        RV321_FUN3_SB:
                        begin
                            data_cache_store_reg = DATA_CACHE_STORE_B;
                        end
                        RV321_FUN3_SH:
                        begin
                            data_cache_store_reg = DATA_CACHE_STORE_H;
                        end
                        RV321_FUN3_SW:
                        begin
                            data_cache_store_reg = DATA_CACHE_STORE_W;
                        end
                        default:
                        begin
                            data_cache_store_reg = DATA_CACHE_STORE_NONE;
                        end
                    endcase
                    imm_format_reg              = S_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = rs_2;
                    rd_address_reg              = 5'b0;
                    alu_instruction_reg         = ALU_ADD;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = LOW;
                end
                RV321_IMMEDIATE:
                begin
                    case(fun3)
                        RV321_FUN3_ADD_SUB:
                        begin
                            alu_instruction_reg = ALU_ADD; 
                        end
                        RV321_FUN3_SLL:
                        begin
                            alu_instruction_reg = ALU_SLLI; 
                        end
                        RV321_FUN3_SLT:
                        begin
                            alu_instruction_reg = ALU_SLT; 
                        end
                        RV321_FUN3_SLTU:
                        begin
                            alu_instruction_reg = ALU_SLTU; 
                        end
                        RV321_FUN3_XOR:
                        begin
                           alu_instruction_reg  = ALU_XOR; 
                        end
                        RV321_FUN3_SRL_SRA:
                        begin
                            case(fun7)  
                                RV321_FUN7_SRL:
                                begin
                                    alu_instruction_reg = ALU_SRLI; 
                                end
                                RV321_FUN7_SRA:
                                begin
                                    alu_instruction_reg = ALU_SRAI;
                                end 
                                default:
                                begin
                                    alu_instruction_reg = ALU_NOP;
                                end
                            endcase
                        end
                        RV321_FUN3_OR:
                        begin
                            alu_instruction_reg = ALU_OR; 
                        end
                        RV321_FUN3_AND:
                        begin
                            alu_instruction_reg = ALU_OR; 
                        end
                    endcase
                    imm_format_reg              = I_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = rd;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_IMM;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                RV321_ALU:
                begin 
                    case(fun3)
                        RV321_FUN3_ADD_SUB:
                        begin
                            case(fun7)  
                                RV321_FUN7_ADD:
                                begin
                                    alu_instruction_reg = ALU_ADD; 
                                end
                                RV321_FUN7_SUB:
                                begin
                                    alu_instruction_reg = ALU_ADD;
                                end 
                                default:
                                begin
                                    alu_instruction_reg = ALU_NOP;
                                end
                            endcase
                        end
                        RV321_FUN3_SLL:
                        begin
                            alu_instruction_reg = ALU_SLL; 
                        end
                        RV321_FUN3_SLT:
                        begin
                            alu_instruction_reg = ALU_SLT; 
                        end
                        RV321_FUN3_SLTU:
                        begin
                            alu_instruction_reg = ALU_SLTU; 
                        end
                        RV321_FUN3_XOR:
                        begin
                            alu_instruction_reg = ALU_XOR; 
                        end
                        RV321_FUN3_SRL_SRA:
                        begin
                            case(fun7)  
                                RV321_FUN7_SRL:
                                begin
                                    alu_instruction_reg = ALU_SRL; 
                                end
                                RV321_FUN7_SRA:
                                begin
                                    alu_instruction_reg = ALU_SRA;
                                end 
                                default:
                                begin
                                    alu_instruction_reg = ALU_NOP;
                                end
                            endcase
                        end
                        RV321_FUN3_OR:
                        begin
                            alu_instruction_reg = ALU_OR;
                        end
                        RV321_FUN3_AND:
                        begin
                            alu_instruction_reg = ALU_AND;
                        end
                    endcase
                    imm_format_reg              = R_FORMAT;
                    rs1_address_reg             = rs_1;
                    rs2_address_reg             = rs_2;
                    rd_address_reg              = rd;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_RS2;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = HIGH;
                end
                default:
                begin
                    imm_format_reg              = R_FORMAT;
                    rs1_address_reg             = 5'b0;
                    rs2_address_reg             = 5'b0;
                    rd_address_reg              = 5'b0;
                    alu_instruction_reg         = ALU_NOP;
                    alu_input_1_select_reg      = SELECT_RS1;   
                    alu_input_2_select_reg      = SELECT_RS2;
                    data_cache_load_reg         = DATA_CACHE_LOAD_NONE;
                    data_cache_store_reg        = DATA_CACHE_STORE_NONE;
                    write_back_mux_select_reg   = LOW;
                    rd_write_enable_reg         = LOW;
                end
        endcase
    end
    
    assign  IMM_FORMAT              = imm_format_reg            ;
    assign  RS1_ADDRESS             = rs1_address_reg           ;
    assign  RS2_ADDRESS             = rs2_address_reg           ;
    assign  RD_ADDRESS              = rd_address_reg            ;
    assign  ALU_INSTRUCTION         = alu_instruction_reg       ;
    assign  ALU_INPUT_1_SELECT      = alu_input_1_select_reg    ;
    assign  ALU_INPUT_2_SELECT      = alu_input_2_select_reg    ;
    assign  DATA_CACHE_LOAD         = data_cache_load_reg       ;
    assign  DATA_CACHE_STORE        = data_cache_store_reg      ;
    assign  WRITE_BACK_MUX_SELECT   = write_back_mux_select_reg ;
    assign  RD_WRITE_ENABLE         = rd_write_enable_reg       ;
    
endmodule
