`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2017 14:08:17
// Design Name: 
// Module Name: sistema_estimador
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


module sistema_estimador #(parameter N = 32)(
        //INPUTS
        input wire CLK,
        input wire [N-1:0] I,
        input wire [N-1:0] V,
        input wire RST,
        //OUTPUTS
        output wire ACK_THETA_IF, ACK_THETA_VF, // señales de revision, necesario quitarlas al final
        output wire [N-1:0] RESULT_IS,
        output wire [N-1:0] RESULT_ALPHA,
        output wire [N-1:0] RESULT_theta1,          // SEÑALES DE REVISION PARA SALIDAS
        output wire [N-1:0] RESULT_theta2
        );
        
             
        wire ACK_I,ACK_V,ACK_E,ACK_THETA_V,ACK_THETA_I,CLEAR;
        wire Begin_FSM_I,Begin_FSM_V,Begin_FSM_E,Begin_FSM_THETA_I,Begin_FSM_THETA_V, REG_IS, REG_ALPHA;
        wire [N-1:0] IG;
        wire [N-1:0] T_IPV;
        wire [N-1:0] RESULT_LN_NORM_I,RESULT_LN_NORM_V;
        wire [N-1:0] RESULT_E_I,RESULT_E_V;
        wire [N-1:0] RESULT_DESN_DESL_I,RESULT_DESN_DESL_V;
        
        assign IG=32'b01000000011111110101110000101001;
        
        assign ACK_THETA_IF = ACK_THETA_I;
        assign ACK_THETA_VF = ACK_THETA_V;        
        assign RESULT_theta1 = RESULT_E_V;
        assign RESULT_theta2 = RESULT_E_I;
        
        /*SUBST_IG_IPV S_IG_IPV( 
        .IG(IG), 
        .IPV(I), 
        .T(T_IPV)
        ); */


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
        .Yin(RESULT_LN_NORM_V),
        .Win(RESULT_LN_NORM_I),
        .estim1out(RESULT_E_I),
        .estim2out(RESULT_E_V),
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
        .START_I(Begin_FSM_I),
        .START_V(Begin_FSM_V),
        .START_E(Begin_FSM_E),
        .START_THETA_I(Begin_FSM_THETA_I),
        .START_THETA_V(Begin_FSM_THETA_V),
        .REG_THETA_I(REG_IS),
        .REG_THETA_V(REG_ALPHA),
        .CLEAR(CLEAR)
        );
        
        FF_D_L #(.N(N)) REG_i ( 
            .CLK(CLK), 
            .RST(RST),
            .EN(REG_IS), 
            .D(RESULT_DESN_DESL_I), 
            .Q(RESULT_IS)
            );
            
        FF_D_L #(.N(N)) REG_v ( 
            .CLK(CLK), 
            .RST(),
            .EN(REG_ALPHA), 
            .D(RESULT_DESN_DESL_V), 
            .Q(RESULT_ALPHA)
            );
        

            
endmodule
