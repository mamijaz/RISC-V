`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:14:19 AM
// Design Name: 
// Module Name:     INSTRUCTION_FETCH_STAGE
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


module INSTRUCTION_FETCH_STAGE #(
        parameter HIGH  = 1'b1  ,
        parameter LOW   = 1'b0
    ) (
        input            CLK                            ,
        input            STALL_INSTRUCTION_FETCH_STAGE  ,
        input            CLEAR_INSTRUCTION_FETCH_STAGE  ,
        input   [31 : 0] PC_IN                          ,
        output  [31 : 0] PC_OUT                 
    );
    
    reg   [31 : 0] pc_reg   ;
    
    always@(posedge CLK) 
    begin
        if(CLEAR_INSTRUCTION_FETCH_STAGE == LOW)
        begin
            if(STALL_INSTRUCTION_FETCH_STAGE == LOW) 
            begin
                pc_reg  <= PC_IN;
            end
        end
        else
        begin
            pc_reg  <= 32'b0;
        end
    end
    
    assign PC_OUT = pc_reg;
    
endmodule
