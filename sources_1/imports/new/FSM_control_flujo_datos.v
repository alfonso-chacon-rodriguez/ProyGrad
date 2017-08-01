`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2017 12:44:17 AM
// Design Name: 
// Module Name: FSM_control_flujo_datos
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


module FSM_control_flujo_datos
(
	input wire clk,reset,ack_i,ack_v,ack_e,ack_d1,ack_d2,
	output reg start_i, start_v, start_e, start_d1, start_d2
);
//*********************************************************

localparam [1:0] // Codificación de los estados o etiquetas
	state_0 = 2'b00,
	state_1 = 2'b01,
	state_2 = 2'b10,
	state_3 = 2'b11;

reg [2:0] state, next_state; // Reg, estado actual y siguiente

//*********************************************************

//Parte Secuencial

always@(posedge clk, posedge reset)
begin
	if(reset)
		state <= state_0;
	else
		state <= next_state;
end

//*********************************************************

//Parte Combinacional
always@*
begin
	next_state = state;
	start_i = 0;
	start_v = 0;
	start_e = 0;
	start_d1 = 0;
	start_d2 = 0;


	case(state)
		state_0:
			if(((ack_i)&&(ack_v))==1)
			begin
			    start_i = 1'b1;
			    start_v = 1'b1;
                next_state = state_1;
             end

		state_1:
            if((ack_e)==1)
            begin
                start_e = 1'b1;
                next_state = state_2;
            end						
		
		state_2:
            if(((ack_d1)&&(ack_d2))==1)
            begin
                start_d1 = 1'b1;
                start_d2 = 1'b1;
                next_state = state_3;
            end

		state_3:
		    next_state = state_0;
		
		default: 
			next_state = state_0;
			
	endcase
end

endmodule
