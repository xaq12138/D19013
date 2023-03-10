module	BPSKLocalNCO(
	input								clk_i,
	input								rst_i,
	input			[31:0]			SubcarrierRateSet_i,
	input			[11:0]			BPSKTheta_i,
	input								BPSKThetaValid_i,
	output		[9:0]				LocalNCOSin_o,
	output		[9:0]				LocalNCOCos_o);
/***********************************************************
				wire & reg
***********************************************************/
reg					PreIntCycClk;
reg	[31:0]		NCOIncNewSet,SubcarrierRateSetHold;
reg	[31:0]		PreNCOInc,DelteThetaChk;
wire	[31:0]		NCOIncSet;
wire	[11:0]		BDelteTheta,FirDelteTheta;
wire					ResetNCOInc;
/***********************************************************
				DelteThetaModP
***********************************************************/	
DelteThetaMod DTHBPSK(
		.clk_i(				clk_i),
		.clkEn_i(			BPSKThetaValid_i),
		.rst_i(				rst_i),
		.ThetaIn_i(			BPSKTheta_i),
		.DelteThetaS_o(	BDelteTheta));
/***********************************************************
				DelteThetaMod
***********************************************************/
BSPKDelteThetaFir FIRDTH(
		.clk_i(				clk_i),
		.clkEn_i(			BPSKThetaValid_i),
		.rst_i(				rst_i),
		.BPSKTheta_i(		BPSKTheta_i),
		.DelteTheta_i(		BDelteTheta),
		.ResetNCOInc_o(	ResetNCOInc),
		.FirDelteTheta_o(	FirDelteTheta));
/***********************************************************
				MyNCO  DBPSKNCO
***********************************************************/
nco_if_mixer DBPSKNCO(//10K
		.phi_inc_i(			NCOIncNewSet), 
		.clk(					clk_i), 
		.reset_n(			~rst_i), 
		.clken(				1'b1),
		.phase_mod_i(		0),
		.freq_mod_i(		0),
		.fsin_o(				LocalNCOSin_o), 
		.fcos_o(				LocalNCOCos_o), 
		.out_valid());	
/***********************************************************
				AddSub32
***********************************************************/
AddSub32 ADDBUS32INC(
	.add_sub(			1'b0),//1 add  0 sub
	.dataa(				NCOIncNewSet),
	.datab(				DelteThetaChk),
	.result(				NCOIncSet));
/***********************************************************
				logic
***********************************************************/
//PreIntCycClk 
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)begin
		NCOIncNewSet<=SubcarrierRateSet_i;
		SubcarrierRateSetHold<=SubcarrierRateSet_i;
	end
	else if(ResetNCOInc)begin
		NCOIncNewSet<=SubcarrierRateSet_i;
		SubcarrierRateSetHold<=SubcarrierRateSet_i;
	end
	else if(SubcarrierRateSetHold!= SubcarrierRateSet_i)begin
		NCOIncNewSet<=SubcarrierRateSet_i;
		SubcarrierRateSetHold<=SubcarrierRateSet_i;
	end
	else if(NCOIncSet>(SubcarrierRateSet_i+{10'h0,SubcarrierRateSet_i[31:10]}))//2147483 2MHz
		NCOIncNewSet<=(SubcarrierRateSet_i+{10'h0,SubcarrierRateSet_i[31:10]});
	else if(NCOIncSet<(SubcarrierRateSet_i-{10'h0,SubcarrierRateSet_i[31:10]}))
		NCOIncNewSet<=(SubcarrierRateSet_i-{10'h0,SubcarrierRateSet_i[31:10]});
	else
		NCOIncNewSet<=NCOIncSet;
//DelteThetaChk
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)
		DelteThetaChk<=32'h0;
	else
		DelteThetaChk<={{17{FirDelteTheta[11]}},FirDelteTheta,{3{FirDelteTheta[11]}}};
//		DelteThetaChk<={{15{FirDelteTheta[11]}},FirDelteTheta,{5{FirDelteTheta[11]}}};//2MHz 1.49 degree
	
endmodule	