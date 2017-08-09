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

    parameter   ADDRESS_WIDTH           = 32                            ;
    parameter   L2_BUS_WIDTH            = 512                           ;
    
    // Inputs
    reg                                     clk                         ;
    reg                                     stall_instruction_cache     ;
    reg     [ADDRESS_WIDTH - 1      : 0]    pc                          ;
    reg                                     pc_valid                    ;
    reg                                     address_to_l2_ready_ins     ;
    reg                                     data_from_l2_valid_ins      ;
    reg     [L2_BUS_WIDTH   - 1     : 0]    data_from_l2_ins            ;
     
    // Outputs
    wire    [ADDRESS_WIDTH - 1      : 0]    instruction                 ;
    wire                                    instruction_cache_ready     ;
    wire                                    address_to_l2_valid_ins     ;      
    wire    [ADDRESS_WIDTH - 2 - 1  : 0]    address_to_l2_ins           ;
    wire                                    data_from_l2_ready_ins      ;
     
    // Instantiate the Unit Under Test (UUT)
    INSTRUCTION_CACHE uut(
        .CLK(clk),
        .STALL_INSTRUCTION_CACHE(stall_instruction_cache),
        .PC(pc),
        .PC_VALID(pc_valid),
        .INSTRUCTION(instruction),
        .INSTRUCTION_CACHE_READY(instruction_cache_ready),
        .ADDRESS_TO_L2_READY_INS(address_to_l2_ready_ins),
        .ADDRESS_TO_L2_VALID_INS(address_to_l2_valid_ins),      
        .ADDRESS_TO_L2_INS(address_to_l2_ins), 
        .DATA_FROM_L2_READY_INS(data_from_l2_ready_ins),
        .DATA_FROM_L2_VALID_INS(data_from_l2_valid_ins),
        .DATA_FROM_L2_INS(data_from_l2_ins)
        );
        
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
       

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        #100;
        clk                      = 1'b1 ;
    end

endmodule
