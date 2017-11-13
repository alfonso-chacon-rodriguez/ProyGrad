`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2016 09:50:50
// Design Name: 
// Module Name: NORMALIZADOR_2
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


module NORMALIZADOR_2(
    input wire [31:0] A, //entrada al normalizador 
    output wire [31:0] Y //salida de la normalizacion en coma fija, coma entre el bit 30 y 29
    );

//wire [61:0] Out;      
wire [63:0] Out;      
    
    MULTIPLIER_32BITS_L MULT_NORM(
        .A(A),
        //.B(32'b00000000001110001110001000011001),
        //.B(32'b00000000001110001101010011111101), // 1/(18)   1/valor maximo 
        //.B(32'b00000000001110001001001101110100), // 1/(18.1)   1/valor maximo constante de adrian
        //.B(32'b00000000001011110011000001011110), // 1/(21.7)   1/valor maximo   constante de jj
        .B(32'b00000100000000000000000000000000), // 1   valor prueba sin normalizacion
        .Y(Out)
        );

//assign Y = Out[54:22];   // salida de constante de adrian    
assign Y = {Out[57],{3{1'b0}},Out[56:52],Out[51:29]};   //constante  de jj y ajuste para estimador a formato 1:8:23  

endmodule
