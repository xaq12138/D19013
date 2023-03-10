// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:39:11
// File Name    : pc_rx_cfg.v
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
// pc_rx_cfg
//    |---
// 
`timescale 1ns/1ns

module pc_rx_cfg #
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
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
    output reg                      fdram_rd_req                , 
    input                           fdram_rd_ack                , 
    output reg                      fdram_rd_done               , 

    output reg               [11:0] fdram_rd_addr               , 
    input                     [7:0] fdram_rd_data               , 
// ----------------------------------------------------------------------------
// Frame Info Fifo Read Port
// ----------------------------------------------------------------------------
    output reg                      fififo_rd_en                , 
    input                    [71:0] fififo_rd_data              , 
    input                           fififo_empty                , 
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    output reg                [7:0] slr_cfg_data                , 
    output reg                      slr_cfg_data_valid          , 
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    output reg                [7:0] upconvert_cfg_data          , 
    output reg                      upconvert_cfg_data_valid    , 
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    output reg                [7:0] mem_cfg_data                , 
    output reg                      mem_cfg_data_valid          , 

    output reg               [15:0] inst_resp_data              , 
    output reg                      inst_resp_data_valid        , 
// ----------------------------------------------------------------------------
// PCM & DY Config Data
// ----------------------------------------------------------------------------
    output reg                      inter_cfg_wr_en             , 
    output reg                      inter_cfg_rd_en             , 
    output reg               [15:0] inter_cfg_addr              , 
    output reg               [31:0] inter_cfg_data                
);

reg                                 fififo_rd_mask              ; 
reg                                 step_en                     ; 
reg                          [31:0] step_cnt                    ; 

reg                                 fififo_rd_data_valid        ; 

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
        fififo_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((fififo_rd_en == 1'b1) && (fififo_empty == 1'b0))
                fififo_rd_data_valid <= #U_DLY 1'b1;
            else
                fififo_rd_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Request read data RAM permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_rd_req <= #U_DLY 1'b0;
    else
        begin 
            if(fififo_rd_data_valid == 1'b1)
                fdram_rd_req <= #U_DLY 1'b1;
            else if(fdram_rd_ack == 1'b1)
                fdram_rd_req <= #U_DLY 1'b0;
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
            if(fdram_rd_ack == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if((step_en == 1'b1) && (step_cnt >= fififo_rd_data[31:0] - 32'd13)) 
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 32'd0;
    else
        begin
            if(step_en == 1'b1)
                step_cnt <= #U_DLY step_cnt + 32'd1;
            else
                step_cnt <= #U_DLY 32'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_rd_done <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (step_cnt >= fififo_rd_data[31:0] - 32'd13)) 
                fdram_rd_done <= #U_DLY 1'b1;
            else
                fdram_rd_done <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Read data from RAM.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_rd_addr <= #U_DLY 12'd0;
    else
        begin
            if(fififo_rd_data_valid == 1'b1)
                fdram_rd_addr <= #U_DLY fififo_rd_data[51:40];
            else if(step_en == 1'b1)
                fdram_rd_addr <= #U_DLY fdram_rd_addr + 12'd1;
            else
                ;
        end
end

// ============================================================================
// SLR config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_cfg_data <= #U_DLY 8'd0;
    else
        slr_cfg_data <= #U_DLY fdram_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_cfg_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(((fififo_rd_data[71:56]== 16'h0003) || (fififo_rd_data[71:56]== 16'h0006)) && (step_cnt >= 32'd3) && (step_cnt < fififo_rd_data[31:0] - 32'd13))
                slr_cfg_data_valid <= #U_DLY 1'b1;
            else
                slr_cfg_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Up convert config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        upconvert_cfg_data <= #U_DLY 8'd0;
    else
        upconvert_cfg_data <= #U_DLY fdram_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        upconvert_cfg_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(((fififo_rd_data[71:56]== 16'h0004) || (fififo_rd_data[71:56] == 16'h0009)) && (step_cnt >= 32'd3) && (step_cnt < fififo_rd_data[31:0] - 32'd13))
                upconvert_cfg_data_valid <= #U_DLY 1'b1;
            else
                upconvert_cfg_data_valid <= #U_DLY 1'b0;
        end
end


// ============================================================================
// Config data to memory
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_cfg_data <= #U_DLY 8'd0;
    else
        mem_cfg_data <= #U_DLY fdram_rd_data;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_cfg_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(((fififo_rd_data[71:56]== 16'h0005) || (fififo_rd_data[71:56] == 16'h0007) || (fififo_rd_data[71:56] == 16'h000a)) && (step_cnt >= 32'd1) && (step_cnt < fififo_rd_data[31:0] - 32'd13))
                mem_cfg_data_valid <= #U_DLY 1'b1;
            else
                mem_cfg_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Instruct Read Infomation
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_resp_data <= #U_DLY 16'd0;
    else
        case(step_cnt)
            32'h3   : inst_resp_data[15:8] <= #U_DLY fdram_rd_data;
            32'h4   : inst_resp_data[7:0] <= #U_DLY fdram_rd_data;
            default :;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_resp_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((fififo_rd_data[71:56] == 16'h000a) && (step_cnt == 32'd4))
                inst_resp_data_valid <= #U_DLY 1'b1;
            else
                inst_resp_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// PCM & DY config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_addr <= #U_DLY 16'd0;
    else
        begin
            if(step_cnt == 32'd3)
                inter_cfg_addr[15:8] <= #U_DLY fdram_rd_data;
            else if(step_cnt == 32'd4)
                inter_cfg_addr[7:0] <= #U_DLY fdram_rd_data;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_data <= #U_DLY 32'd0;
    else
        case(step_cnt)
            32'd5   : inter_cfg_data[3*8+:8] <= #U_DLY fdram_rd_data;
            32'd6   : inter_cfg_data[2*8+:8] <= #U_DLY fdram_rd_data;
            32'd7   : inter_cfg_data[1*8+:8] <= #U_DLY fdram_rd_data;
            32'd8   : inter_cfg_data[0*8+:8] <= #U_DLY fdram_rd_data;
            default : ;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((fififo_rd_data[71:56]== 16'h0005) && (step_cnt == 32'd8))
                inter_cfg_wr_en <= #U_DLY 1'b1;
            else
                inter_cfg_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((fififo_rd_data[71:56]== 16'h0008) && (step_cnt == 32'd4))
                inter_cfg_rd_en <= #U_DLY 1'b1;
            else
                inter_cfg_rd_en <= #U_DLY 1'b0;
        end
end

endmodule



