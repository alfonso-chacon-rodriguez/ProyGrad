`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2016 11:31:21 AM
// Design Name: 
// Module Name: multiplier
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


module multiplier
    # (parameter W = 32/*,level=5*/) (//level=log2(W)
    input wire clk,
    input wire [W-1:0] Data_A_i,
    input wire [W-1:0] Data_B_i,
    output wire [2*W-1:0] Data_S_o
    );
    
    //reg [W-1:0] aint,bint;
    reg [2*W-1:0] pdt_int;/*[level-1:0];*/
    //integer i;
    
    assign Data_S_o=pdt_int;//[level-1];
    
    always@(posedge clk)
    begin
        //aint<=Data_A_i;
        //bint<=Data_B_i;
        pdt_int<= Data_A_i*Data_B_i;
        //for (i=1;i<level;i=i+1)
            //pdt_int[i]<=pdt_int[i-1];
    end
    
endmodule

//module multiplier #(parameter W=32)(
//    input wire clk,
//    input wire [W-1:0] Data_A_i,
//    input wire [W-1:0] Data_B_i,
//    output reg [2*W-1:0] Data_S_o
//        );
     
//    //reg [W-1:0] a_in, b_in;
//    //wire [2*W-1:0] multi_reg;
//    reg [2*W-1:0] pipe1, pipe2, pipe3, pipe4, pipe5;
     
//    //assign multi_reg = a_in * b_in;
    
//    always @(posedge clk) begin
//            //a_in <= Data_A_i; b_in <= Data_B_i;
//            pipe1 <= Data_A_i*Data_B_i;
//            pipe2 <= pipe1;
//            pipe3 <= pipe2;
//            pipe4 <= pipe3;
//            pipe5 <= pipe4;
//            Data_S_o <= pipe5;
//    end
//    endmodule
