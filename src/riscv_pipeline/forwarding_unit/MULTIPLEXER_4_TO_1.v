`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/05/2017 10:24:09 PM
// Design Name: 
// Module Name:     MULTIPLEXER_4_TO_1
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


module MULTIPLEXER_4_TO_1 #(
        parameter BUS_WIDTH     = 32          
    ) (
        input   [BUS_WIDTH - 1 : 0] IN1     ,
        input   [BUS_WIDTH - 1 : 0] IN2     ,
        input   [BUS_WIDTH - 1 : 0] IN3     ,
        input   [BUS_WIDTH - 1 : 0] IN4     ,
        input   [1             : 0] SELECT  ,
        output  [BUS_WIDTH - 1 : 0] OUT     
    );
    
    reg [BUS_WIDTH - 1 : 0] out_reg;
    
    always@(*)
    begin
        case(SELECT)
            2'b00:
            begin
                out_reg = IN1;
            end 
            2'b01:
            begin
                out_reg = IN2;
            end 
            2'b10:
            begin
                out_reg = IN3;
            end 
            2'b11:
            begin
                out_reg = IN4;
            end 
        endcase
    end
    
   assign OUT = out_reg;
    
endmodule
