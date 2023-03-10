// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 16:49:46
// File Name    : uart_txctrl.v
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
// uart_txctrl
//    |---
// 
`timescale 1ns/1ps

module uart_txctrl #
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
// FIFO Read 
// ----------------------------------------------------------------------------
    output reg                      fifo_rd_en                  , 
    input                     [7:0] fifo_rd_data                , 
    input                           fifo_empty                  , 
// ----------------------------------------------------------------------------
// Send status
// ----------------------------------------------------------------------------
    input                           tx_busy                     , 
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    output reg                [7:0] driver_tx_data              , 
    output reg                      driver_tx_data_valid          
);

reg                                 fifo_rd_mask                ; 
reg                                 fifo_rd_data_valid          ; 

//===================================================================================
// Uart send control
//===================================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((fifo_empty == 1'b0) && (tx_busy == 1'b0))
                fifo_rd_mask <= #U_DLY 1'b1;
            else if(tx_busy == 1'b1)
                fifo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((fifo_empty == 1'b0) && (tx_busy == 1'b0) && (fifo_rd_mask == 1'b0))
                fifo_rd_en <= #U_DLY 1'b1;
            else
                fifo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fifo_rd_data_valid <= #U_DLY 1'b0;
    else 
        begin
            if((fifo_rd_en == 1'b1) && (fifo_empty == 1'b0))
                fifo_rd_data_valid <= #U_DLY 1'b1;
            else
                fifo_rd_data_valid <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        driver_tx_data <= #U_DLY 8'd0;
    else
        driver_tx_data <= #U_DLY fifo_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        driver_tx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(fifo_rd_data_valid == 1'b1)
                driver_tx_data_valid <= #U_DLY 1'b1;
            else
                driver_tx_data_valid <= #U_DLY 1'b0;
        end
end

endmodule




