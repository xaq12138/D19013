//ʱ������
`timescale 1ns/1ps

module  time_code_combination(
input												sclk,
input												rst_n,
//----------------------------------
input	 		[31:0]											TimerBSecondCnt_o,
input			[31:0]											TimerBNanosecondCnt_o,
input		  														TimerBNanosecondCnt_sample_o,	//	
//---------------------------------
output 																w_en,
output		[63:0]											w_data
);
reg 															TimerBNanosecondCnt_sample_o_buffer;
//--------------
always@(posedge sclk or negedge rst_n)
begin
	if(rst_n==1'b0)
		TimerBNanosecondCnt_sample_o_buffer<=1'b0;
	else
		TimerBNanosecondCnt_sample_o_buffer<=TimerBNanosecondCnt_sample_o;
end
//-------------

assign w_en=TimerBNanosecondCnt_sample_o_buffer ^ TimerBNanosecondCnt_sample_o;
assign w_data={TimerBSecondCnt_o,TimerBNanosecondCnt_o};
endmodule




