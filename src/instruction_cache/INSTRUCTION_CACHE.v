`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:12:26 AM
// Design Name: 
// Module Name:     INSTRUCTION_CACHE
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


module INSTRUCTION_CACHE #(
        parameter   ADDRESS_WIDTH           = 32        ,
        parameter   DATA_WIDTH              = 32        ,
        parameter   L2_BUS_WIDTH            = 32        ,
        
        parameter   HIGH                    = 1'b1      ,
        parameter   LOW                     = 1'b0
    ) (
        input                                   CLK                         ,
        input                                   STALL_INSTRUCTION_CACHE     ,
        input   [ADDRESS_WIDTH - 1      : 0]    PC                          ,
        input                                   PC_VALID                    ,
        output  [ADDRESS_WIDTH - 1      : 0]    INSTRUCTION                 ,
        output                                  INSTRUCTION_CACHE_READY     ,
        
        // Transfer Address From L1 to L2 Cache 
        input                                   ADDRESS_TO_L2_READY_INS     ,
        output                                  ADDRESS_TO_L2_VALID_INS     ,      
        output   [ADDRESS_WIDTH - 2 - 1 : 0]    ADDRESS_TO_L2_INS           ,
                
        // Transfer Data From L2 to L1 Cache   
        output                                  DATA_FROM_L2_READY_INS      ,
        input                                   DATA_FROM_L2_VALID_INS      ,
        input    [L2_BUS_WIDTH   - 1    : 0]    DATA_FROM_L2_INS
    );
   
    //////////////////------ TEST CODE ------//////////////////
    
    reg                                     instruction_cache_ready_reg     ;
    reg                                     address_to_l2_valid_ins_reg     ;
    reg     [ADDRESS_WIDTH - 2 - 1   : 0]   address_to_l2_ins_reg           ;
    reg                                     data_from_l2_ready_ins_reg      ;
    reg     [DATA_WIDTH - 1          : 0]   instruction_reg                 ; 
    
    initial
    begin
        instruction_cache_ready_reg     = HIGH                              ;
        address_to_l2_valid_ins_reg     = LOW                               ;
        address_to_l2_ins_reg           = 30'b0                             ;
        data_from_l2_ready_ins_reg      = HIGH                              ;
        instruction_reg                 = 32'b0                             ;
    end    
    
    always@(*)
    begin 
        instruction_cache_ready_reg     = ~STALL_INSTRUCTION_CACHE          ;
    end                              
    
    always@(posedge CLK)
    begin
        if(STALL_INSTRUCTION_CACHE == LOW)
        begin
            if(PC_VALID == HIGH)
            begin
                address_to_l2_valid_ins_reg <= HIGH                             ;
                address_to_l2_ins_reg       <= PC[ADDRESS_WIDTH - 1      : 2]   ; 
            end
            if(DATA_FROM_L2_VALID_INS == HIGH)
            begin
                instruction_reg    <= DATA_FROM_L2_INS                          ;   
            end
        end
    end
  
    //////////////////------ TEST CODE ------//////////////////
    
    assign  INSTRUCTION_CACHE_READY     = instruction_cache_ready_reg       ;
    assign  ADDRESS_TO_L2_INS           = address_to_l2_ins_reg             ;
    assign  ADDRESS_TO_L2_VALID_INS     = address_to_l2_valid_ins_reg       ;
    assign  DATA_FROM_L2_READY_INS      = data_from_l2_ready_ins_reg        ;
    assign  INSTRUCTION                 = instruction_reg                   ;
   
endmodule
