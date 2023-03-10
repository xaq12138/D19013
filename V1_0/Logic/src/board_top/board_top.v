// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 17:55:32
// File Name    : board_top.v
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
// board_top
//    |---
// 
`timescale 1ns/1ps

module board_top #
(
    parameter                       U_DLY = 1                   ,
    parameter                       SIMULATION = "FALSE"
)
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    input                           soft_rst_en                 , 
// ----------------------------------------------------------------------------
// Clock & Reset Generate
// ----------------------------------------------------------------------------
    output                          clk_60m                     , 
    output                          clk_125m                    ,
    output                          clk_100m                    , 
    output                          rst_n                         
);

wire                                rst_pll                     ; 
wire                                pll_locked                  ; 

/*sys_clk_gen u_sys_clk_gen
(
    .refclk                         (clk_sys                    ), // (input )  refclk.clk
    .rst                            (rst_pll                    ), // (input )   reset.reset
    .outclk_0                       (clk_125m                   ), // (output) outclk0.clk
    .outclk_1                       (clk_60m                    ), // (output) outclk0.clk
    .locked                         (pll_locked                 )  // (output)  locked.export
);*/
 sys_clk60m_gen  u_sys_clk60m 
 (
    .refclk                         (clk_sys                    ), // (input )  refclk.clk
    .rst                            (rst_pll                    ), // (input )   reset.reset
    .outclk_0                       (clk_60m                    )  // (output) outclk0.clk
);
 sys_clk125m_gen   u_sys_clk125m 
 (

    .refclk                         (clk_sys                    ), // (input )  refclk.clk
    .rst                            (rst_pll                    ), // (input )   reset.reset
    .outclk_0                       (clk_125m                   ), // (output) outclk0.clk
    .outclk_1                       (clk_100m                   ), // (output) outclk0.clk
    .locked                         (pll_locked                 )  // (output)  locked.export
);

sys_rst_gen #
(
    .U_DLY                          (U_DLY                      ), 
    .SIMULATION                     (SIMULATION                 )  
)
u_sys_rst_gen
(
// ----------------------------------------------------------------------------
// Clock
// ----------------------------------------------------------------------------
    .clk_60m                        (clk_60m                    ), // (input )
    .clk_sys                        (clk_sys                    ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .soft_rst_en                    (soft_rst_en                ), // (input )
// ----------------------------------------------------------------------------
// MMCM Status
// ----------------------------------------------------------------------------
    .pll_locked                     (pll_locked                 ), // (input )
// ----------------------------------------------------------------------------
// Reset Generate
// ----------------------------------------------------------------------------
    .rst_pll                        (rst_pll                    ), // (output)
    .rst_n                          (rst_n                      )  // (output)
);

endmodule




