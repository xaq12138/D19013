/********************************************************************************
									Project Top-level 
  
  $Id: ethernet_pro_top.v

  $Date: 2014/10/11 17:26:24 
  $Revision: 1.00 
  $Author: 
  $Email:
  $Locker:  
  $State: 
*********************************************************************************/
module	ethernet_pro_top(
									input										Clk,
//									output									Clk_sys,
									input 									Rst,
									//ethernet phy interface
									output 									enet_rest,
									//output          					enet_mdc,
									//inout           					enet_mdio,
									input										enet_rx_clk,
									input										enet_rx_dv,
									input		[3:0]							enet_rxd,
									output 	[3:0]							enet_txd,
									output 									enet_tx_en,
									output 									enet_gtx_clk,
									input										enet_link_1000,
									input										enet_link_100,
									//user interface
                                    input                     [3:0] cfg_udp_socket              ,  // 4'b0001 point-to-point,4'b0100 multicast.
                                    input                    [31:0] cfg_phy_srcip               , 
                                    input                    [31:0] cfg_phy_dstip               , 
                                    input [47:0] LocMacAddr,
									output									enet_phy_link,										
									
									input						udp_send_apply,
									input		[31:0]						udp_send_data,
									output							udp_send_data_en,
									input		[15:0]						udp_send_data_len,
									output	               					udp_send_over,	
									input		[15:0]						udp_send_src_port,
									input		[15:0]						udp_send_dst_port,
									
									output 	[15:0]						udp_rec_dst_port,
									output 	[15:0]						udp_rec_sour_port,
									output 	[31:0]						udp_rec_sour_ip,
									output	[31:0]						udp_rec_data,
									output									udp_rec_data_en,
									output	[15:0]						udp_rec_data_len
);
/*************************************************************************************************************
															loacl wires
***************************************************************************************************************/	
reg																	locked_delay1;
wire																	net_tx_clk;
wire																	enet_rx_clk_net;
wire																	clk_125M_0deg;
wire																	clk_125M_90deg;
wire																	clk_25M_0deg;
wire																	clk_25M_90deg;

wire                         [5:0 ] UDPSendFifoRd               ; 
wire                          [5:0] UDPSendOver                 ; 


pll_internet_contro pll_internet_contro_inst(
	.Clk(																Clk),   //  refclk.clk
	.Rst(																Rst),      //   reset.reset
	.clk_125M_0deg(												clk_125M_0deg), // outclk0.clk
	.clk_125M_90deg(												clk_125M_90deg), // outclk1.clk
	.clk_25M_0deg(													clk_25M_0deg), // outclk1.clk
	.clk_25M_90deg(												clk_25M_90deg) // outclk1.clk
//	.Clk_sys(														Clk_sys)
	);

clkctr_s clkctr_s_inst1(
	.inclk(															enet_rx_clk),  //  altclkctrl_input.inclk
	.outclk(															enet_rx_clk_net)  // altclkctrl_output.outclk
	);
clkctr clk_contro1(
	.inclk3x(														clk_25M_0deg),
	.inclk2x(														clk_125M_0deg),
	.inclk1x(														),   //  altclkctrl_input.inclk1x
	.inclk0x(														),   //                  .inclk0x
	.clkselect(														{1'b1,enet_link_1000}), //                  .clkselect
	.outclk(															net_tx_clk)     // altclkctrl_output.outclk
	);

clkctr clk_contro2(
	.inclk3x(														clk_25M_90deg),
	.inclk2x(														clk_125M_90deg),
	.inclk1x(														),   //  altclkctrl_input.inclk1x
	.inclk0x(														),   //                  .inclk0x
	.clkselect(														{1'b1,enet_link_1000}), //                  .clkselect
	.outclk(															enet_gtx_clk)     // altclkctrl_output.outclk
	);
/*************************************************************************************************************
															EthernetModTop
***************************************************************************************************************/							
EthernetModTop  EthernetModTop
(
    .LocMacAddr                     (LocMacAddr[47:0]           ), // (input )
						.MacIPCFGClk(								Clk								),//用户接口时钟，最大100m
						.RstSys(										Rst								),//高复位,几个时钟周期
						.SysClk(										Clk								),//用户接口时钟，最大100m
						.RGMIITxClk(								net_tx_clk							),//网口MAC接口时钟，100m网==25m；1000m网==125m
									//ethernet phy interface
						.enet_Rest(									enet_rest							),//端口
									//output          					enet_mdc,
									//inout           					enet_mdio,
						.enet_rx_clk(								enet_rx_clk_net					),//端口
						.enet_rx_dv(								enet_rx_dv							),//端口
						.enet_rxd(									enet_rxd								),//端口
						.enet_txd(									enet_txd								),//端口
						.enet_tx_en(								enet_tx_en							),//端口
						.enet_link_1000(							enet_link_1000						),//端口
						.enet_link_100(							enet_link_100						),//端口
									
									//app user interface 
						.EnetPhyLink(								enet_phy_link						),//突发失联，为高时，连接正常；为低时，连接出问题，需要清除fifo内数据，重新申请
																												  //（为低时网口程序不提取fifo数据）
						
						.UDPSendApply(									{5'd0,udp_send_apply}					),//发送端申请（持续到UDPSendFifoRd），6组1bit
						.UDPSendFifoDout(							{160'd0,udp_send_data}						),//发送端数据，6组32bit。长度不为4整倍数时，数据从最后一32bit数中最高位开始取
						.UDPSendFifoRd(	UDPSendFifoRd										),//发送端使能，6组1bit
						.UDPSendFramLen(							{80'd0,udp_send_data_len}					),//发送端数据长度(字节)，最大UDP包1460字节，6组16bit
						.UDPSendOver(								UDPSendOver						),//发送端完成，6组1bit
						.UDPSendSRC_PORT(							{80'd0,udp_send_src_port}					),//发送端本地端口号（core需要，具体值不重要），6组16bit
						.UDPSendDST_PORT(							{80'd0,udp_send_dst_port}					),//发送端目的端口号，6组16bit
						
						.UDPRecDstPort(							udp_rec_dst_port					),//接收端目的端口，1组16bit
						.UDPRecSourPort(							udp_rec_sour_port					),//接收端数据来源端口，1组16bit
						.UDPRecSourIP(								udp_rec_sour_ip					),//接收端数据来源IP，1组32bit
						.UDPRecDataOut(							udp_rec_data						),//接收端数据，1组32bit。长度不为4整倍数时，数据从最后一32bit数中最高位开始取
						.UDPRecDaEnOut(							udp_rec_data_en					),//接收端使能，1组1bit
						.UDPRecDaLen(								udp_rec_data_len					),//接收端数据长度(字节)，最大UDP包1460字节，1组16bit
						//user sets
                        .SetLocalIP                     (					cfg_phy_srcip         ), //本地IP(联网时，每台设备不同)192.168.1.106
                        .SetDataDstIP                   (						cfg_phy_dstip        ), //32'hc0_a8_01_64//目的IP（主播时：224.1.1.x）
    .SetWorkProtocol                (							cfg_udp_socket      )  //4'b0001 SocketInUDP（点对点） 4'b0100 SocketInUDPGP（主播：224.1.1.x）	
);

assign udp_send_over = UDPSendOver[0];
assign udp_send_data_en = UDPSendFifoRd[0];




endmodule			
