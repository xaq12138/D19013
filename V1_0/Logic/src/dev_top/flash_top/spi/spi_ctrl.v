// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/20 21:54:57
// File Name    : spi_ctrl.v
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
// spi_txfifo_rdctrl
//    |---
// 
`timescale 1ns/1ns

module spi_ctrl #
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
// TX-FIFO Read Control
// ----------------------------------------------------------------------------
    output reg                      txfifo_rd_en                , 
    input                    [15:0] txfifo_rd_data              , 
    input                           txfifo_empty                , 
// ----------------------------------------------------------------------------
// SPI Status
// ----------------------------------------------------------------------------
    output reg                      bus_tx_busy                 , 
// ----------------------------------------------------------------------------
// SPI TX Control
// ----------------------------------------------------------------------------
    output reg                      tx_en                       , 
    output reg                [3:0] tx_cmd                      , // bit0 --> write(0)/read(1),bit1 --> last byte(1),thers --> reserved.
    output reg                [7:0] tx_data                     , 
    input                           tx_busy                       
);

reg                                 txfifo_rd_mask              ; 
reg                                 txfifo_rd_data_valid        ; 

// ============================================================================
// Read Data From TX-FIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txfifo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((txfifo_empty == 1'b0) && (tx_busy == 1'b0))
                txfifo_rd_mask <= #U_DLY 1'b1;
            else if(tx_busy == 1'b1)
                txfifo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txfifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((txfifo_empty == 1'b0) && (tx_busy == 1'b0) && (txfifo_rd_mask == 1'b0))
                txfifo_rd_en <= #U_DLY 1'b1;
            else
                txfifo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txfifo_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((txfifo_rd_en == 1'b1) && (txfifo_empty == 1'b0))
                txfifo_rd_data_valid <= #U_DLY 1'b1;
            else
                txfifo_rd_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// SPI TX Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_en <= #U_DLY 1'b0;
    else
        begin
            if(txfifo_rd_data_valid == 1'b1)
                tx_en <= #U_DLY 1'b1;
            else
                tx_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_cmd <= #U_DLY 4'd0;
    else
        tx_cmd <= #U_DLY txfifo_rd_data[11:8];
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_data <= #U_DLY 8'd0;
    else
        tx_data <= #U_DLY txfifo_rd_data[7:0];
end

// ============================================================================
// SPI Status
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        bus_tx_busy <= #U_DLY 1'b0;
    else
        begin
            if(txfifo_empty == 1'b0)
                bus_tx_busy <= #U_DLY 1'b1;
            else if((tx_busy == 1'b0) && (txfifo_rd_mask == 1'b0))
                bus_tx_busy <= #U_DLY 1'b0;
            else
                ;
        end
end

endmodule



