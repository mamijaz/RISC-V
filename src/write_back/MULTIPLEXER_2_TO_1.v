`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/06/2017 08:43:21 AM
// Design Name: 
// Module Name:     MULTIPLEXER_2_TO_1
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


module MULTIPLEXER_2_TO_1 #(
        parameter BUS_WIDTH     = 32       
    ) (
        input   [BUS_WIDTH - 1 : 0] IN1     ,
        input   [BUS_WIDTH - 1 : 0] IN2     ,
        input                       SELECT  ,
        output  [BUS_WIDTH - 1 : 0] OUT     
    );
    
    reg [BUS_WIDTH - 1 : 0] out_reg;
        
    always@(*)
    begin
        case(SELECT)
            1'b0:
            begin
                out_reg = IN1;
            end
            1'b1:
            begin
                out_reg = IN2;
            end
        endcase
    end 
    
    assign OUT = out_reg;
    
endmodule
