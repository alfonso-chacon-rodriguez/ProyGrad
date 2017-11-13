`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2017 15:33:30
// Design Name: 
// Module Name: ACD_VALUE_RAM_tb
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


module ACD_VALUE_RAM_tb();
   reg reset, clk;
   reg [11:0] din_i;
   reg [11:0] din_v;
   wire [31:0] dout_i; 
   wire [31:0] dout_v; 
     
     
   ADC_VALUE_ROM uut ( 
   //.clk(clk),
   .reset  (reset), 
   .din_i (din_i),
   .din_v (din_v),
   .dout_v (dout_v),
   .dout_i (dout_i)
   ); 
     
   initial 
   begin 
     #30 reset = 1;
     #100 reset =0;
     din_i = 0;
     din_v = 0;
     clk=0;
   end 
     
   always 
      #5  clk =  ! clk; 
     
/*   initial  begin
          $dumpfile ("FSM.vcd"); 
          $dumpvars; 
        end */
        
    task random_states(); 
        begin 
            @(posedge clk); 
            din_i = {$random};
            din_v = {$random};
            reset = 1'b0; 
        end 
    endtask 
    
        
    initial
    repeat(60)
        begin
        random_states();
        end 
endmodule 