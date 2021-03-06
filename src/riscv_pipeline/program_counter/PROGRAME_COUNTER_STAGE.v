`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Muhammad Ijaz
// 
// Create Date:     05/13/2017 06:08:14 PM
// Design Name: 
// Module Name:     PROGRAME_COUNTER_STAGE
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


module PROGRAME_COUNTER_STAGE #(
        parameter   ADDRESS_WIDTH           = 32                            ,
        parameter   DATA_WIDTH              = 32                            ,
        parameter   ALU_INS_WIDTH           = 5                             ,
        
        parameter   PC_INITIAL              = 32'b0	                        ,
       
        parameter   ALU_JAL                 = 5'b01110                      ,
        parameter   ALU_JALR                = 5'b01111                      ,
        
        parameter   HIGH                    = 1'b1                          ,
        parameter   LOW                     = 1'b0
    ) (
        input                               CLK                             ,
        input                               STALL_PROGRAME_COUNTER_STAGE    ,
        input  [ALU_INS_WIDTH - 1   : 0]    ALU_INSTRUCTION                 ,
        input                               BRANCH_TAKEN                    ,
        input  [ADDRESS_WIDTH - 1   : 0]    PC_EXECUTION                    ,
        input  [DATA_WIDTH - 1      : 0]    RS1_DATA                        ,
        input  [DATA_WIDTH - 1      : 0]    IMM_INPUT                       ,
        input  [ADDRESS_WIDTH - 1   : 0]    PC_DECODING                     ,
        output [ADDRESS_WIDTH - 1   : 0]    PC                              ,
        output                              PC_VALID                        ,
		output                              PC_MISPREDICT_SELECT	           		
    );
    
    reg     [ADDRESS_WIDTH - 1   : 0]   pc_reg                              ;
    reg                                 pc_rs_1_select_reg                  ;
    reg                                 pc_predict_select_reg               ;
    reg                                 pc_mispredict_select_reg            ;
    
    wire                                pc_predictor_status                 ;
    wire    [ADDRESS_WIDTH - 1   : 0]   pc_predictor_out                    ;
    wire    [ADDRESS_WIDTH - 1   : 0]   pc_execution_or_rs_1                ;
    wire    [ADDRESS_WIDTH - 1   : 0]   pc_current_plus_4_or_pc_predicted   ;
    wire    [ADDRESS_WIDTH - 1   : 0]   pc_next                             ;
	
	initial
	begin
        pc_reg          = PC_INITIAL                                        ;
    end
    
    MULTIPLEXER_2_TO_1 pc_execution_or_rs_1_mux(
        .IN1(PC_EXECUTION),
        .IN2(RS1_DATA),
        .SELECT(pc_rs_1_select_reg),
        .OUT(pc_execution_or_rs_1) 
        );
    
    MULTIPLEXER_2_TO_1 pc_current_plus_4_or_pc_predicted_mux(
        .IN1(pc_reg+4),
        .IN2(pc_predictor_out),
        .SELECT(pc_predict_select_reg),
        .OUT(pc_current_plus_4_or_pc_predicted) 
        );
        
    MULTIPLEXER_2_TO_1 pc_mispredicted_mux(
        .IN1(pc_current_plus_4_or_pc_predicted),
        .IN2($signed(pc_execution_or_rs_1)+$signed(IMM_INPUT)),
        .SELECT(pc_mispredict_select_reg),
        .OUT(pc_next) 
        );
    
    BRANCH_PREDICTOR branch_predictor(
        .CLK(CLK),
        .PC(pc_reg),
        .PC_EXECUTION(PC_EXECUTION),
        .PC_PREDICT_LEARN(pc_next),
        .PC_PREDICT_LEARN_SELECT(pc_mispredict_select_reg),
        .PC_PREDICTED(pc_predictor_out),
        .PC_PREDICTOR_STATUS(pc_predictor_status)            
        );
    
    always@(*)
    begin
        if(STALL_PROGRAME_COUNTER_STAGE == LOW)
        begin
            if(pc_predictor_status == HIGH)
            begin
                pc_predict_select_reg = HIGH;
            end
            else
            begin
                pc_predict_select_reg = LOW;
            end
        
            if(ALU_INSTRUCTION == ALU_JALR)
            begin
                pc_rs_1_select_reg = HIGH;
            end
            else
            begin
                pc_rs_1_select_reg = LOW;
            end
            
            if((ALU_INSTRUCTION == ALU_JAL)|(ALU_INSTRUCTION == ALU_JALR)|(BRANCH_TAKEN == HIGH))
            begin
                if($signed(pc_execution_or_rs_1) + $signed(IMM_INPUT) != $signed(PC_DECODING))
                begin
                    pc_mispredict_select_reg            = HIGH;
                end
                else
                begin
                    pc_mispredict_select_reg            = LOW;
                end
            end
            else
            begin
                pc_mispredict_select_reg            = LOW;
            end
        end
    end
    
    always@(posedge CLK)
    begin
        if(STALL_PROGRAME_COUNTER_STAGE == LOW)
        begin
            pc_reg          <= pc_next  ;
        end
    end
    
    assign PC                               = pc_reg                            ;
    assign PC_VALID                         = HIGH                              ;
	assign PC_MISPREDICT_SELECT             = pc_mispredict_select_reg          ;
            
endmodule
