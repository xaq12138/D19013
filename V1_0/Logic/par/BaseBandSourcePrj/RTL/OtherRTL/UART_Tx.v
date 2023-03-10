/************************************************************************
										串口发送模��
数据格式：Start bit + 8Bits Data + Stop bit
*************************************************************************/
module	UART_Tx(
					clk,
					rst,
					Ready,
					LoadData,
					DataIn,
					UartTx);
//IOs
input				clk,rst;
output			Ready;
input				LoadData;
input	[7:0]		DataIn;
output			UartTx;

reg				Ready,next_Ready;
//parameters
parameter		CntWide			=		14;//RateDelay 位宽
parameter		RateDelay		=  	259;//1562;//clk/DataRate -1    时钟/波特��- 1-485：230400/972:115200/2916:38400
// local wire & reg
reg		[2:0]		state=3'b000;
reg      [2:0]		next_state;
//wire 		[2:0]		state_m;
reg		[CntWide-1:0]		DelayCnt,next_DelayCnt;
reg		[9:0]		DataReg,next_DataReg;
reg		[3:0]		BitCnt,next_BitCnt;
//define
`define			UARTINIT			3'H0
`define			WTDATA			3'H1
`define			WTDELAY			3'H2
`define			SHIFTDATA		3'H3
//
assign				UartTx=DataReg[0];
always@(*)begin
	next_Ready=Ready;
	next_DelayCnt=DelayCnt;
	next_DataReg=DataReg;
	next_BitCnt=BitCnt;
	next_state=state;
	case(state)
		`UARTINIT:begin
			next_DataReg=10'h3ff;
			next_state=`WTDATA;
		end
		`WTDATA:begin
			next_Ready=1'b1;
			if(LoadData==1'b1)begin
				next_Ready=1'b0;
				next_DataReg={1'b1,DataIn,1'b0};
				next_DelayCnt=13'h0;
				next_state=`WTDELAY;
			end
		end
		`WTDELAY:
			if(DelayCnt==RateDelay && BitCnt==9)begin
				next_DelayCnt=13'h0;
				next_BitCnt=4'h0;
				next_Ready=1'b1;
				next_state=`WTDATA;
			end
			else if(DelayCnt==RateDelay )begin
				next_DelayCnt=13'h0;
				next_DataReg={1'b1,DataReg[9:1]};
				next_BitCnt=BitCnt+1'b1;
				next_state=`WTDELAY;
			end
			else 
				next_DelayCnt=DelayCnt+1'b1;
		default:
			next_state=`UARTINIT;
	endcase
end

always@(posedge clk or posedge rst)
	if(rst==1'b1)
		state<=`UARTINIT;
	else 
		state<=next_state;
		
always@(posedge clk or posedge rst)
	if(rst==1'b1)begin
		Ready<=1'b0;
		DelayCnt<=0;;
		DataReg<=10'h3ff;
		BitCnt<=0;;
	end
	else begin
		Ready<=next_Ready;
		DelayCnt<=next_DelayCnt;
		DataReg<=next_DataReg;
		BitCnt<=next_BitCnt;
	end
endmodule	