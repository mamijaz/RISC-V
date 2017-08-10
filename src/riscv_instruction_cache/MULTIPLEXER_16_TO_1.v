`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/10/2017 09:26:11 AM
// Design Name: 
// Module Name:     MULTIPLEXER_16_TO_1
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


module MULTIPLEXER_16_TO_1 #(
        parameter BUS_WIDTH     = 32
    ) (
        input   [BUS_WIDTH - 1 : 0] IN1     ,
        input   [BUS_WIDTH - 1 : 0] IN2     ,
        input   [BUS_WIDTH - 1 : 0] IN3     ,
        input   [BUS_WIDTH - 1 : 0] IN4     ,
        input   [BUS_WIDTH - 1 : 0] IN5     ,
        input   [BUS_WIDTH - 1 : 0] IN6     ,
        input   [BUS_WIDTH - 1 : 0] IN7     ,
        input   [BUS_WIDTH - 1 : 0] IN8     ,
        input   [BUS_WIDTH - 1 : 0] IN9     ,
        input   [BUS_WIDTH - 1 : 0] IN10    ,
        input   [BUS_WIDTH - 1 : 0] IN11    ,
        input   [BUS_WIDTH - 1 : 0] IN12    ,
        input   [BUS_WIDTH - 1 : 0] IN13    ,
        input   [BUS_WIDTH - 1 : 0] IN14    ,
        input   [BUS_WIDTH - 1 : 0] IN15    ,
        input   [BUS_WIDTH - 1 : 0] IN16    ,
        input   [3             : 0] SELECT  ,
        output  [BUS_WIDTH - 1 : 0] OUT 
    );
    
    reg [BUS_WIDTH - 1 : 0] out_reg;
            
    always@(*)
    begin
        case(SELECT)
            4'b0000:
            begin
                out_reg = IN1   ;
            end
            4'b0001:
            begin
                out_reg = IN2   ;
            end
            4'b0010:
            begin
                out_reg = IN3   ;
            end
            4'b0011:
            begin
                out_reg = IN4   ;
            end
            4'b0100:
            begin
                out_reg = IN5   ;
            end
            4'b0101:
            begin
                out_reg = IN6   ;
            end
            4'b0110:
            begin
                out_reg = IN7   ;
            end
            4'b0111:
            begin
                out_reg = IN8   ;
            end
            4'b1000:
            begin
                out_reg = IN9   ;
            end
            4'b1001:
            begin
                out_reg = IN10  ;
            end
            4'b1010:
            begin
                out_reg = IN11  ;
            end
            4'b1011:
            begin
                out_reg = IN12  ;
            end
            4'b1100:
            begin
                out_reg = IN13  ;
            end
            4'b1101:
            begin
                out_reg = IN14  ;
            end
            4'b1110:
            begin
                out_reg = IN15  ;
            end
            4'b1111:
            begin
                out_reg = IN16  ;
            end
        endcase
    end 
    
    assign OUT = out_reg;
    
endmodule
