//不断检测B码的高电平和低电平脉宽，上升沿输出一次检测结果
//Plus_type为001 表示低电平
//Plus_type为010 表示P码
//Plus_type为100 表示高电平
`timescale 1ns/1ps

module Irig_b_pluse(
input																	Clk,
input																	Rst,
input																	IrigbIn,
output	reg	[2:0]												Plus_type,					//001:0 010:p 100:1
//output	reg														pps_b_o,						//准秒时刻
output	reg														Ready
);
localparam		TIME_7MS											=32'd875000;
localparam		TIME_3MS											=32'd375000;
localparam		IRIG_P											=3'b010;
localparam		IRIG_H											=3'b100;
localparam		IRIG_L											=3'b001;
//state
localparam		IDEL												=0;
localparam		WAIT_POS											=1;
localparam		WAIT_NEG											=2;
localparam		JUNGE												=3;
/***********************************************wire***********************************************/

/***********************************************reg************************************************/
reg				[2:0]												shift_irig;
reg				[31:0]											cnt;
reg				[31:0]											Low_plus;
reg				[31:0]											Hign_plus;
reg				[1:0]												state;

always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		shift_irig													<=3'b0;
	end
	else
	begin
		shift_irig													<={shift_irig[1:0],IrigbIn};
	end
end

always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		state															<=IDEL;
		cnt															<=32'd0;
		Hign_plus													<=32'd0;
		Low_plus														<=32'd0;
		Plus_type													<=3'b000;
		Ready															<=1'b0;
	end
	else
	begin
		case (state)
		IDEL:
		begin
			if (shift_irig[2:1] == 2'b01)																								//上升沿
			begin
				cnt													<=cnt + 1'b1;
				state													<=WAIT_NEG;
			end
			Ready														<=1'b0;
		end
		WAIT_NEG:
		begin
			if (shift_irig[2:1] == 2'b10)
			begin
				Hign_plus											<=cnt;
				cnt													<=32'd1;
				state													<=WAIT_POS;
			end
			else
			begin
				cnt													<=cnt + 1'b1;
			end
			Ready														<=1'b0;
		end
		WAIT_POS:
		begin
			if (shift_irig[2:1] == 2'b01)
			begin
				Low_plus												<=cnt;
				cnt													<=32'd1;
				state													<=JUNGE;
			end
			else
			begin
				cnt													<=cnt + 1'b1;
			end
		end
		JUNGE:
		begin
			if (Hign_plus > TIME_7MS && Low_plus < TIME_3MS)
			begin
				Plus_type											<=IRIG_P;
			end
			else if (Hign_plus < TIME_3MS && Low_plus > TIME_7MS)
			begin
				Plus_type											<=IRIG_L;
			end
			else
			begin
				Plus_type											<=IRIG_H;
			end
			Ready														<=1'b1;
			cnt														<=cnt + 1'b1;
			state														<=WAIT_NEG;
		end
		endcase
	end
end

endmodule
