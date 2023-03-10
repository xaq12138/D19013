// +FHDR============================================================================/
// Author       : Huangjie
// Creat Time   : 2020/04/20 13:26:48
// File Name    : spi_baud_gen.v
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
// spi_baud_gen
//    |---
// 
`timescale 1ns/1ns

module spi_baud_gen #
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
// Baud Rate Config
// ----------------------------------------------------------------------------
    input                    [15:0] baud_rate                   , 
// ----------------------------------------------------------------------------
// Baud Rate
// ----------------------------------------------------------------------------
    output reg                      baud_en                       
);

reg                          [15:0] baud_cnt                    ; 

// ============================================================================
// Baud Rate Generate
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        baud_cnt <= #U_DLY 16'd0;
    else
        begin
            if(baud_cnt < baud_rate)
                baud_cnt <= #U_DLY baud_cnt + 16'd1;
            else
                baud_cnt <= #U_DLY 16'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        baud_en <= #U_DLY 1'b0;
    else
        begin
            if(baud_cnt == baud_rate)
                baud_en <= #U_DLY 1'b1;
            else
                baud_en <= #U_DLY 1'b0;
        end
end

endmodule 





