`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Juan Jos� Rojas Salazar
// 
// Create Date: 08/01/2016 03:34:00 PM
// Design Name: 
// Module Name: DESNORMALIZADOR_DESLINEALIZADOR
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


module DESNORMALIZADOR_DESLINEALIZADOR(
    input wire CLK,
    input wire [31:0] I,
    input wire [31:0] V,
    input wire RST_EX_FF,
    input wire Begin_FSM_I,
    input wire Begin_FSM_V,
    output wire ACK_I,
    output wire ACK_V,
    //   output wire U_F,
    //   output wire O_F,
    output wire [31:0] RESULT_I,
    output wire [31:0] RESULT_V
    );
    
//    wire ACK_EX;
    wire ACK_FF;
    wire [31:0] FLOATING;

    I_DESNORM_FIXED_TO_FLOAT DESNORM_I_FIXED_FLOAT(
        .CLK(CLK),                  //system clock
        .F(I),                      //VALOR BINARIO EN COMA FIJA 
        .RST_FF(RST_EX_FF),         //system reset
        .Begin_FSM_FF(Begin_FSM_I), //INICIA LA CONVERSION 
        .ACK_FF(ACK_FF),            //INDICA QUE LA CONVERSION FUE REALIZADA 
        .RESULT(FLOATING)           //RESULTADO FINAL 
        );
          
    DESLINEALIZADOR #(.P(32)) DESLINEALIZADOR_FLOAT (
        .CLK(CLK),                  //system clock
        .T(FLOATING),               //VALOR DEL ARGUMENTO DEL EXPONENCIAL QUE SE DESEA CALCULAR 
        //.T(I),                    //VALOR DEL ARGUMENTO DEL EXPONENCIAL QUE SE DESEA CALCULAR 
        .RST_EX(RST_EX_FF),         //system reset
        .Begin_FSM_EX(ACK_FF),      //INICIA EL CALCULO 
        //.Begin_FSM_EX(Begin_FSM_I), //INICIA EL CALCULO        
        .ACK_EX(ACK_I),             //INDICA QUE EL CALCULO FUE REALIZADO 
        .O_FX(),                    //BANDERA DE OVER FLOW X
        .O_FY(),                    //BANDERA DE OVER FLOW X
        .O_FZ(),                    //BANDERA DE OVER FLOW X
        .U_FX(),                    //BANDERA DE UNDER FLOW Y
        .U_FY(),                    //BANDERA DE UNDER FLOW Y
        .U_FZ(),                    //BANDERA DE UNDER FLOW Y         
        .RESULT(RESULT_I)           //RESULTADO FINAL 
        );
    
    V_DESNORM_FIXED_TO_FLOAT DESNORM_V_FIXED_FLOAT(
        .CLK(CLK),                  //system clock
        .F(V),                      //VALOR BINARIO EN COMA FIJA 
        .RST_FF(RST_EX_FF),         //system reset
        .Begin_FSM_FF(Begin_FSM_V), //INICIA LA CONVERSION 
        .ACK_FF(ACK_V),             //INDICA QUE LA CONVERSION FUE REALIZADA 
        .RESULT(RESULT_V)           //RESULTADO FINAL 
        );

endmodule
