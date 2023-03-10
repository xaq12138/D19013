module pcm_nco_out(
input 			clk,
input 			rst_n,
    input                     [7:0] cfg_inst_length             , 
input	[31:0]	mode_sel,//码率

input        tx_en,
input [511:0] tx_data,

output reg	 [15:0]  word_out,

output reg				ws,//字长16
output 					bd,
output 					bs

);


reg[31:0]		f_nco;
//wire[17:0]		fsin_val;
reg [31:0]		fsin_val;
wire[17:0]		fcos_val;
wire				out_valid;
reg[2:0]			clk_nco;
wire				clk_nco_edge;
	
assign 			clk_nco_edge		=clk_nco[2];
	
reg 				bd_reg;
//assign			bd						=bd_reg;

//reg[3:0]			state;

//reg[15:0]		pcm_out_data;
reg[7:0]			pcm_out_data;
reg[5:0]			bd_cnt;
//
reg				bit_out_delay1;
reg				bit_out_pos_delay1;
wire				bit_out_pos;
wire				bit_out_neg;

//localparam     Fifo_q_pcm				=72'hf;

parameter		s_idle				=4'h0,
					s_fifo_start		=4'h1,
					s_fifo_read			=4'h2,
					s_fifo_write		=4'h3,
					s_pcm_out			=4'h4;

//20200815
always @(posedge clk)
begin
	if (SysRst)
	begin
		fsin_val	<= 32'd0;
	end
	else
	begin
		fsin_val	<=fsin_val + mode_sel;		
	end
end					
//					
//PCM_NCO_DATA PCM_NCO_DATA_inst
//			(
//				.phi_inc_i(mode_sel) ,		// input [31:0] phi_inc_i_sig
//				.clk(clk) ,						// input  clk_sig
//				.reset_n(rst_n) ,				// input  reset_n_sig
//				.clken(1'b1) ,					// input  clken_sig
//				.fsin_o(fsin_val) ,			// output [17:0] fsin_o_sig
//				.fcos_o(fcos_val) ,			// output [17:0] fcos_o_sig
//				.out_valid(out_valid) 		// output  out_valid_sig
//			);
						
always@(posedge clk)begin
	clk_nco[0]<=fsin_val[31];
	clk_nco[1]<=clk_nco[0];
	clk_nco[2]<=clk_nco[1] & !clk_nco[0];
//	if(mode_sel)begin
//		f_nco<=32'h015D867C;//clk_sys=60M  PCM_RATE=320k  N=PCM_RATE*2^32/clk_sys//32'h06060606;clk_sys=85M  PCM_RATE=2M  N=PCM_RATE*2^32/clk_sys
//		end
//	else begin
//		f_nco<=32'h015D867C;//32'h06060606;
//		end
		
		
	end

//always@(posedge clk)begin
//	if(!rst_n)begin
//		state<=s_fifo_start;
//		bs<=1'b0;
//		ws<=1'b0;
//		Fifo_rden_pcm<=1'b0;
//		bd_cnt<=5'h00;
//		pcm_out_data<=0;
//		word_out<=0;
//		end
//		
//	else begin
//		case(state)
//		s_fifo_start: begin
//			bs<=1'b0;
//			ws<=1'b0;
//			if(!Fifo_empty_pcm)begin
//				Fifo_rden_pcm<=1'b1;
//				state<=s_fifo_read;
//				end
//			end
//		s_fifo_read:begin
//			Fifo_rden_pcm<=1'b0;
//			state<=s_fifo_write;
//			end
//		s_fifo_write:begin
//			pcm_out_data<=Fifo_q_pcm;
//			word_out<=Fifo_q_pcm;
//			state<=s_pcm_out;
//			end
//		s_pcm_out:begin
//			if(clk_nco_edge)begin
//				if(bd_cnt<7)begin
//					bd_reg<=pcm_out_data[7-bd_cnt];
//					bd_cnt<=bd_cnt+1'b1;
//					bs<=1'b1;
//					end 
//				else begin
//					bd_reg<=pcm_out_data[7-bd_cnt];
//					bd_cnt<=5'h00;
//					bs<=1'b1;
//					ws<=1'b1;
//					state<=s_fifo_start;
//					end
//				end
//			else begin
//				bs<=1'b0;
//				ws<=1'b0;
//				end
//			end
//		endcase
//		end
//	end
//	

wire clk_sys_data;
wire SysRst ;

reg  tx_req;

reg step_en;
reg [15:0] step_cnt;
reg                          [15:0] step_data                   ; 
reg bit_out;

assign clk_sys_data = clk;
assign SysRst = !rst_n;

always @(posedge clk_sys_data)
begin
	if(SysRst == 1'b1)
        step_data <= 16'd0;
    else
        step_data <= {13'd0,cfg_inst_length,3'd0};
end

always @(posedge clk_sys_data)
begin
	if(SysRst == 1'b1)
		tx_req <= 1'b0;
	else
		begin
			if(tx_en == 1'b1)
				tx_req <= 1'b1;
			else if(clk_nco_edge == 1'b1)
				tx_req <= 1'b0;
			else
				;
		end
end
always @(posedge clk_sys_data)
begin
	if(SysRst == 1'b1)
		step_en <= 1'b0;
	else
		begin
			if((tx_req ==1'b1) && (clk_nco_edge == 1'b1))
				step_en <= 1'b1;
			else if((step_cnt == step_data - 'd1) && (clk_nco_edge == 1'b1))
				step_en <= 1'b0;
			else
				;
		end
end	
	
always @(posedge clk_sys_data)
begin
	if(SysRst == 1'b1)
		step_cnt <= 0;
	else
		begin
			if(step_en == 1'b1)
				begin
					if(clk_nco_edge == 1'b1)
						step_cnt <= step_cnt + 1;
					else
						;
				end
			else
				step_cnt <= 0;
				
		end
end	
	
always @(posedge clk_sys_data)
begin
	if(SysRst == 1'b1)
		bit_out <= 'b0;
	else
		begin
			if((step_en == 1'b1)&&(step_cnt <= step_data - 'd1))
				bit_out <= tx_data[511-step_cnt];
			else
				bit_out <= 'b0;
		end
end

//20200814
assign	bit_out_pos				=bit_out & ~bit_out_delay1;
assign	bit_out_neg				=~bit_out & bit_out_delay1;
//assign	bs							=bit_out_pos_delay1 | bit_out_neg;
always @(posedge clk_sys_data)
begin
	if (SysRst == 1'b1)
	begin
		bit_out_delay1	<=1'b0;
		bit_out_pos_delay1<=1'b0;
	end
	else
	begin
		bit_out_delay1	<=bit_out;
		bit_out_pos_delay1<=bit_out_pos;
	end
end	
	
assign			bd						=bit_out;
assign			bs						=fsin_val[31];
	
endmodule

