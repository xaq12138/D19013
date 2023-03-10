module pll_internet_contro(
input																			Clk,										//时钟60M
input																			Rst,
output																		clk_125M_0deg,
output																		clk_125M_90deg,
output																		clk_25M_0deg,
output																		clk_25M_90deg
//output																		Clk_sys
);

localparam				IDEL										=1'b0;
localparam				WAIT_TIME								=1'b1;

reg																	reset;
reg			[7:0]													cnt;
reg																	state;
reg																	locked_delay1;
wire																	locked;
wire																	locked_neg;
always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		reset															<=1'b0;
		cnt															<=8'd0;
		state															<=IDEL;
	end
	else
	begin
		case (state)
		IDEL:
		begin
			if (locked_neg)
			begin
				reset													<=1'b1;
				cnt													<=cnt + 1'b1;
				state													<=WAIT_TIME;
			end
		end
		WAIT_TIME:
		begin
			if (cnt == 20)
			begin
				cnt													<=8'd0;
				reset													<=1'b0;
				state													<=IDEL;
			end
			else
			begin
				cnt													<=cnt + 1'b1;
			end
		end
		default:
		begin
			state														<=IDEL;
		end
		endcase
	end
end
assign				locked_neg									=~locked & locked_delay1;
always @(posedge Clk or posedge Rst)
begin
	if (Rst)
	begin
		locked_delay1												<=1'b0;
	end
	else
	begin
		locked_delay1												<=locked;
	end
end

pll_internet pll_internet_inst(
	.refclk(															Clk),   //  refclk.clk
	.rst(																Rst | reset),      //   reset.reset
	.outclk_0(														clk_125M_0deg), // outclk0.clk
	.outclk_1(														clk_125M_90deg), // outclk1.clk
	.outclk_2(														clk_25M_0deg), // outclk1.clk
	.outclk_3(														clk_25M_90deg), // outclk1.clk
//	.outclk_4(														Clk_sys),
	.locked(															locked)    //  locked.export
	);

endmodule
