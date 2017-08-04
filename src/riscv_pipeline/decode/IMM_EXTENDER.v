`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/05/2017 10:52:10 AM
// Design Name: 
// Module Name:     IMM_EXTENDER
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


module IMM_EXTENDER #(
        parameter   IMM_MAX_IN_WIDTH        = 25                ,
        parameter   DATA_WIDTH              = 32                ,
        parameter   IMM_FORMAT_SELECT       = 3                 ,
    
        parameter   R_FORMAT                = 3'b000            ,
        parameter   I_FORMAT                = 3'b001            ,
        parameter   S_FORMAT                = 3'b010            ,
        parameter   U_FORMAT                = 3'b011            ,
        parameter   SB_FORMAT               = 3'b100            ,
        parameter   UJ_FORMAT               = 3'b101 
    ) (
        input   [IMM_MAX_IN_WIDTH - 1   : 0]    IMM_INPUT       ,
        input   [IMM_FORMAT_SELECT - 1  : 0]    IMM_FORMAT      ,
        output  [DATA_WIDTH - 1         : 0]    IMM_OUTPUT  
    );
    
    reg     [DATA_WIDTH - 1     : 0]    imm_output_reg          ;
    
    always@(*)
    begin
        case(IMM_FORMAT)
            R_FORMAT:
            begin
                imm_output_reg = 32'b0;
            end
            I_FORMAT:
            begin 
                if(IMM_INPUT[24] == 1'b1)
                    imm_output_reg = {20'b11111111111111111111,IMM_INPUT[24:13]};
                else
                    imm_output_reg = {20'b0,IMM_INPUT[24:13]};
            end
            S_FORMAT:
            begin 
                if(IMM_INPUT[24] == 1'b1)
                    imm_output_reg = {20'b11111111111111111111,IMM_INPUT[24:18],IMM_INPUT[4:0]};
                else
                    imm_output_reg = {20'b0,IMM_INPUT[24:18],IMM_INPUT[4:0]};
            end
            U_FORMAT:   
            begin    
                imm_output_reg = {IMM_INPUT[24:5],12'b0};
            end
            SB_FORMAT:                
            begin
                if(IMM_INPUT[24] == 1'b1)
                    imm_output_reg = {20'b11111111111111111111,IMM_INPUT[0],IMM_INPUT[23:18],IMM_INPUT[4:1],1'b0};
                else
                    imm_output_reg = {20'b0,IMM_INPUT[0],IMM_INPUT[23:18],IMM_INPUT[4:1],1'b0};
            end
            UJ_FORMAT:            
            begin
                if(IMM_INPUT[24] == 1'b1)
                    imm_output_reg = {12'b111111111111,IMM_INPUT[12:5],IMM_INPUT[13],IMM_INPUT[23:18],IMM_INPUT[17:14],1'b0};
                else
                    imm_output_reg = {12'b0,IMM_INPUT[12:5],IMM_INPUT[13],IMM_INPUT[23:18],IMM_INPUT[17:14],1'b0};
            end
            default:
            begin
                imm_output_reg = 32'b0;
            end
        endcase
    end
    
    assign IMM_OUTPUT = imm_output_reg;
    
endmodule
