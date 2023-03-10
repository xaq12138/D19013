// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/20 11:47:40
// File Name    : fifo_gen.v
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
// fifo_gen
//    |---
// 
`timescale 1ns/1ns

module fifo_gen #
(
    parameter                       FIFO_MODE = "ST_FIFO"       , // "ST_FIFO" or "FWFT_FIFO"
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
    input                  [DW-1:0] wr_data                     , 
    
    input               [DEPTH-1:0] wr_pcnt                     , 
    output reg                      pfull                       , 
    output reg                      full                        , 
    output reg          [DEPTH-1:0] wr_cnt                      , 
// ----------------------------------------------------------------------------
// Read Prot
// ----------------------------------------------------------------------------
    input                           rd_en                       , 
    output reg             [DW-1:0] rd_data                     , 
    output reg                      valid                       , 

    output reg                      empty                       , 
    output reg          [DEPTH-1:0] rd_cnt                        
);

localparam  U_DLY = 1;
localparam  FIFO_DEPTH = 1<<DEPTH;

reg                        [DW-1:0] fifo_mem [FIFO_DEPTH-1:0]   ; 

reg                       [DEPTH:0] wptr                        /*synthesis noprune */; 
reg                       [DEPTH:0] wptr_reg                    ; 

reg                       [DEPTH:0] rptr                        /*synthesis noprune */; 
reg                       [DEPTH:0] rptr_reg                    ; 

initial
begin
    wptr = 0;
    rptr = 0;
end

// ============================================================================
// Write Data To Memory 
// ============================================================================
always @ (*)
begin
    if(rst_n == 1'b0)
        wptr = {(DEPTH+1){1'b0}};
    else if((wr_en == 1'b1) && (full == 1'b0))
        wptr = wptr_reg + {{(DEPTH){1'b0}},1'b1};
    else
        ;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wptr_reg <= #U_DLY {(DEPTH+1){1'b0}};
    else
        wptr_reg <= #U_DLY wptr;
end

always @ (posedge clk_sys)
begin
    if((wr_en == 1'b1) && (full == 1'b0))
        fifo_mem[wptr_reg[DEPTH-1:0]] <= #U_DLY wr_data;
    else
        ;
end

// ============================================================================
// Read Data From Memory 
// ============================================================================
always @ (*)
begin
    if(rst_n == 1'b0)
        rptr = {(DEPTH+1){1'b0}};
    else if((rd_en == 1'b1) && (empty == 1'b0))
        rptr = rptr_reg + {{(DEPTH){1'b0}},1'b1};
    else
        ;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rptr_reg <= #U_DLY {(DEPTH+1){1'b0}};
    else
        rptr_reg <= #U_DLY rptr;
end

generate
if(FIFO_MODE == "ST_FIFO")
begin:st_fifo

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY {DW{1'b0}};
    else
        begin
            if((rd_en == 1'b1) && (empty == 1'b0))
                rd_data <= #U_DLY fifo_mem[rptr_reg[DEPTH-1:0]];
            else
                ;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        valid <= #U_DLY 1'b0;
    else
        begin
            if((rd_en == 1'b1) && (empty == 1'b0))
                valid <= #U_DLY 1'b1;
            else
                valid <= #U_DLY 1'b0;
        end
end

end
else if(FIFO_MODE == "FWFT_FIFO")
begin:fwft_fifo

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_data <= #U_DLY {DW{1'b0}};
    else
        rd_data <= #U_DLY fifo_mem[rptr[DEPTH-1:0]];
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        valid <= #U_DLY 1'b0;
    else
        begin
            if((wptr - rptr) > {(DEPTH+1){1'b0}})
                valid <= #U_DLY 1'b1;
            else
                valid <= #U_DLY 1'b0;
        end
end

end
endgenerate

// ============================================================================
// Write Status 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        full <= #U_DLY 1'b0;
    else
        begin
            if((wptr[DEPTH-1:0] + {{(DEPTH-1){1'b0}},1'b1}) == rptr[DEPTH-1:0])
                full <= #U_DLY 1'b1;
            else
                full <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wr_cnt <= #U_DLY {DEPTH{1'b0}};
    else
        wr_cnt <= #U_DLY wptr - rptr;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pfull <= #U_DLY 1'b0;
    else
        begin
            if(wr_cnt >= wr_pcnt)
                pfull <= #U_DLY 1'b1;
            else
                pfull <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Read Status 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        empty <= #U_DLY 1'b1;
    else
        begin
            if((rptr[DEPTH] == wptr[DEPTH]) && (rptr[DEPTH-1:0] == wptr[DEPTH-1:0]))
                empty <= #U_DLY 1'b1;
            else
                empty <= #U_DLY 1'b0;

        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rd_cnt <= #U_DLY {DEPTH{1'b0}};
    else
        rd_cnt <= #U_DLY wptr - rptr;
end

endmodule
