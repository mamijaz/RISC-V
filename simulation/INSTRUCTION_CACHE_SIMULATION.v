`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/09/2017 09:46:11 PM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE_SIMULATION
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


module INSTRUCTION_CACHE_SIMULATION();

    parameter   ADDRESS_WIDTH           = 32                                            ;
    parameter   BLOCK_WIDTH             = 512                                           ;
    parameter   BLOCK_ADDRESS_WIDTH     = 26                                            ;
    
    // Inputs
    reg                                     clk                                         ;
    reg                                     stall_instruction_cache                     ;
    reg     [ADDRESS_WIDTH - 1      : 0]    pc                                          ;
    reg                                     pc_valid                                    ;
    reg                                     address_to_l2_ready_instruction_cache       ;
    reg                                     data_from_l2_valid_instruction_cache        ;
    reg     [BLOCK_WIDTH   - 1      : 0]    data_from_l2_instruction_cache              ;
     
    // Outputs
    wire    [ADDRESS_WIDTH - 1      : 0]    instruction                                 ;
    wire                                    instruction_cache_ready                     ;
    wire                                    address_to_l2_valid_instruction_cache       ;      
    wire    [BLOCK_ADDRESS_WIDTH - 1: 0]    address_to_l2_instruction_cache             ;
    wire                                    data_from_l2_ready_instruction_cache        ;
     
    // Instantiate the Unit Under Test (UUT)
    INSTRUCTION_CACHE uut(
        .CLK(clk),
        .STALL_INSTRUCTION_CACHE(stall_instruction_cache),
        .PC(pc),
        .PC_VALID(pc_valid),
        .INSTRUCTION(instruction),
        .INSTRUCTION_CACHE_READY(instruction_cache_ready),
        .ADDRESS_TO_L2_READY_INSTRUCTION_CACHE(address_to_l2_ready_instruction_cache),
        .ADDRESS_TO_L2_VALID_INSTRUCTION_CACHE(address_to_l2_valid_instruction_cache),      
        .ADDRESS_TO_L2_INSTRUCTION_CACHE(address_to_l2_instruction_cache), 
        .DATA_FROM_L2_READY_INSTRUCTION_CACHE(data_from_l2_ready_instruction_cache),
        .DATA_FROM_L2_VALID_INSTRUCTION_CACHE(data_from_l2_valid_instruction_cache),
        .DATA_FROM_L2_INSTRUCTION_CACHE(data_from_l2_instruction_cache)
        );
        
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
        pc                       = 32'b0 ;
        pc_valid                 = 1'b1 ;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        pc_valid                 = 1'b0 ;
        #100;
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        #100;
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        #100;
        clk                      = 1'b1 ;
    end

endmodule
