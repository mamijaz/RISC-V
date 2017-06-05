`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/17/2017 08:13:16 AM
// Design Name: 
// Module Name:     DATA_CACHE
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


module DATA_CACHE #(
        parameter   ADDRESS_WIDTH           = 32        ,
        parameter   DATA_WIDTH              = 32        ,
        parameter   D_CACHE_LW_WIDTH        = 3         ,
        parameter   D_CACHE_SW_WIDTH        = 2         ,
        parameter   L2_BUS_WIDTH            = 32        ,       
        
        parameter DATA_CACHE_LOAD_NONE  = 3'b000        , 
        parameter DATA_CACHE_LOAD_B_S   = 3'b010        ,
        parameter DATA_CACHE_LOAD_B_U   = 3'b011        ,
        parameter DATA_CACHE_LOAD_H_S   = 3'b100        ,
        parameter DATA_CACHE_LOAD_H_U   = 3'b101        ,
        parameter DATA_CACHE_LOAD_W     = 3'b110        ,
        parameter DATA_CACHE_STORE_NONE = 2'b00         ,
        parameter DATA_CACHE_STORE_B    = 2'b01         ,
        parameter DATA_CACHE_STORE_H    = 2'b10         ,
        parameter DATA_CACHE_STORE_W    = 2'b11         ,
        
        parameter HIGH                  = 1'b1          ,
        parameter LOW                   = 1'b0
    ) (
        input                                   CLK                             ,
        input   [ADDRESS_WIDTH - 1      : 0]    DATA_CACHE_READ_ADDRESS         ,
        input   [D_CACHE_LW_WIDTH - 1   : 0]    DATA_CACHE_LOAD                 ,
        input   [ADDRESS_WIDTH - 1      : 0]    DATA_CACHE_WRITE_ADDRESS        ,
        input   [DATA_WIDTH - 1         : 0]    DATA_CACHE_WRITE_DATA           ,
        input   [D_CACHE_SW_WIDTH - 1   : 0]    DATA_CACHE_STORE                ,
        output                                  DATA_CACHE_READY                ,
        output  [DATA_WIDTH - 1         : 0]    DATA_CACHE_READ_DATA            ,
        
        // Write Data From L1 to L2 Cache
        input                                   WRITE_TO_L2_READY_DATA          ,
        output                                  WRITE_TO_L2_VALID_DATA          ,
        output  [ADDRESS_WIDTH - 2 - 1  : 0]    WRITE_ADDR_TO_L2_DATA           ,
        output  [L2_BUS_WIDTH   - 1     : 0]    DATA_TO_L2_DATA                 ,
        output                                  WRITE_CONTROL_TO_L2_DATA        ,
        input                                   WRITE_COMPLETE_DATA             ,
        
        // Read Data From L2 to L1 Cache
        input                                   READ_ADDR_TO_L2_READY_DATA      ,
        output                                  READ_ADDR_TO_L2_VALID_DATA      ,
        output  [ADDRESS_WIDTH - 2 - 1  : 0]    READ_ADDR_TO_L2_DATA            ,
        output                                  DATA_FROM_L2_READY_DATA         ,
        input                                   DATA_FROM_L2_VALID_DATA         ,
        input   [L2_BUS_WIDTH   - 1     : 0]    DATA_FROM_L2_DATA                  
    );
    
    //////////////////------ TEST CODE ------//////////////////
    
    reg                                     data_cache_ready_reg                ;
    reg                                     write_to_l2_valid_data_reg          ;
    reg     [ADDRESS_WIDTH - 2 - 1   : 0]   write_addr_to_l2_data_reg           ; 
    reg     [DATA_WIDTH - 1          : 0]   data_to_l2_data_reg                 ;
    
    reg                                     read_addr_to_l2_valid_data_reg      ;
    reg     [ADDRESS_WIDTH - 2 - 1   : 0]   read_addr_to_l2_data_reg            ; 
    reg     [DATA_WIDTH - 1          : 0]   data_from_l2_data_reg               ; 
    
    initial
    begin
        data_cache_ready_reg            = HIGH                                  ;
        write_to_l2_valid_data_reg      = LOW                                   ;
        write_addr_to_l2_data_reg       = 30'b0                                 ;
        data_to_l2_data_reg             = 32'b0                                 ;
        read_addr_to_l2_valid_data_reg  = LOW                                   ;
        read_addr_to_l2_data_reg        = 30'b0                                 ;
        data_from_l2_data_reg           = 32'b0                                 ;
    end                                  
    
    always@(posedge CLK)
    begin
        if(DATA_CACHE_STORE == DATA_CACHE_STORE_W)
        begin
            write_to_l2_valid_data_reg      <= HIGH                                                 ;
            write_addr_to_l2_data_reg       <= DATA_CACHE_WRITE_ADDRESS[ADDRESS_WIDTH - 1     : 2]  ;
            data_to_l2_data_reg             <= DATA_CACHE_WRITE_DATA                                ;
        end
        else
        begin
            write_to_l2_valid_data_reg      <= LOW                                                  ;
            write_addr_to_l2_data_reg       <= 30'b0                                                ;
            data_to_l2_data_reg             <= 32'b0                                                ;
        end
        
        if(DATA_CACHE_LOAD == DATA_CACHE_LOAD_W)
        begin
            read_addr_to_l2_valid_data_reg  <= HIGH                                                 ;
            read_addr_to_l2_data_reg        <= DATA_CACHE_READ_ADDRESS[ADDRESS_WIDTH - 1      : 2]  ;             
        end
        else
        begin
            read_addr_to_l2_valid_data_reg  <= LOW                                                  ;
            read_addr_to_l2_data_reg        <= 30'b0                                                ;
        end
        
        if(DATA_FROM_L2_VALID_DATA == HIGH)
        begin
            data_from_l2_data_reg           <= DATA_FROM_L2_DATA                                    ;
        end
        else
        begin
            data_from_l2_data_reg           <= 32'b0                                                ;
        end
    end
    
    assign  DATA_CACHE_READY            = data_cache_ready_reg                                      ;
    assign  WRITE_TO_L2_VALID_DATA      = write_to_l2_valid_data_reg                                ;
    assign  WRITE_ADDR_TO_L2_DATA       = write_addr_to_l2_data_reg                                 ;
    assign  DATA_TO_L2_DATA             = data_to_l2_data_reg                                       ;
    assign  READ_ADDR_TO_L2_VALID_DATA  = read_addr_to_l2_valid_data_reg                            ;
    assign  READ_ADDR_TO_L2_DATA        = read_addr_to_l2_data_reg                                  ;
    assign  DATA_CACHE_READ_DATA        = data_from_l2_data_reg                                     ;
    
    //////////////////------ TEST CODE ------//////////////////
    
endmodule
