// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 10:03:04
// File Name    : dev_top.v
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
// dev_top
//    |---
// 
`timescale 1ns/1ps

module dev_top #
(
    parameter                       U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_60m                     , 
    input                           clk_100m                    , 
    input                           clk_125m                    , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    input                    [15:0] cfg_ins_length              , 
    input                     [7:0] cfg_ins_enable              , 
    input                           cfg_keyer_sel               ,
    input                     [7:0] cfg_pcm_header              , 
    input                     [7:0] cfg_dy_header               , 
    input                    [31:0] cfg_key_filter_data         , 

    input                           cfg_rm_time_valid           , 
    input                    [31:0] cfg_rm_time                 , 

    input                     [3:0] cfg_udp_socket              ,  // 4'b0001 point-to-point,4'b0100 multicast.
    input                    [15:0] cfg_udp_srcport             , 
    input                    [15:0] cfg_udp_dstport             , 
    input                    [31:0] cfg_phy_srcip               , 
    input                    [31:0] cfg_phy_dstip               , 
    input                    [47:0] cfg_phy_srcmac              , 
    input                    [47:0] cfg_phy_dstmac              , 
// ----------------------------------------------------------------------------
// Remote & Local Uart
// ----------------------------------------------------------------------------
    input                           pc_lcuart_rx                , 
    output                          pc_lcuart_tx                , 
    
    input                           pc_rmuart_rx                , 
    output                          pc_rmuart_tx                , 

    output                    [7:0] pc_lcrx_data                , 
    output                          pc_lcrx_data_valid          , 
    input                           pc_lctx_en                  , 
    input                     [7:0] pc_lctx_data                , 

    output                    [7:0] pc_rmrx_data                , 
    output                          pc_rmrx_data_valid          , 
    input                           pc_rmtx_en                  , 
    input                     [7:0] pc_rmtx_data                , 
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    input                           udp_tx_en                   , 
    input                     [7:0] udp_tx_data                 , 

    output                    [7:0] udp_rx_data                 , 
    output                          udp_rx_data_valid           , 
// ----------------------------------------------------------------------------
// IRIG-B
// ----------------------------------------------------------------------------
    input                           irigb_rx                    , 
// ----------------------------------------------------------------------------
// Local Time 
// ----------------------------------------------------------------------------
    output                   [63:0] local_time                  , 
// ----------------------------------------------------------------------------
// Power Monitor 
// ----------------------------------------------------------------------------
    input                           pwr_uart_rx                 , 
    input                           pwr_sw_sel                  , 

    output                   [31:0] pwr_current                 , 
    output                   [31:0] pwr_voltage                 , 
    output                   [31:0] pwr_power                   , 
// ----------------------------------------------------------------------------
// SLR
// ----------------------------------------------------------------------------
    input                           slr_data_uart_rx            , 

    input                           slr_cfg_uart_rx             , 
    output                          slr_cfg_uart_tx             , 

    input                     [7:0] slr_cfg_data                , 
    input                           slr_cfg_data_valid          , 
    output                    [7:0] slr_rd_data                 , 
    output                          slr_rd_data_valid           , 

    output                  [575:0] rxins_data                  , 
    output                          rxins_data_valid            , 
// ----------------------------------------------------------------------------
// Up Convert
// ----------------------------------------------------------------------------
    input                           upc_cfg_uart_rx             , 
    output                          upc_cfg_uart_tx             ,  

    input                     [7:0] upconvert_cfg_data          , 
    input                           upconvert_cfg_data_valid    , 
    output                    [7:0] upcovert_rd_data            , 
    output                          upcovert_rd_data_valid      , 
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    input                    [15:0] key_in                      , 

    output                   [15:0] key_instruct                , 
    output                          key_instruct_valid          , 

    output                          key_lr_status               , 
    output                          key_status_valid            , 
// ----------------------------------------------------------------------------
// Instruct Config Data 
//
// instruct_cfg_data[15:0] insInstruct sign
// ----------------------------------------------------------------------------
    input                    [15:0] instruct_cfg_data           , 
    input                           instruct_cfg_data_valid     , 
// ----------------------------------------------------------------------------
// Flash
// ----------------------------------------------------------------------------
    input                     [7:0] mem_cfg_data                , 
    input                           mem_cfg_data_valid          , 

    input                           mem_rd_en                   , 
    input                    [15:0] mem_rd_addr                 , 
    output                   [31:0] mem_rd_data                 , 
    output                          mem_rd_data_valid           , 

    output                  [511:0] mem_inst_data               , 
    output                          mem_inst_data_valid         , 

    output                  [511:0] tx_inst_data                , 
    output                          tx_inst_data_valid          , 

    output                          flash_holdn                 , 
    output                          flash_csn                   , 
    output                          flash_sck                   , 
    output                          flash_si                    , 
    input                           flash_so                    , 
// ----------------------------------------------------------------------------
// Phy
// ----------------------------------------------------------------------------
    output                          phy_rst                     , 
    input                           phy_link1000                , 
    input                           phy_link100                 , 

    input                           rgmii_rxclk                 , 
    input                           rgmii_rxdv                  , 
    input                     [3:0] rgmii_rxdata                , 
    output                          rgmii_txclk                 , 
    output                          rgmii_txen                  , 
    output                    [3:0] rgmii_txdata                  
);

wire                         [95:0] pwr_data                    ; 

wire                        [583:0] rxins_data_tmp              ; 

wire                         [15:0] key_data                    ; 
wire                                key_data_valid              ; 

time_top u_time_top(
    .sclk                           (clk_60m                    ), // (input )
    .clk_125M                       (clk_125m                   ), // (input )
    .rst_n                          (rst_n                      ), // (input )
    .IrigbIn                        (irigb_rx                   ), // (input )
    .rm_time_valid                  (cfg_rm_time_valid          ), // (input )
    .rm_time                        (cfg_rm_time[31:0]          ), // (input )
    .pps_b_syno                     (/* not used */             ), // (output)
    .TimerBSecond_ov                (local_time[63:0]           )  // (output)
);

monitor_top u_monitor_top(
    .sclk                           (clk_60m                    ), // (input )60MHZ
    .rst_n                          (rst_n                      ), // (input )
    .rx                             (pwr_uart_rx                ), // (input )
    .data_ov                        (pwr_data[95:0]             )  // (output)
);

assign pwr_voltage = {pwr_data[3*16+:16],pwr_data[0*16+:16]};
assign pwr_current = {pwr_data[4*16+:16],pwr_data[1*16+:16]};
assign pwr_power   = {pwr_data[5*16+:16],pwr_data[2*16+:16]};

power_state u_power_state(
    .clk_i                          (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
    .signal_i                       (pwr_sw_sel                 ), // (input )
    .signal_o                       (                           )  // (output)
);

slr_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_slr_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input )
    .local_time                     (local_time[63:0]           ), // (input )
    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (input )
    .cfg_pcm_header                 (cfg_pcm_header[7:0]        ), // (input )
    .cfg_dy_header                  (cfg_dy_header[7:0]         ), // (input )
// ----------------------------------------------------------------------------
// SLR Uart
// ----------------------------------------------------------------------------
    .slr_data_uart_rx               (slr_data_uart_rx           ), // (input )

    .slr_cfg_uart_rx                (slr_cfg_uart_rx            ), // (input )
    .slr_cfg_uart_tx                (slr_cfg_uart_tx            ), // (output)
// ----------------------------------------------------------------------------
// SLR Config & Data
// ----------------------------------------------------------------------------
    .slr_cfg_data                   (slr_cfg_data[7:0]          ), // (input )
    .slr_cfg_data_valid             (slr_cfg_data_valid         ), // (input )
    .slr_rd_data                    (slr_rd_data[7:0]           ), // (output)
    .slr_rd_data_valid              (slr_rd_data_valid          ), // (output)

    .rxins_data                     (rxins_data[575:0]          ), // (output)
    .rxins_data_valid               (rxins_data_valid           )  // (output)
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
    .clk_sys                        (clk_60m                    ), // (input )
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
    .uart_tx_en                     (upconvert_cfg_data_valid   ), // (input )
    .uart_tx_data                   (upconvert_cfg_data[7:0]    ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (upcovert_rd_data[7:0]      ), // (output)
    .uart_rx_data_valid             (upcovert_rd_data_valid     ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (upc_cfg_uart_rx            ), // (input )
    .uart_tx                        (upc_cfg_uart_tx            )  // (output)
);

uart_top #
(
    .U_DLY                          (U_DLY                      )  
)
u2_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd134                    ), // (input ) 16'd134  
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b1                       ), // (input )
    .check_sel                      (1'b0                       ), // (input )
    .check_filter                   (1'b1                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (pc_lctx_en                 ), // (input )
    .uart_tx_data                   (pc_lctx_data[7:0]          ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (pc_lcrx_data[7:0]          ), // (output)
    .uart_rx_data_valid             (pc_lcrx_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (pc_lcuart_rx               ), // (input )
    .uart_tx                        (pc_lcuart_tx               )  // (output)
);

uart_top #
(
    .U_DLY                          (U_DLY                      )  
)
u3_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd67                     ), // (input )
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b1                       ), // (input )
    .check_sel                      (1'b0                       ), // (input )
    .check_filter                   (1'b1                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (pc_rmtx_en                 ), // (input )
    .uart_tx_data                   (pc_rmtx_data[7:0]          ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (pc_rmrx_data[7:0]          ), // (output)
    .uart_rx_data_valid             (pc_rmrx_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (pc_rmuart_rx               ), // (input )
    .uart_tx                        (pc_rmuart_tx               )  // (output)
);

key_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_key_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    .cfg_key_filter_data            (cfg_key_filter_data[31:0]  ), // (input )
// ----------------------------------------------------------------------------
// Key In
// ----------------------------------------------------------------------------
    .key_in                         (key_in[15:0]               ), // (input )
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    .key_data                       (key_data[15:0]             ), // (output)
    .key_data_valid                 (key_data_valid             ), // (output)

    .key_lr_status                  (key_lr_status              ), // (output)
    .key_status_valid               (key_status_valid           ), // (output)
// ----------------------------------------------------------------------------
// Key Instruct
// ----------------------------------------------------------------------------
    .key_instruct_valid             (key_instruct_valid         ), // (output)
    .key_instruct                   (key_instruct[15:0]         )  // (output)
);

flash_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .inst_length                    (cfg_ins_length[15:0]       ), // (input )
    .cfg_ins_enable                 (cfg_ins_enable[7:0]        ), // (input )
// ----------------------------------------------------------------------------
// Instruct Config Data
// ----------------------------------------------------------------------------
    .mem_cfg_data                   (mem_cfg_data[7:0]          ), // (input )
    .mem_cfg_data_valid             (mem_cfg_data_valid         ), // (input )

    .mem_inst_data                  (mem_inst_data[511:0]       ), // (output)
    .mem_inst_data_valid            (mem_inst_data_valid        ), // (output)
// ----------------------------------------------------------------------------
// Initial Config Data
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (input )
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (input )

    .mem_rd_data                    (mem_rd_data[31:0]          ), // (output)
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// Instruct Send Port
// ----------------------------------------------------------------------------
    .key_inst                       (key_instruct[15:0]         ), // (input )
    .key_inst_valid                 (key_instruct_valid         ), // (input )

    .rm_inst                        (instruct_cfg_data[15:0]    ), // (input )
    .rm_inst_valid                  (instruct_cfg_data_valid    ), // (input )

    .tx_inst_data                   (tx_inst_data[511:0]        ), // (output)
    .tx_inst_data_valid             (tx_inst_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Flash 
// ----------------------------------------------------------------------------
    .flash_hold_n                   (flash_holdn                ), // (output)
    .flash_cs_n                     (flash_csn                  ), // (output)
    .flash_clk                      (flash_sck                  ), // (output)
    .flash_mosi                     (flash_si                   ), // (output)
    .flash_miso                     (flash_so                   )  // (input )
);

udp_top u_udp_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    .cfg_udp_socket                 (cfg_udp_socket[3:0]        ), // (input ) 4'b0001 point-to-point,4'b0100 multicast.
    .cfg_udp_srcport                (cfg_udp_srcport[15:0]      ), // (input )
    .cfg_udp_dstport                (cfg_udp_dstport[15:0]      ), // (input )
    .cfg_phy_srcip                  (cfg_phy_srcip[31:0]        ), // (input )
    .cfg_phy_dstip                  (cfg_phy_dstip[31:0]        ), // (input )
    .cfg_phy_srcmac                 (cfg_phy_srcmac[47:0]       ), // (input )
    .cfg_phy_dstmac                 (cfg_phy_dstmac[47:0]       ), // (input )
// ----------------------------------------------------------------------------
// User RX & TX Data
// ----------------------------------------------------------------------------
    .udp_tx_en                      (udp_tx_en                  ), // (input )
    .udp_tx_data                    (udp_tx_data[7:0]           ), // (input )

    .udp_rx_data                    (udp_rx_data[7:0]           ), // (output)
    .udp_rx_data_valid              (udp_rx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// Phy
// ----------------------------------------------------------------------------
    .phy_rst                        (phy_rst                    ), // (output)
    .phy_link1000                   (phy_link1000               ), // (input )
    .phy_link100                    (phy_link100                ), // (input )

    .rgmii_rxclk                    (rgmii_rxclk                ), // (input )
    .rgmii_rxdv                     (rgmii_rxdv                 ), // (input )
    .rgmii_rxdata                   (rgmii_rxdata[3:0]          ), // (input )
    .rgmii_txclk                    (rgmii_txclk                ), // (output)
    .rgmii_txen                     (rgmii_txen                 ), // (output)
    .rgmii_txdata                   (rgmii_txdata[3:0]          )  // (output)
);

endmodule




