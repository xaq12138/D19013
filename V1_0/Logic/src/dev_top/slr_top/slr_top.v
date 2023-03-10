// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/31 12:23:43
// File Name    : slr_top.v
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
// slr_top
//    |---
// 
`timescale 1ns/1ps

module slr_top #
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
    input                    [15:0] cfg_ins_length              , 
    input                    [63:0] local_time                  , 
    input                           cfg_keyer_sel               ,
    input                     [7:0] cfg_pcm_header              , 
    input                     [7:0] cfg_dy_header               , 
// ----------------------------------------------------------------------------
// SLR Uart
// ----------------------------------------------------------------------------
    input                           slr_data_uart_rx            , 

    input                           slr_cfg_uart_rx             , 
    output                          slr_cfg_uart_tx             , 
// ----------------------------------------------------------------------------
// SLR Config & Data
// ----------------------------------------------------------------------------
    input                     [7:0] slr_cfg_data                , 
    input                           slr_cfg_data_valid          , 
    output                    [7:0] slr_rd_data                 , 
    output                          slr_rd_data_valid           , 

    output                  [575:0] rxins_data                  , 
    output                          rxins_data_valid              
);

wire                          [7:0] slr_rx_data                 ; 
wire                                slr_rx_data_valid           ; 

wire                          [7:0] uart_rx_data                ; 
wire                                uart_rx_data_valid          ; 

wire                                dram_wr_en                  ; 
wire                         [11:0] dram_wr_addr                ; 
wire                          [7:0] dram_wr_data                ; 

wire                         [11:0] dram_rd_addr                ; 
wire                          [7:0] dram_rd_data                ; 

wire                                ififo_wr_en                 ; 
wire                         [11:0] ififo_wr_data               ; 

wire                                ififo_rd_en                 ; 
wire                         [15:0] ififo_rd_data               ; 
wire                                ififo_empty                 ; 

wire                          [7:0] instruct_cod                ; 
wire                                fifo_empty                  ; 
wire                                fifo_rd_en                  ; 

wire                        [583:0] rxins_data_tmp              ; 

uart_top #
(
    .U_DLY                          (U_DLY                      )  
)
u0_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd813                    ), // (input )
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b0                       ), // (input )
    .check_sel                      (1'b0                       ), // (input )
    .check_filter                   (1'b0                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (slr_cfg_data_valid         ), // (input )
    .uart_tx_data                   (slr_cfg_data[7:0]          ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (slr_rx_data[7:0]           ), // (output)
    .uart_rx_data_valid             (slr_rx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (slr_cfg_uart_rx            ), // (input )
    .uart_tx                        (slr_cfg_uart_tx            )  // (output)
);

uart_top #
(
    .U_DLY                          (U_DLY                      )  
)
u1_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd67                     ), // (input )
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b0                       ), // (input )
    .check_sel                      (1'b0                       ), // (input )
    .check_filter                   (1'b0                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (1'b0                       ), // (input )
    .uart_tx_data                   (8'd0                       ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (uart_rx_data[7:0]          ), // (output)
    .uart_rx_data_valid             (uart_rx_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (slr_data_uart_rx           ), // (input )
    .uart_tx                        (/* not used */             )  // (output)
);

sdpram_d4kw8 u_sdpram_d4kw8 
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wren                           (dram_wr_en                 ), 
    .wraddress                      (dram_wr_addr[11:0]         ), 
    .data                           (dram_wr_data[7:0]          ), 
    .rdaddress                      (dram_rd_addr[11:0]         ), 
    .q                              (dram_rd_data[7:0]          )  
);


fifo_d512w16_fwft u_fifo_d512w16_fwft
(
    .clock                          (clk_sys                    ), // (input )
    .aclr                           (!rst_n                     ), // (input )
    .wrreq                          (ififo_wr_en                ), // (input )
    .data                           ({4'd0,ififo_wr_data}       ), // (input )
    .rdreq                          (ififo_rd_en                ), // (input )
    .q                              (ififo_rd_data[15:0]        ), // (output)
    .empty                          (ififo_empty                ), // (output)
    .full                           (                           )  // (output)
);

slr_rx_cfg #
(
    .U_DLY                          (U_DLY                      )  
)
u_slr_rx_cfg
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Uart RX Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (slr_rx_data[7:0]           ), // (input )
    .uart_rx_valid                  (slr_rx_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Uart Data Buffer & FIFO (FWFT)
// ----------------------------------------------------------------------------
    .dram_wr_en                     (dram_wr_en                 ), // (output)
    .dram_wr_addr                   (dram_wr_addr[11:0]         ), // (output)
    .dram_wr_data                   (dram_wr_data[7:0]          ), // (output)

    .dram_rd_addr                   (dram_rd_addr[11:0]         ), // (output)
    .dram_rd_data                   (dram_rd_data[7:0]          ), // (input )

    .ififo_wr_en                    (ififo_wr_en                ), // (output)
    .ififo_wr_data                  (ififo_wr_data[11:0]        ), // (output)

    .ififo_rd_en                    (ififo_rd_en                ), // (output)
    .ififo_rd_data                  (ififo_rd_data[11:0]        ), // (input )
    .ififo_empty                    (ififo_empty                ), // (input )
// ----------------------------------------------------------------------------
// SLR Config RX Data
// ----------------------------------------------------------------------------
    .slr_rxcfg_data                 (slr_rd_data[7:0]           ), // (output)
    .slr_rxcfg_data_valid           (slr_rd_data_valid          )  // (output)
);


slr_rx_dat #
(
    .U_DLY                          (U_DLY                      )  
)
u_slr_rx_dat
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    .local_time                     (local_time[63:0]           ), // (input )
    .cfg_ins_length                 (cfg_ins_length[7:0]        ), // (input )
    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (input )
    .cfg_pcm_header                 (cfg_pcm_header[7:0]        ), // (input )
    .cfg_dy_header                  (cfg_dy_header[7:0]         ), // (input )
// ----------------------------------------------------------------------------
// Uart RX Data
// ----------------------------------------------------------------------------
    .rx_data                        (uart_rx_data[7:0]          ), // (input )
    .rx_data_valid                  (uart_rx_data_valid         ), // (input )
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// rxins_data[575:512] : (8byte)  time
// rxins_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------    
    .rxins_data                     (rxins_data[575:0]          ), // (output)
    .rxins_data_valid               (rxins_data_valid           )  // (output)
);

endmodule




