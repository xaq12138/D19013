module	IQSoundDemodem(
	input						ad_data_clk,
	input						rst_n,
	input						clkEn_i,
	
	input		  [11:0]		ADRxFreq_i,
	input	 	  [31:0]		CFGFreqSound_i,
	input		  [31:0]		DetThreshold,
	input		  [7:0]		IntegralLenSet,
	output  					IQDataFSoundCicEn_o,
	output  					IQDataFSoundCicBit_o);
/**********************************************************************************
												local wire	
**********************************************************************************/
wire	[9:0]		FSinSound_o,FCosSound_o;
wire	[21:0]	IDataFSound_o,QDataFSound_o;
wire	[31:0]	IDataFSoundCic_o,QDataFSoundCic_o;//IQDataFSoundCicADD_o;
//wire	[31:0]	IDataFSoundCicEx_o,QDataFSoundCicEx_o;
//reg	[31:0]	IDataFSoundCicAbs_o,QDataFSoundCicAbs_o;
wire				IDataFSoundCicEn_o,QDataFSoundCicEn_o;
wire	[31:0]	IDataFSoundCicFir_o,QDataFSoundCicFir_o;	
//reg	[31:0]	IDataFSoundCicADDAcc_o,QDataFSoundCicADDAcc_o;
//reg	[7:0]		IQDataFSoundCicCnt;
//reg	[31:0]	IDataFSoundCicAve_o,QDataFSoundCicAve_o;
wire	[31:0]	IQDataFSoundCicAve,IQDataFSoundCicAveHalf;
wire				IQDataFSoundCicEnHalf;
//wire	[31:0]	DetThreshold;

/**********************************************************************************
												assign	
**********************************************************************************/	
//assign IDataFSoundCicAbs_o[30:0]				=IDataFSoundCic_o[31]?	~IDataFSoundCic_o[30:0] : IDataFSoundCic_o[30:0];
//assign	IDataFSoundCicAbs_o[30:0]				=QDataFSoundCic_o[31]?	~QDataFSoundCic_o[30:0] : QDataFSoundCic_o[30:0];
//assign	IDataFSoundCicEx_o[15:0]				=IDataFSoundCic_o[31:16];
//assign	IDataFSoundCicEx_o[31:16]				={16{IDataFSoundCic_o[31]}};
//assign	QDataFSoundCicEx_o[15:0]				=QDataFSoundCic_o[31:16];
//assign	QDataFSoundCicEx_o[31:16]				={16{QDataFSoundCic_o[31]}};
/**********************************************************************************
										
**********************************************************************************/	
				
//IQModemNCO IQModemNCORxSound(
//	.clk(									ad_data_clk),         			
//	.reset_n(							rst_n),     		 				
//	.clken(								1'b1),       	 					
//	.phi_inc_i(							CFGFreqSound_i),//32'h00A7_C5AC),// 5.12k---clk2M 			
//	.freq_mod_i(						32'h00000000),  		 			
//	.phase_mod_i(						16'h0000), 
//	.fsin_o(								FSinSound_o),      			
//	.fcos_o(								FCosSound_o),      			
//	.out_valid(							));
	
IQDemodemNCOSound IQDemodemNCOSoundRx (
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGFreqSound_i),//32'h00A7_C5AC),// 5.12k---clk2M 	  
	.fsin_o(								FSinSound_o),      			
	.fcos_o(								FCosSound_o),      			
	.out_valid(							));		
	
/**********************************************************************************
										
**********************************************************************************/	
MUL10_12_S	MUL10_12_QData(
	.dataa( 								FSinSound_o[9:0]),
	.datab( 								ADRxFreq_i),
	.result( 							QDataFSound_o));
/**********************************************************************************
										
**********************************************************************************/	
MUL10_12_S	MUL10_12_IData(
	.dataa( 								FCosSound_o[9:0]),
	.datab( 								ADRxFreq_i),
	.result( 							IDataFSound_o));
/**********************************************************************************
										
**********************************************************************************/	
CICSoundSet CICSSetQData (
	.clk(									ad_data_clk),      
	.reset_n(							rst_n),
	.in_error(							2'b00), 
	.in_valid(							clkEn_i),//1'b1),
	.out_ready(							1'b1),
	.in_data(							QDataFSound_o[20:9]),  
	.out_data(							QDataFSoundCic_o[31:0]),  
	.out_error(							), 
	.out_valid(							QDataFSoundCicEn_o),   
	.in_ready (							));	
/**********************************************************************************
										
**********************************************************************************/	
CICSoundSet CICSSetIData (
	.clk(									ad_data_clk),      
	.reset_n(							rst_n),
	.in_error(							2'b00), 
	.in_valid(							clkEn_i),//1'b1),
	.out_ready(							1'b1),
	.in_data(							IDataFSound_o[20:9]),  
	.out_data(							IDataFSoundCic_o[31:0]),  
	.out_error(							), 
	.out_valid(							IDataFSoundCicEn_o),   
	.in_ready (							));
/**********************************************************************************
										
**********************************************************************************/	
//cordic ADRxCordic(
//	.clk_samp(							ad_data_clk) ,	
//	.clk_ena(							IDataFSoundCicEn_o),//1'B1) ,
//	.iq_singal(							1'B0) ,								
//	.xi(									IDataFSoundCic_o[31:20]),//IDataCosFirBuf[24:13]),//IDataCosBuf[20:9]),//i_buff[15:4]) ,
//	.yi(									QDataFSoundCic_o[31:20]),//QDataCosFirBuf[24:13]),//QDataSinBuf[20:9]),//q_buff[15:4]) ,	
//	.xo(									) ,	 
//	.yo(									) ,	
//	.zo(									) ,	
//	.samp_ena(							) ,
//	.samp_iq_singal(					));	


/**********************************************************************************
										
**********************************************************************************/		
MultSubcarrierDetMod MultSubcarrierDetModAve
(
	.clk_i(								ad_data_clk) ,	 								
	.rst_i(								~rst_n) ,	
	.IntegralLenSet_i(				IntegralLenSet) ,//8'd100),					
	.DetThreshold_i(					DetThreshold),//32'd50000) ,						
	.SinDaEn_i(							QDataFSoundCicEn_o) ,	
	.SinData_i(							{QDataFSoundCic_o[31],QDataFSoundCic_o[31],QDataFSoundCic_o[31],QDataFSoundCic_o[31],QDataFSoundCic_o[31:4]}) ,									
	.CosDaEn_i(							IDataFSoundCicEn_o) ,	
	.CosData_i(							{IDataFSoundCic_o[31],IDataFSoundCic_o[31],IDataFSoundCic_o[31],IDataFSoundCic_o[31],IDataFSoundCic_o[31:4]}) ,	
	.SubDetEn_o(						IQDataFSoundCicEn_o) ,	
	.SubDetBit_o(						IQDataFSoundCicBit_o) 	
);
/**********************************************************************************
										
**********************************************************************************/	
//IQSoundDemodemDataAve IQSoundDemodemDataAve_50
//(
//	.ad_data_clk(						ad_data_clk) ,	
//	.rst_n(								rst_n) ,	
//	.IDataFSoundCicEn(				IDataFSoundCicEn_o) ,	
//	.IDataFSoundCic(					IDataFSoundCic_o) ,	
//	.QDataFSoundCic(					QDataFSoundCic_o) ,
//	
//	.IQDataFSoundCicAve_o(			IQDataFSoundCicAve) ,	
//	.IQDataFSoundCicEn_o(			) ,	 
//	.IQDataFSoundCicEnHalf_o(		IQDataFSoundCicEnHalf));
//
/**********************************************************************************
										
**********************************************************************************/	
//IQSoundDemodemDataAveHalf IQSoundDemodemDataAveHalf_25
//(
//	.ad_data_clk(						ad_data_clk) ,	
//	.rst_n(								rst_n) ,	
//	.IDataFSoundCicEn(				IDataFSoundCicEn_o) ,	 				
//	.IDataFSoundCic(					IDataFSoundCic_o) ,				
//	.QDataFSoundCic(					QDataFSoundCic_o) ,	 					
//	.IQDataFSoundCicAve(				IQDataFSoundCicAve) ,					
//	.IQDataFSoundCicEnHalf(			IQDataFSoundCicEnHalf) ,
//	
//	.IQDataFSoundCicAveHalf_o(		IQDataFSoundCicAveHalf_o) ,		
//	.IQDataFSoundCicAve_o(			IQDataFSoundCicAve_o) ,	 	
//	.IQDataFSoundCicEn_o(			IQDataFSoundCicEn_o));

/**********************************************************************************
										
**********************************************************************************/
//FIR1M_LP QDataFIR1M(
//	.clk(									ad_data_clk),             
//	.reset_n(							rst_n),        
//	.ast_sink_data(					QDataFSoundCic_o[31:20]),
//	.ast_sink_valid(					QDataFSoundCicEn_o),  
//	.ast_sink_error(					2'B00),  
//	.ast_source_data(					QDataFSoundCicFir_o[31:0]), 
//	.ast_source_valid(				),
//	.ast_source_error(				));
/**********************************************************************************
										
**********************************************************************************/
//FIR1M_LP IDataFIR1M(
//	.clk(									ad_data_clk),             
//	.reset_n(							rst_n),        
//	.ast_sink_data(					IDataFSoundCic_o[31:20]),
//	.ast_sink_valid(					IDataFSoundCicEn_o),  
//	.ast_sink_error(					2'B00),  
//	.ast_source_data(					IDataFSoundCicFir_o[31:0]), 
//	.ast_source_valid(				),
//	.ast_source_error(				));
//	
/**********************************************************************************
										
**********************************************************************************/
//	
//ABS_32	IDataABS_32(
//	.data( 								IDataFSoundCic_o[31:0] ),
//	.result( 							IDataFSoundCicAbs_o[31:0] ));
/**********************************************************************************
										
**********************************************************************************/
//	
//ABS_32	QDataABS_32(
//	.data( 								QDataFSoundCic_o[31:0] ),
//	.result( 							QDataFSoundCicAbs_o[31:0] ));
/**********************************************************************************
										
**********************************************************************************/
//ADD32 IQDataADD32(
//	.clock( 								ad_data_clk),
//	.dataa( 								{1'b0,IDataFSoundCicAbs_o[30:0]}),
//	.datab( 								{1'b0,QDataFSoundCicAbs_o[30:0]} ),
//	.result( 							IQDataFSoundCicAve_o[31:0]));//IQDataFSoundCicADD_o[31:0]));

/**********************************************************************************
										
**********************************************************************************/
////always@(posedge ad_data_clk or negedge rst_n)begin
////if(!rst_n)begin
////	IDataFSoundCicAbs_o[31:0]					<=32'h0000_0000;
////	QDataFSoundCicAbs_o[31:0]					<=32'h0000_0000;
////	end
////else begin
////	if(IDataFSoundCic_o[31])begin//if(IDataFSoundCicFir_o[31])begin		
////		IDataFSoundCicAbs_o[30:0]				<=~IDataFSoundCic_o[30:0];//<=~IDataFSoundCicFir_o[30:0];
////		end
////	else begin
////		IDataFSoundCicAbs_o[30:0]				<=IDataFSoundCic_o[30:0];//<=IDataFSoundCicFir_o[30:0];
////		end
////	if(QDataFSoundCic_o[31])begin//if(QDataFSoundCicFir_o[31])begin
////		QDataFSoundCicAbs_o[30:0]				<=~QDataFSoundCic_o[30:0];//<=~QDataFSoundCicFir_o[30:0];
////		end
////	else begin
////		QDataFSoundCicAbs_o[30:0]				<=QDataFSoundCic_o[30:0];//<=QDataFSoundCicFir_o[30:0];
////		end
////	end
////end
/**********************************************************************************
										
**********************************************************************************/
//always@(posedge ad_data_clk or negedge rst_n)begin
//if(!rst_n)begin
//	IQDataFSoundCicCnt							<=8'h00;
//	IDataFSoundCicAve_o[31:0]					<=32'h0000_0000;
//	IDataFSoundCicADDAcc_o[31:0]				<=32'h0000_0000;
//	QDataFSoundCicADDAcc_o[31:0]				<=32'h0000_0000;
//	end
//else begin
//	if(IQDataFSoundCicCnt<50)begin
//		if(IDataFSoundCicEn_o)begin
//			IDataFSoundCicADDAcc_o[31:0]		<=IDataFSoundCicADDAcc_o[31:0]+IDataFSoundCicEx_o[31:0];//IDataFSoundCic_o[31:16];
//			IQDataFSoundCicCnt					<=IQDataFSoundCicCnt+1'b1;
//			end
//		else begin
//			IDataFSoundCicADDAcc_o[31:0]		<=IDataFSoundCicADDAcc_o[31:0];
//			end
//		if(QDataFSoundCicEn_o)begin
//			QDataFSoundCicADDAcc_o[31:0]		<=QDataFSoundCicADDAcc_o[31:0]+QDataFSoundCicEx_o[31:0];//QDataFSoundCic_o[31:16];
//			IQDataFSoundCicCnt					<=IQDataFSoundCicCnt+1'b1;
//			end
//		else begin
//			QDataFSoundCicADDAcc_o[31:0]		<=QDataFSoundCicADDAcc_o[31:0];
//			end
//		IDataFSoundCicAve_o[31:0]				<=IDataFSoundCicAve_o[31:0];
//		QDataFSoundCicAve_o[31:0]				<=QDataFSoundCicAve_o[31:0];
//		end
//	else if(IQDataFSoundCicCnt<51)begin
//		IDataFSoundCicAve_o[31:0]				<=IDataFSoundCicADDAcc_o[31:0];
//		QDataFSoundCicAve_o[31:0]				<=QDataFSoundCicADDAcc_o[31:0];
//		IQDataFSoundCicEn							<=1'b1;
//		IQDataFSoundCicCnt						<=IQDataFSoundCicCnt+1'b1;
//		end
//	else begin
//		IQDataFSoundCicEn							<=1'b0;
//		IQDataFSoundCicCnt						<=8'h00;
//		IDataFSoundCicADDAcc_o[31:0]			<=32'h0000_0000;
//		QDataFSoundCicADDAcc_o[31:0]			<=32'h0000_0000;
//		end
//	end
//end
/**********************************************************************************
										
**********************************************************************************/
//always@(posedge ad_data_clk or negedge rst_n)begin
//if(!rst_n)begin
//	IDataFSoundCicAbs_o[31:0]					<=32'h0000_0000;
//	QDataFSoundCicAbs_o[31:0]					<=32'h0000_0000;
//	end
//else begin
//	if(IDataFSoundCicAve_o[31])begin		
//		IDataFSoundCicAbs_o[30:0]				<=~IDataFSoundCicAve_o[30:0];
//		end
//	else begin
//		IDataFSoundCicAbs_o[30:0]				<=IDataFSoundCicAve_o[30:0];
//		end
//	if(QDataFSoundCicAve_o[31])begin
//		QDataFSoundCicAbs_o[30:0]				<=~QDataFSoundCicAve_o[30:0];
//		end
//	else begin
//		QDataFSoundCicAbs_o[30:0]				<=QDataFSoundCicAve_o[30:0];
//		end
//	end
//end
endmodule
