`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.11.2017 13:50:37
// Design Name: 
// Module Name: FPU_UART_tb
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


module FPU_UART_tb();
         reg CLK; //system clock
         reg RST;
		 
		 //OUTPUT SIGNALS
         wire TX,LED_P, START_ADC, ack_op, LED_reset;
              
	// Instantiate the Unit Under Test (UUT)
	FPU_UART uut(
        .clk(CLK),
        .rst(RST),
        //.Y(Y),
        .TX(TX),
        .TX_p(TX_P),
        .LED_P(LED_P),
        .START_ADC(START_ADC),
        .ack_op(ack_op),
        .LED_reset(LED_reset)
        );
	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        RST = 0;
      
        
        #30 RST = 1;
        #100 RST =0;
    
    end 
    
     //******************************* Se ejecuta el CLK ************************
   
       initial forever #5 CLK = ~CLK;
        
endmodule
