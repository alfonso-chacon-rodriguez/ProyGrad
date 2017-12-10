`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:01 08/27/2015 
// Design Name: 
// Module Name:    FPU_Add_Subtract_Function 
// Project Name: 
// Target Devices:   
// Tool versions: 
// Description: 
//
// Dependencies:  
//
// Revision: 
// Revision 0.01 - File Created 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FPU_Add_Subtract_Function_L
//Add/Subtract Function Parameters
	
   #(parameter W = 32, parameter EW = 8, parameter SW = 23,
		parameter SWR=26, parameter EWR = 5)  //Single Precision */
		
	/*#(parameter W = 64, parameter EW = 11, parameter SW = 52,
		parameter SWR = 55, parameter EWR = 6) //-- Double Precision */
	(
		//FSM Signals 
		input wire clk,
		input wire rst,
		input wire beg_FSM,
		input wire rst_FSM,
		
		//Oper_Start_in signals
		input wire [W-1:0] Data_X,
		input wire [W-1:0] Data_Y,
		input wire add_subt,
		 
		//Round signals signals
		input wire [1:0] r_mode,
		
		//OUTPUT SIGNALS
		output wire overflow_flag,
		output wire underflow_flag,
		output wire ready,
		output wire [W-1:0] final_result_ieee
    );



////////////op_start_in///////////////
wire FSM_op_start_in_load_a,FSM_op_start_in_load_b; 
wire [W-2:0] DMP, DmP;
wire real_op;
wire sign_final_result;
///////////Mux S-> exp_operation OPER_A_i//////////

wire FSM_selector_A;
//D0=DMP_o[W-2:W-EW-1] 
//D1=exp_oper_result
wire [EW-1:0] S_Oper_A_exp;

///////////Mux S-> exp_operation OPER_B_i//////////

wire [1:0] FSM_selector_B;
//D0=DmP_o[W-2:W-9/W-12]
//D1=LZA_output
wire [EW-1:0] S_Oper_B_exp;

///////////exp_operation///////////////////////////
wire FSM_exp_operation_load_diff, FSM_exp_operation_load_OU ,FSM_exp_operation_A_S;
//oper_A= S_Oper_A_exp
//oper_B= S_Oper_B_exp
wire [EW-1:0] exp_oper_result;

///////////Mux S-> Barrel shifter shift_Value//////

//ctrl = FSM_selector_B;
//D0=exp_oper_result
//D1=LZA_output
wire [EWR-1:0] S_Shift_Value;

///////////Mux S-> Barrel shifter Data_in//////

wire FSM_selector_C;
//D0={1'b1,DmP [SW-1:0], 2'b0}
//D1={Add_Subt_Data_output}
wire [SWR-1:0]S_Data_Shift;

///////////Barrel_Shifter//////////////////////////

wire FSM_barrel_shifter_load, FSM_barrel_shifter_L_R, FSM_barrel_shifter_B_S;
//Shift_Value=S_Shift_Value
//Data_in=S_Data_Shift
wire [SWR-1:0] Sgf_normalized_result;

//////////Mux S-> Add_Subt_Sgf op//////////////////
wire FSM_selector_D;
//D0=real_op
//D1= 1'b0
wire S_A_S_op;

//////////Mux S-> Add_Subt_Sgf OPER A//////////////////
//wire FSM_selector_D
//D0={1'b1, DMP[SW-1:0], 2'b00}
//D1= Norm_Shift_Data
wire [SWR-1:0] S_A_S_Oper_A;

//////////Mux S-> Add_Subt_Sgf OPER B//////////////////
//wire FSM_selector_D
//D0= Norm_Shift_Data
//D1= SWR'd1;
wire [SWR-1:0] S_A_S_Oper_B;

/////////ADD_Subt_sgf///////////////////////////////////


wire FSM_Add_Subt_Sgf_load, add_overflow_flag;
//Add_Subt_i=S_A_S_op
//Oper_A_i=S_A_S_Oper_A
//Oper_B_i=S_A_S_Oper_B
wire [SWR-1:0] Add_Subt_result;
wire [SWR-1:0] A_S_P;
wire [SWR-1:1] A_S_C;
//FSM_C_o=add_overflow_flag


//////////LZA///////////////////////////////////////////

wire FSM_LZA_load;
//P_i=A_S_P
//C_i=A_S_C
//A_S_op_i=S_A_S_op
wire [EWR-1:0] LZA_output;

/////////Deco_round///////////////////////////////////////

//Data_i=Sgf_normalized_result
//Round_Type=r_mode
//Sign_Result_i=sign_final_result
wire round_flag;

////////Final_result//////////////////////////////////////

wire FSM_Final_Result_load;

///////////////////////////////////////////////////////////////////////////////////

wire rst_int;


//////////////////////////////////////////////////////////////////////////////////
wire selector_A;
wire [1:0] selector_B;
wire load_b;
wire selector_C;
wire selector_D;

///////////////////////////////////////FSM/////////////////////////////////////////

FSM_Add_Subtract_L FS_Module(
    .clk(clk),                                                       //
    .rst(rst),                                                       //
    .rst_FSM(rst_FSM),                                               //
    .beg_FSM(beg_FSM),                                               //
	.zero_flag_i(zero_flag),                                         // 
    .real_op_i(real_op),                                             //
    .norm_iteration_i(FSM_selector_C),                               //
    .add_overflow_i(add_overflow_flag),                              //
    .round_i(round_flag),                                            //
	.load_1_o(FSM_op_start_in_load_a),                               //
    .load_2_o(FSM_op_start_in_load_b),                               //
    .load_3_o(FSM_exp_operation_load_diff),                               //
    .load_8_o(FSM_exp_operation_load_OU),
    .A_S_op_o(FSM_exp_operation_A_S),                                //
    .load_4_o(FSM_barrel_shifter_load),                              //
    .left_right_o(FSM_barrel_shifter_L_R),                           //
    .bit_shift_o(FSM_barrel_shifter_B_S),                            //
    .load_5_o(FSM_Add_Subt_Sgf_load),                                  //
    .load_6_o(FSM_LZA_load),                                           //
    .load_7_o(FSM_Final_Result_load),                                  // 
    .ctrl_a_o(selector_A),                                         //
    .ctrl_b_o(selector_B),                                         //
    .ctrl_b_load_o(load_b),
    .ctrl_c_o(selector_C),                                         //
    .ctrl_d_o(selector_D),                                         //
	.rst_int(rst_int),                                               //
	.ready(ready)                                                    //
    );
	 



/////////////////////////////Selector's registers//////////////////////////////

RegisterAdd_L #(.W(1)) Sel_A ( //Selector_A register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_A), 
    .D(1'b1), 
    .Q(FSM_selector_A)
    );

RegisterAdd_L #(.W(1)) Sel_C ( //Selector_C register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_C), 
    .D(1'b1), 
    .Q(FSM_selector_C)
    );
    
RegisterAdd_L #(.W(1)) Sel_D ( //Selector_D register
        .clk(clk), 
        .rst(rst_int), 
        .load(selector_D), 
        .D(1'b1), 
        .Q(FSM_selector_D)
        );
        
RegisterAdd_L #(.W(2)) Sel_B ( //Selector_D register
                .clk(clk), 
                .rst(rst_int), 
                .load(load_b), 
                .D(selector_B), 
                .Q(FSM_selector_B)
                );
                            
////////////////////////////////////////////////////////
	 
//MODULES///////////////////////////

////////////////////Oper_Start_in//////////////////7

//This Module classify both operands
//in bigger and smaller magnitude, Calculate the result' Sign bit and calculate the real
//operation for the execution///////////////////////////////

Oper_Start_In_L #(.W(W)) Oper_Start_in_module (
    .clk(clk), 
    .rst(rst_int),
    .load_a_i(FSM_op_start_in_load_a),
    .load_b_i(FSM_op_start_in_load_b),
    .add_subt_i(add_subt),
    .Data_X_i(Data_X),
    .Data_Y_i(Data_Y),
    .DMP_o(DMP),
    .DmP_o(DmP),
    .zero_flag_o(zero_flag),
    .real_op_o(real_op),
    .sign_final_result_o(sign_final_result)
    );

///////////////////////////////////////////////////////////


///////////Mux exp_operation OPER_A_i//////////

Multiplexer_AC_L #(.W(EW)) Exp_Oper_A_mux(
        .ctrl(FSM_selector_A),
        .D0 (DMP[W-2:W-EW-1]),
        .D1 (exp_oper_result),
        .S (S_Oper_A_exp)
    );

///////////Mux exp_operation OPER_B_i//////////
generate
    case(EW)
        8:begin
            Mux_3x1_L #(.W(EW)) Exp_Oper_B_mux(
                .ctrl(FSM_selector_B),
                .D0 (DmP[W-2:W-EW-1]),
                .D1 ({3'b000,LZA_output}),
                .D2(8'd1),
                .S(S_Oper_B_exp)
            );
        end
        default:begin
            Mux_3x1_L #(.W(EW)) Exp_Oper_B_mux(
                .ctrl(FSM_selector_B),
                .D0 (DmP[W-2:W-EW-1]),
                .D1({5'b00000,LZA_output}),
                .D2(11'd1),
                .S(S_Oper_B_exp)
            );
        end
    endcase
endgenerate

///////////exp_operation///////////////////////////

Exp_Operation_L #(.EW(EW)) Exp_Operation_Module(
    .clk(clk), 
    .rst(rst_int),
    .load_a_i(FSM_exp_operation_load_diff),
    .load_b_i(FSM_exp_operation_load_OU),
    .Data_A_i(S_Oper_A_exp),
    .Data_B_i(S_Oper_B_exp),
    .Add_Subt_i(FSM_exp_operation_A_S),
    .Data_Result_o(exp_oper_result),
    .Overflow_flag_o(overflow_flag),
    .Underflow_flag_o(underflow_flag)
    );


//////////Mux Barrel shifter shift_Value/////////////////

generate
    case(EW)
        8:begin
            Mux_3x1_L #(.W(EWR)) Barrel_Shifter_S_V_mux(
                .ctrl(FSM_selector_B),
                .D0 (exp_oper_result[EWR-1:0]),
                .D1 (LZA_output),
                .D2 (5'd1),
                .S(S_Shift_Value)
            );
        end
        default:begin
            Mux_3x1_L #(.W(EWR)) Barrel_Shifter_S_V_mux(
                .ctrl(FSM_selector_B),
                .D0 (exp_oper_result[EWR-1:0]),
                .D1 (LZA_output),
                .D2 (6'd1),
                .S(S_Shift_Value)
            );
        end 
    endcase
endgenerate

///////////Mux Barrel shifter Data_in//////

Multiplexer_AC_L #(.W(SWR)) Barrel_Shifter_D_I_mux(
    .ctrl(FSM_selector_C),
    .D0 ({1'b1,DmP[SW-1:0],2'b00}),
    .D1 (Add_Subt_result),
    .S (S_Data_Shift)
    );

///////////Barrel_Shifter//////////////////////////

Barrel_Shifter_L #(.SWR(SWR),.EWR(EWR)) Barrel_Shifter_module (
    .clk(clk), 
    .rst(rst_int),
    .load_i(FSM_barrel_shifter_load),
    .Shift_Value_i(S_Shift_Value),
    .Shift_Data_i(S_Data_Shift),
    .Left_Right_i(FSM_barrel_shifter_L_R),
    .Bit_Shift_i(FSM_barrel_shifter_B_S),
    .N_mant_o(Sgf_normalized_result)
    );


//////////Mux Add_Subt_Sgf op//////////////////

Multiplexer_AC_L #(.W(1)) Add_Sub_Sgf_op_mux(
    .ctrl(FSM_selector_D),
    .D0 (real_op),
    .D1 (1'b0),
    .S (S_A_S_op)
    );

//////////Mux Add_Subt_Sgf oper A//////////////////

Multiplexer_AC_L #(.W(SWR)) Add_Sub_Sgf_Oper_A_mux(
    .ctrl(FSM_selector_D),
    .D0 ({1'b1,DMP[SW-1:0],2'b00}),
    .D1 (Sgf_normalized_result),
    .S (S_A_S_Oper_A)
    );

//////////Mux Add_Subt_Sgf oper B//////////////////
generate
    case (W)
        32:begin
            Multiplexer_AC_L #(.W(SWR)) Add_Sub_Sgf_Oper_A_mux(
                .ctrl(FSM_selector_D),
                .D0 (Sgf_normalized_result),
                .D1 (26'd1),
                .S (S_A_S_Oper_B)
                );
            end
        default:begin
             Multiplexer_AC_L #(.W(SWR)) Add_Sub_Sgf_Oper_A_mux(
                       .ctrl(FSM_selector_D),
                       .D0 (Sgf_normalized_result),
                       .D1 (55'd1),
                       .S (S_A_S_Oper_B)
                       );
            end
       endcase
endgenerate

/////////ADD_Subt_sgf///////////////////////////////////

Add_Subt_L #(.SWR(SWR)) Add_Subt_Sgf_module(
    .clk(clk), 
    .rst(rst_int),
    .load_i(FSM_Add_Subt_Sgf_load),
    .Add_Sub_op_i(S_A_S_op),
    .Data_A_i(S_A_S_Oper_A),
    .PreData_B_i(S_A_S_Oper_B),
    .Data_Result_o(Add_Subt_result),
    .P_o(A_S_P),
    .Cn_o(A_S_C),
    .FSM_C_o(add_overflow_flag)
    );

//////////LZA///////////////////////////////////////////

LZA_L #(.SWR(SWR),.EWR(EWR)) Leading_Zero_Anticipator_Module (
    .clk(clk), 
    .rst(rst_int),
    .load_i(FSM_LZA_load),
    .P_i(A_S_P),
    .C_i(A_S_C),
    .A_S_op_i(S_A_S_op),
    .Shift_Value_o(LZA_output)
    );

/////////Deco_round///////////////////////////////////////

Round_Sgf_Dec_L Rounding_Decoder(
    .clk(clk),
    .Data_i(Sgf_normalized_result[1:0]),
    .Round_Type_i(r_mode),
    .Sign_Result_i(sign_final_result),
    .Round_Flag_o(round_flag)
    );

////////Final_result//////////////////////////////////////

Tenth_Phase_L #(.W(W),.EW(EW),.SW(SW)) final_result_ieee_Module(
    .clk(clk), 
    .rst(rst_int),
    .load_i(FSM_Final_Result_load),
    .sel_a_i(overflow_flag),
    .sel_b_i(underflow_flag),
    .sign_i(sign_final_result),
    .exp_ieee_i(exp_oper_result),
    .sgf_ieee_i(Sgf_normalized_result[SWR-2:2]),
    .final_result_ieee_o(final_result_ieee)
    );

endmodule
