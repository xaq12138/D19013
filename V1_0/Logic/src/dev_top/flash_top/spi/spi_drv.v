// +FHDR============================================================================/
// Author       : Huangjie
// Creat Time   : 2020/04/20 10:31:55
// File Name    : spi_drv.v
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
// spi_drv
//    |---
// 
`timescale 1ns/1ns

module spi_drv #
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
// Baud Rate
// ----------------------------------------------------------------------------
    input                           baud_en                     , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    input                           cfg_cplo                    , 
    input                           cfg_cpha                    , 
    input                           cfg_mlsb                    , 

    input                     [7:0] cfg_dev_sel                 , // Select the device by asserting the relevant bit.
// ----------------------------------------------------------------------------
// Tx & Rx Data
// ----------------------------------------------------------------------------
    input                           tx_en                       , 
    input                     [3:0] tx_cmd                      , // bit0 --> write(0)/read(1),bit1 --> last byte(1),thers --> reserved.
    input                     [7:0] tx_data                     , 
    output reg                      tx_busy                     , 

    output reg                [7:0] rx_data                     , 
    output reg                      rx_data_valid               , 
// ----------------------------------------------------------------------------
// SPI Port
// ----------------------------------------------------------------------------
    output                    [7:0] spi_cs_n                    , 
    output reg                      spi_clk                     , 
    input                           spi_sdi                     , 
    output reg                      spi_sdo                     , 
    output reg                      spi_sdo_en                    
);

reg                                 step_en                     ; 
reg                           [4:0] step_cnt                    ; 

reg                           [7:0] tx_reg                      ; 

reg                                 cs_n_temp                   ; 

reg                           [4:0] rxstep_cnt                  ; 

// ============================================================================
// SPI TX & RX Step Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if(tx_en == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if(step_cnt >= 5'd18)
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 5'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(baud_en == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 5'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 5'd0;
        end
end

// ============================================================================
// SPI TX Data Latch
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_reg <= #U_DLY 8'd0;
    else
        begin
            if(tx_en == 1'b1)
                begin
                    if(cfg_mlsb == 1'b1)
                        tx_reg <= #U_DLY {tx_data[0],tx_data[1],tx_data[2],tx_data[3],tx_data[4],tx_data[5],tx_data[6],tx_data[7]};
                    else
                        tx_reg <= #U_DLY tx_data;
                end
            else
                ;
        end
end

// ============================================================================
// SPI Timing Generate
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cs_n_temp <= #U_DLY 1'b1;
    else
        begin
            if((step_en == 1'b1) && (baud_en == 1'b1))
                begin
                    if((tx_cmd[1] == 1'b1) && (step_cnt >= 5'd17))
                        cs_n_temp <= #U_DLY 1'b1;
                    else
                        cs_n_temp <= #U_DLY 1'b0;
                end
            else
                ;
        end
end

assign spi_cs_n = (cs_n_temp == 1'b0) ? ~cfg_dev_sel : 8'hff;

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        spi_clk <= #U_DLY 1'b0;
    else
        begin
            if(step_en == 1'b0)
                spi_clk <= #U_DLY cfg_cplo;
            else if((step_cnt >= 5'd1) && (step_cnt <= 5'd16) && (baud_en ==1'b1))
                spi_clk <= #U_DLY ~spi_clk;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        spi_sdo <= #U_DLY 1'b0;
    else
        begin
            if(step_en == 1'b0)
                spi_sdo <= #U_DLY 1'b0;
            else if((step_cnt[0] == cfg_cpha) && (baud_en ==1'b1))
                case(step_cnt[4:1])
                    4'd0    : spi_sdo <= #U_DLY tx_reg[0];
                    4'd1    : spi_sdo <= #U_DLY tx_reg[1];
                    4'd2    : spi_sdo <= #U_DLY tx_reg[2];
                    4'd3    : spi_sdo <= #U_DLY tx_reg[3];
                    4'd4    : spi_sdo <= #U_DLY tx_reg[4];
                    4'd5    : spi_sdo <= #U_DLY tx_reg[5];
                    4'd6    : spi_sdo <= #U_DLY tx_reg[6];
                    4'd7    : spi_sdo <= #U_DLY tx_reg[7];
                    default : spi_sdo <= #U_DLY 1'b0;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        spi_sdo_en <= #U_DLY 1'b0;
    else
        begin
            if(tx_cmd[0] == 1'b0)
                spi_sdo_en <= #U_DLY 1'b1;
            else
                spi_sdo_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// SPI RX Data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxstep_cnt <= #U_DLY 5'd0;
    else
        rxstep_cnt <= #U_DLY step_cnt - 5'd1;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rx_data <= #U_DLY 8'd0;
    else
        begin
            if((step_cnt[0] == cfg_cpha) && (baud_en ==1'b1))
                begin
                    if(cfg_mlsb == 1'b1)
                        case(rxstep_cnt[4:1])
                            4'd0    : rx_data[7] <= #U_DLY spi_sdi;
                            4'd1    : rx_data[6] <= #U_DLY spi_sdi;
                            4'd2    : rx_data[5] <= #U_DLY spi_sdi;
                            4'd3    : rx_data[4] <= #U_DLY spi_sdi;
                            4'd4    : rx_data[3] <= #U_DLY spi_sdi;
                            4'd5    : rx_data[2] <= #U_DLY spi_sdi;
                            4'd6    : rx_data[1] <= #U_DLY spi_sdi;
                            4'd7    : rx_data[0] <= #U_DLY spi_sdi;
                            default : ;
                        endcase
                    else
                        case(rxstep_cnt[4:1])
                            4'd0    : rx_data[0] <= #U_DLY spi_sdi;
                            4'd1    : rx_data[1] <= #U_DLY spi_sdi;
                            4'd2    : rx_data[2] <= #U_DLY spi_sdi;
                            4'd3    : rx_data[3] <= #U_DLY spi_sdi;
                            4'd4    : rx_data[4] <= #U_DLY spi_sdi;
                            4'd5    : rx_data[5] <= #U_DLY spi_sdi;
                            4'd6    : rx_data[6] <= #U_DLY spi_sdi;
                            4'd7    : rx_data[7] <= #U_DLY spi_sdi;
                            default : ;
                        endcase
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((tx_cmd[0] == 1'b1) && (step_cnt == 5'd17) && (baud_en == 1'b1))
                rx_data_valid <= #U_DLY 1'b1;
            else
                rx_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// SPI Status
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_busy <= #U_DLY 1'b0;
    else
        begin
            if(step_en == 1'b1)
                tx_busy <= #U_DLY 1'b1;
            else
                tx_busy <= #U_DLY 1'b0;
        end
end

endmodule




