`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/15/2017 01:21:09 AM
// Design Name: 
// Module Name:     VICTIM_CACHE_SIMULATION
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


module VICTIM_CACHE_SIMULATION();

    parameter   BLOCK_WIDTH             = 512                           ;
    parameter   TAG_WIDTH               = 26                            ;
    parameter   MEMORY_LATENCY    	    = "HIGH_LATENCY"                ;
    
    localparam  MEMORY_DEPTH            = 4                             ;
    localparam  ADDRESS_WIDTH           = $clog2(MEMORY_DEPTH-1)        ;    
    
    // Inputs
    reg                                clk                              ;
    reg    [TAG_WIDTH - 1      : 0]    write_tag_address                ;   
    reg    [BLOCK_WIDTH - 1    : 0]    write_data                       ;
    reg                                write_enable                     ;
    reg    [TAG_WIDTH - 1      : 0]    read_tag_address                 ;                                         
    reg                                read_enble                       ;
    
    // Outputs
    wire                               read_hit                         ;                                                    
    wire   [BLOCK_WIDTH - 1    : 0]    read_data                        ;
    
    // Instantiate the Unit Under Test (UUT)
    VICTIM_CACHE #(
        .BLOCK_WIDTH(BLOCK_WIDTH),
        .TAG_WIDTH(TAG_WIDTH),
        .MEMORY_LATENCY(MEMORY_LATENCY)
    )uut(
        .CLK(clk),
        .WRITE_TAG_ADDRESS(write_tag_address),   
        .WRITE_DATA(write_data),
        .WRITE_ENABLE(write_enable),
        .READ_TAG_ADDRESS(read_tag_address),                                         
        .READ_ENBLE(read_enble), 
        .READ_HIT(read_hit),                                                    
        .READ_DATA(read_data)           
        );
        
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
        write_tag_address        = 26'b1 ;
        write_data               = 512'b1 ;
        write_enable             = 1'b1 ;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        clk                      = 1'b1 ;
        #100;
        write_tag_address        = 26'b0 ;
        write_data               = 512'b0 ;
        write_enable             = 1'b0 ;
        clk                      = 1'b0 ;
        read_tag_address         = 26'b1 ;
        read_enble               = 1'b1 ;
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
