
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    NetParadefine.v 
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
/*************************************************************************************************************
															PHYADDR
***************************************************************************************************************/	
`define			PHYADDR				5'b10010
/*************************************************************************************************************
															mac defines
***************************************************************************************************************/	
`define 		 		  MAC_TYPE              16'h0800 
`define 				ARP_TYPE					 	16'h0806 
`define 				IP_TYPE					 	16'h0800
`define 				HARDWAR_TYPE				16'h0001////16'h0001 hard type:ethernet network ;
//opcode
`define				REQ_OPCODE					16'h0001
`define				REPLY_OPCODE					16'h0002
//ip
`define 			    IP_VERSION            4'h4 
`define 			    IP_HEADER_LENGTH      4'h5 
`define 				   IP_TOS                8'h0 

//0
`define 		    IP_FLAGS              3'h2 
`define 		   IP_FRAGMENT_OFFSET    13'h0 
`define 		    IP_TTL                8'h80 
`define 		    UDP_PROTOCOL           8'h11 
/*************************************************************************************************************
															Protocol
***************************************************************************************************************/
`define				SocketInUDP			4'b0001
`define				SocketInTCP			4'b0010
`define				SocketInUDPGP		4'b0100
/*************************************************************************************************************
														user set
***************************************************************************************************************/	
`define 		LOCAL_MAC   	48'h5c_63_bf_41_6c_6a//ensure that you use a valid mac address
//`define 		DST_IP 		  	32'hc0_a8_01_6b //32'hc0_a8_01_107 
//`define 		LOCAL_IP		   32'hc0_a8_01_69 //32'hc0_a8_01_105 
`define		UDPTxPoartNum	6						//UDP Tx PoartNum. The MaxNum is 6,The MinNum is 2

`define		Tim_500_ms		32'h3B9ACA0

`define		Enable_MacAddress_Filter

