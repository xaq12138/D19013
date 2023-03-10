// +FHDR============================================================================/
// Author       : huangjie
// Creat Time   : 2020/08/11 15:51:45
// File Name    : udp_top.v
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
// udp_top
//    |---
// 
`timescale 1ns/1ps

module udp_top 
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    input                     [3:0] cfg_udp_socket              ,  // 4'b0001 point-to-point,4'b0100 multicast.
    input                    [15:0] cfg_udp_srcport             , 
    input                    [15:0] cfg_udp_dstport             , 
    input                    [31:0] cfg_phy_srcip               , 
    input                    [31:0] cfg_phy_dstip               , 
    input                    [47:0] cfg_phy_srcmac              , 
    input                    [47:0] cfg_phy_dstmac              , 
// ----------------------------------------------------------------------------
// User RX & TX Data
// ----------------------------------------------------------------------------
    input                           udp_tx_en                   , 
    input                     [7:0] udp_tx_data                 , 

    output                    [7:0] udp_rx_data                 , 
    output                          udp_rx_data_valid           , 
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

wire                                udp_send_apply              ; 
wire                         [15:0] udp_send_data_len           ; 
wire                                udp_send_data_en            ; 
wire                         [31:0] udp_send_data               ; 
wire                                udp_send_over               ; 
									
wire                         [15:0] udp_rec_dst_port            ; 
wire                         [31:0] udp_rec_data                ; 
wire                                udp_rec_data_en             ; 
wire                         [15:0] udp_rec_data_len            ; 

wire                                txdram_wr_en                ; 
wire                         [13:0] txdram_wr_addr              ; 
wire                          [7:0] txdram_wr_data              ; 
wire                                txdram_rd_en                ; 
wire                         [11:0] txdram_rd_addr              ; 
wire                         [31:0] txdram_rd_data              ; 

wire                                txififo_wr_en               ; 
wire                         [31:0] txififo_wr_data             ; 
wire                                txififo_rd_en               ; 
wire                         [31:0] txififo_rd_data             ; 
wire                                txififo_empty               ; 

wire                                rxdram_wr_en                ; 
wire                         [11:0] rxdram_wr_addr              ; 
wire                         [31:0] rxdram_wr_data              ; 
wire                         [13:0] rxdram_rd_addr              ; 
wire                          [7:0] rxdram_rd_data              ; 

wire                                rxififo_wr_en               ; 
wire                         [31:0] rxififo_wr_data             ; 
wire                                rxififo_rd_en               ; 
wire                         [31:0] rxififo_rd_data             ; 
wire                                rxififo_empty               ; 

ethernet_pro_top u_ethernet_pro_top
(
    .Clk                            (clk_sys                    ), // (input )
    .Rst                            (!rst_n                     ), // (input )
//ethernet phy interface
    .enet_rest                      (phy_rst                    ), // (output)
    .enet_rx_clk                    (rgmii_rxclk                ), // (input )
    .enet_rx_dv                     (rgmii_rxdv                 ), // (input )
    .enet_rxd                       (rgmii_rxdata[3:0]          ), // (input )
    .enet_txd                       (rgmii_txdata[3:0]          ), // (output)
    .enet_tx_en                     (rgmii_txen                 ), // (output)
    .enet_gtx_clk                   (rgmii_txclk                ), // (output)
    .enet_link_1000                 (phy_link1000               ), // (input )
    .enet_link_100                  (phy_link100                ), // (input )
//user interface
    .cfg_udp_socket                 (cfg_udp_socket[3:0]        ), // (input ) 4'b0001 point-to-point,4'b0100 multicast.
    .cfg_phy_srcip                  (cfg_phy_srcip[31:0]        ), // (input )
    .cfg_phy_dstip                  (cfg_phy_dstip[31:0]        ), // (input )
    .LocMacAddr                     (cfg_phy_srcmac[47:0]       ), // (input )

    .enet_phy_link                  (                           ), // (output)
									
    .udp_send_apply                 (udp_send_apply             ), // (input )
    .udp_send_data                  (udp_send_data[31:0]        ), // (input )
    .udp_send_data_en               (udp_send_data_en           ), // (output)
    .udp_send_data_len              (udp_send_data_len[15:0]    ), // (input )
    .udp_send_over                  (udp_send_over              ), // (output)
    .udp_send_src_port              (cfg_udp_srcport[15:0]      ), // (input )
    .udp_send_dst_port              (cfg_udp_dstport[15:0]      ), // (input )
									
    .udp_rec_dst_port               (udp_rec_dst_port[15:0]     ), // (output)
    .udp_rec_sour_port              (                           ), // (output)
    .udp_rec_sour_ip                (                           ), // (output)
    .udp_rec_data                   (udp_rec_data[31:0]         ), // (output)
    .udp_rec_data_en                (udp_rec_data_en            ), // (output)
    .udp_rec_data_len               (udp_rec_data_len[15:0]     )  // (output)
);

internet_tx_ctrl # 
(
    .U_DLY                          (1                          )  
)
u_internet_tx_ctrl
(
// ----------------------------------------------------------------------------
// Clock @ Reset 
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// User Send Data
// ----------------------------------------------------------------------------
    .user_tx_en                     (udp_tx_en                  ), // (input )
    .user_tx_data                   (udp_tx_data[7:0]           ), // (input )
// ----------------------------------------------------------------------------
// Send FIFO
// ----------------------------------------------------------------------------
    .txdram_wr_en                   (txdram_wr_en               ), // (output)
    .txdram_wr_addr                 (txdram_wr_addr[13:0]       ), // (output)
    .txdram_wr_data                 (txdram_wr_data[7:0]        ), // (ointernet_rx_ctrlutput)
    .txdram_rd_en                   (txdram_rd_en               ), // (output)
    .txdram_rd_addr                 (txdram_rd_addr[11:0]       ), // (output)
    .txdram_rd_data                 (txdram_rd_data[31:0]       ), // (input )

    .txififo_wr_en                  (txififo_wr_en              ), // (output)
    .txififo_wr_data                (txififo_wr_data[31:0]      ), // (output)
    .txififo_rd_en                  (txififo_rd_en              ), // (output)
    .txififo_rd_data                (txififo_rd_data[31:0]      ), // (input )
    .txififo_empty                  (txififo_empty              ), // (input )
// ----------------------------------------------------------------------------
// UDP Send Data
// ----------------------------------------------------------------------------
    .udp_send_apply                 (udp_send_apply             ), // (output)
    .udp_send_data                  (udp_send_data[31:0]        ), // (output)
    .udp_send_data_en               (udp_send_data_en           ), // (input )
    .udp_send_data_len              (udp_send_data_len[15:0]    ), // (output)
    .udp_send_over                  (udp_send_over              )  // (input )
);  

sdpram_d16kw8_d4kw32 u_sdpram_d16kw8_d4kw32
(
    .clock                          (clk_sys                    ), 
    .wren                           (txdram_wr_en               ), 
    .wraddress                      (txdram_wr_addr[13:0]       ), 
    .data                           (txdram_wr_data[7:0]        ), 
    .rden                           (txdram_rd_en               ), 
    .rdaddress                      (txdram_rd_addr[11:0]       ), 
    .q                              (txdram_rd_data[31:0]       )  
);

fifo_d512w32_st u0_fifo_d512_w32_st
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (txififo_wr_en              ), 
    .data                           (txififo_wr_data[31:0]      ), 
    .rdreq                          (txififo_rd_en              ), 
    .q                              (txififo_rd_data[31:0]      ), 
    .empty                          (txififo_empty              ), 
    .full                           (                           )  
);

//`Internet_rx_byte u_Internet_rx_byte
//`(
//`    .Clk                            (clk_sys                    ), // (input )时钟60M
//`    .Rst                            (!rst_n                     ), // (input )高复位
//`    .udp_rec_dst_port               (udp_rec_dst_port[15:0]     ), // (input )目的地端口
//`    .udp_rec_data                   (udp_rec_data[31:0]         ), // (input )32位数据
//`    .udp_rec_data_en                (udp_rec_data_en            ), // (input )数据有效
//`    .udp_rec_data_len               (udp_rec_data_len[15:0]     ), // (input )长度，字节数
//`    .udp_rec_valid                  (udp_rx_data_valid          ), // (output)数据有效
//`    .udp_rec_byte                   (udp_rx_data[7:0]           )  // (output)按字节输出的网口数据
//`);

internet_rx_ctrl #
(
    .U_DLY                          (1                          )  
)
u_internet_rx_ctrl
(
// ----------------------------------------------------------------------------
// Clock @ Reset 
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    .cfg_udp_filter                 (1'b1                       ), // (input )
    .cfg_udp_rxdstport              (cfg_udp_srcport[15:0]      ), // (input )
// ----------------------------------------------------------------------------
// UDP Receive Data
// ----------------------------------------------------------------------------
    .udp_rx_length                  (udp_rec_data_len[15:0]     ), // (input )
    .udp_rxdst_port                 (udp_rec_dst_port[15:0]     ), // (input )
    .udp_rxdata                     (udp_rec_data[31:0]         ), // (input )
    .udp_rx_data_valid              (udp_rec_data_en            ), // (input )
// ----------------------------------------------------------------------------
// FIFO Write & Read Port
// ----------------------------------------------------------------------------
    .rxdram_wr_en                   (rxdram_wr_en               ), // (output)
    .rxdram_wr_addr                 (rxdram_wr_addr[11:0]       ), // (output)
    .rxdram_wr_data                 (rxdram_wr_data[31:0]       ), // (output)
    .rxdram_rd_addr                 (rxdram_rd_addr[13:0]       ), // (output)
    .rxdram_rd_data                 (rxdram_rd_data[7:0]        ), // (input )

    .rxififo_wr_en                  (rxififo_wr_en              ), // (output)
    .rxififo_wr_data                (rxififo_wr_data[31:0]      ), // (output)
    .rxififo_rd_en                  (rxififo_rd_en              ), // (output)
    .rxififo_rd_data                (rxififo_rd_data[31:0]      ), // (input )
    .rxififo_empty                  (rxififo_empty              ), // (input )
// ----------------------------------------------------------------------------
// User Receive Data
// ----------------------------------------------------------------------------
    .user_rx_data                   (udp_rx_data[7:0]           ), // (output)
    .user_rx_data_valid             (udp_rx_data_valid          )  // (output)
);

sdpram_d1kw32_d4kw8	u_sdpram_d1kw32_d4kw8
(
    .clock                          (clk_sys                    ), 
    .wren                           (rxdram_wr_en               ), 
    .wraddress                      (rxdram_wr_addr[11:0]       ), 
    .data                           (rxdram_wr_data[31:0]       ), 
    .rdaddress                      (rxdram_rd_addr[13:0]       ), 
    .q                              (rxdram_rd_data[7:0]        )  
);

fifo_d512w32_st u1_fifo_d512_w32_st
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (rxififo_wr_en              ), 
    .data                           (rxififo_wr_data[31:0]      ), 
    .rdreq                          (rxififo_rd_en              ), 
    .q                              (rxififo_rd_data[31:0]      ), 
    .empty                          (rxififo_empty              ), 
    .full                           (                           )  
);

endmodule




