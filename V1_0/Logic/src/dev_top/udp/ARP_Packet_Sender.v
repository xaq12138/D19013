`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    ARP_Packet_Sender 
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
module ARP_Packet_Sender(
									clk,rst,
									//source port
									StartARPSend,
									StartARPACK,
									DST_MAC,Dst_IP,Local_IP,
									//port to mac
									Mac_tx_data,
									Mac_tx_mod,
									Mac_tx_sop,
									Mac_tx_eop,
									Mac_tx_wren,
									Mac_tx_rdy);
/****************************************************************************************************
											IOs
****************************************************************************************************/
input								clk,rst;
input								StartARPSend,StartARPACK;
input				[47:0]		DST_MAC;
input				[31:0]		Dst_IP,Local_IP;
output reg		[31:0]		Mac_tx_data;//data to mac
output reg		[1:0]			Mac_tx_mod;// 11:Mac_tx_data[23:0]  is not valid
													// 10:Mac_tx_data[15:0]  is not valid
													// 01:Mac_tx_data[7:0]  is not valid
													// 00:Mac_tx_data[31:0]  is  valid
output reg						Mac_tx_sop;//start of the tx packet
output reg						Mac_tx_eop;//end of the tx packet
output reg						Mac_tx_wren;//en the tx signal
input								Mac_tx_rdy;//mac ready
/****************************************************************************************************
											localparam
****************************************************************************************************/

localparam				SP0				  =	0;
localparam				SP1				  =	2;
localparam				SP2				  =	3;
localparam				SP3				  =	4;
localparam				SP4				  =	5;
localparam				SP5				  =	6;
localparam				SP6				  =	7;
localparam				SP7				  =	8;
localparam				SP8				  =	9;
localparam				SP9				  =	10;
localparam				SP10				  =	11;
localparam				SP11				  =	12;
localparam				SPn				  =	13;
/****************************************************************************************************
											reg & wire
****************************************************************************************************/
reg		[3:0]	 state,next_state;
reg		[15:0] ARPCmd;

wire    [31:0]  ip_word_0;
wire    [31:0]  ip_word_1;

wire    [31:0]  packet_word_0;
wire    [31:0]  packet_word_1;
wire    [31:0]  packet_word_2;
wire    [31:0]  packet_word_3;
wire    [31:0]  packet_word_4;
wire    [31:0]  packet_word_5;
wire    [31:0]  packet_word_6;
wire    [31:0]  packet_word_7;
wire    [31:0]  packet_word_8;
wire    [31:0]  packet_word_9;
wire    [31:0]  packet_word_10;
wire	  [47:0]	Dst_MAC,Src_MAC;
wire		[31:0]	LocalIP;

/****************************************************************************************************
											assigns
****************************************************************************************************/
assign		Dst_MAC=DST_MAC;
assign		Src_MAC=`LOCAL_MAC;
assign		LocalIP=Local_IP;
// IP header layout
//
assign ip_word_0    = {`HARDWAR_TYPE,`IP_TYPE};
assign ip_word_1    = {16'h0604,ARPCmd};//16'h0604  mac addr len 06 ; IP addr len  04;

// packet word layout
//
//assign packet_word_0    = Dst_MAC[47:16];
//assign packet_word_1    = {Dst_MAC[15:0], Src_MAC[47:32]};
//assign packet_word_2    = Src_MAC[31:0];
//assign packet_word_3    = {`ARP_TYPE, ip_word_0[31:16]};
//assign packet_word_4    = {ip_word_0[15:0], ip_word_1[31:16]};
//assign packet_word_5    = {ip_word_1[15:0], Src_MAC[47:32]};
//assign packet_word_6    = Src_MAC[31:0];
//assign packet_word_7    = `LOCAL_IP;
//assign packet_word_8    = Dst_MAC[47:16];//dst mac addr bits  
//assign packet_word_9    = {Dst_MAC[15:0], Dst_IP[31:16]};
//assign packet_word_10   = {Dst_IP[15:0],16'h0};


// packet word layout
//
assign packet_word_0    = {16'h0000,Dst_MAC[47:32]};
assign packet_word_1    = Dst_MAC[31:0];
assign packet_word_2    = Src_MAC[47:16];
assign packet_word_3    = {Src_MAC[15:0],`ARP_TYPE};
assign packet_word_4    = ip_word_0;
assign packet_word_5    = ip_word_1;
assign packet_word_6    = Src_MAC[47:16];
assign packet_word_7    = {Src_MAC[15:0],LocalIP[31:16]};
assign packet_word_8    = {LocalIP[15:0],Dst_MAC[47:32]};//dst mac addr bits 
assign packet_word_9    = Dst_MAC[31:0]; 
assign packet_word_10   = Dst_IP;
/****************************************************************************************************
											logic
****************************************************************************************************/								
always@(*)begin
	next_state=state;
	case(state)
		SP0:
			if( StartARPSend && Mac_tx_rdy)
				next_state=SP1;
		SP1:
			if(Mac_tx_rdy)
				next_state=SP2;
		SP2:
			if(Mac_tx_rdy)
				next_state=SP3;
		SP3:
			if(Mac_tx_rdy)
				next_state=SP4;
		SP4:
			if(Mac_tx_rdy)
				next_state=SP5;
		SP5:
			if(Mac_tx_rdy)
				next_state=SP6;
		SP6:
			if(Mac_tx_rdy)
				next_state=SP7;
		SP7:
			if(Mac_tx_rdy)
				next_state=SP8;
		SP8:
			if(Mac_tx_rdy)
				next_state=SP9;
		SP9:
			if(Mac_tx_rdy)
				next_state=SP10;
		SP10:
			if(Mac_tx_rdy)
				next_state=SP0;
//		SPn:
//			if(Mac_tx_rdy)
//				next_state=SP0;
	endcase
end

always@(posedge clk or posedge rst)
	if(rst)
		state<=SP0;
	else 
		state<=next_state;
		
		
always@(posedge clk or posedge rst)
	if(rst)begin
		Mac_tx_mod<=2'b00;
		Mac_tx_sop<=1'b0;
		Mac_tx_eop<=1'b0;
		Mac_tx_wren<=1'b0;
	end
	else case(state)
		SP0:begin
			//chk start 
			if(StartARPSend && Mac_tx_rdy)begin
				Mac_tx_eop<=1'b0;
				Mac_tx_sop<=1'b1;
				Mac_tx_wren<=1'b1;
				Mac_tx_data<=packet_word_0;
			end
			else begin
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
			//chk cmd
			if(StartARPACK)
				ARPCmd<=16'h0002;// 0001 reply host mac addr
			else 
				ARPCmd<=16'h0001; //0001 req host mac addr
		end
		SP1:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_1;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP2:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_2;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP3:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_3;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end  
		SP4:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_4;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP5:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_5;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP6:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_6;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP7:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_7;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP8:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_8;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP9:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_9;
				Mac_tx_wren<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		SP10:
			if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_10;
				Mac_tx_wren<=1'b1;
				Mac_tx_eop<=1'b1;
				Mac_tx_sop<=1'b0;
			end
			else begin
				Mac_tx_sop<=1'b0;
				Mac_tx_wren<=1'b0;
			end 
		//SPn:Mac_tx_data<=32'h0;
			
	endcase
									
endmodule	