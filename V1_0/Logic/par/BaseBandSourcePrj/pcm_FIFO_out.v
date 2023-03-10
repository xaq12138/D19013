module pcm_FIFO_out(
input					rst_n,
input					clk,

input					data_valid,
input [71:0]		data,		         
input					Fifo_rden_pcm,
input	[31:0]		times,
output				Fifo_empty_pcm,
output				Fifo_q_pcm,
output				busy_out
);

reg					Fifo_ween_pcm;
reg					busy;
reg	[71:0]		data_in;
reg	[7:0]			state;
reg	[15:0]		data_sig;
reg	[31:0]		times_data;


//assign				data_in[511:0]	      =data[511:0];
assign				busy_out					=busy;

always@(posedge clk)
begin
data_in[71:0]	<= data[71:0];
end

always@(posedge clk or posedge rst_n)
begin
if(rst_n)begin
	state <=8'h00;
	Fifo_ween_pcm <=1'b0;
	busy <=1'b0;
	times_data<=32'h00000000;
	end
else begin
	if(times_data<times+1)begin
	case (state)
	8'h00:begin
		Fifo_ween_pcm <=1'b0;
	if(data_valid==1)begin
		state <= state+1'b1;
	    end
	else begin
		state <= state;
	     end
   end
	8'h01:begin
		data_sig[7:0] <= data_in[71:64];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	8'h02:begin
		data_sig[7:0] <= data_in[63:56];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
		end
	8'h03:begin
		data_sig[7:0] <= data_in[55:48];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	8'h04:begin
		data_sig[7:0] <= data_in[47:40];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	8'h05:begin
		data_sig[7:0] <= data_in[39:32];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	8'h06:begin
		data_sig[7:0] <= data_in[31:24];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
		end
	8'h07:begin
		data_sig[7:0] <= data_in[23:16];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	8'h08:begin
		data_sig[7:0] <= data_in[15:8];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
		end
	8'h09:begin
		data_sig[7:0] <= data_in[7:0];
		state <= state+1'b1;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
	  end
	 8'h0A:begin 
		state <= 8'h01;
		Fifo_ween_pcm <=1'b1;
		busy <=1'b1;
		times_data<=times_data+1'b1;
		end	
  endcase
end
	else begin
	busy <=1'b0;
		end
	
end	
end	  
PCM_FIFO	PCM_FIFO_inst (
	.aclr ( 					rst_n ),
	.clock (					clk ),
	.data ( 					data_sig ),   //写入FIFO的数据
	.rdreq (				   Fifo_rden_pcm ), //读操作请求信号
	.wrreq (             Fifo_ween_pcm ),   //高电平时往FIFO中写数
	.empty (             Fifo_empty_pcm ),  //FIFO空标记信号，高电平时表示已空
	.full (                 ),
	.q (                 Fifo_q_pcm ),   //FIFO输出数据
	.usedw (              )   //存储大小
	);
endmodule	
