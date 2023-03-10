module monitor_rx_ctrl(
input											sclk,
input											rst_n,
input											fifo_empty,
input						[7:0]			fifo_data,
output		reg							fifo_rd_en,
output		reg		[95:0]		data_ov			
);

localparam 					idle				=3'd0;				
localparam					header 			=3'd1;	
localparam 					data_header		=3'd2;
localparam					data				=3'd3;
localparam					data_tail		=3'd4;
localparam					check				=3'd5;
//
reg 	[2:0]				state;
parameter 				DA_WID=136;
reg			[DA_WID-1:0]			data_reg;//
wire 		[7:0]							check_flag;
reg										over_flag;
reg     [15:0]						 data_hd_buffer;
reg 										end_flag;
reg     [7:0]							byte_cnt;
//
always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		fifo_rd_en<=1'b0;
	else if(fifo_empty==1'b0 && over_flag==1'b0 )
		fifo_rd_en<=1'b1;
	else
		fifo_rd_en<=1'b0;
end
//
always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		byte_cnt<=8'h0;
	else if(byte_cnt==8'h11)
		byte_cnt<=8'h0;
	else if(fifo_rd_en==1'b1 && state==data)
		byte_cnt<=byte_cnt+1'b1;
	else
		;
end
//
assign check_flag= data_reg[39:24] + data_reg[55:40] + data_reg[71:56] + data_reg[87:72] + data_reg[103:88] +data_reg[119:104] + data_reg[135:120];



always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
	begin
		state<=idle;
		data_hd_buffer<=16'd0;
		data_reg<='d0;
		data_ov<='d0;
		end_flag<=1'b0;
	end
	else begin
	case(state)
		idle: begin
					state<=header;
					over_flag<=1'b0;
				end
		header:begin
		if(fifo_rd_en==1'b1)
		begin
						data_hd_buffer<={data_hd_buffer[7:0],fifo_data};
						state<=data_header;
		end
					else
						state<=idle;
				 end
		data_header: begin
		if(data_hd_buffer==16'h0ff0)
		begin
										data_hd_buffer<=16'h0;
										state<=data;
		end
									else
										state<=header;
						 end
		data: begin
		if(fifo_rd_en==1'b1)
		begin
						data_reg<={data_reg[127:0],fifo_data};
						state<=data_tail;
		end
					else 
						state<=data;
				end
		data_tail:begin
		if(data_reg[15:0]==16'hEB90)
		begin
									over_flag<=1'b1;
									state<=check;
		end
								else 
		begin
									state<=data;
									over_flag<=1'b0;
		end
					end
		check: begin
		if(data_reg[23:16]==check_flag)
		begin
						data_ov<=data_reg[119:24];
						state<=idle;
						end_flag<=1'b1;
						
		end
		else
		begin
						data_ov<='d0;
						end_flag<=1'b1;
						state<=idle;
		end
				 end
		default: state<=idle;
		endcase											
	end
end
endmodule

