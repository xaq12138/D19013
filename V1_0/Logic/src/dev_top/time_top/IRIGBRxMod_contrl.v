`timescale 1ns/1ps

module IRIGBRxMod_contrl(
input																	clk,
input          													rst,
input																	IrigbIn,
    input                           rm_time_valid               , 
    input                    [31:0] rm_time                     , 
output																pps_b_syno,
output	 		[31:0]											TimerBSecondCnt_o,
output			[31:0]											TimerBNanosecondCnt_o,
output 		  														TimerBNanosecondCnt_sample_o			
);

wire				[6:0] 											RxSecond;								//秒
wire				[6:0] 											RxMinute;								//分
wire				[5:0]												RxHour;									//小时

wire                         [9:0 ] RxDayOfYear                 ; 

wire				[7:0] 											RxYear;
wire																	Rx_sec_vld;								//秒计算完成
wire																	Rx_year_vld;							//年计算完成（所有时间计算完成）
wire																	Rx_day_vld;								//天计算完成
wire																	Rx_hour_vld;							//时计算完成
wire																	Rx_min_vld;								//分计算完成

wire																	pps_o;
wire																	updata;
wire				[31:0]											Irig_Time_Seconds;

assign			TimerBNanosecondCnt_sample_o				=TimerBNanosecondCnt_o[0];							//亚秒地位，用于写fifo

Irig_b_rx Irig_b_rx_inst(
	.Clk(																clk),														//125M时钟
	.Rst(																rst),														//复位，高有效
	.IrigbIn(														IrigbIn),															//from B码
	.RxSecond(														RxSecond),								//秒
	.RxMinute(														RxMinute),								//分
	.RxHour(															RxHour),									//小时
	.RxDayOfYear(													RxDayOfYear),							//天
	.RxYear(															RxYear),
	.Rx_sec_vld(													Rx_sec_vld),								//秒计算完成
	.Rx_year_vld(													Rx_year_vld),							//年计算完成（所有时间计算完成）
	.Rx_day_vld(													Rx_day_vld),								//天计算完成
	.Rx_hour_vld(													Rx_hour_vld),							//时计算完成
	.Rx_min_vld(													Rx_min_vld),								//分计算完成
	.pps_b_o(														pps_o)						//准秒时刻
);

Irig_b_time_to_seconds Irig_b_time_to_seconds_inst(
	.Clk(																clk),														//125M时钟
	.Rst(																rst),														//复位，高有效
	.RxSecond(														RxSecond),								//秒
	.RxMinute(														RxMinute),								//分
	.RxHour(															RxHour),									//小时
	.RxDayOfYear(													RxDayOfYear),							//天
	.RxYear(															RxYear),
	.Rx_sec_vld(													Rx_sec_vld),								//秒计算完成
	.Rx_year_vld(													Rx_year_vld),							//年计算完成（所有时间计算完成）
	.Rx_day_vld(													Rx_day_vld),								//天计算完成
	.Rx_hour_vld(													Rx_hour_vld),							//时计算完成
	.Rx_min_vld(													Rx_min_vld),								//分计算完成
	.updata(															updata),
	.Irig_Time_Seconds(											Irig_Time_Seconds)
);

NewPPS_1sMod SYNPPS_rs422(
	.clk(																clk),
	.rst(																rst),
	.PPS1S_From_GPS(												pps_o),
	.UpNewDateReg(													{1'b0,updata}),
	.GPSTimerS(														Irig_Time_Seconds),
	.PPS1S_Output_delay1(										pps_b_syno),
	.SYN_10MHz(														),
	.BaseSetTimerReg(												),
	.BaseSetTimerEn(												1'b0),
    .rm_time_valid                  (rm_time_valid              ), // (input )
    .rm_time                        (rm_time[31:0]              ), // (input )
	.Tim_nS_Out(													TimerBNanosecondCnt_o),
	.Tim_S_BaseSetCnt(											),
	.Tim_S_Out_delay1(											TimerBSecondCnt_o)
);	

//always @(posedge clk or posedge rst)
//begin
//	if (rst)
//	begin
//		Irig_Time_Seconds					<=32'd0;
//		updata								<=1'b0;
//		RxDayOfYear							<=9'd0;
//		RxHourOfYear						<=16'd0;
//		RxMinOfYear							<=32'd0;
//		RxSecOfYear							<=32'd0;
//		RxHourofHour						<=32'd0;
//		RxMinofMin							<=32'd0;
//		RxMinofHour[31:0]					<=32'd0;
//		RxSecofMin[31:0]					<=32'd0;
//		RxSecofHour							<=32'd0;
//		state									<=5'd0;
//	end	
//	else
//	begin
//		case (state)
//		0:
//		begin
//			if (updatanew)
//			begin
//				state							<=1;
//				RxDayOfYear[8:0]			<={RxDayOfYear_r[10:9],6'b000000};				//乘以64
//				RxHourofHour[31:0]		<={RxHour_r[6:5],3'b000};							//乘以8
//				RxMinofMin[31:0]			<={RxMinute_r[7:5],3'b000};						//乘以8
//			end
//			updata							<=1'b0;
//		end
//		1:
//		begin
//			state								<=2;
//			RxDayOfYear[8:0]				<=RxDayOfYear[8:0] + {RxDayOfYear_r[10:9],5'b00000};		//乘以32
//			RxHourofHour[31:0]			<=RxHourofHour[31:0] + {RxHour_r[6:5],1'b0};							//乘以2,十时计算完成
//			RxMinofMin[31:0]				<=RxMinofMin[31:0] + {RxMinute_r[7:5],1'b0};						//乘以2，十分计算完成
//		end
//		2:
//		begin
//			state								<=3;
//			RxDayOfYear[8:0]				<=RxDayOfYear[8:0] + {RxDayOfYear_r[10:9],2'b00};		//乘以4,百天计算完成
//			RxHourofHour[31:0]			<=RxHourofHour[31:0] + RxHour_r[3:0];							//时计算完成
//			RxMinofMin[31:0]				<=RxMinofMin[31:0] + RxMinute_r[3:0];						//分计算完成
//		end
//		3:
//		begin
//			state								<=4;
//			RxDayOfYear[8:0]				<=RxDayOfYear[8:0] + {RxDayOfYear_r[8:5],3'b000};		//乘以8,十天
//			RxMinofHour[31:0]				<={RxHourofHour[31:0],5'b00000};								//乘以32
//			RxSecofMin[31:0]				<={RxMinofMin[31:0],5'b00000};								//乘以32			
//		end	
//		4:
//		begin
//			state								<=5;
//			RxDayOfYear[8:0]				<=RxDayOfYear[8:0] + {RxDayOfYear_r[8:5],1'b0};		//乘以2,十天计算完成
//			RxMinofHour[31:0]				<=RxMinofHour[31:0] + {RxHourofHour[31:0],4'b0000};								//乘以16
//			RxSecofMin[31:0]				<=RxSecofMin[31:0] + {RxMinofMin[31:0],4'b0000};								//乘以16
//		end
//		5:
//		begin
//			state								<=6;
//			RxDayOfYear[8:0]				<=RxDayOfYear[8:0] + RxDayOfYear_r[3:0];		//天计算完成
//			RxMinofHour[31:0]				<=RxMinofHour[31:0] + {RxHourofHour[31:0],3'b000};								//乘以8
//			RxSecofMin[31:0]				<=RxSecofMin[31:0] + {RxMinofMin[31:0],3'b000};								//乘以8
//		end
//		6:
//		begin
//			state								<=7;
//			RxHourOfYear[15:0]			<={RxDayOfYear[8:0],4'b0000};						//乘以16
//			RxMinofHour[31:0]				<=RxMinofHour[31:0] + {RxHourofHour[31:0],2'b00};								//乘以4,分计算完成
//			RxSecofMin[31:0]				<=RxSecofMin[31:0] + {RxMinofMin[31:0],2'b00};								//乘以4，秒计算完成
//		end
//		7:
//		begin
//			state								<=8;
//			RxHourOfYear[15:0]			<=RxHourOfYear[15:0] + {RxDayOfYear[8:0],3'b000};		//乘以8,小时计算完成
//			RxSecofHour[31:0]				<={RxMinofHour[31:0],5'b00000};								//乘以32
//		end
//		8:
//		begin
//			state								<=9;
//			RxMinOfYear[31:0]				<={RxHourOfYear[15:0],5'b00000};					//乘以32
//			RxSecofHour[31:0]				<=RxSecofHour[31:0] + {RxMinofHour[31:0],4'b0000};						//乘以16
//		end
//		9:
//		begin
//			state								<=10;
//			RxMinOfYear[31:0]				<=RxMinOfYear[31:0] + {RxHourOfYear[15:0],4'b0000};					//乘以16
//			RxSecofHour[31:0]				<=RxSecofHour[31:0] + {RxMinofHour[31:0],3'b000};						//乘以8
//		end
//		10:
//		begin
//			state								<=11;
//			RxMinOfYear[31:0]				<=RxMinOfYear[31:0] + {RxHourOfYear[15:0],3'b000};					//乘以8
//			RxSecofHour[31:0]				<=RxSecofHour[31:0] + {RxMinofHour[31:0],2'b00};							//乘以4，秒计算完成（小时）
//		end
//		11:
//		begin
//			state								<=12;
//			RxMinOfYear[31:0]				<=RxMinOfYear[31:0] + {RxHourOfYear[15:0],2'b00};					//乘以4,分钟计算完成
//		end
//		12:
//		begin
//			state								<=13;
//			RxSecOfYear[31:0]				<={RxMinOfYear[31:0],5'b00000};					//乘以32
//		end
//		13:
//		begin
//			state								<=14;
//			RxSecOfYear[31:0]				<=RxSecOfYear[31:0] + {RxMinOfYear[31:0],4'b0000};					//乘以16
//		end
//		14:
//		begin
//			state								<=15;
//			RxSecOfYear[31:0]				<=RxSecOfYear[31:0] + {RxMinOfYear[31:0],3'b000};					//乘以8
//		end
//		15:
//		begin
//			state								<=16;
//			RxSecOfYear[31:0]				<=RxSecOfYear[31:0] + {RxMinOfYear[31:0],3'b000};					//乘以4,秒计算完成
//			updata							<=1'b0;
//		end
//		16:
//		begin
//			state								<=0;
//			Irig_Time_Seconds				<=RxSecOfYear + RxSecofHour + RxSecofMin + RxSecond_r;
//			updata							<=1'b1;
//		end
//		default:
//		begin
//			state								<=0;
//		end
//		endcase
//	end
//end


endmodule
