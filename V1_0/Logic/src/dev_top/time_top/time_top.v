`timescale 1ns/1ps

module time_top(
input																	sclk,
    input                           clk_125M                    , 
input 																rst_n,
input																	IrigbIn,
    input                           rm_time_valid               , 
    input                    [31:0] rm_time                     , 
output																pps_b_syno,
output  		[63:0]										TimerBSecond_ov
);
wire  	[31:0]						                     TimerBSecondCnt_o;
wire 		[31:0]						                 TimerBNanosecondCnt_o;
wire 	  									          TimerBNanosecondCnt_sample_o;		
wire  										                                  w_en;
wire  	[63:0]						                                w_data;
wire    									                            fifo_empty;
wire    [63:0]						                             fifo_data;
wire    									                            fifo_rd_en;
//wire           												rst_n;
wire 	[8:0]															rdusedw_sig;																										
//assign fifo_empty=~w_en;
////-----------------
//PLL125M  pll125m (
//.refclk(sclk),   //  refclk.clk
//.rst(~rst_n),      //   reset.reset
//.outclk_0(clk_125M)  // outclk0.clk
//	);
//--------------
//reset_n  reset_n_inst(
//.sclk(sclk),
//.rst_n(rst_n)
//);                                                                              
//----------
wire                                rm_time_valid_sync          ; 
wire                         [31:0] rm_time_sync                ; 

wire                                IrigbIn_filter              ; 

cb_cross_bus #
(
    .U_DLY                          (1                          ), 
    .DAT_WIDTH                      (32                         )  
)
u_cb_cross_bus
( 
//-----------------------------------------------------------------------------------
// Global Sinals 
//-----------------------------------------------------------------------------------     
    .rst_n                          (rst_n                      ), // (input ) Reset, Active low  
    .clk_src                        (sclk                       ), // (input ) Reference clock of source clock region 
    .clk_dest                       (clk_125M                   ), // (input ) Reference clock of destination clock region 
//-----------------------------------------------------------------------------------
// Input data & strobe @ source clock region
//-----------------------------------------------------------------------------------
    .dat_src_strb                   (rm_time_valid              ), // Input bus change/enable strobe, one clock pulse
    .dat_src                        (rm_time[31:0]              ), // Input bus from source clock region
//-----------------------------------------------------------------------------------
// Output data @ destination clock region
//-----------------------------------------------------------------------------------
    .dat_dest_strb                  (rm_time_valid_sync         ), // Output bus change/enable strobe, one clock pulse
    .dat_dest                       (rm_time_sync[31:0]         )  // Output bus   
);


 cb_line_filter #
(
    .U_DLY                          (1                          )  
)    
u_cb_line_filter
( 
//-----------------------------------------------------------------------------------
// Golbal Signals
//-----------------------------------------------------------------------------------
    .clk_sys                        (clk_125M                   ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------------
// filter paramter
//-----------------------------------------------------------------------------------
    .filter_cnt                     (32'd11                     ), // (input )
//-----------------------------------------------------------------------------------
// line signal
//-----------------------------------------------------------------------------------
    .sig_in                         (IrigbIn                    ), // (input )
    .sig_out                        (IrigbIn_filter             )  // (output)
);

IRIGBRxMod_contrl   IRIGBRxMod_contrl_inst(
.clk																	(clk_125M)												      ,
.rst																	(~rst_n)											      ,
.IrigbIn															(IrigbIn_filter)											      ,
    .rm_time_valid                  (rm_time_valid_sync         ), // (input )
    .rm_time                        (rm_time_sync[31:0]         ), // (input )
.pps_b_syno														(pps_b_syno	)									      ,
.TimerBSecondCnt_o										(TimerBSecondCnt_o)						      ,
.TimerBNanosecondCnt_o								(TimerBNanosecondCnt_o)				      ,
.TimerBNanosecondCnt_sample_o			    (TimerBNanosecondCnt_sample_o)
);
//-------------------
time_code_combination  time_code_combination_inst(
.sclk																(clk_125M)													       ,
.rst_n															(rst_n)													       ,
.TimerBSecondCnt_o									(TimerBSecondCnt_o)							       ,
.TimerBNanosecondCnt_o							(TimerBNanosecondCnt_o)					       ,
.TimerBNanosecondCnt_sample_o	      (TimerBNanosecondCnt_sample_o)         ,
.w_en																(w_en)													       ,
.w_data                             (w_data)
);
//-----------
FIFO_512X8	FIFO_512X8_inst (
	.data ( w_data ),
	.rdclk (sclk ),
	.rdreq ( ~fifo_empty),
	.wrclk ( clk_125M),
	.wrreq ( w_en ),
	.q ( fifo_data ),
	.rdempty ( fifo_empty ),
	.rdusedw ( rdusedw_sig )
	);


//-------
time_ok_out   time_ok_out_inst(
.sclk													(sclk)						        ,
.rst_n												(rst_n)						        ,
.fifo_empty										(fifo_empty)			        ,
.fifo_data										(fifo_data)				        ,
//.w_en												(w_en)							,
//.fifo_rd_en										(fifo_rd_en)			        ,
.TimerBSecond_ov              (TimerBSecond_ov)
);
endmodule
