/***********************************************************
				delete the theta change corner,like 
				*******
						 *
							*
							 *************
				theta direction protect
***********************************************************/
module	BSPKDelteThetaFir(
	input							clk_i,
	input							clkEn_i,
	input							rst_i,
	input			[11:0]		DelteTheta_i,
	input			[11:0]		BPSKTheta_i,
	output reg					ResetNCOInc_o,
	output  reg [11:0]		FirDelteTheta_o);
/***********************************************************
				wire & reg
***********************************************************/
reg	[11:0]		DelteThetaHoldQ,DelteThetaHoldW,DelteThetaHoldE,
						DelteThetaHoldR;
reg	[11:0]		DelteThetaHold1,DelteThetaHold2,DelteThetaHold3,
						DelteThetaHold4;
reg	[11:0]		BPSKThetaHold,DelteThetaErrDir;
reg	[3:0]			HoldDlyCnt;
/***********************************************************
				logic
***********************************************************/
always@(posedge	clk_i  or posedge	rst_i)
	if(rst_i)
		FirDelteTheta_o<=12'h0;
	else if(clkEn_i)
		FirDelteTheta_o<=DelteThetaHoldR;
	else 
		FirDelteTheta_o<=12'h0;

//		
always@(posedge	clk_i  or posedge	rst_i)
	if(rst_i)begin
		DelteThetaHold1<=12'h0;
		DelteThetaHold2<=12'h0;
		DelteThetaHold3<=12'h0;
		DelteThetaHold4<=12'h0;
		DelteThetaHoldQ<=12'h0;
		DelteThetaHoldW<=12'h0;
		DelteThetaHoldE<=12'h0;
		DelteThetaHoldR<=12'h0;
		HoldDlyCnt<=4'h0;
	end	
	else if(clkEn_i)begin
		if((DelteTheta_i[11]==1'b1 && DelteTheta_i<12'hED3) ||//12'hf9b
			(DelteTheta_i[11]==1'b0 && DelteTheta_i>12'h12C))begin//12'h64
			DelteThetaHold1<=12'h0;
			DelteThetaHold2<=12'h0;
			DelteThetaHold3<=12'h0;
			DelteThetaHold4<=12'h0;
			DelteThetaHoldQ<=12'h0;
			DelteThetaHoldW<=12'h0;
			DelteThetaHoldE<=12'h0;
			DelteThetaHoldR<=12'h0;
			HoldDlyCnt<=4'h0;
		end
		else if(HoldDlyCnt==4'd7)begin
			DelteThetaHold1<=DelteThetaErrDir ;
			DelteThetaHold2<=DelteThetaHold1;
			DelteThetaHold3<=DelteThetaHold2;
			DelteThetaHold4<=DelteThetaHold3;
			DelteThetaHoldQ<=DelteThetaHold4;
			DelteThetaHoldW<=DelteThetaHoldQ;
			DelteThetaHoldE<=DelteThetaHoldW;
			DelteThetaHoldR<=DelteThetaHoldE;
			HoldDlyCnt<=HoldDlyCnt;
		end
		else begin
			DelteThetaHold1<=12'h0;
			DelteThetaHold2<=12'h0;
			DelteThetaHold3<=12'h0;
			DelteThetaHold4<=12'h0;
			DelteThetaHoldQ<=12'h0;
			DelteThetaHoldW<=12'h0;
			DelteThetaHoldE<=12'h0;
			DelteThetaHoldR<=12'h0;
			HoldDlyCnt<=HoldDlyCnt+1'b1;
		end
	end
//BPSKTheta dly 1 clk ,syn for DelteTheta_i
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)
		BPSKThetaHold<=12'h0;
	else if(clkEn_i)
		BPSKThetaHold<=BPSKTheta_i;
//DelteThetaErrDir  DelteTheta_i
reg [7:0]	ThetaDirShiftN,ThetaDirShiftP;

always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)
		ThetaDirShiftN<=8'h0;
	else if(clkEn_i)begin
		if(((BPSKThetaHold[11:10]==2'b00 && BPSKThetaHold>12'h200) || 
						(BPSKThetaHold[11:10]==2'b10 &&  BPSKThetaHold>12'hA00)))
			ThetaDirShiftN<={ThetaDirShiftN[6:0],1'b1};
		else
			ThetaDirShiftN<={ThetaDirShiftN[6:0],1'b0};
	end
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)
		ThetaDirShiftP<=8'h0;
	else if(clkEn_i)begin
		if(((BPSKThetaHold[11:10]==2'b01 && BPSKThetaHold<12'h600)||
					(BPSKThetaHold[11:10]==2'b11 && BPSKThetaHold<12'hE00)))
			ThetaDirShiftP<={ThetaDirShiftP[6:0],1'b1};
		else
			ThetaDirShiftP<={ThetaDirShiftP[6:0],1'b0};
	end
reg [1:0]	ThetaGoDir;
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)
		ThetaGoDir<=2'b00;
	else if(clkEn_i)begin
		if(ThetaDirShiftN==8'hff && ThetaGoDir==2'b00)//dir to X
			ThetaGoDir<=2'b01;//ThetaGoDir==2'b00 ? 2'b01 : ThetaGoDir;
		else if(ThetaDirShiftP==8'hff && ThetaGoDir==2'b00)
			ThetaGoDir<=2'b10;//ThetaGoDir==2'b00 ? 2'b10 : ThetaGoDir;
		else if(ThetaDirShiftN==8'h0 && ThetaDirShiftP==8'h0)
			ThetaGoDir<=2'b00;
	end
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)	
		ResetNCOInc_o<=1'b0;
	else if(ThetaGoDir<=2'b00)
		ResetNCOInc_o<=1'b1;
	else
		ResetNCOInc_o<=1'b0;

always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)	
		DelteThetaErrDir<=12'h0;	
	else if(clkEn_i)begin
		if(ThetaGoDir==2'b10)//dir to X
			DelteThetaErrDir<=(DelteTheta_i[11]==1'b1 || DelteTheta_i==12'h0)? 12'h08 : DelteTheta_i;
		else if(ThetaGoDir==2'b01)//dir to X
			DelteThetaErrDir<=(DelteTheta_i[11]==1'b0 || DelteTheta_i==12'h0)? 12'hff8 : DelteTheta_i;
		else
			DelteThetaErrDir<=DelteTheta_i;
	end
	
	
endmodule	