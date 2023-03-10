// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:39:36
// File Name    : pc_rx_instruct.v
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
// pc_rx_instruct
//    |---
// 
`timescale 1ns/1ns

module pc_rx_instruct #
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
// Instruct Config Data 
// ----------------------------------------------------------------------------
    output reg               [15:0] instruct_cfg_data           , 
    output reg                      instruct_cfg_data_valid       
);

reg                                 fififo_rd_mask              ; 
reg                                 step_en                     ; 
reg                          [31:0] step_cnt                    ; 

reg                                 fififo_rd_data_valid        ; 
reg                                 fdram_rd_en                 ; 

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
            else if((step_en == 1'b1) && (step_cnt >= fififo_rd_data[31:0] - 31'd13)) 
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
            if((step_en == 1'b1) && (step_cnt >= fififo_rd_data[31:0] - 31'd13)) 
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
        fdram_rd_en <= #U_DLY 1'B0;
    else
        begin
            if((step_cnt >= 32'd1) && (step_cnt < fififo_rd_data[31:0] - 31'd17 + 32'd1))
                fdram_rd_en <= #U_DLY 1'b1;
            else
                fdram_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_rd_addr <= #U_DLY 12'd0;
    else
        begin
            if(fififo_rd_data_valid == 1'b1)
                fdram_rd_addr <= #U_DLY fififo_rd_data[51:40] + 12'd2;
            else if(fdram_rd_en == 1'b1)
                fdram_rd_addr <= #U_DLY fdram_rd_addr + 12'd1;
            else
                ;
        end
end

// ============================================================================
// Instruct config data 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        instruct_cfg_data <= #U_DLY 16'd0;
    else
        case(step_cnt)
            32'd3   : instruct_cfg_data[15:8] <= #U_DLY fdram_rd_data;
            32'd4   : instruct_cfg_data[7:0] <= #U_DLY fdram_rd_data;
            default :;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        instruct_cfg_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (step_cnt == 32'd5))
                instruct_cfg_data_valid <= #U_DLY 1'b1;
            else
                instruct_cfg_data_valid <= #U_DLY 1'b0;
        end
end

endmodule




