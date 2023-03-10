`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    UDP_Packet_Receiver 
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
module UDP_Packet_Receiver(
										clk,rst,
										UDPDstPort,
										UDPSourPort,
										UDPSourIP,
										UDPUserDaOut,
										UDPUserDaOutEn,
										UDPUserDaLen,
										Local_IP,
										SetWorkProtocol,
										
										Mac_rx_data,
										Mac_rx_mod,
										Mac_rx_eop,
										Mac_rx_sop,
										Mac_rx_dval);

/****************************************************************************************************
											IOs
****************************************************************************************************/
input									clk,rst;
output reg		[31:0]			UDPSourIP;//rec udp data sour IP ,this signal is valid when UDPUserDaOutEn goes high 
output reg		[15:0]			UDPDstPort;//rec udp data dstport ,this signal is valid when UDPUserDaOutEn goes high 
output reg		[15:0]			UDPSourPort;//rec udp data sourport ,this signal is valid when UDPUserDaOutEn goes high 
output reg		[31:0]			UDPUserDaOut;//rec udp data
output reg							UDPUserDaOutEn;
output reg		[15:0]			UDPUserDaLen;//user data leng // bytes
input				[31:0]			Local_IP;
input				[3:0]				SetWorkProtocol;
//output reg							UDPCheckOk;//UDP check done
input				[31:0]			Mac_rx_data;//data fro mac
input				[1:0]				Mac_rx_mod;// 11:Mac_rx_data[23:0]  is not valid
														// 10:Mac_rx_data[15:0]  is not valid
														// 01:Mac_rx_data[7:0]  is not valid
														// 00:Mac_rx_data[31:0]  is  valid
input									Mac_rx_sop;//start of the packet
input									Mac_rx_eop;//end of the packet
input									Mac_rx_dval;//when asserted ,Mac_rx_data/Mac_rx_mod/Mac_rx_eop
														//Mac_rx_sop  are valid.
/****************************************************************************************************
											wire & reg
****************************************************************************************************/
reg				[1:0]				state,next_state;
//reg				[31:0]			PacketTypeChkReg;
//reg				[47:0]			DstMacAddrReg;
reg									UDPPacketRec;
reg				[15:0]			ByteCnt;
reg				[31:0]			IPPacketTypeReg;
//reg				[15:0]			IPPacketTotalLen;
reg				[15:0]			UDPPacketLen;
/****************************************************************************************************
											parameter
****************************************************************************************************/
parameter							INIT			=		0;
parameter							GETHEAD		=		1;
parameter							GETUDPDA	=		2;
parameter							CHKIP			=		3;
/****************************************************************************************************
											logic
****************************************************************************************************/
always@(*)begin
	next_state=state;
	case(state)
		INIT:
			if(Mac_rx_sop && Mac_rx_dval)
				next_state=GETHEAD;
		GETHEAD:
			if(UDPPacketRec && ByteCnt==16'h1a && Mac_rx_dval)
				next_state=CHKIP;
			else if(Mac_rx_eop && Mac_rx_dval)
				next_state=INIT;
		CHKIP:
			if(Mac_rx_dval && UDPPacketRec && ByteCnt==16'h26)
				next_state=GETUDPDA;
			else if(Mac_rx_dval  && ByteCnt==16'h26)
				next_state=INIT;
		GETUDPDA:
			if(Mac_rx_eop && Mac_rx_dval)
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
		UDPUserDaLen<=16'h00;
		//UDPCheckOk<=1'b0;
		UDPUserDaOutEn<=1'b0;
	end
	else case(state)
		INIT:begin
			UDPPacketRec<=1'b0;
			UDPUserDaOutEn<=1'b0;
			UDPUserDaLen<=16'h0;
			if(Mac_rx_sop && Mac_rx_dval)begin
				ByteCnt<=16'h2;
			end
		end
		GETHEAD:begin
			//received packet len
			if(Mac_rx_dval)
				ByteCnt<=ByteCnt+8'h4;
			//get the packet dst mac addr.(as dst mac addr for this Ethernet module)
//			if(ByteCnt==16'h4)
//				DstMacAddrReg[47:32]<=Mac_rx_data[15:0];
//			if(ByteCnt==16'h8)
//				DstMacAddrReg[31:0]<=Mac_rx_data;
			//	get IP Packet 
			if(ByteCnt==16'ha && Mac_rx_dval)
				IPPacketTypeReg[31:16]<=Mac_rx_data[15:0];
			if(ByteCnt==16'he && Mac_rx_dval)begin
				IPPacketTypeReg[15:0]<=Mac_rx_data[31:16];
				//IPPacketTotalLen<=Mac_rx_data[15:0];
			end
 			if(ByteCnt==16'h16 && Mac_rx_dval && Mac_rx_data[23:16]==`UDP_PROTOCOL && IPPacketTypeReg=={`IP_TYPE,`IP_VERSION,`IP_HEADER_LENGTH,8'h00})
				UDPPacketRec<=1'b1;
			//get sour IP
			if(ByteCnt==16'h1a && Mac_rx_dval)
				UDPSourIP<=Mac_rx_data;
		end
		CHKIP:begin
			if(Mac_rx_dval && ByteCnt==16'h26)
				ByteCnt<=16'h0;
			else if(Mac_rx_dval)
				ByteCnt<=ByteCnt+8'h4;
			//chk IP
			if(ByteCnt==16'h1e && Mac_rx_dval && (Mac_rx_data==Local_IP || SetWorkProtocol==`SocketInUDPGP))begin
				UDPPacketRec<=1'b1;
			end
			else if(ByteCnt==16'h1e && Mac_rx_dval)
				UDPPacketRec<=1'b0;
			//Get UDP Port	
			if(ByteCnt==16'h22 && Mac_rx_dval)begin
				UDPDstPort<=Mac_rx_data[15:0];
				UDPSourPort<=Mac_rx_data[31:16];
			end
			//received udp packet len
			if(Mac_rx_dval && ByteCnt==16'h26)
				UDPUserDaLen<=Mac_rx_data[31:16]-16'h8;
		end
		GETUDPDA:begin
			if(Mac_rx_dval && Mac_rx_eop)begin
				if(Mac_rx_mod==2'b11)
					ByteCnt<=ByteCnt+16'h1;
				else if(Mac_rx_mod==2'b10)
					ByteCnt<=ByteCnt+16'h2;
				else if(Mac_rx_mod==2'b01)
					ByteCnt<=ByteCnt+16'h3;
				else 
					ByteCnt<=ByteCnt+16'h4;
			end
			else if(Mac_rx_dval)
				ByteCnt<=ByteCnt+8'h4;
			//received udp data
			if(Mac_rx_dval && ByteCnt<UDPUserDaLen)begin
				UDPUserDaOutEn<=1'b1;
				UDPUserDaOut<=Mac_rx_data;
			end
			else begin
				UDPUserDaOutEn<=1'b0;
				UDPUserDaOut<=32'h0;
			end
		end
	endcase
endmodule	