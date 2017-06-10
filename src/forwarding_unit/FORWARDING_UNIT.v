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
        parameter   DATA_WIDTH              = 32            ,
        parameter   REG_ADD_WIDTH           = 5             ,
        parameter   MUX_SEL_WIDTH           = 2             ,
        
        parameter   SELECT_DIRECT_RS1       = 1'b0          ,
        parameter   SELECT_RS1_FORWARDED    = 1'b1          ,
        parameter   SELECT_DIRECT_RS2       = 1'b0          ,
        parameter   SELECT_RS2_FORWARDED    = 1'b1          ,
        
        parameter   FORWARDING_RD_DM1       = 2'b00         ,
        parameter   FORWARDING_RD_DM2       = 2'b01         ,
        parameter   FORWARDING_RD_DM3       = 2'b10         ,
        parameter   FORWARDING_RD_WB        = 2'b11         ,
        
        parameter   HIGH                    = 1'b1          ,
        parameter   LOW                     = 1'b0
    ) (
        input                               CLK                             ,
        input                               STALL_EXECUTION_STAGE           ,
        input   [REG_ADD_WIDTH - 1  : 0]    RS1_ADDRESS_EXECUTION           ,
        input   [DATA_WIDTH - 1     : 0]    RS1_DATA_EXECUTION              ,
        input   [REG_ADD_WIDTH - 1  : 0]    RS2_ADDRESS_EXECUTION           ,
        input   [DATA_WIDTH - 1     : 0]    RS2_DATA_EXECUTION              ,
        input   [REG_ADD_WIDTH - 1  : 0]    RD_ADDRESS_DM1                  ,
        input                               RD_WRITE_ENABLE_DM1             ,
        input   [DATA_WIDTH - 1     : 0]    RD_DATA_DM1                     ,
        input   [REG_ADD_WIDTH - 1  : 0]    RD_ADDRESS_DM2                  ,
        input                               RD_WRITE_ENABLE_DM2             ,
        input   [DATA_WIDTH - 1     : 0]    RD_DATA_DM2                     ,
        input   [REG_ADD_WIDTH - 1  : 0]    RD_ADDRESS_DM3                  ,
        input                               RD_WRITE_ENABLE_DM3             ,
        input   [DATA_WIDTH - 1     : 0]    RD_DATA_DM3                     ,
        input   [REG_ADD_WIDTH - 1  : 0]    RD_ADDRESS_WB                   ,
        input                               RD_WRITE_ENABLE_WB              ,
        input   [DATA_WIDTH - 1     : 0]    RD_DATA_WB                      ,
        output  [DATA_WIDTH - 1     : 0]    RS1_DATA                        ,
        output  [DATA_WIDTH - 1     : 0]    RS2_DATA
    );
    
    reg     [MUX_SEL_WIDTH - 1  : 0]    rs1_forward_select                  ;
    reg     [MUX_SEL_WIDTH - 1  : 0]    rs2_forward_select                  ;
    reg                                 rs1_forward_or_default_select       ;
    reg                                 rs2_forward_or_default_select       ;
    reg     [DATA_WIDTH - 1     : 0]    rs1_stall_forwarded                 ;
    reg     [DATA_WIDTH - 1     : 0]    rs2_stall_forwarded                 ;
    reg                                 rs1_stall_forwarded_select          ;
    reg                                 rs2_stall_forwarded_select          ;    
    
    wire    [DATA_WIDTH - 1     : 0]    rs1_forwarded                       ;
    wire    [DATA_WIDTH - 1     : 0]    rs2_forwarded                       ;
    wire    [DATA_WIDTH - 1     : 0]    rs1_none_stalled_condition          ;
    wire    [DATA_WIDTH - 1     : 0]    rs2_none_stalled_condition          ;
    
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
        .OUT(rs1_none_stalled_condition)
        );
        
    MULTIPLEXER_2_TO_1 rs1_stall_forward_or_default(
        .IN1(rs1_none_stalled_condition),
        .IN2(rs1_stall_forwarded),
        .SELECT(rs1_stall_forwarded_select),
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
        .OUT(rs2_none_stalled_condition)
        );
        
    MULTIPLEXER_2_TO_1 rs2_stall_forward_or_default(
        .IN1(rs2_none_stalled_condition),
        .IN2(rs2_stall_forwarded),
        .SELECT(rs2_stall_forwarded_select),
        .OUT(RS2_DATA)
        );
    
    always@(*) 
    begin 
        if((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM1) & (RD_WRITE_ENABLE_DM1 == HIGH))
        begin
            rs1_forward_select              = FORWARDING_RD_DM1     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM2) & (RD_WRITE_ENABLE_DM2 == HIGH))
        begin
            rs1_forward_select              = FORWARDING_RD_DM2     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if((RS1_ADDRESS_EXECUTION == RD_ADDRESS_DM3) & (RD_WRITE_ENABLE_DM3 == HIGH))
        begin
            rs1_forward_select              = FORWARDING_RD_DM3     ;
            rs1_forward_or_default_select   = SELECT_RS1_FORWARDED  ; 
        end
        else if((RS1_ADDRESS_EXECUTION == RD_ADDRESS_WB) & (RD_WRITE_ENABLE_WB == HIGH))
        begin
            rs1_forward_select              = FORWARDING_RD_WB      ;
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
        if((RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM1) & (RD_WRITE_ENABLE_DM1 == HIGH))
        begin
            rs2_forward_select              = FORWARDING_RD_DM1     ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if((RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM2) & (RD_WRITE_ENABLE_DM2 == HIGH))
        begin
            rs2_forward_select              = FORWARDING_RD_DM2     ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if((RS2_ADDRESS_EXECUTION == RD_ADDRESS_DM3) & (RD_WRITE_ENABLE_DM3 == HIGH))
        begin
            rs2_forward_select              = FORWARDING_RD_DM3     ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else if((RS2_ADDRESS_EXECUTION == RD_ADDRESS_WB) & (RD_WRITE_ENABLE_WB == HIGH))
        begin
            rs2_forward_select              = FORWARDING_RD_WB      ;
            rs2_forward_or_default_select   = SELECT_RS2_FORWARDED  ; 
        end
        else
        begin
            rs2_forward_select              = FORWARDING_RD_DM1     ;
            rs2_forward_or_default_select   = SELECT_DIRECT_RS2     ; 
        end
    end
    
    always@(posedge CLK)
    begin
        if(STALL_EXECUTION_STAGE == HIGH)
        begin
            if(((RS1_ADDRESS_EXECUTION == RD_ADDRESS_WB) & (RD_WRITE_ENABLE_WB == HIGH)) & (RS1_ADDRESS_EXECUTION != RD_ADDRESS_DM1) & (RS1_ADDRESS_EXECUTION != RD_ADDRESS_DM2) & (RS1_ADDRESS_EXECUTION != RD_ADDRESS_DM3))
            begin
                rs1_stall_forwarded         <= RD_DATA_WB           ;
                rs1_stall_forwarded_select  <= HIGH                 ;
            end
            if(((RS2_ADDRESS_EXECUTION == RD_ADDRESS_WB) & (RD_WRITE_ENABLE_WB == HIGH)) & (RS2_ADDRESS_EXECUTION != RD_ADDRESS_DM1) & (RS2_ADDRESS_EXECUTION != RD_ADDRESS_DM2) & (RS2_ADDRESS_EXECUTION != RD_ADDRESS_DM3))
            begin
                rs2_stall_forwarded         <= RD_DATA_WB           ;
                rs2_stall_forwarded_select  <= HIGH                 ;
            end
        end
        else
        begin
            rs1_stall_forwarded             <= 32'b0                ;
            rs1_stall_forwarded_select      <= LOW                  ;
            rs2_stall_forwarded             <= 32'b0                ;
            rs2_stall_forwarded_select      <= LOW                  ;
        end
    end
     
endmodule
