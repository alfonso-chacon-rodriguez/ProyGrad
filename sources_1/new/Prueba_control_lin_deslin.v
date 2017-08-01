`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2017 03:40:44 PM
// Design Name: 
// Module Name: Prueba_control_lin_deslin
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


module Prueba_control_lin_deslin(
    input wire CLK,
    input wire [31:0] I,
    input wire [31:0] V,
    input wire reset,

    output wire [31:0] RESULT_I,
    output wire [31:0] RESULT_V
    );
    
    wire ack_i, ack_v, ack_e, ack_deslin_i, ack_deslin_v;
    wire start_i, start_v, start_e, start_d1, start_d2;
    wire [31:0] result_i, result_v, result_estim_i, result_estim_v;
    
    
LINEALIZADOR_NORMALIZADOR linealizador_normalizador (
       // Input Ports - Single Bit
       .Begin_FSM_I    (start_i), 
       .Begin_FSM_V    (start_v), 
       .CLK            (CLK),         
       .RST_LN_FF      (reset),   
       // Input Ports - Busses
       .I        (I),     
       .V        (V),     
       // Output Ports - Single Bit
       .ACK_I          (ack_i),       
       .ACK_V          (ack_v),       
       // Output Ports - Busses
       .RESULT_I (result_i),
       .RESULT_V (result_v)
       // InOut Ports - Single Bit
       // InOut Ports - Busses
    );
    
estimador_vacio estimador_vacio (
           // Input Ports - Single Bit
           .reset          (reset),       
           .start_e        (start_e),     
           // Input Ports - Busses
           .I        (result_i),     
           .V        (result_v),     
           // Output Ports - Single Bit
           .ack_e          (ack_e),       
           // Output Ports - Busses
           .result_i (result_estim_i),
           .result_v (result_estim_v),
           // InOut Ports - Single Bit
           .clk            (CLK)         
           // InOut Ports - Busses
        );    
    
DESNORMALIZADOR_DESLINEALIZADOR desnormalizador_deslinealizador (
       // Input Ports - Single Bit
       .Begin_FSM_I    (start_d1), 
       .Begin_FSM_V    (start_d2), 
       .CLK            (CLK),         
       .RST_EX_FF      (reset),   
       // Input Ports - Busses
       .I        (result_estim_i),     
       .V        (result_estim_v),     
       // Output Ports - Single Bit
       .ACK_I          (ack_deslin_i),       
       .ACK_V          (ack_deslin_v),       
       // Output Ports - Busses
       .RESULT_I (RESULT_I),
       .RESULT_V (RESULT_V)
       // InOut Ports - Single Bit
       // InOut Ports - Busses
    );
    

FSM_control_flujo_datos control_estimador (
   // Input Ports - Single Bit
   .ack_d1   (ack_deslin_i),
   .ack_d2   (ack_deslin_v),
   .ack_e    (ack_e), 
   .ack_i    (ack_i), 
   .ack_v    (ack_v), 
   .clk      (CLK),   
   .reset    (reset), 
   // Input Ports - Busses
   // Output Ports - Single Bit
   .start_d1 (start_d1),
   .start_d2 (start_d2),
   .start_e  (start_e),
   .start_i  (start_i),
   .start_v  (start_v)
   // Output Ports - Busses
   // InOut Ports - Single Bit
   // InOut Ports - Busses
);
    
 
endmodule
