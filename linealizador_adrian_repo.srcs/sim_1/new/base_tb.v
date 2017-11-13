`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2017 14:07:49
// Design Name: 
// Module Name: sistema_estimador_tb
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


module base_tb();

        parameter P=32;
        parameter D = 5; 
        parameter width = 10;
         reg [P-1:0] Yin;
         reg [P-1:0] Win;
         reg CLK; //system clock
         reg RST;
         reg start;

		 
		 //OUTPUT SIGNALS
		 //wire ACK_THETA_IF;
		 wire flag;
         wire [31:0] estim1out;
         wire [31:0] estim2out;
                 

    
    
	// Instantiate the Unit Under Test (UUT)
    base #(.M(8),.F(23),.N(32))uut (
       .Yin(Yin), 
       .Win(Win), 
       .reset(RST),
       .start(start),
       .clk(CLK), 
       .estim1out(estim1out), 
       .estim2out(estim2out), 
       .flag(flag)
    );
    
    reg [31:0] Array_IN_I [0:199]; //((2**width)-1)];
    reg [31:0] Array_IN_V [0:199]; //((2**width)-1)];
    
    integer contador;
    integer FileSaveData_I;
    integer FileSaveData_V;
    integer Cont_CLK;
    integer Recept;

	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        Win = 0;
        Yin = 0;
        start = 0;
        
        #30 RST = 1;

        FileSaveData_I = $fopen("datosbin1_estimador_BIN.txt","w");
        FileSaveData_V = $fopen("datosbin2_estimador_BIN.txt","w");                
        //Inicializa las variables del testbench
        contador = 0;
        Cont_CLK = 0;
        Recept = 1;
        
        #100 RST =0;
        
        
    end 
        
	   //**************************** Se lee el archivo txt y se almacena en un arrays***************************************************//
     
     initial begin
         $readmemb("/home/pgomezr/Descargas/datosbin_rampa.txt", Array_IN_I);
         $readmemb("/home/pgomezr/Descargas/datosbin_rampa.txt", Array_IN_V);
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
                    $finish;
                end
            else 
                begin
                if(Cont_CLK ==1) 
                    begin
                       start= 1;
                       Win = Array_IN_I[contador];
                       Yin = Array_IN_V[contador];
                       Cont_CLK = Cont_CLK + 1;
					   RST = 0;
                    end
                else 
                    if(Cont_CLK ==2) 
                        begin
					       RST = 0;
					       start = 0;

					       Cont_CLK = Cont_CLK +1 ;
				        end 
                else 
                    if(Cont_CLK ==5000) 
                        begin
                            contador = contador + 1;
                            RST = 1;
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
        if(flag) 
            begin
			if(Recept == 1) 
			     begin
				    $fwrite(FileSaveData_I,"%b %\n",estim1out);
				    $fwrite(FileSaveData_V,"%b %\n",estim2out);
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
