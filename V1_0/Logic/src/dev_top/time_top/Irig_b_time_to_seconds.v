module Irig_b_time_to_seconds(
input																	Clk,														//125M时钟
input																	Rst,														//复位，高有效
input				[6:0] 											RxSecond,								//秒
input				[6:0] 											RxMinute,								//分
input				[5:0]												RxHour,									//小时
input				[9:0] 											RxDayOfYear,							//天
input				[7:0] 											RxYear,
input																	Rx_sec_vld,								//秒计算完成
input																	Rx_year_vld,							//年计算完成（所有时间计算完成）
input																	Rx_day_vld,								//天计算完成
input																	Rx_hour_vld,							//时计算完成
input																	Rx_min_vld,								//分计算完成
output	reg	[31:0]											Irig_Time_Seconds,
output	reg														updata
);	
localparam		IDEL												=0;
localparam		RX_SEC											=1;
localparam		RX_MIN_WAIT										=2;
localparam		RX_MIN											=3;
localparam		RX_HOUR_WAIT									=4;
localparam		RX_HOUR											=5;
localparam		RX_DAY_WAIT										=6;
localparam		RX_DAY											=7;
localparam		RX_YEAR_WAIT									=8;
localparam		RX_YEAR											=9;
localparam		ALL_SECOND										=10;

/***********************************************wire***********************************************/
//秒
reg				[31:0]											RxSecond_to_s;
reg				[6:0]												RxSecond_reg;
//分
reg				[31:0]											RxMinute_to_s;
reg				[31:0]											RxMinute_to_s_h;
reg				[31:0]											RxMinute_to_s_l;
reg				[6:0]												RxMinute_reg;
//时
reg				[31:0]											RxHour_to_s;
reg				[31:0]											RxHour_to_s_h;
reg				[31:0]											RxHour_to_s_l;
reg				[5:0]												RxHour_reg;
//天
reg				[9:0]												RxDayOfYear_reg;
reg				[31:0]											RxDayOfYear_to_s;
//reg				[31:0]											RxDayOfYear_to_s_h;
//reg				[31:0]											RxDayOfYear_to_s_m;
//reg				[31:0]											RxDayOfYear_to_s_l;
//年
reg				[7:0]												RxYear_reg;
reg				[7:0]												RxYear_reg_d;											//十进制年
reg				[31:0]											RxYear_to_s;
reg				[31:0]											RxYear_to_s_h;
reg				[31:0]											RxYear_to_s_l;
reg				[31:0]											RxYear_to_s_u;											//润年多出的秒数
reg				[3:0]												state;
//reg																	Rx_sec_vld_delay1;

/***********************************************reg************************************************/
//wire																	Rx_sec_vld_pos;
//
//assign			Rx_sec_vld_pos									=Rx_sec_vld & ~Rx_sec_vld_delay1;
//always @(posedge Clk or posedge Rst)
//begin
//	if (Rst)
//	begin
//		Rx_sec_vld_delay1											<=1'b0;
//	end
//	else
//	begin
//		Rx_sec_vld_delay1											<=Rx_sec_vld;
//	end
//end

always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		state															<=IDEL;
		RxSecond_reg												<=7'd0;
		RxSecond_to_s												<=32'd0;
		RxMinute_reg												<=7'd0;
		RxMinute_to_s												<=32'd0;
		RxMinute_to_s_h											<=32'd0;
		RxMinute_to_s_l											<=32'd0;		
		RxHour_reg													<=6'd0;
		RxHour_to_s													<=32'd0;
		RxHour_to_s_h												<=32'd0;
		RxHour_to_s_l												<=32'd0;	
		RxDayOfYear_reg											<=10'd0;
		RxDayOfYear_to_s											<=32'd0;	
//		RxDayOfYear_to_s_h										<=32'd0;
//		RxDayOfYear_to_s_m										<=32'd0;
//		RxDayOfYear_to_s_l										<=32'd0;
		RxYear_reg													<=8'd0;
		RxYear_reg_d												<=8'd0;											//十进制年
		RxYear_to_s													<=32'd0;
		RxYear_to_s_h												<=32'd0;
		RxYear_to_s_l												<=32'd0;
		RxYear_to_s_u												<=32'd0;											//润年多出的秒数
		updata														<=1'b0;
		Irig_Time_Seconds											<=32'd0;
	end
	else
	begin
		case (state)
		IDEL:
		begin
			if (Rx_sec_vld)
			begin
				state													<=RX_SEC;
				RxSecond_reg										<=RxSecond;
			end
//			RxSecond_reg											<=7'd0;
			RxSecond_to_s											<=32'd0;
			RxMinute_reg											<=7'd0;
			RxMinute_to_s											<=32'd0;
			RxMinute_to_s_h										<=32'd0;
			RxMinute_to_s_l										<=32'd0;
			RxHour_reg												<=6'd0;
			RxHour_to_s												<=32'd0;
			RxHour_to_s_h											<=32'd0;
			RxHour_to_s_l											<=32'd0;	
			RxDayOfYear_reg										<=10'd0;
			RxDayOfYear_to_s										<=32'd0;	
//			RxDayOfYear_to_s_h									<=32'd0;
//			RxDayOfYear_to_s_m									<=32'd0;
//			RxDayOfYear_to_s_l									<=32'd0;
			RxYear_reg												<=8'd0;
			RxYear_reg_d											<=8'd0;											//十进制年
			RxYear_to_s												<=32'd0;
			RxYear_to_s_h											<=32'd0;
			RxYear_to_s_l											<=32'd0;
			RxYear_to_s_u											<=32'd0;											//润年多出的秒数
			updata													<=1'b0;
		end
		RX_SEC:
		begin
			if (RxSecond_reg[6:4] >= 3'd1)
			begin
				RxSecond_reg[6:4]									<=RxSecond_reg[6:4] - 1'b1;
				RxSecond_to_s										<=RxSecond_to_s + 32'd10;
			end
			else
			begin
				RxSecond_to_s										<=RxSecond_to_s + RxSecond_reg[3:0];
				state													<=RX_MIN_WAIT;									
			end
		end
		RX_MIN_WAIT:
		begin
			if (Rx_min_vld)
			begin
				state													<=RX_MIN;
				RxMinute_reg										<=RxMinute;
			end
		end
		RX_MIN:
		begin
			if (RxMinute_reg[6:4] == 3'd0 && RxMinute_reg[3:0] == 4'd0)
			begin
				RxMinute_to_s										<=RxMinute_to_s_h + RxMinute_to_s_l;
				state													<=RX_HOUR_WAIT;
			end
			else
			begin
				if (RxMinute_reg[6:4] >= 3'd1)
				begin
					RxMinute_reg[6:4]								<=RxMinute_reg[6:4] - 1'b1;
					RxMinute_to_s_h								<=RxMinute_to_s_h + 32'd600;
				end
				if (RxMinute_reg[3:0] >= 4'd1)
				begin
					RxMinute_reg[3:0]								<=RxMinute_reg[3:0] - 1'b1;
					RxMinute_to_s_l								<=RxMinute_to_s_l + 32'd60;
				end
			end
		end
		RX_HOUR_WAIT:
		begin
			if (Rx_hour_vld)
			begin
				state													<=RX_HOUR;
				RxHour_reg											<=RxHour;				
			end
		end
		RX_HOUR:
		begin
			if (RxHour_reg[5:4] == 2'd0 && RxHour_reg[3:0] == 4'd0)
			begin
				RxHour_to_s											<=RxHour_to_s_h + RxHour_to_s_l;
				state													<=RX_DAY_WAIT;
			end
			else
			begin
				if (RxHour_reg[5:4] >= 2'd1)
				begin
					RxHour_reg[5:4]								<=RxHour_reg[5:4] - 1'b1;
					RxHour_to_s_h									<=RxHour_to_s_h + 32'd36000;
				end
				if (RxHour_reg[3:0] >= 4'd1)
				begin
					RxHour_reg[3:0]								<=RxHour_reg[3:0] - 1'b1;
					RxHour_to_s_l									<=RxHour_to_s_l + 32'd3600;
				end
			end
		end
		RX_DAY_WAIT:
		begin
			if (Rx_day_vld)
			begin
				state													<=RX_DAY;
//				RxDayOfYear_reg									<=RxDayOfYear - 1'b1;;
				RxDayOfYear_reg									<={RxDayOfYear[9:8],6'b000000}+{RxDayOfYear[9:8],5'b00000}+{RxDayOfYear[9:8],2'b00}+{RxDayOfYear[7:4],3'b000}+{RxDayOfYear[7:4],1'b0}+RxDayOfYear[3:0];													//20200807
			end
		end
		RX_DAY:
		begin
			if (RxDayOfYear_reg > 10'd1)
			begin
				RxDayOfYear_reg									<=RxDayOfYear_reg - 1'b1;
				RxDayOfYear_to_s									<=RxDayOfYear_to_s + 32'd86400;
			end
			else
			begin
				state													<=RX_YEAR_WAIT;
			end
//			if (RxDayOfYear_reg[9:0] == 10'd0)
////			if (RxDayOfYear_reg[9:0] == 10'd1)
//			begin
//				RxDayOfYear_to_s									<=RxDayOfYear_to_s_h + RxDayOfYear_to_s_l + RxDayOfYear_to_s_m;
//				state													<=RX_YEAR_WAIT;
//			end
//			else
//			begin
//				if (RxDayOfYear_reg[9:8] >= 2'd1)
//				begin
//					RxDayOfYear_reg[9:8]							<=RxDayOfYear_reg[9:8] - 1'b1;
//					RxDayOfYear_to_s_h							<=RxDayOfYear_to_s_h + 32'd8640000;							//100天
//				end
//				if (RxDayOfYear_reg[7:4] >= 4'd1)
//				begin
//					RxDayOfYear_reg[7:4]							<=RxDayOfYear_reg[7:4] - 1'b1;
//					RxDayOfYear_to_s_m							<=RxDayOfYear_to_s_m + 32'd864000;
//				end
//				if (RxDayOfYear_reg[3:0] >= 4'd1)
////				if (RxDayOfYear_reg[3:0] >= 4'd2)
//				begin
//					RxDayOfYear_reg[3:0]							<=RxDayOfYear_reg[3:0] - 1'b1;
//					RxDayOfYear_to_s_l							<=RxDayOfYear_to_s_l + 32'd86400;
//				end
//			end
		end
		RX_YEAR_WAIT:
		begin
			if (Rx_year_vld)
			begin
				RxYear_reg											<=RxYear;
				RxYear_reg_d										<={RxYear[7:4],3'b000} + {RxYear[7:4],1'b0} + RxYear[3:0];			//十进制年
				state													<=RX_YEAR;
			end
		end
		RX_YEAR:
		begin
			if (RxYear_reg == 8'd0 && RxYear_reg_d <= 8'd4)
			begin
				if (RxYear_reg_d == 8'd0)
				begin
					RxYear_to_s										<=RxYear_to_s_h + RxYear_to_s_l + RxYear_to_s_u;
				end
				else
				begin
					RxYear_to_s										<=RxYear_to_s_h + RxYear_to_s_l + RxYear_to_s_u + 32'd86400;					
				end
				state													<=ALL_SECOND;
			end
			else
			begin
				if (RxYear_reg[7:4] >= 4'd1)
				begin
					RxYear_reg[7:4]								<=RxYear_reg[7:4] - 1'b1;
					RxYear_to_s_h									<=RxYear_to_s_h + 32'd315360000;													//十年的秒数
				end
				if (RxYear_reg[3:0] >= 4'd1)
				begin
					RxYear_reg[3:0]								<=RxYear_reg[3:0] - 1'b1;
					RxYear_to_s_l									<=RxYear_to_s_l + 32'd31536000;													//年的秒数
				end
				if (RxYear_reg_d > 8'd4)
				begin
					RxYear_reg_d									<=RxYear_reg_d - 8'd4;
					RxYear_to_s_u									<=RxYear_to_s_u + 32'd86400;
				end
			end
		end
		ALL_SECOND:
		begin
			Irig_Time_Seconds										<=RxYear_to_s + RxDayOfYear_to_s + RxHour_to_s + RxMinute_to_s + RxSecond_to_s;
			updata													<=1'b1;
			state														<=IDEL;
		end
		default:
		begin
			state														<=IDEL;
		end
		endcase
	end
end
endmodule
