`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/05/2017 10:24:09 PM
// Design Name: 
// Module Name:     MULTIPLEXER_6_TO_1
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


module MULTIPLEXER_6_TO_1 #(
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
    
    reg [BUS_WIDTH - 1 : 0] out_reg;
    
    always@(*)
    begin
        case(SELECT)
            3'b000:
            begin
                out_reg = IN1;
            end 
            3'b001:
            begin
                out_reg = IN2;
            end 
            3'b010:
            begin
                out_reg = IN3;
            end 
            3'b011:
            begin
                out_reg = IN4;
            end 
            3'b100:
            begin
                out_reg = IN5;
            end 
            3'b101:
            begin
                out_reg = IN6;
            end 
			default:
            begin
                out_reg = 32'b0;
            end
        endcase
    end
    
   assign OUT = out_reg;
    
endmodule
