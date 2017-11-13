`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2017 08:40:51
// Design Name: 
// Module Name: SIST_ESTIMADOR
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


module SIST_ESTIMADOR #(parameter N = 32)(
        //INPUTS
        input wire CLK,
        input wire [N-1:0] I,
        
        //input wire [N-1:0] Y,                   // SEÑAL AGREGADA PARA COMPROBAR COMPORTAMIENTO DE ESTIMADOR !!!! QUITAR!!!!
        
        input wire [N-1:0] V,
        input wire [N-1:0] EXP,
        input wire RST,
        input wire ACK_CAS_I,ACK_CAS_V,
        //OUTPUTS
        output wire ACK_THETA_IF, ACK_THETA_VF, 
        output wire [N-1:0] RESULT_IS,
        output wire [N-1:0] RESULT_ALPHA,
        output wire [N-1:0] RESULT_LIN_I,          // SEÑALES DE REVISION PARA SALIDAS !!!! QUITAR!!!!
        output wire [N-1:0] RESULT_V
        );
        
        reg [N-1:0] aux, aux1, aux2;     
        wire ACK_I,ACK_V,ACK_E,ACK_THETA_V,ACK_THETA_I,CLEAR;
        wire Begin_FSM_I,Begin_FSM_V,Begin_FSM_E,Begin_FSM_THETA_I,Begin_FSM_THETA_V, REG_IS, REG_ALPHA;
        wire [N-1:0] LN=suma(EXP,RESULT_LN_NORM_I);
        wire [N-1:0] RESULT_LN_NORM_I,RESULT_LN_NORM_V;
        wire [N-1:0] RESULT_E_I,RESULT_E_V;
        wire [N-1:0] RESULT_DESN_DESL_I,RESULT_DESN_DESL_V;
        
        
        assign ACK_THETA_IF = REG_IS;
        assign ACK_THETA_VF = REG_ALPHA;        
        assign RESULT_LIN_I = RESULT_E_I;
        assign RESULT_V = RESULT_E_V;
        //assign RESULT_LIN_I = LN;
        //assign RESULT_V = RESULT_LN_NORM_V;


        LINEALIZADOR_NORMALIZADOR LIN_NORM(
        // Input Ports - Single Bit
        .Begin_FSM_I    (Begin_FSM_I), 
        .Begin_FSM_V    (Begin_FSM_V), 
        .CLK            (CLK),         
        .RST_LN_FF      (CLEAR),   
        // Input Ports - Busses
        //.I        (T_IPV),     
        .I        (I),     
        .V        (V),     
        // Output Ports - Single Bit
        .ACK_I          (ACK_I),       
        .ACK_V          (ACK_V),       
        // Output Ports - Busses
        .RESULT_I (RESULT_LN_NORM_I),
        .RESULT_V (RESULT_LN_NORM_V)
        // InOut Ports - Single Bit
        // InOut Ports - Busses
        );
        
        
        base ESTIMADOR(
        .clk(CLK),
        .reset(RST),
        .start(Begin_FSM_E),
        //.Y(RESULT_LN_NORM_I),
        .Y(LN),
        .V(RESULT_LN_NORM_V),
        .theta_1(RESULT_E_V),
        .theta_2(RESULT_E_I),
        .flag(ACK_E)
        );
        
        
        
        // Instantiate the Unit Under Test (UUT)
        DESNORMALIZADOR_DESLINEALIZADOR DESNORM_DESLIN(
        .CLK(CLK),
        .I(RESULT_E_I),
        .V(RESULT_E_V),
        .RST_EX_FF(CLEAR),
        .Begin_FSM_I(Begin_FSM_THETA_I),
        .Begin_FSM_V(Begin_FSM_THETA_V),
        .ACK_I(ACK_THETA_I),
        .ACK_V(ACK_THETA_V),
        //      .U_F(U_F),
        //      .O_F(O_F),
        .RESULT_I(RESULT_DESN_DESL_I),
        .RESULT_V(RESULT_DESN_DESL_V)
        );
        
        FSM_control_flujo_datos CONTROL(
        .CLK(CLK),
        .RESET(RST),
        .ACK_I(ACK_I),
        .ACK_V(ACK_V),
        .ACK_E(ACK_E),
        .ACK_THETA_I(ACK_THETA_I),
        .ACK_THETA_V(ACK_THETA_V),
        .ACK_CAS_I(ACK_CAS_I),
        .ACK_CAS_V(ACK_CAS_V),
        .START_I(Begin_FSM_I),
        .START_V(Begin_FSM_V),
        .START_E(Begin_FSM_E),
        .START_THETA_I(Begin_FSM_THETA_I),
        .START_THETA_V(Begin_FSM_THETA_V),
        .REG_THETA_I(REG_IS),
        .REG_THETA_V(REG_ALPHA),
        .CLEAR(CLEAR)
        );
        
        FF_D_L #(.P(N)) REG_i ( 
            .CLK(CLK), 
            .RST(RST),
            .EN(REG_IS), 
            .D(RESULT_DESN_DESL_I), 
            .Q(RESULT_IS)
            );
            
        FF_D_L #(.P(N)) REG_v ( 
            .CLK(CLK), 
            .RST(),
            .EN(REG_ALPHA), 
            .D(RESULT_DESN_DESL_V), 
            .Q(RESULT_ALPHA)
            );
        
        function  [N-1:0] suma(input signed [N-1:0] num1, num2);//Subrutina de suma
        begin
           aux = 32'h00000000;
           aux1 = 32'hffffffff;
           aux2 = num1 + num2;
           suma = (num1[N-1]==0 && num2[N-1]==0 && aux2[N-1]==1) ? {1'b0,aux1[N-2:0]}: //Si hay overflow
                         (num1[N-1]==1 && num2[N-1]==1 && aux2[N-1]==0) ? {1'b1,aux[N-2:0]}: //Si hay underflow
                          aux2; //Si no hay nada
        end
        endfunction
            
endmodule