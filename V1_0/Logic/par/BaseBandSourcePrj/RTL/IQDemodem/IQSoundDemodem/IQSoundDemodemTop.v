module	IQSoundDemodemTop(
	input					ad_data_clk,
	input					rst_n,
	input					clkEn_i,
	
	input	 [11:0]		ADRxFreq_i,
	input	 [31:0]		CFGIQDataFSoundAvePara,
	output [7:0] 		IQDataFSoundByte,
	output  				IQDataFSoundByteEn,
	output 				IQDataFSoundFrameLock,
	output 				IQDataFSoundFrameOver);

/**********************************************************************************
												local wire	
**********************************************************************************/

wire	[15:0]			IQDataFSoundAddr;
wire						IQDataFSoundCicEn;
wire	[31:0]			DetThreshold;
wire	[7:0]				IntegralLenSet;

/**********************************************************************************
										ConstantAve
**********************************************************************************/	

ConstantAve	ConstantAvePara (
	.result ( 							DetThreshold ));	

ConstantInterTime	ConstantInterTimePara (
	.result ( 							IntegralLenSet));
	
/**********************************************************************************
										IQSound0Demodem
**********************************************************************************/	

IQSoundDemodem IQSound0Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,//
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0005_97A7),//5.12k---clk60M //32'h00A7_C5AC),// 5.12k---clk2M 
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[0]),
	.IQDataFSoundCicEn_o(			IQDataFSoundCicEn));
/**********************************************************************************
										IQSound1Demodem
**********************************************************************************/	
IQSoundDemodem IQSound1Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,//
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0006_FD91),//6.4k---clk60M //32'h00D1_B717),// 6.4k---clk2M 
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[1]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound2Demodem
**********************************************************************************/	
IQSoundDemodem IQSound2Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,//
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0007_6D6A),//6.8k---clk60M //32'h00DE_D288),//CFGPcmFreqSound0_i[31:0]), 6.8k---clk2M 
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[2]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound3Demodem
**********************************************************************************/	
IQSoundDemodem IQSound3Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,//
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0007_DD44),//7.2k---clk60M //32'h00EB_EDFA),//CFGPcmFreqSound0_i[31:0]), 7.2k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[3]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound4Demodem
**********************************************************************************/	
IQSoundDemodem IQSound4Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,//
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0008_4D1D),//7.6k---clk60M //32'h00F9_096B),//CFGPcmFreqSound0_i[31:0]), 7.6k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[4]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound5Demodem
**********************************************************************************/	
IQSoundDemodem IQSound5Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0008_BCF6),//8.0k---clk60M //32'h0106_24DD),//CFGPcmFreqSound0_i[31:0]), 8.00k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[5]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound6Demodem
**********************************************************************************/	
IQSoundDemodem IQSound6Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0009_2CCF),//8.40k---clk60M //32'h0113_404E),//CFGPcmFreqSound0_i[31:0]), 8.40k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[6]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound7Demodem
**********************************************************************************/	
IQSoundDemodem IQSound7Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h0009_9CA8),//8.80k---clk60M //32'h0120_5BBF),//CFGPcmFreqSound0_i[31:0]), 8.80k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[7]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound8Demodem
**********************************************************************************/	
IQSoundDemodem IQSound8Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000A_0C81),//9.20k---clk60M //32'h012D_7730),//CFGPcmFreqSound0_i[31:0]), 9.20k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[8]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound9Demodem
**********************************************************************************/	
IQSoundDemodem IQSound9Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000A_7C5A),//9.60k---clk60M //32'h013A_92A1),//CFGPcmFreqSound0_i[31:0]), 9.60k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[9]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound10Demodem
**********************************************************************************/	
IQSoundDemodem IQSound10Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000A_EC33),//10.0k---clk60M //32'h0147_AE12),//CFGPcmFreqSound0_i[31:0]), 10.0k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[10]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound11Demodem
**********************************************************************************/	
IQSoundDemodem IQSound11Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000B_5C0D),//10.4k---clk60M //32'h0154_C985),//CFGPcmFreqSound0_i[31:0]), 10.4k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[11]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound12Demodem
**********************************************************************************/	
IQSoundDemodem IQSound12Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000B_CBE6),//32'h00‭0B_CBE6),//10.8k---clk60M //32'h0161_E4F7),//CFGPcmFreqSound0_i[31:0]), 10.8k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[12]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound13Demodem
**********************************************************************************/	
IQSoundDemodem IQSound13Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000C_3BBF),//11.2k---clk60M //32'h016F_0068),//CFGPcmFreqSound0_i[31:0]), 11.2k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[13]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound14Demodem
**********************************************************************************/	
IQSoundDemodem IQSound14Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000C_AB98),//11.6k---clk60M //32'h017C_1BDA),//CFGPcmFreqSound0_i[31:0]), 11.6k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[14]),
	.IQDataFSoundCicEn_o(			));
/**********************************************************************************
										IQSound15Demodem
**********************************************************************************/	
IQSoundDemodem IQSound15Demodem
(
	.ad_data_clk(						ad_data_clk) ,						
	.rst_n(								rst_n),
	.clkEn_i(							clkEn_i) ,
	.ADRxFreq_i(						ADRxFreq_i),
	.CFGFreqSound_i(					32'h000D_1B71),//12.0k---clk60M //32'h0189_374B),//CFGPcmFreqSound0_i[31:0]), 12.0k---clk2M
	.DetThreshold(						DetThreshold),
	.IntegralLenSet(					IntegralLenSet),
	.IQDataFSoundCicBit_o(			IQDataFSoundAddr[15]),
	.IQDataFSoundCicEn_o(			));


/**********************************************************************************
										IQDemodemSoundPCM
**********************************************************************************/	
IQDemodemSoundPCM IQDemodemSoundPCMFrame(
	.ad_data_clk(						ad_data_clk) ,		
	.rst_n(								rst_n) ,		
	.IQDataFSoundAddr(				IQDataFSoundAddr),
	.IQDataFSoundCicEn(				IQDataFSoundCicEn) ,	
	.SoundRxFrameLen(					16'h07) ,	
	.IQDataFSoundByte(				IQDataFSoundByte) ,	
	.IQDataFSoundByteEn(				IQDataFSoundByteEn) ,
	.IQDataFSoundFrameLock(			IQDataFSoundFrameLock),
	.IQDataFSoundFrameOver(			IQDataFSoundFrameOver),
	.IQDataFSoundByteTest(			));
	
/**********************************************************************************
										PCM-FRQ
**********************************************************************************/	
//32'h00A7_C5AC),//CFGPcmFreqSound0_i[31:0]), 5.12k---clk2M 
//32'h00D1_B717),//CFGPcmFreqSound0_i[31:0]), 6.40k---clk2M 
//32'h00DE_D288),//CFGPcmFreqSound0_i[31:0]), 6.80k---clk2M  
//32'h00EB_EDFA),//CFGPcmFreqSound0_i[31:0]), 7.20k---clk2M 
//32'h00F9_096B),//CFGPcmFreqSound0_i[31:0]), 7.60k---clk2M
//32'h0106_24DD),//CFGPcmFreqSound0_i[31:0]), 8.00k---clk2M 
//32'h0113_404E),//CFGPcmFreqSound0_i[31:0]), 8.40k---clk2M  
//32'h0120_5BBF),//CFGPcmFreqSound0_i[31:0]), 8.80k---clk2M
//32'h012D_7730),//CFGPcmFreqSound0_i[31:0]), 9.20k---clk2M 
//32'h013A_92A1),//CFGPcmFreqSound0_i[31:0]), 9.60k---clk2M 
//32'h0147_AE12),//CFGPcmFreqSound0_i[31:0]), 10.0k---clk2M 
//32'h0154_C985),//CFGPcmFreqSound0_i[31:0]), 10.4k---clk2M 
//32'h0161_E4F7),//CFGPcmFreqSound0_i[31:0]), 10.8k---clk2M 
//32'h016F_0068),//CFGPcmFreqSound0_i[31:0]), 11.2k---clk2M
//32'h017C_1BDA),//CFGPcmFreqSound0_i[31:0]), 11.6k---clk2M
//32'h0189_374B),//CFGPcmFreqSound0_i[31:0]), 12.0k---clk2M 


//32'h0005_97A7),//CFGPcmFreqSound0_i[31:0]), 5.12k---clk60M 
//32'h0006_FD91),//CFGPcmFreqSound0_i[31:0]), 6.40k---clk60M 
//32'h0007_6D6A),//CFGPcmFreqSound0_i[31:0]), 6.80k---clk60M  
//32'h0007_DD44),//CFGPcmFreqSound0_i[31:0]), 7.20k---clk60M 
//32'h0008_4D1D),//CFGPcmFreqSound0_i[31:0]), 7.60k---clk60M
//32'h0008_BCF6),//CFGPcmFreqSound0_i[31:0]), 8.00k---clk60M 
//32'h0009_2CCF),//CFGPcmFreqSound0_i[31:0]), 8.40k---clk60M  
//32'h0009_9CA8),//CFGPcmFreqSound0_i[31:0]), 8.80k---clk60M
//32'h000A_0C81),//CFGPcmFreqSound0_i[31:0]), 9.20k---clk60M 
//32'h000A_7C5A),//CFGPcmFreqSound0_i[31:0]), 9.60k---clk60M 
//32'h000A_EC33),//CFGPcmFreqSound0_i[31:0]), 10.0k---clk60M 
//32'h000B_5C0D),//CFGPcmFreqSound0_i[31:0]), 10.4k---clk60M 
//32'h000B_CBE6),//CFGPcmFreqSound0_i[31:0]), 10.8k---clk60M 
//32'h000C_3BBF),//CFGPcmFreqSound0_i[31:0]), 11.2k---clk60M
//32'h000C_AB98),//CFGPcmFreqSound0_i[31:0]), 11.6k---clk60M
//32'h000D_1B71),//CFGPcmFreqSound0_i[31:0]), 12.0k---clk60M 
	
endmodule
