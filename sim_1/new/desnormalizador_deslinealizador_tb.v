`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2017 02:16:15 PM
// Design Name: 
// Module Name: desnormalizador_deslinealizador_tb
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


module desnormalizador_deslinealizador_tb();
        reg clk, reset;
        reg begin_v, begin_i;
        reg[31:0] I, V;  
        wire ack_i, ack_v;
        wire[31:0]result_1, result_2; 


DESNORMALIZADOR_DESLINEALIZADOR desnormalizador_deslinealizador (
       // Input Ports - Single Bit
       .Begin_FSM_I    (begin_i), 
       .Begin_FSM_V    (begin_v), 
       .CLK            (clk),         
       .RST_EX_FF      (reset),   
       // Input Ports - Busses
       .I       (I),     
       .V       (V),     
       // Output Ports - Single Bit
       .ACK_I          (ack_i),       
       .ACK_V          (ack_v),       
       // Output Ports - Busses
       .RESULT_I (result_1),
       .RESULT_V (result_2)
       // InOut Ports - Single Bit
       // InOut Ports - Busses
    );
    
    
        initial 
        begin 
          clk = 0; 
          reset = 0;
          begin_i = 0;
          begin_v = 0; 
          I = 32'd0;
          V = 32'd0;
          #5
          reset =  1;
          #10
          reset = 0;
          #15
          begin_i = 1;
          begin_v = 1;
          #25
          begin_i = 0;
          begin_v = 0;
        end
         
       always 
           #1  clk =  ! clk; 
          
        initial  
        begin
            $dumpfile ("deslinealizador.vcd"); 
            $dumpvars; 
        end 
             
         task random_input_IV(); 
             begin 
                 @(posedge clk); 
                 I = 32'hfd28e4fa;//$random;//32'b11111111111111111111111111110011;//
                 V = 32'hb0bcee61;//$random;//32'b0.10001100110011001100110011;//
/*                 begin_i = 0;//$random;
                 begin_v = 0;//$random;
                 reset = 0;*/
                 if(ack_i == 1 && ack_v == 1)
                     begin
                         begin_i = 1;
                         begin_v = 1;
                     end
                 else
                     begin
                         begin_i = 0;
                         begin_v = 0;
                     end 
             end 
         endtask 
         
/*         task control_ack_start();
         begin
                if(ack_i == 1 && ack_v == 1)
                    begin
                        begin_i = 1;
                        begin_v = 1;
                    end
                else
                    begin
                        begin_i = 0;
                        begin_v = 0;
                    end
         endtask*/
             
             initial
             repeat(600)
             begin
                random_input_IV();
    //            control_ack_start();
             end
     endmodule
