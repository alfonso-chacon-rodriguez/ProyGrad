`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2016 01:13:48 PM
// Design Name: 
// Module Name: Add_Subt
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


module Add_Subt_L
    #(parameter SWR=26) (
    input wire clk,
    input wire rst,
    input wire load_i,//Reg load input
    input wire Add_Sub_op_i,

    input wire [SWR-1:0] Data_A_i,

    input wire [SWR-1:0] PreData_B_i,  


/////////////////////////////////////////////////////////////

    output wire [SWR-1:0] Data_Result_o,
    output wire [SWR-1:0] P_o,
    output wire [SWR-1:1] Cn_o,
    output wire FSM_C_o
    );

    wire [SWR-1:0] Data_B;
    wire [SWR-1:0] S_to_D;
    wire [SWR-1:0] P_to_D;
    wire [SWR-1:1] C_to_D;
    wire Co_to_D;

     
    /////////////////////////////////////////7
    genvar j;
    for (j=0; j<SWR; j=j+1)begin

        assign Data_B[j] = PreData_B_i[j] ^ Add_Sub_op_i;

    end

    Full_Adder_PG_L #(.SWR(SWR)) AS_Module(
        .clk(clk),
        .rst(rst),
        .Op_A_i(Data_A_i),
        .Op_B_i(Data_B),
        .C_i(Add_Sub_op_i), //Carry in
        .S_o(S_to_D), // Solution out
        .Cn_o(C_to_D),
        .C_o(Co_to_D), //Carry out
        .P_o(P_to_D) //Propagate (for LZA)
    );

    RegisterAdd_L #(.W(SWR)) Add_Subt_Result(
        .clk (clk),
        .rst (rst),
        .load (load_i),
        .D (S_to_D),
        .Q (Data_Result_o)
        );

    RegisterAdd_L #(.W(SWR)) P_Result(
        .clk (clk),
        .rst (rst),
        .load (load_i),
        .D (P_to_D),
        .Q (P_o)
        );
      
    RegisterAdd_L #(.W(SWR-1)) C_Result(
                .clk (clk),
                .rst (rst),
                .load (load_i),
                .D (C_to_D),
                .Q (Cn_o)
                );  
    
    RegisterAdd_L #(.W(1)) Add_overflow_Result(
                .clk (clk),
                .rst (rst),
                .load (load_i),
                .D (Co_to_D),
                .Q (FSM_C_o)
                );
endmodule
