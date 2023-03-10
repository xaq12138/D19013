module framer_ankong (
input clk_sys,
input rst_n,
input bs,
input bd,
input [15:0]fram_h,
input [15:0]fram_lth,
output reg ws,
output reg [7:0]byte_out,
output reg fram_lock,
output reg fram_over,
output reg [15:0]f_cont,
output reg f_cont_lock
);
reg [2:0]bs_reg;
reg [1:0]ws_delay;
wire bs_posegde;
assign bs_posegde=bs_reg[2];
always @(posedge clk_sys)
begin 
bs_reg[0]<=bs;
bs_reg[1]<=bs_reg[0];
bs_reg[2]<=!bs_reg[1] & bs_reg[0];//bs posedge
ws_delay[1]<=ws_delay[0];
ws<=ws_delay[1];
end 
reg [3:0]state;
reg [3:0]cnt_bit;
reg [15:0]cnt_byte;
reg [15:0]bd_shift;
reg [7:0] fm;


//reg [15:0]fram_h;
//reg [15:0]fram_lth;

always @(posedge clk_sys or negedge rst_n)
begin 
if(!rst_n)begin
	state<=4'h0;
	f_cont_lock<=0;
	fram_lock<=0;
	fram_over<=0;
//	fram_h<=16'heb90;
//	fram_lth<=16'h0007;
	end
else begin
case (state)
4'h0: begin
		f_cont_lock<=0;
		fram_over<=0;
		if(bs_posegde)
			begin 
			bd_shift[15:0]<={bd_shift[14:0],bd};
			state<=4'h1;
			cnt_bit<=cnt_bit+1'b1;
			ws_delay[0]<=1'b0;
			end 
		else 
			begin 
			state<=4'h0;
			ws_delay[0]<=1'b0;
			end 
		end 
4'h1: begin 
		if(bd_shift[15:0]==fram_h[15:0])
			begin 
			ws_delay[0]<=1'b1;
			byte_out[7:0]<=bd_shift[15:8];
			cnt_byte<=0;
			cnt_bit<=0;
			fram_lock<=1'b1;
			state<=4'h2;
			fm<=8'h00;
			end 
		else if(bd_shift[15:0]==~fram_h[15:0])
			begin 
			ws_delay[0]<=1'b1;
			byte_out[7:0]<=~bd_shift[15:8];
			cnt_byte<=0;
			cnt_bit<=0;
			fram_lock<=1'b1;
			state<=4'h2;
			fm<=8'hff;
			end 
		else 
			begin 
			if(cnt_bit==8)
				begin 
				cnt_bit<=0;
//				ws_delay[0]<=1'b1;
//				byte_out[7:0]<=bd_shift[15:8] ^ fm[7:0];
				state<=4'h0;
				fram_lock<=1'b0;
				end 
			else 
				begin 
				ws_delay[0]<=1'b0;
				state<=4'h0;
				end 
			end 
		end 
4'h2: begin
		f_cont_lock<=0;
		ws_delay[0]<=1'b0; 
		if(bs_posegde)
			begin 
			bd_shift[15:0]<={bd_shift[14:0],bd};
			state<=4'h3;
			cnt_bit<=cnt_bit+1'b1;
			end 
		else 
			begin 
			state<=4'h2;
			end 
		end 
4'h3:	begin 
		if(cnt_bit==8)
			begin 
			cnt_bit<=0;
			ws_delay[0]<=1'b1;
			byte_out[7:0]<=bd_shift[15:8] ^ fm;
			cnt_byte<=cnt_byte+1'b1;
			state<=4'h4;
			end 
		else 
			begin
			ws_delay[0]<=1'b0; 
			state<=4'h2;
			end 
		end 
4'h4: begin 
		ws_delay[0]<=1'b0;
		if(cnt_byte<fram_lth)
			begin 
			if(cnt_byte==2)begin
				f_cont[15:8]<=byte_out[7:0];
				end
			else if(cnt_byte==3)begin
				f_cont[7:0]<=byte_out[7:0];
				f_cont_lock<=1; 
				end
			else begin
				f_cont[15:0]<=f_cont[15:0];
				end
			state<=4'h2;
			end 
		else 
			begin 
			fram_over<=1; 
			state<=4'h0;
			cnt_byte<=0;
			end 
		end 
default: state<=4'h0;		
endcase
end
end 

endmodule 