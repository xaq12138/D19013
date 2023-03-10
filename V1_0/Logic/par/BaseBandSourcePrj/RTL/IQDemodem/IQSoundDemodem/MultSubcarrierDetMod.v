module	MultSubcarrierDetMod(
input								clk_i,
input								rst_i,
//user set
input			[7:0]				IntegralLenSet_i,
input			[31:0]			DetThreshold_i,
//data in
input								SinDaEn_i,
input			[31:0]			SinData_i,//signed data 
input								CosDaEn_i,
input			[31:0]			CosData_i,//signed data 
//subcarrier det bit out
output reg						SubDetEn_o,
output reg						SubDetBit_o
); 
/***********************************************************
				local wire & reg
***********************************************************/ 
reg				LocalDetBit,LocalDetEn,SinCosIntDaEn,BitShiftEn;
reg	[31:0]	SinCosIntData;
reg	[7:0]		DetBitShift;
wire				SinIntegralDaEn;
wire	[31:0]	SinIntegralData,CosIntegralData;
/***********************************************************
				logic
***********************************************************/
//sin+cos
 always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin	
		SinCosIntDaEn<=1'b0;
		SinCosIntData<=32'h0;
	end
	else if(SinIntegralDaEn)begin
		SinCosIntData<=SinIntegralData+CosIntegralData;
		SinCosIntDaEn<=1'b1;
	end
	else begin	
		SinCosIntDaEn<=1'b0;
		SinCosIntData<=SinCosIntData;
	end
//LocalDetBit
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin
		LocalDetBit<=1'b0;
		LocalDetEn<=1'b0;
	end
	else if(SinCosIntDaEn)begin
		LocalDetBit<=SinCosIntData>DetThreshold_i ? 1'b1 : 1'b0;
		LocalDetEn<=1'b1;
	end
	else begin
		LocalDetBit<=1'b0;
		LocalDetEn<=1'b0;
	end
//DetBitShift
 always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin
		DetBitShift<=8'h0;
		BitShiftEn<=1'b0;
	end
	else if(LocalDetEn)begin
		DetBitShift<={DetBitShift[6:0],LocalDetBit};
		BitShiftEn<=1'b1;
	end
	else begin
		DetBitShift<=DetBitShift;
		BitShiftEn<=1'b0;
	end
//SubDetBit_o
 always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin
		SubDetEn_o<=1'b0;
		SubDetBit_o<=1'b0;
	end
	else if(BitShiftEn)begin
		SubDetEn_o<=1'b1;
		SubDetBit_o<=(&DetBitShift)==1'b1 ? 1'b1 : 
							(|DetBitShift)==1'b0 ? 1'b0 : SubDetBit_o;
	end
	else begin
		SubDetEn_o<=1'b0;
		SubDetBit_o<=SubDetBit_o;
	end
/***********************************************************
				mod:SeriesIntegralMod
***********************************************************/
SeriesIntegralMod  SININT(
	.clk_i(						clk_i),
	.rst_i(						rst_i),
	.IntegralLenSet_i(		IntegralLenSet_i),
	.DaEn_i(						SinDaEn_i),
	.Data_i(						SinData_i),//signed data 
	.IntegralDaEn_o(			SinIntegralDaEn),
	.IntegralData_o(			SinIntegralData));//signed data 
/***********************************************************
				mod:SeriesIntegralMod
***********************************************************/
SeriesIntegralMod  COSINT(
	.clk_i(						clk_i),
	.rst_i(						rst_i),
	.IntegralLenSet_i(		IntegralLenSet_i),
	.DaEn_i(						CosDaEn_i),
	.Data_i(						CosData_i),//signed data 
	.IntegralDaEn_o(			),
	.IntegralData_o(			CosIntegralData));//signed data 
endmodule	