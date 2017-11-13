`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2016 12:07:25
// Design Name: 
// Module Name: NORMALIZADOR
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


module NORMALIZADOR(
    input wire [31:0] A, //entrada al normalizador 
    output wire [31:0] Y //salida de la normalizacion en coma fija, coma entre el bit 30 y 29
    );

//wire [61:0] Out;      
wire [63:0] Out;      
    
    MULTIPLIER_32BITS_L MULT_NORM(
        .A(A),
        //.B(32'b00000001110010011110000110110000),
        //.B(32'b00000000110011000111000100001100),//0.199641     1/valor maximo constante de adrian
        .B(32'b00000010111000111111111011111011),//0.72265236     constante de JJ
        .Y(Out)
        );

//assign Y = Out[54:22]; //constante de adrian   
//assign Y = Out[57:26];   //constante  de jj
assign Y = {Out[57],{3{1'b0}},Out[56:52],Out[51:29]};   //constante  de jj y ajuste para estimador a formato 1:8:23


endmodule
