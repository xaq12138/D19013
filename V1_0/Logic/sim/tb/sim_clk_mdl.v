// +FHDR============================================================================/
// Author       : Administrator
// Creat Time   : 2020/04/22 09:41:37
// File Name    : sim_clk_mdl.v
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
// sim_clk_mdl
//    |---
// 
`timescale 1ns/1ps

module sim_clk_mdl #
(
    parameter                       CLK_PERIOD = 10 
)
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    output reg                      clk_p                       , 
    output                          clk_n                         
);

initial clk_p = 0;

always #(CLK_PERIOD/2) clk_p = ~clk_p;

assign clk_n = ~clk_p;

endmodule


