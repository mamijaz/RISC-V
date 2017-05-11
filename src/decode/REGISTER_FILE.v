`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/05/2017 09:31:01 AM
// Design Name: 
// Module Name:     REGISTER_FILE
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


module REGISTER_FILE #(
        parameter REGISTER_WIDTH     = 32       ,
        parameter REGISTER_DEPTH     = 32       ,
        parameter STACK_POINTER_ADD  = 2        ,
        parameter STACK_POINTER_VAL  = 32'd1024  
    ) (
        input                                      CLK         ,
        input  [$clog2(REGISTER_DEPTH) - 1 : 0]    RS1_ADDRESS ,
        input  [$clog2(REGISTER_DEPTH) - 1 : 0]    RS2_ADDRESS ,
        input  [$clog2(REGISTER_DEPTH) - 1 : 0]    RD_ADDRESS  ,
        input  [REGISTER_WIDTH - 1         : 0]    RD_DATA     ,
        input                                      RD_WRITE_EN ,
        output [REGISTER_WIDTH - 1         : 0]    RS1_DATA    ,
        output [REGISTER_WIDTH - 1         : 0]    RS2_DATA    
    );
    
    reg [REGISTER_WIDTH - 1         : 0]    REGISTER [REGISTER_DEPTH - 1 : 0]    ;
    reg [REGISTER_WIDTH - 1         : 0]    RS1_DATA_REG                         ;
    reg [REGISTER_WIDTH - 1         : 0]    RS2_DATA_REG                         ;
    
    integer i;
    initial
    begin
        for(i = 0 ; i < REGISTER_DEPTH ; i = i + 1)
        begin
            if(i == STACK_POINTER_ADD)
                REGISTER[ i ] = STACK_POINTER_VAL;
            else
                REGISTER[ i ] = 32'd0;
        end
    end
    
    always@(*)
    begin
            RS1_DATA_REG = REGISTER [ RS1_ADDRESS ];
            RS2_DATA_REG = REGISTER [ RS2_ADDRESS ];
    end
    
    always@(negedge CLK)
    begin
        if((RD_WRITE_EN == 1'b1) & (RD_ADDRESS != 5'b0))
        begin
           REGISTER [RD_ADDRESS] <= RD_DATA;
        end
    end
    
    assign RS1_DATA = RS1_DATA_REG;
    assign RS2_DATA = RS2_DATA_REG;
    
endmodule
