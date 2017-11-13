`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pablo Gomez Ramirez
// 
// Create Date: 19.09.2017 15:33:57
// Design Name: 
// Module Name: CAS
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


module CAS #(parameter N=32, M=12, Kv=32'h41ad999a, Ki=32'h40800000, Ig=32'h407f5c29, ln2=32'h3f317218 )//Kv=21.7 Ki=4 Ig=3.99
(
        //INPUTS
        input wire CLK,
        input wire [M-1:0] I,
        input wire [M-1:0] V,
        input wire RST,
        input wire ACK_THETA_I, ACK_THETA_V, EOC,
        //OUTPUTS
        output wire ACK_CAS_I,ACK_CAS_V, START_ADC,
        //output wire [N-1:0] RESULT_I,
        output wire [N-1:0] EXP,
        output wire [N-1:0] MANTISSA,
        output wire [N-1:0] RESULT_V
        );
    
    wire [N-1:0] RESULT_ADC_V, RESULT_ADC_I, RESULT_REG_ADC_V, RESULT_REG_ADC_I, RESULT_MULT_I, RESULT_MULT_V, RESULT_REG_MULT_I, RESULT_SUBS_I, RESULT_T;// EXP;
    wire ACK_MULT_I, ACK_SUBS_I, EN_REG_ADC_I, EN_REG_ADC_V, Begin_FSM_MULT_I, Begin_FSM_MULT_V, ACK_FSM_MULT_I, ACK_FSM_MULT_V, EN_REG_MULT_I;
    wire EN_REG_MULT_V, Begin_FSM_SUBS_I, ACK_FSM_SUBS_I, EN_REG_SUBS_I, Begin_FSM_MULT_LN2, ACK_FSM_MULT_LN2, ACK_MULT_LN2, Begin_SUBS_EXP, ACK_SUBS_EXP;
    
        ADC_VALUE_ROM MEMORIA ( 
        //.clk(clk),
        .reset  (RST), 
        .din_i (I),
        .din_v (V),
        .dout_v (RESULT_ADC_V),
        .dout_i (RESULT_ADC_I)
        );
        
        
        FF_D_L #(.P(N)) REG_ADC_I ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG_ADC_I), 
        .D(RESULT_ADC_I), 
        .Q(RESULT_REG_ADC_I)
        );
        
        
        FF_D_L #(.P(N)) REG_ADC_V ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG_ADC_V), 
        .D(RESULT_ADC_V), 
        .Q(RESULT_REG_ADC_V)
        );
        
        
        FPU_Multiplication_Function #(.W(32),.EW(8),.SW(23)) MULT_CONSTANTE_I(
        .clk(CLK),
        .rst(RST),
        .beg_FSM(Begin_FSM_MULT_I),
        .ack_FSM(ACK_FSM_MULT_I),
        .Data_MX(RESULT_REG_ADC_I),
        .Data_MY(Ki),// CONSTANTE K_i que compensa el amplificador analógico que acondiciona la señal K_i=4
        .round_mode(2'b00),
        .overflow_flag(),
        .underflow_flag(),
        .ready(ACK_MULT_I),
        .final_result_ieee(RESULT_MULT_I)
        );
            
            
        FPU_Multiplication_Function #(.W(32),.EW(8),.SW(23)) MULT_CONSTANTE_V(
        .clk(CLK),
        .rst(RST),
        .beg_FSM(Begin_FSM_MULT_V),
        .ack_FSM(ACK_FSM_MULT_V),
        .Data_MX(RESULT_REG_ADC_V),
        .Data_MY(Kv),// CONSTANTE K_v que compensa el amplificador analógico que acondiciona la señal K_v=21.7
        .round_mode(2'b00),
        .overflow_flag(),
        .underflow_flag(),
        .ready(ACK_MULT_V),
        .final_result_ieee(RESULT_MULT_V)
        );
        
        
        FF_D_L #(.P(N)) REG_MULT_I ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG_MULT_I), 
        .D(RESULT_MULT_I), 
        .Q(RESULT_REG_MULT_I)
        );
        
        
        FF_D_L #(.P(N)) REG_MULT_V ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG_MULT_V), 
        .D(RESULT_MULT_V), 
        .Q(RESULT_V)
        );
        
        
        FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUSBS_I(
        .clk(CLK),
        .rst(RST),
        .beg_FSM(Begin_FSM_SUBS_I),
        .ack_FSM(ACK_FSM_SUBS_I),
        .Data_X(Ig),                //se coloca la constante Ig. 
        .Data_Y(RESULT_REG_MULT_I),
        .add_subt(1'b1),                                            //SIEMPRE restara, por lo tanto su valor sera 1'b1=resta
        .r_mode(2'b00),
        .overflow_flag(),
        .underflow_flag(),
        .ready(ACK_SUBS_I),
        .final_result_ieee(RESULT_SUBS_I)
        );
           
        
        FF_D_L #(.P(N)) REG_SUBS_I ( 
        .CLK(CLK), 
        .RST(RST),
        .EN(EN_REG_SUBS_I), 
        .D(RESULT_SUBS_I), 
        .Q(RESULT_T)
        );
        
        RESTA_EXPONENTE_MANTISSA RESTA_EXP_MANT(
        .CLK(CLK),
        .T(RESULT_T),
        .RST(RST),
        .Begin_SUBS_EXP(Begin_SUBS_EXP),
        .ACK_SUBS_EXP(ACK_SUBS_EXP),
        .MANTISSA(MANTISSA),
        .EXP(EXP)
        );
    
/*        FPU_Multiplication_Function #(.W(32),.EW(8),.SW(23)) MULT_LN_2(
        .clk(CLK),
        .rst(RST),
        .beg_FSM(Begin_FSM_MULT_LN2),
        .ack_FSM(ACK_FSM_MULT_LN2),
        .Data_MX(EXP),
        .Data_MY(ln2),
        .round_mode(2'b00),
        .overflow_flag(),
        .underflow_flag(),
        .ready(ACK_MULT_LN2),
        .final_result_ieee(RESULT_MULT_LN2)
        ); */ 
       
        FSM_CAS CONTROL_CAS(
        .CLK(CLK),
        .RESET(RST),
        .EOC(EOC),
        .ACK_MULT_I(ACK_MULT_I),
        .ACK_MULT_V(ACK_MULT_V),
        //.ACK_MULT_LN2(ACK_MULT_LN2),
        .ACK_SUBS_I(ACK_SUBS_I),
        .ACK_SUBS_EXP(ACK_SUBS_EXP),
        .ACK_THETA_I(ACK_THETA_I),
        .ACK_THETA_V(ACK_THETA_V),
        .EN_REG_ADC_I(EN_REG_ADC_I),
        .EN_REG_ADC_V(EN_REG_ADC_V),
        .Begin_FSM_MULT_I(Begin_FSM_MULT_I),
        .Begin_FSM_MULT_V(Begin_FSM_MULT_V),
        //.Begin_FSM_MULT_LN2(Begin_FSM_MULT_LN2),
        .Begin_SUBS_EXP(Begin_SUBS_EXP),
        .ACK_FSM_MULT_I(ACK_FSM_MULT_I),
        .ACK_FSM_MULT_V(ACK_FSM_MULT_V),
        //.ACK_FSM_MULT_LN2(ACK_FSM_MULT_LN2),
        .EN_REG_MULT_I(EN_REG_MULT_I),
        .EN_REG_MULT_V(EN_REG_MULT_V),
        .Begin_FSM_SUBS_I(Begin_FSM_SUBS_I),
        .ACK_FSM_SUBS_I(ACK_FSM_SUBS_I),
        .EN_REG_SUBS_I(EN_REG_SUBS_I),
        .ACK_CAS_I(ACK_CAS_I),
        .ACK_CAS_V(ACK_CAS_V),
        .START_ADC(START_ADC)
        );
        
endmodule
