`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
Pablo Gomez Ramirez// 
// Create Date: 12.10.2017 10:47:02
// Design Name: 
// Module Name: RESTA_EXPONENTE_MANTISSA
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


module RESTA_EXPONENTE_MANTISSA#(parameter N=32, M=8, F=23, E=127, ln2=32'd5814540)
(
        //INPUTS
        input wire CLK,
        input wire [N-1:0] T,
        input wire RST,
        input wire Begin_SUBS_EXP,
        //OUTPUTS
        output reg ACK_SUBS_EXP,
        output reg [N-1:0] MANTISSA,
        output reg [N-1:0] EXP
        );
        
    reg [N-1:0] aux, aux1, aux2, aux3; //Variables auxiliares para concatenar unos o ceros
    
    wire [M-1:0] exponente = T[M+F-1:F];
    wire [N-1:0] resta_exp = resta(exponente,E);
    wire [2*N-1:0] mult_exp = mult(resta_exp,ln2);
    wire [N-1:0] mult_exp_trunc = truncar(mult_exp);
        
    always @(posedge CLK, posedge RST)
    begin
        if(RST)
        begin
            MANTISSA = 0;
            EXP = 0;
            ACK_SUBS_EXP = 0;
        end
        else if(Begin_SUBS_EXP)
        begin
            MANTISSA = {2'b0,7'd127,T[F-1:0]};
            EXP= truncar(mult(resta(exponente,E),ln2));
            ACK_SUBS_EXP = 1'b1;
        end
        else
        begin
            MANTISSA = MANTISSA;
            EXP= EXP;
            ACK_SUBS_EXP = 1'b0;
        end
    end
        
    function [N-1:0] resta(input unsigned [M-1:0] num1, num2);//Subrutina de resta
    begin
       aux = 32'h00000000;
       aux1 = 32'hffffffff;
       aux3 = num1 - num2;
       resta = (aux3[M-1]==1) ? {1'b1,aux3,aux[22:0]}: 
                {1'b0,aux3,aux[22:0]}; //Si no hay nada
     end
     endfunction
        
    function  [2*N-1:0] mult(input signed [N-1:0] in1, in2);//Subrutina de multiplicacion
    begin
       mult = in1*in2;
    end
    endfunction
    
    function  [N-1:0] truncar(input signed [2*N-1:0] in);
    begin
       aux = 32'h00000000;
       aux1 = 32'hffffffff;     
       truncar = (in[2*N-1]==0 && in[2*N-3:(2*F)+M]==0) ? {in[2*N-1],in[(2*F)+M-1:F]}: //Si es positivo pero no muy grande: S1, M2, F1
                        (in[2*N-1]==0 && in[2*N-3:(2*F)+M]>0) ? {in[2*N-1],aux1[(M+F)-1:0]}: //Si es positivo muy grande: S1, M=1, F=1
                        (in[2*N-1]==1 && in[2*N-3:(2*F)+M]==aux1[M-1:0]) ? {in[2*N-1],in[(2*F)+M-1:F]}: //Si es negativo pero no tanto: S1, M2, F1 
                        {in[2*N-1],aux[(M+F)-1:0]}; //Si es muy negativo ***
    end
    endfunction 
     

endmodule
