// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/23 10:02:47
// File Name    : flash_ctrl.v
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
// flash_ctrl
//    |---
// 
`timescale 1ns/1ps

module flash_ctrl #
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
// Read Commond & Data
// ----------------------------------------------------------------------------
    output reg                      flash_ififo_rd_en           , 
    input                    [31:0] flash_ififo_rd_data         , 
    input                           flash_ififo_empty           , 

    output reg                      flash_dfifo_rd_en           , 
    input                     [7:0] flash_dfifo_rd_data         , 
                           
    output                    [7:0] flash_rd_data               , 
    output                          flash_rd_data_valid         , 
// ----------------------------------------------------------------------------
// Write & Read Data By SPI
//
// spi_tx_data[15:10] --> reserved 
// spi_tx_data[10]    --> last byte(1)
// spi_tx_data[9]     --> write(0)/read(1)
// spi_tx_data[7:0]   --> data
// ----------------------------------------------------------------------------
    output reg                      spi_tx_en                   , 
    output reg               [15:0] spi_tx_data                 , 

    input                     [7:0] spi_rx_data                 , 
    input                           spi_rx_data_valid             
);

localparam IDLE    = 4'b0000;
localparam GETINFO = 4'b0010;
localparam WR_DATA = 4'b0011;
localparam RD_DATA = 4'b0110;
localparam ACK     = 4'b0111;
localparam DONE    = 4'b0101;

reg                           [3:0] c_status                    ; 
reg                           [3:0] n_status                    ; 

reg                           [7:0] wrstp_cnt                   ; 
reg                                 wr_en                       ; 
reg                          [15:0] wr_data                     ; 

reg                           [7:0] rdstp_cnt                   ; 
reg                                 rd_en                       ; 
reg                          [15:0] rd_data                     ; 

// ============================================================================
// FSM - 1&2
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_status <= #U_DLY IDLE;
    else
        c_status <= #U_DLY n_status;
end

always @ (*)
begin
    case(c_status)
        IDLE    :
            begin
                if(flash_ififo_empty == 1'b0)
                    n_status = GETINFO;
                else
                    n_status = IDLE;
            end
        GETINFO :
            begin
                if(flash_ififo_rd_data[31] == 1'b1)
                    n_status = RD_DATA;
                else
                    n_status = WR_DATA;
            end
        WR_DATA :
            begin
                if(wrstp_cnt > flash_ififo_rd_data[23:16] + 8'd5)
                    n_status = ACK;
                else   
                    n_status = WR_DATA;
            end
        RD_DATA :
            begin
                if(rdstp_cnt > flash_ififo_rd_data[23:16] + 8'd3)
                    n_status = ACK;
                else
                    n_status = RD_DATA;
            end
        ACK     : n_status = DONE;  
        DONE    : n_status = IDLE;
        default : n_status = IDLE;
    endcase
end

// ============================================================================
// Flash write control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wrstp_cnt <= #U_DLY 8'd0;
    else
        begin
            if(c_status == WR_DATA)
                wrstp_cnt <= #U_DLY wrstp_cnt + 8'd1;
            else
                wrstp_cnt <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_dfifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_status == WR_DATA) && (wrstp_cnt >= 8'd3) && (wrstp_cnt <= flash_ififo_rd_data[23:16] + 8'd2))
                flash_dfifo_rd_en <= #U_DLY 1'b1;
            else
                flash_dfifo_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wr_en <= #U_DLY 1'b0;
    else
        begin
            if((c_status == WR_DATA) && (wrstp_cnt >= 8'd0) && (wrstp_cnt <= flash_ififo_rd_data[23:16] + 8'd5))
                wr_en <= #U_DLY 1'b1;
            else
                wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wr_data <= #U_DLY 16'd0;
    else
        begin
            if(wrstp_cnt < 8'd5)
                case(wrstp_cnt)
                    8'd0    : wr_data <= #U_DLY 16'h0206;
                    8'd1    : wr_data <= #U_DLY 16'h0002;
                    8'd2    : wr_data <= #U_DLY {8'h00,8'h00};
                    8'd3    : wr_data <= #U_DLY {8'h00,flash_ififo_rd_data[1*8+:8]};
                    8'd4    : wr_data <= #U_DLY {8'h00,flash_ififo_rd_data[0*8+:8]};
                    default :;
                endcase
            else if(wrstp_cnt == flash_ififo_rd_data[23:16] + 8'd4)
                wr_data <= #U_DLY {8'h02,flash_dfifo_rd_data};
            else if(wrstp_cnt == flash_ififo_rd_data[23:16] + 8'd5)
                wr_data <= #U_DLY 16'h0204;
            else
                wr_data <= #U_DLY {8'h00,flash_dfifo_rd_data};
        end
end

// ============================================================================
// Flash read control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rdstp_cnt <= #U_DLY 8'd0;
    else
        begin
            if(c_status == RD_DATA)
                rdstp_cnt <= #U_DLY rdstp_cnt + 8'd1;
            else
                rdstp_cnt <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_status == RD_DATA) && (rdstp_cnt >= 8'd0) && (rdstp_cnt <= flash_ififo_rd_data[23:16] + 8'd3))
                rd_en <= #U_DLY 1'b1;
            else
                rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY 16'd0;
    else
        begin
            if(rdstp_cnt == flash_ififo_rd_data[23:16] + 8'd3)
                rd_data <= #U_DLY {8'h03,8'h00};
            else
                case(rdstp_cnt)
                    8'h00   : rd_data <= #U_DLY {8'h00,8'h03};
                    8'h01   : rd_data <= #U_DLY {8'h00,8'h00};
                    8'h02   : rd_data <= #U_DLY {8'h00,flash_ififo_rd_data[1*8+:8]};
                    8'h03   : rd_data <= #U_DLY {8'h00,flash_ififo_rd_data[0*8+:8]};
                    default : rd_data <= #U_DLY 16'h0100;
                endcase
        end
end

// ============================================================================
// Info FIFO response
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_ififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if(c_status == ACK)
                flash_ififo_rd_en <= #U_DLY 1'b1;
            else
                flash_ififo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Write or read mux
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        spi_tx_en <= #U_DLY 1'b0;
    else
        begin
            if((wr_en == 1'b1) || (rd_en ==1'b1))
                spi_tx_en <= #U_DLY 1'b1;
            else
                spi_tx_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        spi_tx_data <= #U_DLY 16'd0;
    else
        begin
            if(flash_ififo_rd_data[31] == 1'b1)
                spi_tx_data <= #U_DLY rd_data;
            else
                spi_tx_data <= #U_DLY wr_data;
        end
end

assign flash_rd_data = spi_rx_data;
assign flash_rd_data_valid = spi_rx_data_valid;

endmodule



