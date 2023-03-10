`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    ARP_Stack 
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
module ARP_Stack(
						input						clk,rst,

						input			[31:0]	SetDataDstIP,
						input			[3:0]		SetWorkProtocol,
						input						ARPReqReced,ARPReplyReced,
						output reg	[47:0]	DstMacAddrForSend,
						output reg				DstMacAddrRdy,
						input			[47:0]	RecDstMacAddr);
/****************************************************************************************************
											localparam
****************************************************************************************************/

localparam				INIT					  =	0;
localparam				UPADDR				  =	1;
localparam				TIMOUT				  =	2;
localparam				UPGroupMAC			  =	3;
/****************************************************************************************************
											reg & wire
****************************************************************************************************/
reg			[1:0]		state,next_state;
/****************************************************************************************************
											assigns
****************************************************************************************************/

/****************************************************************************************************
											logic
****************************************************************************************************/								
always@(*)begin
	next_state=state;
	case(state)
		INIT:
			if(ARPReplyReced==1'b1)
				next_state=UPADDR;
			else if(SetWorkProtocol==`SocketInUDPGP)
				next_state=UPGroupMAC;
				
		UPADDR:
			next_state=TIMOUT;
		UPGroupMAC:
			next_state=UPGroupMAC;
		TIMOUT:
			if( ARPReplyReced)
				next_state=UPADDR;
			else
				next_state=TIMOUT;
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
		DstMacAddrForSend<=48'hFFFF_FFFF_FFFF;
		DstMacAddrRdy<=1'b0;
	end
	else case(next_state)
		INIT:begin
			DstMacAddrForSend<=48'hFFFF_FFFF_FFFF;
			DstMacAddrRdy<=1'b0;
		end
		UPADDR:begin
			DstMacAddrForSend<=RecDstMacAddr;
			DstMacAddrRdy<=1'b1;
		end	
		TIMOUT:begin
			DstMacAddrForSend<=DstMacAddrForSend;
			DstMacAddrRdy<=1'b1;
		end	
		UPGroupMAC:begin
			DstMacAddrForSend<={24'h01005e,1'b0,SetDataDstIP[22:0]};
			DstMacAddrRdy<=1'b1;
		end	
			
	endcase
									
endmodule	