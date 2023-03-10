module IQModem_DY	(			
input 									ad_data_clk,
input										rst_n,
/************参数配置**********************************************************************/
input										CFGADSourceState1_DY,			//加载/去载  [31:0]	
input										CFGADSourceState2_DY,			 //加调/去调		
input           [15:0]          cfg_offset_freq_dy,
//input			[31:0]				CFGADSourcePcmFreq,
//input			[31:0]				CFGADSourceCarrierFreqShift,
//input			[3:0]					CFGADSourceCarrierTime,
//input			[31:0]				CFGADSoundState,    //判断多音方式
/************指令数据**********************************************************************/ 	
input				[127:0]				DY_data,
input										Fifo_ween_DY,
input										valid,
/************输出数据**********************************************************************/                                      			
//output			[11:0]				da_iq_out,
//output									ad_fb_clk,	
//output									ad_tx_fram,
//output			[15:0]            ad_FSinPSK_o,
//output			[15:0]            ad_FCosPSK_o,
output									empty_o,

    output      reg              [7:0] tx_cnt                      , 
output			[11:0]            i_buff_a,  //输出给AD9785的数据   [15:0]
output			[11:0]            q_buff_b	  //输出给AD9785的数据   [15:0]
); 
/**********************************************************************************
												local wire	
**********************************************************************************/
wire				[15:0]				PModPSK_i;
reg				[17:0]				FSinPSK_o;
wire				[31:0]				FModTx_i;
wire				[15:0]				FSinTx_o,FCosTx_o;
reg				[11:0]				i_buff,q_buff;
reg										carry_on,modem_on;
wire				[35:0]				CFGPcmFreqPSK_i;
wire				[11:0]				ADRxIQTheta,ADRxIQDelteThetaS_o;
wire				[1:0]					GDBdBuf;
wire										GDBdDiff_o;
//wire				[15:0]            FSinSound[15:0];
//wire				[17:0]            FSinExSound[15:0];
wire				[15:0]				FSinSound0_o,FSinSound1_o,FSinSound2_o,FSinSound3_o,
											FSinSound4_o,FSinSound5_o,FSinSound6_o,FSinSound7_o,
											FSinSound8_o,FSinSound9_o,FSinSound10_o,FSinSound11_o,
											FSinSound12_o,FSinSound13_o,FSinSound14_o,FSinSound15_o;
//wire				[15:0]				FSinSound4_o,FSinSound5_o,FSinSound6_o,FSinSound7_o;
//wire				[15:0]				FSinSound8_o,FSinSound9_o,FSinSound10_o,FSinSound11_o;
//wire				[15:0]				FSinSound12_o,FSinSound13_o,FSinSound14_o,FSinSound15_o;
wire				[17:0]				FSinExSound0_o,FSinExSound1_o,FSinExSound2_o,FSinExSound3_o,
											FSinExSound4_o,FSinExSound5_o,FSinExSound6_o,FSinExSound7_o,
											FSinExSound8_o,FSinExSound9_o,FSinExSound10_o,FSinExSound11_o,
											FSinExSound12_o,FSinExSound13_o,FSinExSound14_o,FSinExSound15_o;

reg				[31:0]				CFGPcmFreqSound0_i,CFGPcmFreqSound1_i,CFGPcmFreqSound2_i,CFGPcmFreqSound3_i,
											CFGPcmFreqSound4_i,CFGPcmFreqSound5_i,CFGPcmFreqSound6_i,CFGPcmFreqSound7_i,
											CFGPcmFreqSound8_i,CFGPcmFreqSound9_i,CFGPcmFreqSound10_i,CFGPcmFreqSound11_i,
											CFGPcmFreqSound12_i,CFGPcmFreqSound13_i,CFGPcmFreqSound14_i,CFGPcmFreqSound15_i;
											
reg				[31:0]				CFGPcmFreqSound0_0,CFGPcmFreqSound1_0,CFGPcmFreqSound2_0,CFGPcmFreqSound3_0,
											CFGPcmFreqSound4_0,CFGPcmFreqSound5_0,CFGPcmFreqSound6_0,CFGPcmFreqSound7_0,
											CFGPcmFreqSound8_0,CFGPcmFreqSound9_0,CFGPcmFreqSound10_0,CFGPcmFreqSound11_0,
											CFGPcmFreqSound12_0,CFGPcmFreqSound13_0,CFGPcmFreqSound14_0,CFGPcmFreqSound15_0;
											
reg				[31:0]				CFGPcmFreqSound0_1,CFGPcmFreqSound1_1,CFGPcmFreqSound2_1,CFGPcmFreqSound3_1,
											CFGPcmFreqSound4_1,CFGPcmFreqSound5_1,CFGPcmFreqSound6_1,CFGPcmFreqSound7_1,
											CFGPcmFreqSound8_1,CFGPcmFreqSound9_1,CFGPcmFreqSound10_1,CFGPcmFreqSound11_1,
											CFGPcmFreqSound12_1,CFGPcmFreqSound13_1,CFGPcmFreqSound14_1,CFGPcmFreqSound15_1;
											
reg				[31:0]				CFGPcmFreqSound0_2,CFGPcmFreqSound1_2,CFGPcmFreqSound2_2,CFGPcmFreqSound3_2,
											CFGPcmFreqSound4_2,CFGPcmFreqSound5_2,CFGPcmFreqSound6_2,CFGPcmFreqSound7_2,
											CFGPcmFreqSound8_2,CFGPcmFreqSound9_2,CFGPcmFreqSound10_2,CFGPcmFreqSound11_2,
											CFGPcmFreqSound12_2,CFGPcmFreqSound13_2,CFGPcmFreqSound14_2,CFGPcmFreqSound15_2;	
											
reg				[31:0]				CFGPcmFreqSound0_3,CFGPcmFreqSound1_3,CFGPcmFreqSound2_3,CFGPcmFreqSound3_3,
											CFGPcmFreqSound4_3,CFGPcmFreqSound5_3,CFGPcmFreqSound6_3,CFGPcmFreqSound7_3,
											CFGPcmFreqSound8_3,CFGPcmFreqSound9_3,CFGPcmFreqSound10_3,CFGPcmFreqSound11_3,
											CFGPcmFreqSound12_3,CFGPcmFreqSound13_3,CFGPcmFreqSound14_3,CFGPcmFreqSound15_3;
											
reg				[31:0]				CFGPcmFreqSound0_4,CFGPcmFreqSound1_4,CFGPcmFreqSound2_4,CFGPcmFreqSound3_4,
											CFGPcmFreqSound4_4,CFGPcmFreqSound5_4,CFGPcmFreqSound6_4,CFGPcmFreqSound7_4,
											CFGPcmFreqSound8_4,CFGPcmFreqSound9_4,CFGPcmFreqSound10_4,CFGPcmFreqSound11_4,
											CFGPcmFreqSound12_4,CFGPcmFreqSound13_4,CFGPcmFreqSound14_4,CFGPcmFreqSound15_4;
											
reg				[31:0]				CFGPcmFreqSound0_5,CFGPcmFreqSound1_5,CFGPcmFreqSound2_5,CFGPcmFreqSound3_5,
											CFGPcmFreqSound4_5,CFGPcmFreqSound5_5,CFGPcmFreqSound6_5,CFGPcmFreqSound7_5,
											CFGPcmFreqSound8_5,CFGPcmFreqSound9_5,CFGPcmFreqSound10_5,CFGPcmFreqSound11_5,
											CFGPcmFreqSound12_5,CFGPcmFreqSound13_5,CFGPcmFreqSound14_5,CFGPcmFreqSound15_5;
											
reg				[31:0]				CFGPcmFreqSound0_6,CFGPcmFreqSound1_6,CFGPcmFreqSound2_6,CFGPcmFreqSound3_6,
											CFGPcmFreqSound4_6,CFGPcmFreqSound5_6,CFGPcmFreqSound6_6,CFGPcmFreqSound7_6,
											CFGPcmFreqSound8_6,CFGPcmFreqSound9_6,CFGPcmFreqSound10_6,CFGPcmFreqSound11_6,
											CFGPcmFreqSound12_6,CFGPcmFreqSound13_6,CFGPcmFreqSound14_6,CFGPcmFreqSound15_6;
											
reg				[31:0]				CFGPcmFreqSound0_7,CFGPcmFreqSound1_7,CFGPcmFreqSound2_7,CFGPcmFreqSound3_7,
											CFGPcmFreqSound4_7,CFGPcmFreqSound5_7,CFGPcmFreqSound6_7,CFGPcmFreqSound7_7,
											CFGPcmFreqSound8_7,CFGPcmFreqSound9_7,CFGPcmFreqSound10_7,CFGPcmFreqSound11_7,
											CFGPcmFreqSound12_7,CFGPcmFreqSound13_7,CFGPcmFreqSound14_7,CFGPcmFreqSound15_7;											
											
reg				[31:0]            count;
reg				[3:0]             state; 
reg				[7:0]					data_cnt;
reg										RFStateFlag;

reg										Fifo_rden_DY;
//wire										Fifo_			_DY;

reg				[3:0]					cnt;
//wire											valid;
wire				[15:0]				data;
reg				[127:0]				pcm_data;
reg                                 start                       ; 

reg										empty;

wire				[17:0]					test1,test2;
reg				[17:0]					YWZ1,YWZ2,YWZ3;
/**********************************************************************************
												assign	
**********************************************************************************/	
wire										GDBd_o;

wire			[15:0]					DYPP;

//localparam								pcm_data		 =128'h0001F000F000F000F000F000F000F000;
localparam								delay_10ms   =32'd625000;         //10ms,62.5Mclk
localparam								delay_100ms  =32'd6250000;        //100ms,62.5Mclk
localparam								delay_5ms    =32'd312500;			//5ms,62.5Mclk

assign									ad_fb_clk				=ad_data_clk;
assign									ad_tx_fram				=ad_data_clk;
assign									PModPSK_i				=GDBd_o?					16'h8000	:16'h0000;
//assign									PModPSK_i				=GDBdDiff_o?			16'h8000	:16'h0000;
//assign									FModTx_i					=FSinPSK_o[15]?		CFGADSourceCarrierFreqShift	:~CFGADSourceCarrierFreqShift;		
//assign									CFGPcmFreqPSK_i		=CFGADSourcePcmFreq	<<2;
//assign									FSinPSK_o				=FSinSound0_o;//+FSinSound1_o+FSinSound2_o;

assign									FSinExSound0_o			={FSinSound0_o[15],FSinSound0_o[15],FSinSound0_o[15:0]};
assign									FSinExSound1_o			={FSinSound1_o[15],FSinSound1_o[15],FSinSound1_o[15:0]};
assign									FSinExSound2_o			={FSinSound2_o[15],FSinSound2_o[15],FSinSound2_o[15:0]};
assign									FSinExSound3_o			={FSinSound3_o[15],FSinSound3_o[15],FSinSound3_o[15:0]};
assign									FSinExSound4_o			={FSinSound4_o[15],FSinSound4_o[15],FSinSound4_o[15:0]};
assign									FSinExSound5_o			={FSinSound5_o[15],FSinSound5_o[15],FSinSound5_o[15:0]};
assign									FSinExSound6_o			={FSinSound6_o[15],FSinSound6_o[15],FSinSound6_o[15:0]};
assign									FSinExSound7_o			={FSinSound7_o[15],FSinSound7_o[15],FSinSound7_o[15:0]};
assign									FSinExSound8_o			={FSinSound8_o[15],FSinSound8_o[15],FSinSound8_o[15:0]};
assign									FSinExSound9_o			={FSinSound9_o[15],FSinSound9_o[15],FSinSound9_o[15:0]};
assign									FSinExSound10_o		={FSinSound10_o[15],FSinSound10_o[15],FSinSound10_o[15:0]};
assign									FSinExSound11_o		={FSinSound11_o[15],FSinSound11_o[15],FSinSound11_o[15:0]};
assign									FSinExSound12_o		={FSinSound12_o[15],FSinSound12_o[15],FSinSound12_o[15:0]};
assign									FSinExSound13_o		={FSinSound13_o[15],FSinSound13_o[15],FSinSound13_o[15:0]};
assign									FSinExSound14_o		={FSinSound14_o[15],FSinSound14_o[15],FSinSound14_o[15:0]};
assign									FSinExSound15_o		={FSinSound15_o[15],FSinSound15_o[15],FSinSound15_o[15:0]};

//assign									ad_FSinPSK_o			=FSinPSK_o[17:6];

//assign									ad_FSinPSK_o			=FSinTx_o[15:0];//=RFStateFlag?			FSinTx_o	:16'h0000;
//assign									ad_FCosPSK_o			=FCosTx_o[15:0];//=RFStateFlag?			FCosTx_o	:16'h0000;										
//assign									YWZ1						={test1[15],test1[15],test1[15:0]};
//assign									YWZ2						={test2[15],test2[15],test2[15:0]};
//assign									YWZ3						=test2[15:0];

assign									i_buff_a					=i_buff[11:0];
assign									q_buff_b					=q_buff[11:0];
assign									empty_o					=empty;
//generate

//genvar i;
//for (i=0;i<16;i=i+1)begin:FSinEx
//	assign								FSinExSound[i]			={FSinSound[i][15],FSinSound[i][15],FSinSound[i]};
//end
//endgenerate

/**********************************************************************************
										
**********************************************************************************/
//MUL4_32	MUL4_32_inst (
//	.dataa ( 							CFGADSourceCarrierTime+1),
//	.datab ( 							CFGADSourcePcmFreq),
//	.result ( 							CFGPcmFreqPSK_i ));	
always@(posedge ad_data_clk )
begin
YWZ1						<={test1[15],test1[15],test1[15:0]};
YWZ2						<={test2[15],test2[15],test2[15:0]};
YWZ3						<=test2[15:0];
end
//always@(posedge ad_data_clk )
//	if(!Fifo_			_DY)begin
//		Fifo_rden_DY<=1'b1;
//		end
//	else begin
//		Fifo_rden_DY<=1'b0;
//		end

//FIFO_DY	FIFO_DY_inst (
//	.aclr ( 					rst_n ),
//	.clock (					ad_data_clk ),
//	.data ( 					DY_data ),   //input写入FIFO的数据
//	.rdreq (				   Fifo_rden_DY ), //input读操作请求信号
//	.wrreq (             Fifo_ween_DY ),   //input高电平时往FIFO中写数
//	.			 (          Fifo_			_DY ),  //output FIFO空标记信号，高电平时表示已空
//	.full (                 ),
//	.q (                 pcm_data ),   //output FIFO输出数据
//	.usedw (              )   //存储大小
//	);



always@(posedge ad_data_clk or negedge rst_n)
begin
	if(!rst_n)begin
		pcm_data			<=0;
	end
	else if(valid)begin
		pcm_data			<=DY_data;
		end
end

always@(posedge ad_data_clk or negedge rst_n)
begin
	if(!rst_n)
        start <= 1'b0;
    else
        begin
            if(valid)
                start <= 1'b1;
            else
                start <= 1'b0;
        end
end


//always@(posedge ad_data_clk or negedge rst_n)
//begin
//if(!rst_n)begin
//	cnt	           <=4'b0000;
//	pcm_data[127:0]  <=0;
//	end
//else if(cnt<8)begin
//     case(times)
//	  
//		if(valid)begin
//			pcm_data_buff[127:0] <={pcm_data_buff[111:0],data[15:0]};
//			cnt				 		<=cnt+1'b1;
//			times						<=times+1'b1;
//			end
//		else begin
//			cnt						<=cnt;
//			end
//		end
//	 else begin
//		cnt							<=4'b0000;
//		end
//end

NCODY testa(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							32'h000C_9539),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								test1),      			
	.fcos_o(								),      			
	.out_valid(							));
	
NCODY testb(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							32'h0000_0000),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								test2),      			
	.fcos_o(								),      			
	.out_valid(							));	
	
NCODY IQModemNCOSound0(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound0_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound0_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound1(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound1_i[31:0]),//32'h00D1_B717), 6.4k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound1_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound2(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound2_i[31:0]),//32'h00DE_D288), 6.8k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound2_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound3(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound3_i[31:0]),//32'h00EB_EDFA), 7.2k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound3_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound4(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound4_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound4_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound5(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound5_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound5_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound6(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound6_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound6_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound7(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound7_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound7_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound8(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound8_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound8_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound9(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound9_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound9_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound10(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound10_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound10_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound11(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound11_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound11_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound12(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound12_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound12_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound13(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound13_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound13_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound14(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound14_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound14_o),      			
	.fcos_o(								),      			
	.out_valid(							));
NCODY IQModemNCOSound15(				
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							CFGPcmFreqSound15_i[31:0]),//32'h00A7_C5AC), 5.12k---clk2M  	 			
	.freq_mod_i(						32'h0000_0000),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinSound15_o),      			
	.fcos_o(								),      			
	.out_valid(							));

//CONS_DY_shift   CONS_DY_shift_inst (
//    .result ( DYPP )
//    );

	
MUL32_DY	MULPara (
	.dataa ( 							FSinPSK_o[17:2] ),
//	.datab ( 							16'd1573 ),//CLK-2M//16'd393 ),--CLK--8M
//	.datab ( 							16'd39 ),//clk,80M  //频偏,是多少？
	.datab ( 							cfg_offset_freq_dy),//clk,62.5M  16'd25  DYPP
	.result ( 							FModTx_i)
);	
										
NCODY_DY IQModemNCOTx (
	.clk(									ad_data_clk),         			
	.reset_n(							rst_n),     		 				
	.clken(								1'b1),       	 					
	.phi_inc_i(							32'h00000000),   	 			
	.freq_mod_i(						FModTx_i),  		 			
	.phase_mod_i(						16'h0000), 
	.fsin_o(								FSinTx_o),      			
	.fcos_o(								FCosTx_o),      			
	.out_valid(							)
);
						
//32'h0005_97A7),0//CFGPcmFreqSound0_i[31:0]), 5.12k---clk60M 
//32'h0006_FD91),1//CFGPcmFreqSound0_i[31:0]), 6.40k---clk60M 
//32'h0007_6D6A),2//CFGPcmFreqSound0_i[31:0]), 6.80k---clk60M  
//32'h0007_DD44),3//CFGPcmFreqSound0_i[31:0]), 7.20k---clk60M 
//32'h0008_4D1D),4//CFGPcmFreqSound0_i[31:0]), 7.60k---clk60M
//32'h0008_BCF6),5//CFGPcmFreqSound0_i[31:0]), 8.00k---clk60M 
//32'h0009_2CCF),6//CFGPcmFreqSound0_i[31:0]), 8.40k---clk60M  
//32'h0009_9CA8),7//CFGPcmFreqSound0_i[31:0]), 8.80k---clk60M
//32'h000A_0C81),8//CFGPcmFreqSound0_i[31:0]), 9.20k---clk60M 
//32'h000A_7C5A),9//CFGPcmFreqSound0_i[31:0]), 9.60k---clk60M 
//32'h000A_EC33),10//CFGPcmFreqSound0_i[31:0]), 10.0k---clk60M 
//32'h000B_5C0C),11//CFGPcmFreqSound0_i[31:0]), 10.4k---clk60M 
//32'h000B_CBE6),12//CFGPcmFreqSound0_i[31:0]), 10.8k---clk60M 
//32'h000C_3BBF),13//CFGPcmFreqSound0_i[31:0]), 11.2k---clk60M
//32'h000C_AB98),14//CFGPcmFreqSound0_i[31:0]), 11.6k---clk60M
//32'h3333_3333),15//CFGPcmFreqSound0_i[31:0]), 12.0k---clk60M 

//32'h0005_5E63),0//CFGPcmFreqSound0_i[31:0]), 5.12k---clk62.5M 
//32'h0006_B5FC),1//CFGPcmFreqSound0_i[31:0]), 6.40k---clk62.5M 
//32'h0007_215C),2//CFGPcmFreqSound0_i[31:0]), 6.80k---clk62.5M  
//32'h0007_8CBC),3//CFGPcmFreqSound0_i[31:0]), 7.20k---clk62.5M  
//32'h0007_F81C),4//CFGPcmFreqSound0_i[31:0]), 7.60k---clk62.5M 
//32'h0008_637B),5//CFGPcmFreqSound0_i[31:0]), 8.00k---clk62.5M 
//32'h0008_CEDB),6//CFGPcmFreqSound0_i[31:0]), 8.40k---clk62.5M  
//32'h0009_3A3B),7//CFGPcmFreqSound0_i[31:0]), 8.80k---clk62.5M 
//32'h0009_A59B),8//CFGPcmFreqSound0_i[31:0]), 9.20k---clk62.5M  
//32'h000A_10FA),9//CFGPcmFreqSound0_i[31:0]), 9.60k---clk62.5M  
//32'h000A_7C5A),10//CFGPcmFreqSound0_i[31:0]), 10.0k---clk62.5M  
//32'h000A_E7BA),11//CFGPcmFreqSound0_i[31:0]), 10.4k---clk62.5M  
//32'h000B_531A),12//CFGPcmFreqSound0_i[31:0]), 10.8k---clk62.5M  
//32'h000B_BE7A),13//CFGPcmFreqSound0_i[31:0]), 11.2k---clk62.5M 
//32'h000C_29D9),14//CFGPcmFreqSound0_i[31:0]), 11.6k---clk62.5M 
//32'h000C_9539),15//CFGPcmFreqSound0_i[31:0]), 12.0k---clk62.5M 
/**********************************************************************************
												多音选择	
**********************************************************************************/
always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	CFGPcmFreqSound0_i					<=32'h0000_0000;
	CFGPcmFreqSound1_i					<=32'h0000_0000;
	CFGPcmFreqSound2_i					<=32'h0000_0000;
	CFGPcmFreqSound3_i					<=32'h0000_0000;
	CFGPcmFreqSound4_i					<=32'h0000_0000;
	CFGPcmFreqSound5_i	         	<=32'h0000_0000;
	CFGPcmFreqSound6_i	         	<=32'h0000_0000;
	CFGPcmFreqSound7_i            	<=32'h0000_0000;
	CFGPcmFreqSound8_i   				<=32'h0000_0000;
	CFGPcmFreqSound9_i            	<=32'h0000_0000;
	CFGPcmFreqSound10_i           	<=32'h0000_0000;
	CFGPcmFreqSound11_i           	<=32'h0000_0000;
	CFGPcmFreqSound12_i					<=32'h0000_0000;
	CFGPcmFreqSound13_i	         	<=32'h0000_0000;
	CFGPcmFreqSound14_i	         	<=32'h0000_0000;
	CFGPcmFreqSound15_i	         	<=32'h0000_0000;
	FSinPSK_o								<=18'h00000;	
	count										<=32'h0000_0000;
	state										<=4'b0000;
	RFStateFlag								<=1'b0;
	data_cnt									<=8'h00;
	empty										<=1'b0;
	CFGPcmFreqSound0_0					<=32'h0000_0000;
	CFGPcmFreqSound1_0             	<=32'h0000_0000;
	CFGPcmFreqSound2_0             	<=32'h0000_0000;
	CFGPcmFreqSound3_0              	<=32'h0000_0000;
	CFGPcmFreqSound4_0              	<=32'h0000_0000;
	CFGPcmFreqSound5_0              	<=32'h0000_0000;
	CFGPcmFreqSound6_0              	<=32'h0000_0000;
	CFGPcmFreqSound7_0              	<=32'h0000_0000;
	CFGPcmFreqSound8_0              	<=32'h0000_0000;
	CFGPcmFreqSound9_0					<=32'h0000_0000;
	CFGPcmFreqSound10_0             	<=32'h0000_0000;
	CFGPcmFreqSound11_0             	<=32'h0000_0000;
	CFGPcmFreqSound12_0             	<=32'h0000_0000;
	CFGPcmFreqSound13_0             	<=32'h0000_0000;
	CFGPcmFreqSound14_0            	<=32'h0000_0000;
	CFGPcmFreqSound15_0             	<=32'h0000_0000;
	CFGPcmFreqSound0_1					<=32'h0000_0000;
	CFGPcmFreqSound1_1             	<=32'h0000_0000;
	CFGPcmFreqSound2_1             	<=32'h0000_0000;
	CFGPcmFreqSound3_1              	<=32'h0000_0000;
	CFGPcmFreqSound4_1              	<=32'h0000_0000;
	CFGPcmFreqSound5_1              	<=32'h0000_0000;
	CFGPcmFreqSound6_1              	<=32'h0000_0000;
	CFGPcmFreqSound7_1              	<=32'h0000_0000;
	CFGPcmFreqSound8_1              	<=32'h0000_0000;
	CFGPcmFreqSound9_1					<=32'h0000_0000;
	CFGPcmFreqSound10_1             	<=32'h0000_0000;
	CFGPcmFreqSound11_1             	<=32'h0000_0000;
	CFGPcmFreqSound12_1             	<=32'h0000_0000;
	CFGPcmFreqSound13_1             	<=32'h0000_0000;
	CFGPcmFreqSound14_1            	<=32'h0000_0000;
	CFGPcmFreqSound15_1             	<=32'h0000_0000;
	CFGPcmFreqSound0_2					<=32'h0000_0000;
	CFGPcmFreqSound1_2             	<=32'h0000_0000;
	CFGPcmFreqSound2_2             	<=32'h0000_0000;
	CFGPcmFreqSound3_2              	<=32'h0000_0000;
	CFGPcmFreqSound4_2              	<=32'h0000_0000;
	CFGPcmFreqSound5_2              	<=32'h0000_0000;
	CFGPcmFreqSound6_2              	<=32'h0000_0000;
	CFGPcmFreqSound7_2              	<=32'h0000_0000;
	CFGPcmFreqSound8_2              	<=32'h0000_0000;
	CFGPcmFreqSound9_2					<=32'h0000_0000;
	CFGPcmFreqSound10_2             	<=32'h0000_0000;
	CFGPcmFreqSound11_2             	<=32'h0000_0000;
	CFGPcmFreqSound12_2             	<=32'h0000_0000;
	CFGPcmFreqSound13_2             	<=32'h0000_0000;
	CFGPcmFreqSound14_2            	<=32'h0000_0000;
	CFGPcmFreqSound15_2             	<=32'h0000_0000;
	CFGPcmFreqSound0_3					<=32'h0000_0000;
	CFGPcmFreqSound1_3             	<=32'h0000_0000;
	CFGPcmFreqSound2_3             	<=32'h0000_0000;
	CFGPcmFreqSound3_3              	<=32'h0000_0000;
	CFGPcmFreqSound4_3              	<=32'h0000_0000;
	CFGPcmFreqSound5_3              	<=32'h0000_0000;
	CFGPcmFreqSound6_3              	<=32'h0000_0000;
	CFGPcmFreqSound7_3              	<=32'h0000_0000;
	CFGPcmFreqSound8_3              	<=32'h0000_0000;
	CFGPcmFreqSound9_3					<=32'h0000_0000;
	CFGPcmFreqSound10_3             	<=32'h0000_0000;
	CFGPcmFreqSound11_3             	<=32'h0000_0000;
	CFGPcmFreqSound12_3             	<=32'h0000_0000;
	CFGPcmFreqSound13_3             	<=32'h0000_0000;
	CFGPcmFreqSound14_3            	<=32'h0000_0000;
	CFGPcmFreqSound15_3             	<=32'h0000_0000;
	CFGPcmFreqSound0_4					<=32'h0000_0000;
	CFGPcmFreqSound1_4             	<=32'h0000_0000;
	CFGPcmFreqSound2_4             	<=32'h0000_0000;
	CFGPcmFreqSound3_4              	<=32'h0000_0000;
	CFGPcmFreqSound4_4              	<=32'h0000_0000;
	CFGPcmFreqSound5_4              	<=32'h0000_0000;
	CFGPcmFreqSound6_4              	<=32'h0000_0000;
	CFGPcmFreqSound7_4              	<=32'h0000_0000;
	CFGPcmFreqSound8_4              	<=32'h0000_0000;
	CFGPcmFreqSound9_4					<=32'h0000_0000;
	CFGPcmFreqSound10_4             	<=32'h0000_0000;
	CFGPcmFreqSound11_4             	<=32'h0000_0000;
	CFGPcmFreqSound12_4             	<=32'h0000_0000;
	CFGPcmFreqSound13_4             	<=32'h0000_0000;
	CFGPcmFreqSound14_4            	<=32'h0000_0000;
	CFGPcmFreqSound15_4             	<=32'h0000_0000;
	CFGPcmFreqSound0_5					<=32'h0000_0000;
	CFGPcmFreqSound1_5             	<=32'h0000_0000;
	CFGPcmFreqSound2_5             	<=32'h0000_0000;
	CFGPcmFreqSound3_5              	<=32'h0000_0000;
	CFGPcmFreqSound4_5              	<=32'h0000_0000;
	CFGPcmFreqSound5_5              	<=32'h0000_0000;
	CFGPcmFreqSound6_5              	<=32'h0000_0000;
	CFGPcmFreqSound7_5              	<=32'h0000_0000;
	CFGPcmFreqSound8_5              	<=32'h0000_0000;
	CFGPcmFreqSound9_5					<=32'h0000_0000;
	CFGPcmFreqSound10_5             	<=32'h0000_0000;
	CFGPcmFreqSound11_5             	<=32'h0000_0000;
	CFGPcmFreqSound12_5             	<=32'h0000_0000;
	CFGPcmFreqSound13_5             	<=32'h0000_0000;
	CFGPcmFreqSound14_5            	<=32'h0000_0000;
	CFGPcmFreqSound15_5             	<=32'h0000_0000;
	CFGPcmFreqSound0_6					<=32'h0000_0000;
	CFGPcmFreqSound1_6             	<=32'h0000_0000;
	CFGPcmFreqSound2_6             	<=32'h0000_0000;
	CFGPcmFreqSound3_6              	<=32'h0000_0000;
	CFGPcmFreqSound4_6              	<=32'h0000_0000;
	CFGPcmFreqSound5_6              	<=32'h0000_0000;
	CFGPcmFreqSound6_6              	<=32'h0000_0000;
	CFGPcmFreqSound7_6              	<=32'h0000_0000;
	CFGPcmFreqSound8_6              	<=32'h0000_0000;
	CFGPcmFreqSound9_6					<=32'h0000_0000;
	CFGPcmFreqSound10_6             	<=32'h0000_0000;
	CFGPcmFreqSound11_6             	<=32'h0000_0000;
	CFGPcmFreqSound12_6             	<=32'h0000_0000;
	CFGPcmFreqSound13_6             	<=32'h0000_0000;
	CFGPcmFreqSound14_6            	<=32'h0000_0000;
	CFGPcmFreqSound15_6             	<=32'h0000_0000;
	CFGPcmFreqSound0_7					<=32'h0000_0000;
	CFGPcmFreqSound1_7             	<=32'h0000_0000;
	CFGPcmFreqSound2_7             	<=32'h0000_0000;
	CFGPcmFreqSound3_7              	<=32'h0000_0000;
	CFGPcmFreqSound4_7              	<=32'h0000_0000;
	CFGPcmFreqSound5_7              	<=32'h0000_0000;
	CFGPcmFreqSound6_7              	<=32'h0000_0000;
	CFGPcmFreqSound7_7              	<=32'h0000_0000;
	CFGPcmFreqSound8_7              	<=32'h0000_0000;
	CFGPcmFreqSound9_7					<=32'h0000_0000;
	CFGPcmFreqSound10_7             	<=32'h0000_0000;
	CFGPcmFreqSound11_7             	<=32'h0000_0000;
	CFGPcmFreqSound12_7             	<=32'h0000_0000;
	CFGPcmFreqSound13_7             	<=32'h0000_0000;
	CFGPcmFreqSound14_7            	<=32'h0000_0000;
	CFGPcmFreqSound15_7             	<=32'h0000_0000;
end
else begin
	case (data_cnt)
	8'h00:begin
    if(start)
        begin
	        if(pcm_data[127]==1)             //判断第15位_导音
		        CFGPcmFreqSound15_0				<=32'h000C_9539;//12.0k---clk60M
	        else
		        CFGPcmFreqSound15_0				<=32'h0000_0000;
            
		    data_cnt								<=data_cnt+1'b1;
		    empty												<=1'b1;
        end
    else
        ;
	end
	8'h01:begin
	if(pcm_data[126]==1)begin 				//判断第14位_导音
		CFGPcmFreqSound14_0				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h02:begin
	if(pcm_data[125]==1)begin 				//判断第13位_导音
		CFGPcmFreqSound13_0				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h03:begin
	if(pcm_data[124]==1)begin 				//判断第12位_导音
		CFGPcmFreqSound12_0				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h04:begin
	if(pcm_data[123]==1)begin 				//判断第11位_导音
		CFGPcmFreqSound11_0				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h05:begin
	if(pcm_data[122]==1)begin 				//判断第10位_导音
		CFGPcmFreqSound10_0				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h06:begin
	if(pcm_data[121]==1)begin 				//判断第9位_导音
		CFGPcmFreqSound9_0				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h07:begin
	if(pcm_data[120]==1)begin 				//判断第8位_导音
		CFGPcmFreqSound8_0				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h08:begin
	if(pcm_data[119]==1)begin 				//判断第7位_导音
		CFGPcmFreqSound7_0				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h09:begin
	if(pcm_data[118]==1)begin 				//判断第6位_导音
		CFGPcmFreqSound6_0				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0A:begin
	if(pcm_data[117]==1)begin 				//判断第5位_导音
		CFGPcmFreqSound5_0				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0B:begin
	if(pcm_data[116]==1)begin 				//判断第4位_导音
		CFGPcmFreqSound4_0				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0C:begin
	if(pcm_data[115]==1)begin 				//判断第3位_导音
		CFGPcmFreqSound3_0				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0D:begin
	if(pcm_data[114]==1)begin 				//判断第2位_导音
		CFGPcmFreqSound2_0				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0E:begin
	if(pcm_data[113]==1)begin 				//判断第1位_导音
		CFGPcmFreqSound1_0				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h0F:begin
	if(pcm_data[112]==1)begin 				//判断第0位_导音
		CFGPcmFreqSound0_0				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_0				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	
	8'h10:begin
	if(pcm_data[111]==1)begin             //判断第15位_码元1
		CFGPcmFreqSound15_1				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h11:begin
	if(pcm_data[110]==1)begin 				//判断第14位_码元1
		CFGPcmFreqSound14_1				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h12:begin
	if(pcm_data[109]==1)begin 				//判断第13位_码元1
		CFGPcmFreqSound13_1				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h13:begin
	if(pcm_data[108]==1)begin 				//判断第12位_码元1
		CFGPcmFreqSound12_1				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h14:begin
	if(pcm_data[107]==1)begin 				//判断第11位_码元1
		CFGPcmFreqSound11_1				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h15:begin
	if(pcm_data[106]==1)begin 				//判断第10位_码元1
		CFGPcmFreqSound10_1				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h16:begin
	if(pcm_data[105]==1)begin 				//判断第9位_码元1
		CFGPcmFreqSound9_1				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h17:begin
	if(pcm_data[104]==1)begin 				//判断第8位_码元1
		CFGPcmFreqSound8_1				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h18:begin
	if(pcm_data[103]==1)begin 				//判断第7位_码元1
		CFGPcmFreqSound7_1				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h19:begin
	if(pcm_data[102]==1)begin 				//判断第6位_码元1
		CFGPcmFreqSound6_1				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1A:begin
	if(pcm_data[101]==1)begin 				//判断第5位_码元1
		CFGPcmFreqSound5_1				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1B:begin
	if(pcm_data[100]==1)begin 				//判断第4位_码元1
		CFGPcmFreqSound4_1				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1C:begin
	if(pcm_data[99]==1)begin 				//判断第3位_码元1
		CFGPcmFreqSound3_1				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1D:begin
	if(pcm_data[98]==1)begin 				//判断第2位_码元1
		CFGPcmFreqSound2_1				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1E:begin
	if(pcm_data[97]==1)begin 				//判断第1位_码元1
		CFGPcmFreqSound1_1				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h1F:begin
	if(pcm_data[96]==1)begin 				//判断第0位_码元1
		CFGPcmFreqSound0_1				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_1				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h20:begin
	if(pcm_data[95]==1)begin             //判断第15位_码元2
		CFGPcmFreqSound15_2				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	end
	8'h21:begin
	if(pcm_data[94]==1)begin 				//判断第14位_码元2
		CFGPcmFreqSound14_2				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty												<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h22:begin
	if(pcm_data[93]==1)begin 				//判断第13位_码元2
		CFGPcmFreqSound13_2				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h23:begin
	if(pcm_data[92]==1)begin 				//判断第12位_码元2
		CFGPcmFreqSound12_2				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h24:begin
	if(pcm_data[91]==1)begin 				//判断第11位_码元2
		CFGPcmFreqSound11_2				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h25:begin
	if(pcm_data[90]==1)begin 				//判断第10位_码元2
		CFGPcmFreqSound10_2				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h26:begin
	if(pcm_data[89]==1)begin 				//判断第9位_码元2
		CFGPcmFreqSound9_2				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h27:begin
	if(pcm_data[88]==1)begin 				//判断第8位_码元2
		CFGPcmFreqSound8_2				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty										<=1'b1;
		end
	end
	8'h28:begin
	if(pcm_data[87]==1)begin 				//判断第7位_码元2
		CFGPcmFreqSound7_2				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h29:begin
	if(pcm_data[86]==1)begin 				//判断第6位_码元2
		CFGPcmFreqSound6_2				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2A:begin
	if(pcm_data[85]==1)begin 				//判断第5位_码元2
		CFGPcmFreqSound5_2				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2B:begin
	if(pcm_data[84]==1)begin 				//判断第4位_码元2
		CFGPcmFreqSound4_2				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2C:begin
	if(pcm_data[83]==1)begin 				//判断第3位_码元2
		CFGPcmFreqSound3_2				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2D:begin
	if(pcm_data[82]==1)begin 				//判断第2位_码元2
		CFGPcmFreqSound2_2				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2E:begin
	if(pcm_data[81]==1)begin 				//判断第1位_码元2
		CFGPcmFreqSound1_2				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h2F:begin
	if(pcm_data[80]==1)begin 				//判断第0位_码元2
		CFGPcmFreqSound0_2				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_2				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h30:begin
	if(pcm_data[79]==1)begin             //判断第15位_码元3
		CFGPcmFreqSound15_3				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h31:begin
	if(pcm_data[78]==1)begin 				//判断第14位_码元3
		CFGPcmFreqSound14_3				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h32:begin
	if(pcm_data[77]==1)begin 				//判断第13位_码元3
		CFGPcmFreqSound13_3				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h33:begin
	if(pcm_data[76]==1)begin 				//判断第12位_码元3
		CFGPcmFreqSound12_3				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h34:begin
	if(pcm_data[75]==1)begin 				//判断第11位_码元3
		CFGPcmFreqSound11_3				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h35:begin
	if(pcm_data[74]==1)begin 				//判断第10位_码元3
		CFGPcmFreqSound10_3				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h36:begin
	if(pcm_data[73]==1)begin 				//判断第9位_码元3
		CFGPcmFreqSound9_3				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h37:begin
	if(pcm_data[72]==1)begin 				//判断第8位_码元3
		CFGPcmFreqSound8_3				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h38:begin
	if(pcm_data[71]==1)begin 				//判断第7位_码元3
		CFGPcmFreqSound7_3				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h39:begin
	if(pcm_data[70]==1)begin 				//判断第6位_码元3
		CFGPcmFreqSound6_3				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3A:begin
	if(pcm_data[69]==1)begin 				//判断第5位_码元3
		CFGPcmFreqSound5_3				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3B:begin
	if(pcm_data[68]==1)begin 				//判断第4位_码元3
		CFGPcmFreqSound4_3				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3C:begin
	if(pcm_data[67]==1)begin 				//判断第3位_码元3
		CFGPcmFreqSound3_3				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3D:begin
	if(pcm_data[66]==1)begin 				//判断第2位_码元3
		CFGPcmFreqSound2_3				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3E:begin
	if(pcm_data[65]==1)begin 				//判断第1位_码元3
		CFGPcmFreqSound1_3				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h3F:begin
	if(pcm_data[64]==1)begin 				//判断第0位_码元3
		CFGPcmFreqSound0_3				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_3				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h40:begin
	if(pcm_data[63]==1)begin             //判断第15位_码元4
		CFGPcmFreqSound15_4				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h41:begin
	if(pcm_data[62]==1)begin 				//判断第14位_码元4
		CFGPcmFreqSound14_4				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h42:begin
	if(pcm_data[61]==1)begin 				//判断第13位_码元4
		CFGPcmFreqSound13_4				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h43:begin
	if(pcm_data[60]==1)begin 				//判断第12位_码元4
		CFGPcmFreqSound12_4				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h44:begin
	if(pcm_data[59]==1)begin 				//判断第11位_码元4
		CFGPcmFreqSound11_4				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h45:begin
	if(pcm_data[58]==1)begin 				//判断第10位_码元4
		CFGPcmFreqSound10_4				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h46:begin
	if(pcm_data[57]==1)begin 				//判断第9位_码元4
		CFGPcmFreqSound9_4				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h47:begin
	if(pcm_data[56]==1)begin 				//判断第8位_码元4
		CFGPcmFreqSound8_4				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h48:begin
	if(pcm_data[55]==1)begin 				//判断第7位_码元4
		CFGPcmFreqSound7_4				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h49:begin
	if(pcm_data[54]==1)begin 				//判断第6位_码元4
		CFGPcmFreqSound6_4				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4A:begin
	if(pcm_data[53]==1)begin 				//判断第5位_码元4
		CFGPcmFreqSound5_4				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4B:begin
	if(pcm_data[52]==1)begin 				//判断第4位_码元4
		CFGPcmFreqSound4_4				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4C:begin
	if(pcm_data[51]==1)begin 				//判断第3位_码元4
		CFGPcmFreqSound3_4				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4D:begin
	if(pcm_data[50]==1)begin 				//判断第2位_码元4
		CFGPcmFreqSound2_4				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4E:begin
	if(pcm_data[49]==1)begin 				//判断第1位_码元4
		CFGPcmFreqSound1_4				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h4F:begin
	if(pcm_data[48]==1)begin 				//判断第0位_码元4
		CFGPcmFreqSound0_4				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_4				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h50:begin
	if(pcm_data[47]==1)begin             //判断第15位_码元5
		CFGPcmFreqSound15_5				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h51:begin
	if(pcm_data[46]==1)begin 				//判断第14位_码元5
		CFGPcmFreqSound14_5				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h52:begin
	if(pcm_data[45]==1)begin 				//判断第13位_码元5
		CFGPcmFreqSound13_5				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h53:begin
	if(pcm_data[44]==1)begin 				//判断第12位_码元5
		CFGPcmFreqSound12_5				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h54:begin
	if(pcm_data[43]==1)begin 				//判断第11位_码元5
		CFGPcmFreqSound11_5				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h55:begin
	if(pcm_data[42]==1)begin 				//判断第10位_码元5
		CFGPcmFreqSound10_5				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h56:begin
	if(pcm_data[41]==1)begin 				//判断第9位_码元5
		CFGPcmFreqSound9_5				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h57:begin
	if(pcm_data[40]==1)begin 				//判断第8位_码元5
		CFGPcmFreqSound8_5				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h58:begin
	if(pcm_data[39]==1)begin 				//判断第7位_码元5
		CFGPcmFreqSound7_5				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h59:begin
	if(pcm_data[38]==1)begin 				//判断第6位_码元5
		CFGPcmFreqSound6_5				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h5A:begin
	if(pcm_data[37]==1)begin 				//判断第5位_码元5
		CFGPcmFreqSound5_5				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty										<=1'b1;
		end
	end
	8'h5B:begin
	if(pcm_data[36]==1)begin 				//判断第4位_码元5
		CFGPcmFreqSound4_5				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h5C:begin
	if(pcm_data[35]==1)begin 				//判断第3位_码元5
		CFGPcmFreqSound3_5				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h5D:begin
	if(pcm_data[34]==1)begin 				//判断第2位_码元5
		CFGPcmFreqSound2_5				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h5E:begin
	if(pcm_data[33]==1)begin 				//判断第1位_码元5
		CFGPcmFreqSound1_5				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_5				<=32'h0000_0000;
		data_cnt						 		<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h5F:begin
	if(pcm_data[32]==1)begin 				//判断第0位_码元5
		CFGPcmFreqSound0_5				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_5				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h60:begin
	if(pcm_data[31]==1)begin             //判断第15位_码元6
		CFGPcmFreqSound15_6				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h61:begin
	if(pcm_data[30]==1)begin 				//判断第14位_码元6
		CFGPcmFreqSound14_6				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h62:begin
	if(pcm_data[29]==1)begin 				//判断第13位_码元6
		CFGPcmFreqSound13_6				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h63:begin
	if(pcm_data[28]==1)begin 				//判断第12位_码元6
		CFGPcmFreqSound12_6				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h64:begin
	if(pcm_data[27]==1)begin 				//判断第11位_码元6
		CFGPcmFreqSound11_6				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h65:begin
	if(pcm_data[26]==1)begin 				//判断第10位_码元6
		CFGPcmFreqSound10_6					<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h66:begin
	if(pcm_data[25]==1)begin 				//判断第9位_码元6
		CFGPcmFreqSound9_6				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h67:begin
	if(pcm_data[24]==1)begin 				//判断第8位_码元6
		CFGPcmFreqSound8_6				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h68:begin
	if(pcm_data[23]==1)begin 				//判断第7位_码元6
		CFGPcmFreqSound7_6				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h69:begin
	if(pcm_data[22]==1)begin 				//判断第6位_码元6
		CFGPcmFreqSound6_6				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6A:begin
	if(pcm_data[21]==1)begin 				//判断第5位_码元6
		CFGPcmFreqSound5_6				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6B:begin
	if(pcm_data[20]==1)begin 				//判断第4位_码元6
		CFGPcmFreqSound4_6				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6C:begin
	if(pcm_data[19]==1)begin 				//判断第3位_码元6
		CFGPcmFreqSound3_6				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6D:begin
	if(pcm_data[18]==1)begin 				//判断第2位_码元6
		CFGPcmFreqSound2_6				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6E:begin
	if(pcm_data[17]==1)begin 				//判断第1位_码元6
		CFGPcmFreqSound1_6				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h6F:begin
	if(pcm_data[16]==1)begin 				//判断第0位_码元6
		CFGPcmFreqSound0_6				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_6				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h70:begin
	if(pcm_data[15]==1)begin             //判断第15位_码元7
		CFGPcmFreqSound15_7				<=32'h000C_9539;//12.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound15_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h71:begin
	if(pcm_data[14]==1)begin 				//判断第14位_码元7
		CFGPcmFreqSound14_7				<=32'h000C_29D9;//11.6k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound14_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h72:begin
	if(pcm_data[13]==1)begin 				//判断第13位_码元7
		CFGPcmFreqSound13_7				<=32'h000B_BE7A;//11.2k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound13_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h73:begin
	if(pcm_data[12]==1)begin 				//判断第12位_码元7
		CFGPcmFreqSound12_7				<=32'h000B_531A;//10.8k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound12_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h74:begin
	if(pcm_data[11]==1)begin 				//判断第11位_码元7
		CFGPcmFreqSound11_7				<=32'h000A_E7BA;//10.4k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound11_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h75:begin
	if(pcm_data[10]==1)begin 				//判断第10位_码元7
		CFGPcmFreqSound10_7				<=32'h000A_7C5A;//10.0k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound10_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h76:begin
	if(pcm_data[9]==1)begin 				//判断第9位_码元7
		CFGPcmFreqSound9_7				<=32'h000A_10FA;//9.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound9_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h77:begin
	if(pcm_data[8]==1)begin 				//判断第8位_码元7
		CFGPcmFreqSound8_7				<=32'h0009_A59B;//9.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound8_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h78:begin
	if(pcm_data[7]==1)begin 				//判断第7位_码元7
		CFGPcmFreqSound7_7				<=32'h0009_3A3B;//8.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound7_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h79:begin
	if(pcm_data[6]==1)begin 				//判断第6位_码元7
		CFGPcmFreqSound6_7				<=32'h0008_CEDB;//8.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound6_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7A:begin
	if(pcm_data[5]==1)begin 				//判断第5位_码元7
		CFGPcmFreqSound5_7				<=32'h0008_637B;//8.00k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound5_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7B:begin
	if(pcm_data[4]==1)begin 				//判断第4位_码元7
		CFGPcmFreqSound4_7				<=32'h0007_F81C;//7.60k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound4_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7C:begin
	if(pcm_data[3]==1)begin 				//判断第3位_码元7
		CFGPcmFreqSound3_7				<=32'h0007_8CBC;//7.20k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound3_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7D:begin
	if(pcm_data[2]==1)begin 				//判断第2位_码元7
		CFGPcmFreqSound2_7				<=32'h0007_215C;//6.80k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound2_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7E:begin
	if(pcm_data[1]==1)begin 				//判断第1位_码元7
		CFGPcmFreqSound1_7				<=32'h0006_B5FC;//6.40k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound1_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h7F:begin
	if(pcm_data[0]==1)begin 				//判断第0位_码元7
		CFGPcmFreqSound0_7				<=32'h0005_5E63;//5.12k---clk60M
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	else begin
		CFGPcmFreqSound0_7				<=32'h0000_0000;
		data_cnt								<=data_cnt+1'b1;
		empty											<=1'b1;
		end
	end
	8'h80:begin
		
		case (state)
//				4'b0000:begin					        		//空闲等待状态,等待10ms
//					FSinPSK_o			<=18'h00000;
//					if (count == delay_100ms-1)begin
//						count				<=32'd0;
////						state				<=4'b0001;
//						empty						<=1'b1;
//						state				<=4'b0010;
//						
//					end
//					else begin
//						count				<=count + 1'b1;
//						state				<=state;
//						empty						<=1'b1;
//					end			
//				end
				4'b0000:begin				                  //导音状态，10ms																
					CFGPcmFreqSound0_i			<=32'h0005_5E63;//5.12k,60M
//					CFGPcmFreqSound0_i_0			<=CFGPcmFreqSound0_0;//5.12k,60M
					FSinPSK_o						<=FSinExSound0_o[17:0];
					if (count == delay_10ms-1)begin
						count							<=32'd0;
						state							<=4'b0001;
                        //	data_cnt						<=8'h00;
//						state							<=state;
						empty								<=1'b1;
					end
					else begin
						count							<=count + 1'b1;
						state							<=state;
						empty									<=1'b1;
					end			
				end
				4'b0001:begin										//第一组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_1;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_1;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_1;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_1;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_1;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_1;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_1;  //8.40k---clk60M  
					CFGPcmFreqSound7_i        	<=CFGPcmFreqSound7_1;  //8.80k---clk60M
					CFGPcmFreqSound8_i        	<=CFGPcmFreqSound8_1;  //9.20k---clk60M 
					CFGPcmFreqSound9_i        	<=CFGPcmFreqSound9_1;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_1; // 10.0k---clk60M 
					CFGPcmFreqSound11_i        <=CFGPcmFreqSound11_1; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_1; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_1; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_1; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_1; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0010;
//						state							<=state;
						empty									<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;	
						empty									<=1'b1;					
					end								
				end
				4'b0010:begin										//第二组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_2;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_2;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_2;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_2;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_2;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_2;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_2;  //8.40k---clk60M  
					CFGPcmFreqSound7_i       	<=CFGPcmFreqSound7_2;  //8.80k---clk60M
					CFGPcmFreqSound8_i        	<=CFGPcmFreqSound8_2;  //9.20k---clk60M 
					CFGPcmFreqSound9_i        	<=CFGPcmFreqSound9_2;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_2; // 10.0k---clk60M 
					CFGPcmFreqSound11_i        <=CFGPcmFreqSound11_2; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_2; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_2; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_2; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_2; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					
														  
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0011;
//						state							<=state;	
						empty									<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;	
						empty									<=1'b1;
					end								
				end
				4'b0011:begin										//第三组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_3;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_3;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_3;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_3;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_3;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_3;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_3;  //8.40k---clk60M  
					CFGPcmFreqSound7_i        	<=CFGPcmFreqSound7_3;  //8.80k---clk60M
					CFGPcmFreqSound8_i        	<=CFGPcmFreqSound8_3;  //9.20k---clk60M 
					CFGPcmFreqSound9_i        	<=CFGPcmFreqSound9_3;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_3; // 10.0k---clk60M 
					CFGPcmFreqSound11_i       	<=CFGPcmFreqSound11_3; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_3; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_3; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_3; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_3; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0100;
						empty									<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;	
						empty									<=1'b1;					
					end								
				end
				4'b0100:begin										//第四组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_4;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_4;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_4;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_4;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_4;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_4;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_4;  //8.40k---clk60M  
					CFGPcmFreqSound7_i         <=CFGPcmFreqSound7_4;  //8.80k---clk60M
					CFGPcmFreqSound8_i         <=CFGPcmFreqSound8_4;  //9.20k---clk60M 
					CFGPcmFreqSound9_i         <=CFGPcmFreqSound9_4;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_4; // 10.0k---clk60M 
					CFGPcmFreqSound11_i       	<=CFGPcmFreqSound11_4; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_4; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_4; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_4; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_4; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0101;
						empty									<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;	
						empty									<=1'b1;
					end								
				end
				4'b0101:begin										//第五组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_5;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_5;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_5;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_5;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_5;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_5;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_5;  //8.40k---clk60M  
					CFGPcmFreqSound7_i        	<=CFGPcmFreqSound7_5;  //8.80k---clk60M
					CFGPcmFreqSound8_i        	<=CFGPcmFreqSound8_5;  //9.20k---clk60M 
					CFGPcmFreqSound9_i        	<=CFGPcmFreqSound9_5;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_5; // 10.0k---clk60M 
					CFGPcmFreqSound11_i       	<=CFGPcmFreqSound11_5; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_5; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_5; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_5; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_5; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0110;
						empty									<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;	
						empty									<=1'b1;
					end								
				end
				4'b0110:begin										//第六组侧音，5ms
					CFGPcmFreqSound0_i			<=CFGPcmFreqSound0_6;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i			<=CFGPcmFreqSound1_6;	//6.40k---clk60M                
					CFGPcmFreqSound2_i			<=CFGPcmFreqSound2_6;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i			<=CFGPcmFreqSound3_6;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i			<=CFGPcmFreqSound4_6;  //7.60k---clk60M
					CFGPcmFreqSound5_i			<=CFGPcmFreqSound5_6;  //8.00k---clk60M 
					CFGPcmFreqSound6_i			<=CFGPcmFreqSound6_6;  //8.40k---clk60M  
					CFGPcmFreqSound7_i         <=CFGPcmFreqSound7_6;  //8.80k---clk60M
					CFGPcmFreqSound8_i         <=CFGPcmFreqSound8_6;  //9.20k---clk60M 
					CFGPcmFreqSound9_i         <=CFGPcmFreqSound9_6;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        <=CFGPcmFreqSound10_6; // 10.0k---clk60M 
					CFGPcmFreqSound11_i        <=CFGPcmFreqSound11_6; // 10.4k---clk60M 
					CFGPcmFreqSound12_i			<=CFGPcmFreqSound12_6; // 10.8k---clk60M 
					CFGPcmFreqSound13_i			<=CFGPcmFreqSound13_6; // 11.2k---clk60M
					CFGPcmFreqSound14_i			<=CFGPcmFreqSound14_6; // 11.6k---clk60M
					CFGPcmFreqSound15_i			<=CFGPcmFreqSound15_6; // 12.0k---clk60M 
					FSinPSK_o						<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)			//5ms
					begin 
						count							<=32'd0;
						state							<=4'b0111;
						empty							<=1'b1;
					end
					else
					begin
						count							<=count + 1'b1;
						state							<=state;
						empty									<=1'b1;
					end								
				end
				4'b0111:begin										//第七组侧音，5ms
					CFGPcmFreqSound0_i				<=CFGPcmFreqSound0_7;	//5.12k---clk60M 					
					CFGPcmFreqSound1_i				<=CFGPcmFreqSound1_7;	//6.40k---clk60M                
					CFGPcmFreqSound2_i				<=CFGPcmFreqSound2_7;  //6.80k---clk60M                 
					CFGPcmFreqSound3_i				<=CFGPcmFreqSound3_7;	//7.20k---clk60M 	
					CFGPcmFreqSound4_i				<=CFGPcmFreqSound4_7;  //7.60k---clk60M
					CFGPcmFreqSound5_i				<=CFGPcmFreqSound5_7;  //8.00k---clk60M 
					CFGPcmFreqSound6_i				<=CFGPcmFreqSound6_7;  //8.40k---clk60M  
					CFGPcmFreqSound7_i         	<=CFGPcmFreqSound7_7;  //8.80k---clk60M
					CFGPcmFreqSound8_i         	<=CFGPcmFreqSound8_7;  //9.20k---clk60M 
					CFGPcmFreqSound9_i          	<=CFGPcmFreqSound9_7;  //9.60k---clk60M 
					CFGPcmFreqSound10_i        	<=CFGPcmFreqSound10_7; // 10.0k---clk60M 
					CFGPcmFreqSound11_i        	<=CFGPcmFreqSound11_7; // 10.4k---clk60M 
					CFGPcmFreqSound12_i				<=CFGPcmFreqSound12_7; // 10.8k---clk60M 
					CFGPcmFreqSound13_i				<=CFGPcmFreqSound13_7; // 11.2k---clk60M
					CFGPcmFreqSound14_i				<=CFGPcmFreqSound14_7; // 11.6k---clk60M
					CFGPcmFreqSound15_i				<=CFGPcmFreqSound15_7; // 12.0k---clk60M 
					FSinPSK_o							<=FSinExSound0_o[17:0]+FSinExSound1_o[17:0]+FSinExSound2_o[17:0]+FSinExSound3_o[17:0]+
														  FSinExSound4_o[17:0]+FSinExSound5_o[17:0]+FSinExSound6_o[17:0]+FSinExSound7_o[17:0]+
														  FSinExSound8_o[17:0]+FSinExSound9_o[17:0]+FSinExSound10_o[17:0]+FSinExSound11_o[17:0]+
														  FSinExSound12_o[17:0]+FSinExSound13_o[17:0]+FSinExSound14_o[17:0]+FSinExSound15_o[17:0];
					if (count == delay_5ms-1)begin										//5ms
						count							<=32'd0;
						state							<=4'b0000;              //回到空闲状态
						empty							<=1'b0;
						data_cnt						<=8'h00;
//						pcm_data						<=0;
						end
					else begin
						count							<=count + 1'b1;
						state							<=state;
						empty							<=1'b1;						
						end								
				end
				default:begin
					state								<=4'b0000;
					count								<=32'd0;
				end
			endcase
		
end

endcase//(大case）
end  //(大else）
end //(always)

always@(posedge ad_data_clk or negedge rst_n)
begin
    if(!rst_n)
        tx_cnt <=0;
    else
        begin
            if((valid) && (data_cnt == 0))
                tx_cnt <= tx_cnt + 1;
            else
                ;
        end
end

/**********************************************************************************
												加调/去调，加载/去载	
**********************************************************************************/	
		
always@(posedge ad_data_clk or negedge rst_n)
begin
if(!rst_n)begin
	carry_on								<=1'b0;
	modem_on								<=1'b0;
	end
else begin
//	carry_on								<=CFGADSourceState[5];
//	modem_on								<=CFGADSourceState[4];
	carry_on								<=CFGADSourceState1_DY;
	modem_on								<=CFGADSourceState2_DY;
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
