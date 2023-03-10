module IQModem	(			
input 									ad_data_clk,
input										rst_n,
/************参数配置**********************************************************************/
input										CFGADSourceState1,			//加载/去载  [31:0]	
input										CFGADSourceState2,			 //加调/去调				
input				[31:0]				CFGADSourcePcmFreq,   		//码率         [31:0]	
input				[31:0]				CFGADSourceCarrierFreqShift,  //频偏         [31:0]	
input				[7:0]					CFGADSourceCarrierTime,   //副载波的倍数      [3:0]		
input				[3:0]					pcm_type,//码型选择 
    input                     [7:0] cfg_inst_length             , 
/************指令数据**********************************************************************/ 		 
input     		[511:0]					data_pcm,				//8bit指令数据           [7:0]		
input										data_pcm_valid,       //fifo写入数据请求           			

/************输出数据**********************************************************************/                                      			
//output									BPSKData_o,                                     			
//output			[11:0]				da_iq_out,                                // [11:0]	
output			[11:0]				IData_o,					//输出给AD9785的数据   [15:0]	
output			[11:0]				QData_o					//输出给AD9785的数据   [15:0]	
//output									ad_fb_clk,	                                    			
//output									ad_tx_fram
);


/**********************************************************************************
												local wire	
**********************************************************************************/

wire				[15:0]				PModPSK_i,FSinPSK_o,FSinPSK_N_o,FSinPSK_P_o;
wire				[31:0]				FModTx_i;
wire				[15:0]				FSinTx_o,FCosTx_o;
reg				[11:0]				i_buff,q_buff;
reg										carry_on,modem_on;
wire				[35:0]				CFGPcmFreqPSK_i;
wire				[11:0]				ADRxIQTheta,ADRxIQDelteThetaS_o;
wire				[1:0]					GDBdBuf;
wire										GDBdDiff_o;
reg										TxBd_o;
wire										TxBdSource,TxBsSource,TxBdSourceClkedge;
reg				[3:0]					TxBdSourceClkHold;
wire										GDBs_o,TxBdSourceClkEdge;
wire										Fifo_rden_pcm,Fifo_empty_pcm;
wire				[7:0]					Fifo_q_pcm;
wire										pcm_reg;

//
wire										bs;
wire										pcm_reg_in;
/**********************************************************************************
												assign	
**********************************************************************************/	
//wire										GDBd_o;

assign									TxBdSource				=pcm_reg;//GDBd_o ;
assign									TxBsSource				=bs;//GDBs_o ;
assign									ad_fb_clk				=ad_data_clk;
assign									ad_tx_fram				=ad_data_clk;
assign									FSinPSK_o				= TxBd_o ?					FSinPSK_N_o	:FSinPSK_P_o;
assign									FModTx_i					=FSinPSK_o[15]?		CFGADSourceCarrierFreqShift	:~CFGADSourceCarrierFreqShift;		
assign									BPSKData_o				=FSinPSK_o[15];
assign									TxBdSourceClkEdge		=TxBdSourceClkHold[2]&!TxBdSourceClkHold[3];	
assign									IData_o[11:0]			=i_buff[11:0];
assign									QData_o[11:0]			=q_buff[11:0];

/**********************************************************************************
										
**********************************************************************************/
always @(posedge ad_data_clk)
begin
	TxBdSourceClkHold[3:0]<={TxBdSourceClkHold[2:0],TxBsSource};
	if(TxBdSourceClkEdge)begin
		TxBd_o<=TxBdSource;
		end
end
MUL8_32	MUL8_32_inst (
	.dataa ( 							CFGADSourceCarrierTime+1),
	.datab ( 							CFGADSourcePcmFreq),
	.result ( 							CFGPcmFreqPSK_i ));	

IQModemNCO IQModemNCOPSK_N(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqPSK_i[31:0]),   	 			
	.freq_mod_i(						32'h00000000),  		 			
	.phase_mod_i(						16'h8000), 
	.fsin_o(								FSinPSK_N_o),      			
	.fcos_o(								),      			
	.out_valid(							));

IQModemNCO IQModemNCOPSK_P(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqPSK_i[31:0]),   	 			
	.freq_mod_i(						32'h00000000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinPSK_P_o),      			
	.fcos_o(								),      			
	.out_valid(							));		
	
//MUL32_Para	MULPara (
//	.dataa ( 							FSinPSK_o ),
//	.datab ( 							16'd1573 ),//16'd393 ),
//	.result ( 							FModTx_i));	
										
IQModemNCO_PCM IQModemNCOTx (
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							32'h00000000),   	 			
	.freq_mod_i(						FModTx_i),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinTx_o),      			
	.fcos_o(								FCosTx_o),      			
	.out_valid(							));
						
//gd_source GDTx(
//	.clk_sys(							ad_data_clk) ,	
//	.reset_n(							rst_n) ,
//	.pcm_nco_i(							CFGADSourcePcmFreq) ,
//	.bd_i(								GDBd_o) ,
//	.bs(									GDBs_o));
	
/**********************************************************************************
												FIFO
**********************************************************************************/	
//pcm_FIFO_out  pcm_FIFO_out_inst(
//	.rst_n(						rst_n),		//input
//	.clk(							ad_data_clk),		//input
//	.data_valid(				data_valid),	//input 有效信号表示
//	.data( 						data),			//input 从存储器中接收的72bit指令
//	.Fifo_rden_pcm(			Fifo_rden_pcm	), //input
//	.times(						times				),		//input
//	.Fifo_empty_pcm(			Fifo_empty_pcm	),	//output
//	.Fifo_q_pcm(				Fifo_q_pcm),		//output
//	.busy_out(					busy_out	)			//output 返回给存储器是否是空闲状态
//);
/**********************************************************************************
												输出PCM流
**********************************************************************************/	
pcm_nco_out  pcm_nco_out_inst(
	.clk(							ad_data_clk),		//input
	.rst_n(						rst_n),			//input
    .cfg_inst_length                (cfg_inst_length[7:0]       ), // (input )
	.mode_sel(					CFGADSourcePcmFreq),	//码率
    .tx_en                          (data_pcm_valid             ), // (input )
    .tx_data                        (data_pcm[511:0]              ), // (input )
	.word_out(								),		//output
	.ws(   							),				//output
	.bd(							pcm_reg_in),				//output
	.bs(							bs)		//output
);
//20200814
code_type_en code_type_en_inst(
	.clk_sys(					ad_data_clk),
	.pcm_type(					pcm_type),
	.bit_syn(					bs),
	.bd_in(						pcm_reg_in),
	.bd_out(						pcm_reg)
);




//bitsyner_new bitsyner_new_inst
//(
//	.clk_sys(				ad_data_clk),				//:INPUT;
//	.clk_samp(				1'b1),				//::INPUT;
//	.pcm_in(					{2'b00,pcm_reg}),		//:: INPUT;
//	.nco_f(					CFGADSourcePcmFreq),	//::input;
//	.code_bw(            2'b00),		//::input;
//	.pcm_type(				pcm_type),		//::input;
//	.demodem_mod(			4'h0), //::input;
//	.modem_m_s	(			1'h0),		//::input;
//	.jf_clr_f(				1'h0),				//::input;
//	.offset_8psk_f(      1'h0),		//::input;
//	.coef(					16'h0000),
//	.bs_50(							),					//::OUTPUT;
//	.bs(						GDBs_o),						//::OUTPUT;
//	.bd(						GDBd_o),						//::OUTPUT;
//	.bs_q(								),					//::OUTPUT;
//	.bd_q	(								),				//::OUTPUT;
//	.bit_lock(								),				//::OUTPUT;
//
//	.coef(										),			//::input;
//	.nco_fof(									),		//::output;
//	.nco_fo(											),		//::output;
//	.led(											),			//::output;
//	.nco_foa(									),		//::output;
//	.nco_fob(								),	//::output;
//	.nco_foc(								),		//::output;
//	.nco_fod(								)	//::output;
//);
/**********************************************************************************
												码型选择
**********************************************************************************/	
//bitsyner_new bitsyner_new_inst
//(
//	.clk_sys(                       ad_data_clk) ,	// input  clk_sys_sig
//	.clk_samp(                      1'b1) ,					// input  clk_samp_sig
//	.pcm_in(                        pcm_reg) ,				// input  pcm_in_sig
//	.nco_f(                         CFGADSourcePcmFreq) ,	// input [31:0] nco_f_sig
//	.pcm_type(                      pcm_type) ,				// input [3:0] pcm_type_sig
//	.update_n(                      1'b0) ,					// input  update_n_sig
//	.modem_mod(                     3'b000) ,					// input [2:0] modem_mod_sig
//	.bs(                            GDBs_o) ,		// output  bs_sig
//	.bd(                            GDBd_o) 			// output  bd_sig
//);

			
/**********************************************************************************
										加载/去载、加调/去调
**********************************************************************************/			
always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	carry_on								<=1'b0;
	modem_on								<=1'b0;
	end
else begin
	carry_on								<=CFGADSourceState1;
	modem_on								<=CFGADSourceState2;
//	carry_on								<=CFGADSourceState[5];
//	modem_on								<=CFGADSourceState[4];
// carry_on								<=1'b1;
//	modem_on								<=1'b0;
	end
end
									
always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	i_buff[11:0]						<=12'h000;	
	q_buff[11:0]						<=12'h000;
	end
else begin							
	if(carry_on)begin
		if(modem_on)begin
			i_buff[11:0]				<=FCosTx_o[15:4];	
			q_buff[11:0]				<=FSinTx_o[15:4];
			end
		else begin
			i_buff[11:0]				<=12'hA81;	
			q_buff[11:0]				<=12'hA81;
			end
		end
	else begin
		i_buff[11:0]					<=12'h000;	
		q_buff[11:0]					<=12'h000;
		end
	end	
end
endmodule
