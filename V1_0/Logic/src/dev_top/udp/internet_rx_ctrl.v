// +FHDR============================================================================/
// Author       : huangjie
// Creat Time   : 2020/08/13 12:46:41
// File Name    : internet_rx_ctrl.v
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
// internet_rx_ctrl
//    |---
// 
`timescale 1ns/1ps

module internet_rx_ctrl #
(
    parameter                       U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock @ Reset 
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    input                           cfg_udp_filter              , 
    input                    [15:0] cfg_udp_rxdstport           , 
// ----------------------------------------------------------------------------
// UDP Receive Data
// ----------------------------------------------------------------------------
    input                    [15:0] udp_rx_length               , 
    input                    [15:0] udp_rxdst_port              , 
    input                    [31:0] udp_rxdata                  , 
    input                           udp_rx_data_valid           , 
// ----------------------------------------------------------------------------
// FIFO Write & Read Port
// ----------------------------------------------------------------------------
    output reg                      rxdram_wr_en                , 
    output reg               [11:0] rxdram_wr_addr              , 
    output reg               [31:0] rxdram_wr_data              , 
    output reg               [13:0] rxdram_rd_addr              , 
    input                     [7:0] rxdram_rd_data              , 

    output reg                      rxififo_wr_en               , 
    output reg               [31:0] rxififo_wr_data             , 
    output reg                      rxififo_rd_en               , 
    input                    [31:0] rxififo_rd_data             , 
    input                           rxififo_empty               , 
// ----------------------------------------------------------------------------
// User Receive Data
// ----------------------------------------------------------------------------
    output reg                [7:0] user_rx_data                , 
    output reg                      user_rx_data_valid            
);

reg                                 pkg_wr_mask                 ; 
reg                                 rxdram_rd_en                ; 
reg                                 rxdram_rd_data_valid        ; 

reg                          [13:0] rx_step_data                ; 
reg                          [13:0] rx_step_cnt                 ; 
reg                          [11:0] dram_start_addr             ; 

reg                                 rxififo_rd_mask             ; 
reg                                 rxififo_rd_data_valid       ; 
reg                                 rd_step_en                  ; 
reg                          [19:0] rd_step_cnt                 ; 

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rx_step_data <= #U_DLY 14'd0;
    else
        begin
            if(udp_rx_length[1:0] > 2'd0)
                rx_step_data <= #U_DLY udp_rx_length[15:2] + 14'd1; 
            else
                rx_step_data <= #U_DLY udp_rx_length[15:2];
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rx_step_cnt <= #U_DLY 14'd0;
    else
        begin
            if(udp_rx_data_valid == 1'b1)
                begin
                    if(rx_step_cnt < rx_step_data - 14'd1)
                        rx_step_cnt <= #U_DLY rx_step_cnt + 14'd1;
                    else
                        rx_step_cnt <= #U_DLY 14'd0;
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dram_start_addr <= #U_DLY 12'd0;
    else
        begin
            if((udp_rx_data_valid == 1'b1) && (rx_step_cnt == 14'd0))
                dram_start_addr <= #U_DLY rxdram_wr_addr;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_wr_mask <= #U_DLY 1'b0;
    else
        begin
            if((cfg_udp_filter == 1'b1) && (cfg_udp_rxdstport != udp_rxdst_port))
                pkg_wr_mask <= #U_DLY 1'b1;
            else
                pkg_wr_mask <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Write data to DFIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((udp_rx_data_valid == 1'b1) && (pkg_wr_mask == 1'b0))
                rxdram_wr_en <= #U_DLY 1'b1;
            else
                rxdram_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_wr_addr <= #U_DLY 12'd0;
    else
        begin
            if(rxdram_wr_en == 1'b1)
                rxdram_wr_addr <= #U_DLY rxdram_wr_addr + 12'd1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_wr_data <= #U_DLY 32'd0;
    else
        rxdram_wr_data <= #U_DLY {udp_rxdata[7:0],udp_rxdata[15:8],udp_rxdata[23:16],udp_rxdata[31:24]};
end

// ============================================================================
// Write data to IFIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxififo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((udp_rx_data_valid == 1'b1) && (rx_step_cnt == rx_step_data - 14'd1) && (pkg_wr_mask == 1'b0))
                rxififo_wr_en <= #U_DLY 1'b1;
            else
                rxififo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxififo_wr_data <= #U_DLY 32'd0;
    else
        rxififo_wr_data <= #U_DLY {4'd0,dram_start_addr,udp_rx_length};
end

// ============================================================================
// Read data from IFIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxififo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((rxififo_empty == 1'b0) && (rd_step_en == 1'b0))
                rxififo_rd_mask <= #U_DLY 1'b1;
            else if(rd_step_en == 1'b1)
                rxififo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((rxififo_empty == 1'b0) && (rd_step_en == 1'b0) && (rxififo_rd_mask == 1'b0))
                rxififo_rd_en <= #U_DLY 1'b1;
            else
                rxififo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxififo_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(rxififo_rd_en == 1'b1)
                rxififo_rd_data_valid <= #U_DLY 1'b1;
            else
                rxififo_rd_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Read data from DFIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_step_en <= #U_DLY 1'b0;
    else
        begin
            if(rxififo_rd_data_valid == 1'b1)
                rd_step_en <= #U_DLY 1'b1;
            else if(rd_step_cnt >= {rxififo_rd_data[15:0],4'hf})
                rd_step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_step_cnt <= #U_DLY 20'd0;
    else
        begin
            if(rd_step_en == 1'b1)
                rd_step_cnt <= #U_DLY rd_step_cnt + 20'd1;
            else
                rd_step_cnt <= #U_DLY 20'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((rd_step_en == 1'b1) && (rd_step_cnt[19:4] < rxififo_rd_data[15:0]) && (rd_step_cnt[3:0] == 4'd0))
                rxdram_rd_en <= #U_DLY 1'b1;
            else
                rxdram_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_rd_addr <= #U_DLY 14'd0;
    else
        begin
            if(rxififo_rd_data_valid == 1'b1)
                rxdram_rd_addr <= #U_DLY {rxififo_rd_data[27:16],2'd0};
            else if(rxdram_rd_en == 1'b1)
                rxdram_rd_addr <= #U_DLY rxdram_rd_addr + 14'd1;
            else
                ;

        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxdram_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(rxdram_rd_en == 1'b1)
                rxdram_rd_data_valid <= #U_DLY 1'b1;
            else
                rxdram_rd_data_valid <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_rx_data <= #U_DLY 8'd0;
    else
        user_rx_data <= #U_DLY rxdram_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_rx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(rxdram_rd_data_valid == 1'b1)
                user_rx_data_valid <= #U_DLY 1'b1;
            else
                user_rx_data_valid <= #U_DLY 1'b0;
        end
end

endmodule




