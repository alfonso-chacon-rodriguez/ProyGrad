`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2017 08:11:52 AM
// Design Name: 
// Module Name: estimador_completo_tb
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


module estimador_completo_tb();
    reg clk, reset;
    reg[31:0] I, V;  
    wire[31:0]result_1, result_2; 

wire ack_i, ack_v, ack_e, ack_d1, ack_d2, start_i, start_v, start_e, start_d1, start_d2;
wire[31:0] lineal_I, lineal_V, estimate_1, estimate_2; 



FSM_control_flujo_datos Control_flujo (
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

LINEALIZADOR_NORMALIZADOR Bloque_LN(
    
    .CLK (clk),
    .I (I),
    .V (V),
    .RST_LN_FF (reset),
    .Begin_FSM_I (start_i),
    .Begin_FSM_V (start),
    .ACK_I (ack_i),
    .ACK_V (ack_v),
    .RESULT_I (lineal_I),
    .RESULT_V (lineal_V)
    );
    
DESNORMALIZADOR_DESLINEALIZADOR Bloque_DLN(

    .CLK (clk),
    .I (estimate_1),
    .V (estimate_2),
    .RST_EX_FF (reset),
    .Begin_FSM_I (start_d1),
    .Begin_FSM_V (start_d2),
    .ACK_I (ack_d1),
    .ACK_V (ack_d2),
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
         repeat(200)
         begin
         random_input_IV();
         end
 endmodule
    

