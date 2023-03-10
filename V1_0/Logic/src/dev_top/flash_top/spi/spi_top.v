// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/20 21:55:12
// File Name    : spi_top.v
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
// spi_top
//    |---
// 
`timescale 1ns/1ps

module spi_top #
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
// Config Data
// ----------------------------------------------------------------------------
    input                    [15:0] baud_rate                   , 

    input                           cfg_cplo                    , 
    input                           cfg_cpha                    , 
    input                           cfg_mlsb                    , 
    input                     [7:0] cfg_dev_sel                 , // Select the device by asserting the relevant bit.
// ----------------------------------------------------------------------------
// TX Data
// ----------------------------------------------------------------------------
    input                           spi_tx_en                   , 
    input                    [15:0] spi_tx_data                 , 
// ----------------------------------------------------------------------------
// RX Data
// ----------------------------------------------------------------------------
    output                    [7:0] spi_rx_data                 , 
    output                          spi_rx_data_valid           , 
// ----------------------------------------------------------------------------
// SPI Port
// ----------------------------------------------------------------------------
    output                    [7:0] spi_cs_n                    , 
    output                          spi_clk                     , 
    input                           spi_sdi                     , 
    output                          spi_sdo                     , 
    output                          spi_sdo_en                    
);

wire                                baud_en                     ; 

wire                                txfifo_rd_en                ; 
wire                         [15:0] txfifo_rd_data              ; 
wire                                txfifo_empty                ; 

wire                                tx_en                       ; 
wire                          [3:0] tx_cmd                      ; // bit0 --> write(0)/read(1),bit1 --> last byte(1),thers --> reserved.
wire                          [7:0] tx_data                     ; 
wire                                tx_busy                     ; 

spi_baud_gen #
(
    .U_DLY                          (U_DLY                      )  
)
u_spi_baud_gen
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Baud Rate Config
// ----------------------------------------------------------------------------
    .baud_rate                      (baud_rate[15:0]            ), // (input )
// ----------------------------------------------------------------------------
// Baud Rate
// ----------------------------------------------------------------------------
    .baud_en                        (baud_en                    )  // (output)
);

fifo_d4kw16_st	u_fifo_d4kw16_st
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (spi_tx_en                  ), 
    .data                           (spi_tx_data[15:0]          ), 
    .rdreq                          (txfifo_rd_en               ), 
    .q                              (txfifo_rd_data[15:0]       ), 
    .empty                          (txfifo_empty               ), 
    .full                           (                           )  
);

spi_ctrl #
(
    .U_DLY                          (U_DLY                      )  
)
u_spi_ctrl
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// TX-FIFO Read Control
// ----------------------------------------------------------------------------
    .txfifo_rd_en                   (txfifo_rd_en               ), // (output)
    .txfifo_rd_data                 (txfifo_rd_data[15:0]       ), // (input )
    .txfifo_empty                   (txfifo_empty               ), // (input )
// ----------------------------------------------------------------------------
// SPI Status
// ----------------------------------------------------------------------------
    .bus_tx_busy                    (/* not used */             ), // (output)
// ----------------------------------------------------------------------------
// SPI TX Control
// ----------------------------------------------------------------------------
    .tx_en                          (tx_en                      ), // (output)
    .tx_cmd                         (tx_cmd[3:0]                ), // (output) bit0 --> write(0)/read(1),bit1 --> last byte(1),thers --> reserved.
    .tx_data                        (tx_data[7:0]               ), // (output)
    .tx_busy                        (tx_busy                    )  // (input )
);

spi_drv #
(
    .U_DLY                          (U_DLY                      )  
)
u_spi_drv
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Baud Rate
// ----------------------------------------------------------------------------
    .baud_en                        (baud_en                    ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_cplo                       (cfg_cplo                   ), // (input )
    .cfg_cpha                       (cfg_cpha                   ), // (input )
    .cfg_mlsb                       (cfg_mlsb                   ), // (input )

    .cfg_dev_sel                    (cfg_dev_sel[7:0]           ), // (input ) Select the device by asserting the relevant bit.
// ----------------------------------------------------------------------------
// Tx & Rx Data
// ----------------------------------------------------------------------------
    .tx_en                          (tx_en                      ), // (input )
    .tx_cmd                         (tx_cmd[3:0]                ), // (input ) bit0 --> write(0)/read(1),bit1 --> last byte(1),thers --> reserved.
    .tx_data                        (tx_data[7:0]               ), // (input )
    .tx_busy                        (tx_busy                    ), // (output)

    .rx_data                        (spi_rx_data[7:0]           ), // (output)
    .rx_data_valid                  (spi_rx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// SPI Port
// ----------------------------------------------------------------------------
    .spi_cs_n                       (spi_cs_n[7:0]              ), // (output)
    .spi_clk                        (spi_clk                    ), // (output)
    .spi_sdi                        (spi_sdi                    ), // (input )
    .spi_sdo                        (spi_sdo                    ), // (output)
    .spi_sdo_en                     (spi_sdo_en                 )  // (output)
);

endmodule



