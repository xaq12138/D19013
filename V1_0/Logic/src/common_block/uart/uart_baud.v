// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 16:39:25
// File Name    : uart_baud.v
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
// uart_baud
//    |---
// 
`timescale 1ns/1ps

module uart_baud #
(
    parameter                       U_DLY = 1                   ,    
    parameter                       DW    = 16                         
)
(
//-----------------------------------------------------------------------------------
// Clock & Reset
//-----------------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
//-----------------------------------------------------------------------------------
// Other Signals
//-----------------------------------------------------------------------------------
    input                  [DW-1:0] baud_rate                   , 
    output reg                      baud_en                       
);

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



