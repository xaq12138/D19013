`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/07/2013 
// Design Name: 
// Module Name:    UDP_Packet_Sender 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//  The standard format of each of the header layers is illustrated below, you
//  can think of each layer being wrapped in the payload section of the layer
//  above it, with the Ethernet packet layout being the outer most wrapper.
//  
//  Standard Ethernet Packet Layout
//  |-------------------------------------------------------|
//  |                Destination MAC Address                |
//  |                           ----------------------------|
//  |                           |                           |
//  |----------------------------                           |
//  |                  Source MAC Address                   |
//  |-------------------------------------------------------|
//  |         EtherType         |                           |
//  |----------------------------                           |
//  |                                                       |
//  |                   Ethernet Payload                    |
//  |                                                       |
//  |-------------------------------------------------------|
//
//  Standard IP Packet Layout
//  |-------------------------------------------------------|
//  | VER  | HLEN |     TOS     |       Total Length        |
//  |-------------------------------------------------------|
//  |       Identification      | FLGS |    FRAG OFFSET     |
//  |-------------------------------------------------------|
//  |     TTL     |    PROTO    |      Header Checksum      |
//  |-------------------------------------------------------|
//  |                   Source IP Address                   |
//  |-------------------------------------------------------|
//  |                Destination IP Address                 |
//  |-------------------------------------------------------|
//  |                                                       |
//  |                      IP Payload                       |
//  |                                                       |
//  |-------------------------------------------------------|
//
//  Standard UDP Packet Layout
//  |-------------------------------------------------------|
//  |      Source UDP Port      |   Destination UDP Port    |
//  |-------------------------------------------------------|
//  |    UDP Message Length     |       UDP Checksum        |
//  |-------------------------------------------------------|
//  |                                                       |
//  |                      UDP Payload                      |
//  |                                                       |
//  |-------------------------------------------------------|
//
//  Proprietary RAW Input Packet Layout
//  |-------------------------------------------------------|
//  |       Packet Length       |                           |
//  |----------------------------                           |
//  |                                                       |
//  |                    Packet Payload                     |
//  |                                                       |
//  |-------------------------------------------------------|
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module UDP_Packet_Sender(
									clk,rst,
									//UDP port
									SRC_PORT,
									DST_PORT,
									DST_MAC,
									Dst_IP,Local_IP,
									//User interface
									StartUDPSend,
									UserDaPacketLen,
									UserDaFifoRd,
									UserDaFifoDout,
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
input				[15:0]		SRC_PORT,DST_PORT;
input				[47:0]		DST_MAC;
input				[31:0]		Dst_IP,Local_IP;
input								StartUDPSend;//when high,send one udp packet
input				[15:0]		UserDaPacketLen;//user data byte len 
output reg						UserDaFifoRd;//user data fifo rd 
input				[31:0]		UserDaFifoDout;//user data fifo data out 
														//when the last user data is not a Dword,put the userdatas in high bits
														//eg: if you have two bytes , Dword ={Userdata1,Userdata0,R,R}
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
localparam				INIT				  =	0;
localparam				SP0				  =	1;
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


localparam [15:0]   UDP_CHECKSUM        = 16'h0000;
/****************************************************************************************************
												reg &  wire
****************************************************************************************************/
reg		[3:0]	 state,next_state;
reg		[15:0]	 ByteCnt;
wire    [15:0]  ip_total_length;
wire    [15:0]  udp_length;

wire    [31:0]  ip_word_0;
wire    [31:0]  ip_word_1;
wire    [31:0]  ip_word_2;
wire    [31:0]  ip_word_3;
wire    [31:0]  ip_word_4;
wire    [31:0]  udp_word_0;
wire    [31:0]  udp_word_1;
reg     [16:0]  ip_header_sum_0;
reg     [16:0]  ip_header_sum_1;
reg     [16:0]  ip_header_sum_2;
reg     [16:0]  ip_header_sum_3;
reg     [16:0]  ip_header_sum_4;
reg     [17:0]  ip_header_sum_a;
reg     [17:0]  ip_header_sum_b;
reg     [18:0]  ip_header_sum_c;
reg     [19:0]  ip_header_sum_d;
reg     [19:0]  ip_header_sum_e;
wire    [15:0]  ip_header_carry_sum;
wire    [15:0]  ip_header_checksum;
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
wire	  [47:0]	 Dst_MAC,Src_MAC;
reg	  [1:0]	 UserFifoDaRdyNum;
reg	  [15:0]	 LastByteLen;	
reg				 FifoRdStoped;
reg		[15:0]	IP_IDENTIFICATION;
/****************************************************************************************************
											assign
****************************************************************************************************/
assign udp_length           = UserDaPacketLen + 16'd8;
assign ip_total_length      = udp_length + 16'd20;// IP header adds 20 bytes to UDP packet
assign ip_header_carry_sum  = (ip_header_sum_e[15:0]) + ({{12{1'b0}}, ip_header_sum_e[19:16]});
assign ip_header_checksum   = ~ip_header_carry_sum;
//
// addr
//
//
assign		Dst_MAC=DST_MAC;
assign		Src_MAC=`LOCAL_MAC;
//assign		Dst_IP=`DST_IP;
// IP header layout
//
assign ip_word_0    = {`IP_VERSION, `IP_HEADER_LENGTH, `IP_TOS, ip_total_length};
assign ip_word_1    = {IP_IDENTIFICATION, `IP_FLAGS, `IP_FRAGMENT_OFFSET};
assign ip_word_2    = {`IP_TTL, `UDP_PROTOCOL, ip_header_checksum};
assign ip_word_3    = Local_IP;
assign ip_word_4    = Dst_IP;
assign udp_word_0   = {SRC_PORT, DST_PORT};
assign udp_word_1   = {udp_length, UDP_CHECKSUM};

// packet word layout
assign packet_word_0    = {16'h0000,Dst_MAC[47:32]};
assign packet_word_1    = Dst_MAC[31:0];
assign packet_word_2    = Src_MAC[47:16];
assign packet_word_3    = {Src_MAC[15:0],`MAC_TYPE};
assign packet_word_4    = ip_word_0;
assign packet_word_5    = ip_word_1;
assign packet_word_6    = ip_word_2;
assign packet_word_7    = ip_word_3;
assign packet_word_8    = ip_word_4;
assign packet_word_9    = udp_word_0;
assign packet_word_10   = udp_word_1;

/****************************************************************************************************
											logic
****************************************************************************************************/
always @ (posedge clk or posedge rst)
begin
    if(rst) begin
        ip_header_sum_0 <= 0;
        ip_header_sum_1 <= 0;
        ip_header_sum_2 <= 0;
        ip_header_sum_3 <= 0;
        ip_header_sum_4 <= 0;

        ip_header_sum_a <= 0;
        ip_header_sum_b <= 0;

        ip_header_sum_c <= 0;

        ip_header_sum_d <= 0;
    end
    else begin
        // stage 1 of header checksum pipeline
        ip_header_sum_0 <= ip_word_0[31:16] + ip_word_0[15:0];
        ip_header_sum_1 <= ip_word_1[31:16] + ip_word_1[15:0];
        ip_header_sum_2 <= ip_word_2[31:16] + 17'h0;
        ip_header_sum_3 <= ip_word_3[31:16] + ip_word_3[15:0];
        ip_header_sum_4 <= ip_word_4[31:16] + ip_word_4[15:0];

        // stage 2 of header checksum pipeline
        ip_header_sum_a <= ip_header_sum_0 + ip_header_sum_1;
        ip_header_sum_b <= ip_header_sum_3 + ip_header_sum_4;

        // stage 3 of header checksum pipeline
        ip_header_sum_c <= ip_header_sum_a + ip_header_sum_b;

        // stage 4 of header checksum pipeline
        ip_header_sum_d <= ip_header_sum_2 + ip_header_sum_c;
		  ip_header_sum_e<=(ip_header_sum_d[15:0]) + ip_header_sum_d[19:16];
    end
end
// ctronal logic									
always@(*)begin
	next_state=state;
	case(state)
		INIT:
			if(StartUDPSend && Mac_tx_rdy) 
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
		SP7:if(Mac_tx_rdy)
				next_state=SP8;
		SP8:if(Mac_tx_rdy)
				next_state=SP9;
		SP9:
			if(Mac_tx_rdy)
				next_state=SP10;
		SP10:
			if(Mac_tx_rdy && UserFifoDaRdyNum==2'b00)
				next_state=INIT;
			else if(Mac_tx_rdy)
				next_state=SPn;
		SPn:
			if(Mac_tx_rdy && UserFifoDaRdyNum==2'b01)
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
		UserDaFifoRd<=1'b0;
		Mac_tx_data<=32'h0;
		Mac_tx_mod<=2'b00;
		Mac_tx_sop<=1'b0;
		Mac_tx_eop<=1'b0;
		Mac_tx_wren<=1'b0;
		FifoRdStoped<=1'b0;
		UserFifoDaRdyNum<=2'b00;
	end
	else case(state)
		INIT:
			if(StartUDPSend && Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_0;
				ByteCnt<=UserDaPacketLen; 
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b1;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
				LastByteLen<=16'h0;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP1:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_1;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP2:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_2;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP3:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_3;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP4:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_4;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP5:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_5;
				IP_IDENTIFICATION<=IP_IDENTIFICATION+1'b1;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP6:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_6;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP7:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_7;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP8:
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_8;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
		SP9:begin
			if( Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_9;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
			//read fifo
			if(Mac_tx_rdy && ByteCnt>16'h0)begin
				UserDaFifoRd<=1'b1;
				UserFifoDaRdyNum<=2'b01;
			end
			else 
				UserFifoDaRdyNum<=2'b00;
			//data len
			if(ByteCnt>16'h3 && Mac_tx_rdy)
				ByteCnt<=ByteCnt-16'h4;
			else if(Mac_tx_rdy)
				ByteCnt<=16'h0;
			//LastByteLen
			if(Mac_tx_rdy && ByteCnt>16'h0)
				LastByteLen<=ByteCnt;
		end
		SP10:begin
			if( Mac_tx_rdy && UserFifoDaRdyNum==2'b00)begin
				Mac_tx_data<=packet_word_10;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b1;
				Mac_tx_wren<=1'b1;
			end
			else if(Mac_tx_rdy)begin
				Mac_tx_data<=packet_word_10;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else begin
				Mac_tx_data<=32'h0;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
			//read fifo
			if(Mac_tx_rdy && ByteCnt>16'h0)begin
				UserDaFifoRd<=1'b1;
				UserFifoDaRdyNum<=2'b10;
			end
			else begin
				UserDaFifoRd<=1'b0;
				UserFifoDaRdyNum<=2'b01;
			end
			//data len
			if(ByteCnt>16'h3 && Mac_tx_rdy)
				ByteCnt<=ByteCnt-16'h4;
			else if(Mac_tx_rdy)
				ByteCnt<=16'h0;
			//LastByteLen
			if(Mac_tx_rdy && ByteCnt>16'h0)
				LastByteLen<=ByteCnt;
		end
		SPn:begin
			if(Mac_tx_rdy && UserFifoDaRdyNum==2'b01)begin
				Mac_tx_data<=FifoRdStoped ? Mac_tx_data : UserDaFifoDout;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b1;
				Mac_tx_wren<=1'b1;
				if(LastByteLen==16'h3)
					Mac_tx_mod<=2'b01;
				else if(LastByteLen==16'h2)
					Mac_tx_mod<=2'b10;
				else if(LastByteLen==16'h1)
					Mac_tx_mod<=2'b11;
				else
					Mac_tx_mod<=2'b00;
			end
			else if(Mac_tx_rdy)begin
				Mac_tx_data<= FifoRdStoped ? Mac_tx_data : UserDaFifoDout;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b1;
			end
			else if(FifoRdStoped==1'b0) begin
				Mac_tx_data<=UserDaFifoDout;
				Mac_tx_mod<=2'b00;
				Mac_tx_sop<=1'b0;
				Mac_tx_eop<=1'b0;
				Mac_tx_wren<=1'b0;
			end
			
			//read fifo
			if(Mac_tx_rdy && ByteCnt>16'h0)begin
				UserDaFifoRd<=1'b1;
				FifoRdStoped<=1'b0;
				UserFifoDaRdyNum<=2'b10;
			end
			else if(Mac_tx_rdy)begin
				UserDaFifoRd<=1'b0;
				FifoRdStoped<=1'b0;
				UserFifoDaRdyNum<=UserFifoDaRdyNum-1'b1;
			end
			else begin
				UserDaFifoRd<=1'b0;
				FifoRdStoped<=1'b1;
			end
			//data len
			if(ByteCnt>16'h3 && Mac_tx_rdy)
				ByteCnt<=ByteCnt-16'h4;
			else if(Mac_tx_rdy)
				ByteCnt<=16'h0;
			//LastByteLen
			if(Mac_tx_rdy && ByteCnt>16'h0)
				LastByteLen<=ByteCnt;
		end
			
	endcase
									
endmodule	