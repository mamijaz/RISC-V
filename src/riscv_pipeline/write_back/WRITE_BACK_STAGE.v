`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:16:53 AM
// Design Name: 
// Module Name:     WRITE_BACK_STAGE
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


module WRITE_BACK_STAGE #(
        parameter   DATA_WIDTH              = 32        ,
        parameter   HIGH                    = 1'b1  
    ) (
        input   [DATA_WIDTH - 1     : 0]    ALU_OUT_IN                  ,
        input   [DATA_WIDTH - 1     : 0]    DATA_CACHE_OUT_DATA         ,
        input                               WRITE_BACK_MUX_SELECT_IN    ,
        output  [DATA_WIDTH - 1     : 0]    WRITE_BACK_MUX_OUT         
    );
    
    MULTIPLEXER_2_TO_1 write_back_mux(
        .IN1(ALU_OUT_IN),
        .IN2(DATA_CACHE_OUT_DATA),
        .SELECT(WRITE_BACK_MUX_SELECT_IN),
        .OUT(WRITE_BACK_MUX_OUT) 
        );
    
endmodule
