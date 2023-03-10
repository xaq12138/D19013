// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/28 11:41:13
// File Name    : cb_sync.v
// Module Ver   : Vx.x
//
//
// All Rights Reserved
//
// ---------------------------------------------------------------------------------/
//
// Modification History:
// V1.0         initial
//
// -FHDR============================================================================/
// 
// cb_sync
//    |---
// 
`timescale 1ns/1ps



module cb_sync #(
    parameter  U_DLY      =  1      ,    
    parameter  WIDTH      =  16     ,
    parameter  INT_VALUE  =  16'h0   
)
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    input               clk_sys                 ,   
    input               rst_n                   ,   
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    input  [WIDTH-1:0]  dat_in                  ,   
    output [WIDTH-1:0]  dat_out	
);

//***********************************************************************************
// Internal Register & Wire Define
//***********************************************************************************
reg  [WIDTH-1:0]                dat_in_1dly                         ;   
reg  [WIDTH-1:0]                dat_in_2dly                         ;   

//===================================================================================
// Delay
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if (rst_n == 1'b0)
        begin
            dat_in_1dly <= INT_VALUE;
            dat_in_2dly <= INT_VALUE;
        end
    else
        begin
            dat_in_1dly <= dat_in;
            dat_in_2dly <= dat_in_1dly;
        end
end

assign dat_out = dat_in_2dly;

endmodule
