// +FHDR============================================================================/
// Author       : Administrator
// Creat Time   : 2020/04/20 16:09:34
// File Name    : sys_rst_gen.v
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
// sys_rst_gen
//    |---
// 
`timescale 1ns/1ps

module sys_rst_gen #
(
    parameter                       U_DLY = 1                   ,
    parameter                       SIMULATION = "FALSE"
)
(
// ----------------------------------------------------------------------------
// Clock
// ----------------------------------------------------------------------------
    input                           clk_60m                     , 
    input                           clk_sys                     , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    input                           soft_rst_en                 , 
// ----------------------------------------------------------------------------
// MMCM Status
// ----------------------------------------------------------------------------
    input                           pll_locked                  , 
// ----------------------------------------------------------------------------
// Reset Generate
// ----------------------------------------------------------------------------
    output reg                      rst_pll                     , 
    output reg                      rst_n                         
);

localparam    RST_TIME = 32'd624_9999;

reg                          [15:0] rst_step_cnt                ; 

reg                          [31:0] rst_cnt                     ; 

wire                                soft_rst_en_sync            ; 

cb_cross_bus #(
    .U_DLY                          (1                          ), 
    .DAT_WIDTH                      (1                          )  
)
u_cb_cross_bus
( 
//-----------------------------------------------------------------------------------
// Global Sinals 
//-----------------------------------------------------------------------------------     
    .rst_n                          (rst_n                      ), // (input ) Reset, Active low  
    .clk_src                        (clk_60m                    ), // (input ) Reference clock of source clock region 
    .clk_dest                       (clk_sys                    ), // (input ) Reference clock of destination clock region 
//-----------------------------------------------------------------------------------
// Input data & strobe @ source clock region
//-----------------------------------------------------------------------------------
    .dat_src_strb                   (soft_rst_en                ), // Input bus change/enable strobe, one clock pulse
    .dat_src                        (1'b0                       ), // Input bus from source clock region
//-----------------------------------------------------------------------------------
// Output data @ destination clock region
//-----------------------------------------------------------------------------------
    .dat_dest_strb                  (soft_rst_en_sync           ), // Output bus change/enable strobe, one clock pulse
    .dat_dest                       (/* not used */             )  // Output bus   
);

// ============================================================================
// Simulation Initial
// ============================================================================
generate
if(SIMULATION == "TRUE")
begin:sim_init
    initial rst_step_cnt = 16'd0;
    initial rst_pll = 16'd0;
end
else;
endgenerate

// ============================================================================
// Reset Generate
//
// reset timing:
//                                       
//        ___|<--------1000 clock cycle------->|_____________
// rst_n :   |_______________//________________|
// ============================================================================
always @ (posedge clk_sys)
begin
    if(rst_step_cnt < 16'hffff)
        rst_step_cnt <= #U_DLY rst_step_cnt + 16'd1;
    else
        ;
end

always @ (posedge clk_sys)
begin
    if((rst_step_cnt >= 100) && (rst_step_cnt < 16'd1099))
        rst_pll <= #U_DLY 1'b1;
    else
        rst_pll <= #U_DLY 1'b0;
end

// ============================================================================
// Reset Generate
//
// reset timing:
//                                       
//        ___|<-------------100 ms------------->|_____________
// rst_n :   |_______________//_________________|
// ============================================================================
always @ (posedge clk_sys)
begin
    if(pll_locked == 1'b0)
        rst_cnt <= #U_DLY 32'd0;
    else
        begin
            if(soft_rst_en_sync == 1'b1)
                rst_cnt <= #U_DLY 32'd0;
            else if(rst_cnt < RST_TIME)
                rst_cnt <= #U_DLY rst_cnt + 32'd1;
            else
                ;
        end
end

always @ (posedge clk_sys)
begin
    if(rst_cnt < RST_TIME)
        rst_n <= #U_DLY 1'b0;
    else
        rst_n <= #U_DLY 1'b1;
end

endmodule 





