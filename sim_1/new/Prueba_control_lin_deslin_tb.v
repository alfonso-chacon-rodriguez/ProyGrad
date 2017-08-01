`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2017 09:14:04 AM
// Design Name: 
// Module Name: Prueba_control_lin_deslin_tb
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


module Prueba_control_lin_deslin_tb();
    reg clk, reset;
    reg[31:0] I, V;  
    wire[31:0]result_1, result_2; 
    
Prueba_control_lin_deslin prueba_control (
       .CLK (clk),         
       .reset (reset),       
       .I (I),     
       .V (V),     
       .RESULT_I (result_1),
       .RESULT_V (result_2)
    );

    initial 
    begin 
      clk = 0; 
      reset = 0; 
      I = 32'd0;
      V = 32'd0;
    end
     
   always 
       #5  clk =  ! clk; 
      
    initial  begin
           $dumpfile ("estimador.vcd"); 
           $dumpvars; 
         end 
         
     task random_input_IV(); 
         begin 
             @(posedge clk); 
             I = $random;
             V = $random;
             reset = 0; 
         end 
     endtask 
         
         initial
         repeat(10)
         begin
         random_input_IV();
         end
 endmodule

