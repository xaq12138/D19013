module Internet_rx_byte(
input																		Clk,										//时钟60M
input																		Rst,										//高复位
    input                    [15:0] cfg_udp_dstport             , 
input			 	[15:0]												udp_rec_dst_port,						//目的地端口
input				[31:0]												udp_rec_data,							//32位数据
input																		udp_rec_data_en,						//数据有效
input				[15:0]												udp_rec_data_len,						//长度，字节数
output	reg															udp_rec_valid,							//数据有效
output			[7:0]													udp_rec_byte							//按字节输出的网口数据
);
/*********************************************************parameter*********************************************/

/*********************************************************reg***************************************************/
reg																		rdreq;
reg				[15:0]												cnt;
reg				[15:0]												udp_rec_data_len_buff;
reg																		udp_rec_data_en_delay1;
/*********************************************************wire**************************************************/
wire																		rdempty;
wire																		udp_rec_data_en_pos;
wire																		udp_rec_data_en_net;
wire				[31:0]												udp_rec_data_buff;

assign			udp_rec_data_en_net								=(udp_rec_dst_port == cfg_udp_dstport)?udp_rec_data_en:1'b0;
assign			udp_rec_data_buff[7:0]							=udp_rec_data[31:24];
assign			udp_rec_data_buff[15:8]							=udp_rec_data[23:16];
assign			udp_rec_data_buff[23:16]						=udp_rec_data[15:8];
assign			udp_rec_data_buff[31:24]						=udp_rec_data[7:0];

assign			udp_rec_data_en_pos								=udp_rec_data_en_net & ~udp_rec_data_en_delay1;
always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		udp_rec_data_len_buff										<=16'd0;
		udp_rec_data_en_delay1										<=1'b0;
	end
	else
	begin
		if (udp_rec_data_en_pos)
		begin
			udp_rec_data_len_buff									<=udp_rec_data_len;
		end
		udp_rec_data_en_delay1										<=udp_rec_data_en_net;
	end
end

always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		udp_rec_valid													<=1'b0;
	end
	else
	begin
		if (rdreq == 1'b1 && cnt == 16'd0)
		begin
			udp_rec_valid												<=1'b1;
		end
		else if (rdreq == 1'b1 && cnt == udp_rec_data_len_buff)
		begin
			udp_rec_valid												<=1'b0;
		end
	end
end
always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		cnt																<=16'd0;
	end
	else
	begin
		if (rdreq)
		begin
			cnt															<=cnt + 1'b1;
		end
		else
		begin
			cnt															<=16'd0;
		end
	end
end
always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		rdreq																<=1'b0;
	end
	else
	begin
		if (~rdempty)
		begin
			rdreq															<=1'b1;
		end
		else
		begin
			rdreq															<=1'b0;
		end
	end
end
//128字节缓存空间，缓存命令
Udp_fifo_32_8 Udp_fifo_32_8_inst(
	.data(																udp_rec_data_buff),
	.rdclk(																Clk),
	.rdreq(																rdreq),
	.wrclk(																Clk),
	.wrreq(																udp_rec_data_en_net),
	.q(																	udp_rec_byte),
	.rdempty(															rdempty),
	.wrfull(																)
);

endmodule
