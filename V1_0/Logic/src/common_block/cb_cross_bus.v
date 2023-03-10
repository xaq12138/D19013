// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/28 11:39:59
// File Name    : cb_cross_bus.v
// Module Ver   : Vx.x
//
//
// All Rights Reserved
//
// ---------------------------------------------------------------------------------/
//
// Modification History:
// V1.0         initial
//
// -FHDR============================================================================/
// 
// cb_cross_bus
//    |---
// 
`timescale 1ns/1ps


module cb_cross_bus #(
    parameter U_DLY     = 1     ,
    parameter DAT_WIDTH = 32
)
( 
//-----------------------------------------------------------------------------------
// Global Sinals 
//-----------------------------------------------------------------------------------     
    input                         rst_n                   ,   // Reset, Active low  
    input                         clk_src                 ,   // Reference clock of source clock region 
    input                         clk_dest                ,   // Reference clock of destination clock region 
//-----------------------------------------------------------------------------------
// Input data & strobe @ source clock region
//-----------------------------------------------------------------------------------
    input                         dat_src_strb            ,   // Input bus change/enable strobe, one clock pulse
    input      [DAT_WIDTH-1:0]    dat_src                 ,   // Input bus from source clock region
//-----------------------------------------------------------------------------------
// Output data @ destination clock region
//-----------------------------------------------------------------------------------
    output reg                    dat_dest_strb           ,   // Output bus change/enable strobe, one clock pulse
    output reg [DAT_WIDTH-1:0]    dat_dest                    // Output bus   
);

//***********************************************************************************
// Internal Register & Wire Define
//***********************************************************************************
reg                                                       strb_adj                    ; 
(*ASYNC_REG = "true"*)reg                                 strb_adj_s2d_1dly           ; 
(*ASYNC_REG = "true"*)reg                                 strb_adj_s2d_2dly           ; 
reg                                                       strb_adj_s2d_3dly           ; 
(*ASYNC_REG = "true"*)reg                                 strb_adj_d2s_1dly           ; 
(*ASYNC_REG = "true"*)reg                                 strb_adj_d2s_2dly           ; 
reg                                       [DAT_WIDTH-1:0] dat_src_latch               ; 

//===================================================================================
// clk_src clock domain process
//===================================================================================
always  @(posedge clk_src or negedge rst_n)
begin
    if(rst_n == 1'b0)
        strb_adj <= #U_DLY 1'b0;
    else 
        begin
            if(dat_src_strb == 1'b1)
                strb_adj <= #U_DLY 1'b1;
            else if(strb_adj_d2s_2dly == 1'b1)
                strb_adj <= #U_DLY 1'b0;
            else;
        end
end

always @(posedge clk_src or negedge rst_n)
begin
    if (rst_n == 1'b0)
        dat_src_latch <= {DAT_WIDTH{1'b0}};
    else 
        begin
            if (dat_src_strb == 1'b1)
                dat_src_latch <= #U_DLY dat_src;
            else
                dat_src_latch <= #U_DLY dat_src_latch;
        end
end

always @(posedge clk_src or negedge rst_n)
begin
    if (rst_n == 1'b0)
        begin
            strb_adj_d2s_1dly <= 1'b0; 
            strb_adj_d2s_2dly <= 1'b0; 
        end       
    else
        begin
            strb_adj_d2s_1dly <= #U_DLY strb_adj_s2d_3dly; 
            strb_adj_d2s_2dly <= #U_DLY strb_adj_d2s_1dly;
        end        
end

//===================================================================================
// clk_dest clock domain process
//===================================================================================
always @(posedge clk_dest or negedge rst_n)
begin
    if (rst_n == 1'b0)
        begin
            strb_adj_s2d_1dly <= 1'b0; 
            strb_adj_s2d_2dly <= 1'b0; 
            strb_adj_s2d_3dly <= 1'b0; 
        end       
    else
        begin
            strb_adj_s2d_1dly <= #U_DLY strb_adj; 
            strb_adj_s2d_2dly <= #U_DLY strb_adj_s2d_1dly;
            strb_adj_s2d_3dly <= #U_DLY strb_adj_s2d_2dly;
        end        
end

always @(posedge clk_dest or negedge rst_n)
begin
    if (rst_n == 1'b0)
        dat_dest <= {DAT_WIDTH{1'b0}};
    else 
        begin
            if ((strb_adj_s2d_2dly == 1'b1) && (strb_adj_s2d_3dly == 1'b0)) // rising edge
                dat_dest <= #U_DLY dat_src_latch;
            else
                dat_dest <= #U_DLY dat_dest;
        end
end  

always @(posedge clk_dest or negedge rst_n)
begin
    if (rst_n == 1'b0)
        dat_dest_strb <= 1'b0;
    else 
        begin
            if ((strb_adj_s2d_2dly == 1'b1) && (strb_adj_s2d_3dly == 1'b0)) // rising edge
                dat_dest_strb <= #U_DLY 1'b1;
            else
                dat_dest_strb <= #U_DLY 1'b0;
        end
end  

endmodule
