module	SeriesIntegralMod(
input								clk_i,
input								rst_i,
input			[7:0]				IntegralLenSet_i,
input								DaEn_i,
input			[31:0]			Data_i,//signed data 
output reg						IntegralDaEn_o,
output reg	[31:0]			IntegralData_o);//unsigned data 
/***********************************************************
				local wire & reg
***********************************************************/
wire	[7:0]  	Buffusedw;
reg				BuffRd,BuffDaRead,IntegralDaEn;
reg	[1:0]		DaEnShift;
reg	[31:0]	DataHold,IntegralData;
wire	[31:0]	BuffDaOut;
/***********************************************************
				logic
***********************************************************/
//dly for rd buff
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)
		DaEnShift<=2'b00;
	else 
		DaEnShift<={DaEnShift[0],DaEn_i};
//DataHold
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)
		DataHold<=32'h0;
	else if(DaEn_i)
		DataHold<=Data_i;
	else	
		DataHold<=DataHold;
//Integral shift in
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin
		IntegralDaEn<=1'b0;
		IntegralData<=32'h0;
	end
	else if(DaEnShift[1])begin
		IntegralDaEn<=1'b1;
		IntegralData<=BuffDaRead ?IntegralData+DataHold-BuffDaOut : IntegralData+DataHold;
	end
	else begin
		IntegralDaEn<=1'b0;
		IntegralData<=IntegralData;
	end
//IntegralData_o
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)begin
		IntegralDaEn_o<=1'b0;
		IntegralData_o<=32'h0;
	end
	else if(IntegralDaEn && IntegralData[31])begin
		IntegralDaEn_o<=1'b1;
		IntegralData_o<=~IntegralData;
	end
	else if(IntegralDaEn)begin
		IntegralDaEn_o<=1'b1;
		IntegralData_o<=IntegralData;
	end
	else begin
		IntegralDaEn_o<=1'b0;
		IntegralData_o<=IntegralData_o;
	end
//Integral shift out
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)
		BuffRd<=1'b0;
	else if(DaEn_i && (Buffusedw<IntegralLenSet_i))
		BuffRd<=1'b0;
	else if(DaEn_i)
		BuffRd<=1'b1;
	else
		BuffRd<=1'b0;
//BuffDaRead
always@(posedge	clk_i	or posedge	rst_i	)
	if(rst_i)
		BuffDaRead<=1'b0;
	else 
		BuffDaRead<=BuffRd;
/***********************************************************
				mod:IntegralFifo
***********************************************************/

IntegralFifo BUFF(
	.aclr(							rst_i),
	.clock(							clk_i),
	.data(							Data_i),
	.rdreq(							BuffRd),
	.wrreq(							DaEn_i),
	.empty(),
	.full(							Buffusedw[7]),
	.q(								BuffDaOut),
	.usedw(							Buffusedw[6:0]));
endmodule	