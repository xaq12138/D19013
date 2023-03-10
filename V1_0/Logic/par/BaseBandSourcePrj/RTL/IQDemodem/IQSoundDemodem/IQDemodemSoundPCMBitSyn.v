module	IQDemodemSoundPCMBitSyn(
	input							ad_data_clk,
	input							rst_n,
	input 		[31:0]		IQDataFSoundCicAve,
	input 		[31:0]		IQDataFSoundCicAveHalf,
	input 						IQDataFSoundCicEn,
	input			[31:0]		CFGIQDataFSoundAvePara,
	
	output reg					IQDataFSoundBit_o,
	output reg					IQDataFSoundCicEn_o);

/**********************************************************************************
												local wire	
**********************************************************************************/
reg	[3:0]			IQDataFSoundCnt,IQDataFSoundNullCnt;			
reg	[3:0]			SoundRxBitState;				

/**********************************************************************************
												assign	
**********************************************************************************/
	
/********************************************************************************
											localparam
*********************************************************************************/
//localparam				SOUNDAVE			=			32'd10000;

/********************************************************************************
											
*********************************************************************************/

always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	IQDataFSoundCnt									<=4'h0;
	IQDataFSoundNullCnt								<=4'h0;
	SoundRxBitState									<=4'h0;
	end
else begin
	if(IQDataFSoundCicEn)begin
		if((IQDataFSoundCicAve>=CFGIQDataFSoundAvePara)&&(IQDataFSoundCicAveHalf>=CFGIQDataFSoundAvePara))begin
			IQDataFSoundBit_o<=1'b1;
			end
		else if((IQDataFSoundCicAve<CFGIQDataFSoundAvePara)&&(IQDataFSoundCicAveHalf<CFGIQDataFSoundAvePara))begin
			IQDataFSoundBit_o<=1'b0;
			end
		else begin
			IQDataFSoundBit_o<=IQDataFSoundBit_o;
			end
		IQDataFSoundCicEn_o<=1'b1;
		end
	else begin
		IQDataFSoundCicEn_o<=1'b0;
		end
	end
end
	
//always@(posedge ad_data_clk or negedge rst_n)
//begin
//if(!rst_n)begin
//	IQDataFSoundCnt									<=4'h0;
//	IQDataFSoundNullCnt								<=4'h0;
//	SoundRxBitState									<=4'h0;
//	end
//else begin
//	case(SoundRxBitState)
//		4'h0:begin
//				if(IQDataFSoundCicEn)begin
//					if(IQDataFSoundCicAve>SOUNDAVE)begin
//						IQDataFSoundCnt				<=IQDataFSoundCnt+1'b1;
//						IQDataFSoundNullCnt			<=4'h0;
//						end
//					else begin
//						IQDataFSoundNullCnt			<=IQDataFSoundNullCnt+1'b1;
//						IQDataFSoundCnt				<=4'h0;
//						end
//					SoundRxBitState					<=4'h1
//					end;
//				end
//		4'h1:begin
//				if(IQDataFSoundCnt>1)begin
//					IQDataFSoundCnt					<=4'h0;
//					IQDataFSoundBit					<=1'b1;
//					end
//				else if(IQDataFSoundNullCnt>1)begin
//					IQDataFSoundNullCnt				<=4'h0;
//					IQDataFSoundBit					<=1'b0;
//					end
//				else begin
//					IQDataFSoundCnt					<=IQDataFSoundCnt;
//					IQDataFSoundNullCnt				<=IQDataFSoundNullCnt;
//					IQDataFSoundBit					<=IQDataFSoundBit;
//					end
//				SoundRxBitState						<=4'h0;
//				end
//		default: SoundRxBitState					<=4'h0;
//		endcase
//	end
//end

endmodule
