`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 07/19/2016 08:27:43 PM
// Design Name: 
// Module Name: Mux_2x1_23Bits
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


module Mux_2x1_23Bits #(parameter M=23) //MULTIPLEXOR 2X1 DE 23 BITS 
(
//Input Signals
input wire MS, // SELECTOR
input wire [M-1:0] D_0, //DATO DE EN LA ENTRADA 0
input wire [M-1:0] D_1, //DATO DE EN LA ENTRADA 1

//Output Signals
output reg [M-1:0] D_out //SALIDA 
);

    always @*
        begin
            case(MS)
                1'b0: D_out = D_0;
                1'b1: D_out = D_1;
                default : D_out = D_0;
            endcase
        end

endmodule
