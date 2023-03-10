// +FHDR============================================================================/
// Author       : huangjie
// Creat Time   : 2020/08/11 16:07:47
// File Name    : internet_tx_ctrl.v
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
// internet_tx_ctrl
//    |---
// 
`timescale 1ns/1ps

module internet_tx_ctrl # 
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
// User Send Data
// ----------------------------------------------------------------------------
    input                           user_tx_en                  , 
    input                     [7:0] user_tx_data                , 
// ----------------------------------------------------------------------------
// Send FIFO
// ----------------------------------------------------------------------------
    output reg                      txdram_wr_en                , 
    output reg               [13:0] txdram_wr_addr              , 
    output reg                [7:0] txdram_wr_data              , 
    output                          txdram_rd_en                , 
    output reg               [11:0] txdram_rd_addr              , 
    input                    [31:0] txdram_rd_data              , 

    output reg                      txififo_wr_en               , 
    output reg               [31:0] txififo_wr_data             , 
    output reg                      txififo_rd_en               , 
    input                    [31:0] txififo_rd_data             , 
    input                           txififo_empty               , 
// ----------------------------------------------------------------------------
// UDP Send Data
// ----------------------------------------------------------------------------
    output reg                      udp_send_apply              , 
    output                   [31:0] udp_send_data               , 
    input                           udp_send_data_en            , 
    output reg               [15:0] udp_send_data_len           , 
    input                           udp_send_over                 
);  

reg                          [23:0] pkg_head_h                  ; 
reg                                 step_en                     ; 
reg                          [15:0] step_cnt                    ; 
reg                          [15:0] pkg_length                  ; 

reg                          [11:0] start_addr                  ; 

reg                                 txififo_rd_mask             ; 
reg                                 txififo_rd_data_valid       ; 
reg                                 send_busy                   ; 

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_head_h <= #U_DLY 24'd0;
    else
        begin
            if(user_tx_en == 1'b1)
                pkg_head_h <= #U_DLY {pkg_head_h[15:0],user_tx_data};
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if((user_tx_en == 1'b1) && (({pkg_head_h,user_tx_data} == 32'hef9119fe) || ({pkg_head_h,user_tx_data} == 32'heb90_09be)))
                step_en <= #U_DLY 1'b1;
            else if((user_tx_en == 1'b1) && (step_cnt > 16'd3) && (step_cnt >= pkg_length - 16'd1))
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 16'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(user_tx_en == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 16'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 16'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_length <= #U_DLY 16'd0;
    else
        case(step_cnt)
            16'd4   : pkg_length[15:8] <= #U_DLY user_tx_data;
            16'd5   : pkg_length[7:0] <= #U_DLY user_tx_data;
            default :;
        endcase
end

// ============================================================================
// Write data to RAM
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txdram_wr_en <= #U_DLY 1'b0;
    else
        begin
            if(user_tx_en == 1'b1)
                txdram_wr_en <= #U_DLY 1'b1;
            else
                txdram_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txdram_wr_addr <= #U_DLY 14'd0;
    else
        begin
            if((step_cnt > 16'd5) && (step_cnt >= pkg_length))
                begin
                    txdram_wr_addr[13:2] <= #U_DLY txdram_wr_addr[13:2] + 12'd1;
                    txdram_wr_addr[1:0] <= #U_DLY 2'd0;
                end
            else if(txdram_wr_en == 1'b1)
                txdram_wr_addr <= #U_DLY txdram_wr_addr + 14'd1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txdram_wr_data <= #U_DLY 8'd0;
    else
        txdram_wr_data <= #U_DLY user_tx_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        start_addr <= #U_DLY 12'd0;
    else
        begin
            if((step_en == 1'b0) && (user_tx_en == 1'b1) && (({pkg_head_h,user_tx_data} == 32'hef9119fe) || ({pkg_head_h,user_tx_data} == 32'heb90_09be)))
                start_addr <= #U_DLY txdram_wr_addr[13:2];
            else
                ;
        end
end

// ============================================================================
// Write infomation to fifo
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txififo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((step_cnt > 16'd5) && (step_cnt >= pkg_length))
                txififo_wr_en <= #U_DLY 1'b1;
            else
                txififo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txififo_wr_data <= #U_DLY 32'd0;
    else
        txififo_wr_data <= #U_DLY {4'd0,start_addr,pkg_length};
end

// ============================================================================
// Ask UDP for send data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        send_busy <= #U_DLY 1'b0;
    else
        begin
            if(udp_send_apply == 1'b1)
                send_busy <= #U_DLY 1'b1;
            else if(udp_send_over == 1'b1)
                send_busy <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txififo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((send_busy == 1'b0) && (txififo_empty == 1'b0))
                txififo_rd_mask <= #U_DLY 1'b1;
            else if(send_busy == 1'b1)
                txififo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txififo_rd_en <= #U_DLY 1'b0;
    else
        begin   
            if((send_busy == 1'b0) && (txififo_empty == 1'b0) && (txififo_rd_mask == 1'b0))
                txififo_rd_en <= #U_DLY 1'b1;
            else
                txififo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txififo_rd_data_valid <= #U_DLY 1'b0;
    else
        begin   
            if(txififo_rd_en == 1'b1)
                txififo_rd_data_valid <= #U_DLY 1'b1;
            else
                txififo_rd_data_valid <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        udp_send_apply <= #U_DLY 1'b0;
    else
        begin   
            if(txififo_rd_data_valid == 1'b1)
                udp_send_apply <= #U_DLY 1'b1;
            else if(udp_send_data_en == 1'b1)
                udp_send_apply <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        udp_send_data_len <= #U_DLY 16'd0;
    else
        begin
            if(txififo_rd_data_valid == 1'b1)
                udp_send_data_len <= #U_DLY txififo_rd_data[15:0] + 16'd4;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txdram_rd_addr <= #U_DLY 12'd0;
    else
        begin
            if(txififo_rd_data_valid == 1'b1)
                txdram_rd_addr <= #U_DLY txififo_rd_data[16+:12];
            else if(txdram_rd_en == 1'b1)
                txdram_rd_addr <= #U_DLY txdram_rd_addr + 12'd1;
            else
                ;
        end
end

assign txdram_rd_en = udp_send_data_en;
assign udp_send_data = {txdram_rd_data[7:0],txdram_rd_data[15:8],txdram_rd_data[23:16],txdram_rd_data[31:24]};

endmodule



