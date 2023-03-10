`timescale 1ns / 1ps
`include        "NetParadefine.V"
/********************************************************************************
 
  $Id: EthernetModTop.v

  $Date: 	013/08/09 09:	6:	4 
  $Revision: 1.00 
  $Author: 
  $Email:
  $Locker:  
  $State: 
*********************************************************************************/
module	EthernetModTop 
(
    input [47:0] LocMacAddr,
									input										MacIPCFGClk,
									input										RstSys,
									input 									SysClk,
									input										RGMIITxClk,
									//ethernet phy interface
									output 									enet_Rest,
									//output          					enet_mdc,
									//inout           					enet_mdio,
									input										enet_rx_clk,
									input										enet_rx_dv,
									input		[3:0]							enet_rxd,
									output 	[3:0]							enet_txd,
									output 									enet_tx_en,
									input										enet_link_1000,
									input										enet_link_100,
									
									//app user interface 
									output 									EnetPhyLink,
									input		[`UDPTxPoartNum-1:0]		UDPSendApply,
									input		[191:0]						UDPSendFifoDout,
									input		[95:0]						UDPSendFramLen,
																				UDPSendSRC_PORT,
																				UDPSendDST_PORT,
									output 	[`UDPTxPoartNum-1:0]		UDPSendFifoRd,
									output 	[`UDPTxPoartNum-1:0]		UDPSendOver,
									
									output 	[15:0]						UDPRecDstPort,
									output 	[15:0]						UDPRecSourPort,
									output 	[31:0]						UDPRecSourIP,
									output 	[31:0]						UDPRecDataOut,
									output 									UDPRecDaEnOut,
									output 	[15:0]						UDPRecDaLen,
									//user sets
									input		[31:0]						SetLocalIP,
									input		[31:0]						SetDataDstIP,
									input		[3:0]							SetWorkProtocol
);
/*************************************************************************************************************
															loacl wires
***************************************************************************************************************/	
wire		[7:0]			MacCFGaddress;//
wire						MacCFGwrite,MacCFGread,waitrequest;
wire		[31:0]		MacCFGwritedata;
wire		[31:0]		MacCFGreaddata;
wire						mdio_in,mdio_oen,mdio_out;
wire		[31:0]		Mac_tx_data;
wire		[1:0]			Mac_tx_mod;
wire						Mac_tx_sop;
wire						Mac_tx_eop;
wire						Mac_tx_wren;
wire						Mac_tx_rdy;

wire		[31:0]		Mac_rx_data;
wire		[1:0]			Mac_rx_mod;
wire		[5:0]			Mac_rx_err;
wire						Mac_rx_sop;
wire						Mac_rx_eop;
wire						Mac_rx_dval;
wire						EtherNetCfgOver;
wire						ARPReqReced,ARPReplyReced;
wire		[47:0]		MacDstMacAddr;
reg		[31:0]		MacDstIPAddr;
wire		[47:0]		DstMacAddr;
wire		[31:0]		DstIPAddr;
wire						PhyLink,ARPReplySSend;
wire		[15:0]		AppTxFraLen;
wire						ARPDaEnToSend,ApplyMacTx,MacTxOver,ManageApplyReply,UDPDaEnToSend;
wire		[31:0]		ARP_tx_data,UDP_tx_data,IGMP_tx_data;
wire		[1:0]			ARP_tx_mod,UDP_tx_mod,IGMP_tx_mod;
wire						ARP_tx_sop,ARP_tx_eop,ARP_tx_wren,UDP_tx_sop,UDP_tx_eop,
							UDP_tx_wren,IGMP_tx_sop,IGMP_tx_eop,IGMP_tx_wren;
wire		[15:0]		SendingUDPLen;
wire		[31:0]		SendingUDPDa;
wire		[5:0]			UDPApplyShiftReg;
wire						SendingUDPRd,DstMacAddrRdy,StartIGMPv3Send;
wire		[15:0]		SendingUDPSRC_PORT,SendingUDPDST_PORT;
/*************************************************************************************************************
															assigns
***************************************************************************************************************/	
//assign					mdio_in				=				enet_mdio;
//assign					enet_mdio			=				mdio_oen		?		mdio_out		:	1'bz;
//assign					enet_gtx_clk		=				SysClk;
//assign					MacIPCFGClk			=				SysClk;
assign					enet_Rest			=				~RstSys;
assign					EnetPhyLink			=				~PhyLink;
assign					PhyLink				=				enet_link_1000 & enet_link_100;
assign					MacTxOver			=				Mac_tx_eop;
assign					ManageApplyReply	=				Mac_tx_sop;

//mac tx
assign					Mac_tx_data			=				EnableLastDWord	?	MacLast_tx_data :
																	ARPDaEnToSend		?	ARP_tx_data	 	:
																	UDPDaEnToSend		?	UDP_tx_data		:		
																	StartIGMPv3Send   ?  IGMP_tx_data    :32'h0;
																	
assign					Mac_tx_mod			=				EnableLastDWord	?	MacLast_tx_mod :
																	ARPDaEnToSend		?	ARP_tx_mod		:		
																	UDPDaEnToSend		?	UDP_tx_mod		:		
																	StartIGMPv3Send   ?  IGMP_tx_mod    :2'b00;	
																	
assign					Mac_tx_sop			=				EnableLastDWord	?	MacLast_tx_sop :
																	ARPDaEnToSend		?	ARP_tx_sop		:		
																	UDPDaEnToSend		?	UDP_tx_sop		:		
																	StartIGMPv3Send   ?  IGMP_tx_sop    :1'b0;

assign					Mac_tx_eop			=				EnableLastDWord	?	MacLast_tx_eop :
																	ARPDaEnToSend		?	ARP_tx_eop		:		
																	UDPDaEnToSend		?	UDP_tx_eop		:		
																	StartIGMPv3Send   ? IGMP_tx_eop    :  1'b0;

assign					Mac_tx_wren			=				EnableLastDWord	?	MacLast_tx_wren :
																	ARPDaEnToSend		?	ARP_tx_wren		:		
																	UDPDaEnToSend		?	UDP_tx_wren		:		
																	StartIGMPv3Send   ?  IGMP_tx_wren   :1'b0;
																	
assign					SendingUDPDa		=				UDPApplyShiftReg[0]==1'b1		?		UDPSendFifoDout[31:0]	:
																	UDPApplyShiftReg[1]==1'b1		?		UDPSendFifoDout[63:32]	:
																	UDPApplyShiftReg[2]==1'b1		?		UDPSendFifoDout[95:64]	:
																	UDPApplyShiftReg[3]==1'b1		?		UDPSendFifoDout[127:96]	:
																	UDPApplyShiftReg[4]==1'b1		?		UDPSendFifoDout[159:128]	:
																	UDPSendFifoDout[191:160]	;
assign					SendingUDPLen		=				UDPApplyShiftReg[0]==1'b1		?		UDPSendFramLen[15:0]	:
																	UDPApplyShiftReg[1]==1'b1		?		UDPSendFramLen[31:16]	:
																	UDPApplyShiftReg[2]==1'b1		?		UDPSendFramLen[47:32]	:
																	UDPApplyShiftReg[3]==1'b1		?		UDPSendFramLen[63:48]	:
																	UDPApplyShiftReg[4]==1'b1		?		UDPSendFramLen[79:64]	:
																	UDPSendFramLen[95:80]	;
assign					SendingUDPSRC_PORT=				UDPApplyShiftReg[0]==1'b1		?		UDPSendSRC_PORT[15:0]	:
																	UDPApplyShiftReg[1]==1'b1		?		UDPSendSRC_PORT[31:16]	:
																	UDPApplyShiftReg[2]==1'b1		?		UDPSendSRC_PORT[47:32]	:
																	UDPApplyShiftReg[3]==1'b1		?		UDPSendSRC_PORT[63:48]	:
																	UDPApplyShiftReg[4]==1'b1		?		UDPSendSRC_PORT[79:64]	:
																	UDPSendSRC_PORT[95:80]	;
assign					SendingUDPDST_PORT=				UDPApplyShiftReg[0]==1'b1		?		UDPSendDST_PORT[15:0]	:
																	UDPApplyShiftReg[1]==1'b1		?		UDPSendDST_PORT[31:16]	:
																	UDPApplyShiftReg[2]==1'b1		?		UDPSendDST_PORT[47:32]	:
																	UDPApplyShiftReg[3]==1'b1		?		UDPSendDST_PORT[63:48]	:
																	UDPApplyShiftReg[4]==1'b1		?		UDPSendDST_PORT[79:64]	:
																	UDPSendDST_PORT[95:80]	;
																	
assign					UDPSendFifoRd		=				SendingUDPRd==1'b1				?		UDPApplyShiftReg	:	`UDPTxPoartNum'h0;
/*************************************************************************************************************
															local state
***************************************************************************************************************/	
//always@(posedge SysClk or posedge RstSys)
//	if(RstSys)begin
//		MacDstMacAddr<=48'hffff_ffff;
//		MacDstIPAddr<=32'h0;
//	end
//	else if(ARPReqReced)begin
//		MacDstMacAddr<=DstMacAddr;
//		MacDstIPAddr<=DstIPAddr;
//	end



/*************************************************************************************************************
															ARP_Stack
***************************************************************************************************************/	
ARP_Stack	 ARPSCK(
						.clk(											SysClk					),
						.rst(											RstSys| PhyLink					),
						.SetDataDstIP(								SetDataDstIP						),
						.SetWorkProtocol(							SetWorkProtocol					),
						

						.ARPReqReced(								ARPReqReced							),
						.ARPReplyReced(							ARPReplyReced						),
						.DstMacAddrForSend(						MacDstMacAddr						),
						.DstMacAddrRdy(							DstMacAddrRdy						),
						.RecDstMacAddr(							DstMacAddr							));
/*************************************************************************************************************
															EthernetConfig
***************************************************************************************************************/							
EthernetConfig UMCFG(
    .LocMacAddr                     (LocMacAddr[47:0]           ), // (input )
						.clk(											MacIPCFGClk							),
						.rst(											RstSys 								),
						.EtherNetCfgOver(							EtherNetCfgOver					),
						//config signal
						.address(									MacCFGaddress						),
						.write(										MacCFGwrite							),
						.read(										MacCFGread							),
						.writedata(									MacCFGwritedata					),
						.readdata(									MacCFGreaddata						),
						.waitrequest(								waitrequest							));

/*************************************************************************************************************
															UDP_Packet_Sender
***************************************************************************************************************/								
UDP_Packet_Sender UDPSD(
						.clk(											SysClk					),
						.rst(											RstSys | PhyLink					),
						//UDP port
						.SRC_PORT(									SendingUDPSRC_PORT 				),
						.DST_PORT(									SendingUDPDST_PORT				),
						.DST_MAC(									MacDstMacAddr						),
						.Dst_IP(										SetDataDstIP						),//MacDstIPAddr
						.Local_IP(									SetLocalIP							),
						//source port
						.StartUDPSend(								ApplyMacTx & UDPDaEnToSend		),
						.UserDaPacketLen(							SendingUDPLen						),
						.UserDaFifoRd(								SendingUDPRd						),
						.UserDaFifoDout(							SendingUDPDa						),
						//port to mac
						.Mac_tx_data(								UDP_tx_data							),
						.Mac_tx_mod(								UDP_tx_mod							),
						.Mac_tx_sop(								UDP_tx_sop							),
						.Mac_tx_eop(								UDP_tx_eop							),
						.Mac_tx_wren(								UDP_tx_wren							),
						.Mac_tx_rdy(								Mac_tx_rdy & EnableMacTx							));
/*************************************************************************************************************
															IGMPv3_Join_Group
***************************************************************************************************************/	
						
IGMPv3_Join_Group UIGMP(
						.clk(											SysClk					),
						.rst(											RstSys | PhyLink					),
									//source port
						.Local_IP(									SetLocalIP							),
						.StartIGMPv3Send(						ApplyMacTx & StartIGMPv3Send	),
									//port to mac
						.Mac_tx_data(								IGMP_tx_data							),
						.Mac_tx_mod(								IGMP_tx_mod							),
						.Mac_tx_sop(								IGMP_tx_sop							),
						.Mac_tx_eop(								IGMP_tx_eop							),
						.Mac_tx_wren(								IGMP_tx_wren							),
						.Mac_tx_rdy(								Mac_tx_rdy & EnableMacTx							));
/*************************************************************************************************************
															ARP_Packet_Sender
***************************************************************************************************************/	
ARP_Packet_Sender	ARPSD(
						.clk(											SysClk					),
						.rst(											RstSys | PhyLink					),
						//source port
						.StartARPSend(								ApplyMacTx & ARPDaEnToSend		),
						.StartARPACK(								ARPReplySSend						),
						.DST_MAC(									DstMacAddr						),//MacDstMacAddr 48'hcc_63_bb_41_6c_aa
						.Dst_IP(										DstIPAddr						),//SetDataDstIP MacDstIPAddr
						.Local_IP(									SetLocalIP							),
						//port to mac
						.Mac_tx_data(								ARP_tx_data							),
						.Mac_tx_mod(								ARP_tx_mod							),
						.Mac_tx_sop(								ARP_tx_sop							),
						.Mac_tx_eop(								ARP_tx_eop							),
						.Mac_tx_wren(								ARP_tx_wren							),
						.Mac_tx_rdy(								Mac_tx_rdy & EnableMacTx							));
/*************************************************************************************************************
															UDP_Packet_Receiver
***************************************************************************************************************/		
 UDP_Packet_Receiver UDPREC(
						.clk(											SysClk					),
						.rst(											RstSys | PhyLink					),
						.UDPDstPort(								UDPRecDstPort						),
						.UDPSourPort(								UDPRecSourPort						),
						.UDPSourIP(									UDPRecSourIP						),
						.UDPUserDaOut(								UDPRecDataOut						),
						.UDPUserDaOutEn(							UDPRecDaEnOut						),
						.UDPUserDaLen(								UDPRecDaLen							),
						.Local_IP(									SetLocalIP							),
						.SetWorkProtocol(							SetWorkProtocol					),
						
						.Mac_rx_data(								Mac_rx_data							),
						.Mac_rx_mod(								Mac_rx_mod							),
						.Mac_rx_eop(								Mac_rx_eop							),
						.Mac_rx_sop(								Mac_rx_sop							),
						.Mac_rx_dval(								Mac_rx_dval							));
/*************************************************************************************************************
															ARP_Packet_Receiver
***************************************************************************************************************/		
ARP_Packet_Receiver ARPREC(
						.clk(											SysClk								),
						.rst(											RstSys | PhyLink					),
						.ARPReplyReced(							ARPReplyReced						),
						.ARPReqReced(								ARPReqReced							),
						.Local_IP(									SetLocalIP							),
						.ARPReqDstIP(								SetDataDstIP						),
						
						.Mac_rx_data(								Mac_rx_data							),
						.Mac_rx_mod(								Mac_rx_mod							),
						.Mac_rx_err(								Mac_rx_err							),
						.Mac_rx_eop(								Mac_rx_eop							),
						.Mac_rx_sop(								Mac_rx_sop							),
						.Mac_rx_dval(								Mac_rx_dval							),
						//
						.DstMacAddr(								DstMacAddr							),
						.DstIPAddr(									DstIPAddr							));

/*************************************************************************************************************
															EthernetManage
***************************************************************************************************************/	

EthernetManage  UNETM(
						.clk(											SysClk					),
						.rst(											RstSys| (~EtherNetCfgOver)	| PhyLink	),
						.SetWorkProtocol(							SetWorkProtocol					),
						//mac interface
						.ApplyMacTx(								ApplyMacTx							),
						.MacTxOver(									MacTxOver							),
						.ApplyReply(								ManageApplyReply					),
						.DstMacAddrRdy(							DstMacAddrRdy						),
						//IGMPv3
						.StartIGMPv3Send(							StartIGMPv3Send					),
						//udp port 
						.UDPSendApply(								UDPSendApply						),
						.UDPSendOver(								UDPSendOver							),
						.UDPDaEnToSend(							UDPDaEnToSend						),
						.UDPApplyShiftReg(						UDPApplyShiftReg					),
						//arp port
						.ARPReqReced(								ARPReqReced							),//
						.ARPReplySSend(							ARPReplySSend						),
						.ARPDaEnToSend(							ARPDaEnToSend						));
/*************************************************************************************************************
															thernet mac
***************************************************************************************************************/
reg				EnableMacTx;
reg				EnableLastDWord;
reg	[1:0]		MacInState;
reg		[31:0]		MacLast_tx_data;
reg		[1:0]			MacLast_tx_mod;
reg						MacLast_tx_sop;
reg						MacLast_tx_eop;
reg						MacLast_tx_wren;

always@(posedge	SysClk	or posedge	RstSys)
	if(RstSys)begin
		EnableMacTx<=1'b0;
		EnableLastDWord<=1'b0;
		MacInState<=0;
	end
	else if(PhyLink)begin
		EnableMacTx<=1'b0;
		EnableLastDWord<=1'b0;
		MacInState<=0;
	end
	else case(MacInState)
		0:
			if(Mac_tx_rdy)begin
				EnableMacTx<=1'b1;
				EnableLastDWord<=1'b0;
				MacInState<=1;
			end
			else begin
				EnableMacTx<=1'b0;
				EnableLastDWord<=1'b0;
				MacInState<=0;
			end
		1:
			if(Mac_tx_rdy)begin
				EnableMacTx<=1'b1;
				EnableLastDWord<=1'b0;
				MacLast_tx_data<=Mac_tx_data;
				MacLast_tx_mod<=Mac_tx_mod;
				MacLast_tx_sop<=Mac_tx_sop;
				MacLast_tx_eop<=Mac_tx_eop;
				MacLast_tx_wren<=Mac_tx_wren;
				MacInState<=1;
			end
			else if(Mac_tx_wren)begin
				EnableMacTx<=1'b0;
				MacLast_tx_data<=Mac_tx_data;
				MacLast_tx_mod<=Mac_tx_mod;
				MacLast_tx_sop<=Mac_tx_sop;
				MacLast_tx_eop<=Mac_tx_eop;
				MacLast_tx_wren<=Mac_tx_wren;
				EnableLastDWord<=1'b0;
				MacInState<=2;
			end
			else begin
				EnableMacTx<=1'b1;
				EnableLastDWord<=1'b0;
				MacLast_tx_data<=Mac_tx_data;
				MacLast_tx_mod<=Mac_tx_mod;
				MacLast_tx_sop<=Mac_tx_sop;
				MacLast_tx_eop<=Mac_tx_eop;
				MacLast_tx_wren<=Mac_tx_wren;
				MacInState<=1;
			end
		2:
			if(Mac_tx_rdy)begin
				EnableMacTx<=1'b0;
				EnableLastDWord<=1'b1;
				MacInState<=1;
			end
			else begin
				EnableMacTx<=1'b0;
				EnableLastDWord<=1'b0;
				MacInState<=2;
			end
	endcase
//	
TriSEthIP UMAC(
						//rst at least 3clks
						.reset(										RstSys								),
						//ctr
						.clk(											MacIPCFGClk							),//set the signal to a value less than or equal to 1	5MHz
    .reg_addr                       (MacCFGaddress[7:0]         ), // (input )                  control_port.address
    .reg_data_out                   (MacCFGreaddata[31:0]       ), // (output)
    .reg_rd                         (MacCFGread                 ), // (input )                              .read
    .reg_data_in                    (MacCFGwritedata[31:0]      ), // (input )                              .writedata
    .reg_wr                         (MacCFGwrite                ), // (input )                              .write
    .reg_busy                       (waitrequest                ), // (output)                              .waitrequest

//mactx
						.ff_tx_clk(									SysClk					),
						.ff_tx_data(								Mac_tx_data							),
						.ff_tx_mod(									Mac_tx_mod							),
						.ff_tx_sop(									Mac_tx_sop & Mac_tx_rdy							),
						.ff_tx_eop(									Mac_tx_eop & Mac_tx_rdy							),
						.ff_tx_err(									1'b0									),
						.ff_tx_wren(								Mac_tx_wren							),
						.ff_tx_crc_fwd(							1'b0									),
						.tx_ff_uflow(),
						.ff_tx_rdy(									Mac_tx_rdy							),
						.ff_tx_septy(),
						.ff_tx_a_full(),
						.ff_tx_a_empty(),
						//macrx
						.ff_rx_clk(									SysClk					),
						.ff_rx_rdy(									1'b1									),//UDPRecRdy
						.ff_rx_data(								Mac_rx_data							),
						.ff_rx_mod(									Mac_rx_mod							),
						.ff_rx_eop(									Mac_rx_eop							),
						.ff_rx_sop(									Mac_rx_sop							),
						.ff_rx_dval(								Mac_rx_dval							),
						.rx_err(										Mac_rx_err							),
						.rx_err_stat(),
						.rx_frm_type(),
						.ff_rx_dsav(),
						.ff_rx_a_full(),
						.ff_rx_a_empty(),
						//
						.xon_gen(),
						.xoff_gen(),
						//RGMII
						.tx_clk(										RGMIITxClk							),
						.rx_clk(										enet_rx_clk							),
						.rgmii_in(									enet_rxd								),
						.rx_control(								enet_rx_dv							),
						.rgmii_out(									enet_txd								),
						.tx_control(								enet_tx_en							),
						//mac state
						.set_10(										1'b0									),
						.set_1000(									~enet_link_1000					),//
						.ena_10(),
						.eth_mode()
						);
//TriSEthIP UMAC
//(
//	.clk(MacIPCFGClk) ,	// input  clk_sig
//	.reset(RstSys) ,	// input  reset_sig
//	.reg_addr				(MacCFGaddress) ,	// input [7:0] reg_addr_sig
//	.reg_data_out			(MacCFGreaddata) ,	// output [31:0] reg_data_out_sig
//	.reg_rd					(MacCFGread) ,	// input  reg_rd_sig
//	.reg_data_in			(MacCFGwritedata) ,	// input [31:0] reg_data_in_sig
//	.reg_wr					(MacCFGwrite) ,	// input  reg_wr_sig
//	.reg_busy				() ,	// output  reg_busy_sig
//	.tx_clk					(RGMIITxClk) ,	// input  tx_clk_sig
//	.rx_clk					(enet_rx_clk) ,	// input  rx_clk_sig
//	.set_10					(1'b0	) ,	// input  set_10_sig
//	.set_1000				(~enet_link_1000) ,	// input  set_1000_sig
//	.eth_mode				() ,	// output  eth_mode_sig
//	.ena_10					() ,	// output  ena_10_sig
//	.rgmii_in				(enet_rxd) ,	// input [3:0] rgmii_in_sig
//	.rgmii_out				(enet_txd) ,	// output [3:0] rgmii_out_sig
//	.rx_control				(enet_rx_dv) ,	// input  rx_control_sig
//	.tx_control				(enet_tx_en) ,	// output  tx_control_sig
//	.ff_rx_clk				(SysClk) ,	// input  ff_rx_clk_sig
//	.ff_tx_clk				(SysClk) ,	// input  ff_tx_clk_sig
//	.ff_rx_data				(Mac_rx_data) ,	// output [31:0] ff_rx_data_sig
//	.ff_rx_eop				(Mac_rx_eop) ,	// output  ff_rx_eop_sig
//	.rx_err					(Mac_rx_err) ,	// output [5:0] rx_err_sig
//	.ff_rx_mod				(Mac_rx_mod) ,	// output [1:0] ff_rx_mod_sig
//	.ff_rx_rdy				(1'b1) ,	// input  ff_rx_rdy_sig
//	.ff_rx_sop				(Mac_rx_sop) ,	// output  ff_rx_sop_sig
//	.ff_rx_dval				(Mac_rx_dval) ,	// output  ff_rx_dval_sig
//	.ff_tx_data				(Mac_tx_data) ,	// input [31:0] ff_tx_data_sig
//	.ff_tx_eop				(Mac_tx_eop) ,	// input  ff_tx_eop_sig
//	.ff_tx_err				(1'b0	) ,	// input  ff_tx_err_sig
//	.ff_tx_mod				(Mac_tx_mod) ,	// input [1:0] ff_tx_mod_sig
//	.ff_tx_rdy				(Mac_tx_rdy) ,	// output  ff_tx_rdy_sig
//	.ff_tx_sop				(Mac_tx_sop & Mac_tx_rdy	) ,	// input  ff_tx_sop_sig
//	.ff_tx_wren				(Mac_tx_wren) ,	// input  ff_tx_wren_sig
////	.magic_wakeup			() ,	// output  magic_wakeup_sig
////	.magic_sleep_n			(1'b0) ,	// input  magic_sleep_n_sig
//	.ff_tx_crc_fwd			(1'b0) ,	// input  ff_tx_crc_fwd_sig
//	.ff_tx_septy			() ,	// output  ff_tx_septy_sig
//	.tx_ff_uflow			() ,	// output  tx_ff_uflow_sig
//	.ff_tx_a_full			() ,	// output  ff_tx_a_full_sig
//	.ff_tx_a_empty			() ,	// output  ff_tx_a_empty_sig
//	.rx_err_stat			() ,	// output [17:0] rx_err_stat_sig
//	.rx_frm_type			() ,	// output [3:0] rx_frm_type_sig
//	.ff_rx_dsav				() ,	// output  ff_rx_dsav_sig
//	.ff_rx_a_full			() ,	// output  ff_rx_a_full_sig
//	.ff_rx_a_empty			() 	// output  ff_rx_a_empty_sig
//);
endmodule			
