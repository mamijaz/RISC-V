`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/10/2017 10:01:02 AM
// Design Name: 
// Module Name:     ENCODER_FOR_2_WAY_ASSOCIATIVE_CACHE
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


module ENCODER_FOR_2_WAY_ASSOCIATIVE_CACHE #(
        parameter   HIGH    = 1'b1  ,
        parameter   LOW     = 1'b0
    ) (
        input       IN1             ,
        input       IN2             ,
        output      OUT             
    );
    
    reg     out_reg                 ;
    
    always@(*)
    begin
        if((IN1 == HIGH) & (IN2 == LOW))
        begin
            out_reg = LOW;
        end
        else 
        begin
            out_reg = HIGH;
        end
    end 
    
    assign OUT = out_reg;
    
endmodule
