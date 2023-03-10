`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    ARP_Packet_Receiver 
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
//////////////////////////////////////////////////////////////////////////////////
module ARP_Packet_Receiver(
										clk,rst,
										ARPReplyReced,
										ARPReqReced,
										
										Mac_rx_data,
										Mac_rx_mod,
										Mac_rx_eop,
										Mac_rx_sop,
										Mac_rx_dval,
										Mac_rx_err,
										//
										Local_IP,
										ARPReqDstIP,
										DstMacAddr,
										DstIPAddr);

/****************************************************************************************************
											IOs
****************************************************************************************************/
input									clk,rst;
output reg							ARPReqReced;//when high,arp req packet received
output reg							ARPReplyReced;//when high,arp Reply packet received
input				[31:0]			Local_IP;
input				[31:0]			ARPReqDstIP;//req which IP's macAddr
//output reg							ARPCheckOk;//arp check done
input				[31:0]			Mac_rx_data;//data fro mac
input				[1:0]				Mac_rx_mod;// 11:Mac_rx_data[23:0]  is not valid
														// 10:Mac_rx_data[15:0]  is not valid
														// 01:Mac_rx_data[7:0]  is not valid
														// 00:Mac_rx_data[31:0]  is  valid
input									Mac_rx_sop;//start of the packet
input									Mac_rx_eop;//end of the packet
input									Mac_rx_dval;//when asserted ,Mac_rx_data/Mac_rx_mod/Mac_rx_eop
														//Mac_rx_sop  are valid.
input				[5:0]				Mac_rx_err;
output reg		[47:0]			DstMacAddr;//
output reg		[31:0]			DstIPAddr;//the IP who asked the local IP
/****************************************************************************************************
											reg & wire
****************************************************************************************************/
reg				[1:0]				state,next_state;
reg				[47:0]			SrcMacAddrReg,DstMacAddrReg;
reg				[31:0]			SrcIPAddrReg,PacketTypeChkReg,DstIPAddrReg;
reg				[7:0]				ByteCnt;
reg				[15:0]			OPCodeReg;
reg				[15:0]			HardTypeReg;
reg									IPChkOk,IPChkErr;
/****************************************************************************************************
											parameter
****************************************************************************************************/
parameter							INIT			=		0;
parameter							PCGET			=		1;
parameter							PCCHK			=		2;
parameter							CHKIP			=		3;
/****************************************************************************************************
											logic
****************************************************************************************************/
always@(*)begin
	next_state=state;
	case(state)
		INIT:
			if(Mac_rx_sop && Mac_rx_dval)
				next_state=PCGET;
		PCGET:
			if(Mac_rx_eop && Mac_rx_dval && Mac_rx_err==6'h0)
				next_state=CHKIP;
			else if(Mac_rx_eop && Mac_rx_dval)
				next_state=INIT;
		CHKIP:
			if(IPChkOk)
				next_state=PCCHK;
			else if(IPChkErr)
				next_state=INIT;
		PCCHK:
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
		DstMacAddr<=48'hFFFF_FFFF_FFFF;
		DstMacAddrReg<=48'hFFFF_FFFF_FFFF;
		DstIPAddr<=32'h0;
		//ARPCheckOk<=1'b0;
		ARPReqReced<=1'b0;
		ARPReplyReced<=1'b0;
		IPChkErr<=1'b0;
		IPChkOk<=1'b0;
	end
	else case(state)
		INIT:begin
			ARPReqReced<=1'b0;
			ARPReplyReced<=1'b0;
			IPChkErr<=1'b0;
			IPChkOk<=1'b0;
			if(Mac_rx_sop && Mac_rx_dval)begin
				ByteCnt<=8'h2;
			end
		end
		PCGET:begin
			//received packet len
			if(Mac_rx_dval && Mac_rx_eop)begin
				if(Mac_rx_mod==2'b11)
					ByteCnt<=ByteCnt+8'h1;
				else if(Mac_rx_mod==2'b10)
					ByteCnt<=ByteCnt+8'h2;
				else if(Mac_rx_mod==2'b01)
					ByteCnt<=ByteCnt+8'h3;
				else 
					ByteCnt<=ByteCnt+8'h4;
			end
			else if(Mac_rx_dval)
				ByteCnt<=ByteCnt+8'h4;
			//get the packet src mac addr.(as dst mac addr for this Ethernet module)
			if(ByteCnt==8'h16 && Mac_rx_dval)
				SrcMacAddrReg[47:16]<=Mac_rx_data;
			if(ByteCnt==8'h1a  && Mac_rx_dval)
				SrcMacAddrReg[15:0]<=Mac_rx_data[31:16];
			//	Packet Type chk
 			if(ByteCnt==8'ha  && Mac_rx_dval)
				PacketTypeChkReg[15:0]<=Mac_rx_data[15:0];
			if(ByteCnt==8'he  && Mac_rx_dval)
				PacketTypeChkReg[31:16]<=Mac_rx_data[15:0];
			//get HardTypeReg
			if(ByteCnt==8'he  && Mac_rx_dval)
				HardTypeReg<=Mac_rx_data[31:16];
			//get the packet src IP addr.(as dst IP addr for this Ethernet module)
			if(ByteCnt==8'h1a  && Mac_rx_dval)
				SrcIPAddrReg[31:16]<=Mac_rx_data[15:0];
			if(ByteCnt==8'h1e  && Mac_rx_dval)
				SrcIPAddrReg[15:0]<=Mac_rx_data[31:16];
			//get the packet dst IP addr.(as src IP addr for this Ethernet module)
			if(ByteCnt==8'h26  && Mac_rx_dval)
				DstIPAddrReg<=Mac_rx_data;
			//get the packet src mac addr.(as dst mac addr for this Ethernet module)
			if(ByteCnt==8'h6 && Mac_rx_dval)
				DstMacAddrReg[47:16]<=Mac_rx_data;
			if(ByteCnt==8'ha  && Mac_rx_dval)
				DstMacAddrReg[16:0]<=Mac_rx_data[31:16];
			//OPCode
			if(ByteCnt==8'h12 && Mac_rx_dval)
				OPCodeReg<=Mac_rx_data[15:0];
		end
		CHKIP:
			if(DstIPAddrReg==Local_IP && OPCodeReg==`REQ_OPCODE || 
				SrcIPAddrReg==ARPReqDstIP  && OPCodeReg==`REPLY_OPCODE)
				IPChkOk<=1'b1;
			else
				IPChkErr<=1'b1;
		PCCHK:
			if(PacketTypeChkReg=={`IP_TYPE,`ARP_TYPE})begin
				if(OPCodeReg==`REPLY_OPCODE)begin
					DstMacAddr<=DstMacAddrReg;
					ARPReplyReced<=1'b1;
					ARPReqReced<=1'b0;
				end
				else if(OPCodeReg==`REQ_OPCODE )begin
					DstMacAddr<=SrcMacAddrReg;
					DstIPAddr<=SrcIPAddrReg;
					ARPReqReced<=1'b1;
					ARPReplyReced<=1'b0;
				end
			end
	endcase
endmodule	