// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 10:50:14
// File Name    : sim_cfg_mem.v
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
// sim_cfg_mem
//    |---
// 
`timescale 1ns/1ps

module sim_cfg_mem #
(
    parameter                   U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    input                           mem_rd_en                   , 
    input                    [15:0] mem_rd_addr                 , 
    
    output reg               [31:0] mem_rd_data                 , 
    output reg                      mem_rd_data_valid             
);

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_data <= #U_DLY 32'd0;
    else
        mem_rd_data <= #U_DLY {mem_rd_addr,mem_rd_addr};
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_data_valid <= #U_DLY 1'b0;
    else 
        begin
            if(mem_rd_en == 1'b1)
                mem_rd_data_valid <= #U_DLY 1'b1;
            else
                mem_rd_data_valid <= #U_DLY 1'b0;
        end
end

endmodule


