// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 17:31:56
// File Name    : inst_tx2pcm.v
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
// inst_tx2pcm
//    |---
// 
`timescale 1ns/1ps

module inst_tx2pcm #
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
    input                   [511:0] pcm_inst_data               , 
    input                           pcm_inst_data_valid         , 
// ----------------------------------------------------------------------------
// PCM Instruct Data
// ----------------------------------------------------------------------------
    output reg              [511:0] pcm_tx_data                 , 
    output reg                      pcm_tx_data_valid             
);

// ============================================================================
// Instruct data to PCM
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pcm_tx_data <= #U_DLY 512'd0;
    else
        pcm_tx_data <= #U_DLY pcm_inst_data[511:0];
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pcm_tx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(pcm_inst_data_valid == 1'b1)
                pcm_tx_data_valid <= #U_DLY 1'b1;
            else
                pcm_tx_data_valid <= #U_DLY 1'b0;
        end
end

endmodule
