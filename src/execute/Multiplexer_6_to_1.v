`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/05/2017 10:24:09 PM
// Design Name: 
// Module Name:     Multiplexer_6_to_1
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


module Multiplexer_6_to_1 #(
        parameter BUS_WIDTH     = 32       
    ) (
        input   [BUS_WIDTH - 1 : 0] IN1     ,
        input   [BUS_WIDTH - 1 : 0] IN2     ,
        input   [BUS_WIDTH - 1 : 0] IN3     ,
        input   [BUS_WIDTH - 1 : 0] IN4     ,
        input   [BUS_WIDTH - 1 : 0] IN5     ,
        input   [BUS_WIDTH - 1 : 0] IN6     ,
        input   [2             : 0] SELECT  ,
        output  [BUS_WIDTH - 1 : 0] OUT     
    );
    
    reg [BUS_WIDTH - 1 : 0] OUT_REG;
    
    always@(*)
    begin
        case(SELECT)
            3'b000:
            begin
                OUT_REG = IN1;
            end 
            3'b001:
            begin
                OUT_REG = IN2;
            end 
            3'b010:
            begin
                OUT_REG = IN3;
            end 
            3'b011:
            begin
                OUT_REG = IN4;
            end 
            3'b100:
            begin
                OUT_REG = IN5;
            end 
            3'b101:
            begin
                OUT_REG = IN6;
            end 
        endcase
    end
    
   assign OUT = OUT_REG;
    
endmodule
