`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2017 10:36:01
// Design Name: 
// Module Name: FPU_Multiplication_Function_tb
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


module FPU_Multiplication_Function_tb();// #(parameter W = 64, parameter EW = 11, parameter SW = 52)();
    reg RST, CLK, Begin_MULT, ACK_FSM;
    reg [31:0] mult;
    wire O_Fmult, U_Fmult;
    wire ACK_MULT;
    wire [31:0] MULT_RESULT;

        parameter P=32;
        parameter D = 5; 
        parameter width = 10;

FPU_Multiplication_Function #(.W(32),.EW(8),.SW(23)) Mult(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_MULT),
    .ack_FSM(ACK_FSM),//ACK_MULT),
    .Data_MX(mult),
    .Data_MY(32'b00111101010011001100110011001101),
    .round_mode(2'b00),
    .overflow_flag(O_Fmult),
    .underflow_flag(U_Fmult),
    .ready(ACK_MULT),
    .final_result_ieee(MULT_RESULT)
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
           mult = 0;
           Begin_MULT = 0;
           ACK_FSM = 0;
                      
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
   
                          mult = {$random};
                          Begin_MULT = 1;
                          ACK_FSM=1;
                          Cont_CLK = Cont_CLK + 1;
                          RST = 0;
                       end
                   else 
                       if(Cont_CLK ==2) 
                           begin
                              RST = 0;
                              Begin_MULT=0;
                              ACK_FSM=0;
                              Cont_CLK = Cont_CLK +1 ;
                           end 
                   else 
                       if(Cont_CLK ==750) 
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
