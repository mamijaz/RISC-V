`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     08/08/2017 06:03:02 PM
// Design Name: 
// Module Name:     DUAL_PORT_MEMORY_SIMULATION
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


module DUAL_PORT_MEMORY_SIMULATION();

    parameter MEMORY_WIDTH          = 512                               ;                       
    parameter MEMORY_DEPTH          = 512                               ;                      
    parameter MEMORY_LATENCY    	= "LOW_LATENCY"                	    ; 
    parameter INIT_FILE             = ""                                ;

    // Inputs
    reg                                     clk                         ;
    reg  [$clog2(MEMORY_DEPTH-1) - 1  : 0]  write_address               ;  
    reg  [MEMORY_WIDTH-1              : 0]  data_in                     ;
    reg                                     write_enable                ;
    reg  [$clog2(MEMORY_DEPTH-1)-1    : 0]  read_address                ;                                     
    reg                                     read_enble                  ;                                                        
   
    // Outputs
   
    wire [MEMORY_WIDTH-1              : 0]  data_out                    ;   
   
    // Instantiate the Unit Under Test (UUT)
    DUAL_PORT_MEMORY uut(
        .CLK(clk),
        .WRITE_ADDRESS(write_address),   
        .DATA_IN(data_in),
        .WRITE_ENABLE(write_enable),
        .READ_ADDRESS(read_address),                                         
        .READ_ENBLE(read_enble),                                                     
        .DATA_OUT(data_out)          
        );
   
    initial 
    begin
        // Initialize Inputs
        clk                      = 1'b0 ;
        write_address            = 9'b1 ;
        data_in                  = 512'b11 ; 
        write_enable             = 1'b1 ;  

        // Wait 100 ns for global reset to finish
        #100;
       
        // Add stimulus here            
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;
        write_address            = 9'b0 ;
        data_in                  = 512'b0 ; 
        write_enable             = 1'b0 ;
        read_address             = 9'b1 ;
        read_enble               = 1'b1 ;
        #100;
        clk                      = 1'b1 ;
        #100;
        clk                      = 1'b0 ;

    end
   
endmodule
