//ʱ������
`timescale 1ns/1ps

module  time_ok_out(
input												sclk,
input												rst_n,
//-------------------------------------
input												fifo_empty,
input				[63:0]					fifo_data,
//input 											w_en,
//output	reg									fifo_rd_en,
//-----------------------------------------
output  	reg 	[63:0]					TimerBSecond_ov
);
/*always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		fifo_rd_en<=1'b0;
	else if(fifo_empty==1'b0)
		fifo_rd_en<=1'b1;
	else
		fifo_rd_en<=1'b0;
end*/
/*always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		TimerBSecond_ov<=64'd0;
	else if(fifo_empty==1'b0)
		TimerBSecond_ov<=fifo_data;
	else 
;
end*/
//assign TimerBSecond_ov=fifo_data;
//assign fifo_rd_en = w_en;
//-----------
/*always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		TimerBSecond_ov<=64'd0;
	else if(fifo_rd_en==1'b1)
		TimerBSecond_ov<=fifo_data;
	else 
;
end*/
localparam								IDLE=3'b001;
localparam								READ_EN=3'B010;
localparam								STOP=3'B100;
reg  [2:0]				state;
//状态机
always@(posedge sclk or negedge rst_n)
begin
if(rst_n==1'b0)
	begin
		state<=IDLE;
		TimerBSecond_ov<=64'h0;
	end
else 
	case(state)
		IDLE:		begin
						if(fifo_empty==1'b0)
							state<=READ_EN;
						else 
							state<=IDLE;
					end
		READ_EN:	begin
						//if(fifo_rd_en==1'b1)
							//begin
							TimerBSecond_ov<=fifo_data;
							state<=STOP;
							//end
						//else
							//state<=READ_EN;
					end
					
			STOP:	begin
						if(fifo_empty==1'b1)
							state<=IDLE;
						else
							state<=STOP;
					end
		
	endcase
end

endmodule
