module		SysRstMod(
								clk,rst,
								SysRst);
								
input							clk,rst;
output reg					SysRst;

reg		[31:0]			RstCnt=32'h0;
always@(posedge clk or posedge rst)
	if(rst)begin
		RstCnt<=32'h0;
		SysRst<=1'b1;
	end
	else if(RstCnt>32'd6_000000)begin
		SysRst<=1'b0;
	end
	else begin
		SysRst<=1'b1;
		RstCnt<=RstCnt+1'b1;
	end
endmodule		