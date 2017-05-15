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
        parameter HIGH  = 1'b1
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
        if(ALU_INPUT_1_SELECT != HIGH)
        begin
            if(RD_ADDRESS_WB == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = 3'b101;
            end
            else if (RD_ADDRESS_DM3 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = 3'b100;
            end
            else if (RD_ADDRESS_DM2 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = 3'b011;
            end
            else if (RD_ADDRESS_DM1 == RS1_ADDRESS)
            begin
                alu_input_mux_1_select_reg = 3'b010;
            end
            else
            begin
                alu_input_mux_1_select_reg = 3'b000;
            end
        end
        else
        begin
            alu_input_mux_1_select_reg = 3'b001;
        end
        
        if(ALU_INPUT_2_SELECT != HIGH)
        begin
            if(RD_ADDRESS_WB == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = 3'b101;
            end
            else if (RD_ADDRESS_DM3 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = 3'b100;
            end
            else if (RD_ADDRESS_DM2 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = 3'b011;
            end
            else if (RD_ADDRESS_DM1 == RS2_ADDRESS)
            begin
                alu_input_mux_2_select_reg = 3'b010;
            end
            else
            begin
                alu_input_mux_2_select_reg = 3'b000;
            end
        end
        else
        begin
            alu_input_mux_2_select_reg = 3'b001;
        end
    end
    
    assign ALU_INPUT_MUX_1_SELECT   = alu_input_mux_1_select_reg    ;
    assign ALU_INPUT_MUX_2_SELECT   = alu_input_mux_2_select_reg    ;
     
endmodule
