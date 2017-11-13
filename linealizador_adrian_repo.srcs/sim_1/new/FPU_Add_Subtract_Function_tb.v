`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2017 14:12:07
// Design Name: 
// Module Name: FPU_Add_Subtract_Function_tb
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


module FPU_Add_Subtract_Function_tb();// #(parameter W = 64, parameter EW = 11, parameter SW = 52)();
    reg RST, CLK, Begin_SUM, ACK_FSM_SUM, ADD_SUBT;
    reg [31:0] REG2;
    wire O_F, U_F;
    wire ACK_SUM;
    wire [31:0] RESULT;

        parameter P=32;
        parameter D = 5; 
        parameter width = 10;

FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBT(
    .clk(CLK),
	.rst(RST),
	.beg_FSM(Begin_SUM),
	.ack_FSM(ACK_FSM_SUM),
	.Data_X(32'b01000000011111110101110000101001),
	.Data_Y(REG2),
	.add_subt(ADD_SUBT),
	.r_mode(2'b00),
	.overflow_flag(O_F),
	.underflow_flag(U_F),
	.ready(ACK_SUM),
	.final_result_ieee(RESULT)
    );
    
       reg [31:0] Array_IN_I [0:999]; //((2**width)-1)];
       reg [31:0] Array_IN_V [0:999]; //((2**width)-1)];
       
       integer contador;
   //    integer FileSaveData_I;
//       integer FileSaveData_V;
       integer Cont_CLK;
       integer Recept;
   
       
       initial begin
           // Initialize Inputs
           CLK = 0;    
           REG2 = 0;
           Begin_SUM = 0;
           ACK_FSM_SUM = 0;
           ADD_SUBT = 0;
                      
           #30 RST = 1;

           

           //FileSaveData_I = $fopen("ALPHA_BIN.txt","w");
           //FileSaveData_V = $fopen("LN_IS_BIN.txt","w");                               
           //Inicializa las variables del testbench
           contador = 0;
           Cont_CLK = 0;
           Recept = 1;
           
           #100 RST =0;
           
           
       end 
           
          //**************************** Se lee el archivo txt y se almacena en un arrays***************************************************//
        
/*        initial begin
            $readmemh("/home/pgomezr/linealizador_adrian_repo/ipv_gradient_HEX.txt", Array_IN_I);
            $readmemh("/home/pgomezr/linealizador_adrian_repo/vpv_gradient_HEX.txt", Array_IN_V);
        end*/
        
        
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
                       //$fclose(FileSaveData_I);
                       //$fclose(FileSaveData_V);
                       $finish;
                   end
               else 
                   begin
                   if(Cont_CLK ==1) 
                       begin
   
                          REG2 = {$random};
                          Begin_SUM = 1;
                          ACK_FSM_SUM=1;
                          ADD_SUBT= 1;
                          Cont_CLK = Cont_CLK + 1;
                          RST = 0;
                       end
                   else 
                       if(Cont_CLK ==2) 
                           begin
                              RST = 0;
                              Begin_SUM=0;
                              ACK_FSM_SUM=0;
                              Cont_CLK = Cont_CLK +1 ;
                           end 
                   else 
                       if(Cont_CLK ==1000) 
                           begin
                               contador = contador + 1;
                               //RST = 1;
                               Cont_CLK = 0;
                           end
/*                  else 
                       if(Recept ==1) 
                           begin
                                Begin_MULT={$random};
                                ACK_FSM=1;
                                Recept=0;
                           end*/
    
                   else 
                       begin
                           RST = 0;
                           Cont_CLK = Cont_CLK + 1;
   
                       end
                   end
               end
           end
    
/*       // Recepción de datos y almacenamiento en archivo*************
       always @(posedge CLK) 
           begin
           if(ACK_MULT) 
               begin
               Recept=1;
               end
           else 
               begin
                  Recept = 0; 
               end    
           end */
   
   
    //******************************* Se ejecuta el CLK ************************
   
       initial forever #5 CLK = ~CLK;
   
   
   endmodule
