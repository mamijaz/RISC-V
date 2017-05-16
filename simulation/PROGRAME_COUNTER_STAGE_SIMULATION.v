`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/16/2017 09:11:44 AM
// Design Name: 
// Module Name:     PROGRAME_COUNTER_STAGE_SIMULATION
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


module PROGRAME_COUNTER_STAGE_SIMULATION;

    // Inputs
    reg            clk                        ;
    reg            stall_execution_stage      ;
    reg  [4  : 0]  alu_instruction            ;
    reg            branch_taken               ;
    reg  [31 : 0]  pc_execution               ;
    reg  [31 : 0]  rs1_data                   ;
    reg  [31 : 0]  imm_input                  ;
    reg  [31 : 0]  pc_decoding                ;
   
    // Outputs
    wire [31 : 0]  pc                         ;
    wire           clear_decoding_stage       ;
    wire           clear_execution_stage      ;
   
    // Instantiate the Unit Under Test (UUT)
    PROGRAME_COUNTER_STAGE uut(
        .CLK(clk),
        .STALL_EXECUTION_STAGE(stall_execution_stage),
        .ALU_INSTRUCTION(alu_instruction),
        .BRANCH_TAKEN(branch_taken),
        .PC_EXECUTION(pc_execution),
        .RS1_DATA(rs1_data),
        .IMM_INPUT(imm_input),
        .PC_DECODING(pc_decoding),
        .PC(pc),
        .CLEAR_DECODING_STAGE(clear_decoding_stage),
        .CLEAR_EXECUTION_STAGE(clear_execution_stage)
        );
   
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
        stall_execution_stage    = 1'b0 ;
        alu_instruction          = 5'b0 ;
        branch_taken             = 1'b0 ;
        pc_execution             = 32'b0 ;
        rs1_data                 = 32'b0 ;
        imm_input                = 32'b0 ;
        pc_decoding              = 32'b0 ;

        // Wait 100 ns for global reset to finish
        #100;
       
        // Add stimulus here
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        #100;
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;

    end
   
endmodule
