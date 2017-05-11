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
        parameter R_FORMAT      = 3'b000 ,
        parameter I_FORMAT      = 3'b001 ,
        parameter S_FORMAT      = 3'b010 ,
        parameter U_FORMAT      = 3'b011 ,
        parameter SB_FORMAT     = 3'b100 ,
        parameter UJ_FORMAT     = 3'b101 
    ) (
        input   [24 : 0] IMM_INPUT  ,
        input   [2  : 0] IMM_FORMAT ,
        output  [31 : 0] IMM_OUTPUT  
    );
    
    reg [31 : 0] IMM_OUTPUT_REG;
    
    always@(*)
    begin
        case(IMM_FORMAT)
            R_FORMAT:
            begin
                IMM_OUTPUT_REG = 32'b0;
            end
            I_FORMAT:
            begin 
                if(IMM_INPUT[24] == 1'b1)
                    IMM_OUTPUT_REG = {20'b11111111111111111111,IMM_INPUT[24:13]};
                else
                    IMM_OUTPUT_REG = {20'b0,IMM_INPUT[24:13]};
            end
            S_FORMAT:
            begin 
                if(IMM_INPUT[24]==1'b1)
                    IMM_OUTPUT_REG = {20'b11111111111111111111,IMM_INPUT[24:18],IMM_INPUT[4:0]};
                else
                    IMM_OUTPUT_REG = {20'b0,IMM_INPUT[24:18],IMM_INPUT[4:0]};
            end
            U_FORMAT:   
            begin    
                IMM_OUTPUT_REG = {IMM_INPUT[24:5],12'b0};
            end
            SB_FORMAT:                
            begin
                if(IMM_INPUT[24]==1'b1)
                    IMM_OUTPUT_REG = {20'b11111111111111111111,IMM_INPUT[0],IMM_INPUT[23:18],IMM_INPUT[4:1],1'b0};
                else
                    IMM_OUTPUT_REG = {20'b0,IMM_INPUT[0],IMM_INPUT[23:18],IMM_INPUT[4:1],1'b0};
            end
            UJ_FORMAT:            
            begin
                if(IMM_INPUT[24]==1'b1)
                    IMM_OUTPUT_REG = {12'b111111111111,IMM_INPUT[12:5],IMM_INPUT[13],IMM_INPUT[23:18],IMM_INPUT[17:14],1'b0};
                else
                    IMM_OUTPUT_REG = {12'b0,IMM_INPUT[12:5],IMM_INPUT[13],IMM_INPUT[23:18],IMM_INPUT[17:14],1'b0};
            end
            default:
            begin
                IMM_OUTPUT_REG = 32'b0;
            end
        endcase
    end
    
    assign IMM_OUTPUT = IMM_OUTPUT_REG;
    
endmodule
