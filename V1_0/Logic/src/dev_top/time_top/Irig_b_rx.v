`timescale 1ns/1ps

module Irig_b_rx(
input																	Clk,														//125M时钟
input																	Rst,														//复位，高有效
input																	IrigbIn,															//from gps
output			[6:0] 											RxSecond,								//秒
output			[6:0] 											RxMinute,								//分
output			[5:0]												RxHour,									//小时
output			[9:0] 											RxDayOfYear,							//天
output			[7:0] 											RxYear,
output	reg														Rx_sec_vld,								//秒计算完成
output	reg														Rx_year_vld,							//年计算完成（所有时间计算完成）
output	reg														Rx_day_vld,								//天计算完成
output	reg														Rx_hour_vld,							//时计算完成
output	reg														Rx_min_vld,								//分计算完成
output	reg														pps_b_o						//准秒时刻
);
localparam		IRIG_P											=3'b010;
localparam		IRIG_H											=3'b100;
localparam		IRIG_L											=3'b001;
//state
localparam		IDEL												=0;
localparam		SEARCH_HEAD										=1;
localparam		CAPTRUE_SECOND									=2;
localparam		CAPTRUE_MINUTE									=3;
localparam		CAPTRUE_HOUR									=4;
localparam		CAPTRUE_DAYL									=5;
localparam		CAPTRUE_DAYH									=6;
localparam		CAPTRUE_YEAR									=7;
localparam		DUMMY												=8;
/***********************************************wire***********************************************/
wire																	Ready;
wire				[2:0]												Plus_type;
/***********************************************reg************************************************/
reg				[3:0]												state;
reg				[8:0]												Rx_year_reg;
reg				[8:0]												Rx_dayl_reg;
reg				[8:0]												Rx_dayh_reg;
reg				[8:0]												Rx_hour_reg;
reg				[8:0]												Rx_min_reg;
reg				[7:0]												Rx_sec_reg;
reg				[7:0]												cnt;

assign			RxSecond											={Rx_sec_reg[7:5],Rx_sec_reg[3:0]};
assign			RxMinute											={Rx_min_reg[7:5],Rx_min_reg[3:0]};
assign			RxHour											={Rx_hour_reg[6:5],Rx_hour_reg[3:0]};
assign			RxDayOfYear										={Rx_dayh_reg[1:0],Rx_dayl_reg[8:5],Rx_dayl_reg[3:0]};
assign			RxYear											={Rx_year_reg[8:5],Rx_year_reg[3:0]};
//脉宽检测，001代表低电平，010代表P码，100代表高电平
Irig_b_pluse Irig_b_pluse_inst(
	.Clk(																Clk),
	.Rst(																Rst),
	.IrigbIn(														IrigbIn),
	.Plus_type(														Plus_type),
	.Ready(															Ready)
);

always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		state															<=IDEL;		
		Rx_sec_reg													<=8'd0;
		Rx_year_reg													<=9'd0;
		Rx_dayl_reg													<=9'd0;
		Rx_dayh_reg													<=9'd0;
		Rx_hour_reg													<=9'd0;
		Rx_min_reg													<=9'd0;
		Rx_sec_vld													<=1'b0;
		Rx_year_vld													<=1'b0;
//		Rx_dayl_vld													<=1'b0;
		Rx_day_vld													<=1'b0;
		Rx_hour_vld													<=1'b0;
		Rx_min_vld													<=1'b0;	
		pps_b_o														<=1'b0;
		cnt															<=8'd0;
	end
	else
	begin
		case (state)
		IDEL:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_P)
				begin
					state												<=SEARCH_HEAD;
					pps_b_o											<=1'b1;
				end
			end
			else
			begin
				pps_b_o												<=1'b0;
			end
			Rx_sec_vld												<=1'b0;
			Rx_year_vld												<=1'b0;
//			Rx_dayl_vld												<=1'b0;
			Rx_day_vld												<=1'b0;
			Rx_hour_vld												<=1'b0;
			Rx_min_vld												<=1'b0;	
//			pps_b_o													<=1'b0;
		end
		SEARCH_HEAD:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_SECOND;																	//连续两个P码
				end
				else
				begin
					state												<=IDEL;
				end
			end
		end
		CAPTRUE_SECOND:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_sec_reg										<={1'b0,Rx_sec_reg[7:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_sec_reg										<={1'b1,Rx_sec_reg[7:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_MINUTE;
					Rx_sec_vld										<=1'b1;
				end
				else
				begin
					state												<=IDEL;
				end
			end
		end
		CAPTRUE_MINUTE:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_min_reg										<={1'b0,Rx_min_reg[8:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_min_reg										<={1'b1,Rx_min_reg[8:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_HOUR;
					Rx_min_vld										<=1'b1;
				end
				else
				begin
					state												<=IDEL;
				end				
			end
		end
		CAPTRUE_HOUR:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_hour_reg										<={1'b0,Rx_hour_reg[8:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_hour_reg										<={1'b1,Rx_hour_reg[8:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_DAYL;
					Rx_hour_vld										<=1'b1;
				end
				else
				begin
					state												<=IDEL;
				end				
			end			
		end
		CAPTRUE_DAYL:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_dayl_reg										<={1'b0,Rx_dayl_reg[8:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_dayl_reg										<={1'b1,Rx_dayl_reg[8:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_DAYH;
//					Rx_dayl_vld										<=1'b1;
				end
				else
				begin
					state												<=IDEL;
				end				
			end						
		end
		CAPTRUE_DAYH:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_dayh_reg										<={1'b0,Rx_dayh_reg[8:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_dayh_reg										<={1'b1,Rx_dayh_reg[8:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=CAPTRUE_YEAR;
					pps_b_o											<=1'b0;
					Rx_day_vld										<=1'b1;
				end
				else
				begin
					state												<=IDEL;
				end				
			end									
		end
		CAPTRUE_YEAR:
		begin
			if (Ready)
			begin
				if (Plus_type == IRIG_L)
				begin
					Rx_year_reg											<={1'b0,Rx_year_reg[8:1]};
				end
				else if (Plus_type == IRIG_H)
				begin
					Rx_year_reg											<={1'b1,Rx_year_reg[8:1]};
				end
				else if (Plus_type == IRIG_P)
				begin
					state												<=DUMMY;
					Rx_year_vld										<=1'b1;
					Rx_sec_vld										<=1'b0;
				end
				else
				begin
					state												<=IDEL;
				end				
			end												
		end
		DUMMY:
		begin
			if (cnt == 8'd3)
			begin
				cnt													<=8'd0;
				state													<=IDEL;
			end
			else if (Ready)
			begin
				if (Plus_type == IRIG_P)
				begin
					cnt												<=cnt + 1'b1;
				end
			end
		end
		default:
		begin
			state														<=IDEL;
		end
		endcase
	end
end

endmodule
