`timescale 1ns/1ps

module	NewPPS_1sMod(
input					clk,
input					rst,
input					PPS1S_From_GPS,
input			[1:0]	UpNewDateReg,
input			[31:0]GPSTimerS,
output reg			PPS1S_Output_delay1,
output reg			SYN_10MHz,
input[31:0]				BaseSetTimerReg,
input						BaseSetTimerEn,

// m
input rm_time_valid,
input [31:0] rm_time,

output reg [31:0]	Tim_nS_Out,
output reg [31:0]	Tim_S_Out_delay1,
output reg [31:0]	Tim_S_BaseSetCnt,
output reg [31:0]	PPS1S_From_Cnt
);

reg	[7:0]			CntFor10MHz,MaxCntFor10M;
reg	[31:0]		CntFor1S,SynTo1PPS10MCnt;
reg	[1:0]			ShiftPPS1SGPS,ShiftPPS1SGPSDly;
reg					ClrAllToSynGPS;
reg					EnGoFast;
reg	[7:0]			WaitForSyn10MH;
reg	[1:0]			Clk125To10M05Add;
reg					PPS1S_Output;
reg 	[31:0]		Tim_S_Out;
//Tim_nS_Out
//assign		Tim_nS_Out		=	{1'b0,CntFor1S[31:1]};	

/******************************************************
					pps_in_err to clk 
*****************************************************/
reg	[31:0]		PPSInErrToClkReg,PPS1S_From_CntQ;
reg					PPSInMoreFastToClk,PPSInTimLocked;
/******************************************************
					localparam
*****************************************************/
localparam		LOCAL_CLK_FREQ	=	32'd125_000_000;
localparam		LOCAL_TIM_5ms	=	32'd625_000;
localparam		LOCAL_TIM_995ms	=	32'd124_375_000;

//20200707
always@(posedge	clk or posedge	rst)
begin
	if (rst)
	begin
		Tim_nS_Out<=32'd0;
		PPS1S_Output_delay1<=1'b0;
		Tim_S_Out_delay1<=32'd0;
	end
	else
	begin
		Tim_nS_Out<={1'b0,CntFor1S[31:1]};
		PPS1S_Output_delay1<=PPS1S_Output;
		Tim_S_Out_delay1<=Tim_S_Out;
	end
end
//20200707
//ShiftPPS1SGPS
always@(posedge	clk or posedge	rst)
	if(rst)
		ShiftPPS1SGPS<=2'b00;
	else 
		ShiftPPS1SGPS<={ShiftPPS1SGPS[0],PPS1S_From_GPS};
		
//ShiftPPS1SGPSDly	
always@(posedge	clk or posedge	rst)
	if(rst)
		ShiftPPS1SGPSDly<=2'b00;
	else 
		ShiftPPS1SGPSDly<=ShiftPPS1SGPS;	
always@(posedge	clk or posedge	rst)
	if(rst)
		PPS1S_From_Cnt<=32'h0;
	else if(ShiftPPS1SGPS==2'b01)
		PPS1S_From_Cnt<=32'h0;
	else
		PPS1S_From_Cnt<=PPS1S_From_Cnt+1'b1;
//PPS1S_From_CntQ
always@(posedge	clk or posedge	rst)
	if(rst)
		PPS1S_From_CntQ<=32'h0;
	else if(ShiftPPS1SGPS==2'b01)
		PPS1S_From_CntQ<=PPS1S_From_Cnt;
	else
		PPS1S_From_CntQ<=PPS1S_From_CntQ;
//PPSInTimLocked
always@(posedge	clk or posedge	rst)
	if(rst)
		PPSInTimLocked<=1'b0;
	else if(ShiftPPS1SGPS==2'b01 && (PPS1S_From_CntQ+32'd500)>PPS1S_From_Cnt &&
					(PPS1S_From_Cnt+32'd500)>PPS1S_From_CntQ)
		PPSInTimLocked<=1'b1;
	else if(ShiftPPS1SGPS==2'b01 || PPS1S_From_Cnt>32'd250_000_000)
		PPSInTimLocked<=1'b0;
	else
		PPSInTimLocked<=PPSInTimLocked;
		
always@(posedge	clk or posedge	rst)
	if(rst)begin
		PPSInErrToClkReg<=32'h0;
		PPSInMoreFastToClk<=1'b0;
	end
	else if(ShiftPPS1SGPSDly==2'b01 && PPSInTimLocked && PPS1S_From_CntQ>LOCAL_TIM_995ms)begin
		if(PPS1S_From_CntQ>LOCAL_CLK_FREQ)begin
			PPSInErrToClkReg<=PPS1S_From_CntQ-LOCAL_CLK_FREQ;
			PPSInMoreFastToClk<=1'b0;
		end
		else begin
			PPSInErrToClkReg<=LOCAL_CLK_FREQ-PPS1S_From_CntQ;	
			PPSInMoreFastToClk<=1'b1;
		end
	end
	else begin
		PPSInErrToClkReg<=PPSInErrToClkReg;
		PPSInMoreFastToClk<=PPSInMoreFastToClk;
	end
	
/******************************************************
					pps_in_err to PPS_OUT
*****************************************************/
reg [31:0]		PPSInErrToPPSOut;
reg 				PPSOutNeedGoFast;
reg [31:0]		PPSInOutCnt,PPSOutToInCntHold;
//PPSInToOutCnt
always@(posedge	clk or posedge	rst)
	if(rst)
		PPSInOutCnt<=32'h0;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M && PPSInTimLocked)
		PPSInOutCnt<=32'h0;
	else if(ShiftPPS1SGPSDly==2'b01 && PPSInTimLocked)
		PPSInOutCnt<=32'h0;
	else if(PPSInTimLocked==1'b0)
		PPSInOutCnt<=32'h0;
	else
		PPSInOutCnt<=PPSInOutCnt+1'b1;
//PPSOutToInCntHold
always@(posedge	clk or posedge	rst)
	if(rst)begin
		PPSOutToInCntHold<=32'h0;
	end
	else if(ShiftPPS1SGPSDly==2'b01 && PPSInTimLocked)begin
		PPSOutToInCntHold<=PPSInOutCnt;//pps out ---pps in  timer
	end
	else if(PPSInTimLocked==1'b0)begin
		PPSOutToInCntHold<=32'h0;
	end
	else begin
		PPSOutToInCntHold<=PPSOutToInCntHold;
	end
		
//PPSInErrToPPSOut
/*********************************
	PPSInOutCnt  PPSOutToInCntHold
	Conuter betton  PPS_in and PPS_OUT 
*********************************/
always@(posedge	clk or posedge	rst)
	if(rst)begin
		PPSInErrToPPSOut<=32'h0;
		PPSOutNeedGoFast<=1'b0;
	end
	else if(ClrAllToSynGPS)begin
		PPSInErrToPPSOut<=32'h0;
		PPSOutNeedGoFast<=1'b0;
	end
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M && PPSInTimLocked)begin
		/*****************************
			out    .....
				    .	
				  ...		
			in  	.....
					.	
				 ...
		*****************************/
		if(PPSInOutCnt<LOCAL_TIM_5ms)begin//d125_000_000 PPSOutToInCntHold<PPSInOutCnt && 
			PPSInErrToPPSOut<=PPSInOutCnt;
			PPSOutNeedGoFast<=1'b1;	
		end
		/*****************************
			out    .....
				    .	
				  ...		
			in  	   .....
					   .	
				    ...
		*****************************/
		else if((PPSInOutCnt>LOCAL_TIM_995ms) && (PPSOutToInCntHold<LOCAL_TIM_5ms))begin//d125_000_000
			PPSInErrToPPSOut<=PPSOutToInCntHold;
			PPSOutNeedGoFast<=1'b0;	
		end
		else begin//d125_000_000
			PPSInErrToPPSOut<=32'h0;
			PPSOutNeedGoFast<=1'b0;	
		end
	end
	else begin
		PPSInErrToPPSOut<=PPSInErrToPPSOut;
		PPSOutNeedGoFast<=PPSOutNeedGoFast;
	end
/******************************************************
					ClrAllToSynGPS
*****************************************************/
always@(posedge	clk or posedge	rst)
	if(rst)
		ClrAllToSynGPS<=1'b0;
	else if(ShiftPPS1SGPSDly==2'b01 && PPSInTimLocked && 
			(CntFor1S>32'd0_100_000 && CntFor1S<32'd19_900_000))
		ClrAllToSynGPS<=1'b1;
	else
		ClrAllToSynGPS<=1'b0;

/******************************************************
					pps_in_err to PPS_OUT
*****************************************************/
reg			DlyToCrectErrPPSIn2PPSOut;	
reg   [31:0]NewErrSet;	
reg    		NewGoFastEn;	
reg	[3:0]	CycDlyChk;
always@(posedge	clk or posedge	rst)	
	if(rst)
		DlyToCrectErrPPSIn2PPSOut<=1'b0;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)
		DlyToCrectErrPPSIn2PPSOut<=~DlyToCrectErrPPSIn2PPSOut;
	else
		DlyToCrectErrPPSIn2PPSOut<=DlyToCrectErrPPSIn2PPSOut;
//CycDlyChk
always@(posedge	clk or posedge	rst)
	if(rst)
		CycDlyChk<=4'h0;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)
		CycDlyChk<=4'h1;
	else 
		CycDlyChk<={CycDlyChk[2:0],1'b0};
//NewErrSet
always@(posedge	clk or posedge	rst)	
	if(rst)begin
		NewErrSet<=32'h0;
		NewGoFastEn<=1'b0;
	end
	else if(CycDlyChk[0] && PPSInTimLocked && DlyToCrectErrPPSIn2PPSOut)begin
		if(PPSInMoreFastToClk == PPSOutNeedGoFast)begin
			NewErrSet<=PPSInErrToClkReg+PPSInErrToPPSOut;
			NewGoFastEn<=PPSInMoreFastToClk;
		end
		else if(PPSInErrToClkReg>PPSInErrToPPSOut)begin//shao zou kuai yi dian
			NewErrSet<=PPSInErrToClkReg-PPSInErrToPPSOut;
			NewGoFastEn<=PPSInMoreFastToClk;
		end
		else begin
			NewErrSet<=PPSInErrToPPSOut-PPSInErrToClkReg;//huan fang xiang
			NewGoFastEn<=PPSOutNeedGoFast;
		end
			
	end
	else if(CycDlyChk[0] )begin
		NewErrSet<=PPSInErrToClkReg;
		NewGoFastEn<=PPSInMoreFastToClk;
	end
	else begin
		NewErrSet<=NewErrSet;
		NewGoFastEn<=NewGoFastEn;
	end
		

/******************************************************
					MaxCntFor10M 125MHZ
*****************************************************/
//		
always@(posedge	clk or posedge	rst)
	if(rst)
		MaxCntFor10M<=8'd5;
	else if(CntFor10MHz==MaxCntFor10M)begin
		if(SynTo1PPS10MCnt && WaitForSyn10MH==8'h1)
			MaxCntFor10M<=(Clk125To10M05Add[0]&Clk125To10M05Add[1])+ (EnGoFast ? 8'd4 : 8'd6);
		else
			MaxCntFor10M<=8'd5+(Clk125To10M05Add[0]&Clk125To10M05Add[1]);
	end
	else
		MaxCntFor10M<=MaxCntFor10M;	

/******************************************************
					PPS1S_From_GPS
*****************************************************/
//chk 		PPS1S_From_GPS
always@(posedge	clk or posedge	rst)
	if(rst)begin	
		EnGoFast<=1'b0;
		SynTo1PPS10MCnt<=32'h0;
	end
	else if(ClrAllToSynGPS)begin	
		SynTo1PPS10MCnt<=32'h0;
		EnGoFast<=1'b0;
	end
	else if(CycDlyChk[3])begin	
		SynTo1PPS10MCnt<=NewErrSet;
		EnGoFast<=NewGoFastEn;
	end
	else if(CntFor10MHz==MaxCntFor10M && SynTo1PPS10MCnt  && WaitForSyn10MH==8'h1)begin
		SynTo1PPS10MCnt<=SynTo1PPS10MCnt-1'b1;
		EnGoFast<=EnGoFast;
	end
	else begin
		SynTo1PPS10MCnt<=SynTo1PPS10MCnt;
		EnGoFast<=EnGoFast;
	end
/******************************************************
					SYN_10MHz
*****************************************************/	
//SYN_10MHz		
always@(posedge	clk or posedge	rst)
	if(rst)begin
		SYN_10MHz<=1'b1;
		Clk125To10M05Add<=2'b00;
		CntFor10MHz<=8'h0;
		WaitForSyn10MH<=8'h0;
	end
	else if(ClrAllToSynGPS )begin
		SYN_10MHz<=1'b1;
		Clk125To10M05Add<=2'b00;
		CntFor10MHz<=8'h0;
		WaitForSyn10MH<=8'h0;
	end
	else if((CntFor10MHz)==MaxCntFor10M)begin
		SYN_10MHz<=~SYN_10MHz;
		Clk125To10M05Add<=Clk125To10M05Add+1'b1;
		CntFor10MHz<=8'h0;
		WaitForSyn10MH<=(WaitForSyn10MH == 8'h3) ? 8'h0 : (WaitForSyn10MH+1'b1);//WaitForSyn10MH+1'b1;//
	end
	else 
		CntFor10MHz<=CntFor10MHz+1'b1;
//Tim_S_Out
always@(posedge	clk or posedge	rst)
	if(rst)	
		Tim_S_Out<=32'h0;
	else if(UpNewDateReg==2'b01)
		Tim_S_Out<=GPSTimerS;
	else if(rm_time_valid)
        Tim_S_Out <= rm_time;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)begin
		Tim_S_Out<=Tim_S_Out+1'b1;
	end
//Tim_S_BaseSetCnt
always@(posedge	clk or posedge	rst)
	if(rst)	
		Tim_S_BaseSetCnt<=32'h0;
	else if(BaseSetTimerEn)
		Tim_S_BaseSetCnt<=BaseSetTimerReg;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)begin
		Tim_S_BaseSetCnt<=Tim_S_BaseSetCnt+1'b1;
	end
//PPS1S_Output		
always@(posedge	clk or posedge	rst)
	if(rst)	
		CntFor1S<=32'h0;
	else if(ClrAllToSynGPS )
		CntFor1S<=32'h0;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)begin
		CntFor1S<=32'h0;
	end
	else if( CntFor10MHz==MaxCntFor10M)
		CntFor1S<=CntFor1S+1'b1;
always@(posedge	clk or posedge	rst)
	if(rst)	
		PPS1S_Output<=1'b0;
	else if(ClrAllToSynGPS )
		PPS1S_Output<=1'b1;
	else if(CntFor1S==32'd19_999_999 && CntFor10MHz==MaxCntFor10M)
		PPS1S_Output<=1'b1;
	else if(CntFor1S==32'd1_999_999 && CntFor10MHz==MaxCntFor10M)
		PPS1S_Output<=1'b0;
		

endmodule	
