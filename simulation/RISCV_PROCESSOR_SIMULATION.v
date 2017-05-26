`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/26/2017 04:11:49 PM
// Design Name: 
// Module Name:     RISCV_PROCESSOR_SIMULATION
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


module RISCV_PROCESSOR_SIMULATION;

    // Inputs
    reg            clk                          ;
   
    // Outputs
    wire [31 : 0]  pc                           ;
    wire [31 : 0]  instruction                  ;
    wire [31 : 0]  alu_out                      ;
    wire [31 : 0]  rd_data_write_back           ;
   
    // Instantiate the Unit Under Test (UUT)
    RISCV_PROCESSOR uut(
        .CLK(clk),
        .PC(pc),
        .INSTRUCTION(instruction),
        .ALU_OUT(alu_out),
        .RD_DATA_WRITE_BACK(rd_data_write_back)                     
        );
   
    initial 
    begin
        // Initialize Inputs
        clk                             = 1'b0 ;

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
