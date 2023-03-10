// +FHDR============================================================================/
// Author       : huangjie
// Creat Time   : 2020/10/15 14:12:32
// File Name    : d19012_sec_ctrl_top.v
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
// d19012_sec_ctrl_top
//    |---
// 
`timescale 1ns/1ps

module d19013_sec_ctrl_top # 
(
    parameter                       U_DLY = 1                   ,                  
    parameter                       FPGA_VER = 32'h00000010     ,
    parameter                       STATUS_SAMPLE_DATA = 32'd99_9999    
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    input                     [5:0] uart_rx                     , 
    output                    [3:0] uart_tx                     , 
// ----------------------------------------------------------------------------
// IRIG-B
// ----------------------------------------------------------------------------
    input                           irigb_rx                    , 
// ----------------------------------------------------------------------------
// Power Monitor 
// ----------------------------------------------------------------------------
    input                           pwr_sw_sel                  , 
// ----------------------------------------------------------------------------
// Key
// ----------------------------------------------------------------------------
    input                    [14:0] key_in                      , 
// ----------------------------------------------------------------------------
// Flash
// ----------------------------------------------------------------------------
    output                          flash_holdn                 , 
    output                          flash_csn                   , 
    output                          flash_sck                   , 
    output                          flash_si                    , 
    input                           flash_so                    , 
// ----------------------------------------------------------------------------
// AD9785
// ---------------------------------------------------------------------------- 
    input                           ad9785_dclk                 ,

    output                          ad9785_rst                  , 
    output                          ad9785_sdio                 , 
    output                          ad9785_sclk                 , 
    output                          ad9785_csn                  , 
    output                          ad9785_if_txen              , 

    output                   [11:0] ad_si_data                  , 
    output                   [11:0] ad_sq_data                  , 
// ----------------------------------------------------------------------------
// 88E1111
// ----------------------------------------------------------------------------
    output                          phy_rst                     , 
    output                          phy_col                     , 
    input                           phy_link1000                , 
    input                           phy_link100                 , 

    input                           rgmii_rxclk                 , 
    input                           rgmii_rxdv                  , 
    input                     [3:0] rgmii_rxdata                , 
    output                          rgmii_txclk                 , 
    output                          rgmii_txen                  , 
    output                    [3:0] rgmii_txdata                , 
// ----------------------------------------------------------------------------
// Debug
// ---------------------------------------------------------------------------- 
    output                    [1:0] debug_led                     
);

wire                                clk_60m                     ; 
wire                                clk_125m                    ; 
wire                                clk_100m                    ; 
wire                                rst_n                       ; 

wire                          [7:0] pc_lcrx_data                ; 
wire                                pc_lcrx_data_valid          ; 
wire                                pc_lctx_en                  ; 
wire                          [7:0] pc_lctx_data                ; 

wire                          [7:0] pc_rmrx_data                ; 
wire                                pc_rmrx_data_valid          ; 
wire                                pc_rmtx_en                  ; 
wire                          [7:0] pc_rmtx_data                ; 

wire                                udp_tx_en                   ; 
wire                          [7:0] udp_tx_data                 ; 

wire                          [7:0] udp_rx_data                 ; 
wire                                udp_rx_data_valid           ; 

wire                         [15:0] key_data                    ; 
wire                                key_data_valid              ; 

wire                                key_lr_status               ; 
wire                                key_status_valid            ; 

wire                        [575:0] txins_data                  ; 
wire                                txins_data_valid            ; 

wire                        [575:0] rxins_data                  ; 
wire                                rxins_data_valid            ; 

wire                        [511:0] memins_data                 ; 
wire                                memins_data_valid           ; 

wire                         [15:0] instruct_cfg_data           ; 
wire                                instruct_cfg_data_valid     ; 

wire                          [7:0] slr_cfg_data                ; 
wire                                slr_cfg_data_valid          ; 
wire                          [7:0] slr_rd_data                 ; 
wire                                slr_rd_data_valid           ; 

wire                          [7:0] upconvert_cfg_data          ; 
wire                                upconvert_cfg_data_valid    ; 
wire                          [7:0] upcovert_rd_data            ; 
wire                                upcovert_rd_data_valid      ; 

wire                          [7:0] mem_cfg_data                ; 
wire                                mem_cfg_data_valid          ; 

wire                                inter_cfg_wr_en             ; 
wire                                inter_cfg_rd_en             ; 
wire                         [15:0] inter_cfg_addr              ; 
wire                         [31:0] inter_cfg_wr_data           ; 
wire                         [31:0] inter_cfg_rd_data           ; 
wire                                inter_cfg_rd_data_valid     ; 

wire                                pc_ch_mode                  ; 

wire                                mem_rd_en                   ; 
wire                         [15:0] mem_rd_addr                 ; 
wire                         [31:0] mem_rd_data                 ; 
wire                                mem_rd_data_valid           ; 

wire                                soft_rst_en                 ; 

wire                         [15:0] cfg_ins_txcnt               ; // 指令发送次数
wire                          [7:0] cfg_ins_enable              ; // 指令有效标志
wire                         [15:0] cfg_ins_length              ; // 指令长度
wire                         [31:0] cfg_ins_waittime            ; // 发送间隔时间

wire                         [31:0] cfg_pcm_bitrate             ; // PCM码率
wire                         [31:0] cfg_pcm_fbias               ; // PCM频偏
wire                          [7:0] cfg_pcm_multsubc            ; // 副载波倍数
wire                          [3:0] cfg_pcm_codesel             ; // 码型选择
wire                                cfg_pcm_load_en             ; // 加载使能
wire                                cfg_pcm_keyer_en            ; // 加调使能

wire                        [159:0] dy_cfg_data                 ; 

wire                                cfg_keyer_sel               ; //调制体制选择  

wire                          [7:0] cfg_pcm_header              ; 
wire                          [7:0] cfg_dy_header               ; 
wire                         [31:0] cfg_key_filter_data         ; 

wire                         [31:0] cfg_status_waittime         ; 

wire                          [3:0] cfg_udp_socket              ; // 4'b0001 point-to-point,4'b0100 multicast.
wire                         [15:0] cfg_udp_srcport             ; 
wire                         [15:0] cfg_udp_dstport             ; 
wire                         [31:0] cfg_phy_srcip               ; 
wire                         [31:0] cfg_phy_dstip               ; 
wire                         [47:0] cfg_phy_srcmac              ; 
wire                         [47:0] cfg_phy_dstmac              ; 

wire                         [63:0] local_time                  ; 

wire                         [31:0] pwr_current                 ; 
wire                         [31:0] pwr_voltage                 ; 
wire                         [31:0] pwr_power                   ; 

wire                        [511:0] inst_data                   ; 
wire                                inst_data_valid             ; 

wire                        [511:0] pcm_tx_data                 ; 
wire                                pcm_tx_data_valid           ; 

wire                        [127:0] dy_tx_data                  ; 
wire                                dy_tx_data_valid            ; 

wire                                cfg_rm_time_valid           ; 
wire                         [31:0] cfg_rm_time                 ; 

assign phy_col = 1'b0;

board_top #
(
    .U_DLY                          (U_DLY                      ), 
    .SIMULATION                     ("FALSE"                    )  
)
u_board_top
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .soft_rst_en                    (soft_rst_en                ), // (input ) 
// ----------------------------------------------------------------------------
// Clock & Reset Generate
// ----------------------------------------------------------------------------
    .clk_60m                        (clk_60m                    ), // (output)
    .clk_125m                       (clk_125m                   ), // (output)
    .clk_100m                       (clk_100m                   ), // (output)
    .rst_n                          (rst_n                      )  // (output)
);

pc_transfer_top #
(
    .U_DLY                          (U_DLY                      ), 
    .STATUS_SAMPLE_DATA             (STATUS_SAMPLE_DATA         )  
)
u_pc_transfer_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Local PC data
// ----------------------------------------------------------------------------
    .pc_lcrx_data                   (pc_lcrx_data[7:0]          ), // (input )
    .pc_lcrx_data_valid             (pc_lcrx_data_valid         ), // (input )
    
    .pc_lctx_en                     (pc_lctx_en                 ), // (output)
    .pc_lctx_data                   (pc_lctx_data[7:0]          ), // (output)
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    .udp_tx_en                      (udp_tx_en                  ), // (output)
    .udp_tx_data                    (udp_tx_data[7:0]           ), // (output)

    .udp_rx_data                    (udp_rx_data[7:0]           ), // (input )
    .udp_rx_data_valid              (udp_rx_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Remote PC data
// ----------------------------------------------------------------------------
    .pc_rmrx_data                   (pc_rmrx_data[7:0]          ), // (input )
    .pc_rmrx_data_valid             (pc_rmrx_data_valid         ), // (input )

    .pc_rmtx_en                     (pc_rmtx_en                 ), // (output)
    .pc_rmtx_data                   (pc_rmtx_data[7:0]          ), // (output)
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    .debug_port_status              (32'd0                      ), // (input )
    .debug_power_current            (pwr_current[31:0]          ), // (input )
    .debug_power_voltage            (pwr_voltage[31:0]          ), // (input )
    .debug_power_data               (pwr_power[31:0]            ), // (input )
    .debug_local_time               (local_time[63:0]           ), // (input )
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    .key_data                       (key_data[15:0]             ), // (input )
    .key_data_valid                 (key_data_valid             ), // (input )

    .key_lr_status                  (key_lr_status              ), // (input )
    .key_status_valid               (key_status_valid           ), // (input )
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .txins_data                     (txins_data[575:0]          ), // (input )
    .txins_data_valid               (txins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .rxins_data                     (rxins_data[575:0]          ), // (input )
    .rxins_data_valid               (rxins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// Read Instruct Data
//
// instruct_rd_data[511:0]      : instruct data
// ----------------------------------------------------------------------------
    .memins_data                    (memins_data[511:0]         ), // (input )
    .memins_data_valid              (memins_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Instruct Config Data 
//
// instruct_cfg_data[15:0] insInstruct sign
// ----------------------------------------------------------------------------
    .instruct_cfg_data              (instruct_cfg_data[15:0]    ), // (output)
    .instruct_cfg_data_valid        (instruct_cfg_data_valid    ), // (output)
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    .slr_cfg_data                   (slr_cfg_data[7:0]          ), // (output)
    .slr_cfg_data_valid             (slr_cfg_data_valid         ), // (output)

    .slr_rd_data                    (slr_rd_data[7:0]           ), // (input )
    .slr_rd_data_valid              (slr_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    .upconvert_cfg_data             (upconvert_cfg_data[7:0]    ), // (output)
    .upconvert_cfg_data_valid       (upconvert_cfg_data_valid   ), // (output)

    .upcovert_rd_data               (upcovert_rd_data[7:0]      ), // (input )
    .upcovert_rd_data_valid         (upcovert_rd_data_valid     ), // (input )
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    .mem_cfg_data                   (mem_cfg_data[7:0]          ), // (output)
    .mem_cfg_data_valid             (mem_cfg_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Internal Config Port
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (output)
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (output)
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (output)
    .inter_cfg_wr_data              (inter_cfg_wr_data[31:0]    ), // (output)
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (input )
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .pc_ch_mode                     (pc_ch_mode                 ), // (output)

    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input ) 指令长度
    .cfg_status_waittime            (cfg_status_waittime[31:0]  )  // (input )
);

inter_cfg_top # 
(
    .U_DLY                          (U_DLY                      ), 
    .FPGA_VER                       (FPGA_VER                   )  
)
u_inter_cfg_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (input )
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (input )
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (input )
    .inter_cfg_wr_data              (inter_cfg_wr_data[31:0]    ), // (input )
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (output)
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (output)
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (output)
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (output)

    .mem_rd_data                    (mem_rd_data[31:0]          ), // (input )
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .soft_rst_en                    (soft_rst_en                ), // (output)

    .cfg_ins_txcnt                  (cfg_ins_txcnt[15:0]        ), // (output) 指令发送次数
    .cfg_ins_enable                 (cfg_ins_enable[7:0]        ), // (output) 指令有效标志
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (output) 指令长度
    .cfg_ins_waittime               (cfg_ins_waittime[31:0]     ), // (output) 发送间隔时间

    .cfg_pcm_bitrate                (cfg_pcm_bitrate[31:0]      ), // (output) PCM码率
    .cfg_pcm_fbias                  (cfg_pcm_fbias[31:0]        ), // (output) PCM频偏
    .cfg_pcm_multsubc               (cfg_pcm_multsubc[7:0]      ), // (output) 副载波倍数
    .cfg_pcm_codesel                (cfg_pcm_codesel[3:0]       ), // (output) 码型选择
    .cfg_pcm_load_en                (cfg_pcm_load_en            ), // (output) 加载使能
    .cfg_pcm_keyer_en               (cfg_pcm_keyer_en           ), // (output) 加调使能
    .cfg_pcm_header                 (cfg_pcm_header[7:0]        ), // (output)

    .dy_cfg_data                    (dy_cfg_data[159:0]         ), // (output)
    .cfg_dy_header                  (cfg_dy_header[7:0]         ), // (output)

    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (output)调制体制选择  

    .cfg_status_waittime            (cfg_status_waittime[31:0]  ), // (output)
    .cfg_key_filter_data            (cfg_key_filter_data[31:0]  ), // (output)

    .cfg_rm_time_valid              (cfg_rm_time_valid          ), // (output)
    .cfg_rm_time                    (cfg_rm_time[31:0]          ), // (output)

    .cfg_udp_socket                 (cfg_udp_socket[3:0]        ), // (output) 4'b0001 point-to-point,4'b0100 multicast.
    .cfg_udp_srcport                (cfg_udp_srcport[15:0]      ), // (output)
    .cfg_udp_dstport                (cfg_udp_dstport[15:0]      ), // (output)
    .cfg_phy_srcip                  (cfg_phy_srcip[31:0]        ), // (output)
    .cfg_phy_dstip                  (cfg_phy_dstip[31:0]        ), // (output)
    .cfg_phy_srcmac                 (cfg_phy_srcmac[47:0]       ), // (output)
    .cfg_phy_dstmac                 (cfg_phy_dstmac[47:0]       )  // (output)
);


dev_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_dev_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_60m                        (clk_60m                    ), // (input )
    .clk_100m                       (clk_100m                   ), // (input )
    .clk_125m                       (clk_125m                   ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input )
    .cfg_ins_enable                 (cfg_ins_enable[7:0]        ), // (input )
    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (input )
    .cfg_pcm_header                 (cfg_pcm_header[7:0]        ), // (input )
    .cfg_dy_header                  (cfg_dy_header[7:0]         ), // (input )
    .cfg_key_filter_data            (cfg_key_filter_data[31:0]  ), // (input )

    .cfg_rm_time_valid              (cfg_rm_time_valid          ), // (input )
    .cfg_rm_time                    (cfg_rm_time[31:0]          ), // (input )

    .cfg_udp_socket                 (cfg_udp_socket[3:0]        ), // (input ) 4'b0001 point-to-point,4'b0100 multicast.
    .cfg_udp_srcport                (cfg_udp_srcport[15:0]      ), // (input )
    .cfg_udp_dstport                (cfg_udp_dstport[15:0]      ), // (input )
    .cfg_phy_srcip                  (cfg_phy_srcip[31:0]        ), // (input )
    .cfg_phy_dstip                  (cfg_phy_dstip[31:0]        ), // (input )
    .cfg_phy_srcmac                 (cfg_phy_srcmac[47:0]       ), // (input )
    .cfg_phy_dstmac                 (cfg_phy_dstmac[47:0]       ), // (input )
// ----------------------------------------------------------------------------
// Remote & Local Uart
// ----------------------------------------------------------------------------
    .pc_lcuart_rx                   (uart_rx[0]                 ), // (input )
    .pc_lcuart_tx                   (uart_tx[0]                 ), // (output)
    
    .pc_rmuart_rx                   (uart_rx[1]                 ), // (input )
    .pc_rmuart_tx                   (uart_tx[1]                 ), // (output)

    .pc_lcrx_data                   (pc_lcrx_data[7:0]          ), // (output)
    .pc_lcrx_data_valid             (pc_lcrx_data_valid         ), // (output)
    .pc_lctx_en                     (pc_lctx_en                 ), // (input )
    .pc_lctx_data                   (pc_lctx_data[7:0]          ), // (input )

    .pc_rmrx_data                   (pc_rmrx_data[7:0]          ), // (output)
    .pc_rmrx_data_valid             (pc_rmrx_data_valid         ), // (output)
    .pc_rmtx_en                     (pc_rmtx_en                 ), // (input )
    .pc_rmtx_data                   (pc_rmtx_data[7:0]          ), // (input )
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    .udp_tx_en                      (udp_tx_en                  ), // (input )
    .udp_tx_data                    (udp_tx_data[7:0]           ), // (input )

    .udp_rx_data                    (udp_rx_data[7:0]           ), // (output)
    .udp_rx_data_valid              (udp_rx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// IRIG-B
// ----------------------------------------------------------------------------
    .irigb_rx                       (irigb_rx                   ), // (input )
// ----------------------------------------------------------------------------
// Local Time 
// ----------------------------------------------------------------------------
    .local_time                     (local_time[63:0]           ), // (output)
// ----------------------------------------------------------------------------
// Power Monitor 
// ----------------------------------------------------------------------------
    .pwr_uart_rx                    (uart_rx[4]                 ), // (input )
    .pwr_sw_sel                     (pwr_sw_sel                 ), // (input )

    .pwr_current                    (pwr_current[31:0]          ), // (output)
    .pwr_voltage                    (pwr_voltage[31:0]          ), // (output)
    .pwr_power                      (pwr_power[31:0]            ), // (output)
// ----------------------------------------------------------------------------
// SLR
// ----------------------------------------------------------------------------
    .slr_data_uart_rx               (uart_rx[5]                 ), // (input )

    .slr_cfg_uart_rx                (uart_rx[2]                 ), // (input )
    .slr_cfg_uart_tx                (uart_tx[2]                 ), // (output)

    .slr_cfg_data                   (slr_cfg_data[7:0]          ), // (input )
    .slr_cfg_data_valid             (slr_cfg_data_valid         ), // (input )
    .slr_rd_data                    (slr_rd_data[7:0]           ), // (output)
    .slr_rd_data_valid              (slr_rd_data_valid          ), // (output)

    .rxins_data                     (rxins_data[575:0]          ), // (output)
    .rxins_data_valid               (rxins_data_valid           ), // (output)
// ----------------------------------------------------------------------------
// Up Convert
// ----------------------------------------------------------------------------
    .upc_cfg_uart_rx                (uart_rx[3]                 ), // (input )
    .upc_cfg_uart_tx                (uart_tx[3]                 ), // (output)

    .upconvert_cfg_data             (upconvert_cfg_data[7:0]    ), // (input )
    .upconvert_cfg_data_valid       (upconvert_cfg_data_valid   ), // (input )
    .upcovert_rd_data               (upcovert_rd_data[7:0]      ), // (output)
    .upcovert_rd_data_valid         (upcovert_rd_data_valid     ), // (output)
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    .key_in                         ({1'b0,key_in[14:0]}        ), // (input )

    .key_instruct                   (key_data[15:0]             ), // (output)
    .key_instruct_valid             (key_data_valid             ), // (output)

    .key_lr_status                  (key_lr_status              ), // (output)
    .key_status_valid               (key_status_valid           ), // (output)
// ----------------------------------------------------------------------------
// Instruct Config Data 
//
// instruct_cfg_data[15:0] insInstruct sign
// ----------------------------------------------------------------------------
    .instruct_cfg_data              (instruct_cfg_data[15:0]    ), // (input )
    .instruct_cfg_data_valid        (instruct_cfg_data_valid    ), // (input )
// ----------------------------------------------------------------------------
// Flash
// ----------------------------------------------------------------------------
    .mem_cfg_data                   (mem_cfg_data[7:0]          ), // (input )
    .mem_cfg_data_valid             (mem_cfg_data_valid         ), // (input )

    .mem_rd_en                      (mem_rd_en                  ), // (input )
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (input )
    .mem_rd_data                    (mem_rd_data[31:0]          ), // (output)
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (output)

    .mem_inst_data                  (memins_data[511:0]         ), // (output)
    .mem_inst_data_valid            (memins_data_valid          ), // (output)

    .tx_inst_data                   (inst_data[511:0]           ), // (output)
    .tx_inst_data_valid             (inst_data_valid            ), // (output)

    .flash_holdn                    (flash_holdn                ), // (output)
    .flash_csn                      (flash_csn                  ), // (output)
    .flash_sck                      (flash_sck                  ), // (output)
    .flash_si                       (flash_si                   ), // (output)
    .flash_so                       (flash_so                   ), // (input )
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

inst_tx_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_inst_tx_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_60m                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    .cfg_ins_txcnt                  (cfg_ins_txcnt[15:0]        ), // (input ) 指令发送次数
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input ) 指令长度
    .cfg_ins_waittime               (cfg_ins_waittime[31:0]     ), // (input ) 发送间隔时间
    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (input ) 调制体制选择  
// ----------------------------------------------------------------------------
// Time
// ----------------------------------------------------------------------------
    .local_time                     (local_time[63:0]           ), // (input )
// ----------------------------------------------------------------------------
// Instruct Data From Memory
// ----------------------------------------------------------------------------
    .inst_data                      (inst_data[511:0]           ), // (input )
    .inst_data_valid                (inst_data_valid            ), // (input )
// ----------------------------------------------------------------------------
// Log Instruct Data 
// ----------------------------------------------------------------------------
    .log_inst_data                  (txins_data[575:0]          ), // (output)
    .log_inst_data_valid            (txins_data_valid           ), // (output)
// ----------------------------------------------------------------------------
// PCM Instruct Data
// ----------------------------------------------------------------------------
    .pcm_tx_data                    (pcm_tx_data[511:0]         ), // (output)
    .pcm_tx_data_valid              (pcm_tx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// DY Instruct Data
// ----------------------------------------------------------------------------
    .dy_tx_data                     (dy_tx_data[127:0]          ), // (output)
    .dy_tx_data_valid               (dy_tx_data_valid           ), // (output)
// ----------------------------------------------------------------------------
// Debug Status
// ----------------------------------------------------------------------------
    .debug_tx_overflow              (                           )  // (output)
);


BFMPrj u_BFMPrj(
/********************  时钟  *****************************/
    .clk_sys                        (clk_60m                    ), // (input )系统时钟，62.5M
    .SysRst                         (!rst_n                     ), // (input )
    .DA_IF_DATACLK                  (ad9785_dclk                ), // (input )9785时钟，62.5M
/********************  多音参数  *****************************/
    .CFGADSourceState1_DY           (dy_cfg_data[0]             ), // (input )加载/去载
    .CFGADSourceState2_DY           (dy_cfg_data[32]            ), // (input )加调/去调
    .cfg_offset_freq_dy             (dy_cfg_data[79:64]         ), // (input )
/********************  多音数据  *****************************/
    .valid_DY                       (dy_tx_data_valid           ), // (input )多音数据有效信号
    .DY_data_DY                     (dy_tx_data[127:0]          ), // (input )多音数据
/********************  副载波参数  *****************************/
    .CFGADSourceState1              (cfg_pcm_load_en            ), // (input )加载/去载
    .CFGADSourceState2              (cfg_pcm_keyer_en           ), // (input )加调/去调
    .CFGADSourceCarrierTime         (cfg_pcm_multsubc[7:0]      ), // (input )倍数
    .CFGADSourceCarrierFreqShift    (cfg_pcm_fbias[31:0]        ), // (input )频偏
    .CFGADSourcePcmFreq             (cfg_pcm_bitrate[31:0]      ), // (input )码率
    .pcm_type                       (cfg_pcm_codesel[3:0]       ), // (input )码型
    .cfg_inst_length                (cfg_ins_length[7:0]        ), // (input )
/********************  副载波数据  *****************************/
    .data_pcm                       (pcm_tx_data[511:0]         ), // (input )8bit指令数据           [7:0]		
    .data_pcm_valid                 (pcm_tx_data_valid          ), // (input )fifo写入数据请求          
/********************  调制体制  *****************************/
    .IQModem_type                   (cfg_keyer_sel              ), // (input )调制体制选择

/********************  DA9785_SPI  *****************************/
    .da_reset                       (ad9785_rst                 ), // (output)
    .da_spi_sdio                    (ad9785_sdio                ), // (output)
    .da_spi_sclk                    (ad9785_sclk                ), // (output)
    .da_spi_csb                     (ad9785_csn                 ), // (output)
    .DA_IF_TXEN                     (ad9785_if_txen             ), // (output)
/********************   tiaozhi DATA  *****************************/
    .ad_si_data                     (ad_si_data[11:0]           ), // (output)输出到9785的数据
    .ad_sq_data                     (ad_sq_data[11:0]           ), // (output)输出到9785的数据
/********************  多音空闲状态  *****************************/
    .empty_o_DY                     (                           ), // (output)多音空闲状态指示，0表示空闲，1表示忙绿
    .led                            (debug_led[1:0]             )  // (output)
);


endmodule



