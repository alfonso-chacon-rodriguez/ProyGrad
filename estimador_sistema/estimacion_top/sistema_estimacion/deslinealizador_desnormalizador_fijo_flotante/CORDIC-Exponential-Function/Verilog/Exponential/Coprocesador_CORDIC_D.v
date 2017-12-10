`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Juan Jos� Rojas Salazar
// 
// Create Date: 07/07/2016 09:29:49 AM
// Design Name: 
// Module Name: Coprocesador_CORDIC
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


module Coprocesador_CORDIC_D#(parameter P = 32, parameter S=8, parameter M=23, parameter D=5, parameter W_Exp = 8, 
        parameter W_Sgf = 23, parameter S_Exp = 9) (
        
    input wire [31:0] T,
    input wire CLK,                 //RELOJ DEL SISTEMA
    input wire RST,                 //RESET PARA LOS REGISTROS 
    input wire MS_1,                //SELECCION DEL MUX 1 VALOR INICIAL DE Z 
    input wire [1:0] MS_M,          //SELECCION DEL MUX VALORES MANTISSA ITERACIONES NEGATIVAS
    input wire EN_REG3,             //ENABLE REG 3 RESULTADO EXP 
    input wire EN_REG4,             //ENABLE REG 4 RESULTADO FINAL 
    input wire ADD_SUBT,            //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
    input wire Begin_SUMX,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE
    input wire Begin_SUMY,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE
    input wire Begin_SUMZ,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE 
    input wire Begin_MULT,          //INICIA LA OPERACION EN MULT FLOTANTE    
    input wire EN_REG1X,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA
    input wire EN_REG1Y,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA
    input wire EN_REG1Z,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA 
    input wire [1:0] MS_2,          //SELECCION MUX 2
    input wire EN_REG2,             //ENABLE PARA EL REGISTRO QUE GUARDA LOS VALORES DESPLAZADOS EN LA SEGUNDA ETAPA
    input wire CLK_CDIR,            //CLK PARA EL CONTADOR DE ITERACIONES 
    input wire EN_REG2XYZ,          //ENABLE PARA REGISTROS QUE GUARDAN EL VALOR ANTERIOR DE X,Y,Z 
    output wire ACK_SUMX,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE X SE COMPLETO
    output wire ACK_SUMY,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE Y SE COMPLETO
    output wire ACK_SUMZ,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE Z SE COMPLETO
    output wire ACK_MULT,           //ACK PARA DETERMINAR CUANDO LA MULT FLOTANTE X*Y SE COMPLETO 
    output wire O_FX,               //BANDERA DE OVERFLOW X
    output wire O_FY,               //BANDERA DE OVERFLOW Y
    output wire O_FZ,               //BANDERA DE OVERFLOW Z
    output wire O_Fmult,            //BANDERA DE OVERFLOW mult
    output wire U_FX,               //BANDERA DE UNDERFLOW X
    output wire U_FY,               //BANDERA DE UNDERFLOW Y
    output wire U_FZ,               //BANDERA DE UNDERFLOW Z
    output wire U_Fmult,            //BANDERA DE UNDERFLOW mult
    output wire [P-1:0] RESULT,     //RESULTADO FINAL 
    output wire [D-1:0] CONT_ITERA  //NUMERO DE LA ITERACION 
    );

    //salidas mux MS_1 a REG1X,Y,Z 
    wire [P-1:0] MUX0;
    wire [P-1:0] MUX1;
    //wire [P-1:0] MUX2;   

    //salidas registros 1 a mux MS_2, signo y desplazador de exponente
    wire [P-1:0] X_ant; 
    wire [P-1:0] Y_ant;
    wire [P-1:0] Z_ant;  

    //salidas de exponentes con calculo de desplazamiento desde la LUT 
    wire [S-1:0] EXP_X;
    wire [S-1:0] EXP_Y;

    //salida LUT valores arctan 
    wire [P-1:0] LUT_arctan; 
    
    //salida valores Mantissa (elecci�n entre X/Y anteriores y LUT Mantissas)
    wire [M-1:0] Mantissa_signX;
    wire [M-1:0] Mantissa_signY;
    
    //salida CONTADOR DE ITER A LUT'S
    wire [D-1:0] DIR_LUT;
          
    // salida de signos
    wire SIGNO_Z;

    //SIGNO + EXPONENTE + MANTISA
    wire [P-1:0] X_act; 
    wire [P-1:0] Y_act;
    wire [P-1:0] Z_act;

    //salidas registros 2 a sumadores punto flotante, signo y desplazador de exponente
    wire [P-1:0] REG2X; 
    wire [P-1:0] REG2Y;
    wire [P-1:0] REG2Z; 
    wire [P-1:0] REG2Xa;
    wire [P-1:0] REG2Ya;
    wire [P-1:0] REG2Za;
    wire [D-1:0] DESP; 
    
    //salidas MUX MANTISSA

    wire [M-1:0] Mant_LUT;
    
    //salidas MUX's MS_2 a ADD/SUBT flotante (esto pertenece al registro de Z)

    wire [P-1:0] A;
    wire [P-1:0] B;

    //resultado ADD/SUBT flotante X,Y,Z

    wire [P-1:0] X_RESULT;
    wire [P-1:0] Y_RESULT;
    wire [P-1:0] Z_RESULT;
    
    //salida REG_3 a mult
    wire [P-1:0] mult;
    wire [P-1:0] MULT_RESULT;
    
    //ASIGNA VALOR DE LA ITERACION A LA DIRECCION DE LAS LUT 
    assign CONT_ITERA = DIR_LUT;
    //ENABLE ROMS 

Mux_2x1 #(.P(P)) MUX2x1_0 ( 
    .MS(MS_1), 
    .D_0(X_RESULT), 
    .D_1(32'b00111111111100010101100000010000), //1.8855 2 iteraciones negativas (0 y 1)
    .D_out(MUX0)
    );

Mux_2x1 #(.P(P)) MUX2x1_1 ( 
    .MS(MS_1), 
    .D_0(Y_RESULT), 
    .D_1(32'b00111111111100010101100000010000), //1.8855 2 iteraciones negativas (0 y 1)
    .D_out(MUX1)
    );
    
/*Mux_2x1 #(.P(P)) MUX2x1_2 ( 
    .MS(MS_1), 
    .D_0(Z_RESULT), 
    .D_1(T),  //Entrada T, dato en coma flotante para calcular el exp(T)=sinh(T)+cosh(T)
    .D_out(MUX2)
    );*/
    
FF_D #(.P(P)) REG1_X ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1X), 
    .D(MUX0), 
    .Q(X_ant)
    );

FF_D #(.P(P)) REG1_Y ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Y), 
    .D(MUX1), 
    .Q(Y_ant)
    );  
    
FF_D #(.P(P)) REG1_Z ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Z), 
    .D(Z_RESULT), 
    .Q(Z_ant)
    );                                  

FF_D #(.P(P)) REG2_Xa ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(X_ant), 
    .Q(REG2Xa)
    );   
        
FF_D #(.P(P)) REG2_Ya ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(Y_ant), 
    .Q(REG2Ya)
    );   

FF_D #(.P(P)) REG2_Za ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(Z_ant), 
    .Q(REG2Za)
    );         
            
COUNTER_5B #(.P(D)) CONT_ITER ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(CLK_CDIR),  
    .Y(DIR_LUT)
    );
        
Mux_2x1_23Bits #(.M(M)) MUX2x1_MANTISSA ( 
    .MS(T[31]), 
    .D_0(23'b01010011011000111101100), 
    .D_1(23'b01101010000001000001100),  
    .D_out(Mant_LUT)
    );   
                                       
LUT_SHIFT #(.P(D)) LUT_ITER ( 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(DESP)
    );                        

LUT_Z #(.P(P),.D(D)) LUT_ARCTAN ( 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(LUT_arctan)
    );    

S_SUBT #(.P(S),.W(5)) SUB_EXP_X ( 
    .A(X_ant[30:23]), 
    .B(DESP), 
    .Y(EXP_X)
    );
                        
S_SUBT #(.P(S),.W(5)) SUB_EXP_Y ( 
    .A(Y_ant[30:23]), 
    .B(DESP), 
    .Y(EXP_Y)
    );        
                        
SIGN SIGNXYZ (
    .SIGN_Z0(Z_ant[31]),
    .SIGN_Z(SIGNO_Z)
    );
    
Mux_3x1_23Bits #(.W(M)) MUX2x1_MANTISSA_SIGNX ( 
    .ctrl(MS_M), 
    .D0(23'b10100110010110100001110), 
    .D1(Mant_LUT),  
    .D2(X_ant[22:0]),
    .S(Mantissa_signX)
    );   
    
Mux_3x1_23Bits #(.W(M)) MUX2x1_MANTISSA_SIGNY ( 
    .ctrl(MS_M), 
    .D0(23'b10100110010110100001110), 
    .D1(Mant_LUT),  
    .D2(Y_ant[22:0]),
    .S(Mantissa_signY)
    );            
             
assign X_act[31] = ~SIGNO_Z;
assign X_act[30:23] = EXP_Y;
assign X_act[22:0] = Mantissa_signY;

assign Y_act[31] = ~SIGNO_Z;
assign Y_act[30:23] = EXP_X;
assign Y_act[22:0] = Mantissa_signX;

assign Z_act[31] = SIGNO_Z;
assign Z_act[30:0] = LUT_arctan[30:0];

FF_D #(.P(P)) REG2_X ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(X_act), 
    .Q(REG2X)
    ); 
            
FF_D #(.P(P)) REG2_Y ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(Y_act), 
    .Q(REG2Y)
    ); 

FF_D #(.P(P)) REG2_Z ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(Z_act), 
    .Q(REG2Z)
    );   

Mux_3x1 #(.W(P)) MUX3x1_X ( 
    .ctrl(MS_2), 
    .D0(X_ant), 
    .D1(REG2Za),
    .D2(T),  
    .S(A)
    );
   
Mux_3x1 #(.W(P)) MUX3x1_Y ( 
    .ctrl(MS_2), 
    .D0(Y_ant), 
    .D1(REG2Z),  
    //.D2(32'b00111101010011001100110011001101),
    .D2(32'b01000001001000000000000000000000), //10
    .S(B)
    );    
                                       
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTX(
    .clk(CLK),
	.rst(RST),
	.beg_FSM(Begin_SUMX),
	.ack_FSM(ACK_SUMX),
	.Data_X(REG2Xa),
	.Data_Y(REG2X),
	.add_subt(ADD_SUBT),
	.r_mode(2'b00),
	.overflow_flag(O_FX),
	.underflow_flag(U_FX),
	.ready(ACK_SUMX),
	.final_result_ieee(X_RESULT)
    );
    
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTY(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_SUMY),
    .ack_FSM(ACK_SUMY),
    .Data_X(REG2Ya),
    .Data_Y(REG2Y),
    .add_subt(ADD_SUBT),
    .r_mode(2'b00),
    .overflow_flag(O_FY),
    .underflow_flag(U_FY),
    .ready(ACK_SUMY),
    .final_result_ieee(Y_RESULT)
    );  
    
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTZ(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_SUMZ),
    .ack_FSM(ACK_SUMZ),
    .Data_X(A),
    .Data_Y(B),
    .add_subt(ADD_SUBT),
    .r_mode(2'b00),
    .overflow_flag(O_FZ),
    .underflow_flag(U_FZ),
    .ready(ACK_SUMZ),
    .final_result_ieee(Z_RESULT)
    );   
		
FF_D #(.P(P)) REG_3 ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG3), 
    .D(Z_RESULT), 
    .Q(mult)
    );
    
FPU_Multiplication_Function #(.W(32),.EW(8),.SW(23)) Mult(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_MULT),
    .ack_FSM(ACK_MULT),
    .Data_MX(mult),
    .Data_MY(32'b00111000001111100110101111001110),
    .round_mode(2'b00),
    .overflow_flag(O_Fmult),
    .underflow_flag(U_Fmult),
    .ready(ACK_MULT),
    .final_result_ieee(MULT_RESULT)
    );
    
FF_D #(.P(P)) REG_4 ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG4), 
    .D(MULT_RESULT), 
    .Q(RESULT)
    );    
                   
endmodule
