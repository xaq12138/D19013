module	IQDemodemSoundPCM(
	input							ad_data_clk,
	input							rst_n,
	input			[15:0]		IQDataFSoundAddr,
	input 						IQDataFSoundCicEn,
	input 		[15:0]		SoundRxFrameLen,
	
	output reg	[7:0]			IQDataFSoundByte,
	output reg					IQDataFSoundByteEn,
	output reg					IQDataFSoundFrameLock,
	output reg					IQDataFSoundFrameOver,
	output reg					IQDataFSoundByteTest);

/**********************************************************************************
												local wire	
**********************************************************************************/
reg	[7:0]				SoundRxFrameState;
reg	[7:0]				IQDataFSoundBitCnt,IQDataFSoundBitCntBuf;
reg	[31:0]			IQDataFSound0TimeWait,IQDataFSound0TimeWaitOut,IQDataFSoundFourTimeWait;
reg	[15:0]			IQDataFSoundFourCnt;
reg	[1:0]				IQDataFSoundAddr0Buf;
reg	[15:0]			IQDataFSoundAddrHold,Sound0Cnt,IQDataFSoundAddrReg,CorrcetIQDataFSoundAddr;
reg	[31:0]			FSoundBitCntDlyCnt,FSoundBitCntMaxDly;
reg						Sound0BitFalg;

//reg						IQDataFSoundByteTest;
/**********************************************************************************
												assign	
**********************************************************************************/
//assign					IQDataFSoundBitCnt=	IQDataFSoundAddr[0]+IQDataFSoundAddr[1]+IQDataFSoundAddr[2]+IQDataFSoundAddr[3]+
//														IQDataFSoundAddr[4]+IQDataFSoundAddr[5]+IQDataFSoundAddr[6]+IQDataFSoundAddr[7]+
//														IQDataFSoundAddr[8]+IQDataFSoundAddr[9]+IQDataFSoundAddr[10]+IQDataFSoundAddr[11]+
//														IQDataFSoundAddr[12]+IQDataFSoundAddr[13]+IQDataFSoundAddr[14]+IQDataFSoundAddr[15];
														
/**********************************************************************************
											localparam
**********************************************************************************/

/**********************************************************************************
										
**********************************************************************************/

always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	IQDataFSoundAddr0Buf<=2'b00;
	IQDataFSoundBitCnt<=16'h0000;
	IQDataFSoundAddrHold<=16'h0000;
	end
else begin
	IQDataFSoundAddr0Buf<={IQDataFSoundAddr0Buf[0],IQDataFSoundAddr[0]};
	IQDataFSoundBitCnt<=IQDataFSoundAddr[1]+IQDataFSoundAddr[2]+IQDataFSoundAddr[3]+
							  IQDataFSoundAddr[4]+IQDataFSoundAddr[5]+IQDataFSoundAddr[6]+IQDataFSoundAddr[7]+
							  IQDataFSoundAddr[8]+IQDataFSoundAddr[9]+IQDataFSoundAddr[10]+IQDataFSoundAddr[11]+
							  IQDataFSoundAddr[12]+IQDataFSoundAddr[13]+IQDataFSoundAddr[14]+IQDataFSoundAddr[15];
	IQDataFSoundAddrHold<=IQDataFSoundAddr;
	end
end

always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	Sound0Cnt<=16'h0000;
	Sound0BitFalg<=1'b0;
	end
else begin
	if(IQDataFSoundAddr[0]==1'b1)begin
		Sound0Cnt<=Sound0Cnt+1'b1;
		end
	else begin
		Sound0Cnt<=16'h0000;
		end
//	if(Sound0Cnt==16'd100)begin		//50us--clk2M
	if(Sound0Cnt==16'd3000)begin		//50us--clk60M
		Sound0Cnt<=16'h0000;
		Sound0BitFalg<=1'b1;
		end
	else begin
		Sound0BitFalg<=1'b0;
		end
	end
end

always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	SoundRxFrameState<=8'h00;
	IQDataFSound0TimeWait<=32'h0000_0000;
	IQDataFSound0TimeWaitOut<=32'h0000_0000;
	IQDataFSoundFourCnt<=16'h0000;
	IQDataFSoundFrameLock<=1'b0;
	IQDataFSoundFrameOver<=1'b0;
	IQDataFSoundByteEn<=1'b0;
	IQDataFSoundFourTimeWait<=32'h0000_0000;
	IQDataFSoundByteTest<=1'b0;
	IQDataFSoundBitCntBuf<=8'h00;
	end
else begin
	case (SoundRxFrameState)
	8'h00:begin
			IQDataFSoundFrameOver<=1'b0;
			FSoundBitCntDlyCnt<=32'h0000_0000;
			FSoundBitCntMaxDly<=32'h0000_0000;
			IQDataFSoundFourTimeWait<=32'h0000_0000;
			IQDataFSoundFourCnt<=16'h0000;
			if(IQDataFSoundAddr[0]==1'b1 && IQDataFSoundBitCnt<8'h2)begin
				IQDataFSound0TimeWait<=IQDataFSound0TimeWait+1'b1;
				end
			else begin
				IQDataFSoundFrameLock<=1'b0;
				IQDataFSound0TimeWait<=32'h0000_0000;
				end
//			if(IQDataFSound0TimeWait==16'd8000)begin //4ms--clk2M
			if(IQDataFSound0TimeWait==32'd240000)begin //4ms--clk60M
				IQDataFSound0TimeWait<=32'h0000_0000;
				IQDataFSoundFrameLock<=1'b1;
				SoundRxFrameState<=8'h01;
				end
			end
	8'h01:begin
			if(IQDataFSoundAddr0Buf==2'b10)begin
				IQDataFSound0TimeWaitOut<=32'h0000_0000;
				SoundRxFrameState<=8'h02;
				end
//			else if(IQDataFSound0TimeWaitOut==16'd40000)begin //20ms--clk2M
			else if(IQDataFSound0TimeWaitOut==32'd1200000)begin //20ms--clk60M
				IQDataFSound0TimeWaitOut<=32'h0000_0000;
				SoundRxFrameState<=8'h00;
				end
			else begin
				IQDataFSound0TimeWaitOut<=IQDataFSound0TimeWaitOut+1'b1;
				end
			end
	8'h02:begin
			IQDataFSoundFourTimeWait<=IQDataFSoundFourTimeWait+1'b1;
//			if(IQDataFSoundFourTimeWait>16'd10_000)begin//5ms for one bit--clk2M
			if(IQDataFSoundFourTimeWait>32'd300_000)begin//5ms for one bit--clk60M
				SoundRxFrameState<=8'h11;
			end
			else if((IQDataFSoundBitCnt==8'd4)&&(IQDataFSoundAddr[0]==1'b0))begin//2ms--clk2M
				FSoundBitCntDlyCnt<=32'h0000_0000;
				SoundRxFrameState<=8'h10;
				IQDataFSoundAddrReg<=IQDataFSoundAddrHold;
				end
			else begin
				FSoundBitCntDlyCnt<=32'h0;
			end
			end
	8'h10:begin
				IQDataFSoundFourTimeWait<=IQDataFSoundFourTimeWait+1'b1;
//				if(IQDataFSoundFourTimeWait>16'd10_000)begin//5ms for one bit--clk2M
				if(IQDataFSoundFourTimeWait>32'd300_000)begin//5ms for one bit--clk60M
					SoundRxFrameState<=8'h11;
				end
				else if(IQDataFSoundAddrReg==IQDataFSoundAddrHold)begin
					FSoundBitCntDlyCnt<=FSoundBitCntDlyCnt+1'b1;
					SoundRxFrameState<=8'h10;
				end
				else begin
					SoundRxFrameState<=8'h11;
				end
			end
	8'h11:begin
				IQDataFSoundFourTimeWait<=IQDataFSoundFourTimeWait+1'b1;
				if(FSoundBitCntMaxDly<FSoundBitCntDlyCnt)begin
					CorrcetIQDataFSoundAddr<=IQDataFSoundAddrReg;
					FSoundBitCntMaxDly<=FSoundBitCntDlyCnt;
				end
//				if(IQDataFSoundFourTimeWait>16'd10_000)begin//5ms for one bit--clk2M
				if(IQDataFSoundFourTimeWait>32'd300_000)begin//5ms for one bit--clk60M
					SoundRxFrameState<=8'h03;
				end
				else
					SoundRxFrameState<=8'h02;
			end
	
	8'h03:begin
				IQDataFSoundByte[7:0]<=CorrcetIQDataFSoundAddr[15:8];
				IQDataFSoundBitCntBuf[7:0]<=CorrcetIQDataFSoundAddr[7:0];
				IQDataFSoundFourCnt<=IQDataFSoundFourCnt+1'b1;
				IQDataFSoundByteEn<=1'b1;			
				IQDataFSoundByteTest<=~IQDataFSoundByteTest;
				FSoundBitCntDlyCnt<=32'h0000_0000;
				SoundRxFrameState<=8'h04;
			end
	
	8'h04:begin
			//if(Sound0BitFalg==1'b0)begin
				IQDataFSoundByte[7:0]<=IQDataFSoundBitCntBuf[7:0];
				IQDataFSoundByteEn<=1'b1;
				IQDataFSoundFourTimeWait<=IQDataFSoundFourTimeWait+1'b1;
				SoundRxFrameState<=8'h05;
			//	end
//			else begin
//				IQDataFSoundFourTimeWait<=32'h0000_0000;
//				IQDataFSoundByteEn<=1'b0;
//				SoundRxFrameState<=8'h00;
//				end
			end
	8'h05:begin
			IQDataFSoundByteEn<=1'b0;
			FSoundBitCntDlyCnt<=32'h0000_0000;
			FSoundBitCntMaxDly<=32'h0000_0000;
			IQDataFSoundFourTimeWait<=32'h0000_0000;
			if(IQDataFSoundFourCnt<SoundRxFrameLen)begin
				SoundRxFrameState<=8'h02;
				end
//			else if(Sound0BitFalg==1'b1)begin
//				IQDataFSoundFourCnt<=16'h0000;
//				SoundRxFrameState<=8'h00;
//				end
			else begin
				IQDataFSoundFourCnt<=16'h0000;
				IQDataFSoundFrameOver<=1'b1;
				SoundRxFrameState<=8'h00;
				end
			end
	default:SoundRxFrameState<=8'h00;
	endcase
	end
end

endmodule
