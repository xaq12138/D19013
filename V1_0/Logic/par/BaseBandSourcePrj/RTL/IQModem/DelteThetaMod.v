module	DelteThetaMod(
	input						clk_i,rst_i,
	input						clkEn_i,
	input		[11:0]		ThetaIn_i,
	output reg	[11:0]	DelteThetaS_o);//signed
/***********************************************************
				wire & reg
***********************************************************/
reg			[11:0]		PreTheta,ThetaHold1,ThetaHold2,ThetaHold3;
reg			[11:0]		ThetaHold4,ThetaHold5,ThetaHold6;
/***********************************************************
				logic
***********************************************************/
//PreTheta
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)begin
		PreTheta<=12'h0;
	end
	else if(clkEn_i)begin
		PreTheta<=ThetaHold6;
		ThetaHold6<=ThetaHold5;
		ThetaHold5<=ThetaHold4;
		ThetaHold4<=ThetaHold3;
		ThetaHold3<=ThetaHold2;
		ThetaHold2<=ThetaHold1;
		ThetaHold1<=ThetaIn_i;
	end
	else begin
		PreTheta<=PreTheta;
	end
//DelteThetaS_o   DelteThetaS=(ThetaIn_i-PreTheta)/2
always@(posedge	clk_i or posedge	rst_i)
	if(rst_i)begin
		DelteThetaS_o<=12'h0;
	end
	else if(clkEn_i)begin
//		if(PreTheta[11:10]==2'b11 && ThetaIn_i[11:10]==2'b00)//quadrant 4 ->quadrant 1
//			DelteThetaS_o<=12'd4095-PreTheta[11:0]+ThetaIn_i[11:0];
//		else if(PreTheta[11:10]==2'b00 && ThetaIn_i[11:10]==2'b11)//quadrant 1 ->quadrant 4
//			DelteThetaS_o<=12'd4095-PreTheta[11:0]+ThetaIn_i[11:0];
//		else 
			DelteThetaS_o<={ThetaIn_i[11:0]}-{ThetaHold5[11:0]};
	end
endmodule	