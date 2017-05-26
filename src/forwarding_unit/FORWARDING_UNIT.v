`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/15/2017 11:04:33 AM
// Design Name: 
// Module Name:     FORWARDING_UNIT
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


module FORWARDING_UNIT #(
        parameter SELECT_DIRECT_RS1     = 1'b0          ,
        parameter SELECT_RS1_FORWARDED  = 1'b1          ,
        parameter SELECT_DIRECT_RS2     = 1'b0          ,
        parameter SELECT_RS2_FORWARDED  = 1'b1          ,
        
        parameter FORWARDING_RD_DM1     = 2'b00         ,
        parameter FORWARDING_RD_DM2     = 2'b01         ,
        parameter FORWARDING_RD_DM3     = 2'b10         ,
        parameter FORWARDING_RD_WB      = 2'b11        
    ) (
        input   [4  : 0] RS1_ADDRESS_EXECUTION          ,
        input   [31 : 0] RS1_DATA_EXECUTION             ,
        input   [4  : 0] RS2_ADDRESS_EXECUTION          ,
        input   [31 : 0] RS2_DATA_EXECUTION             ,
        input   [4  : 0] RD_ADDRESS_DM1                 ,
        input   [31 : 0] RD_DATA_DM1                    ,
        input   [4  : 0] RD_ADDRESS_DM2                 ,
        input   [31 : 0] RD_DATA_DM2                    ,
        input   [4  : 0] RD_ADDRESS_DM3                 ,
        input   [31 : 0] RD_DATA_DM3                    ,
        input   [4  : 0] RD_ADDRESS_WB                  ,
        input   [31 : 0] RD_DATA_WB                     ,
        output  [31 : 0] RS1_DATA                       ,
        output  [31 : 0] RS2_DATA
    );
    
    reg   [1  : 0] rs1_forward_select                   ;
    reg   [1  : 0] rs2_forward_select                   ;
    reg            rs1_forward_or_default_select        ;
    reg            rs2_forward_or_default_select        ;
    
    wire  [31 : 0] rs1_forwarded                        ;
    wire  [31 : 0] rs2_forwarded                        ;
    
    MULTIPLEXER_4_TO_1 rs1_forward(
        .IN1(RD_DATA_DM1),
        .IN2(RD_DATA_DM2),
        .IN3(RD_DATA_DM3),
        .IN4(RD_DATA_WB),
        .SELECT(rs1_forward_select),
        .OUT(rs1_forwarded)
        );
    
    MULTIPLEXER_2_TO_1 rs1_forward_or_default(
        .IN1(RS1_DATA_EXECUTION),
        .IN2(rs1_forwarded),
        .SELECT(rs1_forward_or_default_select),
        .OUT(RS1_DATA)
        );
        
    MULTIPLEXER_4_TO_1 rs2_forward(
        .IN1(RD_DATA_DM1),
        .IN2(RD_DATA_DM2),
        .IN3(RD_DATA_DM3),
        .IN4(RD_DATA_WB),
        .SELECT(rs2_forward_select),
        .OUT(rs2_forwarded)
        );
        
    MULTIPLEXER_2_TO_1 rs2_forward_or_default(
        .IN1(RS2_DATA_EXECUTION),
        .IN2(rs2_forwarded),
        .SELECT(rs2_forward_or_default_select),
        .OUT(RS2_DATA)
        );
    
    always@(*) 
    begin 
        if(RS1_ADDRESS_EXECUTION == RD_ADDRESS_WB)
        begin
            rs1_forward_select              = FORWARDING_RD_WB      ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if(RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM3)
        begin
            rs1_forward_select              = FORWARDING_RD_DM3     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if(RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM2)
        begin
            rs1_forward_select              = FORWARDING_RD_DM2     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if(RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM1)
        begin
            rs1_forward_select              = FORWARDING_RD_DM1     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else
        begin
            rs1_forward_select              = FORWARDING_RD_DM1     ;
            rs1_forward_or_default_select   = SELECT_DIRECT_RS1     ; 
        end
    end
    
    always@(*) 
    begin 
        if(RS2_ADDRESS_EXECUTION == RD_ADDRESS_WB)
        begin
            rs2_forward_select              = FORWARDING_RD_WB      ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if(RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM3)
        begin
            rs2_forward_select              = FORWARDING_RD_DM3     ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if(RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM2)
        begin
            rs2_forward_select              = FORWARDING_RD_DM2     ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if(RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM1)
        begin
            rs2_forward_select              = FORWARDING_RD_DM1     ;
            rs2_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else
        begin
            rs2_forward_select              = FORWARDING_RD_DM1     ;
            rs2_forward_or_default_select   = SELECT_DIRECT_RS2     ; 
        end
    end
     
endmodule
