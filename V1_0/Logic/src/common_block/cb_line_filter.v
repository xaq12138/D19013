// *********************************************************************************
// Project Name :
// Author       : libing
// Email        : lb891004@163.com
// Creat Time   : 2015/8/27 13:48:27
// File Name    : cb_line_filter.v
// Module Name  : cb_line_filter
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

module cb_line_filter #(
    parameter U_DLY     = 1                      
)    
( 
//-----------------------------------------------------------------------------------
// Golbal Signals
//-----------------------------------------------------------------------------------
    input               clk_sys                 ,   
    input               rst_n                   , 
//-----------------------------------------------------------------------------------
// filter paramter
//-----------------------------------------------------------------------------------
    input  [31:0]       filter_cnt              ,
//-----------------------------------------------------------------------------------
// line signal
//-----------------------------------------------------------------------------------
    input               sig_in                  ,
    output reg          sig_out                
);

//***********************************************************************************
// Internal Register & Wire Define
//***********************************************************************************
reg [31:0]                      cnt_tmp                             ;   
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
// Counter
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        cnt_tmp <= #U_DLY 31'h0;
    else
        begin
            if (sig_in_3dly != sig_in_2dly)
                cnt_tmp <= #U_DLY 16'h0;
            else 
                begin
                    if (cnt_tmp < filter_cnt)
                        cnt_tmp <= #U_DLY cnt_tmp + 31'h1; 
                    else
                        ;
                end
        end
end

//===================================================================================
// Output process
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        sig_out <= #U_DLY 1'b0;
    else
        begin
            if ((cnt_tmp >= (filter_cnt - 1)) && (sig_in_3dly == sig_in_2dly))
                sig_out <= #U_DLY sig_in_2dly;
            else
                ;
        end
end

endmodule           
