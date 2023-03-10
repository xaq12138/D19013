// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/31 11:22:11
// File Name    : slr_rx_cfg.v
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
// slr_rx_cfg
//    |---
// 
`timescale 1ns/1ps

module slr_rx_cfg #
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
// Uart RX Data
// ----------------------------------------------------------------------------
    input                     [7:0] uart_rx_data                , 
    input                           uart_rx_valid               , 
// ----------------------------------------------------------------------------
// Uart Data Buffer & FIFO (FWFT)
// ----------------------------------------------------------------------------
    output reg                      dram_wr_en                  , 
    output reg               [11:0] dram_wr_addr                , 
    output reg                [7:0] dram_wr_data                , 

    output reg               [11:0] dram_rd_addr                , 
    input                     [7:0] dram_rd_data                , 


    output reg                      ififo_wr_en                 , 
    output reg               [11:0] ififo_wr_data               , 

    output reg                      ififo_rd_en                 , 
    input                    [11:0] ififo_rd_data               , 
    input                           ififo_empty                 , 
// ----------------------------------------------------------------------------
// SLR Config RX Data
// ----------------------------------------------------------------------------
    output reg                [7:0] slr_rxcfg_data              , 
    output reg                      slr_rxcfg_data_valid          
);

reg                           [7:0] header_h                    ; 

reg                                 wrstep_en                   ; 
reg                           [3:0] wrstep_cnt                  ; 

reg                                 rdstep_en                   ; 
reg                           [3:0] rdstep_cnt                  ; 

// ============================================================================
// Write data to buffer
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dram_wr_en <= #U_DLY 1'b0;
    else
        begin
            if(uart_rx_valid == 1'b1)
                dram_wr_en <= #U_DLY 1'b1;
            else
                dram_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dram_wr_addr <= #U_DLY 12'd0;
    else
        begin
            if(dram_wr_en == 1'b1)
                dram_wr_addr <= #U_DLY dram_wr_addr + 12'd1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dram_wr_data <= #U_DLY 8'd0;
    else
        dram_wr_data <= #U_DLY uart_rx_data;
end

// ============================================================================
// Look for header
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        header_h <= #U_DLY 8'd0;
    else
        begin
            if(uart_rx_valid == 1'b1)
                header_h <= #U_DLY uart_rx_data;
            else
                ;
        end
end

// ============================================================================
// Write info
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wrstep_en <= #U_DLY 1'b0;
    else
        begin
            if((uart_rx_valid ==1'b1) && ({header_h,uart_rx_data} == 16'h0ff0))
                wrstep_en <= #U_DLY 1'b1;
            else if((wrstep_cnt >= 4'd9) && (uart_rx_valid == 1'b1))
                wrstep_en <= #U_DLY 1'b0;
            else
                ;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wrstep_cnt <= #U_DLY 4'd0;
    else
        begin
            if(wrstep_en == 1'b1)
                begin
                    if(uart_rx_valid == 1'b1)
                        wrstep_cnt <= #U_DLY wrstep_cnt + 4'd1;
                    else
                        ;
                end
            else
                wrstep_cnt <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((wrstep_cnt == 4'd9) && (uart_rx_valid == 1'b1) && ({header_h,uart_rx_data} == 16'heb90))
                ififo_wr_en <= #U_DLY 1'b1;
            else
                ififo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_wr_data <= #U_DLY 12'd0;
    else
        begin
            if((uart_rx_valid ==1'b1) && ({header_h,uart_rx_data} == 16'h0ff0))
                ififo_wr_data <= #U_DLY dram_wr_addr - 12'd1;
            else
                ;
        end
end

// ============================================================================
// Get frame data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rdstep_en <= #U_DLY 1'b0;
    else
        begin
            if(ififo_empty == 1'b0)
                rdstep_en <= #U_DLY 1'b1;
            else if(rdstep_cnt >= 4'd12)
                rdstep_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rdstep_cnt <= #U_DLY 4'd0;
    else
        begin
            if(rdstep_en == 1'b1)
                rdstep_cnt <= #U_DLY rdstep_cnt + 4'd1;
            else
                rdstep_cnt <= #U_DLY 4'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dram_rd_addr <= #U_DLY 12'd0;
    else
        begin
            if(rdstep_en == 1'b1)
                dram_rd_addr <= #U_DLY dram_rd_addr + 12'd1;
            else
                dram_rd_addr <= #U_DLY ififo_rd_data;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if(rdstep_cnt == 4'd12)
                ififo_rd_en <= #U_DLY 1'b1;
            else
                ififo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_rxcfg_data <= #U_DLY 8'd0;
    else
        slr_rxcfg_data <= #U_DLY dram_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_rxcfg_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((rdstep_cnt >= 4'd1) && (rdstep_cnt <= 4'd12))
                slr_rxcfg_data_valid <= #U_DLY 1'b1;
            else
                slr_rxcfg_data_valid <= #U_DLY 1'b0;
        end
end

endmodule




