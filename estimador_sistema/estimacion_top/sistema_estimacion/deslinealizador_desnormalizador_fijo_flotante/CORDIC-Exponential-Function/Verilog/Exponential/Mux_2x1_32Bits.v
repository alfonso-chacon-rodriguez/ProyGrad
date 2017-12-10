`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2016 03:23:53 PM
// Design Name: 
// Module Name: Mux_2x1_32Bits
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


module Mux_2x1_32Bits(
//Input Signals
input wire MS, // SELECTOR
input wire [31:0] D_0, //DATO DE EN LA ENTRADA 0
input wire [31:0] D_1, //DATO DE EN LA ENTRADA 1

//Output Signals
output reg [31:0] D_out //SALIDA 
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
