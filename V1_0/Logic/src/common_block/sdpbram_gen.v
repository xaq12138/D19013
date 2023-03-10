// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/20 11:59:38
// File Name    : sdpbram_gen.v
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
// sdpbram_gen
//    |---
// 
`timescale 1ns/1ns

module sdpbram_gen #
(
    parameter                       U_DLY = 1                   ,
    parameter                       DW = 16                     ,
    parameter                       DEPTH = 10               
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Write Prot
// ----------------------------------------------------------------------------
    input                           wr_en                       , 
    input               [DEPTH-1:0] wr_addr                     , 
    input                  [DW-1:0] wr_data                     , 
// ----------------------------------------------------------------------------
// Write Prot
// ----------------------------------------------------------------------------
    input                           rd_en                       , 
    input               [DEPTH-1:0] rd_addr                     , 
    output reg             [DW-1:0] rd_data                       
);

localparam  MEM_DEPTH = 1<<DEPTH;

reg                        [DW-1:0] bram_mem [MEM_DEPTH-1:0]        ; 

// ============================================================================
// Write Data To Memory 
// ============================================================================
always @ (posedge clk_sys)
    if(wr_en == 1'b1)
        bram_mem[wr_addr] <= #U_DLY wr_data;
    else
        ;
// ============================================================================
// Read Data From Memory 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY {DW{1'b0}};
    else
        begin
            if(rd_en == 1'b1)
                rd_data <= #U_DLY bram_mem[rd_addr];
            else
                ;
        end
end

endmodule 




