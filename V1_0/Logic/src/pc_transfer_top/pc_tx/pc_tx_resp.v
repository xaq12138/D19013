// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:35:04
// File Name    : pc_tx_resp.v
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
// pc_tx_resp
//    |---
// 
`timescale 1ns/1ns

module pc_tx_resp #
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
// Info & Data FIFO Read Pot
// ----------------------------------------------------------------------------
    output reg                      ififo_rd_en                 , 
    input                    [19:0] ififo_rd_data               , 
    input                           ififo_empty                 , 
// ----------------------------------------------------------------------------
// Response Pakadge Frame
// ----------------------------------------------------------------------------
    output reg                      resp_wr_req                 , 
    input                           resp_wr_ack                 , 
    output reg                      resp_wr_done                , 

    output reg                      resp_wr_en                  , 
    output reg                [7:0] resp_wr_data                  
);

reg                                 ififo_rd_mask               ;
reg                                 ififo_rd_data_valid         ; 

reg                                 step_en                     ;
reg                           [7:0] step_cnt                    ; 

// ============================================================================
// Read pakadge info from IFIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b0) && (ififo_empty == 1'b0))
                ififo_rd_mask <= #U_DLY 1'b1;
            else if(step_en == 1'b1)
                ififo_rd_mask <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b0) && (ififo_empty == 1'b0) && (ififo_rd_mask == 1'b0))
                ififo_rd_en <= #U_DLY 1'b1;
            else
                ififo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ififo_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((ififo_rd_en == 1'b1) && (ififo_empty == 1'b0))
                ififo_rd_data_valid <= #U_DLY 1'b1;
            else
                ififo_rd_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Request send frame permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_wr_req <= #U_DLY 1'b0;
    else
        begin
            if(ififo_rd_data_valid == 1'b1)
                resp_wr_req <= #U_DLY 1'b1;
            else if(resp_wr_ack == 1'b1)
                resp_wr_req <= #U_DLY 1'b0;
            else
                ;
        end
end

// ============================================================================
// Responce Frame Generate Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if(resp_wr_ack == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if(step_cnt >=  8'd12)
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 8'd0;
    else
        begin
            if(step_en == 1'b1)
                step_cnt <= #U_DLY step_cnt + 8'd1;
            else
                step_cnt <= #U_DLY 8'd0;
        end  
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < 8'd12))
                resp_wr_en <= #U_DLY 1'b1;
            else
                resp_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'h0    : resp_wr_data <= #U_DLY 8'h00;
            8'h1    : resp_wr_data <= #U_DLY 8'h00;
            8'h2    : resp_wr_data <= #U_DLY 8'h00; 
            8'h3    : resp_wr_data <= #U_DLY 8'd18;
            8'h4    : resp_wr_data <= #U_DLY 8'h00; 
            8'h5    : resp_wr_data <= #U_DLY 8'h00; 
            8'h6    : resp_wr_data <= #U_DLY 8'h00; 
            8'h7    : resp_wr_data <= #U_DLY 8'h00; 
            8'h8    : resp_wr_data <= #U_DLY ififo_rd_data[15:8];
            8'h9    : resp_wr_data <= #U_DLY ififo_rd_data[7:0];
            8'ha    : resp_wr_data <= #U_DLY 8'h00;
            8'hb    : resp_wr_data <= #U_DLY {5'd0,ififo_rd_data[18:16]};
            default : resp_wr_data <= #U_DLY 8'd0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_wr_done <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (step_cnt == 8'd12))
                resp_wr_done <= #U_DLY 1'b1;
            else
                resp_wr_done <= #U_DLY 1'b0;
        end
end

endmodule




