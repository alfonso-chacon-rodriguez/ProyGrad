`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pablo Gomez Ramirez
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
	input wire CLK,RESET,ACK_I,ACK_V,ACK_E,ACK_THETA_I,ACK_THETA_V, ACK_CAS_I,ACK_CAS_V,
	output reg START_I, START_V, START_E, START_THETA_I, START_THETA_V, CLEAR, REG_THETA_I, REG_THETA_V
);
//*********************************************************

localparam [2:0] // Codificaci�n de los estados o etiquetas
	state_0 = 3'b000,
	state_1 = 3'b001,
	state_2 = 3'b010,
	state_3 = 3'b011,
	state_4 = 3'b100;

reg [3:0] state, next_state; // Reg, estado actual y siguiente

//*********************************************************

//Parte Secuencial

always@(posedge CLK, posedge RESET)
begin
	if(RESET)
    begin
		state <= state_0;
	    //START_I = 1'b1;// se agregan para darle arranque a la maquina.
        //START_V = 1'b1;// de otra manera la máquina no funciona
        //CLEAR = 1'b1;
    end
	else
		state <= next_state;
end

//*********************************************************

//Parte Combinacional
always@*
begin
	next_state = state;
	START_I = 0;
	START_V = 0;
	START_E = 0;
	START_THETA_I = 0;
	START_THETA_V = 0;
	REG_THETA_I = 0;
	REG_THETA_V = 0;
	CLEAR = 0;


	case(state)
        state_0:
            if(((ACK_CAS_I)&&(ACK_CAS_V))==1)
            begin
                CLEAR = 1'b1;
                REG_THETA_I = 1'b0;
                REG_THETA_V = 1'b0;
                //START_V = 1'b1;
                next_state = state_1;
            end
	
	    state_1:
		    begin
                CLEAR = 1'b0;
                START_I = 1'b1;
                START_V = 1'b1;
                next_state = state_2;
            end	    
	        
		state_2:
			if(((ACK_I)&&(ACK_V))==1)
			begin
			    //START_I = 1'b1;
			    //START_V = 1'b1;
			    START_E = 1'b1; //se agrega para darle arranque al estimador. Al parecer no necesita esta señal
                next_state = state_3;
             end
             

		state_3:
            if((ACK_E)==1)
            begin
                //START_E = 1'b1;
                START_THETA_I = 1'b1; // se agregan para darle arranque al siguiente modulo
                START_THETA_V = 1'b1;
                next_state = state_4;
            end						
		
		state_4:
            if(((ACK_THETA_I)&&(ACK_THETA_V))==1)
            begin
                REG_THETA_I = 1'b1;
                REG_THETA_V = 1'b1;
                //CLEAR = 1'b1;
                next_state = state_0;
            end

//		state_5:
//		    begin
//                next_state = state_0;
//		    end
		    
		default:
			//CLEAR = 1'b0; 
			next_state = state_0;
			
	endcase
end

endmodule
