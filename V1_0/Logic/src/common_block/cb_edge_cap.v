// *********************************************************************************
// Project Name :
// Author       : libing
// Email        : lb891004@163.com
// Creat Time   : 2015/8/24 16:43:50
// File Name    : cb_edge_cap.v
// Module Name  : cb_edge_cap
// Called By    : 
// Abstract     :
//
// CopyRight(c) 2014, Zhimingda digital equipment Co., Ltd.. 
// All Rights Reserved
//
// *********************************************************************************
// Modification History:
// 1. initial
// *********************************************************************************/
// *************************
// MODULE DEFINITION
// *************************
`timescale 1 ns / 1 ns

module cb_edge_cap #(
    parameter U_DLY     = 1             
)
(
//-----------------------------------------------------------------------------------
// Golbal Signals
//-----------------------------------------------------------------------------------
    input               clk_sys                 ,   
    input               rst_n                   ,   
//-----------------------------------------------------------------------------------
// signal in
//-----------------------------------------------------------------------------------
    input               sig_in                  ,  
//-----------------------------------------------------------------------------------
// Result Signals
//-----------------------------------------------------------------------------------
    output reg          edge_r                  ,   
    output reg          edge_f                  ,   
    output reg          edge_rf                    
);

(*ASYNC_REG = "true"*)reg       sig_in_1dly                         ;   
(*ASYNC_REG = "true"*)reg       sig_in_2dly                         ;  
reg                             sig_in_3dly                         ;   

//===================================================================================
// Sync 
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        begin
            sig_in_1dly <= 1'b0;
            sig_in_2dly <= 1'b0;
            sig_in_3dly <= 1'b0;
        end
    else
        begin
            sig_in_1dly <= #U_DLY sig_in;
            sig_in_2dly <= #U_DLY sig_in_1dly;
            sig_in_3dly <= #U_DLY sig_in_2dly;
        end
end

//===================================================================================
// Edge Capture
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        edge_r <= #U_DLY 1'b0;
    else
        begin
            if ((sig_in_3dly == 1'b0) && (sig_in_2dly == 1'b1)) // Rising edge
                edge_r <= #U_DLY 1'b1;
            else
                edge_r <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        edge_f <= #U_DLY 1'b0;
    else
        begin
            if ((sig_in_3dly == 1'b1) && (sig_in_2dly == 1'b0)) // Falling edge
                edge_f <= #U_DLY 1'b1;
            else
                edge_f <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        edge_rf <= #U_DLY 1'b0;
    else
        begin
            if (sig_in_3dly != sig_in_2dly) // Falling edge &  Rising edge
                edge_rf <= #U_DLY 1'b1;
            else
                edge_rf <= #U_DLY 1'b0;
        end
end

endmodule
