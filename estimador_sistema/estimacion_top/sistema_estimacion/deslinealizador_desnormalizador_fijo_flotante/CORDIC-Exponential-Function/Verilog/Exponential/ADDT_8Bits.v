`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2016 02:44:46 PM
// Design Name: 
// Module Name: ADDT_8Bits
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


module ADDT_8Bits #(P=8, W=8) //SUMADOR EXPONENTE FORMATO PUNTO FIJO EN 8 BITS
(
input wire [P-1:0] A, //ENTRADA A
input wire [W-1:0] B,  //ENTRADA B

output wire [P-1:0] Y //SALIDA Y
);

assign Y = A+B; //SUMA DE EXPONENTES

endmodule
