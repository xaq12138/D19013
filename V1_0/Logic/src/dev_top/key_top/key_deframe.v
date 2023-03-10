// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 17:31:50
// File Name    : key_deframe.v
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
// key_deframe
//    |---
// 
`timescale 1ns/1ps

module key_deframe #
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
// Key Data
// ----------------------------------------------------------------------------
    input                    [15:0] key_data                    , 
    input                           key_data_valid              , 
// ----------------------------------------------------------------------------
// Key Instruct
// ----------------------------------------------------------------------------
    output reg               [15:0] key_instruct                , 
    output reg                      key_instruct_valid            
);

// ============================================================================
// Key Instruct Deframe
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        key_instruct <= #U_DLY 16'd0;
    else
        case(key_data[4:0])
            5'h1e   : key_instruct <= #U_DLY 16'd0;
            5'h1d   : key_instruct <= #U_DLY 16'd1;
            5'h1b   : key_instruct <= #U_DLY 16'd2;
            5'h17   : key_instruct <= #U_DLY 16'd3;
            5'h0f   : key_instruct <= #U_DLY 16'd4;
            default : key_instruct <= #U_DLY 16'hffff;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        key_instruct_valid <= #U_DLY 1'b0;
    else
        begin
            if(key_data_valid == 1'b1)
                key_instruct_valid <= #U_DLY 1'b1;
            else
                key_instruct_valid <= #U_DLY 1'b0;
        end
end

endmodule




