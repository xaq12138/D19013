module			BFMPrj(
/********************  时钟  *****************************/
    input                           clk_sys                     , //系统时钟，62.5M
    input                           SysRst                      , 
    input                           DA_IF_DATACLK               , //9785时钟，62.5M
/********************  多音参数  *****************************/
input						CFGADSourceState1_DY,	//加载/去载
input						CFGADSourceState2_DY,	//加调/去调
input           [15:0]          cfg_offset_freq_dy,
/********************  多音数据  *****************************/
input						valid_DY,			//多音数据有效信号
input		[127:0]		DY_data_DY,			//多音数据
/********************  副载波参数  *****************************/
input						CFGADSourceState1,				//加载/去载
input						CFGADSourceState2,   			//加调/去调
input		[7:0]			CFGADSourceCarrierTime,	 		//倍数
input		[31:0]		CFGADSourceCarrierFreqShift,	//频偏
input		[31:0]		CFGADSourcePcmFreq,				//码率
input		[3:0]			pcm_type,							//码型
    input                     [7:0] cfg_inst_length             , 
/********************  副载波数据  *****************************/
input     		[511:0]					data_pcm,				//8bit指令数据           [7:0]		
input										data_pcm_valid,       //fifo写入数据请求           		
/********************  调制体制  *****************************/
input						IQModem_type,			//调制体制选择

/********************  DA9785_SPI  *****************************/
output					da_reset,			//9785寄存器配置
output					da_spi_sdio,		//9785寄存器配置
output					da_spi_sclk,		//9785寄存器配置
output					da_spi_csb,			//9785寄存器配置
output					DA_IF_TXEN,			//9785寄存器配置
/********************   tiaozhi DATA  *****************************/
output	[11:0]		ad_si_data,		//输出到9785的数据
output	[11:0]		ad_sq_data,		//输出到9785的数据
/********************  多音空闲状态  *****************************/
output					empty_o_DY,	 //多音空闲状态指示，0表示空闲，1表示忙绿
output	[1:0]			led
		
);

/**********************************************************************************
												local wire	
**********************************************************************************/
wire	[7:0]				CFGADCtr_o;

wire	[31:0]			CFGADSourceCarrierFreq,CFGADSourceState;
wire	[31:0]			CFGADRecState,CFGADRecCarrierFreq,CFGADRecFrameCodeH,CFGADRecFrameCodeL,CFGADRecPcmFreq,CFGIQDataFSoundAvePara,CFGADSoundState;
wire	[15:0]			CFGADRecFrameCodeLen,CFGADRecFrameLen;
wire	[3:0]				CFGADRecCodeMode;
wire	[2:0]				CFGADMode;
wire						CFGADUpOver;				

wire						ad_data_clk;
wire	[2:0]				LED_o;
wire	[7:0]				ADRxByte_o;
wire						ADRxByteEn_o,ADRxFrameLock,ADRxFrameOver;

reg	[11:0]			IData_o_buff;
reg	[11:0]			QData_o_buff;

wire	[15:0]			ad_FSinPSK_o_buff;
wire	[15:0]			ad_FCosPSK_o_buff;

wire 	[11:0]			IData_DY,QData_DY;
wire	[11:0]			IData_pcm,QData_pcm;


wire                                CFGADSourceState1_DY_sync   ; //加载/去载
wire                                CFGADSourceState2_DY_sync   ; //加调/去调
wire                         [15:0] cfg_offset_freq_dy_sync     ; 

wire                                valid_DY_sync               ; //多音数据有效信号
wire                        [127:0] DY_data_DY_sync             ; //多音数据

wire                                CFGADSourceState1_sync      ; //加载/去载
wire                                CFGADSourceState2_sync      ; //加调/去调
wire                          [7:0] CFGADSourceCarrierTime_sync ; //倍数
wire                         [31:0] CFGADSourceCarrierFreqShift_sync; //频偏
wire                         [31:0] CFGADSourcePcmFreq_sync     ; //码率
wire                          [3:0] pcm_type_sync               ; //码型

wire                                IQModem_type_sync           ; 

wire                        [511:0] data_pcm_sync               ; //8bit指令数据           [7:0]		
wire                                data_pcm_valid_sync         ; //fifo写入数据请求           			

wire                          [7:0] cfg_inst_length_sync        ; 

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (1                          ), 
    .INT_VALUE                      (0                          )  
)
u0_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceState1_DY       ), // (input )
    .dat_out                        (CFGADSourceState1_DY_sync  )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (1                          ), 
    .INT_VALUE                      (0                          )  
)
u1_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceState2_DY       ), // (input )
    .dat_out                        (CFGADSourceState2_DY_sync  )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (8                          ), 
    .INT_VALUE                      (0                          )  
)
u2_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceCarrierTime     ), // (input )
    .dat_out                        (CFGADSourceCarrierTime_sync)  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (32                         ), 
    .INT_VALUE                      (0                          )  
)
u3_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceCarrierFreqShift), // (input )
    .dat_out                        (CFGADSourceCarrierFreqShift_sync)  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (32                         ), 
    .INT_VALUE                      (0                          )  
)
u4_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourcePcmFreq         ), // (input )
    .dat_out                        (CFGADSourcePcmFreq_sync    )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (4                          ), 
    .INT_VALUE                      (0                          )  
)
u5_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (pcm_type                   ), // (input )
    .dat_out                        (pcm_type_sync              )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (1                          ), 
    .INT_VALUE                      (0                          )  
)
u6_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (IQModem_type               ), // (input )
    .dat_out                        (IQModem_type_sync          )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (1                          ), 
    .INT_VALUE                      (0                          )  
)
u7_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceState1          ), // (input )
    .dat_out                        (CFGADSourceState1_sync     )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (1                          ), 
    .INT_VALUE                      (0                          )  
)
u8_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (CFGADSourceState2          ), // (input )
    .dat_out                        (CFGADSourceState2_sync     )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (16                         ), 
    .INT_VALUE                      (0                          )  
)
u9_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (cfg_offset_freq_dy         ), // (input )
    .dat_out                        (cfg_offset_freq_dy_sync    )  // (output)
);

cb_sync #
(
    .U_DLY                          (1                          ), 
    .WIDTH                          (16                         ), 
    .INT_VALUE                      (0                          )  
)
u10_cb_sync
(
//-----------------------------------------------------------------------------------
// Global Signals 
//-----------------------------------------------------------------------------------    
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (!SysRst                    ), // (input )
//-----------------------------------------------------------------------------------
// Cross clock domain Signals 
//-----------------------------------------------------------------------------------    
    .dat_in                         (cfg_inst_length[7:0]       ), // (input )
    .dat_out                        (cfg_inst_length_sync[7:0]  )  // (output)
);

cb_cross_bus #
(
    .U_DLY                          (1                          ), 
    .DAT_WIDTH                      (128                        )  
)
u0_cb_cross_bus
( 
//-----------------------------------------------------------------------------------
// Global Sinals 
//-----------------------------------------------------------------------------------     
    .rst_n                          (!SysRst                    ), // (input ) Reset, Active low  
    .clk_src                        (clk_sys                    ), // (input ) Reference clock of source clock region 
    .clk_dest                       (clk_sys_data               ), // (input ) Reference clock of destination clock region 
//-----------------------------------------------------------------------------------
// Input data & strobe @ source clock region
//-----------------------------------------------------------------------------------
    .dat_src_strb                   (valid_DY                   ), // Input bus change/enable strobe, one clock pulse
    .dat_src                        (DY_data_DY                 ), // Input bus from source clock region
//-----------------------------------------------------------------------------------
// Output data @ destination clock region
//-----------------------------------------------------------------------------------
    .dat_dest_strb                  (valid_DY_sync              ), // Output bus change/enable strobe, one clock pulse
    .dat_dest                       (DY_data_DY_sync            )  // Output bus   
);

cb_cross_bus #
(
    .U_DLY                          (1                          ), 
    .DAT_WIDTH                      (512                        )  
)
u1_cb_cross_bus
( 
//-----------------------------------------------------------------------------------
// Global Sinals 
//-----------------------------------------------------------------------------------     
    .rst_n                          (!SysRst                    ), // (input ) Reset, Active low  
    .clk_src                        (clk_sys                    ), // (input ) Reference clock of source clock region 
    .clk_dest                       (clk_sys_data               ), // (input ) Reference clock of destination clock region 
//-----------------------------------------------------------------------------------
// Input data & strobe @ source clock region
//-----------------------------------------------------------------------------------
    .dat_src_strb                   (data_pcm_valid             ), // Input bus change/enable strobe, one clock pulse
    .dat_src                        (data_pcm[511:0]            ), // Input bus from source clock region
//-----------------------------------------------------------------------------------
// Output data @ destination clock region
//-----------------------------------------------------------------------------------
    .dat_dest_strb                  (data_pcm_valid_sync        ), // Output bus change/enable strobe, one clock pulse
    .dat_dest                       (data_pcm_sync[511:0]       )  // Output bus   
);

/**********************************************************************************
												assign	
**********************************************************************************/	
//assign					ad_data_clk											=ad_data_clk_p;
assign					led[0]												=LED_o[0];
assign					led[1]												=LED_o[0];//LED_o[0];
assign					ad_fb_clk_n											=1'b0;			
assign					ad_tx_frame_n										=1'b0;
assign					ad_txnrx												=1'b1;			//high:TX ,low:RX
assign					ad_en_agc											=1'b1;
assign					ad_enable											=1'b1;			//high:fdd ,low:tdd
assign					ad_test_en											=1'b0;
assign					ad_si_data[11:0]									=IData_o_buff[11:0];
assign					ad_sq_data[11:0]									=QData_o_buff[11:0];
//assign					ad_sa_data[11:0]									=ad_FSinPSK_o_buff[11:0];
//assign					ad_sb_data[11:0]									=ad_FCosPSK_o_buff[11:0];


////assign					ad_sa_data[11:0]											=IData_o_buff[11:0];
////assign					ad_sb_data[11:0]											=QData_o_buff[11:0];
//assign					ad_si_data[11:0]									   	=ad_FSinPSK_o_buff[11:0];
//assign					ad_sq_data[11:0]											=ad_FCosPSK_o_buff[11:0];		
assign					DA_IF_TXEN											=1'b1;
/**********************************************************************************
												rst_gen
**********************************************************************************/	
//SysRstMod RSTM(
//	.clk(										clk_sys_in),
//	.rst(										~PLLLocked),
//	.SysRst(									SysRst));
//	
/**********************************************************************************
												MyPLL
**********************************************************************************/	
//MyPLL PLL(
//	.refclk(									clk_sys_in),
//	.rst(										1'b0),
//	.outclk_0(								clk_sys),
//	.locked(									PLLLocked));
//	
DAPLL PLL_DA(
	.refclk(									DA_IF_DATACLK),
	.rst(										1'b0),
	.outclk_0(								clk_sys_data),
	.locked(									));
/**********************************************************************************
												SoundPLL
**********************************************************************************/	
//MyPLL SoundPLL(
//	.refclk(									ad_data_clk_p),
//	.rst(										1'b0),
//	.outclk_0(								Sound_clk_2M),
//	.locked(									));

/**********************************************************************************
												LEDDrive
**********************************************************************************/	
LEDDrive LEDDriveTest
(
	.clk(										clk_sys),	
	.led(										LED_o) 
);

always@(posedge clk_sys_data )
begin
if(IQModem_type_sync)begin
	IData_o_buff								<=IData_pcm;
	QData_o_buff								<=QData_pcm;
	end
else begin
	IData_o_buff								<=IData_DY;
	QData_o_buff								<=QData_DY;
	end
end
/**********************************************************************************
												McuUartTop
**********************************************************************************/	
//McuUartTop McuUart(
//	.clk(										clk_sys) ,	
//	.rst_n(									~SysRst) ,
//	.CFGADRst_n(							ad_rst_n) ,	
//	.CFGADSpiClk_o(						ad_spi_clk) ,	
//	.CFGADSpiDi_i(							ad_spi_di) ,	
//	.CFGADSpiDo_o(							ad_spi_do) ,	
//	.CFGADSpiLe_o(							ad_spi_enb) ,	
//	.CFGADUartRxd(							pcm_in_rs422) ,	
//	.CFGADUartTxd(							pcm_out_rs422) ,	
//	.CFGADCtr_o(							CFGADCtr_o) ,
//	
//	.CFGADSourcePcmFreq(					CFGADSourcePcmFreq) ,
//	.CFGADSourceCarrierFreqShift(		CFGADSourceCarrierFreqShift) ,	
//	.CFGADSourceCarrierFreq(			CFGADSourceCarrierFreq) ,	
//	.CFGADSourceState(					CFGADSourceState) ,
//	.CFGADRecState(						CFGADRecState) ,	
//	.CFGADRecCarrierFreq(				CFGADRecCarrierFreq) ,	
//	.CFGADRecFrameCodeH(					CFGADRecFrameCodeH) ,
//	.CFGADRecFrameCodeL(					CFGADRecFrameCodeL) ,
//	.CFGADRecFrameCodeLen(				CFGADRecFrameCodeLen) ,	
//	.CFGADRecCodeMode(					CFGADRecCodeMode),
//	.CFGADRecFrameLen(					CFGADRecFrameLen) ,	
//	.CFGADRecPcmFreq(						CFGADRecPcmFreq) ,	
//	.CFGADMode(								CFGADMode) ,	
//	.CFGADUpOver(							CFGADUpOver));		

/**********************************************************************************
												IQModem
**********************************************************************************/			
IQModem IQModemFM(
	.ad_data_clk(							clk_sys_data),//input
	.rst_n(									~SysRst) ,    //input
	.CFGADSourceState1(					CFGADSourceState1_sync			),//input
	.CFGADSourceState2(					CFGADSourceState2_sync			),//input
	.CFGADSourcePcmFreq(					CFGADSourcePcmFreq_sync) ,			//input
	.CFGADSourceCarrierFreqShift(		CFGADSourceCarrierFreqShift_sync			) ,//input
	.CFGADSourceCarrierTime(			CFGADSourceCarrierTime_sync),		//input
	.pcm_type(								pcm_type_sync),					//input
    .cfg_inst_length                (cfg_inst_length_sync[7:0]  ), // (input )
    .data_pcm                       (data_pcm_sync[511:0]       ), // (input )8bit指令数据           [7:0]		
    .data_pcm_valid                 (data_pcm_valid_sync             ), // (input )fifo写入数据请求           			

	.IData_o(		              		IData_pcm),//output
	.QData_o(								QData_pcm));//output

//iqmodem_pcm #
//(
//    .U_DLY                          (1                          )  
//)
//u_iqmodem_pcm
//(
//// ----------------------------------------------------------------------------
//// Clock & Reset
//// ----------------------------------------------------------------------------
//    .clk_sys                        (clk_sys_data               ), // (input )
//    .rst_n                          (~SysRst                    ), // (input )
//// ----------------------------------------------------------------------------
//// Config
//// ----------------------------------------------------------------------------
//    .cfg_pcm_bitrate                (CFGADSourcePcmFreq_sync[31:0]), // (input ) PCM码率
//    .cfg_pcm_fbias                  (CFGADSourceCarrierFreqShift_sync[31:0]), // (input ) PCM频偏
//    .cfg_pcm_multsubc               (CFGADSourceCarrierTime_sync[7:0]), // (input ) 副载波倍数
//    .cfg_pcm_codesel                (pcm_type_sync[3:0]         ), // (input ) 码型选择
//    .cfg_pcm_load_en                (CFGADSourceState1_sync     ), // (input ) 加载使能
//    .cfg_pcm_keyer_en               (CFGADSourceState2_sync     ), // (input ) 加调使能
//    .cfg_inst_length                (cfg_inst_length_sync[7:0]  ), // (input )
//// ----------------------------------------------------------------------------
//// Instruction Data
//// ----------------------------------------------------------------------------
//    .inst_data                      (data_pcm_sync[511:0]       ), // (input )
//    .inst_data_valid                (data_pcm_valid_sync        ), // (input )
//// ----------------------------------------------------------------------------
//// IQ Data
//// ----------------------------------------------------------------------------
//    .pcm_idata                      (IData_pcm[11:0]            ), // (output)
//    .pcm_qdata                      (QData_pcm[11:0]            )  // (output)
//);

/**********************************************************************************
												IQModem_DY
**********************************************************************************/			
//IQModem_DY IQModemFM_DY(
//	.ad_data_clk(							clk_sys_data) ,//input
//	.rst_n(									~SysRst) ,		//input
//	.CFGADSourceState1_DY(				CFGADSourceState1_DY_sync			),		//input
//	.CFGADSourceState2_DY(				CFGADSourceState2_DY_sync			),		//input
//    .cfg_offset_freq_dy             (cfg_offset_freq_dy_sync[15:0]   ), // (input )
//    .DY_data(								DY_data_DY_sync),					//input
//	.valid(									valid_DY_sync),						//input
////	.DY_data(								128'h0001f000f000f000f000f000f000f000),					//input
////	.valid(									1'b1),						//input
//	.empty_o(								empty_o_DY),						//output
//	.i_buff_a(								IData_DY),		//output
//	.q_buff_b(								QData_DY)		//output
//	);

iqmodem_dy #
(
    .U_DLY                          (1                          )  
)
u_iqmodem_dy
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys_data               ), // (input )
    .rst_n                          (~SysRst                    ), // (input )
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    .cfg_dy_load_en                 (CFGADSourceState2_DY_sync  ), // (input )
    .cfg_dy_keyer_en                (CFGADSourceState1_DY_sync  ), // (input )
    .cfg_dy_fbias                   (cfg_offset_freq_dy_sync[15:0]), // (input )
// ----------------------------------------------------------------------------
// DY Instruct Data
// ----------------------------------------------------------------------------
    .dy_tx_en                       (valid_DY_sync              ), // (input )
    .dy_tx_data                     (DY_data_DY_sync[127:0]     ), // (input )
// ----------------------------------------------------------------------------
// DAC data
// ----------------------------------------------------------------------------
    .dy_idata                       (IData_DY[11:0]             ), // (output)
    .dy_qdata                       (QData_DY[11:0]             )  // (output)
);



/**********************************************************************************
												9785_SPI
**********************************************************************************/	
	
wr_da9785 wr_da9785_inst(
	.clk(clk_sys),
	.wren(1'b0),
	.da_reset(da_reset),
	.da_sdio(da_spi_sdio),
	.da_sclk(da_spi_sclk),
	.da_le(da_spi_csb)
);

endmodule
