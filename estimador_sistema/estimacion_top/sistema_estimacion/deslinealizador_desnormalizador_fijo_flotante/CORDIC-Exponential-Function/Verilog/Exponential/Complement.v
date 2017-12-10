`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2016 04:41:37 PM
// Design Name: 
// Module Name: Complement
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
module Complement (

  input wire  [31:0] a_i,
  output wire [31:0] twos_comp
  );
  
  assign twos_comp = ~a_i + 1'b1;

endmodule
