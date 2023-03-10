`timescale 1ns / 1ps
`include        "NetParadefine.V"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:11 08/08/2013 
// Design Name: 
// Module Name:    EthernetConfig 
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
module		EthernetConfig(
                                LocMacAddr,
									clk,rst,
									EtherNetCfgOver,
									//config signal
									address,
									write,
									read,
									writedata,
									readdata,
									waitrequest
									);

/****************************************************************************************************
											IOs
****************************************************************************************************/
input [47:0] LocMacAddr;
input								clk,rst;
output reg						EtherNetCfgOver;
output reg		[7:0]			address;//
output reg						write,read;
output reg		[31:0]		writedata;
input				[31:0]		readdata;
input								waitrequest;

/****************************************************************************************************
											reg & wire
****************************************************************************************************/
reg				[3:0]			state,next_state;
reg								waitrequestReg;

/****************************************************************************************************
											localparam
****************************************************************************************************/
localparam						INIT				=			0;
localparam						MacAddr1			=			1;
localparam						MacAddr2			=			2;
localparam						Mac_Cfg			=			3;
localparam						CFPOVER			=			4;
localparam						Wr_Scratch		=			5;
localparam						Rd_Scratch		=			6;
localparam						Wr_PIGLen		=			7;
localparam						Wr_FraLen		=			8;
localparam						Wr_PauseQua		=			9;
localparam						Rd_State			=			10;

localparam						TB_IPG_LENGTH 	= 			12;//TB_IPG_LENGTH
localparam						TB_MACLENMAX 	= 			1518; //max. frame length configuration of MAC
localparam 						TB_MACPAUSEQ	= 			15 ; //  pause quanta configuration of MAC

`define							TX_En					32'h0000_0000_0000_0001//o
`define							RX_En					32'h0000_0000_0000_0002//o
`define							XON_GEN				32'h0000_0000_0000_0004//
`define							ETH_SPEED			32'h0000_0000_0000_0008//
`define							PROMIS_EN			32'h0000_0000_0000_0010//filter address
`define							PAD_EN				32'h0000_0000_0000_0020//
`define							CRC_FWD				32'h0000_0000_0000_0040//

/****************************************************************************************************
											logic
****************************************************************************************************/
always@(posedge clk or posedge rst)
	if(rst)
		waitrequestReg<=1'b0;
	else
		waitrequestReg<=waitrequest;


always@(*)begin
	next_state=state;
	case(state)
		INIT:
			next_state=Wr_Scratch;
		Wr_Scratch:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=Rd_Scratch;
		Rd_Scratch:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0 && readdata==32'haaaaaaaa)
				next_state=Mac_Cfg;
			else if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=Wr_Scratch;
		Mac_Cfg:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=MacAddr1;//;
		MacAddr1:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=MacAddr2;
		MacAddr2:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=Wr_PIGLen;
		Wr_PIGLen:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=Wr_FraLen;
		Wr_FraLen:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=Wr_PauseQua;
		Wr_PauseQua:
			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=CFPOVER;
		CFPOVER:
			//if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
				next_state=CFPOVER;
//		Rd_State:
//			if(waitrequestReg==1'b1 &&  waitrequest==1'b0)
//				next_state=CFPOVER;
	endcase
end

always@(posedge clk or posedge rst)
	if(rst)
		state<=INIT;
	else 
		state<=next_state;
		
		
always@(posedge clk or posedge rst)
	if(rst)begin
		write<=1'b0;
		read<=1'b0;
		EtherNetCfgOver<=1'b0;
	end
	else case(state)
		INIT:begin
			write<=1'b0;
			read<=1'b0;
			EtherNetCfgOver<=1'b0;
		end
		Wr_Scratch:begin
			address<=8'h01;//Scratch
			write<=1'b1;
			read<=1'b0;
			writedata<=32'haaaaaaaa;
		end
		Rd_Scratch:begin
			address<=8'h01;//Scratch
			write<=1'b0;
			read<=1'b1;
			writedata<=32'h0;
		end
		Mac_Cfg:begin
			address<=8'h02;//COMMAND
			write<=1'b1;
			read<=1'b0;
			writedata<={`TX_En | `RX_En | `PROMIS_EN};
		end
		MacAddr1:begin
			address<=8'h03;//mac_0
			write<=1'b1;
			read<=1'b0;
			writedata<={LocMacAddr[23:16],LocMacAddr[31:24],LocMacAddr[39:32],LocMacAddr[47:40]};
		end
		MacAddr2:begin
			address<=8'h04;//mac_1
			write<=1'b1;
			read<=1'b0;
			writedata<={16'h0,LocMacAddr[7:0],LocMacAddr[15:8]};
		end
		Wr_PIGLen:begin
			address<=8'h17;//Pig leng
			write<=1'b1;
			read<=1'b0;
			writedata<=TB_IPG_LENGTH;
		end
		Wr_FraLen:	begin
			address<=8'h05;//FraLen:
			write<=1'b1;
			read<=1'b0;
			writedata<=TB_MACLENMAX;
		end
		Wr_PauseQua:begin
			address<=8'h06;//Wr_PauseQua:
			write<=1'b1;
			read<=1'b0;
			writedata<=TB_MACPAUSEQ;
		end
		CFPOVER:begin
			write<=1'b0;
			read<=1'b0;
			address<=8'h1a;
			EtherNetCfgOver<=1'b1;
		end
//		Rd_State:begin
//			write<=1'b0;
//			read<=1'b1;
//			address<=8'h1b;
//			EtherNetCfgOver<=1'b1;
//		end
			
	endcase

endmodule	
