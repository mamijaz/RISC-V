`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/09/2017 06:36:09 PM
// Design Name: 
// Module Name:     ALU
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


module ALU #(
        parameter DATA_WIDTH            = 32            ,
        parameter HIGH                  = 1'b1          ,
        parameter LOW                   = 1'b0          ,
        
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
        parameter ALU_SLLI              = 5'b01011      ,
        parameter ALU_SRLI              = 5'b01100      ,
        parameter ALU_SRAI              = 5'b01101      ,
        parameter ALU_JAL               = 5'b01110      ,
        parameter ALU_JALR              = 5'b01111      ,
        parameter ALU_BEQ               = 5'b10000      ,
        parameter ALU_BNE               = 5'b10001      ,
        parameter ALU_BLT               = 5'b10010      ,
        parameter ALU_BGE               = 5'b10011      ,
        parameter ALU_BLTU              = 5'b10100      ,
        parameter ALU_BGEU              = 5'b10101      
    ) (
        input   [DATA_WIDTH - 1  : 0]   ALU_IN1           ,
        input   [DATA_WIDTH - 1  : 0]   ALU_IN2           ,
        input   [DATA_WIDTH - 1  : 0]   PC_IN             ,
        input   [4               : 0]   ALU_INSTRUCTION   ,
        output  [DATA_WIDTH - 1  : 0]   ALU_OUT           ,
        output                          BRANCH_TAKEN
    );
   
    reg  [DATA_WIDTH - 1  : 0]  alu_out_reg         ;
    reg                         branch_taken_reg    ;
    
    always@(*)
    begin
        case(ALU_INSTRUCTION)
            ALU_NOP:
            begin
                alu_out_reg         = 32'b0;
                branch_taken_reg    = LOW;
            end
            ALU_ADD:
            begin
                alu_out_reg         = $signed(ALU_IN1) + $signed(ALU_IN2);
                branch_taken_reg    = LOW;
            end
            ALU_SUB:
            begin
                alu_out_reg         = $signed(ALU_IN1) - $signed(ALU_IN2);
                branch_taken_reg    = LOW;
            end
            ALU_SLL:
            begin
                alu_out_reg         = ALU_IN1 << ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_SLT:
            begin
                if(ALU_IN1 < ALU_IN2)
                begin
                    alu_out_reg         = 32'b1;
                end
                else
                begin
                    alu_out_reg         = 32'b0;
                end
                branch_taken_reg    = LOW;
            end
            ALU_SLTU:
            begin
                if($signed(ALU_IN1) < $signed(ALU_IN2))
                begin
                    alu_out_reg         = 32'b1;
                end
                else
                begin
                    alu_out_reg         = 32'b0;
                end
                branch_taken_reg    = LOW;
            end
            ALU_XOR:
            begin
                alu_out_reg         = ALU_IN1 ^ ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_SRL:
            begin
                alu_out_reg         = ALU_IN1 >> ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_SRA:
            begin
                alu_out_reg         = ALU_IN1 >>> ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_OR:
            begin
                alu_out_reg         = ALU_IN1 | ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_AND:
            begin
                alu_out_reg         = ALU_IN1 & ALU_IN2;
                branch_taken_reg    = LOW;
            end
            ALU_SLLI:
            begin
                alu_out_reg         = ALU_IN1 << ALU_IN2[4:0];
                branch_taken_reg    = LOW;
            end
            ALU_SRLI:
            begin
                alu_out_reg         = ALU_IN1 >> ALU_IN2[4:0];
                branch_taken_reg    = LOW;
            end
            ALU_SRAI:
            begin
                alu_out_reg         = ALU_IN1 >>> ALU_IN2[4:0];
                branch_taken_reg    = LOW;
            end
            ALU_JAL:
            begin
                alu_out_reg         = ALU_IN1 + 4;
                branch_taken_reg    = LOW;
            end
            ALU_JALR:
            begin
                alu_out_reg         = PC_IN + 4;
                branch_taken_reg    = LOW;
            end
            ALU_BEQ:
            begin
                alu_out_reg         = 32'b0;
                if(ALU_IN1 == ALU_IN2)
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end
            ALU_BNE:
            begin
                alu_out_reg         = 32'b0;
                if(ALU_IN1 != ALU_IN2)
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end
            ALU_BLT:
            begin
                alu_out_reg         = 32'b0;
                if($signed(ALU_IN1) < $signed(ALU_IN2))
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end
            ALU_BGE:
            begin
                alu_out_reg         = 32'b0;
                if($signed(ALU_IN1) >= $signed(ALU_IN2))
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end
            ALU_BLTU:
            begin
                alu_out_reg         = 32'b0;
                if(ALU_IN1 == ALU_IN2)
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end
            ALU_BGEU:
            begin
                alu_out_reg         = 32'b0;
                if(ALU_IN1 >= ALU_IN2)
                begin
                    branch_taken_reg    = HIGH;
                end
                else
                begin
                    branch_taken_reg    = LOW;
                end
            end      
            default:
            begin
                alu_out_reg         = 32'b0;
                branch_taken_reg    = LOW;
            end
        endcase
    end
    
    assign  ALU_OUT         = alu_out_reg       ;
    assign  BRANCH_TAKEN    = branch_taken_reg  ;
    
endmodule
