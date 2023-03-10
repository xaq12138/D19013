// *********************************************************************************
// Project Name :
// Author       : libing
// Email        : lb891004@163.com
// Creat Time   : 2015/8/24 16:10:39
// File Name    : cb_baud_gen.v
// Module Name  : cb_baud_gen
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
                                                     
//H : 1           clk_sys   
//L : baud_rate   clk_sys

module cb_baud_gen #(
    parameter U_DLY     = 1                     ,    
    parameter DW        = 16                         
)
(
//-----------------------------------------------------------------------------------
// Golbal Signals
//-----------------------------------------------------------------------------------
    input               clk_sys                 ,   
    input               rst_n                   ,   
//-----------------------------------------------------------------------------------
// Other Signals
//-----------------------------------------------------------------------------------
    input [DW-1:0]      baud_rate              ,   
    output reg          baud_en                
);

//***********************************************************************************
// Internal Register & Wire Define
//***********************************************************************************
reg [DW-1:0]                    baud_cnt                            ;   

//===================================================================================
// baud_cnt Counter
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        baud_cnt <= #U_DLY {DW{1'b0}};
    else
        begin
            if (baud_cnt < baud_rate)
                baud_cnt <= #U_DLY baud_cnt + {{(DW-1){1'b0}},1'b1};
            else
                baud_cnt <= #U_DLY {DW{1'b0}};
        end
end

//===================================================================================
// baud_en Generate
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        baud_en <= #U_DLY 1'b0;
    else
        begin
            if (baud_cnt < baud_rate)
                baud_en <= #U_DLY 1'b0;
            else
                baud_en <= #U_DLY 1'b1;
        end
end

endmodule
