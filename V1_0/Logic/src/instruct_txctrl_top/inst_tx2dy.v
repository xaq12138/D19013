// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 17:09:43
// File Name    : inst_tx2dy.v
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
// inst_tx2dy
//    |---
// 
`timescale 1ns/1ps

module inst_tx2dy #
(
    parameter                       U_DLY = 1                   
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    input                    [15:0] cfg_ins_length              , // 指令长度
// ----------------------------------------------------------------------------
// PCM TX Control
// ----------------------------------------------------------------------------
    input                   [511:0] dy_inst_data                , 
    input                           dy_inst_data_valid          , 
// ----------------------------------------------------------------------------
// PCM Instruct Data
// ----------------------------------------------------------------------------
    output reg              [127:0] dy_tx_data                  , 
    output reg                      dy_tx_data_valid              
);


// ============================================================================
// Instruct data to DY
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dy_tx_data <= #U_DLY 8'd0;
    else
        dy_tx_data <= #U_DLY dy_inst_data[511:384];
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dy_tx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(dy_inst_data_valid == 1'b1)
                dy_tx_data_valid <= #U_DLY 1'b1;
            else
                dy_tx_data_valid <= #U_DLY 1'b0;
        end
end

endmodule



