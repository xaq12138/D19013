`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    EthernetManage 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
///
//////////////////////////////////////////////////////////////////////////////////
module	EthernetManage 
(
								input 									clk,rst,
								input			[3:0]						SetWorkProtocol,
								//mac interface
								output reg								ApplyMacTx,
								input										MacTxOver,
								input										ApplyReply,
								input										DstMacAddrRdy,
								//IGMPv3
								output reg								StartIGMPv3Send,
								//udp port 
								input			[`UDPTxPoartNum-1:0]	UDPSendApply,
								output reg								UDPDaEnToSend,
								output reg	[`UDPTxPoartNum-1:0]	UDPSendOver,
								output reg	[`UDPTxPoartNum-1:0]	UDPApplyShiftReg,
								//arp port
								input										ARPReqReced,
								output reg								ARPReplySSend,ARPReqSSend,
								output reg								ARPDaEnToSend);
/****************************************************************************************************
											reg & wire
****************************************************************************************************/			
reg											ARPReqReg,ClrARPReqReg,IGMPv3SendOnce,GoNextState;
reg			[3:0]							state,next_state;
reg			[31:0]						TimDlyCnt;
/****************************************************************************************************
											localparam
****************************************************************************************************/	
//state
localparam					INIT					=					0;	
localparam					SDARP1				=					1;	
localparam					SDUDP					=					2;	
localparam					SDARP2				=					3;	
localparam					CHKARP2				=					4;	
localparam					DELY					=					5;
localparam					WTAPPLY				=					6;
localparam					SIGMP					=					7;
/****************************************************************************************************
											logic
****************************************************************************************************/
// register ARPReqReced
always@(posedge clk or posedge rst)
	if(rst)
		ARPReqReg<=1'b0;
	else if(ClrARPReqReg)
		ARPReqReg<=1'b0;
	else if(ARPReqReced)
		ARPReqReg<=1'b1;
		
//manage logic
always@(*)begin
	next_state=state;
	case(state)
		INIT:
			if(StartIGMPv3Send)
				next_state=SIGMP;
			else if(GoNextState)
				next_state=WTAPPLY;
		WTAPPLY:
			if(ARPReplySSend)
				next_state=SDARP1;
			else if(ARPReqSSend)
				next_state=SDARP2;
			else if(UDPDaEnToSend)
				next_state=SDUDP;
		SDARP1:
			if(ARPReplySSend==1'b0)
				next_state=WTAPPLY;
		SDARP2:
			if(ARPReqSSend==1'b0)
				next_state=CHKARP2;
		CHKARP2:
			if( GoNextState)
				next_state=DELY;
			else if(ARPReqReg)
				next_state=WTAPPLY;
			else if(ARPReqSSend)
				next_state=SDARP2;
		SDUDP:
			if(UDPDaEnToSend==1'b0)
				next_state=WTAPPLY;
		SIGMP:
			if(GoNextState)
				next_state=WTAPPLY;
			else if(StartIGMPv3Send==1'b0)
				next_state=INIT;
		DELY:
			if(GoNextState)
				next_state=WTAPPLY;
		default:
			next_state=INIT;
	endcase
end		
always@(posedge clk or posedge rst)
	if(rst)
		state<=INIT;
	else 
		state<=next_state;
		
always@(posedge clk or posedge rst)
	if(rst)begin
		ARPReplySSend<=1'b0;
		ARPReqSSend<=1'b0;
		ClrARPReqReg<=1'b0;
		UDPDaEnToSend<=0;
		ApplyMacTx<=1'b0;
		ARPDaEnToSend<=1'b0;
		StartIGMPv3Send<=1'b0;
		IGMPv3SendOnce<=1'b0;
		TimDlyCnt<=32'h0;
		GoNextState<=1'b0;
		UDPSendOver<=`UDPTxPoartNum'h00;
		UDPApplyShiftReg<=`UDPTxPoartNum'h1;
	end
	else case(next_state)
		INIT:begin
			ARPReplySSend<=1'b0;
			ARPReqSSend<=1'b0;
			ClrARPReqReg<=1'b0;
			UDPDaEnToSend<=0;
			ARPDaEnToSend<=1'b0;
			UDPSendOver<=`UDPTxPoartNum'h00;
			UDPApplyShiftReg<=`UDPTxPoartNum'h1;
			if(TimDlyCnt==`Tim_500_ms && SetWorkProtocol==`SocketInUDPGP)begin
				TimDlyCnt<=32'h0;
				GoNextState<=1'b0;
				StartIGMPv3Send<=1'b1;
				ApplyMacTx<=1'b1;
			end
			else if(TimDlyCnt==`Tim_500_ms)begin
				TimDlyCnt<=32'h0;
				GoNextState<=1'b1;
				StartIGMPv3Send<=1'b0;
				ApplyMacTx<=1'b0;
			end
			else begin
				TimDlyCnt<=TimDlyCnt+1'b1;
				GoNextState<=1'b0;
				StartIGMPv3Send<=1'b0;
				ApplyMacTx<=1'b0;
			end
				
		end
		WTAPPLY:begin
			UDPSendOver<=`UDPTxPoartNum'h0;
			TimDlyCnt<=32'h0;
			if(ARPReqReg)begin
				ClrARPReqReg<=1'b1;
				ARPReplySSend<=1'b1;
				ApplyMacTx<=1'b1;
				UDPDaEnToSend<=1'b0;
				ARPDaEnToSend<=1'b1;
			end
			else if((UDPApplyShiftReg & UDPSendApply) && DstMacAddrRdy)begin
				UDPDaEnToSend<=1'b1;
				ARPDaEnToSend<=1'b0;
				ARPReplySSend<=1'b0;
				ApplyMacTx<=1'b1;
			end 
			else if(UDPApplyShiftReg & UDPSendApply)begin
				ClrARPReqReg<=1'b1;
				ARPReqSSend<=1'b1;
				ApplyMacTx<=1'b1;
				ARPReplySSend<=1'b0;
				UDPDaEnToSend<=1'b0;
				ARPDaEnToSend<=1'b1;
			end
			else 
				UDPApplyShiftReg<={UDPApplyShiftReg[`UDPTxPoartNum-2'b10:0],UDPApplyShiftReg[`UDPTxPoartNum-1'b1]};
		end
		SDARP1:begin
			ClrARPReqReg<=1'b0;
			//chk mac start
			if(ApplyReply)
				ApplyMacTx<=1'b0;
			//chk mac over
			if(MacTxOver)begin
				ARPDaEnToSend<=1'b0;
				ARPReplySSend<=1'b0;
			end
		end
		SDUDP:begin
			//chk mac start
			if(ApplyReply)
				ApplyMacTx<=1'b0;
			//chk mac over
			if(MacTxOver)begin
				UDPDaEnToSend<=1'b0;
				UDPSendOver<=UDPApplyShiftReg; 
				UDPApplyShiftReg<={UDPApplyShiftReg[`UDPTxPoartNum-2'b10:0],UDPApplyShiftReg[`UDPTxPoartNum-1'b1]};
			end
		end
		SIGMP:begin
			//chk mac start
			if(ApplyReply)
				ApplyMacTx<=1'b0;
			//chk mac over
			if(MacTxOver)begin
				StartIGMPv3Send<=1'b0;
				IGMPv3SendOnce<=1'b1;
				if(IGMPv3SendOnce)
					GoNextState<=1'b1;
				else
					GoNextState<=1'b0;	
			end
		end
		SDARP2:begin
			TimDlyCnt<=32'h0;
			ClrARPReqReg<=1'b0;
			//chk mac start
			if(ApplyReply)
				ApplyMacTx<=1'b0;
			//chk mac over
			if(MacTxOver)begin
				ARPDaEnToSend<=1'b0;
				ARPReqSSend<=1'b0;
			end
		end
		CHKARP2:begin
			if(DstMacAddrRdy)begin
				ARPReqSSend<=1'b0;
				TimDlyCnt<=32'h0;
				ApplyMacTx<=1'b0;
				ARPDaEnToSend<=1'b0;
				GoNextState<=1'b1;
			end
			else if(TimDlyCnt==`Tim_500_ms)begin
				ARPReqSSend<=1'b1;
				TimDlyCnt<=32'h0;
				ApplyMacTx<=1'b1;
				ARPDaEnToSend<=1'b1;
				GoNextState<=1'b0;
			end
			else begin
				TimDlyCnt<=TimDlyCnt+1'b1;
				GoNextState<=1'b0;
			end
		end
		DELY:
			if(TimDlyCnt==`Tim_500_ms)begin
				TimDlyCnt<=32'h0;
				GoNextState<=1'b1;
			end
			else begin
				TimDlyCnt<=TimDlyCnt+1'b1;
				GoNextState<=1'b0;
			end
			
			
	endcase
endmodule	