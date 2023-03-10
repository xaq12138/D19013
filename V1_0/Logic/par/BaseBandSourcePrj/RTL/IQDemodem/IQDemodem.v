module	IQDemodem(
	input						ad_data_clk,
	input						rx_frame_p,
	input						rst_n,
	
	input		[11:0]		ADIQData_i,
	input		[31:0]		ADRxIFFreq,
	input		[2:0]			ADRxFGain,
	input		[31:0]		ADRxPcmFreq,
	input		[15:0]		ADRxFrameCodeL,
	input		[15:0]		ADRxFrameCodeLen,
	input		[3:0]			ADRxCodeMode,
	input		[31:0]		ADRxState,
	input		[31:0]		CFGIQDataFSoundAvePara,
	
	output					ADRxBd_o,
	output					ADRxBs_o,
	output					ADRxBynBd_o,
	output					ADRxBynBs_o,
	output reg				ADRxByteEn_o,
	output reg [7:0]		ADRxByte_o,	
	output reg				ADRxFrameLock,
	output reg				ADRxFrameOver);

/**********************************************************************************
												local wire	
**********************************************************************************/
wire		[11:0]		IDataBuf,QDataBuf,IDataBuf_o,QDataBuf_o;
wire		[31:0]		ADRxDetFreq,ADRxPFreq;
wire		[9:0]			FSinRx_o,FCosRx_o;
wire		[21:0]		IDataCosBuf,QDataSinBuf;

wire		[7:0]			ADRxRateCic3,ADRxRateCic5;
wire		[3:0]			ADRxModeSel,ADRxSubCarrierTime;
wire						IQDataEn_o;
wire		[11:0]		ADRxIQTheta,ADRxIQDelteThetaS_o,ADRxIQDelteThetaSReturn_o;//ADRxAccFreq,
wire						ADRxIQThetaEn;
wire		[30:0]		ADRxAccFreq;
wire		[35:0]		ADRxIQThetaCic;
wire						ADRxIQThetaCicEn;
wire		[30:0]		IDataCosFirBuf,QDataCosFirBuf;

wire		[7:0] 		ADRxFMByte,IQDataFSoundByte;
wire		  				ADRxFMByteEn,IQDataFSoundByteEn;
wire		 				ADRxFMFrameOver,IQDataFSoundFrameOver;
wire		 				ADRxFMFrameLock,IQDataFSoundFrameLock;
wire						BitClkSamp;	
wire		[3:0]			DemodemMode;
/**********************************************************************************
												assign	
**********************************************************************************/	
//assign					ADRxBs_o				=ADRxIQThetaEn;
assign					ADRxSubCarrierTime[3:0]			=4'h4;//ADRxState[27:24];
assign					ADRxModeSel[3:0]					=DemodemMode[3:0];//ADRxState[19:16];
assign					ADRxRateCic3[7:0]					=ADRxState[15:8];
assign					ADRxRateCic5[7:0]					=ADRxState[7:0];	

/**********************************************************************************
												Constant
**********************************************************************************/	
DemodemModeCons	DemodemModeConsTop (
	.result ( DemodemMode[3:0] )
	);
/**********************************************************************************
												
**********************************************************************************/	

always @(posedge ad_data_clk or negedge rst_n)
begin
	if(!rst_n)begin
		end
	else begin
		if(ADRxModeSel==4'b1000)begin					//PSK-FM
			ADRxByte_o								<=ADRxFMByte;
			ADRxByteEn_o							<=ADRxFMByteEn;
			ADRxFrameLock							<=ADRxFMFrameLock;
			ADRxFrameOver							<=ADRxFMFrameOver;
			end
		else if(ADRxModeSel==4'b1101)begin			//Sound
			ADRxByte_o								<=IQDataFSoundByte;
			ADRxByteEn_o							<=IQDataFSoundByteEn;
			ADRxFrameLock							<=IQDataFSoundFrameLock;
			ADRxFrameOver							<=IQDataFSoundFrameOver;
			end
		end
end

/**********************************************************************************
										
**********************************************************************************/	
ddio_in	IQDataTx(
	.inclock(							ad_data_clk),
	.datain(								ADIQData_i),
	.dataout_h(							IDataBuf),
	.dataout_l(							QDataBuf));
/**********************************************************************************
										
**********************************************************************************/	
	
ADD32	ADDRxFrq(
	.clock(								ad_data_clk),
	.dataa(								ADRxIFFreq),								
	.datab(								ADRxDetFreq),
	.result(								ADRxPFreq));
/**********************************************************************************
										
**********************************************************************************/	
				
nco_if_mixer IQModemNCORx (
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							ADRxPFreq),
	.freq_mod_i(						32'h0000_0000),
	.phase_mod_i(						32'h0000_0000), 
	.fsin_o(								FSinRx_o),      			
	.fcos_o(								FCosRx_o),      			
	.out_valid(							));		
	
/**********************************************************************************
										
**********************************************************************************/	
MUL10_12	IQDataMUL10_12 (
	.clock ( 							ad_data_clk ),
	.dataa_imag ( 						IDataBuf ),
	.dataa_real ( 						QDataBuf ),
	.datab_imag ( 						FSinRx_o ),
	.datab_real ( 						FCosRx_o ),
	.result_imag (  					IDataCosBuf),
	.result_real ( 					QDataSinBuf));


/**********************************************************************************
										
**********************************************************************************/	
filter_acc FilterACCRx(
	.clk_sys(							ad_data_clk) ,	
	.rst_s(								rst_n) ,
	.coef_set(							ADRxFrameLock) ,	
	.cic3_rate(							ADRxRateCic3) ,	
	.cic5_rate(							ADRxRateCic5) ,	
	.in_valid(							1'b1) ,	
	.coef_set_in(						1'b0) ,	
	.coef_we(							1'b0) ,	
	.coef_in(							16'h0000) ,	
	.coef_in_clk(						1'b0) ,
	.i_data(								IDataCosBuf[20:9]) ,
	.q_data(								QDataSinBuf[20:9]) ,	
	.clk_ena(							IQDataEn_o) ,	
	.i_out(								IDataBuf_o) ,	
	.q_out(								QDataBuf_o));
/**********************************************************************************
										
**********************************************************************************/	
	
	
cordic ADRxCordic(
	.clk_samp(							ad_data_clk) ,	
	.clk_ena(							IQDataEn_o),//1'B1) ,
	.iq_singal(							1'B0) ,								
	.xi(									IDataBuf_o),//IDataCosFirBuf[24:13]),//IDataCosBuf[20:9]),//i_buff[15:4]) ,
	.yi(									QDataBuf_o),//QDataCosFirBuf[24:13]),//QDataSinBuf[20:9]),//q_buff[15:4]) ,	
	.xo(									) ,	 
	.yo(									) ,	
	.zo(									ADRxIQTheta) ,	
	.samp_ena(							ADRxIQThetaEn) ,
	.samp_iq_singal(					));	

	
/**********************************************************************************
										
**********************************************************************************/	

DelteThetaMod DelteThetaReturn(
	.clk_i(								ad_data_clk),
	.rst_i(								~rst_n),
	.clkEn_i(							ADRxIQThetaEn) ,//1'B1),
	.ThetaIn_i(							ADRxIQTheta),
	.DelteThetaS_o(					ADRxIQDelteThetaSReturn_o));

/**********************************************************************************
										
**********************************************************************************/		
//FIR8M_LP FIR8MReturn(
//	.clk(									ad_data_clk),             
//	.reset_n(							rst_n),        
//	.ast_sink_data(					ADRxIQDelteThetaSReturn_o[11:0]),   
//	.ast_sink_valid(					ADRxIQThetaEn) ,//1'B1),  
//	.ast_sink_error(					2'B00),  
//	.ast_source_data(					ADRxAccFreq), 
//	.ast_source_valid(				),
//	.ast_source_error(				));	

/**********************************************************************************
										
**********************************************************************************/	
//fsk_acc ADRxFskAcc(
//	.clk_sys(							ad_data_clk) ,
//	.clk_ena(							ADRxIQThetaEn) ,
//	.theta(								ADRxIQTheta) ,	
//	.f_gain(								ADRxFGain) ,		
//	.f(									ADRxAccFreq));
/**********************************************************************************
										
**********************************************************************************/	
	
iir_fzb_fsk ADRxFskSubIIR(
	.clk_sys(							ad_data_clk) ,	
	.ena_smp(							ADRxIQThetaEn) ,//1'b1),ADRxIQThetaCicEn//
	.f_in(								ADRxIQDelteThetaSReturn_o),//ADRxAccFreq[26:15]) ,	
	.afc_flag(							1'b1) ,
	.det_f(								ADRxDetFreq));
/**********************************************************************************
										
**********************************************************************************/	
	
jsj_fzb_jt ADRxFskSubDemodem(
	.clk_sys(							ad_data_clk) ,	
	.rst_s(								rst_n) ,
	.code_f(								ADRxPcmFreq) ,
	.clk_ena(							ADRxIQThetaEn) ,//1'b1),	
	.fm_in(								ADRxIQDelteThetaSReturn_o),//ADRxAccFreq[26:15]) ,	
	.fzb_time(							ADRxSubCarrierTime) ,	
	.pcm_out(							),//ADRxBd_o), 
	.pcm_out_d(							ADRxBd_o) ,//),
	.pcm_out_ena(						ADRxBs_o));
/**********************************************************************************
										
**********************************************************************************/	
//CLK_SAMPLE_GENERATOR 	CLKSAMPLE(
//	.clk_sys(							ad_data_clk) ,	
//	.bit_f(								ADRxPcmFreq) ,
//	.clk_samp(							BitClkSamp));
/**********************************************************************************
										
**********************************************************************************/	
bitsyner_new ADRxFskByn
(
	.clk_sys(							ad_data_clk) ,			
	.clk_samp(							1'b1),	//BitClkSamp) ,						
	.pcm_in(								{2'b00,ADRxBd_o}) ,								
	.nco_f(								ADRxPcmFreq) ,								
	.code_bw(							2'b00) ,								
	.pcm_type(							ADRxCodeMode),//4'h0) ,				
	.demodem_mod(						4'h0) ,							
	.modem_m_s(							1'b0) ,	 							
	.jf_clr_f(							1'b1) ,	  							
	.offset_8psk_f(					1'b0) ,	 			
	.coef(								16'h0000) ,						
	.bs_50(								) ,	 								
	.bs(									ADRxBynBs_o) ,  									
	.bd(									ADRxBynBd_o) ,	 									
	.bs_q(								) ,							
	.bd_q(								) ,							
	.bit_lock(							) ,			 								
	.nco_fof(							) ,	 							
	.nco_fo(								) ,	 								
	.led(									) ,										
	.nco_foa(							) ,	 							
	.nco_fob(							) ,	 							
	.nco_foc(							) ,	 							
	.nco_fod(							));
/**********************************************************************************
										
**********************************************************************************/	
framer_ankong FramerSyn
(
	.clk_sys(							ad_data_clk) ,
	.rst_n(								rst_n) ,
	.bs(									ADRxBynBs_o) ,
	.bd(									ADRxBynBd_o) ,
	.fram_h(								ADRxFrameCodeL) ,	
	.fram_lth(							ADRxFrameCodeLen) ,
	.ws(									ADRxFMByteEn) ,
	.byte_out(							ADRxFMByte) ,	
	.fram_lock(							ADRxFMFrameLock) ,
	.fram_over(							ADRxFMFrameOver) ,
	.f_cont(								) ,	
	.f_cont_lock(						)
);
/**********************************************************************************
										
**********************************************************************************/	

IQSoundDemodemTop IQSoundDemodem(
	.ad_data_clk(						ad_data_clk),							
	.rst_n(								rst_n),	
	.clkEn_i(							ADRxIQThetaEn) ,//1'B1),
	.ADRxFreq_i(						ADRxIQDelteThetaSReturn_o[11:0]),
	.CFGIQDataFSoundAvePara(		CFGIQDataFSoundAvePara),
	.IQDataFSoundByte(				IQDataFSoundByte) ,	
	.IQDataFSoundByteEn(				IQDataFSoundByteEn) ,	
	.IQDataFSoundFrameLock(			IQDataFSoundFrameLock),
	.IQDataFSoundFrameOver(			IQDataFSoundFrameOver));
	
endmodule
