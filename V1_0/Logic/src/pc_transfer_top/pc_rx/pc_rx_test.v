// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:39:45
// File Name    : pc_rx_test.v
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
// pc_rx_test
//    |---
// 
`timescale 1ns/1ns

module pc_rx_test # 
(
    parameter               U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
//    output reg                      fdram_rd_req                , 
//    input                           fdram_rd_ack                , 
//    output reg                      fdram_rd_done               ,  
//    output reg               [11:0] fdram_rd_addr               , 
//    input                     [7:0] fdram_rd_data               , 
// ----------------------------------------------------------------------------
// Frame Info Fifo Read Port
// ----------------------------------------------------------------------------
    output reg                      fififo_rd_en                , 
    input                    [71:0] fififo_rd_data              , 
    input                           fififo_rd_data_valid        , 
    input                           fififo_empty                , 
// ----------------------------------------------------------------------------
// Test Pulse
// ----------------------------------------------------------------------------
    output reg                      test_pulse                    
);

reg                                 fififo_rd_mask              ; 
reg                                 step_en                     ; 

// ============================================================================
// Read the pakadge info.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fififo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b0) && (fififo_empty == 1'b0))
                fififo_rd_mask <= #U_DLY 1'b1;
            else if(step_en == 1'b1)
                fififo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end 
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b0) && (fififo_empty == 1'b0) && (fififo_rd_mask == 1'b0))
                fififo_rd_en <= #U_DLY 1'b1;
            else
                fififo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if(fififo_rd_en == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if(fififo_rd_data_valid == 1'b1)
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

// ============================================================================
// Generate test pulse
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        test_pulse <= #U_DLY 1'b0;
    else
        begin
            if((fififo_rd_data_valid == 1'b1) && (fififo_rd_data[39:32] == 8'h80))
                test_pulse <= #U_DLY 1'b1;
            else
                test_pulse <= #U_DLY 1'b0;
        end
end

endmodule



