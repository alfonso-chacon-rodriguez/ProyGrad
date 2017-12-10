`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2016 03:56:05 PM
// Design Name: 
// Module Name: I_DESNORM_FIXED_TO_FLOAT
// Project Name: 
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


module I_DESNORM_FIXED_TO_FLOAT(
    input wire CLK,             //system clock
    input wire [31:0] F,        //VALOR BINARIO EN COMA FIJA 
    input wire RST_FF,          //system reset
    input wire Begin_FSM_FF,    //INICIA LA CONVERSION 
    output wire ACK_FF,         //INDICA QUE LA CONVERSION FUE REALIZADA 
    output wire [31:0] RESULT   //RESULTADO FINAL 
    );
    
    wire Bandcomp;  
    wire [7:0] Encd;      
    wire EN_REG1;
    wire EN_REGmult;   
    wire LOAD;
    wire MS_1;
    wire EN_MS_1;
    wire MS1_REG;
    wire EN_REG2;
    wire RST;

    FF_D #(.P(1))  REG_MS1_I ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_MS_1), 
        .D(MS_1), 
        .Q(MS1_REG)
        );
    
    FSM_Convert_Fixed_To_Float FSM_CONVERT_FIXED_FLOAT(
		.CLK(CLK),                    //system clock
		.RST_FF(RST_FF),              //system reset
		.Bandcomp(Bandcomp),
		.Begin_FSM_FF(Begin_FSM_FF),  //inicia la maquina de estados 
		.Encd(Encd),	
        .EN_REG1(EN_REG1),
        .EN_REGmult(EN_REGmult),  
        .LOAD(LOAD),
        .MS_1(MS_1),
        .ACK_FF(ACK_FF),
        .EN_MS_1(EN_MS_1),
        .EN_REG2(EN_REG2),
        .RST(RST)
        );
	 
	 Convert_Fixed_To_Float CONVERT_FIXED_FLOAT(
        .CLK(CLK),
        .FIXED(F),
        .EN_REG1(EN_REG1),
        .EN_REGmult(EN_REGmult),
        .LOAD(LOAD),
        .MS_1(MS1_REG),
        .Bandcomp(Bandcomp),
        .FLOATOUT(RESULT), 
        .Encd(Encd),
        .EN_REG2(EN_REG2),
        .RST(RST)
        );
      
endmodule
