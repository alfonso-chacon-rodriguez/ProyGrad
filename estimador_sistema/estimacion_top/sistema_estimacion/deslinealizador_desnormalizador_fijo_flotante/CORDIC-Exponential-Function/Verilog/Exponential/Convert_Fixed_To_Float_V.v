`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2016 04:10:04 PM
// Design Name: 
// Module Name: Convert_Fixed_To_Float_V
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


module Convert_Fixed_To_Float_V(
    
        input wire CLK,               //CLOCK 
        input wire [31:0] FIXED,      // VALOR DEL NUMERO EN PUNTO FIJO 
        input wire EN_REG1,           // ENABLE PARA EL REGISTRO 1 QUE GUARDA EL NUMERO EN PUNTO FIJO
        input wire EN_REGmult,        // ENABLE PARA EL REGISTRO MULT QUE GUARDA EL VALOR A TRUNCAR 
        input wire LOAD,              // SELECCION CARGA REGISTRO DE DESPLAZAMIENTOS  
        input wire MS_1,              // SELECCIONA EL MUX PARA UN VALOR DIFERENTE O IGUAL A 26 SEGUN SEA EL CASO 
        input wire RST,
        input wire EN_REG2,

        output wire Bandcomp,         // INDICA SI EL EXPONENTE ES MAYOR QUE 26 
        output wire [31:0] FLOATOUT,  // CONTIENE EL RESULTADO EN COMA FIJA  
        output wire [7:0] Encd        // CONTIENE EL VALOR DEL PRIMER 1 SECUENCIA BINARIA 

    );

        parameter P = 32;
        parameter W = 8;
        wire [31:0] fixed; 
        wire [31:0] complemento;
        wire [31:0] MUXSIGN;
        wire [31:0] P_RESULT;
        wire [31:0] DESNORM;
        wire [7:0] Encoder;
        wire [31:0] mult;

FF_D #(.P(P)) REG_FIXED_I ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG1), 
        .D(FIXED), 
        .Q(fixed)
        );
        
Complement COMPLEMENTO2 (
        .a_i(fixed),     
        .twos_comp(complemento)
        );        
        
Mux_2x1_32Bits  MUX2x1_0_I ( 
        .MS(fixed[31]), 
        .D_0(fixed), 
        .D_1(complemento), 
        .D_out(MUXSIGN)
        );    
        
DESNORMALIZADOR_V DESNORMA_V(
        //.CLK(CLK),
        .A(MUXSIGN),  //entrada al desnormalizador 
        .Y(DESNORM)   //salida de la desnormalizacion en coma fija, coma en el bit 56
        );     

FF_D #(.P(P)) REG_FLOAT_mult ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REGmult), 
        //.D(MUXSIGN), 
        .D(DESNORM), 
        .Q(mult)
        );

Priority_Encoder OUTONE ( 
        .d_in(mult), //Valor truncado de la desnormalizaci�n [61:30]
        .d_out(Encoder) //Posicion del primer 1 en la secuencia binaria
        );         
               
        wire [31:0] FLOAT;
        wire [7:0] FLOATEXPONENT;
        wire [7:0] MUX1;
        wire [7:0] SUBT_1;
        wire [7:0] SUBT_2;
        wire [7:0] MUXSal8bits;

        assign Encd = Encoder[7:0];

Comparador_Mayor VALOR26_I(
        .CLK(CLK),
        .A(Encoder),
        .B(8'b00011010),//00011010 -- >26 
        .Out(Bandcomp)
        );

Barrel_Shifter #(.SWR(32),.EWR(8)) S_REG_I(
        .clk(CLK),
        .rst(RST),
        .load_i(LOAD),
        .Shift_Value_i(MUXSal8bits),
        .Shift_Data_i(mult),
        .Left_Right_i(~Bandcomp),
        .Bit_Shift_i(1'b0),
        .N_mant_o(P_RESULT)
        );
        
S_SUBT #(.P(W),.W(W)) SUBT_EXP_1_I ( 
        .A(Encoder), 
        .B(8'b00011010), 
        .Y(SUBT_1)
        );

S_SUBT #(.P(W),.W(W)) SUBT_EXP_2_I ( 
        .A(8'b00011010), 
        .B(Encoder), 
        .Y(SUBT_2)
        );
             
Mux_2x1_8Bits  MUX2x1_1_I ( 
        .MS(Bandcomp), 
        .D_0(SUBT_2), 
        .D_1(SUBT_1), 
        .D_out(MUX1)
        );

Mux_2x1_8Bits  MUX2x1_2_I ( 
        .MS(MS_1), 
        .D_0(8'b00000000), 
        .D_1(MUX1), 
        .D_out(MUXSal8bits)
        );
        
ADDT_8Bits #(.P(W),.W(W))  ADDT_EXPONENTE_I ( 
        .A(Encd), 
        .B(8'b01100101), 
        .Y(FLOATEXPONENT)
        );

assign FLOAT [31] = fixed [31];
assign FLOAT [30:23] = FLOATEXPONENT [7:0];  
assign FLOAT [22:0] = P_RESULT[25:3];
    
FF_D #(.P(P)) REG_FLOAT ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG2), 
        .D(FLOAT), 
        .Q(FLOATOUT)
        );

endmodule
