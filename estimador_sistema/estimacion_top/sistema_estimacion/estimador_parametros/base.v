`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DCI Lab TEC
// Engineer: Rolen Coto Calder�n
// Create Date: 21.04.2017 14:38:40
// Module Name: base
// Project Name: Estimador
//////////////////////////////////////////////////////////////////////////////////

module base #(parameter N=32,parameter M=8,parameter F=23)( //agregar parametros
    input clk,
    input reset,
    input start,
    input [N-1:0] Y,//Yin,
    input [N-1:0] V,//Win,
    output [N-1:0] theta_1,//estim1out,
    output [N-1:0] theta_2,//estim2out,
    output flag
    );
    
    reg [14:0] activar = 0;
    
    reg [N-1:0] aux, aux1; //Variables auxiliares para concatenar unos o ceros
    reg signed [2*N-1:0]aux3; //Variable auxiliar para usar en funci�n suma
    reg [2*N-1:0] aux4, aux5; //Variables auxiliares para concatenar unos o ceros
    reg signed [N-1:0]aux6; //Variable auxiliar para usar en funci�n sumay 
    
    parameter [3:0]	E0 = 4'd0, E1 = 4'd1, E2 = 4'd2, E3 = 4'd3;
    parameter [3:0] E4 = 4'd4, E5 = 4'd5, E6 = 4'd6, E7 = 4'd7;
    parameter [3:0] E8 = 4'd8, E9 = 4'd9, E10 = 4'd10, E11 = 4'd11;
    
    reg [3:0] estado = 0, estado_sig; //Pablo agrega el valor inicial de la señal/ Agregada señal estado_sig
    reg dataready; //Señal para tomar 2 variables de entrada e iniciar
    reg bandera, inicio; //Señal para dar una operación por terminada
    assign flag = bandera;
    
    //Registros - Pipeline
    reg enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP;
    reg [N-1:0] registC,registD,registF,estim1out_1,estim2out_1;
    reg [N-1:0] registM = 32'h00466666; // =0.55 theta_1 estimado inicial
    reg [N-1:0] registN = 32'hf9800000; // =-13 theta_2 estimado inicial   SE AGREGAN VALORES PARA REG m Y n (28-9-17)
    reg [N-1:0] cteA = 32'h00000001; //CORRECCION (0.1*1micros)   32'h00000346; //cteA = t11*Ts, darle valor (0.1*1ms)
    reg [N-1:0] cteB = 32'h00000346; //(100*1micros) (28-9-17)  32'h000ccccc; //cteB = t22*Ts, darle valor (100*1ms)  
    reg [2*N-1:0] registA,registP,registB,registE,registG,registH;
    reg [2*N-1:0] registI,registJ,registK,registL;
    
//////////////////////////////////////////////////////
//                             correccion de entrada de 1 entero 30 fracc a 8 entero 23 fracc                  // 
//////////////////////////////////////////////////////    

/*wire [N-1:0] Win_corregido, Yin_corregido;


assign Win_corregido = (Win[31]==1) ? {Win[31],{7{1'b1}},Win[30],Win[29:7]} : {Win[31],{7{1'b0}},Win[30],Win[29:7]};
assign Yin_corregido = (Yin[31]==1) ? {Yin[31],{7{1'b1}},Yin[30],Yin[29:7]} : {Yin[31],{7{1'b0}},Yin[30],Yin[29:7]};*/
    


//////////////////////////////////////////////////////
// 							FSM						// 
//////////////////////////////////////////////////////	
/*
	// Algoritmo de transicion de estados
	always @(posedge clk) begin
		if (reset) begin
			estado <= E0;
		end
		else begin
			case (estado)
				E0 :	estado <= E1;//if (dataready) estado <= E1; else estado <= E0;
				E1 :	estado <= E2;
				E2 :	estado <= E3; 
				E3 :	estado <= E4;  //�Como agarrar valores nuevos de entradas aqui?
				E4 :	estado <= E5;
				E5 :	estado <= E6; 
				E6 :	estado <= E7;
				E7 :	estado <= E8;
				E8 :	estado <= E9; 
				E9 :	estado <= E10;
				E10 :	estado <= E0;
				default : estado <= E0;
			endcase
	end
end

always @(*) begin
    activar <= {enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP};
end

// Algoritmo de asignacion de salidas
	always @(posedge clk) begin
		if (reset) begin
                enA <= 0; enB <= 0; enC <= 0; enD <= 0; enE <= 0; 
                enF <= 0; enG <= 0; enH <= 0; enI <= 0; enJ <= 0;
                enK <= 0; enL <= 0; enM <= 0; enN <= 0; enP <= 0;
                end
        else begin //�Se inicializan registros en cero?
			case(estado)
				E0: begin
				        bandera <= 0;
				        if(start == 1)
				            estado <= E1;
				        else
				            estado <= E0;
				    end
				E1: begin 
				        enA <= 1; enP <= 1; //dataready <= 0;
				    end
				E2: begin 
				        enB <= 1; enE <= 1; enA <= 0; enP <= 0; 
				    end
				E3: begin 
				        enC <= 1; enB <= 0; enE <= 0;
				    end
				E4: begin 
				        enD <= 1; enF <= 1; enC <= 0;
				    end
				E5: begin 
				        enG <= 1; enI <= 1; enD <= 0; enF <= 0; 
				    end
				E6: begin 
				        enH <= 1; enJ <= 1; enG <= 0; enI <= 0;
				    end
				E7: begin 
				        enK <= 1; enH <= 0; enJ <= 0; 
				    end
				E8: begin 
				        enL <= 1; enM <= 1; enK <= 0;
				    end
				E9: begin 
				        enN <= 1; enL <= 0; enM <= 0;
				    end
				E10: begin
				        bandera <= 1; enN <= 0;
				        //estim1out_1 <= registM;
				        //estim2out_1 <= registN;
				     end
			endcase
		end
	end*/

//////////////////////////////////////////////////////
// 							FSM						// 
//////////////////////////////////////////////////////	
/*
	// Algoritmo de transicion de estados
	always @(posedge clk,posedge reset) begin
		if (reset) begin
			estado <= E0;
			//enA = 0; enB = 0; enC = 0; enD = 0; enE = 0; 
            //enF = 0; enG = 0; enH = 0; enI = 0; enJ = 0;
            //enK = 0; enL = 0; enM = 0; enN = 0; enP = 0;
		end
		else 
		estado<=estado_sig;
end

//always @(*) begin
//    activar <= {enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP};
//end

// Algoritmo de asignacion de salidas
	always @(*) begin
	   activar <= {enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP};
       estado_sig=estado;
			case(estado)
				E0: begin
				        bandera <= 0;
				        if(start == 1)
				            estado_sig <= E1;
				        else
				            estado_sig <= E0;
				    end
				E1: begin 
				        enA <= 1; enP <= 1; //dataready <= 0;
				        estado_sig <= E2;
				    end
				E2: begin 
				        enB <= 1; enE <= 1; enA <= 0; enP <= 0; 
				        estado_sig <= E3;
				    end
				E3: begin 
				        enC <= 1; enB <= 0; enE <= 0;
				        estado_sig <= E4;
				    end
				E4: begin 
				        enD <= 1; enF <= 1; enC <= 0;
				        estado_sig <= E5;
				    end
				E5: begin 
				        enG <= 1; enI <= 1; enD <= 0; enF <= 0; 
				        estado_sig <= E6;
				    end
				E6: begin 
				        enH <= 1; enJ <= 1; enG <= 0; enI <= 0;
				        estado_sig <= E7;
				    end
				E7: begin 
				        enK <= 1; enH <= 0; enJ <= 0; 
				        estado_sig <= E8;
				    end
				E8: begin 
				        enL <= 1; enM <= 1; enK <= 0;
				        estado_sig <= E9;
				    end
				E9: begin 
				        enN <= 1; enL <= 0; enM <= 0;
				        estado_sig <= E10;
				    end
				E10: begin
				        bandera <= 1; enN <= 0;
				        estado_sig <= E0;
				        //estim1out_1 <= registM;
				        //estim2out_1 <= registN;
				     end
			endcase
		end*/

//////////////////////////////////////////////////////
// 							FSM						// 
//////////////////////////////////////////////////////	

	// Algoritmo de transicion de estados
	always @(posedge clk/*,posedge reset*/) begin
		if (reset) begin
			estado <= E0;
			//enA = 0; enB = 0; enC = 0; enD = 0; enE = 0; 
            //enF = 0; enG = 0; enH = 0; enI = 0; enJ = 0;
            //enK = 0; enL = 0; enM = 0; enN = 0; enP = 0;
		end
		else 
		estado<=estado_sig;
end

//always @(*) begin
//    activar <= {enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP};
//end

// Algoritmo de asignacion de salidas
	always @(*) begin
//	   activar <= {enA,enB,enC,enD,enE,enF,enG,enH,enI,enJ,enK,enL,enM,enN,enP};
       estado_sig=estado;
			case(estado)
				E0: begin
				        bandera <= 0;
				        if(start == 1)
				            estado_sig <= E1;
				        else
				            estado_sig <= E0;
				    end
				E1: begin 
				        registA = mult(registM,V);
                        registP = concatenar(registN);
				        estado_sig <= E2;
				    end
				E2: begin 
                        registB = suma(registA,registP);
                        registE = mult(V,cteA);
				        estado_sig <= E3;
				    end
				E3: begin 
                        registC = truncar(registB);
				        estado_sig <= E4;
				    end
				E4: begin 
                        registD = resta(Y,registC);
                        registF = truncar(registE);
				        estado_sig <= E5;
				    end
				E5: begin 
                        registG = mult(registF,registD);
                        registI = concatenar(registM);
				        estado_sig <= E6;
				    end
				E6: begin 
                        registH = mult(cteB,registD);
                        registJ = concatenar(registN);
				        estado_sig <= E7;
				    end
				E7: begin 
                        registK = suma(registG,registI);
				        estado_sig <= E8;
				    end
				E8: begin 
                        registL = suma(registH,registJ);
                        registM = truncar(registK);
				        estado_sig <= E9;
				    end
				E9: begin 
                        registN = truncar(registL);
				        estado_sig <= E10;
				    end
				E10: begin
				        bandera <= 1;
				        estado_sig <= E0;
				        //estim1out_1 <= registM;
				        //estim2out_1 <= registN;
				     end
			endcase
		end	

//Manejo de pipeline
/*always @(posedge clk , posedge reset) begin
    if (reset) begin
    registA <= 0; registB <= 0; registC <= 0; registD <= 0; registE <= 0; registF <= 0;
    registG <= 0; registH <= 0; registI <= 0; registJ <= 0; registK <= 0; registL <= 0;
    registP <= 0; //registM <= 0; registN <= 0;
    end
    else begin
//    if ((enA==1) && (enP==1)) begin
//        registA = mult(estim1out,Win_corregido); //�Puedo llamar se�ales de entrada, salida, y auxiliares?
//        registP = concatenar (estim2out);
//        end
//    else if ((enB==1) && (enE==1)) begin
//        registB = suma(registA,registP);
//        registE = mult(Win_corregido,cteA);
//        end
//    else if (enC==1) begin
//        registC = truncar(registB);
//        end
//    else if ((enD==1) && (enF==1)) begin
//        registD = resta(Yin_corregido,registC);
//        registF = truncar(registE);
//        end
//    else if ((enG==1) && (enI==1)) begin
//        registG = mult(registF,registD);
//        registI = concatenar (estim1out_1);
//        end        
//    else if ((enH==1) && (enJ==1)) begin
//        registH = mult(cteB,registD);
//        registJ = concatenar (estim2out_1);
//        end
//    else if (enK==1) begin
//        registK = suma(registG,registI);
//        end
//    else if ((enL==1) && (enM==1)) begin
//        registL = suma(registH,registJ);
//        registM = truncar(registK);
//        end
//    else if (enN==1) begin
//        registN = truncar(registL);
//        end
//    end
    
    case (activar)
          15'h4001 : begin
                     //registA = mult(registM,Win_corregido); //registM y registN en vez de estimouts
                     //registA = mult(registM,Win); //registM y registN en vez de estimouts
                     ///// AGREGADO
                     registA = mult(registM,V);
                     /////
                     registP = concatenar(registN);
                   end
          15'h2400 : begin
                     registB = suma(registA,registP);
                     //registE = mult(Win_corregido,cteA);
                     //registE = mult(Win,cteA);
                     ///// AGREGADO
                     registE = mult(V,cteA);
                     /////
                   end
          15'h1000 : begin
                      registC = truncar(registB);
                   end
          15'h0a00 : begin
                      //registD = resta(Yin_corregido,registC);
                      //registD = resta(Yin,registC);
                      ///// AGREGADO
                      registD = resta(Y,registC);
                      /////
                      registF = truncar(registE);
                   end
          15'h0140 : begin
                      registG = mult(registF,registD);
                      registI = concatenar(registM);
                   end
          15'h00a0 : begin
                      registH = mult(cteB,registD);
                      registJ = concatenar(registN);
                   end
          15'h0010 : begin
                      registK = suma(registG,registI);
                   end
          15'h000c : begin
                      registL = suma(registH,registJ);
                      registM = truncar(registK);
                   end
          15'h0002 : begin
                      registN = truncar(registL);
                   end
          default: begin
                   end
       endcase
   end
end
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                             correccion de salida de 8 entero 23 fracc a 5 entero 26 fracc                  /

/*wire [N-1:0] estim1out_corregido, estim2out_corregido;

assign estim1out_corregido = registM; //Salidas
assign estim2out_corregido = registN;

assign estim1out = {estim1out_corregido[31],estim1out_corregido[27:23],estim1out_corregido[22:0],{3{1'b0}}};
assign estim2out = {estim2out_corregido[31],estim2out_corregido[27:23],estim2out_corregido[22:0],{3{1'b0}}};*/

///// AGREGADO

assign theta_1 = {registM[31],registM[27:23],registM[22:0],{3{1'b0}}};
assign theta_2 = {registN[31],registN[27:23],registN[22:0],{3{1'b0}}};

//assign theta_1 = registM;
//assign theta_2 = registN;
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
    
// Subrutinas
    function  [2*N-1:0] mult(input signed [N-1:0] in1, in2);//Subrutina de multiplicaci�n
    begin
       mult = in1*in2;
    end
    endfunction  

    function  [2*N-1:0] suma(input signed [2*N-1:0] num1, num2);//Subrutina de suma
    begin
       aux4 = 64'h0000000000000000;
       aux5 = 64'hffffffffffffffff;
       aux3 = num1 + num2;
       suma = (num1[2*N-1]==0 && num2[2*N-1]==0 && aux3[2*N-1]==1) ? {1'b0,aux5[2*N-2:0]}: //Si hay overflow
                     (num1[2*N-1]==1 && num2[2*N-1]==1 && aux3[2*N-1]==0) ? {1'b1,aux4[2*N-2:0]}: //Si hay underflow
                      aux3; //Si no hay nada
    end
    endfunction 

    function [N-1:0] resta(input signed [N-1:0] num1, num2);//Subrutina de resta
    begin
       aux = 32'h00000000;
       aux1 = 32'hffffffff;
       aux3 = num1 - num2;
       resta = (num1[N-1]==1 && num2[N-1]==0 && aux3[N-1]==0) ? {1'b1,aux[N-2:0]}: //Si hay underflow
                      (num1[N-1]==0 && num2[N-1]==1 && aux3[N-1]==1) ? {1'b0,aux1[N-2:0]}: //Si hay overflow
                      aux3; //Si no hay nada
    end
    endfunction
    
    function  [2*N-1:0] concatenar(input signed [N-1:0] in);
    begin
       aux = 32'h00000000;
       aux1 = 32'hffffffff;     
       concatenar = (in[N-1]==0) ? {2'b00,aux[M-1:0],in[M+F-1:0],aux[F-1:0]}: //Caso positivo
                                           {2'b11,aux1[M-1:0],in[M+F-1:0],aux[F-1:0]}; //Caso negativo  ***Rev
    end
    endfunction
    
    function  [N-1:0] truncar(input signed [2*N-1:0] in);
    begin
       aux = 32'h00000000;
       aux1 = 32'hffffffff;     
       truncar = (in[2*N-1]==0 && in[2*N-3:(2*F)+M]==0) ? {in[2*N-1],in[(2*F)+M-1:F]}: //Si es positivo pero no muy grande: S1, M2, F1
                        (in[2*N-1]==0 && in[2*N-3:(2*F)+M]>0) ? {in[2*N-1],aux1[(M+F)-1:0]}: //Si es positivo muy grande: S1, M=1, F=1
                        (in[2*N-1]==1 && in[2*N-3:(2*F)+M]==aux1[M-1:0]) ? {in[2*N-1],in[(2*F)+M-1:F]}: //Si es negativo pero no tanto: S1, M2, F1 
                        {in[2*N-1],aux[(M+F)-1:0]}; //Si es muy negativo ***
    end
    endfunction   
             
endmodule
