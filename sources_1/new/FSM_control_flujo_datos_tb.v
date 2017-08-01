`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2017 1:45:09 AM
// Design Name: 
// Module Name: FSM_control_flujo_datos_tb
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


module FSM_control_flujo_datos_tb();
   reg clk, reset, ack_i, ack_v, ack_e, ack_d1, ack_d2;  
   wire start_i, start_v, start_e, start_d1, start_d2; 
     
   reg [1:0] state;
     
   FSM_control_flujo_datos DUT (
   .clk    (clk), 
   .reset  (reset), 
   .ack_i (ack_i),
   .ack_v (ack_v),
   .ack_e (ack_e),
   .ack_d1 (ack_d1),
   .ack_d2 (ack_d2),
   .start_i  (start_i),
   .start_v  (start_v),
   .start_e  (start_e),
   .start_d1  (start_d1),
   .start_d2  (start_d2) 
   ); 
     
   initial 
   begin 
     clk = 0; 
     reset = 0; 
     ack_i = 0;
     ack_v = 0;
     ack_e = 0;
     ack_d1 = 0;
     ack_d2 = 0; 
   end 
     
   always 
      #5  clk =  ! clk; 
     
   initial  begin
          $dumpfile ("FSM.vcd"); 
          $dumpvars; 
        end 
        
    task random_states(); 
        begin 
            @(posedge clk); 
            ack_i = {$random};
            ack_v = {$random};
            ack_e = {$random};
            ack_d1 = {$random};
            ack_d2 = {$random};
            reset = 0; 
        end 
    endtask 
    
    task state_monitor();
        begin
            if((ack_i)&&(ack_v)==1)
            begin
                state=1;
            end
            else if ((ack_e)==1)
            begin  
                state = 2;
            end
            else if ((ack_d1)&&(ack_d2)==1)
            begin   
               state = 3;
            end
            else
            begin
                state = 0;
            end
        end
    endtask 
        
        initial
        repeat(60)
        begin
        random_states();
        state_monitor(); 
        end
endmodule
