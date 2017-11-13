`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pablo Gomez Ramirez
// 
// Create Date: 21.09.2017 17:26:39
// Design Name: 
// Module Name: ADC_VALUE_ROM
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


module ADC_VALUE_ROM #(L=12,N=32,P=4096)
(input wire reset,
//input wire clk,
input wire [L-1:0] din_i, ///desde ADC
input wire [L-1:0] din_v, ///desde ADC
output reg [N-1:0] dout_i, /// hacia conversion
output reg [N-1:0] dout_v); /// hacia conversion


reg [N-1:0] mem [0:P-1];


initial begin
$readmemb("/home/pgomezr/linealizador_adrian_repo/0_1_BIN.rcf",mem);
end

always @(*)
    if(reset)
    begin
        dout_i <=0;
        dout_v <=0;
    end
    else
    begin
      dout_i <= mem[din_i];
      dout_v <= mem[din_v];
    end

endmodule