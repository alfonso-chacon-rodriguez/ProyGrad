`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pablo Gomez Ramirez
// 
// Create Date: 19.09.2017 16:06:48
// Design Name: 
// Module Name: FSM_CAS
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


module FSM_CAS(
	input wire CLK,RESET,ACK_MULT_I,ACK_MULT_V,ACK_SUBS_I,ACK_THETA_I, ACK_THETA_V, EOC, ACK_SUBS_EXP, //ACK_MULT_LN2,
	output reg EN_REG_ADC_I, EN_REG_ADC_V, Begin_FSM_MULT_I, Begin_FSM_MULT_V, ACK_FSM_MULT_I, ACK_FSM_MULT_V, EN_REG_MULT_I, EN_REG_MULT_V,
	output reg Begin_FSM_SUBS_I, ACK_FSM_SUBS_I, EN_REG_SUBS_I, ACK_CAS_I, ACK_CAS_V, START_ADC, Begin_SUBS_EXP //Begin_FSM_MULT_LN2, ACK_FSM_MULT_LN2
);
//*********************************************************

localparam [3:0] // Codificaci�n de los estados o etiquetas
	state_0 = 4'b0000,
	state_1 = 4'b0001,
	state_2 = 4'b0010,
	state_3 = 4'b0011,
	state_4 = 4'b0100,
	state_5 = 4'b0101,
	state_6 = 4'b0110,
	state_7 = 4'b0111,
	state_8 = 4'b1000,
	state_9 = 4'b1001,
	state_10 = 4'b1010,
	state_11 = 4'b1011;



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
	EN_REG_ADC_I=0;
	EN_REG_ADC_V=0;
	Begin_FSM_MULT_I=0;
	Begin_FSM_MULT_V=0;
	ACK_FSM_MULT_I=0;
	ACK_FSM_MULT_V=0;
	EN_REG_MULT_I=0;
	EN_REG_MULT_V=0;
	Begin_FSM_SUBS_I=0;
	ACK_FSM_SUBS_I=0;
    EN_REG_SUBS_I=0;
    Begin_SUBS_EXP=0;
    //Begin_FSM_MULT_LN2=0;
    //ACK_FSM_MULT_LN2=0;	
	ACK_CAS_I=0; 
	ACK_CAS_V=0; 
	START_ADC=0; 


	case(state)
                
        state_0:
        //state_1:
            if(EOC)
            begin
                START_ADC=1'b0;
	            EN_REG_ADC_I=1'b1;
                EN_REG_ADC_V=1'b1;
                next_state = state_1;
                //next_state = state_2;
            end

	    state_1:
	    //state_2:
		    begin
		        EN_REG_ADC_I=1'b0;
                EN_REG_ADC_V=1'b0;                
                Begin_FSM_MULT_I=1'b1;
                Begin_FSM_MULT_V=1'b1;
                ACK_FSM_MULT_I=1'b1;
                ACK_FSM_MULT_V=1'b1;
                next_state = state_2;
                //next_state = state_3;
            end
            
	    //state_3:
	    state_2:
		    begin		        
		        EN_REG_ADC_I=1'b0;
                EN_REG_ADC_V=1'b0;
                Begin_FSM_MULT_I=1'b1;
                Begin_FSM_MULT_V=1'b1;
                ACK_FSM_MULT_I=1'b1;
                ACK_FSM_MULT_V=1'b1;
                next_state = state_3;
                //next_state = state_4;
            end	    
	        
		//state_4:
		state_3:
		//state_2:
			if(((ACK_MULT_V)&&(ACK_MULT_I))==1)
			begin
	            EN_REG_MULT_I=1'b1;
                EN_REG_MULT_V=1'b1;
                //next_state = state_3;
                next_state = state_4;
                //next_state = state_5;
             end
             

		//state_5:
		state_4:
		//state_3:
            begin
	            Begin_FSM_SUBS_I=1'b1;
                ACK_FSM_SUBS_I=1'b1;
                //next_state = state_4;
                next_state = state_5;
                //next_state = state_6;
            end
            
		//state_6:
		state_5:
		//state_4:
        //state_3:
                begin
                    Begin_FSM_SUBS_I=1'b1;
                    ACK_FSM_SUBS_I=1'b1;
                    //next_state = state_4;
                    //next_state = state_5;
                    next_state = state_6;
                    //next_state = state_7;
                end    						
		
		
		//state_7:
		state_6:
		//state_5:
		//state_4:
            if((ACK_SUBS_I)==1)
            begin
                EN_REG_SUBS_I = 1'b1;
                //ACK_CAS_I=1'b1; 
                //ACK_CAS_V=1'b1;
                next_state = state_7;
                //next_state = state_0;
            end

		//state_6:
		state_7:
		//state_4:
        //state_3:
            begin
                Begin_SUBS_EXP=1'b1;
                next_state = state_8;
                //next_state = state_6;
                //next_state = state_7;
            end
        
/*        //state_0:
        //state_7:
        state_8:
            if((ACK_SUBS_EXP)==1)
            begin
                Begin_FSM_MULT_LN2=1'b1;
                ACK_FSM_MULT_LN2=1'b1;
                next_state = state_9;
                //next_state = state_8;
            end    
            
        //state_0:
        //state_8:
        state_9:
        begin
            Begin_FSM_MULT_LN2=1'b1;
            ACK_FSM_MULT_LN2=1'b1;
            next_state = state_10;
            //next_state = state_9;
        end */
            
        //state_0:
        state_8:
        //state_10:
            if((ACK_SUBS_EXP)==1)
            begin
                ACK_CAS_I=1'b1; 
                ACK_CAS_V=1'b1;
                //next_state = state_11;
                next_state = state_9;
            end
                    
        //state_11:
        state_9:
            if(((ACK_THETA_I)&&(ACK_THETA_V))==1)
            begin
                START_ADC=1'b1;
                ACK_CAS_I=1'b0; 
                ACK_CAS_V=1'b0;
                next_state = state_0;
                //next_state = state_1;
            end
		    
		default:
			next_state = state_0;
			
	endcase
end

endmodule