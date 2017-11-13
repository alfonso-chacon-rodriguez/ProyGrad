`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2017 08:35:15
// Design Name: 
// Module Name: ESTIMADOR_TOP
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


module ESTIMADOR_TOP#(parameter N=32, M=12)(

    input wire CLK,
    input wire [M-1:0] I,
    input wire [M-1:0] V,
    
    //input wire [N-1:0] Y,                             // SEÑAL AGREGADA PARA COMPROBAR COMPORTAMIENTO DE ESTIMADOR !!!! QUITAR!!!!
    
    input wire RST, EOC,
    output wire ACK_THETA_IF, ACK_THETA_VF, START_ADC,
    output wire [N-1:0] RESULT_IS,
    output wire [N-1:0] RESULT_ALPHA,
    output wire [N-1:0] RESULT_LIN_I,
    output wire [N-1:0] RESULT_NORM_V
    );
    

    wire ACK_THETA_I, ACK_THETA_V, ACK_CAS_I, ACK_CAS_V;
    wire [N-1:0] RESULT_I, RESULT_V;
    wire [N-1:0] EXP, MANTISSA;
    
    assign ACK_THETA_IF = ACK_THETA_I;
    assign ACK_THETA_VF = ACK_THETA_V;    
    
    CAS ACOND_DIGITAL(
    .CLK(CLK),
    .RST(RST),
    .I(I),
    .V(V),
    .ACK_THETA_I(ACK_THETA_I),
    .ACK_THETA_V(ACK_THETA_V),
    .EOC(EOC),
    .EXP(EXP),
    .MANTISSA(MANTISSA),
    .RESULT_V(RESULT_V),
    //.RESULT_I(RESULT_I),
    .ACK_CAS_I(ACK_CAS_I),
    .ACK_CAS_V(ACK_CAS_V),
    .START_ADC(START_ADC)
    );
    

    
    SIST_ESTIMADOR ESTIMADOR(
    .CLK(CLK),
    .RST(RST),
    .I(MANTISSA),
    .EXP(EXP),
    //.Y(Y),
    .V(RESULT_V),
    .ACK_CAS_I(ACK_CAS_I),
    .ACK_CAS_V(ACK_CAS_V),
    .RESULT_IS(RESULT_IS),
    .RESULT_ALPHA(RESULT_ALPHA),
    .ACK_THETA_IF(ACK_THETA_I),
    .ACK_THETA_VF(ACK_THETA_V),
    .RESULT_LIN_I(RESULT_LIN_I),
    .RESULT_V(RESULT_NORM_V)
    );
       
    
endmodule
