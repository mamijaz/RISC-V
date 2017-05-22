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
        parameter SELECT_RS1            = 1'b0          ,
        parameter SELECT_PC             = 1'b1          ,
        parameter SELECT_RS2            = 1'b0          ,
        parameter SELECT_IMM            = 1'b1          ,
        
        parameter DIRECT_RS1            = 3'b000        ,
        parameter ALU_IN1_PC            = 3'b001        ,
        parameter DIRECT_RS2            = 3'b000        ,
        parameter ALU_IN1_IMM           = 3'b001        ,
        parameter FORWARDING_RD_DM1     = 3'b010        ,
        parameter FORWARDING_RD_DM2     = 3'b011        ,
        parameter FORWARDING_RD_DM3     = 3'b100        ,
        parameter FORWARDING_RD_WB      = 3'b101        
    ) (
        input            ALU_INPUT_1_SELECT     ,
        input            ALU_INPUT_2_SELECT     ,
        input   [4  : 0] RS1_ADDRESS            ,
        input   [4  : 0] RS2_ADDRESS            ,
        input   [4  : 0] RD_ADDRESS_DM1         ,
        input   [4  : 0] RD_ADDRESS_DM2         ,
        input   [4  : 0] RD_ADDRESS_DM3         ,
        input   [4  : 0] RD_ADDRESS_WB          ,
        output  [2  : 0] ALU_INPUT_MUX_1_SELECT ,
        output  [2  : 0] ALU_INPUT_MUX_2_SELECT 
    );
    
    reg  [2  : 0] alu_input_mux_1_select_reg    ;
    reg  [2  : 0] alu_input_mux_2_select_reg    ;
    
    always@(*) 
    begin 
        if(ALU_INPUT_1_SELECT == SELECT_RS1)
        begin
            if(RD_ADDRESS_WB == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = FORWARDING_RD_WB;
            end
            else if (RD_ADDRESS_DM3 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = FORWARDING_RD_DM3;
            end
            else if (RD_ADDRESS_DM2 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = FORWARDING_RD_DM2;
            end
            else if (RD_ADDRESS_DM1 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = FORWARDING_RD_DM1;
            end
            else
            begin
                alu_input_mux_1_select_reg = DIRECT_RS1;
            end
        end
        else
        begin
            alu_input_mux_1_select_reg = ALU_IN1_PC;
        end
        
        if(ALU_INPUT_2_SELECT == SELECT_RS2)
        begin
            if(RD_ADDRESS_WB == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = FORWARDING_RD_WB;
            end
            else if (RD_ADDRESS_DM3 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = FORWARDING_RD_DM3;
            end
            else if (RD_ADDRESS_DM2 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = FORWARDING_RD_DM2;
            end
            else if (RD_ADDRESS_DM1 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = FORWARDING_RD_DM1;
            end
            else
            begin
                alu_input_mux_2_select_reg = DIRECT_RS2;
            end
        end
        else
        begin
            alu_input_mux_2_select_reg = ALU_IN1_IMM;
        end
    end
    
    assign ALU_INPUT_MUX_1_SELECT   = alu_input_mux_1_select_reg    ;
    assign ALU_INPUT_MUX_2_SELECT   = alu_input_mux_2_select_reg    ;
     
endmodule
