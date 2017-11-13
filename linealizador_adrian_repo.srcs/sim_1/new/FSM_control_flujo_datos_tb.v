`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2017 09:58:31 PM
// Design Name: 
// Module Name: FSM_tb
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
   reg clk, reset, ack_i, ack_v, ack_e, ack_theta_i, ack_theta_v;  
   wire start_i, start_v, start_e, start_theta_i, start_theta_v, clear, reg_theta_i, reg_theta_v; 
     
   reg [1:0] state;
     
   FSM_control_flujo_datos control ( 
   .clk    (clk), 
   .reset  (reset), 
   .ack_i (ack_i),
   .ack_v (ack_v),
   .ack_e (ack_e),
   .ack_theta_i (ack_theta_i),
   .ack_theta_v (ack_theta_v),
   .start_i  (start_i),
   .start_v  (start_v),
   .start_e  (start_e),
   .start_theta_i  (start_theta_i),
   .start_theta_v  (start_theta_v), 
   .clear  (clear), 
   .reg_theta_i  (reg_theta_i), 
   .reg_theta_v  (reg_theta_v) 
   ); 
     
   initial 
   begin 
     clk = 0; 
     reset = 0; 
     ack_i = 0;
     ack_v = 0;
     ack_e = 0;
     ack_theta_i = 0;
     ack_theta_v = 0; 
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
            ack_i = {$random};
            ack_v = {$random};
            ack_e = {$random};
            ack_theta_i = {$random};
            ack_theta_v = {$random};
            reset = 1'b0; 
        end 
    endtask 
    
    task state_monitor();
        begin
            if((ack_i)&&(ack_v)==1)
            begin
                state=3;
            end
            else if ((ack_e)==1)
            begin  
                state = 4;
            end
            else if ((ack_theta_i)&&(ack_theta_v)==1)
            begin   
               state = 0;
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