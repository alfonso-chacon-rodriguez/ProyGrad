`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2016 12:07:59
// Design Name: 
// Module Name: FSM_C_CORDIC
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


module FSM_C_CORDIC(
	 //INPUTS
	 input wire CLK,            //system clock
	 input wire RST_EX,         //system reset 
	 input wire ACK_ADD_SUBTX,  //RECIBE SI LA SUMA EN FLOTANTE X SE EJECUTO 
	 input wire ACK_ADD_SUBTY,  //RECIBE SI LA SUMA EN FLOTANTE Y SE EJECUTO
	 input wire ACK_ADD_SUBTZ,  //RECIBE SI LA SUMA EN FLOTANTE Z SE EJECUTO
	 input wire ACK_MULT,	 	//RECIBE SI LA MULT EN FLOTANTE X*Y SE EJECUTO 
	 input wire Begin_FSM_EX,   //inicia la maquina de estados 
	 input wire [4:0] CONT_ITER,//LLEVA LA CUENTA DE LA ITERACIONES 
		
     //OUTPUT SIGNALS
     output reg RST,            //REALIZA EL RESET DE LOS REGISTROS 
     output reg MS_1,           //SELECCION DEL MUX 1 
     output reg [1:0] MS_M,     //SELECCION DEL MUX_M
     output reg EN_REG3,        //ENABLE PARA EL REGISTRO 3 CON EL VALOR DEL EXP = COSH + SIN H
     output reg EN_REG4,        //ENABLE PARA EL REGISTRO 4 CON EL VALOR FINAL DEL RESULTADO CALCULADO
     output reg ADD_SUBT,       //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
     output reg Begin_SUMX,     //INICIA ADD/SUM FLOTANTE X
     output reg Begin_SUMY,     //INICIA ADD/SUM FLOTANTE Y
     output reg Begin_SUMZ,     //INICIA ADD/SUM FLOTANTE Z
     output reg Begin_MULT,     //INICIA MULT FLOTANTE X*Y
     output reg EN_REG1X,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA
     output reg EN_REG1Y,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA 
     output reg EN_REG1Z,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA   
     output reg [1:0] MS_2,     //SELECCION DEL MUX 2
     output reg EN_REG2,        //ENABLE PARA EL REGISTRO CON LOS VALORES DESPLAZADOS DE LA SEGUNDA ETAPA 
     output reg CLK_CDIR,       //CLK PARA EL CONTADOR DE ITERACIONES 
     output reg EN_REG2XYZ,     //ENABLE PARA EL VALOR ANTERIOR DE XYZ DE SEGUNDA ETAPA 
     output reg ACK_EX,         //ACK PARA SABER SI LA OPERACION EX YA SE REALIZO 
        
     //registros de selectores
     output reg EN_ADDSUBT,
     output reg EN_MS_M,
     output reg EN_MS1,
     output reg EN_MS2
	 );


parameter [5:0] 
    //se definen los estados que se utilizaran en la maquina
					 a = 6'd0,
				     b = 6'd1,
					 c = 6'd2,
					 d = 6'd3,
					 e = 6'd4,
					 f = 6'd5,
					 g = 6'd6, 
					 h = 6'd7,   
					 i = 6'd8,
					 j = 6'd9, 
					 k = 6'd10,                          
					 l = 6'd11,  
					 m = 6'd12,
					 n = 6'd13,
					 o = 6'd14,
					 p = 6'd15,
					 q = 6'd16,
					 r = 6'd17,
					 s = 6'd18,
					 t = 6'd19;
					 	
reg [5:0] state_reg, state_next ; //state registers declaration

////
always @(posedge CLK, posedge RST_EX)
	if (RST_EX) begin
		state_reg <= a;	
	end
	else begin
		state_reg <= state_next;
	end

//assign State = state_reg;
///	
always @*
	begin
	state_next = state_reg;
	
	EN_REG2 = 0;
    EN_REG3 = 0;
    EN_REG4 = 0;
    EN_REG1X = 0;
    EN_REG1Y = 0;
    EN_REG1Z = 0;
    EN_REG2XYZ = 0;
    Begin_SUMX = 0;
    Begin_SUMY = 0;
    Begin_SUMZ = 0;
    Begin_MULT = 0;
    ACK_EX = 0;
    CLK_CDIR = 0;
    RST = 0;
    MS_M = 2'b00;
    MS_1 = 0;
    MS_2 = 2'b00;
    ADD_SUBT = 0;
    EN_ADDSUBT = 0;
    EN_MS_M = 0;
    EN_MS1 = 0;
    EN_MS2 = 0;
    //nuevos estados 
    
case(state_reg)
            a: 
            begin
                
                if(Begin_FSM_EX) 
                    begin
                    RST = 1; 
                    state_next = b;
                    end
                else
                    state_next = a;
            end
            
            b:
            begin
                ADD_SUBT = 0;
                EN_ADDSUBT = 1;
                MS_M = 2'b00;
                EN_MS_M = 1;
                MS_1 = 1;
                EN_MS1 = 1;
                MS_2 = 2'b10;
                EN_MS2 = 1;
                state_next = c;
            end
            
            c:
            begin
                Begin_SUMZ = 1;
                state_next = d;
            end
            
            d:
            begin
                state_next = e;
            end
            
            e:
            begin
                if(ACK_ADD_SUBTZ)
                    begin
                        EN_REG1X = 1;
                        EN_REG1Y = 1;
                        EN_REG1Z = 1;
                        state_next = f;
                    end
                else
                    state_next = e;
            end
          
            f:
            begin 
                MS_1 = 0;
                EN_MS1= 1;
                MS_2 = 2'b01;
                EN_MS2 = 1;
                ADD_SUBT = 0;
                EN_ADDSUBT = 1;
                state_next = g;
            end
            
            g:
            begin 
                state_next = h;
            end
            
            h:
            begin
                
                if(CONT_ITER == 5'b00001)
                    begin
                    MS_M = 2'b01;
                    EN_MS_M = 1;
                    state_next = i;
                    end
                else if (CONT_ITER >= 5'b00010)     
                    begin
                    MS_M = 2'b10;
                    EN_MS_M = 1;
                    state_next = i;
                    end
                else
                    state_next = i;
            end
                                    
            i:
            begin
                EN_REG2 = 1;
                state_next = j;
            end
            
            j:
            begin
                EN_REG2XYZ = 1;
                state_next = k;
            end
            
            k:
            begin
                Begin_SUMX = 1;
                Begin_SUMY = 1;
                CLK_CDIR = 1;
                state_next = l;
            end
            
            l:
            begin
                state_next = m;
            end
            
            m:
            begin
                    Begin_SUMZ = 1;
                if(ACK_ADD_SUBTX & ACK_ADD_SUBTY)
                    begin
                    EN_REG1X = 1;
                    EN_REG1Y = 1;
                    //Begin_SUMZ = 1;
                    state_next = n;
                    end
                else
                    state_next = m;
            end
                 
            n:
            begin
                
                if(ACK_ADD_SUBTZ)
                    begin
                    EN_REG1Z = 1;
                    state_next = o;
                    end
                else
                    state_next = n;
            end
                         
            o:
            begin
                           
                if(CONT_ITER == 5'b01111 )//if(CONT_ITER == 5'b01111 ) //15 iteraciones
                    begin 
                    MS_2 = 0;
                    EN_MS2 = 1;
                    ADD_SUBT = 0;
                    EN_ADDSUBT = 1; 
                    state_next = p;
                    end
                else
                   state_next = g;
            end      
            
            p:
            begin
                Begin_SUMZ = 1;
                state_next = q;
            end 
     
            q:
            begin
                
                if(ACK_ADD_SUBTZ)
                   begin 
                   EN_REG3 = 1;
                   state_next = r;
                   end
                else
                   state_next = q;
            end 
            
            r:
            begin
                Begin_MULT = 1;
                state_next = s;            
            end
            
            s:
            begin
                if(ACK_MULT)
                   begin
                   EN_REG4 = 1;
                   state_next = t;
                   end
                else
                   state_next = s;    
            end
           
            t:
            begin
                ACK_EX = 1;
                if(RST_EX)
                    begin 
                    RST = 1; 
                    state_next = a;
                    end
            end
        endcase
end

	
endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 06.03.2016 12:07:59
//// Design Name: 
//// Module Name: FSM_C_CORDIC
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module FSM_C_CORDIC(
//	 //INPUTS
//	 input wire CLK,            //system clock
//	 input wire RST_EX,         //system reset 
//	 input wire ACK_ADD_SUBTX,  //RECIBE SI LA SUMA EN FLOTANTE X SE EJECUTO 
//	 input wire ACK_ADD_SUBTY,  //RECIBE SI LA SUMA EN FLOTANTE Y SE EJECUTO
//	 input wire ACK_ADD_SUBTZ,  //RECIBE SI LA SUMA EN FLOTANTE Z SE EJECUTO	 	 
//	 input wire Begin_FSM_EX,   //inicia la maquina de estados 
//	 input wire [4:0] CONT_ITER,//LLEVA LA CUENTA DE LA ITERACIONES 
		
//     //OUTPUT SIGNALS
//     output reg RST,            //REALIZA EL RESET DE LOS REGISTROS 
//     output reg MS_1,           //SELECCION DEL MUX 1 
//     output reg [1:0] MS_M,     //SELECCION DEL MUX_M
//     output reg EN_REG3,        //ENABLE PARA EL REGISTRO 3 CON EL VALOR FINAL DEL RESULTADO CALCULADO
//     output reg ADD_SUBT,       //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
//     output reg Begin_SUMX,     //INICIA ADD/SUM FLOTANTE X
//     output reg Begin_SUMY,     //INICIA ADD/SUM FLOTANTE Y
//     output reg Begin_SUMZ,     //INICIA ADD/SUM FLOTANTE Z
//     output reg EN_REG1X,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA
//     output reg EN_REG1Y,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA 
//     output reg EN_REG1Z,       //ENABLE PARA LOS REGISTROS X,Y,Z DE LA PRIMERA ETAPA   
//     output reg [1:0] MS_2,     //SELECCION DEL MUX 2
//     output reg EN_REG2,        //ENABLE PARA EL REGISTRO CON LOS VALORES DESPLAZADOS DE LA SEGUNDA ETAPA 
//     output reg CLK_CDIR,       //CLK PARA EL CONTADOR DE ITERACIONES 
//     output reg EN_REG2XYZ,     //ENABLE PARA EL VALOR ANTERIOR DE XYZ DE SEGUNDA ETAPA 
//     output reg ACK_EX,         //ACK PARA SABER SI LA OPERACION EX YA SE REALIZO 
        
//     //registros de selectores
//     output reg EN_ADDSUBT,
//     output reg EN_MS_M,
//     output reg EN_MS1,
//     output reg EN_MS2
//	 );


//parameter [5:0] 
//    //se definen los estados que se utilizaran en la maquina
//					 a = 6'd0,
//				     b = 6'd1,
//					 c = 6'd2,
//					 d = 6'd3,
//					 e = 6'd4,
//					 f = 6'd5,
//					 g = 6'd6, 
//					 h = 6'd7,   
//					 i = 6'd8,
//					 j = 6'd9, 
//					 k = 6'd10,                          
//					 l = 6'd11,  
//					 m = 6'd12,
//					 n = 6'd13,
//					 o = 6'd14,
//					 p = 6'd15,
//					 q = 6'd16,
//					 r = 6'd17;
						
//reg [5:0] state_reg, state_next ; //state registers declaration

//////
//always @(posedge CLK, posedge RST_EX)
//	if (RST_EX) begin
//		state_reg <= a;	
//	end
//	else begin
//		state_reg <= state_next;
//	end

////assign State = state_reg;
/////	
//always @*
//	begin
//	state_next = state_reg;
	
//	EN_REG2 = 0;
//    EN_REG3 = 0;
//    EN_REG1X = 0;
//    EN_REG1Y = 0;
//    EN_REG1Z = 0;
//    EN_REG2XYZ = 0;
//    Begin_SUMX = 0;
//    Begin_SUMY = 0;
//    Begin_SUMZ = 0;
//    ACK_EX = 0;
//    CLK_CDIR = 0;
//    RST = 0;
//    MS_M = 2'b00;
//    MS_1 = 0;
//    MS_2 = 2'b00;
//    ADD_SUBT = 0;
//    EN_ADDSUBT = 0;
//    EN_MS_M = 0;
//    EN_MS1 = 0;
//    EN_MS2 = 0;
//    //nuevos estados 
    
//case(state_reg)
//            a: 
//            begin
                
//                if(Begin_FSM_EX) 
//                    begin
//                    RST = 1; 
//                    state_next = b;
//                    end
//                else
//                    state_next = a;
//            end
            
//            b:
//            begin
//                ADD_SUBT = 0;
//                EN_ADDSUBT = 1;
//                MS_M = 2'b00;
//                EN_MS_M = 1;
//                MS_1 = 1;
//                EN_MS1 = 1;
//                MS_2 = 2'b10;
//                EN_MS2 = 1;
//                state_next = c;
//            end
            
//            c:
//            begin
//                Begin_SUMZ = 1;
//                state_next = d;
//            end
            
//            /*d:
//            begin
//                state_next = e;
//            end*/
            
//            d:
//            begin
//                if(ACK_ADD_SUBTZ)
//                    begin
//                        EN_REG1X = 1;
//                        EN_REG1Y = 1;
//                        EN_REG1Z = 1;
//                        state_next = e;
//                    end
//                else
//                    state_next = d;
//            end
          
//            e:
//            begin 
//                MS_1 = 0;
//                EN_MS1= 1;
//                MS_2 = 2'b01;
//                EN_MS2 = 1;
//                ADD_SUBT = 0;
//                EN_ADDSUBT = 1;
//                state_next = f;
//            end
            
//            f:
//            begin 
//                state_next = g;
//            end
            
//            g:
//            begin
                
//                if(CONT_ITER == 5'b00001)
//                    begin
//                    MS_M = 2'b01;
//                    EN_MS_M = 1;
//                    state_next = h;
//                    end
//                else if (CONT_ITER >= 5'b00010)     
//                    begin
//                    MS_M = 2'b10;
//                    EN_MS_M = 1;
//                    state_next = h;
//                    end
//                else
//                    state_next = h;
//            end
                                    
//            h:
//            begin
//                EN_REG2 = 1;
//                state_next = i;
//            end
            
//            i:
//            begin
//                EN_REG2XYZ = 1;
//                state_next = j;
//            end
            
//            j:
//            begin
//                Begin_SUMX = 1;
//                Begin_SUMY = 1;
//                CLK_CDIR = 1;
//                state_next = k;
//            end
            
//            k:
//            begin
//                state_next = l;
//            end
            
//            l:
//            begin
//                    Begin_SUMZ = 1;
//                if(ACK_ADD_SUBTX & ACK_ADD_SUBTY)
//                    begin
//                    EN_REG1X = 1;
//                    EN_REG1Y = 1;
//                    //Begin_SUMZ = 1;
//                    state_next = m;
//                    end
//                else
//                    state_next = l;
//            end
                 
//            m:
//            begin
                
//                if(ACK_ADD_SUBTZ)
//                    begin
//                    EN_REG1Z = 1;
//                    state_next = n;
//                    end
//                else
//                    state_next = m;
//            end
                         
//            n:
//            begin
                           
//                if(CONT_ITER == 5'b01111 )//if(CONT_ITER == 5'b01111 ) //15 iteraciones
//                    begin 
//                    MS_2 = 0;
//                    EN_MS2 = 1;
//                    ADD_SUBT = 0;
//                    EN_ADDSUBT = 1; 
//                    state_next = o;
//                    end
//                else
//                   state_next = f;
//            end      
            
//            o:
//            begin
//                Begin_SUMZ = 1;
//                state_next = p;
//            end 
     
//            p:
//            begin
                
//                if(ACK_ADD_SUBTZ)
//                   begin 
//                   EN_REG3 = 1;
//                   state_next = q;
//                   end
//                else
//                   state_next = p;
//            end 
    
//            q:
//            begin
//                ACK_EX = 1;
//                if(RST_EX)
//                    begin 
//                    RST = 1; 
//                    state_next = a;
//                    end
//            end
//        endcase
//end

	
//endmodule		