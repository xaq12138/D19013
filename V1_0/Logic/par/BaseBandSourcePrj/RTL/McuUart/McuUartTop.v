module	McuUartTop(
input 														clk,
input  														rst_n,
output 														CFGADRst_n,
output														CFGADSpiClk_o,
input															CFGADSpiDi_i,
output														CFGADSpiDo_o,
output														CFGADSpiLe_o,
input 														CFGADUartRxd,
output 														CFGADUartTxd,
output			[7:0]										CFGADCtr_o,
						
output	reg	[31:0]									CFGADSourcePcmFreq,
output	reg	[31:0]									CFGADSourceCarrierFreqShift,
output	reg	[31:0]									CFGADSourceCarrierFreq,
output	reg	[31:0]									CFGADSourceState,
output	reg	[31:0]									CFGADRecState,
output	reg	[31:0]									CFGADRecCarrierFreq,
output	reg	[31:0]									CFGADRecFrameCodeH,
output	reg	[31:0]									CFGADRecFrameCodeL,
output	reg	[15:0]									CFGADRecFrameCodeLen,
output	reg	[3:0]										CFGADRecCodeMode,
output	reg	[15:0]									CFGADRecFrameLen,
output	reg	[31:0]									CFGADRecPcmFreq,
output	reg	[2:0]										CFGADMode,
output	reg	[31:0]									CFGIQDataFSoundAvePara,
output	reg												CFGADUpOver);								

/**********************************************************************************
												local wire	
**********************************************************************************/
wire		[31:0]											CFGADData_o; 
wire															CFGADClk;
reg		[1:0]												CFGADClkBuf;
wire		[7:0]												CFGADAddr_o;
wire															CFGADEn;
wire															CFGADRst;
/**********************************************************************************
												assign	
**********************************************************************************/	
assign														CFGADEn		=!CFGADClkBuf[1]&CFGADClkBuf[0];
assign														CFGADRst_n	=~CFGADRst;


/**********************************************************************************/
										
mcu McuSet(
	.clk_0(													clk) ,	
	.reset_n(												rst_n) ,	
	.out_port_from_the_pio_addr(						CFGADAddr_o) ,
	.out_port_from_the_pio_clk(						CFGADClk) ,	
	.out_port_from_the_pio_ctr_out(					CFGADCtr_o) ,
	.out_port_from_the_pio_data(						CFGADData_o) ,
	.out_port_from_the_pio_reset(						CFGADRst) ,
	.out_port_from_the_pio_spi_clk(					CFGADSpiClk_o) ,
	.in_port_to_the_pio_spi_di(						CFGADSpiDi_i) ,	
	.out_port_from_the_pio_spi_do(					CFGADSpiDo_o) ,
	.out_port_from_the_pio_spi_le(					CFGADSpiLe_o) ,
	.rxd_to_the_uart(										CFGADUartRxd) ,	
	.txd_from_the_uart(									CFGADUartTxd), 
	.rxd_to_the_uart_0(									1'B0) ,
	.txd_from_the_uart_0(								));
			

always	@(posedge clk or negedge rst_n)
begin
if(!rst_n)begin
	CFGADClkBuf[1:0]										<=2'B00;
	end			
else begin			
	CFGADClkBuf[0]											<=CFGADClk;
	CFGADClkBuf[1]											<=CFGADClkBuf[0];
	end
end

always	@(posedge clk or negedge rst_n)
begin
if(!rst_n)begin
	CFGADSourcePcmFreq									<=32'h0000_0000;
	CFGADSourceCarrierFreqShift						<=32'h0000_0000;
	CFGADSourceCarrierFreq								<=32'h0000_0000;
	CFGADSourceState										<=32'h0000_0000;
	CFGADRecState											<=32'h0000_0000;
	CFGADRecCarrierFreq									<=32'h0000_0000;
	CFGADRecFrameCodeH									<=32'h0000_0000;
	CFGADRecFrameCodeL									<=32'h0000_0000;
	CFGADRecFrameCodeLen									<=15'h0000;
	CFGADRecCodeMode										<=4'h0;
	CFGADRecFrameLen										<=15'h0000;
	CFGADRecPcmFreq										<=32'h0000_0000;							
	CFGADMode												<=3'b000;
	CFGIQDataFSoundAvePara								<=32'h0000_0000;	
	CFGADUpOver												<=1'b0;
	end
else begin
	if(CFGADEn==1'b1)begin
		if(CFGADAddr_o==8'h00)	
			CFGADSourcePcmFreq							<=CFGADData_o;
		else if(CFGADAddr_o==8'h01)	
			CFGADSourceCarrierFreqShift				<=CFGADData_o;
		else if(CFGADAddr_o==8'h02)	
			CFGADSourceCarrierFreq						<=CFGADData_o;
		else if(CFGADAddr_o==8'h03)	
			CFGADSourceState								<=CFGADData_o;
		else if(CFGADAddr_o==8'h04)	
			CFGADRecState									<=CFGADData_o;
		else if(CFGADAddr_o==8'h05)	
			CFGADRecCarrierFreq							<=CFGADData_o;
		else if(CFGADAddr_o==8'h06)	
			CFGADRecFrameCodeH							<=CFGADData_o;
		else if(CFGADAddr_o==8'h07)			
			CFGADRecFrameCodeL							<=CFGADData_o;
		else if(CFGADAddr_o==8'h08)begin	
			CFGADRecFrameCodeLen							<=CFGADData_o[31:20];
			CFGADRecCodeMode								<=CFGADData_o[19:16];
			CFGADRecFrameLen								<=CFGADData_o[15:0];
			end
		else if(CFGADAddr_o==8'h09)	
			CFGADRecPcmFreq								<=CFGADData_o;
		else if(CFGADAddr_o==8'h0a)begin	
			CFGADMode										<=CFGADData_o[2:0];
			end
		else if(CFGADAddr_o==8'h11)begin	
			CFGIQDataFSoundAvePara						<=CFGADData_o;
			CFGADUpOver										<=1'b1;
			end
		else begin
			CFGADSourcePcmFreq							<=CFGADSourcePcmFreq;
			CFGADSourceCarrierFreqShift				<=CFGADSourceCarrierFreqShift;
			CFGADSourceCarrierFreq						<=CFGADSourceCarrierFreq;
			CFGADSourceState								<=CFGADSourceState;
			CFGADRecState									<=CFGADRecState;
			CFGADRecCarrierFreq							<=CFGADRecCarrierFreq;
			CFGADRecFrameCodeH							<=CFGADRecFrameCodeH;
			CFGADRecFrameCodeL							<=CFGADRecFrameCodeL;
			CFGADRecFrameCodeLen							<=CFGADRecFrameCodeLen;
			CFGADRecCodeMode								<=CFGADRecCodeMode;
			CFGADRecFrameLen								<=CFGADRecFrameLen;
			CFGADRecPcmFreq								<=CFGADRecPcmFreq;							
			CFGADMode										<=CFGADMode;
			CFGIQDataFSoundAvePara						<=CFGIQDataFSoundAvePara;
			CFGADUpOver										<=1'b0;
			end
		end
	else begin
		CFGADSourcePcmFreq								<=CFGADSourcePcmFreq;
		CFGADSourceCarrierFreqShift					<=CFGADSourceCarrierFreqShift;
		CFGADSourceCarrierFreq							<=CFGADSourceCarrierFreq;
		CFGADSourceState									<=CFGADSourceState;
		CFGADRecState										<=CFGADRecState;
		CFGADRecCarrierFreq								<=CFGADRecCarrierFreq;
		CFGADRecFrameCodeH								<=CFGADRecFrameCodeH;
		CFGADRecFrameCodeL								<=CFGADRecFrameCodeL;
		CFGADRecFrameCodeLen								<=CFGADRecFrameCodeLen;
			CFGADRecCodeMode								<=CFGADRecCodeMode;
		CFGADRecFrameLen									<=CFGADRecFrameLen;
		CFGADRecPcmFreq									<=CFGADRecPcmFreq;							
		CFGADMode											<=CFGADMode;
			CFGIQDataFSoundAvePara						<=CFGIQDataFSoundAvePara;
		CFGADUpOver											<=1'b0;
		end
	end
end		
endmodule	