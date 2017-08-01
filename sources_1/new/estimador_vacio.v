`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2017 08:03:18 AM
// Design Name: 
// Module Name: estimador_vacio
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


module estimador_vacio(
    inout wire clk,
    input wire [31:0] I,
    input wire [31:0] V,
    input wire reset,
    input wire start_e,
    output reg ack_e,
    output reg [31:0] result_i,
    output reg [31:0] result_v
    );
    

always @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            result_i <= 32'd0;
            result_v <= 32'd0;
            ack_e <= 1'b1;
        end
    else if(start_e)
        begin
            result_i <= I;
            result_v <= V;
            ack_e <= 1'b0;
        end
    else
        begin
            result_i <= result_i;
            result_v <= result_v;
            ack_e <= 1'b1;
        end
end

endmodule