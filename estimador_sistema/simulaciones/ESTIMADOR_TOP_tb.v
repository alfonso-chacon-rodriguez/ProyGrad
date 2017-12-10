`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2017 09:22:00
// Design Name: 
// Module Name: ESTIMADOR_TOP_tb
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


module ESTIMADOR_TOP_tb();

        parameter P=32;
        parameter D = 5; 
        parameter width = 10;
         reg [11:0] I;
         reg [11:0] V;
         reg [31:0] Y;
         reg CLK; //system clock
         reg RST;
         reg EOC;

		 
		 //OUTPUT SIGNALS
         wire ACK_THETA_IF, ACK_THETA_VF, START_ADC;
         wire [31:0] RESULT_IS;
         wire [31:0] RESULT_ALPHA;
         wire [31:0] RESULT_LIN_I;
         wire [31:0] RESULT_NORM_V;
                 

    
    
	// Instantiate the Unit Under Test (UUT)
	ESTIMADOR_TOP uut(
        .CLK(CLK),
        .I(I),
        //.Y(Y),
        .V(V),
        .RST(RST),
        .EOC(EOC),
        .ACK_THETA_IF(ACK_THETA_IF),
        .ACK_THETA_VF(ACK_THETA_VF),
        .START_ADC(START_ADC),
        .RESULT_IS(RESULT_IS),
        .RESULT_ALPHA(RESULT_ALPHA),        
        .RESULT_LIN_I(RESULT_LIN_I),        
        .RESULT_NORM_V(RESULT_NORM_V)        
        );
    
    reg [31:0] Array_IN_Y [0:999]; //((2**width)-1)];
    reg [11:0] Array_IN_I [0:999]; //((2**width)-1)];
    reg [11:0] Array_IN_V [0:999]; //((2**width)-1)];
    
    integer contador;
    integer FileSaveData_I;
    integer FileSaveData_V;
    integer Cont_CLK;
    integer Recept;

	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        I = 0;
        V = 0;
        EOC = 0;
        
        #30 RST = 1;
        //T = 32'b00111110101000000000000000000000;//0.3125//00111100001000111101011100001010; // 0.01
        //T = 32'b00111111000000000000000000000000; //0.5	
        //T = 32'b00111110000110011001100110011010; //0.15
        //T = 32'b00111101110011001100110011001101; //0.1
        //T = 32'b00111110100110011001100110011010; //0.3
        
        FileSaveData_I = $fopen("IS_TOP_BIN.txt","w");
        FileSaveData_V = $fopen("ALPHA_TOP_BIN.txt","w");
        //FileSaveData_I = $fopen("LN_IS_TOP_BIN.txt","w");
        //FileSaveData_V = $fopen("ALPHA_TOP_BIN.txt","w");                               
        //FileSaveData_I = $fopen("LIN_I_TOP_BIN.txt","w");                               
        //FileSaveData_V = $fopen("NORM_V_TOP_BIN.txt","w");                               
        //Inicializa las variables del testbench
        contador = 0;
        Cont_CLK = 0;
        Recept = 1;
        
        #100 RST =0;
        
        
    end 
        
	   //**************************** Se lee el archivo txt y se almacena en un arrays***************************************************//
     
     initial begin
           $readmemb("/home/pgomezr/linealizador_adrian_repo/ipv_gradient_normalizado_4_BIN.txt", Array_IN_I);
           $readmemb("/home/pgomezr/linealizador_adrian_repo/vpv_gradient_normalizado_20_BIN.txt", Array_IN_V);
           $readmemb("/home/pgomezr/linealizador_adrian_repo/y_gradient_BIN_Q.txt", Array_IN_Y);
     end
     
     
    always @(posedge CLK) 
        begin
        if(RST) 
            begin
            //contador = 0;
            Cont_CLK = 0;
             
            #50 RST = 0;
            
            end
        else 
            begin
            if (contador == (2**width)) 
                begin
                    $fclose(FileSaveData_I);
                    $fclose(FileSaveData_V);
                 end
            else 
                begin
                if(Cont_CLK ==1) 
                    begin
                       I = Array_IN_I[contador];
                       V = Array_IN_V[contador];
                       //Y = Array_IN_Y[contador];
                       Cont_CLK = Cont_CLK + 1;
                       EOC = 1;
					   RST = 0;
                    end
                else 
                    if(Cont_CLK ==2) 
                        begin
					       RST = 0;
					       EOC = 0;
					       Cont_CLK = Cont_CLK +1 ;
				        end 
                else 
                    if(Cont_CLK ==2000) 
                        begin
                            contador = contador + 1;
                            //RST = 1;
            				Cont_CLK = 0;
                        end
 
                else 
                    begin
					    RST = 0;
                        Cont_CLK = Cont_CLK + 1;

                    end
                end
            end
        end
 
    // Recepción de datos y almacenamiento en archivo*************
    always @(posedge CLK) 
        begin
        if(START_ADC) 
            begin
			if(Recept == 1) 
			     begin
				    //$fwrite(FileSaveData_I,"%b\n",RESULT_LIN_I);
				    //$fwrite(FileSaveData_V,"%b\n",RESULT_NORM_V);
				    $fwrite(FileSaveData_I,"%b\n",RESULT_IS);
				    $fwrite(FileSaveData_V,"%b\n",RESULT_ALPHA);
				    Recept = 0;
			     end
		    end
        else 
            begin
			   Recept = 1; 
		    end	
        end 


 //******************************* Se ejecuta el CLK ************************

    initial forever #5 CLK = ~CLK;


endmodule
